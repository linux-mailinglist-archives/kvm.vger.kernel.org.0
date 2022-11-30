Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 238B363DC1F
	for <lists+kvm@lfdr.de>; Wed, 30 Nov 2022 18:38:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbiK3RiJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 12:38:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbiK3RiF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 12:38:05 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BBC330540;
        Wed, 30 Nov 2022 09:38:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669829883; x=1701365883;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=jgk+/gRksD/zcs3SEL3Csm7ScRic4ED0irw6NfZJsSk=;
  b=XCuC3EyiO1qXfsDqj7fsWtYf0ZG1KbHhDShofFVT1ccPRcFlmvLOXbNH
   pVojtcZAwcfxS9TBPDjqCzKIQCrrt+tIUv3B+KJeOLgToyOPn/aus7v/A
   jVQseH3pZzufK88f8XS8UIyoEKCJqKZkIzDWmikTlkK5GEfz2KbgOYOA1
   7oPcci7+xTxXVTLbCm5AQMsQ5qk88+bdzO2XiHaduT2tQPJRxFIuZIdxO
   XC+mqDXcA4qWgH7ck4fwruXQF0t3/qBSrGdI9rycTFPi79U8XNW/GkhdO
   qQLuPyTxwOepiykYEPyumUj7zHOOM5U3r2suftI0hS0iw0mrAG7Rwhl4s
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="298832519"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="298832519"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 09:38:02 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="676903764"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="676903764"
Received: from xwang-mobl1.amr.corp.intel.com (HELO [10.212.177.221]) ([10.212.177.221])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 09:38:01 -0800
Message-ID: <c93a0fed-23d8-addd-b6ac-cd4076d0a528@intel.com>
Date:   Wed, 30 Nov 2022 09:37:59 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v7 17/20] x86/virt/tdx: Configure global KeyID on all
 packages
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, seanjc@google.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, rafael.j.wysocki@intel.com,
        kirill.shutemov@linux.intel.com, ying.huang@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com,
        tony.luck@intel.com, peterz@infradead.org, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com
References: <cover.1668988357.git.kai.huang@intel.com>
 <8d8285cc5efa6302cf42a3fe2c9153d1a9dbcdac.1668988357.git.kai.huang@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <8d8285cc5efa6302cf42a3fe2c9153d1a9dbcdac.1668988357.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/20/22 16:26, Kai Huang wrote:
> After the array of TDMRs and the global KeyID are configured to the TDX
> module, use TDH.SYS.KEY.CONFIG to configure the key of the global KeyID
> on all packages.

I want to circle back to this because it potentially has the same class
of issue that TDH.SYS.LP.INIT had.  So, here's some more background
followed by the key question: is TDH.SYS.KEY.CONFIG too strict?  Should
we explore relaxing it?

Here's the very long-winded way of asking the same thing:

This key is used to protect TDX module memory which is too large to fit
into the limited range-register-protected (SMRR) areas that most of the
module uses.  Right now, that metadata includes the Physical Address
Metadata Tables (PAMT) and "TD Root" (TDR) pages.  Using this "global
KeyID" provides stronger isolation and integrity protection for these
structures than is provided by KeyID-0.

The "global KeyID" only strictly needs to be programmed into a memory
controllers if a PAMT or TDR page is allocated in memory attached to
that controller.  However, the TDX module currently requires that
TDH.SYS.KEY.CONFIG be executed on one processor in each package.  This
is true even if there is no TDX Memory Region (TDMR) attached to that
package.

This was likely done for simplicity in the TDX module.  It currently has
no NUMA awareness (or even trusted NUMA metadata) and no ability to
correlate processor packages with the memory attached to their memory
controllers.

The TDH.SYS.KEY.CONFIG design is actually pretty similar to Kirill's
MKTME implementation[1].  Basically blast the KeyID configuration out to
one processor in each package, regardless of whether the KeyID will ever
get used on that package.

While this requirement from the TDX module is _slightly_ too strict, I'm
not quite as worried about it as I was about the *super* strict
TDH.SYS.LP.INIT requirements.  It's a lot harder and more rare to have
an entire package of CPUs unavailable versus a single logical CPU.
There is, for instance, no side-channel mitigation that disables an
entire package worth of CPUs.  I'm not even sure if we allow an entire
package worth of NOHZ_FULL-indisposed processors.

I'm happy to go run the same drill for TDH.SYS.KEY.CONFIG that we did
for TDH.SYS.LP.INIT.  Basically, can we relax the too-strict
restrictions?  But, I'm not sure anyone will ever reap a practical
benefit from it.  I'm tempted to just leave it as-is.

Does anyone feel differently?

1.
https://lore.kernel.org/lkml/20190508144422.13171-1-kirill.shutemov@linux.intel.com/T/#m936f260a345284687f8e929675f68f3d514725f5


