Return-Path: <kvm+bounces-55087-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A00BB2D1F5
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 04:34:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9E8A01C438BC
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 02:33:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02D9D277CA1;
	Wed, 20 Aug 2025 02:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="avcv9kJO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEAD51DDC1B;
	Wed, 20 Aug 2025 02:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755657172; cv=fail; b=HG528QxkwdgUdPConZrwjwbHSt6bUOoWLRovQ1N3AP7p+3bG/yqpXMrm0ckMKXNbZP63i8A38qUkJjd0Ey9UWOFPv6nDlKVtleM3EELfJ6UbA0En6EGUtv4k9In+gH9EYVhqlxAxj8YHZCRKBwh7fMAeGkkYvLsRuae7T4dgZyQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755657172; c=relaxed/simple;
	bh=rL6KV/S0cQnSNDQvwSMXvRzj/BxySFyyB/g0Hs8stBA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=UL9fXLaHSr8kZcTKOyxpPlu5j42h2ZmHy0BdCyJYBSIuqnmNxNKvHgUH+QnFlyTG5vMj6mdcY81stBXH1xhgYz1/ta2rNHsL+u8bCLilnDKrn+a5sJiZSuS6z7vM2kV0MZm8BPLAooVIMgWbPJU9zk742/8cax2jWt4iNrJGkCc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=avcv9kJO; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755657171; x=1787193171;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=rL6KV/S0cQnSNDQvwSMXvRzj/BxySFyyB/g0Hs8stBA=;
  b=avcv9kJOwMwH3Hu8yQ7cfz8je+Ff3Poes8UxdZSDkgNN95D3Df55YcX7
   T75U5SHcGCAKK5k+XJjqqCzwT5sKUBhwePVyByUFT5nPaQn2Zba38cAVu
   f/13tWkkgMluARW6lWAdAKxFIhX0WSVUPVDitFouX2Y0TgAcLih9ohrOr
   h/bKc+jUN9YGV2WSPFwG6ksDeaMVJ84RB0rzcWKeTXKHg5Wq933VSWR8Q
   CGd1bFi+6uB4bd/4LgYHyC+26vHzTbHWHrklpzHiDL0XQhg5bT9S1x86K
   TRlqeQzqvU1Vo4F1il2AnB4IGKEpXPqhutAZ2CPMYpFwvS0H8rIcbO2dP
   g==;
X-CSE-ConnectionGUID: XQJZfilZRNi7cxe0oJYnNw==
X-CSE-MsgGUID: ZqFTSNn8RqCllQPgtdNlug==
X-IronPort-AV: E=McAfee;i="6800,10657,11527"; a="57983999"
X-IronPort-AV: E=Sophos;i="6.17,302,1747724400"; 
   d="scan'208";a="57983999"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2025 19:32:49 -0700
X-CSE-ConnectionGUID: NimNGf3SQ+GcSA+/Y6w6Pg==
X-CSE-MsgGUID: 6yYyplqeSZmYGC7H1ju4WQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,302,1747724400"; 
   d="scan'208";a="205165613"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2025 19:32:45 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 19 Aug 2025 19:32:43 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 19 Aug 2025 19:32:43 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.48)
 by edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 19 Aug 2025 19:32:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vmYHYwoxHWRkzDEUg4iRQi/+7YgbKU5iqT3/3VBsih4Md7Jk7T6wnMHJe/8qLNLdiqriHBIXIM63fvOMy4tf1JxxgtMdxck/iI6r5w0WfZx6z2vrvvsUe6z7P3dyjyKBPw1VhnoBc9MtQ/2bmY1JLuIOrzEw6QieK8dfy3CniYUhdGNDiB5wzKLHbk0SLuJgXzBgDUKJWazqzm2Ai9ZvbRWAwmvgud7iKRriDc6JjQhpTDZp2SyrKo8FwmKFlLOB+3wEjP2TR53UMLX635XuoqDiqFgKU1u+pjPAiv+EfGwVRHj0tFxmJdMG251y14oZvpTMdRj5QOQQ/IB23EuSgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bBASJkUm/bxnkgxZhXM0xw/Ucn4R/jBxC3Hg5TWxx/M=;
 b=BTCaISXGMkTLYpM4eTadFOkECy0SIyASgDtukR6pNuJuBETCT3oUQr7AVJ84Wr5kKQU2oNhfSd8mAaNR1YcBV00Nf6jGR32DwWFtm7lOMms/6XW/WtrVsXXszWTJCLFt938AF6cErfbD5ZSmFkwwijCFCskEaTEPm+jI68c85Ts4qrB272xi6nmnDd0kcLzpI1YryKk6e6GW4clltmPLgklwz4qoWtccQmnemw/AW9TddtFKc1d1M3p89x6vsMZLP5rFIaFjqIKFDcRk0csqguq//hfhmpP8nDwZRCaN7WLLp1j+fDPCtjjQSDGgbWeSP7oQcV40ru03pDl/wj2TtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by CH3PR11MB8444.namprd11.prod.outlook.com (2603:10b6:610:1ba::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.25; Wed, 20 Aug
 2025 02:32:41 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.9031.024; Wed, 20 Aug 2025
 02:32:41 +0000
Date: Wed, 20 Aug 2025 10:32:30 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<mlevitsk@redhat.com>, <rick.p.edgecombe@intel.com>,
	<weijiang.yang@intel.com>, <xin@zytor.com>, Mathias Krause
	<minipli@grsecurity.net>, John Allen <john.allen@amd.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar
	<mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, "H. Peter Anvin"
	<hpa@zytor.com>
Subject: Re: [PATCH v12 15/24] KVM: VMX: Emulate read and write to CET MSRs
Message-ID: <aKUzvnUHMUSC/A8/@intel.com>
References: <20250812025606.74625-1-chao.gao@intel.com>
 <20250812025606.74625-16-chao.gao@intel.com>
 <aKShs0btGwLtYlVc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aKShs0btGwLtYlVc@google.com>
X-ClientProxiedBy: SG2PR06CA0239.apcprd06.prod.outlook.com
 (2603:1096:4:ac::23) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|CH3PR11MB8444:EE_
X-MS-Office365-Filtering-Correlation-Id: 578c3339-16ca-4c17-1f69-08dddf91d610
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?vYe1qBTzYNZXFUPEKmOFHGBBdFDcmuDhVi2Sd2hzIKKe+sm2/f72ud6qqF0Y?=
 =?us-ascii?Q?ph4Igt8NBT/e9rKPd6VldVXb6XaljZJfHN7LJfxFEQfADZyWG04HLOMjvyI+?=
 =?us-ascii?Q?PAQDc0xAQBlyiIsXfx0wi5p2OyaNlpJJTiNUBb3T0hYzq7MZC2f4NzLRFhHp?=
 =?us-ascii?Q?1h8+cn1LcCPClxKmqf/QZ7/L8dO5coKE2fOV949WaB+ihWqqb2xMhoJ6Uc/o?=
 =?us-ascii?Q?7O/8McZjmYLq7f6aNWjAM4jHIZbf+25ZUGvR58zles/Y8AWeJAf+jTa2LnPY?=
 =?us-ascii?Q?TdJ9ksmtIDMVQIavFB5hGVyc6ZrSYt9dP4btkJ6YtrJIPp5UhBNG/MePqttP?=
 =?us-ascii?Q?wdzD8ICVfR6cmD+sLVvtgmGUHNEMH8IN5JVBwZZHdDnpHD/T8Vh0u7nAUgZQ?=
 =?us-ascii?Q?RZ5mAvSMbSC/dXCmAnrxYtNSNxX5u55gtDwyJ2bWep08RPBXLiyVwHwEP+pn?=
 =?us-ascii?Q?hrZWU5DTDAQxAxQD7t5vguH49WmGj+I+1/oqMy+bbUcVCzPQkEHVLWqcSgg4?=
 =?us-ascii?Q?4pnnzcDPllwewFfCRdGfPwH+FgBCqjvTgve8jk7izfhXH32FYKKqSJwfZ+Vc?=
 =?us-ascii?Q?kW/dQdnjhGUa8vgflbsTReLsT4/DpwiLtpXGD7dbZ8k8A2u1E75t+Iy1REEy?=
 =?us-ascii?Q?GETWwu5zjT7X9MTRoPZa/HvA+RjfXD/nRIb6Y8gi25gNv/MdGCnb/4YWbXd8?=
 =?us-ascii?Q?sn+FNYk9/6qgQ2SikF4b51avgk42kxyDsqO3u4dvrbV+YXTQxWKPdGZpgRg1?=
 =?us-ascii?Q?nY1iKL/0c20h/ZPXuNQbkpC02Tk77uenJSW3Xbss1loLwVNPQqAKCqagYEuY?=
 =?us-ascii?Q?12u+FYV9y0FDqFzao1+NbtZqB9qcidXWba8VlUtjRMfLamHfbjctPsnlFkWq?=
 =?us-ascii?Q?dAqkq7I+GuXOsDdAvWaR48c7vS3O4DFjMSoKqroNkvtpLdINIsZKfkR6eVCt?=
 =?us-ascii?Q?oRnufZ3HqvUHBFoQ567eSgyqW+1Ng19bMvMO5RCFbBc0YYiSR4NhEAmDhKpy?=
 =?us-ascii?Q?QK6t8jKRolpIfqNNZ7ZU7SrbWgm4wW9l5veMvFMthL2m5VaQdIyUy4c7ZKRn?=
 =?us-ascii?Q?megR9cLCjz58OrpzZq7lrPQFDa85mjz6dF7JTHCQZHC6zxnBWYUYzZ5Mmbi2?=
 =?us-ascii?Q?IeY8lAyBjfizam1QDkuByK+A6ZGSw4GiURm2SpSGqd3bTYrB9+0Nm2uDdat7?=
 =?us-ascii?Q?BL4WSpa8KmdbDz05lwDbGFZg0KFr53GdV0HbtP/HdCIjxolpdwB6uEnsP9v/?=
 =?us-ascii?Q?eMuoulleDYgbFVRWreSfz6dw8K8KcbuvhQgGkS/xBMW4lN10DrVvXPe1GW01?=
 =?us-ascii?Q?mPwi1LCQEe6b/5fy/Q1c9DRIBguDtF51lJZOy0BsvXht3tCOoKM7Zag2CPYT?=
 =?us-ascii?Q?pP1rvy+jEBaEahRM7FubcwMRxr26KeKzTzFvS1n/4p8bfvUvIYmH0N5bcbxf?=
 =?us-ascii?Q?VIYVHJAee50=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ywPUwxlnBS+O3j6f6JasWPiaD0mFP7TbRK7tWty0fh21qdMZbYMLfCLW2aJC?=
 =?us-ascii?Q?We6aNCeB4VOFw/fg3bypH2kUXyXGJFJwHBj/ZTExaw81cybe0OY21XA4Gcyq?=
 =?us-ascii?Q?I/qWtNsZx7GWA9QY9GjA7h1/cAjY4Nm5uaSYgEOBGSCDnngQrABwB3aVOZ0T?=
 =?us-ascii?Q?XgP+NwZT1Xm7lyo+DKGBEl1xPffgZ90v0UG1oh1yh0+vjztRCmfNBVK1iRrJ?=
 =?us-ascii?Q?rjftE8wQcQ1Dvbwe+rRqrEc4c4p6Vw47vNA3EvscxnEiicBnJHiHarU7SYib?=
 =?us-ascii?Q?1RJ5NpuRLU+VNTvam7H423AfvjORKr/euQwFz1SD2jIJeXgmfSD251l/g/Ld?=
 =?us-ascii?Q?+RzaERlpuNBaASS9ITB64Hlj01F4Pgqgycl9AS8ngnrVgOzCUBs4KYny2jqU?=
 =?us-ascii?Q?dqlBgYh8ZwucdvMnzwCkTbvZWZjO1phDtbR1xrPcfq4orGWmZUKJbjjBPylT?=
 =?us-ascii?Q?WrrWoYS3OU2APSOkwzQBEMO4JR7lv7zoLLwRP+bN3X5zkltvxHcZup+qaZ3N?=
 =?us-ascii?Q?omzc/z4Z0OOAbu+92dTa1usuux0eZajoQsH/Zt42gfceRMtlxXV77jAmZgUF?=
 =?us-ascii?Q?+apLgaclnfXju0WtIzSGmCbvPdtgVKCoHllfjT+4UGKVYtBeAc25wcVf0T1u?=
 =?us-ascii?Q?5oh10NqRZLlSL4HVCF2dMXqKzgjORN4N6NyNDs6gbVbML+nM5uMy5Qoi4ja1?=
 =?us-ascii?Q?JX08K93ka4O2VOD8n5vy2wOMwA/ZOgai6hJj7B23zhNaiFZMXQBUV9pIVZmc?=
 =?us-ascii?Q?Ttb1cdT4QwBB+Wv4dAcpFtPCv73P6Yw4JyyojC237ZRaQynpM87+8HzZC2Jh?=
 =?us-ascii?Q?qGBRh2fnqrZuk5pIMnbAMTVDPP6xkNrOIyTOqcWAeA3I4UgieOOLPxYfO71S?=
 =?us-ascii?Q?UsgUMkuhDElNSC+GH6EfRSiOhXF7kUTINm2nP6g+GhyMrgx8YioYNNocT/9x?=
 =?us-ascii?Q?IeccLgDIesl7pQpFDkapHweDaOf1wHO7cfTMcA191R1cCnPa/bBV8666rEbU?=
 =?us-ascii?Q?7qSxU5RlHY5y5dlckhdt5jizNcRYySw3zCvKmHowmhAMi9jFkpQ2YIWhiO6z?=
 =?us-ascii?Q?V1/QPbCaKoCCmCE9o16bw6WkO7hfZqxY+q2emGnvbpfrBjXsWPOM7wOR/U4j?=
 =?us-ascii?Q?sCY927o3slWTbsxhjGQmQX9eQI0d7leLbq5afwYu1IaO2f5czvRKjUc3PZL+?=
 =?us-ascii?Q?8iKM6g8UCGQA2hpxgV5S0WLpCpSQPn4oj9bIscMTnCkQM7GYLyRlfq6ulTXL?=
 =?us-ascii?Q?EXJSODVgzxtvJ0a7zkHj/m1jpaoagSkLZF+4P81ehdpdZzNEEbbsNhf6IFaj?=
 =?us-ascii?Q?RdSybpGU+YWx7SXeoVgR7LPt+Ck09F9Zqa1kxo+RTU3pTFIGKCHTd00hBb6j?=
 =?us-ascii?Q?8iRauseufeCsGW6WsnMblJT3rH8zznm7K8v68m/EA9jc2CjEDlQbSOfn9l72?=
 =?us-ascii?Q?q0ulC/QjV/CpFsmlxexK3/VmUa8cZeQTFPWcRFBwRSGkj0UcBLHiZ4mcXeOq?=
 =?us-ascii?Q?UqQmEC427UeZT3n6Xgexo/Z9S2k06rDDNHFV4XrT3p75AuP7atGUfMRh5f0K?=
 =?us-ascii?Q?KlcOVSEE70n2DEBMcyYgAOyPJBeVJ4YPQ1rMF6ZH?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 578c3339-16ca-4c17-1f69-08dddf91d610
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2025 02:32:41.2900
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M/1i32ldlj79+x9BCVC9nK3R05Wys/vZNNI3gHiHkhXnItaQ8NU/MHj5qwhkW78G7CHXB9/pfKfAqL7pKtTy6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8444
X-OriginatorOrg: intel.com

>> +	case MSR_IA32_PL0_SSP ... MSR_IA32_INT_SSP_TAB:
>> +		if (!guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK))
>> +			return KVM_MSR_RET_UNSUPPORTED;
>> +		if (is_noncanonical_msr_address(data, vcpu))
>
>This emulation is wrong (in no small part because the architecture sucks).  From
>the SDM:
>
>  If the processor does not support Intel 64 architecture, these fields have only
>  32 bits; bits 63:32 of the MSRs are reserved.
>
>  On processors that support Intel 64 architecture this value cannot represent a
>  non-canonical address.
>
>  In protected mode, only 31:0 are loaded.
>
>That means KVM needs to drop bits 63:32 if the vCPU doesn't have LM or if the vCPU
>isn't in 64-bit mode.  The last one is especially frustrating, because software
>can still get a 64-bit value into the MSRs while running in protected, e.g. by
>switching to 64-bit mode, doing WRMSRs, then switching back to 32-bit mode.
>
>But, there's probably no point in actually trying to correctly emulate/virtualize
>the Protected Mode behavior, because the MSRs can be written via XRSTOR, and to
>close that hole KVM would need to trap-and-emulate XRSTOR.  No thanks.

I don't get why we need to trap-and-emulate XRSTOR. if XRSTOR instruction in
protection mode can change higher 32 bits of CET MSRs, it is the hardware
behavior. why KVM needs to clear the higher 32 bits?

>
>Unless someone has a better idea, I'm inclined to take an erratum for this, i.e.
>just sweep it under the rug.
>
>> +			return 1;
>> +		/* All SSP MSRs except MSR_IA32_INT_SSP_TAB must be 4-byte aligned */
>> +		if (index != MSR_IA32_INT_SSP_TAB && !IS_ALIGNED(data, 4))
>> +			return 1;
>> +		break;
>>  	}
>>  
>>  	msr.data = data;
>
>...
>
>> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
>> index f8fbd33db067..d5b039addd11 100644
>> --- a/arch/x86/kvm/x86.h
>> +++ b/arch/x86/kvm/x86.h
>> @@ -733,4 +733,27 @@ static inline void kvm_set_xstate_msr(struct kvm_vcpu *vcpu,
>>  	kvm_fpu_put();
>>  }
>>  
>> +#define CET_US_RESERVED_BITS		GENMASK(9, 6)
>> +#define CET_US_SHSTK_MASK_BITS		GENMASK(1, 0)
>> +#define CET_US_IBT_MASK_BITS		(GENMASK_ULL(5, 2) | GENMASK_ULL(63, 10))
>> +#define CET_US_LEGACY_BITMAP_BASE(data)	((data) >> 12)
>> +
>> +static inline bool is_cet_msr_valid(struct kvm_vcpu *vcpu, u64 data)
>
>This name is misleading, e.g. it reads "is this CET MSR valid", whereas the helper
>is checking "is this value for U_CET or S_CET valid".  Maybe kvm_is_valid_u_s_cet()?

Will do.

