Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6167A4DA452
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 22:06:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351763AbiCOVHY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 17:07:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237862AbiCOVHX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 17:07:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9EB79483AC
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 14:06:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647378369;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=emsFlxwu2Fpzz4LWF/dJeqV7CMDiP7wZEH5sRvwPHYI=;
        b=OKm/FhRMJOptucUt6+fvvIkPZMx3rBqhCFaKNluEiV5/ZE54pTxa60zOZ5zbJG0Ya/KrYN
        +/GCHlrTTkh0IczPLJCrzumgEDR1tvjkuUj+00zvEp8vvvGGRSGYjwPVyPBg+TnEuya02e
        s+VamScc3DS0yTkPJyDSZZ363FQRRJs=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-460-wDLNoS-vNVicf3ticB1Rdw-1; Tue, 15 Mar 2022 17:06:08 -0400
X-MC-Unique: wDLNoS-vNVicf3ticB1Rdw-1
Received: by mail-ej1-f69.google.com with SMTP id ga31-20020a1709070c1f00b006cec400422fso28932ejc.22
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 14:06:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=emsFlxwu2Fpzz4LWF/dJeqV7CMDiP7wZEH5sRvwPHYI=;
        b=KwkR4RfoeF0HnsTlSfzxnwRhzD3N40E3IhgwNN0EGDybdu5r28fpjxStyj9FrOp2M3
         I+lSzmqtfTrVVD6yWLLeaB8XvGNvd5uH5fFRDiMCuAkljYx4Zl7d4SVH2/hEhI9zXd9h
         EjZRPJeO+GFuKK5Ex39VtG4VMO6mSNNsWb2kaDo+TCRe+P/81q6goeMF3fDyilDjjumb
         cAoRsU+R2lToNxg54NG6CAnkBuDRXQ1u0Tud4F9IXDAFbVXJrtMo7w/iQy4goEoiT7jq
         UOSBWaPwiULpkRgVciu0pGjoiXYyF8gYp5ewqBNReCUn82aYGvYSEAA9TszFjpOvnbo1
         ZHqA==
X-Gm-Message-State: AOAM533SpsPKdLAKeRbTRgZhicWOWLXkxrckexsoDjluv3EZdSSQEuRl
        p4/n/50Iz5RhgcUvURjbXETeQLJ57zfhq4CwU3w8aBkNUm536/rZP30Js7xa+oVlK8nhmJkwkR2
        4pZ4axAcLRNxs
X-Received: by 2002:a17:907:96a8:b0:6db:4c68:1393 with SMTP id hd40-20020a17090796a800b006db4c681393mr24116127ejc.87.1647378367368;
        Tue, 15 Mar 2022 14:06:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzE4fUDhYm2sNjarm9dSLvKXqwJDtQNDnrVXJGWOPwLtqbXXpUkCFSU8NNt0KzN353BvFc3EQ==
X-Received: by 2002:a17:907:96a8:b0:6db:4c68:1393 with SMTP id hd40-20020a17090796a800b006db4c681393mr24116110ejc.87.1647378367151;
        Tue, 15 Mar 2022 14:06:07 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id s8-20020a170906354800b006da9dec91f2sm52534eja.163.2022.03.15.14.06.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Mar 2022 14:06:06 -0700 (PDT)
Message-ID: <5cc80cc7-8088-3bb7-4bbe-40c527465658@redhat.com>
Date:   Tue, 15 Mar 2022 22:06:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH V2 0/5] KVM: X86: permission_fault() for SMAP
Content-Language: en-US
To:     Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>
Cc:     Lai Jiangshan <jiangshan.ljs@antgroup.com>
References: <20220311070346.45023-1-jiangshanlai@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220311070346.45023-1-jiangshanlai@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/11/22 08:03, Lai Jiangshan wrote:
> From: Lai Jiangshan<jiangshan.ljs@antgroup.com>
> 
> Some change in permission_fault() for SMAP.  It also reduces
> calls two callbacks to get CPL and RFLAGS in come cases, but it
> has not any measurable performance change in tests (kernel build
> in guest).

I am going to queue patches 1-4.  The last one shouldn't really have any 
performance impact with static calls.

Paolo

