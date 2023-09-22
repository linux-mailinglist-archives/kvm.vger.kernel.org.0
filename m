Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75F9D7AA601
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 02:22:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbjIVAWc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 20:22:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjIVAWb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 20:22:31 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6ACB102
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 17:22:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695342145; x=1726878145;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=FogeaomQX2VVcu9AEHsQgloDflBQsHSa+RD1u+C6qTc=;
  b=ePzk56AdudhIEnDVndwhszQzVw1RCHzweQxS+EB0OZm9opXSiftHM/o7
   1dEqgEYYIuChLzRmSef8YkKTz613Ali8PSZ6TN+tsI0QMVy2BqH57GSNN
   Y56/Oio6ekbwrs4SDu1zQOxx9fwyFMUfO+yPI3zVWrSA3973733bjIqls
   0qMi3KTqbSe69qYHin57TLyK6iCwshsOuBkyipptfT592/1X/EorzQhDg
   34edoqqW6d7f7wppCvQt1vwxG4+X/M2dggMIv27jBwl8HM74ZauG3sIIZ
   u8JE5IS7EfUaJMqdU8TgpcgCF+Iu2og2VgDnP/W2sa1MLsQkOZCdfabrl
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10840"; a="360088254"
X-IronPort-AV: E=Sophos;i="6.03,166,1694761200"; 
   d="scan'208";a="360088254"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2023 17:22:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10840"; a="747341164"
X-IronPort-AV: E=Sophos;i="6.03,166,1694761200"; 
   d="scan'208";a="747341164"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.11.250]) ([10.93.11.250])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2023 17:22:20 -0700
Message-ID: <6eeb5568-2faa-85c3-8f42-ed6317ea376c@intel.com>
Date:   Fri, 22 Sep 2023 08:22:17 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.15.1
Subject: Re: [RFC PATCH v2 02/21] RAMBlock: Add support of KVM private gmem
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
 <20230914035117.3285885-3-xiaoyao.li@intel.com>
 <678bf0bf-57e7-a596-1ddf-6d0b47cd8677@redhat.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <678bf0bf-57e7-a596-1ddf-6d0b47cd8677@redhat.com>
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

On 9/21/2023 4:55 PM, David Hildenbrand wrote:
> On 14.09.23 05:50, Xiaoyao Li wrote:
>> From: Chao Peng <chao.p.peng@linux.intel.com>
>>
>> Add KVM gmem support to RAMBlock so both normal hva based memory
>> and kvm gmem fd based private memory can be associated in one RAMBlock.
>>
>> Introduce new flag RAM_KVM_GMEM. It calls KVM ioctl to create private
>> gmem for the RAMBlock when it's set.
> 
> 
> But who sets RAM_KVM_GMEM and when? 

The answer is in the next patch. When `private` property of memory 
backend is set to true, it will pass RAM_KVM_GMEM flag to 
memory_region_init_ram_*()

> Don't we simply allocate it for all 
> RAMBlocks under such special VMs? 

yes, this is the direction after your comments.

I'll try to figure out how to achieve it.

> What's the downside of doing that?

As far as I see, for TDX, no downside.

