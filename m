Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AC036A4EF9
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 23:55:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbjB0WzQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 17:55:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbjB0WzO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 17:55:14 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2D9F1C32B;
        Mon, 27 Feb 2023 14:55:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677538511; x=1709074511;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=SCRrC5ty/g1L2vmk39UkzRTg62xTOOkxd2rHSzpm+PI=;
  b=cLlt5TNJITIsF+D13PgyB6umH7S0UHSiXBBgYeZ5yxaI4nDS5m4T5OfN
   3gbH+ldDPLTLwRJWr8eBkqi5HXqppRQp+S7p50urEGAKDisRAPk/TMr2/
   AzcULNSJv36d5LNPdz6EN6q2IRqajBOXOWW1rkqYDKbExviaRHAIvg7mv
   o2weOmW/QAPFzW/QcC3bAp/tFLzOwFnKIU41X2QjsCxlU36jzH8wpaLpV
   c1Vl86/Rz6Foly8kPbaWDLHbGzHlBGLrlyUZMiQoQRxuAb/O/xtuSgUGW
   2zkqwctEafJrEoNuVtoMIffcDn9d8bPNxpxGaoE0fp1fCpkHrawqVR7bc
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10634"; a="361547553"
X-IronPort-AV: E=Sophos;i="5.98,220,1673942400"; 
   d="scan'208";a="361547553"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 14:55:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10634"; a="762917662"
X-IronPort-AV: E=Sophos;i="5.98,220,1673942400"; 
   d="scan'208";a="762917662"
Received: from smile.fi.intel.com ([10.237.72.54])
  by FMSMGA003.fm.intel.com with ESMTP; 27 Feb 2023 14:55:07 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1pWmOg-00D274-0I;
        Tue, 28 Feb 2023 00:55:06 +0200
Date:   Tue, 28 Feb 2023 00:55:05 +0200
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
Message-ID: <Y/00yaVqK2x3+pP3@smile.fi.intel.com>
References: <20230227214524.914050-1-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230227214524.914050-1-yury.norov@gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 27, 2023 at 01:45:23PM -0800, Yury Norov wrote:
> The tests that don't use expect_eq() macro to determine that a test is
> failured must increment failed_tests explicitly.

...

>  			pr_err("bitmap_copy_arr32(nbits == %d:"
>  				" tail is not safely cleared: %d\n",

Usually we don't split string literals (since checkpatch doesn't complain on a
looong lines with them at the end of the line),

...

>  			pr_err("bitmap_copy_arr64(nbits == %d:"
>  				" tail is not safely cleared: %d\n", nbits, next_bit);

Ditto.

P.S. Seems a material for another patch.

-- 
With Best Regards,
Andy Shevchenko


