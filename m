Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19F49493D06
	for <lists+kvm@lfdr.de>; Wed, 19 Jan 2022 16:23:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355685AbiASPXK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 10:23:10 -0500
Received: from mga11.intel.com ([192.55.52.93]:41950 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355569AbiASPXJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jan 2022 10:23:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642605789; x=1674141789;
  h=to:cc:references:from:subject:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=7v8+ytScz60DzQuNQqLNXPcL7UmX5D6rKpdw4oM8kV4=;
  b=YNH2p0aJ7DVvprn7S5pd5FJtYQ1QXxiMyZXOU52zfdjU/yBLdSViG7yp
   FLLmClzTk09gJ6bBgqROq01oCE1jFc1a7vV/9lVKiTIr7CiihDZgGUtxy
   vL6z9ZGU8rrNSOIPfm/ha6usRXKXbyNsWCDzGiadml8hQRt70yg32Ygi/
   z87xKQI7UbGjUekoccKrCpmMS/IblilS22Hi9OVJZcoCdbiX2K7JijYiG
   8aBanf1KoixaGRAmAdEtzzDFmIWfL98vkfa94u2e4FMfbjahr7Cpfrzbw
   oSZ0RLyW7EQYabxIvWxgPHX/b0TbtcpSM7/GL0A8u/W38xEgUGnsoaiyR
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10231"; a="242650707"
X-IronPort-AV: E=Sophos;i="5.88,299,1635231600"; 
   d="scan'208";a="242650707"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2022 07:23:09 -0800
X-IronPort-AV: E=Sophos;i="5.88,299,1635231600"; 
   d="scan'208";a="578843564"
Received: from wenwang3-mobl.amr.corp.intel.com (HELO [10.209.118.159]) ([10.209.118.159])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2022 07:23:08 -0800
To:     Like Xu <like.xu.linux@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Like Xu <likexu@tencent.com>
References: <20220119070427.33801-1-likexu@tencent.com>
From:   Dave Hansen <dave.hansen@intel.com>
Subject: Re: [PATCH] KVM: x86/xcr0: Don't make XFEATURE_MASK_SSE a mandatory
 bit setting
Message-ID: <1b6a8366-d1ab-536f-9bad-8c2b7a822fcb@intel.com>
Date:   Wed, 19 Jan 2022 07:23:05 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220119070427.33801-1-likexu@tencent.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/18/22 11:04 PM, Like Xu wrote:
> Remove the XFEATURE_MASK_SSE bit as part of the XFEATURE_MASK_EXTEND
> and opportunistically, move it into the context of its unique user KVM.

Is this a problem for xstate_required_size()?  The rules for the CPUID
sub-functions <=1 are different than those for >1.  Most importantly,
'eax' doesn't enumerate the size of the feature for the XFEATURE_SSE
sub-leaf.

I think XFEATURE_MASK_EXTEND was being used to avoid that oddity:

> u32 xstate_required_size(u64 xstate_bv, bool compacted)
> {
>         int feature_bit = 0;
>         u32 ret = XSAVE_HDR_SIZE + XSAVE_HDR_OFFSET;
> 
>         xstate_bv &= XFEATURE_MASK_EXTEND;
>         while (xstate_bv) {
>                 if (xstate_bv & 0x1) {
>                         u32 eax, ebx, ecx, edx, offset;
>                         cpuid_count(0xD, feature_bit, &eax, &ebx, &ecx, &edx);
>                         /* ECX[1]: 64B alignment in compacted form */
>                         if (compacted)
>                                 offset = (ecx & 0x2) ? ALIGN(ret, 64) : ret;
>                         else
>                                 offset = ebx;
>                         ret = max(ret, offset + eax);
>                 }
> 
>                 xstate_bv >>= 1;
>                 feature_bit++;
>         }
> 
>         return ret;
> }
