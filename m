Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E8B57236F0
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 07:47:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233748AbjFFFr0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 01:47:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233891AbjFFFrN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 01:47:13 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47B9CB0
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 22:47:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686030431; x=1717566431;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=83Rj93jkR1HTPLlo3NBLnWf+4pu0cA9y29h88jLuWR0=;
  b=mpzVqiZ24J6fC/ywhmhgaV7YdODKj5r2gp8SYt/RzNK9D2vqi3RvG+qO
   U3WNtb3lnqhemBIe7D7O6r9ymSTkGSkS7M/NWFXbDTZcrNxlIYxgClAQ+
   4yetpAqB29yRH7jSm4svtOIOkVRZuMxN5927GnZBdete7lz4wWPcumkiU
   YzGKbski86pL8haxsFft2mOeoMxJXqMouRKflVDSkCaFtsjaupsnhBCbA
   2Xbf97YlcHqcwMHuRl/m+RgthmAGV0Zo5xu6AxQWqnnHD7EKah/YVaIVw
   9k9diu5m7WzJbePdNHtrVGEC3RhqPtRk2V+TA8qkM9eKkiGu47ZD1RUWY
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="420119216"
X-IronPort-AV: E=Sophos;i="6.00,219,1681196400"; 
   d="scan'208";a="420119216"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2023 22:47:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="955610184"
X-IronPort-AV: E=Sophos;i="6.00,219,1681196400"; 
   d="scan'208";a="955610184"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.249.170.159]) ([10.249.170.159])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2023 22:47:09 -0700
Message-ID: <fa4a405f-0ee6-c6de-7947-e56c4ee22734@linux.intel.com>
Date:   Tue, 6 Jun 2023 13:47:07 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH v5 4/4] x86: Add test case for INVVPID with LAM
To:     Chao Gao <chao.gao@intel.com>
Cc:     kvm@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com,
        robert.hu@linux.intel.com
References: <20230530024356.24870-1-binbin.wu@linux.intel.com>
 <20230530024356.24870-5-binbin.wu@linux.intel.com>
 <ZH3hqvoaQkQ8qK/n@chao-email>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <ZH3hqvoaQkQ8qK/n@chao-email>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/5/2023 9:22 PM, Chao Gao wrote:
> On Tue, May 30, 2023 at 10:43:56AM +0800, Binbin Wu wrote:
>> LAM applies to the linear address of INVVPID operand, however,
>> it doesn't apply to the linear address in the INVVPID descriptor.
>>
>> The added cases use tagged operand or tagged target invalidation
>> address to make sure the behaviors are expected when LAM is on.
>>
>> Also, INVVPID case using tagged operand can be used as the common
>> test cases for VMX instruction VMExits.
>>
>> Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
>> ---
>> x86/vmx_tests.c | 46 +++++++++++++++++++++++++++++++++++++++++++++-
>> 1 file changed, 45 insertions(+), 1 deletion(-)
>>
>> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
>> index 217befe..3f3f203 100644
>> --- a/x86/vmx_tests.c
>> +++ b/x86/vmx_tests.c
>> @@ -3225,6 +3225,48 @@ static void invvpid_test_not_in_vmx_operation(void)
>> 	TEST_ASSERT(!vmx_on());
>> }
>>
>> +/* LAM applies to the target address inside the descriptor of invvpid */
> This isn't correct. LAM doesn't apply to that address. Right?
Oops, will fix it, thanks.

>
>> +static void invvpid_test_lam(void)
>> +{
>> +	void *vaddr;
>> +	struct invvpid_operand *operand;
>> +	u64 lam_mask = LAM48_MASK;
>> +	bool fault;
>> +
>> +	if (!this_cpu_has(X86_FEATURE_LAM)) {
>> +		report_skip("LAM is not supported, skip INVVPID with LAM");
>> +		return;
>> +	}
>> +	write_cr4_safe(read_cr4() | X86_CR4_LAM_SUP);
> why write_cr4_safe()?
>
> This should succeed if LAM is supported. So it is better to use
> write_cr4() because write_cr4() has an assertion which can catch
> unexpected exceptions.
OK.

>
>> +
>> +	if (this_cpu_has(X86_FEATURE_LA57) && read_cr4() & X86_CR4_LA57)
>> +		lam_mask = LAM57_MASK;
>> +
>> +	vaddr = alloc_vpage();
>> +	install_page(current_page_table(), virt_to_phys(alloc_page()), vaddr);
>> +	/*
>> +	 * Since the stack memory address in KUT doesn't follow kernel address
>> +	 * space partition rule, reuse the memory address for descriptor and
>> +	 * the target address in the descriptor of invvpid.
>> +	 */
>> +	operand = (struct invvpid_operand *)vaddr;
>> +	operand->vpid = 0xffff;
>> +	operand->gla = (u64)vaddr;
>> +	operand = (struct invvpid_operand *)set_la_non_canonical((u64)operand,
>> +								 lam_mask);
>> +	fault = test_for_exception(GP_VECTOR, ds_invvpid, operand);
>> +	report(!fault, "INVVPID (LAM on): tagged operand");
>> +
>> +	/*
>> +	 * LAM doesn't apply to the address inside the descriptor, expected
>> +	 * failure and VMXERR_INVALID_OPERAND_TO_INVEPT_INVVPID set in
>> +	 * VMX_INST_ERROR.
>> +	 */
> Maybe
>
> 	/*
> 	 * Verify that LAM doesn't apply to the address inside the descriptor
> 	 * even when LAM is enabled. i.e., the address in the descriptor should
> 	 * be canonical.
> 	 */
>> +	try_invvpid(INVVPID_ADDR, 0xffff, NONCANONICAL);
> shouldn't we use a kernel address here? e.g., vaddr. otherwise, we
> cannot tell if there is an error in KVM's emulation because in this
> test, LAM is enabled only for kernel address while INVVPID_ADDR is a
> userspace address.

INVVPID_ADDR is the invalidation type, not the address.
The address used  here is NONCANONICAL, which is 0xaaaaaaaaaaaaaaaaull and
is considered as kernel address.

>
>> +
>> +	write_cr4_safe(read_cr4() & ~X86_CR4_LAM_SUP);
> ditto.
>
> With all above fixed:
>
> Reviewed-by: Chao Gao <chao.gao@intel.com>
>
>
>> +}
>> +
>> /*
>>   * This does not test real-address mode, virtual-8086 mode, protected mode,
>>   * or CPL > 0.
>> @@ -3274,8 +3316,10 @@ static void invvpid_test(void)
>> 	/*
>> 	 * The gla operand is only validated for single-address INVVPID.
>> 	 */
>> -	if (types & (1u << INVVPID_ADDR))
>> +	if (types & (1u << INVVPID_ADDR)) {
>> 		try_invvpid(INVVPID_ADDR, 0xffff, NONCANONICAL);
>> +		invvpid_test_lam();
>> +	}
>>
>> 	invvpid_test_gp();
>> 	invvpid_test_ss();
>> -- 
>> 2.25.1
>>

