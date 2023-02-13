Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F3D26952D1
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 22:14:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbjBMVOB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 16:14:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229837AbjBMVOA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 16:14:00 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1750919F31;
        Mon, 13 Feb 2023 13:13:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676322839; x=1707858839;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=T5j4dobECzNEs28L4kBTXMN0iG3LDAzrInYeg0SK8z8=;
  b=lZffjTwx8xR4HVQ3dZn9KLxmWLrpF1f7XMSHbqU4jb6fVETo2uopMf/m
   M0VdDseNBLS/8qi7+c4TV6ximYbLiCvnfxRgycq+8Em0l8QpzQkz5msr3
   s1prpoXhFmA5ucrSwRz9JEGXT/A2q8cAOCfB+o7YdWiSjQ2fZvuvIE8YB
   IfIyTIC7+ZB8zEN7Xs0Z6qcdyGXservpN2DDjNvP2a7JJzkt4duj+OtK7
   E+VsopJe9A7sgq5dnV6tjpglIKBPbDDhfvPpzsZcNi5QQMBLbY/61NA09
   +TmIs8vpLTONtphbr2wVdJCYBU2dF8uqINdyOZs40uPQkWmF3M6Uu2VXe
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="319030143"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="319030143"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 13:13:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="701426402"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="701426402"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga001.jf.intel.com with ESMTP; 13 Feb 2023 13:13:57 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 13 Feb 2023 13:13:57 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 13 Feb 2023 13:13:57 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 13 Feb 2023 13:13:57 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.44) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 13 Feb 2023 13:13:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R9Mk5F5KquawARFKuxdDMHPk9JxGJk657l4QqtmTaSD0xtwrKUhKHj/Iwuu5S+jt5oU0VqEVE24V06lx2nMe+7RT9LduDtiuKdtdFteC6N2Ox6M1rFWUTtz30L1RXfLFQQt4O6Vnln/YBJO2F5lp1l53NN8nkxl693rvtORi2ElhxW4DZaSCiOJB9idAbE5sDk8b4znZFGUZhO4bR186sJMjrIj9ua26URyUUtsh7U4LWvXZZW0mlrXypER6/0GSBl2zraDf+8HYGjs6CBVRpL5OkedlnG3maLH4hipZodKljrffZXK/aqwQr0I9wa9Ny09lyBJb3QbWGfCLkFm78A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T5j4dobECzNEs28L4kBTXMN0iG3LDAzrInYeg0SK8z8=;
 b=iz+OVx5Mo3/g2XqeNdZcVtZCXH+gghbr717b1VfYQem22hnzhJDVKongxWkHhifKvMygf/NvHBoNTdhtcwesemJSekRSQJaOVkAdJwRuWJeEjBk0pDs4pumK5VL6s+4xue7UlOmk1Uhd/L1UVZtLjnuIRu0n1WbsJfKoEctSVuC52izdA+I/SCzkgg4RTzP14qq/6DUcFZ2r0Mb+A9+bZxXh7INa1tKw9+0PP8hXy5DG2pwr5v1E8R2Es1hjmX6GyCEOrsN27IeghAuRggx/ly8g7+DJujwVek/T+zrEflPbdt88VKr8IOude4FphBtXSdml8Ga1//g5QJUfY0h6Ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CH0PR11MB5562.namprd11.prod.outlook.com (2603:10b6:610:d5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.17; Mon, 13 Feb
 2023 21:13:51 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a%8]) with mapi id 15.20.6086.023; Mon, 13 Feb 2023
 21:13:51 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Hansen, Dave" <dave.hansen@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>
Subject: RE: [PATCH v9 07/18] x86/virt/tdx: Do TDX module per-cpu
 initialization
Thread-Topic: [PATCH v9 07/18] x86/virt/tdx: Do TDX module per-cpu
 initialization
Thread-Index: AQHZP5uucDbGOLsVDEixmYuAvdZDZ67NLNsAgAAwVbA=
Date:   Mon, 13 Feb 2023 21:13:51 +0000
Message-ID: <BL1PR11MB5978F562548EA22BFFD13970F7DD9@BL1PR11MB5978.namprd11.prod.outlook.com>
References: <cover.1676286526.git.kai.huang@intel.com>
 <557c526a1190903d11d67c4e2c76e01f67f6eb15.1676286526.git.kai.huang@intel.com>
 <2d9172c5-e1e7-bf94-c52b-0e9bc5b5b319@intel.com>
In-Reply-To: <2d9172c5-e1e7-bf94-c52b-0e9bc5b5b319@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CH0PR11MB5562:EE_
x-ms-office365-filtering-correlation-id: c49470b7-008f-45a6-4e80-08db0e0734ba
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ulEK36xN/WOLFaTYAj1KlkFcZpI9JEu+G8YsiBTdUGSJXd324CznruUBsEWLdHYwvz/CaUvgif7SA2Kz7C5w1PiFhMXxuvCOAWXZnmYfqIqrc05jCTTJtlEj27igg6pZlmILlbMV4Nx2y9FdwQgeV33L2b3pKuByHK1hFeuAKm+ajdscEcSMzmV8rgndBMaNYNjiOvb+caAgt/MoK81OOxjQCs2P1+IPcFnshReedggMBByrRKtDYlPskFJ2yZsrO34Hs5rdlcmqZ8p74oXWxuDSECklFPsUiXeY6Djf1NGCACp8vnysBUwMJSpiexCct+i8Cq9K92inc/YWlHjKB2xkTmBmm8Jbar/kHFkQcmJ08Mk3ctyI3yvH/y64VK2CHwJYQ4AulmESasZF40cTWFA1cTnoenrTToIeftdFp9RFIyLkL9+HBqeZheEQNOM783eoVbe6qy6QDQtQDR05hmNXeUh8X62ZqZQoEqC07/NOd0Tw9rH8T2hMk3rWdZypbTJD3J3pWZKTjkQP5IoFUSSq7ZLo69WsBL1OaIcdapO5UGsAdeDonc4i3e6l/EFuXCWyhOvhyeiQ+U+Nq//A1wvKIVH90fMAZgUSRa8KBVDVS3CZcrgt7cxwDOXIG/AcFbUtUijk3HI113JHNRILNKgEIQjf4+Bw9bF5iBLzm+JZdecwjm/45sapLXgcaDiozMOhm6DZTjctkn+XmjjOVQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(396003)(136003)(366004)(376002)(346002)(451199018)(45080400002)(52536014)(186003)(9686003)(5660300002)(8936002)(26005)(7416002)(66556008)(316002)(7696005)(55016003)(66946007)(478600001)(76116006)(33656002)(8676002)(2906002)(41300700001)(64756008)(83380400001)(110136005)(6506007)(54906003)(66446008)(86362001)(66476007)(53546011)(4326008)(38070700005)(71200400001)(122000001)(38100700002)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ajNkN2R3V3JVWFNMSWdNcVU5NGxKZldpY1IvRjNjZ0o0WTE5TTB0MmFpd3ow?=
 =?utf-8?B?RlRUY2VPbWlmcjE4QlhKZTduUkFVVmVXVFB3RVg0QkFZUzR1b1A4V3V5MkNF?=
 =?utf-8?B?VUlNOStQWWJrTHBlZDFzL2ZMSEJBbnhXN3Q1Q1k0S0VKZmVGbTNYanRJODNj?=
 =?utf-8?B?Y0xmamtzREVIYWowSkVpbTZsYUt4OXBrWUE5K0RuUTh4dmpyR28wcXpMV2d0?=
 =?utf-8?B?SjF6bUlEbm0vK2Z3dytTellpYndkU1dHb3F2RjA3NFVGZlFyMnhlNGN0NElN?=
 =?utf-8?B?Sk54ZTBNeVZ3UTBVSm01djA4U3JJRDV6SUFPeDdBZ1BxU0t6b3lXWTkvVkps?=
 =?utf-8?B?UTVZWlFtNDhGSmdlWjJuSEE1MEFLUEJSVlR4UCt4cE9CK29mSk81YlhtMmRQ?=
 =?utf-8?B?RkFiOFZueTU1T1pkV2VWRndvUWJyNVY5ZGsyemtPTWRabUVWZjZRa0ZSSVZP?=
 =?utf-8?B?UUVTaFh1ZzE0d29URTZBemJnYWdhOVNPUnFRNnUvZC9sMXhmT0FSZXpMZTM3?=
 =?utf-8?B?bCs1cGVOcW5oeitPaHY3S1dqbys5R2dSMXFJb2s3Nm43c2xiZmVBYWVRVUU1?=
 =?utf-8?B?VHlYV1ovS0hrUUxFaFM0R0pYVkxVODZsd2pTdVRMRmp6WGlHU1VoRlp0T0Rt?=
 =?utf-8?B?S1lMSTFqVTlhVVJxMkxCbXBFUUlIVGlMRW12ZkhOSjM3YlJqREhEdzBjellD?=
 =?utf-8?B?V0duaE96UG9Zcm8wVVBxTllqQUF1YWkwWUEzQ1ppdld5TDE3R0tsUWVveVFi?=
 =?utf-8?B?UFdjNTRXcXF2TWMrY1JvT1kwblp4a09jcTBKOU42ZWhzMW11amRhTHFkdzlI?=
 =?utf-8?B?Mm9OUm1LVzBlN2JXVEgzbDBRY2wyU3NzSXBxKzZTVExIcHZRNHZSQUFoNnlz?=
 =?utf-8?B?dml3UkdFUHFlcC91WlAzbWpPQ09mTGJsVC9GYWdFY2VhWURqb20vUXpwTHFj?=
 =?utf-8?B?UkZOem5ZSmZKWGtxSHpjNGNrMmhVbmNJYUJ1dEFjcDNVS2g3UTk2amZwaE5Q?=
 =?utf-8?B?K2wrQUlWZU5lRUR3WENtSWNEbEc5SXpJenlIRXh4bjhaS1YvVTFzUGU3Rmx1?=
 =?utf-8?B?RnFHY1ZQMlM0L044TjBOL0lyYndscUpidEtCNUljOG93OTJwZlJjV3E2d1dz?=
 =?utf-8?B?b1gwRXZNdVppZnRxOVBkSXMvbEFaOFMvV20wUmtmRnpwaTZneFVxWDFaMG1R?=
 =?utf-8?B?QlFjVnEzbVpuY21JT1NWb1V2N1Y3TFZjci9JZzBwWTBxSGt2cC9xR3h6cTRo?=
 =?utf-8?B?WjFiandoNVI4V3Y3Ym5CT09qSmJhOUhIeWVRMXViYkNobXI3RmNmRVFEd04w?=
 =?utf-8?B?ZzU5YVpsRVhqclJ1QWJEYWZ6Ulg3eFNjSkJsNHNLeS9nZ0owTTQzR0t2Mk1B?=
 =?utf-8?B?OVlZZDFxcmtRazNJWEM2WWE3N2dkNG1aWHRNYW5ucmVwTytaZElWTEtGNEM0?=
 =?utf-8?B?ak9vWFNXZnBSWnJ2NGduWHN2ak9UR0ZSMlNZWTZPK2Rubno4dkEzZ1FEK1NI?=
 =?utf-8?B?MkViNUdEanZaajBGRFpYbXhWRlR6UXNSNm55R3duNXMrL0VLcGJLNFJQUVBZ?=
 =?utf-8?B?SWo5TEdjYVE1ajluS3YxdVJZQWNPODNuVGpLSFpPcCt1UVNTU3dtcDVXd3RS?=
 =?utf-8?B?NHAwckRLU2k4YmxrbXdjalltRXpUektNRDAzMVVZMForTERsYlZZL2JJMEEy?=
 =?utf-8?B?Y1FDM3BvQWZSMmlkTlNiNkFhdzdzSzJRbVJyVGV0YWdXMEViWHFJNWM5TzV0?=
 =?utf-8?B?SWxQS3hUdG1QbUFxUXpuaGxtTHhYWnNRRjZVQ0VxanJDbUtkOGhmaVd1azFD?=
 =?utf-8?B?bUNYNjJ5TE1Vbjd0amtZK0tPaWxUSlY1RllMb1VWd1lxcnlnRWRBVk9aZkdX?=
 =?utf-8?B?YTRubTM5QTRmK2ZUbnJGS3dhNTV6WFYrMFJGRkQ1Nit0bjJSQXVITHdoV243?=
 =?utf-8?B?eTJCWGt1elNnNitOV2c1L1NHZEplTGhOUThwZmdQTWpEbDlPbjUrUlJDdlIz?=
 =?utf-8?B?TlhoZ3RQbEdQV2pMWExGMDdHeDJ1ZkJRYTRMZWplNFBxTzExMVlZN0hLajJ2?=
 =?utf-8?B?eDE2cStLWGtrNzl4ZlAyT1lyWm1NTE1xd1p1ZjlZKzVvT3dMVW0xOGdCclZ6?=
 =?utf-8?Q?27eeAOobp8Tn38UquW5+9qv6r?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c49470b7-008f-45a6-4e80-08db0e0734ba
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Feb 2023 21:13:51.4929
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MA4mO6Tku/NP7z+yc6plzKsEFo2Q5/IQ8DukZPwh6yOMj2YjhlMhiZTyIGDUtDcXrKZrKxUNtFfEGRlBLsEzDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5562
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBPbiAyLzEzLzIzIDAzOjU5LCBLYWkgSHVhbmcgd3JvdGU6DQo+ID4gQEAgLTI0Nyw4ICszOTUs
MTcgQEAgaW50IHRkeF9lbmFibGUodm9pZCkNCj4gPiAgCQlyZXQgPSBfX3RkeF9lbmFibGUoKTsN
Cj4gPiAgCQlicmVhazsNCj4gPiAgCWNhc2UgVERYX01PRFVMRV9JTklUSUFMSVpFRDoNCj4gPiAt
CQkvKiBBbHJlYWR5IGluaXRpYWxpemVkLCBncmVhdCwgdGVsbCB0aGUgY2FsbGVyLiAqLw0KPiA+
IC0JCXJldCA9IDA7DQo+ID4gKwkJLyoNCj4gPiArCQkgKiBUaGUgcHJldmlvdXMgY2FsbCBvZiBf
X3RkeF9lbmFibGUoKSBtYXkgb25seSBoYXZlDQo+ID4gKwkJICogaW5pdGlhbGl6ZWQgcGFydCBv
ZiBwcmVzZW50IGNwdXMgZHVyaW5nIG1vZHVsZQ0KPiA+ICsJCSAqIGluaXRpYWxpemF0aW9uLCBh
bmQgbmV3IGNwdXMgbWF5IGhhdmUgYmVjb21lIG9ubGluZQ0KPiA+ICsJCSAqIHNpbmNlIHRoZW4u
DQo+ID4gKwkJICoNCj4gPiArCQkgKiBUbyBtYWtlIHN1cmUgYWxsIG9ubGluZSBjcHVzIGFyZSBU
RFgtcnVubmFibGUsIGFsd2F5cw0KPiA+ICsJCSAqIGRvIHBlci1jcHUgaW5pdGlhbGl6YXRpb24g
Zm9yIGFsbCBvbmxpbmUgY3B1cyBoZXJlDQo+ID4gKwkJICogZXZlbiB0aGUgbW9kdWxlIGhhcyBi
ZWVuIGluaXRpYWxpemVkLg0KPiA+ICsJCSAqLw0KPiA+ICsJCXJldCA9IF9fdGR4X2VuYWJsZV9v
bmxpbmVfY3B1cygpOw0KPiANCj4gSSdtIG1pc3Npbmcgc29tZXRoaW5nIGhlcmUuICBDUFVzIGdl
dCBpbml0aWFsaXplZCB0aHJvdWdoIGVpdGhlcjoNCj4gDQo+ICAxLiBfX3RkeF9lbmFibGUoKSwg
Zm9yIHRoZSBDUFVzIGFyb3VuZCBhdCB0aGUgdGltZSAgMi4gdGR4X2NwdV9vbmxpbmUoKSwgZm9y
DQo+IGhvdHBsdWdnZWQgQ1BVcyBhZnRlciBfX3RkeF9lbmFibGUoKQ0KPiANCj4gQnV0LCB0aGlz
IGlzIGEgdGhpcmQgY2xhc3MuICBDUFVzIHRoYXQgY2FtZSBvbmxpbmUgYWZ0ZXIgIzEsIGJ1dCB3
aGljaCBnb3QgbWlzc2VkDQo+IGJ5ICMyLiAgSG93IGNhbiB0aGF0IGhhcHBlbj8NCg0KKFJlcGx5
aW5nIHZpYSBNaWNyb3NvZnQgT3V0bG9vayBjYXVzZSBteSBFdm9sdXRpb24gc3VkZGVubHkgc3Rv
cHBlZCB0byB3b3JrIGFmdGVyIHVwZGF0aW5nIHRoZSBGZWRvcmEpLg0KDQpDdXJyZW50bHkgd2Ug
ZGVwZW5kIG9uIEtWTSdzIENQVSBob3RwbHVnIGNhbGxiYWNrIHRvIGNhbGwgdGR4X2NwdV9vbmxp
bmUoKS4gIFRoZSBwcm9ibGVtIGlzIHRoZSBLVk0ncyBjYWxsYmFjayBjYW4gZ28gYXdheSB3aGVu
IEtWTSBtb2R1bGUgZ2V0cyB1bmxvYWRlZC4NCg0KRm9yIGV4YW1wbGU6DQoNCgkxKSBLVk0gbW9k
dWxlIGxvYWRlZCB3aGVuIENQVSAwLCAxLCAyIGFyZSBvbmxpbmUsIENQVSAzLCA0LCA1IGFyZSBv
ZmZsaW5lLg0KCTIpICBfX3RkeF9lbmFibGUoKSBnZXRzIGNhbGxlZC4gIExQLklOSVQgYXJlIGRv
bmUgb24gQ1BVIDAsIDEsIDIuDQoJMykgS1ZNIGdldHMgdW5sb2FkZWQuICBJdCdzIENQVSBob3Rw
bHVnIGNhbGxiYWNrcyBhcmUgcmVtb3ZlZCB0b28uDQoJNCkgQ1BVIDMgYmVjb21lcyBvbmxpbmUu
ICBJbiB0aGlzIGNhc2UsIHRkeF9jcHVfb25saW5lKCkgaXMgbm90IGNhbGxlZCBmb3IgaXQgYXMg
dGhlIEtWTSdzIENQVSBob3RwbHVnIGNhbGxiYWNrIGlzIGdvbmUuDQoNClNvIGxhdGVyIGlmIEtW
TSBnZXRzIGxvYWRlZCBhZ2Fpbiwgd2UgbmVlZCB0byBnbyB0aHJvdWdoIF9fdGR4X2VuYWJsZV9v
bmxpbmVfY3B1cygpIHRvIGRvIExQLklOSVQgZm9yIENQVSAzIGFzIGl0J3MgYWxyZWFkeSBvbmxp
bmUuDQoNClBlcmhhcHMgSSBkaWRuJ3QgZXhwbGFpbiBjbGVhcmx5IGluIHRoZSBjb21tZW50LiAg
QmVsb3cgaXMgdGhlIHVwZGF0ZWQgb25lOg0KDQoJCS8qDQoJCSAqIFRoZSBwcmV2aW91cyBjYWxs
IG9mIF9fdGR4X2VuYWJsZSgpIG1heSBvbmx5IGhhdmUNCgkJICogaW5pdGlhbGl6ZWQgcGFydCBv
ZiBwcmVzZW50IGNwdXMgZHVyaW5nIG1vZHVsZQ0KCQkgKiBpbml0aWFsaXphdGlvbiwgYW5kIG5l
dyBjcHVzIG1heSBoYXZlIGJlY29tZSBvbmxpbmUNCgkJICogc2luY2UgdGhlbiB3L28gZG9pbmcg
cGVyLWNwdSBpbml0aWFsaXphdGlvbi4NCgkJICogDQoJCSAqIEZvciBleGFtcGxlLCBhIG5ldyBD
UFUgY2FuIGJlY29tZSBvbmxpbmUgd2hlbiBLVk0gaXMNCgkJICogdW5sb2FkZWQsIGluIHdoaWNo
IGNhc2UgdGR4X2NwdV9lbmFibGUoKSBpcyBub3QgY2FsbGVkIHNpbmNlDQoJCSAqIEtWTSdzIENQ
VSBvbmxpbmUgY2FsbGJhY2sgaGFzIGJlZW4gcmVtb3ZlZC4NCgkJICoNCgkJICogVG8gbWFrZSBz
dXJlIGFsbCBvbmxpbmUgY3B1cyBhcmUgVERYLXJ1bm5hYmxlLCBhbHdheXMNCgkJICogZG8gcGVy
LWNwdSBpbml0aWFsaXphdGlvbiBmb3IgYWxsIG9ubGluZSBjcHVzIGhlcmUNCgkJICogZXZlbiB0
aGUgbW9kdWxlIGhhcyBiZWVuIGluaXRpYWxpemVkLg0KCQkgKi8NCg0K
