Return-Path: <kvm+bounces-40671-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 35CF2A59991
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 16:17:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EC1893A9244
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 15:16:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C3C9230BF7;
	Mon, 10 Mar 2025 15:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="StQ4A8O7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F1AB22D4FE
	for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 15:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741619662; cv=none; b=rMIcoTdtz/wlqEPRBBdVwC31bldGULZ+7a2w+bykNfSBMDpWU5vbhEi+hLE3crZbuiUj4L+X+gcVjyICAf/sIjHXaY0J/44+pU0hvbQYZMRhzlgCJtPxYufWLSTYLCZgtF4fGHXo+saoKwSqIWrkZCmurBEMsJZsvlr12TZRkNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741619662; c=relaxed/simple;
	bh=bnTO4F0S5ychW6vkQ40467dj4QMVwl+AJTO7Dfj0Lpk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YmIQe1RV9W1EGRYKijmckDVog2JgWreVt++X17+12M1qsMSf7eYWswXtFaouujsg2wB4q9PUgJHjERLMx2+OWubgCku2vxqCTOZ2l7+aDilYkHuzq+cTd/1PSAI5VCqC6aBq5VPhKmUmYrb/ofC9DW1H4u0YICXCJQym8cFxzUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=StQ4A8O7; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-224191d92e4so74437425ad.3
        for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 08:14:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1741619659; x=1742224459; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0Ne6qRsQBgMn6Z9TbFB4C5/y3IwlTc1J69dL1IhT4E0=;
        b=StQ4A8O7p0CPx+UAaJH0+xUioxoW+RgH2cW8at9e9HEloGqUVkyAM4Uc3YL2IkIntD
         QL6W7qIs5r9bw4HHkxomN/eFr8J5bckein20oGKhPB98HE/solr3P6lgkmrDjYNmCm4t
         QaR+CJfrfQ2KFOoXsaJ9jiuYol7ya0n+XdyFeBqV5tNmlIEjXIge4Wrz6vKC3zuKoHpz
         c4kbFW4POqOGewfVODs43qg/1pVqvYIReT6fAcHJUfvrS8rB7jF24xQaVA73G7JTcuMo
         lm11HfPvIOt0nuip7hRYlJGh4l7cSSwnvvJcd/c4UPEfNe/wbOkLXR74l+1C+3Hj/QUN
         0hSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741619659; x=1742224459;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0Ne6qRsQBgMn6Z9TbFB4C5/y3IwlTc1J69dL1IhT4E0=;
        b=Ajc7YxAH0Z5y/b5XesBpdwXKuv5lQU+CZko88kOfZIo9J4ghcvih5AOSDOwPvJvJRz
         xR63tsEDxKtvCZ07qECKckAbWFwWiPuOcrRmzFNWbgj32mNqHA24idX0m06c/amjMUJN
         3X1gKcHQa5vR/cgtWvUTk3XqEJCaKVc3rf/bKK6WCmxlewWyISlMaIf9DKwuNoeM2O8K
         sgAcIOokLWvItMLdlGdlCqxPAvr9tqpxytGzyzTJVPUCvnNq6yxyHBN8DjMkPNNjQN7p
         dnjUeDQwSzxMuzDR5Yj54OQxvlQnrJmAC1S9Rz3wLCHYjC7UfofXy/kRjUX5hGda1Eb2
         8X/Q==
X-Forwarded-Encrypted: i=1; AJvYcCVU3hMUOYoYSLsVd5fx21tDVPsSt7jG1+LCOUfx2gT70scUR0NHK5ZgPYv2qqfdbGDhGKw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz/D7gASCde1jT2bZ0AOiEchv8CTg21ZGkR/nD/PkMSWqtLqZjh
	OVHTeSJoyCCfH6ISC1ziE0fPQBKbvh05BTnav6vImceEKhVI1myWoDGrr92Q7ig=
X-Gm-Gg: ASbGncsEptdG6/CLlOGDQFjhBSxh9S4ZErp+G20QBuMZsVGRQzZ7iaUBbUX+tmi9jsT
	G5k9yBBoQ9+VkURNgaSF6fhgUQmU6ngt640EW2Dh5y4pZ3HW8Z2BJsC0++ZCae6VmxzeCuE9S+t
	ShD3IR65xKEsxqQRFkCuaDFLyHhm4Dho8EwVcoNG32QHoQyCdXj5pdvOPOxQUUo0q17Gw4nFMAs
	rSxsoDvDLQpbQeJHnTIAL6LPg64wfqKL9xWFP7xcIG4Bjv7VcEdtBV3vUqdADY4ik+7/lcvEZm9
	vp4SrTYsrunQad46t8bUAZ0UkMjPjoiHJ2OFINhtdhpavA==
X-Google-Smtp-Source: AGHT+IHou97UuMHPx2aRC5ipTZybHeRQW/gREfJF/XOKkR7oov9xPoqimKZKRudGRu1JoJNuk3RSLQ==
X-Received: by 2002:a17:903:2405:b0:220:fe51:1aab with SMTP id d9443c01a7336-22428c05613mr273654235ad.38.1741619659507;
        Mon, 10 Mar 2025 08:14:19 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-224109e99dfsm79230515ad.91.2025.03.10.08.14.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Mar 2025 08:14:18 -0700 (PDT)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	Shuah Khan <shuah@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-kselftest@vger.kernel.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Samuel Holland <samuel.holland@sifive.com>
Subject: [PATCH v3 11/17] riscv: misaligned: use get_user() instead of __get_user()
Date: Mon, 10 Mar 2025 16:12:18 +0100
Message-ID: <20250310151229.2365992-12-cleger@rivosinc.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250310151229.2365992-1-cleger@rivosinc.com>
References: <20250310151229.2365992-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Now that we can safely handle user memory accesses while in the
misaligned access handlers, use get_user() instead of __get_user() to
have user memory access checks.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
---
 arch/riscv/kernel/traps_misaligned.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/traps_misaligned.c b/arch/riscv/kernel/traps_misaligned.c
index a67a6e709a06..44b9348c80d4 100644
--- a/arch/riscv/kernel/traps_misaligned.c
+++ b/arch/riscv/kernel/traps_misaligned.c
@@ -269,7 +269,7 @@ static unsigned long get_f32_rs(unsigned long insn, u8 fp_reg_offset,
 	int __ret;					\
 							\
 	if (user_mode(regs)) {				\
-		__ret = __get_user(insn, (type __user *) insn_addr); \
+		__ret = get_user(insn, (type __user *) insn_addr); \
 	} else {					\
 		insn = *(type *)insn_addr;		\
 		__ret = 0;				\
-- 
2.47.2


