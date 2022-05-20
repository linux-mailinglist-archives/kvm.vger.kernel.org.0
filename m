Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EDA152EE77
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 16:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350461AbiETOt0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 10:49:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350409AbiETOtZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 10:49:25 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 726331737DE
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 07:49:24 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id t11-20020a17090a6a0b00b001df6f318a8bso11681795pjj.4
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 07:49:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=f1NRmKh5Rhsxk9PmTkCXw/A8MNF/NhHvXEmLtT1IpHE=;
        b=QZq4zlFkytnpkoKLHXfPVTDwcf9UtqLUzauaG+cSAnYVATmyPX81nLvs7hhmFyWBhe
         CbWOigB+fYckwMOkgfGsCJ0urV15tiqwqIWj3aFa+InB8MHitijRYDLZqlyktUnOHdzK
         1E/BkiyELKk1vHvrUiViJjXSEKszJYX395HLQWuDEFyfTdtW8F8lUTlYL3NXfdkIM609
         87aKY/zH8Ngh+Qhb2+aojh/ynF4pK/Flk9qjGL93ex6Hec84NYU6elLaxICYnxjkr8Kp
         hFXOe3z4bKd/JlXrfT/tb54mcnS+iQd+zJ/dt7EZNoN1Gcp2G5wD2CmWphQ7IJj+qdGI
         PXcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=f1NRmKh5Rhsxk9PmTkCXw/A8MNF/NhHvXEmLtT1IpHE=;
        b=c9ydaG4d0bisZqfZAPAmzTebcdFLnjwjNp4CCcLPWpTO4qyfQJbBZ5Y/VYS+QPWuYn
         d0BzYIMLUSTGAuJ/c75Q8Bn+muVpYRc3GMA7P8V2ptpw4XIUk8I03Fl4CewVmmGDuZ4U
         hp6cBmrxmVLbhfn+uV74UOPvYRmNgiPEJ9ysJ8p0qW3MssZdcBMgdcfHKUJQT/wAEEn+
         9CNt1VyOVfdLUURkGmCVeFcm1Ktkdw6GEn0373KBlY20BiyTLkOvAr7wvSj96elML43v
         Wmgbb60fQgWsXWwHtKFsR5zGvfqvN2ZhIqwffzjuI4tAlPXVMThSoJm5yYebzAnIUuls
         LQEA==
X-Gm-Message-State: AOAM5320CO6seeR19EWNiSGTh/dvFW7g3ub+oTKRAfL1lYSfNYVmX+I6
        GnQLRthGd+wS1l1dlqyTLDY7RQ==
X-Google-Smtp-Source: ABdhPJyEbl4XhIo7xvkFoiHhRz1H+L7M1KeQghT2ol/Uc3pk9wA/MY8rSpYGOfK4Zij5dnpx8N4gnA==
X-Received: by 2002:a17:902:d502:b0:161:bc5f:7b2d with SMTP id b2-20020a170902d50200b00161bc5f7b2dmr9675245plg.140.1653058163758;
        Fri, 20 May 2022 07:49:23 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id t4-20020a170902e84400b0015e8d4eb248sm5871611plg.146.2022.05.20.07.49.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 May 2022 07:49:23 -0700 (PDT)
Date:   Fri, 20 May 2022 14:49:19 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Yajun Deng <yajun.deng@linux.dev>, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Move kzalloc out of atomic context on
 PREEMPT_RT
Message-ID: <YoeqbxPwOnOZx5oI@google.com>
References: <20220519090218.2230653-1-yajun.deng@linux.dev>
 <YoZeI6UeQbP3t1dF@google.com>
 <f7585471-43be-4b40-f398-dfd7dc937131@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f7585471-43be-4b40-f398-dfd7dc937131@redhat.com>
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

On Fri, May 20, 2022, Paolo Bonzini wrote:
> On 5/19/22 17:11, Sean Christopherson wrote:
> > AFAICT, kfree() is safe to call under a raw spinlock, so this?  Compile tested
> > only...
> 
> Freeing outside the lock is not complicated enough to check if it is:
> 
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 6aa1241a80b7..f849f7c9fbf2 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -229,12 +229,15 @@ void kvm_async_pf_task_wake(u32 token)
>  		dummy->cpu = smp_processor_id();
>  		init_swait_queue_head(&dummy->wq);
>  		hlist_add_head(&dummy->link, &b->list);
> +		dummy = NULL;
>  	} else {
> -		kfree(dummy);
>  		apf_task_wake_one(n);
>  	}
>  	raw_spin_unlock(&b->lock);
> -	return;
> +
> +	/* A dummy token might be allocated and ultimately not used.  */
> +	if (dummy)
> +		kfree(dummy);
>  }
>  EXPORT_SYMBOL_GPL(kvm_async_pf_task_wake);
> 
> 
> I queued your patch with the above fixup.

Ha, I wrote it exactly that way, then grepped around found a few instances of kfree()
being called in side a raw spinlock, so changed it back :-)

100% agree it's not worth having to generate another patch if it turns out those
callers are wrong.
