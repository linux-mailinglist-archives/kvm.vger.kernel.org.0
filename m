Return-Path: <kvm+bounces-24474-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B3A809560B3
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 03:04:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 154B2B21E11
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 01:04:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D78021B5AA;
	Mon, 19 Aug 2024 01:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U+XAcUxD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f196.google.com (mail-pl1-f196.google.com [209.85.214.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0F1110A0C
	for <kvm@vger.kernel.org>; Mon, 19 Aug 2024 01:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.196
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724029485; cv=none; b=sb0SQB6htrIZX42JNvQ0BXwNn7yQYZQ3wIhKa7rjY/iTUlNZBlUh+mB1uXBWznNNjFRKTj32aLXNCsRU61tTeHaB7AnVwC4jZPYkeoLL4gR7FF5waqrcyD82pQStoEb5G64cB05PGEYRFkprs0G6ojIWmepcOfCad9vw/rolrts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724029485; c=relaxed/simple;
	bh=Y4/pvjoHgRFY6mCbKH+DK/2YiMcMuVOofpCFyOolc6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r59NraUXyN0I8ki7+0pGFD9Gojw3WLwLnH7vP84jeZ7uivRe0njlYDVuCgPBa91ZZCJrXTo7ufpj+AiwfxoqlR0lUxCEsP8xkPj6FMrk4DtrTg4xKO+7UafUov+57ubPs/LMUA4UCu5su7R3mie59SNSiJcd2i8T+IdymxVJc0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=U+XAcUxD; arc=none smtp.client-ip=209.85.214.196
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f196.google.com with SMTP id d9443c01a7336-2021a99af5eso12360875ad.1
        for <kvm@vger.kernel.org>; Sun, 18 Aug 2024 18:04:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724029483; x=1724634283; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qTe4pMoweYqHTL0yLGfICkCC/EGnVC9HjE1ZA80wPxM=;
        b=U+XAcUxD6iBDF96vfzHvvtK6HgMBkEuby8RGA9OzPePlvCl5c8PyYM+ibWd0PpSaq5
         ln+sXiqYeH6yQfhGnE+a66tC4D6UDSIdqTxhgEfXkQj3dtSnFZvm1TZ9wa2UEEjobJLj
         KE6mdZZ3FEkbpdc2COweE6K7SubaoCFyL9fw9KDDSBCJcBrTxOiKRlHjVdMTB46l/nOm
         QqTV+3I4RSUURjEbuPLy0QBirw0azmEIRVrfXOwv8Tvwb1a8Qa5m76Gm43VFeRhwX11E
         EXfZ8SR0xF1ovY7Qb6GCz53oJGzbaOYEazmiUOnYayjI8jjWYfOWo4YORMx2YukFP00S
         WW9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724029483; x=1724634283;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qTe4pMoweYqHTL0yLGfICkCC/EGnVC9HjE1ZA80wPxM=;
        b=kGX/xFTsBzR05cCSW96yBcsQ7MuBt3EdQ+Pj0SZOHWYITnpNLGObpnpCTQPVPCFQYJ
         wdcpg7gxiyBFGPdOXcyTQAbXOzHBjRYMRnB40+SdVWosMYvlHOZQSGLzAr4GQLhapmZC
         bqStCQ1NusNHfFlRiFE3yPd4VGjjMXH59ETOPGqDgfJAKdhmYSDLmV+Z4kn5P+4WjvnR
         uVGSPoHjyiudeZe7/c66zEl8rKL4KQ575rlSjjPrMWHLDvV3UpXDaJPvP3XQ8+qvR3ms
         dxdzuusR/rQbay6ZSsAiI5huhdhoBGuqsfz/tM6SysoqDL0D2wZlrTe3j3jHckMLB/gI
         6g3A==
X-Gm-Message-State: AOJu0Yw0fxKI/AUwuBIgQvVD/8HCsALh+KqPoEyB18+HU0TjKxbZbC9h
	P7lfg8I9CXZGB4o0Y10DgGdajJodSSziLBCxgd/mT/QvvrmV7TsktV0ZuFkm4Es=
X-Google-Smtp-Source: AGHT+IHiPWTS02fh9JtViKU1lI/aGNz1dHX3GgRgQMMl6xkpywWskON3Dw/tOBTkwXK3uph6/swewg==
X-Received: by 2002:a17:903:32c9:b0:202:bc3:3e6e with SMTP id d9443c01a7336-2020bc33fc8mr108220625ad.33.1724029482880;
        Sun, 18 Aug 2024 18:04:42 -0700 (PDT)
Received: from localhost.localdomain ([45.63.58.14])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-201f0375626sm54501495ad.156.2024.08.18.18.04.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Aug 2024 18:04:42 -0700 (PDT)
From: Dongli Si <sidongli1997@gmail.com>
To: sidongli1997@gmail.com
Cc: kvm@vger.kernel.org
Subject: [PATCH kvmtool 2/4] x86: Add the ISA I/O interrupt assignment entries of mptable
Date: Mon, 19 Aug 2024 09:04:21 +0800
Message-ID: <20240819010421.13843-1-sidongli1997@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240819010154.13808-1-sidongli1997@gmail.com>
References: <20240819010154.13808-1-sidongli1997@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

According to Intel MultiProcessor Specification:
"There is one entry for each I/O APIC interrupt input that is connected."

Missing this will cause the guest kernel to report some
warnings or errors when enabling the io apic.

Fixes: 0c7c14a7 ("kvm tools: Add MP tables support")
Signed-off-by: Dongli Si <sidongli1997@gmail.com>
---
 x86/mptable.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/x86/mptable.c b/x86/mptable.c
index f4753bd..82b692e 100644
--- a/x86/mptable.c
+++ b/x86/mptable.c
@@ -171,10 +171,8 @@ int mptable__init(struct kvm *kvm)
 	nentries++;
 
 	/*
-	 * IRQ sources.
-	 * Also note we use PCI irqs here, no for ISA bus yet.
+	 * PCI IRQ sources.
 	 */
-
 	dev_hdr = device__first_dev(DEVICE_BUS_PCI);
 	while (dev_hdr) {
 		unsigned char srcbusirq;
@@ -189,6 +187,23 @@ int mptable__init(struct kvm *kvm)
 		dev_hdr = device__next_dev(dev_hdr);
 	}
 
+	/*
+	 * ISA IRQ sources.
+	 */
+	for (i = 0; i < 16; i++) {
+		if (i == 2)
+			continue;
+
+		mpc_intsrc = last_addr;
+		if (i == 0)
+			mptable_add_irq_src(mpc_intsrc, isabusid, i, ioapicid, 2);
+		else
+			mptable_add_irq_src(mpc_intsrc, isabusid, i, ioapicid, i);
+
+		last_addr = (void *)&mpc_intsrc[1];
+		nentries++;
+	}
+
 	/*
 	 * Local IRQs assignment (LINT0, LINT1)
 	 */
-- 
2.44.0


