Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2F9F514A1C
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 14:59:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359660AbiD2NC7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 09:02:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359621AbiD2NCx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 09:02:53 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F4DCCA0D2;
        Fri, 29 Apr 2022 05:59:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651237172; x=1682773172;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=G3cxB0HDg/hWN46WuirekDQTBDL7WfaNTwXNbR3h9l0=;
  b=WzIFGRUvXNGXuHRTXYalIdBOmr5/cN5iCiLe30i8QeN2Kia5BIh06zg7
   WEKMtJLgYaQ3MlRLoVZIFE7Ts8NrYg8jRkenRmA6DEiXcRjlFntZpnWU5
   Qcq/LC/t+vevZI0BYbR/jcHVs69Q0xsuruAh9XlhSKktjcFD+8uUgM3T2
   T/VnwhqnaPHvhHwW0rj28OAe6G7eiMe3ocw3BIICD3dy/kK2Q0x11qfn0
   D9bY5pCIJgbkyQCO4BO20BS1FbKfMEt0Lpw/iD79GmEovngdRLQ1ki5mb
   TmhOsJopOdgK+5sowJa1gI1cMKVvhJjVyh/nTy2mx/YqAKPjCzLEOcRoW
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10331"; a="266793289"
X-IronPort-AV: E=Sophos;i="5.91,185,1647327600"; 
   d="scan'208";a="266793289"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2022 05:59:32 -0700
X-IronPort-AV: E=Sophos;i="5.91,185,1647327600"; 
   d="scan'208";a="514810215"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2022 05:59:28 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1nkQDV-009iQX-QJ;
        Fri, 29 Apr 2022 15:59:25 +0300
Date:   Fri, 29 Apr 2022 15:59:25 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Yury Norov <yury.norov@gmail.com>
Cc:     linux-kernel@vger.kernel.org,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH 2/5] lib: add bitmap_{from,to}_arr64
Message-ID: <YmvhLbIoHDhEhJFq@smile.fi.intel.com>
References: <20220428205116.861003-1-yury.norov@gmail.com>
 <20220428205116.861003-3-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220428205116.861003-3-yury.norov@gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 28, 2022 at 01:51:13PM -0700, Yury Norov wrote:
> Manipulating 64-bit arrays with bitmap functions is potentially dangerous
> because on 32-bit BE machines the order of halfwords doesn't match.
> Another issue is that compiler may throw a warning about out-of-boundary
> access.
> 
> This patch adds bitmap_{from,to}_arr64 functions in addition to existing
> bitmap_{from,to}_arr32.

...

> +	bitmap_copy_clear_tail((unsigned long *) (bitmap),	\
> +			(const unsigned long *) (buf), (nbits))

Drop spaces after castings. Besides that it might be placed on a single line.

...


> +	bitmap_copy_clear_tail((unsigned long *) (buf),		\
> +			(const unsigned long *) (bitmap), (nbits))

Ditto.

...

> +void bitmap_to_arr64(u64 *buf, const unsigned long *bitmap, unsigned int nbits)
> +{
> +	const unsigned long *end = bitmap + BITS_TO_LONGS(nbits);
> +
> +	while (bitmap < end) {
> +		*buf = *bitmap++;
> +		if (bitmap < end)
> +			*buf |= (u64)(*bitmap++) << 32;
> +		buf++;
> +	}
>  
> +	/* Clear tail bits in last element of array beyond nbits. */
> +	if (nbits % 64)
> +		buf[-1] &= GENMASK_ULL(nbits, 0);

Hmm... if nbits is > 0 and < 64, wouldn't be this problematic, since
end == bitmap? Or did I miss something?

> +}

-- 
With Best Regards,
Andy Shevchenko


