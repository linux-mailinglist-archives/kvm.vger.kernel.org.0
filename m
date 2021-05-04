Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 935953731AE
	for <lists+kvm@lfdr.de>; Tue,  4 May 2021 22:56:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232580AbhEDU5a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 May 2021 16:57:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22341 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231715AbhEDU53 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 4 May 2021 16:57:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620161793;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GEOG2LrQF2aVluADfXxyAse1VlnB/ZrzEuAypGjwwE8=;
        b=OVXTaN/PFFreBJ77zsG5oxOEVAz1f7y21LHAXrdPfbiM1ZKXip33i3Y9P94Rat6j3J3Ni5
        givze/nlqbCm+PuGQTVC9ujP69Db0Z7xHlHvX8GO6J8RwAfGy7QfeV2/s1bqqExB6H6SzV
        ga9ldPqdOi3PTHO/bpkR4Al6RizL0I8=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-527-ijt8pss7Mh29m3FYbqliow-1; Tue, 04 May 2021 16:56:32 -0400
X-MC-Unique: ijt8pss7Mh29m3FYbqliow-1
Received: by mail-ed1-f70.google.com with SMTP id i2-20020a0564020542b02903875c5e7a00so6979993edx.6
        for <kvm@vger.kernel.org>; Tue, 04 May 2021 13:56:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GEOG2LrQF2aVluADfXxyAse1VlnB/ZrzEuAypGjwwE8=;
        b=RTFMVZHZnkxaB7KksGWqqW/npykv03mj9JJVIFGjc1nd3mdeBfAyp/dQLfyb+3V1JD
         GoAfGKGaHOL+mHPvcV9oC0M7csPHIwy7vVacDuyFeCP0CEON84scpqtm8cjzyxywFISX
         BjEh9sWj2l5IWhiWeAmKnXHHGH3T5OWNXuyRHiw31bCeHdDWm/2ZFoq92FlaAatcSLYE
         0U2/5AE/fq0B9SCQqItvwjM0frBilYJrQf3rA23kS5235+o5Zbk3iNt2U1BrU8SWUt5I
         kcRgHLgrc+MbYqq3XccZexsp0U6BEweuEYFVdoc/NjxqKMoYktGA22Z8NhpgiTl9E3MB
         8S1A==
X-Gm-Message-State: AOAM53217HgJFBIXYVzJ4U7aabsxCc7WOJFki9UibcqNgkad1gyRhXtO
        zQbIm/o6Ts4vvdxpEZWTwi+x0uPyLjgM4iLma2EzVlxD393M/VQw4HNtfriubu1IKtQnZkK//NF
        td+xYiUydBsAu
X-Received: by 2002:a50:9e0b:: with SMTP id z11mr28449861ede.228.1620161790882;
        Tue, 04 May 2021 13:56:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzN/MalCk4maG2dMLpXNujfcse6dFnpyiMkfWSbK4DZq5k8xkPvID7cUhfcn/20LwN1PReJIw==
X-Received: by 2002:a50:9e0b:: with SMTP id z11mr28449848ede.228.1620161790715;
        Tue, 04 May 2021 13:56:30 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id k5sm14839855edj.84.2021.05.04.13.56.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 May 2021 13:56:30 -0700 (PDT)
Subject: Re: [PATCH v3 2/2] KVM: X86: Introduce KVM_HC_PAGE_ENC_STATUS
 hypercall
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        srutherford@google.com, joro@8bytes.org, brijesh.singh@amd.com,
        thomas.lendacky@amd.com, ashish.kalra@amd.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@suse.de>,
        x86@kernel.org
References: <20210429104707.203055-1-pbonzini@redhat.com>
 <20210429104707.203055-3-pbonzini@redhat.com> <YIxkTZsblAzUzsf7@google.com>
 <c4bf8a05-ec0d-9723-bb64-444fe1f088b5@redhat.com>
 <YJF/3d+VBfJKqXV4@google.com>
 <f7300393-6527-005f-d824-eed5f7f2f8a8@redhat.com>
 <YJGvrYWLQwiRSNLt@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <55db8e64-763b-9ecc-9c9a-6d840628e763@redhat.com>
Date:   Tue, 4 May 2021 22:56:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <YJGvrYWLQwiRSNLt@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/05/21 22:33, Sean Christopherson wrote:
> On Tue, May 04, 2021, Paolo Bonzini wrote:
>> On 04/05/21 19:09, Sean Christopherson wrote:
>>> On Sat, May 01, 2021, Paolo Bonzini wrote:
>>>> - make it completely independent from migration, i.e. it's just a facet of
>>>> MSR_KVM_PAGE_ENC_STATUS saying whether the bitmap is up-to-date.  It would
>>>> use CPUID bit as the encryption status bitmap and have no code at all in KVM
>>>> (userspace needs to set up the filter and implement everything).
>>>
>>> If the bit is purely a "page encryption status is up-to-date", what about
>>> overloading KVM_HC_PAGE_ENC_STATUS to handle that status update as well?   That
>>> would eliminate my biggest complaint about having what is effectively a single
>>> paravirt feature split into two separate, but intertwined chunks of ABI.
>>
>> It's true that they are intertwined, but I dislike not having a way to read
>> the current state.
> 
>  From the guest?

Yes, host userspace obviously doesn't need one since it's implemented 
through an MSR filter.  It may not be really necessary to read it, but 
it's a bit jarring compared to how the rest of the PV APIs uses MSRs.

Also from a debugging/crashdump point of view the VMM may have an 
established way to read an MSR from a vCPU, but it won't work if you 
come up with a new way to set the state.

Paolo

