Return-Path: <kvm+bounces-9280-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CF44D85D155
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 08:28:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 83D941F23888
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 07:28:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DFC539FE4;
	Wed, 21 Feb 2024 07:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="Jq4+Atpv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67E2E3D3BA
	for <kvm@vger.kernel.org>; Wed, 21 Feb 2024 07:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708500382; cv=none; b=V3m1YsunwCK+D6ic8kX+VM9157ms10YzmX+TJuzmEZpbVHrs5zxyoHjUzdZSDLQju9NK11guh+/+7xtNJ2/tZyvi3d6DjbodjC53Z8nUIYSLUfGIjSKuRORAV56Up9fSFajKzmcyYW2tdV76iZsyV7hsHtIScUUTNQ+NW8RqYVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708500382; c=relaxed/simple;
	bh=vFAefepjz3E0t+04lpw2yPf+Nx3onOaZVt72QR755hc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YvAZfQZVt9gmbT7h90Fzn1d6rxXlGYLLWG+7Ole/TuDwYlSlFRVYKWHeMmh2UelDnROjODyTILSxvvkREE4E9gGzl1zqE6a4da5KAsyrgv5EY8/wkaT9160OP3QmHRnsisSBrVEEBKJ4ULzSDvTiaahA4dsVt90FTnaKH4OSSAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=Jq4+Atpv; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1dbf1fe91fcso25686655ad.3
        for <kvm@vger.kernel.org>; Tue, 20 Feb 2024 23:26:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1708500381; x=1709105181; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SWEaXNkEutzzfeWk4tkEh/aV9qyvddav9W73rpwAgUc=;
        b=Jq4+AtpvIVQHm1KD+bqb31WoXIM5dUi1NhCaP3jkfaFZZsASoi8BdExRvd7nc0QZnv
         Ji0iOqjQgIaGI0uUuYRR7LIqRLgYp7aMpsE+lXiD1KULIGkbTufz6IvKFC3RCKV3S50T
         FXkJEhMKhpElY6LJHinKL+6X5BRv7ItYYucm8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708500381; x=1709105181;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SWEaXNkEutzzfeWk4tkEh/aV9qyvddav9W73rpwAgUc=;
        b=GZicel39T5GhJNFlTFKU+pxc4ZdUxkMlfbjIwjelmFpbRG0bECFCdxXrNhtajVSgk9
         xSZwYfGVFmKa2f5tkt+HVTH0/uZi7FJKLpXbpKG9r61EMyHQhQXa2ndeOza7ll2KHoiO
         I8730LnejJEnTkXF3ZKFTBBEPNc+YvGhN08b3ghllYc0fg4bLkzy0pKJ73vPpnKio/0B
         3jLpXx4G1USqJfAOBKptqhtSp/gxkdL3ZiE08n136+UlzEEjQXjhyUYnGjp/CaRhRbz9
         ZabSeiWSgEvKTT7GWL3Px33Y/01mHHKT3xa8womZnAnQxN3oFzeT8Rg9Uton4KEww0Aw
         aMwQ==
X-Forwarded-Encrypted: i=1; AJvYcCVlntk+DQ4fSScP3wnEoQF6e4wJrSFKbR1wk7xwcek2tJV6N/LHaW722XM3i7wUp4OQKDo8ylM+tbQmUEjz2VD2TdFT
X-Gm-Message-State: AOJu0YztBdms/a0WQV2RHoJOx5NpyideI1VVAQO78p7wxuRVE9M0AO+R
	famDqd3Wben5kg+Be9D9X3qyCo9K3F7dAYLHYc6+QHz+pSvYIMZbVKqD3Z6stw==
X-Google-Smtp-Source: AGHT+IHTaM/Rw7dtF9Vc7sCfD1uYbTKNFQjI2s6I8Jpo/gJ3zxDAIPGiSzfjjSJYmob/3WCYbNzzWg==
X-Received: by 2002:a17:902:6841:b0:1da:1c72:2ca7 with SMTP id f1-20020a170902684100b001da1c722ca7mr17564758pln.29.1708500380788;
        Tue, 20 Feb 2024 23:26:20 -0800 (PST)
Received: from localhost ([2401:fa00:8f:203:b417:5d09:c226:a19c])
        by smtp.gmail.com with UTF8SMTPSA id s3-20020a170902c64300b001d93ba1120dsm7387923pls.200.2024.02.20.23.26.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Feb 2024 23:26:20 -0800 (PST)
From: David Stevens <stevensd@chromium.org>
X-Google-Original-From: David Stevens <stevensd@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Yu Zhang <yu.c.zhang@linux.intel.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Zhi Wang <zhi.wang.linux@gmail.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	David Stevens <stevensd@chromium.org>
Subject: [PATCH v10 5/8] KVM: Migrate kvm_vcpu_map() to kvm_follow_pfn()
Date: Wed, 21 Feb 2024 16:25:24 +0900
Message-ID: <20240221072528.2702048-7-stevensd@google.com>
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
In-Reply-To: <20240221072528.2702048-1-stevensd@google.com>
References: <20240221072528.2702048-1-stevensd@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Stevens <stevensd@chromium.org>

Migrate kvm_vcpu_map() to kvm_follow_pfn(). Track is_refcounted_page so
that kvm_vcpu_unmap() know whether or not it needs to release the page.

Signed-off-by: David Stevens <stevensd@chromium.org>
---
 include/linux/kvm_host.h |  2 +-
 virt/kvm/kvm_main.c      | 24 ++++++++++++++----------
 2 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 88279649c00d..f72c79f159a2 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -295,6 +295,7 @@ struct kvm_host_map {
 	void *hva;
 	kvm_pfn_t pfn;
 	kvm_pfn_t gfn;
+	bool is_refcounted_page;
 };
 
 /*
@@ -1265,7 +1266,6 @@ void kvm_release_pfn_dirty(kvm_pfn_t pfn);
 void kvm_set_pfn_dirty(kvm_pfn_t pfn);
 void kvm_set_pfn_accessed(kvm_pfn_t pfn);
 
-void kvm_release_pfn(kvm_pfn_t pfn, bool dirty);
 int kvm_read_guest_page(struct kvm *kvm, gfn_t gfn, void *data, int offset,
 			int len);
 int kvm_read_guest(struct kvm *kvm, gpa_t gpa, void *data, unsigned long len);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 6c10dc546c8d..e617fe5cac2e 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3188,24 +3188,22 @@ struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn)
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
+	struct kvm_follow_pfn kfp = {
+		.slot = gfn_to_memslot(vcpu->kvm, gfn),
+		.gfn = gfn,
+		.flags = FOLL_GET | FOLL_WRITE,
+		.allow_non_refcounted_struct_page = true,
+	};
 
 	if (!map)
 		return -EINVAL;
 
-	pfn = gfn_to_pfn(vcpu->kvm, gfn);
+	pfn = kvm_follow_pfn(&kfp);
 	if (is_error_noslot_pfn(pfn))
 		return -EINVAL;
 
@@ -3225,6 +3223,7 @@ int kvm_vcpu_map(struct kvm_vcpu *vcpu, gfn_t gfn, struct kvm_host_map *map)
 	map->hva = hva;
 	map->pfn = pfn;
 	map->gfn = gfn;
+	map->is_refcounted_page = !!kfp.refcounted_page;
 
 	return 0;
 }
@@ -3248,7 +3247,12 @@ void kvm_vcpu_unmap(struct kvm_vcpu *vcpu, struct kvm_host_map *map, bool dirty)
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
2.44.0.rc0.258.g7320e95886-goog


