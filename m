Return-Path: <kvm+bounces-56132-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D6500B3A467
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 17:29:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DF5967A76AC
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 15:27:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A454E22FE06;
	Thu, 28 Aug 2025 15:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KQRRs2Iy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F319220F3E;
	Thu, 28 Aug 2025 15:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756394947; cv=fail; b=sHqUG+cqOu9z8PPvD+1xC2xxDTAW9P9B9Kvem3wvuXGg9V+lHN/REI/jD3vvQKJx6XVc66YNXfDG3uezWviohiWZWBkvW8WPIHEOYIapXjRWIb7fnWKlfox+WyvQefB3oGNRBu5umngYi1FBLPSodqNS0zQD4HMB0fMmEepWifs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756394947; c=relaxed/simple;
	bh=JErO6IN2bDoSdUTN1beUHTcwzKsv3j9KwVOTaya6Iog=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=FSRZXcj+rbJ2CatetzMcXhzXi5Z2wQ6bwcAOrF/1wSLcgISUF8LB304liMRC5+aole/qdfBMzbgpaCkPni4QpU5n1cXnHBJofPoUFTHqTdPCBMlqqojMUPluH5pgzicdsv4Z3xuqrtOyhr0tyRsV1zs8jwFkFs6geJfrxkxk1Ok=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KQRRs2Iy; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756394947; x=1787930947;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=JErO6IN2bDoSdUTN1beUHTcwzKsv3j9KwVOTaya6Iog=;
  b=KQRRs2IyjKvOAfyPVIX2hEtzPZzMxojiaWZDV1/uWuJyXntw6AjcJjdA
   fDlxj6qB7rm4Hjczfpg0SpgN0It9aM3aV0pMXfMz8e6z6vsFwrkcE9fxy
   YFz2hZlk2SqBLHUGlxg6Jgkm4b3c6NXvDngQuEfsqdCCobMy2Ntdn6AXr
   3JeBkyLrw3OXnYGJ8MnafjeYbuw29pWk5ig787nH12OhXfmTbSPQ6L2ba
   GR4EkRwyspYbfrI5DNqZDhq+Of/Wcff8Qxb7vOXfuJJ8CBHUQh2n+plzi
   0Q3KKqM0MobiB3oZxZ+zPftmpP7ZOLiRxfl3ZQODEzOlfp3deeWcU52R7
   A==;
X-CSE-ConnectionGUID: RSPg0IayT2m9coB9oAoFBg==
X-CSE-MsgGUID: wvztSzM7SEmo0PMw3Ax8Cw==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="58594523"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="58594523"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 08:29:06 -0700
X-CSE-ConnectionGUID: UVTiIr+FSKarZuLDL1Gosw==
X-CSE-MsgGUID: P3VeqMB2TSqn5aY10rOUOQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,217,1751266800"; 
   d="scan'208";a="169661664"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 08:29:05 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 28 Aug 2025 08:29:04 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 28 Aug 2025 08:29:04 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.86) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 28 Aug 2025 08:29:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t1HOaLE4Q1YVRMSZ/0FqWDnAs/PKUHDaO41M364+w3IZ/nAUgrP0gqwBwslQU0jFAdPh8XZpg7olpmC7u+VR/8KE3kQWUVZwBqAhAuBQXTGN4hw76nGrrXR4kmUfauE8g6KHflU4V0PN0kZQUKXO4S/uu78Vd/oQITLXUsXnzcdMRHXQe7P+w5z0/JFxZ5q7D4DBg2B2bTjEI8ZTgylWhmUEx017mKZpK1d609Oq+q9E4G5Rm0qswwoHGtYWZIyD3zX+eJzJEy3rRFVT7GaBl0LyfhS5QAHxLjlKLXsKy816k37Lq2E/I4+dJ3JJRijlCidOCbBLMrP6IJrYpIGBYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yjf4oerH8n6iG8ad8bxq3BwiJcTjRCz+MZIeFW7OPAU=;
 b=Qq8ecZJvec+iv94+78BcM27DgFHDS3PuY6bLUEicLKykuSTSNy6MZx2Qd29wHg8POcKgzDsuKPDk0n/syfTzLivxeRjoIhYD9FMff23Zc5YsrguCpTBLRm6DbIWNnWZRmf5jgi5bIj0jkZ0rFHCoqL1+J0wy9yp06IUT4vTs4WRtHvDCh/dbnJQaN/hQp26hMIxYsR/5gll1NXFQOoORbt4WrBJsAjUK8bdBBSdoQe2sK0/tqv7d5C3HxKCKkaNPkUAnkqYJYL/x8jRyn8doOXOKy5wypDumIKX207GJOkOOjPZYXCqC3neXs3T+3TvLw1c5WzgJ9CQWvs8CwZXZNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by LV3PR11MB8743.namprd11.prod.outlook.com
 (2603:10b6:408:20e::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Thu, 28 Aug
 2025 15:28:57 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::bbd5:541c:86ba:3efa]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::bbd5:541c:86ba:3efa%7]) with mapi id 15.20.9052.019; Thu, 28 Aug 2025
 15:28:56 +0000
Date: Thu, 28 Aug 2025 10:30:44 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Sean Christopherson <seanjc@google.com>, Yan Zhao <yan.y.zhao@intel.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Michael Roth <michael.roth@amd.com>, "Ira
 Weiny" <ira.weiny@intel.com>, Vishal Annapurve <vannapurve@google.com>, "Rick
 Edgecombe" <rick.p.edgecombe@intel.com>
Subject: Re: [RFC PATCH 09/12] KVM: TDX: Fold
 tdx_mem_page_record_premap_cnt() into its sole caller
Message-ID: <68b0762463960_22d9829498@iweiny-mobl.notmuch>
References: <20250827000522.4022426-1-seanjc@google.com>
 <20250827000522.4022426-10-seanjc@google.com>
 <aK7Ji3kAoDaEYn3h@yzhao56-desk.sh.intel.com>
 <aK9Xqy0W1ghonWUL@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aK9Xqy0W1ghonWUL@google.com>
X-ClientProxiedBy: MW3PR06CA0002.namprd06.prod.outlook.com
 (2603:10b6:303:2a::7) To PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|LV3PR11MB8743:EE_
X-MS-Office365-Filtering-Correlation-Id: 20b33727-56f3-436f-9e64-08dde6479a8e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?165h/kRHx09OZHKBzElrjpJscIN299c8gobUj67jm/FgeAnmVOJOtnwwe9X9?=
 =?us-ascii?Q?TBbaYeNcFbKh61I4tozbqGlRu65ne3xwa74Qqg9PtTP1ATSdoa02JoRuvoTn?=
 =?us-ascii?Q?AGfgxMzJAUt9jy/4KVV8YXsNFV+p1wP103HhkoGLtPSz3b236LblCRUYdAKk?=
 =?us-ascii?Q?YyTuhh0W6KB/y/YvQD+XpcI140Dg9i3vZs1RR2luN06ECdIk1zHk1AbJ+eEJ?=
 =?us-ascii?Q?5CaLS3TOLJZXaZSj2kwMeQ9/VUtOA7V1cANkNmvS5KKCnr8hJxi0PAqbvie8?=
 =?us-ascii?Q?9iO2WBHdCTuQQsGe5ScTJSs4ZnCD7wrYIvNJJkc8+SJ1D9kuPT5reSkDwrfa?=
 =?us-ascii?Q?Xdo2Uij/opCjK3yDcCQxw8BxksMnj/ch5obWcEW7KRppn17KTLmOsxaRsI2Q?=
 =?us-ascii?Q?MnIBS39YKqeAv9dgShhEOD2s6bGL41Zu3f589yY7GbOSb7BNAVPbbDp3PXwL?=
 =?us-ascii?Q?dJ/I0Iidws6k2vnbvJkq+mG+zjryoUgszvhB1rZLJ/o9CH002ipI3a4J3R1+?=
 =?us-ascii?Q?/y4nSGxue7naGjdIlsspt4uiQ+P2VdBt3WjLuyJjvZ3BQbbUjYXtSGahq5FB?=
 =?us-ascii?Q?NdobHs88t40Z9PA6TrG67HI+Bm20uOUnQkJmvrmxgZimyrnxK3J3j51+MSVS?=
 =?us-ascii?Q?ThklthFIKVel5cs4DjquSpo0b/3GBjzi1ulb1S/EZZbVKjU+cQcsrTPR87Hd?=
 =?us-ascii?Q?G/DpnQOpt+B2jkjQr2vgG1UjC4NW9NR3AJf7Gede4BT1wA1Q6seCslEBAX9z?=
 =?us-ascii?Q?sjGP0EfIKJaYC0r8CC3ZPl9g4HO6icoJde1H2xQSmm+ab8K8Z8cZLm8Gl9SR?=
 =?us-ascii?Q?sg0N1CXystSDBNgFq1E0cje6YVcp5R2qnbvpJurEZDltXO5IACzulGbbs/w+?=
 =?us-ascii?Q?1gUL38ybP8cZDj5UvuMc5aXkNs+McRtBe8jOCswLmXBhwa/6pKWvcK2iJmQg?=
 =?us-ascii?Q?n4+pe7bqqqFB1LZtuXFtZSXtRmRtL+aaCo4dgKa2RM/8dsSSMuPAUk0bmWBk?=
 =?us-ascii?Q?WRanBByAjtSL1G8ebj2BngX7hstrH3KwmRIiOPmX3PUiVGwHbQ5nsssOIfLM?=
 =?us-ascii?Q?YxgPokC2oVS7UsZaJUangW6/Sck80mwRqwREYmTUqSn7gP+0/aw9M6oaBxNO?=
 =?us-ascii?Q?Rs+gfxc/c7Qr0QhnaTeMB0XAAwMe02IYO8Iywn4lxe5BtRA1d2FP0cn6cTuz?=
 =?us-ascii?Q?YfLE0EPvImdo66irDE8cmqYREUkRt6ha685GGz4XYX/Y35hWgre9o5EEJA/s?=
 =?us-ascii?Q?2lQgi/BumjpaC+Jb+/d4/7zUUTNbQc7StRrKpmSHiDTfolpavJroVSrPQQMD?=
 =?us-ascii?Q?fXI8CvLWhTsKCc2iLBuu1Uvo784L0780FSwK5OJZrPm3exaHBjzKRRXKfQeT?=
 =?us-ascii?Q?uv7qTBT5DnbMr7/GdU9lScFkDbDn1m2/eP/Gfm8dSMCJAlrG2vfOpVhD5g/A?=
 =?us-ascii?Q?Eu82djJa9zE=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aB9TtIV/pwygXohuptqPQTjjcJppFAz/NqdPum4lJpr8Q1OeRq6THwCG31su?=
 =?us-ascii?Q?BGsAOjCRq+xJoFaXn9GZgfi8yZO4KVGl4nGsJhUvATUUKcZ3KPTgItH8nC2F?=
 =?us-ascii?Q?WPhLwCpVFzr95q3783KDVHFZ0NGXyTJJ8599s5S9VxtLugxbjZBjXgG5FHqs?=
 =?us-ascii?Q?4JkMLDs3qh+Wghn4hnp1ebhUbRGofZtSjAH52qJ9IwAgQ8mtrrZLU/1Zcxl0?=
 =?us-ascii?Q?FPStyni4QKwv/RQHB2cgVi5RRR19wGjkGDJ/J+MRSRqhMqWWhPympk2GrfMw?=
 =?us-ascii?Q?dqwiqtAdM3t3ylEEI4Ivj05F84dQy2FUxsGOXCVhfhjUcRgK7vfSBTtG3r2m?=
 =?us-ascii?Q?SjyDeqfGvgsc0h9zJYk+dyVSvPTX8pWmRXLJOzjiibRMpR3d9J9Fgz0+cUvs?=
 =?us-ascii?Q?CVeGTrMThRa5nqO3G/dV/3yZPDMsHBMUqVWLctJQXN/fugm5vpQl62Ge7Jla?=
 =?us-ascii?Q?973HetrvIst/6AhVkFsW8TxICelDinqA+WYWXyIG3/DcY5C8ADRm2Q3mGn3e?=
 =?us-ascii?Q?RwXs6DOUHf0XpvVs+JRp0wQdGmtyrLAHwOlYOPI5dEQy2RJKSdtk00TEyH1b?=
 =?us-ascii?Q?OihM6/c+lE2NmzyCJIQ5ZeNH4XNBGQ+xIld0iPsxXDho3cM1ZldEnNeMvgZX?=
 =?us-ascii?Q?+yXcYjx3HKpijnWF4VaJzGVRXkcGLif4vKiaJcXqF1u7wl8HHZBl6jEA9IDU?=
 =?us-ascii?Q?BGCK8XcP//7PYjPUOlJ8+O+26LUWNPhV7Rp1diOkqkL7cmTIPsaU7ZDFsw5m?=
 =?us-ascii?Q?vJkrlqauLzfNHSd22Qj1OL75+MOtsWRQqQgY+e5RuaCSb0fXUuh6EFjEHfqN?=
 =?us-ascii?Q?0b1tapRGZGVEsHRFKaH8lukBQN5MzuB5vqrPnpeYiVvIpK47qHVhsLYlvB4K?=
 =?us-ascii?Q?WnbDiHeIeM2Tpv9U9sWqasnwvEwwTOhy5PJVQ3yKN9hOT9yEKmvPOEJDJh/9?=
 =?us-ascii?Q?o4fFUcxA/p679AJbbnLKM29zec+X+rKO1A8dwCKXBxJkHPF0kqJlckQM5mGe?=
 =?us-ascii?Q?8I0DFFKdFaKxJyZ+IrXrPUTyh9pD1iZUpSpL1ZRDuvSdEtn4CFh56b2WLVdD?=
 =?us-ascii?Q?Wjrv1IiG2q22rfidPcbvBKvCJm+/DrtW2hRUeE5iNlJAIfWCR29dOgh43CpS?=
 =?us-ascii?Q?ZTH/z7lPf+o19brmRogLouBddZQDoboe2WT66hUWTpg6+2WZCYGrNvAzFAgu?=
 =?us-ascii?Q?lTtAIhmz7mldX//9xUsg9SYZRFjIBSmP1bWC6hej4xzh9rKflF9k91/KBPZk?=
 =?us-ascii?Q?yurMRDlO9VHQLzPVCVxCYItGSRBJxMGYYX2eDxvhy7RyAuoAWCN1R/6LTXxl?=
 =?us-ascii?Q?p63T+n1PDFP6SHmZNmkplHmbZRCHIp//UVvw+pp6t9KiCZYqOTcerA7qiuFI?=
 =?us-ascii?Q?4u9dk/cLeWfdIuaC6+ahpQZ7ThAok5IU+RhKV0rTQEKInHVBUCKshbdJzvgR?=
 =?us-ascii?Q?AYyL/kUkLl6q0A2MuhIpvbS0NTPtlO7AZdZc5cYBFVOlBtBH2/3Fvz0p05Fp?=
 =?us-ascii?Q?TJXUiA7cIgHvhAjdssVlkvoIwc9vMZCHgN7zpABaY+XhEm96RNUwGaaQUku3?=
 =?us-ascii?Q?XZwb7RoUkcoAieIRKeWn4Xo2USrjF94JdL2idpEG?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 20b33727-56f3-436f-9e64-08dde6479a8e
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 15:28:56.8262
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gKAl0hLjrpH6KAU3m0pf7/sFVK9OMNl2Izkkb5hpo+td70/R45kSf6U0UJg6CVX9N+em9wRChMvCDR5IiEA2Iw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR11MB8743
X-OriginatorOrg: intel.com

Sean Christopherson wrote:
> On Wed, Aug 27, 2025, Yan Zhao wrote:
> > On Tue, Aug 26, 2025 at 05:05:19PM -0700, Sean Christopherson wrote:
> > > @@ -1641,14 +1618,30 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
> > >  		return -EIO;

[snip]

> > >  	/*
> > > -	 * Read 'pre_fault_allowed' before 'kvm_tdx->state'; see matching
> > > -	 * barrier in tdx_td_finalize().
> > > +	 * Ensure pre_fault_allowed is read by kvm_arch_vcpu_pre_fault_memory()
> > > +	 * before kvm_tdx->state.  Userspace must not be allowed to pre-fault
> > > +	 * arbitrary memory until the initial memory image is finalized.  Pairs
> > > +	 * with the smp_wmb() in tdx_td_finalize().
> > >  	 */
> > >  	smp_rmb();
> > > -	if (likely(kvm_tdx->state == TD_STATE_RUNNABLE))
> > > -		return tdx_mem_page_aug(kvm, gfn, level, pfn);
> > >  
> > > -	return tdx_mem_page_record_premap_cnt(kvm, gfn, level, pfn);
> > > +	/*
> > > +	 * If the TD isn't finalized/runnable, then userspace is initializing
> > > +	 * the VM image via KVM_TDX_INIT_MEM_REGION.  Increment the number of
> > > +	 * pages that need to be initialized via TDH.MEM.PAGE.ADD (PAGE.ADD
> > > +	 * requires a pre-existing S-EPT mapping).  KVM_TDX_FINALIZE_VM checks
> > > +	 * the counter to ensure all mapped pages have been added to the image,
> > > +	 * to prevent running the TD with uninitialized memory.
> > To prevent the mismatch between mirror EPT and the S-EPT?
> 
> No?  Because KVM bumps the count when installing the S-EPT and decrements it
> on AUG, so I don't see how nr_premapped guards against M-EPT vs. S-EPT issues?
> 
> > e.g., Before KVM_TDX_FINALIZE_VM, if userspace performs a zap after the
> > TDH.MEM.PAGE.ADD, the page will be removed from the S-EPT. The count of
> > nr_premapped will not change after the successful TDH.MEM.RANGE.BLOCK and
> > TDH.MEM.PAGE.REMOVE.
> 
> Eww.  It would be nice to close that hole, but I suppose it's futile, e.g. the
> underlying problem is unexpectedly removing pages from the initial, whether the
> VMM is doing stupid things before vs. after FINALIZE doesn't really matter.
> 
> > As a result, the TD will still run with uninitialized memory.
> 
> No?  Because BLOCK+REMOVE means there are no valid S-EPT mappings.  There's a
> "hole" that the guest might not expect, but that hole will trigger an EPT
> violation and only get "filled" if the guest explicitly accepts an AUG'd page.
> 
> Side topic, why does KVM tolerate tdh_mem_page_add() failure?  IIUC, playing
> nice with tdh_mem_page_add() failure necessitates both the
> tdx_is_sept_zap_err_due_to_premap() craziness and the check in tdx_td_finalize()
> that all pending pages have been consumed.
> 
> What reasonable use case is there for gracefully handling tdh_mem_page_add() failure?
> 
> If there is a need to handle failure, I gotta imagine it's only for the -EBUSY
> case.  And if it's only for -EBUSY, why can't that be handled by retrying in
> tdx_vcpu_init_mem_region()?  If tdx_vcpu_init_mem_region() guarantees that all
> pages mapped into the S-EPT are ADDed, then it can assert that there are no
> pending pages when it completes (even if it "fails"), and similarly
> tdx_td_finalize() can KVM_BUG_ON/WARN_ON the number of pending pages being
> non-zero.

Ah just reading this...  yea I'm wondering the same thing.

Ira

[snip]

