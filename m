Return-Path: <kvm+bounces-9050-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FA75859F58
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 10:12:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7A3A8B20A1B
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 09:12:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6A2622EF7;
	Mon, 19 Feb 2024 09:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GNal29Mv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1148A224DA;
	Mon, 19 Feb 2024 09:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708333931; cv=fail; b=RTI38dEOGBV6CG8jviCe7lH3qQy/o03DMcr2awrv10jhhAMP8JZPg3prXxmDE4gPBsshnl43gRuRd6+gKEYVXVKrypPO2BQ5xdM0qffzREELQpZCgkcCXOsScfnZ1djwVon982+i3Rrf5j/WSqZ769F2eef+FcPgJp3AMIqcmss=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708333931; c=relaxed/simple;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=OTjt7dAme1C8jFUzYEWXHEAlKWv+7hb0CdkNOk7U/7PAqN8TfeRDDpVX4nG5bdas0oEjaIYxThjTPlB5CwKZO+gSe8g+pK54PQPoWyT6XMt3CXRMMI198nRChpB4qbdUBj4DKfVHb5vJ/W3dWWzgMSxkMh+YOKL8InACRIfPbBk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GNal29Mv; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708333930; x=1739869930;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=frcCV1k9oG9oKj3dpUqdJg1PxRT2RSN/XKdLCPjaYaY=;
  b=GNal29MvMcBFHrDsbIrY6+P1QfFhyyx48haMrutVczrdolHZ4BIw11Ct
   qg3QwQ+u9JeaDaCKkecGaR39PnwvOT59XaP4M5fIV25jUVjgdDMJK89zE
   hpK/qVFJJw+tpoMEIPNKap8CiiexLfKNar6gCbL97kYrVQo6HVpHAqluM
   4SLCoHlAAm4CbLNXZpdWDZ92TtA7zJB447IgEbUteSC/8tPLeXH56CkZu
   2rTJTXalGQAHdVoUE81NzqsklkYhnrX1bXItXHeQ1o9rHOiFJEQnJmIrL
   UR+3BiAJ4nvfMCFkefKKzhQQidhzpYCwnDvrxGQy5LP4xGpK6IODiV/Th
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10988"; a="19933490"
X-IronPort-AV: E=Sophos;i="6.06,170,1705392000"; 
   d="scan'208";a="19933490"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2024 01:12:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10988"; a="936260073"
X-IronPort-AV: E=Sophos;i="6.06,170,1705392000"; 
   d="scan'208";a="936260073"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 19 Feb 2024 01:12:06 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 19 Feb 2024 01:12:05 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 19 Feb 2024 01:12:05 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 19 Feb 2024 01:12:05 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bKZ4jE9e9F5RiRW9ScOAknEwGX3QsFZi6YDU8nuouSqEbePplIS3wNxv6D7QB67Y3Kjoq83m/IwJgmhz2CMlz+m69a+7IG/61HXg1PZb8JOzzO68aHeinAxF3Tc8uWQDmc2gEKnPccnxU091vdGsgsvWbJSgh589jN9T0pbxc2iQV61rBl6yzipunDybHNnNpsb0UscgGf04K6zuGh1Dvrw0Yq/qiAZ0ta48XDVEK1OBsrBv6Tly8jpLRiUi3MjYjTr3Hz5qpoco9LaoPuLxAU3c7YqqiH0yF39gcW+Y+VOefsISWBDkzzjAxtTa5MoRcnDHApmCIM0wwVU/IKbkKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
 b=Wps88IhknK4qPdAACKpa6NMVU0kT7xnP8hGbQ08he5ceDsO1yuta+krp6HweEq6kdkYdrzgYdMa2beY3gNmezuwkLRttoLE5cmsLD2SeMp0LHp4V/Sth/OfgVEbPIMZ1YlQSaeL9spryNXNQ6AwYd/t/QX6whKeElNtrTLCl63R+UDRQLGIYuF82ictyyWUdIWRW/DignGgmrhrF8CgnqbF+7+/jtgNWXPznw8NK7gzmlnii5olt/8VYpOQ2kyw0BTwcmmry+oQXkv2Wm1kP06t8aVt2NMa+N4tFH5y9mzDDt4iKJWyz9Z6OcOCUBbXiT0RLHgMYBghybRIgcEUgzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH0PR11MB5015.namprd11.prod.outlook.com (2603:10b6:510:39::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.34; Mon, 19 Feb
 2024 09:12:04 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ff69:9925:693:c5ab]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ff69:9925:693:c5ab%6]) with mapi id 15.20.7292.033; Mon, 19 Feb 2024
 09:12:04 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>
CC: "dmatlack@google.com" <dmatlack@google.com>, "yu.c.zhang@linux.intel.com"
	<yu.c.zhang@linux.intel.com>, "chao.p.peng@linux.intel.com"
	<chao.p.peng@linux.intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "f.weber@proxmox.com" <f.weber@proxmox.com>,
	"tabba@google.com" <tabba@google.com>, "yuan.yao@linux.intel.com"
	<yuan.yao@linux.intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"michael.roth@amd.com" <michael.roth@amd.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "yilun.xu@linux.intel.com" <yilun.xu@linux.intel.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v4 3/4] KVM: x86/mmu: Move slot checks from
 __kvm_faultin_pfn() to kvm_faultin_pfn()
Thread-Topic: [PATCH v4 3/4] KVM: x86/mmu: Move slot checks from
 __kvm_faultin_pfn() to kvm_faultin_pfn()
Thread-Index: AQHaW6dsgcZvfprhkEui2Cpmk/oNjbERFIEAgABblYA=
Date: Mon, 19 Feb 2024 09:12:03 +0000
Message-ID: <5e0b8c9eb9a0f8c917c6deea64827b53c51efe0c.camel@intel.com>
References: <20240209222858.396696-1-seanjc@google.com>
	 <20240209222858.396696-4-seanjc@google.com>
	 <ZdLOjuCP2pDjhsJl@yzhao56-desk.sh.intel.com>
In-Reply-To: <ZdLOjuCP2pDjhsJl@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH0PR11MB5015:EE_
x-ms-office365-filtering-correlation-id: da014862-fd8c-4944-3c3a-08dc312ad6b8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XmMvQ9DODtcUyl0ddJfKyJFrn7MFfYOjLWhTPWaxrAnxiz4KJuowapz4F72xraaJCuHDRpQmf2mosRDBwHBRLZYhtQ1SqscA1Pt27sG7E0NzBIo7RpiHGcvBRVtNbjS8+lLanHmgIvBc/aboqJ0Ol3yAyU3qPfPNnzVJHuRvJ8YQQi2kVTRURYAxTmWUC3CZWJaNIKCdN/hErhZY+v5qFsYpkZzoTlhxs9RmODPgXFOk5L0WElA/o2EaVEjkR9uehL6kfeWUNWX23Qn6zCh4NkLfWZ/xpUXlDAfJdhAv9u7Aef7h5jVIFfwc3rNU9pEtVUQ0UxeK+tvzg4MOFt0TUVzPR/Csvm0FY2Zoo2LbfDg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(346002)(366004)(39860400002)(376002)(136003)(230922051799003)(1800799012)(186009)(451199024)(64100799003)(54906003)(110136005)(71200400001)(316002)(7416002)(2906002)(4326008)(4270600006)(66946007)(66556008)(64756008)(66446008)(66476007)(8936002)(76116006)(8676002)(86362001)(6636002)(41300700001)(6486002)(6512007)(38070700009)(36756003)(2616005)(26005)(6506007)(478600001)(122000001)(73894004)(621065003)(82960400001)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?Lo/3SAiHlNABbdHGHTAj9fD+f2Oxc+QsWPqfJj+X/FQZbaUrIzQIg6EBrv?=
 =?iso-8859-1?Q?VI+IT7tlF0/DZI/pn6BHfaBY/uxgWt9zI2BIvnagu0jNe8GOMjbm48x7m+?=
 =?iso-8859-1?Q?albv+4KzMRcBLTz/DaxsPiNGNHfC/VkDzdWKMy6xHyezHUDFkKNoA3Ong/?=
 =?iso-8859-1?Q?unBbSyOUJSwTcGIB2tKYA4jUTLEipnivBRc4xNyzOj9klidEb3pVytb3h/?=
 =?iso-8859-1?Q?2v+q7rdjYRfwqlKrCjobAauBy2Na5pytnoDG7UMNaQQOYM/wCUKXTx3nU1?=
 =?iso-8859-1?Q?roiNkJ2FMaJgq21BYric90oxVKJx2I9BvDswmkuA2SQLaWNUyhxuKaCE0q?=
 =?iso-8859-1?Q?RIQFJxciKLivIAJhcc2akde5jzOrbk6r/G3phMm0RJO6VtkC77A5/xqi5G?=
 =?iso-8859-1?Q?SGhb6VJYmDBRcKsZvMJzxO/97T1O0mHFd/gNMh5keFd6gGBnUNNfR3jmJc?=
 =?iso-8859-1?Q?UAMdJ2+raGKe5jukWMpXDFBOJGOUFTy9CeX2oE4Tgzi6vRsfTU6FL1UKG9?=
 =?iso-8859-1?Q?uQ7IwV0/uAuO9hU4x6Zn+y+SOiIyeTBZWotbmuy2XrA4ZtkL8RTjgvaLR/?=
 =?iso-8859-1?Q?zZNwV/2go1DgDZDrY6JEoePxZeb7VO504HF6EVPe/nHovbuQF6RSvj03JI?=
 =?iso-8859-1?Q?ZvwD9HrbPDYoATqpw7hFp0OU/YUx/7b6qkqpLjyq+7znB2dJXgQYfN6jRZ?=
 =?iso-8859-1?Q?bU96gnZR4VLSVf8H5LCkyfb9qNU3G0XKnQXpCFk+PJvccIeHDs8ZzFUWyJ?=
 =?iso-8859-1?Q?dyYNE7NWPmaOND2e/ZKQ8TsZq4WZ1R4qwrIwMrAZJIJ6vNK1Dm/lxbuxhz?=
 =?iso-8859-1?Q?aMalZOsaRacQ/rPTandgrFtQLEJW9/jUo+SAfVV4nkl/OpwnXHBv+eZ4sb?=
 =?iso-8859-1?Q?fKW5ryn2KGM5+qnkcd7Duv64uAGcw/8tf/Sd9ZrH2WsEWoR5uiZDShyCs/?=
 =?iso-8859-1?Q?0KJfS0AUNfNEkJtht/mfYtCDwEtuql4I+rziRsSEUWmB+zWVJ9laCcIgmS?=
 =?iso-8859-1?Q?27hIzZBBVOlsePv4LquzZ2+3m7+4R7//o2xybWsl5moKLcH4U79JQ1uX2F?=
 =?iso-8859-1?Q?0eLHAmXbP+PEuGtUqEjqIhpttwXaD/1uTLted/OZ3LAbv/w8JqaQGwM3Vo?=
 =?iso-8859-1?Q?9jadwLDdCl7hP8DA1EQ52kmdPwqvBdfXaMbozKaEC5CwtXyUCU8OxdZ1W2?=
 =?iso-8859-1?Q?5inXwhZNRM3w77PMD638v8KyI3N/O0UaZp/sn1TzuwoTI24bYDuNiwfw9W?=
 =?iso-8859-1?Q?xLDo8o6NLf81OrJUXi8LJs9kyi6SrCssQlKLSL6A0I5w5aZZtcNmgviNCx?=
 =?iso-8859-1?Q?F4HsFaRryicm0O7uwhWXu7KmAxNzz8Dn6l/e0Mg1DE0kbfxT2TopGqzaRw?=
 =?iso-8859-1?Q?qUdOXrEp8epdI2imEfMRcIreuFthYDU4nfQ7c8jn62bn0mDhnjMjeSST38?=
 =?iso-8859-1?Q?hZKgCy30EX3Cu4qVa/vzvH1kxUSycltUWDbKS4oHlyVdZ01W9Kp0BhHlXm?=
 =?iso-8859-1?Q?xldekxQxrEcPQ3aNrf3yDIsy3c2uENnS8lAN+1c0pCiICYjPPOJ3Ly6WkP?=
 =?iso-8859-1?Q?759QLgDHVvGzTn2fm2n/sHv9CVTI8Hh9gDgq9ujw4627Poq26TqrKYp8Ms?=
 =?iso-8859-1?Q?K6mOD6kiHwHvbfOZWJVd6936lxhpt8CjToV/pnUhtmYCnRUrsvLkH9hQ?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da014862-fd8c-4944-3c3a-08dc312ad6b8
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Feb 2024 09:12:04.0098
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OhNAZKYvvGCEaT3cNV6IYOZ+jUZbfsEjwVF02jz/vqq3Zg458Ml4AUHf4HmkQjHLp4NQOkoHzy6IcfayC2OWZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5015
X-OriginatorOrg: intel.com



