Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAF5E40A910
	for <lists+kvm@lfdr.de>; Tue, 14 Sep 2021 10:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230460AbhINIV7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Sep 2021 04:21:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49141 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230303AbhINIV4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Sep 2021 04:21:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631607639;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OZrYl96UcrzJ4U/1lcwjzdKR3IPWpMITPCEIEQf+OBw=;
        b=PJB4Jz7mhpk1qsVH7H8TgEzm/TXIphRIQX3Z86h8SxjYSKiZVK905lteIWiHrXwWGWrHr7
        kWWvR0Q0+hIQaZzMT0AEUliVSik5wRNeW10gODnrnWmCRAE3D/YyZHa0brjwFEFYUSXbHj
        6ACWv3XOc9ytQuepzE82lLcKt+VJjM8=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-524-FSqoMLYfP8y89Fyiqyk6gA-1; Tue, 14 Sep 2021 04:20:37 -0400
X-MC-Unique: FSqoMLYfP8y89Fyiqyk6gA-1
Received: by mail-ed1-f71.google.com with SMTP id h15-20020aa7de0f000000b003d02f9592d6so5980902edv.17
        for <kvm@vger.kernel.org>; Tue, 14 Sep 2021 01:20:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OZrYl96UcrzJ4U/1lcwjzdKR3IPWpMITPCEIEQf+OBw=;
        b=Xu7MwmjX3pd9hXj7zup8vrqPHrWDQORIFoWkeQlzIMun7tbfdmm/IKGppAUiEO+G7j
         /WwQaqySF3fEnUfosb5VN+znq1LzUkeYrjr8XiXJgbxRp9iTxfLAlQk9oco/w42GzWVV
         O5upLVct0dUsWRYg06l2cUEQH6S8K3huuS2YHJFATwJUZAa3w0C7lDvikXd2ag46Ry6q
         8bkmRVtQzY/aUtlhHyxXaF077tGOwR6DaFLyjSaboCEoCAgTPPhsZpxzodrxg0knoSUN
         oKPQiizOWBe6pKnhLCJ6ZzanoV0YFKQzzOgA8IQG9wUYE2IwHiHN6ZNELY8CD58fkkQP
         DRyA==
X-Gm-Message-State: AOAM531G2ZDSV9wFzUQtmxXcQk3mkZOWz2YDc95QfcylYhmdIirG5nxq
        sqcboPCZYHvsO2uf1e/xQrZ4DagQ5QNBF/dhSFVEyTzGMLXx9wrGUeTYne6zuOX6nPP8AP1tb21
        nYSVaHtAy79sp
X-Received: by 2002:a17:906:3693:: with SMTP id a19mr17824384ejc.237.1631607635929;
        Tue, 14 Sep 2021 01:20:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz5i665AMySfybFMK4WWmW9FuL6POLqqgnKYXsAFXFztRVO+7qVj5BAth9qVjtGIXqSoMuBqA==
X-Received: by 2002:a17:906:3693:: with SMTP id a19mr17824378ejc.237.1631607635793;
        Tue, 14 Sep 2021 01:20:35 -0700 (PDT)
Received: from localhost.localdomain ([2a04:ee41:4:31cb:e591:1e1e:abde:a8f1])
        by smtp.gmail.com with ESMTPSA id h10sm4540598ede.28.2021.09.14.01.20.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Sep 2021 01:20:33 -0700 (PDT)
Subject: Re: [RFC PATCH 3/3] nSVM: use svm->nested.save to load vmcb12
 registers and avoid TOC/TOU races
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
References: <20210903102039.55422-1-eesposit@redhat.com>
 <20210903102039.55422-4-eesposit@redhat.com>
 <21d2bf8c4e3eb3fc5d297fd13300557ec686b625.camel@redhat.com>
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
Message-ID: <73b5a5bb-48f2-3a08-c76b-a82b5b69c406@redhat.com>
Date:   Tue, 14 Sep 2021 10:20:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <21d2bf8c4e3eb3fc5d297fd13300557ec686b625.camel@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/09/2021 12:42, Maxim Levitsky wrote:
>>   
>> -	if (!nested_vmcb_valid_sregs(vcpu, &vmcb12->save) ||
>> +	if (!nested_vmcb_valid_sregs(vcpu, &svm->nested.save) ||
>>   	    !nested_vmcb_check_controls(vcpu, &svm->nested.ctl)) {

> If you use a different struct for the copied fields, then it makes
> sense IMHO to drop the 'control' parameter from nested_vmcb_check_controls,
> and just use the svm->nested.save there directly.
> 

Ok, what you say in patch 2 makes sense to me. I can create a new struct 
vmcb_save_area_cached, but I need to keep nested.ctl because 1) it is 
used also elsewhere, and different fields from the one checked here are 
read/set and 2) using another structure (or the same 
vmcb_save_area_cached) in its place would just duplicate the same fields 
of nested.ctl, creating even more confusion and possible inconsistency.

Let me know if you disagree.

Thank you,
Emanuele

