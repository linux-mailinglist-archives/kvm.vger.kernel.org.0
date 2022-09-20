Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B0235BEA92
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 17:53:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231167AbiITPxk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 11:53:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231524AbiITPxg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 11:53:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FF9C6A485
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 08:53:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663689213;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RBX1E0mCd6T0JdYFE1OsHVt8Dm3SjbynDjMcfSGkSdY=;
        b=S7eOHV8sVuThZMK8doFU0miZZDI3nQoffrCaXjcwpRdfGnzpGgNE4QL0KIdk6w8IK/EBoI
        QRsHW9jOSLxCK543s08jp239csyTybDqhYceuYzrRXpOWS2yMai4jUm0k4TehLqmKz/G79
        XgodD9JKNpR6QuB5ojmMQdSxqr4yyFM=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-589-dXL3mQQnP7OZYAS00-bSJA-1; Tue, 20 Sep 2022 11:53:31 -0400
X-MC-Unique: dXL3mQQnP7OZYAS00-bSJA-1
Received: by mail-wm1-f71.google.com with SMTP id i132-20020a1c3b8a000000b003b339a8556eso1334220wma.4
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 08:53:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=RBX1E0mCd6T0JdYFE1OsHVt8Dm3SjbynDjMcfSGkSdY=;
        b=1TeWoJPc7SADflyLxX0Z3PGrMZFl5IbFXo0yoBBWR77QjfOo28lp3kSK86s8Y4Yn/h
         giooutrNqf+mVIutuX5JJFJVknckF2qQoMs85NuMpV9urUXiZNzp1flYgNFu4LBX/SeP
         pT2KfxwXLPMK2sn5hIyHsd9ERZvJBM5ncdMt/4wlrt3+ow3f+gazkIYzuwWhPjk62DVg
         dPc56wIDdnBqqRZbs8rC0s7qhsP9nNznDgx2biBfHWpGsCwqqywTy/hxG4d5EMOUPk2s
         QueydvJXIS6banH1Ly+ibE9jtDU7V75FMD0sGPhPI0HLDY/OvE1Rx0TD3j5fSHUu1kId
         AkKg==
X-Gm-Message-State: ACrzQf3HD8j6IFUZFrQoyUgTqxMtjQkmgsLagxHr8OJk8qKpJ6pmeWiZ
        2ivALP67ZlJ/0VRQkhGLliO/we4A/ZhOVAi8Vocp7dN9z4EDRNgoHsXnvOkjNp1NlPntawqGXwO
        OMuiIHvIkCUmx
X-Received: by 2002:a5d:47a9:0:b0:22a:4746:cfa7 with SMTP id 9-20020a5d47a9000000b0022a4746cfa7mr14235655wrb.368.1663689210701;
        Tue, 20 Sep 2022 08:53:30 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6PQB6l8suRn+MKPCmO2NiJ4wALD23Fcsi3U2vcwT9k9Hg0jihgD36/JOsMuJK8opPaPSN1Zg==
X-Received: by 2002:a5d:47a9:0:b0:22a:4746:cfa7 with SMTP id 9-20020a5d47a9000000b0022a4746cfa7mr14235647wrb.368.1663689210467;
        Tue, 20 Sep 2022 08:53:30 -0700 (PDT)
Received: from [192.168.8.103] (tmo-083-219.customers.d1-online.com. [80.187.83.219])
        by smtp.gmail.com with ESMTPSA id a17-20020adff7d1000000b0021e6c52c921sm144935wrq.54.2022.09.20.08.53.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Sep 2022 08:53:29 -0700 (PDT)
Message-ID: <f7b8977e-7cf3-f422-77fa-808d9049ffeb@redhat.com>
Date:   Tue, 20 Sep 2022 17:53:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [kvm-unit-tests GIT PULL 02/28] s390x: add test for SIGP
 STORE_ADTL_STATUS order
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com
References: <20220512093523.36132-1-imbrenda@linux.ibm.com>
 <20220512093523.36132-3-imbrenda@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20220512093523.36132-3-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/05/2022 11.34, Claudio Imbrenda wrote:
[...]
> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
> index 743013b2..256c7169 100644
> --- a/s390x/unittests.cfg
> +++ b/s390x/unittests.cfg
> @@ -146,3 +146,28 @@ extra_params = -device virtio-net-ccw
>   
>   [tprot]
>   file = tprot.elf
> +
> +[adtl-status-kvm]
> +file = adtl-status.elf
> +smp = 2
> +accel = kvm
> +extra_params = -cpu host,gs=on,vx=on

FWIW, on my z13 LPAR, I now see a warning:

SKIP adtl-status-kvm (qemu-kvm: can't apply global host-s390x-cpu.gs=on: 
Feature 'gs' is not available for CPU model 'z13.2', it was introduced with 
later models.)

Could we silence that somehow?

  Thomas

