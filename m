Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 086E33B3FEE
	for <lists+kvm@lfdr.de>; Fri, 25 Jun 2021 11:05:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230449AbhFYJH2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Jun 2021 05:07:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58080 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229839AbhFYJHZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Jun 2021 05:07:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624611905;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3Vf7eQafJpn+Km6dnUrld2h7erdnsGXaWtmQA8sYWrM=;
        b=SBX0uACWf3C6b4SAISY2Mgz6snDj7ua9rw3CqpRLu9Znep7Vq+ciApAOC6dVvgA5FQ3VUo
        c5XMFGgjpRZEMikObEvrJLxEJH04W/4sygFBW9DWjEsGN3R/BHxCjSy7ReYft6sg2iJdhZ
        0XlG+cdENOL57eF5U4Y3W1lGSaxtU84=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-284-jfFwOt-YNDOQC4cZPvnNmw-1; Fri, 25 Jun 2021 05:05:02 -0400
X-MC-Unique: jfFwOt-YNDOQC4cZPvnNmw-1
Received: by mail-ej1-f71.google.com with SMTP id g6-20020a1709064e46b02903f57f85ac45so2868525ejw.15
        for <kvm@vger.kernel.org>; Fri, 25 Jun 2021 02:05:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3Vf7eQafJpn+Km6dnUrld2h7erdnsGXaWtmQA8sYWrM=;
        b=PAWbgpFWjWiMNJmDP2OaCuk2lbGgHoG/YvNHtQMETywF4VzClKWrgNR/m6JKnMDJQW
         7jdTxTs0QWv+prmoJqCrV166sltlhodZau6Ncl5K7Lsv5AdIefpxLsdM5iGsA0IZQfFC
         iduyBFzBCZJW3Dat9zeiacmlICkiVXT3cF1XcwKPaRtSeUAdzHESBm2Ud6R+Rpg+pzVx
         xBzMNRIX9UljsZTlmAzN+ktVOcC3Udrq3m/AkPiohvoK5M151kcWeKZljtGp1Fe4Ng06
         rl4O5PoNOprywCbMfj3C3aGAJw4b6Jp2Aagmw8OFR6kthzKy9/e3l6xHAYaxl54dOt5/
         hDxA==
X-Gm-Message-State: AOAM533WueT8RcJhLRrY903UCA74Ur81dAbL4ad1sIWsMQVji/6G5Gd6
        KM4ApYVogizqeq8xL1FG/5aESdhhoAqG9o8sl+7iNOywcWcd8TDI4Ojg539jXTd/KksU/y9odEV
        MPXlBI5Y47t0r
X-Received: by 2002:a17:906:b215:: with SMTP id p21mr10141807ejz.237.1624611901530;
        Fri, 25 Jun 2021 02:05:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzfEt+Mcicq18UzSdQy2+ca/CS9XiyaFqrwUOm+ZVOjBEnrIF6U+hhzb0ccOUQ+FYXzVWitZQ==
X-Received: by 2002:a17:906:b215:: with SMTP id p21mr10141785ejz.237.1624611901306;
        Fri, 25 Jun 2021 02:05:01 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id jl21sm2423410ejc.42.2021.06.25.02.05.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Jun 2021 02:05:00 -0700 (PDT)
Subject: Re: [PATCH 3/4] KVM: x86: WARN and reject loading KVM if NX is
 supported but not enabled
To:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210615164535.2146172-1-seanjc@google.com>
 <20210615164535.2146172-4-seanjc@google.com> <YNUITW5fsaQe4JSo@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ad85c5db-c780-bd13-c6ce-e3478838acbe@redhat.com>
Date:   Fri, 25 Jun 2021 11:04:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YNUITW5fsaQe4JSo@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/06/21 00:33, Sean Christopherson wrote:
> On Tue, Jun 15, 2021, Sean Christopherson wrote:
>> WARN if NX is reported as supported but not enabled in EFER.  All flavors
>> of the kernel, including non-PAE 32-bit kernels, set EFER.NX=1 if NX is
>> supported, even if NX usage is disable via kernel command line.
> 
> Ugh, I misread .Ldefault_entry in head_32.S, it skips over the entire EFER code
> if PAE=0.  Apparently I didn't test this with non-PAE paging and EPT?
> 
> Paolo, I'll send a revert since it's in kvm/next, but even better would be if
> you can drop the patch :-)  Lucky for me you didn't pick up patch 4/4 that
> depends on this...
> 
> I'll revisit this mess in a few weeks.

Rather, let's keep this, see if anyone complains and possibly add a 
"depends on X86_PAE || X86_64" to KVM.

Paolo

