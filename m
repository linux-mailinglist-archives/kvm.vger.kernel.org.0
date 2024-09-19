Return-Path: <kvm+bounces-27181-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B8DC597CBF7
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 18:02:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6E3A71F21F0E
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 16:02:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F2841A01B0;
	Thu, 19 Sep 2024 16:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="Uy4kYy8D"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EA3312E4A
	for <kvm@vger.kernel.org>; Thu, 19 Sep 2024 16:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726761753; cv=none; b=MyntH8jND0KLP14dNFMvpgDh+Qe6fpIOa6JBNBr/ZNZuRTtE5xLUJfBBMmiJkkjpwLAWO9Jgw3JzN/iv5TjzZOKiInHJfp9awnwOWNUTww7a4EIfOoLKvg5awwmhiBiN5hiYiqoPTEdVom8kwta2qF2tW5Z5+p12j8bDVhYMpNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726761753; c=relaxed/simple;
	bh=3Rdw/7FPHr7LRKVhUtEAjNZXLsqUxVL5CyGv7Wt/Dy4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=q/SgGonInl10aMEBwp55eTpAHeUmjkKJeI08MNbmE43MjGj48u5NejzBWmCav9811qChvWIIIpSGE2546pNMEgzD53axsx6+9KZLWvKkvmmle3PxPS15CFRDqlCXXmv49qDt5Z5Jm11BYBDYWgUgldNKTEG3meupD1Ql0vWQogE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=Uy4kYy8D; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-20696938f86so9078865ad.3
        for <kvm@vger.kernel.org>; Thu, 19 Sep 2024 09:02:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1726761751; x=1727366551; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=IY5B5QxXDNVGbG3vnBPyBqvWzO5uiDp/nIYu33vK85A=;
        b=Uy4kYy8DvylGxgTb8+p2pAPlwrvJFuTxYB/fDG+Skl2LR7fBUDhc2lzJwqWoUEEaX+
         g11Iv4uhb7dKs/wpqhCbZZPVrIBy3O9nbLOX9CRaCht7k4JMqQp++kEn/9v//9x5hbEB
         qxtIJR+2mpYz5mTnDS4eoZEg/eV7bI8RhQ1j2f4OI1acsI1yUwzVtiTQaxEzid2Tuw60
         5JjqBsZMNhRcVcdlipszY/p/zNOgrcGzGI1Ki+bKgAhqUYhwktc9BPlJYosg6K9qGOon
         4ei1PrnquEEvXEETp99f3DKpSLRfGtxV4LTGwWRncyjI5YGjg3b5nLl2V6yE82dhSYSr
         nB+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726761751; x=1727366551;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IY5B5QxXDNVGbG3vnBPyBqvWzO5uiDp/nIYu33vK85A=;
        b=AX6BGcmx0dKESVmHghpFSU8mMgfqcSX/VXBcK8B9Kg5VW/eYra6b7a4Ffll1swaWN+
         x5i6G6cOHoYv3K9HgpnVVuirCFOcn0cBj6KdIvNcvSbo0EYyHeHypfYWNOzv2/XgYgZH
         MlNhj1oEFCmdnwgfBq0uWS3gpezJay1KOuESexJU2IQ7SUSUeVU31wavar+9K4/j7ny1
         PWBezflLX6bfnWSdkYogWWB4mmgM5P7EqvhTgAQvuISuZYs7zmf7/oEmrCWTHNtMYTGv
         AHp/r0EGWmCPMT9Yceh2Cg9vzxK82shbsJYBbhuK2ogWM7nvcifW1Io6ElVARuJGp2Qx
         bz8g==
X-Forwarded-Encrypted: i=1; AJvYcCVNI2859w5xhP/lJMAEHH5yWIxdP6LdYurmKu2rCD0NtsBhOfUKZ0+nqycap/yez4zySQ4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz1npr8+89ertdG0D04K7hZK7UWdE8K7SkbCzjb91wYukMHFJMv
	Hi2TDFwipNKf4kU0ksRrTuea8ZnenKUjQNdHF/AJVfOxLj/08mNmmG91vRNinrw=
X-Google-Smtp-Source: AGHT+IHlrfEPPxfE7BBmxMTJoT8E08EE7/Q0AmzGFUzu6sN8uV/9Rnz5ZDYIemz+SMlLQ8t0Vj4kxg==
X-Received: by 2002:a17:903:8c8:b0:205:40a6:115a with SMTP id d9443c01a7336-2076e4360f7mr350612825ad.48.1726761751137;
        Thu, 19 Sep 2024 09:02:31 -0700 (PDT)
Received: from cyan-mbp.internal.sifive.com (114-32-147-116.hinet-ip.hinet.net. [114.32.147.116])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-207946d19e5sm81665645ad.140.2024.09.19.09.02.28
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 19 Sep 2024 09:02:30 -0700 (PDT)
From: Cyan Yang <cyan.yang@sifive.com>
To: anup@brainfault.org
Cc: atishp@atishpatra.org,
	paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Cyan Yang <cyan.yang@sifive.com>,
	Yong-Xuan Wang <yongxuan.wang@sifive.com>
Subject: [PATCH] RISCV: KVM: use raw_spinlock for critical section in imsic
Date: Fri, 20 Sep 2024 00:01:26 +0800
Message-Id: <20240919160126.44487-1-cyan.yang@sifive.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For the external interrupt updating procedure in imsic, there was a
spinlock to protect it already. But since it should not be preempted in
any cases, we should turn to use raw_spinlock to prevent any preemption
in case PREEMPT_RT was enabled.

Signed-off-by: Cyan Yang <cyan.yang@sifive.com>
Reviewed-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
---
 arch/riscv/kvm/aia_imsic.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/riscv/kvm/aia_imsic.c b/arch/riscv/kvm/aia_imsic.c
index 0a1e85932..a8085cd82 100644
--- a/arch/riscv/kvm/aia_imsic.c
+++ b/arch/riscv/kvm/aia_imsic.c
@@ -55,7 +55,7 @@ struct imsic {
 	/* IMSIC SW-file */
 	struct imsic_mrif *swfile;
 	phys_addr_t swfile_pa;
-	spinlock_t swfile_extirq_lock;
+	raw_spinlock_t swfile_extirq_lock;
 };
 
 #define imsic_vs_csr_read(__c)			\
@@ -622,7 +622,7 @@ static void imsic_swfile_extirq_update(struct kvm_vcpu *vcpu)
 	 * interruptions between reading topei and updating pending status.
 	 */
 
-	spin_lock_irqsave(&imsic->swfile_extirq_lock, flags);
+	raw_spin_lock_irqsave(&imsic->swfile_extirq_lock, flags);
 
 	if (imsic_mrif_atomic_read(mrif, &mrif->eidelivery) &&
 	    imsic_mrif_topei(mrif, imsic->nr_eix, imsic->nr_msis))
@@ -630,7 +630,7 @@ static void imsic_swfile_extirq_update(struct kvm_vcpu *vcpu)
 	else
 		kvm_riscv_vcpu_unset_interrupt(vcpu, IRQ_VS_EXT);
 
-	spin_unlock_irqrestore(&imsic->swfile_extirq_lock, flags);
+	raw_spin_unlock_irqrestore(&imsic->swfile_extirq_lock, flags);
 }
 
 static void imsic_swfile_read(struct kvm_vcpu *vcpu, bool clear,
@@ -1051,7 +1051,7 @@ int kvm_riscv_vcpu_aia_imsic_init(struct kvm_vcpu *vcpu)
 	}
 	imsic->swfile = page_to_virt(swfile_page);
 	imsic->swfile_pa = page_to_phys(swfile_page);
-	spin_lock_init(&imsic->swfile_extirq_lock);
+	raw_spin_lock_init(&imsic->swfile_extirq_lock);
 
 	/* Setup IO device */
 	kvm_iodevice_init(&imsic->iodev, &imsic_iodoev_ops);
-- 
2.39.5 (Apple Git-154)


