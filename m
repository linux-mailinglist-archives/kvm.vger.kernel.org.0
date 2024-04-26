Return-Path: <kvm+bounces-16018-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 022C88B2F62
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 06:17:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 959931F21020
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 04:17:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B8D584A4E;
	Fri, 26 Apr 2024 04:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fh6Ntgu0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1888683CBA;
	Fri, 26 Apr 2024 04:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714105004; cv=none; b=aMEpjfT/jEYryWhsye9F5VOKbAGi1nnsC+7xm/b020g35Zmi/et5/yzd0/GolzbOWttH4dmmiLY+3vTY8Kwb00UoAWbTp80yGktkSEI4SA8NJQ0/6dADtHWO+jQYohfMtxPwJVJyEDe9om9K+mkf1ytRi+p6xDlcGWiRFht9ucY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714105004; c=relaxed/simple;
	bh=hbWQ3Mur+/ECvEanbvX6901lMYP+yzm6OHJl+SocuvU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=R0NR49qkNjVvbolw2RLBj1LIntp+CeS/ky37Bt0k0rmcjRvQGN5F7Cr9CZzahDvQMyD7Js1Pwv3FOasLVWoKmMG48F7mQJMkJvmCNEsLT7ZKEa3i8NKZyaCEtqCWMwmXQ1M8HOayyUdFmkYlUwgiMBvOpzE6NTz2bl7JKpQyPFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Fh6Ntgu0; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1e3ca4fe4cfso13025455ad.2;
        Thu, 25 Apr 2024 21:16:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714105002; x=1714709802; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=31KekFIOIpF99+poRc8QNtBNYMF8yQuGd++gmF2U7xs=;
        b=Fh6Ntgu0iT27SZQZ+PLIYQpl9uOoyqSQGnRfm6zRB9ICftihTXNT8xyElhOvb45/JQ
         ul7iLVOpcsqh3m8KEnx8U1kqN59ykfKIMLM9IV9IVQKbcb/rmZ7kvJy+nJmbkRNAGwiX
         gylOb+JH0g24URvmhD90LBDvfWA6W+nBGvo561m3ONNRsomakDzqLGDToskj5oy6XEyu
         HqzXMrLMgAKtFZcsrUqyHDKee66R4F3bCadpbW9i6o9tOYPL39qF2v4R92vv6CQs/wMO
         FpCbzKcMPE3KyvMjHnSCZ8rSR5eBPCWIWHudoIH+znXcixI41uXA/ztHwTjHYO8O0NRQ
         eKMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714105002; x=1714709802;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=31KekFIOIpF99+poRc8QNtBNYMF8yQuGd++gmF2U7xs=;
        b=KEwd6SGBgFcNIUoKtxY5M/ZBstLb3Bau8mj3cdXvOFhbln1P8jb4PMOgkIyLOCuKnN
         zFsxALz5Z98E/V8Z900VZbdKUqsIm5inIq22nLHeE0tpxtyV2YNVhz0/ahS//71cVQTl
         ryZLe2fbllKoFX2KoteDFr7mqnT1A5FYnH/M8RRiQlaOcaI0ZwHCX2WKpRk2lggtEh/G
         kiSJLs0Y7GROHOw0ew5yuud7XZh4X8nX9jByH6+W1xY3c89JkvgNvoOAlCdMgmdzjjAD
         YSuJ2cn0ktfJ+M3E3GnmtQ/7AkZxQAWh6aXincruPbkop0H7GEw1dB7WL3WZ+6GVVZV0
         l9vg==
X-Forwarded-Encrypted: i=1; AJvYcCWW/G6AK1t716rVNEVGt9R66h5aPELCReV2xqYdzGVh0Hd4ZMqS8GkludyykxUAN44GenxWHvzkRqdwVIynQ3krrsPlPfSMSdSk+DyV6HEEmp/Q0jGPasIcujqti1a5fP/M
X-Gm-Message-State: AOJu0Ywm0wbXHmGH76FzJ2kml8ppdjHRzqq9hF/FPzmPKLcQP4keYLHs
	QBc98oMwzwZz5FxK/kXFupQrV9+Ln3fb0yKmgUazoj9YgbFkKu7S
X-Google-Smtp-Source: AGHT+IF2R6ZxZ7uWv/ssydB7/h/Ru3mALSufbWP9vudXmlWAUmpZgQkyyDbCqHwK1+c9dIHVZxCUyg==
X-Received: by 2002:a17:902:6bc4:b0:1dd:878d:9dca with SMTP id m4-20020a1709026bc400b001dd878d9dcamr1369903plt.48.1714105002418;
        Thu, 25 Apr 2024 21:16:42 -0700 (PDT)
Received: from localhost.localdomain ([43.132.141.8])
        by smtp.gmail.com with ESMTPSA id x13-20020a170902ec8d00b001e9684b0e07sm9426780plg.173.2024.04.25.21.16.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Apr 2024 21:16:42 -0700 (PDT)
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
Subject: [v4 RESEND 3/3] KVM: s390: don't setup dummy routing when KVM_CREATE_IRQCHIP
Date: Fri, 26 Apr 2024 12:15:59 +0800
Message-Id: <20240426041559.3717884-4-foxywang@tencent.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240426041559.3717884-1-foxywang@tencent.com>
References: <20240426041559.3717884-1-foxywang@tencent.com>
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


