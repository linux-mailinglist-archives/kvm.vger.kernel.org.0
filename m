Return-Path: <kvm+bounces-12359-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E318E88560C
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 09:51:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 20CF41C21008
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 08:51:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F98443AC1;
	Thu, 21 Mar 2024 08:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="LDZEiYRz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 558551B274
	for <kvm@vger.kernel.org>; Thu, 21 Mar 2024 08:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711011062; cv=none; b=NT6nuBC8Avv9ofMGQeS06F2rafsinonX0S5ysOyQu0Y1jmvn6RHzeyn/cVikOA+rCExY3PUsmzkulE6xzaOoAVuhyqwSJ+UplTxmKSMi9550DJQxUkrlun5oAfxTVHIJeMIItPUdlzIMnk/PflvUs4OQhP7ewSVZef+R7EB/Bmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711011062; c=relaxed/simple;
	bh=b0D5UA4UkNTQ3hrb1awYFHUtTZYLtdiN4O7EFOEvags=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W2aGBRSkgnzZozbgDIa9MkO+kG/XZDJpyQyqogZxj0WCZnmxjaIYiUnaJvX5ZuZCfueJRnOBJYPi/mgRc3tUNvTVp1/dhTq/PDVfYXAxlyH7HY15PvaTll88m/3l3C7JOQGw+4R3/n/Up8odO0VBqQJO60Dsuhvy14JhB6aRnqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=LDZEiYRz; arc=none smtp.client-ip=209.85.167.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-oi1-f176.google.com with SMTP id 5614622812f47-3c3acf4b0e1so232083b6e.0
        for <kvm@vger.kernel.org>; Thu, 21 Mar 2024 01:51:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1711011060; x=1711615860; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pb2DImA394Xn1GF25dwWbz9ebhgojzvFgrEv+j58JQY=;
        b=LDZEiYRzupwHf9CELWDC7TlZ2QtUQHw0qIvkW35avc9BQyKfqazv32MorD1fpgAYBc
         /nu+IvHj1GItxG8GXXF9D7PMIzuqwQC8phEON/0cxxRShKf/3yPxQFszywjqfsyZ+QsH
         aJZdLigMG7Dxp144TPTolkeLmmIm+VsPtk1zPl40RKRQJ2GIrHydB25g1vDEx6Bst8Ia
         LeEsFcJVTKzdVlNfEya/AtJws68++FzKE2OqOMnS8Zj6hsIWAApo+u/c5pBDpAN+reVU
         AgSQ54MAWQNAchrQM0U/sAR3OkUc86JRRhE4zXSTxDfjnZkBRyNSlx8O+tXVqtfLjKJ5
         azPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711011060; x=1711615860;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pb2DImA394Xn1GF25dwWbz9ebhgojzvFgrEv+j58JQY=;
        b=xODUeWLzFdVbUwKRWTCUY0OKyL2WDWnP7yiK7nn+IEmJnEpV8d9MM+/JSByL4Z7mm4
         vxUpHLNOJcqjunAxroJuFDc7nJIG/+jPkzQdaCJo3PidXFr3Iwa5DV3T5PEoE72M7BZO
         M1rr3W9wKtOXHKSp4KanFI+yqg3VjTKaKhzOspf/7ewlDLLLzGZYF5Q9Ho1HyHly0iDL
         aNTO7drygB4DQRIgYFF2Us7DLD5wydBRyxUQBG8CBbvV6yzHiHdzv3B1Y/SqCclZ16jc
         1R80xl+8X1vX5Ng5W05h6lva0GpE3Fqj0yPwja6ox5X33jNyk9tr8hnxKbhft06LuCMe
         DJiA==
X-Forwarded-Encrypted: i=1; AJvYcCXjtx/AzxM9JwPotoi/+8+RPEMWdMu6nhbaZO1Spe6zoDorG8qm5aq+JnY05ZhWFgonIG+zICPtRLPeDNRJM96P2JcV
X-Gm-Message-State: AOJu0YyZ38xJ8D42rNo9hbnqdFxGnY9iEQesSIFG5sfjeONVuZK6wdNn
	T8Iw3adXovxzlRaF2QOTiGkaRYDc9PB8aVT4FqtdlFsQZgGWUaFmR4h8JQ5riRY=
X-Google-Smtp-Source: AGHT+IFm6Yj6dZwM/TRCsKt+MMBPFQPRbWez6YSGqm2WUAe87j/A2qKzPB8fe5tq8WbjG6fC4RnUTA==
X-Received: by 2002:a05:6808:f90:b0:3c3:a696:c7e1 with SMTP id o16-20020a0568080f9000b003c3a696c7e1mr3806907oiw.3.1711011060344;
        Thu, 21 Mar 2024 01:51:00 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id x3-20020a544003000000b003c3753dd869sm2275409oie.58.2024.03.21.01.50.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Mar 2024 01:50:59 -0700 (PDT)
From: Anup Patel <apatel@ventanamicro.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Atish Patra <atishp@atishpatra.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Anup Patel <apatel@ventanamicro.com>,
	stable@vger.kernel.org
Subject: [PATCH 1/2] RISC-V: KVM: Fix APLIC setipnum_le/be write emulation
Date: Thu, 21 Mar 2024 14:20:40 +0530
Message-Id: <20240321085041.1955293-2-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240321085041.1955293-1-apatel@ventanamicro.com>
References: <20240321085041.1955293-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The writes to setipnum_le/be register for APLIC in MSI-mode have special
consideration for level-triggered interrupts as-per the section "4.9.2
Special consideration for level-sensitive interrupt sources" of the RISC-V
AIA specification.

Particularly, the below text from the RISC-V AIA specification defines
the behaviour of writes to setipnum_le/be register for level-triggered
interrupts:

"A second option is for the interrupt service routine to write the
APLIC’s source identity number for the interrupt to the domain’s
setipnum register just before exiting. This will cause the interrupt’s
pending bit to be set to one again if the source is still asserting
an interrupt, but not if the source is not asserting an interrupt."

Fix setipnum_le/be write emulation for in-kernel APLIC by implementing
the above behaviour in aplic_write_pending() function.

Cc: stable@vger.kernel.org
Fixes: 74967aa208e2 ("RISC-V: KVM: Add in-kernel emulation of AIA APLIC")
Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arch/riscv/kvm/aia_aplic.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/kvm/aia_aplic.c b/arch/riscv/kvm/aia_aplic.c
index 39e72aa016a4..5e842b92dc46 100644
--- a/arch/riscv/kvm/aia_aplic.c
+++ b/arch/riscv/kvm/aia_aplic.c
@@ -137,11 +137,21 @@ static void aplic_write_pending(struct aplic *aplic, u32 irq, bool pending)
 	raw_spin_lock_irqsave(&irqd->lock, flags);
 
 	sm = irqd->sourcecfg & APLIC_SOURCECFG_SM_MASK;
-	if (!pending &&
-	    ((sm == APLIC_SOURCECFG_SM_LEVEL_HIGH) ||
-	     (sm == APLIC_SOURCECFG_SM_LEVEL_LOW)))
+	if (sm == APLIC_SOURCECFG_SM_INACTIVE)
 		goto skip_write_pending;
 
+	if (sm == APLIC_SOURCECFG_SM_LEVEL_HIGH ||
+	    sm == APLIC_SOURCECFG_SM_LEVEL_LOW) {
+		if (!pending)
+			goto skip_write_pending;
+		if ((irqd->state & APLIC_IRQ_STATE_INPUT) &&
+		    sm == APLIC_SOURCECFG_SM_LEVEL_LOW)
+			goto skip_write_pending;
+		if (!(irqd->state & APLIC_IRQ_STATE_INPUT) &&
+		    sm == APLIC_SOURCECFG_SM_LEVEL_HIGH)
+			goto skip_write_pending;
+	}
+
 	if (pending)
 		irqd->state |= APLIC_IRQ_STATE_PENDING;
 	else
-- 
2.34.1


