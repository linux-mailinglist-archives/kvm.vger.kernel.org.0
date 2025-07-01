Return-Path: <kvm+bounces-51164-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C106DAEF096
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 10:11:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6909E1BC3E72
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 08:11:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7516D2698AE;
	Tue,  1 Jul 2025 08:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ihH14E4V"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2063.outbound.protection.outlook.com [40.107.220.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5474269CE5
	for <kvm@vger.kernel.org>; Tue,  1 Jul 2025 08:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751357479; cv=fail; b=ijFToVXU6l4Z7eC1qxivDzpGNo/CXuee5r8YyBYmLtG1dbRoqfrgj9Vx5Q2U03x55UOs1cSUukrALFsSEAz8YI9+caCxB9j5JDYMyR1Z0FQ06+5T7s4xrokVJoX7zqsR5CErD8kuqlvNlTdoUXf+ZuN4n2WQkh0vELTV83BIQps=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751357479; c=relaxed/simple;
	bh=c96lMczRsdur0mOqdDaEdf4c9asaXlahtP3srtUDOtw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ltOczz5Nae6ZxOCBaZ+roienLvrpO0wA9YTzmeWJZfp2VY79y2pMTrkNmrqBCpiCcT0ZEn8b4xnMIHjGjLiVU7dqjZ2keNHzJi0pOddGgGH7EUaamQhUthRJU+7GQPW9k3fiu03ZCv0R7I4T4UG8W84k+64YKbR54E7Ht7q4ffk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ihH14E4V; arc=fail smtp.client-ip=40.107.220.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hS8ReafEwFW4JR9R3QI0ciNJVGqa2aWXKFaMerR52BljOMusrThH72A/sZiI+0oGyGNI1vWHc+s5n/UzTZtlemzxFsRjeerigOQ2+XJ6dOv2XI1L5djUK+DdkHmgMxi36kk1lnw5RBeK/OzL47zcYiXXxLNuVJOEhGT3dAGICWBvsuqnZj2CxzoxoD2Nl6X4MVPF2/ipBP2npChDOTnrp3VQyWhxJ3UwMCh2cZG7i9e7gqMYlsv2fjlE8sqS04Rbr2x8IrJhlGI+9q+YjscqjbdmR0vgt/ldNmMqG7/N/X858KSHk8YD9KhAzUFpnZw9G3zXtRllV+6YbRJVAT1FcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rN47yrNWl0VEaK5Yv2Vo2JJWSUQRNGiO2wKOK5QTcHA=;
 b=Nd8aiIbzcfr8N5Fu0PsDJ73MV/S7vjarSAmfXI3PS+c7vmKl4fd62AEm0yR5PrlBUIbAOPPhSUZYr/zyGlb4gUZzYdT7CNWAxAAFGTPEKOxgx3iCWL1ZZ2+7VaHe1gvk5KlHCxq7bBHDy/tJnU7fI15izSAF8TP6mvTiav8OOiExyEghAX+Khpg1Bu8VmU+4ecDq2aF2r6BrYamT8UuNsbIh6hc6Ir5N02nnGxUPSVWf7zCNB8867jgwj5ViRCuZfJzl5rP3oAdIrauCleA5QDSuWRP9A3ATxJl+43oZyQoMCpp4ONZFydqElIG1Vk/Fjd/THiHTSf1hIIAzZM3DGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rN47yrNWl0VEaK5Yv2Vo2JJWSUQRNGiO2wKOK5QTcHA=;
 b=ihH14E4Vc0D+N4ozE+wXCMkNl952ZQnLclDnXqsziEWiH73Xw/Nz06syvuI8ZdYs8o7nFCo66rOxeMs3gMNg36I5bnlT1uHFLp9R75GZNV+ohbe3eaPAYjShW9BimdYycgi3Ojphpm/UOVmh5rWcwjDh9QHX1AKX647fmqfGgeI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN0PR12MB6317.namprd12.prod.outlook.com (2603:10b6:208:3c2::12)
 by CH2PR12MB4135.namprd12.prod.outlook.com (2603:10b6:610:7c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.23; Tue, 1 Jul
 2025 08:11:16 +0000
Received: from MN0PR12MB6317.namprd12.prod.outlook.com
 ([fe80::6946:6aa5:d057:ff4]) by MN0PR12MB6317.namprd12.prod.outlook.com
 ([fe80::6946:6aa5:d057:ff4%6]) with mapi id 15.20.8880.027; Tue, 1 Jul 2025
 08:11:16 +0000
Message-ID: <11aed908-fd03-46b1-907d-3d70bef8b804@amd.com>
Date: Tue, 1 Jul 2025 13:41:08 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 2/2] KVM: SVM: Enable Secure TSC for SNP guests
To: "Huang, Kai" <kai.huang@intel.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "seanjc@google.com" <seanjc@google.com>
Cc: "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
 "vaishali.thakkar@suse.com" <vaishali.thakkar@suse.com>,
 "bp@alien8.de" <bp@alien8.de>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
 "santosh.shukla@amd.com" <santosh.shukla@amd.com>
References: <20250630104426.13812-1-nikunj@amd.com>
 <20250630104426.13812-3-nikunj@amd.com>
 <bbee145d51971683255536feabf10e5d2ffefb44.camel@intel.com>
 <1cbd9a5a-1c15-4d32-87b2-6a82d41ff175@amd.com>
 <be5465f9feeb5d04f8c78f4a2ecc91aaa9be7ad3.camel@intel.com>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <be5465f9feeb5d04f8c78f4a2ecc91aaa9be7ad3.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN4PR01CA0055.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:274::8) To MN0PR12MB6317.namprd12.prod.outlook.com
 (2603:10b6:208:3c2::12)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR12MB6317:EE_|CH2PR12MB4135:EE_
X-MS-Office365-Filtering-Correlation-Id: a73579d3-1a91-4697-fb6c-08ddb876d9e3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?U1R4MTg0OXMxd01FLytQYnU2NDNUQUZCTkY4Q3RPaU9VK2lnTnZKMThLMFRl?=
 =?utf-8?B?L3ZYVnMxbmowcGtiamQrYWQ5YU4zWDVTMTFLRjJHRU5odVc5emZJQzh6TS9m?=
 =?utf-8?B?L0g5eXFtL1V3ZzdGTnlUVEVuNDRMbmprL2cwb0kxQjRpSVVrUTRUcVJpZEdK?=
 =?utf-8?B?VWowcEJmSDFyOSttMkpOS05JNEhGQjRiaVQ1QU8wZEtzZDNEbXRaV01XR1Bo?=
 =?utf-8?B?bElYNEJZUkVCTE52Z1Mzdm1hbzJCVFRleEN6L1VQRVBnNitNakJtTG5QeVBN?=
 =?utf-8?B?dkp0RGYvSzVMNVpRNHUxaEw5UEliRVZ2RytsNmlSZ2NIRDVGQUFMOGV1Mkkv?=
 =?utf-8?B?a3FHVk1BMExLQWszUHU3L1pFWVFSKy9lTDFYZnFodU5hWFhFYm0xcytGRE9x?=
 =?utf-8?B?eCtOQXlkbytxRUtPK1ZNUFR3eVZGOUpKTURCK0ZOSFdIZU9DVmc5STNCNDNi?=
 =?utf-8?B?SlM2RU4rZldFbkZFd0xDTTc2OHR4WElzbzZNdHNpdnN2aW1hMWVhZnB0U05m?=
 =?utf-8?B?SXU0QmdRREo0YStYL0FFbGlURWVtcmd1cUxPSFJzMmF2dzhXVkk4Q2tUZWxo?=
 =?utf-8?B?L3paeHhCclVydzNFU05wMUY2KzI1bzd0Vk15TWFZdnlmb0FNT3JQTE1hd0k0?=
 =?utf-8?B?K204UVJ5bmFWTGJrQ3oybisySnNrQlUwWXVka1FjWm1wK09wM2hXQWlDR0px?=
 =?utf-8?B?WTVldUNRUklveWhLSlNwRHJmNHc5ZGtVRFVCeTdWZ24yLzZYZ0RUcEtIWU9r?=
 =?utf-8?B?VGE4UUNza2RhN2V2cTJCc0I0dFdWNzZldmR4R2xCUWg2dXdVaVVSYSszcm80?=
 =?utf-8?B?RHVOTDNXM2E0NTVETGFud3NoTmxjdzMzVm1iKzBISXdNV0VJTWNVYjNkbEZD?=
 =?utf-8?B?RENhZCtQK29EMjhZSFNoTEpZYW4rU1hTamJZelBsY1pXOUEzQ3N6OVRBNk55?=
 =?utf-8?B?ZXNZZHlQeFI3cmtqVnY1aHUvQWY1L25OZUplZWU2Z3k0c01nbVQ5djduc0tS?=
 =?utf-8?B?K2FIQVRrVU4wendnRWpycHIvQlBoTnZVNzdWZEZwL1N3MlMrUXdBdFlQbFJz?=
 =?utf-8?B?NDVPWHQ0M21nZFF1b2pvR2pvZW9QM3BQK0xaR2xvUlN6N0dwYnI4VVlUdFFk?=
 =?utf-8?B?LzU4bG90czNIMjY0QWQrU0FnQ3VyRFlsZzl2TkJoYTBtRC9ueHlDRXl0Vk5s?=
 =?utf-8?B?c1o1MDZSbXl1UUZkRDJkZjVYaWRENi84UjZRL24ydWlGQTVIeXJHOHNDZmlU?=
 =?utf-8?B?YWwwVVhOR3RaUU13RW1LK3duQUtzTnJJVTFKVEE1Y0IwTDlVQmRoS1pPQnZO?=
 =?utf-8?B?SkpUQkhFODJ6d0xxaTNSc2RBalVRN3MxZmlGdlo5b0JHM0F2ZXhublhzUlo4?=
 =?utf-8?B?MUE2SHFjT1R6UlJSYWF4RUVnYjdrT0FvRzRuNWs0aTk2MG9HWVVwKzRSd0hp?=
 =?utf-8?B?REdiZmxPMVpwMHF5bm51Vml2RlMvK3RHdjM0TmdkWFMwYVZrZ3lFRW1oVkx5?=
 =?utf-8?B?S083eU1nSC9sZStqcmlES01CMWlTenBPRnp3b01ZczFsSE5QSWNSc2U5ZHhL?=
 =?utf-8?B?a0FxNzVrYVgvMWpGVmgycWxqV3hJUTZ5STR0UFVtcEtab0xYZ0lIUjF1Y21G?=
 =?utf-8?B?Y1phZlpmclpjWFJiakhaQUpOTTFHVkJBRVM3UEdLT2J2VzVYOHRLYzBFZU5y?=
 =?utf-8?B?ZjA0a3BNUzlFbHNNZ2VLbFFBQ0NrRzRRSkkyV01aVVRPNFljbWZiOUZKMkJZ?=
 =?utf-8?B?R2VKTUt2dXd4aDN2RDhDa1l2MFNSWXFuS3NHWHBZcDFERmg3SElkeHpGSXly?=
 =?utf-8?B?RWRvWjhEcytjb2JvM29xemgySy9rdWkvdjUxNmhWUHJQd2Y3UDVBRG9uMXpD?=
 =?utf-8?B?bnJuQWlhaEhJNWoxVkpFS3lhRitVVzZwejBGcitLYXhkSURrWmhrNVptdVdO?=
 =?utf-8?Q?MJyzzVyuj2A=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6317.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?S0NhenZLUFRyQThkVHBWTllXUXZqMXJDUUVKYTl3d3pueFJYR29vQzB4MGxm?=
 =?utf-8?B?SWxQSWNXUXArcmE2RmdGQlpNNGVETGtMMWtPMlp1aGlNZlc1eXpQMkNOQ3lh?=
 =?utf-8?B?QmJhSmhMR01ZeXZ2dmhDV0NpN0VaeWhnOGFUeTBBZjQzdmlhMlFIdllkdTNo?=
 =?utf-8?B?K252NWJ3NU9VSG1YVDNhNWM4d0ZDeGJMam9kUnc3KytFNVJNVlNXSjFsMWNM?=
 =?utf-8?B?a3NqOHp1dDhUSGdpSlBCaTdMRkh5Qko5NUJrWXNRRFBPOGZMWmtlZE5ad2JE?=
 =?utf-8?B?Y09NWm9CMk1PSWQvNTRPU3hsN0VGR3FsOXkrb1BlVUw1ZFlpQXZWYVdJR2R4?=
 =?utf-8?B?aGlpQldFMnczaDdKaE9zSmR0N2lCTlpCUElwT1E4Nzk4SDNFb1dkUFNVQ25r?=
 =?utf-8?B?TDlIWHQ4S2JYLzZXcmJCbUwwMjNWK3cyNGRzOXh4YnRHOGZKVVNadFRoaWdm?=
 =?utf-8?B?enZ4WTRHODFBMDQ4b2g3WDVZR0RERlhxNmUxZzNCcUlFWlV4SkJ4VjNYYlVq?=
 =?utf-8?B?NFJPcVpGOG5pRG13UVZ4WXVSSG5oVGk1S2JiS3lQdk5qY3BKNEVyUDhNMTVP?=
 =?utf-8?B?MmxmbGZIeURaTnovQUhhb0NKTTJTK1dJU1pjWVZnYWs5a21VYWNzS1RBQW03?=
 =?utf-8?B?S2JqWDFhR1dCTE4zYmM1UjZOUTlBR2xvdVI1SDlDVVN5M0hicFNzT2k2aS9U?=
 =?utf-8?B?N2lNTTBDV1d2YXZVMjJTSlhFOFVpanREd3JWZEU2ZzAwNmlrcDRXbGltTkg1?=
 =?utf-8?B?RE50RzlzQ215WlBHWXUzOGdsYlZ1TDNORDFSbGRtcTVLYVBwR3h4aGdlQkhr?=
 =?utf-8?B?dUxGS3dLK1Z4K1VpUHNseXNvQzhjU0lKVFRNenl5T0ZFUUorVFhydnl0WThB?=
 =?utf-8?B?WElnWTE5WjU5SXV6YlFickQzYVhmRDBUTlUyWSthdU1vZzJod2diL1dSV0xH?=
 =?utf-8?B?WDNUNjllSVRGN001cUpkekdsZXZFTHhyMm9WdVhPMDVWb0dOVkJDaWVqbzRk?=
 =?utf-8?B?T3pucEx5d3lxQ0hrS21vdEFVeVc1WHNxc1FUQTNpSU9tanREbWs1cks2OTdU?=
 =?utf-8?B?eVA1ZFhHR1plMm92bHhMWEVZZHUwOGYxekJ0MVpjSHU0T2xtN2lUY2JON3Z3?=
 =?utf-8?B?SjVsUHpuYjhNeVJROFhESWJ6cXlXRHpESmpYcGl0SjFxK0pleUVyL1B2eVEv?=
 =?utf-8?B?ZWczUDlEWTV1VmFmMDVGNFcwQzRPUUdNU2QxMVQ2SWFnR284SVR6WTA1Zm9W?=
 =?utf-8?B?ODkxcE1wZFBqMWJpOUF1emRadFJXc1MweVlHRFlzU2FRcVdwTW5XeXJTdDJ2?=
 =?utf-8?B?bUdNYXlVRFBXS1BEdE5kaVhVV0ZlYzBrTXZjZy80b1ZrZDREaVBzdTJldmdk?=
 =?utf-8?B?bktaY2RrQVV6N0dsbURZQTJhMFRtaTUyRnVHZ0VzZ2lZaUdneGpkanF0d3N4?=
 =?utf-8?B?RkVMcFFkZGl0MCsra01aOTJXZkExck9rclBIU0g1N2VscW9IQSt1blI0OXJy?=
 =?utf-8?B?eXZubE42MGZLTVI5YjJyWVVoS0w1anVJWGJQU0M3TFdkL3lHRFFhL25ncHg1?=
 =?utf-8?B?NGJocTZiSlpDYmMvWjlZcktHSDNUQ2JnTkJ5STZaU3NOb0c3L2pLa3gzeE5Z?=
 =?utf-8?B?ZXpwc3E1dTB1S2cyZlc0d0pDZGN2RXorOTRBOWtTK2RoeGNsdlVYeDlhb05G?=
 =?utf-8?B?eHlsTy8zUjFGaWhjSDA0TWs2UDliU2RUUkxnaTdQdnBEcWpQL2xEWWRvTURZ?=
 =?utf-8?B?Nk5QbS9sa0JPbFFDVnV3RXFZb1FJQk5YOHNpeExTZ2o4aS9aZTlLTlI0WnZG?=
 =?utf-8?B?bzJJQldic0Z6dXpmRVExQVdaN1lwc0d6SFUvMThoc1Y5RmxTcTJSc3oyQ2hF?=
 =?utf-8?B?eG12S2JtZzJDZUthOW5QMW1OTFYwenJITzREVDRYZlJyOERlMVlTMGs1eG14?=
 =?utf-8?B?TzRQeG41RTlwd1gyMFhOQ2Y2M0JPOGdBeVI2Zm1HMTRUb1VFc3YwZ0JleFl4?=
 =?utf-8?B?MkpEM0JrRE5rUEVpTUlzY2ErdUlsV0s0MHN4SGJjSTdZWDdJRk41bVJYRHlm?=
 =?utf-8?B?TktXNHFVRnFYMVZKMm5hT0FCOVIzcjdvZk1RMStLaUFjQ252Q2lTQyszdDlL?=
 =?utf-8?Q?m1aZTO4xt6dtwtSxiCZ0kLTQS?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a73579d3-1a91-4697-fb6c-08ddb876d9e3
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6317.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2025 08:11:15.9699
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1/y9tKgKMQhfxX2vwfmFxKlDlIeujZ7I5/2ai8zImBcNq8wCIpvJAS3d64WRoSFd7x69+aqdQn0LnytNFe7gUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4135


On 7/1/2025 11:26 AM, Huang, Kai wrote:
>>>
>>>> the VCPU ioctl. The desired_tsc_khz defaults to kvm->arch.default_tsc_khz.
>>>
>>> IIRC the KVM_SET_TSC_KHZ ioctl updates the kvm->arch.default_tsc_khz, and
>>> the snp_launch_start() always just uses it.
>>
>> Correct
>>
>>> The last sentence is kinda confusing since it sounds like that
>>> desired_tsc_khz is used by the SEV command and it could have a different
>>> value from kvm->arch.default_tsc_khz.
>>
>>
>> start.desired_tsc_khz is indeed used as part of SNP_LAUNCH_START command.
>>
>> How about something like the below:
>>
>> "In case, user has not set the TSC Frequency, desired_tsc_khz will default to
>> the host tsc frequency saved in kvm->arch.default_tsc_khz"
> 
> Hmm.. If user has set the TSC frequency, desired_tsc_khz will still be the
> value in kvm->arch.default_tsc_khz.
> 
> Not intended to nitpicking here, but how about something like:
> 
>   Always use kvm->arch.arch.default_tsc_khz as the TSC frequency that is  
>   passed to SNP guests in the SNP_LAUNCH_START command.  The default value
>   is the host TSC frequency.  The userspace can optionally change it via
>   the KVM_SET_TSC_KHZ ioctl before calling the SNP_LAUNCH_START ioctl.

Yes, this works as well.

>>
>>>
>>>> @@ -2146,6 +2158,14 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
>>>>  
>>>>  	start.gctx_paddr = __psp_pa(sev->snp_context);
>>>>  	start.policy = params.policy;
>>>> +
>>>> +	if (snp_secure_tsc_enabled(kvm)) {
>>>> +		if (!kvm->arch.default_tsc_khz)
>>>> +			return -EINVAL;
>>>> +
>>>> +		start.desired_tsc_khz = kvm->arch.default_tsc_khz;
>>>> +	}
>>>
>>> I didn't dig the full history so apologize if I missed anything.
>>>
>>> IIUC this code basically only sets start.desired_tsc_khz to default_tsc_khz
>>> w/o reading anything from params.desired_tsc_khz.
>>>
>>> Actually IIRC params.desired_tsc_khz isn't used at all in this patch, except
>>> it is defined in the userspace ABI structure.
>>>
>>> Do we actually need it?  Since IIUC the userspace is supposed to use
>>> KVM_SET_TSC_KHZ ioctl to set the kvm->arch.default_tsc_khz before
>>> snp_launch_start() so here in snp_launch_start() we can just feed the
>>> default_tsc_khz to SEV command. 
>>>
>>> Btw, in fact, I was wondering whether this patch can even compile because
>>> the 'desired_tsc_khz' was added to 'struct kvm_sev_snp_launch_start' but not
>>> 'struct sev_data_snp_launch_start', while the code:
>>>
>>> 	start.desired_tsc_khz = kvm->arch.default_tsc_khz;
>>>
>>> indicates it is the latter which should have this desired_tsc_khz member.
>>>
>>> Then I found it depends one commit that has already been merged to Sean's
>>> kvm-x86 tree but not in upstream yet (nor Paolo's tree):
>>>
>>>   51a4273dcab3 ("KVM: SVM: Add missing member in SNP_LAUNCH_START command
>>> structure"
>>>
>>> IMHO it would be helpful to somehow call this in the coverletter otherwise
>>> other people may get confused.
>>
>> I did mention in the v7 change log that patches are rebased on kvm-x86/next.
>> Next time I will make it more explicit.
> 
> So could you confirm that we don't need the new 'desired_tsc_khz' in 'struct
> kvm_sev_snp_launch_start' as part of userspace ABI?

I agree, we can drop it from userspace ABI.

> I think this is where I got confused at the beginning.
> 
> For explicitly calling out the 51a4273dcab3 as dependency, I guess it's
> perhaps just me, so feel free to ignore.  Again, no intention of nitpicking
> here.

Sure.

Thanks
Nikunj

