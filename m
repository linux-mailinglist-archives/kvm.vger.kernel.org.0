Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FC07575414
	for <lists+kvm@lfdr.de>; Thu, 14 Jul 2022 19:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238811AbiGNRdp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jul 2022 13:33:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiGNRdj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jul 2022 13:33:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 68BB8A1BD
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 10:33:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657820017;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0uihKaBOQkwF5deCzOTDYRhxxtwy14Pizt+T/pVs9Yg=;
        b=al4VYPA/9NyqMpBTtyejfFfvv2l/VPXDlHPVE9Tw3sCbPDljAlmZlYJ5nqcYBqAhE0fG7u
        2wOd35TOLfBcnMdo8VUhPCuuCAqCNeEBxHu4dl4xBsHAGuAFT2bwCI+w2kytGnVcK9ZVmD
        guysOigrijNTrH94hbRM8oLa+NBOBsk=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-7-QHXfrxL8OQ6esTcqctJluQ-1; Thu, 14 Jul 2022 13:33:36 -0400
X-MC-Unique: QHXfrxL8OQ6esTcqctJluQ-1
Received: by mail-ej1-f72.google.com with SMTP id qb28-20020a1709077e9c00b0072af6ccc1aeso955937ejc.6
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 10:33:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=0uihKaBOQkwF5deCzOTDYRhxxtwy14Pizt+T/pVs9Yg=;
        b=u4+ecoZoKfrRyvb9wDnvwLqbvjC4p3bIrIVr0MP/d2T5oBYKikuT3v5reooCwkz66H
         hBHwtwy0Qb+sxii/8MCMVbkyKiZib9QwI6si0sJz+vAnf9zX5HTLCeHwG9dfaob/d8bi
         fpLLuPY+zZSeLcQoIRpaA8gbMBjV9MKNDahTQMDTbPDCz+c8XL+NhS4u4nOSrEU8pZKk
         lxTG+t2lTM/P41+VOwWZjlWqBtmk57VnHQvN75yCwSL96Z5DS8HXF3HuRL2GL4303bhR
         YMTkbbceGhDZajkjgTfX5m6yJI16ze5vWjhrMhLztgqwOwyZnWKpMfb6Xz9bCxkiSRQM
         FNVA==
X-Gm-Message-State: AJIora+V8yV/F8R9oPrVAQp6Mo4L4hLKWPGchmpL7yppoQYpRm+2b591
        Ws1esxo/lZAQDe4EgY6FQkYDk4otrD8l/GLjFu5RjRAjfnxVGrui0RkKwycH6HjZm2NWyxeE9Gb
        bEcMfY9S4iHIj
X-Received: by 2002:a05:6402:3214:b0:43a:b36f:a0b4 with SMTP id g20-20020a056402321400b0043ab36fa0b4mr13821021eda.122.1657820014768;
        Thu, 14 Jul 2022 10:33:34 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vV0UoPqphONFgcUdCBs8koMta1HObDMznrSBqqIdYHhspB9/PNO5wIYVZMH94ltjorGpco5g==
X-Received: by 2002:a05:6402:3214:b0:43a:b36f:a0b4 with SMTP id g20-20020a056402321400b0043ab36fa0b4mr13821007eda.122.1657820014534;
        Thu, 14 Jul 2022 10:33:34 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id h27-20020a170906719b00b0072aeaa1bb5esm920080ejk.211.2022.07.14.10.33.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Jul 2022 10:33:33 -0700 (PDT)
Message-ID: <747332db-189a-2f58-4a2c-6a40eb631af8@redhat.com>
Date:   Thu, 14 Jul 2022 19:33:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 0/5] KVM: x86: Clean up rmap zap helpers
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220712015558.1247978-1-seanjc@google.com>
 <bc2c1af3-33ec-d97e-f604-12a991c7cd5e@redhat.com>
 <YtBR/x3CAEavwzMI@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YtBR/x3CAEavwzMI@google.com>
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

On 7/14/22 19:27, Sean Christopherson wrote:
> 
>    pte_list_remove  => kvm_zap_one_rmap_spte
>    pte_list_destroy => kvm_zap_all_rmap_sptes
> 
> That will yield a better series too, as I can move patch 5 to be patch 2, then
> split what was patch 2 (the rename) into separate patches to first align kvm_zap_rmap()
> and __kvm_zap_rmap(), and then rename the pte_list_remove/destroy helpers.

Yeah, sounds good (I also was looking into moving patch 5 and possibly 
even patch 4 more towards the beginning).

Paolo

