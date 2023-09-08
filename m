Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98951798AB0
	for <lists+kvm@lfdr.de>; Fri,  8 Sep 2023 18:31:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242100AbjIHQbv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Sep 2023 12:31:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231976AbjIHQbv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Sep 2023 12:31:51 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 671E91739;
        Fri,  8 Sep 2023 09:31:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694190707; x=1725726707;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=1irE0Oh6SvrG7SeE6HAy9wbfWNk4Gkba/izCnIEjgtw=;
  b=fvOEEaqblnVpWlzqG6HaHbfjepV2FzvluWI7BTwu6vrKXffStd5JnCNf
   2Y5i19F0JZ5w1m2/d5md7eBI6Io6uwQPtA20hqmk6MISrlSIuzqiAqGEQ
   pPNtf9WmTfniCzyGOC6uP8obSzzChwzolrbXAjvaTWJoliLj+g1xYB/dA
   OKJ5HjwdMi9bkBMayJr3qdcoNaNXyPAAo5RuQJcM712ecPUy7XqXwi65h
   f0g2Ab733uhRhgC2nq6/uHFLpnYIdFF387OdPvcQ1VdOs7W9BCOxtVlBk
   ytXALbzdnUTkhg5aVs2WBs58A/DF8hfri1IFr51cAtIn1soF0BU16bpLK
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10827"; a="441702596"
X-IronPort-AV: E=Sophos;i="6.02,237,1688454000"; 
   d="scan'208";a="441702596"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2023 09:31:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10827"; a="812626925"
X-IronPort-AV: E=Sophos;i="6.02,237,1688454000"; 
   d="scan'208";a="812626925"
Received: from fgilganx-mobl1.amr.corp.intel.com (HELO [10.209.17.195]) ([10.209.17.195])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2023 09:31:45 -0700
Message-ID: <2f30d181-0747-cd7d-be6a-f19dcd1674f6@intel.com>
Date:   Fri, 8 Sep 2023 09:31:44 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
Subject: Re: [PATCH v13 06/22] x86/virt/tdx: Add SEAMCALL error printing for
 module initialization
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     x86@kernel.org, kirill.shutemov@linux.intel.com,
        tony.luck@intel.com, peterz@infradead.org, tglx@linutronix.de,
        bp@alien8.de, mingo@redhat.com, hpa@zytor.com, seanjc@google.com,
        pbonzini@redhat.com, david@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, ashok.raj@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, ying.huang@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, nik.borisov@suse.com,
        bagasdotme@gmail.com, sagis@google.com, imammedo@redhat.com
References: <cover.1692962263.git.kai.huang@intel.com>
 <3b9ddfb377a944393b2a93f963cd902232a5ee33.1692962263.git.kai.huang@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <3b9ddfb377a944393b2a93f963cd902232a5ee33.1692962263.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/25/23 05:14, Kai Huang wrote:
> +#define SEAMCALL_PRERR(__seamcall_func, __fn, __args, __seamcall_err_func)	\
> +({										\
> +	u64 ___sret = __SEAMCALL_PRERR(__seamcall_func, __fn, __args,		\
> +			__seamcall_err_func, pr_err);				\
> +	int ___ret;								\
> +										\
> +	switch (___sret) {							\
> +	case TDX_SUCCESS:							\
> +		___ret = 0;							\
> +		break;								\
> +	case TDX_SEAMCALL_VMFAILINVALID:					\
> +		pr_err("SEAMCALL failed: TDX module not loaded.\n");		\
> +		___ret = -ENODEV;						\
> +		break;								\
> +	case TDX_SEAMCALL_GP:							\
> +		pr_err("SEAMCALL failed: TDX disabled by BIOS.\n");		\
> +		___ret = -EOPNOTSUPP;						\
> +		break;								\
> +	case TDX_SEAMCALL_UD:							\
> +		pr_err("SEAMCALL failed: CPU not in VMX operation.\n");		\
> +		___ret = -EACCES;						\
> +		break;								\
> +	default:								\
> +		___ret = -EIO;							\
> +	}									\
> +	___ret;									\
> +})

I have no clue where all of this came from or why it is necessary or why
it has to be macros.  I'm just utterly confused.

I was really hoping to be able to run through this set and get it ready
to be merged.  But it seems to still be seeing a *LOT* of change.
Should I wait another few weeks for this to settle down again?
