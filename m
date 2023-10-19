Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F6947CF60F
	for <lists+kvm@lfdr.de>; Thu, 19 Oct 2023 13:04:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345280AbjJSLEV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Oct 2023 07:04:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233155AbjJSLEU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Oct 2023 07:04:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8FD0FA
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 04:03:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697713416;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=1oLThQA7BoG9TrrlukhY6YwYjjcU/Mz40wCk9uHQpIc=;
        b=gIOS2cZZNzHbBWkVQT2iwg2hrkINL5RhWOsU+IJbTppCovbNIqTsDallcmTdiM34mu46O1
        1A/APGn9+/d92CaQoHSHXmIedVvYdM0qHJsA+L7jegsYhP6HgpCuN9ttAI/i98NkX4ObXy
        G9sza+HgG8g8naN5LbzwvNuMUpc1WFs=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-348-SCQO9Lx1PuKCQfK0fsbfQw-1; Thu, 19 Oct 2023 07:03:34 -0400
X-MC-Unique: SCQO9Lx1PuKCQfK0fsbfQw-1
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-7788fb06a43so257524485a.1
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 04:03:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697713414; x=1698318214;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1oLThQA7BoG9TrrlukhY6YwYjjcU/Mz40wCk9uHQpIc=;
        b=TSwMr1OsDMbL9ypAMqNKXLavylzdmVrm2Ge6IcU6q/e9CctP3/JLD5O3+DAV6GGi2x
         82GbJ0ZlKnEFZbW2PKAhcUYkMKyTzhfNd1cElNIPp8057+bstEafLuAg6ThFhHlWTNtj
         +lbZouCOSzbtHMsbzueKtELCG/mk2SC0OOJG0lV/w5t+t9Ay8V5fcQ07X3oqQNReC2Wy
         xLL12CZjEAjjpYaPquSKsT2hnlnnGCDeIkxj6+BOOzTrp75HnqhTjHKyce9OaTSC4I0c
         Yhat2A8iEwNxesxn+uXRQOct8mN0UVcGOx6VWSyAj59RK1t6r5JuJj40JLuSNPBKaC97
         Ef1w==
X-Gm-Message-State: AOJu0YxRNt1FTYXLep5YBDc6eajqQ6mNEFWFe1q4JiOfZmVHEATBH/cp
        StKziAXAlAetKdYVYXn+uyDLQxXx6Bt3tds8zoeUME2dS0oDj3WnHtt72OA7bJ+oB0TLIb631CT
        ApkgKLxzmMOOx
X-Received: by 2002:a05:6214:300f:b0:658:8f94:5e61 with SMTP id ke15-20020a056214300f00b006588f945e61mr1869260qvb.43.1697713414165;
        Thu, 19 Oct 2023 04:03:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEEIN22pIwoGMlPi4MdidjtdTo2+V3WNcldbTz7yWQ8AxhGyCJshvoazbLvE+wZx3aify8baA==
X-Received: by 2002:a05:6214:300f:b0:658:8f94:5e61 with SMTP id ke15-20020a056214300f00b006588f945e61mr1869248qvb.43.1697713413927;
        Thu, 19 Oct 2023 04:03:33 -0700 (PDT)
Received: from [192.168.0.5] (ip-109-43-176-141.web.vodafone.de. [109.43.176.141])
        by smtp.gmail.com with ESMTPSA id mk12-20020a056214580c00b0065b151d5d12sm690832qvb.126.2023.10.19.04.03.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Oct 2023 04:03:33 -0700 (PDT)
Message-ID: <25e03ac5-19d4-41c1-82b1-5821433bf5b8@redhat.com>
Date:   Thu, 19 Oct 2023 13:03:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v2 1/7] lib: s390x: Add ap library
Content-Language: en-US
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     imbrenda@linux.ibm.com, david@redhat.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com
References: <20231010084936.70773-1-frankja@linux.ibm.com>
 <20231010084936.70773-2-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20231010084936.70773-2-frankja@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/10/2023 10.49, Janosch Frank wrote:
> Add functions and definitions needed to test the Adjunct
> Processor (AP) crypto interface.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>   lib/s390x/ap.c | 92 ++++++++++++++++++++++++++++++++++++++++++++++++++
>   lib/s390x/ap.h | 88 +++++++++++++++++++++++++++++++++++++++++++++++
>   s390x/Makefile |  1 +
>   3 files changed, 181 insertions(+)
>   create mode 100644 lib/s390x/ap.c
>   create mode 100644 lib/s390x/ap.h
> 
> diff --git a/lib/s390x/ap.c b/lib/s390x/ap.c
> new file mode 100644
> index 00000000..4af3cdee
> --- /dev/null
> +++ b/lib/s390x/ap.c
...
> +bool ap_check(void)
> +{
> +	/*
> +	 * Base AP support has no STFLE or SCLP feature bit but the
> +	 * PQAP QCI support is indicated via stfle bit 12. As this
> +	 * library relies on QCI we bail out if it's not available.
> +	 */
> +	if (!test_facility(12))
> +		return false;
> +
> +	return true;
> +}

Easier:

	return test_facility(12);

... but with that in mind, I wonder why you need a wrapper function for this 
at all - why not simply checking test_facility(12) at the calling side instead?

  Thomas

