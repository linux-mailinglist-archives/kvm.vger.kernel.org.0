Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01F96738707
	for <lists+kvm@lfdr.de>; Wed, 21 Jun 2023 16:31:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbjFUObi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jun 2023 10:31:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbjFUObh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jun 2023 10:31:37 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6279612E;
        Wed, 21 Jun 2023 07:31:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687357895; x=1718893895;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=O64wJ4h2FjMBRHsbamypZL1GWJNUE5Ay/zmz6Kb6Fbw=;
  b=QhJVop2jENEPwjbKZntHyZiGNSZuKE3HfYuEE0+NAvFXXjcyocIRV88t
   vZplUd9p33m6ayvnl9Lb1hBdc+VfbcbD92jJBsxXK6nKwId7LAzjXfgnc
   ZdSdnmcy/KmnUWb7Mtc+HZvfvNBbnUlj/6uqmYhmy4/LUrByzEjmagPRo
   MADNBAjNYtp5lQBdom4io7OSJVfsgLsX7TF4wY9pWCczkKP/wLmvgLvY3
   T1H7T78oenkkDqvuwC9wljseueIpAdp8NOy1Ti1F2sAE6dAT62AAVWWfD
   btQUaoxXudpNtliBp1xYMKcG+fpOAM5E/JHNAw/6jL0G+XEZ8Jy/NT40t
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10748"; a="349921498"
X-IronPort-AV: E=Sophos;i="6.00,260,1681196400"; 
   d="scan'208";a="349921498"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2023 07:31:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10748"; a="714507270"
X-IronPort-AV: E=Sophos;i="6.00,260,1681196400"; 
   d="scan'208";a="714507270"
Received: from rmathew-mobl2.amr.corp.intel.com (HELO [10.212.134.235]) ([10.212.134.235])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2023 07:31:34 -0700
Message-ID: <23f400bc-9a62-be4a-6a24-0e2149d4491c@intel.com>
Date:   Wed, 21 Jun 2023 07:31:34 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH RFC v9 07/51] x86/sev: Add the host SEV-SNP initialization
 support
Content-Language: en-US
To:     Borislav Petkov <bp@alien8.de>
Cc:     Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org, ashish.kalra@amd.com,
        nikunj.dadhania@amd.com, liam.merwick@oracle.com,
        zhi.a.wang@intel.com, Brijesh Singh <brijesh.singh@amd.com>
References: <20230612042559.375660-1-michael.roth@amd.com>
 <20230612042559.375660-8-michael.roth@amd.com>
 <12f95b38-427c-6810-373a-ba2062c43882@intel.com>
 <20230621091541.GEZJK/veTnfhOnX8ci@fat_crate.local>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <20230621091541.GEZJK/veTnfhOnX8ci@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/21/23 02:15, Borislav Petkov wrote:
> On Mon, Jun 12, 2023 at 08:34:02AM -0700, Dave Hansen wrote:
>> On 6/11/23 21:25, Michael Roth wrote:
>>> +	/*
>>> +	 * Calculate the amount the memory that must be reserved by the BIOS to
>>> +	 * address the whole RAM, including the bookkeeping area. The RMP itself
>>> +	 * must also be covered.
>>> +	 */
>>> +	max_rmp_pfn = max_pfn;
>>> +	if (PHYS_PFN(rmp_end) > max_pfn)
>>> +		max_rmp_pfn = PHYS_PFN(rmp_end);
>> Could you say a little here about how this deals with memory hotplug?
> Does SNP hw even support memory hotplug?
> 
> I think in order to support that, you'd need some special dance because
> of the RMP table etc...

Yep, there's the hardware side and then there are fun nuggets like using
mem= and then doing a software-only hot-add later after boot.

Also, if the hardware doesn't support any kind of hotplug, it would be
great to point to the place in the spec where it says that.
