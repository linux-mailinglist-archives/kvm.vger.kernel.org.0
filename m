Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 296A457BDF2
	for <lists+kvm@lfdr.de>; Wed, 20 Jul 2022 20:41:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbiGTSls (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jul 2022 14:41:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbiGTSlr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jul 2022 14:41:47 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBA80564F4
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 11:41:46 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id 70so17258299pfx.1
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 11:41:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mRPcgTIH6IsKIJQCeaziCyLFexZR/ta22krRMly0Teg=;
        b=BaGng3shZ0HLEiVcprmv3DhEYLH5QO6B2Gzz2znQhbWxSSwtz20BofJlzy92gS2+Ks
         sLfccM1nI921KGHdrA9wuYLeByXq35p7p6s3BMhQeqBNQkIuZOclmteF0X8qxERsGcZM
         sYNYAsU2TBM9OD9VoZKTcgUJlUWHtq8pUqdnOAfMYT4eG0f3VA2UxFq8AfosVagPpzQ9
         RyzVbi2EbB7NBlA6P+6cQcDHVDiFSdEJsuEv+yVaMEPIhtdlJQXV+MQXEaPoKeAX04je
         oVMSphvkS9w7ICg1v9maH0Sl9Wpd4g9cCAJWXpFi4y1Y1WEgik6VBqsRJezXaXNkpLSY
         27Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mRPcgTIH6IsKIJQCeaziCyLFexZR/ta22krRMly0Teg=;
        b=QiJbv9/AoHbJDZ/2YVYc9vuZGIjn76gfZ43e+2SMntttXAfhE1qfTSvZDgQbVMIUqn
         mki6ZLnZUz4NjkH45M2hVU0LaSqH+qR4KmsgVyOBEcAj6LJkTM2KxgAlZSHxdXtbq9Gg
         S3FE9RakAFHnpTXzgVO8Jv1+jYmnkAV4Vq2hjzBVl1HYr4dKutMdgALok0cLRyMmkxTT
         9n0M/jLdADiwZixIXlfS3KDvRKVjRvS0Sh5LfvP8XHUGkmZ6HP0bkBpY/9OVVdd0PLx4
         4RGDY8NtfEFsCnayNfbV2cHWgYFM1Jb/w8gZDMOGCRp41nUhCiCblkqp/PvGg/Cpkxp4
         skyQ==
X-Gm-Message-State: AJIora9C4xzKLodFjpD/lG1cUUsAnZd81ANnL3MbCLpAjNOPCQNzfjK0
        f3AlpMYyrvlYNt/LmO7hz5WzPA==
X-Google-Smtp-Source: AGRyM1uxWy16mUGxaW8i18ZKdtALJrlxMElnJ6WLC4zQ322gI6jrkxUbAfNcth/ODNiVYrlqj+3LQw==
X-Received: by 2002:a65:6b8a:0:b0:3fc:4c06:8a8d with SMTP id d10-20020a656b8a000000b003fc4c068a8dmr34410549pgw.83.1658342506207;
        Wed, 20 Jul 2022 11:41:46 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id y20-20020aa79434000000b005289f594326sm7523207pfo.69.2022.07.20.11.41.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 11:41:45 -0700 (PDT)
Date:   Wed, 20 Jul 2022 18:41:42 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Kechen Lu <kechenl@nvidia.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, chao.gao@intel.com,
        vkuznets@redhat.com, somduttar@nvidia.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v4 5/7] KVM: x86: add vCPU scoped toggling for
 disabled exits
Message-ID: <YthMZvWpZ+3gNUhM@google.com>
References: <20220622004924.155191-1-kechenl@nvidia.com>
 <20220622004924.155191-6-kechenl@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220622004924.155191-6-kechenl@nvidia.com>
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

On Tue, Jun 21, 2022, Kechen Lu wrote:
> @@ -5980,6 +5987,8 @@ int kvm_vm_ioctl_irq_line(struct kvm *kvm, struct kvm_irq_level *irq_event,
>  int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>  			    struct kvm_enable_cap *cap)
>  {
> +	struct kvm_vcpu *vcpu;
> +	unsigned long i;
>  	int r;
>  
>  	if (cap->flags)
> @@ -6036,14 +6045,17 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>  			break;
>  
>  		mutex_lock(&kvm->lock);
> -		if (kvm->created_vcpus)
> -			goto disable_exits_unlock;
> +		if (kvm->created_vcpus) {

I retract my comment about using a request, I got ahead of myself.

Don't update vCPUs, the whole point of adding the !kvm->created_vcpus check was
to avoid having to update vCPUs when the per-VM behavior changed.

In other words, keep the restriction and drop the request.

> +			kvm_for_each_vcpu(i, vcpu, kvm) {
> +				kvm_ioctl_disable_exits(vcpu->arch, cap->args[0]);
> +				kvm_make_request(KVM_REQ_DISABLE_EXITS, vcpu);
> +			}
> +		}
> +		mutex_unlock(&kvm->lock);
>  
>  		kvm_ioctl_disable_exits(kvm->arch, cap->args[0]);
>  
>  		r = 0;
> -disable_exits_unlock:
> -		mutex_unlock(&kvm->lock);
>  		break;
>  	case KVM_CAP_MSR_PLATFORM_INFO:
>  		kvm->arch.guest_can_read_msr_platform_info = cap->args[0];
> @@ -10175,6 +10187,9 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  
>  		if (kvm_check_request(KVM_REQ_UPDATE_CPU_DIRTY_LOGGING, vcpu))
>  			static_call(kvm_x86_update_cpu_dirty_logging)(vcpu);
> +
> +		if (kvm_check_request(KVM_REQ_DISABLE_EXITS, vcpu))
> +			static_call(kvm_x86_update_disabled_exits)(vcpu);
>  	}
>  
>  	if (kvm_check_request(KVM_REQ_EVENT, vcpu) || req_int_win ||
> -- 
> 2.32.0
> 
