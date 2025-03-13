Return-Path: <kvm+bounces-40956-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 31193A5FC08
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 17:39:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2ED163B5589
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 16:39:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88EC126A0C5;
	Thu, 13 Mar 2025 16:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="YEZz/p73"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 417C026A09A
	for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 16:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741883961; cv=none; b=ZiCqwvyKb1NzvHfkKfocDr6H2SrasleAB/meaYrPo/uw8ntnKEqX13Ks8eV7azeouuj+EvYPfbrNWkrascrBomLWMFR1RmTpQEJe9G50v2VE9Hq2d8OEQ7RG8pmNBz/KmBNbRbrChxedq3Lf6Xqz0MbhRZfymCCo61G/itGpWUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741883961; c=relaxed/simple;
	bh=aHcHDSCEQG/Lxg84jg/rjAhvQowTiiMszTRoQh+zwoY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IhD6zxPqs6TsPnySu0S1BxKJxWA/iwCN7XAGdGJISm10jGF3itROD9JFYvwq6QRHtgl/MpFjf8cbnlYn6CZJeCOzV81pvZSP8/C5C/N7vn8EIHs9XmpTLxHwQplFua2Vt5LHAWVPLEotBJqjRcjw4pOcUdhwg/LPZL4o8hK9i9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=YEZz/p73; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-2ff799d99dcso2532069a91.1
        for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 09:39:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741883959; x=1742488759; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bYYGOsy+zcSjxVOnigwMonGaAhWbZB7W76ZyOX5Jlgc=;
        b=YEZz/p7337XaTbioiRqmlI2C29iWfqRqL6T4TbiZSHy9bJ9XLmWryjuk2F4OYY+nyQ
         e+LDQZtqPzdCqzydzGbeW25Vot3m1vxe62p4uZys6GcILnhG6MlH7VyKvQ8YJtWM/mhu
         EBJ5hT1FMH09FIXCk+hkU1aA/avQT2vs+ljtHgf0iuGIw8hMORo+VvzbG3C4Qa6QE84X
         iJwDHjwW0i7v3tuThkDvv+we+G/y7DfKX4LK9soIvxKHxvAt8aa/kticfexHoPz9RdXk
         9e2ea1i7Jnzll5GTNgTI9dHtchdfhmNDWF/Tx/YUZP5g6zQHljU52abNG5FBaaQEEH6J
         Vvvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741883959; x=1742488759;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bYYGOsy+zcSjxVOnigwMonGaAhWbZB7W76ZyOX5Jlgc=;
        b=dgqN7jv2SZObsX3hvaODKyBLUk0C/KSmo+C4DpgE6tMTnjQ4QcEahVlMSxLwgdQ8cz
         pFieeioFLBGHMgJJ0CxTHKIoqz8Xk+BR3xRHM2UcqPaaJyIw4d3JEciWP/ham0C/TsDS
         GgkWHzy23ErTRhjkA3WdGp+S1IPiN+H89b4m8JgOXq/JPCNzoMH5DtzlzDy65UusPrpZ
         VmrbTuWqzqocVWS/sEN3xlyl6sFIpPgxjO8pMGiCOww+2aQ1bhwYBTmosP6QrsgulFNu
         q2g7C91BdWAAaK/mpSnbU3AcKWcB6cNgrqvwxD/g2xHD8o2fFNe4rUZ9AcVG1CfiV5sd
         VESQ==
X-Forwarded-Encrypted: i=1; AJvYcCWIHoKOFN1ttbZu9YReOvIdcJOxXIjGG7mzd2/1MO4AfFc+zbfAfomL+tcwIHzUqOHHd8U=@vger.kernel.org
X-Gm-Message-State: AOJu0YyPAseJ0u/lU3RasbBSybcZTYDpjt+79YYz01FVqkE+vXZnw5F8
	bYg3lMqtAV2cakux7+KWRKoCjTnLfxsf6B3A1Mmyf5GDNbXI1vogWDht6/26s9c=
X-Gm-Gg: ASbGncv5qe4p9A2XEj0bV40DKTYEnZWnkWpk+wYHrg1qrwo0oJxPUstEbaXn8WnBGZq
	8EA53UquxnzJ9nvwOsqDrVHKBpZtv+A7hBZDuCps9DEXKtJBkQ90AW/YGPQxGewK2YmofLnnn4+
	ITQndgXERMagVc7QxxGfccEACScaodt8/Jdu3BsaRN8lX+TD9a8hP30zDlQnIVNozy9LUamSqoU
	Yh0I8LvpfW+TbkBG80qd0OXhN+KHpP0Hxz5I5WfyJKPCYohptOlKxDQ3jQezidWMZAtoprtuY03
	Mp3lx5f3ysVjFw988ekFmMRcLzXNh1r3Qd7h+kkiJB12
X-Google-Smtp-Source: AGHT+IGIP+en0Aj0eYAe+7XhNeZ6W7zp31secPtMQkoPMAwiLZjQzktFWA/FDeyZICzvqUiJA1imgg==
X-Received: by 2002:a17:90b:54c4:b0:2ff:52b8:2767 with SMTP id 98e67ed59e1d1-3014e8619f7mr247106a91.19.1741883959525;
        Thu, 13 Mar 2025 09:39:19 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30119265938sm4020084a91.39.2025.03.13.09.39.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Mar 2025 09:39:19 -0700 (PDT)
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
Subject: [PATCH v4 07/17] exec/exec-all: remove dependency on cpu.h
Date: Thu, 13 Mar 2025 09:38:53 -0700
Message-Id: <20250313163903.1738581-8-pierrick.bouvier@linaro.org>
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

Previous commit changed files relying transitively on it.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 include/exec/exec-all.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/exec/exec-all.h b/include/exec/exec-all.h
index dd5c40f2233..19b0eda44a7 100644
--- a/include/exec/exec-all.h
+++ b/include/exec/exec-all.h
@@ -20,7 +20,6 @@
 #ifndef EXEC_ALL_H
 #define EXEC_ALL_H
 
-#include "cpu.h"
 #if defined(CONFIG_USER_ONLY)
 #include "exec/cpu_ldst.h"
 #endif
-- 
2.39.5


