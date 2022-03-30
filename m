Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 726CC4EC3B4
	for <lists+kvm@lfdr.de>; Wed, 30 Mar 2022 14:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344621AbiC3MRC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Mar 2022 08:17:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345396AbiC3MNx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Mar 2022 08:13:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5D0624B1C1
        for <kvm@vger.kernel.org>; Wed, 30 Mar 2022 05:07:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648642038;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p4IaRvBma0W1UBcawEsDhyvvua/6JtF1rikRuXR/v3o=;
        b=QpvHhGGlh4FPtTdJKMM4fR6Q6imhid8mQzlVhsvTXTbLYY+UZzgS5SLoXrWzBW3QAim1BE
        VX2wzkPiY1L/h/IP6wKlqlKJBig5rKfCEKeBPojdJZa4lWpJ9KlqtwuM0bwKun3h0radJx
        5u7fOslJxQLMvNGjFnwVlvNybfukK8Q=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-241-mb_8M31ZP12f4XRfZBSkiw-1; Wed, 30 Mar 2022 08:07:16 -0400
X-MC-Unique: mb_8M31ZP12f4XRfZBSkiw-1
Received: by mail-ed1-f69.google.com with SMTP id j39-20020a05640223a700b0041992453601so10560964eda.1
        for <kvm@vger.kernel.org>; Wed, 30 Mar 2022 05:07:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=p4IaRvBma0W1UBcawEsDhyvvua/6JtF1rikRuXR/v3o=;
        b=oqcFPlIk8GGTPTMWCEfInogiq7sYX00vt6lVL52SjKGroRJOLmYcy/neY/01Cw5SIH
         8su9IaowBVfUFZFyBfExC9Oy/E5/IwXjAeKeHVfJIhaKgmPc5BgZ0O+TG7uXQhc8PQ/U
         bV9bbfli5eWIFFWydSi1tcZn4ZxivxzHQh+GTx+ATXEWSqkMgYawgAMmFkGeO0d6KilI
         U6WEEuxGTu4YfkLRuz3Tk9zTb+s1oAnqVdP9JzKhLHO927Xm4vPjnAIMbePqU2fsrLLz
         Gg+MdygILWTnbvMiyQ3OXcy1XxJ1CI7hZc0yOFBRN3J4Wr/XQGJVji3J7zxsrk3K6B9L
         bmNg==
X-Gm-Message-State: AOAM530hdTWO8A5yT61UfMUflm2TjLO5ozYwN80e65QZGvoGhL6mx/Cj
        z/bFG0Yrx2SZHvJCDwph8jZn/4K9gkKLIIhf+OEcTqlvQ2+ExHd/qe2bN1Jn1sFz195x1TvZKAK
        fVco3znyQbVoy
X-Received: by 2002:a17:907:629a:b0:6d7:b33e:43f4 with SMTP id nd26-20020a170907629a00b006d7b33e43f4mr40595893ejc.149.1648642034594;
        Wed, 30 Mar 2022 05:07:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzStAnN2iHa+Rqbu8eIJhXelGfz14EyM1yta1FQP72irc8UflbROtPx9mfIOIWwkGT4QHJKyw==
X-Received: by 2002:a17:907:629a:b0:6d7:b33e:43f4 with SMTP id nd26-20020a170907629a00b006d7b33e43f4mr40595860ejc.149.1648642034371;
        Wed, 30 Mar 2022 05:07:14 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:8ca6:a836:a237:fed1? ([2001:b07:6468:f312:8ca6:a836:a237:fed1])
        by smtp.googlemail.com with ESMTPSA id v2-20020a17090606c200b006a728f4a9bcsm8235476ejb.148.2022.03.30.05.07.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Mar 2022 05:07:13 -0700 (PDT)
Message-ID: <27670a35-c67e-726f-f03f-9cf2eae83523@redhat.com>
Date:   Wed, 30 Mar 2022 14:07:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 1/8] KVM: x86: avoid loading a vCPU after .vm_destroy was
 called
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        Ingo Molnar <mingo@redhat.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org
References: <20220322172449.235575-1-mlevitsk@redhat.com>
 <20220322172449.235575-2-mlevitsk@redhat.com> <YkOkCwUgMD1SVfaD@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YkOkCwUgMD1SVfaD@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/30/22 02:27, Sean Christopherson wrote:
> Rather than split kvm_free_vcpus(), can we instead move the call to svm_vm_destroy()
> by adding a second hook, .vm_teardown(), which is needed for TDX?  I.e. keep VMX
> where it is by using vm_teardown, but effectively move SVM?
> 
> https://lore.kernel.org/all/1fa2d0db387a99352d44247728c5b8ae5f5cab4d.1637799475.git.isaku.yamahata@intel.com

I'd rather do that only for the TDX patches.

Paolo

