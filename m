Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6B6933F6A6
	for <lists+kvm@lfdr.de>; Wed, 17 Mar 2021 18:22:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbhCQRWZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Mar 2021 13:22:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49877 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232151AbhCQRWR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Mar 2021 13:22:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616001736;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UQ3e5CiL3zDWKnU78btJdTG8eWtPDoYbv2Xyt4NhHDk=;
        b=JT0JoJsrvyQ0ASdvC15R713beOYcveJpDZ0TZHE8cztAKSbKKtfqirN+RJpDuBmYFebn78
        Szy6L1ro8ugIDYlNymMkxkAiO8mIe47rMlY4Kf5kJlAKXxjm8HxP0ntnbhV2C3l242Bkzh
        oWBFq2i95nRM9B7BbcNyeFajGO+a/a0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-297-qa9pnro7MyqLR5puNh98vw-1; Wed, 17 Mar 2021 13:22:15 -0400
X-MC-Unique: qa9pnro7MyqLR5puNh98vw-1
Received: by mail-wm1-f71.google.com with SMTP id n2so11015822wmi.2
        for <kvm@vger.kernel.org>; Wed, 17 Mar 2021 10:22:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UQ3e5CiL3zDWKnU78btJdTG8eWtPDoYbv2Xyt4NhHDk=;
        b=sZvTwbRB6iyKMtVd4YbEWuZFeFcVdHjplfgH5ufiPV/zxu9RjNVNM8N3pcDSzO4Axy
         8rcWl7ikxHR8y+QEzNF/8W6XKJ8HB+Bsl+RD6wnEPw96lFGEQPCH5ygyzL5PK5TWJzYw
         X+/LTol84fMurRiNOCu0f16XGxlAf6c2Bi6iTGcYAEMtdO82Ae03urlW60sAGVVvt62q
         SDxvs8Mq/0P/hEnTd0AhwUAS/fK3XOjUOh/MF4bveWMctrsmsTCqnHyoMzy3HyJjaax5
         G/enHMf5p+sikFqB58Yi5SYajetj1oQf+kVK+YfULd8LasGhXKTd53ZlrTevQqBUSHND
         pUhA==
X-Gm-Message-State: AOAM533dCEigvtioJGpR7byz66frCo/jBZTXUVhr/Y+i9cpe+KYEsTLa
        oWzMVA9hyg1T3CFJvc6ZkDXV5rB7DqPHE5SgGQ2NrqXw27B+vHl0lgYU7GaWXphfrn75nFALQuw
        E4VJ+oyCgR9Pd
X-Received: by 2002:a05:6000:1107:: with SMTP id z7mr5325580wrw.415.1616001734048;
        Wed, 17 Mar 2021 10:22:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw4yMffe6AVXzrbHcSkMfW4mrYMLQtBrzouKvYs3+tGE9yCV1ENsPMfAQRlfH7ea3dENh2njA==
X-Received: by 2002:a05:6000:1107:: with SMTP id z7mr5325563wrw.415.1616001733838;
        Wed, 17 Mar 2021 10:22:13 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id s83sm2984618wmf.26.2021.03.17.10.22.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Mar 2021 10:22:13 -0700 (PDT)
Subject: Re: [PATCH 2/4] KVM: nVMX: Handle dynamic MSR intercept toggling
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alexander Graf <graf@amazon.com>,
        Yuan Yao <yaoyuan0329os@gmail.com>
References: <20210316184436.2544875-1-seanjc@google.com>
 <20210316184436.2544875-3-seanjc@google.com>
 <66bc75f6-58c5-c67f-f268-220d371022a2@redhat.com>
 <YFIzbz6S5/vyvBJz@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <fe8329d4-3b80-7eda-a2ab-be282b4aa31b@redhat.com>
Date:   Wed, 17 Mar 2021 18:22:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YFIzbz6S5/vyvBJz@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/03/21 17:50, Sean Christopherson wrote:
>> Feel free to squash patch 3 in this one or reorder it before; it makes sense
>> to make them macros when you go from 4 to 6 functions.
> I put them in a separate patch so that backporting the fix for the older FS/GS
> nVMX bug was at least feasible.  Not worth it?

Going all the way back to 5.2 would almost certainly have other 
conflicts, so probably not.

Paolo

