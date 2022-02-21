Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 789884BDCDD
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 18:43:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345062AbiBUKIV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Feb 2022 05:08:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353590AbiBUKGb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Feb 2022 05:06:31 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 872AC26120
        for <kvm@vger.kernel.org>; Mon, 21 Feb 2022 01:31:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645435887;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=M7GipAFivLru7/FXCZ9Ov73kX45whBG6hrjha1HlyIU=;
        b=TWFVldRaAzNni9Bl3hNupI7fRmdZmY44TycxJ++WYXL+TCVFumoKO1cBgNfEfrWEzJLemY
        D3fFfDtUwVNCwD65LovTS5KLGRUb8o7VjYNX3NWaEWA65gHmELPzzXCX6Wi1uOHBsv7RUl
        IQX/a7CxtSm5cwYk95cBjEGwXyFRoO4=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-212-hG9Ovz7NNnyckqChq22B_g-1; Mon, 21 Feb 2022 04:31:25 -0500
X-MC-Unique: hG9Ovz7NNnyckqChq22B_g-1
Received: by mail-wr1-f71.google.com with SMTP id k20-20020adfc714000000b001e305cd1597so7144133wrg.19
        for <kvm@vger.kernel.org>; Mon, 21 Feb 2022 01:31:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=M7GipAFivLru7/FXCZ9Ov73kX45whBG6hrjha1HlyIU=;
        b=1wa6avuckkaftxvUqAH/LRz3EfoDdoYvyuqf3UIcm+nWfNevhZtUVEj8K3QbAck8yB
         L2hiUjHaQltsEwdnSRsoawjstxRSAnR7+QhjRYznunUzVSyNuV0zno2V3uxSR9oole+t
         dHGPEFHSxwgyB6PlcMrWmOlnfAQEZnxJspBOM9RQOU90//W9j2Cmi0XEIC855emYf2tJ
         vkdmJDcLahZMzEBYq2ceFUY7aaJisI26cX2PeA0jaeLmQMmAvPOs1bY0UAzhdJEhF9/a
         UWIpBe/sPZo9F2Xo3BEHknyxf1iXaip5JhXQ3SxoPUmEpinyKVFa6iHUQQ7gHShWggsS
         bfug==
X-Gm-Message-State: AOAM533dqTPq5C9m0CUWrljklzMGEMxS2EsDJF0955GeIddOeI9VvqhT
        IHFj6/JgHCpNyAwOs0KE0/RemZVzEvfE2kGv068QjEQ2uPWBU7OHIltRSG6pBKCoMtC7FeDH5QC
        RMNgG2sljta90
X-Received: by 2002:a5d:598f:0:b0:1e3:649:e6c3 with SMTP id n15-20020a5d598f000000b001e30649e6c3mr15091393wri.520.1645435884410;
        Mon, 21 Feb 2022 01:31:24 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzHT0HMNxoGY/7w7S9Z2qpMPtCIP1DkecWzMXFUa68IRpPrLRiHR5foft4LM7SrrciDM7n/aw==
X-Received: by 2002:a5d:598f:0:b0:1e3:649:e6c3 with SMTP id n15-20020a5d598f000000b001e30649e6c3mr15091376wri.520.1645435884162;
        Mon, 21 Feb 2022 01:31:24 -0800 (PST)
Received: from [10.33.192.232] (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id h15-20020a05600c350f00b0037d1e31a25csm7094078wmq.26.2022.02.21.01.31.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Feb 2022 01:31:23 -0800 (PST)
Message-ID: <6e5acc94-4459-2385-331f-501d47106a20@redhat.com>
Date:   Mon, 21 Feb 2022 10:31:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] selftests: kvm: Check whether SIDA memop fails for normal
 guests
Content-Language: en-US
To:     Shuah Khan <skhan@linuxfoundation.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220215074824.188440-1-thuth@redhat.com>
 <d576d8f7-980f-3bc6-87ad-5a6ae45609b8@linuxfoundation.org>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <d576d8f7-980f-3bc6-87ad-5a6ae45609b8@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/02/2022 16.25, Shuah Khan wrote:
> On 2/15/22 12:48 AM, Thomas Huth wrote:
>> Commit 2c212e1baedc ("KVM: s390: Return error on SIDA memop on normal
>> guest") fixed the behavior of the SIDA memops for normal guests. It
>> would be nice to have a way to test whether the current kernel has
>> the fix applied or not. Thus add a check to the KVM selftests for
>> these two memops.
>>
>> Signed-off-by: Thomas Huth <thuth@redhat.com>
>> ---
>>   tools/testing/selftests/kvm/s390x/memop.c | 15 +++++++++++++++
>>   1 file changed, 15 insertions(+)
>>
>> diff --git a/tools/testing/selftests/kvm/s390x/memop.c 
>> b/tools/testing/selftests/kvm/s390x/memop.c
>> index 9f49ead380ab..d19c3ffdea3f 100644
>> --- a/tools/testing/selftests/kvm/s390x/memop.c
>> +++ b/tools/testing/selftests/kvm/s390x/memop.c
>> @@ -160,6 +160,21 @@ int main(int argc, char *argv[])
>>       run->psw_mask &= ~(3UL << (63 - 17));   /* Disable AR mode */
>>       vcpu_run(vm, VCPU_ID);                  /* Run to sync new state */
>> +    /* Check that the SIDA calls are rejected for non-protected guests */
>> +    ksmo.gaddr = 0;
>> +    ksmo.flags = 0;
>> +    ksmo.size = 8;
>> +    ksmo.op = KVM_S390_MEMOP_SIDA_READ;
>> +    ksmo.buf = (uintptr_t)mem1;
>> +    ksmo.sida_offset = 0x1c0;
>> +    rv = _vcpu_ioctl(vm, VCPU_ID, KVM_S390_MEM_OP, &ksmo);
>> +    TEST_ASSERT(rv == -1 && errno == EINVAL,
>> +            "ioctl does not reject SIDA_READ in non-protected mode");
> 
> Printing what passed would be a good addition to understand the tests that
> get run and expected to pass.

Yes, I agree ... I'll add that for a follow-up patch to my TODO list.

>> +    ksmo.op = KVM_S390_MEMOP_SIDA_WRITE;
>> +    rv = _vcpu_ioctl(vm, VCPU_ID, KVM_S390_MEM_OP, &ksmo);
>> +    TEST_ASSERT(rv == -1 && errno == EINVAL,
>> +            "ioctl does not reject SIDA_WRITE in non-protected mode");
>> +
> 
> Same here.
> 
>>       kvm_vm_free(vm);
>>       return 0;
>>
> 
> Something to consider in a follow-on patch and future changes to these tests.
> 
> Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>

  Thanks!

   Thomas


