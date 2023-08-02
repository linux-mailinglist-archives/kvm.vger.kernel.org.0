Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C2C876C266
	for <lists+kvm@lfdr.de>; Wed,  2 Aug 2023 03:41:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231701AbjHBBlX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 21:41:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231674AbjHBBlH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 21:41:07 -0400
Received: from mgamail.intel.com (unknown [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AA95359D;
        Tue,  1 Aug 2023 18:40:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690940447; x=1722476447;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vKpHpvSJe2DUmvKBcJ2VLpczF7I6MWATZTGYOdi6dFU=;
  b=akpu3p4Yjr1Wg3LJsuN6HA5kXxDFI4D8LXpZMW/meGMTR4Mt7ipc6gT8
   geFah8c3sbITyIFxQG9shH9Xql/jIdtuku5S918QwYx1mGC3mHWKnijzt
   3evebSiBZkjnFo62P2oodydvfgL9XZEIEm1idXPSKCXggw2pErZueFqIs
   bEAkDpFk1aPHUL03TnGzm5M38Ki7AjRdcWhzVGRtsaxNbB5PQBtgI16l/
   SjXSUdVwLVCx2jPfMNr29DlOm1pacd6B21LAlUt1mVxoZpqY3Lke2mxSW
   BnniH7FAPntyQzAIfRqc5wvnI3dxwxtPKFdrZKbZpt0rTNujFnEQc3qt1
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10789"; a="369453383"
X-IronPort-AV: E=Sophos;i="6.01,248,1684825200"; 
   d="scan'208";a="369453383"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2023 18:39:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10789"; a="798891244"
X-IronPort-AV: E=Sophos;i="6.01,248,1684825200"; 
   d="scan'208";a="798891244"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga004.fm.intel.com with ESMTP; 01 Aug 2023 18:39:10 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 1 Aug 2023 18:39:09 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 1 Aug 2023 18:39:09 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Tue, 1 Aug 2023 18:39:09 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.174)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Tue, 1 Aug 2023 18:39:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ABmdN24BzVNCkTnW6SiN/gsjKWnrp1DY8GRewZ9WQWls1ngxf13gMSIjhUNv/agePMfAguNNPr4JatOkRsQL6VD8MJOS4H1IRbDIS0gv7xW+RjN5uteYFNrmYbg8tRbkXEJs/6QRfl74R4w7u4bULh1ZWQCGP1fdDwMyJmBtwtl9ouf2t7jc2DXMws+SG5ghY1g6JDiuxG6Kdoh1LhnuJjOAGFv4PUTqIgH7ugoyU9Ljy/SmuLk/O4Opwaj9Xu0QZbWEZSvq5d0jW6Vq6eCxNxni5tdQRieZKVY3+8Us8d5HFFEuhI4N2DZ2qe+aHbtMfkU35wOLTzwhUVZkujVebA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vKpHpvSJe2DUmvKBcJ2VLpczF7I6MWATZTGYOdi6dFU=;
 b=O1lK+3q7wFFRQBmOq54b3tKcKDwsXaLjjDtfKDnH+Ekd8U3glK51f9iNjeYdAzUbofuhohqwsN2MvfppIC38tI+IlTgDt7kJjJr4yiyAPPzpMfzMoRfO5IGYlMrvjhPzZC5729hrz+2mGhywGhuAcYMonFzf7LddvpNjmRmmwRI+lnn8LwUo2HW+q7KxIaCjR3CfFbS6W+v9x4TQ9mFh9H0SDei3W8+no7UddiKJL2Wor6Z/AzhpvPPe2+jRlU8fizzgph1nw0Mo2BVxoFsyjkeBF39ugymBswQgYpolPkk8/Mnr2T3Mxb38P9sC0xsQ59TJM/KZXJXMlcEbmkeP3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.45; Wed, 2 Aug
 2023 01:39:02 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed%4]) with mapi id 15.20.6631.045; Wed, 2 Aug 2023
 01:39:01 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Baolu Lu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Will Deacon" <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        "Jason Gunthorpe" <jgg@ziepe.ca>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Nicolin Chen <nicolinc@nvidia.com>
CC:     "Liu, Yi L" <yi.l.liu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/2] iommu: Consolidate pasid dma ownership check
Thread-Topic: [PATCH 1/2] iommu: Consolidate pasid dma ownership check
Thread-Index: AQHZxEIhfIdukOyCd0Ww2obftm7IEq/VAaVQgAANsACAASweIA==
Date:   Wed, 2 Aug 2023 01:39:01 +0000
Message-ID: <BN9PR11MB5276B0865C9D8DC9060BF1A08C0BA@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230801063125.34995-1-baolu.lu@linux.intel.com>
 <20230801063125.34995-2-baolu.lu@linux.intel.com>
 <BN9PR11MB5276D196F9BFB06D0E59AEF28C0AA@BN9PR11MB5276.namprd11.prod.outlook.com>
 <36fb3548-7206-878e-d095-195c2feb24f1@linux.intel.com>
In-Reply-To: <36fb3548-7206-878e-d095-195c2feb24f1@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH0PR11MB5657:EE_
x-ms-office365-filtering-correlation-id: 1f877808-84b7-4c4b-a314-08db92f93fdf
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6++UBDmwie5B+P+Hyd8UxU2j+dt4Ysf/zO14gkbWJ0UMYOVp0+maNy4SB+MG3Fl6weuhlJH3fNc6BylZIvkz6Za3hbEuGoj4D2Bv4kJIsPKo/N5PFa+GrGCzlo0SgDZLcHXhAeS9cCvZkGIS7GcdjrIwo+0onx40FUlpHy9tP+/LQ9E7guREYKkgDmayI913G5AzHy9K3PlSUmQ82fTQS/8hWLyJgRzEZK+xfBv4QCCVEkJ9fBbix0xMMsfOzA1aeQW74nXn8KqLGKD2Qw5DZeidnk65NSTOrWIwCAzSepQcqOYBVXaqIFKaI1uVlTT8F545EhWrcA9SKvRGJW7OZVr2IU5FnLWxpSZ7TnpVsC0m170hdl2z1wbN2oCCf+0tq5y8VtOYAD8hHbmStcB/sSfZD2Z2sVofAlGlFv7wL2jyqtegTXMueivoux+GUs0b0F0j2Fh5qy/k98rJKWypKqFRIshVmVx7JAwBrXmHTazTigFfEP8saQIROhBFV8n/rLUNul/64WNsQWlJ4dimc0M5kQwpk1gPfn3JwPD4WyZJIRPOmEQ7cl+f32yqY6BkIboMbgS7MoJUipmX3FgV7DufPJWfhB5fQmUpd5Zngnh+Mwdo+DRuBy2FwBYizgiN
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(376002)(366004)(136003)(396003)(346002)(451199021)(55016003)(186003)(9686003)(316002)(86362001)(478600001)(122000001)(54906003)(110136005)(38100700002)(76116006)(71200400001)(66946007)(66556008)(66476007)(66446008)(33656002)(64756008)(7696005)(4326008)(82960400001)(6506007)(53546011)(41300700001)(26005)(52536014)(8676002)(5660300002)(8936002)(2906002)(38070700005)(7416002)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dndJVzM3anNmT1F3bVlDeEx2VTg0dms5SDAzeWsrcWdMazl6d0tpSk9XM0dR?=
 =?utf-8?B?TUFwM2h5YUhjNTBzNktrYlpudHlUVklIYnJFN2lVazlPaGVMK1FvMnpwNXpZ?=
 =?utf-8?B?cU1GNGJRVzhuMERRbXVLSUNzcU1Bem1iV0VvNFdndk5MUm4wc3pNeFdiOWtx?=
 =?utf-8?B?QlJrdTgvdVpxbzN2MnVBYmZQbTJTNVhQbU5aSXhUVU9rTkZ6dUlYczJxUmE4?=
 =?utf-8?B?WTNRNmR1anBQbjhXaHB1dmRlb3hyaUZqejJ2YmZPUjZ5WmxLNnBTNFZ1Tlhr?=
 =?utf-8?B?NU43d1lRNHgyWmZ3ZzgxRTR3cFpxK2UxbFpwRWxVMVNmWXJBZzI5dEJFOURB?=
 =?utf-8?B?OElFaGFHQWpraGVUdXk4M1NIU00rVnZBSFppVlZyclFJVG81cXY5MUpLZVZq?=
 =?utf-8?B?NUlhWUpuVkNTTkRPK0FDUG1pUlZGVmdsbjZlaUVDWC9OZGVDampkWG82bit4?=
 =?utf-8?B?a2lscGwvL0VtT1U4aE9NbjA0aW5NdzltdnZuSy92R1JBeFVYdlZ6czBzVzlB?=
 =?utf-8?B?cnRjaVY5d3dHM1MzVEs0R0V2T0JYc1lqTWJTRlZGdnExQkoyYmxCbENUSU81?=
 =?utf-8?B?Q0dsMkRFR3RZWERKRVlsSXZXSUltZ2ZKdDNyZWtJYzlYRzBPOTJvWlZqbUFR?=
 =?utf-8?B?Mlk5ci83M2NLRVBkMVpFa0tSSmdYcWhDWFJmWURRL1ZsL3VMTVVpSStXMkRC?=
 =?utf-8?B?S2s0eTZ6YjRuemEwSXdNWFhlcDVZY2ZCbGZVNzVOa1Y1VCtuV3ExTzhoK3hX?=
 =?utf-8?B?aUp0VldZRmc1dkowTklPUjJLSnJJT3V6VmRheCtyMDM1elgzOFRKbFdiYSsv?=
 =?utf-8?B?SVpVNGVzczJJZmxvU1VaNW02Y2ZzRW1XV2lGKzYvYW5ZMFZTRU9NdVdPcWtp?=
 =?utf-8?B?cHBFa0VXWWhZVm5sZWc2b012Z3lsSlNua0xORjRUZlIva0J3M2hNc1lBQ0Ra?=
 =?utf-8?B?ZDNXUWUxc0trS0hIRjR1cjZOVEdXUWFHbEtmV1BheGd3ek1vU045VVFzSllO?=
 =?utf-8?B?dzJMUXhuR3hkSmxwVkwrMWRPWGFhbXN4Mk40R3Ivem93TEJacXZyMFJjK2Ju?=
 =?utf-8?B?VkRzNVNFUE0wY3c4UDFPRzFkSEQwWHhKVStjU085bW9YeU1yemo1WCtSclps?=
 =?utf-8?B?UHk4WkQ4WUpmVHJOQ2VycCt5UXJJV2twUkYwNk9RMXd1S0ZJQWwyaXU4RXgv?=
 =?utf-8?B?QkwwT09HSEEvRnJWV2hNRGw5TFBZeWk5TXEvNG1UUGNsL1dpclpLSGJnWWpB?=
 =?utf-8?B?dERTckRMcEthNzNyeFNzQlZMSTRVdnFYUjNhMHZiU2NjeFBRY0xmd3N2NWVu?=
 =?utf-8?B?Um4xUTFBdk9XazI2V0pYWG9iR3JzUk04V1MyaTczTTFnM3h1TDN4M2c5WVVo?=
 =?utf-8?B?QTZ2NUQrdXljc2JKQU9GenRybEZBOVlGK2NxTmxwOTBrb01QaCtCMkZCZFE3?=
 =?utf-8?B?cE1hSEc2SjJidEZVSTR1d3RrWDJXT0RVOFFiZW1XRXlNeWRnanBDRjkwRlM4?=
 =?utf-8?B?NUMwZ3l4UXFXdU9XRGpkL3pWVUJ3RnMxNWRMamU4OUdpWHE0WUpyZDEzTTdP?=
 =?utf-8?B?Ny9zU0Zja3QrRHNhMzAxdCtVZG1YTTdaQk9TVTBBZ1hGd2tpV3labWd5eHBJ?=
 =?utf-8?B?RTBQUkJHbFRwZ3A0NnBtUFEwWm5mZUtndWJ4dXovektpMUpVQWNmMzF6Vk9z?=
 =?utf-8?B?NHRNTjQzdmhuK3dlQzBoT3BleHdQTkRiOFF4Y3M1N1VCYllwb2phYlJndVFT?=
 =?utf-8?B?M25HTDlwVzB6aTZ5cVFUaTNMeHZqcjFYaWlySWFMTUxmcEppcWYvbVBDN0du?=
 =?utf-8?B?K0VXdTFNRUprK29Ka3RWemRpNHMyN0grb1MyTFJxczVwbEhXMlhqREFVa1pB?=
 =?utf-8?B?ZEg2NVhUQTU3VHdhK25CbGd3a1cvM0dKK1BwUmJjMS9uYU9HN1ZQMnFKYVVH?=
 =?utf-8?B?VU5pcHFFVThVMnYwRnhCTFF4Y3V6KzJuYmY5SXdJVnRvWGhGdmEreDQrQ1RP?=
 =?utf-8?B?T3lXYittdXQ5U05mTFlnTDNuc05CcHM5RS9COEhpUW9na1ExWXowUFRHRVlZ?=
 =?utf-8?B?ZG4rMUVrcS9OT09wSzJRZ3I1cGRKUjhHbjJHUlMvWk5pK1FxTW13cEZmUDhE?=
 =?utf-8?Q?rsSU9NPEW1LQMYxUy5ev8cOf6?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f877808-84b7-4c4b-a314-08db92f93fdf
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Aug 2023 01:39:01.9178
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SVx11qo49sxuvNAFcEc7f3RR8t7Rx3SHxL5nnLbtksmM5AcN3vtnjdKEDwwRKf/bXjbEYcDRYlzBQx+SGaCxvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5657
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

PiBGcm9tOiBCYW9sdSBMdSA8YmFvbHUubHVAbGludXguaW50ZWwuY29tPg0KPiBTZW50OiBUdWVz
ZGF5LCBBdWd1c3QgMSwgMjAyMyAzOjQ0IFBNDQo+IA0KPiBPbiAyMDIzLzgvMSAxNTowMywgVGlh
biwgS2V2aW4gd3JvdGU6DQo+ID4+ICAgLyoqDQo+ID4+ICAgICogaW9tbXVfZGV2aWNlX3VzZV9k
ZWZhdWx0X2RvbWFpbigpIC0gRGV2aWNlIGRyaXZlciB3YW50cyB0byBoYW5kbGUNCj4gPj4gZGV2
aWNlDQo+ID4+ICAgICogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgRE1BIHRo
cm91Z2ggdGhlIGtlcm5lbCBETUEgQVBJLg0KPiA+PiBAQCAtMzA1MiwxNCArMzA2MywxNCBAQCBp
bnQNCj4gaW9tbXVfZGV2aWNlX3VzZV9kZWZhdWx0X2RvbWFpbihzdHJ1Y3QNCj4gPj4gZGV2aWNl
ICpkZXYpDQo+ID4+DQo+ID4+ICAgCW11dGV4X2xvY2soJmdyb3VwLT5tdXRleCk7DQo+ID4+ICAg
CWlmIChncm91cC0+b3duZXJfY250KSB7DQo+ID4+IC0JCWlmIChncm91cC0+b3duZXIgfHwgIWlv
bW11X2lzX2RlZmF1bHRfZG9tYWluKGdyb3VwKSB8fA0KPiA+PiAtCQkgICAgIXhhX2VtcHR5KCZn
cm91cC0+cGFzaWRfYXJyYXkpKSB7DQo+ID4+ICsJCWlmIChncm91cC0+b3duZXIgfHwgIWlvbW11
X2lzX2RlZmF1bHRfZG9tYWluKGdyb3VwKSkgew0KPiA+PiAgIAkJCXJldCA9IC1FQlVTWTsNCj4g
Pj4gICAJCQlnb3RvIHVubG9ja19vdXQ7DQo+ID4+ICAgCQl9DQo+ID4+ICAgCX0NCj4gPj4NCj4g
Pj4gICAJZ3JvdXAtPm93bmVyX2NudCsrOw0KPiA+PiArCWFzc2VydF9wYXNpZF9kbWFfb3duZXJz
aGlwKGdyb3VwKTsNCj4gPiBPbGQgY29kZSByZXR1cm5zIGVycm9yIGlmIHBhc2lkX3hycmFyeSBp
cyBub3QgZW1wdHkuDQo+ID4NCj4gPiBOZXcgY29kZSBjb250aW51ZXMgdG8gdGFrZSBvd25lcnNo
aXAgd2l0aCBhIHdhcm5pbmcuDQo+ID4NCj4gPiB0aGlzIGlzIGEgZnVuY3Rpb25hbCBjaGFuZ2Uu
IElzIGl0IGludGVuZGVkIG9yIG5vdD8NCj4gDQo+IElmIGlvbW11X2RldmljZV91c2VfZGVmYXVs
dF9kb21haW4oKSBpcyBjYWxsZWQgd2l0aCBwYXNpZF9hcnJheSBub3QNCj4gZW1wdHksIHRoZXJl
IG11c3QgYmUgYSBidWcgc29tZXdoZXJlIGluIHRoZSBkZXZpY2UgZHJpdmVyLiBXZSBzaG91bGQN
Cj4gV0FSTiBpdCBpbnN0ZWFkIG9mIHJldHVybmluZyBhbiBlcnJvci4gUHJvYmFibHkgdGhpcyBp
cyBhIGZ1bmN0aW9uYWwNCj4gY2hhbmdlPyBJZiBzbywgSSBjYW4gYWRkIHRoaXMgaW4gdGhlIGNv
bW1pdCBtZXNzYWdlLg0KPiANCg0KSU1ITyB3ZSBzaG91bGQgV0FSTiAqYW5kKiByZXR1cm4gYW4g
ZXJyb3IuDQo=
