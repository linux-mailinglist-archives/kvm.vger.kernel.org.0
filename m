Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B848C6575A0
	for <lists+kvm@lfdr.de>; Wed, 28 Dec 2022 12:07:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232562AbiL1LG6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Dec 2022 06:06:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232954AbiL1LGK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Dec 2022 06:06:10 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75495137
        for <kvm@vger.kernel.org>; Wed, 28 Dec 2022 03:05:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672225520;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2lOLYUyc+DMwOURlYo5ZgfUD0hSGzq7ojQx2C123EIA=;
        b=VczNbA2uLWY1PsVA99JJW69js07CKwwshSkCoSNG+5M/+bcdDQosBeH04rwExygJSQRVVP
        WFB8AITGV4QqnnUDq+gNoIKg2RmmUxB4XAHi/whOq5JL67mnBXCYswg4dYC58LsFcNX+UN
        2Obe+sWdJCfiOLM64CwfJJuvAdT7Cds=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-664-GYM5WNVjO0Kg4ippkwvcUA-1; Wed, 28 Dec 2022 06:05:18 -0500
X-MC-Unique: GYM5WNVjO0Kg4ippkwvcUA-1
Received: by mail-ej1-f70.google.com with SMTP id qa18-20020a170907869200b007df87611618so10527335ejc.1
        for <kvm@vger.kernel.org>; Wed, 28 Dec 2022 03:05:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2lOLYUyc+DMwOURlYo5ZgfUD0hSGzq7ojQx2C123EIA=;
        b=0GgkDQehilMDupKSm25KIAECQ0Z73jIA4/Fb6kGk7ZAlt9Q9qDtTsnLVhf1BPx/4p3
         lxdpB0ejcxpc12eSzH4BvsyyQv1v6b0oyG4WmLSIoYVRDW/lXxrWoCJJiz9lBGy7FhtU
         VdfAmUDOe9rMf0/kjpHOdAxiLrVUsn59aXcE9YJ3EqDX82SxlddjmYHxQky+9Y00TyeN
         L8IAWHkoOnyE42NrFAGGRPLF0R/x02OC6RDUG6EP97WlUqSCndXBF6TdUKk9pbyXwwsi
         wDcoqm+95307ruDdIcNErOpJ17fFTLGJqEHIpfZYPxT1cKgNGC1ilf6YJnHgo0BsjOPa
         ZJSg==
X-Gm-Message-State: AFqh2ko1Vs3mlI8BGSA/kh/aN7qIjjQEaDw+7xGKjWqpyoDmArOs/mUg
        N6rEcZGl5byFRMEO6Inm7A5uM7pyVYQJRJf2tkYLHVpN8+xhquuiHWQtj35Qgz7uGkUj3IDMBG/
        GVQlv43iwKOdC
X-Received: by 2002:a17:907:c786:b0:7ad:a797:5bb9 with SMTP id tz6-20020a170907c78600b007ada7975bb9mr32450019ejc.29.1672225517852;
        Wed, 28 Dec 2022 03:05:17 -0800 (PST)
X-Google-Smtp-Source: AMrXdXv8wZSRfeT9Q/QbzLOYb1XTniWyKlwVPyyyLZkjkOFG5qaZo5rkyXj0YAX3hsngKagI7ezuZQ==
X-Received: by 2002:a17:907:c786:b0:7ad:a797:5bb9 with SMTP id tz6-20020a170907c78600b007ada7975bb9mr32450007ejc.29.1672225517631;
        Wed, 28 Dec 2022 03:05:17 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id x15-20020aa7dacf000000b004589da5e5cesm6991391eds.41.2022.12.28.03.05.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Dec 2022 03:05:16 -0800 (PST)
Message-ID: <81436cec-8c5f-4f90-3bc0-7da03570bbf3@redhat.com>
Date:   Wed, 28 Dec 2022 12:05:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH] KVM: x86: Remove the second definition of pr_fmt in
 hyperv.c
Content-Language: en-US
To:     Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org
Cc:     jmattson@google.com, seanjc@google.com
References: <20221227202636.680628-1-aaronlewis@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20221227202636.680628-1-aaronlewis@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/27/22 21:26, Aaron Lewis wrote:
> Both commit e21d10ee00c5 ("KVM: x86: Unify pr_fmt to use module name
> for all KVM modules") and commit 1567037614af ("KVM: VMX: Resurrect
> vmcs_conf sanitization for KVM-on-Hyper-V") define pr_fmt.
> 
> Remove the pr_fmt that was defined in commit 1567037614af ("KVM: VMX:
> Resurrect vmcs_conf sanitization for KVM-on-Hyper-V").
> 
> With both defined I get this:
> 
> arch/x86/kvm/vmx/hyperv.c:4:9: error: 'pr_fmt' macro redefined [-Werror,-Wmacro-redefined]
>          ^
> arch/x86/kvm/vmx/hyperv.c:2:9: note: previous definition is here

Hi Aaron,

since I am not really sure how much I am going to look at KVM during the 
vacations (and I assumed not many people would be looking at the 
results...), I pushed to kvm/queue without even doing a build test.

I am using these early merges to experiment with topic branches so, if 
applicable, I will rewind the merges and fix the semantic conflicts in 
the merges where they arise, either in the merges themselves or in the 
commits.

Paolo

