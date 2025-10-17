Return-Path: <kvm+bounces-60282-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 68D54BE7421
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 10:48:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id CC2E0504F1B
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 08:47:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50C4529E0E5;
	Fri, 17 Oct 2025 08:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="j6FIOZBq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D58C7296BCB;
	Fri, 17 Oct 2025 08:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760690850; cv=fail; b=bLnIjUVP7FJ98gCC6bsAIDkRpVKFel12ruUIjMPEsXQQ+GRqbXjdDPUbrlwWBrb5At67IeW79zd5tyypJLoZV42eanFlc4EXK5+HuJ/QnG5zTswVLHOvR5ZGUviraufA3qQ1PrrPZFrbKZkp+1yKiJ/xu2fWTEjBrMcbGJc7y/g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760690850; c=relaxed/simple;
	bh=Qk2PXLP9eSCFURn6qYSLBZi2oetyYhk9Xf762b6qsHQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=fpr0bzAmcMlkpit5KpjoI3zeyO0MtIVZdLxTYcUWzvSMOXeuKEStR9EdaZCHNUSJuhPhIbtniiVHkFlhiudcykMrwn8Y/fRMzrF1Irz9nmA3xBpEojy/VTfjHvaAm/J77Uyt49vtKBAspPErGjiSgZAvlGK1T4ZLbrsbd5XcQms=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=j6FIOZBq; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760690849; x=1792226849;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Qk2PXLP9eSCFURn6qYSLBZi2oetyYhk9Xf762b6qsHQ=;
  b=j6FIOZBq6i+w/Rj48OV2UswLAMMRV7gYJeXKF7cSg0WZAr96MYS2XUDG
   1BukUlzNveGVHBR4M++tPtDgXFIo5Z7uSDYrLCeN9ufjq+mQK4stMOEMX
   lo4CsAgMHwfQhBZ6lw6V/6MsqmHw5A8cqXcTePxRi9tRo7QV4lIBahj1N
   W3/EOlZszQlSCgUJBAfThVzuCJCH9f+95yFCLRNCPFvJeyb7eL4DXFueq
   QBTIJ3h/jKTB35zxJDSLJ4zOIg/7BxCyc6duN72BGWPeizVRXH0YWN4Sy
   fZprPw547kgOacsfoDn9vUImskGxBhUHrLSZi52/zcbhFP2IgHhge0o4O
   Q==;
X-CSE-ConnectionGUID: 15OWlljtQZiFgB5mtO5OAg==
X-CSE-MsgGUID: sdgTB6gQQYaV3rnOgQAUEA==
X-IronPort-AV: E=McAfee;i="6800,10657,11584"; a="62609098"
X-IronPort-AV: E=Sophos;i="6.19,236,1754982000"; 
   d="scan'208";a="62609098"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2025 01:47:29 -0700
X-CSE-ConnectionGUID: fhtMaPkwStKrIeWV//+LHA==
X-CSE-MsgGUID: E5JDGCD7S9WbZFtOfRvORQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,236,1754982000"; 
   d="scan'208";a="182619263"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2025 01:47:28 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 17 Oct 2025 01:47:27 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Fri, 17 Oct 2025 01:47:27 -0700
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.69) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 17 Oct 2025 01:47:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VymDCgiXtrNvO/6pokzpFE++zJS7zHIEZTMYKlSfNaUo7IGMi8doSiXBB8THEyaIO1n91CcF71CyViiN6zsZXCP9Ccpn2BSyEDFF0wcOVpNeMRB64oy+mCi956EvTqqe4e6T0Aimfcx1ueYj0xI97dF+Sdy7M3ivf5etYUKB+sTQHHNFHxH+I6jRG70yZtBHrmo4T5xEg9aQXP48RT7n8ndzh5CWK/4Q/NGRcWyqWnZxAv09Er/TmQ7mLac4w97AiY/0owo+CcOytnLq9vxcz4NV6eX0pWqnWZy3c2m6TFxIbZ23UhUC5GiuKedgf3Avy0KsNfb+CJK0arHln+9Jvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nlEbx9H2YeUB6y6lv6VJb+XpSNxeJZMDG8+fLKmqFhM=;
 b=Z9jfQi6kCIg47bOz9HrcRqCRX5CA25hq/u4pxfx3LaigRkgo8XY8yHE539FX/KfkxJW41By0rUaFdr4WEF5W7ua5+JKnrf0015w5+CsY3WruQnmuZrBkV1BL6GpEdLW5Vd8YfN0yeNVK6s6MlteuZMHSEIiFRZ1lVWZ+dG7pdc8lHwhqdIu6Ayy5d5ZVGeZorNIS3wp0xkFIQcm2IUESd3gxqBZNxoPOsf65WpDhSqGQU+q/hvKjnVFDzEHpMVYiedpMWUC8USpe3BbZuURx2ZxpiCWmCMcoBKDoTRmRV0joMO9g6+J8heqn59eMr/4yhTiwv3HeJVqLmHpm6XhD9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SA3PR11MB7486.namprd11.prod.outlook.com (2603:10b6:806:314::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.12; Fri, 17 Oct
 2025 08:47:24 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.9228.011; Fri, 17 Oct 2025
 08:47:24 +0000
Date: Fri, 17 Oct 2025 16:47:12 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, "Kirill A. Shutemov" <kas@kernel.org>, Paolo Bonzini
	<pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <kvm@vger.kernel.org>, Dan Williams
	<dan.j.williams@intel.com>, Xin Li <xin@zytor.com>, Kai Huang
	<kai.huang@intel.com>, Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [RFC PATCH 2/4] KVM: x86: Extract VMXON and EFER.SVME enablement
 to kernel
Message-ID: <aPICkLKEMFI2OouB@intel.com>
References: <20251010220403.987927-1-seanjc@google.com>
 <20251010220403.987927-3-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251010220403.987927-3-seanjc@google.com>
X-ClientProxiedBy: KUZPR03CA0024.apcprd03.prod.outlook.com
 (2603:1096:d10:24::16) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SA3PR11MB7486:EE_
X-MS-Office365-Filtering-Correlation-Id: 66eaf507-aa11-4975-4528-08de0d59cade
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7416014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?LUsH5FEcwbfFesuD4UJJT3hpQbc6ADwJ0qinaDnQpVf3jfXFon/0JwiDZnyN?=
 =?us-ascii?Q?uBfVtCj/OZC6DbESz5rBo3KcP/gLQSNYqEocmwl4oy/AUjEReBb5oP7S8VjN?=
 =?us-ascii?Q?DsQnpklhMp8Ag7cSgwKpF7N+vgke97W4jiOK9ucZGG72j6sIeg1fC1kNVMc+?=
 =?us-ascii?Q?OemRYO57KFiu580HmdC68gOnw5JJRyfenbaT1fX7RK44P49uUXQ+BqmHQRs4?=
 =?us-ascii?Q?4I/tPo3hQ1+phmhYVUMul7UqczQ6KKVxgxA8oFCtFqR4hm6nYSX6lseVmTMv?=
 =?us-ascii?Q?rwpSAr+bZWlhL+0lfDVURHTRXdYxaB2ju4NghNa6sEkKoqlbtPbmx+brCt5r?=
 =?us-ascii?Q?p5O8lCDCPmz4T+OPCIGTWHWNdutPUhk07D8e6f9X0s7Sr0QPNWwKw7QWTu0A?=
 =?us-ascii?Q?kqINSzT7xrVl1kpMcEhjqz+Nk+8Jo5jfb/mZMZn2/1eka/yvlL7mZvxJlYNQ?=
 =?us-ascii?Q?2N9AWTRFOvOz2emEXKPBo+mGRTTDH3fNLn7Af/xnF+GPkIJcNAWgmr47jsP8?=
 =?us-ascii?Q?KFk6kpSms9PtkXBJrrspM1WToNtaPpGUSeQnHJbwbM3oW6SwR6cbRapzhy/R?=
 =?us-ascii?Q?RjiaUhvlG2As2lkxLCaXa+VatzG3at6fckD2BrV1LnPGsnEn18OQk0CCqEBW?=
 =?us-ascii?Q?pRsfhQb33f8xx7T8FyMY4zLGBk8bkP51JxQpiCSUDLeZmrqn0Haor7ZJIup+?=
 =?us-ascii?Q?ySPcZYb+6CnYq6nqX0k1gtsFzOe2RftSakozia/koFa9BfXU+ARIH/MB6qwe?=
 =?us-ascii?Q?Pa9Id/DY34zkomNKkNAKfrO4JXmzdpxJ2liUHVinnEpZQJRFHW4wLAW0YJZD?=
 =?us-ascii?Q?Ntp6JrQhhkEuOlcCqMLoGHnDvbAs3h3WAC+Zcc4wbkFO8o9Vdi76N7hBVWcS?=
 =?us-ascii?Q?t7n+9z9GStE45avD0N9ALz3N5znvj8QuTzr8gGH7ghOJ8QdZ5xCR5olq5BSg?=
 =?us-ascii?Q?7PLXiL1tjGnzs4Zk0BiUjv6YthHenf8QM2jCs+Gw7oGCGhilKVwq/pxRFYmj?=
 =?us-ascii?Q?6btC/8u03qLXdRnpW9v26Ql5U2W8I7/Nc0BL9Hh6q+yPH85aFRnZB962zdi9?=
 =?us-ascii?Q?sbmfoEfOO1u4WUGcPGJNwNT0L/3AFDpAKatnPGeBZ/lpAfxkjS1Fo8pLvtJV?=
 =?us-ascii?Q?94xfPFdb2QYcB+EDFu6BEtqf6bFdUdHA92m/S6mXakCmjlW1oTs6YgDxXl5f?=
 =?us-ascii?Q?mDBHF9PPeO9/M1UdRY9kHcHt31PnR6Gau3kOLxYSR2ksp1qWmI0eydhmQP1O?=
 =?us-ascii?Q?j7yq0IXHJ+6n0oMm0wLYyvTxmYz1kGnkECnWVMnRD6YgAhDfTGyKNInMTSfT?=
 =?us-ascii?Q?qOne7mBhMYH1e1UUKW6k+AKRnQtmNvlVjYoUGhkTAKICbcznQVAyB7nZHPTg?=
 =?us-ascii?Q?siHOkRznmWxgclJUVvlTfyJkHgi/V/fQzm2L6lXQNxk5JcSJvGGJkyxBUj5W?=
 =?us-ascii?Q?4L9+wDk1bZsIPhtU2ospdEjb2w92pr35?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EtWGws26gM8sVVXpEL077JzL645Rq/1F9nvaMm4cnkRaf/G3wZuziYXyhlJf?=
 =?us-ascii?Q?Peh+Vi8idSCF/XoBPURum+m/bAkV2Kq7lh4ygfsr+FLOXLAIJEp2KHVcC0mT?=
 =?us-ascii?Q?lurNZLUxxenXDrxfQiF9rtp3YXpn7N+dzP1EmSLVp6PeSEma5X5/Abz9lCFv?=
 =?us-ascii?Q?g+59XodgZ7jYmsM+MPTYwomPiTxdKxGNEd9kzTaGcSysG42IP/1Q0weKrIUU?=
 =?us-ascii?Q?g+yP6RJOg3PpAYyfmresDdkHyOre3UlQ2QAbNCEv6+rMMPRGRmVi5jwTEQQV?=
 =?us-ascii?Q?P1tS4Qn/yj+efBsWWgo0peb/jx9w4H9Ji+SMM/LS4DszoFa552i3xdI+RNB6?=
 =?us-ascii?Q?tYNbG4Fh8Yrpi4s+jSNnA9Sc/T4uM+vqOxz+2KhzNIvJWEA2fZ33fJyawM/1?=
 =?us-ascii?Q?myvFcgttcBzHA6N8QaGXecpGPF16/4hNp4WsEUj2PwO/Vuf9iUOFt8h5NKvS?=
 =?us-ascii?Q?LrI3soHBll5UONnJAUmyS4sAWorQIoTpFk9BxxydP/QJ+Pj0hXO7bhM4DaVW?=
 =?us-ascii?Q?WzG+0J/mmH3CV6Le6aewlQxwiP0wHiVUHE6RLaTXmKpxz6Ff3ALCJOX/jxzp?=
 =?us-ascii?Q?DxTm9KPIrqp90eZX6aofxEc4nWXnwjB23iLbusWlTzwbxRLjrsNwLSvq4ItN?=
 =?us-ascii?Q?60NBECOTJDqzSE0TGjR8IXzOP2iM78CXdGtexZm2+GSV0jM2Ji6yonoWQfio?=
 =?us-ascii?Q?34RSBUtSBgp2Akkse4jYITODAfYn+EMWIIECsVp+tVEq4HNGxCbT6rha1iCg?=
 =?us-ascii?Q?ggc0ZfEliXviYxNz8p0rINuB9ozESWudS3w6nR1SfvDchvN3eQPgBv7O74ie?=
 =?us-ascii?Q?c2aiwUsGLUHWJPdf37aD+jlpwZa6gusLddMmGNqnpFxysJF4DYQdk0Snb7ag?=
 =?us-ascii?Q?H54sODrMteklm/1pwTm+8pz7X5utHIbG+SLJHeNpziWMtgQAUfXIzEUcR9om?=
 =?us-ascii?Q?N48M1Cv80toV89np10eQ8ht5Lrcz4I/JYTL0CztgJNyk0LxSnpJe3Y2NbWRe?=
 =?us-ascii?Q?4+4DCHGL7U/qQIj6BDfuS0tRM+EsulM9XlyFFn9uxoYKUbKqDl8lPPQ1NjDN?=
 =?us-ascii?Q?BhHIX7TrZa7pnvNKQhfxh3bjZ3s42/9GjFOibjFrJpEY32HenJDdq0kFMa4v?=
 =?us-ascii?Q?ZOq8zD0Fp1gob/CyAeWQ1wsgrNKysjEO6FPdP5VllPcpjxJp38mOKymhHX9h?=
 =?us-ascii?Q?6C0YLhfQ9Dia3kFyEWEZMKdVDN4+UsWhOxI8os9wj+a/MERXsj1etZSUL51U?=
 =?us-ascii?Q?BNyj2OGFOih/cd/nMA1Mhhm2vFPA93BahRgtXL/TPELMh5bd7E60tgDlVboq?=
 =?us-ascii?Q?J9TIH5NnStLXpc0wwJKAf3+CK6JPx9KU8fIG0HrQU+WrdzpmBb/V1DBlP8jp?=
 =?us-ascii?Q?QGoc44ItgR4HgiH/pGgzEZCrmWEllCHL8ADl3KczgtuahhflfoWr+aKkZTef?=
 =?us-ascii?Q?s2SatnIKCtRYBDQzmu22DO86LHL1xDbreMRh1g/mGPfNSu/oixhNpHd20viF?=
 =?us-ascii?Q?W4upd72+eHsh00LXFveed1rwdLNn1cM3wjDtL3ptI0isyfNX20ERZFGbtxjK?=
 =?us-ascii?Q?vv18je1wHqeCcIn7zVioEOoKK8D61xsuwYeIKjJk?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 66eaf507-aa11-4975-4528-08de0d59cade
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2025 08:47:24.3794
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GW3nzrZxwskqyTaHUsISoouwnlV+db6smz7OzZpRK2Rk7BhdC2aSUfgEa/5/ZknH1nl0wYSZTOlPeRwmFn1gmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7486
X-OriginatorOrg: intel.com

> void vmx_emergency_disable_virtualization_cpu(void)
> {
> 	int cpu = raw_smp_processor_id();
> 	struct loaded_vmcs *v;
> 
>-	kvm_rebooting = true;
>-
>-	/*
>-	 * Note, CR4.VMXE can be _cleared_ in NMI context, but it can only be
>-	 * set in task context.  If this races with VMX is disabled by an NMI,
>-	 * VMCLEAR and VMXOFF may #UD, but KVM will eat those faults due to
>-	 * kvm_rebooting set.
>-	 */
>-	if (!(__read_cr4() & X86_CR4_VMXE))
>-		return;
>+	WARN_ON_ONCE(!virt_rebooting);
>+	virt_rebooting = true;

This is unnecessary as virt_rebooting has been set to true ...

>+static void x86_vmx_emergency_disable_virtualization_cpu(void)
>+{
>+	virt_rebooting = true;

... here.

and ditto for SVM.

>+
>+	/*
>+	 * Note, CR4.VMXE can be _cleared_ in NMI context, but it can only be
>+	 * set in task context.  If this races with VMX being disabled via NMI,
>+	 * VMCLEAR and VMXOFF may #UD, but the kernel will eat those faults due
>+	 * to virt_rebooting being set.
>+	 */
>+	if (!(__read_cr4() & X86_CR4_VMXE))
>+		return;
>+
>+	x86_virt_invoke_kvm_emergency_callback();
>+
>+	x86_vmx_cpu_vmxoff();
>+}
>+

<snip>

>+void x86_virt_put_cpu(int feat)
>+{
>+	if (WARN_ON_ONCE(!this_cpu_read(virtualization_nr_users)))
>+		return;
>+
>+	if (this_cpu_dec_return(virtualization_nr_users) && !virt_rebooting)
>+		return;

any reason to check virt_rebooting here?

It seems unnecessary because both the emergency reboot case and shutdown case
work fine without it, and keeping it might prevent us from discovering real
bugs, e.g., KVM or TDX failing to decrease the refcount.

>+
>+	if (x86_virt_is_vmx() && feat == X86_FEATURE_VMX)
>+		x86_vmx_put_cpu();
>+	else if (x86_virt_is_svm() && feat == X86_FEATURE_SVM)
>+		x86_svm_put_cpu();
>+	else
>+		WARN_ON_ONCE(1);
>+}
>+EXPORT_SYMBOL_GPL(x86_virt_put_cpu);

