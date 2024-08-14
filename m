Return-Path: <kvm+bounces-24154-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 84016951E1F
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 17:08:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3B4131F22A54
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 15:08:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4448F1B3F31;
	Wed, 14 Aug 2024 15:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="C6h+AwkI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92A161B0137
	for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 15:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723648090; cv=none; b=YICzWQ+xBNP28kzD9s7284H4FpiG68bArb3+6Ma5uy+KBg/SXkVfZY3MMMQTMKjAvq0to79TEktj+bQPKobJzZisBUoFBrYb8rkiy5SglBYIyN/3sBtYgKlwGIhiAbAKYXtX5a5RCAtlsaZ5pF3ab6dhA6hln8KK5aY4LDeOmZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723648090; c=relaxed/simple;
	bh=Oq75bF6b7Xsf6oaRIc8eb6zXZ+JAV3xZdtoY0XlEz1s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=G6gMjw2/zWIG+SNccyrXfv9yw4AMTlRpdu/BM/e7Pvlpk7G+qM74LtJi0o5TWqAzg4uIndsNRAFJGAC3f0VAITxCUVk4yKEjyWqpU4UX3N87lmd/HfBDHbhOtAS5bXUu9sgT9uO6DiueelhMn5smtXOl6B5g3Q65WX+1c26UyYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=C6h+AwkI; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7a30753fe30so15970a12.3
        for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 08:08:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723648088; x=1724252888; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yoJQXmjJ2IVbbFRZhVVje/CJkcjIPZibKaR4ShslcHA=;
        b=C6h+AwkI0P/r/ti5DuS3cs6m8ZePqjV+r+EgwJ8k72cNep7Gla20DGmFKb6xLKoV7x
         se89resCetyD1XuYMDYIcZ0eX9DqgDLvI6jGC5sxWOVt4YdH2zn/q8USAqrI+IPVuuug
         0K2NdoOABoFcFaybw+qYuJ6p4K1k79sPKrWjWhji72FVvNEtunXRAmSY99rgdP7XclIm
         S0EUyaSwlizowGxG3pS82wAY9t7V+pIUcFNlw8wBAkuj9a7UV/kS9RRa4Z1IJNgr0PxX
         jhsNgyq/A/cJT2ufBnW/on4LAenIzSLWXt6JfH4Ybo9RRUbK28/P4u6fCR0dVDWC+tu/
         LprQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723648088; x=1724252888;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yoJQXmjJ2IVbbFRZhVVje/CJkcjIPZibKaR4ShslcHA=;
        b=hBw54yV690XKCj9RlH9ivBtuuH2SAyJvowFfQ55X7a0gJu7pWe1uaRFfR/T6dISzEV
         0D8I1PpuL/zsmHtyvLLNXSdnDtwqfcTJwRrfZ+YyM1nZ5KN57mmHu6adjrOAHuxIpBMf
         nH73nuHQ/14U90iqHq/6I1epFEbx2RV9+KDcpwRVK4CpIZSug7y2afwgfpm0k09AVo5j
         aZwru/by7VCFgNBW1lAUrMOKgzT6GD5HWfGH0oXZjCmuO32UrjKPMaSRUoDinT9Hj41i
         eQVGBGzRpMSHzpGnqsukJrbJvRTbyo9sM3EDg/jYc5CgO8hvY/PFnUzkq9xQe51wubVM
         zN+w==
X-Forwarded-Encrypted: i=1; AJvYcCUw0v+txNKgo3+/BAdHMD/DnW29ooF3ZzixpqLPwB0f7pZ2vpS/3NvrNzg4ivl6WUj+7hwkvAqVZSAM639G/5Kwt06k
X-Gm-Message-State: AOJu0YzhWIj2kR00gcTBMMfy0cBvAvLfdLYiEHLIdB41neqs52V/M/Uk
	/MWL6xw/YtObfjDVV6Bco0I66INhbyM5DBll6HMxfYlvgvZyNeqQlnTZLLLRkSkgA8II7MYJIeq
	7Uw==
X-Google-Smtp-Source: AGHT+IFSo0qHJU5DQKCgeqRIDwH7U8xGwP62B3Xnf0u1/CK6HYU/5v7+V60gWz2HotfzMrnqap4rQiN4yTs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:155a:0:b0:7a0:d530:86b8 with SMTP id
 41be03b00d2f7-7c6a568e1afmr5246a12.2.1723648087768; Wed, 14 Aug 2024 08:08:07
 -0700 (PDT)
Date: Wed, 14 Aug 2024 08:08:06 -0700
In-Reply-To: <87plqbfq7o.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <b44227c5-5af6-4243-8ed9-2b8cdc0e5325@gmail.com>
 <Zpq2Lqd5nFnA0VO-@google.com> <207a5c75-b6ad-4bfb-b436-07d4a3353003@gmail.com>
 <87a5i05nqj.fsf@redhat.com> <b20eded4-0663-49fb-ba88-5ff002a38a7f@gmail.com> <87plqbfq7o.fsf@redhat.com>
Message-ID: <ZrzIVnkLqcbUKVDZ@google.com>
Subject: Re: [BUG] =?utf-8?Q?arch=2Fx86=2Fkvm=2Fvmx?= =?utf-8?Q?=2Fvmx=5Fonhyperv=2Eh=3A109=3A36=3A_error=3A_dereference_of_NUL?=
 =?utf-8?B?TCDigJgw4oCZ?=
From: Sean Christopherson <seanjc@google.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Mirsad Todorovac <mtodorovac69@gmail.com>, kvm@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Aug 14, 2024, Vitaly Kuznetsov wrote:
> What I meant is something along these lines (untested):
> 
> diff --git a/arch/x86/kvm/vmx/vmx_onhyperv.h b/arch/x86/kvm/vmx/vmx_onhyperv.h
> index eb48153bfd73..e2d8c67d0cad 100644
> --- a/arch/x86/kvm/vmx/vmx_onhyperv.h
> +++ b/arch/x86/kvm/vmx/vmx_onhyperv.h
> @@ -104,6 +104,14 @@ static inline void evmcs_load(u64 phys_addr)
>         struct hv_vp_assist_page *vp_ap =
>                 hv_get_vp_assist_page(smp_processor_id());
>  
> +       /*
> +        * When enabling eVMCS, KVM verifies that every CPU has a valid hv_vp_assist_page()
> +        * and aborts enabling the feature otherwise. CPU onlining path is also checked in
> +        * vmx_hardware_enable(). With this, it is impossible to reach here with vp_ap == NULL
> +        * but compilers may still complain.
> +        */
> +       BUG_ON(!vp_ap);

A full BUG_ON() is overkill, and easily avoided.  If we want to add a sanity
check here and do more than just WARN, then it's easy enough to plumb in @vcpu
and make this a KVM_BUG_ON() so that the VM dies, i.e. so that KVM doesn't risk
corrupting the guest somehow.

> +
>         if (current_evmcs->hv_enlightenments_control.nested_flush_hypercall)
>                 vp_ap->nested_control.features.directhypercall = 1;
>         vp_ap->current_nested_vmcs = phys_addr;
> 
> the BUG_ON() will silence compiler warning as well as become a sentinel
> for future code changes.
> 
> -- 
> Vitaly
> 

