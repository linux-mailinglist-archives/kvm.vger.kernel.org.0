Return-Path: <kvm+bounces-10343-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 119A786BF30
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 04:00:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 99CE528614F
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 02:59:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C46213FBBA;
	Thu, 29 Feb 2024 02:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="J0QDgUnR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 864443D388
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 02:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709175512; cv=none; b=M4smkG7G5Es42F22lO4+enSGzOqlNSqctTiFzoWWnDAWTGrJ9y5Z3u09dda/z72ohPq2UUfqdOxzMU2Kb74ugrzA3WAgU5AfqjQXYq4M2Tlj6cb7Y4XJXlYD8/tkdFnLU4pjbQulNoQFqA06lczv33wUaexL4U5GxdMjQ74WSdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709175512; c=relaxed/simple;
	bh=ntmqS432o2IecDkbveS88A7jvkU9H2eMDxulzMNm4uA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SR2RoSp9JnWYjLbL5ySciOUrm0RvGPmk3ZqvozJFHp9tNFKA0xPx8T/XoTm2jL3o+cC95o6BmERbSyu2nwFQ6OY2BCQ43xX4zXiPiYgosMVblF30Sqrdk3fd+qfUP/xX2SQIm5+h9of164ViP3DkSKF5NXCw44je+soYtgwLkO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=J0QDgUnR; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-6e581ba25e1so334853b3a.1
        for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 18:58:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1709175510; x=1709780310; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ni2jT8j4ual03uOxDJftxXgB5iCIPPNSKtQ7Mr+vnE0=;
        b=J0QDgUnR/OeRtU1ByzEXvqoTR5PYVh3RUK9jBS1tOfws8S1szIMaZRyDiVs0rr0iH/
         nwpSRRKmq79Fo67RgPTkzk1X8T0ksPR5oCvPFX9gLjJahSEEOahzeZRcjoaz2hdZYU9e
         hdgEB1OZIYjHwfILSifxU9lPSTLXxfy1R35oQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709175510; x=1709780310;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ni2jT8j4ual03uOxDJftxXgB5iCIPPNSKtQ7Mr+vnE0=;
        b=qWSHrBDndpFtNXIeSqEvBmnbe+kVm37+HgYepQBlB7PLrC0UDs3vUhk/GPRsZ3WkSO
         6TS7pZRxMtt22OQcNnnyvwy2bUcb3hR9Wn73X557G+6Bm3RhiRgd1QX35OHBUf1TW4DC
         ewvuwn7x4s4fTWV3qoEmIKthZg9vNy7kA2asC//Hfz9EsaGfWy2dDxYajFkAM996uGvE
         XNC8g98GGitElfjeo0GmhhfDLTt8FWaiutY8CiEUpb2QSoGctE0Q/3waDVgE8GCfcGOZ
         13DqEOhqePQgf/lVs5Xr9g+harnP+hGcFqNWYfMnrcmnszHW3rIaJyfyIXsw+FSocC5J
         g7rg==
X-Forwarded-Encrypted: i=1; AJvYcCWdRvZp3rD7jlBJjNIyJNxQl1aCUWQVBEhEtDJp2T0+OD9DPNu7YRbvuICsh0yNGtAK/Gtf56oXtKaAIVDz5POJnP9Y
X-Gm-Message-State: AOJu0Yz8o/7VnVX1CCeEPmscBoGzI+1PgwoutUzysEv5FqPewxCiCNn8
	l4FfScEbLCmoBwYNPNju7A+dmpgQg4rUUI0ParJpRJ/q8hE2FUrZC4RN6KRlkw==
X-Google-Smtp-Source: AGHT+IFrTrtIz8ZueShqadVtdqzR++6dqKD8QrlfV9UFyrfW9Ry/CvODvFWbe40fOMGg2kbfHMju+Q==
X-Received: by 2002:a05:6a00:cc4:b0:6e5:37cb:64c4 with SMTP id b4-20020a056a000cc400b006e537cb64c4mr952284pfv.9.1709175509796;
        Wed, 28 Feb 2024 18:58:29 -0800 (PST)
Received: from localhost ([2401:fa00:8f:203:f51:e79e:9056:77ea])
        by smtp.gmail.com with UTF8SMTPSA id x65-20020a626344000000b006da96503d9fsm167784pfb.109.2024.02.28.18.58.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Feb 2024 18:58:29 -0800 (PST)
From: David Stevens <stevensd@chromium.org>
X-Google-Original-From: David Stevens <stevensd@google.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: Yu Zhang <yu.c.zhang@linux.intel.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Zhi Wang <zhi.wang.linux@gmail.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	David Stevens <stevensd@chromium.org>
Subject: [PATCH v11 5/8] KVM: Migrate kvm_vcpu_map() to kvm_follow_pfn()
Date: Thu, 29 Feb 2024 11:57:56 +0900
Message-ID: <20240229025759.1187910-6-stevensd@google.com>
X-Mailer: git-send-email 2.44.0.rc1.240.g4c46232300-goog
In-Reply-To: <20240229025759.1187910-1-stevensd@google.com>
References: <20240229025759.1187910-1-stevensd@google.com>
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
index 66516088bb0a..59dc9fbafc08 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -295,6 +295,7 @@ struct kvm_host_map {
 	void *hva;
 	kvm_pfn_t pfn;
 	kvm_pfn_t gfn;
+	bool is_refcounted_page;
 };
 
 /*
@@ -1270,7 +1271,6 @@ void kvm_release_pfn_dirty(kvm_pfn_t pfn);
 void kvm_set_pfn_dirty(kvm_pfn_t pfn);
 void kvm_set_pfn_accessed(kvm_pfn_t pfn);
 
-void kvm_release_pfn(kvm_pfn_t pfn, bool dirty);
 int kvm_read_guest_page(struct kvm *kvm, gfn_t gfn, void *data, int offset,
 			int len);
 int kvm_read_guest(struct kvm *kvm, gpa_t gpa, void *data, unsigned long len);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 984bcf8511e7..17bf9fd6774e 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3184,24 +3184,22 @@ struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn)
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
 
@@ -3221,6 +3219,7 @@ int kvm_vcpu_map(struct kvm_vcpu *vcpu, gfn_t gfn, struct kvm_host_map *map)
 	map->hva = hva;
 	map->pfn = pfn;
 	map->gfn = gfn;
+	map->is_refcounted_page = !!kfp.refcounted_page;
 
 	return 0;
 }
@@ -3244,7 +3243,12 @@ void kvm_vcpu_unmap(struct kvm_vcpu *vcpu, struct kvm_host_map *map, bool dirty)
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
2.44.0.rc1.240.g4c46232300-goog


