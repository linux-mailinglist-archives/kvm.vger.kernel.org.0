Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 637F56A6F0E
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 16:11:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbjCAPLn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 10:11:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbjCAPLm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 10:11:42 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C0F016897;
        Wed,  1 Mar 2023 07:11:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677683501; x=1709219501;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=hjYr2EMRWWOBA1w4cnhzIu+T7tZBlHG4CpSb2cRhb34=;
  b=NJpRKkRpt3/rHgSTAxW7Cfe4xrLcj7xTxAaVhCl+QmzqeJ5VQ/gmDrtV
   vjGoQOpwZX0URqFhPruGS4A6Mu7caXc2SUlxT70+8zkgapsFYwO8RA4vr
   T8v792GxcXnPD23LoB4vF+bypJ/V6oZgZbqLU4rG5cVpKnxwUR8xAEhb1
   m26mL2tuLf2+hRWy5eb6LNhNtD69PMgbDs5moQFUapjgtF8dPG1Gpak4R
   gYf1MO1azj7m8mfidv34qc5gBhRw/lQ0IiITib7wceTFG9H8zQSAN+93d
   2cQatQGshVtoxvU7TYtHn8KYm6oa0JgiX3PsfngWN93AtRxXP16xtBtDK
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10636"; a="318230725"
X-IronPort-AV: E=Sophos;i="5.98,225,1673942400"; 
   d="scan'208";a="318230725"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2023 07:11:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10636"; a="920278181"
X-IronPort-AV: E=Sophos;i="5.98,225,1673942400"; 
   d="scan'208";a="920278181"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga006.fm.intel.com with ESMTP; 01 Mar 2023 07:11:34 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1pXO7B-00Dnz1-0F;
        Wed, 01 Mar 2023 17:11:33 +0200
Date:   Wed, 1 Mar 2023 17:11:32 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Yury Norov <yury.norov@gmail.com>
Cc:     linux-kernel@vger.kernel.org,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Alexander Lobakin <aleksander.lobakin@intel.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Heiko Carstens <hca@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH 1/2] lib/test_bitmap: increment failure counter properly
Message-ID: <Y/9rJFJ9Pmzf6Waz@smile.fi.intel.com>
References: <20230227214524.914050-1-yury.norov@gmail.com>
 <Y/00yaVqK2x3+pP3@smile.fi.intel.com>
 <Y/1ruRmnY4eU536Q@yury-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y/1ruRmnY4eU536Q@yury-laptop>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 27, 2023 at 06:49:29PM -0800, Yury Norov wrote:
> On Tue, Feb 28, 2023 at 12:55:05AM +0200, Andy Shevchenko wrote:
> > On Mon, Feb 27, 2023 at 01:45:23PM -0800, Yury Norov wrote:
> > > The tests that don't use expect_eq() macro to determine that a test is
> > > failured must increment failed_tests explicitly.
> > 
> > ...
> > 
> > >  			pr_err("bitmap_copy_arr32(nbits == %d:"
> > >  				" tail is not safely cleared: %d\n",
> > 
> > Usually we don't split string literals (since checkpatch doesn't complain on a
> > looong lines with them at the end of the line),
> > 
> > ...
> > 
> > >  			pr_err("bitmap_copy_arr64(nbits == %d:"
> > >  				" tail is not safely cleared: %d\n", nbits, next_bit);
> > 
> > Ditto.
> > 
> > P.S. Seems a material for another patch.
> 
> If you're OK with this patch, can you give your review tag please?

I'm fine with the series,
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

-- 
With Best Regards,
Andy Shevchenko


