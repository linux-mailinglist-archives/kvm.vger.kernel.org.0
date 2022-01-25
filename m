Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB6D149ADF8
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 09:27:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379055AbiAYI0B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 03:26:01 -0500
Received: from mga18.intel.com ([134.134.136.126]:33198 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1449962AbiAYIXF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jan 2022 03:23:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643098985; x=1674634985;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=nQhmw9tqKel7ByAdCmGlBqrn9SP/aEAWIm/Z2cqpZcs=;
  b=YN4ADf8RQoxlLpt4YJMMCqjIRoeiEvp7FiVu11Hbmh45n9GCup1hzMvf
   0wXpNjeAvpfw+e0BCaT+MA16d2Ux2RQfUVGSSNICCf1i4tIf5ds8SnxJ8
   RgdgILDb+v5TBtfLE1qn01E4uxKUY15N7TB7i5GnjBnEpqWAjpIIt4YhR
   rgP7SqbbGaT5bqtLMdb0TUpCqM/oN63HMSmJtTnGlmnDqMi7+V3DPlrb3
   R+46UxKXFSRz9Lq10u41lr5h4kJ4tOv8pyzLGFb9moSE3FEfB6yxhRkvx
   rXCtJMtRxxUFL3tnTSqj2w5EHX1Bzl4SQfx91a/+rZKKcyoU+T2AdnrS3
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10237"; a="229826060"
X-IronPort-AV: E=Sophos;i="5.88,314,1635231600"; 
   d="scan'208";a="229826060"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2022 00:22:46 -0800
X-IronPort-AV: E=Sophos;i="5.88,314,1635231600"; 
   d="scan'208";a="534628975"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.255.30.216]) ([10.255.30.216])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2022 00:22:40 -0800
Message-ID: <21af8d43-75dd-6b32-5362-f8a9575cba8f@intel.com>
Date:   Tue, 25 Jan 2022 16:22:38 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.5.0
Subject: Re: [RFC PATCH v2 20/44] i386/tdx: Parse tdx metadata and store the
 result into TdxGuestState
Content-Language: en-US
To:     Gerd Hoffmann <kraxel@redhat.com>
Cc:     Laszlo Ersek <lersek@redhat.com>, isaku.yamahata@gmail.com,
        qemu-devel@nongnu.org, pbonzini@redhat.com, alistair@alistair23.me,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, mst@redhat.com,
        cohuck@redhat.com, mtosatti@redhat.com, seanjc@google.com,
        erdemaktas@google.com, kvm@vger.kernel.org,
        isaku.yamahata@intel.com, "Min M . Xu" <min.m.xu@intel.com>,
        "Daniel P. Berrange" <berrange@redhat.com>
References: <cover.1625704980.git.isaku.yamahata@intel.com>
 <acaf651389c3f407a9d6d0a2e943daf0a85bb5fc.1625704981.git.isaku.yamahata@intel.com>
 <20210826111838.fgbp6v6gd5wzbnho@sirius.home.kraxel.org>
 <a97a75ad-9d1c-a09f-281b-d6b0a7652e78@intel.com>
 <4eb6a628-0af6-409b-7e42-52787ee3e69d@redhat.com>
 <e74fcb88-3add-4bb7-4508-742db44fa3c8@intel.com>
 <20220110110120.ldjekirdzgmgex4z@sirius.home.kraxel.org>
 <8793aa69-3416-d48e-d690-9f70b1784b46@intel.com>
 <20220125074225.sqxukflp3vat7ilu@sirius.home.kraxel.org>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20220125074225.sqxukflp3vat7ilu@sirius.home.kraxel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/25/2022 3:42 PM, Gerd Hoffmann wrote:
>> Regarding what interface should be used to load TDVF, there are three
>> options:
>>
>>    1) pflash: the same as how we load OVMF.
>>
>>    Suppose TDVF support will finally get into OVMF, using this
>>    interface, it's full compatible with normal VMs. No change required
>>    to QEMU command line and TDVF binary is mapped to the GPA address
>>    right below 4G, but they are actually mapped as RAM.
>>
>>    Of course, we need several hacks (special handling) in QEMU.
> 
> What kind if "hack"?

For example, several pflash codes require the support of read-only 
memslot from KVM. We need to absolve it for TDX guest.

And the pflash won't work as a flash device that no write induced 
KVM_EXIT_MMIO will go to its callback.

>>    Of course, they don't work as flash, the change made to it doesn't
>>    persist.
>>
>>    2) -bios
>>
>>    exploit "-bios" parameter to load TDVF. But again, read-only is not
>>    supported. TDVF is mapped as RAM.
>>
>>    3) generic loader
>>
>>    Just like what this series does. Implement specific parser in generic
>>    loader to load and parse TDVF as private RAM.
>>
>> I'm nor sure if 1) is acceptable from your side. If not, we will go with
>> option 3, since 2) doesn't make too much sense.
> 
> Yep, Daniel (Cc'ed) tried (2) recently for SEV.  Didn't work due to
> differences in -bios and -pflash reset handling.  So that option is
> out I guess.
> 
> SEV uses (1), and there is some support code which you should be able to
> reuse (walker for the list of guid-sections with meta-data in the ovmf
> reset vector for example).
> 
> So TDX going for (1) too is probably the best option.

Yes. With option 1), it's friendly to user that no command change.
And also compatible for future TDX/TDVF when non-volatile variable is 
supported.

Next version of this series will go with option 1). Let's wait and see 
if the real implementation is acceptable or not.

> take care,
>    Gerd
> 

