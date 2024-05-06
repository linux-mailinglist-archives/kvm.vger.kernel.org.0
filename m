Return-Path: <kvm+bounces-16714-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FD708BCBD1
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 12:19:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A44951F234B5
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 10:19:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DBD914388C;
	Mon,  6 May 2024 10:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jHFjbKxM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FC7E14387F;
	Mon,  6 May 2024 10:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714990719; cv=none; b=paulGUQMmSVHkGrI5oFWWmn/AnY1i91oaGTH/Tq1Sa5zTkp6t/vgLTIvO7ynuqZnuRE4zRtA/i7XBl4NOXFJVA/CvP49F2aOKIIrW6GwqvPjNl2UXzaGHcnQMhMPJPIY3x5zh7vgDBFP1c4tXTTOz/fyjQKkFw/QA9Se2czPcrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714990719; c=relaxed/simple;
	bh=hbWQ3Mur+/ECvEanbvX6901lMYP+yzm6OHJl+SocuvU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DBSUhcjPIb2beK0LaDhX5tR6lSSdF0RzWIxHEhbqh75aOfxc9mgBeu/iu3ZcSXD9uQwGUXbku3kuSXTkKN0IqSLTrYDAh1NV+qLt8YW9//rYsYEZ0DJ43Bqa9/2PyUU1wGY9asLWeF5C0ufu6yq2T7bhXHFc+iwTSlTI1/p7RGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jHFjbKxM; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-2b4a7671abaso1101449a91.0;
        Mon, 06 May 2024 03:18:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714990717; x=1715595517; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=31KekFIOIpF99+poRc8QNtBNYMF8yQuGd++gmF2U7xs=;
        b=jHFjbKxMaggi45CIZpdkMay8B8tVb3kc0DV/ZGWTK7L/BwtiS4Ks6Wp1+kNud6viaP
         Xvgufqme6x0n1eW9/mAA8jJq/Q01PEQbPTKNPyQPz0ToffhjjeMAZtVjRQI5ZflrI4P7
         8sTiZfttkc/3gGAPPnJIckuilD54Mjw953yY2EgkQI9QJXCORCJmkMwGu1RvY/nnosAk
         iNclr/HGDykZYQMlba9QLi3xuvabOSWaaP5jzwmFDt94j1aap6apYP4EEveCSVdrH4pk
         59oGWJNM7jHCHHPyxFP/sH24CEtqjC6UzS1Xsp239q03UUmFtlIYkq34lXes0KeXT+XN
         /bNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714990717; x=1715595517;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=31KekFIOIpF99+poRc8QNtBNYMF8yQuGd++gmF2U7xs=;
        b=IMDjC+H6HybqKdvmUhK7DHoj7EjOhMjRSImEOuhqMoC4ZrCsZrtPg6wMbCS+KUcp/H
         IUUJdew8cDabvQu0snxZpe4WLE5rBZmKmCsWM6wbBex5oNFB9aqABwCcCM6pnbsfXC8Y
         RuL5GAXdhssu+exM+k1IeDyeUXnNTVtoX9gu/G0FUzWF9YntPqiOsQIxKMIBaPVRkGUg
         xz+GyDigZCS1CS3i79sWztaqNYd3LsadM2R8Hyx7YaKgAoYw8gkXtMozXvdsg1e+x25Q
         uAdtogCYY8K8jnTejtdLDrZzTOc7zQ1jblncqSscx//3RfYx9toAE1a3vUTVLy/a0BGW
         +OPQ==
X-Forwarded-Encrypted: i=1; AJvYcCWXrQenckIrXNezrrNEwwvrvVHxrJ06jRvd5tyrVLKSsEuS9/7UVpXiyGbKlOn/zLly1KNWLC3hsimOtdOcIWHrci7roEYtf8Jsz57NKDEEWMnWGBd4Bxl7zG9nbHIQaYtp
X-Gm-Message-State: AOJu0Yw6OErzyzib/ALW+bWrbbVQWXAbkgBfQxOUSsqH/Z3qMaDN3Puu
	rKbodtp8TT6XuYq3QzM2ku877mZLyMAbOkIPaI6iw0GDUWq8fa0m
X-Google-Smtp-Source: AGHT+IHB3HRfjhiqL/tX1CDXXr1K19EOnmaHDdUrdFkmoVBi0L0LlA2/KoxLijSD5Hshni/CHzqqmQ==
X-Received: by 2002:a17:90a:a906:b0:2b3:df47:d743 with SMTP id i6-20020a17090aa90600b002b3df47d743mr8017623pjq.9.1714990717546;
        Mon, 06 May 2024 03:18:37 -0700 (PDT)
Received: from localhost.localdomain ([43.132.141.9])
        by smtp.gmail.com with ESMTPSA id co18-20020a17090afe9200b002af8f746f28sm9747820pjb.14.2024.05.06.03.18.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 May 2024 03:18:37 -0700 (PDT)
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
Subject: [v5 3/3] KVM: s390: don't setup dummy routing when KVM_CREATE_IRQCHIP
Date: Mon,  6 May 2024 18:17:51 +0800
Message-Id: <20240506101751.3145407-4-foxywang@tencent.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240506101751.3145407-1-foxywang@tencent.com>
References: <20240506101751.3145407-1-foxywang@tencent.com>
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
index 5147b943a864..ba7fd39bcbf4 100644
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


