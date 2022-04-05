Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE6204F5514
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 07:31:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443437AbiDFF14 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 01:27:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1588314AbiDFAPV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 20:15:21 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BD5816F6DF
        for <kvm@vger.kernel.org>; Tue,  5 Apr 2022 15:40:05 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id t4so633606pgc.1
        for <kvm@vger.kernel.org>; Tue, 05 Apr 2022 15:40:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mja/7Hv2yue+rVJAx6K5Hvn3mkY+RhBRGz47vlxkKUQ=;
        b=EkH6rRJ4ouJTgRc1oiSzVnRlg71jkUg3f2CN4kywiE9HLy2OfRI8r+5uutp20X2IXm
         rx/o6a1D4/Tos+AyAQJQ74thxLA67pi3cAVX+upPp0A73Opew9btQh9r0Zmicpl3Gbs8
         GWU5JPI/vhZQNO5F11tWgzsMFHqAl+FHQ6WpB5y81CDNCpsB1QNYxW+non1H0tiMUGpo
         Q8Cd8qVXLVdr5+B+YTgB0QOv5nzu7CelWg+Df8gkDtb14o7yF7sbbQT4G+P0tuBIFDuX
         qJwN11Jp8y5MyTV9INkUXXejBHNC00qkNyKp0uPXAgBSqHJA8pHig/7AhX9CUkFSSRB4
         QHlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mja/7Hv2yue+rVJAx6K5Hvn3mkY+RhBRGz47vlxkKUQ=;
        b=YmaM9vos/wQwyG9Zt8iFPNwrtXpx5c+Ue+MQM86UdVa58xlAboV66x7q4JcPgcAk0I
         DN89dW+fhzFU7Buu6hLaQYkZ9kJ56/oi4lVTu4olYATRfgVAyiPhiqGqeAod5oofdMCU
         oUV5A4dDaIM7tdBXoOiFPiIdMrAGbUyLVZjZMzAT8RfkJYQVIK8NGNR+PeVh4vVF+KFc
         3096sQZF3Mqcp5E4Htiks9fOZpugGN6/Buk8DUPQuF8cmqQll8t94GRRxWz3ZnuXZl5f
         8X0yNPyLde93toKWLeQpsGAGEO8iJV8WKEvFaEkz8fOPBQ19agCVpQ447GpmQvD8V2D/
         IXaw==
X-Gm-Message-State: AOAM531nBU3Rz7hLHip9fi0tuMIBtbpkGiyi7Y492Nktnue4c97qjMC1
        ZkzjztOUzI9F85+h34Dp7oA5wA==
X-Google-Smtp-Source: ABdhPJybMyhTNJNxDqSE/8X856+gFMewDiBCEEDwkiMSEl/dfJJtft8+rQ37c7S10gJJi3tz4MURXQ==
X-Received: by 2002:a05:6a00:3316:b0:4fa:80fd:f3f6 with SMTP id cq22-20020a056a00331600b004fa80fdf3f6mr5642757pfb.65.1649198404907;
        Tue, 05 Apr 2022 15:40:04 -0700 (PDT)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id k3-20020a056a00168300b004f7e60da26csm17089109pfc.182.2022.04.05.15.40.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 15:40:04 -0700 (PDT)
Date:   Tue, 5 Apr 2022 22:40:00 +0000
From:   David Matlack <dmatlack@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>
Subject: Re: [PATCH v3 07/11] KVM: x86/MMU: Factor out updating NX hugepages
 state for a VM
Message-ID: <YkzFQBjbt081HhbG@google.com>
References: <20220330174621.1567317-1-bgardon@google.com>
 <20220330174621.1567317-8-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220330174621.1567317-8-bgardon@google.com>
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

On Wed, Mar 30, 2022 at 10:46:17AM -0700, Ben Gardon wrote:
> Factor out the code to update the NX hugepages state for an individual
> VM. This will be expanded in future commits to allow per-VM control of
> Nx hugepages.
> 
> No functional change intended.
> 
> Signed-off-by: Ben Gardon <bgardon@google.com>

Reviewed-by: David Matlack <dmatlack@google.com>

> ---
>  arch/x86/kvm/mmu/mmu.c | 17 +++++++++++------
>  1 file changed, 11 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index dbf46dd98618..af428cb65b3f 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -6202,6 +6202,15 @@ static void __set_nx_huge_pages(bool val)
>  	nx_huge_pages = itlb_multihit_kvm_mitigation = val;
>  }
>  
> +static void kvm_update_nx_huge_pages(struct kvm *kvm)
> +{
> +	mutex_lock(&kvm->slots_lock);
> +	kvm_mmu_zap_all_fast(kvm);
> +	mutex_unlock(&kvm->slots_lock);
> +
> +	wake_up_process(kvm->arch.nx_lpage_recovery_thread);
> +}
> +
>  static int set_nx_huge_pages(const char *val, const struct kernel_param *kp)
>  {
>  	bool old_val = nx_huge_pages;
> @@ -6224,13 +6233,9 @@ static int set_nx_huge_pages(const char *val, const struct kernel_param *kp)
>  
>  		mutex_lock(&kvm_lock);
>  
> -		list_for_each_entry(kvm, &vm_list, vm_list) {
> -			mutex_lock(&kvm->slots_lock);
> -			kvm_mmu_zap_all_fast(kvm);
> -			mutex_unlock(&kvm->slots_lock);
> +		list_for_each_entry(kvm, &vm_list, vm_list)
> +			kvm_update_nx_huge_pages(kvm);
>  
> -			wake_up_process(kvm->arch.nx_lpage_recovery_thread);
> -		}
>  		mutex_unlock(&kvm_lock);
>  	}
>  
> -- 
> 2.35.1.1021.g381101b075-goog
> 
