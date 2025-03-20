Return-Path: <kvm+bounces-41537-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BFBC4A69E9E
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 04:16:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E3CC418969C7
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 03:16:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2024C1CEEB2;
	Thu, 20 Mar 2025 03:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FjVAOAGj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DAEA149DFF
	for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 03:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742440565; cv=fail; b=tshGncNaPP4Mc3jly8ioJ3QO2dYIRCQWg8wqXwSrJsLNx9iaZqoQaTLjA3mEZ0MfgCEFDyR9KozPcLWHznRrq5qfuA/q9pPEg/hg0LtA634fRxXn9SAfpYolIZVRT/F3mA1rcP6ZAhaYXybxu6ETcufqi1z9+tuSpGCx1NncwUA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742440565; c=relaxed/simple;
	bh=+n93Z1sejNMEcwXFR/uU2XV2ev4FuBmZzEc/wRFEsQQ=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=J8gX+OSbSmPb/hcVBrGfL3/q9hU9YsU6h+E7pQ9h5LU+uzJStcfRYPqlJloaRMU9h1a3sYsqiKjzvtWxF1MFkvTn+p9zYOkomwnmXRoBJC+nXFXB0evaO+B0rqVP34Kc5Kti6ceXrShzghFSRMLlpU9jPW5emacTiZGXwXFPFoQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FjVAOAGj; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742440563; x=1773976563;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+n93Z1sejNMEcwXFR/uU2XV2ev4FuBmZzEc/wRFEsQQ=;
  b=FjVAOAGjkPnWDEAzPYbbE3UzpLBxkDQUN84qT5Ntw5fR7PP5YogcZiFh
   C80QfApbrxxNl2a07dntndu7q+qJ78vx9Z8few/V+BnY2wU9mVNRl/01f
   p8+SbZS7r1sBVWCjQki92Lf6NO8Dre9vkX3ZsqnLgSZkXw7MHMQnx7D2W
   rtBKVoSTHf3dHYxkyByvkI4wOb4IsqRBJKQjyYSBoh2x726B2v1t1aOuu
   JAyQNKp3OBnIFehNLgdbOr36WqKqX6Vayp/lpAfJ/IXVErRL2P15fiWi6
   LBiv4f3+syKAz/hHQk/bXby1ZUsolINF4pjEV9whWadlbnNlpQuWR4cz7
   w==;
X-CSE-ConnectionGUID: +xAZWBkdTgW3zyUUTKym8g==
X-CSE-MsgGUID: SlRv9vhGRoqZkLeXMgG2UQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11378"; a="43544988"
X-IronPort-AV: E=Sophos;i="6.14,260,1736841600"; 
   d="scan'208";a="43544988"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2025 20:16:02 -0700
X-CSE-ConnectionGUID: 2l18mjuLSViii2/qu8UfeQ==
X-CSE-MsgGUID: Rd8NEa4SSw+kb6KSk0aldA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,260,1736841600"; 
   d="scan'208";a="123418938"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2025 20:16:02 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.14; Wed, 19 Mar 2025 20:16:01 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Wed, 19 Mar 2025 20:16:01 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.171)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 19 Mar 2025 20:16:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZXkGP6bopM8le4KQEuHruQReR6PP0vNIpPmqsHq/wYR4oVgkEfdNJuF8CALttCuI2uA9Be6JyLqerLZMDHwtKYgFL4FlqqqqGsN5lo/1PEij2njm8gXRftprQ9GPSAZ2YbS9lN2EJaDUfskJC2bYBrqyWUfynoBoxDpU29UHse2ch7a6SDtgjveCwjBs+JZ08RA/Ffgvn60eX4gEUEOfkSb/oZh7xuTuBvT1IfocA5vloErXikvVS3RAEhSvTEWb2WSOf86Qig0Tm6vGQOjz/Zr0BExO2YN9svKRa17uQRpdEwhmabrYxKj5GdEx4XEaR0MCRNAU7W0+xGO7d0drwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gsGkjKu4mVY1yXAmh9rMecaGgQLxpZ1vlOER95X8ieM=;
 b=yuzIlY1cy5VtZ5DkzF/vefEswOo62v2ciiYpz4WY5GQvhYnMuFOWstScXhJkex8kpWOfJm0Y48+mwDbGFiUX7+9CG/XI7Q0L7HqVaxJ8f5O7vbE1X8ocYPDV3bsAdbNutXazvykI1GsDuWDllUg0IEnjVWrSCtb3wGliQ+gF8tbBNgGzjlSWZBeIobxOBOrop2+5XOR9TWzpvVnvVW9xGvGun/HfkoKadygEvZZPJJ6b22lYaWl6Qf2xunzGD6/+F8l9CxKmhExS6u0Fx5+GX8bBPRmbaDb23W0y3C+1YZtyp+87+p70jpPDlF7Aot6ePp5YAt/pv0ANI6Gj7rvNMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 PH8PR11MB7117.namprd11.prod.outlook.com (2603:10b6:510:217::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.34; Thu, 20 Mar
 2025 03:15:31 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95%7]) with mapi id 15.20.8534.036; Thu, 20 Mar 2025
 03:15:31 +0000
Message-ID: <c94c26c5-9687-48df-9d40-0bca0892e625@intel.com>
Date: Thu, 20 Mar 2025 11:15:20 +0800
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
 <9c05e977-119c-481b-82a2-76506c537d97@intel.com>
 <4fd73f58-ac9a-4e24-a2af-98a3cbd6b396@amd.com>
 <4bef4a8c-6627-4054-83dc-79d41ca03023@intel.com>
 <0ed6faf8-f6f4-4050-994b-2722d2726bef@amd.com>
Content-Language: en-US
From: Chenyi Qiang <chenyi.qiang@intel.com>
In-Reply-To: <0ed6faf8-f6f4-4050-994b-2722d2726bef@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: KL1P15301CA0034.APCP153.PROD.OUTLOOK.COM
 (2603:1096:820:6::22) To DM3PR11MB8735.namprd11.prod.outlook.com
 (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|PH8PR11MB7117:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ca17136-fde4-4313-9b87-08dd675d787f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?YVBGdzlOc3BJWXhidnFMbHJuYnZJN0ZuclIxVlhLQVVwYjdDRDhRbDh5RWt5?=
 =?utf-8?B?d1ZNQnBHNEtBb1U4c2QydE9oWkZLd2xGWDBFRFhPVXdRdHo3dkRKRER4WkRx?=
 =?utf-8?B?dHpwVTZKcHJtZTVRUlVnZFVERnpUM0Vjd21KNTJSWWd5c2tFUWVtbEp6QzBD?=
 =?utf-8?B?alhjaDlTb3QraXRMUm9QWXh0M3ZzNEdzTUVSY0ZVd0ZxcmFIV2tQYzk5dTdo?=
 =?utf-8?B?Ym40aStJTXZ5cXN3SEJXd1UrYWE4cFI1VVkyYlEyYitXM3lFd0J3TVg2Nmxn?=
 =?utf-8?B?U1FoT0JPM2RBL3B5QWNPK2YyelI3NkVoZ0FXOGJZSXVyYVk3UHlFZzlkclh5?=
 =?utf-8?B?bjc2VDJGaTk3a3VvUEZ3eXAydTA1elNId1dXVXp1emFTUGNoV3dmcTV6RFZz?=
 =?utf-8?B?VlcwZDN0VHVCQ3o3OTZMbGtyNGJUa2hVM0ZIVno1aWxQVTg0MjRRSDBJNm01?=
 =?utf-8?B?U0lEZE1yMzhjbjlGRjNyTzVpUG05MmpLNGVxZHlLNnh4NC9EeGlLbG0zL1pG?=
 =?utf-8?B?ZUJUOVRYNWhuTkFJVngvaXc5Q3BxYTBud0ViQlc2K28xbkh6a2c2YWpKbkQr?=
 =?utf-8?B?VXJwaUI3ekkwRm1zRGxRYVBvbThOU3A2NStOUUJzdHFMODBYdjFhSEFPbW5L?=
 =?utf-8?B?Y1RuTGlVTE9UeURWZ0NDZ055dmE2R3N0RnhPamYzUHQzYXpZWXgvUHN3eER4?=
 =?utf-8?B?V09QWlVNUndIT2Zrd3J5dWUwdkkzOTlrOE4zeUg1R3phV21qNmVkQjFSdkVr?=
 =?utf-8?B?NUFXZDh0YkxNemtOZUkrYUNPZ3gveDArL2Q5TUtJeEpGK0RuTS9YclgwTTc4?=
 =?utf-8?B?akN1ckNVQ0hqWHhydFc2N2ozLzZkMDBQbUtjazJRNUI4UU0vRFNIbDBYQUhW?=
 =?utf-8?B?WHNzUVlmV0hpTm9DdVR1VWFqTUxzR3dpbzB2RmtXaGNqaHk0akREZDZ0TzBk?=
 =?utf-8?B?SlhmK1FVRUdZME5TTHJFMzhwdFIxZ0RBZkd5MzQzY3NpbWwrdEJzU25Rc29Q?=
 =?utf-8?B?Z1l6cStZQ1A1UHhjbHBYS3pCZEUvb0RNYTM4SGJzNlVCQ1RjVmhidnIyWitQ?=
 =?utf-8?B?S2VvZERpSzBVQkxVTXMwNkNtYkNQS3ZURG9oOGdRQXl0WEV6MXJjbldXeHZj?=
 =?utf-8?B?UjNWWkIvYUVyYVpTZFdpOHNtdkFacVVWTEhRRm9ET1FmZmhReFA4OXBVaW9H?=
 =?utf-8?B?cHpjZEtENkFxUDlvcFFoV2s1U21ZT2ZCODlmUEk0NTM0NDgyVGZwNnhrUUY3?=
 =?utf-8?B?ZU5rT3VtNmVPODg3aEVvck9seUNQYnpGUTBJVUhhendPRUZjcWxmblNnZk1s?=
 =?utf-8?B?YmF2MXhWU1N0QVQ5Y3VUM3pwQk1NTGl5bWV6ZXF1Q3JoMXd6alBNZXd0QVUr?=
 =?utf-8?B?L2dnRzNSekRqcU04allFVHlwSWkySHlQaTR2TFBrR2k4ODU5Q0lxY0J4L2p5?=
 =?utf-8?B?OExLZnpiSEtPVS9SczBtWE1CUEFvSG9LOTMvdlpPcFlMdE1YeEFMWEZCQ3px?=
 =?utf-8?B?YlY2eFhmQ2RXQ1RMdXpEcjZjTGNrRlVoOWdTZXZqVHZSd3gzY2lhZkpsaTRZ?=
 =?utf-8?B?TXZRc1lpbTE5VzhkbGR4d0czK2Q1b282QXFnRVVMUm03bmZPa3RJc0tMelNP?=
 =?utf-8?B?QnUzM2ZsMzhRY2hwYjk5Z25RRFJMSWlLSE11QkwvTWhhZUhWVTBSTzRWODMr?=
 =?utf-8?B?UFl2K3hCOE1TTHpNSnZrNVVXY3V3RjNlTmY2aFhUY3QzamM5cjZVb1hqK252?=
 =?utf-8?B?dW5NSGRlWGtYWHZraWQzbFQ1c1NBNXhaWldjN1ljbkFxY2tGaGpDaWIxZ1hY?=
 =?utf-8?B?WE4rNmc0c3Z5RFlSc1g0VWl0ZlF6bjVCckVzaFp3MFVTNXJDMHVhWjVSNGxF?=
 =?utf-8?Q?ypTWvIfJW10MW?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TnpEdk5BQksxVnB2M3loZTA4UFI0YWJvbytoZXBwWXpJaTZ3dEp2NHY4a0Jn?=
 =?utf-8?B?d25yUU9GY3UxNVVZLzhQeWZ2aGJabDh3M01zMHRtWjNCaHRRQlIxTjZUVXN0?=
 =?utf-8?B?MGlYRWZmS3ZMOVJOdXpWMTFwUXRaQk40VzgzL1R0U28reGxCc0EwOExTczg5?=
 =?utf-8?B?M3c4M1lQNGNSWFY5eWpXcWJZSFNLV1Q0N0tWa0tyZytWaHZoK21HMGVIVGU5?=
 =?utf-8?B?ZkdZcC9adk1VY0tLUE0wc0pZOXplTEtjeW5sOVlPNFl0QW1vMTF1Y2lySDBo?=
 =?utf-8?B?cjdURXA3cTJQbVhiR2p2bFpwRVd3eXZyVjhKcGJXWXBMNmo0U0tWNTV0RXZI?=
 =?utf-8?B?bHRsamdwc0VFTXd0MEdMREdoVGY0VUxDUUNDVzRTV2p5QkFBUFM0M0JQZWdJ?=
 =?utf-8?B?L2s1WG5ZemdDWnJxTEl6N0lMRndzL0JBUmVtNWlDY0lDR1VyNTkwMERvSHJS?=
 =?utf-8?B?YzA3T0l6L3lpNGxVb1RkZzU4a05PRUhORmllZTZYc1NrWnVTbHFvUy9qMEJq?=
 =?utf-8?B?V0pYM2NOMUk2TmM1S3VjNkhDSnpXTERUQytDOGNEY3hCdVVXNWNBcVVCbHd0?=
 =?utf-8?B?TSs4dUZqdUdnK1paTzJTbE9hMTFUcnU4VEVoNkVRWmt4OUd2V05nZ1hlY28v?=
 =?utf-8?B?U3dVYWtBMk50Y2liYXBISXFwdWxSRFZpN1lyc0w4NGRyeEVkK1pqUlJiNU1X?=
 =?utf-8?B?SXVhMDFOdVVqcWlsRHlSSXNyVDZ3a3k1UDBvcEN3bUFVMGlUQitCcnArRXFa?=
 =?utf-8?B?UlRXSVBOeFFDL2NMdkxSM3ZFK2h4MGRDS0xCQ0ZFeEhiMnc5c2ptOHhHSW9q?=
 =?utf-8?B?cVh2S0E4WDJKcXRsRlRCWGJMaUxyVlg5K1hJTThERHMzZE01WGM0WDRYM2VI?=
 =?utf-8?B?YlRVcnZ0anRFbHdtcE53U0k5ZG4yMlJxZVIxZFpzYkE1ek5Ca0FuS1dRMGhw?=
 =?utf-8?B?b0FwL2xSVWRhNHhTTlNXRFIyci84eHArMUpKWVIrOG1PMlZLaVcyaEIzWWF0?=
 =?utf-8?B?WTVYQ3dodTh5VDRtZG1vK2RhMUFwWkN5YVl0cllSYkRkUGc2ZnBMVUtYbGdE?=
 =?utf-8?B?YkFjcVR6Sm1CZ2pLWXFRMXFUdVdPaEE1Y2d5TEdTcFRoa015K3lYbFBoSDhy?=
 =?utf-8?B?KzVPSGtsM281NlN6MU1SckJ2NFB2SFQzMVF5YmRtMVNZS2F0TGRWbFN3QjZk?=
 =?utf-8?B?QUUxS05ZWm05clJYNUNRN2xTM3FLZXRUdDJRbE45ZWxkTHM4VzV6L0Q4Um54?=
 =?utf-8?B?aTJnbElJRlVnZUhyZFJrSlhFUDBqSVUwSm8vL0NyYThoR2xYbjVRVTA2ZUpT?=
 =?utf-8?B?eDd5L1V1WHBKdzVsZFRXUDRLV2FpK3hTOUlGSlRzd1JWT3NHVnRucXV1YjBC?=
 =?utf-8?B?RlphYWhwK1FLSnNqZWpKT1loUXpGOXQ3ZnZtVHcrVWphNGpqczk4UCtCS0lF?=
 =?utf-8?B?VmU4VzBmWXpQSE5aeWwvUVRUaHJGRkZKenBGN2RNeTNEOGNUSGswelFRYlU5?=
 =?utf-8?B?S1lGTUU5TW5YSnl0dysydkVqL0M2aWJWQ2drZVY3K2x2VU41VjJEaGpwMW9M?=
 =?utf-8?B?dTkvNmtDc05rd2RMaUlnVUQyeEoxRzlJWFBtdmpSVEw3NnJNdlYydVRRT1o3?=
 =?utf-8?B?Q0xITmFBSno2bkxvREYyVGhld0lrc3FXNS8zT1JkUTk3U0N0bFRSUUE2Njdk?=
 =?utf-8?B?WWJRMjBhNEJZSEtlMXMzWDN3YXl2ZmhrdkF0Ui95bW51WUI2b3hXVnVCSFlT?=
 =?utf-8?B?MUFzZ1VFUmZCMmt5NEhxaVJZaGxCeVYvNHR2OTk3V0R1RHhPa24wbzkxNmo1?=
 =?utf-8?B?T2lIeTFZUnhNbjdVdndHOFBMc0tZdW5wSnp5c0JvWno0S0phcTJzOEl1TEZD?=
 =?utf-8?B?YmZMOGhlRmRGekxFUml2MmVrK1JlQWV6eXRHd3BhZFJ3Q2paV1RDOEpKMng3?=
 =?utf-8?B?RjVCSUUvWWI3MHdyZTJ0Ty8zRkthYjV1aHZ3bjNoMDltc3ljT3I0N0F3eU5K?=
 =?utf-8?B?ZFMwNExnN3pCMWd4TmlaQ00xNzc1VTFBWVpLQTBoVGNSUmE1UFc0Sjlpdng5?=
 =?utf-8?B?dEVMZ2IxVVRKZVVxSGFzVjZzTk1GQk0wMDN3aXdXNXQ4UzBKRGRiVnBWL1Ni?=
 =?utf-8?B?VVdDREFwOUR3cnhLbXMrMUtGZGRGT3EvNHJyRjFjTmJUeS9RZmZLUVlic2xL?=
 =?utf-8?B?ZFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ca17136-fde4-4313-9b87-08dd675d787f
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2025 03:15:31.1317
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T/AFj/iEqwexH+1yY95FcRlyfu0pkPFTecDAVni6H22ZOCypQrXxa95w77qlnTfzc0PDa8jAW77rAxUn61tVrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB7117
X-OriginatorOrg: intel.com



On 3/19/2025 7:56 PM, Gupta, Pankaj wrote:
> On 3/19/2025 12:23 PM, Chenyi Qiang wrote:
>>
>>
>> On 3/19/2025 4:55 PM, Gupta, Pankaj wrote:
>>>
>>>>>>>>> As the commit 852f0048f3 ("RAMBlock: make guest_memfd require
>>>>>>>>> uncoordinated discard") highlighted, some subsystems like VFIO may
>>>>>>>>> disable ram block discard. However, guest_memfd relies on the
>>>>>>>>> discard
>>>>>>>>> operation to perform page conversion between private and shared
>>>>>>>>> memory.
>>>>>>>>> This can lead to stale IOMMU mapping issue when assigning a
>>>>>>>>> hardware
>>>>>>>>> device to a confidential VM via shared memory. To address this,
>>>>>>>>> it is
>>>>>>>>> crucial to ensure systems like VFIO refresh its IOMMU mappings.
>>>>>>>>>
>>>>>>>>> RamDiscardManager is an existing concept (used by virtio-mem) to
>>>>>>>>> adjust
>>>>>>>>> VFIO mappings in relation to VM page assignment. Effectively page
>>>>>>>>> conversion is similar to hot-removing a page in one mode and
>>>>>>>>> adding it
>>>>>>>>> back in the other. Therefore, similar actions are required for
>>>>>>>>> page
>>>>>>>>> conversion events. Introduce the RamDiscardManager to
>>>>>>>>> guest_memfd to
>>>>>>>>> facilitate this process.
>>>>>>>>>
>>>>>>>>> Since guest_memfd is not an object, it cannot directly
>>>>>>>>> implement the
>>>>>>>>> RamDiscardManager interface. One potential attempt is to implement
>>>>>>>>> it in
>>>>>>>>> HostMemoryBackend. This is not appropriate because guest_memfd is
>>>>>>>>> per
>>>>>>>>> RAMBlock. Some RAMBlocks have a memory backend but others do
>>>>>>>>> not. In
>>>>>>>>> particular, the ones like virtual BIOS calling
>>>>>>>>> memory_region_init_ram_guest_memfd() do not.
>>>>>>>>>
>>>>>>>>> To manage the RAMBlocks with guest_memfd, define a new object
>>>>>>>>> named
>>>>>>>>> MemoryAttributeManager to implement the RamDiscardManager
>>>>>>>>> interface. The
>>>>>>>>
>>>>>>>> Isn't this should be the other way around. 'MemoryAttributeManager'
>>>>>>>> should be an interface and RamDiscardManager a type of it, an
>>>>>>>> implementation?
>>>>>>>
>>>>>>> We want to use 'MemoryAttributeManager' to represent RAMBlock to
>>>>>>> implement the RamDiscardManager interface callbacks because
>>>>>>> RAMBlock is
>>>>>>> not an object. It includes some metadata of guest_memfd like
>>>>>>> shared_bitmap at the same time.
>>>>>>>
>>>>>>> I can't get it that make 'MemoryAttributeManager' an interface and
>>>>>>> RamDiscardManager a type of it. Can you elaborate it a little bit? I
>>>>>>> think at least we need someone to implement the RamDiscardManager
>>>>>>> interface.
>>>>>>
>>>>>> shared <-> private is translated (abstracted) to "populated <->
>>>>>> discarded", which makes sense. The other way around would be wrong.
>>>>>>
>>>>>> It's going to be interesting once we have more logical states, for
>>>>>> example supporting virtio-mem for confidential VMs.
>>>>>>
>>>>>> Then we'd have "shared+populated, private+populated, shared+discard,
>>>>>> private+discarded". Not sure if this could simply be achieved by
>>>>>> allowing multiple RamDiscardManager that are effectively chained, or
>>>>>> if we'd want a different interface.
>>>>>
>>>>> Exactly! In any case generic manager (parent class) would make more
>>>>> sense that can work on different operations/states implemented in
>>>>> child
>>>>> classes (can be chained as well).
>>>>
>>>> Ah, we are talking about the generic state management. Sorry for my
>>>> slow
>>>> reaction.
>>>>
>>>> So we need to
>>>> 1. Define a generic manager Interface, e.g.
>>>> MemoryStateManager/GenericStateManager.
>>>> 2. Make RamDiscardManager the child of MemoryStateManager which manages
>>>> the state of populated and discarded.
>>>> 3. Define a new child manager Interface PrivateSharedManager which
>>>> manages the state of private and shared.
>>>> 4. Define a new object ConfidentialMemoryAttribute to implement the
>>>> PrivateSharedManager interface.
>>>> (Welcome to rename the above Interface/Object)
>>>>
>>>> Is my understanding correct?
>>>
>>> Yes, in that direction. Where 'RamDiscardManager' &
>>> 'PrivateSharedManager' are both child of 'GenericStateManager'.
>>>
>>> Depending on listeners registered, corresponding handlers can be called.
>>
>> Yes, it would be more generic and future extensive.
>>
>> Do we need to add this framework change directly? Or keep the current
>> structure (abstract private/shared as discard/populated) and add the
>> generic manager until the real case like virtio-mem for confidential VMs.
>>
> 
> Yes, maybe to start with we should add new (discard/populated) changes
> with the new framework.
> 
> In future the current framework can be extended for in-place conversion
> for private-shared conversion (if require userspace help) and virtio-mem
> like interfaces. Important is to have proper hierarchy with base bits
> there.

Thanks. Then I will follow this direction.

To abstract the common parent class, what I can think of is to abstract
it to manage a pair of opposite states (state set and state clear, like
populate and discard) and define some similar common callbacks like
notify_set() and notify_clear(), as long as we don't use it to manage
more than two states in the future. Otherwise I may define a stub parent
class.

> 
> Thanks,
> Pankaj


