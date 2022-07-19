Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8BDB57A032
	for <lists+kvm@lfdr.de>; Tue, 19 Jul 2022 15:57:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232214AbiGSN47 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 09:56:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237691AbiGSN4m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 09:56:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AAE02863FA
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 06:08:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658236070;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z97Q++kaRsbHjLNBJx5eb9ljkY//zciSeUOYhhgbfqc=;
        b=SyDWbG16UD+sG7TTd1YVFuD2PGKedKAnxRj/wrW7wxTsIq5BwhESXg12hoC2q1648sHoCg
        UZJPAhfRsHFQNf7APnI6LWhV8X2pe5haaMOjUgA7/81h7W4/oBy4YVmNUBMdzIueOOltqT
        tQRDcUfoISXWIJ3QrRh0BwA65HGZvtU=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-271-hYCXUqQgPYqwqqLMLqs0bg-1; Tue, 19 Jul 2022 09:07:48 -0400
X-MC-Unique: hYCXUqQgPYqwqqLMLqs0bg-1
Received: by mail-ej1-f70.google.com with SMTP id hb41-20020a170907162900b0072f044ca263so1889355ejc.15
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 06:07:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Z97Q++kaRsbHjLNBJx5eb9ljkY//zciSeUOYhhgbfqc=;
        b=wlCXMm2XXJYBFK/IJ2c4HPMj5gk55qubhXlCLNpyWSgN8zceXvV6/pSE6mKuZdbKlJ
         wpo4XKB7+VC1zTk4fiPrNF16OIqEJnVyUVQMoHTrz1bBtC/iqp0/qTQftIpOMccvZOqH
         42C7XnoXH/K1y4zoerjLqbI5Ae3OpI4IaEhkASO2LNBpxQqainz9MqDBxOHFinBQhAoc
         GfZZKvUlt7PpQI9tBt5kfYjLf/9GOI9kJdbrr/3y0BV4H+WEMKose0DYYWTNst62SyNE
         ABgTZPomjmUsbR5kM+YrgT76oM0jgwITcTH7cp9AHTQw86bbBp5j+TcC3ShR1p9D8pWb
         6Y/g==
X-Gm-Message-State: AJIora88C3lLH8DqAF4ckfbBHaIGF7PUQAtwdtl26CwR667r2M9dj/jz
        LjA13ACpExRTwH7opCPR+vr/kCagw896w6ODdskgpKGCqmFGx0jM66Y8Dgad2vvVWNb7YRu+Qnf
        ZPJKp/Vg5LPwd
X-Received: by 2002:a17:907:a052:b0:72b:1d92:2aaf with SMTP id gz18-20020a170907a05200b0072b1d922aafmr31030397ejc.197.1658236067469;
        Tue, 19 Jul 2022 06:07:47 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1u4bRTo9FudCZwnFs2bagJhSPaSV4i16G8eV/Ij+Fb14agX9CsIU3a7besYY/y6hucZDiGSZQ==
X-Received: by 2002:a17:907:a052:b0:72b:1d92:2aaf with SMTP id gz18-20020a170907a05200b0072b1d922aafmr31030380ejc.197.1658236067249;
        Tue, 19 Jul 2022 06:07:47 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id fg14-20020a056402548e00b0043a45dc7158sm10410243edb.72.2022.07.19.06.07.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Jul 2022 06:07:46 -0700 (PDT)
Message-ID: <78ba738c-cdf4-350f-119f-298081f215d6@redhat.com>
Date:   Tue, 19 Jul 2022 15:07:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] KVM: nSVM: Pull CS.Base from actual VMCB12 for soft
 int/ex re-injection
Content-Language: en-US
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <4caa0f67589ae3c22c311ee0e6139496902f2edc.1658159083.git.maciej.szmigiero@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <4caa0f67589ae3c22c311ee0e6139496902f2edc.1658159083.git.maciej.szmigiero@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/18/22 17:47, Maciej S. Szmigiero wrote:
> From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
> 
> enter_svm_guest_mode() first calls nested_vmcb02_prepare_control() to copy
> control fields from VMCB12 to the current VMCB, then
> nested_vmcb02_prepare_save() to perform a similar copy of the save area.
> 
> This means that nested_vmcb02_prepare_control() still runs with the
> previous save area values in the current VMCB so it shouldn't take the L2
> guest CS.Base from this area.
> 
> Explicitly pull CS.Base from the actual VMCB12 instead in
> enter_svm_guest_mode().
> 
> Granted, having a non-zero CS.Base is a very rare thing (and even
> impossible in 64-bit mode), having it change between nested VMRUNs is
> probably even rarer, but if it happens it would create a really subtle bug
> so it's better to fix it upfront.
> 
> Fixes: 6ef88d6e36c2 ("KVM: SVM: Re-inject INT3/INTO instead of retrying the instruction")
> Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
> ---
>   arch/x86/kvm/svm/nested.c | 9 +++++----
>   1 file changed, 5 insertions(+), 4 deletions(-)

Queued, thanks.

Paolo

> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index adf4120b05d90..23252ab821941 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -639,7 +639,8 @@ static bool is_evtinj_nmi(u32 evtinj)
>   }
>   
>   static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
> -					  unsigned long vmcb12_rip)
> +					  unsigned long vmcb12_rip,
> +					  unsigned long vmcb12_csbase)
>   {
>   	u32 int_ctl_vmcb01_bits = V_INTR_MASKING_MASK;
>   	u32 int_ctl_vmcb12_bits = V_TPR_MASK | V_IRQ_INJECTION_BITS_MASK;
> @@ -711,7 +712,7 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
>   	svm->nmi_l1_to_l2 = is_evtinj_nmi(vmcb02->control.event_inj);
>   	if (is_evtinj_soft(vmcb02->control.event_inj)) {
>   		svm->soft_int_injected = true;
> -		svm->soft_int_csbase = svm->vmcb->save.cs.base;
> +		svm->soft_int_csbase = vmcb12_csbase;
>   		svm->soft_int_old_rip = vmcb12_rip;
>   		if (svm->nrips_enabled)
>   			svm->soft_int_next_rip = svm->nested.ctl.next_rip;
> @@ -800,7 +801,7 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa,
>   	nested_svm_copy_common_state(svm->vmcb01.ptr, svm->nested.vmcb02.ptr);
>   
>   	svm_switch_vmcb(svm, &svm->nested.vmcb02);
> -	nested_vmcb02_prepare_control(svm, vmcb12->save.rip);
> +	nested_vmcb02_prepare_control(svm, vmcb12->save.rip, vmcb12->save.cs.base);
>   	nested_vmcb02_prepare_save(svm, vmcb12);
>   
>   	ret = nested_svm_load_cr3(&svm->vcpu, svm->nested.save.cr3,
> @@ -1663,7 +1664,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
>   	nested_copy_vmcb_control_to_cache(svm, ctl);
>   
>   	svm_switch_vmcb(svm, &svm->nested.vmcb02);
> -	nested_vmcb02_prepare_control(svm, svm->vmcb->save.rip);
> +	nested_vmcb02_prepare_control(svm, svm->vmcb->save.rip, svm->vmcb->save.cs.base);
>   
>   	/*
>   	 * While the nested guest CR3 is already checked and set by
> 

