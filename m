Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8806A61E0F6
	for <lists+kvm@lfdr.de>; Sun,  6 Nov 2022 09:48:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbiKFIsG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Nov 2022 03:48:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbiKFIsE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 6 Nov 2022 03:48:04 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3F37DEEA
        for <kvm@vger.kernel.org>; Sun,  6 Nov 2022 01:47:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667724429;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=O/XFZ/+6CJqUqFY2kBzrGvEKjq+yBbx5dOWN6p476wI=;
        b=HLt/5O7Ks4H93Z557IxO/AT19LCAHBMYpckf7VTXUfi6ZecONulAdjTkaa9qv4Z9VzRlj1
        T+VCBwM2eew2qoI+XQ5Ilec0GrAX6fAXDV6MewRGi2CCLOkiCZpDH6rt8gQoWou2nBqDVY
        DV1F81yZEp1F9MT20v1EG45bpQ2fZ54=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-433-q4Vc802fMZKTta10W5WltQ-1; Sun, 06 Nov 2022 03:47:07 -0500
X-MC-Unique: q4Vc802fMZKTta10W5WltQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 701813803913;
        Sun,  6 Nov 2022 08:47:07 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4851B140EBF5;
        Sun,  6 Nov 2022 08:46:57 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] More KVM fixes for Linux 6.1-rc4
Date:   Sun,  6 Nov 2022 03:46:56 -0500
Message-Id: <20221106084656.148797-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit 8e5423e991e8cd0988d0c4a3f4ac4ca1af7d148a:

  Merge tag 'parisc-for-6.1-2' of git://git.kernel.org/pub/scm/linux/kernel/git/deller/parisc-linux (2022-11-02 11:25:12 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to f4298cac2bfcced49ab308756dc8fef684f3da81:

  Merge tag 'kvmarm-fixes-6.1-3' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD (2022-11-06 03:30:49 -0500)

----------------------------------------------------------------
ARM:

* Fix the pKVM stage-1 walker erronously using the stage-2 accessor

* Correctly convert vcpu->kvm to a hyp pointer when generating
  an exception in a nVHE+MTE configuration

* Check that KVM_CAP_DIRTY_LOG_* are valid before enabling them

* Fix SMPRI_EL1/TPIDR2_EL0 trapping on VHE

* Document the boot requirements for FGT when entering the kernel
  at EL1

x86:

* Use SRCU to protect zap in __kvm_set_or_clear_apicv_inhibit()

* Make argument order consistent for kvcalloc()

* Userspace API fixes for DEBUGCTL and LBRs

----------------------------------------------------------------
Ben Gardon (1):
      KVM: x86: Use SRCU to protect zap in __kvm_set_or_clear_apicv_inhibit()

Gavin Shan (1):
      KVM: Check KVM_CAP_DIRTY_LOG_{RING, RING_ACQ_REL} prior to enabling them

Liao Chang (1):
      KVM: x86: Fix a typo about the usage of kvcalloc()

Marc Zyngier (1):
      KVM: arm64: Fix SMPRI_EL1/TPIDR2_EL0 trapping on VHE

Mark Brown (1):
      arm64: booting: Document our requirements for fine grained traps with SME

Paolo Bonzini (2):
      Merge branch 'kvm-master' into HEAD
      Merge tag 'kvmarm-fixes-6.1-3' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD

Quentin Perret (1):
      KVM: arm64: Use correct accessor to parse stage-1 PTEs

Ryan Roberts (1):
      KVM: arm64: Fix bad dereference on MTE-enabled systems

Sean Christopherson (3):
      KVM: VMX: Advertise PMU LBRs if and only if perf supports LBRs
      KVM: VMX: Fold vmx_supported_debugctl() into vcpu_supported_debugctl()
      KVM: VMX: Ignore guest CPUID for host userspace writes to DEBUGCTL

 Documentation/arm64/booting.rst         |  8 ++++++++
 arch/arm64/kvm/hyp/exception.c          |  3 ++-
 arch/arm64/kvm/hyp/include/hyp/switch.h | 20 ++++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/mem_protect.c   |  2 +-
 arch/arm64/kvm/hyp/nvhe/switch.c        | 26 --------------------------
 arch/arm64/kvm/hyp/vhe/switch.c         |  8 --------
 arch/x86/kvm/cpuid.c                    |  2 +-
 arch/x86/kvm/vmx/capabilities.h         | 19 +++----------------
 arch/x86/kvm/vmx/vmx.c                  | 18 +++++++++++-------
 arch/x86/kvm/x86.c                      |  3 +++
 virt/kvm/kvm_main.c                     |  3 +++
 11 files changed, 52 insertions(+), 60 deletions(-)

