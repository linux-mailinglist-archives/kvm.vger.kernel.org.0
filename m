Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92995640391
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 10:43:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232854AbiLBJnx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 04:43:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232526AbiLBJnv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 04:43:51 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED9A426499
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 01:42:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669974169;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+wLl4vtYCGhwohXxITZQq5I6CY9K6KjTKaeRzYrEEpY=;
        b=GVyMkVrxHuH6ntzuBs4aff9tewyssz9Vp2M/M4P1m+LoXlEEKm8kH2GbKgdYtd2OJeF+vE
        RyWKS65gp9qEqlF88IMqgTPxdZZiUdCeYdKGVDv6WMLCE2WO1AivtqZxglgo1HaZW+Wknk
        BK4lxk/HK8Xti52QOHJO/Z22nhzgWSQ=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-111-uzTlSB3_Px20wqM9cYwOeQ-1; Fri, 02 Dec 2022 04:42:48 -0500
X-MC-Unique: uzTlSB3_Px20wqM9cYwOeQ-1
Received: by mail-wr1-f72.google.com with SMTP id r17-20020adfb1d1000000b002421ae7fd46so937733wra.10
        for <kvm@vger.kernel.org>; Fri, 02 Dec 2022 01:42:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+wLl4vtYCGhwohXxITZQq5I6CY9K6KjTKaeRzYrEEpY=;
        b=4LcVU/+D72a4XDWUXLKHK6z3oWstS9/IDAIx7Ka4zuWIY1f4M015U50Ye3C0LOzPBZ
         lk6vsGTsybUfyKdYz2Z7o16hTmoeqObTjdRtxZ65JfWypygw/tl5ykjfOPL2ZC1VTjId
         L4WXlfe8EYq33LGlNqAXlOn9B+2MqczZBpVtFfBBOQ96UbFRyw9qET1R65xbPSQBf6d2
         WW33wQbW/f9djMekmgjfv+Rt9sqp4reOidx+htC8y1Mbu/kdmhP+k8S2sVS3IWOS71qN
         gFfL51LZwLMBkyg8qAiNqznqkwBEf60PZ+S823mYDXhA5NYTyoGJ6Vm1GcDgcUjiZqhU
         BgjA==
X-Gm-Message-State: ANoB5plD+WYVU8NhBrPpXlgg1/+xRst9uCILD3HoW/6zx83R3bU9uxOO
        GzT5loKIfwfeOJzSLDEOcJKKrEP/EAL/hRL1t4D2Cg7UPObCqWWsx+z5jHaQGN/UA/tC7hp6P39
        rODGXIjzUriV0
X-Received: by 2002:a5d:6947:0:b0:242:17a5:ee80 with SMTP id r7-20020a5d6947000000b0024217a5ee80mr14530216wrw.628.1669974166727;
        Fri, 02 Dec 2022 01:42:46 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6UdJV/mDJpmRG4muvnS79yLQAxAfJtB+81SwOHAcWOxkps8MZJhxfA5YRNqhJp3giA0N1wyw==
X-Received: by 2002:a5d:6947:0:b0:242:17a5:ee80 with SMTP id r7-20020a5d6947000000b0024217a5ee80mr14530202wrw.628.1669974166476;
        Fri, 02 Dec 2022 01:42:46 -0800 (PST)
Received: from [192.168.1.130] (205.pool92-176-231.dynamic.orange.es. [92.176.231.205])
        by smtp.gmail.com with ESMTPSA id z5-20020adff745000000b002383fc96509sm6488257wrp.47.2022.12.02.01.42.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Dec 2022 01:42:46 -0800 (PST)
Message-ID: <3805ed81-2315-4eca-3ea6-b391c1659cc7@redhat.com>
Date:   Fri, 2 Dec 2022 10:42:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH 1/2] KVM: Mark KVM_SET_MEMORY_REGION and
 KVM_SET_MEMORY_ALIAS as obsoleted
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org,
        Sergio Lopez Pascual <slp@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
References: <20221119085632.1018994-1-javierm@redhat.com>
 <Y4T+SY9SZIRFBdBM@google.com>
 <a6a59b75-2ee2-ab9b-3038-2590df17d031@redhat.com>
Content-Language: en-US
From:   Javier Martinez Canillas <javierm@redhat.com>
In-Reply-To: <a6a59b75-2ee2-ab9b-3038-2590df17d031@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Sean and Paolo,

Thanks for your feedback.

On 11/30/22 15:28, Paolo Bonzini wrote:
> On 11/28/22 19:30, Sean Christopherson wrote:
>> E.g. KVM_{CREATE,GET,SET}_PIT are good examples of obsolete ioctls; they've been
>> supplanted by newer variants, but KVM still supports the old ones too.
>>
>> Alternatively (to marking them deprecated), can we completely remove all references
>> to VM_SET_MEMORY_REGION and KVM_SET_MEMORY_ALIAS?  The cascading updates in api.rst
>> will be painful, but it's one-time pain.
> 
> Yes, we should.
>

Ok. I'll do that and post a v2 then.
 
> Paolo
> 

-- 
Best regards,

Javier Martinez Canillas
Core Platforms
Red Hat

