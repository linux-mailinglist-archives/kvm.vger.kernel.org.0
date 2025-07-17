Return-Path: <kvm+bounces-52790-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 32EEBB094F1
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 21:25:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C78D1A646E8
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 19:24:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C10342FF494;
	Thu, 17 Jul 2025 19:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m9OUMATS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 781F62F7D0D;
	Thu, 17 Jul 2025 19:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752780275; cv=none; b=IvopsOMcXWX2JDjTZBc1Lolo94LahG5ttE8xBhltA2CvWUk02i/YKqVN5Wbr8L32a9CvDeQTPO78TaKmTMvF4iqk7UFDw1GFWh7pIZzZSB/hwbI66MNhdLtOhr6mPYTZy0RxQ7yUv0dI6TOxbBku6XUErV5JIrHOe0XUpIDciIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752780275; c=relaxed/simple;
	bh=yB7YWr7pdMNp0G6SU+5Ktnv13HebVm3m/nP6rxYHkoY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pdpT8SOx6P2+dI2Fc0Yt5EoXRFMzV0MAD0v67y1DKQPrfwXU6iK+6afv7DYE6nQAgLzlr073cETS6KvR3Zz+b1tWU2JHLXi7T5JTP04BgqUHFzaqgTA6Ra9w/tRzlizHIjNb0SUbwu+t4BX7f2CJ8HWrbojZMFbIe0d+VngR9so=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m9OUMATS; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-7494999de5cso1009893b3a.3;
        Thu, 17 Jul 2025 12:24:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752780272; x=1753385072; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B5uTmFEIku9lXr76P6a9yZMUm9o04d0GZ8Ab2OcDl1U=;
        b=m9OUMATSP7LFGIAcNPn5u4M8THv3vMOZeAmUjmULn4VTXQdYzhrFZ4gXnbpa/7Ae9k
         yiXAZXahA8O5dNWOD63RZvLUoTwbeDtNaDIsAcGEQyVc21ghVtiHJuu9T9axtCI8QFUL
         ZxbXqYWRrvq1e231OAKkcnHJYGKkHOd2Dra4B/0cIoyVK+4yaur4of9pvFy27hiSy8A1
         A41RBclqtIAA3IH/PogzUoSUdrpSlvRspU2nUZx39hF85fbdjJiPi2iBSNk/5Td/roHc
         kfcqp4K6qe1lyqzrHGOEKAvdUI1TiG8vTAwdp2HCv2YFV/wqK1dvi/gWKGgWwinD3R0I
         VKuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752780272; x=1753385072;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B5uTmFEIku9lXr76P6a9yZMUm9o04d0GZ8Ab2OcDl1U=;
        b=hZ3AAyaiyen/s2c12cvIJN22WKFuw/SNQnRk2LH5LYVIBJMC0xVQ3/aGWyPO/hcJ1H
         Fk2XPhdVMWXLrjO0XI1D2D16JQFpVitwAuqvMHMwpUdNv4yKGN/Le5ww2pzJ5QNtBDlY
         bfXG/ZVMaMH9WcfXWDB3m+xl88hHOhtoxFaeeUKOzIM4ZGjAuHEzagvrjgy8lWHIaiY1
         J5qAOhpSe0E1jKHwBtRJBDjJ55Il9mlZSR9RQbVlVShvm2tQZ1BS54ThPDL+kNPLeWDv
         hvMHB+0qGFP+VNlvUsfdswG3r1j4YR6lDTI9XWJe3OuYtvP1SflwBIIh6TmQmpLJkUAW
         AwqQ==
X-Forwarded-Encrypted: i=1; AJvYcCUKUByAFkbtxoL5W9q6G2BmIxd86sWPNQPUHGbLrcIF6IxaEKKqNUj0QaXHyx9pcemmVTsEmv6/Ioay6pU9@vger.kernel.org, AJvYcCUuW7XR9JWg8PVSoRIfPLoy83zi71bahZFC7LSZZGYsPN1ke9FpZghIZDQO8uALVEhaqK4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzNCCg0XB2Z0ogWXez/elE2EFk8ngy9xp3t2Tu1aWv0cQNwJPl4
	K4yLxDRG+r+7lZYWijXLE313mB/t6HNkIt1w62O+Z1ahwB2HobGDuNBwMLUh1Q==
X-Gm-Gg: ASbGncvEC+oKmMk9pxli72E85bIFIo8Do0iV/4jj21/37CIXXqDBlzte+tqA4d3onqL
	k6NI9g8DZBM50AP3lgOjFMjz+pht4RMWKSYy4OW7e9uP2Z++/aH09tGCYtLU0yRgSQqkse+725R
	7CX6maHCHxez5X/AUMYGjCbrp250oLxpFYaJ4lXSBHO88717n75JlsuQ3n9Pt9oCnl5pECo97dG
	pOIBs9xMelMNiTCxsuJGxVi0aRBXdXqgkorNFglOvb+QVs7Af6KyWee3HMamMeUiVeg1kyss4YV
	Ob8aTxLLRTVlVduKFWKrWYDCDN0waN+L9urROCKCIP4QTiZOCj1YjcqbM9yIPWpGlV5omr+uDGf
	07CdbRKjC7UEV9khjDjicIsIo15r5cmZI
X-Google-Smtp-Source: AGHT+IEBo+NVswoO51+I72a+W29MTI+M02gMC09GnAX4WkT6HvCuJoBwWEupRLOBtpw+ol59pKkWPg==
X-Received: by 2002:a05:6a00:3c8e:b0:748:2e7b:3308 with SMTP id d2e1a72fcca58-756e8773a2amr11825884b3a.6.1752780271538;
        Thu, 17 Jul 2025 12:24:31 -0700 (PDT)
Received: from localhost ([216.228.127.129])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b3f2ff87dcfsm16634a12.51.2025.07.17.12.24.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jul 2025 12:24:31 -0700 (PDT)
From: Yury Norov <yury.norov@gmail.com>
To: Madhavan Srinivasan <maddy@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Yury Norov <yury.norov@gmail.com>
Subject: [PATCH 2/3] KVM: PPC: simplify kvmppc_core_check_exceptions()
Date: Thu, 17 Jul 2025 15:24:15 -0400
Message-ID: <20250717192418.207114-3-yury.norov@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250717192418.207114-1-yury.norov@gmail.com>
References: <20250717192418.207114-1-yury.norov@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yury Norov (NVIDIA) <yury.norov@gmail.com>

The function opencodes for_each_set_bit() macro.

Signed-off-by: Yury Norov (NVIDIA) <yury.norov@gmail.com>
---
 arch/powerpc/kvm/booke.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/arch/powerpc/kvm/booke.c b/arch/powerpc/kvm/booke.c
index 3401b96be475..1fe2592c2022 100644
--- a/arch/powerpc/kvm/booke.c
+++ b/arch/powerpc/kvm/booke.c
@@ -692,16 +692,10 @@ static void kvmppc_core_check_exceptions(struct kvm_vcpu *vcpu)
 	unsigned long *pending = &vcpu->arch.pending_exceptions;
 	unsigned int priority;
 
-	priority = __ffs(*pending);
-	while (priority < BOOKE_IRQPRIO_MAX) {
+	for_each_set_bit(priority, pending, BOOKE_IRQPRIO_MAX)
 		if (kvmppc_booke_irqprio_deliver(vcpu, priority))
 			break;
 
-		priority = find_next_bit(pending,
-		                         BITS_PER_BYTE * sizeof(*pending),
-		                         priority + 1);
-	}
-
 	/* Tell the guest about our interrupt status */
 	vcpu->arch.shared->int_pending = !!*pending;
 }
-- 
2.43.0


