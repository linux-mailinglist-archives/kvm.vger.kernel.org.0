Return-Path: <kvm+bounces-37039-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BB51A24662
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 02:56:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2A10D3A6BB4
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 01:56:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2AA61487C1;
	Sat,  1 Feb 2025 01:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="y92IgAIr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A287413E3F5
	for <kvm@vger.kernel.org>; Sat,  1 Feb 2025 01:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738374930; cv=none; b=hI0JtjQJHSv/93F12ixpaZjW5BFrVIfSL2SSM7OcJFGbcVp0xJJE8Mq0gOgBtjlSxqmwIXNxvf+pUH9YSv28zwa7OH+cJ4X63VSkEBAA3CR3jLWdiwHg0Nqfo6UNTS1xZ23VyhoQwqzAkc8ocMjTMNEQPEgl/OuRFgw+gm781yM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738374930; c=relaxed/simple;
	bh=4KLJLbNb3dm5XQSSplNU+uwKog1RwQjU+uH/1EHjBWE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Va7Bp1ApZL9smiNDId4CN166VXNNHtNEymYQCAh+ot6KR+sE0g1Un76bi1IlBZKpyfoIvEbRoi/5qpyoaElyPGSQEQQ/rkHJjATQMKgP47jiIOWyi4vRLTJ4iWKmPQs+PYAf4SN694W7craZNLAlBlFD2fvGggGLaqGBw3EqiLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=y92IgAIr; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ef9da03117so7078183a91.1
        for <kvm@vger.kernel.org>; Fri, 31 Jan 2025 17:55:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738374928; x=1738979728; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=8fgNag4pP/Al/+jEnlzyFsUV+JTyAkY6cS8rvrrIp0U=;
        b=y92IgAIrikDSXHbuB6TMccQFPaLb9fatP0vEq4PCjTd0nlt8Yyvex1YY86Lj4kJzMs
         99XRQsTBFgjJzFqbTn8Bv0Ar7WXlQAZfJinb6Cz5M1m1b4YBtmSxX247QJbpDTipN6vf
         zA7cJ7lzVVwdkWsIqJ/vSRJTzqscmpDaPvycpOhy/bim1SA0SjvurFxmXPbIbkoIlmPH
         7uRWxgiLKY0ylo3IRon9grhvjaDZmELAoK5DqAnGC5y1GnfKXgw8ZBiwWLkhJR8h78kl
         hbInnlZG+ECU2mU2vLeubLCupv/ZcKu3UyegWnRicdRObRTllLMEll5RCndDpNc13VSq
         QZyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738374928; x=1738979728;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8fgNag4pP/Al/+jEnlzyFsUV+JTyAkY6cS8rvrrIp0U=;
        b=u4w17zYqnZyqFw9y9Nb/yIjiGYvbVhpHR06eCtF4D/xa5vHn9Eaw1hIAmSJxrjNj5W
         JekIhfqhPUtxkljloKKnrx9NhU5DQdEommeR+senVs05OTVoSa9xqNVLXvxWtl2oxHjJ
         ILN8tpoM5UWj38C68D2FkLYlZmwLFqmdp9966ansYWEsyfurpLgNK2vb3FWQ0z03hRmM
         1vWK2x2ra6dhe9oli+Nx81/37E72id9XeWf5Pkclyg2wGjDf+YiDAbyAottQfSp9QM3l
         KWoNRkx9xRQ2sNRyIGJhygmrotOWwh1gSFaoAGMdcqwp8t6xZVoP2QIEsivDOHCR9Hzp
         GGLQ==
X-Gm-Message-State: AOJu0Yx+pnT9+glZYK+d/C98Dr9sOHl9orShfq1+mQ/1wYkr5Ud9W032
	GRqrL8iXA/doB6/QbO3zcwANcncs9B6Wbe+Ne88P7jKITi4ZjRcGHvNMmEVUAiP7dYibdQduSqh
	jLw==
X-Google-Smtp-Source: AGHT+IGat+UI+PbiqPp0x4IlhMTMlQ4Wh/0OH9JXwg33xEB/TjQQwBsT7F9d2kQn++dFr13DA3e5CEPT9Os=
X-Received: from pjbfr16.prod.google.com ([2002:a17:90a:e2d0:b0:2ea:5c73:542c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:264e:b0:2ee:53b3:3f1c
 with SMTP id 98e67ed59e1d1-2f83abb4032mr18429535a91.5.1738374928261; Fri, 31
 Jan 2025 17:55:28 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 31 Jan 2025 17:55:12 -0800
In-Reply-To: <20250201015518.689704-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250201015518.689704-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.362.g079036d154-goog
Message-ID: <20250201015518.689704-6-seanjc@google.com>
Subject: [PATCH v2 05/11] KVM: nVMX: Consolidate missing X86EMUL_INTERCEPTED
 logic in L2 emulation
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Refactor the handling of port I/O interception checks when emulating on
behalf of L2 in anticipation of synthesizing a nested VM-Exit to L1
instead of injecting a #UD into L2.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index fb4e9290e6c4..dba22536eea3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8007,12 +8007,11 @@ static __init void vmx_set_cpu_caps(void)
 		kvm_cpu_cap_check_and_set(X86_FEATURE_WAITPKG);
 }
 
-static int vmx_check_intercept_io(struct kvm_vcpu *vcpu,
+static bool vmx_is_io_intercepted(struct kvm_vcpu *vcpu,
 				  struct x86_instruction_info *info)
 {
 	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
 	unsigned short port;
-	bool intercept;
 	int size;
 
 	if (info->intercept == x86_intercept_in ||
@@ -8032,13 +8031,9 @@ static int vmx_check_intercept_io(struct kvm_vcpu *vcpu,
 	 * Otherwise, IO instruction VM-exits are controlled by the IO bitmaps.
 	 */
 	if (!nested_cpu_has(vmcs12, CPU_BASED_USE_IO_BITMAPS))
-		intercept = nested_cpu_has(vmcs12,
-					   CPU_BASED_UNCOND_IO_EXITING);
-	else
-		intercept = nested_vmx_check_io_bitmaps(vcpu, port, size);
+		return nested_cpu_has(vmcs12, CPU_BASED_UNCOND_IO_EXITING);
 
-	/* FIXME: produce nested vmexit and return X86EMUL_INTERCEPTED.  */
-	return intercept ? X86EMUL_UNHANDLEABLE : X86EMUL_CONTINUE;
+	return nested_vmx_check_io_bitmaps(vcpu, port, size);
 }
 
 int vmx_check_intercept(struct kvm_vcpu *vcpu,
@@ -8067,7 +8062,9 @@ int vmx_check_intercept(struct kvm_vcpu *vcpu,
 	case x86_intercept_ins:
 	case x86_intercept_out:
 	case x86_intercept_outs:
-		return vmx_check_intercept_io(vcpu, info);
+		if (!vmx_is_io_intercepted(vcpu, info))
+			return X86EMUL_CONTINUE;
+		break;
 
 	case x86_intercept_lgdt:
 	case x86_intercept_lidt:
@@ -8079,8 +8076,6 @@ int vmx_check_intercept(struct kvm_vcpu *vcpu,
 	case x86_intercept_str:
 		if (!nested_cpu_has2(vmcs12, SECONDARY_EXEC_DESC))
 			return X86EMUL_CONTINUE;
-
-		/* FIXME: produce nested vmexit and return X86EMUL_INTERCEPTED.  */
 		break;
 
 	case x86_intercept_hlt:
@@ -8108,6 +8103,7 @@ int vmx_check_intercept(struct kvm_vcpu *vcpu,
 		break;
 	}
 
+	/* FIXME: produce nested vmexit and return X86EMUL_INTERCEPTED.  */
 	return X86EMUL_UNHANDLEABLE;
 }
 
-- 
2.48.1.362.g079036d154-goog


