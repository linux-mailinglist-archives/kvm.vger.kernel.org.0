Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AADF979A12F
	for <lists+kvm@lfdr.de>; Mon, 11 Sep 2023 04:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232836AbjIKCR1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 10 Sep 2023 22:17:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232645AbjIKCR0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 10 Sep 2023 22:17:26 -0400
Received: from mail-oo1-xc34.google.com (mail-oo1-xc34.google.com [IPv6:2607:f8b0:4864:20::c34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 625651710
        for <kvm@vger.kernel.org>; Sun, 10 Sep 2023 19:17:04 -0700 (PDT)
Received: by mail-oo1-xc34.google.com with SMTP id 006d021491bc7-5733aa10291so2676826eaf.3
        for <kvm@vger.kernel.org>; Sun, 10 Sep 2023 19:17:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1694398623; x=1695003423; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+u6FWrlXt53l0jioDQF0YNbKRi7RWqUmOraPqVJzqX4=;
        b=LEVmDlEUNW+jUNSXEqtCGWC6uLJhT5Q+YmIFV5OnzHm3q5GTaaU2V+N+Xo4iB6jhpi
         ie0ufgPGN4b/43F9zn6u/mlMpjM1r/NmVzO6dkckfPxhLRtL8/Hq6u/8JSNp4OoXWuDx
         z/h3i/6nvdIrkE8qedHmsFvBSyTYmhqh8/3p0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694398623; x=1695003423;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+u6FWrlXt53l0jioDQF0YNbKRi7RWqUmOraPqVJzqX4=;
        b=hBgQIrTavAIHfloUr5SGhhcbdEBXNou5NGazSUHiXH1Eu15IWhxw1EfXVIuZNiVqMR
         +IoxBhCDbtpejN+hKJaBAO9CLONp8EwTZ7D1N3fAeW0aMDhjX5QE0c4kdLHZhdtjy/0f
         tqpjcl+3sEc8cgtdNUwrZDY+WmcTwdBAztMPp0zhqwhJfdPs4suCokj6/nEkWf9ZsMgw
         PoalmSrs88LofVYOscJQ/pTowahcQjfPqrAmGabVdl5N86IzVRy94e2NLBC1/EeQK7OX
         eFeXPhe9bfBc0Je/2nY3uxAoWq16nEy8rBtwNT3fkybOw1LxzK+LypkElSOr08T8VszX
         g1Ug==
X-Gm-Message-State: AOJu0Ywi1JYNURlT/DGmYtAT+8ZIYXCKL5AEllBB/CL0j2wjW8L/EqYc
        8XdaedXiXZGFrgsLS5faWcbzhg==
X-Google-Smtp-Source: AGHT+IHwkesfgaOAHg5OyAz5O7jGYM7x2Y+BjVBilIwEqB9YCTVI0ogAM/gbH69qdUBkeeb1GRPk7g==
X-Received: by 2002:a9d:6754:0:b0:6b9:6419:1cde with SMTP id w20-20020a9d6754000000b006b964191cdemr9700883otm.22.1694398623724;
        Sun, 10 Sep 2023 19:17:03 -0700 (PDT)
Received: from localhost ([2401:fa00:8f:203:282a:59c8:cc3a:2d6])
        by smtp.gmail.com with UTF8SMTPSA id o13-20020a63a80d000000b0056c2de1f32esm4483868pgf.78.2023.09.10.19.17.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 Sep 2023 19:17:03 -0700 (PDT)
From:   David Stevens <stevensd@chromium.org>
X-Google-Original-From: David Stevens <stevensd@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Yu Zhang <yu.c.zhang@linux.intel.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        David Stevens <stevensd@chromium.org>
Subject: [PATCH v9 4/6] KVM: Migrate kvm_vcpu_map to __kvm_follow_pfn
Date:   Mon, 11 Sep 2023 11:16:34 +0900
Message-ID: <20230911021637.1941096-5-stevensd@google.com>
X-Mailer: git-send-email 2.42.0.283.g2d96d420d3-goog
In-Reply-To: <20230911021637.1941096-1-stevensd@google.com>
References: <20230911021637.1941096-1-stevensd@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Stevens <stevensd@chromium.org>

Migrate kvm_vcpu_map to __kvm_follow_pfn. Track is_refcounted_page so
that kvm_vcpu_unmap know whether or not it needs to release the page.

Signed-off-by: David Stevens <stevensd@chromium.org>
---
 include/linux/kvm_host.h |  2 +-
 virt/kvm/kvm_main.c      | 24 ++++++++++++++----------
 2 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 2ed08ae1a9be..b95c79b7833b 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -294,6 +294,7 @@ struct kvm_host_map {
 	void *hva;
 	kvm_pfn_t pfn;
 	kvm_pfn_t gfn;
+	bool is_refcounted_page;
 };
 
 /*
@@ -1228,7 +1229,6 @@ void kvm_release_pfn_dirty(kvm_pfn_t pfn);
 void kvm_set_pfn_dirty(kvm_pfn_t pfn);
 void kvm_set_pfn_accessed(kvm_pfn_t pfn);
 
-void kvm_release_pfn(kvm_pfn_t pfn, bool dirty);
 int kvm_read_guest_page(struct kvm *kvm, gfn_t gfn, void *data, int offset,
 			int len);
 int kvm_read_guest(struct kvm *kvm, gpa_t gpa, void *data, unsigned long len);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 235c5cb3fdac..913de4e86d9d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2886,24 +2886,22 @@ struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn)
 }
 EXPORT_SYMBOL_GPL(gfn_to_page);
 
-void kvm_release_pfn(kvm_pfn_t pfn, bool dirty)
-{
-	if (dirty)
-		kvm_release_pfn_dirty(pfn);
-	else
-		kvm_release_pfn_clean(pfn);
-}
-
 int kvm_vcpu_map(struct kvm_vcpu *vcpu, gfn_t gfn, struct kvm_host_map *map)
 {
 	kvm_pfn_t pfn;
 	void *hva = NULL;
 	struct page *page = KVM_UNMAPPED_PAGE;
+	struct kvm_follow_pfn foll = {
+		.slot = gfn_to_memslot(vcpu->kvm, gfn),
+		.gfn = gfn,
+		.flags = FOLL_WRITE,
+		.allow_non_refcounted_struct_page = true,
+	};
 
 	if (!map)
 		return -EINVAL;
 
-	pfn = gfn_to_pfn(vcpu->kvm, gfn);
+	pfn = __kvm_follow_pfn(&foll);
 	if (is_error_noslot_pfn(pfn))
 		return -EINVAL;
 
@@ -2923,6 +2921,7 @@ int kvm_vcpu_map(struct kvm_vcpu *vcpu, gfn_t gfn, struct kvm_host_map *map)
 	map->hva = hva;
 	map->pfn = pfn;
 	map->gfn = gfn;
+	map->is_refcounted_page = foll.is_refcounted_page;
 
 	return 0;
 }
@@ -2946,7 +2945,12 @@ void kvm_vcpu_unmap(struct kvm_vcpu *vcpu, struct kvm_host_map *map, bool dirty)
 	if (dirty)
 		kvm_vcpu_mark_page_dirty(vcpu, map->gfn);
 
-	kvm_release_pfn(map->pfn, dirty);
+	if (map->is_refcounted_page) {
+		if (dirty)
+			kvm_release_page_dirty(map->page);
+		else
+			kvm_release_page_clean(map->page);
+	}
 
 	map->hva = NULL;
 	map->page = NULL;
-- 
2.42.0.283.g2d96d420d3-goog

