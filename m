Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E739B78D2F2
	for <lists+kvm@lfdr.de>; Wed, 30 Aug 2023 07:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236134AbjH3FTs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Aug 2023 01:19:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232200AbjH3FTQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Aug 2023 01:19:16 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BADC6CC5
        for <kvm@vger.kernel.org>; Tue, 29 Aug 2023 22:19:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693372753; x=1724908753;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=LXJuPDXh3gwQJJRH7U0bQkQoX6Ky44NOYuYOW0HmDug=;
  b=QFbcUKN+vtFvykwxz2aXsvg7csnDq6NCEuTZjlBJc2U4/z73pavwWyAZ
   RPGlst46S4jk/W41R5bcVMEunMylIeMWgYqflojFdO0qogBK3Wu5/k722
   nUVU2PUPw2VuwgiopEuxWmXQENE5hxHXHE/c1gL1c14sscK96v+tfJkQ6
   sTW1MoggRD6DOlhvI2lbitCJKGJNJihG1EeUA4F4kI3hXjwXKqycWCuFd
   H8pzDpp33QZp1fDO1kpAz8sG5nxhby7f/S2Zq6vyZvDoqdJkI42gHnyLq
   yvPeRMaU/cBdIdBXIgKa1COAQqAy7ov74/Qg8zleCovw/GI6A8rHgMz2u
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10817"; a="365754182"
X-IronPort-AV: E=Sophos;i="6.02,212,1688454000"; 
   d="scan'208";a="365754182"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2023 22:19:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.01,202,1684825200"; 
   d="scan'208";a="882584143"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga001.fm.intel.com with ESMTP; 29 Aug 2023 22:19:17 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 29 Aug 2023 22:19:11 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 29 Aug 2023 22:19:10 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Tue, 29 Aug 2023 22:19:10 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.176)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Tue, 29 Aug 2023 22:19:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mlYjk/5ZQPsgswJbiQlk7l4IBH9+X62y0Rv1qXwliHFyGKoGtJ0wVCQCA9QXFYyNRwtg4FYyzvvXcbBw/iCEf0funtA8ooFaB3ZNNIBZNz6qOqnWYKCvWsetT8867Apzx0h2fMcWz4F5pnuJU4xLxZ2SIY8ugdLRnSk78dO103iv8y2vJkgMBkWML5JeRtJXi0FtOVtnowxG+M9JM8oQgBekWxN8Fn30giOrMizDzQ1QyDJkRhP4WrsMlPhOHXutSqrzAHgMKrK541FarzUWvuWD6n6J4lyFR7O8e+wF55NAoyYPREe0MjiCUYrYhIhHgfVlArPE3XYkD0yiZz67ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6xow0aFO1NKcdGvsnbp5fmqJlo7GvPcYytbiEL2eUzA=;
 b=ampb/s0P1fYjbFRnFEbjea4L+OpDv1lRYdTpx45gYJd01C1Xi82nlB1CXxR7VQkMC2NQVo6UPHTcEKf5jHuWyfH5Ih4w/U+EWdr2rkNAd8fhSJ1CAc03wJeriGVxhXDYKB8lDL9O5HcWTZCRf61D3+ZUxdN+V0IFa5PoUsqYbldV43w1u4BJUSJo8vV/UYupRDlmhJJJxue8a3/jee4XdqWNqSUjqIT4cqwNOxQgUHwuoyWuhTfqyqUfzyfYKsTNR1OojIJmt+u9TgN9gqvRG7coRSHoB4SVtTmzOV7IWfxHA5pZLaQSmEiWhx6dWAND2ClqtH8hSHa0PVJuOg4wZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA2PR11MB5052.namprd11.prod.outlook.com (2603:10b6:806:fa::15)
 by IA0PR11MB7355.namprd11.prod.outlook.com (2603:10b6:208:433::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.34; Wed, 30 Aug
 2023 05:19:07 +0000
Received: from SA2PR11MB5052.namprd11.prod.outlook.com
 ([fe80::e0e8:f57f:3ef9:ae6]) by SA2PR11MB5052.namprd11.prod.outlook.com
 ([fe80::e0e8:f57f:3ef9:ae6%4]) with mapi id 15.20.6745.020; Wed, 30 Aug 2023
 05:19:07 +0000
Message-ID: <c74e7e2e-a986-240c-6300-0d3fbc22dfc4@intel.com>
Date:   Wed, 30 Aug 2023 13:18:49 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.14.0
Subject: Re: [PATCH v2 41/58] i386/tdx: handle TDG.VP.VMCALL<GetQuote>
To:     =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>
CC:     Markus Armbruster <armbru@redhat.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
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
        Gerd Hoffmann <kraxel@redhat.com>, <qemu-devel@nongnu.org>,
        <kvm@vger.kernel.org>, Eduardo Habkost <eduardo@habkost.net>,
        Laszlo Ersek <lersek@redhat.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        <erdemaktas@google.com>
References: <20230818095041.1973309-1-xiaoyao.li@intel.com>
 <20230818095041.1973309-42-xiaoyao.li@intel.com>
 <87wmxn6029.fsf@pond.sub.org> <ZORws2GWRwIGAaJE@redhat.com>
 <d6fbacab-d7e4-9992-438d-a8cb58e179ae@intel.com>
 <ZO3HjRp1pk5Qd51j@redhat.com>
Content-Language: en-US
From:   Chenyi Qiang <chenyi.qiang@intel.com>
In-Reply-To: <ZO3HjRp1pk5Qd51j@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: KU1PR03CA0032.apcprd03.prod.outlook.com
 (2603:1096:802:19::20) To SA2PR11MB5052.namprd11.prod.outlook.com
 (2603:10b6:806:fa::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PR11MB5052:EE_|IA0PR11MB7355:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ca2330f-8d64-4b6f-7d5c-08dba918a1b5
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: THErIgTa1gv42LahEzfm7JL6deku1oW308T8mi519FBvR0JuemjSefg1pxaNryCreWlWhEjcYxqzmEj8RhVwGItStKPloq3+LtTplUYz2StaGZGOWejYG806yup3CiCO+nLTz70eXr/YUwYVQtA8N5Jnoq+h026QJXK+6yDQfYLkft/zS/e1EpL2TAi7bsXquCppvaKhnRpGO0K6OxPL04lE9C+9EkHqq1RG6qHSijkz3Py98Yg1WvGJNSyIiJDI44qLVk7ZV8otXIl9g8PtABA2VEtqhzAjGIlf196rkl2FOruMwOHtc1LzJm2tymyLHKmoop4mNQw9d/vxM8N5fn6tJDIFMKV93JvT9RYCH2RX4m6tSiJTeedBJtM80RU4XdCrL6sB5WNmoNTx7p5W4AfdmHt5dfUMcZ10SlR+5/z05Xh+ImLQSgrNroZwvTVZNGkJ9KmqmzDWfw9IGp7uHeIWSBP670MAswmF2GIuCzh0c0mG4MZV+8mk9gNhaP8IH4Y4DtcdAVjm2AuvgWJEs5qynMI+WoWlHCcZxmBX0nTSqtFV0JAn4sUTaHjtVHLhGrYxJftnQrDgRNyaSTS14rDYB3pN/DWN3MInwNDm846QNKrH1bIwlESGTy6eBf9n6bmmuau0h8hMWRmXBlZd2w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR11MB5052.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(346002)(396003)(376002)(366004)(451199024)(1800799009)(186009)(6512007)(26005)(316002)(38100700002)(6916009)(82960400001)(41300700001)(4326008)(7416002)(2906002)(31696002)(2616005)(86362001)(36756003)(5660300002)(44832011)(8676002)(83380400001)(8936002)(6666004)(6506007)(66476007)(6486002)(54906003)(66556008)(53546011)(66946007)(478600001)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TW9WS3RVL0ZuYVpDSjVpaTlGMGpXZVBvdndRNjNoMGRBQmRGLys0UWMwbFZ2?=
 =?utf-8?B?cWpodEVpSGhrVVBiL05jdmZzZ3dFNUhtaDBwVTB3YzZjZklCQkNWWk12Ky9V?=
 =?utf-8?B?bGR1dG1BQzZEd1VqNnFreHlLeUdITzFiTmxieTZQZGlIK3pHUC9HNmsxOFRE?=
 =?utf-8?B?R2FnSFA0blpkcnVJYWN3RFQ0WDZXaTduSUZvdkFpbm5YT0RtRXpiNTVmU2la?=
 =?utf-8?B?UytwdjU5M2trZjFjUE4yM3QvMkFRMXFFZWd6Q0NVWlZBanJFLzZJdzJiSHly?=
 =?utf-8?B?T1hycU1JcTkyZ0VQd29MNVZhTEFUSDdpcS9qdmFiWWpjSzlFbEEwWkdqUUZM?=
 =?utf-8?B?MHVyQmR3ZVJ0MU14V3k1NHI3b2x0RDFQeEpGQ0ZkTmxNVWJlZnZ5VVF5Vloy?=
 =?utf-8?B?bkQyMVA4RTBkN2phUVFQMml4T2ZRMWgrMlVuNWh2UVZaUTgxcEtOc2d2aEJH?=
 =?utf-8?B?RFNkNkVxVk8wZ1ZDR1NURldpQUpMTU80ejM5czVpWjIrcVgrNkpWWndvKzVC?=
 =?utf-8?B?Zld1QXNhNnZOSkZDd3hIa2FxMG1IUkJhSm9nYkE2alBxN1JwUHNLVFBnNDJ0?=
 =?utf-8?B?TlNtK0pVak03RVhNWGFMR05nRVlXemg1YncwQUhuVTZSekxuVDJEZFNoRFhR?=
 =?utf-8?B?MG52Z05pUVo0c0pvcWlYOWs3c0tMb0dheCtoSERiVG4wTTNLb3NWdEdvV3ZS?=
 =?utf-8?B?OTUwQlVtVzlnWGZLOXZPWFJtaUh1aTg0ck9IOVpMNWFQM0RCK1ZNV2o4cUFM?=
 =?utf-8?B?WXUwazB2K2lRZTMwUys4c2Q0dWtLL1ZjQjVkOVJzSnBFWnhqZmt5OWJOODBN?=
 =?utf-8?B?Y3pKdUg4bjB6TjlUVHNjQ2JNdFNvOEF3UVJUb1RlYUVJSXJaR0JPNFhKeVRP?=
 =?utf-8?B?RER1Y2lVV29XQmV1YmVJYlV2MWtJWEI2TXNGQTBQY2xXd2wwbkd2dkQrQTZG?=
 =?utf-8?B?ZEpYN0JzZ2c3MFl5YWxHQ2VrNXluZlVCMGV1dndYY1VPVVhvL016VWRic2xN?=
 =?utf-8?B?cWlUUER0UCtiVDRrVjR1dkNyM3NRRHJPR3RQcFArN0xwNkZQNFo2bzNjMmdF?=
 =?utf-8?B?V1ZrNXc0d0MvYTBqTkY3R0dvMDk1SFFtQ3RPbThrVGlVazdUUmh0YnVUTWZM?=
 =?utf-8?B?MHo2bnQ4ZStFZFFFdFFDMitmV0pBZGx0Mkp0WDc4VDZUbjFaWU9CT2RUN3J3?=
 =?utf-8?B?dVZ0NTBQeEpKeFM0NHlCeC9sRFd1TmtGS3R1TlI3dUQyNlBIV2Frb3AweE5s?=
 =?utf-8?B?dUpMdFo1RkY1L3A5bTdlYUZPTTFjSVlEMnRoT2NXZkZURGQ3T3JVeTkvSUxr?=
 =?utf-8?B?K0xoTU4xUnpweUlHNFZDSFBtYUlFS3hERzNHV3p2bTZ4SDJ5SG9JVkpUbHJl?=
 =?utf-8?B?Z2V1dmxRb1prdmlOU01wTzVzOHN2SzdRZFZENkdmVEtIMWNhaDVoYlNKL2NZ?=
 =?utf-8?B?MkY1UWdqUEgwSHJmRUlpM3pXQ0tDRDdkbDJLUFZzQ0x6T2tvN2wwL1RybTZG?=
 =?utf-8?B?RkwyV1NwUzkrc2sxM3N4Rm5ISHV4VVZOM0JmRzE3UHpSTEdBYXg4Y0FqSysy?=
 =?utf-8?B?N29qV0g4MXZjS3JmbTVkeHdmMkcxMmd5MHN0cHFqT1pjRlI1UC9OTHRMbVVs?=
 =?utf-8?B?K0hRcnVWNUdBVVQ4ZEpldzc1SnNGYWhZcDRET0theTByNW4wN3RKMW1tZFVO?=
 =?utf-8?B?K0FwL0VNVENjL2xoWFBDdUlEdkwzQjEyNDArSXZvMjhteHJkTmxqcFMydVdv?=
 =?utf-8?B?SlNtOEZ6azBvaW1Xdlk3emVVcXh1ZllxUnVSdVVlTmxoaHlsSVVzd2VKeGsy?=
 =?utf-8?B?eGtUQW13emtMZ3A1VnF5Nk1hUmVLRlNvUEFVdGN1bW9yeHgxVno3aGFIWHo2?=
 =?utf-8?B?OHVDMTdMYkFEaEtMN1BhSmpwT0dyMEZQUkR5dStMWElPQW5YS3FaVXVGVktu?=
 =?utf-8?B?ZU9FK05KMEVPNVB2NGl4NVpENHFUUE9tQUFja2Y1WnhLUGFuMzExc1dpbytP?=
 =?utf-8?B?cDJqeDdlWHREL0g1QnlmTVhTdWZ1RGM5Y3A0SXZNSlpsMllQRWpEeWZZNy9S?=
 =?utf-8?B?NUNPQlFOMjExVmRvUDBtYnk2NmpuelE0RmpWeFhCd24rSDF3WnhseFY2bnB0?=
 =?utf-8?Q?v5WUDNcE64eeR3OBOgJyJVSlW?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ca2330f-8d64-4b6f-7d5c-08dba918a1b5
X-MS-Exchange-CrossTenant-AuthSource: SA2PR11MB5052.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2023 05:19:06.8119
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lOjqRLDfrluGL2Kp8OC42wlS9zsnOj0nEFXtlL20rahuirFb45HbeNidmjWhmTYnEH+PFWkkcf7XZRsIJwxoCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7355
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/29/2023 6:25 PM, Daniel P. Berrangé wrote:
> On Tue, Aug 29, 2023 at 01:31:37PM +0800, Chenyi Qiang wrote:
>>
>>
>> On 8/22/2023 4:24 PM, Daniel P. Berrangé wrote:
>>> On Tue, Aug 22, 2023 at 08:52:30AM +0200, Markus Armbruster wrote:
>>>> Xiaoyao Li <xiaoyao.li@intel.com> writes:
>>>>
>>>>> From: Isaku Yamahata <isaku.yamahata@intel.com>
>>>>>
>>>>> For GetQuote, delegate a request to Quote Generation Service.  Add property
>>>>> of address of quote generation server and On request, connect to the
>>>>> server, read request buffer from shared guest memory, send the request
>>>>> buffer to the server and store the response into shared guest memory and
>>>>> notify TD guest by interrupt.
>>>>>
>>>>> "quote-generation-service" is a property to specify Quote Generation
>>>>> Service(QGS) in qemu socket address format.  The examples of the supported
>>>>> format are "vsock:2:1234", "unix:/run/qgs", "localhost:1234".
>>>>>
>>>>> command line example:
>>>>>   qemu-system-x86_64 \
>>>>>     -object 'tdx-guest,id=tdx0,quote-generation-service=localhost:1234' \
>>>>>     -machine confidential-guest-support=tdx0
>>>>>
>>>>> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>>>>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>>>>> ---
>>>>>  qapi/qom.json         |   5 +-
>>>>>  target/i386/kvm/tdx.c | 380 ++++++++++++++++++++++++++++++++++++++++++
>>>>>  target/i386/kvm/tdx.h |   7 +
>>>>>  3 files changed, 391 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/qapi/qom.json b/qapi/qom.json
>>>>> index 87c1d440f331..37139949d761 100644
>>>>> --- a/qapi/qom.json
>>>>> +++ b/qapi/qom.json
>>>>> @@ -879,13 +879,16 @@
>>>>>  #
>>>>>  # @mrownerconfig: MROWNERCONFIG SHA384 hex string of 48 * 2 length (default: 0)
>>>>>  #
>>>>> +# @quote-generation-service: socket address for Quote Generation Service(QGS)
>>>>> +#
>>>>>  # Since: 8.2
>>>>>  ##
>>>>>  { 'struct': 'TdxGuestProperties',
>>>>>    'data': { '*sept-ve-disable': 'bool',
>>>>>              '*mrconfigid': 'str',
>>>>>              '*mrowner': 'str',
>>>>> -            '*mrownerconfig': 'str' } }
>>>>> +            '*mrownerconfig': 'str',
>>>>> +            '*quote-generation-service': 'str' } }
>>>>
>>>> Why not type SocketAddress?
>>>
>>> Yes, the code uses SocketAddress internally when it eventually
>>> calls qio_channel_socket_connect_async(), so we should directly
>>> use SocketAddress in the QAPI from the start.
>>
>> Any benefit to directly use SocketAddress?
> 
> We don't want whatever code consumes the configuration to
> do a second level of parsing to convert the 'str' value
> into the 'SocketAddress' object it actually needs.
> 
> QEMU has a long history of having a second round of ad-hoc
> parsing of configuration and we've found it to be a serious
> maintenence burden. Thus we strive to have everything
> represented in QAPI using the desired final type, and avoid
> the second round of parsing.

Thanks for your explanation.

> 
>> "quote-generation-service" here is optional, it seems not trivial to add
>> and parse the SocketAddress type in QEMU command. After I change 'str'
>> to 'SocketAddress' and specify the command like "-object
>> tdx-guest,type=vsock,cid=2,port=1234...", it will report "invalid
>> parameter cid".
> 
> The -object parameter supports JSON syntax for this reason
> 
>    -object '{"qom-type":"tdx-guest","quote-generation-service":{"type": "vsock", "cid":"2","port":"1234"}}'
> 
> libvirt will always use the JSON syntax for -object with a new enough
> QEMU.

The JSON syntax works for me. Then, we need to add some doc about using
JSON syntax when quote-generation-service is required.

> 
> With regards,
> Daniel
