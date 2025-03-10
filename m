Return-Path: <kvm+bounces-40558-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EE0E5A58B64
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 06:00:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B04B73AA580
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 04:59:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B12F1D5CEA;
	Mon, 10 Mar 2025 04:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="u6uq8vn3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0192A1D5AA9
	for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 04:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741582746; cv=none; b=E2ZSI8bNd09uVnobVGTtWxfGvYDCj54MBA0CWZsmEiG/dtjglkuHFET3UfmT/03rQ4i2jxtGSXBI7tWAj2NsiEfuItN4uU0LXLNbDuBm+jUgqY9vQknkpnEorm8jFPM5y/9HaU4xZ0yfMs7yzp/rSyWMbJ5C1T8A5TjwMQRPV80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741582746; c=relaxed/simple;
	bh=DRwQTps5snJJdEBDNnVUJF1Cb/5/flcUiwsKRSOTXEE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GFr05bgKBVBvUCv8M8CMEEe9HCI0GzQ40MYgPAhULgpQEmq5oeUDWHd5Wmu+yOeDF7gkY9/KycjVMMRyzZtcoyoZ2GxrZuCNWkx8XXwXbGle8XOepO53jjROqJHRWVwS3jYcala/cFwfuDiGAR/HBceuqvFoydTUYhpBZOXBSOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=u6uq8vn3; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2240b4de12bso56093095ad.2
        for <kvm@vger.kernel.org>; Sun, 09 Mar 2025 21:59:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741582744; x=1742187544; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0+faf/Iypy1sVhFNFInOCPAbXVKj8STEbMMwCdFMyRw=;
        b=u6uq8vn3A8MmqUVHH0BwfZtD64hmexKZ+9/jc7Trg3bB4qBj+yvH7mwaLhqdL6siUr
         KsAeFCJFCdK4HyEM7M9soW2AnJXNvFSnJMZ1Ly2kUTmKhTsH32DCAvWDlYz+Ot5PC0eO
         ML1WzxJXZjtMe+9UfYJmLpFi2QGYxZpNI84pSgGlZGKbuvPgnDXg9nSx9yEGFfFiUzCd
         PWDRT/WYj/8doMMAzuGvZd4fKI+wqlf75dYfJNNM993wO/0YeluKVYZtpz5w8Y4ce9jX
         XrXxaJtaj07Atect4qWOrapkzJ8csn9kOm9In3Y7vzrelv65TszzTCv/qYeCtOUSHzH7
         acMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741582744; x=1742187544;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0+faf/Iypy1sVhFNFInOCPAbXVKj8STEbMMwCdFMyRw=;
        b=NEyXeEjZKUbnb8Ewo8gkAlRDaozFYx5NSs7epi7AQq72dLDNX0GkmnAiwSEUExcBQG
         4lQEeh0f+XZZBfIO1NMy5URamlmRfO/HX+xKOXNBlne5k3IuBrBAstV6miFHzkE6Kr6l
         LhUh0IR1K2jzdYqETL5DzZob5bQWbO1Q0TVsczOcazmfz5iOxBGSv/YSfsi2gvvAYj3P
         X9Gq8jyQKK9054NrSF8o+7nmbSLKgXV/1F5KnindPjhkxd72seu94/pltdJ6rFntBHYN
         34I5XrUpw8Usn1+CGQlmcnGBEKlsyfKcLhwBB5O+t5kh6fldd8T7U5oPkGtHOOXuHJ0b
         9+/Q==
X-Forwarded-Encrypted: i=1; AJvYcCV34n44pyxaoHMdaU8KhCPxpOMAq2Xa/PmFZe+z+8IDbpA0T8ZVINF1IJT9NsferHG+2Rw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwcQfZjyhgtF6TIxN+w9Z/7Ba8zGR8amzVPmQJtVcELgBRLy1z6
	nS2JhqVfUc12sy4qXa/ZgTJgJh35FYW6LpMWzq0T5EFJcOnMM49kuBx/5jAwILM=
X-Gm-Gg: ASbGncsYvkZrr+86WvDjx7Bvda4aPOxTIVMVWeZFxPNat+g44KA8YZ/txqUT7jRUAxZ
	talcNvzXXtac1EuRqkF3PjpAZB+kBnKK/y47JOsu4skq0jIX6KSmntPIe35t9qnQ/JznERIMAur
	GC/n6Fg5P7lcN1dTkjyStxNyYS+Lm0nnwxsOIQxyWAKbM5K/M9Y4wfm4ZBFnn7oD/43WmKp5wT2
	Xgsm4v8VaM92iVDfsMPhDiC20p5AKMNaq1Nhb8pbtx2CjhJ0gFmhaUEWKeruRbg4upV/h/fzHAU
	g57ulzqbYCr2aEfvifowvrORvY14axQ4L+SBDu8DACPh/ycvIoNx8S4=
X-Google-Smtp-Source: AGHT+IHvC7npbpjr3DTdxoZwzYb1dM7G7lfM3pxuLeNMzVZpdYuqkJ12UM6z/Bptz/oCAInuSIhPSQ==
X-Received: by 2002:a05:6a20:a11f:b0:1f3:2d62:3151 with SMTP id adf61e73a8af0-1f544acc6camr22843444637.7.1741582744338;
        Sun, 09 Mar 2025 21:59:04 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-736d2ae318csm1708308b3a.53.2025.03.09.21.59.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Mar 2025 21:59:03 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-ppc@nongnu.org,
	Alistair Francis <alistair.francis@wdc.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	alex.bennee@linaro.org,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	kvm@vger.kernel.org,
	Peter Xu <peterx@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>,
	Weiwei Li <liwei1518@gmail.com>,
	Paul Durrant <paul@xen.org>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Anthony PERARD <anthony@xenproject.org>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	manos.pitsidianakis@linaro.org,
	qemu-riscv@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	xen-devel@lists.xenproject.org,
	Stefano Stabellini <sstabellini@kernel.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH 12/16] exec/ram_addr: call xen_hvm_modified_memory only if xen is enabled
Date: Sun,  9 Mar 2025 21:58:38 -0700
Message-Id: <20250310045842.2650784-13-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250310045842.2650784-1-pierrick.bouvier@linaro.org>
References: <20250310045842.2650784-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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


