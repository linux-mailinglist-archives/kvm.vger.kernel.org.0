Return-Path: <kvm+bounces-6401-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 60CAA830B20
	for <lists+kvm@lfdr.de>; Wed, 17 Jan 2024 17:35:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 08B5128BF84
	for <lists+kvm@lfdr.de>; Wed, 17 Jan 2024 16:35:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFBFF219F0;
	Wed, 17 Jan 2024 16:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QrIihL2S"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EC3512B96;
	Wed, 17 Jan 2024 16:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705509296; cv=fail; b=WbO/BVs46slcfzzKd8A4U8yMi8cD6Ccicmvlfdtzs+VYcEFRWmaNoL54abfioO1F98o21VQGbihk842qs8HJIPDfn7kLhOCGBOAy/1C8aGdg8RQtBC9hYX068YgkHYMxzt8iwneG5z6zxBkbnisukTjTz3/UR1Dwa5aGnjdG9hQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705509296; c=relaxed/simple;
	bh=ukXvCvcHCkD/0WF/tKr1bbTWLhK0w5MtUQfTuxjRUbM=;
	h=DKIM-Signature:X-IronPort-AV:X-IronPort-AV:Received:X-ExtLoop1:
	 X-IronPort-AV:Received:Received:Received:Received:Received:
	 ARC-Message-Signature:ARC-Authentication-Results:Received:Received:
	 From:To:CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:
	 References:In-Reply-To:Accept-Language:Content-Language:
	 X-MS-Has-Attach:X-MS-TNEF-Correlator:x-ms-publictraffictype:
	 x-ms-traffictypediagnostic:x-ms-office365-filtering-correlation-id:
	 x-ms-exchange-senderadcheck:x-ms-exchange-antispam-relay:
	 x-microsoft-antispam:x-microsoft-antispam-message-info:
	 x-forefront-antispam-report:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:
	 X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
	 X-MS-Exchange-CrossTenant-userprincipalname:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
	b=UmwOD7QZneome+IvUaf9qbJj/9LxeOpua2g1VhrEvAZjEPpNl9lcxhjP4Ve515r3PIHK016FxwJdK/Wq4u27Ci9UPbSEgJVA0/e5wFpPr7qCTuV74tOhoiiJnfi1bYyExfW9yrkBDUkQwrl4a1o/jzH+OBtDH4Lnqnsd+9cgzpI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QrIihL2S; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705509294; x=1737045294;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ukXvCvcHCkD/0WF/tKr1bbTWLhK0w5MtUQfTuxjRUbM=;
  b=QrIihL2SJfisjqKsuDAPVPgH6Azk60onvXG8SlyTSNbLNUT2CKIwaLEX
   E1oQhgQ1th8DLS9xjs/zKCRIlmfghg+Hj2jRx7HfUu2savouY6vaXsND5
   zRm3HvwSQOkRJ7Rzm3VubYACtMhNSr2X/elHee0YPpUPRs51g/iQErdtw
   BPtp8dmR9CfVCSL8/kcR/npIRRBnWSQkNOukg4YxDnJSeWCv7P1qGlOqS
   4nF393Tz9Iksv5g54SjwTFJLWuwR86V4ssGaKFTyWcB/0YEgZ3eRON9O6
   dCTgnO0/1tDE8EjlvKppc22qjRubRV44VMx3j9fSYS993MmVo5oTbhrgO
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10956"; a="102106"
X-IronPort-AV: E=Sophos;i="6.05,200,1701158400"; 
   d="scan'208";a="102106"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2024 08:34:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,200,1701158400"; 
   d="scan'208";a="32852503"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 17 Jan 2024 08:34:54 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 17 Jan 2024 08:34:53 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 17 Jan 2024 08:34:52 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 17 Jan 2024 08:34:52 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 17 Jan 2024 08:34:51 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EGdh81jHviwp3tda5PO9SR9a5qvTtQcajJdNiUdeyrguxhejTAcH385rqqpv9WDi9gNfphCl3jHWbfKE/vs03t9pUZYEA/s0FerjyzLzCELWtl37m81J7oQqD65XzcjthsQj4qgOQp03Z074Gw8I01rsZ4CE/Rg8stIx6o3KxmFp71kCRWm1MqiIcKt1+jjGniV0icchxvD+3Lbvn3bnr87vR+4flMESIOza87MUkcvRQ2QS5wFkIWEpuvhvfTfvTDn9ieC6poGkSGO+l4E3W5+Fe6UEMMIyvwJeJ3hKPKT+hEDI9hfsezQ9OpjhqTn2oDQj7ZG4I7VUaJytWQ0CHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B8ga3Wng9QqZcE2QTizg2MCLVYjZCMsKhbNNxbr9mJU=;
 b=EShndH6GeH7Y4/4VLBcPL6PcxrFN47qsQ4XgtV1neA5Y+ZcyldUC3KgSQAt8sFOvpM/vJLQl9w3UkQVJPXYuO4QYru02+BUddSqsLAjBRA9LdJyeAvQnza6hYDPkLxe3CmKUhXYXEMg1ckVEQPC0FEx/Q+dsji5tskrpMAuT4hONxn+c+30he5X8Tm9mlsEhlaw5rySzhSPYBHok6DyKNEyRcl0TeI94EHCXhtEQfYrTmDwgwcOLfUOOh+XlspqsYBOFmVLT0yCUCPwR47gdIhiFfbxwwccO2ffIy66refaOlNC2OmrKkrdCcdM38oy2ceo95/3piDMNRBcr88DUNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by MW3PR11MB4571.namprd11.prod.outlook.com (2603:10b6:303:59::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7181.26; Wed, 17 Jan
 2024 16:34:49 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::8ccb:4e83:8802:c277]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::8ccb:4e83:8802:c277%4]) with mapi id 15.20.7202.020; Wed, 17 Jan 2024
 16:34:49 +0000
From: "Li, Xin3" <xin3.li@intel.com>
To: "Gao, Chao" <chao.gao@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "seanjc@google.com"
	<seanjc@google.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com"
	<mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>, "Yang, Weijiang"
	<weijiang.yang@intel.com>, "Huang, Kai" <kai.huang@intel.com>
Subject: RE: [PATCH v4 1/2] KVM: VMX: Cleanup VMX basic information defines
 and usages
Thread-Topic: [PATCH v4 1/2] KVM: VMX: Cleanup VMX basic information defines
 and usages
Thread-Index: AQHaRT8NfyvFkqdAjk6/fSX6qVKXsrDcFbiAgAIkzVA=
Date: Wed, 17 Jan 2024 16:34:49 +0000
Message-ID: <SA1PR11MB67340002B67910588EE335B1A8722@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20240112093449.88583-1-xin3.li@intel.com>
 <ZaY0UbFjwCYh4u/r@chao-email>
In-Reply-To: <ZaY0UbFjwCYh4u/r@chao-email>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|MW3PR11MB4571:EE_
x-ms-office365-filtering-correlation-id: ead5bef0-c596-4d75-a76d-08dc177a393c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CtLZ6K5P8MMs3mgjbj9M3ypVg3uFg399Q2r/hRCUYng+9biqClVcnxcU43Jh/fLiEvzehmkbRDtn5lZ5iJtNDyibgwEoFbQUFLwvKJBljU3zJHusfHihrWiH5+C052tub4033ZZJLieGSHQvXb2iYGeC4FJZVbhT+x4ZY5U7WbI4bJt7Le6jzUiyf8sKx6OxK2lQHObnkcp86P0BzxGk3T39W59wBePIL5dcZRpX0t2UgyuPpkItKRaZNguLxM0qoNwxSyNLuRIxZM/cATr5spgrivw8uxFLRjbAWJ0CJ+V29VPaFmBHr8auEec/UGiGvYHv0X6KAf7jX4xfWfe6N8sgj9G0witdbBpfVoHSpwV6NYmxK6Sywa7LvVTNTFVLCBBGmBPWK3XaZKqSPALksErHL+DCFYNrTzCXrUUPFo/sktu8KBVidHtl6zIDpjDemhPcScwvUYHlcVI4DPESo7cEcVuLvINPkdIJgcIwlWzQ1TEQ22q93h6DD/ANZjA+Rs/iZ8HUe7gvH2L6AppmsuZB8OVZTMm/KVJj5BR4i8dscCXZX4arvMfvNVrzLHG+/F1D+NgX6WkPBceykn2f21LNQaj/gw/vJqhXQs92i43y+Xz1FYkByQ89/N8wnOBM
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(39860400002)(376002)(366004)(346002)(396003)(230922051799003)(1800799012)(186009)(64100799003)(451199024)(71200400001)(82960400001)(6506007)(7696005)(122000001)(54906003)(316002)(64756008)(9686003)(66446008)(66946007)(66476007)(66556008)(41300700001)(6636002)(76116006)(38070700009)(478600001)(38100700002)(7416002)(5660300002)(55016003)(2906002)(86362001)(83380400001)(8936002)(8676002)(6862004)(52536014)(4326008)(33656002)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?1HYcYvwZm5bLQcnCZvIc47JNlPwhf+eC1ynKkJebmu3dtYtkoxcSQlJKoZdv?=
 =?us-ascii?Q?PApat4kM6pXlYcx4b6c6QErw/oLuPAo6GqLgYHgdERZiGbOgPwLqOlv8bYGQ?=
 =?us-ascii?Q?+K6xh29Df0AKpkntAAu4IkxKC15XXibKSKWJ8KOZmDoIeD756uODn0Vjo7tF?=
 =?us-ascii?Q?NNoJZpQGbnxoOB36zWfkx2sQQ2/kFi2Ji2C2+Fky8VYYGo0qIxzxGg2qLaJJ?=
 =?us-ascii?Q?JIqV+/95i85CiSewlgdAlFfHP98Faol2+27uE066EmjiBasxsjc6bIDh51jQ?=
 =?us-ascii?Q?TbmbNiq7WknoX8JRMjLFRruiKpUU9oFWCFevdvEvo2fZ4ch65ottf8zv78eK?=
 =?us-ascii?Q?a5ilQNVhLBf3TR+MKTh1fxUw7YwCNx6mJ2BSpd5rAz4qh9O1Ayv+ZKkna+RF?=
 =?us-ascii?Q?2jRHkT4g0Ucb84sDCaSs1hobAF7nrfl3zzdL0rvPZWk9THULz9hDkSiA0MLT?=
 =?us-ascii?Q?bti1Gy2RGjaQ92i7fuyBcO0z4GeTdEHedbOI8OEfPQpEfEROUH905fNg8eOz?=
 =?us-ascii?Q?k0lL9HYwsfIbnm8x4fKvdr0uvybE7sfTHCiwWJfH1cHYZxPQE56H7v7DleH1?=
 =?us-ascii?Q?VxHmxtD2gBIB3cnItQc3nyRswcEHUDwPSlRdsrBSCKe/hFpFM64YQhi0s8Jy?=
 =?us-ascii?Q?ri0jp79JVrBEE3u75hmjbPHGO4hUNsOYWFKauOAmtb+mIOjpK84RJcy/Oina?=
 =?us-ascii?Q?8yehUObLEfqf6WIaE896it8YKIjfAXhJzQUGgI1ZMXijK8+roiVb+5nCv4FL?=
 =?us-ascii?Q?8X3+uhq7yf4jid8GchCvVCUoLMWyVInGezD28+KI+XkLBxZoknjxs6p7mu9F?=
 =?us-ascii?Q?eXdbPf3hX8vcxNsa10O7yu/t4nst05MRoItD88Q27PDmE4bLuGuLEnqo9/Hz?=
 =?us-ascii?Q?CVLIZOjFyAGzilcxtpmhXY0ArVDTBFbIiEfAFH8aVMG6e2j7rRrwLI9DGjEU?=
 =?us-ascii?Q?K/3mqXWxRF11KEbtqD/C/ZnUl6NavpgjqMihog+syUKKJfzIr2hRyisMtXDm?=
 =?us-ascii?Q?5XEoI9V6TNccx9JeeJ9deUw23RvKv5uqdvBbCLVsFq7LiOrDwJrVVdZjkS2B?=
 =?us-ascii?Q?TD0EvU6Uj/gOKytS0AxNXUpp+ZXPfHOG5+ph5Rf6+dDW7pFDo1QbHR0XY/c/?=
 =?us-ascii?Q?Obmhka7Hen3iHOLDEiOz6rKgxutpPw0bI3cwbLwLu2CB4NkBKGR6mjKvJeem?=
 =?us-ascii?Q?NSeDNo8BCAjEdokcFaPqr4LP7Yl5Wfguz5cdUAuGLOQZx59agYjUuwki6LC9?=
 =?us-ascii?Q?+nT7PXtAcYWFRlLrw0tT4eOyrPuKpQdMmeMG9LCos5+hkV95aty0hEFHZFLA?=
 =?us-ascii?Q?AKl4+mVYS6erOEykKBSIFQNmX0XVyVwmnPX6KiafJ5akUCKpOpdL7ZGuxWYs?=
 =?us-ascii?Q?1Ip/eTcTzOEfaMoH/CKw2gLhyHEWr5qtsbyQiDiPjQKfXAWGrUG1cO+xkZdr?=
 =?us-ascii?Q?UtqFs3zIIfBTkQtpxHkNEcy6I6299U8YlMN8ninGsTIA2fklJnw/+l/ReRVY?=
 =?us-ascii?Q?jACI6p5XKm9mp89AXQNOfO4NKKAya4uQy5vuuz3VQbZQozOj6LPtBS3FCNxp?=
 =?us-ascii?Q?00dcbLXNwDQJvDGluzU=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: ead5bef0-c596-4d75-a76d-08dc177a393c
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jan 2024 16:34:49.3322
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zyYxAHmNVUK7fTidJNyiWCXXz2Zh76x1ESDBbQetAv3vLJy0aI1w2ihJNGAftKMogfgpbMGAiyW/7qKl/na1yw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4571
X-OriginatorOrg: intel.com

> >+#define VMX_BASIC_FEATURES_MASK			\
> >+	(VMX_BASIC_DUAL_MONITOR_TREATMENT |	\
> >+	 VMX_BASIC_INOUT |			\
> >+	 VMX_BASIC_TRUE_CTLS)
> >+
> >+#define VMX_BASIC_RESERVED_BITS			\
> >+	(GENMASK_ULL(63, 56) | GENMASK_ULL(47, 45) | BIT_ULL(31))
>=20
> When we add a new feature (e.g., in CET series, bit 56 is added), the abo=
ve
> two macros need to be modified.
>=20
> Would it be better to use a macro for bits exempt from the bitwise check =
below
> e.g.,
>=20
> #define VMX_BASIC_MULTI_BITS_FEATURES_MASK
>=20
> 	(GENMASK_ULL(53, 50) | GENMASK_ULL(44, 32) | GENMASK_ULL(30, 0))
>=20
> and do
> 	if (!is_bitwise_subset(vmx_basic, data,
> 			       ~VMX_BASIC_MULTI_BITS_FEATURES_MASK)
>=20
> then we don't need to change the macro when adding new features.

Sounds a good idea to me, and just need to add comments about why.

>=20
> >+
> > static int vmx_restore_vmx_basic(struct vcpu_vmx *vmx, u64 data)
> > {
> >-	const u64 feature_and_reserved =3D
> >-		/* feature (except bit 48; see below) */
> >-		BIT_ULL(49) | BIT_ULL(54) | BIT_ULL(55) |
> >-		/* reserved */
> >-		BIT_ULL(31) | GENMASK_ULL(47, 45) | GENMASK_ULL(63, 56);
> > 	u64 vmx_basic =3D vmcs_config.nested.basic;
> >
> >-	if (!is_bitwise_subset(vmx_basic, data, feature_and_reserved))
> >+	static_assert(!(VMX_BASIC_FEATURES_MASK &
> VMX_BASIC_RESERVED_BITS));
> >+
> >+	if (!is_bitwise_subset(vmx_basic, data,
> >+			       VMX_BASIC_FEATURES_MASK |
> VMX_BASIC_RESERVED_BITS))
> > 		return -EINVAL;
> >
> > 	/*
> > 	 * KVM does not emulate a version of VMX that constrains physical
> > 	 * addresses of VMX structures (e.g. VMCS) to 32-bits.
> > 	 */
> >-	if (data & BIT_ULL(48))
> >+	if (data & VMX_BASIC_32BIT_PHYS_ADDR_ONLY)
> > 		return -EINVAL;
>=20
> Side topic:
>=20
> Actually, there is no need to handle bit 48 as a special case. If we add =
bit 48
> to VMX_BASIC_FEATURES_MASK, the bitwise check will fail if bit 48 of @dat=
a is 1.

Good point!  This is also what you suggested above.


