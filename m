Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AC8863CA8F
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 22:41:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236641AbiK2VlN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 16:41:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233312AbiK2VlL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 16:41:11 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E37F36153D;
        Tue, 29 Nov 2022 13:41:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669758069; x=1701294069;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=H6tFVx8YFjtrsgdtfWkCGSXF6RRdlIaHy4IaUji1afk=;
  b=HmiGvt1gimf6ExTwmEFjFmBYmeAkNnUMelYukCxCCT1odTfHQHWkdh+1
   iq9VZn5UvpKZ3ItRwe2Mg2KtnbIDQHMjxPKcBk7zGlAe8ZcMU2vuoPfdA
   JO6r/SVLoA1PnLiaN380kxu/mBjYo36XNWegtvkNmx1lkxviys3JDKvW+
   oATSNjk+ayk1rAY/S/b58W8bCg238m1KZcCMaYzhAUDNaGI/l+hbQVCce
   RTos1vI7fNgL1k2GIamdDRlcJeXs3GHE9K3Ro/aNFmG4Wu/sQMwFEV4ME
   +UxrG85Yxtk4GHpoDilSQ/EV85qu1f/ocjDuhuGpHpncRXGJhrtPmXVNh
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10546"; a="379521175"
X-IronPort-AV: E=Sophos;i="5.96,204,1665471600"; 
   d="scan'208";a="379521175"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Nov 2022 13:40:56 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10546"; a="637757920"
X-IronPort-AV: E=Sophos;i="5.96,204,1665471600"; 
   d="scan'208";a="637757920"
Received: from wteng-mobl1.gar.corp.intel.com (HELO [10.209.83.194]) ([10.209.83.194])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Nov 2022 13:40:56 -0800
Message-ID: <f3826824-3ce6-4317-bc43-e327da2d4417@intel.com>
Date:   Tue, 29 Nov 2022 13:40:55 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v7 06/20] x86/virt/tdx: Shut down TDX module in case of
 error
Content-Language: en-US
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org, seanjc@google.com,
        pbonzini@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, kirill.shutemov@linux.intel.com,
        ying.huang@intel.com, reinette.chatre@intel.com,
        len.brown@intel.com, tony.luck@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com
References: <cover.1668988357.git.kai.huang@intel.com>
 <48505089b645019a734d85c2c29f3c8ae2dbd6bd.1668988357.git.kai.huang@intel.com>
 <Y3ySxEr64HkUaEDq@hirez.programming.kicks-ass.net>
 <52b2be9b-defd-63ce-4cb2-96cd624a95a6@intel.com>
 <Y30fUS5/JClpBHVc@hirez.programming.kicks-ass.net>
 <b3938f3a-e4f8-675a-0c0e-4b4618019145@intel.com>
 <Y30j/EJ9Y1/gWcXo@hirez.programming.kicks-ass.net>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <Y30j/EJ9Y1/gWcXo@hirez.programming.kicks-ass.net>
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

On 11/22/22 11:33, Peter Zijlstra wrote:
> On Tue, Nov 22, 2022 at 11:24:48AM -0800, Dave Hansen wrote:
>>> Not intialize TDX on busy NOHZ_FULL cpus and hard-limit the cpumask of
>>> all TDX using tasks.
>> I don't think that works.  As I mentioned to Thomas elsewhere, you don't
>> just need to initialize TDX on the CPUs where it is used.  Before the
>> module will start working you need to initialize it on *all* the CPUs it
>> knows about.  The module itself has a little counter where it tracks
>> this and will refuse to start being useful until it gets called
>> thoroughly enough.
> That's bloody terrible, that is. How are we going to make that work with
> the SMT mitigation crud that forces the SMT sibilng offline?
> 
> Then the counters don't match and TDX won't work.
> 
> Can we get this limitiation removed and simply let the module throw a
> wobbly (error) when someone tries and use TDX without that logical CPU
> having been properly initialized?

It sounds like we can at least punt the limitation away from the OS's
purview.

There's actually a multi-step process to get a "real" TDX module loaded.
 There's a fancy ACM (Authenticated Code Module) that's invoked via
GETSEC[ENTERACCS] and an intermediate module loader.  That dance used to
be done in the kernel, but we talked the BIOS guys into doing it instead.

I believe these per-logical-CPU checks _can_ also be punted out of the
TDX module itself and delegated to one of these earlier module loading
phases that the BIOS drives.

I'm still a _bit_ skeptical that the checks are needed in the first
place.  But, as long as they're hidden from the OS, I don't see a need
to be too cranky about it.

In the end, we could just plain stop doing the TDH.SYS.LP.INIT code in
the kernel.

Unless someone screams, I'll ask the BIOS and TDX module folks to look
into this.
