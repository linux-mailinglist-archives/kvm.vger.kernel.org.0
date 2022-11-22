Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29AC7634082
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 16:45:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232625AbiKVPpA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 10:45:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233966AbiKVPo6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 10:44:58 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 944CF7118B
        for <kvm@vger.kernel.org>; Tue, 22 Nov 2022 07:44:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669131840;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xWL302xeQNaUeD1XBBbHjOQmICjs58t7c74x1CuLrlw=;
        b=UVvTU98oth9ZRvLUMmePRuiGGsHZXOQrnehKYJX6K4NentrwNJTUDvIjkqcYwRVOrDhyaD
        M5hT9BxYhUHchBwBOgk3XBY6AaH0Cx1LPUHloT05TfIAKYx9twOvaomIEWpi8oAG8gCotF
        GcZEA00dWF+uHhxbRGeRYv6rCtPUjtk=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-513-9LZsYUU3N-eCB5ecrg3RCg-1; Tue, 22 Nov 2022 10:43:59 -0500
X-MC-Unique: 9LZsYUU3N-eCB5ecrg3RCg-1
Received: by mail-ed1-f69.google.com with SMTP id y20-20020a056402271400b004630f3a32c3so8991180edd.15
        for <kvm@vger.kernel.org>; Tue, 22 Nov 2022 07:43:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xWL302xeQNaUeD1XBBbHjOQmICjs58t7c74x1CuLrlw=;
        b=c4Lw0UIbyzDMRiBYuREUhA3TlVVBC6dQrPidYeXoPYmg1CqqFXZQdzX05RhUQrHyWr
         d/OH/xv8YywOUXQKh/HDs/zIaTnHInk90smmalk0pLwjQae74gb4xlN2G0pSqQap/oQQ
         zZDEMmpEpoUJdALRebE7/liSd04fhFNH9gyAXokTwWKG/wtEJWi6LDWI4bGbho0QUiMb
         KTPjXF3ycLq7+9Zbk/CbssgwTVJ/ILuulSNOI3/1wM+CnDQbDIU1TRdNj8Nt/CzqZk3A
         5qocdylS7gNi0KC+BbXPsaS6nIeOXxoC6yulAZqETYTBxyQAgvMf5scVtnmSoYesmWyu
         q0iQ==
X-Gm-Message-State: ANoB5pkG7mddqt5Yq4beJ/6cSUIzPAMdVHfEic7IR2IibHQACUUqd5qs
        QO5FpIQ67KkYDxkaKzYOTTwoF+w4Vsp09JcBGPi99BY1ssCwpEY2BkSYWNo8dJAbtpBdN2Hu541
        gLIYBZjTADuIz
X-Received: by 2002:a05:6402:2024:b0:468:f633:9484 with SMTP id ay4-20020a056402202400b00468f6339484mr20729277edb.200.1669131838107;
        Tue, 22 Nov 2022 07:43:58 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6HyiTcH1qadnX+DoTbSf5WrVcbc+T6q+Jo/GX4nTI50Ag4+RR58bqywik7IbUTzuQOnoDUzg==
X-Received: by 2002:a05:6402:2024:b0:468:f633:9484 with SMTP id ay4-20020a056402202400b00468f6339484mr20729262edb.200.1669131837911;
        Tue, 22 Nov 2022 07:43:57 -0800 (PST)
Received: from ovpn-194-185.brq.redhat.com (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id fy21-20020a170906b7d500b0077d6f628e14sm6125586ejb.83.2022.11.22.07.43.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 07:43:57 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 0/7] KVM: x86: Hyper-V invariant TSC control feature
In-Reply-To: <Y0nA0DCeh4IPmWMX@google.com>
References: <20221013095849.705943-1-vkuznets@redhat.com>
 <Y0nA0DCeh4IPmWMX@google.com>
Date:   Tue, 22 Nov 2022 16:43:56 +0100
Message-ID: <87o7szouyr.fsf@ovpn-194-185.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Thu, Oct 13, 2022, Vitaly Kuznetsov wrote:
>> Normally, genuine Hyper-V doesn't expose architectural invariant TSC
>> (CPUID.80000007H:EDX[8]) to its guests by default. A special PV MSR
>> (HV_X64_MSR_TSC_INVARIANT_CONTROL, 0x40000118) and corresponding CPUID
>> feature bit (CPUID.0x40000003.EAX[15]) were introduced. When bit 0 of the
>> PV MSR is set, invariant TSC bit starts to show up in CPUID. When the 
>> feature is exposed to Hyper-V guests, reenlightenment becomes unneeded.
>> 
>> Note: strictly speaking, KVM doesn't have to have the feature as exposing
>> raw invariant TSC bit (CPUID.80000007H:EDX[8]) also seems to work for
>> modern Windows versions. The feature is, however, tiny and straitforward
>> and gives additional flexibility so why not.
>> 
>> Vitaly Kuznetsov (7):
>>   x86/hyperv: Add HV_EXPOSE_INVARIANT_TSC define
>>   KVM: x86: Add a KVM-only leaf for CPUID_8000_0007_EDX
>>   KVM: x86: Hyper-V invariant TSC control
>>   KVM: selftests: Rename 'msr->available' to 'msr->fault_exepected' in
>>     hyperv_features test
>>   KVM: selftests: Convert hyperv_features test to using
>>     KVM_X86_CPU_FEATURE()
>>   KVM: selftests: Test that values written to Hyper-V MSRs are preserved
>>   KVM: selftests: Test Hyper-V invariant TSC control
>
> For the series, in case Paolo ends up grabbing this:
>
> Reviewed-by: Sean Christopherson <seanjc@google.com>
>

I completely forgot about this one! Any chance it can still be queueed
for 6.2? Thanks!

-- 
Vitaly

