Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C59937315E
	for <lists+kvm@lfdr.de>; Tue,  4 May 2021 22:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232596AbhEDU1X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 May 2021 16:27:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29803 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229542AbhEDU1W (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 4 May 2021 16:27:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620159986;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NmaFtxsE0S5qvJK+FcOeAQOG1JYRVA5bDwB/1VM2dIk=;
        b=QqAvEi4FNbgdlCddsw6m88UPDAxj6Wrpsxgo8CdKS2PsdAFhGMPonsRL6pzhmfQzS+4ubj
        pkF15OpCS2HZft+N4hWlGSqWqCqwuuLI32Lczews0Yoae222RxY4GKyGEYtMHkvYmDUlb7
        hA7zvrYaKAXMXb1t4BEE8FlQp6MG7Zg=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-226-ZogSY5DJPc2kNS68Ssw1_Q-1; Tue, 04 May 2021 16:26:24 -0400
X-MC-Unique: ZogSY5DJPc2kNS68Ssw1_Q-1
Received: by mail-ed1-f72.google.com with SMTP id g7-20020aa7c5870000b02903888f809d62so6056639edq.23
        for <kvm@vger.kernel.org>; Tue, 04 May 2021 13:26:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NmaFtxsE0S5qvJK+FcOeAQOG1JYRVA5bDwB/1VM2dIk=;
        b=AnGxo+qSM86zoKHGZZhUh81YeUdnbZ/MLyZclji7PLgjnMUXzYlOzWfbt8bR+RucDY
         zUM0QsKhg3AcANedBqguOnSMV96Rvm59FcgAWs1rJavauTcQrG7mJmcqsSOwJRa8YVRT
         S6uRfcAvGCe52A9t15iDYxym1KEXw+ccjzwLPn5n1WeLIHDGQLe44qlWJ02B1ZyUXEKZ
         8sw23nNSXrLNEbeajRQ6MHWI2R2i6WXQHb0iQ4g44E3+3r1w+5mc0FBe4f9iFUYZz998
         X2VDObPGvGYr//rnwEUXOryki+n2TmqAaxOZsbhS9gOdxrpvCumb6TfpSjfW0nvvCdA2
         p+Dw==
X-Gm-Message-State: AOAM530gkWn6p5pzs9hLxs6O5lTfCAAmK+tsyvUNnvvcDT/OHlAmrWbZ
        c2Q9/XZUYSI4S/Vmqmhhcit0XYS5TqduhtjM1oeMTavq6gdp/Fex1LCY51zQ087mZN6UpSDC9Yq
        +f/SWT1A1R5au
X-Received: by 2002:a17:906:fcd6:: with SMTP id qx22mr24014615ejb.529.1620159983342;
        Tue, 04 May 2021 13:26:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxh1zbFHg9vwi2oHIGX5YBErFcyt0Oodg4Od0An9+HOszlBG2A+myYeCIIk2cSbkE0RAwV6gQ==
X-Received: by 2002:a17:906:fcd6:: with SMTP id qx22mr24014595ejb.529.1620159983133;
        Tue, 04 May 2021 13:26:23 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id ca20sm1907157ejb.84.2021.05.04.13.26.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 May 2021 13:26:22 -0700 (PDT)
Subject: Re: [PATCH v2 1/7] KVM: x86/mmu: Track if shadow MMU active
To:     Sean Christopherson <seanjc@google.com>,
        Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
References: <20210429211833.3361994-1-bgardon@google.com>
 <20210429211833.3361994-2-bgardon@google.com> <YJGmpOzaFy9E0f5T@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <edfadb98-b86e-6d03-bdfc-9025fac73dee@redhat.com>
Date:   Tue, 4 May 2021 22:26:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <YJGmpOzaFy9E0f5T@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/05/21 21:55, Sean Christopherson wrote:
> But, I think we we can avoid bikeshedding by simply eliminating this flag.  More
> in later patches.

Are you thinking of checking slot->arch.rmap[0] directly?  That should 
work indeed.

>> -	kvm_mmu_init_tdp_mmu(kvm);
>> +	if (!kvm_mmu_init_tdp_mmu(kvm))
>> +		activate_shadow_mmu(kvm);
> Doesn't come into play yet, but I would strongly prefer to open code setting the
> necessary flag instead of relying on the helper to never fail.
> 

You mean

kvm->arch.shadow_mmu_active = !kvm_mmu_init_tdp_mmu(kvm);

(which would assign to alloc_memslot_rmaps instead if shadow_mmu_active 
is removed)?  That makes sense.

Paolo

