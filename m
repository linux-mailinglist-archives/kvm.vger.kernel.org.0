Return-Path: <kvm+bounces-60263-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 3422BBE5F60
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 02:39:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id CA6E2357D39
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 00:39:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4AB32C11C3;
	Fri, 17 Oct 2025 00:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="I2d2BaLt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D724F2BEC3F
	for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 00:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760661208; cv=none; b=bJo1yGXe/4UhHSutODGRIVqr7ZK/44kOi4R7lHTeWezmght/5NOnP0+iTuS/xU2ezCRnQmIW6NN3s24Xpobx72w7UDYcOKkmYb6QySDiNH/vbGrck7+/h1LDl/GNifcQa+cYr/4gBiKQVdlRAveBigLukuJKaiQMBT1b01f1frQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760661208; c=relaxed/simple;
	bh=7L8ZMSuIkRJTkNiFBvS5epoU4gg7pv9o+BehY7SDauc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tmJTVTx31y+nx374GN4MkK8djiPGyQlC5buxe01lELH5b+gfKT5k6GQnMrm0Vl6ycKitxPQtOEmdkMpy4fVzTfwKtn/NKavwyitnQSzZegFVULvSIuF8Rsvmurb9EEK7+nuWZn48n1FUWeMoRdcI/m/wywTlffjKW6JE0/XwZu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=I2d2BaLt; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-33428befbbaso1593967a91.0
        for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 17:33:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760661205; x=1761266005; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=G1uT4yQcba8Ntip8LDR4veCehne/0rON+KC3PlpYlbc=;
        b=I2d2BaLtXqDJIKsNYUqpCOnQeIzAGYVpirrMAlP0NvOM+mzhb0h0sgpGfn0PitSFTU
         +5dns31JOWekYVeclB4cNzOz/l06RBk+7mBe+cupAbWT/FfI0Jl7ZUFTYguzroQROfqw
         +hFhYY6VZR8XnV7MFhanRhR9G9xvLAxF4X46uQbEubCFfqLGRiEuWlYpVhCb7JpINlyM
         nlabs3mKEln6vSpYDZEPDRai6uaWjlsqTEFM6xQ8QBrW6ullentcn29VVQnk1T/XsCo/
         10AWXS1pVYoYiud2ksL9f6HFJzWRLNNxEEJiS3dVOdgcOVLgyGkJ6kiO5T5BMRXMjhNt
         6VSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760661205; x=1761266005;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G1uT4yQcba8Ntip8LDR4veCehne/0rON+KC3PlpYlbc=;
        b=sM6F6Z+csV4ZAo532zJBgErZEQ/i5IDKf+0O7XZm1xo8ABuSyutIKgYgIEwQTmuJfn
         cw3qvtbmLs4XkOESKvk0WoBX2nZKbqRiPSOvzPt7j+N+nqGTdQfDTEMC9l5GVVNdTD5Q
         dMC+54bjhzPMbLlv3TXft+0+aMst1lf2QeqRb3jBJisyAkUFsgj+59Kv6XflNGLdyZyD
         128VImcH9ARd9F9l6D1Zfc/zYhjwbVgy8nJg3eYWm0pIUwNX/SK8cZzUjQ1gT4xI+YiP
         XO+C5mWNVqClzTtYtlhrTJGT9B9iCCoVSppoNBhOEyTpMQHeQxh/qVOomP0zRhVYo63G
         aYzQ==
X-Forwarded-Encrypted: i=1; AJvYcCX/amjR6T4al4UpQeqFLpkEGNQpSCXIoFSGpqP2dDrwRmA7KUcHL6/lJsTtRVaR7acoau8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyQny16TzVhAU2eyOojDUT3dSpiinFe9TX9wtVwvIPmUw45OAB7
	Thl7l3ovAawV8QKyCT5vcshgRUGj/YqVljynC9cWcP5j+8fyUWdYfTw6dANgc4CVC0EEC67DpZx
	eWIfiKA==
X-Google-Smtp-Source: AGHT+IFb3cb9XScIkfIbQA2oQID7nhqxfExRyWF6N5UGcVhE3T71y0SJP1d51io6pNMM6/KZP3XG25y1rx0=
X-Received: from pjoa3.prod.google.com ([2002:a17:90a:8c03:b0:32e:a549:83e3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2d8f:b0:335:2eee:19dc
 with SMTP id 98e67ed59e1d1-33bcf8f94b6mr1826093a91.28.1760661204960; Thu, 16
 Oct 2025 17:33:24 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 16 Oct 2025 17:32:39 -0700
In-Reply-To: <20251017003244.186495-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251017003244.186495-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <20251017003244.186495-22-seanjc@google.com>
Subject: [PATCH v3 21/25] KVM: TDX: Add tdx_get_cmd() helper to get and
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
	Kai Huang <kai.huang@intel.com>, Michael Roth <michael.roth@amd.com>, 
	Yan Zhao <yan.y.zhao@intel.com>, Vishal Annapurve <vannapurve@google.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Ackerley Tng <ackerleytng@google.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

Add a helper to copy a kvm_tdx_cmd structure from userspace and verify
that must-be-zero fields are indeed zero.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/tdx.c | 31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 2e2dab89c98f..d5f810435f34 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -2761,20 +2761,25 @@ static int tdx_td_finalize(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
 	return 0;
 }
 
+static int tdx_get_cmd(void __user *argp, struct kvm_tdx_cmd *cmd)
+{
+	if (copy_from_user(cmd, argp, sizeof(*cmd)))
+		return -EFAULT;
+
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
 
@@ -3152,11 +3157,9 @@ int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
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
2.51.0.858.gf9c4a03a3a-goog


