Return-Path: <kvm+bounces-16166-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 377D18B5D2C
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 17:17:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E29A21F20FBA
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 15:17:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9929D130E4A;
	Mon, 29 Apr 2024 15:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="IphIGX5T"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 617C2130AF2
	for <kvm@vger.kernel.org>; Mon, 29 Apr 2024 15:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714403208; cv=none; b=TSCH8QwOBZr6X9ywxNO1klaLEWsi3nHkyA6QsPxx1LbrAahY1VH5mIvL+icPGD/yxbBlX9IEU8lBYunoXob2FqfUH+S2bH7yDNJHViY+uVw5j3h4z10GNexyFJywg4WL6tFT3HeNva23nBMY8ZSmBP9/wseuBGJxuKmyCHj9GN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714403208; c=relaxed/simple;
	bh=VBYIkTZIleyOsUo3Vs7GTW09WzwtONhQK0/AstEMTYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Wgrtjb5kyJT3WprEJoCFVFUJc7ebx+wUqJ8CWEPUw4vi+K2HjTyblurbTUGwcC3rUdkH9nPuosujRvSSzWWdUKiye+mtOOVi7EiILiLzcs7PaXWYbE09xosEA28MleuVwjxSxpjxam0bzklfVVIgWBdjNcuF6AmUXstqTY8sN/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=IphIGX5T; arc=none smtp.client-ip=209.85.208.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-2db8021275eso11679751fa.3
        for <kvm@vger.kernel.org>; Mon, 29 Apr 2024 08:06:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1714403205; x=1715008005; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rdCfPjm06PN8DLWdVlWU7iGB8QhHqS8f5T3HQCXkkpY=;
        b=IphIGX5TTrUC/uFJ8BaxG7n8/RFvEhoIC1BHzQ5cRX4j563R/qMkGlkYwwjNsmKHdR
         MEL7whh8gGX7f4CAYyb3gFqCYoBemsR9mv4s+pbvSCixsCbnCzSkT6t+s782xWmGdyNt
         ggPSWugYJvgoMGISPiGycCiCAEeqk+/dtTVwSoV0OCF4l/jAY5znMGxfAwz/CNKGUky+
         0nC/VgZokiA26hgMhtnccWfHW7gCakVCErZqFKOE55adMQshJrJnHvBt+QLz/XkLjHRK
         GCWde5JnzlfPUiAvxqdhvKZItGRrZCckIrtebNLP5jshkMwhmOvJ6wJU/HnF3RPFVj4t
         f8Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714403205; x=1715008005;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rdCfPjm06PN8DLWdVlWU7iGB8QhHqS8f5T3HQCXkkpY=;
        b=lp1obOzggs/GEkB65xXX+cG7yY5vjCL1BxTCalp3rx5xZ2Jk0hj7PC/Yn8/Vg46R80
         kTVmOyUHCfz5ydOO1BuJlsWIJz79IM8NFOw/guXLyMPKcWYiU2GIJ/oA6q6tCvK8dBlK
         9gI4mEP/s/Q/Vbx6gLnqUnSuBNBXHpGdXEqLsqXC6FmvDZH/UUORjVty+ClfYjaEv2I7
         O5nH25Ly+G9fHae6fvw3/H0ItLttKlyJL+2gE3y2fvU/nnFpTFm4q866a/LHvzr5IYDE
         JqaIakz8i9F8CXOG+Zm1HhL7KXAf1wTUfT/VWuYtT14RqKkm5vy2gWll+UEIOJlMJw6S
         YYIw==
X-Forwarded-Encrypted: i=1; AJvYcCWgrMDT+hot/GyuQjuc1FyENvH0N4oD50IVBKEC7oxi/EZCDViL5ZDVCrb+1gDz01dt4zf5borB8lXfqo+EmfF3E1Vs
X-Gm-Message-State: AOJu0YxCAf7pHMuox0izK+UP0n6W+iiJmmmohewaRjOSgugn9yH/ytkd
	bSjLojXqGuY2v46CoXg/FFlY0/6/2m9wUh2NcCqZZxCUm4FcE3iYhLUh3u7dsRc=
X-Google-Smtp-Source: AGHT+IGj1uRjkxG+FV5WjycG0XJI9pmWuDAlxIOwFNFoM4jSpFSFb8mNeeM7/iNLVr5rfQAB/mcNDA==
X-Received: by 2002:a2e:9f46:0:b0:2df:b336:76e6 with SMTP id v6-20020a2e9f46000000b002dfb33676e6mr4355115ljk.5.1714403203714;
        Mon, 29 Apr 2024 08:06:43 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:999:a3a0:2fec:d20:2b60:e334])
        by smtp.gmail.com with ESMTPSA id l23-20020a05600c1d1700b00418f99170f2sm39646638wms.32.2024.04.29.08.06.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Apr 2024 08:06:42 -0700 (PDT)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: Jonathan Corbet <corbet@lwn.net>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Conor Dooley <conor@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Anup Patel <anup@brainfault.org>,
	Shuah Khan <shuah@kernel.org>
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Atish Patra <atishp@atishpatra.org>,
	linux-doc@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH v4 09/11] riscv: hwprobe: export Zcmop ISA extension
Date: Mon, 29 Apr 2024 17:05:02 +0200
Message-ID: <20240429150553.625165-10-cleger@rivosinc.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240429150553.625165-1-cleger@rivosinc.com>
References: <20240429150553.625165-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Export Zcmop ISA extension through hwprobe.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
---
 Documentation/arch/riscv/hwprobe.rst  | 4 ++++
 arch/riscv/include/uapi/asm/hwprobe.h | 1 +
 arch/riscv/kernel/sys_hwprobe.c       | 1 +
 3 files changed, 6 insertions(+)

diff --git a/Documentation/arch/riscv/hwprobe.rst b/Documentation/arch/riscv/hwprobe.rst
index bf96b4e8ba3b..e3187659a077 100644
--- a/Documentation/arch/riscv/hwprobe.rst
+++ b/Documentation/arch/riscv/hwprobe.rst
@@ -212,6 +212,10 @@ The following keys are defined:
        ("Zcf doesn't exist on RV64 as it contains no instructions") of
        riscv-code-size-reduction.
 
+  * :c:macro:`RISCV_HWPROBE_EXT_ZCMOP`: The Zcmop May-Be-Operations extension is
+       supported as defined in the RISC-V ISA manual starting from commit
+       c732a4f39a4 ("Zcmop is ratified/1.0").
+
 * :c:macro:`RISCV_HWPROBE_KEY_CPUPERF_0`: A bitmask that contains performance
   information about the selected set of processors.
 
diff --git a/arch/riscv/include/uapi/asm/hwprobe.h b/arch/riscv/include/uapi/asm/hwprobe.h
index dd4ad77faf49..d97ac5436447 100644
--- a/arch/riscv/include/uapi/asm/hwprobe.h
+++ b/arch/riscv/include/uapi/asm/hwprobe.h
@@ -64,6 +64,7 @@ struct riscv_hwprobe {
 #define		RISCV_HWPROBE_EXT_ZCB		(1ULL << 38)
 #define		RISCV_HWPROBE_EXT_ZCD		(1ULL << 39)
 #define		RISCV_HWPROBE_EXT_ZCF		(1ULL << 40)
+#define		RISCV_HWPROBE_EXT_ZCMOP		(1ULL << 41)
 #define RISCV_HWPROBE_KEY_CPUPERF_0	5
 #define		RISCV_HWPROBE_MISALIGNED_UNKNOWN	(0 << 0)
 #define		RISCV_HWPROBE_MISALIGNED_EMULATED	(1 << 0)
diff --git a/arch/riscv/kernel/sys_hwprobe.c b/arch/riscv/kernel/sys_hwprobe.c
index 2ffa0fe5101e..9457231bd1c0 100644
--- a/arch/riscv/kernel/sys_hwprobe.c
+++ b/arch/riscv/kernel/sys_hwprobe.c
@@ -114,6 +114,7 @@ static void hwprobe_isa_ext0(struct riscv_hwprobe *pair,
 		EXT_KEY(ZIMOP);
 		EXT_KEY(ZCA);
 		EXT_KEY(ZCB);
+		EXT_KEY(ZCMOP);
 
 		if (has_vector()) {
 			EXT_KEY(ZVBB);
-- 
2.43.0


