Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59C00635081
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 07:33:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236036AbiKWGdx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 01:33:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234531AbiKWGdv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 01:33:51 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 870E5EA138;
        Tue, 22 Nov 2022 22:33:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669185230; x=1700721230;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=27L+f2UUfa+f7KW/A/rdUyhJdUZDtfiEtjWnXwlvi1A=;
  b=UCQ00pT3nIaQuAk0UpdFMW/hzVH2hh3oDE8TwVgd2BE+Ju4pi90elDRH
   VSShPn7K+AxZdiehoP2P2ufLV5Fnj10Wb2vzVc+eMXWYTIIe+CCXqUGm7
   KR0wHfzdzHJ44CbWm9lKmakCegjcGrOqbpnV3xY5YjOgww1ZU9RKvFPMS
   uUtb/tXuTt18KQ8J3cptAOX/bSHAmwh230rdGEHkHSdf1CJt6m1NwsLS7
   VIC2napiGt6lC6vlE9kUD9b1LaZkYlsuvH+touxJUk8+D4Z8aGGuCCJHV
   3dKS9jRWpscBd31qQwjabHMqH9xeX6+MLIpSTePt/fJCPYgTaI7py6hfC
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="340870395"
X-IronPort-AV: E=Sophos;i="5.96,186,1665471600"; 
   d="scan'208";a="340870395"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2022 22:33:50 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="643995920"
X-IronPort-AV: E=Sophos;i="5.96,186,1665471600"; 
   d="scan'208";a="643995920"
Received: from jiaxiche-mobl.ccr.corp.intel.com (HELO [10.254.210.241]) ([10.254.210.241])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2022 22:33:37 -0800
Message-ID: <f2cf136e-bf38-54ce-a0dc-31b0192d1dd6@linux.intel.com>
Date:   Wed, 23 Nov 2022 14:33:32 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v4 1/6] x86: KVM: Advertise CMPccXADD CPUID to user space
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     kvm@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, seanjc@google.com, pbonzini@redhat.com,
        ndesaulniers@google.com, alexandre.belloni@bootlin.com,
        peterz@infradead.org, jpoimboe@kernel.org,
        chang.seok.bae@intel.com, pawan.kumar.gupta@linux.intel.com,
        babu.moger@amd.com, jmattson@google.com, sandipan.das@amd.com,
        tony.luck@intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        fenghua.yu@intel.com, keescook@chromium.org, nathan@kernel.org,
        linux-kernel@vger.kernel.org
References: <20221118141509.489359-1-jiaxi.chen@linux.intel.com>
 <20221118141509.489359-2-jiaxi.chen@linux.intel.com>
 <efb55727-f8bd-815c-ddfc-a8432ae5af4e@intel.com>
 <f04c2e74-87e4-5d50-579a-0a60554b83d3@linux.intel.com>
 <6d7fae50-ef3c-dc1e-336c-691095007117@intel.com>
From:   Jiaxi Chen <jiaxi.chen@linux.intel.com>
In-Reply-To: <6d7fae50-ef3c-dc1e-336c-691095007117@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/21/2022 11:29 PM, Dave Hansen wrote:
> On 11/21/22 06:46, Jiaxi Chen wrote:
>> Features which has been enabled in kernel usually should be added to
>> /proc/cpuinfo.
> 
> Features that the kernel *itself* is actually using always get in there.
>  Things like "smep".
> 
> But, things that the kernel "enables" but that only get used by
> userspace don't generally show up in /proc/cpuinfo.
> 
> KVM is kinda a weird case.  The kernel is making the feature available
> to guests, but it's not _using_ it in any meaningful way.  To me, this
> seems much more akin to the features that are just available to
> userspace than something that the kernel is truly using.
> 
> Also, these feature names are just long and ugly, and the "flags" line
> is already a human-*un*readable mess.  I think we should just leave them
> out.

True and agree. As for these cpuids are not truly used by kernel except
for advertising to kvm userspace, we can hide them in /proc/cpuinfo by
overriding their name with "".

-- 
Regards,
Jiaxi
