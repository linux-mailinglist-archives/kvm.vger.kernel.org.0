Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 452205232EC
	for <lists+kvm@lfdr.de>; Wed, 11 May 2022 14:18:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242069AbiEKMS4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 May 2022 08:18:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242325AbiEKMSr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 May 2022 08:18:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6FA5166FB0
        for <kvm@vger.kernel.org>; Wed, 11 May 2022 05:18:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652271521;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vPCHCk+m9eMkfNHcSlo497cSCDeJHYEmoGiZK+XZy0M=;
        b=fGYNrjUZAgSqwSbNoGCfvDebIHNQklMVOpqQxxyr5vYZ08ZgmOEjvLy3BkKhjTtbV72hnj
        yHzHJGYpzPQJG6znbKZCV2saoOSyxXfPTdCclyqufpLtm9tGBtUTy4b3c3LqDWS+iDjVTF
        3ELhvsqr0jgjFAFI0Zp3gYW581kdoTw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-45-iM4tCd3uOX6IcIPDGAkozg-1; Wed, 11 May 2022 08:18:37 -0400
X-MC-Unique: iM4tCd3uOX6IcIPDGAkozg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D13EE101AA4D;
        Wed, 11 May 2022 12:18:36 +0000 (UTC)
Received: from starship (unknown [10.40.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8D6BA4538B0;
        Wed, 11 May 2022 12:18:34 +0000 (UTC)
Message-ID: <cd8b071da6287b5c8c26bf4c5fb9b5c02c629cb5.camel@redhat.com>
Subject: Re: [PATCH v3 32/34] KVM: selftests: Move Hyper-V VP assist page
 enablement out of evmcs.h
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Wed, 11 May 2022 15:18:33 +0300
In-Reply-To: <20220414132013.1588929-33-vkuznets@redhat.com>
References: <20220414132013.1588929-1-vkuznets@redhat.com>
         <20220414132013.1588929-33-vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-04-14 at 15:20 +0200, Vitaly Kuznetsov wrote:
> Hyper-V VP assist page is not eVMCS specific, it is also used for
> enlightened nSVM. Move the code to vendor neutral place.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  tools/testing/selftests/kvm/Makefile          |  2 +-
>  .../selftests/kvm/include/x86_64/evmcs.h      | 40 +------------------
>  .../selftests/kvm/include/x86_64/hyperv.h     | 31 ++++++++++++++
>  .../testing/selftests/kvm/lib/x86_64/hyperv.c | 21 ++++++++++
>  .../testing/selftests/kvm/x86_64/evmcs_test.c |  1 +
>  5 files changed, 56 insertions(+), 39 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/lib/x86_64/hyperv.c
> 
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index 8b83abc09a1a..ae13aa32f3ce 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -38,7 +38,7 @@ ifeq ($(ARCH),riscv)
>  endif
>  
>  LIBKVM = lib/assert.c lib/elf.c lib/io.c lib/kvm_util.c lib/rbtree.c lib/sparsebit.c lib/test_util.c lib/guest_modes.c lib/perf_test_util.c
> -LIBKVM_x86_64 = lib/x86_64/apic.c lib/x86_64/processor.c lib/x86_64/vmx.c lib/x86_64/svm.c lib/x86_64/ucall.c lib/x86_64/handlers.S
> +LIBKVM_x86_64 = lib/x86_64/apic.c lib/x86_64/hyperv.c lib/x86_64/processor.c lib/x86_64/vmx.c lib/x86_64/svm.c lib/x86_64/ucall.c lib/x86_64/handlers.S
>  LIBKVM_aarch64 = lib/aarch64/processor.c lib/aarch64/ucall.c lib/aarch64/handlers.S lib/aarch64/spinlock.c lib/aarch64/gic.c lib/aarch64/gic_v3.c lib/aarch64/vgic.c
>  LIBKVM_s390x = lib/s390x/processor.c lib/s390x/ucall.c lib/s390x/diag318_test_handler.c
>  LIBKVM_riscv = lib/riscv/processor.c lib/riscv/ucall.c
> diff --git a/tools/testing/selftests/kvm/include/x86_64/evmcs.h b/tools/testing/selftests/kvm/include/x86_64/evmcs.h
> index 36c0a67d8602..026586b53013 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/evmcs.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/evmcs.h
> @@ -10,6 +10,7 @@
>  #define SELFTEST_KVM_EVMCS_H
>  
>  #include <stdint.h>
> +#include "hyperv.h"
>  #include "vmx.h"
>  
>  #define u16 uint16_t
> @@ -20,27 +21,6 @@
>  
>  extern bool enable_evmcs;
>  
> -struct hv_nested_enlightenments_control {
> -	struct {
> -		__u32 directhypercall:1;
> -		__u32 reserved:31;
> -	} features;
> -	struct {
> -		__u32 reserved;
> -	} hypercallControls;
> -} __packed;
> -
> -/* Define virtual processor assist page structure. */
> -struct hv_vp_assist_page {
> -	__u32 apic_assist;
> -	__u32 reserved1;
> -	__u64 vtl_control[3];
> -	struct hv_nested_enlightenments_control nested_control;
> -	__u8 enlighten_vmentry;
> -	__u8 reserved2[7];
> -	__u64 current_nested_vmcs;
> -} __packed;
> -
>  struct hv_enlightened_vmcs {
>  	u32 revision_id;
>  	u32 abort;
> @@ -246,31 +226,15 @@ struct hv_enlightened_vmcs {
>  #define HV_VMX_ENLIGHTENED_CLEAN_FIELD_ENLIGHTENMENTSCONTROL    BIT(15)
>  #define HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL                      0xFFFF
>  
> -#define HV_X64_MSR_VP_ASSIST_PAGE		0x40000073
> -#define HV_X64_MSR_VP_ASSIST_PAGE_ENABLE	0x00000001
> -#define HV_X64_MSR_VP_ASSIST_PAGE_ADDRESS_SHIFT	12
> -#define HV_X64_MSR_VP_ASSIST_PAGE_ADDRESS_MASK	\
> -		(~((1ull << HV_X64_MSR_VP_ASSIST_PAGE_ADDRESS_SHIFT) - 1))
> -
>  #define HV_VMX_SYNTHETIC_EXIT_REASON_TRAP_AFTER_FLUSH 0x10000031
>  
>  extern struct hv_enlightened_vmcs *current_evmcs;
> -extern struct hv_vp_assist_page *current_vp_assist;
>  
>  int vcpu_enable_evmcs(struct kvm_vm *vm, int vcpu_id);
>  
> -static inline int enable_vp_assist(uint64_t vp_assist_pa, void *vp_assist)
> +static inline void evmcs_enable(void)
>  {
> -	u64 val = (vp_assist_pa & HV_X64_MSR_VP_ASSIST_PAGE_ADDRESS_MASK) |
> -		HV_X64_MSR_VP_ASSIST_PAGE_ENABLE;
> -
> -	wrmsr(HV_X64_MSR_VP_ASSIST_PAGE, val);
> -
> -	current_vp_assist = vp_assist;
> -
>  	enable_evmcs = true;
> -
> -	return 0;
>  }
>  
>  static inline int evmcs_vmptrld(uint64_t vmcs_pa, void *vmcs)
> diff --git a/tools/testing/selftests/kvm/include/x86_64/hyperv.h b/tools/testing/selftests/kvm/include/x86_64/hyperv.h
> index 1e34dd7c5075..095c15fc5381 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/hyperv.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/hyperv.h
> @@ -189,4 +189,35 @@
>  
>  #define HYPERV_LINUX_OS_ID ((u64)0x8100 << 48)
>  
> +#define HV_X64_MSR_VP_ASSIST_PAGE		0x40000073
> +#define HV_X64_MSR_VP_ASSIST_PAGE_ENABLE	0x00000001
> +#define HV_X64_MSR_VP_ASSIST_PAGE_ADDRESS_SHIFT	12
> +#define HV_X64_MSR_VP_ASSIST_PAGE_ADDRESS_MASK	\
> +		(~((1ull << HV_X64_MSR_VP_ASSIST_PAGE_ADDRESS_SHIFT) - 1))
> +
> +struct hv_nested_enlightenments_control {
> +	struct {
> +		__u32 directhypercall:1;
> +		__u32 reserved:31;
> +	} features;
> +	struct {
> +		__u32 reserved;
> +	} hypercallControls;
> +} __packed;
> +
> +/* Define virtual processor assist page structure. */
> +struct hv_vp_assist_page {
> +	__u32 apic_assist;
> +	__u32 reserved1;
> +	__u64 vtl_control[3];
> +	struct hv_nested_enlightenments_control nested_control;
> +	__u8 enlighten_vmentry;
> +	__u8 reserved2[7];
> +	__u64 current_nested_vmcs;
> +} __packed;
> +
> +extern struct hv_vp_assist_page *current_vp_assist;
> +
> +int enable_vp_assist(uint64_t vp_assist_pa, void *vp_assist);
> +
>  #endif /* !SELFTEST_KVM_HYPERV_H */
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/hyperv.c b/tools/testing/selftests/kvm/lib/x86_64/hyperv.c
> new file mode 100644
> index 000000000000..32dc0afd9e5b
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/lib/x86_64/hyperv.c
> @@ -0,0 +1,21 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Hyper-V specific functions.
> + *
> + * Copyright (C) 2021, Red Hat Inc.
> + */
> +#include <stdint.h>
> +#include "processor.h"
> +#include "hyperv.h"
> +
> +int enable_vp_assist(uint64_t vp_assist_pa, void *vp_assist)
> +{
> +	uint64_t val = (vp_assist_pa & HV_X64_MSR_VP_ASSIST_PAGE_ADDRESS_MASK) |
> +		HV_X64_MSR_VP_ASSIST_PAGE_ENABLE;
> +
> +	wrmsr(HV_X64_MSR_VP_ASSIST_PAGE, val);
> +
> +	current_vp_assist = vp_assist;
> +
> +	return 0;
> +}
> diff --git a/tools/testing/selftests/kvm/x86_64/evmcs_test.c b/tools/testing/selftests/kvm/x86_64/evmcs_test.c
> index 8d2aa7600d78..8fa50e76d557 100644
> --- a/tools/testing/selftests/kvm/x86_64/evmcs_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/evmcs_test.c
> @@ -105,6 +105,7 @@ void guest_code(struct vmx_pages *vmx_pages, vm_vaddr_t pgs_gpa)
>  	GUEST_SYNC(2);
>  
>  	enable_vp_assist(vmx_pages->vp_assist_gpa, vmx_pages->vp_assist);
> +	evmcs_enable();
>  
>  	GUEST_ASSERT(vmx_pages->vmcs_gpa);
>  	GUEST_ASSERT(prepare_for_vmx_operation(vmx_pages));

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

