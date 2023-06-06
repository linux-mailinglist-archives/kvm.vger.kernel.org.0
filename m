Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1F07725056
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 00:58:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240119AbjFFW6M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 18:58:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239599AbjFFW6K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 18:58:10 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 802FA10F2;
        Tue,  6 Jun 2023 15:58:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686092289; x=1717628289;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=lMj+btD7TqyNhq3LR+jIqcLCFtpAnBO5loFT9hMX1ac=;
  b=aumJ71DIzNjY0ngSK/yFeWJ2YosldX+36Y9RLNvOFqE3luVOdPGo4dRZ
   seMFZJK/+cMyqnymN78GRq+hUjVgYNPj/XOfVxpjKbaxr8eq4xiJoaAnD
   04cH4qle/LsfZ3w3GPo0EtUFEA1UJSeaJVtsdaYyy+9Up9i68RQ3QIisc
   uSk/T4H6GdKsyRB4jrEGwkTeTBPP1CYalyooguNlqjketugSNaHyiOR0m
   tAyIpCXIE1ThLBBfUoqixsE8Ny0emxp9AvX4+Wcy0OngyDI6ZJ6BBkZDa
   V7uY7MX5AwJtv86r2DAfAzNzhuFxy7BTIJHXr/D9qVGUtEI8EckFECyjR
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="356830806"
X-IronPort-AV: E=Sophos;i="6.00,222,1681196400"; 
   d="scan'208";a="356830806"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 15:58:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="779146233"
X-IronPort-AV: E=Sophos;i="6.00,222,1681196400"; 
   d="scan'208";a="779146233"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga004.fm.intel.com with ESMTP; 06 Jun 2023 15:58:08 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 15:58:08 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 15:58:07 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 6 Jun 2023 15:58:07 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.171)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 6 Jun 2023 15:58:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cl2MxKP/iVmHuWEtpMKyF9QQIW67dAYIhtLxaeocDgKMZD9BPV3o0d3WIs92QtWHTs5XbSfiaeWbPW7Hf4PlXaRE9eKPqQaaY1ZrO+HwcpCZDPL5n8Av6R/qsWYB+1eOr69FA9LVhRaGhddqs9yYARffe+sqHx1HZ32wkckto9MxJZH6L9nxw5Hf7mvpLyn9Db6rHk4lYDqQxcsXb1/Q/r3DiwJ+3UeARih3PRTE4vrh2iDDh6K784t4m3bcNmeOqtKaaOXFale9iAbfqIH/eatvLnhLVDekRAqYGvsVzol+fZ3xQ82Ujg2ozisIWOsta7fhEeb804tGSPxCwYA9WQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lMj+btD7TqyNhq3LR+jIqcLCFtpAnBO5loFT9hMX1ac=;
 b=KRjKAt2f8yQzL3Uyw1OTpmxO30Pv4eYBKRc/M5L7JCrLgiRnbsFV8Fk0Lse2Y4uNW6G7+4lKoTUbGZATG6dE3inI7uhhwlKQel6hfxxqOZYo2vAG4/dcbgLmowAobfSFET49qPmIXhBmaAzx/nEslc4y0wX8CdHRpMqSlxUnmLaIg5OzKAE96ZB+Wj7R7rG77v/9oazd4IjjihYRfp8qsgLPtua8L4e1IUvatqdumMVSqC5J9w5sJA0oudsQHLe6zKL1KIlw5XmZIcDZwShU1JHVxYNupUprAbYGXU+nH3fgE5b7b5uCQq136scfqO8PK0jLdmJXp7yCqVpX0f8Beg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH7PR11MB5958.namprd11.prod.outlook.com (2603:10b6:510:1e1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.19; Tue, 6 Jun
 2023 22:58:04 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 22:58:04 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v11 04/20] x86/cpu: Detect TDX partial write machine check
 erratum
Thread-Topic: [PATCH v11 04/20] x86/cpu: Detect TDX partial write machine
 check erratum
Thread-Index: AQHZlu+rViPY+CkNoE2o6SSiJzjZxK99ua6AgACtIoA=
Date:   Tue, 6 Jun 2023 22:58:04 +0000
Message-ID: <4e9acea6b956e1fb83b4e49fc8d154295e321f29.camel@intel.com>
References: <cover.1685887183.git.kai.huang@intel.com>
         <86f2a8814240f4bbe850f6a09fc9d0b934979d1b.1685887183.git.kai.huang@intel.com>
         <20230606123821.exit7gyxs42dxotz@box.shutemov.name>
In-Reply-To: <20230606123821.exit7gyxs42dxotz@box.shutemov.name>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH7PR11MB5958:EE_
x-ms-office365-filtering-correlation-id: 410aabea-167e-456f-7ee0-08db66e17c8c
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KbC0vsAochpLXiy2h0AIf+G4+y0W/77Y2F9zhczJBAHBPyEdVqN76/rqhq8UEcLBGljWpjlBixttZe7II4ns/LaAoCyiuoK4reuRJ+HEl+ZPYc9htCbo1qk2dMGe19NzKw/DX1GoeTyXTdqIfB1dA5p0Jl1SEllMbJmn5hGtSiuqvJVhe8E3WUUzGDWhhBbeDYuy/aFHXgnCFl2K9mxH6NPJIZEDqZ6r9fm4FM6MBGhQPM1lqVszN6H7ISU4eXikOlabWb3KpnswNwJxHpPwLFQSxa2LvDNakuK6Z1zKsbTtZyLfOBcta65tGlTEES0Ie/r43PUUAGcGHofz7yls34d8sDuP+sVSTPebU4c8xFnjzSP4fug5nYmDHqt0BAnt10QSle/Nny0njDC1xCJpMK97cuRGmjPrrz5Nf5aMM2u6FcDGD98zNanaTEhUKEdjtmd+QrruQS7j8FydePrU2T8grHxzYkR56nrh+ZtRKTMWpJ2176ZvAqxKoHtIZDVK6Np8V07qttb47DyOjSYW58LqhNdjjayyYcvg/WeD9EB0cjSpOmBFI0F53jSlltpL7Niq7EOhALKPo+WZaabAnZligt/NAlDPgbSkX9k9wa4UEY+wj+8O6N1799d70+om
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(346002)(136003)(376002)(39860400002)(396003)(451199021)(186003)(2616005)(478600001)(6506007)(6512007)(26005)(83380400001)(6486002)(316002)(8676002)(8936002)(38070700005)(86362001)(38100700002)(41300700001)(71200400001)(66476007)(66446008)(6916009)(76116006)(64756008)(66946007)(122000001)(36756003)(91956017)(82960400001)(2906002)(4326008)(5660300002)(7416002)(54906003)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?REhnYUdYNUJqNTJEVUMvNnR6TW5UL292Q0dFTjNGdHJQZURoWXpKVlVpd3U1?=
 =?utf-8?B?Mm5WUW0rYzlUNVFFaGtOczZaNUpOTExIV05hNXdkMVY0TWdZRENoSG1ya3BJ?=
 =?utf-8?B?SmRSWlNzUFl4bG9rVzc0Sm9ENG4wbDNlQ3YxeU9qaWZyenJWYituYnJCYWoy?=
 =?utf-8?B?TkNaak9UdVd4QTV1cFB5bFkvYVhObHR1b2I1VzFjUUFvZjlWYUc0d2xMd0Zu?=
 =?utf-8?B?cjVUdFNQRDVzNUxucUxCS1lYTndVbVdORTBRSTlnUU1CbWpXY3VJMHkzY0JZ?=
 =?utf-8?B?WE9kQ25SaHlBM3gvVmxCcThOdUtvOFBYL1Noc01XbFBYZlZoRGcyZnZSSUtS?=
 =?utf-8?B?d2FyUGNUZnFZVmlzK3BXMnBzY0tSZkxFWVk4dnJzUmFKR2xPekFLdXhDMmJ3?=
 =?utf-8?B?QlBNNmdWZHQzS3EvaXY5N3pkQVVobkdNeldwZVNrbjRocU4vaWFoaEhmNGdK?=
 =?utf-8?B?V3ZRQitDRUcrdERFb09GVktvYVN6THNoaWhUa01XdUJhZ2lPQlpabFJ2NW9J?=
 =?utf-8?B?RDl3VkpwVjJUM1pGR2s2cEpuMWYwemFldzRpSWlwRk5XYmpYZWxpNkVCWm5S?=
 =?utf-8?B?VTRPSjdzNlJWemxkY0lBTEJCU3NUbnhtdm5GQkpMdjM1cVpkL2V5dkFuRSsv?=
 =?utf-8?B?L1dUdGdQQXNycjNlSjd5a09ZR0lyV0RlQ3hkM2tnZm9Qc29hSDd2V0ZwdzR4?=
 =?utf-8?B?UnJ5dDB2ZDRnQkc5L1k0WEFVdi8rK0YwL1pEYVJUajRWaXdJSHlvTnlnOTFP?=
 =?utf-8?B?M0VOMmFpSzVGQ1pHaUtwUUVENzBJUDdXeFZSVElKRklXbWwzOU5MVk9uVVQ3?=
 =?utf-8?B?dkVTS0RhMkxoMjBldnpjNFI4Z0o0TFpMbmxtMUlmYS9lZ3RHNnFFMzF5RHly?=
 =?utf-8?B?VHg4ZW9iOUEwWC9IVTNnQzZGWXc1OEtTQVRVdWtac1lDbGxYdTBJSU1MTlEr?=
 =?utf-8?B?RGp1SFpQR2swU2EyWkF5bjlhNnRETFQ5czJEOUZXc0p1SjNrZFdPMDV3WTZT?=
 =?utf-8?B?TlVuTnRPKzlpOFFYWGVtTU51UWdqQXlKS1M3TCtMS3RmSjFHZXQ0T1BzZ25O?=
 =?utf-8?B?cHAvVVJIUEJ4T3QyQXFGeVhDeGxnUU5LbUg5ODVzZHpsUnBpMWIyNk03bDV5?=
 =?utf-8?B?U0UzQUxCOHhWQm9STWo3KzJNY1Z0K0o4RFhBdURld3lnYnk1SVdIWGx1QkpQ?=
 =?utf-8?B?aUZxVklZVyt4K21oNys3dE9QaW4vMWJLQi9NNzBKTUt2NSsvdzFTSGxRTnlr?=
 =?utf-8?B?NXZVTkNxcmFLaUl0RkJmam9pM2pYa2FtUDFhaWJpdkdyY2dXbHZYVXAvV3RY?=
 =?utf-8?B?MktPR3JDQzgxK0tMZ1hpcDZQUitUcThlTGhFS0oyeXdvc2NPWmJXb0hzb3BF?=
 =?utf-8?B?K0RkeCt2NVRPclZxR0pBbkpidjV5VU9BTmI5WjRraGQzV1I0ZWtyK01WWnk1?=
 =?utf-8?B?Y0xjc3UrLzBoR1cyTkZMSytPYTUzSm4yVzdqSlBVOXN0U2FtRVF4aTNLT0F0?=
 =?utf-8?B?SXlVcXJ6RWg4YlVkQVhjUFFEZTJCbjF5QmY4aTBjbERXaE1Hd00wVGpkamlE?=
 =?utf-8?B?Y1luNC9GYXJsU0FOSk9BSklMVzJkYjV6cFpxMGJqN2hJUFk2OUVwRmU3ZUF3?=
 =?utf-8?B?MDNwNitKM0FncHVpdUE2K3ArYnBXZWo4cTc1SWxpcjdYYkR0a3hqWHQxS1U0?=
 =?utf-8?B?R1ZVQ2JxdGY5V0pzL3VqODV0OHZKUENTWW43cGdTaTZvdWZWUFJuK0JjNmc4?=
 =?utf-8?B?dm80V2hiUDRXZ29WQk9LTnVyTnNZS2Q5MHkvOVk0N2NiTXN4MThYRjhvNEhM?=
 =?utf-8?B?aG9uRTAyelBYbUQ2aEdnaW1NR2M2d1c2SWR5NkVabHhaR3BUaWplVTZmdm1n?=
 =?utf-8?B?U05pQWcwaTlJRG5xbU53Q2JHaWl4cHlsQmVQOTBEVmhoczhFZTBEaGVONEhq?=
 =?utf-8?B?dlFPcDFXYWYwQndIbnQxbDhhTTE3V1lnSDJIbTNzQ1RhWkFNcFdQUFJ6c3po?=
 =?utf-8?B?WFB2QkhacTduZkl3RTdiTElIZy9QbmJkVytzeGhOWTF1cG1VNkw2dStLV200?=
 =?utf-8?B?M2tTbU54QUdkQ0p1UVpwUjZmUjQ5KzF4ZHlYQ21VK1YrMVRlSHJPc1RkVEdZ?=
 =?utf-8?B?MjNjMlMzS0RhYkhLbWtGMlk1ZnMwUHVRbTh6dTFsUEZmZG5iY2VYdFBQeEts?=
 =?utf-8?B?WFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4B9C6E799FDA5040A8D1C0318269A7A1@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 410aabea-167e-456f-7ee0-08db66e17c8c
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2023 22:58:04.5936
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZUYpKSSXQznU65rAEQBbhSl1HEcX3eWOOckPtPFOyg9he7Cgyu9MFMkwOsLDU3B9TQ+RSxjGw5rO7a+z5KkQTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5958
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCAyMDIzLTA2LTA2IGF0IDE1OjM4ICswMzAwLCBraXJpbGwuc2h1dGVtb3ZAbGludXgu
aW50ZWwuY29tIHdyb3RlOg0KPiBPbiBNb24sIEp1biAwNSwgMjAyMyBhdCAwMjoyNzoxN0FNICsx
MjAwLCBLYWkgSHVhbmcgd3JvdGU6DQo+ID4gVERYIG1lbW9yeSBoYXMgaW50ZWdyaXR5IGFuZCBj
b25maWRlbnRpYWxpdHkgcHJvdGVjdGlvbnMuICBWaW9sYXRpb25zIG9mDQo+ID4gdGhpcyBpbnRl
Z3JpdHkgcHJvdGVjdGlvbiBhcmUgc3VwcG9zZWQgdG8gb25seSBhZmZlY3QgVERYIG9wZXJhdGlv
bnMgYW5kDQo+ID4gYXJlIG5ldmVyIHN1cHBvc2VkIHRvIGFmZmVjdCB0aGUgaG9zdCBrZXJuZWwg
aXRzZWxmLiAgSW4gb3RoZXIgd29yZHMsDQo+ID4gdGhlIGhvc3Qga2VybmVsIHNob3VsZCBuZXZl
ciwgaXRzZWxmLCBzZWUgbWFjaGluZSBjaGVja3MgaW5kdWNlZCBieSB0aGUNCj4gPiBURFggaW50
ZWdyaXR5IGhhcmR3YXJlLg0KPiA+IA0KPiA+IEFsYXMsIHRoZSBmaXJzdCBmZXcgZ2VuZXJhdGlv
bnMgb2YgVERYIGhhcmR3YXJlIGhhdmUgYW4gZXJyYXR1bS4gIEENCj4gPiAicGFydGlhbCIgd3Jp
dGUgdG8gYSBURFggcHJpdmF0ZSBtZW1vcnkgY2FjaGVsaW5lIHdpbGwgc2lsZW50bHkgInBvaXNv
biINCj4gPiB0aGUgbGluZS4gIFN1YnNlcXVlbnQgcmVhZHMgd2lsbCBjb25zdW1lIHRoZSBwb2lz
b24gYW5kIGdlbmVyYXRlIGENCj4gPiBtYWNoaW5lIGNoZWNrLiAgQWNjb3JkaW5nIHRvIHRoZSBU
RFggaGFyZHdhcmUgc3BlYywgbmVpdGhlciBvZiB0aGVzZQ0KPiA+IHRoaW5ncyBzaG91bGQgaGF2
ZSBoYXBwZW5lZC4NCj4gPiANCj4gPiBWaXJ0dWFsbHkgYWxsIGtlcm5lbCBtZW1vcnkgYWNjZXNz
ZXMgb3BlcmF0aW9ucyBoYXBwZW4gaW4gZnVsbA0KPiA+IGNhY2hlbGluZXMuICBJbiBwcmFjdGlj
ZSwgd3JpdGluZyBhICJieXRlIiBvZiBtZW1vcnkgdXN1YWxseSByZWFkcyBhIDY0DQo+ID4gYnl0
ZSBjYWNoZWxpbmUgb2YgbWVtb3J5LCBtb2RpZmllcyBpdCwgdGhlbiB3cml0ZXMgdGhlIHdob2xl
IGxpbmUgYmFjay4NCj4gPiBUaG9zZSBvcGVyYXRpb25zIGRvIG5vdCB0cmlnZ2VyIHRoaXMgcHJv
YmxlbS4NCj4gPiANCj4gPiBUaGlzIHByb2JsZW0gaXMgdHJpZ2dlcmVkIGJ5ICJwYXJ0aWFsIiB3
cml0ZXMgd2hlcmUgYSB3cml0ZSB0cmFuc2FjdGlvbg0KPiA+IG9mIGxlc3MgdGhhbiBjYWNoZWxp
bmUgbGFuZHMgYXQgdGhlIG1lbW9yeSBjb250cm9sbGVyLiAgVGhlIENQVSBkb2VzDQo+ID4gdGhl
c2UgdmlhIG5vbi10ZW1wb3JhbCB3cml0ZSBpbnN0cnVjdGlvbnMgKGxpa2UgTU9WTlRJKSwgb3Ig
dGhyb3VnaA0KPiA+IFVDL1dDIG1lbW9yeSBtYXBwaW5ncy4gIFRoZSBpc3N1ZSBjYW4gYWxzbyBi
ZSB0cmlnZ2VyZWQgYXdheSBmcm9tIHRoZQ0KPiA+IENQVSBieSBkZXZpY2VzIGRvaW5nIHBhcnRp
YWwgd3JpdGVzIHZpYSBETUEuDQo+ID4gDQo+ID4gV2l0aCB0aGlzIGVycmF0dW0sIHRoZXJlIGFy
ZSBhZGRpdGlvbmFsIHRoaW5ncyBuZWVkIHRvIGJlIGRvbmUgYXJvdW5kDQo+ID4gbWFjaGluZSBj
aGVjayBoYW5kbGVyIGFuZCBrZXhlYygpLCBldGMuICBTaW1pbGFyIHRvIG90aGVyIENQVSBidWdz
LCB1c2UNCj4gPiBhIENQVSBidWcgYml0IHRvIGluZGljYXRlIHRoaXMgZXJyYXR1bSwgYW5kIGRl
dGVjdCB0aGlzIGVycmF0dW0gZHVyaW5nDQo+ID4gZWFybHkgYm9vdC4gIE5vdGUgdGhpcyBidWcg
cmVmbGVjdHMgdGhlIGhhcmR3YXJlIHRodXMgaXQgaXMgZGV0ZWN0ZWQNCj4gPiByZWdhcmRsZXNz
IG9mIHdoZXRoZXIgdGhlIGtlcm5lbCBpcyBidWlsdCB3aXRoIFREWCBzdXBwb3J0IG9yIG5vdC4N
Cj4gPiANCj4gPiBTaWduZWQtb2ZmLWJ5OiBLYWkgSHVhbmcgPGthaS5odWFuZ0BpbnRlbC5jb20+
DQo+ID4gLS0tDQo+ID4gDQo+ID4gdjEwIC0+IHYxMToNCj4gPiAgLSBOZXcgcGF0Y2gNCj4gPiAN
Cj4gPiAtLS0NCj4gPiAgYXJjaC94ODYvaW5jbHVkZS9hc20vY3B1ZmVhdHVyZXMuaCB8ICAxICsN
Cj4gPiAgYXJjaC94ODYva2VybmVsL2NwdS9pbnRlbC5jICAgICAgICB8IDIxICsrKysrKysrKysr
KysrKysrKysrKw0KPiA+ICAyIGZpbGVzIGNoYW5nZWQsIDIyIGluc2VydGlvbnMoKykNCj4gPiAN
Cj4gPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYvaW5jbHVkZS9hc20vY3B1ZmVhdHVyZXMuaCBiL2Fy
Y2gveDg2L2luY2x1ZGUvYXNtL2NwdWZlYXR1cmVzLmgNCj4gPiBpbmRleCBjYjhjYTQ2MjEzYmUu
LmRjODcwMWY4ZDg4YiAxMDA2NDQNCj4gPiAtLS0gYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9jcHVm
ZWF0dXJlcy5oDQo+ID4gKysrIGIvYXJjaC94ODYvaW5jbHVkZS9hc20vY3B1ZmVhdHVyZXMuaA0K
PiA+IEBAIC00ODMsNSArNDgzLDYgQEANCj4gPiAgI2RlZmluZSBYODZfQlVHX1JFVEJMRUVECQlY
ODZfQlVHKDI3KSAvKiBDUFUgaXMgYWZmZWN0ZWQgYnkgUkVUQmxlZWQgKi8NCj4gPiAgI2RlZmlu
ZSBYODZfQlVHX0VJQlJTX1BCUlNCCQlYODZfQlVHKDI4KSAvKiBFSUJSUyBpcyB2dWxuZXJhYmxl
IHRvIFBvc3QgQmFycmllciBSU0IgUHJlZGljdGlvbnMgKi8NCj4gPiAgI2RlZmluZSBYODZfQlVH
X1NNVF9SU0IJCQlYODZfQlVHKDI5KSAvKiBDUFUgaXMgdnVsbmVyYWJsZSB0byBDcm9zcy1UaHJl
YWQgUmV0dXJuIEFkZHJlc3MgUHJlZGljdGlvbnMgKi8NCj4gPiArI2RlZmluZSBYODZfQlVHX1RE
WF9QV19NQ0UJCVg4Nl9CVUcoMzApIC8qIENQVSBtYXkgaW5jdXIgI01DIGlmIG5vbi1URCBzb2Z0
d2FyZSBkb2VzIHBhcnRpYWwgd3JpdGUgdG8gVERYIHByaXZhdGUgbWVtb3J5ICovDQo+ID4gIA0K
PiA+ICAjZW5kaWYgLyogX0FTTV9YODZfQ1BVRkVBVFVSRVNfSCAqLw0KPiA+IGRpZmYgLS1naXQg
YS9hcmNoL3g4Ni9rZXJuZWwvY3B1L2ludGVsLmMgYi9hcmNoL3g4Ni9rZXJuZWwvY3B1L2ludGVs
LmMNCj4gPiBpbmRleCAxYzQ2Mzk1ODhmZjkuLjI1MWIzMzNlNTNkMiAxMDA2NDQNCj4gPiAtLS0g
YS9hcmNoL3g4Ni9rZXJuZWwvY3B1L2ludGVsLmMNCj4gPiArKysgYi9hcmNoL3g4Ni9rZXJuZWwv
Y3B1L2ludGVsLmMNCj4gPiBAQCAtMTU1MiwzICsxNTUyLDI0IEBAIHU4IGdldF90aGlzX2h5YnJp
ZF9jcHVfdHlwZSh2b2lkKQ0KPiA+ICANCj4gPiAgCXJldHVybiBjcHVpZF9lYXgoMHgwMDAwMDAx
YSkgPj4gWDg2X0hZQlJJRF9DUFVfVFlQRV9JRF9TSElGVDsNCj4gPiAgfQ0KPiA+ICsNCj4gPiAr
LyoNCj4gPiArICogVGhlc2UgQ1BVcyBoYXZlIGFuIGVycmF0dW0uICBBIHBhcnRpYWwgd3JpdGUg
ZnJvbSBub24tVEQNCj4gPiArICogc29mdHdhcmUgKGUuZy4gdmlhIE1PVk5USSB2YXJpYW50cyBv
ciBVQy9XQyBtYXBwaW5nKSB0byBURFgNCj4gPiArICogcHJpdmF0ZSBtZW1vcnkgcG9pc29ucyB0
aGF0IG1lbW9yeSwgYW5kIGEgc3Vic2VxdWVudCByZWFkIG9mDQo+ID4gKyAqIHRoYXQgbWVtb3J5
IHRyaWdnZXJzICNNQy4NCj4gPiArICovDQo+ID4gK3N0YXRpYyBjb25zdCBzdHJ1Y3QgeDg2X2Nw
dV9pZCB0ZHhfcHdfbWNlX2NwdV9pZHNbXSBfX2luaXRjb25zdCA9IHsNCj4gPiArCVg4Nl9NQVRD
SF9JTlRFTF9GQU02X01PREVMKFNBUFBISVJFUkFQSURTX1gsIE5VTEwpLA0KPiA+ICsJWDg2X01B
VENIX0lOVEVMX0ZBTTZfTU9ERUwoRU1FUkFMRFJBUElEU19YLCBOVUxMKSwNCj4gPiArCXsgfQ0K
PiA+ICt9Ow0KPiA+ICsNCj4gPiArc3RhdGljIGludCBfX2luaXQgdGR4X2VycmF0dW1fZGV0ZWN0
KHZvaWQpDQo+ID4gK3sNCj4gPiArCWlmICh4ODZfbWF0Y2hfY3B1KHRkeF9wd19tY2VfY3B1X2lk
cykpDQo+ID4gKwkJc2V0dXBfZm9yY2VfY3B1X2J1ZyhYODZfQlVHX1REWF9QV19NQ0UpOw0KPiA+
ICsNCj4gPiArCXJldHVybiAwOw0KPiA+ICt9DQo+ID4gK2Vhcmx5X2luaXRjYWxsKHRkeF9lcnJh
dHVtX2RldGVjdCk7DQo+IA0KPiBJbml0Y2FsbD8gRG9uJ3Qgd2UgYWxyZWFkeSBoYXZlIGEgY29k
ZXBhdGggdG8gY2FsbCBpdCBkaXJlY3RseT8NCj4gTWF5YmUgY3B1X3NldF9idWdfYml0cygpPw0K
PiANCkkgIGRpZG4ndCBsaWtlIGRvaW5nIGluIGNwdV9zZXRfYnVnX2JpdHMoKSBiZWNhdXNlIGl0
IGFwcGVhcnMgdGhlIGJ1Z3MgdGhhdA0KaGFuZGxlZCBpbiB0aGF0IGZ1bmN0aW9uIHNlZW0gdG8g
aGF2ZSBzb21lIGRlcGVuZGVuY3kuICBGb3IgaW5zdGFuY2UsIGlmIGEgQ1BVDQppcyBpbiB0aGUg
d2hpdGVsaXN0IG9mIE5PX1NQRUNVTEFUSU9OLCB0aGVuIHRoaXMgZnVuY3Rpb24gc2ltcGx5IHJl
dHVybnMgYW5kDQphc3N1bWVzIGFsbCBvdGhlciBidWdzIGFyZSBub3QgcHJlc2VudDoNCg0Kc3Rh
dGljIHZvaWQgX19pbml0IGNwdV9zZXRfYnVnX2JpdHMoc3RydWN0IGNwdWluZm9feDg2ICpjKQ0K
eyAgICAgICAgICAgICAgICAgICAgICAgDQogICAgICAgIHU2NCBpYTMyX2NhcCA9IHg4Nl9yZWFk
X2FyY2hfY2FwX21zcigpOw0KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICANCgkuLi4N
Cg0KICAgICAgICBpZiAoY3B1X21hdGNoZXMoY3B1X3Z1bG5fd2hpdGVsaXN0LCBOT19TUEVDVUxB
VElPTikpDQogICAgICAgICAgICAgICAgcmV0dXJuOw0KDQogICAgICAgIHNldHVwX2ZvcmNlX2Nw
dV9idWcoWDg2X0JVR19TUEVDVFJFX1YxKTsNCgkNCgkuLi4NCn0NCg0KVGhpcyBURFggZXJyYXR1
bSBpcyBxdWl0ZSBzZWxmIGNvbnRhaW5lZCB0aHVzIEkgdGhpbmsgdXNpbmcgc29tZSBpbml0Y2Fs
bCBpcyB0aGUNCmNsZWFuZXN0IHdheSB0byBkby4NCg0KQW5kIHRoZXJlICBhcmUgb3RoZXIgYnVn
IGZsYWdzIHRoYXQgYXJlIGhhbmRsZWQgaW4gb3RoZXIgcGxhY2VzICBidXQgbm90IGluDQpjcHVf
c2V0X2J1Z19iaXRzKCksIGZvciBpbnN0YW5jZSwgDQoNCnN0YXRpYyB2b2lkIGluaXRfaW50ZWwo
c3RydWN0IGNwdWluZm9feDg2ICpjKQ0KeyAgICAgICAgICAgICAgIA0KCS4uLg0KDQogICAgICAg
IGlmIChjLT54ODYgPT0gNiAmJiBib290X2NwdV9oYXMoWDg2X0ZFQVRVUkVfTVdBSVQpICYmDQog
ICAgICAgICAgICAgICAgKChjLT54ODZfbW9kZWwgPT0gSU5URUxfRkFNNl9BVE9NX0dPTERNT05U
KSkpDQogICAgICAgICAgICAgICAgc2V0X2NwdV9idWcoYywgWDg2X0JVR19NT05JVE9SKTsNCg0K
CS4uLg0KfQ0KDQpTbyBpdCBzZWVtcyB0aGVyZSdzIG5vIGhhcmQgcnVsZSB0aGF0IGFsbCBidWdz
IG5lZWQgdG8gYmUgZG9uZSBpbg0KY3B1X3NldF9idWdfYml0cygpLg0KDQoNCg==
