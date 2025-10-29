Return-Path: <kvm+bounces-61376-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 91A53C1843F
	for <lists+kvm@lfdr.de>; Wed, 29 Oct 2025 05:58:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 834194EABC6
	for <lists+kvm@lfdr.de>; Wed, 29 Oct 2025 04:58:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB8852F60DB;
	Wed, 29 Oct 2025 04:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VQZSX9rX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B9FA2E8B80
	for <kvm@vger.kernel.org>; Wed, 29 Oct 2025 04:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761713915; cv=fail; b=aJ0ykfryOObZAn4SKHRQXd6+x4Dpce9S60U3sgujKKnDiiZ6WDIU24U73p1i5QNMErWkR+I/NiK0ztL0+a2lVkTt5NkBR4VlTvBrubYjXQyFcOk0TvpyRTM5sVgjOVs/2CQREbh5ZJrHbMoe2ZdyXkVuJmv3+V9wiHxJbgjBnl0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761713915; c=relaxed/simple;
	bh=i5zCoXm44eHtu03+F9JqTs8Bzj7BvFUUiY5mxaDPGrc=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=pvOvZLIIreBfILp+exma1VJS9DSwV1ANHeUi0C6QKFhChUhHLDxFMnciM9loLmBd8ZKnj4/iM+UyIA4p710Z7ftiWHJYfnIow9QUna0+bDmYrhWyK8aiipT2wjyHsEbjzwKIy/ontch2yLXOKcufmwa0OP/hI8/0GTVURpf7irA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VQZSX9rX; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761713914; x=1793249914;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=i5zCoXm44eHtu03+F9JqTs8Bzj7BvFUUiY5mxaDPGrc=;
  b=VQZSX9rXP0ghYoMlc4rw1vt+a2SkultwgdJhLbsqG3dCRfgjAh4iwYUp
   MjS7gbiymli4mKXsgvEbmD5ApYPrZ1mUkCXPdBig25FA7f5BKYaNpt+VJ
   tuh12JMFCSttNcMczJq0HIVIlLcoCg35vYhmcam6TlKC7UA4DdE0qrYyx
   QckA7X7lKspPGlSVNoDbEJPegF9H6vEgCZr/Lxae/nUbPlJf7u6qcrMuS
   1M8wPf0fYP61hRBei9m8GU5bSZv4ywSfjlrQvSmQONnCaSIL1H19NBixN
   sn1/zgv0+d4PEy/LzIJs5oUeFwQC/snl2w/m09jFCHkZGmMB+k0pze0kx
   Q==;
X-CSE-ConnectionGUID: j1/6+F54SQaa/Am56cnhqg==
X-CSE-MsgGUID: 3RkM8wTTRhqPXXO0/ErjtQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="75272733"
X-IronPort-AV: E=Sophos;i="6.19,263,1754982000"; 
   d="scan'208";a="75272733"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2025 21:58:34 -0700
X-CSE-ConnectionGUID: oaOm2BY6T5qPnjzfHOfdbg==
X-CSE-MsgGUID: m2cO+z2zSBivsh24gxGKyA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,263,1754982000"; 
   d="scan'208";a="184738798"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2025 21:58:34 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 28 Oct 2025 21:58:33 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 28 Oct 2025 21:58:33 -0700
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.66) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 28 Oct 2025 21:58:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kkChvl4YdRZtbzw8YZ3ygLP8QVzDzHijAgTEiKFF6Xh8MmJ2hTCoJ09eER5iA/ngRqaCxfsArUfE6IYLwMgt/oDgvb1HLn1kg+zXDk9IQHy+QdiqbD5aZt0SzM071vgUz1laG6O2RvAH4kN+z/htG9HBOgN9vKOFgz/A+RTPSfuR70zbSXCALNakXzgBzf8f523RS6Xuo26qSpgLUO3i31qyMRXk5SVBWaytTfCpOzXV/+UcHgs/4YRJCgcJy2KfeUXEOE57cjfNU7m6p9GoEHZJ7rFcbIaXPJp0pXPMgZZgbO3dRgxAEbiD1uQaYL40R8CKSiyKCsUJpZmJ/L0nug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i5zCoXm44eHtu03+F9JqTs8Bzj7BvFUUiY5mxaDPGrc=;
 b=vwgfoqPxzKHRlAeBGFm7QwMYdklxNo6LC4WBrL986NPf6bDACpO/kONpucJTaOCh87znmwrQJngsUqXiBej6EJjel0LQKGJYiFBn0N+WwdzDaiFFOPHNpJhdGofxncB+1iu9LUKr3wzzM0sinV2ISFCfCp6vgRSJa7Y2niisJQkShlJRDsJyZqdnsNg8kmqjbSI0B0OxScCyyTYtMCqkgD4mgJxr3LCJ/KsJZHmHynWhRrnkEdnbOcXn/UfADgtxVKPsSlSCSFSVxfXlLH7zia4iRtpc/FiCrMczZF3959NqIPTHSP7Qwq9e6xh6oK+qPLhmlQfvq69pfElde1ktSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SJ0PR11MB5149.namprd11.prod.outlook.com (2603:10b6:a03:2d1::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.12; Wed, 29 Oct
 2025 04:58:31 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.9275.011; Wed, 29 Oct 2025
 04:58:31 +0000
Date: Wed, 29 Oct 2025 12:58:19 +0800
From: Chao Gao <chao.gao@intel.com>
To: Zhao Liu <zhao1.liu@intel.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti
	<mtosatti@redhat.com>, <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, "John
 Allen" <john.allen@amd.com>, Babu Moger <babu.moger@amd.com>, Mathias Krause
	<minipli@grsecurity.net>, Dapeng Mi <dapeng1.mi@intel.com>, Zide Chen
	<zide.chen@intel.com>, Chenyi Qiang <chenyi.qiang@intel.com>, Xiaoyao Li
	<xiaoyao.li@intel.com>, Farrah Chen <farrah.chen@intel.com>, Yang Weijiang
	<weijiang.yang@intel.com>
Subject: Re: [PATCH v3 11/20] i386/cpu: Enable xsave support for CET states
Message-ID: <aQGe66NsIm7AglKb@intel.com>
References: <20251024065632.1448606-1-zhao1.liu@intel.com>
 <20251024065632.1448606-12-zhao1.liu@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251024065632.1448606-12-zhao1.liu@intel.com>
X-ClientProxiedBy: KL1PR01CA0146.apcprd01.prod.exchangelabs.com
 (2603:1096:820:149::9) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SJ0PR11MB5149:EE_
X-MS-Office365-Filtering-Correlation-Id: f664d4fe-9aad-49f3-aae5-08de16a7ce16
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?6vZHBofJh1+8s3oAWNNSwKj9uSifp2hfpeQ/N9eBidXN0VzkSgyNR6YL22y+?=
 =?us-ascii?Q?fzR4BQwNbfYXbempDH4SNZjMxHlK7KJFvyd5F17Qemfj5B+0w6o4oJlan9vH?=
 =?us-ascii?Q?KfvS0oPXFHVTTzHLlHg/t/idm5jnP1CeRfzLQcHKFkr4EOnTDXPL+0+fbhOu?=
 =?us-ascii?Q?9CoTOdsBuDhVOnAKwrJrcVxa7CpUWOTi1hCDejp43anOG5Y3hrBu9Hsd0FLb?=
 =?us-ascii?Q?AxnD7cgIHt4OGFIlnmYrbdqCV2DHVUsMFN7cRLKwGtruA8XfBc0uARUjGXni?=
 =?us-ascii?Q?fE4uORQj95hgqdaQ5CFSF7lee/1u6IRgkEzZerhT4LVYsUOST7q0Y0BeKNPY?=
 =?us-ascii?Q?QCfFofYEVN22WmYLDoOjje/zOdjiYhCdhjhlA32JojoDnBQ60X6bhainbqMr?=
 =?us-ascii?Q?oDqkdicXNrZtKe7rfbBAvVyPWS3upPFycbhx0sPA4obiab33AwBwsdgBY3wT?=
 =?us-ascii?Q?/SuCBuhaMAvFjcDRJdQ2HiVPmdtMEao4Ls3mweyO4t7izMdkfUHgTEKX+12j?=
 =?us-ascii?Q?EA3UADZC+VfOrFh9rjJ75zNZHhs/lov/34SG3suR/pLrNZyGNm0+0fltxp0J?=
 =?us-ascii?Q?I9yTYAtyCnC5hJwYwNZibAtDE26b8oHQOtUhvEJJUPa/2xsAGyRf7ZevSDld?=
 =?us-ascii?Q?yt8pEpOo5QEVxIAC23HHn56JTSaiebMOJu680wwPR3sJoiv4aO3XUJCr4kpz?=
 =?us-ascii?Q?z1lAR8joz/+lJsZQmwAbsvijBTYRgWdDij2BMPkVYk4di2qkrA3zYg9Q9ztI?=
 =?us-ascii?Q?ik48rVCbj7DKZ+J3TNoUkspz9CyrixxyO1YvVcVT0kH9VpeotpM7ikFMAAPq?=
 =?us-ascii?Q?jc8VyXPW4pGjy7O1meekfmaTHsrluGaPZ2Uq+83DCAuOB5bjmXUTr864CBsQ?=
 =?us-ascii?Q?KTAxki+kT2X6iQTR12LnHrLjYqlaQVhndYFI/nEe9OlyBoy+/45RfkEqKc9u?=
 =?us-ascii?Q?5/H8m4H1idoCsUt5LtU2ltbOn9iKhCURwIyiL0iLxWZfJCsTYiHpOhAxmWTz?=
 =?us-ascii?Q?w9au9qG2/mHG1DvjiWETpzoI0/EQi2vIObBTTWwN1bGRjCbd6Fs9EuruqbGG?=
 =?us-ascii?Q?97ZsLxw5LPDbK6GUi3Mc+zEtr7LeXOBWGD87Q9taTAYfe51SkzD87LbtHJC7?=
 =?us-ascii?Q?wvp3t05jvqFO6Nw1Xmmd26sNRaJ9CXs3ZPAGk3LfAEiHmxa+M1hKdQtlvy8W?=
 =?us-ascii?Q?sa07joZ1Viqi0+9152nSK8gfbON3FVPkl+KshMSZRVE+s2P4F1MasURcYDaK?=
 =?us-ascii?Q?J7S9WMUaiekOJO/P4FiI6MjhvqXriGwoC4Ss5MtUqYUvRlJBNmeiZhGgEusG?=
 =?us-ascii?Q?XD0fPfWPqWHuOEiP0zzTA+yBsBl1MSdWX8exLsk+AL4a65rmlnWqHTfYxIKZ?=
 =?us-ascii?Q?R1UNNhtn2LJsbPW3/2KLPy2BuSDUsHBpwt7qi3ZE9TxMxPsfuMsHYa2jGiOK?=
 =?us-ascii?Q?nDO6SIRtmgRUePMkUV0H5ryCQ35iZgff?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ysNfcA7uKbJmpCLI2FutDkJgyWf9XOCSubJKzb8ELZO2Q3yF/MKn4MpJxJ1h?=
 =?us-ascii?Q?AEP0kPEXXz5gveqZsifLt8AhkaN1fN6AM1dae1vT2AilwWJkki7wBrNbAefp?=
 =?us-ascii?Q?N1YowJS0MP/PAds7OQ6mgTp910pPmwalT4tHj6UQsUUTqpT4bbm44KOUdUZ5?=
 =?us-ascii?Q?CebJe9z12kqRJCH9+0SmB7ZIC5NqFQv3hKXuWYMMykbYN6Uq7UYqnUSKtJr+?=
 =?us-ascii?Q?9qwdkOUfbEdhNIrgLHRmf4nik3SX9T3/6x6Gn7UlQOteJOeh+q55KFj01Unk?=
 =?us-ascii?Q?fKch7LGruy3fYbuaIsTjBsSmjZitrc8Bbdf+ig5vb2yylkU1DpMZ9UCY6Yzx?=
 =?us-ascii?Q?jzwQMF1VWMaPguNhmijElz8GARWDoWArJvThQgEBfQeEKj5mWycAkVB1e48Q?=
 =?us-ascii?Q?qLT/6YG53M/o5yw9hEaUF8arML/lOc8J5h2WSbMHpKYJXz7M1S0uGgY8Lua5?=
 =?us-ascii?Q?yK+Cd97kRG8rOS1gVjKXLLwGwnimyk9CSbHHfbpbmal1M0q08PmnfmSUmNgp?=
 =?us-ascii?Q?5UpF1UZepQOMhFpOpCIcZh+hUlDPjFoITu/MYlyrplcpqEX7KRuL/1p3TRfq?=
 =?us-ascii?Q?f8pIzRxQnmVVqpzXPtGqFfgbNXh7VGLBdbkHEh1W93dg2nmEAzfV9Qu4r1Ip?=
 =?us-ascii?Q?4T+l22SqlT+MMIoDLSSt6wZYrXfUqWjejeqNtNriBtwR09AjSHWFcrkTKxC3?=
 =?us-ascii?Q?3gYBQ7XmDOo0qpBQvbfdg/duudbqPr0+1Y7tli2ezz9StiT9GIKQ1aVo78kH?=
 =?us-ascii?Q?H49mtAHaaYqVwzElpZ93Wh0X0ljVCgCffjVYGpL5Jcjne1rbT1Bt4mZ5UTys?=
 =?us-ascii?Q?f0q222+3ZhmEiPnkHPVY190cXSwMuSMGuz5s4JFw/wCv7o4x2uvIgzxSRjo1?=
 =?us-ascii?Q?4Al5cSqSQQFHgb4zC+VaU6CovF8MMPE0OoQ8CxdY/YVTUhPr+0dtpdIFBBCY?=
 =?us-ascii?Q?LrVgts+eJAYYAK54e9f7ExL53t2A0sncOCcZakMIgT1g+nzWudXrA9QVM/L0?=
 =?us-ascii?Q?h19rr8yOJanlUEGmrv6uJZxqTV7CxZ4wsJPcOXk8HpLrUrhd/Drf7DJbgzVP?=
 =?us-ascii?Q?fLlknVqxK0BCDCLwtvkUHEbcX2dHcSFxoZDE0Pr91QwxOFEVRqcn/62e48+B?=
 =?us-ascii?Q?MWmI/S/wLreh6Dbf/yJn+iWsZkPEFg04yxZL+Lly2Kg7c+fe5TEhEUJ63J6D?=
 =?us-ascii?Q?ldzCe3LSbRkZ3PmkLzxF8qFJYKC3BrX0/5zLC12YqF0r2NWkL8d61QaHhwWW?=
 =?us-ascii?Q?333Q1Xf6eFpUUOjvtltcEEZCV37Uo7HNldfRfviHFar8r5G1OR+bUiVJ4rN2?=
 =?us-ascii?Q?ZBDjWj6s8EklOMz0V9FZp/OR7Ke1+WltY9QUDItD/ZCXtN5SM02dMuLWV36Z?=
 =?us-ascii?Q?e9VK2clohansZs4VnPYPCcfzLxosxm1J7kXbHycwgad4lA3YmTjZVlMMf6lK?=
 =?us-ascii?Q?4CaU0xdJy7hXdZTu32yyeCfYPEo0rwVBHekAdenj9yGVSZFU6As0wJyMgutK?=
 =?us-ascii?Q?HjsgMLLqyYFyP2FMUyEwYvAi9OtDQf46fXeHSMDCp28KNYH/nadATkyJc6P/?=
 =?us-ascii?Q?9vXwk+JiFGUdKlLgikLy+/ssOwwKgdajHqSyzpbQ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f664d4fe-9aad-49f3-aae5-08de16a7ce16
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2025 04:58:30.9616
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7QZor1GUqnJm7k2050BkVuPihtvVrMt/nWRs0+V+QPNtDJlvimJzkmHY24pwU2I9pt/1wkrEGkHjZgCJHcCwOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5149
X-OriginatorOrg: intel.com

On Fri, Oct 24, 2025 at 02:56:23PM +0800, Zhao Liu wrote:
>From: Yang Weijiang <weijiang.yang@intel.com>
>
>Add CET_U/S bits in xstate area and report support in xstate
>feature mask.
>MSR_XSS[bit 11] corresponds to CET user mode states.
>MSR_XSS[bit 12] corresponds to CET supervisor mode states.
>
>CET Shadow Stack(SHSTK) and Indirect Branch Tracking(IBT) features
>are enumerated via CPUID.(EAX=07H,ECX=0H):ECX[7] and EDX[20]
>respectively, two features share the same state bits in XSS, so
>if either of the features is enabled, set CET_U and CET_S bits
>together.
>
>Tested-by: Farrah Chen <farrah.chen@intel.com>
>Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>Co-developed-by: Chao Gao <chao.gao@intel.com>
>Signed-off-by: Chao Gao <chao.gao@intel.com>
>Co-developed-by: Zhao Liu <zhao1.liu@intel.com>
>Signed-off-by: Zhao Liu <zhao1.liu@intel.com>

It just occurred to me that KVM_GET/SET_XSAVE don't save/restore supervisor
states. Supervisor states need to be saved/restored via MSR APIs. So, there
is no need to add supervisor states (including ARCH_LBR states) to
x86_ext_save_areas[].

