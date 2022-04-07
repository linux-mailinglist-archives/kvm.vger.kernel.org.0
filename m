Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F047B4F7216
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 04:30:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239126AbiDGCc0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 22:32:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231925AbiDGCcV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 22:32:21 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A36001F976F;
        Wed,  6 Apr 2022 19:30:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649298622; x=1680834622;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3IwYZPATgkappCyO7E3fAkypHvxH0ctVxZsQ7qKYG8g=;
  b=L6Xqj/b6Xr5Nohvye9I30Ge52wO6s0gN6oA2CPZA3zeadLpdagbwpARC
   juaEv5oiSUzuvELGlZwwd9TCpR+cGodanLuATGefMHvFPjUqIA8egHZ65
   AA+m6NuFxbkmDkpGHo5n/yj5+AIsMuyaHo/9UmktfyaYnW2cxWPHEPBGA
   8rPd1C3Qn/y8I8wVNxJEZWEUDNUd/gdkzr7thvKlaCIdK0O/Csg8FHjNn
   XoI6PgLVS/F+Er62AYgqyNES+v8xrgwxJOPjZegwvSM12+tJSVTYgXQD2
   RpxZlgJlISUm3Sps6tGT8TlTTVH2FdILvMrzeKG5rRSjJN8ZtJUsmi5i3
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10309"; a="241802742"
X-IronPort-AV: E=Sophos;i="5.90,241,1643702400"; 
   d="scan'208";a="241802742"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2022 19:30:22 -0700
X-IronPort-AV: E=Sophos;i="5.90,241,1643702400"; 
   d="scan'208";a="642303315"
Received: from mgailhax-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.55.23])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2022 19:30:20 -0700
Message-ID: <7749a232f617a5474f1c362935ec459418e678a5.camel@intel.com>
Subject: Re: [RFC PATCH v5 060/104] KVM: TDX: Create initial guest memory
From:   Kai Huang <kai.huang@intel.com>
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Date:   Thu, 07 Apr 2022 14:30:18 +1200
In-Reply-To: <676ece0bb9acb3bdc66c969c0f33520abbc1c265.1646422845.git.isaku.yamahata@intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
         <676ece0bb9acb3bdc66c969c0f33520abbc1c265.1646422845.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-03-04 at 11:49 -0800, isaku.yamahata@intel.com wrote:
> +	/*
> +	 * In case of TDP MMU, fault handler can run concurrently.  Note
> +	 * 'source_pa' is a TD scope variable, meaning if there are multiple
> +	 * threads reaching here with all needing to access 'source_pa', it
> +	 * will break.  However fortunately this won't happen, because below
> +	 * TDH_MEM_PAGE_ADD code path is only used when VM is being created
> +	 * before it is running, using KVM_TDX_INIT_MEM_REGION ioctl (which
> +	 * always uses vcpu 0's page table and protected by vcpu->mutex).
> +	 */
> +	WARN_ON(kvm_tdx->source_pa == INVALID_PAGE);

We can just KVM_BUG_ON() and return here.

> +	source_pa = kvm_tdx->source_pa & ~KVM_TDX_MEASURE_MEMORY_REGION;
> +
> +	err = tdh_mem_page_add(kvm_tdx->tdr.pa, gpa, hpa, source_pa, &out);
> +	if (KVM_BUG_ON(err, kvm))
> +		pr_tdx_error(TDH_MEM_PAGE_ADD, err, &out);
> +	else if ((kvm_tdx->source_pa & KVM_TDX_MEASURE_MEMORY_REGION))
> +		tdx_measure_page(kvm_tdx, gpa);
> +
> +	kvm_tdx->source_pa = INVALID_PAGE;

