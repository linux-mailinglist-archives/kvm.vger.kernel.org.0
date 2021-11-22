Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C89E645940E
	for <lists+kvm@lfdr.de>; Mon, 22 Nov 2021 18:38:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239956AbhKVRlO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Nov 2021 12:41:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239856AbhKVRlN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Nov 2021 12:41:13 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 338ABC061714
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 09:38:07 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id o14so14726914plg.5
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 09:38:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RfgufGkge6LcOJ7o6WilfLIxcSMJwk5H2M7ujdcdjxk=;
        b=pfx6iWvWQAdor0Us7spIoG6XdpIzT9Rrr22CxdxF4Hblv9omFuQJnIkyhFjnS8yfyo
         sc7Wly/N2UOiFW0z/35Csss5Oe2EO0r6JHNbuhToVoqzCpGwgM2UPzPh66aJhC63/xBA
         yuL+kPl1czFd97C0cRpsqHeecSL75+soc80Pq/1btngi1mzEZDJhm3/vMw+l0VqiqJwc
         uCLHpcfYMkerpY+AC4+wMbBDxpGprbbyntkvf0QNAzY0tp0S0sp2LJn5VVc4T7YBhBRz
         a4MiqMZKWlgxgfcw+GVKMmwJobw3rOwVJ1RR2xVun7szukQlHA/d0j8GlXXum9KgX6OK
         xh/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RfgufGkge6LcOJ7o6WilfLIxcSMJwk5H2M7ujdcdjxk=;
        b=ivzAOWjetQWDQvnCHI8ON4aIIpMkonFcG27sjCsrM4ZvvrQAc/kexJG6GimvDaSGT4
         n41sfSKjxujoHKj+3nnSwY+Wf/8PhZ6+0IhYAD5wnMUa8uOKsAAf4VKblXUOWkYMmCL1
         qDvLHilutSEeEr2rRix9y/DrYH9ReUXRSRq1JtWnO+OwPTrhQIjf89aTcHfK5/aKBrvx
         P42On+nkdvLIhAMvljrCyBzf1ecZNYk8+cmxGURg1hkQ3yFN7Ofesl5+UlBLM8HkHrnG
         +WMKs6IgjXgaI5VvDuZGcvkr4hdOQCHPJa0wbkhwjDnJhfQdrJSgHaSB3e3B424WdSjM
         +b3Q==
X-Gm-Message-State: AOAM533fo9mkkCguDDZAjz53zlysIEB1y73fIN5hDuZTtpmzZxohhUnx
        ng7VRjjuhjT2WN3mV7DPlkPYcA==
X-Google-Smtp-Source: ABdhPJw1OcVRbaPF71e8wVXUv9wdNbQqpvjaMZwTzNZK7mPhYd/gMIe9BBeeCWKvdpsC9NKbf4CvGw==
X-Received: by 2002:a17:902:b28a:b0:142:3e17:38d8 with SMTP id u10-20020a170902b28a00b001423e1738d8mr111179399plr.56.1637602685581;
        Mon, 22 Nov 2021 09:38:05 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id f7sm9674738pfv.89.2021.11.22.09.38.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Nov 2021 09:38:05 -0800 (PST)
Date:   Mon, 22 Nov 2021 17:38:01 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: selftests: Make sure kvm_create_max_vcpus test
 won't hit RLIMIT_NOFILE
Message-ID: <YZvVeW6qYNb/kkSc@google.com>
References: <20211122171920.603760-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211122171920.603760-1-vkuznets@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 22, 2021, Vitaly Kuznetsov wrote:
> With the elevated 'KVM_CAP_MAX_VCPUS' value kvm_create_max_vcpus test
> may hit RLIMIT_NOFILE limits:
> 
>  # ./kvm_create_max_vcpus
>  KVM_CAP_MAX_VCPU_ID: 4096
>  KVM_CAP_MAX_VCPUS: 1024
>  Testing creating 1024 vCPUs, with IDs 0...1023.
>  /dev/kvm not available (errno: 24), skipping test
> 
> Adjust RLIMIT_NOFILE limits to make sure KVM_CAP_MAX_VCPUS fds can be
> opened. Note, raising hard limit ('rlim_max') requires CAP_SYS_RESOURCE
> capability which is generally not needed to run kvm selftests (but without
> raising the limit the test is doomed to fail anyway).
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  .../selftests/kvm/kvm_create_max_vcpus.c      | 22 +++++++++++++++++++
>  1 file changed, 22 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/kvm_create_max_vcpus.c b/tools/testing/selftests/kvm/kvm_create_max_vcpus.c
> index f968dfd4ee88..19198477a10e 100644
> --- a/tools/testing/selftests/kvm/kvm_create_max_vcpus.c
> +++ b/tools/testing/selftests/kvm/kvm_create_max_vcpus.c
> @@ -12,6 +12,7 @@
>  #include <stdio.h>
>  #include <stdlib.h>
>  #include <string.h>
> +#include <sys/resource.h>
>  
>  #include "test_util.h"
>  
> @@ -19,6 +20,9 @@
>  #include "asm/kvm.h"
>  #include "linux/kvm.h"
>  
> +/* 'Safe' number of open file descriptors in addition to vCPU fds needed */
> +#define NOFD 16

Any reason not to make this "buffer" extra large, e.g. 100+ to avoid having to
debug this issue again in the future?

> +
>  void test_vcpu_creation(int first_vcpu_id, int num_vcpus)
>  {
>  	struct kvm_vm *vm;
> @@ -40,10 +44,28 @@ int main(int argc, char *argv[])
>  {
>  	int kvm_max_vcpu_id = kvm_check_cap(KVM_CAP_MAX_VCPU_ID);
>  	int kvm_max_vcpus = kvm_check_cap(KVM_CAP_MAX_VCPUS);

Rather than a separate define that's hard to describe succintly, what about:

	int nr_fds_wanted = kvm_max_vcpus + <arbitrary number>

and then the body becomes

	if (nr_fds_wanted > rl.rlim_cur) {
		rl.rlim_cur = nr_fds_wanted;
		rl.rlim_max = max(rl.rlim_max, nr_fds_wanted);

		...
	}

> +	struct rlimit rl;
>  
>  	pr_info("KVM_CAP_MAX_VCPU_ID: %d\n", kvm_max_vcpu_id);
>  	pr_info("KVM_CAP_MAX_VCPUS: %d\n", kvm_max_vcpus);
>  
> +	/*
> +	 * Creating KVM_CAP_MAX_VCPUS vCPUs require KVM_CAP_MAX_VCPUS open
> +	 * file decriptors.
> +	 */
> +	TEST_ASSERT(!getrlimit(RLIMIT_NOFILE, &rl),
> +		    "getrlimit() failed (errno: %d)", errno);

And strerror() output too?

> +
> +	if (kvm_max_vcpus > rl.rlim_cur - NOFD) {
> +		rl.rlim_cur = kvm_max_vcpus + NOFD;
> +
> +		if (kvm_max_vcpus > rl.rlim_max - NOFD)
> +			rl.rlim_max = kvm_max_vcpus + NOFD;
> +
> +		TEST_ASSERT(!setrlimit(RLIMIT_NOFILE, &rl),
> +			    "setrlimit() failed (errno: %d)", errno);
> +	}
> +
>  	/*
>  	 * Upstream KVM prior to 4.8 does not support KVM_CAP_MAX_VCPU_ID.
>  	 * Userspace is supposed to use KVM_CAP_MAX_VCPUS as the maximum ID
> -- 
> 2.33.1
> 
