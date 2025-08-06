Return-Path: <kvm+bounces-54100-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BA5EB1C2A9
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 11:02:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E1D6E1680A0
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 09:01:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8B01289371;
	Wed,  6 Aug 2025 09:00:55 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 151D928852E;
	Wed,  6 Aug 2025 09:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754470855; cv=none; b=sbnQJ0kbC7rwoFKb+sACfVPRa2jyTc1kPrU6Luz31lqgBsQz7IuwUCxq5UQvzn6gLyNh5m6BUSGVBPA/6S8bPEI+VHr3qvsfC44ZMeBZGtdHznJvBDv2CgVrjnkyDA//LsNvQCn81U9p3zIDgeoqKlH2E+SOGXBLEYv0J65UHB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754470855; c=relaxed/simple;
	bh=PesLW11khJRpGmSVJfT+LbNggq4Xf0R0wDY67UVzXGI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ujKnji4Z40v4ihbK7rtNu+XvPw1WFR4MeB/yuSBtcuuCO3YCPK+LCtJin8kIGLvJra/AgpFSQayc3AOIIxeiv130Uiy9miqSl4/iE/IQR4XqY7fzO5HWMAT0SFOCF23DsOERq+r/fpPNdPBF7xNSIovATUj6ePkG6TEP8Zlp6Vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8AxmnHDGZNoj5s5AQ--.47823S3;
	Wed, 06 Aug 2025 17:00:51 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJBxzsG+GZNoe6k4AA--.54411S5;
	Wed, 06 Aug 2025 17:00:49 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	Xianglai Li <lixianglai@loongson.cn>
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/3] LoongArch: KVM: Make function kvm_own_lbt() robust
Date: Wed,  6 Aug 2025 17:00:46 +0800
Message-Id: <20250806090046.2028785-4-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20250806090046.2028785-1-maobibo@loongson.cn>
References: <20250806090046.2028785-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJBxzsG+GZNoe6k4AA--.54411S5
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Add flag KVM_LARCH_LBT checking in function kvm_own_lbt(), so that
it can be called safely rather than duplicated enabling again.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/kvm/vcpu.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index d1b8c50941ca..ce478151466c 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -1283,9 +1283,11 @@ int kvm_own_lbt(struct kvm_vcpu *vcpu)
 		return -EINVAL;
 
 	preempt_disable();
-	set_csr_euen(CSR_EUEN_LBTEN);
-	_restore_lbt(&vcpu->arch.lbt);
-	vcpu->arch.aux_inuse |= KVM_LARCH_LBT;
+	if (!(vcpu->arch.aux_inuse & KVM_LARCH_LBT)) {
+		set_csr_euen(CSR_EUEN_LBTEN);
+		_restore_lbt(&vcpu->arch.lbt);
+		vcpu->arch.aux_inuse |= KVM_LARCH_LBT;
+	}
 	preempt_enable();
 
 	return 0;
-- 
2.39.3


