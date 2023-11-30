Return-Path: <kvm+bounces-2829-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 47D4B7FE646
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 02:39:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 746E71C20B83
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 01:39:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1742879CF;
	Thu, 30 Nov 2023 01:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nuX6GuDg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFC3B1A3
	for <kvm@vger.kernel.org>; Wed, 29 Nov 2023 17:38:54 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-5c6072bc218so1394247a12.1
        for <kvm@vger.kernel.org>; Wed, 29 Nov 2023 17:38:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701308334; x=1701913134; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=91kgiS9Jgc7V4foMf6RxYX634vn5hfsz4EzI3W+cTWo=;
        b=nuX6GuDgAyIz/iTr6+ZvGbSvO6SMeBtIi1T5FFYoAcLp/y0aULeI+Vo8fyldfZYytn
         glK2kwcUTvsv/YVyMeJx17/K76zaYKHPP0Aq2R4Lj31IZnC6VUZLzEB+9e20j0wzGuXE
         uLlyJx1lf3A6khFG40UyfoyPZpMrQnQQJwUpp+oxj3Jx5Ui2wDa1QwTiVqXle6cLLZJX
         CHIU8LMhumrw0uiB5JcCDItGN/UyOw+BMuG8CP2TCbBnwPXIQ3AkmtzuBaP2T+OmHBzA
         W5pqY30cyfk5KM8wyu4APKQq6qZ0gEfgG9XdCECN13apSQUHj8Tfk5nsxifq/2g8bAbj
         iogQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701308334; x=1701913134;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=91kgiS9Jgc7V4foMf6RxYX634vn5hfsz4EzI3W+cTWo=;
        b=aF2CKTkJZnsPfuWGW/5zYFN71+/a3q/JlMtjxr2KyLiXL8/nGAE8SLKjQhiFDsWad5
         gL1LQwnzS8R3t+UR1fDO9WFgmD7jzBsHmQKO+57PczerC9ZFdDcp0Is4o7L2vtcO8AM0
         WOwprJefNErIJwR3U7IZkrgW2QeW7mqYg4UMzy/jQuoChW+frUprzkDlWJnvzjtJWW1k
         lvyQUl19tmne8oVGv/QNCm40DN1xGovlb/kL9CQG68gTNbeSGJcgaA8BZHhpNDU/EXo7
         1VtIKhKm99mNjXeQiDE5N5hm53Nbg3j29G/8QEj84Sb+dxaXle2YxuB0VcErzCu0aaYD
         aiPQ==
X-Gm-Message-State: AOJu0Yzi2bfToDnlnEZOQlRQZP6BjHYQFBjRAHnAsmwCjrQeWOrquPfK
	Wr9iQawn81PxLhkS/wyLn9mVurJC/mU=
X-Google-Smtp-Source: AGHT+IHqBZdQMIJiW1i3yuviz3YDYA+PL7MJ4JYi8vfwzPkJ3zkNWNdLJVW06CEFNlmCV6zclnL/NgvK92I=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:1a8c:b0:285:b3a1:3943 with SMTP id
 ng12-20020a17090b1a8c00b00285b3a13943mr3509774pjb.3.1701308334357; Wed, 29
 Nov 2023 17:38:54 -0800 (PST)
Date: Wed, 29 Nov 2023 17:38:52 -0800
In-Reply-To: <20231025152406.1879274-11-vkuznets@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231025152406.1879274-1-vkuznets@redhat.com> <20231025152406.1879274-11-vkuznets@redhat.com>
Message-ID: <ZWfnrLyLUS2_viVS@google.com>
Subject: Re: [PATCH 10/14] KVM: x86: Make Hyper-V emulation optional
From: Sean Christopherson <seanjc@google.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Oct 25, 2023, Vitaly Kuznetsov wrote:
> @@ -1570,6 +1572,7 @@ static void copy_vmcs12_to_shadow(struct vcpu_vmx *vmx)
>  	vmcs_load(vmx->loaded_vmcs->vmcs);
>  }
>  
> +#ifdef CONFIG_KVM_HYPERV
>  static void copy_enlightened_to_vmcs12(struct vcpu_vmx *vmx, u32 hv_clean_fields)
>  {
>  	struct vmcs12 *vmcs12 = vmx->nested.cached_vmcs12;
> @@ -2077,6 +2080,10 @@ static enum nested_evmptrld_status nested_vmx_handle_enlightened_vmptrld(
>  
>  	return EVMPTRLD_SUCCEEDED;
>  }
> +#else /* CONFIG_KVM_HYPERV */
> +static inline void copy_enlightened_to_vmcs12(struct vcpu_vmx *vmx, u32 hv_clean_fields) {}
> +static inline void copy_vmcs12_to_enlightened(struct vcpu_vmx *vmx) {}

I'm not sure I love the stubs in .c code.  What if we instead throw the #ifdef
inside the helper, and then add a KVM_BUG_ON() in the CONFIG_KVM_HYPERV=n path?

> +#endif /* CONFIG_KVM_HYPERV */
>  
>  void nested_sync_vmcs12_to_shadow(struct kvm_vcpu *vcpu)
>  {
> @@ -3155,6 +3162,7 @@ static int nested_vmx_check_vmentry_hw(struct kvm_vcpu *vcpu)
>  	return 0;
>  }
>  
> +#ifdef CONFIG_KVM_HYPERV
>  static bool nested_get_evmcs_page(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
> @@ -3182,6 +3190,9 @@ static bool nested_get_evmcs_page(struct kvm_vcpu *vcpu)
>  
>  	return true;
>  }
> +#else
> +static bool nested_get_evmcs_page(struct kvm_vcpu *vcpu) { return true; }
> +#endif

And this one seems like it could be cleaner to just #ifdef the callers.

