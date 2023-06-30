Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32AEF743E83
	for <lists+kvm@lfdr.de>; Fri, 30 Jun 2023 17:18:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232682AbjF3PSv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jun 2023 11:18:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232402AbjF3PSc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jun 2023 11:18:32 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2541A469B;
        Fri, 30 Jun 2023 08:17:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688138267; x=1719674267;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=vNkj93/5Q0qPJqdsxO49mwhsALqQK4kXJEFlJaSNhnE=;
  b=S18uEx3lk1G0nR2kIoaSVGv25QB6PwuweY4F3PAx1bb55zJxQcD85+Kz
   VSNQkwDWkccXwVBeKG4qIFeFpNh6xe10oINPOzluuMZVDzabwCL9bGDcu
   oW+LhTYKpVwuXXyad4klg1NeonOZbEQHjY2dnNtgB69G0UkDGFSkS8wEy
   qDWYH19KN4fT2+4dh99cbl/b11C9oVXYGwOLa8/xCXMJ8eJzZ10QwSa7n
   gG5vSh8zrlQSZyyeg9+/2XHTJPaVkUkcEypIUFrTaKdW0pPI0mFSlE2Vv
   REUExvMMqNov/O3WSqSfZ/VGXBrd4gO6aCo07c2w0xBX/RLRN46XdaOhX
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10757"; a="448793795"
X-IronPort-AV: E=Sophos;i="6.01,171,1684825200"; 
   d="scan'208";a="448793795"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2023 08:16:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10757"; a="747455463"
X-IronPort-AV: E=Sophos;i="6.01,171,1684825200"; 
   d="scan'208";a="747455463"
Received: from amuruge1-mobl.amr.corp.intel.com (HELO [10.252.133.96]) ([10.252.133.96])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2023 08:16:51 -0700
Message-ID: <1121357f-93ad-9016-36be-8bc34c256b16@intel.com>
Date:   Fri, 30 Jun 2023 08:16:50 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v12 20/22] x86/virt/tdx: Allow SEAMCALL to handle #UD and
 #GP
Content-Language: en-US
To:     "Huang, Kai" <kai.huang@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "hpa@zytor.com" <hpa@zytor.com>, "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "x86@kernel.org" <x86@kernel.org>
References: <cover.1687784645.git.kai.huang@intel.com>
 <c124550719716f1f7759c2bdea70f4722d8e0167.1687784645.git.kai.huang@intel.com>
 <20230628152900.GI2438817@hirez.programming.kicks-ass.net>
 <20230628203823.GR38236@hirez.programming.kicks-ass.net>
 <42e13ccf7f27a68c0dd64640eed378c38ef40967.camel@intel.com>
 <20230630100659.GF2533791@hirez.programming.kicks-ass.net>
 <88de636ed40786f40c153b392070357f8b3d6948.camel@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <88de636ed40786f40c153b392070357f8b3d6948.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/30/23 03:18, Huang, Kai wrote:
>> Please, because 12,14 are callee-saved, which means we need to go add
>> push/pop to preserve them 🙁
> Yes.
> 
> However those new SEAMCALLs are for TDX guest live migration support,  which is
> at a year(s)-later thing from upstreaming's point of view.  My thinking is we
> can defer supporting those new SEAMCALls until that phase.  Yes we need to do
> some assembly change at that time, but also looks fine to me.
> 
> How does this sound?

It would sound better if the TDX module folks would take that year to
fix the module and make it nicer for Linux. :)
