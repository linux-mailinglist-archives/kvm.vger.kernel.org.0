Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A20B6A77B7
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 00:37:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbjCAXh2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 18:37:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjCAXh0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 18:37:26 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F151151FB0;
        Wed,  1 Mar 2023 15:37:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677713845; x=1709249845;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=FgO69G8MZkaqniX2vBowz6BTvzzRuECLqSJBvz0Dm10=;
  b=NJUz1aWxW2NuNBhZownkqN45RYur+uA3c1yWhf6ANeeWOv4gNnYemmdF
   CX7T3Ps1wnSaiidhEj+N7COg8zQuptBmdRmg5IbkIpN6Coox4w+YPdHox
   01HlC1b8O2lMqYielRkgsrRBl72dsD58p4+RML/BvTkZhdprbmIDzjkEp
   4bTl+yZYH1oLH51yn/WRn5SjjAtbTBtbgZOdBrn483LhsFYny0UN93T02
   bCvIGy1v8/bkrYNpVGTtIoV3Y+pz0k8x2MB9tfWVCJNNN7IaPgmInZouD
   EuPqvZbd1ZS2vHBh0aAoBGF7pGjne9i6ZSPbMDBne4av3C8k+jJCHT8LV
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10636"; a="314223225"
X-IronPort-AV: E=Sophos;i="5.98,225,1673942400"; 
   d="scan'208";a="314223225"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2023 15:37:01 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10636"; a="705033304"
X-IronPort-AV: E=Sophos;i="5.98,225,1673942400"; 
   d="scan'208";a="705033304"
Received: from asaha3-mobl1.amr.corp.intel.com (HELO [10.251.12.67]) ([10.251.12.67])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2023 15:37:00 -0800
Message-ID: <f664f44d-fc0a-1af7-070c-306ab100bbc9@intel.com>
Date:   Wed, 1 Mar 2023 15:37:00 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH RFC v8 48/56] KVM: SVM: Add SNP-specific handling for
 memory attribute updates
Content-Language: en-US
To:     Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc:     linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        bp@alien8.de, vbabka@suse.cz, kirill@shutemov.name,
        ak@linux.intel.com, tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org, ashish.kalra@amd.com,
        nikunj.dadhania@amd.com
References: <20230220183847.59159-1-michael.roth@amd.com>
 <20230220183847.59159-49-michael.roth@amd.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <20230220183847.59159-49-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE,T_FILL_THIS_FORM_SHORT
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/20/23 10:38, Michael Roth wrote:
> +		/*
> +		 * TODO: The RMP entry's hugepage bit is ignored for
> +		 * shared/unassigned pages. Either handle looping through each
> +		 * sub-page as part of snp_make_page_shared(), or remove the
> +		 * level argument.
> +		 */
> +		if (op == SNP_PAGE_STATE_PRIVATE && order &&
> +		    IS_ALIGNED(gfn, 1 << order) && (gfn + (1 << order)) <= end) {
> +			level = order_to_level(order);
> +			npages = 1 << order;
> +		}

That's a wee bit obtuse.

First of all, I assume that the 'RFC' is because of these TODOs and they
won't survive to the point when you ask for this to be merged.

BTW, what keeps the restrictedmem_get_page() offset and the gfn aligned?

Let's start with this:

> +static inline u8 order_to_level(int order)
> +{
> +	BUILD_BUG_ON(KVM_MAX_HUGEPAGE_LEVEL > PG_LEVEL_1G);
> +
> +	if (order >= KVM_HPAGE_GFN_SHIFT(PG_LEVEL_1G))
> +		return PG_LEVEL_1G;
> +
> +	if (order >= KVM_HPAGE_GFN_SHIFT(PG_LEVEL_2M))
> +		return PG_LEVEL_2M;
> +
> +	return PG_LEVEL_4K;
> +}

Right now, 'order' comes only from restrictedmem_get_page(), which I dug
out of:

> https://github.com/mdroth/linux/commit/c6792672cd11737fd255dff10b2d5b6bccc626a8

That order is *only* filled in by THPs.  That makes the PG_LEVEL_1G
stuff here kinda silly.  I guess it might be seen as thorough, but it's
dead code.  I'd probably just make this work on order==9 || order==0 and
warn on anything else.

I'd also highly recommend some comments about how racy this all is.  I
guess it probably works, but it would be good to add some comments about
page splits and collapsing.

It's also not obvious why this only cares about private pages.

Anyway, this is the exact kind of thing where I really like a
well-commented helper:

bool can_install_large_rmp_entry(gfn, order)
{
	// small pages, blah blah
	if (!order)
		return false;

	// The region being updated must be aligned
	if (!IS_ALIGNED(gfn, 1 << order))
		return false;
	// ... and fit
	if (gfn + (1 << order)) > end)
		return false;

	return true;	
}

Which gets used like this:

	if (op == SNP_PAGE_STATE_PRIVATE &&
	    can_install_large_rmp_entry(gfn, order)) {
		level = ...
	}
