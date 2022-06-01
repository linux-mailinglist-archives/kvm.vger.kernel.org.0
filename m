Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC2FE539E1D
	for <lists+kvm@lfdr.de>; Wed,  1 Jun 2022 09:21:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344829AbiFAHVH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jun 2022 03:21:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346057AbiFAHUy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jun 2022 03:20:54 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A68FB129
        for <kvm@vger.kernel.org>; Wed,  1 Jun 2022 00:20:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654068053; x=1685604053;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=l+XiHh7anBduFpnJiS88+SjvrMYYjtp3avkrqqQLOEw=;
  b=S70Tt1Q4yM7OB8tISVzwvN5DQnDmquhCOix/GRDb8FxrtCPK+iB7KMkW
   TJnA8AZoCpJjUTsF4ZR68jjp7+haO2bkVfBWSE8QBylQc+m1S63Lc8Ql0
   cqDuMupqNCu/FEfsH7pTP2q2XfWT8y084SbKcsZZbzMHiUNi6t7X7wERo
   TAKvkK78LgoH7ctERydxy0qzSYImAkGeUOuUYF+pougbESZ3V/HYYjsXd
   rli/H8HIm9ZjooeITWTGLQ09YiO3Xh9EeHdjsloPaijpe/nvKe9tKqfsF
   8gXoU91KmdYTkhAfDTlx2fGhQXaIauPB+1Hrq4A6ZNzy1xg5Ncy9jWxhT
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10364"; a="336158087"
X-IronPort-AV: E=Sophos;i="5.91,266,1647327600"; 
   d="scan'208";a="336158087"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2022 00:20:53 -0700
X-IronPort-AV: E=Sophos;i="5.91,266,1647327600"; 
   d="scan'208";a="576804072"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.249.172.148]) ([10.249.172.148])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2022 00:20:48 -0700
Message-ID: <39341481-67b6-aba4-a25a-10abb398bec4@intel.com>
Date:   Wed, 1 Jun 2022 15:20:46 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.9.0
Subject: Re: [RFC PATCH v4 11/36] i386/tdx: Initialize TDX before creating TD
 vcpus
Content-Language: en-US
To:     Gerd Hoffmann <kraxel@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        isaku.yamahata@intel.com,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Laszlo Ersek <lersek@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Connor Kuehl <ckuehl@redhat.com>, erdemaktas@google.com,
        kvm@vger.kernel.org, qemu-devel@nongnu.org, seanjc@google.com
References: <20220512031803.3315890-1-xiaoyao.li@intel.com>
 <20220512031803.3315890-12-xiaoyao.li@intel.com>
 <20220523092003.lm4vzfpfh4ezfcmy@sirius.home.kraxel.org>
 <d3e967f3-917f-27ce-1367-2dba23e5c241@intel.com>
 <20220524065719.wyyoba2ke73tx3nc@sirius.home.kraxel.org>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20220524065719.wyyoba2ke73tx3nc@sirius.home.kraxel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/24/2022 2:57 PM, Gerd Hoffmann wrote:
>    Hi,
> 
>>> Hmm, hooking *vm* initialization into *vcpu* creation looks wrong to me.
>>
>> That's because for TDX, it has to do VM-scope (feature) initialization
>> before creating vcpu. This is new to KVM and QEMU, that every feature is
>> vcpu-scope and configured per-vcpu before.
>>
>> To minimize the change to QEMU, we want to utilize @cpu and @cpu->env to
>> grab the configuration info. That's why it goes this way.
>>
>> Do you have any better idea on it?
> 
> Maybe it's a bit more work to add VM-scope initialization support to
> qemu.  

If just introducing VM-scope initialization to QEMU, it would be easy. 
What matters is what needs to be done inside VM-scope initialization.

For TDX, we need to settle down the features that configured for the TD. 
Typically, the features are attributes of cpu object, parsed from "-cpu" 
option and stored in cpu object.

I cannot think up a clean solution for it, other than
1) implement the same attributes from cpu object to machine object, or
2) create a CPU object when initializing machine object and collect all 
the info from "-cpu" and drop it in the end; then why not do it when 
creating 1st vcpu like this patch.

That's what I can think up. Let's see if anyone has better idea.

> But I expect that approach will work better long-term.  You need
> this mutex and the 'initialized' variable in your code to make sure it
> runs only once because the way you hook it in is not ideal ...
> 
> [ disclaimer: I'm not that familiar with the kvm interface in qemu ]
> 
> take care,
>    Gerd
> 

