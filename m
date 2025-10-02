Return-Path: <kvm+bounces-59385-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 756ADBB26F3
	for <lists+kvm@lfdr.de>; Thu, 02 Oct 2025 05:28:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 14C3A192337E
	for <lists+kvm@lfdr.de>; Thu,  2 Oct 2025 03:29:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB0DE24886E;
	Thu,  2 Oct 2025 03:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="zkV2ekAQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20744149E17
	for <kvm@vger.kernel.org>; Thu,  2 Oct 2025 03:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759375724; cv=none; b=G/WvvOzmsuO7AM5qR94nml2c44txM3vBEh+E9kzol1/U7p91WBcwBSqUQILDr0N47fP+JwE/zQY0+q/XAzJapnIfxdD6U3if80qGDdLNK93XqCudZjhgU/J4N2u5pQubp20hd+c2yA11d6j7/ehLum3jXL2Frk/+uNTurDpG8dQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759375724; c=relaxed/simple;
	bh=xehy+/JTTedrlPJoRZSJE92yDecmlnv5Vpc68jLWdxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dF9lN1jfJNpSPb249lXsSO+y7PgDIWm4D78k5cgOrWTfvS3jYQwydc9SM/9+rkHozmeTYMjXlEM8rvpUgqSeraNT11ZZn47oRR+UJ6ZeAx2jViWYBR6/WZit2CHaTQCcmwPgI/lDuDi3n2JJD4mASEPmP/wRW8UB6svMN+0OXl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=zkV2ekAQ; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-46e491a5b96so2808575e9.2
        for <kvm@vger.kernel.org>; Wed, 01 Oct 2025 20:28:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759375721; x=1759980521; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VL++psIcTnezWEV7BWLGf1XEHbU+wiOL+n3sKTSCz9o=;
        b=zkV2ekAQ76mMNwtKgqSo8nMgdZSm+mro5n7Mb3g2OYRfQLPhfzPz05ItTL41ksz4dW
         4jx6EVxT2LW3CYrYPO9rGMXrN7nFPDuU0QT4ss8gq9WBPu14YiWIw8EwUOSqFJlrccFd
         pMNRgqu7xItH/OkzCUtjkrsH3WpLY2zEuAE98fMOWXx/Mc+7EocmAYp0f2DE2JILOtHq
         bfNGgv7RLUzEA1TPCOBZb6jTzYAR5xHbIiWOt7JI7vmmRMhaRAxIXwCpv9MTQpTVT4PB
         XSm7kcSUB7YRX9RhfL5sMwRRwHlt6PA2zr9D7gAkP0H4C3NOx9+lXZrXU6dro7BGiMGC
         J6+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759375721; x=1759980521;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VL++psIcTnezWEV7BWLGf1XEHbU+wiOL+n3sKTSCz9o=;
        b=v6vb3DMGFABHiIEkvYmlmQKlN98sTr4P/Tra55d6EGgmOv5S07O/QUsTithnJfqD23
         SJeCOLxCyqKTcTLCNFMq5xzU17sYQoT3mf3T3SbUiOZJoOmad2AO/LGQ9811kV6z208R
         ZDsXSlIqfApDw2+qnhBRUTtIccgk5LpiGuhjQS/d3ZSDnbaOkHTP8d8Og+wQ3duWboDc
         lz4Lc0D6hqT32ZXDktMxQ++S63nHGnsAj7Nc2VrIjrYWdOzjmu56VoPEuWQ0hEaJhLhr
         Gb+MBQudxdQgw8EcjcVz6Sng8U8ZrENBpuEUCE7Z6z/hR18tHFOG8qvInNGJoeF83V/e
         j7FA==
X-Forwarded-Encrypted: i=1; AJvYcCUd6hXC3fBKEqqrPhSHLnQfbq7WDFjVsudgDRSJIMx78ChGXCg9k1biU3dPU2eLUsDNTqE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwCP6ZRbxOVzmTNp6RbWv812LhLPPMFRA+SK44gXpXUZtdIjOQ9
	hPAFDMD3JDJstt6TFmirH2nmbsbnL821S+NFa4urWw46XjWBxSSZNJQVZMJoydb+uM4=
X-Gm-Gg: ASbGncsIMMUv6kpTI6cCr65lN+wJAFM6uMYldv3HbYOXVQqwW6oINE7/FSCc1Xb6SOl
	3jmulon9Xh8fZW2xgOYc3FzL+EvXckig+eFAbUBk3UocP9cpSVRVnGDKk7jaOhIv9AU7ECdL7SZ
	YpTVJXrd6cR1ZA6+SEVWvqQmRqsarSEhLRwWCWlAptfY9zrslQ44XYcQ7wlnp6Zc7Ln4e1wP81d
	PslKPnqXS3V4dGBBUUKwJRpfBV2YIwb4rheNxsfdyWpESiFtoyAXpNTM/ihQI/edFkjuXuyyrRR
	2riIgAGBkPXlDcTs3oA1QLGL3oAd6gAP1ZeHSOJoXxWL5+VqUbgsgrEk46mR5jJ8VGOWU8Hpij6
	RnZd1Mddqk7S6csofFy4n+d9SrADc6JlFHj/tP12mIXm9cS5sEvlVA4JIe/swI04PgiBen7jCK0
	O7ooqSQMB+LrCjpG172/Xq4iQE2L8dYg==
X-Google-Smtp-Source: AGHT+IEan6gq7FwOIOX+CQUrYOyZ1ZpzE1JMwvcDmTnfCD9kmJozhNIT9DcGRPkhZkVaK5maYShAEw==
X-Received: by 2002:a05:600c:1d08:b0:46e:396b:f5ae with SMTP id 5b1f17b1804b1-46e653f35fcmr38896575e9.16.1759375721447;
        Wed, 01 Oct 2025 20:28:41 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8f017esm1625977f8f.47.2025.10.01.20.28.40
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 01 Oct 2025 20:28:40 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: David Hildenbrand <david@redhat.com>,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Peter Xu <peterx@redhat.com>,
	kvm@vger.kernel.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Fabiano Rosas <farosas@suse.de>
Subject: [PATCH v3 5/5] system/ramblock: Move RAMBlock helpers out of "system/ram_addr.h"
Date: Thu,  2 Oct 2025 05:28:12 +0200
Message-ID: <20251002032812.26069-6-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251002032812.26069-1-philmd@linaro.org>
References: <20251002032812.26069-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 include/system/ram_addr.h | 11 -----------
 include/system/ramblock.h | 11 +++++++++++
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/include/system/ram_addr.h b/include/system/ram_addr.h
index 53c0c8c3856..6b528338efc 100644
--- a/include/system/ram_addr.h
+++ b/include/system/ram_addr.h
@@ -80,17 +80,6 @@ static inline bool clear_bmap_test_and_clear(RAMBlock *rb, uint64_t page)
     return bitmap_test_and_clear(rb->clear_bmap, page >> shift, 1);
 }
 
-static inline bool offset_in_ramblock(RAMBlock *b, ram_addr_t offset)
-{
-    return (b && b->host && offset < b->used_length) ? true : false;
-}
-
-static inline void *ramblock_ptr(RAMBlock *block, ram_addr_t offset)
-{
-    assert(offset_in_ramblock(block, offset));
-    return (char *)block->host + offset;
-}
-
 static inline unsigned long int ramblock_recv_bitmap_offset(void *host_addr,
                                                             RAMBlock *rb)
 {
diff --git a/include/system/ramblock.h b/include/system/ramblock.h
index 85cceff6bce..76694fe1b5b 100644
--- a/include/system/ramblock.h
+++ b/include/system/ramblock.h
@@ -119,4 +119,15 @@ int ram_block_attributes_state_change(RamBlockAttributes *attr, uint64_t offset,
  */
 bool ram_block_is_pmem(RAMBlock *rb);
 
+static inline bool offset_in_ramblock(RAMBlock *b, ram_addr_t offset)
+{
+    return b && b->host && (offset < b->used_length);
+}
+
+static inline void *ramblock_ptr(RAMBlock *block, ram_addr_t offset)
+{
+    assert(offset_in_ramblock(block, offset));
+    return (char *)block->host + offset;
+}
+
 #endif
-- 
2.51.0


