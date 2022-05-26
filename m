Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45CBF53490E
	for <lists+kvm@lfdr.de>; Thu, 26 May 2022 04:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238848AbiEZCzP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 May 2022 22:55:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232535AbiEZCzN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 May 2022 22:55:13 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2281FAF31D
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 19:55:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653533713; x=1685069713;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ACUvpAw4fP8n3H8/+ddBfvDqIhHF+X4k+5/2EXHVwn8=;
  b=mrI3BcgLK0ZgEVOlhJ/dNXs2/ftAnPIFFc9qUiwl81nqrUhAiKBA40Iy
   W8B/sQWDwML5hG7rKmBdJSmckmM7glKz7mmj9irGROu79Z5RQ7JpvSoLU
   V6nC69nA/MIebt63i75F0uFajaeyY+5AwJSC5OB6ZVBJrL83InyltM1VC
   wSllp5DWZ1th/BaJESaD/s+ZuXTmjGwRDMKq1aWKrCLqw6FuLpL2ANrbb
   roLhYaFiMx2HzklhNdHb8P+eyq3hYn8sT8OHNtjfkVJ4GOX4XV5BWAJs9
   gfzTAqtyKk3awrDByx+tjIIc6HcoiCplw1mC7ioyCb2ZJykDghm6I8aCK
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10358"; a="274115671"
X-IronPort-AV: E=Sophos;i="5.91,252,1647327600"; 
   d="scan'208";a="274115671"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2022 19:49:03 -0700
X-IronPort-AV: E=Sophos;i="5.91,252,1647327600"; 
   d="scan'208";a="573640580"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.255.28.212]) ([10.255.28.212])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2022 19:48:58 -0700
Message-ID: <b294af31-fe92-f251-5d3e-0e439a59ee1e@intel.com>
Date:   Thu, 26 May 2022 10:48:56 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.9.0
Subject: Re: [RFC PATCH v4 18/36] i386/tdx: Skip BIOS shadowing setup
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
 <20220512031803.3315890-19-xiaoyao.li@intel.com>
 <20220524070804.tcrsg7cwlnbkzhjz@sirius.home.kraxel.org>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20220524070804.tcrsg7cwlnbkzhjz@sirius.home.kraxel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/24/2022 3:08 PM, Gerd Hoffmann wrote:
> On Thu, May 12, 2022 at 11:17:45AM +0800, Xiaoyao Li wrote:
>> TDX guest cannot go to real mode, so just skip the setup of isa-bios.
> 
> Does isa-bios setup cause any actual problems?
> (same question for patch #19).

It causes mem_region split and mem_slot deletion on KVM.

TDVF marks pages starting from 0x800000 as TEMP_MEM and TD_HOB, which 
are TD's private memory and are TDH_MEM_PAGE_ADD'ed to TD via 
KVM_TDX_INIT_MEM_REGION

However, if isa-bios and pc.rom are not skipped, the memory_region 
initialization of them is after KVM_TDX_INIT_MEM_REGION in 
tdx_machine_done_notify(). (I didn't figure out why this order though)

And the it causes memory region split that splits
	[0, ram_below_4g)
to
	[0, 0xc0 000),
	[0xc0 000, 0xe0 000),
	[0xe0 000, 0x100 000),
	[0x100 000, ram_below_4g)

which causes mem_slot deletion on KVM. On KVM side, we lose the page 
content when mem_slot deletion. Thus, the we lose the content of TD HOB.

Yes, the better solution seems to be ensure KVM_TDX_INIT_MEM_REGION is 
called after all the mem region is settled down. But I haven't figured 
out the reason why the isa-bios and pc.rom initialization happens after
machine_init_done_notifier

on the other hand, to keep isa-bios and pc.rom, we need additional work 
to copy the content from the end_of_4G to end_of_1M.

I'm not sure if isa-bios and pc.rom are needed from people on TD guest, 
so I just skip them for simplicity,

> "is not needed" IMHO isn't a good enough reason to special-case tdx
> here.
> 
> take care,
>    Gerd
> 

