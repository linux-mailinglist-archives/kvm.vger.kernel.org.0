Return-Path: <kvm+bounces-34662-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E7D6A03813
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 07:42:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 687AF3A5031
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 06:42:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD7D91DED66;
	Tue,  7 Jan 2025 06:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ul6kIfvQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3548826ADD;
	Tue,  7 Jan 2025 06:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736232129; cv=fail; b=qnnq2nAQUzXNCTSYGPnq3lxaAjB7jq3ZmjTfPbl0R1TCkCrq34putdiBmnlHndYYWQP+2iJ0BvK+2AMOqw3hrIRp17bo6u9r9jiOLnVLZienwMsaZgqjSzzLKfksPgMZCvc72IeOsHwV9SddvNE+AQY470DiDOv4c4crxD5RCsM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736232129; c=relaxed/simple;
	bh=JtM2JzMH2JSPHRuuUHHzM3gJA+eUtobtNHuuAx/u8Jg=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=pce6yps3WCloi5mkzM92TcarYZOH/EVPqalb7wgrfeTji8wcy6DKqAD1KZfgym4vhEZaX+AZUGFGF6FfNksmcbwXB2PHvWjQt45fmBxM+uAAXAEYbV0QsOzdEQDqAtgF+YoKjIC8DcG94i7j4S8pX01zLrgdI03vTy/UURkQoDI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ul6kIfvQ; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736232128; x=1767768128;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=JtM2JzMH2JSPHRuuUHHzM3gJA+eUtobtNHuuAx/u8Jg=;
  b=Ul6kIfvQOt4dG2JRXKCA2W9ch5eip/CTpNRHIQ568X6z88y+Tvs6x7Rs
   sy5Xt8deeSGyF/jraRJ1ZsH56qV4iWwg2u9LWokxG486sd2deT5DM0Z6Z
   CIVG9aGt5eWXVgfZaLUk4zxv8D/sL3r1ewr2kRUMspKYqg5J9z3EW/46i
   1l32JPii22MRRoZRyzBRvjaKx40h5pza24wXGsX69WY6JkIHXquA9NCoq
   92MHAi3zca8cUoi/poysIl9gKMZy979DmBcxAxmfR4VmM4Wr9Z7+wpC+H
   E4h/kgO1lxzFXz1Z8aycwH9wFyG5QlN0zza7uvk6qFEejUO1OrHrTyKUu
   A==;
X-CSE-ConnectionGUID: vBHsjNibQdyLCWYTlrwQPQ==
X-CSE-MsgGUID: 0Otv5oxWTRuhB3gPgem0FA==
X-IronPort-AV: E=McAfee;i="6700,10204,11307"; a="36278640"
X-IronPort-AV: E=Sophos;i="6.12,294,1728975600"; 
   d="scan'208";a="36278640"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2025 22:42:07 -0800
X-CSE-ConnectionGUID: k7rtfC6SSCq68iHVzF7Jng==
X-CSE-MsgGUID: KeLq1f43Q5uUfnNIB2VDuQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,294,1728975600"; 
   d="scan'208";a="102566193"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Jan 2025 22:42:06 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Mon, 6 Jan 2025 22:42:05 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Mon, 6 Jan 2025 22:42:05 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.172)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 6 Jan 2025 22:42:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w80MQIPVnl/3HOwDo+FXR7Zi5PbMOL/WcwZ3MQr1cL+dt6LpeHXJaulCzV70q2Zqn+xALWjrAGim/sSQT2rOLjDTzak8EOsEEuYrNiz3wZWYz4kkP/BZZ1ge8Ol7A+mY4wJkrVhJ9o0qLJSYR+4VX95vr+sNNxbyO/QmA9NtFr9W+syDKgl6MqXRXMj1hNTWgJ2EJYYlF9xfUleN/gH6w59qJKIkUd20gMsa3ieD+pZeL1sEqqJl1LcTnP6oatN/LQYLz9CYXIR33ggQeHrw/5C76b6k8v9mzByvPIoopjovr8E+Zx/o08h4WGu3adydmHJoatLr/lGAhG8bQ5f5Ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5E9ZfOuvsDx00FXLIH7/g1j6ceBN6QmSLEaa6tNK4D4=;
 b=F88icjoyIJrS/f1yfBnhmp41vW0oiG50a2SvahYRjyjT0r8++PXRgyoznCUjxCAxKOdkEXdjX+iwo4jz/acaeWabRRb8jqnf1HgbmdfgfVwcqTJBMR/QWOAhVv+zUz4niDROMZE6lbR91LL2sngEUk9KDNy7OCiBHYzzxD9xPe9KFackJbYfxLrP7pTLwXRPhfXKxphJ8i8/gncV7+z9wxPjUuGTHRdUdJCJstBVrVgTrkfLMPW6EfSdrovrAYzCWwZotOxSB7+QY0f8BRNfB5X/5X1ntwb2BjCzIEmHepePQPOEtuMMqSJof9tD86/cXs32QxqrSLgMft4FDVnYvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN0PR11MB5964.namprd11.prod.outlook.com (2603:10b6:208:373::17)
 by PH7PR11MB7596.namprd11.prod.outlook.com (2603:10b6:510:27e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.16; Tue, 7 Jan
 2025 06:41:43 +0000
Received: from MN0PR11MB5964.namprd11.prod.outlook.com
 ([fe80::7a0e:21e8:dce9:dbee]) by MN0PR11MB5964.namprd11.prod.outlook.com
 ([fe80::7a0e:21e8:dce9:dbee%6]) with mapi id 15.20.8314.018; Tue, 7 Jan 2025
 06:41:43 +0000
Date: Tue, 7 Jan 2025 14:40:48 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "sean.j.christopherson@intel.com"
	<sean.j.christopherson@intel.com>, "Huang, Kai" <kai.huang@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH 09/13] x86/virt/tdx: Add SEAMCALL wrappers to manage TDX
 TLB tracking
Message-ID: <Z3zMcEdE7gFA3P1C@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250101074959.412696-1-pbonzini@redhat.com>
 <20250101074959.412696-10-pbonzini@redhat.com>
 <fb17ae7ec64fa1eb884ab87b1729cdeb79c32871.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <fb17ae7ec64fa1eb884ab87b1729cdeb79c32871.camel@intel.com>
X-ClientProxiedBy: SG2PR02CA0129.apcprd02.prod.outlook.com
 (2603:1096:4:188::19) To MN0PR11MB5964.namprd11.prod.outlook.com
 (2603:10b6:208:373::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR11MB5964:EE_|PH7PR11MB7596:EE_
X-MS-Office365-Filtering-Correlation-Id: 656e0e73-b0ec-4fa1-c892-08dd2ee6594a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?yHaPG9TYwe7HmZCwtQaF+ZaxZt8E58xiMFiK+6mNdVl0wr1MRzFBXtKKtfM9?=
 =?us-ascii?Q?KPWZ1yzLE8EqwYvP4KHyJTH25mwjlZ+EhhGuYr8IgT9pG20SYojroLkkDshT?=
 =?us-ascii?Q?GmnFMzsZXisETO3Ie4iuvH21RH6IE2fKkcHsM7oMjIkU8fBQ5SIhCbyqt9yY?=
 =?us-ascii?Q?1IeTNxm1uwcfYz0CAL51fAKNgeNDPRX92qCmEi4+KjvEerf6KvZ8WoXKPyxq?=
 =?us-ascii?Q?nags6XADpoo9q1JtqYBv4DC02uZzEnuYmrqzOzFqZw87MLmWUT96mVpJRFpo?=
 =?us-ascii?Q?LT8S6tQFtRyeU/KGZh6xCynZOwZ6j1V1OXokmeSQkXEQ2AWXwJmbOUkEo9ET?=
 =?us-ascii?Q?251tSxlXJOcsS4zaHIhw76iuFp3i4Bhyd/wR6ruNFVhdxnNGPSr30RlSUlSM?=
 =?us-ascii?Q?YCEH08pEo+BOjfKbkyL2EtDSDtKgLTEsQnbLV/ZnB2KlUKbd56jxTt04ihcn?=
 =?us-ascii?Q?5XHegy0qvuOXPL8OtMAQd1kHTFuwwn9aO9nWE1hEGkLDtHwXi7dzApR4zih7?=
 =?us-ascii?Q?GS7eAU4Cw9Lh6eylYXYnQ06ajWQul4nq5eD7mcgm1YBoSPqNuCE9PHiHaKYX?=
 =?us-ascii?Q?sFP5P1Q328O3g4YUi4eX2X6UQBBIGwStS7UV4AAyOOyo1+QzIbEGgWS9E93I?=
 =?us-ascii?Q?eP7cD/vQ7cQpVLZAdFYzwC7uMaR1zeJFluyri14pc3yHx+X2Xrqq6KKXo3Ed?=
 =?us-ascii?Q?cgX0D//WbPtbp5ms8QrCgudetGvuYJCrPjEh/UIFns29XPAInD+uEpOrVHIu?=
 =?us-ascii?Q?bLoW2OQknaBZ6/k+2AgVhveIcKNHj88uOC6E+07XYKjBb0pfKr1T0lZrlgdU?=
 =?us-ascii?Q?DabT94DLSdG6HFheOO14TvxFXDhQvjuA3G7H0T2YCBxSkLGxb5dUDBjJbMF0?=
 =?us-ascii?Q?e86wGn9l+PBgEK0YD9UgPEgO0I737GBWzkgOXkbpoX/XhoZv5/tegBfP6BII?=
 =?us-ascii?Q?JANjBaTfAoMoGxLBT5CeZ68pv6/vZEBRM+epmt+ShG9vpuWNgn2TcM3TWbtz?=
 =?us-ascii?Q?7BVAYTTplrMtKiPT0l8z4xRGddOrJeHqMjodZP9OKlfihIViSjNlBsj0QUaw?=
 =?us-ascii?Q?Tp9iITsIZSBuPN1xt4jmF1jUDrKqe7jSC9EAE9xyy1VavJGiHGKGnegF4xMp?=
 =?us-ascii?Q?KH8WCi3+UcMJjtE3Ll36ZyAitOcBvMgOlE5SXKLFbd6firX1/+LRb820c9Ki?=
 =?us-ascii?Q?/e8rb1rWd//WQQ/OADoB3Pd7y5QoC0PGmyU7tq/DA7oXvNR8OmPZ6d23YF7Z?=
 =?us-ascii?Q?fvxbyqAAXNFmaFm6A+XP1+QAcMy55RjH80R7zt6ZYq8i1Z7kTRIdJXPU+vWj?=
 =?us-ascii?Q?42JBOVcxR5d0MfMkmIiVFya6jMhUPRORtPzxnY11PEzy0GtcgNEW0Wh36ZVS?=
 =?us-ascii?Q?flurwYVCFvtEEEwgRI46KlPdDCGs?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5964.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LuddJuGc0p8WX3VY34U7AYKcgB8ADXv0Ka1ZPRszUoU+hy8fuJ1azyfZjd0B?=
 =?us-ascii?Q?aYmzu0XORrB2eZ8oEodhMStKItWYK02s0TQoV4tvMbQALYbv9ulBb2tCslha?=
 =?us-ascii?Q?wiv3bCW0rtJ8O+Ai49JKuyqineoSrhOxfHQmfHZPiOdfJt/pUsiiaQ2VWKjz?=
 =?us-ascii?Q?FPPiMmkEMo7w7F8620dvIcsGrcBgvyyxib5tWhKUgVRzseMJZ5Q30JvziqzE?=
 =?us-ascii?Q?I5adFtnPchixCi1SwuYom7Xje5tZ5Wap0KHSD2257FsLBtFDsNBQzXmJy1n5?=
 =?us-ascii?Q?xS9IlwFbWp9kLI49XuUeEVKHGiuNKVROFDdhYTsE53QC/GKz9NXE614aHZf9?=
 =?us-ascii?Q?xDb+6c8hffVwML4FvSRcuQfApxL+HaTkd/hDtGMG6KxMUHo2zbVgPW98hEkQ?=
 =?us-ascii?Q?8SOHafPXsotK6GSPTr99iFceBpVzLpfCIBlBeCH9rZXBplPHnnK9SQUlOLeM?=
 =?us-ascii?Q?wSDjY6+xuD+OvCthtja1rrD2zSnTD0QZJYkIRWzi6IfPjD7CW0waaVgXYOBk?=
 =?us-ascii?Q?j/XQIasEK0xs4LGweVPQAVvqKj56MkP0jY/ywOMooeI4BFEAH6rNQw9Z/Iz6?=
 =?us-ascii?Q?OjiYnyFU5g0hMYbzsYc9+zPLcX200os1lEPN1YP+UP/K470p82oDk9LmyFcX?=
 =?us-ascii?Q?vNgFd+HqN3NZ3hB7p2/S86YvG4kOS9EJjuevfV9KgOtNjMIaUjTY/gyuoxOF?=
 =?us-ascii?Q?tgisJhJuVxM1Hepc/cH77BBzNTZiYXvVPMKA7leR5fvMj4RYHp5eXRL/l1Hc?=
 =?us-ascii?Q?sou71mAvhiz7ILxZ1v395CZoPFxNANHFankbKy+zFhFT5h0+PDJwaZOfVrpV?=
 =?us-ascii?Q?xdLhFBxzm+Fed1RUrZLH5jLiy09j/ehD+KD9y34xyRGZ/gg/gV1OvoL1Zcwb?=
 =?us-ascii?Q?C/5CvzB8i4+iYEG1m1bk3YeBHuQmGcahWIpBZ0s7c3jMzEHn49gumvgYVgQH?=
 =?us-ascii?Q?967PO1YEHIDMKpciq2zXZlQ1MLyHaaIzjsKBd43cfYfsN2d+zNOF/PR+vjOB?=
 =?us-ascii?Q?Rrcb0KCzzuss9lFG4lOnkH52L3KqMc8MZgH1JmunEjfuQK3+Xtl4nbzbitkK?=
 =?us-ascii?Q?b3dc5RbyFAz9GGNB90bvfd5xZjanM5N7RupUm+w82u3lYCcMQwdCQUG5LbR1?=
 =?us-ascii?Q?WnhuGpjtSbibnHjAAfdqM7+Vyi2uIjLTFXYWZKwbNBdN8ieVygc6KY0FAeN4?=
 =?us-ascii?Q?mycFhPV1ZYytg/kexe7LDa+XxjRSnaezV+WDvbIwyvuL2Zjuw/KWwM6zWdJr?=
 =?us-ascii?Q?XZP4hG8O2p73c/s2zFeD9Dow8gKWS/LhrmMV9Sfdox7pMIgQeM10krML8/16?=
 =?us-ascii?Q?V32eKR37fdmF/PqCs1Ex9U0itXpgLtXQE0bXX74I9VfbWyVUWgqpsSxeHEwt?=
 =?us-ascii?Q?ZMwMMd7PkWLAStM/doBNY8avaSdOTTCw0D6Wm763PiWZJNH67iqr/YAizJLt?=
 =?us-ascii?Q?F9ocur4NjnecG3EpKG0jDF7lxNjI4yyJenT2XKzz9GAeug2bDeXWmtBGH9cn?=
 =?us-ascii?Q?Ji3/IgCeTg26dCW71+EXBdJ/NaIGl6BUPbsBdrboMegTaeWQnFxIpJEmUJ+j?=
 =?us-ascii?Q?i7cFJyUwdycN6A5It8GGMfu3RRIg/fyxvwMdIRIo?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 656e0e73-b0ec-4fa1-c892-08dd2ee6594a
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5964.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2025 06:41:43.2826
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: temRTStAoFY7a0gg4oRBAoxA8OortpuCy8O1YJ7CRyVZPeLvE0ux7qs5XnZj539/Ef6So5s5rOXbRkw8Mn3Tnw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7596
X-OriginatorOrg: intel.com

New diffs and changelog:
SEAMCALL RFC:
    - Use struct tdx_td instead of raw TDR u64.
    - Use extended_err1/2 instead of rcx/rdx for output.
    - Change "u64 level" to "int tdx_level".
    - Change "u64 gpa" to "gfn_t gfn". (Reinette)
    - Use union tdx_sept_gpa_mapping_info to initialize args.rcx in
      tdh_mem_range_block(). (Reinette)


diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 1db93e4886df..980daa142e92 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -152,6 +152,8 @@ u64 tdh_vp_addcx(struct tdx_vp *vp, struct page *tdcx_page);
 struct folio;
 u64 tdh_mem_page_aug(struct tdx_td *td, gfn_t gfn, struct page *private_page,
                     u64 *extended_err1, u64 *extended_err2);
+u64 tdh_mem_range_block(struct tdx_td *td, gfn_t gfn, int tdx_level,
+                       u64 *extended_err1, u64 *extended_err2);
 u64 tdh_mng_key_config(struct tdx_td *td);
 u64 tdh_mng_create(struct tdx_td *td, u64 hkid);
 u64 tdh_vp_create(struct tdx_td *td, struct tdx_vp *vp);
@@ -165,6 +167,7 @@ u64 tdh_vp_rd(struct tdx_vp *vp, u64 field, u64 *data);
 u64 tdh_vp_wr(struct tdx_vp *vp, u64 field, u64 data, u64 mask);
 u64 tdh_vp_init_apicid(struct tdx_vp *vp, u64 initial_rcx, u32 x2apicid);
 u64 tdh_phymem_page_reclaim(struct page *page, u64 *tdx_pt, u64 *tdx_owner, u64 *tdx_size);
+u64 tdh_mem_track(struct tdx_td *td);
 u64 tdh_phymem_cache_wb(bool resume);
 u64 tdh_phymem_page_wbinvd_tdr(struct tdx_td *td);
 #else
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index cfedff43e1e0..120a415c1d7a 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1660,6 +1660,25 @@ u64 tdh_mem_page_aug(struct tdx_td *td, gfn_t gfn, struct page *private_page,
 }
 EXPORT_SYMBOL_GPL(tdh_mem_page_aug);
 
+u64 tdh_mem_range_block(struct tdx_td *td, gfn_t gfn, int tdx_level,
+                       u64 *extended_err1, u64 *extended_err2)
+{
+       union tdx_sept_gpa_mapping_info gpa_info = { .level = tdx_level, .gfn = gfn, };
+       struct tdx_module_args args = {
+               .rcx = gpa_info.full,
+               .rdx = tdx_tdr_pa(td),
+       };
+       u64 ret;
+
+       ret = seamcall_ret(TDH_MEM_RANGE_BLOCK, &args);
+
+       *extended_err1 = args.rcx;
+       *extended_err2 = args.rdx;
+
+       return ret;
+}
+EXPORT_SYMBOL_GPL(tdh_mem_range_block);
+
 u64 tdh_mng_key_config(struct tdx_td *td)
 {
        struct tdx_module_args args = {
@@ -1833,6 +1852,16 @@ u64 tdh_phymem_page_reclaim(struct page *page, u64 *tdx_pt, u64 *tdx_owner, u64
 }
 EXPORT_SYMBOL_GPL(tdh_phymem_page_reclaim);
 
+u64 tdh_mem_track(struct tdx_td *td)
+{
+       struct tdx_module_args args = {
+               .rcx = tdx_tdr_pa(td),
+       };
+
+       return seamcall(TDH_MEM_TRACK, &args);
+}
+EXPORT_SYMBOL_GPL(tdh_mem_track);
+
 u64 tdh_phymem_cache_wb(bool resume)
 {
        struct tdx_module_args args = {
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 8a56e790f64d..24e32c838926 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -22,6 +22,7 @@
 #define TDH_MEM_SEPT_ADD               3
 #define TDH_VP_ADDCX                   4
 #define TDH_MEM_PAGE_AUG               6
+#define TDH_MEM_RANGE_BLOCK            7
 #define TDH_MNG_KEY_CONFIG             8
 #define TDH_MNG_CREATE                 9
 #define TDH_MNG_RD                     11
@@ -37,6 +38,7 @@
 #define TDH_SYS_KEY_CONFIG             31
 #define TDH_SYS_INIT                   33
 #define TDH_SYS_RD                     34
+#define TDH_MEM_TRACK                  38
 #define TDH_SYS_LP_INIT                        35
 #define TDH_SYS_TDMR_INIT              36
 #define TDH_PHYMEM_CACHE_WB            40


