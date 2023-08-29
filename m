Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C94178BDF4
	for <lists+kvm@lfdr.de>; Tue, 29 Aug 2023 07:35:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235823AbjH2Fc5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Aug 2023 01:32:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235909AbjH2FcW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Aug 2023 01:32:22 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5015019F
        for <kvm@vger.kernel.org>; Mon, 28 Aug 2023 22:32:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693287137; x=1724823137;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=OmmER+nETRSqH3nknSIe3IGvaSJ61K6gMWZYiAnzPkQ=;
  b=WDLtIGWDlNgsAS1VLQbYnYcWQisxY2lCg0YxiDgNZR39V/xvh+ueOUWe
   YFz6DgwPSMs2xC1oytk+iT8zjKHc9gPahn99kYQNEvCrqj5mJbIgVM9nd
   n6FRiAXSNoMTGuj1dBVo/K4+JBpj7aUtHCcDiwR+Hb5fOlr7nQdIrHxWA
   LQA4nUfvGnxYTeBZYbJMikxrvtpSxNlm/G91qmZPr1UyOPKRFvexPK94x
   DuD1XL1BgwrW5B946dX/v/rb3XRb//1etIqpXSdllK6eJUatVr33KIOsn
   sBBtsc/0+zuTEUXCguHQbs2TDpD0fZiHSgcwpfVGqzGgDWrxhKlRK/b5f
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10816"; a="461645175"
X-IronPort-AV: E=Sophos;i="6.02,208,1688454000"; 
   d="scan'208";a="461645175"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2023 22:31:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10816"; a="808547919"
X-IronPort-AV: E=Sophos;i="6.02,208,1688454000"; 
   d="scan'208";a="808547919"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga004.fm.intel.com with ESMTP; 28 Aug 2023 22:31:58 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 28 Aug 2023 22:31:58 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 28 Aug 2023 22:31:57 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Mon, 28 Aug 2023 22:31:57 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.44) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Mon, 28 Aug 2023 22:31:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CJ07wkIKyfNrlI9U1v2YMe4WgTp5oRtJNM63dqv1ZjYM9lTahKSmjzm32W15ci6MnVZf3Vol73v2LnNHVN7dxEtXwqVQfMFn+IY9G2GvDt0uHY/Ar0KNIWapTmVuJ9aqQLfNKGxkntUxwrCU5Re2mXr+AcQ6UqlpbFkhXvLIdg1rLvrXLBk39IBy9cLFYA7LJu+3uko9FZgOYSG6sTEHOdH4K1Bo0CCzFwthm+yCRNcPuig8K3fek16VhmLstfg5S4HqIvZt3LE1ardf7PXb94gEIJrlhvkCxd2cNJ6rwXsBzaufpRMMBt6E2SPNpDs5f21iib21g9UXz5nphEnHKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DW36UhFmaN0o7dc6BDGpAEF1xNW7sVveVdilNVhjdbs=;
 b=EOHP9QNkA2Ab19j7nQ/3+6hdjkPqQ/cslyCGN9POTwJ/ijQewf3a/M2ki2Uzt+d6fTinit2j7z8Ipe39x28AIoHs7FxGLCsjX/JXcX0HR0KOnFD7sDRad8Z9YAECFkN+2Iw8txU16lgEK/lXgP3Ixd6lnuKHRvKPR9BZSjcIXVTJ7n6OUP443wnn2jGRNhl0J03tBbRNpOdohNZkwqFCAsHqtfDMmy8UM2Q174Ti5mXNTc/y62vdLCEO/O096rMCi2cQyyJBNNaYldmyKZjc9GQNmStjgffSw42WJUwVN6KJinQw0yT7gSew0mSER2aWpzAKJjxsGUW7HF4G9DM8lA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA2PR11MB5052.namprd11.prod.outlook.com (2603:10b6:806:fa::15)
 by SA1PR11MB7131.namprd11.prod.outlook.com (2603:10b6:806:2b0::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.47; Tue, 29 Aug
 2023 05:31:52 +0000
Received: from SA2PR11MB5052.namprd11.prod.outlook.com
 ([fe80::e0e8:f57f:3ef9:ae6]) by SA2PR11MB5052.namprd11.prod.outlook.com
 ([fe80::e0e8:f57f:3ef9:ae6%4]) with mapi id 15.20.6699.034; Tue, 29 Aug 2023
 05:31:52 +0000
Message-ID: <d6fbacab-d7e4-9992-438d-a8cb58e179ae@intel.com>
Date:   Tue, 29 Aug 2023 13:31:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.14.0
Subject: Re: [PATCH v2 41/58] i386/tdx: handle TDG.VP.VMCALL<GetQuote>
To:     =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        "Markus Armbruster" <armbru@redhat.com>
CC:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        "Igor Mammedov" <imammedo@redhat.com>,
        Ani Sinha <anisinha@redhat.com>, Peter Xu <peterx@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>, <qemu-devel@nongnu.org>,
        <kvm@vger.kernel.org>, Eduardo Habkost <eduardo@habkost.net>,
        Laszlo Ersek <lersek@redhat.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        <erdemaktas@google.com>
References: <20230818095041.1973309-1-xiaoyao.li@intel.com>
 <20230818095041.1973309-42-xiaoyao.li@intel.com>
 <87wmxn6029.fsf@pond.sub.org> <ZORws2GWRwIGAaJE@redhat.com>
Content-Language: en-US
From:   Chenyi Qiang <chenyi.qiang@intel.com>
In-Reply-To: <ZORws2GWRwIGAaJE@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR01CA0038.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::20) To SA2PR11MB5052.namprd11.prod.outlook.com
 (2603:10b6:806:fa::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PR11MB5052:EE_|SA1PR11MB7131:EE_
X-MS-Office365-Filtering-Correlation-Id: b12c717f-0064-498f-45bb-08dba8513fbf
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3OWOyskqhVHm/2d4JzeGYlEOITwY1AW6NcdY52UDWUpnmUD4D9hggvnxLon0gqXSoo6ax8brdshNkKd3TikTFVe0QawU14v84HtgWblcuV5dg4JkqVivC5CZoACw4xMUFbIHW08ONG9CCcKpMFNvxx1IW+JCHWlUwzDrnxL178NQoirzz9YZvlXS0pxH+81dkPqB4oGmA0wD4IdKn8ja3GROwFONbz/op9cuvdqf+GlTZM3FP1jMVznh8axn7eEUxD7OEvLBuV7u10pO7pZnpQfKgbuozfyuZT/zEWO+iJJXzf85F6lOBAAJXZGxtW9Fq62O6Pqyj4fm0Q/MAf0eu3EfkkLc/JVDgXLa1SLE211oZdDhEjB2z6W4bjvaSISuZz4/kkOYLFEuDXn5YW6E0JPX8S2sHM/Xqb/gctngv1ened24NwoFppDpuafQVR+5DNBzlnrvRCoVmv0faYSWqG5cWeMO2/LUUDcuGGoXScJdE3N/SWYWv/Vo96EWq+YI0woMCezUUHiI4loKkwqVVW82MjeI8LMq0/1bngWX7WaB5S4m7l1IyULVSQRQMlU7KC7W3fmeh0Byzm6vfaqY+nVRPfb+OzpKFHaLC1MnSok950uo2yrI1bJeQccpZOQMibTa86IYDawUYNuh0fraYg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR11MB5052.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(396003)(366004)(136003)(376002)(451199024)(186009)(1800799009)(2616005)(26005)(478600001)(36756003)(53546011)(6486002)(6506007)(6666004)(6512007)(110136005)(82960400001)(66946007)(316002)(38100700002)(66556008)(66476007)(54906003)(41300700001)(83380400001)(31686004)(8936002)(44832011)(5660300002)(8676002)(4326008)(2906002)(86362001)(31696002)(7416002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QzBiMW9iMlMvZnZuMFhtRjVsbWdaNzV4RHo0SUFvYk5nQ0hnQml0SVlYRDh5?=
 =?utf-8?B?bjROdEVCOFdzTUdVSkQvRTJadXZySTFQRzdESURyQi9HQzg5clZmMkhiVTcy?=
 =?utf-8?B?VXlqQ0hQbzJ3ci9TaWU4SnBBZkNxZ3RqTnA3NWhaOE1oVStqaFhKcmIwZmlI?=
 =?utf-8?B?QWg4eklSV0NiZUcyemdRVy8yakh2VjZybC9JcXdNeUlxMGxqU3lvOWJNNEdV?=
 =?utf-8?B?YTBqSUI4SjFvNzJxQ1RiYTd5TTlhOFlRRHpybElXWFJ1TEtJTUlIN0V0bWwr?=
 =?utf-8?B?L0tyTlNtdFpGUUQybkQ1QmJBdFdIZTR5UU1uTGJkNXdRMWlpdmFYM3lPRzZo?=
 =?utf-8?B?L1B1Ym5vZUFsTWNwbGE4RWRSWnBUZUxjN1lkRFFtNm5jQmlaajI2dU9xaEN6?=
 =?utf-8?B?S1dhQVNkU0dTck83c3NHZ0VuM3VLeDB1Q0E5TVF4Yzd4eXNYQ3ZOdDNNZ3pw?=
 =?utf-8?B?M2dhQjZOUU9URDY2T294NEtON2VTd3JEWWFaMSs0MlRZdmkvMEpQM1ZLSjFl?=
 =?utf-8?B?aEN3MEFLMGVvcUVSN1pxY3h2dWlDWnpBWDVEb2N2SzhjQzFWNDg1RFFKbEh0?=
 =?utf-8?B?eEd6eGZqR2lSL1JWbEYzeXdLaHdjS0F4bVRvRDAvenZML1V2YnlGR2ZHTzUz?=
 =?utf-8?B?WkxRcTJJc2lyRTJZZ2IvSkNidmRJaHVlV2srWEZvTEVzb3UxVllqZWRTUlI3?=
 =?utf-8?B?NFJOQ0ZGQ0lkSWJIbGN4d2c4OUd4MkZoalN4bnVzODg0TkZtWHVFSzY1V3Y4?=
 =?utf-8?B?LzN4cmwvbE8rcVp2ekQxeWd4ZWZ2QWxyRE1BMEpnanhVMWd6WW1DazlXa3Bh?=
 =?utf-8?B?aHl0ZVVKYVMySEZZOHJRTzVOUnFNY0tyOGpvUnZmV0dUOXZhTzVIbEVYVUxm?=
 =?utf-8?B?ZEtHejVVTldLTVFkeWRoOEpoallJLzNleHZnU3FRT0xqYmJ2TmUxMld0WmNo?=
 =?utf-8?B?akxOZmVLTnJYRVFDNmtlV0IrNzZQakhqZkRIK05IOGFjWHpobFNjd1FmdStt?=
 =?utf-8?B?eStRaDkyWFpMM2pIdUN5NlRvRFo1cmdMNU9LWXd2RVJiUCtJb2RLK0ZwZ2t0?=
 =?utf-8?B?UUdFdXJTZnExcUY5eUp2SnFlSndnZ2IrMGNQTFFIOXBjMFlVUmRBV3VsK0pF?=
 =?utf-8?B?V05mMFBIMnc2bnoycGE4bUROMTBhT3drQzNVM0pJRTFFZGFvQjFZR2ZjWDNY?=
 =?utf-8?B?aGlzenl3bWN3ZGNPZUxlZ0pSU1dnM2VNa0RtNG1xN09BQ3lSWTE4V3RDZzha?=
 =?utf-8?B?bDg5RnovMndTTjFQdzB0OGxWSFMvUzMxVVg2c3RGOU1iWk9PdUlTWkFza2JX?=
 =?utf-8?B?RlZhOWV6YUJkbndYRkVEQS9KYW9nQ05tVUhLcytuVmVMRVkrQysycFR5dkdU?=
 =?utf-8?B?TW5wNHFQRy90VnhIaGh1TkJhZlBLeWY2WWh5RDNOUjd3NUZMaXFMcHhNOWw5?=
 =?utf-8?B?ZkRCaElkcndldjRNbU42L3VqT0dDWmxidXVXVEgwVWJiMDhUalZlZGdYbkl6?=
 =?utf-8?B?V2FNRjFHOXMrV010UnRITFRuWDUzdVRkaGQ3NjJydVB1V2tjcEM3aUVBZExr?=
 =?utf-8?B?UzNWMGN0ZG54cDBVWGlzcE4zNkNoMWtHTDBPSnpSVnNheTcrTWJ1aExIZTE4?=
 =?utf-8?B?emVLZHprWGlsVUZTSG41d0U2WU8zekhqK0V1Q2pmd2pzNUxrc0JDMmtnWWl2?=
 =?utf-8?B?MFNzcWlVQUlwOFdYK2xoTFEwM1FOVUtHUXpvenptMXJNWGVHN2V3YW1Wc0RV?=
 =?utf-8?B?Y0oxMkw5cHRJbjBWSXJSVUppQ2o4MEp5RWNraVVnUFZ2UTNIeldGYktIL3du?=
 =?utf-8?B?b3doajZuK2VHelBHVXd1RDVqQldBclgydVZIUTk2WVJkbEdLdzBkQmNoTGJq?=
 =?utf-8?B?RU9VNytnOWNZeThQQUFsVGcwcW5OakU5WkphS1lvWG8vcTdNa2pUbnBWUmNZ?=
 =?utf-8?B?ZVFVR2M5NVlxMEJtN1pYUzh4MXVweTc3dzl2cmlGZm5FeHBYQ3htNXR0RFYv?=
 =?utf-8?B?SS9aSWo4Zk1oYkc5Ri95Y0FpL05QRjNkYjRLTzNwcXZndm5SZituZGt2bnBh?=
 =?utf-8?B?MWRzNEUwZGM5bDlaQTdXWUZEVUQ5bUMxK1YrcnMwN251VlR6TkQ0L3l2UUQr?=
 =?utf-8?Q?0RgAe8aRboTkMYVyR/spNxwUf?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b12c717f-0064-498f-45bb-08dba8513fbf
X-MS-Exchange-CrossTenant-AuthSource: SA2PR11MB5052.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2023 05:31:52.1749
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eejcH8xwctDYWxiSL9hrLgA5KHazMD3T62f7nZvE558KSpKCM1eMVtkxkdNm1SBtqKwKQcBjcydWWUU4ZkB0HA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB7131
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-6.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/22/2023 4:24 PM, Daniel P. Berrangé wrote:
> On Tue, Aug 22, 2023 at 08:52:30AM +0200, Markus Armbruster wrote:
>> Xiaoyao Li <xiaoyao.li@intel.com> writes:
>>
>>> From: Isaku Yamahata <isaku.yamahata@intel.com>
>>>
>>> For GetQuote, delegate a request to Quote Generation Service.  Add property
>>> of address of quote generation server and On request, connect to the
>>> server, read request buffer from shared guest memory, send the request
>>> buffer to the server and store the response into shared guest memory and
>>> notify TD guest by interrupt.
>>>
>>> "quote-generation-service" is a property to specify Quote Generation
>>> Service(QGS) in qemu socket address format.  The examples of the supported
>>> format are "vsock:2:1234", "unix:/run/qgs", "localhost:1234".
>>>
>>> command line example:
>>>   qemu-system-x86_64 \
>>>     -object 'tdx-guest,id=tdx0,quote-generation-service=localhost:1234' \
>>>     -machine confidential-guest-support=tdx0
>>>
>>> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>>> ---
>>>  qapi/qom.json         |   5 +-
>>>  target/i386/kvm/tdx.c | 380 ++++++++++++++++++++++++++++++++++++++++++
>>>  target/i386/kvm/tdx.h |   7 +
>>>  3 files changed, 391 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/qapi/qom.json b/qapi/qom.json
>>> index 87c1d440f331..37139949d761 100644
>>> --- a/qapi/qom.json
>>> +++ b/qapi/qom.json
>>> @@ -879,13 +879,16 @@
>>>  #
>>>  # @mrownerconfig: MROWNERCONFIG SHA384 hex string of 48 * 2 length (default: 0)
>>>  #
>>> +# @quote-generation-service: socket address for Quote Generation Service(QGS)
>>> +#
>>>  # Since: 8.2
>>>  ##
>>>  { 'struct': 'TdxGuestProperties',
>>>    'data': { '*sept-ve-disable': 'bool',
>>>              '*mrconfigid': 'str',
>>>              '*mrowner': 'str',
>>> -            '*mrownerconfig': 'str' } }
>>> +            '*mrownerconfig': 'str',
>>> +            '*quote-generation-service': 'str' } }
>>
>> Why not type SocketAddress?
> 
> Yes, the code uses SocketAddress internally when it eventually
> calls qio_channel_socket_connect_async(), so we should directly
> use SocketAddress in the QAPI from the start.

Any benefit to directly use SocketAddress?

"quote-generation-service" here is optional, it seems not trivial to add
and parse the SocketAddress type in QEMU command. After I change 'str'
to 'SocketAddress' and specify the command like "-object
tdx-guest,type=vsock,cid=2,port=1234...", it will report "invalid
parameter cid".

> 
> With regards,
> Daniel
