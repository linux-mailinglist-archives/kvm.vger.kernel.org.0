Return-Path: <kvm+bounces-63686-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 99FFEC6D32E
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 08:42:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 7E3C2355BBD
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 07:40:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35EB02E228D;
	Wed, 19 Nov 2025 07:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="N0FrmK6N"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 272D8260583;
	Wed, 19 Nov 2025 07:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763538050; cv=fail; b=PbmUG1hVwmwbPkmDz/ds+YGlST8Dfi/fWy8/5WdVIYSS7kKUanowMo3xneDq2T+edEdNkoox6iTIwf7TufmtE+Dv6okUBJHI7dpfkn4ME5NhoxOjWNNPd+yySd4otd2R4mK8du2Lx0XAwJMZttq2waqvwtSYD+YGMavu/xOrg7o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763538050; c=relaxed/simple;
	bh=ZA7YoadePyBVrCUk1uyiUpdtNd8VNZyRfdfgVA2U0bk=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=cxIYnFSxhUWM3aCEurzu6iXjRrRLV8IftdXoce5E60BY9lW85YP3Sn1pPLYF8ESz6OAIv1MCgdGXRgYAaLaLBBl+avitM1SKvLU3zGySKJ89ukAhJLQgGf/fVzWEkwyKhe6EnRcjv11LgN2F7q6JxTd7FLz82vmhL2Z5L27wxAI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=N0FrmK6N; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763538048; x=1795074048;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ZA7YoadePyBVrCUk1uyiUpdtNd8VNZyRfdfgVA2U0bk=;
  b=N0FrmK6NPGWIq9kHA4LNS7jJhql2U+onEEre00PMIZn8ZRNeszaLVnDY
   HdmC7yhoKmMadrzepnadylXgzV5zrMVo6+YY1PglmFHDBn6GPBfwd7L5x
   HYUHMG8ND2xF4yPFjquUQBEFUfjpuJ8iOE2ZlkG6NdkHvjJC4OkMNkQQz
   TJK1jB7zlP59NqBg/oRKFT0yr04ZrJAahn5dhuF+c30doXcxnqxKTKHDk
   fkKKRpzbjovbogtnWfGS++pfN/0pbPOnj6tipk374PHMhyEviXiBaxkKJ
   Im0y6gW3TvjpPMLgR3oY9uc0uZvI2EC2PpVZHDuiBNflg+3eNlu4913gv
   A==;
X-CSE-ConnectionGUID: VYoCgn10RD2Ze+luzhoQNg==
X-CSE-MsgGUID: dJMoJ5GYQkukxfoENMVZIg==
X-IronPort-AV: E=McAfee;i="6800,10657,11617"; a="65468631"
X-IronPort-AV: E=Sophos;i="6.19,315,1754982000"; 
   d="scan'208";a="65468631"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2025 23:40:46 -0800
X-CSE-ConnectionGUID: tt8FWeiiQHunBUFcYwmQ2A==
X-CSE-MsgGUID: 4E4y/Ga8RQiR4T36nFgxZQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,315,1754982000"; 
   d="scan'208";a="221622513"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2025 23:40:45 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 18 Nov 2025 23:40:45 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 18 Nov 2025 23:40:45 -0800
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.33) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 18 Nov 2025 23:40:45 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QmzMFKPN/in4Bbn9VcTIJMnIEe8ugt5gitkoJS02yMYJKUUKUd97g8HhBjx1WYuovA8OtzUYP3HIRrt/iZhy3mnBWc8FEVfHeHyRWkCHcTct499myo9Xgt3w7VPBU7sVQGUjC998OJNUkYe207ATXnTugocw2cL6mzH1M7khDp1oqYRsI4iWPuHVsjV6T6f9oQ1xUZq6CSzAy8RwU59jQ/g4IdfzGGGJXMgNjTjfb2rjSqeTUTeOFHaLAuv9aGoJgaKOuT6v5nOH/9sAlXllrgEcTvNWRUXZvQWg7pNgO/r7npmGY2h43teIHvRnKcQ54uUSShG7B+Ur6jbPFW83aQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZA7YoadePyBVrCUk1uyiUpdtNd8VNZyRfdfgVA2U0bk=;
 b=kMVuHgsaG7D6oZBmkGI8ev/5dWKX4/dzF4AFeAiFc4w1hUhx6TwNGQ6NS2Dm63Ip70uJT+d/KQIpkVHSTax8iScJxqcIv7uacG/sUiIsmds6SOCy4aL9jZ5EBcysbT8X0f5OqrxHiaQY0e2bNNsBzBwUqwAbrklWWTmHY69h4ZD0TMi+bxl4ciFCqCEKnzA8rkU8/P1SP39ADjr1ihp+OG5KMd9dTMdINuGHvLEd76nKzr6K6XIqnYXNnXGMrEWRQzkMwiBynMxYV+nf6kcLJUWV/SZoyK+QORcUaSHoGPqqXI/4vTv5RggFoz2Lm9wQlyqqQW/M2Ggo936XBvm+CQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by CY5PR11MB6343.namprd11.prod.outlook.com (2603:10b6:930:3c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Wed, 19 Nov
 2025 07:40:43 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf%6]) with mapi id 15.20.9343.009; Wed, 19 Nov 2025
 07:40:43 +0000
Date: Wed, 19 Nov 2025 15:40:31 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Xin Li (Intel)" <xin@zytor.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<corbet@lwn.net>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<luto@kernel.org>, <peterz@infradead.org>, <andrew.cooper3@citrix.com>,
	<hch@infradead.org>, <sohil.mehta@intel.com>
Subject: Re: [PATCH v9 16/22] KVM: VMX: Dump FRED context in dump_vmcs()
Message-ID: <aR10b/+lTzZHIyLn@intel.com>
References: <20251026201911.505204-1-xin@zytor.com>
 <20251026201911.505204-17-xin@zytor.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251026201911.505204-17-xin@zytor.com>
X-ClientProxiedBy: SI1PR02CA0059.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::19) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|CY5PR11MB6343:EE_
X-MS-Office365-Filtering-Correlation-Id: dd30e5e7-89c6-40d3-48fc-08de273ef1ae
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?C7IqmQaaoAmD3FigJkN6Jwx0I+1psfQPt7tMpjoO1ytN664BwnOGjF5xwcON?=
 =?us-ascii?Q?y+T7lYUMy3pfx0T0WZlpUEQxaRbCSezmYkd1QYb7bHMR2VKNygR4sB1LR7Ws?=
 =?us-ascii?Q?C93fSn40xfJVItELMgaTHX1S9UC2v0Q//Hnb9FG+VA6vLxO/LIFVq0p7uE+/?=
 =?us-ascii?Q?j8OIHLKttwKCtUxMF2JQjKqEjaIQn/eFWRsqHcrp+5dRlYlVXXatXv30DimH?=
 =?us-ascii?Q?omww68vecttQzDwxv5essIZpZoJFHPU3SsNpM+GDWep3lYudiY439GDx009B?=
 =?us-ascii?Q?fOYyrI3/i1IANvRI0xGHY+aV2Hbs3uaLXsoQVxcsXrj1iCDQaM4Kw+lCbY5l?=
 =?us-ascii?Q?oaQr9FuV5SzzHdoiGuCatSAShQnfB2oMhEtT/xIBXuyvIqEd7fylCemJF0Nd?=
 =?us-ascii?Q?er84zyJDy1kARsJWejMzHl3678cA1XMficej+N4ZVdNtaK49zvlvaP/bZL/C?=
 =?us-ascii?Q?5AZ0gzcUfr+sOKUNw3EMLYMu4H8ssgHrp75ue3BeJd45emGUtYRpcNiVY89S?=
 =?us-ascii?Q?0Bd03SO89Bc1GHdaFVEfMucqOn1hlKWgCEhtJNAlhTa9//ZSpt0JDI63Aade?=
 =?us-ascii?Q?lZyxp7MnQ4aOPaPb4ydvnSKHVcP5pVPWheB331IE70T0rMQk3qZikW1cHB+J?=
 =?us-ascii?Q?dw8YcggPPM9gpEaNveIW0A2BRBBx1aB94JKBXZIy6DjjBD/4dWdqMjWZLTEo?=
 =?us-ascii?Q?maFQR1fNN7uUG9C+YGQ5k61r8X14X68zfbB85KXormIgkv+w/vo/n1iZak6j?=
 =?us-ascii?Q?veMlzA4ZTgA8CSwlQU0DV898+1jO0nNvGS8H6iHKrZPVNMZID62ssXJSa/iP?=
 =?us-ascii?Q?f1b4df/cXqfjdZ5QuKrkoHVXj3GhkyFtG+5QlEIf8TjboAxryHssUX5/etwt?=
 =?us-ascii?Q?0fPlETkTZ/5YWEc6dbvf2QA2CvH15oD6sLG00GRkUeTVqYZsN7oFRjRE5zWe?=
 =?us-ascii?Q?uuxA7jeJ6UFiCUwke3maPRkr/ferubFnlvk0e6ufa86mb4tIhG2a01N/Q6/H?=
 =?us-ascii?Q?3LKZ6UorwM0+ZwqWyTXz5LhKv2mOR2NZdi2sBSnHVKjmqpFef+w8SZBkqDs7?=
 =?us-ascii?Q?q59MaAMHlUHWZkAcfgwwY6IZ+65PDNw7AYdQ76qdO0dFobZhXtckQoVjfPmM?=
 =?us-ascii?Q?43EdFoPVeQ+RrulXdUC//Qohhk7Ax91KF4Eti6IQbKcWFvAlCQ+9M9yCvCSc?=
 =?us-ascii?Q?jYuE5srExxRA03a+c6nZeDaTF6AYaiH5y3d9dnk/N/Eh3sJeJW1DIz/oPGP5?=
 =?us-ascii?Q?uZCmzVahyRrg5yGJAu0Yc11am5kPK3rWkS+3D3/5mqMJJhDdYTExt+BoDCBr?=
 =?us-ascii?Q?xYIayxv3+eKqn7nPs470jYxoLV/3qXlD79bBV0fwJNky1sjLsIU9v+BZzOqw?=
 =?us-ascii?Q?OO+GJsWuw493hzq49E3LlP/21MWBKAGP2XJIOuKCYVgHvHbFFTSJngWpza8W?=
 =?us-ascii?Q?pnkePkKf8Qfcg/Rm6gcThlMLpjWMrkfV?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WG+SJA32Z2/VIkUVpbYdC8+A/3I+AchM6zszB3bkLcNROSrMfnjhseTH9ibl?=
 =?us-ascii?Q?UYysq+sFIpLDIpsAzE79nwZ3TFk37NjKHDrpssAmeLg2fRTGYNHqwTVCtRd9?=
 =?us-ascii?Q?XZJUoDyloOhBxk2IoTszro7oKJqx/4XEZ/KCCGkH7ZjfwHsbN1P5jJAnkHFk?=
 =?us-ascii?Q?FPPtx0BBAkAmkzYYe7wSRq25/56hX4PPr74O2y4oIjH8nWKhzHQjafvCLy7L?=
 =?us-ascii?Q?3tNK6HSnSGWPfTL+yB43hoN/qhqmHA1k5jdetZ7oeBrz6g9/YcljNsd/adTm?=
 =?us-ascii?Q?kDMtbHX0rhXikkWNt3vKETBXlaoap28OpZ76Lb2ZX++hareht3hPUXCDmGxM?=
 =?us-ascii?Q?npE/Ks1O0Mm87gmp3DxlbB44RXiN1jN5MCAeIR7pwetvuZMEJNhcuEsGW4GC?=
 =?us-ascii?Q?q1IqOhHhECAfXPF6Y8G7J5++j0sRKLmj9G34BnMMBAxuNHQDf+U8kYN5tU5K?=
 =?us-ascii?Q?IKZdSWxZT8yTq0UXagpVRIGG/fuCXaM7hpd6qiP3ktlV7uYPvfQo/xp31+qE?=
 =?us-ascii?Q?gRUwpYaMG0vwfdV8fDUOHek/witRORdWDqnAXAJqMzXV+11zFJWbGUZEYkoR?=
 =?us-ascii?Q?BpXYiK2B4+rWkPFtPUVDUzaOEizMnYLntMtbjENpOLBFSrsFrLyBhyW/+b+9?=
 =?us-ascii?Q?ND36xIDGsZff5X1yAXstjPxnQuFMUpBCPFTl3b5rOr/3/fYcc/hRZCjdnZBh?=
 =?us-ascii?Q?aI4ucM0rJeFU/CY1+U2CR0FfpB1kMkOL+AcUyYRMaSPdhuc7TzjFda6hB5Zd?=
 =?us-ascii?Q?48UXYKVhp48NygyWnPP/vTUd+kAa8LFs0ABH6JyrhkvZXGdu/UbviokTRn+Z?=
 =?us-ascii?Q?Pn2+kJ+eGGyIqME/3GHrAGqy1xfzkufETwwh3duSoaOAg4JKki/tAlOdgo1G?=
 =?us-ascii?Q?yaklBuEtkRZJAI/mtfgQXmWqDO8pX8+W/wmlg3YHsHgz+N6Q4bhxlfWsfj2V?=
 =?us-ascii?Q?yvshpZwjseEoPOUuvZh1XQFHNKYQDSHAGVMeZufzENmf0WUzqwkYVuarGn+f?=
 =?us-ascii?Q?iuLrSJJ+W8qp5FlEefskQmiiK1e5GQpivLDc1GcJwbz4YFtupFBLFaZzcGtf?=
 =?us-ascii?Q?jySn1lio/HHBvXoZesbQClDgT5/YJfJoivQSocwOCJFe9qkGBBYGZhro3VG5?=
 =?us-ascii?Q?82B5dj+ftVTgPYXrzEcdO2jvWu2Gm6/GTNZ/laLa7DxBGUvtY5BpjcpycM3/?=
 =?us-ascii?Q?SezQP6IJe4+aG5h/QKDAtvXSd4hAsk4cC6GWr5D0B/reRs6gZxiRQyj6KJMg?=
 =?us-ascii?Q?DvcKMOA5SZo/IsUs5PZlkd1F0xpAlaaCIeJD6G0SGzQYfa10QxXqScDhz3CK?=
 =?us-ascii?Q?QY/2xZHtC90b6wwzpA/hJqE2vzmSz6Ufrwjtf3u3QAAgizcxMgdrb5jyUg9k?=
 =?us-ascii?Q?m+emwO/lpaO5w0/41rVGGELqwyufw2aJgtCvbt5JsM8HD3yVs+f3fNjZv2fq?=
 =?us-ascii?Q?2Nc00Ll398g8H0xOqTbgfihYi95k0w01hnHZvxYQAtdxYpU/OYkf+krJtW1Q?=
 =?us-ascii?Q?8NdoB7jHpDb2pyuYzWG9rCLaTN9tViV95vabAlKCdc0f2bGHZOYZW5+dWZXZ?=
 =?us-ascii?Q?vFk0rsevuk8iX4XxZVK2mLRWGPfO4CqWRFL9GWLV?=
X-MS-Exchange-CrossTenant-Network-Message-Id: dd30e5e7-89c6-40d3-48fc-08de273ef1ae
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2025 07:40:43.1056
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BXWlW3SI2IoQiokKXbghVXL+Rc/TwyxdfH1kOEHm5rJYOm0evVSwA5pUc9rHkedGM+82dAxxU8VnWoW3T17yKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6343
X-OriginatorOrg: intel.com

On Sun, Oct 26, 2025 at 01:19:04PM -0700, Xin Li (Intel) wrote:
>From: Xin Li <xin3.li@intel.com>
>
>Add FRED related VMCS fields to dump_vmcs() to dump FRED context.

Why are SSPx not dumped?

