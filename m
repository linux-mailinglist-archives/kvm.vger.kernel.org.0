Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0390054E604
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 17:27:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377772AbiFPP11 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 11:27:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233352AbiFPP1Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 11:27:25 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEA923EF2C;
        Thu, 16 Jun 2022 08:27:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655393244; x=1686929244;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ob9vLmkazjAUFLVrXlg6KrVwndrvcwTzHXxq35Obb0w=;
  b=NfUD+36MtSQ6mzrzAlFWV0gWSGpo1l0k1sw7QgzZuiGSXqgj4UBGP4A8
   lBSeG6x/KJCT2s8aEoAvW7ZX50dyYVTb29sNceRopL3T/+Vz4IlR/Nqpu
   EUPSDcWm1irQxetZyPeGlcRXJZ3AYoFku+uKKE6hvkIpq8tsnzrWdmZxH
   CCAy/DNVMOTU5MZQDuXS8E0W79LdbZd3a1topBg95cxiX+2xdMDrx3aok
   WOb1rEesk/xEgRdtWqYXfYHBPa7VAXlsnHjU/J0JWtSfJzSPX5Y2tOhsp
   a8cqSeAK2yZB4ugCGMsbRkQzCB7mVWaeguqG8lLrtrqojdENSiquG/g5X
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10379"; a="279988460"
X-IronPort-AV: E=Sophos;i="5.92,305,1650956400"; 
   d="scan'208";a="279988460"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2022 08:27:18 -0700
X-IronPort-AV: E=Sophos;i="5.92,305,1650956400"; 
   d="scan'208";a="641590945"
Received: from yangweij-mobl.ccr.corp.intel.com (HELO [10.249.174.123]) ([10.249.174.123])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2022 08:27:14 -0700
Message-ID: <d9abeb5d-989b-1b38-4551-1ccc50c7f400@intel.com>
Date:   Thu, 16 Jun 2022 23:27:08 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 16/19] KVM: x86: Enable CET virtualization for VMX and
 advertise CET to userspace
Content-Language: en-US
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20220616084643.19564-1-weijiang.yang@intel.com>
 <20220616084643.19564-17-weijiang.yang@intel.com>
 <YqsM9VkQ4cTSJ4Ct@worktop.programming.kicks-ass.net>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <YqsM9VkQ4cTSJ4Ct@worktop.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 6/16/2022 6:59 PM, Peter Zijlstra wrote:
> On Thu, Jun 16, 2022 at 04:46:40AM -0400, Yang Weijiang wrote:
>> Set the feature bits so that CET capabilities can be seen in guest via
>> CPUID enumeration. Add CR4.CET bit support in order to allow guest set CET
>> master control bit(CR4.CET).
>>
>> Disable KVM CET feature if unrestricted_guest is unsupported/disabled as
>> KVM does not support emulating CET.
>>
>> Don't expose CET feature if dependent CET bits are cleared in host XSS,
>> or if XSAVES isn't supported.  Updating the CET features in common x86 is
>> a little ugly, but there is no clean solution without risking breakage of
>> SVM if SVM hardware ever gains support for CET, e.g. moving everything to
>> common x86 would prematurely expose CET on SVM.  The alternative is to
>> put all the logic in VMX, but that means rereading host_xss in VMX and
>> duplicating the XSAVES check across VMX and SVM.
> Doesn't Zen3 already have SHSTK ?

Hmm, you remind me of reading more specs from AMD... I'll check their HW 
solution

if it's available.

