Return-Path: <kvm+bounces-31858-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F91F9C8F89
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 17:19:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1C0A41F22C7C
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 16:19:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32B7318A6AD;
	Thu, 14 Nov 2024 16:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="ogM8fqbT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D8BF1779AE
	for <kvm@vger.kernel.org>; Thu, 14 Nov 2024 16:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731601133; cv=none; b=mZEhnhHA8ZPmqCv8TV3B90eBUFKCQDHqKa6vw4r7ZAcjW0wF4VPfkj8KP2KaMOFQrxGtdKIPUfoFAVUOpKoAbKCVzGJbpnDBToo1zajQ6hT/UoMZp7OTD3KQuehpUHNCFrtmlw55dbUjlrLo6Vm43iniy6NFdvbF/mwlWTjvl/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731601133; c=relaxed/simple;
	bh=Fk34GaC/hTLP6m0UNDLPdCaDiAz8BRxxGQykrmrUHjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AMZ78XKMUIr1Ijxsa+sSHj8a+H7OezIN3Q4PLJ3R6eH729uadV4YsoWgfqsQ+BTS3KaTwCCZZcF2bZ+QzCa1GTE5PiMt2qjrHbTCPxXjdXCd+cX6LQU8IRoZ+LqHRREV3LKk5VNdQNYGxG1liYstp6IWXUEQjD/u50MeSTO0xWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=ogM8fqbT; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-382171e1a83so624280f8f.0
        for <kvm@vger.kernel.org>; Thu, 14 Nov 2024 08:18:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1731601130; x=1732205930; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4sV1q1LQk/q83S2J2BpeMk7gg4mJdAxo4Zufy5rZGAM=;
        b=ogM8fqbTMAIib6JisGUriwtAYFoUI7SYWbE3JembUiuwTAlOYGTbKCv9+bMne15a6b
         Cq1oobXNizib4H6EWAW/T0xdJ5C1OZwcPiz2KbCsg2ffSTuiuGxmQlNit04Xh4xs1LAc
         +mY0odhwcUY10Kn1g5xVufbYeh1v/xJtqOYZmRPzDBpbt6rSAcSUs/LeCb6bYMPs7RBf
         U6IOX6fkuMtZP7aXowbQgcecnKgzCmTaBUvf774WEbvp1tclst5/adllD2dy0X+lkaRS
         EMTxIapOfYuLWJI2769LDEiO+X5O5yGd5XuKVFrV0Mfv18BGSas63C7khn+BcjIazU8P
         NdSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731601130; x=1732205930;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4sV1q1LQk/q83S2J2BpeMk7gg4mJdAxo4Zufy5rZGAM=;
        b=jkp6GsHmkMouMYftx41qnLy1UTih1stWCzUUgk7E8j/naNOKUYBdUNObXnMvxmIo7O
         510G4YzYTAoEXEC7UB1O3f/tAqcaugy3cVhKGJd9C+UIMTmWsQsST+sAmqSdpPWbrnsH
         /WZemTS46AIP/LrA2rbJzJ+y/emX/mvPuTEpcjptl/cmnNpBr42Z+88sU6vGAVF3Rq9s
         lt/s/KjmlsWe1a+fOiz7tYi7vDUJMwSUyGUICwR4IwTelFP8PdqY5E6Bw3xQtFOrCcFd
         Gwy5fkvA+aB9S5auHR0BpH7XZfm9zuP/zsYNPoJuZu7POjsLFJARG3sJRrLuWHRA1Vzc
         gG5Q==
X-Forwarded-Encrypted: i=1; AJvYcCXazpce9ACQTj6AcWjKVuIGRy9nTQQgmoefa15t3RwpJ2Twk0IzF+W+K/5Qf0yNze95NvE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5JF4/sAjkh8m5ozrkyDac6qBpUwRsZiNhaNaZhNZJXvVLmtlt
	RmTaAr3+MOjeyv2uRthT97nnJCW3Kb3G6sSDB9IMWyl62in24rOFAJ4FHZo8OG0=
X-Google-Smtp-Source: AGHT+IG+PIdlvaNPVTcrNev34iOeURvR6kwzzOllPVjWxdCbuE/GqDAX+WoRpo6pTqFd8njujj53Ow==
X-Received: by 2002:a05:6000:2a10:b0:382:2084:19b3 with SMTP id ffacd0b85a97d-38220844ac9mr1324585f8f.22.1731601129621;
        Thu, 14 Nov 2024 08:18:49 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432da265c45sm28633555e9.11.2024.11.14.08.18.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2024 08:18:49 -0800 (PST)
From: Andrew Jones <ajones@ventanamicro.com>
To: iommu@lists.linux.dev,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: tjeznach@rivosinc.com,
	zong.li@sifive.com,
	joro@8bytes.org,
	will@kernel.org,
	robin.murphy@arm.com,
	anup@brainfault.org,
	atishp@atishpatra.org,
	tglx@linutronix.de,
	alex.williamson@redhat.com,
	paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu
Subject: [RFC PATCH 02/15] genirq/msi: Provide DOMAIN_BUS_MSI_REMAP
Date: Thu, 14 Nov 2024 17:18:47 +0100
Message-ID: <20241114161845.502027-19-ajones@ventanamicro.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241114161845.502027-17-ajones@ventanamicro.com>
References: <20241114161845.502027-17-ajones@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Provide a domain bus token for the upcoming support for the RISC-V
IOMMU interrupt remapping domain, which needs to be distinguished
from NEXUS domains. The new token name is generic, as the only
information that needs to be conveyed is that the IRQ domain will
remap MSIs, i.e. there's nothing RISC-V specific to convey.

Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
---
 include/linux/irqdomain_defs.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/irqdomain_defs.h b/include/linux/irqdomain_defs.h
index 36653e2ee1c9..676eca8147ae 100644
--- a/include/linux/irqdomain_defs.h
+++ b/include/linux/irqdomain_defs.h
@@ -27,6 +27,7 @@ enum irq_domain_bus_token {
 	DOMAIN_BUS_AMDVI,
 	DOMAIN_BUS_DEVICE_MSI,
 	DOMAIN_BUS_WIRED_TO_MSI,
+	DOMAIN_BUS_MSI_REMAP,
 };
 
 #endif /* _LINUX_IRQDOMAIN_DEFS_H */
-- 
2.47.0


