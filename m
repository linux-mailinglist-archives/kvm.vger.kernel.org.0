Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 146754E8B9A
	for <lists+kvm@lfdr.de>; Mon, 28 Mar 2022 03:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237273AbiC1Bbv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Mar 2022 21:31:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237266AbiC1Bbu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 27 Mar 2022 21:31:50 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7EFC192A3;
        Sun, 27 Mar 2022 18:30:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648431010; x=1679967010;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=beeEYxcAp4r2iI1wWi4YsTfFuc4wGRqsztjNxGViHVo=;
  b=XO8g38G2bWH4+JnyjpMH6hxOntFrTFxmN/dc2izRzl2LkLfjpUWGS2r+
   a2X27CFZf7WAhfKbrRLiCTkJMdu6d8WR0eO6ztj9uekGE/z7QIkp8heqd
   OXKC0WgCnwMLxCiWOibsaDvwnfU6kz+CyiCZa+b1oeB4kAo14QJFyq+bs
   MJ3YFx/3WS6/PYFjaZwbCKlTdT4Kg0RDTKwrTF2ZqxVR2AmEZCkiyoGt4
   2xhhVuk+2xuy/2B5v1V63L1AlqRiIWwpXSPVqOXuMe9/ZEbeMaiQGNiO/
   jko2p/F6lfPfS6TW1sSzbzP6Lrif7up/PQahfQ9TUtx/Gmtuthq4Ei2jH
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10299"; a="257718836"
X-IronPort-AV: E=Sophos;i="5.90,216,1643702400"; 
   d="scan'208";a="257718836"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2022 18:30:10 -0700
X-IronPort-AV: E=Sophos;i="5.90,216,1643702400"; 
   d="scan'208";a="585016682"
Received: from stung2-mobl.gar.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.255.94.73])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2022 18:30:07 -0700
Message-ID: <f211441a6d23321e22517684159e2c28c8492b86.camel@intel.com>
Subject: Re: [PATCH v2 09/21] x86/virt/tdx: Get information about TDX module
 and convertible memory
From:   Kai Huang <kai.huang@intel.com>
To:     Isaku Yamahata <isaku.yamahata@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        dave.hansen@intel.com, seanjc@google.com, pbonzini@redhat.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, peterz@infradead.org,
        tony.luck@intel.com, ak@linux.intel.com, dan.j.williams@intel.com,
        isaku.yamahata@intel.com
Date:   Mon, 28 Mar 2022 14:30:05 +1300
In-Reply-To: <20220324174301.GA1212881@ls.amr.corp.intel.com>
References: <cover.1647167475.git.kai.huang@intel.com>
         <98c1010509aa412e7f05b12187cacf40451d5246.1647167475.git.kai.huang@intel.com>
         <20220324174301.GA1212881@ls.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> > +
> > +static int sanitize_cmrs(struct cmr_info *cmr_array, int cmr_num)
> > +{
> > +	int i, j;
> > +
> > +	/*
> > +	 * Intel TDX module spec, 20.7.3 CMR_INFO:
> > +	 *
> > +	 *   TDH.SYS.INFO leaf function returns a MAX_CMRS (32) entry
> > +	 *   array of CMR_INFO entries. The CMRs are sorted from the
> > +	 *   lowest base address to the highest base address, and they
> > +	 *   are non-overlapping.
> > +	 *
> > +	 * This implies that BIOS may generate invalid empty entries
> > +	 * if total CMRs are less than 32.  Skip them manually.
> > +	 */
> > +	for (i = 0; i < cmr_num; i++) {
> > +		struct cmr_info *cmr = &cmr_array[i];
> > +		struct cmr_info *prev_cmr = NULL;
> > +
> > +		/* Skip further invalid CMRs */
> > +		if (!cmr_valid(cmr))
> > +			break;
> > +
> > +		if (i > 0)
> > +			prev_cmr = &cmr_array[i - 1];
> > +
> > +		/*
> > +		 * It is a TDX firmware bug if CMRs are not
> > +		 * in address ascending order.
> > +		 */
> > +		if (prev_cmr && ((prev_cmr->base + prev_cmr->size) >
> > +					cmr->base)) {
> > +			pr_err("Firmware bug: CMRs not in address ascending order.\n");
> > +			return -EFAULT;
> > +		}
> > +	}
> > +
> > +	/*
> > +	 * Also a sane BIOS should never generate invalid CMR(s) between
> > +	 * two valid CMRs.  Sanity check this and simply return error in
> > +	 * this case.
> > +	 */
> > +	for (j = i; j < cmr_num; j++)
> > +		if (cmr_valid(&cmr_array[j])) {
> > +			pr_err("Firmware bug: invalid CMR(s) among valid CMRs.\n");
> > +			return -EFAULT;
> > +		}
> 
> This check doesn't make sense because above i-for loop has break.

The break in above i-for loop will hit at the first invalid CMR entry.  Yes "j =
i" will make double check on this invalid CMR entry, but it should have no
problem.  Or we can change to "j = i + 1" to skip the first invalid CMR entry.

Does this make sense?

> 
> > +
> > +	/*
> > +	 * Trim all tail invalid empty CMRs.  BIOS should generate at
> > +	 * least one valid CMR, otherwise it's a TDX firmware bug.
> > +	 */
> > +	tdx_cmr_num = i;
> > +	if (!tdx_cmr_num) {
> > +		pr_err("Firmware bug: No valid CMR.\n");
> > +		return -EFAULT;
> > +	}
> 
> Something strange.
> Probably we'd like to check it by decrementing.
> for (i = cmr_num; i >= 0; i--)
>   if (!cmr_valid()) // if last invalid cmr
>      tdx_cmr_num
>   // more check. overlapping
> 

I don't know how does this look strange to you? As replied above, "i" is the
index to the first invalid CMR entry (or cmr_num, which is array size), so
"tdx_cmr_num = i" initializes the total valid CMR number, correct?
