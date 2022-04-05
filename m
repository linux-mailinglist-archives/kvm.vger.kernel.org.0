Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C86EB4F4999
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 02:28:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442996AbiDEWUD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Apr 2022 18:20:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1457273AbiDEQDC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 12:03:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C3F4F20BE2
        for <kvm@vger.kernel.org>; Tue,  5 Apr 2022 08:36:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649173016;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=w5pFr+rSLwvAAi2cZv8XUzE7S/JhtL0csx8uaJExo6E=;
        b=Nl04lveKhPyC3CaRI5R6bqz1Rhsf25+UEos9E1IY+FsoVg6wTVdCxyeEIZIgIXHlIz6iGL
        z2YTqXbdlKzCC13MkM0zm5KJh+3AIwhWM/e2HG6jzkkPcQR9DnzNtiitO8Oe+Pq1vkWtpS
        5mdOp1deWMWKrs7hJiskxDt4bkX5DeM=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-622-SFm2KBCVPL6cZ2OkATUJJQ-1; Tue, 05 Apr 2022 11:36:55 -0400
X-MC-Unique: SFm2KBCVPL6cZ2OkATUJJQ-1
Received: by mail-wr1-f70.google.com with SMTP id p18-20020adfba92000000b001e8f7697cc7so2569505wrg.20
        for <kvm@vger.kernel.org>; Tue, 05 Apr 2022 08:36:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=w5pFr+rSLwvAAi2cZv8XUzE7S/JhtL0csx8uaJExo6E=;
        b=4WOKQF04xa1bx4xbBpyKPvIfLVte8upK+14tZWm1sobJkPlCBLsxWhiAfFrGQKz0gm
         qrj+AiT/QtjG+Jf9MQhQKd/4UKpefY9TZintO030ou1/8xlGyj7LT7HVl0zSCi3BGKic
         LQssPDLOKeHA8tTC0kbmEWsTB17OXZK4oiyrXj5MszSggM8jWEB/5ddZrL6qJk9sKhaF
         AdFwlleGsLvKSjEBhhMcmlcWN1W18Efk3wfjaBSUFbAZ145Rqhtm3gHQm/TLvBdITtYv
         ZGlfcwYHzNB8YFahd6yUrBxFSDvDU5PbNmHGwNgCRoD1/xonEClTUCW1a/d7PoTgtTbY
         eyFQ==
X-Gm-Message-State: AOAM531y7PA780J7p6NnF96uTAXVrCYxeOJ18mNS8l6v141c07tqLw2L
        U7g9jOPuhT6qhX4JXtkeXxa0VUOAGBw8DMprubU0bKzRad5Al/ycNP5RFk/J/6TGYrTJ7f6SurG
        9hzv3kBvUlEgI
X-Received: by 2002:a05:600c:2213:b0:38e:7138:de13 with SMTP id z19-20020a05600c221300b0038e7138de13mr3610877wml.26.1649173014493;
        Tue, 05 Apr 2022 08:36:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyD2fMFuh8JuuHOsHRwnbywieUmyYbfuQQjPfttsinL3vtfw+ztig4KQrX2KML8XIXv9oeJ5Q==
X-Received: by 2002:a05:600c:2213:b0:38e:7138:de13 with SMTP id z19-20020a05600c221300b0038e7138de13mr3610856wml.26.1649173014255;
        Tue, 05 Apr 2022 08:36:54 -0700 (PDT)
Received: from [10.32.181.87] (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.googlemail.com with ESMTPSA id c7-20020a5d4f07000000b00203db8f13c6sm12570791wru.75.2022.04.05.08.36.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Apr 2022 08:36:53 -0700 (PDT)
Message-ID: <b3d7a72d-39f8-d9dc-8811-25df504d481d@redhat.com>
Date:   Tue, 5 Apr 2022 17:36:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v5 077/104] KVM: TDX: Use vcpu_to_pi_desc() uniformly
 in posted_intr.c
Content-Language: en-US
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <ee7be7832bc424546fd4f05015a844a0205b5ba2.1646422845.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <ee7be7832bc424546fd4f05015a844a0205b5ba2.1646422845.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/4/22 20:49, isaku.yamahata@intel.com wrote:
> From: Yuan Yao <yuan.yao@intel.com>
> 
> The helper function, vcpu_to_pi_desc(), is defined to get the posted
> interrupt descriptor from vcpu.  There is one place that doesn't use it,
> but direct reference to vmx_vcpu->pi_desc.  It's inconsistent.
> 
> For TDX, TDX vcpu structure will be defined and the helper function,
> vcpu_to_pi_desc(), will return tdx_vcpu->pi_desc for TDX case instead of
> vmx_vcpu->pi_desc.  The direct reference to vmx_vcpu->pi_desc doesn't work
> for TDX.
> 
> Replace vmx_vcpu->pi_desc with the helper function, vcpu_pi_desc() for
> consistency and TDX.
> 
> Signed-off-by: Yuan Yao <yuan.yao@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/vmx/posted_intr.c | 2 +-
>   arch/x86/kvm/vmx/x86_ops.h     | 3 +++
>   2 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
> index aa1fe9085d77..c8a81c916eed 100644
> --- a/arch/x86/kvm/vmx/posted_intr.c
> +++ b/arch/x86/kvm/vmx/posted_intr.c
> @@ -311,7 +311,7 @@ int pi_update_irte(struct kvm *kvm, unsigned int host_irq, uint32_t guest_irq,
>   			continue;
>   		}
>   
> -		vcpu_info.pi_desc_addr = __pa(&to_vmx(vcpu)->pi_desc);
> +		vcpu_info.pi_desc_addr = __pa(vcpu_to_pi_desc(vcpu));
>   		vcpu_info.vector = irq.vector;
>   
>   		trace_kvm_pi_irte_update(host_irq, vcpu->vcpu_id, e->gsi,
> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> index aae0f4449ec5..0f1a28f67e60 100644
> --- a/arch/x86/kvm/vmx/x86_ops.h
> +++ b/arch/x86/kvm/vmx/x86_ops.h
> @@ -147,6 +147,9 @@ void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu);
>   void tdx_vcpu_put(struct kvm_vcpu *vcpu);
>   void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
>   
> +void tdx_apicv_post_state_restore(struct kvm_vcpu *vcpu);
> +int tdx_deliver_posted_interrupt(struct kvm_vcpu *vcpu, int vector);
> +
>   int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
>   int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
>   

Applied the first hunk, the second should be squashed somewhere else.

Paolo

