Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1C987A95DC
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 18:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229493AbjIUQ4Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 12:56:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjIUQ4Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 12:56:24 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DE9EC1
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 09:56:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695315371; x=1726851371;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=XjjSoZ7Kjr8a+VD5sxsSA7OrugdElOS9X7CAZMZJKFg=;
  b=YJd4/cfUlImEqYcKQSoLNSypd2OYD4lRbQzBmoarRd9RGE5OsUE3saD6
   tsPGwcEn7ugd42OYsd4nEUGlJDpS7YxM5PQBWwYvDffHGW/hbGRGSKgJJ
   JP5MKS9kkjV3c1Upz3eod1RZqzEFk45xrgb2Q9PlzrSCTKP5HWiHSI4ik
   X652THXT016Ga2szbpGVaKtNwaDS8kcC4oRDF2UkmOb7/fA+qkzgnvIrc
   pSsC8hv/iHcsniywlx/bHmh/P2x6OCXX121CUD0Cgvf3sZ9iwR2dDvHMe
   d4g912L+5D2fYteiuxhzqklfF5vFfYXgckGlXjhgvhxkeJJYwG3l+zZ3L
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10839"; a="360707406"
X-IronPort-AV: E=Sophos;i="6.03,164,1694761200"; 
   d="scan'208";a="360707406"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2023 01:39:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10839"; a="696653200"
X-IronPort-AV: E=Sophos;i="6.03,164,1694761200"; 
   d="scan'208";a="696653200"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.29.154]) ([10.93.29.154])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2023 01:38:58 -0700
Message-ID: <cfa3ac58-fb1f-b255-772a-ab369a68be68@intel.com>
Date:   Thu, 21 Sep 2023 16:38:55 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.15.1
Subject: Re: [RFC PATCH v2 03/21] HostMem: Add private property and associate
 it with RAM_KVM_GMEM
Content-Language: en-US
To:     Markus Armbruster <armbru@redhat.com>,
        David Hildenbrand <david@redhat.com>
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
        Marcelo Tosatti <mtosatti@redhat.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, Michael Roth <michael.roth@amd.com>,
        isaku.yamahata@gmail.com, Sean Christopherson <seanjc@google.com>,
        Claudio Fontana <cfontana@suse.de>
References: <20230914035117.3285885-1-xiaoyao.li@intel.com>
 <20230914035117.3285885-4-xiaoyao.li@intel.com> <8734zazeag.fsf@pond.sub.org>
 <d0e7e2f8-581d-e708-5ddd-947f2fe9676a@intel.com>
 <878r91nvy4.fsf@pond.sub.org>
 <da598ffc-fa47-3c25-64ea-27ea90d712aa@intel.com>
 <091a40cb-ec26-dd79-aa26-191dc59c03e6@redhat.com>
 <87msxgdf5y.fsf@pond.sub.org>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <87msxgdf5y.fsf@pond.sub.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/20/2023 11:42 PM, Markus Armbruster wrote:
> David Hildenbrand <david@redhat.com> writes:
> 
>> On 20.09.23 16:35, Xiaoyao Li wrote:
>>> On 9/20/2023 3:30 PM, Markus Armbruster wrote:
>>>> Xiaoyao Li <xiaoyao.li@intel.com> writes:
>>>>
>>>>> On 9/19/2023 5:46 PM, Markus Armbruster wrote:
>>>>>> Xiaoyao Li <xiaoyao.li@intel.com> writes:
>>>>>>
>>>>>>> From: Isaku Yamahata <isaku.yamahata@intel.com>
>>>>>>>
>>>>>>> Add a new property "private" to memory backends. When it's set to true,
>>>>>>> it indicates the RAMblock of the backend also requires kvm gmem.
>>>>>> Can you add a brief explanation why you need the property?
>>>>>
>>>>> It provides a mechanism for user to specify whether the memory can serve as private memory (need request kvm gmem).
>>>>
>>>> Yes, but why would a user want such memory?
>>>>
>>> Because KVM demands it for confidential guest, e.g., TDX guest. KVM
>>> demands that the mem slot needs to have KVM_MEM_PRIVATE set and has
>>> valid gmem associated if the guest accesses it as private memory.
> 
> Commit messages should explain why we want the patch.  Documenting "why"
> is at least as important as "what".  If "what" is missing, I can read
> the patch to find out.  If "why" is missing, I'm reduced to guesswork.

I'll try best to improve the commit message of this patch, and all other 
patches.

>> I think as long as there is no demand to have a TDX guest with this property be set to "off", then just don't add it.
>>
>> With a TDX VM, it will can be implicitly active. If we ever have to disable it for selective memory backends, we can add the property and have something like on/off/auto. For now it would be "auto".
> 
> Makes sense to me.

OK. I think I get the answer of open #1 in cover letter.

If no other voice, I'll drop this patch and allocate gmem RAM when 
vm_type is TDX.


