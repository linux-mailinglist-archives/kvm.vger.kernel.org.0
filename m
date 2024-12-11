Return-Path: <kvm+bounces-33497-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AD1409ED48C
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 19:16:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4D4E42811BA
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 18:16:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73F62202F9D;
	Wed, 11 Dec 2024 18:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2XZTIUu7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 522AB1DB55C
	for <kvm@vger.kernel.org>; Wed, 11 Dec 2024 18:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733940968; cv=none; b=JBEgtu8jArdQmPbdpOuRwTjZ+yzcenBlzzmfc0f5KgGZbQ0tLiEs9opKoOsObO7f2NN7HotZ9SRYtoRJQM2NdG1XXVZhuzCleRA1ZdNNYq5kaCDOiEdBGo+AukR2elrVSoTru5QVp4SP+Rf6EK9lQPXCEcFfj+fYkO8IHHNbTlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733940968; c=relaxed/simple;
	bh=eMzuNypVlCf9Kg82lscOlenwY/vNl/fjamqKzyMx2EI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=glJcumEbMEK0lYKyYvoz4Z9oeqJCJ8t1FPgwfpqXimhxAO6so8/fq2n/rytJl/r4F1ZBsVU+slbsuOnkVEWKuIxdoNzjhq/HaH2GaC9Cxz64v6TL6+XBjr7EJp0lpXvE9HDmvyI9kJr7iDWUCrfipVsskQkgvSDPZ7FmR+fOqVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2XZTIUu7; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2164861e1feso36030935ad.1
        for <kvm@vger.kernel.org>; Wed, 11 Dec 2024 10:16:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733940965; x=1734545765; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2Rkf82Rck3Of1XQyRr3aB2y17npEYOSAr3hN4tIPqUw=;
        b=2XZTIUu7vJ6MXofLHEKytkQBr77YQ3YSX63EAjfffVmKFvtjxWQ7HEE3v9gAYN4NL7
         X2tsFJU2eoP87yqdWNnEn/ew6T/bkg1NXvDl4hMUWFCuxDkUWgyY8qKYdu2s4MNF+xjJ
         dIFJ4VvJ8G0GV4wPp+FPPaqm/XFUiV+3EoKl5pbJlAuoNnr/CCxikjsKheUJQnzM6o5n
         Oj4l1k2BGzFkwI365e3hQS1DG+fFGQtjsDnoc9Z3Zvt9ABcmQr2vVwtXl3Q3Acl03jO7
         nMsRD/Vkmhg3uREIgqAH83WSO3Feqprg6tq5Z+wFRnHfS95pEiLSP8Q/FPgRHmUsUzaV
         UhIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733940965; x=1734545765;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2Rkf82Rck3Of1XQyRr3aB2y17npEYOSAr3hN4tIPqUw=;
        b=PfdG7UvNEbvWsi3wCCkdweIQ0WlmV2Tdd6QC+MAF4SqlHGsSWpv7syBZLQfBnkc3R/
         lvZP1d5T4bGYJXwWWFv2vsBqLEiOx2Int8v20oDAIwtiTchgl+0sF1kPlGKth7nq5E7c
         +ZWbUf8kE1CLIAAnaoerTCJkeKc17snjM8AujncBbpRPOU/Nk1lyVPOnYuqJBn0mA6a9
         2oEazwn+aMQF5LYeNswZytPRKFQzfAGFrv9nD9b3EXvzMS5h1myokF/n1YUj5blwJAsB
         siuqHVzsNPHzpgnQS6erAcd7kRZ5xZZd61KIJGoEZksXuQw/iId0fSoFP32pX03gU/ok
         Snhw==
X-Forwarded-Encrypted: i=1; AJvYcCVfDw7hDR/MFSaVCITipmW+ap8TUr/DdodaLAwAx3EBjaSmERdY2oQxl1scK9HiIAZWmig=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz5W8wmIljuxEOivaJq4tPNNiRsoDi5fR8Cjh/oA45ANdFc3t4e
	I+UGIBma2t6WMlaYTd8wf3b66/oKabkyJXnQOieRa+Nv2HuKffdQ31oRG6g7HCbocM3xc/Vr6Th
	WhQ==
X-Google-Smtp-Source: AGHT+IGMn9egCYfVZgafQPXP1ek0EEm5+YAe7GW3QcdDpZoFy4M0KjUP+DR+0RQkWGgc58ItkqwhAHD8F3w=
X-Received: from plbw4.prod.google.com ([2002:a17:902:d3c4:b0:216:411e:f000])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ea10:b0:215:acb3:3786
 with SMTP id d9443c01a7336-2178ae5a469mr9706725ad.19.1733940965588; Wed, 11
 Dec 2024 10:16:05 -0800 (PST)
Date: Wed, 11 Dec 2024 10:16:03 -0800
In-Reply-To: <20241111102749.82761-5-iorlov@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241111102749.82761-1-iorlov@amazon.com> <20241111102749.82761-5-iorlov@amazon.com>
Message-ID: <Z1nW4xTUjWry2qF4@google.com>
Subject: Re: [PATCH v2 4/6] KVM: SVM: Handle MMIO during vectroing error
From: Sean Christopherson <seanjc@google.com>
To: Ivan Orlov <iorlov@amazon.com>
Cc: bp@alien8.de, dave.hansen@linux.intel.com, mingo@redhat.com, 
	pbonzini@redhat.com, shuah@kernel.org, tglx@linutronix.de, hpa@zytor.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, x86@kernel.org, pdurrant@amazon.co.uk, 
	dwmw@amazon.co.uk
Content-Type: text/plain; charset="us-ascii"

On Mon, Nov 11, 2024, Ivan Orlov wrote:
> Handle MMIO during vectoring error in check_emulate_instruction to
> prevent infinite loop on SVM and eliminate the difference in how the
> situation when the guest accesses MMIO during vectoring is handled on
> SVM and VMX.
> 
> Signed-off-by: Ivan Orlov <iorlov@amazon.com>
> ---
> V1 -> V2:
> - Detect the unhandleable vectoring error in svm_check_emulate_instruction
> instead of handling it in the common MMU code (which is specific for
> cached MMIO)
> 
>  arch/x86/kvm/svm/svm.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index c1e29307826b..b69f0f98c576 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4797,9 +4797,16 @@ static void svm_enable_smi_window(struct kvm_vcpu *vcpu)
>  static int svm_check_emulate_instruction(struct kvm_vcpu *vcpu, int emul_type,
>  					 void *insn, int insn_len)
>  {
> -	bool smep, smap, is_user;
> +	bool smep, smap, is_user, is_vect;
>  	u64 error_code;
>  
> +	is_vect = to_svm(vcpu)->vmcb->control.exit_int_info &
> +		  SVM_EXITINTINFO_TYPE_MASK;
> +
> +	/* Emulation is not possible when MMIO happens during event vectoring. */
> +	if (kvm_is_emul_type_mmio(emul_type) && is_vect)

Same nit here, omit the local variable.

> +		return X86EMUL_UNHANDLEABLE_VECTORING_IO;
> +
>  	/* Emulation is always possible when KVM has access to all guest state. */
>  	if (!sev_guest(vcpu->kvm))
>  		return X86EMUL_CONTINUE;
> -- 
> 2.43.0
> 

