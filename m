Return-Path: <kvm+bounces-32496-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 354729D91BC
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 07:27:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E99C12860F8
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 06:27:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F0FC17B4EC;
	Tue, 26 Nov 2024 06:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="c5lAkklX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8F8712CDA5;
	Tue, 26 Nov 2024 06:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732602459; cv=fail; b=RZ0dOgegXNhpaR0nV0yMXd/TK5xRqZ5C4TLtebD75dcb7WJkiriXXsWN6sENyx8HxsgVizQLKA+zbMaDNAfBCzLl1Em8Yyz01qyx7LVg/mHTVEGSz1qXg07urDSVl0Bn/wbjzBrNhSR/T0Zqw/RxCp0r8nBUIzKn3Nby2W7eRx8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732602459; c=relaxed/simple;
	bh=P1jCrQrFv///Ploqi8XL8PHhSJSE1XTVkvBaTnoFS+0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=eDEn6uSNmx7Og4nuIQ/2505NtunWYMIyLOcrYSbks2US9wiUNHPjOoI6vFmbyUSg6Bo/OSRymfUhAkpUMnubcUYzDDIsMiMNNI3PVUbzfAidXSUqQjVGe2E07YDHDNnWs3yNRGKhsKsSvE1FANRuuj0ecHAG6e+YUcaQBGDSkew=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=c5lAkklX; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732602458; x=1764138458;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=P1jCrQrFv///Ploqi8XL8PHhSJSE1XTVkvBaTnoFS+0=;
  b=c5lAkklXC/ZBKbjh+eSTGNkEN5kWsUfav8/EUITDoW5biqW7qFODexKC
   2IuIWZuTi4Xb8PDKA26VdsK7mRM7a8XZmqZ46hxZEqatW6yuENUTxnoTm
   l3mp2MZTe63unGKuFHGQSAY7eU5dHo4g55P2GCsixMDmponqsen5fDGkj
   A3q2WcKEhdVQhnvMDuoRlmGvPfTcAHLVP38x/org7N04a+4goS48pCioM
   zFqW/zIngd0w8gZZO+HbjinGZkz7vXaYOL7AiviK1QjBvOpsn096oTRLe
   nQ62CRZ3mbsVzFRkxzI3eFifaw2RbY+uZA5f33TzYtoFtjyJsM+sRO//g
   w==;
X-CSE-ConnectionGUID: a3Q9W7KPQompC5Tl3yxCtw==
X-CSE-MsgGUID: 6WcZmRp9SAW8V6i6eP1mag==
X-IronPort-AV: E=McAfee;i="6700,10204,11267"; a="43404998"
X-IronPort-AV: E=Sophos;i="6.12,185,1728975600"; 
   d="scan'208";a="43404998"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2024 22:27:37 -0800
X-CSE-ConnectionGUID: oowqkdbQQ4a3ApNFq4UQaA==
X-CSE-MsgGUID: VZAAFqc7Swiztx9csVLYww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,185,1728975600"; 
   d="scan'208";a="122371166"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Nov 2024 22:27:36 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 25 Nov 2024 22:27:36 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 25 Nov 2024 22:27:36 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.46) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 25 Nov 2024 22:27:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vm28LdSsSEUFSVkkTSLgyFu9zp/fOYl2pDBy1sZdFDFeFQFh9KWy7tmld7EG18hRLXax/o2RB4UM1ZFJZV0D/nwXcoBLMCkpOOorKRzsReY4Nr6pT8cZjEdeVLENho7kpoD6FQdAR/tsffUxXH78Kh3o4SJNZKElpqgHNFLSBW8pRN0mbDyMXij0fXu32fgUG+4OLdTrJpLoplopRuEX1PpAGyFCqxWR4v7JeL48Jb7iBVuaE3sSsWeI2nkQsTwG8VvG8sKgDTWNFhATwqILj1GpkS9ETAx8yZ8bFXjoSQMcs0BthczwzUCBukxTxjxkaWcACAZ/5YJg0PDij9xX3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XQNLBcPI1+Dg2DPMwz45TGa8vckoxwdq4oncFQboLpI=;
 b=pCFV2lyBL655BJDM4PpDEdElJHVsMizFTe3Z0uvX6u7cgiFlhg+f6ODDL4WAk/eBp9l0sreWVFJk8n+57UAH2Hjv13U+LiEf+8xaS9cD1bLodRWUs+4aF8VNPX0/evyUw6IUTonJzODYnvU/GS6zi/JXbDbeE18UtkQTZc2EKz62D+EycJZQgWRxvjQAqF5SeDFDGpO3j/lRigB+eNsqS1KmphFTAfF8j98eX+1EheKZavoPyXvORV9OGYFLcPNMFSa21VgfiZiSX3y9Nl1hW+bEj3yqYe8WJGScFetZWAIC+mCoohUgzig+hQ07JwihHJ6N62mlR/O+5rIRVENaLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH7PR11MB6054.namprd11.prod.outlook.com (2603:10b6:510:1d2::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8182.21; Tue, 26 Nov 2024 06:27:33 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%5]) with mapi id 15.20.8182.019; Tue, 26 Nov 2024
 06:27:33 +0000
Date: Tue, 26 Nov 2024 14:24:49 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "x86@kernel.org"
	<x86@kernel.org>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Chatre,
 Reinette" <reinette.chatre@intel.com>, "Hunter, Adrian"
	<adrian.hunter@intel.com>, "Lindgren, Tony" <tony.lindgren@intel.com>,
	"dmatlack@google.com" <dmatlack@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Huang, Kai" <kai.huang@intel.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>
Subject: Re: [RFC PATCH 0/2] SEPT SEAMCALL retry proposal
Message-ID: <Z0VpsYpcz4uqdA7o@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20241112073327.21979-1-yan.y.zhao@intel.com>
 <20241121115139.26338-1-yan.y.zhao@intel.com>
 <4a3b3b6bc96e111e5380de4681a20c2734d82a33.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4a3b3b6bc96e111e5380de4681a20c2734d82a33.camel@intel.com>
X-ClientProxiedBy: SG2PR04CA0216.apcprd04.prod.outlook.com
 (2603:1096:4:187::18) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH7PR11MB6054:EE_
X-MS-Office365-Filtering-Correlation-Id: 43c8903a-f542-4eba-e060-08dd0de36949
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|3613699012;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?TxTkn4GrtWpuVyE3aiWtmYrabOv8YSv0vJJR05MVk4WbcH9jgASd+u3EIE?=
 =?iso-8859-1?Q?T9AP01po8TS244f2ReTraN3BbUj3cUluau9yiVC3d2m+1kuQ6PSnrncQPB?=
 =?iso-8859-1?Q?mRGibeVrF0olqClfuxv4ZSnmB811bFQHQBPW/nX1THSIklv2eHuEzrIC/m?=
 =?iso-8859-1?Q?iaP2Bhp3LpiEwP24B/4zb93SWmnKG8hhXWoX0GLyTJtutnfl16LnTBHb6R?=
 =?iso-8859-1?Q?zYWi08ZJu4sPpmOR3QTsjJomznjLj3gddRDuU2OXdON7QhJz73OYFoQgy3?=
 =?iso-8859-1?Q?VtjH++DstdZ7KN+hPRJLUGPcY2QrLBmjyg4Pc2P6YYVTkJ/xTpDKiK2ho6?=
 =?iso-8859-1?Q?YC+dn+n51cZBF+731jI2EdiCdq/T/KV6scOiU8SdUxr6FgizQRRsY7N8FX?=
 =?iso-8859-1?Q?esy1YiVIjiRK8jiqGnwA2iJMrLonKDLl/QfsBn7tRFFEFtfnceijspNUns?=
 =?iso-8859-1?Q?GqZ/vQjYc2N4UljK8lEyOkDUczKxLcwm6bMfwnCjGmC2eUvJpFrZHSxSPH?=
 =?iso-8859-1?Q?1w3F3KIDE6heUj6ISVLs4XToZwHyUu5P0YFVGp6zoLCcGukabwvg2Na/fs?=
 =?iso-8859-1?Q?EezPKW6P2/nJxvDIB6g4/RBiXa2nCp1X4NHVjXSfL/6EvCLKL1SoGHKjsh?=
 =?iso-8859-1?Q?+r+WW6Swy+E2A3PXmIBbIxV9ldq7XTly84hxTayjkme2jVjggX5XWS100U?=
 =?iso-8859-1?Q?oVimpzMxUdwOqku7hikTZh2SpIuD680GCq2wsS8Cb/YqhVEibRW4slj7W3?=
 =?iso-8859-1?Q?kLxFlr7PbjMqdlLCzVB7SOBtjzEi319iDiAXUz/5BTYb+ADpQdFAQxhikT?=
 =?iso-8859-1?Q?pPB/zlEbv2s7UEHjkx6omY1qMVKJ4srbmnka2U2aGVeMwJn0vqipRalRRV?=
 =?iso-8859-1?Q?A8RkFst6XeLkOakYhgc3D1dFVB5ib6aKrsooeou7BHL9fBq3ZuYLDwA2bX?=
 =?iso-8859-1?Q?ys2oIFB8M0zCHH707hZopcYMMv9JF81pfk8TSuY4/VdtRdEGcBKaR0L+15?=
 =?iso-8859-1?Q?CU0+Ull9aQ3oL61itTQRQu+Dkl5S2DVHIhT5vrPNFjNEJEpck9yb+Eu/ji?=
 =?iso-8859-1?Q?AfslGbk69fLKFVDzzbA9FKV/j8dzx11JPiIebz9hD7+2O3Qd6lQgTlUOir?=
 =?iso-8859-1?Q?64DGuuewkw/M7dTPKlEcGJAsDFtkSloPRdX43/u0SkbGq+o55N+vCri57c?=
 =?iso-8859-1?Q?657WYn2NWb9cNvr4hR/dhrWDriKm9ac1C2oJfiVvRaKKJDrrOHhwuT1SST?=
 =?iso-8859-1?Q?3oJi2YeF6WCJLPO8bPmUR+ks1GsRF74zum/8GWWYrEqU/Q1SStH/8QvzwV?=
 =?iso-8859-1?Q?iJHGSPDu5TylKdd9URy8X11Aru7l/OZP5yUrB6tQqhtBSc4hKNH6aQVuYq?=
 =?iso-8859-1?Q?d9GKUXrAf2lKkh1+qqoWUtcoeg3IcjSuXUpKFgo3unwbE13Sxe8sBaUF0d?=
 =?iso-8859-1?Q?0iY5wWfAPhBukREaEkzsXkBwbsA5VK8lWHZL3A=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(3613699012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?76FlOiaUJIXBmwmtWnsN8adELD3z1TH+i2j2CDgMbSIrEEBdslLD6shuEa?=
 =?iso-8859-1?Q?HAx54kL9/zFIpxSUNkSnsqf+UUT5oy/lBDCBsPP1DaPpZ3ILA7BAUhZd0i?=
 =?iso-8859-1?Q?iRpjeWGV97h19M0qbVz+21UYN+wDQBihFzxFHCbHtzs8LBY9IVkgpjaDNj?=
 =?iso-8859-1?Q?eQEqTgFN48cU4yuPvVxBn5i3YhDmuyn7Naf7LGrarItTEDWmu8WuCBc9Ei?=
 =?iso-8859-1?Q?iJlHA4wOLX7WqdyydXUXRDRpNAlEkbzdP7eHuRbNAeoahA6RKwJtlk8bwZ?=
 =?iso-8859-1?Q?NFPcicXX6IMPZlqB2zNlHKBCgYjoFMryEMNdjS6kg1HQyfD3EXng78wM+F?=
 =?iso-8859-1?Q?NXmpPft7J+bTQCssPKxNXYKZA23ZuhS/BNNVD6LEyUYDX4ffj2Ig4dYnW1?=
 =?iso-8859-1?Q?ILbTQyu3LxPfh/aEUg79Qj+I7r11CwzSNpR8USbMzO03YnNrBS3SgLfokX?=
 =?iso-8859-1?Q?JHOIJH4FCePt6SlLiU3ncy+3ZaT01wkLHzhwR2dn+4CX3iTCPnDWtD1Cat?=
 =?iso-8859-1?Q?cn1xYhy1bOW7xiRTrCT6DGOPtPdpoJC7531+YHPVAcU8ezM+KFf4YOE1aj?=
 =?iso-8859-1?Q?4k2haB0z8Yk4K+KhYtyAeCrVTlgb7J+VpOtUmZ9UBxxZ1eD8AQi0tBFdbc?=
 =?iso-8859-1?Q?8/Wyc/CftoKZ+MYHPl1EQv8O/PkNE5Aaz1y9hZ19CIaBAtRt4PzsINYPmT?=
 =?iso-8859-1?Q?6HTyv0C1hYwRNVn+jtsjV9WtjjQv0UW9aS7xVV6L9mR2Rhb/8s+FEcJuuw?=
 =?iso-8859-1?Q?DbuL+1WUBbYjTXWpczHcMpAtr3sni2nNGcEC1rlLtFMnu5armFDvVO1d53?=
 =?iso-8859-1?Q?EyjK170WXyb1mdP7TMjlcZezqPhfxv7Ayi0uR84n/UkGf35wT9lvaBHwiV?=
 =?iso-8859-1?Q?EtNBxH9NBTODMAL2L/QaImMLPlpuDoko0qBsQSrVpwbp1XoubTyjyRWT+B?=
 =?iso-8859-1?Q?Pyg/6kHpJwmlNWxmhdxSxI/FDvRd86cNJtdPzx8FmO916yEoP321D4B1aP?=
 =?iso-8859-1?Q?wQ/4D9QTttukwo5Bb3sq2TeAULIgqtvPCfhQ88wBrqi6sy3bVYSjSVCJRs?=
 =?iso-8859-1?Q?efRKhcMhNw58ye3VCsmpxIVAeKflCN9SYWxV988svqAcS6KYKelAqpzQNM?=
 =?iso-8859-1?Q?R10VKAg7W7sNsTXtKPZs0MBZrRdAzdP4wE/AjtAeb+CQgMxcd8nRudQpt6?=
 =?iso-8859-1?Q?m/mmo30u8SKEUy1mdWnKvSHpuX8GNPDyDjRub+3ZU+waslrJt4rdOcOqBo?=
 =?iso-8859-1?Q?jhYaDfCptvBnnITJN0L0IBx1Tas2L1bSAKV1CO6NrBzhLuGzfOsyzr4nBj?=
 =?iso-8859-1?Q?C3cHRfgEmP4ZbB2U8SEKllpsAJNbN+X+BtJoLGMLqS/mU1m6hmvefvnO2X?=
 =?iso-8859-1?Q?6oQv7Glj1CoHrwz+NIEuAW4tqWn1tTGFOZNzuY5UwBOiOT0uK/1vkAZNSD?=
 =?iso-8859-1?Q?faA4SJr5LKlemGaGh83GgS/0/nPICiUn7Kz+iHNsPxrtkTRrmA002oslJo?=
 =?iso-8859-1?Q?Vu0O0NOjeWj5baHZFcHyPhOix2tTm/EOHAa2cCt2ufLo1bNww6SV5WFV6a?=
 =?iso-8859-1?Q?l9LJqxSaRLf6DWLMI85hBn2d0qyrZdn5I8pWTzwk0QpQafP3ihpp13YoPZ?=
 =?iso-8859-1?Q?fgFMf0anS1OCWvMsHaOQryg3yHu8PUV/9K?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 43c8903a-f542-4eba-e060-08dd0de36949
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2024 06:27:33.4081
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jj4IQU7hjfOvHqXO3FSTHn/oURxVYIlRkuSvUzxJAxj8Xt2d4/Rwb5Q8gL//Lo3sw7UxaLbXrB5ttP9y5UJ+FA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6054
X-OriginatorOrg: intel.com

On Tue, Nov 26, 2024 at 08:46:51AM +0800, Edgecombe, Rick P wrote:
> On Thu, 2024-11-21 at 19:51 +0800, Yan Zhao wrote:
> > ==proposal details==
> > 
> > The proposal discusses SEPT-related and TLB-flush-related SEAMCALLs
> > together which are required for page installation and uninstallation.
> > 
> > These SEAMCALLs can be divided into three groups:
> > Group 1: tdh_mem_page_add().
> >          The SEAMCALL is invoked only during TD build time and therefore
> >          KVM has ensured that no contention will occur.
> > 
> >          Proposal: (as in patch 1)
> >          Just return error when TDX_OPERAND_BUSY is found.
> > 
> > Group 2: tdh_mem_sept_add(), tdh_mem_page_aug().
> >          These two SEAMCALLs are invoked for page installation. 
> >          They return TDX_OPERAND_BUSY when contending with tdh_vp_enter()
> > 	 (due to 0-step mitigation) or TDCALLs tdg_mem_page_accept(),
> > 	 tdg_mem_page_attr_rd/wr().
> 
> We did verify with TDX module folks that the TDX module could be changed to not
> take the sept host priority lock for zero entries (that happen during the guest
> operations). In that case, I think we shouldn't expect contention for
> tdh_mem_sept_add() and tdh_mem_page_aug() from them? We still need it for
> tdh_vp_enter() though.
Ah, you are right.

I previously incorrectly thought TDX module will avoid locking free entries for
tdg_mem_page_accept() only.


> 
> 
> > 
> >          Proposal: (as in patch 1)
> >          - Return -EBUSY in KVM for TDX_OPERAND_BUSY to cause RET_PF_RETRY
> >            to be returned in kvm_mmu_do_page_fault()/kvm_mmu_page_fault().
> >          
> >          - Inside TDX's EPT violation handler, retry on RET_PF_RETRY as
> >            long as there are no pending signals/interrupts.
> > 
> >          The retry inside TDX aims to reduce the count of tdh_vp_enter()
> >          before resolving EPT violations in the local vCPU, thereby
> >          minimizing contentions with other vCPUs. However, it can't
> >          completely eliminate 0-step mitigation as it exits when there're
> >          pending signals/interrupts and does not (and cannot) remove the
> >          tdh_vp_enter() caused by KVM_EXIT_MEMORY_FAULT.
> > 
> >          Resources    SHARED  users      EXCLUSIVE users
> >          ------------------------------------------------------------
> >          SEPT tree  tdh_mem_sept_add     tdh_vp_enter(0-step mitigation)
> >                     tdh_mem_page_aug
> >          ------------------------------------------------------------
> >          SEPT entry                      tdh_mem_sept_add (Host lock)
> >                                          tdh_mem_page_aug (Host lock)
> >                                          tdg_mem_page_accept (Guest lock)
> >                                          tdg_mem_page_attr_rd (Guest lock)
> >                                          tdg_mem_page_attr_wr (Guest lock)
> > 
> > Group 3: tdh_mem_range_block(), tdh_mem_track(), tdh_mem_page_remove().
> >          These three SEAMCALLs are invoked for page uninstallation, with
> >          KVM mmu_lock held for writing.
> > 
> >          Resources     SHARED users      EXCLUSIVE users
> >          ------------------------------------------------------------
> >          TDCS epoch    tdh_vp_enter      tdh_mem_track
> >          ------------------------------------------------------------
> >          SEPT tree  tdh_mem_page_remove  tdh_vp_enter (0-step mitigation)
> >                                          tdh_mem_range_block   
> >          ------------------------------------------------------------
> >          SEPT entry                      tdh_mem_range_block (Host lock)
> >                                          tdh_mem_page_remove (Host lock)
> >                                          tdg_mem_page_accept (Guest lock)
> >                                          tdg_mem_page_attr_rd (Guest lock)
> >                                          tdg_mem_page_attr_wr (Guest lock)
> > 
> >          Proposal: (as in patch 2)
> >          - Upon detection of TDX_OPERAND_BUSY, retry each SEAMCALL only
> >            once.
> >          - During the retry, kick off all vCPUs and prevent any vCPU from
> >            entering to avoid potential contentions.
> > 
> >          This is because tdh_vp_enter() and TDCALLs are not protected by
> >          KVM mmu_lock, and remove_external_spte() in KVM must not fail.
> 
> The solution for group 3 actually doesn't look too bad at all to me. At least
> from code and complexity wise. It's pretty compact, doesn't add any locks, and
> limited to the tdx.c code. Although, I didn't evaluate the implementation 
> correctness of tdx_no_vcpus_enter_start() and tdx_no_vcpus_enter_stop() yet.
> 
> Were you able to test the fallback path at all? Can we think of any real
> situations where it could be burdensome?
Yes, I did some negative tests to fail block/track/remove to check if the
tdx_no_vcpus_enter*() work.

Even without those negative tests, it's not rare for tdh_mem_track() to return
busy due to its contention with tdh_vp_enter().

Given that normally it's not frequent to find tdh_mem_range_block() or
tdh_mem_page_remove() to return busy (if we reduce the frequency of zero-step
mitigation) and that tdh_mem_track() will kick off all vCPUs later any way, I
think it's acceptable to do the tdx_no_vcpus_enter*() stuffs in the page removal
path.


> One other thing to note I think, is that group 3 are part of no-fail operations.
> The core KVM calling code doesn't have the understanding of a failure there. So
> in this scheme of not avoiding contention we have to succeed before returning,
> where group 1 and 2 can fail, so don't need the special fallback scheme.
Yes, exactly.

