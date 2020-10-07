Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5113E286648
	for <lists+kvm@lfdr.de>; Wed,  7 Oct 2020 19:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728695AbgJGRyS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Oct 2020 13:54:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22025 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728298AbgJGRyQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 7 Oct 2020 13:54:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602093255;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vH9Kiij2/aTW7bWMoqRFax1aZ04huQLmyjYHxGrPQdc=;
        b=hy588wNbTybUX2yppO//PNsX1EET+say0PxYsk/8vuf8eFLWIVDevGsXwZ50nyLkNyNkTg
        RuVbMSg2AvO7+wXoNYlFxiuHnuFzDMPiFaTJvQKzMqZxCFTjGgI7z72XEjSr3xJcewGL8u
        g3VVkNfWhZtNZE9XKX+F1xSO5NSYjj8=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-341-35ozINl1NuyNN1RbO3eHEw-1; Wed, 07 Oct 2020 13:54:11 -0400
X-MC-Unique: 35ozINl1NuyNN1RbO3eHEw-1
Received: by mail-wr1-f71.google.com with SMTP id 33so1692645wrk.12
        for <kvm@vger.kernel.org>; Wed, 07 Oct 2020 10:54:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vH9Kiij2/aTW7bWMoqRFax1aZ04huQLmyjYHxGrPQdc=;
        b=M55VTZHmfvi0C+VeXgm/3VBgIpyLrUFGa26V7BOfADvdWg+2Ae7ILErbZ8jsjPLB21
         AemKx5gKFfVy2z4FP6HIpoYivhXw0ZAJl8K2htE8jOJ0Osz2sVXimPazTfp6bXcNiMwi
         Wrs8/UlaIgNU6qhdM/lbqV48XUmDcvpzSvDKXlL9N5ZkUZYFucFbTpFr3ExaQiDFfcAA
         nbXvVlf7rxwDwdyPDm0BMLIPeKSlOPdl1bgVopXbNMZciyfkHWB3055pEdTWl/HUwwpa
         nNaOwoUxKloIkU7M4jbBT/df25tpklC3z8xDgu/VPCR2TX+s0HkN8L6RpipzNgttYmT2
         kbzw==
X-Gm-Message-State: AOAM530SI+KD/yEBwSOHzLHhYDKOfRB+OMTwEtytaULvfEWUUUGi/PW9
        ZR34JQlskMAx37IYblaxSVHkxonT9WBfqmQB1t1xdFlZN736UDPV5PARB+EvrVFLcNeUDnMqMi8
        rGBdljXz/EfNo
X-Received: by 2002:a1c:3105:: with SMTP id x5mr4237273wmx.143.1602093250496;
        Wed, 07 Oct 2020 10:54:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx4+uUHG31siOZb1tYt9cPAYxZ5B/XQn33ayWCITZONCDeGW1eaR6Zh3CPhBOOARnjaPLcSNQ==
X-Received: by 2002:a1c:3105:: with SMTP id x5mr4237182wmx.143.1602093249068;
        Wed, 07 Oct 2020 10:54:09 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:d2f4:5943:190c:39ff? ([2001:b07:6468:f312:d2f4:5943:190c:39ff])
        by smtp.gmail.com with ESMTPSA id 67sm3587452wmb.31.2020.10.07.10.54.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Oct 2020 10:54:08 -0700 (PDT)
Subject: Re: [PATCH 15/22] kvm: mmu: Support changed pte notifier in tdp MMU
To:     Ben Gardon <bgardon@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Cannon Matthews <cannonmatthews@google.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
References: <20200925212302.3979661-1-bgardon@google.com>
 <20200925212302.3979661-16-bgardon@google.com>
 <622ffc59-d914-c718-3f2f-952f714ac63c@redhat.com>
 <CANgfPd_8SpHkCd=NyBKtRFWKkczx4SMxPLRon-kx9Oc6P7b=Ew@mail.gmail.com>
 <7636707a-b622-90a3-e641-18662938f6dd@redhat.com>
 <CANgfPd_F_EurkfGquC79cEHa=4A2AMfnCAfMHPpAXa-6w4+bsg@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <5bb8168c-e4a2-6365-f220-13b67c9c375d@redhat.com>
Date:   Wed, 7 Oct 2020 19:54:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <CANgfPd_F_EurkfGquC79cEHa=4A2AMfnCAfMHPpAXa-6w4+bsg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/10/20 19:30, Ben Gardon wrote:
>> Well that's not easy if you have to think of which functions have to be
>> called.
>>
>> I'll take a closer look at the access tracking and dirty logging cases
>> to try and understand what those bugs can be.  Apart from that I have my
>> suggested changes and I can probably finish testing them and send them
>> out tomorrow.
> Awesome, thank you. I'll look forward to seeing them. Will you be
> applying those changes to the tdp_mmu branch you created as well?
> 

No, only to the rebased version.

Paolo

