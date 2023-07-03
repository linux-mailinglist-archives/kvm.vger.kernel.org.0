Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13E887456FB
	for <lists+kvm@lfdr.de>; Mon,  3 Jul 2023 10:09:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230483AbjGCIJp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jul 2023 04:09:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230503AbjGCIJo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jul 2023 04:09:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B52C83
        for <kvm@vger.kernel.org>; Mon,  3 Jul 2023 01:08:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688371735;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FXPKfZsTXzahD7ycQScFS2q+Sn+AkPPRgq7/KVL7l/U=;
        b=g2UJrTGB+D/M8M9cCVZfZMdASRyfrPyL2w3hcjwNmxxmI57uGW7LKm2aYcL3dJlnW+ItFe
        nUVwHZFNHQ69pi7b4+5IoAIxKcpJVK9D6uVorYvbqbpU0TdG4z6slVzJRqk9Oukf0KEb1y
        v41x4n+tVa3PdtuqWWgFj0aP7skA4+c=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-102--j7d9tGDOwmu92YMFs6IFg-1; Mon, 03 Jul 2023 04:08:54 -0400
X-MC-Unique: -j7d9tGDOwmu92YMFs6IFg-1
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-635eeb952b8so47399116d6.3
        for <kvm@vger.kernel.org>; Mon, 03 Jul 2023 01:08:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688371734; x=1690963734;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FXPKfZsTXzahD7ycQScFS2q+Sn+AkPPRgq7/KVL7l/U=;
        b=JtH3JozWNBkkbcj2jFM7v0FkKuqEspLRu5fOZ6koSnIH4BKhJGOVqg4Tce5zTbCNsX
         RXqCCbLR+NYUe/m1sIHYotyupktCmOScyAQUyVzK30U4YOjTwF8t3oju5uyGvMwuFKrA
         WoxLXCC9uPxyDHt+ldiRrbpNxxc6o0dWe8239zJK/GGaH5jsU9n3TMhfbvvYIcaPZeBg
         eRX97c8HRctu24zmUwtJn83F6mxgi3hOVw8gnARHTWJZbqA2y6ML7XXMFkSvwaYiEzvm
         hoc40m3FXcbZJdHe3AiBs1hoivnyEiky14CsQS65nAxInsjQVkm/8RzLvGv1FQE4d5Al
         TL7w==
X-Gm-Message-State: ABy/qLbM+86s/O7YP8GvEjvcn1fB5JPC2SLO8jbBX3ALGcmcRZS9wzXB
        m8O9IVEkftbOtyRyJac0RURfzQQOi8ezagjkG+g646dhIVRFXgjmArTTe2KfA3qLzCc8fplqrU4
        3oeLI3UKPQRPL
X-Received: by 2002:a05:6214:c3:b0:635:de52:8385 with SMTP id f3-20020a05621400c300b00635de528385mr8486494qvs.65.1688371733896;
        Mon, 03 Jul 2023 01:08:53 -0700 (PDT)
X-Google-Smtp-Source: APBJJlGKzp5ZiukExyOrvxJTeHKv24OOZijoaMTKRVV4KAAWAvgblhqLeAZDPyKzp3kaChdmwgOQmg==
X-Received: by 2002:a05:6214:c3:b0:635:de52:8385 with SMTP id f3-20020a05621400c300b00635de528385mr8486485qvs.65.1688371733711;
        Mon, 03 Jul 2023 01:08:53 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id l15-20020ad4444f000000b0062439f05b87sm11201681qvt.45.2023.07.03.01.08.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Jul 2023 01:08:53 -0700 (PDT)
Message-ID: <6b7c593e-d735-93ae-2e5c-99d87b4604cc@redhat.com>
Date:   Mon, 3 Jul 2023 10:08:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v3 5/6] arm: pmu: Add
 pmu-mem-access-reliability test
Content-Language: en-US
To:     Andrew Jones <andrew.jones@linux.dev>
Cc:     eric.auger.pro@gmail.com, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, maz@kernel.org, will@kernel.org,
        oliver.upton@linux.dev, ricarkol@google.com, reijiw@google.com,
        alexandru.elisei@arm.com, mark.rutland@arm.com
References: <20230619200401.1963751-1-eric.auger@redhat.com>
 <20230619200401.1963751-6-eric.auger@redhat.com>
 <20230701-daff0cec48c2329abd7ede9f@orel>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20230701-daff0cec48c2329abd7ede9f@orel>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Drew,

On 7/1/23 13:36, Andrew Jones wrote:
> On Mon, Jun 19, 2023 at 10:04:00PM +0200, Eric Auger wrote:
> ...
>> @@ -1201,6 +1257,9 @@ int main(int argc, char *argv[])
>>  	} else if (strcmp(argv[1], "pmu-basic-event-count") == 0) {
>>  		run_event_test(argv[1], test_basic_event_count, false);
>>  		run_event_test(argv[1], test_basic_event_count, true);
>> +	} else if (strcmp(argv[1], "pmu-mem-access-reliability") == 0) {
>> +		run_event_test(argv[1], test_mem_access_reliability, false);
>> +		run_event_test(argv[1], test_mem_access_reliability, true);
> This breaks compilation for arm since this patch is missing the stub.
> I've added it.

sorry for the oversight and thanks for adding it ;-)

Eric
>
> Thanks,
> drew
>

