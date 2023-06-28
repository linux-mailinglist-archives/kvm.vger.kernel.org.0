Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13006741048
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 13:46:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231161AbjF1LqO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 07:46:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36726 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230456AbjF1LqM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 28 Jun 2023 07:46:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687952721;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gG34vBszsSTsXv424f+J6wft9r6cv3NSWGV4K4eT1m0=;
        b=gsZEG3XbO+ydB20VNpWaA0mW94DqU/vfS+h81qTwUvHy2ThfwxiPynmsnKXSpdF+CxeLYT
        SYldf9EdHTuwQyjqVaI0TGTPZk9eR5I9g/E3Kf9qDZPZo2MoVq7a8IwIe0aIfbuASru6w8
        t/H7oJsESOqn95qFr4huLdqQSU9YAH8=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-608-wDlr5My4Nqu2INLOmVBpPw-1; Wed, 28 Jun 2023 07:45:20 -0400
X-MC-Unique: wDlr5My4Nqu2INLOmVBpPw-1
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-7659d103147so401267485a.3
        for <kvm@vger.kernel.org>; Wed, 28 Jun 2023 04:45:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687952719; x=1690544719;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gG34vBszsSTsXv424f+J6wft9r6cv3NSWGV4K4eT1m0=;
        b=WOslcCNfdtyGR00gQjEEP0m6TDBN1yKe4LB9Udkx1rjUDX3Q78im5CPHnkuGCf1cuG
         IYnomWATSUo9mK2TSelB3XSsbuDnp3qlnSJY/VegiTOX/5Je0Ep4wlWxjr+zzBi0gWhr
         VPcLExpoEnsIbxlglKY9KmBRsilKtlgcyowyq19JChlDsAwDRwOkTOWBesCNE76bEPeP
         1e9TL35MvLDsBt13rL36/IwgCdb1wCPag5rv4/nVTN2NJyBqi9JK54PD+dvEHStGiHw7
         WyV72e5Dt72uz5vOgewyVTGdb+bDPIjxwsr631LGLedjhzF0/Uuo8afP8NIoLbT64p2b
         pbqg==
X-Gm-Message-State: AC+VfDzQBt7+G7+Hj7zuLis3z3vJHNW3PAAGlqgi5z21NJBTNajV/xyb
        kwGpvn8NLmW4eS1h73RCvv1g30Rq8z7kh62eC6jivbH/D6d4OhXErfdWp0jgYx/xsUbXqd3pF2i
        gypMsrgk6tkAK5rLsC2wu
X-Received: by 2002:ad4:5b81:0:b0:61a:197b:605 with SMTP id 1-20020ad45b81000000b0061a197b0605mr40853442qvp.1.1687952719552;
        Wed, 28 Jun 2023 04:45:19 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5IuyO6xm/7d6GVxqbgTrPYJusJ78jlvdgLFF7AKVoRvQjl0Q/qvORJnqPEtUaAlb7IFTttAg==
X-Received: by 2002:ad4:5b81:0:b0:61a:197b:605 with SMTP id 1-20020ad45b81000000b0061a197b0605mr40853410qvp.1.1687952719223;
        Wed, 28 Jun 2023 04:45:19 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id du7-20020a05621409a700b006301d31e315sm5714148qvb.10.2023.06.28.04.45.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Jun 2023 04:45:18 -0700 (PDT)
Message-ID: <e570fe02-3018-cb8f-ee21-b9f6e9ee11b9@redhat.com>
Date:   Wed, 28 Jun 2023 13:45:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v3 0/6] arm: pmu: Fix random failures of
 pmu-chain-promotion
Content-Language: en-US
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     eric.auger.pro@gmail.com, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, andrew.jones@linux.dev, maz@kernel.org,
        will@kernel.org, oliver.upton@linux.dev, ricarkol@google.com,
        reijiw@google.com, mark.rutland@arm.com
References: <20230619200401.1963751-1-eric.auger@redhat.com>
 <0aa48994-96b3-b5a1-e72b-961e6e892142@redhat.com>
 <ZJwI45VTkf6TppBm@monolith.localdoman>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <ZJwI45VTkf6TppBm@monolith.localdoman>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alexandru,

On 6/28/23 12:18, Alexandru Elisei wrote:
> Hi,
>
> On Wed, Jun 28, 2023 at 09:44:44AM +0200, Eric Auger wrote:
>> Hi Alexandru, Drew,
>>
>> On 6/19/23 22:03, Eric Auger wrote:
>>> On some HW (ThunderXv2), some random failures of
>>> pmu-chain-promotion test can be observed.
>>>
>>> pmu-chain-promotion is composed of several subtests
>>> which run 2 mem_access loops. The initial value of
>>> the counter is set so that no overflow is expected on
>>> the first loop run and overflow is expected on the second.
>>> However it is observed that sometimes we get an overflow
>>> on the first run. It looks related to some variability of
>>> the mem_acess count. This variability is observed on all
>>> HW I have access to, with different span though. On
>>> ThunderX2 HW it looks the margin that is currently taken
>>> is too small and we regularly hit failure.
>>>
>>> although the first goal of this series is to increase
>>> the count/margin used in those tests, it also attempts
>>> to improve the pmu-chain-promotion logs, add some barriers
>>> in the mem-access loop, clarify the chain counter
>>> enable/disable sequence.
>>>
>>> A new 'pmu-mem-access-reliability' is also introduced to
>>> detect issues with MEM_ACCESS event variability and make
>>> the debug easier.
>>>
>>> Obviously one can wonder if this variability is something normal
>>> and does not hide any other bug. I hope this series will raise
>>> additional discussions about this.
>>>
>>> https://github.com/eauger/kut/tree/pmu-chain-promotion-fixes-v3
>>>
>>> History:
>>>
>>> v2 -> v3:
>>> - took into account Alexandru's comments. See individual log
>>>   files
>> Gentle ping. Does this version match all your expectations?
> The series are on my radar, I'll have a look this Friday.

OK thanks :-)

Eric
>
> Thanks,
> Alex
>
>> Thanks
>>
>> Eric
>>> v1 -> v2:
>>> - Take into account Alexandru's & Mark's comments. Added some
>>>   R-b's and T-b's.
>>>
>>>
>>> Eric Auger (6):
>>>   arm: pmu: pmu-chain-promotion: Improve debug messages
>>>   arm: pmu: pmu-chain-promotion: Introduce defines for count and margin
>>>     values
>>>   arm: pmu: Add extra DSB barriers in the mem_access loop
>>>   arm: pmu: Fix chain counter enable/disable sequences
>>>   arm: pmu: Add pmu-mem-access-reliability test
>>>   arm: pmu-chain-promotion: Increase the count and margin values
>>>
>>>  arm/pmu.c         | 208 ++++++++++++++++++++++++++++++++--------------
>>>  arm/unittests.cfg |   6 ++
>>>  2 files changed, 153 insertions(+), 61 deletions(-)
>>>

