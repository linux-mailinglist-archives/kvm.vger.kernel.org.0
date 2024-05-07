Return-Path: <kvm+bounces-16918-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FCBF8BEBF4
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 20:52:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 815421C24108
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 18:52:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B96816D4EE;
	Tue,  7 May 2024 18:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=flygoat.com header.i=@flygoat.com header.b="dijWbgwG";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="AY96E30J"
X-Original-To: kvm@vger.kernel.org
Received: from wfhigh2-smtp.messagingengine.com (wfhigh2-smtp.messagingengine.com [64.147.123.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0BED16DEDB;
	Tue,  7 May 2024 18:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=64.147.123.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715107896; cv=none; b=Yrd01p8dBfCRYZHUzvOuTSSkdSe6Vs4Vby/LaDZkzVDf2B2sdf4p5mDB1NJhAcKI2LuFMiEyEcm8FskZouWZD94JuTBn3MKuCgBQygVhqP2JiOELT/B20bCoZ4DodPlj888JFowmMvAJTbmAv1cRlGgadg41qB3NaTO/nMmOFNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715107896; c=relaxed/simple;
	bh=KdcCNVcmeZ72AJl9E3GrBg4pv9vxdHO3/iu3xmIRyOc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=eU4UOiTdU0wyLSwghVcasdIb1ne7Y9VYoim1aVRUjfKNsdIERCBm5o+swdd5prMwCVPSbOm9AkSsKkf4npv/yfIr5OdIkOwQzJSX5vroBw/Bddj0xixt3Nkk2PgfWtcDFh0VOF9FUcLaSHsnh31HTmur/J2J/D9L2pFw6XGzJNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=flygoat.com; spf=pass smtp.mailfrom=flygoat.com; dkim=pass (2048-bit key) header.d=flygoat.com header.i=@flygoat.com header.b=dijWbgwG; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=AY96E30J; arc=none smtp.client-ip=64.147.123.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=flygoat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flygoat.com
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
	by mailfhigh.west.internal (Postfix) with ESMTP id 5AA5418000AA;
	Tue,  7 May 2024 14:51:33 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Tue, 07 May 2024 14:51:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1715107893;
	 x=1715194293; bh=w1VjM0ud1RjbTEuBE6lkuqZ74DTWQfcdUXkhG/SaK+0=; b=
	dijWbgwGE7NeIrmEpBPbt1GTzwosbFdsrtq1Mh7ENQh+IHwUt8ksPt7QQV7ISS8S
	NFKENEYGFBquvEMHNYKLiPe8106pCd5RYjxnmJ2x/3mPwm9GHQfr63oBLoARTQ2/
	Sf0vDQViwOVxV9XGhasgZuUTwDdSYwZkAQB83Cxl7TaJ7Yedj/AqxHj/ReD77K1R
	9Ycr+j+AD+oBLmXRC5ixB2uKX2fpbm7eGeU0u5Q0hXl1Ql3Rxx55Jl8NHXzIUNgp
	iKL7lkxCKPb60ORrlVx4wkYf85l/HU9yQ3cshYhCIUlWRUtKiqcgJ0toDF6cu45D
	Z9vMjUp8XnACLxeetNsBDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1715107893; x=
	1715194293; bh=w1VjM0ud1RjbTEuBE6lkuqZ74DTWQfcdUXkhG/SaK+0=; b=A
	Y96E30JiW+lTyHmFtFYLekHWjegk9qgrNIk4FYrFXXGDC9C8WmcBUfZWvgwrzOlp
	V/NgzfOW2g98oH/L2WQsBVwmKOR5DLKZK8u030Q9JawsrP7pQjfjUZY/l6ep5ypM
	yyKi1uu4BuEE5ZbWDV4whIZ40UsjkVntfeiHgyEePkSzTUUddYDAV9mYGAYyXph2
	Y1qHIRZVJMDjAxFY9U0CzgSOLvhbv2OLHNZkcYPnePvJfZsxAYl32eIptAiABCmQ
	OisIgJPBpju9tAGArScjQYA1DD0zp1eEJYi+AwJjsVl62HkNAjSrnim+p+1qjvVa
	WkIov9KCebjUTLJr/R0fg==
X-ME-Sender: <xms:NHg6ZrHq_2VLpTPU9Hsq9YcGPcLWQ_XtSF5LNCzgudu4J3MLCzlAbw>
    <xme:NHg6ZoUP9Huk20uR6Ibtk3xnW3UCSGpXA7-5SMXQ-w3BAcF2ENLZBX4czotivQ2MA
    TjBkI_lfFVnR8G7Rb4>
X-ME-Received: <xmr:NHg6ZtJx2KhmotdSokhwwdlPoxOQfGggl2WLMaYN3FKI4GCPd75QVsY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvledrvddvkedguddvkecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefhfffugggtgffkfhgjvfevofesthekredtredtjeenucfhrhhomheplfhi
    rgiguhhnucgjrghnghcuoehjihgrgihunhdrhigrnhhgsehflhihghhorghtrdgtohhmqe
    enucggtffrrghtthgvrhhnpeevveetheeggfegjeekjedttdetueeludehveejgfejtedv
    hfdugeetgfelhfevkeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehjihgrgihunhdrhigrnhhgsehflhihghhorghtrdgtohhm
X-ME-Proxy: <xmx:NHg6ZpGO5qjE5Trs0bx10lhhqsQx0z23Bf8EHiRGK8TkAx3eoK-bbg>
    <xmx:NHg6ZhW-MHYGBn-1Q0KM7V-n4LZTIcX7VvyTB-7tMP9yXdoP0S3iGg>
    <xmx:NHg6ZkNpyg_UghVmsthstX7Og67YzOp_mw0gNaM8OZB9m8qqVMYfkA>
    <xmx:NHg6Zg2VIirL2lJVdfoLq6GGYmX1j8ZDBNC1Srs0VdNMg2YR7Tx8zQ>
    <xmx:NHg6ZqvygQgcmbERbTgFFX4__OjdYwONdZlqVH4ClUjIVCHMrM2YteR9>
Feedback-ID: ifd894703:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 7 May 2024 14:51:31 -0400 (EDT)
From: Jiaxun Yang <jiaxun.yang@flygoat.com>
Date: Tue, 07 May 2024 19:51:20 +0100
Subject: [PATCH 2/4] MIPS: Loongson64: Include bootinfo.h in dma.c
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20240507-loongson64-warnings-v1-2-2cad88344e9e@flygoat.com>
References: <20240507-loongson64-warnings-v1-0-2cad88344e9e@flygoat.com>
In-Reply-To: <20240507-loongson64-warnings-v1-0-2cad88344e9e@flygoat.com>
To: Huacai Chen <chenhuacai@kernel.org>, 
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, 
 Paolo Bonzini <pbonzini@redhat.com>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>
Cc: Jiaxun Yang <jiaxun.yang@flygoat.com>, linux-mips@vger.kernel.org, 
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 devicetree@vger.kernel.org
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=850;
 i=jiaxun.yang@flygoat.com; h=from:subject:message-id;
 bh=KdcCNVcmeZ72AJl9E3GrBg4pv9vxdHO3/iu3xmIRyOc=;
 b=owGbwMvMwCHmXMhTe71c8zDjabUkhjSrCt19Cg9ZDwfv6RXZ2hdrOvlqyK9zqWqOW7fx33s3f
 VWW653YjlIWBjEOBlkxRZYQAaW+DY0XF1x/kPUHZg4rE8gQBi5OAZjISV2GfyZ3zOwcXlyO6dgl
 xGZ8VnrFhVXp3zZ9OPI32HVDj86//KUM/9NT1ncu2fzXNatevlzkuE7Co6WrGEMUDy8T8g89E2s
 qwgoA
X-Developer-Key: i=jiaxun.yang@flygoat.com; a=openpgp;
 fpr=980379BEFEBFBF477EA04EF9C111949073FC0F67

dma.c defined function plat_swiotlb_setup, which is declared in
bootinfo.h.

Fixes warning:
arch/mips/loongson64/dma.c:25:13: warning: no previous prototype for ‘plat_swiotlb_setup’ [-Wmissing-prototypes]
   25 | void __init plat_swiotlb_setup(void)
      |             ^~~~~~~~~~~~~~~~~~

Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
---
 arch/mips/loongson64/dma.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/mips/loongson64/dma.c b/arch/mips/loongson64/dma.c
index 8220a1bc0db6..52801442ea86 100644
--- a/arch/mips/loongson64/dma.c
+++ b/arch/mips/loongson64/dma.c
@@ -2,6 +2,7 @@
 #include <linux/dma-direct.h>
 #include <linux/init.h>
 #include <linux/swiotlb.h>
+#include <asm/bootinfo.h>
 #include <boot_param.h>
 
 dma_addr_t phys_to_dma(struct device *dev, phys_addr_t paddr)

-- 
2.34.1


