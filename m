Return-Path: <kvm+bounces-72986-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4LB3LjhnqmlOQwEAu9opvQ
	(envelope-from <kvm+bounces-72986-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 06:33:44 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 4985221BBDA
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 06:33:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B38C13034A13
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 05:33:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 729B9369229;
	Fri,  6 Mar 2026 05:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lqVQ/1CV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1C2354654;
	Fri,  6 Mar 2026 05:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772775219; cv=fail; b=uvX/GYiLpoNYHte7hNExxbiY7aaWIqnPWgPT4dV4m4ItP1IhOS4CaViSq/h4W6Gx2bE2gs3BxzIvTqlBY7iBKvh2+mEgSy7y+oq8W7CUiwMaduoOQT2AEEj8eFV+G2MyP6jC8RWrVTHcPa7DfWU892xQfEzntGgJkBbC+hjNtf8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772775219; c=relaxed/simple;
	bh=/wKPml3UF2JPOH+flnFjM6cmC79UzcYZn2/C4OkTdT8=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=azboQFSFUbTRvwWcai22VURbIgDnUOxj2LavBpbPM+xqnGcKWF0kwx0mGGxIbO4xV1+hPPtOHgCgIr/kOn9DXPIu8aq+0Vu0FxiA2zMUjVqGAi1Tdsj32ILWx1YOHylWtsdK9T8JRlyd6Hd6dFqenJDLbEHRy2Ldfqywm9PSWDg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lqVQ/1CV; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772775218; x=1804311218;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=/wKPml3UF2JPOH+flnFjM6cmC79UzcYZn2/C4OkTdT8=;
  b=lqVQ/1CVgnDWx112UdZffo33g2uQ+CLoBztjaNrexduAsbFQde1Tsnml
   cmzHbCGRjsHTehEmO0oS3J+MAXicIV5MBLgmT3PGYPnTaINhaIks8nxfr
   p6pNQh8x3Xda6v6xrTYsRUGaeepZWjOr0FR7sCnTxorODm7US1P8ER22Q
   IsA0vYf+BWwKNzzoJsJBDJCoRSCb78KjjC3EE/T4PBF0/2y4cVrN9Nq4w
   7WnQfwDQdJkL8dTH7sJuOgqBU/Q/mThQ79RLoLZpy36TCU1gpJBiom/yP
   HxvDQdkBpqZgbHnsy0ofY79EiylNS6ORLZ5gCj0lib+tkcW30QmAPCwrt
   A==;
X-CSE-ConnectionGUID: nw+2gg+eS+OKeqbhePSTHA==
X-CSE-MsgGUID: r/0CcrzKT629W/KU7rQBRQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11720"; a="61452988"
X-IronPort-AV: E=Sophos;i="6.23,104,1770624000"; 
   d="scan'208";a="61452988"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 21:33:37 -0800
X-CSE-ConnectionGUID: sp8eH7YvRV+zMbdA27ClJA==
X-CSE-MsgGUID: ZOftLvt9R9eeQx3sWDB9vw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,104,1770624000"; 
   d="scan'208";a="245252811"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 21:33:37 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 5 Mar 2026 21:33:35 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 5 Mar 2026 21:33:35 -0800
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.0) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 5 Mar 2026 21:33:35 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RBhVRfnmu8SN+PMLlwDOfDJEbTKMX8OT9jpV1jSG5uJzlw8loYjuFlrpiCzJuFjxgX2yD2O3PKHjhgxM5+ar9N+vsjOY2dfbtjPxO9qGnj+SzOV+RaoRnH3adkpM+yb0emGxV5Fq8siLKDhnjydHElrHloktpDxDRF7AKFPwbYxqF57IdBAqRQPufoprmhkxIDUwRFdxOrjmm6wqL5ufp/FGlmtsuI6yVkZOAxCqil3FSMi01gomcxRa1bLKKjtgdHsztTm2iYuFNrp04D/oK1dLCF783sn75f+xKfl1hxloMstpPOQZjnzupugB4qTd7Wp/96XiSAMkinA0gkjmUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KGVBPRDGenSmBKFkerTC43ZhcQ855ukZ4BFts2ulHaM=;
 b=BoN2Vmhv4bEN+m/sjTGcSlqX7+Iq88QWPBzS9O2dQsnd0MpthCDCKOiedG5MS2qJ3BLSRU0LitYzem2Id0wgPS3/pMGDQ1++b2wlZCaQmuaTFEKIyB80vtjmTD1ZIZJMGSqyBfVtgzHS8/iJdr8Lly7WqSXGvwI9spmHhl0hDFRb5Czi9AFOa9hwOvhgJezl96zuCKdFALBZqaufxfiuWsE0Rubc84VX/Kjq8v8QochROxj8bOo5wlK8OHcKCMufz/EfipQJlwtSRdMJA1C0ik9O9qfl6TDwutv6vBfnh9lAr69wpyWXooeJXBgbyEJzb+GvGMasM1BBxcXAB0roDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SA0PR11MB4640.namprd11.prod.outlook.com (2603:10b6:806:9b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.18; Fri, 6 Mar
 2026 05:33:33 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf%6]) with mapi id 15.20.9678.016; Fri, 6 Mar 2026
 05:33:33 +0000
Date: Fri, 6 Mar 2026 13:33:23 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: "Xin Li (Intel)" <xin@zytor.com>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <linux-doc@vger.kernel.org>, <pbonzini@redhat.com>,
	<corbet@lwn.net>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<luto@kernel.org>, <peterz@infradead.org>, <andrew.cooper3@citrix.com>,
	<hch@infradead.org>, <sohil.mehta@intel.com>
Subject: Re: [PATCH v9 15/22] KVM: x86: Mark CR4.FRED as not reserved
Message-ID: <aapnI6KN7Flal8kg@intel.com>
References: <20251026201911.505204-1-xin@zytor.com>
 <20251026201911.505204-16-xin@zytor.com>
 <aR1xNLrhqEWu+rmE@intel.com>
 <aajVJlU2Zg4Djqqz@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aajVJlU2Zg4Djqqz@google.com>
X-ClientProxiedBy: TP0P295CA0036.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:910:4::15) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SA0PR11MB4640:EE_
X-MS-Office365-Filtering-Correlation-Id: 979a8e8e-82b1-43c5-edef-08de7b41e7fa
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info: aKu1mHT7FJqZOnqY4pCbU41zFZHVHQwzxHcBSMHTxVJngsrZOVo50BQSVLHTJTUpsSgXpaOBYsSlZL2hB0REjEHGNp9u+VBHPQANC/LiUUeHqAc6HAzJIFkNx+fAApiIVETruE5mJ+d3QB99U47AyWUOfA8aAGhXFK7KQhylNBoCXUMDKVWchYCZWkGUL/vXu9nNczfck/mq/gQgXO2IvSdJepHJ4AnM1KMoOacKmIUazG0lP9eJc1KS9qTzUMelig0RtXZYiJjKyNs5cou2zpZ6W43UnVOtkT2FeIrIviEaXAa03Or7u3tZWmQhiUdCoWqfs5oQtOFhKrl8u0tp+kiQGtCsW1H6l57k9t/sSr8rQVKua3sh+VEw2lM6DxiR1hJ+1Fsz8Gh9wnrkB6PWbAUYoLitXF8NRwHCwJLdiZ096u//N2EUHTrjVEjQvfOicz3EcUh0bxjSVGkhQOurvAJ7KqPnRipAklPecsnbOxzFJr5r+wpe2uLqc1ifp5+BccuQjegOt/4XZpCcesVbkaAHG2Mkh/yVWTaUkQOPHgWvivbe/dY8WonvEHe6Q+g/UNN0EWYI1XTLfljnvAu6RrnXlHvjsdNRvFltQe+/5usGegUbfj6jMUfVyVd6Vw6ig/jHPbOXtvA78HDV5rVEcn7ObVmOD6CZtSbUrqHuZm5YKkpEsKijftEEQdOdK+LgZ4zXmlO2GxrlBh8VqCIG8u4xKrjW9mMDXSB8Jk3shrg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hAPCRSKBhEZfmFUsL+IVVSDf46XE6tOo1kyVPtKI05Yocp5UwOB6LdS7f6tq?=
 =?us-ascii?Q?dqKXtDhVbL2q7en1VZgFqE0jWpdGEfo0LKHFuu3cXQ780isUtKyb1If0mVi8?=
 =?us-ascii?Q?jr4bpNK0LyYcNGQP8AjUj421c1tMv3YQ69wii0fxd0aJjFD3NmYfaleFcWQ8?=
 =?us-ascii?Q?dxzcFMOSy5VgzICCfZ/RLwM3H5Z8LaXA87SAx6KLwNaMeZPQrahc5Ffhy+er?=
 =?us-ascii?Q?35k+SIJWZA6d1t3a9ts549gpiEjP5MPSpSKx3ZfE8kO2Dvm3p4pSFKlatZTY?=
 =?us-ascii?Q?HEVmhtWGif5Z4P4n5tEc8SzmFcyiGwV8MH1i0nwViTL5j7bWBlCUf8YuXzZ5?=
 =?us-ascii?Q?DFrHYMI8Q1PsAPJDWxyRpqNAtwehgBGTMCekaEn3aodBdtlhKbl0xyWoJb3v?=
 =?us-ascii?Q?H9MLF16ZjTx50BW89FWURRYSzpJ4JYOyF7XaPgC3HrSCEjZn/gOEOwcfldb8?=
 =?us-ascii?Q?SnVpqAn1Vlf6yehJRjrWQmxHzt+W5MM2I4SFCvAfgVBpax+Ub0KfdgMLXm22?=
 =?us-ascii?Q?Ne8ikxmmWgpEtA4DCdkDMupOBSTw2LbzuZvU9R3UFFULa4wzQJn7fcBhFZ4O?=
 =?us-ascii?Q?IPjby2hNKRpjbkBHL6ca5KTU3HsdCMNFIFyB7zoe8ASQfkqEA+kRDko97dF3?=
 =?us-ascii?Q?ps9TxW0N7mS7JaO2YW/G4ooMleVrQJVEEahN9kNSdzMK6DR1CCmg9tskZBK7?=
 =?us-ascii?Q?4368Dkq6Ng964wW855U9dyIBQ6s6Iiw28qDoZuF+AcowIq/2TTUjbRYAD2WG?=
 =?us-ascii?Q?x56HuIyLbffgo6p2RLwICXsUXcmEG8TuO6sj8bb1Ayf/MhwwwYIWW3PpL6mo?=
 =?us-ascii?Q?juYvjSkZyQ3DPZrtRDtFt98WE50r7GPxPUscnU1nLGfdIbuSlRXjjM77YKcq?=
 =?us-ascii?Q?cnPNp9KSrmyBYsdeptNJHWfYAqb+Jg7kFwohlcyaaHY8ljvpeGFaVkzlXmxK?=
 =?us-ascii?Q?Ymyq9BorqbQpP1xhq8Tbwzfi5cV0ihPAR7CztyZ1FuBJH2vkqDXYDKvv3Y4i?=
 =?us-ascii?Q?ThXztj2VR/60QMZv0rvgomyJv9TcirlU9iVz0orJUStFUr87b/a5QVEmYB0D?=
 =?us-ascii?Q?7aNejML4zecWvAvl4m8G2Tl3LEekREr9DcH9TpxLSmlOe9sVN4//w+lxbGhm?=
 =?us-ascii?Q?oZaGGjQJGRflllfzM8Zr2UK/EJ4NIVzacOolzEjvWbgN9foTnMxkGbjEU9fg?=
 =?us-ascii?Q?K3V54lv7XfdloeEhCUdvZ29WAQQBPpZNTsPHH3rOYKpFuY0n/l6sFDXXjuCq?=
 =?us-ascii?Q?US1yRnPEv9S/+vGEWw+kKNoPdlu+DVhrzPGYlTJXgY7GAVGPHIrqw33RSijp?=
 =?us-ascii?Q?QOAABjwnYMgHRpA1QmowzRENxgkzTvGK+ZPo0sk5nAW9oDeAd7HdjsHpaYuz?=
 =?us-ascii?Q?XvAYheBYgtTJLXOhiKTDZ+/GY8PHF1rzIQ9Tl4r0y8jhcMpMx5dVDsy5VNmE?=
 =?us-ascii?Q?fLwfP0jzfqnab2fTSBNl++CiZok1D8rq7D7pWQeDe84eoZO3QLKp10hwflx/?=
 =?us-ascii?Q?0KdU/o/xTEjitg0pQtaLp/UxtrMWAkOagJ4g340MsGLNWZgUyQUfTUNtPGWs?=
 =?us-ascii?Q?eewln95E8b7oZsyPmFZ55O+yTGgAYS+0W74m31qN/u6OdqsGySLSspf4cX35?=
 =?us-ascii?Q?51NVE6EvM3CHYgvhGHr6YmijrF7ja9FzFzvbuKM6xHqN3/tVdqiFIYydsCki?=
 =?us-ascii?Q?L2Mw6MWxdxzysEarCJpOlij9rhzJ1nyNdI3wShlb6yiFrfKIJqftx3gekc6v?=
 =?us-ascii?Q?4vFMdn7MBg=3D=3D?=
X-Exchange-RoutingPolicyChecked: tvsiT8La/qwfwCQkWP4P9hQCJkXiPPwoifFNJR0MqvSeBSzNhfWmYOJkVTi9ePaSyLNLOWrLRPBlS353aUMfGOq5ymjnW1DlybiyfYataLANzQmtlLvP3D/iDiwQL8YFg6yi05UuzWGxVS66bwQaiiuEZ1EpsKAAiGHkk3pWo+borDkdxEkEKdWvI1s+mwp0UmbfmbBgZ2r6lAb5mC7Ny43Ldd5yFeQAAxZM0xDenBCwvx/z3Cav2G9ilNHBH5WAv5IwG77Z1E/881CnkHaOZOHZBKES4r1x53lTsxjQIHqzCStPYfP/GZ+EAJXu4dHINDvgEVPuNqek9jtbVDKjpA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 979a8e8e-82b1-43c5-edef-08de7b41e7fa
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2026 05:33:32.9749
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6K1RgSCZHbHg4q6/cOqTvLGByESxnTWpvbE4w7C8Qbd0kd1E+GR4swBA4DT/7Bf325NEopexqnOVLDmyfNG+XQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4640
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: 4985221BBDA
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72986-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,intel.com:dkim,intel.com:email,intel.com:mid,zytor.com:email];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[18];
	DKIM_TRACE(0.00)[intel.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chao.gao@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Action: no action

On Wed, Mar 04, 2026 at 04:58:14PM -0800, Sean Christopherson wrote:
>On Wed, Nov 19, 2025, Chao Gao wrote:
>> On Sun, Oct 26, 2025 at 01:19:03PM -0700, Xin Li (Intel) wrote:
>> >From: Xin Li <xin3.li@intel.com>
>> >
>> >The CR4.FRED bit, i.e., CR4[32], is no longer a reserved bit when
>> >guest cpu cap has FRED, i.e.,
>> >  1) All of FRED KVM support is in place.
>> >  2) Guest enumerates FRED.
>> >
>> >Otherwise it is still a reserved bit.
>> >
>> >Signed-off-by: Xin Li <xin3.li@intel.com>
>> >Signed-off-by: Xin Li (Intel) <xin@zytor.com>
>> >Tested-by: Shan Kang <shan.kang@intel.com>
>> >Tested-by: Xuelian Guo <xuelian.guo@intel.com>
>> 
>> I am not sure about two things regarding CR4.FRED and emulator code:
>> 
>> 1. Should kvm_set_cr4() reject setting CR4.FRED when the vCPU isn't in long
>>    mode? The concern is that emulator code may call kvm_set_cr4(). This could
>>    cause VM-entry failure if CR4.FRED is set in other modes.
>
>This has nothing to do with the emulator, KVM will intercept and emulate all
>CR4 writes that toggle CR4.FRED.

I think I misanalyzed this.

For normal (non-emulator) code paths, kvm_register_read() drops the high-32 bits
which ensures CR4.FRED won't be set outside 64-bit mode.

Looking at the emulator code again, the Op3264 flag and
fetch_register_operand() will also prevent CR4.FRED from being set outside
64-bit mode.

The only scenario where CR4.FRED could be set in non-64-bit mode is through
userspace VMM's CR4 writes. But, KVM currently allows userspace to write
invalid values anyway, so this isn't a problem.

>KVM also needs to enforce leaving 64-bit mode
>with CR4.FRED=1.

Yes.

