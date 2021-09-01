Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D66503FE5EF
	for <lists+kvm@lfdr.de>; Thu,  2 Sep 2021 02:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230250AbhIAXGH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Sep 2021 19:06:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbhIAXGE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Sep 2021 19:06:04 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFCFDC061575
        for <kvm@vger.kernel.org>; Wed,  1 Sep 2021 16:05:06 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id x16so40956pll.2
        for <kvm@vger.kernel.org>; Wed, 01 Sep 2021 16:05:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IIkEYN/zkqRwKdkFSskoNZeF/xcwIFT7kXI6bRG007g=;
        b=dUgjBt4H9jP3nfaLhbtcM7L9zfWITNYwixqO8H1IHP/vYd5LxMFLqwhxd+O/i15UJ4
         Tmi3b8bMBrACyaRE3kwIG0ZK2ZGmiIdN7nkdN3uXTzd/YJVzVYscvxYXJ/upqEBnHf81
         HJGvsexFNAA7fea2+pD6EbRHDS0QwgNZH7bM+ZS4xaqI378frujD+kL2xrmeqc9xn5OX
         RcaYlV4oL1WfmrnIoqOnuhTJer/40BvlDK/pAIIcNFiepom0zDfkgEkNkwdJG2+Lg6ex
         TDr7/AtVUBPwnIXXnvFUvYvXdwZ5hrUwL/GQY/P+osHpTFlRNvrU1EHuSsrnS6NmYpuB
         BOYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IIkEYN/zkqRwKdkFSskoNZeF/xcwIFT7kXI6bRG007g=;
        b=e5gf6CN5STF5Q2nvbfyHXVcu63BUxwQqrSxRxx4G3QENEof0D67isCu7pJy8bIxWup
         n5ZBdJOuaKcofD+wRbqVRwLr8ZQBvj2M9hf9Y2Yo2192rPxxlfbDPDGlUkKp5A/mOP6w
         fXDVCeyXb5ELu4hCULWPoGWvgSLBTdwbldyPy7+4Dk9V8HPRDy56Nw5lg0RXWKq6Tfyb
         bzWvk1+xmcJw/7y01rJ7E1dKpFqZlRxE9ziWHLFPBNpVbrhc4DJLB6xCcvPEox/FxoV9
         WpUpjs9eB5So3+d1CpVMRl03d9wtkkgwzyZJ0BS4vjH+D1hTiju13UvLRzrMmyFO+sHj
         amZA==
X-Gm-Message-State: AOAM532N90x/5mUAo4tad8Cg5NhaPpG4PLw2RebhE6O1VjgPa3l6b/87
        ePkkizk56R9Q4X6igUkHmYSP/g==
X-Google-Smtp-Source: ABdhPJxlPidW11ujRaEvcP2dofZLfwUaPQXVYGGDSEc45V6vCYXHrk4Ian/Ds2SEcRI7DmYy0ZafCw==
X-Received: by 2002:a17:902:8604:b0:137:974f:f87 with SMTP id f4-20020a170902860400b00137974f0f87mr103411plo.54.1630537506174;
        Wed, 01 Sep 2021 16:05:06 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id o15sm66668pjr.0.2021.09.01.16.05.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 16:05:05 -0700 (PDT)
Date:   Wed, 1 Sep 2021 23:05:01 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        isaku.yamahata@intel.com, David Matlack <dmatlack@google.com>,
        peterx@redhat.com
Subject: Re: [PATCH 07/16] KVM: MMU: change try_async_pf() arguments to
 kvm_page_fault
Message-ID: <YTAHHeQloYWjqovc@google.com>
References: <20210807134936.3083984-1-pbonzini@redhat.com>
 <20210807134936.3083984-8-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210807134936.3083984-8-pbonzini@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Aug 07, 2021, Paolo Bonzini wrote:
> @@ -3919,25 +3915,25 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>  	else
>  		write_lock(&vcpu->kvm->mmu_lock);
>  
> -	if (!is_noslot_pfn(pfn) && mmu_notifier_retry_hva(vcpu->kvm, mmu_seq, hva))
> +	if (!is_noslot_pfn(fault->pfn) && mmu_notifier_retry_hva(vcpu->kvm, mmu_seq, fault->hva))
>  		goto out_unlock;
>  	r = make_mmu_pages_available(vcpu);
>  	if (r)
>  		goto out_unlock;
>  
>  	if (is_tdp_mmu_fault)
> -		r = kvm_tdp_mmu_map(vcpu, gpa, error_code, map_writable, fault->max_level,
> -				    pfn, fault->prefault);
> +		r = kvm_tdp_mmu_map(vcpu, gpa, error_code, fault->map_writable, fault->max_level,
> +				    fault->pfn, fault->prefault);
>  	else
> -		r = __direct_map(vcpu, gpa, error_code, map_writable, fault->max_level, pfn,
> -				 fault->prefault, fault->is_tdp);
> +		r = __direct_map(vcpu, gpa, error_code, fault->map_writable, fault->max_level,
> +		                 fault->pfn, fault->prefault, fault->is_tdp);

More unwanted spaces!

ERROR: code indent should use tabs where possible
#95: FILE: arch/x86/kvm/mmu/mmu.c:3951:
+^I^I^I^I          fault->write, &fault->map_writable,$

ERROR: code indent should use tabs where possible
#96: FILE: arch/x86/kvm/mmu/mmu.c:3952:
+^I^I^I^I          &fault->hva);$

ERROR: code indent should use tabs where possible
#123: FILE: arch/x86/kvm/mmu/mmu.c:3987:
+^I                        fault->gfn, fault->pfn, ACC_ALL, &r))$

ERROR: code indent should use tabs where possible
#147: FILE: arch/x86/kvm/mmu/mmu.c:4008:
+^I^I                 fault->pfn, fault->prefault, fault->is_tdp);$

total: 4 errors, 0 warnings, 180 lines checked
