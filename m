Return-Path: <kvm+bounces-51545-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B9729AF87F9
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 08:27:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 735903B306F
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 06:26:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 803EE23C515;
	Fri,  4 Jul 2025 06:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="LtQWwl0s"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3794F24678F
	for <kvm@vger.kernel.org>; Fri,  4 Jul 2025 06:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751610399; cv=none; b=YY2gFZSgOEtvqw8cVIwpin+xd28dEFFH9s+T/V/mKse9AW0Rc8EKBvg4Gxlwf1D9u7zA96RpYeeuH6b+ImNfznHyuIRhezk8GKeuG9QHdmIU4j2+0rW7MBc72DIjsckpkywWVA8pmIYZwh9RV+P33LZWrOzmIP2YGo6Sqt8MqVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751610399; c=relaxed/simple;
	bh=zFqecOrZpi0qTmPninPaSLMJPvbB/zlF0VDVWE7x3aQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pbQJmIIvYlg9PhiwOugNzoUmeWx3Hz31Z5lRz5yJhY8022ud4wk89TnGAtodBYEdo6UfUClh5CHSLypYHqOtUiXGDCKc272+b/qijqdsfP078BnRgR3tWq6ItLWdU5cyZK0eFQvVv96wCfM7on4qc6ll8kMQcbCi7RAAuEEclWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=LtQWwl0s; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-749248d06faso579968b3a.2
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 23:26:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1751610397; x=1752215197; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2g/dwRr6sLGaceuHHFqckJ3jttaQlwjxhPJ/ULf0C3w=;
        b=LtQWwl0si2ZHFo394eqK410kyFb8tsW3HTyufWP7iaT2Q51DMxCanf+MfmA3R3MGoV
         iM3i5VNNKAErYgX2N15Fy0JEytL44CxGlOR54bjZHS+iDtCMcoDeFNLREgSUM7r3PoF3
         Mu9ovwUR2BoxSBATKgU0aJpA+K/RyLkfxYRMSnUEfUyfknnBlGNA49oY94FI2aYG3H6I
         b42JcHnmyrhdm0HYreMo3T8ShAzqDqD6mqZZOoYVegfBpVEDeYkJNwqbRCZXwG5Hu2tY
         dSDXCygU7t4Rynl0VgzzZ3kcAG3x/x48Z2hrJO6XpR/6dPLdZTgOLvXXvcc2b3zNYT08
         Lqqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751610397; x=1752215197;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2g/dwRr6sLGaceuHHFqckJ3jttaQlwjxhPJ/ULf0C3w=;
        b=NQsN/r4LKj5qNbGU3RZapDK1JvBb397bkXMfuXjn34DAGwG0y0rmLRcke+woGcyOL2
         2M+L+GQJ9PrTffpPfUISh46TX6UivFDBiVa6ULzl/AY8r4lLClQqWae16WLo5Ef8fTcd
         4Bf9gzDHexdyL/oDRIOj0KU8Q5NGab31+zdZktLUZsl80lLuJztA9MaAeZQHQaydMFME
         flnIxNO1CpAaP4wHepzbp9BO9qvlvVq40km++q6w8fx5L5oMvdsTmcaAUNDo+KEi3T1D
         uSExL4ScdzZvWUO8g5z0CDhYoPIBPYPsuzxGFIufk00x0wUWsV/1Hf1KSDagWV/hKkjv
         KArA==
X-Gm-Message-State: AOJu0YwbOzVPx1c7zkLt+SobfcJ5f9DnHrZ1uAW7a64xeUL9mtkh0hzG
	Cu5obJVPZCeCfbLySjgUKUZ2pnFDLsFxkVw44VLgDRiGWCCFW7k5jzRotkafxKhy+IQ=
X-Gm-Gg: ASbGncvloOcOL53ECEXk6CPscbhOXWf2X+rda6yGyhz+PbSSeVkKxsvUe43pl5+0Zyx
	ZY46G+Y4KwoEoe2gX4W738lNPXVrx13ToCBNhtbDqbks5Zhrg0hP44LCafNZS7L0P+TDkz+UjlU
	w7B6WNjneresUZhsS557Ah/nGpxsY7SW36ue2XgfqZeyXA66MRXGkWO/04gTg+vFjLg+aeKI7I9
	nv/dZezRFnYYAERFgGIwi+XVXjVBENDYvhRmLcTNRWlyBDJP+zUqu9PWkLXreCwMD+Q8nCu9DJF
	Qz5uDu2vjoLoLT8iEax5qqnQY6hLA7MbGMKHvMkSwHqAa2wcfu807P7FI5+67Pr2k7EIwf8WUUo
	9J4eAekFfi1ms2ow8vVMI6b8=
X-Google-Smtp-Source: AGHT+IFgq2ivg/0MglwTFQ4WJrnXsHzXC1MwrFb4H0GFB2MQTzaMHFKRHwI7ymeiA/dv4aTbTUdETg==
X-Received: by 2002:a05:6a20:9195:b0:203:bb65:995a with SMTP id adf61e73a8af0-225c08e0ffamr2890704637.30.1751610397524;
        Thu, 03 Jul 2025 23:26:37 -0700 (PDT)
Received: from localhost.localdomain ([203.208.189.8])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b38ee5f643dsm1183240a12.37.2025.07.03.23.26.33
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 23:26:37 -0700 (PDT)
From: lizhe.67@bytedance.com
To: alex.williamson@redhat.com,
	akpm@linux-foundation.org,
	david@redhat.com,
	peterx@redhat.com,
	jgg@ziepe.ca
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lizhe.67@bytedance.com
Subject: [PATCH v2 1/5] mm: introduce num_pages_contiguous()
Date: Fri,  4 Jul 2025 14:25:58 +0800
Message-ID: <20250704062602.33500-2-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250704062602.33500-1-lizhe.67@bytedance.com>
References: <20250704062602.33500-1-lizhe.67@bytedance.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Li Zhe <lizhe.67@bytedance.com>

Function num_pages_contiguous() determine the number of contiguous
pages starting from the first page in the given array of page pointers.
VFIO will utilize this interface to accelerate the VFIO DMA map process.

Suggested-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 include/linux/mm.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 0ef2ba0c667a..1d26203d1ced 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -205,6 +205,26 @@ extern unsigned long sysctl_admin_reserve_kbytes;
 #define folio_page_idx(folio, p)	((p) - &(folio)->page)
 #endif
 
+/*
+ * num_pages_contiguous() - determine the number of contiguous pages
+ * starting from the first page.
+ *
+ * @pages: an array of page pointers
+ * @nr_pages: length of the array
+ */
+static inline unsigned long num_pages_contiguous(struct page **pages,
+						 unsigned long nr_pages)
+{
+	struct page *first_page = pages[0];
+	unsigned long i;
+
+	for (i = 1; i < nr_pages; i++)
+		if (pages[i] != nth_page(first_page, i))
+			break;
+
+	return i;
+}
+
 /* to align the pointer to the (next) page boundary */
 #define PAGE_ALIGN(addr) ALIGN(addr, PAGE_SIZE)
 
-- 
2.20.1


