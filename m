Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBB406376C2
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 11:47:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbiKXKri (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 05:47:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbiKXKrg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 05:47:36 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A6DE1609DA
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 02:46:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669286803;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=meOlUg5MwMVHhaGR+idYAm5TqDEXqBJj0zANbpF8wbk=;
        b=SvswAlx1GhLqE1a0gq9TVQKkmYZkJrxG8RttmdB868AwLKR9Ih/ZFMFTTaOOCOC+rstyZV
        /nIqlgpHIgOlTrj1nGfKHcKD9yzZQS/kFQxiFV3F9fAemCRg/vvkst5Y795hXOt5FLZL4j
        lPBBMKkIxIhfN8ovF5aafajRp4hCkC0=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-529-oOuQRCikOdC7LmA7lNFAbA-1; Thu, 24 Nov 2022 05:46:42 -0500
X-MC-Unique: oOuQRCikOdC7LmA7lNFAbA-1
Received: by mail-wr1-f69.google.com with SMTP id u24-20020adfa198000000b00241da98e057so303927wru.22
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 02:46:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=meOlUg5MwMVHhaGR+idYAm5TqDEXqBJj0zANbpF8wbk=;
        b=q1tW1TDvvPBLxKW11nbtaT8q2KpYJzCZqG31GEkwap5RwMsnZ1AT9DszFb+Ai11vlm
         MN4tFQWGWzpsIHFVKD9UQQldx7a4PLDKv77PcLPYdNfLPjXSzHWJH6sfNWBQFrnpxpUA
         dv4FJyX2uOQ86byYeSdiDCGhtI9cC8mLQRDQXNUSCpe5HUFNygYvDhBuNg//mFRXqEV3
         aU3nVnM87Aqtd6eii7+aqK9DojgEmbTQxcUlPTb4ukw4VE+8XPud3O1+L+LnKB7mFYFO
         aDE3zw55wFyQ7q8u6SwJFieSpMi7qp1vT1zaqJgC9/t9/Ijo94Pti/JmhuZmqajnbOwc
         HCDg==
X-Gm-Message-State: ANoB5pnp5gFAdQgRBc2WuKBuSUVex9Ujs4WdI/t5U1zrEv3Ndl/+Npiq
        GqBg6R/37LD5l7IvLB5ifl4YxBhtuEdf/yz2/7N30wTXXZh+0S/svJ1pvTM2KLzz2iZAnlM9n3+
        DQoMf5QGqARdq
X-Received: by 2002:a5d:4ec7:0:b0:241:e27f:840e with SMTP id s7-20020a5d4ec7000000b00241e27f840emr7459988wrv.690.1669286801107;
        Thu, 24 Nov 2022 02:46:41 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5pwj5K0xvKVmdTQVnmmXoBI1L5Ykv5hwXvwBuBFvXNl68vB2n20Hl/zZh/FDl0FMsQUPjmcQ==
X-Received: by 2002:a5d:4ec7:0:b0:241:e27f:840e with SMTP id s7-20020a5d4ec7000000b00241e27f840emr7459977wrv.690.1669286800876;
        Thu, 24 Nov 2022 02:46:40 -0800 (PST)
Received: from [192.168.0.5] (ip-109-43-177-190.web.vodafone.de. [109.43.177.190])
        by smtp.gmail.com with ESMTPSA id n8-20020a05600c4f8800b003cfd64b6be1sm6445455wmq.27.2022.11.24.02.46.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Nov 2022 02:46:40 -0800 (PST)
Message-ID: <ef6d7ca6-e896-b554-6a30-05113114713d@redhat.com>
Date:   Thu, 24 Nov 2022 11:46:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH] KVM: s390: vsie: Fix the initialization of the epoch
 extension (epdx) field
Content-Language: en-US
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        "Collin L. Walling" <walling@linux.ibm.com>,
        Jason J Herne <jjherne@linux.ibm.com>
References: <20221123090833.292938-1-thuth@redhat.com>
 <4d46020f-f33a-474c-b791-be11c2ce2aa6@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <4d46020f-f33a-474c-b791-be11c2ce2aa6@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/11/2022 11.27, Janosch Frank wrote:
> On 11/23/22 10:08, Thomas Huth wrote:
>> We recently experienced some weird huge time jumps in nested guests when
>> rebooting them in certain cases. After adding some debug code to the epoch
>> handling in vsie.c (thanks to David Hildenbrand for the idea!), it was
>> obvious that the "epdx" field (the multi-epoch extension) did not get set
>> to 0xff in case the "epoch" field was negative.
>> Seems like the code misses to copy the value from the epdx field from
>> the guest to the shadow control block. By doing so, the weird time
>> jumps are gone in our scenarios.
>>
>> Link: https://bugzilla.redhat.com/show_bug.cgi?id=2140899
>> Fixes: 8fa1696ea781 ("KVM: s390: Multiple Epoch Facility support")
>> Signed-off-by: Thomas Huth <thuth@redhat.com>
> 
> Could you please add a test for this to the KVM unit tests?
> I'd guess you might already have some code for it from your debugging sessions.

I don't have some test code for this yet - I was only testing with the 
scenario that is described in the bugzilla ticket. But sure, I can have a 
try to come up with a k-u-t test.

  Thomas

