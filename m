Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99E9F72D6A1
	for <lists+kvm@lfdr.de>; Tue, 13 Jun 2023 02:51:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235062AbjFMAvd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 20:51:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbjFMAvb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 20:51:31 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52DA910CC;
        Mon, 12 Jun 2023 17:51:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686617490; x=1718153490;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=eB36iqWvlEGfIIhwU/Fb+FhMfOC2emnVEqlMGbClUI8=;
  b=eWqP6VfhLKLEqhbvOAF1+0hkGhm/BXGx7oGcXigSqesXc8JrOQ8UJ5Kf
   CMuRDIukuPyyDXswvQLAeXND6jAJiCe85/Uyp/hxI+sOfChzXBPY09is0
   4Cang0uYHgPq3eESqjCd3eAw3N8yfNfCA5FCltrNGIMcvd0Vy+H3MGnG8
   +pBrX7u+xKq14OaAqW7OzcF6qIhoBvZ6ZINoRNThQ5cjSMZ2cnAH+nKJZ
   +QVty8r25yYitDmcxdPFQCCk6axbtstyk7SvJrCvnXKLWfFcH0dwoExxb
   QLdCo60T5O1C177eZGBE8X0qQtZQF8P2X4LK4/cYPcVWuSC3LdESzeod0
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="338556639"
X-IronPort-AV: E=Sophos;i="6.00,238,1681196400"; 
   d="scan'208";a="338556639"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2023 17:51:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="835678029"
X-IronPort-AV: E=Sophos;i="6.00,238,1681196400"; 
   d="scan'208";a="835678029"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga004.jf.intel.com with ESMTP; 12 Jun 2023 17:51:29 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 12 Jun 2023 17:51:28 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 12 Jun 2023 17:51:28 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 12 Jun 2023 17:51:28 -0700
Received: from outbound.mail.protection.outlook.com (104.47.57.174) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 12 Jun 2023 17:51:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bZg/0lpotyhQrKMkRKVZy51tBebggcMKUESRI7hPFCEvPX4E2jJh2JpWlkQPMwui+joylwuj04O5ppCV+Zul+WrE0ZWYA20wGs+S5turP+seluVU11rV18ISqnso/4oGdcJUC689Gp/k4SgMvSV5Xr1XaGm9djlb4KfHWe3eblAPuRmT5ibxXXhFtGvtiMnsc1lWC5l3ca0r6Q4wMfS7p2DH9WKQhGZ/iuMdjcE+NX1I3ZziS6bJEx/V5zGZ7EmvqwBOxtmscKEmHFf2soEKgNEqo8aHQuKWuSrvP42rCroXSZtE49RCbW76RX+A7f3kRkO0zrQo7wqbiqs2Jm4Y3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eB36iqWvlEGfIIhwU/Fb+FhMfOC2emnVEqlMGbClUI8=;
 b=f/LjeLDgkDXzR2qX8ZoVuSkE4Fab44PbhgGRpTLqqJUtRIeNsl4aI6ILXQQ97/+hCzmx1o4KpZLo3Uy0zGmELZjD+Zrw2fRYok+Mkro85/380GFWlRyNHp86WYEw7qz4u6DNWC7qtEfbs9kbjC8AEsb66ZGw0F4z/Gpx/r45oBmrhrpYaYX2X1BR1YokkZVgLfUDlfOOiwc1vUPAf32DK79P+1XE7L/JOom8GaaN81d6hH+kuiwDh1KdBiXAeOvjqx/vr4zzXMCqFnRFjh/vRv/dofvQ62fLg+KeY9INPtMtgwI/I8ksBO/Uzx7CqtJGo9pXK308Vcxu38ddOO04KQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CY8PR11MB7747.namprd11.prod.outlook.com (2603:10b6:930:87::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Tue, 13 Jun
 2023 00:51:23 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6455.043; Tue, 13 Jun 2023
 00:51:23 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>
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
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v11 18/20] x86: Handle TDX erratum to reset TDX private
 memory during kexec() and reboot
Thread-Topic: [PATCH v11 18/20] x86: Handle TDX erratum to reset TDX private
 memory during kexec() and reboot
Thread-Index: AQHZlu+7CCb5RYnzE0SLr6ZWSpg4cK+CfSeAgAQK0ICAAFGDAIAAKbAAgAA3uQCAALmTAA==
Date:   Tue, 13 Jun 2023 00:51:23 +0000
Message-ID: <3bbb6b384ba89dfaa13be01654ad27e41d779fba.camel@intel.com>
References: <cover.1685887183.git.kai.huang@intel.com>
         <5aa7506d4fedbf625e3fe8ceeb88af3be1ce97ea.1685887183.git.kai.huang@intel.com>
         <20230609132301.uvvp27yr5kpenl6f@box.shutemov.name>
         <58f34b4b81b6d6b37d3386dec0f073e6eb7a97ff.camel@intel.com>
         <20230612075830.jbrdd6ysz4qq7wdf@box.shutemov.name>
         <4c7effc3abe71aa1cbee41f3bd46b97aed40be26.camel@intel.com>
         <48d5a29a-878c-665d-6ac2-6f0563bf6f3c@intel.com>
In-Reply-To: <48d5a29a-878c-665d-6ac2-6f0563bf6f3c@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CY8PR11MB7747:EE_
x-ms-office365-filtering-correlation-id: c2a0db71-97d7-449c-b7e9-08db6ba84f3d
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Sp/tpPmV2bMXBrzxxUhejTMRUyfWg0GqmrjKjKvo5UET+yWII4BdRGYSEALefUBo1/miHbbSkzNp822+HvvbdsiN3p8eVZqjEY1C53I04p8M+XsuHjZSe/S7hw0jJjiv/zYWwT2werVYjPPJAENnqL3ysH4ogZiyyoL+R8nDAWWkUBp2H5hfbOlFVBCoqVa4U/dyjfu83+tz8BC8aufaKyonsechLSxqX7cKwiXQ/UkG9w8znUK+jXrUyhzSbx+ZBq1GxM2GlQqMGUfnCKqMfYUEBhR60RDvUD4/mXti4Vn7Uwt7HiBz4e6EsdNDAUnJ40dEVH3mEpRBPnF9FUC3DfLI3mz1zUbkyUWuxYPYkTDkE5LQCWK5ztwMMQZfbByoZAXk06oQGPCU6auaZ9/t3Uz7gSmtam8EpR5DRpjiGM43lHcsqCBmOxFcvsQq6Ik8NjYd1fA5YEQlL8UdyI/jNEXV9mxd7jgbHWXtMxynh4Xu1NlZzqK27dROURqFccoRKUMGoFLbYMFfgRI1D39iBsIoLoKwQg5WdCkPD8ZyygQjck57MccrQPBMUmDcmGTZW5FykkZZxOR7N+DYrmfDp9qvAsRejvumPRnTOMMLszQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(396003)(376002)(39860400002)(346002)(136003)(451199021)(41300700001)(86362001)(83380400001)(7416002)(966005)(6486002)(8676002)(478600001)(36756003)(316002)(110136005)(8936002)(76116006)(66476007)(4326008)(5660300002)(66446008)(54906003)(91956017)(64756008)(66556008)(38070700005)(66946007)(122000001)(38100700002)(6636002)(82960400001)(2906002)(71200400001)(6512007)(6506007)(26005)(2616005)(186003)(66899021)(53546011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NVllMnYzNW5DV0xjUGJ3d01UMm92c0NkYy9jVjl1YVlWR2pBMGFkNmhYNmR5?=
 =?utf-8?B?KzZqaU85UXRsRlRFYTlIUEVGM3BXNVVQWHZqdWNzZW9pNExCd1UyU05EV0lm?=
 =?utf-8?B?N3pZdDVmb1cvQy9KQXNpSzI5V3FYc0E3VEtMdDY5eGJpYXpobUs3YVZYcXIx?=
 =?utf-8?B?UElNRFFPUnpmQ01oaTl2Yk11OWJ5Q3BQa3plSlVWUDJlZGtmNkEvY0U5aTRs?=
 =?utf-8?B?bC9tVDdNS3VUTitYdkpWbWlyTysxenhCZSt1RS94U28yRnQwLytyRTBwb1U3?=
 =?utf-8?B?NnM5bWtuaXkxNEZRR3JPcHl3MllMSG5FWVBpK2pDZUZzTGpCQW05c011aHlL?=
 =?utf-8?B?dlQ4L3dXRDZNdTR3QnNuc0V6SW9xOTArbXFpQkRjUkM0RTd2ZGRQa1hKSk91?=
 =?utf-8?B?OGlxM0ZQN3hCZ2dUZCtmVnFzcHVseHI1aWJpZWVaOHFjeEFJTGZIZFRaVUVD?=
 =?utf-8?B?UXBOMUlQU2ErNllwOXIyVG91UldnbU00NUpqWE1uRDdCaFVKMWpNa1pOZWwv?=
 =?utf-8?B?cHFxeDc0eUkxQTMzSUt1SE9zYzNDWk5WVVFFUytFRUFZZEFsWVJ6WnN1dG1V?=
 =?utf-8?B?Q3JrWlJKd25LV3pGODJRZlNMc3JEdkFYeS9mUGk1My9iK1VKUU16NnZ5Vkw0?=
 =?utf-8?B?K0J2Zmo3SEwzRktlUlphWERuS1pQOFM3UXFYaUFEbnlBTzNUbmNBamwvRUY0?=
 =?utf-8?B?WHp6Z3YzN3Fhb2M4NXAwT0dLRFI2MzdUam0vaXFLYlBBemdDMlhZKzJsRGt0?=
 =?utf-8?B?VFRqM0pibFBSQkVBUGF3M2JwcHFNakowV3l4Y2Y3U3l5aGx0TmQ0OVUwd3lo?=
 =?utf-8?B?Tm5ZaVQ4VVh3WVBtb2JuVkFxYlMvK0ZiK0diN2JXRUIrQ2FnVm5JQUt6c1B3?=
 =?utf-8?B?NDI0U3l4QTB6cTV5QjkzWm1XbENrYTh6REF6bzdreTF3bzVHVndRWkRialR2?=
 =?utf-8?B?TnVKRGxQLzl3NWUxcEpyUE9LTyt2aTB0ajhZZ2xWblZvWFphd2FoU25wc3g5?=
 =?utf-8?B?RVhUQkxNQU5hdk0xalREYXptS21aUTNZRVZ1YWtVeWgvSUh5MzhsTnVxQThy?=
 =?utf-8?B?dnRVWVQ0UVZUSXBlODUvTVJwRHpMNzFrUDFGTVpHaWZKZHpRSEEwSE5RMXdR?=
 =?utf-8?B?cXo5a0hsb2tqL3V3aTdORjAvOWo3UXdpY045cThqZkQxTXU0MnRoZE9MamZO?=
 =?utf-8?B?ZFA1OThha3lXalE2V3RteVUxa0R3NjZhdmVCRjArV3lKVGc2VWdqdlBzQUtx?=
 =?utf-8?B?MDY2NTFjL0xHTUJoVGtYZ1R5Z2hFNVZVQnVXeDI0S21oWEdIaXA4L1hwV0Jk?=
 =?utf-8?B?SkNjQ2hRRW1GSitnNVhMSWJ5bnh1MWo5N0hKay83N1kxRlNpaE5vTmxZV2Rr?=
 =?utf-8?B?a0tPeHJOQkNsQll6QlFqUnFyL21ndERPNm0rUU1kbkdWS2ljY0RsTUdOUTl0?=
 =?utf-8?B?czBRdXJkdk9xSkdndHhOZWlKOHVHeCtBMnpsN2hHelcwblNvcDNNbHZ4L0NT?=
 =?utf-8?B?bFY2VUxsNFErRmpmc1ZmaFdIcllBVWRjOHM5MlpvVHFRWnZaWUh0NklNMzVh?=
 =?utf-8?B?L3EyN0szb0lUWTZMR3dnc1d6Ly81NkNLWWFlWE9JYmNsUHYrWkFrWWRXemFN?=
 =?utf-8?B?dnVySHc5VkpMYlBhNmQ4K1ArRXhoOU9PeGxRa21EQUtjem1rMkE0T2xmeTNu?=
 =?utf-8?B?Wmo4RkcyZThBVnpiWGtNY1dkWGVQVEVuTWFKZGJQUHVvdGxkcUFxZWZOWW40?=
 =?utf-8?B?dnA5Yy9nUkZBbjJRU1drOFRLYXptejdid3UwTzdCWVNFU2lYcUVnNHluNTN1?=
 =?utf-8?B?ZTBHMjNWbUFSUVo5cGZiVjJISENjVkdZMS9Xakx1WkJERjhQVFNlNmJCM24r?=
 =?utf-8?B?cHdnM0NvK1pKeXhVbytXREJVbTdmdTN4bHBuSzQ4STVtQ3ROZ1dEU3dubldD?=
 =?utf-8?B?Y01NV244QVlrYTRaRWxXb2JEbUN1RHgrMTFTRGtIUWNUaDlSb3k1REZ2SzFt?=
 =?utf-8?B?d3pBSjB0OFc4QUlUaGFnd0Y3UVRhbkdYMnpZcktOUEpsb2lSTVh4V2tNR0hy?=
 =?utf-8?B?N1hGMVExaUJKblhOK055SVc4bURhUXp0N1lmZHV6V1FYYXZwNTZDZllLS3ND?=
 =?utf-8?B?Q0t3SlhlMlp5VWpMeDEwMkY4clNqNHI2MGllQjl4d2FWWHhNbnNpSklSc1Rm?=
 =?utf-8?B?T2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EB403D71154F074F94C7180C8B7EA488@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2a0db71-97d7-449c-b7e9-08db6ba84f3d
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2023 00:51:23.1097
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +axXPLG9ntquGIVQesDo6Hle/T7QoPiEOvM9E5tX4yvVq5M0LuBIuMv0L5PIQvm8ieCR4WQEDBE4b9co46KN6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7747
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

T24gTW9uLCAyMDIzLTA2LTEyIGF0IDA2OjQ3IC0wNzAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gNi8xMi8yMyAwMzoyNywgSHVhbmcsIEthaSB3cm90ZToNCj4gPiBTbyBJIHRoaW5rIGEgX19t
YigpIGFmdGVyIHNldHRpbmcgdGRtci0+cGFtdF80a19iYXNlIHNob3VsZCBiZSBnb29kIGVub3Vn
aCwgYXMNCj4gPiBpdCBndWFyYW50ZWVzIHdoZW4gc2V0dGluZyB0byBhbnkgcGFtdF8qX3NpemUg
aGFwcGVucywgdGhlIHZhbGlkIHBhbXRfNGtfYmFzZQ0KPiA+IHdpbGwgYmUgc2VlbiBieSBvdGhl
ciBjcHVzLg0KPiA+IA0KPiA+IERvZXMgaXQgbWFrZSBzZW5zZT8NCj4gDQo+IEp1c3QgdXNlIGEg
bm9ybWFsIG9sZCBhdG9taWNfdCBvciBzZXRfYml0KCkvdGVzdF9iaXQoKS4gIFRoZXkgaGF2ZQ0K
PiBidWlsdC1pbiBtZW1vcnkgYmFycmllcnMgYXJlIGFyZSBsZXNzIGxpa2VseSB0byBnZXQgYm90
Y2hlZC4NCg0KVGhhbmtzIGZvciB0aGUgc3VnZ2VzdGlvbi4NCg0KSGkgRGF2ZSwgS2lyaWxsLA0K
DQpJJ2QgbGlrZSB0byBjaGVjayB3aXRoIHlvdSB0aGF0IHdoZXRoZXIgd2Ugc2hvdWxkIGludHJv
ZHVjZSBhIG1lY2hhbmlzbSB0byB0cmFjaw0KVERYIHByaXZhdGUgcGFnZXMgZm9yIGJvdGggdGhp
cyBwYXRjaCBhbmQgdGhlIG5leHQuDQoNCkFzIHlvdSBjYW4gc2VlIHRoaXMgcGF0Y2ggb25seSBk
ZWFscyBQQU1UIHBhZ2VzIGR1ZSB0byBjb3VwbGUgb2YgcmVhc29ucyB0aGF0DQptbmVudGlvbmVk
IGluIHRoZSBjaGFuZ2Vsb2cuICBUaGUgbmV4dCBNQ0UgcGF0Y2ggaGFuZGxlcyBhbGwgVERYIHBy
aXZhdGUgcGFnZXMsDQpidXQgaXQgdXNlcyBTRUFNQ0FMTCBpbiB0aGUgI01DIGhhbmRsZXIuICBV
c2luZyBTRUFNQ0FMTCBoYXMgdHdvIGNvbnM6IDEpIGl0IGlzDQpzbG93IChwcm9iYWJseSBkb2Vz
bid0IG1hdHRlciwgdGhvdWdoKTsgMikgaXQgYnJpbmdzIGFkZGl0aW9uYWwgcmlzayBvZg0KdHJp
Z2dlcmluZyBmdXJ0aGVyICNNQyBpbnNpZGUgVERYIG1vZHVsZSwgYWx0aG91Z2ggc3VjaCByaXNr
IHNob3VsZCBiZSBhDQp0aGVvcmV0aWNhbCB0aGluZy4NCg0KSWYgd2UgaW50cm9kdWNlIGEgaGVs
cGVyIHRvIG1hcmsgYSBwYWdlIGFzIFREWCBwcml2YXRlIHBhZ2UsIHRoZW4gYm90aCBhYm92ZQ0K
cGF0Y2hlcyBjYW4gdXRpbGl6ZSBpdC4gIFdlIGRvbid0IG5lZWQgdG8gY29uc3VsdCBURE1ScyB0
byBnZXQgUEFNVCBhbnltb3JlIGluDQp0aGlzIHBhdGNoICh3ZSB3aWxsIG5lZWQgYSB3YXkgdG8g
bG9vcCBhbGwgVERYLXVzYWJsZSBtZW1vcnkgcGFnZXMsIGJ1dCB0aGlzDQpuZWVkcyB0byBiZSBk
b25lIGFueXdheSB3aXRoIFREWCBndWVzdHMpLiAgSSBiZWxpZXZlIGV2ZW50dWFsbHkgd2UgY2Fu
IGVuZCB1cA0Kd2l0aCBsZXNzIGNvZGUuDQoNCkluIHRlcm1zIG9mIGhvdyB0byBkbywgZm9yIFBB
TVQgcGFnZXMsIHdlIGNhbiBzZXQgcGFnZS0+cHJpdmF0ZSB0byBhIFREWCBtYWdpYw0KbnVtYmVy
IGJlY2F1c2UgdGhleSBjb21lIG91dCBvZiBwYWdlIGFsbG9jYXRvciBkaXJlY3RseS4gIFNlY3Vy
ZS1FUFQgcGFnZXMgYXJlDQpsaWtlIFBBTVQgcGFnZXMgdG9vLiAgRm9yIFREWCBndWVzdCBwcml2
YXRlIHBhZ2VzLCBTZWFuIGlzIG1vdmluZyB0byBpbXBsZW1lbnQNCktWTSdzIG93biBwc2V1ZG8g
ZmlsZXN5c3RlbSBzbyB0aGV5IHdpbGwgaGF2ZSBhIHVuaXF1ZSBtYXBwaW5nIHRvIGlkZW50aWZ5
Lg0KDQpodHRwczovL2dpdGh1Yi5jb20vc2Vhbi1qYy9saW51eC9jb21taXQvNDBkMzM4Yzg2Mjky
ODdkZGE2MGE5ZjdjODAwZWRlODU0OTI5NWE3Yw0KDQpBbmQgbXkgdGhpbmtpbmcgaXMgaW4gdGhp
cyBURFggaG9zdCBzZXJpZXMsIHdlIGNhbiBqdXN0IGhhbmRsZSBQQU1UIHBhZ2VzLiAgQm90aA0K
c2VjdXJlLUVQVCBhbmQgVERYIGd1ZXN0IHByaXZhdGUgcGFnZXMgY2FuIGJlIGhhbmRsZWQgbGF0
ZXIgaW4gS1ZNIFREWCBzZXJpZXMuIA0KSSB0aGluayBldmVudHVhbGx5IHdlIGNhbiBoYXZlIGEg
ZnVuY3Rpb24gbGlrZSBiZWxvdyB0byB0ZWxsIHdoZXRoZXIgYSBwYWdlIGlzDQpURFggcHJpdmF0
ZSBwYWdlOg0KDQoJYm9vbCBwYWdlX2lzX3RkeF9wcml2YXRlKHN0cnVjdCBwYWdlICpwYWdlKQ0K
CXsNCgkJaWYgKHBhZ2UtPnByaXZhdGUgPT0gVERYX1BSSVZBVEVfTUFHSUMpDQoJCQlyZXR1cm4g
dHJ1ZTsNCg0KCQlpZiAoIXBhZ2VfbWFwcGluZyhwYWdlKSkNCgkJCXJldHVybiBmYWxzZTsNCg0K
CQlyZXR1cm4gcGFnZV9tYXBwaW5nKHBhZ2UpLT5hX29wcyA9PSAma3ZtX2dtZW1fb3BzOw0KCX0N
Cg0KSG93IGRvZXMgdGhpcyBzb3VuZD8gIE9yIGFueSBvdGhlciBjb21tZW50cz8gIFRoYW5rcyEN
Cg==
