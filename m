Return-Path: <kvm+bounces-58264-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 71FE1B8B865
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 00:43:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3E2071662BF
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 22:43:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16FBC305972;
	Fri, 19 Sep 2025 22:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZkNcRkZV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A79EE301489
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 22:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758321252; cv=none; b=Avd58aHmseW76OdGmeLRkoWqW85ZyVCi4Qo1sBeJ1IJggABI20uVyBgNN99u7blPy6DodKeyyPvOF1qOce3VwXMqxH7pwpA2YtuWFjeatZt34/cGwiKeMr8PUhRU7gpRlDBweTfZMxSLXvbl0Dix0AlTF+C6LhJcD/jozw06dLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758321252; c=relaxed/simple;
	bh=nKZ5Q7RgK3XRxdc3o7cKqV6DWFuIWGsdh+EcSzBiSww=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lnQ2dEzVEzeVDNlZSSyf6IhGi7MEFUY6Di8QL4QXrdW+T+VnxzCtz9cNS8HMhLu4q8WPMDrNTKO2GQWaKQEObHB7qBFBoUAaB5MYqWmdx3qvWZlTZan2kwsmq7pxO+KboVq/Gz6ZQWzh3/4Q+bSvdDcrO0dhUlG7TuiEJ9NaM94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZkNcRkZV; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32ee62ed6beso3496974a91.2
        for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 15:34:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758321250; x=1758926050; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=cYHRrx1Rwo9eQXWeqWJXpUpu9aJ7cOqVN25IkcGdX1A=;
        b=ZkNcRkZV/lVfWvgwZpfuXapRTN2IuUSGBZt5f/46+pFyf/J63unGfnM9z/hZmHnRMO
         XQGmwxb0Ix3BPmIEPO5Drl4Q63sHzRPn+C3eDFndrT7Ilz7RmrcmhBb4WE5Czwv87GhQ
         UjvINhQWdcxKsa3AQOxcpbeCIapWXZEgOcR1onzU5lM9x6VGZOLzw/3sQpa4MRl97QdT
         Agh7fIwY/bEljUWD5YD1EDYC7kuwuWS9ys4IfC62nzjBAGhGabZ9SeqJEHi2OeJDr1hb
         /HaNyv7MBr2MW3I4ldUAU5dPR17b4qpt8tTEy5g0BrrSO5KiUzv1rK2Fth7WoU7x351z
         HUnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758321250; x=1758926050;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cYHRrx1Rwo9eQXWeqWJXpUpu9aJ7cOqVN25IkcGdX1A=;
        b=hHLdBvXom+IbhqI4nCmu/80WsdcfJX+s+yet/zBbKoUUyKrHjFKcIYASX+uJ5KWPuS
         yeOqI6mwtf6JTQG8ZAKOBt40N8u1PsDAjvJLTapnzKubUzKoEvSPZiHvYpek3yPQM5DI
         4wtJUx/1rg/LudGM3OLA5sSR97jri2ISVVE8ngsy3dM+yyYmbeYKvykFZxeJ6JogOaWC
         E0S3aHfdvBiZ7Rybwoy2C925weHZvPhO7KCHi6xUdeK9oUV5qBX8Npr+z1RRozc3I4F/
         Z9Iz+rK8KWBuk/JZ8K8eGt4XMNR7NqAwRaTFo/F1F2Th5WZhlQpmrlWdsDzSNQ2/GKkz
         HHjw==
X-Gm-Message-State: AOJu0YwSvUb+1xGKUvzFkz2dX0y9dKqHzM6r7yORw2WfYwepFD7sDeHV
	ArsESzQ6mKUk5RpkvSmc7Ov91t8za1jVALGAgM62u8D+Fx9JXhTsLSLWBuipt54ndqSH6Pq/RKe
	lCkG3Sw==
X-Google-Smtp-Source: AGHT+IEW7HITViOOE/8pfh1gBFeALqS2Mwkwb0jK0TfcwCqmDCr4DL2x+WvNHZBBQhSy5ImpJhKVudjl1j8=
X-Received: from pjbpd9.prod.google.com ([2002:a17:90b:1dc9:b0:32b:5548:d659])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d60c:b0:32e:8c1e:1301
 with SMTP id 98e67ed59e1d1-3309838dec4mr5848473a91.34.1758321249933; Fri, 19
 Sep 2025 15:34:09 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 19 Sep 2025 15:32:43 -0700
In-Reply-To: <20250919223258.1604852-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919223258.1604852-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
Message-ID: <20250919223258.1604852-37-seanjc@google.com>
Subject: [PATCH v16 36/51] KVM: nSVM: Save/load CET Shadow Stack state to/from vmcb12/vmcb02
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Zhang Yi Z <yi.z.zhang@linux.intel.com>, Xin Li <xin@zytor.com>
Content-Type: text/plain; charset="UTF-8"

Transfer the three CET Shadow Stack VMCB fields (S_CET, ISST_ADDR, and
SSP) on VMRUN, #VMEXIT, and loading nested state (saving nested state
simply copies the entire save area).  SVM doesn't provide a way to
disallow L1 from enabling Shadow Stacks for L2, i.e. KVM *must* provide
nested support before advertising SHSTK to userspace.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/nested.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 826473f2d7c7..a6443feab252 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -636,6 +636,14 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12
 		vmcb_mark_dirty(vmcb02, VMCB_DT);
 	}
 
+	if (guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK) &&
+	    (unlikely(new_vmcb12 || vmcb_is_dirty(vmcb12, VMCB_CET)))) {
+		vmcb02->save.s_cet  = vmcb12->save.s_cet;
+		vmcb02->save.isst_addr = vmcb12->save.isst_addr;
+		vmcb02->save.ssp = vmcb12->save.ssp;
+		vmcb_mark_dirty(vmcb02, VMCB_CET);
+	}
+
 	kvm_set_rflags(vcpu, vmcb12->save.rflags | X86_EFLAGS_FIXED);
 
 	svm_set_efer(vcpu, svm->nested.save.efer);
@@ -1044,6 +1052,12 @@ void svm_copy_vmrun_state(struct vmcb_save_area *to_save,
 	to_save->rsp = from_save->rsp;
 	to_save->rip = from_save->rip;
 	to_save->cpl = 0;
+
+	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK)) {
+		to_save->s_cet  = from_save->s_cet;
+		to_save->isst_addr = from_save->isst_addr;
+		to_save->ssp = from_save->ssp;
+	}
 }
 
 void svm_copy_vmloadsave_state(struct vmcb *to_vmcb, struct vmcb *from_vmcb)
@@ -1111,6 +1125,12 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	vmcb12->save.dr6    = svm->vcpu.arch.dr6;
 	vmcb12->save.cpl    = vmcb02->save.cpl;
 
+	if (guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK)) {
+		vmcb12->save.s_cet	= vmcb02->save.s_cet;
+		vmcb12->save.isst_addr	= vmcb02->save.isst_addr;
+		vmcb12->save.ssp	= vmcb02->save.ssp;
+	}
+
 	vmcb12->control.int_state         = vmcb02->control.int_state;
 	vmcb12->control.exit_code         = vmcb02->control.exit_code;
 	vmcb12->control.exit_code_hi      = vmcb02->control.exit_code_hi;
-- 
2.51.0.470.ga7dc726c21-goog


