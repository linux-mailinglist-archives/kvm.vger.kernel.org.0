Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42DEC5703FC
	for <lists+kvm@lfdr.de>; Mon, 11 Jul 2022 15:14:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbiGKNOR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 09:14:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230245AbiGKNOO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 09:14:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0A91E3DF24
        for <kvm@vger.kernel.org>; Mon, 11 Jul 2022 06:14:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657545250;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3lSHKhJUTpxkQhTz3CQGyimwBBwQzPjTROcROGQGDTM=;
        b=GZn+tV8SFveALG2TaGGgk9NluMftEh+nXFe09YKEovt1bUP56JETncgr6rFpTQZAFzkqJQ
        5MP9fJ+YKxyRTHBXWxIB970ctb78p21V9h+u7g8V65LR9bWTpSYlkEPoyjNY42/qI214F9
        QZguus3uV8aDgeot0kQkYoN0fwBtvpM=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-669-Jyyr0LKtOLWNf53qL9s5BQ-1; Mon, 11 Jul 2022 09:14:09 -0400
X-MC-Unique: Jyyr0LKtOLWNf53qL9s5BQ-1
Received: by mail-wm1-f72.google.com with SMTP id c187-20020a1c35c4000000b003a19b3b9e6cso5202568wma.5
        for <kvm@vger.kernel.org>; Mon, 11 Jul 2022 06:14:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=3lSHKhJUTpxkQhTz3CQGyimwBBwQzPjTROcROGQGDTM=;
        b=KXN33oKwCvh89fGFAKiQtVDlE7Ycn12O3deb4Msq7sJNZuTkot+1vTeGHYDD426ugn
         ZfWmBmJzYeeqQ//3WfJf+plwbojbcc2I7xRo7wDSPDvAixEsQ8yIil4fbJa3JAXlq3ve
         m7unNJ8BP5WIxQNRNV4t8orUpQCafTNMAoOtz+I68OkihDlVfyQeMBAoZN2sB9/ckx5Z
         c4jTayuS7kW6ZBkecfzofnEWrHVvnc/kZpFL4ZlP5bNXeExFa7vFu9L9YMoX/4kDs+Zz
         CwJkWq08arg7KwoHNQ0EgzQZTABWi4nQv5SFXjM/FmDtQszAUrSc5glJZwG/q6iNleJz
         2PMg==
X-Gm-Message-State: AJIora8E/1l7gb62rf9dp9+hU5q61QMBbHAMihTheC64itbKYdncQP1n
        CY/scDTLHD/UVEiXszTYs1W2FR8MQwgtkGOdcSxJHQmfge1XTiH9/6gYxB88vdJm3tVVUYEvA/W
        +COrwmjNCjLFZ
X-Received: by 2002:a7b:ce01:0:b0:3a2:e106:f648 with SMTP id m1-20020a7bce01000000b003a2e106f648mr13581885wmc.195.1657545248227;
        Mon, 11 Jul 2022 06:14:08 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1u42Vwv+W/GurLzVnna/GdAJjG2OjksPanQGEqtzBCZFpQGTp0Stfwi/WHS0PtPdy13M5KOIQ==
X-Received: by 2002:a7b:ce01:0:b0:3a2:e106:f648 with SMTP id m1-20020a7bce01000000b003a2e106f648mr13581850wmc.195.1657545248010;
        Mon, 11 Jul 2022 06:14:08 -0700 (PDT)
Received: from [192.168.0.5] (ip-109-43-177-23.web.vodafone.de. [109.43.177.23])
        by smtp.gmail.com with ESMTPSA id o16-20020a5d4a90000000b0021d6ac977fasm5811578wrq.69.2022.07.11.06.14.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Jul 2022 06:14:06 -0700 (PDT)
Message-ID: <ec3948ec-ce12-83bc-e8b2-5b73bf542495@redhat.com>
Date:   Mon, 11 Jul 2022 15:14:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 1/1] KVM: s390: Add facility 197 to the white list
Content-Language: en-US
To:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        KVM <kvm@vger.kernel.org>
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>
References: <20220711115108.6494-1-borntraeger@linux.ibm.com>
 <754d4ea2-8a1a-9b09-50c1-f877696b81f2@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <754d4ea2-8a1a-9b09-50c1-f877696b81f2@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/07/2022 15.11, Christian Borntraeger wrote:
> Am 11.07.22 um 13:51 schrieb Christian Borntraeger:
>> z16 also provides facility 197 (The processor-activity-instrumentation
>> extension 1). Lets add it to KVM.
>>
>> Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
>> ---
>>   arch/s390/tools/gen_facilities.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/arch/s390/tools/gen_facilities.c 
>> b/arch/s390/tools/gen_facilities.c
>> index 530dd941d140..cb0aff5c0187 100644
>> --- a/arch/s390/tools/gen_facilities.c
>> +++ b/arch/s390/tools/gen_facilities.c
>> @@ -111,6 +111,7 @@ static struct facility_def facility_defs[] = {
>>               193, /* bear enhancement facility */
>>               194, /* rdp enhancement facility */
>>               196, /* processor activity instrumentation facility */
>> +            197, /* processor activity instrumentation extension 1 */
>>               -1  /* END */
>>           }
>>       },
> 
> Unless there are complaints, I will queue this with "white list" -> "allow 
> list" and "lets" -> "let's".

With those modifications:

Acked-by: Thomas Huth <thuth@redhat.com>

