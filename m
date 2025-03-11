Return-Path: <kvm+bounces-40732-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FD5AA5B7D7
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 05:10:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 13F353B09F4
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 04:10:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E4861EB1B2;
	Tue, 11 Mar 2025 04:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="c7eQtko+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06E771F872F
	for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 04:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741666151; cv=none; b=QZXhHrujC8Ly3ufJiKcgZAaPJJj0SNfde8HKcqkXZ6B6GrSg9gnLlJS/dnIF/Jp0yASp5URKsBBYakE8VD6Kk01C5RJPa3E+fsAWoqGnaQ278vWH/DQC3omJ+TiezeI5tBEI0Z7Dq3v9J2Ui2KtAeXpyLSewh6R47b+f8EXSuH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741666151; c=relaxed/simple;
	bh=2EiUgDnSIr2U0DMUcevHrrz6cNF3hvjf3O5YcIT7Nyc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=aMQwDRAId4BQoAgLBtjnCYLwRmpveSNRxNebbFVD47CzpoQvRWCRMNKottyYdymxiXVvj3NI1y0Hxf5hUaNdtbQ7FPOFxy8vTwxGcSN/CH9vI3B/ifnbx8aouC+hp6GrweMq59vgsP7k4E4v0JJjtFqJM95AtkZgujMW2JbOVh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=c7eQtko+; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-219f8263ae0so94074115ad.0
        for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 21:09:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741666149; x=1742270949; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d9PU2mUUZXceFgFF8NURkIZqXSTxuLUTW3yG3F37dHQ=;
        b=c7eQtko+x00xmt+LfUTmShr1gr7hOCKOyELOOj2xMBIfVRjW5mQmJ1G/uqSaC2D3Ae
         Wq1Gr6x4joYDCYg7DMkX8sw07AOGLoE1/dwPfm3ykdnmVklYOuJcklhiqJEsXwXfUrC4
         H0Jc5NZAkqyZGbCatc+eBvhrJljJn9pcyuiw0o9mk/u4iXVxY5iQ0uLc7PcM+xQJMgTk
         J7kXrolg89663H11bTmWgh11G10P0jAJVWQeIw2697227mpOP+2jQcoafzSJKYOG5wsv
         6Yb4pFXv8Ze0AAx8av83gjb0efTF21rAWQ+Jr94aX20GdurpetZ4UoWgATK+M3NebZdE
         R4+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741666149; x=1742270949;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d9PU2mUUZXceFgFF8NURkIZqXSTxuLUTW3yG3F37dHQ=;
        b=H2OA36jvF27VznPtzV5tenKCK+Sur2+eE9QYnOV8/dsnvYpU/xWpUqd6gY9/hrbBUN
         S3cTljxTLH3v18yaXtO8PyvUc8Z/vlpLqFYvwqBg8WlAayVOi3Es+UkbcY4pocLoA6O1
         ofNJxZ5Sh6vSZkOqOvai8NO2MnEOTfAC29Sgu1Aj18VoYIRraSJifuO4ci2BDPPJpct4
         ar0TeIoDH57OKjwQtl+PXriSrvF/XM0LqG4JIcge57V71PmZPdI4ZW3A4W6BjSH0hVkD
         l8HVoaI/yNwikca+fXT1hG+RUal64+tdopnrn++HL46qUZgxlpBmHGOestYeLG1P41/o
         reOQ==
X-Forwarded-Encrypted: i=1; AJvYcCVd2v5Ejk6wLqKnbs9paAycWwmuNX3Nc/BeRU4TSZ8SUL/BBuS5vXSWvFh6p/ZcqdeR+nc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxbEg4VbarfROkNs27uPtzdJ249HkFbBQ/t1EtmL5BLlgETLzaQ
	aiOdVR/GsG1680KVS4nofwQBqgjo6CJ/kan6dWJYseAGoFiD2jH/+KjRr8DQDHw=
X-Gm-Gg: ASbGncsz83ByFGuWQH9BvXxnKnaqJzq7+KP1en31wJZOMwgxvuc58TwqHbDBewVSTZf
	URsv02o5948Hj6u78sykHCAY3TXXDeLdEkXuq/r8KkDI3yYP8wQlHYkw64QhQTQyX3B7m+M8aUu
	rXu1HAeGg74ST5cj2sV6ABMOVAy7SWRS39YZHc0en8anxX/Vbz381Oz2iX5qLZrCQUj11JEUEnF
	nuQpC8rGxceXa9IYd5HNfnDkhNBNv/ujV52uGnUrfYWe1Yly3L56nKEC1juXjsbfINDjEFXYOjv
	voVQDtnYUquDfal6ymTuaNMDkkuPMwk5YzU5zW20UXWgFtx6GOuraa0=
X-Google-Smtp-Source: AGHT+IFhjhUd2vTxqYR3Z5nzc5K52WwhbsgB0wgjWXiu+XeofP+aLrA4dkvuyGbgnmdnOjVQzIEANg==
X-Received: by 2002:a05:6a20:160c:b0:1f5:75a9:5257 with SMTP id adf61e73a8af0-1f58cb1ba63mr3462589637.13.1741666149439;
        Mon, 10 Mar 2025 21:09:09 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-af28c0339cesm7324454a12.46.2025.03.10.21.09.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Mar 2025 21:09:09 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paul Durrant <paul@xen.org>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>,
	Weiwei Li <liwei1518@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	xen-devel@lists.xenproject.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Peter Xu <peterx@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	kvm@vger.kernel.org,
	qemu-ppc@nongnu.org,
	Alistair Francis <alistair.francis@wdc.com>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	alex.bennee@linaro.org,
	qemu-riscv@nongnu.org,
	manos.pitsidianakis@linaro.org,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Anthony PERARD <anthony@xenproject.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v2 11/16] exec/ram_addr: call xen_hvm_modified_memory only if xen is enabled
Date: Mon, 10 Mar 2025 21:08:33 -0700
Message-Id: <20250311040838.3937136-12-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250311040838.3937136-1-pierrick.bouvier@linaro.org>
References: <20250311040838.3937136-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 include/exec/ram_addr.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/exec/ram_addr.h b/include/exec/ram_addr.h
index 7c011fadd11..098fccb5835 100644
--- a/include/exec/ram_addr.h
+++ b/include/exec/ram_addr.h
@@ -342,7 +342,9 @@ static inline void cpu_physical_memory_set_dirty_range(ram_addr_t start,
         }
     }
 
-    xen_hvm_modified_memory(start, length);
+    if (xen_enabled()) {
+        xen_hvm_modified_memory(start, length);
+    }
 }
 
 #if !defined(_WIN32)
@@ -418,7 +420,9 @@ uint64_t cpu_physical_memory_set_dirty_lebitmap(unsigned long *bitmap,
             }
         }
 
-        xen_hvm_modified_memory(start, pages << TARGET_PAGE_BITS);
+        if (xen_enabled()) {
+            xen_hvm_modified_memory(start, pages << TARGET_PAGE_BITS);
+        }
     } else {
         uint8_t clients = tcg_enabled() ? DIRTY_CLIENTS_ALL : DIRTY_CLIENTS_NOCODE;
 
-- 
2.39.5


