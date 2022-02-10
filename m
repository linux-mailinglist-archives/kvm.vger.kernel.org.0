Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA1E74B028C
	for <lists+kvm@lfdr.de>; Thu, 10 Feb 2022 02:57:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233554AbiBJB5e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 20:57:34 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:33320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233672AbiBJB4N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 20:56:13 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D45E2AAB2
        for <kvm@vger.kernel.org>; Wed,  9 Feb 2022 17:41:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644457283; x=1675993283;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=zB6AoUKvVij7NWzZ9PeCjkUlZ2UWAt5KrXtxCVaMnF4=;
  b=WUC8rRSu4D9Ae0p57X9VIAOrK6n7Z8oBPvA0XuK3j3O6QI9jIBIipKNK
   KaFI2NBLV+4Ki3abk0yl848XPU7wINwOQhCHtJSZp0oT65xoA4fA1Buxu
   U7u0MlNbAy0CZ5CgXwxJF88cOn+gWNf121iz4BBx2Ooe56EPRVekxusLl
   JCKGnFUa8I0cgcI/2+wQsvWfVkOjgOvjL2ptFrDcywCyFjuNnY5UVEowu
   SNFnnP+7xyuBxI2O7rXSZfrHZHCH4yfyaFe9F6VeXq3sHTOeZbTfSyYne
   qRcFkAx6iVB0szky9MXvsUa7p3gTRLQFVpAVNdM3zf+qNhLUkiMfiUVHc
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10253"; a="273921791"
X-IronPort-AV: E=Sophos;i="5.88,357,1635231600"; 
   d="scan'208";a="273921791"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2022 16:38:06 -0800
X-IronPort-AV: E=Sophos;i="5.88,357,1635231600"; 
   d="scan'208";a="541377323"
Received: from yangweij-mobl.ccr.corp.intel.com (HELO [10.255.28.189]) ([10.255.28.189])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2022 16:38:01 -0800
Message-ID: <d5e051cd-a4ff-6816-a279-92e97b57e7c8@intel.com>
Date:   Thu, 10 Feb 2022 08:37:58 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v5 0/2] Enable legacy LBR support for guest
Content-Language: en-US
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     pbonzini@redhat.com, ehabkost@redhat.com, mtosatti@redhat.com,
        richard.henderson@linaro.org, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, likexu@tencent.com, wei.w.wang@intel.com
References: <20220122161201.73528-1-weijiang.yang@intel.com>
 <e2c18d80-7c4e-6a0a-d37e-3a585d53d3f2@gmail.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <e2c18d80-7c4e-6a0a-d37e-3a585d53d3f2@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2/9/2022 5:14 PM, Like Xu wrote:
> Hi Weijiang,
>
> On 23/1/2022 12:11 am, Yang Weijiang wrote:
>> KVM legacy LBR patches have been merged in kernel 5.12, this patchset
>> is to expose the feature to guest from the perf capability MSR. Qemu can
>> add LBR format in cpu option to achieve it, e.g., -cpu host,lbr-fmt=0x5,
>
> Some older Intel CPUs may have lbr-fmt=LBR_FORMAT_32 (which is 0), would
> you help verify that KVM is supported on these platforms ? If so, how 
> do we enable
> guest LBR form the QEMU side, w/ -cpu host,lbr-fmt=0x0 ?

Hi, Like, do you know which cpu model or platform so that I can have a 
test on?

>
>> the format should match host value in IA32_PERF_CAPABILITIES.
>>
>> Note, KVM legacy LBR solution accelerates guest perf performace by 
>> LBR MSR
>> passthrough so it requires guest cpu model matches that of host's, i.e.,
>
> Would you help add live migration support across host/guest CPU models 
> when
> hosts at both ends have the same number of LBR entries and the same 
> lbr-fmt ?
Yes, I'm working on this part for Arch LBR, then enable it for legacy 
LBR as well.
>
> Thanks,
> Like Xu
>
>> only -cpu host is supported.
>>
>> Change in v5:
>>     1. This patchset is rebased on tip : 6621441db5
>>     2. No functional change since v4.
