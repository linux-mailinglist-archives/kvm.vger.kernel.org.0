Return-Path: <kvm+bounces-42399-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 581AEA7828F
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 21:04:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4122D7A4A2C
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 19:03:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DD52213236;
	Tue,  1 Apr 2025 19:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="V9UcA72f"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C71F2054EF
	for <kvm@vger.kernel.org>; Tue,  1 Apr 2025 19:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743534271; cv=none; b=phGSKhmFubh88rfby2YN35uvk8FIHlPazxiCsCjgKa/gws68Cev0kvt3zcnxSSRbVxPItmMSOs17/+GtFfsndS5zSulEpb8Z2UJTbQx3qPshkwlNp/PJxs1G6Fg4S4Af0nIFB64i9n+Ft07gFJiNYmEVi1Y2sBwoTJyoC0FKmyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743534271; c=relaxed/simple;
	bh=ZA8WLLQSRnBdeI7oPmhuG3QFKCFrkE3uu8PKti+PBHQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=sBKjqwskE9AaoaEmsCeLN9aqk27cagJ65b8rTaC4e7EpknCRcRfvNSjmac7neYgZVJW6YFcz6KBAe+yXbg69bJbcvPT8/Y6TmegVkUh3bpvLtNp3y33Jm5pRnotD2P0k4PlDl/Som73tWa+8Os9iLhdKrTF6QpXaafWlEqcOtnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=V9UcA72f; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743534269;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/LKDYucSS97pnhgHvj6/5ba13WSnYs1hpEZo6Z/7tAc=;
	b=V9UcA72fALJJm3lD8dRRvzhT72hBH9gVdtVfGiyPBnFJTGdzJNDGy6zm1xhEVnVKUmC+Gl
	uU/yoaY7djXMGSCqP6e506PfwZEFBfqSJ8TaDFTRgwHyIBpQQ4iw3XO8H3+PgR8OPZSBM/
	3P3O9BWsXuSLeB+fI3YEshdST73BIfA=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-687-dVPcD9q7Oz-b_Eqc-nalrg-1; Tue, 01 Apr 2025 15:04:26 -0400
X-MC-Unique: dVPcD9q7Oz-b_Eqc-nalrg-1
X-Mimecast-MFC-AGG-ID: dVPcD9q7Oz-b_Eqc-nalrg_1743534265
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-6e8f6443ed5so2488436d6.1
        for <kvm@vger.kernel.org>; Tue, 01 Apr 2025 12:04:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743534265; x=1744139065;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/LKDYucSS97pnhgHvj6/5ba13WSnYs1hpEZo6Z/7tAc=;
        b=mWWXHJs45N+NiJrrbdfsvzLtNVIgNq9Jp0okq9rV71CNPmENE9T2Rq7whsEx3Wc6JS
         LDoZEIWTY6rY1WEOYXERUozZnhly4q90Bu2Gbxum3PJmtPRQv0omVd8196gDkeBy9ICx
         W2wPZYELoK9iYImjUoFky15mITvFYdwOC/2n89M85y5U15lovPlq7fDcPRMnIhrLMZNT
         zoJ1yWQXidRBhPBBrETpW2Jyuky7X4mOl3S1oauDq1TDqE12sY9nxxdUsj7WxhkqVFjw
         VdZ6JsZH0dCjOV7k78fNYmWbbVmq4J9Dp0zA25x6tKuTwIQKfN0JwsK0bd2SFOzaj1vP
         o9Mg==
X-Gm-Message-State: AOJu0Yz2mmZNiDzPpwKwPJFcDaeNxbky6Fl3NoCfLyua0diSqUpJvYcl
	4v8yJLqi8rvgJku5nIZ/qHTUo3zDLXy92EL+gtEmG7MECh44qsTHrMZcasdSXTFkgq9wZ7nNCkA
	jRgFtWfiecyqFwA+yXz0U1Mi6WH3cxZFsCqEIYCJcgpAYHeoHbw==
X-Gm-Gg: ASbGncstv4d0wur0mORFQ/tYwFh+PXAvuJLdvrZe0kJ8is5kOsnl242ewIoz0smXvto
	35f4Ojqu/jwZorodIJ3nboMz+WE/DYGDca1Zg5XNi6LGei4tMFrs++yMLniWjoOvt3deMZoy5CU
	neVDCJYwM7gdDXAKM9/VCsdJR571gh5xMxVa5dyxd6HrGDYIgZMriJMIYTck0zhl8enVaG8B3I6
	JoQ+L/vOCfpFTrcsz1ndTmINjRQYPqICPwjavDoJ6E33O4gSmNpfBL/AjNnOnE2VVqXTz1VOgOS
	b/FYjkXcxED1CMQ=
X-Received: by 2002:a0c:ed2f:0:b0:6e8:f387:e0d2 with SMTP id 6a1803df08f44-6ef007f4899mr13121756d6.11.1743534265656;
        Tue, 01 Apr 2025 12:04:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IECRXXZWchA57oOedz8AT78HpF5eHX9r+gsD8ZcFuy0bS8m37e7vAC5QG33T44tol8BiKAbdw==
X-Received: by 2002:a0c:ed2f:0:b0:6e8:f387:e0d2 with SMTP id 6a1803df08f44-6ef007f4899mr13121496d6.11.1743534265400;
        Tue, 01 Apr 2025 12:04:25 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6eec965a40bsm64992426d6.61.2025.04.01.12.04.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Apr 2025 12:04:25 -0700 (PDT)
Message-ID: <7ddba836af37493764c56098a46aad7ee202b6ba.camel@redhat.com>
Subject: Re: [PATCH 1/2] KVM: VMX: Assert that IRQs are disabled when
 putting vCPU on PI wakeup list
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Yan Zhao
	 <yan.y.zhao@intel.com>
Date: Tue, 01 Apr 2025 15:04:24 -0400
In-Reply-To: <20250401154727.835231-2-seanjc@google.com>
References: <20250401154727.835231-1-seanjc@google.com>
	 <20250401154727.835231-2-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Tue, 2025-04-01 at 08:47 -0700, Sean Christopherson wrote:
> Assert that IRQs are already disabled when putting a vCPU on a CPU's PI
> wakeup list, as opposed to saving/disabling+restoring IRQs.  KVM relies on
> IRQs being disabled until the vCPU task is fully scheduled out, i.e. until
> the scheduler has dropped all of its per-CPU locks (e.g. for the runqueue),
> as attempting to wake the task while it's being scheduled out could lead
> to deadlock.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/posted_intr.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
> index ec08fa3caf43..840d435229a8 100644
> --- a/arch/x86/kvm/vmx/posted_intr.c
> +++ b/arch/x86/kvm/vmx/posted_intr.c
> @@ -148,9 +148,8 @@ static void pi_enable_wakeup_handler(struct kvm_vcpu *vcpu)
>  	struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
>  	struct pi_desc old, new;
> -	unsigned long flags;
>  
> -	local_irq_save(flags);
> +	lockdep_assert_irqs_disabled();
>  
>  	raw_spin_lock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
>  	list_add_tail(&vmx->pi_wakeup_list,
> @@ -176,8 +175,6 @@ static void pi_enable_wakeup_handler(struct kvm_vcpu *vcpu)
>  	 */
>  	if (pi_test_on(&new))
>  		__apic_send_IPI_self(POSTED_INTR_WAKEUP_VECTOR);
> -
> -	local_irq_restore(flags);
>  }
>  
>  static bool vmx_needs_pi_wakeup(struct kvm_vcpu *vcpu)


Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


