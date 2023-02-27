Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 453D46A429E
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 14:28:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbjB0N2x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 08:28:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbjB0N2s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 08:28:48 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5743D83E3
        for <kvm@vger.kernel.org>; Mon, 27 Feb 2023 05:28:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677504483;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YmlhivxPyn41yfCley82zJJmLNnrUbgrLTlucDsjrt8=;
        b=dg5maO3+BIt2KbDnoKjrmCoKL64I6Xil0Q2i6CkMtt97xT+vkJVc/GTzCW+CJxBc0hHV4d
        17tg2DlT3nwHrwp5/zn18G/uj5lCDXK1dsHYK6Ei2q+FZjo9zBHDm+y68HXSpBwvvku+Hy
        lleGYyiH0lbItXPek6M5Nh8+aVAL6uw=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-475-7AHaKCM0My6hf100ljVOWw-1; Mon, 27 Feb 2023 08:28:02 -0500
X-MC-Unique: 7AHaKCM0My6hf100ljVOWw-1
Received: by mail-wr1-f70.google.com with SMTP id o15-20020a05600002cf00b002c54a27803cso846349wry.22
        for <kvm@vger.kernel.org>; Mon, 27 Feb 2023 05:28:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YmlhivxPyn41yfCley82zJJmLNnrUbgrLTlucDsjrt8=;
        b=bnBET76voGOFnI4NeTbhIh8FgFyh8u4jpe2ItvOKnodyrCxZDRcf2KKeXN8Y+UMATN
         Gy8CpOgXk7fI6Fimfi9li7vSsrNFaoj7IjrxuIMjydivXZpYg2tJBtGii2/kwECkLu7U
         z++WNHBGue85bTS5uweiG/09L/6PD8ro+OvlV7X2Ae9YyojeNAeczNHUQOK+Pz9OL/Y2
         JLS2MMeAsL53ArJjsnrNgV03YXnm+2Mxz9Z2FDuj3Kkmu+jotvjVGFxf8wgIiVQR4ZXH
         COr1bxufeqkJz1R8DLx+U6I/7ThtjgV+RrwNJ622E72ZWPRJ+pQKjPx03/HvAoq4ZD+D
         X4ig==
X-Gm-Message-State: AO0yUKVrdn4By7ED7ReKmvLR5GHg3tZBgncBUVtsHae1BVoBiS9npXVP
        xODP37AzWPga9q0jRVfEixTg3ipraDm6TJ28zfRsEHH6+iiOrgW3EFL/on6nUZ7WllyoDRJ+5Jf
        xoLu2iEwAkyhK
X-Received: by 2002:a05:600c:818:b0:3dc:5390:6499 with SMTP id k24-20020a05600c081800b003dc53906499mr13658596wmp.1.1677504480833;
        Mon, 27 Feb 2023 05:28:00 -0800 (PST)
X-Google-Smtp-Source: AK7set8j17rihmR4PnRjPZNfIiGsZQncvoBmO3R1RfbNlYVcX3HsAHTzsNmwUFsPQa1kL1FyJcYnlQ==
X-Received: by 2002:a05:600c:818:b0:3dc:5390:6499 with SMTP id k24-20020a05600c081800b003dc53906499mr13658575wmp.1.1677504480584;
        Mon, 27 Feb 2023 05:28:00 -0800 (PST)
Received: from [192.168.0.2] (ip-109-43-176-150.web.vodafone.de. [109.43.176.150])
        by smtp.gmail.com with ESMTPSA id l21-20020a1c7915000000b003e21ba8684dsm8942230wme.26.2023.02.27.05.27.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Feb 2023 05:28:00 -0800 (PST)
Message-ID: <6db3c0bd-ce65-1d23-ca6c-ee4a6fb60dbf@redhat.com>
Date:   Mon, 27 Feb 2023 14:27:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v16 09/11] machine: adding s390 topology to query-cpu-fast
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        nsg@linux.ibm.com, frankja@linux.ibm.com, berrange@redhat.com,
        clg@kaod.org
References: <20230222142105.84700-1-pmorel@linux.ibm.com>
 <20230222142105.84700-10-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20230222142105.84700-10-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/02/2023 15.21, Pierre Morel wrote:
> S390x provides two more topology attributes, entitlement and dedication.
> 
> Let's add these CPU attributes to the QAPI command query-cpu-fast.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> Reviewed-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
> ---
>   qapi/machine.json          | 9 ++++++++-
>   hw/core/machine-qmp-cmds.c | 2 ++
>   2 files changed, 10 insertions(+), 1 deletion(-)

Reviewed-by: Thomas Huth <thuth@redhat.com>

