Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E6B653FFAD
	for <lists+kvm@lfdr.de>; Tue,  7 Jun 2022 15:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244412AbiFGNHc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 09:07:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239390AbiFGNHX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 09:07:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E3B15E08F
        for <kvm@vger.kernel.org>; Tue,  7 Jun 2022 06:07:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654607241;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dT4dXwV/JhpOmCLS9PchFBis6qJXMvk6Uxx+4D1f3pE=;
        b=aZ1LONUQYQ5jGFQKNV2DCgZzoBPyW1tQGqjM9fO1hbIrJN/Pird+BGNaXdawp4JFlssfjF
        FQ+k2972ruiDmLrVQ+PcaDpXUq/96aV3VEJZ9nKBv10ImMOGfPCu208vsvL7gPr2j79ghD
        sFKueL/b2IrPl0Mdxj0uFFHrK7tOcp0=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-591--u4JyluUOeCVsd6_IQZKnw-1; Tue, 07 Jun 2022 09:07:19 -0400
X-MC-Unique: -u4JyluUOeCVsd6_IQZKnw-1
Received: by mail-qv1-f69.google.com with SMTP id fw9-20020a056214238900b0043522aa5b81so10800535qvb.21
        for <kvm@vger.kernel.org>; Tue, 07 Jun 2022 06:07:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=dT4dXwV/JhpOmCLS9PchFBis6qJXMvk6Uxx+4D1f3pE=;
        b=dhMCC4Nx/d+tMFnU7qO3VDJXXKo4fCBInB6BXiwq/W4Czqmm7FRVKCDIOI8l/o4RH/
         vI5wwzkz+EwlhsBFFma8CNi9pvBK3gBCYFyvRHCAaE1KTn9fMSNuVT4Shx7PBPt9bV1H
         uFd5l+oTnzQjT8rQey3YBPpm49pvzCrR7Mf+0E9I/3cFtn2yERs6dDanAU0oAJBTtAjB
         uomtg2Z9Y/bFYDadScpedZy80tD+2stsBhAZUxaXKqNzUm8XcNFPh1enpmM0eaESVvJO
         4IbrZ6EWHiEZ/+5SCqeTOKi9nEcLoKsYONWC/nkjEaG5/O84leDG4FcK5qibu6fQ+HEG
         5RSg==
X-Gm-Message-State: AOAM531TTuRst0merk+8eXoHbGCNKT0zzhI3la1Epz1fkTw/b0DaEAxW
        NexDGXUCZKrbADN6DGIqJWrM1/91rtOq3KvObem85dtljcUJqcXs46nRimVWvBOXm8tuDQajE8f
        hJNGgYN9jYGPE
X-Received: by 2002:a05:622a:64b:b0:304:c896:3473 with SMTP id a11-20020a05622a064b00b00304c8963473mr22554386qtb.457.1654607237843;
        Tue, 07 Jun 2022 06:07:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwtO8Y0TPdwX1KmRcPW5zSOt9b4uoeWht2wLpW7fuOkuSrr5u+VNkTlvcweX3Vfb0sSftLLVA==
X-Received: by 2002:a05:622a:64b:b0:304:c896:3473 with SMTP id a11-20020a05622a064b00b00304c8963473mr22554317qtb.457.1654607237337;
        Tue, 07 Jun 2022 06:07:17 -0700 (PDT)
Received: from [10.35.4.238] (bzq-82-81-161-50.red.bezeqint.net. [82.81.161.50])
        by smtp.gmail.com with ESMTPSA id v10-20020a05620a440a00b0069fc13ce217sm1260715qkp.72.2022.06.07.06.07.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jun 2022 06:07:16 -0700 (PDT)
Message-ID: <d3f2da59b5afd300531ae428174c1f91d731e655.camel@redhat.com>
Subject: Re: [PATCH 3/7] KVM: SVM: Add VNMI support in get/set_nmi_mask
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Santosh Shukla <santosh.shukla@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 07 Jun 2022 16:07:13 +0300
In-Reply-To: <20220602142620.3196-4-santosh.shukla@amd.com>
References: <20220602142620.3196-1-santosh.shukla@amd.com>
         <20220602142620.3196-4-santosh.shukla@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-2.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-06-02 at 19:56 +0530, Santosh Shukla wrote:
> VMCB intr_ctrl bit12 (V_NMI_MASK) is set by the processor when handling
> NMI in guest and is cleared after the NMI is handled. Treat V_NMI_MASK as
> read-only in the hypervisor and do not populate set accessors.
> 
> Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
> ---
>  arch/x86/kvm/svm/svm.c | 20 +++++++++++++++++++-
>  1 file changed, 19 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 860f28c668bd..d67a54517d95 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -323,6 +323,16 @@ static int is_external_interrupt(u32 info)
>         return info == (SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_INTR);
>  }
>  
> +static bool is_vnmi_enabled(struct vmcb *vmcb)
> +{
> +       return vnmi && (vmcb->control.int_ctl & V_NMI_ENABLE);
> +}

Following Paolo's suggestion I recently removed vgif_enabled(),
based on the logic that vgif_enabled == vgif, because
we always enable vGIF for L1 as long as 'vgif' module param is set,
which is set unless either hardware or user cleared it.

Note that here vmcb is the current vmcb, which can be vmcb02,
and it might be wrong

> +
> +static bool is_vnmi_mask_set(struct vmcb *vmcb)
> +{
> +       return !!(vmcb->control.int_ctl & V_NMI_MASK);
> +}
> +
>  static u32 svm_get_interrupt_shadow(struct kvm_vcpu *vcpu)
>  {
>         struct vcpu_svm *svm = to_svm(vcpu);
> @@ -3502,13 +3512,21 @@ static int svm_nmi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
>  
>  static bool svm_get_nmi_mask(struct kvm_vcpu *vcpu)
>  {
> -       return !!(vcpu->arch.hflags & HF_NMI_MASK);
> +       struct vcpu_svm *svm = to_svm(vcpu);
> +
> +       if (is_vnmi_enabled(svm->vmcb))
> +               return is_vnmi_mask_set(svm->vmcb);
> +       else
> +               return !!(vcpu->arch.hflags & HF_NMI_MASK);
>  }
>  
>  static void svm_set_nmi_mask(struct kvm_vcpu *vcpu, bool masked)
>  {
>         struct vcpu_svm *svm = to_svm(vcpu);
>  
> +       if (is_vnmi_enabled(svm->vmcb))
> +               return;

What if the KVM wants to mask NMI, shoudn't we update the 
V_NMI_MASK value in int_ctl instead of doing nothing?

Best regards,
	Maxim Levitsky


> +
>         if (masked) {
>                 vcpu->arch.hflags |= HF_NMI_MASK;
>                 if (!sev_es_guest(vcpu->kvm))


