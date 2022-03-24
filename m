Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 504E94E6869
	for <lists+kvm@lfdr.de>; Thu, 24 Mar 2022 19:12:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352527AbiCXSOJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Mar 2022 14:14:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352514AbiCXSOG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Mar 2022 14:14:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9DE2FB7141
        for <kvm@vger.kernel.org>; Thu, 24 Mar 2022 11:12:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648145551;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4NVnAUSl0gdBiXg0XzzRFvlJNA1grykJ2S0JEY11Nbk=;
        b=R2GaI+CKH6fUI14NsfMFoUOb3qTZf2TZRTuR519B79HPXh+ugN0kCy2HOb78Cay1bHza3m
        H/QEmhtMzKhJDkzi9y3I650T7GtVd/2RFNkrwRE1Oelv8z58NPkxc8T1yCWNsp3ejJiVsV
        c3R8qKU1s8jx8UbfkCRrXjw3pY268UI=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-351-cOOwSDjqPGGgiPoVuFZDBA-1; Thu, 24 Mar 2022 14:12:30 -0400
X-MC-Unique: cOOwSDjqPGGgiPoVuFZDBA-1
Received: by mail-ed1-f70.google.com with SMTP id i22-20020a508716000000b0041908045af3so3473629edb.3
        for <kvm@vger.kernel.org>; Thu, 24 Mar 2022 11:12:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=4NVnAUSl0gdBiXg0XzzRFvlJNA1grykJ2S0JEY11Nbk=;
        b=UxuVkmnGVvwng0IUO63AtntCRrQCAD97quhqyQMUb5AxXywYnjYJVbpccIuzQRtX1e
         lC1LTmA/rhWwaQS85lNLin1wRkhuU/Mz+3Wt/0xfju/n0CJha3XXCx60iwe9/3qpXi/v
         AnOI3xHtkYAnqBPEHoxGursMBv3oUq+iQ6ZciW8+kgUwlDXpIJAuvpjf0fwdupZiaZ08
         Bnr1hqp7mFeATyaPSLHKKnR1QkVBwFW8HK0g1lp8m2AmUDLr2w4Uf35vSQGHi0JA5bMG
         6T4AF7B8oKJHByHUkUgMIAqagm4rWYVBg8G6A4fUk7GlHMIxMy+mLYmGpVcOftt3wU9C
         TvjA==
X-Gm-Message-State: AOAM530zC6vlX4NvFzhLsuKvAWCEXXdf0LAkAXB0GfRqawFKBue1PXa+
        N8gUUn9b12cGwvubQddA6TMWRdKtOwp0naXENO9wGWRElsEGNtrtGPFB2GCYtQEWzA4p3YH8JlQ
        9wMKYg+KLizwJ
X-Received: by 2002:a05:6402:1e90:b0:419:4cdc:8b05 with SMTP id f16-20020a0564021e9000b004194cdc8b05mr8152913edf.211.1648145549303;
        Thu, 24 Mar 2022 11:12:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzl1pOGNmtNKqaqjzB/IEGNfgxI4RN1wwsYQ2aza86ksmyrLbJxeMnAeF1nCnbY+bzdhFqmxg==
X-Received: by 2002:a05:6402:1e90:b0:419:4cdc:8b05 with SMTP id f16-20020a0564021e9000b004194cdc8b05mr8152887edf.211.1648145549048;
        Thu, 24 Mar 2022 11:12:29 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id n9-20020a05640205c900b00418d79d4a61sm1825824edx.97.2022.03.24.11.12.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Mar 2022 11:12:28 -0700 (PDT)
Message-ID: <fa6ea646-6609-af7f-e43c-ecd4cb54e210@redhat.com>
Date:   Thu, 24 Mar 2022 19:12:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 2/8] KVM: x86: SVM: use vmcb01 in avic_init_vmcb and
 init_vmcb
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        Ingo Molnar <mingo@redhat.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
References: <20220322172449.235575-1-mlevitsk@redhat.com>
 <20220322172449.235575-3-mlevitsk@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220322172449.235575-3-mlevitsk@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/22/22 18:24, Maxim Levitsky wrote:
>   
>   void avic_init_vmcb(struct vcpu_svm *svm)
>   {
> -	struct vmcb *vmcb = svm->vmcb;
> +	struct vmcb *vmcb = svm->vmcb01.ptr;
>   	struct kvm_svm *kvm_svm = to_kvm_svm(svm->vcpu.kvm);
>   	phys_addr_t bpa = __sme_set(page_to_phys(svm->avic_backing_page));
>   	phys_addr_t lpa = __sme_set(page_to_phys(kvm_svm->avic_logical_id_table_page));

Let's do this for consistency with e.g. svm_hv_init_vmcb:

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index b39fe614467a..ab202158137d 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -165,9 +165,8 @@ int avic_vm_init(struct kvm *kvm)
  	return err;
  }
  
-void avic_init_vmcb(struct vcpu_svm *svm)
+void avic_init_vmcb(struct vcpu_svm *svm, struct vmcb *vmcb)
  {
-	struct vmcb *vmcb = svm->vmcb01.ptr;
  	struct kvm_svm *kvm_svm = to_kvm_svm(svm->vcpu.kvm);
  	phys_addr_t bpa = __sme_set(page_to_phys(svm->avic_backing_page));
  	phys_addr_t lpa = __sme_set(page_to_phys(kvm_svm->avic_logical_id_table_page));
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index cc02506b7a19..ced8edad0c87 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1123,7 +1123,7 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
  		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SPEC_CTRL, 1, 1);
  
  	if (kvm_vcpu_apicv_active(vcpu))
-		avic_init_vmcb(svm);
+		avic_init_vmcb(svm, vmcb);
  
  	if (vgif) {
  		svm_clr_intercept(svm, INTERCEPT_STGI);
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index d07a5b88ea96..bbac6c24a8b8 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -591,7 +591,7 @@ extern struct kvm_x86_nested_ops svm_nested_ops;
  int avic_ga_log_notifier(u32 ga_tag);
  void avic_vm_destroy(struct kvm *kvm);
  int avic_vm_init(struct kvm *kvm);
-void avic_init_vmcb(struct vcpu_svm *svm);
+void avic_init_vmcb(struct vcpu_svm *svm, struct vmcb *vmcb);
  int avic_incomplete_ipi_interception(struct kvm_vcpu *vcpu);
  int avic_unaccelerated_access_interception(struct kvm_vcpu *vcpu);
  int avic_init_vcpu(struct vcpu_svm *svm);

