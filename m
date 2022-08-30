Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E45DD5A63F4
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 14:52:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbiH3Mwt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 08:52:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbiH3Mwi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 08:52:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9FFEFC130
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 05:52:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661863957;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vv2OrSXgnBFuvHiH/+q9HtCghWxl4Gpfg2D3H7JjXLE=;
        b=E0YId0Uj8JznBkhUsnPOQ1gxW93mootzjAlJV1+/nSE5dysS2aU9YiCe7cR04Cgk5OOx9Y
        Khgu9d39YF9lb99VWU6z9mFuKCvoFMDUg4UvGBsRyhSZJaspLi8aUhXOhYRSM1SiVhme1A
        ODb7cJPVZFj8ikqOwsMLz7JOC/OCCCE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-433-YghWtRF-Pmy3VOlvsbEcHg-1; Tue, 30 Aug 2022 08:52:18 -0400
X-MC-Unique: YghWtRF-Pmy3VOlvsbEcHg-1
Received: by mail-wm1-f70.google.com with SMTP id b4-20020a05600c4e0400b003a5a96f1756so10059268wmq.0
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 05:52:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=vv2OrSXgnBFuvHiH/+q9HtCghWxl4Gpfg2D3H7JjXLE=;
        b=Id/QUEjQ3f20y/1t5OJ3PM4T4WczeXyw2rII4Nmpxxf3qqMd56U7hJg2+TBRW1wDE0
         J0lXHIanJTIYFWdBZWdPt4j6gxDoSjeR4kWL5oGJJ5OyX4evYG+Wuqq1NlUfG5zrMMYJ
         NrtSVOmWOyyxU25oOjCcPZgKrBZRX2LCDGFQJNV2tZi4yaR3ieVoZnWuB0GPKoDLJ5u5
         4yvzr6AOgSTamk640lINlvi/0bbs+7PViQw3tNO7GBRJkZ/Db8QVDXSAv5fNFnjHWefq
         yUvUusQHWxg5+V/PuVVTHaSd/NESLnC3GYOduS97UWRrxh31txw+pW12qnPHWdBH+ypi
         gZ2w==
X-Gm-Message-State: ACgBeo3jd/2vJ1UCu3pMzfC90Hz6u2cf0zjBxic0sLrv4jzayO9lMt30
        IwFKQn466vPurZiTZ2hgDx7tg22PdV6PznfKnTUmObYHGzm3zSUS1lzf5UndoSrd3x9Iing414q
        HAduMxr/d3WlR
X-Received: by 2002:a5d:6045:0:b0:226:d21d:947b with SMTP id j5-20020a5d6045000000b00226d21d947bmr8178141wrt.274.1661863937342;
        Tue, 30 Aug 2022 05:52:17 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5KF+t63PS7WCo8FvxObbu+uD0kEWoPOyzQ/K0tpvRnU05EIsR79352NBFNZrkS2uv8ZJKRdg==
X-Received: by 2002:a5d:6045:0:b0:226:d21d:947b with SMTP id j5-20020a5d6045000000b00226d21d947bmr8178128wrt.274.1661863937064;
        Tue, 30 Aug 2022 05:52:17 -0700 (PDT)
Received: from [192.168.0.5] (ip-109-43-176-96.web.vodafone.de. [109.43.176.96])
        by smtp.gmail.com with ESMTPSA id i12-20020a1c540c000000b003a2f2bb72d5sm13315974wmb.45.2022.08.30.05.52.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Aug 2022 05:52:16 -0700 (PDT)
Message-ID: <47fe3036-3566-0118-ac0c-86f4a0d1c838@redhat.com>
Date:   Tue, 30 Aug 2022 14:52:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com
References: <20220830115623.515981-1-nrb@linux.ibm.com>
 <20220830115623.515981-3-nrb@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v1 2/2] s390x: add exittime tests
In-Reply-To: <20220830115623.515981-3-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/08/2022 13.56, Nico Boehr wrote:
> Add a test to measure the execution time of several instructions. This
> can be helpful in finding performance regressions in hypervisor code.
> 
> All tests are currently reported as PASS, since the baseline for their
> execution time depends on the respective environment and since needs to
> be determined on a case-by-case basis.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>   s390x/Makefile      |   1 +
>   s390x/exittime.c    | 258 ++++++++++++++++++++++++++++++++++++++++++++
>   s390x/unittests.cfg |   4 +
>   3 files changed, 263 insertions(+)
>   create mode 100644 s390x/exittime.c
> 
> diff --git a/s390x/Makefile b/s390x/Makefile
> index efd5e0c13102..5dcac244767f 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -34,6 +34,7 @@ tests += $(TEST_DIR)/migration.elf
>   tests += $(TEST_DIR)/pv-attest.elf
>   tests += $(TEST_DIR)/migration-cmm.elf
>   tests += $(TEST_DIR)/migration-skey.elf
> +tests += $(TEST_DIR)/exittime.elf
>   
>   pv-tests += $(TEST_DIR)/pv-diags.elf
>   
> diff --git a/s390x/exittime.c b/s390x/exittime.c
> new file mode 100644
> index 000000000000..dc8329116b77
> --- /dev/null
> +++ b/s390x/exittime.c
> @@ -0,0 +1,258 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Measure run time of various instructions. Can be used to find runtime
> + * regressions of instructions which cause exits.
> + *
> + * Copyright IBM Corp. 2022
> + *
> + * Authors:
> + *  Nico Boehr <nrb@linux.ibm.com>
> + */
> +#include <libcflat.h>
> +#include <smp.h>
> +#include <sclp.h>
> +#include <asm/time.h>
> +#include <asm/sigp.h>
> +#include <asm/interrupt.h>
> +#include <asm/page.h>
> +
> +char pagebuf[PAGE_SIZE] __attribute__((__aligned__(PAGE_SIZE)));
> +
> +static void test_sigp_sense_running(long destcpu)
> +{
> +	smp_sigp(destcpu, SIGP_SENSE_RUNNING, 0, NULL);
> +}
> +
> +static void test_nop(long ignore)
> +{
> +	asm volatile("nop" : : : "memory");
> +}

What's the purpose of testing "nop"? ... it does not trap to the 
hypervisor... ? Is it just for reference? Then a comment might be helpful here.

> +static void test_diag9c(long destcpu)
> +{
> +	asm volatile("diag %[destcpu],0,0x9c"
> +		:
> +		: [destcpu] "d" (destcpu)
> +		:
> +	);
> +}
> +
> +static long setup_get_this_cpuaddr(long ignore)
> +{
> +	return stap();
> +}
> +
> +static void test_diag44(long ignore)
> +{
> +	asm volatile("diag 0,0,0x44" : : : );

Drop the " : : : " please.

> +}
> +
> +static void test_stnsm(long ignore)
> +{
> +	int out;
> +
> +	asm volatile(
> +		"stnsm %[out],0xff"
> +		: [out] "=Q" (out)
> +		:
> +		: "memory"

I don't think you need the "memory" clobber here, do you?

> +	);
> +}
> +
> +static void test_stosm(long ignore)
> +{
> +	int out;
> +
> +	asm volatile(
> +		"stosm %[out],0"
> +		: [out] "=Q" (out)
> +		:
> +		: "memory"

dito

> +	);
> +}
> +
> +static long setup_ssm(long ignore)
> +{
> +	long system_mask = 0;
> +
> +	asm volatile(
> +		"stosm %[system_mask],0"
> +		: [system_mask] "=Q" (system_mask)
> +		:
> +		: "memory"
> +	);
> +
> +	return system_mask;
> +}
> +
> +static void test_ssm(long old_system_mask)
> +{
> +	asm volatile(
> +		"ssm %[old_system_mask]"
> +		:
> +		: [old_system_mask] "Q" (old_system_mask)
> +		:
> +	);
> +}
> +
> +static long setup_lctl4(long ignore)
> +{
> +	long ctl4_orig = 0;
> +
> +	asm volatile(
> +		"stctg 4,4,%[ctl4_orig]"
> +		: [ctl4_orig] "=S" (ctl4_orig)
> +		:
> +		: "memory"
> +	);
> +
> +	return ctl4_orig;
> +}
> +
> +static void test_lctl4(long ctl4_orig)
> +{
> +	asm volatile(
> +		"lctlg 4,4,%[ctl4_orig]"
> +		:
> +		: [ctl4_orig] "S" (ctl4_orig)
> +		:
> +	);
> +}
> +
> +static void test_stpx(long ignore)
> +{
> +	unsigned int prefix;
> +
> +	asm volatile(
> +		"stpx %[prefix]"
> +		: [prefix] "=S" (prefix)

STPX seems to have only a short displacement, so it should have "=Q" instead 
of "=S" ?

> +		:
> +		: "memory"
> +	);
> +}
> +
> +static void test_stfl(long ignore)
> +{
> +	asm volatile(
> +		"stfl 0" : : : "memory"
> +	);
> +}
> +
> +static void test_epsw(long ignore)
> +{
> +	long r1, r2;
> +
> +	asm volatile(
> +		"epsw %[r1], %[r2]"
> +		: [r1] "=d" (r1), [r2] "=d" (r2)
> +		:
> +		:
> +	);
> +}
> +
> +static void test_illegal(long ignore)
> +{
> +	expect_pgm_int();
> +	asm volatile(
> +		".word 0"
> +		:
> +		:
> +		:
> +	);
> +	clear_pgm_int();
> +}
> +
> +static long setup_servc(long arg)
> +{
> +	memset(pagebuf, 0, PAGE_SIZE);
> +	return arg;
> +}
> +
> +static void test_servc(long ignore)
> +{
> +	SCCB *sccb = (SCCB*) pagebuf;
> +	sccb->h.length = 8;
> +	servc(0, (unsigned long) sccb);
> +}
> +
> +static void test_stsi(long fc)
> +{
> +	stsi(pagebuf, fc, 2, 2);
> +}
> +
> +struct test {
> +	char name[100];

"const char *name" instead of using an array here, please. Otherwise this 
wastes a lot of space in the binary.

...
> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
> index f7b1fc3dbca1..c11d1d987c82 100644
> --- a/s390x/unittests.cfg
> +++ b/s390x/unittests.cfg
> @@ -185,3 +185,7 @@ groups = migration
>   [migration-skey]
>   file = migration-skey.elf
>   groups = migration
> +
> +[exittime]
> +file = exittime.elf
> +smp = 2

I wonder whether we should execute this test by default, since nothing can 
fail here? I assume this is rather something that you want to run manually?

  Thomas

