Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 235075AC9CD
	for <lists+kvm@lfdr.de>; Mon,  5 Sep 2022 07:36:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235396AbiIEFf7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Sep 2022 01:35:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231744AbiIEFf5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Sep 2022 01:35:57 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41F4526AE6;
        Sun,  4 Sep 2022 22:35:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662356156; x=1693892156;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=cQMxScv/eSJNt080rZxewyQzAxe+pGTLshbySipJkFo=;
  b=Bsf3rf+elELLZMq0F188ifDEtI3Ee18X9P08UsjEHAg1NPZcxRbROW0x
   nRIDExjnnQMctf6hjBNn5192QlaR9WZMesifHrtOZSH4F1MDygRJVLAVX
   YSybHm52EfQdFB6ZIldzzEdHEELUidh8RLjEgKyG8nLtHXWQ0ZJUS3aZk
   7tbhCyjXlw1kS0cVQLfGBJMddjOglucXgyEuEv6U+ZrzQyANKBq1xexDD
   k14TdwssCAM8bGH2G0Dpu9DHV9R8NuE0pcVl1JDAFCNQEMqiyWeRjz/3X
   75zfimHqmc4nb04NzrAGCu05NrHz3CfgQCwJf+drxKzqZWanAqzppd7u/
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10460"; a="293893746"
X-IronPort-AV: E=Sophos;i="5.93,290,1654585200"; 
   d="scan'208";a="293893746"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2022 22:35:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,290,1654585200"; 
   d="scan'208";a="609565717"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by orsmga007.jf.intel.com with ESMTP; 04 Sep 2022 22:35:51 -0700
Date:   Mon, 5 Sep 2022 13:35:50 +0800
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     isaku.yamahata@intel.com
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        isaku.yamahata@gmail.com, Kai Huang <kai.huang@intel.com>,
        Chao Gao <chao.gao@intel.com>,
        Atish Patra <atishp@atishpatra.org>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Qi Liu <liuqi115@huawei.com>,
        John Garry <john.garry@huawei.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Huang Ying <ying.huang@intel.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v3 02/22] KVM: x86: Use this_cpu_ptr() instead of
 per_cpu_ptr(smp_processor_id())
Message-ID: <20220905053550.ltovrnpu6tlxqje3@yy-desk-7060>
References: <cover.1662084396.git.isaku.yamahata@intel.com>
 <aadde2a7309b6267ab44cb205a00ba51f4ccdde7.1662084396.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aadde2a7309b6267ab44cb205a00ba51f4ccdde7.1662084396.git.isaku.yamahata@intel.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 01, 2022 at 07:17:37PM -0700, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> convert per_cpu_ptr(smp_processor_id()) to this_cpu_ptr() as trivial
> cleanup.

Reviewed-by: Yuan Yao <yuan.yao@intel.com>

>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Reviewed-by: Chao Gao <chao.gao@intel.com>
> ---
>  arch/x86/kvm/x86.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 0e200fe44b35..fd021581ca60 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -428,8 +428,7 @@ static void kvm_user_return_msr_init_cpu(struct kvm_user_return_msrs *msrs)
>
>  int kvm_set_user_return_msr(unsigned slot, u64 value, u64 mask)
>  {
> -	unsigned int cpu = smp_processor_id();
> -	struct kvm_user_return_msrs *msrs = per_cpu_ptr(user_return_msrs, cpu);
> +	struct kvm_user_return_msrs *msrs = this_cpu_ptr(user_return_msrs);
>  	int err;
>
>  	kvm_user_return_msr_init_cpu(msrs);
> @@ -453,8 +452,7 @@ EXPORT_SYMBOL_GPL(kvm_set_user_return_msr);
>
>  static void drop_user_return_notifiers(void)
>  {
> -	unsigned int cpu = smp_processor_id();
> -	struct kvm_user_return_msrs *msrs = per_cpu_ptr(user_return_msrs, cpu);
> +	struct kvm_user_return_msrs *msrs = this_cpu_ptr(user_return_msrs);
>
>  	if (msrs->registered)
>  		kvm_on_user_return(&msrs->urn);
> --
> 2.25.1
>
