Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF41751D9B0
	for <lists+kvm@lfdr.de>; Fri,  6 May 2022 15:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1441937AbiEFOA6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 May 2022 10:00:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232255AbiEFOA4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 May 2022 10:00:56 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA225403FB;
        Fri,  6 May 2022 06:57:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651845433; x=1683381433;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=O1cQeAjasg1O4DhfO6/orc3h+WVxOjsEIKgORiuE2S0=;
  b=G0L9PcRmtEhJxEabRU6VDvQp1gZavZSSjZ8F5ubepmtioiPTvAk/9BoJ
   xFZlC9XjYIB1cquOFlYxaFrPArmoBlGjph3k7zvYYELAbGZPqVZYLloRT
   ViXMbXHDjpUaXgy6AS77pYONv1UdLy6kbXjlwVvLK3iyUiCftzjVbheZU
   vH6L/4xjLTbiQjm1PB6zEIj8uNQ0YzBH31E6Vn5+72Lvb+e2wWWY4l3hM
   0ZOaAqwvXIE/hMDfYoseAsjPZ9yZJg/BOGHuQDog8FjGYyB/D7X8pdJOV
   SRWvWdmnUGfVZI4YtZcVnwyaVXOMIIzVMN74kIsLu5zFk6eBlixeditda
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10339"; a="267309306"
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="267309306"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2022 06:57:13 -0700
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="585982664"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.249.169.36]) ([10.249.169.36])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2022 06:57:11 -0700
Message-ID: <c7c1f8d1-081a-d543-bdb4-6895292c7077@intel.com>
Date:   Fri, 6 May 2022 21:57:09 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.8.1
Subject: Re: [RFC PATCH v6 011/104] KVM: TDX: Initialize TDX module when
 loading kvm_intel.ko
Content-Language: en-US
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
References: <cover.1651774250.git.isaku.yamahata@intel.com>
 <752bc449e13cb3e6874ba2d82f790f6f6018813c.1651774250.git.isaku.yamahata@intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <752bc449e13cb3e6874ba2d82f790f6f6018813c.1651774250.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/6/2022 2:14 AM, isaku.yamahata@intel.com wrote:
> +int __init tdx_module_setup(void)
> +{
> +	const struct tdsysinfo_struct *tdsysinfo;
> +	int ret = 0;
> +
> +	BUILD_BUG_ON(sizeof(*tdsysinfo) != 1024);
> +	BUILD_BUG_ON(TDX_MAX_NR_CPUID_CONFIGS != 37);
> +
> +	ret = tdx_detect();
> +	if (ret) {
> +		pr_info("Failed to detect TDX module.\n");
> +		return ret;
> +	}
> +
> +	ret = tdx_init();
> +	if (ret) {
> +		pr_info("Failed to initialize TDX module.\n");
> +		return ret;
> +	}
> +
> +	tdsysinfo = tdx_get_sysinfo();
> +	if (tdx_caps.nr_cpuid_configs > TDX_MAX_NR_CPUID_CONFIGS)
> +		return -EIO;

It needs to check tdsysinfo->num_cpuid_config against 
TDX_MAX_NR_CPUID_CONFIG

or move the check down after tdx_caps is initialized.

> +	tdx_caps = (struct tdx_capabilities) {
> +		.tdcs_nr_pages = tdsysinfo->tdcs_base_size / PAGE_SIZE,
> +		/*
> +		 * TDVPS = TDVPR(4K page) + TDVPX(multiple 4K pages).
> +		 * -1 for TDVPR.
> +		 */
> +		.tdvpx_nr_pages = tdsysinfo->tdvps_base_size / PAGE_SIZE - 1,
> +		.attrs_fixed0 = tdsysinfo->attributes_fixed0,
> +		.attrs_fixed1 = tdsysinfo->attributes_fixed1,
> +		.xfam_fixed0 =	tdsysinfo->xfam_fixed0,
> +		.xfam_fixed1 = tdsysinfo->xfam_fixed1,
> +		.nr_cpuid_configs = tdsysinfo->num_cpuid_config,
> +	};
> +	if (!memcpy(tdx_caps.cpuid_configs, tdsysinfo->cpuid_configs,
> +			tdsysinfo->num_cpuid_config *
> +			sizeof(struct tdx_cpuid_config)))
> +		return -EIO;
> +
> +	return 0;
> +}

