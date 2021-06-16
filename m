Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F21023AA45F
	for <lists+kvm@lfdr.de>; Wed, 16 Jun 2021 21:31:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231452AbhFPTdm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Jun 2021 15:33:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:22264 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231202AbhFPTdi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 16 Jun 2021 15:33:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623871891;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sNNp0eIzCVCfXdjt8vd07Lhu5JkSAHpnkOwlvasxeV4=;
        b=LUg5+Z7Yn/i1cc8TU3BFQGaEcjYGeej64Q9obLTY22duFTf0Ge4V4YP1oCqxmhPL+X4G9t
        iAEDYF9d6AercwWr7arkL4ZeTebEdYi3HgQ9hm+dNYWw9kU/mX3ERvxbwrqYhjvBZnjqvJ
        1kppe0JjkVTxtgMwAVpiL01hkmnjaow=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-18-FwcEQiWUPMaQ-8SpR-tOFw-1; Wed, 16 Jun 2021 15:31:29 -0400
X-MC-Unique: FwcEQiWUPMaQ-8SpR-tOFw-1
Received: by mail-ej1-f71.google.com with SMTP id nd10-20020a170907628ab02903a324b229bfso1369700ejc.7
        for <kvm@vger.kernel.org>; Wed, 16 Jun 2021 12:31:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sNNp0eIzCVCfXdjt8vd07Lhu5JkSAHpnkOwlvasxeV4=;
        b=MU/VqCKuaDrW0QN4UnsuDOI1YljTqsPbEOXL07hGE8XkPvV4kGtavbelXnM8Q4Crli
         qRRMZdqT5XaPzZAdlqpLKwCVurehn8cQS2WNBmcw5CghpcE1wbU622cTMgwC5eR8IoTR
         TU5ldL5fpdgxl3aAsIxZNDfZQBabehM50DV/TTDJvnXuY6k1RFKHyDDaGr+aIdfHGms2
         s7EfGEOmHs1Y/yc5RzLFlTnUeO6lxOV0S8jdtAZBwHw0yy2D2XJL04kPaOO44PoVDzTU
         W0u6D330cAcjUE2lE3JdAXZ1mNpMf6XmddM7xCV01bvhhPEq+cx6tMqyUSbYD6n046p3
         F1xw==
X-Gm-Message-State: AOAM531m4O2UTZp3ZwLsXNubJnxG83bpzsMR8f/YUOHUtYekkZqUqBNi
        zkSKHqHtRqQxKdzxxrXNa5n1xUyrzdYDFtK2dNRG7uCiCzqB6m8HN7KH7vjbEwh2EzzTski8lbB
        F+Dnf5qkmFX7U
X-Received: by 2002:a17:906:1701:: with SMTP id c1mr1095967eje.425.1623871888402;
        Wed, 16 Jun 2021 12:31:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwNxNch3YPl1SlZRNt2XCc83Vo2v/l1WQ5Scl1mveVXnY0LzUKi7d67GmKFhIr5H5zF1gk3YQ==
X-Received: by 2002:a17:906:1701:: with SMTP id c1mr1095952eje.425.1623871888243;
        Wed, 16 Jun 2021 12:31:28 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id cw10sm2173687ejb.62.2021.06.16.12.31.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Jun 2021 12:31:27 -0700 (PDT)
Subject: Re: [PATCH 0/8] KVM: x86/mmu: Fast page fault support for the TDP MMU
To:     David Matlack <dmatlack@google.com>
Cc:     kvm@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Junaid Shahid <junaids@google.com>,
        Andrew Jones <drjones@redhat.com>
References: <20210611235701.3941724-1-dmatlack@google.com>
 <639c54a4-3d6b-8b28-8da7-e49f2f87e025@redhat.com>
 <YMfFQnfsq5AuUP2B@google.com>
 <a13646ce-ee54-4555-909b-2d2977f65f59@redhat.com>
 <YMpQu6q1YViuLwhg@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <55e38377-dd53-a167-117d-19beea443c1d@redhat.com>
Date:   Wed, 16 Jun 2021 21:31:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YMpQu6q1YViuLwhg@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/06/21 21:27, David Matlack wrote:
>>> I actually have a set of
>>> patches from Ben I am planning to send soon that will reduce the number of
>>> redundant gfn-to-memslot lookups in the page fault path.
>> That seems to be a possible 5.14 candidate, while this series is probably a
>> bit too much for now.
> Thanks for the feedback. I am not in a rush to get either series into
> 5.14 so that sounds fine with me. Here is how I am planning to proceed:
> 
> 1. Send a new series with the cleanups to is_tdp_mmu_root Sean suggested
>     in patch 1/8 [1].
> 2. Send v2 of the TDP MMU Fast Page Fault series without patch 1/8.
> 3. Send out the memslot lookup optimization series.
> 
> Does that sound reasonable to you? Do you have any reservations with
> taking (2) before (3)?
> 
> [1]https://lore.kernel.org/kvm/YMepDK40DLkD4DSy@google.com/

They all seem reasonably independent, so use the order that is easier 
for you.

Paolo

