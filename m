Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8E966BE8C6
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 13:06:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229820AbjCQMG3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 08:06:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbjCQMG1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 08:06:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF828618D
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 05:05:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679054742;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xlVkuVds0BzmioA6HMJHcmCMJQMnqByBFchTL1H/jl8=;
        b=drr482HbX2c7NU+p1K5kDbUc4gijM1kqDslEaCpl5ToDmT7tBK8FpXNV6wpS5yU7j8m6cO
        z37Bq98hEnMExgCd6TIxa7ZraApntfARSPyC7G7vhYuezPaC9AGo5cXwOiVBSD2dWPDZhs
        JyEkE9khSxzcPvBrYrmXbxuqcRTdHoo=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-367-93sCcSpJN0K7uSE5j-0BJw-1; Fri, 17 Mar 2023 08:05:40 -0400
X-MC-Unique: 93sCcSpJN0K7uSE5j-0BJw-1
Received: by mail-wr1-f72.google.com with SMTP id u27-20020adfa19b000000b002d3b9266941so211950wru.2
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 05:05:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679054739;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xlVkuVds0BzmioA6HMJHcmCMJQMnqByBFchTL1H/jl8=;
        b=3Puk+5GhWM1tOlHUvMg55BwLsPHeaOWRN8jCf5YtQ/29JOYYECA9yOFdCsnIniJZ+s
         rWTtoXrJedEZchNFGU2Tmv5c7E7aTxOW6P0YW+U16QOkGKWjRF0AfsrRaxLnRwT23l22
         +GrxyAVmylLu2cw5nWtu4esVQ9necA/xqPDmlO550OcnpbNvITZxnm1tPXTPfv6KUEnZ
         LdNENQqn7bt0dTgb2VtG/O6PKFhf2rVhdldEnQ1Y2PBpvaWjluL01HGfIB6onMOAm/AZ
         Yxo0EiNx1lrovSaNLXk6pY1ZUyGhEgxgLlqURv7+pfFUMmyJclYzRuSJ33AR+Ix4X2hl
         8BfQ==
X-Gm-Message-State: AO0yUKUougohAfu2TfbsvfV7tFlBkLv74z/zlxE0MD8ITehaZPQIMyz9
        zYdk6Pznnl+dHfzHG1xNwEZXWHQQIdHzUiENj3UAR1guK4VFSm4HNN8WTnFeY+bc/qMVDjqEjRC
        9Gq+jgHkxZBjk
X-Received: by 2002:a05:600c:4746:b0:3ed:26fa:6ed0 with SMTP id w6-20020a05600c474600b003ed26fa6ed0mr2204804wmo.0.1679054739676;
        Fri, 17 Mar 2023 05:05:39 -0700 (PDT)
X-Google-Smtp-Source: AK7set/rGd+QwS67ICAtgwac0dQrNdBoIvaXc11jgB0c1NyzXp4Ls03CcAuumKTL4rvmqnyB01+XFA==
X-Received: by 2002:a05:600c:4746:b0:3ed:26fa:6ed0 with SMTP id w6-20020a05600c474600b003ed26fa6ed0mr2204757wmo.0.1679054739358;
        Fri, 17 Mar 2023 05:05:39 -0700 (PDT)
Received: from [192.168.0.3] (ip-109-43-176-33.web.vodafone.de. [109.43.176.33])
        by smtp.gmail.com with ESMTPSA id z11-20020a05600c220b00b003ed3034698esm2135722wml.9.2023.03.17.05.05.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Mar 2023 05:05:38 -0700 (PDT)
Message-ID: <ec17a227-8c71-d238-6ead-89cfec687727@redhat.com>
Date:   Fri, 17 Mar 2023 13:05:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v2 02/32] tests/docker: all add DOCKER_BUILDKIT to RUNC
 environment
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
        Fabiano Rosas <farosas@suse.de>
References: <20230315174331.2959-1-alex.bennee@linaro.org>
 <20230315174331.2959-3-alex.bennee@linaro.org>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20230315174331.2959-3-alex.bennee@linaro.org>
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
> It seems we also need to pass DOCKER_BUILDKIT as an argument to docker
> itself to get the full benefit of caching.
> 
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> Suggested-by: Fabiano Rosas <farosas@suse.de>
> ---
>   tests/docker/Makefile.include | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tests/docker/Makefile.include b/tests/docker/Makefile.include
> index 54ed77f671..9401525325 100644
> --- a/tests/docker/Makefile.include
> +++ b/tests/docker/Makefile.include
> @@ -39,7 +39,7 @@ docker-qemu-src: $(DOCKER_SRC_COPY)
>   # General rule for building docker images.
>   docker-image-%: $(DOCKER_FILES_DIR)/%.docker
>   	  $(call quiet-command,			\
> -		$(RUNC) build				\
> +		DOCKER_BUILDKIT=1 $(RUNC) build		\
>   		$(if $V,,--quiet)			\
>   		$(if $(NOCACHE),--no-cache,		\
>   			$(if $(DOCKER_REGISTRY),--cache-from $(DOCKER_REGISTRY)/qemu/$*)) \

Reviewed-by: Thomas Huth <thuth@redhat.com>

