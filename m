Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 742567A86A9
	for <lists+kvm@lfdr.de>; Wed, 20 Sep 2023 16:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234658AbjITOfn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Sep 2023 10:35:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232318AbjITOfm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Sep 2023 10:35:42 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D32AAD
        for <kvm@vger.kernel.org>; Wed, 20 Sep 2023 07:35:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695220537; x=1726756537;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=sH0b1baKbczKWombPJgtMInrODweXnPkKAuTu8OU4t0=;
  b=JGkbgwcoN93sF2o2dK7qMjtpPFtrK65pVZKKTZTffEH9Dp65jJROV3ce
   tHgV0OyRhZ7RFr/sGtxv0qx05X7PkMIIxi/z4KofzzLgt+dLsoVopCPK2
   7/ZEo+qN3f0LcbtNoIUxWZat6BGKlHotsy3RmhL9v7PWs9ENdKWyZJjm9
   jum0C18EkdIogd7vbXAAgw/iTmIi+48RzZ1W7ox3cVJaKV+JUH+rlnqNW
   orabbEQ0LGDXleOJf+DzbccdJ6XccdOmlwmpvcGq33REh/4Da6oITLNYZ
   fFOKyeBfgOSrfMUy+nlWLUK6nqJ+l/WMvfzxS6KtvEttJMmCF3xeHm/R/
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10839"; a="365292557"
X-IronPort-AV: E=Sophos;i="6.03,162,1694761200"; 
   d="scan'208";a="365292557"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Sep 2023 07:35:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10839"; a="696318566"
X-IronPort-AV: E=Sophos;i="6.03,162,1694761200"; 
   d="scan'208";a="696318566"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.29.154]) ([10.93.29.154])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Sep 2023 07:35:31 -0700
Message-ID: <da598ffc-fa47-3c25-64ea-27ea90d712aa@intel.com>
Date:   Wed, 20 Sep 2023 22:35:28 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.15.1
Subject: Re: [RFC PATCH v2 03/21] HostMem: Add private property and associate
 it with RAM_KVM_GMEM
To:     Markus Armbruster <armbru@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        David Hildenbrand <david@redhat.com>,
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
Content-Language: en-US
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <878r91nvy4.fsf@pond.sub.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/20/2023 3:30 PM, Markus Armbruster wrote:
> Xiaoyao Li <xiaoyao.li@intel.com> writes:
> 
>> On 9/19/2023 5:46 PM, Markus Armbruster wrote:
>>> Xiaoyao Li <xiaoyao.li@intel.com> writes:
>>>
>>>> From: Isaku Yamahata <isaku.yamahata@intel.com>
>>>>
>>>> Add a new property "private" to memory backends. When it's set to true,
>>>> it indicates the RAMblock of the backend also requires kvm gmem.
>>> Can you add a brief explanation why you need the property?
>>
>> It provides a mechanism for user to specify whether the memory can serve as private memory (need request kvm gmem).
> 
> Yes, but why would a user want such memory?
> 

Because KVM demands it for confidential guest, e.g., TDX guest. KVM 
demands that the mem slot needs to have KVM_MEM_PRIVATE set and has 
valid gmem associated if the guest accesses it as private memory.
