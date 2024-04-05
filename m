Return-Path: <kvm+bounces-13779-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 058F789A7B3
	for <lists+kvm@lfdr.de>; Sat,  6 Apr 2024 01:58:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 04B861C210B5
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 23:58:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABAB86FE1A;
	Fri,  5 Apr 2024 23:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bdAtFD/3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 882F15EE61
	for <kvm@vger.kernel.org>; Fri,  5 Apr 2024 23:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712361384; cv=none; b=QfmfcazddWzpUGFtHihC61c+Th7QQmRTNNz8IIgo+6+Gprfywkf74Jhxp7q+JXuQ86cQ7isJ5uh/lraj7VDDrqp5NKTk5aBeafLH6/xCzUtrhNhCptHkk0EujqoKRYNtjAiBbVi4PsGa8kJHDTnizRfF+om6jzopxbMfaaOMRhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712361384; c=relaxed/simple;
	bh=H6nYKSnkJ9WM2desm7KNbB1Q8JvyoSy87GOitFOzshw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GJV+Wn5yUULlI043Yi2J3jac6lpp9rJsWxDQ1DRlz0CZeHnaP6jCbFUAu4vavQCJPzuDtTZ1Ju3KCIZUX+vt18S22wHLzCdoMXkaxbvej4AQ/ohCGcyr1baoy8WJd15+oIB6TPiw3AtMyN1MdOcSwoR9KlLlPAcxWwe4VVCuuZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bdAtFD/3; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-6ed007e950dso904547b3a.1
        for <kvm@vger.kernel.org>; Fri, 05 Apr 2024 16:56:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712361383; x=1712966183; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=aBGD+1+NYJryR8MdWegT7yXPgS8gyTtoFLOwao+cTXc=;
        b=bdAtFD/3/yyQx5ZqMKWdJDnywaIKTtT6hHt7IeNwTfPDyIeVnTZtQpci2gwYs6GZ1E
         Etk0puekVsr8Zf+MJCoJgapmXF67idq6bRXOvfSvRsiHiUibjk62f/vcKb9+2doLsOWT
         KDYPJI4vmr6hf0fhJtMxAs8TfYDbeQYd8AkRMaFCS/7mp+DPrBgV9tjQeTxC+WkJTwFj
         8MLtWOuf2K3PXROfCvxEN54PhlBGxxsV9FmT2iNEqw4BVAX/QMYT+xuSFwHxdik1PHfs
         Oo0kaBt05+Jkb3omymypyz/Tyau/jB1/eELq4XeYlLWya75Orf8zM/9YO+gGXNBlZTXK
         WuJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712361383; x=1712966183;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aBGD+1+NYJryR8MdWegT7yXPgS8gyTtoFLOwao+cTXc=;
        b=PpYVOZBeH6+ZakqXExXm5c10lYIrTS9vUX4WGxw6IyCjk23yRY/8hY5zt6XbJNTFHO
         EB2/bKJ6vM/PLoXHgTR6PR49AWCf6g4ckJycVgkYJdfl/QQ8hoA3rx0rJoRgKfYGHNHy
         912x1Rc6VyrVmiogJP/aljanK9XGKUYFa6/Ix1xr1PuxvzlyD7dOrxQd7IjTFn1Y6OM8
         pURFtlXuSEsBUqqLVTQ4e1IWgyxl5r99kM/u9Y0aM9LTYmCFi/HiYDdzK1lbpoAN1ol0
         HVSgzd9V7upFIRkGZ7Cj2+aGEHe6X4aZl6tsVbOl4Rg/5gKRjWgJcrqU5cMYuUJDKh7w
         Dx3w==
X-Gm-Message-State: AOJu0YwDHiZJthJg6a1q0tW+V6OPsolcwt7njLIwfGy0jQmQVSk9Ucg8
	fRTXsFQFq8Wh3we/YjUQdEtkgKrS07RtoFsJvwluVozNTUdTpxgpgRYxEE3OX/BUgQVe70HrocU
	bJg==
X-Google-Smtp-Source: AGHT+IF3TVd3OdDVtN3oDGrVy2/CgLa3AqQHgD0Q9oZH7Lgt1wEtK2sbv80Wz4fL6xGg/zn6ticXi0zpknM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:17a2:b0:6ea:f425:dba2 with SMTP id
 s34-20020a056a0017a200b006eaf425dba2mr228426pfg.0.1712361382841; Fri, 05 Apr
 2024 16:56:22 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  5 Apr 2024 16:56:01 -0700
In-Reply-To: <20240405235603.1173076-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240405235603.1173076-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <20240405235603.1173076-9-seanjc@google.com>
Subject: [PATCH 08/10] KVM: x86: Allow SYSENTER in Compatibility Mode for all
 Intel compat vCPUs
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sandipan Das <sandipan.das@amd.com>, Jim Mattson <jmattson@google.com>, 
	Like Xu <like.xu.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Emulate SYSENTER in Compatibility Mode for all vCPUs models that are
compatible with Intel's architecture, as the behavior if SYSENTER is
architecturally defined in Intel's SDM, i.e. should be followed by any
CPU that implements Intel's architecture.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/emulate.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 1fb73d96bdf0..26e8c197a1d1 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -2354,6 +2354,7 @@ setup_syscalls_segments(struct desc_struct *cs, struct desc_struct *ss)
 	ss->avl = 0;
 }
 
+#ifdef CONFIG_X86_64
 static bool vendor_intel(struct x86_emulate_ctxt *ctxt)
 {
 	u32 eax, ebx, ecx, edx;
@@ -2362,6 +2363,7 @@ static bool vendor_intel(struct x86_emulate_ctxt *ctxt)
 	ctxt->ops->get_cpuid(ctxt, &eax, &ebx, &ecx, &edx, true);
 	return is_guest_vendor_intel(ebx, ecx, edx);
 }
+#endif
 
 static int em_syscall(struct x86_emulate_ctxt *ctxt)
 {
@@ -2444,11 +2446,11 @@ static int em_sysenter(struct x86_emulate_ctxt *ctxt)
 		return emulate_gp(ctxt, 0);
 
 	/*
-	 * Not recognized on AMD in compat mode (but is recognized in legacy
-	 * mode).
+	 * Intel's architecture allows SYSENTER in compatibility mode, but AMD
+	 * does not.  Note, AMD does allow SYSENTER in legacy protected mode.
 	 */
-	if ((ctxt->mode != X86EMUL_MODE_PROT64) && (efer & EFER_LMA)
-	    && !vendor_intel(ctxt))
+	if ((ctxt->mode != X86EMUL_MODE_PROT64) && (efer & EFER_LMA) &&
+	    !ctxt->ops->guest_cpuid_is_intel_compatible(ctxt))
 		return emulate_ud(ctxt);
 
 	/* sysenter/sysexit have not been tested in 64bit mode. */
-- 
2.44.0.478.gd926399ef9-goog


