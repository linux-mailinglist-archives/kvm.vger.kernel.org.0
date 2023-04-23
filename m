Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A9076EBC8A
	for <lists+kvm@lfdr.de>; Sun, 23 Apr 2023 05:07:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230159AbjDWDH0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 Apr 2023 23:07:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbjDWDHY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 22 Apr 2023 23:07:24 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E33E6211C
        for <kvm@vger.kernel.org>; Sat, 22 Apr 2023 20:07:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682219242; x=1713755242;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=miBmhrALR/hRCIivoqB2zBdPO5BGaAENvrZHHghOdus=;
  b=ZllqY8X4RSxzb6tcui2HuKu+0Z9OqZ6psfTXvYfwC21iI3FzEAW9SMKT
   nPO/Dw5Hyhu9irKO3t2tpddvCRcIc/toVhA4lYmrc/3nUzbV9pAoSlk6Y
   MjuQZmEKYDK+378VVwTm1auzyrEwDrynW0+xU/+6AdI4QNOmvAWDfBjW3
   RYpVsxbfaitK5/HxNyyA380U5tGT5RkPYx9gurIK4r/ZJfxFqxq7YfhPl
   f/z1rA+7GKDECTkopgBNrUMYJCzUumiaC4VSVg+IxrRjN/I+7ZEJV8rku
   nPsx+7kYOiiVCC6c+bgTTIFyEuIGBL3OYqvgaTsEvgV7XLzRwsWXSlR7+
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10688"; a="344985182"
X-IronPort-AV: E=Sophos;i="5.99,219,1677571200"; 
   d="scan'208";a="344985182"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2023 20:07:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10688"; a="692657945"
X-IronPort-AV: E=Sophos;i="5.99,219,1677571200"; 
   d="scan'208";a="692657945"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.254.214.112]) ([10.254.214.112])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2023 20:07:20 -0700
Message-ID: <a380bdd5-c986-c829-3aa3-bcf28b7e4df6@linux.intel.com>
Date:   Sun, 23 Apr 2023 11:07:18 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [kvm-unit-tests v3 3/4] x86: Add test cases for LAM_{U48,U57}
To:     Chao Gao <chao.gao@intel.com>
Cc:     kvm@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com,
        robert.hu@linux.intel.com
References: <20230412075134.21240-1-binbin.wu@linux.intel.com>
 <20230412075134.21240-4-binbin.wu@linux.intel.com>
 <ZEIZu7Qp5jaYsgLn@chao-email>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <ZEIZu7Qp5jaYsgLn@chao-email>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/21/2023 1:06 PM, Chao Gao wrote:
> On Wed, Apr 12, 2023 at 03:51:33PM +0800, Binbin Wu wrote:
>> This unit test covers:
>> 1. CR3 LAM bits toggles.
>> 2. Memory/MMIO access with user mode address containing LAM metadata.
>>
>> Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
> Reviewed-by: Chao Gao <chao.gao@intel.com>
>
> two nits below:
>
>> ---
>> +static void test_lam_user(bool has_lam)
>> +{
>> +	phys_addr_t paddr;
>> +	unsigned long cr3 = read_cr3();
>> +
>> +	/*
>> +	 * The physical address width is within 36 bits, so that using identical
>> +	 * mapping, the linear address will be considered as user mode address
>> +	 * from the view of LAM.
>> +	 */
> Why 36 bits (i.e., 64G)?

KUT memory allocator supports 4 Memory Areas:
AREA_NORMAL, AREA_HIGH, AREA_LOW and AREA_LOWEST.
AREA_NORMAL has the maximum address width, which is 36 bits.

How about change the comment to this:

+	/*
+	 * The physical address width supported by KUT memory allocator is within 36 bits,
+	 * so that using identical mapping, the linear address will be considered as user
+        * mode address from the view of LAM.
+	 */


>
> would you mind adding a comment in patch 2 to explain why the virtual
> addresses are kernel mode addresses?

OK. Will add the following comments:

     /*
      * KUT initializes vfree_top to 0 for X86_64, and each virtual address
      * allocation decreases the size from vfree_top. It's guaranteed that
      * the return value of alloc_vpage() is considered as kernel mode
      * address and canonical since only a small mount virtual address range
      * is allocated in this test.
      */



>
>> +	paddr = virt_to_phys(alloc_page());
>> +	install_page((void *)cr3, paddr, (void *)paddr);
>> +	install_page((void *)cr3, IORAM_BASE_PHYS, (void *)IORAM_BASE_PHYS);
> are the two lines necessary?

The two lines are not necessary.
Check setup_mmu(), it already sets up the identical mapping for avialble 
physcial memory/MMIO.
Will remove them.


>
>> +
>> +	test_lam_user_mode(has_lam, LAM48_MASK, paddr, IORAM_BASE_PHYS);
>> +	test_lam_user_mode(has_lam, LAM57_MASK, paddr, IORAM_BASE_PHYS);
>> +}
>> +
>> int main(int ac, char **av)
>> {
>> 	bool has_lam;
>> @@ -239,6 +309,7 @@ int main(int ac, char **av)
>> 			    "use kvm.force_emulation_prefix=1 to enable\n");
>>
>> 	test_lam_sup(has_lam, fep_available);
>> +	test_lam_user(has_lam);
>>
>> 	return report_summary();
>> }
>> -- 
>> 2.25.1
>>
