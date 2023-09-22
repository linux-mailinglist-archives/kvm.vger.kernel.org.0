Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73BF87AA9A9
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 09:04:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230254AbjIVHEn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 03:04:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230273AbjIVHEk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 03:04:40 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DA4D18F
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 00:04:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695366274; x=1726902274;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=/UUAcVXG2ViI9IVF3s/SfGomnPqiRRaiDBRjonZhOLE=;
  b=ElMIXImd9gjKZ96v2B/K5XiaDfoqDotCX/7KVPxwDSH7wsZqrkbtKkJ2
   iiXBOT4Cxob059k1ENsd1+UzkA7vPloM5Y0v7E5zVsDnNXSESq0+dhVJI
   BvllCX5Ld560txjE6UBQiyRqZ5MJ5xVsAxlg7lZmobHqcmKhm0mlN/3G8
   vJCJx3OhA7fn7uc6lDih/cx/3QkoISinwUaGlDWPDUkPN3pF+hCvgBwiV
   AWWQybkF1hxl8z7bhTuRk7huMZn5q3HA6U8NHOiH8lQWMLgN45K4ifs0j
   u23PE4NJwRBcp4wLMBkJ1hDaHLn3G/S1v8z1dAYaDUMuDLjcXmMAjoZFq
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10840"; a="411699615"
X-IronPort-AV: E=Sophos;i="6.03,167,1694761200"; 
   d="scan'208";a="411699615"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2023 00:04:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10840"; a="1078262936"
X-IronPort-AV: E=Sophos;i="6.03,167,1694761200"; 
   d="scan'208";a="1078262936"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.11.250]) ([10.93.11.250])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2023 00:03:56 -0700
Message-ID: <ace06668-81fd-3153-5b93-30b0b82aea46@intel.com>
Date:   Fri, 22 Sep 2023 15:03:53 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.15.1
Subject: Re: [RFC PATCH v2 00/21] QEMU gmem implemention
Content-Language: en-US
To:     David Hildenbrand <david@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
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
        Marcelo Tosatti <mtosatti@redhat.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, Michael Roth <michael.roth@amd.com>,
        isaku.yamahata@gmail.com, Claudio Fontana <cfontana@suse.de>
References: <20230914035117.3285885-1-xiaoyao.li@intel.com>
 <fe9f3d19-df01-01e6-a253-f7fe5bdea41f@redhat.com>
 <ZQOu+OE8LWtLTyno@google.com>
 <103096a6-f4b5-d88a-2aac-07dcc86825d6@redhat.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <103096a6-f4b5-d88a-2aac-07dcc86825d6@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/21/2023 5:11 PM, David Hildenbrand wrote:
>>>> 3. What is KVM_X86_SW_PROTECTED_VM going to look like? and do we 
>>>> need it?
>>>>
>>>
>>> Why implement it when you have to ask others for a motivation? 😉
>>>
>>> Personally, I'm not sure if it is really useful, especially in this 
>>> state.
>>
>> Yeah, as of today, KVM_X86_SW_PROTECTED_VM is mainly a development 
>> vehicle,
>> e.g. so that testing gmem doesn't require TDX/SNP hardware, debugging 
>> gmem guests
>> isn't brutally painful, etc.
>>
>> Longer term, I have aspirations of being able to back most VMs with 
>> gmem, but
>> that's going to require quite a bit more work, e.g. gmem needs to be 
>> mappable
>> (when hardware allows it) so that gmem doesn't all but require double 
>> mapping,
>> KVM obviously needs to be able to read/write gmem, etc.
>>
>> The value proposition is that having a guest-first memory type will 
>> allow KVM to
>> optimize and harden gmem in ways that wouldn't be feasible for a more 
>> generic
>> memory implementation.  E.g. memory isn't mapped into host userspace 
>> by default
>> (makes it harder to accidentally corrupt the guest), the guest can 
>> have *larger*
>> mappings than host userspace, guest memory can be served from a 
>> dedicated pool
>> (similar-ish to hugetlb), the pool can be omitted from the direct map, 
>> etc.
>>
> Thanks for that information. Personally, I don't believe "to back most 
> VMs with gmem", but that's a different discussion.
> 
> As a development vehicle to get TDX up and running it might be very 
> valuable indeed. But it doesn't necessarily have to be merged in QEMU 
> for that case -- especially in a semi-finished form.

It's true and I agree with it. I'll drop the KVM_X86_SW_PROTECTED_VM 
part in next version.

How would you like this series to proceed in next version? only the 
patches of gmem support without a user? or together with next QEMU TDX 
series?
