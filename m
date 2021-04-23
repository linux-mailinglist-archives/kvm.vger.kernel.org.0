Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A886D368D8F
	for <lists+kvm@lfdr.de>; Fri, 23 Apr 2021 09:04:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240905AbhDWHE7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 03:04:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57893 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229456AbhDWHE7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 23 Apr 2021 03:04:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619161462;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RmvPHXOIz59ZhDsNoQXWHFewKFvZPSMFlQfKoIahSjw=;
        b=bcD5YH7NBbaihGcoebNMZNDePeLgOikAWc4lmwxFESgdN83e81L4n2wn95Zhwi0f1P+LNn
        vVra+PfjfkDBab+lwjfddr6tw2My2ItN3VINrCHdEmWhct6eqwCwRAQn8TNFRYq2qWvi6l
        7u0Y9O1SHIi982sODM7LKnWNIcxKmEM=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-446-s3ILswUGMX-Y_ow0bPAWvA-1; Fri, 23 Apr 2021 03:04:21 -0400
X-MC-Unique: s3ILswUGMX-Y_ow0bPAWvA-1
Received: by mail-ej1-f72.google.com with SMTP id z6-20020a17090665c6b02903700252d1ccso8010585ejn.10
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 00:04:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RmvPHXOIz59ZhDsNoQXWHFewKFvZPSMFlQfKoIahSjw=;
        b=E8hY10mB01TdfMDt80EfICOA7Nlna7VFIo5wRutZ0zaxGAKTlOzFhQ5XRUcua+YJ9Z
         jXgQnNmlvPI5HMv/W11UPoun5SNhpvOIHa/YVRWUcYrnye/2MVNx2/FAYHhEg48Gxquv
         tSnl5MURRCea/+EzclM/Xg6J262zn9+GfTpQJiXQ/dn0C9FP1m/KWXCkH7OwLm3Qolig
         MDx7G24c2F4neD/ERuqmLpnWXMM7AEPiw9AgYY7hj+L/ajDPbDGsGQ+X4nmzvhRBnk8j
         tI48oZy9oqxA23UQrJGTve8W1AjWxl6CeU1dLXhO7uFY9D4cSgI5GopB1rT/aI3cx6Gw
         Uyvg==
X-Gm-Message-State: AOAM531zw65BI/5ucr3B9lf9cK3SJrJgx7vhsJ5KKFRzrMpf2WK3j+qN
        aouIeELJulhXGKaVJf7DYh5VIgf/yGUpu7cn54nqiVLAwwh/jXvYE5TkxhE9cfRlldlHabwA0Vb
        qQpm0Od8qfkA5
X-Received: by 2002:a05:6402:646:: with SMTP id u6mr2719487edx.74.1619161459991;
        Fri, 23 Apr 2021 00:04:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxWR+WigVfcUVDUgxhH63vnxFbSo3QzmiBcdSKKBGoPovmcpdIwJCOfTnVynrTz+hP5rmBfYA==
X-Received: by 2002:a05:6402:646:: with SMTP id u6mr2719474edx.74.1619161459855;
        Fri, 23 Apr 2021 00:04:19 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id l3sm4009512edr.2.2021.04.23.00.04.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Apr 2021 00:04:19 -0700 (PDT)
Subject: Re: [PATCH 0/4] KVM: x86: Kill off pdptrs_changed()
To:     Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210423000637.3692951-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <68ff1249-2902-43d5-3dfd-35b1f14c4f90@redhat.com>
Date:   Fri, 23 Apr 2021 09:04:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210423000637.3692951-1-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/04/21 02:06, Sean Christopherson wrote:
> Remove pdptrs_changed(), which is mostly dead anyways, and the few bits
> that are still thrashing are useless.
> 
> This conflicts with Maxim's work to migrate PDPTRs out-of-band, but I
> think it will conflict in a good way as the "skip load_pdptrs()"
> logic for the out-of-band case won't have to juggle this legacy crud.

Maxim, can you integrate these patches in your series yourself?

Thanks,

Paolo

> Sean Christopherson (4):
>    KVM: nVMX: Drop obsolete (and pointless) pdptrs_changed() check
>    KVM: nSVM: Drop pointless pdptrs_changed() check on nested transition
>    KVM: x86: Always load PDPTRs on CR3 load for SVM w/o NPT and a PAE
>      guest
>    KVM: x86: Unexport kvm_read_guest_page_mmu()
> 
>   arch/x86/include/asm/kvm_host.h |  4 ----
>   arch/x86/kvm/svm/nested.c       |  6 ++---
>   arch/x86/kvm/vmx/nested.c       |  8 +++----
>   arch/x86/kvm/x86.c              | 41 ++++-----------------------------
>   4 files changed, 10 insertions(+), 49 deletions(-)
> 

