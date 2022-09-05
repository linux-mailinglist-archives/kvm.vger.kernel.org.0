Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C88F5AC883
	for <lists+kvm@lfdr.de>; Mon,  5 Sep 2022 03:27:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235207AbiIEB1Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 4 Sep 2022 21:27:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbiIEB1Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 4 Sep 2022 21:27:24 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5437E2BB21
        for <kvm@vger.kernel.org>; Sun,  4 Sep 2022 18:27:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662341243; x=1693877243;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=PArFqMpsc31CVfxEJKJglsosV2yx3vAzp7IDKqJSsnE=;
  b=bagvwZWgcGpIcAEXSSErUIGqTpm72A9Ifbw2bHJNCdMgk8NWtTEK1Uay
   dRioiZGWakA5HMkVdKPmagyrfMIp66mkg36pEv1ywFyzY7AnXa85Qecyx
   DYB1VYqwJrgUYdARg+X+QYH4cHyNXgSAb67Xtwh9TLi4IbFcnYaqE6SxG
   qQ06sWRaX3hryc/jcTrDjoGTDsUDx2/zns/d1hXhL3ouPVHlt3YXKJpoi
   8jxnG1EUDziMJK4qoGazG05/GnZwnyzV/BQTZoDah1dYijZgP7d01/U6d
   /pkt2J9p1a1JtUyWH+QJd9HZNQrBiWfQFKjxq3h+Rv1Bxxz6plkZBjeL3
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10460"; a="358000089"
X-IronPort-AV: E=Sophos;i="5.93,290,1654585200"; 
   d="scan'208";a="358000089"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2022 18:27:22 -0700
X-IronPort-AV: E=Sophos;i="5.93,290,1654585200"; 
   d="scan'208";a="675077315"
Received: from zengguan-mobl1.ccr.corp.intel.com (HELO [10.238.0.184]) ([10.238.0.184])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2022 18:27:20 -0700
Message-ID: <2c9d8124-c8f5-5f21-74c5-307e16544143@intel.com>
Date:   Mon, 5 Sep 2022 09:27:09 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v3] target/i386: Set maximum APIC ID to KVM prior to vCPU
 creation
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Gao, Chao" <chao.gao@intel.com>
References: <20220825025246.26618-1-guang.zeng@intel.com>
From:   Zeng Guang <guang.zeng@intel.com>
In-Reply-To: <20220825025246.26618-1-guang.zeng@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Kindly PING!

On 8/25/2022 10:52 AM, Zeng Guang wrote:
> Specify maximum possible APIC ID assigned for current VM session to KVM
> prior to the creation of vCPUs. By this setting, KVM can set up VM-scoped
> data structure indexed by the APIC ID, e.g. Posted-Interrupt Descriptor
> pointer table to support Intel IPI virtualization, with the most optimal
> memory footprint.
>
> It can be achieved by calling KVM_ENABLE_CAP for KVM_CAP_MAX_VCPU_ID
> capability once KVM has enabled it. Ignoring the return error if KVM
> doesn't support this capability yet.
>
> Signed-off-by: Zeng Guang <guang.zeng@intel.com>
> ---
>   hw/i386/x86.c              | 4 ++++
>   target/i386/kvm/kvm-stub.c | 5 +++++
>   target/i386/kvm/kvm.c      | 5 +++++
>   target/i386/kvm/kvm_i386.h | 1 +
>   4 files changed, 15 insertions(+)
>
> diff --git a/hw/i386/x86.c b/hw/i386/x86.c
> index 050eedc0c8..4831193c86 100644
> --- a/hw/i386/x86.c
> +++ b/hw/i386/x86.c
> @@ -139,6 +139,10 @@ void x86_cpus_init(X86MachineState *x86ms, int default_cpu_version)
>           exit(EXIT_FAILURE);
>       }
>   
> +    if (kvm_enabled()) {
> +        kvm_set_max_apic_id(x86ms->apic_id_limit);
> +    }
> +
>       possible_cpus = mc->possible_cpu_arch_ids(ms);
>       for (i = 0; i < ms->smp.cpus; i++) {
>           x86_cpu_new(x86ms, possible_cpus->cpus[i].arch_id, &error_fatal);
> diff --git a/target/i386/kvm/kvm-stub.c b/target/i386/kvm/kvm-stub.c
> index f6e7e4466e..e052f1c7b0 100644
> --- a/target/i386/kvm/kvm-stub.c
> +++ b/target/i386/kvm/kvm-stub.c
> @@ -44,3 +44,8 @@ bool kvm_hyperv_expand_features(X86CPU *cpu, Error **errp)
>   {
>       abort();
>   }
> +
> +void kvm_set_max_apic_id(uint32_t max_apic_id)
> +{
> +    return;
> +}
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index f148a6d52f..af4ef1e8f0 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -5428,3 +5428,8 @@ void kvm_request_xsave_components(X86CPU *cpu, uint64_t mask)
>           mask &= ~BIT_ULL(bit);
>       }
>   }
> +
> +void kvm_set_max_apic_id(uint32_t max_apic_id)
> +{
> +    kvm_vm_enable_cap(kvm_state, KVM_CAP_MAX_VCPU_ID, 0, max_apic_id);
> +}
> diff --git a/target/i386/kvm/kvm_i386.h b/target/i386/kvm/kvm_i386.h
> index 4124912c20..c133b32a58 100644
> --- a/target/i386/kvm/kvm_i386.h
> +++ b/target/i386/kvm/kvm_i386.h
> @@ -54,4 +54,5 @@ uint64_t kvm_swizzle_msi_ext_dest_id(uint64_t address);
>   bool kvm_enable_sgx_provisioning(KVMState *s);
>   void kvm_request_xsave_components(X86CPU *cpu, uint64_t mask);
>   
> +void kvm_set_max_apic_id(uint32_t max_apic_id);
>   #endif
