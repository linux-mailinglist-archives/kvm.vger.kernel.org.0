Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE9866530EF
	for <lists+kvm@lfdr.de>; Wed, 21 Dec 2022 13:41:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbiLUMlF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Dec 2022 07:41:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbiLUMlE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Dec 2022 07:41:04 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11ACC2251B
        for <kvm@vger.kernel.org>; Wed, 21 Dec 2022 04:41:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671626463; x=1703162463;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=8iJlqRFswBRbGQQNzwyojTwo9h/4ILdH8znRksedoN0=;
  b=AQMxF2Zv61dztIHDPX6jLt0Ivuvmmh4DTT/m6gMlsQlidjc53T4RijhW
   r4Fg8hXSHggilYnSQfIlY7v3Pk6CiR2XIxeIj1TAItvKq473RE3vgSixd
   oFoBaBJ0m64xLK2zhLk4F9DzGE4BqqoxCWUDWy7vHeWvIt49xkguBDrDC
   LN9noHndzXywRSfkTjqZO355blJ6SkOsLbBBWpr1FIZyv2t5MF0mTG/nL
   3l5VOVCyRJaANajaH8wjoaZLDdlLXSg99kiYEs4sU8lgFEHKsOSuftspt
   Q19EukWmzWdHgpnmBT+dOYqPTabEY1QO/o99wt08ODkmG5h10dPRPhGtV
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="299538698"
X-IronPort-AV: E=Sophos;i="5.96,262,1665471600"; 
   d="scan'208";a="299538698"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2022 04:41:02 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="980184337"
X-IronPort-AV: E=Sophos;i="5.96,262,1665471600"; 
   d="scan'208";a="980184337"
Received: from xruan5-mobl.ccr.corp.intel.com (HELO localhost) ([10.255.29.248])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2022 04:40:56 -0800
Date:   Wed, 21 Dec 2022 20:40:53 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     Yuan Yao <yuan.yao@linux.intel.com>
Cc:     Robert Hoo <robert.hu@linux.intel.com>, pbonzini@redhat.com,
        seanjc@google.com, kirill.shutemov@linux.intel.com,
        kvm@vger.kernel.org, Jingqi Liu <jingqi.liu@intel.com>
Subject: Re: [PATCH v3 6/9] KVM: x86: Untag LAM bits when applicable
Message-ID: <20221221124053.5s2aashbhqz4hppx@linux.intel.com>
References: <20221209044557.1496580-1-robert.hu@linux.intel.com>
 <20221209044557.1496580-7-robert.hu@linux.intel.com>
 <20221219094511.boo7iththyps565z@yy-desk-7060>
 <3e3a389cc887062a737327713a634ded80e977b2.camel@linux.intel.com>
 <20221221080222.ohsk6mcqvq5z4t3t@linux.intel.com>
 <ec96c8499a9a48aea59ce87f0244c9b31f91641f.camel@linux.intel.com>
 <20221221101032.3g54omjqhnscuaqw@linux.intel.com>
 <20221221103030.hwo5xj2jlrflrevx@yy-desk-7060>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221221103030.hwo5xj2jlrflrevx@yy-desk-7060>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 21, 2022 at 06:30:31PM +0800, Yuan Yao wrote:
> On Wed, Dec 21, 2022 at 06:10:32PM +0800, Yu Zhang wrote:
> > On Wed, Dec 21, 2022 at 04:49:26PM +0800, Robert Hoo wrote:
> > > On Wed, 2022-12-21 at 16:02 +0800, Yu Zhang wrote:
> > > > > Emm, I take a look at the callers, looks like they're segment
> > > > > registers
> > > > > and MSRs. Per spec (ISE 10.4): processors that support LAM continue
> > > > > to
> > > > > require the addresses written to control registers or MSRs be
> > > > > legacy
> > > > > canonical. So, like the handling on your last commented point on
> > > > > this
> > > > > patch, such situation needs no changes, i.e. legacy canonical still
> > > > > applied.
> > > > >
> > > >
> > > > Well, it's not about the control register or MSR emulation. It is
> > > > about
> > > > the instruction decoder, which may encounter an instruction with a
> > > > memory
> > > > operand with LAM bits occupied.
> > > >
> > > OK, combine reply to you and Yuan's comments here.
> > > So you're talking about when KVM emulates an instruction, and that
> > > instruction is accessing memory, and the address for the memory can be
> > > LAM tagged.
> > > I think instruction emulation and memory access should be separated,
> > > and LAM rules should apply to memory access phase. But frankly
> > > speaking, I haven't looked into such case yet. Can you name an example
> > > of such emulated instruction? I can take a look, hoping that the
> > > emulation accessing memory falls into same code path as page fault
> > > handling.
> >
> > I do not know the usage case of LAM. According to the spec, LAM does
> > not apply to instruction fetches, so guest rip and target addresses
> > in instructions such as jump, call etc. do not need special treatment.
> > But the spec does not say if LAM can be used to MMIO addresses...
> 
> The MMIO accessing in guest is also via GVA, so any emulated
> device MMIO accessing hits this case. KVM checks GVA firstly even in TDP

Yes. And sorry, I meant the spec does not say LAM can not be used
to MMIO addresses.

> case(which KVM already has GPA in hand) before start to "real"
> accessing the GPA:
> 
> segmented_read/write() -> linearize() -> __linearize()
> 

B.R.
Yu
