Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B58AA6D58B5
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 08:24:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233633AbjDDGYJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 02:24:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233236AbjDDGYH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 02:24:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3594B138
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 23:23:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680589401;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=APNrYYwPBAuPO+GWb7+dbYKyxbTjRyfGmu8CPqknU3k=;
        b=COXlicD+7EXAJ+V275J7ui2dMHKOPPP6Gfd1pAzppXqLa2Q/RkyXQAgkB9RKbUWi+8W/MJ
        xZejej26+ewSBF4BrrfFoaKLl8wUyKsTsAMhIKHVrmPdOkoXAnz607dRZHxp7bSaF7pDHB
        1YZAuMN2LxAUd5VgEVPA7Gyp9l+YrIk=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-578-pyt_4OIvPTeFRYSVb-fZDA-1; Tue, 04 Apr 2023 02:23:20 -0400
X-MC-Unique: pyt_4OIvPTeFRYSVb-fZDA-1
Received: by mail-qt1-f197.google.com with SMTP id r4-20020ac867c4000000b003bfefb6dd58so21564465qtp.2
        for <kvm@vger.kernel.org>; Mon, 03 Apr 2023 23:23:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680589399;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=APNrYYwPBAuPO+GWb7+dbYKyxbTjRyfGmu8CPqknU3k=;
        b=FH717nIcUtTKIASW8cEIWhbPZrAinDPKr0HHjllA3UI0Bw89dx8uGHNUCCUgyyAGxS
         Ja6X9R0+uyoMtD5YypKL0SvajDYQ/bgghrt7+ujg6Z5oQPi72/yDNzmiFrqnUXVgr3Vx
         7F+MF8urvJH599RdAg5WklSvTUzZbxQTTlwjhfE9CHMqXVPOuTfB7IvB2DdiCHQRnwCn
         EyP+OCyJ1LrIYUACqeSnEB9QajfRKIEKbrwfSwAyZvvZYQjx8YLenRNWu25fqD5qYZQU
         o3hzZgbr80Nob/zTDKQC5XePgpPPzBDDfI2jB67rNoavjYK9MGpT3Vjt8vwJ6w+L7Hcf
         ZDbg==
X-Gm-Message-State: AAQBX9dDqzsMISlXe/whzIchEeYjRajZPs0DJSTFspnD6IvdRv5cHgvL
        wRnAfl3ipxDnkkFVKm91UdNV8yN/1sTgk9PkIbg5BprO6HFPrz42+YYknAgZD19v/VHw6ne93rI
        f3YVqpjOgeuZz
X-Received: by 2002:a05:6214:21a4:b0:56f:d8:dbb4 with SMTP id t4-20020a05621421a400b0056f00d8dbb4mr1943711qvc.2.1680589399745;
        Mon, 03 Apr 2023 23:23:19 -0700 (PDT)
X-Google-Smtp-Source: AKy350azFYLEwDlMSgwwh8I9rqVxvJqaLdUyzLHmRZw0ztFX9U2/HybsX+OTx3X6c8SwpCBJw9wTYg==
X-Received: by 2002:a05:6214:21a4:b0:56f:d8:dbb4 with SMTP id t4-20020a05621421a400b0056f00d8dbb4mr1943700qvc.2.1680589399506;
        Mon, 03 Apr 2023 23:23:19 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ny4-20020a056214398400b005e37909a7fcsm2022912qvb.13.2023.04.03.23.23.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Apr 2023 23:23:18 -0700 (PDT)
Message-ID: <968a026e-066e-deea-d02f-f64133295ff1@redhat.com>
Date:   Tue, 4 Apr 2023 08:23:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH 0/6] arm: pmu: Fix random failures of
 pmu-chain-promotion
Content-Language: en-US
To:     eric.auger.pro@gmail.com, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, andrew.jones@linux.dev, maz@kernel.org,
        will@kernel.org, oliver.upton@linux.dev, ricarkol@google.com,
        reijiw@google.com, alexandru.elisei@arm.com
References: <20230315110725.1215523-1-eric.auger@redhat.com>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20230315110725.1215523-1-eric.auger@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 3/15/23 12:07, Eric Auger wrote:
> On some HW (ThunderXv2), some random failures of
> pmu-chain-promotion test can be observed.
>
> pmu-chain-promotion is composed of several subtests
> which run 2 mem_access loops. The initial value of
> the counter is set so that no overflow is expected on
> the first loop run and overflow is expected on the second.
> However it is observed that sometimes we get an overflow
> on the first run. It looks related to some variability of
> the mem_acess count. This variability is observed on all
> HW I have access to, with different span though. On
> ThunderX2 HW it looks the margin that is currently taken
> is too small and we regularly hit failure.
>
> although the first goal of this series is to increase
> the count/margin used in those tests, it also attempts
> to improve the pmu-chain-promotion logs, add some barriers
> in the mem-access loop, clarify the chain counter
> enable/disable sequence.
>
> A new 'pmu-memaccess-reliability' is also introduced to
> detect issues with MEM_ACCESS event variability and make
> the debug easier.
>
> Obviously one can wonder if this variability is something normal
> and does not hide any other bug. I hope this series will raise
> additional discussions about this.
>
> https://github.com/eauger/kut/tree/pmu-chain-promotion-fixes-v1

Gentle ping.

Thanks

Eric
>
> Eric Auger (6):
>   arm: pmu: pmu-chain-promotion: Improve debug messages
>   arm: pmu: pmu-chain-promotion: Introduce defines for count and margin
>     values
>   arm: pmu: Add extra DSB barriers in the mem_access loop
>   arm: pmu: Fix chain counter enable/disable sequences
>   arm: pmu: Add pmu-memaccess-reliability test
>   arm: pmu-chain-promotion: Increase the count and margin values
>
>  arm/pmu.c         | 189 +++++++++++++++++++++++++++++++++-------------
>  arm/unittests.cfg |   6 ++
>  2 files changed, 141 insertions(+), 54 deletions(-)
>

