Return-Path: <kvm+bounces-7209-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id ECB4C83E377
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 21:45:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7BD3B1F25A29
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 20:45:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AAB0249FD;
	Fri, 26 Jan 2024 20:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rhFKVmiY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4232E249E7
	for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 20:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706301941; cv=none; b=WLQTdFQ10rD7JW6sn67KCh7dKAAqj4TbrnjXWM86QzU+6eALUn4cECZV9B91cOhIe3HKUb4R/k1uPzHQdsYBv/KbPGRoFTvqJiFYpsU2MrY/PoZf/9Wm3SjFFe3xeIX6sDuvh9sAT3PvX5tywzbTmDJHFjrW4FhLebhGmZRRDGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706301941; c=relaxed/simple;
	bh=AR00ZdH4/5Wfh7jYkpxm+znKN3mGgWgLukY4Sbe2M+E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rraNBgua7llr53gyLthUAxPuw1VRtVwK2+NlP/BkGjfxzAFL/CbZGE4NuGJyB5SwHgRl407UBINvCcN8uJ/rpUdYeVu7OoaE6dCcOscbYgEN6azt5ULE3xs8ftb+eOMDDlCGM4RRS6mPhaaHzhuamqg3zlTjQWHAVuJMS5XU1bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rhFKVmiY; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc221ed88d9so1016381276.3
        for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 12:45:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706301939; x=1706906739; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=c/zXnSdVBxJIdFgt/Z8mS/8aj0AyZX20d8Uo3SKEayQ=;
        b=rhFKVmiYS6/0LioW65/xGKBBjEnfHLYTx7haKKWcqdjyQrA3FlHvxEwSQOwVFBnpRD
         kzeGkxX03Sc0zRiD9mKBsL5EjCtEnIk1+1dEiLCm3DPxqfFFiRTe826xtuN+4OmfNCpT
         fUAb2PeC7II5aQbWq6zs9AssDCpBufzJnu1mdPymHZlFeX5SGdjsXQHtpx6sU5ZuG2Im
         pyjeARbA4+yDhCFf1KYsP9DEVQaR5FUvwuxMgonO1z+ZgseGmgvQVH1bK3iodamuPyRt
         hC1P03wm2SXAjVe/QpOXlNGHxU4mde+kwZNFFCpa/kRT9DdIhmGFFfDgjX8avIGaEaZU
         W41A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706301939; x=1706906739;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=c/zXnSdVBxJIdFgt/Z8mS/8aj0AyZX20d8Uo3SKEayQ=;
        b=hCbQdgNZdEhSJVoEQLN7ujRQ5HQjBeLC9+Ofg+yoMYpb86kJ/Zx9IcxkpSy+pnsVCd
         E7x7nBcB5nzbPheh9ACcI+5wq3wenfmWnbCdKGbeHa9OZLvtx2Ycrgc4giBvgyHpnT8o
         1hYhNTUnP6L0AVNUq2EVSIZJJzRcbiKY6gxMtnme1n8Gs+7I6ixkxDqzq5CAu3a09EFg
         A3y1BLgTN1vtPHPqBYugyW9J5vJ+D18jwAve6KWue3P1Tw5cWqUhod4VKF0dprQ2Sw0v
         JY5uofd8jJOTq8AL+2335M5znmYqYs2OYK0DPur9UQB1VUgAShy8YVgFIjxL24lEOzBH
         S/uA==
X-Gm-Message-State: AOJu0YxsyEYvkp74Y/W68PpNJFiiF6YLk8BNgz9CPXlbYiSOkcT8RQjB
	kN5G/oOZ9Z29M9YK9fJWt14aArFB1Pwmlg/TdU/fm8YzQ3oBAtHKhW1DJUC8NHegMntz6Q+EYlV
	iGQ==
X-Google-Smtp-Source: AGHT+IG3knhTrkB5CiIUNLngmdV4SDRGVWsRIsLODIVC0Ls5IJlYuizZ+Nj4uuQ6VbxZg7aYE3RvS+x9tTQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1a47:b0:dbd:73bd:e55a with SMTP id
 cy7-20020a0569021a4700b00dbd73bde55amr60015ybb.4.1706301939311; Fri, 26 Jan
 2024 12:45:39 -0800 (PST)
Date: Fri, 26 Jan 2024 12:45:37 -0800
In-Reply-To: <20240112065159.982-1-robert.hoo.linux@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240112065159.982-1-robert.hoo.linux@gmail.com>
Message-ID: <ZbQZ8SSBy74HeD7h@google.com>
Subject: Re: [PATCH] KVM: VMX: Correct *intr_info content and *info2 for
 EPT_VIOLATION in get_exit_info()
From: Sean Christopherson <seanjc@google.com>
To: Robert Hoo <robert.hoo.linux@gmail.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Jan 12, 2024, Robert Hoo wrote:
> Fill vmx::idt_vectoring_info in *intr_info, to align with
> svm_get_exit_info(), where *intr_info is for complement information about
> intercepts occurring during event delivery through IDT (APM 15.7.2
> Intercepts During IDT Interrupt Delivery), whose counterpart in
> VMX is IDT_VECTORING_INFO_FIELD (SDM 25.9.3 Information for VM Exits
> That Occur During Event Delivery), rather than VM_EXIT_INTR_INFO.
> 
> Fill *info2 with GUEST_PHYSICAL_ADDRESS in case of EPT_VIOLATION, also
> to align with SVM. It can be filled with other info for different exit
> reasons, like SVM's EXITINFO2.

Nothing in here says *why*.

> Fixes: 235ba74f008d ("KVM: x86: Add intr/vectoring info and error code to kvm_exit tracepoint")
> Signed-off-by: Robert Hoo <robert.hoo.linux@gmail.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 20 ++++++++++++++++----
>  1 file changed, 16 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index d21f55f323ea..f1bf9f1fc561 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6141,14 +6141,26 @@ static void vmx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
>  
>  	*reason = vmx->exit_reason.full;
>  	*info1 = vmx_get_exit_qual(vcpu);
> +
>  	if (!(vmx->exit_reason.failed_vmentry)) {
> -		*info2 = vmx->idt_vectoring_info;
> -		*intr_info = vmx_get_intr_info(vcpu);
> +		*intr_info = vmx->idt_vectoring_info;
>  		if (is_exception_with_error_code(*intr_info))
> -			*error_code = vmcs_read32(VM_EXIT_INTR_ERROR_CODE);
> +			*error_code = vmcs_read32(IDT_VECTORING_ERROR_CODE);
>  		else
>  			*error_code = 0;
> -	} else {
> +
> +		/* various *info2 semantics according to exit reason */
> +		switch (vmx->exit_reason.basic) {
> +		case EXIT_REASON_EPT_VIOLATION:
> +			*info2 = vmcs_read64(GUEST_PHYSICAL_ADDRESS);
> +			break;
> +		/* To do: *info2 for other exit reasons */

I really, really don't want to go down this road.  As I stated in a different,
similar thread[*], I don't think this approach is sustainable.  I would much
rather people put time and effort into (a) developing BPF programs to extract info
from the VM-Entry and VM-Exit paths, (b) enhancing KVM in the areas where it's
painful or impossible for a BPF program to get at interesting data, and (c) start
upstreaming the BPF programs, e.g. somewhere in tools/.

[*] https://lore.kernel.org/all/ZRNC5IKXDq1yv0v3@google.com

