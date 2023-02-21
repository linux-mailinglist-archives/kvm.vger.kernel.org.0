Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC7AC69DB4C
	for <lists+kvm@lfdr.de>; Tue, 21 Feb 2023 08:36:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233664AbjBUHg6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Feb 2023 02:36:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232246AbjBUHgz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Feb 2023 02:36:55 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCEB2233E5
        for <kvm@vger.kernel.org>; Mon, 20 Feb 2023 23:36:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676964966;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GJUhBSU80naNAyt7KCYwVauVvdFPDJ7F9xsF0ak04fU=;
        b=N6Kj33Z7NDZJBtV3iqTifNVNWNVhj+oIoC/iSL7PK82kbTjSqIoasISRwZg6pmT3dgJkKA
        vDfEIqb4a+m/IUd8xngHAaWBWl9qaNtNPJT6O+36hqT5DFdreJ4NmCgetF74K1SyklZQ/r
        jzQaXtIKUETsUmjlMIyeYdC65C8in3Q=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-189-Kjib8UxzMyqomAoR5pqc4Q-1; Tue, 21 Feb 2023 02:36:04 -0500
X-MC-Unique: Kjib8UxzMyqomAoR5pqc4Q-1
Received: by mail-ed1-f69.google.com with SMTP id dm14-20020a05640222ce00b0046790cd9082so5089112edb.21
        for <kvm@vger.kernel.org>; Mon, 20 Feb 2023 23:36:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GJUhBSU80naNAyt7KCYwVauVvdFPDJ7F9xsF0ak04fU=;
        b=wpxyBWcIeHqT2A8gXWBHfrZLSVZJnyAJNBaIEEsBlXkzxcnSQmyEeoSweMMvfIC07Z
         aU6fmvfPClwMXa+lQ8Hq/wN2aoR7k0p6JIjKyjpcPkPZiV9S1/ejtxjeI5VMhf0uq+5X
         b3IcYOd3SYi/YNWdrQYi+l9NipHzO8NMg+VNwVtBG5grFt3gsA0RFYZJSaxdk0xa/Qra
         HhgoYEACT119xMFIaGWRZXklU7k1tMeoC8V4JS0Ob0Vk28X9mNeFnTTDIqIeoK6nF5sP
         78eVwzhi/GgvgwQj+4XEPo3ndDKSNDo5NjGMc3M/wrDy5OWgXhFQK0PweXsC7nNjWkBc
         OtEg==
X-Gm-Message-State: AO0yUKVjdMn57DFn/2LwnRxZiBTijvf7PzCA0ScIJEo7BhFTSAk5YSX2
        aTlLHieTHmwPcSIsnMgykYR3kd5a3HWeg7Ql07/m1vugtMOZZ9eDu06e3fugFU1hgPwmlZ/bruW
        BJY/hGyPxvXp2
X-Received: by 2002:a17:906:eca1:b0:87d:eff1:acc8 with SMTP id qh1-20020a170906eca100b0087deff1acc8mr11390847ejb.48.1676964963253;
        Mon, 20 Feb 2023 23:36:03 -0800 (PST)
X-Google-Smtp-Source: AK7set9J1/92GkILe5uy/U98ad25HyMRx/vMAcuPeun433EDTbMLSpuGQJ2VGiRFrZCp9HdNZZQeUw==
X-Received: by 2002:a17:906:eca1:b0:87d:eff1:acc8 with SMTP id qh1-20020a170906eca100b0087deff1acc8mr11390829ejb.48.1676964962981;
        Mon, 20 Feb 2023 23:36:02 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id z10-20020a170906714a00b008ba365e7e59sm4555423ejj.121.2023.02.20.23.36.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Feb 2023 23:36:02 -0800 (PST)
Message-ID: <87268dce-1b5d-0556-7e65-2a75a7893cd1@redhat.com>
Date:   Tue, 21 Feb 2023 08:35:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v2 05/29] LoongArch: KVM: Add vcpu related header files
Content-Language: en-US
To:     Xi Ruoyao <xry111@xry111.site>, maobibo <maobibo@loongson.cn>,
        Tianrui Zhao <zhaotianrui@loongson.cn>
Cc:     Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>
References: <20230220065735.1282809-1-zhaotianrui@loongson.cn>
 <20230220065735.1282809-6-zhaotianrui@loongson.cn>
 <497693ca2cbc443c1d9f796c3aace6c9987bec72.camel@xry111.site>
 <7d6125dd-29e8-14d8-b1d7-d8c14d7bec80@loongson.cn>
 <4cd00b5cdc78da6357d2d326e607b169faee34a8.camel@xry111.site>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <4cd00b5cdc78da6357d2d326e607b169faee34a8.camel@xry111.site>
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

On 2/21/23 08:12, Xi Ruoyao wrote:
>> We are preparing to submit these instruction support for binutils,
>> however it is still necessary. Supposing that it is supported in future
>> gcc version, we can not drop existing gcc 12/13 supporting to compiling
>> kernel with LoongArch architecture.
> You can drop the support for KVM with less capable Binutils versions,
> like:
> 
> config AS_HAS_LVZ
>      def_bool $(as-instr some_gcsr_insn \$r0, \$gcsr0)
> 
> config KVM
>      depends on AS_HAS_LVZ
> 

There are precedents in Linux for using .word when necessary.  There's 
no reason to prevent using KVM on old Binutils versions.

Paolo

