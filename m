Return-Path: <kvm+bounces-20154-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 104B991107A
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 20:13:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 30BF3B24CD9
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 18:09:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C8231D053C;
	Thu, 20 Jun 2024 17:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j/4JY3q2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A2261D0524;
	Thu, 20 Jun 2024 17:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718906334; cv=none; b=OazWtCS14e+oVvfU/Ut2vWyzzizUaWXB047+es8oDE5aLACWwJpjSoGvxPwRdyh/IK1zUic/VEvkWk8sfcLtyLUyaI0eGuUQoghf+WsYqaVTrnS/a/eLO9GS5cC+IM+IH+PS+Z8pwwbGTZolnmyfBL1oKjg1q7IEtZq2TsYVMoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718906334; c=relaxed/simple;
	bh=iFsifJx1wMiIIUWuh/ayjg/iUbqKnwO1KoeqNmj0MPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tgjwOGRzA1h7Srlc+or0ON+BS9qxvSb5rYpkU+AEBPurK+NvwyreBYUa4eErJ3XB9ACShS7Qam8XON+3ozzT3fUqyy+b0Y8155in1msV8y+s1gjpyL2vq7wBfq3QjlaafJaTNoJUqJJc00Hb+jAJBdt/TXJTNuXzgzHvHREJBM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j/4JY3q2; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1f4a5344ec7so8743805ad.1;
        Thu, 20 Jun 2024 10:58:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718906333; x=1719511133; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hj1QfKPBw8fFwUqArOqXUFjt0dwMTc6OO+45pzeQpo8=;
        b=j/4JY3q2qlsOdoJeRcVTj5iKP5KuR9U365iHvOhM57fFUV9yH7QJhNt2bjdLRiVgjw
         dzNcfhHl6lvlnEE4WEoimXRbFRPYNFbBtAvYzMqkgRWxBk/It0isVE4T2V6gF9yi9DQN
         99pUylWzxvsFSpjR8GUzZlApLOJ7q/M+r1gT0qwh1KPnuDn/ewwzYRb3ATApEXD1exp0
         mlYq3yEBIkwvQXtFVEmEwauf3GtOek4aYqmxBCTm0DYTlHwGq/uvyAaY7QbUXDe5mzgb
         mR0DYFBQCkHaPcWEd44nMY+Wp4+01UlaxZPUN7XixE7ZBaoRovoU3dMuwd4+LbWIUlZO
         wArw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718906333; x=1719511133;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hj1QfKPBw8fFwUqArOqXUFjt0dwMTc6OO+45pzeQpo8=;
        b=UZWqdl9uz0GoVF3lmQ1MR53EExWlLi2ExMaViUQjo33jCBtkIoXsuZU417AM3Picz0
         exDkH0ATMN4iE9Oy/l0rgn8kSpP17PlllTn2hNa4+NAZUzunWxKzfPP/fycr4TolEwoG
         HR73ADPZTMzyszKnNK7Vd+7CXbylFAaBspQrxwAz7LKbBZTuxf62gYHv2uVpDHa+wvpS
         Co/oAYTIyemfkkt2Rc1eXmmX5nwoX1s7m1c8zPlKqwQKc1SbZImNZHr0CuhGrajeRiA2
         rt6PpUnmU1rGLV9/MDBMpF7l/vItyoVAy70cqlhBAzw9I00iAQnMYWmBE01JkP+E2QUY
         JCyg==
X-Forwarded-Encrypted: i=1; AJvYcCW5DxLvCNQEMNB6JYK0aVQeJsGLJKwSI2rtF8FrGXxz6WQf+mhMFGPgarrHMWxvIyTE2dD49pxXoYsIKd1vuQNLIObH
X-Gm-Message-State: AOJu0YzLs90tys57502gK3TJVdP60AEJdi4+uxClG2tbV6PMxgmtuEsA
	Z7A1IHLzXA04JHPYA2ahqAOdzSQ5H9nXFBAdFUMEYXvqSRRrMxYd33FwUN8KNHM=
X-Google-Smtp-Source: AGHT+IHv7hZ0hu3tHqs8vQg7dykPKbTq19sg2MZwzPshyGp9XYLFVMvIGQ9OcLfhnMnfvSTxeFX6Ow==
X-Received: by 2002:a17:902:d510:b0:1f6:ee7b:6ecf with SMTP id d9443c01a7336-1f98b28f021mr132320805ad.34.1718906333014;
        Thu, 20 Jun 2024 10:58:53 -0700 (PDT)
Received: from localhost ([216.228.127.128])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f9c92ac748sm19063135ad.187.2024.06.20.10.58.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jun 2024 10:58:52 -0700 (PDT)
From: Yury Norov <yury.norov@gmail.com>
To: linux-kernel@vger.kernel.org,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	"Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org
Cc: Yury Norov <yury.norov@gmail.com>,
	Alexey Klimov <alexey.klimov@linaro.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Jan Kara <jack@suse.cz>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Sergey Shtylyov <s.shtylyov@omp.ru>
Subject: [PATCH v4 37/40] KVM: PPC: Book3s HV: drop locking around kvmppc_uvmem_bitmap
Date: Thu, 20 Jun 2024 10:57:00 -0700
Message-ID: <20240620175703.605111-38-yury.norov@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240620175703.605111-1-yury.norov@gmail.com>
References: <20240620175703.605111-1-yury.norov@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The driver operates on individual bits of the kvmppc_uvmem_bitmap.
Now that we have an atomic search API for bitmaps, we can rely on
it and drop locking around the bitmap entirely.

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 arch/powerpc/kvm/book3s_hv_uvmem.c | 33 ++++++++++--------------------
 1 file changed, 11 insertions(+), 22 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_uvmem.c b/arch/powerpc/kvm/book3s_hv_uvmem.c
index 92f33115144b..93d09137cb23 100644
--- a/arch/powerpc/kvm/book3s_hv_uvmem.c
+++ b/arch/powerpc/kvm/book3s_hv_uvmem.c
@@ -86,6 +86,7 @@
  * page-sizes, we need to break this assumption.
  */
 
+#include <linux/find_atomic.h>
 #include <linux/pagemap.h>
 #include <linux/migrate.h>
 #include <linux/kvm_host.h>
@@ -99,7 +100,6 @@
 
 static struct dev_pagemap kvmppc_uvmem_pgmap;
 static unsigned long *kvmppc_uvmem_bitmap;
-static DEFINE_SPINLOCK(kvmppc_uvmem_bitmap_lock);
 
 /*
  * States of a GFN
@@ -697,23 +697,20 @@ static struct page *kvmppc_uvmem_get_page(unsigned long gpa, struct kvm *kvm)
 	struct page *dpage = NULL;
 	unsigned long bit, uvmem_pfn;
 	struct kvmppc_uvmem_page_pvt *pvt;
-	unsigned long pfn_last, pfn_first;
+	unsigned long num_pfns, pfn_first;
 
 	pfn_first = kvmppc_uvmem_pgmap.range.start >> PAGE_SHIFT;
-	pfn_last = pfn_first +
-		   (range_len(&kvmppc_uvmem_pgmap.range) >> PAGE_SHIFT);
+	num_pfns = range_len(&kvmppc_uvmem_pgmap.range) >> PAGE_SHIFT;
 
-	spin_lock(&kvmppc_uvmem_bitmap_lock);
-	bit = find_first_zero_bit(kvmppc_uvmem_bitmap,
-				  pfn_last - pfn_first);
-	if (bit >= (pfn_last - pfn_first))
-		goto out;
-	bitmap_set(kvmppc_uvmem_bitmap, bit, 1);
-	spin_unlock(&kvmppc_uvmem_bitmap_lock);
+	bit = find_and_set_bit(kvmppc_uvmem_bitmap, num_pfns);
+	if (bit >= num_pfns)
+		return NULL;
 
 	pvt = kzalloc(sizeof(*pvt), GFP_KERNEL);
-	if (!pvt)
-		goto out_clear;
+	if (!pvt) {
+		clear_bit(bit, kvmppc_uvmem_bitmap);
+		return NULL;
+	}
 
 	uvmem_pfn = bit + pfn_first;
 	kvmppc_gfn_secure_uvmem_pfn(gpa >> PAGE_SHIFT, uvmem_pfn, kvm);
@@ -725,12 +722,6 @@ static struct page *kvmppc_uvmem_get_page(unsigned long gpa, struct kvm *kvm)
 	dpage->zone_device_data = pvt;
 	zone_device_page_init(dpage);
 	return dpage;
-out_clear:
-	spin_lock(&kvmppc_uvmem_bitmap_lock);
-	bitmap_clear(kvmppc_uvmem_bitmap, bit, 1);
-out:
-	spin_unlock(&kvmppc_uvmem_bitmap_lock);
-	return NULL;
 }
 
 /*
@@ -1021,9 +1012,7 @@ static void kvmppc_uvmem_page_free(struct page *page)
 			(kvmppc_uvmem_pgmap.range.start >> PAGE_SHIFT);
 	struct kvmppc_uvmem_page_pvt *pvt;
 
-	spin_lock(&kvmppc_uvmem_bitmap_lock);
-	bitmap_clear(kvmppc_uvmem_bitmap, pfn, 1);
-	spin_unlock(&kvmppc_uvmem_bitmap_lock);
+	clear_bit(pfn, kvmppc_uvmem_bitmap);
 
 	pvt = page->zone_device_data;
 	page->zone_device_data = NULL;
-- 
2.43.0


