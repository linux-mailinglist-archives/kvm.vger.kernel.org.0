Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7EA36EBD59
	for <lists+kvm@lfdr.de>; Sun, 23 Apr 2023 08:13:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbjDWGN0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 23 Apr 2023 02:13:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230162AbjDWGNY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 23 Apr 2023 02:13:24 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3017210C
        for <kvm@vger.kernel.org>; Sat, 22 Apr 2023 23:13:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682230401; x=1713766401;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=h59YgJHg3RnM7tUyHr+yoS38Krs7eXTdbOxuXnnU6WY=;
  b=MpVC5D/aIjQWHYAkqU09TiClVxnjS/LxaBWBMuW8sRXT/xZiqJU57WEI
   4kHEPFtbiF5BezDWA0cAo9wYXr2neXTwXUmWMbPWJkAUOkqzSnVQqhsru
   /LZAasNdXlx/G+b7v4bEg3bM5ITLwF94fiO07K0Fo2fupB4LfxfUOMd7L
   qrZTlFcmafIp6acBbdqB+0KMo9TCbgt0TIlOAZQwmFHvJOT4Al2QXOpr8
   giU0qCBA9dB3VFabSislM7uYvj5kBrbeLEYcw7OUiqYE0SGhnviNLYzO2
   fflPsmDHNauXBWASUl8M7iyKJsFzbTmmPbTDnnf+nJaM663Klps6hNMig
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10688"; a="345001830"
X-IronPort-AV: E=Sophos;i="5.99,219,1677571200"; 
   d="scan'208";a="345001830"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2023 23:13:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10688"; a="836578855"
X-IronPort-AV: E=Sophos;i="5.99,219,1677571200"; 
   d="scan'208";a="836578855"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.254.214.112]) ([10.254.214.112])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2023 23:13:19 -0700
Message-ID: <701ed57a-6b51-f03a-7296-71270668a014@linux.intel.com>
Date:   Sun, 23 Apr 2023 14:13:17 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [kvm-unit-tests v3 4/4] x86: Add test case for INVVPID with LAM
From:   Binbin Wu <binbin.wu@linux.intel.com>
To:     Chao Gao <chao.gao@intel.com>
Cc:     kvm@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com,
        robert.hu@linux.intel.com
References: <20230412075134.21240-1-binbin.wu@linux.intel.com>
 <20230412075134.21240-5-binbin.wu@linux.intel.com>
 <ZEIhQRMtWoZod345@chao-email>
 <fa8f55ef-d987-8750-0300-1a91030e3fa2@linux.intel.com>
In-Reply-To: <fa8f55ef-d987-8750-0300-1a91030e3fa2@linux.intel.com>
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


On 4/23/2023 11:41 AM, Binbin Wu wrote:
>
> On 4/21/2023 1:38 PM, Chao Gao wrote:
>> On Wed, Apr 12, 2023 at 03:51:34PM +0800, Binbin Wu wrote:
>>> When LAM is on, the linear address of INVVPID operand can contain
>>> metadata, and the linear address in the INVVPID descriptor can
>>> contain metadata.
>>>
>>> The added cases use tagged descriptor address or/and tagged target
>>> invalidation address to make sure the behaviors are expected when
>>> LAM is on.
>>> Also, INVVPID cases can be used as the common test cases for VMX
>>> instruction VMExits.
>>>
>>> Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
>> Reviewed-by: Chao Gao <chao.gao@intel.com>
>>
>> with a few cosmetic comments below:
>>
>>> ---
>>> x86/vmx_tests.c | 60 +++++++++++++++++++++++++++++++++++++++++++++++++
>>> 1 file changed, 60 insertions(+)
>>>
>>> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
>>> index 5ee1264..381ca1c 100644
>>> --- a/x86/vmx_tests.c
>>> +++ b/x86/vmx_tests.c
>>> @@ -3225,6 +3225,65 @@ static void 
>>> invvpid_test_not_in_vmx_operation(void)
>>>     TEST_ASSERT(!vmx_on());
>>> }
>>>
>>> +#define LAM57_MASK    GENMASK_ULL(62, 57)
>>> +#define LAM48_MASK    GENMASK_ULL(62, 48)
>>> +
>>> +static inline u64 set_metadata(u64 src, u64 metadata_mask)
>>> +{
>>> +    return (src & ~metadata_mask) | (NONCANONICAL & metadata_mask);
>>> +}
>> Can you move the duplicate defintions and functions to a header file?
>
> Then add a new header file lam.h?
> Didn't find a suitable existant header file to add these definitions.

I am about to move the definitions to lib/x86/processor.h and
rename set_metadata() to set_la_non_canonical() to be more generic.


index e00a32b..236b537 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -8,6 +8,14 @@
  #include <stdint.h>

  #define NONCANONICAL    0xaaaaaaaaaaaaaaaaull
+#define LAM57_MASK    GENMASK_ULL(62, 57)
+#define LAM48_MASK    GENMASK_ULL(62, 48)
+
+/* Set metadata with non-canonical pattern in mask bits of a linear 
address */
+static inline u64 set_la_non_canonical(u64 src, u64 mask)
+{
+    return (src & ~mask) | (NONCANONICAL & mask);
+}



>
>
>>
>>> +
>>> +/* LAM applies to the target address inside the descriptor of 
>>> invvpid */
>>> +static void invvpid_test_lam(void)
>>> +{
>>> +    void *vaddr;
>>> +    struct invvpid_operand *operand;
>>> +    u64 lam_mask = LAM48_MASK;
>>> +    bool fault;
>>> +
>>> +    if (!this_cpu_has(X86_FEATURE_LAM)) {
>>> +        report_skip("LAM is not supported, skip INVVPID with LAM");
>>> +        return;
>>> +    }
>> ...
>>
>>> +
>>> +    if (this_cpu_has(X86_FEATURE_LA57) && read_cr4() & X86_CR4_LA57)
>>> +        lam_mask = LAM57_MASK;
>>> +
>>> +    vaddr = alloc_vpage();
>>> +    install_page(current_page_table(), virt_to_phys(alloc_page()), 
>>> vaddr);
>>> +    /*
>>> +     * Since the stack memory address in KUT doesn't follow kernel 
>>> address
>>> +     * space partition rule, reuse the memory address for 
>>> descriptor and
>>> +     * the target address in the descriptor of invvpid.
>>> +     */
>>> +    operand = (struct invvpid_operand *)vaddr;
>>> +    operand->vpid = 0xffff;
>>> +    operand->gla = (u64)vaddr;
>>> +
>>> +    write_cr4_safe(read_cr4() | X86_CR4_LAM_SUP);
>>> +    if (!(read_cr4() & X86_CR4_LAM_SUP)) {
>>> +        report_skip("Failed to enable LAM_SUP");
>>> +        return;
>>> +    }
>> It might be better to enable LAM_SUP right after above check for the 
>> LAM CPUID
>> bit. And no need to verify the result because there is a dedicated 
>> test case
>> already in patch 2.
>
> OK.
>
>
>>> +
>>> +    operand = (struct invvpid_operand *)vaddr;
>>> +    operand->gla = set_metadata(operand->gla, lam_mask);
>>> +    fault = test_for_exception(GP_VECTOR, ds_invvpid, operand);
>>> +    report(!fault, "INVVPID (LAM on): untagged pointer + tagged 
>>> addr");
>>> +
>>> +    operand = (struct invvpid_operand *)set_metadata((u64)operand, 
>>> lam_mask);
>>> +    operand->gla = (u64)vaddr;
>>> +    fault = test_for_exception(GP_VECTOR, ds_invvpid, operand);
>>> +    report(!fault, "INVVPID (LAM on): tagged pointer + untagged 
>>> addr");
>>> +
>>> +    operand = (struct invvpid_operand *)set_metadata((u64)operand, 
>>> lam_mask);
>>> +    operand->gla = set_metadata(operand->gla, lam_mask);
>>> +    fault = test_for_exception(GP_VECTOR, ds_invvpid, operand);
>>> +    report(!fault, "INVVPID (LAM on): tagged pointer + tagged addr");
>>> +
>>> +    write_cr4_safe(read_cr4() & ~X86_CR4_LAM_SUP);
>>> +}
>>> +
>>> /*
>>>   * This does not test real-address mode, virtual-8086 mode, 
>>> protected mode,
>>>   * or CPL > 0.
>>> @@ -3282,6 +3341,7 @@ static void invvpid_test(void)
>>>     invvpid_test_pf();
>>>     invvpid_test_compatibility_mode();
>>>     invvpid_test_not_in_vmx_operation();
>>> +    invvpid_test_lam();
>> operand->gla is checked only in INVVPID_ADDR mode. So, the lam test 
>> should be
>> moved under "if (types & (1u << INVVPID_ADDR))" a few lines above.
>
> Yes, will update it.
>
>
>>
>>> }
>>>
>>> /*
>>> -- 
>>> 2.25.1
>>>
