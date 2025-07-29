Return-Path: <kvm+bounces-53592-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 58310B145BF
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 03:31:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 938043A31B3
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 01:30:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D0EF1F3D58;
	Tue, 29 Jul 2025 01:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PZJfzTBa"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9C6F1428E7;
	Tue, 29 Jul 2025 01:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753752649; cv=fail; b=CD8l4eyw43qDflO16rDlZ6BpdOyG49eK24ycWDL8BDMAIg/B5mjdQHh4q/6Jx0PlkCvIoDmSeC6VXq1FxOCZ5YFUsfxAyw2Dh7G+GzaG8N/b7tj6j5vxQcAScZVviI0mDkamOXAjHi5scFdQZ7LNEj5VTODudLmQ9jqWf3nxrZ4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753752649; c=relaxed/simple;
	bh=b0G+/jIL0goKyojLacDt1yPhSznFs8teMZRGwrovFJ8=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=f3n8hTQI9SFFFCvR8PQKBhIloWSzwsUvSB+Rg9B+StYF4Sf7i7LDXZCdWxgzOTiHiHAF6xccRn9gCSAmX7Eoibmz54SXKpT41/kcKkq1NQgbEpR8OtERXi43k+CrjbuigU6ae0OL+nVr4axUs8d6yLTSpb368aAzCNpnjCX0GK4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PZJfzTBa; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753752648; x=1785288648;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=b0G+/jIL0goKyojLacDt1yPhSznFs8teMZRGwrovFJ8=;
  b=PZJfzTBaDVhbWJ1cL/HdEVeBhpToSGU/9deQw3VV/f7NMBtgc4C2/RQY
   JIJVeg7Mzvb/KjjWkJcxe/dJSgxM7GVRoXiEiCwbA39/mCoTmwiRfMWS1
   0tT9sl41uVcLoS+76fDRv4c26OHbi0o2NS3FHoDYZhwwaGlG+h/00eytr
   KUnKNu423Ko2BROquqtoxmWUerTfKXGgUSHYOIS5jfhr+ikoh4+AXgPe/
   t4tEEwnU8gqyyKCLwpNiJqhEycBkmPluRu0loDJJFz7wMgq2euoYbuxwe
   fAmmMMUvibP7w50ixU9Vru0G5GtMCd8NakU0hhLHdtVY5Mrsc+rrvhN0A
   Q==;
X-CSE-ConnectionGUID: cZVjGKYKQdeJ8vSPB/PRJQ==
X-CSE-MsgGUID: Brv/4UlSRN64CcxJB1+bUA==
X-IronPort-AV: E=McAfee;i="6800,10657,11505"; a="73459714"
X-IronPort-AV: E=Sophos;i="6.16,348,1744095600"; 
   d="scan'208";a="73459714"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2025 18:30:47 -0700
X-CSE-ConnectionGUID: cC+SPfJSRg24Od5uu8YCAQ==
X-CSE-MsgGUID: RNwBXFljQ8ao6H+UKfyTtg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,348,1744095600"; 
   d="scan'208";a="162437603"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2025 18:30:47 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 28 Jul 2025 18:30:46 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Mon, 28 Jul 2025 18:30:46 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (40.107.100.57)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 28 Jul 2025 18:30:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v8A7S/Xi3EnWvFj7VPo0mGqRBcxuFFsxYN59H/mywodVb98OTM1AgqcPudoyz6V4y2/VI3cqTFDEg6YWvFnjngqugEEAATNvxIxFGQ8v/gYeyPjyhjMu3zC22MAQKXRybv3zSgb9WDMdv/IVMbYFwn3te20XB6CcscnHPebG59gARzjTGwEn1TijpDQ6MuWls+zVsFh4s1BfZCzhJmQ5y+hDxSMgNscpYEZyLwBUts5hWP45R8dLx4KfVa6QhsN1joM+nxk42Chgm5AI2oopMP5Ir2ZbpRFYXCgmmK61hBlWNeDE2DQqZRkvtAz0Udf6xDT4bnLhDs65WoSqCfIh4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9ZFB12aKdrcgJBGqHsMXeG/qkdU7ZM6cjDbcsAHtdNo=;
 b=kkpdEtcmBsG++XErehseXDmTK5DZf50OUBLwNywDyH/ey1hbkVaamdXen1a5MFHsizUk9yExzh9UdCozgE0gXchG1rf0nE548pGaPDEGbcPDSJyDW/olRt8FtonXYnIdrp6hGbP4U6MIs+QexV2rb+W+Cok9wpZJDiMxtXv2vp7KtlAy8mTkaVuEMVwzODDUjnbQK9Ls4Ftm63crUkQL7RJ3KyCpq3uO6EiTkTBctZsZ4x2gq2A6JFFK3uSR0vhm+eECqG/6VsDGk6KhDbAZ4SeGnaALbB9qLuqL8nUdsOF5NLUmu6Yic5HASRFWgCUkXCI8bBSxx5SFp7fOJTbyhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by IA3PR11MB9424.namprd11.prod.outlook.com (2603:10b6:208:583::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.39; Tue, 29 Jul
 2025 01:30:29 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.8964.026; Tue, 29 Jul 2025
 01:30:29 +0000
Date: Tue, 29 Jul 2025 09:30:17 +0800
From: Chao Gao <chao.gao@intel.com>
To: Xin Li <xin@zytor.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <dave.hansen@intel.com>,
	<rick.p.edgecombe@intel.com>, <mlevitsk@redhat.com>, <john.allen@amd.com>,
	<weijiang.yang@intel.com>, <minipli@grsecurity.net>, Zhang Yi Z
	<yi.z.zhang@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, "Ingo
 Molnar" <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v11 12/23] KVM: VMX: Introduce CET VMCS fields and
 control bits
Message-ID: <aIgkKTkxCLoBHOIs@intel.com>
References: <20250704085027.182163-1-chao.gao@intel.com>
 <20250704085027.182163-13-chao.gao@intel.com>
 <b63275a2-8d7e-4e45-ae4b-f69e90644fe5@zytor.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <b63275a2-8d7e-4e45-ae4b-f69e90644fe5@zytor.com>
X-ClientProxiedBy: SI2PR01CA0004.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::22) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|IA3PR11MB9424:EE_
X-MS-Office365-Filtering-Correlation-Id: 5580e167-faa5-44f6-df28-08ddce3f8082
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?c765yj9L8KG6coDUmxu/ZOqI7nMsTyRkXx5xiTaQcUT8NlF2goXA10b8CJjC?=
 =?us-ascii?Q?E7CIJmNTqPoy30qMg05gezFnpU4WLPvEXadWv1TFrn0twgee+D1yNwoWI84D?=
 =?us-ascii?Q?xPRbXF2q0sZDtml9e0TQnHPtwmiL9P4iRmY8xQqib3dM+sNmDtSD/ZIZqLAI?=
 =?us-ascii?Q?8C7vDoqOPpioapTs8ywKSoNZWC/2aXVFJzkfN3tLdx3C+rgTy5wVp/Unf+Jy?=
 =?us-ascii?Q?lhps2UvlDLTrQz47zurPawGbZHFglPedZyq/H2jUeDVDf5kuPdMGNAH2aa8V?=
 =?us-ascii?Q?YAjzwZOO8+kiRzYj5X9u+qovrC1m6cn1rLKx5nHQ/Ucfd5OpnvZ8uKc+OJrn?=
 =?us-ascii?Q?3QPSylh2HTD8NQHMxrKPiP/p7AxmAwZe8h4zoNRC7NzlxikoAUjhG6kmh5uo?=
 =?us-ascii?Q?qaUAslAR90egR5TD5LV5WOOIWBRb3IvgZ9R/O40vl+VQCt1gKhJk/OKcx6bu?=
 =?us-ascii?Q?IShQOyITB53thVh/5Lhbpn9BaOpq/JrTOkD9BDap4b/EnScFtF7smcsStdA+?=
 =?us-ascii?Q?nD1kvj2mYUjHuYy+A27jX/C7v7FVjo2tFQCZnT3IJjFtE8eUG5B08/kwCJCS?=
 =?us-ascii?Q?UJNGNgLbrmyf3LblBrqBKXaUzpekbv5tit65tGjvNhjlNnoiuoe4mHvicfSN?=
 =?us-ascii?Q?AgUDuDACKADcNWVIgU2XDQwf5H7uRX6hsC48M2ycbMtSH6XE863P+UEqubaE?=
 =?us-ascii?Q?PtAV+rNcqUZyPqFB0taKrmkggCIAQ09Uemsqud0GJ7uBgPiKy2XDn5pd8Zwl?=
 =?us-ascii?Q?PJWYsgVxhGnw6YC2PZBUTI45bZX4q2pWPfMFXIcWCvyBEnfl5qPLF2/FuV1D?=
 =?us-ascii?Q?3l6AYhG0gcxEDN6YNfGEvZM1OqGYbaGME5jew3zPCEzxHh1n490XZHRsqLRo?=
 =?us-ascii?Q?R+4+Fr8Ze5emGqUz0vOtldq1ULpz73l9fMDyUqXsOSy9bz5m4dE+4v5p/bLM?=
 =?us-ascii?Q?daPGXBpTcZH5jmITLgOya35sWx7HAIW93ePpFA8SWpZcTaH27iSOE+Ss37IR?=
 =?us-ascii?Q?es+07A1T18aN8iexd4PhPS8X0pAfsq8o3lqN7DZtO2NS+8OnC2csq19BV3JN?=
 =?us-ascii?Q?Gd68wglJG0cOi+LQfBJtdIa2cahYRZHt4GaHYfXs3AKryuWYirHpy9F8OzNy?=
 =?us-ascii?Q?iLDUt8Fb7+docdpD9RZa5zRp3ffqnXYPIQBPQzljIt/lWqMFcRf6ISx0aGBu?=
 =?us-ascii?Q?CIX9GoB2yJsi4/tYg9aDbeiZnUB0QJOio4ETim8+ABWUHx2F36rk5mZJ6h01?=
 =?us-ascii?Q?mmJgfEvopWyU9dXTYcclvw3qH/nkWbHpTkgayu9tb9wd5QCs7mOxsfhuPZ0q?=
 =?us-ascii?Q?0JvcWFIBfRgqmiJz1xCxi3VP9Koxh8yrKOG5IUWDDhq9gJfcQzPnjjCyIOkh?=
 =?us-ascii?Q?NGT3FoBtShNXxVrUs+NEW5ZncSLhS7gKqdGOA9z+jQ/UPZ8L8qyukMslVtPf?=
 =?us-ascii?Q?wJnzbJ6ObVc=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EJWkINm3lEbCSAt0l+CfxFm0RIb2rcrR6Ksb/7O0yDa5/JJfMD/z+eKhlhli?=
 =?us-ascii?Q?1F3VcRsEUMGTe5Zn6RUA1VZDxuprmKLaA9aQEY8SI6XL0eOCToM3BQHNCoWP?=
 =?us-ascii?Q?VWVIaSXcwQNla+qtLXhwuX5iXLR5s7ptfotHfm5+fxDgW1bi9qmNA3Qir8+p?=
 =?us-ascii?Q?kJ0a/tv3ytJ1vymP8sRRKacFeFNmYgXep2b5L8bpONljm9BrBUd7hUBFhL4y?=
 =?us-ascii?Q?m/dCwt4mXGl8sQnyhw/Bv4XRCAK48hRBYaMQQrCZ2mPwcpaoKm9ru2/DWlcZ?=
 =?us-ascii?Q?9bfnsTICX7v2a7+YvZkBJTYbYIghrCCnHFVlqAHqsAp6FQMftwNJDvWS8lM4?=
 =?us-ascii?Q?5OCMuinn2+sYewLf2sAyc99FPYTdT1/UJGu3UiG0g/HuEMaQmUl/HMulunxN?=
 =?us-ascii?Q?rhkQypw5/MGRU3JjZJ5oqMlO+3qoB3/4nTGAbq0wMUZ0nQPUSGXXWtn3gW9v?=
 =?us-ascii?Q?sdBY+HjVK6DLbegKAmqS4Ud/ShOOmols5ZNVmYm4uZWfFFSIdr/ti5ut/3YX?=
 =?us-ascii?Q?nnWoNwoXbqTYcMAQKDP3PjtFmWiRrB91z42crGRB7d6iwC9oNgRwcSOS9PfK?=
 =?us-ascii?Q?XKgRKlXQY8lpXlgL9EIp59uLt+6oVVEJm8C35V0H38bczNTLFXhtlLt1paMe?=
 =?us-ascii?Q?HYWvvTaY/YcQrJn7S63ZIAlLl9SfWQLqw9PvAW7w8VAHQus2u4qeWIIW+PJY?=
 =?us-ascii?Q?hCbcgo6m+JVcp3nm8Ts2F+VhgpN95OYL8Kvo+1hIW35LMKJkttN8qFh+eVSm?=
 =?us-ascii?Q?3aWeRSK4ZpzEzKsX9ku3/VjJy9/xcVi71TOInow+PhTFAwuuwfGZnDhJa2u6?=
 =?us-ascii?Q?+YtuzxuihAy4m1kgic2JQWW/XOTrC3mg/eyRTkaOWArxfAdeOXFI/kjtsqX0?=
 =?us-ascii?Q?St+YhEzG7ULDL/pjenLHV8AxedyfsM0kSTKj5FyeNVnsuNqPWspl0X8mPgq+?=
 =?us-ascii?Q?7/P7oTuPJelOARvAXzwcjwH16yotuvGWX4V1+mY/SLDwSWQ9RTDSeK8Gmsqs?=
 =?us-ascii?Q?YE7hCQ3debrM/BbDtIRZy9EPnR52H0vh11WOiRzjJJqqERmTd6rJMsmdcHAO?=
 =?us-ascii?Q?+MHg2ODAHNvzhJohUkC998pKikVODw3nrg2ZZTfYnmEivGW7fq2AGlaGo5Az?=
 =?us-ascii?Q?FLNVI6QdtG8NbFRsU4Oyaz73hOs/q22f1niq4oZiytTmmU7NsmGAfQuYmV2R?=
 =?us-ascii?Q?OmSkDnlQzA4uC9TvVIQezakIc6gT5tO/SN9tPzbN9JXzOOyB91SIlEDcIlJy?=
 =?us-ascii?Q?0wsQnd4KhBKj930z4U6EB+yrj3UTqrqnIJEMDTTDauHo5hXqJrhvRoSUAeYP?=
 =?us-ascii?Q?JBzUqg78eOLK3WsLRL2tZFgrNtZkaBQwZQnw3yoruUPjW5z2RG4dECbkQv7I?=
 =?us-ascii?Q?DGkItiUn9Vv/Dg1T0kXU/9CtyJFV4+OcKIKp6U+O1DV1JYDdjGFJhbtwXi6G?=
 =?us-ascii?Q?zNfqfRLPz3kNCeO5gUTI0QDiI4AdZQLF85qg8q7xSAvgpc90pp6jeLddYMTm?=
 =?us-ascii?Q?JTFE6Yt3eXJZ/8XFQXe+dCeDsnqmeObv/W6VR1J6jJNuFvk7eLdYGbVN3qKm?=
 =?us-ascii?Q?Ih+PjMi1XVLGLMt/l13VpHyiU8eLXCFTsPB9h1JX?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5580e167-faa5-44f6-df28-08ddce3f8082
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2025 01:30:29.2661
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t3yyLNURS3Kmhz0T+VaC1LJPB7xvRFy/7JzTFaivUIAUuG7tofVj768anThPhOl73tFyi3guZEmYzZeb9QLg5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB9424
X-OriginatorOrg: intel.com

On Mon, Jul 28, 2025 at 03:53:14PM -0700, Xin Li wrote:
>On 7/4/2025 1:49 AM, Chao Gao wrote:
>> diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
>> index cca7d6641287..ce10a7e2d3d9 100644
>> --- a/arch/x86/include/asm/vmx.h
>> +++ b/arch/x86/include/asm/vmx.h
>> @@ -106,6 +106,7 @@
>>   #define VM_EXIT_CLEAR_BNDCFGS                   0x00800000
>>   #define VM_EXIT_PT_CONCEAL_PIP			0x01000000
>>   #define VM_EXIT_CLEAR_IA32_RTIT_CTL		0x02000000
>> +#define VM_EXIT_LOAD_CET_STATE                  0x10000000
>>   #define VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR	0x00036dff
>> @@ -119,6 +120,7 @@
>>   #define VM_ENTRY_LOAD_BNDCFGS                   0x00010000
>>   #define VM_ENTRY_PT_CONCEAL_PIP			0x00020000
>>   #define VM_ENTRY_LOAD_IA32_RTIT_CTL		0x00040000
>> +#define VM_ENTRY_LOAD_CET_STATE                 0x00100000
>>   #define VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR	0x000011ff
>> @@ -369,6 +371,9 @@ enum vmcs_field {
>>   	GUEST_PENDING_DBG_EXCEPTIONS    = 0x00006822,
>>   	GUEST_SYSENTER_ESP              = 0x00006824,
>>   	GUEST_SYSENTER_EIP              = 0x00006826,
>> +	GUEST_S_CET                     = 0x00006828,
>> +	GUEST_SSP                       = 0x0000682a,
>> +	GUEST_INTR_SSP_TABLE            = 0x0000682c,
>>   	HOST_CR0                        = 0x00006c00,
>>   	HOST_CR3                        = 0x00006c02,
>>   	HOST_CR4                        = 0x00006c04,
>> @@ -381,6 +386,9 @@ enum vmcs_field {
>>   	HOST_IA32_SYSENTER_EIP          = 0x00006c12,
>>   	HOST_RSP                        = 0x00006c14,
>>   	HOST_RIP                        = 0x00006c16,
>> +	HOST_S_CET                      = 0x00006c18,
>> +	HOST_SSP                        = 0x00006c1a,
>> +	HOST_INTR_SSP_TABLE             = 0x00006c1c
>>   };
>>   /*
>
>A comment not on this patch itself.
>
>Both spaces and tabs are currently used to align columns in
>arch/x86/include/asm/vmx.h.  Can we standardize on one, either spaces or
>tabs?

I'm okay with using tabs or spaces consistently, but doing so will cause a lot
of code churn and make it slightly harder to use git-blame. Let's see what
others think.

>
>Thanks!
>    Xin

