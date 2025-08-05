Return-Path: <kvm+bounces-53948-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E18C1B1ABA8
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 02:18:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 93E693BE686
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 00:18:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF2C472605;
	Tue,  5 Aug 2025 00:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lVi7fYCs"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DDCAE55A;
	Tue,  5 Aug 2025 00:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754353074; cv=fail; b=RcqV+o2Z9pJCuIHm68ffnkRAGitRMezlBlXItqtiQHS1qC9rjvgLA+CC2H7VwfcYWT8d+U4EuPUOPgyNltHGuIGKkHeZvg1z8ucyaTYxJGbD9PAbwKdU9LpvLrXJadn9E6ePCVoOpOV6gaLyxxX8TA5rDD+G2Y44SmI/cUoAR2I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754353074; c=relaxed/simple;
	bh=juSMlthPKG8q1rbf3w+v7eJ+iqvylsUe/eVmq/M5kPA=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=W3YwDwpcDsIv8viyByK+2geMk0nhnHJUHIFJURaycOVBd60mmtTfu5Gfzov8WZ3gYGiYcMNchZTim8bDc2yJXIeMLhs1VIKtqv2zue2JSXusZG/uu2Ab3aTQw8RWnBIzc3E2s30rCzGs+SkriqlHCemZLooBhu/INIhBqrNWKR0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lVi7fYCs; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754353074; x=1785889074;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=juSMlthPKG8q1rbf3w+v7eJ+iqvylsUe/eVmq/M5kPA=;
  b=lVi7fYCsWGuKYjwpiY+u2h6NPYatwtxXhDIk32OTp0NBpWBN+8ToqRiS
   f5AEnXrOTwD71aBmBzvcGFznkZDm0bRXDZq90K8YF5hfYz/cDfEfgw89Q
   cgbXcmVFPiAP8Cu7Y5aCqr5VGJNkDJD0GIPp5MJ0cZlM0aDTlSiKEZWq8
   ehszG0NqYD+U7TRZ58F2GxOHqouvIQ65HICP1QZCNSJoUo8XfyRLcvtgk
   77LFsGGfDQA5U+eXK8G8rH3LobDCIF+4oIGj9163y8eCyUF48GLOrphC5
   RZhV2DN2qiaveDBIpfJuLEIPSbgtmRJK9TEfRgvPNMbILkdNtEy6uvbag
   A==;
X-CSE-ConnectionGUID: h3bsB5uBSEyooEp9UzXcyg==
X-CSE-MsgGUID: 53JrPUCASG6letjkjz21fA==
X-IronPort-AV: E=McAfee;i="6800,10657,11512"; a="60270550"
X-IronPort-AV: E=Sophos;i="6.17,265,1747724400"; 
   d="scan'208";a="60270550"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2025 17:17:53 -0700
X-CSE-ConnectionGUID: 7RzwebaHSXecjhrAxrqs/w==
X-CSE-MsgGUID: ZCra5yLGT3OeDpDI7DdP5A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,265,1747724400"; 
   d="scan'208";a="164694851"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2025 17:17:52 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 4 Aug 2025 17:17:51 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Mon, 4 Aug 2025 17:17:51 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (40.107.237.74)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 4 Aug 2025 17:17:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ngYOLaMrFO/zXIdVinM4tX8qCdJnnj0E2RQ940rzs/agRA7DJb7Ypsvj6dOoskm65tEwLP76fE0pXuV5Q65z2DcDqWYxurW8o0Uncw+5Sn6EqZM1lvXLbWxsbxqjDBIrpkUc8F08AXT2+XtO8A8GyEgVqeoY1EDQ8q/9N2AlMmNp8mX0wiGLcvjc2yPY3jXtuvtly4J81QBp/VhrPhBS1nhF8JPDc4RhlGChH7FggaQv2xHfDdEnvGymHoOC7HxZyfCgBti0MMrHeWYUZYelRS5B91rq85zVuMaxP193XQSvVxx0DDznnrlqaz1A/AsOUon9V45WaevOJ8bcSJLGVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HT8JFwWxdu0CquFvEx0yhiPMQ/8ibdVqOWtTus3FaiU=;
 b=k71bZ4cHI8mXUQoFnL4/XvvNhsnbL+bBZibWx5f1nPH4kWsUmdFNN3QYgzsD9Ro9HXpYjuSvsyCQGJqxc++cdO76hwF2weapgUJK19Sq2bRqDfEnBZvohaInteoy+QPuIjKHU4wAdQ5zoDZGL3bO/Ze0+qEP+QbKmqtJBkoVsSmlfHfPCBC3cTf6tNfOTFrV/loR8ZOu3N12D7uCvb4WGdp8yJriNvXkhjThtMeFCx+tbrDJJjLRJlO9phgrBAD96A+lfH8/J1sTg9qfyY27WEFKzNzawD9+MnfYKUcJEcvhdo4Xpg2Uz1PJRLA9ZyTswr+Dg6O3V5VrmsvfyJw4UA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by PH3PPF55C5E51F2.namprd11.prod.outlook.com (2603:10b6:518:1::d20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.11; Tue, 5 Aug
 2025 00:17:21 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%2]) with mapi id 15.20.8989.018; Tue, 5 Aug 2025
 00:17:21 +0000
From: <dan.j.williams@intel.com>
Date: Mon, 4 Aug 2025 17:17:19 -0700
To: Xu Yilun <yilun.xu@linux.intel.com>, <dan.j.williams@intel.com>
CC: Chao Gao <chao.gao@intel.com>, <linux-coco@lists.linux.dev>,
	<x86@kernel.org>, <kvm@vger.kernel.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <eddie.dong@intel.com>, <kirill.shutemov@intel.com>,
	<dave.hansen@intel.com>, <kai.huang@intel.com>, <isaku.yamahata@intel.com>,
	<elena.reshetova@intel.com>, <rick.p.edgecombe@intel.com>, Farrah Chen
	<farrah.chen@intel.com>, "Kirill A. Shutemov"
	<kirill.shutemov@linux.intel.com>, Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
	<linux-kernel@vger.kernel.org>
Message-ID: <68914d8f61c20_55f0910074@dwillia2-xfh.jf.intel.com.notmuch>
In-Reply-To: <aJBamtHaXpeu+ZR6@yilunxu-OptiPlex-7050>
References: <20250523095322.88774-1-chao.gao@intel.com>
 <20250523095322.88774-8-chao.gao@intel.com>
 <aIhUVyJVQ+rhRB4r@yilunxu-OptiPlex-7050>
 <688bd9a164334_48e5100f1@dwillia2-xfh.jf.intel.com.notmuch>
 <aIwhUb3z9/cgsMwb@yilunxu-OptiPlex-7050>
 <688cdc169163a_32afb100b3@dwillia2-mobl4.notmuch>
 <aJBamtHaXpeu+ZR6@yilunxu-OptiPlex-7050>
Subject: Re: [RFC PATCH 07/20] x86/virt/tdx: Expose SEAMLDR information via
 sysfs
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR04CA0006.namprd04.prod.outlook.com
 (2603:10b6:a03:40::19) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|PH3PPF55C5E51F2:EE_
X-MS-Office365-Filtering-Correlation-Id: b32e47de-399b-485d-bfe7-08ddd3b571df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?WHgwallHZ0l4SGgwcGp4ZkdvamlHY0l4bnZ1Z0hmdWNyc0pVNGMrVE13dGN5?=
 =?utf-8?B?eUM4TkZvVHRsK2lGTHkySkw0K2VyMU8zcUk3Y1daUXFMaUI2WUlMZjVJeHBH?=
 =?utf-8?B?SHFIelM4Q2x5WVRCdUJoVFc4N1k4dzdvaHJCVlBoK2d4anczb1dwQllkQVlZ?=
 =?utf-8?B?dnVFbWh1bmhQWWtEdWxGTnI2OXYxWHEwcld5YzVYejVPMGh6UHhrRFBtKzJr?=
 =?utf-8?B?TnJ0dzR2UGJ4SjM2V2FZMDlGb2hGb2QyZ1pMZ1Vxa2tUZXFiY0kyaHVvZmVy?=
 =?utf-8?B?bDlaaTJHU21VeDI3blRyMFFEdmt6aFRTQkJIb0Fibm01NlhXR2UxRkxCZlRD?=
 =?utf-8?B?UFU0ZWZjL21wenRpbVhWT1VuaERpcWV3TTh5emtMM1FoaFZla3ZtWHIvc2p5?=
 =?utf-8?B?UVNUdjQ0YjlGNUlEdzZnYXpXdEMvOFNhcjc2a2JvckFpZHlKNEpHK1QzWE5Q?=
 =?utf-8?B?dEtxcVdJcjJsYUlKakpTd3Vya0NudjRrSUh5SFRmR3lreEZnYjlEVEh5UWd4?=
 =?utf-8?B?dGV1TWEzQnZzOG9WaVB1eE5YMnJVS25ETi91UHoyNG5nS1MyV2dPbzBQcmo3?=
 =?utf-8?B?SzZBL0xQajVqYXl5alZIcksvWEFQN0dTbU9Zc1dGM3hndWhLTy9IUlkxY002?=
 =?utf-8?B?TGdMNEtsWElIVW9weEllamxONFRJTFpLK0FZWXRLQzNaOFk3aG5kZ3pUcU04?=
 =?utf-8?B?eHlKTGt3MytncFdDNk5mdGROOGtPaXpXQmtFTi9vS3BEUHM3d0FQdXovTG51?=
 =?utf-8?B?aXF3WmhmeFc5dUpVYkJsd2J4VTNBS2t1eWp3QWF6MXFOck1QeDdqbVc0RGc5?=
 =?utf-8?B?YzdjLzAvbTFnQXNzWHVRalpnVTlVYXI3b3JMM2IvWGlvd1lLdnlXOHN0N2dE?=
 =?utf-8?B?MnRtWUJZb201Z2dNaDJUVVVNcy8rRzhoVklzcjRWRVdET2xBZis5NjlWb0cx?=
 =?utf-8?B?MzRZcXJISVBrNTBlbUpEeFVLcEI2Wk5PaU1QeHRlN3c1VldxaFJVS0lwVVZt?=
 =?utf-8?B?cExiVUt4eVFBTW90UVhpc21HaE4wMTh5Z1Q2MWNZWjJrdyszdHpjR083QStM?=
 =?utf-8?B?Y21pNzZFZlozVXJoSTFzR1UrcE14ekpzK251ZWdRWUhQNU5OOTVtRyt2Ulcz?=
 =?utf-8?B?S01vNnpiV3B6WkQzaEZWNmtUZ0V4Wm9pQ3pSUkZ0emRQVTloUGhZcFlDa3FN?=
 =?utf-8?B?WFhHUlVJL0kwcTZPS1h6eXVoQ2NEV0kxTm9vS2ZvL1JvZURZR0NKN1dHWWJ6?=
 =?utf-8?B?MjBCd0d6b1ZuL2VLMy9DTDk5MWVvWWg4ZjJrY1BLb2lkZUVZOTQxZ1dtdUEy?=
 =?utf-8?B?SkFwNVhXTEg3Z0F1MUxKVmpHbHFPYkJTc2R1WlVqSnNoVjVXYk93OC9NT0Q4?=
 =?utf-8?B?RDR0QVFnNFVERWVUd0liNlFnSzdYOVpHL1RsMVpuZjhpWDd5N1lpdXRteFZt?=
 =?utf-8?B?SElOdUtzZzFnTHB6Z3dkSnhzdGcvYVFJTkJzNTFPZ0dLaEdZbjluV2xYRWRu?=
 =?utf-8?B?M1Q5VS9NaUlxVWErSld5NUxsZHg0T05IaFZVYTRTOWRKSGpzNzNzOEdvSWJu?=
 =?utf-8?B?cWM2Z1ZQV1pWZ0RURStaR0E4Syt5dHZKVDdidjk3dStUbGo1UE9wa3ZLckpM?=
 =?utf-8?B?Qjh0NjZ1VFRMemJId3c5RHRDZGVsdS9xeEt0SkdZUFJ4S2E1Rnp2VGNIclJO?=
 =?utf-8?B?S1VMbElZVUxtOXArRUF1Zmh2T1RzcEM3ZlRNeEdGZEN5Y2NaZ1BmdmUvUDhm?=
 =?utf-8?B?ZDA5bEE5Zy85aVBzSVdjdDN3d2k4ZGlEeDVkNEtWRWFqTHBZMENqaC9uY3Vt?=
 =?utf-8?B?ajFxdU9rbU5XK0tpazdGcUxCbU03TTNpTDcwQlUvYzl6V2craWRlWklCdWVZ?=
 =?utf-8?B?MHVXY2lqNDZkSVg5N2FZSjcxSkp2OC9CMEZxZU1mUmt6QStlS01OQ0I1djZs?=
 =?utf-8?Q?6phdEuNtFY0=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ejRML1R0OVliekU2WkpDallvdU9EQ1BoMEVVNTRTV0Jmb1VaeFh2dDBqK2M0?=
 =?utf-8?B?MnVvQ0VyQmUzQ2FPMDJrdmxCU0xhbUx5SWVjdzBsTDJ5UGNCQTFkWjNaYTZR?=
 =?utf-8?B?aDFxQk9zb0ljVW4yTTZrUEdwSmhVQ3JOTWE0SkNZVW85aXoyUjVnQjJnckVz?=
 =?utf-8?B?ZTUyRzFLTmNkL1Q2WUo5WUFIMXlybnE5b1E0QXpNaTBvcXh0RjV2L21ZOWE2?=
 =?utf-8?B?S2MraC90cUp3T1JTbVFmL3JRUWZnZ2w2UzNZTUowNmtXRHNTYkZLS2dZVzds?=
 =?utf-8?B?S1ZFb3dBcVJiQWpkMUF4NFdxRVBmWWx1NEhwQXRFQldZVFVock5SYUROby9R?=
 =?utf-8?B?TUs4ZWcrUmg1UVZZNHNwVzhDQnowTjc4VkpuK2ZoS0dLbGxINkhwN3lsQ3lk?=
 =?utf-8?B?aEpFTzJhTldqQXR1WUZTbXc4aUpnckZlWmRTVkFGNGhtWGwxa25BWDZoRkJo?=
 =?utf-8?B?Tmh2T28xMUtHdHhjMVNTc0dqTHNkN1hlbUhNbWYzRy9aR2xzSUswY2NpNVZH?=
 =?utf-8?B?cmlndW8yd2NNOCtWTWUrNjJGd1BDZUdnbUVHNWh2MWdjK3o1Nk83azR4WXhu?=
 =?utf-8?B?bjNrVlFxYmNaTXFBeU8xc0pjeUcrRm1CYnloYUhmeFVBT0x0enRCZkNRTm9R?=
 =?utf-8?B?R2g5ejl2dHdGajZ2YXJxc0hSdWg2bW5pTkRHN2sxY0dWSHQvcU13UXZrL2li?=
 =?utf-8?B?enJBWmkxVnVGbXNQazIxSXdja2xtUW0wdWxpR3NwTlFRdW41NEJkWklnZmlT?=
 =?utf-8?B?OWI2WEY4cW1UVHB2YUhWa09PMTlwYUliSTRESXJrQll1RkhhSWVGY0dXdkU5?=
 =?utf-8?B?M3lJZUgyYk50OFZtM1dBZ1o5dkxkZDB2L25JTXRxckhrNDhzSmJmWVRQMU9h?=
 =?utf-8?B?VzhlOFFtWTBlcmd1c1M0SDB3MmZxVm43MmRKN0Zjd0xjWWxxRnhVbFZrTGQy?=
 =?utf-8?B?cDdoVFhGQSs2SWM2bGprY0EzRFpmVjkyT3lCa1ZocUF6a0dlNEJFQ0JIc2tM?=
 =?utf-8?B?VERqS1dNd1MzK2NVM3BNYnA4eG9YK2RYNVpMTTY4S1pqV01nOEhDZ1l4RkNJ?=
 =?utf-8?B?Z1RGa1BXbHFuK2l0ZU5qV0RWbEhhWjZjZm5Kb2VubURkV1VBcWdZN3Z2QS9Z?=
 =?utf-8?B?TXRmNEhuN3MwZHJoVlVyTERFVGNBUmtVa3BpMzByS1ZyVThXTDArZ0EyeXlG?=
 =?utf-8?B?d1FpbngyMCtLRHMwQU1JeDBic0R2K0F4KzNyMEdmVHFvcEJEakw1QlNmL0ND?=
 =?utf-8?B?aWZHLy9xZHlVUFhGeWZGb0pIWkRlWWFOUWd6Q3ViQ2pOc09oT1hraDg5Vmlw?=
 =?utf-8?B?Q0R5WWo4dGdlYU5ZdWdaUlJUN2lkRXh1V3VFWFhBeURzR3BlN213UVZnSnp6?=
 =?utf-8?B?ZC93TGJna1c4ZU12NDJMS3VGUXdlV3pRVW9pRWY4a3pJWlMvWXJ3aUx6cmdx?=
 =?utf-8?B?MU5UK21tbURuRk5DYzZyeXl2VWdRb0NrN29ZK1QvZWpWNnNKTE1QeVFMNXRl?=
 =?utf-8?B?TVR3SkszalVIMGZudG5Pd2liV2pML2dBZmR6bTdnSEluY2JveFN4WU5QNnpu?=
 =?utf-8?B?Mkt3MlJEUjRzUm50eWplMlZQZkF2ZzFyWGRCWjV2TDFIbStLUEdENzgxM3I5?=
 =?utf-8?B?ZlNHNncrblA3VnplbGtyVGtGK0tPSGl6NG1nSXE1VjByZmt6c3BzZlA2NVR2?=
 =?utf-8?B?RVdLZSsyUFdBYllaUTZXNjRzaFk2QVQwQzVkQURJNytTaG94OTl4bUpXMHlp?=
 =?utf-8?B?WkpOOHFkb09GYUN4NmprbU1SdEpISW9oZWdLcnFJSjRmazc0cFpRVjFkQ0lP?=
 =?utf-8?B?Y1RWcTUvbjhDTzBOVFU2amxrL0dadTYrYUJDWmxMMDA1d3ZrWVRzeC81c0li?=
 =?utf-8?B?R2RqcGlSeURwcU9FajlnNEx3bFN0Nk9WeEU2K2l5TGZ5Z09nakU4alJmcXJp?=
 =?utf-8?B?bGl2bTJFQzZkSEZnZ0xRckl4Q3dtVGZqYVZJdzFPTVBBeG9IZ1hON3A3aCtR?=
 =?utf-8?B?ZW1mak05TWJWT01nQ1E0a1V3VHdGRDRkMDVRNnN2T2pGQ0l0R2hUQmhvVXdE?=
 =?utf-8?B?KzBScFpJVlRSL0pQZGNhenpOVU13a0RHSWMwUlFuUURzdStLRVBhOVF5RmVo?=
 =?utf-8?B?OHY4M2pJQjN2ek9WRlcva2RTcFhlT2RzaHVqY3I1Q2hMYXI3V0grODhlWU1s?=
 =?utf-8?B?RWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b32e47de-399b-485d-bfe7-08ddd3b571df
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2025 00:17:21.1373
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lyzHBlpQid8L/e+4zy/loPWkzRcDT+4CAszXUL8d71SUjUY1Vsh8meTN50oLm+tGPWghbyhH3QPYfDFE1rg7cw8iwKsEi4V9Qqf7Sqq8fKE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF55C5E51F2
X-OriginatorOrg: intel.com

Xu Yilun wrote:
> > > > - Create drivers/virt/coco/tdx-tsm/bus.c for registering the tdx_subsys.
> > > >   The tdx_subsys has sysfs attributes like "version" (host and guest
> > > >   need this, but have different calls to get at the information) and
> > > >   "firmware" (only host needs that). So the common code will take sysfs
> > > >   groups passed as a parameter.
> > > > 
> > > > - The "tdx_tsm" device which is unused in this patch set can be
> > > 
> > > It is used in this patch, Chao creates tdx module 'version' attr on this
> > > device. But I assume you have different opinion: tdx_subsys represents
> > > the whole tdx_module and should have the 'version', and tdx_tsm is a
> > > sub device dedicate for TDX Connect, is it?
> > 
> > The main reason for a tdx_tsm device in addition to the subsys is to
> > allow for deferred attachment.
> 
> I've found another reason, to dynamic control tdx tsm's lifecycle.
> tdx_tsm driver uses seamcalls so its functionality relies on tdx module
> initialization & vmxon. The former is a one way path but vmxon can be
> dynamic off by KVM. vmxoff is fatal to tdx_tsm driver especially on some
> can-not-fail destroy path.
> 
> So my idea is to remove tdx_tsm device (thus disables tdx_tsm driver) on
> vmxoff.
> 
>   KVM                TDX core            TDX TSM driver
>   -----------------------------------------------------
>   tdx_disable()
>                      tdx_tsm dev del
>                                          driver.remove()
>   vmxoff()
> 
> An alternative is to move vmxon/off management out of KVM, that requires
> a lot of complex work IMHO, Chao & I both prefer not to touch it.

It is fine to require that vmxon/off management remain within KVM, and
tie the lifetime of the device to the lifetime of the kvm_intel module*.

However, I think it is too violent to add/remove the device on async
vmxon/vmxoff.

Are there more sources of async vmxoff besides CPU offline, system
suspend, or system shutdown?

The suspend and shutdown cases can be handled with suspend and shutdown
callbacks in the tdx_tsm driver. Those will be called before KVM's
vmxoff. For CPU offline, is it safe to assume that the driver will not
be invoked from those CPUs?

Are there other sources of vmxoff?

> That said, we still want to "deal with bus/driver binding logic" so faux
> is not a good fit.

Faux device gives you a bus / driver-binding flow, it just expects that
the driver is always ready to bind immediately upon device create.

> > Now, that said, the faux_device infrastructure has arrived since this
> > all started and *could* replace tdx_subsys. The only concern is whether
> > the tdx_tsm driver ever needs to do probe deferral to wait for IOMMU or
> > PCI initialization to happen first.
> 
> The tdx_tsm driver needs to wait for IOMMU/PCI initialization...

Intel IOMMU can not be modular and arrives at rootfs_initcall(). PCI
arrives at subsys_initcall(). The earliest that KVM arrives is
late_initcall() when it is built-in.

Hmm, so faux_device could work, all dependencies are resolved before the
device is created.

> > If probe deferral is needed that requires a bus, if probe can always be
> > synchronous with TDX module init then faux_device could work.
> 
> ... but doesn't see need for TDX Module early init now. Again TDX Module
> init requires vmxon, so it can't be earlier than KVM init, nor the
> IOMMU/PCI init. So probe synchronous with TDX module init should be OK.
> 
> But considering the tdx tsm's lifecycle concern, I still don't prefer
> faux.

If there are other sources of async vmxoff that are not handled by
'suspend' and 'shutdown' handlers in the tdx_tsm driver, then perhaps a
flag that gets toggled to fail requests. Otherwise it feels like the
tdx_tsm device should only end life at vt_exit() / tdx_cleanup().

> Thanks,
> Yilun

* It would be unfortunate if userspace needed to manually probe for TDX
  Connect when KVM is not built-in. We might add a simple module that
  requests kvm_intel in that case:

static const struct x86_cpu_id tdx_connect_autoprobe_ids[] = {
        X86_MATCH_FEATURE(X86_FEATURE_TDX_HOST_PLATFORM, NULL),
        {}
};
MODULE_DEVICE_TABLE(x86cpu, tdx_connect_autoprobe_ids);

...to allow for userspace to have dependencies on TDX Connect services
arriving automatically without needing to manually demand load
kvm_intel. That module would just immediately exit if TDX Connect
capability is not found.

