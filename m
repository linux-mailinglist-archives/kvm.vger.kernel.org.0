Return-Path: <kvm+bounces-41098-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 44556A617CA
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 18:33:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 55A9F3BF88F
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 17:32:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD7F02054F6;
	Fri, 14 Mar 2025 17:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dIQ3qdXQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9130C204F94
	for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 17:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741973520; cv=none; b=QnjbJxvtPXjTHR+2z4mIcYK9M40ram4Y6LtFM2V0scjwUyH3Erd0LwRPULl+GaSM1rEFEvgAX5YvCAvCe/xAil5fJGFn7QqdRs7HUxaL+895ndGcwDfOLJcBcOvUapLq9DPp1cEiqW72NOO5RwExhY5A8RUCix33Kio7ohtFW5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741973520; c=relaxed/simple;
	bh=ym8vi7HBFMN71o/ytWbPTEvymne8dwvUZJtelFdMdmA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Bx0hnwbRiHyTyviRTJjaDlZ2c3NRfYlUrtz92FeDyKCgcBxja9NWIlr1w+CX+7mvfxM+c7xCo4rTxncf4Bw8PH/K/NZZLkmFQNqH3LNxsBKfQ9KJkFfvrZZaXzxwuaTZljX5p9O0FAFDlCZ7h0m3ja6yIAgHh26kJSdfOyleQR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=dIQ3qdXQ; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2232aead377so53469885ad.0
        for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 10:31:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741973518; x=1742578318; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PABH8iZPN9WF+wJr72ZMp6Lm7i1C+9jWBJAvssLik90=;
        b=dIQ3qdXQFa8U8OHiPk9kGZTv8sM/aXnV2Ckn39zCF6To+CZHptgtnqyImNbhFLm1MB
         TdLge4dT1q8c2ZDQj3w3vbThOd8N8ur9jDgwchT2znG4fsHFSKwG6nH6nhPiBGpJ6fh8
         /r7ho3qHf2XTkNT6yjjqInmaohuAciTbCFrVKrRBh6tsV/0IsepZNWTx4JU0/FGuvo13
         k7dA2nDV6AdNaJiibW+YgsNZxf7Adbd/3V6PK1/rCVmkXQ2rljad8qKD2Ck7THaoKfMm
         eXtZK27Fz+zbBVbJsGNQOqsdYW6c9ACT6pcKvVDsj5E136QI3uae/BhvyJTnjaoneJhu
         mdaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741973518; x=1742578318;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PABH8iZPN9WF+wJr72ZMp6Lm7i1C+9jWBJAvssLik90=;
        b=Uad3oCl197PlOCbu8XhcC0GOKz+GbM059jkq78U5fl+6+UAf6uqsLjkuIL/g2F0VC7
         tW3SRh5IO09rGLAxa9aJ99L4zMWq2hqQ5JEhfICaJj85VeeapNLMJWehDroYIzIWIvB4
         1S0PmZnXlvwSkwNw48/7WLczU4MarEthht+9sCCYUmX3QxpKj1yU0F3qNBxX9whF+KwV
         2kuRATAR6ovV4b/X4VDscy+zzywwBdwwy3qaGjAzzgGljUCX5cKqJIDNK8MYH/xR0UqM
         h7FAQLJKtQty4MPEyIZpeEgFcpfuoH6f39Vq5FlNcdWqxNU3nAFZE30TK0YZrwZznvY3
         Gzjg==
X-Forwarded-Encrypted: i=1; AJvYcCUnKOQqq+g61pyTNpLuwO6YkFZEsqeleBhJG3onmBgcJalhnobU6OVghdCBreYkIgtJfo0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyrIZgPwh3zm2HQZc3mzUFEpRbrpJxZm62FUpd6Cmc+Zopj6iSd
	Ae6O6WbYQZYTp1Iusb+DrQS+PssC0KgsO9DZMhUQlJhaAeQx6gMhn+rJfmS8QnY=
X-Gm-Gg: ASbGncvkYdZNXBZSeqzD8LqyNdhOS/2ZmEaf11HWBZqO8iNyRQDDfh7HLGt0yjAb4yi
	Tk4F/mliVJv16NmOr8Ssfs619KpYDl3J5X4RssQ2IU+gLCORkin+OjZ/vsYUZazaqHl6dJ61aDD
	6kJ+hoLrSX2CyUOBuJEChjNNnJtnE23ADsVh9sbE9sqvAj44nojOWUMsPZhqolXER2KqxqSUaX4
	FCwK9uGFELWKuxnYVrWUBcaUBKAgND/EeQwuUaRLOEEoPvq6q8030EvjObvtHI7o4cNy9ilZUw7
	Z43mZla+ueWYNYgJhMGvUMCdJcbHUgevnfc5X3dGNYW+
X-Google-Smtp-Source: AGHT+IGnTvSqXO1fzlE+2xVmojsF7Bo5wJQ+q4TppfmkSKTjR2FsyvyfU5Ot+87AVkRJkvXuDcvBmA==
X-Received: by 2002:a05:6a00:228e:b0:736:562b:9a9c with SMTP id d2e1a72fcca58-7372242d387mr4348766b3a.18.1741973517785;
        Fri, 14 Mar 2025 10:31:57 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-af56e9cd03bsm2990529a12.8.2025.03.14.10.31.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Mar 2025 10:31:57 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-ppc@nongnu.org,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Paul Durrant <paul@xen.org>,
	Peter Xu <peterx@redhat.com>,
	alex.bennee@linaro.org,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	qemu-riscv@nongnu.org,
	manos.pitsidianakis@linaro.org,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Anthony PERARD <anthony@xenproject.org>,
	kvm@vger.kernel.org,
	xen-devel@lists.xenproject.org,
	Stefano Stabellini <sstabellini@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Weiwei Li <liwei1518@gmail.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v5 11/17] exec/ram_addr: call xen_hvm_modified_memory only if xen is enabled
Date: Fri, 14 Mar 2025 10:31:33 -0700
Message-Id: <20250314173139.2122904-12-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250314173139.2122904-1-pierrick.bouvier@linaro.org>
References: <20250314173139.2122904-1-pierrick.bouvier@linaro.org>
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


