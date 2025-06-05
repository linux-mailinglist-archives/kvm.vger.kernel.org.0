Return-Path: <kvm+bounces-48565-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FEF6ACF47F
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 18:39:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E0E961891EBC
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 16:39:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEE8A274FD4;
	Thu,  5 Jun 2025 16:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xMaBO2hv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B247274FC1
	for <kvm@vger.kernel.org>; Thu,  5 Jun 2025 16:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749141562; cv=none; b=s7xP9e6uJyyKbXbI7OlRUr8Nz/iY9xtdcXtVo6acOLioRYpMZXBgPyIOB73qW6DwHykZ8JXIdpUX8kQHAWRPa1JlFxwqiXX5T3jnov0KenxtQ+pTmr7Ih8olczjFNd+XlnnrvJKc5s8ktqv35usRJp/d5P6odoX6WUSR62Wk+eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749141562; c=relaxed/simple;
	bh=H1YPp6+o+p2q7dIafkj50JICd7zLoaIKYOyffRXuexQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ImoIfCWyjHrdOkyN8EwCqtolCi3R58mAeczBV/MKDNYLqjEQaWw2oZyg5AyhXmBl8nhY9D5+7PjYJ7s5shk/II9e94L+E9mKG4ZhC5qr6N/P7m3o2LRCSqhOQtP5x5IF2D0g6qNlKF7T3DvsdIVkoJ0EFvCd9sLIEQcK9LIxFVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xMaBO2hv; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-311fa374c2fso1938742a91.2
        for <kvm@vger.kernel.org>; Thu, 05 Jun 2025 09:39:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749141560; x=1749746360; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RLHLJ72ZskhzqHD5wQqoMHh6pl0NfS3wNoq8ri0R1wo=;
        b=xMaBO2hv+9j/r5I4E+Sgxb4MvmXBE7t0MX8IjJiuC4Hd/Bh8Qniz0nFS7u0fjlp9pY
         HoppUpb9NPJEjQH5M89QYLXHxbsrwLLQpbce0kUfiNSXLz1UEt2Kab1nlI0FyFrYODMz
         EahrxdpEUnFF/L4+6HzSoZ92NNCieakk5YC+hWkE2ehrLOvXz53cFNL3r987HKoo274b
         VF7nvmjhpognsEkDjLx7CnuYQ9QmgicHvGsetOYyJsO3SYsM2V4+69lSgF7qpfzk15K3
         4lu7ciXiidf+baqAgzynEkvOND6a0CatG4T3MfpRsQkjXieu9YpBBsAOHHVbmchNFx9j
         Up1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749141560; x=1749746360;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RLHLJ72ZskhzqHD5wQqoMHh6pl0NfS3wNoq8ri0R1wo=;
        b=qmDGQI0HjxbmIbokIm+6QRPCnJ4NVOylBXxqHshj1MJLCKkNUPvLa5uguSOSHRyEv4
         kPQzqqs7knSi5L3B8eMp3Il9+hXIFMAYRlF0y1UXEDD4hOwfUXIO9jcDfsMSOgmMPqq9
         1EAyuR5Dsxg2G1kaQHJ4qpSx5LVW1RTTfpubG2qs2HkOb6C25pQbAo2j2wuUnTaB9RFf
         RguKNIN0ZBf7CAXWVNVGLe8S97zQ0HNo4kSd/nJPg81ENcObRkMFkfSZ2oPX+QynUak7
         l0ZW5Vv3gYCqnD0melDqWTQkzpFwI75Drc6kQw9jVPTdfykdIBg93lNQATbrkA0h8ez8
         0m/w==
X-Forwarded-Encrypted: i=1; AJvYcCUT/uyxoQlkojTBiod1ZQGaxvMxzDD+Pyw2yXBDm9m8Hl7oWhqpbZ6+7GV9kH2JuBcltzg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzxOFKdHaOYL4eUZQAigfex4uoiKatnKjvoEz7hfdOcyqQaHlXD
	b4kUkXxVe/46TpF4XXUDkNOZD8RReW+vljfZJJEZ8czT/H32Eta5rHzwNVhes720yTfgZHz2/9v
	06fKOSQ==
X-Google-Smtp-Source: AGHT+IFvFrLqHR1ghrQGa/UNDi1qRfKtC9i6a3FVhMJPpt61M52gk1rUWTLvFny4IIdNm62PLyCcaiVBrlM=
X-Received: from pjbqb9.prod.google.com ([2002:a17:90b:2809:b0:2ef:d283:5089])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3f8c:b0:311:df4b:4b81
 with SMTP id 98e67ed59e1d1-313470578eamr495536a91.25.1749141559893; Thu, 05
 Jun 2025 09:39:19 -0700 (PDT)
Date: Thu, 5 Jun 2025 09:39:18 -0700
In-Reply-To: <aEE4BEHAHdhNTGoG@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250529234013.3826933-1-seanjc@google.com> <20250529234013.3826933-18-seanjc@google.com>
 <aEE4BEHAHdhNTGoG@intel.com>
Message-ID: <aEHINux8hnYC6HC7@google.com>
Subject: Re: [PATCH 17/28] KVM: SVM: Manually recalc all MSR intercepts on
 userspace MSR filter change
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Borislav Petkov <bp@alien8.de>, Xin Li <xin@zytor.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Jun 05, 2025, Chao Gao wrote:
> >+static void svm_recalc_msr_intercepts(struct kvm_vcpu *vcpu)
> >+{
> >+	struct vcpu_svm *svm = to_svm(vcpu);
> >+
> >+	svm_vcpu_init_msrpm(vcpu);
> >+
> >+	if (lbrv)
> >+		svm_recalc_lbr_msr_intercepts(vcpu);
> >+
> >+	if (boot_cpu_has(X86_FEATURE_IBPB))
> >+		svm_set_intercept_for_msr(vcpu, MSR_IA32_PRED_CMD, MSR_TYPE_W,
> >+					  !guest_has_pred_cmd_msr(vcpu));
> >+
> >+	if (boot_cpu_has(X86_FEATURE_FLUSH_L1D))
> >+		svm_set_intercept_for_msr(vcpu, MSR_IA32_FLUSH_CMD, MSR_TYPE_W,
> >+					  !guest_cpu_cap_has(vcpu, X86_FEATURE_FLUSH_L1D));
> >+
> >+	/*
> >+	 * Unconditionally disable interception of SPEC_CTRL if V_SPEC_CTRL is
> >+	 * supported, i.e. if VMRUN/#VMEXIT context switch MSR_IA32_SPEC_CTRL.
> >+	 */

Tangentially related, the comment above isn't quite correct.  MSR_IA32_SPEC_CTRL
isn't purely context switched, the CPU merges together host and guest values.
Same end result though: KVM doesn't need to manually context switch the MSR.

> >+	if (boot_cpu_has(X86_FEATURE_V_SPEC_CTRL))
> >+		svm_disable_intercept_for_msr(vcpu, MSR_IA32_SPEC_CTRL, MSR_TYPE_RW);
> 
> I think there is a bug in the original code. KVM should inject #GP when guests
> try to access unsupported MSRs. Specifically, a guest w/o spec_ctrl support
> should get #GP when it tries to access the MSR regardless of V_SPEC_CTRL
> support on the host.
> 
> So, here should be 
> 
> 	if (boot_cpu_has(X86_FEATURE_V_SPEC_CTRL))
> 		svm_set_intercept_for_msr(vcpu, MSR_IA32_SPEC_CTRL, MSR_TYPE_RW,
> 					  !guest_has_spec_ctrl_msr(vcpu));

Right you are!  I'll slot in a patch earlier in the series, and then it'll end up
looking like this.

I'll also post a KUT testcase.

