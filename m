Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 542EE5EE2E9
	for <lists+kvm@lfdr.de>; Wed, 28 Sep 2022 19:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234469AbiI1RSn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Sep 2022 13:18:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234483AbiI1RSe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Sep 2022 13:18:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F107EB1E1
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 10:18:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664385512;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=X/r6KCKf1vxWod/Dk6IGZU/aQVyTqynzb69MIGT/niI=;
        b=Soq+qQv94hjXcPonQYr/bOXTlKjC9/1Fus/1+iKmBMfpUJ2UIkyNoKy1DBq4tFRVqWZ5RU
        Lgib3mFKEzG2zRDDmH6u2WdC+TnntPXWgNTesIiLMfEgxvlqW9TMm5MRSk2PMN7w5knLgV
        hedj1JSX8B5kqvwQw4uB0RG3n0ExuiQ=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-465-yXdsAeKQN9e2i0WHTChQkw-1; Wed, 28 Sep 2022 13:18:30 -0400
X-MC-Unique: yXdsAeKQN9e2i0WHTChQkw-1
Received: by mail-ej1-f70.google.com with SMTP id sd4-20020a1709076e0400b00781e6ba94e1so5820691ejc.1
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 10:18:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=X/r6KCKf1vxWod/Dk6IGZU/aQVyTqynzb69MIGT/niI=;
        b=s/K1++rdvx0+dhJbsSJNqV7TT0BCfcoHxR44sjYC2NGBpt40gzZ/osSrP+CjGu0yyW
         LYsWIsNQxLODr0OSkD9IMS2U/8b0nO91u7fSB4q/L5ulIA+Ey/dXhZ1mdqCrS7g/be8T
         L9k3nrW0zdf5HNDo/r2wldZdqoNh4M6F485aQlVZf6nfJ13YCdTEYeJPMpgeXtKJz5Qc
         PtpALvXwpoZslORZHb3qQzxZTE379XVZGpgACMnC5A3GFapV1Qyu12JvfQSIhI3DPHAR
         +tGAiinKLl2/jyW4G9iSca+veKyY5VIYNVVA+sZZZR3OfoHPX2+CiTTJ3vKt+4JsPSvd
         3PXg==
X-Gm-Message-State: ACrzQf2eJJM+4kWg4iXnI2thKuwgdM0B32QadcBn1JR4b21qtuFjStXX
        WvmeZl0lr0uI1e+0d7QbL7/vRsrvoRCITqnr5HRIMxj+JCDwNkgWhHWJHQ2IrElivHVgsW6rrP0
        fF4+FJOscCb2L
X-Received: by 2002:a17:907:a067:b0:77b:9672:3f83 with SMTP id ia7-20020a170907a06700b0077b96723f83mr27719534ejc.523.1664385509627;
        Wed, 28 Sep 2022 10:18:29 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4y+VtC+3fkqh3nOfD54Thq7KzED4MZaOBS96HS+eMi4AX7iODHQvWUOeCZ783oe015OIfXuA==
X-Received: by 2002:a17:907:a067:b0:77b:9672:3f83 with SMTP id ia7-20020a170907a06700b0077b96723f83mr27719507ejc.523.1664385509419;
        Wed, 28 Sep 2022 10:18:29 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:2f4b:62da:3159:e077? ([2001:b07:6468:f312:2f4b:62da:3159:e077])
        by smtp.googlemail.com with ESMTPSA id m5-20020a1709062ac500b00773dbdd8205sm2644031eje.168.2022.09.28.10.18.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Sep 2022 10:18:28 -0700 (PDT)
Message-ID: <3e457190-8ebc-2234-5a14-79cab89b393f@redhat.com>
Date:   Wed, 28 Sep 2022 19:18:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [RFC PATCH 7/9] kvm_main.c: duplicate invalid memslot also in
 inactive list
Content-Language: en-US
To:     Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Hildenbrand <david@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
References: <20220909104506.738478-1-eesposit@redhat.com>
 <20220909104506.738478-8-eesposit@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220909104506.738478-8-eesposit@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/9/22 12:45, Emanuele Giuseppe Esposito wrote:
>   	/*
> -	 * if change is DELETE or MOVE, invalid is in active memslots
> -	 * and old in inactive, so replace old with new.
> +	 * if change is DELETE or MOVE, invalid is in both active and inactive
> +	 * memslot list. This means that we don't need old anymore, and
> +	 * we should replace invalid with new.
>   	 */
> -	kvm_replace_memslot(kvm, batch->old, batch->new);
> +	if (batch->change == KVM_MR_DELETE || batch->change == KVM_MR_MOVE)
> +		kvm_replace_memslot(kvm, batch->invalid, batch->new);
> +	else
> +		kvm_replace_memslot(kvm, batch->old, batch->new);

This is also

	kvm_replace_memslot(kvm, batch->invalid ?: batch->old,
			    batch->new);

with no need to look at batch->change.

Paolo

