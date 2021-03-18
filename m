Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 781CA34082B
	for <lists+kvm@lfdr.de>; Thu, 18 Mar 2021 15:53:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231305AbhCROwi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Mar 2021 10:52:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:59097 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229960AbhCROwf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Mar 2021 10:52:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616079149;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ECZj1OY6qFwHdJt8CU1kR6qrjpoCi85QI/OBr1imPwQ=;
        b=T5i9tRoFKyXYxyIIKRq8hA2AFFnDFPqqHqiXsoXO0cvxuCwhPl8g5gK8Sh/zF+v1k1My2T
        wk7Z3z3D3YAHOz5s3qH6UKtXZjuz9GxZmivujOMB3ALncJBxdxzq1zPunmmWpGAqgRcReG
        zSQpL2HrTlB9lQcT7BeoCaHhnpkZ9Yo=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-404-y5jbRJjYOoW8-MYAyshTWg-1; Thu, 18 Mar 2021 10:52:27 -0400
X-MC-Unique: y5jbRJjYOoW8-MYAyshTWg-1
Received: by mail-ed1-f70.google.com with SMTP id h2so21235098edw.10
        for <kvm@vger.kernel.org>; Thu, 18 Mar 2021 07:52:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=ECZj1OY6qFwHdJt8CU1kR6qrjpoCi85QI/OBr1imPwQ=;
        b=SvUGLMFsLmSDYgWmXbL4fuOEJPA0qggXoS4dQSNI9azFgsmChN84Ewil/FYFWG9WhJ
         KexPv7MUdt9oeVzmPaWudQ8/tm9mS88KskR5E/81t8r9mk2eHgU+jWBU9QmHmUnfA5+8
         N9jl0qXL17jl8rxE8OOzFHyCZmbI/JQVBAvwnV6J4FSf1OFMEKNLNDIIwQMaBwExOLOE
         NdyvdHJ6liEUegquhEfvPF2qtXMbGmae/XsGRgoIYy1ckfieBChm7xHOmF1OeMcg7pVd
         2G4A4jcHKOnIgbw31Zy3g9qwPHKZ8ZO1ArinE8ZKMB5ewXJPVgZ+IG65D0VImun4RhuE
         ceqg==
X-Gm-Message-State: AOAM532Hd3Y31di7OUB9/frSN/HdUh4H4dACy80mjuo2TlhDzIa9iqZg
        ieem1cNb25iv8LokYC8iZVWJ7dHty7P+AYndq6rvJEXkXACgVcVSSYGbb0fmBSpDW3lm8xkPpcF
        VOCU/ZHN0z3Oi
X-Received: by 2002:a50:f38f:: with SMTP id g15mr4066095edm.262.1616079146854;
        Thu, 18 Mar 2021 07:52:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz1N0WUuZKABYtGP3i2mz58USiSdMym4kqMNeWOUyf3jVyqeXAfmV1mefVw/SuNQ/pYAJSYhg==
X-Received: by 2002:a50:f38f:: with SMTP id g15mr4066082edm.262.1616079146666;
        Thu, 18 Mar 2021 07:52:26 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id a22sm2086920ejr.89.2021.03.18.07.52.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 07:52:26 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH v2 6/4] selftests: kvm: Add basic Hyper-V clocksources
 tests
In-Reply-To: <1176f351-220d-003e-2cae-65f0b42c8f18@redhat.com>
References: <20210316143736.964151-1-vkuznets@redhat.com>
 <20210318140949.1065740-1-vkuznets@redhat.com>
 <1176f351-220d-003e-2cae-65f0b42c8f18@redhat.com>
Date:   Thu, 18 Mar 2021 15:52:25 +0100
Message-ID: <8735ws7bva.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 18/03/21 15:09, Vitaly Kuznetsov wrote:
>> +static inline void check_tsc_msr_tsc_page(struct ms_hyperv_tsc_page *tsc_page)
>> +{
>> +	u64 r1, r2, t1, t2;
>> +	s64 delta_ns;
>> +
>> +	/* Compare TSC page clocksource with HV_X64_MSR_TIME_REF_COUNT */
>> +	t1 = mul_u64_u64_shr64(rdtsc(), tsc_page->tsc_scale) + tsc_page->tsc_offset;
>> +	r1 = rdmsr(HV_X64_MSR_TIME_REF_COUNT);
>> +	nop_loop();
>> +	t2 = mul_u64_u64_shr64(rdtsc(), tsc_page->tsc_scale) + tsc_page->tsc_offset;
>> +	r2 = rdmsr(HV_X64_MSR_TIME_REF_COUNT);
>> +
>> +	delta_ns = ((r2 - r1) - (t2 - t1)) * 100;
>> +	if (delta_ns < 0)
>> +		delta_ns = -delta_ns;
>> +
>> +	/* 1% tolerance */
>> +	GUEST_ASSERT(delta_ns * 100 < (t2 - t1) * 100);
>> +}
>> +
>
> I think you should also be able to check r1 and r2 individually, not 
> just r1 and r2.  Is that correct?

Right, we could've checked r1 == t1 and r2 == t2 actually (with some
tiny margin of course). Let me try that.

-- 
Vitaly

