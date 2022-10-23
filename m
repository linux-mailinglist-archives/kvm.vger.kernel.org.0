Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE5AC60953E
	for <lists+kvm@lfdr.de>; Sun, 23 Oct 2022 19:49:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230311AbiJWRtA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 23 Oct 2022 13:49:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230070AbiJWRsy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 23 Oct 2022 13:48:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28C4760C85
        for <kvm@vger.kernel.org>; Sun, 23 Oct 2022 10:48:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666547332;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vEfdKErJsUmUR1/yos9QP+bNAkmXMZOsQ2d8ha8BHWU=;
        b=eA+bk085fs22a6z9cRRCaOguYxH43SynmQReYqhkIh1fpQNbgQ/vAaTMpFzsZ4IDmbaziK
        AOlUd3NKRMexwItwAuC11bkF2RgLOSMmnvVJcbZykGcyTkRPCh3H0/z9aaboUOK16bewvj
        K+SxTInU0zxqYAJbuAVr9G8Pb0Bo9ls=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-573-Ip7Leo-zOYCT_yu5NFQ3cw-1; Sun, 23 Oct 2022 13:48:50 -0400
X-MC-Unique: Ip7Leo-zOYCT_yu5NFQ3cw-1
Received: by mail-ed1-f71.google.com with SMTP id y14-20020a056402270e00b0045d1baf4951so7336581edd.11
        for <kvm@vger.kernel.org>; Sun, 23 Oct 2022 10:48:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vEfdKErJsUmUR1/yos9QP+bNAkmXMZOsQ2d8ha8BHWU=;
        b=xIkze+OKOC1iIFDKhSOfkgfcf9hcsLJIykrNSyl093h0KFijK/bieTpWK3vAgmhaTX
         iGAqzVJNvB/nlinvU2zzx4eiHubJXbxIRe/QSss8cjc4gig8rw1eZggTYirKPYoHqosV
         XDCh4GC00er9w/ymmmVQF2SglZyfTyJm3CUPutnEoFNE4f7FCsMfXJ/OOTOV8Dh0XzqI
         zFsItIJAkmi2GRvHGoG+Dp5V10O3o7AVBKnh7jPE8gHp/Bdm/05TzsN6eV/xM9Xl8I9i
         fJNinuVqm1lJQ4r0XDFORkd0e4jVY0qU1salVP9Dl82fI+Wk8T5m19GSZfG2uVKCtPSX
         m63A==
X-Gm-Message-State: ACrzQf0FR8amqrpZn+gLFYKv3K56duJcijLd/lMnjt9GdnYVtafyvvwi
        NlusWBG5xJmBiLaeecIGYaxL4oHxvrU9QE2KRtUXOsiyBABde95gw8DtcrXtyQBTSfgLNdvYRnV
        6C5fzly1yUtzz
X-Received: by 2002:a17:907:168e:b0:7a1:6786:f16 with SMTP id hc14-20020a170907168e00b007a167860f16mr6419721ejc.590.1666547329196;
        Sun, 23 Oct 2022 10:48:49 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6mUSKfu9T6DkHEU5jtf2+fA27CrmXJC26pSFEwAcm+BNpJmvPPw8rKJG5A939hZ5MB5VCcgg==
X-Received: by 2002:a17:907:168e:b0:7a1:6786:f16 with SMTP id hc14-20020a170907168e00b007a167860f16mr6419696ejc.590.1666547328896;
        Sun, 23 Oct 2022 10:48:48 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id w5-20020a17090649c500b007789e7b47besm14238632ejv.25.2022.10.23.10.48.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 Oct 2022 10:48:47 -0700 (PDT)
Message-ID: <5ee4eeb8-4d61-06fc-f80d-06efeeffe902@redhat.com>
Date:   Sun, 23 Oct 2022 19:48:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH 4/4] KVM: use signals to abort enter_guest/blocking and
 retry
Content-Language: en-US
To:     Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        kvm@vger.kernel.org
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Hildenbrand <david@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20221022154819.1823133-1-eesposit@redhat.com>
 <20221022154819.1823133-5-eesposit@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20221022154819.1823133-5-eesposit@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/22/22 17:48, Emanuele Giuseppe Esposito wrote:
> Once a vcpu exectues KVM_RUN, it could enter two states:
> enter guest mode, or block/halt.
> Use a signal to allow a vcpu to exit the guest state or unblock,
> so that it can exit KVM_RUN and release the read semaphore,
> allowing a pending KVM_KICK_ALL_RUNNING_VCPUS to continue.
> 
> Note that the signal is not deleted and used to propagate the
> exit reason till vcpu_run(). It will be clearead only by
> KVM_RESUME_ALL_KICKED_VCPUS. This allows the vcpu to keep try
> entering KVM_RUN and perform again all checks done in
> kvm_arch_vcpu_ioctl_run() before entering the guest state,
> where it will return again if the request is still set.
> 
> However, the userspace hypervisor should also try to avoid
> continuously calling KVM_RUN after invoking KVM_KICK_ALL_RUNNING_VCPUS,
> because such call will just translate in a back-to-back down_read()
> and up_read() (thanks to the signal).

Since the userspace should anyway avoid going into this effectively-busy 
wait, what about clearing the request after the first exit?  The 
cancellation ioctl can be kept for vCPUs that are never entered after 
KVM_KICK_ALL_RUNNING_VCPUS.  Alternatively, kvm_clear_all_cpus_request 
could be done right before up_write().

Paolo

> Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
> ---
>   arch/x86/include/asm/kvm_host.h |  2 ++
>   arch/x86/kvm/x86.c              |  8 ++++++++
>   virt/kvm/kvm_main.c             | 21 +++++++++++++++++++++
>   3 files changed, 31 insertions(+)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index aa381ab69a19..d5c37f344d65 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -108,6 +108,8 @@
>   	KVM_ARCH_REQ_FLAGS(30, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
>   #define KVM_REQ_MMU_FREE_OBSOLETE_ROOTS \
>   	KVM_ARCH_REQ_FLAGS(31, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
> +#define KVM_REQ_USERSPACE_KICK		\
> +	KVM_ARCH_REQ_FLAGS(32, KVM_REQUEST_WAIT)
>   
>   #define CR0_RESERVED_BITS                                               \
>   	(~(unsigned long)(X86_CR0_PE | X86_CR0_MP | X86_CR0_EM | X86_CR0_TS \
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index b0c47b41c264..2af5f427b4e9 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10270,6 +10270,10 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>   	}
>   
>   	if (kvm_request_pending(vcpu)) {
> +		if (kvm_test_request(KVM_REQ_USERSPACE_KICK, vcpu)) {
> +			r = -EINTR;
> +			goto out;
> +		}
>   		if (kvm_check_request(KVM_REQ_VM_DEAD, vcpu)) {
>   			r = -EIO;
>   			goto out;
> @@ -10701,6 +10705,10 @@ static int vcpu_run(struct kvm_vcpu *vcpu)
>   			r = vcpu_block(vcpu);
>   		}
>   
> +		/* vcpu exited guest/unblocked because of this request */
> +		if (kvm_test_request(KVM_REQ_USERSPACE_KICK, vcpu))
> +			return -EINTR;
> +
>   		if (r <= 0)
>   			break;
>   
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index ae0240928a4a..13fa7229b85d 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3431,6 +3431,8 @@ static int kvm_vcpu_check_block(struct kvm_vcpu *vcpu)
>   		goto out;
>   	if (kvm_check_request(KVM_REQ_UNBLOCK, vcpu))
>   		goto out;
> +	if (kvm_test_request(KVM_REQ_USERSPACE_KICK, vcpu))
> +		goto out;
>   
>   	ret = 0;
>   out:
> @@ -4668,6 +4670,25 @@ static long kvm_vm_ioctl(struct file *filp,
>   		r = kvm_vm_ioctl_enable_cap_generic(kvm, &cap);
>   		break;
>   	}
> +	case KVM_KICK_ALL_RUNNING_VCPUS: {
> +		/*
> +		 * Notify all running vcpus that they have to stop.
> +		 * Caught in kvm_arch_vcpu_ioctl_run()
> +		 */
> +		kvm_make_all_cpus_request(kvm, KVM_REQ_USERSPACE_KICK);
> +
> +		/*
> +		 * Use wr semaphore to wait for all vcpus to exit from KVM_RUN.
> +		 */
> +		down_write(&memory_transaction);
> +		up_write(&memory_transaction);
> +		break;
> +	}
> +	case KVM_RESUME_ALL_KICKED_VCPUS: {
> +		/* Remove all requests sent with KVM_KICK_ALL_RUNNING_VCPUS */
> +		kvm_clear_all_cpus_request(kvm, KVM_REQ_USERSPACE_KICK);
> +		break;
> +	}
>   	case KVM_SET_USER_MEMORY_REGION: {
>   		struct kvm_userspace_memory_region kvm_userspace_mem;
>   

