Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F7DC68ED81
	for <lists+kvm@lfdr.de>; Wed,  8 Feb 2023 12:07:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbjBHLHW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Feb 2023 06:07:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbjBHLHU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Feb 2023 06:07:20 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF9814491
        for <kvm@vger.kernel.org>; Wed,  8 Feb 2023 03:06:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675854391;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=THAvMDTpqfQY0OQG1jNe64/m+leegxoPjSY/H415Uh4=;
        b=gYyBJuyCGyG1sIeyRsr+2EA+szbyulzFhkAGZyufGXYm9d5OvgXKdzdce5aAq7GIooCZXU
        LtSiPa8/pqzZYyv/hNUv+15aw9QNar60+gANueyheUIIMAi0EwZGsw0yrBlIJ8WlbkltJJ
        HrYUFFXW/1R09WrBdk7kExOK6WJGbj8=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-486-0LsfHybZN0utReFljCT2Xg-1; Wed, 08 Feb 2023 06:06:29 -0500
X-MC-Unique: 0LsfHybZN0utReFljCT2Xg-1
Received: by mail-qt1-f199.google.com with SMTP id x16-20020ac87ed0000000b003b82d873b38so10581023qtj.13
        for <kvm@vger.kernel.org>; Wed, 08 Feb 2023 03:06:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=THAvMDTpqfQY0OQG1jNe64/m+leegxoPjSY/H415Uh4=;
        b=ZTS8LHeE+ru0jZ+daXW2Y5iXB2gghOTwO7LvgrvDmwpVJFOVNs1hExHC7iT0cRxQN5
         r/4kRu8UDyvBbn5nP6f9KCfaCA+tWI9AbbmsHUkAsAX9ZWGtGQW6Mrf7KNLXw/qxqH+y
         ZrcFV/PbuHFE8BVhYiBygzVthxqgZ4HAUZxZjQKWK1d0/z/qt73bqyVQ/Hg8pjmm5UNO
         Crj2cCulJoOoScKqD4w8vvya8K9crhDegmqh4Hhc64Y0aN/DRwFQlEnFFTzAWiHv3Kbn
         M8kUw7diN+Q5VF2Njh5V5zBIIh6rbg/1ABwHQ6R3IiJEiVOY+3Qb/UlNf2LR20Mm8kMP
         96cA==
X-Gm-Message-State: AO0yUKWrSyyQfbzu0lMR/VUu2RzQDv33fkXZ39IaJZS0AXk3E9liCxlj
        p/hj175pa6qGVbyO2Sx21BXhr0KqiI1pSHd5HHd6SaFj3lzpglZA72+L675tbMy4SS0WXzrNLmr
        rDu8TYl7M/whI
X-Received: by 2002:ad4:5be2:0:b0:56c:38e:9764 with SMTP id k2-20020ad45be2000000b0056c038e9764mr11398035qvc.18.1675854389370;
        Wed, 08 Feb 2023 03:06:29 -0800 (PST)
X-Google-Smtp-Source: AK7set9jDmQNotvUgghlyrPyJkmnIcS5j7P3SoBNrvGSlrtO8f63BdN7LQofeduBzOOqc+OGuNynXw==
X-Received: by 2002:ad4:5be2:0:b0:56c:38e:9764 with SMTP id k2-20020ad45be2000000b0056c038e9764mr11397998qvc.18.1675854389045;
        Wed, 08 Feb 2023 03:06:29 -0800 (PST)
Received: from [192.168.0.2] (ip-109-43-177-253.web.vodafone.de. [109.43.177.253])
        by smtp.gmail.com with ESMTPSA id d3-20020ae9ef03000000b007069fde14a6sm465982qkg.25.2023.02.08.03.06.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Feb 2023 03:06:28 -0800 (PST)
Message-ID: <3a38ca69-ac0a-ce75-4add-256c5996d89c@redhat.com>
Date:   Wed, 8 Feb 2023 12:06:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, kvm@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, nrb@linux.ibm.com, nsg@linux.ibm.com
References: <20230202092814.151081-1-pmorel@linux.ibm.com>
 <20230202092814.151081-2-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v6 1/2] s390x: topology: Check the Perform
 Topology Function
In-Reply-To: <20230202092814.151081-2-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/02/2023 10.28, Pierre Morel wrote:
> We check that the PTF instruction is working correctly when
> the cpu topology facility is available.
> 
> For KVM only, we test changing of the polarity between horizontal
> and vertical and that a reset set the horizontal polarity.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>   s390x/Makefile      |   1 +
>   s390x/topology.c    | 155 ++++++++++++++++++++++++++++++++++++++++++++
>   s390x/unittests.cfg |   3 +
>   3 files changed, 159 insertions(+)
>   create mode 100644 s390x/topology.c
> 
> diff --git a/s390x/Makefile b/s390x/Makefile
> index 52a9d82..b5fe8a3 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -39,6 +39,7 @@ tests += $(TEST_DIR)/panic-loop-extint.elf
>   tests += $(TEST_DIR)/panic-loop-pgm.elf
>   tests += $(TEST_DIR)/migration-sck.elf
>   tests += $(TEST_DIR)/exittime.elf
> +tests += $(TEST_DIR)/topology.elf
>   
>   pv-tests += $(TEST_DIR)/pv-diags.elf
>   
> diff --git a/s390x/topology.c b/s390x/topology.c
> new file mode 100644
> index 0000000..20f7ba2
> --- /dev/null
> +++ b/s390x/topology.c
> @@ -0,0 +1,155 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * CPU Topology
> + *
> + * Copyright IBM Corp. 2022
> + *
> + * Authors:
> + *  Pierre Morel <pmorel@linux.ibm.com>
> + */
> +
> +#include <libcflat.h>
> +#include <asm/page.h>
> +#include <asm/asm-offsets.h>
> +#include <asm/interrupt.h>
> +#include <asm/facility.h>
> +#include <smp.h>
> +#include <sclp.h>
> +#include <s390x/hardware.h>
> +
> +#define PTF_REQ_HORIZONTAL	0
> +#define PTF_REQ_VERTICAL	1
> +#define PTF_REQ_CHECK		2
> +
> +#define PTF_ERR_NO_REASON	0
> +#define PTF_ERR_ALRDY_POLARIZED	1
> +#define PTF_ERR_IN_PROGRESS	2
> +
> +extern int diag308_load_reset(u64);
> +
> +static int ptf(unsigned long fc, unsigned long *rc)
> +{
> +	int cc;
> +
> +	asm volatile(
> +		"       .insn   rre,0xb9a20000,%1,0\n"

Why are you specifying the instruction manually? I think both, GCC and Clang 
should know the "ptf" mnemonic, shouldn't they?

> +		"       ipm     %0\n"
> +		"       srl     %0,28\n"
> +		: "=d" (cc), "+d" (fc)
> +		:
> +		: "cc");
> +
> +	*rc = fc >> 8;
> +	return cc;
> +}
> +
> +static void test_ptf(void)
> +{
> +	unsigned long rc;
> +	int cc;
> +
> +	/* PTF is a privilege instruction */

s/privilege/privileged/ ?

> +	report_prefix_push("Privilege");
> +	enter_pstate();
> +	expect_pgm_int();
> +	ptf(PTF_REQ_CHECK, &rc);
> +	check_pgm_int_code(PGM_INT_CODE_PRIVILEGED_OPERATION);
> +	report_prefix_pop();
> +
> +	report_prefix_push("Wrong fc");
> +	expect_pgm_int();
> +	ptf(0xff, &rc);
> +	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
> +	report_prefix_pop();
> +
> +	report_prefix_push("Reserved bits");
> +	expect_pgm_int();
> +	ptf(0xffffffffffffff00UL, &rc);
> +	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
> +	report_prefix_pop();

This function is quite big ... I'd maybe group the above checks for error 
conditions into a separate function instead.

> +	report_prefix_push("Topology Report pending");
> +	/*
> +	 * At this moment the topology may already have changed
> +	 * since the VM has been started.
> +	 * However, we can test if a second PTF instruction
> +	 * reports that the topology did not change since the
> +	 * preceding PFT instruction.
> +	 */
> +	ptf(PTF_REQ_CHECK, &rc);
> +	cc = ptf(PTF_REQ_CHECK, &rc);
> +	report(cc == 0, "PTF check should clear topology report");
> +	report_prefix_pop();
> +
> +	report_prefix_push("Topology polarisation check");
> +	/*
> +	 * We can not assume the state of the polarization for

s/can not/cannot/ ?

Also, you sometimes write polarization with "z" and sometimes with "s". I'd 
suggest to standardize on "z" (as in "IBM Z" ;-))

> +	 * any Virtual Machine but KVM.
> +	 * Let's skip the polarisation tests for other VMs.
> +	 */
> +	if (!host_is_kvm()) {
> +		report_skip("Topology polarisation check is done for KVM only");
> +		goto end;
> +	}
> +
> +	/*
> +	 * Set vertical polarization to verify that RESET sets
> +	 * horizontal polarization back.
> +	 */
> +	cc = ptf(PTF_REQ_VERTICAL, &rc);
> +	report(cc == 0, "Set vertical polarization.");
> +
> +	report(diag308_load_reset(1), "load normal reset done");
> +
> +	cc = ptf(PTF_REQ_CHECK, &rc);
> +	report(cc == 0, "Reset should clear topology report");
> +
> +	cc = ptf(PTF_REQ_HORIZONTAL, &rc);
> +	report(cc == 2 && rc == PTF_ERR_ALRDY_POLARIZED,
> +	       "After RESET polarization is horizontal");
> +
> +	/* Flip between vertical and horizontal polarization */
> +	cc = ptf(PTF_REQ_VERTICAL, &rc);
> +	report(cc == 0, "Change to vertical polarization.");
> +
> +	cc = ptf(PTF_REQ_CHECK, &rc);
> +	report(cc == 1, "Polarization change should set topology report");
> +
> +	cc = ptf(PTF_REQ_HORIZONTAL, &rc);
> +	report(cc == 0, "Change to horizontal polarization.");
> +
> +end:
> +	report_prefix_pop();
> +}

Apart from the nits, the patch looks fine to me.

  Thomas

