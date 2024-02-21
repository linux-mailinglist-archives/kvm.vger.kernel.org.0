Return-Path: <kvm+bounces-9275-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 87E9185D148
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 08:26:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 36D4F1F25550
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 07:26:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 943E43BB3D;
	Wed, 21 Feb 2024 07:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="Jc1WSE5W"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f52.google.com (mail-oo1-f52.google.com [209.85.161.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3604E3B794
	for <kvm@vger.kernel.org>; Wed, 21 Feb 2024 07:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708500361; cv=none; b=TEkJ4e2LYeaUl5bWT2Jm6cL0EM2D3zcNnM9LUg9v1k3UZqCT8u/pcUdQm4yDEb3n4P+tQ9vaEBsRGcqa2S3uSNneYU34zhjg0FU60jtTaoqaffA1GkWRjA9seRp4bsSBBLR+29kZ9mzN+cpgizUSkNy1nnyfXjcFhvyYZb6Ikfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708500361; c=relaxed/simple;
	bh=ts94nRAA8qijZ1+V+8RhVz7hYImR2xwd7IhA+JpQbfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Csy6SuQ2AC47VTafr2kvu266eDe8m9R0NkP8gW9dDXh4ROKzK4sZq/CnEhBbr+r+AnoV/Bydy04ZzgBkVyXacWYkTidfOZfL5xN0sVHYuKd/DpjTyV+BXnN62ELI5FIgoP+YvYul5RfxiKGizCoOrkjy+mjPE7vLGx71/wb5TfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=Jc1WSE5W; arc=none smtp.client-ip=209.85.161.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Received: by mail-oo1-f52.google.com with SMTP id 006d021491bc7-59a87156cb8so1983987eaf.2
        for <kvm@vger.kernel.org>; Tue, 20 Feb 2024 23:26:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1708500359; x=1709105159; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H+hdGBpVbr7bFPAdmaXUhe5OHdgegQxKZy+RG2n/NC8=;
        b=Jc1WSE5WpIABSh5VOgxQcE6TojJuRVlPipKkbMk4IHiYg99vpx4izo2a29AGvppyk4
         Bw3lpYKdEQi9f+dlcyXa/3v8TmplYX+rCnwaWlXD6E7sMPuLJZNbA82x+/ArIVJKwLiW
         H5L0jcxxE/6ViB0cwmIg1NgEGuiKfNcewhsSE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708500359; x=1709105159;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H+hdGBpVbr7bFPAdmaXUhe5OHdgegQxKZy+RG2n/NC8=;
        b=EjmfvBMFflnEoPKyhYm6ZfuQzydRHv+xdwXlnCJ4oaJGZoF+KJLfann0j5sUQdghCL
         B+UVJr6M2zsuJ+aV0HMLe9U2frCPJbUOvAih+kuF2D1SP767mNnpyWUJs+6OsSqNDfKN
         oPLDCjCgbxpdvWsNzgQRKD6I1/LUD1wLnHf2LZqMULHFjVvEbm6BACY1jJgTDT5VtAVU
         B8sPQ+2Tkhqw9TPCLU8oV1YH8f5Fig1FcPSN6Sze5ABlYpU7YIhAHb05D5BOE9OtZSRp
         DkKn594L28V8+644giSbBYT/BQkH+2rftdEfykiY+5FWtcCrTUB8m4njc8eQT1z+ILOd
         2ODg==
X-Forwarded-Encrypted: i=1; AJvYcCXiBYEHlFAfa0rnR7XN1Mxkgg4xlrPU/WemGOfWBTNWtcGsX64vBHf1UcQ4pfJ/dUaPRftTOy/qFLiEX6/LJZZIfr3W
X-Gm-Message-State: AOJu0Yx5+fuF9y272cr3ffiditXMgK+90oDGdAGXD+1LKC1xpNoQ5KPz
	t2OPpYG8i8jlP0O4PQTx5oL5B30zd0XArMTciG02/fDyzIZFJsQJif3IqghldA==
X-Google-Smtp-Source: AGHT+IE2G1nq+fsRegEtXbcZKijUFBnow+nd04+2OKpMuJUnEvCAkTRVdFsn5NwLBnQPzSaj9SDRPg==
X-Received: by 2002:a05:6358:caa:b0:178:c51c:7af5 with SMTP id o42-20020a0563580caa00b00178c51c7af5mr20488158rwj.32.1708500359251;
        Tue, 20 Feb 2024 23:25:59 -0800 (PST)
Received: from localhost ([2401:fa00:8f:203:b417:5d09:c226:a19c])
        by smtp.gmail.com with UTF8SMTPSA id u4-20020a62d444000000b006e2b23ea858sm8097492pfl.195.2024.02.20.23.25.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Feb 2024 23:25:58 -0800 (PST)
From: David Stevens <stevensd@chromium.org>
X-Google-Original-From: David Stevens <stevensd@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Yu Zhang <yu.c.zhang@linux.intel.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Zhi Wang <zhi.wang.linux@gmail.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH v10 1/8] KVM: Assert that a page's refcount is elevated when marking accessed/dirty
Date: Wed, 21 Feb 2024 16:25:19 +0900
Message-ID: <20240221072528.2702048-2-stevensd@google.com>
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

From: Sean Christopherson <seanjc@google.com>

Assert that a page's refcount is elevated, i.e. that _something_ holds a
reference to the page, when KVM marks a page as accessed and/or dirty.
KVM typically doesn't hold a reference to pages that are mapped into the
guest, e.g. to allow page migration, compaction, swap, etc., and instead
relies on mmu_notifiers to react to changes in the primary MMU.

Incorrect handling of mmu_notifier events (or similar mechanisms) can
result in KVM keeping a mapping beyond the lifetime of the backing page,
i.e. can (and often does) result in use-after-free.  Yelling if KVM marks
a freed page as accessed/dirty doesn't prevent badness as KVM usually
only does A/D updates when unmapping memory from the guest, i.e. the
assertion fires well after an underlying bug has occurred, but yelling
does help detect, triage, and debug use-after-free bugs.

Note, the assertion must use page_count(), NOT page_ref_count()!  For
hugepages, the returned struct page may be a tailpage and thus not have
its own refcount.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 10bfc88a69f7..c5e4bf7c48f9 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3204,6 +3204,19 @@ EXPORT_SYMBOL_GPL(kvm_vcpu_unmap);
 
 static bool kvm_is_ad_tracked_page(struct page *page)
 {
+	/*
+	 * Assert that KVM isn't attempting to mark a freed page as Accessed or
+	 * Dirty, i.e. that KVM's MMU doesn't have a use-after-free bug.  KVM
+	 * (typically) doesn't pin pages that are mapped in KVM's MMU, and
+	 * instead relies on mmu_notifiers to know when a mapping needs to be
+	 * zapped/invalidated.  Unmapping from KVM's MMU must happen _before_
+	 * KVM returns from its mmu_notifier, i.e. the page should have an
+	 * elevated refcount at this point even though KVM doesn't hold a
+	 * reference of its own.
+	 */
+	if (WARN_ON_ONCE(!page_count(page)))
+		return false;
+
 	/*
 	 * Per page-flags.h, pages tagged PG_reserved "should in general not be
 	 * touched (e.g. set dirty) except by its owner".
-- 
2.44.0.rc0.258.g7320e95886-goog


