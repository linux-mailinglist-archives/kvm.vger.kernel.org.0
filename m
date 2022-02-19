Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B30544BC41B
	for <lists+kvm@lfdr.de>; Sat, 19 Feb 2022 02:09:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236888AbiBSA71 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Feb 2022 19:59:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240892AbiBSA66 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Feb 2022 19:58:58 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6362288807
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 16:57:43 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id y16so1808155pjt.0
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 16:57:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=U9fjhgWOiMwGi5xI0xw+IhlspCq83wOfrur+IO2MG8c=;
        b=YGoHZMw0uktKVdBMiax/QJHTrzA6pidCl/4MbhdknUd/KpbG85kak8B2g8pweuk3P6
         mqPL8ODqdstE/QUHTBhc0GHabpkrnhBwOFl2Fl8PpfaVnmxU/Mjz713KDwIBvivNmviQ
         /2YEJphKpGggD5dUKzHrlqXoo+MfiqsUsQL533/oehy4vgEn32PCDr/aMyLZx5IsnakO
         R6lIrVMvvad5nWjDeAHeDrovn0L9uR5ejiKsyYtsiyJfHsHaQQjjxuykdGL75Db1ANi2
         EqEb+SqMc0299bYQueXNw/9Jt7h/OE1Z0+vbkG1vG2GL8q+6M+5nuFTivl4tgz4zpk6y
         lSbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=U9fjhgWOiMwGi5xI0xw+IhlspCq83wOfrur+IO2MG8c=;
        b=LnMWpwJ4rLxysTpYeENemWCcfkE7BtyujqQSd3atJSEnx0CETaZ/3A3/X0PeZTvBCS
         d8iIWJS8Zr/aOh7riZZa+elHFYiOIIihgSLcEhACnjCFETBMN9u5QJ8Y2x2+JAOpxfb6
         4/Q9HvtFcTql5/ACzLO5dc2q4uV/gsZd5ISi+Xe+4lPCKNf6E9N86uiFyZ8EAfuPYprF
         p69QrgabJ/u4wXBSLZ4k2/V5hgEXbagkr5WMQL4/sux5owYv0MlLhV9vwWVNeh1P6ZMV
         eF0vI3RhmJYEg/OD3X0dxv9oqPzcztgdfhRqXINjCPRdO0gf8l/8KQ1kh0a+4vS59wRS
         GTPw==
X-Gm-Message-State: AOAM532AvdSPwo4veqkKGZRgT9T80RWvsVKd6+I1xSfdNeTPNHdWxZP+
        rkFl1Biey+AOLpANZKcyFL49mw==
X-Google-Smtp-Source: ABdhPJy8js9of3B7aQjY5J5vP748PYtbjSDeRxllFJ7Wlerd9M5F5uoIpozPu2kTp+j1oZbgrTFyAQ==
X-Received: by 2002:a17:903:1d0:b0:14d:a620:5828 with SMTP id e16-20020a17090301d000b0014da6205828mr9520010plh.64.1645232262955;
        Fri, 18 Feb 2022 16:57:42 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id q5sm4564458pfu.199.2022.02.18.16.57.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 16:57:42 -0800 (PST)
Date:   Sat, 19 Feb 2022 00:57:39 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        leksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Peter Feiner <pfeiner@google.com>,
        Andrew Jones <drjones@redhat.com>, maciej.szmigiero@oracle.com,
        kvm@vger.kernel.org
Subject: Re: [PATCH 01/23] KVM: x86/mmu: Optimize MMU page cache lookup for
 all direct SPs
Message-ID: <YhBAg3219mC+4DIq@google.com>
References: <20220203010051.2813563-1-dmatlack@google.com>
 <20220203010051.2813563-2-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220203010051.2813563-2-dmatlack@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 03, 2022, David Matlack wrote:
> Commit fb58a9c345f6 ("KVM: x86/mmu: Optimize MMU page cache lookup for
> fully direct MMUs") skipped the unsync checks and write flood clearing
> for full direct MMUs. We can extend this further and skip the checks for
> all direct shadow pages. Direct shadow pages are never marked unsynced
> or have a non-zero write-flooding count.
> 
> No functional change intended.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>

>  arch/x86/kvm/mmu/mmu.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 296f8723f9ae..6ca38277f2ab 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2052,7 +2052,6 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
>  					     int direct,
>  					     unsigned int access)
>  {
> -	bool direct_mmu = vcpu->arch.mmu->direct_map;
>  	union kvm_mmu_page_role role;
>  	struct hlist_head *sp_list;
>  	unsigned quadrant;
> @@ -2093,7 +2092,8 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
>  			continue;
>  		}
>  
> -		if (direct_mmu)
> +		/* unsync and write-flooding only apply to indirect SPs. */
> +		if (sp->role.direct)

Because I spent waaaay too much time over-analyzing this... checking sp->role.direct
actually generates better code than check @direct.  Because of regsiter pressure,
direct has to get shoved onto the stack and then pulled back off.  Not that it
matters, at all, because this code runs exactly once...

>  			goto trace_get_page;
>  
>  		if (sp->unsync) {
> -- 
> 2.35.0.rc2.247.g8bbb082509-goog
> 
