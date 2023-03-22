Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D2BB6C416A
	for <lists+kvm@lfdr.de>; Wed, 22 Mar 2023 05:03:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230480AbjCVEDo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Mar 2023 00:03:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230436AbjCVEDT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Mar 2023 00:03:19 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DFDF5BD95;
        Tue, 21 Mar 2023 21:02:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679457732; x=1710993732;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=7Hj7tRv4+Rc9UMP86VA4Ii4mE8aI+72mPUgX4/qzk3g=;
  b=Iqh/a+UA/7ZFHwjluWsS/3q6Ihpk6MOMZdWQnSfXZS4Wk8xSJBTVlWja
   Sfgaiy+SKiYE6se6Ga9IA5mJNoEs9hMquc0yKiv8UH6YB7sUQO/cGGBue
   occeMexe+sSscZvzeebj5dT9OmF1Lw+pgP5ob5b1OWJ+UKbQvph6tYVIn
   tMSdsFXRmbC43+6R02RZTLLW0Gi6IvRVsBiqb4oHe9ixCkqxALsLlLlGm
   vCDb0lGEyYi/SPq7g1mpSxD98ngcchf0/nr52JIA+VD9eozr5L39QX2np
   AdSHcvDNqrWklt8kSlOW1VdsWtNiXtNT7rBXRsAfXHFV1K9im07/ZpfVr
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10656"; a="341477218"
X-IronPort-AV: E=Sophos;i="5.98,280,1673942400"; 
   d="scan'208";a="341477218"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2023 21:01:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10656"; a="1011222409"
X-IronPort-AV: E=Sophos;i="5.98,280,1673942400"; 
   d="scan'208";a="1011222409"
Received: from rhchan-mobl1.amr.corp.intel.com (HELO [10.212.217.72]) ([10.212.217.72])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2023 21:01:18 -0700
Message-ID: <7a3bf16a-5ad2-39b0-c68d-f36d40b8dfc4@intel.com>
Date:   Tue, 21 Mar 2023 21:01:17 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v5 22/34] x86/fred: FRED initialization code
Content-Language: en-US
To:     "Li, Xin3" <xin3.li@intel.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>
References: <20230307023946.14516-1-xin3.li@intel.com>
 <20230307023946.14516-23-xin3.li@intel.com>
 <CAJhGHyADXz-3PCFS3M_7TJ8qLGJ=4NcV9aBWrpjemuXB_SnMGg@mail.gmail.com>
 <5D679723-D84F-42F0-AD8A-8BD1A38FB6CD@zytor.com>
 <CAJhGHyC0_1xJD2R03-NoRVpMXFTHR4v8CdzyJOZe_k0rdv=NfQ@mail.gmail.com>
 <SA1PR11MB673486AB91F77B468ED1BD82A8869@SA1PR11MB6734.namprd11.prod.outlook.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <SA1PR11MB673486AB91F77B468ED1BD82A8869@SA1PR11MB6734.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/21/23 19:22, Li, Xin3 wrote:
>> If there is no other concrete reason other than overflowing for assigning NMI and
>> #DB with a stack level > 0, #VE should also be assigned with a stack level > 0, and
>> #BP too. #VE can happen anytime and anywhere, so it is subject to overflowing too.
> With IDT, both #VE and #BP do not use IST, but NMI, #DB, #MC and #DF do.
> 
> Let's keep this "secret" logic for now, i.e., not change the stack levels
> for #VE and #BP at this point. We can do "optimization", i.e., change them
> later 😄.

#VE also can't happen anywhere.  There is some documentation about it in
here:

	https://docs.kernel.org/x86/tdx.html#linux-ve-handler

But, basically, the only halfway sane thing a guest might do to hit a
#VE is touch some "MMIO".  The host can *not* cause them in arbitrary
places because of the SEPT_VE_DISABLE attribute.

#VE's also can't nest until after the guest retrieves the "VE info".
That means that the #VE handler at _least_ reaches C code before it's
subject to another #VE and that second one would still need to be
induced by something the guest does explicitly.
