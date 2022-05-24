Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78EBE532A45
	for <lists+kvm@lfdr.de>; Tue, 24 May 2022 14:22:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237320AbiEXMVs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 May 2022 08:21:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237309AbiEXMVq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 May 2022 08:21:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AF2DE4133F
        for <kvm@vger.kernel.org>; Tue, 24 May 2022 05:21:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653394904;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L+chxkVxBobaBchO54kL0l35eGJFFZkX0e4j8J/fk5o=;
        b=jH1TMy9lahLA63PwFPb6YbmOS6Fym2z95+HDHi6p+WKwnUoX6E6MZh2SF9J6Xqb/9QygMM
        1niO40cI1W4uQK4ncVkAInYtVY7+a/nhLNDrWN/dAiZZhvQi4BvE9cPWxJYB06gPuvIreg
        7DL+FEjB3bapsG/Nbg+DpisVRI86JKY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-475-GHuU2NJ_Mx-V0webgRodpw-1; Tue, 24 May 2022 08:21:43 -0400
X-MC-Unique: GHuU2NJ_Mx-V0webgRodpw-1
Received: by mail-wm1-f72.google.com with SMTP id bi5-20020a05600c3d8500b0039489e1d18dso1217060wmb.5
        for <kvm@vger.kernel.org>; Tue, 24 May 2022 05:21:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=L+chxkVxBobaBchO54kL0l35eGJFFZkX0e4j8J/fk5o=;
        b=PkDFqcXfm30kqy4YdzpG1gl5tpd7bwsWweXf5bHVWi4lMegMEcDO90akvLNYCS4xFp
         NG4eyvYRAnLh9LMAx/bOJjegRCwM5hOwvoNcoqu+iY2JhV7h7N2gF2e1E67Cgj2qVIC0
         Hq4rruXYM/eW2NPb7FB8Eaq62VkizSQI6dWrXqAA17pcn9MFxcxIFZnxpogOiU82QuqP
         MYWZxdkc+GtPKbkmskfv/RyT1Je25Dhvft45ezVcpHVDH42fwT8nnpXapDvQXeQ67Woc
         0qb+UvOs0XFyNxAXZt1D9g+iyrGAj/spGTLvlXSNs5M7ngdro7MKxs7XV2ee/W0TlvQu
         dL6Q==
X-Gm-Message-State: AOAM533yE23kcPzdJucoAKN9zCPKDEM58edzsZhWMuGNZa1qALaTER9G
        NQ/EnqT3j0AbL9A2tFHnrL0fDwiXQZFnMlL1QgHFoD+0ST6hFne4Z4AC4/Etxo1pxmB7qbChDfh
        2pRi7W4gHiRhi
X-Received: by 2002:a5d:5541:0:b0:20d:a89:ae21 with SMTP id g1-20020a5d5541000000b0020d0a89ae21mr22830641wrw.176.1653394902387;
        Tue, 24 May 2022 05:21:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz5Cy+AD4DNIJ14qrcQMhIehCeRUlsSnd6d0aoswYqqa1dR7TBGkd3Mzkd5VJzs/Ksd5yBaTw==
X-Received: by 2002:a5d:5541:0:b0:20d:a89:ae21 with SMTP id g1-20020a5d5541000000b0020d0a89ae21mr22830626wrw.176.1653394902192;
        Tue, 24 May 2022 05:21:42 -0700 (PDT)
Received: from [10.33.192.183] (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id v2-20020adfc5c2000000b0020fcd1704a4sm8925748wrg.61.2022.05.24.05.21.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 May 2022 05:21:41 -0700 (PDT)
Message-ID: <9b7b7b08-d66c-7412-8217-c3bbbafd73a0@redhat.com>
Date:   Tue, 24 May 2022 14:21:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH kvm-unit-tests v2 2/2] lib: Add ctype.h and collect is*
 functions
Content-Language: en-US
To:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, nikos.nikoleris@arm.com
References: <20220520132404.700626-1-drjones@redhat.com>
 <20220520132404.700626-3-drjones@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20220520132404.700626-3-drjones@redhat.com>
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
> We've been slowly adding ctype functions to different files without
> even exporting them. Let's change that.
> 
> Reviewed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
...
> diff --git a/lib/ctype.h b/lib/ctype.h
> new file mode 100644
> index 000000000000..0b43d626478a
> --- /dev/null
> +++ b/lib/ctype.h
> @@ -0,0 +1,40 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */

Maybe we should use LGPL for the C library stuff? ... most other libc 
related files use LGPL, too.

Apart from that:
Reviewed-by: Thomas Huth <thuth@redhat.com>

