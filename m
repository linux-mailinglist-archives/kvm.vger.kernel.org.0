Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FE9F6381E2
	for <lists+kvm@lfdr.de>; Fri, 25 Nov 2022 01:13:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbiKYANy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 19:13:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbiKYANw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 19:13:52 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BDBE79E1D;
        Thu, 24 Nov 2022 16:13:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669335232; x=1700871232;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=sHUBdusIZuXH0fnCcTNPqeuM2fv8Bn6/hdvFYpjF9F4=;
  b=oGxFDA/s9CKqBWTMOIhOupixQYTvvy7g2XfwzsGIPADUnx+yYvpUPGyd
   0KGpWXBFAdbpCgO67btgZSgH3ZhDdFxUnXocLBoeqrrNjEPHBlTtPgYaP
   QAKtT2lbxHJr4mahlfaihmwJP6Kwpeb4oI9sVM7xqNaZNJKGY6+80JOpz
   WqLPnxgMVvTSxE21KQDbet5Xr+RsRljAC06Gw96aEFiPHrX5jF1CvORwU
   S00UtlGTXlAjnR5l2Hl7gWx7qDkM5BxnYVxzuGaGSyZnnXvEFi6faBjFC
   Bqiioewoo8p5UG1rEyayqWUA2+fziRlbgd+r76rpHvtUllhqOKrRlJedi
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="341282438"
X-IronPort-AV: E=Sophos;i="5.96,191,1665471600"; 
   d="scan'208";a="341282438"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 16:13:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="731269847"
X-IronPort-AV: E=Sophos;i="5.96,191,1665471600"; 
   d="scan'208";a="731269847"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by FMSMGA003.fm.intel.com with ESMTP; 24 Nov 2022 16:13:52 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 24 Nov 2022 16:13:51 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 24 Nov 2022 16:13:51 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 24 Nov 2022 16:13:51 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 24 Nov 2022 16:13:51 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dsWnHBvBV3nhdRMNLvwJBkN22Rrj1AcWqt/y1D4uvl86/jhLGJIpuKbYL02+M/7+ik2wQWq/7kgqTYq2OHCCl4fqwNXGYOtwWnmSP2KVj6smmh6oCVE970jfvwdsRoxKKVQrWz9qnkHMo5JY3ty7qD8QcpoMsU3gXP2jlJv2eORgUTgcXwyHz7nbei2hJPzvku7ADGpdbNJIqAoNUp5nR90L5Cg9U9ylCtFi6Q3rOKKacdXgaAkO2ZfWGVx4/5N4dO5tGO+6Gv02WI2fS6kQLCHVdZcvxASIPMPZ/+DV/2mNSou3RM9OMk7prCU+bqoldeJXKN9ZWLk7OnX5XM8XKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sHUBdusIZuXH0fnCcTNPqeuM2fv8Bn6/hdvFYpjF9F4=;
 b=cJvS1VEQKp5fK5h/iohD2FHE4zSdRUeSWjxLjkPyNqKUI94+RF2Vm1OWiGYSqisev7bGMANS5YNAxBx/y+ss6jJ2YvpN3ufWHUr1h31CUtJz+cL+jFh5BsPQVKfDJ5zLiMH72ScC10QgxGuGQXjN0SrS7oAW1VF5jn9Z+Y18Xr/WkHJlMCF6hSXMeTT33Ei531S3SoO5HKqlbhU/8J9upEAMQeWfYIcdMmlorrViAY+YtD0fDQu0RB4GW9ik4cS4Ys4CH0jLiVW98SQYXjDvz76CzEu8gI2WCTqXJJn+uCwNAeTW/qgKoCsoLjvT52NxKU4+zv+vrMuf6+5XinunBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MW3PR11MB4732.namprd11.prod.outlook.com (2603:10b6:303:2c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19; Fri, 25 Nov
 2022 00:13:48 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%8]) with mapi id 15.20.5834.015; Fri, 25 Nov 2022
 00:13:48 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC:     "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [PATCH v10 035/108] KVM: x86/mmu: Track shadow MMIO value on a
 per-VM basis
Thread-Topic: [PATCH v10 035/108] KVM: x86/mmu: Track shadow MMIO value on a
 per-VM basis
Thread-Index: AQHY7ChybP3VDS//1EK2niE1cyNWwq5KVsuAgASWdoA=
Date:   Fri, 25 Nov 2022 00:13:48 +0000
Message-ID: <887a77acc9bf96f7c7bea519ab7ebdd27fb67985.camel@intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
         <f1c9996fa4f4bc71b3feee8407d247aeabb8968e.1667110240.git.isaku.yamahata@intel.com>
         <Y3wvhWyIKNzczFov@yzhao56-desk.sh.intel.com>
In-Reply-To: <Y3wvhWyIKNzczFov@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MW3PR11MB4732:EE_
x-ms-office365-filtering-correlation-id: 5660a6c2-46f7-469c-18da-08dace79ecb4
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rUcRVE79sJRD7LhRXUcuBHU+I+eOzU3jK6gDJQLyzJJn1Ayd9gFHqjufrZCCCJZWzxlyYt5ePxGXq+7eRIk9MIo5hzRTwVX7serPqSlJzMLd9CyQSy2QZ8sJCiWCsUrX/kuqPSH1ADCHhXEX+Bq52oObNyF5lOEJ0NFafZuxWhUIpegYkT12Ipl88U3q9LZCNOq5rKoyIHTmdgCO5hH0SC+kVDnEbp3mMWTHfh/GEEEQJ6DObcVAf+B5zt+ClWvUVtve63YP/K6OPvKZWobTbcTDtRpBxQp4pNeSBhwluoqc0StMmg5vvIPaQRmstnQIE3Bwld+P9JX9F3Cpif5BwQdAd1RzrfoTp14HottT5ssjwpu8gAqAELTnicZkzcYpJgpkqEJZP704SeZ3CA1DQpuvR97dlBEwCWi6KY+xh4aww5Zws8as5uXcPlFd6CNiDguKJ1lR4K3n+oUkpc+l2TwPbCr9fM5OzIyS1LnoXdDtxAZ3xfm63PGRa45LWH6J+cpTFtVBmQw/UHpqt+qWf5poKkS1CTOej1W0E1medab7+MbDT8Kg90VCSuFfYANlKP3rvEmiS321a8eAIa4SECxJa9DqZ1pFz4r1EjGha7ZIj/b9fs2/oi7UPnW8XUzJ319JzgK1QG+n4UjOcQBlnZ3jedNUP7Nf96rqibMjb0CGCkmUAEEvEiBhcDaOlqSvvIDuZd032O0r59ukvhD0vw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(366004)(376002)(136003)(346002)(451199015)(38100700002)(122000001)(478600001)(6486002)(82960400001)(110136005)(66556008)(66946007)(5660300002)(4744005)(71200400001)(8936002)(83380400001)(2906002)(4001150100001)(8676002)(4326008)(6506007)(186003)(38070700005)(36756003)(26005)(316002)(86362001)(54906003)(66476007)(91956017)(66446008)(76116006)(64756008)(6636002)(41300700001)(2616005)(6512007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?N1dtVWVPamprRTloRVlVa1pxV2dxVFNLZjViOTFMRGdDbHBSWTZZUnFKcUNi?=
 =?utf-8?B?TUxVbHB4cHlDT1N1dUU5VW12SDB0cDFsd1ZIcjdMTWhRYlAvVzFHbldyY1A3?=
 =?utf-8?B?cDdjNUd0ZjNjY0ZNcjVkYmovTGFoQWowMmNnTmtnZ3lwOGVZalU2NnRkT1Ev?=
 =?utf-8?B?N05FeFczRi9NeUFPRmF0MU9EZmFJZ2hRZnEvZ0lUU2R4NWdoUWFVY29RRXNC?=
 =?utf-8?B?MWF1Q3VMeC9lRmJlMGpDUHY0aXp5OFIrLzROTFlJditaUDJQcGJZNVBnNmk5?=
 =?utf-8?B?a293Rm1RaWJLb3BPVWtsQlI1MU55dFdGaU5Mejlyb1p1UDFxRmIxdUU0b251?=
 =?utf-8?B?d2o3U1F2Wko3c0s2YUc4SVU2akFqUWpjWTBPR3NpMldPNEdqT0xEUlhBRjJK?=
 =?utf-8?B?NmQ5Y3htUE5SMi9qMTNOSmw3QkVmS1BjcU5UMkZSQWVIcVkwMkpMdUx2b3dI?=
 =?utf-8?B?ZnZXRnFhdTB4dUZha3dlcjZrOW54TmY0WlNHSWFPY0dkSHkvNnBuK053ZzQy?=
 =?utf-8?B?YnUyWDJJWUorT01FMlFCMHl2NkowVkJuOU5PNWc4ZSsyaTd6bERoWEdXb3V2?=
 =?utf-8?B?RmFGLzlSSHNWcDRVWkd2T09wS0QxLzZqUUY2dDg1Rk51RTRzcmRPMDhQNXVH?=
 =?utf-8?B?WmV3eUpNQ2pYVEtDbnRtR1JVZDFoak5qSjUvUWlNYXJZNXlkMmVrVW5tUWpP?=
 =?utf-8?B?ck93NGltMkVHaU5WcjQyZFZrZE1QQjlhUVB0UXV3c1MyWTlHT2pwcmN4R1hl?=
 =?utf-8?B?eW1WbGtabFI1THhsNkVtOE9TNEVBcE1wYW41WTNUNjE2MEUrcmE2WDROQ3hn?=
 =?utf-8?B?V3RYMm9INVdxbWJnbU9FTk41b0NjeDc3ZHhRZ2doQzZwck1rRm5pdDYvWGt6?=
 =?utf-8?B?aHV4WndMaUQ3dHNLZmZKMzVLTE91Mi94NGV2cnI1dk9jOE0rUGNjK0t6VFM4?=
 =?utf-8?B?L0FzNXpjdVZQZzBTai9jbExhY2NxNHdVZHhMd0lOazgvUWdoN3JJc0dGR1g3?=
 =?utf-8?B?NXZMWE83WE9CbDdCb1NTRjI2UENhYk1qendzLzhrV1ZFNGE3R0gyUTVuVnJm?=
 =?utf-8?B?ajF4dFJoa1hUNXIrZzllblNxbUV4QWZWdFFsTlhFT0wyUFVZc0FXemdiUGpT?=
 =?utf-8?B?bHdpbDdkQXZVQm5BdW9EWTROMkZMK0lCamh4akJpeE43a1dyQVo1czA5N1Zm?=
 =?utf-8?B?aVJkK3hvdGFRcC9nODJYbDR3S1lHeWs1dHMzUFBZMkl6eE5vTUdHdXQ2b2hO?=
 =?utf-8?B?Q1hjSTFtWk1vRVV0bTIySm0zVFcydlQxdVVRYmxRY09JKzJDOE0xa05IeXJj?=
 =?utf-8?B?bnNmTjBiejZiWHFDYUFSZHM5QW9WWndPb2tISmMvc3poMkFNQ1FNMG54cm9U?=
 =?utf-8?B?VlIwZWl1RGlNQVBmTkQwL25wbFVoMjB3VDVMa3I3aURibWsvamtxaTM5VTE2?=
 =?utf-8?B?RFF4L251NUgxZHlEYXVRZ3YzY2tvejlRV1ZIc1BmSzByNG1ON20vcWtUUDVL?=
 =?utf-8?B?UjFiUlFCM29HYU1ETWQ1bXBvWU9hOUdDcXNsbXRzc0k4Y2JIeFlYRlpWRENu?=
 =?utf-8?B?TW04UlQxTjU4aWxsLzZUVjdiMkk0bE5KSXp3S2Evb0p1aHlETGFzUlFqem1m?=
 =?utf-8?B?QklTVE5MUnE5SlFhbHdLdXJNRVNhOEJ6SGxCc3NLZFZkZEZlK3pkUU1iVGw3?=
 =?utf-8?B?S1JjMzEzZHhkMmorR084WVIyQjFCWnBIZGdBSjU3Ly90djFVNWJlcmVxWlR2?=
 =?utf-8?B?a09Vd1FZb1h3d05CNXdkakFzNmJpWDBoWVhGWStHOFB1dkxtem9McXpRQ29R?=
 =?utf-8?B?eFJSbFNZV05yL0s2c0k4QWM3STlTZkhLYzZUK1hDZVU3VDZDejExT1ZVY2hF?=
 =?utf-8?B?d0FJS1A2NjczM3ZGcStWRjR0dVhRT0x6ODZlbUR5OWpWUGhZOGRPTzRjVTJ0?=
 =?utf-8?B?eHRvZ04zMW5XOE1uS1hwRWFJcnEwaVdYemcyQ0twclU1M1paSUlldE9sVlk1?=
 =?utf-8?B?L2FoR0JLZUx4K3lkU1dhLzcya3hsU0VmS0gxUWU4T1dIUEs5M0dZeURIZFcv?=
 =?utf-8?B?cWxxcE94THhmRUpjS1ViZE1qNkkyeUQyRFVqYzkxSzB6L3NhQkpUcDU1SDRr?=
 =?utf-8?B?OWNTMnpIdVc1dE1KaFJwbWxkN3ErUFJLQ2xXbWtuMnZBOXZxVm9UMFIrQVhk?=
 =?utf-8?B?MHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E8A170EA28BCA048B0B360AC5DF9327C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5660a6c2-46f7-469c-18da-08dace79ecb4
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Nov 2022 00:13:48.3624
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: atGPhwllac3m7L+NzqSOxy2zEImKWJE66BTsyjjia3kwnsPh5hsaO+UiMPerEhcIZ9a3Iq4phTn+RqJ15lGWug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4732
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCAyMDIyLTExLTIyIGF0IDEwOjEwICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gQWxz
byBtYWtlIGVuYWJsZV9tbWlvX2NhY2hpbmcgdG8gYmUgYSBwZXItVk0gdmFsdWU/DQo+IEFzIGlm
IHRoZSBzaGFkb3dfbW1pb192YWx1ZSBpcyAwLCBtbWlvX2NhY2hpbmcgbmVlZHMgdG8gYmUgZGlz
YWJsZWQuDQoNCklmIEkgcmVjYWxsIGNvcnJlY3RseSwgU2VhbiBzYWlkIHdlIGNhbiBkaXNhYmxl
IFREWCBndWVzdHMgaWYgbW1pb19jYWNoaW5nIGlzDQpkaXNhYmxlZCAod2UgYWxzbyB3aWxsIG5l
ZWQgdG8gY2hhbmdlIHRvIGFsbG93IGVuYWJsZV9tbWlvX2NhY2hpbmcgdG8gc3RpbGwgYmUNCnRy
dWUgd2hlbiBtbWlvX3ZhbHVlIGlzIDApLg0KDQpTRVZfRVMgaGFzIHNpbWlsYXIgbG9naWM6DQoN
CnZvaWQgX19pbml0IHNldl9oYXJkd2FyZV9zZXR1cCh2b2lkKQ0Kew0KDQoJLi4uDQoNCiAgICAg
ICAgLyoNCiAgICAgICAgICogU0VWLUVTIHJlcXVpcmVzIE1NSU8gY2FjaGluZyBhcyBLVk0gZG9l
c24ndCBoYXZlIGFjY2VzcyB0byB0aGUgZ3Vlc3QNCiAgICAgICAgICogaW5zdHJ1Y3Rpb24gc3Ry
ZWFtLCBpLmUuIGNhbid0IGVtdWxhdGUgaW4gcmVzcG9uc2UgdG8gYSAjTlBGIGFuZA0KICAgICAg
ICAgKiBpbnN0ZWFkIHJlbGllcyBvbiAjTlBGKFJTVkQpIGJlaW5nIHJlZmxlY3RlZCBpbnRvIHRo
ZSBndWVzdCBhcyAjVkMNCiAgICAgICAgICogKHRoZSBndWVzdCBjYW4gdGhlbiBkbyBhICNWTUdF
WElUIHRvIHJlcXVlc3QgTU1JTyBlbXVsYXRpb24pLg0KICAgICAgICAgKi8NCiAgICAgICAgaWYg
KCFlbmFibGVfbW1pb19jYWNoaW5nKQ0KICAgICAgICAgICAgICAgIGdvdG8gb3V0Ow0KDQo=
