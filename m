Return-Path: <kvm+bounces-56554-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C2EBB3FB2D
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 11:51:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3A4DA189A648
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 09:51:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 851FA2F1FD8;
	Tue,  2 Sep 2025 09:49:58 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B14ED2ED872;
	Tue,  2 Sep 2025 09:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756806597; cv=none; b=d4ZYWjFuHV6nIrrSp4FKzIZfseX5pEiJaW7FLGkI1HlaxpaBTbfuo25O8HmWvmJa6sEg8E2PR1MQM5tFqXWAdjfP9jSVZS2PBW9t3PIDMFbRm1xsXcxu8pwacdBQZNdavyrkViZ94inwlflNK7gujtUuWGGsbwarRcQcR5Ah88o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756806597; c=relaxed/simple;
	bh=cN9I9jMTSNJN8kn0LUhtAfaQC8Rz+kldpnKp7D7k6ds=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=nQmiE8dPtdbPrlM7/D9VfT8nMO6JgiLHWo4zfEVI9nIeTksA9GBZFhq3mp8hwBWCrci7bsDMJyKKcH3D2ym+j9YsfeTnEtcI+EIdy7EmnerAzocrikWWpTEeVjxX1A1JeJIspGfK37ACSGsCK/+e62/gJ/wvGloKO/4nzYSEhWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8Cx77+6vbZoX7wFAA--.10650S3;
	Tue, 02 Sep 2025 17:49:46 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJDx_8O5vbZoyLF4AA--.52017S2;
	Tue, 02 Sep 2025 17:49:45 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Huacai Chen <chenhuacai@kernel.org>,
	Xianglai Li <lixianglai@loongson.cn>
Cc: WANG Xuerui <kernel@xen0n.name>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] Move copy_from_user out of preempt disabled context
Date: Tue,  2 Sep 2025 17:49:41 +0800
Message-Id: <20250902094945.2957566-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJDx_8O5vbZoyLF4AA--.52017S2
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Function copy_from_user() and copy_to_user() may sleep because of page
fault, and they cannot be called with preempt disabled context, such as
spin_lock hold context.

Here this patch set move copy_from_user out of preempt disabled context,
local variable is added in spinlock context at first and then put to user
memory from local variable without spinlock.

Bibo Mao (4):
  LoongArch: KVM: Avoid use copy_from_user with lock hold in
    kvm_eiointc_regs_access
  LoongArch: KVM: Avoid use copy_from_user with lock hold in
    kvm_eiointc_sw_status_access
  LoongArch: KVM: Avoid use copy_from_user with lock hold in
    kvm_eiointc_ctrl_access
  LoongArch: KVM: Avoid use copy_from_user with lock hold in
    kvm_pch_pic_regs_access

 arch/loongarch/kvm/intc/eiointc.c | 87 +++++++++++++++++++------------
 arch/loongarch/kvm/intc/pch_pic.c | 22 +++++---
 2 files changed, 68 insertions(+), 41 deletions(-)


base-commit: b320789d6883cc00ac78ce83bccbfe7ed58afcf0
-- 
2.39.3


