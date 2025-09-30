Return-Path: <kvm+bounces-59105-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 45CD7BABFCB
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 10:21:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C19EE17FE2F
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 08:21:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43CE92F39DC;
	Tue, 30 Sep 2025 08:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="h0UftDol"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f66.google.com (mail-wr1-f66.google.com [209.85.221.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9751423BF9E
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 08:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759220503; cv=none; b=P4hG4ex0p2jSFgcJUyorPCTsTPenhZnHM1uzupp/sNKlwEk9ECYKU/9e6YS1Qo+cEEH6oYsKfC5k5rKL5CHLqEIn3/PkbBlrcoBEaHJ/Co0b/iD2RLdL8dZzKkaCQxd1epRJKkE6N9gs9Y4Mp1FHewb4xtYOROmMeb1EV4CAG8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759220503; c=relaxed/simple;
	bh=LEcCUTdvINU9IDES3AHeeKLmzuWBUaxvcKWtytlYZ/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V0e70rVDFpinpXkjohRaZNZmpCjjO5AyJ55wkH+O/ygTNJDVOm0gBpCaD5IPOB2d0bIZr4xpUgH4aj30zkoK/G/kFCQyt1eBmHzI2HfYH6Fd+IBzEQ8TbfOMlo+VjiEf5Oq2N8DzOg69L1o+Gc2DdU+cVWtqnXMNGDlmnl0CsUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=h0UftDol; arc=none smtp.client-ip=209.85.221.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f66.google.com with SMTP id ffacd0b85a97d-3ece1102998so3769262f8f.2
        for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 01:21:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759220500; x=1759825300; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g6Y+9YynyQUWZr+3xZXfGIWc6Jhbj4AT6sZ58oDn40Q=;
        b=h0UftDolMFlqjyuFXc2JAU3V/1pqzXOsbj35Vt25QoMxSuRNOOt2c0Dr2cimtMUayg
         EN0I4mwbz7IVKDw2a3deUoveQ/TXwGtFoI0IHn56ml2ILbAfKySxuzmDwPhnD5T6Y/wV
         ZadEVXcP2uKDyBgFTdJxzjg/CN/Ij9Gh9vyPEhv812GqInAKUyFmaVh+nRfglaLKrcQ1
         n1v3OReDg0Dv0bdzRgtjYnJdPgNIhfwtaXrX2DbKBUhkhQYr7MZRl2VzMW/H1j3SxMKQ
         /55vywgq369zrDGDKD2aeVBa4lxwXwrc2GeMZAzoyS54O96+I7CQv5a4ng/O5yj371c5
         ofOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759220500; x=1759825300;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g6Y+9YynyQUWZr+3xZXfGIWc6Jhbj4AT6sZ58oDn40Q=;
        b=FvLyt6bQbpuJ6qSmxm8mDx0roqO6QXJ/DZkT4imJXYyUGLjZ3nZKFBeXt1wJZc6lCZ
         YRT8Zxpdfl2Gf4xoQdfS7Q3E7AVIR1r2st2Nb0C6t2++NzHIeBrWhWFcFOgswn4gNM3u
         Lj+5XjsvewiN9zUPl0pO6JSLIPdXsR+AS/32POBcjw6nrZbuiLkYEyQsAj4KsufdCHkc
         M0AN9Eun4Jhq60kzGO8POaFGcxUFSCv3fO+XBw8If2t/rK6872a2WC5LVINqECjQP44n
         APWwV6xSd0Z+8Sr7Hemg4cplbOwEf7FiYPUwmaZTDGc6ly06g0QO0+a8f0vIbTeokBH/
         OZDQ==
X-Forwarded-Encrypted: i=1; AJvYcCXlbrKoamPiWpz362dd6mfA38gx75xex/egL+Mbnf5Yc0ZrFm7SgaEIC4Myy14R7pSdA5U=@vger.kernel.org
X-Gm-Message-State: AOJu0YxBxfUpHN+CiBZt019bxumeBnNkhJQe4Mpq3OMRW8HPAfIKISG7
	dXmvL/wqrLbHdsHcSMf/xHCiYpaKTOTgPrup8gpwJWSOQb/ldDdm6hlzUGKwvehIGWQ=
X-Gm-Gg: ASbGncuRtQtfFhmGVdnRAi2FK0OX0FGZNH+DtEKJF5F0g8D6qVM+06ueQDTEbFiFFLe
	QUHiJckLT5Pem8OFCqcrrremIk+Gq6ZJHYjKjNJvDc8kSsCfsXP/JJVDzdEcFHuhrs2Um96uQXS
	5vxQaYwC/sxZ6ZqgvdMAXG0J1wXB2uE+BqXitPMUajDGlb9ke+TaI82cFf7gk8yGPlffnb25R0O
	TJjkzHogWIAB0q4oOlv+4Y9ZBcTiZHFBZPzmRMJdrIQ0VirZQdSEiHuq48DigOmj+/zr86emk/q
	5x+2tT9VUK45WskqqKYFdh4R/mIRuwBX/NSxaRl206je/tY7cOED57dvvM8MUWYiJJftyo79aWi
	myuiZRP+oz6r677Pt1BDo3mjqu888C5HMvbzZDhD4U9C6/oDx232GcmTeu822fXrEtYxreo4pCb
	eYvyzTGFuM2i6uqSGPeJVT
X-Google-Smtp-Source: AGHT+IEvqZbVxTkOzuE7/OdSy85DpVZk0C8frEdFACso26c6+h9s7puUVSPKjShsswhtViU8Ba02iA==
X-Received: by 2002:a05:6000:18a7:b0:3e9:d0a5:e436 with SMTP id ffacd0b85a97d-40e437371acmr19688375f8f.23.1759220499859;
        Tue, 30 Sep 2025 01:21:39 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fb72fb1a3sm22070432f8f.10.2025.09.30.01.21.38
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 30 Sep 2025 01:21:39 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org,
	Peter Maydell <peter.maydell@linaro.org>
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Reinoud Zandijk <reinoud@netbsd.org>,
	Peter Xu <peterx@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	David Hildenbrand <david@redhat.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	kvm@vger.kernel.org,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	xen-devel@lists.xenproject.org,
	Stefano Garzarella <sgarzare@redhat.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	qemu-s390x@nongnu.org,
	Paul Durrant <paul@xen.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Anthony PERARD <anthony@xenproject.org>,
	Jason Herne <jjherne@linux.ibm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Eric Farman <farman@linux.ibm.com>
Subject: [PATCH v3 02/18] system/memory: Better describe @plen argument of flatview_translate()
Date: Tue, 30 Sep 2025 10:21:09 +0200
Message-ID: <20250930082126.28618-3-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930082126.28618-1-philmd@linaro.org>
References: <20250930082126.28618-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

flatview_translate()'s @plen argument is output-only and can be NULL.

When Xen is enabled, only update @plen_out when non-NULL.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/system/memory.h | 5 +++--
 system/physmem.c        | 9 +++++----
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/include/system/memory.h b/include/system/memory.h
index aa85fc27a10..3e5bf3ef05e 100644
--- a/include/system/memory.h
+++ b/include/system/memory.h
@@ -2992,13 +2992,14 @@ IOMMUTLBEntry address_space_get_iotlb_entry(AddressSpace *as, hwaddr addr,
  * @addr: address within that address space
  * @xlat: pointer to address within the returned memory region section's
  * #MemoryRegion.
- * @len: pointer to length
+ * @plen_out: pointer to valid read/write length of the translated address.
+ *            It can be @NULL when we don't care about it.
  * @is_write: indicates the transfer direction
  * @attrs: memory attributes
  */
 MemoryRegion *flatview_translate(FlatView *fv,
                                  hwaddr addr, hwaddr *xlat,
-                                 hwaddr *len, bool is_write,
+                                 hwaddr *plen_out, bool is_write,
                                  MemTxAttrs attrs);
 
 static inline MemoryRegion *address_space_translate(AddressSpace *as,
diff --git a/system/physmem.c b/system/physmem.c
index 8a8be3a80e2..86422f294e2 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -566,7 +566,7 @@ iotlb_fail:
 
 /* Called from RCU critical section */
 MemoryRegion *flatview_translate(FlatView *fv, hwaddr addr, hwaddr *xlat,
-                                 hwaddr *plen, bool is_write,
+                                 hwaddr *plen_out, bool is_write,
                                  MemTxAttrs attrs)
 {
     MemoryRegion *mr;
@@ -574,13 +574,14 @@ MemoryRegion *flatview_translate(FlatView *fv, hwaddr addr, hwaddr *xlat,
     AddressSpace *as = NULL;
 
     /* This can be MMIO, so setup MMIO bit. */
-    section = flatview_do_translate(fv, addr, xlat, plen, NULL,
+    section = flatview_do_translate(fv, addr, xlat, plen_out, NULL,
                                     is_write, true, &as, attrs);
     mr = section.mr;
 
-    if (xen_enabled() && memory_access_is_direct(mr, is_write, attrs)) {
+    if (xen_enabled() && plen_out && memory_access_is_direct(mr, is_write,
+                                                             attrs)) {
         hwaddr page = ((addr & TARGET_PAGE_MASK) + TARGET_PAGE_SIZE) - addr;
-        *plen = MIN(page, *plen);
+        *plen_out = MIN(page, *plen_out);
     }
 
     return mr;
-- 
2.51.0


