Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4660B66D0C9
	for <lists+kvm@lfdr.de>; Mon, 16 Jan 2023 22:15:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234108AbjAPVPd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Jan 2023 16:15:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234057AbjAPVPa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Jan 2023 16:15:30 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6FAD1207D;
        Mon, 16 Jan 2023 13:15:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673903729; x=1705439729;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=BjXiOG/yTpsib22dvo4gTY26G0IKOftojtMmiRyxqfw=;
  b=QzveZxbBRabohwotYfdVivEyuWz9+KAj/mVfLytIJIrm/Dwr5a/PkeQO
   zkGmAy18G7qXReeN2BbOb6dBSALQKB9QjIcQS9NLLX7+MDuZpPTFWWxW3
   6iGhMmEheFbw3f1kI30edqXCIuJfyZxiV9x7O68zWsJ705LMb5edVjvso
   klRFBE6R0C4p7+I9sMQA5xHRxQemCG4jJgTCvFe2mzMW3U2de7DTggpFB
   dWkWviMbA8rRFB+xSfgm05FkexPMDrS5x6aCDHWrgj47taoy/NAFmCnrj
   HJjAaTyojyAYJFjJiMTwfx7ZDfXTtp4kPvkulAzpaIzy3S0DLyBaDFB+4
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10592"; a="325828854"
X-IronPort-AV: E=Sophos;i="5.97,221,1669104000"; 
   d="scan'208";a="325828854"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2023 13:15:29 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10592"; a="727592088"
X-IronPort-AV: E=Sophos;i="5.97,221,1669104000"; 
   d="scan'208";a="727592088"
Received: from paichuan-mobl1.amr.corp.intel.com (HELO [10.209.71.173]) ([10.209.71.173])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2023 13:15:28 -0800
Message-ID: <cc344449-5f0b-51c7-bae8-6deb9be83702@intel.com>
Date:   Mon, 16 Jan 2023 13:15:29 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v6 3/7] x86/cpu, kvm: Move the LFENCE_RDTSC / LFENCE
 always serializing feature
Content-Language: en-US
To:     Borislav Petkov <bp@alien8.de>,
        Kim Phillips <kim.phillips@amd.com>,
        Dave Hansen <dave.hansen@linux.intel.com>
Cc:     x86@kernel.org, Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Juergen Gross <jgross@suse.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tony Luck <tony.luck@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Alexey Kardashevskiy <aik@amd.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230110224643.452273-1-kim.phillips@amd.com>
 <20230110224643.452273-5-kim.phillips@amd.com> <Y8WTnx/ukvdAEeoe@zn.tnic>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <Y8WTnx/ukvdAEeoe@zn.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/16/23 10:13, Borislav Petkov wrote:
>>  /* AMD-defined Extended Feature 2 EAX, CPUID level 0x80000021 (EAX), word 20 */
>>  #define X86_FEATURE_NO_NESTED_DATA_BP	(20*32+ 0) /* "" AMD No Nested Data Breakpoints */
>> +#define X86_FEATURE_LFENCE_RDTSC	(20*32+ 2) /* "" LFENCE always serializing / synchronizes RDTSC */
> Hmm, a synthetic bit which gets replaced with a vendor one and then the other
> vendors set it too. I don't see why that cannot work but we probably should be
> careful here.
> 
> dhansen, am I missing an angle?

I don't think so.

I'd be surprised if we don't have a _few_ other cases like this around,
but nothing is coming to mind.  Either way, it doesn't seem problematic.
