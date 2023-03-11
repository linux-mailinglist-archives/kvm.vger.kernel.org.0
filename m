Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 701C36B569D
	for <lists+kvm@lfdr.de>; Sat, 11 Mar 2023 01:24:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231398AbjCKAYk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 19:24:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231163AbjCKAYB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 19:24:01 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80FFC6B307
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 16:23:33 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id d3-20020a17090acd0300b00237659aae8dso5055154pju.1
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 16:23:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678494212;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Rm109LqJljTWMnqiCeQQyQd+NmHilpchibDoYyZB3Pk=;
        b=nbQyCIoiLIM7RQJY0KwsZy4MzALtUvpTVM0wdA1nSuVn+9c9kcDfgfjPsaslp3h104
         zCUflGcnq2a5vqfNqA7G619cjYvpnP0xZenQN8Zu1a1rSrPcdxhIboj4sIXYcbKgkKZF
         1HiHk172uv/TS/YsLBJ8VPH5ev9KwCQ+n0xy/R2NBWQfRgme2yPjjL66yaKvoymjOp98
         H7bh6xdjI+pIQvZVpqHMbBcMVNwAe8eRczAgZZ12yOdlAdRqTGG+BqDD+VS/2ZFU4HsK
         WCauxqGyQpSRdb6mw3BfyWNp7bQTtspy/V2CMSt8fyQjpFLp47jZ/M0grWgr3WRYJApx
         659g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678494212;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Rm109LqJljTWMnqiCeQQyQd+NmHilpchibDoYyZB3Pk=;
        b=kGtUmVdvH7hqNZBgKuwhxn1BLDLwc2shy2SO2SXmxT5UvChTYWGvuVV+QhKDp6e+6v
         O31W044w4R3uv2iyxlQDDOyzJ8KKo8D6FnXjA1cZH6U9O3sJ8DBfwEGDW12QqzcH5g8s
         mIAcI/G6Y6i34iGspYoI1XyhIgrvgZ7pyFgUBrqhGwUAphm+/uw5ImSTIQSh1h+HD4Tw
         HDNGA4XQylvc5kzIfPDUsq59vyY5fMtBYLAm6pbLqGEggblZ0h8wsPLIEJF1s4CfcoQZ
         VW6ToBlkNwiGiQPFIy2+jRstq1tTpl7N7o9EFn096fBsHDD78bmg1a+7djUpTUBrfh9R
         63uA==
X-Gm-Message-State: AO0yUKXRQrBP/qBin30xBidIvDjyQPjHxTvAN37Cqyn7Ep+rjy+Tn8+b
        ZHVjjdHLILmko8fQiuDrkFouBGZZJz0=
X-Google-Smtp-Source: AK7set/n6UE/V7iWsKnat8pQjFuFgR5r7U2AsXF3aLCinLAedf3bBdp71x6bUangZ7z1FWvGXbBi6akMf+I=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:7515:0:b0:503:20b9:5d88 with SMTP id
 q21-20020a637515000000b0050320b95d88mr8959180pgc.4.1678494212241; Fri, 10 Mar
 2023 16:23:32 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 10 Mar 2023 16:22:45 -0800
In-Reply-To: <20230311002258.852397-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230311002258.852397-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230311002258.852397-15-seanjc@google.com>
Subject: [PATCH v2 14/27] KVM: x86: Reject memslot MOVE operations if KVMGT is attached
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>
Cc:     kvm@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Yan Zhao <yan.y.zhao@intel.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Disallow moving memslots if the VM has external page-track users, i.e. if
KVMGT is being used to expose a virtual GPU to the guest, as KVM doesn't
correctly handle moving memory regions.

Note, this is potential ABI breakage!  E.g. userspace could move regions
that aren't shadowed by KVMGT without harming the guest.  However, the
only known user of KVMGT is QEMU, and QEMU doesn't move generic memory
regions.  KVM's own support for moving memory regions was also broken for
multiple years (albeit for an edge case, but arguably moving RAM is
itself an edge case), e.g. see commit edd4fa37baa6 ("KVM: x86: Allocate
new rmap and large page tracking when moving memslot").

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_page_track.h | 3 +++
 arch/x86/kvm/mmu/page_track.c         | 5 +++++
 arch/x86/kvm/x86.c                    | 7 +++++++
 3 files changed, 15 insertions(+)

diff --git a/arch/x86/include/asm/kvm_page_track.h b/arch/x86/include/asm/kvm_page_track.h
index 0d65ae203fd6..6a287bcbe8a9 100644
--- a/arch/x86/include/asm/kvm_page_track.h
+++ b/arch/x86/include/asm/kvm_page_track.h
@@ -77,4 +77,7 @@ kvm_page_track_unregister_notifier(struct kvm *kvm,
 void kvm_page_track_write(struct kvm_vcpu *vcpu, gpa_t gpa, const u8 *new,
 			  int bytes);
 void kvm_page_track_flush_slot(struct kvm *kvm, struct kvm_memory_slot *slot);
+
+bool kvm_page_track_has_external_user(struct kvm *kvm);
+
 #endif
diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
index 39a0863af8b4..1cfc0a0ccc23 100644
--- a/arch/x86/kvm/mmu/page_track.c
+++ b/arch/x86/kvm/mmu/page_track.c
@@ -321,3 +321,8 @@ enum pg_level kvm_page_track_max_mapping_level(struct kvm *kvm, gfn_t gfn,
 	return max_level;
 }
 EXPORT_SYMBOL_GPL(kvm_page_track_max_mapping_level);
+
+bool kvm_page_track_has_external_user(struct kvm *kvm)
+{
+	return hlist_empty(&kvm->arch.track_notifier_head.track_notifier_list);
+}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 29dd6c97d145..47ac9291cd43 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12484,6 +12484,13 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 				   struct kvm_memory_slot *new,
 				   enum kvm_mr_change change)
 {
+	/*
+	 * KVM doesn't support moving memslots when there are external page
+	 * trackers attached to the VM, i.e. if KVMGT is in use.
+	 */
+	if (change == KVM_MR_MOVE && kvm_page_track_has_external_user(kvm))
+		return -EINVAL;
+
 	if (change == KVM_MR_CREATE || change == KVM_MR_MOVE) {
 		if ((new->base_gfn + new->npages - 1) > kvm_mmu_max_gfn())
 			return -EINVAL;
-- 
2.40.0.rc1.284.g88254d51c5-goog

