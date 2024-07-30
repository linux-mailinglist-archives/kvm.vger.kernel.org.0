Return-Path: <kvm+bounces-22586-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AC10494082F
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 08:19:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 67B8A28185A
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 06:19:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C98818FC60;
	Tue, 30 Jul 2024 06:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eGv/K86z"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4092818F2E7
	for <kvm@vger.kernel.org>; Tue, 30 Jul 2024 06:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722320316; cv=none; b=s+0Uo4uLG20rg5Az4ShakCixOI3JBGfuFfe5DeambCKfEfGv3A+Hd4ssUV/hzLNq7rj5ZIZmLCTljJlUzn1Mrh3IamnrBNp268v1V+FNYqfwX6S1aLIscSp6RjNQ4/gNlPirBgXWhV/bkyC+qe874IgY+lqNTj5zmbO3e3PwUX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722320316; c=relaxed/simple;
	bh=XRJl/uPgbWvSt8YMeQOUC5JnzlykeY0IhpbgHZkzhCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KZMWqxChd3adwjwrN3T9sqflKQwknIWSy/K29sNwmmbnvRFWIpcTHcXrNo5pzqlMwNLA2c2gh/U0c/X+YUwWsL54Yjsl8yf5UyN4c/v01PHvAd+EnTs8GC7+u7ricf6BfkoLZ3aLjZnmi3x9IzUEA2TzWZoLk9PJtdYuDqVU1yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eGv/K86z; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-70b703eda27so2484400b3a.3
        for <kvm@vger.kernel.org>; Mon, 29 Jul 2024 23:18:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722320314; x=1722925114; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BEiXZ1Hftnd13V7cSXtmzxOOQFtbwN2az/SPk33hWyc=;
        b=eGv/K86zMAGvjKGim+LWTPb9kxOHTDJuqjrjyn1R63qts4Bs0ghWmzvVzsgJrURRM9
         kNhdEInZ1xVhkO89IuVBfy+2zb4inG1UIBGHdsqoXD4qLl2uPfQ+u/wzSp3ofdiwpJjx
         7GTfruKjawDWvUBxLF/00WtYstXHJvr0aXu1ZlLS+juUicENMAMHZ9yzVgGksGDK25Ed
         o7WU3OdoN2zzgxByKw39autvgQ2wAlnRLl4OEy55TDqB0hWVEEpDIs1w1yq00zYoUGqt
         2Qdmi5yGxYofnnRmlOLMeYBMB1KydM/HOqhj8hVTgtrd+dcffopA0z3TUuOa4/08sX0z
         u1eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722320314; x=1722925114;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BEiXZ1Hftnd13V7cSXtmzxOOQFtbwN2az/SPk33hWyc=;
        b=IMOB6qoPLKnqW+1XQvyFYKhRWXeYZUR58KETLjhJsaiRswaog6Vd6nPOO/R8PX1MR5
         w2Vlqnm3tt93iLxXuLJNaoKb3b/7O4MBoBAHH7ZAkPnCuRGbovH58B7TGIlnySq+O0cz
         cqHlcwDII0vPEJck9Jdg5aHHQSLWWiUy6OVdTYxcPvDJA6OwbPX58Ffeq/X5rv26zR1a
         zTNkru+M73R7o/LFGg0FLnt0ws86HenXKVb6OHhZcsTj3zWx29QX9AKdaYV1+oESq9YH
         t1R33/IFffPtHyINft5RFqHJFy27xd9rsIr2JBLhxQYkPSlt2ZqQzoX3FckxHKyFFX3p
         r2Vw==
X-Gm-Message-State: AOJu0Yy0BK9+j90tW3krjb3wKYVmEHlJz1bVTSilmWRt+TSuZdsybj+y
	Zn8PXAvHBbiktfMSuLkLk5MC5CmiGs0ZRDU8C/30ltWUtTd7T/Wtpkn/pskp65Q=
X-Google-Smtp-Source: AGHT+IHEOGQoMzw6uwNYgIfG5QWUNtOH7qO1sK3jwBwHoTREqCpBgVGPtSWJwiAOfdutPlMvqnSdKw==
X-Received: by 2002:a05:6a20:9e4b:b0:1be:c2f7:275 with SMTP id adf61e73a8af0-1c4a153355fmr8735392637.50.1722320313931;
        Mon, 29 Jul 2024 23:18:33 -0700 (PDT)
Received: from JRT-PC.. ([202.166.44.78])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70ead6e161dsm7732781b3a.42.2024.07.29.23.18.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jul 2024 23:18:33 -0700 (PDT)
From: James Raphael Tiovalen <jamestiotio@gmail.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: andrew.jones@linux.dev,
	atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	James Raphael Tiovalen <jamestiotio@gmail.com>
Subject: [kvm-unit-tests PATCH v6 3/5] riscv: Add method to probe for SBI extensions
Date: Tue, 30 Jul 2024 14:18:18 +0800
Message-ID: <20240730061821.43811-4-jamestiotio@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240730061821.43811-1-jamestiotio@gmail.com>
References: <20240730061821.43811-1-jamestiotio@gmail.com>
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


