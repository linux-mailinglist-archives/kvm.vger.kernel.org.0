Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 895C646DBEB
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 20:17:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234084AbhLHTUu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Dec 2021 14:20:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231388AbhLHTUu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Dec 2021 14:20:50 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF46BC061746
        for <kvm@vger.kernel.org>; Wed,  8 Dec 2021 11:17:17 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id u11so2188429plf.3
        for <kvm@vger.kernel.org>; Wed, 08 Dec 2021 11:17:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DGnuOBwhoBGsqcbwh1V3s8v4tkBJox5VDKCuMWrCxRI=;
        b=fbvEgdJVp9DubGUA5+/dSVLMkuGd39qD7pKitXNbCxQQ25h2rtA0U8zDfgG10+48kk
         Z7fIDyR9H1m0bwe4YLYvIaJC2G+ZMyAlcUGwQ2vF3GLc0WtMed4x4mUd/+wslThcz9q3
         WMf3jd8KpucybyJF03UVWdix26Kt8uhTxOgQGv3VHvySbxTkdiBl0gchTrLtaBnADLVv
         UHquEeLRlh1cfmfH/ffMjCLkZ050whAVjX+Vvm8yFOqPRiD3OCKm8PIiN14meMoZ4+Qv
         WYoh5vPhWsrSAUVpm020kApSUL2qGbplbKV5h/Nnr56+/YC/dQKLbewmqvoqNR4ZUH+z
         XaSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DGnuOBwhoBGsqcbwh1V3s8v4tkBJox5VDKCuMWrCxRI=;
        b=GKOogkfzaQGkHzChwrjyFMnRddox1MBHZUp9K/vZdLl8FoG1NSZr3enJdhyVbsTJWO
         hvqOWj545ZYnOE0VbygqZvCXGys4X2JXmly7JBXd6r1hs+26ISayMKslQq41i18LUSs+
         Sa7MbKrAtUQN8LDf97iUdeyGpGZMnFmTulDXXCZVEM7ewVE21GUaJ9p8ZhkuiudrjKz8
         19BrH25ILniNMwo8RkdH13uR4aq1A72CSqXxjUir1VUzlaB1hpC/GFLk6rux07Tq8SMw
         gaW9x/jtnkHlMMBVLBl9DlCxnnCFRjk4Kj6HmayTE46iVbc1H/AVgYVdpCkf/fSy1vja
         8xtA==
X-Gm-Message-State: AOAM5300kWNSbYeQsjllt5oCFKh+HTNDkcpXLs9YH6fqy+EcaI1RRToN
        gJ1FCOvuK3ZduvruTFIe9h+VBw==
X-Google-Smtp-Source: ABdhPJzErlY5eV+qzr52TnFF6JnHqQk+b9rFrt/flyTqyxNA1fc1JM6Cv//8XdHYPVs/YWjN1lmSog==
X-Received: by 2002:a17:902:b20b:b0:141:a92c:a958 with SMTP id t11-20020a170902b20b00b00141a92ca958mr61874259plr.24.1638991037051;
        Wed, 08 Dec 2021 11:17:17 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id y31sm4952081pfa.92.2021.12.08.11.17.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 11:17:16 -0800 (PST)
Date:   Wed, 8 Dec 2021 19:17:13 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Hou Wenlong <houwenlong93@linux.alibaba.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH 04/28] KVM: x86/mmu: Retry page fault if root is
 invalidated by memslot update
Message-ID: <YbEEuZBjEjOO9Pws@google.com>
References: <20211120045046.3940942-1-seanjc@google.com>
 <20211120045046.3940942-5-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211120045046.3940942-5-seanjc@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Nov 20, 2021, Sean Christopherson wrote:
> @@ -3976,6 +3980,20 @@ static bool kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
>  	return true;
>  }
>  
> +/*
> + * Returns true if the page fault is stale and needs to be retried, i.e. if the
> + * root was invalidated by a memslot update or a relevant mmu_notifier fired.
> + */
> +static bool is_page_fault_stale(struct kvm_vcpu *vcpu,
> +				struct kvm_page_fault *fault, int mmu_seq)
> +{
> +	if (is_obsolete_sp(vcpu->kvm, to_shadow_page(vcpu->arch.mmu->root_hpa)))

Ugh, I got so focused on TDP MMU that I completely forgot to test this with shadow
paging.  PAE roots are not backed by shadow pages, which means this explodes on the
very first page fault with TDP disabled.  Nested NPT will suffer the same fate.

I'll figure out a patch for 5.16.  Long term, it might be nice to actually allocate
shadow pages for the special roots.

> +		return true;
> +
> +	return fault->slot &&
> +	       mmu_notifier_retry_hva(vcpu->kvm, mmu_seq, fault->hva);
> +}
