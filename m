Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C99A34FCCA3
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 04:49:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241104AbiDLCvg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 22:51:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiDLCve (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 22:51:34 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64B60BCA4
        for <kvm@vger.kernel.org>; Mon, 11 Apr 2022 19:49:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649731758; x=1681267758;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=J0l4bGsyOmT3NAPxkPaVUUkUtunhh9XCUe5SzoPBrx8=;
  b=X1hbWXlkCE1UHz8A1cZD9lhK+GX+9QS7/+lMejHgJ4VWrWvQXtKwg3Vc
   uMUAxr35on2+oY4P3PnRgY2uBcrTQFqG6+3ivxnm7U2MXqSIFVXdhxCRM
   d7IwM4OUNnGp8eA7BemYDEj7Tlp54z8FNovtOuGIMMY/ZpNx9DuLGkbH7
   onE8P1MY3v9VPkrWnFaRUhRSOb7c/soh1aMfNsONAO0Yr44I5Xly1zRVN
   1ByWBigHMw45xvWfHeyNS+ttDqmWoZkKppBJ8p2K8SzfzLXu2BnAWi2Pt
   ymgWUbekBY2EZ1eieUAEbXfr05n2Yh9C3cRNdSP2AtDFaM2WRCbGO/1u+
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10314"; a="322707563"
X-IronPort-AV: E=Sophos;i="5.90,252,1643702400"; 
   d="scan'208";a="322707563"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2022 19:49:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,252,1643702400"; 
   d="scan'208";a="507359425"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga003.jf.intel.com with ESMTP; 11 Apr 2022 19:49:17 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 11 Apr 2022 19:49:17 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 11 Apr 2022 19:49:17 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Mon, 11 Apr 2022 19:49:17 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.48) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Mon, 11 Apr 2022 19:49:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BwCqEhOEnabl3twXP0bKRJd2Wdfe8FI/rxjFRxfSSujMgKU/mFrR6+KuKSydlYbMzFk7WvdKO91PZY296WLeT8t9aVE8OZjkhOGHY+oAqgMFV97nU32GJ86FQcfAndOjxxxzFIpVi+ouPKfP11W/fjo1kVlVfFbaaDpwD1tbkAtfgv0CxlfBD7mY4TTH9fOGisNdO5bQPHwHl++xJ6WXMybqeQyE/BriDhVxt3+gZ0z5FuHz60gRnczc44zlFwXVNam4Uz4O5qL1Fv5CoQYk2aqMQ+wMfVeiLjofj3e7IUEajfNzoL6NFb8uK4iCYH5e4L5a5tfqxCoJCHS0hs2CXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J0l4bGsyOmT3NAPxkPaVUUkUtunhh9XCUe5SzoPBrx8=;
 b=C5sp8aOkspvansvQgekgN6hD/RcgrziY7GCvNkB4+v2tzfAI3IGc86qXPj1UEA8f3fgp5uZXtO8spiefV0u31Lt4OAnSamYdInzQOwpyFvpXTL0aQMH2ZguaAq2sc1Kh7l2w9KSUn6BWp+wda//GSk4CkTcKmEWk+NZxL1nbjGRuBmrJlvgIZ8UyKerPZHUd1XXHbu5C/lIV4yz8fiksDXsHTnpX2GlEDP7T76OVGzVGL0w4YlHvR1t71BltHgSr29iK3tzHVhIjFljv0sC2Aw65gnL06/RShkUHSKdAWL502pub5For/GQ70FSS3UFScG5UfOk45i/twzbNKMN5GQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MW3PR11MB4537.namprd11.prod.outlook.com (2603:10b6:303:5d::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Tue, 12 Apr
 2022 02:49:15 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c4ea:a404:b70b:e54e]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c4ea:a404:b70b:e54e%9]) with mapi id 15.20.5144.030; Tue, 12 Apr 2022
 02:49:15 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Robin Murphy <robin.murphy@arm.com>,
        Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "David Woodhouse" <dwmw2@infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>, "Christoph Hellwig" <hch@lst.de>
Subject: RE: [PATCH v2 0/4] Make the iommu driver no-snoop block feature
 consistent
Thread-Topic: [PATCH v2 0/4] Make the iommu driver no-snoop block feature
 consistent
Thread-Index: AQHYSpOFxZ/QKUg0ZEGhoQEsmfFbSqzkrbGAgAALHwCAAAU0gIAAEooAgADpbQCAABLzgIAFzXuQ
Date:   Tue, 12 Apr 2022 02:49:15 +0000
Message-ID: <BN9PR11MB5276F807493E771DBAD3A28E8CED9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v2-f090ae795824+6ad-intel_no_snoop_jgg@nvidia.com>
 <f5acf507-b4ef-b393-159c-05ca04feb43d@arm.com>
 <20220407174326.GR2120790@nvidia.com>
 <77482321-2e39-fc7c-09b6-e929a851a80f@arm.com>
 <20220407190824.GS2120790@nvidia.com>
 <BN9PR11MB527648540AA714E988AE92608CE99@BN9PR11MB5276.namprd11.prod.outlook.com>
 <f904979d-35ee-e2b8-5fd3-325d956be0d7@arm.com>
In-Reply-To: <f904979d-35ee-e2b8-5fd3-325d956be0d7@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: eb493565-7525-44bc-2f24-08da1c2f0820
x-ms-traffictypediagnostic: MW3PR11MB4537:EE_
x-microsoft-antispam-prvs: <MW3PR11MB45371A0978C81CCC02697CCC8CED9@MW3PR11MB4537.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: B84SkK7WXYIPVL5DizxKw+LcCDeiz4XRRP1i2vqdHILPi0DhOUdnzTOdDeUpGcH+Irxeq0jXDfaPJpGGH/wkCO693fB1SKS/BFvbolczYLVPa6YA4N+/MuZOC1ck0OSMcNImL2vCTrPDJZewCq2DuQUFimioESurPwuB6Qv9jzEeucD9abxbgWLG5TFWXNPto0wJArUhXK1gMPej0fgl4uvhJRKQXFLIg2wZOS1aeBzdkcPOa7KTC8kt9Rr2j1MHS5I+dK/hptoA/FrdAXJR53XWCoCdpzUHjxtD+vGMp0KzPwMmjPvUe9ApdoYo/h0fTSCLlHtyQiDruThu1f96pgZZbhxS+P5md5sB4nY8EcTJEW7FDzDQlKw0YXOuhoisZmNIrdjKNmqb/nHxlGi/2UPT/EmbEimLNQwnXJTfSGqHuJbmfemNUYMaHV4L2PYMZcOp4+/PlsZWhAC+Fp4jmK44/AnNlHFuz33/YDDgsA0VYs6ANSzDwLQzFwpj6j1EQ6JTlcfRXaZyNnEW524EXMX6qX0AUgkX048bKbDv9bPoGin7jG6uOb2C4lKm7x/kInmeg+E31fzUo7yn9keygw7+YZiaYGRA9j/VdUzYujMmGjXuZxVWuBLsOYtJJPqah6xzSdRkVELjjiymIbV0cuzBj7hDZsJEJb9toowZlV+P3bXquaMUW7bAosGLeYTRPW51z+4RgUCH3RFnZIIwVg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(9686003)(52536014)(38100700002)(38070700005)(8676002)(66556008)(66446008)(64756008)(66946007)(4326008)(66476007)(122000001)(8936002)(7696005)(53546011)(6506007)(5660300002)(76116006)(7416002)(82960400001)(86362001)(54906003)(55016003)(110136005)(316002)(186003)(26005)(33656002)(2906002)(71200400001)(508600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MjdYTTZVVjRVUmNDVmVkZVd4cE1nUlFiVzlLSHBTK2FrL09JNzlxNi90K2ZB?=
 =?utf-8?B?MDUwZ1hnV2RZM2U4T29FQlFIYThYTjNMcGFoNHA2dVUrMzlGaTNQeHY0aWxU?=
 =?utf-8?B?U3VpZ090YTZ2NHpseXZIS3luVmhGb3FHQ0dBR1VKU3F3T3ZrYkVhVlVGQkF3?=
 =?utf-8?B?WU1NYVVlWW1YU3NYbFJhSDZKMHlHeHNKQWdMZmp2eCtST2VNUUpBYkFObDBC?=
 =?utf-8?B?L1Urazlwb1drSWRBL25McEVtWHMxeCtrSzNxdVZTZ3lrd3BrYWc1Yk8xbE9H?=
 =?utf-8?B?TWxTRG9hc3B3WllGdGY2SG9QTjVoeUpLS0Jmd1FIL2d1RUlEL0VnY3NZd1Zu?=
 =?utf-8?B?eTJGOENwaXBibkZ4RUlyNWN1SU1LZnIwTzcxdStZS2lhQkFqcFF2LzVBR1NS?=
 =?utf-8?B?bUpHRkprTUZHTm5GK3JOL0JwRVJwYXVhdWtvUDA3bE1UOWJtRFJiT2JsY3dH?=
 =?utf-8?B?clZZMDdQeGNsV3pCaXJzempwUHN1eWdFc1VPcjZPbndqNUJMR0p0UDMxWkhF?=
 =?utf-8?B?VkpDZzZNTGlGWXFYMGt1a0F5Z3RvWmp5R2JKSlNhYU5ocHlDWVJWU05BY1pY?=
 =?utf-8?B?VDMvNEFxZVBPU2tGY2ZDZ1JGWlpkajJmSVptMnVmb1B6RUoyOURKMHQyNnV2?=
 =?utf-8?B?Z1JqcEkrN0lHNGgzWG9CVXQvbGg5Rk5jR0JDTHd6b3hmYjZvdkp5THZDNDZw?=
 =?utf-8?B?YU92TVl2YTFleTRQRTZoRDBULzRqU3UyWE1IeS96Sm93RnI1T0wxOFJHWjRa?=
 =?utf-8?B?QmlRQ1VRbEhXZWZmNXV1NkYwVnh0aHFNVTFoeCt3NEg5U3NOeW5LWVBmb3Ju?=
 =?utf-8?B?RHJRQWxHSXZoZU9qNEVpeStXZnRFUDdjbWZzbHVMZVo5Y2lLZWR4eWxZZGpE?=
 =?utf-8?B?YU1GMStSK2s2YnJnYnBvYm1NV1l1MGFITWRnTC9Ldm50TjR4dFkyZWRYelhV?=
 =?utf-8?B?UEd0OEhBa0hnTzdFeEJpcUxPTExpK3czUDV5VWpyWFl1TXpPaGJPNGdCK3M0?=
 =?utf-8?B?L1V3aVljYzk1Z3c0TXZPR2kzemJRNjQxRk9ianBBTWF2T01pTEZhVXQ3Njl6?=
 =?utf-8?B?WFVBWS83ejd0OWZCWEcyYkw2MTh5cGZaUklQVUNOK25uVjZTRytGeXdCbk4v?=
 =?utf-8?B?d0xOUk8weUdJcVJ2NVBKT2xFV3kvYkpXNHhxS2VDN1ZaeS8yRGFMOTBkZTRl?=
 =?utf-8?B?UnFSbFBtcVpINThuQnBqR2ZRcDU0SWJ4M2hKVDRoS3RoL0R6RnFFcnhiOC9u?=
 =?utf-8?B?S3JUZGpiSVVYWVVQVmxNVkVabHFzVVBiZEdUN1JXM1hlWHoydlVkVUpBZDRy?=
 =?utf-8?B?WklFWVFrY3NwMkxDWlRrY3czRy9ZeFlMdmdHVmhtSC94YUVhdzBQMFE0dENO?=
 =?utf-8?B?VFBCNXg3QkdoaVVBTkhaS2ppeHlHdCs0VkMyeC9DZDZkUkN6cXVrVVkyU2Nk?=
 =?utf-8?B?alRWSlBaMFpNRmxxNzh3RjVHWXBMV2dZY25jYjU3V2RSNXpmZ1ZJWENjRm9J?=
 =?utf-8?B?dkkvOWN0ZWJnRzhxSkgxSzBncWwwU1NUUlFmYkFJdjJub2xPMUlGc1JtUE4x?=
 =?utf-8?B?SlBtNGxtSGUzT3dudkN2MFp0Lzlaa3AyeFdBaHZxZ0pNNjYxdTJXYjQveGYz?=
 =?utf-8?B?ZE16Q0llcy96MWZvdE5Ia015NkxZUERiUng2QTJpT1c3NVIzM1NrbDZuUzRV?=
 =?utf-8?B?cm9NYWpuajRoNzlVREZSVVRRUWdTZjIzZ2trblA0OEtkSFVjMXZMa3Z0UWs4?=
 =?utf-8?B?RGFxaGlDRTZnaXA0OE94RGYySHlHc2J2ZCtmNEJYaDdTeTZnV0Q3eFdXOVA1?=
 =?utf-8?B?emo4RGRZZFhrdnF6NGw1MHVsUlhDM3JpdENiemN0clpDSXlTalJJK2hmUVlv?=
 =?utf-8?B?RWl4Mi8vWWFTaVhNcG02QlVhRkkzMlZuSkdLZTErMmZUbW9HeGowWnpCT0lj?=
 =?utf-8?B?RWd3TEVaL0kwUjdMNy9SNEU1NEZsRGR3bUJpWVIxejF1OERFK3VxL1BvcWZQ?=
 =?utf-8?B?bzlGdkswVTZKSldMWUErc1Q4Tyt6Tk04Yis5V0ppMk1vYlQzVXpoMStmQTZX?=
 =?utf-8?B?d0tXbmlXaTRDTTRoeDNoL3puNXFlUUl4bFI0SGpJeUNGcHl0bEtxNWZtbUlD?=
 =?utf-8?B?Mm9ORWRSUnBGdmxoUUZnRnFUb0pQZ2ZUbDlwTVdyOXJyUXUrbVoxM2F0SUNI?=
 =?utf-8?B?MXZUZVN6aVVoMXhtMEJlVHNsb25vZEFFZ2JFMGlvSlRTWk1mVndzTkpkdWk5?=
 =?utf-8?B?ZFlmbGEwejFQYTBmckJTSU9TbG9JTHozeGtMcVVwNDNvZ2xwaUM2WFlNSHFy?=
 =?utf-8?B?dXBkSzFFeUs2TzdwWHd0ZUVNamxRKzFMWTZISEdNempjWGFWMmhBUT09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb493565-7525-44bc-2f24-08da1c2f0820
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Apr 2022 02:49:15.0620
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9uUGgCXIomwtBQtPZIMszzC+ZdiQ2Nhg6qEuPchCxE4PPmOk9dVY7XmDPGQ/ijqLYaG3Gy8+uP7NwMutM0WRvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4537
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBSb2JpbiBNdXJwaHkgPHJvYmluLm11cnBoeUBhcm0uY29tPg0KPiBTZW50OiBGcmlk
YXksIEFwcmlsIDgsIDIwMjIgNjoxMiBQTQ0KPiANCj4gT24gMjAyMi0wNC0wOCAxMDowOCwgVGlh
biwgS2V2aW4gd3JvdGU6DQo+ID4+IEZyb206IEphc29uIEd1bnRob3JwZSA8amdnQG52aWRpYS5j
b20+DQo+ID4+IFNlbnQ6IEZyaWRheSwgQXByaWwgOCwgMjAyMiAzOjA4IEFNDQo+ID4+IE9uIFRo
dSwgQXByIDA3LCAyMDIyIGF0IDA3OjAyOjAzUE0gKzAxMDAsIFJvYmluIE11cnBoeSB3cm90ZToN
Cj4gPj4+IE9uIDIwMjItMDQtMDcgMTg6NDMsIEphc29uIEd1bnRob3JwZSB3cm90ZToNCj4gPj4+
PiBPbiBUaHUsIEFwciAwNywgMjAyMiBhdCAwNjowMzozN1BNICswMTAwLCBSb2JpbiBNdXJwaHkg
d3JvdGU6DQo+ID4+Pj4+IEF0IGEgZ2xhbmNlLCB0aGlzIGFsbCBsb29rcyBhYm91dCB0aGUgcmln
aHQgc2hhcGUgdG8gbWUgbm93LCB0aGFua3MhDQo+ID4+Pj4NCj4gPj4+PiBUaGFua3MhDQo+ID4+
Pj4NCj4gPj4+Pj4gSWRlYWxseSBJJ2QgaG9wZSBwYXRjaCAjNCBjb3VsZCBnbyBzdHJhaWdodCB0
byBkZXZpY2VfaW9tbXVfY2FwYWJsZSgpDQo+ID4+IGZyb20NCj4gPj4+Pj4gbXkgVGh1bmRlcmJv
bHQgc2VyaWVzLCBidXQgd2UgY2FuIGZpZ3VyZSB0aGF0IG91dCBpbiBhIGNvdXBsZSBvZiB3ZWVr
cw0KPiA+PiBvbmNlDQo+ID4+Pj4NCj4gPj4+PiBZZXMsIHRoaXMgZG9lcyBoZWxwcyB0aGF0IGJl
Y2F1c2Ugbm93IHRoZSBvbmx5IGlvbW11X2NhcGFibGUgY2FsbCBpcw0KPiA+Pj4+IGluIGEgY29u
dGV4dCB3aGVyZSBhIGRldmljZSBpcyBhdmFpbGFibGUgOikNCj4gPj4+DQo+ID4+PiBEZXJwLCBv
ZiBjb3Vyc2UgSSBoYXZlICp0d28qIFZGSU8gcGF0Y2hlcyB3YWl0aW5nLCB0aGUgb3RoZXIgb25l
DQo+IHRvdWNoaW5nDQo+ID4+PiB0aGUgaW9tbXVfY2FwYWJsZSgpIGNhbGxzICh0aGVyZSdzIHN0
aWxsIElPTU1VX0NBUF9JTlRSX1JFTUFQLA0KPiB3aGljaCwNCj4gPj4gbXVjaA0KPiA+Pj4gYXMg
SSBoYXRlIGl0IGFuZCB3b3VsZCBsb3ZlIHRvIGJvb3QgYWxsIHRoYXQgc3R1ZmYgb3ZlciB0bw0K
PiA+Pj4gZHJpdmVycy9pcnFjaGlwLA0KPiA+Pg0KPiA+PiBPaCBtZSB0b28uLi4NCj4gPj4NCj4g
Pj4+IGl0J3Mgbm90IGluIG15IHdheSBzbyBJJ20gbGVhdmluZyBpdCBiZSBmb3Igbm93KS4gSSds
bCBoYXZlIHRvIHJlYmFzZSB0aGF0DQo+ID4+PiBhbnl3YXksIHNvIG1lcmdpbmcgdGhpcyBhcy1p
cyBpcyBhYnNvbHV0ZWx5IGZpbmUhDQo+ID4+DQo+ID4+IFRoaXMgbWlnaHQgaGVscCB5b3VyIGVm
Zm9ydCAtIGFmdGVyIHRoaXMgc2VyaWVzIGFuZCB0aGlzIGJlbG93IHRoZXJlDQo+ID4+IGFyZSBu
byAnYnVzJyB1c2VycyBvZiBpb21tdV9jYXBhYmxlIGxlZnQgYXQgYWxsLg0KPiA+Pg0KPiA+DQo+
ID4gT3V0IG9mIGN1cmlvc2l0eSwgd2hpbGUgaW9tbXVfY2FwYWJsZSBpcyBiZWluZyBtb3ZlZCB0
byBhIHBlci1kZXZpY2UNCj4gPiBpbnRlcmZhY2Ugd2hhdCBhYm91dCBpcnFfZG9tYWluX2NoZWNr
X21zaV9yZW1hcCgpIGJlbG93ICh3aGljaA0KPiA+IGlzIGFsc28gYSBnbG9iYWwgY2hlY2spPw0K
PiANCj4gSSBzdXBwb3NlIGl0IGNvdWxkIGlmIGFueW9uZSBjYXJlZCBlbm91Z2ggdG8gbWFrZSB0
aGUgZWZmb3J0IC0gcHJvYmFibHkNCj4gYSBjYXNlIG9mIHJlc29sdmluZyBzcGVjaWZpYyBNU0kg
ZG9tYWlucyBmb3IgZXZlcnkgZGV2aWNlIGluIHRoZSBncm91cCwNCj4gYW5kIHBvdGVudGlhbGx5
IGhhdmluZyB0byBkZWFsIHdpdGggaG90cGx1ZyBsYXRlciBhcyB3ZWxsLg0KPiBSZWFsaXN0aWNh
bGx5LCB0aG91Z2gsIEkgd291bGRuJ3QgZXhwZWN0IHN5c3RlbXMgdG8gaGF2ZSBtaXhlZA0KPiBj
YXBhYmlsaXRpZXMgaW4gdGhhdCByZWdhcmQgKGkuZS4gd2hlcmUgdGhlIGNoZWNrIHdvdWxkIHJl
dHVybiBmYWxzZQ0KPiBldmVuIHRob3VnaCAqc29tZSogZG9tYWlucyBzdXBwb3J0IHJlbWFwcGlu
ZyksIHNvIHRoZXJlIGRvZXNuJ3Qgc2VlbSB0bw0KPiBiZSBhbnkgcHJlc3NpbmcgbmVlZCB0byBy
ZWxheCBpdC4NCj4gDQoNClllcywgdGhhdCBtYWtlcyBzZW5zZSBpZiBubyBzdWNoIGV4YW1wbGUg
c28gZmFyLg0K
