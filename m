Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BE867263B4
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 17:08:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240908AbjFGPIq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 11:08:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240435AbjFGPIo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 11:08:44 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B1CD1720;
        Wed,  7 Jun 2023 08:08:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686150524; x=1717686524;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=6TdsUePGYVEjerNbgyfVc3Eki0F3cK61GqMEgDDK4l4=;
  b=a3UCvWa9kw0T5727lu0LsLQ+vrkHB5uQuWbP4o/92sZBYNLwgGCAlepd
   hnEp0hFTj1MNdl6LEYf4zqQg83UjgIr4AlQEC2EC/0HS1MXyYNaNmgV+p
   UlSNV6qTTtc5RjzjhGgwdmm7SOEZWLpoBsTBhc5vC2/76t8TbFbeZ9SMw
   njSBwqeVEycPyA7DAJ6g0Flr9ZwK0Le4li2kDKEnhv5F0nfSM1C+fNY7h
   vrwfi/j0DO4ksQU4nPRISkeFVqx4xOF24g9JaeIGNV3jyVVv8FnSt95bD
   sNL41x/69yFM9IOww/GU2l5rxw6ucY8W2CXnUjcMOH5QwQLqe88X+06uh
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="443381443"
X-IronPort-AV: E=Sophos;i="6.00,224,1681196400"; 
   d="scan'208";a="443381443"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2023 08:06:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="883838935"
X-IronPort-AV: E=Sophos;i="6.00,224,1681196400"; 
   d="scan'208";a="883838935"
Received: from akuporos-mobl.ger.corp.intel.com (HELO box.shutemov.name) ([10.251.211.72])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2023 08:06:37 -0700
Received: by box.shutemov.name (Postfix, from userid 1000)
        id C2CEA10F0E0; Wed,  7 Jun 2023 18:06:34 +0300 (+03)
Date:   Wed, 7 Jun 2023 18:06:34 +0300
From:   "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v11 04/20] x86/cpu: Detect TDX partial write machine
 check erratum
Message-ID: <20230607150634.te5u2q5tlwuyni37@box.shutemov.name>
References: <cover.1685887183.git.kai.huang@intel.com>
 <86f2a8814240f4bbe850f6a09fc9d0b934979d1b.1685887183.git.kai.huang@intel.com>
 <20230606123821.exit7gyxs42dxotz@box.shutemov.name>
 <4e9acea6b956e1fb83b4e49fc8d154295e321f29.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e9acea6b956e1fb83b4e49fc8d154295e321f29.camel@intel.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 06, 2023 at 10:58:04PM +0000, Huang, Kai wrote:
> So it seems there's no hard rule that all bugs need to be done in
> cpu_set_bug_bits().

Yes, CPU identify is a mess, but initcall makes it worse. Initcall is lazy
way out that contributes to the mess. Maybe cpu_set_bug_bits() is the
wrong place, find the right one.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov
