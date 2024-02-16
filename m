Return-Path: <kvm+bounces-8896-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C29E385857F
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 19:43:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4A85BB223A3
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 18:43:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C964E13AA3E;
	Fri, 16 Feb 2024 18:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ZLbfNeSQ"
X-Original-To: kvm@vger.kernel.org
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73A7A137C47
	for <kvm@vger.kernel.org>; Fri, 16 Feb 2024 18:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708108935; cv=none; b=p9t1CQtA5Mwg/UzaE2V3tm+tT+C9zRG7bzfrZIjI9WA0eXhcytqVagGWB/4482oGw9uWMnLLuDEEANMF+CBnsOaJdshcPvYT7ABOsK4oYssfy4GmXhcZWduX79Hntl6PQnL1Q3reB94blCdhgBcClI9Msba75wncvVHqKIbwX9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708108935; c=relaxed/simple;
	bh=RxF9w33LgnXLTuXV5O9RLdzK9dXUqE5MSbsOmdxxwVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QcBw1rNymI2FfIa3Uww+yi7JPrNzMDqpWtuWVFiF9aVWlAXoVfFz7o+2SwSyRrHO0lrZ8JRo8EJvccDgtaTL1V+L9hu5mlbLv6qMlccMnKmDa1h4l6jrxF1i3MRaCGxQjK9a9S8dsD4vAk4jZOjRFNdcRjrkoCueRUpVT+yNNCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ZLbfNeSQ; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1708108931;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p7/gBwWxFbIZwFC+F2czZFaZoLMKZvcePyaMRonjua4=;
	b=ZLbfNeSQ+vvMysguJereiuL6HX9y7yTkwAqfZDi01alhaBPsgpmVjE5rDkwu1Yn8Htvw9v
	fzVoJNNRJHANhXohgMOEmDPfTxdaCfZD8ONhfVqCE7ZJVf2ocgo0jDD1DRg4a2cUdGSBHp
	8wDn/MKghWUzK463T149MUkCPXm0D6Y=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-kernel@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 03/10] KVM: arm64: vgic-v3: Iterate the xarray to find pending LPIs
Date: Fri, 16 Feb 2024 18:41:46 +0000
Message-ID: <20240216184153.2714504-4-oliver.upton@linux.dev>
In-Reply-To: <20240216184153.2714504-1-oliver.upton@linux.dev>
References: <20240216184153.2714504-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Start walking the LPI xarray to find pending LPIs in preparation for
the removal of the LPI linked-list. Note that the 'basic' iterator
is chosen here as each iteration needs to drop the xarray read lock
(RCU) as reads/writes to guest memory can potentially block.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-v3.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 9465d3706ab9..4ea3340786b9 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -380,6 +380,7 @@ int vgic_v3_save_pending_tables(struct kvm *kvm)
 	struct vgic_irq *irq;
 	gpa_t last_ptr = ~(gpa_t)0;
 	bool vlpi_avail = false;
+	unsigned long index;
 	int ret = 0;
 	u8 val;
 
@@ -396,7 +397,7 @@ int vgic_v3_save_pending_tables(struct kvm *kvm)
 		vlpi_avail = true;
 	}
 
-	list_for_each_entry(irq, &dist->lpi_list_head, lpi_list) {
+	xa_for_each(&dist->lpi_xa, index, irq) {
 		int byte_offset, bit_nr;
 		struct kvm_vcpu *vcpu;
 		gpa_t pendbase, ptr;
-- 
2.44.0.rc0.258.g7320e95886-goog


