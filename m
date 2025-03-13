Return-Path: <kvm+bounces-40960-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 16969A5FC0D
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 17:40:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3A9063BA287
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 16:40:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F13CD26A1A8;
	Thu, 13 Mar 2025 16:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="eF9zmOlo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B925E26A0EB
	for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 16:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741883966; cv=none; b=qLut7TuoHsTIQE2riraUJ1HeeWE3lu9cEXDbNA3DAo6bksqsY6/GNSP/GtzXbN2lLhK4twmY3xEAmh3zkMwQvZYkED1rocf3leVjSarlGuUha8iDZ4chN37kF4zq3EX/pgx+D9esGrwms6HBVPEit9WIUBPsYDYTPyX9WjvJA3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741883966; c=relaxed/simple;
	bh=ym8vi7HBFMN71o/ytWbPTEvymne8dwvUZJtelFdMdmA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hglGvWGSjVuKB3F9VKqrzJ7/YfOfhy8zaLsdkz/41WQVdt85xRIcKr4XRBMjA0eSXfLtCDinE2CbHwG+PHjI65v53b5XJZGKt7ZsnNIsSGZxmKrc4c+9F+Jra9vKx2TessPI3Ep+Njjm3JZ/ZQEIVbYy8Sv6/IrdQYd3QMJjcuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=eF9zmOlo; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-2ff615a114bso4342444a91.0
        for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 09:39:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741883964; x=1742488764; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PABH8iZPN9WF+wJr72ZMp6Lm7i1C+9jWBJAvssLik90=;
        b=eF9zmOlopMCc62QlMcAmMXsAZspwaHJV5fFX7CYM/AqJnGMRWfJmycOaUhaGot4EEi
         DMT5ZGuZXiaiNjRCwUv6GVwllDBxIkfl4LNDZizCIoaPF4a2htZutmKs7Y5zWI/6yUui
         As0I9SFeMVrTIPbFGDSKA5TcWdOZkBVE/aLjBacfUgqi9Hk2VnPEd0cXqw+PMknEn0RG
         H/jbhaUouw/M8eECohusaQ7i8YzpnrPI6dQ+ReGGPqH+51gACunMBnaWpfSc0wTVYANO
         cYNnI3I73pvDGUmin46g6+5y1JCZMW1epk+m+LAWQsCFytDW6nCmpiRj00zLy5YjMFm9
         ZmXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741883964; x=1742488764;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PABH8iZPN9WF+wJr72ZMp6Lm7i1C+9jWBJAvssLik90=;
        b=eW6OkCCH6BNN95kNBo/NMHFdFxdjZ/aaog4pkTId9F9Vo2EEy8+INWO1aBxUxVsq9Q
         zIObthErxQcBuBLFYu7tCVye11CPQidvuGdAbyhJBgBsP0QBMuYEr+tjqu5ydEihIzxU
         FcfnvriZqWzQWoMB0HrMcurqdWnr4T7Kf/3GIHPcf8FdSaUElzqSw1GX/T+cFf5ZEfBJ
         vwFUV1EabLqXaYuwxXDFcngCpqGdid0p3HBfk9T7+9k4qRn6I6R47z8XbK9eNVKCxKRe
         r5Vs05Ewu2b+Io8PslNe0pRLMXD7yd8SzuUUQNK7XcB7teMZ5nKp3kLsGIcbVPKJ9qb6
         9f6g==
X-Forwarded-Encrypted: i=1; AJvYcCVahM7eqobGqZpiwnkGTb4uckGaX1lkyMHcEZkeO3MpxaAIl69kT/BumQp8BvXyDcpOA2U=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywu9g2SsR5WE50fB9eNtHPlcRCnAavlItX4J3lAbZOeYTpKPucG
	y9T6zLURmNmgwkYaPQBC+FfxM2QAQhKOU21cYeDq8vvtS1nVadrkVpT5vDtggzQ=
X-Gm-Gg: ASbGncv3d87yGvpGNQsYgqsqHnSGM/lMIwBWffeCldb/vu7PnO0EkO0DghMoag7Aqpa
	Fg+uR9APW7lEHFTXd6bRv9rideGy8sX07fxbA9WQ0Ulx2+Zof2QHBJFKSngNAjFtw2MXEumR0vV
	YD5FodIBN5Lh0f+lCnxW58KVXFnP2wP8oPFBCd4GrI4vD5zseKbgKzqKjQMiGwKx5o0N0A/qHgH
	0cIE7Ix2cf8Rf4yULRRftlTq0YUfGOztNp6vpMBFBrQ0sR+YhyHtcHEtMpPoYKStUq76TK1CJbF
	+CjIRyvv+y19DMspfnOWIG32t64gJCV+IUJka8mFmZ+tc2GtHj70HkM=
X-Google-Smtp-Source: AGHT+IFBCzdx2RE2XSuvFzfGvZFs1Ld7NKM4NGPSUQ/nU1Uh9fZ+kP54v1OAyBR0HlgDCGZ75ow8Ew==
X-Received: by 2002:a17:90b:2f0d:b0:2ee:9661:eafb with SMTP id 98e67ed59e1d1-30135ed493amr4421602a91.12.1741883964075;
        Thu, 13 Mar 2025 09:39:24 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30119265938sm4020084a91.39.2025.03.13.09.39.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Mar 2025 09:39:23 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paul Durrant <paul@xen.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	xen-devel@lists.xenproject.org,
	Peter Xu <peterx@redhat.com>,
	alex.bennee@linaro.org,
	manos.pitsidianakis@linaro.org,
	Stefano Stabellini <sstabellini@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	qemu-ppc@nongnu.org,
	Richard Henderson <richard.henderson@linaro.org>,
	kvm@vger.kernel.org,
	David Hildenbrand <david@redhat.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Weiwei Li <liwei1518@gmail.com>,
	qemu-riscv@nongnu.org,
	Alistair Francis <alistair.francis@wdc.com>,
	Anthony PERARD <anthony@xenproject.org>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v4 11/17] exec/ram_addr: call xen_hvm_modified_memory only if xen is enabled
Date: Thu, 13 Mar 2025 09:38:57 -0700
Message-Id: <20250313163903.1738581-12-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250313163903.1738581-1-pierrick.bouvier@linaro.org>
References: <20250313163903.1738581-1-pierrick.bouvier@linaro.org>
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


