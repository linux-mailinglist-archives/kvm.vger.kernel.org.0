Return-Path: <kvm+bounces-41298-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C960A65CBC
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 19:35:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0FDF37AAE29
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 18:34:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66AA81EFF97;
	Mon, 17 Mar 2025 18:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="g65ACxnw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F0E91EB5C8
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 18:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742236479; cv=none; b=PDVc9ewAvG7p/hs0/LgM5pNH0Tbfw3vLS/Qae/LE3JJ8hx2VIcEaC3D1WJWAsW2MMWP8q/LT00tRtkM1LdImACZmQ68sGY28m5RPZzne92sW8Ec6kjF4BWhrbNMrwUHQs+RxXOZ+MZ7f27JoiuJqfCp3msO/g3uZBtSEejSWBNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742236479; c=relaxed/simple;
	bh=ym8vi7HBFMN71o/ytWbPTEvymne8dwvUZJtelFdMdmA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=B9P5m8aDbvrWgvaM3oKwYW+d7e5s/boLR3MJQJnCCEnQZJf6tXcC8yqclHUE5CKM4Ho2FeWXt4/Cuf87gnbXiApLv90419HF3PnrqJmJ7hUgd34LeOZjje11BrA+OSwVdDDf1TMjlsB3mRolL2jtAoYS3N0SKhCFcjSgnWRSzx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=g65ACxnw; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-225df540edcso61414625ad.0
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 11:34:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742236477; x=1742841277; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PABH8iZPN9WF+wJr72ZMp6Lm7i1C+9jWBJAvssLik90=;
        b=g65ACxnw2mr/bPPWo//ZKBsAX0WXcaOjUFCEKK6pZDFpiWN///RPfB/YZ0Wfdno8SF
         98chrxVnVbPmAp+k2a5i7VBGDC0BZYdahtLOPMw/lKDTUzEjLEz+BSf3B1OIUmFO7+29
         VkpL2CavQ7XrVvUZ4hKn/FXd98mzjwyCNWtVy6B/GSX0QIYwrpPbCSzypVlEEBvxn9Hr
         RTPfoSGrlzYMeH0lYqt0ClrkR8/JOc5Y8d8BEM4OoxRCe472pZyxsSCeiJvV33YyDZi+
         y94z65G3qjjGtrZCzG8vYvjQKRUpzeFmli5K7jXW556c4yyi/u6nnappMn74AgbO8VDL
         Feaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742236477; x=1742841277;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PABH8iZPN9WF+wJr72ZMp6Lm7i1C+9jWBJAvssLik90=;
        b=J/ihwEeLP4DCJqTF1foxaqvXHwgnX6i/9d+DTL043NOd521r8Az6cy63RM09Zt9vdD
         aLrLlwl9WiD0vHGTj6AsKkw7SKhwQujzbqlveOlgR9l0mGlEntTElCNYUz6c/82rgEAa
         DLykZ1Ce3k2FN0d2EJVnHP4P8ETKBcGNqHv4YgjkgJg3v1pZczCDm1rp6BaFZHZ+8JHE
         6PplWe2cMRsFr/Js5paIkS45tqlIuSIfiOdbA0cIKvaCcPDEQ1wG/Ea/POkz3O6queo9
         HEwYysQpX5hYhby0ILixg94JEor8Bd+WFl8f95kXSk4VGr42kS3OfTxZDLETp6W2mCKn
         f2NQ==
X-Forwarded-Encrypted: i=1; AJvYcCUtG0vNtePMU7l/nslWLbPOrjSXI0Aw5/NtEYCwOGRsML4H19YXuNeCDSJrGxOP+P2s10Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YwksKVLtCZeOCL9ZXK1362uRIOlCrGhBvhM+jIwRZal3UyRnueI
	t5/UtrRL35e9nB9q8RhxdTlvEW84YgC7lAH9fE6iQ9Sh0ima5iCDz/6ssZLL0Yg=
X-Gm-Gg: ASbGncuAHONpOr67IiRRoSOxfMlJZKKYuuak1U8C4qFu/vo/yhH8kOYktHpBD9ZvGJO
	26FefS9N35ZEMzyKqEWquyXVUzrw/z77FuQdV54lAGVyyUT0XAE2CjWe+CT6V3tffCYQTfRP+0c
	y4mMPpX9upGqkyFuL7WmW/1RV62cdBt8OB4UC/UGmYTbmqaYYGg2HPkruA7MzfjeawM5GHkxSkw
	Dyk6hayBgoYKmuLpZK+MgQVvX41TnomN9XJiLNgM7Y66pgDj6DDhreYyhHHYvOwWi5P8rtqLxwY
	ElpFTqg+DVAyq4k4c0ZcnmJPiaiOWEHYOYJWF0Q7SWGs
X-Google-Smtp-Source: AGHT+IG3g1g1/S4GhLMViIQmdttYJlPvvQDr2HFvFncsoI+sX7+pFPl4do/KG0rupNOCudw5OLu0nA==
X-Received: by 2002:a05:6a00:2d8a:b0:732:5875:eb95 with SMTP id d2e1a72fcca58-7375778c1femr704383b3a.4.1742236477316;
        Mon, 17 Mar 2025 11:34:37 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73711695a2esm8188770b3a.144.2025.03.17.11.34.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Mar 2025 11:34:36 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paul Durrant <paul@xen.org>,
	xen-devel@lists.xenproject.org,
	David Hildenbrand <david@redhat.com>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	qemu-riscv@nongnu.org,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	alex.bennee@linaro.org,
	manos.pitsidianakis@linaro.org,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Alistair Francis <alistair.francis@wdc.com>,
	qemu-ppc@nongnu.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Weiwei Li <liwei1518@gmail.com>,
	kvm@vger.kernel.org,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Peter Xu <peterx@redhat.com>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Anthony PERARD <anthony@xenproject.org>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v6 11/18] exec/ram_addr: call xen_hvm_modified_memory only if xen is enabled
Date: Mon, 17 Mar 2025 11:34:10 -0700
Message-Id: <20250317183417.285700-12-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250317183417.285700-1-pierrick.bouvier@linaro.org>
References: <20250317183417.285700-1-pierrick.bouvier@linaro.org>
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
index f5d574261a3..92e8708af76 100644
--- a/include/exec/ram_addr.h
+++ b/include/exec/ram_addr.h
@@ -339,7 +339,9 @@ static inline void cpu_physical_memory_set_dirty_range(ram_addr_t start,
         }
     }
 
-    xen_hvm_modified_memory(start, length);
+    if (xen_enabled()) {
+        xen_hvm_modified_memory(start, length);
+    }
 }
 
 #if !defined(_WIN32)
@@ -415,7 +417,9 @@ uint64_t cpu_physical_memory_set_dirty_lebitmap(unsigned long *bitmap,
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


