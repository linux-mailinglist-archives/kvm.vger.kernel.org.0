Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FFCF7AA383
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 23:51:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232839AbjIUVvb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 17:51:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232933AbjIUVvI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 17:51:08 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB164ACD32
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 13:33:36 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d77fa2e7771so1798377276.1
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 13:33:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695328416; x=1695933216; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=FGyjwBvsOtsfuIhphBYWtiq/+EdBc6Gwm+3ffP2TVfs=;
        b=MJ/4lc+cX7TzyAAdalfKhnJV2Qvqe61anNd0ZAc9E3gCp1vGBElc/PE1/LcOl5S/Ys
         /SosH7LMDdxj1R5b6cRKylf3vp9/cCdCxQy8wiHI8NDdjLFhb2iGCRqXQM9jPcGn0D/y
         AhXHiCAKC6bjlPMfQ5b1yFC5P7MgeMC1vZjJ72xoQWHG8fCAS9IxY8n3JAstImk4ToCL
         maNDy7MIwnhjd44s1O8ulnLZf8pdxO5o3POVq/31Pc85VMjVTexR/iuoPj+B2Y1J/eL1
         ytLBkpBqa7FW85ROdg2r+V+xE/AIOogyD9uIsggayqwP4J3b6rJgaRU20ZV7fqmifiu9
         KygA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695328416; x=1695933216;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FGyjwBvsOtsfuIhphBYWtiq/+EdBc6Gwm+3ffP2TVfs=;
        b=CV2yl6M5rNHNkPu05r9XnSEJVCcrP4qSNZZoyvhyRw14khz9YHbywV1wdA6sN/mA7o
         30bQaNFptso5jyLw9+ekGR9O23Jj5J1yxGlnd4uz9goxnro4iD5LJ+wqPP2SKc0kgyqA
         KLLJzM/4FIRGgluN7HnvP0z9r7S+pOzdTxJLJrc3sNSmB3vx4DKAlwJ6hzgPP1zwWWfB
         4iE2fcfI83X16A27eHpvIwnFuOxrDswmjAxNv1VQbnrVuXE2LdhQxLxrwGLIP83ip07S
         BJ1Ubvau2T52xpXR23X20Xrav/oxxRwETWAQ0VtPGQ/sCxqbtDSpwRwFj5e8A0zPGKFy
         WsTQ==
X-Gm-Message-State: AOJu0Yy1ML5IZq4K5O9mWvVe61bec8wsr5XN/EFriScz6N1GX4sR+LF/
        C/B7CUjpjvlmXbwdKm2WujefCbdcm1k=
X-Google-Smtp-Source: AGHT+IHmSxFj/rzaiI2sywRueiP80CEdjOd2hu2Iude5MVmXEp4VG1h2O78o3QM7I+FKA1VxJxlQX6QqLrA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:d849:0:b0:d81:58d3:cc71 with SMTP id
 p70-20020a25d849000000b00d8158d3cc71mr94599ybg.13.1695328415917; Thu, 21 Sep
 2023 13:33:35 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 21 Sep 2023 13:33:18 -0700
In-Reply-To: <20230921203331.3746712-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230921203331.3746712-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.515.g380fc7ccd1-goog
Message-ID: <20230921203331.3746712-2-seanjc@google.com>
Subject: [PATCH 01/13] KVM: Assert that mmu_invalidate_in_progress *never*
 goes negative
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Roth <michael.roth@amd.com>,
        Binbin Wu <binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the assertion on the in-progress invalidation count from the primary
MMU's notifier path to KVM's common notification path, i.e. assert that
the count doesn't go negative even when the invalidation is coming from
KVM itself.

Opportunistically convert the assertion to a KVM_BUG_ON(), i.e. kill only
the affected VM, not the entire kernel.  A corrupted count is fatal to the
VM, e.g. the non-zero (negative) count will cause mmu_invalidate_retry()
to block any and all attempts to install new mappings.  But it's far from
guaranteed that an end() without a start() is fatal or even problematic to
anything other than the target VM, e.g. the underlying bug could simply be
a duplicate call to end().  And it's much more likely that a missed
invalidation, i.e. a potential use-after-free, would manifest as no
notification whatsoever, not an end() without a start().

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index a83dfef1316e..30708e460568 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -870,6 +870,7 @@ void kvm_mmu_invalidate_end(struct kvm *kvm)
 	 * in conjunction with the smp_rmb in mmu_invalidate_retry().
 	 */
 	kvm->mmu_invalidate_in_progress--;
+	KVM_BUG_ON(kvm->mmu_invalidate_in_progress < 0, kvm);
 
 	/*
 	 * Assert that at least one range must be added between start() and
@@ -906,8 +907,6 @@ static void kvm_mmu_notifier_invalidate_range_end(struct mmu_notifier *mn,
 	 */
 	if (wake)
 		rcuwait_wake_up(&kvm->mn_memslots_update_rcuwait);
-
-	BUG_ON(kvm->mmu_invalidate_in_progress < 0);
 }
 
 static int kvm_mmu_notifier_clear_flush_young(struct mmu_notifier *mn,
-- 
2.42.0.515.g380fc7ccd1-goog

