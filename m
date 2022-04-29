Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0504E513F82
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 02:26:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350379AbiD2A34 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 20:29:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237176AbiD2A3y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 20:29:54 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55968388E;
        Thu, 28 Apr 2022 17:26:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651191998; x=1682727998;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=nIphI1y/pUQiwKzsJVZayDhDq8pwIDE4wCOjF7ZG5F8=;
  b=DPLK95Aw+In8YSMk5qd1TDv47qDK+fsw1wX78ac6xaMYcBRjCGb7VMTR
   R2Xf/uYdEY7MhmdlF0RlDcLsoVEG/1Tmpsz8jK3p4xVLvYJQ7ZChAfcRn
   nEif5p0tyyjqMGyIBME4+LoLW63c41E3HnHahhZyBxw9VvBaZ8O39C6Vt
   86aL7R+d+B8pABPe5eXdSKrz630loAwv2DfgZdC0NqyX7Vn7BsunYsmfg
   w2n7ljFdZR8wQgpoECUPdZgBfa4nwlM/jMv2vGe+EuOmwn3xqEPhEvtJN
   aO3ZOhjcNiBVc8wWhSqCZIU/elX7iA4ujZzcPDzeymBuv7bjBDLI/g6Nw
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10331"; a="253858761"
X-IronPort-AV: E=Sophos;i="5.91,296,1647327600"; 
   d="scan'208";a="253858761"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 17:26:36 -0700
X-IronPort-AV: E=Sophos;i="5.91,296,1647327600"; 
   d="scan'208";a="565875001"
Received: from mpoursae-mobl2.amr.corp.intel.com (HELO [10.212.0.84]) ([10.212.0.84])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 17:26:35 -0700
Message-ID: <966b1f45-ba5d-febd-e365-29308a9a59b4@intel.com>
Date:   Thu, 28 Apr 2022 17:26:52 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v3 04/21] x86/virt/tdx: Add skeleton for detecting and
 initializing TDX on demand
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, len.brown@intel.com,
        tony.luck@intel.com, rafael.j.wysocki@intel.com,
        reinette.chatre@intel.com, dan.j.williams@intel.com,
        peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com
References: <cover.1649219184.git.kai.huang@intel.com>
 <32dcf4c7acc95244a391458d79cd6907125c5c29.1649219184.git.kai.huang@intel.com>
 <ac482f2b-d2d1-0643-faa4-1b36340268c5@intel.com>
 <22e3adf42b8ea2cae3aabc26f762acb983133fea.camel@intel.com>
 <c833aff2-b459-a1d7-431f-bce5c5f29182@intel.com>
 <37efe2074eba47c51bf5c1a2369a05ddf9082885.camel@intel.com>
 <3731a852-71b8-b081-2426-3b0a650e174c@intel.com>
 <edcae7ab1e6a074255a6624e8e0536bd77f84eed.camel@intel.com>
 <0aa81fd0-a491-847d-9fc6-4b853f2cf7b4@intel.com>
 <af6fccf2f6f8d83593f0eedd003c7cd07f89274d.camel@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <af6fccf2f6f8d83593f0eedd003c7cd07f89274d.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/28/22 17:11, Kai Huang wrote:
> This is true.  So I think w/o taking the lock is also fine, as the TDX module
> initialization is a state machine.  If any cpu goes offline during logical-cpu
> level initialization and TDH.SYS.LP.INIT isn't done on that cpu, then later the
> TDH.SYS.CONFIG will fail.  Similarly, if any cpu going offline causes
> TDH.SYS.KEY.CONFIG is not done for any package, then TDH.SYS.TDMR.INIT will
> fail.

Right.  The worst-case scenario is someone is mucking around with CPU
hotplug during TDX initialization is that TDX initialization will fail.

We *can* fix some of this at least and provide coherent error messages
with a pattern like this:

	cpus_read_lock();
	// check that all MADT-enumerated CPUs are online
	tdx_init();
	cpus_read_unlock();

That, of course, *does* prevent CPUs from going offline during
tdx_init().  It also provides a nice place for an error message:

	pr_warn("You offlined a CPU then want to use TDX?  Sod off.\n");

> A problem (I realized it exists in current implementation too) is shutting down
> the TDX module, which requires calling TDH.SYS.LP.SHUTDOWN on all BIOS-enabled
> cpus.  Kernel can do this SEAMCALL at most for all present cpus.  However when
> any cpu is offline, this SEAMCALL won't be called on it, and it seems we need to
> add new CPU hotplug callback to call this SEAMCALL when the cpu is online again.

Hold on a sec.  If you call TDH.SYS.LP.SHUTDOWN on any CPU, then TDX
stops working everywhere, right?  But, if someone offlines one CPU, we
don't want TDX to stop working everywhere.
