Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 390BC3F461D
	for <lists+kvm@lfdr.de>; Mon, 23 Aug 2021 09:54:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235434AbhHWHzE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Aug 2021 03:55:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23666 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235252AbhHWHzD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 23 Aug 2021 03:55:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629705261;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LNQHzhBU61w8aySVKkAPo9NSfHYRJWrZd0ke9vwfjJk=;
        b=ElEXmOCgua7ofb/Z5PlVt0TfFfzkunHRx48CfI7+B2gFgRvaXAcXkidOdNRCRTrVZopEos
        pUzelNBOX8TjA1q8QhexYOgQXE6Kw8asyrJzyx6yZdLo3JYI2YNT0/U7llGt4Wb6zFYmdh
        X2F5URR5Nc8BmFsWYJRP01GPWOUHttc=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-552-a4CyQpQLOyOvo1ZZJbParA-1; Mon, 23 Aug 2021 03:54:19 -0400
X-MC-Unique: a4CyQpQLOyOvo1ZZJbParA-1
Received: by mail-wr1-f72.google.com with SMTP id b8-20020a5d5508000000b001574e8e9237so918073wrv.16
        for <kvm@vger.kernel.org>; Mon, 23 Aug 2021 00:54:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=LNQHzhBU61w8aySVKkAPo9NSfHYRJWrZd0ke9vwfjJk=;
        b=AwNR6rt4JXCDsTU1RJo1trWT6eMxAS5j2Knef7CKBs6RAaOcGQlaYTYkNp6d9QLMcv
         KoUPkU5DiabWDceFVT1exOEXvmD3vfw8+ftAVBeRtU16om77Pl4L5J4Hod8WhMxNhoO9
         PwvUtiBepKECp+P+jUWcSq0a0SHa3+Ml9mXN1g6C6kMziszqme3621gm1TaCkwkWYrfC
         ZDgBwoK3Js51hAvIGDSreAbAKonHGweSgObNSd6eLRogkqNlEv+OFttkWS5gfjS+2M8J
         dy+QDR2h6JgZolRR4cqkCGzTKDlQ8wby/bsSMT7rjnp7xbu399o24gKtL3isoe5zpjPB
         7F8Q==
X-Gm-Message-State: AOAM530Jws5xNM7wdiHtnGLl8j6413keE/JKYp8GRU0FVVxQzabsPlGe
        d7tHkVfQ9OaYDlWxuCzMPddq48GctmivwE25UIwtDLPsiqCHxGMxdAcpFG3e3UOov3FG5JMu/dL
        kYrNopoBILoM1
X-Received: by 2002:a7b:cf05:: with SMTP id l5mr14936190wmg.138.1629705258656;
        Mon, 23 Aug 2021 00:54:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzND033zGe/eugLPehvBvzHmQ600rjQM2jZoXTXeTOGRVMQhD5X4o8/yaxNE5yMWDNWZwjh7w==
X-Received: by 2002:a7b:cf05:: with SMTP id l5mr14936177wmg.138.1629705258455;
        Mon, 23 Aug 2021 00:54:18 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id s16sm7245700wrw.44.2021.08.23.00.54.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Aug 2021 00:54:17 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Venkatesh Srinivas <venkateshs@google.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH 2/2] KVM: Guard cpusmask NULL check with
 CONFIG_CPUMASK_OFFSTACK
In-Reply-To: <20210821000501.375978-3-seanjc@google.com>
References: <20210821000501.375978-1-seanjc@google.com>
 <20210821000501.375978-3-seanjc@google.com>
Date:   Mon, 23 Aug 2021 09:54:16 +0200
Message-ID: <871r6klhp3.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> Check for a NULL cpumask_var_t when kicking multiple vCPUs if and only if
> cpumasks are configured to be allocated off-stack.  This is a meaningless
> optimization, e.g. avoids a TEST+Jcc and TEST+CMOV on x86, but more
> importantly helps document that the NULL check is necessary even though
> all callers pass in a local variable.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  virt/kvm/kvm_main.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
>
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 786b914db98f..82c5280dd5ce 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -247,7 +247,7 @@ static void ack_flush(void *_completed)
>  
>  static inline bool kvm_kick_many_cpus(const struct cpumask *cpus, bool wait)
>  {
> -	if (unlikely(!cpus))
> +	if (IS_ENABLED(CONFIG_CPUMASK_OFFSTACK) && unlikely(!cpus))
>  		cpus = cpu_online_mask;
>  
>  	if (cpumask_empty(cpus))
> @@ -277,6 +277,14 @@ bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req,
>  		if (!(req & KVM_REQUEST_NO_WAKEUP) && kvm_vcpu_wake_up(vcpu))
>  			continue;
>  
> +		/*
> +		 * tmp can be NULL if cpumasks are allocated off stack, as
> +		 * allocation of the mask is deliberately not fatal and is
> +		 * handled by falling back to kicking all online CPUs.
> +		 */
> +		if (IS_ENABLED(CONFIG_CPUMASK_OFFSTACK) && !tmp)
> +			continue;
> +
>  		/*
>  		 * Note, the vCPU could get migrated to a different pCPU at any
>  		 * point after kvm_request_needs_ipi(), which could result in
> @@ -288,7 +296,7 @@ bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req,
>  		 * were reading SPTEs _before_ any changes were finalized.  See
>  		 * kvm_vcpu_kick() for more details on handling requests.
>  		 */
> -		if (tmp != NULL && kvm_request_needs_ipi(vcpu, req)) {
> +		if (kvm_request_needs_ipi(vcpu, req)) {
>  			cpu = READ_ONCE(vcpu->cpu);
>  			if (cpu != -1 && cpu != me)
>  				__cpumask_set_cpu(cpu, tmp);

In case MM people don't like us poking into CONFIG_CPUMASK_OFFSTACK
details we can probably get away with a comment. Otherwise

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

