Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71B3F4E7801
	for <lists+kvm@lfdr.de>; Fri, 25 Mar 2022 16:37:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354043AbiCYPgf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Mar 2022 11:36:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377390AbiCYPd0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Mar 2022 11:33:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 325D82E080
        for <kvm@vger.kernel.org>; Fri, 25 Mar 2022 08:29:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648222142;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R4b/RrzRGXsrmJmZeFQ5kq93JrdF0EChm4bSn93FYyo=;
        b=KFc2FtojHtZPFCSYdSteVJTL0uOgraPeItYq/HeXtVi+Lt+6ljBXXxKv4nJVDciayZcQIB
        UrRUZvJvfuMNVMR1Wn1X6CUthFksmOj6fcYlMrli0Gy6AVrdakDR6D6qEXrc9eaYjutzn1
        aKUHHCOQ2b4pssROyfX/KuMjruqjbKM=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-668-bDkVRDmSNby5xuF33OPRrQ-1; Fri, 25 Mar 2022 11:28:59 -0400
X-MC-Unique: bDkVRDmSNby5xuF33OPRrQ-1
Received: by mail-ed1-f72.google.com with SMTP id z22-20020a50cd16000000b0041960ea8555so5149569edi.2
        for <kvm@vger.kernel.org>; Fri, 25 Mar 2022 08:28:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=R4b/RrzRGXsrmJmZeFQ5kq93JrdF0EChm4bSn93FYyo=;
        b=I3MKy6UwEOJd+r40vDoDHgXvR5nl/XrHBQS7nkWS9X/GvSuBJ9BKD+NhRNz8+i4fms
         ZTqiRBUXdDCDTHVOvVWdzeKYuFrPMU5aix7mc30RMHI87sf/w/sEUeVp5j7lzqEwWXOS
         jmvWnLh+9dHsfsq5kXc9WrrURoOFEUnZhxGxB7ZQonOqxsOsxr4B5GnvCYC89E4DLvq0
         qt5W98QpKh8PgY1YN5Ey9xVRpywMt+0hbM8nSkVDETkBCrMBlGvbVtjZ4HlmPO5j8lmp
         ftRIcnYO460rOHiItZ581vlyqqMb9F3hDjc9gTQ+HrlNUU6O7HXvsl/l9iVk5NsBv2j0
         F+iA==
X-Gm-Message-State: AOAM531aH3Hnlf32urX7hyofgWPbkDjc+VRahVIprJTcgTOReN0lUSni
        Fq++qisouYjrAt/OVOhslpVy8Sre4FYiry9K9rKyFEaeuX69QePMa1Xs/khBq293Cwyb1DZ8Gk1
        T7LCTUBN9tICK
X-Received: by 2002:a17:907:3f86:b0:6db:b745:f761 with SMTP id hr6-20020a1709073f8600b006dbb745f761mr11683524ejc.610.1648222137981;
        Fri, 25 Mar 2022 08:28:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwFMz1bXOrDR8uR67xIBjSTgllG9Bb+/PbFJfLogt7xVbQ9GZR/XRrA+3EDQZUqVdk+fCRK5w==
X-Received: by 2002:a17:907:3f86:b0:6db:b745:f761 with SMTP id hr6-20020a1709073f8600b006dbb745f761mr11683497ejc.610.1648222137771;
        Fri, 25 Mar 2022 08:28:57 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id f3-20020a056402004300b004162aa024c0sm2943242edu.76.2022.03.25.08.28.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Mar 2022 08:28:57 -0700 (PDT)
Message-ID: <d0366a14-6492-d2b9-215e-2ee310d9f8ae@redhat.com>
Date:   Fri, 25 Mar 2022 16:28:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2] Add KVM_EXIT_SHUTDOWN metadata for SEV-ES
Content-Language: en-US
To:     Peter Gonda <pgonda@google.com>, kvm@vger.kernel.org
Cc:     Borislav Petkov <bp@alien8.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Joerg Roedel <jroedel@suse.de>, Marc Orr <marcorr@google.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org
References: <20220325152758.335626-1-pgonda@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220325152758.335626-1-pgonda@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/25/22 16:27, Peter Gonda wrote:
> SEV-ES guests can request termination using the GHCB's MSR protocol. See
> AMD's GHCB spec section '4.1.13 Termination Request'. Currently when a
> guest does this the userspace VMM sees an KVM_EXIT_UNKNOWN (-EVINAL)
> return code from KVM_RUN. By adding a KVM_EXIT_SHUTDOWN_ENTRY to kvm_run
> struct the userspace VMM can clear see the guest has requested a SEV-ES
> termination including the termination reason code set and reason code.
> 
> Signed-off-by: Peter Gonda <pgonda@google.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Brijesh Singh <brijesh.singh@amd.com>
> Cc: Joerg Roedel <jroedel@suse.de>
> Cc: Marc Orr <marcorr@google.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: kvm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org

This is missing an update to Documentation/.

Paolo

> ---
> 
> V2
>   * Add KVM_CAP_EXIT_SHUTDOWN_REASON check for KVM_CHECK_EXTENSION.
> 
> Tested by making an SEV-ES guest call sev_es_terminate() with hardcoded
> reason code set and reason code and then observing the codes from the
> userspace VMM in the kvm_run.shutdown.data fields.
> 
> ---
>   arch/x86/kvm/svm/sev.c   |  9 +++++++--
>   include/uapi/linux/kvm.h | 13 +++++++++++++
>   virt/kvm/kvm_main.c      |  1 +
>   3 files changed, 21 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 75fa6dd268f0..5f9d37dd3f6f 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2735,8 +2735,13 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
>   		pr_info("SEV-ES guest requested termination: %#llx:%#llx\n",
>   			reason_set, reason_code);
>   
> -		ret = -EINVAL;
> -		break;
> +		vcpu->run->exit_reason = KVM_EXIT_SHUTDOWN;
> +		vcpu->run->shutdown.reason = KVM_SHUTDOWN_SEV_TERM;
> +		vcpu->run->shutdown.ndata = 2;
> +		vcpu->run->shutdown.data[0] = reason_set;
> +		vcpu->run->shutdown.data[1] = reason_code;
> +
> +		return 0;
>   	}
>   	default:
>   		/* Error, keep GHCB MSR value as-is */
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 8616af85dc5d..017c03421c48 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -271,6 +271,12 @@ struct kvm_xen_exit {
>   #define KVM_EXIT_XEN              34
>   #define KVM_EXIT_RISCV_SBI        35
>   
> +/* For KVM_EXIT_SHUTDOWN */
> +/* Standard VM shutdown request. No additional metadata provided. */
> +#define KVM_SHUTDOWN_REQ	0
> +/* SEV-ES termination request */
> +#define KVM_SHUTDOWN_SEV_TERM	1
> +
>   /* For KVM_EXIT_INTERNAL_ERROR */
>   /* Emulate instruction failed. */
>   #define KVM_INTERNAL_ERROR_EMULATION	1
> @@ -311,6 +317,12 @@ struct kvm_run {
>   		struct {
>   			__u64 hardware_exit_reason;
>   		} hw;
> +		/* KVM_EXIT_SHUTDOWN */
> +		struct {
> +			__u64 reason;
> +			__u32 ndata;
> +			__u64 data[16];
> +		} shutdown;
>   		/* KVM_EXIT_FAIL_ENTRY */
>   		struct {
>   			__u64 hardware_entry_failure_reason;
> @@ -1145,6 +1157,7 @@ struct kvm_ppc_resize_hpt {
>   #define KVM_CAP_PMU_CAPABILITY 212
>   #define KVM_CAP_DISABLE_QUIRKS2 213
>   #define KVM_CAP_VM_TSC_CONTROL 214
> +#define KVM_CAP_EXIT_SHUTDOWN_REASON 215
>   
>   #ifdef KVM_CAP_IRQ_ROUTING
>   
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 70e05af5ebea..03b6e472f32c 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4299,6 +4299,7 @@ static long kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
>   	case KVM_CAP_CHECK_EXTENSION_VM:
>   	case KVM_CAP_ENABLE_CAP_VM:
>   	case KVM_CAP_HALT_POLL:
> +	case KVM_CAP_EXIT_SHUTDOWN_REASON:
>   		return 1;
>   #ifdef CONFIG_KVM_MMIO
>   	case KVM_CAP_COALESCED_MMIO:

