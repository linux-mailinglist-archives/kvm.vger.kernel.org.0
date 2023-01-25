Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C15C67B9DA
	for <lists+kvm@lfdr.de>; Wed, 25 Jan 2023 19:47:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235678AbjAYSrv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Jan 2023 13:47:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235053AbjAYSrh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Jan 2023 13:47:37 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC79945BEA
        for <kvm@vger.kernel.org>; Wed, 25 Jan 2023 10:46:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674672412;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O4sw02gtulFKBW9mVdYt93F1Y1D7GINQFQqpDdDSSZo=;
        b=cyolW0XtbMTT3/PT9PWECG7rhwRe/T0X6jSzEAW+SkbSIPsGDgE9+DFSB0IdkHa0wi/vku
        dQi0Waqo1snoOOjS/BdezoL8rqlv09QtFbTxd3iu1QO2rCLlaMFNoMnudNUDBSe/ZONPIL
        V4TZrasU1f4Q1OGWxTJ94HvZACOVr2I=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-447-FlIXhYvfNnesNOk49nj_Ig-1; Wed, 25 Jan 2023 13:46:50 -0500
X-MC-Unique: FlIXhYvfNnesNOk49nj_Ig-1
Received: by mail-ej1-f70.google.com with SMTP id sb39-20020a1709076da700b0086b1cfb06f0so12557493ejc.4
        for <kvm@vger.kernel.org>; Wed, 25 Jan 2023 10:46:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O4sw02gtulFKBW9mVdYt93F1Y1D7GINQFQqpDdDSSZo=;
        b=oSR/ILqLYBzjFUnntQgz2qrjHIk5AeF5CBzMnjPB581NqRJR62wfuTMCVMS3pBIzxZ
         W22nmmNFeSRDdQjiNVFQVOc7/qnXjQFWd3Oxy8oPRqTxZpaETswZAiYmUZUkDwtmPULN
         TCJ2xjuWs0q4wSbMRLJRWdas+jxSh/IEbf1SYZkbqUesSg9btE8DNnbUDa//pcagz6D3
         2v5Yajprhr8NrnUky5ibPApXFXLhbqpoatvDBvBPWqz9tgeRgKcdb8dyk+Z8nnpSdIqg
         2aeFDZ8fQADq1yntpbli9wMfUzkidkOHwHoimyzTpG2ImIzaJObV6pORf451kslWjV0E
         iS5g==
X-Gm-Message-State: AFqh2koJISJuUWNG+yKRhQZFDEgncCBVbFTac1JaAcf+RryQXBvJ4Ry8
        f0mESYZONag5tVZjmwu8fu69ppKINvxPPKoOs+vjQ0nQVGoSUKwA6x8iZ766nGQghQt0aEFaCQA
        KWBt0tng11+SQ
X-Received: by 2002:a17:907:d506:b0:7c0:cc69:571b with SMTP id wb6-20020a170907d50600b007c0cc69571bmr40984047ejc.8.1674672409032;
        Wed, 25 Jan 2023 10:46:49 -0800 (PST)
X-Google-Smtp-Source: AMrXdXuEoeWZ8OP95mDWdmgsQBFXuMeyjc72MRf/G+Y3cxr5+I+JmUjwd2Ah8XVyvttg+y78cuD41g==
X-Received: by 2002:a17:907:d506:b0:7c0:cc69:571b with SMTP id wb6-20020a170907d50600b007c0cc69571bmr40984039ejc.8.1674672408828;
        Wed, 25 Jan 2023 10:46:48 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id ui42-20020a170907c92a00b0085214114218sm2709971ejc.185.2023.01.25.10.46.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Jan 2023 10:46:48 -0800 (PST)
Message-ID: <4320fc00-ac70-c0ef-672c-b3bb03496bdf@redhat.com>
Date:   Wed, 25 Jan 2023 19:46:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: A question of KVM selftests' makefile
Content-Language: en-US
To:     Yu Zhang <yu.c.zhang@linux.intel.com>, kvm@vger.kernel.org
Cc:     seanjc@google.com
References: <20230125085350.xg6u73ozznpum4u5@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20230125085350.xg6u73ozznpum4u5@linux.intel.com>
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

On 1/25/23 09:53, Yu Zhang wrote:
>   x := $(shell mkdir -p $(sort $(dir $(LIBKVM_C_OBJ) $(LIBKVM_S_OBJ))))
>   $(LIBKVM_C_OBJ): $(OUTPUT)/%.o: %.c
> -       $(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@
> +       $(CC) $(CFLAGS) $(CPPFLAGS) $(EXTRA_CFLAGS) $(TARGET_ARCH) -c $< -o $@

Yes, this all looks very good.  Feel free to post it as a patch!

Paolo

