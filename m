Return-Path: <kvm+bounces-10339-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C297286BF27
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 03:58:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 57FB01F23FC6
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 02:58:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E6353771C;
	Thu, 29 Feb 2024 02:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="KgjD/AlN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47E10374EF
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 02:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709175494; cv=none; b=q03bLEJWgPN+7cJZkFf2b6sO/nGFkZQu4U72L61kD730iAjQZ4JQJae+4c5ExSajWqRhanUz0swTyTMGqwQFiYUXe16IMwmDvXEaKELCHYB0DwU8IAUB1Xv9CAM8FZlTuvKT/6mOLZEZvusenXHD87T1vahBdaaTy9yBoKskjOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709175494; c=relaxed/simple;
	bh=4TOA+r5FgQu9r7XyUG+jnEXfKZGB1J0B4LAWQX2lpPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rnQfjbDavoT/NG/dP7IZNp4Uy596aevM/jFq6dJhkZMqrDLvYM+U76BbvqGEir6m7VYBBlcIAVmeDVy4rdxFTt6ThkrWReUurGos5cv4V+xqbMn+a7n6L9YmGHPzkgmpmzfT/W/k75FYWW+7f8FtCVSXjlGSPG5vAZyVaf0JSpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=KgjD/AlN; arc=none smtp.client-ip=209.85.210.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-6e49872f576so218097a34.1
        for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 18:58:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1709175491; x=1709780291; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h8gBHZBcb2YMWItHZ5v52k75LYEpNNA/oZohojyoTqA=;
        b=KgjD/AlNkquVx5HzOsnwQTVby5PEbzF8CT9VtOG6+9VTjGFd1/M9KSvgEKOA9xLvbb
         BY/KVjfOgJj9vGOhDs1ghheKsREuquRCGywg9BMWydxuhwC64noIs18BAvNfI+ewTVlY
         z5rKjQEsjgaMHTB+CWbvJ3e3Tnr9onosiTpvs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709175491; x=1709780291;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h8gBHZBcb2YMWItHZ5v52k75LYEpNNA/oZohojyoTqA=;
        b=bVkpEj1D0TvCpfJVD1BQAuZl2B3jTHIbCQLjb0cUR9tGapU10PAHW/uojYW0641t7h
         RAposd/ZjY27lsnPRcK6bnaRbKvVvW4aGyidcljZUODtqRK9ytdxHevxwi0cg/b7uob3
         Bg13FByAYrsEkIj5tMdNZLoSVfzgHsviQPVy85XbqKpOnsq5MoV4RoRPJg1kFujUKMG2
         Qj3RDSw7vX1kSJ8Gr5ndTYCdim0K9rYfXQInnmO+4t9+4kp5OuyKidLHia0jfTgq9zKN
         +iySSTiL+3FG6a73kflZmPBkx9ktY03IjBBBLSMOqdDG2jbZK3qbNX3GMbyCpobll+UO
         Z/Rw==
X-Forwarded-Encrypted: i=1; AJvYcCXd5H2DLqORcixF+i0C1P/xvs0o8RorsZogBul8BMgbCZXFOZW131flXi+Qnx/E1YGTd2HI1LU8gEZh2fqsFOsgavdJ
X-Gm-Message-State: AOJu0YxhgABPF/YD4XLEwfZUOCffPN0dSasZTfdOMjEBDApOaTPr6ewt
	C4sj/tb7+AyAUbP20bxEhdbbtt4vU7qs79C+UCEFBkZotfxVIORZqZoFYfw7yg==
X-Google-Smtp-Source: AGHT+IEzcIYIV1hTiSnL4EPI23CXk8BeKzYnMBwtI8PGGd225Hl71snn2MsVWt1anzA1zrdbxElYnQ==
X-Received: by 2002:a05:6358:6f12:b0:17b:c624:b0a1 with SMTP id r18-20020a0563586f1200b0017bc624b0a1mr1060447rwn.23.1709175491359;
        Wed, 28 Feb 2024 18:58:11 -0800 (PST)
Received: from localhost ([2401:fa00:8f:203:f51:e79e:9056:77ea])
        by smtp.gmail.com with UTF8SMTPSA id r37-20020a632065000000b005dcc075d5edsm190825pgm.60.2024.02.28.18.58.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Feb 2024 18:58:10 -0800 (PST)
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
	kvm@vger.kernel.org
Subject: [PATCH v11 1/8] KVM: Assert that a page's refcount is elevated when marking accessed/dirty
Date: Thu, 29 Feb 2024 11:57:52 +0900
Message-ID: <20240229025759.1187910-2-stevensd@google.com>
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
2.44.0.rc1.240.g4c46232300-goog


