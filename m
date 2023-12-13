Return-Path: <kvm+bounces-4287-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A19EC810A1E
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 07:16:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 16A44B20CE4
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 06:16:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F07C0F9FA;
	Wed, 13 Dec 2023 06:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="Igxe7+XE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD831AD
	for <kvm@vger.kernel.org>; Tue, 12 Dec 2023 22:16:16 -0800 (PST)
Received: by mail-ot1-x32d.google.com with SMTP id 46e09a7af769-6d9f7af8918so3655025a34.0
        for <kvm@vger.kernel.org>; Tue, 12 Dec 2023 22:16:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1702448176; x=1703052976; darn=vger.kernel.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uvNv5wfHF4xhsTtKWQpkLRjgdWBIUIRMHOfm0nTFkAs=;
        b=Igxe7+XErz0OpoPk/X2UUroCzmLxq0eraYDWHPJe2KaVNQ6dWfFphGgBafPBeeAjMV
         3d3NUNVMPWyi7wlitNCoe3lH8VCPMxNUNkabFDz6ZK1zRB7hJjc3KFsAOizhJGp8ISHJ
         XRhifwLqSgRLoZDcma9TUX0KVgSwp8YV0Z7zC7muAdthhvG058jPM43Utex7KUAukAyI
         3+ae72ojMj/zRFsQ4Rm9bxRrrSi1ZUZSvvCuX9ENd4orDS3UOucdXjzjKjdePhMsVZ8u
         M/YC2cbjYG2G7AzTxb9xJhHX2NwKd0H98xe5FP5ukIsAYUpQSB42Nh6jjCsmpWEFaAnj
         uJMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702448176; x=1703052976;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uvNv5wfHF4xhsTtKWQpkLRjgdWBIUIRMHOfm0nTFkAs=;
        b=Eqml71s5p8Q9keyDmSTVzTKtO6zbOSBR5HaPaz751+EddzL9Bug19K9jHEFlpuPWq2
         nsC94oCu0LTdoGsd0c7gNpARFSfETRYcYBQHrVe3Qna1riXFOcihLw5wtxtcZ7JVRtq3
         aXinI4vilwDjxXnGm4w6zSUAHWkTuwuh5nPwy9KL9VPMOazy2mwsE3yZhlAbjhoRrz7G
         HkRxEmtJTtUiLF4vjIhUfcDdbNB9DQVz55Mms7AP0DLt3Q0zI4tFIK/xz66bahmJLBYQ
         Ord0qqqEkcBqG9bu9XfPoksrLNpdT7lZ5qmnXNAm5+Sxon6wgPj0jzHQ4akmK4G2N+Hj
         689w==
X-Gm-Message-State: AOJu0YwB7RgTwcMYx51WO9vJkdD5+w1+0bSPRf9Uts7G+6QC7zNAROWN
	4GuoV/XkVYKuF5ReVMQeTvJXFw==
X-Google-Smtp-Source: AGHT+IGagDM0nKL4ki3x1mUmX8Sb5HGZKw8UWtPHqF+o2WY74k963vboMKd1J30RZCv1Lb6uCLOblA==
X-Received: by 2002:a05:6808:1385:b0:3b8:45cf:9b2 with SMTP id c5-20020a056808138500b003b845cf09b2mr9139581oiw.20.1702448175749;
        Tue, 12 Dec 2023 22:16:15 -0800 (PST)
Received: from hsinchu26.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id w2-20020a654102000000b005c65ed23b65sm7731076pgp.94.2023.12.12.22.16.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Dec 2023 22:16:14 -0800 (PST)
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
Subject: [PATCH v2 1/1] RISCV: KVM: update external interrupt atomically for IMSIC swfile
Date: Wed, 13 Dec 2023 06:16:09 +0000
Message-Id: <20231213061610.11100-1-yongxuan.wang@sifive.com>
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

Fixes: db8b7e97d613 ("RISC-V: KVM: Add in-kernel virtualization of AIA IMSIC")
Tested-by: Roy Lin <roy.lin@sifive.com>
Tested-by: Wayling Chen <wayling.chen@sifive.com>
Co-developed-by: Vincent Chen <vincent.chen@sifive.com>
Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
---
Changelog
v2:
- rename the variable and add a short comment in the code
---
 arch/riscv/kvm/aia_imsic.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/riscv/kvm/aia_imsic.c b/arch/riscv/kvm/aia_imsic.c
index 6cf23b8adb71..e808723a85f1 100644
--- a/arch/riscv/kvm/aia_imsic.c
+++ b/arch/riscv/kvm/aia_imsic.c
@@ -55,6 +55,7 @@ struct imsic {
 	/* IMSIC SW-file */
 	struct imsic_mrif *swfile;
 	phys_addr_t swfile_pa;
+	spinlock_t swfile_extirq_lock;
 };
 
 #define imsic_vs_csr_read(__c)			\
@@ -613,12 +614,23 @@ static void imsic_swfile_extirq_update(struct kvm_vcpu *vcpu)
 {
 	struct imsic *imsic = vcpu->arch.aia_context.imsic_state;
 	struct imsic_mrif *mrif = imsic->swfile;
+	unsigned long flags;
+
+	/*
+	 * The critical section is necessary during external interrupt
+	 * updates to avoid the risk of losing interrupts due to potential
+	 * interruptions between reading topei and updating pending status.
+	 */
+
+	spin_lock_irqsave(&imsic->swfile_extirq_lock, flags);
 
 	if (imsic_mrif_atomic_read(mrif, &mrif->eidelivery) &&
 	    imsic_mrif_topei(mrif, imsic->nr_eix, imsic->nr_msis))
 		kvm_riscv_vcpu_set_interrupt(vcpu, IRQ_VS_EXT);
 	else
 		kvm_riscv_vcpu_unset_interrupt(vcpu, IRQ_VS_EXT);
+
+	spin_unlock_irqrestore(&imsic->swfile_extirq_lock, flags);
 }
 
 static void imsic_swfile_read(struct kvm_vcpu *vcpu, bool clear,
@@ -1039,6 +1051,7 @@ int kvm_riscv_vcpu_aia_imsic_init(struct kvm_vcpu *vcpu)
 	}
 	imsic->swfile = page_to_virt(swfile_page);
 	imsic->swfile_pa = page_to_phys(swfile_page);
+	spin_lock_init(&imsic->swfile_extirq_lock);
 
 	/* Setup IO device */
 	kvm_iodevice_init(&imsic->iodev, &imsic_iodoev_ops);
-- 
2.17.1


