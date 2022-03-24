Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFDAA4E689B
	for <lists+kvm@lfdr.de>; Thu, 24 Mar 2022 19:24:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345326AbiCXSZl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Mar 2022 14:25:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240548AbiCXSZk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Mar 2022 14:25:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 09511AC076
        for <kvm@vger.kernel.org>; Thu, 24 Mar 2022 11:24:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648146247;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BJQ4AT1Ezm+OM7uYaunbGJGeDkJH79IfuLeFbVntUZE=;
        b=Pfj2bc0JG961cvCmyISnZpOQ0JGojJmuXkHB+h8FMwqnlal0IYnr8K6TpTPSK0/ADG+YjA
        cLtOyVhlybcl9RMBpymAN/qJcKtiJ3eCzlBs3MtzlQRzRJhzW42gs33SHcc379eTGCshng
        v1S6OkP+/0CxoUIeUqGwZ8Vqc2wt/9I=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-336-ZdKfS_u9PM-Ir0qWCVeB-w-1; Thu, 24 Mar 2022 14:24:05 -0400
X-MC-Unique: ZdKfS_u9PM-Ir0qWCVeB-w-1
Received: by mail-wm1-f72.google.com with SMTP id l7-20020a05600c1d0700b0038c9c48f1e7so4347886wms.2
        for <kvm@vger.kernel.org>; Thu, 24 Mar 2022 11:24:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=BJQ4AT1Ezm+OM7uYaunbGJGeDkJH79IfuLeFbVntUZE=;
        b=lOL7HN6tnq1zvAHKRrFLi4UaalNENUt1mp1lO/UXvh/L2gOmBDgssPvpgDAGKeIGhK
         X/sq65U6rcvgFe+1Hs5J9tAP24sgAxN296drz6RsP8rPoSYbNckvE5E8oLvJCuzH9x+3
         YbWHInwvy1zrAApNfrS1x794K79XyB3vWJL1ZhlliNmUB1mOPkxZL8A21G5/peeqSfeN
         OADxsTosdq6zJnOc4DJY45eLzL1PHSMGwS7Ta9Dpo2TODoHM41JteGDTJyzkT7bpdLFU
         /KnXF4xbArSeIqshnp2quYCMYr8+6OXerYmAOigWTlwoV1+U9GoV49K96PArQASkOgnY
         8hVg==
X-Gm-Message-State: AOAM532cMx17lktrrejIUqfrAYMwTbY5tT2EIV3ityXPaGf6WCPHsIGE
        nZAHWdRZeA5WdOaKLciVbxdye4jUPhS9ErhKacRMF/9A8Lp7tqec5x6BrwvunWdSTzPMV8JuoZR
        t1/NJ/A0vsXO4
X-Received: by 2002:a5d:4a0f:0:b0:1ed:d377:288a with SMTP id m15-20020a5d4a0f000000b001edd377288amr5542431wrq.3.1648146244541;
        Thu, 24 Mar 2022 11:24:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzCPjRof9hOHTEcZ0tmLN1KWm/QUI1HGnj1f9hRLaiYWf0GX/hWiVdh77H1Ueh5vTfpR0fp+g==
X-Received: by 2002:a5d:4a0f:0:b0:1ed:d377:288a with SMTP id m15-20020a5d4a0f000000b001edd377288amr5542414wrq.3.1648146244333;
        Thu, 24 Mar 2022 11:24:04 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id z12-20020a5d4d0c000000b002057d6f7053sm3210955wrt.47.2022.03.24.11.24.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Mar 2022 11:24:03 -0700 (PDT)
Message-ID: <848bba1a-66f2-a3eb-510e-9322b729c8ec@redhat.com>
Date:   Thu, 24 Mar 2022 19:24:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v4 3/6] KVM: x86: nSVM: support PAUSE filtering when L0
 doesn't intercept PAUSE
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Wanpeng Li <wanpengli@tencent.com>
References: <20220322174050.241850-1-mlevitsk@redhat.com>
 <20220322174050.241850-4-mlevitsk@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220322174050.241850-4-mlevitsk@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/22/22 18:40, Maxim Levitsky wrote:
> Allow L1 to use PAUSE filtering if L0 doesn't use it.
> 
> Signed-off-by: Maxim Levitsky<mlevitsk@redhat.com>

Can you enlarge the commit message to explain the logic in 
nested_vmcb02_prepare_control?

Thanks,

Paolo

