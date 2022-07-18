Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78BAE57830F
	for <lists+kvm@lfdr.de>; Mon, 18 Jul 2022 15:04:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235209AbiGRNEP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jul 2022 09:04:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235185AbiGRNEN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Jul 2022 09:04:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A480DBCB8
        for <kvm@vger.kernel.org>; Mon, 18 Jul 2022 06:04:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658149451;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rCaukIQ4Y9kP6/SvywHkOLwsqGQwYiQZVmc0+Rt1khE=;
        b=LPswGsLs5qzSuqTcrmPl0jTBqrB7GtB933sliWxxff9ceZSEF4sWAezT5q4Ktlg4BTHE7L
        +geXulc16E1far+NW1ieyFrOqYBfJzJAmGg7cGCVyBqtXBt6C1I765ty+M2xaYokRWMKP1
        sLNXH28nhkFio2zFZRqSCSLyv7xxSzo=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-516-nLIEqitsPFuMmy5xvjunng-1; Mon, 18 Jul 2022 09:04:10 -0400
X-MC-Unique: nLIEqitsPFuMmy5xvjunng-1
Received: by mail-qv1-f70.google.com with SMTP id i8-20020ad44ba8000000b00472ff57d370so5406662qvw.2
        for <kvm@vger.kernel.org>; Mon, 18 Jul 2022 06:04:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=rCaukIQ4Y9kP6/SvywHkOLwsqGQwYiQZVmc0+Rt1khE=;
        b=ZGSS7be8mSYQ69Z2E8Ea6AUenj6F3nEHzF65L5YTggKa7Po9igkifru8XDoCabKlHu
         SSH+v74PUHHfEGrtNiSv1ofCAKDoaYL5pp8F89he29bMYIvpO5fin1R925U7X5SES48z
         57upDE7Ji8ywzxtnTGXjYExryZaAGf2nOFF9zf8gQBG8dXqZIos5W8SHxXMgJLSYmh1u
         ENGl9OJgmOnUzqucgjYPw3g/BsxpPsQ3TLM8q+tHnsAkMvGkY2mBlrwr9n3aDerq1MVU
         29LtYZq3pCcpvN2+wxoEYUW8r0mI/kwwaCYOWw46cvUzQcJb4ROz2HO4vgUi/e0Zcwi6
         QGBQ==
X-Gm-Message-State: AJIora+1sI/eZLYb6eqxOIX/IMLDfTrh7LWZL4v6Sz5c+rFJsmJ90RB9
        XHCxTT26XO5vj14RClty8UGRIurr4jMAYWi/sOBOYsLDuHXQGwU/KL2ZCjcxSc1vW9juFg6fznk
        yGoNlRmGh/NVs
X-Received: by 2002:a37:b8c4:0:b0:6b5:79e4:36f0 with SMTP id i187-20020a37b8c4000000b006b579e436f0mr16796650qkf.126.1658149448863;
        Mon, 18 Jul 2022 06:04:08 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sxp4WFs1CRKioCUfqdwEazjduXx4uCsRMlfV7UWtZG6xxfxu6hNzU/uGwBIl7vg64cKH8PbQ==
X-Received: by 2002:a37:b8c4:0:b0:6b5:79e4:36f0 with SMTP id i187-20020a37b8c4000000b006b579e436f0mr16796595qkf.126.1658149448288;
        Mon, 18 Jul 2022 06:04:08 -0700 (PDT)
Received: from [10.35.4.238] (bzq-82-81-161-50.red.bezeqint.net. [82.81.161.50])
        by smtp.gmail.com with ESMTPSA id h10-20020ac8548a000000b0031eddc83560sm6208450qtq.90.2022.07.18.06.04.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 06:04:07 -0700 (PDT)
Message-ID: <547250051f1578b7ddf60311be46b3eb7990ccc6.camel@redhat.com>
Subject: Re: [PATCH v2 02/24] KVM: VMX: Drop bits 31:16 when shoving
 exception error code into VMCS
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jim Mattson <jmattson@google.com>,
        Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Date:   Mon, 18 Jul 2022 16:04:04 +0300
In-Reply-To: <20220715204226.3655170-3-seanjc@google.com>
References: <20220715204226.3655170-1-seanjc@google.com>
         <20220715204226.3655170-3-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-5.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-07-15 at 20:42 +0000, Sean Christopherson wrote:
> Deliberately truncate the exception error code when shoving it into the
> VMCS (VM-Entry field for vmcs01 and vmcs02, VM-Exit field for vmcs12).
> Intel CPUs are incapable of handling 32-bit error codes and will never
> generate an error code with bits 31:16, but userspace can provide an
> arbitrary error code via KVM_SET_VCPU_EVENTS.  Failure to drop the bits
> on exception injection results in failed VM-Entry, as VMX disallows
> setting bits 31:16.  Setting the bits on VM-Exit would at best confuse
> L1, and at worse induce a nested VM-Entry failure, e.g. if L1 decided to
> reinject the exception back into L2.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Reviewed-by: Jim Mattson <jmattson@google.com>
> ---
>  arch/x86/kvm/vmx/nested.c |  9 ++++++++-
>  arch/x86/kvm/vmx/vmx.c    | 11 ++++++++++-
>  2 files changed, 18 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 8c2c81406248..05c34a72c266 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -3822,7 +3822,14 @@ static void nested_vmx_inject_exception_vmexit(struct kvm_vcpu *vcpu,
>         u32 intr_info = nr | INTR_INFO_VALID_MASK;
>  
>         if (vcpu->arch.exception.has_error_code) {
> -               vmcs12->vm_exit_intr_error_code = vcpu->arch.exception.error_code;
> +               /*
> +                * Intel CPUs will never generate an error code with bits 31:16
> +                * set, and more importantly VMX disallows setting bits 31:16
> +                * in the injected error code for VM-Entry.  Drop the bits to
> +                * mimic hardware and avoid inducing failure on nested VM-Entry
> +                * if L1 chooses to inject the exception back to L2.

Very small nitpick:
I think I would still prefer to have a mention that AMD CPUs can have error code > 16 bit,
The above comment kind of implies this, but it would be a bit more clear, but I don't
have a strong preference on this.


> +                */
> +               vmcs12->vm_exit_intr_error_code = (u16)vcpu->arch.exception.error_code;
>                 intr_info |= INTR_INFO_DELIVER_CODE_MASK;
>         }
>  
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index b0cc911a8f6f..d2b3d30d6afb 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1621,7 +1621,16 @@ static void vmx_queue_exception(struct kvm_vcpu *vcpu)
>         kvm_deliver_exception_payload(vcpu);
>  
>         if (has_error_code) {
> -               vmcs_write32(VM_ENTRY_EXCEPTION_ERROR_CODE, error_code);
> +               /*
> +                * Despite the error code being architecturally defined as 32
> +                * bits, and the VMCS field being 32 bits, Intel CPUs and thus
> +                * VMX don't actually supporting setting bits 31:16.  Hardware
> +                * will (should) never provide a bogus error code, but KVM's
> +                * ABI lets userspace shove in arbitrary 32-bit values.  Drop
> +                * the upper bits to avoid VM-Fail, losing information that
> +                * does't really exist is preferable to killing the VM.
> +                */
> +               vmcs_write32(VM_ENTRY_EXCEPTION_ERROR_CODE, (u16)error_code);
>                 intr_info |= INTR_INFO_DELIVER_CODE_MASK;
>         }
>  


Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
 Maxim Levitsky


