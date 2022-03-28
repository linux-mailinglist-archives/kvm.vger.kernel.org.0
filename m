Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34D864EA3D2
	for <lists+kvm@lfdr.de>; Tue, 29 Mar 2022 01:44:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230505AbiC1XmX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Mar 2022 19:42:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230472AbiC1XmW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Mar 2022 19:42:22 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60A3A63A9;
        Mon, 28 Mar 2022 16:40:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648510841; x=1680046841;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0mmJ/whBeCllU3xdwmN5YeVPUumAS7XqYgOhdOdB3g8=;
  b=jjl01dh8ga3r27G7Um1eUGGr8KRhZuwKdHNJA8XrfOrx2q34bLFFB0bh
   +Kfef9U0isZrgaDez4SqQq5CPpJE/FjslqG4P36My16BNB/SmDIGgTiyA
   9xLcMEjMU2Oek2fKiqq72QOjVvwO6urQc+nUW49dk1sXEUcuDQT912YSF
   4OrFfkw4JiZqQK7oaTi4ePqGKqStWiQmS/f2+onwghqGDgwmbghnljUef
   +geCGv+W1Th5azb3OQRKVxs9zZe6MkIegtR4IbeQictN6ql3Vk1YI3D4I
   lQ7H6OKgsTWZ7gARnHwKhrIOTrE8MBnJy33SvOM/UINRuGlSlVnjYxwoL
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10300"; a="239057013"
X-IronPort-AV: E=Sophos;i="5.90,218,1643702400"; 
   d="scan'208";a="239057013"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2022 16:40:40 -0700
X-IronPort-AV: E=Sophos;i="5.90,218,1643702400"; 
   d="scan'208";a="521215541"
Received: from nhawacha-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.27.18])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2022 16:40:37 -0700
Message-ID: <9d8d20f62f82e052893fa32368d6a228a2140728.camel@intel.com>
Subject: Re: [PATCH v2 09/21] x86/virt/tdx: Get information about TDX module
 and convertible memory
From:   Kai Huang <kai.huang@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        seanjc@google.com, pbonzini@redhat.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, peterz@infradead.org,
        tony.luck@intel.com, ak@linux.intel.com, dan.j.williams@intel.com,
        isaku.yamahata@intel.com
Date:   Tue, 29 Mar 2022 12:40:35 +1300
In-Reply-To: <60bf1aa7-b004-0ea7-7efc-37b4a1ea2461@intel.com>
References: <cover.1647167475.git.kai.huang@intel.com>
         <98c1010509aa412e7f05b12187cacf40451d5246.1647167475.git.kai.huang@intel.com>
         <20220324174301.GA1212881@ls.amr.corp.intel.com>
         <f211441a6d23321e22517684159e2c28c8492b86.camel@intel.com>
         <20220328202225.GA1525925@ls.amr.corp.intel.com>
         <60bf1aa7-b004-0ea7-7efc-37b4a1ea2461@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2022-03-28 at 13:30 -0700, Dave Hansen wrote:
> On 3/28/22 13:22, Isaku Yamahata wrote:
> > > > > +	/*
> > > > > +	 * Also a sane BIOS should never generate invalid CMR(s) between
> > > > > +	 * two valid CMRs.  Sanity check this and simply return error in
> > > > > +	 * this case.
> > > > > +	 */
> > > > > +	for (j = i; j < cmr_num; j++)
> > > > > +		if (cmr_valid(&cmr_array[j])) {
> > > > > +			pr_err("Firmware bug: invalid CMR(s) among valid CMRs.\n");
> > > > > +			return -EFAULT;
> > > > > +		}
> > > > This check doesn't make sense because above i-for loop has break.
> > > The break in above i-for loop will hit at the first invalid CMR entry.  Yes "j =
> > > i" will make double check on this invalid CMR entry, but it should have no
> > > problem.  Or we can change to "j = i + 1" to skip the first invalid CMR entry.
> > > 
> > > Does this make sense?
> > It makes sense. Somehow I missed j = i. I scratch my review.
> 
> You can also take it as something you might want to refactor, add
> comments, or work on better variable names.  If it confused one person,
> it will confuse more in the future.

Hi Dave,

OK I'll think over whether I can improve.  Thanks for advice.

Btw if you have time, could you help to review this series? Or could you take a
look at whether the overall design is OK, for instance, the design limitations
described in the cover letter?

-- 
Thanks,
-Kai


