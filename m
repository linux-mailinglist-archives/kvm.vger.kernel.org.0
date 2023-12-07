Return-Path: <kvm+bounces-3870-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 24E58808B8B
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 16:12:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D3B4E28275E
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 15:12:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31C0246B82;
	Thu,  7 Dec 2023 15:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P1qywze3"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70A5D44C85;
	Thu,  7 Dec 2023 15:12:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43442C433A9;
	Thu,  7 Dec 2023 15:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701961936;
	bh=G1d1p3GQg206rYpvaJngUIRBrnEaOtSk7cwkcJjOcAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P1qywze3eq4f+FlzruUCaqp6aR/OplVKvURA2scifbXqVCJN/3nAwyMn6h8j6TA6M
	 xSFXQ0080Sn0tr6JN2a6BBWOitaggA8gg5atPCjJVAUz8ShOQb3vfBKQJkL/GDGZA4
	 w+pqBh77w2LmNznvdOszRFEe+pvRTAhPt9W/RMQXbk50ns7pT53ecEr4OeVmftzeZ2
	 w3Gybawk/R7KRvKHHLHw5TL/G4CNWGIm5bYNGDYOXDKYo/u3zIA+ivbfLbEkq6aQ8P
	 +AUoupe1InD6EYiddZaAy6fKRTl3gmMAkLr64dBXe5F14V0/1eRxCsqjdAHaVGpA1e
	 ly2lKjxLalEfw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rBG2w-002FcG-6H;
	Thu, 07 Dec 2023 15:12:14 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	vdonnefort@google.com
Subject: [PATCH 5/5] KVM: Convert comment into an assertion in kvm_io_bus_register_dev()
Date: Thu,  7 Dec 2023 15:12:01 +0000
Message-Id: <20231207151201.3028710-6-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231207151201.3028710-1-maz@kernel.org>
References: <20231207151201.3028710-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, will@kernel.org, vdonnefort@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Instead of having a comment indicating the need to hold slots_lock
when calling kvm_io_bus_register_dev(), make it explicit with
a lockdep assertion.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 virt/kvm/kvm_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 486800a7024b..278d31ae45d8 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5545,7 +5545,6 @@ int kvm_io_bus_read(struct kvm_vcpu *vcpu, enum kvm_bus bus_idx, gpa_t addr,
 	return r < 0 ? r : 0;
 }
 
-/* Caller must hold slots_lock. */
 int kvm_io_bus_register_dev(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t addr,
 			    int len, struct kvm_io_device *dev)
 {
@@ -5553,6 +5552,8 @@ int kvm_io_bus_register_dev(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t addr,
 	struct kvm_io_bus *new_bus, *bus;
 	struct kvm_io_range range;
 
+	lockdep_assert_held(&kvm->slots_lock);
+
 	bus = kvm_get_bus(kvm, bus_idx);
 	if (!bus)
 		return -ENOMEM;
-- 
2.39.2


