Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 254E973F7DE
	for <lists+kvm@lfdr.de>; Tue, 27 Jun 2023 10:54:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230259AbjF0Iyp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 04:54:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbjF0Iyo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 04:54:44 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E34C9A4;
        Tue, 27 Jun 2023 01:54:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687856082; x=1719392082;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=sS9K1y0H75rBCRfGvneDgck2IW3uMWxd1lEbBTeJPr8=;
  b=LKW59deBZq0llMzjOJh/33IDb06EQN5QTzGuXquX0tXSSmuKYqOTVDVk
   1S0QHyar2z7y+1t8etQ1JnwScEuE9O8YZ+5lZ1T/GOvrmiZqcz4TjOdvT
   wtWG5K/QW0ftS3oyP4Lu+DMeKdMzKo8wjNdODY+gMWHZWebPJ9y7dnN4+
   4YnWldaGTUTwoEG9XfYcn4K0tVlobBZUwt8mlzop1pAPNfheMyssjyP/7
   M57QJ1Fjhxgwa4HnMskGosNfBf6cDEwn83He80Uo7as6uSINyXC2Fx3zs
   +ta0yMMLo2XzpcGm5weIfWalXaEbO1dwQLi4vcDA5PVLVfd2q7VQR29Cm
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10753"; a="361558084"
X-IronPort-AV: E=Sophos;i="6.01,162,1684825200"; 
   d="scan'208";a="361558084"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2023 01:54:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10753"; a="751594693"
X-IronPort-AV: E=Sophos;i="6.01,162,1684825200"; 
   d="scan'208";a="751594693"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga001.jf.intel.com with ESMTP; 27 Jun 2023 01:54:37 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 27 Jun 2023 01:54:36 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 27 Jun 2023 01:54:36 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Tue, 27 Jun 2023 01:54:36 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.171)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 27 Jun 2023 01:54:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XUD0WIM1s8ek++n8krKyBeyC1caDMcn7vw52gVeOUwdnBRjm7Q6m8bK7BGjmXrS9Es1jecZbDQ3n8vmfenC6aEkKU6O8A7wlieZTed9d66fGZ2BOgfEyUFvFy/YjxjqTthmzEL8R6i1c+1UiLD9acDQNN91GFfruv7CSlLEF7VeitWPxPYtZQtMqR1BoDGLBKLpgUzVnLqimTlNdWvPQ2ZHa8SddmmSAXdHrYtPqGFLZro/OjvSVpcrWeun+dvDwRa4WHgjXPC8Fd8oYcPYRhIdLyNKsoagLziGpcZQ7VbsXo8NSAdOIHoVJ2PBcQr63byz3+FSwcOr4uvzMVQDW3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sS9K1y0H75rBCRfGvneDgck2IW3uMWxd1lEbBTeJPr8=;
 b=LT+GG4jjY5dN7Eq2jqlV7EIkSCQ0Wk6GM4UneD3gOhHc8KHnFezW1Wl+CMrvTarDR/96LYx4CWY5APE5c+W60SG4XokpRTVJzycihEPo5IimoHuDvj4Dv8erS8Dd1ZyWDtEwTGxv4obtL3LcfG9wmW2/pY0cWcZQnlzkCSka17NyoHMyFQmqBxiRjxqGK/bnxMB9SBdIYZca+h8lkfaMojQ1j4jioRMZycn3OTALqDxLvsaHiqCq3d8hRmaTCzMKb1cbXZYKvEqDUK11PrTcAjtIDGYc2BLl/zeNEkofsHFdWmQdt2H8hpkXac8+fSDH4CIAvGRN5YzAKcGO5ycEng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by IA1PR11MB6267.namprd11.prod.outlook.com (2603:10b6:208:3e5::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.23; Tue, 27 Jun
 2023 08:54:34 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e7db:878:dfab:826d]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e7db:878:dfab:826d%3]) with mapi id 15.20.6521.023; Tue, 27 Jun 2023
 08:54:34 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "jgg@nvidia.com" <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
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
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
        "clegoate@redhat.com" <clegoate@redhat.com>
Subject: RE: [PATCH v13 22/22] docs: vfio: Add vfio device cdev description
Thread-Topic: [PATCH v13 22/22] docs: vfio: Add vfio device cdev description
Thread-Index: AQHZoDaix48j/fAvNky2csY4DXj56K+V1V8AgAiMsLA=
Date:   Tue, 27 Jun 2023 08:54:33 +0000
Message-ID: <DS0PR11MB7529C5F9C31CE343AB66B0D4C327A@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230616093946.68711-1-yi.l.liu@intel.com>
        <20230616093946.68711-23-yi.l.liu@intel.com>
 <20230621155406.437d3b4d.alex.williamson@redhat.com>
In-Reply-To: <20230621155406.437d3b4d.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|IA1PR11MB6267:EE_
x-ms-office365-filtering-correlation-id: 408c8857-4fd1-410f-4e17-08db76ec20a5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hKcCO7wQzpXJKi7BWTm2XtWAxTmq6iv3hh6+V9QFtP32RVtBNQazTv8lYUMs/qapm7kOBJ1MsGvIOwt/R+UUEVcAyokmieJT3DIPSvLS45qRLsmtgHH+UZAn7hEJOnr8lY47vbsksUPd8e0NnvvANPlaozvwogapDk36Eqpm/KPIUo3d5k94VQ8upMHDzQzqAGarfdx5fq8Ntcdq+/zwzDutLr7Q7aHYJMWcSH2wa2tPhRruCq52dbmlIbLZn/FaW3QwvzIxbyHsMgbMtYF66sGdVXxzpFX7y8+vztJNk6qkgsSQ8/V/hC6DpwfK35FSVd6uo0cRToHIAXv9Qe/rcH9opLJil6NdemKWUYG2ydTYQB1O/4OdZHRM7OvbGVaBPLOhGjSa0dVpk73vc3n+IO823YWzaBSPtMJVvhNKvMNdI3xZieHnevasMKvdxjH6M0stJRdkB4r4TP8wj75xpCpZE77zcoCobci4OVim5TE04t5JokSrudVKhHELHL0MnGr3MlhMZL0aFyzUD2NzFREmcep5KHbpwtNZqICBG5c2sOxM72k8pjdRrQBVJ8Ua9QlvsLKZiYIePVYmnFMx/fpZXiPsuRyP0btkjODis7w=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(396003)(376002)(136003)(366004)(346002)(451199021)(83380400001)(7696005)(966005)(478600001)(54906003)(9686003)(33656002)(66556008)(66946007)(2906002)(186003)(6506007)(26005)(66476007)(64756008)(71200400001)(66446008)(7416002)(316002)(41300700001)(76116006)(38100700002)(8676002)(5660300002)(52536014)(8936002)(122000001)(4326008)(6916009)(55016003)(86362001)(82960400001)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bk8zVGdPWlg0dlhXQW1GNTMxSytDTWRhYW9QdmFWZW1aOGlPaEZ4aUE0Z2Zr?=
 =?utf-8?B?UVBuZHF4MnoyT3hBUmlNYlhMcXNGVndxNUZ6U3NJRzk5KzRTdk9lUElLckI4?=
 =?utf-8?B?cmhRdlBYUHR5UC9HRjlJR1Q0WnFQRFBJV2dTUm1lemE2MjlrVkJGRDNweGhv?=
 =?utf-8?B?TGxGRmFld2NINVBGeXFHUlNIdERrNnhHc1UyaklMUFFyTlRBalFDOC9jcGdZ?=
 =?utf-8?B?K0JsTnhtYk1mWHk3Z1p2VWQ1SDNYRTJTd3BhNzZaY0xKUXBUOGJUN1RUR1Vk?=
 =?utf-8?B?ekY5L0RaamlGYzlOKzZLNk9hZkx3MGlEaFpYbkRVWUU3S0RjRDBXU1lyZS85?=
 =?utf-8?B?bGowTlRrWjQwWEZQT0dGbGhxdVNpMFZIN0hVRDdWU0hONFZBZkh0UWlCdFpD?=
 =?utf-8?B?dG9zK3FhSjRYbVEveXZsYkhHSkk1NUtUNjZJMjlkWDJGK2N4SkZsQVBUS0Ra?=
 =?utf-8?B?Z0dTUmtLNXd5RDlIV0NBWjhyU254Q1N4cjZ1VmFUcHREbktFTHMrRVBWR2Rx?=
 =?utf-8?B?MWN6cU16QkN2VVk3aVliWnEweGR6alJxSDVIb3A1azh1eFo2Q2FRSlMrZWJS?=
 =?utf-8?B?QTdjRFE2U1pmTTJhUVdtZytGVmYxbDBKeTBTY09nYUMwNkpKYVpxVTdjVTQ5?=
 =?utf-8?B?VzJVbnVmTjdaRVFpZ1BEdHArZUZSZ3M4enNNclVaUmdCa24xN20xK1YzM0pG?=
 =?utf-8?B?UjFURHZyOWNjTHg3Q3hlRXA0WWpTaENkbHVCUVNWQWZSZGRoYWg5MkZEZFZ2?=
 =?utf-8?B?eE1hTncyYWZrMXV0UVFZeTdsVDRJQk40aUtpMHpDVndaNE9ubCtXbS91OGZt?=
 =?utf-8?B?dUxKTmFqUTNYWU9vT2FEQnNWU3Z1NkM0ZENwRVRiWUQ5QzJxVVdZQWxQSmFY?=
 =?utf-8?B?Rkg5SGhsYjlPUmZoUExhQ1ExV2gweDlMOWdSeWx5YjNIQW5ObmhTMHVPRmtx?=
 =?utf-8?B?MFpRZmpMNEtRUEZFNlJjOElaL3VnSnNnLzdTSFJUUmhMVE5keE9TbW1Lcm13?=
 =?utf-8?B?c1NpWnA1a09wbGRRem1nakZ3cnIvd2ZxQ0FQL1QwRnRSS1ZtVlFCZk9WWCtE?=
 =?utf-8?B?K005QlpLYllSeUlIaVl4MTlWSGFWWFNYUjNqcDU5dmFvdk9meTNtWkdET0pB?=
 =?utf-8?B?aTBrVkRmZUUwNXpLOU01dWc3NDRmMHlFc1U5d285dFFkQlBLVGlyWXArR2Rs?=
 =?utf-8?B?WTZSMERoaWl5TVErM082S1IrK3cyNjBlKzEwbFBzYmIyNVBaN2tUU3dCMzZW?=
 =?utf-8?B?ZmRBVWg4MFhPRytGdWhVUlJPUmxvTmtpaU5raTVGT3FsaGg1TzVDemdDdldp?=
 =?utf-8?B?R3R0TzU2NkNraTVPVWo1QkVZcjFRTC9VVFJIaVVSSm0rVENUNk5nNWdNQzNN?=
 =?utf-8?B?MEcvbTErUmJ3UjN2SDRFVjdncUpTYXY2TkVlM2pOOVdnVmYvREJWRTFtbk9z?=
 =?utf-8?B?RjdGVVdYMnRpM001NmpZS0laSndkZWx1T2FIdFZVT3hyc2ZvV0NsTXc5c2NH?=
 =?utf-8?B?Uk9oSVhaTmdsUTUvNEh5K1VhUDN1eUlBdHlvcE0wWklwYmlUU2I3cEN2OUxW?=
 =?utf-8?B?MlZxLzRTN2VsNi9Nd3FNTVdHb0lDZHZ5Ri9ZY3FSSmthd1E5ODRqSHBMOUQz?=
 =?utf-8?B?Ty9CSUoyUWxBWWFhVlZUbHhGNWw0NFhvM0UxVUVLQmxRU2djRk5BciswbVR3?=
 =?utf-8?B?Rjhzb1ZjMVludENlNFdJOGQxY0o2RzBFWVdaNFF6WWVvRGVQdkUzVTZjVCtJ?=
 =?utf-8?B?UlpjM0hCcGJFNXgvRG1XamJodkFCQ2sxWEhjdGdycTRxVWJKblRVTkpCNUUr?=
 =?utf-8?B?SVRqL1hURzF0S1VpenVxRncvOFM2QTZTaWthM3BvSStOdHd5eTM3ejNXTitR?=
 =?utf-8?B?Z2NTZnhqRFBaSHNFYTZaN2sxMWdPMmNFRzdCZ3o1OXhCYzBtakU4U0JxSXZJ?=
 =?utf-8?B?OGRuU3VZNTJqaUxjU1kxbVErWkNsSnFXSStTYU5DckhaWTlXZndGU3UydDJr?=
 =?utf-8?B?UG5kQkYwZzRmVmFiWmw4T3BieXAwMWpnTS9mNk8rOHpUSTE4QlFNWW0rMFM1?=
 =?utf-8?B?eTFzUFBDR1J0cGFYVGswRzhZcG54bGZMSmg3L1BTZTdRd2FwSFZpdDd5UDdJ?=
 =?utf-8?Q?gTTGlxGwKPcqu/y/BQSQuARf7?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 408c8857-4fd1-410f-4e17-08db76ec20a5
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jun 2023 08:54:33.4679
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +doNowzvgbIFNdBtQHEKwOVtj8pc8zJ0yN3zetpxhG4OCvVB9nRyqlc3hH8ICygkFeQvqTl76brZjldPWs6BBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6267
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

PiBGcm9tOiBBbGV4IFdpbGxpYW1zb24gPGFsZXgud2lsbGlhbXNvbkByZWRoYXQuY29tPg0KPiBT
ZW50OiBUaHVyc2RheSwgSnVuZSAyMiwgMjAyMyA1OjU0IEFNDQo+IA0KPiBPbiBGcmksIDE2IEp1
biAyMDIzIDAyOjM5OjQ2IC0wNzAwDQo+IFlpIExpdSA8eWkubC5saXVAaW50ZWwuY29tPiB3cm90
ZToNCg0KPiA+ICtWRklPIGRldmljZSBjZGV2IGRvZXNuJ3QgcmVseSBvbiBWRklPIGdyb3VwL2Nv
bnRhaW5lci9pb21tdSBkcml2ZXJzLg0KPiA+ICtIZW5jZSB0aG9zZSBtb2R1bGVzIGNhbiBiZSBm
dWxseSBjb21waWxlZCBvdXQgaW4gYW4gZW52aXJvbm1lbnQNCj4gPiArd2hlcmUgbm8gbGVnYWN5
IFZGSU8gYXBwbGljYXRpb24gZXhpc3RzLg0KPiA+ICsNCj4gPiArU28gZmFyIFNQQVBSIGRvZXMg
bm90IHN1cHBvcnQgSU9NTVVGRCB5ZXQuICBTbyBpdCBjYW5ub3Qgc3VwcG9ydCBkZXZpY2UNCj4g
PiArY2RldiBlaXRoZXIuDQo+IA0KPiBXaHkgaXNuwrR0IHRoaXMgZW5mb3JjZWQgdmlhIEtjb25m
aWc/ICBBdCB0aGUgdmZpbyBsZXZlbCB3ZSBjb3VsZCBzaW1wbHkNCj4gYWRkIHRoZSBmb2xsb3dp
bmcgaW4gcGF0Y2ggMTcvOg0KPiANCj4gY29uZmlnIFZGSU9fREVWSUNFX0NERVYNCj4gICAgICAg
ICBib29sICJTdXBwb3J0IGZvciB0aGUgVkZJTyBjZGV2IC9kZXYvdmZpby9kZXZpY2VzL3ZmaW9Y
Ig0KPiAgICAgICAgIGRlcGVuZHMgb24gSU9NTVVGRCAmJiAhU1BBUFJfVENFX0lPTU1VDQo+ICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIF5eXl5eXl5eXl5eXl5eXl5eXl4NCj4gDQo+IE9yIGlm
IEphc29uIHdhbnRzLCBJT01NVUZEIGNvdWxkIGRlcGVuZCBvbiAhU1BBUFJfVENFX0lPTU1VIGZv
ciBub3cgYW5kDQo+IHRoZSBleGlzdGluZyBLY29uZmlnIG9wdGlvbnMgd291bGQgZXhjbHVkZSBp
dC4gIElmIHdlIGtub3cgaXQgZG9lc24ndA0KPiB3b3JrLCBsZXQncyBub3QgcHV0IHRoZSBidXJk
ZW4gb24gdGhlIHVzZXIgdG8gZmlndXJlIHRoYXQgb3V0LiAgQQ0KPiBmb2xsb3ctdXAgcGF0Y2gg
Zm9yIHRoaXMgd291bGQgYmUgZmluZSBpZiB0aGVyZSdzIG5vIG90aGVyIHJlYXNvbiB0bw0KPiBy
ZXNwaW4gdGhlIHNlcmllcy4NCg0KQEphc29uLA0KSG93IGFib3V0IHlvdXIgb3Bpbmlvbj8gU2Vl
bXMgcmVhc29uYWJsZSB0byBtYWtlIElPTU1VRkQNCmRlcGVuZCBvbiAhU1BBUFJfVENFX0lPTU1V
LiBJcyBpdD8NCg0KPiBPdGhlcndpc2UgdGhlIHNlcmllcyBpcyBsb29raW5nIHByZXR0eSBnb29k
IHRvIG1lLiAgSXQgc3RpbGwgcmVxdWlyZXMNCj4gc29tZSByZXZpZXdzL2Fja3MgaW4gdGhlIGlv
bW11ZmQgc3BhY2UgYW5kIGl0IHdvdWxkIGJlIGdvb2QgdG8gc2VlIG1vcmUNCj4gcmV2aWV3cyBm
b3IgdGhlIHJlbWFpbmRlciBnaXZlbiB0aGUgYW1vdW50IG9mIGNvbGxhYm9yYXRpb24gaGVyZS4N
Cj4gDQo+IEknbSBvdXQgZm9yIHRoZSByZXN0IG9mIHRoZSB3ZWVrLCBidXQgSSdsbCBsZWF2ZSBv
cGVuIGFjY2VwdGluZyB0aGlzDQo+IGFuZCB0aGUgaG90LXJlc2V0IHNlcmllcyBuZXh0IHdlZWsg
Zm9yIHRoZSBtZXJnZSB3aW5kb3cuICBUaGFua3MsDQoNCkBBbGV4LA0KR2l2ZW4gSmFzb24ncyBy
ZW1hcmtzIG9uIGNkZXYgdjEyLCBJJ3ZlIGFscmVhZHkgZ290IGEgbmV3IHZlcnNpb24gYXMgYmVs
b3cuDQpJIGNhbiBwb3N0IGl0IG9uY2UgdGhlIGFib3ZlIGtjb25maWcgb3BlbiBpcyBjbG9zZWQu
DQoNCmh0dHBzOi8vZ2l0aHViLmNvbS95aWxpdTE3NjUvaW9tbXVmZC90cmVlL3dpcC92ZmlvX2Rl
dmljZV9jZGV2X3YxNA0KDQpSZWdhcmRzLA0KWWkgTGl1DQoNCg==
