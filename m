Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96CFF513F6E
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 02:11:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353524AbiD2AOj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 20:14:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353514AbiD2AOj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 20:14:39 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ED2C13FA9;
        Thu, 28 Apr 2022 17:11:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651191083; x=1682727083;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=smpyNqmyFSCJvZZ+sLu7SHod4hKNPqpKqnKcw6fAVnU=;
  b=VstMflPxdtVSFMPHTJQrqKKyYfU+B8aSlBN2H/TMFzDkHnSbvIG5HeMb
   m2arUuAwRnHDtUVlGIAlKBDgVgr69aRng7j5dAhS/qeQcuR2u5sz7hl5o
   RWVvA4widXtHW+qN+CmygCI+sFntwTVDJ2w21MW+iZxJWMTlliY5eDqmH
   w+qKJ6m34Naj8a37yvRXR+3VEneS3YZPc/2NvKyAfn5QlQztkSYS0vc8G
   mWnGsS/QJmqQ/Im18fpOzGMKxd+BmOGaAOSo0HFu4TIXhq9TvXODOWMCl
   r5hzUifoKWyWcjdRRyfomk17CQXVgCDGsDVHzUuC2KlqOl6pgjORkou6j
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10331"; a="265320843"
X-IronPort-AV: E=Sophos;i="5.91,296,1647327600"; 
   d="scan'208";a="265320843"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 17:11:22 -0700
X-IronPort-AV: E=Sophos;i="5.91,296,1647327600"; 
   d="scan'208";a="629811840"
Received: from gshechtm-mobl.ger.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.60.191])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 17:11:19 -0700
Message-ID: <af6fccf2f6f8d83593f0eedd003c7cd07f89274d.camel@intel.com>
Subject: Re: [PATCH v3 04/21] x86/virt/tdx: Add skeleton for detecting and
 initializing TDX on demand
From:   Kai Huang <kai.huang@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, len.brown@intel.com,
        tony.luck@intel.com, rafael.j.wysocki@intel.com,
        reinette.chatre@intel.com, dan.j.williams@intel.com,
        peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com
Date:   Fri, 29 Apr 2022 12:11:17 +1200
In-Reply-To: <0aa81fd0-a491-847d-9fc6-4b853f2cf7b4@intel.com>
References: <cover.1649219184.git.kai.huang@intel.com>
         <32dcf4c7acc95244a391458d79cd6907125c5c29.1649219184.git.kai.huang@intel.com>
         <ac482f2b-d2d1-0643-faa4-1b36340268c5@intel.com>
         <22e3adf42b8ea2cae3aabc26f762acb983133fea.camel@intel.com>
         <c833aff2-b459-a1d7-431f-bce5c5f29182@intel.com>
         <37efe2074eba47c51bf5c1a2369a05ddf9082885.camel@intel.com>
         <3731a852-71b8-b081-2426-3b0a650e174c@intel.com>
         <edcae7ab1e6a074255a6624e8e0536bd77f84eed.camel@intel.com>
         <0aa81fd0-a491-847d-9fc6-4b853f2cf7b4@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-04-28 at 16:53 -0700, Dave Hansen wrote:
> On 4/28/22 16:44, Kai Huang wrote:
> > > Just like the SME test, it doesn't even need to be precise.  It just
> > > needs to be 100% accurate in that it is *ALWAYS* set for any system that
> > > might have dirtied cache aliases.
> > > 
> > > I'm not sure why you are so fixated on SEAMRR specifically for this.
> > I see.  I think I can simply use MTRR.SEAMRR bit check.  If CPU supports SEAMRR,
> > then basically it supports MKTME.
> > 
> > Is this look good for you?
> 
> Sure, fine, as long as it comes with a coherent description that
> explains why the check is good enough.
> 
> > > > "During initializing the TDX module, one step requires some SEAMCALL must be
> > > > done on all logical cpus enabled by BIOS, otherwise a later step will fail. 
> > > > Disable CPU hotplug during the initialization process to prevent any CPU going
> > > > offline during initializing the TDX module.  Note it is caller's responsibility
> > > > to guarantee all BIOS-enabled CPUs are in cpu_present_mask and all present CPUs
> > > > are online."
> > > But, what if a CPU went offline just before this lock was taken?  What
> > > if the caller make sure all present CPUs are online, makes the call,
> > > then a CPU is taken offline.  The lock wouldn't do any good.
> > > 
> > > What purpose does the lock serve?
> > I thought cpus_read_lock() can prevent any CPU from going offline, no?
> 
> It doesn't prevent squat before the lock is taken, though.

This is true.  So I think w/o taking the lock is also fine, as the TDX module
initialization is a state machine.  If any cpu goes offline during logical-cpu
level initialization and TDH.SYS.LP.INIT isn't done on that cpu, then later the
TDH.SYS.CONFIG will fail.  Similarly, if any cpu going offline causes
TDH.SYS.KEY.CONFIG is not done for any package, then TDH.SYS.TDMR.INIT will
fail.

A problem (I realized it exists in current implementation too) is shutting down
the TDX module, which requires calling TDH.SYS.LP.SHUTDOWN on all BIOS-enabled
cpus.  Kernel can do this SEAMCALL at most for all present cpus.  However when
any cpu is offline, this SEAMCALL won't be called on it, and it seems we need to
add new CPU hotplug callback to call this SEAMCALL when the cpu is online again.

Any suggestion?  Thanks!


-- 
Thanks,
-Kai


