Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E984114A9
	for <lists+kvm@lfdr.de>; Thu,  2 May 2019 10:01:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726001AbfEBIBK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 May 2019 04:01:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43072 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725795AbfEBIBK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 May 2019 04:01:10 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id F0494C0568FE;
        Thu,  2 May 2019 08:01:09 +0000 (UTC)
Received: from [10.40.205.25] (unknown [10.40.205.25])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 842CF1001E6F;
        Thu,  2 May 2019 08:01:08 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH] powerpc: Allow for a custom decr value to
 be specified to load on decr excp
To:     Suraj Jitindar Singh <sjitindarsingh@gmail.com>,
        kvm@vger.kernel.org
Cc:     thuth@redhat.com, kvm-ppc@vger.kernel.org, dgibson@redhat.com
References: <20190501070039.2903-1-sjitindarsingh@gmail.com>
From:   Laurent Vivier <lvivier@redhat.com>
Message-ID: <ec8d1a58-e066-f61a-ad28-92b82fccdbff@redhat.com>
Date:   Thu, 2 May 2019 10:01:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.8.0
MIME-Version: 1.0
In-Reply-To: <20190501070039.2903-1-sjitindarsingh@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Thu, 02 May 2019 08:01:10 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/05/2019 09:00, Suraj Jitindar Singh wrote:
> Currently the handler for a decrementer exception will simply reload the
> maximum value (0x7FFFFFFF), which will take ~4 seconds to expire again.
> This means that if a vcpu cedes, it will be ~4 seconds between wakeups.
> 
> The h_cede_tm test is testing a known breakage when a guest cedes while
> suspended. To be sure we cede 500 times to check for the bug. However
> since it takes ~4 seconds to be woken up once we've ceded, we only get
> through ~20 iterations before we reach the 90 seconds timeout and the
> test appears to fail.
> 
> Add an option when registering the decrementer handler to specify the
> value which should be reloaded by the handler, allowing the timeout to be
> chosen.
> 
> Modify the spr test to use the max timeout to preserve existing
> behaviour.
> Modify the h_cede_tm test to use a 10ms timeout to ensure we can perform
> 500 iterations before hitting the 90 second time limit for a test.
> 
> This means the h_cede_tm test now succeeds rather than timing out.
> 
> Signed-off-by: Suraj Jitindar Singh <sjitindarsingh@gmail.com>
> ---
>   lib/powerpc/handlers.c | 7 ++++---
>   powerpc/sprs.c         | 3 ++-
>   powerpc/tm.c           | 3 ++-
>   3 files changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/lib/powerpc/handlers.c b/lib/powerpc/handlers.c
> index be8226a..c8721e0 100644
> --- a/lib/powerpc/handlers.c
> +++ b/lib/powerpc/handlers.c
> @@ -12,11 +12,12 @@
>   
>   /*
>    * Generic handler for decrementer exceptions (0x900)
> - * Just reset the decrementer back to its maximum value (0x7FFFFFFF)
> + * Just reset the decrementer back to the value specified when registering the
> + * handler
>    */
> -void dec_except_handler(struct pt_regs *regs __unused, void *data __unused)
> +void dec_except_handler(struct pt_regs *regs __unused, void *data)
>   {
> -	uint32_t dec = 0x7FFFFFFF;
> +	uint64_t dec = *((uint64_t *) data);
>   
>   	asm volatile ("mtdec %0" : : "r" (dec));
>   }
> diff --git a/powerpc/sprs.c b/powerpc/sprs.c
> index 6744bd8..3bd6ac7 100644
> --- a/powerpc/sprs.c
> +++ b/powerpc/sprs.c
> @@ -253,6 +253,7 @@ int main(int argc, char **argv)
>   		0x1234567890ABCDEFULL, 0xFEDCBA0987654321ULL,
>   		-1ULL,
>   	};
> +	uint64_t decr = 0x7FFFFFFF;
>   
>   	for (i = 1; i < argc; i++) {
>   		if (!strcmp(argv[i], "-w")) {
> @@ -288,7 +289,7 @@ int main(int argc, char **argv)
>   		(void) getchar();
>   	} else {
>   		puts("Sleeping...\n");
> -		handle_exception(0x900, &dec_except_handler, NULL);
> +		handle_exception(0x900, &dec_except_handler, &decr);
>   		asm volatile ("mtdec %0" : : "r" (0x3FFFFFFF));
>   		hcall(H_CEDE);
>   	}
> diff --git a/powerpc/tm.c b/powerpc/tm.c
> index bd56baa..0f3f543 100644
> --- a/powerpc/tm.c
> +++ b/powerpc/tm.c
> @@ -95,11 +95,12 @@ static bool enable_tm(void)
>   static void test_h_cede_tm(int argc, char **argv)
>   {
>   	int i;
> +	uint64_t decr = 0x3FFFFF;
>   
>   	if (argc > 2)
>   		report_abort("Unsupported argument: '%s'", argv[2]);
>   
> -	handle_exception(0x900, &dec_except_handler, NULL);
> +	handle_exception(0x900, &dec_except_handler, &decr);

Maybe you should also need here:

     asm volatile ("mtdec %0" : : "r" (decr));

To set the first one to the same values as the following ones?

Thanks,
Laurent
