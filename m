Return-Path: <kvm+bounces-40311-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B91EEA561E8
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 08:39:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AB6B27A6CFF
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 07:38:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2D4F1A8F97;
	Fri,  7 Mar 2025 07:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="404+y3My"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2080.outbound.protection.outlook.com [40.107.93.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 135F01A5BA3
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 07:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741333125; cv=fail; b=Xqxl+LuHoL+2yvWvMbrTUdgEvnyIKz3AiS6krvT/IC7kmk5OWBBxJ60q3N99sdmJ8DFlsF9gexqPAxX0ClMiAg3OB+V33px3jUwGmKA638KtBWsyQJW9VQXU8sY674gnq5s1aRVsDF7Tyc7STX6PR/SYqIrK7mEQE9yTtphMn1o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741333125; c=relaxed/simple;
	bh=e2kERrT6Zc/jsxvM1j4z9Ku+iT4W1MXti+vZhIgGAn4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=eFZQx5ddHeYnCX4E/UjrAhfPwUGPgeDEe1wne+iWIO9rnVJDWAM3w7bMmbMYFl4d1qSgxds9BSOI14MK6v41kiUxyTHwmw0hiqEd/89WNzQamlK9cpBBDyiD7R3c/JN99qTgu32i3Rdp5PnUAA19G7cX11rkG63kTL3FtEYnBWI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=404+y3My; arc=fail smtp.client-ip=40.107.93.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OrZDmZgDjPWMfE2KiU9LmADcqxRjskyGcFhXuZVa15Rxir+L/ICrzOuTA6D3cDHI8aRy80f6CWBcjN6CgHbMExwhpsGgAW+EKhBXz4gc+oJtjp21JVfJ5eloyAzgBMuFBphOsfhRwar4gg6+GkGVYoSKLu8hRsPFQzqos2XD0OWHD1E1Ob3jPhL1ONDu9t6fQb84FoOIpPBuoAbbEPOd07zppflY1+q7K3xwqIx6SLua3/r4aljZkMk1NXHRlsR9Gboh6bx9wuePV1OUYw3bZ/Mkar9cNac+tTvn60aknuXtru12HIsSsZ+VXG9uj4j6B8Aq5QrWR2xz6AhNNnkeiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XMFwTROS0mtqdJw2lT8WeRh/t+cN142okO1pavvRtu4=;
 b=EamgK/w4Lt0pJ1En9e5te194dNf55Z9rCuRDKLZO2yZhSAfoEiYfq3IN49eVzmCACocLaNJRMTZYsXE/0O26hvt+drDhtSlpAAKvKlaBoZPN8M3VotadEWSmcDKwIJP5lNWxsFwHJ87oRhyYTOo7Z5lKdRCDOyCjXHUfgjNaZPkvZwMq25H7TeEHGm94iS6qsT4gVmzTh7ob2kPX9t7KOIUMzIzwYRsRlA0idqP1gU5VWa0WFmSGXA0Xb2Xc4dmErrIVxGDl4j0V/m1aFRtm0n17pbRMznAtwEA95I55+3kwI38Rou136SeniiTuB1i60C9B9MDr9ggrRIorAPlQ7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XMFwTROS0mtqdJw2lT8WeRh/t+cN142okO1pavvRtu4=;
 b=404+y3MyNEs8c8V2Nra1iaGw1pSEhiPHOR3JXyJMMXXos0qCP6QuJfWOXJn/mKXDlDMgOD4m3i5FMVlUSfvuf0pcDno/JuBf7EBfaGV/+CaiTBlDzcIxbW5AyTBM0p9G7Dy85Ksdo0vQOhaDNxdf0032loEg7rPrOqm6mD8WYH0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5712.namprd12.prod.outlook.com (2603:10b6:510:1e3::13)
 by CYYPR12MB8731.namprd12.prod.outlook.com (2603:10b6:930:ba::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.19; Fri, 7 Mar
 2025 07:38:40 +0000
Received: from PH7PR12MB5712.namprd12.prod.outlook.com
 ([fe80::2efc:dc9f:3ba8:3291]) by PH7PR12MB5712.namprd12.prod.outlook.com
 ([fe80::2efc:dc9f:3ba8:3291%4]) with mapi id 15.20.8511.017; Fri, 7 Mar 2025
 07:38:40 +0000
Message-ID: <52804bd6-1763-4092-adcc-d4784d04e962@amd.com>
Date: Fri, 7 Mar 2025 13:08:29 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 08/10] target/i386/kvm: reset AMD PMU registers during
 VM reset
To: Dongli Zhang <dongli.zhang@oracle.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org
Cc: pbonzini@redhat.com, zhao1.liu@intel.com, mtosatti@redhat.com,
 babu.moger@amd.com, likexu@tencent.com, like.xu.linux@gmail.com,
 zhenyuw@linux.intel.com, groug@kaod.org, khorenko@virtuozzo.com,
 alexander.ivanov@virtuozzo.com, den@virtuozzo.com,
 davydov-max@yandex-team.ru, xiaoyao.li@intel.com,
 dapeng1.mi@linux.intel.com, joe.jin@oracle.com
References: <20250302220112.17653-1-dongli.zhang@oracle.com>
 <20250302220112.17653-9-dongli.zhang@oracle.com>
Content-Language: en-US
From: Sandipan Das <sandipan.das@amd.com>
In-Reply-To: <20250302220112.17653-9-dongli.zhang@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0176.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:de::18) To PH7PR12MB5712.namprd12.prod.outlook.com
 (2603:10b6:510:1e3::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5712:EE_|CYYPR12MB8731:EE_
X-MS-Office365-Filtering-Correlation-Id: f5342bbf-a8c0-4a9c-1cb0-08dd5d4b1407
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZGs1d0NDRkVtUExWLzE5dW11Vng3YXlZK0Y2Y2pjSGdzK0JCN2Z6TWhaVmJB?=
 =?utf-8?B?aC9wM3VzQWJNNnJVSDh4OUdPSFoxS2oraWFJaTRseU1pVXNWVEpYK2lSRzUr?=
 =?utf-8?B?dlZSeTVacFR6SHFpRTByUTk3c1BScDZCLzBxUzVUbWg5V1N6QkZBUmpRUTlW?=
 =?utf-8?B?VFRVN2ZEVFppdERNZDJtZFpSR3JQM1lMcmt1NnNPUjRQQXhJMVZ1dVYydFJr?=
 =?utf-8?B?dnl5ZHBxdkJzVFpkVmE3NG5VVHFObERBRFRSRWxVaTNLWC90TlBOYjlVUitG?=
 =?utf-8?B?K1FnSDVNQXprUityejB1T216OFJ4S1RVUDVLM0RIYzAvcVpVZ2sxQzNGWUpy?=
 =?utf-8?B?Q1R4djRHcUV6eVErOVlzcmgvdzRNeW9vVzZBT0lvdjdhTmVROE5MRUROc3pS?=
 =?utf-8?B?UEFKNXRSaVBHZWZyTnIvNDF6TlZoZWNlUG8rU2tRNlJkNGt1KzZBc0lIOVhq?=
 =?utf-8?B?aEN1RkdVdjdIei94amZoRERxZDFvZVZlYXdYMWxIOVpyS0VveGI4SmY3RndR?=
 =?utf-8?B?WmNsYjJrYmdXa0FxWGhHNGdQQWhHOVkyRE5UTHhOZy8wZXVySEM4SVdLZEdn?=
 =?utf-8?B?TlFXU1p4M2hFeW1hTEdSUzAraGM3NVExclNoL1BOODYxbzRtc3FYNFcwSDYx?=
 =?utf-8?B?ckh2WEhibVFZWTIyOHZyeDY5YVVEcVh4MHZTNFcrR3dwUkpYNERZRXZhU0JQ?=
 =?utf-8?B?UFNLeDNGL3Zod0I1aUkxdllXcFQrS0NvQ1BWTVNuSXBEVmhXVG1CVzJhbFQ0?=
 =?utf-8?B?K3FrVWNvYkdOTjVCYy9jUFkyMXlLcElobHliQzE2WE9senQ0K2V4cGVGRXY4?=
 =?utf-8?B?NDFJVU9zSjNDZDRCREVlVEV5SlFXMWZJMTJXTGJRc2JtclV5LzRDSGNoTDd2?=
 =?utf-8?B?RVJWc1FVQmVmNjhTOUhkUGtjR2lDamJJMGJDTlJMcGVVWFl4bCtLVWwwMzBJ?=
 =?utf-8?B?Q3Z2SnZKRVAvRDEyMGN0dEN6c2N0SEtjc0NneXU2UkdrUEtNckFHKzJ1UjNC?=
 =?utf-8?B?ckMwa0hNYlM3dlBwb0tXZm9JbEVVeU5seTRPdkYvMkRGckdlWW50c1V3RzJG?=
 =?utf-8?B?bzByejNxZ3NaZWhxck5DTW5BMlB2Y0w4TlQwT0NIZ05OZmsyMmVTcDV5c05q?=
 =?utf-8?B?aE5JVFd6Z1M1Uzg0UFl4bkN0SUljRmpzUGJyY2FDbmg0M0RHalU4c281VVZq?=
 =?utf-8?B?UHFPeHFvYXB4KzdwTmhLOVg2bng1Q1RoL2lDeXZTSWwrSXNjeTQ1Q2VRWnNL?=
 =?utf-8?B?YXFIdWk4ZmhHbkRYQ2RjUXZmQkpiRU52cmtjaldFRXZSOXFYWGh2Y3g4NXQ1?=
 =?utf-8?B?Z2hHeTZ5UnJ3NFZGc3hkSjNxaGs2QW5kQ3lNM0xqbkhJckpMand6SE5CNGhI?=
 =?utf-8?B?T0ZMMmRSSUpsTVRDUVFyNlhVdzVtNTVWYUpSM0dhcmtHTmQxcHFDSUxBN3Zr?=
 =?utf-8?B?T0RjN3hCaDd4NDd6N2kvdTFyMTE4b0p4ZDZqamFmclVQRFRHdlYzaThFaG9K?=
 =?utf-8?B?ZUI1aTZzdW9nd01hbzVZaTNGSmpsL1d6bGhoRDNXSGdGeithMEt2WXpOeE55?=
 =?utf-8?B?MTVoMHZpTjdla1FiNXI0OWlFRmlPUE9EYnhRRitoNk1hVzJINjhyOG1JSHJX?=
 =?utf-8?B?VDNsOTVZWEJ0QWwxVXUvaHFWc29GYmVBQkhzeWxWQUhyK3BrYnpHMUdOWkc4?=
 =?utf-8?B?aHo0KzhNRnJmblIvaDJJOUFtVFl0aDhiRk9qaFpESUtMazllZUdYT0dCSVQ5?=
 =?utf-8?B?cGxHeDVKNjhDdGd4N3dKbStZMVljdyt0aE9VZHhKcDVhSFJqS2luRm1TeGRw?=
 =?utf-8?B?NkVUOHlZd0xuaTZQNWhYMnQwZW9vZkpLRFArdnUvZ1E1bmdqRFUzQndoaEFi?=
 =?utf-8?Q?lL5NirvOUrWd0?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5712.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?S0l4SVlaamV4dmQzWGhHaDBvdDlUSit6N1AzVXJnYXYxRVUwU2tBVFFpbXE5?=
 =?utf-8?B?Qm54L3FoWlNzb082YkFaZTZEZVFqR3RWSlllMWd0clpEVUEzUnNPelVNOUxU?=
 =?utf-8?B?NGY3Z3BKQ0tPSldzaWYyeXBYMFNUTWxuVEJHb2tWVm1TNGZ5R0lOUDVlK2JM?=
 =?utf-8?B?cnZPQWxzcTQxTXBHeU1oeXRJVHY0UUszWWM0SFM2b0pkSEpEVjI4MFQzUzBu?=
 =?utf-8?B?d3JSRUcraFd1bEVTY3NCUE5GTzZVS2RLTHhYWXEyY0F3NkJqNFozaUl2QWJv?=
 =?utf-8?B?bHBSaTZncXRObllFejdhbW11KzA2YU5LaW9yZ1VCdE5JTEIvRE43N2EwWWZZ?=
 =?utf-8?B?a2NpRTdGNGllNjFGRVBiV01TVEVTR2xHdzhvNHg2cUo4eUpvMktJelhiRElU?=
 =?utf-8?B?RWRmeWtkWlJQdmI2OVk0TGs1VnpDdkVDL2loT1d2cnZnRHc1RU1naW1sRG1P?=
 =?utf-8?B?RlN1cHZET2dvNnhaaCtmOVF2VjR1ODI1VzJBaHJGU1pLNnUyaHBHaDJhS21z?=
 =?utf-8?B?NHZEZDdXbStXZzdveWtVRTRFWFFUYVlJRTM2cUVpbkRGNFQrREpDeHR0dU53?=
 =?utf-8?B?NWV6SDNEQ0huVjlya2dUVnZWb1pjZzRRTjdOYUpZNmVmZ2VUdXdsTmE5d3lP?=
 =?utf-8?B?YlNMVlFIQXVKRGtaVElrNXJ1b21yczRTWURENXBMU0xjd3M1R3k0bHEwQTcz?=
 =?utf-8?B?N2p4ZWZ0MGM4Z0RobGFoN0lGeXB2L1BXYUdxU3VqcHhrK0dObndQcWoybkV4?=
 =?utf-8?B?ZGx2dUlEeGkrUktrRWhHcWVyTG55RUZJWTEyQmMxNFVQcXpvZmN6SHM4cmQy?=
 =?utf-8?B?cHpwMkhFQTg1N1pvUXdNbXRGbi9HeWZxV3JDQ3VESHl1TGFKeXozajhlNlJo?=
 =?utf-8?B?aTZIZEV4c3E0NXUzTzVjVjBzaS9pa1AyeWpSazdOTE42ZTZscC9MY2J2N0Ru?=
 =?utf-8?B?U1A4UjhjSWcwS0c2dW5EZDNISmMzcDNueHUvc0RGUHNjMHVXSkk2aHBJMnRp?=
 =?utf-8?B?V29tbzdnMUVZMGM0TjR4OHRDdXdSaFVlcWc2dlJJMEpxVms3Y3BISnNjRk9Z?=
 =?utf-8?B?cFUrWDNyc0JVN3ovQ0lER3V0V3dWbDM4bG9BWkJTcWErSFFuSjNPNFdUVHVM?=
 =?utf-8?B?UENQRjNwa05uYnNJNnFTVWg5TUppUS9tdlRwaTlxN1NSTGo3YlhEUTNUQ1li?=
 =?utf-8?B?aHhnNExOK1h0Q2E5bE1IZHZYN1B5bnJzYUtZWVBxRGp6dHlTZzJVTUsvMVV3?=
 =?utf-8?B?SkNzUlZNazVpRjAwakxiN2U0ZU0rZm1yTFRGcVQ5aEJnRGVUQnhTcHo2LzIy?=
 =?utf-8?B?NHNUaEtNSDRXNG92OXUrczRzdi9BYi81R251M0tXM1Q5cCtaK3F3SmR2akZj?=
 =?utf-8?B?MTFCS0xkYXBkcTdDSmhSc0VBdHczZ0ttcXU4OHdnaFk2REx5M1VVbENNeXoy?=
 =?utf-8?B?MXNYcGRsRFp3OFY1T0V0cEhERkJ6QkZkRm5nRHoyNUlhS2xjNS8xbmpCSU9C?=
 =?utf-8?B?REVDdWJnWkdkbGRMREplTDQyVHViSmlnV1dybXFvUGdhSUhaNzlaVU5oUDJs?=
 =?utf-8?B?aEJFL2JhaVdDSCt4NmtyTGlqZnBjLzlRQTN4QisyVjFiT0ZRdWFhT0JzVkJX?=
 =?utf-8?B?QTEwb0VMNmJCNHMydzE0U0x5eEpMY0dnRCtSOE1LOWx2dzN2aHlLYkxRbmlH?=
 =?utf-8?B?L2hTZXhjRFZHZDErZVArS0lMR2hhWVpLcERyVGpUeHM2bFVGb053Q0pmRVdU?=
 =?utf-8?B?ZjFtc29ZekZ4Z2NXKzFTODR5NTEva21WbmV0UjIyeDRvMC9BTGNvVStWTjBq?=
 =?utf-8?B?RWllZGpSSzdVU0pqZlErUDdMZEZ1eGtIb2NXR2IvbFU1Mm05bmhUd0taeUxV?=
 =?utf-8?B?YzVDYlNLWVU2ZERKdzBWMytUVHcvNFkwbDdKdEdzalVNUHJ5S1lIT2Vnb21u?=
 =?utf-8?B?dnJYbi9NMExqRDJHUzNUWEVPaDFiYkRVVFJET28rY3Z2a09keE9Yb0dNNVlP?=
 =?utf-8?B?R0pDWjNvU21sbzFwTytQMG5nSkU2TVU3UDkwR3JFWll5SDEwVHpnM0FPQUlH?=
 =?utf-8?B?Z1dOVXRpczZxZU43aTYzVVpUN3lKSEJSWnMxVFhvMm9tSk4vc3JhUStoZVVr?=
 =?utf-8?Q?vZD31ATYpr+FB/Em8mqswgvfU?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5342bbf-a8c0-4a9c-1cb0-08dd5d4b1407
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5712.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2025 07:38:40.0312
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +1L2W4j3I29ypvZGWiZqz8oFgOlhP9lr6f+kuy92qHCZjz6AE/CFlmxfKLb5CiHyPKZjkNznwJHpY8S8f//fBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8731

On 3/3/2025 3:30 AM, Dongli Zhang wrote:
> QEMU uses the kvm_get_msrs() function to save Intel PMU registers from KVM
> and kvm_put_msrs() to restore them to KVM. However, there is no support for
> AMD PMU registers. Currently, has_pmu_version and num_pmu_gp_counters are
> initialized based on cpuid(0xa), which does not apply to AMD processors.
> For AMD CPUs, prior to PerfMonV2, the number of general-purpose registers
> is determined based on the CPU version.
> 
> To address this issue, we need to add support for AMD PMU registers.
> Without this support, the following problems can arise:
> 
> 1. If the VM is reset (e.g., via QEMU system_reset or VM kdump/kexec) while
> running "perf top", the PMU registers are not disabled properly.
> 
> 2. Despite x86_cpu_reset() resetting many registers to zero, kvm_put_msrs()
> does not handle AMD PMU registers, causing some PMU events to remain
> enabled in KVM.
> 
> 3. The KVM kvm_pmc_speculative_in_use() function consistently returns true,
> preventing the reclamation of these events. Consequently, the
> kvm_pmc->perf_event remains active.
> 
> 4. After a reboot, the VM kernel may report the following error:
> 
> [    0.092011] Performance Events: Fam17h+ core perfctr, Broken BIOS detected, complain to your hardware vendor.
> [    0.092023] [Firmware Bug]: the BIOS has corrupted hw-PMU resources (MSR c0010200 is 530076)
> 
> 5. In the worst case, the active kvm_pmc->perf_event may inject unknown
> NMIs randomly into the VM kernel:
> 
> [...] Uhhuh. NMI received for unknown reason 30 on CPU 0.
> 
> To resolve these issues, we propose resetting AMD PMU registers during the
> VM reset process.
> 
> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
> ---
> Changed since v1:
>   - Modify "MSR_K7_EVNTSEL0 + 3" and "MSR_K7_PERFCTR0 + 3" by using
>     AMD64_NUM_COUNTERS (suggested by Sandipan Das).
>   - Use "AMD64_NUM_COUNTERS_CORE * 2 - 1", not "MSR_F15H_PERF_CTL0 + 0xb".
>     (suggested by Sandipan Das).
>   - Switch back to "-pmu" instead of using a global "pmu-cap-disabled".
>   - Don't initialize PMU info if kvm.enable_pmu=N.
> 
>  target/i386/cpu.h     |   8 ++
>  target/i386/kvm/kvm.c | 173 +++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 177 insertions(+), 4 deletions(-)
> 
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index c67b42d34f..319600672b 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -490,6 +490,14 @@ typedef enum X86Seg {
>  #define MSR_CORE_PERF_GLOBAL_CTRL       0x38f
>  #define MSR_CORE_PERF_GLOBAL_OVF_CTRL   0x390
>  
> +#define MSR_K7_EVNTSEL0                 0xc0010000
> +#define MSR_K7_PERFCTR0                 0xc0010004
> +#define MSR_F15H_PERF_CTL0              0xc0010200
> +#define MSR_F15H_PERF_CTR0              0xc0010201
> +
> +#define AMD64_NUM_COUNTERS              4
> +#define AMD64_NUM_COUNTERS_CORE         6
> +
>  #define MSR_MC0_CTL                     0x400
>  #define MSR_MC0_STATUS                  0x401
>  #define MSR_MC0_ADDR                    0x402
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index efba3ae7a4..d4be8a0d2e 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -2069,7 +2069,7 @@ int kvm_arch_pre_create_vcpu(CPUState *cpu, Error **errp)
>      return 0;
>  }
>  
> -static void kvm_init_pmu_info(CPUX86State *env)
> +static void kvm_init_pmu_info_intel(CPUX86State *env)
>  {
>      uint32_t eax, edx;
>      uint32_t unused;
> @@ -2106,6 +2106,94 @@ static void kvm_init_pmu_info(CPUX86State *env)
>      }
>  }
>  
> +static void kvm_init_pmu_info_amd(CPUX86State *env)
> +{
> +    uint32_t unused;
> +    int64_t family;
> +    uint32_t ecx;
> +
> +    has_pmu_version = 0;
> +
> +    /*
> +     * To determine the CPU family, the following code is derived from
> +     * x86_cpuid_version_get_family().
> +     */
> +    family = (env->cpuid_version >> 8) & 0xf;
> +    if (family == 0xf) {
> +        family += (env->cpuid_version >> 20) & 0xff;
> +    }
> +
> +    /*
> +     * Performance-monitoring supported from K7 and later.
> +     */
> +    if (family < 6) {
> +        return;
> +    }
> +
> +    has_pmu_version = 1;
> +
> +    cpu_x86_cpuid(env, 0x80000001, 0, &unused, &unused, &ecx, &unused);
> +
> +    if (!(ecx & CPUID_EXT3_PERFCORE)) {
> +        num_pmu_gp_counters = AMD64_NUM_COUNTERS;
> +        return;
> +    }
> +
> +    num_pmu_gp_counters = AMD64_NUM_COUNTERS_CORE;
> +}
> +
> +static bool is_same_vendor(CPUX86State *env)
> +{
> +    static uint32_t host_cpuid_vendor1;
> +    static uint32_t host_cpuid_vendor2;
> +    static uint32_t host_cpuid_vendor3;
> +
> +    host_cpuid(0x0, 0, NULL, &host_cpuid_vendor1, &host_cpuid_vendor3,
> +               &host_cpuid_vendor2);
> +
> +    return env->cpuid_vendor1 == host_cpuid_vendor1 &&
> +           env->cpuid_vendor2 == host_cpuid_vendor2 &&
> +           env->cpuid_vendor3 == host_cpuid_vendor3;
> +}
> +
> +static void kvm_init_pmu_info(CPUState *cs)
> +{
> +    X86CPU *cpu = X86_CPU(cs);
> +    CPUX86State *env = &cpu->env;
> +
> +    /*
> +     * The PMU virtualization is disabled by kvm.enable_pmu=N.
> +     */
> +    if (kvm_pmu_disabled) {
> +        return;
> +    }
> +
> +    /*
> +     * It is not supported to virtualize AMD PMU registers on Intel
> +     * processors, nor to virtualize Intel PMU registers on AMD processors.
> +     */
> +    if (!is_same_vendor(env)) {
> +        return;
> +    }
> +
> +    /*
> +     * If KVM_CAP_PMU_CAPABILITY is not supported, there is no way to
> +     * disable the AMD pmu virtualization.
> +     *
> +     * If KVM_CAP_PMU_CAPABILITY is supported !cpu->enable_pmu
> +     * indicates the KVM has already disabled the PMU virtualization.
> +     */
> +    if (has_pmu_cap && !cpu->enable_pmu) {
> +        return;
> +    }
> +
> +    if (IS_INTEL_CPU(env)) {
> +        kvm_init_pmu_info_intel(env);
> +    } else if (IS_AMD_CPU(env)) {
> +        kvm_init_pmu_info_amd(env);
> +    }
> +}
> +
>  int kvm_arch_init_vcpu(CPUState *cs)
>  {
>      struct {
> @@ -2288,7 +2376,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
>      cpuid_i = kvm_x86_build_cpuid(env, cpuid_data.entries, cpuid_i);
>      cpuid_data.cpuid.nent = cpuid_i;
>  
> -    kvm_init_pmu_info(env);
> +    kvm_init_pmu_info(cs);
>  
>      if (((env->cpuid_version >> 8)&0xF) >= 6
>          && (env->features[FEAT_1_EDX] & (CPUID_MCE | CPUID_MCA)) ==
> @@ -4064,7 +4152,7 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
>              kvm_msr_entry_add(cpu, MSR_KVM_POLL_CONTROL, env->poll_control_msr);
>          }
>  
> -        if (has_pmu_version > 0) {
> +        if (IS_INTEL_CPU(env) && has_pmu_version > 0) {
>              if (has_pmu_version > 1) {
>                  /* Stop the counter.  */
>                  kvm_msr_entry_add(cpu, MSR_CORE_PERF_FIXED_CTR_CTRL, 0);
> @@ -4095,6 +4183,38 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
>                                    env->msr_global_ctrl);
>              }
>          }
> +
> +        if (IS_AMD_CPU(env) && has_pmu_version > 0) {
> +            uint32_t sel_base = MSR_K7_EVNTSEL0;
> +            uint32_t ctr_base = MSR_K7_PERFCTR0;
> +            /*
> +             * The address of the next selector or counter register is
> +             * obtained by incrementing the address of the current selector
> +             * or counter register by one.
> +             */
> +            uint32_t step = 1;
> +
> +            /*
> +             * When PERFCORE is enabled, AMD PMU uses a separate set of
> +             * addresses for the selector and counter registers.
> +             * Additionally, the address of the next selector or counter
> +             * register is determined by incrementing the address of the
> +             * current register by two.
> +             */
> +            if (num_pmu_gp_counters == AMD64_NUM_COUNTERS_CORE) {
> +                sel_base = MSR_F15H_PERF_CTL0;
> +                ctr_base = MSR_F15H_PERF_CTR0;
> +                step = 2;
> +            }
> +
> +            for (i = 0; i < num_pmu_gp_counters; i++) {
> +                kvm_msr_entry_add(cpu, ctr_base + i * step,
> +                                  env->msr_gp_counters[i]);
> +                kvm_msr_entry_add(cpu, sel_base + i * step,
> +                                  env->msr_gp_evtsel[i]);
> +            }
> +        }
> +
>          /*
>           * Hyper-V partition-wide MSRs: to avoid clearing them on cpu hot-add,
>           * only sync them to KVM on the first cpu
> @@ -4542,7 +4662,8 @@ static int kvm_get_msrs(X86CPU *cpu)
>      if (env->features[FEAT_KVM] & CPUID_KVM_POLL_CONTROL) {
>          kvm_msr_entry_add(cpu, MSR_KVM_POLL_CONTROL, 1);
>      }
> -    if (has_pmu_version > 0) {
> +
> +    if (IS_INTEL_CPU(env) && has_pmu_version > 0) {
>          if (has_pmu_version > 1) {
>              kvm_msr_entry_add(cpu, MSR_CORE_PERF_FIXED_CTR_CTRL, 0);
>              kvm_msr_entry_add(cpu, MSR_CORE_PERF_GLOBAL_CTRL, 0);
> @@ -4558,6 +4679,35 @@ static int kvm_get_msrs(X86CPU *cpu)
>          }
>      }
>  
> +    if (IS_AMD_CPU(env) && has_pmu_version > 0) {
> +        uint32_t sel_base = MSR_K7_EVNTSEL0;
> +        uint32_t ctr_base = MSR_K7_PERFCTR0;
> +        /*
> +         * The address of the next selector or counter register is
> +         * obtained by incrementing the address of the current selector
> +         * or counter register by one.
> +         */
> +        uint32_t step = 1;
> +
> +        /*
> +         * When PERFCORE is enabled, AMD PMU uses a separate set of
> +         * addresses for the selector and counter registers.
> +         * Additionally, the address of the next selector or counter
> +         * register is determined by incrementing the address of the
> +         * current register by two.
> +         */
> +        if (num_pmu_gp_counters == AMD64_NUM_COUNTERS_CORE) {
> +            sel_base = MSR_F15H_PERF_CTL0;
> +            ctr_base = MSR_F15H_PERF_CTR0;
> +            step = 2;
> +        }
> +
> +        for (i = 0; i < num_pmu_gp_counters; i++) {
> +            kvm_msr_entry_add(cpu, ctr_base + i * step, 0);
> +            kvm_msr_entry_add(cpu, sel_base + i * step, 0);
> +        }
> +    }
> +
>      if (env->mcg_cap) {
>          kvm_msr_entry_add(cpu, MSR_MCG_STATUS, 0);
>          kvm_msr_entry_add(cpu, MSR_MCG_CTL, 0);
> @@ -4869,6 +5019,21 @@ static int kvm_get_msrs(X86CPU *cpu)
>          case MSR_P6_EVNTSEL0 ... MSR_P6_EVNTSEL0 + MAX_GP_COUNTERS - 1:
>              env->msr_gp_evtsel[index - MSR_P6_EVNTSEL0] = msrs[i].data;
>              break;
> +        case MSR_K7_EVNTSEL0 ... MSR_K7_EVNTSEL0 + AMD64_NUM_COUNTERS - 1:
> +            env->msr_gp_evtsel[index - MSR_K7_EVNTSEL0] = msrs[i].data;
> +            break;
> +        case MSR_K7_PERFCTR0 ... MSR_K7_PERFCTR0 + AMD64_NUM_COUNTERS - 1:
> +            env->msr_gp_counters[index - MSR_K7_PERFCTR0] = msrs[i].data;
> +            break;
> +        case MSR_F15H_PERF_CTL0 ...
> +             MSR_F15H_PERF_CTL0 + AMD64_NUM_COUNTERS_CORE * 2 - 1:
> +            index = index - MSR_F15H_PERF_CTL0;
> +            if (index & 0x1) {
> +                env->msr_gp_counters[index] = msrs[i].data;
> +            } else {
> +                env->msr_gp_evtsel[index] = msrs[i].data;
> +            }
> +            break;
>          case HV_X64_MSR_HYPERCALL:
>              env->msr_hv_hypercall = msrs[i].data;
>              break;


Reviewed-by: Sandipan Das <sandipan.das@amd.com>


