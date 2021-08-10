Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D6543E84AC
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 22:53:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233782AbhHJUxX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 16:53:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50247 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233412AbhHJUxW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Aug 2021 16:53:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628628780;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=NhVj87YtWSgAJFzfob9ZxJQ6iKp15+xteDE4MWJJLZ0=;
        b=ClrR3wjHSVHPBfEiW3mFMmw1jwicfspa7sKmL9esYTUUKgagziM4JErUUEPI0c9PjI6HuD
        +L3iku9bTIbhmWVB2mTJoi+9oDC0vUvroBEjMu6DxfgibtUHt3SsLdPsgRVdVtc5QGFLTO
        hR35T9raQI8MnZn485C9L+Qc5qAHb5w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-402-nVe_l5eYPPSM03G3LugNCw-1; Tue, 10 Aug 2021 16:52:58 -0400
X-MC-Unique: nVe_l5eYPPSM03G3LugNCw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 10F19801B3D;
        Tue, 10 Aug 2021 20:52:57 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 086D06E0B7;
        Tue, 10 Aug 2021 20:52:52 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v4 00/16] My AVIC patch queue
Date:   Tue, 10 Aug 2021 23:52:35 +0300
Message-Id: <20210810205251.424103-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi!=0D
=0D
This is a series of bugfixes to the AVIC dynamic inhibition, which was=0D
made while trying to fix bugs as much as possible in this area and trying=0D
to make the AVIC+SYNIC conditional enablement work.=0D
=0D
* Patches 1,3-8 are code from Sean Christopherson which=0D
  implement an alternative approach of inhibiting AVIC without=0D
  disabling its memslot.=0D
=0D
  V4: addressed review feedback.=0D
=0D
* Patch 2 is new and it fixes a bug in kvm_flush_remote_tlbs_with_address=0D
=0D
* Patches 9-10 in this series fix a race condition which can cause=0D
  a lost write from a guest to APIC when the APIC write races=0D
  the AVIC un-inhibition, and add a warning to catch this problem=0D
  if it re-emerges again.=0D
=0D
  V4: applied review feedback from Paolo=0D
=0D
* Patch 11 is the patch from Vitaly about allowing AVIC with SYNC=0D
  as long as the guest doesn=E2=80=99t use the AutoEOI feature. I only slig=
htly=0D
  changed it to expose the AutoEOI cpuid bit regardless of AVIC enablement.=
=0D
=0D
  V4: fixed a race that Paolo pointed out.=0D
=0D
* Patch 12 is a refactoring that is now possible in SVM AVIC inhibition cod=
e,=0D
  because the RCU lock is not dropped anymore.=0D
=0D
* Patch 13-15 fixes another issue I found in AVIC inhibit code:=0D
=0D
  Currently avic_vcpu_load/avic_vcpu_put are called on userspace entry/exit=
=0D
  from KVM (aka kvm_vcpu_get/kvm_vcpu_put), and these functions update the=
=0D
  "is running" bit in the AVIC physical ID remap table and update the=0D
  target vCPU in iommu code.=0D
=0D
  However both of these functions don't do anything when AVIC is inhibited=
=0D
  thus the "is running" bit will be kept enabled during the exit to userspa=
ce.=0D
  This shouldn't be a big issue as the caller=0D
  doesn't use the AVIC when inhibited but still inconsistent and can trigge=
r=0D
  a warning about this in avic_vcpu_load.=0D
=0D
  To be on the safe side I think it makes sense to call=0D
  avic_vcpu_put/avic_vcpu_load when inhibiting/uninhibiting the AVIC.=0D
  This will ensure that the work these functions do is matched.=0D
=0D
  V4: I splitted a single patch to 3 patches to make it easier=0D
      to review, and applied Paolo's review feedback.=0D
=0D
* Patch 16 removes the pointless APIC base=0D
  relocation from AVIC to make it consistent with the rest of KVM.=0D
=0D
  (both AVIC and APICv only support default base, while regular KVM,=0D
  sort of support any APIC base as long as it is not RAM.=0D
  If guest attempts to relocate APIC base to non RAM area,=0D
  while APICv/AVIC are active, the new base will be non accelerated,=0D
  while the default base will continue to be AVIC/APICv backed).=0D
=0D
  On top of that if guest uses different APIC bases on different vCPUs,=0D
  KVM doesn't honour the fact that the MMIO range should only be active=0D
  on that vCPU.=0D
=0D
Best regards,=0D
	Maxim Levitsky=0D
=0D
Maxim Levitsky (14):=0D
  KVM: x86/mmu: fix parameters to kvm_flush_remote_tlbs_with_address=0D
  KVM: x86/mmu: add comment explaining arguments to kvm_zap_gfn_range=0D
  KVM: x86/mmu: bump mmu notifier count in kvm_zap_gfn_range=0D
  KVM: x86/mmu: rename try_async_pf to kvm_faultin_pfn=0D
  KVM: x86/mmu: allow kvm_faultin_pfn to return page fault handling code=0D
  KVM: x86/mmu: allow APICv memslot to be enabled but invisible=0D
  KVM: x86: don't disable APICv memslot when inhibited=0D
  KVM: x86: APICv: fix race in kvm_request_apicv_update on SVM=0D
  KVM: SVM: add warning for mistmatch between AVIC vcpu state and AVIC=0D
    inhibition=0D
  KVM: SVM: remove svm_toggle_avic_for_irq_window=0D
  KVM: SVM: avoid refreshing avic if its state didn't change=0D
  KVM: SVM: move check for kvm_vcpu_apicv_active outside of=0D
    avic_vcpu_{put|load}=0D
  KVM: SVM: call avic_vcpu_load/avic_vcpu_put when enabling/disabling=0D
    AVIC=0D
  KVM: SVM: AVIC: drop unsupported AVIC base relocation code=0D
=0D
Sean Christopherson (1):=0D
  Revert "KVM: x86/mmu: Allow zap gfn range to operate under the mmu=0D
    read lock"=0D
=0D
Vitaly Kuznetsov (1):=0D
  KVM: x86: hyper-v: Deactivate APICv only when AutoEOI feature is in=0D
    use=0D
=0D
 arch/x86/include/asm/kvm-x86-ops.h |  1 -=0D
 arch/x86/include/asm/kvm_host.h    | 13 +++++-=0D
 arch/x86/kvm/hyperv.c              | 32 ++++++++++---=0D
 arch/x86/kvm/mmu/mmu.c             | 75 ++++++++++++++++++++----------=0D
 arch/x86/kvm/mmu/paging_tmpl.h     |  6 +--=0D
 arch/x86/kvm/mmu/tdp_mmu.c         | 15 ++----=0D
 arch/x86/kvm/mmu/tdp_mmu.h         | 11 ++---=0D
 arch/x86/kvm/svm/avic.c            | 49 +++++++------------=0D
 arch/x86/kvm/svm/svm.c             | 21 ++++-----=0D
 arch/x86/kvm/svm/svm.h             |  8 ----=0D
 arch/x86/kvm/x86.c                 | 67 +++++++++++++++-----------=0D
 include/linux/kvm_host.h           |  5 ++=0D
 virt/kvm/kvm_main.c                |  7 ++-=0D
 13 files changed, 174 insertions(+), 136 deletions(-)=0D
=0D
-- =0D
2.26.3=0D
=0D

