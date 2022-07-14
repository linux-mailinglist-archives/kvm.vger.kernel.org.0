Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9DC0575163
	for <lists+kvm@lfdr.de>; Thu, 14 Jul 2022 17:05:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239662AbiGNPFx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jul 2022 11:05:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238532AbiGNPFu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jul 2022 11:05:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6EDCA12080
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 08:05:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657811148;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HFc06b2VfDyKx2DgSvnfDqpBVzHP5QTPT3Pnt7QYJWw=;
        b=RYXV8yP2T7OLQzs4dLmCNL148j3cvZDBysfr5xAF6IJ41EXUfYDHhyu7wpABbewTQioCge
        GWRWjDPM9Rdx0hVBTrkBPS6Ujwidb4kPa+980UbAccyYJeaU135yLi9q2GF7K23zH/Le5u
        1/N00uEfbx2vQ08+lSGLwSoYjmECFtI=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-288-snY4wBQGNGGcMrY1ts1pcA-1; Thu, 14 Jul 2022 11:05:45 -0400
X-MC-Unique: snY4wBQGNGGcMrY1ts1pcA-1
Received: by mail-ed1-f71.google.com with SMTP id j6-20020a05640211c600b0043a8ea2c138so1682626edw.2
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 08:05:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=HFc06b2VfDyKx2DgSvnfDqpBVzHP5QTPT3Pnt7QYJWw=;
        b=I4BnkdHCR+K4aqUr6SVxCoVmX59YhfzH9TPdNaFAssjQOUzoWEgSHv4huB5Vyem3Da
         9A+KGqW8k5PuTkJHM4kxxB3VVNcEjAZ8GzczS7ABlY4HzSKlIzaWjrcdU0rVkVXSFuoi
         Gwnn4xOo0Sh6nuYl/jIu6eOSwVGH73nnpL6A0YPcrYWDcVAMT+kRAXvb6xntq/dvwh1Y
         DppgtUaj1S7v2MoHTmLxWH9SSYkuXSQJ0xpVHDhJNDcqw2PYrXgvxPyjhvJhk9nHMlvX
         647XYY51ctP5CqehmHuhNr2JRuTTYf+akxTt7lmtNL/xPWTcUv/3SEhe8AXHZ/3UE4iz
         TG0Q==
X-Gm-Message-State: AJIora+hbUruMSWZF7j/elWZSkEZODAa4a3dlZ0dn4gX+BUMPBG33RNo
        m3cxZSySjiSxKcDCdzpAy6Kme21hO2/N0FT3NUkjpDtZ+9cfktQyrsr43g6gxqrNihxwxmM8/wK
        M8vLmSOZBuELX
X-Received: by 2002:a05:6402:e9f:b0:435:644e:4a7d with SMTP id h31-20020a0564020e9f00b00435644e4a7dmr12871885eda.114.1657811143760;
        Thu, 14 Jul 2022 08:05:43 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tmJWul7l+Ug5o5Pe8ztJJl4Vb1O65uGu/p5ANaHZ4dCvmwYg1VI2lV8xWlydvFiIsSp5hNBQ==
X-Received: by 2002:a05:6402:e9f:b0:435:644e:4a7d with SMTP id h31-20020a0564020e9f00b00435644e4a7dmr12871848eda.114.1657811143493;
        Thu, 14 Jul 2022 08:05:43 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id 7-20020a170906308700b0072ee0976aa2sm422811ejv.222.2022.07.14.08.05.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jul 2022 08:05:43 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH 1/3] KVM: x86: Hyper-V invariant TSC control
In-Reply-To: <399f335a97f5e46a339f906290e0c90de3613fe9.camel@redhat.com>
References: <20220713150532.1012466-1-vkuznets@redhat.com>
 <20220713150532.1012466-2-vkuznets@redhat.com>
 <399f335a97f5e46a339f906290e0c90de3613fe9.camel@redhat.com>
Date:   Thu, 14 Jul 2022 17:05:42 +0200
Message-ID: <87zghbn395.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Maxim Levitsky <mlevitsk@redhat.com> writes:

> On Wed, 2022-07-13 at 17:05 +0200, Vitaly Kuznetsov wrote:
>> Normally, genuine Hyper-V doesn't expose architectural invariant TSC
>> (CPUID.80000007H:EDX[8]) to its guests by default. A special PV MSR
>> (HV_X64_MSR_TSC_INVARIANT_CONTROL, 0x40000118) and corresponding CPUID
>> feature bit (CPUID.0x40000003.EAX[15]) were introduced. When bit 0 of the
>> PV MSR is set, invariant TSC bit starts to show up in CPUID. When the
>> feature is exposed to Hyper-V guests, reenlightenment becomes unneeded.
>>=20
>> Add the feature to KVM. Keep CPUID output intact when the feature
>> wasn't exposed to L1 and implement the required logic for hiding
>> invariant TSC when the feature was exposed and invariant TSC control
>> MSR wasn't written to. Copy genuine Hyper-V behavior and forbid to
>> disable the feature once it was enabled.
>>=20
>> For the reference, for linux guests, support for the feature was added
>> in commit dce7cd62754b ("x86/hyperv: Allow guests to enable InvariantTSC=
").
>>=20
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> ---
>> =C2=A0arch/x86/include/asm/kvm_host.h |=C2=A0 1 +
>> =C2=A0arch/x86/kvm/cpuid.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 7 +++++++
>> =C2=A0arch/x86/kvm/hyperv.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 | 19 +++++++++++++++++++
>> =C2=A0arch/x86/kvm/hyperv.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 | 15 +++++++++++++++
>> =C2=A0arch/x86/kvm/x86.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 4 +++-
>> =C2=A05 files changed, 45 insertions(+), 1 deletion(-)
>>=20
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_=
host.h
>> index de5a149d0971..88553f0b524c 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -1022,6 +1022,7 @@ struct kvm_hv {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0u64 hv_reenlightenment_c=
ontrol;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0u64 hv_tsc_emulation_con=
trol;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0u64 hv_tsc_emulation_sta=
tus;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0u64 hv_invtsc;
>> =C2=A0
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/* How many vCPUs have V=
P index !=3D vCPU index */
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0atomic_t num_mismatched_=
vp_indexes;
>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>> index d47222ab8e6e..788df2eb1ec4 100644
>> --- a/arch/x86/kvm/cpuid.c
>> +++ b/arch/x86/kvm/cpuid.c
>> @@ -1404,6 +1404,13 @@ bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u=
32 *ebx,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 (data & TSX_CTRL_CPUID_CLEAR))
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0*ebx &=3D ~(F(RTM) | F(HLE));
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0}
>
> Tiny nitpick: Maybe add a bit longer comment about this thing, like that =
guest needs to opt-in
> to see invtsc when it has the HV feature exposed to it,=C2=A0
> I don't have a strong preference about this though.
>
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0/*
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 * Filter out invariant TSC (CPUID.80000007H:EDX[8]) f=
or Hyper-V
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 * guests if needed.
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 */
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0if (function =3D=3D 0x80000007 && kvm_hv_invtsc_filter=
ed(vcpu))
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0*edx &=
=3D ~(1 << 8);
>
>> +
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0} else {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0*eax =3D *ebx =3D *ecx =3D *edx =3D 0;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0/*
>> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
>> index e2e95a6fccfd..0d8e6526a839 100644
>> --- a/arch/x86/kvm/hyperv.c
>> +++ b/arch/x86/kvm/hyperv.c
>> @@ -991,6 +991,7 @@ static bool kvm_hv_msr_partition_wide(u32 msr)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0case HV_X64_MSR_REENLIGH=
TENMENT_CONTROL:
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0case HV_X64_MSR_TSC_EMUL=
ATION_CONTROL:
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0case HV_X64_MSR_TSC_EMUL=
ATION_STATUS:
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0case HV_X64_MSR_TSC_INVARIANT=
_CONTROL:
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0case HV_X64_MSR_SYNDBG_O=
PTIONS:
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0case HV_X64_MSR_SYNDBG_C=
ONTROL ... HV_X64_MSR_SYNDBG_PENDING_BUFFER:
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0r =3D true;
>> @@ -1275,6 +1276,9 @@ static bool hv_check_msr_access(struct kvm_vcpu_hv=
 *hv_vcpu, u32 msr)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0case HV_X64_MSR_TSC_EMUL=
ATION_STATUS:
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0return hv_vcpu->cpuid_cache.features_eax &
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0HV_=
ACCESS_REENLIGHTENMENT;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0case HV_X64_MSR_TSC_INVARIANT=
_CONTROL:
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0return hv_vcpu->cpuid_cache.features_eax &
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0HV_ACC=
ESS_TSC_INVARIANT;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0case HV_X64_MSR_CRASH_P0=
 ... HV_X64_MSR_CRASH_P4:
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0case HV_X64_MSR_CRASH_CT=
L:
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0return hv_vcpu->cpuid_cache.features_edx &
>> @@ -1402,6 +1406,17 @@ static int kvm_hv_set_msr_pw(struct kvm_vcpu *vcp=
u, u32 msr, u64 data,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0if (!host)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ret=
urn 1;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0break;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0case HV_X64_MSR_TSC_INVARIANT=
_CONTROL:
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0/* Only bit 0 is supported */
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0if (data & ~BIT_ULL(0))
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return=
 1;
>> +
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0/* The feature can't be disabled from the guest */
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0if (!host && hv->hv_invtsc && !data)
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return=
 1;
>
> The unit test in patch 3 claims, that this msr should #GP when 'invtsc'
> aka bit 8 of edx of leaf 0x80000007 is not enabled by the hypervisor
> in the guest cpuid.
>

No, we don't GP when architectural InvTsc is not there....

> Yet, looking at the code I think that this msr read/write access only dep=
ends on
> the 'new' cpuid bit, aka the HV_ACCESS_TSC_INVARIANT, thus this msr will =
'work'
> but do nothing if 'invtsc' is not exposed (it will then not turn it on).

... as this PV feature just enabled and disables filtering. If
architectural InvTsc is not there then filtering just changes
nothing. VMM is supposed to not enable this without InvTsc itself as
it's kind of pointless.

>
>
>
>> +
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0hv->hv_invtsc =3D data;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0break;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0case HV_X64_MSR_SYNDBG_O=
PTIONS:
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0case HV_X64_MSR_SYNDBG_C=
ONTROL ... HV_X64_MSR_SYNDBG_PENDING_BUFFER:
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0return syndbg_set_msr(vcpu, msr, data, host);
>> @@ -1577,6 +1592,9 @@ static int kvm_hv_get_msr_pw(struct kvm_vcpu *vcpu=
, u32 msr, u64 *pdata,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0case HV_X64_MSR_TSC_EMUL=
ATION_STATUS:
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0data =3D hv->hv_tsc_emulation_status;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0break;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0case HV_X64_MSR_TSC_INVARIANT=
_CONTROL:
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0data =3D hv->hv_invtsc;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0break;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0case HV_X64_MSR_SYNDBG_O=
PTIONS:
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0case HV_X64_MSR_SYNDBG_C=
ONTROL ... HV_X64_MSR_SYNDBG_PENDING_BUFFER:
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0return syndbg_get_msr(vcpu, msr, pdata, host);
>> @@ -2497,6 +2515,7 @@ int kvm_get_hv_cpuid(struct kvm_vcpu *vcpu, struct=
 kvm_cpuid2 *cpuid,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ent=
->eax |=3D HV_MSR_REFERENCE_TSC_AVAILABLE;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ent=
->eax |=3D HV_ACCESS_FREQUENCY_MSRS;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ent=
->eax |=3D HV_ACCESS_REENLIGHTENMENT;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ent->e=
ax |=3D HV_ACCESS_TSC_INVARIANT;
>> =C2=A0
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ent=
->ebx |=3D HV_POST_MESSAGES;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ent=
->ebx |=3D HV_SIGNAL_EVENTS;
>> diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
>> index da2737f2a956..1a6316ab55eb 100644
>> --- a/arch/x86/kvm/hyperv.h
>> +++ b/arch/x86/kvm/hyperv.h
>> @@ -133,6 +133,21 @@ static inline bool kvm_hv_has_stimer_pending(struct=
 kvm_vcpu *vcpu)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 HV_SYNIC_STIMER_COUNT);
>> =C2=A0}
>> =C2=A0
>> +/*
>> + * With HV_ACCESS_TSC_INVARIANT feature, invariant TSC (CPUID.80000007H=
:EDX[8])
>> + * is only observed after HV_X64_MSR_TSC_INVARIANT_CONTROL was written =
to.
>> + */
>> +static inline bool kvm_hv_invtsc_filtered(struct kvm_vcpu *vcpu)
>> +{
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct kvm_vcpu_hv *hv_vcpu =
=3D to_hv_vcpu(vcpu);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct kvm_hv *hv =3D to_kvm_=
hv(vcpu->kvm);
>> +
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (hv_vcpu && hv_vcpu->cpuid=
_cache.features_eax & HV_ACCESS_TSC_INVARIANT)
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0return !hv->hv_invtsc;
>> +
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return false;
>> +}
>> +
>> =C2=A0void kvm_hv_process_stimers(struct kvm_vcpu *vcpu);
>> =C2=A0
>> =C2=A0void kvm_hv_setup_tsc_page(struct kvm *kvm,
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 567d13405445..322e0a544823 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -1466,7 +1466,7 @@ static const u32 emulated_msrs_all[] =3D {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0HV_X64_MSR_STIMER0_CONFI=
G,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0HV_X64_MSR_VP_ASSIST_PAG=
E,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0HV_X64_MSR_REENLIGHTENME=
NT_CONTROL, HV_X64_MSR_TSC_EMULATION_CONTROL,
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0HV_X64_MSR_TSC_EMULATION_STAT=
US,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0HV_X64_MSR_TSC_EMULATION_STAT=
US, HV_X64_MSR_TSC_INVARIANT_CONTROL,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0HV_X64_MSR_SYNDBG_OPTION=
S,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0HV_X64_MSR_SYNDBG_CONTRO=
L, HV_X64_MSR_SYNDBG_STATUS,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0HV_X64_MSR_SYNDBG_SEND_B=
UFFER, HV_X64_MSR_SYNDBG_RECV_BUFFER,
>> @@ -3769,6 +3769,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, stru=
ct msr_data *msr_info)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0case HV_X64_MSR_REENLIGH=
TENMENT_CONTROL:
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0case HV_X64_MSR_TSC_EMUL=
ATION_CONTROL:
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0case HV_X64_MSR_TSC_EMUL=
ATION_STATUS:
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0case HV_X64_MSR_TSC_INVARIANT=
_CONTROL:
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0return kvm_hv_set_msr_common(vcpu, msr, data,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 msr_info->host_initiated);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0case MSR_IA32_BBL_CR_CTL=
3:
>> @@ -4139,6 +4140,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, stru=
ct msr_data *msr_info)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0case HV_X64_MSR_REENLIGH=
TENMENT_CONTROL:
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0case HV_X64_MSR_TSC_EMUL=
ATION_CONTROL:
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0case HV_X64_MSR_TSC_EMUL=
ATION_STATUS:
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0case HV_X64_MSR_TSC_INVARIANT=
_CONTROL:
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0return kvm_hv_get_msr_common(vcpu,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 msr_info->index, &msr_info->data,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 msr_info->host_initiated);
>
>
> Beware that this new msr also will need to be migrated by qemu,=C2=A0
> when the feature is added to qemu -
> I had my own share of fun with AMD's TSC ratio msr when I implemented it
> (had to fix it twice in qemu :( ...)

Yes, we do this for a numbet of Hyper-V MSRs already
(e.g. reenlightnment MSRs).

--=20
Vitaly

