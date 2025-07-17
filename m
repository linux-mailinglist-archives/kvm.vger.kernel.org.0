Return-Path: <kvm+bounces-52791-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B67B9B094F4
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 21:25:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E1F081C801E4
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 19:25:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36FBF302044;
	Thu, 17 Jul 2025 19:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j5h8J5hA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6B1C2F7CEE;
	Thu, 17 Jul 2025 19:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752780277; cv=none; b=ugxotg+qPedJLukaHjL81BkpFMan3ngzRiyXIgs3hIK5tgbLoTsxk/sbfqEMwVGt9LWtXG18TPuhle56SRE+2YPLKii0vw/Dv15WovyUGLX0uQTxIWb8x3XNHTvfXDpTOpHVKtzIWK9GJE8J8nVEkUcd0nSzmry8Zb0ulRGM/2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752780277; c=relaxed/simple;
	bh=sv4WTZuI911NdE+G2NOTUcKGiBy26of1/QBd7acTr1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SNALkKdLS9zF8PKxES41nUpiuVPFvVh/71+moLBfLhJB6OzgXh/4DozHdzCl6foou57oDm6Ua4FHKLwJMpyVUkmXmIBwwNk6I0UhAuo1jlO3mAF57TeqYXNfeR0loeyiMYpWgbSnaqJptpbGLe43Pux68p2SFTUxEKlpo1/eeUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j5h8J5hA; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-748e63d4b05so940794b3a.2;
        Thu, 17 Jul 2025 12:24:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752780275; x=1753385075; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y9F3ssPuPP3VoFXG4eDO52KgRaiof9vnRgeoiSXlcJE=;
        b=j5h8J5hAvDuh1XgmTUjtaBqpeNMb8dvHDsB/AkpJuXXluxhw8A+nUCpC6xZiO6OqlE
         IJ5tdOab4agfmJD2ZyBP06TfnncT6wSKr3qzKLAqMbRsoI+3Rpq8uB8Txo+o+2SKwGIN
         c0hJJs1D7hdjBajvo4WiYOu4Xt/9ewlAiIFJPvfueBT5s0Ie/l9Qbsueup5PxLtLVw5v
         mCBSgHZoK8E+pN+SiDhSzug8cDTruN3kbRW1e6MP8q4SjSczH13iMPRw0zy0yN6Xveet
         A+a5gPqqjPjAF0s8rLIRDKbgIaTjPHPDdsp4beZ7qGpZa8DBv6/AZ6A3dJr/dB4+1buo
         iDJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752780275; x=1753385075;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y9F3ssPuPP3VoFXG4eDO52KgRaiof9vnRgeoiSXlcJE=;
        b=HdxkcX6GdtXsIQNAsQoqB7b4hXABDJfMSs0FJy0YCC93FQYxWYwPXZVYI5w4UwNIGI
         D6RVcgYGdepqbMyL4J2nTnx1ZvEjBoERamEbSJ9vGuSRnH8I+1kRwfCLFKa9Aedt3zOP
         rh0Vs3j8ClETIdjIzShVx4381tS2guBmC3aZb+WZR62cM0zEPrBJmb5m5W3dGdKaLxT+
         q058oeiKu8fHm+UOmt5g35/wiewDTol++mkL0Vk4DKKvyhMzd5OCzJNaeKjKiIK2XQMK
         SGCPFf/Y++FNmmet8+1lNKIpoPG455UWogt7Iz3O3Sf62iVPzNe0pKANAIAI4bcRcUUp
         za9g==
X-Forwarded-Encrypted: i=1; AJvYcCUxKA1uZ814T3fbc30jfBxjZ6udh+BNAwRqGTH/3CjNySkTRj2KfnBWJTLASxKX6YGfUBk=@vger.kernel.org, AJvYcCVLM/74tJSKenzLSN+MyI1kmQJCsYPqNDMpEvuYnr9bUlUBv3hITPCNsngj4+38O2X9uJWr4WxBzS49CRGA@vger.kernel.org
X-Gm-Message-State: AOJu0YxZNhkHNJn5/lP2ElmSjbn+/Cn2fF5tvj6R3VZvMEMahTxYf2Mg
	8Z6iTEE/gF8J+vye8Xyx6Er48pqH4FZ3iP1XV9yv/9K4ZKzIcmnnC1fw
X-Gm-Gg: ASbGncvYV9O+YWN+ZCTDyaDO8xrSUMVwr5DSOyYB+/TrapTiD3KYyH8rWnKw6B4b1BZ
	wNoQhXOcVdvKYpvKuAXgFgWXwJc9X9f0J+zsfzKxqq0ASNIQKLrvyUwzyj2KVDs9gvrj9YbbB6a
	g1Xsh7g8LS68jy3lLaxyq2Nshm2SGM5+nc25cYxPS0UfmizvTu+2UfajvXlMrgFGFmIg4DDeoRy
	y2DxlqSZnQadKIK9TzZMSceIf/BOzpL3hEPRbIwFPYThtxg6oRJojXqJalqp1l3/0mqVemJ5lde
	SAAekaiz5It5WkBujWg8PP7i/RPyD0JdbphP/mrUD+QmrXxPmguy8W9BaTl2fmZkqZwnwN8gx4V
	zcy8xAoS+G9rhF3DyUlgsergoumeJY6gO
X-Google-Smtp-Source: AGHT+IGV3ZbmQI7qK+TZ9Px70PLokdttIlZQa8u/GSYPXu3yqruqG3XYgZr8R3NYQ/dqMtvPkSO9gQ==
X-Received: by 2002:a05:6a21:e92:b0:232:813b:8331 with SMTP id adf61e73a8af0-23811d5b784mr12685064637.2.1752780275065;
        Thu, 17 Jul 2025 12:24:35 -0700 (PDT)
Received: from localhost ([216.228.127.129])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74eb9f1b2f6sm17245711b3a.99.2025.07.17.12.24.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jul 2025 12:24:34 -0700 (PDT)
From: Yury Norov <yury.norov@gmail.com>
To: Madhavan Srinivasan <maddy@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Yury Norov <yury.norov@gmail.com>
Subject: [PATCH 3/3] KVM: PPC: use for_each_set_bit() in IRQ_check()
Date: Thu, 17 Jul 2025 15:24:16 -0400
Message-ID: <20250717192418.207114-4-yury.norov@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250717192418.207114-1-yury.norov@gmail.com>
References: <20250717192418.207114-1-yury.norov@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yury Norov (NVIDIA) <yury.norov@gmail.com>

The function opencodes for_each_set_bit() macro.

Signed-off-by: Yury Norov (NVIDIA) <yury.norov@gmail.com>
---
 arch/powerpc/kvm/mpic.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/kvm/mpic.c b/arch/powerpc/kvm/mpic.c
index 23e9c2bd9f27..ae68b213f0f9 100644
--- a/arch/powerpc/kvm/mpic.c
+++ b/arch/powerpc/kvm/mpic.c
@@ -290,15 +290,11 @@ static inline void IRQ_resetbit(struct irq_queue *q, int n_IRQ)
 
 static void IRQ_check(struct openpic *opp, struct irq_queue *q)
 {
-	int irq = -1;
+	int irq;
 	int next = -1;
 	int priority = -1;
 
-	for (;;) {
-		irq = find_next_bit(q->queue, opp->max_irq, irq + 1);
-		if (irq == opp->max_irq)
-			break;
-
+	for_each_set_bit(irq, q->queue, opp->max_irq) {
 		pr_debug("IRQ_check: irq %d set ivpr_pr=%d pr=%d\n",
 			irq, IVPR_PRIORITY(opp->src[irq].ivpr), priority);
 
-- 
2.43.0


