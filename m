Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A11E457198F
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 14:14:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230328AbiGLMOR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 08:14:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232463AbiGLMON (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 08:14:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2E6514504D
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 05:14:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657628051;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WAxGI00yNn9GNFeh9dlU/4akmeOA8R+tofyDowtvI5A=;
        b=dbNwqZpZrFlT1bP01S+mzLK5MbEs5D9UP64vjQaPVXzd8+3Fbn4w/dNSyN7NWavMWG2equ
        t8r2VRhynq0Nq/B+XaRfTRrdXNC8T71MMmHC6vkmqwsDQxl+a+g16fkPXriCchaPlpz46e
        4AA/OYb8cphUOzw9aWMOhi6R5X1KGWI=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-437-xXTfh68EOp6INtSKKyEfEg-1; Tue, 12 Jul 2022 08:14:10 -0400
X-MC-Unique: xXTfh68EOp6INtSKKyEfEg-1
Received: by mail-wm1-f70.google.com with SMTP id v67-20020a1cac46000000b003a2be9fa09cso4063024wme.3
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 05:14:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=WAxGI00yNn9GNFeh9dlU/4akmeOA8R+tofyDowtvI5A=;
        b=1v3sITFR4/LUXqSqyQZBfbbeJ8UHPH5LDHOzgHpVFpWk28Pys+EchKG+tXpw/MIUyn
         MWl3la8S+zofsjQeqFNosM9DEOTvFOeP5TAfkUurKYXDSI9jekiFmpq23KkWKGAnlNjr
         6qEnVt4CN1sYAvdoHD6QxQe8vf45harHTFQfOSQbfwsB5RK5s1NMJtXWg4kuJRW86ZNE
         U9WteV9Eub4rk2KPAIbFrGZoUlqaPJ2GIf6h7VTvqDtprtMejYUC/gWy3q2/bNpYe9rY
         pAQQDMZvrzdQ8KV25evxZorpsqqPy10yeoQhMlc37QGyOYjjKNi/Y50KRmgtAZjx9ygS
         5Wkw==
X-Gm-Message-State: AJIora+1e7UVT4DIdX4AfQiRCEBDi9TGAIBC59/cBCwWE+2Eidq0MW/A
        cwqwKfouUPa2+VEMrRMNJMCt96h/9Bj9h6pl6Bn9ZsLRbcYfe6Rr6niK/iaCSBGqgsHsjOtmKZg
        28De7/UWa/UAm
X-Received: by 2002:a05:600c:a02:b0:39c:97cc:82e3 with SMTP id z2-20020a05600c0a0200b0039c97cc82e3mr3631778wmp.97.1657628049125;
        Tue, 12 Jul 2022 05:14:09 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vJr7AKZGM9mihE37deXYF43Gq0ysHz0r6eaHk1Fd0fSvJKJonKBW6zwaLCeWi3o7tRipBdtg==
X-Received: by 2002:a05:600c:a02:b0:39c:97cc:82e3 with SMTP id z2-20020a05600c0a0200b0039c97cc82e3mr3631744wmp.97.1657628048818;
        Tue, 12 Jul 2022 05:14:08 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id bg32-20020a05600c3ca000b003a04d19dab3sm2256602wmb.3.2022.07.12.05.14.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 05:14:07 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v3 11/25] KVM: VMX: Get rid of eVMCS specific VMX
 controls sanitization
In-Reply-To: <f1d030d7db4aaf3075fe625799b99ae335fc9f60.camel@redhat.com>
References: <20220708144223.610080-1-vkuznets@redhat.com>
 <20220708144223.610080-12-vkuznets@redhat.com>
 <f1d030d7db4aaf3075fe625799b99ae335fc9f60.camel@redhat.com>
Date:   Tue, 12 Jul 2022 14:14:06 +0200
Message-ID: <877d4iplyp.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Maxim Levitsky <mlevitsk@redhat.com> writes:

> On Fri, 2022-07-08 at 16:42 +0200, Vitaly Kuznetsov wrote:
>> With the updated eVMCSv1 definition, there's no known 'problematic'
>> controls which are exposed in VMX control MSRs but are not present in
>> eVMCSv1. Get rid of VMX control MSRs filtering for KVM on Hyper-V.
>
> If I understand correctly we are taking about running KVM as a nested gue=
st of Hyper-V here:
>
> Don't we need to check the new CPUID bit and only then use the new fields=
 of eVMCS,
> aka check that the 'cpu' supports the updated eVMCS version?
>

I've checked various Hyper-V versions available around and it seems
there's no need for that: these new features are exposed in VMX control
MSRs only when the updated eVMCS is supported.

We can, in theory, preserve the filtering for non-updated eVMCS verison
but I'd vote for putting a WARN_ON() or something around: we can
eventually get rid of it in case we don't get any reports.

> Best regards,
> 	Maxim Levitsky
>
>
>
>>=20
>> Note: VMX control MSRs filtering for Hyper-V on KVM
>> (nested_evmcs_filter_control_msr()) stays as even the updated eVMCSv1
>> definition doesn't have all the features implemented by KVM and some
>> fields are still missing. Moreover, nested_evmcs_filter_control_msr()
>> has to support the original eVMCSv1 version when VMM wishes so.
>>=20
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> ---
>> =C2=A0arch/x86/kvm/vmx/evmcs.c | 13 -------------
>> =C2=A0arch/x86/kvm/vmx/evmcs.h |=C2=A0 1 -
>> =C2=A0arch/x86/kvm/vmx/vmx.c=C2=A0=C2=A0 |=C2=A0 5 -----
>> =C2=A03 files changed, 19 deletions(-)
>>=20
>> diff --git a/arch/x86/kvm/vmx/evmcs.c b/arch/x86/kvm/vmx/evmcs.c
>> index 52a53debd806..b5cfbf7d487b 100644
>> --- a/arch/x86/kvm/vmx/evmcs.c
>> +++ b/arch/x86/kvm/vmx/evmcs.c
>> @@ -320,19 +320,6 @@ const struct evmcs_field vmcs_field_to_evmcs_1[] =
=3D {
>> =C2=A0};
>> =C2=A0const unsigned int nr_evmcs_1_fields =3D ARRAY_SIZE(vmcs_field_to_=
evmcs_1);
>> =C2=A0
>> -#if IS_ENABLED(CONFIG_HYPERV)
>> -__init void evmcs_sanitize_exec_ctrls(struct vmcs_config *vmcs_conf)
>> -{
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0vmcs_conf->cpu_based_exec_ctr=
l &=3D ~EVMCS1_UNSUPPORTED_EXEC_CTRL;
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0vmcs_conf->pin_based_exec_ctr=
l &=3D ~EVMCS1_UNSUPPORTED_PINCTRL;
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0vmcs_conf->cpu_based_2nd_exec=
_ctrl &=3D ~EVMCS1_UNSUPPORTED_2NDEXEC;
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0vmcs_conf->cpu_based_3rd_exec=
_ctrl =3D 0;
>> -
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0vmcs_conf->vmexit_ctrl &=3D ~=
EVMCS1_UNSUPPORTED_VMEXIT_CTRL;
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0vmcs_conf->vmentry_ctrl &=3D =
~EVMCS1_UNSUPPORTED_VMENTRY_CTRL;
>> -}
>> -#endif
>> -
>> =C2=A0bool nested_enlightened_vmentry(struct kvm_vcpu *vcpu, u64 *evmcs_=
gpa)
>> =C2=A0{
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct hv_vp_assist_page=
 assist_page;
>> diff --git a/arch/x86/kvm/vmx/evmcs.h b/arch/x86/kvm/vmx/evmcs.h
>> index 4b809c79ae63..0feac101cce4 100644
>> --- a/arch/x86/kvm/vmx/evmcs.h
>> +++ b/arch/x86/kvm/vmx/evmcs.h
>> @@ -203,7 +203,6 @@ static inline void evmcs_load(u64 phys_addr)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0vp_ap->enlighten_vmentry=
 =3D 1;
>> =C2=A0}
>> =C2=A0
>> -__init void evmcs_sanitize_exec_ctrls(struct vmcs_config *vmcs_conf);
>> =C2=A0#else /* !IS_ENABLED(CONFIG_HYPERV) */
>> =C2=A0static __always_inline void evmcs_write64(unsigned long field, u64=
 value) {}
>> =C2=A0static inline void evmcs_write32(unsigned long field, u32 value) {}
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index b4915d841357..dd905ad72637 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -2689,11 +2689,6 @@ static __init int setup_vmcs_config(struct vmcs_c=
onfig *vmcs_conf,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0vmcs_conf->vmexit_ctrl=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D _vmexit_control;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0vmcs_conf->vmentry_ctrl=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D _vmentry_control;
>> =C2=A0
>> -#if IS_ENABLED(CONFIG_HYPERV)
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (enlightened_vmcs)
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0evmcs_sanitize_exec_ctrls(vmcs_conf);
>> -#endif
>> -
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return 0;
>> =C2=A0}
>> =C2=A0
>
>

--=20
Vitaly

