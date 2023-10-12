Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E2F37C7754
	for <lists+kvm@lfdr.de>; Thu, 12 Oct 2023 21:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442540AbjJLTwe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Oct 2023 15:52:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442559AbjJLTwd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Oct 2023 15:52:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1316113
        for <kvm@vger.kernel.org>; Thu, 12 Oct 2023 12:51:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697140288;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FN0hCzoaq8AmG1djNzWtTawftKIXoDU1JdzeJfHIRa4=;
        b=i7N3z3DQaGPCl62OE704hUOh96MLyD2uXTXjRMXTF6VpyfxbLyTo3VY0x2/vyjuxdHnx8H
        9qRbl5ZhKKtp0/pXidNTcuTpFFbclbhVbOAPn4dDqAvYwasZZbM8WBKz9uBdIFts1HpA9N
        yWd19O7qqcKxoPZsCnYbqf14qKZhPnM=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-314-NVtXpQOEPBKn9rqimQOvsw-1; Thu, 12 Oct 2023 15:51:27 -0400
X-MC-Unique: NVtXpQOEPBKn9rqimQOvsw-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4054743df06so9237275e9.3
        for <kvm@vger.kernel.org>; Thu, 12 Oct 2023 12:51:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697140286; x=1697745086;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FN0hCzoaq8AmG1djNzWtTawftKIXoDU1JdzeJfHIRa4=;
        b=nvJ+lM2yNYiHMYVtTM/0iQK8nzZATY1JCJftZoYh3iZzLL80kvUM9MFEEs95zqmEl7
         kLuTrZIMDOFrO49hy8RF42FWHP9Ga4loalHX89K3FfiAwbQfCw1lAuhuO5oc1X4LTuIU
         EN0vRvBrW5irt15LOi5l0sY5zs+m0VtkgVwobU0SbdoSGjoLxG6QyuocpUefrGxbZL+M
         d/e3bjio2NmVdxiVVoebAeCVrpKS3M6BUVTuePxPQ/iMlld5ip5hD+i82Td2sDCWL/BK
         Sl8pRXFlfpMs56etfwomhzoAv/KCPgKWyM7N5yskirn4S/PKmml9InIhHrdnO1Es6zNS
         gu7A==
X-Gm-Message-State: AOJu0Yyqx382XoMUEqrvNiSkPdPEFg7l9FnfzQJvmWb/lSsBgrxxCPOl
        T/OFiNvFuKqTfbLfssR1OOpB8tjdKWJGMYUPQn5Y+Es2EJW8ZuX6oWa8qtmfnJeI5cclXBOg4Zd
        4o4u9EDO8Acoi
X-Received: by 2002:a1c:7419:0:b0:405:7b92:453e with SMTP id p25-20020a1c7419000000b004057b92453emr22144875wmc.37.1697140286085;
        Thu, 12 Oct 2023 12:51:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEJfm1WRvOuXWmP7q7aaKwIRHV8uZRpor0oZZjI575mfE/iapqJhHqIvYVdKxoHK6vmsWN8rQ==
X-Received: by 2002:a1c:7419:0:b0:405:7b92:453e with SMTP id p25-20020a1c7419000000b004057b92453emr22144864wmc.37.1697140285875;
        Thu, 12 Oct 2023 12:51:25 -0700 (PDT)
Received: from starship ([89.237.100.246])
        by smtp.gmail.com with ESMTPSA id m8-20020a7bcb88000000b0040646a708dasm648046wmi.15.2023.10.12.12.51.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Oct 2023 12:51:25 -0700 (PDT)
Message-ID: <baa4c956d8a1bc86872560da9a15fec3798e3942.camel@redhat.com>
Subject: Re: [PATCH RFC 10/11] KVM: nVMX: hyper-v: Hide more stuff under
 CONFIG_KVM_HYPERV
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org
Date:   Thu, 12 Oct 2023 22:51:24 +0300
In-Reply-To: <20231010160300.1136799-11-vkuznets@redhat.com>
References: <20231010160300.1136799-1-vkuznets@redhat.com>
         <20231010160300.1136799-11-vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

У вт, 2023-10-10 у 18:02 +0200, Vitaly Kuznetsov пише:
> 'hv_evmcs_vmptr'/'hv_evmcs_map'/'hv_evmcs' fields in 'struct nested_vmx'
> should not be used when !CONFIG_KVM_HYPERV, hide them when
> !CONFIG_KVM_HYPERV.
> 
> No functional change intended.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 2 ++
>  arch/x86/kvm/vmx/vmx.c    | 3 +++
>  arch/x86/kvm/vmx/vmx.h    | 2 ++
>  3 files changed, 7 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index d539904d8f1e..10cb35cd7a19 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -6650,6 +6650,7 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
>  			return -EINVAL;
>  
>  		set_current_vmptr(vmx, kvm_state->hdr.vmx.vmcs12_pa);
> +#ifdef CONFIG_KVM_HYPERV
>  	} else if (kvm_state->flags & KVM_STATE_NESTED_EVMCS) {
>  		/*
>  		 * nested_vmx_handle_enlightened_vmptrld() cannot be called
> @@ -6659,6 +6660,7 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
>  		 */
>  		vmx->nested.hv_evmcs_vmptr = EVMPTR_MAP_PENDING;
>  		kvm_make_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
> +#endif
>  	} else {
>  		return -EINVAL;
>  	}
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 04eb5d4d28bc..3b1bd3d97150 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4834,7 +4834,10 @@ static void __vmx_vcpu_reset(struct kvm_vcpu *vcpu)
>  	vmx->nested.posted_intr_nv = -1;
>  	vmx->nested.vmxon_ptr = INVALID_GPA;
>  	vmx->nested.current_vmptr = INVALID_GPA;
> +
> +#ifdef CONFIG_KVM_HYPERV
>  	vmx->nested.hv_evmcs_vmptr = EVMPTR_INVALID;
> +#endif
>  
>  	vcpu->arch.microcode_version = 0x100000000ULL;
>  	vmx->msr_ia32_feature_control_valid_bits = FEAT_CTL_LOCKED;
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index c2130d2c8e24..55addb8eef01 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -241,9 +241,11 @@ struct nested_vmx {
>  		bool guest_mode;
>  	} smm;
>  
> +#ifdef CONFIG_KVM_HYPERV
>  	gpa_t hv_evmcs_vmptr;
>  	struct kvm_host_map hv_evmcs_map;
>  	struct hv_enlightened_vmcs *hv_evmcs;
> +#endif
>  };
>  
>  struct vcpu_vmx {
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

