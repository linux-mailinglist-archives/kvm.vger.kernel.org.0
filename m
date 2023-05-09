Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0458A6FBC94
	for <lists+kvm@lfdr.de>; Tue,  9 May 2023 03:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233624AbjEIBip (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 May 2023 21:38:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbjEIBin (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 May 2023 21:38:43 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF8B14215
        for <kvm@vger.kernel.org>; Mon,  8 May 2023 18:38:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683596322; x=1715132322;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=zqT/kA3NuouuRPjW99xcvp5B6gwgFhVt6TNhnuge4hg=;
  b=XkiVwhX5Gcqp3CP0S5UV94UuoWHurujN/RxMT3wL/0jLtZkBC0d069jt
   QvQ5cIIQIpnyuxpyq9abVmjVP7bIhMxeASegXbnfqAj+RqHhqzKc2JSjh
   dysLN+di59jcDcCsoXdOcLnSbKPZ2WcCtZ1TemmeMfd5WlpWLs/QohO9M
   T+yfveVOl+MqzVM6Owz5UdZ0i7WuEkThRVtvk98eyxudsdUFPpreqYShX
   31ji/fQxxgwLAjbZh+wnnRcllRdXAPSX6LaRXSxV21Ehpo7oFMQSFaElf
   bKfFFyxIjdlTtmiQCAAkEWMkDrJpz2s8QR5jw9ywZQrtUTrHDXA/+NyJ4
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10704"; a="352849820"
X-IronPort-AV: E=Sophos;i="5.99,259,1677571200"; 
   d="scan'208";a="352849820"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2023 18:38:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10704"; a="731501156"
X-IronPort-AV: E=Sophos;i="5.99,259,1677571200"; 
   d="scan'208";a="731501156"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.8.90]) ([10.238.8.90])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2023 18:38:41 -0700
Message-ID: <198546a7-7ffd-480f-c4e9-17196cd2884d@linux.intel.com>
Date:   Tue, 9 May 2023 09:38:39 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [kvm-unit-tests v4 4/4] x86: Add test case for INVVPID with LAM
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, chao.gao@intel.com,
        robert.hu@linux.intel.com
References: <20230504084751.968-1-binbin.wu@linux.intel.com>
 <20230504084751.968-5-binbin.wu@linux.intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20230504084751.968-5-binbin.wu@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/4/2023 4:47 PM, Binbin Wu wrote:
> When LAM is on, the linear address of INVVPID operand can contain
> metadata, and the linear address in the INVVPID descriptor can
> contain metadata.
>
> The added cases use tagged descriptor address or/and tagged target
> invalidation address to make sure the behaviors are expected when
> LAM is on.
> Also, INVVPID cases can be used as the common test cases for VMX
> instruction VMExits.
>
> Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
> Reviewed-by: Chao Gao <chao.gao@intel.com>
> ---
>   x86/vmx_tests.c | 52 ++++++++++++++++++++++++++++++++++++++++++++++++-
>   1 file changed, 51 insertions(+), 1 deletion(-)
>
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index 217befe..678c9ec 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -3225,6 +3225,54 @@ static void invvpid_test_not_in_vmx_operation(void)
>   	TEST_ASSERT(!vmx_on());
>   }
>   
> +/* LAM applies to the target address inside the descriptor of invvpid */
> +static void invvpid_test_lam(void)
> +{
> +	void *vaddr;
> +	struct invvpid_operand *operand;
> +	u64 lam_mask = LAM48_MASK;
> +	bool fault;
> +
> +	if (!this_cpu_has(X86_FEATURE_LAM)) {
> +		report_skip("LAM is not supported, skip INVVPID with LAM");
> +		return;
> +	}
> +	write_cr4_safe(read_cr4() | X86_CR4_LAM_SUP);
> +
> +	if (this_cpu_has(X86_FEATURE_LA57) && read_cr4() & X86_CR4_LA57)
> +		lam_mask = LAM57_MASK;
> +
> +	vaddr = alloc_vpage();
> +	install_page(current_page_table(), virt_to_phys(alloc_page()), vaddr);
> +	/*
> +	 * Since the stack memory address in KUT doesn't follow kernel address
> +	 * space partition rule, reuse the memory address for descriptor and
> +	 * the target address in the descriptor of invvpid.
> +	 */
> +	operand = (struct invvpid_operand *)vaddr;
> +	operand->vpid = 0xffff;
> +	operand->gla = (u64)vaddr;
> +
> +	operand = (struct invvpid_operand *)vaddr;
> +	operand->gla = set_la_non_canonical(operand->gla, lam_mask);
> +	fault = test_for_exception(GP_VECTOR, ds_invvpid, operand);
> +	report(!fault, "INVVPID (LAM on): untagged pointer + tagged addr");
> +
> +	operand = (struct invvpid_operand *)set_la_non_canonical((u64)operand,
> +								 lam_mask);
> +	operand->gla = (u64)vaddr;
> +	fault = test_for_exception(GP_VECTOR, ds_invvpid, operand);
> +	report(!fault, "INVVPID (LAM on): tagged pointer + untagged addr");
> +
> +	operand = (struct invvpid_operand *)set_la_non_canonical((u64)operand,
> +								 lam_mask);
> +	operand->gla = set_la_non_canonical(operand->gla, lam_mask);
> +	fault = test_for_exception(GP_VECTOR, ds_invvpid, operand);
> +	report(!fault, "INVVPID (LAM on): tagged pointer + tagged addr");
The test cases designed for invvpid with LAM is not right.

Will use two test cases to test invvpid when LAM is activated:
One to test with tagged operand expecting no #GP.
The other one to test with tagged target address inside the descriptor 
expecting failure and VMXERR_INVALID_OPERAND_TO_INVEPT_INVVPID set in 
VMX_INST_ERROR field of VMCS.

The new test code proposed as below:

     ....
     operand = (struct invvpid_operand *)vaddr;
     operand->vpid = 0xffff;
     operand->gla = (u64)vaddr;
     operand = (struct invvpid_operand *)set_la_non_canonical((u64)operand,
                                  lam_mask);
     fault = test_for_exception(GP_VECTOR, ds_invvpid, operand);
     report(!fault, "INVVPID (LAM on): tagged operand");

     /*
      * LAM doesn't apply to the address inside the descriptor, expected
      * failure and VMXERR_INVALID_OPERAND_TO_INVEPT_INVVPID set in
      * VMX_INST_ERROR.
      */
     try_invvpid(INVVPID_ADDR, 0xffff, NONCANONICAL);


> +
> +	write_cr4_safe(read_cr4() & ~X86_CR4_LAM_SUP);
> +}
> +
>   /*
>    * This does not test real-address mode, virtual-8086 mode, protected mode,
>    * or CPL > 0.
> @@ -3274,8 +3322,10 @@ static void invvpid_test(void)
>   	/*
>   	 * The gla operand is only validated for single-address INVVPID.
>   	 */
> -	if (types & (1u << INVVPID_ADDR))
> +	if (types & (1u << INVVPID_ADDR)) {
>   		try_invvpid(INVVPID_ADDR, 0xffff, NONCANONICAL);
> +		invvpid_test_lam();
> +	}
>   
>   	invvpid_test_gp();
>   	invvpid_test_ss();

