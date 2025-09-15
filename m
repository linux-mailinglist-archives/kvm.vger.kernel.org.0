Return-Path: <kvm+bounces-57508-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 916A9B56FBE
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 07:34:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2A5A6189BAED
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 05:35:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5344F2741C6;
	Mon, 15 Sep 2025 05:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="QEgbWh2S"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE6D24207F
	for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 05:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757914475; cv=none; b=pUnWFEiuiZH8ffJS/VYCtziHwSjqKZgcLjUfIngt1OqZ4RjRE230C5PPfxIaxAVWaM72zPX4FrjJD0RgITGi/6xDG2/CnkQi9DD5gAsyDjdvj+O4EmC1JCz1vjkhk7BvF3A7tapLpQXDA9mt0lcpqdSfLh2d2zB99Xl5seYUE1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757914475; c=relaxed/simple;
	bh=1MJFzf4pGz8DgaKAs7CKJL+eWNPRE7XZdof1TjvBwFw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MeAmSW/X48EnCr6ikgAdBHjXJz+6p9ivzRzTQq889Qive8TNivuCf2/+c5pJrJgfVlzwjRdGQuHRI1nBZQZhXDWqH/Lq8J2KfmsJhUcHPGKfvbvan+i3IcN8S+fO4TywAEZqo9z8xOr2T2FWPMovvE8CSFgBar2GAURjB3rLK30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=QEgbWh2S; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-7726c7ff7e5so2995978b3a.3
        for <kvm@vger.kernel.org>; Sun, 14 Sep 2025 22:34:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1757914473; x=1758519273; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=HcWOum1mNBViAIuGhSYHqBX6ni4rWoPSQnGJMRFhyRI=;
        b=QEgbWh2SGvLVQ6+bLS6V0L28fPmCVKNNK/2Td7dLtaGbjDpmryKsaGt7kFbgvyyOSf
         sA8XlWQrfscz7Zzniatf0LNv51nj6bjLy69KFwvL2WqhuSJeZyqYPPrvCAfv3KKFC9lG
         1WEcugjX3/OAsT14fzov+ZNdoa7b0nHSdXmOfGWfVdmmczTNAWwsiIIbZdalqfJwZNPs
         Vo3GRr7uWWzk/Yh4eaqLAHHKjBaeAWMtid0YbLSjJA0p03BZolej73suIWPFdydDpenz
         fLS4hQUoW+enX77HgWGjBvDxJm9QwnTbwldMyO+9K6CYV+myFDusNtWaPa3dgC7n6yDA
         8Daw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757914473; x=1758519273;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HcWOum1mNBViAIuGhSYHqBX6ni4rWoPSQnGJMRFhyRI=;
        b=xPHJB5NXoJPe+Pwg39saX6am3uvOghvWiK83+OWMqgUzSI2ms/Qj85kc+z3YXeyi2k
         kKWxMppa5RPFV1vOV8TKClDUMvIvc0FFnovnOdoIt79p7RA76S833yiCW94Uo+A+dzsB
         dyFXzYnnAPzltb12ehTOLI8HXJrN/bAFmjy83Igkqfl8CAGDtO1gpX8Sh1J4g5MF1mMG
         ocA48QhO6JzayHNS+KpsC4BDO7cq6+ZZwubfB8+pODtIu9TvxulfT0OGmQyz2NGutN1P
         CcqnapqZvPspWTihQZY+6lZDnxG+WdgokDLRcwoeFS2dpj/X7tBYczv8QAvey1v2LVOu
         ZZDQ==
X-Forwarded-Encrypted: i=1; AJvYcCWgIa4M8YeJO1f6ufKdloefR29dcf7zIDYgR5V9k3FuFgatBtCAJKMOfxuuiTWsObqj3Bw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzO/K0NZKt2NyXgf1VsGZl5AB9THdzKPCHWT4mq6ukcewE3n63c
	ycHGd2BZH7d7gL71dqTzt6Bi1K0kvVGnfEfoLBXft7GJ6hfrM51aDRmjkoLSnUaMoOE=
X-Gm-Gg: ASbGncugoe0o0BacU+zHoQkqThtH/SmSSYBbMV8cQTF93H1GYoURI8D0IzarCHtfJ1Y
	sqynLSCK45hVciwjw0CO88YT5A9DqOKKEDH//Pw0okbRAUaOfxlHdjni/eAbIZH3++IpXiDmAAa
	x5nhzQahHzIWy5NNPPW+MST7RtntR9hiMlusH7gySSrb1zvjP7b9dGxupNPK+GkrW1rqkIKCmKQ
	ln1rOzEzRDQ4EtTEU9prkgL2CO7AAqm4dxLeJnVDooC45FZI9OQtrBsDz2lJI+QSPpOK1lbnUv6
	ndCtlW3cZ9Yy9nfJg4EEIx/4nndSSQV7phmaaZKa+rdJhB3LVGH1yNdmhHQo/rLQ/FudF/iaZAL
	BUmk9mgDAUmZd9ZsXUioGY9cNtxijhKM1eNUyKwrT3Pm/+ytG8FozUlY=
X-Google-Smtp-Source: AGHT+IGjRSvNn9pjamHg0axHO24KuBYdd0ejvKhVmAXCjHWpKLeck8mQqMrFQreoUO1LGLwUqHHLQg==
X-Received: by 2002:a05:6a21:999a:b0:262:d265:a3c with SMTP id adf61e73a8af0-262d2650de3mr5504416637.32.1757914473069;
        Sun, 14 Sep 2025 22:34:33 -0700 (PDT)
Received: from sw06.internal.sifive.com ([4.53.31.132])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b54a387cc21sm10604151a12.28.2025.09.14.22.34.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Sep 2025 22:34:32 -0700 (PDT)
From: Samuel Holland <samuel.holland@sifive.com>
To: Anup Patel <anup@brainfault.org>,
	Atish Patra <atish.patra@linux.dev>,
	kvm-riscv@lists.infradead.org
Cc: Samuel Holland <samuel.holland@sifive.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org
Subject: [PATCH] RISC-V: KVM: Fix SBI_FWFT_POINTER_MASKING_PMLEN algorithm
Date: Sun, 14 Sep 2025 22:34:20 -0700
Message-ID: <20250915053431.1910941-1-samuel.holland@sifive.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The implementation of SBI_FWFT_POINTER_MASKING_PMLEN from commit
aa04d131b88b ("RISC-V: KVM: Add support for SBI_FWFT_POINTER_MASKING_PMLEN")
was based on a draft of the SBI 3.0 specification, and is not compliant
with the ratified version.

Update the algorithm to be compliant. Specifically, do not fall back to
a pointer masking mode with a larger PMLEN if the mode with the
requested PMLEN is unsupported by the hardware.

Fixes: aa04d131b88b ("RISC-V: KVM: Add support for SBI_FWFT_POINTER_MASKING_PMLEN")
Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
---
I saw that the RFC version of this patch already made it into
riscv_kvm_queue, but it needs an update for ratified SBI 3.0. Feel free
to squash this into the original commit, or I can send a replacement v2
patch if you prefer.

 arch/riscv/kvm/vcpu_sbi_fwft.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/arch/riscv/kvm/vcpu_sbi_fwft.c b/arch/riscv/kvm/vcpu_sbi_fwft.c
index cacb3d4410a54..62cc9c3d57599 100644
--- a/arch/riscv/kvm/vcpu_sbi_fwft.c
+++ b/arch/riscv/kvm/vcpu_sbi_fwft.c
@@ -160,14 +160,23 @@ static long kvm_sbi_fwft_set_pointer_masking_pmlen(struct kvm_vcpu *vcpu,
 	struct kvm_sbi_fwft *fwft = vcpu_to_fwft(vcpu);
 	unsigned long pmm;
 
-	if (value == 0)
+	switch (value) {
+	case 0:
 		pmm = ENVCFG_PMM_PMLEN_0;
-	else if (value <= 7 && fwft->have_vs_pmlen_7)
+		break;
+	case 7:
+		if (!fwft->have_vs_pmlen_7)
+			return SBI_ERR_INVALID_PARAM;
 		pmm = ENVCFG_PMM_PMLEN_7;
-	else if (value <= 16 && fwft->have_vs_pmlen_16)
+		break;
+	case 16:
+		if (!fwft->have_vs_pmlen_16)
+			return SBI_ERR_INVALID_PARAM;
 		pmm = ENVCFG_PMM_PMLEN_16;
-	else
+		break;
+	default:
 		return SBI_ERR_INVALID_PARAM;
+	}
 
 	vcpu->arch.cfg.henvcfg &= ~ENVCFG_PMM;
 	vcpu->arch.cfg.henvcfg |= pmm;
-- 
2.47.2

base-commit: 7835b892d1d9f52fb61537757aa446fb44984215
branch: up/kvm-fwft-pmlen

