Return-Path: <kvm+bounces-57194-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 80FFAB515D0
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 13:33:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 29FC956350F
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 11:33:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2551F280332;
	Wed, 10 Sep 2025 11:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MIwu7Tpi"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A02AE23D7DD;
	Wed, 10 Sep 2025 11:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757504024; cv=fail; b=S/Ok6MytKIifD1Yy26xQhPqCzUHYWlunOc7c8Gc5PiGW/1dK/4QmTexXcaIxwTQzDzrRzk9dq15jpVqLzy9FCVwsQgCK3wEST7ETomFAH2TN/YSmuUpUCAyUYrjVH4HRjK6K8pK1sNeRQGU9qlUwbRB5ZmSWSNPXldyPPhsSOFg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757504024; c=relaxed/simple;
	bh=UENekzNsnUK+tP5AnUhuPvtabN5L9Qupno0C9U6UVFQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=huknQudZCy4xYuATRw5vpzAnierHo7pjsLJIabeY+jqtDuRmX89F1XV+5OtcM5LeV2vCZ0YeCy3806XuZl4ppOO2tAMkCsJqvm8qKgiheioZVDDUX4Pjjc9dlk07E4UJCpOnKbsXRQ4b3V1lnG5rV7aPFZmAzWiLbKWU3KUDaM0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MIwu7Tpi; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757504023; x=1789040023;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=UENekzNsnUK+tP5AnUhuPvtabN5L9Qupno0C9U6UVFQ=;
  b=MIwu7Tpiv5AlFrOtDhIbKTkP0k2XGASZC5oQ7bG8T3DfrsdFpCJ9mc5C
   cMm451fNVyyDJe2soKKfPZFBqlC7ic5+1xp+7ZzG2r9l9ZEoNgMvzwtUI
   XfLw8o3QPU46uMSbrkNhXZ3KppOJ9QdgnvUpf43AGPTYt1YLM7SZH6wZN
   +bNuoXGs4W4t3eIOp4+p2PJugGrWEkbqSd+o2hXQAEh2M10tN6i6VN4y2
   6xGLhWmLBAuFyHUNTy5LFXunRUqnTjCDts2tcPoY6yK3eizeh46g1Xkt1
   EBkygLO/MucM17gl0CA8iOdsd7e0L5fmAG1NholbpeOjGiQyJQYh0DIIV
   g==;
X-CSE-ConnectionGUID: quSOcFzIRGu3mNfoOO1Cvw==
X-CSE-MsgGUID: v1IZ3wy9RVidP129/TTlUA==
X-IronPort-AV: E=McAfee;i="6800,10657,11548"; a="85253786"
X-IronPort-AV: E=Sophos;i="6.18,254,1751266800"; 
   d="scan'208";a="85253786"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2025 04:33:42 -0700
X-CSE-ConnectionGUID: g6a9MBQjSlC/cEUOzzmvEw==
X-CSE-MsgGUID: aL/ICj3/QqOOJBwndThbnA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,254,1751266800"; 
   d="scan'208";a="173817187"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2025 04:33:41 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 10 Sep 2025 04:33:40 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 10 Sep 2025 04:33:40 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (40.107.100.66)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 10 Sep 2025 04:33:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z/jXvdvq23fqVLhqjjfdPYt4b5F8HSRTUuzO8khSXf8rQcmdhcq+h2i2naLY1Xa3huoIBmognsWHx4Y5KqXI87z/4Fdp9dt6bLhSTqYo/UtSjHFR3Da5R3kuuxVup3e3DLJt3eBuj45CgejFvHgMEKl9tTSc4jB86mC7/QDu65UXKAwnYYd9l7SvBkbfXdL+5ikj/EWuv1BqEhZfIAYEu/Iy/bGKx5gaOnfF2kxc1k+bbBpbYaZboRNTuENi3/p6PYduVIKmxiDXdsn1ebFPiwluKJAg7qJhoeCxxYQPSWalbK9Mjf0QSQgx3HMLIKJDxXBSaXaQTtDVcEHJXp/AqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6ua9SfkifqTfNtnijtCB3TG1Dqq6bCs+pR+L6tfiQ10=;
 b=b86qJqpZsBteBHZfYIboec6Hr+A495UeoYXiG4vKftbFEd8Cop8RT/ZiclvaqOUav4vf/UTboF8ZWE5FMk4+v/ZvUNTk/NycuBLCM1lCWbB802m5pkM2z+HqLtYNqdqG29/nFViWSQlbb6IKFENF2oAzOQ8WQfRuBZnnsdPf3YXHG5iY53MLP/9IVROC/0G3uapvmzNcysJ9SxkgOPiEgAWHToRfuCcUj7woRAilmRL1Nis60LpmkagRZEkgz0OQ/LCMJ0e06QhohsGPohnlDIfm11M01IO28BPQyPWY6I/m3Nz9HwqjwhVobix3uwv/TLF6H3VaAxc7Q1EC6+Mj/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SN7PR11MB7418.namprd11.prod.outlook.com (2603:10b6:806:344::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Wed, 10 Sep
 2025 11:33:38 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.9094.021; Wed, 10 Sep 2025
 11:33:38 +0000
Date: Wed, 10 Sep 2025 19:33:25 +0800
From: Chao Gao <chao.gao@intel.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <acme@redhat.com>,
	<bp@alien8.de>, <dave.hansen@linux.intel.com>, <hpa@zytor.com>,
	<john.allen@amd.com>, <mingo@kernel.org>, <mingo@redhat.com>,
	<minipli@grsecurity.net>, <mlevitsk@redhat.com>, <namhyung@kernel.org>,
	<pbonzini@redhat.com>, <prsampat@amd.com>, <rick.p.edgecombe@intel.com>,
	<seanjc@google.com>, <shuah@kernel.org>, <tglx@linutronix.de>,
	<weijiang.yang@intel.com>, <x86@kernel.org>, <xin@zytor.com>
Subject: Re: [PATCH v14 03/22] KVM: x86: Check XSS validity against guest
 CPUIDs
Message-ID: <aMFiBZARu5pD+Zzq@intel.com>
References: <20250909093953.202028-1-chao.gao@intel.com>
 <20250909093953.202028-4-chao.gao@intel.com>
 <c0e5cd9b-6bdd-4f42-9d1b-d61a8f52f4b8@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <c0e5cd9b-6bdd-4f42-9d1b-d61a8f52f4b8@intel.com>
X-ClientProxiedBy: SI1PR02CA0050.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::12) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SN7PR11MB7418:EE_
X-MS-Office365-Filtering-Correlation-Id: 016514ba-a19a-4a76-17cc-08ddf05de28a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?HS0YN4pdwREA1OIAFTiQt9QeDNfjg5hFJYp3Oi0SP5jzYO5UBCaGcPtvwHyM?=
 =?us-ascii?Q?Nd1T32SSWXo4WdRWN3btrofE7tAB6baDbwfYbtp96FOMFlMme7iN+3YSjFpE?=
 =?us-ascii?Q?5TzO/NCNxubJAvih9JDv0K9r1TSuBne+TSRB2HRM4kU+91rjx345U15gKvFM?=
 =?us-ascii?Q?+tgxkEQfUAaWEg6DO5mkIhAn7piY2zcvMdXJAeFI+kqQC4SmsVzXVNiLAJgR?=
 =?us-ascii?Q?oxBq1JI6Cjwaha3Mi4jBW4i4KlRT44xPz+mf1nBswIBAQmjVL4azf2dfhgO1?=
 =?us-ascii?Q?+xt5IUT8G5cvMmxMsTx3ziwuX3X5Wb+1lsJwU1rnzHXPrDPN0Sf5ugPoIhQ0?=
 =?us-ascii?Q?MwU3jT9LbFOe5RdrhdJXj2U+WSVcGDsubwdx0EcIbvqS+s5Y31XAcsm6Q+Ks?=
 =?us-ascii?Q?QcfVdAUXOnVz49hh8+has5F9Qlrb+ioj8m6NDI1Li9aoNZFXCHSl6UMQDs+N?=
 =?us-ascii?Q?/j2TUQEbOYjpdn4cepsQAqQ9ZJgTuxiSckAROhh435w9RB3/6H30ZtrWc8XV?=
 =?us-ascii?Q?QA1G2lAs83yk9j+oPtH2hW7E8tFfgIpZKrJSeD2VkQBoZ1QpAuqj/Wj6n1V6?=
 =?us-ascii?Q?BI83mC4FdsC3/7Wy05A/DWz0GMT9rlQYFy1EmHPR0lo2ShCrVTCbRtO7JPhP?=
 =?us-ascii?Q?nIleoNEoiWago1Nkl5VxrqXvHG03s3yOgAZvoJj/WLM/ftbLrr9Wc9GBjoHK?=
 =?us-ascii?Q?jJ3AL+AOsAwKMADyHl65bVBblBsaVC/FBrZOEpHha/xnAx52KLwS7Im7ytR8?=
 =?us-ascii?Q?vBMgyYGN2vcukSKmWut/4yN3x9qg85AN4NjOOlv+iheF1ErSJU0r3LhUyXph?=
 =?us-ascii?Q?BKpwFYc3IAay68J1k+qiE4CXz66zPrDiJJuRHM36NGC+8op5yn1NAvFQV7Pu?=
 =?us-ascii?Q?3CDZHtfXu2y+nOSYCWE1LMzHKKSHHCigLYrWAxEG8trOQIkUmqiwyKCM+2/D?=
 =?us-ascii?Q?bZ7t3mYS7ZBFh3b12Z4cBl07eVjGYqT8RyJosxSWBy9NkxZwVPe83Vds3PqJ?=
 =?us-ascii?Q?KHqy71AA468Vsx2VZXU0DuEZiaKoDFiw17/zN7D186d29eGNzLZyyjrbFGNa?=
 =?us-ascii?Q?VhRknI4m7rBePe3xdaxd/16jiFsOBOg+ynFe6ODu+n8aEy+Pbh8sbv8rrEP6?=
 =?us-ascii?Q?moGFZjARWCrTUS8fgXJxQZQ1HirpgaewjKn2MqCNiYJscFCmGZXV8vKCQ4J6?=
 =?us-ascii?Q?02Mao0/BtqmMRvqi25vOwv8n07ZOZujvTt4erk5bkBMB1O5v1PRBZLQ7Dxi9?=
 =?us-ascii?Q?otx+6p+018LGISDxwj7JfL1LEPO6O24domi8V83OeI2ecYcmcLAdtM4L+hBY?=
 =?us-ascii?Q?cTYuxQpqAXwoMSht7XFvntDjTYXUg6oYKdSAOyvC0suMA+6wzYZ7YcFBNhtt?=
 =?us-ascii?Q?UrqNdCU8pwc6gnMWJbOYFbNG5/GNXLKD1L48c60PZc7OY3y8HsqMWRSfMhIx?=
 =?us-ascii?Q?2JOtX+0WrzY=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?t4Ro6t0Tgq0FW0OCaiGKRTgs+05wiY6uabPQuMo3iXqgsVbS/V2aNHT7CvsZ?=
 =?us-ascii?Q?fhK2cHtaR7tAYD9hg0/hu5i9MciuB5Nvygxh1/FJUL1mBp6RCA8dF6wYv7Ni?=
 =?us-ascii?Q?0e801SdAWi3gUbyG5hJwZsJ/8l51wRvp2wbmNg9OzWe8vnfFAlxvsRVqllXK?=
 =?us-ascii?Q?AEOHMe82yq5BO6lTdEIQAGmh5TLtbtg/ID/wli2B6n6vh6lLUyUFpjIlKfjU?=
 =?us-ascii?Q?7ejv0I0Sr43sFmb9Zqud0P70VqYRBEgtCpfGQfJ7lLIsfnGybLqFkgK3sMH8?=
 =?us-ascii?Q?Dx9hEdQPIgUZqt50yEOp/E1tK8SEmhE6Q8mOMwWTXVHlBBbAj2gCP+42Siad?=
 =?us-ascii?Q?qMvGkRz5qDh6lrLqFokg/GaZmdU9LGcoFAagp0Xo/X4hjRXMJ09ndJJgvcia?=
 =?us-ascii?Q?INbH/PbjlY6k4hE/cEn+laLQaNhr622kj0OA1Xl35wD7WoE1LOHtqY1vWSZC?=
 =?us-ascii?Q?uaaU6U5Qw7Ob5FfRyYADNmiHmT+3/8G4F1ZRUSwVkIG7tbVRA5XLAxgbL4YU?=
 =?us-ascii?Q?6P7CEZ/nGU8tOYdOJMtJ0E+nRFeRY7S/Sa3i5gLnJffQbAALH6VDBYxPRF4k?=
 =?us-ascii?Q?ey6lsdCEqcCRiRajBjS+yJfM4InOZaB2jXLkAnuy/MskFVJbeOUKBmaXEaWX?=
 =?us-ascii?Q?MigGO6EvTB+XCgTE1//2yxhr6CGQUU4Zzpswzz/BQLp/4FL8Yf3jMNC8ZXHg?=
 =?us-ascii?Q?+Z2PB8xQ8xIZh2vMGgXeByQQeP5ZJhbHFQbS+Lg9+HHxT6yMGZaDIWJtxpt1?=
 =?us-ascii?Q?CTs01X2F0to7zqMNjEGtPE9UJrIFicg8Z7P1mOrtq5LsVb9jIK4vH8vxf3sh?=
 =?us-ascii?Q?/WA4jzeRsaUux3ByRRdBbefJ8Fx8SEWPJDCnCQ+zmOb1svyxePr3uQJ/LwpX?=
 =?us-ascii?Q?udI3anhGrNOjreeTb/KQZ3/VWm0p8OwRJOPi91ayhcHDzSbeKoHeByHqIv7a?=
 =?us-ascii?Q?JRwi1DDxGLqOh+HoQE3ojQLxb2qSaraBjHhqu700fhuEpKZX3I7ps7yih7Gs?=
 =?us-ascii?Q?7MHQCaSooMdvitcgEkEe3wHN9eDgxuLW3mujiF2nG4k+2uT5accm6HtxHFD3?=
 =?us-ascii?Q?khl7lm0NaB8pTq3tTBOMsi74XdGqFAIKIDrhEpcmg7PPJQLURvDpeBlwebSj?=
 =?us-ascii?Q?E7q2/3D+jzz9g842qBPoKYlZAOKd6lfoRHGsC5GBCc1V45z3ObG2QlJPMxsj?=
 =?us-ascii?Q?Mq4iBW/96M46t2BucfvVQmKN45zcUZl/YaejyE0PZ59Enzokl+JxzpNeB8DF?=
 =?us-ascii?Q?hCXaFB1Vx/0+aKAKj2nijj/j2fkNt8sEcxdnynxZyGXARX3+HhII5nK6QE37?=
 =?us-ascii?Q?naqoJOnPteUjFbD+1i0XvUtxfMP9y7P8tUyqSbIwwuCgvW79retcE9n/8G55?=
 =?us-ascii?Q?VfJhJtC3m0V5GXhmP9j5XjV3wdqBheZghbXG6OVC1xbcYeneKnjH4u2iJ3DV?=
 =?us-ascii?Q?CNAgPHmvuzjgWZe74FqlU/aUW4BXdmEDdM9MaF2LHOjYysuJmjq91wJGQwB1?=
 =?us-ascii?Q?FGvm5Kte6g2708S4e2XnTv6vINfmrMlC4/7ujVzKETj3l6bn4pZN1HNTMqI3?=
 =?us-ascii?Q?eInLxuIcKWB2VGVdeKM8tbKxXWYn+4Bf0F1A4kAj?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 016514ba-a19a-4a76-17cc-08ddf05de28a
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2025 11:33:38.1808
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5JpWjcMbF2IU5ptyaWovI2HDwlVNqyn1ugWGwCMkFHC6b3o9AnkqGlQBmqCiHg2AMZFOCpLuwcQys4vbvZ/Mpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7418
X-OriginatorOrg: intel.com

On Wed, Sep 10, 2025 at 05:22:15PM +0800, Xiaoyao Li wrote:
>On 9/9/2025 5:39 PM, Chao Gao wrote:
>> Maintain per-guest valid XSS bits and check XSS validity against them
>> rather than against KVM capabilities. This is to prevent bits that are
>> supported by KVM but not supported for a guest from being set.
>> 
>> Opportunistically return KVM_MSR_RET_UNSUPPORTED on IA32_XSS MSR accesses
>> if guest CPUID doesn't enumerate X86_FEATURE_XSAVES. Since
>> KVM_MSR_RET_UNSUPPORTED takes care of host_initiated cases, drop the
>> host_initiated check.
>> 
>> Signed-off-by: Chao Gao <chao.gao@intel.com>
>
>Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
>
><snip>
>> @@ -4011,15 +4011,14 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>   		}
>>   		break;
>>   	case MSR_IA32_XSS:
>> -		if (!msr_info->host_initiated &&
>> -		    !guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))
>> -			return 1;
>> +		if (!guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))
>> +			return KVM_MSR_RET_UNSUPPORTED;
>>   		/*
>>   		 * KVM supports exposing PT to the guest, but does not support
>>   		 * IA32_XSS[bit 8]. Guests have to use RDMSR/WRMSR rather than
>>   		 * XSAVES/XRSTORS to save/restore PT MSRs.
>>   		 */
>
>Not an issue of this patch, there seems not the proper place to put above
>comment.

Agreed.

I am curious why PT state isn't supported, which is apparently missing from
the comment. If it is due to lack of host FPU support, I think the recent
guest-only xfeatures we built for CET can help.

Anyway, PT is only visible on BROKEN kernels. so we won't do anything for
now besides documenting the reason.

