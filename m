Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F681652E16
	for <lists+kvm@lfdr.de>; Wed, 21 Dec 2022 09:49:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233321AbiLUItc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Dec 2022 03:49:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiLUItb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Dec 2022 03:49:31 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3407F1F2C4
        for <kvm@vger.kernel.org>; Wed, 21 Dec 2022 00:49:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671612570; x=1703148570;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NqMBsrTLxW/ZMxbqA3agyMys/0UqTOvoBk0lvI0pvmI=;
  b=Oen23/ep7phtW/tAWQH3Mo0bgKVEcEDorioya1r66BgVV4K5LFwQEpna
   mePbZZVyCQU//UTLUnDHmLumw3EGbU3HUOZBYWo3pgOZuIYFNt+QPBCyz
   GQCtyRJN1gF22S3Js3IIfNIxcSkEnsjDDDaQlegeyQVLySxDKIxKtQE/I
   mXeGZBS28nMOejQDFQ3eaeQ43AIorzvLTg71dpHxRknATD2DGRTqy4qI7
   0JXymUkK1YAisckLz95G0OOS5E0WDm0OhpP5MJ5/IiZqYebsqPRPAgMpu
   q+c1LCA6eumPVd3OFFMs00wzPtXR0cKugqKsls/SRcKBPsDcTZq96bQKH
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="321733579"
X-IronPort-AV: E=Sophos;i="5.96,262,1665471600"; 
   d="scan'208";a="321733579"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2022 00:49:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="793635280"
X-IronPort-AV: E=Sophos;i="5.96,262,1665471600"; 
   d="scan'208";a="793635280"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by fmsmga001.fm.intel.com with ESMTP; 21 Dec 2022 00:49:27 -0800
Message-ID: <ec96c8499a9a48aea59ce87f0244c9b31f91641f.camel@linux.intel.com>
Subject: Re: [PATCH v3 6/9] KVM: x86: Untag LAM bits when applicable
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     Yu Zhang <yu.c.zhang@linux.intel.com>
Cc:     Yuan Yao <yuan.yao@linux.intel.com>, pbonzini@redhat.com,
        seanjc@google.com, kirill.shutemov@linux.intel.com,
        kvm@vger.kernel.org, Jingqi Liu <jingqi.liu@intel.com>
Date:   Wed, 21 Dec 2022 16:49:26 +0800
In-Reply-To: <20221221080222.ohsk6mcqvq5z4t3t@linux.intel.com>
References: <20221209044557.1496580-1-robert.hu@linux.intel.com>
         <20221209044557.1496580-7-robert.hu@linux.intel.com>
         <20221219094511.boo7iththyps565z@yy-desk-7060>
         <3e3a389cc887062a737327713a634ded80e977b2.camel@linux.intel.com>
         <20221221080222.ohsk6mcqvq5z4t3t@linux.intel.com>
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

On Wed, 2022-12-21 at 16:02 +0800, Yu Zhang wrote:
> > Emm, I take a look at the callers, looks like they're segment
> > registers
> > and MSRs. Per spec (ISE 10.4): processors that support LAM continue
> > to
> > require the addresses written to control registers or MSRs be
> > legacy
> > canonical. So, like the handling on your last commented point on
> > this
> > patch, such situation needs no changes, i.e. legacy canonical still
> > applied.
> > 
> 
> Well, it's not about the control register or MSR emulation. It is
> about
> the instruction decoder, which may encounter an instruction with a
> memory
> operand with LAM bits occupied. 
> 
OK, combine reply to you and Yuan's comments here.
So you're talking about when KVM emulates an instruction, and that
instruction is accessing memory, and the address for the memory can be
LAM tagged.
I think instruction emulation and memory access should be separated,
and LAM rules should apply to memory access phase. But frankly
speaking, I haven't looked into such case yet. Can you name an example
of such emulated instruction? I can take a look, hoping that the
emulation accessing memory falls into same code path as page fault
handling.

> B.R.
> Yu

