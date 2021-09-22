Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0D904145B1
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 12:02:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234531AbhIVKEV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 06:04:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47191 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234233AbhIVKER (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Sep 2021 06:04:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632304967;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Qb8DRYmAxRXlFdlb2jYQeeG3H/2W6Rld2Q8cOt11XZU=;
        b=MdY+iWCAZ/w27WObw6lm7KCoA2LVoaKUJznXA3nFKc2pELkpjurZMYM3PXZJl0wbpNfZQc
        eq0B+qH6H/n9gOrIOgBgVBu74smCmfhcJI/1xFYCpt1wWjucmYY9HLNZAVM1i2esBi4fmR
        cSGWulPMpcvwBnrJXcVfu0rU9DB7H64=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-62-UNShy47pP0yU00q0-flmCQ-1; Wed, 22 Sep 2021 06:02:46 -0400
X-MC-Unique: UNShy47pP0yU00q0-flmCQ-1
Received: by mail-ed1-f72.google.com with SMTP id c7-20020a05640227c700b003d27f41f1d4so2431188ede.16
        for <kvm@vger.kernel.org>; Wed, 22 Sep 2021 03:02:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Qb8DRYmAxRXlFdlb2jYQeeG3H/2W6Rld2Q8cOt11XZU=;
        b=LWUw8ZVO0j5HYywNQrj0EFPBSCKqsZZjVa6tOr9XWEdqv30ObFv3mAGVjTZ96uY2EP
         cW112Emnm9vmQeW0Ybed95RhIMbi85tbYW4mxDqY6GRwasPHzzQkJb60hEIy23NAPMiR
         N1Ca1oDamxurfB7h2nFOxwbNS4sLF1YN8KQTHnZGSghGPctC8annC4mUMdv84mSCgtxx
         kGIUqNiIJMPjYoeXYjqmCXiEzwEM6LmdMAQvhMnDo2A+8dbv9i9XwsLZspIjbrSEPNbT
         hZWQVrafD/oA7kUcsN4Kpj8m6IExGckeOQTyH3AyafOFmAaUy6ruelKgTNh3J6pvlLDY
         CRrg==
X-Gm-Message-State: AOAM5304QjeVpt0hFlVDXqMt8TAj3qos7okneEDN0b9tQX18ruwKW/h4
        nIvQLkVWd58RUlR8as9Y0DsjZdstYnBPLj1BZdGpyTl/GjZX/MuMGUznnIO1z9ouwq8qUtyduux
        J8EtZv/UFsTNv
X-Received: by 2002:a17:906:3fc8:: with SMTP id k8mr38612737ejj.217.1632304965364;
        Wed, 22 Sep 2021 03:02:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwe4x5M0xdDGG3Nj4Oi9PRMN0+2vvrg4Ke/sie9bJ7lVbvExB41cX+IyRQZGFMk7dfx+QFMag==
X-Received: by 2002:a17:906:3fc8:: with SMTP id k8mr38612711ejj.217.1632304965092;
        Wed, 22 Sep 2021 03:02:45 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id lb20sm799141ejc.40.2021.09.22.03.02.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Sep 2021 03:02:44 -0700 (PDT)
Subject: Re: [PATCH] KVM: VMX: Check if bus lock vmexit was preempted
To:     Hao Xiang <hao.xiang@linux.alibaba.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, chenyi.qiang@intel.com,
        sean.j.christopherson@intel.com, shannon.zhao@linux.alibaba.com
References: <1631964600-73707-1-git-send-email-hao.xiang@linux.alibaba.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <87b411c3-da75-e074-91a4-a73891f9f5f8@redhat.com>
Date:   Wed, 22 Sep 2021 12:02:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <1631964600-73707-1-git-send-email-hao.xiang@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/09/21 13:30, Hao Xiang wrote:
> exit_reason.bus_lock_detected is not only set when bus lock VM exit
> was preempted, in fact, this bit is always set if bus locks are
> detected no matter what the exit_reason.basic is.
> 
> So the bus_lock_vmexit handling in vmx_handle_exit should be duplicated
> when exit_reason.basic is EXIT_REASON_BUS_LOCK(74). We can avoid it by
> checking if bus lock vmexit was preempted in vmx_handle_exit.

I don't understand, does this mean that bus_lock_detected=1 if 
basic=EXIT_REASON_BUS_LOCK?  If so, can we instead replace the contents 
of handle_bus_lock_vmexit with

	/* Do nothing and let vmx_handle_exit exit to userspace.  */
	WARN_ON(!to_vmx(vcpu)->exit_reason.bus_lock_detected);
	return 0;

?

That would be doable only if this is architectural behavior and not a 
processor erratum, of course.

Thanks,

Paolo

> Signed-off-by: Hao Xiang <hao.xiang@linux.alibaba.com>
> ---
>   arch/x86/kvm/vmx/vmx.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 0c2c0d5..5ddf1df 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6054,7 +6054,8 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
>   	 * still need to exit to user space when bus lock detected to inform
>   	 * that there is a bus lock in guest.
>   	 */
> -	if (to_vmx(vcpu)->exit_reason.bus_lock_detected) {
> +	if (to_vmx(vcpu)->exit_reason.bus_lock_detected &&
> +			to_vmx(vcpu)->exit_reason.basic != EXIT_REASON_BUS_LOCK) {
>   		if (ret > 0)
>   			vcpu->run->exit_reason = KVM_EXIT_X86_BUS_LOCK;
>   
> 

