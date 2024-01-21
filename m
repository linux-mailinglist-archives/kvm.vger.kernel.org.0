Return-Path: <kvm+bounces-6484-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FFB2835572
	for <lists+kvm@lfdr.de>; Sun, 21 Jan 2024 12:19:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D26A0282105
	for <lists+kvm@lfdr.de>; Sun, 21 Jan 2024 11:18:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9BF7374D2;
	Sun, 21 Jan 2024 11:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FzgsCfgY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADE2E3717A;
	Sun, 21 Jan 2024 11:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705835891; cv=none; b=g4+7qta4gDGbOtrgegkREeT1SWJq7d7HjlQsr+CtHnNG6GJtMHdW+ZWyB1D/1VMMGDb/m4xRzm4prpaO4jMK40iFeUEosL2cwga1O/jtVN52cWu25day8JvL5VczGrgscixdJiBxxGtq8IFoaJ5vv8CsY5HFrjIpph/BSsyD/fA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705835891; c=relaxed/simple;
	bh=ZBCkIly2SghJOsQJf5IdELgmQy89p/P22vnKYG5KKj0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cWaWxX/frp3MEcKWcPhr1H0C8/TTu1qSUEewzNrm7nWictXoZpx/IPwjbzmkujpGmSnMC13X+PHnHpnU4So19zeJJeOey9Jht+UiT6Aq2pS4simBwTob84HldCeV99A2rVXN6p1gqZPpoM55g6lr4D1MqAMvpwbWvOxFABLlbTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FzgsCfgY; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1d73066880eso6362485ad.3;
        Sun, 21 Jan 2024 03:18:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705835890; x=1706440690; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BfeygfP8cde5ltVuzdVkTQ5N6jzGLB73RlZNPdB1Cv8=;
        b=FzgsCfgYcbW4rLX/4xHNh3EbX07yx3NIpgleaTS/ExZHiuTYuA0aMBK+/ezpEzoMxS
         JzQZ8Yo7Nd9d6m7VSucLRd4GgMmjmpekdh6yc3BLb1JhFiGYy8hMDl6WE3rOzzumLx8k
         A7xRteuUk2MnzJ+yyG5Q7b+bp0CJr2TQpMOzvMUrXNw6YXDAhAS9VYrKFobYfIgdc8TE
         bQJFpKAKmsgCTgjZhOBQL94ShhgGkJ+hWSp+3x6PWaUJHjFgvfnelUkenCaAtkE6gIoX
         lLfEdP8c3WrDZJhbMvQmgtftbEPjBZe3vQMr7RDPjFJ7K2MX4W9Z3SCC8ytMT06DFwhh
         PZbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705835890; x=1706440690;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BfeygfP8cde5ltVuzdVkTQ5N6jzGLB73RlZNPdB1Cv8=;
        b=GZo/4i15FDkHo/LkF9F3N9gVycig6zrJJx5hHkBoHKEe2v4l0azZUF3ZVBBPyMPW+2
         yp9ZiDNOkALWaf4z/YpB3OAUsAlgZZHuRH06zITp+KrJFrHg1VHg1a78eue2inUbNz7W
         TNh9iB+trTQjhBRmsJACqEcCjG1va/2n2uDI1DppxpSGOGrHsLvV4T2v2gdC+tw0aULQ
         sQs/WvaNSZVYI3oT0oEAcSPWr9qwP+3hQ6M8TZXFAHoom8q56aIi64MHFBjsc1y8atuY
         4WNXLllvwpxamDiiLoBAnPtXUrqnEdiFx2xVecEe4Ol8Hx87WIOW7cf5brKW+Loc87v3
         tDzA==
X-Gm-Message-State: AOJu0Yxm7+k8HB9RDxdCjPjM7NCGlWo+PXp+c6jlz4KTom2nmaRW8Sxw
	G6MY6/rHP2xaDDjY+coaqzq320LzuVYxWp1P4XyN/nfuJbxNMuhp
X-Google-Smtp-Source: AGHT+IFhVicMZ3gcp23QRReDCkTAlzUfmAZDzMBOBWXTUJYXy9+74u97YxU0BllkofJUt1eUs91gLw==
X-Received: by 2002:a17:902:b788:b0:1d4:a179:e697 with SMTP id e8-20020a170902b78800b001d4a179e697mr3298347pls.55.1705835889977;
        Sun, 21 Jan 2024 03:18:09 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.9])
        by smtp.gmail.com with ESMTPSA id jc9-20020a17090325c900b001d7233f1a92sm3560255plb.221.2024.01.21.03.18.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Jan 2024 03:18:09 -0800 (PST)
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
Subject: [v2 2/4] KVM: setup empty irq routing when create vm
Date: Sun, 21 Jan 2024 19:17:28 +0800
Message-Id: <20240121111730.262429-3-foxywang@tencent.com>
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

Setup empty irq routing when kvm_create_vm(), so that x86 and s390
no longer need to set empty/dummy irq routing when creating an
IRQCHIP 'cause it avoid an synchronize_srcu.

Signed-off-by: Yi Wang <foxywang@tencent.com>
---
 virt/kvm/kvm_main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 7db96875ac46..db1b13fc0502 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1242,6 +1242,10 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
 	if (r)
 		goto out_err;
 
+	r = kvm_setup_empty_irq_routing_lockless(kvm);
+	if (r)
+		goto out_err;
+
 	mutex_lock(&kvm_lock);
 	list_add(&kvm->vm_list, &vm_list);
 	mutex_unlock(&kvm_lock);
-- 
2.39.3


