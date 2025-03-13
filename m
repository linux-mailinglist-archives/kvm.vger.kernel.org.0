Return-Path: <kvm+bounces-40957-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E018A5FC0A
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 17:40:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C188716CAF4
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 16:39:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84BCF26A0DB;
	Thu, 13 Mar 2025 16:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ZIoeOqoO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CF7126A0AF
	for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 16:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741883962; cv=none; b=UPhjND3wKENBaNo2ZEM7mAijfl4w+YurlmTKJko02TCpSvcMfx0c2cAULKb//fAAfchsti3xCaQ2mjZPUrYc8FYuTdnycNstf6IfFBy7vozrfmNhRbVcuQdCrmXWz3WSrJrZq5H2qlAw24G/D82IxAlYOp2aC7K7XuDEUvWwwZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741883962; c=relaxed/simple;
	bh=072rJgb1v8WTOR3ndNWM1YDjHaA2UGkZkEMRddxYphA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gTEF3t9wEBA1Yfy/S2GQ6HPtx7edNAnEJ9JDs+c4/jdoOlzpud2aN1YThFOovAif+GYgRncH9anQaj0E3vh/PBco521qL5WFAJ+39miKznGWxzcdRZY161x1GvczmqacziRDLnRgBMdD+3+eFHesc00gOxb9o2IQ09VlORooZMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ZIoeOqoO; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-2ff6e91cff5so2131038a91.2
        for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 09:39:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741883960; x=1742488760; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rp8GQC6vA5rTxSSazblnkjuLZPjrJAYUOFg9uGM493s=;
        b=ZIoeOqoOnszgFjIbf5Yv+3z/TDcTE3CpiwSyQ7nTaPWhkuGTxdkLbzuIyKJaBZ8JpA
         ma2ngqSDJE+HEG7NMad5I/tRrlFCPK7FCAyZhzfw8ExHRpLYC6CC3kgAc3z+OyhDsAoK
         vxcxh38EffMLGaBoXgvIb0FLckjBWnbONiauSE5oCvuMb3Xeh2uj5nE6DcC/ZrIGNS7q
         ech0o9u3ne6OKX8gKV9OiVd5zOY7vF5NTnkyjGX421kyNjAT5NVDEnDMDbH94FV3Hxu/
         /LKN4lnXRHzLdHrLskLabzDlNe0Om7N0+dTytcFc2bGZrGwWtRxctsIe89s4d0Ckl2RY
         /J9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741883960; x=1742488760;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Rp8GQC6vA5rTxSSazblnkjuLZPjrJAYUOFg9uGM493s=;
        b=NOtBJ+7K9R2vDsB60FB7BbnmuV3DwycnnVMaVgo0Lk+dwxroBS9f/zlZr0Te+g/nO9
         3wDatOmaGZMgYEfhBzOE53wduveVt++d91iAvnzz9ZoVnLDC6N3AtMU4z52Z5qehBPSw
         ZvxBcNTsunrgfXfTjs3Fp+mBJ2K8CtanzhfyG5FkRbA/KdvR7Wg5nLti2PI1iAaIrb0T
         KdqD8tEfv81huFbbYDinAPWhZJQGX2M3mlaexO+5qe7v5twjtWsiJm2gjA1Z4j3cDxk6
         jjBCva88c+tAFEuoZGEK9WnDPF5mVB8sptF5V97ZA3ZXj/eoAcl2daPH3qas4g4CBjhP
         acwQ==
X-Forwarded-Encrypted: i=1; AJvYcCVl9j2k4HISkAMh/cJpg9DvSEyU2nTAHbvw1nezFJp4Yd4/V9uL2NpIKSozMf2XWeFRnVs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwtwE9/soEbBEguQPSh8I6LvRNl1HUBjYh3EdOkbAEIngezncV/
	pVxomBsFCXTfmkh44QPKSEqRBQcoPnN7NMsJmw8zf2UEwBlyKekeLaypvVEVpkA=
X-Gm-Gg: ASbGnctzVDZTcbvnanxTmLJ3dtEgdMAni7HRHJo/YOdVYUnhX1O9bWlGll45W1jTs1c
	aXVcdHl/gZHuYNCK0nZW++jadKXJCUp0ZJYxHfnkReUX10gX+Z70l0NHOhOwZrPurFh6FYcNjZ1
	l32cuTcdHu6jP06cynMn9fIQjhW6YSV/IZghm1QlzaBYIdNkczTwqiSoGcs8wSP3E/fzA26wF20
	/Cbr185k8xC0a3bo2Sy9XmcQ2rpFTd6Q4ac7au3mIC8Oil887024DURfr8BdWqNlGPDngq6/8Z9
	kQX5EhMtGCXtYmNAD+Fugrf/bHZM6J/UWTTart2iCjHw
X-Google-Smtp-Source: AGHT+IGZzjulkQU+BByDQKOIMhSKMvzNQK3Jb1Ldmjqqry9imNMjEt/+F7i1NK8ViRkyqUoEaWDauw==
X-Received: by 2002:a17:90b:4f41:b0:2ee:c2b5:97a0 with SMTP id 98e67ed59e1d1-3014ea23938mr221254a91.25.1741883960596;
        Thu, 13 Mar 2025 09:39:20 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30119265938sm4020084a91.39.2025.03.13.09.39.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Mar 2025 09:39:20 -0700 (PDT)
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
Subject: [PATCH v4 08/17] exec/memory-internal: remove dependency on cpu.h
Date: Thu, 13 Mar 2025 09:38:54 -0700
Message-Id: <20250313163903.1738581-9-pierrick.bouvier@linaro.org>
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

Needed so compilation units including it can be common.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 include/exec/memory-internal.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/exec/memory-internal.h b/include/exec/memory-internal.h
index 100c1237ac2..b729f3b25ad 100644
--- a/include/exec/memory-internal.h
+++ b/include/exec/memory-internal.h
@@ -20,8 +20,6 @@
 #ifndef MEMORY_INTERNAL_H
 #define MEMORY_INTERNAL_H
 
-#include "cpu.h"
-
 #ifndef CONFIG_USER_ONLY
 static inline AddressSpaceDispatch *flatview_to_dispatch(FlatView *fv)
 {
-- 
2.39.5


