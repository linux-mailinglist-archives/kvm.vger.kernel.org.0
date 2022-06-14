Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65B6054B30D
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 16:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343664AbiFNOYp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 10:24:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243580AbiFNOYn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 10:24:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B575E2BB2A
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 07:24:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655216680;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c/W8jZgUnGZP6Qe9nuklShonDb+6U/u9I9QZozewk0A=;
        b=gfXM9rzGWyPv7NpVIPsGIvGoDzThINLzEKPqbmVrYYbQFnE/DtzrBv96jzbslfaingvewC
        TNW2J/58HZGG8hceTKdIPZwLfCvpeODmcTzyJWXxOPoE+JD47yh1oabQc6zkc9L5T3dCmw
        5n2gmZBf52xbggu1GN4I7DsxHpc95VI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-104-KKfEfWQiNj6ktgbVtOOACA-1; Tue, 14 Jun 2022 10:24:39 -0400
X-MC-Unique: KKfEfWQiNj6ktgbVtOOACA-1
Received: by mail-wm1-f71.google.com with SMTP id l17-20020a05600c4f1100b0039c860db521so4547743wmq.5
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 07:24:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=c/W8jZgUnGZP6Qe9nuklShonDb+6U/u9I9QZozewk0A=;
        b=CRHX7MIUUyJ9mT1k0g6iC/4qeUMT6BWl3J9gdDqdjj2XYK9tNq36qPtHfpHNTNCcNL
         VLt1+PoTdq1MDLdOz78PrzvCMwFGRZ8kiq8zs5KK/VNIdzHzap54pQw7QbtY0QICogIO
         L7ruU4G1pU67s674ltEOE6T7dy+dZVIOVfphH6VtFUcIUf3NVxOxP7D2ZdOwv/dLg8lN
         81DfYQXUc73njdHuE0U+eLjJhJinGYqRtVnHE/F4HIXqavdB2N4s6/AZGZFUnnkLAnYa
         h4LFJ9yZQjOUDCWTDDFu3qHlPT3XhA5Td85KFge1ayDGUaev4D26jhng0n4iXMKJx3dN
         7R9w==
X-Gm-Message-State: AJIora8t9N3T/VWtMqS/XYfDPb3mrTjkkt+tcbdJlBYKWg1no3QN7rZx
        vmo2uPvfQUiQzHVcgDTdPexl6Q7CsHm7bHPVAB+0O8pSnMoNfVi5zyu4TC5NYRRiivMIq6Zu9Me
        E50vNp6fONQ+q
X-Received: by 2002:adf:a55a:0:b0:219:e574:2ae9 with SMTP id j26-20020adfa55a000000b00219e5742ae9mr5364268wrb.158.1655216678288;
        Tue, 14 Jun 2022 07:24:38 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uCDAmT9GjGpaTwIkrS4ralu3DyoBR1ymKq0LMgiqhfqUcmwAISgLlJrM1+isW+D7YDEmGJOw==
X-Received: by 2002:adf:a55a:0:b0:219:e574:2ae9 with SMTP id j26-20020adfa55a000000b00219e5742ae9mr5364228wrb.158.1655216677887;
        Tue, 14 Jun 2022 07:24:37 -0700 (PDT)
Received: from [192.168.0.3] (ip-109-42-114-75.web.vodafone.de. [109.42.114.75])
        by smtp.gmail.com with ESMTPSA id h206-20020a1c21d7000000b0039746638d6esm13583229wmh.33.2022.06.14.07.24.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jun 2022 07:24:37 -0700 (PDT)
Message-ID: <36d83871-343d-e8a0-1aed-05bf386f9b1b@redhat.com>
Date:   Tue, 14 Jun 2022 16:24:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v4 1/4] KVM: s390: selftests: Use TAP interface in the
 memop test
Content-Language: en-US
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>, kvm@vger.kernel.org,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Hildenbrand <david@redhat.com>,
        Shuah Khan <shuah@kernel.org>, linux-s390@vger.kernel.org
References: <20220531101554.36844-1-thuth@redhat.com>
 <20220531101554.36844-2-thuth@redhat.com>
 <07576ae9-9798-316f-d33e-10c91faeebfb@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <07576ae9-9798-316f-d33e-10c91faeebfb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/06/2022 12.38, Janis Schoetterl-Glausch wrote:
> On 5/31/22 12:15, Thomas Huth wrote:
>> The memop test currently does not have any output (unless one of the
>> TEST_ASSERT statement fails), so it's hard to say for a user whether
>> a certain new sub-test has been included in the binary or not. Let's
>> make this a little bit more user-friendly and include some TAP output
>> via the kselftests.h interface.
>>
>> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
>> Signed-off-by: Thomas Huth <thuth@redhat.com>
>> ---
>>   tools/testing/selftests/kvm/s390x/memop.c | 95 ++++++++++++++++++-----
>>   1 file changed, 77 insertions(+), 18 deletions(-)
>>
>> diff --git a/tools/testing/selftests/kvm/s390x/memop.c b/tools/testing/selftests/kvm/s390x/memop.c
>> index 49f26f544127..e704c6fa5758 100644
>> --- a/tools/testing/selftests/kvm/s390x/memop.c
>> +++ b/tools/testing/selftests/kvm/s390x/memop.c
>> @@ -14,6 +14,7 @@
>>   
> 
> [...]
> 
>>   int main(int argc, char *argv[])
>>   {
>> -	int memop_cap, extension_cap;
>> +	int memop_cap, extension_cap, idx;
>>   
>>   	setbuf(stdout, NULL);	/* Tell stdout not to buffer its content */
>>   
>> +	ksft_print_header();
>> +
>>   	memop_cap = kvm_check_cap(KVM_CAP_S390_MEM_OP);
>>   	extension_cap = kvm_check_cap(KVM_CAP_S390_MEM_OP_EXTENSION);
>>   	if (!memop_cap) {
>> -		print_skip("CAP_S390_MEM_OP not supported");
>> -		exit(KSFT_SKIP);
>> +		ksft_exit_skip("CAP_S390_MEM_OP not supported.\n");
>>   	}
>>   
>> -	test_copy();
>> -	if (extension_cap > 0) {
>> -		test_copy_key();
>> -		test_copy_key_storage_prot_override();
>> -		test_copy_key_fetch_prot();
>> -		test_copy_key_fetch_prot_override();
>> -		test_errors_key();
>> -		test_termination();
>> -		test_errors_key_storage_prot_override();
>> -		test_errors_key_fetch_prot_override_not_enabled();
>> -		test_errors_key_fetch_prot_override_enabled();
>> -	} else {
>> -		print_skip("storage key memop extension not supported");
>> +	ksft_set_plan(ARRAY_SIZE(testlist));
>> +
>> +	for (idx = 0; idx < ARRAY_SIZE(testlist); idx++) {
>> +		if (testlist[idx].extension >= extension_cap) {
> 
> This is reversed, should be
> 
>     		if (testlist[idx].extension <= extension_cap) {
> or
> 		if (extension_cap >= testlist[idx].extension) {

Drat! The patch is already in Paolo's queue ... could you please send a 
patch to fix this, so that Paolo can either squash it (not sure whether 
that's still feasible) or queue it, too?

> I'd prefer the latter.

Me too.

  Thanks,
   Thomas

