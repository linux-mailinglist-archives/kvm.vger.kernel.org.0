Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C1FA4FC0C0
	for <lists+kvm@lfdr.de>; Mon, 11 Apr 2022 17:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347772AbiDKPeQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 11:34:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348124AbiDKPdG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 11:33:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2AD5D32EF7
        for <kvm@vger.kernel.org>; Mon, 11 Apr 2022 08:30:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649691051;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hV5Dyv1C11+higGhHQ1ZLcKGjBUwcNJfErNJD+t36JU=;
        b=Q8HRfLorwmlc9+Egac7qs8INM1OsZA62ABGSvccF0yekNsd+KiHgtEYAh0sXv/0KTQYEGM
        BMy9ZX9wo3598N+OM6sDvnSPGDOj8pV8xe/zJasm54176EVxFErR9eXgWLmYH+sq7qIjdG
        uRiFzI4OjbqZqTRrRf6wwTKhC7CQouE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-376-coUiz-l1MW25R9A3xBnV1Q-1; Mon, 11 Apr 2022 11:30:50 -0400
X-MC-Unique: coUiz-l1MW25R9A3xBnV1Q-1
Received: by mail-wm1-f70.google.com with SMTP id c62-20020a1c3541000000b0038ec265155fso403674wma.6
        for <kvm@vger.kernel.org>; Mon, 11 Apr 2022 08:30:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=hV5Dyv1C11+higGhHQ1ZLcKGjBUwcNJfErNJD+t36JU=;
        b=NpwQoET8T4ppEYzSmpkczGCtvbmKaSzWsbHIo+TK9Yj8NWbk6ZCGn85viiWKLPnpbw
         M468Z2qb4U5BfA3I4L2aXv3blE6LBLa0YnfAkFzspeXDAdk9L5C8JsXzuwqVgvW8E/Lv
         BtFG6NqUSV0G2ZqrHziUu2YcIafdLmXXv0Zar7P7y+25ffd+8+9rdpBXVm7/Il8pf//9
         HXpU0s46yfPtscEdKPD/sQrENcH+35l5AO02J9jxQCz5fhLwp1ptR3AGdVueMQWz1meE
         4MruKw4N6GJwrbZaZHXgw8x+RVfuAUUryup/dDLbX7239+B0Mh+X1GniIgm79UflLvaF
         uz+w==
X-Gm-Message-State: AOAM530XAbMLIps7SUVZWDVLeuNoOk435PccbOOp/zlsbTuLe0vL5m6Y
        1WCN4yRvAvbS8KRcHjfFcJ2yUvzq0psleV0twGmUdR1VNzSxlCsWayXsrmZO6XqBzEPf5W9PNPZ
        6Y0wEF1boFEsz
X-Received: by 2002:a5d:6d0d:0:b0:207:8b9b:e38 with SMTP id e13-20020a5d6d0d000000b002078b9b0e38mr15986245wrq.166.1649691048875;
        Mon, 11 Apr 2022 08:30:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyUFQGby0QUPjBNszAuAeDrQZiOPCv95kxxG89l+OJftEWcZRW1RlMAnSnyoNbwseB0RKglxg==
X-Received: by 2002:a5d:6d0d:0:b0:207:8b9b:e38 with SMTP id e13-20020a5d6d0d000000b002078b9b0e38mr15986235wrq.166.1649691048646;
        Mon, 11 Apr 2022 08:30:48 -0700 (PDT)
Received: from [192.168.8.100] (tmo-080-174.customers.d1-online.com. [80.187.80.174])
        by smtp.gmail.com with ESMTPSA id m20-20020a05600c3b1400b0038ebbbb2ad2sm3183159wms.44.2022.04.11.08.30.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Apr 2022 08:30:48 -0700 (PDT)
Message-ID: <5073d0fc-1017-5be6-2ec5-2709be14c93c@redhat.com>
Date:   Mon, 11 Apr 2022 17:30:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [kvm-unit-tests PATCH v1 4/4] s390x: add selftest for migration
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com
References: <20220411100750.2868587-1-nrb@linux.ibm.com>
 <20220411100750.2868587-5-nrb@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20220411100750.2868587-5-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/04/2022 12.07, Nico Boehr wrote:
> Add a selftest to check we can do migration tests.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>   s390x/Makefile             |  1 +
>   s390x/selftest-migration.c | 27 +++++++++++++++++++++++++++
>   s390x/unittests.cfg        |  4 ++++
>   3 files changed, 32 insertions(+)
>   create mode 100644 s390x/selftest-migration.c
> 
> diff --git a/s390x/Makefile b/s390x/Makefile
> index 62e197cb93d7..2e43e323bcb5 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -26,6 +26,7 @@ tests += $(TEST_DIR)/edat.elf
>   tests += $(TEST_DIR)/mvpg-sie.elf
>   tests += $(TEST_DIR)/spec_ex-sie.elf
>   tests += $(TEST_DIR)/firq.elf
> +tests += $(TEST_DIR)/selftest-migration.elf
>   
>   pv-tests += $(TEST_DIR)/pv-diags.elf
>   
> diff --git a/s390x/selftest-migration.c b/s390x/selftest-migration.c
> new file mode 100644
> index 000000000000..8884322a84ca
> --- /dev/null
> +++ b/s390x/selftest-migration.c
> @@ -0,0 +1,27 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Migration Selftest
> + *
> + * Copyright IBM Corp. 2022
> + *
> + * Authors:
> + *  Nico Boehr <nrb@linux.ibm.com>
> + */
> +#include <libcflat.h>
> +
> +int main(void)
> +{
> +	/* don't say migrate here otherwise we will migrate right away */
> +	report_prefix_push("selftest migration");
> +
> +	/* ask migrate_cmd to migrate (it listens for 'migrate') */
> +	puts("Please migrate me\n");
> +
> +	/* wait for migration to finish, we will read a newline */
> +	(void)getchar();
> +
> +	report_pass("Migrated");
> +
> +	report_prefix_pop();
> +	return report_summary();
> +}

Thanks for tackling this!

Having written powerpc/sprs.c in the past, I've got one question / request:

Could we turn this into a "real" test immediately? E.g. write a sane value 
to all control registers that are currently not in use by the k-u-t before 
migration, and then check whether the values are still in there after 
migration? Maybe also some vector registers and the "guarded storage control"?
... or is this rather something for a later update?

  Thomas

