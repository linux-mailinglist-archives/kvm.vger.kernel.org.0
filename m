Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C33CC4CC572
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 19:51:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235818AbiCCSvu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 13:51:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235810AbiCCSvt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 13:51:49 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B902E19CCED
        for <kvm@vger.kernel.org>; Thu,  3 Mar 2022 10:51:03 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id bd1so5446343plb.13
        for <kvm@vger.kernel.org>; Thu, 03 Mar 2022 10:51:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yX5m8MlUOAzLqKBbT/pjod3RHno71P9LV7MCNSMdCNA=;
        b=hKByNygA1xInTtaOkprgwYnnSAvv3TOfL1VRe9RsQUpBLFx1/c6vMaTN8ywDq1jd0r
         S9+BNhV687ksiIgKNgFtooC6ZfYgYyYjj9Lqu6SjcSriUIcS4CwvlaQBFt8RNkUPKjhb
         A5xPtVw21RU9INzaevBV/emcaNy0Tdh1nFpL+hw4YPJ8G/kUVo0x748Pk7jy/gVrVMgl
         Vb4a7HKm7QPShHMiUOfKj7gkpuTBuZ9c9GdwKZQpH9tOn10s1dnuQ0gFegSVcDKUADES
         Fl0TdlH+N9GRSQV+TZGZzAzN0gtePMTI0jmbpKyQNv2IbHGCrHGlxD2+ylk/DUgy68/9
         mz8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yX5m8MlUOAzLqKBbT/pjod3RHno71P9LV7MCNSMdCNA=;
        b=PMROZsH3ADiy+BwXMt10pQKnOBPM7e4h9Nmw6uR7r00V6kFkm8aIfkY+LsKJJaIIlB
         0AaArz1G1nZw38R0+qH76OJnZWfluSXwxckp9tpt/xTDC7FRjhwrT/YlUnSG+IuRZm0j
         Hb0jbEZ0nIvlwtq+ykLHiQEqmOJZoIfsJsOhW2M63B8SXwf0loMXgU24VdWPdSsPQbku
         0N8O6DsyLAePTr9jXHqo/e3bRYuth0i+pHmEehCwLBPrVOGuuL8wmnaT8USdNI0veEbK
         p4Sq5RYec5mVfacC6vkgBCB1pWPzVVM8RvrBvgCl2TJeakz1sxNTnTtnjffROyZdqy9G
         uSMA==
X-Gm-Message-State: AOAM531knqvcpCIaMpO3IXoBLKsiS5LlSqYRud3nVESyv2RVG0A0mbQW
        eLaQMQbq59N7+0IoIrperKwCAA==
X-Google-Smtp-Source: ABdhPJxX8XR0ZS0cRvllspUQlxpTdJW88rG6/kheSbKjyDIs1IbwHSUjG1b1J56o0sqgIeYukK3btw==
X-Received: by 2002:a17:902:eb8b:b0:151:60f4:84e5 with SMTP id q11-20020a170902eb8b00b0015160f484e5mr24432716plg.134.1646333462795;
        Thu, 03 Mar 2022 10:51:02 -0800 (PST)
Received: from google.com (226.75.127.34.bc.googleusercontent.com. [34.127.75.226])
        by smtp.gmail.com with ESMTPSA id k62-20020a17090a4cc400b001bf0d92e1c7sm2704686pjh.41.2022.03.03.10.51.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 10:51:02 -0800 (PST)
Date:   Thu, 3 Mar 2022 18:50:58 +0000
From:   Mingwei Zhang <mizhang@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v3 14/28] KVM: x86/mmu: Skip remote TLB flush when
 zapping all of TDP MMU
Message-ID: <YiEOEjJHqyJJLtFz@google.com>
References: <20220226001546.360188-1-seanjc@google.com>
 <20220226001546.360188-15-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220226001546.360188-15-seanjc@google.com>
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Feb 26, 2022, Sean Christopherson wrote:
> Don't flush the TLBs when zapping all TDP MMU pages, as the only time KVM
> uses the slow version of "zap everything" is when the VM is being
> destroyed or the owning mm has exited.  In either case, KVM_RUN is
> unreachable for the VM, i.e. the guest TLB entries cannot be consumed.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Mingwei Zhang <mizhang@google.com>
> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index c231b60e1726..87706e9cc6f3 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -874,14 +874,15 @@ bool __kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, int as_id, gfn_t start,
>  
>  void kvm_tdp_mmu_zap_all(struct kvm *kvm)
>  {
> -	bool flush = false;
>  	int i;
>  
> +	/*
> +	 * A TLB flush is unnecessary, KVM zaps everything if and only the VM
> +	 * is being destroyed or the userspace VMM has exited.  In both cases,
> +	 * KVM_RUN is unreachable, i.e. no vCPUs will ever service the request.
> +	 */
>  	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
> -		flush = kvm_tdp_mmu_zap_gfn_range(kvm, i, 0, -1ull, flush);
> -
> -	if (flush)
> -		kvm_flush_remote_tlbs(kvm);
> +		(void)kvm_tdp_mmu_zap_gfn_range(kvm, i, 0, -1ull, false);
>  }
>  
>  /*
> -- 
> 2.35.1.574.g5d30c73bfb-goog
> 
