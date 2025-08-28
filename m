Return-Path: <kvm+bounces-56027-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F01F9B39374
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 07:57:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AAF6A174740
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 05:57:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B0F82777F7;
	Thu, 28 Aug 2025 05:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nxIv+31n"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FFCC4A02;
	Thu, 28 Aug 2025 05:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756360634; cv=fail; b=KMOEHdjneFv4nnUVcyweN4cgd6S/M/HhovgLAJArKySQYbMGT1vbSczt+YT4tIOTbquY7nfKmLFKAhRNFDx8Q08RWH0iMck4MxrkJY+qYFcPsQ+OfGSjKq9839sE1qfHW6Vj5JtmsJ/hVw7lzNI2NldvkrV01+T7kY32x2jNGNs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756360634; c=relaxed/simple;
	bh=lIUgGY+fWLYEmEWvcEhmorZVIYbrvpwRM695KbhRyM0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=g87FY9Z9veqs4cYU19gW+B1/oY/FQPL6E/b17zaIKoN06b/vB1Ga+oW5l65g61cJ458kqDpBIe8UsEu9sLfooLls/zCerwSNNVtqhh9J7jiU0InA+56eYThFX6KrurLWQP0XRbnAI2CRz0K6mLFVaGBRWPagEFzoV3pmuc1ju6Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nxIv+31n; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756360632; x=1787896632;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=lIUgGY+fWLYEmEWvcEhmorZVIYbrvpwRM695KbhRyM0=;
  b=nxIv+31ny6rpztu/TYco0niO3YyhFs2fgI8ieqy9zW4zhVclBvAyy+YS
   QXIDbyOFXVRKaCVe5TeaXW/V1Et/7u62ysmGtZAMwKaOBXzxWhjweAJO+
   6RX3ncHtv/yDhsiaoq0SIo8V1/Z/uckkDMP7dYL1yvUvz4lrUVJv45Z3w
   JknZtFzRP2bc+dziGMFIBwvVyn7+xy/IKVefwvkgr+97qG+5iFxdhKma5
   hnPeURoktlOR65P28rW02T+iSEUPPgKtsJMygaLQLKmj7ZA06Z4VpaSwy
   14T9R1txQcyf/o08WccN6ecsWmXYuSHTMvfaXJ0xzpPSUgwfWRf0zJ6aj
   Q==;
X-CSE-ConnectionGUID: ANmxS8PHQ7WcDXBtSYKtUA==
X-CSE-MsgGUID: qM7mgReiTIml4JkzsQ702A==
X-IronPort-AV: E=McAfee;i="6800,10657,11535"; a="58471960"
X-IronPort-AV: E=Sophos;i="6.18,217,1751266800"; 
   d="scan'208";a="58471960"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2025 22:57:11 -0700
X-CSE-ConnectionGUID: ENIhsZHpRR2OzgGXbu6sHw==
X-CSE-MsgGUID: R9Jxaiu9SDi31xx/1+8lgg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,217,1751266800"; 
   d="scan'208";a="169928557"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2025 22:57:12 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 27 Aug 2025 22:57:11 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 27 Aug 2025 22:57:11 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.73)
 by edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 27 Aug 2025 22:57:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y/0cehtomhVyZnuzezNxK+6mX8vf9oWw/qZ8LleSy7vXEUJ6tkmoJPBMA0XqsSrcju0fPsaY47u48wn7+WzjCtIuHjIWwwta/q/4bLhbHt9bynElZoZ3huFFCXT/Ex4XEeqBXR+WNYj8KNosMBkOjbHBvc/BkTcZgTI5aWDGqwJ1IczRaTCP/wpQOwm/LbBinCsNRjJ6ZlYvQ6D8q0O6I40BhuCGnRaqvHNEZjX5poH0Sx209uBF6XMJnZPDz0bG78ZWuWEZhQrbgTGOiCDl0kjD/02SCsgP5YYTfFq36z47BukP5pSBf8g85A/UENZLFd4jvFdTo28Uzu+C3qMhTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=foBYI7k5EUEoiUpbTZaL6w3IVIqAQ3AQcfAEwhCsQ1E=;
 b=p62vU+wsnEeoMiA7cKKQLp+5xbBwJgSpiFBu0RQFAphc4BG5vqMm1Dq+MZyoZe1wk8GcImAF6gp9CtgPzA5fGhpIl0mpvH3P/82sIS0B9UETytEyimAUCjWXlRLgS4oytJ2OdR+jfduI2LmsZt2zRdskOOjDnJBPK21RLNroUiAWoe2wzCNHDiOUhVMxEXnZkgT35t2jHBFemh/4fAotJUCGVQ3icCYT2fpTtAWSO0yluvM1QUGf7n0Ww1C7zq/NQOoUjSw1dofiy2wPNFtvKfYQ6xyci2Epx7P8wctRLT0nDyzW4uElQfBCEN4C/+lW7royEXyVSEWyubs1DLa6oQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DM3PPF5AD378C3B.namprd11.prod.outlook.com (2603:10b6:f:fc00::f24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Thu, 28 Aug
 2025 05:57:04 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%7]) with mapi id 15.20.9052.013; Thu, 28 Aug 2025
 05:57:04 +0000
Date: Thu, 28 Aug 2025 13:56:15 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "seanjc@google.com" <seanjc@google.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Annapurve, Vishal" <vannapurve@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "Weiny, Ira" <ira.weiny@intel.com>
Subject: Re: [RFC PATCH 09/12] KVM: TDX: Fold
 tdx_mem_page_record_premap_cnt() into its sole caller
Message-ID: <aK/vfyw5lyIZgdH7@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250827000522.4022426-1-seanjc@google.com>
 <20250827000522.4022426-10-seanjc@google.com>
 <aK7Ji3kAoDaEYn3h@yzhao56-desk.sh.intel.com>
 <aK9Xqy0W1ghonWUL@google.com>
 <3dc6f577250021f0bda6948dedb4df277f902877.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3dc6f577250021f0bda6948dedb4df277f902877.camel@intel.com>
X-ClientProxiedBy: SI2PR02CA0023.apcprd02.prod.outlook.com
 (2603:1096:4:195::11) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DM3PPF5AD378C3B:EE_
X-MS-Office365-Filtering-Correlation-Id: 227ea860-244c-4f00-d80d-08dde5f7b6e8
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?khP6JVaSyhllY4POdolLjeAmdMlTaLRJ6Q0RTVsWBbZ3nOWo6vAWgrWPbA?=
 =?iso-8859-1?Q?gEp4qcGd9emk/+A7k/lAa7Lp5T8QAx6regjL5UWSFLnfzFlyBybEDmYIwm?=
 =?iso-8859-1?Q?KmoaMidnL5Szx5G4A8R6lo1hj30I40ABxd/U6+40FEBSQZBNxuNyoQpKT6?=
 =?iso-8859-1?Q?ck6eir5Xc40uwd3284Cv6ty0+c5nbWLNZ78M1MYhHY/VoMcXKeG636KKXw?=
 =?iso-8859-1?Q?IgsMm3Lk/8jkzaR8i7hfutPki7+osG/naJAwWPh7GeTUtWm9Ks1pAseHlH?=
 =?iso-8859-1?Q?kYySZ4htRpbz1NTjNRtKqF81LMAJoHjjE+z/5dmbq2Syn+PVmK0RydtGE8?=
 =?iso-8859-1?Q?j7ABOV+SsznW3aPK9GN9X2UscxxZskNMGlJbqvix3ZMuJnPHI2Hb7b3g4X?=
 =?iso-8859-1?Q?/9ZADnOKtLpZDTsITb3nVNIkND1PGQjztZIp8s1U3ErtJBL0FTOI2NoEeG?=
 =?iso-8859-1?Q?84CleMLB2VYH6huLwh/5eoi/tdl01Kmm/nQdTtA4Oymp/TAMabpCh5TJ3u?=
 =?iso-8859-1?Q?0xf0FTZuyKPEe0w/sFQnBxU+55Im4CJT36v8Dj9LDc6DjKvQ8q3jP9jKGK?=
 =?iso-8859-1?Q?aiHnUFPxB6lXW4I1msTrvkMsnl+j+lFFVUSKkZ14rRbjRvxplaZuveJxop?=
 =?iso-8859-1?Q?GSTuFxEDfHpUqM+nr1y0PPmoKuA9atckBs3WJmdLgnINxy1GVMnTcyfBZL?=
 =?iso-8859-1?Q?wDfkoIKSu36AnOWk3NO115lTE1OB6OR3rbRbViZvmOraOn773ehoqVesiC?=
 =?iso-8859-1?Q?hwPqfK3SifYY+sVaaYV8YWF9vVlm7FDzhlUPzK6AyYPkXA56juDW2jxgg6?=
 =?iso-8859-1?Q?dpT673OoK6tj6qmCn+hFMxtVRhzgUP7U+6WWE/rMlKLn6BRnute6M3INgO?=
 =?iso-8859-1?Q?syji2fCkSKyTyVvFzvuAuvXdrpjUJUSIvO8uY2r2zoIEPd99ImDDy/ez1M?=
 =?iso-8859-1?Q?luR0Gg+G8flnML9AyYROXgyDATUCkJhmf5BE5fq8ei8E8kJPGePGCf2U6Y?=
 =?iso-8859-1?Q?GkYk1Y4CIDsZk5ws0W0qh0beXH0+cCsjOgwj284c1Hab76TQPNFlyvaw67?=
 =?iso-8859-1?Q?a76zzBYlyjDJ/m/ZjVQ3AECKrCjZEwwsTB+rW7Oxg+eGSohL4wp4allnL0?=
 =?iso-8859-1?Q?eqIBz0wFsMrZc1ws1tSInrj5myxnEhZzRc9Y6RuYo3ywau7kSkXwqUJIiH?=
 =?iso-8859-1?Q?drv8tuDCK7n5fCtwVjNQscchHhjTYeu9918F+T4cQ5aLcKyGdFRR96XqEk?=
 =?iso-8859-1?Q?coZcK9QQiZOt45/61b49CJC84m+CdVkKU64ygnBU7EZAWsTD9BRdiDGiSN?=
 =?iso-8859-1?Q?3dbqsX2VjTyVzkd9CBLHRL7vXQ0DCODJsqZAcatBzyTxlr+3WvgXU0YE5D?=
 =?iso-8859-1?Q?pPkEpg39G1+uXbCiZqxeS2Kki2em0Tk/sorApxu7MCoEDR1gP8DuyYKM+q?=
 =?iso-8859-1?Q?0DyVYeILUU4fjBr9?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?ctTRIZ0wPaRruybBby5LxcQQlfBhOxx9qnzi4ORsguU19b5jR2R/7x0NmI?=
 =?iso-8859-1?Q?zPQwkgwKwzif+XfjKTS+AiY2wlygmCaSUjGWLfiChVYI55lovj8AxWUofH?=
 =?iso-8859-1?Q?pJVFdeqz2hYf+DfImSEpDkGcMZV38hKLhhzYhicd0dvgLmLazsjehlpuzV?=
 =?iso-8859-1?Q?o+EUg7d0V4JgA8bLwgJBNc00BFfAR1PON8KT9g8hpYirt815Vx/jgq+ehT?=
 =?iso-8859-1?Q?mFF8Afzy0NHezzliQCZgELA7WyoVkDIRozDv2J+v8dNTGgvZiyPV+s2MXU?=
 =?iso-8859-1?Q?5eD1lEOHt1qwyf8yQ4v7rfC/Ca3sGTrA1ykJ6NsdzRCLqsptanbVgdWv20?=
 =?iso-8859-1?Q?dcJp0jcgSct7p016SRDYSscdWPx7m+CsITFZrzMfiEEeyeMLouoha1pPno?=
 =?iso-8859-1?Q?GrDBDfhhVeHvzg8KOlyppGJu5HMeR09mzOCTZywCBfpKbCI+9i4ocpJ102?=
 =?iso-8859-1?Q?LhSEjtNbojMdqqDArlpVE7KdsbHHy1ROc+1S53NhS29/60KkduPz+77AJO?=
 =?iso-8859-1?Q?Hfn2uiQ/mnzM7YZW3x0tu/wmbnpW/5AgLptBoFsE4MV2kLJxuUXmo7w9GW?=
 =?iso-8859-1?Q?rnjtsk5d/tok+tbcW5Kmk9nbMWZtIF+bE3nAiTtyBCsVnZZVl+fzSA8zi9?=
 =?iso-8859-1?Q?rIK6P5sC5JduAf+1KF536Ros/8Ge83Pk6yLZIbKHklfeaa9PsCZQOlOqKJ?=
 =?iso-8859-1?Q?ICb4YDU54We9yC8SO+J2ELPqmmQ4riV6ZLTIC3LHLclxA+K0V+fK0sB6dS?=
 =?iso-8859-1?Q?fDUG2qxddBMQpitcsa7eDY4XxvWfNgUlQh+G9PbEzSCsxwuwIfuC5HjFtx?=
 =?iso-8859-1?Q?XdkLByrWnFrkjZQTv50Cr9/gnwKPzox9Rbfqc+G6R7ELYH0IxJnlD305od?=
 =?iso-8859-1?Q?pA+UwiMx/dkJA3MYKGhvw+tfGOqmIBx5iv5amtqn0gcwCV3tbg+1ijzZCo?=
 =?iso-8859-1?Q?tLlqCBF7Lodz8j7F4XvktNUsxoFnwHAAaU8GZgAL3Dcfls/R/cX18rwaOx?=
 =?iso-8859-1?Q?b/x2lj2oqbvyyh3oRQIYFz9Q/FkR08H5LZqnzINLxUQhgbF2oDTHMIYZ5L?=
 =?iso-8859-1?Q?5wlF1EJViTUBuVfdnmP2xVh6N/Zi/OQpKaiiTkFGId8+7pLaoTb9Rv6rfC?=
 =?iso-8859-1?Q?ihhEzZEI+h4wtToIzznSRXqtLan+uaIkLV47CyyA6EBtUpdpyTaWBuXhgk?=
 =?iso-8859-1?Q?7cEaAs836YM3p06CiguuoKufPb/bKnHcZDktXht884QNjypyS+DQCiG8nF?=
 =?iso-8859-1?Q?tt5Gffbo2g+AjT0qqX+h8vb7ocCBlOb95cHMGCZYqEntz7sDs1J/8WCZyF?=
 =?iso-8859-1?Q?kzpLLIGO5Xe08leD5Fx5e4XnIMvws9U6NRZB/ySYAhI6DhV6Bu/sFf4ILn?=
 =?iso-8859-1?Q?aNr2nLobYwBKtchcY+HEhYL6/roibYQpuRPEqzUKTkLTKr4PWvHVC35ulN?=
 =?iso-8859-1?Q?iz3Q0o64OmChACdNfF3CFN2wK+dRXjl+sv/RQaCeYOaAArHUQN5WgWd3AH?=
 =?iso-8859-1?Q?YypjD5xaJYmeZ/a+Gw+RndN0+dXHwWGDWr2CAmap7dOmZPHTkSREPBPEzZ?=
 =?iso-8859-1?Q?2KwDvxpOzVrImCvDJTwFD15rhLeOYdiZhkgjV3vHqGAWSMdCv428bIGEuQ?=
 =?iso-8859-1?Q?jgIgaeVLF2pH+O1K/JeBPRMLknBp1/0rA3?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 227ea860-244c-4f00-d80d-08dde5f7b6e8
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 05:57:04.5894
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iU6hST0MeRUz9vDfHJjwootNCA8FB1ZlP6sNfMgojDbhU8VDEpng+wyC+KmKyiMdoTfgs83ek+AV5FM/J83h6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF5AD378C3B
X-OriginatorOrg: intel.com

On Thu, Aug 28, 2025 at 11:13:11AM +0800, Edgecombe, Rick P wrote:
> On Wed, 2025-08-27 at 12:08 -0700, Sean Christopherson wrote:
> > > e.g., Before KVM_TDX_FINALIZE_VM, if userspace performs a zap after the
> > > TDH.MEM.PAGE.ADD, the page will be removed from the S-EPT. The count of
> > > nr_premapped will not change after the successful TDH.MEM.RANGE.BLOCK and
> > > TDH.MEM.PAGE.REMOVE.
> > 
> > Eww.  It would be nice to close that hole, but I suppose it's futile, e.g. the
> > underlying problem is unexpectedly removing pages from the initial, whether
> > the
> > VMM is doing stupid things before vs. after FINALIZE doesn't really matter.
> > 
> > > As a result, the TD will still run with uninitialized memory.
> > 
> > No?  Because BLOCK+REMOVE means there are no valid S-EPT mappings.  There's a
> > "hole" that the guest might not expect, but that hole will trigger an EPT
> > violation and only get "filled" if the guest explicitly accepts an AUG'd page.
> 
> Ah, I just responded on another patch. I wonder if we can get rid of the premap
> cnt.

I think keeping it is safer.
See my explanation at [1].

[1] https://lore.kernel.org/all/aK%2Fsdr2OQqYv9DBZ@yzhao56-desk.sh.intel.com.

> > 
> > Side topic, why does KVM tolerate tdh_mem_page_add() failure?  IIUC, playing
> > nice with tdh_mem_page_add() failure necessitates both the
> > tdx_is_sept_zap_err_due_to_premap() craziness and the check in
> > tdx_td_finalize()
> > that all pending pages have been consumed.
> 
> Reasons that tdh_mem_page_add() could get BUSY:
> 1. If two vCPU's tried to tdh_mem_page_add() the same gpa at the same time  they
> could contend the SEPT entry lock
> 2. If one vCPU tries to tdh_mem_page_add() while the other zaps (i.e.
> tdh_mem_range_block()).
Hmm, two tdh_mem_page_add()s can't contend as they are protected by both
slot_lock and filemap lock.

With regard to the contention to tdh_mem_range_block(), please check my analysis
at the above [1].

tdh_mem_page_add() could get BUSY though, when a misbehaved userspace invokes
KVM_TDX_INIT_MEM_REGION on one vCPU while initializing another vCPU.

Please check more details at [2].

[2] https://lore.kernel.org/kvm/20250113021050.18828-1-yan.y.zhao@intel.com/


> I guess since we don't hold MMU lock while we tdh_mem_page_add(), 2 is a
> possibility.
2 is possible only for paranoid zaps.
See "case 3. Unexpected zaps" in [1].


> > What reasonable use case is there for gracefully handling tdh_mem_page_add()
> > failure?
> > 
> > If there is a need to handle failure, I gotta imagine it's only for the -EBUSY
> > case.  And if it's only for -EBUSY, why can't that be handled by retrying in
> > tdx_vcpu_init_mem_region()?  If tdx_vcpu_init_mem_region() guarantees that all
> > pages mapped into the S-EPT are ADDed, then it can assert that there are no
> > pending pages when it completes (even if it "fails"), and similarly
> > tdx_td_finalize() can KVM_BUG_ON/WARN_ON the number of pending pages being
> > non-zero.
> 
> Maybe we could take mmu write lock for the retry of tdh_mem_page_add(). Or maybe
> even for a single call of it, until someone wants to parallelize the operation.
Hmm. I prefer returning -BUSY directly as invoking KVM_TDX_INIT_MEM_REGION 
before finishing initializing all vCPUs are uncommon.


