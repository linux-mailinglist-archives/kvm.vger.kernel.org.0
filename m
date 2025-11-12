Return-Path: <kvm+bounces-62861-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 92D59C50F41
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 08:33:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 0B1CE4ED3FA
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 07:31:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9C372D876B;
	Wed, 12 Nov 2025 07:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bTDAvyTP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 738FC26E717;
	Wed, 12 Nov 2025 07:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762932666; cv=fail; b=cwXht6Wy3HU4ZsAL/3xeFxkWlQhxk2/IewaFUXU4cTle8uoVAzm6Kv5mJOZNrSBZHa3Wu32h525Gkaf8OKjTPF4x5XrsMrgQvEqaYClKjb7F7aYDTsIADMwuo1WHYTOX0b8qctrTA2ioaRlqTHwF1TqGYswC+Dea6ll/xXJNmkw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762932666; c=relaxed/simple;
	bh=kFLl5QUWA+1uMqQtnbfMYfy5vqU9RUCgVz5ThYx3aRk=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=gtGKRN1MKVtO70YE4DSCq6Eg23k6gTWkS410norPYf5HI6aW9Gcq8qJs8YThLS1Rhj/tG0cgwtZXHld+JKPwj5oh/gVN3Se/MtPhBoSyHokVsMCkplLiiF/rAahMYWoOIBNHNWhjqDjyS40SyIcneezsfKk8aIM+RbsQ6mI8/Pk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bTDAvyTP; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762932664; x=1794468664;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=kFLl5QUWA+1uMqQtnbfMYfy5vqU9RUCgVz5ThYx3aRk=;
  b=bTDAvyTPgwiKg88wPXO+xmZ4iZTLLIyJz+aGTYjh+fv1B34pM8EQx9ye
   /Q1pcRvR1Vez1nRGjMaPo1bLAjCJ/BbfI3jll0eWi+TW59o/vr9N4lxhu
   iqUQAtGnjbq0uyLPDaV4FMXWScFBoNHEcoqiw5eQstWwYaY14Yqq3JQu6
   AO4+O4hEo2YfQ9XjfbU7bDOVrrZkKF0UjNEg0DI/KKltlaiiA3E4gvtyv
   gc6u1+vAnJXQEhyCfzE1rTvE2mKq2NcZnjjzR/RkWYlDJtqap0LKcF0nw
   JYxGJO/kUpCzWm1s2YCO3bcy4Y/9hoU34liRazMAz3S1PmIVS3IxUUcui
   w==;
X-CSE-ConnectionGUID: 0VqJLTvfRUunZ9gfnl1nJg==
X-CSE-MsgGUID: +hEq9qmNQ+yJNLN2DuLgzA==
X-IronPort-AV: E=McAfee;i="6800,10657,11610"; a="82621780"
X-IronPort-AV: E=Sophos;i="6.19,298,1754982000"; 
   d="scan'208";a="82621780"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2025 23:31:03 -0800
X-CSE-ConnectionGUID: Kw0apb8hSFmkiKvJtIx/qg==
X-CSE-MsgGUID: vVn9J7poQB6HeXLpTBQ29g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,298,1754982000"; 
   d="scan'208";a="189877906"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2025 23:31:01 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 11 Nov 2025 23:30:52 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 11 Nov 2025 23:30:52 -0800
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.57) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 11 Nov 2025 23:30:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qEERLvPWMHnSe+zRAVpluMVLnglqfEqYHnRQb5HeVcGGVt38No8XVphNFx6G2j9VIeA0mL3/+/mrZko4eFS5r3c46g7IYgNqeZhJUU//M3ih19VaoHg1PFw5gdOcuf/iXBx0Y6RxGaca91WJNP+BRONkrgVzs/TAHeNgGxCgXrdLts+8Bhuy3aaKvwg8XIXpKTrO+bWTtd2Gie/Vl/+mpESG2YR0q9FLQs7vY/h30qz7V9MumcOpX0A4clMiTr2XU0GHzsXogKR25iwctIdekAN6bLONWI2EvuMsvl87LBYtLCnuTcMNMB7sKjTT8+Madhht7z4F6MgstULoDqPJqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FlbKno8uJC5xnioozlsiQ306AnjuGCpPa+2qBUdqDPU=;
 b=NCexXaeQaJNY1G9PazwOYRdrSjb80LGnpHYXSauTpUvUEBbPzlql3RCFNoWoJndhfD1AaDE9mCUtGgOtI0w4F+ZimJqFN+CQarFtq7UWxanFrj5Ek5GHeOv4BU+I0yvDQu8v8Rq+3PslPsDX93CjmXlrCrIwh9G3ewfWycZvIJBPNLpNnU8e8Y1mcFx+8tgO1vPaGIlVfJZ1KdA+GvFvXGdh9NqawpgmPWj6bLtY0464chGZdJuH3msSo0MceemMEhmxDH1bQHgwV796qzWItrX0R7z+EkvWcvePzW+/y/9BuTIqmV0FBid6CDnuhAs+IBgNOLRjsOdOC7Ssk/U7tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by DS7PR11MB8853.namprd11.prod.outlook.com (2603:10b6:8:255::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.15; Wed, 12 Nov
 2025 07:30:50 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.9320.013; Wed, 12 Nov 2025
 07:30:50 +0000
Date: Wed, 12 Nov 2025 15:30:38 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Xin Li (Intel)" <xin@zytor.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<corbet@lwn.net>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<luto@kernel.org>, <peterz@infradead.org>, <andrew.cooper3@citrix.com>,
	<hch@infradead.org>, <sohil.mehta@intel.com>
Subject: Re: [PATCH v9 17/22] KVM: x86: Advertise support for FRED
Message-ID: <aRQ3ngRvif/0QRTC@intel.com>
References: <20251026201911.505204-1-xin@zytor.com>
 <20251026201911.505204-18-xin@zytor.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251026201911.505204-18-xin@zytor.com>
X-ClientProxiedBy: SG2P153CA0036.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::23)
 To CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|DS7PR11MB8853:EE_
X-MS-Office365-Filtering-Correlation-Id: fcc6f062-c2a8-4e3f-fa9f-08de21bd6762
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?PuAM30/qvpzZLRORLblWFPPZcUjl9sdlBLHtQrpEBi+szNGYzq29hupQI695?=
 =?us-ascii?Q?3NHPWA1iu5vIIZr54//vD9wp4kzsXPAEO1bHG7F4MpgO7zvYPpCHsETvNXJE?=
 =?us-ascii?Q?vMFTxSpUKgfmkogiSonyOfMYDxXmZwxbySWik8tcchGbYpwZCD7GM0bYuNqx?=
 =?us-ascii?Q?a9czEoRdogvKz2owsTyOjMRItaTfQ6MRCo1R8ExnprpdYDnAwNMXgFGJ1b4Y?=
 =?us-ascii?Q?3qZv5rGi1eMzqHk0kK4tvYxSW5dEs6/X9OJOFbtew9GjwMlpH2JruvRt53c9?=
 =?us-ascii?Q?s3UgiH8gPtLnp7ibEz36Payujr8v+hhMVowbPkdMi8QspNFdRxnVMX4ZdwwR?=
 =?us-ascii?Q?8VvtyYgtSSgfEPqrebQC18fVJbRBs63UdoVzQKY9B4tWbGM/XhezzqSh4hSh?=
 =?us-ascii?Q?TVJKOCttKF+baAxgH90h7F+W4dF7fDAB1m8wiIlwkierQhyAk6m6BSNNBa6d?=
 =?us-ascii?Q?SPVhw16JCZ8AGqu6YGKfZyH+cOSawpMJ1xcEtxkBq8UURg0TOkL96x8JELre?=
 =?us-ascii?Q?S+DEQ4NIhAfg3KBIB2+b/eUgk7ov3occd/8/8MLMnfOmUjZCN0DUMhdzrjMP?=
 =?us-ascii?Q?LkohMWxMnMLOqGcZy/A4a1yX6cGIGigIC6yJ30dbrVMbBmXlm6SW+qAtmCns?=
 =?us-ascii?Q?1ZBoQRoW4LYfmQd1FLZlLZGeHIwCzy3gDHcoXZhjAD3dPrLIRacMMIQiPvhg?=
 =?us-ascii?Q?+IVOukLsaoqV1lJLX4xU8/q7JdBGm+G5cTve/LfYuY/strw4TVRiCcYUEbKd?=
 =?us-ascii?Q?bdj9IKSk1d1XvvA1XcQL12lmK1yjHOzkAvZnu0JSyfz2P3DSzZkd5t5WQ31a?=
 =?us-ascii?Q?iiIx5amE20zsaEbhgD2pSgbGHjWdGULShgF7g6qkCkxw58Bmpk6M+VwpuoVi?=
 =?us-ascii?Q?7gxnnI4GbSefVBjRmp0pluIwNKNh+RNM83ZLn7B8nFtiKnFIV2GSEjOr3x7n?=
 =?us-ascii?Q?DOR+99K2E7fJfMTBsCKF4J0fLvXWpPdFn07M1v53Q4D9SxLfbpGQIK/giNjV?=
 =?us-ascii?Q?GvUJTSnhpFDt4CxJUlwHT6r0KOjcw1xIMNZn85eS3GDphIyhWAxcp1xPQADM?=
 =?us-ascii?Q?2neebseDBEgwfmYI9r9lxylA9mIrD9EXUhazlvRvEnCMm8xh9+9gUfPXGiFb?=
 =?us-ascii?Q?Znj+VH5urUhvokdP69pZrYe+q2NF/lJGUbr2lTDOH7NufMuxzCxJMjwkhMlM?=
 =?us-ascii?Q?lQlR2tGxoAgItYjordbNfOs7CLp2OSjZnCOwUEQJFxqZ9SgRgzdDN1NmqQvV?=
 =?us-ascii?Q?Aa/rudOTFRXzivGFccfzJETYvNdR5yg4Lxi3rIFksR3JNzhzRsuh1U0Xa8a+?=
 =?us-ascii?Q?o28m4RB1EIG9xyXx1/yPSNUKdqneTIe+m+Tl5mnqM9s6yX0b8eNO0W9KiadD?=
 =?us-ascii?Q?MKp3qyPl7cWKRYXd2IZ+k4jgTpZIv8YGTwdX3NEJ7nt454IPel9b+oxhVl8i?=
 =?us-ascii?Q?0F8w1DgzQvOtwlDlSRi5Np9iK1qvXeWI?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sSXvJNmwjRhPHxr2/L/CXiuV6AstVqQ/HZ0nz5BLHsmQq1ARr7/RaLUzLzR+?=
 =?us-ascii?Q?Jh0zYtx6lZYr6sKQZjkvMsgKoJWmXP3p4rvI0oHMd9EDYAX69UxfToyB5jvt?=
 =?us-ascii?Q?bkzpMwNu9sCW6DEPC0kHWJPhL1oOEaxJs6puORUYRsN54+eFsnLo88iEPSTI?=
 =?us-ascii?Q?7ALRWXHkjKNuF3cAg9BJsnmamdY2UsqTNFrIWiK+e42uCuFhZeIunEowHJ7Y?=
 =?us-ascii?Q?laiukCTxRXG6/3gY8ncSNW7oGdPfqZXGP0EVGNvVBvrCU3sXbVPPOFpqUFfT?=
 =?us-ascii?Q?CGPrmBzbvyPHxEklITOkhLnBYGG1lSNp2X+yfuTvMn2TQGYNpeY317TmHc+m?=
 =?us-ascii?Q?w/wODOWMKxpNx9EaSfieEsi/nZpk5XfoUzChMb0A1ENIb6GbGRdmSoDbR4lu?=
 =?us-ascii?Q?Ktz+mX/BptBDa5bR09wiDd4i3CkSPjmAWrn/FvBGCMB4QVJMFgFBxnw+rMFW?=
 =?us-ascii?Q?YpQsj1UhwUOnoKENlRHx3Nh5/a4mu3lNkplVdEfznaXNOl8XL+rxfmMTj36z?=
 =?us-ascii?Q?GKlDIbXtxI49zL5Td+b+5pcpnC14oKp/nllBMm2aMNhBBmTmIumEFCxWA00G?=
 =?us-ascii?Q?lPVJkbSRzvqNDpTIrFXLe3JF/lij2Q+uf0WU2aMiVFtG69yQsaTudgZHQSuF?=
 =?us-ascii?Q?gR6cand5/yBNW8qXsfTwtRTHd7tP02wsgiz40paMQDlT18SRTXgvYzdd8Tjo?=
 =?us-ascii?Q?qI1MIOPDrNocBpscc3e7dvtnQFmqpeOV5xH/4oiuKSFoN8UBxqcQZEr+Vifj?=
 =?us-ascii?Q?2QsNexz/vAEWaDowyQbQuTSOzMx9IzkwnXJSLxAKkWwAKYP1SRdU0FntSbqw?=
 =?us-ascii?Q?+i4RhvIAQ1UGXxOBXmxkLt19TVUCF3sCovgvk2hDuUzcD4WtJm1ZxEj1eYce?=
 =?us-ascii?Q?QEq5U56rJFqhFyeOenb/5gNzo+oECejvkAF7oqpBgQAeKFIaNSAxXT+pXSNn?=
 =?us-ascii?Q?eHXr/jlJD4X15fiSBNmvSyHucV71t2VdrILyK3/bjUENcEL8DEFOEfYoBz32?=
 =?us-ascii?Q?CeEczMNfcjG0OGHzZTa6tk4AWPJWhFi4L6CquA+TTUlZXeIBA0nyMBN8hM2Z?=
 =?us-ascii?Q?x/vKodBncnHjY23cmkcvTDJivIDGB0PLSEhdXtg3og8OdrWpxdjHbhdiV5xu?=
 =?us-ascii?Q?8BmzM/k0pNaHcRIsFWMKtk+i+HCXuYi0cauyD/D9JisMf2ZX2wbbW8evqYrb?=
 =?us-ascii?Q?5NB7FzaZfJiZaC/qymrcY8qcBwe6n9qDFk4swbv6uLVm+Q7W8Rh+BRERV1v5?=
 =?us-ascii?Q?1rIXT10SzW5mWZgkwFm0zQ90ju7oloyTKLsDxCpKtNyMFdMO+3DvsTxBp5nP?=
 =?us-ascii?Q?4Xku1GIgjrJiR6fhuphpdf7ajCD8+A4oZyuKfZKF6AU+r3NZa/YS7b7s902V?=
 =?us-ascii?Q?Y3XdfNHmMv4jqdTZ/9KHxTVnfjYeaxZJbfJ1f++nffDEbL8jHNnI+GDVNzkz?=
 =?us-ascii?Q?VF37xEwmUptdXRz/Y4QgSDVB7yFH9sX4Z1QBS8Qy83OKeqoWtuf3+2vdzYTe?=
 =?us-ascii?Q?2Qyqg7Z44Oelu+VT8xPmaR/TiIleWC/OxKQwbLmkwDQAwnQgrqha90RbzTEm?=
 =?us-ascii?Q?LfPJc7QRZJwIhFR3BS0OS0xUvXoIOqx8kGod7YCm?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fcc6f062-c2a8-4e3f-fa9f-08de21bd6762
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2025 07:30:50.1671
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: miKjGl7/cgHEEn600IK8X8RkGk1iMIZoWj6x51jYnu1UhZ5B0nEVmG0fRRKPG3Pmo+QzGrt2kiH/vtVCqJLIgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB8853
X-OriginatorOrg: intel.com

On Sun, Oct 26, 2025 at 01:19:05PM -0700, Xin Li (Intel) wrote:
>From: Xin Li <xin3.li@intel.com>
>
>Advertise support for FRED to userspace after changes required to enable
>FRED in a KVM guest are in place.

I'm not sure if AMD CPUs support FRED, but just in case, we can clear FRED
i.e., kvm_cpu_cap_clear(X86_FEATURE_FRED) in svm_set_cpu_caps().

With this fixed:

Reviewed-by: Chao Gao <chao.gao@intel.com>

>
>Signed-off-by: Xin Li <xin3.li@intel.com>
>Signed-off-by: Xin Li (Intel) <xin@zytor.com>
>Tested-by: Shan Kang <shan.kang@intel.com>
>Tested-by: Xuelian Guo <xuelian.guo@intel.com>
>---
>
>Change in v5:
>* Don't advertise FRED/LKGS together, LKGS can be advertised as an
>  independent feature (Sean).
>* Add TB from Xuelian Guo.
>---
> arch/x86/kvm/cpuid.c | 1 +
> 1 file changed, 1 insertion(+)
>
>diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>index d563a948318b..0bf97b8a3216 100644
>--- a/arch/x86/kvm/cpuid.c
>+++ b/arch/x86/kvm/cpuid.c
>@@ -1014,6 +1014,7 @@ void kvm_set_cpu_caps(void)
> 		F(FSRS),
> 		F(FSRC),
> 		F(WRMSRNS),
>+		X86_64_F(FRED),
> 		X86_64_F(LKGS),
> 		F(AMX_FP16),
> 		F(AVX_IFMA),
>-- 
>2.51.0
>

