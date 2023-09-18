Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 379987A4013
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 06:37:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236303AbjIREgx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 00:36:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239556AbjIREgr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 00:36:47 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4FE8EA;
        Sun, 17 Sep 2023 21:36:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695011801; x=1726547801;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=2eEpcKG7Dklf+1yZNwkEy6EPo6DwzB6pT/2D1L62gTM=;
  b=Gkx+Jefwk/YNU3avdZOdLKcG2Nb9x/OspKHAjlew2GCEGurbsdpMVAA4
   AIqrohlQ4iT8rnmmBr5gArHvZqW0lTKG6txTTDOQ97R+OBMYclil61o7/
   lshD17GgorPXnzSvTinuLCCJ4bfmekSB1waJapOT+49Sw9nXuTzEHKyDS
   V7LI49KQeIYyXUgW037OiZyHoh+S6EL5hdUf/f6GAVNCQqtiTE7ZyYhLx
   bob3sgJAG6dXycZ55nsWfkbWQLROHB+FCnFcSxQfdHRY90jHthC67q0TC
   X9x28OfE5mxSqyh1J46nmFofwZv4luUCq8bQBcK+lCM9c8sWBFMsElaZD
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10836"; a="465908558"
X-IronPort-AV: E=Sophos;i="6.02,155,1688454000"; 
   d="scan'208";a="465908558"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2023 21:36:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10836"; a="815875985"
X-IronPort-AV: E=Sophos;i="6.02,155,1688454000"; 
   d="scan'208";a="815875985"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 17 Sep 2023 21:36:40 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Sun, 17 Sep 2023 21:36:37 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Sun, 17 Sep 2023 21:36:36 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Sun, 17 Sep 2023 21:36:36 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.103)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Sun, 17 Sep 2023 21:36:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O9mHM3aADVAb1lNazBsjRgeLzKVj9YPhWpkfyF5I7WG6RuuiS2+hp4ir+gZpUrHMiNho9ZDofYc3xsSG6JgTqs+X49E/DmEM+ePjjOpwlcR1TnOJWxTJDVd0s6oVNWr9Tib6MttMhr44XvBEw43tH+RoNM4uCBdlf6wAxne70x1urZYjHnSXdSAnyfcdoHNoNwRfok4795XNwH24zVvXf/uR9t07tXjAv+iLJB9Mwy4VIBtSk3cVJc/iRX3fluRJREeqSeCKCGUEpZ3SossQjYGX8svJ89QXibysSy+hkgzcr/6qsfBGxBy6JHrxuNc9aLmPbrDjUauZGM01Wxqu3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2eEpcKG7Dklf+1yZNwkEy6EPo6DwzB6pT/2D1L62gTM=;
 b=n1+/zgtPARTV7uuiEFVTjLyPNNbyNKtaHAncZuZ57bBgW5fyTk2idJtffrxLD2ZK2TTv46DmBExLPqH6I2LqmV9CkKZcAkvsjcQ9x27+Mo7/JZJF5cAIcvNPm8Kz20qVmuQSfA3/7ZrF0msVfH3KKV6/ek51OTB7BrpW2LQplWY5Kg5ysE6Pmv6fhbLLIV0ynmLRgmD1u+UfOV8p18MqUxOkQajjozjAJ66IydJYo7Ls/Cg6fuK4gJRIRBk/L94PfHtjVNHANGoZKT2VxxKQZiUtcth9eXLm8SNeY6Il/QEh3AwUxFGW1Wv+bzaJsXy+AdLeWAX8Q2RilccwoIWQnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SN7PR11MB6923.namprd11.prod.outlook.com (2603:10b6:806:2aa::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.24; Mon, 18 Sep
 2023 04:36:33 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::31a9:b803:fe81:5236]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::31a9:b803:fe81:5236%4]) with mapi id 15.20.6792.026; Mon, 18 Sep 2023
 04:36:33 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC:     "Raj, Ashok" <ashok.raj@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Luck, Tony" <tony.luck@intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v13 20/22] x86/kexec(): Reset TDX private memory on
 platforms with TDX erratum
Thread-Topic: [PATCH v13 20/22] x86/kexec(): Reset TDX private memory on
 platforms with TDX erratum
Thread-Index: AQHZ101Okhxwq9ktjkOz/F9rFTzkybAa+E0AgADsmYCAAFPVAIAD7A0A
Date:   Mon, 18 Sep 2023 04:36:33 +0000
Message-ID: <11e8d55976b7f36715597dfc329c017de3f77ea3.camel@intel.com>
References: <cover.1692962263.git.kai.huang@intel.com>
         <12c249371edcbad8fbb15af558715fb8ea1f1e05.1692962263.git.kai.huang@intel.com>
         <87497f25d91c5f633939c1cb87001dde656bd220.camel@intel.com>
         <c33f7c61a1a24c283294075862cae4452d7dec3d.camel@intel.com>
         <c1227134ab2430872824334d2e68e8f43d6d630f.camel@intel.com>
In-Reply-To: <c1227134ab2430872824334d2e68e8f43d6d630f.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SN7PR11MB6923:EE_
x-ms-office365-filtering-correlation-id: e9978213-2039-4152-b1c6-08dbb800d643
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lqO0cl/trGAjeYciemm/lVd7dlTs734kw+uY6uFjFfgQd0I9AQ2yKStujZXXTtpgFbGknvI/CWr40cavfsE2yFlmxlJCPsAHP8y6n9lhONkcj7qgAE57fkKFkoFYMs4A3F9El264ugdVI2yPwK61tx72PPVE+mb0JqTT52UA6fQ0AOY93+fohZLnM2moERjQraVgJmNyCjrbrSvvncaAWt9FR0Ubb9Qk54XeRKHDnpSxT42XO6WxezsZdJRh6VOYroqkHnqEjgeBNxrX1mfdjyHsH6dtxg3NFUaANLqbLRXh964Vc2AC0D2R7W4IPO8907iHQ61TfTw7TcKQ0lTBhus9vplRWug63dJUhDrwRQp9Vvqe92vW0Vf3K5+PLUwh4xfuvw1tfqKAVo2JgcMsaq3/ZkODW6eVDQBdV3Cec/aXVKZskEIdzT1YTjFfxVfTxdwRmxT/+21ntJe8AbBnDk0SWgTYDy92NVYlZxshCi6kYcUbtJlRmuXYzF/icKCBkkE3nZzc+3MCrIcQhBUzNIivJqm5ipDaLUzF9wbOBJrlj/1XeF9YMum/obHvc7bo8C3aAns3cQXnLasDPq/SJfzelRdlQRA4hLPcDgHpeuG3Z8gRBh7E7s7f2gOuGrRD
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(39860400002)(376002)(136003)(366004)(396003)(451199024)(186009)(1800799009)(6486002)(5660300002)(6506007)(86362001)(54906003)(316002)(6512007)(66446008)(64756008)(66946007)(38100700002)(41300700001)(66556008)(66476007)(38070700005)(76116006)(110136005)(91956017)(71200400001)(478600001)(6636002)(82960400001)(8936002)(2616005)(8676002)(26005)(2906002)(36756003)(122000001)(4326008)(83380400001)(7416002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OGZnb3NoYlpTNVp0cDRjTHZkWlpmcEptZ2g5VDRBb0dWTXlZTkdvYlVQOFd3?=
 =?utf-8?B?aFdMUnliZnRZbTFSOGJKTk4ydDUyZm1iUGRjWjRsOW9RWUdDWnJRRFMyVmhL?=
 =?utf-8?B?dmVlNVNwc1lLOS9haG1od1R6S0FESThLdllMY2ZLMW52a2k2Mk1PVTBTWnlF?=
 =?utf-8?B?K0l6QlV1WURrak9IZENFbmdlVnpDLzFiaXdKT2Z3YjVaZzd4MjJ4T2ZvWnZa?=
 =?utf-8?B?UVR1TS9mdmE4eTR5b1RsVGJ1ZTVMTk54b2xoc2lYZFNVNGlFcDlJL29uWVJE?=
 =?utf-8?B?dzU1bXNpSlozZTl3bmQ2TWNVRmxHcGR2SERJZkVCc3ppZ3ZJcDVxd3d3LzNV?=
 =?utf-8?B?S1FtWnBoZENUd3QvOEtNMUNXK1orRndYeHg3M1ZNczhnY2R2N1VnZ2NpTkFs?=
 =?utf-8?B?cG1Hc1F4ZFJaNzJ3RDA1QXRUeTBGb3hXNXlLcFc2YmtqK0NYVDlERjZYSGVp?=
 =?utf-8?B?WUZ4Ti9zZy9DY3hLUVhFMmdjSlJKZjhWR1Z0MWZiV0tXWC95SkZSYUg2VVdq?=
 =?utf-8?B?dUF1VmtXSE50VEZPTGVac2k4WEJkUjBZT2RVUzF6ckpFajVhdU01QU85eUtL?=
 =?utf-8?B?UFJxQVY2d2xDVzl5cW1ZOE54cGptUHVhaU45b2V5RXNVc1BwODZDalB2YmNY?=
 =?utf-8?B?dmNnQkJxVFVka0xmc04wa091MTh4MWl4WDQwNkNacHZ6Rk1BaE85Rm9EVTNh?=
 =?utf-8?B?WU5odUp1OGxXZTl6Yk9naHVGY2ZKVkhXSzhqUUE5ZWJpWEE3TkNReTN0YXR2?=
 =?utf-8?B?NTFvYTdpd1d3V0hrbmRhVW5tSkNDL0NBaWtqZlRxbVZCSDJiYXVwYkJycHFi?=
 =?utf-8?B?UWN1ak5YdkFoeGVOVmxGWmw4N3RMUU9wUTNjak02czQ1cXYxd3VRVGtHb3gv?=
 =?utf-8?B?amFURDFkV3NoSncyK0xpcHpyUi9ZSTY3SUZpaHBTbkVjV2N1eTVGdjJkU1Ju?=
 =?utf-8?B?QXZEMFNkUFB0Z01FT3RQenFub0hXZFBPTCs5Q0tLZ29SeWRMMmh4a3FwWnMy?=
 =?utf-8?B?Z3pieG9MQTJicHJ3MldyV0NmVjhXL2tXWFRrTXhoVWdkR0h1YWFmN0w2VjlZ?=
 =?utf-8?B?SVErSmdJYnRmUmwxOUVUamN1N2Q2UnN6QUVLcEQvbTlnS29tZHJxai9ZTkls?=
 =?utf-8?B?Q2tzNjlwb0cwMkFVd1ZHS1R2b3NtQTdpdVpMcUZLejg1K2lOZmVJQzBTNU1U?=
 =?utf-8?B?VXlKSDRwSjIrK2VNamtiVGZ0UTFLQjQzNFUzbnF0b3ZFdnZVak00SUNpaG9j?=
 =?utf-8?B?MndDNVpuK2RwMWZRb2RSNjZZZkkvOTQ2WHJIVVdld1l4NXJOaXZ4ODJLU3BH?=
 =?utf-8?B?T0FkOGJmUVJETVFKOEs3bFpOdW9kUFNKcUZBV1pQRnVVVnZERVFITWluQ1Zj?=
 =?utf-8?B?enJVTDNoT3ZZaFlPeXBGQlRKVjRJTkp6RzhjVExkNDhNeWEzbytEQnFWUlNp?=
 =?utf-8?B?M2tOUnkvNTRLVjFEeDBSU1AyT2plbFU1c2h4RmNVd3lnMGpLZzhsRG51VFRa?=
 =?utf-8?B?Y0hya3JlVkxMUi9lZFRVQ3A3OXRsTDFvODNyelN3QzM4ZllLRDZESTJ0WEFX?=
 =?utf-8?B?THlQMWhEQ044R2ZhT0JZdlhpUmpDdGF3amd0QW5Pbk5xaUNrb1k0cWk3YytG?=
 =?utf-8?B?T2tyT0hEeXBwb2k2NFNTWTVMcFRWbk9ialI2MkIzSW9Ga2U3RnJzQ3k5T3NU?=
 =?utf-8?B?M1l5NWZNdmtpYXdkQmN6Wkg0WUpDdjRzdnJpcHBTOFcwdEN3MUhRNWV4V1o4?=
 =?utf-8?B?OE1mVGFZYU9OaTVqRE5VMjZzRkJPbCswQzR2RDZOVHBwRjN6aTV6T25hMGUx?=
 =?utf-8?B?VlVTTzhqNlFTRnJTOVFMYVNaVnBLZkovaE04bXo2R215SXlhYitKcDlBQ2JF?=
 =?utf-8?B?cmg3RS9xdzR4aVZxRE5wSmVjd2dkUUdjK3lOY0xqQUNwTTY3Y25CRHlvQTZV?=
 =?utf-8?B?aU1zOU1rMDFMTmpmU3V4eWVLQWhFSzB3OTNiVEFJeml5OGdaUlNLLysvZmJX?=
 =?utf-8?B?QmtCc3ZXTnRMMVU3Z1VwWG9Ta2JBWnVwaDkzanhPOERwSExWbXNsMzJTK0c2?=
 =?utf-8?B?NU13YThwSFFtWjdSZkROVDJXamtWTmU3MnA4Mml3eGdYdzVwR3ZpakFRcG1P?=
 =?utf-8?B?TnZ2OUNwMFN3em1GTDVNR2dSdTVFN1dYbTdLRnFNY0tXRDRhem9XT0NLTkZ4?=
 =?utf-8?B?Vnc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <02114CF6F6DE2740A18751ACD397B379@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9978213-2039-4152-b1c6-08dbb800d643
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Sep 2023 04:36:33.7269
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cd2Jg1XSO8zcHaqMJdD4TRzyn+H4Gu9ma9bMrJxnV7O4oDwRzybnggxKgsAcJDmB69nEacNka2ixnvFWyv1xPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6923
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiA+ID4gDQo+ID4gDQo+ID4gR29vZCBwb2ludC7CoCBUaGFua3MhDQo+ID4gDQo+ID4gQmFzZWQg
b24gbXkgdW5kZXJzdGFuZGluZywgaXQgc2hvdWxkIGJlIE9LIHRvIHNraXAgdGR4X3Jlc2V0X21l
bW9yeSgpDQo+ID4gKG9yIGJldHRlcg0KPiA+IHRvKSB3aGVuIHByZXNlcnZlX2NvbnRleHQgaXMg
b24uwqAgVGhlIHNlY29uZCBrZXJuZWwgc2hvdWxkbid0IHRvdWNoDQo+ID4gZmlyc3QNCj4gPiBr
ZXJuZWwncyBtZW1vcnkgYW55d2F5IG90aGVyd2lzZSBpdCBtYXkgY29ycnVwdCB0aGUgZmlyc3Qg
a2VybmVsDQo+ID4gc3RhdGUgKGlmIGl0DQo+ID4gZG9lcyB0aGlzIG1hbGljaW91c2x5IG9yIGFj
Y2lkZW50YWxseSwgdGhlbiB0aGUgZmlyc3Qga2VybmVsIGlzbid0DQo+ID4gZ3VhcmFudGVlZCB0
bw0KPiA+IHdvcmsgYW55d2F5KS4gwqANCj4gDQo+IEkgdGhpbmsgaXQgbWF5IHJlYWQgdGhlIG1l
bW9yeSwgaXMgaXQgb2s/DQoNClJlYWQgaXMgZmluZS4gIE9ubHkgInBhcnRpYWwgd3JpdGUiIGNh
biBwb2lzb24gdGhlIG1lbW9yeS4NCg0KWy4uLl0NCj4gDQoNCj4gDQo+IE5vdCB0aGUgbW9zdCBi
ZWF1dGlmdWwgaWZkZWZmZXJ5LCBJJ2QganVzdCBkdXBsaWNhdGUgdGhlDQo+IHRkeF9yZXNldF9t
ZW1vcnkoKSBjYWxsLiBCdXQgbm90IGEgc3Ryb25nIG9waW5pb24uDQo+IA0KDQpSZWZpbmVkIHRv
IGJlbG93LiAgTGV0IG1lIGtub3cgaWYgeW91IGhhdmUgYW55IGZ1cnRoZXIgY29tbWVudHM/DQoN
Ci0tLSBhL2FyY2gveDg2L2tlcm5lbC9tYWNoaW5lX2tleGVjXzY0LmMNCisrKyBiL2FyY2gveDg2
L2tlcm5lbC9tYWNoaW5lX2tleGVjXzY0LmMNCkBAIC0zMDcsMTIgKzMwNywxOSBAQCB2b2lkIG1h
Y2hpbmVfa2V4ZWMoc3RydWN0IGtpbWFnZSAqaW1hZ2UpDQogICAgICAgICAqIGFsbCBURFggcHJp
dmF0ZSBwYWdlcyBuZWVkIHRvIGJlIGNvbnZlcnRlZCBiYWNrIHRvIG5vcm1hbA0KICAgICAgICAg
KiBiZWZvcmUgYm9vdGluZyB0byB0aGUgbmV3IGtlcm5lbCwgb3RoZXJ3aXNlIHRoZSBuZXcga2Vy
bmVsDQogICAgICAgICAqIG1heSBnZXQgdW5leHBlY3RlZCBtYWNoaW5lIGNoZWNrLg0KKyAgICAg
ICAgKg0KKyAgICAgICAgKiBCdXQgc2tpcCB0aGlzIHdoZW4gcHJlc2VydmVfY29udGV4dCBpcyBv
bi4gIFRoZSBzZWNvbmQga2VybmVsDQorICAgICAgICAqIHNob3VsZG4ndCB3cml0ZSB0byB0aGUg
Zmlyc3Qga2VybmVsJ3MgbWVtb3J5IGFueXdheS4gIFNraXBwaW5nDQorICAgICAgICAqIHRoaXMg
YWxzbyBhdm9pZHMga2lsbGluZyBURFggaW4gdGhlIGZpcnN0IGtlcm5lbCwgd2hpY2ggd291bGQN
CisgICAgICAgICogcmVxdWlyZSBtb3JlIGNvbXBsaWNhdGVkIGhhbmRsaW5nLg0KICAgICAgICAg
Ki8NCi0gICAgICAgdGR4X3Jlc2V0X21lbW9yeSgpOw0KLQ0KICNpZmRlZiBDT05GSUdfS0VYRUNf
SlVNUA0KICAgICAgICBpZiAoaW1hZ2UtPnByZXNlcnZlX2NvbnRleHQpDQogICAgICAgICAgICAg
ICAgc2F2ZV9wcm9jZXNzb3Jfc3RhdGUoKTsNCisgICAgICAgZWxzZQ0KKyAgICAgICAgICAgICAg
IHRkeF9yZXNldF9tZW1vcnkoKTsNCisjZWxzZQ0KKyAgICAgICB0ZHhfcmVzZXRfbWVtb3J5KCk7
DQogI2VuZGlmDQoNCg0KDQo=
