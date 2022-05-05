Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A131251C89A
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 20:59:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359647AbiEETDa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 15:03:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234553AbiEETD2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 15:03:28 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0EDD3D1FB
        for <kvm@vger.kernel.org>; Thu,  5 May 2022 11:59:47 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id cu23-20020a17090afa9700b001d98d8e53b7so6420344pjb.0
        for <kvm@vger.kernel.org>; Thu, 05 May 2022 11:59:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wCpcowAM0vgqZbW/i6EGm8F/PqCUq6WSEgcBbHIctY4=;
        b=FOSXdjwYY+3UTCbqzQzs8mkttYPpNGGb3NsqLtj2FIpdNh229+ezVOtprB0pVomaBu
         LhTzaZ61Qk34BrFxfxYqLmmRO9JWDClk4DCjqUrc2LEUsDvfmTswOiSz2LyoJ5Dp3u97
         snYFyrOeJO7jQ3B9MjdPqbD2sTXGVDHR/9AWgLOXUTp1bC51K0EulSHD5CCFdpe7YrIJ
         RGgmjTQDUciMcPbv7Wzt04lj63OzR76uOKzSynHm0DhFtUpkJSz1Q4s35X5AEnkOzjVX
         gFndHrhoZBiMkxoShqR7Go9aMkXNlV0kxxYW58+FgstzVQockUc6ShkJy9S/2HIWRjMf
         qSDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wCpcowAM0vgqZbW/i6EGm8F/PqCUq6WSEgcBbHIctY4=;
        b=ZJzOKndQhaptIMNqSL/eZ3uG0WnQiYq1Mr+m8e4bmhIN8/pZf/A1UoP281s1baHZ0I
         T4etv1vQa3DlzgQoHR03ueh5/ed+d9wQ92I2gOQWykESJcNW20BOsNRb8HzPns//hlab
         S9DG8lzUukedrhmACMQjzrFYAFGWyH2S4zX6uXkh6CnrckJcC6lCvQX00o0y6PnVXuOe
         TPRx97ihVM2Xm1rj/NS94CTEfpEpAxMCaBiTsCKRFCGA3bNBv8xmSw9tRTLsk4vUf1AA
         cfWXKpisKuMCkJgQhdmW50r7CYSLNC4b8rCf1Exq8Mzt6PUz3n02L+CP3wQUmiALj7QZ
         1Kmg==
X-Gm-Message-State: AOAM530tRCFxofrpnAFhhRznD5oeTsR+g5oMktk3nysb/9+pkoY50oKq
        Z7lUCLmVuDO2+rGtUzIE4ICJ9Q==
X-Google-Smtp-Source: ABdhPJwZksnVYlCSOf2n+0LS5XsuLxFB4fgJlq9S9y1eaaO5qNII/YpHSP8iYdd3sdvhKq1kPEUYig==
X-Received: by 2002:a17:90b:4398:b0:1dc:7edf:c92a with SMTP id in24-20020a17090b439800b001dc7edfc92amr7888739pjb.136.1651777186947;
        Thu, 05 May 2022 11:59:46 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id h125-20020a625383000000b0050dc76281dfsm1690853pfb.185.2022.05.05.11.59.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 May 2022 11:59:46 -0700 (PDT)
Date:   Thu, 5 May 2022 18:59:43 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>
Subject: Re: [PATCH v7 06/11] KVM: selftests: Add NX huge pages test
Message-ID: <YnQen5rO3t/2WiLi@google.com>
References: <20220503183045.978509-1-bgardon@google.com>
 <20220503183045.978509-7-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220503183045.978509-7-bgardon@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 03, 2022, Ben Gardon wrote:
> There's currently no test coverage of NX hugepages in KVM selftests, so
> add a basic test to ensure that the feature works as intended.

Please describe how the test actually validates the feature, here and/or as a
file comment.  Doesn't have to be super detailed, but people shouldn't have to
read the code just to understand that the test uses stats to verify the KVM is
(or isn't) splitting pages as expected.

> Reviewed-by: David Matlack <dmatlack@google.com>
> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---
>  tools/testing/selftests/kvm/Makefile          |  10 +
>  .../selftests/kvm/include/kvm_util_base.h     |   1 +
>  tools/testing/selftests/kvm/lib/kvm_util.c    |  80 ++++++++
>  .../selftests/kvm/x86_64/nx_huge_pages_test.c | 180 ++++++++++++++++++
>  .../kvm/x86_64/nx_huge_pages_test.sh          |  36 ++++

Test needs to be added to .gitignore.

>  5 files changed, 307 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
>  create mode 100755 tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh

...

> + * Input Args:
> + *   vm - the VM for which the stat should be read
> + *   stat_name - the name of the stat to read
> + *   max_elements - the maximum number of 8-byte values to read into data
> + *
> + * Output Args:
> + *   data - the buffer into which stat data should be read
> + *
> + * Return:
> + *   The number of data elements read into data or -ERRNO on error.
> + *
> + * Read the data values of a specified stat from the binary stats interface.
> + */
> +static int __vm_get_stat(struct kvm_vm *vm, const char *stat_name,
> +			 uint64_t *data, ssize_t max_elements)
> +{
> +	struct kvm_stats_desc *stats_desc;
> +	struct kvm_stats_header header;
> +	struct kvm_stats_desc *desc;
> +	size_t size_desc;
> +	int stats_fd;
> +	int ret = -EINVAL;
> +	int i;
> +
> +	stats_fd = vm_get_stats_fd(vm);
> +
> +	read_stats_header(stats_fd, &header);
> +
> +	stats_desc = read_stats_desc(stats_fd, &header);
> +
> +	size_desc = sizeof(struct kvm_stats_desc) + header.name_size;
> +
> +	/* Read kvm stats data one by one */

Bad copy+paste.  This doesn't read every stat, it reads only the specified stat.

> +	for (i = 0; i < header.num_desc; ++i) {
> +		desc = (void *)stats_desc + (i * size_desc);

		desc = get_stats_descriptor(vm->stats_desc, i, vm->stats_header);

> +
> +		if (strcmp(desc->name, stat_name))
> +			continue;
> +
> +		ret = read_stat_data(stats_fd, &header, desc, data,
> +				     max_elements);
> +
> +		break;
> +	}
> +
> +	free(stats_desc);
> +	close(stats_fd);
> +	return ret;
> +}
> +
> +/*
> + * Read the value of the named stat
> + *
> + * Input Args:
> + *   vm - the VM for which the stat should be read
> + *   stat_name - the name of the stat to read
> + *
> + * Output Args: None
> + *
> + * Return:
> + *   The value of the stat
> + *
> + * Reads the value of the named stat through the binary stat interface. If
> + * the named stat has multiple data elements, only the first will be returned.
> + */
> +uint64_t vm_get_stat(struct kvm_vm *vm, const char *stat_name)

One read_stat_data() doesn't return an int, this can be inlined.  Yeah, it'll
expose __vm_get_stat(), but IMO there's no point in having __vm_get_stat() unless
it's exposed.  At that point, drop the function comment and defer to the inner
helper for that detailed info (or even drop it entirely).

> +{
> +	uint64_t data;
> +	int ret;
> +
> +	ret = __vm_get_stat(vm, stat_name, &data, 1);
> +	TEST_ASSERT(ret == 1,
> +		    "Stat %s expected to have 1 element, but %d returned",
> +		    stat_name, ret);
> +	return data;
> +}
> diff --git a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
> new file mode 100644
> index 000000000000..238a6047791c
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
> @@ -0,0 +1,180 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * tools/testing/selftests/kvm/nx_huge_page_test.c
> + *
> + * Usage: to be run via nx_huge_page_test.sh, which does the necessary
> + * environment setup and teardown
> + *
> + * Copyright (C) 2022, Google LLC.
> + */
> +
> +#define _GNU_SOURCE
> +
> +#include <fcntl.h>
> +#include <stdint.h>
> +#include <time.h>
> +
> +#include <test_util.h>
> +#include "kvm_util.h"
> +
> +#define HPAGE_SLOT		10
> +#define HPAGE_GVA		(23*1024*1024)
> +#define HPAGE_GPA		(10*1024*1024)

Is there any special meaning behind the addresses?  If not, IMO it's safer to
define the GPA to be 4gb, that way there's no chance of this colliding with
memslot0 created by the framework.  10mb (if my math isn't terrible) isn't all
that high.  And unless the GPA and GVA need to be different for some reason, just
identity map them.

> +#define HPAGE_SLOT_NPAGES	(512 * 3)
> +#define PAGE_SIZE		4096

commit e852be8b148e ("kvm: selftests: introduce and use more page size-related constants")
in kvm/master defines PAGE_SIZE.  I bring that up, because rather than open code
the "512" math in multiple places, I would much rather do something like

#define PAGE_SIZE_2MB		(PAGE_SIZE * 512)

or whatever, and then use that.

> +
> +/*
> + * Passed by nx_huge_pages_test.sh to provide an easy warning if this test is
> + * being run without it.
> + */
> +#define MAGIC_TOKEN 887563923
> +
> +/*
> + * x86 opcode for the return instruction. Used to call into, and then
> + * immediately return from, memory backed with hugepages.
> + */
> +#define RETURN_OPCODE 0xC3
> +
> +/*
> + * Exit the VM after each memory access so that the userspace component of the
> + * test can make assertions about the pages backing the VM.
> + *
> + * See the below for an explanation of how each access should affect the
> + * backing mappings.
> + */
> +void guest_code(void)
> +{
> +	uint64_t hpage_1 = HPAGE_GVA;
> +	uint64_t hpage_2 = hpage_1 + (PAGE_SIZE * 512);
> +	uint64_t hpage_3 = hpage_2 + (PAGE_SIZE * 512);
> +
> +	READ_ONCE(*(uint64_t *)hpage_1);
> +	GUEST_SYNC(1);
> +
> +	READ_ONCE(*(uint64_t *)hpage_2);
> +	GUEST_SYNC(2);
> +
> +	((void (*)(void)) hpage_1)();

LOL, nice.  It'd be very, very helpful for readers to add a helper for this, e.g.

static guest_do_CALL(void *target)
{
	((void (*)(void)) target)();
}

and then the usage should be a little more obvious.

	guest_do_CALL(hpage_1);

> +	GUEST_SYNC(3);
> +
> +	((void (*)(void)) hpage_3)();
> +	GUEST_SYNC(4);
> +
> +	READ_ONCE(*(uint64_t *)hpage_1);
> +	GUEST_SYNC(5);
> +
> +	READ_ONCE(*(uint64_t *)hpage_3);
> +	GUEST_SYNC(6);
> +}

...

> +int main(int argc, char **argv)
> +{
> +       struct kvm_vm *vm;
> +       struct timespec ts;
> +       void *hva;
> +
> +       if (argc != 2 || strtol(argv[1], NULL, 0) != MAGIC_TOKEN) {

Since this will take multiple params, I think it makes senes to skip on:

	if (argc < 2 || strtol(argv[1], NULL, 0) != MAGIC_TOKEN) {

And the error out on the remaining params.

> +               printf("This test must be run through nx_huge_pages_test.sh");

Needs a newline at the end.  Even better, just use print_skip().  And I strongly
prefer that the skip message complain about not getting the correct magic token,
not about the script.  It's totally valid to run the test without the script.
I think it's a good idea to provide a redirect to the script, but yell about the
magic token first.

> +               return KSFT_SKIP;
> +       }

...

> +	hva = addr_gpa2hva(vm, HPAGE_GPA);
> +	memset(hva, RETURN_OPCODE, HPAGE_SLOT_NPAGES * PAGE_SIZE);

Heh, no need to set the entire page, only the first byte needs to be written.  If
you're going for paranoia, write 0xcc to the entire slot and then write only the
first byte to RET.

> +	/*
> +	 * Give recovery thread time to run. The wrapper script sets
> +	 * recovery_period_ms to 100, so wait 5x that.
> +	 */
> +	ts.tv_sec = 0;
> +	ts.tv_nsec = 500000000;
> +	nanosleep(&ts, NULL);

Please pass in the configured nx_huge_pages_recovery_period_ms, or alternatively
read it from within the test.  I assume the test will fail if the period is too
low, so some sanity checks are likely in order.  It'll be unfortunate if someone
changes the script and forgets to update the test.

> +
> +	/*
> +	 * Now that the reclaimer has run, all the split pages should be gone.
> +	 */
> +	check_2m_page_count(vm, 1);
> +	check_split_count(vm, 0);
> +
> +	/*
> +	 * The 4k mapping on hpage 3 should have been removed, so check that
> +	 * reading from it causes a huge page mapping to be installed.
> +	 */
> +	vcpu_run(vm, 0);
> +	check_2m_page_count(vm, 2);
> +	check_split_count(vm, 0);
> +
> +	kvm_vm_free(vm);
> +
> +	return 0;
> +}
> +
> diff --git a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh
> new file mode 100755
> index 000000000000..60bfed8181b9
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh
> @@ -0,0 +1,36 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0-only */
> +#
> +# Wrapper script which performs setup and cleanup for nx_huge_pages_test.
> +# Makes use of root privileges to set up huge pages and KVM module parameters.
> +#
> +# tools/testing/selftests/kvm/nx_huge_page_test.sh
> +# Copyright (C) 2022, Google LLC.
> +
> +set -e
> +
> +NX_HUGE_PAGES=$(sudo cat /sys/module/kvm/parameters/nx_huge_pages)
> +NX_HUGE_PAGES_RECOVERY_RATIO=$(sudo cat /sys/module/kvm/parameters/nx_huge_pages_recovery_ratio)
> +NX_HUGE_PAGES_RECOVERY_PERIOD=$(sudo cat /sys/module/kvm/parameters/nx_huge_pages_recovery_period_ms)
> +HUGE_PAGES=$(sudo cat /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages)

I think we can omit sudo on these.  Since we're assuming sysfs is mounted at the
normal path, we can also likely assume it's mounted with normal permissions too,
i.e. read-only for non-root users.

> +
> +set +e
> +
> +(
> +	set -e
> +
> +	sudo echo 1 > /sys/module/kvm/parameters/nx_huge_pages

"sudo echo" doesn't work, the redirection is done by the shell, not echo itself
(which is run with sudo).  This needs to be e.g.

	echo 1 | sudo tee -a /sys/module/kvm/parameters/nx_huge_pages > /dev/null

> +	sudo echo 1 > /sys/module/kvm/parameters/nx_huge_pages_recovery_ratio
> +	sudo echo 100 > /sys/module/kvm/parameters/nx_huge_pages_recovery_period_ms
> +	sudo echo 3 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages

So, what happens if the user is running something else that needs huge pages?  Feels
like the script should read the value and add three, not just blindly write '3'.

> +
> +	"$(dirname $0)"/nx_huge_pages_test 887563923
> +)
> +RET=$?
> +
> +sudo echo $NX_HUGE_PAGES > /sys/module/kvm/parameters/nx_huge_pages
> +sudo echo $NX_HUGE_PAGES_RECOVERY_RATIO > /sys/module/kvm/parameters/nx_huge_pages_recovery_ratio
> +sudo echo $NX_HUGE_PAGES_RECOVERY_PERIOD > /sys/module/kvm/parameters/nx_huge_pages_recovery_period_ms
> +sudo echo $HUGE_PAGES > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
> +
> +exit $RET
> -- 
> 2.36.0.464.gb9c8b46e94-goog
> 
