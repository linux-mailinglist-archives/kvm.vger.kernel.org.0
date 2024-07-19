Return-Path: <kvm+bounces-21911-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BB29993728C
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 04:40:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ED18E1C209EE
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 02:40:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68C45848E;
	Fri, 19 Jul 2024 02:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jvb6irOB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B7A617C61
	for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 02:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721356805; cv=none; b=qb7y3Wke0IAJTOMrbtThfM9Zymjs3Fphbnm2RTgWB4uf6F43B0o9CJyT+Xz3rNX/6Rq754dp0KuNHNIeDm7/LT5+zuLFGnQ/Khqe43QV/+s4Oh3+dxHPFqZdFl1SWkyG8JumS8sxMVGHbXAyxW1QE3cwrxkfVd9BnnHwjowJ61c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721356805; c=relaxed/simple;
	bh=2ojPZa4h2oYAX55qtj8WvJCbwq5yeV93EXeRORL+gpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oy1ZRNxZgxlfFqosYdGBaysz6MOgZnAogV/xJb/Y9KCFJqRrQKoys6D710TAFrrNsuGKT3VJbhK4JI5ZSjTkGg57ykL7lmItz3O88lt4F1BUD0wlEc78wrCIjce0gujXXc7Jo6Gfdl/m7lqd1ZuogpatMXjj4k9urmnj1cXVoT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jvb6irOB; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-70b0e7f6f8bso391214b3a.3
        for <kvm@vger.kernel.org>; Thu, 18 Jul 2024 19:40:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721356803; x=1721961603; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OLU7dzQvfkJ9Ef0blGKudWZ8SLP+KA1hEm/nsUl2wGw=;
        b=jvb6irOBvMZUFVnHi+RmkMdlxg/oN+0jIOR7O3xzilU/inX83eMmUsGlmYWGVjuqwD
         vhMsNilbwF8Q7SXt+LV9ksVmO4QhtOTZr5MbAShgCMLRt9QwAX2HRxszOlsqvUImKxMc
         SjC3cAm+6FX3nBiFs5QUU6Gsd8gXYs/FhHaupiHPbuAkhCsyKa/HayeObvMEnDMMAUgS
         r9+zwmfQ3Bu8WC6LAXBiAgNN2KcfrbdltqajPTXQsfBPJfTeyNoHb4YCp4XT/oVrUi2o
         PeU+mi5pbbd7Y5m3+sip4XIndWGeMzCrJYGID1YNGSTS9gquKG4CwRlZzSISsU+W3684
         iPAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721356803; x=1721961603;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OLU7dzQvfkJ9Ef0blGKudWZ8SLP+KA1hEm/nsUl2wGw=;
        b=TS4nFXLEIr0Ug15GhmpJVaJKl6/opf/TeY7t7r57yw39AjYDTP0+XRo3G+WxwXeGno
         BdXQ3pn8dVlb1bey91fLcBFNhv3Tq7wI80/P0z24hcsVyAKq/eF0kpIGz9bCHBaODzst
         8G9M+ZhEwBpnnEA8xtp8THw7dk/YIZUr+E3RRt56EVrpcwOxcwEQA30IhfMsZ5tRRAiz
         8Kdp5EvM7dFPlsdSACnNURcvdipqAJrpRxWew9g+GzrkyuaNvExxvnvV4SK0YQqh+a8m
         LsIgJ0cVlqm7e3Y9iEdwWRdbsgaWOie6gKPcLMdKpiSAfg5F/QvLZ5djp9rTBNWB7eXU
         G5xA==
X-Gm-Message-State: AOJu0YysLK5JdQvxiZZr5ncEGCL5YOtDyM4Fvse8YBz3uIwtQ6npdJox
	xHlvtVvVa/qHkkQMd+J329CuVT3z+MAcmzMMt+mA/+ooVd4Y5AmKvlgtUp90
X-Google-Smtp-Source: AGHT+IE7JpMmfmafXElRljUIBX5nNaC28/MohzaDsxFle4aKtRo45YlHaoMlFZzgUMTdcxt2s61H3A==
X-Received: by 2002:a05:6a00:4fc5:b0:706:6b0b:9573 with SMTP id d2e1a72fcca58-70ce4fb5f42mr8187623b3a.19.1721356803260;
        Thu, 18 Jul 2024 19:40:03 -0700 (PDT)
Received: from JRT-PC.. ([202.166.44.78])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70cff491231sm234930b3a.31.2024.07.18.19.40.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jul 2024 19:40:02 -0700 (PDT)
From: James Raphael Tiovalen <jamestiotio@gmail.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: andrew.jones@linux.dev,
	atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	James Raphael Tiovalen <jamestiotio@gmail.com>
Subject: [kvm-unit-tests PATCH v3 3/5] riscv: Add method to probe for SBI extensions
Date: Fri, 19 Jul 2024 10:39:45 +0800
Message-ID: <20240719023947.112609-4-jamestiotio@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240719023947.112609-1-jamestiotio@gmail.com>
References: <20240719023947.112609-1-jamestiotio@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a `sbi_probe` helper method that can be used by SBI extension tests
to check if a given extension is available.

Signed-off-by: James Raphael Tiovalen <jamestiotio@gmail.com>
---
 lib/riscv/asm/sbi.h |  1 +
 lib/riscv/sbi.c     | 10 ++++++++++
 2 files changed, 11 insertions(+)

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
index f39134c4..7d7d09c3 100644
--- a/lib/riscv/sbi.c
+++ b/lib/riscv/sbi.c
@@ -38,3 +38,13 @@ struct sbiret sbi_hart_start(unsigned long hartid, unsigned long entry, unsigned
 {
 	return sbi_ecall(SBI_EXT_HSM, SBI_EXT_HSM_HART_START, hartid, entry, sp, 0, 0, 0);
 }
+
+long sbi_probe(int ext)
+{
+	struct sbiret ret;
+
+	ret = sbi_ecall(SBI_EXT_BASE, SBI_EXT_BASE_PROBE_EXT, ext, 0, 0, 0, 0, 0);
+	assert(!ret.error);
+
+	return ret.value;
+}
-- 
2.43.0


