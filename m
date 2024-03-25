Return-Path: <kvm+bounces-12565-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 508AA88A27C
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 14:38:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D30A61F2BF34
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 13:38:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15B0E1411F6;
	Mon, 25 Mar 2024 10:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HnxCLs9U"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7548F15CD41;
	Mon, 25 Mar 2024 08:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711353754; cv=fail; b=pB+w9rNqYq8SLMed9yyf3i9lJYFApgUvzv6OuUZXZMiQqzqSPVV2dc8Xj1pTWbvXZYpZVAG0nvnMJDqedIRgJQLVnS0kOZmEqXo/iwJAsom2seV9BXc29VaU2Xa9y2csC7el8XXFADRyaxRSYaA1HHEknvwi40hl5j5fiOCzdW0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711353754; c=relaxed/simple;
	bh=u3labdVuCyIxtPl/SeD1H8bExIIBXWqgn7GZ1L5leKc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=CtnN/cB1glCXwOWxx7UO0niy/9eHd46B9T3YUMTa0nCYpn8jVPQ2JKdDwGUu7Sg2goEwTzagoGLrqPcF90DcWBdp1hvPIf+S0Cz2DweH8Pi5pIdjHxT22wFiqRQDrpdtGslhFiaxq/uD2mLIZjjcv2MZ+Jp5HcsA1mkqHM2mdVA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HnxCLs9U; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711353753; x=1742889753;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=u3labdVuCyIxtPl/SeD1H8bExIIBXWqgn7GZ1L5leKc=;
  b=HnxCLs9URYvYowjqmUnt6AkQrTyj/7bdOvJHhKbkoThHkhWuhLJCnk1s
   wC/DlisaHE/uga2VS2mstSc+sNucR82gm1RtV/SU1PlYGBNJs3Av50wcx
   W74OPPE5IYdOUr7MR49WWfFSn7ETt7dyOQcolQ3Ogd93WC3RUu/qntnOy
   /lXBfa2kLBqmtqdrE4O0fYA5alOtz49CX9qbNLA8YcFl3NZxT5KeIbdhc
   aN2CVcZfl0FNd01l8zVzEItB6AeiPWEL9AyJS1ienmpcJ+tKxRIIxHdR3
   il77IZyUlyy2gBP1bgISWbKa4gnoOCMRUdSfRG0/tb4e2EvJWRTkXqiqU
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11023"; a="9298863"
X-IronPort-AV: E=Sophos;i="6.07,152,1708416000"; 
   d="scan'208";a="9298863"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2024 01:02:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,152,1708416000"; 
   d="scan'208";a="15413051"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Mar 2024 01:02:31 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 25 Mar 2024 01:02:29 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 25 Mar 2024 01:02:29 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 25 Mar 2024 01:02:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YanjN15O8SdXz1O0/ceAr56LTRg3gWbQTsH4wGrQD4tXShBzqZk1VPyqFyRHaGiuPTgmB9lOJe8WgeD7aTu/pTj4Ynv8c7hBug2e6ep0DeA00/i4WMlL8vrdIk/NHSkESGVJ/HuGQ5t440ZKgOb3Gx6+Zto1JiSEEI+mw20f77z57cpiYeSdXaDzITiR2CAuOEwNdzv5gXX2K+X56VMn6K8ruSn+1DYhoyjF5KbZLpz/BtPX/3ylnTvFTLPEjpZrnc5G68f3pfpINqU8GxoscKyeJkf6N4bivPXMjHq4JiPENQQcdXL8fXIhNRRFsuDc6m47/SzwRJzL92TctUPf/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u3labdVuCyIxtPl/SeD1H8bExIIBXWqgn7GZ1L5leKc=;
 b=GkRe+ZkOE78M0sGUNSDV/Mia4RKqltsTRBvD8QxYv6ky0Jy+Kd9VbaRcHBKVolpYSo27hX1yUt9oJ7M5lLSah2vC0ac+ldW8kW7e18FVKv7R6vzDXTOMG1SfDuIpvdrTC2079RVsATCsLLrVxPMB4whA2NfSJG2TkXNrZFDWuoVV3U1PLFwe1+TFYj7EZbrZKEGyiT3ijA4V0qN0ylLIOKY8eOuTQ0GKo4Mq2JN5z0eIChQH+J9u1D7HuifQZ18qGRs3vL52Cn55Ga8Dqi3RODyYrOkecN8S7Nv18ipuNYmaUsh/KTqEk92h0r3oX+kU9SoWRPXd2Zvy49Neptvmsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ0PR11MB5940.namprd11.prod.outlook.com (2603:10b6:a03:42f::18)
 by DM4PR11MB5326.namprd11.prod.outlook.com (2603:10b6:5:391::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.31; Mon, 25 Mar
 2024 08:02:27 +0000
Received: from SJ0PR11MB5940.namprd11.prod.outlook.com
 ([fe80::75d7:cfc7:3a4e:e4]) by SJ0PR11MB5940.namprd11.prod.outlook.com
 ([fe80::75d7:cfc7:3a4e:e4%6]) with mapi id 15.20.7409.010; Mon, 25 Mar 2024
 08:02:27 +0000
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
Thread-Index: AQHafFn+Bj7vmpQOcEW/PEjFxiybeLFIBhdAgAAFj6A=
Date: Mon, 25 Mar 2024 08:02:27 +0000
Message-ID: <SJ0PR11MB59405AEB55E33367E5104C0386362@SJ0PR11MB5940.namprd11.prod.outlook.com>
References: <20240309010929.1403984-1-seanjc@google.com>
 <Zf2CvBs7R3KN6rIl@yzhao56-desk.sh.intel.com>
 <SJ0PR11MB594067997E7879AF927F264686362@SJ0PR11MB5940.namprd11.prod.outlook.com>
In-Reply-To: <SJ0PR11MB594067997E7879AF927F264686362@SJ0PR11MB5940.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5940:EE_|DM4PR11MB5326:EE_
x-ms-office365-filtering-correlation-id: 82b8fc8c-7476-425d-e0f8-08dc4ca1e9fa
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GxiSnIz9S5elinYhI0TkLd9u/RTPS4x5Iac7idYt4zSrcpdZ+3oyBnKjv71hUT6NRXmKJEMLpMIvjsXXn94UFtuDWX2zxhig2xG2qbmTeCX/gUoi+IrRlWm/MPYHuk8GzEEql0cK9Vpu0Y9efe2LiZxGwIOPkart9EcqFGdQmaaiXnft5evssYjqxMVy6KZxyisjK0LXlImvicQbEuGVHzbTZ+YrYMZl9eAuxDvKohOBI/s0av/CBxOy4i8GCaA2YTcR8N7hH/zJY6LTq8flHE47VDK+84HXLeb+fmf9dM83jEe3GMMuGOGl+i75I+MPPRj6UIeDYGKTK0JUM81s8nq/v1vZSF8cgRuncRCMijdma0P7G7fpteTipIkNvxu++RGM6jtE8JH5Dyu4dO3ZuSqsZxvkt3poUwSh+J8LP+yli2N/ZQh+OwInV8OBRyyuqV3EhSo781XuIIibjia5YHGFuEYTiDj9DCOxNK0EzIGPqw5+dmOY5RikC1QkddzdXk7LU8sOXdevgLShw0OeW/tXUlBPu+EOf4YPykhUeoC52e3904E/f2BY6ICeKwieokGAwI66xCUzz+mSO3CSyM6P8pWTgPUkvTmumol7L/myE3O5XE0I6p3y0OXOWVvU9dbckaHKYGSNuE0xk3hmFsxb+XFGZqOAmvVDkcg6fe8lIsnGltE0zQ8ZSEFNVeBzHxQJlQK2cDDFmfpDnj47xQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5940.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?bl9hpmbs73s4suEElFpYF9ZpUWkGToCqiF5f0joDifKhDKypIHyZYwjBQ1gZ?=
 =?us-ascii?Q?sz7b/Bf09QaJri+M8wFILKyxUsgzjabHgvUmocP6XLfrtFXdGwKPQkDLQ8z0?=
 =?us-ascii?Q?tqTk0A8FBhR5iPSVQRy0+25u9Ae4SKt6x0OH8aWMbbEBDlATeZU4WKvn1Hrz?=
 =?us-ascii?Q?iM4Avz3PeR2wuolKceAWKCZubtiLcNOqBefArQqpbLjndLQO6n3XbTQ5TnIQ?=
 =?us-ascii?Q?OHeMmpg5O+FWUn8mro8O+SRNpiTh974BLWeJeIlVTBBsOe7yrra1BXmf/yVs?=
 =?us-ascii?Q?UrY2eA1E5D7zFZlsyGErwsWU3Qip4zq4FyPFyl1phyTXLYO11JDWY4DTcLaX?=
 =?us-ascii?Q?cZok/1l3n8hMaERto/CLP2d4TA1Q28ycF2zZl/NpQdlgDf4+5oqmpjb5NI25?=
 =?us-ascii?Q?UoKtYsR4UkgrWQ/S89TJ4+eYD0r7LUWzS1TgA6udoT08isYAS+Lt4OjQtncy?=
 =?us-ascii?Q?VZLElJ4YtDDvaOtH4VFCAA/hQBBH04dxDfF8m8SkikJVUD+InkDvFx1/bNr0?=
 =?us-ascii?Q?yKJUAGWspzrtvtIdOXzvmxWAefzv4tnck6nMvfi410CfiVZMqnaHHVYW7Oiy?=
 =?us-ascii?Q?7jS0voUQWpbzrxDCB2k9otW+44vd0ogN5hhu1/wFG3JuSg3Gs8e2a7LPR3Lv?=
 =?us-ascii?Q?vpG+53m0aNOlZTQE3cOGOcrxWYknMr4hj90NgVceHAWLmj96WbQze19zB5Fd?=
 =?us-ascii?Q?Fpm1hKMElMJcAxbCYX9E6sHNtvU1tnqUvBzvyowL3RXwEATQiA8WjhZv3yQd?=
 =?us-ascii?Q?S5ajU1futrewKCMsoNVYoTUaWyhKNYrLrZ724QyjEJajh34PEUqE6oID+Uma?=
 =?us-ascii?Q?WCIDq7ZUWw5oDLVZWpwURiSmopj0tk8/uh3V1DyAV8GZXajDPnmenrTag6lT?=
 =?us-ascii?Q?nBvQQIjoqG7/+jpOo9S2XE0IqV5sy9XUe2H6Rgv70ReSUjsrNy/YEtQYuiTI?=
 =?us-ascii?Q?5uAh70cSRiSokmOBCctkyN4RDTR339FECaUUDDtWM+gfIxjK0H7CVqJuPHSH?=
 =?us-ascii?Q?vygYUvfWYzhyUgylNGG46b8iek7kARKu/UtMPCAIS+67lyYpdfJhyyOM20GS?=
 =?us-ascii?Q?nnQICaD8B4wSIPLZ1vLxv0mc7zmqc2XMmB2wtaQ3e7CMmhP/ud5mtB0mxp0l?=
 =?us-ascii?Q?Ls8Hd0+IzM56VAgqiQyvBc2A+gtSgF077moOYk4BxTZYkNSUL89GqEvfmOnB?=
 =?us-ascii?Q?AjUGQbIn1NcmL4VKWPvDlPwtR+R6cDI7CqsLDaQoBywhdrM/zKRs/Q8MqXWx?=
 =?us-ascii?Q?6V9mRY98W7wdhj7vtYkaDGYVk/WdmKLYYsHbq40mEfVLfiVZJnkQ4stAmF+W?=
 =?us-ascii?Q?XXvC1WeA/uvMUy843pOxE0peYH+pAhFiiR93Wl+aoEt9GlfvPE81ClkY1X07?=
 =?us-ascii?Q?5O+cx4XJU7TBNBndxPXVCnOmi8SrekzOvO5891D6WG4JCZi/H9v/DyTktHTp?=
 =?us-ascii?Q?UwqeW1yHblPiGGvy8FmbXXLEqcFl0Ii+QuvehfwO7tkIivVyHWj1Uvo8QauZ?=
 =?us-ascii?Q?LQvSBw7V8JR/xj9URv2jXMzmeHckKhQ28/adZJqGHW1TsjSZFDYQe3EpqXeE?=
 =?us-ascii?Q?J8+6RAPB9FXXbkoPMytNxhRmbnWsnyNEyaSJO1f3?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 82b8fc8c-7476-425d-e0f8-08dc4ca1e9fa
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Mar 2024 08:02:27.8286
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tXirRVpem8lqz6GSNthPvFcHErefwnpKZpegrxM6rVojA6MTME9XPCOgxrjQDQJWrMQkzsOGU+F42V22tH6zNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5326
X-OriginatorOrg: intel.com


Tested-by: Xiangfei Ma <xiangfeix.ma@intel.com>

Testing environment is based on the EMR-2S3 platform + CentOS 9(kernel vers=
ion: 6.8.0-rc4).
Test cases include cpu, amx, umip, ptvmx, IPIv, vtd, PMU, SGX, kmv-unit-tes=
ts, kvm selftests, etc. And workload test on the guest using Netperf(bridge=
) and SPECJBB(passthrough NIC).
Except for the known issue and the previously mentioned "rdtsc_vmexit_diff_=
test", no other issue found.

-----Original Message-----
From: Ma, XiangfeiX=20
Sent: Monday, March 25, 2024 2:56 PM
To: Zhao, Yan Y <yan.y.zhao@intel.com>; Sean Christopherson <seanjc@google.=
com>; Hao, Xudong <xudong.hao@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>; Lai Jiangshan <jiangshanlai@gmail.=
com>; Paul E. McKenney <paulmck@kernel.org>; Josh Triplett <josh@joshtriple=
tt.org>; kvm@vger.kernel.org; rcu@vger.kernel.org; linux-kernel@vger.kernel=
.org; Tian, Kevin <kevin.tian@intel.com>; Yiwei Zhang <zzyiwei@google.com>
Subject: RE: [PATCH 0/5] KVM: VMX: Drop MTRR virtualization, honor guest PA=
T

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


