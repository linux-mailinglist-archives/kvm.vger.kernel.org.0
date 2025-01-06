Return-Path: <kvm+bounces-34645-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 14A4DA03330
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 00:09:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E5612163957
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 23:09:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5431D1E1C3B;
	Mon,  6 Jan 2025 23:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="NZ5uMTov"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2044.outbound.protection.outlook.com [40.107.93.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE9681DA614;
	Mon,  6 Jan 2025 23:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736204940; cv=fail; b=MYi1LH08/XvDVryI+SXX6SN7hp5/7JxGRFd2XuNmg/XFrLpBwkHhhUb6o8Puips6zeJw8tbITQtz37mo2eW0Vi9nY7Z2e5sdiS3ImSD2uGuNIRfkaywYd+Vovf1l8+AaxJTdQRIHkps/qlJME8eb3KyWl9tRSJ3RUDlSlYsH74E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736204940; c=relaxed/simple;
	bh=QYEZ6f9Xe10t+qR0dIzA/cx4Vq8m9F0EoZMngiiqgDA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Mr3cspKIxR8fWSqZ9DJikaTYrc94ohqr4tgC5FHFM1oGrusa1Sb4/bO6AjyCy8sbvh6n+W80VocoiMYOciSU9RdJWZxyVcTBVPB8pGBlKkXTjLZ5AudmqiLZLzekT7GYKWVV33J9HNkrjJ0ZUw7ZSyQURbMQR/sAYDXS90vACck=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=NZ5uMTov; arc=fail smtp.client-ip=40.107.93.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BhFOWxoxt75KrpHCznwHVuOwN9hQI/Fn+LOA6r4fftYCHs2DaMSCFOBC7OWoSIMHlJrSM8HSYY9A4vrkWZNDCSNjJ6fsWOvCTA+l1KYilEtBqbPFMb/R+8BzknPPLZ3wpxz4qaD8cz4cBwInRJ4gJAlQwBsxpZEmuw6svzX5b0ns1at/i1bLQwTiy8jwmldf1R7lNiBfpGbipjjd9t8CZnGdizkSCfXr2nqhZDVNhG5DOxuIxTf82EUfSqrqYQ1CC32ed2vptkhrRY5ISINagfR0iXgrMcJBVD260xUjDaUAbFwH/oUgPYr9flfsbKi3eZ56dY6aSSFQgo/ChgQh3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wRngzxBQG1TkLnFdfeJepu0SHnjSw3OK9de3NBDA6cA=;
 b=xQiHzNwQdvFX7SEkvuxXZd9MbvOynW/shAdCackNn8we2NI6zsAqByYyvclb13Ba5mMjFrglymBc+4VtpA2ibQLLPutAg91juR25YpmnDRhASKIZMT5PneRjTEeTYjwknlUpoPeUemkIqsUiXJmqAt0hyp/iOa2hncCBaRqYV7SKdg9Eaf2O5fV+/Pv/hLz2O0fdChwLjQeHWyBwFqGIjyXAu7akcznX3+jnZy8yGO3ntRc8tWoPba6kKZn/J3CFkyHR4O/thboy9WfSWbOpZ6SMUIGR42tAbNUC44QxwF658BM3oJ1OudMml76hpJZGal1ln8RBXUrpZ498S6yLiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wRngzxBQG1TkLnFdfeJepu0SHnjSw3OK9de3NBDA6cA=;
 b=NZ5uMTovPTRby9hex+EM1ZpfUigX7DBQ4YcAO/0Qm4DaF3Q+vdSJIgakcq+yhy+rgPm/xUUeZQF8bdHKIsPwM/ck9dT5Y3BD6F7pkrG5v9Z8iWex3raruOiBjDcfQTBi9b8H1lGzuHY2HvBp4fZ7qtbdpcaN/nMlosSwP+cBcgM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by BL3PR12MB6402.namprd12.prod.outlook.com (2603:10b6:208:3b2::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.17; Mon, 6 Jan
 2025 23:08:52 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef%3]) with mapi id 15.20.8314.015; Mon, 6 Jan 2025
 23:08:52 +0000
Message-ID: <d8f5a27d-ae8f-4aec-aa4b-9f4d010e45ae@amd.com>
Date: Mon, 6 Jan 2025 17:08:48 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/7] crypto: ccp: Move dev_info/err messages for
 SEV/SNP initialization
To: Dionna Amalie Glaze <dionnaglaze@google.com>
Cc: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
 hpa@zytor.com, thomas.lendacky@amd.com, john.allen@amd.com,
 herbert@gondor.apana.org.au, davem@davemloft.net, michael.roth@amd.com,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1735931639.git.ashish.kalra@amd.com>
 <707efae1123d13115bd8517324b58c763e9377d8.1735931639.git.ashish.kalra@amd.com>
 <CAAH4kHb6-us9a-GZhXEs2Ah0aQp5YwSniHVvJ=QtuiJF5LTrAA@mail.gmail.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <CAAH4kHb6-us9a-GZhXEs2Ah0aQp5YwSniHVvJ=QtuiJF5LTrAA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN7P220CA0025.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:806:123::30) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|BL3PR12MB6402:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ee64e64-f0dc-47fb-6888-08dd2ea71616
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OW9hdkFZakpOMUEyUWtQemJNVVVWZkxtT2poVWpuYkZNL1hZei9WY0N5NFEx?=
 =?utf-8?B?alJuUndaNEMvR2dMb2liaUZRdlEwcE5lSHhmdFJiQnFwcktHdXZudEJvWURJ?=
 =?utf-8?B?WDU1dm1mVFRZMXZROHZnZU51VitwMVJmNE1qbHUxVGVFdFJLUVcrUEttRTZ3?=
 =?utf-8?B?VHNMc1c4cGgvQjg2K09TTzc2Y2p6NmR1cVdqNkU0b2hnYktPaURBazFMUTZ5?=
 =?utf-8?B?clYyclliazFEcGxGaWFrNUsya3BRTlhjaWtDTjVqZHZ2WXFtK1c5dnBkZTFt?=
 =?utf-8?B?OEJjZzh4Zk40TjJ2S0FpWW9YMzBMdThiRWMreDdmakk0REJ6bmxMZXVJR29i?=
 =?utf-8?B?YmV2L0F6YnVnK09MekM3cldhTmJHOHNRa2U4MUpLZE5taGEvL0ZGaXZTYnk0?=
 =?utf-8?B?VUM5TEQzM25QNldiekd3ZGVsdUZHRzQ0TXpOK0dzd1JLMU11dUI4UUZSK0Nt?=
 =?utf-8?B?LzZlOCt1VjdIN0lRbEdyZnVTNDBYQ3RTR2Z4NEI3UkNwNytpVVNsYjdsa0p2?=
 =?utf-8?B?bTAyYzRqa3NnUTd4WGx4ZDV4MmtOY1l1R2FrNkpTQ2d6eW1hNm05dndwVkFl?=
 =?utf-8?B?a3F3d2hmL0x5Wm82V3prK0oyTHlxVzkvQUFhcjRENlJDYThtN3ZQM1A0Wldy?=
 =?utf-8?B?U0N4blFoNzIrOHBibnlQT0x6Wno2d093eHIzaWRKbWFXbFMwS25wVzl4STV1?=
 =?utf-8?B?dmVIWitoTTRMa0FmL2RicDlUWkFsekpQUXBzb1lkS24xTVFaZldpMmwrUHJ3?=
 =?utf-8?B?SUZ0c3hHZUpUb045UlkycUVac2RLVGtveEZtQ1NKb1QrTmhBbjA2OTZFQThn?=
 =?utf-8?B?QndYRjRpNlJhRWdUVUxROUhsMUZRRGJVbnM4bXBCUVZ4T1JLdWltOG1UcUl5?=
 =?utf-8?B?a3JWM01JaXNPYzE4MForRmFBVUFiaUdqeTRvMVVsdHNmQXgvOXIvRHNjd01s?=
 =?utf-8?B?Y3RqNTVBOUY2Vndyb1loSzBlc2dlTFRsTEhVYzBjU09uaUJSVlI1eGVKcmp0?=
 =?utf-8?B?MzlZc1JqRWpZY0VYV1NTUkZHVVVyck9uejNaT1FZYVQ1NEVNQk9xZ09KMXg1?=
 =?utf-8?B?cUNMUWFFcTVld0NDQStBOXh0cCtuU1A4UWdzWHJkS1lGV09ueHdUWnpVdmZC?=
 =?utf-8?B?Q0EwVjFTby9HcjZlVE1xbHJIb2Z1S0hVSTB2bzZwZW9qWHZRSE1tVU9QOVZU?=
 =?utf-8?B?alNhMlZSRko3aUxMTDREWmY1TElqVTRwcitaOWtENVFDYjNaTFQ2Y0ZOWHBl?=
 =?utf-8?B?bnVib0p2MlFqcmdhOEVCbXc3YTNFV2ErZTRFd1UrSndhV2ZPWG52Ny9vODNn?=
 =?utf-8?B?czM5MXh0aGlvb29qWUpQNnZpanRjcWtBNFl4MGxaRTh0Nm1pSlZaMUJUQTlr?=
 =?utf-8?B?ZExjeVBraGR3bllSbVZXRHBlTklVS3c5YVZuWmdkTVdwMGc4SHgyVTlxdnZx?=
 =?utf-8?B?bDByaU1jVU4reTFPMWpVYlpQVlNGVU0zNDBWOEQ3L0NMbFNrbXViMHhxQk8v?=
 =?utf-8?B?NWd2VHVDVzFBcE5BOWl5RC9IejljUUI2SVVmTXRSanJlRVRPT3gxWjA1RCtl?=
 =?utf-8?B?bGdpM1o2RzJsUjY0bm9tek42cktaV0Zza1lFZGZMUHh6WDlLamhtaDcrNVBK?=
 =?utf-8?B?bWV0WnI4ZTlBKzBGOGdMbkw0cEZqQTV6QTJYTk9SenNVTDZYQlMzR0tvVEN1?=
 =?utf-8?B?bUNyalNjWFhNSXhYTTltamwzTExoZUl3VlBUR0dqZlNBbFZvWjhOc1RXcnlq?=
 =?utf-8?B?ck1IVXExa0w4Nk54VXNMWnBzUzZTaWZiYVBnTU40aU1XOTYzbmE4MzJqRzZC?=
 =?utf-8?B?L3VVNDNpWW9sa1BZQkNZbDFYUFZjU3hBcjNIYW1jTUFFZ1AvSXlhVXhHZTcy?=
 =?utf-8?Q?3l21zEXUMqpyU?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Zk9PMXk0dGgrMUE4aHdGS3RJbzhKRzEzUVB3OVpWaTl6MjlUTDBzSDhQUVZl?=
 =?utf-8?B?Q29XM1NSVHFCRW5qTlc4MTVMNEFVVUNEWGZYbW4yZkpKZHZQcmJ4cE5UaVlN?=
 =?utf-8?B?dFZDRjd4T3hnSDN3ZllvclNGbUJMT0taZ1ZzZHpXMTdBUjlqeEtuamRDdmZP?=
 =?utf-8?B?VW9EcStoMTRIT0owc0RLU2s4YmV5YndLWXZCeGR3R2ZYNFNYMnB5Y2pOa2wy?=
 =?utf-8?B?d0tVZ29TWmw4emtwOExXNGJ6a2JTQTZuZHNKWkFpeGRaQWRFT09VdnRwYVBU?=
 =?utf-8?B?NENXR2g0UmVyL1kxRFErT2xsbHpvNDNlTFFOQTFxajlKMGhLb1NKV21ha1ov?=
 =?utf-8?B?U25oWlpsMWVIa1NTUjgzdWYvZkF6aHdxM3BkTFRiRi81QkZXUUdtd3lyWklU?=
 =?utf-8?B?MDU0NExJVllXbXY3TW9lQzVvQ1lkMjVEYnBsQ0QzemUxYTBKZS9XUEE0aWlD?=
 =?utf-8?B?UXRhdEd2K0xpeFFpaWN6aWJQOUZUVS93dWJSQzFrSi9nKzdXK1EvUUdZK2Fj?=
 =?utf-8?B?a0FzNnFteEg1eWlzZy9LcDBQTGVkTXJiOVV5a3o1Y2JNOTRhQUpoczJkR0pz?=
 =?utf-8?B?N3VMY2FBR0lOUnBjMHIyVk9mUjN0cjI1RzZLUGVid0NmVTduOXo4clZ0ME5j?=
 =?utf-8?B?R0V4YnpMcnA3eGN0VVlNbzdXbnZROVRyOWYwdWh4cDlhY1FIRjRHKzlrdnNO?=
 =?utf-8?B?LzY2bDJZUDRkdWhndUU1cjRESFZoQ3V3d3VkM3lTZlpyNVBWNHVrV2JtRHJk?=
 =?utf-8?B?UXZmUmgzR3VnYXdSNndmVkVncHIrRHNMYzhNSlNscjJMaXZBeUJSeHgwS2xI?=
 =?utf-8?B?SEt2L2lIbEJlaE85eUxIcHVuTlR6VENpWFUzeWlmRkQvOHZycDJMM3pHZm9D?=
 =?utf-8?B?aS9XRFFQSnVkdFlrR2NGZlBEM2VYMTRTUTJXbVpEV2tDL2VRMEFmZlFVeFg0?=
 =?utf-8?B?L01PTnFKMmw0eitsaVhQSG1rQXZRNXJxaFR3MFZ4VndRUjh6YzFSdExXZ05D?=
 =?utf-8?B?cG8vWnVwUTF5bE1va29UNzdjQXRaVWx0eENJUy81MXlLVndERzZWVjhXSUZo?=
 =?utf-8?B?OW1GaEk0cTJEbmRodjhyM2pFQ1d5a3Myc3A4bCtoR08zdi9vZ3dTY0cxWnkr?=
 =?utf-8?B?VTlCRUVkUmwvKy9hUWM2UlJtWVBZSE51WEJPM3kyR3U2Q3YvOGM1VzB0S3Z6?=
 =?utf-8?B?K2NnbGY3bmlyMm9LREJpSTVxNmlJSVlaYnFCK2ltUnZWSkRCaUtuK0lwcGhm?=
 =?utf-8?B?eE9xRXRVZXJLMkg0ZUZ1Y21ndm5zc2d1blQzcHFkdStjMHJaaUJVY2I4SUpn?=
 =?utf-8?B?MnoxVEhzbXFlc1NSa3VoSUJkK2FaSDdMcU5wVE83MlJuV2h6bTcvQzJ6SCto?=
 =?utf-8?B?STd5dk9SbWtvSlFiR0FMcWloemQwU1phcW11blljTUF1bmQvUkF1S3lJOXpR?=
 =?utf-8?B?eDljeXp6RzdWclBrbVlqQlVPTytDMSszUlFCN2t4YlduV3h1YmxrUTJveGMv?=
 =?utf-8?B?cjdMYVl0OEZ3cU45SFk5ODFiR1IwOUdzOHI5RUo1YVk3dmF2T0J5a3E0bDZs?=
 =?utf-8?B?WjU0bHRFRnBWd0xqa25ncG5qdjRGQ0h3ZmFoL3p4M1ZkUCtPK2FQWUl2QitY?=
 =?utf-8?B?MDM2WldCOTBRMmM0T0s4Vk02cElueXcyWjZoeENaMldldWFIUUl6QVduaXRU?=
 =?utf-8?B?eU82RGJKOE1VanRHRFNmL3o0SEc0dFJQVTVGd3Mrcm9YcHlpZUUyemdGU040?=
 =?utf-8?B?MlZmTHlNRi9RdXZBUlJWNGxYZ2h4N25CTE54ZmRPdVRteWRtQ2NFcGh3ak1J?=
 =?utf-8?B?eWRHSWZzZVFIRzVTaFNqemV6ellMb2ZGZ1ZSU08rWEY1Yy9CSm9oVlNhWnhs?=
 =?utf-8?B?bE1hS1IxcW9tK1A4YUorZnlBMkJhNEd5Ny9vdXphQU1pemVPTlh0clVlKzJo?=
 =?utf-8?B?NlRVWjQ4YVN3OU1MWnNXSzJvWVZaNXFLUjVnek41UVNnRlZwaFpkamdQYzFM?=
 =?utf-8?B?bUs5OXBtL1NaSEZxNEVUR0xTYjkremZWTDZCUXl6czltRTIrRjN0bzBkT0p4?=
 =?utf-8?B?azhNbHJBWTU4OU1uL0JSdW5nZHJ3ZFQrd2RmdGtiN290MEpDTElyUnFCT2FC?=
 =?utf-8?Q?e1LHtQv7rAVe8D2VYII0j/XoX?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ee64e64-f0dc-47fb-6888-08dd2ea71616
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2025 23:08:52.3212
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1Vo4JFAt10cBo7fFrGHjv8aDw6Y4WdQu76V8Z6/dj3cFBu55maKSgDVqnpW/nxZzKnVGBgz3RlWjlXQn5gRs+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6402


On 1/6/2025 11:17 AM, Dionna Amalie Glaze wrote:
> On Fri, Jan 3, 2025 at 11:59 AM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
>>
>> From: Ashish Kalra <ashish.kalra@amd.com>
>>
>> Remove dev_info and dev_err messages related to SEV/SNP initialization
> 
> I don't see any "remove" code in this patch.
> 
> 

Actually, the removal code is in the final patch after the platform initialization
stuff has been moved to KVM, and this is more of a pre-patch to move dev_info/dev_err
messages related to SEV/SNP initialization inside __sev_platform_init_locked()
and __sev_snp_init_locked(), so i will drop the remove" from commit message and 
keep only the move description as part of the commit message.

Thanks,
Ashish

