Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8320352A23
	for <lists+kvm@lfdr.de>; Fri,  2 Apr 2021 13:14:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235077AbhDBLOz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Apr 2021 07:14:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:34982 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234448AbhDBLOz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 2 Apr 2021 07:14:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617362092;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/fKJ2OSCFXizuU2U1MJ67BIOWCyNds4Q38dY2jX+k4E=;
        b=IuTrGx2H4s5+2boY/qSzwSUi70bWbbG7kBZSN2vQIJlTxSfpW9QhF2e33+CzSihH9Cla2q
        khTZPYErEx+FWFSKvMHUZZR5PpDBpUT2gO+CaWhgrlXoRtYzi0OR3urF1kL5tY36LEwLUS
        DZn290JgXSodiN1gdbv69H7ONV+xnDM=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-556-WO4OiiUcOPauy4bEVvvcAw-1; Fri, 02 Apr 2021 07:14:51 -0400
X-MC-Unique: WO4OiiUcOPauy4bEVvvcAw-1
Received: by mail-wr1-f71.google.com with SMTP id x9so4185729wro.9
        for <kvm@vger.kernel.org>; Fri, 02 Apr 2021 04:14:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/fKJ2OSCFXizuU2U1MJ67BIOWCyNds4Q38dY2jX+k4E=;
        b=TwjcRIEQ973imeOPJx/SgdX1LK05N+0xq/QFTrgVczqB1G3XPWf1m5CdmRapomOWcU
         32hHx5u4Trj61C5nlfmUzrRw2+nh5HDLi+uxrkTLl0kgET3yVIgVv42WyhIRGz84PRtW
         AYCRnaYRbxu7yGIjPoAbPHDVvKnS3Uh9yTWXIl9K8clv7/UmvMrso6Hwyn+XahdlJHWl
         93nj5lrPNMotLXJYjwI4Emm6bHaLMCVuWDBT4khRKi431uEWkzC/uSmJA3H697oFCrcK
         iRFgI1qteCTbnE9q9TO1bFv1jBtG5QIVMdNuOdwO6+QZ0K79g0kFQF9fdfk8AnUZLvWY
         rmXA==
X-Gm-Message-State: AOAM5324DWMKv7mkzgVkH/DhYKyKf+8YwtPSnSrmjHVvbEvQNrtr7hu2
        MHDGAW3Vy2nKYM3loOyyLecs+QleU08VrHPFPiFkr7sBhUAkG3/38v8dhnsNKSjZSILwoud1+Q8
        TfyZCen6nFktf
X-Received: by 2002:adf:fb05:: with SMTP id c5mr15230081wrr.302.1617362090123;
        Fri, 02 Apr 2021 04:14:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyDC2lEkIz55o7/8zmXTfl7KMf2+IvXa4U8NcK872E7p5nXNoS/a2umf8IXffQu2cm+oMqeRQ==
X-Received: by 2002:adf:fb05:: with SMTP id c5mr15230063wrr.302.1617362089964;
        Fri, 02 Apr 2021 04:14:49 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id n1sm18076777wro.36.2021.04.02.04.14.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Apr 2021 04:14:49 -0700 (PDT)
Subject: Re: [PATCH v2 10/13] KVM: x86/mmu: Allow zapping collapsible SPTEs to
 use MMU read lock
To:     Ben Gardon <bgardon@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
References: <20210401233736.638171-1-bgardon@google.com>
 <20210401233736.638171-11-bgardon@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <4140362f-92d5-5c5e-de8e-4e1e3a65b317@redhat.com>
Date:   Fri, 2 Apr 2021 13:14:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210401233736.638171-11-bgardon@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/04/21 01:37, Ben Gardon wrote:
> To speed the process of disabling dirty logging, change the TDP MMU
> function which zaps collapsible SPTEs to run under the MMU read lock.

Technically it only reduces the impact on the running VM; it doesn't
speed it up right?  Something like:

     To reduce the impact of disabling dirty logging, change the TDP MMU
     function which zaps collapsible SPTEs to run under the MMU read lock.
     This way, page faults on zapped SPTEs can proceed in parallel with
     kvm_mmu_zap_collapsible_sptes.

Paolo

