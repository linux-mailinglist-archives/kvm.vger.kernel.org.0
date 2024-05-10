Return-Path: <kvm+bounces-17151-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B7D688C1F64
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 10:04:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6E6252832E2
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 08:04:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC15515F3F4;
	Fri, 10 May 2024 08:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JUxeZ2z7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59F8315F3E0;
	Fri, 10 May 2024 08:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715328241; cv=fail; b=JfEEY/CQ7AAwZMmY+9NoI1RCEvfdIRLXCsmMm37mUJRrOD2zebyuBV1AFGprjW/Nzt+m08QdSAgVZll/ScrPOkqlZDF7RMKHxPNeUhVshODRBrz6Ac0OINoI7ja1/IN7b8iLCMJDS137NovR7lXSwop6wbiRVIFTEqBtU8KW4vo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715328241; c=relaxed/simple;
	bh=D07La9l7sDdG7Ppos5x7xzQfWoK9h4Biid4q8BA3ak0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=i3NTJ/5cRncfNmznqA/nv/dngcHC7sLaLpB8M2Dp5BKbLmN9cTnqs7hJMXdXKXeF2w2/7jrddBQdI2so68Rcxm8tM2Dpl2v7AAxi54bnpyfxIx3pphVh4wuyEW3gTdC7wDqeaCC2luJDdnq1F318aBlbNuRWs6Hx2tJsohFPjwA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JUxeZ2z7; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715328239; x=1746864239;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=D07La9l7sDdG7Ppos5x7xzQfWoK9h4Biid4q8BA3ak0=;
  b=JUxeZ2z7g4aS95oN0m6l2u86I3maqtGaPp93MNyQXpUFpkzSvx/8WH21
   L8l0CJUVDYDdB3SgTZK/rsqv57/tnWYRb1Koelvhu+jT95qJ70cy70GoH
   ahyLEe+tCUdAa4k4AGr56YaneS/w8rYE11HGJ8fsZ5iqrR6JJJJITcWzv
   1Xp4cnTsL3bTaxaPq2AI+3+y7B4/UXmxDkOEzSgrTW+eQU5WLMUfBCJB3
   YuDgBxKmcIZYxy0rOzKH0ABHDwJ9HZ1Om2D3gWdipiCkBX26tOY+mvFKK
   hAv6UgXMw8c5/AlsKa1Mfwt06f0Bpku5Ha1UiEPB8wR/QCcPkGtJOHnse
   Q==;
X-CSE-ConnectionGUID: Nhfdv0suQQGXOqWRTBdJ1g==
X-CSE-MsgGUID: lKdElvRuTqWWhVrFYtAC6Q==
X-IronPort-AV: E=McAfee;i="6600,9927,11068"; a="11461935"
X-IronPort-AV: E=Sophos;i="6.08,150,1712646000"; 
   d="scan'208";a="11461935"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2024 01:03:58 -0700
X-CSE-ConnectionGUID: sDkMusBHRd2FwN05ND109A==
X-CSE-MsgGUID: R2QZgzagQfCmyQkBybYIbA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,150,1712646000"; 
   d="scan'208";a="34188870"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 10 May 2024 01:03:58 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 10 May 2024 01:03:57 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 10 May 2024 01:03:56 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 10 May 2024 01:03:56 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.40) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 10 May 2024 01:03:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l6iPTHcCFHzU3lM72cd8OJMv4eIN0X/VO3PhhWROMYQ9Cys2QsEma72h944U8v6K8VBsPQRJn2cH9db85yC6ss4DkGZJhEWrNvrYNfgBRy+ldQdgHTtFtSztF+jvPvRQZuwgpgPUrWQRX3tTSjDGRc7Cg5jWBEcgqwh0iBPs5J3eOTfBzs3KKOYz4X0KTu3iKGgCgrmz5cKmRFZCJOJbWoKG2ihJPSaYFXXWwp3jhlnk7CQU9aKgXB5VUJbRPumJjiHwpc+R0aAJKaGgMgfCjAHOXqMerBgAlLdW/PP4JI4REg2b1iU9An9orSpZSYr1VpyZiUdOsWNFsi36T+wZ9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n82XZxOIdT89axmY87fX3fE56CZ8dJvb9YKOryOKIU8=;
 b=Qs0XUMmZ7EKxezv/cQJHPG51dO/nKzq29hLz7FSL1dz+113LuqIbgETSvmW73YN/rddVi/XI7Q75GnGr0XEvxsec9VvNzRCsv+1SY6paJX7DlER75dQ80id9hpJNAqhUjxIBUJn1yMMlEHAlDSqeErKDnoC8e7WjdfqDT3D3sSBdz24yy/ZqEYhfMxNJsonEG5WL2JqBN5joZKEtfV9pEm4vFXRX5Pmx5WSzOdJZPgfOjq7/PCdWu8fqiHe+nQFvtE/ytqYusYj19H0RLkqszfw55RngmuHJ6CpFwLxZF7QuVu9E+zqngSzmTPd0/GxNbvfpvSIGhEFs5JTCVafTTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CH0PR11MB8167.namprd11.prod.outlook.com (2603:10b6:610:192::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7544.47; Fri, 10 May 2024 08:03:51 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.7544.047; Fri, 10 May 2024
 08:03:51 +0000
Date: Fri, 10 May 2024 16:03:04 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<alex.williamson@redhat.com>, <kevin.tian@intel.com>,
	<iommu@lists.linux.dev>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<dave.hansen@linux.intel.com>, <luto@kernel.org>, <peterz@infradead.org>,
	<tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>, <hpa@zytor.com>,
	<corbet@lwn.net>, <joro@8bytes.org>, <will@kernel.org>,
	<robin.murphy@arm.com>, <baolu.lu@linux.intel.com>, <yi.l.liu@intel.com>
Subject: Re: [PATCH 5/5] iommufd: Flush CPU caches on DMA pages in
 non-coherent domains
Message-ID: <Zj3UuHQe4XgdDmDs@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240507061802.20184-1-yan.y.zhao@intel.com>
 <20240507062212.20535-1-yan.y.zhao@intel.com>
 <20240509141332.GP4650@nvidia.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240509141332.GP4650@nvidia.com>
X-ClientProxiedBy: SI2PR04CA0009.apcprd04.prod.outlook.com
 (2603:1096:4:197::8) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CH0PR11MB8167:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ecbc227-62c4-47fe-522a-08dc70c7bac5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|7416005|376005|366007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?oeBUJD1DHvLpT37IqkzYx/vFAyUcTkb7N1xVueDKUZhFnF9ZHIkaRPDlTjnH?=
 =?us-ascii?Q?V9ulyVrxY+Ux+onTMSW1KqburvYMCG+XDmPxhzr/uzYmaicnUzGeQ7JcnOgv?=
 =?us-ascii?Q?Sl+cDonN2mON+8xLSbU9chpbhtluJQ/mdKtyLFSu6QdIrNIUcxxIL/LAxUv9?=
 =?us-ascii?Q?kOk7OQXF6Qpk5zg29i2Ubod5ZwfbdqZzXXI+OgvZ3Pt4Ry1VhxlF5UMJTdy5?=
 =?us-ascii?Q?7j4Ce+4evfkcKgvbtJftSit9hTatNYnxBuCgLBLAV6SRQjm28xAEw2lmkSnR?=
 =?us-ascii?Q?RCP6UWmW+onpfriHuWUyI1xCKjkzaPLPFM+ymLbeAPQiEXmD0UXE4MnL/d93?=
 =?us-ascii?Q?tUcRWFkhkmInhvSFAEBvPX8NqwHtw7ADJwpWZsDtu33cDUfhy3Hns/9lxRDN?=
 =?us-ascii?Q?ci3GtAe7teXKd9Dx1ik7moPxA2aLkMhBnkYOdmKh4HGLI4zNFnRy8RWQn0/p?=
 =?us-ascii?Q?dNx3qe5kPpP5bWjsvA/eQmxvP/ZkTgcTDORhj3hDB8Ekr8jzDLTfOA+XfaMi?=
 =?us-ascii?Q?H/Bso45wkvGXkppApkkbMiwp19K6zYVhfRXM3u3Iq39nrOaTfuazNrM6GvgL?=
 =?us-ascii?Q?/9+x52JMGvBiH0UqUYF1EY+Hdr25Zr62vM4PVg7LD3mxmV1mtLP8YgxO65Yu?=
 =?us-ascii?Q?EZcHegfxVv32YqnVqIcAfd11RGbevtq4bcPW+0284rZUV9ZxbCMOQiqP7T4y?=
 =?us-ascii?Q?poAXkFBBmRmubFH8CMzeZa98ajFTxMNLZlhZjWFiAShc0iVnTAKOkmw+jQrU?=
 =?us-ascii?Q?VP1bRyO+43fRAZqMgg+/j/a/iJTY9JpiLxAPo+uZ5uVhX5QbtAXlGhNOPwT6?=
 =?us-ascii?Q?lPux0LC4hZWSP/n5yYKH9ZcepN7zxgEtqK6kagEor3Hc1mYQ8+KuBZA21DEr?=
 =?us-ascii?Q?ycJGQZyIj70eYBfzCQf3ufQ80ozaJSni5kchDXQvZNncz2mvSUZyZOrN7CGl?=
 =?us-ascii?Q?iSCeFndfYgXtpgdJS0kCSa8Aa7wtbpwVwo1L+aSdTKYnzNuiZyXb5IsOzv7Z?=
 =?us-ascii?Q?r1C+trnw/BIKDvBSLo8qCbKD1WI8uI43wM39IQtSkoO3HCE5QW/H+lKeQFLb?=
 =?us-ascii?Q?oV6Q99b0fJcbvKquURylO2IR6tUYuBDwb5DVD+tD4XBcH5Emm+CzAp3EiNou?=
 =?us-ascii?Q?7TQBqvQxqbZVH5sa5up/b7aL8oh+hAiUnoBIMbmP5xk+2fNRuZxnPpqtwvSb?=
 =?us-ascii?Q?fGS4KudrMuSN6I/y33nStcdDZbzANh+7s2ya46W6uBtPMYU9g47iWok8tkMK?=
 =?us-ascii?Q?IzUvT9sHk9XMmW1Xjk7MRAhOztWMhT1woyVtmG9Eqw=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(7416005)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AygMMnpbRUcfHvNuoWbGJak5FhQu95NcX75bqurEKq4e6qgb/lLgrCTyarDS?=
 =?us-ascii?Q?NwD9QfpDxKs3rhwuH1uJxY98HunMmLStzLc4NTAPjW4w602RGu5p14EQa4VF?=
 =?us-ascii?Q?qTZD2ZeeE4mW985HyBTx/Hv0SLVtVpiXRnWRM5gwsigo/RZen5dgQlgTabWS?=
 =?us-ascii?Q?4x/DCNYFGsz8ZD56twXNDpqJFmo0jmiqLMIscDvfou/CNslBr4KdXRg87wHi?=
 =?us-ascii?Q?TiSN0dH/OcEs4WsPW09d19HfwpdR29Xki6rbqmdDozLIQmQFb9lSA0qDyYeu?=
 =?us-ascii?Q?ia0OnqSygMpVgMvdVBTP4NCqJK+CLuGXCoCNwbXMXhc8PwEtNRiTjTRcMyXs?=
 =?us-ascii?Q?2ypUbUuOSIvzQmec7TaHEKSU9JXJTgDOU71husXg7qPKL9ylOeKRb31RGjDq?=
 =?us-ascii?Q?vG0ntyNuERS3fvpQeEPd0AKGzBA2HIvZ0ZXxvC9bOoAjQBJs8av+3MOhKp7K?=
 =?us-ascii?Q?Ef8CXuF4Jw8FGVpiTYMjMBAse1tJ+dET1d5/LpivLPcsvSroi78DPeMK5lqm?=
 =?us-ascii?Q?ZcMbCppUgofRF1DC0w/ZaYD2XnefBWRXS+9b8Utk8nZByTVQd1ELo/aHcDy+?=
 =?us-ascii?Q?t/09KcYpMwhK1OcVXBBWIyZV5V3C1eiByM9nLclYkVHldMSsTT1g47WDzKM1?=
 =?us-ascii?Q?aDRjFSEeJG7Lif8fWCYAye/C929LX+LuLB+FFn+AZwGF6CHT0gQb53siQ3Gp?=
 =?us-ascii?Q?YlaKI7CiLJHFEBkM2cvYaSgYWjBAyTZ87v16EipWnbTWY/UFph/lVlRjPNi2?=
 =?us-ascii?Q?Fg84VVo0dUNY0yqDEzAxxCUf+OsvjlbpKMO+YD+ffZgO0UBR4QJLHwv5Tk//?=
 =?us-ascii?Q?JWr973YPrRTlKZ7ldUtf6yiXqCHlAYlIEl8gkQi2GTpfKTlKf24jyVQmev7J?=
 =?us-ascii?Q?pruhU0KsevewiYzQGMyXa0Qy0+Coxdec9xpdTQLEWDuxRhLmMSR6YUkT5XtP?=
 =?us-ascii?Q?NlJQJjgkPBVgQuf1cg4C4L5K9c5rgLjgjOiwM3dwX5i/nqeDbITtdfQbxt7x?=
 =?us-ascii?Q?B+pZxgCDBRp0KDSq4t79ce3Ncy/fjVuQgto0Zc4RnuKjfnEl2zVrw6mWBurU?=
 =?us-ascii?Q?uSCRd5txmWzroKEl2odjNSp0GXpvfaKJWRNBs/im+/fRivmaDJao76l+l554?=
 =?us-ascii?Q?NQzUuoSWOvrHHIUEeI1Da/6ra8u5neir1X3PoHJWPBARbT8cUqkDbEKyFCVm?=
 =?us-ascii?Q?O5FKlUIQiEHWZ2vOY4PTf7hnp7Qe5kDa2XyS9z5tnV+6s4MDGIztaRVlW31z?=
 =?us-ascii?Q?v3buw7mooi4XmuzWyRijaFH2K6UOxre5w2/ya4RH5YUdYM9qk4L7i5OtiUJz?=
 =?us-ascii?Q?z9s1TE/1uL4+WZn2O7ZRGmxePRMKTcwn294+onDEgYDqX2BzR2Oza5ZUAE2f?=
 =?us-ascii?Q?Wg2sHUhXRKvShQ5jioLBwr6oxMjkjZ2vw+hSbFfyTv4mmu7Y30KSH40SRsos?=
 =?us-ascii?Q?4gbCF4yPzgUHoSitnVpJn7CMYl8G1bOuOiDzjxbKegO9z7WA5tT3m67lHZEn?=
 =?us-ascii?Q?u7qc5pqT5KkICBs2Y548aHdtV/PZT+HuSM6RG+uwlOn3Syf36rUB27NobAr7?=
 =?us-ascii?Q?J6/Zs6X7dlJ56kwmTDf9uyHj1E62CP7TgWhaEs70?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ecbc227-62c4-47fe-522a-08dc70c7bac5
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2024 08:03:51.5455
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1N7o0u+zhaTZxP+oNUfxBDs+0ARwkzoI9SF3H7wyhR/tHc0SFTozeY176LDfOpjEhL0oVyPN0elFbU5RByxJaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB8167
X-OriginatorOrg: intel.com

On Thu, May 09, 2024 at 11:13:32AM -0300, Jason Gunthorpe wrote:
> On Tue, May 07, 2024 at 02:22:12PM +0800, Yan Zhao wrote:
> > diff --git a/drivers/iommu/iommufd/hw_pagetable.c b/drivers/iommu/iommufd/hw_pagetable.c
> > index 33d142f8057d..e3099d732c5c 100644
> > --- a/drivers/iommu/iommufd/hw_pagetable.c
> > +++ b/drivers/iommu/iommufd/hw_pagetable.c
> > @@ -14,12 +14,18 @@ void iommufd_hwpt_paging_destroy(struct iommufd_object *obj)
> >  		container_of(obj, struct iommufd_hwpt_paging, common.obj);
> >  
> >  	if (!list_empty(&hwpt_paging->hwpt_item)) {
> > +		struct io_pagetable *iopt = &hwpt_paging->ioas->iopt;
> >  		mutex_lock(&hwpt_paging->ioas->mutex);
> >  		list_del(&hwpt_paging->hwpt_item);
> >  		mutex_unlock(&hwpt_paging->ioas->mutex);
> >  
> > -		iopt_table_remove_domain(&hwpt_paging->ioas->iopt,
> > -					 hwpt_paging->common.domain);
> > +		iopt_table_remove_domain(iopt, hwpt_paging->common.domain);
> > +
> > +		if (!hwpt_paging->enforce_cache_coherency) {
> > +			down_write(&iopt->domains_rwsem);
> > +			iopt->noncoherent_domain_cnt--;
> > +			up_write(&iopt->domains_rwsem);
> 
> I think it would be nicer to put this in iopt_table_remove_domain()
> since we already have the lock there anyhow. It would be OK to pass
> int he hwpt. Same remark for the incr side
Ok. Passed hwpt to the two funcions.

int iopt_table_add_domain(struct io_pagetable *iopt,
                          struct iommufd_hw_pagetable *hwpt);

void iopt_table_remove_domain(struct io_pagetable *iopt,
                              struct iommufd_hw_pagetable *hwpt);

> 
> > @@ -176,6 +182,12 @@ iommufd_hwpt_paging_alloc(struct iommufd_ctx *ictx, struct iommufd_ioas *ioas,
> >  			goto out_abort;
> >  	}
> >  
> > +	if (!hwpt_paging->enforce_cache_coherency) {
> > +		down_write(&ioas->iopt.domains_rwsem);
> > +		ioas->iopt.noncoherent_domain_cnt++;
> > +		up_write(&ioas->iopt.domains_rwsem);
> > +	}
> > +
> >  	rc = iopt_table_add_domain(&ioas->iopt, hwpt->domain);
> 
> iopt_table_add_domain also already gets the required locks too
Right.

> 
> >  	if (rc)
> >  		goto out_detach;
> > @@ -183,6 +195,9 @@ iommufd_hwpt_paging_alloc(struct iommufd_ctx *ictx, struct iommufd_ioas *ioas,
> >  	return hwpt_paging;
> >  
> >  out_detach:
> > +	down_write(&ioas->iopt.domains_rwsem);
> > +	ioas->iopt.noncoherent_domain_cnt--;
> > +	up_write(&ioas->iopt.domains_rwsem);
> 
> And then you don't need this error unwind
Yes :)

> > diff --git a/drivers/iommu/iommufd/io_pagetable.h b/drivers/iommu/iommufd/io_pagetable.h
> > index 0ec3509b7e33..557da8fb83d9 100644
> > --- a/drivers/iommu/iommufd/io_pagetable.h
> > +++ b/drivers/iommu/iommufd/io_pagetable.h
> > @@ -198,6 +198,11 @@ struct iopt_pages {
> >  	void __user *uptr;
> >  	bool writable:1;
> >  	u8 account_mode;
> > +	/*
> > +	 * CPU cache flush is required before mapping the pages to or after
> > +	 * unmapping it from a noncoherent domain
> > +	 */
> > +	bool cache_flush_required:1;
> 
> Move this up a line so it packs with the other bool bitfield.
Yes, thanks!

> >  static void batch_clear(struct pfn_batch *batch)
> >  {
> >  	batch->total_pfns = 0;
> > @@ -637,10 +648,18 @@ static void batch_unpin(struct pfn_batch *batch, struct iopt_pages *pages,
> >  	while (npages) {
> >  		size_t to_unpin = min_t(size_t, npages,
> >  					batch->npfns[cur] - first_page_off);
> > +		unsigned long pfn = batch->pfns[cur] + first_page_off;
> > +
> > +		/*
> > +		 * Lazily flushing CPU caches when a page is about to be
> > +		 * unpinned if the page was mapped into a noncoherent domain
> > +		 */
> > +		if (pages->cache_flush_required)
> > +			arch_clean_nonsnoop_dma(pfn << PAGE_SHIFT,
> > +						to_unpin << PAGE_SHIFT);
> >  
> >  		unpin_user_page_range_dirty_lock(
> > -			pfn_to_page(batch->pfns[cur] + first_page_off),
> > -			to_unpin, pages->writable);
> > +			pfn_to_page(pfn), to_unpin, pages->writable);
> >  		iopt_pages_sub_npinned(pages, to_unpin);
> >  		cur++;
> >  		first_page_off = 0;
> 
> Make sense
> 
> > @@ -1358,10 +1377,17 @@ int iopt_area_fill_domain(struct iopt_area *area, struct iommu_domain *domain)
> >  {
> >  	unsigned long done_end_index;
> >  	struct pfn_reader pfns;
> > +	bool cache_flush_required;
> >  	int rc;
> >  
> >  	lockdep_assert_held(&area->pages->mutex);
> >  
> > +	cache_flush_required = area->iopt->noncoherent_domain_cnt &&
> > +			       !area->pages->cache_flush_required;
> > +
> > +	if (cache_flush_required)
> > +		area->pages->cache_flush_required = true;
> > +
> >  	rc = pfn_reader_first(&pfns, area->pages, iopt_area_index(area),
> >  			      iopt_area_last_index(area));
> >  	if (rc)
> > @@ -1369,6 +1395,9 @@ int iopt_area_fill_domain(struct iopt_area *area, struct iommu_domain *domain)
> >  
> >  	while (!pfn_reader_done(&pfns)) {
> >  		done_end_index = pfns.batch_start_index;
> > +		if (cache_flush_required)
> > +			iopt_cache_flush_pfn_batch(&pfns.batch);
> > +
> 
> This is a bit unfortunate, it means we are going to flush for every
> domain, even though it is not required. I don't see any easy way out
> of that :(
Yes. Do you think it's possible to add an op get_cache_coherency_enforced
to iommu_domain_ops?

