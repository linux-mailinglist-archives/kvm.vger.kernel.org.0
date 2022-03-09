Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBB8E4D36E2
	for <lists+kvm@lfdr.de>; Wed,  9 Mar 2022 18:44:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236320AbiCIQrW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Mar 2022 11:47:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235964AbiCIQpq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Mar 2022 11:45:46 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2164EE33A9
        for <kvm@vger.kernel.org>; Wed,  9 Mar 2022 08:40:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646844000;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IAc/oOoGUadcAFsmIKAJnthrZQUYi2PSEkJ4X4JgBng=;
        b=ZZHCb23CyzOmGIpafshRksGV5uULcNPkWleHypBPREKyv4gjPNEAJY+qtj2jw9ZQ2HhL1e
        G3oRowq1k5ef85Ih6u6VJqLQ6HMmCbOqxvv99BK9tD+Xb3JGXj7sO2LDR/ay1AMGNNBglc
        uSdx5ebZDltmHUPtVF1wgdIVUd25g9Y=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-247-C_x6w1KPMEOhuVMCvGk-xw-1; Wed, 09 Mar 2022 11:39:59 -0500
X-MC-Unique: C_x6w1KPMEOhuVMCvGk-xw-1
Received: by mail-wm1-f72.google.com with SMTP id m34-20020a05600c3b2200b0038115c73361so1010873wms.5
        for <kvm@vger.kernel.org>; Wed, 09 Mar 2022 08:39:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=IAc/oOoGUadcAFsmIKAJnthrZQUYi2PSEkJ4X4JgBng=;
        b=M1KuBDRwXAoDsXja2JffC8VIXDWvR+k9g/Uk6kNUYAhIVQ6lrgoPHrb6lyM9sceZVG
         Aexk84vfUnrV2Q1cZJjtwJZWsz4eP40ivZq1csuqMO1YF8DckTkrF7alCZ3FH7nTJRrk
         GWaE1UzJPfO6Z5J98H9kC1pMgmOJoP4rM2oU6Ehe7SPVkgk7A6ToplRtJ01Be3WO2z1I
         1C8/ZyACvMPTJjVOHxOSxdAcOjQ6npmixEyENyN4XxWCF53BFu/Cvq0laXuDZqxzgScr
         8M3j6vDo6m/akckGHovnhsVozEvhTg3+kbd/zMawuRmGs6h4Y56fDXtDUQOKC5P4esld
         Kqig==
X-Gm-Message-State: AOAM530PAlMTGyvd9Nq8tfPdW2zJri8O9427nFt0GkFWOs1nYaCQ7n0r
        +FdY9UlCz8iMM2fVC+GepFuhBd6EkdycX/YLcQ67vEV5rowVW+IWMzKp4R6+9TJI/K4w3A9fucU
        QUTeUjU0PDpEk
X-Received: by 2002:a05:600c:4fd5:b0:389:d26a:3fb6 with SMTP id o21-20020a05600c4fd500b00389d26a3fb6mr180102wmq.152.1646843998012;
        Wed, 09 Mar 2022 08:39:58 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxWj3WnIzUxoFDzNWUxoyAiz0YdXqRpDHfNFCgKsTGg3uluzuijVXvNDTKsj9H4rwAGUFbvFw==
X-Received: by 2002:a05:600c:4fd5:b0:389:d26a:3fb6 with SMTP id o21-20020a05600c4fd500b00389d26a3fb6mr180085wmq.152.1646843997718;
        Wed, 09 Mar 2022 08:39:57 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id bj7-20020a0560001e0700b001f1d7822865sm1978946wrb.43.2022.03.09.08.39.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 08:39:56 -0800 (PST)
Message-ID: <d1bbb6cd-2fb1-6d12-e661-c369d5e587dc@redhat.com>
Date:   Wed, 9 Mar 2022 17:39:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 1/2] KVM: x86/xen: PV oneshot timer fixes
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Metin Kaya <metikaya@amazon.co.uk>,
        Paul Durrant <pdurrant@amazon.co.uk>
References: <20220309143835.253911-1-dwmw2@infradead.org>
 <20220309143835.253911-2-dwmw2@infradead.org>
 <846caa99-2e42-4443-1070-84e49d2f11d2@redhat.com>
 <4f1b299dd989640b5c9e8f23a9b90de357581b62.camel@infradead.org>
 <baa1d8da-fd9d-39f4-269e-4af50936e042@redhat.com>
 <50356625296df21e07c42f5ddd190bcdc79cc530.camel@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <50356625296df21e07c42f5ddd190bcdc79cc530.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/9/22 17:37, David Woodhouse wrote:
> The dirty tracking part is already there:
> 
>    Note that the shared info page may be constantly written to by KVM;
>    it contains the event channel bitmap used to deliver interrupts to
>    a Xen guest, amongst other things. It is exempt from dirty tracking
>    mechanisms — KVM will not explicitly mark the page as dirty each
>    time an event channel interrupt is delivered to the guest! Thus,
>    userspace should always assume that the designated GFN is dirty if
>    any vCPU has been running or any event channel interrupts can be
>    routed to the guest.
> 
> And for vcpu_info:
> 
> KVM_XEN_VCPU_ATTR_TYPE_VCPU_INFO
>    Sets the guest physical address of the vcpu_info for a given vCPU.
>    As with the shared_info page for the VM, the corresponding page may be
>    dirtied at any time if event channel interrupt delivery is enabled, so
>    userspace should always assume that the page is dirty without relying
>    on dirty logging.
> 
> 
> For the ordering of the various vCPU state fetches... is there any
> existing documentation on that? An emacs buffer just to the right of
> this compose window contains the only notes on that topic that I've
> ever seen (much of which may well be out of date by now)...

Ok, guilty as charged.

Paolo

> 	/*
> 	 * Notes on ordering requirements (and other ramblings).
> 	 *
> 	 * KVM_GET_MP_STATE calls kvm_apic_accept_events(), which might modify
> 	 * vCPU/LAPIC state. As such, it must be done before most everything
> 	 * else, otherwise we cannot restore everything and expect it to work.
> 	 *
> 	 * KVM_GET_VCPU_EVENTS/KVM_SET_VCPU_EVENTS is unsafe if other vCPUs are
> 	 * still running.
> 	 *
> 	 * Some SET ioctls depend on kvm_vcpu_is_bsp(), so if we ever change
> 	 * the BSP, we have to do that before restoring anything. The same
> 	 * seems to be true for CPUID stuff.
> 	 *
> 	 * KVM_GET_LAPIC may change state of LAPIC before returning it.
> 	 *
> 	 * GET_VCPU_EVENTS should probably be last to save. The code looks as
> 	 * it might as well be affected by internal state modifications of the
> 	 * GET ioctls.
> 	 *
> 	 * SREGS saves/restores a pending interrupt, similar to what
> 	 * VCPU_EVENTS also does.
> 	 *
> 	 * SET_REGS clears pending exceptions unconditionally, thus, it must be
> 	 * done before SET_VCPU_EVENTS, which restores it.
> 	 *
> 	 * SET_LAPIC must come after SET_SREGS, because the latter restores
> 	 * the apic base msr.
> 	 *
> 	 * SET_LAPIC must come before SET_MSRS, because the TSC deadline MSR
> 	 * only restores successfully, when the LAPIC is correctly configured.
> 	 *
> 	 * GET_MSRS requires a pre-populated data structure to do something
> 	 * meaningful. For SET_MSRS it will then contain good data.
> 	 *
> 	 * The KVM API documentation is wrong for GET_MSRS/SET_MSRS. They
> 	 * return the number of successfully read/written values, which is
> 	 * actually helpful to determine where things went wrong.
> 	 */
> 
> 
> If there's existing documentation on the ordering, I'd be happy to add
> to it. If not, then my comment earlier about timers causing an
> interrupt to be injected to the local APIC is far*more*  obvious than
> most of the rest...:)

