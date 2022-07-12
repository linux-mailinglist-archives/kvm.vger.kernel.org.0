Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 893CC5719BD
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 14:19:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbiGLMTS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 08:19:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231902AbiGLMTM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 08:19:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E05C513E37
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 05:19:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657628351;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D/fC+rsuewsmYyokkHN4davc+n6pcIuIFkioCEI5EXs=;
        b=JhJSW0CQMGfFfYFc0lWYcSjeAG81CnnzBy1EeNZ5hjPgSRfV2tNMhw9h7HMxgdmll4BRxH
        Sbo9c/fVj0PvRjO288KRxa7+kTM4LOhYSK3eOx29cZ7DNVhCRzD/p3wXEPp+6gDxlPO9E+
        cqlTmi23ClI6JGlaKmv6ymyXMq/GDFA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-625-GO2iXpGIPcufRQTG4r0QQQ-1; Tue, 12 Jul 2022 08:19:09 -0400
X-MC-Unique: GO2iXpGIPcufRQTG4r0QQQ-1
Received: by mail-wm1-f70.google.com with SMTP id 2-20020a1c0202000000b003a2cfab44eeso6642102wmc.6
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 05:19:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=D/fC+rsuewsmYyokkHN4davc+n6pcIuIFkioCEI5EXs=;
        b=lMzpVfkWN2YRcI8Sbc0yxOEvK+fDVzZErweIiTu6nrHH6O9RawcDIHnW+trKZWxt3q
         aB40v+UkcyD1Dnk44yMkfrUQIzYFr8lunBwKexksSywvGLvMBIPzjJun81NFUTSbWTJq
         N+MfhmRASwmM8CBM6sKbIDtZMf29B/GxOnG8F4uI+K2106CjTj0g7I4uiQA34fjAkuSe
         YKBnOFBBkysPRTDX10D0ZLBUNmDf8rovwULUJKp/48GrG470qedCBqpNyXq62pdvFwLp
         eO+lT7Ub01RhUROshD6mSH850NaRpHsxmus+RJl8KoYuitoXGtZhGJ9WItjQibzKpNQf
         LDRw==
X-Gm-Message-State: AJIora9DPgR7R2gf/AnXeZ3fdVwacihLUDjQbQUzostK5IdNomL7D0A9
        jVmkJ5kBsn6aEHTGLN9rDmx5CDMNG8yL2f/4dvVlV0511nGtWBYbc2WsCrbYddvb9y/J966PQws
        XkyZugGTk42My
X-Received: by 2002:a05:600c:3845:b0:3a2:c04d:5ff9 with SMTP id s5-20020a05600c384500b003a2c04d5ff9mr3619769wmr.74.1657628348621;
        Tue, 12 Jul 2022 05:19:08 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tSAiVrHcowqDbe7dPEm4sreDyxs47ZG63PfIWwugXmlHXOLYhohrraQDJqffTNnuGllHv/ag==
X-Received: by 2002:a05:600c:3845:b0:3a2:c04d:5ff9 with SMTP id s5-20020a05600c384500b003a2c04d5ff9mr3619748wmr.74.1657628348428;
        Tue, 12 Jul 2022 05:19:08 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id j5-20020adff545000000b0021d864d4461sm8090767wrp.83.2022.07.12.05.19.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 05:19:07 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v3 03/25] x86/hyperv: Update 'struct
 hv_enlightened_vmcs' definition
In-Reply-To: <6cf5812083ebfa18ba52563527298cb8b91f7fab.camel@redhat.com>
References: <20220708144223.610080-1-vkuznets@redhat.com>
 <20220708144223.610080-4-vkuznets@redhat.com>
 <6cf5812083ebfa18ba52563527298cb8b91f7fab.camel@redhat.com>
Date:   Tue, 12 Jul 2022 14:19:06 +0200
Message-ID: <874jzmplqd.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Maxim Levitsky <mlevitsk@redhat.com> writes:

> On Fri, 2022-07-08 at 16:42 +0200, Vitaly Kuznetsov wrote:
>> Updated Hyper-V Enlightened VMCS specification lists several new
>> fields for the following features:
>>=20
>> - PerfGlobalCtrl
>> - EnclsExitingBitmap
>> - Tsc Scaling
>> - GuestLbrCtl
>> - CET
>> - SSP
>>=20
>> Update the definition. The updated definition is available only when
>> CPUID.0x4000000A.EBX BIT(0) is '1'. Add a define for it as well.
>>=20
>> Note: The latest TLFS is available at
>> https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/tlfs/=
tlfs
>>=20
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> ---
>>  arch/x86/include/asm/hyperv-tlfs.h | 18 ++++++++++++++++--
>>  1 file changed, 16 insertions(+), 2 deletions(-)
>>=20
>> diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/h=
yperv-tlfs.h
>> index 6f0acc45e67a..6f2c3cdacdf4 100644
>> --- a/arch/x86/include/asm/hyperv-tlfs.h
>> +++ b/arch/x86/include/asm/hyperv-tlfs.h
>> @@ -138,6 +138,9 @@
>>  #define HV_X64_NESTED_GUEST_MAPPING_FLUSH		BIT(18)
>>  #define HV_X64_NESTED_MSR_BITMAP			BIT(19)
>>=20=20
>
> Maybe add a comment that this is undocumented + what that cpuid bit does?
>
>> +/* Nested quirks. These are HYPERV_CPUID_NESTED_FEATURES.EBX bits. */
>> +#define HV_X64_NESTED_EVMCS1_2022_UPDATE		BIT(0)
>> +
>>  /*
>>   * This is specific to AMD and specifies that enlightened TLB flush is
>>   * supported. If guest opts in to this feature, ASID invalidations only
>> @@ -559,9 +562,20 @@ struct hv_enlightened_vmcs {
>>  	u64 partition_assist_page;
>>  	u64 padding64_4[4];
>>  	u64 guest_bndcfgs;
>> -	u64 padding64_5[7];
>> +	u64 guest_ia32_perf_global_ctrl;
>> +	u64 guest_ia32_s_cet;
>> +	u64 guest_ssp;
>> +	u64 guest_ia32_int_ssp_table_addr;
>> +	u64 guest_ia32_lbr_ctl;
>> +	u64 padding64_5[2];
>
> This change looks OK
>
>>  	u64 xss_exit_bitmap;
>> -	u64 padding64_6[7];
>> +	u64 host_ia32_perf_global_ctrl;
>> +	u64 encls_exiting_bitmap;
>> +	u64 tsc_multiplier;
>> +	u64 host_ia32_s_cet;
>> +	u64 host_ssp;
>> +	u64 host_ia32_int_ssp_table_addr;
>> +	u64 padding64_6;
>
> I think we have a mistake here:
>
> UINT64 XssExitingBitmap;
> UINT64 EnclsExitingBitmap;
> UINT64 HostPerfGlobalCtrl;
> UINT64 TscMultiplier;
> UINT64 HostSCet;
> UINT64 HostSsp;
> UINT64 HostInterruptSspTableAddr;
> UINT64 Rsvd8;
>
>
> I think you need to swap encls_exiting_bitmap and host_ia32_perf_global_c=
trl
>
> I used=C2=A0https://docs.microsoft.com/en-us/virtualization/hyper-v-on-wi=
ndows/tlfs/datatypes/hv_vmx_enlightened_vmcs
> as the reference.=C2=A0

Oh, nice catch, thanks! I have no idea how this mistake crept in. A
conspiracy theory: maybe the online version of TLFS was updated
under our feet? :-)

v4 is coming to rescue.

>
>
> Best regards,
> 	Maxim Levitsky
>
>
>>  } __packed;
>>=20=20
>>  #define HV_VMX_ENLIGHTENED_CLEAN_FIELD_NONE			0
>
>

--=20
Vitaly

