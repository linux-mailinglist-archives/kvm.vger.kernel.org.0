Return-Path: <kvm+bounces-49261-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B844CAD6FB4
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 14:05:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 643A716A41C
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 12:05:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F85E231A23;
	Thu, 12 Jun 2025 12:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LRG/GW+l"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DC89135A53;
	Thu, 12 Jun 2025 12:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749729897; cv=fail; b=BJwvcN2ytn39fS8eG64mgLRYS6qcpCpq+NSVm1Zy4rWqtgM0Vu4ecVlLPOg/iSPPqyAr4vFo98LUH9df7+A2HmoGuI9uR4YId8ix4xpYhhuqxpPzirUYunNZQ8u4Oc1kSnfYEI8pkiZVh+rEtXSomiuyrjgTvpao4yqDmPdqn50=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749729897; c=relaxed/simple;
	bh=hrNlxAFmsVOl6HiTNWKtZjZ2KNaiQrMDv+sXwHMfRBk=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ssJyyRobMzypbEFD3FpLY8NyY3wWoJBtWAHBDRL6vTjEacqEoAPIze55axFA7UkXbYj+iGLgZFCxQ2KFOt16AY7YN5KVpX5k+r+AoNVBUghzm0CfV62gcUPPQqhiVF+GzNxeIdHS4IECp4HOMHuhglcILGOFY+8LSxm8fm/RZhI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LRG/GW+l; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749729895; x=1781265895;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=hrNlxAFmsVOl6HiTNWKtZjZ2KNaiQrMDv+sXwHMfRBk=;
  b=LRG/GW+lnRx3LxbJGD+TdpRRnKnhabd+Zl1gf47XPVbodd1taznEDCCV
   Ylp9uQ5PTnt+y8O+0w//WbLtM0KK2OgV90nqSS/lIDgRKlIZf9fSn3he5
   e52Q3TtlKRGSjxeV4LtMfu8LCGGYxP3Y16cGthJuzHqRA/uq2qDfrVlFP
   lPqct+IvQktSDnSmxPivOOVGwkUDiykh9jTN8WtSXYPEcMx5EixhHrcxT
   mAasnXQPbl4vtp2ZDGjubGZIwoeT3F+Wn6vvUMZxe8FmItyF9vUg8umyC
   s/2Sw3jLKXXGgLNGImgYXRyofBJc+o9EJ8TRKZsYjnRC9B5ZAcHGHotD0
   A==;
X-CSE-ConnectionGUID: g6bjmCigQwyW7H0fgp/3OA==
X-CSE-MsgGUID: XpWK8LU6QCqi28FhHCEMQA==
X-IronPort-AV: E=McAfee;i="6800,10657,11461"; a="51822702"
X-IronPort-AV: E=Sophos;i="6.16,230,1744095600"; 
   d="scan'208";a="51822702"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2025 05:04:52 -0700
X-CSE-ConnectionGUID: osHUsb9WQGSZEebfUBrrIQ==
X-CSE-MsgGUID: JBe7R2yCTQSvYxAfvuPDYA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,230,1744095600"; 
   d="scan'208";a="147490509"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2025 05:04:52 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 12 Jun 2025 05:04:51 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 12 Jun 2025 05:04:51 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (40.107.223.78)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 12 Jun 2025 05:04:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NL4dWamf1k4PydIYq3Pr1F8E3LZO8JxitnuV3WnsTNH+wK8eyglYbWekIYdfncGlkd+uzbgph3BRkAXdc6LmMCuoLvL7frzO8xVvPk6GN8d3s0w7XWaCEjsiT/fKkq4wCicJrbniq8fl7nL23fYEFrYg0y0qnWRr5BiuGJ9HDTmxuwpDAH22TtQtTTcg9HndtjXQc5mFuQ+gLsC/nBNYTEn2Pk8Nmr8XR8RrJ9SBGdowZozJVqS59Zgr+853eYIyiyxKh6dSDxpIHtk+p7gGJ3tqeZb1UZGGcNTpp8PkKuPtYWZkqK5DHUaGbMq8uKxv6k1LPCm4L5hsYHwbtQNtqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3GsEEEoLiZxo4f1rwesN4lHgxV5j5apGlH52BbrC6a8=;
 b=gD8EnFxpxRLjLdihq3ei104V7stPiV23PUK7/3tF+yzVGkLsu6yPh0j54txue1NoSixQ0Y9NaHw5Wod/pjPJwHCe/f3EG6mYcB7QkVQ/JZWCwGpxpEEH8xG6W5mmrkOjbE7SYXwl2h2cQrX+jhSQrxIWH/EON08qdVvjJGVPiQiy3DQdevieVj7z4EwNKroFjgJ5teDcBtZFmkO8QE2S3vvzeuUfCzaCqhcBR9r2Qo1C+B4342fla0rygjft2ZF2aLahEZSChF6oLjDRFNzS3S1+ozT+atOjbBUkI+lcLcD+3Pf1Wfgsxa52ovkWGCExjessgf9CqDv1ESx40eCBZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by DM4PR11MB8177.namprd11.prod.outlook.com (2603:10b6:8:17e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.31; Thu, 12 Jun
 2025 12:04:49 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%5]) with mapi id 15.20.8813.024; Thu, 12 Jun 2025
 12:04:49 +0000
Date: Thu, 12 Jun 2025 20:04:40 +0800
From: Chao Gao <chao.gao@intel.com>
To: Nikolay Borisov <nik.borisov@suse.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <dapeng1.mi@linux.intel.com>
Subject: Re: [PATCH 1/2] KVM: x86: Deduplicate MSR interception enabling and
 disabling
Message-ID: <aErCWBDT4jZQfNXK@intel.com>
References: <20250612081947.94081-1-chao.gao@intel.com>
 <20250612081947.94081-2-chao.gao@intel.com>
 <37aaaff2-2519-43b3-b388-eb0185e03c41@suse.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <37aaaff2-2519-43b3-b388-eb0185e03c41@suse.com>
X-ClientProxiedBy: SI2PR01CA0025.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::10) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|DM4PR11MB8177:EE_
X-MS-Office365-Filtering-Correlation-Id: 3b5bc94d-e79e-40f8-4871-08dda9a954d9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?gQs4LxkbSkWAqtuOgRZVBfcilCnqUahJ6vH1QiRHCsWosGeukZlY2E0PGIzL?=
 =?us-ascii?Q?cAikeTCfymluppuFTbSPsZ7lOtwLArEIIQbB1y9MqMCIhfQSmZvRlki6MxUT?=
 =?us-ascii?Q?0kjKY9rcI+4euHw6MvQaUp7/N+l9+uDnTMyf3g3POLvI1CCYPgL4gB+UaL55?=
 =?us-ascii?Q?mIJi7c1qRNrN5xBENx+dc+rcQwvn4i8MBo/ywMuVmTBqsQmTXdeSxfWPFSnl?=
 =?us-ascii?Q?4D556JR2/Uh/uxzYOWYlh8Jk79lD4sVqhN+SU6PO7CS93/0/UWAJufCCjjzT?=
 =?us-ascii?Q?nEAPOyWXjNYkwKVwRoPgBBWxkCPWM1jZ6pgAkZhskOyF6W3hJeofL6bqPVPm?=
 =?us-ascii?Q?tIATD0raC05Mic0cndTtv21JErxIGq+I0zTc9gFuy2jlkRlKEBrq5BLrau4J?=
 =?us-ascii?Q?R4k5O+TUcCWPET/gfqjx79zjxmf1ymW+AGzC9M5J1kG5TxacB9H+2LHD7K5H?=
 =?us-ascii?Q?5Jjf03N7lQMzMlmRJHALN4kns0d3Q2nAZadC0kMAl0kPWuwo+LylOm+SCIhl?=
 =?us-ascii?Q?B2lrTSvBpNHGKHEb8pfeySZmgEmASMj6E2jwOw5xJOoF1BvdjZpsI5yMOvjv?=
 =?us-ascii?Q?sBCtTCXDbv6BRJNmBTWoZ/rZvHEC1PzPCNmK2RyNbOxfuizVWuSdNdWs5U0J?=
 =?us-ascii?Q?DRRfw5rVM2lRGgfM1zPsa8/uJdxjM8viXJp0id7AU+B+ULjyjucddUKkvjue?=
 =?us-ascii?Q?/ZzmlyuPP1T/Gy/yc1H/AFwOoyixuLURCvx2Ph70jZqTH3sexPjaNHqNsFbv?=
 =?us-ascii?Q?cmmDSA95JLz5o3pPgQgxlVbOSC4HwIgcZ8fkzJHylzgUf0/nEZlUp8j1W/ZI?=
 =?us-ascii?Q?BQpC19JSMg5+mER//hHPBylNlVvXxXcJv4vETPPhEFjGP0YYBqTXfe9glE3Q?=
 =?us-ascii?Q?Q4sFT+l4Ry9SPIVGGjjXVGBvXwezjRAVFibxYjop0qtsRw4dCiyAJzjxEfWY?=
 =?us-ascii?Q?Eir6EqW0V7XTnOCPMPO0X9KoomRmpAMM2aWFVN2V64m1/GWNsmG8a88N2A/1?=
 =?us-ascii?Q?8N5UGQf5mWadSZd2T9BIWd3Ypa0bQcZhShRBG1uj9S2vjBIwoiYWdDhrm/KU?=
 =?us-ascii?Q?y/gf15bHiLAdbd7sDkxyb6Gw7srvfPIKA11bKmq88GSkL0DF1d6RkSpX+4Z5?=
 =?us-ascii?Q?eruz0yLKsHV4EQ3yu4Il7bRXqptHLnhSyVy7N8MKvTBBrpE/2aEaxjRNTUbS?=
 =?us-ascii?Q?yC7F8IhNrdXxJLGCm0X+TLM7nh3WLrvHd5BXpn1jtill+w9CTU6pDfNSZ8uy?=
 =?us-ascii?Q?itOZV2+tUvKMk+AwuRpFvEIWQ0HBq5Elch4OxwTj4qKLZ6fVWR1+IF6Dq0gW?=
 =?us-ascii?Q?vAULmrsWLDZfmiYTHoSlFvfwNbpLUbOJtm6fXnIX4K7rXCLFidHD1BB7hFZC?=
 =?us-ascii?Q?Gpe5Eoi5wwpeN4qnoXNGzlAw9+RlpKi5UGQU8M3sNHtutDjefuZQUsMEXjTW?=
 =?us-ascii?Q?zJil+KFS5NE=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OpnBZpn8vgYL3l3KbILxdmwtGlKmUXRGd0XiipVCHgsYdbjj+0daZs3WoNwE?=
 =?us-ascii?Q?EO9SgN3XwnJp33O7LwCPBv/1HBizJ0tBtsUFjllQMC6FZ7UmaKwcN+h8AvhW?=
 =?us-ascii?Q?63nUd3+Fuswi89NpC7UYtWoZYcFQIrVMuZ/UEHEHX05eLzrhsbil2HWr1MZV?=
 =?us-ascii?Q?WzXoldlQvRFXffwxPMOnavtWrZZC2odJJNyYvCfb3TXj7jacMk6Y577TqVit?=
 =?us-ascii?Q?Ci8yw5vPm8+qCs7UcKppoA4FCd42EkYYWrXmWT5yjlD5v5ouOuHxQ6vP+W3k?=
 =?us-ascii?Q?7KxsgeREr48l3w6yoTD6EsPQtdOp5wjBA1G+mCdqGMNNJdC3i7j+Ar8NATWm?=
 =?us-ascii?Q?rTTe9jKmpi7GLKSkAVHEN2P2JP8hIQDkmFf+75u8JTzwkwCngK0AbA9cBJ7W?=
 =?us-ascii?Q?MhQJFTiP81eLfruJ7u/dYICcKfYEuPTZFEbvqIbIToaWMDDdLe7YFNyGfqkr?=
 =?us-ascii?Q?wZuiUdI4HyKhJ7ofceRFE3uPNugcqfWLvPa7vriJvTqx6vv22mbyaUEg8Ybu?=
 =?us-ascii?Q?ixUd5hOPdZLp2LIvPXi3HM1NTva0ImyIcghqT7db2RIyXVRfWybylbIPPUU2?=
 =?us-ascii?Q?Vt3E+myd5/4/KtETTQ50kKLLJoPxE7+EivAc2karppiRnzdFB8jihUF+Iq/q?=
 =?us-ascii?Q?bZNtwHuZCgk4qP7ls6hRIbHc6dBD0PyFnGhHEaZPBhCOuwFKB1u6dZl82OPa?=
 =?us-ascii?Q?CGBzq/nRdtErLVXDr2trfAlJ0WsDmc7Q1lZ2I48d+FvdL5NZLeeZpVdKgHI4?=
 =?us-ascii?Q?YY5+Y/obP7y8eaSXqwX3lIiVwa1nNxJgiBAyI6KNISjcU04+bR3TElmbszUu?=
 =?us-ascii?Q?g1U2xhczRtorjr3/LPeBqAg0w71rApWmTmHTzom75bjCsPYPLTMJL+BAagHY?=
 =?us-ascii?Q?A9DqK650HLMR/irf9dVU9YkiOscdB35xnfXPq3bNzhimiY4T1b95NhWIff4E?=
 =?us-ascii?Q?gB612nZxdMlU9SLZvcMlr97VQioCqL0U6bKCCctA9qg3roKKVptXaZtu+1f+?=
 =?us-ascii?Q?8A9+g5ruM2X6p/xarIXpZrMshxMZAR0LQHM78IxWwKk9SM1MwcBFLlyQYRtB?=
 =?us-ascii?Q?0hJK4QiiiH3kRqB89WV3vkWJ1kkEyMZOAxYwJ406LCImFi1RfJi+aS1o7LIG?=
 =?us-ascii?Q?qpPVLgMyhsijmi/pfqYqE1/HBVPgWLOgRXIAXqX0CmvwJG0sgfCs4kLVZSWn?=
 =?us-ascii?Q?aZ9snQ9xSDg0X4detg5H03h4Pj9++TEAmMC480lkT/RS+/BX+VSGRFhGJf09?=
 =?us-ascii?Q?asK2kqe/wMtE8IxrEvGJPsn9dOx5bxM3BKRQPL3ZbecDbzmIDgMbcGfXMFng?=
 =?us-ascii?Q?/GC/yWO8+T5IerI94YjAWAz5EzC4kHv3YCL5rDzUMpRirmwLG4etKYZ3s34X?=
 =?us-ascii?Q?8o1/LZGBdfKJOAOW0JFQmlnWxkJmkoq+aGskJZwNK8q8aFAiJsLDXqjUIQ4w?=
 =?us-ascii?Q?wo5GbpQZxcWYj0SKKX7DXfGblkh3x7nmaiE5e0JcRRNF7VSk3gfIR35NgRlH?=
 =?us-ascii?Q?gyjuzkLhGpm0NVnoOp3FkDLrigYqBE7sM5lKONJhkeieE9XHeFYheGXehwQj?=
 =?us-ascii?Q?sGq0SGaw+5wOm3NW+oX6JHc/EWycsCU2KYnl/EMM?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b5bc94d-e79e-40f8-4871-08dda9a954d9
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2025 12:04:49.6549
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g0sfGj0N2p+XB1Rre2QVucbcsXUIQ4o9sUmHFA4UXSnntlogTumpNYr9ePdYRbrZUCAZ7hLqWTQnt6RkFNgPhg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB8177
X-OriginatorOrg: intel.com

On Thu, Jun 12, 2025 at 02:25:04PM +0300, Nikolay Borisov wrote:
>
>
>On 6/12/25 11:19, Chao Gao wrote:
>> Extract a common function from MSR interception disabling logic and create
>> disabling and enabling functions based on it. This removes most of the
>> duplicated code for MSR interception disabling/enabling.
>> 
>> No functional change intended.
>> 
>> Signed-off-by: Chao Gao <chao.gao@intel.com>
>
>I believe similar change is already part of Sean's series on MSR intercept
>overhaul.

No, this series is based on Sean's work and can only be applied after applying
his v2.

