Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4ABA727316
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 01:36:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233167AbjFGXgo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 19:36:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbjFGXgl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 19:36:41 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4574226A1;
        Wed,  7 Jun 2023 16:36:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686181000; x=1717717000;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=oR6KCC893Q/QumsV9+FlpPXFhPRYAEdi+hMui3K52jM=;
  b=mIQG97oSA9jqHlqc4ItVKNghkTvGppFCio+VGEIVaOtzmcxk+CUB8s3N
   uAnK0nFdCL4JOv3uWPEq1bAr9zvFSYJj/T+FxWlA3fUOlff3ubou+7lrq
   asaspEXcEf0BXqFjHbnuuAijQuhXT9Pgwppy+3TVnqYS+ZrDH7nPqG4US
   kPvWVFAAuCEWaAMIF+8mCzuH126Mv2fsdDx8V08hycQToDXkIJAOKmW9C
   8pjLsHbj988ntL9k04jMtImLhyTwrgrIUAT5gCztVYxG1ekjDYFYX/fUe
   AHHjUVqMP3x3525SSaXHyO5TsVTBWz7Hyvalh2SO7cDmfl4xTzXjABnvZ
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="337499340"
X-IronPort-AV: E=Sophos;i="6.00,225,1681196400"; 
   d="scan'208";a="337499340"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2023 16:36:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="687169672"
X-IronPort-AV: E=Sophos;i="6.00,225,1681196400"; 
   d="scan'208";a="687169672"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga006.jf.intel.com with ESMTP; 07 Jun 2023 16:36:39 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 7 Jun 2023 16:36:38 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 7 Jun 2023 16:36:38 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 7 Jun 2023 16:36:38 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.42) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 7 Jun 2023 16:36:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mTon0b7eHxKrLHNTDGVPf9/AlmbQU6Xc+maUAR2oS4DGgXYipehKsmnG2rVvvRecPehgv4JwUt+qnR4N9CdAZmWG9l8ullCEyhypyXkBhkY1Rs+DloqbeDMnB+pFtOt90bHS/S/OShQ1hU0fHtIDnh/cPAXqScSR9HBxSkO8Cqdhhps6njlrcPNYtHxHKUGkjBOl6s+JEA//IWBNYoiPuyJw2UcK0PDKsJ+SPKbjuk64bwq8f+CywMh8WIrXOD0ZVVkmYhBbTA4sB9oGeslBjMpV5CdJXM7aOpq72/eLZ/w+c0r6iaQIUpE6ZYKdgLJA3S/yTK5QHDMFnQSpRN8d0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oR6KCC893Q/QumsV9+FlpPXFhPRYAEdi+hMui3K52jM=;
 b=L/B6P7D+uEAZTmCcO2px21qoZeUqns/4vDF48+2iszpcsOeM3IKVycQB8BwqvJBFm83/b+z0nUlWx9Ov7Lvikdsh4Agv2PztvCafYu5uUAtorq6ikW9EoeFwMkhr6IpqFnC8fdzfpRseJQEfTf7CoaxxLKqI9ueNyQu+W9y38MAHZ+K4OuuNp/on56VXAwUNK+6UBPLBHtxkHlTYkJZT9daEVQuwtZDuYoFGYq7MAVCx4bWBZ6DcWvJrlmZD9PUE5siDrq1fYEKT0wB98wgIenQ2BFk8MfW4i5Hu6fFgk3V4R6F4Kp0Qx4GLqKd3r4tAXhJMBvNzVqOMLGie+uIvaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SN7PR11MB7440.namprd11.prod.outlook.com (2603:10b6:806:340::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Wed, 7 Jun
 2023 23:36:35 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6455.030; Wed, 7 Jun 2023
 23:36:35 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Luck, Tony" <tony.luck@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v11 06/20] x86/virt/tdx: Handle SEAMCALL running out of
 entropy error
Thread-Topic: [PATCH v11 06/20] x86/virt/tdx: Handle SEAMCALL running out of
 entropy error
Thread-Index: AQHZlu+v0XNcOtw04kG29tp3PFLJcq9/dgwAgACN3AA=
Date:   Wed, 7 Jun 2023 23:36:35 +0000
Message-ID: <c05384781a900ec5f36809d3036f7af64ef3c997.camel@intel.com>
References: <cover.1685887183.git.kai.huang@intel.com>
         <9b3582c9f3a81ae68b32d9997fcd20baecb63b9b.1685887183.git.kai.huang@intel.com>
         <1e58e3df-ae9a-607c-cfc3-4f3d033ed531@intel.com>
In-Reply-To: <1e58e3df-ae9a-607c-cfc3-4f3d033ed531@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SN7PR11MB7440:EE_
x-ms-office365-filtering-correlation-id: b0bc664c-4a47-46bd-fb70-08db67b0084e
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lM+obc6fUvxVwXtFgfFhi92AlLxqTgRdRb/5rndT9zBVySVvdVMx+RwHab/Kqjvaf6S3WfNBPxYuP4/hknXLUPH3maYCmw/z/xqL1OcvkY4q6pFOOObb6DQ4Ts4Ex/EdqGpD9cBQLvP9/t262ZYMMA6BSq1XEO6HEsGKqqHiSI0zLZyphobEl+TYZzE2ERAqaXQGxVYSO2hSKu/MPlAc5UQVaqlhXFzc+4d0xX+M4kzyuXFXoWD2B2hcbpcYw5/EVUKlFzqZFNJzCMeqp/keFdKkixxb1sTIHZb9ou2qLGQGX/FnG4cFwgDO4QgQYPLs93FQRTCDZ5yi5BqaZCIUe7tHVbr1IPStlvssXx5mqfKX79N1MwVR2l/MaMgwN1//EkzOf1Mv6I+Zslcfp87maoKlW0ccr+dPSkZeiIw9Ni3OKvZ1VcisginSkZ+zviq+kNbXWQGEHkPg0vkI/LNMpYf1a4f6CYIblnutfQp1fltk6RNi6uQRY9GThDpWbPmg3fhFQLlUz1OcEuvdnkMtdFELRfJT25joMQ01y64ZaOuS+plJ851H/8zMfVzbK37bJy8bYKnYzZ0YVcbQOBZy8mgUxSDgLGxDDNhupuAx6NoMs5Nhd6LpBWodOyN9FxwJ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(136003)(346002)(366004)(39860400002)(396003)(451199021)(2906002)(478600001)(38070700005)(41300700001)(2616005)(86362001)(82960400001)(38100700002)(71200400001)(122000001)(53546011)(6506007)(186003)(6486002)(26005)(36756003)(7416002)(316002)(76116006)(91956017)(5660300002)(66556008)(4326008)(66476007)(66946007)(64756008)(66446008)(6512007)(110136005)(54906003)(8676002)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Tkp2S24wUkw4enBsOFNlVGNPV05wbjlOR0J6NFBaSGtsOFRKSjJZVzlVODVG?=
 =?utf-8?B?NTk2eWRPN1paTHp6eHlFMGhkSHFPbks2Y2V6M0RvWnVvWURtWFljNTZpOUlE?=
 =?utf-8?B?eWVCWS9ubUJQQkozQ1BYek4rTmg3Q0EzUkZnMGRoeUl4d0VGZFUyUExqM1pM?=
 =?utf-8?B?eWRlbU8xU1I4NjRqZ3pOQVBoY2J2ZktROENyQnFkanFZK0Fmb211Z3dCV3or?=
 =?utf-8?B?S3hIcHZ0cU9scVJBaGFGdVFmSkErMjdBOWt4MFpxVDdqQ2VoSUJGaWo5YnZI?=
 =?utf-8?B?U3RmMXYyU3hCdGZock5ybHhtRU4za1FFbU9lRG1XckZaeG9aMjBYM3RXNE16?=
 =?utf-8?B?TVY3eWhTYTNhdkZORSttME5QQVhBclhiVVNSM01TUDVIVWJQaGRZa2ljL0R0?=
 =?utf-8?B?bVdUWXgyQmprWUxJY3VwVk9EcGlMcVgwNksramhUSVlCSnAvRGxNYjVaTzhk?=
 =?utf-8?B?OG1Yb0ZkVlJZSXVDY2tuakZJY2pNdDNRSTdoYjNlakVBd25mUERCcVhBYndQ?=
 =?utf-8?B?M1NPRjFobHNsSWp2WTFIcDNudmZhWEo2Q3BtMWZPSHNBVzBkcmQzVmY0Zzls?=
 =?utf-8?B?ZmpjMm5KdDZCN3dHSTEzdC9NMUIzak01ZXVaVmw2T3M0R1Z4NWlkODNwTjhj?=
 =?utf-8?B?RGxSN3l0OTFNNnVPdHNpZzh6VGRDYU1PMXV5MmRSK1JLWVRWSG9HK2t4ajkv?=
 =?utf-8?B?L05kWjRzNDlnOHdVVkJUbWJEcml3dm0xOFdzUk5TTXEwUzRvSTNVSnZldDB2?=
 =?utf-8?B?K2dpZUIycGV3T09DeVh2bTN4RXE2aEROcHVRUHczbmlOcW9lQXBFNEIyOU5S?=
 =?utf-8?B?czZSalRzcFczMFRkYlU0L0MrM3dyODJBN2l6T3daOEhDQVU0QXdPRlRCMGdX?=
 =?utf-8?B?bXhSak8zakN3VlMxd3paV0NLaU1ibHRNazg3QzlaR0Fwc1dQcGN4RFFVYnll?=
 =?utf-8?B?eDhRNjNtNmRFcUQ2V3ZoeXVCSVpyU3RvSnRmQWhNTlN3Q2UzbFI5bk9DSm9B?=
 =?utf-8?B?bHh1MzdQa2hKVTZUQ0pZUy83eVphWUw5eXMwOWV1TXdsaHhTa3NIODZDaHBT?=
 =?utf-8?B?QnZsQU9uUW04YUw1RVRHVHAvRSsrSDhGb1M0NGdhdUpWN2h6a0VsNEtmdS9Y?=
 =?utf-8?B?SUdKRkhuTTIxL1FHajEvbnZUNEFNZElKcXlrMFF5VjRINlZLdmdtTTJPcGhU?=
 =?utf-8?B?Nlg1S0VraUVua2tVL2hDeVZuMWtTTEx6VVFQL3llUWgzUElJVTl6ejhrZndk?=
 =?utf-8?B?elpwTG1yRXB3ZmIyMi8zN0tUaEo1Mi9QL3psS2ErenRoTWdrZnpJQVVSeHYx?=
 =?utf-8?B?cE5mNVdsOEhCNjBDTU9XMkhFdmNKWmtzS0RVdEhubS9zdzBZTlJMK3hET1F6?=
 =?utf-8?B?UURRT1lUdjU2cTZzenorWVpqZkV6NmQ3L0w1ZXl2RG8vR29nalZnYUZNdkt2?=
 =?utf-8?B?M090ejlWL2ZoOXgxVERlUHU4aFlLUTAzMmV1UTB2UG1TSjFZNDlhYTNBZXFq?=
 =?utf-8?B?MENFZERzNUpFRWFnQlJoL09jQXh5dlkyaHErUXViclNOcDFVdE1PK3ZUbEFv?=
 =?utf-8?B?VURBeDBUbHlHbk0xYm85YjVvTUtBTHJGUWZmOTF5VERvSjVzSWNtUzhpVG11?=
 =?utf-8?B?WjNJS2wyZFpwN1hBelJwU2p1UGxHZWNBakJHbUttM1hZaUF1SXVBemNOOXBa?=
 =?utf-8?B?YzNZbExNZW5QL0VkS01ubXBTaHVUWm1ocytxWTZxZFpuNWhxb0FMeEMyOHZ3?=
 =?utf-8?B?RGpyZG9zeUg3NE5yUkhVVmlPQ0ZBN1luT3JaTUtLc201dmRCQ0NWUTFaRWl5?=
 =?utf-8?B?MGF4Z2FEdENqZm1NOEJGRWptRnMzT0pjMndlWnpqZkJ6WTBCZi9oYW5OaVN4?=
 =?utf-8?B?NDQ3OVo4VFBQdWlocHZudnZFSVc0eSt1Q0xaVkN2RGlnQ0RLb2FpWSsrOUVa?=
 =?utf-8?B?N1cwci9rdzRxY0NadXRieG5UWUh6NHVFNXJ5VURPZGZZeHN0ZEFxTmhGUFdk?=
 =?utf-8?B?TytYRTdlQi9PMW5ZeW1RWXJGeEtNSjZXdkxLYk92NUhJUVVQYTlweXZQcWZF?=
 =?utf-8?B?Z2Fza2tEMmxoMkIxZjN6MXlvZitaVjhIdGVKS0JWQzJaamN5Z2FLTEVqRUJF?=
 =?utf-8?Q?2eScQKRk6Iuyy0Go5cEpK7izw?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D8F1E4EFFBF00741B1C56781AE91DB8E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0bc664c-4a47-46bd-fb70-08db67b0084e
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2023 23:36:35.4160
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5Ec+xIDkfdjfaLvE6OZim+V9jNrbYL5vYhN2an4EfdWBCAPIfZR1/q6priaruvT3Ri7e0Vr/RmQJK6PL8mR7mw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7440
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

T24gV2VkLCAyMDIzLTA2LTA3IGF0IDA4OjA4IC0wNzAwLCBIYW5zZW4sIERhdmUgd3JvdGU6DQo+
IE9uIDYvNC8yMyAwNzoyNywgS2FpIEh1YW5nIHdyb3RlOg0KPiA+IENlcnRhaW4gU0VBTUNBTEwg
bGVhZiBmdW5jdGlvbnMgbWF5IHJldHVybiBlcnJvciBkdWUgdG8gcnVubmluZyBvdXQgb2YNCj4g
PiBlbnRyb3B5LCBpbiB3aGljaCBjYXNlIHRoZSBTRUFNQ0FMTCBzaG91bGQgYmUgcmV0cmllZCBh
cyBzdWdnZXN0ZWQgYnkNCj4gPiB0aGUgVERYIHNwZWMuDQo+ID4gDQo+ID4gSGFuZGxlIHRoaXMg
Y2FzZSBpbiBTRUFNQ0FMTCBjb21tb24gZnVuY3Rpb24uICBNaW1pYyB0aGUgZXhpc3RpbmcNCj4g
PiByZHJhbmRfbG9uZygpIHRvIHJldHJ5IFJEUkFORF9SRVRSWV9MT09QUyB0aW1lcy4NCj4gDQo+
IC4uLiBiZWNhdXNlIHdobyBhcmUgd2Uga2lkZGluZz8gIFdoZW4gdGhlIFREWCBtb2R1bGUgc2F5
cyBpdCBkb2Vzbid0DQo+IGhhdmUgZW5vdWdoIGVudHJvcHkgaXQgbWVhbnMgcmRyYW5kLg0KDQpU
aGUgVERYIHNwZWMgc2F5cyAiZS5nLiwgUkRSQU5EIG9yIFJEU0VFRCIuDQoNCkRvIHlvdSBwcmVm
ZXIgYmVsb3c/DQoNCkNlcnRhaW4gU0VBTUNBTEwgbGVhZiBmdW5jdGlvbnMgbWF5IHJldHVybiBl
cnJvciBkdWUgdG8gcnVubmluZyBvdXQgb2YgZW50cm9weQ0KKGUuZy4sIFJEUkFORCBvciBSRFNF
RUQpLCBpbiB3aGljaCBjYXNlIHRoZSBTRUFNQ0FMTCBzaG91bGQgYmUgcmV0cmllZCBhcw0Kc3Vn
Z2VzdGVkIGJ5IHRoZSBURFggc3BlYy4NCg0KSGFuZGxlIHRoaXMgY2FzZSBpbiBTRUFNQ0FMTCBj
b21tb24gZnVuY3Rpb24uICBCYXNlZCBvbiB0aGUgU0RNIHRoZXJlJ3Mgbm8gYmlnDQpkaWZmZXJl
bmNlIGJldHdlZW4gUkRSQU5EIGFuZCBSRFNFRUQgZXhjZXB0IHRoZSBsYXR0ZXIgaXMgImNvbXBs
aWFudCB0byBOSVNUDQpTUDgwMC05MEIgYW5kIE5JU1QgU1A4MDAtOTBDIGluIHRoZSBYT1IgY29u
c3RydWN0aW9uIG1vZGUiLiAgSnVzdCBNaW1pYyB0aGUNCmV4aXN0aW5nIHJkcmFuZF9sb25nKCkg
dG8gcmV0cnkgUkRSQU5EX1JFVFJZX0xPT1BTIHRpbWVzLg0KDQo+IA0KPiBSZXZpZXdlZC1ieTog
RGF2ZSBIYW5zZW4gPGRhdmUuaGFuc2VuQGxpbnV4LmludGVsLmNvbT4NCj4gDQo+IA0KDQpUaGFu
a3MhDQo=
