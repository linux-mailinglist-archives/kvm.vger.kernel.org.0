Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 965A67A1486
	for <lists+kvm@lfdr.de>; Fri, 15 Sep 2023 05:45:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231383AbjIODp2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 23:45:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjIODp0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 23:45:26 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9353196
        for <kvm@vger.kernel.org>; Thu, 14 Sep 2023 20:45:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694749522; x=1726285522;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Y5O8yBf2hm2V5a0KPQnIgJP46w9iulxKXoLXHLGRFlM=;
  b=PC4HBv/VBpGW2WXCUpTTI/nKoSZO2pLAWRMX7oUgCXij4Eh63ckVSEae
   LcW/Sfc+5locPtCkjcxjL6obvghpVSC9pOG6w8xzUyptFXkRAWcWTkNM8
   QX9kxqQosgoiCKyUSXhSkqsfBXfEP+Jzkq7gddSzGYzZi0EIcK5PNXqJl
   LNBeMcL0lx6jFwUSrc62CKpTxGbuZAib5B6DKmApTWO6T2iohjk5Hi948
   0QADtFDtJG2D0g70eZpgZ3u2xBAAC9sIGdZwhs4qRwHAXW3ZIcX7ucKYZ
   0uA34W+tksrft+lsNgNR4myH1uaqI0rkGhLcNjqHVab/GtPZEtvZlxbRD
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10833"; a="379067618"
X-IronPort-AV: E=Sophos;i="6.02,147,1688454000"; 
   d="scan'208";a="379067618"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2023 20:45:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10833"; a="815026475"
X-IronPort-AV: E=Sophos;i="6.02,147,1688454000"; 
   d="scan'208";a="815026475"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.29.154]) ([10.93.29.154])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2023 20:45:16 -0700
Message-ID: <a47ca6f9-6c2f-8212-151c-44f5ec117dbf@intel.com>
Date:   Fri, 15 Sep 2023 11:45:14 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.15.1
Subject: Re: [RFC PATCH v2 02/21] RAMBlock: Add support of KVM private gmem
Content-Language: en-US
To:     "Wang, Lei" <lei4.wang@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
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
        Markus Armbruster <armbru@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Michael Roth <michael.roth@amd.com>, isaku.yamahata@gmail.com,
        Sean Christopherson <seanjc@google.com>,
        Claudio Fontana <cfontana@suse.de>
References: <20230914035117.3285885-1-xiaoyao.li@intel.com>
 <20230914035117.3285885-3-xiaoyao.li@intel.com>
 <bd1eca88-98f4-718f-4d40-c2ea40f65d95@intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <bd1eca88-98f4-718f-4d40-c2ea40f65d95@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/15/2023 10:04 AM, Wang, Lei wrote:
> On 9/14/2023 11:50, Xiaoyao Li wrote:
>> From: Chao Peng<chao.p.peng@linux.intel.com>
>>
>> Add KVM gmem support to RAMBlock so both normal hva based memory
>> and kvm gmem fd based private memory can be associated in one RAMBlock.
>>
>> Introduce new flag RAM_KVM_GMEM. It calls KVM ioctl to create private
>> gmem for the RAMBlock when it's set.
>>
>> Signed-off-by: Xiaoyao Li<xiaoyao.li@intel.com>
> Kindly reminding the author's Signed-off-by is missing.

I will fix it.
Thanks!


