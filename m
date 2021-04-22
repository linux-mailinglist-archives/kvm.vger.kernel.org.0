Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87349367EB9
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 12:36:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235885AbhDVKgT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 06:36:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50647 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235810AbhDVKgS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 22 Apr 2021 06:36:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619087743;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pHa3hGYdY/NebgmfQ2FScrNOSdDh9EEW0ZZOOGb69Po=;
        b=XWVF6Ap1BcGU2nvv14PYXZjBo5BPqD1GK1FcrAlkICDSPD3xWxB3hU5aXH18OD/WwxYWjU
        SHCCx/MXV2+IOUjFoBvFN0uhpQmtVHiuf5RsbSqPlKHxr8TSVc/lbAWPq8QwGtQrtO1mga
        UNPI7purI24ItduR9QN8J9XqkZeirfs=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-149-YR82iEJfNzii7nXYWr6BKA-1; Thu, 22 Apr 2021 06:34:38 -0400
X-MC-Unique: YR82iEJfNzii7nXYWr6BKA-1
Received: by mail-ed1-f70.google.com with SMTP id h13-20020a05640250cdb02903790a9c55acso16468125edb.4
        for <kvm@vger.kernel.org>; Thu, 22 Apr 2021 03:34:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pHa3hGYdY/NebgmfQ2FScrNOSdDh9EEW0ZZOOGb69Po=;
        b=iFGsU5irscgBaZu82pCrfu2lAiuOxIZenUMpIDf/kX+Il9p3uGZv7J9N3nGOogf0aq
         FWIcnLgXkl0Wq53V8mW9cQHD9M6GHDE921RSQeaV3iTI9OP2JaL1RxHJvtkez+3MQ2F/
         qKHD8ozapvefJjQ5ajLApFFFu6Cklp7VnbioAXwnJQM9IC4luvkxIxbH0GXQ3T7VOj9O
         ozeH6+WkcTpukL+/NUs0e8mVKWsIBMMt/V8bxLbZVgaKNzvq757qJybzjJauw9/7oUl7
         NaSYk0DeGdPHrK9ERUiQCXelisSyH/pwrfEJVkHT1576SnZzAeZUSo5v2FAyDRQqX555
         eHFA==
X-Gm-Message-State: AOAM532mHXhqu19gEB1B/DcsGQhu0BJ7JkJ8b8oJtJcMkJbjq/BiDpLN
        P/8PE161wkpd6a8R3JP8+u4HXZrHF/wpPZsFFIaXI1h1lvdPIMW3ZgW61jXExuzv7dNj5yY6GI4
        WO0lRnSsgV7Ah
X-Received: by 2002:a17:906:f8cd:: with SMTP id lh13mr2651224ejb.387.1619087676852;
        Thu, 22 Apr 2021 03:34:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzkWR85Sr2lbGoFYqFOR9uUIDIZO4dTU54VFc2EDX4XSQdcooksddMIxISQPqCXuy4N/bhivg==
X-Received: by 2002:a17:906:f8cd:: with SMTP id lh13mr2651207ejb.387.1619087676646;
        Thu, 22 Apr 2021 03:34:36 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id 16sm1642520ejw.0.2021.04.22.03.34.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Apr 2021 03:34:36 -0700 (PDT)
Subject: Re: [PATCH] KVM: X86: Fix always skip to boost kernel lock holder
 candidate for SEV-ES guests
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <1619080459-30032-1-git-send-email-wanpengli@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a5dc4068-050e-b651-2e8a-8e90164694a6@redhat.com>
Date:   Thu, 22 Apr 2021 12:34:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <1619080459-30032-1-git-send-email-wanpengli@tencent.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/04/21 10:34, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> Commit f1c6366e3043 ("KVM: SVM: Add required changes to support intercepts under
> SEV-ES") prevents hypervisor accesses guest register state when the guest is
> running under SEV-ES. The initial value of vcpu->arch.guest_state_protected
> is false, it will not be updated in preemption notifiers after this commit which
> means that the kernel spinlock lock holder will always be skipped to boost. Let's
> fix it by always treating preempted is in the guest kernel mode, false positive
> is better than skip completely.
> 
> Fixes: f1c6366e3043 (KVM: SVM: Add required changes to support intercepts under SEV-ES)
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>   arch/x86/kvm/x86.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index d696a9f..e52ca09 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -11151,6 +11151,9 @@ bool kvm_arch_dy_has_pending_interrupt(struct kvm_vcpu *vcpu)
>   
>   bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu)
>   {
> +	if (vcpu->arch.guest_state_protected)
> +		return true;
> +
>   	return vcpu->arch.preempted_in_kernel;
>   }
>   
> 

Queued, thanks.

Paolo

