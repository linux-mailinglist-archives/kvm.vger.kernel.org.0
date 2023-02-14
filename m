Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFF6A69569C
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 03:20:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231317AbjBNCUu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 21:20:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbjBNCUt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 21:20:49 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16E3BE382;
        Mon, 13 Feb 2023 18:20:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676341248; x=1707877248;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=KvJyklDJS1Xvk8PFGEUXqzZ1RFNYfwNYeMTf+913hAQ=;
  b=ABUQ7qunJ10L4NKd2EU81+9jZQmLEYM29OjYz9PNmCeHJrPkGg0mq9UC
   RWTtNpc5VZQjtnQi7dzvl4PUqP3jm184l2roVuMiL842aL598emKPIuFj
   E8iY9s4NwjZ3nZ+3P6HGVLNOXZmvaPOAMKND700Y5ecryiTd+tTX0np4l
   AJl89IjkE0V79WlwZMYjB6lKsU8rf0zvGYwlR02x4voA3R/kr8EvLgMMM
   JelOiPCZeIDc/yx51Tpw3lba4P6pvmk5eXoEpRoSXGd2ReQL28GsQF6GE
   5unEhIblxsk5Zc8YuKhR/R+lHzcE6FQskD3eX78JgGVZGlVU2+txbfYif
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="331059154"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="331059154"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 18:20:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="618866067"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="618866067"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga003.jf.intel.com with ESMTP; 13 Feb 2023 18:20:38 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 13 Feb 2023 18:20:37 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 13 Feb 2023 18:20:37 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 13 Feb 2023 18:20:37 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 13 Feb 2023 18:19:49 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kTw9L4XPgNKO2s/7wMt4WCW5HLwgvKshPAyXG5d6YF8i0mY8S2sAkuRf/E1fYjYfY9fF/OM0bt1alRNE8Wzx0fLfYiXi452DkCxlmbMMZe7QNBninWqb2DkhrhVwPkXx2FavSfFGazClZd09ORPxxuYArJ5uNac4PMMFSOksyRjKkJlQEUJf4ImZeqpqYJPpCrWmI2LsHUCxNd4zPXGOB3djJrBsUsKUh+Y2rGIz+KosC8vy0lCWczrypqzp49hGxU8suADGRWWe4L6xXSoV4zrB/7x8mk1DBVa+OPKZQXyj/ComWTJ8s2dSG88wErC0tJiH1+/dwRIjcHAhWF+Fiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KvJyklDJS1Xvk8PFGEUXqzZ1RFNYfwNYeMTf+913hAQ=;
 b=iIHoEkjQ1NLDv1SZpdkdPrX2iCOIWAXUDKZPoFdGWT/gxHWZRHsCG84+Dym5eML1bPOh7wcOPH6ueXVNKO+X/g7hkjGxoTTP0HT4bu0eFKcdniReHJkmU258bieecfozexELO2KjzL3VTobT4LTdT4EJmGUkNzcXBW1DxQtsLWkpBkhZVQue6ybodZBEUTHBl16GeS1g6eAu9tGkWl1sKdz7oy15nQrcbw1LSjg4Rs0TJfDBZUxfEg3QoWx5GcNaGas64BKVLa7MuocSATaOHFD/7TondB27xLo/z3yAIwJdtpbP4tpIsjBj/HS5WIfNZoVoQtQNmYpDlPTHoRlJYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by BL1PR11MB5463.namprd11.prod.outlook.com (2603:10b6:208:315::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Tue, 14 Feb
 2023 02:19:47 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3%3]) with mapi id 15.20.6086.024; Tue, 14 Feb 2023
 02:19:47 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "joro@8bytes.org" <joro@8bytes.org>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>
Subject: RE: [PATCH v3 03/15] vfio: Accept vfio device file in the driver
 facing kAPI
Thread-Topic: [PATCH v3 03/15] vfio: Accept vfio device file in the driver
 facing kAPI
Thread-Index: AQHZP73OQ1XOEaarRU+iobEkUB6WaK7NhGoAgAAvuqA=
Date:   Tue, 14 Feb 2023 02:19:47 +0000
Message-ID: <DS0PR11MB752944997EAB3CF400310605C3A29@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230213151348.56451-1-yi.l.liu@intel.com>
        <20230213151348.56451-4-yi.l.liu@intel.com>
 <20230213162150.7626055b.alex.williamson@redhat.com>
In-Reply-To: <20230213162150.7626055b.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|BL1PR11MB5463:EE_
x-ms-office365-filtering-correlation-id: e2dd2803-6c36-48d6-e66e-08db0e31f1d8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: a5fdneny38gzc1CnYe0p/3MbP1AxNtS5cmk0WfzHcn7NJ33DCrQf0Igl4OScEpUtVt2H2oe06mbBlUVs4/+p2hCmtZMAIYpLMzExw4TTlVjvVoEGm+VOpssSs06WyZUS5ClcumUiWC/sAh9xVZXTSBOMT93lORX5hUZtywsWHs3ZYDh3ysk67cvIhHNEcFc701l7A56OtkKoJIoVw+uOE84Jjgsn5XphgysA3V/Ep8ANncyUTcgCATLkIKZrFirWaC+gVpQo1jk7ZuXjAjUkiicI0HMIB3O1f871ZSzy6/7N3E4swcSpkpHU1mEBBOJzHa93vX4pwST3D5RWrIKNhstwAEzK0OF4NaWGsHup3IMQOK4mjCHAi7O0W2I3+rhN1OwlWzfhnckcnUfgU09A0WKf9K12luvGdvOYNclh2XJvopmijrpe0tupIhH78EdLbBpvdf2PIKqF3xCcOnhCoT64bbsqaQqmR8mxZpNbMI4Qb5onOhn9I/Fr2HvfAzcRiN8VmvDsNVVYZI2jr9BWJ1NntWV/oIIzHvLWj+k77KgCtY1zaIF4sgnJhqAQ+qj2yhQUN3L9XYG6au+YmdM9P02826P7gF1sKFvSAiBQmIVaghOasg/+PeXRqw6tTuegJV6ZngMGQMYnBc4WV8WOE78oWewTsVDpTjhTreQP5IhYHuI8OY/U3YatdALtw5Dk5TiQLxiDDaf5XaFf5n7kB51usJjVIR5oYKFYZimLw4g=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(366004)(136003)(376002)(346002)(396003)(451199018)(5660300002)(38070700005)(83380400001)(55016003)(186003)(26005)(7416002)(2906002)(6506007)(86362001)(52536014)(33656002)(41300700001)(478600001)(7696005)(71200400001)(122000001)(9686003)(8936002)(54906003)(66556008)(64756008)(66476007)(6916009)(316002)(4326008)(66946007)(66446008)(82960400001)(8676002)(38100700002)(76116006)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?V0E0a0JzbG1UREM5R0Y2SmUyNFZqaUZOSVI3QTBPRmRDbEZxT3A5ZUc1d2JL?=
 =?utf-8?B?NWRtK25uc3pyOGsyeWdkVWxma0laeTZITTA5RUZmYzhKVGZ4SDAwS3RTSnR3?=
 =?utf-8?B?aExpZ1E0cWtkMkE0Z3p0dmVvMFl3RkN5UGtRdndETUYzZUFLM0dmc2dmRVJH?=
 =?utf-8?B?cGptMHYzUldZQU5nU2djbHNiaUI1R2ZQb3dGb2d3S0FWWm1JKzFHd1VUTE5M?=
 =?utf-8?B?RytHU3EvUFhTd1JWemVLODQrbjNwZWlENUk5Qm5IRWJKbExWKy9JVVZhdDlm?=
 =?utf-8?B?UEw5QUhibXJDcG1KZVNnM2VhTkVpYzcxdkFmUGNha040d1A3bmlaWnpwejBR?=
 =?utf-8?B?RlduWkphR3VxUHUxN200RHRDRnliUkVudi8vKzRuYk1QV05LNEVRVEcrRmtw?=
 =?utf-8?B?SElaeUFadUduQldRNWJ1SFBuZGVoM1kyckFWQUVjcnRCMXJyb2VLNWJxcXVX?=
 =?utf-8?B?TkRnVlFJZGlvNEF1YzJPSzRkbFZERnJCVTZUa2h2TVpyVEpCZ2p1M01hMzMr?=
 =?utf-8?B?VzkyZnNTaWNaMHl1dU0wYnFBU0NVMWJDbkVRb2lGazRVck0vMC90dVk2enM3?=
 =?utf-8?B?T0JQOGNRdE9JYU44RDc1N0o5TER4UVE3VWNnb3lxTUJtSjlTeTdPdmN6OUl3?=
 =?utf-8?B?UGdFTTErYnV3S1djZFcxQjZja3U4LzYzNUJvVHZkK0xPQTQ3bjZwT3A5NTZV?=
 =?utf-8?B?TzYwZVVqT2hldnJKNHFYS1F4a1VRV1doTWhlR0lCcG1KcDJMNXlTS3oxNzVN?=
 =?utf-8?B?RWxFSlZYb1FqUFZHR2ZubXp4dktNMzYrWnJERnhtcEsydWF3ZEpVV2grSjZ0?=
 =?utf-8?B?L2FTV2F3KzNHRVd0K0pNT0pUOWJ6Z3h1Q0h6NFJySXpnWE5jdHQ1MERmQzBm?=
 =?utf-8?B?VXp3ZUkxZGkrU2xuZ2pzczRDeVJYZEtwUTlYaitFNXpWVUsyOTdvUWh0SjF4?=
 =?utf-8?B?KzR6bm01K21yWXcyRHpQcGh4OXQrNVJDL0tKRmpYMHRyNTB0ZTFDS2NwSUdx?=
 =?utf-8?B?OE9nL3Fhcm9aZTIwZGU2dGpjVlgxWVN5blFLUGlQcWQ3V1NQSjFGcURSR2NR?=
 =?utf-8?B?L1hoSWcyaVd6RlJxWlVaVlhrWnJCaEdGdHR5b0JqdUNoRFZTOExSNnBuK3kv?=
 =?utf-8?B?dnlsc3BFbHQzQTJibUd2blo0V1VHUXViZUdXdFp2R3pacXRJelBWN2pDOUhD?=
 =?utf-8?B?NnQ3V1BOVkpvNzZIOG5lVlU5eE84ZmtEUC9Lci9IbGJtekdFY2F4dG1EQ1ha?=
 =?utf-8?B?NWkrOFNxblZEb2xSRkpRTmw1a2pVQnBiYk05bnJJM1hzdys0RTU3SEVzbERm?=
 =?utf-8?B?ek10OXQ5THpwRWZNdmNrcG5rV2w4U2hhWnAwbnlZakMwc29YcG5QWTN0RURx?=
 =?utf-8?B?YlpjQzJmVzJWaURmQnorQ0hua0ZibVByRVN6cFRkbStEWXlURHZ2eUsrMXdB?=
 =?utf-8?B?ejl3UzJYOE9Jd1g1Nkk2S0VoTEkxY0VlRmFVNjdxcllXZzEvQm1tUEN1ZWdT?=
 =?utf-8?B?cnhJOVkvbXdFcUJvYlRIUy83SFBEOFR6RllIcFF3MFZQWGlkS0xoNy9ZRzho?=
 =?utf-8?B?VFIrT1VnOGcyNldmNGpYVUtsWlIvU3hCZjg2TVdLdUxWSXRHTXlGNFV4N3ZB?=
 =?utf-8?B?ODF3NFhSazNObjBiZllpanFGRTY2SXdTblFjMFhUK3lwUTVpdjNURWRldlBh?=
 =?utf-8?B?WlA4TGNtRnY2VEY1bWs5MW5heFEyTWdlQzBtT0xWeTY0ang0Q2loaWZnSk1J?=
 =?utf-8?B?UE5UZGR6cVYza1lHL0R5UmJlc2hrWVYvOTV6RlZVRHhhQ0ZDRm11N2FKQlZ5?=
 =?utf-8?B?Y1QrSHdvUDVHaVdZeVhaRXBRQmdPMGQ5NHB6T2JtS3BIamZSUU44d0N1R3E2?=
 =?utf-8?B?S2cyMVVJTjBVdzhscEZmai9ydkdXVDFmaG9tSitPVTA0dk5XT1NzL1JVVXdQ?=
 =?utf-8?B?T2lQSitHditpS0loRko3SkNFdlF2cStzMHM3b2pmNWhYamo1UURRME45WUla?=
 =?utf-8?B?NVV4WUpuaTcrZVBSbk1wdlcwYVNscWVrTVBJblR3bGFMQjV3L1lNV0tDbkNC?=
 =?utf-8?B?RG5RdGRBbitSdTRaQjQ3a3o5V1h1dDNwOHgzVnFwUUxOdkF5K3JxUGF5b21R?=
 =?utf-8?Q?dcKubpxLg6tMiV9cr6gMMLhgA?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2dd2803-6c36-48d6-e66e-08db0e31f1d8
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Feb 2023 02:19:47.6611
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oJpeXeLmCabfxOuNmGplamvrqYOmRhrgl307p8Lr8idILnk/auu4mOv8K3YwvD13QVCqTHMDkUTbTlZM5/cLmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5463
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBBbGV4IFdpbGxpYW1zb24gPGFsZXgud2lsbGlhbXNvbkByZWRoYXQuY29tPg0KPiBT
ZW50OiBUdWVzZGF5LCBGZWJydWFyeSAxNCwgMjAyMyA3OjIyIEFNDQo+IA0KPiBPbiBNb24sIDEz
IEZlYiAyMDIzIDA3OjEzOjM2IC0wODAwDQo+IFlpIExpdSA8eWkubC5saXVAaW50ZWwuY29tPiB3
cm90ZToNCj4gDQo+ID4gVGhpcyBtYWtlcyB0aGUgdmZpbyBmaWxlIGtBUElzIHRvIGFjY2VwdGUg
dmZpbyBkZXZpY2UgZmlsZXMsIGFsc28gYQ0KPiA+IHByZXBhcmF0aW9uIGZvciB2ZmlvIGRldmlj
ZSBjZGV2IHN1cHBvcnQuDQo+ID4NCj4gPiBGb3IgdGhlIGt2bSBzZXQgd2l0aCB2ZmlvIGRldmlj
ZSBmaWxlLCBrdm0gcG9pbnRlciBpcyBzdG9yZWQgaW4gc3RydWN0DQo+ID4gdmZpb19kZXZpY2Vf
ZmlsZSwgYW5kIHVzZSBrdm1fcmVmX2xvY2sgdG8gcHJvdGVjdCBrdm0gc2V0IGFuZCBrdm0NCj4g
PiBwb2ludGVyIHVzYWdlIHdpdGhpbiBWRklPLiBUaGlzIGt2bSBwb2ludGVyIHdpbGwgYmUgc2V0
IHRvIHZmaW9fZGV2aWNlDQo+ID4gYWZ0ZXIgZGV2aWNlIGZpbGUgaXMgYm91bmQgdG8gaW9tbXVm
ZCBpbiB0aGUgY2RldiBwYXRoLg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogWWkgTGl1IDx5aS5s
LmxpdUBpbnRlbC5jb20+DQo+ID4gUmV2aWV3ZWQtYnk6IEtldmluIFRpYW4gPGtldmluLnRpYW5A
aW50ZWwuY29tPg0KPiA+IC0tLQ0KPiA+ICBkcml2ZXJzL3ZmaW8vdmZpby5oICAgICAgfCAgMiAr
Kw0KPiA+ICBkcml2ZXJzL3ZmaW8vdmZpb19tYWluLmMgfCA1MQ0KPiArKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKystLS0tDQo+ID4gIDIgZmlsZXMgY2hhbmdlZCwgNDkgaW5zZXJ0
aW9ucygrKSwgNCBkZWxldGlvbnMoLSkNCj4gDQo+IFRoaXMgc3VidGx5IGNoYW5nZXMgdGhlIGJl
aGF2aW9yIG9mIHRoZSB2ZmlvLXBjaSBob3QgcmVzZXQgZnVuY3Rpb25zDQo+IHdpdGhvdXQgdXBk
YXRpbmcgdGhlIHVBUEkgZGVzY3JpcHRpb24gb3IgaW1wbGVtZW50YXRpb24gdG8gdXNlIGxlc3MN
Cj4gZ3JvdXAtY2VudHJpYyB2YXJpYWJsZXMuICBUaGUgbmV3IGJlaGF2aW9yIGFwcGVhcnMgdG8g
YmUgdGhhdCBjZGV2IGZkcw0KPiBjYW4gYWxzbyBiZSBwYXNzZWQgdG8gcHJvdmUgb3duZXJzaGlw
IG9mIHRoZSBhZmZlY3RlZCBzZXQgb2YgZGV2aWNlcw0KPiBmb3IgYSBob3QgcmVzZXQsIGJ1dCB0
aGlzIHByb2JhYmx5IG5lZWRzIHRvIGJlIGV4YW1pbmVkIGZvciBnYXBzLg0KDQpZZXMuIHVzZXIg
Y291bGQgcGFzcyBjZGV2IGZkcyBhZnRlcndhcmQuIEkgc3VwcG9zZSB0aGUgVkZJT19ERVZJQ0Vf
R0VUX1BDSV9IT1RfUkVTRVRfSU5GTw0Kd2lsbCByZXBvcnQgdGhlIGV4aXN0aW5nIGluZm8gKGdy
b3VwX2lkLCBzZWdtZW50LCBidXMsIGRldmZuKS4gV2hpbGUgdXNlcnNwYWNlDQpwYXNzZXMgZGV2
aWNlIGZkcyB0byB0aGUga2VybmVsIGZvciByZXNldHRpbmcuIE5lZWQgdG8gdXBkYXRlIHN0cnVj
dCB2ZmlvX3BjaV9ob3RfcmVzZXQNCmFuZCB0aGUga2VybmVsIHJlc2V0IGNvZGUgYWNjb3JkaW5n
bHkuIFByb2JhYmx5LCBpdCBpcyBhIGZvbGxvd2luZyBzZXJpZXMgZm9yIGl0LiDwn5iKDQoNCi8q
Kg0KICogVkZJT19ERVZJQ0VfR0VUX1BDSV9IT1RfUkVTRVRfSU5GTyAtIF9JT1dSKFZGSU9fVFlQ
RSwgVkZJT19CQVNFICsgMTIsDQogKgkJCQkJICAgICAgc3RydWN0IHZmaW9fcGNpX2hvdF9yZXNl
dF9pbmZvKQ0KICoNCiAqIFJldHVybjogMCBvbiBzdWNjZXNzLCAtZXJybm8gb24gZmFpbHVyZToN
CiAqCS1lbm9zcGMgPSBpbnN1ZmZpY2llbnQgYnVmZmVyLCAtZW5vZGV2ID0gdW5zdXBwb3J0ZWQg
Zm9yIGRldmljZS4NCiAqLw0Kc3RydWN0IHZmaW9fcGNpX2RlcGVuZGVudF9kZXZpY2Ugew0KCV9f
dTMyCWdyb3VwX2lkOw0KCV9fdTE2CXNlZ21lbnQ7DQoJX191OAlidXM7DQoJX191OAlkZXZmbjsg
LyogVXNlIFBDSV9TTE9UL1BDSV9GVU5DICovDQp9Ow0KDQpzdHJ1Y3QgdmZpb19wY2lfaG90X3Jl
c2V0X2luZm8gew0KCV9fdTMyCWFyZ3N6Ow0KCV9fdTMyCWZsYWdzOw0KCV9fdTMyCWNvdW50Ow0K
CXN0cnVjdCB2ZmlvX3BjaV9kZXBlbmRlbnRfZGV2aWNlCWRldmljZXNbXTsNCn07DQoNCiNkZWZp
bmUgVkZJT19ERVZJQ0VfR0VUX1BDSV9IT1RfUkVTRVRfSU5GTwlfSU8oVkZJT19UWVBFLCBWRklP
X0JBU0UgKyAxMikNCg0KLyoqDQogKiBWRklPX0RFVklDRV9QQ0lfSE9UX1JFU0VUIC0gX0lPVyhW
RklPX1RZUEUsIFZGSU9fQkFTRSArIDEzLA0KICoJCQkJICAgIHN0cnVjdCB2ZmlvX3BjaV9ob3Rf
cmVzZXQpDQogKg0KICogUmV0dXJuOiAwIG9uIHN1Y2Nlc3MsIC1lcnJubyBvbiBmYWlsdXJlLg0K
ICovDQpzdHJ1Y3QgdmZpb19wY2lfaG90X3Jlc2V0IHsNCglfX3UzMglhcmdzejsNCglfX3UzMglm
bGFnczsNCglfX3UzMgljb3VudDsNCglfX3MzMglncm91cF9mZHNbXTsNCn07DQoNCiNkZWZpbmUg
VkZJT19ERVZJQ0VfUENJX0hPVF9SRVNFVAlfSU8oVkZJT19UWVBFLCBWRklPX0JBU0UgKyAxMykN
Cg==
