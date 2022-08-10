Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2547E58F2E3
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 21:16:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232960AbiHJTQR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 15:16:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231360AbiHJTQQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 15:16:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A9EC5286F8
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 12:16:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660158974;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Yuk7N/xiq0HIW33fh8ipQmpkKHx9Ov4tG2OqBXiygDw=;
        b=ZHjQyumHUDBuxMZlJM5AJl54TjHPrkchFoGagFQ96ZV+FTrN4qiegnmf0k39XbSZN3x7D1
        BmGfFWglKeEnKdK7ioLRObAWG5xaTGRv2/40FVjs7GeiPRh+Qfxu1YhcVf8aNxdSABCgHh
        jl0/pJ3Y+2sASZU00X+1Kwa6Lw+sc/Q=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-627-3bb9e83sNcWRFL67C6yQUg-1; Wed, 10 Aug 2022 15:16:13 -0400
X-MC-Unique: 3bb9e83sNcWRFL67C6yQUg-1
Received: by mail-ed1-f72.google.com with SMTP id v19-20020a056402349300b0043d42b7ddefso9697944edc.13
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 12:16:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=Yuk7N/xiq0HIW33fh8ipQmpkKHx9Ov4tG2OqBXiygDw=;
        b=MyX9npBfnA4y2xsGP0SlrD6KL7JSpJpMOoLd+KwDyeB6QUz6zpIi/z9YUvFqc9eC8o
         k8Kjvkp5PJrdmkclAM3wlZULruhLnqVJj5M3ftrIjH5iBZPE7e+rwKqunvi8171Jl3Jw
         HEulvOcThPNCzIN2cmo+P9AtK7XBTXZVnaMK2/06qa6Q0XsyP6S/xZF4UWPwd9gOeVZH
         QygEKZWulT4Kuq5gcg23HsMnFLVzY49rNh1jpNENWbklORgKtMul95o/wfZcTLmCI9Je
         YZwnR4coKItP5nBGgqyOeXDvm8avNdkuHYWqVJnv9utfU2IPVs+NUczOUB2vMG8nqOS2
         O2Vg==
X-Gm-Message-State: ACgBeo0SFt1A/1Vgo2VeHLlyGkTJcFOi8+3lhkXdC2DwQ+kPIjhbcPGO
        2BAREEc2LjeDO+jGVcFKJNgGHTbFrTBpNrNlghYNYae/n6fnda14g0zETmX979KFykrXh+4xQyd
        BywwCgkxssFcb
X-Received: by 2002:a17:907:2d12:b0:731:6a4e:ceb0 with SMTP id gs18-20020a1709072d1200b007316a4eceb0mr10079036ejc.115.1660158972001;
        Wed, 10 Aug 2022 12:16:12 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6+FYQetpU3q/Q5uOyO8nSkvyFk5TvPqTUmApwtAkGzu9ywUxx5N/JvC3UE+anDgXpNN9zzBg==
X-Received: by 2002:a17:907:2d12:b0:731:6a4e:ceb0 with SMTP id gs18-20020a1709072d1200b007316a4eceb0mr10079033ejc.115.1660158971826;
        Wed, 10 Aug 2022 12:16:11 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id n6-20020aa7c786000000b0043a554818afsm8082123eds.42.2022.08.10.12.16.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Aug 2022 12:16:10 -0700 (PDT)
Message-ID: <eb0a073d-f045-a5d7-2d3d-54abe1ae478c@redhat.com>
Date:   Wed, 10 Aug 2022 21:16:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [RFC PATCH 2/3] KVM: x86: Generate set of VMX feature MSRs using
 first/last definitions
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Like Xu <like.xu.linux@gmail.com>
References: <20220805172945.35412-1-seanjc@google.com>
 <20220805172945.35412-3-seanjc@google.com>
 <29150d3f-36fb-516d-55d0-a9aebe23cdcf@redhat.com>
 <YvPDYVPgrLCRlYuH@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YvPDYVPgrLCRlYuH@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/10/22 16:40, Sean Christopherson wrote:
>> I'd rather move all the code to a new function kvm_init_feature_msr_list()
>> instead, and call it from kvm_arch_hardware_setup().
> 
> Would it make sense to also split out kvm_init_emulated_msr_list()?  Hmm, and
> rename this to kvm_init_virtualized_msr_list()?  I can't tell if that would be
> helpful or confusing.

I thought of feature MSRs because it's a different ioctl altogether, but 
this is not an objection; whatever seems less confusing to you.

Paolo

