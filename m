Return-Path: <kvm+bounces-13355-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BFB62894E02
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 10:53:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5EA551F22C35
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 08:53:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54C7251C4A;
	Tue,  2 Apr 2024 08:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YiP66Yvp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE5AD4778E;
	Tue,  2 Apr 2024 08:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712047984; cv=fail; b=BufsiJo+YeF9scAi8tSTOaUzVuUIY2FloxN0Ol/jvx+I6QOo+mQbjt8L7tZiHPq8AxKQuCEhDlguqtufxMQnSVnl5WUNJZf/h4gMB3lPH8MrYlllkLtWU+lM89i8okmAttGYeTHT+JuERoNDrhl4cfvfgSGog/yScy24raFyih4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712047984; c=relaxed/simple;
	bh=dSCEziGDFic31y8YzwKT/HbEkbttIioh73ScuveSlI4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=FS8fYiBTAkxHZLn3v3DcIpgLIIRL1EClcUhihhVdKIGnvqvB39rKDxH3PmleZy7vFJUJ/oswrfzS4TkvFCu7h0OUaIVbxOXfDCUjouAHgPC59jcBL5nt7e6ZA6i1melpKCwBfPytu/GYeGf0Mn7amcbi7DupiR9P+n/b9GHLymQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YiP66Yvp; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712047983; x=1743583983;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=dSCEziGDFic31y8YzwKT/HbEkbttIioh73ScuveSlI4=;
  b=YiP66Yvp5q/TLgP+gYnhQKQcH7XXmwt95gNbyh9yk6m+0fXon8mDOMKR
   P0Pos1tnSHUSe/5JXnybMWmTyODa+IFcI5PlS3PgXUfiGlODxNidkExBj
   6AtwAinzrS7pSDeR/Lr0MvJj9MT0yRkewwITlhHSTUa7Oi0Hju32LjimM
   2rgNEuKh9x3TglJ4dvh2LIV+p7NwPx+un9tXu5LvSWGGp4v+VHp50K00S
   3YmYmnxweDVcGN5Lo4z9P2NfWJ2cWxOyOom80S3ONoykJ24O/GUyATCRb
   VgudVX9d02TP48jgfq7uVH3IKH/W9P+wqMbSySOafTqn3CzMFinSgQhUG
   g==;
X-CSE-ConnectionGUID: Or+j1kkXRhizbVC/7PSJMA==
X-CSE-MsgGUID: dJ4cvGnxRx6TZdXeUBh5EQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11031"; a="17930784"
X-IronPort-AV: E=Sophos;i="6.07,174,1708416000"; 
   d="scan'208";a="17930784"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2024 01:53:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,174,1708416000"; 
   d="scan'208";a="22474905"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 02 Apr 2024 01:52:58 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 2 Apr 2024 01:52:58 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 2 Apr 2024 01:52:57 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 2 Apr 2024 01:52:57 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 2 Apr 2024 01:52:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CopLGe1j3HV8Hg3qYWq7/drJQzB4xA1H0V2q4A9ETAnTUY8qG+RxN0UbnlzDlKVPSER90I89Zaguel+0wHBru+9NUprSysQ0XRJCqq//dppIbMIAzY07vAkpEaMvvqpLgyEjIPK8vZ0i8NNXVO30HWdeO4SR8p26iNd8nwse4dgvWzQaE18nbT/rCDFzLnlwwPn62hsZ6x8LgWGbJE7jhzay5ubD8rf+J/q6PCc3hfWrM1sA7C8oTQdBCyELZpkpepSWC5DHYtb+mI/2vtELZGVaBnj9cfLumrWE26sbatPv3CpmfweXbo9FfDAz9Q20hHWL2p688aGoj1VJThhXnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xbpPE8aHgca/VbPgEgwsgHZCtYlj8VIiMNFTWrl8McQ=;
 b=XD4OL7+LIpW2957xjyB8yt03Ys6KmhfUkGLrIxF2fFpenCqxpICqI9NCYC6eTSswqtfJ+mGKUga6Gy9tvmd3QFRQ3TwtdlhImaE8GmJC+trBh0SCIpO1jCqbVaMlXR7LLrrK/v84pMnXxjU+bJsxy4yAgZWv7JvdnjV9hNVxSL/of7Df6m2z8EjYyJgxMSIYQHpMJI1kc3X2Zjdv1OTcg4MsUeBtemIIcTby4u88mbxXNZa56ZFR8PxuLPdDDtLyVtn8ZlvQDuk0ZtJ6dvGd3qJIUYCVUEX3SPlSAiVnlQvrlqygOPj1miXJ9/sCchcmFffrgcAxF+wOStoosLyKuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by LV8PR11MB8700.namprd11.prod.outlook.com (2603:10b6:408:201::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.25; Tue, 2 Apr
 2024 08:52:54 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e%4]) with mapi id 15.20.7452.019; Tue, 2 Apr 2024
 08:52:54 +0000
Date: Tue, 2 Apr 2024 16:52:46 +0800
From: Chao Gao <chao.gao@intel.com>
To: <isaku.yamahata@intel.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<isaku.yamahata@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
	<erdemaktas@google.com>, Sean Christopherson <seanjc@google.com>, Sagi Shahar
	<sagis@google.com>, Kai Huang <kai.huang@intel.com>, <chen.bo@intel.com>,
	<hang.yuan@intel.com>, <tina.zhang@intel.com>
Subject: Re: [PATCH v19 105/130] KVM: TDX: handle KVM hypercall with
 TDG.VP.VMCALL
Message-ID: <ZgvHXk/jiWzTrcWM@chao-email>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <ab54980da397e6e9b7b8d6636dc88c11c303364f.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ab54980da397e6e9b7b8d6636dc88c11c303364f.1708933498.git.isaku.yamahata@intel.com>
X-ClientProxiedBy: SG2PR01CA0181.apcprd01.prod.exchangelabs.com
 (2603:1096:4:189::13) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|LV8PR11MB8700:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q/hCyoi4BkRhJoRGz4fymdcsjsW9KiqprCJUkZh/tLP2RKGlgdtb+EcDNpoV3adWGG+jtRAKa7n/WL1kxCZJB2Qf7A0VgqEqAWsCbO/bNkyu49lSUt1nWEgvKYreWxGMBQLlGWH5N7XlhUM9QGVAO1ARJLE8Yz0TSFZtyeeM8jlJrc3tJWiERqxQHf87oDTb9GhWRnlIqJS8E1SaklqIsXac0WqrWtuJea8REoxvf4xsgXuk7I7yQDb9B1hY36QKwG2DRKWYzvV7Fe5ytMGfKjEfrWJDyLE0PTFP/DmRCUzf85y93c5iUfe/S4YX/R3VvpuS1lUPD9m1781GiLVexBoyZXJH6Ag0YeSfCmDd+FF3MFZlspuN7kl5T/aiGU/J6Tmdmx8ZEE6K6bJhQc8lNxkJK3ly6u+SmRVGZonRy79uydSYpdRxkx7rHLvfcgX12bzEo0pDO7YK3lyTOqNF3itd6uvWhv0knv23A4lX085tzXWDFUzMxRBVrnJeTEYWNcnjTW3YHDPT8EPNtp2777TK3AgB/viV97HwmlWmQCGFWZMOcDqdoOB8OVzXW8CND26Qjpg+0HO09mGOUiJEudjQLeIexSMKduSfok0vrTlM8GbCC0F4QH4kH36RyhUqjo2kdpQp1PXRwq3u+VU5aDWWuyDxOkeFrIJ0ATddcKA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XR66TyzM6MmCBgjHLfCUO2Zyuz4rfVZjg5V/p2Mn/RFoIbxII1YWuwVw4NJw?=
 =?us-ascii?Q?2fAC44nb89MRLlHs53odMOlLmzjz2zuTHvKhgwYlhrlWSNyLlg5PkUGwEZPK?=
 =?us-ascii?Q?iK4/KxPPH2ZG2QZcJMx9e0dAP6O+KSi/JF8LkVJU9yozMKcpltazK4OGyfTP?=
 =?us-ascii?Q?sozSfMte7GetGbDvfw03883Agh6Z1sPosXhBArcfBjhoHnIWE+km1Zohg253?=
 =?us-ascii?Q?2qwuoVCGGgTftpo+pXm7c35Khnn88bceA513WhwIjWUtXyPk4fgeJG9SXfir?=
 =?us-ascii?Q?2vsCMOLw8At4eaGe+59QF8c5mWlc47RsZSaZlZdYgoM6C+nxm2B8Mw7sHk77?=
 =?us-ascii?Q?Inp34fsWozmRfeo7uxl+1hRvhcsbK/wgwEBsdC1UxYZGI+bn13er/pVVBl8J?=
 =?us-ascii?Q?vuhczFZ4Hyxq/Ocq3hWCYlE1kzkhll5rZYmtkHt5U05ETnxM+2zL8TAxa7la?=
 =?us-ascii?Q?kLj0bqGuqEmTJ6yvPN0R0S+C/caHM5iahmpH68am6y7dR9EnGs5IcKY6GCP6?=
 =?us-ascii?Q?r8OY0vrkc9B1EJ5IBfO0h41sZ+2hkN4P0+5em4DQ50e67NCMa4WDnJj/2l5h?=
 =?us-ascii?Q?PSwoTXldZzoJHvP8NWiJT4+sqktwJMeDW6vDarLCr/xVKwGBnkXr05TpTUjT?=
 =?us-ascii?Q?P5BNxC85Tuel/59d90FaZhIlP1F4orw2OCZW5JULbrwDlKNfB3Qd7X3fZCzN?=
 =?us-ascii?Q?iauwuZi7eN7UQYUWg89jO/mQ/ALGeAlDosN8rzrh50KZBLmk31EtWGUVQJOU?=
 =?us-ascii?Q?5+bk9TRjcBHZJhEWnCo+RfH+W43R71qWdWqiyDbQclzPeGtuJm6HJfJg7a5F?=
 =?us-ascii?Q?P0PXE8QG9DQe5egUBQSFfqeu3l8UVUL3naRotgr4aE4wQjkC0ALI2qCC4/g7?=
 =?us-ascii?Q?n00FPdhT1T7VrCdK4us4o9UhUvPTDX/pR9dYlO5mLPaELlKM1bj7j0ZlRWCv?=
 =?us-ascii?Q?xN542r3xPgVxoovBVDOTov7knZByFGm6bnqZUq8Txg5JzuHbKrr5v+/JTwt3?=
 =?us-ascii?Q?J9w8sjmfMpyVUwZCXw+FVtb/q9e0ZaOk8nRGiv0RLzIdndKr+dhb8zBUek7P?=
 =?us-ascii?Q?yTdUB9/G1jvaIfp1PLzItuGXFWgEvgHyHQT9DK2MyuotOythl79oAC1ITMwB?=
 =?us-ascii?Q?TXP1c5diOoH5cYEOcHHuCwM1ruiBWqBjxXblDN57UPyMbFEwyNnyB0IqjHTO?=
 =?us-ascii?Q?h54b64NP4Mn02Uu0co4m/AQ0gs/2G2AArH/W421khffASLkmHSYXtaxBuAVE?=
 =?us-ascii?Q?kIfU53zGB2LpecZB/g6zYE5N6MIOmG1GMzh34M/a4/1dfF9stsmX/Bxv3ORd?=
 =?us-ascii?Q?5dUULPFP5qO2GV4jfHG8vBOjzh9/Frjj3YKQDd87yfTf4Kg+CIsuo734c7Nq?=
 =?us-ascii?Q?DcrxgKCidYmFIwzAAuq9oJjQzxE9ZBA9J7PDI06uat6kRaqr21jCxxSCulO8?=
 =?us-ascii?Q?RHBVtvXfw0hqNZ84bmbJ8yJ9rBp3Kd6GO7Wagc7xwmxRDGQYD1dEyMxto21J?=
 =?us-ascii?Q?WJHwPiViAQl6OjtCOrg/NkiQ3ZZ29gJeZA1LdsJHaw8h+zSky4HWI1RUGSXN?=
 =?us-ascii?Q?7ncTujEKFOsJAMj2dTkF/kmQ+9Fq8abz9c0a6OBR?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cbf73535-3304-4c33-6a79-08dc52f24967
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2024 08:52:54.8052
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EjVsKh/Zo/YYh+P2idGu9LQe5VF+UEDzJt1FarTsVE37FHAjUZ5FlvXKyMUqM+af0Ks2MjudT56bTScga8PzEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR11MB8700
X-OriginatorOrg: intel.com

>+static int tdx_emulate_vmcall(struct kvm_vcpu *vcpu)
>+{
>+	unsigned long nr, a0, a1, a2, a3, ret;
>+

do you need to emulate xen/hyper-v hypercalls here?

Nothing tells userspace that xen/hyper-v hypercalls are not supported and
so userspace may expose related CPUID leafs to TD guests.

>+	/*
>+	 * ABI for KVM tdvmcall argument:
>+	 * In Guest-Hypervisor Communication Interface(GHCI) specification,
>+	 * Non-zero leaf number (R10 != 0) is defined to indicate
>+	 * vendor-specific.  KVM uses this for KVM hypercall.  NOTE: KVM
>+	 * hypercall number starts from one.  Zero isn't used for KVM hypercall
>+	 * number.
>+	 *
>+	 * R10: KVM hypercall number
>+	 * arguments: R11, R12, R13, R14.
>+	 */
>+	nr = kvm_r10_read(vcpu);
>+	a0 = kvm_r11_read(vcpu);
>+	a1 = kvm_r12_read(vcpu);
>+	a2 = kvm_r13_read(vcpu);
>+	a3 = kvm_r14_read(vcpu);
>+
>+	ret = __kvm_emulate_hypercall(vcpu, nr, a0, a1, a2, a3, true, 0);
>+
>+	tdvmcall_set_return_code(vcpu, ret);
>+
>+	if (nr == KVM_HC_MAP_GPA_RANGE && !ret)
>+		return 0;

Can you add a comment to call out that KVM_HC_MAP_GPA_RANGE is redirected to
the userspace?

>+	return 1;
>+}

