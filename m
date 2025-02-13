Return-Path: <kvm+bounces-38004-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 01247A33863
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2025 07:59:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 80BD23A8FFD
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2025 06:59:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6DFC207E0F;
	Thu, 13 Feb 2025 06:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="N/S3rfoz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73ACB8635C;
	Thu, 13 Feb 2025 06:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739429959; cv=fail; b=L02pODr9L6B31Ri1V69sw1kyjk99WEff2k08321dU4BFv7deejMEKeh69z+khMDLJ8C/wrJ6Hnud52bBkF1N8AY0t4J4DeJyvbgFYQxYOLml951CIGmx8LzoNsXnuLXayg59SRTe76X40Soi+9ph/rdECu3E8Nxz5Lm94cJ6EiA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739429959; c=relaxed/simple;
	bh=ES3hMlgkk5PdlCuPW1w8Gv1rOeRXenjM9w2eOm4iZeg=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=tj+wEiOrjqn5Cu7RoCOldgclsP1rJi7NZmTzpJH3hQHLW2DmdLh4cGxn6/HwgJ4Ust9X+gGr4krdqHh03Z6NT3FkfQFsagiredHzEFWkFYdhv8Ia4kFM86UggP7ARAMVAlIWo6+Tixsd8rAbi9DOqVfjNbrdjsE4Vksn/GzEou8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=N/S3rfoz; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739429958; x=1770965958;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ES3hMlgkk5PdlCuPW1w8Gv1rOeRXenjM9w2eOm4iZeg=;
  b=N/S3rfozExhYtMDCe1uCiL752uZqzGXj/rYodVTa3XXfBcfIZtsj5yuH
   W92tjHM2hDPSMU8EZyvhC6RbLMzVYtp9pv1j944e26VN1GqW1xC/DxFpq
   QSSEnBBLNIX94K2FMxbOYJcBLyS/V6ZPmOGITWVJDYsVeuHrdIM657shK
   pLQ1tvHQkS+8hNv2AmSljoiJF6hyLgpTE3OQSysYRiEW53x4fUd9ZOPtf
   D3IG0b0rJDC9jAfMENjm/rHTLXBrXPpx98/tGIDVhDCukY1wQkySEtaMv
   szRlhx7wK4fAPu+2JhMvDOE1vKQDAtdTXUAC6e3UM1brbmgvDiDyTN//p
   g==;
X-CSE-ConnectionGUID: z1P6u6JKTl29R3Wq/m4IDQ==
X-CSE-MsgGUID: 7rF4HRtLThW0zE7zf3TE8w==
X-IronPort-AV: E=McAfee;i="6700,10204,11314"; a="40234164"
X-IronPort-AV: E=Sophos;i="6.12,310,1728975600"; 
   d="scan'208";a="40234164"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2025 22:59:16 -0800
X-CSE-ConnectionGUID: pAllCN3USpax8YaRZuQwAQ==
X-CSE-MsgGUID: S6ShpUCQTM+aUqsYu7nxvg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="143999039"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2025 22:59:15 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.14; Wed, 12 Feb 2025 22:59:14 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Wed, 12 Feb 2025 22:59:14 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.43) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 12 Feb 2025 22:59:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dhbuxUzpzu3NiOHOOrYpm1/E6vvyWusvhj004/bRSTGwMKhcQDxajnf5QQ8IGgelzSaGLErN7uh8aYx5cuaLwlHAcafnzs7hmAxufuSbQagmPGkelzFDZCPAeh0pJEiKYWFJ24fsAK8hfFZpCbkaGrvj2oquQidPRngFBIkvYCBOdAdRrvTIaBv6YPrCts9wIullF+Aqabft0Ux1ge/qplgvW5aCkGMZGvvzU+OhijvEcrhvwi+DhNHGpCy6/LSPGIKFeRHUsmCsaSuatFTNTExutBy8/GtWw1mgMsUrxTxdCIxPmvHCv8DcxFIQGJ+3Oj69hQnbMeZShFuHF3S5sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zea3KkDMVpXlHlqBixx25c7AXv7+N2FGwmD3ZfTkBXI=;
 b=YJ9G+VHlEjfbHhRVdbI9dCIWM9LzBbfdQPayFSJ+nT2JMJpKvC10HAbzTw4PEupOj9GpgtrdLVn/iB//dksbc27UemizHMSHQ/SPUYAXqxBHhZS94wcMYOZFibs7HEdXh58PK6SDRA/sPh1xKW8Yff7KITWYEQb1wWQtqCBfGtK3my9GMSb1OhYd9Qekg2XBhnQQUUelrmfKXaU/S9Hv0bgCoo3oke2NccXMgrGplejGDqO7LaZ4nXCDODYCqwezbSsE1pCBCWE9Pd5ifyCX6J8vpQ2w/BCL+58/BBP2ERpO4cdHBPuPCqMsM5/F8ZJPJRcmU/MuS3z5IBAKufHcQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SA2PR11MB4986.namprd11.prod.outlook.com (2603:10b6:806:114::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.15; Thu, 13 Feb
 2025 06:59:13 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%5]) with mapi id 15.20.8445.013; Thu, 13 Feb 2025
 06:59:12 +0000
Date: Thu, 13 Feb 2025 14:59:02 +0800
From: Chao Gao <chao.gao@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
CC: <pbonzini@redhat.com>, <seanjc@google.com>, <kvm@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <kai.huang@intel.com>,
	<adrian.hunter@intel.com>, <reinette.chatre@intel.com>,
	<xiaoyao.li@intel.com>, <tony.lindgren@intel.com>,
	<isaku.yamahata@intel.com>, <yan.y.zhao@intel.com>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 03/17] KVM: VMX: Move posted interrupt delivery code
 to common header
Message-ID: <Z62YNrvnJ9Dzw7GE@intel.com>
References: <20250211025828.3072076-1-binbin.wu@linux.intel.com>
 <20250211025828.3072076-4-binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250211025828.3072076-4-binbin.wu@linux.intel.com>
X-ClientProxiedBy: SI2PR01CA0009.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::18) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SA2PR11MB4986:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d18aacd-9bd0-439d-d020-08dd4bfbec22
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?yKC1btOwgS/0Fe2GO7dW6z6bMGyzsdxuvXnIdAzVnO930DIpFaTpzYy9B2KW?=
 =?us-ascii?Q?TBJ3aGeEAcb7NK1m09+VrhGUPhdZQyBqUM0czYHemCQ9XODe2osZSEkrCQ49?=
 =?us-ascii?Q?suAidumPSRqrg0iSa2wDdsfEJofqjAefTGI+mnO4kz4wYhqlpsRfLXNezTO1?=
 =?us-ascii?Q?PWDPUywmOQUtjUa0JEm8Zwp6XdKqCUaeVtmGNomn1MaLOWooNAicNa0XdvfR?=
 =?us-ascii?Q?Uac88P6zi3R+Xze0pe0kaYbARWZVAgaOjcVWx2Rq0g76U61ytLoafzti5zD8?=
 =?us-ascii?Q?LTXYfFJFuF6dPaQoWKaxzKencaJLwgHVh823of8iWynSw4ZwBerJJjwZA2Qc?=
 =?us-ascii?Q?rHRWy1AckvbqqB8C/vb8NwpYDqR/JxZ+AXB527NmSf2Y4xHRElPthaT4KXZz?=
 =?us-ascii?Q?XV065sPHVT6CrFR6vL5Nr3nkYNJeWTllxXzyef0GK9IQ9iPTdXTw5b/rI11S?=
 =?us-ascii?Q?LzfEzTZ8aGK+3lIU5T1ZX2I3lwBi9a4Xhxq2l8Eqlb9OETHQWHNI/lf3wK2d?=
 =?us-ascii?Q?yLIwk12jNw93ez88onmr3Es2/fauN3p8PF4OlVNWr2tPrT4fP6ndHxaW/NXJ?=
 =?us-ascii?Q?fx3kfGtn0+KqrHHr78svT2mpI39UmFTTOrzNG1xTMTijGIOsszCfgdIxlOR6?=
 =?us-ascii?Q?LErDt3xyLRWNUC1Ga0WV9VZN4WviahvBifvTvcGO/VjYk4PUibmV8xDXhL39?=
 =?us-ascii?Q?m0NW8Gug3VwGeirDYBTu28EDCXFWiStv1lv/V/CULa56OfDJTOw3GWs29gy1?=
 =?us-ascii?Q?CYRGX2cXQsQxIls64Y2IRM11/7aZwNlwr1nLqT3F/dptJxAcT2hIcA+fzvbC?=
 =?us-ascii?Q?DiPRMojRMJb15IAPmOGSPwdpHiJ9+TntSx9LbvtSWxPiG4Dk5B9h+I9wBH7F?=
 =?us-ascii?Q?yWJtQT6cUgDb380bg7729/nrQJ5sHskGiar1lR/H1dhmolDbGBCLmcoAhbe8?=
 =?us-ascii?Q?KcKpDinlvnp29B535iocUFJuVg5/QDuhvjw6FeL7J1jMqVBjmCFZgwWSBgVj?=
 =?us-ascii?Q?ubDJijTtnHbxsmBUw3s98CjMsro95VdS2/vjNs6RsbDFUAQ2aZFufl8TGUhP?=
 =?us-ascii?Q?Cb/cStk0UNmbS8tYIROjqzjTMDCKzX1KODjqJUwTVvwOmDsCKwNULZoKbGeh?=
 =?us-ascii?Q?Fmr+gfldOjzF7WBwbMVeIARYy+Fp5UDODz/YdJwQi4xLHukUABftwavr3OHF?=
 =?us-ascii?Q?uBAvvNoDFCuJ+wu7q/V+OXjHCJ6wSsb86OhB875xR940UBF5+ebHX15h3+Yo?=
 =?us-ascii?Q?Vw9gqqlRwEf4kHKTZP7vHKpBT9Fhb7IP9YNWSxraH8liOf/p53ZN4yHGlo3S?=
 =?us-ascii?Q?QrqeAK8h2frvoOke0jeVivV/InrQcCpLdOyybh498WErLHQI4ic1W2r7pIjn?=
 =?us-ascii?Q?/u0lUCVsf7ngE62ANEkIW4+IXJ/S?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QkZ1ITOFwppgczaq0k2MBvNXJNX2tCvEYBr+y8IaRRchJq3yF7RaeD/Z3x/H?=
 =?us-ascii?Q?XOr4EjBLKfLq+5sdTVVY4559sOTx6L2NXzvhIPFMTTC8nO605VWTnXllUVPt?=
 =?us-ascii?Q?GmalDbTV/NQx0Kccx4h3vaoJmKj0iRlGNfeRXZR6CpI70vR2ybQUg6IH9Rxt?=
 =?us-ascii?Q?NsZ/V5H3I1iW7eMCD7Fos8VKOmBEUtQ59Ds59IkQbOHdZkEZNx95+H1Q7mdG?=
 =?us-ascii?Q?nSBEFt1oeUa4poG2156XoUni2ex+Lo082cs1d7uZNtkQ6l2qVBtQILw3YKst?=
 =?us-ascii?Q?uWo07D20cltcfERtHfaX/+UHRSJP4ti/zAc4BaasNmdZ/yUbQWFGcztxP/HD?=
 =?us-ascii?Q?hwf+zMFl2AGfKxEcs6XpfeZGichwwKUCcJ5olBCy41kNXoYj6jvXshWUMbUD?=
 =?us-ascii?Q?kijPCw9p50MrORqhz238XdKmbkjSW7x29CEP3RHZiOrOKiMhKr3McbuNcU7J?=
 =?us-ascii?Q?oHPA3uoA/pzkhgQB6JUD5nz3pTlTYdCBkLvIeIrIjwyqldQ0de4/L1BotqcW?=
 =?us-ascii?Q?RvUj1alW2Pygs0O5q1Roh8uNocD3UrzetzObcLmFg/+R2duwpmxfreAXabzL?=
 =?us-ascii?Q?el++LT3JAkvqD6Qdd/VukFFpEHmLC491QAhBZdAhW7RKQP0DucdWdf2dOiVY?=
 =?us-ascii?Q?DWe6LzLoqUnar5zG7hUtqV9l+5eipe/lf3TFUkCjDFEHKtjeKerpkK2oroVH?=
 =?us-ascii?Q?tDC4z/UafIm98bCdzYx8HckknGTF9FBCKRqxIxtjjDGVMXn887EjuB6OfSb3?=
 =?us-ascii?Q?/rW8w0zZY50cMSjLn9d7hNdDHtRakhg+tY4tRXWz1NNjvJXadEsblEU1E/ya?=
 =?us-ascii?Q?4PXEw5ctFgjQ+wKHEghquNGwZwBi/8tgep9jOvqXoTpjlLrnkzGlA0E1bFmL?=
 =?us-ascii?Q?o+a/O6HaQ3qBdAVRzS+Fn1sIRlzLT/XqxI8xJsFFVGNVQqnhKSMGqvAfNt35?=
 =?us-ascii?Q?98WaUT7BvHWUxBvgt93MNhhqLckEJaW1U7WPkXv6EELqa+ivEtQDB5qtFcCf?=
 =?us-ascii?Q?pq6hRF1hPJSYOl0tD1oejfFQ1Sb7VjG4HfalJUqnUcAu8+BZaVeJV2n3Xcsj?=
 =?us-ascii?Q?i5BkfONBH8/2BJgFhw17Lyr/R3KFGcPHn4CmgU1T7hsDpVub45aF3P4cf23a?=
 =?us-ascii?Q?bU6WclC9oDZxY3QxyoyJhiPSaShmqKT8xgQgALaYGwdo3FiBVphkDBvFEDl8?=
 =?us-ascii?Q?E4Rx3fblNHeE3mocsafciB9yY9/KCsgJrRtjRg4EKC2uvkgwW3ssxTXvggPC?=
 =?us-ascii?Q?/HPoiaxmYwnKdJTIKQBUbIB/PtRdkvOiWwAtkketpPKXTSBieMyyOVYkNLTY?=
 =?us-ascii?Q?JPcitwt4AMMPlZj3QO13ZRt82sQFWJ+s4L4BiYT+CS+4kvyK3A8oX1TdE/0+?=
 =?us-ascii?Q?ZuFJRKhI162/ZVo7DmnNqapLLOUIvbd0MPcppEQ5QxoSFbNOrNi0dHlxTfHp?=
 =?us-ascii?Q?/CByigvjL/e7z4Oj9bZHd/DDbc4R++oBBUPAZbWDnqAzqZeap6Rj8sWfjXOY?=
 =?us-ascii?Q?qss0eR9ivu0Vq93A3ugqqA3/hkaLzeC/KHAoVWhUs86dtn1NS5RIuqNvyM6L?=
 =?us-ascii?Q?689e42jrVxsmNlz3K9jA6GJjM9ohLk6hjRcKq+RB?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d18aacd-9bd0-439d-d020-08dd4bfbec22
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2025 06:59:12.8538
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yCJqWwviRHmv7axnNL/hDPJ1Cj6JeToio1b79cet1hHQ2wp4wrYE+XYlnbc8v3oUb8P2+dcpHsqWtgI1WFNUaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4986
X-OriginatorOrg: intel.com

>+/*
>+ * Send interrupt to vcpu via posted interrupt way.
>+ * 1. If target vcpu is running(non-root mode), send posted interrupt
>+ * notification to vcpu and hardware will sync PIR to vIRR atomically.

This comment primarily describes what kvm_vcpu_trigger_posted_interrupt() does.
And, it is not entirely accurate, as it is not necessarily the "hardware" that
syncs PIR to vIRR (see case 2 & 3 in the comment in
kvm_vcpu_trigger_posted_interrupt()).

How about:

/*
 * Post an interrupt to a vCPU's PIR and trigger the vCPU to process the
 * interrupt if necessary.
 */


Other than that, the patch looks good to me

Reviewed-by: Chao Gao <chao.gao@intel.com>

>+ * 2. If target vcpu isn't running(root mode), kick it to pick up the
>+ * interrupt from PIR in next vmentry.
>+ */
>+static inline void __vmx_deliver_posted_interrupt(struct kvm_vcpu *vcpu,
>+						  struct pi_desc *pi_desc, int vector)
>+{
>+	if (pi_test_and_set_pir(vector, pi_desc))
>+		return;
>+
>+	/* If a previous notification has sent the IPI, nothing to do.  */
>+	if (pi_test_and_set_on(pi_desc))
>+		return;
>+
>+	/*
>+	 * The implied barrier in pi_test_and_set_on() pairs with the smp_mb_*()
>+	 * after setting vcpu->mode in vcpu_enter_guest(), thus the vCPU is
>+	 * guaranteed to see PID.ON=1 and sync the PIR to IRR if triggering a
>+	 * posted interrupt "fails" because vcpu->mode != IN_GUEST_MODE.
>+	 */
>+	kvm_vcpu_trigger_posted_interrupt(vcpu, POSTED_INTR_VECTOR);
>+}
>+

