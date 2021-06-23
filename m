Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC1883B1A31
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 14:31:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230212AbhFWMdA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 08:33:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50281 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230163AbhFWMc7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Jun 2021 08:32:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624451441;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CNpTMCJ8h80BO/+0pCndBRwHmkrNlQnKpFd4gripH9E=;
        b=OfyCtexLB+xuQwWMrWH2TEsAElfGBALjH62CBwUb3bHS6REPLwiO+9uxf9Hk4jdjt+XRKV
        Azdlgxxb27L9s50WWnoKkzZ18ZsislWgcJGyEXBD6T/ZIvnx5zNgJboKiMU0vArz7ZH01L
        ggbcIgfEIJDCNVIMxxRRjbfsOFstCsE=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-137--N94VIjwOTGxGXgqHz-slg-1; Wed, 23 Jun 2021 08:30:40 -0400
X-MC-Unique: -N94VIjwOTGxGXgqHz-slg-1
Received: by mail-ed1-f71.google.com with SMTP id p19-20020aa7c4d30000b0290394bdda6d9cso1190688edr.21
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 05:30:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CNpTMCJ8h80BO/+0pCndBRwHmkrNlQnKpFd4gripH9E=;
        b=UevOqQAX2Zd0JhQNBtepDQ+inxvGgOABgc1AavYml7Fl1YzdBOw08+M+72J7pk/+7w
         5owlJjoj5SjA+brT88jy5qvQgqTiHdCnb0d2gdUrR0Ho0qGQ9PcR7GcqdE1BYV/B6nnH
         LQuY9tdC5Fu70dmHUhL9v3rXv2yGz5XGAsIV1RlZB/qEQddSfmPX+LTs06YdFN/ldI6b
         dwBukxTaJzo4EwUEKk3obLaWtbtdEQRZs3ndXADww/Y67okLO+K1aDY+DsdMcgR1tVdp
         BJ1MXq2wOgemmLevFg14B7d2YmilyLOSKXXq0+hi6xXf12aE0mkuRymZAnZk8yJXKJdp
         /vGg==
X-Gm-Message-State: AOAM5315um3eQKtVOlIGGPabZmEA1qs9TwnpB2OsAvWjJ00eIoES4Giv
        PXkOiFUI56bES26zkG2c5jZYriawoayx2Hymw09rcy0/JQ7OYGhvqpSmUPzXqo6bfgSBvAVqwPy
        /InFBsRUX4bqz
X-Received: by 2002:a50:8dc6:: with SMTP id s6mr12033902edh.50.1624451438886;
        Wed, 23 Jun 2021 05:30:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxmm7zTFDcKfnLZRxH+XZo5x35PRmTvnIDFPY8FLZghKb25e1jWxAFk5KRn57K4/Snxjtkn+Q==
X-Received: by 2002:a50:8dc6:: with SMTP id s6mr12033887edh.50.1624451438767;
        Wed, 23 Jun 2021 05:30:38 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id o14sm8403568edw.36.2021.06.23.05.30.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 05:30:38 -0700 (PDT)
Subject: Re: [PATCH] KVM: nVMX: Handle split-lock #AC exceptions that happen
 in L2
To:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210622172244.3561540-1-seanjc@google.com>
 <5196d26a-abb5-7ec9-70b1-69912a45ecd7@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e0acbfa6-0f46-1c75-7453-fa604548b3c5@redhat.com>
Date:   Wed, 23 Jun 2021 14:30:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <5196d26a-abb5-7ec9-70b1-69912a45ecd7@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/06/21 04:43, Xiaoyao Li wrote:
>>
>> +        else if (is_alignment_check(intr_info) &&
>> +             !vmx_guest_inject_ac(vcpu))
>> +            return true;
> 
> Why choose to check in nested_vmx_l0_wants_exit, not in 
> nested_vmx_l1_wants_exit()?

nested_vmx_l0_wants_exit() == true means "this is a vmexit that needs 
some transformation before being injected into L1".  Instead, 
nested_vmx_l1_wants_exit() == true means "this is an event that should 
either be processed directly by L0, or cause a vmexit in L1"

Typically, nested_vmx_l1_wants_exit() checks the controls in vmcs12, 
while nested_vmx_l0_wants_exit() returns true unconditionally for most 
vmexits; for others it checks processor state, or other state set up by 
userspace with ioctls such as vcpu->guest_debug.

In this case it's *L0* that wants that vmexit, in order to either 
disable split-lock detection or inject a SIGBUS, so 
nested_vmx_l0_wants_exit() is the right one to test.

Paolo

