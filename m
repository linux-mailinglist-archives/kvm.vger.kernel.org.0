Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 993BA6FE969
	for <lists+kvm@lfdr.de>; Thu, 11 May 2023 03:25:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236907AbjEKBZx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 May 2023 21:25:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231465AbjEKBZu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 May 2023 21:25:50 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 543E43A8E;
        Wed, 10 May 2023 18:25:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683768347; x=1715304347;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Gx1xSLA5d0yp2DjVwjwwCY3Ftth1Tj8DVA150LgfKIY=;
  b=SSp9wEwql27yrIR8xsYsujf5F3V99DWulA2uJD+1dnwmWcENIpwXUrP8
   GYEzi+QgqvTOSaEOIhnnvRWirHTVY3bTX2/dICfXxTNZHzBr7IiJdj58J
   mFIONU163PkLCAMhObzWjtynQAMLvIe/baFycM2Q8a4F343/ESM87/l3w
   TxIkiTI7GtgtpFfIGKLqcX1rhaiJiXCL6BOzS8Oa6LZVUcIXPqIQyVnch
   XHKWx9sd+UPzkn1VUfMwEof4COsbArjTFStWnUY+GL/wJCKaex65xwAoa
   g73QMESfnZHVgO8nZdyKlPR9Yr55TG8YfALiUNaQP65K1Go65ZP9WmF4o
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10706"; a="334836723"
X-IronPort-AV: E=Sophos;i="5.99,265,1677571200"; 
   d="scan'208";a="334836723"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2023 18:25:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10706"; a="677069929"
X-IronPort-AV: E=Sophos;i="5.99,265,1677571200"; 
   d="scan'208";a="677069929"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.254.215.43]) ([10.254.215.43])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2023 18:25:44 -0700
Message-ID: <68a5df32-82de-1f07-5ea2-52ecf1c17e63@linux.intel.com>
Date:   Thu, 11 May 2023 09:25:42 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH v8 1/6] KVM: x86: Consolidate flags for __linearize()
To:     Chao Gao <chao.gao@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        seanjc@google.com, pbonzini@redhat.com, kai.huang@intel.com,
        robert.hu@linux.intel.com
References: <20230510060611.12950-1-binbin.wu@linux.intel.com>
 <20230510060611.12950-2-binbin.wu@linux.intel.com>
 <ZFtK/NS8rzCx9Mus@chao-email>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <ZFtK/NS8rzCx9Mus@chao-email>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/10/2023 3:42 PM, Chao Gao wrote:
> On Wed, May 10, 2023 at 02:06:06PM +0800, Binbin Wu wrote:
>> Define a 32-bit parameter and consolidate the two bools into it.
>>
>> __linearize() has two bool parameters write and fetch. And new flag
>> will be needed to support new feature (e.g. LAM needs a flag to skip
>> address untag under some conditions).
>>
>> No functional change intended.
>>
>> In the follow-up patches, the new parameter will be extended for LAM.
>>
>> Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
> Reviewed-by: Chao Gao <chao.gao@intel.com>
>
> one nit below
>
>> ---
>> arch/x86/kvm/emulate.c     | 19 +++++++++++++------
>> arch/x86/kvm/kvm_emulate.h |  4 ++++
>> 2 files changed, 17 insertions(+), 6 deletions(-)
>>
>> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
>> index 936a397a08cd..9508836e8a35 100644
>> --- a/arch/x86/kvm/emulate.c
>> +++ b/arch/x86/kvm/emulate.c
>> @@ -687,8 +687,8 @@ static unsigned insn_alignment(struct x86_emulate_ctxt *ctxt, unsigned size)
>> static __always_inline int __linearize(struct x86_emulate_ctxt *ctxt,
>> 				       struct segmented_address addr,
>> 				       unsigned *max_size, unsigned size,
>> -				       bool write, bool fetch,
>> -				       enum x86emul_mode mode, ulong *linear)
>> +				       u32 flags, enum x86emul_mode mode,
>> +				       ulong *linear)
>> {
>> 	struct desc_struct desc;
>> 	bool usable;
>> @@ -696,6 +696,8 @@ static __always_inline int __linearize(struct x86_emulate_ctxt *ctxt,
>> 	u32 lim;
>> 	u16 sel;
>> 	u8  va_bits;
>> +	bool fetch = !!(flags & X86EMUL_F_FETCH);
>> +	bool write = !!(flags & X86EMUL_F_WRITE);
>>
>> 	la = seg_base(ctxt, addr.seg) + addr.ea;
>> 	*max_size = 0;
>> @@ -757,7 +759,11 @@ static int linearize(struct x86_emulate_ctxt *ctxt,
>> 		     ulong *linear)
>> {
>> 	unsigned max_size;
>> -	return __linearize(ctxt, addr, &max_size, size, write, false,
>> +	u32 flags = 0;
>> +
>> +	if (write)
>> +		flags |= X86EMUL_F_WRITE;
> this can be more dense:
>
> 	u32 flags = write ? X86EMUL_F_WRITE : 0;
Thanks, will update it.
