Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 952DF72B5A9
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 05:07:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbjFLDHA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 11 Jun 2023 23:07:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbjFLDG4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 11 Jun 2023 23:06:56 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 782C0136;
        Sun, 11 Jun 2023 20:06:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686539212; x=1718075212;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=0/5rc4ZOuvdgWUWZKaXR2Nn7ih+qQIQXMxd/IwqxbG4=;
  b=cUS+NTPJRGAO8K0lIAZFeXTg6aqx1cgoTaSIgC1lh6BR+tPGdNBvkoHc
   5Jzo7kzaSF1pqEM7V43DuSV+zQCewModvEk9pRrxalfm2EgSVcY4Fzw4t
   09rFFACGLW0jHrirrmM1d4s5948a6RCo19mQe8r5LzZe3xgwaCQb/QPKe
   /hkyhuKIfxiTLJTfmRyh+GKilSixX7NYPXt2K9b1QPGwlAGRpFxOn3m63
   fI8awekn4uK3MD88egCb9Ihk+dxMcrMLlsIbjfB7WjgM3RxqwpfnsqwW2
   3l7z+NrPlrljC6gVbWIOdkLt9wLT2Fnjjr2vIn1ufKx7AFwusFHY/kZCT
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10738"; a="444303112"
X-IronPort-AV: E=Sophos;i="6.00,235,1681196400"; 
   d="scan'208";a="444303112"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2023 20:06:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10738"; a="1041170485"
X-IronPort-AV: E=Sophos;i="6.00,235,1681196400"; 
   d="scan'208";a="1041170485"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga005.fm.intel.com with ESMTP; 11 Jun 2023 20:06:51 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sun, 11 Jun 2023 20:06:51 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sun, 11 Jun 2023 20:06:50 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Sun, 11 Jun 2023 20:06:50 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.170)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Sun, 11 Jun 2023 20:06:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vadk2fK8Ee21sFwFkDegiIsVc0xftISrNbzWgvzlpoK/Y+pGyea/2fyMkjpHBjlECnev1fUppXvJAjYt3P6Smi13Skz+COZQnMpFOQX4/k0l+RJwgi+2RxWPIW2dQoqZ5SA1vvAmjn8TvwAm1riLPPJRsv+qW+I+pkYVZqyW1lMihsgdl5uEHt2DTr0bfVs9f/MIMP2CxfddJbFSQvfm7wwijv04pJksvTwNea/lkOA813yZqHCftnL7u62FcTnmSAMZzzjzUqUA84aUENbNDgJVES3gMqqYC7d1qpVvzbnEKYRmPVwqR/unDLGIDmN/Sl1hr0e4z+ztdjvHj+NbQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0/5rc4ZOuvdgWUWZKaXR2Nn7ih+qQIQXMxd/IwqxbG4=;
 b=iUyeiktIn6/zIWnLs1CFRCo1bNbNlgOy3j7yRcWm63h5FFjTl/rtvZdTmDgUQ0+i+3RXEOPHxed19Liu9FcmjKLq0qzZ9Y2fi1Y/BJKCY149hqxfxVHC1JqytD8+sOgOrFbAS1PxjpsUV7q7tyG6HNGFx7lII3PIQwMopo+aZYCJzn2L/JFaYo3Wa/phJASXL999EmPPV0UO0SOkg37YYG7XOUgOZYtRadIeefwbyv3QOsOnZ6FkPXWPzaMlU3AZyaPgtQ9xlqiV+ozofOy3Qy2vLcHiTPSaiedZB/GwrInAcWzbPfdNJgWaIz34oEloz5NJHr1VRU7obDvUhTTPpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA3PR11MB8004.namprd11.prod.outlook.com (2603:10b6:806:2f8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.38; Mon, 12 Jun
 2023 03:06:48 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6455.043; Mon, 12 Jun 2023
 03:06:48 +0000
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
Subject: Re: [PATCH v11 18/20] x86: Handle TDX erratum to reset TDX private
 memory during kexec() and reboot
Thread-Topic: [PATCH v11 18/20] x86: Handle TDX erratum to reset TDX private
 memory during kexec() and reboot
Thread-Index: AQHZlu+7CCb5RYnzE0SLr6ZWSpg4cK+CfSeAgAQK0IA=
Date:   Mon, 12 Jun 2023 03:06:48 +0000
Message-ID: <58f34b4b81b6d6b37d3386dec0f073e6eb7a97ff.camel@intel.com>
References: <cover.1685887183.git.kai.huang@intel.com>
         <5aa7506d4fedbf625e3fe8ceeb88af3be1ce97ea.1685887183.git.kai.huang@intel.com>
         <20230609132301.uvvp27yr5kpenl6f@box.shutemov.name>
In-Reply-To: <20230609132301.uvvp27yr5kpenl6f@box.shutemov.name>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SA3PR11MB8004:EE_
x-ms-office365-filtering-correlation-id: 76c06d77-b6f4-418e-b26f-08db6af20fb6
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QeO3fzPNo2loIFo26jX/HCpjPEncukNo9L7WmuHIOw9Fqef3dfGtufO5RldoMN+BU95Am6kSa1PuU3ytHN04HK0CZQ7fIRDJbc6OVSDQn+FYSEagi6g8ZQBPEMgeBlLnT4HmMj3Bhlg/X45Unq1HKs0ptAw6oFr+sALejy2N95H2avGutSmyeZoSSZSs6FfjsqsqliHdlChIfGIAltFSw/FtWetfez8NKZ1hKeG7gaE/BSyGsHFkpqg5lqve0QOJ6JJutx/bHmkVNhDJmgAMBx6AYjJOTapU9uC3whNZzdsmZ+o0FaL9jtrXfBGSFYEt3KQRL5iwgxemJFOsFROji96dyuhxuj95Oz8DXK1Tn3v65wFHisvJYLtDMDIsvRbRywA0QnA+wFgiKl/cLi3w4kds/FZw359/yi2/xr2CUltUp+yOuKXoI9CMkIwO4/rlnldZxUBL8uu0VfKZ206clXrMCroIyA92nqwEATDBfyKgXprq1C4q1tv2QG4EtrPy5EF8cz/+vV69VU6cz8NK6Fswvi9xI/dcEwNuX8VgDx9ibBBlLwuPehVs7bBIXjFh/04qP8j91rOKBBZQEcLPO8tVlyYyOaG9lIA6v9VlWwjd53EvL5mf4f8g4L+pUcSc
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(136003)(396003)(39860400002)(346002)(366004)(451199021)(5660300002)(316002)(478600001)(2906002)(41300700001)(54906003)(7416002)(71200400001)(66476007)(91956017)(8936002)(66946007)(8676002)(4326008)(76116006)(66556008)(6916009)(66446008)(64756008)(6486002)(26005)(6506007)(6512007)(2616005)(82960400001)(186003)(83380400001)(36756003)(38100700002)(122000001)(86362001)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SzVBdXROcUNLcndjR0hCY0ZSdUFVdHJCNmcvMmE2NjhUL0Ryeks2QkpNTXZl?=
 =?utf-8?B?VEtkaUVCOS9CWWY3ek1NYVQ1MVhWQU5IMnV2dFlVR1UyMnpLekE3K0FQTHl0?=
 =?utf-8?B?RzZmT1NNRWFJUVUvalBCODhyUVlUY2pORER4YU9IYm9ieFl4TVplYXk3L2V0?=
 =?utf-8?B?QkorNUNDa01vd0tKUTQvb3RBVUZ5MUVndEJMT2syN1lsdDk5RWFqdEZsS2FH?=
 =?utf-8?B?Zkk1Vk1oWkpoV3MwVmIyZ0F2MnNPRFd1d1pjRlhwSFg2d2F5QVl5UmxBL2N5?=
 =?utf-8?B?NlllQ1ZtZ0d2ZmNjY1k1M1I1TlNPWXYxWTVOeFcreThVS0JGcDR4TWsxYWZq?=
 =?utf-8?B?RE9yTVB0TEpkdlk4SjdLTnl3bEpWTkRGMFdoenJWSDhrOFVyREZWdjJSdkdC?=
 =?utf-8?B?MXpSakZUb1VXelVRMFRZWXpjemIzbmdWS0pjbHhqZ1B6eUJOVlQ5MGN3RnAx?=
 =?utf-8?B?d2tIRTJTbmlRM2xZbzlHNW5LWUpBd2NMTjBFcnJKcGpzR25LOG9qcmU2S0U1?=
 =?utf-8?B?YnFTOGZ3dEk1ZGNTOHJTVGxUbloyWG1UWUZVWk1tRFEwM2JoeUR5dkNLVnNR?=
 =?utf-8?B?UEtVNnNlSzdqeVk4Q0VFajhZaWEvY1o4c1BLc01lVEFLRzhTdFo1Uk9aSUNF?=
 =?utf-8?B?ZHNNQmZXRStYVHVVYVJNVEdqTnh2Y0UweGpJWUFlQnlwdUdFNVY0NEZkOUh3?=
 =?utf-8?B?bkRxWkRreWVPRThzR1Bsc2FZNzFkY0dxRlp5SDhWWmYyRVVnbVNHZzZqcWwx?=
 =?utf-8?B?YmNHZDlKeVAvWjd3bUpjYlVqR214ckpENGRYMCtRaVMyZHNsTnJVbGM2bDhi?=
 =?utf-8?B?czNNeFEzTTFoSzY5REloUkp4U0dueU1RNDE4L01HTDV2d012bEhvSlVGVjhs?=
 =?utf-8?B?MHhUSkpYQkdPc2c5REpYQjdrdVlwbDh6SXBYWGhFVEZWTWNSVFRvN2l6bjVG?=
 =?utf-8?B?RkRoek94YUNWVW13aWFQT0dWWWJvRm94M1k1LzJsUlF6emw3cUkyb1l3c3dN?=
 =?utf-8?B?RG4rcVhTL0NFSFFXdm4wc2E1Y3UzQ1dmZXBLV2hSK25qTTZ0WUFTTVdxQWZw?=
 =?utf-8?B?a1RHTVpUMWs5dC9oeDJ3dGRKc3o4ZVJsUnVCNTRRU1ZDeHo5M2tNZ2s3NTVR?=
 =?utf-8?B?dGZSTHcwanhUVko2YkZRSlZ3bVlPYW9tMW84SjJDK0FObU0xZU9IejZmSVpW?=
 =?utf-8?B?R0l5dFBPekE5bXNzaWlrbGNJRzZtWXh4MkhpT2swdmkvYmM1bjhnMlBxUTlY?=
 =?utf-8?B?V0Qxa2pUVk9reUc5a1J1ODF1WjBxQysvUVRJNUJwK3RrSWJUaXVISFYwbWN5?=
 =?utf-8?B?cmlXQjhBUlM2Ry9HYVZlZFRzdVZNVWRTRmM1VzIwRDFPcjJxbVpPSzRreVBa?=
 =?utf-8?B?YXh6cVFXWHBHamc1QjFVaWJSMnR5TXN0OEVLNGpsMUZxd1RLRFJjOHZKTUc1?=
 =?utf-8?B?emVJeUY4dE5RcFd4d0N1QldnblVmSXptZFVmQ2EwZ21MQy9mSUtWekYxVzRw?=
 =?utf-8?B?aEp6YlNZd2Vpcnd3L21uQmRIR205NFEzUzlUYUx0Z0dHa1UwRlhhRndPeDA1?=
 =?utf-8?B?U3M2MHE0bVpYc09sWWZjd1d6VTBNak1IM0ROajZaNXU1NjJ5em53WEdYQjBX?=
 =?utf-8?B?YkxXa0p0S0hhbmMvSjQ3Vk52T3U2TXhLNXI1bWt0OGRHYzc2WVNpU2pTOWl2?=
 =?utf-8?B?ajFhTnpVM3BBVjI1UmtoRlhNNlRjWWNYb2cwSUkveDZOMjI2R0diVVc4T0pt?=
 =?utf-8?B?eElHTDFRMHJUSjlkQmllVGNmYXJPU2U0M3JyL29RbUQ4STlXY3krZlljY0l0?=
 =?utf-8?B?TXp6WTF2cCtJSTJ2QlYwV0hyOGZ0Q1EwbWRoNkR5VEh5bWxabmptbjlqSURI?=
 =?utf-8?B?eGt3UkVTeE5WNkpuTjY4RkpxeWZPTklnNGRBZElBOXFmQld0TmdKQ1hQWUFs?=
 =?utf-8?B?OFUrQVpuK2Z6eFhCczdPQkxIZDNqTHVVR2IyaU9Jd3Nzd3dINGpaOFh6bG9B?=
 =?utf-8?B?NUtJenB3d3RmdDAvYXBnZFM1aFJydzIyclc3ckRGYUc4UzBLZmtCNzJxRkc3?=
 =?utf-8?B?ZUFodGhPdEJld3NabVB5REk1ZVd6OU5DeEdvbCs5TDBqK0VocTFnakhYekR0?=
 =?utf-8?Q?KHrQ6ESOnT4Sacv6agVIpNbcQ?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <11A64713248C444CBBF47A021A8A5EA8@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76c06d77-b6f4-418e-b26f-08db6af20fb6
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2023 03:06:48.1063
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xzOBvGdtjoSQ9Rv6LR4hu6w2mnTHD8NC+fysGMFEGUhjPxE0cpLZqye7VlLudaCnOoPYNEvrHLEtjhot6vWFOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB8004
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gRnJpLCAyMDIzLTA2LTA5IGF0IDE2OjIzICswMzAwLCBraXJpbGwuc2h1dGVtb3ZAbGludXgu
aW50ZWwuY29tIHdyb3RlOg0KPiBPbiBNb24sIEp1biAwNSwgMjAyMyBhdCAwMjoyNzozMUFNICsx
MjAwLCBLYWkgSHVhbmcgd3JvdGU6DQo+ID4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L3ZpcnQvdm14
L3RkeC90ZHguYyBiL2FyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHguYw0KPiA+IGluZGV4IDhmZjA3
MjU2YTUxNS4uMGFhNDEzYjcxMmU4IDEwMDY0NA0KPiA+IC0tLSBhL2FyY2gveDg2L3ZpcnQvdm14
L3RkeC90ZHguYw0KPiA+ICsrKyBiL2FyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHguYw0KPiA+IEBA
IC01ODcsNiArNTg3LDE0IEBAIHN0YXRpYyBpbnQgdGRtcl9zZXRfdXBfcGFtdChzdHJ1Y3QgdGRt
cl9pbmZvICp0ZG1yLA0KPiA+ICAJCXRkbXJfcGFtdF9iYXNlICs9IHBhbXRfc2l6ZVtwZ3N6XTsN
Cj4gPiAgCX0NCj4gPiAgDQo+ID4gKwkvKg0KPiA+ICsJICogdGR4X21lbW9yeV9zaHV0ZG93bigp
IGFsc28gcmVhZHMgVERNUidzIFBBTVQgZHVyaW5nDQo+ID4gKwkgKiBrZXhlYygpIG9yIHJlYm9v
dCwgd2hpY2ggY291bGQgaGFwcGVuIGF0IGFueXRpbWUsIGV2ZW4NCj4gPiArCSAqIGR1cmluZyB0
aGlzIHBhcnRpY3VsYXIgY29kZS4gIE1ha2Ugc3VyZSBwYW10XzRrX2Jhc2UNCj4gPiArCSAqIGlz
IGZpcnN0bHkgc2V0IG90aGVyd2lzZSB0ZHhfbWVtb3J5X3NodXRkb3duKCkgbWF5DQo+ID4gKwkg
KiBnZXQgYW4gaW52YWxpZCBQQU1UIGJhc2Ugd2hlbiBpdCBzZWVzIGEgdmFsaWQgbnVtYmVyDQo+
ID4gKwkgKiBvZiBQQU1UIHBhZ2VzLg0KPiA+ICsJICovDQo+IA0KPiBIbW0/IFdoYXQgcHJldmVu
dHMgY29tcGlsZXIgZnJvbSBtZXNzaW5nIHRoaXMgdXAuIEl0IGNhbiByZW9yZGVyIGFzIGl0DQo+
IHdpc2hlcywgbm8/DQoNCkhtbS4uIFJpZ2h0LiBTb3JyeSBJIG1pc3NlZC4NCg0KPiANCj4gTWF5
YmUgYWRkIGEgcHJvcGVyIGxvY2tpbmc/IEFueXRoaW5nIHRoYXQgcHJldmVudCBwcmVlbXB0aW9u
IHdvdWxkIGRvLA0KPiByaWdodD8NCj4gDQo+ID4gIAl0ZG1yLT5wYW10XzRrX2Jhc2UgPSBwYW10
X2Jhc2VbVERYX1BTXzRLXTsNCj4gPiAgCXRkbXItPnBhbXRfNGtfc2l6ZSA9IHBhbXRfc2l6ZVtU
RFhfUFNfNEtdOw0KPiA+ICAJdGRtci0+cGFtdF8ybV9iYXNlID0gcGFtdF9iYXNlW1REWF9QU18y
TV07DQo+IA0KDQpJIHRoaW5rIGEgc2ltcGxlIG1lbW9yeSBiYXJyaWVyIHdpbGwgZG8uICBIb3cg
ZG9lcyBiZWxvdyBsb29rPw0KDQotLS0gYS9hcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4LmMNCisr
KyBiL2FyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHguYw0KQEAgLTU5MSwxMSArNTkxLDEyIEBAIHN0
YXRpYyBpbnQgdGRtcl9zZXRfdXBfcGFtdChzdHJ1Y3QgdGRtcl9pbmZvICp0ZG1yLA0KICAgICAg
ICAgKiB0ZHhfbWVtb3J5X3NodXRkb3duKCkgYWxzbyByZWFkcyBURE1SJ3MgUEFNVCBkdXJpbmcN
CiAgICAgICAgICoga2V4ZWMoKSBvciByZWJvb3QsIHdoaWNoIGNvdWxkIGhhcHBlbiBhdCBhbnl0
aW1lLCBldmVuDQogICAgICAgICAqIGR1cmluZyB0aGlzIHBhcnRpY3VsYXIgY29kZS4gIE1ha2Ug
c3VyZSBwYW10XzRrX2Jhc2UNCi0gICAgICAgICogaXMgZmlyc3RseSBzZXQgb3RoZXJ3aXNlIHRk
eF9tZW1vcnlfc2h1dGRvd24oKSBtYXkNCi0gICAgICAgICogZ2V0IGFuIGludmFsaWQgUEFNVCBi
YXNlIHdoZW4gaXQgc2VlcyBhIHZhbGlkIG51bWJlcg0KLSAgICAgICAgKiBvZiBQQU1UIHBhZ2Vz
Lg0KKyAgICAgICAgKiBpcyBmaXJzdGx5IHNldCBhbmQgcGxhY2UgYSBfX21iKCkgYWZ0ZXIgaXQg
b3RoZXJ3aXNlDQorICAgICAgICAqIHRkeF9tZW1vcnlfc2h1dGRvd24oKSBtYXkgZ2V0IGFuIGlu
dmFsaWQgUEFNVCBiYXNlDQorICAgICAgICAqIHdoZW4gaXQgc2VlcyBhIHZhbGlkIG51bWJlciBv
ZiBQQU1UIHBhZ2VzLg0KICAgICAgICAgKi8NCiAgICAgICAgdGRtci0+cGFtdF80a19iYXNlID0g
cGFtdF9iYXNlW1REWF9QU180S107DQorICAgICAgIF9fbWIoKTsNCg==
