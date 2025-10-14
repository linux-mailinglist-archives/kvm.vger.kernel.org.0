Return-Path: <kvm+bounces-60043-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 249FCBDBB95
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 01:10:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 592FE18A22E4
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 23:11:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 756FE2DF13A;
	Tue, 14 Oct 2025 23:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="boeUcNOZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8DA217A2EA;
	Tue, 14 Oct 2025 23:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760483434; cv=fail; b=Znzk4AxNSb+b1Amig2LRPXxZH0KGXHNZIZDPsoOBQGrj15vpQDBsXho4bbIS5Q7rh88PKZR73gId58xEaES3DXrOvZPPeG4ey1+/9Ri3q3iaSNRgbw+/NAX2K9swPP3RuS06bokQZEsbo0BnYvWWjO6rK8B4scg29kcfPVcVhRE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760483434; c=relaxed/simple;
	bh=kC02l/dyV1YVJHTd9/+odW9ZvBnQ77FWD9rllOAytnA=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=P//pra+D+pOT6UGMA0jjwPkGK42aHjcMdcrb8AsHHdcAp9EQjnHZryxotzgBsr0yMiSeYtisQSrE/EUue5fUATbB9u3ykajav3FJa5ooOgLKrL2z+Q3WEjNFFHIpGcA+A2pUZ4dFWNja5nE1cNZyT7KXS4LhSGtoBAOiRxiko/I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=boeUcNOZ; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760483433; x=1792019433;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=kC02l/dyV1YVJHTd9/+odW9ZvBnQ77FWD9rllOAytnA=;
  b=boeUcNOZ2b41QIvrX5fv9I9I2mCb/NDmFfUfoDyLYjxkMdnb360WLtC0
   5Y54cTDL2b0cK+0Xt+ansNAcjM/uHKSNefuOzcmcwDv6YHg4VjyRxNHpk
   HKEJCjq8zonMK5BqXMS9FMmx6+IzZ/px8L1BUCRmBHzMVerscZV1LUdcx
   MdonBwk4SJRGfsEA4/j2ZkW1IZtXj+xAjpdcRHi7DGloMsEVCPjSOhrbt
   i7kcTJGvRcCpiq+5yC7QghwpMZEu3xXDP1jl4S9DpRHnoHSJpM3ZLx2HT
   5htZSpMlPMRA4flw9/nPyc8RbprPPGS7p+WbHAxxtI8bJ+ZjWzz4ejASu
   A==;
X-CSE-ConnectionGUID: kq7ySn8QQH2sB/T5C11Q2Q==
X-CSE-MsgGUID: W3kZ1GOsR1a3rwbqx4NOVA==
X-IronPort-AV: E=McAfee;i="6800,10657,11582"; a="73754517"
X-IronPort-AV: E=Sophos;i="6.19,229,1754982000"; 
   d="scan'208";a="73754517"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2025 16:10:08 -0700
X-CSE-ConnectionGUID: j01SJqdkR120NKv5a7lT2w==
X-CSE-MsgGUID: 2fnazl7FRrCuMMTHq+x/Jg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,229,1754982000"; 
   d="scan'208";a="181684993"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2025 16:09:48 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 14 Oct 2025 16:09:48 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 14 Oct 2025 16:09:48 -0700
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.37) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 14 Oct 2025 16:09:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uNMlzVTFSY2LP4NRXgPnbRfsi8C4x//ywndq+zhnqHIHjLeacB+S92HVLnded01mt2hJGCrTMC/US72E9/GMz0o51L8w6gXWIxKHKyFMQMDMjxCgw9aewF9m3SIwQiZWK5t1ZeWASt2ncKMnpp0/i1y3gXRPdAh+hmLgJzwn/U1qkzRjTxzSkY3cvdqpvTgQdNAGVEcWlo3t2zz0cnobQJmDg6edoK1qe19f4XIqxp5KVhV9gcJWSPc/Wk5TN9i2VF88AHeHM31DFFhVwleey5Iju0tuWnKCVFOLJPFEf5Q2drTuI5vjdjrrD76n7wPeY/Zatbcnki82SeCnkYL1iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KqhJnKtXe2WBLVm6l2t4/VKtTRa0otfidWdFox2soOQ=;
 b=TWkQ7j9mAIqggIOb4hBbij7mEBPIol8LzSI9GG9RXskRVhZZB/nEDoVY1ZLHl52d8UUJS73f+SfLlxUyu7mOTA20z7dkNqeabvc/6wh+0GgHFHlP1VgxcjF3e+Ef+eZqRyzRFpI+sFw0xnq3Eoqc7N2OCU6LMwbXULgNdqlZEXAa23EupYEwBhvI+0FH6fXThStBM1phyYFsd09OK8MURzHenRiLpQRQwAkCWefrTZRbXX4TzlWo8Wti9Ab6L/9Sxa6w1DhJkaWXOAQkpO/IOuBMwfKZNkaJt6ewgZTeiouFbu6mPhCMHbYCzUBWEhubRZCOba+V6kkl6sDsbyi1/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH7PR11MB6794.namprd11.prod.outlook.com (2603:10b6:510:1b8::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.10; Tue, 14 Oct
 2025 23:09:45 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9228.009; Tue, 14 Oct 2025
 23:09:45 +0000
Message-ID: <5163ce35-f843-41a3-abfc-5af91b7c68bc@intel.com>
Date: Tue, 14 Oct 2025 16:09:43 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fs/resctrl: Fix MBM events being unconditionally enabled
 in mbm_event mode
To: "Moger, Babu" <bmoger@amd.com>, <babu.moger@amd.com>,
	<tony.luck@intel.com>, <Dave.Martin@arm.com>, <james.morse@arm.com>,
	<dave.hansen@linux.intel.com>, <bp@alien8.de>
CC: <kas@kernel.org>, <rick.p.edgecombe@intel.com>,
	<linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<linux-coco@lists.linux.dev>, <kvm@vger.kernel.org>
References: <6082147693739c4514e4a650a62f805956331d51.1759263540.git.babu.moger@amd.com>
 <a8f30dba-8319-4ce4-918c-288934be456e@intel.com>
 <b86dca12-bccc-46b1-8466-998357deae69@amd.com>
 <2cdc5b52-a00c-4772-8221-8d98b787722a@intel.com>
 <0cd2c8ac-8dee-4280-b726-af0119baa4a1@amd.com>
 <1315076d-24f9-4e27-b945-51564cadfaed@intel.com>
 <3f3b4ca6-e11e-4258-b60c-48b823b7db4f@intel.com>
 <0e52d4fe-0ff7-415a-babd-acf3c39f9d30@amd.com>
 <7292333a-a4f1-4217-8c72-436812f29be8@amd.com>
 <a9472e2f-d4a2-484a-b9a9-63c317a2de82@intel.com>
 <a75b2fa6-409c-4b33-9142-7be02bf6d217@amd.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <a75b2fa6-409c-4b33-9142-7be02bf6d217@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR03CA0287.namprd03.prod.outlook.com
 (2603:10b6:303:b5::22) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH7PR11MB6794:EE_
X-MS-Office365-Filtering-Correlation-Id: d7f148a7-66d7-4cc6-6804-08de0b76c40a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?SU53TFFaLzhSMDRYc2FZVCtZTWZROXlvWWxzUTF2VUoxTkllS3dTL2lxY21n?=
 =?utf-8?B?WXdNUE1DbDRDT0F3Q1JTWEp6TTgvanhscUNSb2VnRlFteTdmbUwrc2MxbkVQ?=
 =?utf-8?B?dXVIdGZsTjJ0SG5BbzE2RGt2bmF3Ym90V3RSVlVvbmNPaHdwTmdEcVpNMjMy?=
 =?utf-8?B?TEcyS1JPcVF2RDV3ck5QdkZEdnNaMGl1WjVYaGY0aU5uNlNjL3JoK3dON1hl?=
 =?utf-8?B?bjYvdDZ5N0FoajV3UDBualVpM1NJTThUbjdiaXUxcFJoKzcyWnlTSitkZTJp?=
 =?utf-8?B?UWUvWEp2NHA4NXRDQllZRXJ3ODRQZUpkT0FEZnpSbFJnV0gvaVcwSE1nNXpP?=
 =?utf-8?B?S0NKSHZQZWtscFNzSjhvK29IS1h4Z3FvcXlCTzhlWkFwMUtHM202VGtFdU85?=
 =?utf-8?B?cmR3ZkhzSWtqVVBlMXlhMlJ0Q04xSHBXSzdPdWdxS0VaZTFhcW5LVllYRUcr?=
 =?utf-8?B?Ri9IUU1nU205U1JRTXpacTc4ZEdXM3hRUUxVMklWdHc2MURXdG04bWFVOXZW?=
 =?utf-8?B?UWdDU01KZ0xWaXphQ1hGbzllbkNWTGhUeDFmRHBtbWVhQ3YrdU1RNkdVOFNQ?=
 =?utf-8?B?ZWw4ZTEwZFBRM01yeVFZLzFXcGpLOGxUYnpGcFFaU2NZWXlBVTc2cnhCMlFV?=
 =?utf-8?B?aUhicHZ2VUpsbUJNMEdQemdVWEluUnMyaHVMOG5scDFVN0NNZlRLQm9ITjRY?=
 =?utf-8?B?b2IwZGFOdEp4L2w1WDMzdnF0cmt3Sjk0aEhiNWRZWnBvMnRFZGEweUJ6c3pl?=
 =?utf-8?B?eW9nUW5Xc1NLblFPTGdLNFN3NmcwVm9QcWdhR21nMkIwZVh1VWFRckRYWlZk?=
 =?utf-8?B?dWV3UjNlZ05uaDF6RmcyWFBNT0tpL3lhY2VMSi9BbXlMekZEc3Z2TVhCa2Uw?=
 =?utf-8?B?YjRIeUtLNTVXVkJ6aTVrUWplSHRVOGlyTy9uemR4QndPclZXOC9YK05XM0hP?=
 =?utf-8?B?VVRpcytiMGsvR0REakVrK0JKbXlBc3JXN04wb1RQYkZUK2RoR1U5eTRwOGlX?=
 =?utf-8?B?Wm5mN2wwcHlWcGJFbE5Vb29ZMUkvMjYrOWVTL3NIYlBoVmYzSnFtdXpvWmNU?=
 =?utf-8?B?QUQxSjRVRWpPMUJLTTlMMG92WTMzVEhHT0taZC9ITmpoWkZHSjh2bDRvZ1I4?=
 =?utf-8?B?MDhmdTBJTUs3RGh3QjZhbDIyRXFnUWV2Zk5nM2Zudlh5WTV0UThkUzFIa3pu?=
 =?utf-8?B?dmpybnRLVlBLNXpPL0ZZNktOU05RWkI4OEN6REpDOFBCYmZHTEJpZmh0Vy9k?=
 =?utf-8?B?eGl6dFhINjhlaDQzSm5DZFZIQU9EVHA0bkhYNzVDR29SekhPWlpHYWpNSFVa?=
 =?utf-8?B?TzJobkNQQ0JFVjBiRFJSNTluMTl2anIrR05ETWRlYnMwRlNFc0FBeUMvZlRO?=
 =?utf-8?B?cVM3UVQ1ZkdKdVpMK0pPaWhTaGFxRVQ4a2lrNGc5aE9Qb2VjSXVIa3RLdlZV?=
 =?utf-8?B?U3h5amhkN3NyRkpJcU5TbXhpVkxvVUkxTFVPZDFWTEo3cHdoOXYxdE8zSE13?=
 =?utf-8?B?dDRGcFg5NE8xbjJ6dFdRaFZyQk5uN203MXhvczc2eVdoVUdlWDNHb2l0RXAx?=
 =?utf-8?B?UzlPR3BQRElUdG1NNXJXYnFqKzNhSWdNeUFTSHVCdFhJRExHOWRPeUxrVXlM?=
 =?utf-8?B?c3luL1ZlUTZtQ3g1NGlRMkJYMXU1TGQrbE85R2ZSNEpCNzJuQnQ2VXF6Vktt?=
 =?utf-8?B?NXdHaFFnRElsVC9GbXlla3RPTHY0a0FsUFI4bzdBMXU3Tk4razNuOEpRSWNy?=
 =?utf-8?B?RUdNVkVZVUhRUHZlQTJ1N1RuSXd3cUNDVnVoQmoyM29nVDBTWDRyTkVsbUJC?=
 =?utf-8?B?Wm81Z1kyOEVXSlE3dGF1QVBzVDlPUFRnVVI1cjZmWnM0ejVwS0lsV3l6TWhp?=
 =?utf-8?B?dHZKN2d1cWJRcmJBVlhhV3RnbDVqd1E4QTBJNWZkOGZoSlR4N0xZbmdPT2ZZ?=
 =?utf-8?Q?HkAXPDgSFkZilf83gEMJJsUkx4LPbaRo?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SDJ2cjd1NXRrZFBaZUlYS0w3RVFkMmh2NlBRWnlLaDRUakYwc3RsYmFzT0hu?=
 =?utf-8?B?S3pkaklIU28yanRHYzVGN3JhbWJwc2svMk51eHBjTFh4R1RvTEU3TXZMZ3Vx?=
 =?utf-8?B?TkJ6ajFkQlZhVEltcVE4YzJRbTRuMitUYTI4UVk5eVhsT0o2bTdZYm1aaWlN?=
 =?utf-8?B?MDJCaGljOGhDRmtkdkZrRzM4dFJPZGlDZkJUSXo4NjdyRFJPNGR4Z0FKeDlX?=
 =?utf-8?B?bDhMRXNqNG5aZU1LVHQ0QkhRaXVuK2lpekdTR1p6b3ZGMW1yNXpTSTU3TmZ2?=
 =?utf-8?B?c0xXUm5rNWsyK3U1UmpVbW9FWUxBNTExbFZHc1N1WlpBdTN4Qi9LTmdIQTBF?=
 =?utf-8?B?aUNmeGtzRllMeFd2UytXeXVjc2Znb1VGbDlqcEJxc3RvN0dSY3FOZExzR1h6?=
 =?utf-8?B?cHh5eW4wN2VvZHArNkZlTmdZVVM3THVuMDA0YmdwTm5qVGwvQmtpRkRhZlg2?=
 =?utf-8?B?SSt4ZmJCei9YK01Cc2xRZnU2Y1pUcVRxZEtFVUY0U1psQzR3Z0NjeGxxUHE0?=
 =?utf-8?B?aGhzbnpqajZqVGZWQmo5NFZWMUVSZDI1VGVqQUJ1dWRXTjVrbzVSKytjcnl5?=
 =?utf-8?B?Y0VadHFic0FEbHZ2UkltQ1pTdHJMbmJBVXhGcFV6Z2xseml6WTdGMnB6NTZj?=
 =?utf-8?B?eDloMW9HZ2ZnTy9LNVNlT2QwNGZDR1Q0eDdrZXd1Y25IVDk5MlZEVXJRKzFz?=
 =?utf-8?B?TVBBYTJEdGNiVmxpemFYVmR5R1F0Y0tMcVN6R3k4YTcyOHU3ZzhHckVlYWN2?=
 =?utf-8?B?UWZEYUpVM0w5TUpIajFGZ2VHUmV0VS85L2V6ZFdjMGtNQ2FsQXdOWDN6VXRQ?=
 =?utf-8?B?MHZuMWZabFNmNFlIYnVCc2JVaC9uVzlnR0hzY3daSFNjL083RW9HeE9ndGo3?=
 =?utf-8?B?emxFVUpuZWtMMUlCYUpYV015amoyQTFhbHhGWFFtVXNQbi9LUXQ2YTJTZnk3?=
 =?utf-8?B?VFFWNGxsbklFZXBwbHZvNEcvZkN6ekl6ektkTWcwNG1aTWdkZ25Ed1Y1UVA1?=
 =?utf-8?B?ek1qdUhBYzBmeUtFSitpdC9na3RPMnNzYVEzVFZGK2ljSzBlbXgyM2Z3aG44?=
 =?utf-8?B?V0p4NGpQVU5FcDIrWFh1Z0VoYXhBK3VaeDd3TU5BYVBiSVlEVHZIditUY2pj?=
 =?utf-8?B?Ujd6SDlpY3pmZkVpZ3FHMWNPa0hITFpmUUdtUzFiejM3a3dIczhFaGN4ZFBy?=
 =?utf-8?B?WndycFkvbHppRmNIeFpOQTBtZ3o5RkRNT2tWeGM4SUVpRVgxR1VXNXBGZlJ2?=
 =?utf-8?B?citqemI0L1RsR0x1S1lxbE5nbExxOVlKd3VWSGd6VklwbTRRZGZKS3VhclVw?=
 =?utf-8?B?SlhSdE9ucVNQUkNRVFIvOHRCd1FibDRId25yTXB2T0wxRTJ3QVp5b2lFNGZZ?=
 =?utf-8?B?M3hXZk1nZWNpRVVHQnBQUjNVaUVhV0k0Z3hhQ1I5a1lTR2xOdFo3TnJNVjZy?=
 =?utf-8?B?SUVuV1o0ZjFIK1EyYnZyd00vd21Ic1hTZjdUUUJ0MjRzTXRjb3pLa3NiRUV5?=
 =?utf-8?B?VTk5OFJhTUV3SjRVYkI4N01HVHpmQTFGODNsSGtUWWQxbTM3bFZSTmxOT28z?=
 =?utf-8?B?MHdOQ3J1UjUxb2pRdXB4WHh3NDJTNU9kam1yYnJwaFQ5UnA1ZUtmbGhaVVUv?=
 =?utf-8?B?VlhTYnRJaVJmYzY0T21WeXNXM1dNQkZUZTgrRGhNTHFhTXJNVkJ2NUdCeUJ3?=
 =?utf-8?B?QmgyUHkrSEdSRGxTRHZJQ1llalptdE16cGRJcWxXMGlkWXMzWnhsdHpLWWk3?=
 =?utf-8?B?WFlmeEFoa2dIcWlyOW5NTzBaeEZDdjJVaWNwSXdhQWROU3AxY1lZZ2I4UTZh?=
 =?utf-8?B?WTliQXkwL0ttSWdWQm1VUUYyZVhqTmI3eXROaEI5QTA5dzcyNlgrYWNteGNz?=
 =?utf-8?B?L0RQemFockc2Y3R2TTJzSjF3dWlXSWxGOG93amR1Uis0eS96TWkxMWZrRFRP?=
 =?utf-8?B?QTg2citkQkZmeDUvMDJsc2tKR0xwUDZZNkFUajMxWThUYWF3dW5KV0JIdXlP?=
 =?utf-8?B?R1RuT0tZS1A3bUdaK0J2T0dJZi9wYWJhT3pMcFFxL1VlNEFKY3I3YjhkNDVI?=
 =?utf-8?B?bDNjckpiQU15RG43NnZFblQrYTR4VGJnL0FqRm1JcGVvbTVwWFA1akkvNDUz?=
 =?utf-8?B?THZqSFpveGw1MEhEK1BKVWxPUGJOMlM5OTVzWWd6OVI5T1VKbWFyTzN0L0JI?=
 =?utf-8?B?MHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d7f148a7-66d7-4cc6-6804-08de0b76c40a
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2025 23:09:45.7879
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ue5I5Sy6mcd/yy46j00suBG9nVvxdP/TE4ljbp+0eAgzWtHlJWgCnuTThtoAaJhoUpNhsUg4HYqnya6nsb1bhq4jJ/4oz54QVEsGOe9btko=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6794
X-OriginatorOrg: intel.com

Hi Babu,

On 10/14/25 3:45 PM, Moger, Babu wrote:
> On 10/14/2025 3:57 PM, Reinette Chatre wrote:
>> On 10/14/25 10:43 AM, Babu Moger wrote:


>>>> Yes. I saw the issues. It fails to mount in my case with panic trace.
>>
>> (Just to ensure that there is not anything else going on) Could you please confirm if the panic is from
>> mon_add_all_files()->mon_event_read()->mon_event_count()->__mon_event_count()->resctrl_arch_reset_rmid()
>> that creates the MBM event files during mount and then does the initial read of RMID to determine the
>> starting count?
> 
> It happens just before that (at mbm_cntr_get). We have not allocated d->cntr_cfg for the counters.
> ===================Panic trace =================================
> 
> 349.330416] BUG: kernel NULL pointer dereference, address: 0000000000000008
> [  349.338187] #PF: supervisor read access in kernel mode
> [  349.343914] #PF: error_code(0x0000) - not-present page
> [  349.349644] PGD 10419f067 P4D 0
> [  349.353241] Oops: Oops: 0000 [#1] SMP NOPTI
> [  349.357905] CPU: 45 UID: 0 PID: 3449 Comm: mount Not tainted 6.18.0-rc1+ #120 PREEMPT(voluntary)
> [  349.367803] Hardware name: AMD Corporation PURICO/PURICO, BIOS RPUT1003E 12/11/2024
> [  349.376334] RIP: 0010:mbm_cntr_get+0x56/0x90
> [  349.381096] Code: 45 8d 41 fe 83 f8 01 77 3d 8b 7b 50 85 ff 7e 36 49 8b 84 24 f0 04 00 00 45 31 c0 eb 0d 41 83 c0 01 48 83 c0 10 44 39 c7 74 1c <48> 3b 50 08 75 ed 3b 08 75 e9 48 83 c4 10 44 89 c0 5b 41 5c 41 5d
> [  349.402037] RSP: 0018:ff56bba58655f958 EFLAGS: 00010246
> [  349.407861] RAX: 0000000000000000 RBX: ffffffff9525b900 RCX: 0000000000000002
> [  349.415818] RDX: ffffffff95d526a0 RSI: ff1f5d52517c1800 RDI: 0000000000000020
> [  349.423774] RBP: ff56bba58655f980 R08: 0000000000000000 R09: 0000000000000001
> [  349.431730] R10: ff1f5d52c616a6f0 R11: fffc6a2f046c3980 R12: ff1f5d52517c1800
> [  349.439687] R13: 0000000000000001 R14: ffffffff95d526a0 R15: ffffffff9525b968
> [  349.447635] FS:  00007f17926b7800(0000) GS:ff1f5d59d45ff000(0000) knlGS:0000000000000000
> [  349.456659] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  349.463064] CR2: 0000000000000008 CR3: 0000000147afe002 CR4: 0000000000771ef0
> [  349.471022] PKRU: 55555554
> [  349.474033] Call Trace:
> [  349.476755]  <TASK>
> [  349.479091]  ? kernfs_add_one+0x114/0x170
> [  349.483560]  rdtgroup_assign_cntr_event+0x9b/0xd0
> [  349.488795]  rdtgroup_assign_cntrs+0xab/0xb0
> [  349.493553]  rdt_get_tree+0x4be/0x770
> [  349.497623]  vfs_get_tree+0x2e/0xf0
> [  349.501508]  fc_mount+0x18/0x90
> [  349.505007]  path_mount+0x360/0xc50
> [  349.508884]  ? putname+0x68/0x80
> [  349.512479]  __x64_sys_mount+0x124/0x150
> [  349.516848]  x64_sys_call+0x2133/0x2190
> [  349.521123]  do_syscall_64+0x74/0x970
> 
> ==================================================================

Thank you for capturing this. This is a different trace but it confirms that it is the
same root cause. Specifically, event is enabled after the state it depends on is (not) allocated
during domain online.

Reinette

