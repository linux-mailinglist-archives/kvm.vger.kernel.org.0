Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A936B73F91F
	for <lists+kvm@lfdr.de>; Tue, 27 Jun 2023 11:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231698AbjF0Jx1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 05:53:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231805AbjF0Jwn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 05:52:43 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 037722958;
        Tue, 27 Jun 2023 02:52:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687859544; x=1719395544;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=eMQjSnWISAaYo3C4cvXdou1DofAukXurvqYsZXMKRUs=;
  b=OrBdq7EmQonnfTh+2fj9J+QlBt8/rLpNwaLGxy6bxvTMZ8PWpdaMPJx+
   nx5Tdh+vt8Gi/HdUECsVPpA43mn5NovQFyO6xDdt8hGzYZ3rsxQP0pk1Y
   58OHaxCedT1ZnMzKgh1jAuwwcQmdFIzACPPsW5ioT7areQrp5FsQqdxgg
   zGd56TF20R4tXexxIoARhEc/VHG4Deo/rYNvCc7Lv93JnvHR8yrtJmG3p
   Zjt1mxanqvnWQ0HezhSUeXQAtnSrm8/oeBQosrSLbwg2Wis+BWzrUHxZ2
   eZtR7RaAIfvyrIrCy8SnN2m1c4+X2KnmtG1X/IYmwjTS8YDARHwBaKRS8
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10753"; a="427528589"
X-IronPort-AV: E=Sophos;i="6.01,162,1684825200"; 
   d="scan'208";a="427528589"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2023 02:51:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10753"; a="781794199"
X-IronPort-AV: E=Sophos;i="6.01,162,1684825200"; 
   d="scan'208";a="781794199"
Received: from rbhaumik-mobl2.ger.corp.intel.com (HELO box.shutemov.name) ([10.251.217.121])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2023 02:51:27 -0700
Received: by box.shutemov.name (Postfix, from userid 1000)
        id D2229103732; Tue, 27 Jun 2023 12:51:24 +0300 (+03)
Date:   Tue, 27 Jun 2023 12:51:24 +0300
From:   kirill.shutemov@linux.intel.com
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, x86@kernel.org, dave.hansen@intel.com,
        tony.luck@intel.com, peterz@infradead.org, tglx@linutronix.de,
        bp@alien8.de, mingo@redhat.com, hpa@zytor.com, seanjc@google.com,
        pbonzini@redhat.com, david@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, ashok.raj@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, ying.huang@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, nik.borisov@suse.com,
        bagasdotme@gmail.com, sagis@google.com, imammedo@redhat.com
Subject: Re: [PATCH v12 08/22] x86/virt/tdx: Get information about TDX module
 and TDX-capable memory
Message-ID: <20230627095124.nhiypr6ivi4kdfrw@box.shutemov.name>
References: <cover.1687784645.git.kai.huang@intel.com>
 <a33f372df345f6232b55e26d498ea67d4adc18f0.1687784645.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a33f372df345f6232b55e26d498ea67d4adc18f0.1687784645.git.kai.huang@intel.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 27, 2023 at 02:12:38AM +1200, Kai Huang wrote:
>  static int init_tdx_module(void)
>  {
> +	struct tdsysinfo_struct *sysinfo;
> +	struct cmr_info *cmr_array;
> +	int ret;
> +
> +	/*
> +	 * Get the TDSYSINFO_STRUCT and CMRs from the TDX module.
> +	 *
> +	 * The buffers of the TDSYSINFO_STRUCT and the CMR array passed
> +	 * to the TDX module must be 1024-bytes and 512-bytes aligned
> +	 * respectively.  Allocate one page to accommodate them both and
> +	 * also meet those alignment requirements.
> +	 */
> +	sysinfo = (struct tdsysinfo_struct *)__get_free_page(GFP_KERNEL);
> +	if (!sysinfo)
> +		return -ENOMEM;
> +	cmr_array = (struct cmr_info *)((unsigned long)sysinfo + PAGE_SIZE / 2);
> +
> +	BUILD_BUG_ON(PAGE_SIZE / 2 < TDSYSINFO_STRUCT_SIZE);
> +	BUILD_BUG_ON(PAGE_SIZE / 2 < sizeof(struct cmr_info) * MAX_CMRS);

This works, but why not just use slab for this? kmalloc has 512 and 1024
pools already and you won't waste memory for rounding up.

Something like this:

        sysinfo = kmalloc(TDSYSINFO_STRUCT_SIZE, GFP_KERNEL);
        if (!sysinfo)
                return -ENOMEM;

        cmr_array_size = sizeof(struct cmr_info) * MAX_CMRS;

        /* CMR array has to be 512-aligned */
        cmr_array_size = round_up(cmr_array_size, 512);

        cmr_array = kmalloc(cmr_array_size, GFP_KERNEL);
        if (!cmr_array) {
                kfree(sysinfo);
                return -ENOMEM;
        }

?

-- 
  Kiryl Shutsemau / Kirill A. Shutemov
