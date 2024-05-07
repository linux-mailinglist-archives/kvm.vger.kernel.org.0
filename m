Return-Path: <kvm+bounces-16814-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 358C88BDDF4
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 11:20:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D91DC284B84
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 09:20:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7A0D14D704;
	Tue,  7 May 2024 09:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="G1sl8LpI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7792614D451;
	Tue,  7 May 2024 09:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715073602; cv=fail; b=CtGDiVJLttIBdzp4+xXGJoDnz/KSgAgvvNnsHWxCjN6Dn/flLFhq+Zv6kic7IRk7JGJ7tKssHU+W4MxATA3xozUy4bal9qf5G0Lco9wveUHHtOAbt2TOchd7893vALbsh3llN9Ab1TQzyFoV9mH7FKFE8ZpEzPzc0CZepgA0sT4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715073602; c=relaxed/simple;
	bh=FOlCUV2jYmcqalqEaRi4wLFPFpgYizC/N4/Mo67bDws=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=tT5nRwXWeS3stfYXEJZjClt0WhUEBG58rtgSGNkJpKbV2d3QcbI0D4isbQA+3wzl4Ej5sz6VtlK+U4K3op/8yQ/tLY8Zmd/pLajp4uRrFwSianNnnPGKqudR+3us8kaDrznf6O7fB1gLxYZ3l2r8EZE3ESHCRD78RU2bhBGE3a4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=G1sl8LpI; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715073602; x=1746609602;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=FOlCUV2jYmcqalqEaRi4wLFPFpgYizC/N4/Mo67bDws=;
  b=G1sl8LpI3PsqcgJwl2Z5+YaB3fcCXDzYY2GnTmBZ0uv14QkalMgtRFBH
   vxi4JcK/MN18CtnmXBKCNd3/s2JiIHOPBjg0Cb0PfRWsKG0le3kPVXV0P
   hJ8DAazDCaokJ8NCtebFYPkI0BLMseQw9hgiv3ErORHgBaj4L5mcD8ehU
   x05LWc7YU3mAV4U0FeSefhkM9cxjoDsA+PMbvJq3YGJf3LoXgSUldV9UT
   30ym51EC2SpbsDfj39B6I+RSVV8Na5TmyxXVywg7URcfVi/DiYMP0bWJh
   gKNDaRNri2FsVIkwuz+1ChcSN0AXpzoNqUF7Y8mDcoucCESt7xITh1MUn
   w==;
X-CSE-ConnectionGUID: w6OltdiRTSeqJ97v2YCXRw==
X-CSE-MsgGUID: NF2Z1be1Shy7wtNhPcwE8w==
X-IronPort-AV: E=McAfee;i="6600,9927,11065"; a="10707427"
X-IronPort-AV: E=Sophos;i="6.07,260,1708416000"; 
   d="scan'208";a="10707427"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2024 02:20:01 -0700
X-CSE-ConnectionGUID: L1FGuCU+RXGXTpSH2zXVOg==
X-CSE-MsgGUID: ANDUgogYTxyvZ/r8rsuruw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,260,1708416000"; 
   d="scan'208";a="51652363"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 May 2024 02:19:59 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 7 May 2024 02:19:59 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 7 May 2024 02:19:59 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 7 May 2024 02:19:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G8MnJ/RsXw32BMcOyhk4Pb5F4w/YrD+p9zJTwVMZS3IodN1YWAXDZZEQAOjvCOx6PBcEv4JGGFc76Ek4bCSpLbq6Ev9Gz54oPpco43uzZ3zNlSnhUq5uG/Bea3ElZWTwtOHQthn1C/3WxvdrEZihkIQ6WWqg5yx1C4qpT0s/b82M2nBYNSOY1TXfB4lfuL1WvfGHFCsB9qYG/yHDA97M/mg9WbsUcSYpPJE7z3u9S5ipFSmErh6Ns+Hg4D225YAfN0IqMm6Avju/ZcpQ/OkglGvaOKPyS+u5Qg22Sq6APahiluNoUmUMPzeffjp/XGiDBVaf+6iXRtfKEZe45GnFcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jheKF3vLfyz9ZqStkXHY2IejqCWulkDpFfsm4sCTnt4=;
 b=n7eAnvZLVLoTZeLFq5X+fpidBeJjI3trnv/9O6iUBM5+qPNJ1qShHu2aCYdXMC1OteUW28MK10wM5prM+AzG1go3565JRMQhLB3UrXBWkEVoZEWbrf2ApL3iSnJX2kP6zGNrTI/T/RFFUPCSO92qw/KT7K3UJdLaYPj/IHq/vWW6gkE5miFr37eSifhiEfGFAcJM4LYWNHgh/eAiRQ0AfQcEJ6cYuuPuydzdqfXdjhRhuUgtB8yEDahFRScBnT926nkvaWtkPJGtLljtyjQzqe5bqQZ6Oez6aZ8j5sTAMv0td98WfuI+4xc0I68h8ogSbLs468FppyYzTnkVda1TOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SJ0PR11MB6621.namprd11.prod.outlook.com (2603:10b6:a03:477::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7544.42; Tue, 7 May 2024 09:19:57 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.7544.041; Tue, 7 May 2024
 09:19:56 +0000
Date: Tue, 7 May 2024 17:19:13 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"x86@kernel.org" <x86@kernel.org>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "jgg@nvidia.com" <jgg@nvidia.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"luto@kernel.org" <luto@kernel.org>, "peterz@infradead.org"
	<peterz@infradead.org>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
	"hpa@zytor.com" <hpa@zytor.com>, "corbet@lwn.net" <corbet@lwn.net>,
	"joro@8bytes.org" <joro@8bytes.org>, "will@kernel.org" <will@kernel.org>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>, "Liu, Yi L" <yi.l.liu@intel.com>
Subject: Re: [PATCH 2/5] KVM: x86/mmu: Fine-grained check of whether a
 invalid & RAM PFN is MMIO
Message-ID: <ZjnyEQilJRK97HVB@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240507061802.20184-1-yan.y.zhao@intel.com>
 <20240507062009.20336-1-yan.y.zhao@intel.com>
 <BN9PR11MB5276CABD8B3E1772932E2E3D8CE42@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276CABD8B3E1772932E2E3D8CE42@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: SG2PR02CA0096.apcprd02.prod.outlook.com
 (2603:1096:4:90::36) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SJ0PR11MB6621:EE_
X-MS-Office365-Filtering-Correlation-Id: 116a3426-f550-4112-a636-08dc6e76dcb8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|366007|7416005|1800799015;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?C+GIS13SuqSQE3z0xynK/r2Re3jUKFZOt11Pw5y7sXvebsjwz/6Pf3+LwwGg?=
 =?us-ascii?Q?FYEtkF8GoslOVZa/OuX+4xL/rYPR7XZxOk1ZoM8kwv171e7Z9vYL2+WrjUjc?=
 =?us-ascii?Q?y6P3NCvrz6m5/u66cuqyQZkLebSmjo3WJdilAqzSziVhSEMkqaUNpESPmPG4?=
 =?us-ascii?Q?Uuh6yPHewjXpc191/jgcfcKAw9qnQ6rFrw/qbACltLfPXt1+J8E87Cw0IoHK?=
 =?us-ascii?Q?NuZTH43oLPsAOPJeMkSda+AW/r5o3McqQOyQe5tTkZ30Z2Af8fLEG/8xoZUK?=
 =?us-ascii?Q?n5fChKPGliY+ONnuAktxhZsctOBXWYkRtiX0B/RGT+LsQ+eJDOfijWB8clml?=
 =?us-ascii?Q?y7CCIQalbgPlq6GNIKl6adBZEXsEAY62M0MPMxi3ln/m/vBXsHMWNjsZD6js?=
 =?us-ascii?Q?okufgeTg9YrXUT2RcxVLGgn7Ab2ITIByuWJMnPtnjxkz5LcG/8mwvdXov3Qq?=
 =?us-ascii?Q?DX0g9WQf0DU+pQHaBc/caYJafl41ligYCTpwkW8Vm/w8lSGOgm4y38spwJck?=
 =?us-ascii?Q?BpWZ71AaeqJ7T4CxQJ6UDevmpqybqLkyweG1yHP79Z8qcEn5gK/rpFJgUVAx?=
 =?us-ascii?Q?e8UQ+DgkOgbUSy/v5dX8NsJAFfN+4CBxuuJVriEh7j+FR7zprVjHhx7XabI1?=
 =?us-ascii?Q?h6H0nuLTcx+xDnQHHeu3r7rwyWGKktMpkHiVQXrjqFYTe0ADjJD8lXyBWC7l?=
 =?us-ascii?Q?KtaSx6huWNA7Ko25GYHYsXnGfbAiqh0SgLe+F8ZzscMhiJwbWSNO8jeRcUxE?=
 =?us-ascii?Q?Ly0vPxJOEHv8Nd0KhW5nZPQv6zXXc3PClJ1abgz+PESNC6Sy70WuMkI/A+ql?=
 =?us-ascii?Q?y+RuZe+nA743HLWevSX0SzRynvLkFYK500EbU4gNBTCovI+4Da7ecYsLPXYK?=
 =?us-ascii?Q?QxdsIaZFZzmWInBS5Ra/q0R8AtMR7yA/5+zVImhjriAnsFsoSBQNiKflAOz7?=
 =?us-ascii?Q?jEcGQamNQ9/nSjHNf7vBgYM66tZtSuirTmOivM3mrOUvlSv9twWxAr1ZKvrZ?=
 =?us-ascii?Q?VrrvNNEcQ4F5K4bdrSIFNyAZr0KLCm05bSO+C3n5VFzgbyQado8sJd3DQeUh?=
 =?us-ascii?Q?LRqH2+wj4JklJtV/KtSIl+2lLj/eGJYNqgqU9UCJ8pZ8XjCWIuAg9ZH6owfU?=
 =?us-ascii?Q?/L7mO5GusRqhEyJbmiUmBFsV9tMLbl/sdNqxXu1qVMmy4eI30kmL9tdaOiQN?=
 =?us-ascii?Q?FBpb8Xed9FoUkl4SCKU2O7hDRtHEobr9zM5xIhtgGyg3FOdtKw8807gv5uVd?=
 =?us-ascii?Q?5ufWjumJzGcHUXHf7U+aY5+3ZEtRnmJ4ZOYGVx0wRg=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(7416005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LLMC3193d86KizPTAkLXBjYVbxoZfMpb9c4DFNlx3wrEDLQQsYIJVbnNZ0sk?=
 =?us-ascii?Q?8FR2sbmHUnGlSdCjs93mhqrVS9I9grDhgtgPEtuPCxgMiHt5CnzErHO9F1l/?=
 =?us-ascii?Q?wIHBm39qtrYhvWQFaBndEWEYDzZ83ilhDJq5kdp7/JxsCUaclwVYJ0/BOOJy?=
 =?us-ascii?Q?6qOp8bb6D5OX6Xmy6ZA9sghNYpyjI67A0UbwVbk4KMEFS6KCO1iKYXDvQ3VL?=
 =?us-ascii?Q?w7cYVG7oCJnZ4kwyTNWQBffnoY0z2iOIDJIZIQkJYWg+51QJtdiO3InWDlAY?=
 =?us-ascii?Q?IoPFV9ZxQHwsWNTae4DfPw6+Q/1xS33Mx4yRCAeH0I0/rwR+wk5qwAIzGHr3?=
 =?us-ascii?Q?A556Ewn5c28/NPTvNBvpmdJWXe8k0L8Dq5OKQPQPf7xW+VeYSrIV9VJSTDS3?=
 =?us-ascii?Q?b+dJmr0WaaY29m2X6+ZUQnTp8uY+BYVGom5CzN2iew5POFaND1d1kV2JvzcB?=
 =?us-ascii?Q?/Y0njTpUiZULlFFswcKhtS8Fso5mff0PKaqgPmvF0dKArkBw4ITpWj2PujN5?=
 =?us-ascii?Q?AmRhrRjvgX+1T5NzC22skY/lHndRNAn+O+vbMFT84/KycI+6C3K+m8hlksH+?=
 =?us-ascii?Q?UYJG1nhKRTIbcMqglCp3gr+TRvlhkHDbJngeXYRKtGZNS9p0Kn2NiO/yLLi2?=
 =?us-ascii?Q?yoPdGHriiAE0skq2WXC3wsYUUHyliWEERuPVsriKVGbVqklefvqnVo7Yk/SO?=
 =?us-ascii?Q?XXdcc9AeVbMJb+6s7/Ojg1ytb9DfxZYIMyCIARrvlCdP2IHGty5sI3ADjnC0?=
 =?us-ascii?Q?Ugi1kHuF2a52LyMAY7BxoknbbrHJeuWQDx67SX376mfzf5+llcky+4zlC+js?=
 =?us-ascii?Q?EngvXQC5rEMV9d7JerFz6qwWawfb7B36dcQz3vdOoHjat3OEf04VUQzuJc/d?=
 =?us-ascii?Q?6N9eebrE+RVBauX7FKM6qRHnt/ZfEVA7arO5NS1paMUQqEDSC1FL7by+Iq/9?=
 =?us-ascii?Q?dPYtoExHNgwoBk1njPYW2+KtyLi8r5nOoNRIMn/66Ev+pOf8O9AQngVyOyJQ?=
 =?us-ascii?Q?N/O8KMY1jciy54LEewLZFHcz2tIaO0zxZDcz96dbIoT6wY0L3G7EYQnl6z9o?=
 =?us-ascii?Q?uIl+jJej05D1X8zh/UR3xn+S736A86B7Pczy6SQdafWDP2yCFEJqLrcXI1hE?=
 =?us-ascii?Q?JXihgetZL7dVVr9m8QRsnxuJfRMwQ/9G+mweimA0B53w4djH5++63VfgvsJH?=
 =?us-ascii?Q?/0fgGhOF5/V3GhKAzICUpEoJIMklWaArq08SETLGpeGYWo5+WUNLU1LsbURj?=
 =?us-ascii?Q?vxRDgzBaN2Iw0V1NvIwJZdhRWtCnDMhKCxZI6QJHXrbEvBOF2ONkIkh7kI7M?=
 =?us-ascii?Q?5WRp/YEyg+LEl6RwouQ8GeZcsYjXNxiQLMz0vI2HT/B6Yu8Wxd/Kz6WZrIYu?=
 =?us-ascii?Q?Sxp6Dlit8MmLzcoSRRI66FOOBK9VZqf1YXgt49GbiPul3017OazUgDSD0/w6?=
 =?us-ascii?Q?10V1jALL0rM87QRth1HhFTF6Y3IU1uiwVMDmBEOcgQhKFIZ3PU5hTKO4Ydbh?=
 =?us-ascii?Q?7MhW7pSnSJeSuiW4+uRRpbpP8yu8WxEq1g/faniRQ7oW9uee6ePKkA0s8Vf+?=
 =?us-ascii?Q?ILodZGzCc8HavFt1fVmE5tQsgMj9ylQouz8hRIfk?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 116a3426-f550-4112-a636-08dc6e76dcb8
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2024 09:19:56.9269
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RY1qjJo9umuE86QFp7/PAFPkAWAXRpYzGZfN/zoCoScGPonjQtBL7+llqPbUwmnEeB8kBTKbzdeg+RlAdNMAdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6621
X-OriginatorOrg: intel.com

On Tue, May 07, 2024 at 04:39:27PM +0800, Tian, Kevin wrote:
> > From: Zhao, Yan Y <yan.y.zhao@intel.com>
> > Sent: Tuesday, May 7, 2024 2:20 PM
> > @@ -101,9 +101,21 @@ static bool kvm_is_mmio_pfn(kvm_pfn_t pfn)
> >  			 */
> >  			(!pat_enabled() ||
> > pat_pfn_immune_to_uc_mtrr(pfn));
> > 
> > +	/*
> > +	 * If the PFN is invalid and not RAM in raw e820 table, keep treating it
> > +	 * as MMIO.
> > +	 *
> > +	 * If the PFN is invalid and is RAM in raw e820 table,
> > +	 * - if PAT is not enabled, always treat the PFN as MMIO to avoid
> > futher
> > +	 *   checking of MTRRs.
> > +	 * - if PAT is enabled, treat the PFN as MMIO if its PAT is UC/WC/UC-
> > in
> > +	 *   primary MMU.
> > +	 * to prevent guest cacheable access to MMIO PFNs.
> > +	 */
> >  	return !e820__mapped_raw_any(pfn_to_hpa(pfn),
> >  				     pfn_to_hpa(pfn + 1) - 1,
> > -				     E820_TYPE_RAM);
> > +				     E820_TYPE_RAM) ? true :
> > +				     (!pat_enabled() ||
> > pat_pfn_immune_to_uc_mtrr(pfn));
> 
> Is it for another theoretical problem in case the primary
> mmu uses a non-WB type on a invalid RAM-type pfn so
> you want to do additional scrutiny here?
Yes. Another untold reason is that patch 3 does not do CLFLUSH to this type of
memory since it's mapped as uncacheable in primary MMU. I feel that it's better
to ensure guest will not access it in cacheable memory type either.

