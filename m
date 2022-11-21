Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D92A063282A
	for <lists+kvm@lfdr.de>; Mon, 21 Nov 2022 16:30:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232448AbiKUPaN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Nov 2022 10:30:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232445AbiKUP3y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Nov 2022 10:29:54 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13938DF80;
        Mon, 21 Nov 2022 07:29:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669044547; x=1700580547;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=0ocp0OORCesdWMSJVXSnmGTZ9TeQKI/Q0W1c3l/hfEc=;
  b=RB44sEk/538mMBQfzjhVtI1ojIeGhQxQ4OQlMuEhOSbNIG6BolrypVxl
   4Q9AB42NSNFOauk0smPNG1ADTBH6FnCPZ6fBvi5oBTlOWnApOdIr+UWbQ
   ggfcmwtVD5id1OVsjBUVT93qHjnhqBpZG/MrS7nTetZuusAmj385581q9
   4QdbMp/LbVjUae5Zgh9b6c41Jiq6LdzEQaqeisEICIPQ+ytER1nMacSj7
   SYqjOc2cZq9rwjLYMW3YgnZCu5KdyiT3Dvk8+pvOvDzpBIz3Hg75PpKJK
   Zv2+JMYfc+bsLFRjNhYzVdg5FP2PtIYTbzaNtf046/HCubKkG9YeWzbiy
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="377843943"
X-IronPort-AV: E=Sophos;i="5.96,181,1665471600"; 
   d="scan'208";a="377843943"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2022 07:29:06 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="730043155"
X-IronPort-AV: E=Sophos;i="5.96,181,1665471600"; 
   d="scan'208";a="730043155"
Received: from ticela-or-327.amr.corp.intel.com (HELO [10.209.6.63]) ([10.209.6.63])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2022 07:29:04 -0800
Message-ID: <6d7fae50-ef3c-dc1e-336c-691095007117@intel.com>
Date:   Mon, 21 Nov 2022 07:29:04 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v4 1/6] x86: KVM: Advertise CMPccXADD CPUID to user space
Content-Language: en-US
To:     Jiaxi Chen <jiaxi.chen@linux.intel.com>
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
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <f04c2e74-87e4-5d50-579a-0a60554b83d3@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/21/22 06:46, Jiaxi Chen wrote:
> Features which has been enabled in kernel usually should be added to
> /proc/cpuinfo.

Features that the kernel *itself* is actually using always get in there.
 Things like "smep".

But, things that the kernel "enables" but that only get used by
userspace don't generally show up in /proc/cpuinfo.

KVM is kinda a weird case.  The kernel is making the feature available
to guests, but it's not _using_ it in any meaningful way.  To me, this
seems much more akin to the features that are just available to
userspace than something that the kernel is truly using.

Also, these feature names are just long and ugly, and the "flags" line
is already a human-*un*readable mess.  I think we should just leave them
out.
