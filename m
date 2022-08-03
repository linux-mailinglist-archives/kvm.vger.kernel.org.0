Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 665475890CC
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 18:50:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236711AbiHCQuj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 12:50:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236910AbiHCQuh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 12:50:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 39CD86422
        for <kvm@vger.kernel.org>; Wed,  3 Aug 2022 09:50:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659545435;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NEAncNPlqkr+KXbJj8athp1uFouyJqzbCLtpoJ5cyp8=;
        b=Aro9KG989BstdoM0rTY5zTMYhqRe8B6trXLUzEDQ3b4RUic1pzz14vhgfch6pvE6fAwN1y
        uEWKiO6VfOctcfxbhdLmr6DKHpD9G19EGkZWHWjT2OF+4w6vvAaTaPavuF0aFfnOyAL61I
        9mabz9MvCgj8Ew8gaDtu5D3gOoC/A+s=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-515-XkqfN1lGPrOcnF-4Al-gSA-1; Wed, 03 Aug 2022 12:50:34 -0400
X-MC-Unique: XkqfN1lGPrOcnF-4Al-gSA-1
Received: by mail-wm1-f69.google.com with SMTP id m4-20020a7bce04000000b003a386063752so341057wmc.1
        for <kvm@vger.kernel.org>; Wed, 03 Aug 2022 09:50:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=NEAncNPlqkr+KXbJj8athp1uFouyJqzbCLtpoJ5cyp8=;
        b=M1kqGJrEJrD83g2Kg8Jsxt8CWv6+IxSNvmsA/fCDr5hwtPCCO4dvk5TO+LEDXQkAm9
         Lz91wYQyiBRNWV0q5seK+ehtA4Ku67qEcZjy1tOjEYesFU86VBuOwsVEsYsHGZk3sbrh
         wF8gYY4u81OjOiZgbljke/ZDZgGdmbuXu7I4+7iWATKJ5v2/yLyDh7ywMh3M38Z+O+JZ
         eWtfAJdnBolNzyOGXzt+VuYDGUqqikwjoQu0M16H2+yACOljQPAEZjV4SQG6mPvkUuY8
         cTlvGBQOUPEztcKX+53ph6jaBcwtC6yyPVw/te+wSAbGzWCSQRnylxBSlqLa9hoyxzdP
         094A==
X-Gm-Message-State: ACgBeo2Pmwoj+lGzkn5tYjYfZLoFkmMaHyMOTJae9UQ7S50sDKvC+Ox0
        zyZv2uPXOvKH6j4Ij1F/pmDJqcwSJpRSKIUZuXMsz1ziRX3+t9iFQlVlUUUupijq4Nx3DHNJNR9
        8x8CSlOOvaLSK
X-Received: by 2002:a05:600c:a07:b0:39e:da6e:fc49 with SMTP id z7-20020a05600c0a0700b0039eda6efc49mr3311580wmp.143.1659545432885;
        Wed, 03 Aug 2022 09:50:32 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7LYhF69Tj8wD+f/h1aP1S1C3q4Vuqt0UQwJUlPcBc6I3wqZsJ7PBentjPZpGxljsIotWaNsg==
X-Received: by 2002:a05:600c:a07:b0:39e:da6e:fc49 with SMTP id z7-20020a05600c0a0700b0039eda6efc49mr3311560wmp.143.1659545432684;
        Wed, 03 Aug 2022 09:50:32 -0700 (PDT)
Received: from ?IPV6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.googlemail.com with ESMTPSA id y11-20020a056000108b00b0021e4f595590sm18411537wrw.28.2022.08.03.09.50.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Aug 2022 09:50:31 -0700 (PDT)
Message-ID: <e7468f00-5d1a-5d9d-ae14-060cdf0f9558@redhat.com>
Date:   Wed, 3 Aug 2022 18:50:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH MANUALSEL 5.18 1/6] KVM: x86: do not report a vCPU as
 preempted outside instruction boundaries
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Jann Horn <jannh@google.com>, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        kvm@vger.kernel.org
References: <20220614021116.1101331-1-sashal@kernel.org>
 <YrI25yOy7WMqr+x3@sashalap>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YrI25yOy7WMqr+x3@sashalap>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/21/22 23:23, Sasha Levin wrote:
> Paolo, ping?

Sorry I missed the whole bunch of MANUALSEL patches.

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

for all six.

Paolo

