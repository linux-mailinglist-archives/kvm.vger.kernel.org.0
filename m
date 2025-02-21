Return-Path: <kvm+bounces-38851-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ED0A3A3F436
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 13:27:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 54C2F7A67EE
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 12:26:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 510C420AF84;
	Fri, 21 Feb 2025 12:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BvHBl4+9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2654D20A5D2;
	Fri, 21 Feb 2025 12:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740140857; cv=fail; b=GKNAAGDAjPVt1diUkidG0FFpJgcU8E1+Yb1W2DI4t4oM8OYdQWYAp24c6lytPYFASIxtYGndwD9ysmv47JXkqn9R9HwBukGcuou1YpvVMyBjHa1XQKkCwr/5hLcJ7OZ4CfciyzPNcdlKpSYbeEgIkDUZ2jqnCSmyeZ3WXg2oX84=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740140857; c=relaxed/simple;
	bh=HFrR/R2VYeahILZ5ejYNhalq9kRQa1pSBuN1CTptVEs=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=bbNyifpQKuVYSAtm+WbqfbVHCQtePXegdfO5r27hQRt2Kbc92dHLWyxs0AQMj7fqV0nNYCSauWMxdJ/4JjwkBk1cBchFt4O2UbYlhVJYxnDaNSHVTZ15CawLTngDtx8Z3fdfRMi4NJend0ioVXmTTyOt1kF8OjhOTmEqF18lvmU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BvHBl4+9; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740140855; x=1771676855;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=HFrR/R2VYeahILZ5ejYNhalq9kRQa1pSBuN1CTptVEs=;
  b=BvHBl4+9oJI/gvB//Gtj8XWLOASTHyKBZozEtyXGdBC8xw0bpI2cxvbW
   oXQ/zv9GzuNnnGivc2tX6P13a3sLCB7EujCAVsFsb/e3cYmfb0nObUXPh
   dE9BxMY98feeP5x+PCO2pVda8wAkIzZkKD7gG3abQjnlYj3graAaC5IPg
   rbcUpJdIlOsKkshE5v7Lmubf+pYrFD88OqFeyQ6fQQX63T0PG4bb5TfrL
   NX0LPOYKSgIc2dCeSsqngRjHLuia6yQKi2APqyazmNAULI+CUfEBwNPnP
   5u5IUmc85nVj1oWcLVuenn2dSqzJkVsJepoyd+vWnQgE2yc7r3Fi3ew/l
   g==;
X-CSE-ConnectionGUID: +nDVM9ItTGyLzWiHbWY7ng==
X-CSE-MsgGUID: jwtoG0L2RmC+KnQgcUttrw==
X-IronPort-AV: E=McAfee;i="6700,10204,11351"; a="51583431"
X-IronPort-AV: E=Sophos;i="6.13,304,1732608000"; 
   d="scan'208";a="51583431"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2025 04:27:34 -0800
X-CSE-ConnectionGUID: 2GKEuZgjQnKKHv9Dh2PPcw==
X-CSE-MsgGUID: rpJ3YzQOQQWAjfm+4MAZDw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,304,1732608000"; 
   d="scan'208";a="115890935"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 21 Feb 2025 04:27:34 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Fri, 21 Feb 2025 04:27:33 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 21 Feb 2025 04:27:33 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.46) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 21 Feb 2025 04:27:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EX2yGRDsfcvs4J8vQcW7u8zKhjec8xleVQC/llGQZJmHSEe79daBxIbTF4YTHBpMdpjq50GIIqsixmpCw/Q3U5zbILFKS5V7rBxy7a8sRjAq8i0wEjz57Gi8y8wVvuw04JUj2/QDv8WtV1XJ5FyoDzH0JRnQ1HVFyN/RWnVB5PFFyazfDJBYHSiN7KRXAUmIycNBsDAciJPWaHMYHxnCyMEIhl8CjCfT8PCKqxYohk7SJqMfOF+IBpXuweKk+uUGTWb7zt/XktETofX6dmPwohLcqbnSo17SjE7T7MP5gs64LpmYL4hHW0lgwmSfUPQ+jEKEHxhwudHRFS9jQfI7cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D75yu9jyogR64vXG2/Itgr/GqyFNS/hZJQMjXddjg1w=;
 b=esfd8X1mlfKCik6QNnaPAco2VR3OZQpKONl/4GKTTKX0Q92fcuHdP9nVR+7wNp69e7ykoG13PJhUlWgog6ljCi4yOZlBSrmNSHnoiEv9yTn60Ilq5KhrGpv033nu6rAjL7tZy+4oDxrFLlZFENeWpX/T0dWnGhhEWm8/znuIx0vkov225vptlENI+d2voiSTAkDQ6aC4e+wUvmXMJyQXrX1+uS0chRmrFMMPWx8ryuOVeQ1aJlT68HsYnM300Atb0G6t54jvG9ug1lSBop0VJ7ZFdM55ZGyufH8+6Cj/OR1ucjmtkJJ/vZtn0rKQSFe6hhFuHXMCP9fkh4Z5sLkwcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SN7PR11MB7539.namprd11.prod.outlook.com (2603:10b6:806:343::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8445.14; Fri, 21 Feb 2025 12:27:03 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%4]) with mapi id 15.20.8466.015; Fri, 21 Feb 2025
 12:27:03 +0000
Date: Fri, 21 Feb 2025 20:25:47 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<seanjc@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, "Isaku
 Yamahata" <isaku.yamahata@intel.com>, Tony Lindgren
	<tony.lindgren@linux.intel.com>, Sean Christopherson
	<sean.j.christopherson@intel.com>, Kai Huang <kai.huang@intel.com>
Subject: Re: [PATCH 20/30] KVM: TDX: create/destroy VM structure
Message-ID: <Z7hwy1K00fqBkUrK@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250220170604.2279312-1-pbonzini@redhat.com>
 <20250220170604.2279312-21-pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250220170604.2279312-21-pbonzini@redhat.com>
X-ClientProxiedBy: SI1PR02CA0036.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::20) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SN7PR11MB7539:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c9bf58c-9c51-49c1-7283-08dd52730bf2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?SUhyFhyb3oVtprkrtjXaExO9cvJyak15sW5lEGy6fwFYcmr9nZ3E22TCxna8?=
 =?us-ascii?Q?LxoU2nrhNiyG3N/XS4a0ZWA9crU8ABieB3YAYZYY8iF9bi8uTnVzPGqvvUzl?=
 =?us-ascii?Q?q0Mt384TYONJBqI0KQBH/mqzazYSqGtDlHwvqUK2jut+hxMnRL0F8A45MAcw?=
 =?us-ascii?Q?s3jQ/iuZujRRXUHNsa97colMRtIliPeCZu8LCRMXVpjwm+H3aSX0jTvg8yHS?=
 =?us-ascii?Q?MrAD4UoBNljb4xM2XqSs5skBti6mv5ByjnAG1UDxDzBQnHlU1VadPkTmOzuO?=
 =?us-ascii?Q?xdQd7FD+bicvFj+/EihgutNpTk9IG04dgDQwkcXw1UpAg3wJnnxXLs2oO9tz?=
 =?us-ascii?Q?t++1U7bPZ1+6zTbSfCFYhZNb4M6XnKGeigsh04KmHV8Ghpiw4hKKTrblGWvj?=
 =?us-ascii?Q?KSGrYKJPqtxDwBrA4zISjYpKD9qc1nPnyNyy0973jdpGFSoEbOl3Y3xOs2lx?=
 =?us-ascii?Q?HSDccqXzIUOtsux3SY2NiclogAZYSrwe3gyWjkZdu/r9gRq/dCRnUjgi3+CZ?=
 =?us-ascii?Q?02IezzC/zFJLQAodUQnp+y2yFwUaBuOuaYlCzdY0xIivDD9TsxJpEL8ZThWw?=
 =?us-ascii?Q?eY8I/C8aQ4cMaXyitLs9XvbTd0U27N7Bf1xWk1hnfO83AH5SP1aWCps+UrBf?=
 =?us-ascii?Q?4rseaP2reEFBXbb9bEP1Of0dxzG7XXVCFQpM9TWWmf7TH1qyMvuHN3bl6dK3?=
 =?us-ascii?Q?UqRi4CGbCGvY4N/ZaN4ecvlW8syGLN1Sn5Lpu0ump0+qxhI6DHRNb8YaoFoM?=
 =?us-ascii?Q?nKCLrw4cyuiNIezYXUmCRifXX8odVV3e1idTyeTNkhapzlRkMCJATo68t0uW?=
 =?us-ascii?Q?uGBj5bLZawhMt9iV+hfoIGl0YJI8B6OXGcP0BcQJAeRdH4TNryabMtVgq5CN?=
 =?us-ascii?Q?9/54AfK5hP3F+LgRMS0qcOTKgv5WEfIaGVvh2HFSqM146us2sdL09pvm4zoZ?=
 =?us-ascii?Q?dOSzcqZ+Q+AVXEjKiVaxCdOr4rRfu1y70T6CmqmmJtkhMP8J26uYaLahNbNU?=
 =?us-ascii?Q?NRMDwlF7+Jk76S6tv/On6jHXUMX6ur75cx1EO3kBmuCNUZ745jwE2L1tsO3L?=
 =?us-ascii?Q?QryVn981b5sl+pT4KxF4XPradlfYpPMwcvw7JzGeCTHH7bO2LdPU8wCPWJXB?=
 =?us-ascii?Q?dsRV714KcqWqEN66blUQ4N06pN0LAIAG1fjla2GEt/Mp1r4GJxB2FwjzwB0P?=
 =?us-ascii?Q?iM6jaT5PmROat3870gQ+syiti0hWLlPZb/jBRrm3P5F/FDzooGRHEm08vwf8?=
 =?us-ascii?Q?mPTIufSXuNdk8vyxH2T15ZIx1WIOh0VWNLdZR8etykPObelDnL0nh/iMsiK8?=
 =?us-ascii?Q?HDMEytAVTX/UN93BOVA6J0wbwnGXWxlMZGX1Wl6m+SVJmw=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?D1heNXAjms1LK6oVNMbHUbqa2kAUcZGJnceDVX/t4NvdotvmysToEA5NvTOX?=
 =?us-ascii?Q?X00+qpQQGNOYDnrkeVr5qiEtJtJ1XERJarVKRW8E6TBncU6XLf+M7ElcCxQv?=
 =?us-ascii?Q?7OFAtUQC/DtGPYdeMMVE55Uy8KiTlDF1EJGj4yziWImh3TKQbEjQUAZQa9vH?=
 =?us-ascii?Q?A0ryVIgL5Of+u2WZEXpTyo/CjxYN5RlixPx+Shs70y55ooQYnlXHicAbK3h0?=
 =?us-ascii?Q?bwHjh0L4lwShnci24n9/7NiNUt/7mtY3MuFyWiIrzIRdZxMBWAkBz5bXaUSJ?=
 =?us-ascii?Q?dHVNd6XtKZCBhDQoIez4gK5x51yzFQfcY7oavLeS804qrim9yZonDIz4pOGo?=
 =?us-ascii?Q?8gNjkwUv3w5M6sPIVHIEgF7eXsc5/amF+oUVZCRVjEYByAUz5MThQABAcway?=
 =?us-ascii?Q?hT7hBuMMPhBoExESENzNOy/q/GWOYexuNDibTF5AxCxnqv0IXrfcMYYOTOaM?=
 =?us-ascii?Q?qq2uDrQoHgaF05662g4aCvKZmXmBtT0FgjXksM1J4pM+WT3OjtT2gA/N5oEb?=
 =?us-ascii?Q?PLUwC/9BaBne3ovVVAoJOWpvWdsYJud6l8abd6xySKa94MFQwX+dHmN2v1w5?=
 =?us-ascii?Q?VrMgqyB24MmZLfdUbSlNmtN2Y1n7LTSr47/tcnPAnM0EzpqmA63FhPMljc4a?=
 =?us-ascii?Q?zamZ3Rcpy1UwYIEbQAtBkf/kovjzc9CQVPxLFGKcWOBk9pnBA9l+1btZjvNX?=
 =?us-ascii?Q?j3tzPfm3R/QkbzbRZ3v/hfUnrAwZP90j2rcGd8QJ0+ty72knKVvLTXiu/i25?=
 =?us-ascii?Q?ZSjnotEtgJvt9h14LtxWDY9dzpD5eK0x1oSOBgTk/uEStNbQDcBaEUR39U7n?=
 =?us-ascii?Q?rzqSrn+zebOLJVd+2GkpTLwHObOdJakndLvPJC4NWbIFNvcearOOmg327l3e?=
 =?us-ascii?Q?4Jzl/lSmLxWAqqAOmOZkuXUkZ9QYNtixK7x+ydp0ytnIcHK2sCLJ/n3gjcZc?=
 =?us-ascii?Q?EnFJtHZB4LO2ULZpAO8arY+s0Olg+qGoq9QrsIDM22uR6RhEJT1wX2er9oJk?=
 =?us-ascii?Q?NUhtIRFg0A7Bsovl+QhwioYaTm5Vz5AT7Yyc4xNnHgguBoZxDn2F4mS+/H9Z?=
 =?us-ascii?Q?V2Cmo0eQHGtcAvI5u/EyVMGVFTsYmspMImcxxw/pT+n4cM1bnaNzKKPyS0T0?=
 =?us-ascii?Q?wtXlXHNNi7eduC/c3fjO1jlBj7a1DQptJv1nybuuIqD7AfAYOypzQ0UuXO2s?=
 =?us-ascii?Q?TeDMVxNs5U3Ot+Z0/80UhdYpb4z/um6sKDp44rGdhXDOjl4lIKP38VSnmet/?=
 =?us-ascii?Q?I6WTNgfhwpvdQzFjLBREjBL398bs6Z6x5Zh+cDbJwHod22dxiY2RlINReePa?=
 =?us-ascii?Q?pXjkFRLCrOyKft5nIRbkZotBWd7Yd6SqGEXcfR0zDKdjjUXI7h9OAEkTiTRR?=
 =?us-ascii?Q?lIF7zXDFPFPOkeP/5DFpUwdhgjLGnc3fK+eZ2tFM6mfc/7mFPdONLkl7+s3g?=
 =?us-ascii?Q?tZovTSRlXUMlAUymVolVkxo1cDUQEyYxEWA5M/XS7Vi12bLd7ZK79eCscnZ/?=
 =?us-ascii?Q?0s7Opjberx3MR15cIkxdax9BO65lwnF5cT+1Ble4xr3JqEXF2urftHrJSQJE?=
 =?us-ascii?Q?GM+gaKEcidfRDaOLrABztkJtAP2oJKnCM4fJF4Zv?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c9bf58c-9c51-49c1-7283-08dd52730bf2
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2025 12:27:03.3290
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BoOILkJUV7Sob7v45ncwtaCfLDmtZlIutUXdKgj9BGec5URtFrafN22EN8nSTXibYDxdKCSsmtV3XgMsmJEMWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7539
X-OriginatorOrg: intel.com

> +/* TDH.PHYMEM.PAGE.RECLAIM is allowed only when destroying the TD. */
> +static int __tdx_reclaim_page(struct page *page)
> +{
> +	u64 err, rcx, rdx, r8;
> +	int i;
> +
> +	for (i = TDX_SEAMCALL_RETRIES; i > 0; i--) {
Yes, the retries can be dropped according to the previous analysis at
https://lore.kernel.org/kvm/ZyMAD0tSZiadZ%2FYx@yzhao56-desk.sh.intel.com.

Currently, all TD pages are 4K and even freed before the hkid is released,
before the control of tdh_phymem_page_reclaim().
Non-TD control pages are also 4K and are guaranteed to be reclaimed before TDR
pages are reclaimed.

So, for basic TDX, contentions in tdh_phymem_page_reclaim() are not expected.

> +		err = tdh_phymem_page_reclaim(page, &rcx, &rdx, &r8);
> +
> +		/*
> +		 * TDH.PHYMEM.PAGE.RECLAIM is allowed only when TD is shutdown.
> +		 * state.  i.e. destructing TD.
> +		 * TDH.PHYMEM.PAGE.RECLAIM requires TDR and target page.
> +		 * Because we're destructing TD, it's rare to contend with TDR.
> +		 */
> +		switch (err) {
> +		case TDX_OPERAND_BUSY | TDX_OPERAND_ID_RCX:
> +		case TDX_OPERAND_BUSY | TDX_OPERAND_ID_TDR:
> +			cond_resched();
> +			continue;
> +		default:
> +			goto out;
> +		}
> +	}
> +
> +out:
> +	if (WARN_ON_ONCE(err)) {
> +		pr_tdx_error_3(TDH_PHYMEM_PAGE_RECLAIM, err, rcx, rdx, r8);
> +		return -EIO;
> +	}
> +	return 0;
> +}
> +
...

> +static void smp_func_do_phymem_cache_wb(void *unused)
> +{
> +	u64 err = 0;
> +	bool resume;
> +	int i;
> +
> +	/*
> +	 * TDH.PHYMEM.CACHE.WB flushes caches associated with any TDX private
> +	 * KeyID on the package or core.  The TDX module may not finish the
> +	 * cache flush but return TDX_INTERRUPTED_RESUMEABLE instead.  The
> +	 * kernel should retry it until it returns success w/o rescheduling.
> +	 */
> +	for (i = TDX_SEAMCALL_RETRIES; i > 0; i--) {
> +		resume = !!err;
> +		err = tdh_phymem_cache_wb(resume);
> +		switch (err) {
> +		case TDX_INTERRUPTED_RESUMABLE:
> +			continue;
These retries may not be removable as tdh_phymem_cache_wb() is an interruptible
and restartable function. If a pending interrupt is detected during operation,
tdh_phymem_cache_wb() returns with a TDX_INTERRUPED_RESUMABLE status in RAX.
KVM needs complete the cache write-back operation by resuming
tdh_phymem_cache_wb().

> +		case TDX_NO_HKID_READY_TO_WBCACHE:
> +			err = TDX_SUCCESS; /* Already done by other thread */
> +			fallthrough;
> +		default:
> +			goto out;
> +		}
> +	}
> +
> +out:
> +	if (WARN_ON_ONCE(err))
> +		pr_tdx_error(TDH_PHYMEM_CACHE_WB, err);
> +}
> +
> +void tdx_mmu_release_hkid(struct kvm *kvm)
> +{
> +	bool packages_allocated, targets_allocated;
> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> +	cpumask_var_t packages, targets;
> +	u64 err;
> +	int i;
> +
> +	if (!is_hkid_assigned(kvm_tdx))
> +		return;
> +
> +	/* KeyID has been allocated but guest is not yet configured */
> +	if (!kvm_tdx->td.tdr_page) {
> +		tdx_hkid_free(kvm_tdx);
> +		return;
> +	}
> +
> +	packages_allocated = zalloc_cpumask_var(&packages, GFP_KERNEL);
> +	targets_allocated = zalloc_cpumask_var(&targets, GFP_KERNEL);
> +	cpus_read_lock();
> +
> +	/*
> +	 * TDH.PHYMEM.CACHE.WB tries to acquire the TDX module global lock
> +	 * and can fail with TDX_OPERAND_BUSY when it fails to get the lock.
> +	 * Multiple TDX guests can be destroyed simultaneously. Take the
> +	 * mutex to prevent it from getting error.
> +	 */
> +	mutex_lock(&tdx_lock);
> +
> +	/*
> +	 * Releasing HKID is in vm_destroy().
> +	 * After the above flushing vps, there should be no more vCPU
> +	 * associations, as all vCPU fds have been released at this stage.
> +	 */
> +	for_each_online_cpu(i) {
> +		if (packages_allocated &&
> +		    cpumask_test_and_set_cpu(topology_physical_package_id(i),
> +					     packages))
> +			continue;
> +		if (targets_allocated)
> +			cpumask_set_cpu(i, targets);
> +	}
> +	if (targets_allocated)
> +		on_each_cpu_mask(targets, smp_func_do_phymem_cache_wb, NULL, true);
> +	else
> +		on_each_cpu(smp_func_do_phymem_cache_wb, NULL, true);
If either packages_allocated or targets_allocated is false,
tdh_phymem_cache_wb() will be executed on each core. Then TDX_OPERAND_BUSY is
possible since tdh_phymem_cache_wb() needs to acquire a per package wbt_entries.

So, should we add the retries for this rare case or just simply leave it to the
WARN_ON()?

> +	/*
> +	 * In the case of error in smp_func_do_phymem_cache_wb(), the following
> +	 * tdh_mng_key_freeid() will fail.
> +	 */
> +	err = tdh_mng_key_freeid(&kvm_tdx->td);
> +	if (KVM_BUG_ON(err, kvm)) {
> +		pr_tdx_error(TDH_MNG_KEY_FREEID, err);
> +		pr_err("tdh_mng_key_freeid() failed. HKID %d is leaked.\n",
> +		       kvm_tdx->hkid);
> +	} else {
> +		tdx_hkid_free(kvm_tdx);
> +	}
> +
> +	mutex_unlock(&tdx_lock);
> +	cpus_read_unlock();
> +	free_cpumask_var(targets);
> +	free_cpumask_var(packages);
> +}
> +

