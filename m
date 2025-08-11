Return-Path: <kvm+bounces-54356-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C521B1FD9D
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 04:14:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B59B37A5633
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 02:12:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBAF9263F38;
	Mon, 11 Aug 2025 02:13:58 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D60011C07C4;
	Mon, 11 Aug 2025 02:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754878438; cv=none; b=k8kHMv6x81V6XggV/SPsvLnXP/YhYRsD64hZ5TEUgvPO28Tc7SBDeLDuHDzE17nZJoasHEFFFLGS5iBESXHbq0XozVvfce7IAvssFcRjW0VzF0YtJlOcnlggqE1bdTIj18kmV9pAKZQeQeJ5ti6+aQAHSz5+eDv/D51ErrR7Ic8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754878438; c=relaxed/simple;
	bh=ZkwqLtuVEwEfj4riMhLdaZMOWzTOEY5QrtIz2t/nj6o=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=mIB73roC1pZHMkY8Dschv3Or9nI8RjabIrVKiY5ELIFQB9K6sddsJQtnYg4eg4a0n3Z9dO4mxb7jEXijLCYi1FIK9necTgPZgawp7RSljwupCU33GJzXpT03PR1iKHz8cg5ozjtTa/k8h/QSUGcvBUhDMjqCIVnZMSHCqP8NvWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8DxbKzZUZlomBg+AQ--.52699S3;
	Mon, 11 Aug 2025 10:13:45 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJDxQ+TYUZloMZtBAA--.48509S2;
	Mon, 11 Aug 2025 10:13:45 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	Xianglai Li <lixianglai@loongson.cn>
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] LoongArch: KVM: Support various access size with pch_pic emulation
Date: Mon, 11 Aug 2025 10:13:39 +0800
Message-Id: <20250811021344.3678306-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJDxQ+TYUZloMZtBAA--.48509S2
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

With PCH PIC interrupt controller emulation driver, its access size is
hardcoded now. Instead the MMIO register can be accessed with different
size such 1/2/4/8.

This patchset adds various read/write size support with emulation
function loongarch_pch_pic_read() and loongarch_pch_pic_write().

Bibo Mao (5):
  LoongArch: KVM: Set version information at initial stage
  LoongArch: KVM: Add read length support in loongarch_pch_pic_read()
  LoongArch: KVM: Add IRR and ISR register read emulation
  LoongArch: KVM: Add different length support in
    loongarch_pch_pic_write()
  LoongArch: KVM: Add address alignment check in pch_pic register access

 arch/loongarch/include/asm/kvm_pch_pic.h |  15 +-
 arch/loongarch/kvm/intc/pch_pic.c        | 239 ++++++++++-------------
 2 files changed, 120 insertions(+), 134 deletions(-)


base-commit: 8f5ae30d69d7543eee0d70083daf4de8fe15d585
-- 
2.39.3


