Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67F126C72C0
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 23:09:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230456AbjCWWJy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 18:09:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230491AbjCWWJv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 18:09:51 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B822B12041;
        Thu, 23 Mar 2023 15:09:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679609390; x=1711145390;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=WYCHMyyDVpQj0ZR6Ah9ZqLK0Lo6lfDx1WgCPg1kB7ZQ=;
  b=PZWzT+Edwi24eHE9iFeBYMJddfNq8DlV2vKGVzYliqzCvDmN/T7Hb1IK
   29mp4hcG0NWGNnijvRRkgnAtxZRRpoWPMmOCkhaokn2wZSNoJJLD45s7U
   uL7BAt/TAU9A/5TlMPLpbAap1iVgeQtIltH4vgb/zyJByhe8taJFf1uTM
   eXfDAiN3RBycA1Cw5YNCEC2sYtYOgncmn/ILtgDpdPSUQseENRGGUapU+
   bnY9N/aWLiQ823N6d77YlLEjvKiYxGxYBDlQMzaEmf4lmbYAXWNZMtUxK
   XR+rFYmT1Vjl3giD9nIdC7rkgkhFsqkfmVxpz0Jd0gKmcZ+b5UjpAMSzy
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10658"; a="338359780"
X-IronPort-AV: E=Sophos;i="5.98,286,1673942400"; 
   d="scan'208";a="338359780"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2023 15:09:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10658"; a="712851966"
X-IronPort-AV: E=Sophos;i="5.98,286,1673942400"; 
   d="scan'208";a="712851966"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga008.jf.intel.com with ESMTP; 23 Mar 2023 15:09:49 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 23 Mar 2023 15:09:49 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 23 Mar 2023 15:09:48 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 23 Mar 2023 15:09:48 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.48) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 23 Mar 2023 15:09:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XiqALML2B7ZJVghDBnpXQzsfN3Wt0QjOLbPj0TaG8gzPmBXfyp8Jzt7ix7efknvSjRdtN8nWhnm4a7/u2xa7yGz/MgkemH9ESfmEj81bIEUNYzR+PolfxyEv5Er4iUzfeE3ZQXHfwqE96YFFkek3jmh7Wcnaeex5kclyTIv46XPYv0wYOxS3EetyQYY3rRDcQHHZY+x6UTH0P4s7guMN2qLlYVk4q3jcgz/CvytoYbC5//JNYAovIPbCJUxpBEByxtNPeITH7TGysXqfO5m32ZCaS7YG+rbmCDTmNPcKBD9BhXusfMlA3eS0Dvd/+zlvayVMK+4kHZLir1s2jxTGDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WYCHMyyDVpQj0ZR6Ah9ZqLK0Lo6lfDx1WgCPg1kB7ZQ=;
 b=dqyin/80EfcVB5ExYsA2GBnTAKg+gum4FAeVbvfKJgttMmi+1h4afkoBOR+xjOhu9j32hmKZ//1QkeuLrAmxPzNFm+ft5/IawGMYOLU1iTgZtu+mIURctPZtUWE3zvw4xGiurLhv6FDJk6a458EweZibefGJrss5GPRkUo+/JO+SZQppcNsQ/SNCzh05ZTeL5LHUgZ1+VXYu9qTgPjaQEPOqsnwqDYtuTs/igw2g5ONN9u30h94hkEiWkOxF5eg9XCJ/TbYhwk3jG2tvs3VC4UlXWgtPHllv7d2C2WWLIkcY6+kf8yOd+lJ8rqzSy2deKFWOHwWFa9kTRGlALKgJCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA0PR11MB4590.namprd11.prod.outlook.com (2603:10b6:806:96::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Thu, 23 Mar
 2023 22:09:45 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9%4]) with mapi id 15.20.6178.037; Thu, 23 Mar 2023
 22:09:45 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Hansen, Dave" <dave.hansen@intel.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
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
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v10 05/16] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Thread-Topic: [PATCH v10 05/16] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Thread-Index: AQHZUDU50M/RwoyayES+lzw7MeI2g67xefUAgAZUzQCAAZ2qAIAAIeiAgADqJACAAUSFAIAMvysAgACLv4A=
Date:   Thu, 23 Mar 2023 22:09:45 +0000
Message-ID: <6be93d78e01906ff5c3714005170d761e5b40d41.camel@intel.com>
References: <cover.1678111292.git.kai.huang@intel.com>
         <f150316b975b5ca22c6c4016ffd90db79d657bbf.1678111292.git.kai.huang@intel.com>
         <20230308222738.GA3419702@ls.amr.corp.intel.com>
         <96b56c5b8a5876aaf6d5ccbb81bab334b10983eb.camel@intel.com>
         <20230313234916.GC3922605@ls.amr.corp.intel.com>
         <a62497059fc3f31706a532b822d6c966bd981468.camel@intel.com>
         <5c4a28c8-f17d-7395-cc63-3cbd9b31befb@intel.com>
         <a02f304ea0e62180e07e2eb63eaf2411b702c672.camel@intel.com>
         <141def31-dcbb-70ae-2935-4fb06a986036@intel.com>
In-Reply-To: <141def31-dcbb-70ae-2935-4fb06a986036@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SA0PR11MB4590:EE_
x-ms-office365-filtering-correlation-id: e29c6385-0eeb-4dcf-7bac-08db2beb4f63
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xuY5EX8cvROYa4iSedqu12I5Gkdcr79NISDzzGKi422CghgsSVoR8oxQKmiU7p41jjDemgnHLIy951K9Z8pW+2WrIdy69dxhQoO7c3yhGdIFykTncKWuICyM9LVfP/Ic3cyk+pdAIEbuvmMjGBIn8cA7TLhanHGb9gqVoPb4TFag7gYe+VW9wTngzr4ASjEc5gGclp9BAmMAuckpP6ivYQ9+dOL688IYZ9CRPXYLnFzJdRZyrFyq4meeJZ+ZArNOwLhptFtCYjTQCKVF2Rn72J+gQvtRzHHjhGMKDFUxEQr1UgkLw+jDEBPgJ8hrtmx4XvOxM+89YEcq1SLN9d+WrTFK2QCaqZf+WBD9lZkTi9i2Dfhuoopvga7NleSSGhF4bqhjMo5OO/d3ylpYpS1t5Dqw/PAPRvhw+LP1rwa8OHmoyJLB0PpCUFO4v2H8yqN0m0Zy/s840NhXgy1Fny1G+AKCzscSNEhpVDd+sR1qOIQyiC7/qp9BSbL0Vic3Nne+elqCtpgCVz0Wgb930xVZb57f52WuQgUFWnXhJodPEmuzRKlts1JgoPkYqq3ErB/eL16NvIcsvrof8vus6HAU1lW1hQrJSXb7E5GJUpes35mbmFkV/4tNLqRxQLCXP1d9YxN9YQRAxtGemZX4M0p2SsYCZvi0tqSNs1DGNptRiEQZewsPXZVgPfwyDudfCYettP/IhfBW42HP0XrM/Iwtrg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(376002)(396003)(346002)(39860400002)(136003)(451199018)(36756003)(38100700002)(122000001)(82960400001)(26005)(6512007)(186003)(6506007)(53546011)(6486002)(2616005)(7416002)(8936002)(5660300002)(86362001)(41300700001)(2906002)(38070700005)(91956017)(478600001)(71200400001)(66946007)(76116006)(54906003)(64756008)(66446008)(66476007)(66556008)(110136005)(4326008)(8676002)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?S05yZEZUb3RTS0thdVg1QWJrU2xHS1RaaldROVprSE1tellqSGVXczIrL056?=
 =?utf-8?B?UUdOeEkxbWE0YTdaZXIyYUZSYTM3OEhYWGw4MWM2aXVrWHBGc2grR1BqNVVI?=
 =?utf-8?B?QktFNXZtcmhYUDJpd1ExZVJPMVNNVTUwd1B2aFJadjhpNGY2a0VpZUcweHI2?=
 =?utf-8?B?aitXVEdnL0pNaVJ4RHZuZjdLRmlOSUdwSEdkQWVKRzZUTHpIOEQrbENyL2hn?=
 =?utf-8?B?QkhXcmFrakkxZXc3TWtMRDF6SnBLZDM4NVRVUmk2T21vVDgrLzNlYzB1c2Vr?=
 =?utf-8?B?Zm02RGt2L0syYXVvVXU4NTRNWWtvTXNON1VKOHU4OWF6Q296Rm1uOGIvQmR6?=
 =?utf-8?B?bWVYdUsvbUdPYnFrSkhwc01xVk5uV2VkNll5bDhBa0VaRUZsRk9kZFdaZzQ5?=
 =?utf-8?B?a1YwVjh6WkkwWUtLSUQvRWpYVUQ2NHR5eU1TR1lyVFZpTHE3UUJsam5DOUNV?=
 =?utf-8?B?ejRQNHdSdC9lSC9RaWU0VFVsL1crdjcycEdRdnpsallFOW5ZdE16b1BVSy9o?=
 =?utf-8?B?UCtjQU1LZ1FSTG5GRkQ2YkVnT2JPZHNqK2RaZUtPa1MwQk1OR3FQQjd0a1kx?=
 =?utf-8?B?bGpqRGNxQmc1dGR3NzdpVmxnWWdKZm85M0dqYmYxazE2Zk5hdkhIUERyTDc4?=
 =?utf-8?B?bmxwalVJSW54V1drc3hNQVpaTWF0VWROeHRJcUg2aEJUOFRTOFpGSlRzNDZP?=
 =?utf-8?B?Qjd1ZU4vVzF4N0ZwaWtoRGowUitzSG5pQWZmOHhUemZ4dEpRWEVKcU83ODl0?=
 =?utf-8?B?WkRXeCtFb0FvSWViQjl5NXJVdU1hb2k0QmZ5S2VRRXRSWElMTC9xeEJuUDVL?=
 =?utf-8?B?cC93RkZiRzRjTnRmMjBNempIdnBTZE9sMHJhUjBGUTk0QUMwQWgyWlphZUR3?=
 =?utf-8?B?d09JMk5jVXhFajBvVzZ2RUZ0N0tSTUtDOXExcytiTTFqVTVYS2R6cFlhazJH?=
 =?utf-8?B?eFFmbXhsc2dEVkQ3Ym9ldXJXMGJyZjNvOW5jNDZkRFhGVDF0WHZ6N2hPNUFy?=
 =?utf-8?B?MEpMejgxeks0TFNUVWQyaTBYOUU5eEt5bytURXFHN0oyQkpzeWYxTFlPRVZM?=
 =?utf-8?B?QWR0b1F1T2JDRWs1ZW53aFozNFRmVFVPMVZidXozVkk4MU9YL1dEL1l4MHZ6?=
 =?utf-8?B?QTlZMWtsaG1VUFRmRGFjRVk5bTRpWWozVmV1QjRubzJ0WU15WDBhOVFhNlVk?=
 =?utf-8?B?UVI2N3FHaXZ3RUJxQ0p0cUU4dTlXcUFvNXo5Vk90cFhFcjZVeGVtK0NORWdr?=
 =?utf-8?B?Z0h4UmNDdWx6Q2dGT3JZb01QUHZPTDFaNnd0clc5M21KZ1VybG9taDlVTjlC?=
 =?utf-8?B?NDVISzBYcU52VFUza3NVUDJqQS8xVUdDdEFOWGpjMzJSclZKUG9CWFdOcHQx?=
 =?utf-8?B?WHJKa0o1blZWMjM0SEc3VFdMc0VKc0dCWWJObVh2T0xPRTEvV2JmSnBNV05S?=
 =?utf-8?B?RWpCK0w0bU1seTJTWXMxYWpHYXd5Rzd3LzM1NkU1MVpnRzFhdWFIUkIrMmw3?=
 =?utf-8?B?QmRUb005ZEZaenovRXBpWFBUV2UwQkcwQytpYmRLbHloNGk0emNleTlib3hZ?=
 =?utf-8?B?RndkQlFuTUo2c2xUWm94d0dTYWhOd280UEZWTmhUaW5qcjBJMEtaZ1BoRHdn?=
 =?utf-8?B?TU5uSUtOSi9ETURiRlY1Y2RZa1g5MnUycGt4amwwRkJFOTQyUlZsY3BEME9s?=
 =?utf-8?B?ZnVWM0YzZlNtRzlRUzU0bGUvU0ZPbmZKNWNERHRBZ01OMTQrek45VnJuOUVU?=
 =?utf-8?B?c1k0b3ZDMXhMZjM0U0ZGeXFmRFRxakxWRTNlMHpOdXRXZENOd3JYMU1aTDFp?=
 =?utf-8?B?Q0VIeVpLVjVzTlJOOGoza2JjU0ZqRWdldmp5MVFCTWxFRmdHaDFHZkxOb3hl?=
 =?utf-8?B?dC94Z0ZycjViZXpFaEo0Vk9YMXY1R0NiRHkxcml6L2tBNFJ5c2Mwa2UxVHlU?=
 =?utf-8?B?b1pXQVowOWx4T3doM1NYMDVoYlE2TXJRTEFJVFMzdEx6OTYvZndCRU9GOHNQ?=
 =?utf-8?B?TE4rN2tGTFdYQVFLZ0NRa3hCV0UyNHRzSGt6MEJmMlNUWGtzdFdSUlJ3UHoy?=
 =?utf-8?B?dGJqRzlLb1hSUVhxWmtmSHlSVk56SHd2OE0rd1pQUCt6Rlg5WUdOTjUyUnRR?=
 =?utf-8?B?S2diSnY1ZlhOaDJBVnc3OGM2YUlyTHYrWm0wZXB3QlBVVUh1RTlGaWJ1VllM?=
 =?utf-8?B?UVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C875748A3E2805418D3D722B2F59872F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e29c6385-0eeb-4dcf-7bac-08db2beb4f63
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Mar 2023 22:09:45.1973
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KUepEe8M0Eq63yz7pGUjSD5gGvWdiB7dArAgwALjx/ogaRlbBLQ0sWjqVnAksmicOP8CKD3eDrDEWHgU1cZYeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4590
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIzLTAzLTIzIGF0IDA2OjQ5IC0wNzAwLCBIYW5zZW4sIERhdmUgd3JvdGU6DQo+
IE9uIDMvMTUvMjMgMDQ6MTAsIEh1YW5nLCBLYWkgd3JvdGU6DQo+ID4gSSBjYW4gZG8uICBKdXN0
IHdhbnQgdG8gbWFrZSBzdXJlIGRvIHlvdSB3YW50IHRvIHJldHJ5IFREWF9TWVNfQlVTWSwgb3Ig
cmV0cnkNCj4gPiBURFhfUk5EX05PX0VOVFJPUFkgKGlmIHdlIHdhbnQgdG8gYXNrIFREWCBtb2R1
bGUgZ3V5cyB0byBjaGFuZ2UgdG8gcmV0dXJuIHRoaXMNCj4gPiB2YWx1ZSk/DQo+IA0KPiBJJ2xs
IHB1dCBpdCB0aGlzIHdheToNCj4gDQo+IAlMaW51eCBpcyBnb2luZyB0byB0cmVhdCBURFhfU1lT
X0JVU1kgbGlrZSBhIExpbnV4IGJ1ZyBhbmQgYXNzdW1lDQo+IAlMaW51eCBpcyBkb2luZyBzb21l
dGhpbmcgd3JvbmcuICBJdCdsbCBtb3N0bHkgbWVhbiB0aGF0DQo+IAl1c2VycyB3aWxsIHNlZSBz
b21ldGhpbmcgbmFzdHkgYW5kIG1heSBldmVuIGNhdXNlIExpbnV4IHRvIGdpdmUNCj4gCXVwIG9u
IFREWC4gIEluIG90aGVyIHdvcmRzLCB0aGUgVERYIG1vZHVsZSBzaG91bGRuJ3QgdXNlDQo+IAlU
RFhfU1lTX0JVU1kgZm9yIHRoaW5ncyB0aGF0IGFyZW4ndCBMaW51eCdzIGZhdWx0Lg0KPiANCj4g
PiBBbHNvLCBldmVuIHdlIHJldHJ5IGVpdGhlciBURFhfU1lTX0JVU1kgb3IgVERYX1JORF9OT19F
TlRST1BZIGluIGNvbW1vbg0KPiA+IHNlYW1jYWxsKCkgY29kZSwgaXQgZG9lc24ndCBoYW5kbGUg
dGhlIFRESC5TWVMuS0VZLkNPTkZJRywgYmVjYXVzZSBzYWRseSB0aGlzDQo+ID4gU0VBTUNBTEwg
cmV0dXJucyBhIGRpZmZlcmVudCBlcnJvciBjb2RlOg0KPiA+IA0KPiA+IFREWF9LRVlfR0VORVJB
VElPTl9GQUlMRUQgICAgICAgRmFpbGVkIHRvIGdlbmVyYXRlIGEgcmFuZG9tIGtleS4gVGhpcyBp
cw0KPiA+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgdHlwaWNhbGx5IGNhdXNlZCBi
eSBhbiBlbnRyb3B5IGVycm9yIG9mIHRoZQ0KPiA+ICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgQ1BVJ3MgcmFuZG9tIG51bWJlciBnZW5lcmF0b3IsIGFuZCBtYXkNCj4gPiAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIGJlIGltcGFjdGVkIGJ5IFJEU0VFRCwgUkRSQU5EIG9y
IFBDT05GSUcNCj4gPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGV4ZWN1dGluZyBv
biBvdGhlciBMUHMuIFRoZSBvcGVyYXRpb24gc2hvdWxkIGJlDQo+ID4gICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICByZXRyaWVkLg0KPiANCj4gU291bmRzIGxpa2Ugd2Ugc2hvdWxkIGp1
c3QgcmVwbGFjZSBURFhfS0VZX0dFTkVSQVRJT05fRkFJTEVEIHdpdGgNCj4gVERYX1JORF9OT19F
TlRST1BZIGluIGNhc2VzIHdoZXJlIGtleSBnZW5lcmF0aW9uIGZhaWxzIGJlY2F1c2Ugb2YgYSBs
YWNrDQo+IG9mIGVudHJvcHkuDQoNClRoYW5rcyBmb3IgZmVlZGJhY2suDQoNCkknbGwgZG8gZm9s
bG93aW5nLCBwbGVhc2UgbGV0IG1lIGtub3cgZm9yIGFueSBjb21tZW50cyBpbiBjYXNlIEkgaGF2
ZSBhbnkNCm1pc3VuZGVyc3RhbmRpbmcuDQoNCjEpIEluIFRESC5TWVMuSU5JVCwgYXNrIFREWCBt
b2R1bGUgdGVhbSB0byByZXR1cm4gVERYX1JORF9OT19FTlRST1BZIGluc3RlYWQgb2YNClREWF9T
WVNfQlVTWSB3aGVuIHJ1bm5pbmcgb3V0IG9mIGVudHJvcHkuIA0KDQoyKSBJbiBUREguU1lTLktF
WS5DT05GSUcsIGFzayBURFggbW9kdWxlIHRvIHJldHVybiBURFhfUk5EX05PX0VOVFJPUFkgaW5z
dGVhZCBvZg0KVERYX0tFWV9HRU5FUkFUSU9OX0ZBSUxFRCB3aGVuIHJ1bm5pbmcgb3V0IG9mIGVu
dHJvcHkuICBXaGV0aGVyDQpURFhfS0VZX0dFTkVSQVRJT05fRkFJTEVEIHNob3VsZCBiZSBzdGls
bCBrZXB0IGlzICB1cCB0byBURFggbW9kdWxlIHRlYW0NCihiZWNhdXNlIGl0IGxvb2tzIHJ1bm5p
bmcgY29uY3VycmVudCBQQ09ORklHcyBpcyBhbHNvIHJlbGF0ZWQpLg0KDQozKSBBc2sgVERYIG1v
ZHVsZSB0byBhbHdheXMgcmV0dXJuIFREWF9STkRfTk9fRU5UUk9QWSBpbiBfQUxMXyBTRUFNQ0FM
THMgYW5kDQprZWVwIHRoaXMgYmVoYXZpb3VyIGZvciBmdXR1cmUgVERYIG1vZHVsZXMgdG9vLg0K
DQo0KSBJbiB0aGUgY29tbW9uIHNlYW1jYWxsKCksIHJldHJ5IG9uIFREWF9STkRfTk9fRU5UUk9Q
WS4NCg0KSW4gdGVybXMgb2YgaG93IG1hbnkgdGltZXMgdG8gcmV0cnksIEkgd2lsbCB1c2UgYSBm
aXhlZCB2YWx1ZSBmb3Igbm93LCBzaW1pbGFyDQp0byB0aGUga2VybmVsIGNvZGUgYmVsb3c6DQoN
CiNkZWZpbmUgUkRSQU5EX1JFVFJZX0xPT1BTICAgICAgMTAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICANCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
IA0KLyogVW5jb25kaXRpb25hbCBleGVjdXRpb24gb2YgUkRSQU5EIGFuZCBSRFNFRUQgKi8gICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIA0KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgDQpzdGF0aWMgaW5saW5lIGJvb2wgX19tdXN0X2NoZWNrIHJkcmFuZF9sb25nKHVuc2lnbmVk
IGxvbmcgKnYpICAgICAgICAgICAgICAgICAgDQp7ICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgDQogICAg
ICAgIGJvb2wgb2s7ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgDQogICAgICAgIHVuc2lnbmVkIGludCByZXRyeSA9IFJEUkFORF9S
RVRSWV9MT09QUzsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgDQogICAgICAgIGRvIHsg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgDQogICAgICAgICAgICAgICAgYXNtIHZvbGF0aWxlKCJyZHJhbmQgJVtvdXRdIiAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgDQogICAgICAgICAgICAgICAgICAgICAg
ICAgICAgIENDX1NFVChjKSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
DQogICAgICAgICAgICAgICAgICAgICAgICAgICAgIDogQ0NfT1VUKGMpIChvayksIFtvdXRdICI9
ciIgKCp2KSk7ICAgICAgICAgICAgICAgDQogICAgICAgICAgICAgICAgaWYgKG9rKSAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgDQogICAgICAg
ICAgICAgICAgICAgICAgICByZXR1cm4gdHJ1ZTsgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgDQogICAgICAgIH0gd2hpbGUgKC0tcmV0cnkpOyAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgDQogICAgICAgIHJldHVybiBm
YWxzZTsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgDQp9ICAgDQo=
