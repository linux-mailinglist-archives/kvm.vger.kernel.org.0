Return-Path: <kvm+bounces-40212-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A8EACA5420E
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 06:28:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D56033A9C2A
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 05:28:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 602BC19DF64;
	Thu,  6 Mar 2025 05:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="1lq0NwBZ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2044.outbound.protection.outlook.com [40.107.93.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B36E1991B6;
	Thu,  6 Mar 2025 05:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741238907; cv=fail; b=mnN4JzQDb4YdG3gBWlPG7mPU4qSaFE5qMch8Ccd+qnMF8GilrrXpYrB/RZfKsCNk/xqX9gH9bmKtGsi5qeH/y7TM+oj8//11qVk0sm3W/P+6Onsktvr8xGi+8+lRNhEvesjPVVTBtVKbrsVwpru72T+fu2NRB3O62jAOsPI6oQ0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741238907; c=relaxed/simple;
	bh=v/hmMu7dkBBNuBoPJAX+g+l7aay/z+qRFIV03EJ65Rc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=IhmgclJ3yDVNQvhOMu1tN3pR4O9YCkRI1FUz17nwm96YsvAWjD5S6cNkuVnaquZ8HixTvcnlFrE1lf6STxMenLKzzQkfRKw3YzM29q7bMNa0YrwMy2nRRUTfM1ucAB0VwrljHdDfDeOdGObfOApJzLg4TRQGdO0aPP+3aSWzUGc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=1lq0NwBZ; arc=fail smtp.client-ip=40.107.93.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QrxWXxaDYE+xAzKC1XAW6B+oBXMnBhcLho9N5cAzVQB8O0J/C7Qyp+4oCvv7KIcfJLwSesp5GUq8MWNeEkmPedcm2GQRFKh7nPPeE27gVIfLiqd+qcIHgBgK6wBkSVhikOw56L59BJ6wx1f8wqJXDtp+Hih4dFKQNJZk6wWc9haahFiGX0es+x1vwes0QwOjKqeqwfbvnT5oZHt2ib8Ucx4JlZLpb5Op51bkMZXYExaGNTgCtywxmHTJmopOcnCpSOwbvbStyKeGsVJDFtbr1YvXzIeDUiUl0K1R3EE53PWd8288O1PM7YwqsY4v4Oi9fTqfDsA6ighpUfDRXNWh3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QimuvJt2HEK21alb1YgTKNQCLVxBKAHfNdNNTlK18Cg=;
 b=SmcbYVRGWg2Sh8BzlcWNiKdmttzj3kFBC3ImckilW8zPYOUByhfMpH+/AuHvJ/kiJZfGQWCbjxMkTbZqCjU9krPfAFS+mJsjHJv75JiLBaSoTUmSUN96/Hk7Wo4QIqFdXBVgD6KQbXiRfkcT00x/XYcVjZcE/oG4G7eEl8AlZDNJ6d8FPlRjPRcrfOsu/h4T2RVh4UzMawZgQAaB2oNamZG6YTq3Q/7CsWAPwusYR7E2t3xR0AotFRrOjt25VgsLuzwX/tY6QbzzGRMloFZRGRMRf26hchMUJom8ErpJj8iIxt4BAWRQxK9yp/dvktZK2gXGjCOHQmNi2O+/AUPjwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QimuvJt2HEK21alb1YgTKNQCLVxBKAHfNdNNTlK18Cg=;
 b=1lq0NwBZKj56D/PL9svvzAGc1srqhVby2ua9yA6wLXDbD4J3rAYHywtuxeRnWITeZ9t2tYdYjNAyJ+BdoUgW8vUTleJ4cXEWa1lqg1Th6yQW5azJgCCrdZz18DD2ALUyV1wp2JxxyxjKzR7ga/4kMkaxpNb5x/pxBhlBHvjxD8E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA1PR12MB8189.namprd12.prod.outlook.com (2603:10b6:208:3f0::13)
 by IA1PR12MB6353.namprd12.prod.outlook.com (2603:10b6:208:3e3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.29; Thu, 6 Mar
 2025 05:28:23 +0000
Received: from IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::193b:bbfd:9894:dc48]) by IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::193b:bbfd:9894:dc48%7]) with mapi id 15.20.8489.025; Thu, 6 Mar 2025
 05:28:23 +0000
Message-ID: <85d324ff-a1d3-4d7c-ae2c-68588b12deb3@amd.com>
Date: Thu, 6 Mar 2025 06:28:18 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/2] KVM: SEV: Configure "ALLOWED_SEV_FEATURES" VMCB
 Field
To: Kim Phillips <kim.phillips@amd.com>, kvm@vger.kernel.org,
 linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org
Cc: Tom Lendacky <thomas.lendacky@amd.com>,
 Michael Roth <michael.roth@amd.com>, Ashish Kalra <ashish.kalra@amd.com>,
 "Nikunj A . Dadhania" <nikunj@amd.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Ingo Molnar <mingo@redhat.com>,
 "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
 Kishon Vijay Abraham I <kvijayab@amd.com>
References: <20250306003806.1048517-1-kim.phillips@amd.com>
 <20250306003806.1048517-3-kim.phillips@amd.com>
Content-Language: en-US
From: "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <20250306003806.1048517-3-kim.phillips@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0149.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:96::16) To IA1PR12MB8189.namprd12.prod.outlook.com
 (2603:10b6:208:3f0::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR12MB8189:EE_|IA1PR12MB6353:EE_
X-MS-Office365-Filtering-Correlation-Id: e7671b75-0197-4b33-59ba-08dd5c6fb68d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Z2lIcS9adHNJNXZ3NW5YN0JZZEJQZ3kyWVk0bktDTWZ0UjcvN1JDUy9renFP?=
 =?utf-8?B?UnduQ0F3aEVRTERCSi9KYlE3TUVQWFBOYlZ3aTVnMFkzYW5td0Exc1NHZkFa?=
 =?utf-8?B?MFpFV0drTWVpZGErNTVNV1pEcktmTmZSc3FBZ0QyQkZqUDhjK202TXZJbVor?=
 =?utf-8?B?MDJIVVFSdy9Eb2hReW9lY3hJYlFueWM3YWxwZjA0ZE1pVTBzRWVWb25COXJa?=
 =?utf-8?B?b0JlYTErNjdQNys0VWJDZHZXcEFXRnNucTRocnhuMk1uUzBOT1RqTFhqOGJW?=
 =?utf-8?B?QnlaNXh0YVE1SVZ2aWRaeGtidFRYTFdyNjVGaUNZWGErd01VUzE1UDI0RUQ2?=
 =?utf-8?B?aHZlRjZ1S0Y3c2lFNko1N3E0Q1dINXBXMjJBM1l2eldFWDBabVJ3eFlrMHdV?=
 =?utf-8?B?SlBhYURpVzlxaHBkOFJVelhhazR4VzBQdjMvR2UweVdCZ25SYXFwdzFjRHVH?=
 =?utf-8?B?Si9GcUt6Q1RNc2V2RjJmT2kwZU05akhpekFJTHJmYStVazFIdS94aWU2eTc0?=
 =?utf-8?B?TW8yRVRSMzBaWmZPU0xsNDFrV2p6a0lCaGZMVHlEUVNnL2lBSXNPZm1JSjF6?=
 =?utf-8?B?aHpUckhvQkxyVWNMYnJkOUlGMFpTRXErTGF1T25PSDFOMGdMSjVrcml4UXBa?=
 =?utf-8?B?aWdNSzZVWVBoUWxib2hlQU9GUWoxU3dEUnl0NGRURWgxdisrYnRNc3Z3TlVr?=
 =?utf-8?B?ZjV2aTRNUnJmTzJhREpEcldTN1EyUWNJUVJUcHpFczFGdVpRTkEwOU53Q2Jz?=
 =?utf-8?B?b1lKQnB5dS85M2llcC90U0RkckJvL3F6b0JKRXE0K0xtYmZmMU5ORGFVR3cv?=
 =?utf-8?B?NUpxMWFqcUNGTzJjTHE1Wk5GYzExT2svcU5lSXpoM3ZXNCtRV2ZxSkJoT0hh?=
 =?utf-8?B?WC85bDJ0MnB2ZVIyMVUyQUhpeHFhMDY5Y1RPd0dpNXFSZ1VjK1E4eEhNY082?=
 =?utf-8?B?eFVpM3pING5VZjNtQmxVbTRvdGpmeTAyeTF2MlV4Y3lMK3dQNWxjQ01zRnFQ?=
 =?utf-8?B?b1NYRzVuUkdTckFYbFVndXE5cEM2c1dTaDRLOHF4NEVwZ1BZeUVjU1RTUGMv?=
 =?utf-8?B?T3JvMjZUSEl1U3UxUlZLcHF4Z01RMGgyTUJpNWVZSVFRRmQ0Yy9VZU8vV2JI?=
 =?utf-8?B?b0ErS2ZLb2FLLzNEUmY5OUVGanllMDFCV3ZKb2NlNkpUVWFWVUhQTDBkYlVv?=
 =?utf-8?B?OHFZVUd4ajdTb1ZpZERsc0pwNVUzYktmVEJIQUhtMGlVUjh2QXcxWnlsN0c0?=
 =?utf-8?B?K01kS1RmVW5TcFA0M1lPT25CL2VVbXQrMFFkRVdGenYrcWJ2dUgrYnJPL2hI?=
 =?utf-8?B?TzlraHZzV003WW1XeU0ydG1CRlNoaXNMZ2p5UklOQnE1bEFiVmtGVjArdnA4?=
 =?utf-8?B?UXJUbndsaU5QbGp1MzZ2cG0vWXBnaWR0ekxCQnN2amV1UDZhV1NBektwN05O?=
 =?utf-8?B?NEdCSVNrKy9zcW95b1Rka05UUzc5c0NMSXlqR2I5QjJwM09MNnZZSFQxZjRQ?=
 =?utf-8?B?M2pPYkJwYy9hODhNdkI3YjhaWERzTDYrYlZGaW9aNmZuT2xTVUJ4MTNJTFQv?=
 =?utf-8?B?ZzVvSDczaWNzdGxBRUJ1VGlOV3I3T2JZUTk3d09vM3oxaGN5cG5FczQyUjV1?=
 =?utf-8?B?RFhrYm1wT0YrUTZqRGd4WGQyTWM2UFV0Y2ZrVXBPcFhGSUltRWFOU0hxenJL?=
 =?utf-8?B?dlRhWmx6YXpRSk4zeVhleldJNEMwMkpOMzkzcS9VZTI4N3kxc0EzU0U0bU1D?=
 =?utf-8?Q?Yjs+FKeXm82tu5hi20aaJVisooEz3o1aPrNvTj5?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB8189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bElPa1JrOTFOYU5neE9jcnk4OC9CVmhYcGdua1dxVVFVek5kRVZmY05zOUVs?=
 =?utf-8?B?c0gvaGxLZXBtNWowZ21RelNwYjJOTHFwYThuUTVKR3pobmR1WnI3L1QyaXNp?=
 =?utf-8?B?RW5XVFpPVjNRRmFVMTVWalkreW1BRFpYQXI4ajEyUnlHZzdPWHZ4bWpjNEJF?=
 =?utf-8?B?K0dNQmozK1B3dkR4dXJ6aUt1RDB0Y2ZpN2VjanRRaHoxUENiRXdBTkxFajRD?=
 =?utf-8?B?VjF0Y2NaRnk2eFE4OFB5TGh6MjdEc2wrUHMxU1ErUURhNHdFYWkwVFhpMVh6?=
 =?utf-8?B?dFFmc0UvbE1mMENxemd5amNkeEZ6ZFIyWWd5b1hXVnVTRUs3cHlDT1ZZZXha?=
 =?utf-8?B?aWw5K0dLanpRbDl1amVxZzRtbGFwNjFMcFRWcUllNnpLWWFxTzlreEZ5YjZK?=
 =?utf-8?B?QlNXMlhmNjFYcm5MallGVHgraXhPdHZTRE1yZ1RsYnM0WWhNVHpPWkYwKzlV?=
 =?utf-8?B?Y011RHhGeEdySTBZY3VXRHBCSm1kaHdselZvejlVZ256UFZMQUhvVXhrY0ls?=
 =?utf-8?B?Znkxc0JjNC9EdjVaSFdOSWZUb2srR0lKVWFHNkNYeWcwRnB3TGpUaEpNb0Zk?=
 =?utf-8?B?aDZRa3phWW1QVktZcFd3QnlKM0Z1U0xWczV5Ky9IcTg2RzFKSTBqRHBsY3cz?=
 =?utf-8?B?WWdITDJxdklhbDdWV1FOUy80UU1XVkhSMURMbUNjeVRoMjFtK25jZlpYN3Jp?=
 =?utf-8?B?SndWNm9vSEJmR3lOU2FnWktCLzEzZ0kzOEZvdE1UQThIemtaTlpZdjZRWW9Y?=
 =?utf-8?B?MmRybUYrMkZ0a0FETC84LzBNcDdhcEZBQUpTai96dzJPTmJjejZidWpSMVZk?=
 =?utf-8?B?bVRrTU51MW9QYlIxYXRHanZ1T0lWc1NqdVY0bHNTTHNIMTU3M1VLSXZqNHVy?=
 =?utf-8?B?WmFmVDhpUUkvQnIxWHJDemV2KzZBdDU4b1hyU2FKVWwyRDlreDVqcW1JVnl0?=
 =?utf-8?B?dndHNmg1Nm52cWgwbk1JVDlyS1pHZ3pBdXRrR3ZFZHZwcmlQTFVCTVd5MHJT?=
 =?utf-8?B?NUhsL1d6Vks1blJQdFRmRGRrbXlPUldObTlkcHRTUGZmT3ZuTkdhcUovWXph?=
 =?utf-8?B?QTJDaWhHT2xmYjRoV2dLTVVjYWhMMTdwRlBPNXNFRlF2U0pZZFp6VTVpTmtt?=
 =?utf-8?B?ZGRZbStsUTZ0eDh2Z1BUdjk1MEV1OGNzMGE2enNXcFp5aXNIeHFGQVc4Z2NE?=
 =?utf-8?B?Q2M0LzZMbk9jdzFRelZ5MEJCK3AzamNYSWNmdmlNeVJyRDRQSlZmSUxIWE5j?=
 =?utf-8?B?aEM0Mis5ZGpuOEVDMTVtckJENlFDYjh5Y2RYNEo0ZzI5Tkd3VDByOWE0UHlv?=
 =?utf-8?B?T2NqaC94ekJoRlNIMFM3TXhLQ2N0RlFSUWhwaEFTNTdKeWFNUm1WQzhOakN1?=
 =?utf-8?B?cGNDK0FvUTQ2b1FLWk1DYVhnTmprV241Q1ZLbWM3Y0dWYlFBbFRFdk9zZHJG?=
 =?utf-8?B?QWVJWWpMVmdwek9jZGpWVHVjZk5CZmJ4RlJBanpvamhieE5XNmw5bi95bVRp?=
 =?utf-8?B?TFVGTUpCSTZiZVRFdm1vb0lmbTNEZllxcHNBSFlaaHdqZWZ4N1oxd3FwSXl2?=
 =?utf-8?B?MmZscXFnUTB1NWVrK2E2ZjlQREZ6b0tmM0ExWFg5d1ZKMGFmRkRxejBtMVB6?=
 =?utf-8?B?VjVjMFErZUxKandjMFJ2SHREMVN2QWJzdmZQRmhOYUdsRDBZcTFBNVVVWXNL?=
 =?utf-8?B?M3ZYaHJZZEw5alZYL2FoZ0RjZlVVa2p4cHptOFZNREdsR2c1Y1NIUlplT2VK?=
 =?utf-8?B?U1pmRkw1S3RoRGgrbUFlUUEzRUxSTko5VkJKTTVJVFNSbVhkU0RJaHVtc1ZU?=
 =?utf-8?B?NU0vZjlTRmZaWVNlbEU0RVkwZU56WWNKQXpEeVFGM0I4dGtGQzA3UFMxQlZz?=
 =?utf-8?B?WE1Yd0pmMmJXdW1ZOHRWZ2U2Uk44UkViSnQ2dCt0VHVWOG5BNFhxVDAxRWVo?=
 =?utf-8?B?SXlwaEUzOGdTanRIQ3NHWklWcGpscmdtRXlxOXV1YWk1VG16cnRLYXQzV3cz?=
 =?utf-8?B?SlJhYVoxN2QydmhaOHdMZ1FxVHRHZXdPV1lGZUt5VjVSSDVvdkJBTzJkcnpE?=
 =?utf-8?B?TVF1Mng5TDBJNTdQMUFiUWR1N0hoQ1JXQUpUM0lzaW1vdndkWEdVdWNxemNo?=
 =?utf-8?Q?4EnPQ2l/Cimb9E8NVVKiLsJYw?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7671b75-0197-4b33-59ba-08dd5c6fb68d
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB8189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2025 05:28:23.2239
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EbJANFEl1FTt9kMJbTkbXpEKkEWMntkkCV2hEo47IMjFzDmE3BnppOfKThQ8KH2eseULUhEzwF3zfLLxnXUbuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6353

On 3/6/2025 1:38 AM, Kim Phillips wrote:
> AMD EPYC 5th generation processors have introduced a feature that allows
> the hypervisor to control the SEV_FEATURES that are set for, or by, a
> guest [1].  ALLOWED_SEV_FEATURES can be used by the hypervisor to enforce
> that SEV-ES and SEV-SNP guests cannot enable features that the
> hypervisor does not want to be enabled.
> 
> Always enable ALLOWED_SEV_FEATURES.  A VMRUN will fail if any
> non-reserved bits are 1 in SEV_FEATURES but are 0 in
> ALLOWED_SEV_FEATURES.
> 
> Some SEV_FEATURES - currently PmcVirtualization and SecureAvic
> (see Appendix B, Table B-4) - require an opt-in via ALLOWED_SEV_FEATURES,
> i.e. are off-by-default, whereas all other features are effectively
> on-by-default, but still honor ALLOWED_SEV_FEATURES.
> 
> [1] Section 15.36.20 "Allowed SEV Features", AMD64 Architecture
>      Programmer's Manual, Pub. 24593 Rev. 3.42 - March 2024:
>      https://bugzilla.kernel.org/attachment.cgi?id=306250
> 
> Co-developed-by: Kishon Vijay Abraham I <kvijayab@amd.com>
> Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
> Signed-off-by: Kim Phillips <kim.phillips@amd.com>
> ---
>   arch/x86/include/asm/svm.h |  7 ++++++-
>   arch/x86/kvm/svm/sev.c     | 13 +++++++++++++
>   2 files changed, 19 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> index 9b7fa99ae951..b382fd251e5b 100644
> --- a/arch/x86/include/asm/svm.h
> +++ b/arch/x86/include/asm/svm.h
> @@ -159,7 +159,10 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
>   	u64 avic_physical_id;	/* Offset 0xf8 */
>   	u8 reserved_7[8];
>   	u64 vmsa_pa;		/* Used for an SEV-ES guest */
> -	u8 reserved_8[720];
> +	u8 reserved_8[40];
> +	u64 allowed_sev_features;	/* Offset 0x138 */
> +	u64 guest_sev_features;		/* Offset 0x140 */

Just thinking, if dumping error in logs would be
useful for Admin in case of failure Or maybe we
want to leave this to userspace?

In any case, this patch looks good to me.

Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>


> +	u8 reserved_9[664];
>   	/*
>   	 * Offset 0x3e0, 32 bytes reserved
>   	 * for use by hypervisor/software.
> @@ -291,6 +294,8 @@ static_assert((X2AVIC_MAX_PHYSICAL_ID & AVIC_PHYSICAL_MAX_INDEX_MASK) == X2AVIC_
>   #define SVM_SEV_FEAT_ALTERNATE_INJECTION		BIT(4)
>   #define SVM_SEV_FEAT_DEBUG_SWAP				BIT(5)
>   
> +#define VMCB_ALLOWED_SEV_FEATURES_VALID			BIT_ULL(63)
> +
>   struct vmcb_seg {
>   	u16 selector;
>   	u16 attrib;
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 0bc708ee2788..7f6cb950edcf 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -793,6 +793,14 @@ static int sev_launch_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
>   	return ret;
>   }
>   
> +static u64 allowed_sev_features(struct kvm_sev_info *sev)
> +{
> +	if (cpu_feature_enabled(X86_FEATURE_ALLOWED_SEV_FEATURES))
> +		return sev->vmsa_features | VMCB_ALLOWED_SEV_FEATURES_VALID;
> +
> +	return 0;
> +}
> +
>   static int sev_es_sync_vmsa(struct vcpu_svm *svm)
>   {
>   	struct kvm_vcpu *vcpu = &svm->vcpu;
> @@ -891,6 +899,7 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
>   static int __sev_launch_update_vmsa(struct kvm *kvm, struct kvm_vcpu *vcpu,
>   				    int *error)
>   {
> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>   	struct sev_data_launch_update_vmsa vmsa;
>   	struct vcpu_svm *svm = to_svm(vcpu);
>   	int ret;
> @@ -900,6 +909,8 @@ static int __sev_launch_update_vmsa(struct kvm *kvm, struct kvm_vcpu *vcpu,
>   		return -EINVAL;
>   	}
>   
> +	svm->vmcb->control.allowed_sev_features = allowed_sev_features(sev);
> +
>   	/* Perform some pre-encryption checks against the VMSA */
>   	ret = sev_es_sync_vmsa(svm);
>   	if (ret)
> @@ -2426,6 +2437,8 @@ static int snp_launch_update_vmsa(struct kvm *kvm, struct kvm_sev_cmd *argp)
>   		struct vcpu_svm *svm = to_svm(vcpu);
>   		u64 pfn = __pa(svm->sev_es.vmsa) >> PAGE_SHIFT;
>   
> +		svm->vmcb->control.allowed_sev_features = allowed_sev_features(sev);
> +
>   		ret = sev_es_sync_vmsa(svm);
>   		if (ret)
>   			return ret;


