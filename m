Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B886E4ED358
	for <lists+kvm@lfdr.de>; Thu, 31 Mar 2022 07:39:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229852AbiCaFlC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Mar 2022 01:41:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229721AbiCaFlA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Mar 2022 01:41:00 -0400
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFE4912764;
        Wed, 30 Mar 2022 22:39:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648705153; x=1680241153;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=gvOy3/489ye6qpz0sVJS+BaGPay3tgv+3wy4I4MM60Y=;
  b=FpnlnJF5cnJ6C161juCI+bzv2AiPi+Aw/y6vah/iZM2e4CJf9ISKCNW7
   o/qUjefgk4sFYDXSthTTouJdf0G9xlqTvpbBDhY13L8JQjtYHtPN9M+a9
   wX/4w7XgX+Wg1DQU0IL/1UbNcUqAFYGOqi8QG0STGl4ei0EVur0sgMRVE
   +pOlm2F6KUfsOS9hJgAfn7crs4FX2eqM9wlGkpfqDtkzmSmiGLnm9ke6W
   hJ2LzOPZqHcPG2+IB18huQCalndx/mNXDAIG66clsLSlXV/LlrLpsiwaJ
   hfRw1ldeGtl76mEwN35GbHNIN7ai4sC0i/LGx8T8DtNof0/t7fD8fJjxs
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10302"; a="320420440"
X-IronPort-AV: E=Sophos;i="5.90,224,1643702400"; 
   d="scan'208";a="320420440"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2022 22:39:13 -0700
X-IronPort-AV: E=Sophos;i="5.90,224,1643702400"; 
   d="scan'208";a="566159090"
Received: from cqiang-mobl.ccr.corp.intel.com (HELO [10.249.172.223]) ([10.249.172.223])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2022 22:39:09 -0700
Message-ID: <04df790f-0900-d678-d560-7b1905b7b56d@intel.com>
Date:   Thu, 31 Mar 2022 13:39:07 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.7.0
Subject: Re: [PATCH v6 2/7] KVM: VMX: Add proper cache tracking for PKRS
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220221080840.7369-1-chenyi.qiang@intel.com>
 <20220221080840.7369-3-chenyi.qiang@intel.com> <YkTAzCPZ3zXYDBLj@google.com>
From:   Chenyi Qiang <chenyi.qiang@intel.com>
In-Reply-To: <YkTAzCPZ3zXYDBLj@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/31/2022 4:42 AM, Sean Christopherson wrote:
> On Mon, Feb 21, 2022, Chenyi Qiang wrote:
>> Add PKRS caching into the standard register caching mechanism in order
>> to take advantage of the availability checks provided by regs_avail.
>>
>> This is because vcpu->arch.pkrs will be rarely acceesed by KVM, only in
>> the case of host userspace MSR reads and GVA->GPA translation in
>> following patches. It is unnecessary to keep it up-to-date at all times.
> 
> It might be worth throwing in a blurb that the potential benefits of this caching
> are tenous.
> 
> Barring userspace wierdness, the MSR read is not a hot path.
> 
> permission_fault() is slightly more common, but I would be surprised if caching
> actually provides meaningful performance benefit.  The PKRS checks are done only
> once per virtual access, i.e. only on the final translation, so the cache will get
> a hit if and only if there are multiple translations in a single round of emulation,
> where a "round of emulation" ends upon entry to the guest.  With unrestricted
> guest, i.e. for all intents and purposes every VM using PKRS, there aren't _that_
> many scenarios where KVM will (a) emulate in the first place and (b) emulate enough
> accesses for the caching to be meaningful.
> 
> That said, this is basically "free", so I've no objection to adding it.  But I do
> think it's worth documenting that it's nice-to-have so that we don't hesitate to
> rip it out in the future if there's a strong reason to drop the caching.
> 

OK, will add this note in commit message.

>> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
>> ---
> 
> Reviewed-by: Sean Christopherson <seanjc@google.com>
