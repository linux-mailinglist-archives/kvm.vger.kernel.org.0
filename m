Return-Path: <kvm+bounces-29948-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CF3E29B4C2A
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 15:35:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5A3F31F23ED0
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 14:35:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF1CF206E99;
	Tue, 29 Oct 2024 14:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="3Sth9dwP"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2045.outbound.protection.outlook.com [40.107.237.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24C3D202F61;
	Tue, 29 Oct 2024 14:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730212491; cv=fail; b=mTyYPZqbk18H0UBM6mHES1IKSxXFd6hOMhzJT6Dgz+iEU9L8hX2q4njHM4gKLeO32W8iefa3N2jT7RSo9D1miC1QAOWV7mLjiyZD92G3xwa1IihksiVO0cu/7yLQ5YkLls9IyPjdPnQhJ57HgPk2DuiL3zpIWWbQIC5QqVsqESw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730212491; c=relaxed/simple;
	bh=BhnFASkpgGFkC/aWzP3ayu9nzvPG6G5QZ3OHu/nS7uc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=SxscCMg/SgBqiY7oP3LufKgCIluTDq001p30pc/TSBV+uepQ9ZWzTmIy80zJCwkJVrWk4T3yEM+yuOgONhXueCm8jHaIee8Fwey+M1hhdvi+5ikScphnz9vcTVCZazFdH+7ZsdDA7Au1EMTC0nw1NqdqclOHWjf1xVpuX3dPzko=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=3Sth9dwP; arc=fail smtp.client-ip=40.107.237.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HUqvWGkr4+AGlepiblHc1z4S4C//viNFV5bN9NmVcTcnuXeBV8ILOkDeVdmjooW36X1Xhq1Ee8vijCyFm3veKrMSR1eQvngWwWqrhcb63eLYUJWB8Kyb775Ghi6WuNmkO1nBpE8wh7hjarVpWrBvTEtPgHFmDK/9Y8AtefKvtcONruhXQAuXFgemnXdMgmeJzKdGFfhIGjTROxVZFu8em+p0ZhAHKCUikJpx5WeziEVglfwVzon0jhyFhlapLhK/y94wVeYpYyW8i0NEp71chmixiZNHfFeEuoCQQT8OsMRh1V6ds6EQfLnFfhdmF26RfdO+UY24s3sC4KMcGF1OxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CFLbFJ5MBsrJeg2Ac+0CvvWPqHk1vAYm7gutoTdpALM=;
 b=YUkh3M4Ow8HPUqVFCtOal8COgZYXfc/Di3lEYG4EMeuSjHVL6vcov3HwvCLBjqZxbmw9CCSg+reC2AL3w6CSaccw413DfyWUghAJr0i4X/3fXck+KZaTNLcd4IvzFC91KLb+zIqAw+/3qXsdiRqeSA3kYzvwvohjLVnH3/B/Uq+FXNsvAFanBSmftMB+zsGWip51vo+4Hnzq9rGL6fP6QbA1nrYLCHqncPkbHCeTmx81ULOhc6e7tjtFq9JHtdOw1akStnWRrtYweRUU5rayQffU7aw22WhtF+J6AbuDkoy0nJiUgYcg1Qk1KIXkMnDIXAZNKEVq6+wPMrpnGYG0Sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CFLbFJ5MBsrJeg2Ac+0CvvWPqHk1vAYm7gutoTdpALM=;
 b=3Sth9dwPMXMdqzPvhLK135x86aEYDMn6lh33VrQ5RpfHLgJ01kRBTiNoYWRh+LN6BkrrXQZQ4ZwuFry7v0UQ6nx0klS3xPxtapffKHMupxelVxhectFCXu5pxb/djl0daBnFyO0e4QgzYK5mvJ1QZuKZQElk867xY+TK3zX3GBw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by MW4PR12MB6706.namprd12.prod.outlook.com (2603:10b6:303:1e2::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.20; Tue, 29 Oct
 2024 14:34:43 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8114.015; Tue, 29 Oct 2024
 14:34:43 +0000
Message-ID: <47219729-826f-b36b-e124-8ed404e7c6ff@amd.com>
Date: Tue, 29 Oct 2024 09:34:40 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v14 03/13] x86/sev: Add Secure TSC support for SNP guests
Content-Language: en-US
To: Borislav Petkov <bp@alien8.de>, Xiaoyao Li <xiaoyao.li@intel.com>
Cc: "Nikunj A. Dadhania" <nikunj@amd.com>, linux-kernel@vger.kernel.org,
 x86@kernel.org, kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
 pbonzini@redhat.com
References: <20241028053431.3439593-1-nikunj@amd.com>
 <20241028053431.3439593-4-nikunj@amd.com>
 <3ea9cbf7-aea2-4d30-971e-d2ca5c00fb66@intel.com>
 <56ce5e7b-48c1-73b0-ae4b-05b80f10ccf7@amd.com>
 <3782c833-94a0-4e41-9f40-8505a2681393@intel.com>
 <20241029142757.GHZyDw7TVsXGwlvv5P@fat_crate.local>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20241029142757.GHZyDw7TVsXGwlvv5P@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN1PR12CA0073.namprd12.prod.outlook.com
 (2603:10b6:802:20::44) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|MW4PR12MB6706:EE_
X-MS-Office365-Filtering-Correlation-Id: 6406e200-3b19-4a61-75fc-08dcf826d460
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VzFPeFZOMHRXd05XbzRqY0RZdFZiTStZMEpQbW5DNUkrUWJpekgvdU9EZW1J?=
 =?utf-8?B?NDFsTXh5b0thV1RFcENjR3ZtdFFCUDVNUHNpeVVwZzZ5THpYazk4Ry9vL21M?=
 =?utf-8?B?WVZCUjd4UGkzS2NYWFU3alZhMEN6ZmlXOC9FTHRwTCtNeTRKRlA1ZnBNQkRs?=
 =?utf-8?B?L293VnNCNU42VVRhUnVsRW9mZGhxVHBkRm9nUmV4TmxzSGR3Mm1YRkhLVU1L?=
 =?utf-8?B?UFBqaDA5UlBjMDdFZkx2eVVsVUtMZlVFMjRqMHJLeXBkcDZ2cFcrTk1walp2?=
 =?utf-8?B?L0Y1eHpTTGVlZEs4ZmVpTjNSL2RMU3k1dThXZTg4Q3c5RVViak9USGlqUVli?=
 =?utf-8?B?Y0J0emVxaVpnRWpBMDdzTUpWcUEvVzlkdnNhaGhYOUh5R1l6Y0JTVmtpNDFw?=
 =?utf-8?B?UXlFZUlTRXJscmFpcTZBckNGV2ZUd1ZSNVA1ZzNTdkRyMFQ5a1RLMHlkdjRw?=
 =?utf-8?B?MjRPclBqOU0wclhZQlE4UGZGem1kWWl1V0lLQ3V2RFF2OE9EYitKTG5BaThG?=
 =?utf-8?B?UmJNZ1AzR3VoMHB2TlRrTnYxa05OcmNLTU9sTTYzQUl4dXlEU3cvZ3hoUDQ3?=
 =?utf-8?B?L1Y3eWlTQVNiUXY4NkhsdFZTdC9ZWGxUcUo2TEVOMUZlMXFnOU1tOHlZMzZR?=
 =?utf-8?B?WHR0ZFpzYUtWMUl6anB0V2FVdFFlRjZLN2l5aVR0dXYzMjZvN08vR1ZrVmlV?=
 =?utf-8?B?aHIzZ0JYb0lWOUpsMTJQemUvK0NPU0ZYVWNjaTBSMDVBbExHSmtZcytRZlJG?=
 =?utf-8?B?NUNmUFI0c2NkYThTcG1LUlhHbmlINFNjNGVEcllKSXhzWUhtd0UwdkFWMlhy?=
 =?utf-8?B?THpIcFFqUm12ODdBdWZrR1g1UGJ6TVE1TXdFWVI5Q3QyVXpPNXRZUE4zT1gr?=
 =?utf-8?B?RGdFMjROUGM4Y3JiZ1FTMlVaSnFuRDRGTWZDbk5icU1ndUFGTU9pc0luT2Ew?=
 =?utf-8?B?U1VLaXdTZE1OeDBQZVVIeFZNbFErbklKQ3JmaFNnbkFXY0RNWHB5cmRsMlY1?=
 =?utf-8?B?RndrZThpajRKZUdyNVIvTFpzYW9YWlQ1dWhzWGlNZ0Y2TXlnQnE1eHFVZjMz?=
 =?utf-8?B?a0VsQ3ljRkxCSUtoem5VWHBEMHhlY0xRcGN1MXNMVmlXNEhoRjk5MVBXVU5x?=
 =?utf-8?B?SWhad0h0c3g2MTc5cUl2T0x1OTlvd3VWUWRmK3h0dUp0VDhySnZSNWRYMURz?=
 =?utf-8?B?NFFQcFFIRVRrRWxqOFp2dE5wMUdUZURIKzFYUlg3Q2NCVkZtUkhTUFNDTkFP?=
 =?utf-8?B?am9nZ2hwYUZkeTVIYUg4aEVOQnhQWnlBVDBmb3NFMW55OHBHU3pVczRBUW1X?=
 =?utf-8?B?cWNESFBzV2dINGdHQy8xc09ZYmxTaDBMSk4ra0V5WG9paXRPWVI0TkJTUW9S?=
 =?utf-8?B?dWhBR0tHTjlvelNVZkd4dW9YNU1VYUN4ZlpFSGNaVysyS2o3SXVwYitmLzBQ?=
 =?utf-8?B?TGV2NTdLZHF4Qjlka1ZYRjZUekZZekRoOHhGd0hqa21kZEI1V0VKeTJSZ0V4?=
 =?utf-8?B?TTJ0TExXZWNjU3MwWElyZmE0UVhFVUk4MnF5aElmRjJlVmFZZldWMDAvSlpu?=
 =?utf-8?B?emYxQlhWdUM1YzNTS3BWSnAzZEl1aFR6UktjSTRNeE9kUmRYQzB1YTdwaFJ1?=
 =?utf-8?B?ZnNSS2E0ODllck80Ni9yaVJGWm5rTUpqOXQwZWN5NzlYR0NmMkdZOXNranZy?=
 =?utf-8?B?djQ3MXpyUVgvSldhSG12bmVxNFdRZ0ZMWGNYZVBLOFZNd3dnSzdLaHFrYmtE?=
 =?utf-8?Q?1sPTj5OOUMDi5BDRR5zXo0hyetsEGi7UVkJ3S2X?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NDB1cVdyYmEzalI2Y1Z0Z0t4ZyttcXBkSDBGcWRnOHlOZlBrOEhVZnFLSURU?=
 =?utf-8?B?d3Q3M1ZRdWVydmN3c2lHeGtYYzVjM1UwVlNiWHh3S1d2Y241dVp2V2NEYWgw?=
 =?utf-8?B?T09Jdnp1VXk0OEFCYndJVHkrY1hCQ3VZMmVseTRubE5yRkd0ZUxSZVRYU0Zu?=
 =?utf-8?B?UnVsUmk0UUZ2aDl0ZUVvUFVXU1dOU2J6ZkZKb3kwYWRSSlBqeVFoZytOTUVJ?=
 =?utf-8?B?S2M3OVRRcGhmRDJDRDRZa0JueW9YbUh1bVpBK3NBeVRWQTdJbkNtVERPc2s1?=
 =?utf-8?B?NmhSMDdWcXBTWE52UyswZVFKZTFRZWhTUHJlbDR0WGZJOW5SS3crUHNIRFhl?=
 =?utf-8?B?eFl2eUhOZkVscTE5SkVrNnFFd3YvaDhsdUk3enIyQXlCMzBFQm1iQ3pNc0J5?=
 =?utf-8?B?L1Bzekh3eWlGSGV6RmFsUzAweFoxcVhzSnVQZzl2RUkwcWJyaWlqR2J2TmxJ?=
 =?utf-8?B?d2RBUEFndVAzaFUzNXU2SUF4UVdja3NWTzRuc0d4UndsSTFUQnZXa1lETTFa?=
 =?utf-8?B?bk4rYnJTeGdqWkRpZ2xiRUNCRmRIZ1NLbTJVb05BMkozejRsYnFhNkxvSVJs?=
 =?utf-8?B?Yk56SG8zU25DeUlYRFM2RTFNazdrS0NaVGFhL2JXNjFpazRxKytHL0tuM0tK?=
 =?utf-8?B?MVRxd3JUeFVSSUtSbDMvZGkxeUVQUHRKbUpJajdCUG44TEFmbXg5RmZkMC9w?=
 =?utf-8?B?ZGVrZzdMeWNQbDl3TkpSUU9Bb2N1VWhtRXZOVHNWOHdFaFg3bUpFcDZjTzd4?=
 =?utf-8?B?ZXY2R0N5bElQK1N2cmZjMHlSL0g5S3lMZURhcFVyRFY5VlVQVHowQ0RCR0hV?=
 =?utf-8?B?QnBXMHFvR2ovU3lNSFltVTBOYU5wdUc4Zk9HL3ZLSWNZQ1JaMll3THZZbFJN?=
 =?utf-8?B?YVB3Z085TjJYemNMbWpGbHpFSkphbVhMc2dtVzNIMW50M3Z5WGpDamRWNHZy?=
 =?utf-8?B?YUNDV3JCck5Jd2J6dEtSQUE5TVBBc2VmeXpFbnNBaXFNL0Y3Y2FpSG02WlF6?=
 =?utf-8?B?VWo3WVVsd3ViYW9KckI5MG9naG13QjVkR1FjbW9TL0lGdnRhdGxONjAwRkRv?=
 =?utf-8?B?dmExVUxEZTBUWGE0UHEvM2Ewb3QrbThlVkNmNGlrTHM3cCtYTnE1bU1xeUhH?=
 =?utf-8?B?cHcwT1FZRjRvdTJISlArRzNCK0duWnRVcWlhWk1hTHNOZ3VaRkd5K0ZzRWJC?=
 =?utf-8?B?UmVMUEp4WTltdVpKTDRMZUJuRUZrTHhML3FMNHNqaUJUZTFSNFVMZDgwUng1?=
 =?utf-8?B?cjN2b0dmY3VGbkM1YUwxNFhaNTJwT3dRL3VzcTNDZU1OSjdnU2dQQkZBeHZh?=
 =?utf-8?B?WGVzeTljQ0pYWGVZNVpoQThvZldQaW5YK3J4enZqSXFBUU1XeTBDNWl1M1BT?=
 =?utf-8?B?OTZYaGNXUEZoajl4Y2tXMWxvMkl6MkN5QUlYV2hNSmZod0N3Nm9ZKytjZ0xa?=
 =?utf-8?B?SUd2SzZBeUx6YlMxTEtlWGZ0em5qYUFyUHBsamhobUlJa2Z4a28yMmZPT08r?=
 =?utf-8?B?Wng5M3lLL3ZGYUF6QlgwME80T0JYdXJUNk1KcXdYbHFWZFdtMnd1ejZtVHl5?=
 =?utf-8?B?K1hVbG5uaHRSQnVxZGdKTHNrTGFCWUc5UTJ5SlVGekFBTGR2VXZ1end5djFh?=
 =?utf-8?B?MkZNc3VXdlBJR1NLcHNPd0FTYy9nVjlnQWlBbHJYZ3JVcmgzZkRvRHhBdldW?=
 =?utf-8?B?ZGRRSVpoMUw0QWFSQjU3NzJYOUdjSWR2b2hzZStCRDFYMlR1RjBJM2VldGk2?=
 =?utf-8?B?bUoyYmRmYzhZUHNFc2orRlVOa0d0U0ltNDVvVDNzTVNtTTRDU1B3ZVhSY0Nm?=
 =?utf-8?B?SnArdnpNaFV2VlE3ajZUcGZoOTFDcFJuOE1mOXlTeXJkM3IrblNJU09VOVVW?=
 =?utf-8?B?QjgrTGhVREM1NFNSU0c5VVM0R29xMkptcXpnd1B3bTh0Y2NscG56L2psK1RT?=
 =?utf-8?B?RDdFMlBwaGFSU21wVXZ0SE9YMkJ0VzRuRHN0SlByRWlvWlpnWGtEVlR6akRk?=
 =?utf-8?B?dzZjN3dtekFZM01IUWFudXd1SURKN3paSVNyNWVmaTFmNkVGbmphOFR0SXE2?=
 =?utf-8?B?cjZRWERBRlFmRVllNWZsMTdRdG5UYnp0VllNQUd5S3orSFU1UUN2dnJRZUZ6?=
 =?utf-8?Q?mvnIssxpF8oLRRDNiB2r7mIk+?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6406e200-3b19-4a61-75fc-08dcf826d460
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2024 14:34:43.7132
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E2wfwjXSSDtWoeAx/vXBgeAp6fn3FYyfMzqLH3yq90NpEzwr1AevURNYRDyD2OGgrXYKgNUHUjjHF5RbToLxVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6706

On 10/29/24 09:27, Borislav Petkov wrote:
> On Tue, Oct 29, 2024 at 05:19:29PM +0800, Xiaoyao Li wrote:
>> IMHO, it's a bad starter.
> 
> What does a "bad starter" mean exactly?
> 
>> As more and more SNP features will be enabled in the future, a SNP init
>> function like tdx_early_init() would be a good place for all SNP guest
>> stuff.
> 
> There is already a call to sme_early_init() around that area. It could be
> repurposed for SEV/SNP stuff too...

Yes, the early call to sme_early_init() is meant for SME, SEV, SEV-ES and
SEV-SNP since we have to support them all and currently does
initialization for all of these. It is analogous to the tdx_early_init() call.

TDX also makes use of initialization that happens in mem_encrypt_init()
and mem_encrypt_setup_arch(), so it doesn't only use tdx_early_init().

Thanks,
Tom

> 

