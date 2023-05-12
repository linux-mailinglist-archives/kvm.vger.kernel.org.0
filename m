Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 817E37005B6
	for <lists+kvm@lfdr.de>; Fri, 12 May 2023 12:37:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240767AbjELKg6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 May 2023 06:36:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240690AbjELKgr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 May 2023 06:36:47 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 474021FC1;
        Fri, 12 May 2023 03:36:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683887779; x=1715423779;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=IsDTmGu5iDfoyt5T79H4DL/fSqWr05Edqoo6gfQ1BIE=;
  b=RyOpp369DI3pgVL1GlP1Gd0zOJxNsxADvk4oT3Y9c4PxTKS5r763+ahX
   T3zxuMtPWecfnfqQNZonyOwNAtGZy1SDJ1dLj40I0M3tSSlqYK+naLpMd
   VayfgARnT5dkj8RJ/urX27dxHlPPFtwPtdrHrQIFzeZVmlSZsifd38qLy
   ltimC01EXTOa2DB9jVRgP2TG+hro+G3AtqluMonQzMmA8t5tcyUgP+7M1
   /8IXRmLCjTUpZPS/j0XGJZXC08HTDD9wBfBnnC8tWugheU/pwcZSNgch6
   1zZtoxWE3AJ3wJIZPSQSaQnin3eghqLzOpvKNTWpWqYWPiT9343uASIXR
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10707"; a="353008001"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="353008001"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2023 03:35:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10707"; a="650594709"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="650594709"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga003.jf.intel.com with ESMTP; 12 May 2023 03:35:18 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 12 May 2023 03:35:18 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 12 May 2023 03:35:17 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 12 May 2023 03:35:17 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.45) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 12 May 2023 03:35:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VbG2HaW4AK9igTMnh8/iKgT8xwj/6jLqZqkuSL8XCoZnylz0JRmYLvyA2Yw6t2M04e9+l9X+QVGpofJ5pynF8wlgf0Ry81Y1fpD4tdWXGTuLTv9PALQxUpeV5XwfXvJUG01SmXfU2VJurMn2U6KfF4q7ItM7cakAWmrk7Av8KZEz49MBV2opohLDD8LfEhwBnLNRW5MDN2xIUtvNNVeVbSsXU4y/Ue/psXNOSpBG+B8IiiZ6gBDFlsn277Z6i2jmGKuxa5ewosPu1jk5L0VhKnd86wZmPyiAzZhf9zuyNzScSaeqJ7xIsmhtlaMgteHuqZSjlplF9tJpVcfYIBFA4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IsDTmGu5iDfoyt5T79H4DL/fSqWr05Edqoo6gfQ1BIE=;
 b=kVBkml2dybQA0C+VNYtcBb1Ighky4QbGXaM7lOvnkwKtEWUjf+ruZC26uHTCytUbdeIRUlVD+xgYizw9haJ5AfJhUjWWozU6W9coJDSUaITU2cVwAOKKw1ix3nEUdzNWGZP3cdW7Y0NaPKXLOW7FWPBpbRwKt7DtFCyEsrcJwgAjVlOTsTqhTlbE2kyR0Et18gqsfVTpO5rRr1DcqS347BUo5GXFLmoIsJA0KYKAlwXex7nkCqCzpUCYBRwb5lB0LbeLYA4MM7tzk6EfNkizyFQaROx7HM3+Yjyu3YBpfyqPWXT4WAAA6/OxE6AippeMGAjVJ8rhG5rwoaC4hSN5ZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CY5PR11MB6464.namprd11.prod.outlook.com (2603:10b6:930:30::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.18; Fri, 12 May
 2023 10:35:10 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3a8a:7ef7:fbaa:19e2]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3a8a:7ef7:fbaa:19e2%5]) with mapi id 15.20.6387.023; Fri, 12 May 2023
 10:35:10 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "guoke@uniontech.com" <guoke@uniontech.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "haiwenyao@uniontech.com" <haiwenyao@uniontech.com>
Subject: Re: [PATCH v2 5/8] KVM: x86: Use MTRR macros to define possible MTRR
 MSR ranges
Thread-Topic: [PATCH v2 5/8] KVM: x86: Use MTRR macros to define possible MTRR
 MSR ranges
Thread-Index: AQHZhGEcNSDg8JA/dkmFf9j26efTAK9WchSA
Date:   Fri, 12 May 2023 10:35:09 +0000
Message-ID: <ecbcfb6ca243cf587eb6e61c6e852b4f474a36d7.camel@intel.com>
References: <20230511233351.635053-1-seanjc@google.com>
         <20230511233351.635053-6-seanjc@google.com>
In-Reply-To: <20230511233351.635053-6-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.1 (3.48.1-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CY5PR11MB6464:EE_
x-ms-office365-filtering-correlation-id: 3093589a-457c-404f-56b5-08db52d48f98
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8v7iKHtFj5izzxBFo1JBFQKCRhDb0uPm/NrUGZgnxusrI6LzxDv/VoTeR1SwiSpj/nRhz/PyMw9pzCqI+fwYcBkb4uSp1Dv9l3OK73p8WfdWQjOXGWUz6SmIQvavSOwyt1E0feH60i7K2AIR2e5KNW/xa468pMAsU4aYAYpCj4a/hSRSLd29D1/FPGsGByIY8JxERHxVBUQIw1H1Fq33NQ2tb/PmmRiC+2/zh3arHmylt67xexGp72B90iClYrqEqQ05MXB7qGjLPZcRO3TrbS/F0efWAAWFcYD4FCl8ioHLMG3pabqKUGGxICf+PveMWDoNgmwWLc8TdFGkLC0LLeyUpav2Zc/I0g/mVTOoUUg7UaQEwvqloNyJw9zM29C4IzXNIsLMufnVK462v/RdW3VGhdVgzhsJdyd4ObBSeNEbsBHqXgQU/Ca6JrZZn3X1Fmm4+Edu2+QY24WcX4FwAcuwvrIluIC5xeJa44T7nlcDZKbo2gqIedtmHcDQtfRY2adGy9V3tseNbhGcT/HsIOBthnC4QCC/XoqhmiW+m5HRCeiqAxLhjpW5w6ahr+mkr7+E+SDnr4kpkYnSsIyNc1kmqFtjJmZ32IOv7iub3WQtGZrVlP7FRY98NvUTNK8R
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(376002)(39860400002)(396003)(366004)(346002)(451199021)(54906003)(110136005)(38070700005)(316002)(83380400001)(122000001)(82960400001)(26005)(6506007)(6512007)(41300700001)(86362001)(4326008)(66476007)(8676002)(8936002)(76116006)(66446008)(64756008)(66946007)(66556008)(38100700002)(5660300002)(91956017)(478600001)(186003)(36756003)(2906002)(2616005)(6486002)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RFF2VVZoTVQ2UHA2cjhFRmV1ejdxWjNqa08yemtRdks3ampRS2U4SGNzNUNH?=
 =?utf-8?B?UFFaRFZSc1pBNTdFNXZLZWpSclZqZmRvOFlrVUtvRzJ3Q3VTLzZaZ05hMkpq?=
 =?utf-8?B?WFhFN2NZWDlsM0l1VnhiNDZHWmtOekVFZWUzT094L0NiYjRhbFk0bEVXQzl5?=
 =?utf-8?B?Mk9raGZyRk1GWjZhQUQ0eVY1YlhFa3dDTzhyM2JGL1VoYUVkdGVzei81M1B2?=
 =?utf-8?B?dzlzZGRDNTNrSmVWM2VCYUtPaU1kZzFpRnAyR1NwRm0wa0g2QnI5VC9SSklq?=
 =?utf-8?B?blRVNFhOZVBvSjRjY3RJUEFlNUtHenpGRTBnN296ZEFPakRycEZVUWxxWkRL?=
 =?utf-8?B?TDg4U1JjYWlUZkU1Ny8zbWhXQ1o2TURIKzVhNTN6N21pNEVLcHNZejhlUVlq?=
 =?utf-8?B?SVBIR3lkK1o2TEpVLzlISDhtbkkzeGdXRm9zRFQxeHRDc00zalluUGUxMTBx?=
 =?utf-8?B?Ukt0R2pqQWEyMVR5dmRVWjYrYVlpTUVhc01ZbVRsUHgwcXQwQ3htWTVXY0ty?=
 =?utf-8?B?emZvMzUra3pGV0gzelA3dGEzS1dNeGo0M1RPazd0UEJJbXB4eFpqMnllZjZ1?=
 =?utf-8?B?ZzlKNGNPSTI2elRIYTBtZWkwRnFJZE9jU0sybVFydVlSOVhjTW5BamN4RTEr?=
 =?utf-8?B?YklvOEthUzB4UW9sWDFMbkhzMExWVkVlQlpHc2Z0RitOc0kzUU1NZ2hTSUtP?=
 =?utf-8?B?MXBjeDMyMjByM24wV1NQMWNvNEtLaGo2YTlXTHV3VllzRHc3K1drSzI1WWpl?=
 =?utf-8?B?QzNNNVdEc3EzQi9iMGVNQkx5dEdhYmlQb0pDelhmMjVORW9rWk1XY2tGZFBM?=
 =?utf-8?B?cnV3RStlWVg2VWJidWtMWVo3cytTMkdnTWtYT1l4czhKUlJJTmdqRnlCYlFt?=
 =?utf-8?B?eHpqSFNuZXIvZ0xxeXRlaW9ydE1QMXIzZVZnL2lWZkFXRmg3WGRza0tuY0pX?=
 =?utf-8?B?b1l0SEt0WW45bTV3RTFZdk8zRWtzeHhOeDgvSWN4NHk3dWtBZEUvM01qcSt6?=
 =?utf-8?B?aEZVby8zck51bEE2QW1vYmtYWGpmRVk2RzVSUW4rTkdsSGR4ck9TZWhkZHhv?=
 =?utf-8?B?MG5xaThNYmZJSlBsZmNQVmxYbm42ejU4SVBDM1Y3VTkvNERTUGJ4SkkxU0Fk?=
 =?utf-8?B?aWtHcTRQYkRTaHlPcTNxMDVlME4zSVc5dHZCTE9oNGg5dThKY2lqV3BKRXRS?=
 =?utf-8?B?Z0lTZUdFbCtVM0pvbHg4UEJGbUVDcndVcUVCY1NCQ1VLZHBCZFRzVXh4VFc3?=
 =?utf-8?B?UWt0S1BCTmRyU25XbGdkR1V1UzRtWjI5dWV0ZUFINHovTGg4dkQyWjdzZ0xu?=
 =?utf-8?B?ZTNsejQ4VHFwZUY5VisyRnFWRm5VWkFEZjhGTitoWWFTbndWakovK2NwNktJ?=
 =?utf-8?B?KzNGd1N0RjhxaGlVSWN2M21RVjJvVTFYTlh3VUdxVUJSYmxuT0ZhbkRrVkhF?=
 =?utf-8?B?N0xkUVNBR1BjVmhsczl3NnlWNmNFNUZtZGpyeDZJVDlPNXkrbU0vZEdXUWtq?=
 =?utf-8?B?am9tZmJ0Q3RGaFM1N0JFWnE3K0pacTljN09WY3BURDIrNzJQNWVBTlJKeEh6?=
 =?utf-8?B?T1BNWkUvUmQzZ1MraTRxYjBXYStJOUE0cDM5SjZmNE5VYlZjdHpmWUJIWHpq?=
 =?utf-8?B?SFlDNXh6UG5PNFZmdVZYRXJKWDZUQXE2RkJ5QW9mRHl6UVphaTVRTE8yalNX?=
 =?utf-8?B?VlpuQkNtRXpoTDhxTFh5Ty9BYmpZckpNMEhDckJiZE54aGNSQzIxblNUdHVF?=
 =?utf-8?B?S2xSSDBid1c4VTdSVU5SZDFPb3V2cWF5ZWN6UHlDZzdRLzFkQ285UUIyMi92?=
 =?utf-8?B?MkFGMDFSOUo5VVZlUk5JYWFuY1JJM0JWVTErb1o1amsvQWZIY2p5VkVOR05Z?=
 =?utf-8?B?RmJnZVd1TmZKMCtGZ3I0YmRqM2p0VjRUalJwNFkwU2N3NVlLczN4aWJJZ1FP?=
 =?utf-8?B?dC9mUktQcngvVkkzMmt0OGw3UkF3dGVGUDNtQnJheitZMXl6dVBseDU5aWV6?=
 =?utf-8?B?bmVOSUVBNWlucStzL3JWQVFja25PMlB6emo3UTRUTFhicmxNcTBEdVM4cjBL?=
 =?utf-8?B?NFQ2aWFVZndjQkI0dVpqbFRsZDU4QXozZythbXVmdkdhdHBaai9RYTd5WlJy?=
 =?utf-8?Q?aRY2ViW8MPTiR3jyfYHp9PVKH?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A3B200F44E048C49AD8673F402FE75D2@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3093589a-457c-404f-56b5-08db52d48f98
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 May 2023 10:35:09.8650
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VOS1zhLpEy/lZG5RbCXa1JTndRdnhq8SvCKmGrG3V2wUUTKaOSk4OVqacLzsGvYJtt3/EmoS9ojJltj30RjH0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6464
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIzLTA1LTExIGF0IDE2OjMzIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBVc2UgdGhlIE1UUlIgbWFjcm9zIHRvIGlkZW50aWZ5IHRoZSByYW5nZXMgb2YgcG9z
c2libGUgTVRSUiBNU1JzIGluc3RlYWQNCj4gb2YgYm91bmRpbmcgdGhlIHJhbmdlcyB3aXRoIGEg
bWlzbWFzaCBvZiBvcGVuIGNvZGVkIHZhbHVlcyBhbmQgdW5yZWxhdGVkDQoJCQkJXg0KCQkJCW1p
c2htYXNoPw0KDQo+IE1TUiBpbmRpY2VzLiAgQ2FydmluZyBvdXQgdGhlIGdhcCBmb3IgdGhlIG1h
Y2hpbmUgY2hlY2sgTVNScyBpbiBwYXJ0aWN1bGFyDQo+IGlzIGNvbmZ1c2luZywgYXMgaXQncyBl
YXN5IHRvIGluY29ycmVjdGx5IHRoaW5rIHRoZSBjYXNlIHN0YXRlbWVudCBoYW5kbGVzDQo+IE1D
RSBNU1JzIGluc3RlYWQgb2Ygc2tpcHBpbmcgdGhlbS4NCj4gDQo+IERyb3AgdGhlIHJhbmdlLWJh
c2VkIGZ1bm5lbGluZyBvZiBNU1JzIGJldHdlZW4gdGhlIGVuZCBvZiB0aGUgTUNFIE1TUnMNCj4g
YW5kIE1UUlJfREVGX1RZUEUsIGkuZS4gMHgyQTAtMHgyRkYsIGFuZCBpbnN0ZWFkIGhhbmRsZSBN
VFRSX0RFRl9UWVBFIGFzDQo+IHRoZSBvbmUtb2ZmIGNhc2UgdGhhdCBpdCBpcy4NCj4gDQo+IEV4
dHJhY3QgUEFUICgweDI3NykgYXMgd2VsbCBpbiBhbnRpY2lwYXRpb24gb2YgZHJvcHBpbmcgUEFU
ICJoYW5kbGluZyINCj4gZnJvbSB0aGUgTVRSUiBjb2RlLg0KPiANCj4gS2VlcCB0aGUgcmFuZ2Ut
YmFzZWQgaGFuZGxpbmcgZm9yIHRoZSB2YXJpYWJsZStmaXhlZCBNVFJScyBldmVuIHRob3VnaA0K
PiBjYXB0dXJpbmcgdW5rbm93biBNU1JzIDB4MjE0LTB4MjRGIGlzIGFyZ3VhYmx5ICJ3cm9uZyIu
ICBUaGVyZSBpcyBhIGdhcCBpbg0KPiB0aGUgZml4ZWQgTVRSUnMsIDB4MjYwLTB4MjY3LCBpLmUu
IHRoZSBNVFJSIGNvZGUgbmVlZHMgdG8gZmlsdGVyIG91dA0KPiB1bmtub3duIE1TUnMgYW55d2F5
cywgYW5kIHVzaW5nIGEgc2luZ2xlIHJhbmdlIGdlbmVyYXRlcyBtYXJnaW5hbGx5IGJldHRlcg0K
PiBjb2RlIGZvciB0aGUgYmlnIHN3aXRjaCBzdGF0ZW1lbnQuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5
OiBTZWFuIENocmlzdG9waGVyc29uIDxzZWFuamNAZ29vZ2xlLmNvbT4NCg0KUmV2aWV3ZWQtYnk6
IEthaSBIdWFuZyA8a2FpLmh1YW5nQGludGVsLmNvbT4NCg0KT25lIE5pdCBiZWxvdyAuLi4NCg0K
PiAtLS0NCj4gIGFyY2gveDg2L2t2bS9tdHJyLmMgfCAgNyArKysrLS0tDQo+ICBhcmNoL3g4Ni9r
dm0veDg2LmMgIHwgMTAgKysrKysrLS0tLQ0KPiAgMiBmaWxlcyBjaGFuZ2VkLCAxMCBpbnNlcnRp
b25zKCspLCA3IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS9t
dHJyLmMgYi9hcmNoL3g4Ni9rdm0vbXRyci5jDQo+IGluZGV4IDU5ODUxZGJlYmZlYS4uZGMyMTNi
OTQwMTQxIDEwMDY0NA0KPiAtLS0gYS9hcmNoL3g4Ni9rdm0vbXRyci5jDQo+ICsrKyBiL2FyY2gv
eDg2L2t2bS9tdHJyLmMNCj4gQEAgLTM0LDcgKzM0LDcgQEAgc3RhdGljIGJvb2wgaXNfbXRycl9i
YXNlX21zcih1bnNpZ25lZCBpbnQgbXNyKQ0KPiAgc3RhdGljIHN0cnVjdCBrdm1fbXRycl9yYW5n
ZSAqdmFyX210cnJfbXNyX3RvX3JhbmdlKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwNCj4gIAkJCQkJ
CSAgICB1bnNpZ25lZCBpbnQgbXNyKQ0KPiAgew0KPiAtCWludCBpbmRleCA9IChtc3IgLSAweDIw
MCkgLyAyOw0KPiArCWludCBpbmRleCA9IChtc3IgLSBNVFJScGh5c0Jhc2VfTVNSKDApKSAvIDI7
DQo+ICANCj4gIAlyZXR1cm4gJnZjcHUtPmFyY2gubXRycl9zdGF0ZS52YXJfcmFuZ2VzW2luZGV4
XTsNCj4gIH0NCj4gQEAgLTQyLDcgKzQyLDcgQEAgc3RhdGljIHN0cnVjdCBrdm1fbXRycl9yYW5n
ZSAqdmFyX210cnJfbXNyX3RvX3JhbmdlKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwNCj4gIHN0YXRp
YyBib29sIG1zcl9tdHJyX3ZhbGlkKHVuc2lnbmVkIG1zcikNCj4gIHsNCj4gIAlzd2l0Y2ggKG1z
cikgew0KPiAtCWNhc2UgMHgyMDAgLi4uIDB4MjAwICsgMiAqIEtWTV9OUl9WQVJfTVRSUiAtIDE6
DQo+ICsJY2FzZSBNVFJScGh5c0Jhc2VfTVNSKDApIC4uLiBNVFJScGh5c01hc2tfTVNSKEtWTV9O
Ul9WQVJfTVRSUiAtIDEpOg0KPiAgCWNhc2UgTVNSX01UUlJmaXg2NEtfMDAwMDA6DQo+ICAJY2Fz
ZSBNU1JfTVRSUmZpeDE2S184MDAwMDoNCj4gIAljYXNlIE1TUl9NVFJSZml4MTZLX0EwMDAwOg0K
PiBAQCAtODgsNyArODgsOCBAQCBib29sIGt2bV9tdHJyX3ZhbGlkKHN0cnVjdCBrdm1fdmNwdSAq
dmNwdSwgdTMyIG1zciwgdTY0IGRhdGEpDQo+ICAJfQ0KPiAgDQo+ICAJLyogdmFyaWFibGUgTVRS
UnMgKi8NCj4gLQlXQVJOX09OKCEobXNyID49IDB4MjAwICYmIG1zciA8IDB4MjAwICsgMiAqIEtW
TV9OUl9WQVJfTVRSUikpOw0KPiArCVdBUk5fT04oIShtc3IgPj0gTVRSUnBoeXNCYXNlX01TUigw
KSAmJg0KPiArCQkgIG1zciA8PSBNVFJScGh5c01hc2tfTVNSKEtWTV9OUl9WQVJfTVRSUiAtIDEp
KSk7DQo+ICANCj4gIAltYXNrID0ga3ZtX3ZjcHVfcmVzZXJ2ZWRfZ3BhX2JpdHNfcmF3KHZjcHUp
Ow0KPiAgCWlmICgobXNyICYgMSkgPT0gMCkgew0KPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3Zt
L3g4Ni5jIGIvYXJjaC94ODYva3ZtL3g4Ni5jDQo+IGluZGV4IGU3Zjc4ZmU3OWIzMi4uOGIzNTZj
OWQ4YTgxIDEwMDY0NA0KPiAtLS0gYS9hcmNoL3g4Ni9rdm0veDg2LmMNCj4gKysrIGIvYXJjaC94
ODYva3ZtL3g4Ni5jDQo+IEBAIC0zNzAwLDggKzM3MDAsOSBAQCBpbnQga3ZtX3NldF9tc3JfY29t
bW9uKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgc3RydWN0IG1zcl9kYXRhICptc3JfaW5mbykNCj4g
IAkJCXJldHVybiAxOw0KPiAgCQl9DQo+ICAJCWJyZWFrOw0KPiAtCWNhc2UgMHgyMDAgLi4uIE1T
Ul9JQTMyX01DMF9DVEwyIC0gMToNCj4gLQljYXNlIE1TUl9JQTMyX01DeF9DVEwyKEtWTV9NQVhf
TUNFX0JBTktTKSAuLi4gMHgyZmY6DQo+ICsJY2FzZSBNU1JfSUEzMl9DUl9QQVQ6DQo+ICsJY2Fz
ZSBNVFJScGh5c0Jhc2VfTVNSKDApIC4uLiBNU1JfTVRSUmZpeDRLX0Y4MDAwOg0KPiArCWNhc2Ug
TVNSX01UUlJkZWZUeXBlOg0KPiAgCQlyZXR1cm4ga3ZtX210cnJfc2V0X21zcih2Y3B1LCBtc3Is
IGRhdGEpOw0KPiAgCWNhc2UgTVNSX0lBMzJfQVBJQ0JBU0U6DQo+ICAJCXJldHVybiBrdm1fc2V0
X2FwaWNfYmFzZSh2Y3B1LCBtc3JfaW5mbyk7DQo+IEBAIC00MTA4LDkgKzQxMDksMTAgQEAgaW50
IGt2bV9nZXRfbXNyX2NvbW1vbihzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIHN0cnVjdCBtc3JfZGF0
YSAqbXNyX2luZm8pDQo+ICAJCW1zcl9pbmZvLT5kYXRhID0ga3ZtX3NjYWxlX3RzYyhyZHRzYygp
LCByYXRpbykgKyBvZmZzZXQ7DQo+ICAJCWJyZWFrOw0KPiAgCX0NCj4gKwljYXNlIE1TUl9JQTMy
X0NSX1BBVDoNCj4gIAljYXNlIE1TUl9NVFJSY2FwOg0KDQouLi4gU2hvdWxkIHdlIHB1dCBNU1Jf
SUEzMl9DUl9QQVQgYWZ0ZXIgTVNSX01UUlJjYXAgc28gaXQgY2FuIGJlIHN5bW1ldHJpYyB0bw0K
a3ZtX3NldF9tc3JfY29tbW9uKCk/DQoNCkxvb2tzIHRoZXJlJ3Mgbm8gcmVhc29uIHRvIHB1dCBp
dCBiZWZvcmUgTVNSX01UUlJjYXAuDQoNCj4gLQljYXNlIDB4MjAwIC4uLiBNU1JfSUEzMl9NQzBf
Q1RMMiAtIDE6DQo+IC0JY2FzZSBNU1JfSUEzMl9NQ3hfQ1RMMihLVk1fTUFYX01DRV9CQU5LUykg
Li4uIDB4MmZmOg0KPiArCWNhc2UgTVRSUnBoeXNCYXNlX01TUigwKSAuLi4gTVNSX01UUlJmaXg0
S19GODAwMDoNCj4gKwljYXNlIE1TUl9NVFJSZGVmVHlwZToNCj4gIAkJcmV0dXJuIGt2bV9tdHJy
X2dldF9tc3IodmNwdSwgbXNyX2luZm8tPmluZGV4LCAmbXNyX2luZm8tPmRhdGEpOw0KPiAgCWNh
c2UgMHhjZDogLyogZnNiIGZyZXF1ZW5jeSAqLw0KPiAgCQltc3JfaW5mby0+ZGF0YSA9IDM7DQo+
IC0tIA0KPiAyLjQwLjEuNjA2LmdhNGIxYjEyOGQ2LWdvb2cNCj4gDQoNCg==
