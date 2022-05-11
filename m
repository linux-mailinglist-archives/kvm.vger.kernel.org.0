Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 203E05234BA
	for <lists+kvm@lfdr.de>; Wed, 11 May 2022 15:53:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244206AbiEKNxV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 May 2022 09:53:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244215AbiEKNxU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 May 2022 09:53:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3B7CB36145
        for <kvm@vger.kernel.org>; Wed, 11 May 2022 06:53:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652277195;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lA4geVyOxRQyAI3c8C3u5d9Je5L+YOhU/m/ISVgHoMw=;
        b=NrMPg3S11WS7DgKlyOVBv/imTimKZuz3/1bXvxwhIXR/tDOswvkTiKF4AHcmjLPOxjs2r2
        vWFX5+UXGeeHC5A1Zcxps7L+4mryyliulHTvXQl/vbalIElLD9Gjk06a5sWhQhAlg7/jYX
        c48xAjDEM0P327znx9e3OhxraP5e9ts=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-536-m4yn15WOObuGa_aTcVLshQ-1; Wed, 11 May 2022 09:53:14 -0400
X-MC-Unique: m4yn15WOObuGa_aTcVLshQ-1
Received: by mail-ed1-f71.google.com with SMTP id a19-20020aa7d913000000b004284eecb34aso1384519edr.6
        for <kvm@vger.kernel.org>; Wed, 11 May 2022 06:53:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=lA4geVyOxRQyAI3c8C3u5d9Je5L+YOhU/m/ISVgHoMw=;
        b=HI3KUncJdUDkfx9OORMB5XhXDuee24fPRg61lwtdv/Ci+4MBsrANgl1YmuA70V4akA
         L5vEdkWYrmx3drFgCEV/k8ZQMZCgyd+c6/+3Bz/kjnlBxDDMbTbaJIDqMJeH139bVTnO
         AG0u7DSaWaLYCWugqmzyUqJn8nEmyT0sQm1PkAMqe2LMU0LOIubZPOmyjTc8/luhlZvt
         3IJeyjLmFaGoQplIz7JpX4EssXi9Ywi6dWxmUscrbEIa5nWU+hwzIEn8KT6DdUJE499q
         GJZdMkd6ixSdm+i1cGmln38/PDE7zp98EjJwL0+u7TtMmbtmgCkGcrW9pYJ8x3zguaow
         V2bQ==
X-Gm-Message-State: AOAM532lWic5CrkGW074L8aI3YVW3s+3osmE/GjkRUC6kWofgBKU5hxh
        IyRi3rzjokOr8CkUqcdmB7/YHy/7vfznE5rVyfnFWlj++H5E+EBxjHjYDqKIJTViTjyTeEF6Cce
        K/YnrdmeZPxTX
X-Received: by 2002:a50:9ecc:0:b0:428:73bd:4667 with SMTP id a70-20020a509ecc000000b0042873bd4667mr25199314edf.165.1652277192826;
        Wed, 11 May 2022 06:53:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzNpPcqaDgy6ACO49WlAIYSxJh/Gjw8KqLpHuWmE+kyyTZCgKq/Nd8OS+KXR+G0Eeja4jW/jw==
X-Received: by 2002:a50:9ecc:0:b0:428:73bd:4667 with SMTP id a70-20020a509ecc000000b0042873bd4667mr25199294edf.165.1652277192638;
        Wed, 11 May 2022 06:53:12 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id dx18-20020a170906a85200b006f3a8b81ff7sm1061918ejb.3.2022.05.11.06.53.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 May 2022 06:53:11 -0700 (PDT)
Message-ID: <7541c9c1-a580-92d1-1261-3cf3ef756215@redhat.com>
Date:   Wed, 11 May 2022 15:53:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 16/22] KVM: x86/mmu: remove redundant bits from extended
 role
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20220414074000.31438-1-pbonzini@redhat.com>
 <20220414074000.31438-17-pbonzini@redhat.com> <Ynmv2X5eLz2OQDMB@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Ynmv2X5eLz2OQDMB@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/10/22 02:20, Sean Christopherson wrote:
> If it's not too late for fixup, this should be:
> 
> 	return is_cr0_pg(mmu) && !mmu->cpu_role.base.has_4_byte_gpte;

It's not, thanks!

Paolo

