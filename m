Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 876784BA6D5
	for <lists+kvm@lfdr.de>; Thu, 17 Feb 2022 18:17:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235563AbiBQRRH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Feb 2022 12:17:07 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231609AbiBQRRG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Feb 2022 12:17:06 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 294C61A82A
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 09:16:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645118209;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qWdOG1LFieVFuqokyux4dhfLVcdCZyJ43J8Lt+eLPYA=;
        b=hA/1VN5uVufbEI8WmYVTqmuijAU/IuHoJGNkRGG8ZieXyWvVSMhGu9uPqOvmNN5c7udBrg
        yJTfOgKTU6MLPw1sRo85Gc0WzYBx5f9hM+1nBTA2WXoG8u9yDdqaEoosoflYTT+jkKJvqc
        x+YzTvfCr33J/Gb2DeO/kKb3srR4eHw=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-498-IsHkkAY8POWhEclkRMqUqA-1; Thu, 17 Feb 2022 12:16:48 -0500
X-MC-Unique: IsHkkAY8POWhEclkRMqUqA-1
Received: by mail-ej1-f69.google.com with SMTP id m4-20020a170906160400b006be3f85906eso1796087ejd.23
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 09:16:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=qWdOG1LFieVFuqokyux4dhfLVcdCZyJ43J8Lt+eLPYA=;
        b=Wm7Un43XKmKw8jNxSTiEPdHmQy7C736k1BIQaDWqh/MU9POeXCmE2qo/wn0lzz3Lxf
         C9jxOsPgk9VMxnkVS09QuNwu9Uf+4yag8jl5Fm2aiJO9Wqgye69SpEgFD8l6D5MG5zHk
         iDbXbwLO9cAftf1LtEvZ355O4hUGR57LUgZU4mIwJJFnpZTs9C+knnv2t83A8tupCXEM
         EJrzMphgri3hNu8Q3FJdwmassEizJ3w6UkKMNby2xVkOP+OmLFHbD1nD5VLidkzk4cBw
         3t0PhO2lWDJYAkt9rq/IuGswcSR65NXZRdCR/jodu5FEWgGb/NkqPC1jSaSLEBaax4jD
         NWyA==
X-Gm-Message-State: AOAM532CosGlokXQqyHmFu4kwHFcp91cZpIbEuo4lEHtfENbpTsG3Jg9
        UwOEeS+ffehPskkYEdf66okq5ZRiEzJW3YZRNQbWSudiTvYr2CKxesuGtz/DGcW/F/HKkk/cL7/
        yIq/3U3LJZON9
X-Received: by 2002:a17:906:9256:b0:6a9:dfca:78d8 with SMTP id c22-20020a170906925600b006a9dfca78d8mr3245966ejx.330.1645118206915;
        Thu, 17 Feb 2022 09:16:46 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwxp/SHuklUJKrKEUXLfcrxOp3gahuzH5cchAv88Bk1ptBWbT312MI/tMfpIYAbQ1Ai9T13eQ==
X-Received: by 2002:a17:906:9256:b0:6a9:dfca:78d8 with SMTP id c22-20020a170906925600b006a9dfca78d8mr3245952ejx.330.1645118206736;
        Thu, 17 Feb 2022 09:16:46 -0800 (PST)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id z12sm3839844edb.77.2022.02.17.09.16.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Feb 2022 09:16:46 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Anton Romanov <romanton@google.com>, mtosatti@redhat.com,
        kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v2] kvm: x86: Disable KVM_HC_CLOCK_PAIRING if tsc is in
 always catchup mode
In-Reply-To: <de6a1b73-c623-4776-2f14-b00917b7d22a@redhat.com>
References: <20220215200116.4022789-1-romanton@google.com>
 <87zgmqq4ox.fsf@redhat.com> <Yg5sl9aWzVJKAMKc@google.com>
 <87pmnlpj8u.fsf@redhat.com>
 <de6a1b73-c623-4776-2f14-b00917b7d22a@redhat.com>
Date:   Thu, 17 Feb 2022 18:16:45 +0100
Message-ID: <87mtippg5e.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 2/17/22 17:09, Vitaly Kuznetsov wrote:
...
>> (but I still mildly dislike using 'EOPNOTSUPP' for a temporary condition
>> on the host).
>
> It's not temporary, always-catchup is set on KVM_SET_TSC_KHZ and never 
> goes away.

Even if the guest is migrated (back) to the host which supports TSC
scaling?

-- 
Vitaly

