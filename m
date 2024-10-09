Return-Path: <kvm+bounces-28260-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CBD09970B3
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 18:10:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B847E1F2394F
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 16:10:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B91B200121;
	Wed,  9 Oct 2024 15:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZDEVa4PD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAD671FF7BC
	for <kvm@vger.kernel.org>; Wed,  9 Oct 2024 15:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728489000; cv=none; b=KvjHH2s/9BK6G+5al92oR9jHGQvJiKKbm3ID/1VT9C6FJE9i35wflMAkojjx8PU80rQWVljPXmdv6to5k2USaVoX95By64QCHS6FfdXUFfJuRppVczzocmFuOsRfj+hTPILWwE20pVfYkR88jTSZ3U/DPmI1Ei6SQib8E/nxLBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728489000; c=relaxed/simple;
	bh=LPFOToixC43DMJpxxdLhELluVDI5pW/ki1X7rgFZYA4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=O6IK7JrUlrFK0nnubwwEWMBKb1Rnsyx3fmPY+3sm14oQHyL4HDRBPjUX29+YgkKt9iLX2pUKDHfkxh8L81ldp7BsA9zmVTraaIYiTnC0PxckKCAO1u4Pqm1/fO+xLEkxCMxCwdqValMrDbfQur4Fep+OJ89SaxgU3uxp+j1KFZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZDEVa4PD; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-690404fd230so59396737b3.3
        for <kvm@vger.kernel.org>; Wed, 09 Oct 2024 08:49:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728488998; x=1729093798; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=+3zZkwU+2EpnRGguJhn2Ww+Ghmvy6uOMqwsBdHy8Row=;
        b=ZDEVa4PDOhQ1q/Q0LSGFJku8Btp1er6OCVG6vGwD+/yDBR6aZA8GPUOV3Vb10jIHvM
         7ok0cW2YCsnop9udUND3nhQjNn2vFzZfinkObODIfkztzLYczolMRha4Vw7+444EyiiC
         rOdmLaGO3uabbVEg98u9vyRSumhJ+YgscW6mfRG3l5Bh0NSQipcyDps4PAv9IaEX6B0L
         Jn5n5MdDIfIkEjsyirpaA2oGAF78rdWuvvIrG4qCAGVm8bcsuLXxDo16cWsMy+9JNie1
         JK73gvZOikKA5YsCekCCRo9SKVlEBEGju00xWZjS9QcDr6C0cmIT3wII/Y7AsKFpT/Zj
         fRqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728488998; x=1729093798;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+3zZkwU+2EpnRGguJhn2Ww+Ghmvy6uOMqwsBdHy8Row=;
        b=kezg4MAorPXKTJpRDyfo96uKRc4kEZGbK/n/yaUryKba4X33xR6B777+5fRQS60rw5
         L99r9J6MOK5P58vk8yTfYNVngAqrTe69ztka4JTj6vu8xI9atDB3kkiNcT5zfvYs+FI7
         pBsZ07CqDagHtxZAzinS7eOkC5LLazWxkedq1zCpFtdxtzGLQR2ZscTe8w4+iO0+FGwz
         ooLTuD7cyzGIwZ7CYt7Ekl8FvuL/YnK4uOP824xK7Mefvi+ZQD+PGizsdbEkWnika/yv
         dJV46hl2LV44GD593WcsKuiJ25W40+atq+olCyc7O/gLDCYCZefOL00vqZ1rAm7MC6sV
         en3g==
X-Forwarded-Encrypted: i=1; AJvYcCVtlvu6l5HLgJBmKZngYqYVans0aIlUHlUR6ixTnCMFab51hnnVpf+TBsRdo6h9o7GHK9g=@vger.kernel.org
X-Gm-Message-State: AOJu0YxQ60iyADDk8zlidw/ya0OeAOLbAZnX1rh13ESG8p/wKHIsCUZH
	fLonkCRiEG5+iQ9JwOfAwcqEe8KkTKacQej7uVzFqpPeCF/isHr4vgIx1v5ONwl5Vu4Ra2uaMjq
	R/A==
X-Google-Smtp-Source: AGHT+IGq8S+cJ3hbYyw4prFkdU6bbiVB3Ddo6czJU4p6VUDHrgM9P6PS5yQttOYl+xpjVaNBwpEpnchtMNk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:690c:460d:b0:6db:89f0:b897 with SMTP id
 00721157ae682-6e3221683d8mr69407b3.4.1728488997664; Wed, 09 Oct 2024 08:49:57
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  9 Oct 2024 08:49:40 -0700
In-Reply-To: <20241009154953.1073471-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241009154953.1073471-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc0.187.ge670bccf7e-goog
Message-ID: <20241009154953.1073471-2-seanjc@google.com>
Subject: [PATCH v3 01/14] KVM: Move KVM_REG_SIZE() definition to common uAPI header
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Paolo Bonzini <pbonzini@redhat.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Andrew Jones <ajones@ventanamicro.com>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

Define KVM_REG_SIZE() in the common kvm.h header, and delete the arm64 and
RISC-V versions.  As evidenced by the surrounding definitions, all aspects
of the register size encoding are generic, i.e. RISC-V should have moved
arm64's definition to common code instead of copy+pasting.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/include/uapi/asm/kvm.h | 3 ---
 arch/riscv/include/uapi/asm/kvm.h | 3 ---
 include/uapi/linux/kvm.h          | 4 ++++
 3 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 964df31da975..80b26134e59e 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -43,9 +43,6 @@
 #define KVM_COALESCED_MMIO_PAGE_OFFSET 1
 #define KVM_DIRTY_LOG_PAGE_OFFSET 64
 
-#define KVM_REG_SIZE(id)						\
-	(1U << (((id) & KVM_REG_SIZE_MASK) >> KVM_REG_SIZE_SHIFT))
-
 struct kvm_regs {
 	struct user_pt_regs regs;	/* sp = sp_el0 */
 
diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
index e97db3296456..4f8d0c04a47b 100644
--- a/arch/riscv/include/uapi/asm/kvm.h
+++ b/arch/riscv/include/uapi/asm/kvm.h
@@ -207,9 +207,6 @@ struct kvm_riscv_sbi_sta {
 #define KVM_RISCV_TIMER_STATE_OFF	0
 #define KVM_RISCV_TIMER_STATE_ON	1
 
-#define KVM_REG_SIZE(id)		\
-	(1U << (((id) & KVM_REG_SIZE_MASK) >> KVM_REG_SIZE_SHIFT))
-
 /* If you need to interpret the index values, here is the key: */
 #define KVM_REG_RISCV_TYPE_MASK		0x00000000FF000000
 #define KVM_REG_RISCV_TYPE_SHIFT	24
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 637efc055145..9deeb13e3e01 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1070,6 +1070,10 @@ struct kvm_dirty_tlb {
 
 #define KVM_REG_SIZE_SHIFT	52
 #define KVM_REG_SIZE_MASK	0x00f0000000000000ULL
+
+#define KVM_REG_SIZE(id)		\
+	(1U << (((id) & KVM_REG_SIZE_MASK) >> KVM_REG_SIZE_SHIFT))
+
 #define KVM_REG_SIZE_U8		0x0000000000000000ULL
 #define KVM_REG_SIZE_U16	0x0010000000000000ULL
 #define KVM_REG_SIZE_U32	0x0020000000000000ULL
-- 
2.47.0.rc0.187.ge670bccf7e-goog


