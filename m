Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 705F54D1463
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 11:11:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345829AbiCHKLw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 05:11:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345774AbiCHKLt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 05:11:49 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FAB842ED4;
        Tue,  8 Mar 2022 02:10:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646734233; x=1678270233;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Z1cNy/yMvruTAa412n6gE/bONEirNAoaXs89BQOAd2o=;
  b=fIKVoKwcdjawuDoccwozH6re5cGSbUz1r6umD+EMXW5rpDBobYTNDfEV
   Aj+2N81mJjTQ7MO+e/x9WRJA0V99gZi/x6QQUgDUkPQLsjK25bkSwUgG5
   YN2W5lhv8ByZiqN4OsaXwNXNKHqtguP0bekOyQv1Pv6NwUJUg5VSffBpH
   /NFoDdyHHNfv9ULvTRRQ6I48CPJoCEYpAQDTR/OIDdoJCrd11/XXy5W27
   waYhCcRFteKUbetj6K3iV91zs/vwlMsZM59sBIJfC9HReq1Kn8Id6i/H3
   DFIZRPToUD6J4HFFnxWWczSD8QbFxTxdChubsZJavPTCAELdXvOlS7z4S
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10279"; a="341079416"
X-IronPort-AV: E=Sophos;i="5.90,164,1643702400"; 
   d="scan'208";a="341079416"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2022 02:10:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,164,1643702400"; 
   d="scan'208";a="780662791"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga006.fm.intel.com with ESMTP; 08 Mar 2022 02:10:32 -0800
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 8 Mar 2022 02:10:32 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 8 Mar 2022 02:10:31 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21 via Frontend Transport; Tue, 8 Mar 2022 02:10:31 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.174)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.21; Tue, 8 Mar 2022 02:10:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gmVOSI1NU4LbcgaF4bTj6aB0pwlTIXJ0P1vCEBnrIZ306V7qqi4zIvhfVrNBm1ckOBC1DsO2JmNI3NB/KkhJ3Mr0kqpFagRBHn0j5sz0BzNdtHs8iEzBYCC77IgdERJN4jXOQC7LV+mGPKkocIQ+3D3gA9Fl22PO2gRwXZ2joOiHxxdJ2wI+3RgARmdPHW710sjb6qld1bQk13WLVhTd8Hht36dwnfq8L7ldS9IMPqQD/zBmDBzeuFORdYziCmJ5hyZW1NAq2A0Cwwyzn7sUrL2pOFGADRXk8V5jwFmCucdB4ZCOTaPxiIiFQheZyELEbkkeWGt/XzKzc8urnohzgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z1cNy/yMvruTAa412n6gE/bONEirNAoaXs89BQOAd2o=;
 b=XiZxwrVOjxMv91Tt/msZJiqF8IwG4DGjJwdy8iZOasp/iVeFbNhBbDX9mJp9SXcAvJStX3bv2Gk+/qTkIosjt+CrSCrViajWBNgZFHKzy/V2M+veggcl1nAtmbi4YgDavf0n8ktpCsc7OVM84z/guYWgLRGaPQGH0TSzuXOf+khmYPA/dPVnhHOGbpHOeB6CikFW7PCpWU4a64TkH0WQKkuraf1VLjuraV1nuR5YSiAgRD+R4YPgxGxRznn8oAZOCv8RY//NtYqB5ADxeMvbpdKtkjYJP23IUx9+qHQuZv+tGUQXzeW2dy1UH3gcMT2UEWJKCC2D9xAwBhibvAHK3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CH0PR11MB5538.namprd11.prod.outlook.com (2603:10b6:610:d5::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Tue, 8 Mar
 2022 10:10:22 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c8aa:b5b2:dc34:e893]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c8aa:b5b2:dc34:e893%6]) with mapi id 15.20.5038.027; Tue, 8 Mar 2022
 10:10:22 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        Linuxarm <linuxarm@huawei.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        "Jonathan Cameron" <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>
Subject: RE: [PATCH v8 7/9] crypto: hisilicon/qm: Set the VF QM state register
Thread-Topic: [PATCH v8 7/9] crypto: hisilicon/qm: Set the VF QM state
 register
Thread-Index: AQHYL1LlxS7vDH7cWUS0mnIYI1OsX6y1C9qggAAnc4CAABdfcA==
Date:   Tue, 8 Mar 2022 10:10:22 +0000
Message-ID: <BN9PR11MB5276FF8757FBB54AA523ECB88C099@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220303230131.2103-1-shameerali.kolothum.thodi@huawei.com>
 <20220303230131.2103-8-shameerali.kolothum.thodi@huawei.com>
 <BN9PR11MB5276D3F8869BEAB2CBB16B498C099@BN9PR11MB5276.namprd11.prod.outlook.com>
 <fe8dbea8868f46f0ad9699f6a12c1e63@huawei.com>
In-Reply-To: <fe8dbea8868f46f0ad9699f6a12c1e63@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e8158a3d-6145-4a6f-fad8-08da00ebdbaa
x-ms-traffictypediagnostic: CH0PR11MB5538:EE_
x-microsoft-antispam-prvs: <CH0PR11MB553885D976F88F82ABA4AA578C099@CH0PR11MB5538.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uPwahY2bhFWWV8RBehx0wEGPqYVq/yC6ORUreHKZNx+5yq2K2wIeMWX+gflrETtECAFThuJ3gnyumchkgBSuDKcPeI4M4jwBYsNpt2NC9Hoy+C2btLK67v4bYJQQX3dgYYtINp9XIC2Jr5LqHkXkB0sWJpoCJNBHCSA87mAS3JTbYiqe0d1sPh1bYq+YXcVR/hBrLIa6OtxBcCllG94uPpHQ+kZyG4C1PwCbG5nJNxNydVTk5ClOCPWm7uNwVTLQYidw+WdBqHS5CXsexw76f1eZadHMfOmX0TVkrgcUE91PocPFNtaVBo27P5Lz2aJNI0EiJFkcnSrhvs7yO2x7OTFf3PcdHya92f9Cv03lmJ9sc+eefW/ISRG6YVyDu7HBvqFpfvuM0zCMmw7WtquBDusFmehQySuvFB6ybMbrk6uJXgF9C2zvqmWy0oV2Xwl3wak0x8UMOqLE3ICc21r5N4fpOnhWRjlH5jLgUv1wU2PoUxW3l85GvVyFOQnsHprwl63BQbpLecodFluQUnG7kYVH/TFN3leKBJZ0UJ2YbL5OQuMGcVCj+IBoEagk5aOT/yjmt1Vq6FlCJInh0HTzaIz0IlsuzimhKriOFoxoCT3OVVINCkezBL9oLwPkgnmKc+Az01c0W6mgTNLeM8WOJBPAV7vk860IkIVV2mzZGuavrXgnpZ+7x/AdcJG/YSZH9cFk5LRkxcSSvbuYC8A84g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(4326008)(66476007)(316002)(8676002)(54906003)(66946007)(66556008)(64756008)(66446008)(38100700002)(38070700005)(86362001)(52536014)(8936002)(82960400001)(122000001)(5660300002)(2906002)(7416002)(9686003)(110136005)(6506007)(26005)(186003)(7696005)(53546011)(76116006)(508600001)(71200400001)(55016003)(83380400001)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Z0xBalArMGcweGF6RStuMTNVTnFFOXVTeVlIQUVmdGo4WVVZVTZsM3RFcGtC?=
 =?utf-8?B?cmtLN3pDdmwwc3hWRVNWT25aUW1qdHlYMUViTE5YelVrTzJLbXV4MXBqV0pw?=
 =?utf-8?B?ZnVEMEQ0dUpCSWJpMGp3TmZIelJGckszTlQ3WGdzMS9KNUVLSXFzU21QWXZ0?=
 =?utf-8?B?RXNZZHp3QjZmT2Q3Z0l0a3Q1Qlh5a051dUhpRHBtbTFQeEs4T1Q0L1N3UHpK?=
 =?utf-8?B?SGdMM09LOGRPdDJHbUZzdGVmS3g1VlNmQ2U5QnJlTmo3UE0vMXpyTzN5TUw5?=
 =?utf-8?B?RTdzQW45dTBaSHFNRUF5TWtIc2VDQWNkRWp0Q2xISUlvVklvT000UnZpVnRJ?=
 =?utf-8?B?bFJ5ZVNQMXBPcFo5Vk1LRGZET2RzOWd2UklkM2NpVzh4WVQ4ZTVpbm8wdjRo?=
 =?utf-8?B?eVA5dGFFQVpnbEFzdmUwd1orT2F0MUhXaU4vZWVjalVsd1JTVDloL3VQcnNn?=
 =?utf-8?B?Z3dCdlltd1g5bitTSWY1NUpPcVRETmdPUElVZDdYd3kvK0tNS01pQjdPWHEy?=
 =?utf-8?B?Rnl6S2ZLQ0RWdG9RQ3hWQzZFSFR1MVZ2VTFRQkhIenIxVzAzUkkrVE84eG1X?=
 =?utf-8?B?Y3piQ0ltL2k2R2VaZXE1WnRyd01nQ3VKenBvZTVGZ2swSFZDcE5vVE9HMSt3?=
 =?utf-8?B?WDhxUmN6bS9Eb0E4SFZ3M05CVyt6c2lldGJhYjhmWmV6R0FrcnpUTExkd3Bk?=
 =?utf-8?B?bUtyV2F0V2N0Y3dveDRvdnZ5ZTRlSU5HMXBQQnBzZ3hqbkUzZjlTYTR6Yjk3?=
 =?utf-8?B?Y1NjMXluN2RnNVNIdU9NOHZDUVZIOGVwUXY3R3FBTGFtYXB5YlN3bkZlOFov?=
 =?utf-8?B?WFZsMnVSd1Y0SWxaQ0FVYnZKMlZseXkyNUQ1MFZPNW9NYmtiV2dIMmNDc2Iv?=
 =?utf-8?B?OGZzNlZuUTlVdi81SVVSUVBURmRLellGVGx1cFJCZy9NL2NxT0NhN3dBL3JR?=
 =?utf-8?B?bVRWR20ySEwvdUU5ZnRVRnN5OVNJWDluTHlicm12Y1psSlFOeEc0NVg3cld5?=
 =?utf-8?B?TEJkRFlVWStpcnljOFZDVEd1d2NxeWFlZUdENmliWkdBZHZ4UXFWZzdjZGsw?=
 =?utf-8?B?c1gwaGdaaGJnWFM0Y1llS01SamZibEVkYUN5TDdWb0JnT3l0UGVFbWhxeWp0?=
 =?utf-8?B?NEt3ZmwxaTNFZEhzeVhoRlJ4TDdzdGUvdUhPU1IvZVNKa1E1QUZtd2JHWC94?=
 =?utf-8?B?REgvRzVwQUExMXNGUmZlYkRQdFA4bGxIcHVXaWNRSE4zSi81b2dmRmhqZDJM?=
 =?utf-8?B?cy9LQ2huWGxvdXl0QVV1bFJSdjBGMEhuL3RDdG40VHJIVkg4WDVYVWNLYmxZ?=
 =?utf-8?B?NlVYNjZrRENlbG5xbExCYmF1UEg4bmFDaEVSelpDRTRzVVFpcnBxRE1EOUts?=
 =?utf-8?B?UllXbHBGRXRNUVVodm5Lb0NYRFB0V1N3RXIrYlJiSHVrL0hLcy9iR0hLUUp0?=
 =?utf-8?B?d2FVM2pGV3J4MDQzbHZUdkJDVWF6cXhsdVQ2WndCNzFZSFVvb0ZCMkR6c1lm?=
 =?utf-8?B?OG1JNjJvbzVhblJCUmIzNFlIMjljZVlialFnUWtNeUhwR09rcWRaclhTbWJX?=
 =?utf-8?B?cGQyRGZiOGpZRURGUGRobzZTZDlYSTl1dFA1Yjg2OTBjTVRSalZ3SGVMN05q?=
 =?utf-8?B?U1I3UlMwNlFFdTN5SlpjS1NWM3JsazFMUXVKYW1rM0lZY3AzZG9DSGovaFZU?=
 =?utf-8?B?THhhaDJJVjJOc21xLzNBSjFDeUttamQwUWVOUUg3RVhDRncyU0lvZWxDMEUw?=
 =?utf-8?B?ZjVGc2ZlaHRIWC9TeStjbnFYUEt5LzJEejNyVTZ0aGlBRjJlUTBCMFYwRkhv?=
 =?utf-8?B?V0Y0VDNlTkZzVlFWUDByc1B5Z1gwRUZsTTl0S09Hbld6VFQzWDNqUVl2OGc1?=
 =?utf-8?B?ZUV3L0ZYUXZDaHIwN0tRb3FUcnRxVlROTjlObWVIOG53M2VyTGFtQkR6WFln?=
 =?utf-8?B?U29DVEhlQWp6RzErZTZSWTJaWDQ0OHVmUVhqcndibVdQZmRFb1kzNFBEVFJJ?=
 =?utf-8?B?RldLMHRDZFFld05EZzlFRU04VURZWlpuVDAvM3lrOFUxdWg1ckJieVVUd1M5?=
 =?utf-8?B?WVZiRjBSSHQvT0gvalBTRHg5VlVyVUpzcHJIUytCK09RLzZZRDVvZGVOMG5q?=
 =?utf-8?B?bjRYUzUvK2FJZEJxSVdZZjYwWmFaRjBxYXppcVBzbkZHbFFIamVVaFVQUDdP?=
 =?utf-8?B?Vmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8158a3d-6145-4a6f-fad8-08da00ebdbaa
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Mar 2022 10:10:22.7826
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: h5c7a8Qj2dTHwLVM0A2ok96zGFmRGrYV3FHsECYCTIDK87CX74SoSgl9rboc65sAP+fSEHfEbkOUqUAUMWMR8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5538
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBTaGFtZWVyYWxpIEtvbG90aHVtIFRob2RpDQo+IDxzaGFtZWVyYWxpLmtvbG90aHVt
LnRob2RpQGh1YXdlaS5jb20+DQo+IFNlbnQ6IFR1ZXNkYXksIE1hcmNoIDgsIDIwMjIgNDo0NiBQ
TQ0KPiANCj4gDQo+IA0KPiA+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+ID4gRnJvbTog
VGlhbiwgS2V2aW4gW21haWx0bzprZXZpbi50aWFuQGludGVsLmNvbV0NCj4gPiBTZW50OiAwOCBN
YXJjaCAyMDIyIDA2OjMxDQo+ID4gVG86IFNoYW1lZXJhbGkgS29sb3RodW0gVGhvZGkNCj4gPHNo
YW1lZXJhbGkua29sb3RodW0udGhvZGlAaHVhd2VpLmNvbT47DQo+ID4ga3ZtQHZnZXIua2VybmVs
Lm9yZzsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsNCj4gPiBsaW51eC1jcnlwdG9Admdl
ci5rZXJuZWwub3JnDQo+ID4gQ2M6IGxpbnV4LXBjaUB2Z2VyLmtlcm5lbC5vcmc7IGFsZXgud2ls
bGlhbXNvbkByZWRoYXQuY29tOw0KPiBqZ2dAbnZpZGlhLmNvbTsNCj4gPiBjb2h1Y2tAcmVkaGF0
LmNvbTsgbWd1cnRvdm95QG52aWRpYS5jb207IHlpc2hhaWhAbnZpZGlhLmNvbTsNCj4gTGludXhh
cm0NCj4gPiA8bGludXhhcm1AaHVhd2VpLmNvbT47IGxpdWxvbmdmYW5nIDxsaXVsb25nZmFuZ0Bo
dWF3ZWkuY29tPjsNCj4gWmVuZ3RhbyAoQikNCj4gPiA8cHJpbWUuemVuZ0BoaXNpbGljb24uY29t
PjsgSm9uYXRoYW4gQ2FtZXJvbg0KPiA+IDxqb25hdGhhbi5jYW1lcm9uQGh1YXdlaS5jb20+OyBX
YW5nemhvdSAoQikNCj4gPHdhbmd6aG91MUBoaXNpbGljb24uY29tPg0KPiA+IFN1YmplY3Q6IFJF
OiBbUEFUQ0ggdjggNy85XSBjcnlwdG86IGhpc2lsaWNvbi9xbTogU2V0IHRoZSBWRiBRTSBzdGF0
ZQ0KPiByZWdpc3Rlcg0KPiA+DQo+ID4gPiBGcm9tOiBTaGFtZWVyIEtvbG90aHVtIDxzaGFtZWVy
YWxpLmtvbG90aHVtLnRob2RpQGh1YXdlaS5jb20+DQo+ID4gPiBTZW50OiBGcmlkYXksIE1hcmNo
IDQsIDIwMjIgNzowMSBBTQ0KPiA+ID4NCj4gPiA+IEZyb206IExvbmdmYW5nIExpdSA8bGl1bG9u
Z2ZhbmdAaHVhd2VpLmNvbT4NCj4gPiA+DQo+ID4gPiBXZSB1c2UgVkYgUU0gc3RhdGUgcmVnaXN0
ZXIgdG8gcmVjb3JkIHRoZSBzdGF0dXMgb2YgdGhlIFFNIGNvbmZpZ3VyYXRpb24NCj4gPiA+IHN0
YXRlLiBUaGlzIHdpbGwgYmUgdXNlZCBpbiB0aGUgQUNDIG1pZ3JhdGlvbiBkcml2ZXIgdG8gZGV0
ZXJtaW5lIHdoZXRoZXINCj4gPiA+IHdlIGNhbiBzYWZlbHkgc2F2ZSBhbmQgcmVzdG9yZSB0aGUg
UU0gZGF0YS4NCj4gPg0KPiA+IENhbiB5b3Ugc2F5IHNvbWV0aGluZyBhYm91dCB3aGF0IFFNIGlz
IGFuZCBob3cgaXQgaXMgcmVsYXRlZCB0byB0aGUgVkYNCj4gc3RhdGUNCj4gPiB0byBiZSBtaWdy
YXRlZD8gSXQgbWlnaHQgYmUgb2J2aW91cyB0byBhY2MgZHJpdmVyIHBlb3BsZSBidXQgbm90IHNv
IHRvIHRvDQo+ID4gb3RoZXJzIGluIHZmaW8gY29tbXVuaXR5IGxpa2UgbWUuIPCfmIoNCj4gDQo+
IE9rLCB1bmRlcnN0YW5kIHRoYXQuIEkgd2lsbCBsaWZ0IGEgZGVzY3JpcHRpb24gZnJvbSB0aGUg
UU0gZHJpdmVyIHBhdGNoIDopLg0KPiANCj4gUU0gc3RhbmRzIGZvciBRdWV1ZSBNYW5hZ2VtZW50
IHdoaWNoIGlzIGEgZ2VuZXJpYyBJUCB1c2VkIGJ5IEFDQyBkZXZpY2VzLg0KPiBJdCBwcm92aWRl
cyBhIGdlbmVyYWwgUENJZSBpbnRlcmZhY2UgZm9yIHRoZSBDUFUgYW5kIHRoZSBBQ0MgZGV2aWNl
cyB0byBzaGFyZQ0KPiBhIGdyb3VwIG9mIHF1ZXVlcy4NCj4gDQo+IFFNIGludGVncmF0ZWQgaW50
byBhbiBhY2NlbGVyYXRvciBwcm92aWRlcyBxdWV1ZSBtYW5hZ2VtZW50IHNlcnZpY2UuDQo+IFF1
ZXVlcyBjYW4gYmUgYXNzaWduZWQgdG8gUEYgYW5kIFZGcywgYW5kIHF1ZXVlcyBjYW4gYmUgY29u
dHJvbGxlZCBieQ0KPiB1bmlmaWVkIG1haWxib3hlcyBhbmQgZG9vcmJlbGxzLiBUaGUgUU0NCj4g
ZHJpdmVyKGRyaXZlcnMvY3J5cHRvL2hpc2lsaWNvbi9xbS5jKQ0KPiBwcm92aWRlcyBnZW5lcmlj
IGludGVyZmFjZXMgdG8gQUNDIGRyaXZlcnMgdG8gbWFuYWdlIHRoZSBRTS4NCj4gDQo+IEkgd2ls
bCBhZGQgc29tZSBvZiB0aGlzIGluIGVpdGhlciB0aGlzIGNvbW1pdCBtc2cgb3IgaW4gdGhlIGFj
dHVhbCBmaWxlDQo+IHNvbWV3aGVyZS4NCj4gDQoNClllcywgc3VjaCBpbmZvcm1hdGlvbiBpcyBo
ZWxwZnVsDQo=
