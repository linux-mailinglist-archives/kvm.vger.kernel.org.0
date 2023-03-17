Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EDA36BE1E3
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 08:27:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230234AbjCQH1E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 03:27:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbjCQH1C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 03:27:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A738475A66
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 00:26:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679037980;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HqrnyekWZtj3autRtqGDoL7x0MtC0GOcxCuc87fpusU=;
        b=cwqTXZ6Rf74awlOSXm30HQtAMEbGYIqy6g9ONZEL/6Obr36tmsNChL72QgAajhJ/6V/l8B
        ZIywMCqnc65ZvcGuIarBCBRY4sa8WFo+x0+My3mYbrEGFCDSUDto4BXtesvQCpIvMrJx9x
        ujnqI2r5XxU1Fu1ZEKJRL48xKjnEv+g=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-643-JLensYKlN1Wh_hrfm2Mo8w-1; Fri, 17 Mar 2023 03:26:17 -0400
X-MC-Unique: JLensYKlN1Wh_hrfm2Mo8w-1
Received: by mail-wm1-f72.google.com with SMTP id m28-20020a05600c3b1c00b003ed307fddadso3867703wms.4
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 00:26:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679037976;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HqrnyekWZtj3autRtqGDoL7x0MtC0GOcxCuc87fpusU=;
        b=QMhSy4v9qh4m/+5xlxcqZZv7EMnwrAWt9PJCtEBE+QpXBaSIz+/zWfoe2bvbvk8+ZH
         JtK8GxQ+ktkhdiUl1WCEuHftlKsPGpqXAzghNVQmcIUs9ydUE3mrPlD/sAtVK9XxAo30
         HgaA63a3CK+hEz4aLN+dzCp2QSwEyHJDIQhO3cU4x1FP2ajfQZ/3aqvaGVLwKmO1eDTd
         kQhcO2vhoLObkx7cfeldDXBjI5ZGwQU6egnJnWAke3/LWZ3F4pbEuMMH4oIJhyPKmGat
         vc1w3yaPjqJp9BdpdMG8qMp3eGEOQ5+m7nUPPa5wLSpYfuKUq0eoK65kiXJZ0ZkOfxRp
         UGSA==
X-Gm-Message-State: AO0yUKUtHZsrWV87429ipQYPEWZpIXOVgySada3Zh0y6r0erVz4LiWor
        61KQPKVPyqTbgc7zzxXKD3q63MfOYPgmqvWyrJvV+kbAb8S+GTYuwwL3K7V0Ev4yVHO7RAtUdBN
        Hbwil6GOU4Ch7
X-Received: by 2002:a05:600c:4fce:b0:3ed:24f6:1089 with SMTP id o14-20020a05600c4fce00b003ed24f61089mr16092854wmq.15.1679037976078;
        Fri, 17 Mar 2023 00:26:16 -0700 (PDT)
X-Google-Smtp-Source: AK7set/Gl8eTfcazshyynddIacq5+dgKonMcbVTvMaTdoQMnA6FrXfJgH39r0LtsNqEKcjgiAOfLyA==
X-Received: by 2002:a05:600c:4fce:b0:3ed:24f6:1089 with SMTP id o14-20020a05600c4fce00b003ed24f61089mr16092826wmq.15.1679037975745;
        Fri, 17 Mar 2023 00:26:15 -0700 (PDT)
Received: from [192.168.0.3] (ip-109-43-176-33.web.vodafone.de. [109.43.176.33])
        by smtp.gmail.com with ESMTPSA id c22-20020a7bc856000000b003dc42d48defsm1479979wml.6.2023.03.17.00.26.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Mar 2023 00:26:14 -0700 (PDT)
Message-ID: <e3e19ba8-6574-c989-ad02-25fabe5956f9@redhat.com>
Date:   Fri, 17 Mar 2023 08:26:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v2 31/32] contrib/gitdm: add more individual contributors
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
        Hanna Reitz <hreitz@redhat.com>, Peter Xu <peterx@redhat.com>,
        Bernhard Beschow <shentey@gmail.com>,
        Amarjargal Gundjalam <amarjargal16@gmail.com>,
        Bin Meng <bmeng@tinylab.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>
References: <20230315174331.2959-1-alex.bennee@linaro.org>
 <20230315174331.2959-32-alex.bennee@linaro.org>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20230315174331.2959-32-alex.bennee@linaro.org>
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
> I've only added the names explicitly acked.
> 
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> Cc: Bernhard Beschow <shentey@gmail.com>
> Cc: Amarjargal Gundjalam <amarjargal16@gmail.com>
> Cc: Bin Meng <bmeng@tinylab.org>
> Cc: Jason A. Donenfeld <Jason@zx2c4.com>
> Cc: Strahinja Jankovic <strahinja.p.jankovic@gmail.com>
> Acked-by: Bernhard Beschow <shentey@gmail.com>
> Message-Id: <20230310180332.2274827-10-alex.bennee@linaro.org>
> ---
>   contrib/gitdm/group-map-individuals | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/contrib/gitdm/group-map-individuals b/contrib/gitdm/group-map-individuals
> index e2263a5ee3..3264c7383d 100644
> --- a/contrib/gitdm/group-map-individuals
> +++ b/contrib/gitdm/group-map-individuals
> @@ -38,3 +38,4 @@ paul@nowt.org
>   git@xen0n.name
>   simon@simonsafar.com
>   research_trasio@irq.a4lg.com
> +shentey@gmail.com

FWIW:
Reviewed-by: Thomas Huth <thuth@redhat.com>

