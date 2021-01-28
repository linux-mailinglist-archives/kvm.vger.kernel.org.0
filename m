Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BDF830799B
	for <lists+kvm@lfdr.de>; Thu, 28 Jan 2021 16:25:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232109AbhA1PY1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jan 2021 10:24:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34053 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232496AbhA1PW4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 Jan 2021 10:22:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611847290;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7+YeWBZhpv/II3pgSGIZfZIZRfHFqPDaeTXzEFgNzdM=;
        b=DcUdbOJweT0Niifvv4r24fCnnfarGMev0+qVIGFAIGcdxRZfEx3/8Sr2tlvG7CfX4tsrrB
        piuVg6j1p9gbloGL43n5cx16YnBQXtXiliPJXzArwuH764SlLsb3UZ1dlTPmznaVVbP4LF
        lwmsTpDsL6fyNwJJhQfrvGIw7PmlqVI=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-45-qu3ZUntANz6j4qIf_8LTEA-1; Thu, 28 Jan 2021 10:21:28 -0500
X-MC-Unique: qu3ZUntANz6j4qIf_8LTEA-1
Received: by mail-ej1-f71.google.com with SMTP id m4so2324154ejc.14
        for <kvm@vger.kernel.org>; Thu, 28 Jan 2021 07:21:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=7+YeWBZhpv/II3pgSGIZfZIZRfHFqPDaeTXzEFgNzdM=;
        b=K52eF6NlVRaGWeqvhOOUr+t8Ye3EnmkQ2V0YW/lXQoJSGVe2YdqfZWQemCUtEvpgT3
         oM9neF07KXyMp/nxzZivUztkr59KAkVT2HMpI5tz8naYm+yOJ+9m2hALu04VtxCEeMXb
         SAleW6WDHMjlTwjeErE1ctJ1rWfx1gp0nZxqgXihJ3JpfcLITzpQbweMs4ct2zn8uaAu
         WWrB0RuhbXlA8pU6gn0P+RI6TCuC2trjgqQ2ef7x3Z+Jo106b2usPjsKD3GmEKl6/3li
         qGaOIzfsOshm1wXQO/R5utlded4h5OMBcymwmsuPnCbGjZtBMEF6XRtLrbrFvRNyEAuu
         bbrQ==
X-Gm-Message-State: AOAM531IWz/vDLjNINrht1F28rbIGijUah40PZ5NUs+Oet/fUzJC/2Zy
        nFWIqIY59iNKE/4H+XVrauefI9c94GySamOmegI1+98vLlb6IdcFZT03dbAZ9wCtsEIGTed9PGV
        8yxLeDvqpmttv
X-Received: by 2002:a17:907:1b27:: with SMTP id mp39mr11554928ejc.519.1611847286926;
        Thu, 28 Jan 2021 07:21:26 -0800 (PST)
X-Google-Smtp-Source: ABdhPJytg1sbgUOlSyM0rQmxw9E7KQxVKIw5Cit9DkLJGAc8mTpfo9/oDLYviVwYXJsCP4GDoIU6lg==
X-Received: by 2002:a17:907:1b27:: with SMTP id mp39mr11554897ejc.519.1611847286568;
        Thu, 28 Jan 2021 07:21:26 -0800 (PST)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id g14sm2473957ejr.105.2021.01.28.07.21.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jan 2021 07:21:25 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH v2 11/15] KVM: x86: hyper-v: Prepare to meet unallocated
 Hyper-V context
In-Reply-To: <fe1bb68d-96a0-cbb3-967a-8576c3533cf6@redhat.com>
References: <20210126134816.1880136-1-vkuznets@redhat.com>
 <20210126134816.1880136-12-vkuznets@redhat.com>
 <fe1bb68d-96a0-cbb3-967a-8576c3533cf6@redhat.com>
Date:   Thu, 28 Jan 2021 16:21:25 +0100
Message-ID: <87y2gd140a.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 26/01/21 14:48, Vitaly Kuznetsov wrote:
>> 
>> +static inline u32 to_hv_vpindex(struct kvm_vcpu *vcpu)
>> +{
>> +	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
>> +
>> +	return hv_vcpu ? hv_vcpu->vp_index : kvm_vcpu_get_idx(vcpu);
>> +}
>> +
>
> I'd rather restrict to_* names for pointer conversions. 
> kvm_hv_get_vpindex is a better choice here.

No objections, feel free to rename. Alternatively, I can send a
follow-up patch.

-- 
Vitaly

