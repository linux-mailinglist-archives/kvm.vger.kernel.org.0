Return-Path: <kvm+bounces-60127-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3410CBE1F27
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 09:37:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C79F3540E76
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 07:37:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D5412FAC09;
	Thu, 16 Oct 2025 07:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IFTxWQ11"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B916627732;
	Thu, 16 Oct 2025 07:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760600261; cv=fail; b=H4/ydB9j5mnpxOQH29eP2J+/tTaQsjb0woNdfSbsaCwNHLko07mE+3q2kahsEx8Cg4hNR/Fn/LAvKqTnunxcbD5DWOTMqB8w8wX2H7bwMF1LO2JSG0iEBGpwp4NNtIZCftA5QQDzN6igjMJq0fxwdoSiefqu8JeSfFlc0iTsSpM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760600261; c=relaxed/simple;
	bh=g6zR36lYImImYgUHkF4F2RAJYFeclbuhMYHBg/n4jZM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=faqrpepHhw6JP5K71m3jQFvbjq0/pzgUoQ9Qf7CRuRcL5TMsYugysRmyNGU+7agtRXUwELutJCtl7DhLJ9sqNTK4sePG8hseMIBriSSESq/gXQyCdmwYM19bPvGe0mM58DRoQcseMJZmjIJC/JvckDffHwk5e7qHOsl0nSKR+J8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IFTxWQ11; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760600260; x=1792136260;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=g6zR36lYImImYgUHkF4F2RAJYFeclbuhMYHBg/n4jZM=;
  b=IFTxWQ11AnFIDg4254+kwHA7qYFm5OwpAeP55QJITL7w4/AM/UV1q1AW
   GJLJ4V0PqXGZ17WHU1cdjRdBWnZBX+66vsH7IzxKD2X6+tiFzam4G0yQg
   AfNOomVr3E31GFmiOY0SFu6NCWr6mhzzQlyPm59cHTxpM6S20kj26RPcn
   lViy4hGqCLMktyLI7R6cMEBECLsUGt3fYkcOx46Q0e3LYAjnQ994TjiNV
   byJmc6FlUsXzCFDtgfBSik/pzL9Wsv7MYVz0ArpKqkDTnGWo0RBJgsXZ/
   fmEk7OKP6GizuCgfaDJrGv8tWuyBKemK+H5vNB/vMVD25qDEkHUkDIfC+
   A==;
X-CSE-ConnectionGUID: 4eOBM/bvSCu41O4SMgqUvA==
X-CSE-MsgGUID: P6+wIsNeTomp/yhbRfmpSg==
X-IronPort-AV: E=McAfee;i="6800,10657,11583"; a="50350788"
X-IronPort-AV: E=Sophos;i="6.19,233,1754982000"; 
   d="scan'208";a="50350788"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2025 00:37:39 -0700
X-CSE-ConnectionGUID: 3AY+5dNVSEa3a0UxWn29uw==
X-CSE-MsgGUID: pwlHw3EGRZeaPzEw/JQfwA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,233,1754982000"; 
   d="scan'208";a="182323750"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2025 00:37:39 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 16 Oct 2025 00:37:38 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 16 Oct 2025 00:37:38 -0700
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.69) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 16 Oct 2025 00:37:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BFRjRZa+iHgRSoPLqxB8Rrqma0Dlf1bKZwdyDEM1ft2cmmqQrrpxN3EtJ/BG6x5s4O2+PRj8vQK21uEeGo2RdjUOyxBHYeSL+vs3Hgg+qzoPJ+NOc8zNi+6VFAKbYVX8sTpa4ahK8RB3UoZGo6Lw2VyCv/CUApwPhEzzpFwUX5GOU3fj5HD92ABo28OGZMORRHXyBR5x8e7TNZWiWEYgdQjR4UWiMIF1/s3vrAolmm2g4C/zr/lMow8PV+hKJtUxhCQKEJGLvOqYDxLPNBabtkvkNh28w8YgFKlBw505Ng2oUZXMyicLr8bh4QBqYoRcp4p9Y0wdhwGjLQrvk5W5AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LBh2endfcRWyLnO6a/kud3EtRhdRY/38+x2SW5O0rtk=;
 b=aV6p/jFKcnRqEqZuM/BTAx+W3SbnNQtlkQZ3Qlq4n1HR1msXsJRjglROcXvVLohwca6aX1iz2NdcsmCZldl0GyXCRCclkt5VVWR+UmKR7JVkpGXm+gU6jzJC4E6cRClzsJWGPdh/bQijUJBKncJPEX5EJLg4uxrapK5uDeAwJ24dgaP73a8YfuzldAjBWb7PLQTh5Uqb2QLboWve8acB3jiU1GzTxn5yKzkYRpA4DTdoSF7owrtjda48h7HEnT02R6gRIOaG29PKWn+kC1ciWHwBGn+syaHcnnC7nQzVUxFh4qORHcx9SWdW6mV6MuSjIYz5ev1Hy+GI3CfF7zd0zA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CY8PR11MB7828.namprd11.prod.outlook.com (2603:10b6:930:78::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.11; Thu, 16 Oct
 2025 07:37:36 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.9228.012; Thu, 16 Oct 2025
 07:37:35 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Alex Williamson <alex.williamson@redhat.com>, "alex@shazbot.org"
	<alex@shazbot.org>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"liulongfang@huawei.com" <liulongfang@huawei.com>, "kwankhede@nvidia.com"
	<kwankhede@nvidia.com>, "yishaih@nvidia.com" <yishaih@nvidia.com>,
	"ankita@nvidia.com" <ankita@nvidia.com>, "jgg@nvidia.com" <jgg@nvidia.com>,
	"skolothumtho@nvidia.com" <skolothumtho@nvidia.com>, "brett.creeley@amd.com"
	<brett.creeley@amd.com>, "eric.auger@redhat.com" <eric.auger@redhat.com>,
	"Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>, "dmatlack@google.com"
	<dmatlack@google.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"torvalds@linux-foundation.org" <torvalds@linux-foundation.org>
Subject: RE: [PATCH] MAINTAINERS: Update Alex Williamson's email address
Thread-Topic: [PATCH] MAINTAINERS: Update Alex Williamson's email address
Thread-Index: AQHcPFXH/QkPd9pBUkyYGooRda5cnbTEZoAQ
Date: Thu, 16 Oct 2025 07:37:35 +0000
Message-ID: <BN9PR11MB5276BF53F5D55B0AE89F51FA8CE9A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20251013152613.3088777-1-alex.williamson@redhat.com>
In-Reply-To: <20251013152613.3088777-1-alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CY8PR11MB7828:EE_
x-ms-office365-filtering-correlation-id: fde16cfd-11c4-4c36-fe7a-08de0c86dfee
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?jyHBZWe+ErxE0b7ja6xuY15/qbKcebIubvdWyG4xNEbkFJ662GNwBegp6WjA?=
 =?us-ascii?Q?9WJjrZQSOWYxiYP81o55+gXW+0kHaUQLvNhpPWWtkNMbx2LMgsnN4uxcOZWy?=
 =?us-ascii?Q?/3Zf7LjRhb/5fGKOqesayM+zY3skkHR2WSXPHzr5E8fKoVCRt7Ciev2BvOq9?=
 =?us-ascii?Q?hkB4SeZHuZkGxGG6AU924kge6mfv3biBWDgDQHmkA+ZCuyiGre9hkOmtT9Il?=
 =?us-ascii?Q?SJUlp9/04DcYaAED8mxww86+hQnQtgQ5B3p5XsrivQKEVlVnHxfTJQ8NsSU3?=
 =?us-ascii?Q?4Sn0Tw2p5Suf2JWFvXfzRbPySn53ZNAox7i3uD8FDiUxZZ4IIhixGQ+AGjgl?=
 =?us-ascii?Q?qJLMewuo0BfOpNib5btcEY7svUAzyg4miv5ywL6jfadM8W6dm3IU0K7DD+EC?=
 =?us-ascii?Q?ZZ+uOhdoHPQEU19F3txCCu7BcvHdpVensVa6EXM6O7aC+zDxvoNhX7sjXW6o?=
 =?us-ascii?Q?DK47rnUWvFD0QHVZE9t0OMjscn9ZtOj/XpOk6iNOj+Ax/nYgRTXtMrmM6Z9Y?=
 =?us-ascii?Q?Zm/v7hDg8NZkjJJJglK3fPUIFufmOmijUDHCucDcTjP6/hezoQ2sBmi0fyRW?=
 =?us-ascii?Q?9vg8ff0M0W0sG7rFhdgMXtlOCRCw4tGW/+BuvKKeJUtrh0UA84PSonp76LMR?=
 =?us-ascii?Q?6HX9ujbhrEBVqjN0XHda4n4TGoGCyMOoGgjRNuKYBckt+3+DUHBSSkl80nVx?=
 =?us-ascii?Q?t4TsfhEvZ76eCVjIlpORcVntfpHOwwvjG4A1nh38hyEm6xuawySWORqh+C4C?=
 =?us-ascii?Q?QhY2vobFMm7LxAPemeX1VQERnhT8whK7Soi7vVSaPyaR7RtpGl7x2nhQ4OLA?=
 =?us-ascii?Q?+l80vO7RTepo2wEr+gRbwnSwgDSkGnHtzEOKxwHpPw3X4yirX9T2B/Z/z8TU?=
 =?us-ascii?Q?eOu4RyKKQdXsH/nHFN6zLKiXpkytp6nFsHKtl4/hvV3pMslTJ94MnYMgB8zy?=
 =?us-ascii?Q?LKGn7yn8pUG/8vVWZKH6+6hyWGnNX23bccG7gDLLd/YG8Th89m8TCollv6if?=
 =?us-ascii?Q?rO+srKFHt7ucTMDDJBfA52Fz4hhsa8jpCw2vHQse2KBZ2SgipL+Iws9oLM6o?=
 =?us-ascii?Q?rt5B7VCYffusSnhz53juJnRMQb6XyzoMe3dcEdqa+CQc/0/HIi513Yo0Z6dk?=
 =?us-ascii?Q?bZBsCutwjjepuCr8nu3K887hiyNJLZqTesQ8cHUpYd1VtdpZEvJIDck/hGDT?=
 =?us-ascii?Q?V8cGE1grq5rxIIVsJrsRkdWC7vya1/EKioUJoYt5qciHYvhvHWDQW+v8cve8?=
 =?us-ascii?Q?Y5gzCKuXHAiAVaJ4ZH0SfpITVLKEGkd6Gyk4d5J32su3GGb6iAWgsA85lp1j?=
 =?us-ascii?Q?AhLnsLp0Rw+/+UNUU9hqaBYyFegSC2tp1a1T7OVksGygkhCp4sGc9ETYFWpW?=
 =?us-ascii?Q?87L3X+T9e6apSMbwVcruXw+wyM/Jq46lsaHhfeneJs/CkP0e5mCuVPDGEIp5?=
 =?us-ascii?Q?5DHjnzyN9abU1ZbNBXr4p7TDXpIL/vdPxbuojTAti4F5nxI7IEEMMN6rleDp?=
 =?us-ascii?Q?p6vYfyiXJ3aZJ0LY7kx1gPGDE88m/ABzXozu?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?YSMWvFBqCnoI81ol8ITpGNr3dxDXWTEfsFaY0v8PawLI6srXMiOs2UutOL+U?=
 =?us-ascii?Q?j64B4OYkewxehlncHUaOqSEwmVjamGYz8omlTMW7IUkYKNn43GNp/puCYBJW?=
 =?us-ascii?Q?BnJZ3s8DE91qivYt/UU3FEPO7jhueus1SyiPxQwLRQlo4rZtFij19ew1xtlo?=
 =?us-ascii?Q?n1WqJ3EWY8FUWJfjdcWvAmDlL65/JJDe5+Z0h0p44yPL8v37yAObgjKClM7W?=
 =?us-ascii?Q?L0aE22uvtD2MIRI81EM4/VMmO35XEP5efKYvRdZZse2JoY9X8cctD1+Hybhp?=
 =?us-ascii?Q?1HxZLiPzjOcVios92yVMXcDwDKctRLZDhIQI8gxhzhuipP6Iq3OjRZbdALgc?=
 =?us-ascii?Q?NXP47L69jHignyn+OPk1I+n5a3IbB5yHV77YuSqK79ovNrdgrnfZupaNZmS0?=
 =?us-ascii?Q?LWXY4wm+GH1VmAiCIMb0lnaRNmQT61hLwXQdbCt5NrXYYwXi2HxSTsRYGDMG?=
 =?us-ascii?Q?FoSsU0jPeHXRrXANrkBCmRF1UpNlOzVCMPN/JQw10kEpfpHeHinAcqV1GPsM?=
 =?us-ascii?Q?o4WewjoDdjg5aZA2twUv/fnyrMrPNPEyzYQGtYUD3Q2pVeY7vusWHqle3oSj?=
 =?us-ascii?Q?f87SUbaay2ivpn/fnJOt9R0DZwPy34bvOzWt8KFKXAzs9YxstXZtx9mYIqv0?=
 =?us-ascii?Q?re4CI88wDkj5zMJGziBX4/MoYB4Wm/ZTeA+sXCvCxYml03/+MAgVVFp/LzXR?=
 =?us-ascii?Q?qXivGW6Xlpwsxegq5JnuOucYU4nY/XOx3ldplj+K00ZvANqcjm1LoBBhX8EM?=
 =?us-ascii?Q?pzNQzpg24eI00wrOYRepNEIlap5MCrhykSZZ+FSiDseyxHLuW+TYZrfHVmwW?=
 =?us-ascii?Q?qM3E0bwqL8nhqD5Jlp1feox39QRWdFyQApGx5QbjoW3Zk3qNBLJNr2pofuvl?=
 =?us-ascii?Q?KNu0kC4aNITchT6G97HU3913yTCPqlx9THNVh0RBGu8Y6hy2fMXzzx8iMl3a?=
 =?us-ascii?Q?B5uSUXjJd85TjTmUcL0J4gX02Vpq/t1++5WCT3q56EhDVdnl4tGSgXUB3CJl?=
 =?us-ascii?Q?6bzyqO9lbA3pjePONiyWlwhsv3N5tSeLU6ON4ffL3Bbyzg7M8wTbkyWHu0lY?=
 =?us-ascii?Q?BPLSj0pbU/Fe+XTPSbUfnk20rC8Dr0EwGQo1xW17ucWqsvtto9OT0O24gsJb?=
 =?us-ascii?Q?bhzYr4zVxZWTDRXGhkv88tnrBayX1iH852ihzHnk8SkP5tZkWXP38oMHdodf?=
 =?us-ascii?Q?KV0g2T8triq1Xb8Rp0pAgujm3RTpjO/X9/PqTzzGyRTH22HzK/Pgh9ZPs92P?=
 =?us-ascii?Q?Eeg37r0hAEA4q3rTv95uld8Ph/zbhqset74ELHJenMq4MvHOsHRTh6oxmdme?=
 =?us-ascii?Q?wURcYQoNLf4WEpl9AENs9dY4uaXb21iCsxb7c4Ssl5UH/ZiHJTNTAXQH9ei6?=
 =?us-ascii?Q?vxGsF+fq+uXlEj5LslsFIWMunocn6AJhpuycV1VM1hKtQQxV43zPBwhHu7At?=
 =?us-ascii?Q?1VURn+a7p2k9gAKuZgYv2c1Vn8EV/B91PTBgt1j7fPRKepo4Dn0jSo2qUhI/?=
 =?us-ascii?Q?UntLfOkNu7Q5etHY/xXAYjQcW0LIJvU1G2e8K8JRN595NOEQwe5oD7T+cU+K?=
 =?us-ascii?Q?nPaqthpcxif9vj2wk3YS6ZUUy3qf+02uaxF+uunE?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fde16cfd-11c4-4c36-fe7a-08de0c86dfee
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2025 07:37:35.5042
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tYtrIjhoqZqdOMZmNA2dlHBKOsg3ly85vGPH+Hq+0yVty1sHNcJLt7khD8RVk+wv97d301XGtaA6gqWs4eIJJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7828
X-OriginatorOrg: intel.com

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Monday, October 13, 2025 11:26 PM
>=20
> Switch to a personal email account as I'll be leaving Red Hat soon.
>=20
> Signed-off-by: Alex Williamson <alex@shazbot.org>
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
>=20
> I'll intend to send this via a signed tag pull request during
> v6.18-rc.  Thanks
>=20

Best wishes to your next journey!

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

