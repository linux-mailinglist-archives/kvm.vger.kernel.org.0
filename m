Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB8B95076B4
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 19:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353999AbiDSRng (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 13:43:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241756AbiDSRnc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 13:43:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 20E8B21266
        for <kvm@vger.kernel.org>; Tue, 19 Apr 2022 10:40:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650390048;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Qnonzc6fh8TJnpE7gaNyUxgdtOHFsR6ybsN1q248jMI=;
        b=X6Tvn6VnIaIFtuISjzE1K2ziDE77IHnNMLZLErc7XmPp73ZFd5uEa1is/92pwr6xOM+Hse
        GwzUzXk84QmGjR5w9fR5FhFMDqU3JVz9ANzFJqj5iUCzYMLCZ+vtkcq0imuCCzqgsSy9zh
        hBuscUe8WufueiRp9pmqnuRmMtdnevE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-122-FN0BlGJdOL2Qj3VL31ZM9w-1; Tue, 19 Apr 2022 13:40:46 -0400
X-MC-Unique: FN0BlGJdOL2Qj3VL31ZM9w-1
Received: by mail-wm1-f71.google.com with SMTP id m125-20020a1c2683000000b00391893a2febso6526391wmm.4
        for <kvm@vger.kernel.org>; Tue, 19 Apr 2022 10:40:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Qnonzc6fh8TJnpE7gaNyUxgdtOHFsR6ybsN1q248jMI=;
        b=Dd05GJztj7FvzlGRKEIVUhTOag02lRwdhDkPZhwEHU5DHXjgmTZjY9M5riflX/Ze/I
         rX8cplq1hNaFtoDuutnNLR3DxlBY/3OGF2uhAzTkEQETRQIfy7D9GeMuGObJblLUphVI
         L0+rzPeMFljCdujo8YM1CrrMcwn4knBBwpUjPRc9OiVKM47L9xd2G52Bo4fSijAMQ6Db
         66A7ukHcLHDMhSntVSZw37Unc9d9I1S2RxhVIWPFpVSNyMw0QpytD6bCHJvH7FNrRNNH
         DnDKLnkIt7h90x38oNm6iDqlzwwIuCdGDGxGBJ4jrLTNqXQ5Vw+60kUgRoyGE/rFaq5g
         uzng==
X-Gm-Message-State: AOAM5335hYCRj7ax9LnRsXNtG3STSjwik/aLRSmyEs8ApwsDK2nonmdL
        Uw9BXPYcNgudZXF2aTbQ6DOUP7sMBngaV/bnrvsRWgKkfL8oz9EbgDZRN7WZeeC/28OO0Y0wZzm
        f77pZGfvSJQxf
X-Received: by 2002:a7b:cc17:0:b0:38d:af7:3848 with SMTP id f23-20020a7bcc17000000b0038d0af73848mr17231886wmh.41.1650390045844;
        Tue, 19 Apr 2022 10:40:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxxUPHblxgqkkDRtIk+7piT1JWk/8UYZYpIWMN0Md1sGmtegk1Go/5gMBC2w/pEAh6nPUzCZA==
X-Received: by 2002:a7b:cc17:0:b0:38d:af7:3848 with SMTP id f23-20020a7bcc17000000b0038d0af73848mr17231868wmh.41.1650390045650;
        Tue, 19 Apr 2022 10:40:45 -0700 (PDT)
Received: from [192.168.8.102] (dynamic-046-114-170-162.46.114.pool.telefonica.de. [46.114.170.162])
        by smtp.gmail.com with ESMTPSA id 20-20020a05600c22d400b0038c8dbdc1a3sm16472044wmg.38.2022.04.19.10.40.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Apr 2022 10:40:45 -0700 (PDT)
Message-ID: <07903c7d-5afc-ce95-0f51-3c643eab8b37@redhat.com>
Date:   Tue, 19 Apr 2022 19:40:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 1/4] KVM: s390: selftests: Use TAP interface in the memop
 test
Content-Language: en-US
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>, kvm@vger.kernel.org,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Hildenbrand <david@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shuah Khan <shuah@kernel.org>
References: <20220414105322.577439-1-thuth@redhat.com>
 <20220414105322.577439-2-thuth@redhat.com>
 <3c627856-5e66-3cbe-adab-464ae573e23d@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <3c627856-5e66-3cbe-adab-464ae573e23d@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/04/2022 14.48, Janis Schoetterl-Glausch wrote:
> On 4/14/22 12:53, Thomas Huth wrote:
>> The memop test currently does not have any output (unless one of the
>> TEST_ASSERT statement fails), so it's hard to say for a user whether
>> a certain new sub-test has been included in the binary or not. Let's
>> make this a little bit more user-friendly and include some TAP output
>> via the kselftests.h interface.
>>
>> Signed-off-by: Thomas Huth <thuth@redhat.com>
>> ---
>>   tools/testing/selftests/kvm/s390x/memop.c | 90 ++++++++++++++++++-----
>>   1 file changed, 73 insertions(+), 17 deletions(-)
>>
>> diff --git a/tools/testing/selftests/kvm/s390x/memop.c b/tools/testing/selftests/kvm/s390x/memop.c
>> index b04c2c1b3c30..a2783d9afcac 100644
>> --- a/tools/testing/selftests/kvm/s390x/memop.c
>> +++ b/tools/testing/selftests/kvm/s390x/memop.c
>> @@ -12,6 +12,7 @@
>>   
>>   #include "test_util.h"
>>   #include "kvm_util.h"
>> +#include "kselftest.h"
>>   
>>   enum mop_target {
>>   	LOGICAL,
>> @@ -648,33 +649,88 @@ static void test_errors(void)
>>   	kvm_vm_free(t.kvm_vm);
>>   }
>>   
>> +struct testdef {
>> +	const char *name;
>> +	void (*test)(void);
>> +	bool needs_extension;
> 
> Please make this numeric. You could also rename it to required_extension or similar.
[...]
>> +
>> +	for (idx = 0; idx < ARRAY_SIZE(testlist); idx++) {
>> +		if (!testlist[idx].needs_extension || extension_cap) {
> 
> Then check here that extension_cap >= the required extension.
> This way the test can easily be adapted in case of future extensions.

Not sure whether a ">=" will really be safe, since a future extension does 
not necessarily assert that previous extensions are available at the same time.

But I can still turn the bool into a numeric to make it a little bit more 
flexible for future use.

  Thomas

