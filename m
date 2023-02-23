Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E5A46A1076
	for <lists+kvm@lfdr.de>; Thu, 23 Feb 2023 20:19:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbjBWTTB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Feb 2023 14:19:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbjBWTS7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Feb 2023 14:18:59 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DBB26010F
        for <kvm@vger.kernel.org>; Thu, 23 Feb 2023 11:17:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677179802;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6KU3Ox2Ew/Jsk/EiHqSrTUkdmsrVL1tultoFc9/FEnc=;
        b=LX3zs5H4JOmBKVuXhj+jYxTd9gp067GWYvoRDuh0XqEykMwPvLeK41l0ElXrIRHKUEGD8D
        7y9+g61fCt0vOISBhqsbHQcmDCO4SgCLyM6ZTI7qvTpjirt6v8RwrjOVF1OnAg0Oi9C1kj
        LYvusSZ3KzxC0Hn4PUJKnyq9ORx+l1Y=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-56-V7L6GyaxNRSeq1CgiUf0FA-1; Thu, 23 Feb 2023 14:16:40 -0500
X-MC-Unique: V7L6GyaxNRSeq1CgiUf0FA-1
Received: by mail-wm1-f71.google.com with SMTP id e17-20020a05600c219100b003e21fa60ec1so91497wme.2
        for <kvm@vger.kernel.org>; Thu, 23 Feb 2023 11:16:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6KU3Ox2Ew/Jsk/EiHqSrTUkdmsrVL1tultoFc9/FEnc=;
        b=aUZsXuCshxVrxAWZ4nZIOi6ebItwxMsIw9ef62FGm2WU4U+yt9zqjqw4WHARKzxijs
         WQuion4IB0ViBjiU07B6IXgs1gkTSAS14TS/CaI3LC0mmqGjpRlviwd8CTR9PFnxl+Ho
         7XHNS8nVKIRWPWDyRdKR+4My0i7eF37Q3OSUWm7iZrsCjZOApMvo6syAV70w7tAB++kZ
         XVYDlilFXZl9/NHaHlhAevL/7Kwn+MttBoB+GYsZkWS/qYI6tzZS3d3Y46ThC/SgaVFe
         hWED4yTyzGv4PWQBCd0hEpDSIypYLuZ0pfxmJH/l5lBfOIVGT2bCFWRdohQW3u+0VmuX
         BJmA==
X-Gm-Message-State: AO0yUKW1agIQ2JWXgSwTHYNpPOk8rcTnKBCLwCzZFQn/HBdeLqtRh+ct
        YTDN9jxWufwjEvfbO+pbgdchUK3TXME5jd1h9fCax11JLkGIrhfAkXLM2DGmIl768Zg2MPOPbBv
        mCdPqbHpXj1XG
X-Received: by 2002:a05:600c:1da5:b0:3e2:1dac:b071 with SMTP id p37-20020a05600c1da500b003e21dacb071mr11790413wms.13.1677179799896;
        Thu, 23 Feb 2023 11:16:39 -0800 (PST)
X-Google-Smtp-Source: AK7set9+rCcRcA2Owu9q2As55Ch182UG72EUT9DZuObj8BilvSgnJCjNXKMZATz95zng1AvEyGI2Jw==
X-Received: by 2002:a05:600c:1da5:b0:3e2:1dac:b071 with SMTP id p37-20020a05600c1da500b003e21dacb071mr11790403wms.13.1677179799635;
        Thu, 23 Feb 2023 11:16:39 -0800 (PST)
Received: from [192.168.8.104] (tmo-100-40.customers.d1-online.com. [80.187.100.40])
        by smtp.gmail.com with ESMTPSA id t4-20020adff044000000b002c5694aef92sm10903913wro.21.2023.02.23.11.16.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Feb 2023 11:16:38 -0800 (PST)
Message-ID: <8ddf067b-4c0e-7c4c-6820-c76e874400ba@redhat.com>
Date:   Thu, 23 Feb 2023 20:16:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [kvm-unit-tests PATCH v1] s390x: Add tests for execute-type
 instructions
Content-Language: en-US
To:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20230222114742.1208584-1-nsg@linux.ibm.com>
 <167713875438.6442.2406479682969262260@t14-nrb.local>
 <e8d21eb5afde7fd9114e225692222fa8902c4e7a.camel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <e8d21eb5afde7fd9114e225692222fa8902c4e7a.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/02/2023 10.50, Nina Schoetterl-Glausch wrote:
> On Thu, 2023-02-23 at 08:52 +0100, Nico Boehr wrote:
>> Quoting Nina Schoetterl-Glausch (2023-02-22 12:47:42)
>>> Test the instruction address used by targets of an execute instruction.
>>> When the target instruction calculates a relative address, the result is
>>> relative to the target instruction, not the execute instruction.
>>>
>>> Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
>> [...]
>>> diff --git a/s390x/Makefile b/s390x/Makefile
>>> index 97a61611..6cf8018b 100644
>>> --- a/s390x/Makefile
>>> +++ b/s390x/Makefile
>>> @@ -39,6 +39,7 @@ tests += $(TEST_DIR)/panic-loop-extint.elf
>>>   tests += $(TEST_DIR)/panic-loop-pgm.elf
>>>   tests += $(TEST_DIR)/migration-sck.elf
>>>   tests += $(TEST_DIR)/exittime.elf
>>> +tests += $(TEST_DIR)/ex.elf
>>
>> You didn't add your new test to unittests.cfg, is this intentional?
> 
> Nope, I just forgot.
> 
> @Thomas, I guess I should also add it to s390x-kvm in .gitlab-ci.yml,
> since the test passes on KVM?

Yes, please (unless your test requires the latest and greatest shiny 
upstream kernel - we don't have that on the machine available yet).

  Thomas

