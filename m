Return-Path: <kvm+bounces-40729-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A3E45A5B7D4
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 05:10:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 522D03B0758
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 04:09:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 049881EE01F;
	Tue, 11 Mar 2025 04:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="nHdwx2XS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C18EE1EB19B
	for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 04:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741666148; cv=none; b=LvuWhpWyBKTwxCZcsmBdS3djXpVfa4yZKDnLTciPmana5zqftYfKul4uzaooBMbb5+vnklsqypsddFSrAq1R3tCq9TYYFUjpsUz7YuXIj9ETGulun6sTz5e2YkjZ1D4SU1fPccu7uByn0Efb8vGPn9/MEPqTk9oo7TPUlpvqpVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741666148; c=relaxed/simple;
	bh=nP4hXHDVJqx/oRSSlzZDpBYh7vDF8y+p4rncNlqlHYo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=uvgzsPlLUWgX+nmMi9Q3uRU/adU59+nkl4/XFINmPJ1EP0pA8j1lvXLA+CcJTT1dTh+zWubpZJnjtfEHay4NBajq+KdlHL8Y05VM9OmuuW8EcWN1D4IcVQmE/MC1uSzllXAQ/OJ3a0+3reW7lknO+pEq/UDZmpXdzaqT1pgg46k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=nHdwx2XS; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2240b4de12bso87519245ad.2
        for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 21:09:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741666146; x=1742270946; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S847jAMJoPTCQP5Yv6FtgKXIrkXeVt152gZ92AA3GhI=;
        b=nHdwx2XSWE8qeRfviIJW2cC+lJaNKd+39nvA0pGvhSNSbyj37uGSkcdtodCAUPsdRh
         jyxw7gmP3wKcPhQq76CnaiLBPcummYL2d6rTfy76uIRFwBHKI/UI9n4oU8WKp9W4vy2V
         xApIYk10HFCIe01utxFNQv5CjVkUfEMoL8myoymzySmS/CIUP+JKFjpviSNMouSY0b6g
         YEELjQSfVLnDVzdiXt05Y0bZ/loQsadzOJaHeNzn4d/TmjyD36+5+0vcxC16i0vGN9Tw
         yAa8V+95Q/9oamLjK1DEFh6QGR8S7X4wArDHrNs8cWz0CGFuW1fO9PHMp103mNHjBdek
         9vpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741666146; x=1742270946;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S847jAMJoPTCQP5Yv6FtgKXIrkXeVt152gZ92AA3GhI=;
        b=kklS6dQwBMCFQbuS1bu1gnYpptI4Kh8/xYFcAbjfAnTYDEcylAQfvM3v4fpkufL3Mc
         p7PsSyg8d9IGrzsmZqh5h/uMmFHobfKckOhROsvWqK8795CT2Es3rgb0nF0WfncY98B8
         Zz9g6D8+wLYbUxSVBNPCevhAPgPb3e1wwcW1v9FRgEac/N3qH2dsBrl8iqCdnlByk1yQ
         vufd6EX7rccwqFi/mlR1ltlDzQdUerFIfpRSByH08xkE5UeeZJyRiuPT/OP9aivsyP1U
         nIzL97BPanIXJk7MhAyLKmoWHKOqEKS7Fu0YCSrlLp0vCxqudQ8S+yAfU3fW0cJWy6ZZ
         STnA==
X-Forwarded-Encrypted: i=1; AJvYcCVMRTrHjuuoi9wzUd29U6A2xTGq7seaQ+C4MdPaGBxqHabO2V74DxZlWJUavXGDOoyOw0k=@vger.kernel.org
X-Gm-Message-State: AOJu0YyxEVuUH7ObUyki0qAs1OozChWPHBPL1bj56SoBpmyS/vWgDp72
	Tw9l9uLhnF5iOtEP2Nc2BgFLjbgleJGph9JCjWKEUWdYxqashbNcx8l0Rao3g10=
X-Gm-Gg: ASbGncsLvU5hrMXGQlkTXLI9DJzHkCnN+Mr2juJ8zX1V+2Ho3Q7S6U7VZ8T5cp8Oa4c
	Q/lo+qQZ4O1SOYAq8piMhjO+GmWwgwxjkusARj5IVvueD2vylPS8E3/I6jl6eVIZhOFYmhg53co
	qNORelrJKj9M4m+no1rcuST07T80UPA3JqBGx4SLCq21Psg5dx7dk/Xsv/DS4uSGtIFDxBnR65W
	oBWofmS4IL756/gRNLVpGbor5Ixoidw1WRkWeu5RIAKa+vsHqFhaNyCCCtIFcycsorf+ipTnARj
	Cj3DLfk67kGqo3uAZiWwnxMm5Q4ZbzejA9A8I1Bai+6r
X-Google-Smtp-Source: AGHT+IE3Vl9B86Ve/DQiaAua/ITAo7nczT+bEsdawDqXZ5VAclVm0x5zL+4TIfw0f3xRMRf28fdfZw==
X-Received: by 2002:a05:6a21:516:b0:1f5:709d:e0c6 with SMTP id adf61e73a8af0-1f5709de3e1mr11267027637.42.1741666146178;
        Mon, 10 Mar 2025 21:09:06 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-af28c0339cesm7324454a12.46.2025.03.10.21.09.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Mar 2025 21:09:05 -0700 (PDT)
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
Subject: [PATCH v2 08/16] exec/memory-internal: remove dependency on cpu.h
Date: Mon, 10 Mar 2025 21:08:30 -0700
Message-Id: <20250311040838.3937136-9-pierrick.bouvier@linaro.org>
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


