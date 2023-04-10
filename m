Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDBFF6DC2F8
	for <lists+kvm@lfdr.de>; Mon, 10 Apr 2023 05:35:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbjDJDfs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 9 Apr 2023 23:35:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjDJDfr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 9 Apr 2023 23:35:47 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E416B30CF
        for <kvm@vger.kernel.org>; Sun,  9 Apr 2023 20:35:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681097745; x=1712633745;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=iLaXXIvCmLkM+pcmu/TF3IjPi+EcpNinc1tjMUrvjno=;
  b=gT3UJ2WY04sEHPKX5iFz2mktmt0czSNRQ3FulvhiGX6ig5oHZ6ZKsUo2
   wySxatPVWWzRcMiUuyXIL7gIDISHJ1RXil5BvxRPQE3DHDajCLjlDnHjo
   Tmb6ZEGu+6lW17S5Lw8H2rD+a7YpZsrM4nA/uYUivKMnh2EwwmaymyPup
   ML4BE6ev4hl2OAYcSoi6ZRvYd+RH5GPuV4kJeGq5qneL2xvl4zkixLTUX
   8UcchX1VmVmmXbzWXbR4j0Hi6ddElYAmIG7bRmQmAcY8q4k8Abzmq4yYM
   2hWvKtD2vsx/v4U29DGgZUUtSC3kfjpS4qGYGvAePn1H/WRjgaSTED6o/
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10675"; a="345940820"
X-IronPort-AV: E=Sophos;i="5.98,332,1673942400"; 
   d="scan'208";a="345940820"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2023 20:35:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10675"; a="799364590"
X-IronPort-AV: E=Sophos;i="5.98,332,1673942400"; 
   d="scan'208";a="799364590"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.8.125]) ([10.238.8.125])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2023 20:35:43 -0700
Message-ID: <688cf58b-d309-322a-2932-363608f70fc5@linux.intel.com>
Date:   Mon, 10 Apr 2023 11:35:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v7 4/5] KVM: x86: Untag address when LAM applicable
To:     "Huang, Kai" <kai.huang@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Cc:     "Guo, Xuelian" <xuelian.guo@intel.com>,
        "robert.hu@linux.intel.com" <robert.hu@linux.intel.com>,
        "Gao, Chao" <chao.gao@intel.com>
References: <20230404130923.27749-1-binbin.wu@linux.intel.com>
 <20230404130923.27749-5-binbin.wu@linux.intel.com>
 <9a19392e64f504e81a5adb32b8095815aeca82b8.camel@intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <9a19392e64f504e81a5adb32b8095815aeca82b8.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.3 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/6/2023 9:20 PM, Huang, Kai wrote:
> On Tue, 2023-04-04 at 21:09 +0800, Binbin Wu wrote:
>>   	case VMX_VPID_EXTENT_INDIVIDUAL_ADDR:
>> +		/* invvpid is not valid in compatibility mode */
>> +		if (is_long_mode(vcpu))
>> +			operand.gla = vmx_untag_addr(vcpu, operand.gla, 0);
> This comment doesn't make sense.  The code does nothing to distinguish the
> compatibility mode and the 64-bit mode.

I was also hesitant when added the comment.


>
> Now although we are all clear that here is_long_mode() basically equals to
> is_64_bit_mode(), but I do think we need a comment or WARN() _SOMEWHERE_ to
> indicate that compatibility mode is not possible when handling VMEXIT for VMX
> instructions (except VMCALL).  Not everyone will be able to notice this small
> thing in the SDM.

If the WARN() is preferred, IMO, it can be added to 
nested_vmx_check_permission() because
it is called by all handlers "need" the check except for handle_vmxon().
handle_vmxon() can be added separately.


>
> Then you can just delete this comment here.
>
> Alternatively, for better readability actually I am thinking maybe we should
> just use is_64_bit_mode(), because those segments are cached by KVM anyway so I
> don't think there's measurable performance difference between is_long_mode() and
> is_64_bit_mode().

Agree.


>
> Sean, any comments?
