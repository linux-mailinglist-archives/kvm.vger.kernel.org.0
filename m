Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18D2D638B83
	for <lists+kvm@lfdr.de>; Fri, 25 Nov 2022 14:46:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbiKYNqz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Nov 2022 08:46:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbiKYNqw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Nov 2022 08:46:52 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C31D529802
        for <kvm@vger.kernel.org>; Fri, 25 Nov 2022 05:45:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669383957;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E4cnPeVektJaCUeRSPOOJqZFTmEwNHTq46ruSi38mqU=;
        b=RZVWMfz/wchOEh+/xE6fXQ7hsBR0KkkgudDFl3GCh71i0ZerAIFEuh1O9EzHV34/jPTWJF
        hm6OctRdIfBfebxEaLIb2ogfru+qtSFOP7HDoqBNTFybS05xdc8McTLgVapUE1IeF2/QgM
        MRaC1I3nOsOhZcUZ2/CNCVWQUtFWFLY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-672-xDOtqfNJNniwIU1VYEAj7A-1; Fri, 25 Nov 2022 08:45:56 -0500
X-MC-Unique: xDOtqfNJNniwIU1VYEAj7A-1
Received: by mail-wm1-f72.google.com with SMTP id 1-20020a05600c028100b003cf7833293cso4221968wmk.3
        for <kvm@vger.kernel.org>; Fri, 25 Nov 2022 05:45:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E4cnPeVektJaCUeRSPOOJqZFTmEwNHTq46ruSi38mqU=;
        b=QbI9aieiuqx/t4BG5hUJ42oKjo2boIZ0qnqsGToS2Y9UM1Wy34TywLjoGiJnVpo2fR
         2kLkwl0f76k9L7199KTjcypRQgz6MkM9a9TsEFqPeY2z6AXzrbaUFfZQI9aXe6PRavdn
         K1e27v3S52pMXibEIG1m5+MVNGgSquQL8Dg48/fwD76AG2PTzC61jLqYdUzq8LvmiZdL
         psRchWdlO+gotzRK4DH5xaFvWfhDrLTYZGArvfxnIi0FwOfo4LC823albw/tH3Dd6XbX
         kfuBJSBn9McrQCLCEr34nGyR3JIFtrbHV01bcGrh08rwK5HYKVB7hjAu1LJaE1buXBj9
         Fj9A==
X-Gm-Message-State: ANoB5pk+t+tdxQVkhgle5hyAFQ0UktvdPm5KXagCoD+fAMQquJakAL8C
        GPe9khk9aoAyiWJQfU4QdQRrK+ihd/AQ5XH5rzlfQpWBtYRpagQjecyV8U8Fej4U1XQ4AsK5OOO
        l2Dk28BgKdNxq
X-Received: by 2002:a5d:544f:0:b0:241:d7b1:470f with SMTP id w15-20020a5d544f000000b00241d7b1470fmr13127632wrv.500.1669383955183;
        Fri, 25 Nov 2022 05:45:55 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4T5D0t8w/n8pgTfO5lELktTVN5Gq7QrEbvgy01en6auao0QTJHwfgl9aBjibyEKr3o987dKw==
X-Received: by 2002:a5d:544f:0:b0:241:d7b1:470f with SMTP id w15-20020a5d544f000000b00241d7b1470fmr13127614wrv.500.1669383954922;
        Fri, 25 Nov 2022 05:45:54 -0800 (PST)
Received: from [192.168.0.5] (ip-109-43-176-41.web.vodafone.de. [109.43.176.41])
        by smtp.gmail.com with ESMTPSA id o5-20020a05600c510500b003b4ff30e566sm15445024wms.3.2022.11.25.05.45.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Nov 2022 05:45:54 -0800 (PST)
Message-ID: <2cc74b33-1b29-c77f-960f-e1c3b35ae47f@redhat.com>
Date:   Fri, 25 Nov 2022 14:45:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com
References: <20221124134429.612467-1-nrb@linux.ibm.com>
 <20221124134429.612467-2-nrb@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v2 1/2] s390x: add a library for
 CMM-related functions
In-Reply-To: <20221124134429.612467-2-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/11/2022 14.44, Nico Boehr wrote:
> Upcoming changes will add a test which is very similar to the existing
> CMM migration test. To reduce code duplication, move the common function
> to a library which can be re-used by both tests.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>   lib/s390x/cmm.c       | 90 +++++++++++++++++++++++++++++++++++++++++++
>   lib/s390x/cmm.h       | 31 +++++++++++++++
>   s390x/Makefile        |  1 +
>   s390x/migration-cmm.c | 34 ++++------------
>   4 files changed, 130 insertions(+), 26 deletions(-)
>   create mode 100644 lib/s390x/cmm.c
>   create mode 100644 lib/s390x/cmm.h
> 
> diff --git a/lib/s390x/cmm.c b/lib/s390x/cmm.c
> new file mode 100644
> index 000000000000..5da02fe628f9
> --- /dev/null
> +++ b/lib/s390x/cmm.c
> @@ -0,0 +1,90 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * CMM test library
> + *
> + * Copyright IBM Corp. 2022
> + *
> + * Authors:
> + *  Nico Boehr <nrb@linux.ibm.com>
> + */
> +#include <libcflat.h>
> +#include <bitops.h>
> +#include "cmm.h"
> +
> +/*
> + * Maps ESSA actions to states the page is allowed to be in after the
> + * respective action was executed.
> + */
> +const int allowed_essa_state_masks[4] = {

Could be declared as "static const int ...", I guess?

Apart from that nit:
Reviewed-by: Thomas Huth <thuth@redhat.com>

