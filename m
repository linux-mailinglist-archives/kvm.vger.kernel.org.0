Return-Path: <kvm+bounces-33904-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 70C599F4356
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 07:13:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9BD4B16996D
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 06:12:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48BF0158A19;
	Tue, 17 Dec 2024 06:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="MlHcYV8N"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2064.outbound.protection.outlook.com [40.107.95.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FCA5157A46;
	Tue, 17 Dec 2024 06:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734415971; cv=fail; b=KpTXm4woCwRyI4/6StC+bAANd2a/G0FsMHRXwMiTrUgY+DtiUyXE2V6yBfuqnipFKT+P9Mr5mRpcBwydXopmkQqlSIIqgHC7dVUHViEn8MNLmPtYmKe8hoi14oP3o5TG1rFwUXA46VNzNgbGcnbcn//CiN9J6e3b9xn5BtRxuLY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734415971; c=relaxed/simple;
	bh=NBdpJ8+kPUPfZZWMNW8/CpCXfo/WpkkIK8m5MisrbAI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=r/KZb+LQ5dPTgqA+yBokWZm+BR2DSs37laKRECtXw1CyteYmsdInk39e89y5ezG798shX3Pghc3iHNHMt5kAw/W8DLoF7m3PhR2njv8Gz0cshz3nWxGZHfXLX+omD/niJBhB7rMi+gS2b6naV3xZg1P2ORvTJ90aivJ1fwXT9L4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=MlHcYV8N; arc=fail smtp.client-ip=40.107.95.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hjOhxpbCaInieV5XP7qkD4FFq0svOXNhAqkfH4Q0WdKPSgyCiy3XKEJtqHeUCm/AO3MeZmmWDBKT/J0oL9JvPK1HZCLxWiyG3VaILMWR3EYX/96i/qChauM0y6zdz9Et7L/Xl8Q0vcPl1fUiaWoqi4P1syNDBwTpkXsFOuDqwqSlTmj82OjdOOPrfU5oGCChnyxsNFk/7TSxmr9qXfYUTGb0Cmny5DTBWdTEu1S/KCb+E7n3/Gsj8e/dyEuIlQYhbenNNf6+RoVGNMLOwhejdlFi7CRFhngEMpN+aLfPWJOPtGUk2yUM2MPktrXEgbAkBKvCFdjFvE7l1MoLLDZsjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+jvp04df0e8lrVmt+e+XczEGOpFN6f7zP6bMlipNjCo=;
 b=EhzYICq9GvM/NQIRkXt/l1nVvA7HHoBG8S0QhZBXd7DJtHW36ltd4YU0/YdPsCci83jvuu5RvgqtGRcd+i3Nej9uiOOiI4E91dc1RUl72tzzlO2AV8DheHwESFMXhwDGncN3V23aM1XPYEm+5AsKbwKh6YZU98h4/bsNqL5Y4wkbr9PP/Ml1NUL+ttRV93cEeZvPmBPr9NOEgQtLV7R/2Az+w1cVHQ+VnOsVOS+R5Afzq4NvouN1OsPxQ3g7GdpGYm0A5K2WnF1SBGqfWChtrYX0KAYl2oJbW8F/4cXnnuZwlvxZ6/RPWyb5tJp4kwFCUPGonZ46Bm1uTnbzcWi8eQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+jvp04df0e8lrVmt+e+XczEGOpFN6f7zP6bMlipNjCo=;
 b=MlHcYV8N4LoSYbOiu5OF6Mpdid8k7alkRzA23Ga05NGNr0geYMVG54Yj3K4GtKjfI4NB0C99m6aNyLAo/TUGweGF/bIem9GhU1MiPbi342cOcWvlnvXPbJIQRekGjY3CkkyLx6xnNSUpPtF23/D7xQk0aOs7yrhrsy598IZtGD4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 DS0PR12MB7510.namprd12.prod.outlook.com (2603:10b6:8:132::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8272.13; Tue, 17 Dec 2024 06:12:46 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%6]) with mapi id 15.20.8251.015; Tue, 17 Dec 2024
 06:12:46 +0000
Message-ID: <471595e4-0f05-43af-8766-eca5399d05b1@amd.com>
Date: Tue, 17 Dec 2024 11:42:36 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 03/13] x86/sev: Add Secure TSC support for SNP guests
To: Tom Lendacky <thomas.lendacky@amd.com>, linux-kernel@vger.kernel.org,
 bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
Cc: mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
 pgonda@google.com, seanjc@google.com, pbonzini@redhat.com
References: <20241203090045.942078-1-nikunj@amd.com>
 <20241203090045.942078-4-nikunj@amd.com>
 <bad7406d-4a0b-d871-cc02-3ffb9e9185ba@amd.com>
Content-Language: en-US
From: Nikunj A Dadhania <nikunj@amd.com>
In-Reply-To: <bad7406d-4a0b-d871-cc02-3ffb9e9185ba@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0118.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:96::19) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|DS0PR12MB7510:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ae390bb-f465-4a17-b509-08dd1e61d337
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YWtyRVNTV294NWJMTkNrVmJjRWNXT1p0WVQvdmlqaURaeThDdDhnOWxiUUtQ?=
 =?utf-8?B?MnFoeFBTMi9ZT1RsYWJ5QXB0bFJKN3JPWHU5d0lvNXFOK0Q2eWxuS3laNDRi?=
 =?utf-8?B?UlVGZkZpbTdjZS95eW94MkNUeXl1YUI1dkRDVGtPaFREdWZPWUZ1OVVKMDlB?=
 =?utf-8?B?cW1KRmRYcGNRdGVzVTJYOTY4c2hyTWpaay9XNzZjdjBuTUFiR1AxZ1BnQ2NR?=
 =?utf-8?B?NVNOa1lXV2x0TmdVajRVNEdMNnpHR01hWEFVZTU5K1VsM3RQaldnVmVZVVdM?=
 =?utf-8?B?cVZUc0M4akorMlVrc3hNbEZUWENnSjRocGpBbmZQcHBXZjVId2JTbmlEQ0dI?=
 =?utf-8?B?QUhvdk93RFBUdWV6R0FrZGVPY1pwNDB3bzQ0NFh5eDZ3RkNJOFlWeEV3U2Za?=
 =?utf-8?B?ZzVxRHhEOVZMRzlleWRKbFRUUm1udWxZZXQrRXB0MG0ySDR2VGZUUGZkeHJF?=
 =?utf-8?B?bFFVNTdzeEJlMzU2dTUxS0p2bzJFUlh3cm13cGV6OHhHaVV2NkI3cTBPR2NX?=
 =?utf-8?B?cEJzTHk2MjdSQkNqdXlXaW03elpVZWREV3VaejRvR2pHam1xakpseXBidko1?=
 =?utf-8?B?cGlXZ2VjRzdOeXhVT2VyU2VZZDlPeFh0UXd1WlJ5WnM3UHp2RnRrSU9PWm5W?=
 =?utf-8?B?THF4eTV6a2JscVovZmVOeFpzbHlwYlA1aDI5TzJGRE03T3NmUkM5QU5JWGcy?=
 =?utf-8?B?OFNaeE9JVytWMHMzQmVyM1gwRGtnL1R3dGx1aFpUS0JFbkxoU0JmQzZEUzJE?=
 =?utf-8?B?b1BHRmMyMHVYQzQ1c0RSeHZPQ2VQOHNtY3ZlaXJsMC9Tbm93Y3d6S1E1Unlu?=
 =?utf-8?B?ZkI3c0YwMjh3VGlTSEJEcGhmdGhvUVN2b0RnZlhsSGUxUXFoaCtPMHVURk1k?=
 =?utf-8?B?eDJhaDU2cy90cWt5SkNEakk4bXkxczNBVEN4alNKNXIrcDNPa3lYTWNBa0pn?=
 =?utf-8?B?SldRbGFwcHgrSWNEZlFQVzF2VktnYmJ6eUo5YW56NElzalVkKzcrODhLbEc1?=
 =?utf-8?B?RHJVU1MreC8xdENBZnR3UGFLK0hka1RlcnZ2V2tCOUMzNDdodW1nWStGek45?=
 =?utf-8?B?MEVVS1kwNWN1UnZSelEwVEFZRjl3b3gweWRSSFpoOUhIdTRSbGdoMXBuTGRa?=
 =?utf-8?B?MTA0RXBBdWRZMUZjR3hVMy84Z2pZNU4veEN3NXBsdFNtUnZlbkdpOS9sblN2?=
 =?utf-8?B?Y1dkVmNBTHVmM2RMSnl0a1MzdGhXdHBCdHIrQWxzQ05wMnRhYnJobEhxWkZx?=
 =?utf-8?B?dG55ajl2UTVBOHI3SFJxNEdYRmRNNkZPWk5GZmFVOGR4bm82dE0yVTZhNnZU?=
 =?utf-8?B?SWU5ZVBDSURDT0QvdHhDVVpyV0h3TUFlTkFRZUhtU2ZWYnYraXQ3Vzg2Szk2?=
 =?utf-8?B?anhJemVoUUxscTBFdHFRdklTcFdlRmRJVGxoNm5KcDBPZUFBdkZJaFJTSFZK?=
 =?utf-8?B?ZTdubzE3YlZBcjY4Sjk4cktLRDA0YkxuYmlTamVRdW55SEFyZkRYWk1KOXp0?=
 =?utf-8?B?Mm1OTVBST1lLV1g1aUVjUTJyV0hIN2F3UG9lTW5KTlJBQklqcmpwU3NlbEdT?=
 =?utf-8?B?NTliOG85MVV5REJ5TjJSNUpGMlpRdHBVVkV1NklqTTRzOEFlZ2IwbUM3a2VY?=
 =?utf-8?B?bzFSWFJWQS80N2xXNmRYMFloUE81U3NFWTc3aVdsYmVnZEpmbGZZcWVSM2s1?=
 =?utf-8?B?Z3FIcjJlWVdZV0JscXVvb3VLUlFPK2VuQm9oZ3Q0TlUwdnZWZGczYjFWWFow?=
 =?utf-8?B?N25rYzFtM0crSDF4STZwU1BDdm5LQmg3WERQc1pkNWl4VW9mcDg3cFUwc09a?=
 =?utf-8?B?bm1IUjlsK3FzUVQ4cVpYakd1Z1dhUkg5ZHNUT29BWEJXcHlPNmxYa2FwOW13?=
 =?utf-8?Q?IR4EtiOJ/p0eU?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?azFpc1F6RzJmL3JNeTRiRUJEcGtWcDUzd1pqV3NoTWRzNjFKQmpOUWRKN0Zq?=
 =?utf-8?B?clV4Nno1Z0pZUC93djQ5dmlqS1RXZzZEQnk2ZnRUQUhXK29STXJSTjdhQXl5?=
 =?utf-8?B?a3hjblk4NXltOVRQQkdDSHVRNWlvMDdocEpUQ0d1YXZsaWF5WDFEQUhiNTZY?=
 =?utf-8?B?U004QkZsblFIdStSbldLMVhlUDBWbDZVZlBaeU0rVmtFZTdtN0hQL0pvYzl0?=
 =?utf-8?B?T2p4MmZNRUNBWm8za1p6VnZQS2ttOHhaTGxHb1JkODN6UUdRNk9jV04xVGVJ?=
 =?utf-8?B?c2lMemlIQkQzYlJRNmV0Tm8yN3RqNnhuQ0pmR0ZKcmJ0ZFFTZTdob3h5NUxJ?=
 =?utf-8?B?RytGTUQ3d1hldkp3TWFiTklsK3NRYkttM2lkU2tUMWNUMEhPL1gyUzAzSE81?=
 =?utf-8?B?cCs4VnZGd2dMZTVyWFB0QkMzSVR2c2J6dWtaUm9Ec29JU3U4VXFaRHd3NTdE?=
 =?utf-8?B?TEMzeGlTM2gxSFZWclAyZTlpWUhKbXkwR1YzTTkzazNwN2tHK0wyM1pFeFE4?=
 =?utf-8?B?amhmOXN4QXVGcTNrSkpTNnJWbnVTMFlNNWJRYmYxd0JXMnRPZlFXS2ZENjJl?=
 =?utf-8?B?Wit0MDBHaVl3SVJ3ak41N0hkRDJ0aFI4ZmRtQUlrUHdLMThxVmJseFcvUnJQ?=
 =?utf-8?B?S2orb3FnQTJXdG9iSUc1Vi9oNVcveE9lb1k0cU4vRHh3U3VicUtSbEVHQ3Rn?=
 =?utf-8?B?eG5IeTBYWkpzOEtPU1dBbkFhZnhxTC9mMGNCQitmbnF6aC9BQVdLUDJ3V0lL?=
 =?utf-8?B?b25qUUJDWWpMeUtrSjFMVFBFbHJ1c1d4TFp6WGJCQmZRMEw1alFvbGxqUGh5?=
 =?utf-8?B?L1FMQWcwRDhMbjBVR0pZMTY5RGhUanFMMFNTWXlKL3BHam5TMjVkaGtNTEhM?=
 =?utf-8?B?UE0wcjBTWGVnWFlvS1VQQVJEQUVWbWpEZDBUNFNpNnBmSDNDVDIxcmV4aHZQ?=
 =?utf-8?B?eDA4OWtITHlhUlFGdXlTRTVuTHA0UERwOVlZcG9PQmpPdlVta0EzdUZxWUdn?=
 =?utf-8?B?ZFlZdmFNVTNVL0tqTm9VNVZZSE9NNzhybHFXTHFKZHNFZnJSMTVjdEwxRTM1?=
 =?utf-8?B?NUE3L0VTZXN6QlJDczU3VjdKS2poMVhLTWxaaUxyWWtmMFQ4VG1NQlpPbTdY?=
 =?utf-8?B?T0JpN2kydWZNM2EwZG1jZkxXbG94M1kraFY2MUNEOFZtTG9MVWRkckxVM292?=
 =?utf-8?B?MitiOTM0UUdXM1hRQ1IxcFM0NEtTMVk5U3pDOHQxdmRwUE0xVzNtRlNPc1F5?=
 =?utf-8?B?S2E4ck43MzZBa05jb0NzK1FJY29hMDFWcXJScDdwaDc4VXpjbVNHNkRFR2lX?=
 =?utf-8?B?bi9DUndrY0tRWWJBZFdRMHRsZEwzdEdacThqSzEvdm5BQUl5akp6dEZDVTFl?=
 =?utf-8?B?dG5ZRTNBVi9Odlorbk9aNS9Rc2tteXZNSk4yTm42TzI4ZU1NeTNDWkRCUWZx?=
 =?utf-8?B?S0NDNmNoUXdjdld3L3pncW5oOE1VeHBEZFZuZ0Nxay92TTVZNExHWG4zTW83?=
 =?utf-8?B?aTlTdUxIRGdzZFhHVmg4bFBzUmJDMy91c20zMk9zMnR1dFJoTnFpWk5aeTd0?=
 =?utf-8?B?Tk0vMHpGMUtSazA5YUc5eGNhaEVjcnBCRGdZQ21EL24vdVRlZU1iY0RjSHc5?=
 =?utf-8?B?TWg1bWpudlVuOFZqWjd3d0VQenYxSVE5OHZqa0NwcWwzRmxNRi8rL2dNSDJW?=
 =?utf-8?B?b3pBcFhnd3lYZWZMUDV2N2tWR3JZMTUrZFFLemJaQmpNUVBnNG9WNHRIN3Mz?=
 =?utf-8?B?UGtHaFJLRU5rTWk3akVKbnVzK1Jub0pqQnNHaHdrV2UwNEZJS2ViZlBXa3Nr?=
 =?utf-8?B?SlY3TVMxQkZvK08rQ3JPUmlaWnZJM05NcGRVb0JPdnlYdXRPK1Iwdit1dVZn?=
 =?utf-8?B?UTBWK2xkSHNJYW9PSFl4SDhjNy85NCtFdU5wZG5oSnRVa09ncWhYWDJlUjlk?=
 =?utf-8?B?dFZ5c2VZdEhONnZudG15MVZ3WCtaQ01GenpjcStkOVdMRmg4MTNTU2xLenMw?=
 =?utf-8?B?QjUzUkNVaWJiRlZnQnNFM3FjbGNVbnRkRnRkVmZrSlhESElMSDhzSWlKM0po?=
 =?utf-8?B?WFRLWlFPaFFqc0RBMjFBQlIwU3Y1ZWNLS01Ea3RDalFoMDJZQ055S2hHN0Nl?=
 =?utf-8?Q?MyzjGEPu0lzwL7ZDHd4jKcHMw?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ae390bb-f465-4a17-b509-08dd1e61d337
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2024 06:12:46.4879
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k6qsru3wKLKmyF1iEEZK29HzfIdt2ZyF0fZjoUZRRsQTCXZgUbKSb6hc9PKtNgky7+uMRsCFT7jXK79/dE0Haw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7510

On 12/16/2024 9:36 PM, Tom Lendacky wrote:
> On 12/3/24 03:00, Nikunj A Dadhania wrote:
>> Add support for Secure TSC in SNP-enabled guests. Secure TSC allows guests
>> to securely use RDTSC/RDTSCP instructions, ensuring that the parameters
>> used cannot be altered by the hypervisor once the guest is launched.
>>
>> Secure TSC-enabled guests need to query TSC information from the AMD
>> Security Processor. This communication channel is encrypted between the AMD
>> Security Processor and the guest, with the hypervisor acting merely as a
>> conduit to deliver the guest messages to the AMD Security Processor. Each
>> message is protected with AEAD (AES-256 GCM).
>>
>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
>> Tested-by: Peter Gonda <pgonda@google.com>
>> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
> 
> Just some minor nits if you have to respin...

Yes, I will be spinning a new version.

> 
>> ---
>>  arch/x86/include/asm/sev-common.h |   1 +
>>  arch/x86/include/asm/sev.h        |  22 ++++++
>>  arch/x86/include/asm/svm.h        |   6 +-
>>  include/linux/cc_platform.h       |   8 +++
>>  arch/x86/coco/core.c              |   3 +
>>  arch/x86/coco/sev/core.c          | 116 ++++++++++++++++++++++++++++++
>>  arch/x86/mm/mem_encrypt.c         |   2 +
>>  7 files changed, 156 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
>> index 50f5666938c0..6ef92432a5ce 100644
>> --- a/arch/x86/include/asm/sev-common.h
>> +++ b/arch/x86/include/asm/sev-common.h
>> @@ -206,6 +206,7 @@ struct snp_psc_desc {
>>  #define GHCB_TERM_NO_SVSM		7	/* SVSM is not advertised in the secrets page */
>>  #define GHCB_TERM_SVSM_VMPL0		8	/* SVSM is present but has set VMPL to 0 */
>>  #define GHCB_TERM_SVSM_CAA		9	/* SVSM is present but CAA is not page aligned */
>> +#define GHCB_TERM_SECURE_TSC		10	/* Secure TSC initialization failed */
>>  
>>  #define GHCB_RESP_CODE(v)		((v) & GHCB_MSR_INFO_MASK)
>>  
>> diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
>> index 53f3048f484e..9fd02efef08e 100644
>> --- a/arch/x86/include/asm/sev.h
>> +++ b/arch/x86/include/asm/sev.h
>> @@ -146,6 +146,9 @@ enum msg_type {
>>  	SNP_MSG_VMRK_REQ,
>>  	SNP_MSG_VMRK_RSP,
>>  
>> +	SNP_MSG_TSC_INFO_REQ = 17,
>> +	SNP_MSG_TSC_INFO_RSP,
>> +
>>  	SNP_MSG_TYPE_MAX
>>  };
>>  
>> @@ -174,6 +177,22 @@ struct snp_guest_msg {
>>  	u8 payload[PAGE_SIZE - sizeof(struct snp_guest_msg_hdr)];
>>  } __packed;
>>  
>> +#define SNP_TSC_INFO_REQ_SZ	128
>> +#define SNP_TSC_INFO_RESP_SZ	128
>> +
>> +struct snp_tsc_info_req {
>> +	u8 rsvd[SNP_TSC_INFO_REQ_SZ];
>> +} __packed;
>> +
>> +struct snp_tsc_info_resp {
>> +	u32 status;
>> +	u32 rsvd1;
>> +	u64 tsc_scale;
>> +	u64 tsc_offset;
>> +	u32 tsc_factor;
>> +	u8 rsvd2[100];
>> +} __packed;
>> +
>>  struct snp_guest_req {
>>  	void *req_buf;
>>  	size_t req_sz;
>> @@ -473,6 +492,8 @@ void snp_msg_free(struct snp_msg_desc *mdesc);
>>  int snp_send_guest_request(struct snp_msg_desc *mdesc, struct snp_guest_req *req,
>>  			   struct snp_guest_request_ioctl *rio);
>>  
>> +void __init snp_secure_tsc_prepare(void);
>> +
>>  #else	/* !CONFIG_AMD_MEM_ENCRYPT */
>>  
>>  #define snp_vmpl 0
>> @@ -514,6 +535,7 @@ static inline struct snp_msg_desc *snp_msg_alloc(void) { return NULL; }
>>  static inline void snp_msg_free(struct snp_msg_desc *mdesc) { }
>>  static inline int snp_send_guest_request(struct snp_msg_desc *mdesc, struct snp_guest_req *req,
>>  					 struct snp_guest_request_ioctl *rio) { return -ENODEV; }
>> +static inline void __init snp_secure_tsc_prepare(void) { }
>>  
>>  #endif	/* CONFIG_AMD_MEM_ENCRYPT */
>>  
>> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
>> index 2b59b9951c90..92e18798f197 100644
>> --- a/arch/x86/include/asm/svm.h
>> +++ b/arch/x86/include/asm/svm.h
>> @@ -417,7 +417,9 @@ struct sev_es_save_area {
>>  	u8 reserved_0x298[80];
>>  	u32 pkru;
>>  	u32 tsc_aux;
>> -	u8 reserved_0x2f0[24];
>> +	u64 tsc_scale;
>> +	u64 tsc_offset;
>> +	u8 reserved_0x300[8];
>>  	u64 rcx;
>>  	u64 rdx;
>>  	u64 rbx;
>> @@ -564,7 +566,7 @@ static inline void __unused_size_checks(void)
>>  	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x1c0);
>>  	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x248);
>>  	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x298);
>> -	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x2f0);
>> +	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x300);
>>  	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x320);
>>  	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x380);
>>  	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x3f0);
>> diff --git a/include/linux/cc_platform.h b/include/linux/cc_platform.h
>> index caa4b4430634..cb7103dc124f 100644
>> --- a/include/linux/cc_platform.h
>> +++ b/include/linux/cc_platform.h
>> @@ -88,6 +88,14 @@ enum cc_attr {
>>  	 * enabled to run SEV-SNP guests.
>>  	 */
>>  	CC_ATTR_HOST_SEV_SNP,
>> +
>> +	/**
>> +	 * @CC_ATTR_GUEST_SNP_SECURE_TSC: SNP Secure TSC is active.
>> +	 *
>> +	 * The platform/OS is running as a guest/virtual machine and actively
>> +	 * using AMD SEV-SNP Secure TSC feature.
>> +	 */
>> +	CC_ATTR_GUEST_SNP_SECURE_TSC,
> 
> Maybe move this up above the host related attribute so that it is grouped
> with the other guest attributes.

Sure

> 
>>  };
>>  
>>  #ifdef CONFIG_ARCH_HAS_CC_PLATFORM
>> diff --git a/arch/x86/coco/core.c b/arch/x86/coco/core.c
>> index 0f81f70aca82..5b9a358a3254 100644
>> --- a/arch/x86/coco/core.c
>> +++ b/arch/x86/coco/core.c
>> @@ -100,6 +100,9 @@ static bool noinstr amd_cc_platform_has(enum cc_attr attr)
>>  	case CC_ATTR_HOST_SEV_SNP:
>>  		return cc_flags.host_sev_snp;
>>  
>> +	case CC_ATTR_GUEST_SNP_SECURE_TSC:
>> +		return sev_status & MSR_AMD64_SNP_SECURE_TSC;
>> +
> 
> Ditto here. Move this up above the host check.

Ack.

> 
> Also, should this be:
> 
> 	return (sev_status & MSR_AMD64_SEV_SNP_ENABLED) &&
> 	       (sev_status & MSR_AMD64_SNP_SECURE_TSC);
> 
> ?

Yes, we can do this and the below mentioned change.

>>  	default:
>>  		return false;
>>  	}
>> diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
>> index a61898c7f114..39683101b526 100644
>> --- a/arch/x86/coco/sev/core.c
>> +++ b/arch/x86/coco/sev/core.c
>> @@ -96,6 +96,14 @@ static u64 sev_hv_features __ro_after_init;
>>  /* Secrets page physical address from the CC blob */
>>  static u64 secrets_pa __ro_after_init;
>>  
>> +/*
>> + * For Secure TSC guests, the BP fetches TSC_INFO using SNP guest messaging and
>> + * initializes snp_tsc_scale and snp_tsc_offset. These values are replicated
>> + * across the APs VMSA fields (TSC_SCALE and TSC_OFFSET).
>> + */
>> +static u64 snp_tsc_scale __ro_after_init;
>> +static u64 snp_tsc_offset __ro_after_init;
>> +
>>  /* #VC handler runtime per-CPU data */
>>  struct sev_es_runtime_data {
>>  	struct ghcb ghcb_page;
>> @@ -1277,6 +1285,12 @@ static int wakeup_cpu_via_vmgexit(u32 apic_id, unsigned long start_ip)
>>  	vmsa->vmpl		= snp_vmpl;
>>  	vmsa->sev_features	= sev_status >> 2;
>>  
>> +	/* Populate AP's TSC scale/offset to get accurate TSC values. */
>> +	if (cc_platform_has(CC_ATTR_GUEST_SNP_SECURE_TSC)) {
>> +		vmsa->tsc_scale = snp_tsc_scale;
>> +		vmsa->tsc_offset = snp_tsc_offset;
>> +	}
>> +
>>  	/* Switch the page over to a VMSA page now that it is initialized */
>>  	ret = snp_set_vmsa(vmsa, caa, apic_id, true);
>>  	if (ret) {
>> @@ -3127,3 +3141,105 @@ int snp_send_guest_request(struct snp_msg_desc *mdesc, struct snp_guest_req *req
>>  }
>>  EXPORT_SYMBOL_GPL(snp_send_guest_request);
>>  
>> +static int __init snp_get_tsc_info(void)
>> +{
>> +	struct snp_guest_request_ioctl *rio;
>> +	struct snp_tsc_info_resp *tsc_resp;
>> +	struct snp_tsc_info_req *tsc_req;
>> +	struct snp_msg_desc *mdesc;
>> +	struct snp_guest_req *req;
>> +	unsigned char *buf;
>> +	int rc = -ENOMEM;
>> +
>> +	tsc_req = kzalloc(sizeof(*tsc_req), GFP_KERNEL);
>> +	if (!tsc_req)
>> +		return rc;
>> +
>> +	tsc_resp = kzalloc(sizeof(*tsc_resp), GFP_KERNEL);
>> +	if (!tsc_resp)
>> +		goto e_free_tsc_req;
>> +
>> +	req = kzalloc(sizeof(*req), GFP_KERNEL);
>> +	if (!req)
>> +		goto e_free_tsc_resp;
>> +
>> +	rio = kzalloc(sizeof(*rio), GFP_KERNEL);
>> +	if (!rio)
>> +		goto e_free_req;
>> +
>> +	/*
>> +	 * The intermediate response buffer is used while decrypting the
>> +	 * response payload. Make sure that it has enough space to cover
>> +	 * the authtag.
>> +	 */
>> +	buf = kzalloc(SNP_TSC_INFO_RESP_SZ + AUTHTAG_LEN, GFP_KERNEL);
>> +	if (!buf)
>> +		goto e_free_rio;
>> +
>> +	mdesc = snp_msg_alloc();
>> +	if (IS_ERR_OR_NULL(mdesc))
>> +		goto e_free_buf;
>> +
>> +	rc = snp_msg_init(mdesc, snp_vmpl);
>> +	if (rc)
>> +		goto e_free_mdesc;
>> +
>> +	req->msg_version = MSG_HDR_VER;
>> +	req->msg_type = SNP_MSG_TSC_INFO_REQ;
>> +	req->vmpck_id = snp_vmpl;
>> +	req->req_buf = tsc_req;
>> +	req->req_sz = sizeof(*tsc_req);
>> +	req->resp_buf = buf;
>> +	req->resp_sz = sizeof(*tsc_resp) + AUTHTAG_LEN;
>> +	req->exit_code = SVM_VMGEXIT_GUEST_REQUEST;
>> +
>> +	rc = snp_send_guest_request(mdesc, req, rio);
>> +	if (rc)
>> +		goto e_request;
>> +
>> +	memcpy(tsc_resp, buf, sizeof(*tsc_resp));
>> +	pr_debug("%s: response status 0x%x scale 0x%llx offset 0x%llx factor 0x%x\n",
>> +		 __func__, tsc_resp->status, tsc_resp->tsc_scale, tsc_resp->tsc_offset,
>> +		 tsc_resp->tsc_factor);
>> +
>> +	if (tsc_resp->status == 0) {
>> +		snp_tsc_scale = tsc_resp->tsc_scale;
>> +		snp_tsc_offset = tsc_resp->tsc_offset;
>> +	} else {
>> +		pr_err("Failed to get TSC info, response status 0x%x\n", tsc_resp->status);
>> +		rc = -EIO;
>> +	}
>> +
>> +e_request:
>> +	/* The response buffer contains sensitive data, explicitly clear it. */
>> +	memzero_explicit(buf, sizeof(buf));
>> +	memzero_explicit(tsc_resp, sizeof(*tsc_resp));
>> +e_free_mdesc:
>> +	snp_msg_free(mdesc);
>> +e_free_buf:
>> +	kfree(buf);
>> +e_free_rio:
>> +	kfree(rio);
>> +e_free_req:
>> +	kfree(req);
>> + e_free_tsc_resp:
>> +	kfree(tsc_resp);
>> +e_free_tsc_req:
>> +	kfree(tsc_req);
>> +
>> +	return rc;
>> +}
>> +
>> +void __init snp_secure_tsc_prepare(void)
>> +{
>> +	if (!cc_platform_has(CC_ATTR_GUEST_SEV_SNP) ||
>> +	    !cc_platform_has(CC_ATTR_GUEST_SNP_SECURE_TSC))
> 
> If you make the change above, you only need to check for SNP_SECURE_TSC.

Ack

Regards
Nikunj

