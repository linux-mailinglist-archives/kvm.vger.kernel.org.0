Return-Path: <kvm+bounces-32241-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EA3739D470E
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 06:06:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 52812B2316B
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 05:06:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B890914D28C;
	Thu, 21 Nov 2024 05:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ulDRJ9mX"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2075.outbound.protection.outlook.com [40.107.243.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2D1B230986;
	Thu, 21 Nov 2024 05:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732165557; cv=fail; b=e2EtDP/WkH2dQCznAKwo9OU8Xsr+Y2WrDY0mgCDN3hJo9CMoyAaqRVSEInatzBPcgh8PW+0Lea7PLqL02tSLct9dxsBCFq+kR2YtndA2bVpTxtv0sLsyGonGdwNcwurc6DEyiVxk4Ulp/B+kwIk3BIO1PGuSmV3TSi8gUjrlXbs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732165557; c=relaxed/simple;
	bh=zlh9ndBFpycVS9h9jDNYARRd1py5ogS1nYbKgiyDGRU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=G3KN3rWUIh3DeTHRd0FuFTjuNkwkxCuTIc6T65d3InPC5FjZN1XrhHlEFu8M+FmVmdFJftE3TS7KT7P2NdueY5m1/0dcNLFTngu2NyLusrSApiDWVaOnpm42sNVtOZgYhd9LrfFYhSjnmAGjurKAHcWA1GuVaiXALgmMm6wNY4s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ulDRJ9mX; arc=fail smtp.client-ip=40.107.243.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=boNmbM7yK77DjtH1B97NOM/xzz6OsWOYG0j4UFWBHtCBxo7g5D6AxlxfQ6PAK3TxXpYD6os/lzT4hLJdhlC4Pbf+7xgvv3J5+cgVzyXog54gpVIJ9KcHGapV1pDSyiRsnXVwCf65wKrg7yU4jfTiflnJ0/80kTRgZIAPcGibXREPp5xImI7eX8g2hnJo2CzXBmh0Kj7XWg+rUKqjDz4c5GT+x1oZKVliUg3Fgjq3YPW12X+12Fwrp9Hc9d4T4yostAgsMdZS2x0eLT7FM7ytuPDd+vL6i9J9iSHGuSB/ch4KrvOkiaol9qQQpNi6xdqnQ9w8Unjp4yNm7DqHMNJ1dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5OGQEpMapz+Z/+/xMfkmaPf0y2AsiqKVM7hKbIov1P4=;
 b=h9ztR5w6WW2QIiGEi18rbJdtLTOK9c7YVAjfAwIKJ0OOWzrTa3ImIATvgjOqllopRNLEtMGvPEMgSlI98faNciNalRi7JPRiYLTqVlXnxkICrq7MOlnplO5YFAUvTfHUF4fThh7uhjQ4Xibu1/IqO7tK53zdExdxTrITiSGtD9w8NMbK4wBR4phsBEQnCrt/hw4gU2/NQjhFOQOcdhfNaQbECRqjMiMDczIKaunuEdWYakD+dH5Zjck8dXucWtF8CD9RPQqsiL0ZyvXpd8/BnmFk6CPAvjXu0+wqpGryfvMkhBFp+BJqsJGmxh8Dx6NKUkP0ObrAGqlrFgkfSygZvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5OGQEpMapz+Z/+/xMfkmaPf0y2AsiqKVM7hKbIov1P4=;
 b=ulDRJ9mX/fJ0/914KLLP4wVHn2rCdQDc2PoZWlMIzNDHUUa3tK3VGQ7e2wK9Ae4RnhJ40kVvydZFmm7uHN2hsZuA9wvlerrnwwRPLCpiA+MBI0Cxo4zECZ+M5Kwv+lmNHUuWfRqMmjl+2mRcKRrwNRUJjN1qvRdugNlMLeaCv4o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6608.namprd12.prod.outlook.com (2603:10b6:8:d0::10) by
 PH7PR12MB6443.namprd12.prod.outlook.com (2603:10b6:510:1f9::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8048.22; Thu, 21 Nov 2024 05:05:52 +0000
Received: from DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627]) by DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627%3]) with mapi id 15.20.8158.023; Thu, 21 Nov 2024
 05:05:52 +0000
Message-ID: <4f0769a6-ef77-46f8-ba78-38d82995aa26@amd.com>
Date: Thu, 21 Nov 2024 10:35:35 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 01/14] x86/apic: Add new driver for Secure AVIC
To: "Melody (Huibo) Wang" <huibo.wang@amd.com>, linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com,
 Thomas.Lendacky@amd.com, nikunj@amd.com, Santosh.Shukla@amd.com,
 Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com, bp@alien8.de,
 David.Kaplan@amd.com, x86@kernel.org, hpa@zytor.com, peterz@infradead.org,
 seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org
References: <20240913113705.419146-1-Neeraj.Upadhyay@amd.com>
 <20240913113705.419146-2-Neeraj.Upadhyay@amd.com>
 <6f6c1a11-40bd-48dc-8e11-4a1f67eaa43b@amd.com>
Content-Language: en-US
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
In-Reply-To: <6f6c1a11-40bd-48dc-8e11-4a1f67eaa43b@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0079.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:9a::19) To DS0PR12MB6608.namprd12.prod.outlook.com
 (2603:10b6:8:d0::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6608:EE_|PH7PR12MB6443:EE_
X-MS-Office365-Filtering-Correlation-Id: be107065-9420-4cd0-2c15-08dd09ea2c1b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?U0F1YUkrMUhWSjBWWnRhYW1ta1FVY01USmtSTXF2UHQwekp0aUhSbENEYXZ6?=
 =?utf-8?B?bUtPelBzQjNTazJRcGlLRnRwOUdZekNEODBNRytDQktzcERTa043M0g2RkRk?=
 =?utf-8?B?ekw4d3lDUkI1YWxOUTlwSHljT0xiWXFQcEtPYTczTWZHSjVMem9qRlM2WjRE?=
 =?utf-8?B?eTlicHo1dEJScHY1cnFIbE0rN3FEcUp0UWNJOEtsdEVXOXRyckpmZ0RUKzdt?=
 =?utf-8?B?YnJBVDdJcTc0M3QvNmZrcmRkMzNMZytnQXNBclRJTnRSb1ZPVFhiL01TOENi?=
 =?utf-8?B?cG44YTU1SjVwaTNLM1gxTm9pdEw5NzRFUDFHZkZjaExma0RieXNCWHFYQ3hj?=
 =?utf-8?B?UXg0eWI1UGN3TlNvSmVQTms3WGgwN2UzTW1CR2IxRDNSVGdySnQwcHg4QytK?=
 =?utf-8?B?UnNlanE3TnVNMllaemVNTE9oc1VWSWRYZkV4QkVOYk5EUFlBNmpqNnM4QkZt?=
 =?utf-8?B?NmcvcDBGYWQ3QU5DTW1MOWIvakRqQ1c3WkQzSStYVVJSTERnQXpsN3FHWmpX?=
 =?utf-8?B?SWZZekxDdHcyM09Ja2ZLU3NUcXFUWFhiZDdvMlQ4TUV4blFnUGo2SHdJYUxX?=
 =?utf-8?B?M205czVHeEc0d2dYNkJFSWM0bElIV1FxWnZhMmNxcFh6Qk41RWhYanJhRnZ2?=
 =?utf-8?B?VS9yY0RCY0pkSFk4cHd3OWUvTUxLcGdiL0dsQ1hiQzBmOTlJaUVYNHB6a3pw?=
 =?utf-8?B?ajhXL1FmY1lIV0YrTmxod1hLVU1DOS9yamg4MDVpVjNETHgvS0lqeU1PeFlK?=
 =?utf-8?B?TW5YSHo3cWVhdFIrTjZEM1U3bkdaY255eVFqZXlvUkIvUndYaXYvbk5wZGlE?=
 =?utf-8?B?S2pCK1lxaXhJS21zWktKeDc3MnlSUGp0VUlRMStUZ1B3YWV1ellITzhWNWZz?=
 =?utf-8?B?TjFPVlpkVlZhZ3JxWVRFR2F0Nlh2V0xpUTVLMnBTS2RHcXJ3dVJkZWsxaXlh?=
 =?utf-8?B?dXJwOUtLTWxTTTF2SjhzZ0JRYm1hS2VacGxpMjZFUDZYK2NYWWNjbDc2dVF0?=
 =?utf-8?B?UERkeXFKWVQzSC9QN3E2aFJjaTFVcDdkbE5FNzl4M0RBUi9NbW5sWmFOVzUr?=
 =?utf-8?B?RmRGWThIblFxd1VYL1d4ZVZyMDVaYTF0M2dqUmNJNDRUeGMrdlZ3MXhlMTIv?=
 =?utf-8?B?RVZGeHhTQXlTNDQxeFdNUnpabXMrS1NkbTR4ZnpQYk5SMXlxM1VpTVRWSEMw?=
 =?utf-8?B?MzJEMVpSWmozU1JTNjEvK0V1NlhkOEZiWVo2enVybEtrdlNWeTJLS1ZKZnls?=
 =?utf-8?B?UkprdzBXK05xcmdNSm9DRDFBNmZ6SmMxcTlLNDBvTTEvWCtRNitpdmNlTEVl?=
 =?utf-8?B?RkJxNUdBYWl1REJVeTBRQUdIZXQ4NExFTWFGODMyYzFETXpSWXRmVVdRYUtT?=
 =?utf-8?B?MEk0bXFJVW1PenJKSUlyakZvdGk1eWQ5NGxlbEtRc01RU0Rib3dlMUJVcnZW?=
 =?utf-8?B?VUdTaVcxR1pZeU1uenBXZlprYS8wcU9hWVZzaTlCWUFRcGJ2aXlET3k2dytI?=
 =?utf-8?B?dTEzV1hTVk9FQ3lXM3NnbTNKb3VWL3N3UHg3TGE3TXVGVm5EN0lPbmoyMHFI?=
 =?utf-8?B?S09jUWZ4VlJGZE05SEZxMzFnNEwvcUxGRkZDeUthbmNDZURyd0RXb3dmTkxp?=
 =?utf-8?B?d29pb2FZM2hkWWpHeXhEOWVXZFhxVzA3VEY3YlczaVgyTThIMWk2VURZY0lr?=
 =?utf-8?B?RGNuSEZyd2R5TE8rSGVnNkpDd2lPM3Y5SGYvZmh2N0hqMTk2M3ZPcUZLRXNu?=
 =?utf-8?Q?DmBa9afAssMQa61fkwVSnz+jd/DJoueuKvgx+7P?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6608.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aE9KS3VLS0h0MVMzaGVLLzczU3YxQTZzRHNvQkl0SEZhb2NWd2FsQWR2aTll?=
 =?utf-8?B?RTZwMmdscDJtbXJNQWRQVTJRV2ZqQTFacmY4eGlsTEJWWHptVVIxaW1reDk4?=
 =?utf-8?B?ek9YMy9zd3lWRWp2d0MzUkswbHdZWUlhUko2LytTdDhtRExTdjVIb1RTbEtU?=
 =?utf-8?B?Q2t5aVJuWGF3VnZad1RraElNc1RQYzRxcTl4QWE2bDd4dW1GQkdISFVXWmIx?=
 =?utf-8?B?aDc0WHFuWktJN1lXU2o4VkcycFY0SjRDcUxuRjNvQllYb2EzdTF5TUw0TWU2?=
 =?utf-8?B?Tm9qZUhsOTg3WTIwUXJTWDl4K0xncWtHcHFieWtRRDBKK1FhUzJBVm1LNWJk?=
 =?utf-8?B?MjFIKzBOa0FVWGJEY1o0VU8wUS9sNjBGcVU1VS9tZjFwYmFHcGlGVWNiYXJT?=
 =?utf-8?B?VUhyaHVOOU1wL2FSQ1dxNUFsWEhWdGNnT0N4dzYrRzZtbFR5cWd6RW13eVUw?=
 =?utf-8?B?amxkN3g3WGtWTWpqNXU5QVRVRFZEUVRDV0VET0t4NSs0eThITldkYjdWZWhm?=
 =?utf-8?B?TTB0dFJoMWxQUjNuVjk0ejVhVGY0QWxVaXA1Z2FwTnhuQ01lMmhRbCt1L3JZ?=
 =?utf-8?B?RGZqQkZ0WmFxYlJoZ3AyaVNPM3FJd1h5TkVyT0ozQU5nUWUxNGlFYXNYQktt?=
 =?utf-8?B?V0JqZzJzcmZ4a1VQT0dNdi9rcUF6K1h2KzRWZkxtaXFyTzNDT2FxVnpkT3p4?=
 =?utf-8?B?YktzL1N0RVJVSklXc0pMeDROdFF0aEExSG1yS01xWEhxZWN1Uk9LdllWQVc3?=
 =?utf-8?B?clhYaTBQWjljSHIrUkl2ZGZJYUdiU29LeXY1NEU2aTBsY21ScFN3ZCtwc1lp?=
 =?utf-8?B?VVNPRXBON0xyYVBTNVdEL2pkZTBhaUFBNzgxZnM3VGhqY3dCMzlucWNsbnpO?=
 =?utf-8?B?allzcnAwQlErbHZ2S1dDQ2hXUTZLQ2lqeGdlTUdHVkxXZVdTSHYxTFpNb1ZY?=
 =?utf-8?B?bHRlcFdiQVluUlhjTGdXZ2sxdzRDbEc2eTBKN0JEUXgzeVZTVXE1Rk8vMXlR?=
 =?utf-8?B?TUlRUVUrNUo4bitudHJXNkVjQ2FFb2dhelgvWFJwTExTKzA2Q3lLdXM4Sk5C?=
 =?utf-8?B?c0hNaWlHbXo2dzFyQlpUbzIxSEd1d0VsZjk0aHEzRUxvTjBKbVZ3cDhHRjF4?=
 =?utf-8?B?U1labk53ZFp6Yklld2VwSXAxNGsxSlVWQmtKdzcxbFAzSzRzR1QvMFI5MlJn?=
 =?utf-8?B?bHFoeW4xcktIMll1WUxhTWxTcGxGNUhWcCttYmdxcjVmREhWNXoxM3N4YWhQ?=
 =?utf-8?B?OFlmRDVNL3kwNGVKTjVhYm50MjRZZ3lSalZEUzZjcHdFOSsvUFlTZ2tYZ3FZ?=
 =?utf-8?B?L2RzZG1JSmtDQUpveFZQSzBpSDBtNTY5T1RXSGp6VGRGYjFOTzhqbVFIcDZP?=
 =?utf-8?B?OTR5aWZBMEZUa0dIVTRDblBTZ0o1MFRpNWd4TW5JbXp2TWhtWXVBVkN6dURG?=
 =?utf-8?B?MS9BWE9MMXIyaUpQK2tQRXBFN0h2MnRHRGxVZWNpZ2hNdHlkYmpTb3c1WE9z?=
 =?utf-8?B?UUROWVB3c0lLVUN2V1d4RVFiTVE3MXZtOFJxVDg0TXEvYmdqaE5oc3BNaFVa?=
 =?utf-8?B?TURReXVVcE5VcDcxQ1g5OFZnVFgrQS9kY2ozdFZvYjFCbTFrV3p1eGFhRENh?=
 =?utf-8?B?UXdqU2VEcXVaWEJ2UW41Qk9jalhzVmpWSHFWTjZqa3BtQ0lIYXZuSlBsVXdq?=
 =?utf-8?B?Wmo0TDBqMDVSWWMremJsYW9qZnNKMCtWMmpqS2lxNlJPNWQ2QkpWNHZhNkhW?=
 =?utf-8?B?djRUeENoZHRhSVN4d0ZXbm0rSWZCWmJZR3ZndC9SMVJpb1gvTWNmSGFnTkY0?=
 =?utf-8?B?T1BpSk1BWm5HQmhneTg2dkVhOGRBT1orcW1UOGh2ZkdMRS9pd1FPT2JLck5I?=
 =?utf-8?B?dVp0cXNZdEMwellnbUR4QmhwZFlhUTJyMjRVRDJ5OHBUTFNnUk5wcU5rdnVD?=
 =?utf-8?B?MnZpMDcyL1h5K1U5MEhSUUs0OHoyOXUwcjNKSDVpZHkwTjhNTTdLRVV3cHFs?=
 =?utf-8?B?cjZYNlFWZ0lBSnNkeXVLOFV1d3FETUNxd3ZxVXJRdEt5dkhtOEx3Wm5oYlpz?=
 =?utf-8?B?dUJvNWlaUDMwR2wxM0hPZG14d3NDbnlscVdLK0pET1NYZUExcWRpSDlGK043?=
 =?utf-8?Q?nTXpnmaVfGKaI056Pm09ohUMN?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be107065-9420-4cd0-2c15-08dd09ea2c1b
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6608.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2024 05:05:52.7770
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W9NUZebvvlfoCtmLRiAgXZ9TPoYdcYX4iX0iIZw20Rd10yUaz6RwdLkNYMl/va9gcpFEcv3eAATyuw6Uk9rWZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6443



On 11/19/2024 3:15 AM, Melody (Huibo) Wang wrote:
> Hi Neeraj,
> 
> On 9/13/2024 4:36 AM, Neeraj Upadhyay wrote:
>> From: Kishon Vijay Abraham I <kvijayab@amd.com>
>>
>> The Secure AVIC feature provides SEV-SNP guests hardware acceleration
>> for performance sensitive APIC accesses while securely managing the
>> guest-owned APIC state through the use of a private APIC backing page.
>> This helps prevent malicious hypervisor from generating unexpected
>> interrupts for a vCPU or otherwise violate architectural assumptions
>> around APIC behavior.
>>
>> Add a new x2APIC driver that will serve as the base of the Secure AVIC
>> support. It is initially the same as the x2APIC phys driver, but will be
>> modified as features of Secure AVIC are implemented.
>>
>> Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
>> Co-developed-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
>> Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
>> ---
>>  arch/x86/Kconfig                    |  12 +++
>>  arch/x86/boot/compressed/sev.c      |   1 +
>>  arch/x86/coco/core.c                |   3 +
>>  arch/x86/include/asm/msr-index.h    |   4 +-
>>  arch/x86/kernel/apic/Makefile       |   1 +
>>  arch/x86/kernel/apic/x2apic_savic.c | 112 ++++++++++++++++++++++++++++
>>  include/linux/cc_platform.h         |   8 ++
>>  7 files changed, 140 insertions(+), 1 deletion(-)
>>  create mode 100644 arch/x86/kernel/apic/x2apic_savic.c
>>
>> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
>> index 007bab9f2a0e..b05b4e9d2e49 100644
>> --- a/arch/x86/Kconfig
>> +++ b/arch/x86/Kconfig
>> @@ -469,6 +469,18 @@ config X86_X2APIC
>>  
>>  	  If you don't know what to do here, say N.
>>  
>> +config AMD_SECURE_AVIC
>> +	bool "AMD Secure AVIC"
>> +	depends on X86_X2APIC && AMD_MEM_ENCRYPT
> 
> If we remove the dependency on X2APIC, there are only 3 X2APIC functions which you call from this driver. Can we just expose them in the header, and then simply remove the dependency on X2APIC? 
> 

APIC common code (arch/x86/kernel/apic/apic.c) and other parts of the
x86 code use X86_X2APIC config to enable x2apic related initialization
and functionality. So, dependency on X2APIC need to be there.


- Neeraj

> Thanks
> Melody
> 

