Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDC72660B09
	for <lists+kvm@lfdr.de>; Sat,  7 Jan 2023 01:47:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236635AbjAGArE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Jan 2023 19:47:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236612AbjAGArC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Jan 2023 19:47:02 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0895E7B;
        Fri,  6 Jan 2023 16:47:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673052421; x=1704588421;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Kk1xFVbKS7sAQ5IQVZhgv/OVqCZqVfmRlO7PwuhRX6E=;
  b=J4XWy58uiFSWTHtqxV2ObfOIMvm2OYIjllKo/cyBj0dfOlJ6uLwRLKFK
   uWh9iuolb+8SY/6oz/x+lQqU3dnN0IaqyMPfQ8AXKWjt7D1ly27UtPY9s
   x0tr8Yph5qP1wUB3xkRR+lPW3tcv5Gx4KEDl5a3layWouo/QDu10wMa6+
   5RRhwDAgIFZ1KBjBnRi57CpDMTAGNpaK0KrBeGRcv3Ls/McuqUfIV4EwN
   GyCtIyv3TKj9YRliANH1ytBQpRqyDh2iPpW3uimYJfMFCtES4m+u7CJk8
   Hma6RCHB8QLl69eZYih8JyYC4CZgpOIUr4GOR/Tg1B5IeZBO4Ji6I7+1Q
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="302293164"
X-IronPort-AV: E=Sophos;i="5.96,306,1665471600"; 
   d="scan'208";a="302293164"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 16:47:01 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="830065883"
X-IronPort-AV: E=Sophos;i="5.96,306,1665471600"; 
   d="scan'208";a="830065883"
Received: from xiangyuy-mobl.amr.corp.intel.com (HELO [10.212.251.186]) ([10.212.251.186])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 16:47:00 -0800
Message-ID: <64381030-bdbd-bc98-45b3-e3d40132a309@intel.com>
Date:   Fri, 6 Jan 2023 16:47:00 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v8 10/16] x86/virt/tdx: Allocate and set up PAMTs for
 TDMRs
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
 <76a17c574da18c10ad7a4f96e010697aaa5f7c04.1670566861.git.kai.huang@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <76a17c574da18c10ad7a4f96e010697aaa5f7c04.1670566861.git.kai.huang@intel.com>
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
> @@ -574,6 +774,11 @@ static int init_tdx_module(void)
>  	 *  Return error before all steps are done.
>  	 */
>  	ret = -EINVAL;
> +	if (ret)
> +		tdmrs_free_pamt_all(&tdmr_list);
> +	else
> +		pr_info("%lu pages allocated for PAMT.\n",
> +				tdmrs_count_pamt_pages(&tdmr_list));

Could you please convert this to megabytes or kilobytes?  dmesg is for
humans and humans don't generally know how large their systems or DIMMs
are in pages without looking or grabbing a calculator.
