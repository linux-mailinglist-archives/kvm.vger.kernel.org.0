Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 110536330D0
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 00:41:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232029AbiKUXli (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Nov 2022 18:41:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232026AbiKUXlV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Nov 2022 18:41:21 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C460DEACE;
        Mon, 21 Nov 2022 15:40:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669074049; x=1700610049;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=fwD9fkd5DZ9MK6CqhZri9E2wDoP0K29Z/5lTjPXLS7s=;
  b=c5VMmWniVoZHNvB39lIJH5PL5oAqTqylxdIpIbTjMBUlYjcitgmzjin8
   4/6d9dzjgF6BPKI/buuWgJaDIDXEEt7Di6mu131OViAqNC6s9lLKN0st8
   +uqxeqZruqRAeQ+MrehyC5YdQZulXtK9PQulPQstqaVzAT8BPM3CuOhZS
   MQQ/0EIUzBm8/0ii+cRNWeQO6jNRVfbwauiN6OOMex9LFSNgDPEJW78Xl
   FBsu3i/kIQhmkrhHkSarqEaW6M/5rinaszBwKKXtBREEM4CizYcz2MImo
   aF11IsKj57QD14hTgEgJl3VpT1Y76LDQUmNRRbskUmGhuMyS3E8KKaVVs
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="377945951"
X-IronPort-AV: E=Sophos;i="5.96,182,1665471600"; 
   d="scan'208";a="377945951"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2022 15:40:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="709989122"
X-IronPort-AV: E=Sophos;i="5.96,182,1665471600"; 
   d="scan'208";a="709989122"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga004.fm.intel.com with ESMTP; 21 Nov 2022 15:40:47 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 21 Nov 2022 15:40:45 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 21 Nov 2022 15:40:45 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 21 Nov 2022 15:40:45 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.42) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 21 Nov 2022 15:40:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iZQ0BAah6EJ4cEDmDIM/Qj2xCMn8rBlwaQljcYGnJtW8KTAyZ4OyQRMoTy0bMaVMYg1pge0m9g+TLm1VsDSLU46dmFo3W+Zl9l5cUYHNWPO0R1kjGbVbXir2/Hs9JtSFwXYWtEycg+mtqeRNjtQUdtHUhEOE6faFgEsRmWiyuHs03dVd3mt79+kqEjRKvPHK/WxtdZb3t2IIGuW7+6OYw+E1u4U+0nPm+HgtqMUfsaJBZFt+zOZtANCOHAvq77NWkgXzFMN/yqTSMN0ek0lWTxucJ8IVz4mwjZLUnzC6RJSX3bEXPo/GgSH6S02D9MB6LqxVZCuJyy1f6JxexKYh+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fwD9fkd5DZ9MK6CqhZri9E2wDoP0K29Z/5lTjPXLS7s=;
 b=Wl2UmO05otunMHnc3PvoaEVU6y3VLl0v/FA8ihk6X7QkEzRaKH2UvB2/MTeFkoiQS7d9RM3qI3GGolTYcpN9OJ17ywN+1MzK14oWWF8yr1FKSZykseeb3uF8zEauYqdNr08MtejfNDHQq6Fys0jvHcejp6Ipnt19DC0u4aTbGlkGEbjYLA5qBhPdM2E8NrdK8LQTMBD7fOqGSw+EZn4R8qUWMN8qChrohPxLgy1neXT6Zw7yloZyJEJSTuNkZ+wSagc6ODvhjyZ3GYiJcqEyGkySuwayUAAtkZFziY9VqwPQM8eraK79q8T3DYlvBppOdk861i4SbCX7hgSNURCDUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MW4PR11MB5774.namprd11.prod.outlook.com (2603:10b6:303:182::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.9; Mon, 21 Nov
 2022 23:40:40 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%8]) with mapi id 15.20.5834.015; Mon, 21 Nov 2022
 23:40:40 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Hansen, Dave" <dave.hansen@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v7 03/20] x86/virt/tdx: Disable TDX if X2APIC is not
 enabled
Thread-Topic: [PATCH v7 03/20] x86/virt/tdx: Disable TDX if X2APIC is not
 enabled
Thread-Index: AQHY/T2/qiNrCEbeGka7t7fkot0Cyq5IvpmAgABiqQCAAM2GAIAAHAqA
Date:   Mon, 21 Nov 2022 23:40:40 +0000
Message-ID: <2b8f18d0fa9f996430e9f92d9350a454dc6b8d78.camel@intel.com>
References: <cover.1668988357.git.kai.huang@intel.com>
         <c5f484c1a87ee052597fd5f539cf021f158755b9.1668988357.git.kai.huang@intel.com>
         <62c67ed3-e4d1-082f-800a-b0837c9432a9@linux.intel.com>
         <31cb1df3cf21889fb33a7c675aa1bf5fa2078cad.camel@intel.com>
         <cb64427e-31a2-eac0-a7f6-546571ac2724@linux.intel.com>
In-Reply-To: <cb64427e-31a2-eac0-a7f6-546571ac2724@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MW4PR11MB5774:EE_
x-ms-office365-filtering-correlation-id: 38c409ff-923e-4f62-c547-08dacc19cc96
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JjkrCZWdPdqtSAR0+PeKZXuGsfT+GS3DpcSa+qBvCznDMYV0HApGtARc4RPVn+Bn+KyD1+nupjOaR6jOqVpZLmxt67XjzGf5JApBcaSP/T0t+kMxLn755LjbUWxv7sn484f2nG3CPrVFtIzvucIcbdBRt2HrXuzI8Tb0FWaW8AKE6ZjnmYDNYZ4IARoR2bu4ChpRxuyoduoJdO6GKoIM9X8xVx4doQ44LXg9J7JHK4mQi/NNspg0MExXQwobT5uIOrdE4MocIK5iKDHZjithOndjOS0l0w/xKgDT+HJmXmXSe2fZT4Z0p3C/78zxGPwh3NUxegRa+kJs3V1i7qH5vj/z4AnRE5jKqyXXnrOszpkiJRM0cnvHUhjmRXgfVbnY7MizuUvKkoj01hVv8VJTNMkgD8MffPLj4IYjJreWtBxfgCCNNC576bBGFDXu4mAkWph0xFZsIY2ZQ6j4FuIGlM/xIze60JRBnpYFNCdYk8WNwC6QHFdVKrMlKMfpfU19kjr/srGKJg7WsgzflyFxHGLU85t0Iv3PHezk+XpciLK0G7AtDEWKSLRug7MBe2xJOo5gDyOWPm9SmLeUIX1FDbNp0BxP5g0Q0I0+DSpKJ1eQmVPnLt9/ZMAHMAooOsGCi+kX4wBji943I9nQL5/16EqMVcXaQd6XkkBR+xP62FD/j/f+yncg9sdP16xPb5U0HhIxvPxOUvoF3idWF4mI2Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(136003)(39860400002)(366004)(396003)(451199015)(66446008)(86362001)(36756003)(6512007)(5660300002)(8936002)(7416002)(186003)(4744005)(2906002)(26005)(38100700002)(122000001)(82960400001)(38070700005)(4001150100001)(91956017)(54906003)(41300700001)(71200400001)(2616005)(316002)(66946007)(6506007)(76116006)(4326008)(66556008)(66476007)(478600001)(110136005)(6486002)(8676002)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WXZlUWpoL2s4ZGJUR3dQeUIxcFBoZFVDTnFGM0RWVTJmbjlrMHF1NlRtUGNi?=
 =?utf-8?B?TTJ5K1NWUlh6VEw0TEdzMjl1bnJHTEZuYngxRTJMZW9yYWtCbjRRZWJVOUhC?=
 =?utf-8?B?Tmp4YU50dStzQmNBWTNNVEJvVnBrOWJhdFpmaFcxTHVKOGtvSng3MkFIMkNq?=
 =?utf-8?B?bHA1czV3aWpvVGtrRzNMaVpNSFJRRGdNcmpsM1ZpN3M0WlMvbWFCeVZhWCtz?=
 =?utf-8?B?cjJhcDRlcE54OElBbURWR1lBR1hmb3Z0T2dhQzlraWZyYzErU3RJcTdPbmxM?=
 =?utf-8?B?QUhwZitwRWdZM3EwODhvaWdnVnBoTlg3M1NRUFc5MXJMVVNGWGE3dWZ5MGtu?=
 =?utf-8?B?V3FmSFVycERtbWZaVnJ4Z3pOdHlML1lUMjU2SzB5dE0vRUNKdE5yWkxKVDhw?=
 =?utf-8?B?TFM4K2lZUVVtdkE4eER5MGhDNi9WMUxuVjlqQUZ3Nzl3RE4vRC9mSVlrN2to?=
 =?utf-8?B?SmFJU0FpN2VuR2NzRDhFVmE2SEpPamNSaXgvU0NGL2V2NkJqWk9taStxZ3hu?=
 =?utf-8?B?dVk5UnBER2o4MHdGMnM3WlRvMHhxa3Y3OEZrNmNyQzFwSlFyU2ZkdGRkYXZE?=
 =?utf-8?B?K3ZwTWEwamcrN0Q3MXNJZnFhK05iK2NZMnk5aERsVENrRThTT2JvN0VRbjEv?=
 =?utf-8?B?UUZBanQ4WHNrNVlxMmxlYTcvdWc3ZTNBY3VLUjZOVDdFZXBzaHdsV0VSNDZt?=
 =?utf-8?B?Snlabk1XbzJua2FYbkIwZjJXNnE2NkRwTTFkTnpjbjhLKzZ3MkF1dFBIMWYz?=
 =?utf-8?B?eDZMdzdLK1JaeGdDeVhJWWwwTjNaNzAyeHZqZ3dJNTIydjlNdW56SUlGQUNj?=
 =?utf-8?B?MkplSEVQY1JSSzFPaW5kdjRtV1Yra3FiL1hNbTRTVTlFblU2aURYL040S0Zm?=
 =?utf-8?B?cVUwaCt0U0lWU2pGRXk4V3p4NW9RdEFlTWliMjVwckZ2R0dycVVuWk95UnNw?=
 =?utf-8?B?VHkydG0zVDZqeHpkdE90Tlp4a2pHaFJXUTZ5dHRxSFh2SDYyYmREQUsySzdI?=
 =?utf-8?B?dmRYbnBlMk5NR1czekZlSkI3OXluNUZhbVJUY1k3VmRycnAzcjRnQkUwejRZ?=
 =?utf-8?B?c1p1b1NYdGU0SkdYTU1STVVKZHJqMFVpYXVIMlJuVXhDY2tFd1hnWk9iN3Jq?=
 =?utf-8?B?b2U5NnNwZTREN2ZFWVhoVmRKNnFKY3NLZ2wyYzc0OFZ1OFZoTS8rZk5JdW85?=
 =?utf-8?B?Z1JsK2J4Sks1UnZXMnZpSEVSZDA0aE9GdXMrZW5PdHJ6K2k4N1hUYmJKaW9L?=
 =?utf-8?B?STZMRlp6SnV4SXVobGo3dTJSVlQzMjRtcUtjM1ZpTnR2V1M5dmxBR2lDemI0?=
 =?utf-8?B?MmttUUtzMWNXajgvSnNQVEtUNW5lTWhHanl0UGFtVEtuSFp1ajEvenhPMXVO?=
 =?utf-8?B?NytMSTZNQ3ltdDBLenQwZElyRGRqcy90Zk5vL0VTNzRHdzl0SDB3RXdWMHB2?=
 =?utf-8?B?TElhR2hlL1V6S2dJYS9qS3h3TXdhYjArYzMyazVSazcwbnNhZWlvMVFxMlZ2?=
 =?utf-8?B?R2RKTnVxZkdVbTg0ZjlwVzhaZlV1TDdBd0lzbkFIVVhhYkhmVTF5eGtNelV0?=
 =?utf-8?B?dm1mN3U1VU9iYXdSMWdsL3ZkZG9pQ1lNdUpBMVFZbGUzSXduZURMVStWRnZt?=
 =?utf-8?B?KzRxWkl4bEpkS3M1QWxFdUlXTWNWZjVHQmpCMzB3azJtdiszZzhoN0ErOXRB?=
 =?utf-8?B?VEYxRnZHYVZhVDhyZEViTUg4eEZ3MlZJelVlMU5uZ0x1QnJ6cEREK1RTaTQx?=
 =?utf-8?B?UDFmbGUrK0xvMTZQeE8xU2lrWFFOaWJ2bEtUMzZYc2tGQm5vQ2VQUmFkSTVK?=
 =?utf-8?B?d3FPSjlubnhvMkd1UkxLS2tXNjhFYUU4STE2bmtsdFUyLzc3UHN4MjcxRnNV?=
 =?utf-8?B?RkZ4dm1EUDBOWUg4OUYrSWNFMnJldG1tOHU1SkNQeEEyUDRoV1ZVK1FJQ1Ey?=
 =?utf-8?B?bHlOeS9XSjdJNWllQWg0VlNWZjN6QVlDZkNDZFhrSXN4ZGI0a3BKemFBL1M0?=
 =?utf-8?B?QlR3elJmcGZ5dGVZbVVEU3V0TjVVZkMrV1Jwa0E5NlFDRGpGSTNHSVVUSVdo?=
 =?utf-8?B?TjlVSGRHWlJxYTN1b3VucklEVzVGdmo2RFUvRnRYbWIxa1l6U09mUyszUTg1?=
 =?utf-8?B?bFEzcEFwR3A5WUIzSTlSazhXNGU5ci9SUmlwdHZYaUdmekNQdEY1Nld2TWFo?=
 =?utf-8?B?UHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DE33AAE58A76A04D816AA4BADD0F95FC@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38c409ff-923e-4f62-c547-08dacc19cc96
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2022 23:40:40.4715
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9OrJnj5WpeczX6jHlTP73bwgLpJFsgLtpjkcZVlF8LoKekh6r3+ORIlNESgG80dqle9ct9OOyGIk8gARRTTxNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5774
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gTW9uLCAyMDIyLTExLTIxIGF0IDE0OjAwIC0wODAwLCBTYXRoeWFuYXJheWFuYW4gS3VwcHVz
d2FteSB3cm90ZToNCj4gPiA+ID4gwqAgDQo+ID4gPiA+ICsJLyoNCj4gPiA+ID4gKwkgKiBURFgg
cmVxdWlyZXMgWDJBUElDIGJlaW5nIGVuYWJsZWQgdG8gcHJldmVudCBwb3RlbnRpYWwgZGF0YQ0K
PiA+ID4gPiArCSAqIGxlYWsgdmlhIEFQSUMgTU1JTyByZWdpc3RlcnMuwqAgSnVzdCBkaXNhYmxl
IFREWCBpZiBub3QgdXNpbmcNCj4gPiA+ID4gKwkgKiBYMkFQSUMuDQo+ID4gPiANCj4gPiA+IFJl
bW92ZSB0aGUgZG91YmxlIHNwYWNlLg0KPiA+IA0KPiA+IFNvcnJ5IHdoaWNoICJkb3VibGUgc3Bh
Y2UiPw0KPiANCj4gQmVmb3JlIEp1c3QgZGlzYWJsZS4gSXQgbG9va2VkIGxpa2UgZG91YmxlIHNw
YWNlLiBJcyBpdCBub3Q/DQoNClRoZXJlIGFyZSBidW5jaCBvZiBleGFtcGxlcyBpbiB0aGUgdXBz
dHJlYW0ga2VybmVsIHVzaW5nICJkb3VibGUgc3BhY2UiIGJvdGggaW4NCmNoYW5nZWxvZyBhbmQg
Y29tbWVudC4NCg==
