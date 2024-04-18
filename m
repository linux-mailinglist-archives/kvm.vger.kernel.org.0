Return-Path: <kvm+bounces-15053-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 32C388A91B1
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 05:58:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E78FC282577
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 03:58:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3DF453E28;
	Thu, 18 Apr 2024 03:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NjSqBiYs"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DF3714294;
	Thu, 18 Apr 2024 03:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713412682; cv=fail; b=NStJt/dbwSKbvk9kSKS8Qho43tUWs1sRc+kSV9ov5Q58G3jpTeUkHo4UYUYc5FqRv2xoO6pnKJ2t66/QDrSCMABKov0Vs4cOMABVxXp4ElnHN83iMZLFi5GVYEld940PM1T5IPiKAABzCqGSs2kvh/vKP8VPHQnWyXECVKxsKEI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713412682; c=relaxed/simple;
	bh=sUa1vesdvof6lpiVtJ43OWS+3i5KYteaevzkMQ3CTcA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=D9xJQ5VpKWMb9a6w0VwsoRqFIXzTBMPOabIggighJ8XsHeIX4rPsPV/BMWrKInZHh29p4xfpDHKkp6lhauu2fS4b/j2LzZ3VkL6QQLqfnt6vGDX/4XxLgzqDVIFv3TZrl3LrlBUDqpFCrRj/PqVhiqtFk7w2iLFRz+XX4w1ybfg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NjSqBiYs; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713412680; x=1744948680;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=sUa1vesdvof6lpiVtJ43OWS+3i5KYteaevzkMQ3CTcA=;
  b=NjSqBiYsC26iYFb7531PRKHDTDiLmWU9CYrcY+CI4xM3tbP6XQNcPaP3
   xOvu0clSWjpq23wJuEEBqAQ/Xje91uJ2plrxBpbZi3ESZWHDPT0MxT37l
   UNoXqLRdl+kGZgd3xXjD6JrLfG+ycp/pMd/hvZu+EooK1s/hdlnVPMgEZ
   phoBr8La9tXxtBsfEVCYJ67bbj5LGsMKGdqsFbLTpEH1wzlCcMdepxzi/
   ms+q0UftzcwzadHJFlDJPz7aTCk7IrAIgDerSwse+FC5BUonkv46SD0af
   DHhNEQyRjqddY6hZwaNa+1MZPEt1FSFtuwDc2aukoVwSNnQziOFaWxmEd
   Q==;
X-CSE-ConnectionGUID: W/7jePzdSmW4MgRQDnXmyg==
X-CSE-MsgGUID: HZahic0xRM2EkgD8B/MbSw==
X-IronPort-AV: E=McAfee;i="6600,9927,11047"; a="26396471"
X-IronPort-AV: E=Sophos;i="6.07,211,1708416000"; 
   d="scan'208";a="26396471"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2024 20:58:00 -0700
X-CSE-ConnectionGUID: 2kTBNt1TQQOAPr1Ea0Pg3Q==
X-CSE-MsgGUID: +BLd3OQaR/OR9zu+Yzsd3w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,211,1708416000"; 
   d="scan'208";a="27499442"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 17 Apr 2024 20:57:59 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 17 Apr 2024 20:57:58 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 17 Apr 2024 20:57:58 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 17 Apr 2024 20:57:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VN5SpZWBY4DWUyyzB+OKXNpIQxOWa+2t3R4N6kT5sXUXTD2rxKO6QwyUvXbGbvA5JnEvCN+yWE89SiUAEkHxWyPktr5Uc0AhTOyTb4oNYA+h5GGldNtWyGf8R/5DIH+tiEDO+P1pflcSjyTAUeqT9pSgAPZrDRdIXT3BgjD0iDxSs5NoQUnv5qcgAdtVcLocm7cA6hTi568wRTJls94wWPmvOoHOhnLPwlWO2qKMMa4HCQ8iZ6LTgzAIU+Zc7935rvxkTpMAyCvtjTdEdZDi+eewAwZlRBa8JRtDmmtP0mD3HHfj4ofrDw2qb5fCXE9B1LtyY84ySTUwe8XA6qbzrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XFGZlhqZ5sd5Y4+PaXUeKSLti7hfU2pE1TpcbuWD/Kw=;
 b=M1FYTCsiiChEBNgjmCpI5GEqR1G+kI9ppUAU4nKhruMAVCjtzLONhvj1EUNJxQTzDnlivZW4e+2YwgqrRoShJJtjpMF++G7aifpC3q2f3q+SdoHwCDjquDfRv4vl49o7FxHxgKLzxcTbKZMn/cuPVtnWIyo6WoI0W+Pn9Bsn1z2amg0OVLtMtMuSnqtXXllv383xM1xfuC/kf58wnOsaCdYaNk2q/s53kjQ4SnrMSN0zBABOLR+qeBHhQTS00g8giPJLEkUSb8v1lRAEUZ/czVbooWlGLoq659rBcr78t6x9hnwx3FvP1m9ChaUPUa/QNHfMtJhEajkRcDGfWZI0rQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB6373.namprd11.prod.outlook.com (2603:10b6:8:cb::20) by
 DM4PR11MB7205.namprd11.prod.outlook.com (2603:10b6:8:113::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7472.39; Thu, 18 Apr 2024 03:57:52 +0000
Received: from DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::55de:b95:2c83:7e6c]) by DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::55de:b95:2c83:7e6c%7]) with mapi id 15.20.7519.010; Thu, 18 Apr 2024
 03:57:52 +0000
From: "Wang, Wei W" <wei.w.wang@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [RFC PATCH v1] KVM: x86: Introduce macros to simplify KVM_X86_OPS
 static calls
Thread-Topic: [RFC PATCH v1] KVM: x86: Introduce macros to simplify
 KVM_X86_OPS static calls
Thread-Index: AQHakNiYqtvKEMFbS0SvTLh/C3Jv+7FsplwAgACN6vA=
Date: Thu, 18 Apr 2024 03:57:52 +0000
Message-ID: <DS0PR11MB63739BE4347EC6369ED22EBADC0E2@DS0PR11MB6373.namprd11.prod.outlook.com>
References: <20240417150354.275353-1-wei.w.wang@intel.com>
 <Zh_4QN7eFxyu9hgA@google.com>
In-Reply-To: <Zh_4QN7eFxyu9hgA@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB6373:EE_|DM4PR11MB7205:EE_
x-ms-office365-filtering-correlation-id: 9d371ba2-9a93-40c7-f111-08dc5f5bb879
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /XcFNgVHza0ACS6FtKJqlPr15lPMBdbHnZ+Y154HZe18zsgAdCpnA1cuIc2+QJzePp5Uum2GKPIRQIauAs5QYT2DpXI/Ng20t/WlV2jLp67vhiLpJpKCZxvpReyArIk7lsh3EwG0S86SjC0uMD9qOUiLl+vIVQ1ZdwbWXC+s9Z+7gKmIqnJv5BSCaHHid2P0As8J8IjooDGizL2Yo+LykVdyDLz6IBaUYgUxUGcEwddnMcu+8dA3JG6ty7YlwAGQQARvH6CaLfvhxQF9G45OUTw1NlBFZykgjogVpPkXEpyY7u9l3F4VJ1JT0VIjfvaCn2zFjgFF3BA5gGVm6c/o3m3DSDU8ObgyWCpEhznklUMNRmdrELxyCxjBA3yjC3piBVh3n81g2+z9j+xRLkSR74vQaXASPd5/WhGPtkwVEUwmU+iO4c24PNM6iRaI4kdTVBsBDwT/HGUpmc7dNhDJPYXWczZYgom4uFIoN1uPVqohs6XkoQm6fXZVJYWH0H4Gl69kx08sW3+zZFCcIbNkZQfzmXOrrKwkkWR9w9SrYko+ogW+nO9dNOPIIKWJ24tB4DXUIW7THHVol2YthuQDqvJzeO3Le0Kh9Cf+jm8vb6F+RNtMPfupZ6cH2Xy1XTKuUBW3N0AZnGxBLFi3DoQeHZ4FFRz21aPFeN7w8lz0XIPyDem9iGw6f3vl/99IVxE2HJRYeSMZbulErP0ALPdY5Q3O4fza1K+iuMk8/4Tmahc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?9vx2iKA7kZewbt5cDRo6nL4SZw0rnEhGPGwtHXiDNnB1M1QCXu/o/de0G/bj?=
 =?us-ascii?Q?noo4bmKbCxINFdTCOEGcg0MEN23xXxFl40fWcSFJ2zVS2cTcaN9cPH2QirK4?=
 =?us-ascii?Q?yWJmFjspPnnAj6b+yn0qjXdnSWL1poCrWddr3Njsm/hDctL1vwfLtEnVCPbS?=
 =?us-ascii?Q?nWcx18docBlNZ2ntsbzk3v4vLkaw0LEUgtgo0Pg/UjmO6uYOHpvUEF202A73?=
 =?us-ascii?Q?5QksWOojVvxVgdkR8VNlCzU3wWNs5if6zbDTwIL8CqA/R7wuCwHiOygu+sAo?=
 =?us-ascii?Q?c4J4ZO2+C4Gp1t2fwZRJcZ9aGcSjclx3H5CR89KNwfQZrottC3ZtP3IZRT0U?=
 =?us-ascii?Q?eQ6hDxTVkH223K8zaHFmBOgqYGZ6dHIGTxJJmPcUHBwNMTfsL4ctM8qnzApG?=
 =?us-ascii?Q?EkVoh3AIHTiKbsyiiDQbruxMutRBOTx2N1TMqBru4PY1JiMrhC77ntGajmB3?=
 =?us-ascii?Q?1iuuAi7CphKfvZboXiFrEz0typEKBFPa2gPXQN/SFyplXw6LAU7QDsYTJlqT?=
 =?us-ascii?Q?r6lf282xyxqBBHJSHealRvVUjgLpjF2dfdvU4/TgEWktcvet7Mv+oycAi5Yi?=
 =?us-ascii?Q?2b6LNu+RNwObMElpu+CV06klZehVn2Nq70PjUXAYvUuBZ+21y8GUD4rGPdXf?=
 =?us-ascii?Q?vXQX3qq4mPPFB3S8qY69hplSDkTmmeiJ8j4rMwlw1+fA/PADKw1w5OGL15uT?=
 =?us-ascii?Q?K37W5XC4q7DNsJQIjVAGsJTGh1SqeK2mGj9hPJYGL0ttIoMkbU+j1eOXLCF9?=
 =?us-ascii?Q?41BgtdNoSniTDR+gqmigdW8kFzOJPF5Pxn8yBVWCarR0x54NHz6s/b5N/v3c?=
 =?us-ascii?Q?RA6GdVq9tThBL6FHXcYsvyZ9JQlCxz4cQcv7liM8MetYxwyF15a649iHvOPE?=
 =?us-ascii?Q?XC65DG9jjWqhKpBoYX3n3hpWiu/zDz6uAI+ndh7E417yDJccirBVoJ409Tkd?=
 =?us-ascii?Q?HgJGx0wUfM8fI9uV/WGfKXp+B6+CgxNeFUtOvwIV1kbujmpY9MSfzhgnobJ4?=
 =?us-ascii?Q?3oeR7NSvdFkrE4z2zpKimjcoVxLWFPiF7c+v/T2ESp0zt/WS7j6fv/EAJyec?=
 =?us-ascii?Q?KCgVTu7bDeYI03vftDIn97fITQPaxvRriSXjhjTOy7mrZboPa8sZVrj9iP9P?=
 =?us-ascii?Q?zcZ3MgppK+JOFtF2yhbQcHOm8cghXUKHi5yYmwY0exO2KwSqABsE6kGdtJKD?=
 =?us-ascii?Q?SA6aRrS8zdkOVpRWKvyrhasWyU+vL+J1AwH+NK3CKgi5qzSkZJAk5kSH9aCI?=
 =?us-ascii?Q?b2rJsidD+i0yrfE6dShJmuro+yItUF9DEXaYsXlC13Aujedfn5ruz3XWBjQB?=
 =?us-ascii?Q?5e4clZHO6hF19GW6cTN6cA+4mFBFWHEN60Qp6k/LYb7Wlquhp7j63mzCchht?=
 =?us-ascii?Q?4Rm051KHJrD8KVn//ijPJ7Oy0C1Xw+LuQE0UQuY+rjeFa/fBphLBQpoEw3Cm?=
 =?us-ascii?Q?i8pMlD+PfZiTiaqRCIUTLh9EM5jKmH73vCLdchg99dCBCSiyJ7G3QM3aDsOA?=
 =?us-ascii?Q?ecH6Fbxv+IbYyuyiwqaVMBUG1NAvZnfiSzs4yuE4cVXay/Mxk/Syo9KtyQ?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d371ba2-9a93-40c7-f111-08dc5f5bb879
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Apr 2024 03:57:52.1118
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: k3Ex2gTcq7tdum1hPW4dOfeqb8ML9pXp7Mcm3EUTdH3MU52nKy3xVb4lKKqpJqLb39sC41RDPbzR+TU1NZ47Xg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7205
X-OriginatorOrg: intel.com

On Thursday, April 18, 2024 12:27 AM, Sean Christopherson wrote:
> On Wed, Apr 17, 2024, Wei Wang wrote:
> > Introduces two new macros, KVM_X86_SC() and KVM_X86_SCC(), to
> > streamline the usage of KVM_X86_OPS static calls. The current
> > implementation of these calls is verbose and can lead to alignment
> > challenges due to the two pairs of parentheses. This makes the code
> > susceptible to exceeding the "80 columns per single line of code"
> > limit as defined in the coding-style document. The two macros are
> > added to improve code readability and maintainability, while adhering t=
o
> the coding style guidelines.
>=20
> Heh, I've considered something similar on multiple occasionsi.  Not becau=
se
> the verbosity bothers me, but because I often search for exact "word" mat=
ches
> when looking for function usage and the kvm_x86_ prefix trips me up.

Yeah, that's another compelling reason for the improvement.

> IIRC, static_call_cond() is essentially dead code, i.e. it's the exact sa=
me as
> static_call().  I believe there's details buried in a proposed series to =
remove
> it[*].  And to not lead things astray, I verified that invoking a NULL kv=
m_x86_op
> with static_call() does no harm (well, doesn't explode at least).
>=20
> So if we add wrapper macros, I would be in favor in removing all
> static_call_cond() as a prep patch so that we can have a single macro.

Sounds good. Maybe KVM_X86_OP_OPTIONAL could now also be removed?=20


> kvm_ops_update() already WARNs if a mandatory hook isn't defined, so doin=
g
> more checks at runtime wouldn't provide any value.

>=20
> As for the name, what about KVM_X86_CALL() instead of KVM_X86_SC()?  Two
> extra characters, but should make it much more obvious what's going on fo=
r
> readers that aren't familiar with the infrastructure.

I thought the macro definition is quite intuitive and those encountering it=
 for the
first time could get familiar with it easily from the definition.
Similarly, KVM_X86_CALL() is fine to me, despite the fact that it doesn't e=
xplicitly
denote "static" calls.

>=20
> And I bet we can get away with KVM_PMU_CALL() for the PMU hooks.

Yes, this can be covered as well.

