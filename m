Return-Path: <kvm+bounces-32405-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8082E9D7BE5
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 08:22:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0F8DD161003
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 07:21:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38C43186E26;
	Mon, 25 Nov 2024 07:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="buB9/BnO"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2051.outbound.protection.outlook.com [40.107.223.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2AAC1426C;
	Mon, 25 Nov 2024 07:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732519314; cv=fail; b=P2M6EogtqRcgICCVL73XEM2mn9RYT565bBE9A2goSAaQZDz5/QVi/D1pOP0KYBgmYoHxgaFz0EpCYwS2QLIJxtAAa1zNPhc1uZC/rBzfPDDpadFNgVipuyJ0bekAPG3QTmy7kKsZ2xvAs+XmCjvYWL3MPD0XHjCaBaa+i+hqZxw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732519314; c=relaxed/simple;
	bh=soyGNKcKAKt0OQ3jxbKU1ysTd1EMSq8QsU2fjbKfQN8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=pa+coMbh05zYX/cbBH+6zLeR/noRfaxOGy/ULNb0GhJEJNox7jXyqTfybC5dEe0GZJztPwdgn3j8j1KH0RSvdx3NjKqv1YSYcFPvm1jR4ItBD4KPFH41PTwrHbTP+Rm9yaC7RV6DhUHeCwxeja2E/xQN3+8C/UAM3G19AXVN16c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=buB9/BnO; arc=fail smtp.client-ip=40.107.223.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PNaU+EZ0hA3pmfgf+TMOtJs1eW/+GlUKPPY72Nxf4T+FaAvEqWncSAJkxwKc6rOM5kWupu3PGKqLC5Cj2HMoVYzphRD8WSj8oEv8C+FyWEL10D8GxenJJ4KzagudgqNsGdWmOLsRjh7bZ3+aa5ntkpZOdfskn/io/GhSu/i0GAAVLeE12M323zCQc4bhRdJm1n01UgE8Wo+YBEr02pTdpVgs80UY/EGTWtqwfq0MXFKug//zMTK5WoU6z7oEB2fqkZNzwWF5IWXmQ7FwQtJTx4N8XdMuz7PhTBRtdH1yAraSZjum2h3JMzamq76fEr/+L8+5PtB183+r8puRBPpLYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w3+E0wLg61F/V5kmlD8tezazaDWf4PUxe8LXdMRAtYs=;
 b=ZnvfVXJTLnBsyVtewJVl2C8A9ROHJpz15vW34sHa6zlidcYStJ3J0T78c/GAhYa8q86QKFWp8T/MOwxYSk67htVJkXCbTGMGrmhSlG8saxsXzeF7ZpGo/xHG/WYXcksIlPL8Nq182TkCbwJgbFV6kueeHVkSJRv3/Cya+FNU1TS0JYVEaS/ibU5j7Xo6Lce9AWRuY2cu990kMdVbB3svXTfhue9OaGPRwaeb5vcmkvY65MnXBlziGDeJ4oha1SQ66EGIRYnb3xki2wiWgS7zi3TxBrT52/iZpdUo0zh+CeoyhgiO5rmfXX30VsZaJUADnTdf0zx3OzOVDHOaRbpG5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w3+E0wLg61F/V5kmlD8tezazaDWf4PUxe8LXdMRAtYs=;
 b=buB9/BnOqTN03M8B4pkcfNVG/tgqCaEEUNy7At+ojNb9+y2el/rIpU8oc7M6LX6GTibYH1/W0vntO0KnHp5cXn+ZqingBXxNCnFa4S2yVq24FloWqLAtzgjrrr5YQFwjiRZDrUPa5ZQjlVh7GMni7qYq/23dd4Njwuc3l31CsUs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6608.namprd12.prod.outlook.com (2603:10b6:8:d0::10) by
 DM4PR12MB6301.namprd12.prod.outlook.com (2603:10b6:8:a5::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8182.18; Mon, 25 Nov 2024 07:21:48 +0000
Received: from DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627]) by DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627%3]) with mapi id 15.20.8182.018; Mon, 25 Nov 2024
 07:21:48 +0000
Message-ID: <0042e7cf-764b-4ab9-9c66-0d020fe173e2@amd.com>
Date: Mon, 25 Nov 2024 12:51:36 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 01/14] x86/apic: Add new driver for Secure AVIC
To: Borislav Petkov <bp@alien8.de>
Cc: "Melody (Huibo) Wang" <huibo.wang@amd.com>, linux-kernel@vger.kernel.org,
 tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com,
 Thomas.Lendacky@amd.com, nikunj@amd.com, Santosh.Shukla@amd.com,
 Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com,
 x86@kernel.org, hpa@zytor.com, peterz@infradead.org, seanjc@google.com,
 pbonzini@redhat.com, kvm@vger.kernel.org
References: <20240913113705.419146-1-Neeraj.Upadhyay@amd.com>
 <20240913113705.419146-2-Neeraj.Upadhyay@amd.com>
 <6f6c1a11-40bd-48dc-8e11-4a1f67eaa43b@amd.com>
 <4f0769a6-ef77-46f8-ba78-38d82995aa26@amd.com>
 <20241121054116.GAZz7H_Cub_ziNiBQN@fat_crate.local>
 <6b2d9a59-cfca-4d6c-915b-ca36826ce96b@amd.com>
 <20241121105344.GBZz8ROFlE8Qx2JuLB@fat_crate.local>
Content-Language: en-US
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
In-Reply-To: <20241121105344.GBZz8ROFlE8Qx2JuLB@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0171.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:de::14) To DS0PR12MB6608.namprd12.prod.outlook.com
 (2603:10b6:8:d0::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6608:EE_|DM4PR12MB6301:EE_
X-MS-Office365-Filtering-Correlation-Id: 76391f9d-ef69-4b01-627e-08dd0d21d2c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?K0tWMnlDQlFmUXhrVkhwMXV3V0RVcDFab0p6OXlNdmVHTEluUzdBY2ZXY2Za?=
 =?utf-8?B?N3hRZXRNN2ZWQy9LczlKdDhoUVR1NGNOakxLdDhBSnIrNVkreHNSMU1mTCtY?=
 =?utf-8?B?NlVKZ2hvQm9zaGFUandYTUhzcHdDREFYakYrckZyMytyMzRGMnNGOXRSUWth?=
 =?utf-8?B?a3VadHRGY1B2RzE1REQ4Q3VZZUdzMDA0TnlNb1pNOWVyOStCRXZYaVUwSW55?=
 =?utf-8?B?cG1WemtyL1FoSmt6OVo3TENjMUJRMkdVdGpIWXRxNEJRT3l1U0NPZk92S05z?=
 =?utf-8?B?UlY5b3NOcWtha3hqTm9HaXIyWVo4aUluU1NWVFMwWGJoSEJKaXB6MFcxZTd3?=
 =?utf-8?B?Um1ZVmU2cHZRWFhMNCtMY3RBbzh5aDVveW1LQjg3MEdBV1d6UkwxRm9jM1hr?=
 =?utf-8?B?N293VzlFcnNSMVhoYlJrSXJZaW5YS0RjT3pMVEUva1Y2cG5WNldwUHA1djlO?=
 =?utf-8?B?RGVOd0NWQ2VnaHJhK09TMENERHNVRG4rWkJ6QjZZSlRjb1FFUXVpdHBKZkph?=
 =?utf-8?B?dHFGazVTV1pIUlk0VFk3bHpyUzZoQWs0TkswczR1T2dhMTdFUTJhRTU1dlNR?=
 =?utf-8?B?czVGeGFPcjVHbmtEZWJ2SEN2dHZjemFBQXpjeko3SUc3TEc1ZVlMR0srVHk1?=
 =?utf-8?B?ZFVuSmNRTkp4OXVHdUdEUC92aWljbzdVNVN6UE5tdEpaQXhYMWZwYkpseVpO?=
 =?utf-8?B?WGdqRXR2aldIZWVSc0FWWkZ0VUJ2NnB6dWg4STFFdi9BL0JUMloxYk1yTGNS?=
 =?utf-8?B?OU9MN1RnR2hQT3pjblV2Wlp5U0ErZkZxVlgzakJYNlducHd6eDNXcXBHU2Qx?=
 =?utf-8?B?V0ZBeHAwb0U5ZG9ITjVUbUlwelJBbkNpcHV4VEUwVks2N0tIWkxoMVRtbE91?=
 =?utf-8?B?K1V2MzVVUzZ3SjNzTkFJQ3ZDNElFWWY3d0oyd05nR255bE1kWXR2bXRKU2gv?=
 =?utf-8?B?TnFGWmpTOTVIL21rWEVsQWVQcytxZndkRGJKUmNwQWxoUC9jNXZrZWdJbVRm?=
 =?utf-8?B?eWprZE1DUnVHbE9vRzI4eWwxZHU3dzRRNk9kdjQ1MHNqd1hVcVNrZXBCUUhF?=
 =?utf-8?B?cDB3STJEOGFGT2cyS3piNHJnRDc3dEdwY0NRU3JaWFIzUVFCazY5WGRmVnNH?=
 =?utf-8?B?N2FVY1hxbTJwNFNrODI1L3ljdzRicUlyQkNlekJpbG5Iak1hWkRteURVaTli?=
 =?utf-8?B?YnY1ZXJleUdDemlyM3U3a1U4aEtrN0FGWjNkelNvWWJvUlRQcXFadUlZTEM1?=
 =?utf-8?B?Rmg1a2swd09DRE1IdVh5dXBRTWUrdUoxRjRJZkxtZVI0bzkvUGQ3c0Z3RjU2?=
 =?utf-8?B?d3hVUGhVOElrOUQxVW5CUFh0Q3Z1cWRUcGkyai9jN05JQWE2Y1d0QjdEZjZC?=
 =?utf-8?B?THZrWUcyTkpHeFlqMnVvaHBPZW1CaXlsMXo5eWtjUXNZa0lKK1gxb3VWOHVh?=
 =?utf-8?B?bG8yeVRmbTlNMk12cFFhZ09HSW9taWFSZjFUVlhoOWNPRW1HVEVYRVluRzNu?=
 =?utf-8?B?S2llRXZTNzFjVFRscU9TYTNEVVlRcGhyQ0NYcWtlWGdmYlgzL1pEcFU4N250?=
 =?utf-8?B?QlgrdElPbHpwYVdMWSttazJ5TG9TU2lGODhJeDV1UGMzdWhDbmdlVldYUkN4?=
 =?utf-8?B?cUVkdTRGTW1tMGpZM1BkU2RETGpabTR3bm1Kell0TW91VDgzQXRjeUx2a1do?=
 =?utf-8?B?NDdvUTV5SDM0N1FoVzU4c1lQM0RnbVZSd01jZlZYVEs3cm5hc1N5WkV3U0xm?=
 =?utf-8?B?MHluWCtZa1c1a21NRHVKeHkzSDdFQXFQNWRtclFLSmxhalJBT1RuVGdLSU1O?=
 =?utf-8?B?b1NkNjFUVm1VSmtJUlZ4dz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6608.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bUpBbVZWNjRVQjJWRFJEMEt6c3FlTHNSOVRKUTlZdW1HMUQ1Z20rZFNwRTZz?=
 =?utf-8?B?TzZ1Q1dxWkVtTStLNzU1UEgxUDhJMnoxQlFJbi9sdG5DN044ZG1QaUFpUXZS?=
 =?utf-8?B?VEd2MTRtSURobW95RlN6Y053NXlsdnVzZktVMTVVZis3Y2pkZ3R3NmtYaVNH?=
 =?utf-8?B?RGsvSE11WXpOQkdacjRoUm5pOUpuNXdLQjVhUFh4eEx1TlpLZmRNZDY3V0F2?=
 =?utf-8?B?c0JFRDJnMVRmczJHWWhqSU1wc0lCLzd2bVQxNm9YOXNGSmlpdmhDOC8yZVlB?=
 =?utf-8?B?bzRCa2xndjV5WHNYdXZITExjdkF2Rk5GS1dRTWpuMStTUitsZWJyWmc1MDNH?=
 =?utf-8?B?MWh6YlBnS0pRQ1lGeHg4M3RxdWtnZVJsYmhmVFUxSmQvOTFsVjBEd0JKTURk?=
 =?utf-8?B?d0FBaWpzQjVNUDJSL09ucDlPRm8rT3JLWnc2bHpwZCsrSFU1Ulc5UTN5OW94?=
 =?utf-8?B?cE9YUDY5T0J3WHJORVEzL0Z1VzNDdWpKOFFXbHpWNU9IUkMzM3VRZGZldi9U?=
 =?utf-8?B?R3ZneGlpYmd5cTN5cFNUV1BqSVlXUEJ6YU93REJOQmtmQjhTWUJGeVhiVkE2?=
 =?utf-8?B?QmV3R0MzQkw3OWNLZ0F2WWNjTlBVaC96VjZjZEZ3SGVhSEtIeHpuSThwaGJu?=
 =?utf-8?B?Z2IvY1NIempyd2oyMGFqSlFBTXY4cGNad1E4WXlETVp3aGtHai9rb2MrcnZs?=
 =?utf-8?B?WjhHVFdQY3FCTUFOcExGbzVPUFdBU3h5UUo3djBoeVlCbVNzQk4yWTVjUUFW?=
 =?utf-8?B?Lzhrb25vbzBQQmNTSE1TV0wzODVDVFJDVDIzZ0QwUkVWYkM3SUloS3NYQldU?=
 =?utf-8?B?RVp1MEErbUczNXZ5ZTZia04wcm5NSGpXTmh4OS9SQVJxTnNWZmN6eXd6eUIv?=
 =?utf-8?B?UEg3b1dPOGQ1L2xCekFJMDFDdVlxaHlhSyt2NG5LZm5rcWRGMUVRclFUeFhN?=
 =?utf-8?B?dUJsSC9WOFY2R1llZEFBK0loZS9jMlVjdGNzbmpVVG5sYkdUQlRSdlU0TWRk?=
 =?utf-8?B?ZmNWVG4waXpzUk9pelF1YWl0TC9xNzdydXZ0Q1hPajdUK2VpWDNXY2IzZTFZ?=
 =?utf-8?B?OWVRQWw2RU9yNFg3ays2Q2dDOEo0bG5jSXlMVWNHTzVFbXFmQ2l6b28wZWpj?=
 =?utf-8?B?U2tmR3gyYlhGREQyanpVODAyMnQ2NE0vMUNqWGsrdXBJM3pqamZ0TVhxUWkv?=
 =?utf-8?B?ZS9LSGdJWE1vcGNsN1BVK2lOb2FqYldqWmJvQmM5QUhRTmZZT1J0K2dJMGky?=
 =?utf-8?B?M2FESGNNNFZFNzYxNWt1ME9yMlh5TlVnQW9XdVlHQ1VQN0lyVDJGVDJJeUFv?=
 =?utf-8?B?enl2ZVpVMEpSdzVOaVFib3AyZDBMR1NIZmR2L0lLOVg5aEppMFNlc2dNWWha?=
 =?utf-8?B?Rnhab09XZVBseTVxbUtzRDJUN0RWbkJGZVZ6bCtMcEg3ZWxRTnRmdWorUkw0?=
 =?utf-8?B?Z3RPcTUyQnNxbUdRTmVGUXVveGFuNGovNTNqOEFUV0R0Yi9DcGlVN21hRkxk?=
 =?utf-8?B?OWJKb0JiYVZnT3N1d3JUUVNhVXdYT2NSS2RoODBjdzNuSGN1Zmx2a2ZDSzEz?=
 =?utf-8?B?bTNFcEZtekU2Vm9TM1pLOHdZOEpoR1EzTDkzREUvS3lsV01EdkUzZURrYVRU?=
 =?utf-8?B?UUhJbTdQOExJQlAxcjZEaTZ3bmEwRENjcmlFWkF4bkgwaW5LaHdCbTdFd3Jp?=
 =?utf-8?B?a1ErbXNzTmNJV3BGeU4vUFpNVnRXb0RlZXljUEp4aWRvT1pNL0tJcGZJZVpq?=
 =?utf-8?B?OWhsaE1EKzhDT08yRUNCYXBMYUlWWWJ4MU1UN1ZxcVQvczNRWVJhbWh4dmIz?=
 =?utf-8?B?MUtCUllUQlAwRWxZUVRPT1NzMzZLdTAzM0RjNjZVcXBLN2FyUWVLV2xnWkpS?=
 =?utf-8?B?TlFYNXcyY2pQWG1tMHkxUFROaHZlOHdjTmRxZHBsdEV5b1EzRmptWjJQVWpQ?=
 =?utf-8?B?ZkNOc3VnbW5DQjVqWlJUTTBhQkl0ZHFaMEVpRVVUa0RQZURPRU1kZTlNbEt5?=
 =?utf-8?B?bXRxNnhzVjFCSWZiYVZvYU5Cbm1KNXF1NHBybXZHRUVaWUs2QWdWZlZCZXIv?=
 =?utf-8?B?NVNuRWp3UXhHb3NWVm5xNlFPWUlOV0FGMTdSSHpEVkVhRVBDVHBIQ2QyeVd5?=
 =?utf-8?Q?0wjpMxhd0PMKFMCZqSO6X43iH?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76391f9d-ef69-4b01-627e-08dd0d21d2c9
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6608.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2024 07:21:48.1974
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W/7wRodhaxlbv47tBkyvI0xtHIhsPjU6Gz58Cz/6zQ7Mo23esh3HNdFNzjAWyviFHYr21A2gjTm1fIdkZRcD1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6301



On 11/21/2024 4:23 PM, Borislav Petkov wrote:
> On Thu, Nov 21, 2024 at 01:33:29PM +0530, Neeraj Upadhyay wrote:
>> As SAVIC's guest APIC register accesses match x2avic (which uses x2APIC MSR
>> interface in guest), the x2apic common flow need to be executed in the
>> guest.
> 
> How much of that "common flow" is actually needed by SAVIC?
> 

I see most of that flow required. By removing dependency on CONFIG_X86_X2APIC 
and enabling SAVIC, I see below boot issues:

- Crash in register_lapic_address() in below path:

    register_lapic_address+0x82/0xe0
    early_acpi_boot_init+0xc7/0x160
    setup_arch+0x9b2/0xec0

The issue happens as register_lapic_address() tries to setup APIC MMIO,
which applies to XAPIC and not to X2APIC. As SAVIC only supports X2APIC
msr interface, APIC MMIO setup fails.

void __init register_lapic_address(unsigned long address)
{
	/* This should only happen once */
	WARN_ON_ONCE(mp_lapic_addr);
	mp_lapic_addr = address;

	if (!x2apic_mode)
		apic_set_fixmap(true);
}

- x2apic_enable() (which enables X2APIC in APIC base reg) not being called causes
  read_msr_from_hv() to return below error:

  Secure AVIC msr (0x803) read returned error (4)
  KVM: unknown exit reason 24

- x2apic_set_max_apicid() not being called causes below BUG_ON to happen:

  kernel BUG at arch/x86/kernel/apic/io_apic.c:2292!

  void __init setup_IO_APIC(void)
  {
        ...
        for_each_ioapic(ioapic)
                BUG_ON(mp_irqdomain_create(ioapic));
        ...
  }



- Neeraj

