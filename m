Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1289F654BD4
	for <lists+kvm@lfdr.de>; Fri, 23 Dec 2022 04:55:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbiLWDzw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Dec 2022 22:55:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbiLWDzu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Dec 2022 22:55:50 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CA2AFCF6
        for <kvm@vger.kernel.org>; Thu, 22 Dec 2022 19:55:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671767749; x=1703303749;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TWQVs1rTKsPPYGeMVlC5/kuq0fuMOxSz8ZkZK+Dl3v0=;
  b=nYWovHFJZsfRz83GSlV8bFJI7SQgmR51iZsJlmMhh/b/fQDb7UOkjoDz
   DmKnotW1ltPbtw74c4qJUZDqbYSZupF5AXWGmaUmVxync7hA06DnzKHS5
   xfVib1zxrvK1cOzwS9BKuxNQ2F0YJoJZYQXQ3Qin5WXhoCIdZii28Ffmx
   Yw+hUZyMvEFTKnzPLYEpWOMbWkRDXRJFICj5Wwa4GGf8JtrITrgj2lg1V
   1njgaYUhDLPCdCnCKJB2NcImolNXT1pN74q1DQQUZ0rsjwGpbuofOwHq6
   rlwdROUtyZgdZPbj+XuFhQV0QsXMaezdVgs9tMuL+jdM4mFrPrHE/hnLb
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10569"; a="322209727"
X-IronPort-AV: E=Sophos;i="5.96,267,1665471600"; 
   d="scan'208";a="322209727"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2022 19:55:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10569"; a="776250954"
X-IronPort-AV: E=Sophos;i="5.96,267,1665471600"; 
   d="scan'208";a="776250954"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by orsmga004.jf.intel.com with ESMTP; 22 Dec 2022 19:55:46 -0800
Message-ID: <a05642f75498f5d55c12d2d749a4210257aaebbb.camel@linux.intel.com>
Subject: Re: [PATCH v3 6/9] KVM: x86: Untag LAM bits when applicable
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     Yuan Yao <yuan.yao@linux.intel.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>
Cc:     pbonzini@redhat.com, seanjc@google.com,
        kirill.shutemov@linux.intel.com, kvm@vger.kernel.org,
        Jingqi Liu <jingqi.liu@intel.com>
Date:   Fri, 23 Dec 2022 11:55:45 +0800
In-Reply-To: <20221223023632.ymyfrpdyphy3h26i@yy-desk-7060>
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
         <20221223023632.ymyfrpdyphy3h26i@yy-desk-7060>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-12-23 at 10:36 +0800, Yuan Yao wrote:
> On Thu, Dec 22, 2022 at 04:21:32PM +0800, Yu Zhang wrote:
> > > > > > > 
> > > > > > > Well, it's not about the control register or MSR
> > > > > > > emulation. It is
> > > > > > > about
> > > > > > > the instruction decoder, which may encounter an
> > > > > > > instruction with a
> > > > > > > memory
> > > > > > > operand with LAM bits occupied.
> > > > > > > 
> > > > > > 
> > > > > > OK, combine reply to you and Yuan's comments here.
> > > > > > So you're talking about when KVM emulates an instruction,
> > > > > > and that
> > > > > > instruction is accessing memory, and the address for the
> > > > > > memory can be
> > > > > > LAM tagged.
> > > > > > I think instruction emulation and memory access should be
> > > > > > separated,
> > > > > > and LAM rules should apply to memory access phase. But
> > > > > > frankly
> > > > > > speaking, I haven't looked into such case yet. Can you name
> > > > > > an example
> > > > > > of such emulated instruction? I can take a look, hoping
> > > > > > that the
> > > > > > emulation accessing memory falls into same code path as
> > > > > > page fault
> > > > > > handling.
> > > > > 
> > > > > I do not know the usage case of LAM. According to the spec,
> > > > > LAM does
> > > > > not apply to instruction fetches, so guest rip and target
> > > > > addresses
> > > > > in instructions such as jump, call etc. do not need special
> > > > > treatment.
> > > > > But the spec does not say if LAM can be used to MMIO
> > > > > addresses...
> > > > 
> > > > The MMIO accessing in guest is also via GVA, so any emulated
> > > > device MMIO accessing hits this case. KVM checks GVA firstly
> > > > even in TDP
> > > 
> > > Yes. And sorry, I meant the spec does not say LAM can not be used
> > > to MMIO addresses.
> > > 
> > 
> > BTW, it is not just about MMIO. Normal memory address can also
> > trigger the
> > linearize(), e.g., memory operand of io instructions, though I
> > still have
> > no idea if this could be one of the usage cases of LAM.
> 
> Yes you are right, the emulated normal memory accessing should also
> be
> considered.
> 
> Emm... to me I think the IOS/OUTS instruction family should be part
> of
> LAM usage case, but yet no such explicity description about this in
> ISE...
> 
What instructions will be emulated by KVM now? I don't think KVM will
emulate all that would otherwise #UD.
For callers from handle page fault path, that address has been untagged
by HW before exit to KVM.

