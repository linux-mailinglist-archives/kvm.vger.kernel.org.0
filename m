Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FF05522871
	for <lists+kvm@lfdr.de>; Wed, 11 May 2022 02:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239253AbiEKA1O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 May 2022 20:27:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239632AbiEKA1M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 May 2022 20:27:12 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B9B35D5DA;
        Tue, 10 May 2022 17:27:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652228828; x=1683764828;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=7fKtwrfJNrDGyLYQn9wBN96rXyqJr09OQezQokT2Rws=;
  b=kVG0eh1JAuJ4Ft+pqKTJD8mVDDtzOZSzRNxY8Gi0VkwbRuhuOxa0ivZu
   F8h+9U0wMzK7yqGR8OhMUn7hM9cAZ3WJ+cV7KWZoUXhtHx1EdHzJ83d9o
   A3dIHvnJlymxMok+Pt77Bj0TKPT0EBOtr5U1HTpDGBYjZikcdyzFG5DfX
   72H6B5Z7HyoIDcX6XyePYGNn6f5XzP4+s1ua2frao9k/Z9gLJSMe16zy4
   fTuR9PqVQLbU+9o9z467df87O+e+ANSuNlam7sjdPZINHQ3ROvfGfLdLp
   jm9/ADUUPjJ6qTVS3NpoVVSCCGdpgcluy9USXPtTpj36ga7hcfPwhc1sd
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10343"; a="269676205"
X-IronPort-AV: E=Sophos;i="5.91,215,1647327600"; 
   d="scan'208";a="269676205"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2022 17:27:07 -0700
X-IronPort-AV: E=Sophos;i="5.91,215,1647327600"; 
   d="scan'208";a="657899142"
Received: from yangweij-mobl.ccr.corp.intel.com (HELO [10.249.171.95]) ([10.249.171.95])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2022 17:27:05 -0700
Message-ID: <fcec0903-69ed-078a-5abd-c9d4198eca4b@intel.com>
Date:   Wed, 11 May 2022 08:26:53 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH] KVM: selftests: x86: Skip unsupported test when Arch LBR
 is available
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     "likexu@tencent.com" <likexu@tencent.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <20220510150637.1774645-1-pbonzini@redhat.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <20220510150637.1774645-1-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/10/2022 11:06 PM, Paolo Bonzini wrote:
> Hi,
>
>> -	ret = _vcpu_set_msr(vm, 0, MSR_IA32_PERF_CAPABILITIES, PMU_CAP_LBR_FMT);
>> -	TEST_ASSERT(ret == 0, "Bad PERF_CAPABILITIES didn't fail.");
>> +	/* Note, on Arch LBR capable platforms, LBR_FMT in perf capability msr is 0x3f,
>> +	 * so skip below test if running on these platforms. */
>> +	if (host_cap.lbr_format != PMU_CAP_LBR_FMT) {
>> +		ret = _vcpu_set_msr(vm, 0, MSR_IA32_PERF_CAPABILITIES, PMU_CAP_LBR_FMT);
>> +		TEST_ASSERT(ret == 0, "Bad PERF_CAPABILITIES didn't fail.");
>> +	}
> Why not try a different value?
OK, I'll select a "real" invalid format and re-post the patch, thanks!
>
> Paolo
>
>
