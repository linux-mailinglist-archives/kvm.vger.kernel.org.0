Return-Path: <kvm+bounces-11534-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 23A09877F09
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 12:33:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CCC791F21B22
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 11:33:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 486B03F9DB;
	Mon, 11 Mar 2024 11:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Irkchh69"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 323433E489;
	Mon, 11 Mar 2024 11:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710156757; cv=none; b=TDhKU9knKAZ1X+BMLktIIdClAf/0QS4GkCHedpUmh9R3RjF4rZflNlpDZhJTYy7TaoL6wMu7XcIxq0s/ONN5SmhG5pEv1XUDoiXeXGa2fY7Mrzya6cKWuCQa3UC12jyxT2THsJU6fOxojfnycpY2oyXGc7SOppoCPSV7GOgPPyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710156757; c=relaxed/simple;
	bh=Pm9fgg10INqcVP31XjiLnyYiAadmNohLqFay8QoaN2g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=R7a0kWHS1hIcIEm+FBEbF7CxMD1uFLghhtdvqbiN8wRrlYH/cm7oji36KAxqM09WuYLbBCqUEJKfVNJSj8I3WQ+ajIA4L47py1uCUMuZkDoK6zJH39X9Vv96hqIsPJK+Fi0WpSt+2DWJJ1pMelVC60csDE8M8wUEmzXuSZyK8qQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Irkchh69; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1dd9066b7c3so5785815ad.2;
        Mon, 11 Mar 2024 04:32:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710156755; x=1710761555; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UZMo8iXTpNcCAjKRxwY/f9W48ELll8VlcsLxbAKJZ68=;
        b=Irkchh698ivwXlbzcsLZ8F6wvb04/lc3bh270ysxcU6IsoGhqisWNs9SJIXQ1Hv6T/
         ZkVmeKwJhPdtVKUt7smVTXugizgDTAQ6kk9EHcd9TMSgbSnm8Uwg4GuRyK0HvDgZH9iU
         qFUPHeWSO/djWlmL+9+zZHbqJPs7lq4+lZO2u1UP6OZM/avXfYlpOiyGvm7kBFeiXPUo
         gCSUacZtEnaws7pDEkK/o36Ks+agRhexKBuizqJkBP3+a0yLO7/rccTuKQY6dGElV5PM
         kdvr9xSo2Gb4yGjl2jI4m4g2yxLphWSXGrX09Qowpjd47LlG7XTfrPbwnlA31CEFfSJr
         c0qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710156755; x=1710761555;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UZMo8iXTpNcCAjKRxwY/f9W48ELll8VlcsLxbAKJZ68=;
        b=MbOokLGkPF3M1nWb6aFETFQ+OkSG3RQKLFBxRMADoyMWL9ChicyDIwfungIxEOFt8I
         Iyn6yAu5oIffCMmR7h5PYc1n2lL2krrXOh1c8FJPdKM8WzGmLDESeoC7XNgEgYmxub1J
         49vyZHezLn3SfXXafA76y/g1m3pemdnGtfbILqYQD8sQCJjL9dWkQFqYvrU21JoL7CBU
         U0AlNAeJceC/Zk/O6SxKF1E6ANBlr7zfwFF4Jk/oC3k3nAaLBUQcfyhFnsdKGZ8wBd5y
         6ANn6/VobdWuBrm1rHdAR/BKB/Osdb966ciZP34UeouPi1KBN8Os6wOLuGYHbPCeKpMO
         kPig==
X-Forwarded-Encrypted: i=1; AJvYcCVSh0u4qje5A16zP9dU5tgzP6H9Sml1aH8tBuMtorVfwlsGcKz/dbyN0HgdQAYBHxXoxz7vl+pT5hpXDIeUBwoA2PZGtfRQ0be+HebaKQyPGK4PSnT0xpPm7AkxEUc+aL1i
X-Gm-Message-State: AOJu0YwAMhKrSKtxD0vyLWhSLisEff1RA3sK0X/PZO1gNU3KZhGULhOh
	jj5Ynwck+lWvi1UUPUNyaLW9atdvUBiUjbGaHq19llQitzhQyDUA
X-Google-Smtp-Source: AGHT+IEqmFHYo8EoRXHHxyuvsF6KgvDj4eyjaY/d+Lb9Z2qdgBVCfqUvoppumJ4/xHBpbXU4xF2jJw==
X-Received: by 2002:a17:903:584:b0:1dd:93a4:3d28 with SMTP id jv4-20020a170903058400b001dd93a43d28mr118657plb.35.1710156755393;
        Mon, 11 Mar 2024 04:32:35 -0700 (PDT)
Received: from localhost.localdomain ([43.132.141.8])
        by smtp.gmail.com with ESMTPSA id u3-20020a170902e5c300b001dda32430b3sm1459042plf.89.2024.03.11.04.32.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Mar 2024 04:32:35 -0700 (PDT)
From: Yi Wang <up2wing@gmail.com>
X-Google-Original-From: Yi Wang <foxywang@tencent.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	wanpengli@tencent.com,
	foxywang@tencent.com,
	oliver.upton@linux.dev,
	maz@kernel.org,
	anup@brainfault.org,
	atishp@atishpatra.org,
	borntraeger@linux.ibm.com,
	frankja@linux.ibm.com,
	imbrenda@linux.ibm.com,
	weijiang.yang@intel.com
Cc: up2wing@gmail.com
Subject: [v4 3/3] KVM: s390: don't setup dummy routing when KVM_CREATE_IRQCHIP
Date: Mon, 11 Mar 2024 19:31:46 +0800
Message-Id: <20240311113146.997631-4-foxywang@tencent.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240311113146.997631-1-foxywang@tencent.com>
References: <20240311113146.997631-1-foxywang@tencent.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yi Wang <foxywang@tencent.com>

As we have setup empty irq routing in kvm_create_vm(), there's
no need to setup dummy routing when KVM_CREATE_IRQCHIP.

Signed-off-by: Yi Wang <foxywang@tencent.com>
---
 arch/s390/kvm/kvm-s390.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index ea63ac769889..78a1e2d801ba 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2998,14 +2998,7 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
 		break;
 	}
 	case KVM_CREATE_IRQCHIP: {
-		struct kvm_irq_routing_entry routing;
-
-		r = -EINVAL;
-		if (kvm->arch.use_irqchip) {
-			/* Set up dummy routing. */
-			memset(&routing, 0, sizeof(routing));
-			r = kvm_set_irq_routing(kvm, &routing, 0, 0);
-		}
+		r = 0;
 		break;
 	}
 	case KVM_SET_DEVICE_ATTR: {
-- 
2.39.3


