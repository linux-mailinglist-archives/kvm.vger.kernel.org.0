Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5E3769D266
	for <lists+kvm@lfdr.de>; Mon, 20 Feb 2023 18:54:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231950AbjBTRyN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 12:54:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230265AbjBTRyM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 12:54:12 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C1D62D76
        for <kvm@vger.kernel.org>; Mon, 20 Feb 2023 09:53:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676915606;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A6m99hVi2S7tt6YKMO1cVTA7Dd38UPq4FNBkdwIRSkw=;
        b=bAyGcO5aIqx7VdN7DoJIqj9+gh1lJiFpT3Wd7qVJuwJQvENN+/kOXvq7XyjQsbxjgej7XS
        /m85oeTDtRJPix8YqXnIud4x6dlNAZbjFzYyFJWxnjhnHSAEj144LP614OF20GEonxVA/X
        kcZubLZTolVmaJAKdUnzVSX6N3L2fqk=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-551-sJF8F-NhNpeiklFgYhCwkA-1; Mon, 20 Feb 2023 12:53:23 -0500
X-MC-Unique: sJF8F-NhNpeiklFgYhCwkA-1
Received: by mail-ed1-f71.google.com with SMTP id h13-20020a0564020e8d00b004a26ef05c34so2107615eda.16
        for <kvm@vger.kernel.org>; Mon, 20 Feb 2023 09:53:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A6m99hVi2S7tt6YKMO1cVTA7Dd38UPq4FNBkdwIRSkw=;
        b=5TVSeNu9O+DBP3BnqoI2tfkwxQyavfocyLqQofDnGWTPHS0QjgarCVFceqfcZOz6s6
         965O9+sqd2CsZ0zOWY+wd5NZTfEKZsVwQsu1KqzoOhTLgOvv+VBNN2c9YojDxRnLf/Hj
         cfZI7Lth5KFeb3CThDJqGSNGzwEoM9gc005rBquNgvtX4Jdojv1i5X1xr0Bc5D+vhwiZ
         Whm/BTZoN/pps5K3auYnUv42xdD4MYFGvezhgeSWF4GMu3cYeECV9YkSLrwyk9HFf2NY
         RieIv4KbRN/bB8sBF/76cGCYXE9gXzYRp1YYE31mlctmHhpG3zOjmUeLlwzVGejm1px6
         NvWg==
X-Gm-Message-State: AO0yUKVOM2QX97OZIyU++5O2aB3uJ3aGf6UNxVbvcSmmmr6Flhw8ftts
        EHOo2nTlKCHPsxUzLLkcNlBPBsnt+LHJLyV5usYnuQj2yDSvY9n59usvJ9IA6UgRfJ7+PIp3XmF
        KfJnvHeclOI9N
X-Received: by 2002:a17:906:5587:b0:8ae:707:e129 with SMTP id y7-20020a170906558700b008ae0707e129mr11613416ejp.19.1676915602744;
        Mon, 20 Feb 2023 09:53:22 -0800 (PST)
X-Google-Smtp-Source: AK7set8YUMllxoIfXoPvpKgnxtQVrwTWJX8iE/yV2ZHIe2nb+KwqL6pfZmuCO53IKmK9nVaiNrgo/w==
X-Received: by 2002:a17:906:5587:b0:8ae:707:e129 with SMTP id y7-20020a170906558700b008ae0707e129mr11613400ejp.19.1676915602476;
        Mon, 20 Feb 2023 09:53:22 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:4783:a68:c1ee:15c5? ([2001:b07:6468:f312:4783:a68:c1ee:15c5])
        by smtp.googlemail.com with ESMTPSA id sa14-20020a170906edae00b008b176df2899sm5514793ejb.160.2023.02.20.09.53.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Feb 2023 09:53:21 -0800 (PST)
Message-ID: <cbd95763-ec38-63f7-89bf-c8b01aa7df77@redhat.com>
Date:   Mon, 20 Feb 2023 18:53:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v2 06/29] LoongArch: KVM: Implement vcpu create and
 destroy interface
Content-Language: en-US
To:     Tianrui Zhao <zhaotianrui@loongson.cn>
Cc:     Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn
References: <20230220065735.1282809-1-zhaotianrui@loongson.cn>
 <20230220065735.1282809-7-zhaotianrui@loongson.cn>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20230220065735.1282809-7-zhaotianrui@loongson.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/20/23 07:57, Tianrui Zhao wrote:
> +	vcpu->arch.guest_eentry = (unsigned long)kvm_context->kvm_eentry;
> +	vcpu->arch.vcpu_run = kvm_context->kvm_enter_guest;
> +	vcpu->arch.handle_exit = _kvm_handle_exit;

Here as well, whatever is constant must not be stored in struct 
kvm_arch_vcpu.

Paolo

