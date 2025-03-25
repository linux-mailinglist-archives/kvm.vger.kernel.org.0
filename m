Return-Path: <kvm+bounces-41924-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 66761A6FACB
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 13:12:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 634E13A98AB
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 12:10:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EE662566F2;
	Tue, 25 Mar 2025 12:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="sp0t4USJ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2064.outbound.protection.outlook.com [40.107.237.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6921F1EA7DF;
	Tue, 25 Mar 2025 12:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742904660; cv=fail; b=ajCzQ6fRQluIuXHE08YMYLqvsMkWrUhq4POEEKEm/s8uuBvw5B3A4ajR6MDdCpGnpau6cbo/iNDz/vpdTKe8dogJvVYLIe0w4mjMP/Q1OanoWbkIitQCcWlxCa9iQAwr8OEw48sfOTqLwAqGAoaKj54MrAotvLSx4SIgj04Y5Eo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742904660; c=relaxed/simple;
	bh=huiDEm0zXwIhfbJvMUmQCeR4C1VgJc5B3EiMBvCUmPc=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ncz6ZLOqLkQB+6YqUcOztNEFq37CB/7BIvUiMokB/9Jy29b0NHvHdbIkHtVuM4fqBzhxoJ7FHX2c7rTaf1lU8OmS/xRoHsjYYqdCHh4HhChS5Yq8tYA/9CAJ0+sGTI7EUCYPwDCgSQbwEuQQTo6KQBGa8sLWVEpBnDMhnCZuqx0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=sp0t4USJ; arc=fail smtp.client-ip=40.107.237.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f0I9SVHtnx+UzAVRS6mhVHkxKqwp5rpbKtikaLfGMh8Cks6tzBBMH3vD0avsctZBp+11rSygrUsfa3kbDsrglOiOcUCh3DnJMcEJ8ZaD4Hy8tkIh0v7n5cJMiUkv33Ng9Tl4zdusH9CrSE9+sQCcViBepThGsQFMwgaO5T0+pW+ue+TPcjY8rTIeaRlQHGzpJgfPvmxEVmdLJRmMsUmNR0lMmeY63YJTWd6kxi6j7/DFlee98nnDmMAafKcSmk4QtaRTjkMpz+21S3WHN8jirvyk4bSx7U+F5lIbOYwA1c3ZvhDJavJ/nPSborkHaP+llwNef402ZyMyUBHkNNluQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fy9mcdjE4LiVdqDI4JLGNYnUPH83yy6kilw1kY4DX54=;
 b=ZXWwgBl9XKaFsVKY3CqfCZ8KS8O6IJO5KUN1Pm5T8hlo72dyNqNapkQQioYLVPWfadXA1UmLAko4Sr2eNXPc+ua73XBtssb9316UG834Ct3mvul/RXCIcDtSHLHRdJsbi5wZFi/yfNmBhoGvDHswNK12WEVf+d/0USzLkLZWwdBy4Nl3/l9Ov7bb6tcZ8hodYihFatLk5FYDaF+UFueKxoiZEUYmCzrEf4sUPsD0XzlXAd5EPBgE0y24QGNbjE0GEuwsW+2ZhduL2pYeXYWntSVpabvy7PJam1AUHQ8gGzuQWa0ptZRSdre9ktj9PJrFG4F0SAuak8E/xZO6bd/zNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fy9mcdjE4LiVdqDI4JLGNYnUPH83yy6kilw1kY4DX54=;
 b=sp0t4USJ2TG3e+l75744c36tkfj3U7h4CUybFY8xmWU7SYZ+N/BAa8pQCrdkvc3F0vqgi+uuSlqxV2Q3J8K1Apuji7+bBeFbis7H3efyKBwSIKwCzcMxE2ixkrkx5tCUPeFpqx+DZIScR6nV1ExFDtihlbmyihGyhEWSEfgHPWY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6608.namprd12.prod.outlook.com (2603:10b6:8:d0::10) by
 CH2PR12MB4119.namprd12.prod.outlook.com (2603:10b6:610:aa::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8534.42; Tue, 25 Mar 2025 12:10:56 +0000
Received: from DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627]) by DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627%4]) with mapi id 15.20.8534.040; Tue, 25 Mar 2025
 12:10:55 +0000
Message-ID: <e86f71ec-94f7-46be-87fe-79ca26fa91d7@amd.com>
Date: Tue, 25 Mar 2025 17:40:45 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v2 05/17] x86/apic: Add update_vector callback for Secure
 AVIC
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Cc: bp@alien8.de, mingo@redhat.com, dave.hansen@linux.intel.com,
 Thomas.Lendacky@amd.com, nikunj@amd.com, Santosh.Shukla@amd.com,
 Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com,
 x86@kernel.org, hpa@zytor.com, peterz@infradead.org, seanjc@google.com,
 pbonzini@redhat.com, kvm@vger.kernel.org, kirill.shutemov@linux.intel.com,
 huibo.wang@amd.com, naveen.rao@amd.com
References: <20250226090525.231882-1-Neeraj.Upadhyay@amd.com>
 <20250226090525.231882-6-Neeraj.Upadhyay@amd.com> <87jz8i31dv.ffs@tglx>
 <ecc20053-42ae-43ba-b1b3-748abe9d5b3b@amd.com>
Content-Language: en-US
In-Reply-To: <ecc20053-42ae-43ba-b1b3-748abe9d5b3b@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0216.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:ea::14) To DS0PR12MB6608.namprd12.prod.outlook.com
 (2603:10b6:8:d0::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6608:EE_|CH2PR12MB4119:EE_
X-MS-Office365-Filtering-Correlation-Id: 660c38d8-aa8f-4321-99de-08dd6b96182c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RmwyLzZkWG96Nm1ucWUvZ3ovandxbkhaZll5Vk83ZTkvcDZjb2dQdjd0Y0Jx?=
 =?utf-8?B?N2hxQUhVbTVxODZ1ODRWMzBIbi9WL3VmQTBzVkJyeXIvTlZPdUMrNHZZSHhF?=
 =?utf-8?B?SXE3WTB2ck9UTDRFYzFUc3hlUnp5aHhIQUxlSm9md3NzbjVFYzhCdllxMTVq?=
 =?utf-8?B?cy82RjdaaTFINkI2akM0VklRR3ZtS3g2R2xEbDNBbk9mK2pLVDhQR1ZRUGg3?=
 =?utf-8?B?c2VGTlk1NnQxTXhXS2oxd05iSGg3ZzR0S1luQjQySTZlb2U5VVFlU29hSWpo?=
 =?utf-8?B?Q09kL1kxUGw2ZlJSQ0s3TFlXaCtVVHRkQWJjZXFSb1RjT0pUejZnVlY0b1ZE?=
 =?utf-8?B?YVlodFdXNmppMGlJQkJ3bnZoTGhtbUtBalJ4WkVCM0N1QXhuaFkvY3lkWThB?=
 =?utf-8?B?MXRodGt1aDB5MkJaNmFpZEJBUFpZNTdzb2FMTXdUS3JoVVRHbmcyckljNWpz?=
 =?utf-8?B?c1FjVnpVYlR0SHJtK2RMVWdEY254OWhBd3ZGRitUQ3h2a3dkWmFzYksvWUZ6?=
 =?utf-8?B?U01pM3EvOWF3ckNreEgrYzFVU2NuVkJ4eU1JMHhtT21RUi95ZkVEb1pzRWV4?=
 =?utf-8?B?QjVlZisyT3p5dzJLSnN0YklQclpxbkNRSjNGU1lES1MyMHpVNHF6TFBDbkM1?=
 =?utf-8?B?emVjRDFSZmVwc3hOQVQrLzc3a3FQakJrOEFRV1o1K3luZzNlVFRBQTRKU2c1?=
 =?utf-8?B?Q01Cc1VIYVpNRDdDNG1zYWM2TzhuSFZ4cngyM1NPRTRaaW8vUlBHbll5NVRp?=
 =?utf-8?B?bG9Kd25pem95VlFzY29hY21ZTUh5QlFzb21JR2NqeTdCVnhDUWk3ajJhTEhn?=
 =?utf-8?B?bzlLbkpVNE5QK2c3MndOTkZZdnF0SmdIbTBnRTlGajdRWW1udGJ2KzdXV2tu?=
 =?utf-8?B?aXVweXBzWUFoUDNnUS9meHBhcmE5Tk4xNk4xODFrV25LME1LeGVoc082bWJx?=
 =?utf-8?B?QnQwYlNIcU50ZCtUck5PSXBqaVJ2YW0yS0gxNTJSWldvV1lnUzkvQkszYzBa?=
 =?utf-8?B?ZmxpYXBrd1ZMNDArc3N6Sm1Wc3Z5Z1BVZHlZTExqQ2dCUFRBVDY2OUJMSlZ0?=
 =?utf-8?B?dm8rVk9CN252WDdtL3o2VkdGSyszYU1MYTdRUE5pT3hoSTVPaWg3V2ZPVjF3?=
 =?utf-8?B?SXJnaSt2Ni9sY2ZIZktrRXpaNkNTSnM0RGdKVEk3NFVYRElVT2ZoL0VNNlJB?=
 =?utf-8?B?ZXpJRk9LYU10dmJuLzRLcGJYelFablZ2OC9acERqdkdGSy9FWHgvQ3dIZ0RH?=
 =?utf-8?B?ZksrN3YwUU9LRFk3S1d2NXkrRHhVZFVIT0JwOEhnRlhZUlZNNmNsZlREdThT?=
 =?utf-8?B?aklWRUpzdW5QTml1QnM0WGRxbmo2U3F2Y0szVzNwSnF0U29kQlhTWlQ2Mko0?=
 =?utf-8?B?ZHBIbS9LVkdCY2YzK2hpQ1FSSWJOai9HUys3WVd6dVhVN2RNalFJZ25LeGZD?=
 =?utf-8?B?TDUwVUZQUFFvWDVwcGpEaXFsY3pUZ2s0MXg4UkhwNzBINTJZQVhjNnFrS0xE?=
 =?utf-8?B?MzBzQzkzVWY0bE82RHkrWVBGUjdqMnBFQ3hMQnVSUjU2NGJnWlQ4c1lNbGQr?=
 =?utf-8?B?QVI0WlA1M1R1MjBZY0YxZ3hQdmN5K1U5dDNsRUZpdFlCbGJJdm9OcHdpVUo1?=
 =?utf-8?B?R3IrOUt2ZThEa1cwWEVScFc3OWF5WnlBRzM5ekVXMklBMjdjcSs5a0VrSFRC?=
 =?utf-8?B?NzRZakRYYVZ0QlVGOHFJbTZnYUp4U2FmOWE0Y1RxVDhra05ZM1daKzBRZHlo?=
 =?utf-8?B?emlTTk5DWVJXb3dJaVBsdXNQSVN0eVJBaVdXNXVBc2svZTFwUFhRRU1UYWFw?=
 =?utf-8?B?NE9xbFBEMlhpckNIUCt6L2R5WTZpdHVsem1tM2FlUFFlY2NpSEpXQzIwNzNY?=
 =?utf-8?Q?e8T2WKoHpDDYk?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6608.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ekRxUUFiSEpmdkcwVTdnY0duOVdPK0haR3pwSk5ZaHdTOENkczBjaG9MWmd4?=
 =?utf-8?B?QnhvdXhoa3BIb0pENFhNTEc4TVQwQ0NVS2g5M0pHOXQ3QUE2aGFFYTVoUU1s?=
 =?utf-8?B?d3BOczhTOGN5UFFxL0pua3BreTFQQzZ3cStnQjZxdzdxRVFsWTNDZk1LSG0r?=
 =?utf-8?B?d3AxQUU4V05MMmgxZmVRaEQ2ZVZTS1Zvd2kvU1Q1aVdXV0pFdlkvNXpyOTVz?=
 =?utf-8?B?YjRINllRb3YyTERIdUZtNWRMelMyc2hoUm9YeW5sdklmc2gwczNZNFhLNnhF?=
 =?utf-8?B?T2dLeVgwK3k3SEVVYW0xQmlZbC9oTXRITG5aaFdGUys3WWpmRWk3RytCREFp?=
 =?utf-8?B?SUZYNWNMazZBSktkaTZva25UWEVvNXBjRE15QjhQNE55UERBNUxkZks0ODZo?=
 =?utf-8?B?cWE4T0F1WTlHSTFERlFnNVpReDlyV3JUclU4WDl5QmZORnhwblQyc1Vhd1U3?=
 =?utf-8?B?WmhwOTQya2pZbjlzdFIzR1NmRjNWKzFlbG1rU0Yya2xSL093YmRtL3VaY3Zi?=
 =?utf-8?B?bGJPdVd4V0tGOU1TYXN1bkIvUWNyeVlUZVgzd29jdXE0cW0xbklMdE5td3Rt?=
 =?utf-8?B?NXd5TEFxK2F5RUJ3Z3hKM3JnL2p2NzY1S2x5WmIza2xzV21ZSENFNVFnVXNx?=
 =?utf-8?B?ZklqeGJTWXRWS2FBa1prNkNNWkNPdUZSamZkVkR0R05LbFpaSkJXblc1Vmov?=
 =?utf-8?B?aGh1M25xV0FiUk1xREFodkhZZ01lK253SjQxQUZHRUNpU3ZuZkJBUDk3SlFz?=
 =?utf-8?B?RmYwWkxWUktoeUNRMHFHSEd4cXhndG9oMzZqUjVKY2o2N2VSTDlkQzVpZmla?=
 =?utf-8?B?V3dRTVlzRFJaakZhcGRsamhzMzJQWDFLSVhXRk9VVnNSK3IweXltcmpkUlpS?=
 =?utf-8?B?cWMzNGdSZjltbmc5UGo3TEloTHROUW1mb2dSOXMwZWpZNTdJR0dlQmR6Mk1B?=
 =?utf-8?B?OUZ1M3ZLRHdRR3krSWNtT2xuQVhwT1BWWk9XWGIyOWlBZ1ZZbHJSbUtyQ3cv?=
 =?utf-8?B?WmpUcVFJc0UrQndpd3A3RXVYYU16UFBIMENrUmx6VDlBWFRiZnVRNU5hWFlW?=
 =?utf-8?B?YjhZaHRRVW9uODMzcmNpRjdMdzhqT3ljWm9EOEZTMEwzbXhydzB2d0dMdDlk?=
 =?utf-8?B?NzF6MCtBMnZ5bjhqVm16c2RkWHBQdGhlU1FEbThOUUNaYTRkRGtIdFpvQ1JV?=
 =?utf-8?B?WnBMV3A0aGxBWHJON1VYUDBPdCtSK0liUlQrRmN6aS83K0hDUWtDOFB6VGlv?=
 =?utf-8?B?VE1ia0JRVnNaOFlXTkQzL0hxRjRSL3kxbkFTd3BKbHRwWnhmYlJKN1QzdjVM?=
 =?utf-8?B?Tk9pc1cwU3E2bmphTHBWdzBncVdmUnBTZUJUUktqcDBOSlUwaVZoRFVUNCtQ?=
 =?utf-8?B?UjdGdDZ0QjQ1Q1BucC96Q0wyekFiUGVMODFTRzVRWmg3Z2lqNU9EcUxHck44?=
 =?utf-8?B?dGVIMmVxZmp2czh6SDdZKzc0MlhqNTBJWHY5YmE3UGJ3T0VtUi9WSDBVYVdt?=
 =?utf-8?B?K1VWOUdqNVRmV2p6cGV0UytsVkQwQXgvWjR5bW9URGZLc2lGckRWNnllTTFI?=
 =?utf-8?B?MnIvVVhTaUZOZytvb3U0VFdtM0ZyVUJwTmh1anJqY3pITkhlL2RzUXNlSW15?=
 =?utf-8?B?WEhVTllXM08rWTBvcWpQczJnUUwvU3QySWJXSmVOdE5XVml5MFk5SjFtQUIz?=
 =?utf-8?B?S2RBTG1SdFIydHpaOXllQjV6Z0trOThmeGx3WURWNWp6Zk44aUZudlUxS2I3?=
 =?utf-8?B?UFk3ejRjNS9OVGsvcmxGZGJ4My9oTHFsUEZEMmhSUDc3djdvZi9TaHRPWHpJ?=
 =?utf-8?B?YjF2M3EwOW1RRGFzNG5XcHBFSVlsS1Y1NGg2b2xpMDZZaEtJVld1T0lKaDdw?=
 =?utf-8?B?MGFMZ3NWK29OeDhIU1lwcDc0S1ZyaFhhSWlpeVUveER0eDBueThMckhlMEF0?=
 =?utf-8?B?M2I3S28xMSs2clJDRnVGL2NhZEtPaHM0Z3ZDamk4THdsMGdXNmtWV2lTR0RL?=
 =?utf-8?B?bE54VTYxYXA5K2NpVUhCNzA0aW5RTnZXUDFWKzFtdHBpSlVPQ1QzTmxhcDRI?=
 =?utf-8?B?a3kvWXRQanY0OWNBSUlDNm1CN0lRVW1PNEFadWxNbkl5bnhWY29hZXhFNytp?=
 =?utf-8?Q?sw/iCJMhCJkh32uSikIecsrSd?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 660c38d8-aa8f-4321-99de-08dd6b96182c
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6608.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2025 12:10:55.5816
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G9IMwEtOFgUPUEDCnLhaY+NzcPIuLWKqNhBGmJ1+mCMwSystxyD+Skk5AAimOkayN850b4VBXkxQBLzGxQLtbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4119

Hi Thomas,

On 3/21/2025 9:05 PM, Neeraj Upadhyay wrote:
...

> 
>>> diff --git a/arch/x86/kernel/apic/vector.c b/arch/x86/kernel/apic/vector.c
>>> index 72fa4bb78f0a..e0c9505e05f8 100644
>>> --- a/arch/x86/kernel/apic/vector.c
>>> +++ b/arch/x86/kernel/apic/vector.c
>>> @@ -174,6 +174,8 @@ static void apic_update_vector(struct irq_data *irqd, unsigned int newvec,
>>>  		apicd->prev_cpu = apicd->cpu;
>>>  		WARN_ON_ONCE(apicd->cpu == newcpu);
>>>  	} else {
>>> +		if (apic->update_vector)
>>> +			apic->update_vector(apicd->cpu, apicd->vector, false);
>>>  		irq_matrix_free(vector_matrix, apicd->cpu, apicd->vector,
>>>  				managed);
>>>  	}
>>> @@ -183,6 +185,8 @@ static void apic_update_vector(struct irq_data *irqd, unsigned int newvec,
>>>  	apicd->cpu = newcpu;
>>>  	BUG_ON(!IS_ERR_OR_NULL(per_cpu(vector_irq, newcpu)[newvec]));
>>>  	per_cpu(vector_irq, newcpu)[newvec] = desc;
>>> +	if (apic->update_vector)
>>> +		apic->update_vector(apicd->cpu, apicd->vector, true);
>>
>> A trivial
>>
>> static inline void apic_update_vector(....)
>> {
>>         if (apic->update_vector)
>>            ....
>> }
>>
>> would be too easy to read and add not enough line count, right?
>>
> 
> Yes.
>

As apic_update_vector() is already defined, I used apic_drv_update_vector().
 
>>>  static void vector_assign_managed_shutdown(struct irq_data *irqd)
>>> @@ -528,11 +532,15 @@ static bool vector_configure_legacy(unsigned int virq, struct irq_data *irqd,
>>>  	if (irqd_is_activated(irqd)) {
>>>  		trace_vector_setup(virq, true, 0);
>>>  		apic_update_irq_cfg(irqd, apicd->vector, apicd->cpu);
>>> +		if (apic->update_vector)
>>> +			apic->update_vector(apicd->cpu, apicd->vector, true);
>>>  	} else {
>>>  		/* Release the vector */
>>>  		apicd->can_reserve = true;
>>>  		irqd_set_can_reserve(irqd);
>>>  		clear_irq_vector(irqd);
>>> +		if (apic->update_vector)
>>> +			apic->update_vector(apicd->cpu, apicd->vector, false);
>>>  		realloc = true;
>>
>> This is as incomplete as it gets. None of the other code paths which
>> invoke clear_irq_vector() nor those which invoke free_moved_vector() are
>> mopping up the leftovers in the backing page.
>>
>> And no, you don't sprinkle this nonsense all over the call sites. There
>> is only a very limited number of functions which are involed in setting
>> up and tearing down a vector. Doing this at the call sites is a
>> guarantee for missing out as you demonstrated.
>>
> 
> This is the part where I was looking for guidance. As ALLOWED_IRR (which
> tells if Hypervisor is allowed to inject a vector to guest vCPU) is per
> CPU, intent was to call it at places where vector's CPU affinity changes.
> I surely have missed cleaning up ALLOWED_IRR on previously affined CPU.
> I will follow your suggestion to do it during setup/teardown of vector (need
> to figure out those functions) and configure it for all CPUs in those
> functions.
> 

I updated it like below. Can you share your opinion on this, if this
looks fine or I got it wrong?

diff --git a/arch/x86/kernel/apic/vector.c b/arch/x86/kernel/apic/vector.c
index 736f62812f5c..fef6faffeed1 100644
--- a/arch/x86/kernel/apic/vector.c
+++ b/arch/x86/kernel/apic/vector.c
@@ -139,6 +139,46 @@ static void apic_update_irq_cfg(struct irq_data *irqd, unsigned int vector,
                            apicd->hw_irq_cfg.dest_apicid);
 }

+static inline void apic_drv_update_vector(unsigned int cpu, unsigned int vector, bool set)
+{
+       if (apic->update_vector)
+               apic->update_vector(cpu, vector, set);
+}
+
+static int irq_alloc_vector(const struct cpumask *dest, bool resvd, unsigned int *cpu)
+{
+       int vector;
+
+       vector = irq_matrix_alloc(vector_matrix, dest, resvd, cpu);
+
+       if (vector < 0)
+               return vector;
+
+       apic_drv_update_vector(*cpu, vector, true);
+
+       return vector;
+}
+
+static int irq_alloc_managed_vector(unsigned int *cpu)
+{
+       int vector;
+
+       vector = irq_matrix_alloc_managed(vector_matrix, vector_searchmask, cpu);
+
+       if (vector < 0)
+               return vector;
+
+       apic_drv_update_vector(*cpu, vector, true);
+
+       return vector;
+}
+
+static void irq_free_vector(unsigned int cpu, unsigned int vector, bool managed)
+{
+       apic_drv_update_vector(cpu, vector, false);
+       irq_matrix_free(vector_matrix, cpu, vector, managed);
+}
+
 static void apic_update_vector(struct irq_data *irqd, unsigned int newvec,
                               unsigned int newcpu)
 {
@@ -174,8 +214,7 @@ static void apic_update_vector(struct irq_data *irqd, unsigned int newvec,
                apicd->prev_cpu = apicd->cpu;
                WARN_ON_ONCE(apicd->cpu == newcpu);
        } else {
-               irq_matrix_free(vector_matrix, apicd->cpu, apicd->vector,
-                               managed);
+               irq_free_vector(apicd->cpu, apicd->vector, managed);
        }

 setnew:
@@ -256,7 +295,7 @@ assign_vector_locked(struct irq_data *irqd, const struct cpumask *dest)
        if (apicd->move_in_progress || !hlist_unhashed(&apicd->clist))
                return -EBUSY;

-       vector = irq_matrix_alloc(vector_matrix, dest, resvd, &cpu);
+       vector = irq_alloc_vector(dest, resvd, &cpu);
        trace_vector_alloc(irqd->irq, vector, resvd, vector);
        if (vector < 0)
                return vector;
@@ -332,8 +371,7 @@ assign_managed_vector(struct irq_data *irqd, const struct cpumask *dest)
        /* set_affinity might call here for nothing */
        if (apicd->vector && cpumask_test_cpu(apicd->cpu, vector_searchmask))
                return 0;
-       vector = irq_matrix_alloc_managed(vector_matrix, vector_searchmask,
-                                         &cpu);
+       vector = irq_alloc_managed_vector(&cpu);
        trace_vector_alloc_managed(irqd->irq, vector, vector);
        if (vector < 0)
                return vector;
@@ -357,7 +395,7 @@ static void clear_irq_vector(struct irq_data *irqd)
                           apicd->prev_cpu);

        per_cpu(vector_irq, apicd->cpu)[vector] = VECTOR_SHUTDOWN;
-       irq_matrix_free(vector_matrix, apicd->cpu, vector, managed);
+       irq_free_vector(apicd->cpu, vector, managed);
        apicd->vector = 0;

        /* Clean up move in progress */
@@ -366,7 +404,7 @@ static void clear_irq_vector(struct irq_data *irqd)
                return;

        per_cpu(vector_irq, apicd->prev_cpu)[vector] = VECTOR_SHUTDOWN;
-       irq_matrix_free(vector_matrix, apicd->prev_cpu, vector, managed);
+       irq_free_vector(apicd->prev_cpu, vector, managed);
        apicd->prev_vector = 0;
        apicd->move_in_progress = 0;
        hlist_del_init(&apicd->clist);
@@ -528,6 +566,7 @@ static bool vector_configure_legacy(unsigned int virq, struct irq_data *irqd,
        if (irqd_is_activated(irqd)) {
                trace_vector_setup(virq, true, 0);
                apic_update_irq_cfg(irqd, apicd->vector, apicd->cpu);
+               apic_drv_update_vector(apicd->cpu, apicd->vector, true);
        } else {
                /* Release the vector */
                apicd->can_reserve = true;
@@ -949,7 +988,7 @@ static void free_moved_vector(struct apic_chip_data *apicd)
         *    affinity mask comes online.
         */
        trace_vector_free_moved(apicd->irq, cpu, vector, managed);
-       irq_matrix_free(vector_matrix, cpu, vector, managed);
+       irq_free_vector(cpu, vector, managed);
        per_cpu(vector_irq, cpu)[vector] = VECTOR_UNUSED;
        hlist_del_init(&apicd->clist);
        apicd->prev_vector = 0;


...

>  
>> Als I have no idea what SAVIC_ALLOWED_IRR_OFFSET means. Whether it's
>> something from the datashit or a made up thing does not matter. It's
>> patently non-informative.
>>
> 
> Ok, I had tried to give some details in the cover letter. These APIC
> regs are at offset APIC_IRR(n) + 4 and are used by guest to configure the
> interrupt vectors which can be injected by Hypervisor to Guest.
> 
> 
>> Again:
>>
>> struct apic_page {
>> 	union {
>> 		u32	regs[NR_APIC_REGS];
>> 		u8	bytes[PAGE_SIZE];
>> 	};
>> };                
>>
>>        struct apic_page *ap = this_cpu_ptr(apic_page);
>>        unsigned long *sirr;
>>
>>        /*
>>         * apic_page.regs[SAVIC_ALLOWED_IRR_OFFSET...] is an array of
>>         * consecutive 32-bit registers, which represents a vector bitmap.
>>         */
>>         sirr = (unsigned long *) &ap->regs[SAVIC_ALLOWED_IRR_OFFSET];
>>         if (set)
>>         	set_bit(sirr, vector);
>>         else
>>         	clear_bit(sirr, vector);
>>
>> See how code suddenly becomes self explaining, obvious and
>> comprehensible?
>>
> 
> Yes, thank you!
> 

After checking more on this, set_bit(vector, ) cannot be used directly  here, as
32-bit registers are not consecutive. Each register is aligned at 16 byte
boundary. So, I changed it to below:

--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -19,6 +19,26 @@

 /* APIC_EILVTn(3) is the last defined APIC register. */
 #define NR_APIC_REGS   (APIC_EILVTn(4) >> 2)
+/*
+ * APIC registers such as APIC_IRR, APIC_ISR, ... are mapped as
+ * 32-bit registers and are aligned at 16-byte boundary. For
+ * example, APIC_IRR registers mapping looks like below:
+ *
+ * #Offset    #bits         Description
+ *  0x200      31:0         vectors 0-31
+ *  0x210      31:0         vectors 32-63
+ *  ...
+ *  0x270      31:0         vectors 224-255
+ *
+ * VEC_BIT_POS gives the bit position of a vector in the APIC
+ * reg containing its state.
+ */
+#define VEC_BIT_POS(v) ((v) & (32 - 1))
+/*
+ * VEC_REG_OFF gives the relative (from the start offset of that APIC
+ * register) offset of the APIC register containing state for a vector.
+ */
+#define VEC_REG_OFF(v) (((v) >> 5) << 4)

 struct apic_page {
        union {
@@ -185,6 +205,35 @@ static void x2apic_savic_send_IPI_mask_allbutself(const struct cpumask *mask, in
        __send_IPI_mask(mask, vector, APIC_DEST_ALLBUT);
 }

+static void x2apic_savic_update_vector(unsigned int cpu, unsigned int vector, bool set)
+{
+       struct apic_page *ap = per_cpu_ptr(apic_backing_page, cpu);
+       unsigned long *sirr;
+       int vec_bit;
+       int reg_off;
+
+       /*
+        * ALLOWED_IRR registers are mapped in the apic_page at below byte
+        * offsets. Each register is a 32-bit register aligned at 16-byte
+        * boundary.
+        *
+        * #Offset                    #bits     Description
+        * SAVIC_ALLOWED_IRR_OFFSET   31:0      Guest allowed vectors 0-31
+        * "" + 0x10                  31:0      Guest allowed vectors 32-63
+        * ...
+        * "" + 0x70                  31:0      Guest allowed vectors 224-255
+        *
+        */
+       reg_off = SAVIC_ALLOWED_IRR_OFFSET + VEC_REG_OFF(vector);
+       sirr = (unsigned long *) &ap->regs[reg_off >> 2];
+       vec_bit = VEC_BIT_POS(vector);
+
+       if (set)
+               set_bit(vec_bit, sirr);
+       else
+               clear_bit(vec_bit, sirr);
+}
+
 static void init_backing_page(void *backing_page)
 {
        u32 apic_id;
@@ -272,6 +321,8 @@ static struct apic apic_x2apic_savic __ro_after_init = {
        .eoi                            = native_apic_msr_eoi,
        .icr_read                       = native_x2apic_icr_read,
        .icr_write                      = native_x2apic_icr_write,
+
+       .update_vector                  = x2apic_savic_update_vector,
 };


- Neeraj

> - Neeraj
> 
>> Thanks,
>>
>>         tglx
> 


