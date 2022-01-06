Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AA63486964
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 19:09:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242556AbiAFSJh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jan 2022 13:09:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242595AbiAFSJg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jan 2022 13:09:36 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81EEEC061245
        for <kvm@vger.kernel.org>; Thu,  6 Jan 2022 10:09:36 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id s15so2996396plg.12
        for <kvm@vger.kernel.org>; Thu, 06 Jan 2022 10:09:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2N5PsN4yRBv182yZ587F2v21F6mIINdXvLaeARO6uyM=;
        b=TUqmPBLA6ycP01HdBSbz6azNMU2nPE3QbDiI1CmHqGDm4c/hRtVJA/jYvC9W/6Qxsk
         L7EkckDD59MYtfzrQ4gYmLzSchMBwA5oonJTyogozcLAzSt2zo5Oc9wxMjizxWpEZ/JH
         Lxjk8/cafgPzuF5pD4nxjh7EBVTYsFUwW3zrbXJS6ENGcN5MCC0voweGwG97mABPgVYY
         UN1kR/Rl95BkdmhJ0mCczsTEJF6a4hukxWo4rmWRL9c9yXxv3kwf5ktlOxAxdxFSO3DF
         ea5PhjJyEnlps6QZdsTR7qUMpuucG09JYoRtd9j3Ne3YyvBAdfVvxUX8b6+dnXjUDgP5
         qFMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2N5PsN4yRBv182yZ587F2v21F6mIINdXvLaeARO6uyM=;
        b=cB9bxjYT4pxuJiQxK/CxnZOn9DH5Ji3UW7av6f/XW2JANsXJA7E8qmZs0NFh7f53aS
         MzttG6EOOZGAOUsJnks50/2UyWWnkMieHoe/qfr+sy51c8Yujlf5SCCTQu+Iik3Zvd67
         AXy+Ej4niuVcUGKyXqWuKzrJGkEpS5r7arYzZYpcdwFAnVPR1+jF2tRS9y6W59CP4RXj
         EFHU8r004WfrKQfgrSm7au1adpsjhyXRu+BmygLsA7kNeiVTfsFnaMcBMtmxsgWWnJQj
         0ERj+IJoxn9V3xmE1lXh2eIXdpfN9i20oqHxZFvtH9Q6TeoXCp6z054gP+rqLZUGSytl
         P7uw==
X-Gm-Message-State: AOAM533EmJryGBJ1pKKDZqrfG8PJZCwCG3H5/BuCmx7W7ygoZqsYcxv0
        pxyF6S7X6DbIP8IgBTLv9h45/g==
X-Google-Smtp-Source: ABdhPJw8atVMtICb9c1YLZCpBibCoH+yi3yhmDOixHPJtX9JF743KsJ0NSzm3tTbFYtITDXckMq7kw==
X-Received: by 2002:a17:902:aa95:b0:149:7c20:bb6f with SMTP id d21-20020a170902aa9500b001497c20bb6fmr48758743plr.170.1641492575874;
        Thu, 06 Jan 2022 10:09:35 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id m14sm3309040pfk.3.2022.01.06.10.09.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jan 2022 10:09:35 -0800 (PST)
Date:   Thu, 6 Jan 2022 18:09:32 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KVM: x86/pmu: Make top-down.slots event unavailable
 in supported leaf
Message-ID: <YdcwXIANeB3fOWOI@google.com>
References: <20220106032118.34459-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220106032118.34459-1-likexu@tencent.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 06, 2022, Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
> 
> When we choose to disable the fourth fixed counter TOPDOWN.SLOTS,
> we also need to comply with the specification and set 0AH.EBX.[bit 7]
> to 1 if the guest (e.g. on the ICX) has a value of 0AH.EAX[31:24] > 7.
> 
> Fixes: 2e8cd7a3b8287 ("kvm: x86: limit the maximum number of vPMU fixed counters to 3")
> Signed-off-by: Like Xu <likexu@tencent.com>
> ---
> v1 -> v2 Changelog:
> - Make it simpler to keep forward compatibility; (Sean)
> - Wrap related comment at ~80 chars; (Sean)
> 
> Previous:
> https://lore.kernel.org/kvm/20220105050711.67280-1-likexu@tencent.com/
> 
>  arch/x86/kvm/cpuid.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 0b920e12bb6d..4fe17a537084 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -782,6 +782,18 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>  		eax.split.mask_length = cap.events_mask_len;
>  
>  		edx.split.num_counters_fixed = min(cap.num_counters_fixed, MAX_FIXED_COUNTERS);
> +
> +		/*
> +		 * The 8th Intel architectural event (Topdown Slots) will be supported

Nit, the "8th" part is unnecessary information.  

> +		 * if the 4th fixed counter exists && EAX[31:24] > 7 && EBX[7] = 0.
> +		 *
> +		 * Currently, KVM needs to set EAX[31:24] < 8 or EBX[7] == 1
> +		 * to make this event unavailable in a consistent way.
> +		 */

This comment is now slightly stale.  It also doesn't say why the event is made
unavailable.

> +		if (edx.split.num_counters_fixed < 4 &&

Rereading the changelog and the changelog of the Fixed commit, I don't think KVM
should bother checking num_counters_fixed.  IIUC, cap.events_mask[7] should already
be '1' if there are less than 4 fixed counters in hardware, but at the same time
there's no harm in being a bit overzealous.  That would help simplifiy the comment
as there's no need to explain why num_counters_fixed is checked, e.g. the fact that
Topdown Slots uses the 4th fixed counter is irrelevant with respect to the legality
of setting EBX[7]=1 to hide an unsupported event.

		/*
		 * Hide Intel's Topdown Slots architectural event, it's not yet
		 * supported by KVM.
		 */
		if (eax.split.mask_length > 7)
			cap.events_mask |= BIT_ULL(7);

> +		    eax.split.mask_length > 7)
> +			cap.events_mask |= BIT_ULL(7);
> +
>  		edx.split.bit_width_fixed = cap.bit_width_fixed;
>  		if (cap.version)
>  			edx.split.anythread_deprecated = 1;
> -- 
> 2.33.1
> 
