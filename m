Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29C084E9B4
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2019 15:44:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726250AbfFUNoF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jun 2019 09:44:05 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:63354 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725985AbfFUNoF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jun 2019 09:44:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1561124644; x=1592660644;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=yfXI9UxtyIv8G/MPell59xXge03VdkSIiUnf5zgJv64=;
  b=Vgd8q/pO/mZTvk5T3W+n/gzcNpToR4D2ulrvpclc/YNF4AxgIJ6WJazf
   W4S5hUKKPb64cHMrsZ3XYcfTzzObDCR5qI+5jQfiGYFyZ3Ys1VG0GfqYc
   VR9Ga8anW2BrGKHDgDXuJWMA6wqsTPI49RZABcBC3+YK2Yoeldf1wbvvy
   U=;
X-IronPort-AV: E=Sophos;i="5.62,400,1554768000"; 
   d="scan'208";a="401783048"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1a-807d4a99.us-east-1.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 21 Jun 2019 13:44:03 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1a-807d4a99.us-east-1.amazon.com (Postfix) with ESMTPS id 8959FA22A3;
        Fri, 21 Jun 2019 13:43:58 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 21 Jun 2019 13:43:57 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.162.225) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 21 Jun 2019 13:43:53 +0000
Subject: Re: [v2, 3/4] Demonstrating unit testing via simple-harness
To:     Sam Caccavale <samcacc@amazon.de>
CC:     <samcaccavale@gmail.com>, <nmanthey@amazon.de>,
        <wipawel@amazon.de>, <dwmw@amazon.co.uk>, <mpohlack@amazon.de>,
        <karahmed@amazon.de>, <andrew.cooper3@citrix.com>,
        <JBeulich@suse.com>, <pbonzini@redhat.com>, <rkrcmar@redhat.com>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <hpa@zytor.com>, <paullangton4@gmail.com>,
        <anirudhkaushik@google.com>, <x86@kernel.org>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20190612153600.13073-1-samcacc@amazon.de>
 <20190612153600.13073-4-samcacc@amazon.de>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <54e7eb69-3700-2e54-77b9-79b61ca69a1b@amazon.com>
Date:   Fri, 21 Jun 2019 15:43:51 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <20190612153600.13073-4-samcacc@amazon.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.43.162.225]
X-ClientProxiedBy: EX13D23UWC001.ant.amazon.com (10.43.162.196) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12.06.19 17:35, Sam Caccavale wrote:
> Simple-harness.c uses inline asm support to generate asm and then has the
> emulator emulate this code.  This may be useful as a form of testing for
> the emulator.
> 
> CR: https://code.amazon.com/reviews/CR-8591638
> ---
>   tools/fuzz/x86ie/Makefile         |  7 ++++--
>   tools/fuzz/x86ie/simple-harness.c | 42 +++++++++++++++++++++++++++++++
>   2 files changed, 47 insertions(+), 2 deletions(-)
>   create mode 100644 tools/fuzz/x86ie/simple-harness.c
> 
> diff --git a/tools/fuzz/x86ie/Makefile b/tools/fuzz/x86ie/Makefile
> index d45fe6d266b9..e79d275e1040 100644
> --- a/tools/fuzz/x86ie/Makefile
> +++ b/tools/fuzz/x86ie/Makefile
> @@ -44,8 +44,11 @@ LOCAL_OBJS := emulator_ops.o stubs.o
>   afl-harness: afl-harness.o $(LOCAL_OBJS) $(KERNEL_OBJS)
>   	@$(CC) -v $(KBUILD_CFLAGS) $(LOCAL_OBJS) $(KERNEL_OBJS) $< $(INCLUDES) -Istubs.h -o $@ -no-pie
> 
> -all: afl-harness
> +simple-harness: simple-harness.o $(LOCAL_OBJS) $(KERNEL_OBJS)
> +	@$(CC) -v $(KBUILD_CFLAGS) $(LOCAL_OBJS) $(KERNEL_OBJS) $< $(INCLUDES) -Istubs.h -o $@ -no-pie
> +
> +all: afl-harness simple-harness
> 
>   .PHONY: clean
>   clean:
> -	$(RM) -r *.o afl-harness
> +	$(RM) -r *.o afl-harness simple-harness
> diff --git a/tools/fuzz/x86ie/simple-harness.c b/tools/fuzz/x86ie/simple-harness.c
> new file mode 100644
> index 000000000000..f21fdafe1dd1
> --- /dev/null
> +++ b/tools/fuzz/x86ie/simple-harness.c
> @@ -0,0 +1,42 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include <assert.h>
> +#include <stdint.h>
> +#include <stdio.h>
> +#include <string.h>
> +#include "emulator_ops.h"
> +#include <asm/kvm_emulate.h>
> +
> +extern void foo(void)
> +{
> +	asm volatile("__start:"
> +		     ".byte 0x32, 0x05, 0x00, 0x00, 0x00, 0x00;" // xor eax,DWORD PTR [rip+0x0]
> +		     ".byte 0x90;"
> +		     //".byte 0x0f, 0x7f, 0xde;" // movq mm6,mm3

Why?

Alex
