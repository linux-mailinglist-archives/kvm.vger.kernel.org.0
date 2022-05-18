Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49A5752C836
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 01:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231389AbiERX5H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 19:57:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231132AbiERX5E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 19:57:04 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B13C8A205F;
        Wed, 18 May 2022 16:56:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652918219; x=1684454219;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sYnBWBRsHWJ/CxGScUq9f0aZZYV853hQS0dqrvcFiLM=;
  b=GjfPgl4BKfE7EJcB8jvLb1bkSfE6TdRgs0eKIwCSAvHUr7K5kQ9QLae0
   Iaz0zdAv0OFI+Ag0+ogi1V2udrWLjQM/RAe+ZNEuQ82wtG2hvTN935rZK
   PqEAqjN+Kml9Lm3V/5xHqxuDUyiY8HsZSuN8spf1gEf3mfMJnhmWfyXMc
   u3CJa1T5NzI9LfwKQWl3PTEJ/U86Ji4QJZqOMQKGI2yjGz+Bqc4KNhb1b
   doLQH7vNTLSktbRR7/mvKeL51T5meoTzRuXtyCm22sXpwdvM83UEJjq7/
   CLP8cyDTpswAFU27u3+PMHyL8J77IiF7q9RefcB4aPyQw9MKVFEZY0iEa
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10351"; a="334990901"
X-IronPort-AV: E=Sophos;i="5.91,235,1647327600"; 
   d="scan'208";a="334990901"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2022 16:56:59 -0700
X-IronPort-AV: E=Sophos;i="5.91,235,1647327600"; 
   d="scan'208";a="700864699"
Received: from ppamkunt-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.33.252])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2022 16:56:55 -0700
Message-ID: <1e880953645d966a9869531409e1296c2ae234f9.camel@intel.com>
Subject: Re: [PATCH v3 09/21] x86/virt/tdx: Get information about TDX module
 and convertible memory
From:   Kai Huang <kai.huang@intel.com>
To:     Sagi Shahar <sagis@google.com>
Cc:     Dave Hansen <dave.hansen@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, len.brown@intel.com,
        tony.luck@intel.com, rafael.j.wysocki@intel.com,
        reinette.chatre@intel.com, dan.j.williams@intel.com,
        peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
Date:   Thu, 19 May 2022 11:56:53 +1200
In-Reply-To: <CAAhR5DGNGJ=MAMPOsbZ2jEOEXG_vR69L77ks4ihMUhixPTuXLA@mail.gmail.com>
References: <cover.1649219184.git.kai.huang@intel.com>
         <145620795852bf24ba2124a3f8234fd4aaac19d4.1649219184.git.kai.huang@intel.com>
         <f929fb7a-5bdc-2567-77aa-762a098c8513@intel.com>
         <0bab7221179229317a11311386c968bd0d40e344.camel@intel.com>
         <CAAhR5DGNGJ=MAMPOsbZ2jEOEXG_vR69L77ks4ihMUhixPTuXLA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-05-18 at 15:30 -0700, Sagi Shahar wrote:
> > > 
> > > > +   pr_info("TDX module: vendor_id 0x%x, major_version %u, minor_version
> > > > %u, build_date %u, build_num %u",
> > > > +           tdx_sysinfo.vendor_id, tdx_sysinfo.major_version,
> > > > +           tdx_sysinfo.minor_version, tdx_sysinfo.build_date,
> > > > +           tdx_sysinfo.build_num);
> > > > +
> > > > +   /* Print BIOS provided CMRs */
> > > > +   print_cmrs(tdx_cmr_array, cmr_num, "BIOS-CMR");
> > > > +
> 
> sanitize_cmrs already prints the cmrs in case of success. So for valid
> cmrs we are going to print them twice.
> Would it be better to only print cmrs here in case sanitize_cmrs fails?

The "BIOS-CMR" will always have 32 entries.  It includes all the *empty* CMRs
after the valid CMRs, so the two are different.  But yes it seems there's no
need to always print "BIOS-CMR".


-- 
Thanks,
-Kai


