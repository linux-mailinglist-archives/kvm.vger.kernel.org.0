Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1A7E45947A
	for <lists+kvm@lfdr.de>; Mon, 22 Nov 2021 19:03:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239811AbhKVSHF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Nov 2021 13:07:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:53656 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232075AbhKVSHE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Nov 2021 13:07:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637604236;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/DEaToVlY5Aeangp7WiLsHVGQQfsjFmc4POHJyFMamU=;
        b=QLJ9rbK0BJdAosqHLAIcXvfSTlvw5/oAQzFmjub4tVyDTiGFWRYuBPzYTvEzWydPfGnyTY
        IgjEEPI1Ru6Kml9yL2jkD+arzNL/ViUxRLhBE4oXcj81qr7ivxhaKPnCBIAXBK0nTEE9is
        Eq7zv+CzgyzSnI6SV8DYEcJ3LnrewOY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-433-g87FoENyMNmq965_W9h1Fw-1; Mon, 22 Nov 2021 13:03:55 -0500
X-MC-Unique: g87FoENyMNmq965_W9h1Fw-1
Received: by mail-wm1-f72.google.com with SMTP id r6-20020a1c4406000000b0033119c22fdbso7140180wma.4
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 10:03:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=/DEaToVlY5Aeangp7WiLsHVGQQfsjFmc4POHJyFMamU=;
        b=SwbB+pO573NT885qz2FFUhdMSckhxG2dmHVi3OOr3OXesVE+0b0TGZ1ltPZpUYV9U6
         IlBIJ3Fyudup/MxaqW6KXYxBR7K0ndWRMdYKzdy6umPcsDjS1nUW8WoXXL25ALn94Kq/
         ckphcpxhTj4K29ZB5WkHjjynOfVfQANQo6lidF8iP+8YZVoVyhXzQS9U1IPpVgJWIZvF
         w6Y7/DnlOXVou+HT9ec2LLm8CasNf30oqF5fX5YxgH7h5lRgYVoxhOTzBH2/LWgE7Mez
         wK2S/ChnzoyZ7mWoKY191aHAw84yXOFsUbvYIDD+rskGQa/PzSWPoYRRJE7czC1Q4Oet
         ml7Q==
X-Gm-Message-State: AOAM530jqFci+iQH56AhCy5Oe0pvmm+B1WP7qDe+s5opCe5U1+O9kSpi
        xUW2Q8elDjQJ49kJnBs4M0rElNuzByfI9FIGtOk0/AfPo6oaH6tcXoi70+s+qd7YmWFSsy19Fox
        x8q48VoAdqpLI
X-Received: by 2002:a7b:c4c4:: with SMTP id g4mr30719668wmk.93.1637604234422;
        Mon, 22 Nov 2021 10:03:54 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx/p3uFUzTXy9khuW7x18qGzSFTTSm7s3WYT3KBUot8+aI7MWQPX+T7zpzrsO0+qx9MA8Lm5A==
X-Received: by 2002:a7b:c4c4:: with SMTP id g4mr30719604wmk.93.1637604234100;
        Mon, 22 Nov 2021 10:03:54 -0800 (PST)
Received: from fedora (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id j40sm11438126wms.16.2021.11.22.10.03.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Nov 2021 10:03:53 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: selftests: Make sure kvm_create_max_vcpus test
 won't hit RLIMIT_NOFILE
In-Reply-To: <YZvVeW6qYNb/kkSc@google.com>
References: <20211122171920.603760-1-vkuznets@redhat.com>
 <YZvVeW6qYNb/kkSc@google.com>
Date:   Mon, 22 Nov 2021 19:03:52 +0100
Message-ID: <87czmsm5iv.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Mon, Nov 22, 2021, Vitaly Kuznetsov wrote:
>> With the elevated 'KVM_CAP_MAX_VCPUS' value kvm_create_max_vcpus test
>> may hit RLIMIT_NOFILE limits:
>> 
>>  # ./kvm_create_max_vcpus
>>  KVM_CAP_MAX_VCPU_ID: 4096
>>  KVM_CAP_MAX_VCPUS: 1024
>>  Testing creating 1024 vCPUs, with IDs 0...1023.
>>  /dev/kvm not available (errno: 24), skipping test
>> 
>> Adjust RLIMIT_NOFILE limits to make sure KVM_CAP_MAX_VCPUS fds can be
>> opened. Note, raising hard limit ('rlim_max') requires CAP_SYS_RESOURCE
>> capability which is generally not needed to run kvm selftests (but without
>> raising the limit the test is doomed to fail anyway).
>> 
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> ---
>>  .../selftests/kvm/kvm_create_max_vcpus.c      | 22 +++++++++++++++++++
>>  1 file changed, 22 insertions(+)
>> 
>> diff --git a/tools/testing/selftests/kvm/kvm_create_max_vcpus.c b/tools/testing/selftests/kvm/kvm_create_max_vcpus.c
>> index f968dfd4ee88..19198477a10e 100644
>> --- a/tools/testing/selftests/kvm/kvm_create_max_vcpus.c
>> +++ b/tools/testing/selftests/kvm/kvm_create_max_vcpus.c
>> @@ -12,6 +12,7 @@
>>  #include <stdio.h>
>>  #include <stdlib.h>
>>  #include <string.h>
>> +#include <sys/resource.h>
>>  
>>  #include "test_util.h"
>>  
>> @@ -19,6 +20,9 @@
>>  #include "asm/kvm.h"
>>  #include "linux/kvm.h"
>>  
>> +/* 'Safe' number of open file descriptors in addition to vCPU fds needed */
>> +#define NOFD 16
>
> Any reason not to make this "buffer" extra large, e.g. 100+ to avoid having to
> debug this issue again in the future?
>

No, not really. We could've avoided this ambiguity completely by
checking how many fds are already open but all methods I can think of
are 'too much'. In my testing I needed around 10 so I put '16' but '100'
is even better.

>> +
>>  void test_vcpu_creation(int first_vcpu_id, int num_vcpus)
>>  {
>>  	struct kvm_vm *vm;
>> @@ -40,10 +44,28 @@ int main(int argc, char *argv[])
>>  {
>>  	int kvm_max_vcpu_id = kvm_check_cap(KVM_CAP_MAX_VCPU_ID);
>>  	int kvm_max_vcpus = kvm_check_cap(KVM_CAP_MAX_VCPUS);
>
> Rather than a separate define that's hard to describe succintly, what about:
>
> 	int nr_fds_wanted = kvm_max_vcpus + <arbitrary number>
>
> and then the body becomes
>
> 	if (nr_fds_wanted > rl.rlim_cur) {
> 		rl.rlim_cur = nr_fds_wanted;
> 		rl.rlim_max = max(rl.rlim_max, nr_fds_wanted);
>
> 		...
> 	}

Sure but a "succinct" comment will still be needed, either near the
'NOFD' define or above 'int nr_fds_wanted' :-)

>
>> +	struct rlimit rl;
>>  
>>  	pr_info("KVM_CAP_MAX_VCPU_ID: %d\n", kvm_max_vcpu_id);
>>  	pr_info("KVM_CAP_MAX_VCPUS: %d\n", kvm_max_vcpus);
>>  
>> +	/*
>> +	 * Creating KVM_CAP_MAX_VCPUS vCPUs require KVM_CAP_MAX_VCPUS open
>> +	 * file decriptors.
>> +	 */
>> +	TEST_ASSERT(!getrlimit(RLIMIT_NOFILE, &rl),
>> +		    "getrlimit() failed (errno: %d)", errno);
>
> And strerror() output too?
>

Sure, will add in v2.

>> +
>> +	if (kvm_max_vcpus > rl.rlim_cur - NOFD) {
>> +		rl.rlim_cur = kvm_max_vcpus + NOFD;
>> +
>> +		if (kvm_max_vcpus > rl.rlim_max - NOFD)
>> +			rl.rlim_max = kvm_max_vcpus + NOFD;
>> +
>> +		TEST_ASSERT(!setrlimit(RLIMIT_NOFILE, &rl),
>> +			    "setrlimit() failed (errno: %d)", errno);
>> +	}
>> +
>>  	/*
>>  	 * Upstream KVM prior to 4.8 does not support KVM_CAP_MAX_VCPU_ID.
>>  	 * Userspace is supposed to use KVM_CAP_MAX_VCPUS as the maximum ID
>> -- 
>> 2.33.1
>> 
>

-- 
Vitaly

