Return-Path: <kvm+bounces-6486-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A3DA0835576
	for <lists+kvm@lfdr.de>; Sun, 21 Jan 2024 12:19:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 64B571F21305
	for <lists+kvm@lfdr.de>; Sun, 21 Jan 2024 11:19:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACDCB376ED;
	Sun, 21 Jan 2024 11:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y7MrYIL+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 982B4376EB;
	Sun, 21 Jan 2024 11:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705835900; cv=none; b=NIl1LpaMVo7kkskxUmBplV/FTsnIEfEpSvJi7oOV5ySbM2yYOONeIKd+pA3FxPRRCu/n40DPiKKN9n397e5yyamQheihFh8V/8ILwrZuwiY5LKKInT6LDIBJOK9Fnf54e4nF1lTCnrrKGfxlXZe31wkgYk+5CfW972oH90UZxEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705835900; c=relaxed/simple;
	bh=gCwwOCvdRTjNsD0Ug+Mg8exzg6pEXSQTPaw+RFMIkqE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JIhopt/nQscoYuAowj1zhAnvUBS+NdESq4dqaK4aDtPYo8AVPs/n8XvPH1zpGTjvv+gyNixTJOPl6RxIRDtdnlyD0r3mCk+hqIVN8LcC4w8rTP6Z3uk2Qpe/NJuZ7hKGOhIYc12dhQVmAWCq4s1mA4R86QVd3UggT8UdPwScrVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y7MrYIL+; arc=none smtp.client-ip=209.85.167.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-3bbb4806f67so2130853b6e.3;
        Sun, 21 Jan 2024 03:18:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705835898; x=1706440698; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o0+D8VJJjP7sruiyX0aFvlAPwpXNG4bVj6IYLPMTV3g=;
        b=Y7MrYIL+uE5OPvOAtnCc0EbRqCuuTlkonnyMd5ce6xBKL3KpkYrq4nkeUWmOJDW66j
         CMKs23rrEqcJDMRtxIAHnbIjC2SfYj9YGVgSRERW/40aXVqTTL31ibeEyOiAQ86fatJt
         Si8J2gw5fCxieRX/YLnsKX7g3WJchXxl5x/CN/wqOgGfoaNeOscdNJfJ1+i66TTAZJB0
         TdkPFwQxbPjBS91So73XuMQ32Z2tR5wXnRGRBiqzg4lv2UeyoAmxskKo7HiPYmVG8NX5
         2Ua/XX7nOZqxJolNO7mDGzZdNBODvUfFosP/3GcOWlNT18w+6YaTCydUh1JEKSzO0bnk
         Dq7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705835898; x=1706440698;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o0+D8VJJjP7sruiyX0aFvlAPwpXNG4bVj6IYLPMTV3g=;
        b=cQ9cViUYxS0/sigWy3QCAh+lAyCuTxZZY7edmK8TWrek50DyKQTj7c0AMJlaiGv/s5
         YQuX+Y+wlGlIsUkzljchyTJqItJGlzS2Z5fmyDJQlj8Ajtds/vaWaG4XquyoWZgXOL40
         NMD8nKU2RtnhEmA9tixW6ULSDhG8NxVTNnnd3MAf3u76R0GtoNxb++xz1ezMKl1f96ix
         JRFfUvUmZ0X8ZQmS7Cwf5gT1TLqrMI89IzqrM+kwanHuZsTIAQS0jtSwbnXwULvN3/ZK
         iHKnbWmDcEpHEEIBeIi/E6Qo2UMtEBM81GK4F/NdiDVhrKuzAh74JoOh9ksI6BMKqnlh
         4z8w==
X-Gm-Message-State: AOJu0Yw2+El4eOazcFwwxyGV7pPUmA3YV5iR0ZhLCgloAQ1OKYlFqlt5
	mhDqGxmxuaSqT34nZ1HJw/FEpjK+sFUWZweXzOAgMtHsDwFVXLtT
X-Google-Smtp-Source: AGHT+IGsg1f4eNGBuVxKY3lR304+ES9Y1D0iBR+xTu9dzIpuIXozCjwPZUQBpbLm55SbCFHFdt9C+Q==
X-Received: by 2002:a05:6808:130d:b0:3bd:68be:407c with SMTP id y13-20020a056808130d00b003bd68be407cmr3595108oiv.46.1705835898677;
        Sun, 21 Jan 2024 03:18:18 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.9])
        by smtp.gmail.com with ESMTPSA id jc9-20020a17090325c900b001d7233f1a92sm3560255plb.221.2024.01.21.03.18.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Jan 2024 03:18:18 -0800 (PST)
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
	imbrenda@linux.ibm.com
Cc: up2wing@gmail.com
Subject: [v2 4/4] KVM: s390: don't setup dummy routing when KVM_CREATE_IRQCHIP
Date: Sun, 21 Jan 2024 19:17:30 +0800
Message-Id: <20240121111730.262429-5-foxywang@tencent.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240121111730.262429-1-foxywang@tencent.com>
References: <20240121111730.262429-1-foxywang@tencent.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As we have setup empty irq routing in kvm_create_vm(), there's
no need to setup dummy routing when KVM_CREATE_IRQCHIP.

Signed-off-by: Yi Wang <foxywang@tencent.com>
---
 arch/s390/kvm/kvm-s390.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index acc81ca6492e..7c836c973b75 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2999,14 +2999,11 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
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
+		/*
+		 * As we have set up empty routing, there is no need to
+		 * setup dummy routing here.
+		 */
+		r = 0;
 		break;
 	}
 	case KVM_SET_DEVICE_ATTR: {
-- 
2.39.3


