Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 154B6512339
	for <lists+kvm@lfdr.de>; Wed, 27 Apr 2022 22:03:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234282AbiD0UGl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Apr 2022 16:06:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230177AbiD0UGk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Apr 2022 16:06:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 652D5C03
        for <kvm@vger.kernel.org>; Wed, 27 Apr 2022 13:03:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651089807;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=rEkeuIdB35PHG3bUObFOQepcEtD/UETXCeHTXiNw/W4=;
        b=gxyFivBnWm2ccPoNc0+7vH4YY9YxaYGWepGmWCAr+Y9TH0Ty8dXlVUizDm46WpzUir8ZXs
        laQVQNEe7dnowk7FhA/o74uiE+1BLp3GjZGpgoKW3V0XiYZl7APQHK8DTaEZM0Kgr0kGyg
        H588KsSAk3LQpuqVOiCZuRlGjld7BQU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-115-ue9yikiaOze3pcESmgHcQA-1; Wed, 27 Apr 2022 16:03:24 -0400
X-MC-Unique: ue9yikiaOze3pcESmgHcQA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0E67B3C10AA2;
        Wed, 27 Apr 2022 20:03:23 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.192.41])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 080E87C55;
        Wed, 27 Apr 2022 20:03:15 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Ingo Molnar <mingo@redhat.com>,
        David Airlie <airlied@linux.ie>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        intel-gfx@lists.freedesktop.org,
        Sean Christopherson <seanjc@google.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        intel-gvt-dev@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [RFC PATCH v3 00/19] RFC: nested AVIC
Date:   Wed, 27 Apr 2022 23:02:55 +0300
Message-Id: <20220427200314.276673-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is V3 of my nested AVIC patches.=0D
=0D
I fixed few more bugs, and I also split the cod insto smaller patches.=0D
=0D
Review is welcome!=0D
=0D
Best regards,=0D
	Maxim Levitsky=0D
=0D
Maxim Levitsky (19):=0D
  KVM: x86: document AVIC/APICv inhibit reasons=0D
  KVM: x86: inhibit APICv/AVIC when the guest and/or host changes apic=0D
    id/base from the defaults.=0D
  KVM: x86: SVM: remove avic's broken code that updated APIC ID=0D
  KVM: x86: mmu: allow to enable write tracking externally=0D
  x86: KVMGT: use kvm_page_track_write_tracking_enable=0D
  KVM: x86: mmu: add gfn_in_memslot helper=0D
  KVM: x86: mmu: tweak fast path for emulation of access to nested NPT=0D
    pages=0D
  KVM: x86: SVM: move avic state to separate struct=0D
  KVM: x86: nSVM: add nested AVIC tracepoints=0D
  KVM: x86: nSVM: implement AVIC's physid/logid table access helpers=0D
  KVM: x86: nSVM: implement shadowing of AVIC's physical id table=0D
  KVM: x86: nSVM: make nested AVIC physid write tracking be aware of the=0D
    host scheduling=0D
  KVM: x86: nSVM: wire nested AVIC to nested guest entry/exit=0D
  KVM: x86: rename .set_apic_access_page_addr to reload_apic_access_page=0D
  KVM: x86: nSVM: add code to reload AVIC physid table when it is=0D
    invalidated=0D
  KVM: x86: nSVM: implement support for nested AVIC vmexits=0D
  KVM: x86: nSVM: implement nested AVIC doorbell emulation=0D
  KVM: x86: SVM/nSVM: add optional non strict AVIC doorbell mode=0D
  KVM: x86: nSVM: expose the nested AVIC to the guest=0D
=0D
 arch/x86/include/asm/kvm-x86-ops.h    |   2 +-=0D
 arch/x86/include/asm/kvm_host.h       |  23 +-=0D
 arch/x86/include/asm/kvm_page_track.h |   1 +=0D
 arch/x86/kvm/Kconfig                  |   3 -=0D
 arch/x86/kvm/lapic.c                  |  25 +-=0D
 arch/x86/kvm/lapic.h                  |   8 +=0D
 arch/x86/kvm/mmu.h                    |   8 +-=0D
 arch/x86/kvm/mmu/mmu.c                |  21 +-=0D
 arch/x86/kvm/mmu/page_track.c         |  10 +-=0D
 arch/x86/kvm/svm/avic.c               | 985 +++++++++++++++++++++++---=0D
 arch/x86/kvm/svm/nested.c             | 141 +++-=0D
 arch/x86/kvm/svm/svm.c                |  39 +-=0D
 arch/x86/kvm/svm/svm.h                | 166 ++++-=0D
 arch/x86/kvm/trace.h                  | 157 +++-=0D
 arch/x86/kvm/vmx/vmx.c                |   8 +-=0D
 arch/x86/kvm/x86.c                    |  19 +-=0D
 drivers/gpu/drm/i915/Kconfig          |   1 -=0D
 drivers/gpu/drm/i915/gvt/kvmgt.c      |   5 +=0D
 include/linux/kvm_host.h              |  10 +-=0D
 19 files changed, 1507 insertions(+), 125 deletions(-)=0D
=0D
-- =0D
2.26.3=0D
=0D

