Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28875751BC2
	for <lists+kvm@lfdr.de>; Thu, 13 Jul 2023 10:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234568AbjGMIhp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jul 2023 04:37:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234562AbjGMIhT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jul 2023 04:37:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9601A30D0
        for <kvm@vger.kernel.org>; Thu, 13 Jul 2023 01:29:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689236993;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cstQukCc6R5g+iNCjcRka3+OU408qYV+ropA4l/qCyo=;
        b=WFPjuZ+Cz1aDNkRx3CPqkbIADvV+lxCbdBWbzk5g2qwlqP7cT4W8ap21+wFaHIYTUx5wYJ
        +6kXchsHDOxeYfVaz3ho4WQqYTtDgXPjq9rBqe2nkGJNHZf+++5wtVaMEH1gJ6beCmHBzW
        oMr8XQv3eWlKF3oZwwzf1vL44nehWh4=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-266-esioLztkM8Sgc1FSuKvHTQ-1; Thu, 13 Jul 2023 04:29:52 -0400
X-MC-Unique: esioLztkM8Sgc1FSuKvHTQ-1
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7659c6caeaeso65090785a.3
        for <kvm@vger.kernel.org>; Thu, 13 Jul 2023 01:29:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689236991; x=1691828991;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cstQukCc6R5g+iNCjcRka3+OU408qYV+ropA4l/qCyo=;
        b=KqOL/uofh4Z+uCo6BmgljLOrpLdD4ZSid/f/kgedCbYLRrDEP7zvmWLIQu6BzEAplp
         fn+HtZp1GvKSgji8MmQKhgzg9raZORsD8YXZoz04rSSrB+NhMxmSguS27KdW9i5SR+dJ
         fStrXas09OAhIH59En54j4olJ1YikFxs29wGHykuJ8SVMzUZ4Q6H3iRN/GOB1DUoM4D4
         0PHwYR1+5EPeOmK2OJzPfNZOUzlZCIYE/Yuefckjrt4wm/xO1Gu/OLd1JTGzK8s+1jut
         xenNJMLBxSVOcU0mQN6O6uRZP0cEImHgUiUtJbuaL6NkYRmV3KDX37nNTsL6g5X58JLi
         Drjw==
X-Gm-Message-State: ABy/qLaWan89efwQOf0VjSw8jcw9vhlR+zrLVmI1aQptWAJ4mWjuCTAu
        dQJMAeoXl4yI/s2ytRZtuPee3FkY6UapbsVa6Wh2qAPLW9hRW0wBRIIzTGdRbtml2zaP2H2x0IO
        XpTtCDV5oj46M
X-Received: by 2002:a37:f614:0:b0:767:54fd:65b2 with SMTP id y20-20020a37f614000000b0076754fd65b2mr794384qkj.66.1689236991648;
        Thu, 13 Jul 2023 01:29:51 -0700 (PDT)
X-Google-Smtp-Source: APBJJlFjcKctmvnzO/YG+UBJmNHVyxS4u/ME5z1qvrE0d4EZS0E5aAnboTMf5vel0S7sL6thtmUlLg==
X-Received: by 2002:a37:f614:0:b0:767:54fd:65b2 with SMTP id y20-20020a37f614000000b0076754fd65b2mr794378qkj.66.1689236991380;
        Thu, 13 Jul 2023 01:29:51 -0700 (PDT)
Received: from [10.33.192.205] (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id k5-20020a05620a142500b00767cb046e40sm2721587qkj.94.2023.07.13.01.29.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Jul 2023 01:29:50 -0700 (PDT)
Message-ID: <1aac769e-7523-a858-8286-35625bfb0145@redhat.com>
Date:   Thu, 13 Jul 2023 10:29:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [kvm-unit-tests PATCH v5 6/6] s390x: add a test for SIE without
 MSO/MSL
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20230712114149.1291580-1-nrb@linux.ibm.com>
 <20230712114149.1291580-7-nrb@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20230712114149.1291580-7-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/07/2023 13.41, Nico Boehr wrote:
> Since we now have the ability to run guests without MSO/MSL, add a test
> to make sure this doesn't break.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>   s390x/Makefile             |   2 +
>   s390x/sie-dat.c            | 115 +++++++++++++++++++++++++++++++++++++
>   s390x/snippets/c/sie-dat.c |  58 +++++++++++++++++++
>   s390x/unittests.cfg        |   3 +
>   4 files changed, 178 insertions(+)
>   create mode 100644 s390x/sie-dat.c
>   create mode 100644 s390x/snippets/c/sie-dat.c
> 
> diff --git a/s390x/Makefile b/s390x/Makefile
> index a80db538810e..4921669ee4c3 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -40,6 +40,7 @@ tests += $(TEST_DIR)/panic-loop-pgm.elf
>   tests += $(TEST_DIR)/migration-sck.elf
>   tests += $(TEST_DIR)/exittime.elf
>   tests += $(TEST_DIR)/ex.elf
> +tests += $(TEST_DIR)/sie-dat.elf
>   
>   pv-tests += $(TEST_DIR)/pv-diags.elf
>   
> @@ -120,6 +121,7 @@ snippet_lib = $(snippet_asmlib) lib/auxinfo.o
>   # perquisites (=guests) for the snippet hosts.
>   # $(TEST_DIR)/<snippet-host>.elf: snippets = $(SNIPPET_DIR)/<c/asm>/<snippet>.gbin
>   $(TEST_DIR)/mvpg-sie.elf: snippets = $(SNIPPET_DIR)/c/mvpg-snippet.gbin
> +$(TEST_DIR)/sie-dat.elf: snippets = $(SNIPPET_DIR)/c/sie-dat.gbin
>   $(TEST_DIR)/spec_ex-sie.elf: snippets = $(SNIPPET_DIR)/c/spec_ex.gbin
>   
>   $(TEST_DIR)/pv-diags.elf: pv-snippets += $(SNIPPET_DIR)/asm/snippet-pv-diag-yield.gbin
> diff --git a/s390x/sie-dat.c b/s390x/sie-dat.c
> new file mode 100644
> index 000000000000..b326995dfa85
> --- /dev/null
> +++ b/s390x/sie-dat.c
> @@ -0,0 +1,115 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Tests SIE with paging.
> + *
> + * Copyright 2023 IBM Corp.
> + *
> + * Authors:
> + *    Nico Boehr <nrb@linux.ibm.com>
> + */
> +#include <libcflat.h>
> +#include <vmalloc.h>
> +#include <asm/pgtable.h>
> +#include <mmu.h>
> +#include <asm/page.h>
> +#include <asm/interrupt.h>
> +#include <alloc_page.h>
> +#include <sclp.h>
> +#include <sie.h>
> +#include <snippet.h>
> +
> +static struct vm vm;
> +static pgd_t *guest_root;
> +
> +/* keep in sync with TEST_PAGE_COUNT in s390x/snippets/c/sie-dat.c */
> +#define GUEST_TEST_PAGE_COUNT 10
> +
> +/* keep in sync with TOTAL_PAGE_COUNT in s390x/snippets/c/sie-dat.c */
> +#define GUEST_TOTAL_PAGE_COUNT 256

I'd maybe put the defines rather in a header a la s390x/snippets/c/sie-dat.h 
and include that header here and in the snippet C code.

Apart from that, test looks good to me:
Reviewed-by: Thomas Huth <thuth@redhat.com>

