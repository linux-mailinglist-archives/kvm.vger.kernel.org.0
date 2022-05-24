Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38C5B532A3A
	for <lists+kvm@lfdr.de>; Tue, 24 May 2022 14:17:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234097AbiEXMRJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 May 2022 08:17:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbiEXMRI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 May 2022 08:17:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E5550814AA
        for <kvm@vger.kernel.org>; Tue, 24 May 2022 05:17:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653394625;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DUFQquvSPiNQ0tgiMVpF2Ez06W4H2V08jlwd1EukDBw=;
        b=aFjWobnUFzyeAwh2pCVNGkRaA0YbKe6SR5+Qbpx7PzttAEPDl++UGIHK8AIAKkbPrj+RGQ
        CR8I/DG+qI2oqOItRCu0Gwua//eW5SZOE9yc+jnQePtJOgXdB8saiMOqilk0IExSLcxHDD
        bcbFF1wkMirZ0InRokPFjWDLlbC59iI=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-45-WgwIy4LGOT2ijaYiqGpQCQ-1; Tue, 24 May 2022 08:17:03 -0400
X-MC-Unique: WgwIy4LGOT2ijaYiqGpQCQ-1
Received: by mail-wr1-f69.google.com with SMTP id m8-20020adfc588000000b0020c4edd8a57so4761931wrg.10
        for <kvm@vger.kernel.org>; Tue, 24 May 2022 05:17:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=DUFQquvSPiNQ0tgiMVpF2Ez06W4H2V08jlwd1EukDBw=;
        b=qLDE1csycInMh7eL5lVFKQCld5rxr7+5wh0ztwlVCm/bjB0qCfkCGnK/EA+MTv8vEJ
         4WvD5Gb67EjCNlFlRbcu+OCPAjiCSqZjWxxP0kEDyOk2qAL4psOK+ALWKJ7Sb+A47k96
         oesTgkxNnRiVVSO0sGYMpdL+OdtSEpYdwuj/ILqoT37t2VQDV4m9TAoigjbzfdN2F7ZD
         6PLAmLV2GyVke5FSNZaFA4stfry+IcFUa0xckEG++YyFR6zHddywvHGTA19AUfqSYIhO
         pMzFR9CRtYmFckUJKlFOFVoJWdkP+C7OXlE2gwVdPcQ0uVhpj3Y4/UukppLa6CXqygX4
         mWlw==
X-Gm-Message-State: AOAM533HiVH+ljGpJDbFv6JgY8zXe9iEfbkaDeznDSB3GLqZJQZ/JJCh
        yAW/Rp39RA2Lyxbww0fP5/MhaO5G5wQ6WJLjagUej70dc92MoQ9d3RdoPvMw2qwKiNK0hAFYVQ2
        E9HZMIbTSnoN/
X-Received: by 2002:a5d:59ad:0:b0:20f:e3bc:c719 with SMTP id p13-20020a5d59ad000000b0020fe3bcc719mr6935454wrr.562.1653394622514;
        Tue, 24 May 2022 05:17:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwxV83OaGO/tX2TCce1cg+6p8d1EZQ2m5MEsSIrQAaUq61cWgdOJo4LWfYNifNgsygLuq1Ogg==
X-Received: by 2002:a5d:59ad:0:b0:20f:e3bc:c719 with SMTP id p13-20020a5d59ad000000b0020fe3bcc719mr6935434wrr.562.1653394622301;
        Tue, 24 May 2022 05:17:02 -0700 (PDT)
Received: from [10.33.192.183] (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id m15-20020adfc58f000000b0020fcf070f61sm8330533wrg.59.2022.05.24.05.17.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 May 2022 05:17:01 -0700 (PDT)
Message-ID: <6a2a808a-e9d9-0e52-d4b6-9cb8034a3fe4@redhat.com>
Date:   Tue, 24 May 2022 14:17:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH kvm-unit-tests v2 1/2] lib: Fix whitespace
Content-Language: en-US
To:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, nikos.nikoleris@arm.com
References: <20220520132404.700626-1-drjones@redhat.com>
 <20220520132404.700626-2-drjones@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20220520132404.700626-2-drjones@redhat.com>
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

On 20/05/2022 15.24, Andrew Jones wrote:
> printf.c and string.c are a couple of the original files and are
> the last that still have the original formatting. Let's finally
> clean them up!
> 
> The change was done by modifying Linux's scripts/Lindent to use
> 100 columns instead of 80 and then manually reverting a few
> changes that I didn't like, which I found by diffing with -b.
> 
> Reviewed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>   lib/printf.c | 427 +++++++++++++++++++++++++--------------------------
>   lib/string.c | 354 +++++++++++++++++++++---------------------
>   2 files changed, 390 insertions(+), 391 deletions(-)

Acked-by: Thomas Huth <thuth@redhat.com>

