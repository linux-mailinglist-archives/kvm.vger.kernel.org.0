Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37CB831DBC7
	for <lists+kvm@lfdr.de>; Wed, 17 Feb 2021 16:00:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233651AbhBQO6z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Feb 2021 09:58:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:48003 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233493AbhBQO6x (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Feb 2021 09:58:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613573846;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=/nfMcV36HhAE2XwGrmtu/12blU+jhydqABEFlCZsevo=;
        b=IvV108WgulYFq/yixRc49kNK1M9pLxX17eiYX+aCOg1r1ANWOeICEhjwY1Al7M2qBpHD+p
        XzRDSod9qwJ97ESJTQXC2eMBwhbACI0LgSiRfo7tO7MI5oQ/+zL9zkucqwJSe2G33AIFiT
        Iv1B/5lWaSOd03lR3J9iRCJTirpT+wk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-334-IRJ5lmrRPEe9OkOERklwfw-1; Wed, 17 Feb 2021 09:57:24 -0500
X-MC-Unique: IRJ5lmrRPEe9OkOERklwfw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C71E518A0837;
        Wed, 17 Feb 2021 14:57:22 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.33])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1797E10016F0;
        Wed, 17 Feb 2021 14:57:18 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 0/7] KVM: random nested fixes
Date:   Wed, 17 Feb 2021 16:57:11 +0200
Message-Id: <20210217145718.1217358-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a set of mostly random fixes I have in my patch queue.=0D
=0D
- Patches 1,2 are minor tracing fixes from a patch series I sent=0D
  some time ago which I don't want to get lost in the noise.=0D
=0D
- Patches 3,4 are for fixing a theoretical bug in VMX with ept=3D0, but als=
o to=0D
  allow to move nested_vmx_load_cr3 call a bit, to make sure that update to=
=0D
  .inject_page_fault is not lost while entering a nested guest.=0D
=0D
- Patch 5 fixes running nested guests with npt=3D0 on host, which is someti=
mes=0D
  useful for debug and such (especially nested).=0D
=0D
- Patch 6 fixes the (mostly theoretical) issue with PDPTR loading on VMX af=
ter=0D
  nested migration.=0D
=0D
- Patch 7 is hopefully the correct fix to eliminate a L0 crash in some rare=
=0D
  cases when a HyperV guest is migrated.=0D
=0D
This was tested with kvm_unit_tests on both VMX and SVM,=0D
both native and in a VM.=0D
Some tests fail on VMX, but I haven't observed new tests failing=0D
due to the changes.=0D
=0D
This patch series was also tested by doing my nested migration with:=0D
    1. npt/ept disabled on the host=0D
    2. npt/ept enabled on the host and disabled in the L1=0D
    3. npt/ept enabled on both.=0D
=0D
In case of npt/ept=3D0 on the host (both on Intel and AMD),=0D
the L2 eventually crashed but I strongly suspect a bug in shadow mmu,=0D
which I track separately.=0D
(see below for full explanation).=0D
=0D
This patch series is based on kvm/queue branch.=0D
=0D
Best regards,=0D
	Maxim Levitsky=0D
=0D
PS: The shadow mmu bug which I spent most of this week on:=0D
=0D
In my testing I am not able to boot win10 (without nesting, HyperV or=0D
anything special) on either Intel nor AMD without two dimensional paging=0D
enabled (ept/npt).=0D
It always crashes in various ways during the boot.=0D
=0D
I found out (accidentally) that if I make KVM's shadow mmu not unsync last =
level=0D
shadow pages, it starts working.=0D
In addition to that, as I mentioned above this bug can happen on Linux as w=
ell,=0D
while stressing the shadow mmu with repeated migrations=0D
(and again with the same shadow unsync hack it just works).=0D
=0D
While running without two dimensional paging is very obsolete by now, a=0D
bug in shadow mmu is relevant to nesting, since it uses it as well.=0D
=0D
Maxim Levitsky (7):=0D
  KVM: VMX: read idt_vectoring_info a bit earlier=0D
  KVM: nSVM: move nested vmrun tracepoint to enter_svm_guest_mode=0D
  KVM: x86: add .complete_mmu_init arch callback=0D
  KVM: nVMX: move inject_page_fault tweak to .complete_mmu_init=0D
  KVM: nSVM: fix running nested guests when npt=3D0=0D
  KVM: nVMX: don't load PDPTRS right after nested state set=0D
  KVM: nSVM: call nested_svm_load_cr3 on nested state load=0D
=0D
 arch/x86/include/asm/kvm-x86-ops.h |  1 +=0D
 arch/x86/include/asm/kvm_host.h    |  2 +=0D
 arch/x86/kvm/mmu/mmu.c             |  2 +=0D
 arch/x86/kvm/svm/nested.c          | 84 +++++++++++++++++++-----------=0D
 arch/x86/kvm/svm/svm.c             |  9 ++++=0D
 arch/x86/kvm/svm/svm.h             |  1 +=0D
 arch/x86/kvm/vmx/nested.c          | 22 ++++----=0D
 arch/x86/kvm/vmx/nested.h          |  1 +=0D
 arch/x86/kvm/vmx/vmx.c             | 13 ++++-=0D
 9 files changed, 92 insertions(+), 43 deletions(-)=0D
=0D
-- =0D
2.26.2=0D
=0D

