Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6B2E5A6CAF
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 21:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbiH3TCB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 15:02:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiH3TB7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 15:01:59 -0400
Received: from mail-io1-xd49.google.com (mail-io1-xd49.google.com [IPv6:2607:f8b0:4864:20::d49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD21E5EDCF
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 12:01:58 -0700 (PDT)
Received: by mail-io1-xd49.google.com with SMTP id x9-20020a056602210900b006897b3869e4so7249771iox.16
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 12:01:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc;
        bh=KF2FaYFBo9TGsmChrHM9AH6GzUReTMVwLGccXsi5P2A=;
        b=SFZLQjrPGX2xL+uz1iv19W19PwvYSRioSqvFzrYa6C12WSNiNjFimJSDYwN+AqneR8
         cLiB5VyKuSG/MHzuzAFfFrfbFOorF2W5QKVYenw/4Tf+v+V4Yqu6zYZChm6VXKcZ11Kf
         DGo4fXbTzZ2BAE/aQpOy0lC6okEWLIe13GYgMvsCDCqJ4oUdfasrPhmG0JBTqR0kjtCi
         RpoXIaHtmaBgKcrclGleB+s4t6aVQ007IlVpEjAadag6oWo+y2cVzyiIGGLmibgrFxwF
         y4Ml/GhY+wHkSFWxJNb7kUdwPWoPHfiSVM/T11iA6Ch+VHZwJi5v8W9Hm4rOqAba6trz
         dQ1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc;
        bh=KF2FaYFBo9TGsmChrHM9AH6GzUReTMVwLGccXsi5P2A=;
        b=nXITrMbPbRJdWGaMFaCsOscZavOyJutCBYdxxA57U4Rwha/bJ2SRj4ubyAe1lkz6ZW
         CFi0iL6l6W1wydzHdUV2/Ie6PKVFARlU00LWZGVt5lHH6lRnfMWnfJH80V8qESfYizQJ
         Mtlp5aXdQKsEopuC2jhcUEYwr7fI6cjPRguvCvtxNNbMIXPGcLtVhyJEpZbKonK6E+z0
         UtrMQl+aY78eQyANB01WPvp/67i9k5ShrcmzfXQKOg31SettfKzpa80FTu+rHLK6rJD+
         Tg1JIfesw9JG1WrHUMy1NG3SK4qFEmv22QxdAOE/Xb4Uhv0lEbhI7N3wxvW1iGtOdk0u
         qXjg==
X-Gm-Message-State: ACgBeo3Y7jHGZP2Pjle02mDP6gq/SSGmHgw34W98JQF68BDT7I3xF3CD
        HZEWvyhQO2GlrwZVyIBjGC6OuVR/t+/4JgmC0g==
X-Google-Smtp-Source: AA6agR6ZiVWuzjXKr4lL4KAcNDj9FSxUlrYMqQiZkvBRCU1kEWlpWFIECw6A4o5mNF+UAqO5XXG6noP+S8fkHqGpiQ==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:6e02:1aa7:b0:2de:b9f1:593f with
 SMTP id l7-20020a056e021aa700b002deb9f1593fmr12518893ilv.243.1661886118175;
 Tue, 30 Aug 2022 12:01:58 -0700 (PDT)
Date:   Tue, 30 Aug 2022 19:01:57 +0000
In-Reply-To: <YwlCGAD2S0aK7/vo@google.com> (message from David Matlack on Fri,
 26 Aug 2022 14:58:48 -0700)
Mime-Version: 1.0
Message-ID: <gsntk06pwo62.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v2 1/3] KVM: selftests: Create source of randomness for
 guest code.
From:   Colton Lewis <coltonlewis@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        seanjc@google.com, oupton@google.com, ricarkol@google.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

David Matlack <dmatlack@google.com> writes:

> On Wed, Aug 17, 2022 at 09:41:44PM +0000, Colton Lewis wrote:
>> Create for each vcpu an array of random numbers to be used as a source
>> of randomness when executing guest code. Randomness should be useful
>> for approaching more realistic conditions in dirty_log_perf_test.

>> Create a -r argument to specify a random seed. If no argument
>> is provided, the seed defaults to the current Unix timestamp.

>> The random arrays are allocated and filled as part of VM creation. The
>> additional memory used is one 32-bit number per guest VM page to
>> ensure one number for each iteration of the inner loop of guest_code.

> nit: I find it helpful to put this in more practical terms as well. e.g.

>    The random arrays are allocated and filled as part of VM creation. The
>    additional memory used is one 32-bit number per guest VM page (so
>    1MiB of additional memory when using the default 1GiB per-vCPU region
>    size) to ensure one number for each iteration of the inner loop of
>    guest_code.

> Speaking of, this commit always allocates the random arrays, even if
> they are not used. I think that's probably fine but it deserves to be
> called out in the commit description with an explanation of why it is
> the way it is.


I'll add a concrete example and explain always allocating.

Technically, the random array will always be accessed even if it never
changes the code path when write_percent = 0 or write_percent =
100. Always allocating avoids extra code that adds complexity for no
benefit.

>> @@ -442,6 +446,9 @@ int main(int argc, char *argv[])
>>   		case 'o':
>>   			p.partition_vcpu_memory_access = false;
>>   			break;
>> +		case 'r':
>> +			p.random_seed = atoi(optarg);

> Putting the random seed in test_params seems unnecessary. This flag
> could just set perf_test_args.randome_seed directly. Doing this would
> avoid the need for duplicating the time(NULL) initialization, and allow
> you to drop perf_test_set_random_seed().


I understand there is some redundancy in this approach and had
originally done what you suggest. My reason for changing was based on
the consideration that perf_test_util.c is library code that is used for
other tests and could be used for more in the future, so it should
always initialize everything in perf_test_args rather than rely on the
test to do it. This is what is done for wr_fract (renamed write_percent
later in this patch). perf_test_set_random_seed is there for interface
consistency with the other perf_test_set* functions.

But per the point below, moving random generation to VM creation means
we are dependent on the seed being set before then. So I do need a
change here, but I'd rather keep the redundancy and
perf_test_set_random_seed.

>> +void perf_test_fill_random_arrays(uint32_t nr_vcpus, uint32_t  
>> nr_randoms)
>> +{
>> +	struct perf_test_args *pta = &perf_test_args;
>> +	uint32_t *host_row;

> "host_row" is a confusing variable name here since you are no longer
> operating on a 2D array. Each vCPU has it's own array.


Agreed.

>> @@ -120,8 +149,9 @@ struct kvm_vm *perf_test_create_vm(enum  
>> vm_guest_mode mode, int nr_vcpus,

>>   	pr_info("Testing guest mode: %s\n", vm_guest_mode_string(mode));

>> -	/* By default vCPUs will write to memory. */
>> -	pta->wr_fract = 1;
>> +	/* Set perf_test_args defaults. */
>> +	pta->wr_fract = 100;
>> +	pta->random_seed = time(NULL);

> Won't this override write the random_seed provided by the test?


Yes. I had thought I accounted for that by setting random_seed later in
run_test, but now realize that has no effect because I moved the
generation of all the random numbers to happen before then.


>>   	/*
>>   	 * Snapshot the non-huge page size.  This is used by the guest code to
>> @@ -211,6 +241,11 @@ struct kvm_vm *perf_test_create_vm(enum  
>> vm_guest_mode mode, int nr_vcpus,

>>   	ucall_init(vm, NULL);

>> +	srandom(perf_test_args.random_seed);
>> +	pr_info("Random seed: %d\n", perf_test_args.random_seed);
>> +	perf_test_alloc_random_arrays(nr_vcpus, vcpu_memory_bytes >>  
>> vm->page_shift);
>> +	perf_test_fill_random_arrays(nr_vcpus, vcpu_memory_bytes >>  
>> vm->page_shift);

> I think this is broken if !partition_vcpu_memory_access. nr_randoms
> (per-vCPU) should be `nr_vcpus * vcpu_memory_bytes >> vm->page_shift`.


Agree it will break then and should not. But allocating that many more
random numbers may eat too much memory. In a test with 64 vcpus, it would
try to allocate 64x64 times as many random numbers. I'll try it but may
need something different in that case.

> Speaking of, this should probably just be done in
> perf_test_setup_vcpus(). That way you can just use vcpu_args->pages for
> nr_randoms, and you don't have to add another for-each-vcpu loop.


Agreed.

>> +
>>   	/* Export the shared variables to the guest. */
>>   	sync_global_to_guest(vm, perf_test_args);

>> @@ -229,6 +264,12 @@ void perf_test_set_wr_fract(struct kvm_vm *vm, int  
>> wr_fract)
>>   	sync_global_to_guest(vm, perf_test_args);
>>   }

>> +void perf_test_set_random_seed(struct kvm_vm *vm, uint32_t random_seed)
>> +{
>> +	perf_test_args.random_seed = random_seed;
>> +	sync_global_to_guest(vm, perf_test_args);

> sync_global_to_guest() is unnecessary here since the guest does not need
> to access perf_test_args.random_seed (and I can't imagine it ever will).

> That being said, I think you can drop this function (see earlier
> comment).


See earlier response about consistency.
