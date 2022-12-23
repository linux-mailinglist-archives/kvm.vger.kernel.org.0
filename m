Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D10C654B26
	for <lists+kvm@lfdr.de>; Fri, 23 Dec 2022 03:36:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235679AbiLWCgj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Dec 2022 21:36:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbiLWCgg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Dec 2022 21:36:36 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0865C183AE
        for <kvm@vger.kernel.org>; Thu, 22 Dec 2022 18:36:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671762996; x=1703298996;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=bc8uQNUawsyJ5k9X7a/Z/jQohOoHp49lfh/DK7m7UX0=;
  b=TEWQpDbzcrxLD/kOvYVNl/wWGFj+4fPcnttE9L1iOlsew8KSpkyi511E
   uQXO365UpZyzgh4QlOjtzLxykARPmMZKxp+qPbesuU45hg+cQRYldqMUQ
   7z0k6JJnEA3KBXQ8bxTwxdlMRI3f1G+qGSD39LgrYfK6aKEntdIwjGKvk
   djZnLhPMTNoZy3LL+mzeDlu7iVUZ/Gp5oLdm75smYbX6CYm/1DznTD0bK
   yd4pl1YF5F/uY/5BvKeNjLv5swQdj8IB3iBeP3tfyBmESYt9HykS4qYcu
   gCJPWzcaFw4gUdxcr1D3M6Xna4/YVwiCtTNEFOyPBIWqkazaU98NUy4ZD
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10569"; a="307972516"
X-IronPort-AV: E=Sophos;i="5.96,267,1665471600"; 
   d="scan'208";a="307972516"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2022 18:36:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10569"; a="654074572"
X-IronPort-AV: E=Sophos;i="5.96,267,1665471600"; 
   d="scan'208";a="654074572"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by fmsmga007.fm.intel.com with ESMTP; 22 Dec 2022 18:36:33 -0800
Date:   Fri, 23 Dec 2022 10:36:32 +0800
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     Yu Zhang <yu.c.zhang@linux.intel.com>
Cc:     Robert Hoo <robert.hu@linux.intel.com>, pbonzini@redhat.com,
        seanjc@google.com, kirill.shutemov@linux.intel.com,
        kvm@vger.kernel.org, Jingqi Liu <jingqi.liu@intel.com>
Subject: Re: [PATCH v3 6/9] KVM: x86: Untag LAM bits when applicable
Message-ID: <20221223023632.ymyfrpdyphy3h26i@yy-desk-7060>
References: <20221209044557.1496580-1-robert.hu@linux.intel.com>
 <20221209044557.1496580-7-robert.hu@linux.intel.com>
 <20221219094511.boo7iththyps565z@yy-desk-7060>
 <3e3a389cc887062a737327713a634ded80e977b2.camel@linux.intel.com>
 <20221221080222.ohsk6mcqvq5z4t3t@linux.intel.com>
 <ec96c8499a9a48aea59ce87f0244c9b31f91641f.camel@linux.intel.com>
 <20221221101032.3g54omjqhnscuaqw@linux.intel.com>
 <20221221103030.hwo5xj2jlrflrevx@yy-desk-7060>
 <20221221124053.5s2aashbhqz4hppx@linux.intel.com>
 <20221222082132.2nnkuvgfez7iiwbj@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221222082132.2nnkuvgfez7iiwbj@linux.intel.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 22, 2022 at 04:21:32PM +0800, Yu Zhang wrote:
> > > > > >
> > > > > > Well, it's not about the control register or MSR emulation. It is
> > > > > > about
> > > > > > the instruction decoder, which may encounter an instruction with a
> > > > > > memory
> > > > > > operand with LAM bits occupied.
> > > > > >
> > > > > OK, combine reply to you and Yuan's comments here.
> > > > > So you're talking about when KVM emulates an instruction, and that
> > > > > instruction is accessing memory, and the address for the memory can be
> > > > > LAM tagged.
> > > > > I think instruction emulation and memory access should be separated,
> > > > > and LAM rules should apply to memory access phase. But frankly
> > > > > speaking, I haven't looked into such case yet. Can you name an example
> > > > > of such emulated instruction? I can take a look, hoping that the
> > > > > emulation accessing memory falls into same code path as page fault
> > > > > handling.
> > > >
> > > > I do not know the usage case of LAM. According to the spec, LAM does
> > > > not apply to instruction fetches, so guest rip and target addresses
> > > > in instructions such as jump, call etc. do not need special treatment.
> > > > But the spec does not say if LAM can be used to MMIO addresses...
> > >
> > > The MMIO accessing in guest is also via GVA, so any emulated
> > > device MMIO accessing hits this case. KVM checks GVA firstly even in TDP
> >
> > Yes. And sorry, I meant the spec does not say LAM can not be used
> > to MMIO addresses.
> >
> BTW, it is not just about MMIO. Normal memory address can also trigger the
> linearize(), e.g., memory operand of io instructions, though I still have
> no idea if this could be one of the usage cases of LAM.

Yes you are right, the emulated normal memory accessing should also be
considered.

Emm... to me I think the IOS/OUTS instruction family should be part of
LAM usage case, but yet no such explicity description about this in ISE...

>
> B.R.
> Yu
