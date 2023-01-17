Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC17666DF79
	for <lists+kvm@lfdr.de>; Tue, 17 Jan 2023 14:53:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231174AbjAQNx1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Jan 2023 08:53:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230219AbjAQNxF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Jan 2023 08:53:05 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86FB83C2A6
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 05:52:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673963534; x=1705499534;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=yw/vVmB+uKwicZSSe7+nfFW2O/zJWBbF9teZnNFRaCI=;
  b=O9fs7Dp/jr2b6tvqyj1jYu1OWwPs/mQJnXVcqi+gEhS79hCyYS9liKS8
   Q3W8PyQZTn5rQa4qqBYC0QJon0PPv47PDjnoIceX969sDfZpDeSQeoW6/
   XCTk0cHbDG4AZXXeAGWNl4/Q+qpzogokMXH9ylFAr0xiZj4VQW2cTkBkb
   DJUiBuRWsEGvDfbcdpc9Jh/H2oAj9r6A96NdXnvX1CdIEUjyZwVGM0UKM
   E9vY3XpWPSCqBmkitqf/JPkHetyqkUbMkw+zELiX3bwTo2lH956F1zmNM
   p8iXHHTmUTumZaY7W9jUT5zfpwRquzW9i39LsFEhbTwo6LoYl1l8BMsuc
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10592"; a="351943699"
X-IronPort-AV: E=Sophos;i="5.97,224,1669104000"; 
   d="scan'208";a="351943699"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2023 05:52:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10592"; a="609245847"
X-IronPort-AV: E=Sophos;i="5.97,224,1669104000"; 
   d="scan'208";a="609245847"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga003.jf.intel.com with ESMTP; 17 Jan 2023 05:52:06 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 17 Jan 2023 05:52:05 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 17 Jan 2023 05:52:05 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 17 Jan 2023 05:52:05 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 17 Jan 2023 05:52:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cRw7hJ0Z4Et7P9VqW+HD6WSeG+X9aGzFAySRqcXZHAngbZaNl6ruyhpfs1PqomVyHU37kW36NpmOJepKpixhk+vGFE9q8oThKgLOUiX9Y/R3jxHO6l7aq1R7wAi8WbsJowyvuPuWpJMzjdG6au9/onxciUB+m1qQV1JpI1KOuXTcckixEWqFQ9pNAXcN0kssIoUk56SkFeo5s3JwbRzwJhg9s4Fovh/9/Q/o65tVY3vzE8UFs2ovZJ2WLuQmP5/msPxwWzrrU8eNu35q7+LGCx8IYDebl5N01+DTwRS2vUgHJ70lt3/u+SQRywZr/uQvsH2JWvc/vp2IdPk42PyUWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yw/vVmB+uKwicZSSe7+nfFW2O/zJWBbF9teZnNFRaCI=;
 b=cLRaX2TYNuQy2jBaHCeemP1GLHEDTr35ZmriWc52CkxRqHaQs2WIwjb5dRhcUszO6h/1DcBkxejD4pnSYWaaDhImf47/J/CDYPA7mLn5w32tdXe6RszXJegzIFo5vius1RFJhkgg5i7ZmQ0N4+mxfFc+vgM9Q44zAvVy8Rcg7x0OmjIhTtGqi2q4LsoTf9h+eMn+isdD66VrpdPorvp0cbf8nofsla418RtsMsECB9Blo0MVpSaNeVY2PWmfM2CMSNCtDcgHkQU0j49m9c3vXvjtKmgkAArLWTntCmUAK6nxijkyvCJk4q4JqbZPiouyQKcf+cCOpC/3nGTj9IZODw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by PH7PR11MB7099.namprd11.prod.outlook.com (2603:10b6:510:20e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Tue, 17 Jan
 2023 13:51:57 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3%3]) with mapi id 15.20.5986.023; Tue, 17 Jan 2023
 13:51:57 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH v2] vfio: Support VFIO_NOIOMMU with iommufd
Thread-Topic: [PATCH v2] vfio: Support VFIO_NOIOMMU with iommufd
Thread-Index: AQHZJS8kfO7o6BZcqkmxMznEHHL4Oa6iGfLAgACMWgCAAASz0A==
Date:   Tue, 17 Jan 2023 13:51:56 +0000
Message-ID: <DS0PR11MB75290F8DB8B7ED2414CD1B02C3C69@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <0-v2-568c93fef076+5a-iommufd_noiommu_jgg@nvidia.com>
 <DS0PR11MB75292238656F19908C0D0A4BC3C69@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y8ajvgYMgM+dKUWJ@nvidia.com>
In-Reply-To: <Y8ajvgYMgM+dKUWJ@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|PH7PR11MB7099:EE_
x-ms-office365-filtering-correlation-id: 6895a99d-d47b-44db-0664-08daf891ff81
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: p9k1qLXmO06zwCtFcDmMI2nRsNljT80BUk5ePVjYDcfCD3ZdT47ylBUFDh5ZelDMncHplwNN5oVxzJAxgE7M4WJbzWeSJXqsLbxqgHhZ7/mjxSGsi7NY+v6uMDlWF2YIMGtLSwItEp2kniMoTgN8K+SxLpMAEjsSsOjjS+co8/aPJcC48DXCAUYGmfUcZoiQN9yIG/TsduI66zi2mwz24Gh+r5ddD//VKmTaQkQTUE5fmYWXeqMJf6jZKzcL9zMFqQVeX7B1FtbspXwqEJdH0VwuRTjIHI+5Ad5JLS7olg4GmVZzEOqUO4xujkN4CXDwbkMizhL8Kj+Emb6nq8vHlTWm42y3H0eK/omVEOCiNpPIGzNwd5hdX16Vi2TIwZ4lTF4MV6ThKPJblc4cbuKxxa+Nrj+b9eMscxSWVowkFauPD4bRgTpTo48qj8TSENaQs/zc6eLxaexWaq/wJZZnV1caX2lyjcLy6BdnC0+ws5EY/NB/t84wthJKwajqiXOYN8ESIBjQAR4HOoIx8ryUUaGGmuoukEn9Y3+dK87uLbnU5DG5P6rJWIJj89uPH+EXb9sdchb2qriV+Cf+v62NfaGHLbyurUZipkJh1/0/BnUcDK5FkStgjYxvWg8Ep8XLnyvQgeX2Jyizz90F4Xq1BuiL68zQCtbKr+NujCM1r4WGNF7eRgDBBVqqO8ao78oLmH3BoMkGISzFrckVgnJCCQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(376002)(396003)(366004)(136003)(346002)(451199015)(33656002)(66476007)(66446008)(66946007)(66556008)(41300700001)(9686003)(8676002)(26005)(186003)(6916009)(64756008)(4326008)(86362001)(76116006)(5660300002)(83380400001)(82960400001)(52536014)(8936002)(54906003)(478600001)(71200400001)(7696005)(38100700002)(38070700005)(316002)(55016003)(6506007)(2906002)(4744005)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dUFPTjJXUjNzdFpXVExIRXlLZ1hnanVZMkNuRmpMM3RiNkt6Zkg3QUFYdjB0?=
 =?utf-8?B?RFBrTWkvWkdZY01lUjRaenNzYnJUNGdOUmRVNkNraHh3RllPeG13Tm1neTJF?=
 =?utf-8?B?dlY4QnR1VEhPbVoxWUFoTzA5SlNjMnJBOCtSbytCLy9QN1p2UWpwM3JsMWUy?=
 =?utf-8?B?V0xhRmxhQTlaYyswa0t3V2t4NGoyYjYycEVVUkNtQWpkbitDc3RnM0lRb0pJ?=
 =?utf-8?B?RWpzNHpUT0xkbXZGTURkWmRzZWhqMUdwVGtIZjMwVGo2cncrWTdMV1hScVhw?=
 =?utf-8?B?MXdCVXlKSnV0Z2pnU1pHUEk5bU9wVjcrbkR5bjc1TUdUSUxOTmhIR3NtOG5r?=
 =?utf-8?B?dTdOQjB0a0ZDVEpvZ2Y3eEJpT0tielh6RFovejN2NGZEemx0Tm1XbkRybmJ4?=
 =?utf-8?B?UWM3ZUYyVU1kb2xPY3BrVkd5bjhsOEpPR0RUWnBLZm1WUUI0cy83RDVGVUlS?=
 =?utf-8?B?UzBCZFJmaFFkckRYVWhMS2hHMGZETzZuV1orT2dYZDJ4c2dxc3hPR29ZZHli?=
 =?utf-8?B?Z3FHd0ZmdVFjaTIzVUVvRmZLV1UzVUJkTnpzWXZTdEZUU2ZKd2pxZ0s0TEFL?=
 =?utf-8?B?K3oraDRKWjIxbktJNmUzWVNoY1B0SWd2UElDZmc5YjNYK3BqckZGelNkdk5l?=
 =?utf-8?B?V3BsMDhYQXVObkZqY0tyNUpUY3MvUng4YVFXNG5ad2U1WCtJZ3VwbUNBT2F6?=
 =?utf-8?B?WWlRc3FUSUlrcWZuRXAvVjVOTlNYcXU0dTI2NENZVHNiNW1udGloTVdwSHJU?=
 =?utf-8?B?ZEJNbWNJMm1VRnJmWktDN1JtTGhNa0kydzN2T3MwRWprdkZNUlRqKzF3RGxo?=
 =?utf-8?B?NGxudWJDUXdnd2NHV3dCSUw1ZUpITnl0K0Nld3VvZUZjL3JSQWFYeUxJN2RZ?=
 =?utf-8?B?VzlrRlFoSFlPenZ4dFdNODZQcmx5bFlrRzM2aHdzdTdaNlF4SCtwdGVDazlZ?=
 =?utf-8?B?b2ZsRVM0RDJ0Y1dCNnpaZDFpQUJmM0dyVi96UEJ4WkVJck1mM1Q4azNza3Jv?=
 =?utf-8?B?WVRmQS91YzBRNUhONFZ1WXZUMWM2NEh2RUd2cTg3c2NWUlo3WTFFMFArVWlj?=
 =?utf-8?B?UTZQa0VJQWFmNHI3M0dPMmFRRHdvMEZvcnNqNnZBSXFCQS9ZSVBCNG9CeE5y?=
 =?utf-8?B?ZTFucEdwQ1dkNk5EY0VlKzR4cDBDcDNrNEc4QXlONFhObTNRMWNTZGpld0l5?=
 =?utf-8?B?UEhrK3MzVER5TkFvK2krTWx1WXZIb2RCMXMxdDdpL1BVOTZyakxnMWtnc1RS?=
 =?utf-8?B?ZlNJUDQwVW54QnQ3Nk9vTm1SQk9zalk5S1NYMmZOcGJ6YlVCYnN3Z3I5OFpD?=
 =?utf-8?B?ek5Uald5ZW9XN1l5R1BlRlNBVjVxdy95OFdEZWpTTmxheUxtY1pzU1ZKRW1s?=
 =?utf-8?B?c29aNjlXbEE1Qis4K3QwRVZ4KzlsOGQraW9jMkhhZ3JXb2p1ZVhpK3lEQmx2?=
 =?utf-8?B?YXNUN0hNZXNwNDcxZE9KT3VlZDdWU2tqcHhCN0JGdmttekNtVjB2ZmMzS3Fm?=
 =?utf-8?B?RTMxT2tCSXRqR29uVmd6Q3RmUzRoeTBnNFlNZHRPV0hndVRrQ3NTdlBrcmVn?=
 =?utf-8?B?UlhPNUdTZDRmWEhKOTZKL2lSVHpNdkczOGRQdFRUK0lEeXJWL054VmE2WEFU?=
 =?utf-8?B?LzlhdFYzN0R0bFZ4RW1SRzVQRHFSeWk3VUtGanVydlJmMXN2SDJvenJoaDVS?=
 =?utf-8?B?ZUZqc0F1amdPUEtJOC81TzJYTC9MTnFSdUFuUHdtN2daaWtQRnRpN0RqbHAx?=
 =?utf-8?B?MHZGbjc4SzdkRGNobFVZSnZHN21Ob25OaTAxekM4VUFqZVdhRHZZWGIwYzNJ?=
 =?utf-8?B?MzY0RkJaeDEwUEZ4cWthZENvdHFtK3VrZzRCUXQ2WXgyam50QUhBM1FNbUNY?=
 =?utf-8?B?WGt5UmJGaXRFVS93bENzRGVxdVFSTTAxVll6RUlPcnRha3dJcFJDZitFVzFZ?=
 =?utf-8?B?UlNnTEtTTkdOdE9JUWhjRFBZVWlyQ3R6N3dBeVZGTUZPamVUbkJNbFFmdXBy?=
 =?utf-8?B?cHlTRGI3bWM3UW9rbjVJcFdVdXFzVUNoYk45V203bklzb1pxcjJlRi9GcWln?=
 =?utf-8?B?TS9PTzY3aVJsTWVVM2kwWTRKWGhhOGRDaTUvVHVxSlBUdllpbkdaT2NPNHZp?=
 =?utf-8?Q?H205bPaakLvdRt1apNhoIv+Z7?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6895a99d-d47b-44db-0664-08daf891ff81
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jan 2023 13:51:56.6496
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nsjFbsxO8Ix0aAZY9i3MrI39xh2F8NSNcqJTRgdI09D6eNAPwPHJuRK4m3q8c2uV2Y5NSJLBDKGMJtxAzUv8uw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7099
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

PiBGcm9tOiBKYXNvbiBHdW50aG9ycGUgPGpnZ0BudmlkaWEuY29tPg0KPiBTZW50OiBUdWVzZGF5
LCBKYW51YXJ5IDE3LCAyMDIzIDk6MzQgUE0NCj4gDQo+IE9uIFR1ZSwgSmFuIDE3LCAyMDIzIGF0
IDA1OjE0OjEyQU0gKzAwMDAsIExpdSwgWWkgTCB3cm90ZToNCj4gPiBIaSBKYXNvbiwNCj4gPg0K
PiA+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdmZpby9pb21tdWZkLmMgYi9kcml2ZXJzL3ZmaW8v
aW9tbXVmZC5jDQo+ID4gPiBpbmRleCA0ZjgyYTZmYTdjNmM3Zi4uNzlhNzgxYTRlNzRjMDkgMTAw
NjQ0DQo+ID4gPiAtLS0gYS9kcml2ZXJzL3ZmaW8vaW9tbXVmZC5jDQo+ID4gPiArKysgYi9kcml2
ZXJzL3ZmaW8vaW9tbXVmZC5jDQo+ID4gPiBAQCAtMTgsNiArMTgsMjEgQEAgaW50IHZmaW9faW9t
bXVmZF9iaW5kKHN0cnVjdCB2ZmlvX2RldmljZSAqdmRldiwNCj4gPiA+IHN0cnVjdCBpb21tdWZk
X2N0eCAqaWN0eCkNCj4gPiA+DQo+ID4gPiAgCWxvY2tkZXBfYXNzZXJ0X2hlbGQoJnZkZXYtPmRl
dl9zZXQtPmxvY2spOw0KPiA+ID4NCj4gPiA+ICsJaWYgKElTX0VOQUJMRUQoQ09ORklHX1ZGSU9f
Tk9JT01NVSkgJiYNCj4gPiA+ICsJICAgIHZkZXYtPmdyb3VwLT50eXBlID09IFZGSU9fTk9fSU9N
TVUpIHsNCj4gPg0KPiA+IFRoaXMgc2hvdWxkIGJlIGRvbmUgd2l0aCBhIGhlbHBlciBwcm92aWRl
ZCBieSBncm91cC5jIGFzIGl0IHRyaWVzDQo+ID4gdG8gZGVjb2RlIHRoZSBncm91cCBmaWVsZHMu
IElzIGl0Pw0KPiANCj4gSXQgd2lsbCBtYWtlIHlvdXIgY2RldiBzZXJpZXMgZWFzaWVyDQoNClll
cCDwn5iKIEkndmUganVzdCBzZW50IG91dCBhIG5ldyBjZGV2IHZlcnNpb24uIE5vdCBiYXNlZCBv
biB0aGlzDQpwYXRjaCB5ZXQuIFdvdWxkIGdldCBpdCBiZSB3aGVuIHRoaXMgcGF0Y2ggZ290IG1l
cmdlZC4NCg0KUmVnYXJkcywNCllpIExpdQ0K
