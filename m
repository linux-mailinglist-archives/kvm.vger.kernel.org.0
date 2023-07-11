Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 810A374E94E
	for <lists+kvm@lfdr.de>; Tue, 11 Jul 2023 10:44:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231146AbjGKIoQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jul 2023 04:44:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230308AbjGKIoO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jul 2023 04:44:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FE11E7A
        for <kvm@vger.kernel.org>; Tue, 11 Jul 2023 01:43:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689065009;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uUu4PL9YIqWcJDoz1iYa6iEBpdujMvrErvf1ceFhKC8=;
        b=Xfq+ZxpUQ42CrNliZay0PfsmYR2IoN9SdhmAdRit4xJrCRBh6FPppydXnIbf72SrzdqSow
        nH9zt4yAvvaHxn6Sq9F57dJ9AAAI+KkeA/wJscS715OwJYgYa6KjW4T+NajTgAZza5ivNR
        1/vxOWSL2pk8oQHPw8sduUWsIvM7NUg=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-503-1rVhUlLZNrmuH7nnmiHZkQ-1; Tue, 11 Jul 2023 04:43:28 -0400
X-MC-Unique: 1rVhUlLZNrmuH7nnmiHZkQ-1
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-635325b87c9so59566186d6.1
        for <kvm@vger.kernel.org>; Tue, 11 Jul 2023 01:43:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689065007; x=1691657007;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uUu4PL9YIqWcJDoz1iYa6iEBpdujMvrErvf1ceFhKC8=;
        b=NuGEIye9QD2/kCvuo9uWJdBeZU3QQcNvfqR6EjhzjaHzbapxX6erLrHfdRJiFSNhjD
         awxPeP0QynRNst7kaq0Fyb14s6KubAvWFcjcUF6X0MV7HOsMF3Vl4+MfOeLklDgG141n
         mIduJP8K2f02iU8jklxErjEbweRUAP+otz+l/POa9aePsRBXEMzzeaLoSdhC6HzFDKxQ
         bxs4brO83JCG+hGhMgQjxTL7FofyiFJxYBhDRLkDKykKzHdcSEZvPAgM6X9j4duIpwUG
         R1d0HKgzJ9MSAvA7wIZcitBjph63PEfZUr430QjbS4/5Ad5b/6HzkkDW3+S3qbwqWGxm
         1hng==
X-Gm-Message-State: ABy/qLa5VnhgTkdT+6dz1GfAdd0769EKToGZmfPfRnwhVehiRBlq4QjI
        vM+mbAyRfq7UDIKWrV3JzciDOYBRQQIkZPWZkH6LiyAGNLGX6e1l/e2YcMgKyFsEehsVtnm66Ol
        ubXTN0FPv9u/L
X-Received: by 2002:a0c:e404:0:b0:631:f9ad:1d46 with SMTP id o4-20020a0ce404000000b00631f9ad1d46mr14182369qvl.47.1689065007682;
        Tue, 11 Jul 2023 01:43:27 -0700 (PDT)
X-Google-Smtp-Source: APBJJlGj7Vd/vQTScrAG5ij63JKspRZF0xJa4kLp0VBmiMtFSOODfIYmuhY6YAYY2/wK7Wqh2pD3+g==
X-Received: by 2002:a0c:e404:0:b0:631:f9ad:1d46 with SMTP id o4-20020a0ce404000000b00631f9ad1d46mr14182363qvl.47.1689065007480;
        Tue, 11 Jul 2023 01:43:27 -0700 (PDT)
Received: from [10.33.192.205] (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id h7-20020a37c447000000b0076745f352adsm757917qkm.59.2023.07.11.01.43.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Jul 2023 01:43:27 -0700 (PDT)
Message-ID: <6c690eb9-06b1-a5e8-4875-e0d83f8d1ce7@redhat.com>
Date:   Tue, 11 Jul 2023 10:43:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [kvm-unit-tests PATCH v10 2/2] s390x: topology: Checking
 Configuration Topology Information
To:     Nico Boehr <nrb@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, kvm@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, nsg@linux.ibm.com
References: <20230627082155.6375-1-pmorel@linux.ibm.com>
 <20230627082155.6375-3-pmorel@linux.ibm.com>
 <ffc48a06-52b2-fc65-e12d-58603d13b3e6@redhat.com>
 <168897816265.42553.541677592228445286@t14-nrb>
 <d52e4c34-55f0-56a5-1543-52fefb39e2a6@redhat.com>
 <168906286416.9488.17612605115280167157@t14-nrb>
Content-Language: en-US
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <168906286416.9488.17612605115280167157@t14-nrb>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/07/2023 10.07, Nico Boehr wrote:
> Quoting Thomas Huth (2023-07-10 16:38:22)
>> On 10/07/2023 10.36, Nico Boehr wrote:
>>> Quoting Thomas Huth (2023-07-06 12:48:50)
>>> [...]
>>>> Does this patch series depend on some other patches that are not upstream
>>>> yet? I just tried to run the test, but I'm only getting:
>>>>
>>>>     lib/s390x/sclp.c:122: assert failed: read_info
>>>>
>>>> Any ideas what could be wrong?
>>>
>>> Yep, as you guessed this depends on:
>>> Fixing infinite loop on SCLP READ SCP INFO error
>>> https://lore.kernel.org/all/20230601164537.31769-1-pmorel@linux.ibm.com/
>>
>> Ok, that fixes the assertion, but now I get a test failure:
>>
>> ABORT: READ_SCP_INFO failed
>>
>> What else could I be missing?
> 
> Argh, I forgot that you need this fixup to the patch:
> https://lore.kernel.org/all/269afffb-2d56-3b2f-9d83-485d0d29fab5@linux.ibm.com/
> 
> If that doesn't work, let me know, so I can try and reproduce it here.

Thank you very much, removing that line fixed the problem, indeed. Both 
topology tests are passing now on my z15 LPAR.

Tested-by: Thomas Huth <thuth@redhat.com>


