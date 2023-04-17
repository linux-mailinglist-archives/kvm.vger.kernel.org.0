Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A783F6E41ED
	for <lists+kvm@lfdr.de>; Mon, 17 Apr 2023 10:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbjDQICh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Apr 2023 04:02:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230125AbjDQICf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Apr 2023 04:02:35 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 337A5196
        for <kvm@vger.kernel.org>; Mon, 17 Apr 2023 01:02:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681718554; x=1713254554;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=WeOwEB2N7hfIRx2MuLh7+gbTaYwreGKIrEYBuA9sS8M=;
  b=dvCFMKiDzxL6hCNKOaF07whoR69i7p1oCqt71Zd30PMnUZs10JQOcJr3
   SQM5FzlbSnYAkqnvIwj/4Xo/z7b5zfWhHGKJBvaikyr5a2uq8eR6Z5wP+
   eOyPzuz0KSmJKrmB83XweM+WrIJdbMpppQHVSZwHvzjg06LE8q10H1QL7
   c/O3Lk6Oe/F15YnCcXPl2fQYV/1juGmDz/URheeMEE1U3b2CiGvXFOpe4
   g/QYrebNmfo3rLzarbPQkwkdACcBEOcrEA9AKgzstyZtjev9l4a65cM6r
   ytTwuSnPOQ8MA/OXmSzGQiPn6JE3Fey48ZoYoiRLcItaP+wEAZUvlNta5
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10682"; a="325177446"
X-IronPort-AV: E=Sophos;i="5.99,203,1677571200"; 
   d="scan'208";a="325177446"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2023 01:02:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10682"; a="721036795"
X-IronPort-AV: E=Sophos;i="5.99,203,1677571200"; 
   d="scan'208";a="721036795"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.8.125]) ([10.238.8.125])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2023 01:02:27 -0700
Message-ID: <39aa87d4-440b-6b7b-3ddc-7b759f4f8359@linux.intel.com>
Date:   Mon, 17 Apr 2023 16:02:24 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v7 2/5] KVM: x86: Virtualize CR3.LAM_{U48,U57}
To:     Chao Gao <chao.gao@intel.com>
Cc:     kvm@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com,
        kai.huang@intel.com, xuelian.guo@intel.com,
        robert.hu@linux.intel.com
References: <20230404130923.27749-1-binbin.wu@linux.intel.com>
 <20230404130923.27749-3-binbin.wu@linux.intel.com>
 <ZDz0N4yBomWLnz3N@chao-env>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <ZDz0N4yBomWLnz3N@chao-env>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/17/2023 3:24 PM, Chao Gao wrote:
> On Tue, Apr 04, 2023 at 09:09:20PM +0800, Binbin Wu wrote:
>> /* Page table builder macros common to shadow (host) PTEs and guest PTEs. */
>> +#define __PT_BASE_ADDR_MASK (((1ULL << 52) - 1) & ~(u64)(PAGE_SIZE-1))
> This is an open-coded(). So, you'd better use GENMASK_ULL() here.

Here basically is a code move and rename from PT_BASE_ADDR_MASK to 
__PT_BASE_ADDR_MASK.
I didn't change the original code, but if it is preferred to use 
GENMASK_ULL()
in kernel/KVM, I can change it as following:

#define __PT_BASE_ADDR_MASK GENMASK_ULL(51, 12)


>
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -1260,7 +1260,7 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
>> 	 * stuff CR3, e.g. for RSM emulation, and there is no guarantee that
>> 	 * the current vCPU mode is accurate.
>> 	 */
>> -	if (kvm_vcpu_is_illegal_gpa(vcpu, cr3))
>> +	if (!kvm_vcpu_is_legal_cr3(vcpu, cr3))
> I prefer to modify the call sites in SVM nested code to use the new
> function. Although this change does not affect functionality, it
> provides a clear distinction between CR3 checks and GPA checks.

Make sense, will do it.


