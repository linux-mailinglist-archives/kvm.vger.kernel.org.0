Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5723B33919D
	for <lists+kvm@lfdr.de>; Fri, 12 Mar 2021 16:44:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230443AbhCLPna (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 10:43:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:49475 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231331AbhCLPn1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 12 Mar 2021 10:43:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615563807;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+wFAgdTMewsnYQw+ZERGa5q6Bhh7JRNwg5iyXn7hZdE=;
        b=ToOAa9A5e3F9M+6GsBI7QX64i+iDsmr6p1wqePKAxIOnCk1OqmXspmDehAoAc//CLLjwx6
        mcAhy21lM65PVdWDr0jnXDYgHtD/KiAWSvPEhO0vmk/u5x6prz5UU7kmBXWjAm6iZCcno8
        qr+9L4BNoSBC2KwuYwVcHfYal5VZLto=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-244-oyvAYJUbNqyYFQnKl1hrcg-1; Fri, 12 Mar 2021 10:43:23 -0500
X-MC-Unique: oyvAYJUbNqyYFQnKl1hrcg-1
Received: by mail-wr1-f71.google.com with SMTP id n17so11341288wrq.5
        for <kvm@vger.kernel.org>; Fri, 12 Mar 2021 07:43:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+wFAgdTMewsnYQw+ZERGa5q6Bhh7JRNwg5iyXn7hZdE=;
        b=oC0OQzRLNeO62gCwbjXGLPEFsEI0N70aFt96OQ0JvstQaVF2gPt5WJez5gtaLlaacg
         OifXYwZWql00kJkJPjGh+QXHVbk22o1qCcO17zwk7P7+ukPOt2ZzL/t8iWmaelsY0T0e
         y1P0rnyYFDAh/SVXAKAmCXX6KfweSRlbOxTwumBrLA8QTbJXA45D/2kEbEf5R9iAks4e
         NQnW0SZ1c+jwuPOPKkcDQuYUOdbemxysAG5MSOH5B0dwFCG4w4hF1JEtqs8G6jvOBTqx
         VSpBwQOSK2bZ23CzbAFN9qbEbrgCkuvU54ZLhGvTRIqdUjvZJHg73Lv/WaGMy9tyBF7x
         dbZg==
X-Gm-Message-State: AOAM533bfh+n23GCAiHPsf0cip4NUsg+B2po7yXJ1H34/AfZ9RngI4Yj
        Nh41GHOajrr/3IX2iOQCqE5xDANm0Ccgq7DRhVWLJGsqAfI69vKX9APxsjP2v7iraPT25OQJCNw
        tVgIhQZrYnOr8
X-Received: by 2002:adf:f411:: with SMTP id g17mr14347984wro.22.1615563802750;
        Fri, 12 Mar 2021 07:43:22 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyjGJU99dXivFeb9iRMuZRQB3sCBDdlFdIMJEYxj6+jLKpF48JR+OqaVPuMnodV6Ku2khpH7g==
X-Received: by 2002:adf:f411:: with SMTP id g17mr14347973wro.22.1615563802618;
        Fri, 12 Mar 2021 07:43:22 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id w6sm8501228wrl.49.2021.03.12.07.43.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Mar 2021 07:43:22 -0800 (PST)
Subject: Re: [PATCH 1/4] KVM: x86/mmu: Fix RCU usage in
 handle_removed_tdp_mmu_page
To:     Sean Christopherson <seanjc@google.com>,
        Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>
References: <20210311231658.1243953-1-bgardon@google.com>
 <20210311231658.1243953-2-bgardon@google.com> <YEuKx6ZveaT5RgAs@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <cc472f99-f9f0-8a63-c38b-31a650b4a39c@redhat.com>
Date:   Fri, 12 Mar 2021 16:43:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YEuKx6ZveaT5RgAs@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/03/21 16:37, Sean Christopherson wrote:
> On Thu, Mar 11, 2021, Ben Gardon wrote:
>> The pt passed into handle_removed_tdp_mmu_page does not need RCU
>> protection, as it is not at any risk of being freed by another thread at
>> that point. However, the implicit cast from tdp_sptep_t to u64 * dropped
>> the __rcu annotation without a proper rcu_derefrence. Fix this by
>> passing the pt as a tdp_ptep_t and then rcu_dereferencing it in
>> the function.
>>
>> Suggested-by: Sean Christopherson <seanjc@google.com>
>> Reported-by: kernel test robot <lkp@xxxxxxxxx>
> 
> Should be <lkp@intel.com>.  Looks like you've been taking pointers from Paolo :-)

The day someone starts confusing employers in CCs you should tell them 
"I see you have constructed a new email sending alias.  Your skills are 
now complete".

Paolo

> https://lkml.org/lkml/2019/6/17/1210
> 
> Other than that,
> 
> Reviewed-by: Sean Christopherson <seanjc@google.com>
> 
>> Signed-off-by: Ben Gardon <bgardon@google.com>
> 

