Return-Path: <kvm+bounces-39839-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 25081A4B5CA
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 02:26:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AD5D83ACA3E
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 01:26:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0942D13BC3F;
	Mon,  3 Mar 2025 01:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="T+TI8sMm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 303AA800;
	Mon,  3 Mar 2025 01:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740965207; cv=fail; b=krOBWx642Tw3T2KA5UXWesCKCilj3iW2OVDXma80mrjASMA5ix2Qoo87/raI7+5Mj/z/XxT/nu28tbdMbJFYN4IAMG5uTNyCAJKyGUe1sxpeiZp4lQVKGzlU41EzKqqnJG7s/grdUPT1AbrmYimpEBla+mQ2h8piuNJWk3FJwSA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740965207; c=relaxed/simple;
	bh=xYCaFl8gCxRrlLIPPuT3RVVZ++qFMtFJU4L/kpVxPe0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=bl/nnr7QTMk5SkDltfh77f1XUOj80QhbAH/QfhXUFR3Xx87UnZSPM418zgCbHkmlCR6kGLTPb8iKPJ/FY2+NfGHNvR0kXIS5VnVHw6mduL8Y3zF0aMAd3JSzb7JSmGhkE71Wu9LHtD8+SUr3zvTroQ0Pn4hACWzNkkiuOoPOvTs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=T+TI8sMm; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740965205; x=1772501205;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=xYCaFl8gCxRrlLIPPuT3RVVZ++qFMtFJU4L/kpVxPe0=;
  b=T+TI8sMmRB8rBw5dTH3Vy+hpW2bY6lr4XGmBMYbujUMPJ8azK9pQ9tCg
   vibE+cUP4yxct6C5HG3AYJSrFCptraeGuvvN67RbbDrnjevEgkbU0cTid
   wtuDGJx+ZLFJfc/BmEkGi16o4lhwwCh17kfgR4BRI8z5aDPOW0BvnP9Y+
   EapdJpmMVcZVoXZDwNlrjWy5HS2372nHjkbRzoqc7hGu77CYdLD+Iujc4
   5e781WZperLwx4DIFUk3kp1ulyxW6J4F8JWKbmCDSNXQcbxpHHateygC+
   xBFxr5ON03CNT+JKrnjZoeKJXWKIiX9syWSIHZNH71FKv+L0CnaYiJ0IG
   Q==;
X-CSE-ConnectionGUID: MSkl7/4NSbikwW6+FiXC/w==
X-CSE-MsgGUID: mLfWJ6FOSKOzQRsz7Tb87w==
X-IronPort-AV: E=McAfee;i="6700,10204,11361"; a="59371874"
X-IronPort-AV: E=Sophos;i="6.13,328,1732608000"; 
   d="scan'208";a="59371874"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2025 17:26:44 -0800
X-CSE-ConnectionGUID: FkZL8nu9TIuDi6G7QycnIA==
X-CSE-MsgGUID: qxbU+IjpTjmYJRIyV32mjg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,328,1732608000"; 
   d="scan'208";a="118559389"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2025 17:26:43 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Sun, 2 Mar 2025 17:26:42 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Sun, 2 Mar 2025 17:26:42 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.44) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Sun, 2 Mar 2025 17:26:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p4Hlzz6oi9JIT0aSLHwfWNuG9dDERgezVUuxQ45hzjnbpbcA2xRUxEBA0UyGzo6petNa4uv+bmFENaJdmsoGFAJ4gSxpMhMgF5SD06Oy+v8wOSjxe4SRr9Dzza63IuqicyhvxEJZ5KJw4m0zSFlnh4Tle579WBth9dR/hgfVM17g1+VPXvx07k1xYjNEdyKFqSKAAFYDYSm7r33vommzb3S/jLuomaEBbrncHk22Bh0V70CAI7pWUgZSd5DNilSi8BQdJRAD/EijqIcI9eeH2tf95ZMZfhgFRHHUHz7m2DpaXbSMH/o3OvDWriqBFKeU17YRbasof34sSutyVx9mBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zELFZXRLfLVJyw0sDDmIl/9DptRuc9nlFvEH+nNghuk=;
 b=KSNISQWRzwcE0HT1Ler0mNSIpDkhB03cpFiCkxK7a4AK1LMe8pJLUX0Xxm9fA6wmNw/8aBYOKkREAn6EUQWegHLr0gXuFIWCv4LUjNx5YUkJZJi6jkOggqwwLcOpOBLedg2uZESXMYKDly94kEeLocJKwJ1z9N42giJGZvK2QZZFLolIAhKraeb58OMS1RS4e6AeEGa607GzS1grUqKgKH+dnSgZ/ekNJfAlGhXNcHwIv3s1JMrcmpb92szYCainnStxCdiDPFP+9iT/jCViHy/wC0yVAA2g29RAuiQKYJNfF/xgwf73R4lW9R9X8aQe/t9ZnLcyMLg1/f7dBg11gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 IA0PR11MB7188.namprd11.prod.outlook.com (2603:10b6:208:440::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.26; Mon, 3 Mar
 2025 01:26:39 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%4]) with mapi id 15.20.8489.025; Mon, 3 Mar 2025
 01:26:39 +0000
Date: Mon, 3 Mar 2025 09:25:19 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<seanjc@google.com>, Kevin Tian <kevin.tian@intel.com>
Subject: Re: [PATCH 3/4] KVM: x86: Introduce Intel specific quirk
 KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT
Message-ID: <Z8UE/zlXoDO3Civj@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250301073428.2435768-1-pbonzini@redhat.com>
 <20250301073428.2435768-4-pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250301073428.2435768-4-pbonzini@redhat.com>
X-ClientProxiedBy: SG2PR02CA0002.apcprd02.prod.outlook.com
 (2603:1096:3:17::14) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|IA0PR11MB7188:EE_
X-MS-Office365-Filtering-Correlation-Id: ee4aec02-3f4b-47cf-75a1-08dd59f27225
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?L1eombptv0R7Q7TKPCgdbcSDvDlniHCCigOY8xBFMhy4V+hfpiyg3d0KMp6N?=
 =?us-ascii?Q?XJK7+6f5KJW8ybfeQRRLfwg98DYHzor/w6vhcLijOThiK6dHU/xBrZ/bqAAF?=
 =?us-ascii?Q?9XhAotmg+2P00nVEUd+ybmCYO/7Qqpo8d4v1TcDgx26X2MM7e8LW41c6Gl6n?=
 =?us-ascii?Q?RqLk/Hxfla5tyOZr+1eTIO7BewGB33RqCPeXF/M4YIfeIVBVijG/Vp+XzyE5?=
 =?us-ascii?Q?ME1HQY3jrAsRPZF7wkbE4Akb4lsJAli1zrfNSrwVZNB7a2WyhpYNzMOJhcQ+?=
 =?us-ascii?Q?CE31tW68PBHrMZwivfPNI+7OCYBtbhSohC1ieaKMINcwfyOLZZnafKXHAKeG?=
 =?us-ascii?Q?7gwg4sVueyYbAV6OUCY0iCsIiQTWZFM2vvPymOKU2dflmB6a0DFhdcpR1T7e?=
 =?us-ascii?Q?ShlWzOwd7eblskTWL9JW+3rpRq3DsK+ORjgBcoSuVbfGp+f6AHW0HJk/ScfE?=
 =?us-ascii?Q?apMuPzmFXmywxiSd+RjP22MY2hcLeHi1H6MyV76x0YEV0eAO/+T3bHwxaaIQ?=
 =?us-ascii?Q?PhWzaDPk7DE9pDwsPXP1i9vX2cZ2TEB1xHTMo2zBETIEcqx8/lxpapig58PE?=
 =?us-ascii?Q?9b4fNCgRpdGmRCyhEg4wXIKwkj65hYDgSjjdANfXeq5rvtkxRriHuZ5Rry3x?=
 =?us-ascii?Q?mCQ2rc2utJEdkJZt4iNYKRRGUqD3SoVmGZh05OhW1z80VvT1rjj6H6ZQXIam?=
 =?us-ascii?Q?ajxIUWEAoC+2vqELem9Ei+EpIsfS0Sq0AzHopUToUXCjqM6P0Snplpbf2i16?=
 =?us-ascii?Q?nAbXth3ZfYkapreWXcJOpltRNN3mAVE+Bax3cM7QMLMpaobzR8DHg5TUyH5V?=
 =?us-ascii?Q?y7Y8OLgA72VQWF2tVbkLyWl3uuns3WKRY1kh/Ois4R4PlwId5pQmG0Q/C/NF?=
 =?us-ascii?Q?xk5X90apWdKYmdkj3sGdML5LROLqEgcHMSkcrRpPMahJsJzE/0TcKQHShS9C?=
 =?us-ascii?Q?NgHGPBHcu2lC4+N8X5Zv3Jp/vUo9tTou0GUjaGPcHxL/NGLDLQOnv7pwcBEw?=
 =?us-ascii?Q?vXhSBzkGiqbwMpIMQfyCqwjgpE/GzxLUx/BVni9P46PZbGQcFlAaVyf6HVm4?=
 =?us-ascii?Q?1dX9vlPFmfCzRZbLEoJk20BZRUFnaYxAbEcR4euBIqCnGvkhESV+cTrJMhHX?=
 =?us-ascii?Q?u9qjlVsjELnsHhLuZ4qvF3+CJPPyMp7QhABITQQjnNEjh4MIRnAVeTlnxVFp?=
 =?us-ascii?Q?Fc5hccXz/NwP3zfPqYNljSsDSgsMc2P+7sRs4qqxsqktaQ4ZMcNQ3UutZrvN?=
 =?us-ascii?Q?6ABwwlTrLQQxZadROMe/J6PES07/KRBe+ajudU+3a1lGl4XApyvegBdckQ2m?=
 =?us-ascii?Q?N7Q+NP9movDSljSRrxJtaM3/L/C0lF869qe7pnUKbO3a7usBEprnoQos2UMU?=
 =?us-ascii?Q?J0oYkrnrOFvrlK8t9QXw6R2tCmxl7eSe8zN9fIR2zXt6G86+dQ=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZQtgEAbQHNy4cKTw6fyHuv5x8afF2XnWsrtkYSw1ssGVDZcafFF1AyJ0deLb?=
 =?us-ascii?Q?6XJqDZ5AzkcSMb96BQeOfQxiZVBNJA73cvoBVUDrATdA2yazQOK7kKgMIxP1?=
 =?us-ascii?Q?6eSdqN+yzBRR7nd/pYgNtSWBvOynhzbDYzi8K600w1XrmLjn42TXJx8ShadL?=
 =?us-ascii?Q?MP0hRVpKO6jGqgjSKnFCESX0eUeHRoph7Gnznwq3pQr+K0Ccis+trNKYCjlK?=
 =?us-ascii?Q?fajDmwHF3Vmg3Dzc0z2JluTbHZIVK8RGyIrD8+x9QgBhTpa2FCw+ny8Tmp6O?=
 =?us-ascii?Q?+VZs/I+umV02tvtK2QzybN+MXTkCiQyxEhNPJq9/V1JEMmUjiEHCMlumw9M/?=
 =?us-ascii?Q?snUSYY806n2a0LywaQIUZgKCEtboNISy2BKtYxHYDgdIX4CunHbaGz7I59pU?=
 =?us-ascii?Q?C/JWIYsPfEs28/EiEqO5HCohUKsWCD53Hyr3tYLgHb7sowdYZaPG8LS7PmG1?=
 =?us-ascii?Q?fXe3ZgtF0kKIMXIUohS92BISHmwIhFgq11G+u6s54NYHpsxvMTy6fF1r9nGh?=
 =?us-ascii?Q?sCHV+h2l0oCEoEJ2vds0+sk2lI4qJf0CR5zkv97t70lpW0Ctifg0hrhfVcN0?=
 =?us-ascii?Q?DN+ykZ1jlCySuXpIzYCBXIMdHjQOXMCDSyxgo0hdEhQjfhNy23n+mKr8cRS1?=
 =?us-ascii?Q?OKxHQvKn8cFl8Kwyzj9eDl/tpwdp6knnM0Syk6tJfwdHMBDn+yj9QlW9P6WW?=
 =?us-ascii?Q?Ft9kz92wmxCBzJIE1Wk6pspxTQw34NuLnvo6nLpTLCBueTd4TsoVL6GELLCM?=
 =?us-ascii?Q?h4ZO4F2p+MJePyShFiD/k/XOUt4MzOY9NREKvcX5YBlIGjW6BFUfAAo4b4LB?=
 =?us-ascii?Q?U9TPiiAXIUIbQKjWfszXRIX+f0zH+u+2XrSAM/iRYWCArzGvl8yKnLvCsFya?=
 =?us-ascii?Q?i1G0T+mP4dMTkdAmHdaNeEMHhWdzAR/TAXH4g0z+TX+XkrX0lCL6XloKkVXj?=
 =?us-ascii?Q?JrDYoIttRdohnH3dVxfclGlGVpLNRMC2OUByhslSlsSiYsFLnvK072XzWnl/?=
 =?us-ascii?Q?gvFkZHefbNnts1oXnXXG9kBMHno3kEtsCxUStP/Uli0MNnQ9nfaJ+0iVGNpM?=
 =?us-ascii?Q?NiYZ6dJJLd1Sl6Ly10Gj/qDoKUY4hU8EGf0h2XadDU6S0Mm2f8e8Ey6ZGN97?=
 =?us-ascii?Q?vrEFyLRkE336YjnBYX54nkGTx3kYeh3o0xUp/Jw9JzsgE/VaYOy6TKa5XhPO?=
 =?us-ascii?Q?blUrWJnv/q8kwXWNuo6wfFWJeb9emRH2SCIkY91LJAdqjCnsB3LO3+MlgYgu?=
 =?us-ascii?Q?/5gZHFXv6E8Vuu81JfV5vkcCT/CZ2o13s/5FCBKiJ+FnclKoztlavJj4YNUe?=
 =?us-ascii?Q?J9pKLtD59uqJ3w7LwBvDgD2Wm3p7euc/kcze10Yh4nV3l/TIvOqPPQ29VEq+?=
 =?us-ascii?Q?kppvGW4fgBArMQyCV9Xkt+nNrpO1dDcQZZW1Epm44CRiiwf0by8k7LjAkKgU?=
 =?us-ascii?Q?vptqh+U6sPPWeXHXmrG+XIYfTKPeYJwN6/iTv4vfkID3/Nemkr+mr937a1BL?=
 =?us-ascii?Q?Hgs/whZH9azzB7A/spH6B4+vGsxQHezA8Q9Oq61rtmT/d6/vXbW1UQIm/ihv?=
 =?us-ascii?Q?f34/lYPu3BqFl4n3drRFb4u64qHuJkWtJVblcFax?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ee4aec02-3f4b-47cf-75a1-08dd59f27225
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2025 01:26:38.9843
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ftXBxSuvSZjsGcp9xmiImyds9JuePTESDB1I5o4NO2fGiF8xnp8jKreZ1a1RgusLdKGiFpK5V2q0ahF6pMrhsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7188
X-OriginatorOrg: intel.com

On Sat, Mar 01, 2025 at 02:34:27AM -0500, Paolo Bonzini wrote:
> From: Yan Zhao <yan.y.zhao@intel.com>
> 
> Introduce an Intel specific quirk KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT to have
> KVM ignore guest PAT when this quirk is enabled.
> 
> KVM is able to safely honor guest PAT on Intel platforms when CPU feature
> self-snoop is supported. However, KVM honoring guest PAT was reverted after
> commit 9d70f3fec144 ("Revert "KVM: VMX: Always honor guest PAT on CPUs that
> support self-snoop""), due to UC access on certain Intel platforms being
> very slow [1]. Honoring guest PAT on those platforms may break some old
> guests that accidentally specify PAT as UC. Those old guests may never
> expect the slowness since KVM always forces WB previously. See [2].
> 
> So, introduce an Intel specific quirk KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT.
> KVM enables the quirk on all Intel platforms by default to avoid breaking
> old unmodifiable guests. Newer userspace can disable this quirk to turn on
> honoring guest PAT.
> 
> The quirk is only valid on Intel's platforms and is absent on AMD's
> platforms as KVM always honors guest PAT when running on AMD.
> 
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Cc: Kevin Tian <kevin.tian@intel.com>
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> Link: https://lore.kernel.org/all/Ztl9NWCOupNfVaCA@yzhao56-desk.sh.intel.com # [1]
> Link: https://lore.kernel.org/all/87jzfutmfc.fsf@redhat.com # [2]
> Message-ID: <20250224070946.31482-1-yan.y.zhao@intel.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  Documentation/virt/kvm/api.rst  | 22 +++++++++++++++++++
>  arch/x86/include/uapi/asm/kvm.h |  1 +
>  arch/x86/kvm/mmu.h              |  2 +-
>  arch/x86/kvm/mmu/mmu.c          | 11 ++++++----
>  arch/x86/kvm/svm/svm.c          |  1 +
>  arch/x86/kvm/vmx/vmx.c          | 39 +++++++++++++++++++++++++++------
>  arch/x86/kvm/x86.c              |  2 +-
>  7 files changed, 65 insertions(+), 13 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 2d75edc9db4f..1f13e47a65fa 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -8157,6 +8157,28 @@ KVM_X86_QUIRK_STUFF_FEATURE_MSRS    By default, at vCPU creation, KVM sets the
>                                      and 0x489), as KVM does now allow them to
>                                      be set by userspace (KVM sets them based on
>                                      guest CPUID, for safety purposes).
> +
> +KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT  By default, on Intel platforms, KVM ignores
> +                                    guest PAT and forces the effective memory
> +                                    type to WB in EPT.  The quirk is not available
> +                                    on Intel platforms which are incapable of
> +                                    safely honoring guest PAT (i.e., without CPU
> +                                    self-snoop, KVM always ignores guest PAT and
> +                                    forces effective memory type to WB).  It is
> +                                    also ignored on AMD platforms or, on Intel,
> +                                    when a VM has non-coherent DMA devices
> +                                    assigned; KVM always honors guest PAT in
> +                                    such case. The quirk is needed to avoid
> +                                    slowdowns on certain Intel Xeon platforms
> +                                    (e.g. ICX, SPR) where self-snoop feature is
> +                                    supported but UC is slow enough to cause
> +                                    issues with some older guests that use
> +                                    UC instead of WC to map the video RAM.
> +                                    Userspace can disable the quirk to honor
> +                                    guest PAT if it knows that there is no such
> +                                    guest software, for example if it does not
> +                                    expose a bochs graphics device (which is
> +                                    known to have had a buggy driver).
>  =================================== ============================================
>  
>  7.32 KVM_CAP_MAX_VCPU_ID
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index 89cc7a18ef45..db55a70e173c 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -441,6 +441,7 @@ struct kvm_sync_regs {
>  #define KVM_X86_QUIRK_MWAIT_NEVER_UD_FAULTS	(1 << 6)
>  #define KVM_X86_QUIRK_SLOT_ZAP_ALL		(1 << 7)
>  #define KVM_X86_QUIRK_STUFF_FEATURE_MSRS	(1 << 8)
> +#define KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT	(1 << 9)
>  
>  #define KVM_STATE_NESTED_FORMAT_VMX	0
>  #define KVM_STATE_NESTED_FORMAT_SVM	1
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index 47e64a3c4ce3..f999c15d8d3e 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -232,7 +232,7 @@ static inline u8 permission_fault(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
>  	return -(u32)fault & errcode;
>  }
>  
> -bool kvm_mmu_may_ignore_guest_pat(void);
> +bool kvm_mmu_may_ignore_guest_pat(struct kvm *kvm);
>  
>  int kvm_mmu_post_init_vm(struct kvm *kvm);
>  void kvm_mmu_pre_destroy_vm(struct kvm *kvm);
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index e6eb3a262f8d..bcf395d7ec53 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4663,17 +4663,20 @@ static int kvm_tdp_mmu_page_fault(struct kvm_vcpu *vcpu,
>  }
>  #endif
>  
> -bool kvm_mmu_may_ignore_guest_pat(void)
> +bool kvm_mmu_may_ignore_guest_pat(struct kvm *kvm)
>  {
>  	/*
>  	 * When EPT is enabled (shadow_memtype_mask is non-zero), and the VM
>  	 * has non-coherent DMA (DMA doesn't snoop CPU caches), KVM's ABI is to
>  	 * honor the memtype from the guest's PAT so that guest accesses to
>  	 * memory that is DMA'd aren't cached against the guest's wishes.  As a
> -	 * result, KVM _may_ ignore guest PAT, whereas without non-coherent DMA,
> -	 * KVM _always_ ignores guest PAT (when EPT is enabled).
> +	 * result, KVM _may_ ignore guest PAT, whereas without non-coherent DMA.
> +	 * KVM _always_ ignores guest PAT, when EPT is enabled and when quirk
> +	 * KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT is enabled or the CPU lacks the
> +	 * ability to safely honor guest PAT.
>  	 */
> -	return shadow_memtype_mask;
> +	return shadow_memtype_mask &&
> +	       kvm_check_has_quirk(kvm, KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT);
>  }
>
>  int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index ebaa5a41db07..2254dbebddac 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -5426,6 +5426,7 @@ static __init int svm_hardware_setup(void)
>  	 */
>  	allow_smaller_maxphyaddr = !npt_enabled;
>  
> +	kvm_caps.inapplicable_quirks |= KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT;
Similar to KVM_X86_QUIRK_CD_NW_CLEARED for Intel,
KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT has actually no effect on AMD's platforms,
even if kvm_check_has_quirk() returns true.

I'm wondering if it's really necessary for us to introuce
kvm_caps.inapplicable_quirks.

>  	return 0;
>  
>  err:
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 75df4caea2f7..5365efb22e96 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7599,6 +7599,33 @@ int vmx_vm_init(struct kvm *kvm)
>  	return 0;
>  }
>  
> +/*
> + * Ignore guest PAT when the CPU doesn't support self-snoop to safely honor
> + * guest PAT, or quirk KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT is turned on.  Always
> + * honor guest PAT when there's non-coherent DMA device attached.
> + *
> + * Honoring guest PAT means letting the guest control memory types.
> + * - On Intel CPUs that lack self-snoop feature, honoring guest PAT may result
> + *   in unexpected behavior. So always ignore guest PAT on those CPUs.
> + *
> + * - KVM's ABI is to trust the guest for attached non-coherent DMA devices to
> + *   function correctly (non-coherent DMA devices need the guest to flush CPU
> + *   caches properly). So honoring guest PAT to avoid breaking existing ABI.
> + *
> + * - On certain Intel CPUs (e.g. SPR, ICX), though self-snoop feature is
> + *   supported, UC is slow enough to cause issues with some older guests (e.g.
> + *   an old version of bochs driver uses ioremap() instead of ioremap_wc() to
> + *   map the video RAM, causing wayland desktop to fail to get started
> + *   correctly). To avoid breaking those old guests that rely on KVM to force
> + *   memory type to WB, only honoring guest PAT when quirk
> + *   KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT is disabled.
> + */
> +static inline bool vmx_ignore_guest_pat(struct kvm *kvm)
> +{
> +	return !kvm_arch_has_noncoherent_dma(kvm) &&
> +	       kvm_check_has_quirk(kvm, KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT);
> +}
> +
>  u8 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
>  {
>  	/*
> @@ -7608,13 +7635,8 @@ u8 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
>  	if (is_mmio)
>  		return MTRR_TYPE_UNCACHABLE << VMX_EPT_MT_EPTE_SHIFT;
>  
> -	/*
> -	 * Force WB and ignore guest PAT if the VM does NOT have a non-coherent
> -	 * device attached.  Letting the guest control memory types on Intel
> -	 * CPUs may result in unexpected behavior, and so KVM's ABI is to trust
> -	 * the guest to behave only as a last resort.
> -	 */
> -	if (!kvm_arch_has_noncoherent_dma(vcpu->kvm))
> +	/* Force WB if ignoring guest PAT */
> +	if (vmx_ignore_guest_pat(vcpu->kvm))
>  		return (MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT) | VMX_EPT_IPAT_BIT;
>  
>  	return (MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT);
> @@ -8506,6 +8528,9 @@ __init int vmx_hardware_setup(void)
>  
>  	kvm_set_posted_intr_wakeup_handler(pi_wakeup_handler);
>  
> +	/* Must use WB if the CPU does not have self-snoop.  */
> +	if (!static_cpu_has(X86_FEATURE_SELFSNOOP))
> +		kvm_caps.supported_quirks &= ~KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT;
>  	kvm_caps.inapplicable_quirks = KVM_X86_QUIRK_CD_NW_CLEARED;
>  	return r;
>  }
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index a97e58916b6a..b221f273ec77 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -13544,7 +13544,7 @@ static void kvm_noncoherent_dma_assignment_start_or_stop(struct kvm *kvm)
>  	 * (or last) non-coherent device is (un)registered to so that new SPTEs
>  	 * with the correct "ignore guest PAT" setting are created.
>  	 */
> -	if (kvm_mmu_may_ignore_guest_pat())
> +	if (kvm_mmu_may_ignore_guest_pat(kvm))
>  		kvm_zap_gfn_range(kvm, gpa_to_gfn(0), gpa_to_gfn(~0ULL));
>  }
>  
> -- 
> 2.43.5
> 
> 

