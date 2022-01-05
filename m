Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2E7B4850BC
	for <lists+kvm@lfdr.de>; Wed,  5 Jan 2022 11:10:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239240AbiAEKKE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 05:10:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:34990 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229770AbiAEKKD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Jan 2022 05:10:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641377402;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EYIR7J8q3TIsA84CjFhzw4cuwyQF/1ednNVnYGVZmik=;
        b=TRaxEw6jixPKdtJdxBDXtv+oHGee18f2BMho8y1tOJrN0sOX/5AlUzZSK6svp0xvc6E9+4
        5VxEKtxzoZ28CIsFNgMw7e6tn3R+2fu+kkte3jY1DUfqif22/DqFFM6oZ1lwgEFKCdOEdX
        MQ1I7B4B4+s2PmMWe8D5r69WPTIyQK8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-625-WwInMNpROSmw5-ZRh4b8KA-1; Wed, 05 Jan 2022 05:10:01 -0500
X-MC-Unique: WwInMNpROSmw5-ZRh4b8KA-1
Received: by mail-wm1-f72.google.com with SMTP id r2-20020a05600c35c200b00345c3b82b22so1480880wmq.0
        for <kvm@vger.kernel.org>; Wed, 05 Jan 2022 02:10:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=EYIR7J8q3TIsA84CjFhzw4cuwyQF/1ednNVnYGVZmik=;
        b=V44vGAnHalcFdAt0zWMnLIJbF1Fkhw+rwtWNRDwgJ3aqXLH4lZGGHawqCTl8G2TQCA
         YPnlD+5QtJDHBcYHlo0WP33npzdT0zqUu3PI51nqhOREwlwkWIKUYG2wrGp9BB5vWiZI
         7eKQfSI7e57w01kWUTFYB9Yaygy9qQ0dpR9/6tjJ587DKIFUltEeIsJQKySx7H6ImMWs
         aqV1F93HKA5RsZrrb11oiZTaIZDuOlJ2N8fDctewkRvbrmX1r765VkMUkjcyZsDcs8MQ
         uWt9qd2jw2McIDCoLT3R0WIBi1GkylkpStcvo12eItlR0gCWVlz607TlE+x/uxAJV3GK
         i0HA==
X-Gm-Message-State: AOAM533XZMXlQplSmDch5rOsYnfzwqkwBvVIarY/X4a24XvJTatbfSF5
        MDqkbpb92vUv+fSvRNHXekMMhEYG3Tu+IJDBRoLNhliB96K6dzkw3aM80+fLpYFCFMdw6Q9wUyc
        eUxCbFuGVPTV5
X-Received: by 2002:adf:e88a:: with SMTP id d10mr45695173wrm.114.1641377400035;
        Wed, 05 Jan 2022 02:10:00 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzoVBTcoWqt1ECD+LSMEnDyPI0xZ67s0U9dh842SryfHZy6fU5K7FRHxyT9LDZAuN/0IuqVnA==
X-Received: by 2002:adf:e88a:: with SMTP id d10mr45695160wrm.114.1641377399867;
        Wed, 05 Jan 2022 02:09:59 -0800 (PST)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id q3sm4505633wrr.55.2022.01.05.02.09.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jan 2022 02:09:59 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: x86: Forbid KVM_SET_CPUID{,2} after KVM_RUN
In-Reply-To: <ceb63787-b057-13db-4624-b430c51625f1@redhat.com>
References: <20211122175818.608220-1-vkuznets@redhat.com>
 <20211122175818.608220-3-vkuznets@redhat.com>
 <16368a89-99ea-e52c-47b6-bd006933ec1f@redhat.com>
 <20211227183253.45a03ca2@redhat.com>
 <61325b2b-dc93-5db2-2d0a-dd0900d947f2@redhat.com>
 <87mtkdqm7m.fsf@redhat.com> <20220103104057.4dcf7948@redhat.com>
 <875yr1q8oa.fsf@redhat.com>
 <ceb63787-b057-13db-4624-b430c51625f1@redhat.com>
Date:   Wed, 05 Jan 2022 11:09:58 +0100
Message-ID: <87o84qpk7d.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 1/3/22 13:56, Vitaly Kuznetsov wrote:
>>   'allowlist' of things which can change (and put
>> *APICids there) and only fail KVM_SET_CPUID{,2} when we see something
>> else changing.
>
> We could also go the other way and only deny changes that result in 
> changed CPU caps.  That should be easier to implement since we have 
> already a mapping from CPU capability words to CPUID leaves and registers.
>

Good idea, I'll look into it (if noone beats me to it).

-- 
Vitaly

