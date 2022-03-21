Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63E684E2293
	for <lists+kvm@lfdr.de>; Mon, 21 Mar 2022 09:55:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244355AbiCUI4X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Mar 2022 04:56:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239388AbiCUI4W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Mar 2022 04:56:22 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18C025640B
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 01:54:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647852898; x=1679388898;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Hh41s0fKyb5NLDLam98VzjysnItQcHpDQLFJXPyxjew=;
  b=BUQrYt2zZeoRPryGa7k6Bxj7byefgMusiqz3nBaxVoMYWN+FVa8Ykg5p
   sQ6waKzj1mJoik+SDVxfPfJ6OOC26OmAqxZgEvaduP15zpMGZ8U+43DGj
   jFE17G1MKGdlYeOyX8hr4CryRsaI39GZy18jLSprXBcuGDdRv4K7zsWvH
   z6Iz9uGwIj49iLzDd4FwlgacENbmwCjLGzRnVCYsUN06xekNOf7ltr5rS
   +oJi9oO4n6A4TMTXYBfkAf7iyc4sheR+XNS/YQCiF9nBA+HXa/KokQ5UM
   1nGInOUoVdYTD/rDUFjXr7Ffp47T6SWD4VK8wJbXWoeZ73qXSj9frFeuL
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10292"; a="256321337"
X-IronPort-AV: E=Sophos;i="5.90,198,1643702400"; 
   d="scan'208";a="256321337"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2022 01:54:57 -0700
X-IronPort-AV: E=Sophos;i="5.90,198,1643702400"; 
   d="scan'208";a="500103014"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.255.28.249]) ([10.255.28.249])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2022 01:54:53 -0700
Message-ID: <7a8233e4-0cae-b05a-7931-695a7ee87fc9@intel.com>
Date:   Mon, 21 Mar 2022 16:54:51 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.6.1
Subject: Re: [RFC PATCH v3 17/36] pflash_cfi01/tdx: Introduce ram_mode of
 pflash for TDVF
Content-Language: en-US
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= 
        <philippe.mathieu.daude@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Cornelia Huck <cohuck@redhat.com>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Laszlo Ersek <lersek@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Eric Blake <eblake@redhat.com>
Cc:     Connor Kuehl <ckuehl@redhat.com>, isaku.yamahata@intel.com,
        erdemaktas@google.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        seanjc@google.com
References: <20220317135913.2166202-1-xiaoyao.li@intel.com>
 <20220317135913.2166202-18-xiaoyao.li@intel.com>
 <f418548e-c24c-1bc3-4e16-d7a775298a18@gmail.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <f418548e-c24c-1bc3-4e16-d7a775298a18@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/18/2022 10:07 PM, Philippe Mathieu-Daudé wrote:
> Hi,
> 
> On 17/3/22 14:58, Xiaoyao Li wrote:
>> TDX VM needs to boot with Trust Domain Virtual Firmware (TDVF). Unlike
>> that OVMF is mapped as rom device, TDVF needs to be mapped as private
>> memory. This is because TDX architecture doesn't provide read-only
>> capability for VMM, and it doesn't support instruction emulation due
>> to guest memory and registers are not accessible for VMM.
>>
>> On the other hand, OVMF can work as TDVF, which is usually configured
>> as pflash device in QEMU. To keep the same usage (QEMU parameter),
>> introduce ram_mode to pflash for TDVF. When it's creating a TDX VM,
>> ram_mode will be enabled automatically that map the firmware as RAM.
>>
>> Note, this implies two things:
>>   1. TDVF (OVMF) is not read-only (write-protected).
>>
>>   2. It doesn't support non-volatile UEFI variables as what pflash
>>      supports that the change to non-volatile UEFI variables won't get
>>      synced back to backend vars.fd file.
>>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> ---
>>   hw/block/pflash_cfi01.c | 25 ++++++++++++++++++-------
>>   hw/i386/pc_sysfw.c      | 14 +++++++++++---
>>   2 files changed, 29 insertions(+), 10 deletions(-)
> 
> If you don't need a pflash device, don't use it: simply map your nvram
> region as ram in your machine. No need to clutter the pflash model like
> that.

I know it's dirty to hack the pflash device. The purpose is to make the 
user interface unchanged that people can still use

	-drive if=pflash,format=raw,unit=0,file=/path/to/OVMF_CODE.fd
         -drive if=pflash,format=raw,unit=1,file=/path/to/OVMF_VARS.fd

to create TD guest.

I can go back to use generic loader[1] to load TDVF in v2.

[1] 
https://lore.kernel.org/qemu-devel/acaf651389c3f407a9d6d0a2e943daf0a85bb5fc.1625704981.git.isaku.yamahata@intel.com/ 


> NAcked-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
> 

