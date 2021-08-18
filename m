Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD8D63F0D9C
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 23:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234174AbhHRVnw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 17:43:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234141AbhHRVnv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Aug 2021 17:43:51 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FDF5C0613CF
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 14:43:16 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id c17so2713457plz.2
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 14:43:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Urwa3UzEqM6bx1rqTWjruQFp6e8+joKwTq2oMTg9VIE=;
        b=HFPtXnpPGToF7LCczbWSo9uUFLMpq1xJe6bOqNTdwgZ/Hr6PAZgnVrspCPVfWRhFWt
         rXuBP7jVpW7XDWjtzuYMkoW3oqSSAq2RPNpjdDYIAu3KB9SdI8VnW2apoOES+q2zYfNP
         HifGUo6eGQfzj1Zd/Oisr47+RHwWxJUbxEQij+zH6t0HWiNLVvUGyBjHWbIKN588QnxF
         bXGIf1/FeTC4ph2lD1GqFNF3cbPOpCZoeYAPHQCavJdwom5os3Pbz/92qDQic+qC9Fu5
         04DFs+QWycTIIZ05qptcENV8520XVElyTa/b2FsAHIISxxksSkaKOMpNletTdNPmAVbw
         WHIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Urwa3UzEqM6bx1rqTWjruQFp6e8+joKwTq2oMTg9VIE=;
        b=o8vUvVNsle45tYTp0suzljabeGQUACmIYcM86CAf0lRs5kF3VWh6oJhzf9MvWcM219
         Iko3SRzsAt9XK2pdi86yZPkR+Gmsi13wTtn0ttXhBteQpjuBfJ6kF8NWzbUR6DJLR0hH
         nD+RjsCr5oAty/9nx6eyFmxKqBgouMDHwi+c7DRUng3qJ1va3legq0/JWSfUefRXXU5O
         xD+uDr+josGtlnLKVJPiprPSksuRTaS3aFe/ZLBi1VdGaKLaJ+2Iscfihf4ncXsWMZbu
         cOLdDQ7ruaKDgXSjVmzXaIyMsCqqxCxvPmkh4eV8jAJprFKVakiUVaNTGqXm1tQeiNjm
         0+bQ==
X-Gm-Message-State: AOAM5313vosVQUF2Zd7yXj4yoftUCtiJs21Ymdhqlkf4FMoLkmw8LeIg
        y2PPIZWVkmlxGOuG3rpdEXgTXA==
X-Google-Smtp-Source: ABdhPJxt6sDtb2wo4PVjm4LVmvOTJ2/mxYkpW4jXJXIh0eYt3JJ/1DSVMNFXZHEPQlo6BCB0iUrAGA==
X-Received: by 2002:a17:902:e9c6:b029:12d:4cb3:3985 with SMTP id 6-20020a170902e9c6b029012d4cb33985mr8921304plk.56.1629322995681;
        Wed, 18 Aug 2021 14:43:15 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id r16sm705172pje.10.2021.08.18.14.43.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Aug 2021 14:43:15 -0700 (PDT)
Date:   Wed, 18 Aug 2021 21:43:09 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Hou Wenlong <houwenlong93@linux.alibaba.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Avi Kivity <avi@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: fix wrong exception emulation in check_rdtsc
Message-ID: <YR1+7awNToPmkitb@google.com>
References: <1297c0dd3f1bb47a6d089f850b629c7aa0247040.1629257115.git.houwenlong93@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297c0dd3f1bb47a6d089f850b629c7aa0247040.1629257115.git.houwenlong93@linux.alibaba.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 18, 2021, Hou Wenlong wrote:
> According to Intel's SDM Vol2 and AMD's APM Vol3, when
> CR4.TSD is set, use rdtsc/rdtscp instruction above privilege
> level 0 should trigger a #GP.
> 
> Fixes: d7eb82030699e ("KVM: SVM: Add intercept checks for remaining group7 instructions")
> Signed-off-by: Hou Wenlong <houwenlong93@linux.alibaba.com>
> ---
>  arch/x86/kvm/emulate.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 2837110e66ed..c589ac832265 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -4206,7 +4206,7 @@ static int check_rdtsc(struct x86_emulate_ctxt *ctxt)
>  	u64 cr4 = ctxt->ops->get_cr(ctxt, 4);
>  
>  	if (cr4 & X86_CR4_TSD && ctxt->ops->cpl(ctxt))
> -		return emulate_ud(ctxt);
> +		return emulate_gp(ctxt, 0);

Heh, I was having some serious deja vu, but the fix I was thinking of was
for em_rdpid, and that was changing #GP -> #UD (commit a9e2e0ae6860).

Reviewed-by: Sean Christopherson <seanjc@google.com>

>  	return X86EMUL_CONTINUE;
>  }
> -- 
> 2.31.1
> 
