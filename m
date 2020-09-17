Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB8AE26D9DC
	for <lists+kvm@lfdr.de>; Thu, 17 Sep 2020 13:08:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726651AbgIQLIR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Sep 2020 07:08:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:59548 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726625AbgIQLHm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 17 Sep 2020 07:07:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600340852;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=kkPhCJgbEfe1snOxUIcIHLF53bSNUGZMiNRLxPCaeLg=;
        b=PiX70Qz38E5lMeqsonbSOM89n+elwJrw0mTqfEHErTTTFkp98SQVFqk2qjsdbClUJ++xav
        xCoMmT2uh+38EyFG/AbbhhaRx7iqsARdg0NHSI4M7jwldwcg8QAahu1rHKFZtFcp6clHBP
        1U+IyH1vTtefWj+6KefqZe9jbqqblsM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-410-32wzq0FnPZG_xa7NCuQrnA-1; Thu, 17 Sep 2020 07:07:31 -0400
X-MC-Unique: 32wzq0FnPZG_xa7NCuQrnA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4A33180EF8A;
        Thu, 17 Sep 2020 11:07:29 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.187])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4FA0875142;
        Thu, 17 Sep 2020 11:07:24 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 0/1] KVM: correctly restore the TSC value on nested migration
Date:   Thu, 17 Sep 2020 14:07:22 +0300
Message-Id: <20200917110723.820666-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
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
Maxim Levitsky (1):=0D
  KVM: x86: fix MSR_IA32_TSC read for nested migration=0D
=0D
 arch/x86/kvm/x86.c | 19 ++++++++++++++++++-=0D
 1 file changed, 18 insertions(+), 1 deletion(-)=0D
=0D
-- =0D
2.26.2=0D
=0D

