Return-Path: <kvm+bounces-23604-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DD8C994B8B7
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 10:14:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 19B141C243F4
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 08:14:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 344F8189502;
	Thu,  8 Aug 2024 08:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="l+HCar1t"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE4141891C3
	for <kvm@vger.kernel.org>; Thu,  8 Aug 2024 08:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723104886; cv=none; b=O/FIYURrT46fMqetVD7/MT7l/lko5ZmQs2Z8gQUNxj3wjAyCIAupYtSxOKCM27CRxus5EMzQQ4DRhwDU74BscLpkR/n30zDbiyBXUFdpC1r1K03PheBMKfEkg4DQTDM6f9kEMKJA7lx47vgMctUahZqocjXgVA5JCFLEAghbYXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723104886; c=relaxed/simple;
	bh=eYH/t+EqSzgoXAk6bItXHNsosxzNFpOP3Tl4KqWYQGM=;
	h=From:To:Cc:Subject:Date:Message-Id; b=pi8jX9zeKhpgHh6QydyvU8Zghr05eiqsVfcJlFldxEZX7c3QeX4LKt7r5Gk0h5GWqtz76zIIm3gCO8GB6Xhk8rktbJH9sbh/Z1YLiT2Oa4T+J28fPi9GfHkiRDlljNgzmREZKN8Gm25Ig2VXjhMNp47zaa9MUZx6YYebckzQX1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=l+HCar1t; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-6bce380eb96so457802a12.0
        for <kvm@vger.kernel.org>; Thu, 08 Aug 2024 01:14:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1723104884; x=1723709684; darn=vger.kernel.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Uz2Q34geGJiRJ8e8z0pDWtJTTDFKWyWloO9Btu2KCw8=;
        b=l+HCar1tYDnQ2TsXG4W+EppSebZY7831K8m7qvv/mX9k9LwDxyLWFadzeRinlBdR6f
         lSffAKyF2XKlG7ewoZUqVtdkYCWL2A9YNeanKiiCI8uhnbORYZ+zhYnyTeorHUWqPMB9
         QkvsOzU+cwxb4sXY8tk9yEJlEbAA4D8GczY714e/Qo1FwpUv0Sn+WMKPX7uhv/wiHIXz
         FSUyhY2LRHOIYJJi32ggs8/1qNkgLK4UalPoUEL4iPoW/Agib4/O5MH7cc1DxP4SUrLj
         YfR5vUsvqjq1fIcMV/Ttfs+yDQfp5WVRnlOaNGrSXTJx5hD4Wvbm+zxEOAok1ojoRuNF
         A5kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723104884; x=1723709684;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Uz2Q34geGJiRJ8e8z0pDWtJTTDFKWyWloO9Btu2KCw8=;
        b=wF5B5TZXw6qDkt35Io/JG1GKUKyBpzZusfNWbpXLP8/Uzl6fmBGr1Mbfl0bH+mKR1q
         6OlaxYXn38lfkusIf3NYr1eDSbQx6PoD3eVxx8VUBvXc5fgJby7Hy2X3b9zftGr9vMLN
         8AY5iOmu+TRf0vUZFEvHw2cqB7Z89/CQZN1J1JKkbxw/VMnIVu78YxWQV3fof3SyTiNq
         3rIwwC4iv0EnXw55fboCtpdVkbWCRuWx2b5BOaoFR+R2Dmar1kl/CM4FodKD6XkdSzgh
         LLEQ+4M3vvU72jklmb2xzlOkKFHgXZn/0coVEtIcl+CnaVb+t9tQ2eUrQagdmiWBNr+G
         qvVg==
X-Forwarded-Encrypted: i=1; AJvYcCWfpqItH/zZMcmoEcm7MpM/pTs+ji1ux7FY0I++wON5i1BndwHuWEWbmrkVeogxt53IykJLpFBDYY8yLYYO6l0t8GWx
X-Gm-Message-State: AOJu0YzmJhjuwiObjgPkT+D9VSzRdzHaOAPWxK4EcrNlGcYthO4wPQ16
	cyq1g3c6jxXDcQWIC2v5MS9+kXlOavT6ODcgzP6oQ/c9IRBM2lVW8Dk6/OUyOsQ=
X-Google-Smtp-Source: AGHT+IE8I00iIp/1AKllHFcYCJLmvvu0pdzTgwwUhvhBSbA/p5VCIfIk3GciGH9HF1hk5jCo+FswWg==
X-Received: by 2002:a05:6a20:5501:b0:1c2:912f:ca70 with SMTP id adf61e73a8af0-1c6fcf7b166mr898421637.42.1723104884149;
        Thu, 08 Aug 2024 01:14:44 -0700 (PDT)
Received: from hsinchu26.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1ff58f18616sm118451765ad.39.2024.08.08.01.14.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Aug 2024 01:14:43 -0700 (PDT)
From: Yong-Xuan Wang <yongxuan.wang@sifive.com>
To: linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org
Cc: greentime.hu@sifive.com,
	vincent.chen@sifive.com,
	Yong-Xuan Wang <yongxuan.wang@sifive.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>
Subject: [PATCH 1/1] RISC-V: KVM: Fix APLIC in_clrip and clripnum write emulation
Date: Thu,  8 Aug 2024 16:14:38 +0800
Message-Id: <20240808081439.24661-1-yongxuan.wang@sifive.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

In the section "4.7 Precise effects on interrupt-pending bits"
of the RISC-V AIA specification defines that:

If the source mode is Level1 or Level0 and the interrupt domain
is configured in MSI delivery mode (domaincfg.DM = 1):
The pending bit is cleared whenever the rectified input value is
low, when the interrupt is forwarded by MSI, or by a relevant
write to an in_clrip register or to clripnum.

Update the aplic_write_pending() to match the spec.

Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
Reviewed-by: Vincent Chen <vincent.chen@sifive.com>
---
 arch/riscv/kvm/aia_aplic.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/riscv/kvm/aia_aplic.c b/arch/riscv/kvm/aia_aplic.c
index da6ff1bade0d..97c6dbcabf47 100644
--- a/arch/riscv/kvm/aia_aplic.c
+++ b/arch/riscv/kvm/aia_aplic.c
@@ -142,8 +142,6 @@ static void aplic_write_pending(struct aplic *aplic, u32 irq, bool pending)
 
 	if (sm == APLIC_SOURCECFG_SM_LEVEL_HIGH ||
 	    sm == APLIC_SOURCECFG_SM_LEVEL_LOW) {
-		if (!pending)
-			goto skip_write_pending;
 		if ((irqd->state & APLIC_IRQ_STATE_INPUT) &&
 		    sm == APLIC_SOURCECFG_SM_LEVEL_LOW)
 			goto skip_write_pending;
-- 
2.17.1


