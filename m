Return-Path: <kvm+bounces-70638-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4CatFAkrimm6HwAAu9opvQ
	(envelope-from <kvm+bounces-70638-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 19:44:25 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C36E8113C00
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 19:44:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id DD6423020FEB
	for <lists+kvm@lfdr.de>; Mon,  9 Feb 2026 18:44:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF7EB3A7849;
	Mon,  9 Feb 2026 18:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UzyuuDgh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E0853803DA;
	Mon,  9 Feb 2026 18:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770662653; cv=fail; b=lfyg1z8Jr3cWoZxO5Kiiy81anZ3gl609xgyaq6PpRGrHIzfJ5HsS+xdv94jH6J2ExCE4XXM+GaIv2Q+JBukMU9263aFQkNj/58hdOTXFy+zXi8OHGW3zNgMGxrurCF+m4fW21wnnzGYT/tj+ddzrGjBk8dnggpiTOH/V9lteEXg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770662653; c=relaxed/simple;
	bh=bdIpMwcnHzdxP2VlGUrJbKloRywO4J15+Dg606gWmkA=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=tpoeUKU+kV96Ex4DyVOKqo1GfCJhgKNqPRcoug+kDv1M9pDAwHJTNXEddy5E98jVoGaax+PaynOiLp5CxpItzbwd8km/iGpYwllAUD70wzs7Rh7FaUPMw4KdiEsazK2/8mK8drPZbYV21UCnd+LMKgZ14eU33w6Mq2jrDh7CkAE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UzyuuDgh; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770662652; x=1802198652;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=bdIpMwcnHzdxP2VlGUrJbKloRywO4J15+Dg606gWmkA=;
  b=UzyuuDghd8It1a3wkK3C8ZLH6z76O9gBHMMyAOlSLiQkTNTCYQqdZqt5
   pjvLZtWfB5TA2Jtw7N4jaFJ2mIMISssawvswrKPCXOZb9oT38/X6bvgcs
   Il1iFV+bFHHUsnPVhZuDtfoFxfAGg9uMcvy7AR7NqgP0T38UO/m/vnnvL
   54mt/tXSWXwY00ZPuFuHr9b81kEighiCu2qyRDyK+f0KyEK+2bmnYTcjX
   zt7l6oA95PZ2ZOA1uIBPFNkA9aqMANyrbCShE5UCX/Zv4CfDmBgZHLfPo
   4DIIQdXApkJqXsiVibgPs0y/5LS4cUKRQwB7avLlMQ5CMfbq2FyjzjzSF
   Q==;
X-CSE-ConnectionGUID: HBVWFUi5SyqITLrBrx3iWw==
X-CSE-MsgGUID: qcETWEuAStq7SmYy6gBdHA==
X-IronPort-AV: E=McAfee;i="6800,10657,11696"; a="82105523"
X-IronPort-AV: E=Sophos;i="6.21,282,1763452800"; 
   d="scan'208";a="82105523"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2026 10:44:11 -0800
X-CSE-ConnectionGUID: 9xyGbxS3Su2G5GwdC4lbDg==
X-CSE-MsgGUID: 4QTSzyGoT1maBLtgJH43sg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,282,1763452800"; 
   d="scan'208";a="211260801"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2026 10:44:11 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 9 Feb 2026 10:44:10 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Mon, 9 Feb 2026 10:44:10 -0800
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.18)
 by edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 9 Feb 2026 10:44:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sR/fZFUx7nUhvUgU/T1ramVZyWWX5qW0Xouf6W6+unA+I/fDjQrRLpPpQzwkDIfvbEsKx7QTuMsJrgpBXrHH+uyObi6M5Ik3vb/jC0piSsRvaONvc5Y98VUHB/EpP43NQ2+FrVZFt6lwd7L60nEUB0rbwVA94mvST2Ute0rtOq7USjikJ2u5UeOgaz0ryNLotRK04aJ4Tr130VgyYppIQC+Tlfm+qEPnurL3kdnHoAPJlBU5vLVEcqxrZqLGihzdNoQDbu5sen9N4bGhGnoq3Waf8H8lW/huZuHabZLNUpj6bYOD+iyxJvw01FM3GxjZp223x6SIobHxBFBAwco9Sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=950LAuBiLtzft9fvhViY2yPe9RvOMPGylZ2CYL9eIPU=;
 b=hfQQ+qH1svEx2z5BK2dDCD3eqyz45VIdIleBlaXW7Zb84DanAcjNZ+u5sgN3E3ZP3udXi3VH3rnruhpUyG+p3hFuaXgAPRQjrxhJA5pKQGID007s/OPQ4iph/K+Gx4QLdgUmyzpIMmHAJTwPj08goI0Q6mBQm4iStw8vbNkpyIumLa3QLI4YBVw/GtTluRvNyssKKrx1ZiEuhprvF6+aPh7YcSvJphjoSWbjTDEK5Jp/zEsF3HQYHhVzrc9wx4Iw0ZRCDHZ5viRQ9UJUTkbdvYc01qkg4ZbJi123IAp5PcEtt7SxK7XLd4NlBXw9354uVx7XItiE8LtARDbeXbB6sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by MN2PR11MB4646.namprd11.prod.outlook.com (2603:10b6:208:264::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.19; Mon, 9 Feb
 2026 18:44:08 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d%6]) with mapi id 15.20.9587.017; Mon, 9 Feb 2026
 18:44:07 +0000
Message-ID: <eb4b7b12-7674-4a1e-925d-2cec8c3f43d2@intel.com>
Date: Mon, 9 Feb 2026 10:44:04 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 01/19] x86,fs/resctrl: Add support for Global
 Bandwidth Enforcement (GLBE)
To: Babu Moger <babu.moger@amd.com>, <corbet@lwn.net>, <tony.luck@intel.com>,
	<Dave.Martin@arm.com>, <james.morse@arm.com>, <tglx@kernel.org>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>
CC: <x86@kernel.org>, <hpa@zytor.com>, <peterz@infradead.org>,
	<juri.lelli@redhat.com>, <vincent.guittot@linaro.org>,
	<dietmar.eggemann@arm.com>, <rostedt@goodmis.org>, <bsegall@google.com>,
	<mgorman@suse.de>, <vschneid@redhat.com>, <akpm@linux-foundation.org>,
	<pawan.kumar.gupta@linux.intel.com>, <pmladek@suse.com>,
	<feng.tang@linux.alibaba.com>, <kees@kernel.org>, <arnd@arndb.de>,
	<fvdl@google.com>, <lirongqing@baidu.com>, <bhelgaas@google.com>,
	<seanjc@google.com>, <xin@zytor.com>, <manali.shukla@amd.com>,
	<dapeng1.mi@linux.intel.com>, <chang.seok.bae@intel.com>,
	<mario.limonciello@amd.com>, <naveen@kernel.org>,
	<elena.reshetova@intel.com>, <thomas.lendacky@amd.com>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <peternewman@google.com>, <eranian@google.com>,
	<gautham.shenoy@amd.com>
References: <cover.1769029977.git.babu.moger@amd.com>
 <aba70a013c12383d53104de0b19cfbf87690c0c3.1769029977.git.babu.moger@amd.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <aba70a013c12383d53104de0b19cfbf87690c0c3.1769029977.git.babu.moger@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY1P220CA0001.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:59d::14) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|MN2PR11MB4646:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d526619-8dd8-465f-ad7f-08de680b3506
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?SjJ3NmF4SzVENmswbXVkMEZ3NktTU2pNenhFK25rcStBc2doK0ZwZzlLZ1lE?=
 =?utf-8?B?Z2lNb1gxaFBvREFnNjlycnpVMzNlYmtsVWNWaXVGNHlHL2Z0TTk0MGhrUlNq?=
 =?utf-8?B?VHNzVHFGUkliUmJsby9DMFJxY1NpRllqTGlPbFQ5YnZIZmZEQkxlZlp5ZXRu?=
 =?utf-8?B?aHpxZldwczVuVUFxamJTM3lMeG1mNzU1c0llZVd6Vm42U09uazQ3eW5QMHRU?=
 =?utf-8?B?SjVOOXdOKzI2LzV4SHNkY1FITU9qWTJMYkhWQUVScG1UU3V5U2lMa1Nvay9t?=
 =?utf-8?B?ZGV2SlpqVHBjUU1xUk94c0x1NUs1SHFRdFg4eUFyblJ4RWZFTkkxenZCajhj?=
 =?utf-8?B?NUx2aTZvekh5OEZ3UTE3Njl3VHc0VkpNK1p2NDBOMUxBUXRFR2ltSlptc1ZI?=
 =?utf-8?B?MXVHVE9hNGhkaWg2bzI2Y3VXbG1ieFNGSWgrZkRjTFlkQU9RMjRnaGQ3THpa?=
 =?utf-8?B?dVZFbXJpUWdIS2U3TzZsTG1DSlVzRFlReXEwUUcvVkQ4R3kwL3p0UUJ4djNx?=
 =?utf-8?B?NUtyb1pSdldhKzVLbi9DN1djMHFWOWRJRlcxazRYcEh2L05Zbll0WERLTGh2?=
 =?utf-8?B?am96d3VaOXlDSE5DeDc4T1JreEMvV1NVdlBnZGZDenBOM2NoWHZZVTIyZHl2?=
 =?utf-8?B?OUticXdhNi91K25XK1dkNnViZ29YaGpKaXp5a3R2QnVhWXNhU3VNRzQrZk0r?=
 =?utf-8?B?YjhhWUJzRW44QjltWFMzU0FZbUQ3dUtUa1FHWU00Y2lvNGpLT2h4M1lpVGFo?=
 =?utf-8?B?TDdrM2lnL2NrZmRQSUxIN0hCM3gxWVc2dUFPK040emFHUCtsMmdSZnBRRW1S?=
 =?utf-8?B?VTlKUTBlL3MvbGJiZ2Q1WS9GUWZ3WUdselJOR241Q3RpYksxMEMyOWsxUlQv?=
 =?utf-8?B?MStYOFMzYlpyYUtIMGlmNXk3RzFwa0NGVmtJeWtFbk9sd29NTlZlZXZub1NE?=
 =?utf-8?B?N0RXdnJNWFI3aTRlVkZnSk1JWW1FSWFtRFZpOVVRVGFHMThkWDN0U041UmRu?=
 =?utf-8?B?aXdyQk5vMk1UOVByMlRmMEt1QVE1WEcwWDM2dk5Yb3VFTUR5V2RRZmI0aFZM?=
 =?utf-8?B?ZHgyNzZubkZSQUpObEJySXBVR2l2TDVtOXVabzZkOHlUY0pmTHpHcXNvd1JS?=
 =?utf-8?B?KzZhZGh1L1ZGc2FTdnVSaHFOeUZDYUJlNDUzKzZuTjF2QVlDZEpyUzR0ZDJ1?=
 =?utf-8?B?V3NJZG5MZEJ0V0FIb2tGUEV2bjRvekpPeTBITEpPQS9WSjkvZHEvZDNJK0RY?=
 =?utf-8?B?Y1gzRW84aWRMWlJSWnJDOFlra3VpQnAvTGZFaVdNTzJkTWtLL2M4ZTVHbW1C?=
 =?utf-8?B?MEtCQUVodE9sVHlwRkx5b2NqelYvRG9yWTVYZUhHSk5DeDl4Y0VZTTJpUlpV?=
 =?utf-8?B?S3BnNEEwak5iR2lTRkV3T0Z4OTZDWXl5ekhnWkhBdEF1dXFUYWkyZUdwZkJT?=
 =?utf-8?B?UHM1dTZrQ29yNWttelhDSkNJVGdjd0g2clV2MGo3UElPVm4yR1ViRVczbnF3?=
 =?utf-8?B?VU5BMnZ4RmcvMlNxZUxGQnpCM3VucnZpTTU4aktScXNBalpuLzlWSXk5cVdS?=
 =?utf-8?B?aGh5U2RwVng0QXQ0SUVSSzI5b2V4VDNOTTJOc1JNaDNpU3BISzNER0FrY2ps?=
 =?utf-8?B?MFd6Uk9YRDJBSTg2V2s5clkxREhOTllGSkN6TDBhWFlTOEpCdEFjdjY2RDdU?=
 =?utf-8?B?ejFoOGdmUXhMdFhGSDdwajBieWszZDBxNU10bkFSbUxzVzBaMHpOd1MvNzJV?=
 =?utf-8?B?U21SeGRsNlNCb3NmckFsVDEycTdkQ0JuUWo4aW5uVW5KV0ZmeDYwdUtiKzJY?=
 =?utf-8?B?RVVLY0kvWWVJR3o3YWFzUWt1QVNnMlB6T2YrUUFMc3Ara0lqaTRSK1VMSHdR?=
 =?utf-8?B?dUpFMnhBSUozMjNnVE83Y0Y0OHp2bzZxNWk5SnhRcS9NcHR4eVh1a0VyY3Na?=
 =?utf-8?B?MEw1cVhRMU9SRGVoZWJseW9vd1phZURXaDdmNmFQSmxzNTJ5OEtHMHpvTGlD?=
 =?utf-8?B?ZWxabFBtQ0F6UnlxTllBbDVycFQyU2FoTk9sNUxBVFFLNDNHaDdnL3AyZlVy?=
 =?utf-8?B?N1FwUFNOM0MwLzV3ZWdUUzNwbHlKTSswNFhtVlZwTzR1VGlyOXp5TU05eVg4?=
 =?utf-8?Q?9kYI=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aXpnNjVKNlJMeEtLQkQyWE9DUDJOdk90UVJDaHRUdUZkOEVKOVBkSHF4b1JP?=
 =?utf-8?B?ajZ1RHQyc0pFTXBSeExURGRWSm10SzBmSHBxOVFBMXNqYmw1MEFDM0FzUnVv?=
 =?utf-8?B?VzhRczVPUk1tbFlvYXJUQitncHZDblljbHhYOGtxNUhFWG83cC9PS085Q3Jw?=
 =?utf-8?B?bGRxZUR4U3FnNldOak1LVHd3SVVieU1aVGxpV1NiM0FDUHVuZUY2TUJjTVBk?=
 =?utf-8?B?SEVPTWkzQ3V2RXgxT1hXVWlDK2RyS0g0dlZYejJOUnFvTFRSU2tlVjdrSy83?=
 =?utf-8?B?UEw1cFJzRUhNS3h3ODI2b2xFTUxqY0dNNUtYdGFHWHZmTFpGVzVQdWVVck04?=
 =?utf-8?B?ZFFjaVZUS1VXZ3pSZzFyUEx6dUlSTmJ0b2haNVk4YTRoWU5VMXc1ekxtSi9R?=
 =?utf-8?B?MnZoYjVqelFudTRJcXNTYmpoTjNWbVp5Q2QrYTFjMENZOWpsd2Z3b1VIVlp1?=
 =?utf-8?B?ZHVhek1tNUFoTHU2OEtCZjIzVDJRY3NFVWV0Qk9WRDFWa2lSdittamNyMEt6?=
 =?utf-8?B?VWVaYkg2b043c1ZnMEl6NUJ1Q3Z1NWc5S3hJbTY5YU5xb0w4Sm04RzZaRU5I?=
 =?utf-8?B?UXNRSWZRdkFCaXBvdUtDOExQZ24wZ3RCVnFsemk2Q3JTZ2lBSjZSTWloYjhs?=
 =?utf-8?B?NFFncXpHd2VsT3lKakFRVmErWDN2Y0pnRkFHSTUvTEFWUzNBY2Nxc2tVQ0NE?=
 =?utf-8?B?L3FPb1lKQVNWVFc0STZrbHdoMHlNNjRaai84bExyZTNQKzIvMWJHeDErbG1Y?=
 =?utf-8?B?WUhJcTNzVUdIdytzbk1aVUdBcmphdzVwb0Rkb2tnNWJUd3FieWczK25QNGg4?=
 =?utf-8?B?ajVZbzBkdEh3Z05RWnpxa3dmQnA2cCtIMjM4VVNiZFhzY00wa05kM1RzWG9W?=
 =?utf-8?B?N2JEeFpYK3BpbSt4MzlWZSt0ck01ek43QXJ1MWFTMjhoRngyOFF2QU1NL0c5?=
 =?utf-8?B?YnNKbG9RTzVrdDBIL1ZjLzVwcXR4cU03REI5a29Mdm8yb1ZIb3ZuWnFNQkl5?=
 =?utf-8?B?RkR5V3JWaEZWR3JsRStZNG1pTDg1VG9ZMEZ2WGlpekVoMXU3YlpRSGFmRW1i?=
 =?utf-8?B?ZFNwNXpDZU5VSngxQVducmVqSW1JY2pyYW81cVFad0JPS0ljbVRySjJzbElm?=
 =?utf-8?B?WExrL0JDL0tpaTZtWHBnTEhKQXdIU283cjhvQlY0V2ptY3BIVGdZdWVoelEx?=
 =?utf-8?B?LzI1b0l3SXBocXM5ODdiSzIzTVJMNFczdnRBKzFUVFlxSkxlM3BtNXZSN0h6?=
 =?utf-8?B?bnIvTDdGWktNbmdac1ljaUhkNXpWcE1sZHZPN1NHbGFwci9pblE1SzJRd0lj?=
 =?utf-8?B?OFIyQlJacE5sT3lraGYrTEVMTzgxaGVUbExKUUNObVlPTmhQNmhXYTZlSTVx?=
 =?utf-8?B?eHhwczN6MEJ2YzJiRnNBOWZGSGUzdGdMVktab1d6a28vY2ZsdjVJSXBxa3VL?=
 =?utf-8?B?OUpIVk0yNlNTdjdlYmRUcC9hdTdKenBVTkJ0clBMUFcrNXA4VnE0NFptZjJt?=
 =?utf-8?B?WHE4RXZGN2JpQngwY0tDL05zQkM1aDBtRGtaZjdPM3MxSFlhcmxIdFRsT3dr?=
 =?utf-8?B?Zk1nTEhYU3NYU3UrUGQxRSthZzkrQTJzS3lTa2U2cEtYNkV1U0docktPVjZI?=
 =?utf-8?B?b2RSQWlOM1hHa3dBMU90L2JQa3AzNlBzWmlYWTAzR3k4UytXR1dCd0tKaDlo?=
 =?utf-8?B?dVpMTWFLNjFWRFhzSlZDdXV6VUR6VGFOK3pEbkFWd1pCZkJEbWVYLzFzczRN?=
 =?utf-8?B?RjROYTU0VGZTQnB4MURJb3VsZFVkckMrVUFQbUt4Um5PSWVKNGlzUWNwM1l1?=
 =?utf-8?B?TWx2N2dxZ21pbWlDUWtwdkZldHduTTFteW1Md3NSeHZ0eXoyeTRwTzR4c1dt?=
 =?utf-8?B?WFV0V29OcDNhbkFoSExocHRsYzRTTTFBRjZocFVzMXdjTUxEVXE2Yi9ZQWNv?=
 =?utf-8?B?YTdqTU02SndzSkN0eHdjb2dTQnVkQk9oNjJqemtQcFRlWHJHSWhRMElNU1Js?=
 =?utf-8?B?R2JaSkhRVHU4U0NPd08yeXNXU01wc2twNy81dE92R1BSZjBmQjYwcDlRSDlG?=
 =?utf-8?B?Y2hzZml0VVU5VzBTSUU5a2Y3RXBtZXpKNGhYNWd0TmFOOEtXaGJ1Y3dtazdM?=
 =?utf-8?B?bCt0cElKM2NOWlpDeVVIZi9jaS90a1pzN1BWL2dhY25BbWJCbW9IUDA4enFt?=
 =?utf-8?B?dmhDMGZDVjFvbzIxREwzRlJjYThzaEFzN3paZ0I2K09kVk5Jd0VNUGpGejFq?=
 =?utf-8?B?ZDcxa083Tkozd0Fnb1JSMUtBQzZGcUtwUlkwRGJrNllHNXRZR1VSRG9XdmRk?=
 =?utf-8?B?UGcycHJ0RzZiaFNSaGZIbytDWjNHRm9NSStXWU5seWdUNzJHTGFybXkrU0Rm?=
 =?utf-8?Q?ugC8rkhrnA2lnty8=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d526619-8dd8-465f-ad7f-08de680b3506
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2026 18:44:07.8642
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kRFilPSSHWj/YWblqH0zxejSIlmGsXD3VD0PmmZFc6ZAIBXl81K0N237EnGbIHrBI4WJtehtBz1ltHkIGX/zOTaZ53oFUlebjKCsSEekaCg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4646
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[43];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[10];
	MID_RHS_MATCH_FROM(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[reinette.chatre@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:mid,intel.com:dkim,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	PRECEDENCE_BULK(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70638-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[intel.com:+]
X-Rspamd-Queue-Id: C36E8113C00
X-Rspamd-Action: no action

Hi Babu,

On 1/21/26 1:12 PM, Babu Moger wrote:
> On AMD systems, the existing MBA feature allows the user to set a bandwidth
> limit for each QOS domain. However, multiple QOS domains share system
> memory bandwidth as a resource. In order to ensure that system memory
> bandwidth is not over-utilized, user must statically partition the
> available system bandwidth between the active QOS domains. This typically

How do you define "active" QoS Domain?

> results in system memory being under-utilized since not all QOS domains are
> using their full bandwidth Allocation.
> 
> AMD PQoS Global Bandwidth Enforcement(GLBE) provides a mechanism
> for software to specify bandwidth limits for groups of threads that span
> multiple QoS Domains. This collection of QOS domains is referred to as GLBE
> control domain. The GLBE ceiling sets a maximum limit on a memory bandwidth
> in GLBE control domain. Bandwidth is shared by all threads in a Class of
> Service(COS) across every QoS domain managed by the GLBE control domain.

How does this bandwidth allocation limit impact existing MBA? For example, if a
system has two domains (A and B) that user space separately sets MBA
allocations for while also placing both domains within a "GLBE control domain"
with a different allocation, does the individual MBA allocations still matter? 
From the description it sounds as though there is a new "memory bandwidth
ceiling/limit" that seems to imply that MBA allocations are limited by
GMBA allocations while the proposed user interface present them as independent.

If there is indeed some dependency here ... while MBA and GMBA CLOSID are
enumerated separately, under which scenario will GMBA and MBA support different
CLOSID? As I mentioned in [1] from user space perspective "memory bandwidth"
can be seen as a single "resource" that can be allocated differently based on
the various schemata associated with that resource. This currently has a
dependency on the various schemata supporting the same number of CLOSID which
may be something that we can reconsider?

Reinette

[1] https://lore.kernel.org/lkml/fb1e2686-237b-4536-acd6-15159abafcba@intel.com/

