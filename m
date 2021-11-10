Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE6D744BE30
	for <lists+kvm@lfdr.de>; Wed, 10 Nov 2021 11:00:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230455AbhKJKDb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Nov 2021 05:03:31 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38736 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229653AbhKJKDa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 10 Nov 2021 05:03:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636538443;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=86aMXmKzAawqKTKO1WhU1TxCzGNukAcU5Mte3VBLD7I=;
        b=bZhm6HdnhnSfymP9Pfix9aqLNApw3PsrclDgEwU3An0cZYI6UcefvPjVoY/qhlHEZsZCde
        zgOBpFgyc1qccxUCST81SFxrEugSVkrDLVvv3b9wp9bVCi4JEB6+e8+TKoQaLY3V4efqtc
        h2EOsev2VXa8I63lI703ivaCxMbNS14=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-346-TfdYpu-fNRGt3NcYkLxIjg-1; Wed, 10 Nov 2021 05:00:41 -0500
X-MC-Unique: TfdYpu-fNRGt3NcYkLxIjg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B5DAF824F88;
        Wed, 10 Nov 2021 10:00:39 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.194.243])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 28A3610495BA;
        Wed, 10 Nov 2021 10:00:19 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Wanpeng Li <wanpengli@tencent.com>, Borislav Petkov <bp@alien8.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 0/3] VMX: nested migration fixes for 32 bit nested guests
Date:   Wed, 10 Nov 2021 12:00:15 +0200
Message-Id: <20211110100018.367426-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is hopefully the last issue I was tracking in regard to nested migrati=
on,=0D
as far as I know.=0D
=0D
The issue is that migration of L1 which is normal 64 bit guest,=0D
but is running a 32 bit nested guest is broken on VMX and I finally found o=
ut why.=0D
=0D
There are two bugs, both related to the fact that qemu first restores SREGS=
=0D
of L2, and only then sets the nested state. That haunts us till this day.=0D
=0D
First issue is that vmx_set_nested_state does some checks on the host=0D
state stored in vmcs12, but it uses the current IA32_EFER which is from L2.=
=0D
Thus, consistency checks fail.=0D
=0D
I fixed this by restoring L1's efer from vmcs12, letting these checks pass,=
=0D
which is somewhat hacky so I am open for better suggestions on how to do th=
is.=0D
One option is to pass explicit value of the L1's IA32_EFER to the consisten=
cy=0D
check code, and leave L2's IA32_EFER alone.=0D
=0D
The second issue is that L2 IA32_EFER makes L1's mmu be initialized incorre=
ctly=0D
(with PAE paging). This itself isn't an immediate problem as we are going i=
nto the L2,=0D
but when we exit it, we don't reset the L1's mmu back to 64 bit mode becaus=
e,=0D
It so happens that the mmu role doesn't change and the 64 bitness isn't par=
t of the mmu role.=0D
=0D
I fixed this also with somewhat a hack by checking that mmu's level didn't =
change,=0D
but there is also an option to make 64 bitness be part of the mmu role.=0D
=0D
Also when restoring the L1's IA32_EFER, it is possible to reset L1's mmu,=0D
so that it is setup correctly, which isn't strictly needed but does=0D
make it more bug proof.=0D
The 3rd patch is still needed as resetting the mmu right after restoring=0D
IA32_EFER does nothing without this patch as well.=0D
=0D
SVM in theory has both issues, but restoring L1's EFER into vcpu->arch.efer=
=0D
isn't needed there as the code explicitly checks the L1's save area instead=
=0D
for consistency.=0D
=0D
Best regards,=0D
	Maxim Levitsky=0D
=0D
Maxim Levitsky (3):=0D
  KVM: nVMX: extract calculation of the L1's EFER=0D
  KVM: nVMX: restore L1's EFER prior to setting the nested state=0D
  KVM: x86/mmu: don't skip mmu initialization when mmu root level=0D
    changes=0D
=0D
 arch/x86/kvm/mmu/mmu.c    | 14 ++++++++++----=0D
 arch/x86/kvm/vmx/nested.c | 33 +++++++++++++++++++++++++++------=0D
 2 files changed, 37 insertions(+), 10 deletions(-)=0D
=0D
-- =0D
2.26.3=0D
=0D

