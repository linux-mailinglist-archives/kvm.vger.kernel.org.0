Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CCD676DEBE
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 05:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231651AbjHCDMk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Aug 2023 23:12:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbjHCDMi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Aug 2023 23:12:38 -0400
Received: from mgamail.intel.com (unknown [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA76FED
        for <kvm@vger.kernel.org>; Wed,  2 Aug 2023 20:12:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691032357; x=1722568357;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=hjKVq+cCV1wX3Jbg6GEunxtbRY4rYSmVI0jzRvDnMpA=;
  b=cFlvIZ5ND2sFokFMGgiwWJZhDkfDHArYY1kD1UNxtwqI4faNsECHsShx
   ZrMcTqEZLuaMgerWKrh1J9MjlDm8VwhaafqKrcUm9zi8oDPu3jTBgEalU
   xMnvtIlepCh+K/KVAIfwFB7WRnAUIYkSRXLFWfx7cCaVipNM7tjbcm5Wa
   /Ip1szPom0nHNOucMDohEsgiW9Qkj8ZtNQI0CHbzizaaAlIihiPh1Z8Ve
   8M324utREPuxMHO6fKRdQRbOSOVCTbiX1PgTDfZofpvCwwk5z+P7L3oQH
   jE2qkbJNi5kh+UqsaBVx6D1FbzAK1HxYvBwBsAWXUG85DsaYyfvyfJQaJ
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10790"; a="349352102"
X-IronPort-AV: E=Sophos;i="6.01,251,1684825200"; 
   d="scan'208";a="349352102"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2023 20:12:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10790"; a="764446486"
X-IronPort-AV: E=Sophos;i="6.01,251,1684825200"; 
   d="scan'208";a="764446486"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.18.246]) ([10.93.18.246])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2023 20:12:22 -0700
Message-ID: <8677f439-4d3e-6831-dfc4-d5a95461f6de@intel.com>
Date:   Thu, 3 Aug 2023 11:12:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.13.0
Subject: Re: [PATCH] KVM: x86: Advertise AMX-COMPLEX CPUID to userspace
To:     Sean Christopherson <seanjc@google.com>,
        Tao Su <tao1.su@linux.intel.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
References: <20230802022954.193843-1-tao1.su@linux.intel.com>
 <ZMroatylDm1b5+WJ@google.com>
Content-Language: en-US
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <ZMroatylDm1b5+WJ@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/3/2023 7:36 AM, Sean Christopherson wrote:
> On Wed, Aug 02, 2023, Tao Su wrote:
>> Latest Intel platform GraniteRapids-D introduces AMX-COMPLEX, which adds
>> two instructions to perform matrix multiplication of two tiles containing
>> complex elements and accumulate the results into a packed single precision
>> tile.
>>
>> AMX-COMPLEX is enumerated via CPUID.(EAX=7,ECX=1):EDX[bit 8]
>>
>> Since there are no new VMX controls or additional host enabling required
>> for guests to use this feature, advertise the CPUID to userspace.
> 
> Nit, I would rather justify this (last paragraph) with something like:
> 
>    Advertise AMX_COMPLEX if it's supported in hardware.  There are no VMX
>    controls for the feature, i.e. the instructions can't be interecepted, and
>    KVM advertises base AMX in CPUID if AMX is supported in hardware, even if
>    KVM doesn't advertise AMX as being supported in XCR0, e.g. because the
>    process didn't opt-in to allocating tile data.

It looks good to me.

> If the above is accurate and there are no objections, I'll fixup the changelog
> when applying.
> 
> Side topic, this does make me wonder if advertising AMX when XTILE_DATA isn't
> permitted is a bad idea.  But no one has complained, and chasing down all the
> dependent AMX features would get annoying, so I'm inclined to keep the status quo.

