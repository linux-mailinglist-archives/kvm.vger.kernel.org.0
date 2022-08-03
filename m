Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D855558911E
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 19:18:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237305AbiHCRS3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 13:18:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236364AbiHCRS1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 13:18:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 253D14BD2B
        for <kvm@vger.kernel.org>; Wed,  3 Aug 2022 10:18:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659547102;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ba3iLOxgTjgaPYB0G8OKdC5j0xGnpNwkrDCBhoUvC78=;
        b=S4sEF4NuTEJPZmh3khtPdVeLz4ob9jeGQoNn+h9axP/5XmgqFzxgd87j3xAuEAtibR8xd+
        CttklH3BWXPlls2BT3gUZO2zWN23lZnW2ox29FG8PrJ4LrshyK1x+t2im4ExE9WQa3jlPu
        QbtX6J+mJblIxRkxY/llroGKo5y8Pas=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-468-X9hvHMDfO4eRQcGwPY6L5A-1; Wed, 03 Aug 2022 13:18:21 -0400
X-MC-Unique: X9hvHMDfO4eRQcGwPY6L5A-1
Received: by mail-wm1-f72.google.com with SMTP id h133-20020a1c218b000000b003a4f57eaeaaso28172wmh.8
        for <kvm@vger.kernel.org>; Wed, 03 Aug 2022 10:18:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=Ba3iLOxgTjgaPYB0G8OKdC5j0xGnpNwkrDCBhoUvC78=;
        b=kix83ksgfW2SlB8z7I+Rokmw3NOYJEwEFioLVoH0+HMmKWalEzxMQXqMbd4i6fzjID
         zwxTID92rbMBBkwDzJr6QAWRLWne0DreI2Wr/2Forg682/E2Z4PkhDiUYKLD9eSJv4Pd
         Csw+ksCPAMX1b1y2xrK0pko/fiRJZsvMtbk6naCxZJ9qzcDmCus5c0nPEjDTXYUPOBOz
         2Y4CTXD3OI2ljmXBSxVi0Oovk62VUWHElplqes5JpveWKLSERkIf6/PwEchKvE9AncF/
         O13MXgWCvskW6Sek3VxuoG0Xtbo9y72Tem7s2cu42ZsgCTgx98cN8LBpK+qm5LKODhlB
         EGZg==
X-Gm-Message-State: ACgBeo125X2rgNCBi0hKd5RXIVQgLE3TT5Np8NkovIwElOMTEJWsmcnf
        VJGlh94XuzbCWbfG/N1HTVbTBCUgYwA+1VJXvRr9M850E6zrxDqQQSx3dTEONwR9B6fAWtXR8hK
        7k0hE32iDunbd
X-Received: by 2002:a1c:e90c:0:b0:3a0:4c68:f109 with SMTP id q12-20020a1ce90c000000b003a04c68f109mr3437859wmc.56.1659547094876;
        Wed, 03 Aug 2022 10:18:14 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7qPAL4aXq9EjlDqJBMgbr8yOpDW7Xvl8NhQdGLuc+XlQUGjcNM+XZObOHc3oNQB2gvCpWf1Q==
X-Received: by 2002:a1c:e90c:0:b0:3a0:4c68:f109 with SMTP id q12-20020a1ce90c000000b003a04c68f109mr3437848wmc.56.1659547094668;
        Wed, 03 Aug 2022 10:18:14 -0700 (PDT)
Received: from ?IPV6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.googlemail.com with ESMTPSA id b13-20020a5d4b8d000000b0021e519eba9bsm18700259wrt.42.2022.08.03.10.18.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Aug 2022 10:18:14 -0700 (PDT)
Message-ID: <b03adf94-5af2-ff5e-1dbb-6dd212790083@redhat.com>
Date:   Wed, 3 Aug 2022 19:18:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-US
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>
References: <20220802230718.1891356-1-mizhang@google.com>
 <20220802230718.1891356-2-mizhang@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 1/5] KVM: x86: Get vmcs12 pages before checking pending
 interrupts
In-Reply-To: <20220802230718.1891356-2-mizhang@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/3/22 01:07, Mingwei Zhang wrote:
> +	/*
> +	 * We must first get the vmcs12 pages before checking for interrupts
> +	 * that might unblock the guest if L1 is using virtual-interrupt
> +	 * delivery.
> +	 */
> +	if (kvm_check_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu)) {
> +		/*
> +		 * If we have to ask user-space to post-copy a page,
> +		 * then we have to keep trying to get all of the
> +		 * VMCS12 pages until we succeed.
> +		 */
> +		if (unlikely(!kvm_x86_ops.nested_ops->get_nested_state_pages(vcpu))) {
> +			kvm_make_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
> +			return 0;
> +		}
> +	}
> +

I think request handling (except for KVM_REQ_EVENT) could be more 
generically moved from vcpu_enter_guest() to vcpu_run().

Paolo

