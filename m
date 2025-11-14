Return-Path: <kvm+bounces-63279-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 45CE5C5FA4A
	for <lists+kvm@lfdr.de>; Sat, 15 Nov 2025 00:56:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 54EE535A19F
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 23:56:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54BCC30FF1E;
	Fri, 14 Nov 2025 23:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LdlXrU47"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD2E423EAB9;
	Fri, 14 Nov 2025 23:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763164533; cv=fail; b=I4lCKZGSB3i0v7GuOQtDnR7JGR4OWkJY+QZeHyZwWgGmFHmySrp3HlSHRDhIZ5+MmZ8T0w5e8wHuqtGc+gPf8jxqp3Uy3eMeiaHJrClONfNbslTfv8shOGAZ3xaiMZj6eH+J+FW03IOvE++bLUPAgx0hovbEpy4CUArqRdin6vU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763164533; c=relaxed/simple;
	bh=Mp6B6AJiDmgn8yP01BXGN1TO8X0m4e/blmoC5hVDiXs=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=B7jkLb9qz/4CdtfAojFf4TWTPRll1weadEpXH93lQiaeL+iIUtkXBuNds1+LsuI4WXqlv7pH5IWAM2S2qkhueBjME5KrJAs/30W73Zy+VPKF0S0Fb5vov/k/6beKQA5YuyQu9ULfU8hqlVh/DQrZ8zOykcvZIUrb9kzrIJdrcp8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LdlXrU47; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763164532; x=1794700532;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=Mp6B6AJiDmgn8yP01BXGN1TO8X0m4e/blmoC5hVDiXs=;
  b=LdlXrU47nzpqUj5e5N9Um8TlnO/IvxjTzbIUJYK1httOu0f/WwvJ/tVW
   3/6BvtSCWwJYfrUqpMidjd5YxilUX5hmR2a+3EHFnu3XxupgjW27iJXqX
   hLexdg9Tx3mrkL+ZiHvCayH8AEci5FiI/Rlq9KUJ6OlecY6Ud5UA4hIh8
   x6ygWWY8fzOv72F+wb7rVVIwLibTBDmNvXjssbivA/Fp38OSg1eCTgmFS
   EEN4CKSoTp7k323ksW4CMdn+wdh4SqAQ+tmFZaFP0YS4c8eqSxCPgJjlG
   AStiNH9LaAq0NTrztIymAflR8ohsDhnGjvmjE6gLjI5cDmYgReZj1ZGXX
   g==;
X-CSE-ConnectionGUID: TYIn8ehzToiR2KWFJnykCg==
X-CSE-MsgGUID: /64T+0mDReOXgyHwW8imFw==
X-IronPort-AV: E=McAfee;i="6800,10657,11613"; a="75943430"
X-IronPort-AV: E=Sophos;i="6.19,306,1754982000"; 
   d="scan'208";a="75943430"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2025 15:55:28 -0800
X-CSE-ConnectionGUID: PZk7ibrASJuGv7bJCuWGOw==
X-CSE-MsgGUID: 6xVVuAW4Q0Crcwn8XNCDsg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,306,1754982000"; 
   d="scan'208";a="194343589"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2025 15:55:27 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 14 Nov 2025 15:55:26 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Fri, 14 Nov 2025 15:55:26 -0800
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.22) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 14 Nov 2025 15:55:26 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ormE7DG6iFSoHMA+ApXuSHQ5TIrb1rUvfpIEVvcOsr/0sKqwav506nrRLXIEZByHZqG4KS2Cwn1SOJr0DiH3/KDQ6k08oSlkEpEULj2peCDoPxctayaJ3EEoexPhxfUX6cP+JlW8PtomZzbtpHazkjLy/TT6pQ8oR5qfTAYxGXg/iO5q0ymCT9AL2Dk2V+p4HA9RAnWuysQirFgz/5TvO8TG5LlSXK6zwNYKujAvhdHk2LchJcZgRqMJdH0aR2KzfAR0iddTQmet2BfVkznu8BPLvPJXF+n8Y7tvuBiKsP9DmfV7Kgv6MoKDgzWjJjf3s6U6fANXz92ee/rSmCDbaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3Ke8uprC4jih8tJPhLQxoCoLvd3+eTVI5XyurFAiV2o=;
 b=lRauXznmssy4+tIkQwMDusRatdoFxdDjWmbp30o10KjulTdP8vsfyTPxPAaksAQ1Ai0yxCXW2IObrevStIDvgBP/wZRrhB961rc7GLe1TuqzQxAHEBudRTmin0lO/R7OnVP74aEUg2fNqPTlFg7/CjTEd7nmRFcb1hFNo4OBSatu0fxWQ40AjLfcMWbimUDARtD8a+J94K+v7oyEq+4u2lpyvgzmlT/kyzPk6oPaI+VrqeECMKyz05Mxb6OWvJBhlCkFh4xneCcgcjEMTyPM1CywNx+GNncTr9UZQyvdvPTeAh9GtGlshA1JPCv/WeRADdlxfR1Yc3ngLF9EtRTz1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by MW6PR11MB8340.namprd11.prod.outlook.com (2603:10b6:303:23e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Fri, 14 Nov
 2025 23:55:23 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff%4]) with mapi id 15.20.9320.013; Fri, 14 Nov 2025
 23:55:23 +0000
From: <dan.j.williams@intel.com>
Date: Fri, 14 Nov 2025 15:55:21 -0800
To: <dan.j.williams@intel.com>, Sean Christopherson <seanjc@google.com>,
	<dan.j.williams@intel.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, "Kirill A. Shutemov" <kas@kernel.org>, Paolo Bonzini
	<pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <kvm@vger.kernel.org>, Chao Gao
	<chao.gao@intel.com>, Xin Li <xin@zytor.com>, Kai Huang
	<kai.huang@intel.com>, Adrian Hunter <adrian.hunter@intel.com>, <aik@amd.com>
Message-ID: <6917c1699405c_1015410078@dwillia2-mobl4.notmuch>
In-Reply-To: <68ed96e9bd668_1992810019@dwillia2-mobl4.notmuch>
References: <20251010220403.987927-1-seanjc@google.com>
 <68ed7bc0c987a_19928100ed@dwillia2-mobl4.notmuch>
 <aO2QJ-YapvJXxE1z@google.com>
 <68ed96e9bd668_1992810019@dwillia2-mobl4.notmuch>
Subject: Re: [RFC PATCH 0/4] KVM: x86/tdx: Have TDX handle VMXON during
 bringup
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR04CA0001.namprd04.prod.outlook.com
 (2603:10b6:a03:217::6) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|MW6PR11MB8340:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c66d664-19a1-417d-32ea-08de23d9468f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?dE5mUXRrVUo5dmxDZVduK0FLeTBFV01qSHRWeEZGRWxvV0p5R0YxSE9nWDdI?=
 =?utf-8?B?Q2p3V2kwZlVaSEhjaFhFOGFGYURHcWhmWVNLK3A1RVEzU0pucXQrTkRIdE96?=
 =?utf-8?B?T2kzQVN4aFpNaDkwT081NXVZdFdNNEMyQzB2NGZiS2hMY0QzcmMwOW1zNW5l?=
 =?utf-8?B?Mjk1M3B1ZHg0VVd3SENhSm8rSi9UdkZQTlJaR2xCZm5vZWw2WmFPSDE0MzhH?=
 =?utf-8?B?UzhpTGhtN3I3N2hNMEhjWjIzRkxqc0hEcjJzMnVKRVl2dS9Tb3JFTXlZSlha?=
 =?utf-8?B?bS9kZXV0Q1UrWS9ESjZpd3l1aG1UK2dnT0FZOXdhZVpoYlY0T3E4VlB6bk1n?=
 =?utf-8?B?S2cxanBhNldDUEM0ejZuSlEyckJnTnJBN2orQjdtb25mOTZjdXg4Nk5FcDlO?=
 =?utf-8?B?UVU3NU1HelBWeU1SNHFoelJXeVRVVng1VzFhM3FBa1JLTHFnMkVNcFNxODdh?=
 =?utf-8?B?SGd6VitMVHVRdHgrenltN1M5cGdPNWlybkNWZTlpcmg0OW5FM2c0Q1NhOFd6?=
 =?utf-8?B?dFBEMXoxV1pES1FPLzF0NUVBSnh3Q3VtcHNja2ovRUJ3WG5BdmRKek1RZDlR?=
 =?utf-8?B?Nm9Fd01NY2JUV09xaWQvWnRqQmpyZTZVQjUzTit0amtoTE9ZMVBBTmxJWWlN?=
 =?utf-8?B?VkkyTVdQTDFVUU5nRzl1M0FTWFlZTm1VWlhlV0d6Y0tpOWZjejFpc0tYa2F0?=
 =?utf-8?B?a0ZMMDBORXNxYWdDYlIxbmdxNXJOL1V0Q0FCcm9Ddk1hZ1R1OExxMkpqcDgw?=
 =?utf-8?B?UkNrTFZwRSs2bjdrWXZXV3IyQnQrZEVYTG5ibG1KQ3RhRkV6N0wyRzVPdzhy?=
 =?utf-8?B?KzllOXFFeU9TakxTbzJCZWIweklqY0R3Qnk1VVhzSnlQQjA1N0F6V3JzUFA5?=
 =?utf-8?B?QVlWYmJWUUJpS3g3L0hzZXZMR3BGajl4NkttVVVLd2NrLzlXU0tlZ0MxVExz?=
 =?utf-8?B?b2JnYlRuNGptcEVSeENDbXhxejVJZVdzOUVHMVUwTlJKOFg4UGNhNXNwMTU3?=
 =?utf-8?B?VjZDdERPMXlqSVFhMTdyVFVXYUl2L3NRd0MyOGo4NWhDTWxZekc3Tko4ZlB3?=
 =?utf-8?B?SER3S1lEd09CUml1dkF1b25FcEEwRjFNMG1kaTRzWmtpRTJzSkEwTUR1Q1Zu?=
 =?utf-8?B?Y2tDRTRSNzdIMHRnRzVEZkVGaTQ3cVhWM2ZXKzdmT2h3NFk2ei90bzRuOENT?=
 =?utf-8?B?OUxyT1hGUXM3LzBTbjNJL2c3QjBENmdKamhocHBhb3ZSNGR2dE5zYmpMNFJC?=
 =?utf-8?B?YkhkNUVYWE52c3BrOTQ0TnBTRU9rZmdZbFBraXV1RUpVN2l0U1JWL3IxbGhm?=
 =?utf-8?B?cnlvelhoczFIRnNXaTB2ZVFSUnh4c1d4MHJOYVhFSDlMMG1tY2xsTTdSc2Vw?=
 =?utf-8?B?a0lUN3MwOGdwNDR5K1BxQ1hDMjZPMlVodklWa3R6OThhYlVCOTFiZUpkbEkv?=
 =?utf-8?B?MTl4Mm4rV2daWjV2UTJ0bXU5d0RlU0JGVnk3anNMMHlFN20vS25WWmNHQWlX?=
 =?utf-8?B?cGkwNCtHN0c3MkkxQVo1MWJNd1dkaWJDNUl6VWtjazFjTnk3bWIwSlU4VXB2?=
 =?utf-8?B?OWdSbm0yZEVTc2ZOb25tZkEzRjNjTDJCMTkvOEFlNEd6UUNuckNaOHBMSWw4?=
 =?utf-8?B?eEJCUmhGZ3Q3TUhSd3htdTdFSDMzRWN6czdqbWkybHIwK05TdElMOEhNcm92?=
 =?utf-8?B?cW85dUV4MmYvL2o4Wk0rb0RSdVY2MkNRRUlOdFJsS29HY0FBcHZJMFdMbHpZ?=
 =?utf-8?B?eTE5L2xwQzJ2Y0VNcitsMlhLWGhYbHd4cWp6Z1A3ODNlb2dtNWFESDBwKzN3?=
 =?utf-8?B?bWNaVVR4TFJrTXErSFp4K0lKcmVrekZtdlpVK1o0aCs0Si8vSE5uTm8xVVdy?=
 =?utf-8?B?bEthclo0TFlGQXNMWm1JZElhSTJmdEg4VUVNeEY5UkEyWFFFQjczSDNDTWd3?=
 =?utf-8?B?VEVqdVBZZ3U2dG5OZzJwSmNRUHNNc0tvckx1eldxSkNSbkJ2VXpBNUpDYVY4?=
 =?utf-8?B?VkJtR1NMaXdBPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K3I0Q0hJUXZEdUE3a1hXTmtFZU9OV0pPdjA4eU94NitLZ2Z2Uk1QOWVkVERu?=
 =?utf-8?B?TWpvUC9uVlNwVzBEemMxZG1Rd0FYT245cUd3aEdaMjlEeXNCT3d1V0JTcmt5?=
 =?utf-8?B?Smx4eFhZYzRmclJxSDYyUE95Mm1tWWpBRGs4Qm91NklZcnFxeER2SHM5VzM0?=
 =?utf-8?B?OFhGNjhid2p4ZkJlckhBbm9XSFVvRGh4L25VOG90N2hpTG9PdmlrVGpkUmc3?=
 =?utf-8?B?b09kZlRsd29NSFBuMldlcWJRbE5rMGRuaDUyelZpckZkdXhpZEplaERDSmlG?=
 =?utf-8?B?RzZvL0Zzc2o1Yk9tM0hkeHBiWExpM25xNnRqN2h1aG1QOXY3V3BNK2JCbXlY?=
 =?utf-8?B?R0QxcGpGZnJ2SktZeFRjVTR5SlJVbWNGNng4OVdiNFdSU2RwaXU5SDRNd215?=
 =?utf-8?B?bjBjd3NTNk1QOFE3K1plUC9MTWNRYk5Tb2dBcWVzZVVkSFdDVW1sWVJWdk9Y?=
 =?utf-8?B?d2Yyb3JzRVZYcndxRGI4dWo2VUpOT3YwU0oxRVJOS1pWUTFTOUYxNVVFZDho?=
 =?utf-8?B?N2ppblJua3JKa2k0WjE2UWRjM2hHcFFXaFFITnIwZlUwTm1UaElLLzhxSDZH?=
 =?utf-8?B?MHFYemE5TGpTSXE4TDdETFhJMkN4VG85QnYrZUlXd0lscklXUVF2dzJDdmZk?=
 =?utf-8?B?OHZDblNsc2h4ZlYxcTkyNVZLMzltUGNlZ052S2owM3BDMWJIVXVlZWhJcEd5?=
 =?utf-8?B?eTYyWWt5VGllWU5WcHBlKzhKa1oreDBQN2VBNEk3SVNTWVh0cDB0OTBWdWg4?=
 =?utf-8?B?algxN1ZLanRKTE96TVpiazAyMDU3b3piaVlnRDhxTm43dHpCamtlbE9Oc3lO?=
 =?utf-8?B?ZHZIMGUwbmFaUVdwSWgzTlFYS3FoMnR5a21zWlpzamZIRExwTG4zcVJHK0N4?=
 =?utf-8?B?N2dQanI1YzRIbnZDZytPcDNZamRTT052OXladGR4R1dZdmJ1TVBZdUpBL0V4?=
 =?utf-8?B?dUJRZm9xV0hleEdGREtFeEszT2pSUmRwbEhxaUd3K1dvVTM3Vlo1bjJEcTc0?=
 =?utf-8?B?b2IwOHdvQzVuNVVBelRKdjlrN3c0WGJ5dVdISVY0aTVoamRpUytGdWhmNFlj?=
 =?utf-8?B?VmMwK2hMZUFCVlhpZldYS3R2c3QxL1ZjZDZ1QTRrdGpLTTdTWGZ1UHBIdjFv?=
 =?utf-8?B?WVU4WFU1U3ZDZ2NMcmEyQVlOdzljOVBxNlJyS2JtRXhOY1NKdTlrV2t6bDNv?=
 =?utf-8?B?WXpCYWFQYmlsczdnRFV4d2NnQkovbWZhM1BhSmpJeFJuOUEvODR6MlVSRGtP?=
 =?utf-8?B?WFowaE92Y0xtc0RxUWY5NzZJc0dLaTFXZ3VhcW9FbE45VGxjT0dDQlY1RXgy?=
 =?utf-8?B?elBoeTZ5STFZYTFCUi9UNlpTZHF2VXNUWndoY0VTSjA2ckVVejBET0xyRzNy?=
 =?utf-8?B?MXpXR21VRWVWNXVyVVY3eDY4Qm1LVGhhMy9vQ0RsWnNSOW5QWEQvRTAyZXk5?=
 =?utf-8?B?dzRRYk02OWxBK3ZlSnFUa1ErWm9id0E3TE5hY1RNd1k3ODZEelpRdGEzOXlB?=
 =?utf-8?B?SHNQWS8wcWFEeUh0QXpQUEN4dlBYUmJSUXlLVjVqeVVEaGtyQ28yY3A3N1Zx?=
 =?utf-8?B?ekxCVmRSYXBrS1dPd1U1NEVjSE5DV3lUdjFQb0EwOTlCTjMrMHduTThVTTN0?=
 =?utf-8?B?c1ZMZXdraXJYUU13TEZZdHRLZlkwV2ZlNWlWK0JKZE9yN1QvOUVvaEY5WTFR?=
 =?utf-8?B?OWpkcXExRHdFQ29VSmt6TzlqbnVvNnVCenJCT2o5K0VpWStKMmpZMlN2NWFV?=
 =?utf-8?B?S2FDallOcWF2T2dJYkxBOXZOZXZEbzdVSlJBazB4Q25HaHY2RCtuVkFyOUlu?=
 =?utf-8?B?Y3pDbThjeWIySVdWS0JzeFE1V3JXV2NtNkxvZ3ZqNjh5L3NHRStyekNXMk9D?=
 =?utf-8?B?WTRKR1VLOGZoZTVhbEJNeVl5ZVNwcVV4aFdYY1RCZ1RsV0l6a2dneU9Vdjd5?=
 =?utf-8?B?MjN1WTYzdkxoSy9mUXZobHRoeWxuRVZ2TG82QlhwV0U1bGtoc3ZNdis3aU8r?=
 =?utf-8?B?aFlLaWdWS0pLL0hhaXZXMXByNGI5NzNGaDZOUkZIeWNEUmxQYTMvTFJXOGVx?=
 =?utf-8?B?SXNnT2duYmFNck1meUZDbWo3TGl6cWF2TTRHWTdaRTUyNTBnYVhrb0NHM0gw?=
 =?utf-8?B?YmV4ZmdQWGtWVjkxa1MrMWpJcDN2c3d4elExK2hhNFRtTmhidTZ1c3ErYkpi?=
 =?utf-8?B?c1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c66d664-19a1-417d-32ea-08de23d9468f
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2025 23:55:23.5715
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2a2n0h4woz+IRXxggt0CiyA0brYdymBqBDdkAq84LPDQYFTj0/5BtBBleEsY4NLfVx/R0rqC6/JuQfWunzqAQfQTtowAzqMvk5BwRh5YHsM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR11MB8340
X-OriginatorOrg: intel.com

dan.j.williams@ wrote:
[..]
> > > Sounds good and I read this as "hey, this is the form I would like to
> > > see, when someone else cleans this up and sends it back to me as a
> > > non-RFC".
> > 
> > Actually, I think I can take it forward.  Knock wood, but I don't think there's
> > all that much left to be done.  Heck, even writing the code for the initial RFC
> > was a pretty short adventure once I had my head wrapped around the concept.
> 
> Ack.

FYI, this series is now included in tsm.git#staging [1]. Chao had one
fixup to it [2].

Recall that tsm.git#staging is where all of us working on PCI Device
Security (TDX, SEV, and CCA) can start tripping over each others
implementations [3] in a unified tree. 

The initial core work in that tree is a v6.19 candidate as long as at
least one arch implementation is also ready. SEV looks nearly ready [4].
CCA will sit out as it is going through a specification update. TDX is
ready save for this vmxon dependency.

I recall being concerned about the new TDX always-on stance, but I now
think it is ok. Just puts more pressure on the dynamic-PAMT work to
land. In the meantime, disabling TDX in the BIOS is a stopgap for those
that can not tolerate the static-PAMT overhead.

[1]: https://git.kernel.org/pub/scm/linux/kernel/git/devsec/tsm.git/log/?h=staging
[2]: https://git.kernel.org/pub/scm/linux/kernel/git/devsec/tsm.git/commit/?id=406cd719d2a2
[3]: https://git.kernel.org/pub/scm/linux/kernel/git/devsec/tsm.git/commit/?id=e3d238ddeec0
[4]: http://lore.kernel.org/20251111063819.4098701-1-aik@amd.com

