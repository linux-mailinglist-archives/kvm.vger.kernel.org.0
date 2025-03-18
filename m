Return-Path: <kvm+bounces-41343-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BA3E4A665BB
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 02:54:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B008D7A5531
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 01:53:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F683146D65;
	Tue, 18 Mar 2025 01:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iNjCdWRh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 940FF8BE8
	for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 01:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742262870; cv=fail; b=K6ljPx8tQIZezSqvO5NRegCAtMvjtqTJVUITK89+Xpo9/qNZs2n3b7FL4qAuZ+H91eBC28ONe+mTM7hTbBOHK9awUxQzaTnKWtzaZBzzgGHUZ2E4i1z6J+fNpeX0o1GQgkr7K7n23cIaoB+xKsyVoSLQJNR7edSqep6fqT5E2pc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742262870; c=relaxed/simple;
	bh=f1rJjPPgsTmcEDtTPTdQOusFKN+PS11ZVZpYugcXfuk=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=LZ4ayfUue2490vZnmCNy0dx9tFrjBvoFBuzmxFfCeh6/IVIMQmVNxCzoq0S+3uRBbEHngMDkGQMRz+zSpIBR8wOBXU08IMpr4U5lgosA1N098OgnQCYi7qPq9f6HiRkPE4yJ9bOmloxStOdKZC8lfwawymIZHk7CvG7UTOSry5E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iNjCdWRh; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742262868; x=1773798868;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=f1rJjPPgsTmcEDtTPTdQOusFKN+PS11ZVZpYugcXfuk=;
  b=iNjCdWRhjtrJljClqrExc7ZDD6/IItbTJBQbIqMWe1Y8iz2WmOLQWzxe
   nh7/WkqG6uzPINpZfHiildNIPuvqHB0/v2BcamV7NzgqoKDLJs5gdADVt
   /ehxSWReFx8I0eDzECVrQzKl6b8iDZYXTwvYxsUtkP/heHdGrr/UN9JMC
   5Xp/pafN3OxzanUtz9wFXddUQooPKX4vtLLFFoiihl+gswaP2jHv/E2M+
   mlF4IubLPBQ+NPaeTVLtazSMf9PXwaSLZ+C13dkkcUgsHPjV+OmPU/+4C
   4kHRC9b11wWuuMua4/4smPN/quDSFgURmqoU7mLSyOLDliCoE6xGDvw8w
   A==;
X-CSE-ConnectionGUID: ecKFleXdTFO+TSeNGGVtfg==
X-CSE-MsgGUID: afzH9+VzQN2FByq7kaCCCA==
X-IronPort-AV: E=McAfee;i="6700,10204,11376"; a="65840983"
X-IronPort-AV: E=Sophos;i="6.14,255,1736841600"; 
   d="scan'208";a="65840983"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2025 18:54:27 -0700
X-CSE-ConnectionGUID: fnrOVVL4SBO5+wNVS8+UfA==
X-CSE-MsgGUID: sUlFqg4MSb263WMhTiA+nw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,255,1736841600"; 
   d="scan'208";a="122103005"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 17 Mar 2025 18:54:23 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Mon, 17 Mar 2025 18:54:20 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 17 Mar 2025 18:54:20 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.41) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 17 Mar 2025 18:54:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zRNH/lQLDD/IIWhaTo0vs2vwCkJttWB1qlttcGu2JsUfKM32d/+VBsFCMfs4EvFBo1AKvO5VCzYq/nIGkwH/tFTNLSTZdWmxRKKQk6H1yiCLHIRCQJm3qYP9hdEDtjt8eE7Fp6dTCMvyFXaltpTQDhk9kCCeFJ25lpeNdPM4jy8kPsdHvncYLKnHbplQjS1tS5z341XK4PRFQCOp+d+rvNc9u5u9nJ14jWV0Kd3DmZSUXUFsnzqMm1QCOgLvy+P4lqUbnpmR9fhrKirVeVQN4e2OiuPob9bwsndJ9OFeAarfjgaXaeLoWaMEnvbDVQ1DDQzqCsn5Gp2jf+DPlFm8ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m0Dus/kIuTDUenR7e3KWfZrIb5BFqFVGIc0M46rg2J4=;
 b=wsPlQkAcJ2ea0JE+KBWVFMJYzdaUcbH0Ausso3pVZbj7zkHLtFrL76OKfxOLrTofhkc+jLXVtLW0alnmeWFtNgv5A1xg5km/f3EKVM01JnK6wDR2Q7OPOWuOXOl4diVoDgNB1g9XdmsVVXGtjnEdZ62oqypcDRPR9Q/k9PvzBWLRddpesYIFKUMkHHDJsSWvXDC1HZw2iHbn59XDY1co2DqT8/WViHt/nrEz42NEt1j7gGtHzUHYBE39vxq5gSsyR3kBl1W+KGfWLRzIdhJHT2qMYgu7K5GW9/Sqzpuo5g6+cKF6+Y82BVFVnTNIPDESBVRrH/g7dOwQH5sX7rssvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 PH0PR11MB7493.namprd11.prod.outlook.com (2603:10b6:510:284::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.33; Tue, 18 Mar
 2025 01:54:17 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95%7]) with mapi id 15.20.8534.031; Tue, 18 Mar 2025
 01:54:17 +0000
Message-ID: <9c05e977-119c-481b-82a2-76506c537d97@intel.com>
Date: Tue, 18 Mar 2025 09:54:08 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/7] memory-attribute-manager: Introduce
 MemoryAttributeManager to manage RAMBLock with guest_memfd
To: "Gupta, Pankaj" <pankaj.gupta@amd.com>, David Hildenbrand
	<david@redhat.com>, Alexey Kardashevskiy <aik@amd.com>, Peter Xu
	<peterx@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>, Michael Roth
	<michael.roth@amd.com>
CC: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, Williams Dan J
	<dan.j.williams@intel.com>, Peng Chao P <chao.p.peng@intel.com>, Gao Chao
	<chao.gao@intel.com>, Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao
	<xiaoyao.li@intel.com>
References: <20250310081837.13123-1-chenyi.qiang@intel.com>
 <20250310081837.13123-5-chenyi.qiang@intel.com>
 <2ab368b2-62ca-4163-a483-68e9d332201a@amd.com>
 <3907507d-4383-41bc-a3cb-581694f1adfa@intel.com>
 <58ad6709-b229-4223-9956-fa9474bad4a6@redhat.com>
 <5a8b453a-f3b6-4a46-9e1a-af3f0e5842df@amd.com>
From: Chenyi Qiang <chenyi.qiang@intel.com>
Content-Language: en-US
In-Reply-To: <5a8b453a-f3b6-4a46-9e1a-af3f0e5842df@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR06CA0013.apcprd06.prod.outlook.com
 (2603:1096:4:186::18) To DM3PR11MB8735.namprd11.prod.outlook.com
 (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|PH0PR11MB7493:EE_
X-MS-Office365-Filtering-Correlation-Id: ba2ecff7-c545-4d32-63de-08dd65bfcac0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?RDFheVFnMGcwaEJ0OHYyMUtmbS9aeWthd0JPYStqL2QzTHZpVWFQRDJtVExs?=
 =?utf-8?B?aks1MDh5bVQreU93WHF4YmFTempjNUh4cFhsWFFUL2RtRm5Sa044VnZMN2pV?=
 =?utf-8?B?bjhkRHpTL0VObDdoMDd0WW56OUxCQmhlakxBbWhaVWlaY1FJU1hEV016M2x4?=
 =?utf-8?B?NVlsYTB5SzlTUFNMbEx1VTJGWWQzMjhmZmIwY0o1c1NVUUdweGJsV1YzM2Uv?=
 =?utf-8?B?Ri9BTmhlNGQwa2RvS0ZyK2ZIY0o4SjRydnZreUc4N2hNcXFCY2l4L2NLekRh?=
 =?utf-8?B?SGJuajF0UFY1SHdYTDZJRWJNK3pTaVJoeDU2Ym1PM3BIZDlUQXEwcWxJNWc5?=
 =?utf-8?B?cFVZWUlRZDlkVG5nNUtFdEFRdXVRemZxL0NnR1RyaUpTUkYxRDRhU2prdm5G?=
 =?utf-8?B?eW1JanZqZUxSdGJ6bXNJVmE0RHN5dnd4OCtGT2NuWFNDMFlYYzVQZnMvNzNI?=
 =?utf-8?B?Z2t1T3l2QVhQb2VxckFWTFIrUGkrc1p3dTRPeXlOSmpMYXpUR0U4cEVhK0Jz?=
 =?utf-8?B?MXRtRVpDaWpvWGd0NG5US1VtR0duMlZDZi91dWk0aE5rSGxaUnc3Nm83Uzhs?=
 =?utf-8?B?MitJOFlFakNCbStiRXBpc3lFa21kOFF3UGZEWkF4RFRMb2dMamZ0Ym4wRGJO?=
 =?utf-8?B?RjNQbFNLWktmQ1dpUHdVNzFVak05QWE3TVhnZEhtREdCQnJQdUFNYzYyUkVF?=
 =?utf-8?B?SHpKaU9rN0FpZFJpUkg3RWp2RUhmeEpzaUI4cG5ja2dJaTdNVFBObGxGTy95?=
 =?utf-8?B?TGxHbmNhbWxWbXFiWm1oMm5rYkVSMmpCL2JRZlZuQXdPczN3cXhudFRWQWpQ?=
 =?utf-8?B?aEx1NStiY3JoamxlMC90UUthdGM5ZHRmWDdNUDV5OTdIYlNoeUw2Z1F4OVZP?=
 =?utf-8?B?bUQzMzJER2Y0OHF6TGw2NXZpcGZqakVtTTAwZEpyelV3ZXFhWTFmS2NXRkp6?=
 =?utf-8?B?NnNDOGlKQUNsOVdNYXMzcktBNi9ka25rMmx6YlIxRDlqQ2M5bHI2ejE1WDZV?=
 =?utf-8?B?TG5kelJPWUpwTDZnV0ZsYzFqSjJqVnNiY1RnODVYVGMzZktyYTgzVE5aRlI0?=
 =?utf-8?B?WWRlWHgwTWFXY0lIaEY2M2dPN2hzL2xiWDNHSDYrcTc2MG5GVEJ3K3QyZG9w?=
 =?utf-8?B?QmNleEVjVzd5S3g0N3RiY2RGTmJCZmg3SnpNTW5QQ3N2K05MUDNFTkRWOWtt?=
 =?utf-8?B?R3MrNnhHZ3BVOFNWNmYvN1BvanplcW1xSnAyVlN1ZnpBYTRZZ2NKdGJXdXpD?=
 =?utf-8?B?QXFHcjBSK1JYUzFERGVhQUExRE94b2hYNVA0ZEU2bStiRTJPZTFzWkp5TEwz?=
 =?utf-8?B?Y1BuR1QxZHV4bFNzakJaOG1CalJRRU5DcXQvc1RVall0YlZ6NTJxYm1JZjZW?=
 =?utf-8?B?R1VkUHVqdXJQVUFRMXEwNG94NThPUHBLbXpvT3IwSk9GUW9qVXZlOUpaS0Iz?=
 =?utf-8?B?clYvcjh3TUlrZXhMWnJHelhqV055cmp2RUxLK2xvNm85a2Naa1djZTJ0RHFs?=
 =?utf-8?B?WUlWaGJ4S3NIYUtUNWxwZzdxTlZxNTdPTzAxMHRuajFDKzlabU51MU1MbGJK?=
 =?utf-8?B?T0tuVmcvcVhHQzNqYlVEZUxIOTRDbjM2eWNNMUkwQ25QRExYSmF4Tm9QOXNk?=
 =?utf-8?B?ZzZQTm9VLzBObUlPWjVieTlKaFlPWVlybU96YXpqSi9QSTM2THl5NUlvMCtN?=
 =?utf-8?B?K0lURTl2ZG1JRDlJYXVUelY4TlhGN2N2L3hJZG1oWlZkOCtEN2paeDA5Z1cw?=
 =?utf-8?B?TzBIVTBOQTBDS1NoVVVoTUIxWVVzYnNsNXFMVjU1YnZJcWZBOUc5SllVQWJE?=
 =?utf-8?B?cXArRmhUK1BiSGFtandWa1BPM2xsdVhaWjVIZzVKenJYWnEyemV1Q2k4bC9a?=
 =?utf-8?Q?/y4G3eh/lj4Mm?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NW5mUHlwVHhxamY1cFd5NW1CTExiSUk3R2lJMEpZM2RsRmlnMUt5cWRBMzRu?=
 =?utf-8?B?UXRQb2tmZ0duWWlIcXk1Y0lKZTVNd0U1VkNYN1psQWNJRU11U1J4VjNzQWRa?=
 =?utf-8?B?bXJEMDlZNUtSWXpRT1VyK04wUnM5cWthcVFYZ245blhQNDBhalRiZ01hTW9B?=
 =?utf-8?B?dzNNSFRMeHdBV0JhamdTem44cndTUlFYWjZEbHFPV0E1VzU4OGsweHc4U2Zp?=
 =?utf-8?B?VmlJVUUxRWVBdm84V1NzUVhNRkVuVmdXNTVjTjdDY1V0aHVrNEkxSWZGWE9w?=
 =?utf-8?B?ZkxMRDNYRzBpQlJpd3cwUWFYR1JKdWtKcXE2bGV4aWthZTc0c0RXSVFoSnRT?=
 =?utf-8?B?Sm1zYU1ZelpidjB4bTl0bzJPQ0IreldTSjFRMTBFMStrYzJERnFmQUd5dy81?=
 =?utf-8?B?bmI5N1Y4RHo3YmFhRVFSUWp6RDdJK0xwZVY1QnlHSnFkcGo0Mm40S09zL0Zh?=
 =?utf-8?B?RDlNdkhCbHNRYytmNXhBanlXcnBPVE9xYTAxKzA0M2NDblhHaXBuRUJuY0VB?=
 =?utf-8?B?alduYWhIazRBR1pyaFkxZE1BQ0xyWlQ0WlRNNk5RaHMvakdIdkRiZ1p2Qmhy?=
 =?utf-8?B?RnlCWE12UmgzZTBCMTFDZ2xyMG5seERQS25LMEVWRnRKTFh0ZEE0VzFqRDlQ?=
 =?utf-8?B?WE9ab1dsRGovaWh2MnAwMWxtR0oyWTdINEhiL29FRnNkcVJ5OEZhWTVmd0g3?=
 =?utf-8?B?QUpYaGpremloaVdWM210TmFtR1dnVVBCZEo1MXd0Mzd4Z0wzRk5TVXRwY1p2?=
 =?utf-8?B?a2lzSGhJSlFpMnVyV1BaMHJERFI4N09iaDdtZkdBak8xSFJDRlcvcjRZclZQ?=
 =?utf-8?B?QXlDdHZhRVloRTN2djF3bExvSUlFbGV5YjlBaDc4MHF5S25FdHZVVU1LY2Zk?=
 =?utf-8?B?cTVxdFRPTDhCeDlWODJUbE9wWGZjUWhwNXQ3RXlQNjNZckJiVm5BUTY4eWJW?=
 =?utf-8?B?Mkd6R3RpdTd6QWxUNFhadG03cDVpeTZHRzVlQ3lqVVpKOE5ybmNFVzFIY2pP?=
 =?utf-8?B?ODRtQUVMcjVIL2F3WHczbWJFbWpsRmhuc0RJc3lKRVdYT2xrSVZxT1JVWjY3?=
 =?utf-8?B?U2FYamUzYUI0cnZPMDFQNXV3TnJIWmxrazJQei9KTHZScHZzYTY0MlIrM3cy?=
 =?utf-8?B?VXVtUkk3MzRsb3NtZHBNZ01nZHlMYlhaK3MwTGphUGcwcmtTdkhjVXQ1VlNO?=
 =?utf-8?B?cE9kcEtWMFVJV3J1emtDb3o1cXNPVEhpMHF3U0NQUENuZWJPUGlvYmNHekxM?=
 =?utf-8?B?ckV3dTZmV0dMQTRZOEhiTjM5clBuQVdhVXpHWmp3dnZjZDdBNDJzTS9LTWIx?=
 =?utf-8?B?RWV6dC9heWJJMnZveEtIa2gyK3ZQVXdab3BHQWZ0RldUMUJ6eDFaZ3JZYi9v?=
 =?utf-8?B?YmY2dFZyMHB3Tm04V0FoUEdaU2NVQnFyT2tXN0NyVEJVYnZPQlZKMjZNeXNI?=
 =?utf-8?B?R1NCdVRaRmd3Y0huaGVQblhCOEJXYVdvRkFjOFd3aHVjcFJpMG1LWFFKMlpP?=
 =?utf-8?B?U0RvT1BvcU54QUE0b2VnUS9uRm9jUWRMNitPbjlMbkxSY3FVN1RPZUF6Nld2?=
 =?utf-8?B?a2FWZFFYd2tQaHZsbHJXR01wVGlUM3JEYVdsMVVjbElKeWtoNmNJeDVsWm1a?=
 =?utf-8?B?WkFtTE01L3YwUDJzUUtlNnUzMDhxSDVOWndkY0JwalJTbFFPUzhvOW1STWN1?=
 =?utf-8?B?aTZsS1AzMjdPUjVQdEJlUE9POHYrMVZrdWJ0K3FHWU9DeitRK3Y4ZXhYUzdY?=
 =?utf-8?B?N1dKRFJkRkZteHRpUWQ3cEFwS0w2amhqRE91Qlk1ZFA2ejM3eENkNHdGQitp?=
 =?utf-8?B?OGZRUHphVGoxODk4TnU1L3hFRkhkemF6RGZjcTN1ZUlHSHk3bmxBelQrT05G?=
 =?utf-8?B?ZC9yTFFPV0N4SVRDRnFNRHgwQWh5akplaWxaK1lpOXFEdktiVkp5cU1senRi?=
 =?utf-8?B?aEptR3ppM254aVdGQncyOGM0V0k5Wjc0R3MvMXp1d2pSb2ZNdVhvdVJCcFN2?=
 =?utf-8?B?TWNzdE5uUENlSys0VjAxQVBsSHVxS3R0aERPRVRhVXRHelpxa2ZpeFdONm5l?=
 =?utf-8?B?RDlvNEZUN0NueUNEdXB6ZzFsMzNnLzV2U2N1QnZvNHVxWU1DWVpHUHZRUjMw?=
 =?utf-8?B?Tlhnd2JyYmhJYzJUQjhPd1RJVHp6aFBubzBLTmpJemc1SERwUXM4MVpROGJ1?=
 =?utf-8?B?cGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ba2ecff7-c545-4d32-63de-08dd65bfcac0
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2025 01:54:17.4935
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y1OyMvqOHXMrCSVYVV66lYK2NMbEMm34IKl9lcmZCRk8Lp3Wv9LR6bA010YMhO6nsRFwOGzsg6QyzhtQbPBWEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7493
X-OriginatorOrg: intel.com



On 3/18/2025 1:01 AM, Gupta, Pankaj wrote:
> On 3/17/2025 11:36 AM, David Hildenbrand wrote:
>> On 17.03.25 03:54, Chenyi Qiang wrote:
>>>
>>>
>>> On 3/14/2025 8:11 PM, Gupta, Pankaj wrote:
>>>> On 3/10/2025 9:18 AM, Chenyi Qiang wrote:
>>>>> As the commit 852f0048f3 ("RAMBlock: make guest_memfd require
>>>>> uncoordinated discard") highlighted, some subsystems like VFIO may
>>>>> disable ram block discard. However, guest_memfd relies on the discard
>>>>> operation to perform page conversion between private and shared
>>>>> memory.
>>>>> This can lead to stale IOMMU mapping issue when assigning a hardware
>>>>> device to a confidential VM via shared memory. To address this, it is
>>>>> crucial to ensure systems like VFIO refresh its IOMMU mappings.
>>>>>
>>>>> RamDiscardManager is an existing concept (used by virtio-mem) to
>>>>> adjust
>>>>> VFIO mappings in relation to VM page assignment. Effectively page
>>>>> conversion is similar to hot-removing a page in one mode and adding it
>>>>> back in the other. Therefore, similar actions are required for page
>>>>> conversion events. Introduce the RamDiscardManager to guest_memfd to
>>>>> facilitate this process.
>>>>>
>>>>> Since guest_memfd is not an object, it cannot directly implement the
>>>>> RamDiscardManager interface. One potential attempt is to implement
>>>>> it in
>>>>> HostMemoryBackend. This is not appropriate because guest_memfd is per
>>>>> RAMBlock. Some RAMBlocks have a memory backend but others do not. In
>>>>> particular, the ones like virtual BIOS calling
>>>>> memory_region_init_ram_guest_memfd() do not.
>>>>>
>>>>> To manage the RAMBlocks with guest_memfd, define a new object named
>>>>> MemoryAttributeManager to implement the RamDiscardManager
>>>>> interface. The
>>>>
>>>> Isn't this should be the other way around. 'MemoryAttributeManager'
>>>> should be an interface and RamDiscardManager a type of it, an
>>>> implementation?
>>>
>>> We want to use 'MemoryAttributeManager' to represent RAMBlock to
>>> implement the RamDiscardManager interface callbacks because RAMBlock is
>>> not an object. It includes some metadata of guest_memfd like
>>> shared_bitmap at the same time.
>>>
>>> I can't get it that make 'MemoryAttributeManager' an interface and
>>> RamDiscardManager a type of it. Can you elaborate it a little bit? I
>>> think at least we need someone to implement the RamDiscardManager
>>> interface.
>>
>> shared <-> private is translated (abstracted) to "populated <->
>> discarded", which makes sense. The other way around would be wrong.
>>
>> It's going to be interesting once we have more logical states, for
>> example supporting virtio-mem for confidential VMs.
>>
>> Then we'd have "shared+populated, private+populated, shared+discard,
>> private+discarded". Not sure if this could simply be achieved by
>> allowing multiple RamDiscardManager that are effectively chained, or
>> if we'd want a different interface.
> 
> Exactly! In any case generic manager (parent class) would make more
> sense that can work on different operations/states implemented in child
> classes (can be chained as well).

Ah, we are talking about the generic state management. Sorry for my slow
reaction.

So we need to
1. Define a generic manager Interface, e.g.
MemoryStateManager/GenericStateManager.
2. Make RamDiscardManager the child of MemoryStateManager which manages
the state of populated and discarded.
3. Define a new child manager Interface PrivateSharedManager which
manages the state of private and shared.
4. Define a new object ConfidentialMemoryAttribute to implement the
PrivateSharedManager interface.
(Welcome to rename the above Interface/Object)

Is my understanding correct?

> 
> Best regards,
> Pankaj
>>
> 


