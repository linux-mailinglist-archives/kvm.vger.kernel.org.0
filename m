Return-Path: <kvm+bounces-61551-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 357F6C22357
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 21:21:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 166333B2F61
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 20:16:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C10133BBB5;
	Thu, 30 Oct 2025 20:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NS337iLP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84195335563
	for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 20:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761855057; cv=none; b=rPBcWcDNAU57Z3M746iTMaVgo2ma5ebZnAzC/o3cnc+OLuiGiFw9F22JPBXlZ8QW9ZrOXgYzrLXJENPE/Lz+r/6YPpZi7u0TLYZgw4nR7DKWFmIqsS2H/DuwPnPp3sINYrsBD+OPCC9TFpwQEEu81K6/V3El2n3WqQKFksLDXTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761855057; c=relaxed/simple;
	bh=ijmVL6tuMasvfCu8NJ2oY2dmKaMYxvGjS6YgS4whU3k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SlA2ctPoeVxzdR6aFtSy5eM6GRTtqUO2uMftTralrCTp0GNzYy42pa6snNMbKNCuL+kIA0ZeCaYDyIkqPCjFZhhRHa0xEEA5Ec0hDwwkWVDKe714z0hFn+ZGdkwfDUZ2chNSOy9g0iq2N9Q8UwEIJzsR29mcnhLygfzYHrZyRho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NS337iLP; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-33d75897745so3866578a91.0
        for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 13:10:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761855055; x=1762459855; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=HfwppzbkJFTqc1oDUhl9YAWd2H/Ydo3ViOcPjYsyqPw=;
        b=NS337iLP3IfeG0E03oUgJhNVR1nwPGhjNqGmulSiXufZUa+ypiuqoTv5igcWybbu/w
         CxjwBZhVof1+fsrJB2PuYKiFELEpHmURNM6SOm8Zktl96J/yOrLkTu0ARmVq5hjgqRUH
         tQZtAKQ0ev2IvGqOHbPN3gQ9zzfrigqztT6Z50flOV3VR4AMOtbsBPBKNjpq9tCBMFNX
         9sLI7L0XH0fgKBXUvZ82IIQeRvwYsZGhAdc/CSfwKFfDkrVl3oGtsJBfjREGWnR/TQU2
         wntY4+yJBp9ER+bs2xOxNeWkLcPZV7Q+On/NjebKAbs1YbqOVSqJML3PmP8lu6E7ysuJ
         nVgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761855055; x=1762459855;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HfwppzbkJFTqc1oDUhl9YAWd2H/Ydo3ViOcPjYsyqPw=;
        b=cjl3BLvq6rsCj8lmavF1rKGvosCNWAwwxHz2d9GS1iMCcUcpK/iiwfdBjQQo1kHZ+Z
         koiwc72EKLwjd3TeEzqGaqxA24tZyB/WWZEMlmyDzBPFLemoFgE93jiZ4ZT69ciaEaOz
         YGyyLZYlamseh9CfnZhiPeidOHhySLQs3p8I6gSfBirjFUNo+ErcJaQeDR2DRU0x6015
         U40nKhl4HfXPGTsaRWvXcU/9saf48T5UCaCmAtnZF6E5dv+vs/y5D0uk63YYsnEQCFuI
         5ISgGa6eudOhOXWzalM24d6JQtqGAdQjCHrH4ratqjzzP3F6aUQg+p+vZpXH5eCyzc+K
         6o8g==
X-Forwarded-Encrypted: i=1; AJvYcCUuSptNGOPD4T+VQO6BuLEuzDvp/8TmrtBXSZPcBjPMycVVQfJyiLrP6LGP2+V/dDmvG4U=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4bSWCTaPKL6SGlAQ6sqX8zWkJ9ZzyeOavVKMt3qSG73V8l9fa
	TpYXkSFQ8LgcqUI/6Ra+e91VSAG7DXw7B3VP0b4jp5Etx39mUvbTmA2sanBrOpOwwTUWlOksDla
	pnzVb4Q==
X-Google-Smtp-Source: AGHT+IFgv0+NgL48Cma0Y79QUzd7lRP+/FCxQ0tZkUpinDRTeLAklkWHALMXu+tHUB2W7Y9sxKQZz0IMk4g=
X-Received: from pjbbt9.prod.google.com ([2002:a17:90a:f009:b0:340:7770:2e30])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1f82:b0:32e:a5ae:d00
 with SMTP id 98e67ed59e1d1-34082fc7b43mr1201499a91.13.1761855054620; Thu, 30
 Oct 2025 13:10:54 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 30 Oct 2025 13:09:45 -0700
In-Reply-To: <20251030200951.3402865-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251030200951.3402865-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.1.930.gacf6e81ea2-goog
Message-ID: <20251030200951.3402865-23-seanjc@google.com>
Subject: [PATCH v4 22/28] KVM: TDX: Add tdx_get_cmd() helper to get and
 validate sub-ioctl command
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, "Kirill A. Shutemov" <kas@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, x86@kernel.org, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>, 
	Kai Huang <kai.huang@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Michael Roth <michael.roth@amd.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Vishal Annapurve <vannapurve@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"

Add a helper to copy a kvm_tdx_cmd structure from userspace and verify
that must-be-zero fields are indeed zero.

No functional change intended.

Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/tdx.c | 35 +++++++++++++++++++++--------------
 1 file changed, 21 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 97632fc6b520..390c934562c1 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -2782,20 +2782,29 @@ static int tdx_td_finalize(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
 	return 0;
 }
 
+static int tdx_get_cmd(void __user *argp, struct kvm_tdx_cmd *cmd)
+{
+	if (copy_from_user(cmd, argp, sizeof(*cmd)))
+		return -EFAULT;
+
+	/*
+	 * Userspace should never set hw_error.  KVM writes hw_error to report
+	 * hardware-defined error back to userspace.
+	 */
+	if (cmd->hw_error)
+		return -EINVAL;
+
+	return 0;
+}
+
 int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_tdx_cmd tdx_cmd;
 	int r;
 
-	if (copy_from_user(&tdx_cmd, argp, sizeof(struct kvm_tdx_cmd)))
-		return -EFAULT;
-
-	/*
-	 * Userspace should never set hw_error. It is used to fill
-	 * hardware-defined error by the kernel.
-	 */
-	if (tdx_cmd.hw_error)
-		return -EINVAL;
+	r = tdx_get_cmd(argp, &tdx_cmd);
+	if (r)
+		return r;
 
 	mutex_lock(&kvm->lock);
 
@@ -3171,11 +3180,9 @@ int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
 	if (!is_hkid_assigned(kvm_tdx) || kvm_tdx->state == TD_STATE_RUNNABLE)
 		return -EINVAL;
 
-	if (copy_from_user(&cmd, argp, sizeof(cmd)))
-		return -EFAULT;
-
-	if (cmd.hw_error)
-		return -EINVAL;
+	ret = tdx_get_cmd(argp, &cmd);
+	if (ret)
+		return ret;
 
 	switch (cmd.id) {
 	case KVM_TDX_INIT_VCPU:
-- 
2.51.1.930.gacf6e81ea2-goog


