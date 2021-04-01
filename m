Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E77ED3513C8
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 12:42:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233858AbhDAKld (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 06:41:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45889 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233553AbhDAKlF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Apr 2021 06:41:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617273664;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CbaTvFT9jV915Hh2tSzMnC9qOGARRNTOWV6YJrRhpRs=;
        b=DnUPfSHo/3dvAN77RpHLun8eQe3UBJIdnK0tcoTHkmclc4AVZv1F5XmaU+KwrlYBsBzpph
        UZ2tRA0hWM2CZneW6+FROC8zGaf/Pm6+P/I5GmgecYJ4OxL/O6oDnAgEAwQ0EbVRKcsfQE
        r922ySjChglUBsbPNB/t8x78YzToAbM=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-220-naLEi49vOrSzaw4iDAW8Cw-1; Thu, 01 Apr 2021 06:41:03 -0400
X-MC-Unique: naLEi49vOrSzaw4iDAW8Cw-1
Received: by mail-wr1-f69.google.com with SMTP id n17so2543200wrq.5
        for <kvm@vger.kernel.org>; Thu, 01 Apr 2021 03:41:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CbaTvFT9jV915Hh2tSzMnC9qOGARRNTOWV6YJrRhpRs=;
        b=CCpHYP4lcJjaZKydiCvVFQjBr+dWK3d5VmPrcjo6w/hHOMUA8vmM8Uz4jTz1fChIEO
         HZLjaeRQz3Od37PBb2SEzfszMlEXQkfQnmBf5+JlCX6upi+i3YGS+iNcX936rKJmN7cV
         HiYXY7rPAv/u+D2z2MPaXoQ7igBY/ZkNjiLaYMwQFxTR3C957Nm09NCv/dalzfGYrxQ+
         bmYkIoLFY71FoqPLSgq7FBmcMtHYi4a/QJmWFiKkxrMo4sb8irI4ZGSf11t7eDLBmbZf
         PkTXWb/JwJINK5aDbyDhMo15dnutmTisiyKPGJNqwq3YrF3cMsNRIUeBVsjogtqw7c5U
         4eWg==
X-Gm-Message-State: AOAM530lZdAbYvQld4tYulRMsccP9E2bt8HwF1O+CpgEVf6ECJofFQ9f
        KNYW54Qazz/zrpkviYYN7Bltb0zG/Y1pgnif2K54GOv2vZNk9Ntf9HXxBeqputBcvbUFcZT2DM7
        IrwHvVxsjf0AK
X-Received: by 2002:a5d:4582:: with SMTP id p2mr8757245wrq.34.1617273662152;
        Thu, 01 Apr 2021 03:41:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwsj33kTXQgfYY9muxulNGXdA3guJ/A5QPfb4dIyEUtaXTPvlUwaH3PhUPRfj3yFTOi1zGcSg==
X-Received: by 2002:a5d:4582:: with SMTP id p2mr8757224wrq.34.1617273661994;
        Thu, 01 Apr 2021 03:41:01 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id u20sm9714996wru.6.2021.04.01.03.41.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Apr 2021 03:41:01 -0700 (PDT)
Subject: Re: [PATCH 13/13] KVM: x86/mmu: Tear down roots in fast invalidation
 thread
To:     Sean Christopherson <seanjc@google.com>,
        Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
References: <20210331210841.3996155-1-bgardon@google.com>
 <20210331210841.3996155-14-bgardon@google.com> <YGT31GoDhVSXlgP4@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ca227500-9fe9-0600-065c-70e02916488f@redhat.com>
Date:   Thu, 1 Apr 2021 12:41:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YGT31GoDhVSXlgP4@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/04/21 00:29, Sean Christopherson wrote:
>> +	if (is_tdp_mmu_enabled(kvm)) {
>> +		read_lock(&kvm->mmu_lock);
>> +		kvm_tdp_mmu_zap_all_fast(kvm);
> Purely because it exists first, I think we should follow the legacy MMU's
> terminology, i.e. kvm_tdp_mmu_zap_obsolete_pages().
> 

It's a bit different, obsolete pages in kvm_zap_obsolete_pages have an 
old mmu_valid_gen.  They are not invalid, so it is inaccurate to talk 
about obsolete pages in the context of the TDP MMU.  But I agree that 
the function should be renamed.

Paolo

