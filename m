Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 207D8618097
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 16:08:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231901AbiKCPIT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Nov 2022 11:08:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231909AbiKCPHs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Nov 2022 11:07:48 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F25571DF11;
        Thu,  3 Nov 2022 08:05:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667487918; x=1699023918;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=g/Nc9Oh47t3xrBMy8uQ8PnTTBtTpjf2qN+cuKgODC74=;
  b=TnT0Xxr0FGBz42hYqscMaDwzzkLx1FtugJ5a+VjoO/NHoVKLg05EqgLA
   Tsx1OyYgMRRvSR5rmCbV9KiAU2DN0oTeeL+9rKIvPT3Jn0HpAIuk4plVl
   90Tl8dwhaxtUa1UaXk/qTcHS5dTWD9G+62DVRrAH/3aulknYjWbjMbhqj
   flNDTfspBU2sQgJL86G5soFF6OJe5M4MEtbPiUyizbqQC83ib/1HrUJ2H
   N4sqZ0cqBRCGxCQMAVB5Cvo1CHtYdn1QV6Qpd4vKLX2UWd4JhxxXsRGwH
   5JH3fHXIqSf52G3FjugKwbRNyDvweyoD8uTz467KPcTbfOzz9zp9h1DvS
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10520"; a="336406027"
X-IronPort-AV: E=Sophos;i="5.96,235,1665471600"; 
   d="scan'208";a="336406027"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2022 08:05:17 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10520"; a="585825682"
X-IronPort-AV: E=Sophos;i="5.96,235,1665471600"; 
   d="scan'208";a="585825682"
Received: from btoolex-mobl.amr.corp.intel.com (HELO [10.209.95.24]) ([10.209.95.24])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2022 08:05:15 -0700
Message-ID: <ded3e60e-035f-1feb-bb7d-43af0064c544@intel.com>
Date:   Thu, 3 Nov 2022 08:05:14 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v6 12/21] x86/virt/tdx: Add placeholder to construct TDMRs
 to cover all TDX memory regions
Content-Language: en-US
To:     Andi Kleen <ak@linux.intel.com>, Kai Huang <kai.huang@intel.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, seanjc@google.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, rafael.j.wysocki@intel.com,
        kirill.shutemov@linux.intel.com, reinette.chatre@intel.com,
        len.brown@intel.com, tony.luck@intel.com, peterz@infradead.org,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com
References: <cover.1666824663.git.kai.huang@intel.com>
 <fe0e1a1133166ca4008840cd1a5959fa70632f07.1666824663.git.kai.huang@intel.com>
 <f6d0b10a-94be-ff33-9742-058469078380@linux.intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <f6d0b10a-94be-ff33-9742-058469078380@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/27/22 08:31, Andi Kleen wrote:
> 
>> +/* Calculate the actual TDMR_INFO size */
>> +static inline int cal_tdmr_size(void)
>> +{
>> +    int tdmr_sz;
>> +
>> +    /*
>> +     * The actual size of TDMR_INFO depends on the maximum number
>> +     * of reserved areas.
>> +     */
>> +    tdmr_sz = sizeof(struct tdmr_info);
>> +    tdmr_sz += sizeof(struct tdmr_reserved_area) *
>> +           tdx_sysinfo.max_reserved_per_tdmr;
> 
> would seem safer to have a overflow check here.

tdmr_reserved_area is 16 bytes.  To overflow a signed int, tdmr_sz would
need to be for an allocation >2GB.  alloc_pages_exact() tops out at
supplying 4MB allocations.

So, sure, this breaks at max_reserved_per_tdmr>2^27, but it actually
breaks *EARLIER* at max_reserved_per_tdmr>2^18 because the page
allocator is borked.

Plus, max_reserved_per_tdmr is barely in double digits today.  It's a
*LOOOOOOOOONG* way from either of those limits.  If you want to add a
warning here, then go for it and enforce a sane value on
max_reserved_per_tdmr.

But, the overflow is *LITERALLY* an order of magnitude more obscure than
overwhelming the page allocator.  Let's not clutter up the code with
silly checks like that.
