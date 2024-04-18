Return-Path: <kvm+bounces-15101-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B2098A9CE3
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 16:23:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E807AB220DF
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 14:23:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 682F716C698;
	Thu, 18 Apr 2024 14:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bEhtwcV/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6DC216ABF3;
	Thu, 18 Apr 2024 14:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713450007; cv=fail; b=BQ+r3GtFb8f/JBOgs21niW+P2nL250ETqTSRVCntTFIn6c6AzvKsSrVUuo5HWRTULTfHgxVLv25eiDF+Zhx3zF+5zwV0SCGoz0hz5RKQ2e8kYtxhHOqMrAW34cAB9lZwRVXA2e8dpQveSScEndxUGduUx4admoMSuBlU1e+DaXk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713450007; c=relaxed/simple;
	bh=BAO27R21wLTG8/8ay6L6Qq23at/hMADruGMJBbYVz4c=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mvAeM9zP3S19Pu45X4gn2KTdNe99caiKPH+mSYoWlGHP4pfQvUR/9ZqIfTzV3/75tzthfBywYcCTVu9Hqcg/4SxykvtqxXN5OJZyHUyu5kk/eRjTk/uSQ5xMu0YT0VQkliIUDaIBpPGwaNeGJ1UBHgBSSSuv31ZgxvaH0iagog4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bEhtwcV/; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713450006; x=1744986006;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=BAO27R21wLTG8/8ay6L6Qq23at/hMADruGMJBbYVz4c=;
  b=bEhtwcV/ebns6Pp7NMrqBsrJxOUoZfviOmON/ASq3NYMNTc1Ey8JKqhr
   tsGuk5AGt0xyVjuFMClwAkGkDm3588ZRRCwEyMK4B8vhaXMQCRMmSdeVH
   aoDBU5DIyxUJGrSODAGw+ZarRgd1NW40KYMNf8A3spdL25etqKR+mQhZi
   wUSXes6SnlSyO5KJtQEwWSSpOFhDD/A3p4mRwv20IT6Hfx2xLcZAF9xVa
   hUPcZ8xM4scyI8LEvzXjyADHGvaDv9ksoFbL/VCRe2RnVqkEtc2uq3CjD
   Y/kyvHbg6UiXWOF8GEmRHvjM/kYzmnSnGn17y7K4ZS++odMM2JWlNr+4U
   A==;
X-CSE-ConnectionGUID: YpKeBG3CQxGU2p2SIdpQcg==
X-CSE-MsgGUID: gZqsPZ1UR0WrkRubWWd2lg==
X-IronPort-AV: E=McAfee;i="6600,9927,11047"; a="9222167"
X-IronPort-AV: E=Sophos;i="6.07,212,1708416000"; 
   d="scan'208";a="9222167"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2024 07:20:04 -0700
X-CSE-ConnectionGUID: ObhzbTF+Qoq8Fq53tZSgHQ==
X-CSE-MsgGUID: 5uY22s7NTnG1Li8b1vAXsg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,212,1708416000"; 
   d="scan'208";a="60423315"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 18 Apr 2024 07:20:04 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 18 Apr 2024 07:20:03 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 18 Apr 2024 07:20:03 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 18 Apr 2024 07:20:03 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 18 Apr 2024 07:20:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ILB7nu7PRNayc4vSSZWEck+21L8SqjcobYWkvl86d5yHeSh7VbgRSoryHn0wn1QpJMZaeftRwpEsJHZ0Lmq+Ayb3zVgRdiS7MN74z8uZMetNKH7LnJjOubyg0FpqIr+lLxm3N/8moWjYqbXBgtG5v8TNu/PboiFuRnKmqniU7dgspOtrTHzy0VAf96CtRaGI4XOsYY4Cnytpnfu6n4zPztNTPVBaTlWydyLz0fzGfoS4Bluecb9c/uqNOsmqPZZnTNCvSabDwfKq7BqR+XGQQErEmlTvblvWZ1VB9vEWb5Qy4n8aIGkS1W2GakiaBHbSiAE1Xs1LZL1r4Ax/BblXUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I14oD4PoCRGtITF2sZWeoRpVqY4r2lzf+1biu9CSkGc=;
 b=l3zjCgCH2xnp0IgL1D8r8vz3A+LUfBH/7vETCeFZT0FW7+k1U0fhP+JqVx9793WpSbaIJ3zK/EBIwdy/TqxWNSx/t7LwWZ8mgciAQ1lwEml89YwVQ+gEDJAwvZvMCDI3pECq13zSoRgiERC/pgpGaEi1GFyL12d91cgT5fWkkJgUQRmCNOnlPVkmhuyvXsELqnuDLvMAk6E6ml36IKGN8DBPZOapMNP09Ra6C+L4OAue6wyXwyOAsF3qELXgTMMVhvnwUfknsYykIrzl7sE/n4WzADTRXS1S/fRqIE04JZhdFh4D9RUxd2dRvRL/mgiV6RDCuuA3G3Su5Yu8z821wQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB6373.namprd11.prod.outlook.com (2603:10b6:8:cb::20) by
 DM4PR11MB5295.namprd11.prod.outlook.com (2603:10b6:5:392::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7472.30; Thu, 18 Apr 2024 14:20:01 +0000
Received: from DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::55de:b95:2c83:7e6c]) by DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::55de:b95:2c83:7e6c%7]) with mapi id 15.20.7519.010; Thu, 18 Apr 2024
 14:20:01 +0000
From: "Wang, Wei W" <wei.w.wang@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [RFC PATCH v1] KVM: x86: Introduce macros to simplify KVM_X86_OPS
 static calls
Thread-Topic: [RFC PATCH v1] KVM: x86: Introduce macros to simplify
 KVM_X86_OPS static calls
Thread-Index: AQHakNiYqtvKEMFbS0SvTLh/C3Jv+7FsplwAgACN6vCAANskAIAAAkcQ
Date: Thu, 18 Apr 2024 14:20:01 +0000
Message-ID: <DS0PR11MB6373B4170ECA01D31830CA20DC0E2@DS0PR11MB6373.namprd11.prod.outlook.com>
References: <20240417150354.275353-1-wei.w.wang@intel.com>
 <Zh_4QN7eFxyu9hgA@google.com>
 <DS0PR11MB63739BE4347EC6369ED22EBADC0E2@DS0PR11MB6373.namprd11.prod.outlook.com>
 <ZiEnIFW3ZQhDwdZ-@google.com>
In-Reply-To: <ZiEnIFW3ZQhDwdZ-@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB6373:EE_|DM4PR11MB5295:EE_
x-ms-office365-filtering-correlation-id: 5350ae52-890c-4749-9f8a-08dc5fb2a28c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 95fKt10lnJaX4Wta6z9mLgHNAgn9PVQufXxMzABoJAVi8kXUlA+Rv++K9s+IanDsY+m9Q4T0APnh/BvNRH4Aid5YvkGdA8Jd456DFS2njaQJrRWdSbqpyBv6mLp50X1yEBrfb1GAzUhL6DYRd8xj2U59iL4IoXPMfLgQEWwlFz5N82u5SDHJz7Umt80uPRPjsKtSr5iUtAMgNOX+Z4ilJfnmDeE/dPZfV4eb2BUeLUscLfzbTL5g9DwcufcWxQLa0T/evJCg4hcGNh/YqKpFELaHW5EJtjpbXmxT8++EzwP9ZYQCLiss/IAvQ2ftkw+ctOCPkKbjXQyKRa9IKUJ8VjpuJ882b+vywJoYNZlN2I09sA1Jf1IzlszTjmRI4N0vVRVrLv7iCK8fraXhVoIM6kQJEAX0YBWjL/Agt/5f4a48Xq6JokO3cXXHPcytB9PMzHPgVPsSKrS1s51JKK8iCWUaQaAjbiWb+4hj3ZiTey4kbeEWk2+ZTNh/AmSir4YLzwHTs7KN39LiAPH2N0IF6XVpUn0ho/1IhEy+GC6aq9mQsd8O9wCLpWy1pn8wju7omW9n8As43zsU+FbT76FS6RAoPoKzvTNt6GHEClZHsP9QszEQgTJX6wWLFWZz4WgX1IBL11mZvzxN4fdHfo5UCoAO5lBsnUoF/L9Js9jBBYxy81slx+KB1QA+hg6W5jl1LbL+jcUaOGrGDEVbv0VF/9A6KNdFZbUfxVuuVMHf74c=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?oVGHFBZDRP/mI1HxBzs+LFw9DR6kz+9MRP390kLnkoCpNSswg8ew+IOQ6Uv4?=
 =?us-ascii?Q?36qoOJXq6vVRNrQ5lNtMPEs8M1HLKovpVAB2G4d1qozFsYVdt4w0ixsGCeff?=
 =?us-ascii?Q?WV+o+3oZyAGfFHG0ncgnmfDf4KGchUZg+zpzh+iKWF7BujOLHZUiVJKnfPNJ?=
 =?us-ascii?Q?3Kvl6JvU0CWCdZBAKa08uPCCDyd+SHNYQauI2ZujNN3TFKeYUy6pwQPxpqYX?=
 =?us-ascii?Q?fpNpKsJ4k7z9UsF9UE4KWkFuzWXwjyzbFQySnu1L9XHHcVCWkjdb/Kv+HAbo?=
 =?us-ascii?Q?cQJp9PaRCFfCPO6xxBYh5lO/9MP5l2YOOWZMwo9iIt6nB08cqM+nsm7Pt9hg?=
 =?us-ascii?Q?XekSXOWOlWBzyMjSRHEEX6VRQk10J8+lwpoHwPYXqiLr03zZYnTAZ6arptRR?=
 =?us-ascii?Q?v0uUHI5txahYSp94D99NsEUmsSLAXDVGsilr5J+ZpWUXvSuH9IRgYaGxGvsq?=
 =?us-ascii?Q?jcLWuCmYILar6VtZwGGU2nymCvCmqw3muWjDJSAsqp/CizrkYOKCSKEAGL10?=
 =?us-ascii?Q?vzDHJv88u4L2Dez3vrSxcwBD11lsxodQWLLg0oU/LO81WgVc6ktqgk2jKq5t?=
 =?us-ascii?Q?wlLpgBsEUKKpPPfE7bcZ/YkPT7idtR3gq/4OeqiiK3YocfxMB/3qH/KjR6W8?=
 =?us-ascii?Q?JqO2eHEdOptclGqNCZ2ka87aJ5cfXxPZB26ROM6oOO8np5uURxGtZ/HxHbm8?=
 =?us-ascii?Q?i4glGgDbB4AfgzgEBPV//rWVKyR9m+SYy6qfj8jp0uYBsZV4CLJTdm9IAo5P?=
 =?us-ascii?Q?pr0ya7aQ5+NSaqi+VY/VtzjaNDECKp32L1FVsbfFG/w7lh2iUA8RV3dEvjZZ?=
 =?us-ascii?Q?wbVWXsCoyS/BVG0bbWlNep+gHH88fOMDaDav/Dv5/s/WfSnLZKDIYe/CejDj?=
 =?us-ascii?Q?ZCKWeNOHcmqJ/OzKj1fcEsn2f1xB69LsnUNVaxzD1vbXs4LddFC+ENWbSJXl?=
 =?us-ascii?Q?ai/lJYBx0Fh3w1TVJQFfq0QTv4mXLFZiOPK2MqeDSmRYr5KaFz8DWA+LGmde?=
 =?us-ascii?Q?vFXFQ2wA71mayV7KPGU5vYlpCoJWb1XSoAYXHfNLZv2QxLynensdb7H7di91?=
 =?us-ascii?Q?3CrJ4nVnCSllfeq+SqSrTePe7/HC4tB9asJvaqLFTxiuDfDQj+3ArpqjIDkS?=
 =?us-ascii?Q?2WvFE5XoquwlmFKMFjucIeXkz+EOL1rwUi5xA94Zoah5FwzpJbX595OomIfY?=
 =?us-ascii?Q?LkPGrsVCMfsZtMJp7SrVxnnhzBbuJgFQBjMvcDAEhkz3nyKi+zrnV9sIaHj3?=
 =?us-ascii?Q?qppKHqLarbauXyUw625EHn/Xr3gWsIz1Gqk7rsf+zwMdDvf2RC3807prSXDI?=
 =?us-ascii?Q?VXbkSguwImXskKEU4IyJSxw3EkTrEJ822gJwxbcjvsiPCVcSBGyaojNpK6mk?=
 =?us-ascii?Q?40Yy/+WjohXe+VnuGFg06Pt/MYxGtWSH6o5W0YdN+hbeDZXisPWMSREJF3q1?=
 =?us-ascii?Q?rkssDmiQR1o0B63QjJC+aZ9YYfh3TkkcByVDs3EfctEceJQE3li85tA4rzD6?=
 =?us-ascii?Q?ffgQcBDf4otCL3k/sO74z+jrpjUN3D09VlM71DPhofVyzBDWmkrW2rrLyw?=
 =?us-ascii?Q?=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB6373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5350ae52-890c-4749-9f8a-08dc5fb2a28c
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Apr 2024 14:20:01.5080
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: j/JLtya/aaopytnx/0e2SaMcPtpj7X7cPEYsilRjE4l+hxuMu1UUUqZSDXU9spTiMUP+UtytXObEbl5WKhYVJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5295
X-OriginatorOrg: intel.com

On Thursday, April 18, 2024 9:59 PM, Sean Christopherson wrote:
> On Thu, Apr 18, 2024, Wei W Wang wrote:
> > On Thursday, April 18, 2024 12:27 AM, Sean Christopherson wrote:
> > > On Wed, Apr 17, 2024, Wei Wang wrote:
> > > > Introduces two new macros, KVM_X86_SC() and KVM_X86_SCC(), to
> > > > streamline the usage of KVM_X86_OPS static calls. The current
> > > > implementation of these calls is verbose and can lead to alignment
> > > > challenges due to the two pairs of parentheses. This makes the
> > > > code susceptible to exceeding the "80 columns per single line of co=
de"
> > > > limit as defined in the coding-style document. The two macros are
> > > > added to improve code readability and maintainability, while
> > > > adhering to
> > > the coding style guidelines.
> > >
> > > Heh, I've considered something similar on multiple occasionsi.  Not
> > > because the verbosity bothers me, but because I often search for
> > > exact "word" matches when looking for function usage and the kvm_x86_
> prefix trips me up.
> >
> > Yeah, that's another compelling reason for the improvement.
> >
> > > IIRC, static_call_cond() is essentially dead code, i.e. it's the
> > > exact same as static_call().  I believe there's details buried in a
> > > proposed series to remove it[*].  And to not lead things astray, I
> > > verified that invoking a NULL kvm_x86_op with static_call() does no h=
arm
> (well, doesn't explode at least).
> > >
> > > So if we add wrapper macros, I would be in favor in removing all
> > > static_call_cond() as a prep patch so that we can have a single macro=
.
> >
> > Sounds good. Maybe KVM_X86_OP_OPTIONAL could now also be removed?
>=20
> No, KVM_X86_OP_OPTIONAL() is what allow KVM to WARN if a mandatory
> hook isn't defined.  Without the OPTIONAL and OPTIONAL_RET variants, KVM
> would need to assume every hook is optional, and thus couldn't WARN.

Yes, KVM_X86_OP_OPTIONAL is used to enforce the definition of mandatory hoo=
ks
with WARN_ON(). But the distinction between mandatory and optional hooks
has now become ambiguous. For example, all the hooks, whether defined or
undefined (NULL), are invoked via static_call() without issues now. In some=
 sense,
all hooks could potentially be deemed as optional, and the undefined ones j=
ust lead
to NOOP when unconditionally invoked by the kvm/x86 core code.=20
(the KVM_X86_OP_RET0 is needed)
Would you see any practical issues without that WARN_ON?

