Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B5C64AC516
	for <lists+kvm@lfdr.de>; Mon,  7 Feb 2022 17:12:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242326AbiBGQD5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Feb 2022 11:03:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377047AbiBGPzF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Feb 2022 10:55:05 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C349EC0401DC
        for <kvm@vger.kernel.org>; Mon,  7 Feb 2022 07:55:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644249303;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=ckLuH3eXQt4Wu9Nzp1D8ksAkv1tHukiQ+KMKFiTtdwY=;
        b=cIx6hvdW99GeleJU4jRK3RUHgV40wH49QCk2UgtyVVxMq7fkD+K5V9JcxmG1r6jcYVKWXm
        h72qR6Uim788LQWPXDR/cCOy9iohJUdxq1+plDA3TTh1iSQAavw3LnQOSFiocbajLhCulu
        eCqL8sWlE5+biPjldKlyHuETyp9qw7Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-277-3oJzETgWM123BYxoIWYJeQ-1; Mon, 07 Feb 2022 10:55:00 -0500
X-MC-Unique: 3oJzETgWM123BYxoIWYJeQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EAE56100C609;
        Mon,  7 Feb 2022 15:54:56 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.192.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 182D87DE5F;
        Mon,  7 Feb 2022 15:54:48 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Tony Luck <tony.luck@intel.com>,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        Ingo Molnar <mingo@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        intel-gvt-dev@lists.freedesktop.org,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        David Airlie <airlied@linux.ie>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org,
        Daniel Vetter <daniel@ffwll.ch>,
        Borislav Petkov <bp@alien8.de>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH RESEND 00/30] My patch queue
Date:   Mon,  7 Feb 2022 17:54:17 +0200
Message-Id: <20220207155447.840194-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is set of various patches that are stuck in my patch queue.=0D
=0D
KVM_REQ_GET_NESTED_STATE_PAGES patch is mostly RFC, but it does seem=0D
to work for me.=0D
=0D
Read-only APIC ID is also somewhat RFC.=0D
=0D
Some of these patches are preparation for support for nested AVIC=0D
which I almost done developing, and will start testing very soon.=0D
=0D
Resend with cleaned up CCs.=0D
=0D
Best regards,=0D
	Maxim Levitsky=0D
=0D
Maxim Levitsky (30):=0D
  KVM: x86: SVM: don't passthrough SMAP/SMEP/PKE bits in !NPT &&=0D
    !gCR0.PG case=0D
  KVM: x86: nSVM: fix potential NULL derefernce on nested migration=0D
  KVM: x86: nSVM: mark vmcb01 as dirty when restoring SMM saved state=0D
  KVM: x86: nSVM/nVMX: set nested_run_pending on VM entry which is a=0D
    result of RSM=0D
  KVM: x86: nSVM: expose clean bit support to the guest=0D
  KVM: x86: mark syntethic SMM vmexit as SVM_EXIT_SW=0D
  KVM: x86: nSVM: deal with L1 hypervisor that intercepts interrupts but=0D
    lets L2 control them=0D
  KVM: x86: lapic: don't touch irr_pending in kvm_apic_update_apicv when=0D
    inhibiting it=0D
  KVM: x86: SVM: move avic definitions from AMD's spec to svm.h=0D
  KVM: x86: SVM: fix race between interrupt delivery and AVIC inhibition=0D
  KVM: x86: SVM: use vmcb01 in avic_init_vmcb=0D
  KVM: x86: SVM: allow AVIC to co-exist with a nested guest running=0D
  KVM: x86: lapic: don't allow to change APIC ID when apic acceleration=0D
    is enabled=0D
  KVM: x86: lapic: don't allow to change local apic id when using older=0D
    x2apic api=0D
  KVM: x86: SVM: remove avic's broken code that updated APIC ID=0D
  KVM: x86: SVM: allow to force AVIC to be enabled=0D
  KVM: x86: mmu: trace kvm_mmu_set_spte after the new SPTE was set=0D
  KVM: x86: mmu: add strict mmu mode=0D
  KVM: x86: mmu: add gfn_in_memslot helper=0D
  KVM: x86: mmu: allow to enable write tracking externally=0D
  x86: KVMGT: use kvm_page_track_write_tracking_enable=0D
  KVM: x86: nSVM: correctly virtualize LBR msrs when L2 is running=0D
  KVM: x86: nSVM: implement nested LBR virtualization=0D
  KVM: x86: nSVM: implement nested VMLOAD/VMSAVE=0D
  KVM: x86: nSVM: support PAUSE filter threshold and count when=0D
    cpu_pm=3Don=0D
  KVM: x86: nSVM: implement nested vGIF=0D
  KVM: x86: add force_intercept_exceptions_mask=0D
  KVM: SVM: implement force_intercept_exceptions_mask=0D
  KVM: VMX: implement force_intercept_exceptions_mask=0D
  KVM: x86: get rid of KVM_REQ_GET_NESTED_STATE_PAGES=0D
=0D
 arch/x86/include/asm/kvm-x86-ops.h    |   1 +=0D
 arch/x86/include/asm/kvm_host.h       |  24 +-=0D
 arch/x86/include/asm/kvm_page_track.h |   1 +=0D
 arch/x86/include/asm/msr-index.h      |   1 +=0D
 arch/x86/include/asm/svm.h            |  36 +++=0D
 arch/x86/include/uapi/asm/kvm.h       |   1 +=0D
 arch/x86/kvm/Kconfig                  |   3 -=0D
 arch/x86/kvm/hyperv.c                 |   4 +=0D
 arch/x86/kvm/lapic.c                  |  53 ++--=0D
 arch/x86/kvm/mmu.h                    |   8 +-=0D
 arch/x86/kvm/mmu/mmu.c                |  31 ++-=0D
 arch/x86/kvm/mmu/page_track.c         |  10 +-=0D
 arch/x86/kvm/svm/avic.c               | 135 +++-------=0D
 arch/x86/kvm/svm/nested.c             | 167 +++++++-----=0D
 arch/x86/kvm/svm/svm.c                | 375 ++++++++++++++++++++++----=0D
 arch/x86/kvm/svm/svm.h                |  60 +++--=0D
 arch/x86/kvm/svm/svm_onhyperv.c       |   1 +=0D
 arch/x86/kvm/vmx/nested.c             | 107 +++-----=0D
 arch/x86/kvm/vmx/vmcs.h               |   6 +=0D
 arch/x86/kvm/vmx/vmx.c                |  48 +++-=0D
 arch/x86/kvm/x86.c                    |  42 ++-=0D
 arch/x86/kvm/x86.h                    |   5 +=0D
 drivers/gpu/drm/i915/Kconfig          |   1 -=0D
 drivers/gpu/drm/i915/gvt/kvmgt.c      |   5 +=0D
 include/linux/kvm_host.h              |  10 +-=0D
 25 files changed, 764 insertions(+), 371 deletions(-)=0D
=0D
-- =0D
2.26.3=0D
=0D

