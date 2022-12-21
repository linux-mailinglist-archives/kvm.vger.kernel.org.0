Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69C52652F83
	for <lists+kvm@lfdr.de>; Wed, 21 Dec 2022 11:32:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234604AbiLUKcJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Dec 2022 05:32:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234567AbiLUKaj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Dec 2022 05:30:39 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75BCBBDF
        for <kvm@vger.kernel.org>; Wed, 21 Dec 2022 02:30:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671618634; x=1703154634;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=EU+ev9kpfAqLk9Pqu0H6tlTJsyDO4EWQ3co/iTJ2Cos=;
  b=VO1cl+f4f9xoz16w8fErGwStyfUdsRNTszPJ8gAJHYRXp7LC2LnbBszf
   qKewTt74LTxprdhSkF+nnK1vDRLrNDc6A71oZAUCC8WL7xk95Gekxq+KO
   J7kDioqO2+pCCnKej8Fim5yZacxh5XELh8Td4+cTC//hVgpEOWbXTcJ4r
   TP72O7W8jWg7Dk+EIWORKs9lyaEK5dTKE+rU7THp7jhEqq11otFbU6aaA
   Mhnxrz/TiGPb10TmX4vOi2i02iSXPSm9x955A2bhauX45FcXVMS6oR0s1
   ayKkLKDSfQiunvMphtngWImnKZX0ven5NkFmH9WvsTMEwUNIRw4uTYO1/
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="317475648"
X-IronPort-AV: E=Sophos;i="5.96,262,1665471600"; 
   d="scan'208";a="317475648"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2022 02:30:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="683745701"
X-IronPort-AV: E=Sophos;i="5.96,262,1665471600"; 
   d="scan'208";a="683745701"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by orsmga001.jf.intel.com with ESMTP; 21 Dec 2022 02:30:31 -0800
Date:   Wed, 21 Dec 2022 18:30:31 +0800
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     Yu Zhang <yu.c.zhang@linux.intel.com>
Cc:     Robert Hoo <robert.hu@linux.intel.com>, pbonzini@redhat.com,
        seanjc@google.com, kirill.shutemov@linux.intel.com,
        kvm@vger.kernel.org, Jingqi Liu <jingqi.liu@intel.com>
Subject: Re: [PATCH v3 6/9] KVM: x86: Untag LAM bits when applicable
Message-ID: <20221221103030.hwo5xj2jlrflrevx@yy-desk-7060>
References: <20221209044557.1496580-1-robert.hu@linux.intel.com>
 <20221209044557.1496580-7-robert.hu@linux.intel.com>
 <20221219094511.boo7iththyps565z@yy-desk-7060>
 <3e3a389cc887062a737327713a634ded80e977b2.camel@linux.intel.com>
 <20221221080222.ohsk6mcqvq5z4t3t@linux.intel.com>
 <ec96c8499a9a48aea59ce87f0244c9b31f91641f.camel@linux.intel.com>
 <20221221101032.3g54omjqhnscuaqw@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221221101032.3g54omjqhnscuaqw@linux.intel.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 21, 2022 at 06:10:32PM +0800, Yu Zhang wrote:
> On Wed, Dec 21, 2022 at 04:49:26PM +0800, Robert Hoo wrote:
> > On Wed, 2022-12-21 at 16:02 +0800, Yu Zhang wrote:
> > > > Emm, I take a look at the callers, looks like they're segment
> > > > registers
> > > > and MSRs. Per spec (ISE 10.4): processors that support LAM continue
> > > > to
> > > > require the addresses written to control registers or MSRs be
> > > > legacy
> > > > canonical. So, like the handling on your last commented point on
> > > > this
> > > > patch, such situation needs no changes, i.e. legacy canonical still
> > > > applied.
> > > >
> > >
> > > Well, it's not about the control register or MSR emulation. It is
> > > about
> > > the instruction decoder, which may encounter an instruction with a
> > > memory
> > > operand with LAM bits occupied.
> > >
> > OK, combine reply to you and Yuan's comments here.
> > So you're talking about when KVM emulates an instruction, and that
> > instruction is accessing memory, and the address for the memory can be
> > LAM tagged.
> > I think instruction emulation and memory access should be separated,
> > and LAM rules should apply to memory access phase. But frankly
> > speaking, I haven't looked into such case yet. Can you name an example
> > of such emulated instruction? I can take a look, hoping that the
> > emulation accessing memory falls into same code path as page fault
> > handling.
>
> I do not know the usage case of LAM. According to the spec, LAM does
> not apply to instruction fetches, so guest rip and target addresses
> in instructions such as jump, call etc. do not need special treatment.
> But the spec does not say if LAM can be used to MMIO addresses...

The MMIO accessing in guest is also via GVA, so any emulated
device MMIO accessing hits this case. KVM checks GVA firstly even in TDP
case(which KVM already has GPA in hand) before start to "real"
accessing the GPA:

segmented_read/write() -> linearize() -> __linearize()

>
> B.R.
> Yu
>
