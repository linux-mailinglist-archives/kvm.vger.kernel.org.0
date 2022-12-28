Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE44F6574CA
	for <lists+kvm@lfdr.de>; Wed, 28 Dec 2022 10:40:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232755AbiL1JkM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Dec 2022 04:40:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232836AbiL1Jj5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Dec 2022 04:39:57 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7921E0F2
        for <kvm@vger.kernel.org>; Wed, 28 Dec 2022 01:39:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672220356;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TXeCr9NAsdOFkkQeZdmrmD/fAH9UPqpqZXos6+aWt1g=;
        b=GjFttu0w1OQ5fzxe33zryLq8/mjPKXlOUuZv1gpV8NXF/JtvxbCg5vYW62gSXDoqdpdtFZ
        yNLeqPk8MldmULB6fAByW6riJFNeJ4/sVyjFQIEiI3AHSA39+2L6rSfbgHUQQKQ5W39Pf7
        qZ7r4piWdZVyrwfXPREbgvYiCOrL++w=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-198-mzUIX-OfOA-bL4Eo_OGuww-1; Wed, 28 Dec 2022 04:39:15 -0500
X-MC-Unique: mzUIX-OfOA-bL4Eo_OGuww-1
Received: by mail-ej1-f71.google.com with SMTP id hq42-20020a1709073f2a00b007c100387d64so10454779ejc.3
        for <kvm@vger.kernel.org>; Wed, 28 Dec 2022 01:39:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TXeCr9NAsdOFkkQeZdmrmD/fAH9UPqpqZXos6+aWt1g=;
        b=ZgkaqW6lOwy9y93FMapmgQxWDvBHJN8XHCxfyd2Kc4fVOuaTPiZbD+FLtiboDwmUV5
         4pxVHBpBaxU8t2FERnpCubGwmgLvXwPgcoAGys+jCPSox5tYZM54pTGh/yCoU40iHj2a
         +vgdIiW+tk8RmCkYcyqVl9JDxxONfv6dtTm9TxElqqY15KEC6FEnd9lG4eq8jFWVME+l
         vGKmjbboMr+QamcKi27iRsbG2YM0crBlyxfq3jBdBHUiuhWkdxn/s8ja3A4Ya/YsH1jf
         +su+RUAWqRi/3qOlhkaIXxZKnIHjUrevgh/rx+2uW0mz6+e14VXFJu1SINd7XfCa60xa
         ZL3A==
X-Gm-Message-State: AFqh2kryVKZU1ViEhgHfLUsMv0MAFti3q+SY5t1Dddxnju0sq8qXU14l
        qsBvgEL8c8F/HlmU2kt5GSNcgqWweowbDyLJgZQ4cHszUl6dUnbumF3fgudfqvPpJwBtKzdI2VQ
        FdJnuOhd0DXP3
X-Received: by 2002:a17:906:2514:b0:7c1:1b89:60ed with SMTP id i20-20020a170906251400b007c11b8960edmr24636055ejb.18.1672220353619;
        Wed, 28 Dec 2022 01:39:13 -0800 (PST)
X-Google-Smtp-Source: AMrXdXv2BOMwElwfTc03HVATSICPNU9uoFWgZXSFOwz9E6BepOWUCbPMX3hy32YzMo08Cs8RRR2ijw==
X-Received: by 2002:a17:906:2514:b0:7c1:1b89:60ed with SMTP id i20-20020a170906251400b007c11b8960edmr24636041ejb.18.1672220353358;
        Wed, 28 Dec 2022 01:39:13 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id g22-20020a1709064e5600b007c0688a68cbsm7340405ejw.176.2022.12.28.01.39.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Dec 2022 01:39:12 -0800 (PST)
Message-ID: <4ed92082-ef81-3126-7f55-b0aae6e4a215@redhat.com>
Date:   Wed, 28 Dec 2022 10:39:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [RFC PATCH 1/2] KVM: x86/xen: Fix use-after-free in
 kvm_xen_eventfd_update()
Content-Language: en-US
To:     Michal Luczaj <mhal@rbox.co>, kvm@vger.kernel.org
Cc:     dwmw2@infradead.org, paul@xen.org, seanjc@google.com
References: <20221222203021.1944101-1-mhal@rbox.co>
 <20221222203021.1944101-2-mhal@rbox.co>
 <42483e26-10bd-88d2-308a-3407a0c54d55@redhat.com>
 <ea97ca88-b354-e96b-1a16-0a1be29af50c@rbox.co>
 <af3846d2-19b2-543d-8f5f-d818dbdffc75@redhat.com>
 <532cef98-1f0f-7011-7793-cef5b37397fc@rbox.co>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <532cef98-1f0f-7011-7793-cef5b37397fc@rbox.co>
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

On 12/28/22 01:21, Michal Luczaj wrote:
> Does it mean kvm_xen_hcall_evtchn_send() deadlocks in the same fashion?
> 
> 				kvm_xen_eventfd_reset()
> 				  mutex_lock()
> srcu_read_lock()
> kvm_xen_hcall_evtchn_send()
>    kvm_xen_set_evtchn()
>      mutex_lock()
>      				  synchronize_srcu()

Yes, I imagine that in practice you won't have running vCPUs during a 
reset but the bug exists.  Thanks!

Paolo

