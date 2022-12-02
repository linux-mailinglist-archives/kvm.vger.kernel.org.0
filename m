Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54E2F640D4C
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 19:32:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234200AbiLBSci (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 13:32:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234540AbiLBScY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 13:32:24 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C639E98AE
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 10:31:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670005877;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KPAEThHQYkAoxRgOP0gcMQ7C7LKoqBRopPsonFY0Z1c=;
        b=gw2yRxf0SwgHxAKIskI/y4QnbURMhr/TI47E9jIQpc2ZpD4xnOxwidP58dJWUidEhthcwM
        QUYjEr+cq/J5X90ht53zWQprt7spLxpFM+v9Pw7G4GAaBck08kdBMghDwgy+qrceP7S+8e
        iKy8d/FvacJpGQVR0j4nwzVQG6/+DmA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-644-rlERrT7_MI2O2vLFV0XNIg-1; Fri, 02 Dec 2022 13:31:16 -0500
X-MC-Unique: rlERrT7_MI2O2vLFV0XNIg-1
Received: by mail-wm1-f72.google.com with SMTP id c187-20020a1c35c4000000b003cfee3c91cdso2871117wma.6
        for <kvm@vger.kernel.org>; Fri, 02 Dec 2022 10:31:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KPAEThHQYkAoxRgOP0gcMQ7C7LKoqBRopPsonFY0Z1c=;
        b=wfsyKIluwdzP7eXpf0wwhKVBkhIirMjFW89xY0a6OLmAU/VIDgclQqefPoDerhyqVK
         jC8ZErXWfPkclJi9O83tYZJMnDHYL1UMyN3qvI4/q4CnpooR7lVnFWgDFaiSYmdL7kLn
         +jRPFdxwHJn1QiYnZEpRSg7ep8+oRNieWTZx5pxh+fW6X/ankltYEe88VdqQa/PmySLR
         ZkWSpGE5WF7ChMyGcM3LgKxpiKihmww5C78dEBomoYrVXToaVLEmQuSaVdRG7yN+6q+x
         NWFHjcjdcLhntIXm1+5ZuOrqYHwVtpLltHFd6mDmS5b8/lEiamRgIAL39tfKmTPVhjry
         RUwg==
X-Gm-Message-State: ANoB5pkeVvceVl+jXLgHbeJU8sNRkrXSA1C4nhhEMesjtjFLqeknULHo
        a0IoFG9zWEOpkAJd41w/Pi4i/7UL9RjmRuRcDjiZkVQn5dZ1XLI4g53dG2nthwtl5qChHZTd2/Z
        McEmQ9Fv8HwPI
X-Received: by 2002:a7b:c8d0:0:b0:3cf:ca91:7094 with SMTP id f16-20020a7bc8d0000000b003cfca917094mr52829042wml.24.1670005874952;
        Fri, 02 Dec 2022 10:31:14 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7BKq3LF1Khn/3igP8bVJoedWajmTvXUEL3jq70BO2f6Tnmw/UAp+Ts+de7CrCJt67wJMN7qQ==
X-Received: by 2002:a7b:c8d0:0:b0:3cf:ca91:7094 with SMTP id f16-20020a7bc8d0000000b003cfca917094mr52829022wml.24.1670005874693;
        Fri, 02 Dec 2022 10:31:14 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id z10-20020a05600c0a0a00b003c70191f267sm15432586wmp.39.2022.12.02.10.31.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Dec 2022 10:31:14 -0800 (PST)
Message-ID: <b97f11f7-912e-1f54-ac6b-cd32f9054e19@redhat.com>
Date:   Fri, 2 Dec 2022 19:31:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH 10/14] KVM: x86: Remove unnecessary export of
 kvm_vcpu_is_reset_bsp()
Content-Language: en-US
To:     Like Xu <like.xu.linux@gmail.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221114095606.39785-1-likexu@tencent.com>
 <20221114095606.39785-11-likexu@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20221114095606.39785-11-likexu@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/14/22 10:56, Like Xu wrote:
> 
> Don't export x86's kvm_vcpu_is_reset_bsp(), the helper isn't used by
> KVM x86's vendor modules. Move up the code block out of existing
> callers' need.

I'm not sure why to move the code up?

Paolo

