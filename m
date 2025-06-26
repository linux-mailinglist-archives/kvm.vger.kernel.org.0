Return-Path: <kvm+bounces-50806-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 49D87AE96E8
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 09:36:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A7D717B60EC
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 07:34:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B50A225EFB7;
	Thu, 26 Jun 2025 07:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="l2h925tK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 486EB25D546
	for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 07:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750923317; cv=none; b=YiJ4TTncSrYse7KYNbPZkHw+VW5+89a+WSY6FYmAYZ7xHCZdhIpYr+xLyuARD9hLFRMLTXOdR7DxKPojAQRN6SwYL0pc6miSLRu8rB1UK/9KLp/8Dv7yPwFi8b9D+JzaKnno8x6oOrcMMNEFQbkHOyiDaY7qtxOy9KY+5ZpoBsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750923317; c=relaxed/simple;
	bh=2OB+04msUxf+YuX/WMJXSqKlVIWXpY6QC3RWqMbf8AY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OHeC1SPUY/8+jSAn1glsq4q9Y1m7+0AoAV1uwm+cu95vIEwdyqq4n6P/cHzsgWPo5UIHEJAev7oS8jczTJXH4nlBulvy4Uth9d1wu9US2xMiVLzyAfQiaacVmfJFWb+0fJ+kpISAfkPEFZSPHxxFfhMf4UGDFZFfar/yg+ZvBbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=l2h925tK; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3a57c8e247cso498656f8f.1
        for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 00:35:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1750923314; x=1751528114; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TN6EDtpGAooBh3mWIUxQOQde4ZcWTOZTfXFRnvyNUEM=;
        b=l2h925tKP+v9ir8v08KJGD4DIJZoGCKktSB0DiUM3KYmIN0w8dCM0bdSO/fzNOaaKM
         L3RCO22AYyzymMmiCcD75m8b6/XgYNY2uUDKlI6Wd8RxDbMHJgLFyjdIBhmlputUKfn/
         N7Mw2+hmweMae5htqlfqP5NdnMtJj5G91hDAc44SYX797YJiopKgrpe0DVS6RtMPOfzh
         Qne1MKIDkwhZnFjXZ0etShVnwqv9kV5xDgU1iHQexMzXo/oYaDE6xFM1gO+MVF2dcjnS
         PfwmLDjzhIttqNBWhpyWyPLlBThiMoj3uLJx7uW4X3JW5dh/MDZmKcH9tPraX/8XA1He
         iDLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750923314; x=1751528114;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TN6EDtpGAooBh3mWIUxQOQde4ZcWTOZTfXFRnvyNUEM=;
        b=gO4K8MhkYxlc4WqiVI6/QgNixg7L3tWWgaf3KHu/TembD+XZaOlk/bMIs3jtgG8w4z
         JUnyCpPjm/m7GokpEvk9p8gs24ZNqR2XTVR7B9q1qN6LVXyiDbxfAXAH6bzasakbDion
         7OZFs0NqxlZwZ0pcaVf/TwHxOCQ0s301uANCTKDt/90hZJFUX3DRiwSqRK47xgYmDUQk
         n2Q7uzJjdfte8Ltc+Vk641HTS8rtJDwhC5GqFeOzQHLldGLsEWnSbf8LKueLQI134ZIB
         GaUt9whVMPQM27luM2cLua9nvkvpEeyF3gKi3IP18peFu0IxEROggeT1Qp4JJTdrVRw0
         qssg==
X-Forwarded-Encrypted: i=1; AJvYcCXv1aoHrlyyhYwyJTzn32TJ/K+gUS0ohbCBnTMYGyerqB9BzPwKF2UWY2mBkcAHDZWAcvM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw3gELvwe4zGCWRCxtiN5k6VhA7eMpo6/KD54QAk4mglHjDvWHN
	zzjOVL1gF/E7w2+UX0yC9ZpVTkJr6SnIB4qBA1hgWTex+jAPiDtJ0KJpxHifhUTdX1E=
X-Gm-Gg: ASbGncslZphy6Muc8ILuHj8DGhmarTlMoUpICP5aavordMz4irSo/eh0zZhYDtlQrCU
	F36lCSU7GxWRHkMxp7mopyDybslXcywiC1jQ9NZzLFrncM+nw9CwRyqp4XGH56LEk046wCEQWpU
	HugiUanS8inYZG3Nu2edPlEtSGkMnIsqzumw1r5DzUGmMvk91y2DtXWVGhBEl/YsVVwoHHH53Db
	RByOzB5T3Bb2on3R76XtW6g52Whr421I9BeNKoyr1TbgfwFl87Fb7qGuH9VtqM+Ila3q4PcDrGz
	zmaTqS6TZIshFp+9Ss/UIogzpQ9W4uggsdQKL7Pe67kGnuwYMRerpNQVB93VzOF3gN76XDXG2qI
	uSLZ5ldnqLsvlLJD1jh/MxdY2M2t1mvS1FZKdxDbUBvRZbAAzJy0cb4A=
X-Google-Smtp-Source: AGHT+IFX1IRWIqqIFOoK/JNpGVs4ynolijLEuwcrjDtZngF94z7bTA0HM9y0jwT9HR9xmHEs3Xn7ng==
X-Received: by 2002:a05:6000:26ca:b0:3a5:2694:d75f with SMTP id ffacd0b85a97d-3a6ed651c5dmr4848875f8f.52.1750923313630;
        Thu, 26 Jun 2025 00:35:13 -0700 (PDT)
Received: from nuc.fritz.box (p200300faaf22cf00fd30bd6f0b166cc4.dip0.t-ipconnect.de. [2003:fa:af22:cf00:fd30:bd6f:b16:6cc4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a6e80f259dsm6692451f8f.50.2025.06.26.00.35.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Jun 2025 00:35:13 -0700 (PDT)
From: Mathias Krause <minipli@grsecurity.net>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Chao Gao <chao.gao@intel.com>,
	kvm@vger.kernel.org,
	Mathias Krause <minipli@grsecurity.net>
Subject: [kvm-unit-tests PATCH v2 13/13] x86: Avoid top-most page for vmalloc on x86-64
Date: Thu, 26 Jun 2025 09:34:59 +0200
Message-ID: <20250626073459.12990-14-minipli@grsecurity.net>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250626073459.12990-1-minipli@grsecurity.net>
References: <20250626073459.12990-1-minipli@grsecurity.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The x86-64 implementation if setup_mmu() doesn't initialize 'vfree_top'
and leaves it at its zero-value. This isn't wrong per se, however, it
leads to odd configurations when the first vmalloc/vmap page gets
allocated. It'll be the very last page in the virtual address space --
which is an interesting corner case -- but its boundary will probably
wrap. It does so, for CET's shadow stack, at least, which loads the
shadow stack pointer with the base address of the mapped page plus its
size, i.e. 0xffffffff_fffff000 + 4096, which wraps to 0x0.

The CPU seems to handle such configurations just fine. However, it feels
odd to set the shadow stack pointer to "NULL".

To avoid the wrapping, ignore the top most page by initializing
'vfree_top' to just one page below.

Reviewed-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
v2:
- change comment in x86/lam.c too

 lib/x86/vm.c |  2 ++
 x86/lam.c    | 10 +++++-----
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/lib/x86/vm.c b/lib/x86/vm.c
index 90f73fbb2dfd..27e7bb4004ef 100644
--- a/lib/x86/vm.c
+++ b/lib/x86/vm.c
@@ -191,6 +191,8 @@ void *setup_mmu(phys_addr_t end_of_memory, void *opt_mask)
         end_of_memory = (1ul << 32);  /* map mmio 1:1 */
 
     setup_mmu_range(cr3, 0, end_of_memory);
+    /* skip the last page for out-of-bound and wrap-around reasons */
+    init_alloc_vpage((void *)(~(PAGE_SIZE - 1)));
 #else
     setup_mmu_range(cr3, 0, (2ul << 30));
     setup_mmu_range(cr3, 3ul << 30, (1ul << 30));
diff --git a/x86/lam.c b/x86/lam.c
index 1af6c5fdd80a..87efc5dd4a72 100644
--- a/x86/lam.c
+++ b/x86/lam.c
@@ -197,11 +197,11 @@ static void test_lam_sup(void)
 	int vector;
 
 	/*
-	 * KUT initializes vfree_top to 0 for X86_64, and each virtual address
-	 * allocation decreases the size from vfree_top. It's guaranteed that
-	 * the return value of alloc_vpage() is considered as kernel mode
-	 * address and canonical since only a small amount of virtual address
-	 * range is allocated in this test.
+	 * KUT initializes vfree_top to -PAGE_SIZE for X86_64, and each virtual
+	 * address allocation decreases the size from vfree_top. It's
+	 * guaranteed that the return value of alloc_vpage() is considered as
+	 * kernel mode address and canonical since only a small amount of
+	 * virtual address range is allocated in this test.
 	 */
 	vaddr = alloc_vpage();
 	vaddr_mmio = alloc_vpage();
-- 
2.47.2


