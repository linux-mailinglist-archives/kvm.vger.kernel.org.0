Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0291E4EE8AD
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 08:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343568AbiDAG6q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 02:58:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343565AbiDAG6m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 02:58:42 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B243B19F45E;
        Thu, 31 Mar 2022 23:56:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648796207; x=1680332207;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Wxp4yJ/NukfxY6U5mWq/JBboluF6jxxrl8HF3wv1pMc=;
  b=eKgaeZs2O26Nin60M62tJcf55tS38SGNyv7Xg65rho9I7cXRxzvxZdOV
   lVg8aNJEZF2y3yyLjKuIWLOBxZrzMTxKvDWvq8NEZcxOnbPHUyGhRXJHj
   vtEkZECGe8Ke3xqaEKSvCHumW9QirU2L9I8sHJmkDfX1ZOoiR7JOKRisO
   ygxoS2KdWxieN69xbmRPKK9KaubAxHUyKgvGZtrwYoBDlROy/tzMphyiv
   oL0NbM0gBIDKv5rkDJsKrDSOQ4ZMChYzGWCXb+ApG/NluMfoarQPv7H+z
   NcMh4NlIURuy9eqlDr6OYNlECy5bznV9u1zC8BHiDElGzG/Miy5e3jFTt
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10303"; a="260045758"
X-IronPort-AV: E=Sophos;i="5.90,226,1643702400"; 
   d="scan'208";a="260045758"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2022 23:56:46 -0700
X-IronPort-AV: E=Sophos;i="5.90,226,1643702400"; 
   d="scan'208";a="567217562"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.249.171.24]) ([10.249.171.24])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2022 23:56:43 -0700
Message-ID: <d63042a2-91d8-5555-1bac-4d908e03da2b@intel.com>
Date:   Fri, 1 Apr 2022 14:56:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.6.1
Subject: Re: [RFC PATCH v5 008/104] KVM: TDX: Add a function to initialize TDX
 module
Content-Language: en-US
To:     Isaku Yamahata <isaku.yamahata@gmail.com>,
        Kai Huang <kai.huang@intel.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <b92217283fa96b85e9a683ca3fcf1b368cf8d1c4.1646422845.git.isaku.yamahata@intel.com>
 <36aac3cb7c7447db6454ee396e25eea3bad378e6.camel@intel.com>
 <20220331194144.GA2084469@ls.amr.corp.intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20220331194144.GA2084469@ls.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/1/2022 3:41 AM, Isaku Yamahata wrote:
> On Thu, Mar 31, 2022 at 04:31:10PM +1300,
> Kai Huang <kai.huang@intel.com> wrote:
> 
>> On Fri, 2022-03-04 at 11:48 -0800, isaku.yamahata@intel.com wrote:
>>> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
>>> Add a wrapper function to initialize the TDX module and get system-wide
>>> parameters via those APIs.  Because TDX requires VMX enabled, It will be
>>> called on-demand when the first guest TD is created via x86 KVM init_vm
>>> callback.
>>
>> Why not just merge this patch with the change where you implement the init_vm
>> callback?  Then you can just declare this patch as "detect and initialize TDX
>> module when first VM is created", or something like that..
> 
> Ok. Anyway in the next respoin, tdx module initialization will be done when
> loading kvm_intel.ko.  So the whole part will be changed and will be a part
> of module loading.

Will we change the GET_TDX_CAPABILITIES ioctl back to KVM scope?
