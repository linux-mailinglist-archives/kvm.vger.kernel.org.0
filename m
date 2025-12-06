Return-Path: <kvm+bounces-65466-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E1CABCAA832
	for <lists+kvm@lfdr.de>; Sat, 06 Dec 2025 15:10:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 84C7F300C367
	for <lists+kvm@lfdr.de>; Sat,  6 Dec 2025 14:10:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 654162FE582;
	Sat,  6 Dec 2025 14:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g4CTPTQU";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="OPPbYz5P"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B847821CFE0
	for <kvm@vger.kernel.org>; Sat,  6 Dec 2025 14:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765030231; cv=none; b=BnDl9afkzKezGJEn2RZ39PaLcCj7iPCegXu5nLpUK0kakQRi8cXBhTl/8kXK/KkSbcqLI1lUB1H51y+jA3LMq23u1wUjxXWWz2+jQ24qFE+r+EC4SC+HHGtHP+vwdxnjjPecjbG1TsZ1D9opcUmgfDoDIS9DvZOchXLlHLJ826Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765030231; c=relaxed/simple;
	bh=XuRAxrlwnRFlJJ9EJI6yr7wupdXLYX7b3+kDS2dVTnI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IwRdcIR1rNZxsQea6NlOJqizIrJ6h/Ep/aufSa98XxmzyQQIzhHDbjqYtKPucveEeb03H4brBFic1qTHwCXNSPMvq1iIJMYQoZ8GoXN49j/nbtHghhkz3BNSUObt2RHb5hhiu9SEyVOGGr4hTcFMo2sYCt3Oc1vVEykWMnOKra0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=g4CTPTQU; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=OPPbYz5P; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765030228;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=+oi3g8gsnlN4LRIJObzxq2G2qb1knpHWTPAplf+W8PA=;
	b=g4CTPTQUyh0bX7yvP2Y4pT/ZYWgdC5GzRGKoaQiJpnxj+rwa+BkfJSvKXxHQ7uXMMruwBm
	87LhL+P3ofQyVDwMEZJQnl5NlX5kaDjJB04xNKuBHZpvhDqExoJWCCNHXoz5bAEuuIGjM5
	5GPLIv71oUDVQDspfPM2SXKXen6W96s=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-212-VFhQovHzN9mN5s-hyDKipA-1; Sat, 06 Dec 2025 09:10:27 -0500
X-MC-Unique: VFhQovHzN9mN5s-hyDKipA-1
X-Mimecast-MFC-AGG-ID: VFhQovHzN9mN5s-hyDKipA_1765030226
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-bf222e5b54dso1769362a12.1
        for <kvm@vger.kernel.org>; Sat, 06 Dec 2025 06:10:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1765030226; x=1765635026; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+oi3g8gsnlN4LRIJObzxq2G2qb1knpHWTPAplf+W8PA=;
        b=OPPbYz5PtbPjGWBbLZu08Bi89de9TEMmYOdyUnji7H+U3x3M4K6B5PZFrWVAnfEkvu
         vIe/PMtyY6ID5XifPk31RyNQPIgdVxMxGEZX1qwQWNR/msgPDNINejFjMKwcOZYoO98E
         d6iR+nD8y061YtzVWbtKnGvnD8+ErnmifC9sQYq3AvyzdTcrNsRDl8sXZmPsGyyhvH5r
         3sqKp22pmpwskWtnGGzPhuex9tZtFBpT0s9NtZq6VpNYzzoBlxzxZveAmxypZFyRm4Cc
         wXndoJJ/3VYLdHUE8M6KfrobfTxZTxG1f3uKqgwpaStBb3bdZptqJAXDI/JLWwjC9zQA
         23mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765030226; x=1765635026;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+oi3g8gsnlN4LRIJObzxq2G2qb1knpHWTPAplf+W8PA=;
        b=Brdiz3aiRka7OJ7W7aX87pgmlIH/L1HH64zh6hc3PALeCwD9mpnnhw91A+6KQtxTyP
         bvKlPeVo0Nc2dyr6BqyEWPHNoiuyN6i3OZZZn3sYGOwGEbHGuQVBfdwJR2JwTDveFWZe
         spBXHUq/ykW0+32wu4Fs83jODLqXgxTalUGmyXfRVYXyU5/nvz4xYYAafrytkkS1SFD9
         PyvSLmSun6WJNrlNBoJ0ERomXkA+C0fIG1crhat0TdbrG1u1PWNveatoDZe/kSHLJDGF
         Awlp6xHVzAPuBcPHv1oDHKiGanivHXxysn9NO+yQ3j1k++D/O8wA7MhU2343kPuPIltC
         h4Bw==
X-Forwarded-Encrypted: i=1; AJvYcCVcG7MJZQyxWqc0pNxTDkyfHHWKDWR25J6+AWB7fwrZLM8Kkj+nRy2SWGv0Yu97Y5m3mx4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxLXhY7i/Hphyp3YVeqnjalNthvsMrd6TdJeRz5f28YQP5jseEL
	iNu4Tq1KoKby4g157oQEQszmFAynT9fM+cJpn1xdtaMWUE/FZkjs2DejpA2TzCBJkbLfzj2sSlQ
	IRNsPjjbyh6kPTp4sTr7t9GsvS6okwYbkckp/7aZtB85Hnc4YaIL4oA==
X-Gm-Gg: ASbGncvavhQyCLUcXWSl6EegY0Zo040b17tG/WXva5o90kFhSfKX4o2IvUXV5GXd0BY
	28+wCTyWyAD0qENcTNYciwVGmxj/xHpPj4Dp6MJH2wAVj/Gv45NCB0LIsh2YI/c1ca1OiOernqI
	paCJci6O0dlG2jZbl1AYFWpq7uRLxOAGL3JiLuzcK64oBZhXb1CoJzY+PYaOP+Vk6+7QsQQiUO+
	GvBncc0+2S4l7tKWsr6o5QfbDITamCnPvgdi90YWqtylh+hllVd8puZKBBHdTJcvro9FkUTI73I
	eAtDcXXlJ9DeuyPCTHMWXvvSWm1+9M1uqmTq2BLclvOwf0G8UalmAumYgZdtB48v24h61Sz3FSQ
	4gwqM
X-Received: by 2002:a05:6a20:7350:b0:366:14b0:4b1c with SMTP id adf61e73a8af0-36618029bd6mr2570339637.39.1765030226164;
        Sat, 06 Dec 2025 06:10:26 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH6K9hWrEKLmm52G0O4yetFo1bM2RpGtoGbQbJOsgPB9bD0ayKd5GXV7pQRT0CdfTebp8gW+Q==
X-Received: by 2002:a05:6a20:7350:b0:366:14b0:4b1c with SMTP id adf61e73a8af0-36618029bd6mr2570312637.39.1765030225736;
        Sat, 06 Dec 2025 06:10:25 -0800 (PST)
Received: from zeus ([2405:6580:83a0:7600:6e93:a15a:9134:ae1f])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-bf6a1306a8bsm7454410a12.18.2025.12.06.06.10.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Dec 2025 06:10:24 -0800 (PST)
From: Ryosuke Yasuoka <ryasuoka@redhat.com>
To: pbonzini@redhat.com,
	vkuznets@redhat.com,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	hpa@zytor.com
Cc: Ryosuke Yasuoka <ryasuoka@redhat.com>,
	x86@kernel.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] x86/kvm: Avoid freeing stack-allocated node in kvm_async_pf_queue_task
Date: Sat,  6 Dec 2025 23:09:36 +0900
Message-ID: <20251206140939.144038-1-ryasuoka@redhat.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

kvm_async_pf_queue_task() can incorrectly try to kfree() a node
allocated on the stack of kvm_async_pf_task_wait_schedule().

This occurs when a task requests a PF while another task's PF request
with the same token is still pending. Since the token is derived from
the (u32)address in exc_page_fault(), two different tasks can generate
the same token.

Currently, kvm_async_pf_queue_task() assumes that any entry found in the
list is a dummy entry and tries to kfree() it. To fix this, add a flag
to the node structure to distinguish stack-allocated nodes, and only
kfree() the node if it is a dummy entry.

Signed-off-by: Ryosuke Yasuoka <ryasuoka@redhat.com>
---

v2:
Based on Vitaly's comment,
* Update comment in kvm_async_pf_queue_task
* Set n->dummy false in kvm_async_pf_queue_task
* Add explanation about what token is in commit message.

v1:
https://lore.kernel.org/all/87cy4vlmv8.fsf@redhat.com/


 arch/x86/kernel/kvm.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index df78ddee0abb..37dc8465e0f5 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -89,6 +89,7 @@ struct kvm_task_sleep_node {
 	struct swait_queue_head wq;
 	u32 token;
 	int cpu;
+	bool dummy;
 };
 
 static struct kvm_task_sleep_head {
@@ -120,15 +121,26 @@ static bool kvm_async_pf_queue_task(u32 token, struct kvm_task_sleep_node *n)
 	raw_spin_lock(&b->lock);
 	e = _find_apf_task(b, token);
 	if (e) {
-		/* dummy entry exist -> wake up was delivered ahead of PF */
-		hlist_del(&e->link);
+		struct kvm_task_sleep_node *dummy = NULL;
+
+		/*
+		 * The entry can either be a 'dummy' entry (which is put on the
+		 * list when wake-up happens ahead of APF handling completion)
+		 * or a token from another task which should not be touched.
+		 */
+		if (e->dummy) {
+			hlist_del(&e->link);
+			dummy = e;
+		}
+
 		raw_spin_unlock(&b->lock);
-		kfree(e);
+		kfree(dummy);
 		return false;
 	}
 
 	n->token = token;
 	n->cpu = smp_processor_id();
+	n->dummy = false;
 	init_swait_queue_head(&n->wq);
 	hlist_add_head(&n->link, &b->list);
 	raw_spin_unlock(&b->lock);
@@ -231,6 +243,7 @@ static void kvm_async_pf_task_wake(u32 token)
 		}
 		dummy->token = token;
 		dummy->cpu = smp_processor_id();
+		dummy->dummy = true;
 		init_swait_queue_head(&dummy->wq);
 		hlist_add_head(&dummy->link, &b->list);
 		dummy = NULL;

base-commit: 416f99c3b16f582a3fc6d64a1f77f39d94b76de5
-- 
2.52.0


