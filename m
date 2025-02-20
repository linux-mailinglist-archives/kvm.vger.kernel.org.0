Return-Path: <kvm+bounces-38691-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 435ECA3DB71
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 14:37:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E772B3BA0FB
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 13:36:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94D0F1F891C;
	Thu, 20 Feb 2025 13:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="R1QeN24W"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2076.outbound.protection.outlook.com [40.107.220.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3C971EEE9;
	Thu, 20 Feb 2025 13:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740058607; cv=fail; b=Crw6yaeegeWGAQfT7MsArWhOhGUp1SeMEk0Xbjf/JNcS/hl7Ym0DvNIK84kaoi2hbqJEMey7qPh8SWCeBjJsX4InK4PfSg47SOJ7WwKywRymW+4a7E1VHaNu57ExsWDkj+AEu87od5+h2HaDWSbyl7QMpjlbj1eJUnm8hd0WLrc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740058607; c=relaxed/simple;
	bh=7T9Sr4mYJeycw8SulyxO9CMwM5j89ZTtb3V3sJbNrh0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=obWOKb+M3kUI+VypS+6w9LC9a0TTEGr4Mhff/DcdCMhEb+i0CBqMDWv81ab0G/sqRDnJnwNQknywI/Z9wHibscWo2Ba5xIW3nLCc6d4HTF+Q67JpXsyPPvqjGmcNDuSOecswsgMS3OSPZHy4yEDYNA1lmvs2+fYZc4liPVT3D+w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=R1QeN24W; arc=fail smtp.client-ip=40.107.220.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d8Bs4P/cpLAgfV90ocGnYVvTdJ/ICa/utgqb6PACEx6lyekWo2yXRYfnFgfRrPb20aR4ghIuDHs1UxXT2lKUCeQRhnGHcQV85rceMZiz6/0lL19xNjWCddNeGeY+6nuHVlfoUZRoF9LsDoxa+ZSon+APZbaJF563SqLH/pVzyR8i7B4b9YueFjNTSAlyAb7QXOcfRFWmDzC9QVNdtZIiu9uLlmiD/9SZcME5jdKQTJPGTgPpPYlqFRwipV9BZcXyJqYItxnGdxhQ5DXjtE76cpGUwDj9BYmpOUrfJHinM7KexKDwWmD0DUnZH1x0kUO0TDrlW/MG1N6E5kpLJodYHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c0/Agik/2G6yPX0QGFo4FuZYEXKHJFLse49vUDAfVvc=;
 b=mvvKV+xPCrZ7qUCunMTfyD2JTtRLqzR5blyP4KwlKlHwiJqQyqK9NGdZ4sXOkvalJsKXS/0pkm5HsxVksPaaIH03PtmtT9mKyMC0R30gGl6igmxCifbkPrD1NbGl9Uv5Tc7nrh6h1GtOBcIwyR4MqzocLy73hHOZBGZmkGmx8J64u2VyLkjvqCDhzh+rbH97Dieoj4EJHpV6poTY1YmVNeelquHdS4dpfSu+bo35/e3C2eRkDJGWarXCgAAjEVtU2mJaMXXSb0X8+UweljPlEg5OHBSEumF+SF0m16CAGaF3wl4qlLqXpnKjAKD+7vLR2mWmY5n1zf7ElKNNGiL63A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c0/Agik/2G6yPX0QGFo4FuZYEXKHJFLse49vUDAfVvc=;
 b=R1QeN24WHsxmtjT+Jhdglufy9Lj7l+e0J3P/Z39alezo/mzmNbQwBsgrK516GcXGeUzOeXscz7ruTuE//RSkdMiw8cnGPfAt6h9oj1qSotSAYsVYAgsy6CMEXl5KjPE4n+RG1O0gnAV07zAmGzy1sUzoNS/qFnfQSO/D3Twj+ZU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA1PR12MB8189.namprd12.prod.outlook.com (2603:10b6:208:3f0::13)
 by CY8PR12MB8267.namprd12.prod.outlook.com (2603:10b6:930:7c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.15; Thu, 20 Feb
 2025 13:36:43 +0000
Received: from IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::193b:bbfd:9894:dc48]) by IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::193b:bbfd:9894:dc48%7]) with mapi id 15.20.8466.015; Thu, 20 Feb 2025
 13:36:42 +0000
Message-ID: <4e6989d1-0ee3-4b87-bc2e-61490b133995@amd.com>
Date: Thu, 20 Feb 2025 14:36:36 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] KVM: SVM: Limit AVIC physical max index based on
 configured max_vcpu_ids
To: "Naveen N Rao (AMD)" <naveen@kernel.org>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Vasant Hegde <vasant.hegde@amd.com>
References: <cover.1740036492.git.naveen@kernel.org>
 <f4c832aef2f1bfb0eae314380171ece4693a67b2.1740036492.git.naveen@kernel.org>
Content-Language: en-US
From: "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <f4c832aef2f1bfb0eae314380171ece4693a67b2.1740036492.git.naveen@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0064.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ce::16) To IA1PR12MB8189.namprd12.prod.outlook.com
 (2603:10b6:208:3f0::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR12MB8189:EE_|CY8PR12MB8267:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ee9bdce-9235-449d-af51-08dd51b39c79
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Titqc2lMdCtjdm92N29Wcnd2RDZpSVBQUVp4eVJaakpVUW5kN1p0V25BTnR3?=
 =?utf-8?B?RndRdkp2YWk5N0hUSjUxOEdTRVpDYTBHc3V4Ni9UUk1jb2ttQ21adDFGVGo2?=
 =?utf-8?B?NitLckU2aUxucHZnUlhiRTBPSVVDZUh0UVpIZ2NTQnArSE5rNlRKelhuVVZP?=
 =?utf-8?B?Y2RTZnVMaU5VMTIvcm5YVmRFOXo3Wk12SkhDUHNjQmN5ekdGcWQvZGI4cnVz?=
 =?utf-8?B?K1pIUGNzZDJDdUdndWgrUW0xbUZ0ektkaktnZ1lDUXd4WDVFaVZwM1FyWEdB?=
 =?utf-8?B?R1BKRkwzQ2JvbEplRENJY0VsdnNxbU9oU2ZRRmltakFxRi9KaGgyR2VwZVd2?=
 =?utf-8?B?MFlodElna29YNTEzd2pJaXkxK3lTaVMyNHplMTMvVDhFcU1KM2JmTUFiSEJZ?=
 =?utf-8?B?SURla25pZDJaMnd6aVpDa3JpY2V3SnByOVp4YkFETUxkUmJIQXRKblFFVEhn?=
 =?utf-8?B?Zml4dU44RSs5Nzh6Y3FaeWxMOUo1c0lHbHdQbEpUR1BUOTY5TEZ3WmxBNjVQ?=
 =?utf-8?B?Tk1mVTBkV1hBMFFUSlJBR3J4dHd0U2NpSjhveGtaUDdQbFRldTAzQzRVNis2?=
 =?utf-8?B?WEFuOXBhZkFINlVTZWw2Wk8wUWZ1UHBkbkEwc2t5MHlFd3R1YThHN3plc3ky?=
 =?utf-8?B?Y3pVZE95S0JjRTZTSDVNSEdMREtWSjRUeVRnT3F5dzAzK0RMZG95RUFiSldj?=
 =?utf-8?B?cFZINzV5TUVrT3Fxb2lNS2pyakp4dHBkNkRPcFFRNE9GS2c2cWQ4MHp3WlBD?=
 =?utf-8?B?b21BRzZlOWJHRGtTdmttblk5dHZrU2JzbjRtdk0zekxCYlMvT1FmK2pPclIv?=
 =?utf-8?B?SmZVbGhJcDUvKzl6NGxBUUF0RDJvNHRDQUg1Y3NhZW0wbk1hMGlrUHROU085?=
 =?utf-8?B?dzhkdkN4TTdFWS9PcGpoYlBVK01yUnNET3dtTC8xSlJHbDMxOGtNY3hBR1Vl?=
 =?utf-8?B?ZkdqeGVvZzBVdllCWEM1MFhQL2NPQ1dteXRnOXJNRHJSUlFsbVJrdVlqSHR3?=
 =?utf-8?B?YmRMcCtlaDFZSkhoV3d5VFZLYTI4TUtucHRyMDJuKzFpbzh6dEJiL2x0NW05?=
 =?utf-8?B?MUpmOEJDbEN0SktUdmRScDhxL0ZMWEEySWJ0elZWQWhCazQ1amtMelJFSFhM?=
 =?utf-8?B?Uzhnc3Bhc1pjblEza2N4T1gwUWQwTGpOS2twSFBybklpcEZxUGEyTEdzU2lY?=
 =?utf-8?B?ZGFMd2Nsb1ZlTFJRUkIyei9pK0s4cGNWOWxxNUVQaDRhamt3WnpFa0NGOTI4?=
 =?utf-8?B?akxCYU42YnJ5VytsM0U2eFQ3ZStxY2N4OW5KZDBGd3ozbml2TjRXNFErQktk?=
 =?utf-8?B?cFhab0h0RlZFVVVYV0F1cnR4YkNoSVkzZTFIOXhVMFZreXR2bGhZVmkybC8z?=
 =?utf-8?B?aWVsMUhaMDBaVEQ0aUV4NzJKZXJDNE8wVVg2YUR2VEZUT1hod2NFSlpNNXBZ?=
 =?utf-8?B?NUwza0FTdjU3SFd4VmxTdlpsS3hKSWFOS0lwWHZ3dERmRk9vMUZGcldJb2ls?=
 =?utf-8?B?cHNGKzg1bjdScUR1NEY4czZ0N2JxaDIyZDl3Q09iSW1ya1k0a29UUGIxdXZ4?=
 =?utf-8?B?TTBvbk5wZ2NiN0ZQVXBCS2NMaVp4dzNEOEJRdTh6ckp5Ry84aUZFQXZpOERD?=
 =?utf-8?B?MGhUZThnQU10Q29BamEwZmFPd1FLbTNTdHFBUUVLZzVwdkVrcFJld3VHenQ3?=
 =?utf-8?B?TW02WFB2ZW83cFVBSDFJclA3QkpURWR5bVRDS0VWVkRmUllTTTNNS0V1c0dj?=
 =?utf-8?B?bmdxbVFFL2ZpZnhCRkQrdHRseEduNTU1bWdGSU5QRGI0WkY5dXV3eDNrRWZi?=
 =?utf-8?B?RW56dUJBYkhKS3dlSFlCNWsweWpWYXgwRjlDSFNCUTRITUV0ODU5UDB1YTFv?=
 =?utf-8?Q?F+7CJVuoKUBjK?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB8189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SVArRzRFRVVkUkc5Vll6dmluS2s2SFZtbmRacEIvU0FUZ2NBc1JreHU4QjFt?=
 =?utf-8?B?OXE1ajZ0THYrQXdoeUc4UVhLQnNBYWJOK0Fva3kwQVVmTFF0MVZONkhFYVl5?=
 =?utf-8?B?UnY2KzF0dE1SbWNkV3NtT21ac3hrT3lMOTY4a2lFYm91ZlhreGJWQlhRdmVp?=
 =?utf-8?B?bFNPSGMrbTJBVkNQcVkyb2NJNnA0M2ZRUU5ROGdyc2ZaanRTanRvNzI1d0tv?=
 =?utf-8?B?NUtjZXd1YVBoUEtXRXNMT2s4NzhZa3ArbVpma3g5alJOdi9IUWhrL1dTbmQ0?=
 =?utf-8?B?V1lhVHlNOU1mVDB1RE1qQ25UYjFsMW9uaWtFQVJqcEZ2WFY1eVJra1o4aWU3?=
 =?utf-8?B?VkNIMHhwOW9iUnVJWmkwZVJJMTZZZVhUczAwQkVld29mYUVXcEhQRGhlSUVa?=
 =?utf-8?B?TFkvL2QxUVRoOXJZMVBjWi95NTNzODl5bXd3eHhLK0VIUTNTQXpIeVJpcHh6?=
 =?utf-8?B?dnE0Z3FSTUxtNjBkYXhaVEkvaVI1YytZS3ZkNjlFR2gxNEhicTF4N3VPTHJF?=
 =?utf-8?B?QlVVbmVxZmF2TFk2ZGpmY3EyRXVUNlpjaCtpQjhiUDg1Si9HZWk5ajJUT05D?=
 =?utf-8?B?Nnhhbm1SZTA1Wm1nM09pQWRpYUhMUkFQbmRwbWxmd0tITGtkaytBQlIzRmta?=
 =?utf-8?B?S2lyTGtjWTZKRjN3M2dRQ29TaDRyZlFDb2dSZE9Za1VsRElrOG1LclRSNW15?=
 =?utf-8?B?TXpMODVmdm9BdU5WaE9TZlI2dFlaNDRTUVdDVUtlVGVyTExNRzJMTjhoa1hB?=
 =?utf-8?B?SXJLeVc4SmpTL3FuZDhISDBLS2dFWjlGTkhGbFNQMXJGT3Q5cjI2dnN2bXQ5?=
 =?utf-8?B?MGpGRHozbFpBcitGa2xMUTdVU2IzcTN1Q2xSbWlSUDRaNnEvbFBZWDNUUy93?=
 =?utf-8?B?enRtdzhtM3dsVjVYcGJYQXZTb3Ywd1Iycmh3VXRrd2YweUZ3N2NEOU5adVBh?=
 =?utf-8?B?RW0xVENyL2YwZmNRZDUvNXR3NXkvTTBxSEVsQkUyZ0tGMUNkbUhnTEZmMFdu?=
 =?utf-8?B?NXhmZVRRTnBhbVlTdU5GVVJVZVQrc3BnU0pxeE1TaXlDZ1prd2lYRkF5dHU3?=
 =?utf-8?B?NVdGd01WdzVnN2hIV2lZdEhHdjZzcWh6eDh4MEp1RGsvMVhFTXdPMGQ3L296?=
 =?utf-8?B?L28weHk2ckV2T3JJZ3pSUks3VitFUk00d1RPUTdQTEIva2lDMVFXZWYrMm9Z?=
 =?utf-8?B?bmNLaHJ0L1l1KzBneENWSllhVHNtUXNnUzR1b1BVaFZ0ZTMyYy85ZU8yWFFz?=
 =?utf-8?B?Mkc1QkFoTTJIMS9pY2s4UHovU2pKRTJ0RVdMS05YVSsvenQ4bE9MSUdJbkxI?=
 =?utf-8?B?dnFVbTBWdkkxRFZvREpHQkNIT1ZqOHUvRkM5dmRmUGFBRUYvc1ZtOXg1U3NH?=
 =?utf-8?B?YlBTbHZ3NkJYb2pLTmRVaTBBV1FWbnBjZkw5aHlsNzhJR0VtMDVMQWN2WlZm?=
 =?utf-8?B?WWpRNFhDSTdBN0t6cisyb0ZzVTlwbnhBUUUrUU9GQXZGWU94cDJpZzQrcDgv?=
 =?utf-8?B?cTduVVhRQjVrR0JaU1NaSFd2ck9mckpMMkxNSElUbjM5NmFvMHZ5cTQ4Z0dm?=
 =?utf-8?B?VmFab0Nsbmh5eEVFay9KUUtEaFp0TjdZRWNZdDRDdm5zcmR6dnY4Mm5CV1U1?=
 =?utf-8?B?NFhGYzNsRDE5Y3dDMUx4dkxnbWEzejJPTHBEVi8yTllLQjBNdlhMK0ViLzJJ?=
 =?utf-8?B?TDdWZTc4QUgwZ2JKM3AyMngxUXhLZk5sVEVVOENuU1lFWDBIWUpyV0ZBNWxG?=
 =?utf-8?B?VndmQUh5ZVB3SWx2clJUeEFUM2E1d1N5L1ZOWWQ2Qm82M1FQUVduTWIrL21W?=
 =?utf-8?B?WlZYaXdqNnVYYWZHQTFqcjNyaXlhM1NWSDllb1I5Z0JjZ2lVTTA3WGNpM2hk?=
 =?utf-8?B?K2c4TG93MVdNWFhJWXRueVRhMDUvTWhWNXA0WmFCbEVOeE9lQXNLWGl4eDEz?=
 =?utf-8?B?cTYwelZ0VTgyWG9BbEU5V2hSTkIxTndnTHo4OTk2OVRtbEZVdFB2NUVwZ3VH?=
 =?utf-8?B?YkF6L0U4cXFwMTBIVzR6Mmc2OGhjYXhnbTFnTnRySWJsWDRlaFkvUTFUWkNR?=
 =?utf-8?B?enh6NFBpWVBTN0Q3andtbkFGem5KblA0R3NNQUxiYmFMYzlwTUxmVERQZFhN?=
 =?utf-8?Q?73Fs+TkLoiygUB7fg09NBuhuq?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ee9bdce-9235-449d-af51-08dd51b39c79
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB8189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2025 13:36:42.5792
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qUPWwrIIXFt1rE2EFBV6ZeIoVh5hH2Fh80cv+JNs/RkA88ojnyClnMW/3/Q3a1EWLqXbFM2o8FIYCCPj5SnKcw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8267

On 2/20/2025 8:38 AM, Naveen N Rao (AMD) wrote:
> KVM allows VMMs to specify the maximum possible APIC ID for a virtual
> machine through KVM_CAP_MAX_VCPU_ID capability so as to limit data
> structures related to APIC/x2APIC. Utilize the same to set the AVIC
> physical max index in the VMCB, similar to VMX. This helps hardware
> limit the number of entries to be scanned in the physical APIC ID table
> speeding up IPI broadcasts for virtual machines with smaller number of
> vcpus.
> 
> The minimum allocation required for the Physical APIC ID table is one 4k
> page supporting up to 512 entries. With AVIC support for 4096 vcpus
> though, it is sufficient to only allocate memory to accommodate the
> AVIC physical max index that will be programmed into the VMCB. Limit
> memory allocated for the Physical APIC ID table accordingly.
> 
> Signed-off-by: Naveen N Rao (AMD) <naveen@kernel.org>
Looks good to me. Liked the optimal solution.

Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>


> ---
>   arch/x86/kvm/svm/avic.c | 53 ++++++++++++++++++++++++++++++-----------
>   arch/x86/kvm/svm/svm.c  |  6 +++++
>   arch/x86/kvm/svm/svm.h  |  1 +
>   3 files changed, 46 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 1fb322d2ac18..dac4a6648919 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -85,6 +85,17 @@ struct amd_svm_iommu_ir {
>   	void *data;		/* Storing pointer to struct amd_ir_data */
>   };
>   
> +static inline u32 avic_get_max_physical_id(struct kvm *kvm, bool is_x2apic)
> +{
> +	u32 avic_max_physical_id = is_x2apic ? x2avic_max_physical_id : AVIC_MAX_PHYSICAL_ID;
> +
> +	/*
> +	 * Assume vcpu_id is the same as APIC ID. Per KVM_CAP_MAX_VCPU_ID, max_vcpu_ids
> +	 * represents the max APIC ID for this vm, rather than the max vcpus.
> +	 */
> +	return min(kvm->arch.max_vcpu_ids - 1, avic_max_physical_id);
> +}
> +
>   static void avic_activate_vmcb(struct vcpu_svm *svm)
>   {
>   	struct vmcb *vmcb = svm->vmcb01.ptr;
> @@ -103,7 +114,7 @@ static void avic_activate_vmcb(struct vcpu_svm *svm)
>   	 */
>   	if (x2avic_enabled && apic_x2apic_mode(svm->vcpu.arch.apic)) {
>   		vmcb->control.int_ctl |= X2APIC_MODE_MASK;
> -		vmcb->control.avic_physical_id |= x2avic_max_physical_id;
> +		vmcb->control.avic_physical_id |= avic_get_max_physical_id(svm->vcpu.kvm, true);
>   		/* Disabling MSR intercept for x2APIC registers */
>   		svm_set_x2apic_msr_interception(svm, false);
>   	} else {
> @@ -114,7 +125,7 @@ static void avic_activate_vmcb(struct vcpu_svm *svm)
>   		kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, &svm->vcpu);
>   
>   		/* For xAVIC and hybrid-xAVIC modes */
> -		vmcb->control.avic_physical_id |= AVIC_MAX_PHYSICAL_ID;
> +		vmcb->control.avic_physical_id |= avic_get_max_physical_id(svm->vcpu.kvm, false);
>   		/* Enabling MSR intercept for x2APIC registers */
>   		svm_set_x2apic_msr_interception(svm, true);
>   	}
> @@ -174,6 +185,12 @@ int avic_ga_log_notifier(u32 ga_tag)
>   	return 0;
>   }
>   
> +static inline int avic_get_physical_id_table_order(struct kvm *kvm)
> +{
> +	/* Limit to the maximum physical ID supported in x2avic mode */
> +	return get_order((avic_get_max_physical_id(kvm, true) + 1) * sizeof(u64));
> +}
> +
>   void avic_vm_destroy(struct kvm *kvm)
>   {
>   	unsigned long flags;
> @@ -186,7 +203,7 @@ void avic_vm_destroy(struct kvm *kvm)
>   		__free_page(kvm_svm->avic_logical_id_table_page);
>   	if (kvm_svm->avic_physical_id_table_page)
>   		__free_pages(kvm_svm->avic_physical_id_table_page,
> -			     get_order(sizeof(u64) * (x2avic_max_physical_id + 1)));
> +			     avic_get_physical_id_table_order(kvm));
>   
>   	spin_lock_irqsave(&svm_vm_data_hash_lock, flags);
>   	hash_del(&kvm_svm->hnode);
> @@ -199,22 +216,12 @@ int avic_vm_init(struct kvm *kvm)
>   	int err = -ENOMEM;
>   	struct kvm_svm *kvm_svm = to_kvm_svm(kvm);
>   	struct kvm_svm *k2;
> -	struct page *p_page;
>   	struct page *l_page;
> -	u32 vm_id, entries;
> +	u32 vm_id;
>   
>   	if (!enable_apicv)
>   		return 0;
>   
> -	/* Allocating physical APIC ID table */
> -	entries = x2avic_max_physical_id + 1;
> -	p_page = alloc_pages(GFP_KERNEL_ACCOUNT | __GFP_ZERO,
> -			     get_order(sizeof(u64) * entries));
> -	if (!p_page)
> -		goto free_avic;
> -
> -	kvm_svm->avic_physical_id_table_page = p_page;
> -
>   	/* Allocating logical APIC ID table (4KB) */
>   	l_page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
>   	if (!l_page)
> @@ -265,6 +272,24 @@ void avic_init_vmcb(struct vcpu_svm *svm, struct vmcb *vmcb)
>   		avic_deactivate_vmcb(svm);
>   }
>   
> +int avic_alloc_physical_id_table(struct kvm *kvm)
> +{
> +	struct kvm_svm *kvm_svm = to_kvm_svm(kvm);
> +	struct page *p_page;
> +
> +	if (kvm_svm->avic_physical_id_table_page || !enable_apicv || !irqchip_in_kernel(kvm))
> +		return 0;
> +
> +	p_page = alloc_pages(GFP_KERNEL_ACCOUNT | __GFP_ZERO,
> +			     avic_get_physical_id_table_order(kvm));
> +	if (!p_page)
> +		return -ENOMEM;
> +
> +	kvm_svm->avic_physical_id_table_page = p_page;
> +
> +	return 0;
> +}
> +
>   static u64 *avic_get_physical_id_entry(struct kvm_vcpu *vcpu,
>   				       unsigned int index)
>   {
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index b8aa0f36850f..3cb23298cdc3 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1423,6 +1423,11 @@ void svm_switch_vmcb(struct vcpu_svm *svm, struct kvm_vmcb_info *target_vmcb)
>   	svm->vmcb = target_vmcb->ptr;
>   }
>   
> +static int svm_vcpu_precreate(struct kvm *kvm)
> +{
> +	return avic_alloc_physical_id_table(kvm);
> +}
> +
>   static int svm_vcpu_create(struct kvm_vcpu *vcpu)
>   {
>   	struct vcpu_svm *svm;
> @@ -5007,6 +5012,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>   	.emergency_disable_virtualization_cpu = svm_emergency_disable_virtualization_cpu,
>   	.has_emulated_msr = svm_has_emulated_msr,
>   
> +	.vcpu_precreate = svm_vcpu_precreate,
>   	.vcpu_create = svm_vcpu_create,
>   	.vcpu_free = svm_vcpu_free,
>   	.vcpu_reset = svm_vcpu_reset,
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 5b159f017055..b4670afe0034 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -694,6 +694,7 @@ bool avic_hardware_setup(void);
>   int avic_ga_log_notifier(u32 ga_tag);
>   void avic_vm_destroy(struct kvm *kvm);
>   int avic_vm_init(struct kvm *kvm);
> +int avic_alloc_physical_id_table(struct kvm *kvm);
>   void avic_init_vmcb(struct vcpu_svm *svm, struct vmcb *vmcb);
>   int avic_incomplete_ipi_interception(struct kvm_vcpu *vcpu);
>   int avic_unaccelerated_access_interception(struct kvm_vcpu *vcpu);


