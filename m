Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62C807CA850
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 14:46:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233493AbjJPMq1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 08:46:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233480AbjJPMq0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 08:46:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B4ADAB
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 05:45:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697460341;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/bBsNaJ9O8PNaJExTqYeHPJN2khegR4L0yu5ItrKyyA=;
        b=cxil5bPTh2hkV/7LOrX7swJBlinykCyEREXZxevTc4rxCHeMk+jmqat/qQ0LctrjajYUN2
        Hm/WksglZrfX1lfZKy5VRdiqqU+sXxF6nqCL7p8qkxQ4GeU/ZDKtEw62Q3Rp4dbB3kHDmm
        FW25SkTJBNPlfiGhs9cBt2B2bCyZ1tY=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-625-Fq782_A5Or6S7zCAYQaqlQ-1; Mon, 16 Oct 2023 08:45:29 -0400
X-MC-Unique: Fq782_A5Or6S7zCAYQaqlQ-1
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-4195a70269eso51896781cf.3
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 05:45:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697460329; x=1698065129;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/bBsNaJ9O8PNaJExTqYeHPJN2khegR4L0yu5ItrKyyA=;
        b=cT6PwT/17xoQRx1D7gyxk0PumXNUZARSy+vmr/q7+HbuPZYGv5kSIe59xXytSTPTnA
         ijXuW/OTMg+1YAizsQbi/8smY02RgdZAGIBVJyRkKO1ASxmfBCYsWqpmO2edAPTdVFqb
         7s2v10bx6GglTnlnh4jMd2n+pHKYuAdsFYgCnus964hggzU28p0RIRHu9BNU1Lz2U+pf
         fVs9CacKrPyxl5TyB3/jaksLTjkGWr0xqWcZ1LhUrMg/CxcgCjhQiAv+HIH3/mvOFOFO
         eXVLdHs7OokNqC5QnjYBGmktgrDUJht2OqYV/cOPwnuzhr3PRbs1raU7YMPJMVFsyCdN
         hEpA==
X-Gm-Message-State: AOJu0YxsTlYSObGUDdwVPo/tB6k6jw/nh1FkXpFVjFWr7RWQFVh8yIhR
        SgchqEHC1vSwjUOusKVKNYw9LBmf8B0GH4piPDpvzJcW0+7fCOIaV0obmqICBVm7mHSMulasFgr
        HhMkSIK5Ry9nL
X-Received: by 2002:a05:622a:1444:b0:418:b8c:1a0a with SMTP id v4-20020a05622a144400b004180b8c1a0amr39156181qtx.25.1697460329350;
        Mon, 16 Oct 2023 05:45:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEcvhEuiLQg3+7xqK8MpUxkIgUpJIsGGXxtA5CaUuCUSDKLyGL8R6chz4MMi468RPBwxyzJlA==
X-Received: by 2002:a05:622a:1444:b0:418:b8c:1a0a with SMTP id v4-20020a05622a144400b004180b8c1a0amr39156164qtx.25.1697460329076;
        Mon, 16 Oct 2023 05:45:29 -0700 (PDT)
Received: from fedora (g2.ign.cz. [91.219.240.8])
        by smtp.gmail.com with ESMTPSA id jz4-20020a05622a81c400b00417b9f5b883sm3036661qtb.2.2023.10.16.05.45.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Oct 2023 05:45:28 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH RFC 02/11] KVM: x86: hyper-v: Move Hyper-V partition
 assist page out of Hyper-V emulation context
In-Reply-To: <4c2b8ddc3b87818f0d752a91963e3895781902d8.camel@redhat.com>
References: <20231010160300.1136799-1-vkuznets@redhat.com>
 <20231010160300.1136799-3-vkuznets@redhat.com>
 <4c2b8ddc3b87818f0d752a91963e3895781902d8.camel@redhat.com>
Date:   Mon, 16 Oct 2023 14:45:26 +0200
Message-ID: <87mswi91nd.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Maxim Levitsky <mlevitsk@redhat.com> writes:

> =D0=A3 =D0=B2=D1=82, 2023-10-10 =D1=83 18:02 +0200, Vitaly Kuznetsov =D0=
=BF=D0=B8=D1=88=D0=B5:
>> Hyper-V partition assist page is used when KVM runs on top of Hyper-V and
>> is not used for Windows/Hyper-V guests on KVM, this means that 'hv_pa_pg'
>> placement in 'struct kvm_hv' is unfortunate. As a preparation to making
>> Hyper-V emulation optional, move 'hv_pa_pg' to 'struct kvm_arch' and put=
 it
>> under CONFIG_HYPERV.
>
> It took me a while to realize that this parition assist page is indeed so=
mething that L0,
> running above KVM consumes.
> (what a confusing name Microsoft picked...)
>
> As far as I know currently the partition assist page has only=20
> one shared memory variable which allows L1 to be notified of direct TLB f=
lushes that L0 does for L2,=20
> but since KVM doesn't need it, it
> never touches this variable/page,
> but specs still demand that L1 does allocate that page.
>

Yes,

KVM doesn't ask L0 (Hyper-V) to deliver synthetic vmexits but the page
needs to be allocated. I'm not sure whether this is done to follow the
spec ("The partition assist page is a page-size aligned page-size region
of memory that the L1 hypervisor must allocate and zero before direct
flush hypercalls can be used.") or if anyone has ever tried writing '0'
to the corresponding field to see what happens with various Hyper-V
versions but even if it happens to work today, there's no guarantee for
the future.

>
> If you agree, it would be great to add a large comment to the code,
> explaining the above,=20

There' this in vmx.c:

        /*
         * Synthetic VM-Exit is not enabled in current code and so All
         * evmcs in singe VM shares same assist page.
         */

but this can certainly get extended. Moreover, it seems that
hv_enable_l2_tlb_flush() should go vmx_onhyperv.c to make that fact that
it's for KVM-on-Hyper-V 'more obvious'.

> and fact that the partition assist page=20
> is something L1 exposes to L0.
>
> I don't know though where to put the comment=20
> because hv_enable_l2_tlb_flush is duplicated between SVM and VMX.
>
> It might be a good idea to have a helper function to allocate the partiti=
on assist page,
> which will both reduce the code duplication slightly and allow us to
> put this comment there.

OK.

>
>
> Best regards,
> 	Maxim Levitsky
>
>>=20
>> No functional change intended.
>>=20
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> ---
>>  arch/x86/include/asm/kvm_host.h | 2 +-
>>  arch/x86/kvm/svm/svm_onhyperv.c | 2 +-
>>  arch/x86/kvm/vmx/vmx.c          | 2 +-
>>  arch/x86/kvm/x86.c              | 4 +++-
>>  4 files changed, 6 insertions(+), 4 deletions(-)
>>=20
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_=
host.h
>> index e5d4b8a44630..711dc880a9f0 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -1115,7 +1115,6 @@ struct kvm_hv {
>>  	 */
>>  	unsigned int synic_auto_eoi_used;
>>=20=20
>> -	struct hv_partition_assist_pg *hv_pa_pg;
>>  	struct kvm_hv_syndbg hv_syndbg;
>>  };
>>=20=20
>> @@ -1436,6 +1435,7 @@ struct kvm_arch {
>>  #if IS_ENABLED(CONFIG_HYPERV)
>>  	hpa_t	hv_root_tdp;
>>  	spinlock_t hv_root_tdp_lock;
>> +	struct hv_partition_assist_pg *hv_pa_pg;
>>  #endif
>>  	/*
>>  	 * VM-scope maximum vCPU ID. Used to determine the size of structures
>> diff --git a/arch/x86/kvm/svm/svm_onhyperv.c b/arch/x86/kvm/svm/svm_onhy=
perv.c
>> index 7af8422d3382..d19666f9b9ac 100644
>> --- a/arch/x86/kvm/svm/svm_onhyperv.c
>> +++ b/arch/x86/kvm/svm/svm_onhyperv.c
>> @@ -19,7 +19,7 @@ int svm_hv_enable_l2_tlb_flush(struct kvm_vcpu *vcpu)
>>  {
>>  	struct hv_vmcb_enlightenments *hve;
>>  	struct hv_partition_assist_pg **p_hv_pa_pg =3D
>> -			&to_kvm_hv(vcpu->kvm)->hv_pa_pg;
>> +		&vcpu->kvm->arch.hv_pa_pg;
>>=20=20
>>  	if (!*p_hv_pa_pg)
>>  		*p_hv_pa_pg =3D kzalloc(PAGE_SIZE, GFP_KERNEL);
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index 72e3943f3693..b7dc7acf14be 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -524,7 +524,7 @@ static int hv_enable_l2_tlb_flush(struct kvm_vcpu *v=
cpu)
>>  {
>>  	struct hv_enlightened_vmcs *evmcs;
>>  	struct hv_partition_assist_pg **p_hv_pa_pg =3D
>> -			&to_kvm_hv(vcpu->kvm)->hv_pa_pg;
>> +		&vcpu->kvm->arch.hv_pa_pg;
>>  	/*
>>  	 * Synthetic VM-Exit is not enabled in current code and so All
>>  	 * evmcs in singe VM shares same assist page.
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 9f18b06bbda6..e273ce8e0b3f 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -12291,7 +12291,9 @@ void kvm_arch_sched_in(struct kvm_vcpu *vcpu, in=
t cpu)
>>=20=20
>>  void kvm_arch_free_vm(struct kvm *kvm)
>>  {
>> -	kfree(to_kvm_hv(kvm)->hv_pa_pg);
>> +#if IS_ENABLED(CONFIG_HYPERV)
>> +	kfree(kvm->arch.hv_pa_pg);
>> +#endif
>>  	__kvm_arch_free_vm(kvm);
>>  }
>>=20=20
>
>
>
>

--=20
Vitaly

