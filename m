Return-Path: <kvm+bounces-16916-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id F41BE8BEBEC
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 20:51:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6A146B22EB4
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 18:51:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A70BC16D9B4;
	Tue,  7 May 2024 18:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=flygoat.com header.i=@flygoat.com header.b="uNN1kSma";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="i2kZ990K"
X-Original-To: kvm@vger.kernel.org
Received: from wfout8-smtp.messagingengine.com (wfout8-smtp.messagingengine.com [64.147.123.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D12F54C8A;
	Tue,  7 May 2024 18:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=64.147.123.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715107890; cv=none; b=Ilz5t5H+7yzrnagiqHFmMZq0/HAIu3MTPNuu6CB3Fx6WafvR2hSqDtbFNKds62flnLxorHx3HVREsdc279IVWRJhONFQ8T1XBU2tknBFHI1tfeKlARP5D73EIK9kO8khMcH4c+vv7G0yuHmETwo4PvTbAq2dMRVHqZQX6q2Oi68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715107890; c=relaxed/simple;
	bh=8CbRw+0pirm48NYUcf2cv3mIQF1sVjvBhz0096eLJAk=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=CSK1WmAHU9CXr9XPqmPjvJW7/Q7g270c0k3xJhzTZm5M9Xg/G7pubDEUL1Yo9HGM7QXU8jyMp5o68P+/1dMmF4v9F7l2HuOfs6sU8gvGRxP/VWPZOrXRWwXroo1ETLu3g8g7cnkxzcrWPoQ305fjA8xYjRaB6NXXq2YLKXiiXSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=flygoat.com; spf=pass smtp.mailfrom=flygoat.com; dkim=pass (2048-bit key) header.d=flygoat.com header.i=@flygoat.com header.b=uNN1kSma; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=i2kZ990K; arc=none smtp.client-ip=64.147.123.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=flygoat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flygoat.com
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
	by mailfout.west.internal (Postfix) with ESMTP id 3782A1C00091;
	Tue,  7 May 2024 14:51:27 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 07 May 2024 14:51:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:message-id:mime-version:reply-to
	:subject:subject:to:to; s=fm1; t=1715107886; x=1715194286; bh=0S
	zFP3E4cwWXZmWMu/IYHJ1K2inzAgP+RUX3bH5/YEE=; b=uNN1kSmauOpQ7JC1SS
	o4uWdbpMQxl6gnBg6xB8EbeWgIAzjDuFnC0JZ7MCMN6G7TXs5SdZsO7w1oScsP9L
	CXVLox2k6OktYz2tFnB9d8Hkbkz7LBMWTf2IFTjR2xwfrcTTlW2LgCqvdA1NfVD2
	DM6NEajnLh7p/n21bAwYBYCXIPE4sYuBXQaBqMnb4fbbu0AoqM5ur5OJXpcedxlT
	ZNH31y+jOluCoijuEWOa/hyTVFGBepCWFLD0lNpXAPpbG8Nvbk0PZ0yfQfWOAIvn
	nvSua81pBX8Di9gLhBLQ9MrUDBHfKKBaddfCheomIHPcfuRNExHvMq3UT34ZjkpP
	lT+w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm3; t=1715107886; x=1715194286; bh=0SzFP3E4cwWXZ
	mWMu/IYHJ1K2inzAgP+RUX3bH5/YEE=; b=i2kZ990KSuNafOH44x3MeFwVHtl1L
	SMDOHNBTtMBJ5jh5FR9io07AATn8GzYQzm1FrjjoOcBecgwPfBIv/10OlJ9zoND1
	LxP7fNOQRhqdwR8DmyUaSrjFMUzgKFX5HlfE+YDrWsp+uJD42oTU85jev/kzb5KS
	Zj/jcfxqXPbhyH55ZcAqEWx0hIF861tDlMUiEOd7+Yx+9c2CrtzbBgQgdKzw266P
	Z+FczkgmZ5dAKl5XxVoAQCa10sEwtAaF4nC8on+I6A46gMXlcPhBZfGrcPTnfQkT
	qlq9RwYwoB1tCpwVjv6kQx6Oj/HQueW4NY6HOT4uuBYT+PkDD0TeQPOwQ==
X-ME-Sender: <xms:Lng6Zo8qS6oUhPHnnT9qu9aykS6MXezTwcr1KCIVOuLSHzXX4IMHxA>
    <xme:Lng6Zgu1B5AswNPBUdrGyXbDSFgpZq84YWaQ12fs2uawYFVOQxwq0lulaQjRfTDmR
    Qq0D9jThLuXNLxwxlw>
X-ME-Received: <xmr:Lng6ZuBPdKeJ6yQyzladYs92M0l1sUSeOPKRZFHsjWar9a-FqYjBDJk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvledrvddvkedguddvkecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefhufffkfggtgfgvfevofesthejredtredtjeenucfhrhhomheplfhirgig
    uhhnucgjrghnghcuoehjihgrgihunhdrhigrnhhgsehflhihghhorghtrdgtohhmqeenuc
    ggtffrrghtthgvrhhnpefgveffjeetgeejfeelgfekteelkefhuefggedvueeujeekjeet
    keekvdffffefudenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrh
    fuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepjhhirgiguhhnrdihrghnghes
    fhhlhihgohgrthdrtghomh
X-ME-Proxy: <xmx:Lng6ZoeurPMwTcP0TefZEJ8a2YMchxQQsJvLhcc4Ckfs1A0sr72eQw>
    <xmx:Lng6ZtNdCxjlZdcwN53kZcQkmcrgPq5jEB9I1md4YreuI0tRi8THSA>
    <xmx:Lng6ZikhjWzSWGpYYhPfhfbx0zrQwhe7Upt7fUY2lDsRCqRImLuV9Q>
    <xmx:Lng6ZvuFS5Yh0BwHWOM4PxnvuCpPrFLfUB9P3wuY6VLFauPNQM-JiA>
    <xmx:Lng6Zhn7oDzFjjPhV9oysc5TdpqgE2PIxpDytwjIyH-5ytj7Bm9SNwPB>
Feedback-ID: ifd894703:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 7 May 2024 14:51:25 -0400 (EDT)
From: Jiaxun Yang <jiaxun.yang@flygoat.com>
Subject: [PATCH 0/4] MIPS: Loongson64: Sweeping build warnings
Date: Tue, 07 May 2024 19:51:18 +0100
Message-Id: <20240507-loongson64-warnings-v1-0-2cad88344e9e@flygoat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIACd4OmYC/33NQQ6CMBAF0KuQWVszxRaIK+9hWNTawiTYIS1BC
 endrRzA5fvJ/3+H5CK5BNdqh+hWSsShQJ4qsKMJgxP0LIYaa4UaWzExhyFxaJR4mxioQHTaWql
 1I81FQ2nO0Xn6HKv3vniktHDcjpNV/tL/e6sUKFqsO680GmwfNz9tA5vlbPkFfc75C0F+3R24A
 AAA
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1715;
 i=jiaxun.yang@flygoat.com; h=from:subject:message-id;
 bh=8CbRw+0pirm48NYUcf2cv3mIQF1sVjvBhz0096eLJAk=;
 b=owGbwMvMwCHmXMhTe71c8zDjabUkhjSrCt2crnY3P5f/C2t7G033P7WWWW0rvPhc5aTiiSkrb
 WwP56V2lLIwiHEwyIopsoQIKPVtaLy44PqDrD8wc1iZQIYwcHEKwES+H2VkmBy+JiQlMPP+//WX
 VRf//lru++yUhey9eUUfLG3f+wQ982NkeFy/xeKjZ5lPq31LgNqdXSf+8NZvX7zSsu6JSsPDIOe
 vfAA=
X-Developer-Key: i=jiaxun.yang@flygoat.com; a=openpgp;
 fpr=980379BEFEBFBF477EA04EF9C111949073FC0F67

Hi all,

This series sweeped various build warnings for loongson3_defconfig.
This is based on next-20240507.

There are still some warnings remain in pm.c, those errors are
covered by [1].

Thanks

[1]: https://lore.kernel.org/linux-mips/20240507-loongson64-suspend-v1-0-534d92a4e09a@flygoat.com/

Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
---
To: Huacai Chen <chenhuacai@kernel.org>
To: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To: Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
To: Paolo Bonzini <pbonzini@redhat.com>
To: Jiaxun Yang <jiaxun.yang@flygoat.com>
To: Rob Herring <robh@kernel.org>
To: Krzysztof Kozlowski <krzk+dt@kernel.org>
To: Conor Dooley <conor+dt@kernel.org>
Cc: linux-mips@vger.kernel.org
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: devicetree@vger.kernel.org

---
Jiaxun Yang (4):
      MIPS: kvm: Declare prototype for kvm_init_loongson_ipi
      MIPS: Loongson64: Include bootinfo.h in dma.c
      MIPS: Loongson64: DTS: Fix msi node for ls7a
      MIPS: Loongson64: DTS: Fix PCIe port nodes for ls7a

 arch/mips/boot/dts/loongson/loongson64-2k1000.dtsi | 37 ++++++++++++++++++----
 .../boot/dts/loongson/loongson64g_4core_ls7a.dts   |  1 +
 arch/mips/kvm/interrupt.h                          |  4 +++
 arch/mips/kvm/loongson_ipi.c                       |  2 ++
 arch/mips/kvm/mips.c                               |  2 --
 arch/mips/loongson64/dma.c                         |  1 +
 6 files changed, 38 insertions(+), 9 deletions(-)
---
base-commit: 93a39e4766083050ca0ecd6a3548093a3b9eb60c
change-id: 20240507-loongson64-warnings-85cc15561a35

Best regards,
-- 
Jiaxun Yang <jiaxun.yang@flygoat.com>


