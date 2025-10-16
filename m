Return-Path: <kvm+bounces-60128-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BF77BE2439
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 11:00:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E67B619C0BDE
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 09:00:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E51330DD3F;
	Thu, 16 Oct 2025 09:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ni4cTuSm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 588F31A294;
	Thu, 16 Oct 2025 09:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760605216; cv=fail; b=k99d7SxWwyKVYFyHSl+0mYNHXvbsSz8fQKdz+c3bPjTvloOu53ocugHdIWUcwkU9XyWz5GD6DlnLObUewjRjPGksSv5uW1AwMT+KPvgyND0TP6SjkbYW4EnG++M0/qK4I/K9YbpOnBgFt+SKE0YdmFTLDkjuENOyCkEXViax3cs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760605216; c=relaxed/simple;
	bh=zrV3K07P5nIsqiKjz+k0h+bSn9AUTgE6UjTFhsHdw8U=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Wk0bmJ022AK/rarbyzhKyMLj2T5cT+aowqH+wjY2gWdvT+JYqXZHTDFz6ZYa2IllawtcHeVoBUh8oEqGZX9Kj36VCow9Tbx6cHa5EV9y/tRSNisKDUqlxF5IldDQ6Uoc3B2LTuVe23/0FdAOUcblo6Qj7hAA6hkjmZueFarIFOg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ni4cTuSm; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760605214; x=1792141214;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=zrV3K07P5nIsqiKjz+k0h+bSn9AUTgE6UjTFhsHdw8U=;
  b=Ni4cTuSmDUPYQ16yveI0ptc8vtiGu9fpPye2KTOKtlELzJ/Hn+NRkN6h
   gvW7QOsX7bseip2FYN5J4HEzVQjpiGd8FXJionVKgwbrlzv7zB228EipE
   8RdoG0wJzNaiFOPbuevAgwALouXtzZCic+K5J17OB+XWIX9thUE6WDise
   IKhRLtc5reL+Yk0RoEgfCS38oZv9CM9r0vpiUlI8eb6JqBnqGFPagEJEF
   6DnCW1NKnT0YD0ga5qz+Ii3oxN2EEUa51KSbwawSv74AVNkenZd7ALAYB
   rC2hl62sDqdqKGsaels85WWwA9Ejn8j1YNsi1GiIPTRg6COx7R7tvF1cX
   Q==;
X-CSE-ConnectionGUID: S/GJIbRtSeyWNm7NLXRVlQ==
X-CSE-MsgGUID: FcNrR2sdTkKqLCVqcEuRPw==
X-IronPort-AV: E=McAfee;i="6800,10657,11583"; a="88261072"
X-IronPort-AV: E=Sophos;i="6.19,233,1754982000"; 
   d="scan'208";a="88261072"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2025 02:00:14 -0700
X-CSE-ConnectionGUID: eqxJr6dQREmBSOC4J5rEnQ==
X-CSE-MsgGUID: fg0V+8iCQ+WYN8M/PXDIPQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,233,1754982000"; 
   d="scan'208";a="182079387"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2025 02:00:13 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 16 Oct 2025 02:00:13 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 16 Oct 2025 02:00:13 -0700
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.51)
 by edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 16 Oct 2025 02:00:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h7/Oy1UTM1Z0r6oWy+0z9Po/a/oryF8ZlNsLWt/elc2sZ1ZNbeAYVuPe7Bs9t3dlxF6Y3KnCH/tyAU1O6XLp2GLUT1i9FtMuvH44mnLamTDhQZrvANXXYuuStNHTcRsfhLTug68YxhNkPXTG2kZgZFTnMmzK2S7xdLxwQfhlFBpUt5tt5Mz6ER6EH78AHGeiIluoCDO8h8mpLWtQfsninW7wxZzprn6MoauajXkP3Q+vuPzfQNzX4kM2SbEYEzl4P3na+CmoMumAvyVQeXGXX/2gDtWYdZtTElMS0SMxtNh8NAfUacBJ4+Bp/5uKEty1PsW6aSqF8wvC0CEUtiCnFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wcPJoPQfmNxxHlwzySh8lAj0PWGJbWiRkoPTUcBUzyo=;
 b=sqqhCm1jynTsmOLxxVsAth55od2WKCHnfTujhbdKj/52M+xzS3qvfhpUBG5Vph3315ZT1lpY8gTXZQAHRLRtIDqF2+yx376Q1nDOiN9ikyINLWH+A+V6aCNJyFpgjP6rryQVQhhu+MdAHavr684E6BnWiaNKxMOzYQL8gX9d68xcFwoCd0ik/9yG8fefyk4hGAciSiceTxoV+FkgTggpUgq5ta39SmILwnA8a92vXMGa+rhac3j4cAwA/n5Sg4O99i6nPe6TOz6+pWJcn6zrC927yShebeRwyV9VK6XDQ2haJboIES9Xlju3pW5yJzXPvV5SXJwiBdXcKBsAc5bf+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH7PR11MB6428.namprd11.prod.outlook.com (2603:10b6:510:1f4::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.11; Thu, 16 Oct
 2025 09:00:05 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.9228.010; Thu, 16 Oct 2025
 09:00:05 +0000
Date: Thu, 16 Oct 2025 16:58:17 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Xiaoyao Li <xiaoyao.li@intel.com>, "Rick
 Edgecombe" <rick.p.edgecombe@intel.com>, Hou Wenlong
	<houwenlong.hwl@antgroup.com>
Subject: Re: [PATCH] KVM: x86: Drop "cache" from user return MSR setter that
 skips WRMSR
Message-ID: <aPCzqQO7LE/cNiMA@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250919214259.1584273-1-seanjc@google.com>
 <aNvLkRZCZ1ckPhFa@yzhao56-desk.sh.intel.com>
 <aNvT8s01Q5Cr3wAq@yzhao56-desk.sh.intel.com>
 <aNwFTLM3yt6AGAzd@google.com>
 <aNwGjIoNRGZL3_Qr@google.com>
 <aO7w+GwftVK5yLfy@yzhao56-desk.sh.intel.com>
 <aO_JdH3WhfWr2BKr@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aO_JdH3WhfWr2BKr@google.com>
X-ClientProxiedBy: KU3P306CA0002.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:15::20) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH7PR11MB6428:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f5f9540-8e26-47fd-3cf0-08de0c92662c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?WBKO8iqSEJ9o7HeWXYtKRlK20BnHgSoOdpkZt0s9ugYxLmSGFs5wEbM/wm7Y?=
 =?us-ascii?Q?s1NZhO9MprYju/9qsNDw7fTGAazqv0imHxneXvveEAsabyDqTBUrdtYpkMF1?=
 =?us-ascii?Q?JkNbYmZH2awSTgohSG4qznzKRoo04Il5Ct9v4Di+9aVQaWvWo/r/XfUMQMJu?=
 =?us-ascii?Q?0UR37NC/szm7Z9FlNPLbe0/uiFSk6hJGBuDMMQu0sqTVQpKJaxp+dw7oCd5w?=
 =?us-ascii?Q?x/JLAZ2D8hXGqxaRZitkIGEctv1oFYPZd5gmcZA2mXY+yfWE0+mYxZUpAChv?=
 =?us-ascii?Q?tihjXcTUJi6I0nCS0xAzKwbi6PEbPWrhdAcRKHYoC0r5tRczHA/ZSYEHgugv?=
 =?us-ascii?Q?VBKT6MPQLdkCAMjLBit7pOxIQ4MzDrD0fdCl4h1dkLyTHXXB+5eEcyXQ2njg?=
 =?us-ascii?Q?E729MNxm5Kc33TbB72CyVWEZ1mpMz0TmXthJfzzAPC79ctFqcfGtR84eLCH+?=
 =?us-ascii?Q?E4/p4LW3AhMN74XMIvY3A84vn3XkU8b5jvt7kthM/eGGyNh4SGzP8uCX6Qao?=
 =?us-ascii?Q?ecyaARORnEN72TdPtdH3X0Fu91H7DO9BU8dhKo5eTS6a7xQVxN6yU2F391hL?=
 =?us-ascii?Q?TOTyWX9jMU3XNST73ZDyj08YPwv+Yvbnm5zzILBVNcc6yERb78ldPgyjFEjw?=
 =?us-ascii?Q?WFMfe5jbam0x1Aem+Ahtoc251OqbdLMaKX3gRfloUbbh02DiHJYFoKq7NAMz?=
 =?us-ascii?Q?eNvZ9AIk8k5mbKZzWEsAboUyinh978YrThjk5oMJzLyrj6cCLri9Fv43hJiB?=
 =?us-ascii?Q?u8+or80+mdsn8iUxT+bkVu/VgEs8Ou4rBMWSbxNmrreiHL8U+PYzn4cKtzty?=
 =?us-ascii?Q?EFcKHtEDFICP27wKO+LxCLJFaJw/wsWzEyZ9fuCE27kk2hDQhiDw/VrP6rgS?=
 =?us-ascii?Q?XUPP0sti0mu4acNP9AevBUCXMJOZRJ3Jl4MJkWTSvzwtCBoDKwbR81EjmgrM?=
 =?us-ascii?Q?SaoZpXiCQGZiMrgkRIngKnLe4YasML9Jv0pBSTry0MTDfwZjGsrcYnl++6UB?=
 =?us-ascii?Q?H6Bbn8EfuDpRWAReZpGPkY12FOy7Bdt68Y8nBC4Fk1MrQhzs+ECtLO3Fp2gm?=
 =?us-ascii?Q?M1ab+sPGpb3kEwx0TKnqvDY2h5ZkhEjOwWmPzWVlQ8mm4H37BpnLWtSt5Ktm?=
 =?us-ascii?Q?A61sQVeu/bidx94zuc5Kk6Ri1TErxD8UTuV1VlsuojXLEpaEnFRVToTR9hQw?=
 =?us-ascii?Q?sWmN5G7JrxsNvavWxg4r4wdkkocfbUAAGhesUSw766tCUjncWA1ocy5SSCWb?=
 =?us-ascii?Q?CMsJNp/EDPjVu8VbDXuSu0F8krGgZWSUKrfMq0X9ympNg8F8QrJLX4PoEp7l?=
 =?us-ascii?Q?r7dHWS4ycF+5F5vmiOsSsxBaxyKQHm+LhcBtMQjKH54/2a5wJrLKVyMC6Kg1?=
 =?us-ascii?Q?X+BdaZvgqiIlAmS4+04wkOK2lPJDfzBsuQ29lVIsgpdEAEtjegJi84F2jweU?=
 =?us-ascii?Q?zHUP4Hj9V4Y=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hyTu5b2NR5DNl+6ui0rOTZVZcIFLuXcQth7DkeS4XOLlIrPn3q8FI6Sv190T?=
 =?us-ascii?Q?PqH9/XcCAaj/TUygUl8k61XFRn6NI+eWFcju8onNxTaWxF8YUEvoHflMHm7P?=
 =?us-ascii?Q?YoRe3XgjDr7ApKu5vBJjB+/j9thpAG4x7ebBJ81elrRLibFvxBxKm7n3tlsS?=
 =?us-ascii?Q?z3VhiW4XK11U7e1ldsTSzncolMw+5EHUKAaNHiBkfce/8ozNlJh9sbNO4/Ni?=
 =?us-ascii?Q?G8CVJ8rQJqR5YKlrXWEsoY2Poq44kUxJSs1UFHs4qlgvS1yLZVBl7AIrQzIp?=
 =?us-ascii?Q?SEy2rrYa2A4HcyC06pm8hatcvPqrAnpRLjjvQE+x/9WckWFS4xa30lcBgNKz?=
 =?us-ascii?Q?w9lbfEb4GMaaHSYJKP6ajVn/uZxcXEVEvJh6L+5YrBjqPGx29S6rOCQTnXxT?=
 =?us-ascii?Q?4pnpgknG03996IDk3tKh+lDo1rqDDZiwDWBm5CauUXVfiMqRG2vgmRFIwkdA?=
 =?us-ascii?Q?uQmq9RUQ60DknRIFaoe4G9Zvo2pVPtYXHk1hut6KiH2VYoZGGSdfCHEcPZEF?=
 =?us-ascii?Q?f1Icbc2tX1ix5hJCwN79qUCzCEUDrFuBD/gr4ElEPNpK/JNt0AfmJGz2HM2A?=
 =?us-ascii?Q?zyfxJbK3QZGfartMOI2lEg92mLyGDOukSgcK2hfxd9u1SWGx6EC/4Qojs3dx?=
 =?us-ascii?Q?5WDx7jS7aiznTt6hwpGK3D5eNSgJsTk8hqfmCORHYLq1aoFWqe23tJd4GZre?=
 =?us-ascii?Q?L/DOSEJjK0BXQNkzCyWZ+2nakJgNI0TG16yHGpmPU4CFo3rmvdcikufrSylT?=
 =?us-ascii?Q?I39IfPDBRoRVlkT2qyYWpT1Q9vyE3J0TVHDnsM0t/wAsOTzjuZajXUHcput1?=
 =?us-ascii?Q?xlLoSF56fbxKtl2sFeq+8TpcWPyaqaCimbhXhm2OLeRNHkErJv03Ln9JS6oW?=
 =?us-ascii?Q?n6Alfw4/e3MibIpYN+NSRyUZsjZQtLdvjLUnJC6xutbPZjcOrWS4IGBxqHB5?=
 =?us-ascii?Q?TwviP0oDdOPJXN2gNlWX69aLp49vNH/w/tu698McdWihrngp4qVPfC7QCKQt?=
 =?us-ascii?Q?gSRhwQEefH5qwMKG4q4CIWO1cllLddZzRY1M+2yZW431ketednfRwZYKLfMF?=
 =?us-ascii?Q?yKupLuOGn8fVkM03mrcBHc5WXMqBKeogoiMO+4mqi6/ZJd1haoeSUr/Ny6Ep?=
 =?us-ascii?Q?HWgQcL0vzkkqa4hssJo34fhDxn+mpro9DuagUDIC7yZxsqygFcrNe6IsaCPN?=
 =?us-ascii?Q?6u5i/oxMcE6V0kGv2Yf7XQ4Gtc40NhER8agGFGmq1bzRjstPQ6EVB0xKYC9m?=
 =?us-ascii?Q?2eu57ud2zF8bVD2FiZtaw/NEU/P3FUT67TasBux9lnXwVVnUuaHd35qlZsqE?=
 =?us-ascii?Q?kQCcmGt0wrARWR5s0z0oqJMDeVUJaEPRxASTBRklN8FG1rE/b3EzLgg/0N20?=
 =?us-ascii?Q?UlUyVkAzBnudzawi49sn0c1nAr2NgUPBkrc7TRMT/KFvJHF6TOTFR2OO57sP?=
 =?us-ascii?Q?r9870XtY19Bv9ORb8sMWdKtqZVR7LQ+/ncGttzPuuuklVguqLZO1rn8s/DLh?=
 =?us-ascii?Q?5t3UNXMTXMePMfd2ksO/crLz0+ioYuOqBEOCO1D7SJ1CuN5jfwPxDXfXsa1H?=
 =?us-ascii?Q?ajhHfxNWQMfhAVGxKcbxN0w+aY075OPZ3JbY5IMT?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f5f9540-8e26-47fd-3cf0-08de0c92662c
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2025 09:00:05.3972
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 58EpWg4OjfvFHR36Sa6aUG0xmL5XfbLtr9KGuCHmHQXycDlLzs309eicKtmat0jY3r7jvwSqxruhqvzrWQxeKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6428
X-OriginatorOrg: intel.com

On Wed, Oct 15, 2025 at 09:19:00AM -0700, Sean Christopherson wrote:
> +Hou, who is trying to clean up the user-return registration code as well:
> 
> https://lore.kernel.org/all/15fa59ba7f6f849082fb36735e784071539d5ad2.1758002303.git.houwenlong.hwl@antgroup.com
> 
> On Wed, Oct 15, 2025, Yan Zhao wrote:
> > On Tue, Sep 30, 2025 at 09:34:20AM -0700, Sean Christopherson wrote:
> > > Ha!  It's technically a bug fix.  Because a forced shutdown will invoke
> > > kvm_shutdown() without waiting for tasks to exit, and so the on_each_cpu() calls
> > > to kvm_disable_virtualization_cpu() can call kvm_on_user_return() and thus
> > > consume a stale values->curr.
> > Looks consuming stale values->curr could also happen for normal VMs.
> > 
> > vmx_prepare_switch_to_guest
> >   |->kvm_set_user_return_msr //for all slots that load_into_hardware is true
> >        |->1) wrmsrq_safe(kvm_uret_msrs_list[slot], value);
> >        |  2) __kvm_set_user_return_msr(slot, value);
> >                |->msrs->values[slot].curr = value;
> >                |  kvm_user_return_register_notifier
> > 
> > As vmx_prepare_switch_to_guest() invokes kvm_set_user_return_msr() with local
> > irq enabled, there's a window where kvm_shutdown() may call
> > kvm_disable_virtualization_cpu() between steps 1) and 2). During this window,
> > the hardware contains the shadow guest value while values[slot].curr still holds
> > the host value.
> > 
> > In this scenario, if msrs->registered is true at step 1) (due to updating of a
> > previous slot), kvm_disable_virtualization_cpu() could call kvm_on_user_return()
> > and find "values->host == values->curr", which would leave the hardware value
> > set to the shadow guest value instead of restoring the host value.
> > 
> > Do you think it's a bug?
> > And do we need to fix it by disabling irq in kvm_set_user_return_msr() ? e.g.,
> 
> Ugh.  It's technically "bug" of sorts, but I really, really don't want to fix it
> by disabling IRQs.
> 
> Back when commit 1650b4ebc99d ("KVM: Disable irq while unregistering user notifier")
> disabled IRQs in kvm_on_user_return(), KVM blasted IPIs in the _normal_ flow, when
> when the last VM is destroyed (and also when enabling virtualization, which created
> its own problems).
> 
> Now that KVM uses the cpuhp framework to enable/disable virtualization, the normal
> case runs in task context, including kvm_suspend() and kvm_resume().  I.e. the only
> path that can toggle virtualization via IPI callback is kvm_shutdown().  And on
> reboot/shutdown, keeping the hook registered is ok as far as MSR state is concerned,
> as the callback will run cleanly and restore host MSRs if the CPU manages to return
> to userspace before the system goes down.
> 
> The only wrinkle is that if kvm.ko module unload manages to race with reboot, then
> leaving the notifier registered could lead to use-after-free.  But that's only
> possible on --forced reboot/shutdown, because otherwise userspace tasks would be
> frozen before kvm_shutdown() is called, i.e. the CPU shouldn't return to userspace
> after kvm_shutdown().  Furthermore, on a --forced reboot/shutdown, unregistering
> the user-return hook from IRQ context rather pointless, because KVM could immediately
> re-register the hook, e.g. if the IRQ arrives before kvm_user_return_register_notifier()
> is called.  I.e. the use-after-free isn't fully defended on --forced reboot/shutdown
> anyways.
> 
> Given all of the above, my vote is to eliminate the IRQ disabling crud and simply
> leave the user-return notifier registered on a reboot.  Then to defend against
> a use-after-free due to kvm.ko unload racing against reboot, simply bump the module
> refcount.  Trying to account for a rather absurd case in the normal paths adds a
> ton of noise for almost no gain.
Thanks for the detailed explanation.

> E.g.
> 
> ---
>  arch/x86/kvm/x86.c | 29 +++++++++++++++++++++--------
>  1 file changed, 21 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 4b8138bd4857..f03f3ae836f8 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -582,18 +582,12 @@ static void kvm_on_user_return(struct user_return_notifier *urn)
>  	struct kvm_user_return_msrs *msrs
>  		= container_of(urn, struct kvm_user_return_msrs, urn);
>  	struct kvm_user_return_msr_values *values;
> -	unsigned long flags;
>  
> -	/*
> -	 * Disabling irqs at this point since the following code could be
> -	 * interrupted and executed through kvm_arch_disable_virtualization_cpu()
> -	 */
> -	local_irq_save(flags);
>  	if (msrs->registered) {
>  		msrs->registered = false;
>  		user_return_notifier_unregister(urn);
>  	}
> -	local_irq_restore(flags);
> +
>  	for (slot = 0; slot < kvm_nr_uret_msrs; ++slot) {
>  		values = &msrs->values[slot];
>  		if (values->host != values->curr) {
> @@ -13079,7 +13073,21 @@ int kvm_arch_enable_virtualization_cpu(void)
>  void kvm_arch_disable_virtualization_cpu(void)
>  {
>  	kvm_x86_call(disable_virtualization_cpu)();
> -	drop_user_return_notifiers();
> +
> +	/*
> +	 * Leave the user-return notifiers as-is when disabling virtualization
> +	 * for reboot, i.e. when disabling via IPI function call, and instead
> +	 * pin kvm.ko (if it's a module) to defend against use-after-free (in
> +	 * the *very* unlikely scenario module unload is racing with reboot).
> +	 * On a forced reboot, tasks aren't frozen before shutdown, and so KVM
> +	 * could be actively modifying user-return MSR state when the IPI to
> +	 * disable virtualization arrives.  Handle the extreme edge case here
> +	 * instead of trying to account for it in the normal flows.
> +	 */
> +	if (in_task() || WARN_ON_ONCE(!kvm_rebooting))
kvm_offline_cpu() may be invoked when irq is enabled.
So does it depend on [1]?

[1] https://lore.kernel.org/kvm/aMirvo9Xly5fVmbY@google.com/

> +		drop_user_return_notifiers();
> +	else
> +		__module_get(THIS_MODULE);
Since vm_vm_fops holds ref of module kvm_intel, and drop_user_return_notifiers()
is called in kvm_destroy_vm() or kvm_exit():

kvm_destroy_vm/kvm_exit
  kvm_disable_virtualization
    kvm_offline_cpu
      kvm_disable_virtualization_cpu
        drop_user_return_notifiers

also since fire_user_return_notifiers() executes with irq disabled, is it
necessary to pin kvm.ko?

>  }
>  
>  bool kvm_vcpu_is_reset_bsp(struct kvm_vcpu *vcpu)
> @@ -14363,6 +14371,11 @@ module_init(kvm_x86_init);
>  
>  static void __exit kvm_x86_exit(void)
>  {
> +	int cpu;
> +
> +	for_each_possible_cpu(cpu)
> +		WARN_ON_ONCE(per_cpu_ptr(user_return_msrs, cpu)->registered);
> +
>  	WARN_ON_ONCE(static_branch_unlikely(&kvm_has_noapic_vcpu));
>  }
>  module_exit(kvm_x86_exit);
> 
> base-commit: fe57670bfaba66049529fe7a60a926d5f3397589
> --

