Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 667DE53128A
	for <lists+kvm@lfdr.de>; Mon, 23 May 2022 18:22:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237888AbiEWPad (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 May 2022 11:30:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237879AbiEWPac (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 May 2022 11:30:32 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 209FA5FF36
        for <kvm@vger.kernel.org>; Mon, 23 May 2022 08:30:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653319831; x=1684855831;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=7OenGLB7dGpptwRRzjJaPmhu5ShRYU9QhFSj1l1mbT8=;
  b=Uhn4xmGhvhMd7pzLfDbGBc9gviUz74WJ5ZLNB1PrEdZt7YAdziXNHL9A
   kBwAFR/GtcYJnB78JaGXAxTOz3SsoiV0oslfoo7z2Sgn30P/SQOuorx8s
   zk4v9ZBjtFnj048aL/f7BGNOgWTigMAlsN2r93MAcXQpgJ+IKtdfK3aPJ
   sXjta4PUjGFH1s/7UrCzsrmL30CKYIBNyA/Rxcy0jW7WZbmOYEqM38f05
   EYkaJiVWEmN0mEGCJAxJNIlE2EfSLkFaRa93t/E5q3Lli+I7hNOuoME/Y
   417mhm7siFAfxm/ZD/MpamKnZNQHiY+TYLTrj2yEQjBQSHZ0FwLPNTKo/
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10356"; a="253758187"
X-IronPort-AV: E=Sophos;i="5.91,246,1647327600"; 
   d="scan'208";a="253758187"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2022 08:30:30 -0700
X-IronPort-AV: E=Sophos;i="5.91,246,1647327600"; 
   d="scan'208";a="600706775"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.249.171.127]) ([10.249.171.127])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2022 08:30:24 -0700
Message-ID: <ee52e4e9-e84f-4654-5414-a9a3fe3a46d7@intel.com>
Date:   Mon, 23 May 2022 23:30:21 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.9.0
Subject: Re: [RFC PATCH v4 06/36] i386/tdx: Get tdx_capabilities via
 KVM_TDX_CAPABILITIES
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
 <20220512031803.3315890-7-xiaoyao.li@intel.com>
 <20220523084530.baedwpbwldc7cbnz@sirius.home.kraxel.org>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20220523084530.baedwpbwldc7cbnz@sirius.home.kraxel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/23/2022 4:45 PM, Gerd Hoffmann wrote:
>    Hi,
> 
>> +    do {
>> +        size = sizeof(struct kvm_tdx_capabilities) +
>> +               max_ent * sizeof(struct kvm_tdx_cpuid_config);
>> +        caps = g_malloc0(size);
>> +        caps->nr_cpuid_configs = max_ent;
>> +
>> +        r = tdx_platform_ioctl(KVM_TDX_CAPABILITIES, 0, caps);
>> +        if (r == -E2BIG) {
>> +            g_free(caps);
>> +            max_ent *= 2;
>> +        } else if (r < 0) {
>> +            error_report("KVM_TDX_CAPABILITIES failed: %s\n", strerror(-r));
>> +            exit(1);
>> +        }
>> +    }
>> +    while (r == -E2BIG);
> 
> This should have a limit for the number of loop runs.

Actually, this logic is copied from get_supported_cpuid().

Anyway, I can put a maximum limit as 256 (it should be large enough) or 
maybe re-use KVM_MAX_CPUID_ENTRIES. When it gets hit, we know we need to 
update QEMU to fit with TDX on new platform.

> take care,
>    Gerd
> 

