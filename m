Return-Path: <kvm+bounces-33791-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BD0979F1B71
	for <lists+kvm@lfdr.de>; Sat, 14 Dec 2024 01:47:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id ABB4D7A0476
	for <lists+kvm@lfdr.de>; Sat, 14 Dec 2024 00:46:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76A7CD51C;
	Sat, 14 Dec 2024 00:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bLcuqXCl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 247BA6125
	for <kvm@vger.kernel.org>; Sat, 14 Dec 2024 00:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734137207; cv=none; b=ciGW/pAY+pX9PGgbk0XL5PWnrWiuGYzKUf8sJWz48bYfBiCRXiPGsQMMlbqW6aFDGGzDfMrTJrLAYyqaYqmZfNXSK81pav+jUiB4O3mYHBB5ptM2QfiqydtQgYKOBug2qUCFhNPVptBwpac1VThneYIRGr+i+szrm+eJDq7JN1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734137207; c=relaxed/simple;
	bh=YkTxbMMiawVkUIc08QsiFvVafsaiU5MkuPAXa/RhYWI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ie8qenSrdUX9OmonY7NjJM9beXOy0LyUdcaw3JIco914TWnStCoZ2s9iXidhtnqVrpOvRWHqywEZO6kYrAL/+PIU+Fz924wJP4n8bXizjvgSZJ5oqUslfm9CpzwxQIZNinMH55DU+uHWisDhqf52PPqvJTKF83FTDcDZDwrHZSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bLcuqXCl; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ef9e4c5343so3220861a91.0
        for <kvm@vger.kernel.org>; Fri, 13 Dec 2024 16:46:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734137205; x=1734742005; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4uH9336rCp9o7Yq8PJbNk6F6237Sbwya1iSdr9VCzpg=;
        b=bLcuqXClAwZxahQBXUr7LEx9at31RH5hDU+YSXbMSDH6v71Jwe8RghHBHCkmpEZb+g
         q93+ZPU81O4qnKG6VoTrwsbsfU5F2lWQ1MiezWzMPmNyl8QNO1FgI6AvStGjLCgTlEzT
         /SNue/2jrLwzN9z9DRGI+2wH3MXkymF5JF3RVN2lGJDj1F2fN7DjPu60fhEyrVoNFF6+
         /J0i2ZHecHsrbfCG9jn869H+NML4StKMXoEle0YJ0qlKENo5UAeBUXPa9y4UmmyraBgv
         C65/qJu9dSZkW20VKgE/0szQwk7gN8BlIXhva8mwGd2UlD8v59AikYgwisUmWQxHZUyO
         3sZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734137205; x=1734742005;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4uH9336rCp9o7Yq8PJbNk6F6237Sbwya1iSdr9VCzpg=;
        b=Nmq133ZADPY6BvKajg7fnjfic86PmTHhZ3uJXySBqzqY9xR0ZnfusZqdXm95CGJXJ6
         snA3WVGCArxj6ORi05Rpl1JMNiw6+lYLnzNvzherXCnc7pmluhbxG/h4280N0DXLME8s
         A8m6lezDJutUda52aySvu8Dowj3JPSD1uzqGFuwalpdeaBfE/xk0Eb6h2Vd35Vs/dtXy
         pIWaxepGJOeRs8ZE/6wFLm6Ilm3PZND+unGuxQSLIkxK6DMLYaOs3xB7AQum3rGfRxQa
         xmxNLgCHylmR1+ROG0NBIUey86togKZwhlQfUIV+MswpKTmrWiYu+aFF7PIpmk+oiTk5
         DzKg==
X-Forwarded-Encrypted: i=1; AJvYcCVmf6GLj2fFUVriYFhKluMroUbk8YkHeYKYEIo3ODcZsayfPzDwAdkaB1o1PCw2Cp8iUU8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzUzXEHu5WtMmDzH2lsLE8cs7zCvAtdNWPaQmxJnOL/so73voT9
	8JsIN6L+zxBrPAzYWuiSeYmJpWpS8eePJtGiagi2QWoOm41cL4WnJQKAkskGk6uDaERV02bRlbD
	34w==
X-Google-Smtp-Source: AGHT+IGrlB3VRB3oLaeEEoYVRywaDYxHmZ9RC6m/BQx+1F75VXWr/mwxyarKI0piG2S9euSOHNJc5lxoJ3k=
X-Received: from pjbsr5.prod.google.com ([2002:a17:90b:4e85:b0:2ef:8ef8:2701])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1646:b0:2ee:c291:7674
 with SMTP id 98e67ed59e1d1-2f28fc693eemr7225298a91.14.1734137205463; Fri, 13
 Dec 2024 16:46:45 -0800 (PST)
Date: Fri, 13 Dec 2024 16:46:43 -0800
In-Reply-To: <20241213194137.315304-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241213194137.315304-1-pbonzini@redhat.com>
Message-ID: <Z1zVc-sSJ8BHdvYJ@google.com>
Subject: Re: [PATCH] KVM: x86: clear vcpu->run->hypercall.ret before exiting
 for KVM_EXIT_HYPERCALL
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, g@google.com
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Binbin Wu <binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Dec 13, 2024, Paolo Bonzini wrote:
> QEMU up to 9.2.0 is assuming that vcpu->run->hypercall.ret is 0 on exit and
> it never modifies it when processing KVM_EXIT_HYPERCALL.  Make this explicit
> in the code, to avoid breakage when KVM starts modifying that field.
> 
> This in principle is not a good idea... It would have been much better if
> KVM had set the field to -KVM_ENOSYS from the beginning, so that a dumb
> userspace that does nothing on KVM_EXIT_HYPERCALL would tell the guest it
> does not support KVM_HC_MAP_GPA_RANGE.  However, breaking userspace is
> a Very Bad Thing, as everybody should know.
> 
> Reported-by: Binbin Wu <binbin.wu@linux.intel.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/svm/sev.c | 14 ++++++++++++++
>  arch/x86/kvm/x86.c     |  7 +++++++
>  2 files changed, 21 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 943bd074a5d3..9ffb0fb5aacd 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -3634,6 +3634,13 @@ static int snp_begin_psc_msr(struct vcpu_svm *svm, u64 ghcb_msr)
>  
>  	vcpu->run->exit_reason = KVM_EXIT_HYPERCALL;
>  	vcpu->run->hypercall.nr = KVM_HC_MAP_GPA_RANGE;
> +	/*
> +	 * In principle this should have been -KVM_ENOSYS, but userspace (QEMU <=9.2)
> +	 * assumed that vcpu->run->hypercall.ret is never changed by KVM and thus that
> +	 * it was always zero on KVM_EXIT_HYPERCALL.  Since KVM is now overwriting
> +	 * vcpu->run->hypercall.ret, ensuring that it is zero to not break QEMU.
> +	 */
> +	vcpu->run->hypercall.ret = 0;
>  	vcpu->run->hypercall.args[0] = gpa;
>  	vcpu->run->hypercall.args[1] = 1;
>  	vcpu->run->hypercall.args[2] = (op == SNP_PAGE_STATE_PRIVATE)
> @@ -3797,6 +3804,13 @@ static int snp_begin_psc(struct vcpu_svm *svm, struct psc_buffer *psc)
>  	case VMGEXIT_PSC_OP_SHARED:
>  		vcpu->run->exit_reason = KVM_EXIT_HYPERCALL;
>  		vcpu->run->hypercall.nr = KVM_HC_MAP_GPA_RANGE;
> +		/*
> +		 * In principle this should have been -KVM_ENOSYS, but userspace (QEMU <=9.2)
> +		 * assumed that vcpu->run->hypercall.ret is never changed by KVM and thus that
> +		 * it was always zero on KVM_EXIT_HYPERCALL.  Since KVM is now overwriting
> +		 * vcpu->run->hypercall.ret, ensuring that it is zero to not break QEMU.
> +		 */
> +		vcpu->run->hypercall.ret = 0;
>  		vcpu->run->hypercall.args[0] = gfn_to_gpa(gfn);
>  		vcpu->run->hypercall.args[1] = npages;
>  		vcpu->run->hypercall.args[2] = entry_start.operation == VMGEXIT_PSC_OP_PRIVATE
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 2e713480933a..705fa475179f 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10052,6 +10052,13 @@ unsigned long __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
>  
>  		vcpu->run->exit_reason        = KVM_EXIT_HYPERCALL;
>  		vcpu->run->hypercall.nr       = KVM_HC_MAP_GPA_RANGE;
> +		/*
> +		 * In principle this should have been -KVM_ENOSYS, but userspace (QEMU <=9.2)
> +		 * assumed that vcpu->run->hypercall.ret is never changed by KVM and thus that
> +		 * it was always zero on KVM_EXIT_HYPERCALL.  Since KVM is now overwriting
> +		 * vcpu->run->hypercall.ret, ensuring that it is zero to not break QEMU.
> +		 */
> +		vcpu->run->hypercall.ret = 0;

As Binbin suggested, please add a helper.  Copy-pasting multi-line comment is
especially ugly.

