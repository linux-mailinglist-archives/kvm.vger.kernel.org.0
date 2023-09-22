Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9308E7AA602
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 02:23:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229899AbjIVAW4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 20:22:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbjIVAWy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 20:22:54 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D721D118
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 17:22:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695342168; x=1726878168;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ewiBLJ54nNGKRJj+GjF255twIywKxcnwQngXvj35lcQ=;
  b=SBXPKGbh66cTtzXap/255j5xzaAfPnzyGwaVHcsHW+LLk1dWEZIiQEU9
   DMbXHDPR29KUTjqCZNxByNhokVbPC9I1uTuIfAUoDrc7FxsLLBBT9vFEc
   nTO6kgXAHPIRm+V9TCOH7SRlwU/GOIVhHMwpxaUwZc4OuOh4nGQJdUkom
   3Me1bP32jTZmY0gLwIa4bY4nG8lS/++cFfS7OvFq0o325/oP5Pv7w+I2P
   ciS598Exu2vbfDexj8U5aLA2IqVgVexP+qPIaiw3atl20b6dICVqB51I0
   9SmIx4m0NA7jWjo1O450W0xeRv3zon9KksfmRtM91jqdMkPEFZW2jHO9A
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10840"; a="360088298"
X-IronPort-AV: E=Sophos;i="6.03,166,1694761200"; 
   d="scan'208";a="360088298"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2023 17:22:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10840"; a="747341198"
X-IronPort-AV: E=Sophos;i="6.03,166,1694761200"; 
   d="scan'208";a="747341198"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.11.250]) ([10.93.11.250])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2023 17:22:42 -0700
Message-ID: <183684ec-8ee5-df22-ca5b-5ca3a0886ca1@intel.com>
Date:   Fri, 22 Sep 2023 08:22:41 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.15.1
Subject: Re: [RFC PATCH v2 04/21] memory: Introduce
 memory_region_has_gmem_fd()
Content-Language: en-US
To:     David Hildenbrand <david@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Peter Xu <peterx@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Michael Roth <michael.roth@amd.com>, isaku.yamahata@gmail.com,
        Sean Christopherson <seanjc@google.com>,
        Claudio Fontana <cfontana@suse.de>
References: <20230914035117.3285885-1-xiaoyao.li@intel.com>
 <20230914035117.3285885-5-xiaoyao.li@intel.com>
 <f525d4da-0878-b4bc-f9cf-7b824abfef0a@redhat.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <f525d4da-0878-b4bc-f9cf-7b824abfef0a@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/21/2023 4:46 PM, David Hildenbrand wrote:
> On 14.09.23 05:51, Xiaoyao Li wrote:
>> Introduce memory_region_has_gmem_fd() to query if the MemoryRegion has
>> KVM gmem fd allocated.
> 
> *probably* best to just squash that into patch #2.

Sure, I will do it.
