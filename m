Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9BE76497A5
	for <lists+kvm@lfdr.de>; Mon, 12 Dec 2022 02:20:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230505AbiLLBUj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 11 Dec 2022 20:20:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiLLBUh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 11 Dec 2022 20:20:37 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7947657E;
        Sun, 11 Dec 2022 17:20:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670808035; x=1702344035;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zn1VMnRkYHMoRMpOby8MvEx+yrnMvRdoagS07llnba8=;
  b=ZSYHt8YdyTSdspbGQmsg6YOzlyBf+pB12pD3aE4cylGvrPQ2s4TGxPtt
   Uamu2RoGSR0lVPoXYKyePjYZnJgneMMbuqMFQI8c/ervsJS1qKm6T6fvb
   osGMTUKUr/qBKPDBXrAiOb6Q4CHTANd8+pkGPI7lokt5Yfp7vTjIHe7Bm
   pz+tqJL/UR3NhOaPjqw+QCrVHX56E1ZaG/9A/YFpasEYrkwNxMhXw8cCM
   pHYgLv5hDvT1CMv0eEVKwgu8pd4grnH0r6WpyTsHbms5vGEqgnOSdrolg
   F7jxbdpx+gMIci9uCMzJcS2Kz9oPo2GoHTZv3bX3earuXkk1jP2fgZctD
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10558"; a="315381683"
X-IronPort-AV: E=Sophos;i="5.96,237,1665471600"; 
   d="scan'208";a="315381683"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2022 17:20:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10558"; a="647992482"
X-IronPort-AV: E=Sophos;i="5.96,237,1665471600"; 
   d="scan'208";a="647992482"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga002.jf.intel.com with ESMTP; 11 Dec 2022 17:20:28 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sun, 11 Dec 2022 17:20:27 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sun, 11 Dec 2022 17:20:27 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Sun, 11 Dec 2022 17:20:27 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.48) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Sun, 11 Dec 2022 17:20:27 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cp5vb/RxwaLZl8GUSXP927iGdfqMDG1NZZWT5lwAGoZvwQQyWlth/9o0n2FOYd/9rF89e4VA3P5MAjk+dy7Hd1YP0U1Mq0JbWGAmKed4bWVOvX8RvA1WS6tY+rwr+lIK+GWI4k45WYTQRaVJzpAvz+13HquYXAMaNMTZl1dkMDPnU3r9Q3aYYzpJTUmqaAA/zlBaCnA6W9SQHh+vOLpI9tKPjAIyV+6xq4S02vgFAE401mUL4VqGb+BTfwY+e+1uT5SBIWHUg+ptD6qg5TeEIfB88v5P95R1WvvsC3BWt0c6JYoyQz5/+DKBCeU/rJdt/AKL7qGvAhRB9R5qiSP0qA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pn7qfivWPror36tp5KIChvrtRf1NYN3Ev/nqO8bSzi8=;
 b=n9kg2BJhRJcrabUth5LdP2+g7fG67CTPdIF3adSlggwKAoH99yVKE8JvJGs7M5QQm7d86TghTDuX8CYCgS1EClIYI75P9YwpBQM2/4dWNQaSGrt0rFoO4Zmxc4LLSc30gLBQTpCRs48YDuBizO57zOgTnX5aB5toZOFUgMw48FbbBLHhZU4d0vfR6a/SXMgTf0kbN1PZBinIWryaIS3YPlzw1Zmnk+ewjnqReJvP5PghvP+a7XOLnIMqm4Fv3Y7bnd51OtlyJCuJqiytwczx+VaRk9q1ZSWsRqqZ2yz1goYWRrcgLEH3wYk53xtyCZ43u3k97jAE1i748f0+50E27w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM8PR11MB5640.namprd11.prod.outlook.com (2603:10b6:8:3f::14) by
 SA1PR11MB6968.namprd11.prod.outlook.com (2603:10b6:806:2be::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Mon, 12 Dec
 2022 01:20:25 +0000
Received: from DM8PR11MB5640.namprd11.prod.outlook.com
 ([fe80::ba45:6089:4ce:18a0]) by DM8PR11MB5640.namprd11.prod.outlook.com
 ([fe80::ba45:6089:4ce:18a0%6]) with mapi id 15.20.5880.019; Mon, 12 Dec 2022
 01:20:25 +0000
Message-ID: <0bda7899-6790-4b24-f622-5f9c8951c239@intel.com>
Date:   Mon, 12 Dec 2022 09:20:09 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.5.1
Subject: Re: [RFC PATCH 5/5] nvme-vfio: Add a document for the NVMe device
To:     Max Gurtovoy <mgurtovoy@nvidia.com>,
        Christoph Hellwig <hch@lst.de>, Jason Gunthorpe <jgg@ziepe.ca>
CC:     <kbusch@kernel.org>, <axboe@fb.com>, <kch@nvidia.com>,
        <sagi@grimberg.me>, <alex.williamson@redhat.com>,
        <cohuck@redhat.com>, <yishaih@nvidia.com>,
        <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
        <mjrosato@linux.ibm.com>, <linux-kernel@vger.kernel.org>,
        <linux-nvme@lists.infradead.org>, <kvm@vger.kernel.org>,
        <eddie.dong@intel.com>, <yadong.li@intel.com>,
        <yi.l.liu@intel.com>, <Konrad.wilk@oracle.com>,
        <stephen@eideticom.com>, <hang.yuan@intel.com>,
        Oren Duer <oren@nvidia.com>
References: <20221206055816.292304-1-lei.rao@intel.com>
 <20221206055816.292304-6-lei.rao@intel.com> <20221206062604.GB6595@lst.de>
 <Y48+AaG5rSCviIhl@ziepe.ca> <20221206130901.GB24358@lst.de>
 <Y49JNvdmRPNWw26q@ziepe.ca> <20221206140002.GB27689@lst.de>
 <Y49PqoAhZOeraLVa@ziepe.ca> <20221206143126.GB30297@lst.de>
 <Y49WNo7XWZ2aFfds@ziepe.ca> <20221206150131.GA32365@lst.de>
 <9bc8e614-a687-e419-f9fd-e3177cfb41dd@nvidia.com>
 <cf88c2ec-bdd6-1df3-6c77-64a17dc3eb86@intel.com>
 <d4aeda5c-d7bb-4427-5157-fb7530dfd1fb@nvidia.com>
Content-Language: en-US
From:   "Rao, Lei" <lei.rao@intel.com>
In-Reply-To: <d4aeda5c-d7bb-4427-5157-fb7530dfd1fb@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2P153CA0015.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:140::21) To DM8PR11MB5640.namprd11.prod.outlook.com
 (2603:10b6:8:3f::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR11MB5640:EE_|SA1PR11MB6968:EE_
X-MS-Office365-Filtering-Correlation-Id: 5df634dc-96ef-45bb-98a5-08dadbdf0afa
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: acB7KdJ4+s58DyOlev3GA9QjRvCfThEDUyzfPsEmML6uUtFUgMCEFL/jqaJLoOP9yZDnTORNhVYmB8W08HSnti5H/J7MiLmF5H8tN4RBE78Ju9FFyXtSXGv+AstjNLphpfsgb/IfiOgKAcY5gKYm7s6v14300LahmA19vjPRjJCKm2iCZ+MtsiNDTtgQVrbQ4JLMunWjA3lDR8lcASA+U/1owxYfcEpjYV10HTr6AXaF8lcDRr9jhL+buQQkDvs+tbpwJnHRxNgyyfOvMvnAMqjIqT5TqX51y2SpnMjv6JfmwL7FPPYJRuyu6vFGoltdYam3PEm9cYLBfz3Rgkm+xJDiJX3jqG18yLYNgUc00ZvQ1Z6LwSZgAiMju6Sky+2hRsTSmwEyOlsa4alA+RwKwOYfhwkxrB8xzmhxb/xDZycedSzoQeJpW6GVhj2nlxAxWrvp5Wute0KJ7JNyf3HhS3mKH/uFC8ZbNO5MfU+jnyTSVrPxK1n5HjjI6i7vL/Te3nRz955HAlqc7mlZdSweNG4DeU/sOeNVKs9yVnZ969F1KYGr0DsqC5qmVnKN5xmVHCzJML88EhvPoOKp95oRHxfIyhohCTN3cmLyuU0uclRN6OWcuUf4uCxGsLGxgpx9udVcliUDx81Fy3qupLDp8Mdlw80rRr4iUukp/PsZoOdLDiMyDQVALcU2nMCkmbw6JvGktdtUgcseO4cislwOo3wJ5AyXqy8ak+Q+HHBPL8Y=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5640.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(346002)(136003)(376002)(39860400002)(366004)(451199015)(41300700001)(5660300002)(26005)(31696002)(7416002)(86362001)(36756003)(8936002)(6512007)(478600001)(6486002)(6506007)(66946007)(66476007)(8676002)(66556008)(4326008)(53546011)(316002)(6666004)(110136005)(31686004)(66899015)(83380400001)(38100700002)(186003)(2616005)(82960400001)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bjY0aHY1RkhqMHdaZmpHS0xFQlJVOGZWTVFIMVZvSFpzQlVUZUtjWnRLczY3?=
 =?utf-8?B?WjF5N1dVQjJHL2RhSkE1M3hNTlhDMG5CUmFaemgyUnNwQXdlQlozclFzOE04?=
 =?utf-8?B?cE9TWGZOTzU4cGhJKzN2TGQ4cEdBay9hQ3FnM0RvaW5sOGFYcXNJOVdLZ2dI?=
 =?utf-8?B?bnJ4K1BHaTFCUmpRd1l0dWZjZEx5Y3FTYUdlekM1QjRRd2F4WXNaNjlwQkxP?=
 =?utf-8?B?S082Y1pVUUdzYWVZcDJsaFhxckp6dk1Fc1l4RWRydmN1Sm4vL1RKNEFlR1Jt?=
 =?utf-8?B?aHc3NVYvV3J5c1hrMzRydHZBS0Q1MDBCSXlOL0lHL3A0RU5lTVVma3RWV3hX?=
 =?utf-8?B?dUpQcFRYZmNUTlBZTVBCUW9DeExrMyt6QldxZ0ZFUXVCLzAvWXFqOGFZTHFo?=
 =?utf-8?B?Q2hVT2ZwT1lhSXMzNExkQmc3aTFaYXEwNUJrR0VrSlc3UjhOSElCb2lZR2Ny?=
 =?utf-8?B?RUxoOXhNWE13SDZ3WjNMLzF2SDFYZ3V1dXhqRFJMcUY0cDVYcWd6MDU5Ymth?=
 =?utf-8?B?VTBIMHVnWnVhZG56T0ZvUTFvYk1WaGVXbGdtbTQxbGFDRUtIYUJXQ1BHWnhP?=
 =?utf-8?B?b1lGRms5cHVZcFg5VG1ocjVMekFmRXNLZEhrOXY1Z28za3B3bnJvdkpnY28x?=
 =?utf-8?B?RlRMMUpjUGxuSno0LzR2bVVVVTEwOEtvNEVqbnMvUXdKZEw5bk1qVURzTCtR?=
 =?utf-8?B?Y2U4c0Q3SXBGNG9sSGZpMnpMUElyZXAwSFRoWHFZdUJqYmFiZzhOVndRUm1o?=
 =?utf-8?B?Y29OTXBiMXVPdVc4Y1ZxUWVMamZVNlVyL0NveVorVWxGRHB2a2h6c3o2SUs1?=
 =?utf-8?B?bWtKL2xWZlh3TFVuWDErK1FmbmI2UTljRzBkOGlvOUxZWVg4OEJ1RHladVdN?=
 =?utf-8?B?UllKTXlLellVTTdqL3E4bVFKa1EweFljays0N1JNVks0MU9tV2dlek15ZG9u?=
 =?utf-8?B?YTNrRGJHU05CNlprVHFBL1dIaFVzdXljOEpkbEV0VmhiU085RVJnQlEyK01O?=
 =?utf-8?B?eGVGNmY5YURubTdJMlJWU2RTaUdCL1FkVXo5UFVKWC9LYUNwTDRFVmwyamtz?=
 =?utf-8?B?TkhLbTVlWHRydFBWRGdEODBaYUtXQUdGV0RCV1RmSnlndVBDbk43WTNsQ0Ra?=
 =?utf-8?B?Unp2QmZ3clNJYU0zL3dkVVE1YjhpbVMwZWhsaDBkNGxBa2NwM0xRUFpPbElk?=
 =?utf-8?B?K0VNOVF3bDVWZDhyaTRUVHBXZVBhQjRjeXJlckZYVFhIVXlEeW02aFdGeTMw?=
 =?utf-8?B?UUh4dWNpMXg0K2ZDU0kzMHRLTjc1YVJQVVpNMWFTSk05V2kwNzYwQk8rc28x?=
 =?utf-8?B?SlhIZ1Iya0hyMk9rWXZsMEpmc0dmemxzOFh0Q0RRUFZxMFVuNm1hbEN6b1Z3?=
 =?utf-8?B?a20zNnZoelZCaXNaOEsrSmIxVFg1ZXo2NlBlaUc4WU5kZm1lMVRMZnN5L0xJ?=
 =?utf-8?B?MksyREg1UmxPVjBUblZLZ2ptU0JkMnNSSlhCWUNtMkJKUURvZTRGVmFrZ1h3?=
 =?utf-8?B?TVVTd2x0dW1ZeVpORFY2Qng5YUZydFZ4WHU0TmNFeDlyYVhiakxvUUtVbXA2?=
 =?utf-8?B?TnlINXFyYW90VytsQzMwSFBOY2RJRDdyM2ZnVCtHYjZPaUFHekQ5OHlvNytX?=
 =?utf-8?B?OEh1cXlzQkhuNTE5cFc5WHcxUlJZTE9IdkJNU25xTm9wdjY0RERnTDNrUDYy?=
 =?utf-8?B?OGcyU3piMzFhUmNtQlY1QkEzTW5GbDNmcjdOYjBlbjZyNzJhR1daNVRLMmdq?=
 =?utf-8?B?dFhuWklFdWMveU1SQXhBQmNWMXJEd3J0S0VsekR2Tk55US93U3owTjR4cXVq?=
 =?utf-8?B?cnFIWjVURVBKemMvLytDZnFqQ3pURDlTS1FjelFrR24yN3hDaDE4eC9FTWdI?=
 =?utf-8?B?NEdqU1RtbFNzZTRNYWRaOHhaYjhVbjZLTnBRazNlS1hMNGh0TldCS3hJb2JI?=
 =?utf-8?B?Q3labmpPNGNlREVHNUw5WU5DVXhnZC82UW1JKzBYZGZSdVNhTlM0OFB3Qm9m?=
 =?utf-8?B?ZDZhNmlHeUo4Z3dTR052WHRkenhCVGNlTG5zK2lOdFpBRys0MWFBOC9yZmtQ?=
 =?utf-8?B?bTdxekFIUjFvZ3V6SVNPVXoySWtvZ3lZK21mQ0grZ2dYenAvaDlWQkdNR2pz?=
 =?utf-8?Q?0eFWgWU2/OxaLul+1Fp25HpeW?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5df634dc-96ef-45bb-98a5-08dadbdf0afa
X-MS-Exchange-CrossTenant-AuthSource: DM8PR11MB5640.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2022 01:20:25.0032
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +eBWHhHXU3d2ekzy6If5CsDmBZmWKo7aS/uz/H1mVRTDvGzjzFjnGXdoUrX1hjNSdXcj9Z9+4yZpGmK1cg9p4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6968
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/11/2022 10:51 PM, Max Gurtovoy wrote:
> 
> On 12/11/2022 3:21 PM, Rao, Lei wrote:
>>
>>
>> On 12/11/2022 8:05 PM, Max Gurtovoy wrote:
>>>
>>> On 12/6/2022 5:01 PM, Christoph Hellwig wrote:
>>>> On Tue, Dec 06, 2022 at 10:48:22AM -0400, Jason Gunthorpe wrote:
>>>>> Sadly in Linux we don't have a SRIOV VF lifecycle model that is any
>>>>> use.
>>>> Beward:  The secondary function might as well be a physical function
>>>> as well.  In fact one of the major customers for "smart" multifunction
>>>> nvme devices prefers multi-PF devices over SR-IOV VFs. (and all the
>>>> symmetric dual ported devices are multi-PF as well).
>>>>
>>>> So this isn't really about a VF live cycle, but how to manage life
>>>> migration, especially on the receive / restore side.  And restoring
>>>> the entire controller state is extremely invasive and can't be done
>>>> on a controller that is in any classic form live.  In fact a lot
>>>> of the state is subsystem-wide, so without some kind of virtualization
>>>> of the subsystem it is impossible to actually restore the state.
>>>
>>> ohh, great !
>>>
>>> I read this subsystem virtualization proposal of yours after I sent my proposal for subsystem virtualization in patch 1/5 thread.
>>> I guess this means that this is the right way to go.
>>> Lets continue brainstorming this idea. I think this can be the way to migrate NVMe controllers in a standard way.
>>>
>>>>
>>>> To cycle back to the hardware that is posted here, I'm really confused
>>>> how it actually has any chance to work and no one has even tried
>>>> to explain how it is supposed to work.
>>>
>>> I guess in vendor specific implementation you can assume some things that we are discussing now for making it as a standard.
>>
>> Yes, as I wrote in the cover letter, this is a reference implementation to
>> start a discussion and help drive standardization efforts, but this series
>> works well for Intel IPU NVMe. As Jason said, there are two use cases:
>> shared medium and local medium. I think the live migration of the local medium
>> is complicated due to the large amount of user data that needs to be migrated.
>> I don't have a good idea to deal with this situation. But for Intel IPU NVMe,
>> each VF can connect to remote storage via the NVMF protocol to achieve storage
>> offloading. This is the shared medium. In this case, we don't need to migrate
>> the user data, which will significantly simplify the work of live migration.
> 
> I don't think that medium migration should be part of the SPEC. We can specify it's out of scope.
> 
> All the idea of live migration is to have a short downtime and I don't think we can guarantee short downtime if we need to copy few terabytes throw the networking.
> If the media copy is taking few seconds, there is no need to do live migration of few milisecs downtime. Just do regular migration of a
> 
>>
>> The series tries to solve the problem of live migration of shared medium.
>> But it still lacks dirty page tracking and P2P support, we are also developing
>> these features.
>>
>> About the nvme device state, As described in my document, the VF states include
>> VF CSR registers, Every IO Queue Pair state, and the AdminQ state. During the
>> implementation, I found that the device state data is small per VF. So, I decided
>> to use the admin queue of the Primary controller to send the live migration
>> commands to save and restore the VF states like MLX5.
> 
> I think and hope we all agree that the AdminQ of the controlling NVMe function will be used to migrate the controlled NVMe function.

Fully agree.

> 
> which document are you refereeing to ?

The fifth patch includes the definition of these commands and how the firmware handles
these live migration commands. It's the documentation that I referenced.

>>
>>>
>>>
