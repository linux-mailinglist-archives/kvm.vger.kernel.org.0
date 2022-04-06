Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 457534F6596
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 18:43:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237375AbiDFQaK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 12:30:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237706AbiDFQ3h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 12:29:37 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CEA543B83B;
        Tue,  5 Apr 2022 18:55:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649210102; x=1680746102;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=S/gcWPbQqOYy2qVePMHR8mvnRPUxCPUqOYRtPIoCTPY=;
  b=CKOAgXFs/ACH9HTYA8ySNi7vqHNHK87sA9u8Ol8qPZHgLMokFErSI0+l
   wrT/tevKj5KPJqYI8+qm748luk3Ulg+amDVtbIIlOKOhpg07tk23BjYyD
   Zwrnb3Z4rpRlj53JOQWSPOWAGUAV9pOpZqZmcx8zkRWdL5ytXhkj+DUpM
   mEd+I4lJ7hVDvAS002qsCCOS7SDwqF33aw2bZ3R9v1ehAGv4670hrg3jP
   9+po+yqcRbgIgvRqtopV24A4rHC41t5TD2u6R3a4i6vFYt+kixxhgEj27
   +nMNN9EhU5XwGR8qyhARvrljLkGEpnL+pHYBZhxiqbCLjdyFwM58NtK0B
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10308"; a="261099515"
X-IronPort-AV: E=Sophos;i="5.90,238,1643702400"; 
   d="scan'208";a="261099515"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2022 18:54:59 -0700
X-IronPort-AV: E=Sophos;i="5.90,238,1643702400"; 
   d="scan'208";a="570281512"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.249.175.134]) ([10.249.175.134])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2022 18:54:56 -0700
Message-ID: <17981a2e-03e3-81df-0654-5ccb29f43546@intel.com>
Date:   Wed, 6 Apr 2022 09:54:05 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v5 026/104] KVM: TDX: x86: Add vm ioctl to get TDX
 systemwide parameters
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>, isaku.yamahata@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <5ff08ce32be458581afe59caa05d813d0e4a1ef0.1646422845.git.isaku.yamahata@intel.com>
 <586be87a-4f81-ea43-2078-a6004b4aba08@redhat.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <586be87a-4f81-ea43-2078-a6004b4aba08@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/5/2022 8:52 PM, Paolo Bonzini wrote:
> On 3/4/22 20:48, isaku.yamahata@intel.com wrote:
>> Implement a VM-scoped subcomment to get system-wide parameters.  Although
>> this is system-wide parameters not per-VM, this subcomand is VM-scoped
>> because
>> - Device model needs TDX system-wide parameters after creating KVM VM.
>> - This subcommands requires to initialize TDX module.  For lazy
>>    initialization of the TDX module, vm-scope ioctl is better.
> 
> Since there was agreement to install the TDX module on load, please 
> place this ioctl on the /dev/kvm file descriptor.
> 
> At least for SEV, there were cases where the system-wide parameters are 
> needed outside KVM, so it's better to avoid requiring a VM file descriptor.

I don't have strong preference on KVM-scope ioctl or VM-scope.

Initially, we made it KVM-scope and change it to VM-scope in this 
version. Yes, it returns the info from TDX module, which doesn't vary 
per VM. However, what if we want to return different capabilities 
(software controlled capabilities) per VM? Part of the TDX capabilities 
serves like get_supported_cpuid, making it KVM wide lacks the 
flexibility to return differentiated capabilities for different TDs.


> Thanks,
> 
> Paolo
> 

