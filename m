Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D6E94AEF8C
	for <lists+kvm@lfdr.de>; Wed,  9 Feb 2022 11:53:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbiBIKxK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 05:53:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbiBIKxK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 05:53:10 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5173E13E817;
        Wed,  9 Feb 2022 02:33:10 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id u12so1809020plq.10;
        Wed, 09 Feb 2022 02:33:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=wrsBIU5iQOCD/ZYGNioXMA0nQCq7ZtyVJUNsT+679Xc=;
        b=DP1rTDjVtEvkSz7OPfM+mIcFsaOV6Y93ws+CPpttlEEzjsZ5OcdltGFFWy4ja6XzRl
         +WXW5rbd2OyboWoFgc+8r41RHvurL5FVnDmvb+Nxte5sqAf/KL9rG24Thr+jsepsz/BB
         XSUk2QKL+4FL7q7t6r7KygyYZOMcwCwH5M+gjv+pX3/HVf5BY1RNvqynqKz01PZUFPFU
         uFUh/JYh8SD0unldsQDKlmTPkpif8GkntAarWIZlwCNZCuC8iCHJaMdgmNWlr4K5Nz0k
         mtvlol4a0EaEWJ0JwBCUn1h6MZ/ECgrYflPgEtaxDYJInxVuGS9WJ97mW5ERzFooF77M
         CLpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=wrsBIU5iQOCD/ZYGNioXMA0nQCq7ZtyVJUNsT+679Xc=;
        b=petm6/t/D54Cxx3U+8K3K6KW+q8Uvr22Cd7Cwfepvub/oegilet5u931uoXD30wtbr
         7tLePZ+XUwdOx5Lprhr7p7YF5Ub80VovAy/kVZeSqeW3w5z7yb5rl5IcfA42IELGA1nr
         xw5GPyl0xTSP0hZumM+gEm2/FCCauaY//dDZu5lNM4eLgITSacQLlHeNT4/gbEjySkDw
         94u5STe69VZBiDM3tp0/cwQB/G98LWqxjQmOC67qdh8UWKFqVtAsdHeeEbKpXhEcdyiL
         2cwaVTiZkvdW1kTbp7lPiA8PCOuTAuwv9dYc6QK3cAEoz2g6j6exMFC/XjixSism+/o9
         LNlg==
X-Gm-Message-State: AOAM531BwoyvGQWbuJFUbfapMtiCCtTKC7HfGD3xwTIJSDBNTsO6mJxS
        fupkqjn818wHJCF8XOJQUrA=
X-Google-Smtp-Source: ABdhPJwqk+Oae5wWC/tHT21nm5TioEJqLdYLjNgP7TRePrtG2iAOE9FNjxsjk6Jl6dP83soJr22bLA==
X-Received: by 2002:a17:902:7e0a:: with SMTP id b10mr1507616plm.17.1644402790326;
        Wed, 09 Feb 2022 02:33:10 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id b12sm6632598pfl.123.2022.02.09.02.33.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Feb 2022 02:33:09 -0800 (PST)
Message-ID: <09d8b472-000b-7150-f60d-ffb5706b164e@gmail.com>
Date:   Wed, 9 Feb 2022 18:33:00 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.0
Subject: Re: [PATCH v5 1/3] KVM: x86: Provide per VM capability for disabling
 PMU virtualization
Content-Language: en-US
To:     "Paolo Bonzini - Distinguished Engineer (kernel-recipes.org) (KVM HoF)" 
        <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, seanjc@google.com,
        David Dunn <daviddunn@google.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20220123184541.993212-1-daviddunn@google.com>
 <20220123184541.993212-2-daviddunn@google.com>
 <CALMp9eSuavLEJ0_jwuOgmSX+Y8iJLsJT0xkGfMZg6B7kGyDmBQ@mail.gmail.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
In-Reply-To: <CALMp9eSuavLEJ0_jwuOgmSX+Y8iJLsJT0xkGfMZg6B7kGyDmBQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

cc LKML and full list of KVM reviewers.

On 25/1/2022 2:39 am, Jim Mattson wrote:
> On Sun, Jan 23, 2022 at 10:45 AM David Dunn <daviddunn@google.com> wrote:
>>
>> KVM_CAP_PMU_DISABLE is used to disable PMU virtualization on individual
>> x86 VMs.  PMU configuration must be done prior to creating VCPUs.
>>
>> To enable future extension, KVM_CAP_PMU_CAPABILITY reports available
>> settings via bitmask when queried via check_extension.
>>
>> For VMs that have PMU virtualization disabled, usermode will need to
>> clear CPUID leaf 0xA to notify guests.
>>
>> Signed-off-by: David Dunn <daviddunn@google.com>
> 
> Nit: The two references to CPUID leaf 0xA should be qualified as
> applying only to Intel VMs.
> 
> Reviewed-by: Jim Mattson <jmattson@google.com>
> 

Nit: It looks like we already have "#define KVM_CAP_SYS_ATTRIBUTES 209".

Hope it helps a little:

Reviewed-by: Like Xu <likexu@tencent.com>
