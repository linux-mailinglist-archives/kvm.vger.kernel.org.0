Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90255502C37
	for <lists+kvm@lfdr.de>; Fri, 15 Apr 2022 17:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354753AbiDOPDJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 11:03:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354747AbiDOPDI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 11:03:08 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A4AE9BB8D
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 08:00:40 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id q12so7431919pgj.13
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 08:00:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=puJYXDXIW0rt8QlOAX8cnmpWvo/2m86AP/4nXdIuCaM=;
        b=g26YDFoRTCVJqAQ1bQPPP206qrINE01PTp/ltfRYl5QRsvGRE/oNJHn/YKu8/Hdz7D
         SslOKcwIS3sbin2n30FPIxOP0s8V5YP60asdGLLNz1G7G0MdbCgWwh1b6fbVZMSe3548
         uWd9WuTxl09t0yIdI+aEyouNQEvnNdJRrW+0/+eBGdN7112r6yGrIpYd+qGLE/anvBrG
         p+qWppfXNktBeKFTWcw/4DHzHNsH4qzOfhVAyhgnDWcmJa0H67x73W0GySXey9gfWgo9
         +A2cVLGre8M/xs6A+ME4JqvTheu9bOq62z8QvOGUeerpn8YpbcDdaXoyMoB7NQJtwwWg
         xs8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=puJYXDXIW0rt8QlOAX8cnmpWvo/2m86AP/4nXdIuCaM=;
        b=ynuLiiWE+8BmIvuaLqyEooMjGJmgPYz2ITc2BBRZb01v3+SgyWVKmMSLAr4eCuOtie
         ndidPV+t0fRbDL3GZ57IDTddTXOxnu3UG3tvQSwE7aLU+wGhw5hEMAGOe5NdF3nJXBNF
         +mauvW+oUOLPj7WygqL8cZ1vLNqGMNIQER1nK08HMrP+SfawnuK6Mi9FgoHHM7vtwUdE
         2qCNKvVLMVpKoHi4SzhipfngeP8omV27ZTwv6VITScb46e3qVrGL3jFhtvzt/sRyTqNQ
         O+kbfR2bV+14T4QFzvKPclGq9ou8zaSguW6rZqQKZ0SKztGY3ANfxCrds5W70BIRVnI4
         JrwA==
X-Gm-Message-State: AOAM533xeGJEFUZouLZKI3Qu+2aOc0Y4mhTPX1M5ux6TXUo+60nDzBfd
        EmOvlnyBPuBmkirSG/u/QW6H/Q==
X-Google-Smtp-Source: ABdhPJzk7aORYIMqLZthRfu69nMvBHnPiUK3Sk94Ct49BMz0eQ9L1wFRyxXefgqYIPifvV5tHDqKZQ==
X-Received: by 2002:a05:6a00:22cf:b0:505:c880:41dc with SMTP id f15-20020a056a0022cf00b00505c88041dcmr9314157pfj.80.1650034839229;
        Fri, 15 Apr 2022 08:00:39 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id oo16-20020a17090b1c9000b001b89e05e2b2sm5408549pjb.34.2022.04.15.08.00.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 08:00:38 -0700 (PDT)
Date:   Fri, 15 Apr 2022 15:00:34 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Zeng Guang <guang.zeng@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Kai Huang <kai.huang@intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Robert Hu <robert.hu@intel.com>,
        Gao Chao <chao.gao@intel.com>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
Subject: Re: [PATCH v8 7/9] KVM: Move kvm_arch_vcpu_precreate() under
 kvm->lock
Message-ID: <YlmIko9PbQMMKceU@google.com>
References: <20220411090447.5928-1-guang.zeng@intel.com>
 <20220411090447.5928-8-guang.zeng@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220411090447.5928-8-guang.zeng@intel.com>
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

Heh, lot's of people cc'd, but none of the people who's code this affects.

+s390 and arm folks

On Mon, Apr 11, 2022, Zeng Guang wrote:
> Arch specific KVM common data may require pre-allocation or other
> preprocess ready before vCPU creation at runtime.

Please provide the specific motivation for the move, i.e. explain the desire to
do per-VM allocations based on max_vcpu_ids at the first vCPU creation.

> It's safe to invoke kvm_arch_vcpu_precreate() within the protection of
> kvm->lock directly rather than take into account in the implementation for
> each architecture.

This absolutely needs to explain _why_ it's safe, e.g. only arm64, x86, and s390
have non-nop implementations and they're all simple and short with no tendrils
into other code that might take kvm->lock.

And as before, I suspect arm64 needs this protection, the vgic_initialized()
check looks racy.  Though it's hard to tell if doing the check under kvm->lock
actually fixes anything.

> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Zeng Guang <guang.zeng@intel.com>
> ---
>  arch/s390/kvm/kvm-s390.c | 2 --
>  virt/kvm/kvm_main.c      | 2 +-

I think it's also worth changing x86's implementation to check created_vcpus
instead of online_vcpus.  That'll fix a race where userspace could never see the
pr_warn() (which is arguably useless, but whatever), e.g. if it creates a VM with
2 vCPUs and both simultaneously go through kvm_arch_vcpu_precreate().

>  2 files changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 156d1c25a3c1..5c795bbcf1ea 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -3042,9 +3042,7 @@ static int sca_can_add_vcpu(struct kvm *kvm, unsigned int id)
>  	if (!sclp.has_esca || !sclp.has_64bscao)
>  		return false;
>  
> -	mutex_lock(&kvm->lock);
>  	rc = kvm->arch.use_esca ? 0 : sca_switch_to_extended(kvm);
> -	mutex_unlock(&kvm->lock);
>  
>  	return rc == 0 && id < KVM_S390_ESCA_CPU_SLOTS;
>  }
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 70e05af5ebea..a452e678a015 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3732,9 +3732,9 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
>  	}
>  
>  	kvm->created_vcpus++;
> +	r = kvm_arch_vcpu_precreate(kvm, id);

Hmm, so I think I'd prefer this to be invoked before bumping created_vcpus.  The
existing implementation don't reference created_vcpus, so there's no change needed
to existing code.  Logically, a pre-create helper should not see a non-zero count
as the "pre" part strongly implies it's being called _before_ creating the first vCPU.

Then switching from online_vcpus to created_vcpus in the x86 implementation doesn't
need to have a wierd change from "> 0" => "> 1".

Ah, and then it also wouldn't have goofy behavior where it drops and reacquires
kvm->lock on failure just to decrement created_vcpus.

>  	mutex_unlock(&kvm->lock);
>  
> -	r = kvm_arch_vcpu_precreate(kvm, id);
>  	if (r)
>  		goto vcpu_decrement;
>  
> -- 
> 2.27.0
> 
