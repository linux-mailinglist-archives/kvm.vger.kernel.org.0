Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99A8A72F0DA
	for <lists+kvm@lfdr.de>; Wed, 14 Jun 2023 02:16:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241101AbjFNAQH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jun 2023 20:16:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231577AbjFNAQE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jun 2023 20:16:04 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D15D81B8;
        Tue, 13 Jun 2023 17:16:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686701763; x=1718237763;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=lgGRq0cUnS89kyQflEZMOgE1TPKF3IPBly176xsbsF0=;
  b=AQGj11fHfovaHib+UT5JGVdRAcVP3Lqf1q8Qc1/OvMbRFKUBzaJkdqEU
   OcCgFuB40AcID2D8++WUB9HHWtjXBq4lEAElUdYTm3yw9M4wmZm8/dYI6
   t+e+VKsHqiXd79CHVvZd6M7y14QX/diJJWysUPbmlWoAQ/1mOCo96AlAk
   2j9aaR92bC9dztP2fXXs+E298M7F+d2hh1qfCb0K+wp28+yvmZSy0qwSh
   eR1/H7ikCYThpsrDF8DGmMnlF9mkCqMo2d2UEPpqXaiIZ6D11udoGOtU5
   n0XfwQWAoSLuxLgSxAKaJ7dSjwHVHUJaCd2HcHfBB+K0+qgVcC4Sdiwk4
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="338836317"
X-IronPort-AV: E=Sophos;i="6.00,241,1681196400"; 
   d="scan'208";a="338836317"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2023 17:16:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="711842542"
X-IronPort-AV: E=Sophos;i="6.00,241,1681196400"; 
   d="scan'208";a="711842542"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga002.jf.intel.com with ESMTP; 13 Jun 2023 17:16:02 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 13 Jun 2023 17:16:00 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 13 Jun 2023 17:15:59 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 13 Jun 2023 17:15:59 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.171)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 13 Jun 2023 17:15:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W8QLHs71ppKdYXfyM7nyjiT5TlamuM0jFAwBFmG5bl/kRnROuIZe0HbVVebiDEC22yKwO83w5VlMVovzEpffLDrCCL8sYlbwJUNBUcVowmqSjfaEQGkfc6B5bS/CZ08xJkFz3YjH7wQFzOOR0RUg9C3s7SIz477fKSAHJ9va11IfjSELNwDzOgbMwLKieLJPs13bUxFBVGllGY2o049/r+7K8YdSIl74oro22sb3HSpa42HTagnqM7aKSIs147ZwcAnFZmtX84Z8VigmKZcHwzsAbnbWg5gFEifCpgkdKHMfIC2dISmTw36K20tr5NfCSWnavVz3BPoBUP6vrTsg1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lgGRq0cUnS89kyQflEZMOgE1TPKF3IPBly176xsbsF0=;
 b=oOexejjAgFeeePez4QOfkM8/PLr+upA80nPJWAY8wL/FnZRwFMwJJHhbG7qxEgV0aeCp7YSBPpziUZ8DaVRvPrBYzrs3HzVGS1RSWqzLWxop/EIBgZq8/dZ58WYwCe4B6veOg4a4FrdW2nJIg7uSq8dsLnDUjYcIGluf9RqheRx4CeJgBaiULcgiFtQEoLl6eSoWLGnCYjAJIjMovnN/TlgZtFMym/JMSTbofGrmAuO+YlQU2P/n/cIrBBiNYn2EW/ZeZli/f9nc1WAQmV86ZmU9pxucIsWA4IhRmKQuL+eD5SdoDfEIoz+3cT9xGm0woqq6e4KxtxgF81ez3kx0jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CY8PR11MB7060.namprd11.prod.outlook.com (2603:10b6:930:50::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.15; Wed, 14 Jun
 2023 00:15:55 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6455.043; Wed, 14 Jun 2023
 00:15:55 +0000
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
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
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
Thread-Index: AQHZlu+7CCb5RYnzE0SLr6ZWSpg4cK+CfSeAgAQK0ICAAFGDAIAAKbAAgAA3uQCAALmTAIAAq6IAgADcygA=
Date:   Wed, 14 Jun 2023 00:15:55 +0000
Message-ID: <1bde5c18e58c6d8f1eb20403c3ba442fa761a2a9.camel@intel.com>
References: <cover.1685887183.git.kai.huang@intel.com>
         <5aa7506d4fedbf625e3fe8ceeb88af3be1ce97ea.1685887183.git.kai.huang@intel.com>
         <20230609132301.uvvp27yr5kpenl6f@box.shutemov.name>
         <58f34b4b81b6d6b37d3386dec0f073e6eb7a97ff.camel@intel.com>
         <20230612075830.jbrdd6ysz4qq7wdf@box.shutemov.name>
         <4c7effc3abe71aa1cbee41f3bd46b97aed40be26.camel@intel.com>
         <48d5a29a-878c-665d-6ac2-6f0563bf6f3c@intel.com>
         <3bbb6b384ba89dfaa13be01654ad27e41d779fba.camel@intel.com>
         <20230613110538.5pwhy26q6irrlqqx@box.shutemov.name>
In-Reply-To: <20230613110538.5pwhy26q6irrlqqx@box.shutemov.name>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CY8PR11MB7060:EE_
x-ms-office365-filtering-correlation-id: 526caea8-2a50-4370-f5e7-08db6c6c853c
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jXs3WYlHwIKyHSuNd3L68TvN5nL93GL/B8XPvgHF6frBCachMS2MGB8q311c2WmsXo5gTRPi13vhXh3Wq91KZkHAbOeBvfAjYnYPba3n5KgsutFM7ouZM2wZaC22sfX4M3SJSk5wk31VcAm8oInMNu1UXLC2ZG/z2yn2nRIbT5TJfDG6VToKMIfxw8oGuG1CSDzH8wpezePzAlJDmmWg7aozc5SAjH6y9fRvua6Hzyh0EJDf0GLzZBYTnaXwVgKn6/QCloEGKwMCY5kqfsPeRZWLbAb9VpyhtF3qkYYKEyP3sdU3QvOPfNFizfGyM253h+ng0BauD9C2NgZLXwqsmsqjNezroV6VZ+pNXWzpfKwZwLa9qinTwUmgPnrNQYUQrpk2OvbAWcX5KapmRkSjiwaErXZC5FlU7+Sr34mBQ7i4koRndxUrE3NfzVAEM4ZOVRtmnX0+AfkewpBupPtKw3Phw4MC18Y65iT4s40JbXjFnN+WOUtS5l06k13jGwZja/CzYIh2DK91zTz/sHSDaQp7100aopxxZ+1Vi3dNClqAmFbDH5O7ZEZ4UxPu1tqqZlfJ+RTy0WrRYJlwgmIo+HR4s8OMYjNmJjT3ce2uVHE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(346002)(396003)(366004)(376002)(39860400002)(451199021)(41300700001)(8676002)(4326008)(76116006)(6916009)(66556008)(66476007)(91956017)(8936002)(66446008)(66946007)(64756008)(5660300002)(7416002)(316002)(54906003)(66899021)(6486002)(2906002)(122000001)(6512007)(82960400001)(53546011)(38100700002)(186003)(6506007)(26005)(86362001)(36756003)(71200400001)(83380400001)(966005)(478600001)(2616005)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dG5KRS9lSzdjSkx3L25MaEJiTTF1SlJxS2lkRllrL0VweWZ6eXA0bWV4UlRx?=
 =?utf-8?B?Z2pHRHRZTUlYblhsb0trOTNBekNZRUpUTUV1a1Y3SWxhaEMvWDdQOVIwekN5?=
 =?utf-8?B?dnRwSDdlZ0s3elVkV3ZuSWl0NXcvNWluMTR3OGtvQkIydXU3Z254RU56SGFh?=
 =?utf-8?B?OGFHM2lGUVBPTll1emFleG8rbGd2M3IrQVJ6UlZFTENWWlhHZDlKV0NOTm9R?=
 =?utf-8?B?NEMwb3Z0VFBQUnlGZU42N2tlMlorRTZaU1Rwd1BKbU1iemdKUTY4eFFkSm1C?=
 =?utf-8?B?eWMxc0gzN3FBU0ZKeXY4YVV3Q05CbncxbEFFQkZNbnpKUGVtMFlBMm9hczVl?=
 =?utf-8?B?ZEU4OTJtSFBWVXVyVUwxSmRPOEZaQ1NvbHBOZkZrN2dQYWkxMnd1UEJvcHF1?=
 =?utf-8?B?NENnNVE5V2M1bHhLejhTNDE3VG1LdmpqT2RTalNMOC9JanhPVVFGblVObFJB?=
 =?utf-8?B?RXB5b1JyYnMxaDZkMWVCQWpNVlVKbFRVTHEzQmJ6SHRJZHFyYmI1a2FTaHdH?=
 =?utf-8?B?Rm5OdzRuSVNNV3RpOVRwWEEySEprNlhJWlZQbUhORXAxb1ZYN0s4Q1ZZYzNH?=
 =?utf-8?B?V2JQUnkzQS9zWjQ3ejNiRktiTThuZk1ZT2I0L3JMVTg2b21STGVsVjZRM0tL?=
 =?utf-8?B?Q3cwb1kvclRoSDBGcEhNaWZjRmJtZUZEVm5pbU40eGFoZHBHVkZrK2p3dGdX?=
 =?utf-8?B?K1Z5ZThmd1Jzb2V5V203ZEZBZHpOZS9rYkFwU1hPZHRoM21jdUw0cGx0R3lS?=
 =?utf-8?B?eWtTYlE2MkYrTTZPTUw4UjZQVW8xaG5WYmhsNGRBQU1sQ2lPOUNSTVRkdjBX?=
 =?utf-8?B?ZGFXK3M3ZEJWS3h4VUZTNHc2ZEZzSjRGREVockdvcE4ybWduYlU2SU9tTzZv?=
 =?utf-8?B?b0ZHb2diK1hCbngxRDhVMEdGRDhqdXBqK1IySkRRL3lwZU9JV0ZuYm9YSG9q?=
 =?utf-8?B?aFkyZGk5SnBxb2hJVE5CWkNpNzRjYlFiWlp2cFFxQkhBWXMvbHNNTUYrc0ZL?=
 =?utf-8?B?UHo3d1JhZm1YOGRsK0JkbXNrSENaTnNHYW5ucU90Um1sSVJDcmpYUWszVkxX?=
 =?utf-8?B?aFdBakpOYTVBRktaWjg5ZEhERWhINHl0dVJYUmlPZlRZV25LN3FzdEJkMGtW?=
 =?utf-8?B?SzlYNVBxVS9rSkRRUEdKMzExQ2h1VFBkcHZVZjNHWmwybnJxZGFHeU1wRVp2?=
 =?utf-8?B?b1dhem5ZVDFRUDRodGhac3ROd3JMdEZMY1dEak84d1M0ZU5CSHdrWnZDbUsw?=
 =?utf-8?B?NmxlYndsR1RDYzE2aDVoWStxbkJkZ1BxSEN3Y1dnUjhBWXI0WUtvZjh4RWZP?=
 =?utf-8?B?VGliZC9EYVYwUnlZVUdXbGhZcE1BaGVaSURBQ0gxeWxPemxZUGcwSTI4MzJJ?=
 =?utf-8?B?Ym8xUG1DdWFXVktMc0dZaFcwOWRnemtYcUNZSU56V25oSk56UGlVM2FUU2M4?=
 =?utf-8?B?bjFIUGI5dlplTEpTVG0yWHpPOFg5bXFrSE01L2ZLdHlyaWJKek9NbER1Y3Z1?=
 =?utf-8?B?bzRIQXAxMHkwZnQyUlRCMENuQ00wbmc2TWIvSm5SK1RpSVhxWHRrUU9jK0tt?=
 =?utf-8?B?QjEzdUFCM0hINVVWZGRGeGRtMS8xcFVnWU1kOWpUd2ZOSUhjem5pUTBoUllT?=
 =?utf-8?B?QnFvM0R3ejM0bGJaNVI0OHJZWW9uMEhMSnFGbjE3K3hJRDhsc09WR2lYU3Qw?=
 =?utf-8?B?OVVYcWUrYVYzWDRqV29hMzhPUUhQd0M5WlBZMDhmVCtXOG4xdWRaaDFZUytZ?=
 =?utf-8?B?UURvUG1VWVlOUndlM0JoNUdsRUREY0Y1RThRa2tDQnBDeVM1YU1UN0EvTnJ1?=
 =?utf-8?B?eDVtWVJSMnNZZGdIeGVHblFkdWtKeFBNbjRoeGM2Y1hmaEZyQ2U1NGZmNklk?=
 =?utf-8?B?bVM2T1hhSlZ3U3JWSWRRQXU2eklHaGk3U3JLZEZyTDVudUFFK1NIaFBzUkVF?=
 =?utf-8?B?bGhZWUxVRk5sK3lESEFFdFNhT1p2ZWRlcHg5QnltZ1JwTHhWQ3lyTnpscnhY?=
 =?utf-8?B?SDUzSWJtcDlOcjdoQURqdlFnTXlIbzc5YWNZNGxIMGdSTlVGa3NEdTF0YTRZ?=
 =?utf-8?B?MGpPUDY1TjRtcFE0SmlZUTUzQXhseWZQZTJZcjQwRUZVVUQ4TUpBWUxmQzlH?=
 =?utf-8?Q?YM0hCjryTqoS3xujoFpeVhuGk?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <75A212DB5985454FAD058EEC78CBBB94@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 526caea8-2a50-4370-f5e7-08db6c6c853c
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2023 00:15:55.0462
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1+6qeYmQxpoWtVwX5fyWCDC7gCF2r5ulUEp5Kwi2FA2Kf1iPQAA8Na4a2YwyWvKH86oH2z7vcKzq9Mty8AkubA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7060
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

T24gVHVlLCAyMDIzLTA2LTEzIGF0IDE0OjA1ICswMzAwLCBraXJpbGwuc2h1dGVtb3ZAbGludXgu
aW50ZWwuY29tIHdyb3RlOg0KPiBPbiBUdWUsIEp1biAxMywgMjAyMyBhdCAxMjo1MToyM0FNICsw
MDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiA+IE9uIE1vbiwgMjAyMy0wNi0xMiBhdCAwNjo0NyAt
MDcwMCwgRGF2ZSBIYW5zZW4gd3JvdGU6DQo+ID4gPiBPbiA2LzEyLzIzIDAzOjI3LCBIdWFuZywg
S2FpIHdyb3RlOg0KPiA+ID4gPiBTbyBJIHRoaW5rIGEgX19tYigpIGFmdGVyIHNldHRpbmcgdGRt
ci0+cGFtdF80a19iYXNlIHNob3VsZCBiZSBnb29kIGVub3VnaCwgYXMNCj4gPiA+ID4gaXQgZ3Vh
cmFudGVlcyB3aGVuIHNldHRpbmcgdG8gYW55IHBhbXRfKl9zaXplIGhhcHBlbnMsIHRoZSB2YWxp
ZCBwYW10XzRrX2Jhc2UNCj4gPiA+ID4gd2lsbCBiZSBzZWVuIGJ5IG90aGVyIGNwdXMuDQo+ID4g
PiA+IA0KPiA+ID4gPiBEb2VzIGl0IG1ha2Ugc2Vuc2U/DQo+ID4gPiANCj4gPiA+IEp1c3QgdXNl
IGEgbm9ybWFsIG9sZCBhdG9taWNfdCBvciBzZXRfYml0KCkvdGVzdF9iaXQoKS4gIFRoZXkgaGF2
ZQ0KPiA+ID4gYnVpbHQtaW4gbWVtb3J5IGJhcnJpZXJzIGFyZSBhcmUgbGVzcyBsaWtlbHkgdG8g
Z2V0IGJvdGNoZWQuDQo+ID4gDQo+ID4gVGhhbmtzIGZvciB0aGUgc3VnZ2VzdGlvbi4NCj4gPiAN
Cj4gPiBIaSBEYXZlLCBLaXJpbGwsDQo+ID4gDQo+ID4gSSdkIGxpa2UgdG8gY2hlY2sgd2l0aCB5
b3UgdGhhdCB3aGV0aGVyIHdlIHNob3VsZCBpbnRyb2R1Y2UgYSBtZWNoYW5pc20gdG8gdHJhY2sN
Cj4gPiBURFggcHJpdmF0ZSBwYWdlcyBmb3IgYm90aCB0aGlzIHBhdGNoIGFuZCB0aGUgbmV4dC4N
Cj4gPiANCj4gPiBBcyB5b3UgY2FuIHNlZSB0aGlzIHBhdGNoIG9ubHkgZGVhbHMgUEFNVCBwYWdl
cyBkdWUgdG8gY291cGxlIG9mIHJlYXNvbnMgdGhhdA0KPiA+IG1uZW50aW9uZWQgaW4gdGhlIGNo
YW5nZWxvZy4gIFRoZSBuZXh0IE1DRSBwYXRjaCBoYW5kbGVzIGFsbCBURFggcHJpdmF0ZSBwYWdl
cywNCj4gPiBidXQgaXQgdXNlcyBTRUFNQ0FMTCBpbiB0aGUgI01DIGhhbmRsZXIuICBVc2luZyBT
RUFNQ0FMTCBoYXMgdHdvIGNvbnM6IDEpIGl0IGlzDQo+ID4gc2xvdyAocHJvYmFibHkgZG9lc24n
dCBtYXR0ZXIsIHRob3VnaCk7IDIpIGl0IGJyaW5ncyBhZGRpdGlvbmFsIHJpc2sgb2YNCj4gPiB0
cmlnZ2VyaW5nIGZ1cnRoZXIgI01DIGluc2lkZSBURFggbW9kdWxlLCBhbHRob3VnaCBzdWNoIHJp
c2sgc2hvdWxkIGJlIGENCj4gPiB0aGVvcmV0aWNhbCB0aGluZy4NCj4gPiANCj4gPiBJZiB3ZSBp
bnRyb2R1Y2UgYSBoZWxwZXIgdG8gbWFyayBhIHBhZ2UgYXMgVERYIHByaXZhdGUgcGFnZSwgdGhl
biBib3RoIGFib3ZlDQo+ID4gcGF0Y2hlcyBjYW4gdXRpbGl6ZSBpdC4gIFdlIGRvbid0IG5lZWQg
dG8gY29uc3VsdCBURE1ScyB0byBnZXQgUEFNVCBhbnltb3JlIGluDQo+ID4gdGhpcyBwYXRjaCAo
d2Ugd2lsbCBuZWVkIGEgd2F5IHRvIGxvb3AgYWxsIFREWC11c2FibGUgbWVtb3J5IHBhZ2VzLCBi
dXQgdGhpcw0KPiA+IG5lZWRzIHRvIGJlIGRvbmUgYW55d2F5IHdpdGggVERYIGd1ZXN0cykuICBJ
IGJlbGlldmUgZXZlbnR1YWxseSB3ZSBjYW4gZW5kIHVwDQo+ID4gd2l0aCBsZXNzIGNvZGUuDQo+
ID4gDQo+ID4gSW4gdGVybXMgb2YgaG93IHRvIGRvLCBmb3IgUEFNVCBwYWdlcywgd2UgY2FuIHNl
dCBwYWdlLT5wcml2YXRlIHRvIGEgVERYIG1hZ2ljDQo+ID4gbnVtYmVyIGJlY2F1c2UgdGhleSBj
b21lIG91dCBvZiBwYWdlIGFsbG9jYXRvciBkaXJlY3RseS4gIFNlY3VyZS1FUFQgcGFnZXMgYXJl
DQo+ID4gbGlrZSBQQU1UIHBhZ2VzIHRvby4gIEZvciBURFggZ3Vlc3QgcHJpdmF0ZSBwYWdlcywg
U2VhbiBpcyBtb3ZpbmcgdG8gaW1wbGVtZW50DQo+ID4gS1ZNJ3Mgb3duIHBzZXVkbyBmaWxlc3lz
dGVtIHNvIHRoZXkgd2lsbCBoYXZlIGEgdW5pcXVlIG1hcHBpbmcgdG8gaWRlbnRpZnkuDQo+ID4g
DQo+ID4gaHR0cHM6Ly9naXRodWIuY29tL3NlYW4tamMvbGludXgvY29tbWl0LzQwZDMzOGM4NjI5
Mjg3ZGRhNjBhOWY3YzgwMGVkZTg1NDkyOTVhN2MNCj4gPiANCj4gPiBBbmQgbXkgdGhpbmtpbmcg
aXMgaW4gdGhpcyBURFggaG9zdCBzZXJpZXMsIHdlIGNhbiBqdXN0IGhhbmRsZSBQQU1UIHBhZ2Vz
LiAgQm90aA0KPiA+IHNlY3VyZS1FUFQgYW5kIFREWCBndWVzdCBwcml2YXRlIHBhZ2VzIGNhbiBi
ZSBoYW5kbGVkIGxhdGVyIGluIEtWTSBURFggc2VyaWVzLiANCj4gPiBJIHRoaW5rIGV2ZW50dWFs
bHkgd2UgY2FuIGhhdmUgYSBmdW5jdGlvbiBsaWtlIGJlbG93IHRvIHRlbGwgd2hldGhlciBhIHBh
Z2UgaXMNCj4gPiBURFggcHJpdmF0ZSBwYWdlOg0KPiA+IA0KPiA+IAlib29sIHBhZ2VfaXNfdGR4
X3ByaXZhdGUoc3RydWN0IHBhZ2UgKnBhZ2UpDQo+ID4gCXsNCj4gPiAJCWlmIChwYWdlLT5wcml2
YXRlID09IFREWF9QUklWQVRFX01BR0lDKQ0KPiA+IAkJCXJldHVybiB0cnVlOw0KPiA+IA0KPiA+
IAkJaWYgKCFwYWdlX21hcHBpbmcocGFnZSkpDQo+ID4gCQkJcmV0dXJuIGZhbHNlOw0KPiA+IA0K
PiA+IAkJcmV0dXJuIHBhZ2VfbWFwcGluZyhwYWdlKS0+YV9vcHMgPT0gJmt2bV9nbWVtX29wczsN
Cj4gPiAJfQ0KPiA+IA0KPiA+IEhvdyBkb2VzIHRoaXMgc291bmQ/ICBPciBhbnkgb3RoZXIgY29t
bWVudHM/ICBUaGFua3MhDQo+IA0KPiBJZiB5b3UgZ29pbmcgdG8gdGFrZSB0aGlzIHBhdGggaXQg
aGFzIHRvIGJlIHN1cHBvcnRlZCBuYXRpdmVseSBieQ0KPiBrdm1fZ21lbV86IGl0IGhhcyB0byBw
cm92aWRlIEFQSSBmb3IgdGhhdC7CoA0KPiANCg0KWWVzLg0KDQo+IFlvdSBzaG91bGQgbm90IGFz
c3VtZSB0aGF0DQo+IHBhZ2UtPnByaXZhdGUgaXMgZnJlZSB0byB1c2UuIEl0IGlzIG93bmVkIGJ5
IGt2bV9nbW1lbS4NCj4gDQoNCnBhZ2UtPnByaXZhdGUgaXMgb25seSBmb3IgUEFNVCBhbmQgU0VQ
VCBwYWdlcy4gIGttZW1fZ21lbSBoYXMgaXQncyBvd24gbWFwcGluZw0Kd2hpY2ggY2FuIGJlIHVz
ZWQgdG8gaWRlbnRpZnkgdGhlIHBhZ2VzIG93bmVkIGJ5IGl0Lg0KDQpIbW0uLiBJIHRoaW5rIHdl
IHNob3VsZCBqdXN0IGxlYXZlIHRoZW0gb3V0IGZvciBub3csIGFzIHRoZXkgdGhlb3JldGljYWxs
eSBhcmUNCm93bmVkIGJ5IEtWTSB0aHVzIGNhbiBiZSBoYW5kbGVkIGJ5IEtWTSwgZS5nLiwgaW4g
aXQncyByZWJvb3Qgb3Igc2h1dGRvd24gb3INCm1vZHVsZSB1bmxvYWQgY29kZSBwYXRoLg0KDQpJ
ZiB3ZSBhcmUgZmluZSB0byB1c2UgU0VBTUNBTEwgaW4gdGhlICNNQyBoYW5kbGVyIGNvZGUgcGF0
aCwgSSB0aGluayBwZXJoYXBzIHdlDQpjYW4ganVzdCBrZWVwIHVzaW5nIFRETVJzIHRvIGxvY2F0
ZSBQQU1Ucy4NCg==
