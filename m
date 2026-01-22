Return-Path: <kvm+bounces-68881-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sAzRCGgScmksawAAu9opvQ
	(envelope-from <kvm+bounces-68881-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 13:04:56 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id C0D3A6660E
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 13:04:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id B45B76A9446
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 11:18:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D925C44BCB9;
	Thu, 22 Jan 2026 11:14:48 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE4DB2E975E;
	Thu, 22 Jan 2026 11:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769080488; cv=none; b=LI+GlFGv2mloDrPtwO/ojErgg5nJUbRdbk05vqESeSudAAIDkvIU4MGhXBggi67gdDtHfA9Kl03k0ZKnSS8KLgw3Et6+raZcFIQB+dcLNk8c12fulPCKtCMebZG89iu/yPvV9NDpLMz6aas/yD7IEPciK14vSArLku3mNDgz1L4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769080488; c=relaxed/simple;
	bh=UmBMjsJrlKDDA8LHwJvfeWVmruHsLXPRh900rfHsP7M=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=r9lfu7ey6JSI2xjbudybRxhU/86FKpTJOf04tuSBU4aLsupayhpwwNJ+oDrBDtkUNTi2f79JM4gpnQsLXUJk/dZuLZoHqYO77UAnr3N4YsxHaeqiCA4XcfPp5IEaBIdutiLYsYyc/r5Dog+tlci1slxLgabqEOHUUGj4ZEFzXPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8DxfcOcBnJpxHsLAA--.37401S3;
	Thu, 22 Jan 2026 19:14:36 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJDxquCbBnJpwR4rAA--.21397S2;
	Thu, 22 Jan 2026 19:14:35 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Tianrui Zhao <zhaotianrui@loongson.cn>
Cc: loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH 0/3] LoongArch: KVM: Add FPU delay load support
Date: Thu, 22 Jan 2026 19:14:30 +0800
Message-Id: <20260122111434.1737872-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJDxquCbBnJpwR4rAA--.21397S2
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.24 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:7979, ipnet:2a01:60a::/32, country:US];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[maobibo@loongson.cn,kvm@vger.kernel.org];
	R_DKIM_NA(0.00)[];
	DMARC_NA(0.00)[loongson.cn];
	TAGGED_FROM(0.00)[bounces-68881-lists,kvm=lfdr.de];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[ams.mirrors.kernel.org:helo,ams.mirrors.kernel.org:rdns,loongson.cn:mid]
X-Rspamd-Queue-Id: C0D3A6660E
X-Rspamd-Action: no action

FPU is lazy enabled in KVM hypervisor. After FPU is enabled and loaded,
vCPU can be preempted and FPU will be lost again. Here FPU is delay load
until guest enter entry.

Bibo Mao (3):
  LoongArch: KVM: Move LSX capability check in LSX exception handler
  LoongArch: KVM: Move LASX capability check in LASX exception handler
  LoongArch: KVM: Add FPU delay load support

 arch/loongarch/include/asm/kvm_host.h |  3 +++
 arch/loongarch/kvm/exit.c             | 10 ++++++---
 arch/loongarch/kvm/vcpu.c             | 30 ++++++++-------------------
 3 files changed, 19 insertions(+), 24 deletions(-)


base-commit: 24d479d26b25bce5faea3ddd9fa8f3a6c3129ea7
-- 
2.39.3


