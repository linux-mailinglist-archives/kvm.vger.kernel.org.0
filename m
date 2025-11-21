Return-Path: <kvm+bounces-64199-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FD17C7B3FA
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 19:13:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id E218C4ED742
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 18:09:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D49834F248;
	Fri, 21 Nov 2025 18:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ic7r6UGH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D85826F2A1
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 18:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763748571; cv=none; b=oTCj1DYki3/DbNbT6yVaJDNc+3lAdPoqTLCtK0nsUe+QTJO2dm0paatTNvalDOopC46Mei03t38VaWhLKFQccEDE7BOqstK3LJrYN7sQKVJu9O2CxSSk8sWLNARj6ZJ99s7GnPq5cLcbDgvu4OTUT5Tc3Wz3M5sjwi0UIoFzbBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763748571; c=relaxed/simple;
	bh=q0tRnmKflb/74DuR7ddJJXDDDoujOOdI1+hKkf528hs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WfweJNDY3sf/nNweKN05um9M1qowllTkmLztv0GkGjzOdVwdmCFMVShkw93cP7KU+iBC7WI5Omfu54JOmMjbxEWwsjnYCBmN+3acCifj//jiVsI6kHxash96cDA9iZIHYTihZF83K/QXg5VPjF+2XROE0XqISuULAbtulpHi9aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ic7r6UGH; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b62da7602a0so2199246a12.2
        for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 10:09:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763748569; x=1764353369; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=1CyLwNJhEGzJ5PvjrWl7GrPePFRwVA9zuOO++bFM+XY=;
        b=ic7r6UGHICIK5ka4Pw0BgNAiomBXoK+FUz9K090S8Lqq69UtFKWHwqC5UA+2XRouAO
         aqMga2RGrnAcPH5zPQdmBeoeK/8hHZV3m+G/vPxYeUgnazkC4NCwah+7efHz2eTHXOIv
         UZCqbYxrdsQmCmq7Vc4FYYV+d/zHd5DIVQvZEhD3Ug9LgjESasnn9RuMfetTeNiC643T
         fkJ0FadUUioaq9gEiqN2rBVzkTQTZT1CvCfDwT640bE+DU6pmxTcxQE9CIJT/S5cdc4o
         juLmo7jdKgyoGR9dPkpvNM2uPimC+kLV/PzYApA/+L95H6y+OA+yUO7RWnOdUTUO9bsn
         eksA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763748569; x=1764353369;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1CyLwNJhEGzJ5PvjrWl7GrPePFRwVA9zuOO++bFM+XY=;
        b=qr+7t/Dppgup65uL390hqWQ2I59S9L1KC5nBEkri/64tdpoZ4AKWYwDjrCBw2xvMDF
         SuOZBouqEDJWhgjLGgex8bJ5Mn7zrJquKhMK5AQTcCaVfNYaVWEnBT20xEGQnx7kbcH+
         5pLtktSBRj1NiC/gTgJ/Jy4HE6wKiipPX3tL0N+FI4sK3hGygYwAQEnXEn+8GbpJkAbk
         Gt9w8yTgsEz4PHJGP4OETzG4fZO7Iv4WI6rnuQWqeNJcQQwG5iofdqaiz08of7zff/Do
         vPsKtyOxKukQSPQf1GH/bktl1HONQXzthlHDkvW8pYrbAgZDbsNGZnDrV5vvHmwlajHQ
         f5rQ==
X-Gm-Message-State: AOJu0YxLTOgIG7jmD33UCJjlYQ4WLWXEazWN8e49beKNUXUtK9vt/rXp
	kFlCO9I1sQiKzHRVeH4OlwVYhUXvTZpdyzAvYbNAnXNM7jMHvmAxR2JNo+d2L2ygqLJyiU/7a3q
	Ngiwinw==
X-Google-Smtp-Source: AGHT+IEubJ0H8NDisAuOLlWiV1X+nOunuZEWMgQwuDBMF0rwUBbJipVX7aInsdJPWE+qhW030U4toRRqGy4=
X-Received: from plhi5.prod.google.com ([2002:a17:903:2ec5:b0:295:cf61:9590])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:19e8:b0:275:81ca:2c5
 with SMTP id d9443c01a7336-29b6c6cfe76mr39095695ad.59.1763748569411; Fri, 21
 Nov 2025 10:09:29 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 21 Nov 2025 10:09:01 -0800
In-Reply-To: <20251121180901.271486-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251121180901.271486-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc2.455.g230fcf2819-goog
Message-ID: <20251121180901.271486-12-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v2 11/11] x86: xsave: Verify XSETBV and XGETBV
 ignore RCX[63:32]
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

When testing XCR0 accesses, verify that RCX[63:32] is ignored (X{G,S}ETBV
have the same register semantics as {RD,WR}MSR);

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/xsave.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/x86/xsave.c b/x86/xsave.c
index 0763f893..254f9fde 100644
--- a/x86/xsave.c
+++ b/x86/xsave.c
@@ -45,10 +45,30 @@ do {									\
 
 static void test_write_xcr0(u64 val)
 {
+	u64 xcr0_alias = rdtsc() << 32, cur;
+	int vector;
+
+	/*
+	 * Verify that RCX[63:32] are ignored by XSETBV and XGETBV.  Use the
+	 * safe variants as XCR0 will be written "normally" below.
+	 */
+	vector = xsetbv_safe(xcr0_alias, val);
+	report(!vector, "XGETBV(0x%lx) (i.e. XCR0) should succeed (exception = %s)",
+	       xcr0_alias, vector ? exception_mnemonic(vector) : "none");
+
+	vector = xgetbv_safe(xcr0_alias, &cur);
+	report(!vector, "XGETBV(0x%lx) (i.e. XCR0) should succeed (exception = %s)",
+	       xcr0_alias, vector ? exception_mnemonic(vector) : "none");
+	report(cur == val,
+	       "Wanted aliased XCR0 == 0x%lx, got XCR0 == 0x%lx", val, cur);
+
+	cur = read_xcr0();
+	report(cur == val, "Wanted XCR0 == 0x%lx, got XCR0 == 0x%lx", val, cur);
+
 	write_xcr0(val);
 
-	report(read_xcr0() == val,
-	       "Wanted XCR0 == 0x%lx, got XCR0 == 0x%lx", val, read_xcr0());
+	cur = read_xcr0();
+	report(cur == val, "Wanted XCR0 == 0x%lx, got XCR0 == 0x%lx", val, cur);
 }
 
 static __attribute__((target("avx"))) void test_avx_vmovdqa(void)
-- 
2.52.0.rc2.455.g230fcf2819-goog


