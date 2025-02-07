Return-Path: <kvm+bounces-37556-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 26852A2B9B6
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 04:27:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E013F166F80
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 03:27:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79A8A18DB00;
	Fri,  7 Feb 2025 03:26:47 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD2C217BB16;
	Fri,  7 Feb 2025 03:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738898806; cv=none; b=SAoyqAhpYVNqpBdXK9J/C5CEDZ6okh1eW5Mxb5yaCNzouGuOeuU3PIpcwKps93k1+za2g0haNsWAgm0bP9kRZQBiD7NB6IU48JkyNlENdcOz3uQWzOndMNsHcaxrvurpM3i1C8GhJBRuzqhgQ+mpqnHDsE9ejU+oRbGqQO744Yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738898806; c=relaxed/simple;
	bh=uAACmwfTwi1FpXNOSvbzbkrI3utd3c8GcS6yWKXUNI0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mjsx69c+huLlqn+2vKkBdeTxXzxOFO0frHuEM9t1NMGvhhOlwdfKTO53wKWAYJS5Ft7TuLVqRCVbNHtZQz0EV5q+7JUhXWkoGMWimtBBm+ZcUx0r3rQKNMuo8K1bR/AOCRqhOAZVYSSrnAuTyAr+YteykRYqOvNcw6NKaRSMdnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8CxieBtfaVnRDFuAA--.17414S3;
	Fri, 07 Feb 2025 11:26:37 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowMDx_MRqfaVn0JsDAA--.12326S5;
	Fri, 07 Feb 2025 11:26:35 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>
Cc: Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] LoongArch: KVM: Set host with kernel mode when switch to VM mode
Date: Fri,  7 Feb 2025 11:26:34 +0800
Message-Id: <20250207032634.2333300-4-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20250207032634.2333300-1-maobibo@loongson.cn>
References: <20250207032634.2333300-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMDx_MRqfaVn0JsDAA--.12326S5
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

PRMD and ERA register is only meaningful on the beginning stage
of exception entry, and it can be overwritten for nested irq or
exception.

When CPU runs in VM mode, interrupt need be enabled on host. And the
mode for host had better be kernel mode rather than random.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/kvm/switch.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/loongarch/kvm/switch.S b/arch/loongarch/kvm/switch.S
index 0c292f818492..1be185e94807 100644
--- a/arch/loongarch/kvm/switch.S
+++ b/arch/loongarch/kvm/switch.S
@@ -85,7 +85,7 @@
 	 * Guest CRMD comes from separate GCSR_CRMD register
 	 */
 	ori	t0, zero, CSR_PRMD_PIE
-	csrxchg	t0, t0,   LOONGARCH_CSR_PRMD
+	csrwr	t0, LOONGARCH_CSR_PRMD
 
 	/* Set PVM bit to setup ertn to guest context */
 	ori	t0, zero, CSR_GSTAT_PVM
-- 
2.39.3


