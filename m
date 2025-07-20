Return-Path: <kvm+bounces-52946-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 27D24B0B31D
	for <lists+kvm@lfdr.de>; Sun, 20 Jul 2025 03:59:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A90AF3BDA58
	for <lists+kvm@lfdr.de>; Sun, 20 Jul 2025 01:58:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6784813AD26;
	Sun, 20 Jul 2025 01:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mIqwpIYY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31F9E1F5F6;
	Sun, 20 Jul 2025 01:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752976730; cv=none; b=RK9RqEXP3LOQQ/YlHsTOCwgOo+6EBYsxoVJSNPaF050TuV34uoIQboWqC2NdyovaIMjwhi2tjiu5GZm+uyEGcHLCUvR1wFrI4xL3HC3uhw034ygj7Nuy9BWZdSjkj1YDcvBNu+BQ/mwJik2RffM4sghJjNkynuLLeXc1nWxp56o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752976730; c=relaxed/simple;
	bh=E9aEmukDszqfxamabuUKz2apGXeYmBqs0kM3psRWNvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PKBQwnzA7wbT+Jq8WzSZp6FAKiYJO67z20mue61sRPsr58usyOX5qbXT6ixL1zMOGvmL9cX0kzh0pORvvGpcBEn3Cvomk/PeWYlvwDpFok460EBxXlaiRD9tuAqO+MbuXCe0XAt8tl2OjAnHlU+MozwGWlRELDBXgWuMBx29Y4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mIqwpIYY; arc=none smtp.client-ip=209.85.128.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-7196cb401d4so6149617b3.3;
        Sat, 19 Jul 2025 18:58:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752976728; x=1753581528; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Gx3r2VCJgOwmSqwpv6M66u1+Yj9MqPzZFlgI2IlBqzA=;
        b=mIqwpIYYVpwuyIxZ8rmO1tlq7JxC2tGtgF9hm+PoGzPgylwkBfTxM85231fK/y57kE
         fatavepz+ir7kACXJQd6zUok9Z2evsoMBXluv6TDC79ZBEISulA/BEdPbeNCGu4maq9d
         d1JhwnFnmvw5D24qg+AZpZDUbMmqtM1n4BXLw4tdjsptG+kWqdVoAYHwibir+6PZVZVx
         +XS4/ncr191SyM3nZVZpRdUbh/SKOopobi+45Yjz55HYDpCEmKCz4uPwf3qkx/vpEqJl
         hQp9TxUQ5Kvlui8S9/BLuNEmALVM3mZ5bBezrfAd+HCTxA8N5qmKm4rA+LlgsaGNIHLB
         Mdhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752976728; x=1753581528;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Gx3r2VCJgOwmSqwpv6M66u1+Yj9MqPzZFlgI2IlBqzA=;
        b=nPmyuqZVTmCYpLGHER+XEIe51TrLXeh7l4wB9OjrUKTcKXhCcihIWaw/al4e1BdcIZ
         Tdm00eEJJG7mLn8DiLLxAjklud7AuD3xfv6pUH9uyJzOPrJRwydWjROiGnkieV1Wy4Vk
         feVvP0De8aUemX+f98sHwNFwta4bHUcCDs7CraXYStlup6vtzmUm9iS2V5RomKWXBh0C
         K9L/kMrPDdczd/WOjTsFvbC/+jPwxnp2iN/M0xvowN9uqqkDs4mGNDBhq0rCkgXw3Mr4
         qfL5JTQj5xVfgtUu8OTNviQBZac/z349WNQQxEox0HPnPqRSSSjkpFgPwTES3fNWPQ0s
         nVhw==
X-Forwarded-Encrypted: i=1; AJvYcCV7+xvp5pq+wqVQKnIGdkq74fD5wT+12SJRNURp2umHinmOvhNOuZo6jOXodNUeokF1ZUU=@vger.kernel.org, AJvYcCWs7rzQZdQ/pV3EFb8I2l3BVJcD0A21CUSujJRH1ck6ryytA1ABTREu25xYphTVwvAot2pyboWVEfOBn16m@vger.kernel.org
X-Gm-Message-State: AOJu0YwYHct2u7o7Ch/erBwgo2uLI49pmj8UCgcSHc9Nu6ElO9+bc32g
	6kC3kWS8bo8FGDjqhnE7MYqGTeNWWVnm5U/qYWPI16E+C7/B3tjPy3Xg
X-Gm-Gg: ASbGncu8tL/iI25tG/ixdQLFoBPZCmPpmAetNgsT5S84ttn5Wvjldm1SpiizAGxpGjA
	/cNhFL57U69vBXPPJUyCikdjZiB6Pc02JCAZr2mrNW3Mymp87iBH06YRyftDcVKUG+ZnATg9tCS
	L196Y4lct+EN36a20oS616NjBg+A429VMVfCwEAkifOleV5lgYTkJcqThW709omcN3SUTE0mXk3
	5L9Aequfd28AjFlxdq+jvRUpEvumKvd4UIQuFhANsDGM+VRkohxjBiVrDeKgC5vL4bTHmxO9yOG
	xyWnUFm1eWwNFEFvLns7N5cvCp9TAXJ5mGo7pvL23HPHGhA+a0VbVYXNaeN5fYD7foYbx6rXo90
	Lctz7lXOho/PvYu2ZdofJ/gBsv/e+ZX6/LLos+bru1x6yg45KohGRT7ljHYx84jsD+hY0
X-Google-Smtp-Source: AGHT+IEizgfXcw1X/zAcOf51TDVB56VoMOdIyvLX3hsit/w346/Bn+iYEToTpCHB1YMhFJlgpKfmPg==
X-Received: by 2002:a05:690c:48c1:b0:719:4c96:f13a with SMTP id 00721157ae682-7194c96f462mr131003647b3.17.1752976728134;
        Sat, 19 Jul 2025 18:58:48 -0700 (PDT)
Received: from localhost (c-73-224-175-84.hsd1.fl.comcast.net. [73.224.175.84])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-719532c81d9sm11493017b3.73.2025.07.19.18.58.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Jul 2025 18:58:47 -0700 (PDT)
From: Yury Norov <yury.norov@gmail.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Yury Norov <yury.norov@gmail.com>
Subject: [PATCH] kvm: x86: simplify kvm_vector_to_index()
Date: Sat, 19 Jul 2025 21:58:45 -0400
Message-ID: <20250720015846.433956-1-yury.norov@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use find_nth_bit() and make the function almost a one-liner.

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 arch/x86/kvm/lapic.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 73418dc0ebb2..6c4ec016de6a 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1106,16 +1106,10 @@ EXPORT_SYMBOL_GPL(kvm_apic_match_dest);
 int kvm_vector_to_index(u32 vector, u32 dest_vcpus,
 		       const unsigned long *bitmap, u32 bitmap_size)
 {
-	u32 mod;
-	int i, idx = -1;
-
-	mod = vector % dest_vcpus;
-
-	for (i = 0; i <= mod; i++) {
-		idx = find_next_bit(bitmap, bitmap_size, idx + 1);
-		BUG_ON(idx == bitmap_size);
-	}
+	u32 mod = vector % dest_vcpus;
+	int idx = find_nth_bit(bitmap, bitmap_size, mod);
 
+	BUG_ON(idx >= bitmap_size);
 	return idx;
 }
 
-- 
2.43.0


