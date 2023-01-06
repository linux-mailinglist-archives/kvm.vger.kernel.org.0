Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 384BC660560
	for <lists+kvm@lfdr.de>; Fri,  6 Jan 2023 18:13:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235050AbjAFRNi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Jan 2023 12:13:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234196AbjAFRNe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Jan 2023 12:13:34 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1741EF57;
        Fri,  6 Jan 2023 09:13:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673025213; x=1704561213;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=PjSGJBiSMHpIgIDZUStzyl407tlADmMulGEemYnHX1E=;
  b=mYSE19ryOgSZ+c2LYpQJ8DEpZf6GerHtjAIW3JgLVhTeDDUzARMYCJES
   z1DieVcgS3gg/trsK0xaK9eIQFBAStn+q5k6FK/38aFb6C6T4B9DfR0AC
   xTA/Hl4PYDKFvTJUzgGtkLlSzY43lIjHvDMKW+5D1Y3P1sGzqCnZOpQLE
   d4vqNHFrxDIYucr/9DsZTjgJM9NYui9UpPyaIsbco4yPTvT0SIJTDGX83
   kZ1K2WLyN1LXNsx5u2oEyIJlN4nQ1JxcNwEzXhnK5srLwip06Py9MhM3C
   lAr48N5LLLiKBGXasxWl3tGp7WwkxNjQYR2sX8uJjqrerhse0Cf8PPRPP
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="302215876"
X-IronPort-AV: E=Sophos;i="5.96,305,1665471600"; 
   d="scan'208";a="302215876"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 09:09:50 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="984724476"
X-IronPort-AV: E=Sophos;i="5.96,305,1665471600"; 
   d="scan'208";a="984724476"
Received: from xiangyuy-mobl.amr.corp.intel.com (HELO [10.212.251.186]) ([10.212.251.186])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 09:09:49 -0800
Message-ID: <426c6483-d10a-27f4-abc1-55de1f3b1356@intel.com>
Date:   Fri, 6 Jan 2023 09:09:48 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v8 02/16] x86/virt/tdx: Detect TDX during kernel boot
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, peterz@infradead.org, tglx@linutronix.de,
        seanjc@google.com, pbonzini@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, kirill.shutemov@linux.intel.com,
        ying.huang@intel.com, reinette.chatre@intel.com,
        len.brown@intel.com, tony.luck@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com
References: <cover.1670566861.git.kai.huang@intel.com>
 <75317b5b6f29e77b98455b0401bd903964f50814.1670566861.git.kai.huang@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <75317b5b6f29e77b98455b0401bd903964f50814.1670566861.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/8/22 22:52, Kai Huang wrote:
> +++ b/arch/x86/virt/vmx/tdx/tdx.h
> @@ -0,0 +1,15 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _X86_VIRT_TDX_H
> +#define _X86_VIRT_TDX_H
> +
> +/*
> + * This file contains both macros and data structures defined by the TDX
> + * architecture and Linux defined software data structures and functions.
> + * The two should not be mixed together for better readability.  The
> + * architectural definitions come first.
> + */
> +
> +/* MSR to report KeyID partitioning between MKTME and TDX */
> +#define MSR_IA32_MKTME_KEYID_PARTITIONING	0x00000087

The *VAST* majority of MSR definitions are in msr-index.h.

Why is this one different from the norm?
