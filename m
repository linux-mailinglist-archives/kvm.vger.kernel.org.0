Return-Path: <kvm+bounces-29265-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 325249A6019
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 11:33:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B53B81F21867
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 09:33:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB53A1E4113;
	Mon, 21 Oct 2024 09:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fiALBdgS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00E431E105F
	for <kvm@vger.kernel.org>; Mon, 21 Oct 2024 09:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729503123; cv=fail; b=l/DB2rTtoBuYOqoKPTo9uVxUxuzLFzxnjkw6dEE8uIaVXXQxJ5VhXJbwljMnb2EhwcEkUm7JGNw3EBhONaULKI6EnWEo9m3Wx+aRRL/2CboeKW+YEYqlQLB9SBK3Xqdx2S7OLpvtl7o+gXiGQmhFToBxMd6tto4fdFEVfVgDNwo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729503123; c=relaxed/simple;
	bh=wWw8roF97kRuEYWIvj7D3Ols5l1clfeA+X751HGEs00=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=TURkdZRGpsnD4SJ4BK5P4dRmN0kFEBxHNgstD6qWvXgdbdKIWBJ00goCVG7GXpXLR/S0NeMr5lD11THjRAtWAh5hX8gzoapWg/4gT+4Xp5oLDOoP2OqvNdedRXTb4FJ6Cxn2S+ps5rMT7G5+44qFD0DphPjLp9Qvmb9YTp+m7Sc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fiALBdgS; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729503121; x=1761039121;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wWw8roF97kRuEYWIvj7D3Ols5l1clfeA+X751HGEs00=;
  b=fiALBdgSClgSPvfmJhlqdi+mnBmvzPpk+ho1kuKV+HeHZdaz5vHdjHpq
   x1+I9mRlQNC289/ltDZfCKEVSKcaJKD2iaJub5u1GvE5K/CpVqUWovJ6V
   Eg3IEwo2ebw+samebsbKG7+4obMrFE1HdzItkZ2KsfHFJriFHYrUvQHvw
   EbPcZuFCwWshlkB+uMTATYDkm3POQF+Ml8b92n8TnISehDbVmRaGBwQpT
   k2SC/VNro+OYmlPnAt0TO2t8KOwkuJ7zMyt2BG1JlsQi2Q42Lvrz+lPmf
   erjBVgUsh1flD4bZ4vURNW4141N7hJYrjxKbsuBZ/hq8CR2Qv6V+vMctO
   A==;
X-CSE-ConnectionGUID: r9+P85TqRH27sX6WrK9t6w==
X-CSE-MsgGUID: EDRDw7RxQN2HfC2Bl7EQ+g==
X-IronPort-AV: E=McAfee;i="6700,10204,11231"; a="40373604"
X-IronPort-AV: E=Sophos;i="6.11,220,1725346800"; 
   d="scan'208";a="40373604"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2024 02:32:01 -0700
X-CSE-ConnectionGUID: xNR8i5WsTvWD89mBgRcb0Q==
X-CSE-MsgGUID: hIQHQTndTs6tnUsaZ4CJRA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,220,1725346800"; 
   d="scan'208";a="79069564"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 21 Oct 2024 02:32:00 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 21 Oct 2024 02:31:59 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 21 Oct 2024 02:31:59 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.172)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 21 Oct 2024 02:31:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PD0FQQCZeUZol+4PJ1Q7QF66IGRWZFP0csr4DpgBZiFsvoheSeDuQ9ep1o3TzMnIDXvqHR5DbmTUXc7xRtIS8KL14gesRatT+wAyFCsj56kVvcD0h2Yr3firOeQnr1btsdLxG4lN9jAQdPv5hL2XQFzw9FoNSUjquThnKcsJxK63Uax8EN/JRO14i5pA13EZ4UZSJGuL+yP6jusQD50e+iLLSECdWzq6dSyIV4a8zwc803h9MgvSwD0vaSSUQW233yiy06ZthYxDDOAYaqufL9JP3kocAafAcosVDWGwwPoZ/U4mXcHFiQYDoNTkWIRzzugziLLm3SGQWRPQxPu2aQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LOvNJFbWciA+gld6j1a8bwTmY835hXu46RJp1ebtff4=;
 b=UZt7U4l9fGe9JLIF2U1beJ0btvzfGHG2JPVULDflsVWabIxw/zHnyb539d2iad39LFRrLxcC9mwSLbr6VowgYo/T5j8Z4HW15H9nqwzedm0ZIKGAxAzXhb17MXfNK6y3IYTFpDZ55lOpRneH8KE0UYOf9Dtdx1woc5PWwtX/K5xNyG/pmZHyILo5Ta2HR09un7W2Qy46ZSzFM4en3wWFvXiLWURLYea2Kf0oA6NWWg75tqgxZnd6QWbYFfg1k5HVWKALJr6G/n678WXebKRF8k0sdTAhmHfiMQlpofvcm4m2h/aOvefCdyHMxHBNLiXlMAtq70h3Ee56q+Mgc0WN6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN7PR11MB7540.namprd11.prod.outlook.com (2603:10b6:806:340::7)
 by CH0PR11MB5252.namprd11.prod.outlook.com (2603:10b6:610:e3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.28; Mon, 21 Oct
 2024 09:31:47 +0000
Received: from SN7PR11MB7540.namprd11.prod.outlook.com
 ([fe80::399f:ff7c:adb2:8d29]) by SN7PR11MB7540.namprd11.prod.outlook.com
 ([fe80::399f:ff7c:adb2:8d29%3]) with mapi id 15.20.8069.027; Mon, 21 Oct 2024
 09:31:47 +0000
Message-ID: <bbf5731c-bb0b-4a25-84bd-a12e70fdef90@intel.com>
Date: Mon, 21 Oct 2024 17:36:22 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] iommu/vt-d: Make the blocked domain support PASID
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <joro@8bytes.org>, <kevin.tian@intel.com>, <baolu.lu@linux.intel.com>,
	<will@kernel.org>, <alex.williamson@redhat.com>, <eric.auger@redhat.com>,
	<nicolinc@nvidia.com>, <kvm@vger.kernel.org>, <chao.p.peng@linux.intel.com>,
	<iommu@lists.linux.dev>, <zhenzhong.duan@intel.com>, <vasant.hegde@amd.com>
References: <20241018055824.24880-1-yi.l.liu@intel.com>
 <20241018055824.24880-4-yi.l.liu@intel.com>
 <20241018155429.GI3559746@nvidia.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20241018155429.GI3559746@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: KL1P15301CA0060.APCP153.PROD.OUTLOOK.COM
 (2603:1096:820:3d::22) To SN7PR11MB7540.namprd11.prod.outlook.com
 (2603:10b6:806:340::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR11MB7540:EE_|CH0PR11MB5252:EE_
X-MS-Office365-Filtering-Correlation-Id: 46bc1e49-b509-4252-d0d9-08dcf1b32ee5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?RitQU1ZVdU8yblFSdjFjRDJFTEdQMERmUG5VSGwvSzJBTkVobDF3ekNqN0Iv?=
 =?utf-8?B?MlN0MTl2Mjdyc3ZBZnZhS3Uzc0l2aXAzaEN4UC9ZYmVNQlZjc1JUMGFtUUlj?=
 =?utf-8?B?ZklJbFMxbGdZb3YxYmtMOXM4bU9Uck5TMkFlQUJSQ3BCc2U1WFF4eG1kR0JL?=
 =?utf-8?B?a2pqN05qMWsyWnptV3o4OTkrVHZDSEl6Sk9KaUlkRXNmYjYvVzJTSDN5c2wr?=
 =?utf-8?B?dGlQM29XaGExTktITndXYm9ZaURBMUlrb1ozS0VETUpMM3MzZnJGRWhiM09p?=
 =?utf-8?B?M1RYem9kVWxCZEJqNXB2UGF0cEhYaVlSVHVSVmdvdzFlN1ByWXd3d3FOZFhH?=
 =?utf-8?B?d0dWc3VTamVyTVhHQzVlRGZ3cWtCZVRGYWRZaUJwNDc2WXJiT3Z2K2lrMGh3?=
 =?utf-8?B?OTU4UCtYZENyTldhQkZrbTY1ejkyWllPZlBFdU1qcGEyVXp1bTdFaUFhSEQ2?=
 =?utf-8?B?S01UYURGZ3h5MUY1bjcwS2Q4WDNkUXFsQVMwNUtZOEM5NGxSWnYrS0dnSUta?=
 =?utf-8?B?eTJtd3QwaWpRUGZrbW1JcktYM2s3K09KclBSY3B6U0E4VDJ1K25WV3d6WkVE?=
 =?utf-8?B?QW53RFdQSTI2MUZNQXpPMVVFRkxRM085V2J6MHZDMVZGYUlsYkNQZXM2eWRM?=
 =?utf-8?B?NVlndXdWRWEwR1IzQXFSandhdTF0OFRtMzNscUtrUW5XcU5PKzdvWHVwYWNh?=
 =?utf-8?B?QmE3N2s2WmwwMUUzVlZERG14U2tIWUVJeUhwbjRXY2cyRDUxenprN3BWLzFv?=
 =?utf-8?B?bVd3NTlXazlWZW9QOU1UR1h1cUNUUGFQcDMvUlpXZTlGN0lsdk4zcmcwWGQ0?=
 =?utf-8?B?QzRFU0FZOStRWWJBVHJQeWExY3FMN3JGRGVEamhhVFIwOGkrQTNPRE53cFoz?=
 =?utf-8?B?TTBFTThnRnVqVngrejZlZ0gyVytXSEl3dCtNSVFrSkoxWGdocEZHMDZSUm9Q?=
 =?utf-8?B?WFlwbnFnQlpIUFFNcVhGZjJLcFMrWWZrQVhBdUtBdm1KWG9MWjAyaFNOK1FH?=
 =?utf-8?B?cEpYRWU2WVVBblNqbjByK0dGdFB1blQ4NlZHZGZ5QlZMdWtIWWlXdld4bTZJ?=
 =?utf-8?B?d2pucGtBSndjWnR6Z2dwb1ZKL0JqdjRiOU4xYllBR0FzRHBIckdJRFAvMGRG?=
 =?utf-8?B?dmdTajlpYXRac2JqTDhuM3BOZDNqZE9mWHQ5UXZaVzBlbFYrVlpSL2ZBbmd2?=
 =?utf-8?B?RmZKbHdLWmFCMStTVm1MRjF6cWllRHdGTHhPVVUvd3RuYzg1T3YvNEFzMWk3?=
 =?utf-8?B?NzlDS0E4NFhabHJycDdkN1loZWx3Q3pNek5UcURreGxlL0pxNFREdmNidVk1?=
 =?utf-8?B?dEZyMzViK08welJOQjZWVzBQQTlvR20yZlhkdURPdXBaSlg3WWt6dG03VTls?=
 =?utf-8?B?bGM0SXZJU0R4bjJFV3F2T3lVQnc1Zmd0SUxFaDFjQ25CbVpoYUdnTWo1ZER0?=
 =?utf-8?B?UnExTG1EVE5tM1YzY1V4VnBzQjNZZ2JPZUFxVS9jQ05RTmhOSVVtUFpJVk9R?=
 =?utf-8?B?TDU1eGdJcExFYzBoano5YmNWMFZFVUN3M25jZFVIMWZRVUdEYXhyUVowWE1N?=
 =?utf-8?B?Z2RFRERRUVJTcVh6Z0hJRzRLTGRkSFRreW5XTzk5S094MStJYkk2c2xta05j?=
 =?utf-8?B?Q0wrOUI5QlJLd1cvU0puNlBTdVdOSUQ2QTAzdmxFZnQyRE9CaTl2N3JQRysw?=
 =?utf-8?B?dWdOUDk1bEI4ZnJrTDJ0S0k1d1VPQUxNU0d5bU8vcnc5WFpLdjNuS25FZjE1?=
 =?utf-8?Q?90ob1gZ6YM0BGz41bs=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR11MB7540.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dzZSaW9vb0t4dS9VNmUrRWQ4UklUcUpiL1hKMmFWbzd6M2JqbzRxUDBMcUUz?=
 =?utf-8?B?NVZLais1SXRIVEFzcWFPczZRUU9tMWc1T2dwV3FQQ1RDS2ROTU0zWlNrRDVw?=
 =?utf-8?B?YVdlcVlWdm14MUxLN2RUYTRyaGg3Z010VlJpeVY2Um9wRHgwVGw0ejRudHF0?=
 =?utf-8?B?ZVFlRlc0MEEra1U3cW9NckN4Nmowb1BiYVZYYUNqZmJHOXpXcTJVdEVlTEhV?=
 =?utf-8?B?aDQ1VmEvY3FVbDJ0N0hKdmhYMTVaOFBsRGF4QzlVQmljclRjbFY5cEpnMTdn?=
 =?utf-8?B?enAzZXFpMEVNakFwOGlQSFlUNm1Fb1pZRFNYOGJPZEpyVnNFZlZYRFNhTUsx?=
 =?utf-8?B?MlFLalJlQTNDOEhqVXlyeEN2K2ZmZ1RvbWJpeC9KZ1JLbDVTc1JJYUtRQy9l?=
 =?utf-8?B?Rnh2cHA3azJaWXNOTTlSa0xYcXdaRXBNWmFxRlNuUTVPN09WeFNlLzI0VlpV?=
 =?utf-8?B?YlorSktpYk9mbjlNeWNzTm9NZk13MkxMS2RyM1ZRSHIxemh1YklQWGM1alRS?=
 =?utf-8?B?M2lBc1J5YlY1bFhsOVd4dDU3V1MvMjJBTlVZMm03Z1B6UjhRendqMGg2ZUY3?=
 =?utf-8?B?cTNHOXc0eHNSTlZyK0ZiQjBMTkxha2FPQWoycnVXSi9oVU05OFA0SmptMS9h?=
 =?utf-8?B?ZTRIQk5STGlQaWpvYmF1bmU5dG84cjRCU1M1WWNCZ0x6ZUxQMjExZ1F4VlEv?=
 =?utf-8?B?eG83dXBsSEd1OVNYbU9KTnNwWm1rTDc5Z1FVUWhVM054NFVTNGFGN0FsVUtm?=
 =?utf-8?B?SVZFREd3Y0dNM2RNeUY4dnR4b2hIYURuR1RnS2plT0piMnlmcEpNNnkyQXYz?=
 =?utf-8?B?bDlhY1ZvSHMxK25KMGV5eGJBK25XQjZCUUIvUDN0UUNJVDg3d2ZvVXo1QjYx?=
 =?utf-8?B?ZE03QXkrODZ5R1Jlc01YSTh5UTBRenJaR3VHd3hNbzdvOHNNYnE3TUVENGkv?=
 =?utf-8?B?WUcrc1hVZDBSNmxjYUxkeUtSRW9hSVlxcFZUMkVUQ0lBSTNzaTJsdC9hZ0E1?=
 =?utf-8?B?UG40T1hRVFVBajVsR005R0gyd1JOdkdNVTBMMHNhd01jK0VMdFJvbk8rZ0Vj?=
 =?utf-8?B?bElyMUg2OFp5U1RleGpaVnl0NEhQTEE0VWRzVndRdVl1UGFyajh2b3UyWUtW?=
 =?utf-8?B?TWRzK1pGb2pqZjFnL3VLNVIwcUtJRDBKUVFWbUV3L2R0UmJRM011S1ZGMGtm?=
 =?utf-8?B?WCtzNXpHck5jclpRTVRsc3RCeTZYK0dlVVBhZWhqTFhEekNpZ0tDWGwzandO?=
 =?utf-8?B?ekJ3Qi9EdTV1MXBrYlpudjh2Zk5jTkZmTTNERVhzT2hOdzI4b2t4dlg4bldx?=
 =?utf-8?B?K21VNXBvRGxmV2dlSmhiWUN2eGhJOEJSRmJsQ1ZuL2t1YjRwNmhHYkdUeVI3?=
 =?utf-8?B?eThseC90cDA2MUZVVHlZdVJsK1MvQ1pkZzZPaVo0dnFQMVhKSzhEMmcvR25a?=
 =?utf-8?B?QU0yN3pnVnZQa2FjbmVQY2twZGpaK2wwOVIzd0diVGNQQjY4ckF6RXI2QzhW?=
 =?utf-8?B?ZVkxY3IzQnJwT21xWXozNGJsNGtQZW0vWjE1b05KMEQreTNDNDZQbDU3aFEr?=
 =?utf-8?B?Wk8yTW85ZTdFZ1JEL3FKa3p3VGFPWTBTblQ1YXNNOStoWmxhakQxUkQyU0oz?=
 =?utf-8?B?MmhHWi9Za1Z3WWViRStjOTFHM29BVEhZWnRSN0pMb3JhU2hHbUFNT0V6QWxV?=
 =?utf-8?B?SlB0aGJPMzFiYzgxY2JwVzdPbW9KODRyaFowUy9SY3Bxb3RQNmdDZkRMWXl1?=
 =?utf-8?B?NEtta21yZjUxUlBBWFlHMjZhSklGTXlZUzJMYjRUSEEzblVnZ3VibHRqOXlx?=
 =?utf-8?B?djd5N3lvWEVETytMbXUvSDU4QktUS05yUHZCRlRTc3U5d3ZvMGVzNUZFTmd6?=
 =?utf-8?B?eTZ5Z3NUZURscXZoY0I5RU9iSmFqdTB5M2F6TzZaZm1uZ1ZpSE96ZEordkJ3?=
 =?utf-8?B?djR4MCtGdUoyYzF0S2UzTXZjQnMwek9pWFNaQmtGMVplcXd5ZlBXTzU2Lzk5?=
 =?utf-8?B?akZsS3Vmbmx3NmljekR4eFgvN0gzRHdLcTExZGs4bWI0cDQ2dEE2RUxkZ01x?=
 =?utf-8?B?MHdncGwwMUZzMmRxMk5KdEorYnNpaGxrb21yNkpja3pVZ2ZySGJEbEVoU3Jz?=
 =?utf-8?Q?W38Hg0KCJz+vwPy5H65tYcVZs?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 46bc1e49-b509-4252-d0d9-08dcf1b32ee5
X-MS-Exchange-CrossTenant-AuthSource: SN7PR11MB7540.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2024 09:31:47.0945
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6dPem/BSe6cL9nISIftVut1g/JcDgViRIEYDGfa2XmeYjr/U7lIoocBd02hzxO0omaPLD9HYkk5b/R0vJ+Aivg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5252
X-OriginatorOrg: intel.com

On 2024/10/18 23:54, Jason Gunthorpe wrote:
> On Thu, Oct 17, 2024 at 10:58:24PM -0700, Yi Liu wrote:
> 
>> -static void intel_iommu_remove_dev_pasid(struct device *dev, ioasid_t pasid,
>> -					 struct iommu_domain *domain)
>> +static int blocking_domain_set_dev_pasid(struct iommu_domain *domain,
>> +					 struct device *dev, ioasid_t pasid,
>> +					 struct iommu_domain *old)
>>   {
>>   	struct device_domain_info *info = dev_iommu_priv_get(dev);
>>   	struct intel_iommu *iommu = info->iommu;
>> @@ -4292,10 +4298,12 @@ static void intel_iommu_remove_dev_pasid(struct device *dev, ioasid_t pasid,
>>   				    INTEL_PASID_TEARDOWN_DRAIN_PRQ);
>>   
>>   	/* Identity domain has no meta data for pasid. */
>> -	if (domain->type == IOMMU_DOMAIN_IDENTITY)
>> -		return;
>> +	if (old->type == IOMMU_DOMAIN_IDENTITY)
>> +		goto out;
> 
> Just return 0
> 

got it.

-- 
Regards,
Yi Liu

