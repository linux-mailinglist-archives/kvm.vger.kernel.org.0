Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65E414D1D0D
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 17:21:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348310AbiCHQWP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 11:22:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348293AbiCHQWN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 11:22:13 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 47AAF5FCE
        for <kvm@vger.kernel.org>; Tue,  8 Mar 2022 08:21:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646756475;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CBvsK7yZkBxfmY+8RqkH2up0UVblpUA0JK9TMDfqBZE=;
        b=A5nTX7XmAqIJzCNxoHJu8BFTyxvjbBn90IBw3L3SA0E/dCYXeil6tvg7+iZ6DmSDt+q+Xw
        Zv5YxjcW2lnZ9h4nfPg3SkOLtwcyVdpgRWyTkYpSGViivUO4FG3gQfdQ2dBHXsUS+vQ1jo
        XJt2Bj8hdk8uPjoJY3Ux0AQQ0F2nBCc=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-302-DGIiHJoUMxCpxLSvMJvpVg-1; Tue, 08 Mar 2022 11:21:13 -0500
X-MC-Unique: DGIiHJoUMxCpxLSvMJvpVg-1
Received: by mail-ed1-f69.google.com with SMTP id r8-20020aa7d588000000b00416438ed9a2so4434545edq.11
        for <kvm@vger.kernel.org>; Tue, 08 Mar 2022 08:21:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=CBvsK7yZkBxfmY+8RqkH2up0UVblpUA0JK9TMDfqBZE=;
        b=Hx9ef14JauW8bLpSlfYSJ8ouuVpofTpj3BIj+bNBnVSQDy+H027zhR7Icr4vqLD50/
         JgHi5KPwr6QMWibDUqzA+xrbalJuuXAHMX+d0OSSd3kX5zJm2KhbKV6V3/v6TtgUxlkK
         8yfD+MWxbSLJyBM4TVVaCrJVU2Hjkx0tydW/c6temwpSUqkqCJu0yj9qZTHPqmPKZwB5
         8b757o8zX9lLqlcgZPg4yXoOSUmCd2WhBb7iFRbhMheEZAl+TJuAZAWAaMaeVQC3R/WO
         xCyiAtD04MPmzn6YBsKhdcoEuaWWF9cm/sSA9l31xWTfZyDW9+73MBi86XTCXKZLAGty
         cLXw==
X-Gm-Message-State: AOAM533vHV5vlJwlujbuhUk/by2g4DAJXtOoyGOLdBRIgaq27ENJnQDK
        1yTUL8wygFib18LA9O885aEHZSWvzc1BrIceb7ec7iryGz6UWebSFs9iLkGu2nJtF9E5o7xuWG1
        KlddZHIHqMSnq
X-Received: by 2002:a17:906:7d83:b0:6ce:fee:9256 with SMTP id v3-20020a1709067d8300b006ce0fee9256mr14590787ejo.647.1646756471794;
        Tue, 08 Mar 2022 08:21:11 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzxQu7IYyETha9E2LZivWjB76N0egbFW8CxeJzmf5k7Cicjr6tmzT1LuArWcSRv8IfHIN9HAA==
X-Received: by 2002:a17:906:7d83:b0:6ce:fee:9256 with SMTP id v3-20020a1709067d8300b006ce0fee9256mr14590769ejo.647.1646756471507;
        Tue, 08 Mar 2022 08:21:11 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id s8-20020a170906354800b006da9dec91f2sm5746016eja.163.2022.03.08.08.21.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Mar 2022 08:21:10 -0800 (PST)
Message-ID: <2652c27e-ce8c-eb40-1979-9fe732aa9085@redhat.com>
Date:   Tue, 8 Mar 2022 17:21:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2 01/25] KVM: x86/mmu: avoid indirect call for get_cr3
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        dmatlack@google.com
References: <20220221162243.683208-1-pbonzini@redhat.com>
 <20220221162243.683208-2-pbonzini@redhat.com> <YieBXzkOkB9SZpyp@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YieBXzkOkB9SZpyp@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/8/22 17:16, Sean Christopherson wrote:
> 
>> +static inline unsigned long kvm_mmu_get_guest_pgd(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
> Wrap the params, no reason to make this line so long.
> 
>> +{
>> +#ifdef CONFIG_RETPOLINE
>> +	if (mmu->get_guest_pgd == kvm_get_guest_cr3)
>> +		return kvm_read_cr3(vcpu);
> This is unnecessarily fragile and confusing at first glance.  Compilers are smart
> enough to generate a non-inline version of functions if they're used for function
> pointers, while still inlining where appropriate.  In other words, just drop
> kvm_get_guest_cr3() entirely, a al get_pdptr => kvm_pdptr_read().

Unfortunately this isn't entirely true.  The function pointer will not 
match between compilation units, in this case between the one that calls 
kvm_mmu_get_guest_pgd and the one that assigned kvm_read_cr3 to the 
function pointer.

Paolo

