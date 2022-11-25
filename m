Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6D8C638736
	for <lists+kvm@lfdr.de>; Fri, 25 Nov 2022 11:19:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbiKYKTA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Nov 2022 05:19:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbiKYKS7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Nov 2022 05:18:59 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11B4D2126B;
        Fri, 25 Nov 2022 02:18:58 -0800 (PST)
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NJW672Lb5zRpQ9;
        Fri, 25 Nov 2022 18:18:23 +0800 (CST)
Received: from kwepemm600007.china.huawei.com (7.193.23.208) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 25 Nov 2022 18:18:56 +0800
Received: from [10.174.185.210] (10.174.185.210) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 25 Nov 2022 18:18:55 +0800
Subject: Re: [PATCH v3 1/3] KVM: x86/pmu: Disable guest PEBS on hybird cpu due
 to heterogeneity
To:     Like Xu <like.xu.linux@gmail.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
CC:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        "wanghaibin.wang@huawei.com" <wanghaibin.wang@huawei.com>,
        Zenghui Yu <yuzenghui@huawei.com>
References: <20221109082802.27543-1-likexu@tencent.com>
 <20221109082802.27543-2-likexu@tencent.com>
From:   Kunkun Jiang <jiangkunkun@huawei.com>
Message-ID: <16bb2874-c8c8-fb4e-c793-28605f36712b@huawei.com>
Date:   Fri, 25 Nov 2022 18:18:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20221109082802.27543-2-likexu@tencent.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.174.185.210]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600007.china.huawei.com (7.193.23.208)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Like,

There is a question I would like to ask. As far as I know, Alder Lake uses
a hybrid architecture and the kernel presents two types of PMUs.Can the
events created on the VCPU still count normally if the VCPU thread gets
migrate across different CPUs?

As far as I know, ARM64 big.LITTLE is not working properly, according to
this set of patches.
[PATCH v4 0/6] KVM: arm64: Improve PMU support on heterogeneous systems
https://lore.kernel.org/all/20220127161759.53553-1-alexandru.elisei@arm.com/

Thanks，
Kunkun Jiang

On 2022/11/9 16:28, Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
>
> >From vPMU enabling perspective, KVM does not have proper support for
> hybird x86 core. The reported perf_capabilities value (e.g. the format
> of pebs record) depends on the type of cpu the kvm-intel module is init.
> When a vcpu of one pebs format migrates to a vcpu of another pebs format,
> the incorrect parsing of pebs records by guest can make profiling data
> analysis extremely problematic.
>
> The safe way to fix this is to disable this part of the support until the
> guest recognizes that it is running on the hybird cpu, which is appropriate
> at the moment given that x86 hybrid architectures are not heavily touted
> in the data center market.
>
> Signed-off-by: Like Xu <likexu@tencent.com>
> ---
>   arch/x86/kvm/vmx/capabilities.h | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
> index cd2ac9536c99..ea0498684048 100644
> --- a/arch/x86/kvm/vmx/capabilities.h
> +++ b/arch/x86/kvm/vmx/capabilities.h
> @@ -392,7 +392,9 @@ static inline bool vmx_pt_mode_is_host_guest(void)
>   
>   static inline bool vmx_pebs_supported(void)
>   {
> -	return boot_cpu_has(X86_FEATURE_PEBS) && kvm_pmu_cap.pebs_ept;
> +	return boot_cpu_has(X86_FEATURE_PEBS) &&
> +	       !boot_cpu_has(X86_FEATURE_HYBRID_CPU) &&
> +	       kvm_pmu_cap.pebs_ept;
>   }
>   
>   static inline bool cpu_has_notify_vmexit(void)
