Return-Path: <kvm+bounces-46768-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E3305AB9645
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 08:51:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6D3B65003BB
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 06:51:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5E54224259;
	Fri, 16 May 2025 06:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fGJfqnTq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCEA522759B;
	Fri, 16 May 2025 06:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747378215; cv=fail; b=hMaFgRokNTwMaHOrspLxTDE/MzC667pOC5qdHcdLcNwLzOLfVhqbdHWZEXfsNj+BDGUT/ukFhC/nHvpT8vVHUVED+93Plym3Elw56CmJI5efhc/GnJficKN5Z6SUd3Vya/4pq+p1lBrw6ZBXqrVQ8SEYHCRlmm/puvxqi6Zh2wY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747378215; c=relaxed/simple;
	bh=FESXbXKhKHAJjV3Ru7Q1MlC5wMou1J7NZiaJGtLTK+Q=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=KDDBC5iB3d5lxlGxUGJehQREeQdHrNwMop/DYZmpOBIjQfpCRu2V0ZvluydjQ8IirgqYnqDF+th1Sd52nyItBVvNUudKBe6XrYhH2YYQ9Thg8OPqVYSkGpB/SOhE5zyeewVORuS1rU0ljL5RrlTtdkAKQjrVJw/Rst3G6cstlNc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fGJfqnTq; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747378213; x=1778914213;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=FESXbXKhKHAJjV3Ru7Q1MlC5wMou1J7NZiaJGtLTK+Q=;
  b=fGJfqnTqm1wju2/OeQmKx4GgGkTwG/zmskZYlDdvgqLPF8xlZ40qhPgu
   IP3tM1zbCAJw1nfF9ZNGZlHzSQeisCk/6mbC+ryhb5s884Zv+blq0BvNY
   DIi2kMaDWkQkZtSlgBqeRwo3Y6sbCkdPS+HTdBg5Fp4LzbkRKgppxCWmV
   kgkAg3Jc40693p9S6sxqnZ+g30UJJ4JBa9nepVxlN9ZjICls6CeyXQD6H
   J0WZB/0DvmSD15IQjz26G5twLw/gXcVlw09/adoKzCrI2oYYX9aFG2pux
   v/yUG2RJCxnhi+epM0XVcILTLk0CqEJSNMdkiYNhYmF7SUp9l9QTn5jTO
   A==;
X-CSE-ConnectionGUID: 0JcdHFRCQ4272ADjj88+ig==
X-CSE-MsgGUID: hRt+HfhfRKyno0aZuiaRYw==
X-IronPort-AV: E=McAfee;i="6700,10204,11434"; a="49033606"
X-IronPort-AV: E=Sophos;i="6.15,293,1739865600"; 
   d="scan'208";a="49033606"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2025 23:50:12 -0700
X-CSE-ConnectionGUID: lOk3vpnGSaSsBk3oQsw7Aw==
X-CSE-MsgGUID: hSegRza0TcaN4FdqQYLOGg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,293,1739865600"; 
   d="scan'208";a="169663082"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2025 23:50:12 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 15 May 2025 23:50:11 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 15 May 2025 23:50:11 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.43) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 15 May 2025 23:50:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X/eoq6J8BJ23SNpZzyPo3mm9ev/Ij9wUhJN4/ZknwudtNgTvC357946wak0vJE8TRSd2xAl+vkm2CqP5/E6fyFGvdMP+I/gm7zHY9ogU3jghRFL9f07segsP4zYMhwNokDy9Pd+mAT/nDPbe8IZmOW58fIDxp5XHE9sF4Ynw3YpXyvdhxSnj4SoCphRf/EtPu77CgNOcb08QTACT4aKYyxc6ZWcAHJkYgaabIa2Nfnw1s6G7sKiZCgAHLet+IA6blzXZHNwE2ejXob2GRAiU0l4SUL7FXrySy+GFZPbJXHR+RbSAJYN06yAGGa96hz5ANcSIyg6dI7ZpwBZ+yg9l6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M12PeNiJzleMO5+MkefmhekW7XjYOVyCwMMTEmbrG30=;
 b=YGEs1Utu1ty8UO6R/hr8qIjzfuz6FFk6vunWtim1keKhnu4ZOKR/Zk7LTCo51dROh3g7ai5vX8E4Ep4dRati+pWVmknc49y5z58dsT96ojNmLRiOhWcl2SWHGfW/h4BEMFoUQcHBV8TVcR1bX3lz6arfRZrlMK11hgJ5Oa8rQba45z3BFORyA99eXAvd2GfJhA7CMCX1NR6LYh3s7WHEyjWO6hcaIOhTwREHdQFXKF+aOcZ6P/kq1KHzbRFtAzlmRnSpPfsrM8Ll+oV2bZuVT87u20X2Sy84hQfeat5aNi2jkdwEnmHUHN/iKQpbkU52sFRgNLEO8aEqiXVg1qZpPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SJ0PR11MB4894.namprd11.prod.outlook.com (2603:10b6:a03:2d4::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.32; Fri, 16 May
 2025 06:49:23 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.8699.019; Fri, 16 May 2025
 06:49:23 +0000
Date: Fri, 16 May 2025 14:49:12 +0800
From: Chao Gao <chao.gao@intel.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
CC: <kvm@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "Sean
 Christopherson" <seanjc@google.com>, Borislav Petkov <bp@alien8.de>,
	<x86@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	<linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: [PATCH v4 2/4] KVM: x86: Drop kvm_x86_ops.set_dr6() in favor of
 a new KVM_RUN flag
Message-ID: <aCbf6JikteXzb0gB@intel.com>
References: <20250515005353.952707-1-mlevitsk@redhat.com>
 <20250515005353.952707-3-mlevitsk@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250515005353.952707-3-mlevitsk@redhat.com>
X-ClientProxiedBy: SI1PR02CA0030.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::8) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SJ0PR11MB4894:EE_
X-MS-Office365-Filtering-Correlation-Id: a5d72f0d-c6ee-446c-6eb8-08dd9445cad2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Fl0sBK17/BSQLTmyKsHFNTxJyOJ2DlZzNRbrWnPUkQjgNR9h5V4nCkrZ3qKc?=
 =?us-ascii?Q?LfURvMPUnFcTkn1Iy6fpVrTSmCiMClzRL0z8EY8zbWXFdnKp493FN5bNKxWg?=
 =?us-ascii?Q?4e7AaEGDO5+pvfs1BQWdYBxCACOQMKuFmK18G+OP6k+R7wdSL3C4R+x5NduF?=
 =?us-ascii?Q?JfaRbR3m0KBxCW9SOHQ4VnkQNezD1+vA08CvK0dZe+9Xw9yHDl3qRGJoVijC?=
 =?us-ascii?Q?qCJp3sQKoOSfgKyiQZBBYhci6LgUZCSllkWgSvai41bGuNSdHMiXcQGc6Blv?=
 =?us-ascii?Q?JpPK4y3zTR44t2WrTHao64/Mb/DKPsFmh7wTmJTTBsbUiA1Ksouhueha4FPr?=
 =?us-ascii?Q?tw/jvT2ByJEASDqsIM7YqZYumF49vxdd3WptdQBNQrWPELeELyWMdfONiugD?=
 =?us-ascii?Q?j7w+kt6vDvsVU6CreBveMreqVTrt0+0MbQJ0YIF3x/l/4BDEXtxDiXu2wEdF?=
 =?us-ascii?Q?Xz+QpfCPyvdRtX31NP/3VoC1AgbYELhy1MhycIJf+duFigq9rsNarvtYyPHF?=
 =?us-ascii?Q?KdssPsM2Ux6zwUh60S6eHvYyj7EgP8ZtbOedurQi5o0VlxCthu1JD9ojmNgP?=
 =?us-ascii?Q?pZ/FvlJxC7oDk3acBN4e7YURql08OH67GCjCGze9PTJhy7nGBRA7tIvjhGFu?=
 =?us-ascii?Q?8ngdfA1514+wQ2VJBLH+6nqqIY+p/bq93wl/lb/NbLFkyuJM6S0omi7/rbbd?=
 =?us-ascii?Q?TWxfcmPlxGi0UAmASNxtv9saQqBNNO1LDcspWBSiWwMV/WF5Ap7Hk21/QYc5?=
 =?us-ascii?Q?r5ko426d1FVnP3tLrSfuqzpIpJ8mkdPRP91IB61/Cci/bcUb/FO+MsghyEu7?=
 =?us-ascii?Q?k8phJYJ6GkP0HCUeEC864Wnx8Vev6RECFR6PFAqI1jWYd6Ek0uks7/4TjJ3H?=
 =?us-ascii?Q?NiE1Q1ScAZN425p/zRZG+ifDf4cGSsHdhdnpBcgoFXnPi2PDrLR8k7mZsA5p?=
 =?us-ascii?Q?FS/ETkoVWQuST5fojJ0h8zBuiIUsiu5vcnrmlAfogjwA4KIuvVxPuvuLErpu?=
 =?us-ascii?Q?1MalO+Frbt7OqsVLNa13hKrY9i34UluAWKBLXZbVsaC6wU355vnMXzbYZhRk?=
 =?us-ascii?Q?Tf+yVtc6/Yd/zzkXo7WbQIkUsxQAJtWTUXHT+WtgpDOSj66cgM7zWLJ4ltcR?=
 =?us-ascii?Q?+GZVgmgLgfBAirybp6JxL4TnL+c76gTn/XtSKuvImMBPiMIFS2owM7eKwW1b?=
 =?us-ascii?Q?DSIR0OQpsvrlTn4LKII+u1e6kbFlmr4tk2pULs2+MuDzv8ztuYDEn9RyyIbQ?=
 =?us-ascii?Q?Qd8udqm6hECrHcuQaTJhehxE0NIeqjVe65xD+CNkcqGhhO8COuBuAs3kw9+C?=
 =?us-ascii?Q?1Qb83JiddOeQ/FZmnbibSIn+FAJjmAYPc0U0ZBaTUzATFTuu/KyQawuXsP8d?=
 =?us-ascii?Q?0Yljd6GVKOgRamh3nUCbLN5iE+W04Ieu4zuxndrsuSAgf245vg=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HSGLo7ERCfTo9UYO8eI4BuNSE+6XG6w2odC+aDqAlISEGVGD5UIMmdsq+WGr?=
 =?us-ascii?Q?KO2FWSHnncYK60KxEa9czTTp7GqOsyc0jVxRFKdMsMHAOwByt6ZEaPQGy7WJ?=
 =?us-ascii?Q?hfPMyXtcHjCad5xkoa8VxmAQAhaS57Ntx4Mm0ZfNfdOGE87UVzugsCmFJ2fe?=
 =?us-ascii?Q?zYxOlZ8UN46GqQqy354hwRDigcK4WYnJpupOHVtiuUA8iRlX4114ovFgP7Z3?=
 =?us-ascii?Q?/wVAWZ20agFcrHRLL2HfgyMPssMnOWeuZuFDoDShC+2Sc8unJD58Fcw/0h5m?=
 =?us-ascii?Q?lzZCZBQxSC7uxIj/INhhicnw0/qnuEfjivY+63mJL52NwVPZsQFcp+FXUSLC?=
 =?us-ascii?Q?eTj/AYtoKpvzQHZrLzOGSF+9iIcFGBEDxr7jTbgNfRx0YrOBP2OQJOXW3NSO?=
 =?us-ascii?Q?M093vYJZ1ojJD1pVIwkS6a4SQ4n5Xrwvh2+iuKQpaGOQecIPpo78jjfeCkBL?=
 =?us-ascii?Q?ZjSnMVWCR37q1fl0d7WFrMklmKdyVAYzTQvN9XMtOTHCBTv3X6fpfpmhSoa1?=
 =?us-ascii?Q?RAoSgi6Qd+jjaURO5rLioiEoifgMOZKnw/27T4mCjnvjbCPOFpnPasHJM6DI?=
 =?us-ascii?Q?ydMa6BzPwUVhSo0iDBNkgH98AwEEnMwXoglCzkwrqdZ//meYcu9U2LXX7Jal?=
 =?us-ascii?Q?QfsPBp5Z+oRlUlBXXBDp7Hy6fatzv42fq1d2qM/Pet0s1N81ZCqcXQVbjQR5?=
 =?us-ascii?Q?oUY0ZQRoPCzeawus+oHaEuMKSAQ1Y1cgmvHFwGuL4oQYQILyE1pVez6FVzja?=
 =?us-ascii?Q?l5ICOpdO1/Rqfv29gGcnnL4wQpj+1Zubbw0xYd5bJdlDMcijr1zV0oxb/Pby?=
 =?us-ascii?Q?cqI9BVuYIl/qyp+zWcCB9SNBpSuJ0fwPAc7OFnOzfQyJ20bEw2V1gK5IdPw5?=
 =?us-ascii?Q?qSiLofakqvjy/Y5JQvm96yqHhkZKx8VK+8D5KMD7cuC15P01r+zLmUBiLLFi?=
 =?us-ascii?Q?+mujLjYKTkb0oUX9Xz18OAoMoZJmszfLjx+/+Aq7vhmeAFSGXOpIdB7C99ew?=
 =?us-ascii?Q?u78M14Ndj5Ahz+rJj2uLX1Tp0L5cRExIUhRvUPkU3WxkfzgjWHqL3+7Bamoe?=
 =?us-ascii?Q?jhbbmGwIQyDOBPRsavwUBniUYEHU9CqDr2TToKaeOMIPUSkRX3J07Ho4a9FU?=
 =?us-ascii?Q?6JpmuwwXIIxznQbciLv4ibhxtOp6YRYypbOu75RQs83HhJvy9HbCCCxdSbME?=
 =?us-ascii?Q?cT5VXfiP8AMHRaSUoHpmnG0cr7sJsJHdLlUGv5zSJX6bfy1wAGvxByVvdx8S?=
 =?us-ascii?Q?3582G4ZBe6yZMsVEBNg4dgBcuYxmRHD/pFW1jE+kLcKWtE6WoUXwT5Gyvlal?=
 =?us-ascii?Q?qLlu7yjvXEoSaARHSKTB2AHteUzMpEl/osu3WlMEz7Lu84onnqNaoqnY/3ao?=
 =?us-ascii?Q?LZABp01uZIsZf7IJB3sb1srOMf/UGAPHM7PCw5SmJ0M+5bO+hwzms8N3Ri4S?=
 =?us-ascii?Q?uEx9I2MieM8ildFGCGtQycT9at4d/YqierrygJoaa81gsJrB2pwgCu+d8xeC?=
 =?us-ascii?Q?te3u+g17S7T+JOdQk7lVoowS6VoWFHo+ntmusHa9HJDfXxWRGjjeuBoufqwg?=
 =?us-ascii?Q?hNFv7w5ZbwBS6V50fMqpWtXOjil5ThoO9bf0bGem?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a5d72f0d-c6ee-446c-6eb8-08dd9445cad2
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2025 06:49:23.4314
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S3DySkwZ6VCtOnhxsEEm9sdYNqMlr7509JciD/rdxmL4TaFtpJG2ZSlEVPcN1H+5urpRpCChtsboe0o4EmNGsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4894
X-OriginatorOrg: intel.com

>diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>index c8b8a9947057..026b28051fff 100644
>--- a/arch/x86/kvm/svm/svm.c
>+++ b/arch/x86/kvm/svm/svm.c
>@@ -4308,10 +4308,13 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
> 	svm_hv_update_vp_id(svm->vmcb, vcpu);
> 
> 	/*
>-	 * Run with all-zero DR6 unless needed, so that we can get the exact cause
>-	 * of a #DB.
>+	 * Run with all-zero DR6 unless the guest can write DR6 freely, so that
>+	 * KVM can get the exact cause of a #DB.  Note, loading guest DR6 from
>+	 * KVM's snapshot is only necessary when DR accesses won't exit.
> 	 */
>-	if (likely(!(vcpu->arch.switch_db_regs & KVM_DEBUGREG_WONT_EXIT)))
>+	if (unlikely(run_flags & KVM_RUN_LOAD_GUEST_DR6))
>+		svm_set_dr6(vcpu, vcpu->arch.dr6);
>+	else if (likely(!(vcpu->arch.switch_db_regs & KVM_DEBUGREG_WONT_EXIT)))
> 		svm_set_dr6(vcpu, DR6_ACTIVE_LOW);

...

> void vmx_set_dr7(struct kvm_vcpu *vcpu, unsigned long val)
> {
> 	vmcs_writel(GUEST_DR7, val);
>@@ -7371,6 +7365,9 @@ fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
> 		vmcs_writel(GUEST_RIP, vcpu->arch.regs[VCPU_REGS_RIP]);
> 	vcpu->arch.regs_dirty = 0;
> 
>+	if (run_flags & KVM_RUN_LOAD_GUEST_DR6)
>+		set_debugreg(vcpu->arch.dr6, 6);
>+
> 	/*
> 	 * Refresh vmcs.HOST_CR3 if necessary.  This must be done immediately
> 	 * prior to VM-Enter, as the kernel may load a new ASID (PCID) any time
>diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>index 25de78cdab42..684b8047e0f2 100644
>--- a/arch/x86/kvm/x86.c
>+++ b/arch/x86/kvm/x86.c
>@@ -11019,7 +11019,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
> 		set_debugreg(vcpu->arch.eff_db[3], 3);
> 		/* When KVM_DEBUGREG_WONT_EXIT, dr6 is accessible in guest. */
> 		if (unlikely(vcpu->arch.switch_db_regs & KVM_DEBUGREG_WONT_EXIT))
>-			kvm_x86_call(set_dr6)(vcpu, vcpu->arch.dr6);
>+			run_flags |= KVM_RUN_LOAD_GUEST_DR6;

The new KVM_RUN flag isn't necessary. Vendor code can directly check
switch_db_regs to decide whether to load the guest dr6 into hardware.

In svm_vcpu_run(), referencing both run_flags and switch_db_regs is confusing.
The following logic is much clearer:

	if (likely(!(vcpu->arch.switch_db_regs & KVM_DEBUGREG_WONT_EXIT)))
 		svm_set_dr6(vcpu, DR6_ACTIVE_LOW);
	else
		svm_set_dr6(vcpu, vcpu->arch.dr6);



> 	} else if (unlikely(hw_breakpoint_active())) {
> 		set_debugreg(0, 7);
> 	}
>-- 
>2.46.0
>
>

