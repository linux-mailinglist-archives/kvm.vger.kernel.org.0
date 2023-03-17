Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04E766BE1DD
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 08:25:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbjCQHZj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 03:25:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230308AbjCQHZ0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 03:25:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 631AB37569
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 00:24:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679037877;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xW5YRWUqoI7YaHI7gPZKm4zvNmnVkp4WxZPUXFEvJBo=;
        b=OnDUM4ca2p/TJYhsHtnYSvFbnWlXbO5i6hGFsmuk7AQBj/mfd3vZZQ33Gjfb+Tb76tW3la
        pup2VhwgRTcOuDOgB4HkRgKL04ZyMWznPmJvAOi0KYdQxhgTuDlbBbF6fr/jyuPK8MSGMn
        Z2GkYYpcIsGO1T50laN6BD5OnPIPWvY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-367-3iQg6cx3MvuAuskM3JSXtw-1; Fri, 17 Mar 2023 03:24:35 -0400
X-MC-Unique: 3iQg6cx3MvuAuskM3JSXtw-1
Received: by mail-wm1-f69.google.com with SMTP id n38-20020a05600c3ba600b003ed29a0b729so1873289wms.9
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 00:24:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679037874;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xW5YRWUqoI7YaHI7gPZKm4zvNmnVkp4WxZPUXFEvJBo=;
        b=AuU8Xgn/bAS6fhqA30n8aTm2QRurW0gQGkwILQmzj16uun5ooIYTVcbbX4+jPE3gwo
         yBMkOVsRSjR9kYVYnsTeR1GNZa1bE+vF2Vav3PFiEp/3xCXoDlh3gw4VyeApX2E3PlMc
         dcv5VTnB2nk/KuiMNh9JsGQNzhLAVs9QxbTsAng/ilsTSb9U2lDFa/1gBjR9ziS99pA8
         2rDDb4N5VHdm20zoAJ3bOcbLQo/1NqCZoK44R27NvXqew6PLDDOdXSmvfNIAS0k3ANCd
         22Wau70Y2UdGEg7NJMIVKX2kyGb1RhkwKMaB2ofxq2GUvq+X9D2OE9Zmlv2uoT2fWaa6
         Qwmw==
X-Gm-Message-State: AO0yUKWemqYrolImtKSXYbdElmGQx0CbOsHnuwEtRr3hHfktvbQ7tYB3
        OxOPzSiKrPzmw0L26jHaudTiPDisgDw7ymwjAF891V428fB9XiHHo6hpgQdZlVrn3fGJsfuu1LI
        G+IlbQjYb7AR5
X-Received: by 2002:a5d:4d06:0:b0:2c7:daa:1c56 with SMTP id z6-20020a5d4d06000000b002c70daa1c56mr5851951wrt.4.1679037874684;
        Fri, 17 Mar 2023 00:24:34 -0700 (PDT)
X-Google-Smtp-Source: AK7set+aVAxUwOvFA/ilN/jNay4xxCe5XpeNTShUolDwE3ogiowCBRVEg+sW7qmY2hMDnR5uIw2AZQ==
X-Received: by 2002:a5d:4d06:0:b0:2c7:daa:1c56 with SMTP id z6-20020a5d4d06000000b002c70daa1c56mr5851904wrt.4.1679037874240;
        Fri, 17 Mar 2023 00:24:34 -0700 (PDT)
Received: from [192.168.0.3] (ip-109-43-176-33.web.vodafone.de. [109.43.176.33])
        by smtp.gmail.com with ESMTPSA id y1-20020a5d4ac1000000b002ceaeb24c0asm1262440wrs.58.2023.03.17.00.24.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Mar 2023 00:24:32 -0700 (PDT)
Message-ID: <95ef3696-f934-376e-ee88-687477a32242@redhat.com>
Date:   Fri, 17 Mar 2023 08:24:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v2 05/32] gitlab: update centos-8-stream job
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
        Thomas Huth <huth@tuxfamily.org>,
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
 <20230315174331.2959-6-alex.bennee@linaro.org>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20230315174331.2959-6-alex.bennee@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/03/2023 18.43, Alex Bennée wrote:
> A couple of clean-ups here:
> 
>    - inherit from the custom runners job for artefacts

I know, it's a difference between BE and AE, but in case you want to be 
consistent with the yml: s/artefacts/artifacts/

>    - call check-avocado directly
>    - add some comments to the top about setup
> 
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> ---
>   .../custom-runners/centos-stream-8-x86_64.yml  | 18 ++++++------------
>   1 file changed, 6 insertions(+), 12 deletions(-)

Reviewed-by: Thomas Huth <thuth@redhat.com>

