Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF84E45EDCE
	for <lists+kvm@lfdr.de>; Fri, 26 Nov 2021 13:22:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352759AbhKZMZu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Nov 2021 07:25:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:32647 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235290AbhKZMXt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 26 Nov 2021 07:23:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637929236;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G6NT3DrZmCCNBPqWpyXXbQjjwiq+lUHxRUgVi/aTnUw=;
        b=H8J0PxvT2GoTc0Bb1J//3lJp/tH+GhuiYpUT7QDTNxHww6jwRwyjMs9uccFwqEZ6ljMfi2
        GKxYJMeCVEe/p3o74+imascDrsdegwudGvHlo8MM0HSSI5PmaFHNSQOqDQ7GMDqgVg4yr7
        rpmS1FwLnoxfy7fd84N+fimxiiDu9JQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-358-2BDCmzvePa-8jGaiSRT3vg-1; Fri, 26 Nov 2021 07:20:33 -0500
X-MC-Unique: 2BDCmzvePa-8jGaiSRT3vg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 953D9839A42;
        Fri, 26 Nov 2021 12:20:32 +0000 (UTC)
Received: from [10.39.195.16] (unknown [10.39.195.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DD7EA608BA;
        Fri, 26 Nov 2021 12:20:29 +0000 (UTC)
Message-ID: <16368a89-99ea-e52c-47b6-bd006933ec1f@redhat.com>
Date:   Fri, 26 Nov 2021 13:20:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 2/2] KVM: x86: Forbid KVM_SET_CPUID{,2} after KVM_RUN
Content-Language: en-US
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
References: <20211122175818.608220-1-vkuznets@redhat.com>
 <20211122175818.608220-3-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211122175818.608220-3-vkuznets@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/22/21 18:58, Vitaly Kuznetsov wrote:
> -	 * KVM does not correctly handle changing guest CPUID after KVM_RUN, as
> -	 * MAXPHYADDR, GBPAGES support, AMD reserved bit behavior, etc.. aren't
> -	 * tracked in kvm_mmu_page_role.  As a result, KVM may miss guest page
> -	 * faults due to reusing SPs/SPTEs.  Alert userspace, but otherwise
> -	 * sweep the problem under the rug.
> -	 *
> -	 * KVM's horrific CPUID ABI makes the problem all but impossible to
> -	 * solve, as correctly handling multiple vCPU models (with respect to
> -	 * paging and physical address properties) in a single VM would require
> -	 * tracking all relevant CPUID information in kvm_mmu_page_role.  That
> -	 * is very undesirable as it would double the memory requirements for
> -	 * gfn_track (see struct kvm_mmu_page_role comments), and in practice
> -	 * no sane VMM mucks with the core vCPU model on the fly.
> +	 * Changing guest CPUID after KVM_RUN is forbidden, see the comment in
> +	 * kvm_arch_vcpu_ioctl().
>   	 */

The second part of the comment still applies to kvm_mmu_after_set_cpuid 
more than to kvm_arch_vcpu_ioctl().

>  		r = -EFAULT;
> [...]
> +		if (vcpu->arch.last_vmentry_cpu != -1)
> +			goto out;
> +
>  		if (copy_from_user(&cpuid, cpuid_arg, sizeof(cpuid)))
>  			goto out;
>  		r = kvm_vcpu_ioctl_set_cpuid(vcpu, &cpuid, cpuid_arg->entries);

This should be an EINVAL.

Tweaked and queued nevertheless, thanks.

Paolo

