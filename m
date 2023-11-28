Return-Path: <kvm+bounces-2644-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B7967FBE14
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 16:25:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D1C03B21A95
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 15:25:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9956C5D4BC;
	Tue, 28 Nov 2023 15:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ls/g0JqN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3FE6D64;
	Tue, 28 Nov 2023 07:25:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701185114; x=1732721114;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=/1AimdV+hkJdCiARKmQXv4QVvB17/+Tf6iObYnm7LAQ=;
  b=ls/g0JqNyPpq3a1jfeGgd7GP0gG0bGVQkgz7b99IcnyvharbWWBL0SkO
   w1SKGNySM4XpxTfhVavI3OAPXQri352OqsW/eoWjI2cLoOv77xWoGK/yl
   S1Il2ssbRLwyVlFohRbo/2mJlDfrdDaJjBR5axWIhYTlmJ4yb5ZT/P2cK
   a1TBt6bWa6wp6r4oigONfoEbVjj1mHv1Z9chY224U6AOW0rWggm4MRJx7
   rJO+FcSxPINXuOfZL2tLhe6RCnEQUmwuiXA9tOaSrp8kHt4e7A2oeG1WW
   6Kmxa+6PLymr+zFJc+otKpAd39BL6TbERO+VGdb3CD3pEFKr8BoOOPlGi
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10908"; a="6202794"
X-IronPort-AV: E=Sophos;i="6.04,234,1695711600"; 
   d="scan'208";a="6202794"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2023 07:25:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.04,234,1695711600"; 
   d="scan'208";a="9977907"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 Nov 2023 07:25:14 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Tue, 28 Nov 2023 07:25:13 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Tue, 28 Nov 2023 07:25:13 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Tue, 28 Nov 2023 07:25:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DdRzB2UL25/1e6BNN8s6lrWOJf8BegIx8NSBGkHj8GNhTDE3i2+l4AzLoISxkebWcek/Zy3LjrNumj9L0q8wchJQmWs7f0wvSEl1ejBokEEX/762ARIs/3baUh72uMnn456iSm28S+XHDSP5o1IJljICTtaqNxiIBmKZRbvdfZPEgvsFY84t8/dMBgPs0RJBqNLtf9of6qQICvJMmTGRf3uqnWYHwr9iyRqYrWME296nLxOQGkS+I/sl0WCcLdcr9IInqzyK7mX7CF+WeiLu3bmWpt6PlxKVz7+XN+S/p1K63721VE32gmWNNwvnSrK6smDEwEwYnfrOhzYjs+tNhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/1AimdV+hkJdCiARKmQXv4QVvB17/+Tf6iObYnm7LAQ=;
 b=ER5CFpBYkEEMQIQ868BxbrKG5GxrC1sACMyv+IAReVe9xPqI4kj2hyLWLrX9DGitGkWS4YnzN15rj6T76HOuhJJKuT1U5uaxx4G3FRatAZMDcVuJA1Kgl+V85dE00BOdDmOGmzn1UoMZ2r6cShom7zNEVBIsj9YnAHOvw+l0FXbE2oXZLE01cRXyizzEk97uGK/QUFmNUKYdgw1n4fhGEk5tvGg3uoM9W0fbOll7i4BVTnqK8s6nqtnuyIETBn3cKWdPE1eOelBqOvg7kpKrNoinzcrwsvHUmJejxI9cXhypRrw0NHAq0vLnYUEEg5LfKKMWXwG3ZkACZox/DZ004A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DM8PR11MB5621.namprd11.prod.outlook.com (2603:10b6:8:38::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.29; Tue, 28 Nov
 2023 15:25:11 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::5260:13db:a6e:35e9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::5260:13db:a6e:35e9%6]) with mapi id 15.20.7025.022; Tue, 28 Nov 2023
 15:25:11 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Yang, Weijiang"
	<weijiang.yang@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Hansen, Dave" <dave.hansen@intel.com>
CC: "john.allen@amd.com" <john.allen@amd.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "Gao, Chao" <chao.gao@intel.com>,
	"mlevitsk@redhat.com" <mlevitsk@redhat.com>
Subject: Re: [PATCH v7 07/26] x86/fpu/xstate: Warn if kernel dynamic xfeatures
 detected in normal fpstate
Thread-Topic: [PATCH v7 07/26] x86/fpu/xstate: Warn if kernel dynamic
 xfeatures detected in normal fpstate
Thread-Index: AQHaHqwV64smhD5UW0KtQXFPI2Q8zrCP4M0A
Date: Tue, 28 Nov 2023 15:25:11 +0000
Message-ID: <8dafb9cb4cb7054ae2a0c1bd19062937148d668b.camel@intel.com>
References: <20231124055330.138870-1-weijiang.yang@intel.com>
	 <20231124055330.138870-8-weijiang.yang@intel.com>
In-Reply-To: <20231124055330.138870-8-weijiang.yang@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DM8PR11MB5621:EE_
x-ms-office365-filtering-correlation-id: 963f92f1-bcfd-4ad3-cba1-08dbf0263670
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ayZPd/m6CUsXHKG4Lk8xjZoadF2VO3GnFuV98nJrIqvKNVYq9gvN/qte2bcFM6v4VFT4s5QAKTuricog6PwD3jsJC6p5xK+RUOLPq34upn1rgFcoJUHhCSGmulq6kjL6YENbEzstOAm/za3V1UnKOt2hugigViBb45dOr5d1I0mdnbKHpuxqC72W9D7MybKwjY54D7pOL1xD5JF/AXF/2oOOo/p7tH1v4ckf/Iq/Eo+N15g8+SKgjbNtIEbxdv6kg1YI0RzDAVdCUbesa1BZifJ7HM4Z1oe4OvNQPiGt6kCYjuchi6MxfM2WAkTlkDCY0apnFIG+0IYBZUn1FJn1uURR4BBJcszbO2ZHBj5DoRCJBj6aBjJLJRJdcxijdqcZJnEyu6fBddFJAyRjRrU8UIh9qSz38orGRA1K61UkxVdBvSC4rmfcFfq4gg+o00GHtRGlvFguyU2U3X83WVf6L2cgQr3n2egiuyuHvfGATaJ3krRtrHwY8nmvAuqHs/xcMTWPs7eMB56f8E4uTPnn2Il7z4W/ujpK3NHpULnYGvePE9Mg2/GUFawQsQdmMjav1qmJtGHQn/Mr5sr6PF2I0Tc+xqTGwN6K/QNQB+ePQ/SFBr+KOqaf8zt9AmpfyJvt
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(366004)(396003)(346002)(376002)(39860400002)(230922051799003)(186009)(451199024)(1800799012)(64100799003)(6636002)(316002)(2616005)(6512007)(6506007)(86362001)(6486002)(76116006)(36756003)(26005)(110136005)(71200400001)(91956017)(478600001)(82960400001)(83380400001)(122000001)(38100700002)(66476007)(66556008)(66946007)(38070700009)(54906003)(64756008)(66446008)(5660300002)(2906002)(4744005)(4001150100001)(41300700001)(4326008)(8936002)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UVI1SHZoTzJuZmYzOUpCcFdvRjNyVGZuSFg4S1VLSlpIeFFvWWFVK0NrcUZL?=
 =?utf-8?B?VzBoaTE0eUduci8wRmtoaWE0QnJZc3FOb3JEd3lHVXVEdkVESGFwV0R0TGdI?=
 =?utf-8?B?N2VTbW9XL05RbUVPMnZyZlE0d3RmRjduNmF0aVBQejN3MDNNd1NnbUJ5Y0ND?=
 =?utf-8?B?aFIycG9xUmNNTlVJVm9pMHZIL0U5cHg3NDduN3BsTG9oeUFOVmZlWmowLzFI?=
 =?utf-8?B?VWYxaEtwVTZHTUVlNFhLcmw2a3VCUmFLWHcxUk5SU2ZucVoreHNiMnhmNTdi?=
 =?utf-8?B?WElLemppNzZVQ29yb1JZSGFvQ0llZmtDanVJWUhDZXRUQUszbmhkbFlXK2tK?=
 =?utf-8?B?RmgrSVhSMThrcUZtWEVHRVZjNHdHRjkrbnBXTk81Ykk1c3p5UjFINUV0OVFG?=
 =?utf-8?B?aVlUL3RpY0p5UmdOR1ZnU1UvYU9HcGFVaE13NkVMTUkvSWowaFBodmNmT3M5?=
 =?utf-8?B?SWZrendxMEFPVTdFUVBjazAvamkzcFhHY1pOUTdTVHRIYjdROWtsUDAxQzY4?=
 =?utf-8?B?UWtZcG40SEp5QWpaN2ZXOUw3eXZGR29wTUMrYTZCanErUWhicmVtR1g1NkYr?=
 =?utf-8?B?S21QOUVrUUovUlBzWTFmU05haUtIM2JRQ1JDWU9rNzhlU29ZRUhoU0dzMjhZ?=
 =?utf-8?B?N2szQlJRbXg2Ti8zMWxCM3dlMXRLZHY1RnRwR25ybnVsN2xmR1BlVldZOHV5?=
 =?utf-8?B?QnJFYVR5eVh2TUFISTZtMlRvVHJnay80Mlg4VWIrZ0hOQUhpc2c4TzBNT2J1?=
 =?utf-8?B?NE9GVStrb3ZNUWFoTmRkWmN3YUlzMjN3ZGV4UVJ2cGhlOEwrc2lKQ2wySU5S?=
 =?utf-8?B?TGwxVjVZa245RURNb1RhNHUrSkJiNDRWQ211OUU4a2ZLMEN5VGNrQ0hQNG1Y?=
 =?utf-8?B?RjZNTHYwNTZEZnlrWW1SZjVJaGJFRmwzQlJuc0NnWGM5R2lIZ002ZHdSVDR2?=
 =?utf-8?B?cGVUVmJsZk1NSTFxenhieEx2WHJoS0sxcmFMMVJBVjFvNnlLWmY3ZzM3cEY5?=
 =?utf-8?B?K2c4OEpmZmMySVF1eG4wcU44RXNYM09oREt4cXRrcUI4NWZDSnlQNU5iZzZQ?=
 =?utf-8?B?MHVwNjQxTVZSZGNCTm0wNVB4akpDQXNZNFhKVGI4V2VLanpmZnJ0S1ZkMklF?=
 =?utf-8?B?RXhLQ293WCtHcVBxbTZwYnNMbVpiZk5wL2lKVWF2eUdTWlU2dUwxOWZSVlZ6?=
 =?utf-8?B?RXBBODFMUUhMNDVuL3Z0ZzZXV05JMTliTmhhbURWWkM0M3J0YzUydnF5SkZp?=
 =?utf-8?B?UG1nalN1a295eU9PWG5aM2RFeW5heEtTVCtYblhiOXRrVzZIcE85aHFHTnNW?=
 =?utf-8?B?Q283OXp1QnBkVkkydkxEd29ETFRhUzhTcTZHaGxuVVJ4cjJ1Y3hINGhkR0sz?=
 =?utf-8?B?VEpxamI0czR2ODNuZlgxTEQ2cEVqZ3NmRUMzeEhiaWsyNVo0RWVTSi9pYXV1?=
 =?utf-8?B?eit2YndBSmpHTjJXODRZODkza2VmdFJWYm9YVmZqUGNsdGduLzJhNnZUQVZq?=
 =?utf-8?B?WG41ZytGWmZWckhHM05SSHdXZi9kaFQ0NUVoWkptUk9rS1ZYT1NrUHF0Q3FZ?=
 =?utf-8?B?Y1ZoUlkyZ3RXM2xCb1AyM3FiS2ZrMEg2Y2xOV2JGalVlSWptcnI5bVdmNXhQ?=
 =?utf-8?B?R05CYURUUlRiaEpSY0k2Lysxc2gyUmQzbURXT3hsZ3RFTHl0aVZ5NjVlNU14?=
 =?utf-8?B?R1h3aGpVZWR3WkkzbVlJL25OR1Jlait3bWoxZjdKNDh0NFY5TS95TWk5Mkox?=
 =?utf-8?B?SmU3V2x2dVRqUmRXRVAyVDBKeUVKTEpWdlFGNk1hbEtMSFVnMWdQVnp5Snlv?=
 =?utf-8?B?TmI0bWxmMGdsVjVRWjVkMzZtZzg5YW1ZTlVnSkxDQjRtUVRGenZtbW1NcFpr?=
 =?utf-8?B?WVZoSld5dnJaVXhXQ1ZURFZVMk5oaHhlK3pxMTRSWklIUlUzckNEeWV1VDR0?=
 =?utf-8?B?V2NuZzIyc1daNmxhQjRBRVZOcHJtdW93dUFnemRiRUc3Nm81SkV2eDhYYnZo?=
 =?utf-8?B?dFVPcEtqcFFJODlXdnJFcG9ucmpveXp3T1VVV3JPSFEwMW5DeFNFVkJWbGFS?=
 =?utf-8?B?b2Z1NnhlU3VaVGpyY3pHWEZRa3BrUU0rVVhEazZlaEJ3dFZ3cGFUNGY2NEdY?=
 =?utf-8?B?eHN0Z0lCbEVvK0pyRkJlWGk1eTNINWk4RHpKRFdra04rdk05d2JqQUMrd25M?=
 =?utf-8?Q?nmkcjtjuLb/TQ8IW3tq4b0s=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1016292DA0208048915F110CA5195081@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 963f92f1-bcfd-4ad3-cba1-08dbf0263670
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Nov 2023 15:25:11.5327
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ir2VPWNFKcOsNvI6E0QzUpjU5Qr8Zmdq2WeBuDx4iWKE9RzM60kHWOHB498CYRHcMrmpjkujlJ19DHrGXuiFvO49F3v+KSz6KLFe07s0Tus=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR11MB5621
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDIzLTExLTI0IGF0IDAwOjUzIC0wNTAwLCBZYW5nIFdlaWppYW5nIHdyb3RlOg0K
PiBLZXJuZWwgZHluYW1pYyB4ZmVhdHVyZXMgbm93IGFyZSBfX09OTFlfXyBlbmFibGVkIGZvciBn
dWVzdCBmcHN0YXRlLA0KPiBpLmUuLA0KPiBub25lIGZvciBub3JtYWwga2VybmVsIGZwc3RhdGUu
IFRoZSBiaXRzIGFyZSBhZGRlZCB3aGVuIGd1ZXN0IEZQVQ0KICBebmV2ZXI/DQo+IGNvbmZpZw0K
PiBpcyBpbml0aWFsaXplZC4gR3Vlc3QgZnBzdGF0ZSBpcyBhbGxvY2F0ZWQgd2l0aCBmcHN0YXRl
LT5pc19ndWVzdCBzZXQNCj4gdG8NCj4gJXRydWUuDQo+IA0KPiBGb3Igbm9ybWFsIGZwc3RhdGUs
IHRoZSBiaXRzIHNob3VsZCBoYXZlIGJlZW4gcmVtb3ZlZCB3aGVuDQo+IGluaXRpYWxpemVzDQo+
IGtlcm5lbCBGUFUgY29uZmlnIHNldHRpbmdzLCBXQVJOX09OQ0UoKSBpZiBrZXJuZWwgZGV0ZWN0
cyBub3JtYWwNCj4gZnBzdGF0ZQ0KPiB4ZmVhdHVyZXMgY29udGFpbnMga2VybmVsIGR5bmFtaWMg
eGZlYXR1cmVzIGJlZm9yZSBleGVjdXRlcyB4c2F2ZXMuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBZ
YW5nIFdlaWppYW5nIDx3ZWlqaWFuZy55YW5nQGludGVsLmNvbT4NCg0KT3RoZXJ3aXNlLi4uDQoN
ClJldmlld2VkLWJ5OiBSaWNrIEVkZ2Vjb21iZSA8cmljay5wLmVkZ2Vjb21iZUBpbnRlbC5jb20+
DQo=

