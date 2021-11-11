Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85D4E44D6E3
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 13:52:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233325AbhKKMzB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Nov 2021 07:55:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39964 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232126AbhKKMzA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Nov 2021 07:55:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636635131;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=izEEkdfiq7NVpY8kXHf0OcoN5YJMfZrmMQlE+w7PjLQ=;
        b=eYEyUcZP6pFKby3Se07O/pJ4n7Gnrze2ckTIumSJJWykVAc+8RGX1/o4WUU4Kob01q3qnt
        l+/Fvj/b+6tCeA9EDTeD+dUaKmoAi+I0Zcv4F/FkGlm3ncMuAUKbAjuhcN7ti2mxwGkTGt
        FkTtVvcDdnrKiY3xcwQkZZ21Ft0CN40=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-431-1gL3N9dyN5aDcDPxHZ6-ig-1; Thu, 11 Nov 2021 07:52:10 -0500
X-MC-Unique: 1gL3N9dyN5aDcDPxHZ6-ig-1
Received: by mail-ed1-f69.google.com with SMTP id x13-20020a05640226cd00b003e2bf805a02so5275920edd.23
        for <kvm@vger.kernel.org>; Thu, 11 Nov 2021 04:52:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=izEEkdfiq7NVpY8kXHf0OcoN5YJMfZrmMQlE+w7PjLQ=;
        b=4Yv5apzxHWIjVAWXlWk1vbtLKaeeGodZ6qnL4tvT06LVlBxjBN3Ujuo1E3yLTMKPtM
         hbRZqqHQappHOrP1eyUBTeIcW2CWxWo+beFAR5tRl+SEzn6CAYr2oK7dFmVnfWtzE994
         ZReE1uHk6rKbiYLnbjqhIJ8WzjGXZd/luIo6WD8X5szIqorbDzr8uz17kU91O2rEQqP4
         vO0/C/0RHNft96xXZl0H1lV8Nf78MIiPTo7R8PeyHCxfXPRv4p7iy3J6Su3y/aNsnRRW
         gGLHq2ywAkQw4vHTI2vanGiFL3IKyVcdrx+WO0brkB0i+9cBuN9BXxlc6cgyL2E8lEjw
         2KTA==
X-Gm-Message-State: AOAM533aovb/0K5iRW5CPX8O9tL+RQJ4KMg5iwqMKXlPtPi1016wC4Wk
        hJXlsJ4mfa8RBtV751yy839y2hIlIcwTORAWNA26vHS1KSW3+K61E7fqOIFR/EylscYEqcKF90h
        Ix1rvXII4zGE/
X-Received: by 2002:a17:906:7304:: with SMTP id di4mr8981730ejc.179.1636635129275;
        Thu, 11 Nov 2021 04:52:09 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzbb99NWRupFa9BjRYCWvu5jNGhN8uooO1296jBViRhy7AurDCYM4fd/rSTJahV29MSoaUOKw==
X-Received: by 2002:a17:906:7304:: with SMTP id di4mr8981692ejc.179.1636635129081;
        Thu, 11 Nov 2021 04:52:09 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id lv19sm1431396ejb.54.2021.11.11.04.52.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Nov 2021 04:52:08 -0800 (PST)
Message-ID: <e7b2172f-c0d9-41ef-0607-257c3871b376@redhat.com>
Date:   Thu, 11 Nov 2021 13:52:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 2/2] KVM: SEV: Fall back to __vmalloc() for SEV-ES scratch
 area if necessary
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>
References: <20211109222350.2266045-1-seanjc@google.com>
 <20211109222350.2266045-3-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211109222350.2266045-3-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/9/21 23:23, Sean Christopherson wrote:
> The buffer is purely a KVM software construct, i.e. there's
> no need for it to be physically contiguous, and at a max allowed size of
> 16kb it's just large enough that kzalloc() could feasibly fail due to
> memory fragmentation.

That isn't entirely correct, as kzalloc() won't really fail for requests 
up to 32kb, i.e. order <= PAGE_ALLOC_COSTLY_ORDER.  However, the 
reasoning is correct so I queued the patches.

Paolo

