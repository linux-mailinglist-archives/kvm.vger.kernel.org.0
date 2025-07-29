Return-Path: <kvm+bounces-53630-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BE66B14BD2
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 12:00:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 50217168C3A
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 10:00:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 982A3288514;
	Tue, 29 Jul 2025 10:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NE0MuOIg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A325C133;
	Tue, 29 Jul 2025 10:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753783246; cv=fail; b=eq0mA8ENfu7yLdZ16luKdgpzxe5aX9Wkc4e2PkDDJzPMajCO+d/rMEUtooEdFK5niegSqDtfhj3wto8jIJ4g9T1wKuplaBi0KgIglDAAtEBlSzpAMAw31A5BXLgD9uBqpXl4eKhgc2Xms2Z3QoQ3txZ1694BaBwSfcW+GYZ/T2E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753783246; c=relaxed/simple;
	bh=VSmreJyWm39cwZv2wI1Lo8i7vR4HrzXxLZUKNDmHbTU=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=dKXVoEwB8H235FqGykiT3YcUm8IdPLR8YarO47XI2L0IL43i2If7uHIA+RJz3wq061BybuN/0CnE75kdyn1u4i6Hp59dK4Vdl+ogzxRLpMxgQ3FsTUvg3T84geWGP9xeaxzKemH+dyeYUpdY1AbT1kCEH5E/gV6leZ6tfnWVxwc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NE0MuOIg; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753783245; x=1785319245;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=VSmreJyWm39cwZv2wI1Lo8i7vR4HrzXxLZUKNDmHbTU=;
  b=NE0MuOIgh/eYdd2dsYuSTq093jC/jZxEvqYV2h2TuckrvyWNq0Czw6WO
   BSo/cLfBHW+lzCFVgj3DlGi2dr7HGQUZRdaULdq+J8pTYHnXa7nFcAdeW
   vlU+iIlOiBxCdi/QFjuKVIbD6uB+NX8mXh1NERZRX2V02jmfPNx2WSgII
   4ANQaMrEK0J0fXNnjLCA5gWPFFLa8Jc3Ydf+12XudjLzNsp1y9ukyWpuP
   Ryd58Gye07hSyJiMhq8bpWS35gMyBv6zcAx3UXhxeiBlsZDRa9694ABPQ
   GOvGUwk4nVLT+qRQrerKLHVObX0RsNWgfCngCjTlqTzjzypaOQ2gektPW
   A==;
X-CSE-ConnectionGUID: Z4bH+Y2STQ2HB+rwVgJpHg==
X-CSE-MsgGUID: 7wd9OhILQXOXxTyc1PI6kw==
X-IronPort-AV: E=McAfee;i="6800,10657,11505"; a="67401301"
X-IronPort-AV: E=Sophos;i="6.16,348,1744095600"; 
   d="scan'208";a="67401301"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2025 03:00:39 -0700
X-CSE-ConnectionGUID: ZjdAur+QSjyIklqhQBC3/A==
X-CSE-MsgGUID: W5upuoXiQyiXtZb79qmFEA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,348,1744095600"; 
   d="scan'208";a="161924977"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2025 03:00:38 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Tue, 29 Jul 2025 03:00:37 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Tue, 29 Jul 2025 03:00:37 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.73)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Tue, 29 Jul 2025 03:00:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Vcx9IXRHfLUqb8w1O+WtdkXPHwW6ye/tyQs2WgdPqbg111oZ8HNjMll7eTT75v2/R9CcDZZHyN6XTzNxgDYL7CAB1FAYtQUsaLwk0gM8mCtrTgYt9FCNCvYT+WVBJ8Xag0NzGfcLzp9xkQClp4VJKhiZkrW1Jb5PkXo/1fkU05ELQCrIdK+0AciaIlE7qlDlinWUkjwH8GTi0CiFbAulJY7JiFzLF2eQ7G47nIL9NmzqKPgd7BWpmtlWq3w3Lj6grpykbjaATAeB/xMWrtyGi2cs5cttgdGGhV2QaP5419gP3i4mg5VJZmPSuLVHgMcBVHXUUgrbxyEx4BqmPOHjiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GqHUpUNQRZ0rNV1OgfdE4hKBcuCD3A90m2A2mnJKwjE=;
 b=rQL6UsupVIcNpUv3NuCLoB8YN1tCSocHtn5UPyPjvf1JKrFX3GP7DPhlPqr6mSqDbv4Z09eO7V3ml2GFKIPxx9X/+HeRb4reZ9o1TnlCARRvFFwyrb0E0aiJIcJtrR0GfONQflO3DVb3Kwpls+bi9VsaKGbpg+pqLyYrqoMf0/sahUqLLrKCtcpKbKL1Li+T25m5nBSHJKdMn+DjgpjnLy9gdcKgS9plpnrTOU+9NIDvCmD1F7OmEeMfIZxJr3JL8whvHq0Vu2pTn6FNJxlnquGuFpd+3w1abJzXVynl7RMkX7oLXmvSsHzyvnzIoO/ZD3YZCqEDUEONoFBuwMK1Vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by PH3PPF310D5CFFC.namprd11.prod.outlook.com (2603:10b6:518:1::d14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.23; Tue, 29 Jul
 2025 10:00:33 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.8964.026; Tue, 29 Jul 2025
 10:00:32 +0000
Date: Tue, 29 Jul 2025 18:00:16 +0800
From: Chao Gao <chao.gao@intel.com>
To: Xu Yilun <yilun.xu@linux.intel.com>
CC: <linux-coco@lists.linux.dev>, <x86@kernel.org>, <kvm@vger.kernel.org>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <eddie.dong@intel.com>,
	<kirill.shutemov@intel.com>, <dave.hansen@intel.com>,
	<dan.j.williams@intel.com>, <kai.huang@intel.com>,
	<isaku.yamahata@intel.com>, <elena.reshetova@intel.com>,
	<rick.p.edgecombe@intel.com>, Farrah Chen <farrah.chen@intel.com>, "Kirill A.
 Shutemov" <kirill.shutemov@linux.intel.com>, Dave Hansen
	<dave.hansen@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, "Ingo
 Molnar" <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin"
	<hpa@zytor.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 07/20] x86/virt/tdx: Expose SEAMLDR information via
 sysfs
Message-ID: <aIibsLNEBdK1I6pv@intel.com>
References: <20250523095322.88774-1-chao.gao@intel.com>
 <20250523095322.88774-8-chao.gao@intel.com>
 <aIhUVyJVQ+rhRB4r@yilunxu-OptiPlex-7050>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aIhUVyJVQ+rhRB4r@yilunxu-OptiPlex-7050>
X-ClientProxiedBy: SI1PR02CA0053.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::8) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|PH3PPF310D5CFFC:EE_
X-MS-Office365-Filtering-Correlation-Id: 74cb2de4-d5c0-442f-eda7-08ddce86c0e4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|7416014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?BS5SxmclCOKKfWbZ/Bz4OaO1fdR0eFEnbBz947ZDujq/Qc/u9ZbJoP6nbgil?=
 =?us-ascii?Q?2dI2ebsy7wo4nWeap3ltcwrzl9oqGGw0e7fKtTgrqQq5anYJcMUsKEVzOx/N?=
 =?us-ascii?Q?Wu+A5XggZXiiX8N1RFjO1CT2IktcImv7oD88M85OZ4gLIiZYJHIFApOP4+3T?=
 =?us-ascii?Q?dSJM6CK7hSlbuIikBhySzcR5x+ybDT4Kl3uMmb14yytsJObhoRW0NjVGKvG7?=
 =?us-ascii?Q?J1zUDbGgAqCfPqKNsc204DaSRIrl3/BfpCL0gj0iSWziULvPuhl8IvUbQ9nW?=
 =?us-ascii?Q?Afk2AHXmp6h25nXSI6TtmljUTR6vPx3Wo3A1GDCmA8dvjzOEkuDXdrRLk9ik?=
 =?us-ascii?Q?Tx9+T7PkmHtM4QT2wLMxasgIqAocNm8K07DNzjOnl6Hq+NRnsyIWKeNdaAPc?=
 =?us-ascii?Q?IQLFeexZT3DYJdrVsMNBks5+Zx4ivxBGl3MzSj8NPgAVvNQuspNsWWayA1O0?=
 =?us-ascii?Q?JnsNPNEEqf1W+Zf2ygh+Z4POQP1K8SxrvuRVlws84fxFuk9zBg67NpkFrXj/?=
 =?us-ascii?Q?60R3IQhJXUwDsIv0oWgLc08LFD+yc9bZIUPkeoffb7QFoDJwfD+vFttQLon+?=
 =?us-ascii?Q?OBnSjU/bLiHEQfApbdhDy65MeJ0qqR4g2aJhmfZ4f+a8wbXPY2rj0Vh7Uz/P?=
 =?us-ascii?Q?sdHkM7KFHBCTiw8k9G+38kYf9CO7rNoxrxm6i0qlJ27L7jAQSfpWWhRzJATR?=
 =?us-ascii?Q?RnDklF3zvW5EteBiIYhYUyBNBlUjp4Re4upIP9+/TnTYJrgsawhUqPPThXND?=
 =?us-ascii?Q?L0OKq7r2ECXGSD6pMg6g4oSRHFQa+Xk+c1sA9KjOetzqzxkrxeNLkLZOiNhu?=
 =?us-ascii?Q?Q+gAr43kHa+83TMtObNR48eqamVNyTeYYV0iDqbQ5llnVeqIPUma4ewg/5XQ?=
 =?us-ascii?Q?/YI/SIZ2C1SzhtXhFmX3Td6oH0PdXrqdbH+Qy65uSA1Xk0akD/2cB3Gkwf42?=
 =?us-ascii?Q?o0xZrzvY/R4cpW0NT/r2Z5sFYzcuBimcwxTc6nOriQBWH1TE3llCmNZj8r5l?=
 =?us-ascii?Q?wMqzmz2E5/u7JoqH7k9ZPMCtLDqMH8HwA2OfnM6AhjfRizuT9PUG8VuKdzzY?=
 =?us-ascii?Q?ZMMyNRjTonAwJJ8qVzhuwwT1yVCQRpaq6B78OUcLeKUVylM8+e/b9Hh2FcN9?=
 =?us-ascii?Q?BYzGkP8GVPVUOVkIy4B4+nKKOvajd7CC31Zv5seh5weq/wqTbejYmIFd9uTO?=
 =?us-ascii?Q?mj6gEJ2b2ULDFVFikQTmEWt3tHTnwuQYxakcnUFTKldpCPjKKMTTx1/07VGC?=
 =?us-ascii?Q?CeaSlzTZpnvMsfLYh9NzJa9+DVoMAIYoDo+cPA42QPMDLQLl/e8Wkdz0pjDz?=
 =?us-ascii?Q?mTa0kk9JJw+03CC2KD27Aw+WpTCUpKv2u+88ZYTDA6cqgUnwoCpQ7uYhD1qg?=
 =?us-ascii?Q?ryKTAdCmCeTv+mns9SzyIeZCyWv8OCi5sjaF9SaP6/J4fllPHGLSBPcI0h3x?=
 =?us-ascii?Q?qZQ8ENW3HuQ=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?abAdYVi18P0BKR9vIVAnZQLDkxFm24ktYxRkJsnAQrROdTcp060Otg99xOmI?=
 =?us-ascii?Q?+WhgNnIQ0TW06DBC/g3veQVLs8CfIXvIBQT/WmVspr3pzpUvli8taDZ2ahfj?=
 =?us-ascii?Q?BdFPphluIDhocHLHlh9T7SmBgtKTJcmdcM0llvK4vRGGdq6P8E3Ecj+iEi/5?=
 =?us-ascii?Q?mVEAe0NOzkHhI8RrfP3A4uz1ZjzeMy60ydBSAb+ZUh3ziSyDwWvd+ozoiaP5?=
 =?us-ascii?Q?p3VF620v5NUdD8S04Bv5+7WcD3P6YhYzts0rgEGiHwnhmLOkv19wBoSA3Ww0?=
 =?us-ascii?Q?C6qd1ufd1W/osDnAUPuIilgvsSnjU1268eOAl4I/2sqYKU3K3Rxbi4Vzf7nx?=
 =?us-ascii?Q?6bSZi45lNgI2qNyF2MuZRvbF4vZX+Fa7O7E/su22uTjwNLak0U5gXONbG1PD?=
 =?us-ascii?Q?a2Avh6ZNqOGTSdF+qP9an0mT2wI7CmZbaGOk9CE2ifhhjBetprYe70UZy2sG?=
 =?us-ascii?Q?Eal/XE6WGMSPcLirji2Ck5DRpm8ySmWQ2cuc4BMUqjegCBWALTBMSAIPCTqv?=
 =?us-ascii?Q?ZldWmprp4J/YrIdjZJcDFevr+jx8prvn7/2w84phGGho48VeiGxk64aESArJ?=
 =?us-ascii?Q?OzRoQiMIfEQ1SQJLaV3HUXGIYx5Q0ChRJ/j3G9BUrHhHGdakIKVHHGlgi1XJ?=
 =?us-ascii?Q?cApcYV3TNquqfceFg4wohreutGdMDu5i+b3u4SULlscr11UCSScl0cpWM12a?=
 =?us-ascii?Q?6dgR3nFvhi/b65BhfhTP27CTfyUXL7WO+UuVeUXZc8B2F/ztmJ3DeeL8xKzK?=
 =?us-ascii?Q?U6BtIM8+WNNTaA68L4Vi4V9STjeW9iRo2wmzxHqcFuJqOTWzChlEhx3cGg4/?=
 =?us-ascii?Q?qmgrSkDybstewkK+kV55TMU73Ksbq8UEgrcKb8Owx4HfO0SCFR27i6XVwxEo?=
 =?us-ascii?Q?eC51eGvXQ0ra1qN7cCAemf7jcGaiSwXmAW6TYdHrxUBEUV+lgio4NIO9B+Ti?=
 =?us-ascii?Q?Lu+bvsduwtwFkiRuml4jG4Kc1nGiwjEKrVGpJz93iHiasX8Pj85Hubx3zRk7?=
 =?us-ascii?Q?4TNSr4joiOnhYDxrHJMGMh8TpgikyrMEnFlLYjN+kPgaaW8CGJ7WeP6ut225?=
 =?us-ascii?Q?wIWNi5f7D2WhnZCsmZhGIc64SnU3zLXwPcuQdGd5WA4lVGJp5U+c5MX/PgSv?=
 =?us-ascii?Q?lE69WIEh/vM2MHQXm2/wsFtvIuOXpOHfhYNWz/ha+PRESaaCpnyImMOcjGBz?=
 =?us-ascii?Q?pwpdY02SR7igV3249ZYngNkCkF/9pVn9cK3emKLtj3+o6gWk14GJq/T1czlB?=
 =?us-ascii?Q?SAvdrzZY9h0pwoT6CdMnEv198889ZMfsaOCNil7B+9qZXpWr0SrQ52eSYPaN?=
 =?us-ascii?Q?gRIuaTV0LAtjCpgcdwmDtX358EA3FBr8aA05OJwP0U5V94CAjEdYDlkFU35k?=
 =?us-ascii?Q?CzBE7azfFic6yQlMZst2xP7WUJU0G3RWT9shcQoYdFSEVtWYnWts65XzJtgo?=
 =?us-ascii?Q?+nxO02GseNRdZxbRCSt8+GJeu42TwIG+ACG1X7EJZ8ZdLl+Sv5aYNVnygetE?=
 =?us-ascii?Q?gEDoQJkf2Z3qrg8gNhzgNSPsVTa0DX3niHqmGQ4ms7n2ZgzTTiMFeOW8Vu4s?=
 =?us-ascii?Q?RGWUWD8jBJU+oEsfLlAvNFYRqaHUyiGeyuPHpqQL?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 74cb2de4-d5c0-442f-eda7-08ddce86c0e4
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2025 10:00:32.4757
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yhwF5NeMPRFiXxLQFrqw2UbEf71uGhrdcUdKNWdBjlFj+F/wn400BPWdAkpBYC2hPPTRHbQRE8K7m8LokXtcQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF310D5CFFC
X-OriginatorOrg: intel.com

>As mentioned, TDX Connect also uses this virtual TSM device. And I tend
>to extend it to TDX guest, also make the guest TSM management run on
>the virtual device which represents the TDG calls and TDG_VP_VM calls.
>
>So I'm considering extract the common part of tdx_subsys_init() out of
>TDX host and into a separate file, e.g.
>
>---
>
>+source "drivers/virt/coco/tdx-tsm/Kconfig"
>+
> config TSM
>        bool
>diff --git a/drivers/virt/coco/Makefile b/drivers/virt/coco/Makefile
>index c0c3733be165..a54d3cb5b4e9 100644
>--- a/drivers/virt/coco/Makefile
>+++ b/drivers/virt/coco/Makefile
>@@ -10,3 +10,4 @@ obj-$(CONFIG_INTEL_TDX_GUEST) += tdx-guest/
> obj-$(CONFIG_ARM_CCA_GUEST)    += arm-cca-guest/
> obj-$(CONFIG_TSM)              += tsm-core.o
> obj-$(CONFIG_TSM_GUEST)                += guest/
>+obj-y                          += tdx-tsm/
>diff --git a/drivers/virt/coco/tdx-tsm/Kconfig b/drivers/virt/coco/tdx-tsm/Kconfig
>new file mode 100644
>index 000000000000..768175f8bb2c
>--- /dev/null
>+++ b/drivers/virt/coco/tdx-tsm/Kconfig
>@@ -0,0 +1,2 @@
>+config TDX_TSM_BUS
>+       bool
>diff --git a/drivers/virt/coco/tdx-tsm/Makefile b/drivers/virt/coco/tdx-tsm/Makefile
>new file mode 100644
>index 000000000000..09f0ac08988a
>--- /dev/null
>+++ b/drivers/virt/coco/tdx-tsm/Makefile
>@@ -0,0 +1 @@
>+obj-$(CONFIG_TDX_TSM_BUS) += tdx-tsm-bus.o
>
>---
>
>And put the tdx_subsys_init() in tdx-tsm-bus.c. We need to move host
>specific initializations out of tdx_subsys_init(), e.g. seamldr_group &
>seamldr fw upload.

Sounds good. I assume you'll update the TDX TSM framework patch* directly.
Please share the updated patch once it's ready, and I'll take care of all the
seamldr stuff.

[*]: https://lore.kernel.org/kvm/20250523095322.88774-5-chao.gao@intel.com/

