Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 148247D9ED9
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 19:26:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346016AbjJ0R0w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Oct 2023 13:26:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232495AbjJ0R0u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Oct 2023 13:26:50 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6442AB
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 10:26:47 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5a7d261a84bso19150057b3.3
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 10:26:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698427607; x=1699032407; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=36/k5kj8Rud6lBCe46IHAu0ez9wIzYLDvyiBO4IFlFE=;
        b=hQkpPksXWaihVWHKOTW1t5U8/vEL++2bH3y0+YTKPdKwhTeuUOTsK4zo/xLh/QKWBm
         Fi+bfms8QJdxNC83vuwm1Me5Dl6opXNiGjc8zSmpW4XdJVuikD7zKubukcIkKML2Iriv
         ZKnyXPAJZG6w2WRaSFXK5IA82W7v6XD0s+juPt248DRTaHCF8pshwbJJUvzlpCaPCbc3
         XPzfqJ1esIW17CAkfvW2RYuUZN+C2EqwuWfSueCqNXbkb3r1lbeIWv9BWOVD1Y6KBWir
         xiesuBN0F40d9c4TPOTZh2UM8AanvrDj0i7y1mEOhKxMbWWM067MpWfAZG0R5ahiVBBa
         puPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698427607; x=1699032407;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=36/k5kj8Rud6lBCe46IHAu0ez9wIzYLDvyiBO4IFlFE=;
        b=RngNFDa41iijSzcJuR1l9q0ioMA9VPDy+MJKUWdb8buHJgQdmgSZQiLVPbGLRt24tH
         3x9lVVzv0/LCe90FkkquIskVyfBgPi5cZBQwu+jQXyNHpIKACA2ivYCRSygjIaq95p3A
         Gnl5VQlK5kW5XyVJceMXTuFmbcnbcl274VHo2ADJFxzTojW1DidCopRzbL8uYBGAKcF5
         OQBrM+iY5TsEnHF+0kmV7j7k8NT/YxYYBGHhub+bIXFWxpe90t+n18PdnAOLs5KmtdSm
         HE/yRQ1i3gNJs7ne27vJFRF2BHHFPMB28DK1RpjimGGmb9B2uEpOpaolufUPlK4YkALO
         1aUA==
X-Gm-Message-State: AOJu0YxTAvS/B+SCFYZzXyEEcxgwgnwNDjN8aRuSJ6KX0QFM/QieBjNh
        E1yPG7KVoOwhMjLl6NEwWtpPVBPF6tVjTw==
X-Google-Smtp-Source: AGHT+IE3Zshzoljj2RC2atKvwgpWJrQMnYbV7n+tmrwEUfs2hE8K/WbqVXrYGQTjIScB1K6RwFrB85GyA4tVVg==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a81:6d17:0:b0:5a8:205e:1f27 with SMTP id
 i23-20020a816d17000000b005a8205e1f27mr70422ywc.6.1698427606956; Fri, 27 Oct
 2023 10:26:46 -0700 (PDT)
Date:   Fri, 27 Oct 2023 10:26:40 -0700
In-Reply-To: <20231027172640.2335197-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20231027172640.2335197-1-dmatlack@google.com>
X-Mailer: git-send-email 2.42.0.820.g83a721a137-goog
Message-ID: <20231027172640.2335197-4-dmatlack@google.com>
Subject: [PATCH 3/3] KVM: Aggressively drop and reacquire mmu_lock during CLEAR_DIRTY_LOG
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>, kvm@vger.kernel.org,
        Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop and reacquire the mmu_lock during CLEAR_DIRTY_LOG to avoid blocking
other threads from acquiring the mmu_lock (e.g. vCPUs taking page
faults).

It should be safe to drop and reacquire the mmu_lock from a correctness
standpoint. slots_lock already ensures that only one thread in KVM is
processing a GET/CLEAR_DIRTY_LOG ioctl. And KVM already has to be
prepared to handle vCPUs updating the dirty log concurrent with
CLEAR_DIRTY_LOG, hence the atomic_long_fetch_andnot(). So holding the
mmu_lock across loop iterations is entirely unnecessary. It only needs
to be acquired when calling in the arch-specific code to modify page
tables.

This change eliminates drops in guest performance during the live
migration of a 160 vCPU VM that we've observed while userspace is
issuing CLEAR ioctls (tested with 1GiB and 8GiB CLEARs). Userspace could
issue finer-grained CLEAR ioctls, which would also reduce contention on
the mmu_lock, but doing so will increase the rate of remote TLB
flushing, so there is a limit. And there's really no reason to punt this
problem to userspace.  KVM can just drop and reacquire the lock more
frequently to avoid holding it for too long.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 virt/kvm/kvm_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 486800a7024b..afa61a2309d2 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2297,7 +2297,6 @@ static int kvm_clear_dirty_log_protect(struct kvm *kvm,
 	if (copy_from_user(dirty_bitmap_buffer, log->dirty_bitmap, n))
 		return -EFAULT;
 
-	KVM_MMU_LOCK(kvm);
 	for (offset = log->first_page, i = offset / BITS_PER_LONG,
 		 n = DIV_ROUND_UP(log->num_pages, BITS_PER_LONG); n--;
 	     i++, offset += BITS_PER_LONG) {
@@ -2316,11 +2315,12 @@ static int kvm_clear_dirty_log_protect(struct kvm *kvm,
 		*/
 		if (mask) {
 			flush = true;
+			KVM_MMU_LOCK(kvm);
 			kvm_arch_mmu_enable_log_dirty_pt_masked(kvm, memslot,
 								offset, mask);
+			KVM_MMU_UNLOCK(kvm);
 		}
 	}
-	KVM_MMU_UNLOCK(kvm);
 
 	if (flush)
 		kvm_flush_remote_tlbs_memslot(kvm, memslot);
-- 
2.42.0.820.g83a721a137-goog

