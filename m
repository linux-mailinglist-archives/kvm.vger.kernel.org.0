Return-Path: <kvm+bounces-8653-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DD09E854189
	for <lists+kvm@lfdr.de>; Wed, 14 Feb 2024 03:24:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6B40D28F68A
	for <lists+kvm@lfdr.de>; Wed, 14 Feb 2024 02:24:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D77810A2E;
	Wed, 14 Feb 2024 02:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HFA9Per0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9038010A11;
	Wed, 14 Feb 2024 02:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707877396; cv=fail; b=DTYg4c9Ubl+NeDJZzddBiuN7Dj6QgmfQRYvzplKv2UebcG1vukc/ZXxmguiIppX3DnmPMArkwg0PYYRlKsUJ7A+zpszPIhRMljc9npMlWl/l/CZ4vknj4LB57d9AIC+1xcKXbgZxxrhCkT5TVuMa17RSMMb/E9byX9OkhDrfRq8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707877396; c=relaxed/simple;
	bh=TkUY9WGedIymhPlPUrROJ12JEctP8/9nV9Elt4ql1fk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=W8mwtArFDzlcK54YJ/ZTC2yNKcXWYtNAfFfrCLzrDWGFvtOGXEguDtGWEvor+KQ2nfBlFA7MjOpeyqXVv0owRRK7IyCCZbdJ649cifFfGa/xTaf/m5Kpmg/LMB2+V94VGeL8UnmeX54y5D+h1FuNGqa+XvhGl4IXVBQEDwTloms=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HFA9Per0; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707877394; x=1739413394;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TkUY9WGedIymhPlPUrROJ12JEctP8/9nV9Elt4ql1fk=;
  b=HFA9Per0J2VULICID8vVh0KoLOVtG/hSGH3ZsqUzt2cIIbWVnupo3Z23
   BLIeWHFduhanxPgjCa71lcHeoBX8Sj3n1qNdsDJx9nyZfCQSnZvIQwxfr
   GlHObMz4/7+zCp9hLFQ8V5RYPVocEbmjUkDye79hP7BQHYOJUvLOljhrA
   mJDWdR7aA5EQXDT4jOa8ujoHjbkNW+KfMi/BuPgVIsuMzD8V4GOGHfv2M
   yWE0aFRVWwul/xiH/2bE95GXJoH9T8IESL0NbTeEtMEhfcDVz4IywR06e
   jET87fusuH1+KaeWqSXMAgHUJwPQHGiwYNTv+yJkta5cwhA6T1ixQMP2R
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10982"; a="13298062"
X-IronPort-AV: E=Sophos;i="6.06,158,1705392000"; 
   d="scan'208";a="13298062"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2024 18:23:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10982"; a="826285073"
X-IronPort-AV: E=Sophos;i="6.06,158,1705392000"; 
   d="scan'208";a="826285073"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Feb 2024 18:23:13 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 13 Feb 2024 18:23:12 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 13 Feb 2024 18:23:12 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.40) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 13 Feb 2024 18:23:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z0kvQRwadr59ENlS7GuTV8uf+eQ7IHJ6qCMOyxgOEYLxbrP6I7eWeOAlqaXyzo+bp25iCgpaJDbndNDI+UyO96NxI49PlZeZYXRaKfUmLWzLOsf0OTPFCi0eZDbYtvC2OwFQyCGDB/LrsRE2Hpb0T02CuivpZ2eZDjjlMZqguVJS/eo2kFu7IGvtG2c3nEek1bpz3FEeIGcOdM8moAKcV6MOIW6yxzhEYMlTvpwlzW82GYzLLmcSJD3i3nn+e93PmFxufJBRtkh6ASoaQkOwqBqTqbLxblLBnoEtJwLjRdxRFde/YDjtmM+3knAAowLlqBQ9tlK+nzS7LpV5xdwCMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9AkSMH5v0n5M/lq9CGA4/2HjYHbkb1k+Rl8o1b7X7OI=;
 b=UQSxOQ9mhKqyxU741xhBxX2JrVL86WRlLn1ZoiTskMiMFUAJd/YAhvigivvmEaOu8rxU3OGpdUAOcCPZ5sAv777USHkTfk+6vbrZpmpjOn5aBVLUy2RP9Qno7idNuSidEIIcPwH/uASDWdWl02kSFmPcm8Gi/Hgf5dANTH+/+bQuz8NTUVX3C1XynISYJBvOXUZBZDHp+QGfK2KzcR/mFg2+Pk3m3breu1ymXcU9WzjB3EaQlTR6jLt+IjTOglGFxTV9jySFtIF+qKnYF1i1dsoXi6B4OR1i0ZYA4NabbgvSnv6zm5Iz0ZI9Kx56HqnrEsN7ql71XJjDCgu5t6zsUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by MW4PR11MB5870.namprd11.prod.outlook.com (2603:10b6:303:187::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.35; Wed, 14 Feb
 2024 02:23:05 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::8ccb:4e83:8802:c277]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::8ccb:4e83:8802:c277%4]) with mapi id 15.20.7270.036; Wed, 14 Feb 2024
 02:23:05 +0000
From: "Li, Xin3" <xin3.li@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>
Subject: RE: [PATCH v5 1/2] KVM: VMX: Cleanup VMX basic information defines
 and usages
Thread-Topic: [PATCH v5 1/2] KVM: VMX: Cleanup VMX basic information defines
 and usages
Thread-Index: AQHaWS3TKLWZzVt2oEy7w+XgclJ8GbEI6uCAgAAZ+hCAABIcAIAAD/HA
Date: Wed, 14 Feb 2024 02:23:05 +0000
Message-ID: <SA1PR11MB6734AFE5E89D450EA4ADE5DDA84E2@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20240206182032.1596-1-xin3.li@intel.com>
 <Zcvxf-fjYhsn_l1F@google.com>
 <SA1PR11MB67347AE5FD9A8710F3921D13A84E2@SA1PR11MB6734.namprd11.prod.outlook.com>
 <ZcwWeiNstRNHQiI6@google.com>
In-Reply-To: <ZcwWeiNstRNHQiI6@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|MW4PR11MB5870:EE_
x-ms-office365-filtering-correlation-id: 7450be42-f172-4d3a-5653-08dc2d03e049
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0CzLyT7/ybDe8UZWvtxSFElh9P/not0KfSBdarooR1mttmW9SmiLaSrDpkRO7uf0foE303eCyxGjpq5g/QbyjPXEAPx2aTvneaPoBZe2WCWLh4/T+wuoI1QiwFE09mbDfFzgo+21HVwUdUy17hIXx1TInZGBPxsu40DrSiXkHI8TeIVA5GUjUiMiVWnjl+vXaSSoynGceopQBVS7oawa15Cx0dPzLBK6FB+21HNHHXVhD29D1+JiCCkTuWU5vYh8HU6onfPcXojA2DftBuQ+Id64+9zbIW1T12ZS4k/ciHnnhVkkvfqQ9RHVfPboC0LT7RyQENsZl5blE4qKRP6Jy/QLNICJDoSbeXVEyzrO8QGNd6ceRTLGybUMcIDDDHwSn869M7cjIOUDC9iiJ06hPiyjujxDxoQ8SBJJ7DRqHtJ6hcfVqnprWh6UPqKBpHNHNfxev76F8/Lojcu7Gczcawmk2mKxgO8IyGs5Fe+aYtEwyvSXNgzHV+z7R26wnun/vDMaHVLqanX6HykPDg/pwPCxEWn2CsozaODW8FdyJnEE9Bv4dTNZS56q/1rcZmYSYTxbPz+BBSZfOkj3HNHCxDQHkcXGJgZA4GlINpFV7Z1xxickJ3twqMSrERmNml7q
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(396003)(366004)(39860400002)(136003)(346002)(230922051799003)(451199024)(1800799012)(186009)(64100799003)(55016003)(6506007)(33656002)(2906002)(7696005)(38070700009)(7416002)(5660300002)(66946007)(4744005)(8676002)(38100700002)(86362001)(122000001)(6916009)(71200400001)(54906003)(9686003)(82960400001)(478600001)(316002)(4326008)(64756008)(66556008)(66476007)(41300700001)(52536014)(66446008)(26005)(8936002)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?7VgHTTdNsWY6AUiEjxYWuulVQAdouj0a5aBGqu3qCWW7V6I46WS2+JTVhDOo?=
 =?us-ascii?Q?jFDCg8vGHCTNA2d4uaeX7KbwCqb7KlOrRto38wNEm9Xygvm4OueqY5mct5wq?=
 =?us-ascii?Q?U9EXwE7kpcXSQeipY6c3B6G40Qss8Uf1/4sgFMQCy1g0Lf7JaSa/tW5oZvwV?=
 =?us-ascii?Q?Bge/Msb1gvhSbR45YJAS8aieeWc/DrYLFyjWFnhT3O7FgiAP76CiKI09EIoe?=
 =?us-ascii?Q?OY7ViVHAD3qo6HKjBOlvt/SfEHBS9HUXVhjB+VIceSFOsYDb+AdNXbyKRszL?=
 =?us-ascii?Q?Ok/F2zR+iQ0wAYGKnBlqfkHO/s1L+ZDRk+05ZtWU/7ZFXyZ+aDo0zi/bY6FV?=
 =?us-ascii?Q?kxo2CuOZJ52209bJ3iqZF2NBT0SQFMYjSJ5UkT98G4O4P50Y0WzVm0q8KvqC?=
 =?us-ascii?Q?tP+Ei2HBg10k8OYkhQn5wkc9Rfz8nQ7ZQCIWBLAjOPLVoGviAnNNriGC/39G?=
 =?us-ascii?Q?N58OiHfHcITxQAXJJq0UrZnUPRC5vIHbDTEcuM5+ROlpH3dY55wzvmOwBE90?=
 =?us-ascii?Q?nFkJZP/s61RXB60KFBi0PtKLw9sR5gaAF+onhnRw4wS8w2ph6dylm/N2s1Zn?=
 =?us-ascii?Q?DeMPIn7Nrf0agIcTR4BOwRKi58DIWu9jmxps2u/OlRwZ1qJEPKFGyHRs6PhA?=
 =?us-ascii?Q?ZZzdT1TfH0OjB//DzE4lGOhewbZlGWkR+P/3Fza1uudi3cqo5dDZE1Lbe8rP?=
 =?us-ascii?Q?yP8W0rBPORVd9OAaUXHamSm1HFLWCrXw10mCry0z7aX7gozEt2JxeJXeeFcJ?=
 =?us-ascii?Q?NmWd3zQg8hp3EQE1b0SRJNBXrXoIzCSS581lLxIowWDe/nnhtzxyyxetvyI7?=
 =?us-ascii?Q?otSoDxj0KB6JAt91fuXMY6/n1hbX5NkbGmhQh5YWRunH/MuTCk1QxbP30HXL?=
 =?us-ascii?Q?yoR4oP7FGPzilorfKMr0ia+v+hx4VSwgeQpuQQu4o6RELkXjK09kuip2l1Gy?=
 =?us-ascii?Q?nAExIypxT1FOZoz3NkNaZ5lWYjtXYGLucnRyA2rbJiyHCfIGKOT0ObaX3Ulv?=
 =?us-ascii?Q?zGwG3fcY3YEHQB6IwHHXjuS01CFKtFyEINAck65qsBo1PY9CX+wCD2dzPJOx?=
 =?us-ascii?Q?GSZ75QiOFocXK8gNQbFrkvE9L6eRnaIOvHWsQla/g2kX7HRoflQHHgdY/MVy?=
 =?us-ascii?Q?xbK9Uhd7WpJaLSnJjysYKc+UPpTRpHY4fXHin3v641wA7e7R+xnKMuLWNspS?=
 =?us-ascii?Q?cPJAJSXIPLj6issbP04eP8QQmjpQivwvgMwX60LmTTDFRedYyxhNOiVoEq5z?=
 =?us-ascii?Q?KL4JkZgHgwGvtB2em0TDrzYmEph4A0Nt6ZwxQK5jAmX+L7bYlU1mWx5yNWF/?=
 =?us-ascii?Q?8yPjQPOumVrOR+jeJ4bk/0aMNu/MaLrDiE1b8LwDM5rtzI75zfe9lYdkkOhg?=
 =?us-ascii?Q?tA+S0ucFR7zSIGGgnN43S8VPkOW1NryPGhLekF1KFItCYVFeRAl2mX15gxet?=
 =?us-ascii?Q?EPb/DMaaWNqxYOT6McHSLLQy6YyhLTFQnFFarVnS6boVeQc/RNioVUsgKv4h?=
 =?us-ascii?Q?e5Pa76ZaUaWV1drteJ8Y70Lw6f9IdmhcxA8VxtoTrtFDxodNBAJBU3YfVfxZ?=
 =?us-ascii?Q?rmQjL2Iq3y75DcNo3Ik=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7450be42-f172-4d3a-5653-08dc2d03e049
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Feb 2024 02:23:05.0571
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ENBXs+UkwmFc06LSNwlU+Pz76GAy7DtRkzI9OPBiSom07ao6ORf/ud2Q2QfVqivIaKazkcNE/9mMUyS3RUxi1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5870
X-OriginatorOrg: intel.com

> > I see your point here.  But "#define VMX_EPTP_MT_WB	0x6ull" seems to
> define
> > its own memory type 0x6.  I think what we want is:
> >
> > /* in a pat/mtrr header */
> > #define MEM_TYPE_WB 0x6
> >
> > /* vmx.h */
> > #define VMX_EPTP_MT_WB	MEM_TYPE_WB
> >
> > if it's not regarded as another layer of indirect.
>=20
> Heh, yep, I already had this:
>=20
> /* The EPTP memtype is encoded in bits 2:0, i.e. doesn't need to be shift=
ed. */
> #define VMX_EPTP_MT_MASK			0x7ull
> #define VMX_EPTP_MT_WB				X86_MEMTYPE_WB
> #define VMX_EPTP_MT_UC				X86_MEMTYPE_UC

Perfect!

