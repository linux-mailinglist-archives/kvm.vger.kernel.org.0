Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBB74426D67
	for <lists+kvm@lfdr.de>; Fri,  8 Oct 2021 17:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242927AbhJHPWK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Oct 2021 11:22:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242929AbhJHPWI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Oct 2021 11:22:08 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEB7AC061764
        for <kvm@vger.kernel.org>; Fri,  8 Oct 2021 08:20:12 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id s11so3399160pgr.11
        for <kvm@vger.kernel.org>; Fri, 08 Oct 2021 08:20:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+DwJxNDoJtDhvq9ZSDg0PQGL/oNqmKyqA/s5QHM/KJw=;
        b=rn5k8n+EcdDIkAXU59D+iKtUjlDA3/0rzhyW1NFD5GsqO06gFaIUNF2+jI3ZfKWzjo
         4yP9WaUypIi52a5e+6yueKr+WvdWFwup4Kjga/xfJ2KxTKLhxxdBWouUTH1O+U79JhAe
         kZjNQrshsd0zSogjVXiyn9ZkAAa41zo0sluHzSfrzMGbwuqXSjN2+8Zl9lBGU+SKH5y9
         jaPUUzbRqeSAPKL4h00gXuoYrAbVqqfJ/5zTAYQLdMNBdWo4TydPYpCO3b0NvYVzwCLR
         c+xHZdC6qBhFp4tias4VLCO/eWXG7rU43EDAgT/46JA2eEIUQbDBepqFq8BFssJ3ngce
         0iRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+DwJxNDoJtDhvq9ZSDg0PQGL/oNqmKyqA/s5QHM/KJw=;
        b=ao0KsMjT7p8q82Vc+jV+CZcuKa+MLYRZvlNf2ZC+Yrj4v+4B8xZiMol+9LtmOBCjOl
         LnR7KWFhWUpVcO+Yp6ilT/wmC8hnGQmWYs40YM/gk0LDx1YWe86fsGVZDaguWEgAAFD4
         lKtmedlL/PbnE8YU3ZjwT9epek4Lnp0B8Dqck2JhLbgJ/t5TcGwsGjFWxtZvyMse0rez
         fzdyHAVLhAGeSenDcRgC2GvN3AwnaqZRYU7LHHcfdEbFL6y7WKhxpEoM1QEOGctXV9Zw
         35H6bkhUuPl37z0nvAzKCNOghh2Ynz+GeoDA5bbOrvoQQ1tCetNwkGWshiKlVeKO76xX
         wgrA==
X-Gm-Message-State: AOAM533fc33/dfSk+FbCNtuDq137SnZUgiDM3GCV6XZGlKDwzTcO0JVB
        80WtMT3P4jSQgRJjZMoQw3DLvg==
X-Google-Smtp-Source: ABdhPJw7IVhwXTlHF/c6N5zkruLir69z9rKpzJ8TK/3w33V/kw79EeM1kE/lWVxR+jaRI+62Jfgs4Q==
X-Received: by 2002:a65:688d:: with SMTP id e13mr5061431pgt.428.1633706411969;
        Fri, 08 Oct 2021 08:20:11 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id r14sm3118866pgf.49.2021.10.08.08.20.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Oct 2021 08:20:11 -0700 (PDT)
Date:   Fri, 8 Oct 2021 15:20:07 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH 1/3] KVM: emulate: #GP when emulating rdpmc if CR0.PE is 1
Message-ID: <YWBhpzsBxe16z+L1@google.com>
References: <1633687054-18865-1-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1633687054-18865-1-git-send-email-wanpengli@tencent.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The shortlog makes it sound like "inject a #GP if CR0.PE=1", i.e. unconditionally
inject #GP for RDMPC in protected mode.  Maybe "Don't inject #GP when emulating
RDMPC if CR0.PE=0"?

On Fri, Oct 08, 2021, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> SDM mentioned that, RDPMC: 
> 
>   IF (((CR4.PCE = 1) or (CPL = 0) or (CR0.PE = 0)) and (ECX indicates a supported counter)) 
>       THEN
>           EAX := counter[31:0];
>           EDX := ZeroExtend(counter[MSCB:32]);
>       ELSE (* ECX is not valid or CR4.PCE is 0 and CPL is 1, 2, or 3 and CR0.PE is 1 *)
>           #GP(0); 
>   FI;
> 
> Let's add the CR0.PE is 1 checking to rdpmc emulate.
> 
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  arch/x86/kvm/emulate.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 9a144ca8e146..ab7ec569e8c9 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -4213,6 +4213,7 @@ static int check_rdtsc(struct x86_emulate_ctxt *ctxt)
>  static int check_rdpmc(struct x86_emulate_ctxt *ctxt)
>  {
>  	u64 cr4 = ctxt->ops->get_cr(ctxt, 4);
> +	u64 cr0 = ctxt->ops->get_cr(ctxt, 0);
>  	u64 rcx = reg_read(ctxt, VCPU_REGS_RCX);
>  
>  	/*
> @@ -4222,7 +4223,7 @@ static int check_rdpmc(struct x86_emulate_ctxt *ctxt)
>  	if (enable_vmware_backdoor && is_vmware_backdoor_pmc(rcx))
>  		return X86EMUL_CONTINUE;
>  
> -	if ((!(cr4 & X86_CR4_PCE) && ctxt->ops->cpl(ctxt)) ||
> +	if ((!(cr4 & X86_CR4_PCE) && ctxt->ops->cpl(ctxt) && (cr0 & X86_CR0_PE)) ||

I don't think it's possible for CPL to be >0 if CR0.PE=0, e.g. we could probably
WARN in the #GP path.  Realistically it doesn't add value though, so maybe just
add a blurb in the changelog saying this isn't strictly necessary?

>  	    ctxt->ops->check_pmc(ctxt, rcx))
>  		return emulate_gp(ctxt, 0);
>  
> -- 
> 2.25.1
> 
