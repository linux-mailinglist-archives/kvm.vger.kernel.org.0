Return-Path: <kvm+bounces-4143-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D31480E3D6
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 06:35:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CC238B20C8C
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 05:35:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 144C114A8B;
	Tue, 12 Dec 2023 05:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="Vji2CaE2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E28ECF
	for <kvm@vger.kernel.org>; Mon, 11 Dec 2023 21:35:08 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id d9443c01a7336-1d0b2752dc6so46232795ad.3
        for <kvm@vger.kernel.org>; Mon, 11 Dec 2023 21:35:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1702359308; x=1702964108; darn=vger.kernel.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mcj60ICAmx2Wgj1m3BhaBwMoYIl3KbsB3eCSbSy5S74=;
        b=Vji2CaE2Nquab2swUAivgUpGrMIQSChLOi1FhGA62KDiMm8XUtc42WvPcz1S56h1p4
         sBGbo0IHf3hbgJ9twjOQ36VECk6uq9HUCROQHvNhL9KxyzyNN9co5ZJ2S/bc8lSPxH+B
         xMAu+NZTUMJLx52XXB+6eLRtpaS34O5Jk987CbRcGqLF7hxcHS9p+wk21ldpdP7GqJii
         4RQbQWhjnzr1bhtMC8+JS1z9Wcms6X2zzflDBXdAlA8bxUF32BTe8J12A9wpdvLx17BC
         iKHzfZo1Lkmb/DD0ipyi+eNcHGGKWJFBcRIZfXwlbfuF1gP4Mw8my7uyWYi5cPsXjSuJ
         cMRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702359308; x=1702964108;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mcj60ICAmx2Wgj1m3BhaBwMoYIl3KbsB3eCSbSy5S74=;
        b=cijDCWeUsPkAcLNSP91W0JK49n/Yfmj7Rkw14Gin4dbKR6w3GiMqhwwrK5dyUMCj+g
         WDbboeWeAYqRO0uE9ZFir2Hus44sDphX6gMGgPP1aSSOzcYmA25WDCTXQCjNy+llub31
         qbnm1vXkWNlfPj3s+EuAku+zuhwLY5z6+nXJfjjcwOa1SZkXizFNxa8ZO6a8Jfk7iIOS
         yYvMAcPFh8KGHNjbAnJyiIA0bdo+W5g4oBJU9KzYKENdenHK0z6xengvoXf+D7i5FPqp
         1a9uyQ1mlzo32wCAVAT6449k+ZQ5SVCOdHjvaANILCSiDgDETjtcBgsNWAIRIrvXK0Nb
         LKFw==
X-Gm-Message-State: AOJu0YxPXmmDOtW7FRuD5IykX4utPD6eprNBOBwgA+8wQEIGGUkqf2Kc
	3+3irtXEh9x9l/XXCD+bmtGgNg==
X-Google-Smtp-Source: AGHT+IH+0SEHIrmD1lG9gKpeJV/gu+68+6vQQUc6qbNwDMzT/HchEiI83Pj9+Ajy1EiiaZ5i2c6GhQ==
X-Received: by 2002:a17:902:eb88:b0:1d0:6ffd:9e37 with SMTP id q8-20020a170902eb8800b001d06ffd9e37mr6217232plg.137.1702359308075;
        Mon, 11 Dec 2023 21:35:08 -0800 (PST)
Received: from hsinchu26.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id l15-20020a170903244f00b001cf5654fc29sm7654118pls.72.2023.12.11.21.35.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Dec 2023 21:35:07 -0800 (PST)
From: Yong-Xuan Wang <yongxuan.wang@sifive.com>
To: linux-riscv@lists.infradead.org,
	kvm-riscv@lists.infradead.org
Cc: greentime.hu@sifive.com,
	vincent.chen@sifive.com,
	Yong-Xuan Wang <yongxuan.wang@sifive.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] RISCV: KVM: should not be interrupted when update the external interrupt pending
Date: Tue, 12 Dec 2023 05:34:59 +0000
Message-Id: <20231212053501.12054-1-yongxuan.wang@sifive.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The emulated IMSIC update the external interrupt pending depending on the
value of eidelivery and topei. It might lose an interrupt when it is
interrupted before setting the new value to the pending status.

For example, when VCPU0 sends an IPI to VCPU1 via IMSIC:

VCPU0                           VCPU1

                                CSRSWAP topei = 0
                                The VCPU1 has claimed all the external
                                interrupt in its interrupt handler.

                                topei of VCPU1's IMSIC = 0

set pending in VCPU1's IMSIC

topei of VCPU1' IMSIC = 1

set the external interrupt
pending of VCPU1

                                clear the external interrupt pending
                                of VCPU1

When the VCPU1 switches back to VS mode, it exits the interrupt handler
because the result of CSRSWAP topei is 0. If there are no other external
interrupts injected into the VCPU1's IMSIC, VCPU1 will never know this
pending interrupt unless it initiative read the topei.

If the interruption occurs between updating interrupt pending in IMSIC
and updating external interrupt pending of VCPU, it will not cause a
problem. Suppose that the VCPU1 clears the IPI pending in IMSIC right
after VCPU0 sets the pending, the external interrupt pending of VCPU1
will not be set because the topei is 0. But when the VCPU1 goes back to
VS mode, the pending IPI will be reported by the CSRSWAP topei, it will
not lose this interrupt.

So we only need to make the external interrupt updating procedure as a
critical section to avoid the problem.

Tested-by: Roy Lin <roy.lin@sifive.com>
Tested-by: Wayling Chen <wayling.chen@sifive.com>
Co-developed-by: Vincent Chen <vincent.chen@sifive.com>
Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
---
 arch/riscv/kvm/aia_imsic.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/riscv/kvm/aia_imsic.c b/arch/riscv/kvm/aia_imsic.c
index 6cf23b8adb71..0278aa0ca16a 100644
--- a/arch/riscv/kvm/aia_imsic.c
+++ b/arch/riscv/kvm/aia_imsic.c
@@ -37,6 +37,8 @@ struct imsic {
 	u32 nr_eix;
 	u32 nr_hw_eix;
 
+	spinlock_t extirq_update_lock;
+
 	/*
 	 * At any point in time, the register state is in
 	 * one of the following places:
@@ -613,12 +615,17 @@ static void imsic_swfile_extirq_update(struct kvm_vcpu *vcpu)
 {
 	struct imsic *imsic = vcpu->arch.aia_context.imsic_state;
 	struct imsic_mrif *mrif = imsic->swfile;
+	unsigned long flags;
+
+	spin_lock_irqsave(&imsic->extirq_update_lock, flags);
 
 	if (imsic_mrif_atomic_read(mrif, &mrif->eidelivery) &&
 	    imsic_mrif_topei(mrif, imsic->nr_eix, imsic->nr_msis))
 		kvm_riscv_vcpu_set_interrupt(vcpu, IRQ_VS_EXT);
 	else
 		kvm_riscv_vcpu_unset_interrupt(vcpu, IRQ_VS_EXT);
+
+	spin_unlock_irqrestore(&imsic->extirq_update_lock, flags);
 }
 
 static void imsic_swfile_read(struct kvm_vcpu *vcpu, bool clear,
@@ -1029,6 +1036,7 @@ int kvm_riscv_vcpu_aia_imsic_init(struct kvm_vcpu *vcpu)
 	imsic->nr_eix = BITS_TO_U64(imsic->nr_msis);
 	imsic->nr_hw_eix = BITS_TO_U64(kvm_riscv_aia_max_ids);
 	imsic->vsfile_hgei = imsic->vsfile_cpu = -1;
+	spin_lock_init(&imsic->extirq_update_lock);
 
 	/* Setup IMSIC SW-file */
 	swfile_page = alloc_pages(GFP_KERNEL | __GFP_ZERO,
-- 
2.17.1


