Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C20EE7AA105
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 22:57:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231961AbjIUU4r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 16:56:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232630AbjIUU4O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 16:56:14 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70922C3314
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 13:33:49 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-570096f51acso1065655a12.0
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 13:33:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695328428; x=1695933228; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=gEbkWjE9idIufV/ddZ5aR1H9FUodW3tbJDRD7kgzYUw=;
        b=Tu5WSHXGB+q7z+GKZFp8/JnK6DVPjpxSNbok85q1Y+PvCvreZ/0X4/GtKRrY8Y/O9V
         SPjbGdeFwEVbYWT2MAX06r9U87PtYOOe2Qyszugqwqj5Cry1j8d9c1JoERb+po3qXahq
         RtvUIjU7W4OLRxNi9F71HXplyEYrwXuh5Ayv79nYL/JCNaHepb00X23aZnJFWKnrvtjw
         84l5FW64zppbOyZ5SAsx66wd3gKrB2Qi4sy71q2iLxnjwUiuu6sUHei6MTxnYzIFbkeo
         GYWFzAVgVxFHUkTG0u7HBs6YrFwbU68G2wyZk6h+yX/0JHJncXpS0PxztrVVL82sciDt
         t34Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695328428; x=1695933228;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gEbkWjE9idIufV/ddZ5aR1H9FUodW3tbJDRD7kgzYUw=;
        b=vA+aq7RfHVSezzORT0coSRwRYYIt4JqZJ3PDmRUT3bhEjWf+zhcomRE4/mUn9YCnzm
         LFRGN5qNh6PpEWSxw+7BfCZeDzL5koAbKwY1WFCpRD5rhAfXWDe/HyZ416tjSPnmSvYG
         O2Tux9iw5S7/UcWGXOWcXkl3y5KPOKqJIgsZtevc4aa9Hf1FzBn+rHJqosRmHrkQxP0l
         9tvi1kl1s4bPbkjeplSAgacpQDlouWbexV9NqqiSA5uNFP5m4d7zAsuWLjfpbMp2Xuiw
         S05qw3gd6q3m1KdJ0OOKGSEiwRU1VmP2bnap2lxxZB3GTfyzlcLNW0oN9nR2JLEkgILA
         pA9w==
X-Gm-Message-State: AOJu0YxEBSHYQWtNJWTNdoNP7fyxnKjH4dP3gro2Pk4GBbIKiB1IZnrL
        84mpohBxAWL7IlKv6WnO5s/S2Nzog8I=
X-Google-Smtp-Source: AGHT+IFdAeqMaeF2jgODrlMtOfJVR36IWpqSSK7eAjHnsSdG7m0GHCsiZUhO86QnzvgNYNps5uY+twCRS8I=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:23d2:b0:1c3:d556:4f9e with SMTP id
 o18-20020a17090323d200b001c3d5564f9emr9906plh.0.1695328428491; Thu, 21 Sep
 2023 13:33:48 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 21 Sep 2023 13:33:25 -0700
In-Reply-To: <20230921203331.3746712-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230921203331.3746712-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.515.g380fc7ccd1-goog
Message-ID: <20230921203331.3746712-9-seanjc@google.com>
Subject: [PATCH 08/13] KVM: x86/mmu: Zap shared-only memslots when private
 attribute changes
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Roth <michael.roth@amd.com>,
        Binbin Wu <binbin.wu@linux.intel.com>
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

Zap all relevant memslots, including shared-only memslots, if the private
memory attribute is being changed.  If userspace converts a range to
private, KVM must zap shared SPTEs to prevent the guest from accessing
the memory as shared.  If userspace converts a range to shared, zapping
SPTEs for shared-only memslots isn't strictly necessary, but doing so
ensures that KVM will install a hugepage mapping if possible, e.g. if a
2MiB range that was mixed is converted to be 100% shared.

Fixes: dcde045383f3 ("KVM: x86/mmu: Handle page fault for private memory")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 148931cf9dba..aa67d9d6fcf8 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -7259,10 +7259,17 @@ bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
 					struct kvm_gfn_range *range)
 {
 	/*
-	 * KVM x86 currently only supports KVM_MEMORY_ATTRIBUTE_PRIVATE, skip
-	 * the slot if the slot will never consume the PRIVATE attribute.
+	 * Zap SPTEs even if the slot can't be mapped PRIVATE.  KVM x86 only
+	 * supports KVM_MEMORY_ATTRIBUTE_PRIVATE, and so it *seems* like KVM
+	 * can simply ignore such slots.  But if userspace is making memory
+	 * PRIVATE, then KVM must prevent the guest from accessing the memory
+	 * as shared.  And if userspace is making memory SHARED and this point
+	 * is reached, then at least one page within the range was previously
+	 * PRIVATE, i.e. the slot's possible hugepage ranges are changing.
+	 * Zapping SPTEs in this case ensures KVM will reassess whether or not
+	 * a hugepage can be used for affected ranges.
 	 */
-	if (!kvm_slot_can_be_private(range->slot))
+	if (WARN_ON_ONCE(!kvm_arch_has_private_mem(kvm)))
 		return false;
 
 	return kvm_mmu_unmap_gfn_range(kvm, range);
-- 
2.42.0.515.g380fc7ccd1-goog

