Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB586272150
	for <lists+kvm@lfdr.de>; Mon, 21 Sep 2020 12:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726513AbgIUKiS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Sep 2020 06:38:18 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:24161 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726436AbgIUKiS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Sep 2020 06:38:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600684697;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=k37fRmP6IslqoM8RNLxcb8OzcjtWZpkq3yLymvakBU4=;
        b=AueoSnjJkfxW7RSb0Z5Hyb1MxvQTgtSHZt5IAWWE7T4OJHOeWVa5CjQTaRFTOhg6DNYqXz
        gI/N6uzv0ZRG7C/brcvbJBNvm5ZnfHWIPWE0NR48mqCvhMROgiRvNMTXmmg8koV/lSR5I1
        rA5JCKVdjyJ+/TE7YOGistZ19H8pJkE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-395-YFqMEzMEPRqvidZyzhPt7g-1; Mon, 21 Sep 2020 06:38:15 -0400
X-MC-Unique: YFqMEzMEPRqvidZyzhPt7g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 40029801AC3;
        Mon, 21 Sep 2020 10:38:13 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.238])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7513E68D64;
        Mon, 21 Sep 2020 10:38:06 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Ingo Molnar <mingo@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Joerg Roedel <joro@8bytes.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v2 0/1] KVM: correctly restore the TSC value on nested migration
Date:   Mon, 21 Sep 2020 13:38:04 +0300
Message-Id: <20200921103805.9102-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch is a result of a long investigation I made to understand=0D
why the nested migration more often than not makes the nested guest hang.=0D
Sometimes the nested guest recovers and sometimes it hangs forever.=0D
=0D
The root cause of this is that reading MSR_IA32_TSC while nested guest is=0D
running returns its TSC value, that is (assuming no tsc scaling)=0D
host tsc + L1 tsc offset + L2 tsc offset.=0D
=0D
This is correct but it is a result of a nice curiosity of X86 VMX=0D
(and apparently SVM too, according to my tests) implementation:=0D
=0D
As a rule MSR reads done by the guest should either trap to host, or just=0D
return host value, and therefore kvm_get_msr and friends, should basically=
=0D
always return the L1 value of any msr.=0D
=0D
Well, MSR_IA32_TSC is an exception. Intel's PRM states that when you disabl=
e=0D
its interception, then in guest mode the host adds the TSC offset to=0D
the read value.=0D
=0D
I haven't found anything like that in AMD's PRM but according to the few=0D
tests I made, it behaves the same.=0D
=0D
However, there is no such exception when writing MSR_IA32_TSC, and this=0D
poses a problem for nested migration.=0D
=0D
When MSR_IA32_TSC is read, we read L2 value (smaller since L2 is started=0D
after L1), and when we restore it after migration, the value is interpreted=
=0D
as L1 value, thus resulting in huge TSC jump backward which the guest usual=
ly=0D
really doesn't like, especially on AMD with APIC deadline timer, which=0D
usually just doesn't fire afterward sending the guest into endless wait for=
 it.=0D
=0D
The proposed patch fixes this by making read of MSR_IA32_TSC depend on=0D
'msr_info->host_initiated'=0D
=0D
If guest reads the MSR, we add the TSC offset, but when host's qemu reads=0D
the msr we skip that silly emulation of TSC offset, and return the real val=
ue=0D
for the L1 guest which is host tsc + L1 offset.=0D
=0D
This patch was tested on both SVM and VMX, and on both it fixes hangs.=0D
On VMX since it uses VMX preemption timer for APIC deadline, the guest seem=
s=0D
to recover after a while without that patch.=0D
=0D
To make sure that the nested migration happens I usually used=0D
-overcommit cpu_pm=3Don but I reproduced this with just running an endless =
loop=0D
in L2.=0D
=0D
This is tested both with and without -invtsc,tsc-frequency=3D...=0D
=0D
The migration was done by saving the migration stream to a file, and then=0D
loading the qemu with '-incoming'=0D
=0D
V2: incorporated feedback from Sean Christopherson (thanks!)=0D
=0D
Maxim Levitsky (1):=0D
  KVM: x86: fix MSR_IA32_TSC read for nested migration=0D
=0D
 arch/x86/kvm/x86.c | 16 ++++++++++++++--=0D
 1 file changed, 14 insertions(+), 2 deletions(-)=0D
=0D
-- =0D
2.26.2=0D
=0D

