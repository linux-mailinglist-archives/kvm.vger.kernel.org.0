Return-Path: <kvm+bounces-68557-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DE81D3C0E0
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 08:50:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 80CA4425E52
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 07:49:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D9E93AE707;
	Tue, 20 Jan 2026 07:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IPFYlEtq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 051BB2E339B;
	Tue, 20 Jan 2026 07:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768895332; cv=fail; b=RHwgRQnrsdSMi/niP79QTXDD7NprgqUg/WFA/hyuhuuboxzMoo7NyDa/m0/JXBRKgQLGmA2eynPRKMw2+hY0rPxrhJCYfVsL7/se2Uab3B87gwVF35Wrt7jfi0CZChAunSjVp8M2dUx5IiRF2+qi7bVLh9jPCMeb5qNt+7cYoTk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768895332; c=relaxed/simple;
	bh=IOpDi6y6Xf54fbhSvjX6ol00wiuFLF5p3GKpZDEMEoA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=SnxP0Mh6+N+zgXAHBV42qH8xMtXvIM06rnUnUTBKPmC+2lCJds1VuzT1i18JfgqxYbSpwU0cgJ6H0b+7+40QZaXZ5O7+KIlMK5sp07fSmOUpxAfBa4SA9zLPniDf2zqp/AyOAiWbyTQkLDMOf2b9660ISokV7qPWJ/kXbo1vLmg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IPFYlEtq; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768895330; x=1800431330;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=IOpDi6y6Xf54fbhSvjX6ol00wiuFLF5p3GKpZDEMEoA=;
  b=IPFYlEtqXfgH5Z0CRtdgWB2D9hCcnayXOKyvBAfaaElfCad8msspa+dD
   FZClWs/Csz/EAw9/aZXRzsS7ZImQHI9Cm6F0sSoghQHpBYN00P9e973I1
   EmCZma+rLMsDUNCqY6wKr1t2gXUHPPVDI49QD0C9jey2JzscULrydC8Rd
   NV73VIanwho0RxKyqL8ZuLrcz0kBRcUSTv2AK6LBnJAIOk76VaDtZQXXP
   B1Pa+ujfuOxwaXyxH00NCJsnAkGyJCq1u3RLVX+qDrvupgmUcMS/RXv3i
   ds/AYIUQHJZawp1oAo6G3bnQ7whK4ppNyciBRKgfGBApo3fYkPEykOSBm
   Q==;
X-CSE-ConnectionGUID: dpC0e58LTzSHgLtgd66k8Q==
X-CSE-MsgGUID: E0jaosbcSLu8qDilhxulvA==
X-IronPort-AV: E=McAfee;i="6800,10657,11676"; a="72683550"
X-IronPort-AV: E=Sophos;i="6.21,240,1763452800"; 
   d="scan'208";a="72683550"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2026 23:48:49 -0800
X-CSE-ConnectionGUID: 2dQAuVPfRTCnXv1PeYNs/A==
X-CSE-MsgGUID: +gwRc8bXQX2xAfD31200Lg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,240,1763452800"; 
   d="scan'208";a="210521691"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2026 23:48:49 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 19 Jan 2026 23:48:47 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Mon, 19 Jan 2026 23:48:47 -0800
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.68) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 19 Jan 2026 23:48:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hh4Dj5KmpacLPuD4QiQ12yxvzi9KhmbMUheFBmDjKXzat1E5VPhuL3DKisT9WKv2AK0qz/AFjMxRQCIWWlzkgdfik+AAww1X4lht/vGmygCOD/+D8jBXmZX3wFEXbCFsezH2oDpykgDWS5ZR+vwxHhC4E21dh+nNuiwnXaM5xUcHEdsJyeb6fSUWF4yCB6i5aYLZn8kS23rNiw9iHLg/zza5FL3cb8dcBxjIH5svjueRpeuLVyWaCckJiWEzTOrWx/3FiY6xLcZSqHtD6A3gK4bN+jyoq8OXi2iXMD5fJPax/NTB6p11y58WN1k1qi9j3TFMwSZoZ89APjbfzObiBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t27eNAvyY1QqidG2s6vJPDOEkJJGpz7xU9Y4B90X2Fw=;
 b=ORe38QrYvR0KG8rWs1i2LlGVeEDEFZmWoK9V++UfdZN4AbqaNBkVhV+u1u1u5htabOYTgkRQsB1zOxitamniBQLk32/WYagoC1Pb8+p2U6JQxb0kPsIMdQlTPgKSxNlCe/1IzP6BpIS6McFLUqEJ6avYolcCd6HTcasLTPtrEvW7KbEp8Z8ye9smxXSOE5lrSbWKGEtKTw4KzeondAtWtzMC3f5+Pex0XAz8ZNKpzowjjsc7jXP3k6wz6CCeiFBM0vdfJwdwCx7hdFiTWJyRjHwEe5kR2mifycMZAt9+uC6CMnjcv84d6/X7E6nx7a5jdpml6wtwFvJlCshn3LYDDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 IA0PR11MB7751.namprd11.prod.outlook.com (2603:10b6:208:43a::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9542.9; Tue, 20 Jan 2026 07:48:44 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2%4]) with mapi id 15.20.9520.011; Tue, 20 Jan 2026
 07:48:44 +0000
Date: Tue, 20 Jan 2026 15:46:00 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
CC: "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Edgecombe, Rick
 P" <rick.p.edgecombe@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>, "Wu, Binbin"
	<binbin.wu@intel.com>, "kas@kernel.org" <kas@kernel.org>, "seanjc@google.com"
	<seanjc@google.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Annapurve,
 Vishal" <vannapurve@google.com>, "bp@alien8.de" <bp@alien8.de>, "Gao, Chao"
	<chao.gao@intel.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v4 12/16] x86/virt/tdx: Add helpers to allow for
 pre-allocating pages
Message-ID: <aW8yuEX486oJ+zOp@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
 <20251121005125.417831-13-rick.p.edgecombe@intel.com>
 <7a6f5b4e-ad7b-4ad0-95fd-e1698f9b4e06@linux.intel.com>
 <af0e05e39229adb814601eb9ce720a0278be3c2f.camel@intel.com>
 <9dcaa60c-6ffa-4f94-b002-3510110782dd@linux.intel.com>
 <a99ec2d41087c65e6b55ac53af8dc158ec5dc059.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a99ec2d41087c65e6b55ac53af8dc158ec5dc059.camel@intel.com>
X-ClientProxiedBy: SI1PR02CA0060.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::17) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|IA0PR11MB7751:EE_
X-MS-Office365-Filtering-Correlation-Id: ed6ea953-dc25-4d98-4aa4-08de57f855eb
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|7416014|1800799024;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?2oQ2ToLUB+LPuPDLtbktXFC4f+1WjFn755YgKrAhTK0e//zxOaY7osH8lj?=
 =?iso-8859-1?Q?jVmLTIfjeyqn0YntUn6VeXCVWw5csNDfMve5Z2v8tnOgGNCwmHkEQB8HEu?=
 =?iso-8859-1?Q?xC+WjuiDaEsqEUFKZZ+30d41teMu8QfBUhns1NmtALlUgXpWl9DBxLrY04?=
 =?iso-8859-1?Q?WcJ9s3D2m4ltW6akpBhxZi8TVkoxZf/YOdLswKWm7kdgWEUfzzyby9vb8q?=
 =?iso-8859-1?Q?t4qqT88ktACkF8ZLSNzx46xg7NTXQqyDkC/lFTD+Fh/uMNBo/fQZoDXgG2?=
 =?iso-8859-1?Q?uIifQ4gjANkw1iZStEBHblnI8ODSWbrC2vTPpAwnfRXwfCVT4Yav5gzeCR?=
 =?iso-8859-1?Q?/z60RHqS1pBIugjo4ewSBJpX3PIz8+kQ4/Zml1gLoaNaiCLACspOwtuvyw?=
 =?iso-8859-1?Q?B7qlf3pxlWJUjF47KHcyn6maxgJ4jUV3DwE5dQHAYmHzewjACASzl34WAP?=
 =?iso-8859-1?Q?EeJlrk0jNyGh0BV32KRxCLxR2hoT2etamBcLp+991o2i88xixyFHrGf9Cu?=
 =?iso-8859-1?Q?tzDulyR829u9pApZCq2kuecc4ulAFKvV4Q6vCwifuILu3ckFF5kop4CAxT?=
 =?iso-8859-1?Q?ZMmR47IFAZ9FPk8ATT0F/OskcAWKsWWgvO0l4ZAMr+nE9mOnRLMbFs4LLo?=
 =?iso-8859-1?Q?CdoHV8Zq8cniRldDfZs+TapjxqWm6nXldudjHfTjAzWDNJYoLEbRZodjKO?=
 =?iso-8859-1?Q?2KFvD8vZ2exBb45rF4nN+Ehztm0fLS66r9w0YSTW/KsOZ8DrHzDJN5E14q?=
 =?iso-8859-1?Q?mQIuzEPvy9W87GjTOucSAOlGZLZgESpBOQOr8X9WVO49r7WyIGREDHdkXt?=
 =?iso-8859-1?Q?7YyE8JG9hs1N792KUGN52f5fp3ypkksazZVLIeH9vzfJkG0ON/sKLEKS0Y?=
 =?iso-8859-1?Q?cClBUpuAUW4uVncsZ0fSVVh891fQSC8JNsnyjsjIQjP6MlJP9Sm/7pmZhK?=
 =?iso-8859-1?Q?7WTQUC2OvF69LdBTS33LDfvPUAFEUVUFgTEACvvLnCV7SUVa+iURFXmCo3?=
 =?iso-8859-1?Q?jiJfbuR3WbbhVd+POePWX9QhxVNWG4jPJALNqTjIj4yOxTClahhOaWiQbc?=
 =?iso-8859-1?Q?hGCyTlYA+sqaGA+UUIcLaE3fRREuqZ0soWrFYWW2WOB7ZLWE+RZtLML3Mr?=
 =?iso-8859-1?Q?EB05cUY6xl743ljEBCTzNUxLb8x/WQdwobq/ODCN14ScLmh523tIb7Ayyg?=
 =?iso-8859-1?Q?8vhWdRnlS0ugi/DCYYUfnnEOY4N2e6tlcxql1M5G2xdUknAA5P0j48r2cp?=
 =?iso-8859-1?Q?QmDxT3l44AkHSpraCyrZJAR+csRj3+/8B0Dl/p0kB3GYNcdhtH2bYZasz2?=
 =?iso-8859-1?Q?YhbGNAgrhWDBgD+5HFKNeaKClab9lO28k5GYIW6rCI4Hjnr6b3iQnQ3IeW?=
 =?iso-8859-1?Q?xA9YL90zvSqV0LxkYBuDDXjAIAnzH0oZPCfQA6IdA2XdvMIdVMPjdgbynX?=
 =?iso-8859-1?Q?3zWp30v7anbVnN8/hfE6ZOf36Z8FDR9gXeJMA6KiwcvPREqL1Y2+IO/WVH?=
 =?iso-8859-1?Q?Ac4v/dBiKdS93do3hSy5AV15BX11VfWx5OFMO5n2D2VtL2tr3toIsc5pxi?=
 =?iso-8859-1?Q?QUFY7jB9s+PNCIwqUxpL+N9SH1+oGVndaPhhbS2akQXlsXs6d5yhoqx0qA?=
 =?iso-8859-1?Q?IIj34Sax/Aw4U=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?mkxov50JDBU58+hMsWwReUEt83hwxzbp6ayhnVPYqjQAPcXXrNcdf4xN3I?=
 =?iso-8859-1?Q?36l2TboRMova2YsjUvRoWhQdJjdt4XK+tiAifA69p45V/f2sPZC0MBPr6G?=
 =?iso-8859-1?Q?8nYD3J34lVpj0HPZfC+8URXAjwB1nDnD2Z1kiJsAIgSieQR1biHVoV6Pf0?=
 =?iso-8859-1?Q?vq8oxPOl52modf+gynQ/CGz06HxSbD2QL03pk2EjV4tTyXorETl0a+A1pB?=
 =?iso-8859-1?Q?0dPQXnjZbJNfPVs6ZL+5P6fruvl9NsZ5+HHqzqe5bFM73J8E6bwiR27bGL?=
 =?iso-8859-1?Q?cA3TB9rFWfvZydeoHz71cWHq55fZhoALjgTlV0jSoPtHRFcNvs562XEcqe?=
 =?iso-8859-1?Q?zD0hH056Y+jQ/XwEeJup7hxNLMxGI/F79EDFW6VpGK2K3i0sYF3n/7kwzH?=
 =?iso-8859-1?Q?kJqdYyeesNEd4T+MGBmyql6LglE2Q1+yB5HC/obhc424RU3wGUAAzeT76Q?=
 =?iso-8859-1?Q?RZsM8jlcszhHhIbAHDnL0tTyUDrTFTghcXz/HJc8VCu8l0iYsVqrZFlDNU?=
 =?iso-8859-1?Q?x9aOYVUWykDSjFg3+wUM9pCL9a7tAC+rodpm7BheXDAboTbPLWLg/hbYfl?=
 =?iso-8859-1?Q?/8kb/eNMxRzbudQOUPJd0a1+brvnwLAKGMqj1QCH5CHfmxZhtEVQroTwAL?=
 =?iso-8859-1?Q?0PD5KdZsy8bg6fbZKM5vUl0WVTWoRI6Y9HeLCxpXw9NIEE2zIRMGKx0Zk4?=
 =?iso-8859-1?Q?pkWwjcTPEkHDDSldKLe13OkoJ15Za8s6llXZEpxHUoHrrnUNqkTvRLupLy?=
 =?iso-8859-1?Q?7NqGV3laEGX5swJOAcpoqZ5DlTcyJ7xA74/HW+bht2z/kEvVyPHo/5777Y?=
 =?iso-8859-1?Q?AtXCXAvr+YmqQPHnn5okVpRly+NU3P+Gs6HyQu5zWlKT5oUdjNpXZ9WGPQ?=
 =?iso-8859-1?Q?Y55ZA5xRqnyYz4WIZeYTcMP5/lFqKyNC+jGLHc59VHFDkbcXRGQj19Oy+S?=
 =?iso-8859-1?Q?LTWekjuqfYu/gphTl8yKZwC9PeNwYT8s7+Bg5kyxD7OfnrUlJ1fiL3VnQG?=
 =?iso-8859-1?Q?vRfF3XeDn6ZSyva3MM2eTgP+cfVR+i10KL4PHM50ggN9pZEwGZhOafZqza?=
 =?iso-8859-1?Q?mLnNit1I91lXHQ60CIaZu8Fl7vGd2m+QRRxLAPwMUMTC3NvNY8nMws3fFA?=
 =?iso-8859-1?Q?zaIAJsrM844I9IkbEa4J0Dtn5G1mrEIiBi5Blr34J75QnekKWytMOCcR36?=
 =?iso-8859-1?Q?tpQ7D54S+INgJiMWDwfGEz22UDKcODcgF7MzhgAKZTkxZ97PzA3VhgXrLH?=
 =?iso-8859-1?Q?vKaudFJdT8hYU8h/Kbe/7VV3Kim4EjPemSpmIqKQHZ1hHH3/co/vnRWpbE?=
 =?iso-8859-1?Q?McIXJpzQN7qDUvjNZeUxrEQbTx3zAIZaNq/BBYuU7M1Zqj8mD/KetgkYZ+?=
 =?iso-8859-1?Q?1P1/zoB65m/LILuWKGPryAfXzl1+lPFBNY0xQtuMMKIVY8tF8e2y/nHRXs?=
 =?iso-8859-1?Q?4zchti0uCZXznSMupBxorJ04TihOiyqVEMmmYWuul3M60v9JInfa+Fnh8V?=
 =?iso-8859-1?Q?dIOAQLwCOvVy+QKyuzB7epgF0R6EG70QpaIh8uZGnOOgnghQQgOvYjWVYv?=
 =?iso-8859-1?Q?ywkPuBtHO5eWYC7dk32aIIWg2tEIacfUGq4MgFJ+6xSLp9sbUGY/UpggFb?=
 =?iso-8859-1?Q?CL9iZTdp8/F+4HlHeJMCFOyBmxrch0ghwwousCaXcY4mq39kErt619hOef?=
 =?iso-8859-1?Q?aBF4OdZdzcQJlS0dfvO7oi4K9X+lek5gh4BD2GAwYpfVMyzhQ4lxGvaNzs?=
 =?iso-8859-1?Q?bl+jvryrvODYGM0RZ2txFevAGifQY1JlD1J2KL6B3qAOrGNgko8Aeqi/So?=
 =?iso-8859-1?Q?9J4WvsGn0g=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ed6ea953-dc25-4d98-4aa4-08de57f855eb
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2026 07:48:43.9962
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oaEd7zM/n4vTpMvUY2HIbnaiXzgUGdcbC0njcHUmI95BvmEOdIzXg+2MexUG/F4Or9Vokkz3QmLaqUdgZHqD/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7751
X-OriginatorOrg: intel.com

On Tue, Jan 20, 2026 at 03:10:59PM +0800, Huang, Kai wrote:
> On Thu, 2025-11-27 at 10:38 +0800, Binbin Wu wrote:
> > 
> > On 11/27/2025 6:33 AM, Edgecombe, Rick P wrote:
> > > > >     
> > > > >     static int tdx_topup_external_fault_cache(struct kvm_vcpu *vcpu, unsigned int cnt)
> > > > >     {
> > > > > -	struct vcpu_tdx *tdx = to_tdx(vcpu);
> > > > > +	struct tdx_prealloc *prealloc = &to_tdx(vcpu)->prealloc;
> > > > > +	int min_fault_cache_size;
> > > > >     
> > > > > -	return kvm_mmu_topup_memory_cache(&tdx->mmu_external_spt_cache, cnt);
> > > > > +	/* External page tables */
> > > > > +	min_fault_cache_size = cnt;
> > > > > +	/* Dynamic PAMT pages (if enabled) */
> > > > > +	min_fault_cache_size += tdx_dpamt_entry_pages() * PT64_ROOT_MAX_LEVEL;
> > > > Is the value PT64_ROOT_MAX_LEVEL intended, since dynamic PAMT pages are only
> > > > needed for 4KB level?
> > > I'm not sure I follow. We need DPAMT backing for each S-EPT page table.
> > Oh, right!
> > 
> > IIUIC,  PT64_ROOT_MAX_LEVEL is actually
> > - PT64_ROOT_MAX_LEVEL - 1 for S-ETP pages since root page is not needed.
> > - 1 for TD private memory page
> > 
> > It's better to add a comment about it.
> > 
> 
> But theoretically we don't need a pair of DPAMT pages for one 4K S-EPT
> page -- we only need a pair for a entire 2M range.  If these S-EPT pages
> in the fault path are allocated from the same 2M range, we are actually
> over allocating DPAMT pages.
topup() always ensures that the min page count in cache is the max count of
pages a fault needs.

For example, mmu_topup_memory_caches() ensures there are at least
PT64_ROOT_MAX_LEVEL pages in mmu_page_header_cache, which are not always
consumed by each fault.

But in the worst-case conditions, we actually need that many.

In the end, the unused pages in cache will be freed by mmu_free_memory_caches().

> And AFAICT unfortunately there's no way to resolve this, unless we use
So, I don't think it's a problem.

And I agree with Binbin :)

> tdx_alloc_page() for S-EPT pages.

