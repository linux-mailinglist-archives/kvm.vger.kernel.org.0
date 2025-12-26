Return-Path: <kvm+bounces-66709-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B38CCCDEC86
	for <lists+kvm@lfdr.de>; Fri, 26 Dec 2025 16:08:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EF97E300B80F
	for <lists+kvm@lfdr.de>; Fri, 26 Dec 2025 15:08:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 373AA24CEEA;
	Fri, 26 Dec 2025 15:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="luNscO0d"
X-Original-To: kvm@vger.kernel.org
Received: from smtpbg150.qq.com (smtpbg150.qq.com [18.132.163.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE523218580;
	Fri, 26 Dec 2025 15:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.132.163.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766761690; cv=none; b=djCsBC+Vvid/aJVy+HrNfIMeJIBJnulMp1RTJ+roLoY9vuXT+QKeMPADbXFPgn+60Y1NFHjX1muT3iD5aUSO6EGZby8Dj5vuuIXicHbCciRDTJ/6pvkE/VsFDkt/1+xLAx9wrYvugVlwFb0VCr7eJS329spKdgT/4BRCPLDmS+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766761690; c=relaxed/simple;
	bh=XRZOxfsh+3VNOaBYs4rVbbv43RBWgsiCafEkxAr8Sdk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=PSbBjrgLrld+WI6xTI4vj8Mjc+e94dkgpu0I/HvclwGTngaSwMZfu7A8rDNVkL1+EiVq3STcnEHF6fFeDdWlX+FtQ9PXUlXZqBy5I149uSF4jc3S55OJeSzdINjjurcxQSr6HwDh4qIBYFjSAsspvk3sk1Unj+nB00gbZqWd1ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=luNscO0d; arc=none smtp.client-ip=18.132.163.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1766761651;
	bh=MTRp+rehqQ+7n6On+OJPgTGjoFwEf7Thcm6mg/opK54=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=luNscO0dapumHVqSqIzLYj+zTbuEM1Q32N8zT3sZTj+lor4zbpUJ11I75O3cJ+o4g
	 Ee9Kfuz11GkcXWOsU5W3mZ3mt0TD/aT/qzReg42U2x99OuvKGPWwaTcqTCTS6ZS9s2
	 wTsslOrQ+0YZmlzSAJlbVY9A6Gf3uq+DABiHDSao=
X-QQ-mid: zesmtpgz9t1766761645t97afa3d3
X-QQ-Originating-IP: NnBNnG/Vv+LjTL8xz8VRh3lPkL/TPL/xqB3zZD35xBE=
Received: from localhost.localdomain ( [123.114.60.34])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 26 Dec 2025 23:07:24 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 17620591120825404023
EX-QQ-RecipientCnt: 8
From: Qiang Ma <maqianga@uniontech.com>
To: zhaotianrui@loongson.cn,
	maobibo@loongson.cn,
	chenhuacai@kernel.org,
	kernel@xen0n.name
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Qiang Ma <maqianga@uniontech.com>
Subject: [PATCH 0/3] LoongArch: KVM: Fix kvm_device leak in kvm_{pch_pic|ipi|eiointc}_destroy
Date: Fri, 26 Dec 2025 23:07:03 +0800
Message-Id: <20251226150706.2511127-1-maqianga@uniontech.com>
X-Mailer: git-send-email 2.20.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:uniontech.com:qybglogicsvrsz:qybglogicsvrsz3b-0
X-QQ-XMAILINFO: MQx7mI7eoecOuJ21VhwK810zFtRiCN4DV+77fEbwBY0tXIl+ewOCoENL
	eGaEVAw3QrjKYzNy54tV9Y5CuBVmHBh5KOdWsoPrIbTra7RbMyXUU0aBMelcgQmpXIduTC1
	2ddOrcD+/XmpO3NIP1GVP6Z/AFqgEesG2MGIJh8kso60gRgMDeEPBoVWa8NYDXu4JCSMQzf
	Ax7TZziH+9bQuR1UNJ+DIFURuR3tCZnhG+wVJom2DVSiKrFSUbRKEssOSrR2fhexCJkKxsZ
	G2HiXZqHVzxhVdLOyY55AoPZBzrHMvJtWlx5owaM6vyiwZjWQFPcTtjOsbxjah02qyuD3gA
	3/lvEGLxZa9448Wbm8Hf9871m3sxsXcCC573N5BvW8d5QFCIkoAnlbl4o3BmR0Kggeu7aml
	OXcQm8zd0O3wAUAyhkgfUMtxVPcoLRYjcNo7NUyWgAptd29eWW9PTMFFwV2Z4epPjQ4qe66
	yJHiJy7hqOsHVkJ3Htk+Hki6RIO2pCCDXZaHnxHyCEHKQ5koVJPjZhyHVDhkGGLKrTayjQF
	f4TnigmVip6DbNkeFY+Ftc3iFdgHWWA6cMv2GQQE6bHU1VkfiW9OKO3ncma7q50Mvv+CjJF
	n8OeGHv0+2ilqyXnzekPosLpU9VLmX/W1x9k90OS8E0fwiXM4tBwoVbH5YpHr7NN6d85mPL
	fr1Bzv6DVU2QkGnqThcdgMhGuh6cbPhmJBQZpTkEWf1yo6ESLKY0W03u/xLrSXLeCzj8p7v
	j65PXzISKxtusinrblFemSdZN61UDpBp7fE8fSQZF1z/9W6gU6EPswVVQibosbUXEb/jWTN
	mDWHNJOdeP3HVFlMKRr/kSgy9QidohGe37yaedsroU2ZS1GAY9OPZXhw4sw98tf+6OHB+ti
	pQANANTvviV7ez96xREV3ZmarAJDTY1ovp8pFVfz73QT168ntNxX5q8ZNscoCmShNGfi5Qf
	cq7WlIaPHJZv0D4ZSb/oQNScAslfPUib+EVYxsNe6h4liTYPZ9OB3RDO87m/JxQ1NbJZFRM
	LfZVLhqrAJ2+6rP8OZ
X-QQ-XMRINFO: Mp0Kj//9VHAxzExpfF+O8yhSrljjwrznVg==
X-QQ-RECHKSPAM: 0

In kvm_ioctl_create_device(), kvm_device has allocated memory,
kvm_device->destroy() seems to be supposed to free its kvm_device
struct, but kvm_pch_pic_destroy() is not currently doing this,
that would lead to a memory leak.

So, fix it.

Qiang Ma (3):
  LoongArch: KVM: Fix kvm_device leak in kvm_pch_pic_destroy
  LoongArch: KVM: Fix kvm_device leak in kvm_ipi_destroy
  LoongArch: KVM: Fix kvm_device leak in kvm_eiointc_destroy

 arch/loongarch/kvm/intc/eiointc.c | 2 ++
 arch/loongarch/kvm/intc/ipi.c     | 2 ++
 arch/loongarch/kvm/intc/pch_pic.c | 2 ++
 3 files changed, 6 insertions(+)

-- 
2.20.1


