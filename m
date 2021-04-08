Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9637035896C
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 18:14:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232132AbhDHQOp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 12:14:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27507 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231655AbhDHQOo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 8 Apr 2021 12:14:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617898472;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=elXf7VW8mYYZHy/sU8ktzpg8oQGZMdhCA5JdOrUTKYM=;
        b=ePTPm4NNNU74eXhhNNKetskDbjbKbiB2kgTTII/Ehhs5fDye1kC0qcsWC5ebLGNxZW+KOR
        /peHU9FKntJY3jc/BsFJWwCer/5FLLUPF0wdGMXGR0Fy9xS4RJ8pkj6MuZHdg69s4gZYeZ
        yPFW8dsoIzZlgJJcIAQ/YQV0j4OiNrk=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-507-WR2qH555MDecYLeqgFSrzA-1; Thu, 08 Apr 2021 12:14:31 -0400
X-MC-Unique: WR2qH555MDecYLeqgFSrzA-1
Received: by mail-ed1-f71.google.com with SMTP id b8so1275128ede.5
        for <kvm@vger.kernel.org>; Thu, 08 Apr 2021 09:14:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=elXf7VW8mYYZHy/sU8ktzpg8oQGZMdhCA5JdOrUTKYM=;
        b=BdM2KsRP6bPHJQsHj/47+jY/EtuuIoPkpk2vlFg0hL8lkdqH9rf2isk+beaCeFr1Dr
         bnEa2J05VBsJNTeFcgRT4yHzbW5ROmGo+e/Vtv2I+ytpfyp675pk82NXyEuG81+IAY0F
         lIQIjP6DWdH/5C2tIsAIPbZAyFOLqEOD0jkJ/T60VOaTZHk8pUWDvuIMFJ84EdRXXhzh
         dIzS0nR305ZS5Px3ULCQ+2VI2MF89dIaXpwhnVh9roYzJey+ZsX9pcDoxakfAZm4qqz7
         SnOpx48T1VGlRgGjXozvLXbWSIxcXI5BS4fDjKSknheirU7M1MxoMs4TGKzAMtWrOX1g
         0awQ==
X-Gm-Message-State: AOAM532EaIpTXdWhPMZOR8uz4ZrgOvlth5jU3K4CkY+Kotl8GHJUSWuz
        4oMW/2zTUl7riXYnLx0QGtRu/QV32ql3JhmveuYTRGrVHtom9xJjRVJo+D2CHeOrqE4b+HS4LrB
        vajnx2yvXKi4d
X-Received: by 2002:a17:906:1453:: with SMTP id q19mr11664861ejc.76.1617898469483;
        Thu, 08 Apr 2021 09:14:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy2caDACYbDyFw8mNJVcybeWHcKDxGKJYs94P6XujvmFPa5vkdq9RAsvPNL5dt8BX/ewU7oYw==
X-Received: by 2002:a17:906:1453:: with SMTP id q19mr11664838ejc.76.1617898469318;
        Thu, 08 Apr 2021 09:14:29 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id bq18sm10535789ejb.27.2021.04.08.09.14.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Apr 2021 09:14:28 -0700 (PDT)
Subject: Re: [PATCH] KVM: SVM: Make sure GHCB is mapped before updating
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <03b349cb19b360d4c2bbeebdd171f99298082d28.1617820214.git.thomas.lendacky@amd.com>
 <YG4RSl88TSPccRfj@google.com> <d46ee7c3-6c8c-1f06-605c-c4f2d1888ba4@amd.com>
 <YG4fAeaTy0HdHCsT@google.com> <b1a6dddd-9485-c6f6-8af9-79f6e3505206@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2b282772-afaa-2fd4-0794-4449eda6fd02@redhat.com>
Date:   Thu, 8 Apr 2021 18:14:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <b1a6dddd-9485-c6f6-8af9-79f6e3505206@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/04/21 18:04, Tom Lendacky wrote:
>>>> +       if (!err || !sev_es_guest(vcpu->kvm) || !WARN_ON_ONCE(svm->ghcb))
>>> This should be WARN_ON_ONCE(!svm->ghcb), otherwise you'll get the right
>>> result, but get a stack trace immediately.
>> Doh, yep.
> Actually, because of the "or's", this needs to be:
> 
> if (!err || !sev_es_guest(vcpu->kvm) || (sev_es_guest(vcpu->kvm) && WARN_ON_ONCE(!svm->ghcb)))

No, || cuts the right-hand side if the left-hand side is true.  So:

- if err == 0, the rest is not evaluated

- if !sev_es_guest(vcpu->kvm), WARN_ON_ONCE(!svm->ghcb) is not evaluated

Paolo

