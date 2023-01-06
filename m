Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 655C8660945
	for <lists+kvm@lfdr.de>; Fri,  6 Jan 2023 23:08:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236232AbjAFWIC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Jan 2023 17:08:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235927AbjAFWHt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Jan 2023 17:07:49 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A60184BCB;
        Fri,  6 Jan 2023 14:07:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673042869; x=1704578869;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=PUhwpAPx9QoZBSVf0J1Kqv9kcSs4Ha7qkZRGZTH8vzQ=;
  b=EWVv+6XcGEfVmVjZEuznc4i9AQd0FXp+Dgaot8lxGEqj9H8pOQTF8SAq
   IBXUd2v04Aov6TQ80Ihmx86D1s6us9FbhAOIyjY4OnDwyps1crrkOGLKe
   i7Obz/pNLQSv3HLV7X6tFUd4pmEkOLTuTRjqKoSc9C1cL5v8KHyPGM5jd
   +uK5byOCoeKoGQBkRl1fHCbHE38Dy3tAtyI1Oe6IwKJoV94lmhCOHJqdO
   4rOsCoqazpcWAAXXXcl84PjH5KEDu25Y1Mp8hgsX31hddtW+IqLZaGrfl
   sz1fEd776yOhhuQGPtiDRG0kf1khTGZF4BX7g+jm5dtUp0vMmb/EnR5dT
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="349787228"
X-IronPort-AV: E=Sophos;i="5.96,306,1665471600"; 
   d="scan'208";a="349787228"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 14:07:48 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="649436711"
X-IronPort-AV: E=Sophos;i="5.96,306,1665471600"; 
   d="scan'208";a="649436711"
Received: from xiangyuy-mobl.amr.corp.intel.com (HELO [10.212.251.186]) ([10.212.251.186])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 14:07:47 -0800
Message-ID: <2d7d2824-7aa7-5f96-d79b-b44ff7fe2ef9@intel.com>
Date:   Fri, 6 Jan 2023 14:07:47 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v8 11/16] x86/virt/tdx: Designate reserved areas for all
 TDMRs
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, peterz@infradead.org, tglx@linutronix.de,
        seanjc@google.com, pbonzini@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, kirill.shutemov@linux.intel.com,
        ying.huang@intel.com, reinette.chatre@intel.com,
        len.brown@intel.com, tony.luck@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com
References: <cover.1670566861.git.kai.huang@intel.com>
 <27dcd2781a450b3f77a2aec833de6a3669bc0fb8.1670566861.git.kai.huang@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <27dcd2781a450b3f77a2aec833de6a3669bc0fb8.1670566861.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/8/22 22:52, Kai Huang wrote:
> +static int tdmr_add_rsvd_area(struct tdmr_info *tdmr, int *p_idx, u64 addr,
> +			      u64 size, u16 max_reserved_per_tdmr)
> +{
> +	struct tdmr_reserved_area *rsvd_areas = tdmr->reserved_areas;
> +	int idx = *p_idx;
> +
> +	/* Reserved area must be 4K aligned in offset and size */
> +	if (WARN_ON(addr & ~PAGE_MASK || size & ~PAGE_MASK))
> +		return -EINVAL;
> +
> +	if (idx >= max_reserved_per_tdmr)
> +		return -E2BIG;
> +
> +	rsvd_areas[idx].offset = addr - tdmr->base;
> +	rsvd_areas[idx].size = size;
> +
> +	*p_idx = idx + 1;
> +
> +	return 0;
> +}

It's probably worth at least a comment here to say:

	/*
	 * Consume one reserved area per call.  Make no effort to
	 * optimize or reduce the number of reserved areas which are
	 * consumed by contiguous reserved areas, for instance.
	 */

I think the -E2BIG is also wrong.  It should be ENOSPC.  I'd also add a
pr_warn() there.  Especially with how lazy this whole thing is, I can
start to see how the reserved areas might be exhausted.  Let's be kind
to our future selves and make the error (and the fix) easier to find.

It's probably also worth noting *somewhere* that there's a balance to be
had between TDMRs and reserved areas.  A system that is running out of
reserved areas in a TDMR could split a TDMR to get more reserved areas.
A system that has run out of TDMRs could relatively easily coalesce two
adjacent TDMRs (before the PAMTs are allocated) and use a reserved area
if there was a gap between them.

I'm *really* close to acking this patch once those are fixed up.
