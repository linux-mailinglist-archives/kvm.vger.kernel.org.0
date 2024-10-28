Return-Path: <kvm+bounces-29897-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 44DA99B3CF1
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 22:40:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 78685282D5E
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 21:40:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 719CE1E3DEE;
	Mon, 28 Oct 2024 21:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Fhd7fOAy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 868CF188904;
	Mon, 28 Oct 2024 21:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730151610; cv=fail; b=m1mD4JB/015nzs6rBFb/ee8gECUAVvLn7V8VgL+FDBfImdcS9GzmSKxRZIIiS3iP7xxAiPpEBFhl4mWRDutu+ipdX3kn54jZsF3FDtRLjdgSZsSYBsgV68aaY+vdfKrShs8Iv7DfF4X3kNQB0gAYca5ARofUfpOixGBFlnGPcLY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730151610; c=relaxed/simple;
	bh=GGdVV5mlBwqbiCz6WImjlLHNHWteWh/1AUgBBFa0t4k=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=YArARvfdcknPvjmT3izJY6SAsG6Kzsyib5UF1pFjAOJqFyK7fAOOF/TFKXAgC1uLD4kiSIY7Sx3ueMUANJSNpAnSMkYbEXTogV8ngtLbQcx8m6qBTuFVPJEXIn+wNmEj2bKQvj7YiRtyjSKqZ/h8T7lsNhhiJna1Atji4Hbo0VE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Fhd7fOAy; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730151609; x=1761687609;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=GGdVV5mlBwqbiCz6WImjlLHNHWteWh/1AUgBBFa0t4k=;
  b=Fhd7fOAy3h/ZYtng838F7UBArpOyyrLkqD/k7vzba/JJKcq85BD5g5Z+
   uncHFSx54PErVrRej4pxU3mObKV30Mr/1myJcqPpdBjPoCcQz0Wxvj7oZ
   qpju6ROASVUqwLbseH7bo3yKVmcnBAB75o7BH9lsRQftG8bWwZsq63Z3o
   /UE1eInFvx+W9nJZc/RlXv4tZCo0xjEQqwIwjxMqQ99JL/FEWOvzo3vsD
   ssOuXrmlZG7BYcevT2HMVVsUIpAMsT8sacN8vbqNZJa7406VXZhvDlnjW
   3sfPa+2T623iSA8AEzS1OFQm2kIlQeNQXUOde429VGjet4UdP/DaQnEWY
   A==;
X-CSE-ConnectionGUID: RpLV62CcQj+aPKMBJj0pcQ==
X-CSE-MsgGUID: c5l6RrwPTa+zyFBgnyPQHg==
X-IronPort-AV: E=McAfee;i="6700,10204,11239"; a="33562303"
X-IronPort-AV: E=Sophos;i="6.11,240,1725346800"; 
   d="scan'208";a="33562303"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2024 14:40:07 -0700
X-CSE-ConnectionGUID: 1osIuYUuTpOj9tHaa4AiPA==
X-CSE-MsgGUID: sEGsdXpnRuqCkouMD0HWSA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,240,1725346800"; 
   d="scan'208";a="85697041"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 Oct 2024 14:40:06 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 28 Oct 2024 14:40:06 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 28 Oct 2024 14:40:06 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.174)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 28 Oct 2024 14:40:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y/8dO0XtRPMq4iAZH/9ibMLzJZTBr/fHEhfaO2l+mStCQT1iksImLZpDtEds6tMqQQmhyCHcjPeAmanQ3GsAIb+GC1YXlUVV+BBbIm2hY1oS69Sz5xM8YYVuE8vhB7Xxkw+W3LHk4hoOU8SGQXLnAfpEBgoxG7rB5yC9WDWk8o4je0t8FjsFOs9eU7FcU/QQ1sCOoOGUKbPu/9ov1ksA/1cdbeOLhy6YQDboy3RBS+9ozlBzT1+lrw/IqE9DrRQdRioC/Q17xpMy8OUJeg/+4wZKkosbwcZmIlGu89dFEBc7ZGPaIKCEMxMxHH+UsaMHkGm+tCponIfAp1diDJdr7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EaMYQgiVtM3TEI4Nszyq7Ziv0K/XvgdemGdrYg+Gwlg=;
 b=gVsfO6zXB//zaqkuy4h92U4cZWdYyLCmh8rrBIpooyq7P+Q/BPcJ8/qXLejeLysLt7+iquSyHTjCIrBfTYgD7vAZg1aTcM6Wu9CzBXeLvJVJY6y0y+BzXOPtrBbq7QDkuqfuQXdsCCiGOHNI8tPQ+Xo12ubQ47VjCKW1Vr9YKZ8XJxA4NLgehHTZOeLICY0Xu+mqsOeYRPKj7HNxIpjd7rA5UgIT5i2ULKvyLpmvOg1ILs991T9jbNT6mNE2HnE1DByNApZdCSsWQERb8OTnt+C5/U0rgprd1dgLhsdLM4XyJyZMQ2Nz8LI71wLrgAwv/h1+XsmpWVM0aJFCYxoZLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CH3PR11MB8344.namprd11.prod.outlook.com (2603:10b6:610:17f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.24; Mon, 28 Oct
 2024 21:40:03 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.8093.018; Mon, 28 Oct 2024
 21:40:03 +0000
Message-ID: <08c6bb42-c068-4dc1-8b97-0c53fb896a58@intel.com>
Date: Tue, 29 Oct 2024 10:39:54 +1300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 00/10] TDX host: metadata reading tweaks, bug fix and
 info dump
To: Paolo Bonzini <pbonzini@redhat.com>, <dave.hansen@intel.com>,
	<kirill.shutemov@linux.intel.com>, <tglx@linutronix.de>, <bp@alien8.de>,
	<peterz@infradead.org>, <mingo@redhat.com>, <hpa@zytor.com>,
	<dan.j.williams@intel.com>, <seanjc@google.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <isaku.yamahata@intel.com>,
	<adrian.hunter@intel.com>, <nik.borisov@suse.com>, Klaus Kiwi
	<kkiwi@redhat.com>
References: <cover.1730118186.git.kai.huang@intel.com>
 <0b1f3c07-a1e9-4008-8de5-52b1fea7ad7b@redhat.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <0b1f3c07-a1e9-4008-8de5-52b1fea7ad7b@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY5PR17CA0065.namprd17.prod.outlook.com
 (2603:10b6:a03:167::42) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|CH3PR11MB8344:EE_
X-MS-Office365-Filtering-Correlation-Id: 224dafd7-5866-4af1-9b44-08dcf79914d5
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?WkhWQURkSE85MTZpR1dha05vT2xjWjV2VmxEM1Q2eDRHZ3pGOUZZa2g5bTMz?=
 =?utf-8?B?QjBDOENYaFk0TFVsZjhrZnlVQXdFUytEcFp3d3VNbTV5Sk9WcWZ0SXpnY21j?=
 =?utf-8?B?Q0wzRzBwRzFpTFA3NVlBdjhYQ1BrQVdMRm5UL3RZeXZMNUNwL3dYeFYxL1hr?=
 =?utf-8?B?VWkwQkNKODZMYTcxMUNkd3VRWE93UExHT3YzdCs0OHRNYkNSamFkazNwSWh2?=
 =?utf-8?B?eUNkYkV2azdRRmdBQnd2b1NnZW1HRFY2bTFudmJKVVliaUdWaDNHRXFoSEpi?=
 =?utf-8?B?QjRXcDZHMHFFcFB4UGc5VUYxMWRmWEV1ZnMycXA1NG9OZmJsdnBEejUwRURK?=
 =?utf-8?B?M2JVSndZeFY0cCtDSndFQUd5OHpHMUpEMExDalkwdFdMOGh5QjdEbHBuVDJU?=
 =?utf-8?B?Unl3VHpJRWlZZjcvMHMvWFVsblA1MG9mSGtBMEpFcDJTTTRSelR1TUNITW1X?=
 =?utf-8?B?aFd4RU5MUEFpaCsvdGVWeURiM1pjS2M0VjJmdHhweEhpL0pldVRIT0J2YzBW?=
 =?utf-8?B?SzlGUmx2SXdRMjkwRFVtY3RPeldST3RkaXZkM2lzaUZSRUlFNGNwZ0pCU20r?=
 =?utf-8?B?WVk5cXJJZmp2S2xISkNzeGZlNitRREE2dW1kL1BrWTZya0pZdzFSdkd6RHpG?=
 =?utf-8?B?bk1RVkIzR3c3d2lOeUJ0ajJNZjdnV0VhNDJ4aTBaQVd4SUhaZVFMdWRGbUNt?=
 =?utf-8?B?YVhPS05XTVhDNmxMa3ppQnRwY0pvVXppaDZ1NkdHQjlNUTNNcGhlTXhVeW1H?=
 =?utf-8?B?VUVvYVJSWk1TZzZnY1cyaTZ5aHhiTnhzVEZLYVBlOVdLUURRRXhMbTYrclFW?=
 =?utf-8?B?cHZRUExIY2F0V1FHVmtxNWxPdExUNzJYQVRUa0RrNnNqMW92d09iY001U2I0?=
 =?utf-8?B?ZXQrWnJTdjlQN2daSDNwUm83VEdJWEtaa2lGL0YxL2x4Mm8xT2RKd2JvalpJ?=
 =?utf-8?B?VS9vdEY2Sjg5dlNySlJPSjlFQXdzV3ZybG9tUTd4QnlJTFl0ajJvN2RWR2lk?=
 =?utf-8?B?bjdxK3lHZHI0OHI2bFpyalRTTEhIMHVjWWZ4S0VFU3BoSU9jVE15WFlmb280?=
 =?utf-8?B?dDBoWi8xYmFheEhxcm1yNVAremRYMnB4Q2JWSUFNaHZRRnd6czVXblNaOFNk?=
 =?utf-8?B?ZVJpMlBqZWlwbmowajZSaFlmaUwzU1g0MXhUd1dDbkpqa3FpY09xYUhIRDRI?=
 =?utf-8?B?OCtPQVhoeElKeG02Qk92Z3NNeThqazI0TkdTL0p5UjZKKzA3Mmtudyt1N0ZZ?=
 =?utf-8?B?dTZiMWM4eWRBR2pOcVhJOGFzQU9kQi9ndW1PTVBxcTFEUEpyd25CK2RqVC9n?=
 =?utf-8?B?MnRVSy9EYXZENVNRaGhBTGMvdyt3NHNySEVsQkpLM3g1UHdoOVhEQlloS1k2?=
 =?utf-8?B?SmljZ2xDU2VZVEpPQTZaS2NQN0NDUnNRMzI2VHdnZ25QSis1WU9OZlYyTloy?=
 =?utf-8?B?NjhHNVNEV0pLeHJSQWd5eTFuSEw2alJ4NG1Xa084UWRXT2RUdEJFbFF2STZX?=
 =?utf-8?B?TXIxZ3g4TUQ3dnE2cks0QjRndXBxRXo0NVFMWDdNSnpsWU9wZldFTDVTaFVP?=
 =?utf-8?B?aWtEQ0E1QldnZ0RDc1JnSWtWNG9sTXZYaGFmOWRHVytoRWdQQjQzekRRcldL?=
 =?utf-8?B?NEdaWXJSWG5wYXAzVHJ3U3VUZmZlSW1LMlJXODMycXliYklDSnFoOTVtS0xm?=
 =?utf-8?B?U1NoM1B1SUZRRmFhTzhJL1FnV1QrSjZSTkJtQjk5MjlGRUR3c3FSMVRRaW9L?=
 =?utf-8?Q?5Cyx6xDHwOYhYTsv0qk0i1jCcBcp86LgbOPdZUs?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TE1FSGZkaExyaFlvclNSSHNDejJlU0UrQlM5MWJmcnljWjNnUUd5YjAzZzc1?=
 =?utf-8?B?UUd0RFhVQi9ZbVFGNG9DdVBTVk5xaklDeGhHN2pSL2F1NXZxL0dLZ3pPOHRv?=
 =?utf-8?B?Wmg3SGc2RUZDSHh5QkM2aGF0ODZ6MUhUSE5Zb253YmpLc21qZXNLQjlwVWha?=
 =?utf-8?B?YjJwbjZaU2JXbkZBRkMrVzNPUktBZkdEU082THFpV2V2Sjh6Zzl2T1hOMTJC?=
 =?utf-8?B?V0NNOUlmNVN6QlJTb2RjcXVCUkl3ektXSlMrNFZ1MjdtczVwbGtOZllUdGtD?=
 =?utf-8?B?YW9JRm53Vk9aYXdML3ZOWXo0T0w3N0M0VlpaSHhaM25oL2xPZ1IzRFJleVVD?=
 =?utf-8?B?TG1oaDNibk94NVZhSXd2ZG1IM3pmNEwrcjlWRVhjb05hV0FiUlNtSUV0T1Fx?=
 =?utf-8?B?K2o2aWdUZldzMjBEL2ozMFdhVStQMEFtVENzWitWTklBbjFDVWw2NDF1Wk41?=
 =?utf-8?B?YVVDanUxY1lINFI0OE1KNmJucHRSTGp3M01TRXorOHdiZlU3Sytqd1dmRU1V?=
 =?utf-8?B?TkZtV041TFdGSjlsY2pOZWkwOG0vUUZsb1MxalN0aUt1aW83VDRvWm5wL3p6?=
 =?utf-8?B?c3ZMNytMWTY2TzBhbEE2bUozcVU5Q0Fxa3FYYzU5cVJIblFyUnQvbVgvamNn?=
 =?utf-8?B?TVRZbkdJa2FFdjE5a3lMdEI4bks4Szl1RkY0a2lTTHhZRUR0ekI1dTFoTlZa?=
 =?utf-8?B?VzhNdUF0Zjdzall0YldMNEJJYVloMVFDeWExQlNlVVdxQjlmb1pBd0gzb1RM?=
 =?utf-8?B?RDJPUFBPeEFjTmpCa3pEWnJGWmpBY1hra3dnUG1Ddk9rREoxN3A3U3grdGNz?=
 =?utf-8?B?QW1rUXFDR0FUOGg4bkZaVzI3cERIeDJLTGhhREt1U01mUnRiZkNSbXBUbVpN?=
 =?utf-8?B?dUMwL0V3c3dvUmwzUU5CemxzNmxJZjkzYVdqTTBOMjF3b1dRNDA4dTNMSWt5?=
 =?utf-8?B?QVE5WXBxOHlweVdNUFFiMk1ILzFNYlNpUVVQdm1wbnlFUDZXWS9DZXZoN3Iv?=
 =?utf-8?B?Y2tRem5kdTFiU0hrcGFHWnFqSXRteHk2TmFQQk41VUI2UnYyS1VEbHdudk1l?=
 =?utf-8?B?MHAzKzYvL0x1bFZZajZ3aXU3RlRiWnZPV2YwdEZxTVkzajllUFVIcit0VEwr?=
 =?utf-8?B?MXJ3YjYrd1p6QXpLOW40QTNpc3N0WGpOTGxJMVdwczRHWmhXZG9TZUhPNE5x?=
 =?utf-8?B?OERCVlBhNmVtbVZubW1qa1MyZXlsZE5nV1VJbVR3ZmVVdVlzSkc3V1EwdGFM?=
 =?utf-8?B?RGRhNjlBYjFYZUhreEUyWHFERG5VNy9vRmx2c0E4RVA1Sk1TNGRGdlhyMis5?=
 =?utf-8?B?TW5sRmI0M25jSlFwU2t1aW56NllRbGw2anBMV2Y3Y05qRTI3dTFkVjI4MExZ?=
 =?utf-8?B?QzA5bHNxbHdVKzF6OGtOVjNxSWNhWmcvY0RtK204Y2E0VUxUa1FXTFBmUnVS?=
 =?utf-8?B?MEZqQlF0MXI2QWErazJYdzgyNWN3MCtBSDJpZUF0b2RGL2svdnhpWCtKSXJv?=
 =?utf-8?B?YzBMV29QR2FDdWUxc2w4UE82NUJOWEovMVVLeWk3aWNwWjJVNVVQYkU4d1hZ?=
 =?utf-8?B?STh6VnJJRGdKYlJwMlpEUGxkVzdNR2xNUmtSTHZ6c2JHdUxIZkhrR0FFZm1q?=
 =?utf-8?B?V1VoZlRFYWErdDQ4dE5NcUwxbzVJNXZ0ZkM5eEY2OHdJYitzaE9VM2ljcW9o?=
 =?utf-8?B?YUxnMjRqOGVtRnI5VTk1cmFQZ2hoUk5JQ241TXFhTGVkNFI4WHUwZVhCVlhI?=
 =?utf-8?B?VVhVVXNBNWpleVR2YVFhNmxEcmlSOGozOWU0UzVSdDNKbm5DYXZCZjdyZFdF?=
 =?utf-8?B?NVlCN1ZhbXp3MGhneXE0OUtnc3MwN2haRjFOQWZOdmFJZGJRYmttaFlwR0RK?=
 =?utf-8?B?UFVGOTV6cXJBQjBwVXBlNmQ1QSt3bDVrdmlyRWxnaHMxb0tuMnZSclBwUGhV?=
 =?utf-8?B?bE9Ld0c0Y04yT05JRkR4NnJ6TnRtN25TNWpGWFRtU1B6NkMzdzFtbW40NDBs?=
 =?utf-8?B?Y0U1Wk85U1RsYmJXR1Z0TkVXRXUyTGttZHRFUS9YYVJtTDRjdy9lY1BlMU9L?=
 =?utf-8?B?NS9XOU1nQWpSWDJSelAwWEd1eWxwejNwOWVzblYrc202UUlRQktDbHZJWlFS?=
 =?utf-8?Q?379gwoU1W3YX4xGlaLEAJBZga?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 224dafd7-5866-4af1-9b44-08dcf79914d5
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2024 21:40:03.3837
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +ZQ9Znp8X+djWb53UgPsiQgJD9rdKWkWywcFAZD2/MJpT7gKt1vUf1fTAQWXRNkRf582fF4RD6DZ1BeYMe0hBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8344
X-OriginatorOrg: intel.com



On 29/10/2024 7:35 am, Paolo Bonzini wrote:
> On 10/28/24 13:41, Kai Huang wrote:
>> This series does necessary tweaks to TDX host "global metadata" reading
>> code to fix some immediate issues in the TDX module initialization code,
>> with intention to also provide a flexible code base to support sharing
>> global metadata to KVM (and other kernel components) for future needs.
> 
> Kai/Dave/Rick,
> 
> the v6 of this series messes up the TDX patches for KVM, which do not 
> apply anymore. I can work on a rebase myself for the sake of putting 
> this series in kvm-coco-queue; but please help me a little bit by 
> including in the generated data all the fields that KVM needs.

I have already rebased the impacted patches and pushed to here:

https://github.com/intel/tdx/commits/kvm-tdxinit-host-metadata-v6/

.. which includes:

   1) this series
   2) TDX module init in KVM patches
   3) 3 additional patches to reading more metadata and share to KVM.

Besides the above, one minor update is needed to the KVM TDX patch

   KVM: TDX: Get system-wide info about TDX module on initialization

.. because now the cpuid_config_value is now a 2-dimensional array:

The updated patch can be found here:

https://github.com/intel/tdx/commit/fd7947118b76f6d4256bc4228e03e73262e67ba2

> 
> Are you able to send quickly a v7 that includes these fields, and that 
> also checks in the script that generates the files?

Yeah I can do.  But for KVM to use those fields, we will also need 
export those metadata.  Do you want me to just include all the 3 patches 
that are mentioned in the above item 3) to v7?

Hi Dave,

Could you also comment whether this is OK to you?

> 
> Emphasis on "quickly".  No internal review processes of any kind, please.

Yeah understood.


