Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 286AE78E6C2
	for <lists+kvm@lfdr.de>; Thu, 31 Aug 2023 08:50:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236420AbjHaGuC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Aug 2023 02:50:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233852AbjHaGuB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Aug 2023 02:50:01 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1694AB4
        for <kvm@vger.kernel.org>; Wed, 30 Aug 2023 23:49:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693464598; x=1725000598;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=6kcZ8h9lTsHGVhE1c9EO1Ak6pqJpZkYxV0ZLtyVD+ho=;
  b=SDB+yG+paUD39CmNQeJCtAvWp1NnnIt1lNEv1Ssy3GVRTUSQxhKMB4+l
   pfEAN0DqifBdRfn2IFoxiI4papAO6p8uHWM3IYacTN61Hl/bWU865Afm5
   ZbJ+9K//pnvz8p0uSbFpS4xeLN/lZiA565svByYsNCkpPVB6BoMDy6Zj5
   Rt/NpKz1OPrwZT/dOjixa94qiF98TJgRV0cr3ixWAC4qaIGm+GCTacKa8
   TMe6SbSV5WXe64oC07pMzo4SAi3kBeZfG8ZPtkaaXGF3757UXrJ6b1Tlc
   jE6aRv36qC7kFpLv1Lzyv5s8XZyFA8uGjFmoH4xQjZQKDKzycV/1aRTpt
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10818"; a="373235654"
X-IronPort-AV: E=Sophos;i="6.02,216,1688454000"; 
   d="scan'208";a="373235654"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2023 23:49:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10818"; a="768678181"
X-IronPort-AV: E=Sophos;i="6.02,216,1688454000"; 
   d="scan'208";a="768678181"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.16.87]) ([10.93.16.87])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2023 23:49:51 -0700
Message-ID: <a98ba28c-1d39-ea83-ade3-c0089a5e9343@intel.com>
Date:   Thu, 31 Aug 2023 14:49:49 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.14.0
Subject: Re: [PATCH v2 41/58] i386/tdx: handle TDG.VP.VMCALL<GetQuote>
Content-Language: en-US
To:     =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>
Cc:     Chenyi Qiang <chenyi.qiang@intel.com>,
        Markus Armbruster <armbru@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Ani Sinha <anisinha@redhat.com>, Peter Xu <peterx@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, Eduardo Habkost <eduardo@habkost.net>,
        Laszlo Ersek <lersek@redhat.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        erdemaktas@google.com
References: <20230818095041.1973309-1-xiaoyao.li@intel.com>
 <20230818095041.1973309-42-xiaoyao.li@intel.com>
 <87wmxn6029.fsf@pond.sub.org> <ZORws2GWRwIGAaJE@redhat.com>
 <d6fbacab-d7e4-9992-438d-a8cb58e179ae@intel.com>
 <ZO3HjRp1pk5Qd51j@redhat.com>
 <c74e7e2e-a986-240c-6300-0d3fbc22dfc4@intel.com>
 <11130e51-72fe-a07a-767b-f768611cf0d9@intel.com>
 <ZO70NwADsSRSe/WD@redhat.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <ZO70NwADsSRSe/WD@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/30/2023 3:48 PM, Daniel P. Berrangé wrote:
> On Wed, Aug 30, 2023 at 01:57:59PM +0800, Xiaoyao Li wrote:
>> On 8/30/2023 1:18 PM, Chenyi Qiang wrote:
>>>
>>>
>>> On 8/29/2023 6:25 PM, Daniel P. Berrangé wrote:
>>>> On Tue, Aug 29, 2023 at 01:31:37PM +0800, Chenyi Qiang wrote:
>>>>>
>>>>>
>>>>> On 8/22/2023 4:24 PM, Daniel P. Berrangé wrote:
>>>>>> On Tue, Aug 22, 2023 at 08:52:30AM +0200, Markus Armbruster wrote:
>>>>>>> Xiaoyao Li <xiaoyao.li@intel.com> writes:
>>>>>>>
>>>>>>>> From: Isaku Yamahata <isaku.yamahata@intel.com>
>>>>>>>>
>>>>>>>> For GetQuote, delegate a request to Quote Generation Service.  Add property
>>>>>>>> of address of quote generation server and On request, connect to the
>>>>>>>> server, read request buffer from shared guest memory, send the request
>>>>>>>> buffer to the server and store the response into shared guest memory and
>>>>>>>> notify TD guest by interrupt.
>>>>>>>>
>>>>>>>> "quote-generation-service" is a property to specify Quote Generation
>>>>>>>> Service(QGS) in qemu socket address format.  The examples of the supported
>>>>>>>> format are "vsock:2:1234", "unix:/run/qgs", "localhost:1234".
>>>>>>>>
>>>>>>>> command line example:
>>>>>>>>     qemu-system-x86_64 \
>>>>>>>>       -object 'tdx-guest,id=tdx0,quote-generation-service=localhost:1234' \
>>>>>>>>       -machine confidential-guest-support=tdx0
>>>>>>>>
>>>>>>>> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>>>>>>>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>>>>>>>> ---
>>>>>>>>    qapi/qom.json         |   5 +-
>>>>>>>>    target/i386/kvm/tdx.c | 380 ++++++++++++++++++++++++++++++++++++++++++
>>>>>>>>    target/i386/kvm/tdx.h |   7 +
>>>>>>>>    3 files changed, 391 insertions(+), 1 deletion(-)
>>>>>>>>
>>>>>>>> diff --git a/qapi/qom.json b/qapi/qom.json
>>>>>>>> index 87c1d440f331..37139949d761 100644
>>>>>>>> --- a/qapi/qom.json
>>>>>>>> +++ b/qapi/qom.json
>>>>>>>> @@ -879,13 +879,16 @@
>>>>>>>>    #
>>>>>>>>    # @mrownerconfig: MROWNERCONFIG SHA384 hex string of 48 * 2 length (default: 0)
>>>>>>>>    #
>>>>>>>> +# @quote-generation-service: socket address for Quote Generation Service(QGS)
>>>>>>>> +#
>>>>>>>>    # Since: 8.2
>>>>>>>>    ##
>>>>>>>>    { 'struct': 'TdxGuestProperties',
>>>>>>>>      'data': { '*sept-ve-disable': 'bool',
>>>>>>>>                '*mrconfigid': 'str',
>>>>>>>>                '*mrowner': 'str',
>>>>>>>> -            '*mrownerconfig': 'str' } }
>>>>>>>> +            '*mrownerconfig': 'str',
>>>>>>>> +            '*quote-generation-service': 'str' } }
>>>>>>>
>>>>>>> Why not type SocketAddress?
>>>>>>
>>>>>> Yes, the code uses SocketAddress internally when it eventually
>>>>>> calls qio_channel_socket_connect_async(), so we should directly
>>>>>> use SocketAddress in the QAPI from the start.
>>>>>
>>>>> Any benefit to directly use SocketAddress?
>>>>
>>>> We don't want whatever code consumes the configuration to
>>>> do a second level of parsing to convert the 'str' value
>>>> into the 'SocketAddress' object it actually needs.
>>>>
>>>> QEMU has a long history of having a second round of ad-hoc
>>>> parsing of configuration and we've found it to be a serious
>>>> maintenence burden. Thus we strive to have everything
>>>> represented in QAPI using the desired final type, and avoid
>>>> the second round of parsing.
>>>
>>> Thanks for your explanation.
>>>
>>>>
>>>>> "quote-generation-service" here is optional, it seems not trivial to add
>>>>> and parse the SocketAddress type in QEMU command. After I change 'str'
>>>>> to 'SocketAddress' and specify the command like "-object
>>>>> tdx-guest,type=vsock,cid=2,port=1234...", it will report "invalid
>>>>> parameter cid".
>>>>
>>>> The -object parameter supports JSON syntax for this reason
>>>>
>>>>      -object '{"qom-type":"tdx-guest","quote-generation-service":{"type": "vsock", "cid":"2","port":"1234"}}'
>>>>
>>>> libvirt will always use the JSON syntax for -object with a new enough
>>>> QEMU.
>>>
>>> The JSON syntax works for me. Then, we need to add some doc about using
>>> JSON syntax when quote-generation-service is required.
>>
>> This limitation doesn't look reasonable to me.
>>
>> @Daniel,
>>
>> Is it acceptable by QEMU community?
> 
> This is the expected approach for object types which have non-scalar
> properties.

Learned it.

thanks!

> With regards,
> Daniel

