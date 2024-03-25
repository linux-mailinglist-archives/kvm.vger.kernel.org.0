Return-Path: <kvm+bounces-12564-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3AEA088A10B
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 14:10:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A60EB1F38993
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 13:10:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A87713BC05;
	Mon, 25 Mar 2024 09:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FOxupBoe"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20B17172BC7;
	Mon, 25 Mar 2024 06:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711349796; cv=fail; b=L5XDTZSXn8PY1HwnhkQ6OU5sE3RJZJlkKrt63i/XoMRy9msNEukq5EQv/5ef76i/4LudR5iA6gYCxpqjB0mmbxzxq1MhqJUuf36vbcf78V75tVQKCcZfXxi8nE0q6Pkiwj2S+zyGaySFWnTgpeRmFcprl2dmpiwxgppyLbyd6Ag=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711349796; c=relaxed/simple;
	bh=OJcwTtETaJScdIfvwVDZAr3xv0DpucZFhmsu+BP8VRA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YvL7uKRBpjU9dhb4dZerzivCujoqEpCnwZCd+q6BZ0PEVnvVeKFH8OLnqLIB+o5hOuvPkbgXjYi4u1BmpHgvjZJ2TYJFSxoc9hxQJksHzrsUB8T9HEeWnzSMKb8iF3k6T59gxB6B8Cwz2LTzGKGV3gS0Zgiy0CgUmRFrIbrjHMY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FOxupBoe; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711349794; x=1742885794;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=OJcwTtETaJScdIfvwVDZAr3xv0DpucZFhmsu+BP8VRA=;
  b=FOxupBoeSUREUwdCSsqwuDOQWWGwv8k8V0PzXtPtCoorZ4w7jPkJCfpJ
   +F5/d9fdr5d5GDErXXBYv72xfJO0404n5gP6NgeOsPHD8sPgK8Yrx6pIP
   IXcKiZ5dAddkPZnXCCxteah9yq4BNTx8yiRFoH5nsYMIWSXgW8fc9PMuE
   D7yWKi7KbzPBpd5IS1NIejNTS9kIeUY1BMrTgJYYIxetBGy4MeiViFXQk
   RToTfDRGv7SYXzMid5+jZE0WupSkj3oeM4VJ+JLxyOjvAKUoWetv9PJP9
   OHVcV7WYzeEHbKBf5hP4eFEoDjAu/cZxb+i70P+j2WQi1S2UNBDjvimNT
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11023"; a="6164662"
X-IronPort-AV: E=Sophos;i="6.07,152,1708416000"; 
   d="scan'208";a="6164662"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2024 23:56:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,152,1708416000"; 
   d="scan'208";a="52989718"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 24 Mar 2024 23:56:31 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sun, 24 Mar 2024 23:56:30 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Sun, 24 Mar 2024 23:56:30 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.41) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Sun, 24 Mar 2024 23:56:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YKGS+yjYhfh0JvyZlTADuXPBFWmESgR4G9ZfSNWggooilxQvXiIjQZUog8G6rY8K1l1/rBtA48ZH0/YqL3mHO8wZq3alAx81cOdYX0SCkx3eYqsc5L2j3vr4Z59kAF7quDwCn3vOmgIEH78i4qKDwkqC1Il6c7Qafa/SEH0KJhEt3B3s9QY3QWv9V9myOxbvFvzMGL7IMz+CSyHIVeKBXv0AEzj1G3WjROZm7loUUEHstCbbbDruPP89vUL7omfvUyAtf+4Vwa3fAYJyg/kyMBJWINdRGKwm3NMdu9vZWh0smgoLz/m8QxTJ/5/laoyObFAs+s82V1lwfnH0zIg0AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OJcwTtETaJScdIfvwVDZAr3xv0DpucZFhmsu+BP8VRA=;
 b=kLruJuUywtKLuzl5GOpHqGvbvBhKWCL5zsVxFfbb9AzRQylysd82Po3egPjCrVMnbozBIzrgqI1IXS66TAdGlrOZZRkD/E5kqHOCGoZLQZ9LVeU3HqUDcpAF1CEiMlccYkfyd8C5VMo0nDlQs2j1DxYRc7G3oUigiuzyjnPODDluKHfzmVP+rSwrOj+/UdaP6bkXmN1TRsj1X/ZKhEoge3HrhAkGZVz0LFXLHxrBlZz01jSq4O5XsQD7EPHUNaVZWf7JqXkyOyiqkYDEm6dpwGPbvC/LUQiyhLIz7CuF4n8yaBu2e/0uC3r0Poyd+npfUndxqn9Uv7YS7KzPRbjTdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ0PR11MB5940.namprd11.prod.outlook.com (2603:10b6:a03:42f::18)
 by DM4PR11MB6359.namprd11.prod.outlook.com (2603:10b6:8:b9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.31; Mon, 25 Mar
 2024 06:56:28 +0000
Received: from SJ0PR11MB5940.namprd11.prod.outlook.com
 ([fe80::75d7:cfc7:3a4e:e4]) by SJ0PR11MB5940.namprd11.prod.outlook.com
 ([fe80::75d7:cfc7:3a4e:e4%6]) with mapi id 15.20.7409.010; Mon, 25 Mar 2024
 06:56:28 +0000
From: "Ma, XiangfeiX" <xiangfeix.ma@intel.com>
To: "Zhao, Yan Y" <yan.y.zhao@intel.com>, Sean Christopherson
	<seanjc@google.com>, "Hao, Xudong" <xudong.hao@intel.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, Lai Jiangshan
	<jiangshanlai@gmail.com>, "Paul E. McKenney" <paulmck@kernel.org>, "Josh
 Triplett" <josh@joshtriplett.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "rcu@vger.kernel.org" <rcu@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Tian, Kevin"
	<kevin.tian@intel.com>, Yiwei Zhang <zzyiwei@google.com>
Subject: RE: [PATCH 0/5] KVM: VMX: Drop MTRR virtualization, honor guest PAT
Thread-Topic: [PATCH 0/5] KVM: VMX: Drop MTRR virtualization, honor guest PAT
Thread-Index: AQHafFn+Bj7vmpQOcEW/PEjFxiybeLFIBhdA
Date: Mon, 25 Mar 2024 06:56:28 +0000
Message-ID: <SJ0PR11MB594067997E7879AF927F264686362@SJ0PR11MB5940.namprd11.prod.outlook.com>
References: <20240309010929.1403984-1-seanjc@google.com>
 <Zf2CvBs7R3KN6rIl@yzhao56-desk.sh.intel.com>
In-Reply-To: <Zf2CvBs7R3KN6rIl@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5940:EE_|DM4PR11MB6359:EE_
x-ms-office365-filtering-correlation-id: 6bdfe4da-ab04-4527-7133-08dc4c98b238
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Fcl8hRA+xrOPZoakCheXpJo9hOyqhDpXtmFXlPR3lKziGgNFVfv7Hv55k/fp2e/AseRvhWvRqd241h5EuzRJh8hSY2Oum2T9Ou9AXgbebc45IYyoVP1D/b8+CFzEbRZGUzTDovy8kThFhzeWJ+WtfccaEVJPd7gVrGdqCZvwlKEU7E/PsUvIf41x4l4NbnHVIP+NKmB8ozrdxqNvMeRHwYqqk94hbKjqKW5qsyymSgkpPOMnYCRANKq9jE6IgzAhKxf7PcdYfCHZOM8W0qBqtGLpMjrdPXHGnJ0vuAOcsZQnDreZczHIUjeHUmVdNqj7Ma2/Q/5+lwdceVQTkPQgbPLDYEtlOHiQCQFp4uRdLGe/OojngImgLV294X+RcJThEPV+6ENsLgxnmQ56KtyVxfGUDSCttGYKxlSdZQr5pHXGal5ZgeOgBMod45rl14V2uFeieaWSpNRqaYJFyAzVN2RNi8pznyX8MnngM3Ifdas4DOYt9nziIKFfFN9enRrKR/+qFW2OcS7q+JiQDNeIaat9urhrkfbgTu3u/+b/l7ee49RPCU5byfIkxGJRWHcVH87MPW2Y6iBRmY5vUk8AX2nec0lvoAdr8hKPkrt3V0ZOrhepSs9CIsn6fPdRAEyH1cr0aFiKE0NOHAca3cZl2WwVBeZk/5yzeuUxYZyUt48y4km1oJIg6P8kOhYG1DIQMjzcEnpf1drsbJYKGdidZwNRhKeLOiATqB4RHafyoHk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5940.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?niQTogIDPGg2P70PMJEzcjcI99V8j8XS9QA2mmOe4wt1rPytBb6KuTxS9lrP?=
 =?us-ascii?Q?G80WUdn0u6xOVG+yDYQ/L625q3zjNz253hDhWV9irgOr4JFTutbhdmxyIMuA?=
 =?us-ascii?Q?XvOkII43TxL0ahGqdio8Kf0TzJITr/M9UMWuVJl0k0nlPU6JpSniFbAxII9+?=
 =?us-ascii?Q?qeh8rq3+REse5KAu4hog2g27yg+O8KwvjUiXKOUqkKt30TzJUVosM6veu1s8?=
 =?us-ascii?Q?ra/67/G9xT4rG62Y43aNJSJy5YC+FDZBDKUEILbv63TazSm+JWCryNBZ9Nww?=
 =?us-ascii?Q?zh/7YuBk/pHmTV/nt2u2Y8EEWoiVVLNVzV9KKbi7mapCoz7YocwrgA8u+5jx?=
 =?us-ascii?Q?jlZaf8vO4oqHiASw+II8r3qlYmf5gpVyj2EWRAxzv3cJsUFYNro+lWPnN/iT?=
 =?us-ascii?Q?J6KF08zOzmFLdeR8KyoG159GUR0LlI59KkEOh195XqamWu6iyH7wAcYc7S57?=
 =?us-ascii?Q?Ijku50mjFzdaxanCxmlcnE0oN1y7dyAXOXlmD8hQqhu2Y7TfxGzy8gilzmtV?=
 =?us-ascii?Q?2H0mLrN3/JUTNbK+VA1/lFyMekoXD8fHp/+rxkqMCgpmpIz+7Y54zY68CYLm?=
 =?us-ascii?Q?0ae0Y8OoRYJWGGQvXZY+EfcNtdcycKHtWg7uESsZHtYID66YTQCpG25fb99B?=
 =?us-ascii?Q?Au/3p8jevfvTM35ph77xk/2gNPVTjD2Y2pyVpEjmWeot1hQ3On9toePhaj9U?=
 =?us-ascii?Q?AecyY8EDdM6ejuA/YjdzybSHQtHtdZ0/bPzLszgr47P3zIlKFOnlEMwgnAMY?=
 =?us-ascii?Q?2vIxtsP9zHtfECeaH/t5UgipyKgC7Vzh1WVVJfZBdW7kcB8HMa6lCJHZlm94?=
 =?us-ascii?Q?Qr8bygM3T6MYKV8Z6T2OYkMBDVIXp3C2FfHG8Jbhb43FtJx7IvGOHAs+72tQ?=
 =?us-ascii?Q?oWhMjDRHXduGQ7bErKA0+HxM6duQ1N4G4t4FaDIUZl1WpXyAQ22cIHbcZUBq?=
 =?us-ascii?Q?JnaxNDzfylu3DKm4MDOug3poP+dfehMGoqHHYIjGvMGWHoODrun9LuDp73R2?=
 =?us-ascii?Q?Y4hp9yDtgpp94H+oTxrm6X/GtZ6+2B5E4YNtH0vWhjCrfJJJ1Oh8SlmIAu0n?=
 =?us-ascii?Q?QdaTg0NHD9uW13WZg2stO0Pz+6/LYYGVG71aMPvwU95M4DeX2SJXf8bowcqU?=
 =?us-ascii?Q?2dLasdl2bIBOALGNqntzS4WPpJFxnMuV1QRPXsbUhsafVqY76K7KIKDoR9n7?=
 =?us-ascii?Q?FP4GjYpFqOuTMB333Zx2v8hk+DqQhM4h0EZ+O0geC8rMZ5XYkE2LOxc4XwmC?=
 =?us-ascii?Q?+7olHxgRQSHnZXaJreYd53ozP8uDqamRpx0zHWHYS/IEUW9SAjCkoZqWFDTc?=
 =?us-ascii?Q?WMCLqY6mqYzNQTHU6MqccKaZzEx645Iw7NZjtF1nkCk8lcANoQDGZZ9vogv9?=
 =?us-ascii?Q?1Hf8+l70cDrUUrOZ/8ExObr2tmlxgeWFnLxXOhZ4uxVSUGLASBa0hQbD5CEe?=
 =?us-ascii?Q?nmT54WCVTWU2J15+tF8FmAUjUeGuNLfZb7QjUUDMZTXWWnK9Zp/yZD48Nlua?=
 =?us-ascii?Q?KuVNl1LgB68ei036WL+4nYz2dysDWZxOL03h415bXBS0ZV84zh6NIaa4SRd5?=
 =?us-ascii?Q?jljdQbzDtkitwNrFuz/K0Z/yF6wUV37j/OBUxgcg?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB5940.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bdfe4da-ab04-4527-7133-08dc4c98b238
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Mar 2024 06:56:28.8523
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0x5HljC8IYZYjC/iTcH2IJoDPJC/c4MbCaLJr/c/5u/nalld3YnIIpkQfzRDyHY7rQspOnRB8HkTwTzobgo6fQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6359
X-OriginatorOrg: intel.com

Tested-by: Xiangfei Ma <xiangfeix.ma@intel.com>

I have verified this method which can solve the issue.

-----Original Message-----
From: Zhao, Yan Y <yan.y.zhao@intel.com>=20
Sent: Friday, March 22, 2024 9:08 PM
To: Sean Christopherson <seanjc@google.com>; Ma, XiangfeiX <xiangfeix.ma@in=
tel.com>; Hao, Xudong <xudong.hao@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>; Lai Jiangshan <jiangshanlai@gmail.=
com>; Paul E. McKenney <paulmck@kernel.org>; Josh Triplett <josh@joshtriple=
tt.org>; kvm@vger.kernel.org; rcu@vger.kernel.org; linux-kernel@vger.kernel=
.org; Tian, Kevin <kevin.tian@intel.com>; Yiwei Zhang <zzyiwei@google.com>
Subject: Re: [PATCH 0/5] KVM: VMX: Drop MTRR virtualization, honor guest PA=
T

Xiangfei found out an failure in kvm unit test rdtsc_vmexit_diff_test with =
below error log:
"FAIL: RDTSC to VM-exit delta too high in 100 of 100 iterations, last =3D 9=
02
FAIL: Guest didn't run to completion."

Fixed it by adding below lines in the unit test rdtsc_vmexit_diff_test befo=
re enter guest in my side.
vmcs_write(HOST_PAT, 0x6);
vmcs_clear_bits(EXI_CONTROLS, EXI_SAVE_PAT); vmcs_set_bits(EXI_CONTROLS, EX=
I_LOAD_PAT);


