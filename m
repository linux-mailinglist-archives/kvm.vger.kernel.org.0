Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A55FF722CEF
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 18:49:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234960AbjFEQtl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 12:49:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234799AbjFEQth (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 12:49:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F57CE8
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 09:48:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685983730;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E/OIxezM2uYStzlyu+OjnotSbaNfvFepI69i/E1bObs=;
        b=RDKvI3aziArKHrhMR0ia9W5THavbyt5+Ax9hhn82AzJmVa/6FWPbHsKWM0zhvmubSlsCKt
        tT11DUdxIHSgKWF8x/I3BYWYpPE7+eRfyvXED6ysKz80Ak/drYWqRwiZ6M2UQHVcMyqxZx
        0jlHIhDAjn+WI79YykE0HVMV2Ojd1WY=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-641-xkg4feEJPQaznr0HIM2X1Q-1; Mon, 05 Jun 2023 12:48:49 -0400
X-MC-Unique: xkg4feEJPQaznr0HIM2X1Q-1
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-2af31539394so36668091fa.3
        for <kvm@vger.kernel.org>; Mon, 05 Jun 2023 09:48:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685983726; x=1688575726;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E/OIxezM2uYStzlyu+OjnotSbaNfvFepI69i/E1bObs=;
        b=aIkf2y2ykILtCVJqIgEqKuLQoVSHDMdIp5HBoJbHb4PInGPWipPDNnjldxIfY6EJyB
         swHC0MU9xXj+unWWC+EKnKZDUAuaOPKdqMBFZUjZJIfnkoVymou8QMxlxsIrk5EnpqxP
         sjdK//UYIgkEEhQYeVa6tsyH0C1PwbAD0k0mBzyoyy1vpiUKSbDfWMH+nFLgP6QtbKUZ
         6NllhIFQIb3n1yARGPqdnT2LfX1Bmwncd2CL0qwykT0KyiDklV7AGPigsfqmvvNN0pDj
         dp6aNzxzmLR8xeOTV7O50kmepYYin+tIPN+VgI+6nr08QrPkqaFTXuEGecl6PGCuB60Y
         H2wQ==
X-Gm-Message-State: AC+VfDy4lkcjhQQGbuTgilaWjIgBq9Wu5yF4YKs65uQwht5Oxqclk7Ir
        NTWCm0UvRuIhElPLXl17ERex/J0pcUDeFfPgntqZTFppeKD3SXTXjUNitkC5WbuAJpK0J3eyd1+
        fT61BejzDjR7AuNU25FGn
X-Received: by 2002:a2e:b1d1:0:b0:2a8:a651:8098 with SMTP id e17-20020a2eb1d1000000b002a8a6518098mr4028404lja.38.1685983726251;
        Mon, 05 Jun 2023 09:48:46 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ78L5uqt81ps8JytggP5F6lBBWC1TXae5N03SPl8+Il1Nomsggk+ISepK5qXMna580T4i/ECQ==
X-Received: by 2002:a2e:b1d1:0:b0:2a8:a651:8098 with SMTP id e17-20020a2eb1d1000000b002a8a6518098mr4028394lja.38.1685983725921;
        Mon, 05 Jun 2023 09:48:45 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id d13-20020aa7c1cd000000b0051425ba4faasm4129750edp.50.2023.06.05.09.48.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Jun 2023 09:48:45 -0700 (PDT)
Message-ID: <b75c9696-9abb-7a3f-0fb2-56af8ef21bb6@redhat.com>
Date:   Mon, 5 Jun 2023 18:48:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v2] KVM: MAINTAINERS: note that linux-kvm.org isn't
 current
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20230525153204.27960-1-rdunlap@infradead.org>
 <ZHqSYbYscprsU2qT@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <ZHqSYbYscprsU2qT@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/3/23 03:07, Sean Christopherson wrote:
> It's definitely stale, though unless Red Hat (presumed hoster) plans on decomissioning
> the site, I'd prefer to keep the reference and instead improve the site.  We (Google)
> are planning on committing resources to update KVM documentation that doesn't belong
> in the kernel itself, and updatingwww.linux-kvm.org  instead of creating something new
> seems like a no-brainer.  I can't promise an updates will happen super quickly, but I
> will do what I can to make 'em happen sooner than later.

We don't plan to decommission the website (especially not the old KVM 
Forum content), though we might move it over to the same 
(container-based) setup as wiki.qemu.org.

What content do you have in mind that doesn't fit in the kernel 
Documentation/ tree?

Paolo

