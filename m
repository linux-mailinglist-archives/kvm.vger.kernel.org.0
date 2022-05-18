Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45AF252C284
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 20:45:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241522AbiERSnC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 14:43:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241501AbiERSm7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 14:42:59 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A32431EEE3E
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 11:42:58 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id l7-20020a17090aaa8700b001dd1a5b9965so2940987pjq.2
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 11:42:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=x+g2rI3f9oK4A/om4OOZJvYEp73ECKayN/tR0aYxCMw=;
        b=Q80G3RnbtpvRJA63+uR6stq540RtUi4AagkeurUmvxepwPIQRsgp8o8jj08wIst1hG
         Is278rav3tXRlFrJPNWNIYazK7OwAx1d+JizqaI/U52yB9Qm0owpfsRqfmufiglC9cYQ
         Gj+rx6J7czR8BwSWk8T0JAG/gJb91ETDVGKSIqRGgT6GMFXKTXl2AIrwYI8jdY5kQxPQ
         A+q/cpwzEV7Jx8xNAVgc3fp3WC3JuxaWaLvdOTtuCcuhkRDHQDnUKUHjVFaFj0CNVOgB
         o5Q/HMMhKHjghY8zWmQ4LGaaWIf72CR/NmoIUb1DjrSbnc+HKod2Go3FGxUpy3YUEK//
         zBXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=x+g2rI3f9oK4A/om4OOZJvYEp73ECKayN/tR0aYxCMw=;
        b=Dx7i/HyvVHwXhIjIXRjzWS6MkfBkk6fuJKqLCfNlVLfyOrx+L/VRhPmDB49Pea213j
         4eWc5mhHVjD7PI8rHVY3tMVymGaxGUpdISmuae5zVaVl1d5E5jRao9Iuc5Pclq5kQ70q
         8s4p+jEtWzvTM2QH/eIixgg8nnVEW/mgO+VT6rm58tkTGZwa+GXkCa7TdYW7ffYxL4MB
         iquwP2Xy4sGTLTxnEacdKHGpjIwjce/7jfUlvlNs2aI3/3AjEM3yIUSoWbn5FnHqGUqk
         Orp1RmZQIsnK273p6yJs+PVkNSfugVEg6V0c2iBQFHCukj/eqBz+MeQRyZrPHB/1Vly8
         v6CA==
X-Gm-Message-State: AOAM533/5+7ElvdTvsX+cYvAn+A25Vojy2CdtXMNyS0ucdfV+S/Z5MDK
        eTTJeEj1uIdaAC+h+N1dGVi53Q==
X-Google-Smtp-Source: ABdhPJyRrDGCtxh9RJlRWdSxB1pWuIzfZFdraxOUaO2zUZx3ip0YIZGag6vXuR9V8JKYHtmC6BxhKg==
X-Received: by 2002:a17:902:e745:b0:15e:c057:d452 with SMTP id p5-20020a170902e74500b0015ec057d452mr896003plf.69.1652899377950;
        Wed, 18 May 2022 11:42:57 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id b19-20020a17090a991300b001df4a0e9357sm1957705pjp.12.2022.05.18.11.42.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 11:42:57 -0700 (PDT)
Date:   Wed, 18 May 2022 18:42:54 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Chenyi Qiang <chenyi.qiang@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 1/3] KVM: X86: Save&restore the triple fault request
Message-ID: <YoU+LgHbeiYNbDJ8@google.com>
References: <20220421072958.16375-1-chenyi.qiang@intel.com>
 <20220421072958.16375-2-chenyi.qiang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220421072958.16375-2-chenyi.qiang@intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Nits on the shortlog...

Please don't capitalize x86, spell out "and" instead of using an ampersand (though
I think it can be omitted entirely), and since there are plenty of chars left, call
out that this is adding/extending KVM's ABI, e.g. it's not obvious from the shortlog
where/when the save+restore happens.

  KVM: x86: Extend KVM_{G,S}ET_VCPU_EVENTS to support pending triple fault

On Thu, Apr 21, 2022, Chenyi Qiang wrote:
> For the triple fault sythesized by KVM, e.g. the RSM path or
> nested_vmx_abort(), if KVM exits to userspace before the request is
> serviced, userspace could migrate the VM and lose the triple fault.
> 
> Add the support to save and restore the triple fault event from
> userspace. Introduce a new event KVM_VCPUEVENT_VALID_TRIPLE_FAULT in
> get/set_vcpu_events to track the triple fault request.
> 
> Note that in the set_vcpu_events path, userspace is able to set/clear
> the triple fault request through triple_fault_pending field.
> 
> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> ---
>  Documentation/virt/kvm/api.rst  |  7 +++++++
>  arch/x86/include/uapi/asm/kvm.h |  4 +++-
>  arch/x86/kvm/x86.c              | 15 +++++++++++++--
>  3 files changed, 23 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 72183ae628f7..e09ce3cb49c5 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -1150,6 +1150,9 @@ The following bits are defined in the flags field:
>    fields contain a valid state. This bit will be set whenever
>    KVM_CAP_EXCEPTION_PAYLOAD is enabled.
>  
> +- KVM_VCPUEVENT_VALID_TRIPLE_FAULT may be set to signal that the
> +  triple_fault_pending field contains a valid state.
> +
>  ARM64:
>  ^^^^^^
>  
> @@ -1245,6 +1248,10 @@ can be set in the flags field to signal that the
>  exception_has_payload, exception_payload, and exception.pending fields
>  contain a valid state and shall be written into the VCPU.
>  
> +KVM_VCPUEVENT_VALID_TRIPLE_FAULT can be set in flags field to signal that
> +the triple_fault_pending field contains a valid state and shall be written
> +into the VCPU.
> +
>  ARM64:
>  ^^^^^^
>  
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index 21614807a2cb..fd083f6337af 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -325,6 +325,7 @@ struct kvm_reinject_control {
>  #define KVM_VCPUEVENT_VALID_SHADOW	0x00000004
>  #define KVM_VCPUEVENT_VALID_SMM		0x00000008
>  #define KVM_VCPUEVENT_VALID_PAYLOAD	0x00000010
> +#define KVM_VCPUEVENT_VALID_TRIPLE_FAULT	0x00000020
>  
>  /* Interrupt shadow states */
>  #define KVM_X86_SHADOW_INT_MOV_SS	0x01
> @@ -359,7 +360,8 @@ struct kvm_vcpu_events {
>  		__u8 smm_inside_nmi;
>  		__u8 latched_init;
>  	} smi;
> -	__u8 reserved[27];
> +	__u8 triple_fault_pending;

What about writing this as

	struct {
		__u8 pending;
	} triple_fault;

to match the other events?  It's kinda silly, but I find it easier to visually
identify the various events that are handled by kvm_vcpu_events.

> +	__u8 reserved[26];
>  	__u8 exception_has_payload;
>  	__u64 exception_payload;
>  };
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index ab336f7c82e4..c8b9b0bc42aa 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4911,9 +4911,12 @@ static void kvm_vcpu_ioctl_x86_get_vcpu_events(struct kvm_vcpu *vcpu,
>  		!!(vcpu->arch.hflags & HF_SMM_INSIDE_NMI_MASK);
>  	events->smi.latched_init = kvm_lapic_latched_init(vcpu);
>  
> +	events->triple_fault_pending = kvm_test_request(KVM_REQ_TRIPLE_FAULT, vcpu);
> +
>  	events->flags = (KVM_VCPUEVENT_VALID_NMI_PENDING
>  			 | KVM_VCPUEVENT_VALID_SHADOW
> -			 | KVM_VCPUEVENT_VALID_SMM);
> +			 | KVM_VCPUEVENT_VALID_SMM
> +			 | KVM_VCPUEVENT_VALID_TRIPLE_FAULT);

Does setting KVM_VCPUEVENT_VALID_TRIPLE_FAULT need to be guarded with a capability,
a la KVM_CAP_EXCEPTION_PAYLOAD, so that migrating from a new KVM to an old KVM doesn't
fail?  Seems rather pointless since the VM is likely hosed either way...

>  	if (vcpu->kvm->arch.exception_payload_enabled)
>  		events->flags |= KVM_VCPUEVENT_VALID_PAYLOAD;
