Return-Path: <kvm+bounces-6830-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CC89F83A803
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 12:36:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 82F6F1F2352D
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 11:36:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AD952C6A0;
	Wed, 24 Jan 2024 11:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h8cWIliy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0D442C689;
	Wed, 24 Jan 2024 11:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706096121; cv=none; b=BCVlgDj7e4oJXtd6Vs3h4DkCbgtXfz7pqoAJ4M+EJ7lrCP9rC5KwF5OWEvS1RxS37vcQ2xbOsgW35XkJAiGVV9Qv/PvNO5QsZb+1u4nkVDCyvjb8Q8pSoyue0ZXAkf0JgN6IsHdUa9qZ+9Jv1a/Ox996c8vlPEc0JGJpr06pBF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706096121; c=relaxed/simple;
	bh=RW46AqXVXgdtflxt/tkQwZU7j0j/bAs5uWwQ7lFOUZk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LOaWMQyWWe7oTx5TKw8SiYd/Xm61rSdrNeoNGpvU+EeDhNzVWLIVS4LcTrMoenCSpri550wVG4Fby6s1WXbX3Ax/xcqDfcLLChdhZnHnGdJTCjEqFsfVCd1jrfGIwjqFU53xTkoAOkNJtN+NcSvvaxh8bbvRNfwiU8L5ZbulTBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h8cWIliy; arc=none smtp.client-ip=209.85.160.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-2148e793e12so1029551fac.1;
        Wed, 24 Jan 2024 03:35:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706096119; x=1706700919; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8UmsTcmfc8pcbPs6rRpAkpag+IwA6bQ9uQr+vxsTK1Q=;
        b=h8cWIliyHpkcopGan7yha/HSFel/Peei8kr0PXMtTagEbV2949Gu9tjm+RKLxyHVuP
         kUH4OlfwiXEBEIiM/2j3pO7adKFH2jnO65pMDdEo7vy6vpayZrgiK42rZM8ukPonpggU
         B2vQPyYyhZW/jMGvwBhpP7oFGgHDF7AlmNq1rMZPxk/Hj/DkAPckddQMmTMPU4jqZ2We
         iXqJ9EIhUsf3OKmxEtuBVNkBIMFuyyppQmbqWVb0wegy04q1I7XZYnl+fWMDyGbCfrxd
         ++WWC9hjECgKHTeRtgHXmHBgC5fD5OKzOElEh+URibx840lFiwQEHcCn5+uB8+taK4P8
         S+jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706096119; x=1706700919;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8UmsTcmfc8pcbPs6rRpAkpag+IwA6bQ9uQr+vxsTK1Q=;
        b=s6U4SUOsl6H1N51df6Npep15ZYA2gtEp8j+Bw9h4/DCavJ+3V4soHfa7JbWExX1vrv
         H7UoZVsG8r0dsKYZSmrXuePDaqDyAjW72ZHYp03Jv2fKyQPuxIueU8R/CIfjmgl/1H2s
         wjP13/hX7UJ9jWViGfhCjpU69dpsXCaZ+dfGr2g1N0cK+e4NT8oVlliMyVhrbm4e/mtH
         XmG60okmY4JHAZyXwQGhKqukYQx053/HelX587Lp7nWw5Mzf6ghoOtxR7q/3j7iXgeOu
         faAMpmLwzF7Xx0ZxDkwMUkTS4RMLcPOiFe4R0PF2DtWnN9isgV4JjeoJBkpKdcrQqq9k
         UZ5A==
X-Gm-Message-State: AOJu0YwyktjMBxqdhmxz0E08fcSwgM0QXpjkjKoeuk8fhe59xRyhHF61
	5Xj2RjKvbiAjX5WuLxBloipGywFEYJcSpp90b0JqgJ+8wgQ/jFlN
X-Google-Smtp-Source: AGHT+IHFSZ4s7KNHUdwSzt9UuvcmiZa9gk9u/RzQP7n/d8l0ivf24HCuX8/5YDYLpIePfxpC0YTbsQ==
X-Received: by 2002:a05:6870:1603:b0:1fb:d89:48c3 with SMTP id b3-20020a056870160300b001fb0d8948c3mr3178545oae.27.1706096119122;
        Wed, 24 Jan 2024 03:35:19 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.3])
        by smtp.gmail.com with ESMTPSA id c15-20020a63d50f000000b00578b8fab907sm11727820pgg.73.2024.01.24.03.35.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jan 2024 03:35:18 -0800 (PST)
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
Subject: [v3 3/3] KVM: s390: don't setup dummy routing when KVM_CREATE_IRQCHIP
Date: Wed, 24 Jan 2024 19:34:46 +0800
Message-Id: <20240124113446.2977003-4-foxywang@tencent.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240124113446.2977003-1-foxywang@tencent.com>
References: <20240124113446.2977003-1-foxywang@tencent.com>
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
index acc81ca6492e..dec3c026a6c1 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2999,14 +2999,7 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
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


