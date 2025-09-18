Return-Path: <kvm+bounces-57969-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E524B82F43
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 07:10:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 28DE0463F9D
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 05:10:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0840C2727EB;
	Thu, 18 Sep 2025 05:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gijtvLKO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACD0827932F;
	Thu, 18 Sep 2025 05:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758172200; cv=fail; b=Web6yrEusg45iJtUxNI22AfNHXX4bXtV36bZd+1r6ink80Qm5HKP+qFrGMs99ew2oTmOW+YXZsyWJ6iZlz18aA9KbezqBel2lT7xyU4qTTRX4lgKjGQVAeu1BuWj43RHBr3vN7tPemHTKJuu/DpcUg8bBz5rucTRhkmWh97sMUc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758172200; c=relaxed/simple;
	bh=9DMow6QJPSDa0E8LMNBp6bQJVFkpWaAJOkpkZJnH7eA=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=uHYhxTpseHmnsxqCRmdEVAOoBrhlAWE1rWzo1lHeg42jX4coyGmHHzKaNHkrkbPNjckKh60AGd3SQEi/Qo14rmKPfhD0l9yumcdoQtL05u/4mcuKxX+otSx5wWkajCwbRNiE0CUAVQ68oKlOuwCzxuk6uGRMCLb0vc4EzwLJvUQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gijtvLKO; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758172199; x=1789708199;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9DMow6QJPSDa0E8LMNBp6bQJVFkpWaAJOkpkZJnH7eA=;
  b=gijtvLKOk1b+ACrwfNxQCV5EqzTxi6QHeesv+20iDocxpy2yRXBz03rS
   7OpKj72jflNbWueHCo5tT3Scu+R/R8vV+ZUXfFB3UgQ/fuFVQtPW+1xMB
   Tf922XnNeZPtpx7GapNFGMOP3JhJ9ztzqpmIjgbJy0bkVeS0OKebOZ3RV
   JyJ4Cs0R/Alo2dA4d6+lyTbFzUY7s98YZKBpF3J/SECpxi8DUbZScuIDY
   myifHUF4jKIZD2jqJL+GiyqTwGsX8Abu5fwqGSLaAxW52vk8L9rFINhgB
   nD+7PPXdal1iDfODGWundUs5rVg+65w5wI5scv3YkIldGHFIR4W+RHNqw
   w==;
X-CSE-ConnectionGUID: YZGd36pzRieX89IAuxvIxA==
X-CSE-MsgGUID: hntjN2JkTMKBiw5nFZYfIQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11556"; a="60182710"
X-IronPort-AV: E=Sophos;i="6.18,274,1751266800"; 
   d="scan'208";a="60182710"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2025 22:09:58 -0700
X-CSE-ConnectionGUID: 4Fc38rXKRWWuk9+naZPk6Q==
X-CSE-MsgGUID: FHEh1ZntRkyDLdvX532hMA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,274,1751266800"; 
   d="scan'208";a="175354346"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2025 22:09:57 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 17 Sep 2025 22:09:57 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 17 Sep 2025 22:09:57 -0700
Received: from BN8PR05CU002.outbound.protection.outlook.com (52.101.57.15) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 17 Sep 2025 22:09:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D11/HuTN4ip0uMZNts7A0bRVPQ2n6Ksn1aXkiHfkpweuvWFfl2/kwTMUbFK4ZfeAzeqhtaq2V1OicKk59g9eTkHX104UdB9bdLN8+weOnwspMreMSttR4kzjWD7ug1HzGUdPyLGPreNYFRCOsjFXQzF56e54OpYcWWyqpnrF9lOdG8MvzoYvKcQ8DwGukhcUNR/t+1cYB3z4JCDUzHy2FW9HxM/MZxeYIdzr9bewVlP3XHLX/eyohud9DuizuSLlx4Zqbkehc8YpCf5kxKy1Rh1yuMQoeBKZNfIEVutQ+KAr0Ut2rY23EDwtPcgXeyc1j+N97NiBJdHupbw/Z30hDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XncRpOEnYSbSKmY7gmFl2gvFbIpyuwUZp8DTa42NG8E=;
 b=md7zJq8bbQQJxTxbWvUg4a5E47c8D/eDgLf7fCphyV3fmzhQY9wPiHlzm1nHqmNdo8zToLwvkMYMDagy5IwKI8YuzzG/gZkLjf1iDzcBxFLXH41u7hFwWmhO5EEOICISrUOg37+ds5XTqlX7ZAXMJFhpQXYyRDbTcdIDYKALWOgZxGe7uS5hF4EISPKrVDo4pZ6SXIfp4+rPwMr6dzX8W7rOcaM8WJJqK/kkVgxHJ9ajPwGvdHJvlVHrC0i8qtCJZjd+k+ePmjYl/+V5q22UXwAopdyglv12OBl/ceQiXqbONAh7AjmfAYnuAQNVckSNP0CZg8UF23KOe08gcaL9Pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by IA0PR11MB8336.namprd11.prod.outlook.com (2603:10b6:208:490::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.22; Thu, 18 Sep
 2025 05:09:54 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.9137.012; Thu, 18 Sep 2025
 05:09:54 +0000
Message-ID: <0a995233-21d2-4adb-a7d1-f651cf3a6ef4@intel.com>
Date: Wed, 17 Sep 2025 22:09:51 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 02/10] x86/resctrl: Add SDCIAE feature in the command
 line options
To: Babu Moger <babu.moger@amd.com>, <corbet@lwn.net>, <tony.luck@intel.com>,
	<Dave.Martin@arm.com>, <james.morse@arm.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>
CC: <x86@kernel.org>, <hpa@zytor.com>, <kas@kernel.org>,
	<rick.p.edgecombe@intel.com>, <akpm@linux-foundation.org>,
	<paulmck@kernel.org>, <pmladek@suse.com>,
	<pawan.kumar.gupta@linux.intel.com>, <rostedt@goodmis.org>,
	<kees@kernel.org>, <arnd@arndb.de>, <fvdl@google.com>, <seanjc@google.com>,
	<thomas.lendacky@amd.com>, <manali.shukla@amd.com>, <perry.yuan@amd.com>,
	<sohil.mehta@intel.com>, <xin@zytor.com>, <peterz@infradead.org>,
	<mario.limonciello@amd.com>, <gautham.shenoy@amd.com>, <nikunj@amd.com>,
	<dapeng1.mi@linux.intel.com>, <ak@linux.intel.com>,
	<chang.seok.bae@intel.com>, <ebiggers@google.com>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <kvm@vger.kernel.org>
References: <cover.1756851697.git.babu.moger@amd.com>
 <f3aae4014bb65145dcbc0064214324133fe568b0.1756851697.git.babu.moger@amd.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <f3aae4014bb65145dcbc0064214324133fe568b0.1756851697.git.babu.moger@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0111.namprd05.prod.outlook.com
 (2603:10b6:a03:334::26) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|IA0PR11MB8336:EE_
X-MS-Office365-Filtering-Correlation-Id: ad742987-185d-4498-3c53-08ddf6719ab3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?NjRrWXlkVW5mOENpcG9rcjBUaXhnVTJySWRiRThwQzhNZjl2SFVONXpHTVJY?=
 =?utf-8?B?UXJ6a2NyMjR5WmF3L216WHhQZTNhTjRZS1RaWXBXT290ZFU4R3FmSDRES1pJ?=
 =?utf-8?B?MXB1UVVNWkd2RXNKNE5EanVJb2VKS2hFSjl4SER0RFM4ZnNvNUpYTVRYeURm?=
 =?utf-8?B?a2ErYWRqa3MzanFzSG0yYW9OaEtzdmlWcmhpVFVMeEthMmZyY0c2WGEzODNO?=
 =?utf-8?B?bVVFTGNMV2NoYlkrcjg1NDdubklDNFNUa0xxblJBalFGWHRzNCttRUhEd0hF?=
 =?utf-8?B?NlB3cE5EQldQSC9JTW5ZOFRKY1ZtdWRuUkNLUjE0Rkx6cTBoV09zWVdUazk3?=
 =?utf-8?B?Y21pc0ZWMmhzMk40ZWVKYVNRNU4xV3ZvL01oUHNiV3B1TitRNFR5S1lSZlF2?=
 =?utf-8?B?WVcxUHhPVDRINSttT2tuMmFMOWt0UmJ6ZklKV3p4WWFncElubGhJZlQ3VDBs?=
 =?utf-8?B?eWpsRnNTSnE2a0N0TE1zTGtRYmNyMm5XcW1Kb01UcmlNYmJaRVdZVytnQ0Fk?=
 =?utf-8?B?ZU1aUmE3RlZraGZOS2pWcHBtRFZIM2poa0hOZ2hrWkRtbEs1MFl0NjZ3cmMx?=
 =?utf-8?B?WXovVDhPK0RzMVVPZTNrWDNERkc2Wjl1Y3c0dFVvSkNyWHQ5bis1bklnZ2pw?=
 =?utf-8?B?S3A1b01Vc0Q0dVdBeGJKM3RLZFlHNzRJcWpzWEdTcXBWRzl3cnNGdjNJRW4v?=
 =?utf-8?B?S2tSVkpLWk9vYS9YeHZLcTcwR1RjckhuNU95WHd1RkJaL3VLQm9Bam1lS3lm?=
 =?utf-8?B?WTg2TGwyOW5STThITk9lRVZ3bkJVRm0xY3Ywc0V6R0tLUWQrakg0NHhPMG9Z?=
 =?utf-8?B?bW1BMFZSay9hckpJOU5zTENCY1ZxUTZtckNTaC9pc1g2bGxiakN0SUw4NUNU?=
 =?utf-8?B?VHFMS0NOK01tSWprcWdWcm9HNUQzREthc3BpK085b0RTb1d5M3pUSUM4NEd1?=
 =?utf-8?B?UERxQ1A3WmowcGpHdEh1R1RDb3k5Qi8rUGdGckxPWUk4bXR6QnI2bm5HYmVx?=
 =?utf-8?B?UEtMd3pHeHBNN2FZd1RLTk9zR01VYklodmpjQjhxTnZZVzk2dk1hWGNEN3lS?=
 =?utf-8?B?OGtpbWpNRENMR0xuMUh1dk8zOWREZDdSYndpNGVEa2xZNWNMTUs1NTgwQ0tn?=
 =?utf-8?B?Ujh6MFVQc3Npb3puT0Fvc2FIR1N4aXdkYUl6YkUxSXo0WHh6NjNLM0pnQXNh?=
 =?utf-8?B?U3c3R3NjeEFxS1dIazJta3V3UHp6U3AwZVdiSlRmRnZPVjFDVENrNUdldUJw?=
 =?utf-8?B?V0I2UTA1WTFDMnZjVXhPU2YwaE04UFdGakRHL210UjhDYTU1WStMdUYxMWpV?=
 =?utf-8?B?THdpaHBaOTFnMGtQUU1FY1NtV1R0NG5vWXdvOUg5TDYyN2FjV3dhMUpJNFFQ?=
 =?utf-8?B?NmFYRXcxNGxvT0g4WERPOVV1Q294ZkdBcURYMzFKT2E2eHZwYkZqQ0Zzdk1x?=
 =?utf-8?B?RVlxekFXR2dMdzlUL0lSbml4NCtqOUlzM2toYzNaQUtQNmd0dnV1Q0lLRUdC?=
 =?utf-8?B?S3RDQWNXRFZJd2NRQjZpeWVOU29zNUFEVFhpSHp4U0QvQU9zNitzUHViejhM?=
 =?utf-8?B?RzNjY3ZzbnFha3lxT3Q1d0s3UlRncm5GdEc4ZFlRWGQrZUhVL2NndW01aDNX?=
 =?utf-8?B?L3R3dFRYS2xFb3lteUhEYkFJWWlRZHpacDRWcWFGUnJTVG11ZmpOTUwxT0NC?=
 =?utf-8?B?OVNQZlJTR1RZZk80WFlYVHNmTWc3M3E3TUsyM0JPSThBQVl0NEo2TTRlVU1S?=
 =?utf-8?B?bUtGQ3l5OVg0YldMV2N1alpSNHg4L3FTYS9VaUx0bDhSTmR1YmtFVWxzaVlM?=
 =?utf-8?B?aHRXb01BMkgxdHdzK1BkL2pVMlgrZDU0TjFFMW9ncVRUY2VWSkJJOVJ6QVpC?=
 =?utf-8?B?NGJ3V1BHSzVhNGpzbmxWS1dQeGMvMitYNG42VUdPOGpXc1BFYVJCcEtFNHA0?=
 =?utf-8?Q?bE4JnDbj5vw=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZGRGSmtqaFA0akozdUtIaFR4NDdNUjJHMDd0aXFXRzF6UGJudXdIeHIvQ2ww?=
 =?utf-8?B?TVUvYzRheFEwVVZtZk1zWG02cmlTT2xIZlhZeEFHQk5UM0hJVVhSS1BvL2Jl?=
 =?utf-8?B?L0xuMEsyU1ZvbnB2YysvSGZpK2pXK29ZOVloTkttSkYvTnNwUWlNdUp5aWVq?=
 =?utf-8?B?Q01COUw3R2R3MGdqSXhEYW52NS9kVDRGLzh0SVczTXRQbUR4WEFnMjhGR3d0?=
 =?utf-8?B?OXhsN0ZISkIzU1lSY2w3VHJyNzNnS1RFbndRTGlhdkdiK1lLeU1URlhYYXZV?=
 =?utf-8?B?RW1KVjVCOHN6em9aZUVXSTBkZHJ5dExQQXlLUlhYaU5KK0lDNFNRRTRVZ3Jv?=
 =?utf-8?B?M2gzY2J4T2gwZjRpdDErT3RDVzBUVDRrQy96cUFHTDg3SE5TSElYMkdYcVBY?=
 =?utf-8?B?YUUxc0RNUjRObGhubjdCT1UxejAyUWVqZnAxZjNLZTJQYm1YL3Q0NElXeVlK?=
 =?utf-8?B?b2hXMUN4TzRDUjJ2QlkwWEJ2aXdSVkRKQXh5TmZ3MzVPdjlXK05VdDJucWFi?=
 =?utf-8?B?aXJ5QTFmdkRVMnkraUhxbjVITDh3eElpaklBditIbFFNYWRlQlVVUzlST204?=
 =?utf-8?B?OC9idTkyVXR2dXNwZDBZWFo1alJKcjkrZzdJelQ0Qi9BQUo3VjBZWlFGM2F6?=
 =?utf-8?B?M0pLZE5ySjFzTXM3cXpwRjNyd3Z1dFRmL3VyRi9pdks5d2tPSlZRaGhQMGVu?=
 =?utf-8?B?dG5DdnlWRkhabVc0dTRrU0JJT0RlRDV6Mm1nNUkvazBOa25tb28rM2h1UHdk?=
 =?utf-8?B?YjVIMWVUMFByWTZ2bWJzN3VLcDFvVXRUMWNESDBPL3Q0aW01ZTRoY3lRMUJj?=
 =?utf-8?B?eXdaaUpyWHpXb2ZHQUtwdmc2em5KbE56OXl2aTRuNDQzZEJiNFVWUWx6ZGNU?=
 =?utf-8?B?QndkOWdWUjM5M1BPdFhyOHMrL2poYkNkWmFxVjVhT3cxeVhzVTAvMzRwbzJI?=
 =?utf-8?B?NlpTWDZnWVhlVjVrQ05Fajh1QURFSXZSR2tHT1QvSHBWdTZSR2lubVJIRFVp?=
 =?utf-8?B?MzlpV2srbWgvbnpkNStwa2c0bEFaK0F6Q1NXVnVMbDF5K1IyalJQSHRPbVFS?=
 =?utf-8?B?YmhpNEpjc0pDWGFqUWtPNWRnSjZUMXpkOVdYclFiQ3JYWUFvNW9oUnh0Vkx1?=
 =?utf-8?B?K1dqWXZkS1hIYU12UmhxUjMrNFRiKzc2bzA4NVBSd2lPQmdnb2lhL0IreFln?=
 =?utf-8?B?cWxzOXpYRS9qS203MjhXTVZJcGVTT3FHYWxFejlUNGxmTktEbmliU0VKY3Rl?=
 =?utf-8?B?TEhBclVjcXhuS3RXKzNLR3Q1dEl5UUJlUWY4dkFuendsVXVtY3dzVW16UC9k?=
 =?utf-8?B?VzBidUU0ZnhZb0FlVzJlUVJkTm5tbzlWWGVuOUQzSTRiSkd2bjJTZzA3RFQ0?=
 =?utf-8?B?blVuRmJNTlpyYXhQaGV4Rk9jVDBYYitRNFpiT1ovTlltTElvQVlKK3VMdkhC?=
 =?utf-8?B?bENyZDg5SEhsQnMyN0k2TTU3RS9aNys3bEFjWS82eFUyMDJ5R3MzL2NRTzNl?=
 =?utf-8?B?cTR0cE1nWVJPUGU1ek8wcWZ4MmNXN1dDWkdxNTFQd085dlMrVjNvZlQvVEgx?=
 =?utf-8?B?K0IvQ1VEdWN5ckNZSGRIV0ZibmcwVUVrdHk3ZHhaV2pZM1pIUTdYVzJkMWRL?=
 =?utf-8?B?NEIydVBFY1lhcHhNUlFFZ1dORVlGa3dKdnpCSVZGbGcvWmtmWmY3S1JncFhF?=
 =?utf-8?B?R3lpN3kycHkrSWZNL3E0QmxXaHd2d2NLVTNIWlhJRTAzb084K1RsZkZFUkdm?=
 =?utf-8?B?Z2pPWnBJeVNkQXBIY1lrNUgySkVpdWx5bWlMcnkxS1dnQVM5OE5Yd2NmT3Er?=
 =?utf-8?B?emVBbGFmeG4wdnpWQkU3cEdTKzNnZnBoUkdEd1VIc285bGZLR0FyMmovNTVw?=
 =?utf-8?B?TVhKeDFzZjBmbVZyc0txV1NwZEQwRFhhRE80RFpyOUdUc2ZMaGk2RXp3TW9F?=
 =?utf-8?B?K2o5d00rZXhlcGthbVdadG9VNThMR1ZOSVl3OGVta1JjV2tlazFyeHphZ3Zo?=
 =?utf-8?B?eHpKVG1vMlJvaitnV3JveGR3M1FjZTR3K1R3UDlDN3ZKOGczV1M4MlRhL01z?=
 =?utf-8?B?emZrblAwTEplTk9HNzJKYW5Fa2x3YlVMbnhlTHp1WG5aWjgxdURyQWF6b2d5?=
 =?utf-8?B?Z0Qzbml4TDQ3U01Ma0FOcStOTy96azlGUkdkWDA1V252eVFqQUVQQkpIMHN5?=
 =?utf-8?B?Wnc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ad742987-185d-4498-3c53-08ddf6719ab3
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2025 05:09:54.5383
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v8opeBt0tOc/ZDtz0MhgxXvrZ4EK5ZIyhvrrLRaCzPq3xyr1VRgiotOgbo/9lGTtH8uD19TQLidNzf2bnHMmsnJ69Batun7KEJ8ojPSlHOQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB8336
X-OriginatorOrg: intel.com

Hi Babu,

On 9/2/25 3:41 PM, Babu Moger wrote:
> Add the command line option to enable or disable the new resctrl feature
> L3 Smart Data Cache Injection Allocation Enforcement (SDCIAE).

Since SDCIAE is the architecture specific feature while the generic resctrl feature
is "io_alloc" I think it will be more accurate to say something similar to the
ABMC changelog:
	Add a kernel command-line parameter to enable or disable the exposure of
	the L3 Smart Data Cache Injection Allocation Enforcement (SDCIAE) hardware
	feature to resctrl.

> 
> Signed-off-by: Babu Moger <babu.moger@amd.com>
> ---

With changelog change:

| Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette


