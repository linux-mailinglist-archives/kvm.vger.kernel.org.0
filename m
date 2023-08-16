Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6956277D8F0
	for <lists+kvm@lfdr.de>; Wed, 16 Aug 2023 05:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241526AbjHPDTl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 23:19:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241525AbjHPDTZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 23:19:25 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FA901FCA;
        Tue, 15 Aug 2023 20:19:24 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id d2e1a72fcca58-686f1240a22so6005151b3a.0;
        Tue, 15 Aug 2023 20:19:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692155964; x=1692760764;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zx6N9SoWNF/u8V+Sw75Ge9zPmSloa2YLfzZtVAyqGyY=;
        b=s3C8ACJj/lDPCCddh1QoxVHfewVO7396V2p0GBnixVGYMJKuEn8LI1f58ij29dTrPT
         aTccs/sE4GUWui4HNce/CCxS3/5UXv/C5xU/IFQ6gHV+yUxcP2D9vM3mdXtwDuLZJR76
         aeIIrXMhonKMbDxjGvoDN3XN3NYmOVgTiTKtTYcZ7C+mOJN5JoJa/6fgnaqqTgR6PGEU
         F5VeaQLA0AtEtPLQsYlkB8X2tHqquPgrTYXkIFupBNn1b6/DOavYgJ6FfEsCgQQkz0Hl
         AtjFbDDRP9YtWXtX0qb1EZicp1a0WzT2G1KYBJ7UZRWyuDTFqkNtFUqsC3xlGvM8IF+1
         ZyqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692155964; x=1692760764;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zx6N9SoWNF/u8V+Sw75Ge9zPmSloa2YLfzZtVAyqGyY=;
        b=RmTOWSwwSmvkPU/7CjCOc1FV6jdLUGT6Kw3IIRTrvG6IN+rWMHTMLNjs7FWnk0nZfG
         garru9RXDpyODsRDYuaH0v0jqGPJUwzfsSz3wXxAIh0lGaw5qY1MSF7CrG4nuvnZ07Y0
         JyyWEytmeTfdVfrkKQN1CPRA9yUerjCNUQr9yDAU6fy9Ow8xKKi9Rh70db4BgYZ4x+HB
         mj3/pEkcJsoeTGmGNkYEGYtGRFu+aX/BWNZBmqeVXzXVdkN1VWP+eZ6HbGRbYHOTAvd6
         3CCB2Disb/PJKM4QGpupRHerQ5BFAEQq5Tz0oiNmiW/nHbonesJFawFCRJ9FAtpmiyLP
         ldwA==
X-Gm-Message-State: AOJu0Yzogwz++RoeeLM5GCSb4+Z01+JWA6nVIAcfzeJYW4X9yQj7MHi0
        XqWnz2jvmADSByyQuONEj18=
X-Google-Smtp-Source: AGHT+IEsefrY5bIASd4gMz3zA3GYRyya7JFTsszT0s4RlXNEyyyIpIa7AqHk4qYms/LNviBFAwlnpw==
X-Received: by 2002:a05:6a00:22d0:b0:676:ad06:29d7 with SMTP id f16-20020a056a0022d000b00676ad0629d7mr971769pfj.15.1692155964000;
        Tue, 15 Aug 2023 20:19:24 -0700 (PDT)
Received: from localhost.localdomain ([146.112.118.69])
        by smtp.gmail.com with ESMTPSA id m22-20020aa78a16000000b00686f048bb9dsm122891pfa.74.2023.08.15.20.19.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Aug 2023 20:19:23 -0700 (PDT)
Subject: Re: [PATCH v3 4/6] KVM: PPC: Book3s HV: Hold LPIDs in an unsigned
 long
To:     David Laight <David.Laight@ACULAB.COM>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Cc:     "mikey@neuling.org" <mikey@neuling.org>,
        "sbhat@linux.ibm.com" <sbhat@linux.ibm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "amachhiw@linux.vnet.ibm.com" <amachhiw@linux.vnet.ibm.com>,
        "gautam@linux.ibm.com" <gautam@linux.ibm.com>,
        "npiggin@gmail.com" <npiggin@gmail.com>,
        "kvm-ppc@vger.kernel.org" <kvm-ppc@vger.kernel.org>,
        "vaibhav@linux.ibm.com" <vaibhav@linux.ibm.com>,
        "kconsul@linux.vnet.ibm.com" <kconsul@linux.vnet.ibm.com>
References: <20230807014553.1168699-1-jniethe5@gmail.com>
 <20230807014553.1168699-5-jniethe5@gmail.com>
 <014488c6d90446f38154a2f7645aa053@AcuMS.aculab.com>
From:   Jordan Niethe <jniethe5@gmail.com>
Message-ID: <1b187307-596d-392f-45a6-3da2c9aa20d9@gmail.com>
Date:   Wed, 16 Aug 2023 13:19:17 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <014488c6d90446f38154a2f7645aa053@AcuMS.aculab.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 14/8/23 6:15 pm, David Laight wrote:
> From: Jordan Niethe
>> Sent: 07 August 2023 02:46
>>
>> The LPID register is 32 bits long. The host keeps the lpids for each
>> guest in an unsigned word struct kvm_arch. Currently, LPIDs are already
>> limited by mmu_lpid_bits and KVM_MAX_NESTED_GUESTS_SHIFT.
>>
>> The nestedv2 API returns a 64 bit "Guest ID" to be used be the L1 host
>> for each L2 guest. This value is used as an lpid, e.g. it is the
>> parameter used by H_RPT_INVALIDATE. To minimize needless special casing
>> it makes sense to keep this "Guest ID" in struct kvm_arch::lpid.
>>
>> This means that struct kvm_arch::lpid is too small so prepare for this
>> and make it an unsigned long. This is not a problem for the KVM-HV and
>> nestedv1 cases as their lpid values are already limited to valid ranges
>> so in those contexts the lpid can be used as an unsigned word safely as
>> needed.
> 
> Shouldn't it be changed to u64?

This will only be for 64-bit PPC so an unsigned long will always be 64 
bits wide, but I can use a u64 instead.

> 
> 	David
>   
> 
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
> 
