Return-Path: <kvm+bounces-6972-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D897783B8EB
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 06:09:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 62B4DB21EA5
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 05:09:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9A0F8831;
	Thu, 25 Jan 2024 05:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="miEO1Cy0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B11EC79EA;
	Thu, 25 Jan 2024 05:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706159360; cv=none; b=R0wmg1s7aVgdyumvhzSVdY/X3VK9qSk2Ha+pcuN1Eq07TNl1jAMuqKaEmK3flIaFchfcmi7u7ZCxrJrlfGKS/DekCjRPy0QbP4zQFrj38ecA+zLnb9qMlKUzOZa4vcYklzxTkrbUdWP+dJ/fyrjWFP8LYdPC3ciF5O1yiM7CNQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706159360; c=relaxed/simple;
	bh=tEoZA2XXLvRj0jSzEf7kmZBKMCXXRf3AZLxJiaXdg9g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=opBvAcuY1LQrUIuq3BMicNWVe9IGaN2HiEa6zQgWti1ru6LsO83rCfH9t0oHmXJWPgWCcrKgDE+LVRan8nmIkiqsc96tt7iXrS260Xy8lGUmfE6FrUlh9LRYwiYSnu5BgEHu5kFk5XPznb8zbCVyaWUNkQVYPeIqbLvkGtgPaCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=miEO1Cy0; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-6dd7b525cd6so2017682b3a.2;
        Wed, 24 Jan 2024 21:09:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706159358; x=1706764158; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SzoDGo3P/j0GvDgArKX+MVMdHU8LGqkP77lyVEPPjAo=;
        b=miEO1Cy03D5R7xKwYi8rGmguiVyCzIAJQ2KdLDtbfEIdH5j1froWcfi45ElaXEE6S+
         6tosKcQHUxcg9yR59yzXhMRGwll40hrE5WJKtKGY7a6ulFylUE8xFTOh9UPZDSFu8Yur
         nEh7e/DhY/DymTnDkLRqFWeKkKJyr8oHXcrMdIDf99IC+5Q8hw2GqEMNG9Uubkzx0e9s
         gBb7rbQNbTZYixaIXUCkw1QEfG3/hQVw0l9HFF+v5R9vqMn20sW2Su+3HWbIInWLo2IA
         oflg9afQptrjt3wi1THYJBH0rdqs6CoEvTPKSssM5nl0sxR+a5+fAJxLv4M3SfbQmoKI
         PMfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706159358; x=1706764158;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SzoDGo3P/j0GvDgArKX+MVMdHU8LGqkP77lyVEPPjAo=;
        b=PcDkH2fkPnSKnAh0oiRNofhNnkctCYMCuih3f+F+awEohLam1DKawCb4elQC98Mxa5
         j2xj7DfMYrmm1RjPcWjrnLrwoYxOmZAIrJcN6l761bcZuMGB1vex2C4xUt6/q+p3shoq
         1MdkB3N9blrgmHEq1XjD6OU1SlDpyzddAcUmgBOX0dy+ghwr/auouDLjjPUZnzO+ojxh
         Z/JPWb5pX3sKYvHTBJSBxdPE1rD63v7GwV5GbsEUgf/pXA6VsJV+Y5gTwFdyFruDuAn/
         BmCOsLhldrFgZqsRI8IuZYCAYkXUaTXMje+1QRmaMwb+mDNDigi6wCCzElVdlxFA7eAN
         K4tw==
X-Gm-Message-State: AOJu0Yw5jeMSYR8vBSfSr3eFxS4WzsC5mXqCkowF17p5xWsc+hSC7n0o
	nEaehpDH/XoTztBfL8MT9IX9sZVEjEwL1S7IpRNFIYWwM5j0EbNQ
X-Google-Smtp-Source: AGHT+IF7T3031ORcm6+Eu0itPc1RkABymLTLfzvgslJMJCpjdcd4BxBmfGnjGHof5XUQipOYveFpOA==
X-Received: by 2002:a05:6a21:3996:b0:199:ba9c:3e91 with SMTP id ad22-20020a056a21399600b00199ba9c3e91mr419373pzc.25.1706159357578;
        Wed, 24 Jan 2024 21:09:17 -0800 (PST)
Received: from localhost.localdomain ([43.129.20.31])
        by smtp.gmail.com with ESMTPSA id pb5-20020a17090b3c0500b002926f68a5f8sm415759pjb.52.2024.01.24.21.09.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jan 2024 21:09:16 -0800 (PST)
From: Tengfei Yu <moehanabichan@gmail.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>
Cc: Tengfei Yu <moehanabichan@gmail.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] KVM: x86: Check irqchip mode before create PIT
Date: Thu, 25 Jan 2024 13:08:23 +0800
Message-Id: <20240125050823.4893-1-moehanabichan@gmail.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <ZbGkZlFmi1war6vq@google.com>
References: <ZbGkZlFmi1war6vq@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As the kvm api(https://docs.kernel.org/virt/kvm/api.html) reads,
KVM_CREATE_PIT2 call is only valid after enabling in-kernel irqchip
support via KVM_CREATE_IRQCHIP.

Without this check, I can create PIT first and enable irqchip-split
then, which may cause the PIT invalid because of lacking of in-kernel
PIC to inject the interrupt.

Signed-off-by: Tengfei Yu <moehanabichan@gmail.com>
---
v1 -> v2: Change errno from -EEXIST to -ENOENT.
v1 link: https://lore.kernel.org/lkml/ZbGkZlFmi1war6vq@google.com/

 arch/x86/kvm/x86.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 27e23714e960..c1e3aecd627f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7016,6 +7016,9 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
 		r = -EEXIST;
 		if (kvm->arch.vpit)
 			goto create_pit_unlock;
+		r = -ENOENT;
+		if (!pic_in_kernel(kvm))
+			goto create_pit_unlock;
 		r = -ENOMEM;
 		kvm->arch.vpit = kvm_create_pit(kvm, u.pit_config.flags);
 		if (kvm->arch.vpit)
-- 
2.39.3


