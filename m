Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6C93620D29
	for <lists+kvm@lfdr.de>; Tue,  8 Nov 2022 11:24:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233856AbiKHKYD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Nov 2022 05:24:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233214AbiKHKYB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Nov 2022 05:24:01 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7218B873;
        Tue,  8 Nov 2022 02:24:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667903040; x=1699439040;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=YJMYXGLA4KEN/fGjMp9iTmRLlIV2wOamv31dHoqNe+8=;
  b=f2GQg1MxVNbv4+v7C3tRyoUy/I+QUmicl0hTv1uOoIlZR/+46LZ4Bamh
   //+Bw1zcmpik2KZrq8WMQ+4VIin1KcZvp6SKWfv//MnnbGnUe27+CRVCu
   2uW6Ofzmzb4JAZZPIAcGV4mS19cAWZIg08oMEzuwdAb5idW1obRRmZGsm
   lfB88i0otf2oLuOCGTHaTzTMgh7qiO/YCqwu/URCnMU0Ju1iiNPj5K6YO
   KCAHcY92Sgo1Jovc6+r7lw3f/rMhvwYTVAP366n11FGKC5crOVBDzQ0r6
   mOJ7yJTp0nFwOmjXzPVaSpNbgyRE+yWRZSXWBcOpTKdq17FhKqy7tv7iT
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="337387021"
X-IronPort-AV: E=Sophos;i="5.96,147,1665471600"; 
   d="scan'208";a="337387021"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2022 02:24:00 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="587321941"
X-IronPort-AV: E=Sophos;i="5.96,147,1665471600"; 
   d="scan'208";a="587321941"
Received: from wanglin4-mobl.ccr.corp.intel.com (HELO localhost) ([10.249.173.199])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2022 02:23:58 -0800
Date:   Tue, 8 Nov 2022 18:23:57 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: VMX: Do not trap VMFUNC instructions for L1 guests.
Message-ID: <20221108102357.ikrskv7shtp3o6lx@linux.intel.com>
References: <20221107082727.1355797-1-yu.c.zhang@linux.intel.com>
 <c8f036f4-6ab1-efbe-dd60-b934c21cb21d@redhat.com>
 <Y2lCFUbAFnbzyKzO@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y2lCFUbAFnbzyKzO@google.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 07, 2022 at 05:36:21PM +0000, Sean Christopherson wrote:
> On Mon, Nov 07, 2022, Paolo Bonzini wrote:
> > On 11/7/22 09:27, Yu Zhang wrote:
> > > VMFUNC is not supported for L1 guests, and executing VMFUNC in
> > > L1 shall generate a #UD directly. Just disable it in secondary
> > > proc-based execution control for L1, instead of intercepting it
> > > and inject the #UD again.
> > > 
> > > Signed-off-by: Yu Zhang<yu.c.zhang@linux.intel.com>
> > 
> > Is this for TDX or similar?  The reason for a patch should be mentioned in
> > the commit message.
> 
> It's just a cleanup, but (a) it should be split over two patches as disabling
> VMFUNC for L1 is technically a functional change, where as the changes to
> nested_vmx_setup_ctls_msrs() are pure cleanups, and (b) the !guest_mode path in
> handle_vmfunc() should either be removed or turned into a KVM_BUG_ON().
> 

Got it. Will do in V2. And thanks!

B.R.
Yu
