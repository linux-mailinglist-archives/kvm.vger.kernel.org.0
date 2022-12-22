Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20AB2653CE9
	for <lists+kvm@lfdr.de>; Thu, 22 Dec 2022 09:21:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235003AbiLVIV4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Dec 2022 03:21:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235095AbiLVIVy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Dec 2022 03:21:54 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 966B711162
        for <kvm@vger.kernel.org>; Thu, 22 Dec 2022 00:21:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671697313; x=1703233313;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=JtmLm+rud1dmKaAW0K1sJ4HYiTgN2eQcr/vzqEkFTxU=;
  b=TP5CeCqLSEG0nj7cXZ3MGbPgBgz+8TrnB/fYwyFLRqgesC8t4zan6Oxm
   ZTx5Qk5ClYsNswBqF1H1Q+zB2MT35jX8ViZ4G8asTXbYTVRHARek1Cibb
   ZTTPZ2UorwGsAqBfCsvsZumgpSbvHg+Nxfg2IiPSWI7WqhLIwRDiK08sl
   4YmRiIH2Ro6J/fNMCUry3duAFDARs9RFg9BWyB9l6CbMdaFegwEQOteJO
   CzFvuS0pSHfePgbknaDDPAyN80IYS39CXUUuXfa9h/XwlT0Vuk2Zfxb3u
   jZyADEbcEiVJDUWrBzEa+9susQ3BxuNBGTuWP4Lc3iHCATz/KliTKIgbQ
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10568"; a="320131320"
X-IronPort-AV: E=Sophos;i="5.96,265,1665471600"; 
   d="scan'208";a="320131320"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2022 00:21:52 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10568"; a="794017018"
X-IronPort-AV: E=Sophos;i="5.96,264,1665471600"; 
   d="scan'208";a="794017018"
Received: from jjin4-desk2.ccr.corp.intel.com (HELO localhost) ([10.249.171.81])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2022 00:21:45 -0800
Date:   Thu, 22 Dec 2022 16:21:32 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     Yuan Yao <yuan.yao@linux.intel.com>
Cc:     Robert Hoo <robert.hu@linux.intel.com>, pbonzini@redhat.com,
        seanjc@google.com, kirill.shutemov@linux.intel.com,
        kvm@vger.kernel.org, Jingqi Liu <jingqi.liu@intel.com>
Subject: Re: [PATCH v3 6/9] KVM: x86: Untag LAM bits when applicable
Message-ID: <20221222082132.2nnkuvgfez7iiwbj@linux.intel.com>
References: <20221209044557.1496580-1-robert.hu@linux.intel.com>
 <20221209044557.1496580-7-robert.hu@linux.intel.com>
 <20221219094511.boo7iththyps565z@yy-desk-7060>
 <3e3a389cc887062a737327713a634ded80e977b2.camel@linux.intel.com>
 <20221221080222.ohsk6mcqvq5z4t3t@linux.intel.com>
 <ec96c8499a9a48aea59ce87f0244c9b31f91641f.camel@linux.intel.com>
 <20221221101032.3g54omjqhnscuaqw@linux.intel.com>
 <20221221103030.hwo5xj2jlrflrevx@yy-desk-7060>
 <20221221124053.5s2aashbhqz4hppx@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221221124053.5s2aashbhqz4hppx@linux.intel.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > > > >
> > > > > Well, it's not about the control register or MSR emulation. It is
> > > > > about
> > > > > the instruction decoder, which may encounter an instruction with a
> > > > > memory
> > > > > operand with LAM bits occupied.
> > > > >
> > > > OK, combine reply to you and Yuan's comments here.
> > > > So you're talking about when KVM emulates an instruction, and that
> > > > instruction is accessing memory, and the address for the memory can be
> > > > LAM tagged.
> > > > I think instruction emulation and memory access should be separated,
> > > > and LAM rules should apply to memory access phase. But frankly
> > > > speaking, I haven't looked into such case yet. Can you name an example
> > > > of such emulated instruction? I can take a look, hoping that the
> > > > emulation accessing memory falls into same code path as page fault
> > > > handling.
> > >
> > > I do not know the usage case of LAM. According to the spec, LAM does
> > > not apply to instruction fetches, so guest rip and target addresses
> > > in instructions such as jump, call etc. do not need special treatment.
> > > But the spec does not say if LAM can be used to MMIO addresses...
> > 
> > The MMIO accessing in guest is also via GVA, so any emulated
> > device MMIO accessing hits this case. KVM checks GVA firstly even in TDP
> 
> Yes. And sorry, I meant the spec does not say LAM can not be used
> to MMIO addresses.
> 
BTW, it is not just about MMIO. Normal memory address can also trigger the
linearize(), e.g., memory operand of io instructions, though I still have
no idea if this could be one of the usage cases of LAM.

B.R.
Yu
