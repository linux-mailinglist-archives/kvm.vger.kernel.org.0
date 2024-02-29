Return-Path: <kvm+bounces-10426-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0183E86C170
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 07:54:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 334A21C213DF
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 06:54:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 651624878F;
	Thu, 29 Feb 2024 06:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ViyQo3fm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42E61482CD;
	Thu, 29 Feb 2024 06:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709189638; cv=none; b=r5BG5T45awgHUZ9YJQ+HjM9Gzqj37ZI0vcnQf1Ipy5ieyN+gncMyOeNjYpe1cIWadEq2GBgYpsGbWn4MGw5X9eT14P0JFvbP4zRnnWC+Z6zAfIrYFmmiOPAUFnFDuj+P9L2ZCiPE4nk0RdJKUUwriAx06W+PoCZ05DSVW6NY0rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709189638; c=relaxed/simple;
	bh=RW46AqXVXgdtflxt/tkQwZU7j0j/bAs5uWwQ7lFOUZk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=eGLsoKn+ef8ghltKcOjwVKBHR39qU5Mfehvthz9nlQchYWbpyyi1+EHwHkfmqxc3dc+E8aaFllFTPE/7GV5ww+KZ910gUDPalrAlmzBMpk6qscCZRsqxqjQAb1h6nhTEp0NQGhKcbS+MfdgUI6USPPqxV5Bc9HIBOB5Yu4F31wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ViyQo3fm; arc=none smtp.client-ip=209.85.166.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-36524116e30so2469855ab.0;
        Wed, 28 Feb 2024 22:53:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709189636; x=1709794436; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8UmsTcmfc8pcbPs6rRpAkpag+IwA6bQ9uQr+vxsTK1Q=;
        b=ViyQo3fmtfinBYxKe8QqrHVPbssoQvAH6+NHcb0Gnbaz3FgbGHG+FsHP2aVvtcoh+g
         7DIuE1I6+xHho1ivg931zApG9p1quYY/YLIQjsMY+sz9pkw4i3K4aIreXhs6L25/eoyF
         h13lty4yjBQseXpHeL4t1I03eCl6S0B7snv0mKwxVjHNvrANA5774At9CGD7Dsfdu587
         C8owlMe/ADJTnzctVjVHe4MC+fdYQQkSjORnY7J9Sx5it2xHNceuDlBag1NOcUqKJ3fc
         M7TX9XOIQ4YTc8ZzUY79LA+HXOSK4NVtX4DvC+xVAhNPSNtnXivNncf6kjOl9aF97u4x
         DEfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709189636; x=1709794436;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8UmsTcmfc8pcbPs6rRpAkpag+IwA6bQ9uQr+vxsTK1Q=;
        b=vglaw5dOXYICj0BCt+wbtrw66UZjqawNMbOaN8Os2+Zukh0nUNXnHTy7OUQ0V/uWRx
         iaanWd5dlipuJ+87bKtLwHzyOUUi3u83hYkPioiAUted8Gk8c8C4JlKLJ6Ji7zA3srFB
         lFS8osH/w2VnxSzOV2f4W4slIV38/WjG2J0LrXtRzrVUi+OW5PuOdjcX9vZsxqpTQ47o
         8ppFid4SXy25MsiXAK3kNLrjQNJePAq1sm0LLDV3AwmlfV1hVkOvs5sQbkCnmjwE6Po2
         wvilvpC3hB/QyoIt4ogAENzkk05d3RWNk7kLSz75VYoGu1jBziQfCYTGBD918ewKMRXv
         lsGQ==
X-Forwarded-Encrypted: i=1; AJvYcCVI7zBYcBK8Us8UWvBJBzvgDHFEZDn5KN+WhRnoQ51INHh7Ny46Fn8NMU7IVykLvQ+8x1DLMdIxBsVmHPCUib4MruEXbT9QsYymtIvd2qHdAZZG8azUk8KE/btMbUCYGp+/
X-Gm-Message-State: AOJu0YyKabS56GLJ4y9eecrfc3hNWqIFnwDBudejJ6CyF6vcy4xIVqZv
	wMJp216FNy7cQivzFsz6gOsuUlyUObEHSSqWwgEvWfKPGB67ELwi
X-Google-Smtp-Source: AGHT+IHlIp65PB6Q5D7qxrYJAwPprIVvCnjTGU5iWAN6KoV2G76wnsFViT2u280sNfIex3ohjklECA==
X-Received: by 2002:a92:d5c7:0:b0:365:13a8:4090 with SMTP id d7-20020a92d5c7000000b0036513a84090mr1399857ilq.27.1709189636394;
        Wed, 28 Feb 2024 22:53:56 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.8])
        by smtp.gmail.com with ESMTPSA id c10-20020a170903234a00b001dc0d1fb3b1sm610509plh.58.2024.02.28.22.53.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Feb 2024 22:53:56 -0800 (PST)
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
Subject: [RESEND v3 3/3] KVM: s390: don't setup dummy routing when KVM_CREATE_IRQCHIP
Date: Thu, 29 Feb 2024 14:53:13 +0800
Message-Id: <20240229065313.1871095-4-foxywang@tencent.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240229065313.1871095-1-foxywang@tencent.com>
References: <20240229065313.1871095-1-foxywang@tencent.com>
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


