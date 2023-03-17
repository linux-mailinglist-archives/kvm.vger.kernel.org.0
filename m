Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A7376BE8EC
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 13:12:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbjCQMMR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 08:12:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbjCQMMO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 08:12:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFB7D1C30D
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 05:11:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679055085;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VdyWJZv8vhAFDbVlVpAgxslKT4rLXftuJGVINjtZsvM=;
        b=aJDcFbUROquPXUKo9w8C56fBPn8iu5IzU+OUyjszX+NGEkTDr5tXIA8icom4bTK/ezK5BM
        Ho5UcR9qX+ghLZgIEAjky0A2f44CYCw+ltOb+YUUYhrNdvdfKjXq+u8HGlXUtlWsTVThEt
        R9kU+VLDSVAsRVNW+6c9qCxXT6OyQz8=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-501-Hx89QbqtNK6cT1JnAVyMrA-1; Fri, 17 Mar 2023 08:11:24 -0400
X-MC-Unique: Hx89QbqtNK6cT1JnAVyMrA-1
Received: by mail-wm1-f71.google.com with SMTP id p21-20020a05600c1d9500b003ed34032a01so2188588wms.2
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 05:11:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679055083;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VdyWJZv8vhAFDbVlVpAgxslKT4rLXftuJGVINjtZsvM=;
        b=CF7IvQ85cX4ZqHKF1LvHneE7r3yJeN502mniCmevtAuNQcjNci/0WiEIt1yubY4s8K
         ug62OadBFZ0FCdmgYCyAsvdXSu01T0GmaGQLrR/ObybzLP/vcFTDh/b3rgUSdyHcwiyu
         RZq4KBUPiOV/pyez3SJMbsqOUOsq00FLg/f7qnBXXn693pPhssrKUiXGP+IgID0C4+QP
         Cjz8nu6H9ZnMBt6UELzddZRQ9QvJgIcJu8c5SwYdgTLHxzhBZjEtyzdCxqoLR4U2Kuwa
         l+M9I/uf7dHSrXZb3n+wOozEqT6NrySLw9puMzGb/aLlzQMwFdDh71Aepqb0ToDvpNz/
         nPsA==
X-Gm-Message-State: AO0yUKXbp3gSTVLdBMDptPPQNREl1AHci11hmQqiXSy/JeK4QO5xdja7
        q1GIGpd8Vp27uVxcPGt5Pqck4+Q6AjokamUfdateMbBWNDEGSdUftGFn9F0BeyyQzhXX1UcEgEw
        0iiutW5dBunW3
X-Received: by 2002:a05:6000:110a:b0:2ce:a93d:41a7 with SMTP id z10-20020a056000110a00b002cea93d41a7mr6815322wrw.40.1679055083545;
        Fri, 17 Mar 2023 05:11:23 -0700 (PDT)
X-Google-Smtp-Source: AK7set+Drn8o6/nNTBEgK8SgVpgvMd4RO9wUeVwEOco0AOkK3H0Ve2COt2l+fdAqjqS7xNs1SwZQWg==
X-Received: by 2002:a05:6000:110a:b0:2ce:a93d:41a7 with SMTP id z10-20020a056000110a00b002cea93d41a7mr6815266wrw.40.1679055083247;
        Fri, 17 Mar 2023 05:11:23 -0700 (PDT)
Received: from [192.168.0.3] (ip-109-43-176-33.web.vodafone.de. [109.43.176.33])
        by smtp.gmail.com with ESMTPSA id u4-20020a5d4344000000b002c5526234d2sm1861459wrr.8.2023.03.17.05.11.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Mar 2023 05:11:22 -0700 (PDT)
Message-ID: <5f003318-c22d-b13b-3976-94b0f874c720@redhat.com>
Date:   Fri, 17 Mar 2023 13:11:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v2 06/32] include/qemu: add documentation for memory
 callbacks
Content-Language: en-US
To:     =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        qemu-devel@nongnu.org
Cc:     Akihiko Odaki <akihiko.odaki@gmail.com>,
        =?UTF-8?Q?Marc-Andr=c3=a9_Lureau?= <marcandre.lureau@redhat.com>,
        qemu-riscv@nongnu.org, Riku Voipio <riku.voipio@iki.fi>,
        Igor Mammedov <imammedo@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Hao Wu <wuhaotsh@google.com>, Cleber Rosa <crosa@redhat.com>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        Jan Kiszka <jan.kiszka@web.de>,
        Aurelien Jarno <aurelien@aurel32.net>, qemu-arm@nongnu.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Alexandre Iooss <erdnaxe@crans.org>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>, qemu-ppc@nongnu.org,
        Juan Quintela <quintela@redhat.com>,
        =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>,
        Darren Kenny <darren.kenny@oracle.com>, kvm@vger.kernel.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        Stafford Horne <shorne@gmail.com>,
        Weiwei Li <liweiwei@iscas.ac.cn>,
        Sunil V L <sunilvl@ventanamicro.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Vijai Kumar K <vijai@behindbytes.com>,
        Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Song Gao <gaosong@loongson.cn>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Niek Linnenbank <nieklinnenbank@gmail.com>,
        Greg Kurz <groug@kaod.org>, Laurent Vivier <laurent@vivier.eu>,
        Qiuhao Li <Qiuhao.Li@outlook.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        Xiaojuan Yang <yangxiaojuan@loongson.cn>,
        Mahmoud Mandour <ma.mandourr@gmail.com>,
        Alexander Bulekov <alxndr@bu.edu>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>, qemu-block@nongnu.org,
        Yanan Wang <wangyanan55@huawei.com>,
        David Woodhouse <dwmw2@infradead.org>, qemu-s390x@nongnu.org,
        Strahinja Jankovic <strahinja.p.jankovic@gmail.com>,
        Bandan Das <bsd@redhat.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Tyrone Ting <kfting@nuvoton.com>,
        Kevin Wolf <kwolf@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Beraldo Leal <bleal@redhat.com>,
        Beniamino Galvani <b.galvani@gmail.com>,
        Paul Durrant <paul@xen.org>, Bin Meng <bin.meng@windriver.com>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Hanna Reitz <hreitz@redhat.com>, Peter Xu <peterx@redhat.com>
References: <20230315174331.2959-1-alex.bennee@linaro.org>
 <20230315174331.2959-7-alex.bennee@linaro.org>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20230315174331.2959-7-alex.bennee@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/03/2023 18.43, Alex Bennée wrote:
> Some API documentation was missed, rectify that.
> 
> Fixes: https://gitlab.com/qemu-project/qemu/-/issues/1497
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> ---
>   include/qemu/qemu-plugin.h | 47 ++++++++++++++++++++++++++++++++++----
>   1 file changed, 43 insertions(+), 4 deletions(-)

Reviewed-by: Thomas Huth <thuth@redhat.com>

