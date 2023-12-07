Return-Path: <kvm+bounces-3866-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BF3E7808B87
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 16:12:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7B32328270B
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 15:12:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60FA045BFA;
	Thu,  7 Dec 2023 15:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jzFjWXVC"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19FF244C77;
	Thu,  7 Dec 2023 15:12:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E013EC433C7;
	Thu,  7 Dec 2023 15:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701961935;
	bh=SnsvmIC202ior+1r69+srxR7F82K1dQtOQXdiYjPx7k=;
	h=From:To:Cc:Subject:Date:From;
	b=jzFjWXVC8Redtt2hoE0mpBCM8NSbvS5MurAwlMk/G3mMI0LVAJcmL5Qbx7mwpXXTe
	 qHFnT9MsfskpOruldhLPfCg41x8U98zJsfePjIo6uDlETkR24LjKIN5UJgYGXtC94S
	 g9YWUC+YntKGmjyrH/55dKiy++ZhEP/5qiODux7fqeY6jVEa5uQMNWZK14Yoa4xreu
	 hccSBRwUIeUBj25LwUtqIx4kvZo1ocajRdYjm3R4lAxa2Etn2dgq9NCJJedwCUM7QW
	 KJaYThoLwGbBC4eKfT/137JWH1vCDbv8cma0yZjpA1ljBpHZyM4643O14r9G3sKAke
	 RRRr0dnw9mxJg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rBG2v-002FcG-79;
	Thu, 07 Dec 2023 15:12:13 +0000
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
Subject: [PATCH 0/5] KVM: arm64: vgic fixes for 6.7
Date: Thu,  7 Dec 2023 15:11:56 +0000
Message-Id: <20231207151201.3028710-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
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

It appears that under some cirumstances, the lifetime of a vcpu
doesn't correctly align with that of the structure describing the
redistributor associated with that vcpu. That's not great.

Fixing it is, unfortunately, not as trivial as it appears as the
required locking gets in the way.

The first two patches in this series amend that locking so that the
third patch, which is the actual fix, becomes almost trivial. The last
two patches are more cosmetic and only add assertions that helped me
debugging the whole thing.

I've earmarked the first 3 patches as stable candidates, and would
love to see them in 6.7. Patches on top of -rc4.

Marc Zyngier (5):
  KVM: arm64: vgic: Simplify kvm_vgic_destroy()
  KVM: arm64: vgic: Add a non-locking primitive for
    kvm_vgic_vcpu_destroy()
  KVM: arm64: vgic: Force vcpu vgic teardown on vcpu destroy
  KVM: arm64: vgic: Ensure that slots_lock is held in
    vgic_register_all_redist_iodevs()
  KVM: Convert comment into an assertion in kvm_io_bus_register_dev()

 arch/arm64/kvm/arm.c               |  2 +-
 arch/arm64/kvm/vgic/vgic-init.c    | 47 ++++++++++++++++++------------
 arch/arm64/kvm/vgic/vgic-mmio-v3.c |  4 ++-
 arch/arm64/kvm/vgic/vgic.h         |  1 +
 virt/kvm/kvm_main.c                |  3 +-
 5 files changed, 36 insertions(+), 21 deletions(-)

-- 
2.39.2


