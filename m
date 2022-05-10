Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D027521D32
	for <lists+kvm@lfdr.de>; Tue, 10 May 2022 16:54:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241526AbiEJO54 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 May 2022 10:57:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345575AbiEJO4m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 May 2022 10:56:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7F572253A99
        for <kvm@vger.kernel.org>; Tue, 10 May 2022 07:18:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652192314;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QGYK88UZJWEVyRD6vfXo2WqFPdtVoF7sXPHaKmqNeAo=;
        b=JB3/9BCquv1KrUA75KfxUcmSdSkc3jIHwKKk026gWeINwr2t6VcEbg4dJUaiPsXomWszzn
        l/AIUXRioDDpPEp5hzaG30B3GiH2Bls3e5MLDD34fTypCjMqL7C6Y2EEIjkKlQ6oy/MqF7
        33eTaOTLIgVOZfSeObCqIe9adMWBJqI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-433-1FHsbXqgOVWc-IUIPob2nQ-1; Tue, 10 May 2022 10:18:33 -0400
X-MC-Unique: 1FHsbXqgOVWc-IUIPob2nQ-1
Received: by mail-wm1-f71.google.com with SMTP id c62-20020a1c3541000000b0038ec265155fso1369637wma.6
        for <kvm@vger.kernel.org>; Tue, 10 May 2022 07:18:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=QGYK88UZJWEVyRD6vfXo2WqFPdtVoF7sXPHaKmqNeAo=;
        b=QNkarRiTXtVuZw4WJ33qV4svNPoeIv+a1zz7vVs2RojLr7yEltrZiDADBlQYqofKJO
         3nfQJ8JI6Jl5ZDVOjKOAM5vNfIiOyAAxZSTTIm5NlepBZLz+Z+3yYClDLKgcpjAHT2go
         jTSYBq7Lvi4AKqbvrc1rJUsN2QC+gtdkW2Y8UlHC3asOD/7cK4GEtX3gxjI+Fkbp9akN
         SHEgGKDrJ97M5fqp72OTX1y7fB4a4Zng2b3F1EADjRw/Z+wvZ+wkWFpAGSItxtw8obnG
         IAhO/X9WXWL3II5D+uwof8EF9ivkQBQfFh+xO2LqJM0YPI/iULRhP0QRNhaA29NCx5dv
         FcLg==
X-Gm-Message-State: AOAM530EqXg3gG5PiUnIMXqk+ZaEKuQxy5sx3CeWnyBu6aYie6jllSD+
        UYSj/p0zcECXJ2Hux8mX/Kaua4OqYWnesMtiNQqOfRruwJp4hc3zxGOExEgHuvBGFWvRKcJcNdR
        HczlWD/lElTxR
X-Received: by 2002:a1c:19c1:0:b0:393:a19f:8f95 with SMTP id 184-20020a1c19c1000000b00393a19f8f95mr231824wmz.149.1652192312108;
        Tue, 10 May 2022 07:18:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzko/Pns2c5QC49wGZyq5NONIjEnLByjUJscWG/J/kkEjaVqsytoyWOTPsh3g7gNdNpRF39rw==
X-Received: by 2002:a1c:19c1:0:b0:393:a19f:8f95 with SMTP id 184-20020a1c19c1000000b00393a19f8f95mr231809wmz.149.1652192311855;
        Tue, 10 May 2022 07:18:31 -0700 (PDT)
Received: from ?IPV6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.googlemail.com with ESMTPSA id ba28-20020a0560001c1c00b0020c86a9f33bsm16161116wrb.18.2022.05.10.07.18.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 May 2022 07:18:31 -0700 (PDT)
Message-ID: <80ddc8a2-41c6-4e12-62f9-7acd51cabdb7@redhat.com>
Date:   Tue, 10 May 2022 16:18:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH] KVM: LAPIC: Narrow down the timer fastpath to tscdeadline
 timer
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <kernellwp@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <1651830457-11284-1-git-send-email-wanpengli@tencent.com>
 <YnpzetR/B3nXVJxu@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YnpzetR/B3nXVJxu@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/10/22 16:15, Sean Christopherson wrote:
>>   
>> -static fastpath_t handle_fastpath_preemption_timer(struct kvm_vcpu *vcpu)
>> +static bool __handle_preemption_timer(struct kvm_vcpu *vcpu)
>>   {
>>   	struct vcpu_vmx *vmx = to_vmx(vcpu);
>>   
>>   	if (!vmx->req_immediate_exit &&
>>   	    !unlikely(vmx->loaded_vmcs->hv_timer_soft_disabled)) {
>>   		kvm_lapic_expired_hv_timer(vcpu);
>> -		return EXIT_FASTPATH_REENTER_GUEST;
>> +		return true;
>>   	}
>>   
>> +	return false;
> It's a bit odd for the non-fastpath case, but I'd prefer to return fastpath_t
> instead of a bool from the inner helper, e.g.
> 

Yeah, enum > bool almost always (or negative errno).  But I also agree 
that using the fast path for periodic or oneshot timers is not 
inherently a bad idea.

Paolo

