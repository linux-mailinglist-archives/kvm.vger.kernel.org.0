Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CC5572C8AD
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 16:35:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236015AbjFLOft (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 10:35:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235319AbjFLOfq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 10:35:46 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D920BAA;
        Mon, 12 Jun 2023 07:35:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686580536; x=1718116536;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=UV/2h6fqgbTSA+6nmz5EI6zXiJFLRye4hW68DS9EZqo=;
  b=HpbqCkok+pVDmwG7yB5/WvZDlqCwd/MyZibYrkmRhczsDhEde1vXxPHR
   fYmZbUmNAtQTJrBLZBbAqq/TrpOsa1iQewreRjw4mT05tLiaqHLJthAG5
   blNWWMYn3YEqaVcQFtXaHz4NQMDz4/+sOb+mBeJ/nIvGMH8bCBDn672xs
   MjD9FEzpzPp9VE2NsQ4if40msT/AnWDz1sUnf6Kivys/RFRRIeyJ6jsx0
   iudTq3t/aUDbdyzfO3aB5Jfdv2Ru1BNmUvfEKdFvURaqC6y6tSn7qJUDF
   Cw1Paqv2SWAoBzjcSGtP6pIdGWIliT3eWfH33+5LU3K62yBkyLHzqg+U1
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="338419480"
X-IronPort-AV: E=Sophos;i="6.00,236,1681196400"; 
   d="scan'208";a="338419480"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2023 07:34:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="711224041"
X-IronPort-AV: E=Sophos;i="6.00,236,1681196400"; 
   d="scan'208";a="711224041"
Received: from smizr3x-mobl3.ger.corp.intel.com (HELO box.shutemov.name) ([10.249.43.127])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2023 07:33:58 -0700
Received: by box.shutemov.name (Postfix, from userid 1000)
        id 3E33710CE1A; Mon, 12 Jun 2023 17:33:55 +0300 (+03)
Date:   Mon, 12 Jun 2023 17:33:55 +0300
From:   "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v11 11/20] x86/virt/tdx: Fill out TDMRs to cover all TDX
 memory regions
Message-ID: <20230612143355.sur7zc7byu7omxal@box.shutemov.name>
References: <cover.1685887183.git.kai.huang@intel.com>
 <927ec9871721d2a50f1aba7d1cf7c3be50e4f49b.1685887183.git.kai.huang@intel.com>
 <0600959d-9e10-fb1f-b3a9-862a51b9d8e1@intel.com>
 <ddbcadf36016bb60a695f54b28f5c9e9af53a07f.camel@intel.com>
 <201af662-f700-9145-c113-563e378074ad@intel.com>
 <89c99e7360dc2acfe5fb56c2bbb40e074e1f94d5.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <89c99e7360dc2acfe5fb56c2bbb40e074e1f94d5.camel@intel.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 12, 2023 at 02:33:58AM +0000, Huang, Kai wrote:
> 
> > 
> > Maybe not even a pr_warn(), but something that's a bit ominous and has a
> > chance of getting users to act.
> 
> Sorry I am not sure how to do.  Could you give some suggestion?

Maybe something like this would do?

I'm struggle with the warning message. Any suggestion is welcome.

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 9cd4f6b58d4a..cc141025b249 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -627,6 +627,15 @@ static int fill_out_tdmrs(struct list_head *tmb_list,
 	/* @tdmr_idx is always the index of last valid TDMR. */
 	tdmr_list->nr_consumed_tdmrs = tdmr_idx + 1;
 
+	/*
+	 * Warn early that kernel is about to run out of TDMRs.
+	 *
+	 * This is indication that TDMR allocation has to be reworked to be
+	 * smarter to not run into an issue.
+	 */
+	if (tdmr_list->max_tdmrs - tdmr_list->nr_consumed_tdmrs < TDMR_NR_WARN)
+		pr_warn("Low number of spare TDMRs\n");
+
 	return 0;
 }
 
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 323ce744b853..17efe33847ae 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -98,6 +98,9 @@ struct tdx_memblock {
 	int nid;
 };
 
+/* Warn if kernel has less than TDMR_NR_WARN TDMRs after allocation */
+#define TDMR_NR_WARN 4
+
 struct tdmr_info_list {
 	void *tdmrs;	/* Flexible array to hold 'tdmr_info's */
 	int nr_consumed_tdmrs;	/* How many 'tdmr_info's are in use */
-- 
  Kiryl Shutsemau / Kirill A. Shutemov
