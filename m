Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E78E265599F
	for <lists+kvm@lfdr.de>; Sat, 24 Dec 2022 10:24:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbiLXJYv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 24 Dec 2022 04:24:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiLXJYt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 24 Dec 2022 04:24:49 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51F81C750
        for <kvm@vger.kernel.org>; Sat, 24 Dec 2022 01:24:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671873842;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cQUoO4G6sdzLrmUADt2hv9AJA1j16aHhp8BOh9XyH3Y=;
        b=CZBoYWAy6Z5RBAWnvdnyWFuYL2HcefczTyu05FYC19uc2jlNr+paRq58bkJuJaAuvF2e3I
        R1reaewZCxioBnU2dHsH8dS6QYUSFl4Jk9864ePBdKrNoZMdYGmMfyk71g2byGORYJB+mc
        tvYYGTM3jXQHulCMLta+IdQDIItMIXA=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-640-EFT2sSX_P0OfCxuhO-GjWA-1; Sat, 24 Dec 2022 04:24:01 -0500
X-MC-Unique: EFT2sSX_P0OfCxuhO-GjWA-1
Received: by mail-ej1-f71.google.com with SMTP id hd17-20020a170907969100b007c117851c81so4700918ejc.10
        for <kvm@vger.kernel.org>; Sat, 24 Dec 2022 01:24:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cQUoO4G6sdzLrmUADt2hv9AJA1j16aHhp8BOh9XyH3Y=;
        b=XqGo3aWi719ETpWEBWoXq4CVmqS8KIpL/7kQ91lwXVpujYZwr0iskFrIBnfzqhNPRZ
         PvIczL9egEX3Y1po4fUVK7j4A18l+1O6Rf/Fpc6rpSC3NB34lJVgR5r3uuFsKRjan4f/
         nFIGL/rA6LEdiNE222QPu2MGCX/udpFLjZFILxRs04sF0VC8ZcXKJzjJx4dccVJVNrR2
         SNPNr4r+Y9ULXsnKcuMc8Sg4A9PlXWMcQdWXpxqw5u2y0buWHngAsxfSvl4VufiiU8Qh
         uvAlCJL8+5CTiBt0a4m3v7zc48rez8mdUdZ9UEs8pomm2oKyRZ+V5uSqaf+0Ud+djLiA
         0VjA==
X-Gm-Message-State: AFqh2kpTRMUys2bb5ep+PTZh0tTjiBDZw/9tX/ZjS8/lSx53bNgekmC2
        Y0FWmQ0tG6H4PXfLEA1JZa1ERa0pZOpwSCzg4P1L4ZYHZW6QJmnN4rqqLuxzh2uG1Z/JvtZ6P7x
        JsNRxRrtbrWQT
X-Received: by 2002:a17:907:c084:b0:7c1:22a6:818f with SMTP id st4-20020a170907c08400b007c122a6818fmr9962695ejc.25.1671873840059;
        Sat, 24 Dec 2022 01:24:00 -0800 (PST)
X-Google-Smtp-Source: AMrXdXu5yag+Wn0Qcys8xdIlgtscsBUCyajRo/QuR9Np12zFtuRKH0vsauC+7pwndJ75MH59prtGFQ==
X-Received: by 2002:a17:907:c084:b0:7c1:22a6:818f with SMTP id st4-20020a170907c08400b007c122a6818fmr9962684ejc.25.1671873839849;
        Sat, 24 Dec 2022 01:23:59 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id u18-20020a1709061db200b007c073be0127sm2305389ejh.202.2022.12.24.01.23.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 24 Dec 2022 01:23:59 -0800 (PST)
Message-ID: <363f4713-6105-82d1-351e-423d07470cdf@redhat.com>
Date:   Sat, 24 Dec 2022 10:23:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH 12/14] KVM: selftests: Use wildcards to find library
 source files
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Tom Rix <trix@redhat.com>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-riscv@lists.infradead.org,
        llvm@lists.linux.dev, linux-kernel@vger.kernel.org,
        Ricardo Koller <ricarkol@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>
References: <20221213001653.3852042-1-seanjc@google.com>
 <20221213001653.3852042-13-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20221213001653.3852042-13-seanjc@google.com>
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

On 12/13/22 01:16, Sean Christopherson wrote:
> Use $(wildcard ...) to find the library source files instead of manually
> defining the inputs, which is a maintenance burden and error prone.

No, please don't.  This leads to weird errors, for example when "git 
checkout" is interrupted with ^C.   I have applied patches 1-11.

Paolo

