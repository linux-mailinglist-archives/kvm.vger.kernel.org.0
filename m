Return-Path: <kvm+bounces-19215-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 231DD90230C
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 15:51:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C139E1F2379A
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 13:51:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 977E3155C92;
	Mon, 10 Jun 2024 13:43:54 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6AC9155C81;
	Mon, 10 Jun 2024 13:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718027034; cv=none; b=ONDumAGFIBPmlo/bHxJXDY5FAN0bI/h7Mf4leLVLnE0vRo/XVzggThpreejSS1B9eP80lF58NdL8KzyMmCNb9PZNq6m4DRB0UvoGW/lxMy23Cq5/uQZ0xaN3WuRxBF+BVOkqoHtH6zujLi1a5GHPD8RZdvx+I/OYE0kTs96hiP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718027034; c=relaxed/simple;
	bh=hmDkcRmffdx2dEYCxN/tyZ+CbfHY6WKH0OsV4sTvbJo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dBv7AgJImUqKkmxteglh8h92lutMfdalh4aFVPwxxY5eh8zLPWJYyepnQnFjGybSZ+LYXAE0Q0SVnPo9XRWLuUcljnU3iXgCun8P0AntlZIHzs9Nb4NcDGpBcd1proR/xjcqHfRzmfFJMgIzEUyEEBYmraePgNJ5YvYEljhBJnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0095C1692;
	Mon, 10 Jun 2024 06:44:17 -0700 (PDT)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.35.41])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E24593F58B;
	Mon, 10 Jun 2024 06:43:48 -0700 (PDT)
From: Steven Price <steven.price@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Joey Gouly <joey.gouly@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Steven Price <steven.price@arm.com>
Subject: [PATCH v3 28/43] arm64: rme: support RSI_HOST_CALL
Date: Mon, 10 Jun 2024 14:41:47 +0100
Message-Id: <20240610134202.54893-29-steven.price@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240610134202.54893-1-steven.price@arm.com>
References: <20240610134202.54893-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Joey Gouly <joey.gouly@arm.com>

Forward RSI_HOST_CALLS to KVM's HVC handler.

Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
---
 arch/arm64/kvm/rme-exit.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/arch/arm64/kvm/rme-exit.c b/arch/arm64/kvm/rme-exit.c
index 03ed147f7926..0940575b0a14 100644
--- a/arch/arm64/kvm/rme-exit.c
+++ b/arch/arm64/kvm/rme-exit.c
@@ -117,6 +117,29 @@ static int rec_exit_ripas_change(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+static int rec_exit_host_call(struct kvm_vcpu *vcpu)
+{
+	int ret, i;
+	struct realm_rec *rec = &vcpu->arch.rec;
+
+	vcpu->stat.hvc_exit_stat++;
+
+	for (i = 0; i < REC_RUN_GPRS; i++)
+		vcpu_set_reg(vcpu, i, rec->run->exit.gprs[i]);
+
+	ret = kvm_smccc_call_handler(vcpu);
+
+	if (ret < 0) {
+		vcpu_set_reg(vcpu, 0, ~0UL);
+		ret = 1;
+	}
+
+	for (i = 0; i < REC_RUN_GPRS; i++)
+		rec->run->enter.gprs[i] = vcpu_get_reg(vcpu, i);
+
+	return ret;
+}
+
 static void update_arch_timer_irq_lines(struct kvm_vcpu *vcpu)
 {
 	struct realm_rec *rec = &vcpu->arch.rec;
@@ -178,6 +201,8 @@ int handle_rme_exit(struct kvm_vcpu *vcpu, int rec_run_ret)
 		return rec_exit_psci(vcpu);
 	case RMI_EXIT_RIPAS_CHANGE:
 		return rec_exit_ripas_change(vcpu);
+	case RMI_EXIT_HOST_CALL:
+		return rec_exit_host_call(vcpu);
 	}
 
 	kvm_pr_unimpl("Unsupported exit reason: %u\n",
-- 
2.34.1


