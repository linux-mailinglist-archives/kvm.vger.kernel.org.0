Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 547AA65F6FD
	for <lists+kvm@lfdr.de>; Thu,  5 Jan 2023 23:46:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236112AbjAEWqx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Jan 2023 17:46:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232346AbjAEWqv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Jan 2023 17:46:51 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9695392C2
        for <kvm@vger.kernel.org>; Thu,  5 Jan 2023 14:46:50 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id cl14so4926990pjb.2
        for <kvm@vger.kernel.org>; Thu, 05 Jan 2023 14:46:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QP7jx92pmQtQsmcPnktia+AqRkjRMoVrW9tsDs4tcD8=;
        b=oJzJTDvtjMGa162eWLnDs3DuZ+w9H6uMJodBleJq20o+Hmf8F8n00zVrwMKSVgEZCt
         /43NesnK+BbypRhFEQRf9UyWjcnldMhMVIFQs8v4Rd2iAkObpg52OGBFBtkPIfEvzfCN
         DNO7uklZvpD5I5zX6PKer09tHRqj0RFnz2cjNoXv/pkMLCE2WCg4GgkJPEEl06zwjOYG
         wpQfblxO120Vz3TwUQIgx3Why9+Maf6iURVJZJij0KNASNnKWrFeXzuGnurrWBeEaMTO
         q7ZvZqfDR02z0pZiboDUdKve9PrVRAsiS81X8nKGjWgt/HTuB5Aqpt3CuS4mwfZ68pVJ
         onHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QP7jx92pmQtQsmcPnktia+AqRkjRMoVrW9tsDs4tcD8=;
        b=4l4T+Tgzk+RqJMdctGhASG6sIYG3+p/TA99MAsZGFvL2LpOB6Ift4umw8bh0noJ/uG
         hCt9WeW3lkHLlMowoqfMkM/+UzRPvF0BafsSJ99H93GfOozjVo9qUf4sbHpeLO1lxUEK
         FrFHOlaU9T1+cb2RHGSYmVCeLM+spHbTKlY8jVNPVpMX8cOC5sG8e+IoubJkWovLPthk
         /RUAe9LlTjUR7Rwjs68lJbFIi/nJ5NYMNPSXTVwDLJ4+d5mc+/gUs3MVc+9LMUVIaJUa
         AF9kJn/7buEdLnzoGIGyo2VR9L6rVjWaW1Slu5D0R9J0uJHGW5hqYjuTD3Hx70lTCOdO
         NlxQ==
X-Gm-Message-State: AFqh2kqTZHrKVy49e2sUuzPcSI4XczIpsMXURRTUd24Mne5uzO+G/iFA
        6DJXzFbAq6oKqJ+cR4XB7FDcCw==
X-Google-Smtp-Source: AMrXdXvfA1HtZJ0MmriTsP4qWvumXIb/3WEQxrdVnDvfrAfYRUq285FZ/SA3gWElqK7LA9sAYJRvLA==
X-Received: by 2002:a05:6a20:6996:b0:b4:1a54:25c6 with SMTP id t22-20020a056a20699600b000b41a5425c6mr46802pzk.1.1672958809951;
        Thu, 05 Jan 2023 14:46:49 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id j14-20020a170903028e00b00192849e1d0asm20360535plr.116.2023.01.05.14.46.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 14:46:49 -0800 (PST)
Date:   Thu, 5 Jan 2023 22:46:46 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Michal Luczaj <mhal@rbox.co>
Cc:     pbonzini@redhat.com, dwmw2@infradead.org, kvm@vger.kernel.org,
        paul@xen.org
Subject: Re: [PATCH 1/2] KVM: x86: Fix deadlock in
 kvm_vm_ioctl_set_msr_filter()
Message-ID: <Y7dTVgz4chEVL2IS@google.com>
References: <a03a298d-dfd0-b1ed-2375-311044054f1a@redhat.com>
 <20221229211737.138861-1-mhal@rbox.co>
 <20221229211737.138861-2-mhal@rbox.co>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221229211737.138861-2-mhal@rbox.co>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 29, 2022, Michal Luczaj wrote:
> Move synchronize_srcu(&kvm->srcu) out of kvm->lock critical section.
> 
> Signed-off-by: Michal Luczaj <mhal@rbox.co>
> ---
>  arch/x86/kvm/x86.c | 12 +++++-------
>  1 file changed, 5 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index da4bbd043a7b..16c89f7e98c3 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6460,7 +6460,7 @@ static int kvm_vm_ioctl_set_msr_filter(struct kvm *kvm,
>  	struct kvm_x86_msr_filter *new_filter, *old_filter;
>  	bool default_allow;
>  	bool empty = true;
> -	int r = 0;
> +	int r;

Separate change that should be its own patch (even though it's trivial).
>  	u32 i;
>  
>  	if (filter->flags & ~KVM_MSR_FILTER_VALID_MASK)
> @@ -6488,16 +6488,14 @@ static int kvm_vm_ioctl_set_msr_filter(struct kvm *kvm,
>  	mutex_lock(&kvm->lock);
>  
>  	/* The per-VM filter is protected by kvm->lock... */
> -	old_filter = srcu_dereference_check(kvm->arch.msr_filter, &kvm->srcu, 1);
> +	old_filter = rcu_replace_pointer(kvm->arch.msr_filter, new_filter, 1);

Same here.  Can you also add a patch to replace the '1' with "mutex_is_locked(&kvm->lock)"?

> +	kvm_make_all_cpus_request(kvm, KVM_REQ_MSR_FILTER_CHANGED);

I think the request can actually be moved outside of kvm->lock too (in yet another
patch).  Iterating over vCPUs without kvm->lock is safe; kvm_make_all_cpus_request()
might race with adding a new vCPU, i.e. send an unnecessary request, but
kvm->online_vcpus is never decremented.

> -	rcu_assign_pointer(kvm->arch.msr_filter, new_filter);
> -	synchronize_srcu(&kvm->srcu);
> +	mutex_unlock(&kvm->lock);
>  
> +	synchronize_srcu(&kvm->srcu);
>  	kvm_free_msr_filter(old_filter);
>  
> -	kvm_make_all_cpus_request(kvm, KVM_REQ_MSR_FILTER_CHANGED);
> -	mutex_unlock(&kvm->lock);
> -
>  	return 0;
>  }
>  
> -- 
> 2.39.0
> 
