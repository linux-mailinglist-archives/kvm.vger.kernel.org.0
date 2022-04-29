Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F34E51417A
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 06:39:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237302AbiD2EmO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 00:42:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231922AbiD2EmN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 00:42:13 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6E0EBCB73
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 21:38:56 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id y16so3281875ilc.7
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 21:38:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=19w9K5HaCiHjRbqySOpO9kP4rZbUP06yF4CGml4ol5M=;
        b=R4cw/wki/iFwm7iRhPkWHnMfaPMzatdA1JE/2rLEqscDUaO2QfDeIqhtdKP+gN810J
         k62JP5taHuF/AO7Z6pblazkYdiNJEAOdt8DzJUone1x4aEdeAmmS5gt7oL2CUun4mJaj
         xJkcG4G2pmga03RXtSOew01OlpATmK9VH/sm1okizbouCqWAYYvSt2nxKwm5wj2Ae2mo
         MFlvITdX0Zh0L1tseUkF1BqDE9Hq4ER4CuXLDk/3YzkZOYgTEZTuDnAJupmEg8DvOqVC
         zWlSrBKV7ME+wuo5wKE1odp102ihdkH0wZ9tpbd7GHlTeQMWlWHDrj0V8hdD9s5h7dYY
         XhLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=19w9K5HaCiHjRbqySOpO9kP4rZbUP06yF4CGml4ol5M=;
        b=iVI/0qsD5DZZDuHnm7D2fxLLi93zxd0hOM2obei2s9XmE5uCz3aXIi0YqbjhCXCwzy
         T/+D9vwNczBQgfONdPBMRjboqn1JgKmQ1BfUnNdHQYDZA0QqIRpgYNOEvKfT4LvGCPPH
         0vOvrYjH/uF5/LigsIdVAKUkiU9o2Z4g/WAa+u1PLNtU1roYhEagHZX4au2994D/gTYl
         SOa0TyC6+VWBHeIi3o5vjvvMvKza1dzym2KpWSPbK3ov9xz/fIIzV2mgjcu7IJ25tKS8
         o+GDYOGDSyFUzM3UEsrXH9+JlW8GVdowUGpu7pgSpvfESQnvb2/X28k0Po4JjrrN5xQ2
         KKvQ==
X-Gm-Message-State: AOAM533LtvAOYekWE7PTwRwJKlwORRAhjwrnTrtp7TvvH5ZWGGfAU//1
        5atp2PFAFnWfTfZabktTDE4DXg==
X-Google-Smtp-Source: ABdhPJyxDMqYk49p1uy6rirkq94xw3yTmM/j/dWmpoo8+aVR3dDr9Ah9T6IdPQUYi1KONcGugXxSfw==
X-Received: by 2002:a92:c24c:0:b0:2cd:8a7d:b606 with SMTP id k12-20020a92c24c000000b002cd8a7db606mr11123474ilo.64.1651207135640;
        Thu, 28 Apr 2022 21:38:55 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id r7-20020a02c6c7000000b0032b3a781792sm281222jan.86.2022.04.28.21.38.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 21:38:54 -0700 (PDT)
Date:   Fri, 29 Apr 2022 04:38:50 +0000
From:   Oliver Upton <oupton@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Peter Gonda <pgonda@google.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH for-5.18] KVM: fix bad user ABI for KVM_EXIT_SYSTEM_EVENT
Message-ID: <Ymtr2mfyujoxLsDR@google.com>
References: <20220422103013.34832-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220422103013.34832-1-pbonzini@redhat.com>
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

Hi Paolo,

On Fri, Apr 22, 2022 at 12:30:13PM +0200, Paolo Bonzini wrote:
> When KVM_EXIT_SYSTEM_EVENT was introduced, it included a flags
> member that at the time was unused.  Unfortunately this extensibility
> mechanism has several issues:
> 
> - x86 is not writing the member, so it is not possible to use it
>   on x86 except for new events
> 
> - the member is not aligned to 64 bits, so the definition of the
>   uAPI struct is incorrect for 32-bit userspace.  This is a problem
>   for RISC-V, which supports CONFIG_KVM_COMPAT.
> 
> Since padding has to be introduced, place a new field in there
> that tells if the flags field is valid.  To allow further extensibility,
> in fact, change flags to an array of 16 values, and store how many
> of the values are valid.  The availability of the new ndata field
> is tied to a system capability; all architectures are changed to
> fill in the field.
> 
> For compatibility with userspace that was using the flags field,
> a union overlaps flags with data[0].
> 
> Supersedes: <20220421180443.1465634-1-pbonzini@redhat.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Peter Gonda <pgonda@google.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  Documentation/virt/kvm/api.rst | 24 +++++++++++++++++-------
>  arch/arm64/kvm/psci.c          |  3 ++-
>  arch/riscv/kvm/vcpu_sbi.c      |  3 ++-
>  arch/x86/kvm/x86.c             |  2 ++
>  include/uapi/linux/kvm.h       |  8 +++++++-
>  virt/kvm/kvm_main.c            |  1 +
>  6 files changed, 31 insertions(+), 10 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 85c7abc51af5..4a900cdbc62e 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -5986,16 +5986,16 @@ should put the acknowledged interrupt vector into the 'epr' field.
>    #define KVM_SYSTEM_EVENT_RESET          2
>    #define KVM_SYSTEM_EVENT_CRASH          3
>  			__u32 type;
> -			__u64 flags;
> +                        __u32 ndata;
> +                        __u64 data[16];

This is out of sync with the union { flags; data; } now.

IMO, we should put a giant disclaimer on all of this to *not* use the
flags field and instead only use data. I imagine we wont want to persist
the union forever as it is quite ugly, but necessary.

[...]

> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 91a6fe4e02c0..f903ab0c8d7a 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -445,7 +445,11 @@ struct kvm_run {
>  #define KVM_SYSTEM_EVENT_RESET          2
>  #define KVM_SYSTEM_EVENT_CRASH          3
>  			__u32 type;
> -			__u64 flags;
> +			__u32 ndata;
> +			union {
> +				__u64 flags;
> +				__u64 data[16];
> +			};
>  		} system_event;
>  		/* KVM_EXIT_S390_STSI */
>  		struct {
> @@ -1144,6 +1148,8 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_S390_MEM_OP_EXTENSION 211
>  #define KVM_CAP_PMU_CAPABILITY 212
>  #define KVM_CAP_DISABLE_QUIRKS2 213
> +/* #define KVM_CAP_VM_TSC_CONTROL 214 */

This sticks out a bit. Couldn't the VM TSC control patch just use a
different number? It seems that there will be a conflict anyway, if only to
delete this comment.

How do we go about getting CAP numbers for features coming in from other
architectures? An eager backport (such as the Android case that made us
look at a union) would wind up using the wrong capability for a feature.

--
Thanks,
Oliver
