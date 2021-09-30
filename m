Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A60641DF83
	for <lists+kvm@lfdr.de>; Thu, 30 Sep 2021 18:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352292AbhI3QrQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Sep 2021 12:47:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52814 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1352288AbhI3QrP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 30 Sep 2021 12:47:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633020332;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DwjKvD8YF5gtcYPtNR5jajIiUW/9CEDaAKvvOa5euB8=;
        b=Sbi1Z9ijOH39vzhBlacIjfsDxuXgqUijmrxxh1dvwQQVH/Lxx9bNC3B0bO0oBjb2GwOshX
        fXOz+oe+BL4ev2YgJ2CZj4uD2jrcrnhqQotQXTp3vqsmBYvnSTHli/QBm5TwAa1F34e2O6
        +IJDjkdZY4uPC6gTkc1uSob8HnZO0y0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-240-XcvfpjgdN9K3oovF0vgZlQ-1; Thu, 30 Sep 2021 12:45:30 -0400
X-MC-Unique: XcvfpjgdN9K3oovF0vgZlQ-1
Received: by mail-wm1-f71.google.com with SMTP id 70-20020a1c0149000000b0030b7dd84d81so3235626wmb.3
        for <kvm@vger.kernel.org>; Thu, 30 Sep 2021 09:45:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=DwjKvD8YF5gtcYPtNR5jajIiUW/9CEDaAKvvOa5euB8=;
        b=HRVBqo5pd5Npi4CW7B3qicrXSWA7aLdjNFrkN3CQ6+N6P2seuBa+nKNWyKqNN6f3Qs
         5IBJ0kUCVRq7/JksRZO0lNRqBuK010FkhwONCzqaHY+/RcP5f07kJwW5iz6bRrbzrJdh
         To9V2KS0nVg6Kqvq8p+Yv2hI5YwN97W0qEUVchFCXNd4Bp/kgOIC6V3dzrueLpcWVRM4
         305ehXDQe7QLyejSllSaz22QqJaR/t/VoN31NY6FlTSIseQsZwzvbU5HZx3zY19D2j0+
         VL54/ybzi10gW05/Tk/4k0AUzVEq58HgQUlmbc4ySNe9VfUL0MJ7euNDV29taGFwZ/ZD
         pAYQ==
X-Gm-Message-State: AOAM532AO9Ew7a2GUME4m40JQUViBLMPp52S+eiWSkQoMP7Tr+bfviTE
        OHXxJDiixA0nX61jpLLeUx5gjvi30EmPR2EM1FN/rL9RPQ6AdY+C9pqxQq9kNxpfl0Goy/XkdRb
        YQHArpgC0Rouk
X-Received: by 2002:a1c:7302:: with SMTP id d2mr257626wmb.92.1633020329465;
        Thu, 30 Sep 2021 09:45:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyzLugsmS9ArG342vN8W9Trx3UAuRgmORibyqOueNOWDRWcTqSsfBi3wftEHd8tLxGBSzo7qg==
X-Received: by 2002:a1c:7302:: with SMTP id d2mr257602wmb.92.1633020329257;
        Thu, 30 Sep 2021 09:45:29 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id r2sm3652294wmq.28.2021.09.30.09.45.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Sep 2021 09:45:28 -0700 (PDT)
Message-ID: <bf754b55-90f2-8055-468f-a2b9b76b4d02@redhat.com>
Date:   Thu, 30 Sep 2021 18:45:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH 2/2] KVM: x86: Manually retrieve CPUID.0x1 when getting
 FMS for RESET/INIT
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+f3985126b746b3d59c9d@syzkaller.appspotmail.com,
        Alexander Potapenko <glider@google.com>
References: <20210929222426.1855730-1-seanjc@google.com>
 <20210929222426.1855730-3-seanjc@google.com>
 <75632fa9-e813-266c-7b72-cf9d8142cebf@redhat.com>
 <YVXTnheIB6MCKGve@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YVXTnheIB6MCKGve@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/09/21 17:11, Sean Christopherson wrote:
>>
>> But, perhaps adding kvm_find_cpuid_entry_index and removing the last
>> parameter from kvm_find_cpuid_entry would be a good idea.
> I like this idea, but only if callers are forced to specify the index when the
> index is significant, e.g. add a magic CPUID_INDEX_DONT_CARE and WARN in
> cpuid_entry2_find() if index is significant and index == DONT_CARE.

Yeah, or it can just be that kvm_find_cpuid_entry passes -1 which acts 
as the magic value.

> I'll fiddle with this, unless you want the honors?

Not really. :)  Thanks,

Paolo

