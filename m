Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8266436EE91
	for <lists+kvm@lfdr.de>; Thu, 29 Apr 2021 19:05:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240856AbhD2RFz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Apr 2021 13:05:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50066 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240748AbhD2RFz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 29 Apr 2021 13:05:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619715908;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0MUCBIWhyKVnTkZFyye6IccUiGMOTOb9ZCPP+i2RvTg=;
        b=UtcfiZLtwBQBX+rpnzFm43VMaRHSKdxQQuoCxJDjcT7Rltx+vME5Rpt9t4MVVYumkNZMWj
        Ijm3JOPIPtJoh7heRoVdv1EmGZVwVUP0/KRAtS/4elJZA91QBBSyoJZfUBL2zV4JjnEbZh
        4P6eqrGy4xtItxoQLlNUnR+aYBAAtng=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-293-ovZyd2WoP9WjXYBxZnpfZA-1; Thu, 29 Apr 2021 13:05:03 -0400
X-MC-Unique: ovZyd2WoP9WjXYBxZnpfZA-1
Received: by mail-ed1-f72.google.com with SMTP id u30-20020a50a41e0000b0290385504d6e4eso7259395edb.7
        for <kvm@vger.kernel.org>; Thu, 29 Apr 2021 10:05:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0MUCBIWhyKVnTkZFyye6IccUiGMOTOb9ZCPP+i2RvTg=;
        b=CR0RuNsOpdcuMjhz066I8QvAzlsm+WvUaSIJ6rHzsrLm+8TmWaF8oVI+N9OJ8Kaz+z
         yX8eXU4DqVW1r5gJG9mdKf/a6N2erjWXMW32FVXoBwn+jX16czIGCU59EME1drlY/2TC
         X8hfM/ONogeIETCaQ/cKpsah6gg8fNjezrU01oHOBdxxCo8jJid42GZxLGqrrlHzrv3h
         jNggEAzwnXlHdG8w6jjJvSoPSBs1UbpbeBMuL9UVq6WcoBvlw5+G9ir2dgmHiiy4IYiT
         Cmi7th0firNXLrNy2iMTlKPp/ALJYTITcN0ZCE4MlSrULg2vFNtVcwobq+MyEM/RrB5b
         9I1g==
X-Gm-Message-State: AOAM5319aYNdIvGZIml18cXdNjSoQ9EDCSxqNI1A9uwKTCVJZQI9D4Co
        CnUU1AveUUS5J0YYb+I6yfvpQK/5raYoEs7kKAWDF5FE7ISIxS03/3g+vO8LoeexFJ7cGJ2BE65
        AJWoHvHUSUoq9
X-Received: by 2002:a17:906:1a10:: with SMTP id i16mr885626ejf.353.1619715902665;
        Thu, 29 Apr 2021 10:05:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwj/OIVKoKsX1RZdBvXR3+9b3KsQpf5fzzMuN5TpKFJ3R89I/2U4cY3Ft0urqQ5EEfCxmn2Cg==
X-Received: by 2002:a17:906:1a10:: with SMTP id i16mr885609ejf.353.1619715902522;
        Thu, 29 Apr 2021 10:05:02 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id d9sm2755772eds.68.2021.04.29.10.05.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Apr 2021 10:05:02 -0700 (PDT)
Subject: Re: [PATCH] KVM: x86/mmu: Avoid unnecessary page table allocation in
 kvm_tdp_mmu_map()
To:     Ben Gardon <bgardon@google.com>, Kai Huang <kai.huang@intel.com>
Cc:     kvm <kvm@vger.kernel.org>, Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <20210429041226.50279-1-kai.huang@intel.com>
 <CANgfPd_PMO6cKtPoTaEV0R_qWfbm1TgwpT=7Sr_N_5JKMgysVQ@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <4091e1aa-4401-da41-4981-4c57da5c0cc4@redhat.com>
Date:   Thu, 29 Apr 2021 19:05:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <CANgfPd_PMO6cKtPoTaEV0R_qWfbm1TgwpT=7Sr_N_5JKMgysVQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/04/21 18:22, Ben Gardon wrote:
> On Wed, Apr 28, 2021 at 9:12 PM Kai Huang <kai.huang@intel.com> wrote:
>>
>> In kvm_tdp_mmu_map(), while iterating TDP MMU page table entries, it is
>> possible SPTE has already been frozen by another thread but the frozen
>> is not done yet, for instance, when another thread is still in middle of
>> zapping large page.  In this case, the !is_shadow_present_pte() check
>> for old SPTE in tdp_mmu_for_each_pte() may hit true, and in this case
>> allocating new page table is unnecessary since tdp_mmu_set_spte_atomic()
>> later will return false and page table will need to be freed.  Add
>> is_removed_spte() check before allocating new page table to avoid this.
>>
>> Signed-off-by: Kai Huang <kai.huang@intel.com>
> 
> Nice catch!
> 
> Reviewed-by: Ben Gardon <bgardon@google.com>

Queued, thanks for the quick review.

Paolo

