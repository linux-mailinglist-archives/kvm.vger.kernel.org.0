Return-Path: <kvm+bounces-13045-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4202C8911C9
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 03:55:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 993C6B2213F
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 02:55:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB872374F1;
	Fri, 29 Mar 2024 02:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RCCN7w3q"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CDB736AE1;
	Fri, 29 Mar 2024 02:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711680916; cv=fail; b=SZqWNy2JhCybEIhefZbRFUpq3X4gdIiSI4NEbCqa+Z1bGPkjFc/ufkjJO4jTkldKNjrMHWLBdc4OrU2Oe6bEPcsggj1962B6l1RzeuJi6KD0s4TDro6qrD4WS+IcBUMCTxtZIfnyKP6vx/G5LxoLuYvWeC3lnNf1LD3p/l+Z6vY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711680916; c=relaxed/simple;
	bh=qEl0tta2vc3R5b+Tm9ai/nOwLZWpiRgMkFyxv+QdapU=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=I5AIYBHtFtdHRP3KTkDGT3acRW0dwAoL4pA7tmeoJOch6BG6C/lFxJnG7OJKfWlseoj9FwwDyvt1r7Ltz4XA/CxOhf7xLSypqKuBH/AhbU74WQQp8QsboMwLQoIUDUp9tyP8MVZWIPI8nQMGYMLJ8Fpv6fl7MNfRhp2Kit3ySLo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RCCN7w3q; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711680915; x=1743216915;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=qEl0tta2vc3R5b+Tm9ai/nOwLZWpiRgMkFyxv+QdapU=;
  b=RCCN7w3qva33slfuVNxme+fxvKHM3a19mC6pHt7OYkDMEkHFtmSD80FG
   zIIgcWy9ywFCkAwDAqoq2UqWm54guMSPzCNATgn0y8TBsHZiFqPRFraVL
   4Zo9kRmZKd2dxyU7VibdyYxWGxK5+/EOcxoZ7bnl98gEVfedjHxayGWkh
   mkuhRobTaZ7jUwi502No3YkzGhbZxwhNG/BJ3rGS9Sfl0X2MPd+OfO4tU
   ol+2U7Rdrvc/nRQd9z+9vlAAYqjKtBB3j7g7GKflHxPP5z1DbV2aba6qc
   eWgg3VxTTkoTEnilue82vmr24UqnT/AlChRsKpiZCkZ2coRskacYZRIl9
   Q==;
X-CSE-ConnectionGUID: EDJBN5Z9TsqwZ63ZW+JPRQ==
X-CSE-MsgGUID: 0KOEQdrlQfKwPWKcn+VoTw==
X-IronPort-AV: E=McAfee;i="6600,9927,11027"; a="7464279"
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="7464279"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 19:55:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,162,1708416000"; 
   d="scan'208";a="16891469"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 Mar 2024 19:55:14 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 28 Mar 2024 19:55:14 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 28 Mar 2024 19:55:14 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 28 Mar 2024 19:55:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GQ5U6LbFeywjYGGrswma1BF1dVU6LBtrC5JrtLX2QxlVm8y1uVBVHVVnBEr0/zpx2jcOGs8zaExBTCMc2RPEVq/ovqFhop9DA80o01sKZrgpOKphM8vGqZs7ex6z0zOwRs2D3cHr/GCr64cDSaT2l2vn6S1AQN/lyeFGk/tGU5H6jOD+UmndqLgMGKkxjyA4ABH+Btwfsmhs7/h5b8yRRFJ8js2nxBVH3A1StgS/AtOsarEF4EIg5IuW0a7Out1pyXMJHo24BIORmQzbgPUIO41C2GVAYcvihO+UkROdAwyuuMjMWuVTGUJreSFZMNz134HehevaxRAU4mr/SwS5PA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eEpc481vQ+3yptUfer1KKIgcVsNQZmgCVBkh3pasw5s=;
 b=ngqWXZXVBNkJiREgj4lezCQM0BzMBZ6ZPZ40TjQQko8buP15tHrQBJ22W2bTc1/nLC53fEf0CbT2jRqf1TpFl9DNivWftVhOxEjeViy9UM8yc/bNs2qtV70HYTS1Smlsn14g5FvEXXnqNRZUGc3F6zYVJZI4QMDtBBTzwSNt+xQQKmpF9fEWw3hAka8Tk2g4PppWieC9i//REGW9fUIWwYOt9sFcuo+do0sSYBppNuF9WcGKTYifE9jsmzJsU3HkTXXKR3refeDNuk3Bp4apGNIdKlKFT3gNkOan2ZArClXIVjau3NVGx0qYEiZ7JZe10J4p5vtXaPIxky1FC7q9tQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SJ2PR11MB7715.namprd11.prod.outlook.com (2603:10b6:a03:4f4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.33; Fri, 29 Mar
 2024 02:55:11 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e%4]) with mapi id 15.20.7409.031; Fri, 29 Mar 2024
 02:55:11 +0000
Date: Fri, 29 Mar 2024 10:55:01 +0800
From: Chao Gao <chao.gao@intel.com>
To: <isaku.yamahata@intel.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<isaku.yamahata@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
	<erdemaktas@google.com>, Sean Christopherson <seanjc@google.com>, Sagi Shahar
	<sagis@google.com>, Kai Huang <kai.huang@intel.com>, <chen.bo@intel.com>,
	<hang.yuan@intel.com>, <tina.zhang@intel.com>, Sean Christopherson
	<sean.j.christopherson@intel.com>
Subject: Re: [PATCH v19 095/130] KVM: VMX: Modify NMI and INTR handlers to
 take intr_info as function argument
Message-ID: <ZgYthRHalTwRm6AT@chao-email>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <c7ea98e64cee7458e1a09d5aa3fddd1e1f83629f.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <c7ea98e64cee7458e1a09d5aa3fddd1e1f83629f.1708933498.git.isaku.yamahata@intel.com>
X-ClientProxiedBy: SG2PR01CA0112.apcprd01.prod.exchangelabs.com
 (2603:1096:4:40::16) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SJ2PR11MB7715:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WHQXtLp9qsqFyat4KCn5/bP+gQgNIwtgO29Gf883w99tMumtQl3VNQ5l7JG/rK5abmWR2t7NFCSB6TTYVtf417lPTWCveMg8GIa6itDmA8gpTSsGDEY5q8wBIvhtzRWGaLGTTJfPdRMXW1iW/huJZEN9wk1WpfMcUAAd/zWWjDvLBJ8hkHxUjmYEr/HrbL3UFjJsttgWR1bZbXl30p8JSXJfVVCC4SEqsPaVkwofZMPkjTKZ4+PxxZPbeNu+972B+K/MCrYEMTEfxP+oGXPHxECXYE/tKfeliApE/aIEwaoR6G/oJzp9HgGf8mAS/Cg6LtqBA0bVUQPuIuEBvSOsZ29WSdkkLI9l4MoMujO7S9sQSLQlgTtBrNgkpeLPJuLdtA/eGgySsq/Ir40S45llhwmxeK/pjuYWPVwkcOL96vRfQo/sAGnr6e1gR6I72ItQU6VkxTEKJGk6DpK7cssmw+cNCGY7Z278cwHQhO5LJjxwd9O0+dsW92r+GbCkpkqC2p31uUpzqB+imlt3089VYWyVKaHNWvdTOWCAi0AkIDNRA67KAy4ZKoG8fbl7FeSpsGjPzZQ5E6Vehzn4xfTsSJXRlgQcbX7EGZswiqS3wnKbQO8k+tVudPrlow2wBMxg6NSgIvpwd2NwgfE84DWGanaf7UHC7wqU/jfeX+VvrcM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lgz8XXsbciGZTrbSJnh423gI82JmYTR3migAfY5mkCkCXL3h/OPCsKnOLNVy?=
 =?us-ascii?Q?ZLiZ0v0EhI+EaxQt/JjqMeWPaLRHS4AX3KJQwDM9VaggmDo/P17V1I7nqwM3?=
 =?us-ascii?Q?jU5R3zN0n2Jjytn+OgZJZI6CaONTfCl1cnlqHL0iXdm9OdE7rCYIQEZTmGgf?=
 =?us-ascii?Q?gJKwdBKj3wLvA5pBtGnzTolbjN7HV8efAgBpqYsTWrcNGLHpMZq782n6HylW?=
 =?us-ascii?Q?c8oh8ZL2oG5EkW4aDSjvlvABKNo6wzugiccODgN92qje1uK8Zdv+9285gDHa?=
 =?us-ascii?Q?H3t7v3NjAWdTlxtqTPuycnhG93X5gFM08MdYP9FuhSsQ8XLBCFj0l75bzbj8?=
 =?us-ascii?Q?3eaC1j3uVTaRJXcHJWC0Css7hLqCIMdGMUOlBO3filxxBm8O5KogWl3ToKJd?=
 =?us-ascii?Q?7vMPgXFWbn4x9iHdLbkXPjmsupsL99mjxve6cCYmbeIp7755AcbsaBbNHWVa?=
 =?us-ascii?Q?cD9uE1JL9tzLLeV1HfyVkUW8QzNvBLSD+jw1XALX6zYHkFc0QJdtBmsG+HzW?=
 =?us-ascii?Q?EWQhZutr7YiH0QmMp27memq1z/pvkARH3AEibeXAaSmbddMR08wj5p4dKoDd?=
 =?us-ascii?Q?+1q341LK32yPotCJdoQQfroaBof0nD0rXc+QkRlbshxtoc3UMgfpKEk6OpIe?=
 =?us-ascii?Q?HRudODA/XxlJAVrVZ69FbWZd/AoLayD3VSoHPUQpyjQDk4cWZALyupy2lWIJ?=
 =?us-ascii?Q?aICTXYaXn4tq9yc4z5WBsJPViijhnaEhHQeGEuvHL2pgHRm3O9yFk3iTWMce?=
 =?us-ascii?Q?BIoDf35qC94oBfNYwtrpvT1yMVOs+NPWhBzI1kn507FMQ11Er+CKzTRC4StB?=
 =?us-ascii?Q?DiCRQiiXKlltWzcLtFyn89+LimL9OXs12pxN6vwcLj51cEDBKRTjHreOVQXq?=
 =?us-ascii?Q?mofXtccrBPKPPrFm4BBhJxyA3WJncdmCZ8pswWCK5s7anHMY/09QXAm9wndi?=
 =?us-ascii?Q?PxU0D+ZS/iN5Q68nu2BSvY6zCZDaVIs90P+GGKJsWajTakiXhrOpV5EhSl8T?=
 =?us-ascii?Q?edEf1WVdMTYzc2njhxMX0++wzt4CQgk+pMwnr/XQHX1s8N0/5NGwL4P/rIi1?=
 =?us-ascii?Q?VTJhXfWzx3UkEt7aZHjYZwTYcbVpwpSSNnvbfEH3NxOgFQY0PYczjxJWE0Gx?=
 =?us-ascii?Q?pbasnWZUnzIESCNXNWbKLcb7us3LdlIvjZXSN5UhBzWr1aHUdBQjA9DfT8pU?=
 =?us-ascii?Q?nCilO7P8UYP0p0V1f8U+K+TmYGzg6m4qgGs0cPRQSe2BBA17IGX+UkZg9HfN?=
 =?us-ascii?Q?4pIfVy3gSJ44XVskVU592iSadw4F/D7h3pP1J/H0JnCBl90TX3/TLS8CgIhe?=
 =?us-ascii?Q?Xc4gcPJ8Ep/rK28lCbnwMi1Tnky1qXNqzLcX2ltonQfp/Hp3pdm9ZRbc8RFU?=
 =?us-ascii?Q?I62ruPcLoKCC+QDhq/BlGUj7WCfFpA2W4FDU1ICczss0jyrllCHyJQ0L0a4G?=
 =?us-ascii?Q?pUUQ9iigYUlq1+EyAJs2WAr72wK9qE/Rt1XN3lFYWJ/IA2AzO6RKiNrdmRcc?=
 =?us-ascii?Q?YtLXLZt79qu44paqsl1lyHimQ52a/472pNYDZy1CpkVBFZ3JaD0NmGpZYDmE?=
 =?us-ascii?Q?V84jlHudWOHu+daO30PLrZsDMG59iemdzkcHPWQJ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 62d192d8-5b48-4ac9-9af0-08dc4f9ba689
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2024 02:55:11.3559
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iXishBJpZTmklBWy8wlNBciwpJ+Qg03xLf2XyAjNiv0g32jCw5r/vXLdLsLmG0jk7qAC+/wmq5fjDP32rmgKoQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7715
X-OriginatorOrg: intel.com

On Mon, Feb 26, 2024 at 12:26:37AM -0800, isaku.yamahata@intel.com wrote:
>From: Sean Christopherson <sean.j.christopherson@intel.com>
>
>TDX uses different ABI to get information about VM exit.  Pass intr_info to
>the NMI and INTR handlers instead of pulling it from vcpu_vmx in
>preparation for sharing the bulk of the handlers with TDX.
>
>When the guest TD exits to VMM, RAX holds status and exit reason, RCX holds
>exit qualification etc rather than the VMCS fields because VMM doesn't have
>access to the VMCS.  The eventual code will be
>
>VMX:
>  - get exit reason, intr_info, exit_qualification, and etc from VMCS
>  - call NMI/INTR handlers (common code)
>
>TDX:
>  - get exit reason, intr_info, exit_qualification, and etc from guest
>    registers
>  - call NMI/INTR handlers (common code)
>
>Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
>Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Chao Gao <chao.gao@intel.com>

