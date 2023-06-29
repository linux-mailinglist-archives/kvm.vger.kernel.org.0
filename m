Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE8C57423D0
	for <lists+kvm@lfdr.de>; Thu, 29 Jun 2023 12:17:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231430AbjF2KQ6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jun 2023 06:16:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231834AbjF2KPu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jun 2023 06:15:50 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CCB63582;
        Thu, 29 Jun 2023 03:15:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688033730; x=1719569730;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=X08EZN+DaChxrUMPDyxcVgkqN2it75n3TMT5gy+uEis=;
  b=L5d3evnNqWGW76tiJqtGFD7voBsrSWu0SXiIO9ugJ9xls9PHvuLyK3No
   POgwlozs3TdTMDxFiS1PzRmKd+svLW5vvDzXemunWRBSuUQBUhb2KPray
   Ti8m1Y3M8E3mqjO9lh/iHZF/HPvaJ9XBEtffKIalDpogQfdgGTznUnRXv
   rE2MKl1n9W2LDaaFQH6X1CdrgsdR45o/PXIYOVqGACBpO0QU3mcn8w6QG
   PRxcVnWwBMWt7lmiCcEZDXw9161ryZDComIs+pQ3G/exrgz29/LADwdlU
   H3HebIwUV2gFydY8gVI1QbFCr1aha+9icVNO8XScxNC7oYClfLtiRGKv7
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10755"; a="448452077"
X-IronPort-AV: E=Sophos;i="6.01,168,1684825200"; 
   d="scan'208";a="448452077"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2023 03:15:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10755"; a="694569273"
X-IronPort-AV: E=Sophos;i="6.01,168,1684825200"; 
   d="scan'208";a="694569273"
Received: from aahouzi-mobl.ger.corp.intel.com (HELO box.shutemov.name) ([10.249.47.115])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2023 03:15:22 -0700
Received: by box.shutemov.name (Postfix, from userid 1000)
        id 29F1F1095C8; Thu, 29 Jun 2023 13:15:19 +0300 (+03)
Date:   Thu, 29 Jun 2023 13:15:19 +0300
From:   kirill.shutemov@linux.intel.com
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
        dave.hansen@intel.com, tony.luck@intel.com, tglx@linutronix.de,
        bp@alien8.de, mingo@redhat.com, hpa@zytor.com, seanjc@google.com,
        pbonzini@redhat.com, david@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, ashok.raj@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, ying.huang@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, nik.borisov@suse.com,
        bagasdotme@gmail.com, sagis@google.com, imammedo@redhat.com
Subject: Re: [PATCH v12 05/22] x86/virt/tdx: Add SEAMCALL infrastructure
Message-ID: <20230629101519.xhuia6d4gtiosesh@box.shutemov.name>
References: <cover.1687784645.git.kai.huang@intel.com>
 <b2a875fd855145728744617ac4425a06d8b46c90.1687784645.git.kai.huang@intel.com>
 <20230628125813.GA2438817@hirez.programming.kicks-ass.net>
 <20230628135436.GC2439977@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230628135436.GC2439977@hirez.programming.kicks-ass.net>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 28, 2023 at 03:54:36PM +0200, Peter Zijlstra wrote:
> On Wed, Jun 28, 2023 at 02:58:13PM +0200, Peter Zijlstra wrote:
> 
> > Can someone explain to me why __tdx_hypercall() is sane (per the above)
> > but then we grew __tdx_module_call() as an absolute abomination and are
> > apparently using that for seam too?
> 
> That is, why do we have two different TDCALL wrappers? Makes no sense.

__tdx_module_call() is the wrapper for TDCALL.

__tdx_hypercall() is the wrapper for TDG.VP.VMCALL leaf function of
TDCALL. The function is used often and it uses wider range or registers
comparing to the rest of the TDCALL functions.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov
