Return-Path: <kvm+bounces-52652-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B919EB07BA5
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 19:00:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 87656504882
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 16:59:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66F732F6FB8;
	Wed, 16 Jul 2025 16:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Dqwz7Zj/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 537612F5C20;
	Wed, 16 Jul 2025 16:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752685181; cv=none; b=nCQXI8PTuLFCJjhm9DwJYhcwVHPnb4w3cgRiY7EmjNfrl8WOqiWSsD/vWhmvhNYzNQRjgfs7wJvL/kgD1P0eK5HLrb/q0ro5alp/w3M2L6kzM41xEsaOsWwgM892tfCLsdFjyvGHfUihtOGX3nSjg7MGNzPbZGEnu9JMdcuDivE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752685181; c=relaxed/simple;
	bh=jkQQvNZpPH/2J4kpelJXhxOtCO/DZFsC1y0v/zswi7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=axco5meBWmjMIfu0x8M3mXvDcdpnnOO29QENYmhyftXnQQH3A0o5OKXEURFth27I+V+EDBDURuoRQIOivy2gNEPmc2rYyVbMJuwU7h58UyHOOC+K+HXLECe3tgISe6MpQ0reBQrikbzlDn/UwXyM+4seMan8PatCYeSnyh7aFD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Dqwz7Zj/; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-23dea2e01e4so551725ad.1;
        Wed, 16 Jul 2025 09:59:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752685176; x=1753289976; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OiTrVurstj4F40PIZ+iGX0tIb5qeeGwqEUAH7aRWxJ4=;
        b=Dqwz7Zj/PGcteDu1CvpcRmp+erph4w1IY20N51MFjv7VmNow3fXZvQ9uD5MhodpgpK
         8bfxDl3WBcuYtWk8U8m4ygM1KJUSuNBkOcJiWijJ2nveB7X5lyMVLaBTTncYz+rjFu4j
         ZYS1D8x9q3qWl8r0rNC8YxOu+A+yv/GSjTquESE+S9e7oJxR4fQUfLqj5iN9xaJacaj3
         6UPIYt2OqUywNQnj17LjDf2beg55jg2xvMAzuZ4HcFByMJT0Oyuv51j5uqiDe3hitqFF
         ZDUCU48qIKdeVmEV1LOM7b+LWxmDz7x+L6qOFH1Ff8bNycv3CCXu4QhRBsDiu8RpZt0I
         Iqtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752685176; x=1753289976;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OiTrVurstj4F40PIZ+iGX0tIb5qeeGwqEUAH7aRWxJ4=;
        b=SOvlgCMqNSCp+r92Nku6wA6SyKA9o85sYLpCkJQdwVVq2/JCGSe5iJnHWE4VXhyEVw
         zFTUbs39kAxhbwappfsy1l4/cTFUSv9uGkUHDwo0aTBjmDsjypFTUFi+Y08N6Tk7ssxh
         HhKZfkeZiREuBR1pkNqV1bZDjdMI7Wpr7kpztWpGSbfIZ+fwg7PxR+T4vXrM3XBcjoV7
         N6K2eDeLwE8y3hVFdtzaYb3Vne8MzTfNbl82DxzHt9KjQ3YiijUX82eszh+IQQdugUue
         vOTPZgT/3N8IS2ikPL7qKdd2QZ351ORnxPqoRVoDNSxky0Jw3YCghzAOJIoIN/zYsEvb
         TxvA==
X-Forwarded-Encrypted: i=1; AJvYcCWgCR20WqvieGCrT8bNw3ID1QCCQ7mocdCXhof5XMRt7Ni6KwSMrRi8x1lsB7mCp4eQ0Hw=@vger.kernel.org, AJvYcCX3ckCvGSmyMbUrxXpA7+VCuVG27xGvPc2WeH567p8rKtF8LJvLPvcAZle7+eVKxzhNNlmhXgKUR+QpmqCf@vger.kernel.org
X-Gm-Message-State: AOJu0Yyd1eyWqQWn4ulPtQmm8wjZe5A7gt5zD5h4090DPVC019nOg9FX
	e3dKC1rRJBUc9n9cl973O8QuaCDkHPlmAfEdMLhfpqJiiYiTC0CQ+Z+q
X-Gm-Gg: ASbGncteBv7pZWH0IBltk9ygP2et85tq/augqq7vb3MjQz0V6dzyygwljelywzHBMFl
	4FWe2hKE2RqtRWSI2pEllD7tYO2+aOc9lF0Tcwdv4EnFywx8ik4irNX52g4Xaw8eeND8VBuQ/66
	yIzTayWomgWDOoUK3Iz05jgsdjAfPKy7jvpPBAEqiixSit4Rgh4RGKEzU650CIsHiPlxhNtf/d8
	VufXZnvCf2lTzZl0cAiVJYy88ww3iLu2jvEH8UO07T7tZUlvQPHxnK73p43m7AsgavnR7tG3sp/
	t7ZQEaIfAw8FiiwrjZ9cq237HLA1vjQ9Txoyvp6ZaSvC8wa89fIIQT62pO05POQtaAIKXNzUXiY
	CdCDg+KXd5JD0/xJ0FufQRFDwruM27vBn
X-Google-Smtp-Source: AGHT+IHDYGJSrqWvIYrXwA07rTPdrVHz0PpU4aL14ZgPQu+1ebjCr22oq2dQrQ5tz6hMocZpkjvvZA==
X-Received: by 2002:a17:902:ef08:b0:23d:d9ae:3b56 with SMTP id d9443c01a7336-23e256b7467mr54372765ad.22.1752685175538;
        Wed, 16 Jul 2025 09:59:35 -0700 (PDT)
Received: from localhost ([216.228.127.129])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23de432278csm132614785ad.121.2025.07.16.09.59.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jul 2025 09:59:35 -0700 (PDT)
From: Yury Norov <yury.norov@gmail.com>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Yury Norov <yury.norov@gmail.com>
Subject: [PATCH 1/2] LoongArch: KVM: rework kvm_send_pv_ipi()
Date: Wed, 16 Jul 2025 12:59:26 -0400
Message-ID: <20250716165929.22386-2-yury.norov@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250716165929.22386-1-yury.norov@gmail.com>
References: <20250716165929.22386-1-yury.norov@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Yury Norov (NVIDIA)" <yury.norov@gmail.com>

The function in fact traverses a "bitmap" stored in GPR regs A1 and A2,
but does it in a non-obvious way by creating a single-word bitmap twice.

This patch switches the function to create a single 2-word bitmap, and
also employs for_each_set_bit() macro, as it helps to drop most of
housekeeping code.

While there, convert the function to return void to not confuse readers
with unchecked result.

Signed-off-by: Yury Norov (NVIDIA) <yury.norov@gmail.com>
---
 arch/loongarch/kvm/exit.c | 31 ++++++++++++-------------------
 1 file changed, 12 insertions(+), 19 deletions(-)

diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
index fa52251b3bf1..359afa909cee 100644
--- a/arch/loongarch/kvm/exit.c
+++ b/arch/loongarch/kvm/exit.c
@@ -821,32 +821,25 @@ static int kvm_handle_lbt_disabled(struct kvm_vcpu *vcpu, int ecode)
 	return RESUME_GUEST;
 }
 
-static int kvm_send_pv_ipi(struct kvm_vcpu *vcpu)
+static void kvm_send_pv_ipi(struct kvm_vcpu *vcpu)
 {
-	unsigned int min, cpu, i;
-	unsigned long ipi_bitmap;
+	DECLARE_BITMAP(ipi_bitmap, BITS_PER_LONG * 2) = {
+		kvm_read_reg(vcpu, LOONGARCH_GPR_A1),
+		kvm_read_reg(vcpu, LOONGARCH_GPR_A2)
+	};
+	unsigned int min, cpu;
 	struct kvm_vcpu *dest;
 
 	min = kvm_read_reg(vcpu, LOONGARCH_GPR_A3);
-	for (i = 0; i < 2; i++, min += BITS_PER_LONG) {
-		ipi_bitmap = kvm_read_reg(vcpu, LOONGARCH_GPR_A1 + i);
-		if (!ipi_bitmap)
+	for_each_set_bit(cpu, ipi_bitmap, BITS_PER_LONG * 2) {
+		dest = kvm_get_vcpu_by_cpuid(vcpu->kvm, cpu + min);
+		if (!dest)
 			continue;
 
-		cpu = find_first_bit((void *)&ipi_bitmap, BITS_PER_LONG);
-		while (cpu < BITS_PER_LONG) {
-			dest = kvm_get_vcpu_by_cpuid(vcpu->kvm, cpu + min);
-			cpu = find_next_bit((void *)&ipi_bitmap, BITS_PER_LONG, cpu + 1);
-			if (!dest)
-				continue;
-
-			/* Send SWI0 to dest vcpu to emulate IPI interrupt */
-			kvm_queue_irq(dest, INT_SWI0);
-			kvm_vcpu_kick(dest);
-		}
+		/* Send SWI0 to dest vcpu to emulate IPI interrupt */
+		kvm_queue_irq(dest, INT_SWI0);
+		kvm_vcpu_kick(dest);
 	}
-
-	return 0;
 }
 
 /*
-- 
2.43.0


