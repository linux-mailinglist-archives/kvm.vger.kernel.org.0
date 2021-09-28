Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFA0641B9D5
	for <lists+kvm@lfdr.de>; Wed, 29 Sep 2021 00:04:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243017AbhI1WGf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Sep 2021 18:06:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242899AbhI1WGe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Sep 2021 18:06:34 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3B2DC061746
        for <kvm@vger.kernel.org>; Tue, 28 Sep 2021 15:04:52 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id il14-20020a17090b164e00b0019c7a7c362dso2727954pjb.0
        for <kvm@vger.kernel.org>; Tue, 28 Sep 2021 15:04:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=s8TgaTkuAOfttq5Ji23XuWmZEPg/t1pbW45rjrv+GjY=;
        b=LOKBGSSThTGJmZr52wMlTVIXy7gN0kcixsV7n11azJM+wFcpy4hdoZIRhH6FjCUukF
         R3ek08fGm45mGkuiA0+Kxm49I86GkQOabdwCzh/L7J8ZtTUESfVtBd1ViQEJJ5vZmB0j
         gVM3+sKMqY01a6pRSxMH/JV7N2k8jZaoTStvXT/CW+6ekMegbYoSEeVNZm/knJC1H2Iz
         JpHolIs35AjaAocSgJu4Q8l0875P6gOMqZFX8yYi8BLrJDNQk0tBeB5SUgTVoQJk7Bxc
         TaQ1FhIIJDiukqtBzIRTPyLdyC5LfChFTqz2xnOAHZ/G/Ty6/PTiLDypDINxMIzqkG+p
         MNEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=s8TgaTkuAOfttq5Ji23XuWmZEPg/t1pbW45rjrv+GjY=;
        b=uWVky7oxWrX/FXMunhP0NBFa6b58EEqR5SZN0Bw6eYP0+nkrrusT3pjaTbn3As4/3o
         qxNUX1iBE4JXzRD3VxxL3PxCfA3Th3qVGGrPScYJ/MxZ78aySzt6qab2CBrw1AvErosy
         /DG81eiGlgHUTV2JJIDAHvOqNccSE73Ph2NbBxEr9/F4yiKVj2mMp51KT0+as8nekC8J
         rpHfP+KwE4bFNk4f3s1ePscTkSM08uXPJ/0Upgsq8GNLvLC7FkLKfxm2HFkt398p2WqH
         vuNYSuGQoBTBpcpZIKgOrO1Cm6NGsb9Yzqt1o0ieBOf1TWzDY7K4OIjSta+OCcQhw0MX
         VhBQ==
X-Gm-Message-State: AOAM530WBDhkfnxVKpITVZFSXeXFEkpdTi8GqGa7vNHw6j2n8ITt774C
        bxZ0aFXiMj+J25eEHHnarbKlWQ==
X-Google-Smtp-Source: ABdhPJyZYZhKpQUljc7RVXwKUERY34mYmQfs2NuJ723fR6n2a6r5wthdOfaTSfpkU7ajTH5d6X1x0g==
X-Received: by 2002:a17:90a:c982:: with SMTP id w2mr2466336pjt.30.1632866692006;
        Tue, 28 Sep 2021 15:04:52 -0700 (PDT)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id v26sm124276pfm.175.2021.09.28.15.04.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Sep 2021 15:04:51 -0700 (PDT)
Date:   Tue, 28 Sep 2021 22:04:47 +0000
From:   David Matlack <dmatlack@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jing Zhang <jingzhangos@google.com>
Subject: Re: [PATCH 11/14] KVM: stats: Add stat to detect if vcpu is
 currently blocking
Message-ID: <YVORf599tkw3MdGZ@google.com>
References: <20210925005528.1145584-1-seanjc@google.com>
 <20210925005528.1145584-12-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210925005528.1145584-12-seanjc@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 24, 2021 at 05:55:25PM -0700, Sean Christopherson wrote:
> From: Jing Zhang <jingzhangos@google.com>
> 
> Add a "blocking" stat that userspace can use to detect the case where a
> vCPU is not being run because of a vCPU/guest action, e.g. HLT or WFS on
> x86, WFI on arm64, etc...  Current guest/host/halt stats don't show this
> well, e.g. if a guest halts for a long period of time then the vCPU could
> appear pathologically blocked due to a host condition, when in reality the
> vCPU has been put into a not-runnable state by the guest.
> 
> Originally-by: Cannon Matthews <cannonmatthews@google.com>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Jing Zhang <jingzhangos@google.com>
> [sean: renamed stat to "blocking", massaged changelog]
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: David Matlack <dmatlack@google.com>
> ---
>  include/linux/kvm_host.h  | 3 ++-
>  include/linux/kvm_types.h | 1 +
>  virt/kvm/kvm_main.c       | 2 ++
>  3 files changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 655c2b24db2d..9bb1972e396a 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1453,7 +1453,8 @@ struct _kvm_stats_desc {
>  	STATS_DESC_LOGHIST_TIME_NSEC(VCPU_GENERIC, halt_poll_fail_hist,	       \
>  			HALT_POLL_HIST_COUNT),				       \
>  	STATS_DESC_LOGHIST_TIME_NSEC(VCPU_GENERIC, halt_wait_hist,	       \
> -			HALT_POLL_HIST_COUNT)
> +			HALT_POLL_HIST_COUNT),				       \
> +	STATS_DESC_ICOUNTER(VCPU_GENERIC, blocking)
>  
>  extern struct dentry *kvm_debugfs_dir;
>  
> diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
> index 2237abb93ccd..c4f9257bf32d 100644
> --- a/include/linux/kvm_types.h
> +++ b/include/linux/kvm_types.h
> @@ -94,6 +94,7 @@ struct kvm_vcpu_stat_generic {
>  	u64 halt_poll_success_hist[HALT_POLL_HIST_COUNT];
>  	u64 halt_poll_fail_hist[HALT_POLL_HIST_COUNT];
>  	u64 halt_wait_hist[HALT_POLL_HIST_COUNT];
> +	u64 blocking;
>  };
>  
>  #define KVM_STATS_NAME_SIZE	48
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index fe34457530c2..2980d2b88559 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3208,6 +3208,7 @@ bool kvm_vcpu_block(struct kvm_vcpu *vcpu)
>  {
>  	bool waited = false;
>  
> +	vcpu->stat.generic.blocking = 1;
>  	kvm_arch_vcpu_blocking(vcpu);
>  
>  	prepare_to_rcuwait(&vcpu->wait);
> @@ -3223,6 +3224,7 @@ bool kvm_vcpu_block(struct kvm_vcpu *vcpu)
>  	finish_rcuwait(&vcpu->wait);
>  
>  	kvm_arch_vcpu_unblocking(vcpu);
> +	vcpu->stat.generic.blocking = 0;
>  
>  	return waited;
>  }
> -- 
> 2.33.0.685.g46640cef36-goog
> 
