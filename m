Return-Path: <kvm+bounces-26184-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BFDA97275D
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 04:54:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 311941C23970
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 02:54:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E503E14F9D0;
	Tue, 10 Sep 2024 02:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="j0jn3UV/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 186601CD2A;
	Tue, 10 Sep 2024 02:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725936849; cv=fail; b=uP+Ia7UhFvkXJqsNwULEmn5dUCX4ozOtzd7dN6dq1vHXf7+pm0igvyWmUnhNAONMdu0qTCxxySkstd+SCGK6O5r0lRDJZHORx5QwSw2x3JEcFB2pAmawTXfcR5ZehRt31bZEpZzCy45jJ+fbe0U3fsA5IUOeJpknK0gVCmmectE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725936849; c=relaxed/simple;
	bh=g9IzNaZactAi5hptNY2Zk2P+aL6D1HzbZK8xk4s1fkE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=CSW3RgtnL/XVGOHnxQ5KgIhz58SZUJG/SFcmSD20b8NdC8uMk+YJL4ypDmtYh84JuXu6WSBlDshq7zI7P82CqgKI0S9YKmsW+D49itfY9gXgDXL2hd13J9wku2HVVIVtTh4ZzJxUlmIRFa1AqzgcL3Vzc+NbW10F3HMgKaQOJMA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=j0jn3UV/; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725936848; x=1757472848;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=g9IzNaZactAi5hptNY2Zk2P+aL6D1HzbZK8xk4s1fkE=;
  b=j0jn3UV/aN9WFidzWTRnEH4Cc41RkrIXXCbGSto2EDDyApUkDODB+Cuj
   tdYdLMDF2VG21kL/rDO52llDRKwzECNB5dwKAculOvR9UVifXLdsMkcUl
   XIzsMEiKHAf8wKosGTwGMaExSWb5FUCP0tznDqf6MKUIe4Yo9grHKSLmz
   MUsh6hlVp2Dg4x0P2bqrq0bVaTmwwWCIRQzB76Q9uauR2oC/G48x1LBRd
   ypUY8/kClE4Y3Tgn+FLj+5GwZ3cAeFLoE+Lx1267EeqVx7tIr4ZVWrbRK
   Rdp1eUeyLd3x7awLWa7H/SPCDJdw4IlGNJUuepwNpF4VeggMAtFaEUVU2
   A==;
X-CSE-ConnectionGUID: vqf42NteRZSzuE5LACVWfQ==
X-CSE-MsgGUID: mJt5IiCEQ1m4EPHNgzmMdw==
X-IronPort-AV: E=McAfee;i="6700,10204,11190"; a="24771734"
X-IronPort-AV: E=Sophos;i="6.10,215,1719903600"; 
   d="scan'208";a="24771734"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2024 19:54:07 -0700
X-CSE-ConnectionGUID: dJ+T2YayQeKXVzZLbuXYfg==
X-CSE-MsgGUID: jvUWX7LiSc2xz68tYM7Osw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,215,1719903600"; 
   d="scan'208";a="67620894"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 09 Sep 2024 19:54:06 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 9 Sep 2024 19:54:05 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 9 Sep 2024 19:54:05 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 9 Sep 2024 19:54:05 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.46) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 9 Sep 2024 19:54:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j+6VSCYJ52T3P/6wjFqJfvbdh6vqRMcxuK7zQPZR9RCTWu7BSOvyomQzMnoie93wbfLcpQ/CYhn0reA9mn21xhYKDAfLmIWd4m9oJunKV/jkaJuiTzKj0gvsxvf+ln78AsroWuujUTAw/HmSe0rPOZhzKUjJKZb1dbqTPmQ72Ny60XZY2h+qrAcgXvXytjvsK0Z8CjFPiFh5rtCsQxETwRbNmCbA+6SgcJCeLYBzSHxxkI9eexKbTlFZhw/uU1FqmANU7q6cIiO9JxRqbZnh/hYKB4FFr11KI1rnEzQQv2ecySzwvtpfqQXH1swhvPfCm4r8UBNDLO1HtQCxrrnaHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pCsu9Kcp3+c7KXjelnD5w/QiT+Lh1GUy9I/zYLjTE8U=;
 b=tyFytVqP2waO9FqXEwg7+a56xmaVIfOAWPFrBx4mlepsJKqNj/AYjZd0YxX1VLFGAACC3dgtLwVwDBugo+aLmRrbimpKAX9/Y50AGGWUAJZA78ANaHob6aRVOVufE4GzI1BsCekIxK9CuBsYk6AikrMRn9p/ScWpMXblhta0IZSmyFrdua+q6FwAzVB++FULWUyAOs4Zn3gbSrrqfevGGyJ2mEGGsDGPWpj1eD4deUZ1Wrsfp/g964hKNxsRpQhDegKp8i8ei9hW0gEyhJ+bko5N6ZHneOR9FBR8yISy6bhnrCllCCSmPjP5knKZKxMcOW8y84/Swu7mAI9Buts2GA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH7PR11MB6331.namprd11.prod.outlook.com (2603:10b6:510:1fd::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.28; Tue, 10 Sep
 2024 02:54:01 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%5]) with mapi id 15.20.7939.017; Tue, 10 Sep 2024
 02:54:01 +0000
Date: Tue, 10 Sep 2024 10:52:01 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Peter Xu <peterx@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, Gavin Shan <gshan@redhat.com>, Catalin Marinas
	<catalin.marinas@arm.com>, <x86@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Dave Hansen
	<dave.hansen@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, Alistair
 Popple <apopple@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, Sean Christopherson
	<seanjc@google.com>, Oscar Salvador <osalvador@suse.de>, Jason Gunthorpe
	<jgg@nvidia.com>, Borislav Petkov <bp@alien8.de>, Zi Yan <ziy@nvidia.com>,
	Axel Rasmussen <axelrasmussen@google.com>, David Hildenbrand
	<david@redhat.com>, Will Deacon <will@kernel.org>, Kefeng Wang
	<wangkefeng.wang@huawei.com>, Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH v2 07/19] mm/fork: Accept huge pfnmap entries
Message-ID: <Zt+0UTTEkkRQQza0@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240826204353.2228736-1-peterx@redhat.com>
 <20240826204353.2228736-8-peterx@redhat.com>
 <ZtVwLntpS0eJubFq@yzhao56-desk.sh.intel.com>
 <Ztd-WkEoFJGZ34xj@x1n>
 <20240909152546.4ef47308e560ce120156bc35@linux-foundation.org>
 <Zt96CoGoMsq7icy7@x1n>
 <20240909161539.aa685e3eb44cdc786b8c05d2@linux-foundation.org>
 <Zt-N8MB93XSqFZO_@x1n>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Zt-N8MB93XSqFZO_@x1n>
X-ClientProxiedBy: SGXP274CA0006.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b8::18)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH7PR11MB6331:EE_
X-MS-Office365-Filtering-Correlation-Id: ce8032b0-4ac9-484b-366a-08dcd143d308
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?JCSCAUswvFvnudPc+skQke9fDxnN/+0DqGL3rZ8/JyIRDwZVf6wOnnwAyqcz?=
 =?us-ascii?Q?kEOIC8Noxt9ogEEaXf3nnW+KJLHiM4t1g/gnIRRul8xdXnDfUQ+zvK38s9l2?=
 =?us-ascii?Q?J8/ABgBVPCloQsNGq+alTDbarltxMQVfp/0R2FFSyFEOlnUmvQApxExd6++/?=
 =?us-ascii?Q?J3jTc1zv2OeRsNhdfeYCRXldZx7iAeaQKZ54kXwECe/+gkhzfBSeAc0Aedv2?=
 =?us-ascii?Q?yPXg/tD/rekkjV1LJRcH6YwcFbGLbqfA2f8w4Dk7MITZCv6XuBC+UfhitmJw?=
 =?us-ascii?Q?M174Wcz+8uuuSCuccQwr+Rj0YO2dOTKVC7M6N1Fg5btAbaTQ1tZVRoi7YRJL?=
 =?us-ascii?Q?kPTr75PZfZTxg+gpuEFNVCmaA0BgDVCXNNAguz6g5s88aToGbvHilrlFzmKy?=
 =?us-ascii?Q?dSCRNrHbeG1Qwh1YFxutb44Q6cIdRfZXydWKsMP23tVu/6yfR7eRdAIan7XE?=
 =?us-ascii?Q?42SrZIVZ32SdfAKZ45R6A3mfruNmGumF39lKrwf3f7DdVe5gdfpR35oAEtkZ?=
 =?us-ascii?Q?bcOt3I/r0G0w4/AYKbsOUKqMzhp+J+RlbDHY3clJ2H10YVGRUZZCVZzspTlE?=
 =?us-ascii?Q?Ko+a0NoHgc07jJuqzZcsqjz3kt4D0CNoHOEAixaPhnaopdiELRGR8pMU1QAD?=
 =?us-ascii?Q?fjb6+lm6PYFU9NofQ7dFUaUFiSnWnwaQEsnldqD8EROgFXhNwpVL6UPZ4z5P?=
 =?us-ascii?Q?ee8S99b+/9G2S//ZrIwB5+7K1ifK4CsvABvoufPSvPvMkadshwvTo7jrqS8Z?=
 =?us-ascii?Q?+sbdlKN4fTuNWW5p4oX612MZUmIgFgPmyNqg4IkmmJr4cqgnWx49P2kC6KFx?=
 =?us-ascii?Q?vRCE4E/whp/W8UZvAbDd8JLvHUSLrTr4izu7R+Yy3K40d4yj30+1Zga8m13+?=
 =?us-ascii?Q?BzpulzS9vkHeG5Qta/5vXrF8xaoYoYzAJ5jCJenbtjknBKbPdxJKv1ghv7PR?=
 =?us-ascii?Q?xeL7+iYsY4gBkHAgJa61NMO8ZIhxi4o3tFLUCXMFXSz10yuSTFGpWWuRFvTe?=
 =?us-ascii?Q?jdSo2rbT1TEUlivRw8xVjoFMKIo6UHk0hM1I2junLm4QNGbgOG+Aqu8eZVEt?=
 =?us-ascii?Q?WgocoYX81mgVVs/i0R58KRk713DC9BKxqk41ivrFQXe5hmQMS8XgUS6ZMgwB?=
 =?us-ascii?Q?i5MsGgWGJyzBDisJU8tU3edPVQfTSbGNVTptwESG64o9hgr93F1CLRAgabHz?=
 =?us-ascii?Q?vRBuyytl35vD7D839bomYndIEESq9C+P/mBH4VHrKCGs+NklESUIuY5Fzh4p?=
 =?us-ascii?Q?4iwExsy7GzvQ9gR4mUaqf5Zt60IcdAqFixBvyhUPPEULE873k6GmTTKA8JwU?=
 =?us-ascii?Q?66GP99Rbw8eZhYKCLZ+74GOg8RvDvIkJPG/pWBiXPnWQWw=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GW9lpYqE2yvoNTxynO3l2tzYNLanXSco9cD0iRZS/u/tchCLSqBLKzEH1w6O?=
 =?us-ascii?Q?td1pGHoeXliWp6TJoZLRUcU9QKGkt5L3wPbuhhxpnALjIuMSu+trKQPBKeld?=
 =?us-ascii?Q?6F4Crvqy/J5vPijh1p+SyXUhVAIJmTah00aETavqFX1YMnFD2RCFVdCOD7de?=
 =?us-ascii?Q?3W3COiB1rQj+yjlp3tJLEczOtaWLw9P1WWnxzkFiUOmdj8jBLdNs69+bAqcT?=
 =?us-ascii?Q?Ko265IhYnhHIGQSINE7b8GC2n7gTLA+VA4LsZzKfhOiE6MKu8LzfgIalraGU?=
 =?us-ascii?Q?KPi0XnzfluAGIYO8E8L+GywVY6qvDibhEpcDbLcuCtzfwavZZegQXUTBB3qO?=
 =?us-ascii?Q?SBB1qGydFeuvtKrxRPKyj7lFiYXw3iPSCbMWRCxrWB0EuHaCx/sJINlw2Yxj?=
 =?us-ascii?Q?A8KrUL+iPOwwPYr62QzVblxyU7a0p/oxu/tLJuIn8hiRCQ08KKBS4B4FWppP?=
 =?us-ascii?Q?sD/YssNbXnKnU32oeeELgy/tHSSQ87JIWM/wGtV5fTO5Jm0jCC7cqi7kYHKX?=
 =?us-ascii?Q?GJXGfvHU/MmBByHYd7uoP19CslgY5fAZ8Ch/437rTJc97/AMPKjPWKaKr+HA?=
 =?us-ascii?Q?0t8/41dqkFgyvrTxXoLxar6lRkTMogCrwsdtZr89IHJx9GI32ddMnlihaf9/?=
 =?us-ascii?Q?/uk4xjs9hsAKhT2cQ8IUJICGHw5TO4ovHlwsuHpkurviN3cMUjCcW2xpYpsj?=
 =?us-ascii?Q?ue02CnVG1VQa3XlVXWiM4V7eSQdB8MfmhT3livBhdVWRSXl+lS9OimEeytpj?=
 =?us-ascii?Q?Rui/ayb+34gvqFwuaVteulIU5ob43DTI9okU5OT+mFwI9nhczoVzAuNfP1NA?=
 =?us-ascii?Q?mKrMhSgf+U8hwfhMNdj1oe75NS5hErxz0z0U7kcVfpmKN6pJ1JJmCEFKCU8z?=
 =?us-ascii?Q?kjWZ7dywn+E1Uk5VrqRHI/y22nZCE1PuunfSjY15Wy2lU5z9p/Rt9hLoc0Vw?=
 =?us-ascii?Q?uW/jjp00E8ibVNw5UYHi69O298h8ICw8o7+t5pXjUe0yboDITFKgZ9xdZX6t?=
 =?us-ascii?Q?2c8AEEZiBRe1tq7N0PnFEx0aF3dbKCGpPoocAdsMA6rpA5NjIylVPFz5YjBg?=
 =?us-ascii?Q?yravo0V0WcqmUxecIX+VtPtAEaLBjVLF4xTOaw9DVqdMx/09Yfin23dFko+d?=
 =?us-ascii?Q?9noovFj+AOxyKWZ9njagBK/sV8N1aOlAHiGFegQaQeOLy7R+uB+1LrBKhc8f?=
 =?us-ascii?Q?PNdnWf+VkzW9GW1cAMIpyaHHQwfNWVBnEqFts1zeLoMHT4GJufs/kUix0FCu?=
 =?us-ascii?Q?vlFFmkNGWN87rEXjEn+ElhNMWqC9hvLV6EHwt7kEFh0RGF2HMCAaUmsWBwVW?=
 =?us-ascii?Q?8wsgvm8u3oZ42EL6zZ6IzrjH4D9yGBYSHeml3p7T9HQxWHgmHk0eueqXnHU6?=
 =?us-ascii?Q?m6WuF869xS3om5OEKrfPB1p1n+L1Ji5kk9BmfPqeI7E/wKS/DSRM9rov1WNS?=
 =?us-ascii?Q?XEM+yoy0cEv84TmCuSDGSfE3OSZC5FvWeXUDhxF1n3N+pjKwlHCheYFoRtIq?=
 =?us-ascii?Q?Xv2t5MCLloyA/dlkiwKFEMUEa5+gEc4/WWIxobxr6gZbGl620uB+vSL91dsv?=
 =?us-ascii?Q?hnMRyrfiKk6ajhBIteBVbMRqM4lEpYolmagbcC7x?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ce8032b0-4ac9-484b-366a-08dcd143d308
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2024 02:54:01.4489
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KanhYRdlCbt7rMO3JtDiL1mIQDgOX6yCIvfgaw9wAJdUMTvcYPK4xIhHmEKUIcQAv1DGy8pmLvv6yXEJm2N5lQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6331
X-OriginatorOrg: intel.com

On Mon, Sep 09, 2024 at 08:08:16PM -0400, Peter Xu wrote:
> On Mon, Sep 09, 2024 at 04:15:39PM -0700, Andrew Morton wrote:
> > On Mon, 9 Sep 2024 18:43:22 -0400 Peter Xu <peterx@redhat.com> wrote:
> > 
> > > > > > Do we need the logic to clear dirty bit in the child as that in
> > > > > > __copy_present_ptes()?  (and also for the pmd's case).
> > > > > > 
> > > > > > e.g.
> > > > > > if (vma->vm_flags & VM_SHARED)
> > > > > > 	pud = pud_mkclean(pud);
> > > > > 
> > > > > Yeah, good question.  I remember I thought about that when initially
> > > > > working on these lines, but I forgot the details, or maybe I simply tried
> > > > > to stick with the current code base, as the dirty bit used to be kept even
> > > > > in the child here.
> > > > > 
> > > > > I'd expect there's only performance differences, but still sounds like I'd
> > > > > better leave that to whoever knows the best on the implications, then draft
> > > > > it as a separate patch but only when needed.
> > > > 
> > > > Sorry, but this vaguensss simply leaves me with nowhere to go.
> > > > 
> > > > I'll drop the series - let's revisit after -rc1 please.
> > > 
> > > Andrew, would you please explain why it needs to be dropped?
> > > 
> > > I meant in the reply that I think we should leave that as is, and I think
> > > so far nobody in real life should care much on this bit, so I think it's
> > > fine to leave the dirty bit as-is.
> > > 
> > > I still think whoever has a better use of the dirty bit and would like to
> > > change the behavior should find the use case and work on top, but only if
> > > necessary.
> > 
> > Well.  "I'd expect there's only performance differences" means to me
> > "there might be correctness issues, I don't know".  Is it or is it not
> > merely a performance thing?
> 
> There should have no correctness issue pending.  It can only be about
> performance, and AFAIU what this patch does is exactly the way where it
> shouldn't ever change performance either, as it didn't change how dirty bit
> was processed (just like before this patch), not to mention correctness (in
> regards to dirty bits).
> 
> I can provide some more details.
> 
> Here the question we're discussing is "whether we should clear the dirty
> bit in the child for a pgtable entry when it's VM_SHARED".  Yan observed
> that we don't do the same thing for pte/pmd/pud, which is true.
> 
> Before this patch:
> 
>   - For pte:     we clear dirty bit if VM_SHARED in child when copy
>   - For pmd/pud: we never clear dirty bit in the child when copy
Hi Peter,

Not sure if I missed anything.

It looks that before this patch, pmd/pud are alawys write protected without
checking "is_cow_mapping(vma->vm_flags) && pud_write(pud)". pud_wrprotect()
clears dirty bit by moving the dirty value to the software bit.

And I have a question that why previously pmd/pud are always write protected.

Thanks
Yan

> 
> The behavior of clearing dirty bit for VM_SHARED in child for pte level
> originates to the 1st commit that git history starts.  So we always do so
> for 19 years.
> 
> That makes sense to me, because clearing dirty bit in pte normally requires
> a SetDirty on the folio, e.g. in unmap path:
> 
>         if (pte_dirty(pteval))
>                 folio_mark_dirty(folio);
> 
> Hence cleared dirty bit in the child should avoid some extra overheads when
> the pte maps a file cache, so clean pte can at least help us to avoid calls
> into e.g. mapping's dirty_folio() functions (in which it should normally
> check folio_test_set_dirty() again anyway, and parent pte still have the
> dirty bit set so we won't miss setting folio dirty):
> 
> folio_mark_dirty():
>         if (folio_test_reclaim(folio))
>                 folio_clear_reclaim(folio);
>         return mapping->a_ops->dirty_folio(mapping, folio);
> 
> However there's the other side of thing where when the dirty bit is missing
> I _think_ it also means when the child writes to the cleaned pte, it'll
> require (e.g. on hardware accelerated archs) MMU setting dirty bit which is
> slower than if we don't clear the dirty bit... and on software emulated
> dirty bits it could even require a page fault, IIUC.
> 
> In short, personally I don't know what's the best to do, on keep / remove
> the dirty bit even if it's safe either way: there are pros and cons on
> different decisions.
> 
> That's why I said I'm not sure which is the best way.  I had a feeling that
> most of the people didn't even notice this, and we kept running this code
> for the past 19 years just all fine..
> 
> OTOH, we don't do the same for pmds/puds (in which case we persist dirty
> bits always in child), and I didn't check whether it's intended, or why.
> It'll have similar reasoning as above discussion on pte, or even more I
> overlooked.
> 
> So again, the safest approach here is in terms of dirty bit we keep what we
> do as before.  And that's what this patch does as of now.
> 
> IOW, if I'll need a repost, I'll repost exactly the same thing (with the
> fixup I sent later, which is already in mm-unstable).
> 
> Thanks,
> 
> -- 
> Peter Xu
> 
> 

