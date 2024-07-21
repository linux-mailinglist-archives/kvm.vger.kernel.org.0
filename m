Return-Path: <kvm+bounces-22023-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A31039383AE
	for <lists+kvm@lfdr.de>; Sun, 21 Jul 2024 09:06:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5069D1F2134C
	for <lists+kvm@lfdr.de>; Sun, 21 Jul 2024 07:06:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD2818F6A;
	Sun, 21 Jul 2024 07:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H5Cgmpjg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C03F88C0B
	for <kvm@vger.kernel.org>; Sun, 21 Jul 2024 07:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721545608; cv=none; b=fC5jneVnBChmmjnaxMr3alXtDZECP9t+S0dp9FfdCa4bwLwWlcUfdIRim5iwX2nD8ID9X6/lqfU9hwpDsKz6/1m1MtmOxtRHilIcguYWnCIbO07RMFUE7CUeDJEtFFu3yjTaV4lCCwhKZN0+xU/jV0AUFR0V3ECkd2mKixlmLcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721545608; c=relaxed/simple;
	bh=XRJl/uPgbWvSt8YMeQOUC5JnzlykeY0IhpbgHZkzhCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cJR2zIhI1upkU9+mKjWpU4rM89bovAXXkSvARsELwsmeukZ+0qMk3y7l6UaYURIIe4ZmtdZ8WxSVUB4oBOTfG/3xJfYP61mRcYc1BNPCOE02Nbyj5DGH4DYiB5ChB+L0/g7xV7feFIMDjlaoa6TddcU/cVKgcNOTyXI4UlCGq1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H5Cgmpjg; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-2cb566d528aso2028679a91.1
        for <kvm@vger.kernel.org>; Sun, 21 Jul 2024 00:06:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721545606; x=1722150406; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BEiXZ1Hftnd13V7cSXtmzxOOQFtbwN2az/SPk33hWyc=;
        b=H5CgmpjgeIJg7QBnUJMjPt+anfG363PYTnbysf4d+QFphVeWf8kz9jXaZYwQOFQwzJ
         25MNY9SKkdLYSkYrdneXh8qWipCHCu24K+DfrZQ1u8ZrmqyYzgvhhLPFXjnfcgMc7EZ7
         CgfXXSVLJTMdXfxBkqtn74nSs4DaXTLm9FzM46IFmXextzthx6I5J/VfyzlAFuGjTCtv
         nZF6CVgXD+6tHAY8seu7Uavs2fesu9p+lI/Ney3DWFCBY+0VXt9HnCYBALBewZIn8POv
         hwtxLTdG9x9Lrph61dA/vTAJtAj1IY5uBNR3htXcERXw1m5vm0gMoYqahK6Vw0/fVtDP
         X0jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721545606; x=1722150406;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BEiXZ1Hftnd13V7cSXtmzxOOQFtbwN2az/SPk33hWyc=;
        b=t3UTRiTQ8c1ehI1jiZ/8RjFYrAl+uQT+aWdLucUvmuYtcQqRPqSMIU8Dyphj60M665
         5NdiggxeeK1jxf1KcdEcbdTv67t0PXiGmFOtJELkriIRxqm2afUs9/vdwl4MtvXnQcS7
         m+BOEw7XlWPssOGk+QtEsiJQMgCVvOqNNSl5SI7q75KvqdFeEJdCMWAn7vBeykNL+0fT
         2YqoJgO9kqLLOfSJ1XqbZv917lif64w8V/M6SauU8RDhKVSXcfxWmdSmwM9t2GNprxLl
         8dk9qDHb5yJsYeg24hKQDY4crOpGlMhM83ouktVJQARneYLfm/kD354DjtM93QKAlbLR
         YYng==
X-Gm-Message-State: AOJu0YxfEacCl8XbTBzzDm5WpqqzOQ3Kkbl3gcwiEuk6S7o35IGcR7f2
	O88iBObNcxxvVz+7b+yiaGiifLyKEmcb2yBNBAdKNtQ4nM1vyki109KkW2Ko
X-Google-Smtp-Source: AGHT+IGqLG6cChuadUwSJR6nMD/h/GchDo5AotWk4zMR+oxtwoOnJrNXEf93syvi6klE5/FW8cHLAA==
X-Received: by 2002:a17:90b:1e44:b0:2c9:9fcd:aa51 with SMTP id 98e67ed59e1d1-2cd273d7d38mr2374397a91.5.1721545575837;
        Sun, 21 Jul 2024 00:06:15 -0700 (PDT)
Received: from JRT-PC.. ([180.255.73.78])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2cb77492bc6sm4891461a91.1.2024.07.21.00.06.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Jul 2024 00:06:15 -0700 (PDT)
From: James Raphael Tiovalen <jamestiotio@gmail.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: andrew.jones@linux.dev,
	atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	James Raphael Tiovalen <jamestiotio@gmail.com>
Subject: [kvm-unit-tests PATCH v4 3/5] riscv: Add method to probe for SBI extensions
Date: Sun, 21 Jul 2024 15:05:58 +0800
Message-ID: <20240721070601.88639-4-jamestiotio@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240721070601.88639-1-jamestiotio@gmail.com>
References: <20240721070601.88639-1-jamestiotio@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a `sbi_probe` helper method that can be used by SBI extension tests
to check if a given extension is available.

Suggested-by: Andrew Jones <andrew.jones@linux.dev>
Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: James Raphael Tiovalen <jamestiotio@gmail.com>
---
 lib/riscv/asm/sbi.h |  1 +
 lib/riscv/sbi.c     | 13 +++++++++++++
 2 files changed, 14 insertions(+)

diff --git a/lib/riscv/asm/sbi.h b/lib/riscv/asm/sbi.h
index d82a384d..5e1a674a 100644
--- a/lib/riscv/asm/sbi.h
+++ b/lib/riscv/asm/sbi.h
@@ -49,6 +49,7 @@ struct sbiret sbi_ecall(int ext, int fid, unsigned long arg0,
 
 void sbi_shutdown(void);
 struct sbiret sbi_hart_start(unsigned long hartid, unsigned long entry, unsigned long sp);
+long sbi_probe(int ext);
 
 #endif /* !__ASSEMBLY__ */
 #endif /* _ASMRISCV_SBI_H_ */
diff --git a/lib/riscv/sbi.c b/lib/riscv/sbi.c
index f39134c4..3d4236e5 100644
--- a/lib/riscv/sbi.c
+++ b/lib/riscv/sbi.c
@@ -38,3 +38,16 @@ struct sbiret sbi_hart_start(unsigned long hartid, unsigned long entry, unsigned
 {
 	return sbi_ecall(SBI_EXT_HSM, SBI_EXT_HSM_HART_START, hartid, entry, sp, 0, 0, 0);
 }
+
+long sbi_probe(int ext)
+{
+	struct sbiret ret;
+
+	ret = sbi_ecall(SBI_EXT_BASE, SBI_EXT_BASE_GET_SPEC_VERSION, 0, 0, 0, 0, 0, 0);
+	assert(!ret.error && ret.value >= 2);
+
+	ret = sbi_ecall(SBI_EXT_BASE, SBI_EXT_BASE_PROBE_EXT, ext, 0, 0, 0, 0, 0);
+	assert(!ret.error);
+
+	return ret.value;
+}
-- 
2.43.0


