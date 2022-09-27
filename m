Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40B1F5EC1F7
	for <lists+kvm@lfdr.de>; Tue, 27 Sep 2022 13:58:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231684AbiI0L6Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Sep 2022 07:58:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231946AbiI0L6W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Sep 2022 07:58:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A13DA1559E8
        for <kvm@vger.kernel.org>; Tue, 27 Sep 2022 04:58:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664279900;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z04ahWrbv+gyCpLbQuuob6w9lJHZaacCaCrvM8sjvoY=;
        b=EMv43gOIp6IwcTfqlYndczYeRyUC8hHx6gRlRs75RULkkgWP8wD5+qJ+GryRm3N81u4rZx
        2ViVeYd1snLmDnwrXEaVNJ82fIzkbB5J6yy/1sZ/7KoBTyjxy4VrmK0p69d4TfKcJZeaQT
        ETUFcFu+/9erBaWWeB8RY1EJy2FGgb8=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-313-x63EQSxyMCqkdrFPQQ2Kfg-1; Tue, 27 Sep 2022 07:58:19 -0400
X-MC-Unique: x63EQSxyMCqkdrFPQQ2Kfg-1
Received: by mail-ed1-f70.google.com with SMTP id dz21-20020a0564021d5500b0045217702048so7513317edb.5
        for <kvm@vger.kernel.org>; Tue, 27 Sep 2022 04:58:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=Z04ahWrbv+gyCpLbQuuob6w9lJHZaacCaCrvM8sjvoY=;
        b=BMBrbqkdPx2tb1eNJott5lMkIx3PIvYNhx105oiiRjO9VLG6iaA06KuKe7ILXng6WI
         tQu4MFbw9U3rFzdSzc2/7QULZDiRO+KzI3cbRBxeGVbSnENcVeQEpVgd92eBdgOCMW10
         Y100WiYkOSvDp0B94xW2OS+PLAjAlHA336a0R2DdyG0RLOjO4TucGJNiuiZcktFSCDcD
         GetfrPLRCQSv5fBZ7xq5NWKUbyB9mJ8I8elwGDWsP4NPXNfEI66yqicqW/YfvY9ceYBn
         CWqxVNtY565L4jta/qTrOnTYwPnsgVCN4nXht2CJPNL5oTDLWL+e7spKhGV7j/zS3vU0
         /dVg==
X-Gm-Message-State: ACrzQf08a+Ch2W4GExeOJzmCYgF5wWaH6H76EJ8lU3KT8fIIzME52qKf
        m6ce1atUO2n27FOXMN8+1t4FKlDbvjLQRMFdmPmSgEjlGz2L9rrVPuQdU9524j4y5TK1rd/Izw0
        O3FBGyAAmEshG
X-Received: by 2002:a17:907:70c:b0:740:33f3:cbab with SMTP id xb12-20020a170907070c00b0074033f3cbabmr22210750ejb.600.1664279897530;
        Tue, 27 Sep 2022 04:58:17 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7mUfz41lvpm4jpECOhfIvGUYjVk3+igb6pvHQJYZLUgUgN7qW3UB/a2by9Bw5F2ymGicq4zg==
X-Received: by 2002:a17:907:70c:b0:740:33f3:cbab with SMTP id xb12-20020a170907070c00b0074033f3cbabmr22210700ejb.600.1664279896830;
        Tue, 27 Sep 2022 04:58:16 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id f20-20020a50ee94000000b004482dd03fe8sm1095629edr.91.2022.09.27.04.58.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Sep 2022 04:58:16 -0700 (PDT)
Message-ID: <3d091669-cb83-330e-52d0-5d3ac0fe7214@redhat.com>
Date:   Tue, 27 Sep 2022 13:58:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH] KVM: selftests: Skip tests that require EPT when it is
 not available
To:     David Matlack <dmatlack@google.com>
Cc:     Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
References: <20220926171457.532542-1-dmatlack@google.com>
Content-Language: en-US
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220926171457.532542-1-dmatlack@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/26/22 19:14, David Matlack wrote:
> Skip selftests that require EPT support in the VM when it is not
> available. For example, if running on a machine where kvm_intel.ept=N
> since KVM does not offer EPT support to guests if EPT is not supported
> on the host.
> 
> This commit causes vmx_dirty_log_test to be skipped instead of failing
> on hosts where kvm_intel.ept=N.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>   .../selftests/kvm/include/x86_64/vmx.h        |  1 +
>   tools/testing/selftests/kvm/lib/x86_64/vmx.c  | 20 +++++++++++++++++++
>   2 files changed, 21 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/include/x86_64/vmx.h b/tools/testing/selftests/kvm/include/x86_64/vmx.h
> index 99fa1410964c..790c6d1ecb34 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/vmx.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/vmx.h
> @@ -617,6 +617,7 @@ void nested_map_memslot(struct vmx_pages *vmx, struct kvm_vm *vm,
>   			uint32_t memslot);
>   void nested_identity_map_1g(struct vmx_pages *vmx, struct kvm_vm *vm,
>   			    uint64_t addr, uint64_t size);
> +bool kvm_vm_has_ept(struct kvm_vm *vm);
>   void prepare_eptp(struct vmx_pages *vmx, struct kvm_vm *vm,
>   		  uint32_t eptp_memslot);
>   void prepare_virtualize_apic_accesses(struct vmx_pages *vmx, struct kvm_vm *vm);
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/vmx.c b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
> index 80a568c439b8..d21049c38fc5 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/vmx.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
> @@ -5,6 +5,8 @@
>    * Copyright (C) 2018, Google LLC.
>    */
>   
> +#include <asm/msr-index.h>
> +
>   #include "test_util.h"
>   #include "kvm_util.h"
>   #include "processor.h"
> @@ -542,9 +544,27 @@ void nested_identity_map_1g(struct vmx_pages *vmx, struct kvm_vm *vm,
>   	__nested_map(vmx, vm, addr, addr, size, PG_LEVEL_1G);
>   }
>   
> +bool kvm_vm_has_ept(struct kvm_vm *vm)
> +{
> +	struct kvm_vcpu *vcpu;
> +	uint64_t ctrl;
> +
> +	vcpu = list_first_entry(&vm->vcpus, struct kvm_vcpu, list);
> +	TEST_ASSERT(vcpu, "Cannot determine EPT support without vCPUs.\n");
> +
> +	ctrl = vcpu_get_msr(vcpu, MSR_IA32_VMX_TRUE_PROCBASED_CTLS) >> 32;
> +	if (!(ctrl & CPU_BASED_ACTIVATE_SECONDARY_CONTROLS))
> +		return false;
> +
> +	ctrl = vcpu_get_msr(vcpu, MSR_IA32_VMX_PROCBASED_CTLS2) >> 32;
> +	return ctrl & SECONDARY_EXEC_ENABLE_EPT;
> +}
> +
>   void prepare_eptp(struct vmx_pages *vmx, struct kvm_vm *vm,
>   		  uint32_t eptp_memslot)
>   {
> +	TEST_REQUIRE(kvm_vm_has_ept(vm));
> +
>   	vmx->eptp = (void *)vm_vaddr_alloc_page(vm);
>   	vmx->eptp_hva = addr_gva2hva(vm, (uintptr_t)vmx->eptp);
>   	vmx->eptp_gpa = addr_gva2gpa(vm, (uintptr_t)vmx->eptp);
> 
> base-commit: 372d07084593dc7a399bf9bee815711b1fb1bcf2
> prerequisite-patch-id: 2e3661ba8856c29b769499bac525b6943d9284b8
> prerequisite-patch-id: 93031262de7b1f7fab1ad31ea5d6ef812c139179

Queued for 6.0, thanks.

Paolo

