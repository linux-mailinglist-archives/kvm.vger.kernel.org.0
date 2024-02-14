Return-Path: <kvm+bounces-8643-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B2D48540E3
	for <lists+kvm@lfdr.de>; Wed, 14 Feb 2024 01:46:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 16E4428AA7A
	for <lists+kvm@lfdr.de>; Wed, 14 Feb 2024 00:46:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7BE1A958;
	Wed, 14 Feb 2024 00:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="V/LTTnT6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90CA57F;
	Wed, 14 Feb 2024 00:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707871569; cv=fail; b=uqcnn0qXP1rzuCmzZrcyQaZiFWMSglP4nzJZJ62OcPqOlDd2Ot67P0ocIa0HXC1+SpaWHqJRNqnJWVTd6FvS5WWr4Y5P19pbsADjY4YuXiEVQPfIoV2ynnArY/esp52OHtRpAOrb1ENrRBDkoaqyBUXSsFawVidOAuCaM4kxv3U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707871569; c=relaxed/simple;
	bh=IA/noqPb9ie1L+Bn2tla9MPVramEQm1KXGx2jrR4Ad0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=b01sRkrGUumFbyoK3RTcyYqwLHCmXmIYtzjOqb09ib6opMVrdcTtyznEcbyMeQJ5rJDTxli0vgqVV2HhcL47eZOpg8L1dGIhxFvjVZsVyynpi9hCNoEz2dxxFBf2FoawCd8qpnBJzHOfZk+Q47P2xRn7lmMxE8B2cR5/icH8sm0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=V/LTTnT6; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707871566; x=1739407566;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=IA/noqPb9ie1L+Bn2tla9MPVramEQm1KXGx2jrR4Ad0=;
  b=V/LTTnT6KKiRxeCnUERCpF6jLI72nPrBA410JuMkC0nXtFl4RjThvwPD
   70B7M88cc7o+76UnGqsoFrOKi2M7fEx3izwqFlObzq7pzRCOjJfkT9Wuz
   PzhuBc0WHS8GHiVB0KMidb1ev99gWFFlDk/NMOGb29JWJeCJJWvkMcGbq
   vO11j5mjQd0yKg4dXH3T9Y7myofe4tJdPjXeQ5ZM8PNfVURvbwCLtGyM0
   xKK0p/fNhm+FexmcWYe+KCZrsWIelphuR8qA4UN3UZU7d83/kS/lf9DZR
   xSGAaW+TapDYonKv8NNIKXRnc/MGSjLswzTILLy9Hcip/Qal2KedNDzJo
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10982"; a="27350195"
X-IronPort-AV: E=Sophos;i="6.06,158,1705392000"; 
   d="scan'208";a="27350195"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2024 16:46:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,158,1705392000"; 
   d="scan'208";a="7696055"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Feb 2024 16:46:05 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 13 Feb 2024 16:46:03 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 13 Feb 2024 16:46:03 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 13 Feb 2024 16:46:03 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 13 Feb 2024 16:46:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oD7QV1SC5y1R60tWrJrj/N1Gejj7MJE2U8JFByNtTCYFqFZQnwb3Xse4hGAeocaDKB6LQ1GjWSHBqYK5qkM9AJg2iWdokHNpHA4JM56rsoviOaYOAb9DEuvSMkaKFzcNNIafP0Wx4rqdfNsXUX1b5dk7/uC2tvLg8ez2954/avsm9jcnJGEWuaEIUSBdyuSM02UGk5G/46BaLjHupcRb1mSmwyWbe1sZZx521/zqVAXLbth2fQJlZpbU2V8rDxpr3cyzzSgE7aMn7v9auoaLMPVaK9Emh8UroQuaPhRe0xyjqzb6qpnaiy49+eRoVQPPKoYLAtpCWTIjn0bSNtW+0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BGKffyh9wE7OMeMNJoKmvSny1pQsluC89jeaS/zG9w8=;
 b=LgWpy4296VqHlFJkobzT5Pe8Q6lZjZzQZK5SbYtB8ACDXL/V5BOXMe8dLDUiw/2OCcRDDnJUtP95TYtMk46uZBW44GaaXkw1CEzTCPaz1D9rydMXDJVubIA2m+MagOX5GBFU8LiqUzW6hai1OLD2SJpGDonG5Q62D3vyUAVYY7czkMx8KFdmSCxeRrwCP8azbguftTqf6RSVV6eGS9NJeHcoXj7QvugZp0wMIsRtRh1qNRDLjnDkEUKdaqBZ0eAKLtN9ucNYredFwEVyCD0yrhtu+8oVkZSmCDHTsMjANeb6egzcBWlLt1Dv5/k3BYWOPaxIb4mga9WC3NCBiDmuGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by CYXPR11MB8689.namprd11.prod.outlook.com (2603:10b6:930:d8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.33; Wed, 14 Feb
 2024 00:46:00 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::8ccb:4e83:8802:c277]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::8ccb:4e83:8802:c277%4]) with mapi id 15.20.7270.036; Wed, 14 Feb 2024
 00:46:00 +0000
From: "Li, Xin3" <xin3.li@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>, "Yang, Weijiang"
	<weijiang.yang@intel.com>, "Huang, Kai" <kai.huang@intel.com>
Subject: RE: [PATCH v5 1/2] KVM: VMX: Cleanup VMX basic information defines
 and usages
Thread-Topic: [PATCH v5 1/2] KVM: VMX: Cleanup VMX basic information defines
 and usages
Thread-Index: AQHaWS3TKLWZzVt2oEy7w+XgclJ8GbEI6uCAgAAZ+hA=
Date: Wed, 14 Feb 2024 00:46:00 +0000
Message-ID: <SA1PR11MB67347AE5FD9A8710F3921D13A84E2@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20240206182032.1596-1-xin3.li@intel.com>
 <Zcvxf-fjYhsn_l1F@google.com>
In-Reply-To: <Zcvxf-fjYhsn_l1F@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|CYXPR11MB8689:EE_
x-ms-office365-filtering-correlation-id: 0229a6e8-0d23-40c9-f1a5-08dc2cf65051
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pdbzFkrQp4LbtTOEs5NGBA3rmCjA72SOlqm1if9V+uebYz+NTGs38ZX3Kg7r0IKurg1CcLPZKJDbVp8cyozxfXlLkZE8mBANHEFEwjLxRKJzZuWDgPQpiPwpWoUtXvZPAW0cLJ8IM4S36p9draA65c7lEDg1yo6+rsDaVqh3KDlCsGJ+0tZWhgIZSYivGdNhqzJPHIc/Oofcdb+xlRtofHPpLgCSsVbDQxF80+C6l5ZK2VzWgfQn1/pTCOzYwm0UeAxooQiXyYS3x6azW0AvnOg19qVNCArtoMs7+AOPI1Krr9abI6mubIxQBfF/Ht0dcwD3ZImQhRQ7W4cE0wSXQ+Hve8ZXDkFI+TEhNSHs7PVS8vaShcbi00d5KYRgQZzyazt/pXVgkCrIHjwdTlClNaJ80tAY2WLojCHC/YnejuH23oXHbEDnhi1mqeCpEXM0Yz4J/FuISwa/xFJe7z8Rlp17I+9feX6N5/E6McvUVZIIhupAbXPh433eW09v/HPa1RzhZR6HNhOOXohp/ybqWVIxyq4OHMkg9xl1+PG1FLDijlcFRhHa8ZVlIRC4PBPmHNa8oYQ3TpOO6xQeCZ+rvqiTnAT15G40A4ZfC7rIR3c=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(396003)(136003)(366004)(376002)(230922051799003)(451199024)(186009)(64100799003)(1800799012)(38100700002)(41300700001)(71200400001)(86362001)(33656002)(38070700009)(55016003)(7416002)(4326008)(478600001)(66476007)(8936002)(2906002)(64756008)(6916009)(5660300002)(66446008)(66946007)(76116006)(8676002)(52536014)(66556008)(6506007)(7696005)(9686003)(316002)(966005)(82960400001)(54906003)(122000001)(83380400001)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?MhxVGrhcu3QyFA0B+v2g2QTByvvbTrDudFyAQM0i1roW18ZkUzbhJjVIWg1p?=
 =?us-ascii?Q?D8p515Rl+3UOkBFetGE2ivX75IBxtce+H4wAlXCBD0Bwy2rVY2SPrKmi2gu2?=
 =?us-ascii?Q?LSqoMluZH5wDZnozxb9nESuOxeGTZFOytkNa0+N81kufb62mwKdt6IKsSLKu?=
 =?us-ascii?Q?eoFt6zSjy5FZcA1xcjwn0nZlvT/ii3M6hZ/17BWlHDDT9f7V0+GCFTasg0VF?=
 =?us-ascii?Q?UM+DQFCkAAe7MlIWhwdkCWo7YF5laW1SKQ51rso4KDUwjlwGE7k5zbkFoQW6?=
 =?us-ascii?Q?LCZNiZnYWuxPoLfJ5BUjC92gOu5s4nbo5/+PVTt1pTlcTbkO+Opy1b+Z/ulc?=
 =?us-ascii?Q?rKNmFE+/pbjDRMvNx8MDPGzZIIE8xlV/alg6XyXOIWGwdiBfti+S6kLB2JeJ?=
 =?us-ascii?Q?Yc9BdPwfWlpVllpgwSjcPWekDY0ExNYvWcncUPLI1BZhicSHv4D5RgeKnmEE?=
 =?us-ascii?Q?3N//60YVOJgFbaIt03+sXwItDlcihQkiOWZq1QE43VytfvBkK7qR3Y04R3yO?=
 =?us-ascii?Q?8sEH4HFbDeZKQfF8Gk8x1fk/z50eKu6bgMOc4GMk8N3Wm/4YS65FUP+Oe0Y9?=
 =?us-ascii?Q?GHJFNkLfOZJ+zfxM5jQkhJUt0LXSk4BKBVLynXtfQ3mdbx62cd9ueoUm/t1z?=
 =?us-ascii?Q?Gi0eSGzKfYJdVMHQd+l5U03YoQOzWLzNnHZYQaN7nAuZICGYJcIdq6EhDGPS?=
 =?us-ascii?Q?TpiKr64gpGxKHADK4iE1aGJAJki/mAPhv8cmVTRgZDG6LSouv9Dg8pfhJ5PH?=
 =?us-ascii?Q?c5k/GnkCeHxdKTpqainm/GRvgj2hTHVH1pOvNGeMKRlWBRwrjngZUBIMGQTS?=
 =?us-ascii?Q?VgR3JUK20bPkkKSKXVBZshXYWmK7g1yShNegsgfnof09gu80bVcuTNP26NNL?=
 =?us-ascii?Q?/pzj7WeY+Dy0p3FeOieg9/G/ezBBZgOwIXbkJPCTd5qwxW5MsWdd64YVg4h6?=
 =?us-ascii?Q?8PJgioOfni1HfdEIvXzUC3CdF8eF9IIdO/J/N7o76v+GtqqNMelvL01c8p1s?=
 =?us-ascii?Q?VigLY+bLP6v0qmB98c57232Smwl2BaJsATVIZnbTk5ZWzeaIbbfpwerTGZZw?=
 =?us-ascii?Q?rjpczL4LgTtu+maDrOZZrsOsCVLzARFTQKiZHAPY5aeYoVnP8DzlRwQrg7sN?=
 =?us-ascii?Q?6OHtV3d+Hw/WSuZDumKxhvt2067uib/+iqgWWxg/z2DpmzB0+Nv+TrIb9Diy?=
 =?us-ascii?Q?MaEYc9TXVIZODcEvpDdlDmGuSmVyIxvFKu06IoQKVyf/In/OgbeIQv9SsFp9?=
 =?us-ascii?Q?AeRoFDxT6QUwQrYnjxGaFFB7rP/AgBKlmh+2+pN9KAOU3i6DAAf6rjlRuY+d?=
 =?us-ascii?Q?UKr4GZzF5/1B6qXp0fqNjc709jf+DEBVrk+iEWH4Uls+IpvzczLuoW9odzzH?=
 =?us-ascii?Q?YKRMk39t1i55hiVwuYN97AjI8dRCZO5/HMQ8mDzDc89p17aFbLOz5zvIWJ1J?=
 =?us-ascii?Q?7zLRtdXPDkJdhZ94CwcKLiLipdzzTf4j5ypx/AuQ49QIqcUHFI29oOw7YYzo?=
 =?us-ascii?Q?3OVwXml/5aiSUJb3qTLQJDaYEqbxR3a06E/AWPuPyzu2HTrQAAwDttfVcC0p?=
 =?us-ascii?Q?wr+mr3okVV0hoz/Kx30=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 0229a6e8-0d23-40c9-f1a5-08dc2cf65051
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Feb 2024 00:46:00.0608
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ciWQOaK56i9aP+8IVBMLTN/Zty7pokQ6bMnyZrYbG5U1v2huDkD3fn9/G5ywJwVHJVmDHInaaJNoALtsBSBeNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR11MB8689
X-OriginatorOrg: intel.com

> Please send cover letters for series with more than one patch, even if th=
ere are
> only two patches.  At the very least, cover letters are a convenient loca=
tion to
> provide feedback/communication for the series as a whole.

Kai also said so...  I'll take it as a standard practice.

>  Instead, I need to put it here:
>=20
> I'll send a v6 with all of my suggestions incorporated.

Perfect!

>  I like the cleanups, but
> there are too many process issues to fixup when applying, a few things th=
at I
> straight up disagree with, and more aggressive memtype related changes th=
at can
> be done in the context of this series.
>=20
> > @@ -505,8 +521,6 @@ enum vmcs_field {
> >  #define VMX_EPTP_PWL_5				0x20ull
> >  #define VMX_EPTP_AD_ENABLE_BIT			(1ull << 6)
> >  #define VMX_EPTP_MT_MASK			0x7ull
> > -#define VMX_EPTP_MT_WB				0x6ull
> > -#define VMX_EPTP_MT_UC				0x0ull
>=20
> I would strongly prefer to keep the VMX_EPTP_MT_WB and VMX_EPTP_MT_UC
> defines,
> at least so long as KVM is open coding reads and writes to the EPTP.  E.g=
. if
> someone wants to do a follow-up series that adds wrappers to decode/encod=
e
> the
> memtype (and other fiels) from/to EPTP values, then I'd be fine dropping =
these.
>=20
> But this:
>=20
>=20
> 	/* Check for memory type validity */
> 	switch (new_eptp & VMX_EPTP_MT_MASK) {
> 	case MEM_TYPE_UC:
> 		if (CC(!(vmx->nested.msrs.ept_caps & VMX_EPTP_UC_BIT)))
> 			return false;
> 		break;
> 	case MEM_TYPE_WB:
> 		if (CC(!(vmx->nested.msrs.ept_caps & VMX_EPTP_WB_BIT)))
> 			return false;
> 		break;
> 	default:
> 		return false;
> 	}
>=20
> looks wrong and is actively confusing, especially when the code below it =
does:
>=20
> 	/* Page-walk levels validity. */
> 	switch (new_eptp & VMX_EPTP_PWL_MASK) {
> 	case VMX_EPTP_PWL_5:
> 		if (CC(!(vmx->nested.msrs.ept_caps &
> VMX_EPT_PAGE_WALK_5_BIT)))
> 			return false;
> 		break;
> 	case VMX_EPTP_PWL_4:
> 		if (CC(!(vmx->nested.msrs.ept_caps &
> VMX_EPT_PAGE_WALK_4_BIT)))
> 			return false;
> 		break;
> 	default:
> 		return false;
> 	}
>

I see your point here.  But "#define VMX_EPTP_MT_WB	0x6ull" seems to define
its own memory type 0x6.  I think what we want is:

/* in a pat/mtrr header */
#define MEM_TYPE_WB 0x6

/* vmx.h */
#define VMX_EPTP_MT_WB	MEM_TYPE_WB

if it's not regarded as another layer of indirect.

> >  static inline bool cpu_has_virtual_nmis(void)
> > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > index 994e014f8a50..80fea1875948 100644
> > --- a/arch/x86/kvm/vmx/nested.c
> > +++ b/arch/x86/kvm/vmx/nested.c
> > @@ -1226,23 +1226,29 @@ static bool is_bitwise_subset(u64 superset, u64
> subset, u64 mask)
> >  	return (superset | subset) =3D=3D superset;
> >  }
> >
> > +#define VMX_BASIC_FEATURES_MASK			\
> > +	(VMX_BASIC_DUAL_MONITOR_TREATMENT |	\
> > +	 VMX_BASIC_INOUT |			\
> > +	 VMX_BASIC_TRUE_CTLS)
> > +
> > +#define VMX_BASIC_RESERVED_BITS			\
> > +	(GENMASK_ULL(63, 56) | GENMASK_ULL(47, 45) | BIT_ULL(31))
>=20
> Looking at this with fresh eyes, I think #defines are overkill.  There is=
 zero
> chance anything other than vmx_restore_vmx_basic() will use these, and th=
e
> feature
> bits mask is rather weird.  It's not a mask of features that KVM supports=
, it's
> a mask of feature *bits* that KVM knows about.
>=20
> So rather than add #defines, I think we can keep "const u64" variables, b=
ut split
> into feature_bits and reserved_bits (the latter will have open coded
> GENMASK_ULL()
> usage, whereas the former will not).
>=20
> BUILD_BUG_ON() is fancy enough that it can detect overlap.

Sounds reasonable to me.

>=20
> > +#define VMX_BSAIC_VMCS12_SIZE	((u64)VMCS12_SIZE << 32)
>=20
> Typo.

Sigh!

>=20
> > +#define VMX_BASIC_MEM_TYPE_WB	(MEM_TYPE_WB << 50)
>=20
> I don't see any value in either of these.  In fact, I find them both to b=
e far
> more confusing, and much more likely to be incorrectly used.
>=20
> Back in v1, when I said "don't bother with shift #defines", I was very sp=
ecifically
> talking about feature bits where defining the bit shift is an extra, poin=
tless
> layer.  I even (tried) to clarify that.

Another review comment got me lost here:
https://lore.kernel.org/kvm/2158ef3c5ce2de96c970b49802b7e1dba8b704d6.camel@=
intel.com/

