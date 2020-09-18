Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DD4326F786
	for <lists+kvm@lfdr.de>; Fri, 18 Sep 2020 09:57:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726485AbgIRH46 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Sep 2020 03:56:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbgIRH4z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Sep 2020 03:56:55 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CC15C06174A
        for <kvm@vger.kernel.org>; Fri, 18 Sep 2020 00:56:55 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0c2600a65c515d56d1ce56.dip0.t-ipconnect.de [IPv6:2003:ec:2f0c:2600:a65c:515d:56d1:ce56])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id A8EA91EC032C;
        Fri, 18 Sep 2020 09:56:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1600415812;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=jnwJikcww71OpZvMfJM4DztBbtdS4UTU0+T1J4/wPs0=;
        b=OfHLTUb8PkeWMxH4XxG7JJ+Qwg2krzoqTNIENSYVaEi0I7GC8BGXkXRoCppYdQ9yFaaddq
        +Qb75xXDQhVOYysOe0QbC7KgdnLagOf2h6VIyGfUWAjrZEMRc1zgaPcOVjkn9TLXXSyeQU
        697UM/9Y+Y/JlmNEU2PQuXIegI2ugb0=
Date:   Fri, 18 Sep 2020 09:56:51 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, joro@8bytes.org,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [PATCH 3/3 v4] KVM: SVM: Don't flush cache if hardware enforces
 cache coherency across encryption domains
Message-ID: <20200918075651.GC6585@zn.tnic>
References: <20200917212038.5090-1-krish.sadhukhan@oracle.com>
 <20200917212038.5090-4-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200917212038.5090-4-krish.sadhukhan@oracle.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 17, 2020 at 09:20:38PM +0000, Krish Sadhukhan wrote:
> In some hardware implementations, coherency between the encrypted and
> unencrypted mappings of the same physical page in a VM is enforced. In such a
> system, it is not required for software to flush the VM's page from all CPU
> caches in the system prior to changing the value of the C-bit for the page.
> 
> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> ---
>  arch/x86/kvm/svm/sev.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 7bf7bf734979..3c9a45efdd4d 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -384,7 +384,8 @@ static void sev_clflush_pages(struct page *pages[], unsigned long npages)
>  	uint8_t *page_virtual;
>  	unsigned long i;
>  
> -	if (npages == 0 || pages == NULL)
> +	if (this_cpu_has(X86_FEATURE_SME_COHERENT) || npages == 0 ||
> +	    pages == NULL)
>  		return;
>  
>  	for (i = 0; i < npages; i++) {
> -- 

Took the first two, Paolo lemme know if I should route this one through
tip too.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
