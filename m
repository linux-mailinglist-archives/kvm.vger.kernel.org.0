Return-Path: <kvm+bounces-34661-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 25365A03812
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 07:39:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 717B818831C3
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 06:39:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7162F1DED6E;
	Tue,  7 Jan 2025 06:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QKOsul1O"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2EA626ADD;
	Tue,  7 Jan 2025 06:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736231960; cv=fail; b=puK1Pp/O8gqqIGJPrt7C0MyoX+QE3o0SATJT8IqL71vzNn4RbdRyxQDv1Bn/PNRsNqJB2rADhugjYKK/Nzsqf4I146Gk21nQ5ORR1drfp5b96pdlO4ZItyhyO8KVvsEwIKWwufaGwjM112g6MmS1Tqk9G42un4LFCjghmW1iaEQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736231960; c=relaxed/simple;
	bh=l0okx23plxKULopevdJ+Hj8NvB1NqbEsxABzt1CMeXI=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=RoDReaCiJbxbUn35bgjdKofDoeBVguxHyuRjLCDwMXyA9nS01C0lWhi8yf3AztvwwC//+ADNnVBXf1/6InTqgl7+nclX7vWczLF/UbNVTb0tQXLzH57MKcro+itQVPVxWCjZCOj94S1Rwo5ZWCYhGIQ5loF8yl8tvvmf9+uNbm8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QKOsul1O; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736231958; x=1767767958;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=l0okx23plxKULopevdJ+Hj8NvB1NqbEsxABzt1CMeXI=;
  b=QKOsul1OhCS352/j3GOqfn+fPTomHYZllnqGq0Vz6NkBIJW8TwtKfpNo
   uAvOGgz7wkmU8HqXNsL+tEAUY0Ce83lqrvOUDQUMa1KBklW34BqqEipMM
   8NMjbttxgSlW2rZnWjBwJEEH4UXeR8VclpAQeI6otf0CO6pwM1aDv4bT7
   RV81Hlp3HnzeCo0CV+L0XKF5B40rEg6O4EPDL6mGzv1n5ne1+ORJWJFCU
   zkDspGcjDqGTBWeTs/JDulISzpxGSubhtihRYDrbHLuIxsf1sijLSiZTZ
   LOWxBfJfpXLGP47ISONqHtcrLwc7SPZ5ypH8WIAqcNcLyQ9RyMO05dY5r
   A==;
X-CSE-ConnectionGUID: DJ+MtPhoRvi7WlFUAXpqnQ==
X-CSE-MsgGUID: MTUTQ8mhQX6X8Hf2ToO3lA==
X-IronPort-AV: E=McAfee;i="6700,10204,11307"; a="36094912"
X-IronPort-AV: E=Sophos;i="6.12,294,1728975600"; 
   d="scan'208";a="36094912"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2025 22:39:15 -0800
X-CSE-ConnectionGUID: k1pE0RigRVC+rg5JW9oRZg==
X-CSE-MsgGUID: yMByfN6xSQqfhMs1NI8qpg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,294,1728975600"; 
   d="scan'208";a="102743694"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Jan 2025 22:39:14 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Mon, 6 Jan 2025 22:39:14 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Mon, 6 Jan 2025 22:39:14 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.42) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 6 Jan 2025 22:39:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LMd19M71qGu257ggnDDdSGg/Bz/8jbXqHt8aJy3N7sIng/yxg2dsIpgJBGQ/zTWhaGQXOIX0TJ+V0BmDIRXZ9ywXs9TWyA3cZlaG1aRe+EGsfRAIE8T9flGWszL78w+upRrlWZCxOcADRWX1696s08OMUSYUU0R4fMkSIfWQhfUj5HkFaydPtSYlXInMMQN4NnJWRfYf99F0dZZ44KlbL76DF+o4QyvWTcMq/LLJ7BWqNoEy4rF2byrwOH+hWt60JjO5ijWKJ7dVUupF7d2PkCgzgWxhkikPJJdsk1Gsw/XqhqTPmaveASzLzNgg+/6pXESWHDs7ZV6dKaHhKIt3Hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PNA7+eR9f6KofS/6J8PrkzxrE+btOxhNsZLsWOzrmc8=;
 b=EtUZMlHpFLjQodNf6xT8ZcJGoKaT4FERs+mlFRgyvw34bilrdxyjGZe90rGzeakQFFvjVQQ1J0AL+jquS1Unb2HjMSEmz5QZxscdCmCvy1mdBu7mq/voW1JFfQ3n02XCfsde8mmP7fcSDUkkK7jRsE0a4m8uX4KxsWzKKI2hbT/+s/7O+PuIlLZcjYHFdwc7rkRgCgiOjjPNOqJtTeGqXJn0zibivUnq7ishqSEnlLqo+ngkagPSKMSgbLtSOXkV8q7n86w3r8y7GbMIzFX5YpjIzhy5MmbzUqsH1DNM2CvRJLT1Yla1eSJaeEyiH8AuCD407sPDLokWTmBQbIJANw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN0PR11MB5964.namprd11.prod.outlook.com (2603:10b6:208:373::17)
 by DS0PR11MB8665.namprd11.prod.outlook.com (2603:10b6:8:1b8::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.10; Tue, 7 Jan
 2025 06:38:27 +0000
Received: from MN0PR11MB5964.namprd11.prod.outlook.com
 ([fe80::7a0e:21e8:dce9:dbee]) by MN0PR11MB5964.namprd11.prod.outlook.com
 ([fe80::7a0e:21e8:dce9:dbee%6]) with mapi id 15.20.8314.018; Tue, 7 Jan 2025
 06:38:27 +0000
Date: Tue, 7 Jan 2025 14:37:31 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Huang, Kai" <kai.huang@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH 08/13] x86/virt/tdx: Add SEAMCALL wrappers to add TD
 private pages
Message-ID: <Z3zLq3BT3vIsB73o@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250101074959.412696-1-pbonzini@redhat.com>
 <20250101074959.412696-9-pbonzini@redhat.com>
 <c11d9dce9eb334e34ba46e2f17ec3993e3935a31.camel@intel.com>
 <Z3tvHKMhLmXGAiPg@yzhao56-desk.sh.intel.com>
 <dbac12aec5270170c2f1a396f56c184a34b14133.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <dbac12aec5270170c2f1a396f56c184a34b14133.camel@intel.com>
X-ClientProxiedBy: SI1PR02CA0025.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::13) To MN0PR11MB5964.namprd11.prod.outlook.com
 (2603:10b6:208:373::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR11MB5964:EE_|DS0PR11MB8665:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f91e8ec-b03a-4eb2-c021-08dd2ee5e459
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?eitJ7foZcglyBSJjWUaAto1+tlOhIZIgUM99W9buOEWn44ei23G2nxtFfYBz?=
 =?us-ascii?Q?vMVIO+WEZFnihOYDJMr1Ph9R1F50dYn8ubDsjUdQZ84z39rz4Ps0EYh5kQUv?=
 =?us-ascii?Q?lKDLVxHgZAC97CZnjg4CNXn9z7T930G2RtmkeEY/ZcK3X1QrctWN/jZ9NSne?=
 =?us-ascii?Q?GKLyB5bFaf7uj+70LlfbKn/4fSdYF6Puq8Vfl7LWCwWdBkF+ZVB3z2XaVt1u?=
 =?us-ascii?Q?DBbiOwZZuUJy5lFeFnFwplyIlGSwhv8WHgGpCo4k/SFBS8I1ixHL/iCIkY8N?=
 =?us-ascii?Q?Z2ngwjGz9AqJ+KjpDUUReK25PM6qsPGT/3JiBxyPrMZEaUurvLnWzJp8UJtX?=
 =?us-ascii?Q?lBzgCg3nH8Vl/xnKaNjFI6B04Vm7EXnbIPK165bAIbBXybDgCWWye7fFZVHM?=
 =?us-ascii?Q?HJKh56B9WIXQA/bJLdngNwzFFaWCulfiXjP73dIrG+JRp4CcT1QdIdiemfRa?=
 =?us-ascii?Q?JfX53j696k5VBziuYlPBqsOs5m9Koi6rJex9KdeIqOY9x42ep15DA2oFksSK?=
 =?us-ascii?Q?FGSgBBaN+mphw3AJQWvdudBmrDcfEUX2wesXH6dyMOthKKGzvhNGkYWHp2bq?=
 =?us-ascii?Q?Vz23AuTNKQqkKnd1bILfz2ZYUPL/SfEdjduVmA08Il7haFoKoPULpT4unyI7?=
 =?us-ascii?Q?fH/LK566WPJjw9KeR41Btk3aqXeW/zXqvnLsXUnTI8hXs3fq72udd7c/LnTY?=
 =?us-ascii?Q?slOWsoI1KndQo7hdW4ifGd5nuZLQVY75lOkF3ZMepVQWt3g9L9ZXqFkJIXhd?=
 =?us-ascii?Q?dN28Qvuk+jNWFIco6rTRy1t2/EY94I07dWKyjbpWTbGGl55cAnxHmMh0YhDb?=
 =?us-ascii?Q?gKOHbZmlrR7JDSqTNlRw0tKpM1ZK0OZpBr3uXlEWzhmUWks9rgbS+S9YMnX1?=
 =?us-ascii?Q?txcuLzetyP1ZMHHXhDrY1EwD4m998tIpPrxLm260bMqFoics8rEG65n/l3y2?=
 =?us-ascii?Q?FwOvnuMD9tSvh9Y22jf8mqwY7YsX7wfNUB+3EvPC1Jh3miI87CLePwKcpwPW?=
 =?us-ascii?Q?l0rv0N5NG3f4OSNItpms/b3aBpUmfJ3CykLBT0IoNVX3j8spsQZtZhgsnD5C?=
 =?us-ascii?Q?ph15TORpGJ90/4mrjwLrLDSA0/iF1wFM+SrbXhdB2pBYy5umpbXTxgZ8OsKV?=
 =?us-ascii?Q?J919asruVt0WnwFrGC/HlGVqnT5muGmGnCE3E09MzJD276l0sHJoUJacMUOb?=
 =?us-ascii?Q?XKGVXmhonjx605lQhnv8LBm8maACT1jEDFM48GwpI2VLcSoNSGDnJ6MS2TLM?=
 =?us-ascii?Q?6AOcfJHjEWOhvWs49Xn6gHwExCpUtCU6yhjsEWtfbWnSIcfrRnu+hiSSQp67?=
 =?us-ascii?Q?Cd89SNkm8MMlhBVI+e48et1+MYNY/nW60G+EeNCKX4KSr7hiDZWqf+2S8z+q?=
 =?us-ascii?Q?wZVqtDOkbO3Igj0IvcnZX5TN7L8d?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5964.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wdnVwMQUOfTDpk8r77Zb7Y4MfalKZCvt/D18CqcQEodHlNiSqkIe7Eu3xi/X?=
 =?us-ascii?Q?pfH8UPOXOXEbIxkG3Ml/tjye+t6CF6TWqnTjgk18d8+Se++mnOxqkQVNzJeg?=
 =?us-ascii?Q?VbJ2pUjOHHbzfLbwZ8dTfEz1iqq+ggkA6YFr8DhBsLEZiQacyB9ERLYtAf7Z?=
 =?us-ascii?Q?LVHbQR2jUf7Jny5COlftaKtHTdfc2UOrZ/s5LH//TX2qA1LEWGmH3IQvYyja?=
 =?us-ascii?Q?28L7eq8K17OzbLb5ujVndxbhG5t2ZH4bnh4V+XxuCTo8AD1jfzkOTZWorg7Z?=
 =?us-ascii?Q?wQGXvREe3zy48rXPxq+HVv3tGrRsbaEzSayzDxPSBazKDlRSnPrrKlbRgXPn?=
 =?us-ascii?Q?GmeIAk724Cx2EbyewjGZKtNSj987dWcGy/69DRJdEfVG2BFq21UPYp8Lc1Vk?=
 =?us-ascii?Q?1L5vVT9K3qnJ4A8k+S1PIy/+2QKxQRh9L/eSyjDphHDgmx6lJUrkdgJuQ4ZN?=
 =?us-ascii?Q?qF0KrRcsBX8kzuv5mpDMn2gyK1OZEjuC95jp4gdydTdj2toztcHk/2Mm6LCY?=
 =?us-ascii?Q?tMZtiaurCtTjuSGb9s9GtrU+xkqz4Xbd0BUwue/cTAKeYLtCCCnHB1eGMfu5?=
 =?us-ascii?Q?KGvtZ9+YXCRWd7e+luKvW9WoY5LAY59oNWQgcX0iRgF7lyP4c4TXL0q00pkP?=
 =?us-ascii?Q?Kp3T2iWodya4sMXHl5JERyUkNr2+IaDRAKRjGmOGcowyOBLdI0afoGjo9uaT?=
 =?us-ascii?Q?/jSD7sTrhEZjSfAY4+oUd2GJaCceZeOqtpEMfyfmry2pZxNeKnwyln169lML?=
 =?us-ascii?Q?cxm5VISi3jz2Hm4bzXP/lLmN4tFMJ/Cr5OcDUf0cc4XtkqKA0caoRsQ2Xx2j?=
 =?us-ascii?Q?xeetxQyH9Du5ie2EkVv8Z1QF1H+3fyl2FpW6EC8f+Yo4zF4SM3hhuufTzvpz?=
 =?us-ascii?Q?zWeTxgsBaApWzmz8oAPY3l0TndF+hZJRd9NghB+P70xehXQnZcxF/2+F1Ahy?=
 =?us-ascii?Q?QSfzrbla6WI+OmfESaK1Yip+a8+bKP6Z/saMgYOuY5odXEs35bSEOEt65ahp?=
 =?us-ascii?Q?qxHEI3s7qJPWDa+8hUvJO1vI57erTtMdFkVuqgshfqIQ1r71rWEXs1mUIBoW?=
 =?us-ascii?Q?TP2aJn53m1u4dNJgmyncRVnRZ5PctOLBuBVtL9i2f5h3vX9bZxDYjiyPZVda?=
 =?us-ascii?Q?G5efwViqgdmfpQRpX1J8GPR8yCF1KesCSI8B+Xy2kL3gqmAKsAHOL1i0kXx1?=
 =?us-ascii?Q?rQl+VLYEu7eRl46zy5gqKKmWmsT2JJouuyydxrY6EAU0EQtwbDMqVaOz4ZhA?=
 =?us-ascii?Q?speaj4Gs9HV4XYh4k+15eDbJVZr4Th7nd3WjvxtjObMfphdlUtWInGM8uJZJ?=
 =?us-ascii?Q?fRCOVgPIZgt4jIxfcRTrx/f/6qsjDiJsZ1zfTe8bbYVHicpAsISCqZlj0qpg?=
 =?us-ascii?Q?AMjVapUovws5Arp2P2o/xK8qopgLNS5kL5q7p4ntFQJhDvtpIoJ1RSoBMRMT?=
 =?us-ascii?Q?jreOcyo/eonEFkaEtT3H+FCm7cCqbzuQBp0zNxFLD4gC3yWRi1yKbyJROxK+?=
 =?us-ascii?Q?wqypRBadgUNfPoIjIlplg+++k1LgBjk9QoF6E/9LeJBo5VbMxYWEjOXqNYiw?=
 =?us-ascii?Q?m88ZrfJjZPgPWw5VaHP4RDcfUodonjWeBCA50Mui?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f91e8ec-b03a-4eb2-c021-08dd2ee5e459
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5964.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2025 06:38:27.0954
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SneCMpOrm1Yb0CFrLouqVSuLcxrT1QBL/4JLNxEaXPJPtDIOEhT8ybfxWrsGBBrgdqGoqqq6d9e5dKjyZqb03A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8665
X-OriginatorOrg: intel.com

On Tue, Jan 07, 2025 at 03:21:40AM +0800, Edgecombe, Rick P wrote:
> On Mon, 2025-01-06 at 13:50 +0800, Yan Zhao wrote:
> > > I think we should try to keep it as simple as possible for now.
> > Yeah.
> > So, do you think we need to have tdh_mem_page_aug() to support 4K level page
> > only and ask for Dave's review again for huge page?
> > 
> > Do we need to add param "level" ?
> > - if yes, "struct page" looks not fit.
> > - if not, hardcode it as 0 in the wrapper and convert "pfn" to "struct page"?
> 
> My thoughts would be we should export just what is needed for today to keep
> things simple and speedy (skip level arg, support order 0 only), especially if
> we can drop all folio checks. The SEAMCALL wrappers will not be set in stone and
> it will be easier to review huge page required stuff in the context of already
> settled 4k support.
Ok. Attached the new diff for tdh_mem_page_aug() to support 4K only.
Have compiled and tested in my local env.
(I kept the tdx_level in tdh_mem_range_block() and tdh_mem_page_remove() in
later patches).

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 787c359a5fc9..1db93e4886df 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -144,9 +144,14 @@ struct tdx_vp {
 };

 u64 tdh_mng_addcx(struct tdx_td *td, struct page *tdcs_page);
+u64 tdh_mem_page_add(struct tdx_td *td, gfn_t gfn, struct page *private_page,
+                    struct page *source_page, u64 *extended_err1, u64 *extended_err2);
 u64 tdh_mem_sept_add(struct tdx_td *td, gfn_t gfn, int tdx_level, struct page *sept_page,
                     u64 *extended_err1, u64 *extended_err2);
 u64 tdh_vp_addcx(struct tdx_vp *vp, struct page *tdcx_page);
+struct folio;
+u64 tdh_mem_page_aug(struct tdx_td *td, gfn_t gfn, struct page *private_page,
+                    u64 *extended_err1, u64 *extended_err2);
 u64 tdh_mng_key_config(struct tdx_td *td);
 u64 tdh_mng_create(struct tdx_td *td, u64 hkid);
 u64 tdh_vp_create(struct tdx_td *td, struct tdx_vp *vp);
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index adb2059b6b5f..cfedff43e1e0 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1583,6 +1583,28 @@ u64 tdh_mng_addcx(struct tdx_td *td, struct page *tdcs_page)
 }
 EXPORT_SYMBOL_GPL(tdh_mng_addcx);

+u64 tdh_mem_page_add(struct tdx_td *td, gfn_t gfn, struct page *private_page,
+                    struct page *source_page, u64 *extended_err1, u64 *extended_err2)
+{
+       union tdx_sept_gpa_mapping_info gpa_info = { .level = 0, .gfn = gfn, };
+       struct tdx_module_args args = {
+               .rcx = gpa_info.full,
+               .rdx = tdx_tdr_pa(td),
+               .r8 = page_to_phys(private_page),
+               .r9 = page_to_phys(source_page),
+       };
+       u64 ret;
+
+       tdx_clflush_page(private_page);
+       ret = seamcall_ret(TDH_MEM_PAGE_ADD, &args);
+
+       *extended_err1 = args.rcx;
+       *extended_err2 = args.rdx;
+
+       return ret;
+}
+EXPORT_SYMBOL_GPL(tdh_mem_page_add);
+
 u64 tdh_mem_sept_add(struct tdx_td *td, gfn_t gfn, int tdx_level, struct page *sept_page,
                     u64 *extended_err1, u64 *extended_err2)
 {
@@ -1616,6 +1638,28 @@ u64 tdh_vp_addcx(struct tdx_vp *vp, struct page *tdcx_page)
 }
 EXPORT_SYMBOL_GPL(tdh_vp_addcx);

+u64 tdh_mem_page_aug(struct tdx_td *td, gfn_t gfn, struct page *private_page,
+                    u64 *extended_err1, u64 *extended_err2)
+{
+       union tdx_sept_gpa_mapping_info gpa_info = { .level = 0, .gfn = gfn, };
+       struct tdx_module_args args = {
+               .rcx = gpa_info.full,
+               .rdx = tdx_tdr_pa(td),
+               .r8 = page_to_phys(private_page),
+       };
+       u64 ret;
+
+       tdx_clflush_page(private_page);
+
+       ret = seamcall_ret(TDH_MEM_PAGE_AUG, &args);
+
+       *extended_err1 = args.rcx;
+       *extended_err2 = args.rdx;
+
+       return ret;
+}
+EXPORT_SYMBOL_GPL(tdh_mem_page_aug);
+
 u64 tdh_mng_key_config(struct tdx_td *td)
 {
        struct tdx_module_args args = {
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 0d1ba0d0ac82..8a56e790f64d 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -18,8 +18,10 @@
  * TDX module SEAMCALL leaf functions
  */
 #define TDH_MNG_ADDCX                  1
+#define TDH_MEM_PAGE_ADD               2
 #define TDH_MEM_SEPT_ADD               3
 #define TDH_VP_ADDCX                   4
+#define TDH_MEM_PAGE_AUG               6
 #define TDH_MNG_KEY_CONFIG             8
 #define TDH_MNG_CREATE                 9
 #define TDH_MNG_RD                     11



