Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36DD768BD0F
	for <lists+kvm@lfdr.de>; Mon,  6 Feb 2023 13:39:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbjBFMjj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 07:39:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbjBFMji (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 07:39:38 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6745A22A14
        for <kvm@vger.kernel.org>; Mon,  6 Feb 2023 04:39:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675687144;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Y0Climxmd80gPJCZb9kfYYkitkINiIJLh9XX7tfV0B0=;
        b=aquDf8Nf13gCxCkWWU938sY9MWGPMw81vwLT9d19ZepWXSypW3suCUUQWnTzl9TpZ+nsJa
        r8FsnwTJAMRBam8QkJtxFy13V5Ecr483h/FheX0XUXNAtr3D5Auz6FQduRuHzkiyEnKe0C
        0waarZFkSXpUfBiUrcUzzlflM/9mL9Q=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-625-_k1en066OSGTPYVakGZ1Yw-1; Mon, 06 Feb 2023 07:39:03 -0500
X-MC-Unique: _k1en066OSGTPYVakGZ1Yw-1
Received: by mail-qv1-f69.google.com with SMTP id ly4-20020a0562145c0400b0054d2629a759so5740070qvb.16
        for <kvm@vger.kernel.org>; Mon, 06 Feb 2023 04:39:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Y0Climxmd80gPJCZb9kfYYkitkINiIJLh9XX7tfV0B0=;
        b=Pey/v311Yhwy/xw1CH7OXExbuhpR5qUH7zh3wdHugJ42m6iZwMkmBKUlOsadT4y4dL
         f/yzyoQprGdY2g0nCEBqamhyho9WkMUGqeUo1pupCeSeBC4yISHTty3SI+ERIi+XuXhe
         H3mNaoQ65cqRArFJ/Qk5dx1g8qMyybff+flTfDZ5d8KIVZJ8FA16Qu3GT7zI1yqSiedT
         IhXQ7GxYXnJ2zacqabKXtAb/br1U0BBdvsDjqugOMLEuff4SiHn604j7KuvMGRiXMGK6
         wy9mgai3MSiGffamBhrCqcB2LXvnv8Nq5PwbW8Ov6UhOEw/qZlPxlfDYD5Mmfv6JH0II
         1V7Q==
X-Gm-Message-State: AO0yUKXEp254TDQeW8kR4kpNYfIx2OkiI9r9V3PKZ+RWwfugaBjUnfiJ
        5KXR3lkXtlEczTLtp4W6pGRIJNnDrN9MIlpW053AGB2V2aj1GDzd6rTdTgy3BiE7cO+tzOKnlPi
        LPjlR7pF6oxMN
X-Received: by 2002:a05:622a:491:b0:3b9:bd05:bdf1 with SMTP id p17-20020a05622a049100b003b9bd05bdf1mr32230873qtx.14.1675687142670;
        Mon, 06 Feb 2023 04:39:02 -0800 (PST)
X-Google-Smtp-Source: AK7set8RJUU66GhEeiPWpfV8qSkiLHe6iumVprXheEBwrWwN+C0Y2B4J1cbBOXtModm3cWIW9aXBOA==
X-Received: by 2002:a05:622a:491:b0:3b9:bd05:bdf1 with SMTP id p17-20020a05622a049100b003b9bd05bdf1mr32230838qtx.14.1675687142434;
        Mon, 06 Feb 2023 04:39:02 -0800 (PST)
Received: from [192.168.0.2] (ip-109-43-177-71.web.vodafone.de. [109.43.177.71])
        by smtp.gmail.com with ESMTPSA id o11-20020ac8698b000000b003b9f1b7895asm7120008qtq.10.2023.02.06.04.38.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Feb 2023 04:39:01 -0800 (PST)
Message-ID: <cce946c3-aa78-b9a2-79af-a2cf1ce32355@redhat.com>
Date:   Mon, 6 Feb 2023 13:38:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        nsg@linux.ibm.com, frankja@linux.ibm.com, berrange@redhat.com,
        clg@kaod.org
References: <20230201132051.126868-1-pmorel@linux.ibm.com>
 <20230201132051.126868-10-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH v15 09/11] machine: adding s390 topology to query-cpu-fast
In-Reply-To: <20230201132051.126868-10-pmorel@linux.ibm.com>
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

On 01/02/2023 14.20, Pierre Morel wrote:
> S390x provides two more topology containers above the sockets,
> books and drawers.

books and drawers are already handled via the entries in 
CpuInstanceProperties, so this sentence looks like a wrong leftover now?

I'd suggest talking about "dedication" and "polarity" instead?

> Let's add these CPU attributes to the QAPI command query-cpu-fast.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>   qapi/machine.json          | 13 ++++++++++---
>   hw/core/machine-qmp-cmds.c |  2 ++
>   2 files changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/qapi/machine.json b/qapi/machine.json
> index 3036117059..e36c39e258 100644
> --- a/qapi/machine.json
> +++ b/qapi/machine.json
> @@ -53,11 +53,18 @@
>   #
>   # Additional information about a virtual S390 CPU
>   #
> -# @cpu-state: the virtual CPU's state
> +# @cpu-state: the virtual CPU's state (since 2.12)
> +# @dedicated: the virtual CPU's dedication (since 8.0)
> +# @polarity: the virtual CPU's polarity (since 8.0)
>   #
>   # Since: 2.12
>   ##
> -{ 'struct': 'CpuInfoS390', 'data': { 'cpu-state': 'CpuS390State' } }
> +{ 'struct': 'CpuInfoS390',
> +    'data': { 'cpu-state': 'CpuS390State',
> +              'dedicated': 'bool',
> +              'polarity': 'int'
> +    }
> +}
>   
>   ##
>   # @CpuInfoFast:
> @@ -70,7 +77,7 @@
>   #
>   # @thread-id: ID of the underlying host thread
>   #
> -# @props: properties describing to which node/socket/core/thread
> +# @props: properties describing to which node/drawer/book/socket/core/thread

I think this hunk should rather be moved to patch 1 now.

  Thomas

