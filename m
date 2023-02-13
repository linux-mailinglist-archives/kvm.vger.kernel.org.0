Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C4D2694E89
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 18:59:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbjBMR7c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 12:59:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230310AbjBMR7a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 12:59:30 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BCC7166F1;
        Mon, 13 Feb 2023 09:59:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676311161; x=1707847161;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=1sRRCU82GzDMVMojlElBVvdgoOoAuSY3zojW+48EiX8=;
  b=f71gownP4PgphUGixOHIzz2K0vXYcI8Q7v2E/sTgwUXj9u6Cq9fTmpdT
   VsDfKd9jgheQEcxfQLHgFZK4Bn6nc7Dnplg4a2bfRI8EVTJ/Su/aThIG1
   /h27lgFnmH3uQGrIGMjmv0Rsx6s/5eXoeNqp3Ult6VLekTMXElPUoXlUo
   gItFgqbV9JpmWtVoO30cP0Tkau/VRfqJYcyXiSwyqPVteZPa0QpYyjY57
   mqtnut8xho2qcRZwUYgpy3M70WFWCghyJnDi4VF/wke7+uscnUwLAFs5A
   l/bW0Ifedz849ynEDKxD9aR2VwIXzkqUkDc8WQBUA9idts/E4SoJHaPq1
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="328657963"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="328657963"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 09:59:19 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="811686102"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="811686102"
Received: from mlswanso-mobl.amr.corp.intel.com (HELO [10.251.26.232]) ([10.251.26.232])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 09:59:17 -0800
Message-ID: <86a8fe2f-566a-d0b9-7a22-9b41c91796f8@intel.com>
Date:   Mon, 13 Feb 2023 09:59:17 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v9 07/18] x86/virt/tdx: Do TDX module per-cpu
 initialization
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, peterz@infradead.org, tglx@linutronix.de,
        seanjc@google.com, pbonzini@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, kirill.shutemov@linux.intel.com,
        ying.huang@intel.com, reinette.chatre@intel.com,
        len.brown@intel.com, tony.luck@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, david@redhat.com,
        bagasdotme@gmail.com, sagis@google.com, imammedo@redhat.com
References: <cover.1676286526.git.kai.huang@intel.com>
 <557c526a1190903d11d67c4e2c76e01f67f6eb15.1676286526.git.kai.huang@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <557c526a1190903d11d67c4e2c76e01f67f6eb15.1676286526.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/13/23 03:59, Kai Huang wrote:
> To avoid duplicated code, add a
> helper to call SEAMCALL on all online cpus one by one but with a skip
> function to check whether to skip certain cpus, and use that helper to
> do the per-cpu initialization.
...
> +/*
> + * Call @func on all online cpus one by one but skip those cpus
> + * when @skip_func is valid and returns true for them.
> + */
> +static int tdx_on_each_cpu_cond(int (*func)(void *), void *func_data,
> +				bool (*skip_func)(int cpu, void *),
> +				void *skip_data)

I only see one caller of this.  Where is the duplicated code?
