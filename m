Return-Path: <kvm+bounces-35353-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C5BF6A10198
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 09:00:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7997B3A85C8
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 07:59:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A5DA24635A;
	Tue, 14 Jan 2025 07:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BD8u2Mp2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D289233554;
	Tue, 14 Jan 2025 07:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736841593; cv=fail; b=J7VgKisPdXRHwPdB+W4PlNBnDLU493eDcZGvLhQ8+Vx00eY4A61oUrMWIWaL0kyfgCJBVOPL/26rrws0ntzI88vcqsMYg74+PPiiGsQ4rLtv6eilf/LqW1SNg5ikf5jhCUMtvWk75zqYxRIk9c1gNvh8EYE9xnnDxbVmq0Fsfc0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736841593; c=relaxed/simple;
	bh=ZfOMC3ktVXvBevZcRS2kGSBGrqkbMBIzXwnnmBPsX9U=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=i0QJ/CrED80gqdmM02/AgwOIdvRkjb9U4AFA8wyWD787LrMRjGOTPz0EwPPEcAPlSTx5xcuviYWoi7wQEUFLBa0lXnjktrc4C7a0ZFjoMubBMLB7qWvbs6AgTxtiY05/NrGObo4x0fWYDy5gwDqCp0s6eOioVkFIkVzN8JiKyR0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BD8u2Mp2; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736841591; x=1768377591;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=ZfOMC3ktVXvBevZcRS2kGSBGrqkbMBIzXwnnmBPsX9U=;
  b=BD8u2Mp2LrFWkBUPk/o0xphuNNG7XtNV9D6H12loGs4dQGZqyV8duG2Z
   wKQeo2bUDYftgqCEvaEWqJ3o14QUdEADTYrJ9bIvLSow1r+/iUjywzfo0
   RArm3921Og+lpFwOJUxlK3rLdHtHz1IuyQiYfGFDBt+UGVOfLUlHP/ww5
   95mIE8MxFlFCRNuBq5ypWJJcuA4wZ/WeqQmCD8Y0Dj0Pyk/7ZAfc2eN44
   j+pWsarbhNAxli3jdftFg+z9Emq4p7McDQ/B/fPWsDe3B86PyD3I2Zv/L
   kOLTpOY0Z/8n+NDaGhfz7gX7J6CFcTs+iOiKEGXCBrChF63w+tVz4bktH
   g==;
X-CSE-ConnectionGUID: NJT3fkgxQyCnRDPEHe/WWg==
X-CSE-MsgGUID: uBwk470iS7ChoVP5vV9isQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11314"; a="48511404"
X-IronPort-AV: E=Sophos;i="6.12,313,1728975600"; 
   d="scan'208";a="48511404"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2025 23:59:44 -0800
X-CSE-ConnectionGUID: XcRcETTuT/2EtfQKXCsCEw==
X-CSE-MsgGUID: 4ae8khLYToqPIrweCgv2Ww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="104597131"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Jan 2025 23:59:44 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Mon, 13 Jan 2025 23:59:44 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Mon, 13 Jan 2025 23:59:44 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.171)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 13 Jan 2025 23:59:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oQ7998sgS7VJ+CMLGTwRf04KXcvG9yMPBZn8dxxalKYnG0o2gnR8K+KNQGnRUBtrV1SUoH3lNauq8qO2ZqGuiSOLHroUziJvMKVer2ZSdZjvXBbz7j5u0Feowr5FDtA6meMC0/YA5mmJL9ZYwBoR9QSRDCHOzRS4W95GE3F3C65AubnjTrhx/1xjul5WEvHWuIDFSkKK9p4DPds3HU4zMuEKYEZoUUJhby6BvQXcIvxR0nffjqdW/aWw58ESQV6j6kPUQCbeYz6sdxeyOHqGWOKblqSyxdngbvIu8ofe7trG29KkVtVwVj74bZEATwT0xdZhP1zBUd7UjKVpDtlS+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=okOqGeF3QA1NQjPdwdulx9WAZzsYWTFihfV3ULCSp0A=;
 b=L68XqS+uZOc5RW1FI8628VEYSqCBp+H7sRcr351gR+tIZt814L4IQgfgK6chHWV3tipAXXPEyMGYsd0u9WYsIo9v1I4M6KJDGxSlxBn+JXAfUTfvwzcPPWfjafIJLgwe6/840GSF1/9XAyDVzYxxyaNjHsJ+v44dNrc96nt2Auc/aEamarKMmrJVUzVjDm+6VlwbyS03XTh7a8RWK5O3rzO1U2Q1QQ+VU82YXROu2PxgfHI2MOL5xWuIHrJsMYI0dBEL4JMJmnLeo4XimjTKpnzJflHjX40h0eFvZMVGY8v7vREx5CIc/47ehoYYkeMmN0LLq25pR6FE9jZoo1QCOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CY8PR11MB7340.namprd11.prod.outlook.com (2603:10b6:930:84::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8335.18; Tue, 14 Jan 2025 07:59:28 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%4]) with mapi id 15.20.8335.017; Tue, 14 Jan 2025
 07:59:27 +0000
Date: Tue, 14 Jan 2025 15:58:34 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Peter Xu <peterx@redhat.com>, Maxim Levitsky
	<mlevitsk@redhat.com>
Subject: Re: [PATCH 3/5] KVM: Conditionally reschedule when resetting the
 dirty ring
Message-ID: <Z4YZKghsVO6nZEYO@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250111010409.1252942-1-seanjc@google.com>
 <20250111010409.1252942-4-seanjc@google.com>
 <Z4S65wQcApuITa7h@yzhao56-desk.sh.intel.com>
 <Z4U_FvvdSBXrzENW@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Z4U_FvvdSBXrzENW@google.com>
X-ClientProxiedBy: SI2PR02CA0002.apcprd02.prod.outlook.com
 (2603:1096:4:194::22) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CY8PR11MB7340:EE_
X-MS-Office365-Filtering-Correlation-Id: 6432f1cf-f710-475a-b29f-08dd34715e7b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Rrri0abp9Hw8oC6LXTeoMMJPH97G9FFubrMLBpwfBiQiZVV+WLBA+RgVczxi?=
 =?us-ascii?Q?RDq7VKIonoLiFWFYtwyLzHiwnR0OSLcjqgkQk4aE2XFdwNZV5dw+IxmTK6O2?=
 =?us-ascii?Q?AHkh2iBi8mN0xWiM62mLTGUXWXXfa1nqGEN9cDeEHg2N5kPwY7UOU1Vlkis0?=
 =?us-ascii?Q?nmUwB288KK6RLrf9RIGkqtfxpCtAB3A/FD3J3ETNqNeC/X8UrVY29U/49RG3?=
 =?us-ascii?Q?CR7Rt5lOsjGUucjtCUNWEUYs5yPirZAcWyIDKNTi419X3ds0PhUEQ3GyyrFN?=
 =?us-ascii?Q?tHQmAsb61D6ggU9zGfWhF19ClEx162z/yKwlL9Zpm0lFygVoyfnWIl2yZLB1?=
 =?us-ascii?Q?tHpYkx/GfKXPyxhGxdzgNuY9gz5zQ46vs3+yfArC87yVBwkiRAQfJLXOiogF?=
 =?us-ascii?Q?8KGhzmh1+UFh4wWecCPFu/sw6vdjSlYv2m/y+kCvKI2llLj+E32R/p3mhOCs?=
 =?us-ascii?Q?46+k1pasdh3TI3Ecm/plLIZWCcMJfSnfqBUsB/NVsRLYDahFInc2i8ap9JxM?=
 =?us-ascii?Q?j7vy/Nl0rqjt81Dmyd7I2MSssacbRzlSDASC2y3apnt0yyZCeqWtHxe90/hq?=
 =?us-ascii?Q?hmMtc88+prqRI2X3diDX5IfiWIaEznUw5dYv0+LdJlwe+8UOlY+QNDdBG0Iv?=
 =?us-ascii?Q?UVbOTWakL9VwivKZ2vB2HwlS0/DTWaqT0VnsjbvTtkgHaqecFR2ZyMjgPyW+?=
 =?us-ascii?Q?UMo9QdN3AI9PVHS33OTvBoC+BysZ9Ja/QNsvaaYLS9WyfFBqvqKsEGrIMzeb?=
 =?us-ascii?Q?wimXvlvKugg/ObJJohYEVTacNXxqO0xer/fTk7Se87Q5N8Jw6j5/fwkbyy2f?=
 =?us-ascii?Q?cQTUoGXGAtz9YAOEq2NKWc1RDpgzgfwWQbaXeM6C0f9Ro/wRa+KG9L6o03cx?=
 =?us-ascii?Q?or1TFR+3brfZy3xzf8kcrePCRCfht4Sv3gDiFdXavQK7Sg4ExQ+Nkh8erizv?=
 =?us-ascii?Q?YVt+WC4s+AZcNBrx/xV80kzzQiYBIHEAL4d+y6eW1WDttQv4/9Gmvq6GncJO?=
 =?us-ascii?Q?7ptzMBabTGdxdC2gDu+xswi3X6K8SzkWFLhRbV+11yDceMf6LLoXioQtjbTS?=
 =?us-ascii?Q?qw+VGMh7K8hEoZ1LdCNlv+i8LA8x6f59APNBaitG4RDOkQjjju+h/mNC15si?=
 =?us-ascii?Q?MgwrCgwlBYW//BFK3vwQA9nqQW2yI5o8VaqW+CNa7lL/lcuMnp3DwhNj7/Yb?=
 =?us-ascii?Q?rcjLMC+UCKGRkmwj0qyt8gKJycZmofBteQjBhzhLsolzNlzLGEPESAAML+Fe?=
 =?us-ascii?Q?Y4os6wE3BYbO1EvxXIwUxN3C8Y//6swoAmfZBbM8GinGiZlKYo7ZcnqJIw0L?=
 =?us-ascii?Q?c7TlQIFoikeWq+vp/NyxwrLwT869sZ/hqnkDDAUfOFih7ycKo+GbejtXAcfN?=
 =?us-ascii?Q?PIzKiu3EoWV3iyDxev1z/Lw4mArJ?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?W7wyRMiWhURL8Wd+aQjSx8xv1duFy751d5Jo7EcyDYfe1VO8oboUQQCeBJKd?=
 =?us-ascii?Q?aBKckjw1rdv9e4dbw6Gn7fbLPumF5Q+hvLGM3kTVDKEnW3goSib7maw0Mq07?=
 =?us-ascii?Q?AYmPMzLrLLFBMU5vqPO3brqLNcfJevYLIwxrRsLQd17YGj/Ej7kx7obXCQlC?=
 =?us-ascii?Q?RxRCNH+il6l30tSPiTqtvTvvYm/YteiGuZc4CfGBsuRBbklbEqV+iAeNyjdz?=
 =?us-ascii?Q?c+Ded9+FCcu1Q6xrseZ9n8g+/1IdR/X7mdqBxTaxSYqtKmuPpzaTJ83lpFYw?=
 =?us-ascii?Q?jacYMo811XDBX0oWG+Pf/OsV+jon6F4XuFaNpj7DkzsVXIjD7NsNRm1ot66i?=
 =?us-ascii?Q?+H4j4pNQcCg6SGNwUU32sroPfMxBsZwiSpnB6al8LZCSQjJ+VNeNTKj4dntX?=
 =?us-ascii?Q?J8u+bvP3YnaxZCQDQheEZvw48+ciImVsNRBrp+IB8eQpwXDEwRGdjnf1oKHz?=
 =?us-ascii?Q?wlUlFNqU5q0ffukA6clEAifLj0uZgTeYDpsQWcADIRvBnEcvQlJw2C9YRRLc?=
 =?us-ascii?Q?5my4b6OTcmrW5+cSVj8mMv6djntjGmOqnicy8Z9jeCB031WLBQr7rCQyK7kr?=
 =?us-ascii?Q?t9grIvKAf3OvkoahQ3CfaBuzKB9QgSAFNxpzk55uP3yBMNpzeFGqwdPjDj5c?=
 =?us-ascii?Q?BQRtt0jQmN5EvbIS34XJAckTVR9QW9bwvPHsBudXxZY9TNWf29F4q3YgF1a6?=
 =?us-ascii?Q?pmGCeInFo3Ddsolm4DCjXY1B4XFwyn/XOiubRXhIbpAv0uKC1pZthusOuVUV?=
 =?us-ascii?Q?92iAWTYDcpYr2JRDXd2vRzlw1Gu4e4qyrc9I0FzEz/Fhsf6wgabfeDpVMZat?=
 =?us-ascii?Q?R9dxJiL4L2jLIa7eGPwGazrwWzlvaznS+P5KPxo4csOy7lSPmKbbQkf4CaPb?=
 =?us-ascii?Q?8NPu2Cq9GhMYLqVl/HDt66r6TVwVjZo8f/9Rh6I9kp1fz+xJDDPc6pN2Bwre?=
 =?us-ascii?Q?iBaxBnfbrzlG/xnk7wTxuQKNEukwVB2e5SMKgXo8qrgqEh3/vv1qk5qIem5Q?=
 =?us-ascii?Q?NPP+lgK78U88VW1A2GLIYr4c8DanKa9vnloU44dv7Z8Aurblr6iuP8SvXCsa?=
 =?us-ascii?Q?QXsux4MjpKrXiIwwghkSoG7luljQqLhZV1eCOdaOP+UwL8gb0jcdSrKCechX?=
 =?us-ascii?Q?a+mmAkfxeDl1YkQPNVZiq3HHUY0zOxaim8KJy3jh8dBtRsT3xhxuD5ZcdVfG?=
 =?us-ascii?Q?uoZgmzPcrZrBzRZAN5OjbWLRatRtp3eaeenzYJ6qAEn2Te3OSWqWTpHxARs9?=
 =?us-ascii?Q?NYontb+jwHrY9IuBVGW2R8zeVdgHMtAmAT958r8ugwa7OebYUh3euhPMJoGO?=
 =?us-ascii?Q?BeP72EG28hL1EvySW+JLUmX/A8tx7Vbj9bfq44oIhDdhyk1tkRzZWoC6rKzU?=
 =?us-ascii?Q?swYXWTd9ZwzmZpk/YnLLB2nwfDoi7b3Tb+1HUJ/B1ZcdWVWmZDG7RHnhdSZL?=
 =?us-ascii?Q?4L5dV/dcO4INpMxX4Fel60aq153pkSDnjoRDIuwaa2uNymeafrE9O9Ox7gyH?=
 =?us-ascii?Q?mc68+zpF2ae+dCUukT9KRcf8zad36OS3GQRhHNaKAfjrIl+c9MhMKVaDlyXm?=
 =?us-ascii?Q?a+0fz7AqgqUsluFrSnpPosM6OssgZSHIzHH38iDM?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6432f1cf-f710-475a-b29f-08dd34715e7b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2025 07:59:27.8698
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DckStK80jfYGT2Vum3Yb1gYdZjm1C7NKwj3NGLnahNcWR4/VxywPj+gj9rzVLVy2F5/2VQlTJOGdIIn6sM7LxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7340
X-OriginatorOrg: intel.com

On Mon, Jan 13, 2025 at 08:28:06AM -0800, Sean Christopherson wrote:
> On Mon, Jan 13, 2025, Yan Zhao wrote:
> > On Fri, Jan 10, 2025 at 05:04:07PM -0800, Sean Christopherson wrote:
> > > diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
> > > index a81ad17d5eef..37eb2b7142bd 100644
> > > --- a/virt/kvm/dirty_ring.c
> > > +++ b/virt/kvm/dirty_ring.c
> > > @@ -133,6 +133,16 @@ int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring,
> > >  
> > >  		ring->reset_index++;
> > >  		(*nr_entries_reset)++;
> > > +
> > > +		/*
> > > +		 * While the size of each ring is fixed, it's possible for the
> > > +		 * ring to be constantly re-dirtied/harvested while the reset
> > > +		 * is in-progress (the hard limit exists only to guard against
> > > +		 * wrapping the count into negative space).
> > > +		 */
> > > +		if (!first_round)
> > > +			cond_resched();
> > > +
> > Will cond_resched() per entry be too frequent?
> 
> No, if it is too frequent, KVM has other problems.  cond_resched() only takes a
> handful of cycles when no work needs to be done, and on PREEMPTION=y kernels,
> dropping mmu_lock in kvm_reset_dirty_gfn() already includes a NEED_RESCHED check.
Ok. I just worried about the live migration performance.
But looks per-entry should be also good.

> 
> > Could we combine the cond_resched() per ring? e.g.
> > 
> > if (count >= ring->soft_limit)
> > 	cond_resched();
> > 
> > or simply
> > while (count < ring->size) {
> > 	...
> > }
> 
> I don't think I have any objections to bounding the reset at ring->size?  I
> assumed the unbounded walk was deliberate, e.g. to let userspace reset entries
> in a separate thread, but looking at the QEMU code, that doesn't appear to be
> the case.
Ok.

> However, IMO that's an orthogonal discussion.  I think KVM should still check for
> NEED_RESCHED after processing each entry regardless of how the loop is bounded.
> E.g. write-protecting 65536 GFNs is definitely going to have measurable latency.
Yes.

