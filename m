Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8964EFDFE
	for <lists+kvm@lfdr.de>; Sat,  2 Apr 2022 04:43:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237509AbiDBCma (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 22:42:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229807AbiDBCm2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 22:42:28 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90BB81A1280;
        Fri,  1 Apr 2022 19:40:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648867238; x=1680403238;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=bj4rfjg830Wz124zyu46gMY5uDkjqoPuQpgNrHl2G3U=;
  b=Wm1ws09myZ6uHiGSS0vhUo6Exp0xBZMfG5s0eraGqXImVhmZNfDEqLxY
   fM5uPEmACgCbS8sF/yOgNZpGwoumM7wlRRwLhdtM7mguRY3wTK8S95i0z
   cOYG04KnIsmx0IA1Zq5X844LczdEgECNJQzFEbCpLwx3tUZvdhhFK3TeN
   OKu8KNfer921lnuWc+GMU7sUVkWg377cPzeFOl2BUnrS/i3/8cGwQZvKt
   6YdI4nRHSA6y5UTHB90zz1ElNkmlZkk7C5JI0myp1WeFcIbeLdU7dsxFE
   8tylG490Yl5Kp3Htq3jHx5SL61YFQs5fVS4NaAL88UWEwArfI93YMStIw
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10304"; a="257850134"
X-IronPort-AV: E=Sophos;i="5.90,229,1643702400"; 
   d="scan'208";a="257850134"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2022 19:40:38 -0700
X-IronPort-AV: E=Sophos;i="5.90,229,1643702400"; 
   d="scan'208";a="548030893"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.255.31.112]) ([10.255.31.112])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2022 19:40:35 -0700
Message-ID: <bd18fe0e-6e74-f89c-a754-15da2aa2eb96@intel.com>
Date:   Sat, 2 Apr 2022 10:40:32 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.6.1
Subject: Re: [RFC PATCH v5 008/104] KVM: TDX: Add a function to initialize TDX
 module
Content-Language: en-US
To:     Isaku Yamahata <isaku.yamahata@gmail.com>
Cc:     Kai Huang <kai.huang@intel.com>, isaku.yamahata@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <b92217283fa96b85e9a683ca3fcf1b368cf8d1c4.1646422845.git.isaku.yamahata@intel.com>
 <36aac3cb7c7447db6454ee396e25eea3bad378e6.camel@intel.com>
 <20220331194144.GA2084469@ls.amr.corp.intel.com>
 <d63042a2-91d8-5555-1bac-4d908e03da2b@intel.com>
 <20220401201806.GA2862421@ls.amr.corp.intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20220401201806.GA2862421@ls.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/2/2022 4:18 AM, Isaku Yamahata wrote:
> On Fri, Apr 01, 2022 at 02:56:40PM +0800,
> Xiaoyao Li <xiaoyao.li@intel.com> wrote:
> 
>> On 4/1/2022 3:41 AM, Isaku Yamahata wrote:
>>> On Thu, Mar 31, 2022 at 04:31:10PM +1300,
>>> Kai Huang <kai.huang@intel.com> wrote:
>>>
>>>> On Fri, 2022-03-04 at 11:48 -0800, isaku.yamahata@intel.com wrote:
>>>>> From: Isaku Yamahata <isaku.yamahata@intel.com>
>>>
>>>>> Add a wrapper function to initialize the TDX module and get system-wide
>>>>> parameters via those APIs.  Because TDX requires VMX enabled, It will be
>>>>> called on-demand when the first guest TD is created via x86 KVM init_vm
>>>>> callback.
>>>>
>>>> Why not just merge this patch with the change where you implement the init_vm
>>>> callback?  Then you can just declare this patch as "detect and initialize TDX
>>>> module when first VM is created", or something like that..
>>>
>>> Ok. Anyway in the next respoin, tdx module initialization will be done when
>>> loading kvm_intel.ko.  So the whole part will be changed and will be a part
>>> of module loading.
>>
>> Will we change the GET_TDX_CAPABILITIES ioctl back to KVM scope?
> 
> No because it system scoped KVM_TDX_CAPABILITIES requires one more callback for
> it.  We can reduce the change.
> 
> Or do you have any use case for system scoped KVM_TDX_CAPABILITIES?

No. Just to confirm.

on the other hand, vm-scope IOCTL seems more flexible if different 
capabilities are reported per VM in the future.
