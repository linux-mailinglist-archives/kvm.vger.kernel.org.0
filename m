Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40D1E76C7E1
	for <lists+kvm@lfdr.de>; Wed,  2 Aug 2023 10:04:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232559AbjHBIEU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Aug 2023 04:04:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232629AbjHBIEQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Aug 2023 04:04:16 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7499910C7
        for <kvm@vger.kernel.org>; Wed,  2 Aug 2023 01:04:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690963455; x=1722499455;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=CUJG5kgK4w6vRjvQVxtBajR+8zX9BVIsj1QWPqvP7to=;
  b=Rv3sXfSGjB5scEIBT5djvIh5hsguXp+hzqrAVzA1t5ceZGOdld6HbOzu
   M8bea1wSWWi0dEnGTfXkMhkvuOCsEo//90/HMwM477U85iNTusnscTZRk
   0vcWmAuCEPhOoK3fHGHOVXr/B6Pu1kewVcbxLsvs4cWjxQkPRMddM04td
   4mX0oLT9nkXgGCQUfHhCGwyt5nVKauBFTKSEE5iwxeuZBm5h1HTV/BRsf
   89GZHnnE6XApMGQVcAltcphVV9b2PaDymqtD5bE2EoBjq1N4sobsgACC5
   8bXw+4H1JBD680BNtU3QarmCQg8gADU5qE6fP0V9cYYtJh2ATyZEYDyR0
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10789"; a="368411600"
X-IronPort-AV: E=Sophos;i="6.01,248,1684825200"; 
   d="scan'208";a="368411600"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2023 01:04:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10789"; a="732288771"
X-IronPort-AV: E=Sophos;i="6.01,248,1684825200"; 
   d="scan'208";a="732288771"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.6.77]) ([10.93.6.77])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2023 01:04:10 -0700
Message-ID: <f5ddade3-01a8-f315-e380-cd53d448123a@intel.com>
Date:   Wed, 2 Aug 2023 16:04:08 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.13.0
Subject: Re: [RFC PATCH 08/19] HostMem: Add private property to indicate to
 use kvm gmem
Content-Language: en-US
To:     =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        Markus Armbruster <armbru@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Hildenbrand <david@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        Peter Xu <peterx@redhat.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Michael Roth <michael.roth@amd.com>, isaku.yamahata@gmail.com,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20230731162201.271114-1-xiaoyao.li@intel.com>
 <20230731162201.271114-9-xiaoyao.li@intel.com> <87o7js808y.fsf@pond.sub.org>
 <ZMkdZkQipZUIUicN@redhat.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <ZMkdZkQipZUIUicN@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/1/2023 10:57 PM, Daniel P. Berrangé wrote:
> On Mon, Jul 31, 2023 at 07:22:05PM +0200, Markus Armbruster wrote:
>> Xiaoyao Li <xiaoyao.li@intel.com> writes:
>>
>>> From: Isaku Yamahata <isaku.yamahata@intel.com>
>>>
>>> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>>
>> [...]
>>
>>> diff --git a/qapi/qom.json b/qapi/qom.json
>>> index 7f92ea43e8e1..e0b2044e3d20 100644
>>> --- a/qapi/qom.json
>>> +++ b/qapi/qom.json
>>> @@ -605,6 +605,9 @@
>>>   # @reserve: if true, reserve swap space (or huge pages) if applicable
>>>   #     (default: true) (since 6.1)
>>>   #
>>> +# @private: if true, use KVM gmem private memory
>>> +#           (default: false) (since 8.1)
>>> +#
>>
>> Please format like
>>
>>     # @private: if true, use KVM gmem private memory (default: false)
>>     #     (since 8.1)
> 
> Also QEMU 8.1.0 is in freeze right now, so there's no chance
> of these patches making 8.1.0. IOW, use "since 8.2" as the
> next release you might achieve merge for.

Thanks for pointing it out. Will do it in next version.

> With regards,
> Daniel

