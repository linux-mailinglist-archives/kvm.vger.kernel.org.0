Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A742783BB0
	for <lists+kvm@lfdr.de>; Tue, 22 Aug 2023 10:24:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233795AbjHVIY4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Aug 2023 04:24:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231920AbjHVIYz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Aug 2023 04:24:55 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30A5E19C;
        Tue, 22 Aug 2023 01:24:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692692693; x=1724228693;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Hl0zISkZGD0Vh9RxW4srsvre9nKZ6YrfXsj/t6GP0iA=;
  b=RCq1VPmL9MzqKbhmDP9ungY7uRMNCrZ5S2GRT65RbfcvFAxfGhQ/yNoZ
   PaDgpNOzsVVoIDOqudw3bnOZnQafukDwoPQ0+6mIa1bplxa3qXhowvgS0
   L/8+wEn8tABYs9edTh0yDGv9gQzuF+mkZQBZSPtE8+Xy+RydYpTu6gZjo
   anOFNmCvnbtuslGZekxkkjhoGTKPu8WNGvrdNUCPy1EVFUSXHc9sTgXX3
   zRniCEYmNkgljBLWirZLVKJRbA0QNz1ZeoIoE0VE75GcXwtfoA1yhgDmE
   Fc/7YhCNFiXyerzhUsD28mAxUxgOeo8mP+4CI7CdeswouL86QyIpBg19S
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10809"; a="358811026"
X-IronPort-AV: E=Sophos;i="6.01,192,1684825200"; 
   d="scan'208";a="358811026"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2023 01:24:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10809"; a="806193869"
X-IronPort-AV: E=Sophos;i="6.01,192,1684825200"; 
   d="scan'208";a="806193869"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga004.fm.intel.com with ESMTP; 22 Aug 2023 01:24:52 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 22 Aug 2023 01:24:51 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 22 Aug 2023 01:24:51 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Tue, 22 Aug 2023 01:24:51 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.45) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Tue, 22 Aug 2023 01:24:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V+oZnPgww53JnbFnkpFh11E0BnpV/WPXm0cLcKoucq9SGB/LOoGyCUbJrNqxzTzTANxtsxJgF6nRePaJ95yMZoLnEPZ4Mm6Cc7Hjh5pL0QL9AiqzqS9yE5p3yNQtvjij/ULS6UseNjBbSaS1WmLGhQ/3Lw60PZ1O49yhBiMPSEUUH5Sm5b4QuBwiT6/9VSnIMMhX/1y/AujlW/D8Lc8OjkH0q9WMeHNLrBRLzfnv5JlPzg111kz8sXFgQXih6s04kVZXTGc9c+AXEVvaXUGHitVdptv1JRF7CWws0iTZaXys8Zv/OqR5nTjHJrH+lXkp5q7KLSuZPye/nfQdkrhcPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hl0zISkZGD0Vh9RxW4srsvre9nKZ6YrfXsj/t6GP0iA=;
 b=ec1S8ck3MmOquuZEJgDp9KYs6tfNZP9KqOI4VOILSYijDhP4Agv2pZ2HFs1/IrEbiTnzHXHh1Ai8A4d8apn2jEalEtfS1/oE0pd4SgoU/C+s/kwKEG8A8MtODkdHrtIO7arwwDmWo+K3zl9zpCY42TMNaGPtbweeer2GbC8pcKgmmXM0OUjtxdnbq0gJ8bJCqwa9oI5knrQS0fTOwSgbCB9W4g4rp1gNNMktMRczt0v1UdUG2gXUHO41mI6rF1kgInGVtmqtKoMnebAb5BVPechinnpypExSkAtHTtpyjAy8pj9nK4wP0k3xIXniQv4ivRNYUwSFXZvpnDz+xERbjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MN2PR11MB4536.namprd11.prod.outlook.com (2603:10b6:208:26a::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.24; Tue, 22 Aug
 2023 08:24:49 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::dcf3:7bac:d274:7bed%4]) with mapi id 15.20.6699.022; Tue, 22 Aug 2023
 08:24:49 +0000
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
Subject: RE: [PATCH v2 1/3] iommu: Make single-device group for PASID explicit
Thread-Topic: [PATCH v2 1/3] iommu: Make single-device group for PASID
 explicit
Thread-Index: AQHZzk2NHVN7+Xla/Uen90/PQyM06K/vcbqggATWyoCAAA098IABk6cAgAAdWTA=
Date:   Tue, 22 Aug 2023 08:24:49 +0000
Message-ID: <BN9PR11MB5276CFED0281AA06E0EB14A28C1FA@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230814011759.102089-1-baolu.lu@linux.intel.com>
 <20230814011759.102089-2-baolu.lu@linux.intel.com>
 <BN9PR11MB5276E3C3D99C2DFA963805C98C1BA@BN9PR11MB5276.namprd11.prod.outlook.com>
 <51dfc143-aafd-fea2-26fe-e2e9025fcd21@linux.intel.com>
 <BN9PR11MB5276EBE5788713FBA99332F88C1EA@BN9PR11MB5276.namprd11.prod.outlook.com>
 <93811e0c-ff04-366d-493e-7186e4588359@linux.intel.com>
In-Reply-To: <93811e0c-ff04-366d-493e-7186e4588359@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|MN2PR11MB4536:EE_
x-ms-office365-filtering-correlation-id: 01c97be1-263d-49ca-c14a-08dba2e9404b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qx+m3g0dXEF0TxnN62Gh26tpF7N61mbPQoHpUptBRg+pWETbaiKRMFO+8lhsmhxCGUYIGsKLJEWQFqG3A49x8sCd/m49eE+UzqAOqpWS/jRIzqSnGbUsOOdEwElpdoK1kneSC/g0hy0KXd5XphyLXv9JXq7Wv9DOrCkt+9NZsAD+y56PQWBk8keK7PRprU610104mncdMCdsFg/LPWqRGZeeXaeNuKHruhPas25x1z6ek1g1YeZElf1QXLtP6v5AXJZvUNEfFPoq5K0NrEj34hj0jtO6xg9rSZeViUB7D73p1rSCVt7P+Es3AF4ncRfPwFM3VZDAewQMQrsPRvvds57Drp2cfbMvVqV9UegADGLRbpYUMCtHjWXxzHngOh7Z3Xx2DkFiiqyE9qH8/gpEsVk5lWSj3g84fWqipvE62wsKyYi0Qfa66DaUaooNRqG6L1kC4WR1Pz5RHQ9E+cVIBn3/MLY/PSVk/vyrPSdXre8gXiMYsbfgvLS5ei+UNdpIPyGIkPmNBhCvzO+PApabFBw7KM6aBW3yRKPmn/nyAJ5j2SkMY6/ivHZz8VHeu+MkzPA/2V1TVgeIgxaF51Cxfgn2FBcSuZnSMIrkHudTUFk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(376002)(346002)(39860400002)(136003)(396003)(451199024)(1800799009)(186009)(2906002)(7416002)(53546011)(38070700005)(38100700002)(6506007)(83380400001)(5660300002)(52536014)(33656002)(26005)(7696005)(86362001)(8676002)(8936002)(4326008)(316002)(9686003)(66946007)(64756008)(66446008)(54906003)(76116006)(66556008)(66476007)(110136005)(82960400001)(966005)(478600001)(122000001)(71200400001)(55016003)(41300700001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NklVSFRPbndQclNmekZSNGhwTUd5VlpCNmJ6YldBQktMZTdaTEs2ZVh3TVlX?=
 =?utf-8?B?aGFyQlMrSUhUeDZTVTUyMTBVQkVpY1hEaWUvWXA2NEVXL01iYTlqcFh4bUVk?=
 =?utf-8?B?MVg4THpteVdkQ2ZrYzY2aFcwRGFabWJLWC9ra0FzdisxM0pyYUtpOTVGN1Vv?=
 =?utf-8?B?Z2k1Mjk1T2kzd3lucW5zTWxBd05FdmNxSEpiamlBUjArVS8rR1RLTDhUdnJO?=
 =?utf-8?B?Z25EQ2ttNWtKVUdxSUxsdHduZDNrT3RNUG1paWJFWmFadVJEaytkb2xBLzFK?=
 =?utf-8?B?V2UwdnhIU1VHbDZSVDhJNHpPZkFYMEYzUXg5Z29MOFQrd2x2VVRZZjdINk5I?=
 =?utf-8?B?UFF2T09TYzlqR08zNC80Z3hvcVk2VHJJZlJUU2JkbTJ4UUZFZEwvSnMrakxK?=
 =?utf-8?B?bWVJZ2lySWE5M09ZZjFYanJ1N25DZXBlREtEMVBKajZoK2piNXlHcGZId3Ir?=
 =?utf-8?B?SjdWeUtwbTZBVmJKa1NhZzZQYnlGNnRRclVJMnp5a1BaSUNNU3dRZ0ZaaUx2?=
 =?utf-8?B?YWxqdS9HODFaTzlkUXpmaVpDRXR5YUY1VmpFaHpBZk9JRG82cy9zYXMyQ0Ev?=
 =?utf-8?B?T2JVS0IxMHdka3RHQ0hwREZwQ0hrdE1iMkxIdkNuSUhqa3VkbmMrMmlVMXlN?=
 =?utf-8?B?Sk1tbWxlLzczS2wwOUNzYXQ3ZWxMUll3d0swWjFGOUU4WEJBZER4dGMzWmoz?=
 =?utf-8?B?NlBKWVgxalFVc1ZjOE8wek84SW5iKzh1L0JZbjNUN1ZYVHVpS25OQ3g5Vmx4?=
 =?utf-8?B?TjFObjJpcjBDOTVxdnVlVWhhWExTVVEwWlA5S0daa0d3WTZpbk14ZjBhM1lW?=
 =?utf-8?B?YnB3Y2I2SjMwT1V3dVdZQjFlNzVvaFg0RE9ZY09WYlBDUjhkY25uTGx3UDMr?=
 =?utf-8?B?RkVtSm9hZVlZYms1eU5uSlJ4MURDa1EvWDBLeWlaelA3VlhablJQaHE5eUhw?=
 =?utf-8?B?cXVCMFY3bnJjN1VTZlI3UGt1eURBLytpZDJmb3g1OThSSUViUkVTREo3WUFm?=
 =?utf-8?B?VkxWYnEyTHhKVjhpN1RHbmRkdnIyRE5TcUx1am1hcUxpVlJtakg2SkorcjlK?=
 =?utf-8?B?MmxkQ3RvUEJwa0dkZTNPNDZsWnVUY2gvMjFMOUpnOFE5Tm9WZHJlaU5LcjJL?=
 =?utf-8?B?ZzVGYkFSSm5WbTRjUWpPd0pBeGF6clJ5SWRZYUswNnBTQjBueWlOWnBReURj?=
 =?utf-8?B?OXZvcThYbEwwM1hFSWVSeFc0TkdpRjNsZ1NmbHZVa28xQkF1bXBTZEhUTVRB?=
 =?utf-8?B?Y2RCMGQ5OHVjRmpiRW1QYW5QdTFpZW9LeTJhQlhpbTdCQTY3YWgzbGJDOEM2?=
 =?utf-8?B?TlBUbUo2ZlYzcGxYS1haQTR6RWpweUY4SEJza2ZZWGVOQ3NpOVV5SjZjMUhz?=
 =?utf-8?B?T0hkUVJQV1hXZkg2MzJZcVAyQWxFajhqUGdDb2I0cEpLZ2NwSU9VU2Vhckgz?=
 =?utf-8?B?eEtBNnJ0UEdQbzNJb1VRd0tESHRJYzdvV1h0THl6UnlpdzBzeG5wa0lJZnhJ?=
 =?utf-8?B?QmFLcmZ5b0pxZ29nczcvY1JqeUd1Q0dLQTJ6bjh0NTAreHFIUE14eTA4WVR4?=
 =?utf-8?B?bnVYRnpxeVE1TW10UlRhVDJzbDh5RGxIUkY4ZFRYL0hmR21FU2pZL3kxdERr?=
 =?utf-8?B?TEhhZXI2S0xKZnl1eWh1VFVKMktHT1hMcmdUTDFTVzhmT2ROaFhlcnZ4eTVq?=
 =?utf-8?B?ZWZlVm1RUE5rZDQ2QTRGd3BZWEhjTm1sTEdWR2VreWFTRDNuaHNXanF0aTZC?=
 =?utf-8?B?OSsxQTlLQnFva3FsZy80MHZvYTdhK0Y4N2t2RXVsVnlrb0M5WGQ5NnJYS0Nl?=
 =?utf-8?B?MEFybUtDNTJON3VQTGFxYVMxUFBLakQ4bTQ3aXFwNmI4UE5weEEzcTZtYWZG?=
 =?utf-8?B?aXlXcVhtRjArZS9SMDV4MDc5dTNaN2daOVZJeGhOYWdKYnRadGhvK0syamdx?=
 =?utf-8?B?SThmbkhZMFhlRHgwZ1ZMZENjZDhEZzNoRThoeFpJVWR1elU5blJid1B0L3JN?=
 =?utf-8?B?a3g2bW1yS1FXaExGWm9iK0pFNE9oZUtnODVFZTJJRXRVR3RidjN4eVpoNE5n?=
 =?utf-8?B?NUVUdVRoSnZLSlRHK3NDajJ4aXJSRG9LeUhQdGxxZ0dtNnZEOHZXaDNUc2Rp?=
 =?utf-8?Q?Zbk2Y3C6zwk9N4lZJzMmhRD+g?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01c97be1-263d-49ca-c14a-08dba2e9404b
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2023 08:24:49.2631
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CP/NCl4mymKCywEXC2OS3/cTyVgfF8uaC2qJnoDURaMMyWBaz0RtK3Tizq2S9GWNL9M/a4FdicJhQbxcWpi/Dw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4536
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBCYW9sdSBMdSA8YmFvbHUubHVAbGludXguaW50ZWwuY29tPg0KPiBTZW50OiBUdWVz
ZGF5LCBBdWd1c3QgMjIsIDIwMjMgMjozNyBQTQ0KPiANCj4gT24gMjAyMy84LzIxIDE0OjMzLCBU
aWFuLCBLZXZpbiB3cm90ZToNCj4gPj4gRnJvbTogQmFvbHUgTHUgPGJhb2x1Lmx1QGxpbnV4Lmlu
dGVsLmNvbT4NCj4gPj4gU2VudDogTW9uZGF5LCBBdWd1c3QgMjEsIDIwMjMgMTo0NSBQTQ0KPiA+
Pg0KPiA+PiBPbiAyMDIzLzgvMTggMTE6NTYsIFRpYW4sIEtldmluIHdyb3RlOg0KPiA+Pj4+IEZy
b206IEx1IEJhb2x1IDxiYW9sdS5sdUBsaW51eC5pbnRlbC5jb20+DQo+ID4+Pj4gU2VudDogTW9u
ZGF5LCBBdWd1c3QgMTQsIDIwMjMgOToxOCBBTQ0KPiA+Pj4+DQo+ID4+Pj4gVGhlIFBBU0lEIGlu
dGVyZmFjZXMgaGF2ZSBhbHdheXMgc3VwcG9ydGVkIG9ubHkgc2luZ2xlLWRldmljZSBncm91cHMu
DQo+ID4+Pj4gVGhpcyB3YXMgZmlyc3QgaW50cm9kdWNlZCBpbiBjb21taXQgMjZiMjVhMmI5OGU0
NSAoImlvbW11OiBCaW5kDQo+ID4+IHByb2Nlc3MNCj4gPj4+PiBhZGRyZXNzIHNwYWNlcyB0byBk
ZXZpY2VzIiksIGFuZCBoYXMgYmVlbiBrZXB0IGNvbnNpc3RlbnQgaW4NCj4gc3Vic2VxdWVudA0K
PiA+Pj4+IGNvbW1pdHMuDQo+ID4+Pj4NCj4gPj4+PiBIb3dldmVyLCB0aGUgY29yZSBjb2RlIGRv
ZXNuJ3QgZXhwbGljaXRseSBjaGVjayBmb3IgdGhpcyByZXF1aXJlbWVudA0KPiA+Pj4+IGFmdGVy
IGNvbW1pdCAyMDEwMDdlZjcwN2E4ICgiUENJOiBFbmFibGUgUEFTSUQgb25seSB3aGVuIEFDUyBS
UiAmDQo+IFVGDQo+ID4+Pj4gZW5hYmxlZCBvbiB1cHN0cmVhbSBwYXRoIiksIHdoaWNoIG1hZGUg
dGhpcyByZXF1aXJlbWVudCBpbXBsaWNpdC4NCj4gPj4+Pg0KPiA+Pj4+IFJlc3RvcmUgdGhlIGNo
ZWNrIHRvIG1ha2UgaXQgZXhwbGljaXQgdGhhdCB0aGUgUEFTSUQgaW50ZXJmYWNlcyBvbmx5DQo+
ID4+Pj4gc3VwcG9ydCBkZXZpY2VzIGJlbG9uZ2luZyB0byBzaW5nbGUtZGV2aWNlIGdyb3Vwcy4N
Cj4gPj4+Pg0KPiA+Pj4+IFNpZ25lZC1vZmYtYnk6IEx1IEJhb2x1IDxiYW9sdS5sdUBsaW51eC5p
bnRlbC5jb20+DQo+ID4+Pj4gLS0tDQo+ID4+Pj4gICAgZHJpdmVycy9pb21tdS9pb21tdS5jIHwg
NSArKysrKw0KPiA+Pj4+ICAgIDEgZmlsZSBjaGFuZ2VkLCA1IGluc2VydGlvbnMoKykNCj4gPj4+
Pg0KPiA+Pj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2lvbW11L2lvbW11LmMgYi9kcml2ZXJzL2lv
bW11L2lvbW11LmMNCj4gPj4+PiBpbmRleCA3MWI5YzQxZjJhOWUuLmYxZWJhNjBlNTczZiAxMDA2
NDQNCj4gPj4+PiAtLS0gYS9kcml2ZXJzL2lvbW11L2lvbW11LmMNCj4gPj4+PiArKysgYi9kcml2
ZXJzL2lvbW11L2lvbW11LmMNCj4gPj4+PiBAQCAtMzQwOCw2ICszNDA4LDExIEBAIGludCBpb21t
dV9hdHRhY2hfZGV2aWNlX3Bhc2lkKHN0cnVjdA0KPiA+Pj4+IGlvbW11X2RvbWFpbiAqZG9tYWlu
LA0KPiA+Pj4+ICAgIAkJcmV0dXJuIC1FTk9ERVY7DQo+ID4+Pj4NCj4gPj4+PiAgICAJbXV0ZXhf
bG9jaygmZ3JvdXAtPm11dGV4KTsNCj4gPj4+PiArCWlmIChsaXN0X2NvdW50X25vZGVzKCZncm91
cC0+ZGV2aWNlcykgIT0gMSkgew0KPiA+Pj4+ICsJCXJldCA9IC1FSU5WQUw7DQo+ID4+Pj4gKwkJ
Z290byBvdXRfdW5sb2NrOw0KPiA+Pj4+ICsJfQ0KPiA+Pj4+ICsNCj4gPj4+DQo+ID4+PiBJIHdv
bmRlciB3aGV0aGVyIHdlIHNob3VsZCBhbHNvIGJsb2NrIGFkZGluZyBuZXcgZGV2aWNlIHRvIHRo
aXMNCj4gPj4+IGdyb3VwIG9uY2UgdGhlIHNpbmdsZS1kZXZpY2UgaGFzIHBhc2lkIGVuYWJsZWQu
IE90aGVyd2lzZSB0aGUNCj4gPj4NCj4gPj4gVGhpcyBoYXMgYmVlbiBndWFyYW50ZWVkIGJ5IHBj
aV9lbmFibGVfcGFzaWQoKToNCj4gPj4NCj4gPj4gICAgICAgICAgIGlmICghcGNpX2Fjc19wYXRo
X2VuYWJsZWQocGRldiwgTlVMTCwgUENJX0FDU19SUiB8IFBDSV9BQ1NfVUYpKQ0KPiA+PiAgICAg
ICAgICAgICAgICAgICByZXR1cm4gLUVJTlZBTDsNCj4gPj4NCj4gPg0KPiA+IHdlbGwgc2luY2Ug
eW91IGFyZSBhZGRpbmcgZ2VuZXJpYyBjb3JlIGNoZWNrIHRoZW4gaXQncyBub3QgZ29vZCB0bw0K
PiA+IHJlbHkgb24gdGhlIGZhY3Qgb2YgYSBzcGVjaWZpYyBidXMuLi4NCj4gDQo+IFdlIGF0dGVt
cHRlZCB0byBkbyB0aGlzIGluIHRoZSBwYXRjaCBsaW5rZWQgYmVsb3cuDQo+IA0KPiBodHRwczov
L2xvcmUua2VybmVsLm9yZy9saW51eC1pb21tdS8yMDIyMDcwNTA1MDcxMC4yODg3MjA0LTUtDQo+
IGJhb2x1Lmx1QGxpbnV4LmludGVsLmNvbS8NCj4gDQo+IEFmdGVyIGxvbmcgZGlzY3Vzc2lvbiwg
d2UgZGVjaWRlZCB0byBtb3ZlIGl0IHRvIHRoZSBwY2lfZW5hYmxlX3Bhc2lkKCkNCj4gaW50ZXJm
YWNlLiBUaGUgbm9uLXN0YXRpYyBzaW5nbGUgZGV2aWNlIGdyb3VwIGlzIG9ubHkgcmVsZXZhbnQg
dG8gUENJDQo+IGZhYnJpY3MgdGhhdCBzdXBwb3J0IGhvdC1wbHVnZ2luZyB3aXRob3V0IEFDUyBz
dXBwb3J0IG9uIHRoZSB1cHN0cmVhbQ0KPiBwYXRoLg0KPiANCg0KSWYgdGhhdCdzIHRoZSBjYXNl
IGJldHRlciBhZGQgYSBjb21tZW50IHRvIGluY2x1ZGUgdGhpcyBmYWN0LiBTbyANCmFub3RoZXIg
b25lIGxvb2tpbmcgYXQgdGhpcyBjb2RlIHdvbid0IGZhbGwgaW50byB0aGUgc2FtZSBwdXp6bGUN
CndvbmRlcmluZyB3aGF0IGFib3V0IGEgZ3JvdXAgYmVjb21pbmcgbm9uLXNpbmdsZXRvbiBhZnRl
cg0KYWJvdmUgY2hlY2suIPCfmIoNCg==
