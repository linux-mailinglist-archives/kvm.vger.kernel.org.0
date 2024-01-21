Return-Path: <kvm+bounces-6482-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 99BB683556E
	for <lists+kvm@lfdr.de>; Sun, 21 Jan 2024 12:18:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4E92C1F212E3
	for <lists+kvm@lfdr.de>; Sun, 21 Jan 2024 11:18:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74F9F36AED;
	Sun, 21 Jan 2024 11:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m24NhnmE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 596BB364B9;
	Sun, 21 Jan 2024 11:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705835883; cv=none; b=WMNBxyGVuCiNfhV3N1hdnzUxX2xoUT8lEdhX0b82xs+Si7j83K0b7KN/n0AVdHuKp28GLpKYXeeWeKO2NPhzeEA4Pd4OotP/9g6Mkeyap2Tg3uUbfiefM3T8BBQR+hTtVYRzBlW4CVcC4qtklxR3f40zjzm6RXr48xWnKza9Czs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705835883; c=relaxed/simple;
	bh=Ubv0rLJDHobpYSxs/pzdciuhtxNUUVVqLBL+5YRdYhY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=DFhF+SdPrEANI8fBasLkfMBRPzkUcjcMidVvjVhT3quwD9K0TIic0YciozTBnnX5qzflVv8+7opaTV4vPgbU9tDXyAbjeMZvaRSDLTbaJDtpeL1H8D23PX58ZEgerfHnACAHkjeMWpo/mPBx2nGnp4AHH92ON3t8R5UxcDzFpWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m24NhnmE; arc=none smtp.client-ip=209.85.167.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oi1-f178.google.com with SMTP id 5614622812f47-3bd6581bc66so1898085b6e.1;
        Sun, 21 Jan 2024 03:18:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705835881; x=1706440681; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fnxOIz+fz6hhaph0nBIFemtok9zJmzQs5V2LHS3xYNM=;
        b=m24NhnmESo0uXdGHtZ9ss/6jk1cijh12wdI6+hB/89S3QQnVzBK3WsbJBrqTmXF9l2
         4wEqozVl7kyQMA7Nmz/JZ8hNUGwScXLV6igymKbne+0Uk4Y9TpFpvBwiw7a/i9lZq/un
         rjR5oyIDDGPq2dy2o+yiui4Ewmf0Yzr2eFOyiie/q9wPpF6pYwpziTpD9h63vY7FPV9Q
         quwHvCw4N4DnZHnyNxzOSiNZZ2VwxMZ6jNI2l1G13JVHKCqAJWT9bo1d1mEQrOncOQuz
         /uXyoRtczfLNYGZyLTl9OwmMPg5/b56RlZtW8Suy1Dv844bbeINNsYwpjKRU9lNRWr0C
         Cyuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705835881; x=1706440681;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fnxOIz+fz6hhaph0nBIFemtok9zJmzQs5V2LHS3xYNM=;
        b=Km08xr8HekDFLj62uzesJQkRIvJlzeoznpvUwSX3IhvzjJDSXK2O4NsKv6sJs7IECh
         JOLA79EAcI8NH+08b+3W1XCkTN7HrkKhuB1LcUUjkGR78x9Q6IBa6KWfaEonBqs9Hz8P
         ZhgYoKJQKXlvxFMXk8y/bgusbCCupuAenfzsGkb7UJ+P80uOeRqkgcPwUsXqgJ9lg/jJ
         6z0uVy3lAytKe3aiKEvH2GYrI7ZhKPm0dRQdmZSfBOuMRAwORd6bGex46ki5BqO7rB9X
         x1ESfM11V7Pk0U2nETkoiwAQRaXaI/fehCSjc9oojAC/SaYAsU/06ohFAIyQqWaoOK3Z
         jbvg==
X-Gm-Message-State: AOJu0YwU8oIxbNzTAl4Ni92deQxIpIP2wusZGZWz/QkEKBQCn0UqYuEK
	YiGAEKuR+3M6Yn37SEaoBZgLla9byEKOOhTxch63oaoECELTpf9S
X-Google-Smtp-Source: AGHT+IG3Sb3mLtHIrr1fyK95APSNwvKjlTtbHQLR6kwJ+gV7wS8XB+MFlCJhhOcPGHG5yoGxFQnm/w==
X-Received: by 2002:a05:6808:3197:b0:3bd:9d4c:de with SMTP id cd23-20020a056808319700b003bd9d4c00demr3694920oib.30.1705835881179;
        Sun, 21 Jan 2024 03:18:01 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.9])
        by smtp.gmail.com with ESMTPSA id jc9-20020a17090325c900b001d7233f1a92sm3560255plb.221.2024.01.21.03.17.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Jan 2024 03:18:00 -0800 (PST)
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
Subject: [v2 0/4] KVM: irqchip: synchronize srcu only if needed
Date: Sun, 21 Jan 2024 19:17:26 +0800
Message-Id: <20240121111730.262429-1-foxywang@tencent.com>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yi Wang <foxywang@tencent.com>

We found that it may cost more than 20 milliseconds very accidentally
to enable cap of KVM_CAP_SPLIT_IRQCHIP on a host which has many vms
already.

The reason is that when vmm(qemu/CloudHypervisor) invokes
KVM_CAP_SPLIT_IRQCHIP kvm will call synchronize_srcu_expedited() and
might_sleep and kworker of srcu may cost some delay during this period.
One way makes sence is setup empty irq routing when creating vm and
so that x86/s390 don't need to setup empty/dummy irq routing.

Note: I have no s390 machine so the s390 patch has not been tested.

Changelog:
----------
v1->v2:
  - setup empty irq routing in kvm_create_vm
  - don't setup irq routing in x86 KVM_CAP_SPLIT_IRQCHIP
  - don't setup irq routing in s390 KVM_CREATE_IRQCHIP

v1: https://lore.kernel.org/kvm/20240112091128.3868059-1-foxywang@tencent.com/

Yi Wang (4):
  KVM: irqchip: add setup empty irq routing function
  KVM: setup empty irq routing when create vm
  KVM: x86: don't setup empty irq routing when KVM_CAP_SPLIT_IRQCHIP
  KVM: s390: don't setup dummy routing when KVM_CREATE_IRQCHIP

 arch/s390/kvm/kvm-s390.c | 13 +++++--------
 arch/x86/kvm/irq.h       |  1 -
 arch/x86/kvm/irq_comm.c  |  5 -----
 arch/x86/kvm/x86.c       |  3 ---
 include/linux/kvm_host.h |  1 +
 virt/kvm/irqchip.c       | 19 +++++++++++++++++++
 virt/kvm/kvm_main.c      |  4 ++++
 7 files changed, 29 insertions(+), 17 deletions(-)

-- 
2.39.3


