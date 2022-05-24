Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B7C8532885
	for <lists+kvm@lfdr.de>; Tue, 24 May 2022 13:09:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234837AbiEXLII (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 May 2022 07:08:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232629AbiEXLIH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 May 2022 07:08:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EEACDE0CA
        for <kvm@vger.kernel.org>; Tue, 24 May 2022 04:08:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653390483;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PglnHa3TCxlkJHEEOakoSj8j9d0Ds6HnFOc18PYwcDg=;
        b=HsXObDeFyRMAECrKSNXJXyqq9Pnp3Rh02QMkAJ3P+HqSrvlPWkmSu0H/dlD1a3lhjWUQSD
        WlU/9P1dlMLd6b/RJjaZsOrp8760+7t0SePqmGsHxWalEiWWCb7xJ3M6WKklZPPJTNahqR
        a4uVR7lX1jZJU93Y3mARcXWLRCCcTSc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-441-EUme0NK_OyW82MH8TRyiJw-1; Tue, 24 May 2022 07:08:01 -0400
X-MC-Unique: EUme0NK_OyW82MH8TRyiJw-1
Received: by mail-wm1-f70.google.com with SMTP id j14-20020a05600c1c0e00b003973bf0d146so1145919wms.4
        for <kvm@vger.kernel.org>; Tue, 24 May 2022 04:08:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=PglnHa3TCxlkJHEEOakoSj8j9d0Ds6HnFOc18PYwcDg=;
        b=DPn/Zps0IM6a8M+iBr/NXaXENp0vKvaWZHLQpAZwFfhbR6KhAISDn+BlCtMz90El9c
         VQbEdiq7mAnAxti22lkBIJeh2IKoFFNaOwb9kVtbH2p53f8nx2ZzQclOKKN4aLTxgfn0
         FQB4hkXLumwrA5RjtLSeptRPV78CGBcJwULSOwyZOzqAkhR3bhfkgvza+FcyZlKXaKSt
         IBpM3cs4gbC20NQ35j6ZrzIFbINl5eLSZ+4v5ipYiWxm7RWO4w6VEbdrkwETUJ064Ijn
         3y1BqdRriGGTDtT0dqIZ0NWL5jOvV2c+RLBifb7J3U/fkQDpbgxa7N7vRzI46mhBTRkl
         kcBw==
X-Gm-Message-State: AOAM531dDzVzUOil1FgGVOMwlFuYpSB64craW47wrBzSSOIrbszbnmAD
        KpGXG+4yzhFiS0IAtxCMNOYoJVgToShYhblvle61ITzEJ4vgtndi+1VlIF8LPsbd8TA9cSs+kOs
        hxrlzG0Nn69Hl
X-Received: by 2002:a5d:5957:0:b0:20e:5942:343f with SMTP id e23-20020a5d5957000000b0020e5942343fmr22872289wri.368.1653390480716;
        Tue, 24 May 2022 04:08:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwkaFl8cOuYQZmiXNu5RC1O3od+giHXYBvWx/OpOEbxErFEspQ8RIpWquVPnaOZWFzbbQ39vA==
X-Received: by 2002:a5d:5957:0:b0:20e:5942:343f with SMTP id e23-20020a5d5957000000b0020e5942343fmr22872273wri.368.1653390480487;
        Tue, 24 May 2022 04:08:00 -0700 (PDT)
Received: from [10.33.192.183] (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id z17-20020adfbbd1000000b0020e6470b2a7sm12433171wrg.85.2022.05.24.04.07.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 May 2022 04:07:59 -0700 (PDT)
Message-ID: <85d42f91-2837-c73a-128f-e40de852f780@redhat.com>
Date:   Tue, 24 May 2022 13:07:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v7 06/13] s390x: topology: Adding books to STSI
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, philmd@redhat.com,
        eblake@redhat.com, armbru@redhat.com, seiden@linux.ibm.com,
        nrb@linux.ibm.com, frankja@linux.ibm.com
References: <20220420115745.13696-1-pmorel@linux.ibm.com>
 <20220420115745.13696-7-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20220420115745.13696-7-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/04/2022 13.57, Pierre Morel wrote:
> Let's add STSI support for the container level 3, books,
> and provide the information back to the guest.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
...
> +static char *drawer_bus_get_dev_path(DeviceState *dev)
> +{
> +    S390TopologyDrawer *drawer = S390_TOPOLOGY_DRAWER(dev);
> +    DeviceState *node = dev->parent_bus->parent;
> +    char *id = qdev_get_dev_path(node);
> +    char *ret;
> +
> +    if (id) {
> +        ret = g_strdup_printf("%s:%02d", id, drawer->drawer_id);
> +        g_free(id);
> +    } else {
> +        ret = g_malloc(6);
> +        snprintf(ret, 6, "_:%02d", drawer->drawer_id);

Please use g_strdup_printf() here as well.

  Thomas

> +    }
> +
> +    return ret;
> +}

