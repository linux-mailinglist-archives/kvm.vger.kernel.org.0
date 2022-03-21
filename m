Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 145A44E2075
	for <lists+kvm@lfdr.de>; Mon, 21 Mar 2022 07:08:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344471AbiCUGJu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Mar 2022 02:09:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234584AbiCUGJr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Mar 2022 02:09:47 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4FAB15A01
        for <kvm@vger.kernel.org>; Sun, 20 Mar 2022 23:08:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647842902; x=1679378902;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=gk3r9H77ctg1IpRHX33yDmxGf6+MwoJQhtFLQ7e4Uuw=;
  b=TPFE+Rzx4552f+6L7640rD6Z0UnRPZXfC0Bzr8CB6CO+dEyk3KBDls5m
   szNnszioZlese7rymEHc5gsKSkoquLzCObGq9V/NSkZkMwnzA+q0EDLCM
   0P+9mtGSV0Ey7Cdp3Qi+uRUAWHjXqLsdmuVbyCh9XaKc8Z4XBw89H+bXk
   CkN9ScIv68E9Gkwiif80xMNFWG//UmnqkQmgnZHq4R4ulKiyPHRuqGCrc
   b8cDK/Cc5DHe2KkNfZPtqz6hGc83J4EjIidU9fSSOFni9eoO42rQjFFMF
   dR3lOY61MkyOliGvYQavOEVY3GyFUqlvv4xuknXb6HQ8Gira/BMpWwkuk
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10292"; a="257667441"
X-IronPort-AV: E=Sophos;i="5.90,197,1643702400"; 
   d="scan'208";a="257667441"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2022 23:08:22 -0700
X-IronPort-AV: E=Sophos;i="5.90,197,1643702400"; 
   d="scan'208";a="559719245"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.249.169.245]) ([10.249.169.245])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2022 23:08:17 -0700
Message-ID: <784e854a-09ca-883a-509a-dd196bb3f7d6@intel.com>
Date:   Mon, 21 Mar 2022 14:08:15 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.6.1
Subject: Re: [RFC PATCH v3 33/36] i386/tdx: Only configure MSR_IA32_UCODE_REV
 in kvm_init_msrs() for TDs
Content-Language: en-US
To:     Isaku Yamahata <isaku.yamahata@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Philippe Mathieu-Daud??? <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "Daniel P. Berrang???" <berrange@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Laszlo Ersek <lersek@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Eric Blake <eblake@redhat.com>, isaku.yamahata@intel.com,
        kvm@vger.kernel.org, Connor Kuehl <ckuehl@redhat.com>,
        seanjc@google.com, qemu-devel@nongnu.org, erdemaktas@google.com
References: <20220317135913.2166202-1-xiaoyao.li@intel.com>
 <20220317135913.2166202-34-xiaoyao.li@intel.com>
 <20220318173120.GB4050087@ls.amr.corp.intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20220318173120.GB4050087@ls.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/19/2022 1:31 AM, Isaku Yamahata wrote:
> On Thu, Mar 17, 2022 at 09:59:10PM +0800,
> Xiaoyao Li <xiaoyao.li@intel.com> wrote:
> 
>> For TDs, only MSR_IA32_UCODE_REV in kvm_init_msrs() can be configured
>> by VMM, while the features enumerated/controlled by other MSRs except
>> MSR_IA32_UCODE_REV in kvm_init_msrs() are not under control of VMM.
>>
>> Only configure MSR_IA32_UCODE_REV for TDs.
> 
> non-TDs?

No. It meant exactly TDs.

Only MSR_IA32_UCODE_REV is supported to be emulated by VMM for TDs.
