Return-Path: <kvm+bounces-25704-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 084D2969342
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 07:44:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 80062284879
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 05:44:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 762801CE71A;
	Tue,  3 Sep 2024 05:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="x5w2pcwb"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2059.outbound.protection.outlook.com [40.107.236.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9B4219C54B
	for <kvm@vger.kernel.org>; Tue,  3 Sep 2024 05:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725342239; cv=fail; b=fMG5JxsqAwsj/TKBXJ/oPuU2AJXA/2B+Rx6VOdIpMX756joaKvjAvK+46ube+q2cyMPkxMhn6Aiv5VJUjatpblyriKbaF5K8H+nyT95EQ60znohOhqFQ4Glyw/6MrrK3CGAm7ObKS3WIgtbb9wH5TzCxET8qHtQQjccnLE8nn/o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725342239; c=relaxed/simple;
	bh=cm78/pIhmoVpnlGgq3ZooT9YUTEsWXNLpjzCglwpfh4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=tXISM3ksynXtILEp7+qVUNnDcRfOXkeU55pPQrJbHdg47RwdsFO4Y0rCLYvmNqBJ61XJe1y3z7tTMdrJCQ3IkPo3pvA+nSHxiUAeZu6wEbkka3PPim/MIcjFR3806Ft+LFhqUJzagAJzki+Gy36xq+hDugdYe6BUoQS3Hq/h0Ks=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=x5w2pcwb; arc=fail smtp.client-ip=40.107.236.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Xhbl5hL/ubXagivtxHHLGJ2oUMjP2GsmADfNeG7CC48/q+FrcFBHZ41YmziLdkHJi4sK/9WNLrv7wVAGLB1BdGDxnfSFb+XiU75VG+x2idH0vpLkxRhzpOu6YuOmODM5htDZVYCh2m/QzqLaO/Duj6Cimko9Yt3lbuRpnsAXWXGJ9ufnlOUhbo524NfMRlowT1LgyR7OlLr3pzaTnzO/ElwnswoG/inXduh1MFnXw3dvEjXKEWRbgzftWEsV1L4DkbcMNBbr78IusICp+Fo2lliBUaoXN02yNIcKd2KdBKlzUFacQUA704PYuuiLx4KR4WeNrt9ALabgj+dK7XZYiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tvtG4ATGt1SExlpyuRjqjOXck6MBqyB8cgJVpOGXHps=;
 b=E41jsCCFucvkNzj53UOsUTkojnYC0tIX7MudALhkB185ZnyX06zdLKqQjJcmbrop9F7HfK5EdkcMaQ03T9+zu6smxgHy/NwA7YLzH/cM0pVVAguhVGfGvTL8Rhu0QrWnfsV3cIozUJC0WZEbBR75J/K0e1myr4MajKX8pDCUwQW0DNgZ0UNCQOuyf+bdNepQIdtnhvzoNAFwoSINmN9mV5Jbd5LFZqD2B1lPPIb8UUZFkQ0I+JRsg+3GEqxI/kf8DnuKuyfA2VmjC9jHbiOaAefIwnQAtzyk8sWAqR005+nsDCQQakhZrlqHwG4sjx82ngNkTpcXduTk0zCzjzClmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tvtG4ATGt1SExlpyuRjqjOXck6MBqyB8cgJVpOGXHps=;
 b=x5w2pcwbm1yuUTXu82pZsJ9740gvVpF2dzlRNjxmVPXjCJYnlDqf4LpTCpc+uwjd3spRHt0d/yCaHCsj/g4On57+jfqyab7O227aP0pD7B7qb56eL8cfX8dRbCbfGzSg1jpEv68GNqPH7D4PXjPbPbRzGETwuDXdiotRVyPm4Io=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CY5PR12MB6321.namprd12.prod.outlook.com (2603:10b6:930:22::20)
 by DS7PR12MB6024.namprd12.prod.outlook.com (2603:10b6:8:84::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.25; Tue, 3 Sep
 2024 05:43:54 +0000
Received: from CY5PR12MB6321.namprd12.prod.outlook.com
 ([fe80::62e5:ecc4:ecdc:f9a0]) by CY5PR12MB6321.namprd12.prod.outlook.com
 ([fe80::62e5:ecc4:ecdc:f9a0%7]) with mapi id 15.20.7918.024; Tue, 3 Sep 2024
 05:43:54 +0000
Message-ID: <5239c9b8-a116-1f57-fd8f-8a50d0c2ba89@amd.com>
Date: Tue, 3 Sep 2024 11:13:45 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [RFC PATCH 1/5] x86/cpufeatures: Add SNP Secure TSC
To: Borislav Petkov <bp@alien8.de>
Cc: seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
 thomas.lendacky@amd.com, santosh.shukla@amd.com
References: <20240829053748.8283-1-nikunj@amd.com>
 <20240829053748.8283-2-nikunj@amd.com>
 <20240829132201.GBZtB1-ZHQ8wW9-5fi@fat_crate.local>
 <1bea8191-b0f2-9b22-7e7b-a24d640e47a2@amd.com>
 <20240902164251.GBZtXrC79ZX13-eGqx@fat_crate.local>
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20240902164251.GBZtXrC79ZX13-eGqx@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA0PR01CA0020.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:b8::8) To CY5PR12MB6321.namprd12.prod.outlook.com
 (2603:10b6:930:22::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6321:EE_|DS7PR12MB6024:EE_
X-MS-Office365-Filtering-Correlation-Id: 5cd0ba7e-679c-455a-58be-08dccbdb654f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cENYV2Y1OSt3Qmx6YXBKbnp2dVpicHVFMGtMNEl6VWVXdDNnaUpvY25rSHNn?=
 =?utf-8?B?aG4vRmtnSFNTRUdBWldWYVpEQmd5YzQwQldicEJieWN5Q1pDZmcybzduTmY0?=
 =?utf-8?B?UENtVDE5aGF5bTVjM1hpaVRVMzV6TmNsdC9ENll2MHRud0RqYU5yRDArSzQ3?=
 =?utf-8?B?TXlvRGFBNDJoeUp2d0lmOW5EdGNMSjNVQi9haGVDUG82ZndMYkNXTi80Q1BZ?=
 =?utf-8?B?endibDllQkxQZlNBdTJrS0plbjZOdFFmR2pPVlBJMzQ2TjcyYzduVzl6K090?=
 =?utf-8?B?ditVQnFYZDA4RG9XajRBeVRZSVlPaVBhWjJEWTVnMEhrQ1lXengvelJYN2pS?=
 =?utf-8?B?YkhFQk1xSm9yVzJZMGxPMHRWdGZoN1RrODg1SU5IQ3pVVktYMlZJbTFvQmNK?=
 =?utf-8?B?VmpPdDhvNStYQm91T3lQWjRzQVdrVFpqS3E3NmJMM2xjMFRqZXF6NkszZks4?=
 =?utf-8?B?OHVkS2pFempSb1dtOExNc3QvbTN3eDgwRFVWYkVaNklMZUNTNUhNTGtOQ1V5?=
 =?utf-8?B?MVVrSnIvSThxeHFrYXJJTEUySk5vSyt3SS84dWJvK1ptOUdFb1M2S3VOa0Z2?=
 =?utf-8?B?eCsyZU03a1k4akxTQ2c0VWhSaFhvZkx1aCs4akxhTisrWHNWZE5wcGlFRnIx?=
 =?utf-8?B?eWpSd01JSzBGdnp6T3k3alZyNWF4NkdDWnJaOHZCc1V6RFdhYWxHak5CbTJp?=
 =?utf-8?B?RXZ5M3hYOFBGYVFTdVZsZlMzUkVZWVFFeURVNVZ3NEFPQzhMOXRSazIyMWZB?=
 =?utf-8?B?MDJXSXVWTlRrUmFLN1dhTUY1M2lid1B6dmVMUEpSM29sMVNoMk9MbkM4Vnp4?=
 =?utf-8?B?SytJSGJtbDVnTVNsdStpNEhKK2p3bEd5aWJSOTFCL3Y1YnFLSmsrdmNjNVNK?=
 =?utf-8?B?ZjlXSE1IdGFvV0oxSnNnaWFFc09CMGtFd3J5elhwK1NqRFd2eFhRQi9pS00y?=
 =?utf-8?B?M0pnQjl2QURhVVJtK1pCU2xCUTlyaE9SR1N1Z2FMcE14M3N4bHpHTi9IRElo?=
 =?utf-8?B?Q3RpNnpMNWQ4VE8vREcvMXhwaXFuSmdLZUV5Wm5vQW9ZN256TlZqZTZQTzBw?=
 =?utf-8?B?cDQvaFJmYVFBWit2L2hmVmVmQjgwWWwwekwydmd4OUdvNW9YblZ3eDFEN1Jh?=
 =?utf-8?B?R29raVBmTXI0QWt5d1MxcWRZUURxNnpVTjJZekR0K1lKWk1Pa1VhSi8yV1p0?=
 =?utf-8?B?Tk5NK2NlSzZ4aTdJMDFQYTI3dTFwTHoxcHloL0FPTmdZT3RiYlNKNm53R2hE?=
 =?utf-8?B?VTErdFpFWVJKYVJMUjg1MlRoMGVRNVBZQ1JJR1hXaEphK0NOOURhY1lKZUlr?=
 =?utf-8?B?WTFvV3pMOWQ0aTg5U2tMcjhkR3R4bjQ1eHNGckpiN3RkQW1hejlSQ29iUncz?=
 =?utf-8?B?VUMzMkdiN2YzYUUrSmY5dkRxWU1aYnNuSU0zeVlwTXhKUTliUEp6bXQvZ3lh?=
 =?utf-8?B?dWJvd3ZhN0FIemsxRUtaYm01R0FabU90cE9LeVphOFY1dkN0SUJSa1g2dStF?=
 =?utf-8?B?a2hOM1FiZnBPUS80NEFxMWVMc0FSTjJza0hLbnR1bXJWVlh3NlZhdkRwMWwx?=
 =?utf-8?B?YWo5dXd5OUY1QVJDZFo4bjBVbXc3cEs1OVIydVdsNXRYM1A2RVhJbFJSWGlQ?=
 =?utf-8?B?cXc3MHZNV3NFbVA1NVdnWjJlVWQ3N0F6WjNNUTcvd21xd3h5cnNzMitZT0sy?=
 =?utf-8?B?WExSdHFwV2hSQitVMFE2Z1hwYkdYd3hCT1VQQUhpWFVKM0gvRnRUMWtXSlJK?=
 =?utf-8?B?c0ZOUEtsUlRXbkY5eVpCZDZRR2xhcTdGclZiM3Fycm1rWXYyOVN5RnNaVk5t?=
 =?utf-8?B?MExObVdJODMwb2RuMDRMdz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6321.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZmRVdW9XNDV0L0NFaEZ6amhDNXFMejdCOFkxK3F1SGREUlQ1emRwcGkwUzNR?=
 =?utf-8?B?RWxySk00S0Y0SGVVTXN1RGl5d3R0cnkyelB4UXQrcDRYOUJ2cklDQkJlVXVB?=
 =?utf-8?B?K295TzdmNkd6YWdtTFIwWTRjTnM1T01MTVVIaDlKbHgxZW9UOGd5TjJxblVS?=
 =?utf-8?B?T2IvckIweERDT0Z6bGZ1V0RIMHd6WEd2bnpPdFZ1MkVlMExWZWpyMEU1dmpL?=
 =?utf-8?B?cXV5alh3TzdNTmpOMHNPRmV1QWw1Y0p5NWQ4WG5Va2ZQWjdNNkp5am5xcWhw?=
 =?utf-8?B?VUVCR1hUSDl5N2NOYk84aXROR0Q0MDV2bThiNXNuUENNYlcwc1RPcUxFZjZj?=
 =?utf-8?B?K3p0dEE5a2E3R3N5RU5XaGZVKzk2YkJZT0M1MW11NVh5OTVnR29sYUVOdVMx?=
 =?utf-8?B?M3JpTXhoeTlRNUxQOEwvMG9hMmFhZ0I3dHVkeFFkYThVWXExa09rcVdHVGNI?=
 =?utf-8?B?UVFCNjZJT1B1ekVHbWhBaGFDTlFud0tSa0VWTS84Z056Um9MWnh1cFpzSzJZ?=
 =?utf-8?B?d2dOa3M1WXB3YVdnS0FSejg5dzlBZDRxam41aWhrZW1jQ2VyS2pEUEdPa1ZY?=
 =?utf-8?B?dUFPY3lTbDNXT1lBV1d0UTBRUlFvODU0am9zWTI0OE9KR2lkd3BBK3hTMG9n?=
 =?utf-8?B?aGFxc25HSCtZUFdOc3lkQ2pOWXByUmppTXo5dzhDNE0rajFjaUpheEpxZTRq?=
 =?utf-8?B?RzA4QUhuaDl0QXZwU3Y2WFIzUXU0RmppbHJ6aXBuSmpQSjg2cllacGVoZTZJ?=
 =?utf-8?B?WTVuWUZCWXVqUTNEUHlRSnZVTURvNzB1UU1UMmE0Vm1vS0ExZHh6RXBkN3lp?=
 =?utf-8?B?cmtOR0xIYlJGbmhOVlRBbWsyeDd4UnRDSGo4eVJqc1JxNU45a1JURjRLSlFH?=
 =?utf-8?B?Q2FISlpzUDhzdU9FTG1GaVoyNXdqY3BWZnlvUnJKTitpaGpWVW81Um0rVS9v?=
 =?utf-8?B?TlVaVWpmOUdIcWRPVzU5TlZQY2NDZ1hPZUhSQlE4MDhtWDRYcDBBODErYXph?=
 =?utf-8?B?VnM0cXprZGdMK0s4cit1VldjQ2VkYzhNV3EzdkJHNUtLY3FoVjdMNDRqem5k?=
 =?utf-8?B?eFZnOHdHV2REQ0ZsSHRFcGU4UjB2b1g2dkN4czErZ1JKcjhpT2I2Wk91Tjh1?=
 =?utf-8?B?L3Y4eW01djhiVEZNdGZweDNIaTV1clVzeGplam9SNlVpcys2WEtZWTh1bThk?=
 =?utf-8?B?MUdBZ3pxSlY5M1V4ZGkzVFdSTkFnb3d5UE5XRGhMR1ZQM2ZQQ0I5TjJ5WUVa?=
 =?utf-8?B?d0I4eUMrNE9kVnNHZ3pYV2JIb2JnSUZEUjNyZnNSNitWeDF1VUpUekdRN0Fo?=
 =?utf-8?B?UmZuemhaMkxQanJjTXZjSERrVzdPYVUrbS9pbEVRSC9BTTFCY3hBVTVKN0h5?=
 =?utf-8?B?QzZJL1ZQQ3hveEM4VE1hTUhvdzBLcHNNWGpBTjJ1dWRiVzd5YWM3cXlCQ0Iz?=
 =?utf-8?B?UXp1a0lSaG85amFyL21ROHo0cEJjOE4rakwyL1I2dnE2RDE2RGlJVnk3aGoy?=
 =?utf-8?B?SmtZS09KUjdTck5HZXl5V1F6S2hlM3BhUEdIUVZuVUU1RUFlWTZZWVFETWt5?=
 =?utf-8?B?ZzkzNitKQ0JYcVh4MFRxZUJTMnBmdHRCWi81ZkoybGxQbDJvdDdIbVBCQzRZ?=
 =?utf-8?B?NkxrS1NTUTRZWE5Cd3ZVQzNja3NYbkd1U0JNZWwwbERFd0p6Ry9Sc0pKRVJ0?=
 =?utf-8?B?QzlwNm9UWllCZCtSUmxlUWZwUVIweFlKQnNUR3BuUWpwaGdXQzVESnh2QXZQ?=
 =?utf-8?B?WGJ2OEpPcTMrQnFFbEZNMHFQNzZmVHNjZE42OXpMTXVXL2t6YnVJNG5Ramww?=
 =?utf-8?B?ekVkRnRVRFJKenlLUUZTaitib01HclgzUi9HYmlMRnJjcGoxRmJBNllIRGc3?=
 =?utf-8?B?MkdnNTZGcEdhYnUraFNsKzVyRU5NVDFIcmFoRVhjemIrMXhPN3R0NjNOM3hj?=
 =?utf-8?B?VUJab3BOaCtvSHpvV3dQMTZuZEZ0a0k3SjdTTnFVTHRUZWJBTVFieS9yS0Fh?=
 =?utf-8?B?WkM4SzFvUmxxZ2lmZyt6REFKRzNGMUdaWUFUOEY2Q1ZZMnNzTnloenBLUVhy?=
 =?utf-8?B?TlU1RHUvYW1kbHMyUElpYm1menBwQXM2c2pSdVdZT095ZENFd2ZMdUtLMGhD?=
 =?utf-8?Q?gZIiyTRcuQpikKCN/XqXXb1yP?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cd0ba7e-679c-455a-58be-08dccbdb654f
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6321.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2024 05:43:54.1393
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ineNKu2UH55dz37mfeW963n40EDu7WXKuP58gegIavhT9RD+jMHsVdFhIHM3mYFrO5c5xecaiJGcETcBcTowfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6024



On 9/2/2024 10:12 PM, Borislav Petkov wrote:
> On Mon, Sep 02, 2024 at 09:46:57AM +0530, Nikunj A. Dadhania wrote:
>> Ok, do we need to add an entry to tools/arch/x86/kcpuid/cpuid.csv ?
> 
> Already there:

Ah ok, in tip/master

> 0x8000001f,         0,  eax,       8,    secure_tsc             , Secure TSC supported
> ^^^^
> 
> but in general if it is not there, most definitely.
> 
> This list should contain *all* CPUID definitions.

Sure

Regards
Nikunj

