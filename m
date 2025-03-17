Return-Path: <kvm+bounces-41284-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 40098A65AA0
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 18:26:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 58CA91704FC
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 17:24:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD1EE1A0BCD;
	Mon, 17 Mar 2025 17:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="YS3Fv7ev"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2048.outbound.protection.outlook.com [40.107.94.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EB0015687D;
	Mon, 17 Mar 2025 17:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742232238; cv=fail; b=huIiGL2AuKS9SBq2cOtdvEnz/3GWp9sZMhn+7QHzYFjCwX5923+HYVZ2MoKK/PG57o+uW9EJ9C0B0FnlijorF3haXOLRpIsZAlG6ZyOYkHwLPk16uyVsy5lAhqNlk88rhX7X6NqEcOahT8Lf9CMk4HuWU72/HJrNYx7wQ0AJYxI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742232238; c=relaxed/simple;
	bh=ho4JZxU1MwjvhaTt+tRr/DneekiwZFqer0ZhgHx2mTY=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=TpU/EdItRfK/Qav1jTThiAMfoVOXvLiHgABX9APhgevw7F55RIqtvpJvUoBg7m+WKfyMP32Qcl4W5gQaR3eCCSpv+p9SRrToylWHmx2M12551ANG8vvKvPoBs/SqjCnPkduPVTd1pc8d8FB8KqPqzdtDsnepbUs1NbwQjSEkWWs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=YS3Fv7ev; arc=fail smtp.client-ip=40.107.94.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JCgck1tFR//Jr0nIC75EH0aCsPIv2mYWpK7XcM6k+OI/6SmsCSNwYEbQ5p0hwn6pq0Yf3KP5vKaMHve+65icqje7D/gbtmlq0BCLv4xrJCSKpRtoZq7hYenQnmaAG5JzoLFBFnYCBupP4TNvwSS2lx3DbswkHyaStc3OFY6OiIWQgW19pkz57XAY/Vn8x0vnDeJciDCrnhdj9RkHXgi0KuHpOM3nZKrvQrzfV99EKS1GVXw9JsLYw6sa6wqwR2qU+ioY4q7nXgYlTFuOn49lYSVO/y/1yLQ/FnXQs4Ypedfa8nWxOfcHDnp0hafEgkbxSsEONYsGslTCESNYsnlbbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wIbYYfJ9aUN5XgEd5465nfKTKXi4ZwyxRND5eOeCxVw=;
 b=jT533qK8iODQcSGRbZw5erZta+gmwhx4Ldec+TsfbKmm0OMSoVBsJQjNdrT/VFzE6qHNPRFlMzTH5guK69B4Jci0VwyddylRkXkXPP77gz/0AjopSxBefrQfKquIMnJ4apWc4wwjCQk0PLLhMhw4IJ1OE9BtgheqVnuXGSmkkGhozgi6N850qBCMBs+5fQMfqvGG4xJ0PfaKnhccBb9Lu+sWxD4XEYzpCBB46uWx7+tJI1EzSgXAxULGSvHrg/6ojiGirlTLdIVv5k8MRNQqsmGwLmzk6bBQCqiDMKPUzpq+VqY2UdxHC2fq5F0TXGJyfw4IT71n9PBDfisTsSlwFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wIbYYfJ9aUN5XgEd5465nfKTKXi4ZwyxRND5eOeCxVw=;
 b=YS3Fv7evTfZT7+xiYS6iCeAM9TkGT9GyEXsgSQokqrSwnYIQCQe9WxGiPCySUrNaEeoWtz0RlS+w1RL3pM3+pBfKDZPaVu7pTty+WQeIu991lA6SAlGaVY3iRZQjr92shBcYS0s+P1fo7n9CzW8NIJUU7Xoc17I3rl4EY37sxNM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by BY5PR12MB4276.namprd12.prod.outlook.com (2603:10b6:a03:20f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.33; Mon, 17 Mar
 2025 17:23:53 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%4]) with mapi id 15.20.8534.031; Mon, 17 Mar 2025
 17:23:53 +0000
Message-ID: <48899db8-c506-b4d1-06cd-6ba9041437f7@amd.com>
Date: Mon, 17 Mar 2025 12:23:51 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH] KVM: SVM: Fix SNP AP destroy race with VMRUN
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
 Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>,
 Thomas Gleixner <tglx@linutronix.de>, Michael Roth <michael.roth@amd.com>
References: <6053e8eba1456e4c1bf667f38cc20a0ea05bc72c.1742232014.git.thomas.lendacky@amd.com>
In-Reply-To: <6053e8eba1456e4c1bf667f38cc20a0ea05bc72c.1742232014.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0053.namprd04.prod.outlook.com
 (2603:10b6:806:120::28) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|BY5PR12MB4276:EE_
X-MS-Office365-Filtering-Correlation-Id: bf65352e-a581-4c63-b837-08dd65787d56
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ek9ETXd1V3JjTzZBYjhqMnptUjdDdUJiWjV2ek5sUmc3UVd2dVZHelRYeFZN?=
 =?utf-8?B?OU51Z3o1cXF5K0ZrdlhQcGZCZi94NGtaWG8ydDNXSDRqanA3Z1Fldk1pRm5R?=
 =?utf-8?B?VGtUZG9IOHdPWDdDZmlmR2VWc0dLQWVuVHZwL2Y3Vlc1MmVPYjIxUWcrWEpm?=
 =?utf-8?B?TmY0aWMzUXdpUU1zV1BuVkxmY2JwNFVGK0FiQ1BkeEFaSlMxRDJTVWkxOTV6?=
 =?utf-8?B?TkUvNjdKYUNLTFh3OS8rZHVFVGVTY05PRWVxZnJ3dWZnMm1Hc0hJcllMZVNs?=
 =?utf-8?B?WXpHdnI3MmFnRlVYVWlYVitZcy9Hd1orc1pxVnluZE5YTnp3M3RhRm84RWZo?=
 =?utf-8?B?d2ZZVjhwOG1DWXEwMkgrQXdDQlZqbWdQcXZmMCtpVFp0bjZCV0VtdnNvVkhq?=
 =?utf-8?B?UkM5UnJ1TERJbGNBS0VIbUNWQmpuY3BHQm85UGpVbGlWZTk0bVVRSUx1c2x1?=
 =?utf-8?B?MHhNTWZPRjE3QnhieG1FbkRnWURxZzBQNlBsMzhBOXJtT01VaWI4VHhkQlRj?=
 =?utf-8?B?NSt0SFlUQ3d5NTFMQlZvUThxVFYxRE1vWnRCQUJmbk9zdG9wWkxhRllIVEtu?=
 =?utf-8?B?WmlKNFZoakNrTzY1UzdiMGpQKy9YWlA5ZVoxN0YzZXZScEtQV20veFloeXFx?=
 =?utf-8?B?RWhneFBPekRjQUpFeDN2MU45cXZGbWlrQk9vemhwWU14V3RSZDBHYXpQL29G?=
 =?utf-8?B?QnRiMkgvMEpuR1JmUkVNMXdNdFh6OU11bGZhZ2k0TmhMREREU0dudmdUOEl0?=
 =?utf-8?B?V29vaHNIVmFRTVNCTG10ZytIQ0RwcDlIcXZTaEFyd1hta1R0cksrbmxLOG5m?=
 =?utf-8?B?bjZoVWJrZUk3aHd2djZOV2xrQWE1Q09NaWorZUY1R0V3K1dBTzYxYVVYcnln?=
 =?utf-8?B?UkJURWtzeCtjVTFKM3BaazJEYWhPYXVmeldVVlFxeVM5b3pDR2RBd1lvL21Z?=
 =?utf-8?B?WU56ajZWaDZ6SS90NjJEaWphbExiTFIrK0dEb1pRS0p1QW02Z3ZtWjFiazkv?=
 =?utf-8?B?anlVK0orb25lWFZtemZyT3B0RXVuMzRQMGUwNWN3UTc4d2tzeHNmeUloY1J4?=
 =?utf-8?B?VUh2UXhlQWJTMXBTUUxTR1dJVGpQRVRWNGpGQkNBWDd3dkZjWW1YRnY5WVFa?=
 =?utf-8?B?T1A1YyszczlUaXRRdVZGMlZSQU5KWU9zL3g2MkcvaWx3QnJjZWZWZmVGTjZT?=
 =?utf-8?B?R0dvdndmM01GcDJZbm5seUJaY1RoTUJDNDdrTGlHaVVCQ2xuOS9nRHVBK2Z3?=
 =?utf-8?B?cWJ2bzh4K3AydFJNelJYOGVoVk1lc2J5WE1OUXhhNUFLeHp2OTNVbTBHWVhK?=
 =?utf-8?B?ZUlac1U4NTVyUmo5SXNIVHBRMFV0cjF0UzBlOVFremo2Z1V1YUZMdHo3VkdX?=
 =?utf-8?B?UVBubitnZW9NVXA3Qk9SZzEyQmsxd3NzL2wwZWVtTkcyUUtGeUxIOHBYQzMr?=
 =?utf-8?B?UEJFNHNLd0Z5dzI5Q2FrUnltTTVuUitkcmJqWkxBaUFDbTNlcENjdFBSbzNP?=
 =?utf-8?B?ZWZyNEFqMHRMcjJDcTlrdTFRc1NjYVNDbHB2TC96Syt6TGU5WU1MOXVoWTZ4?=
 =?utf-8?B?ci9JcnRoSGxsVHZFOHk3NXA1QllXK2lrZXViRG5nRFozYXZneWNvdXBMSEty?=
 =?utf-8?B?cUxWQ242aUVuTnY4Z2UvRTZFczhhU2tHN3hmRzFQQXp4L28zZVo2NFZOS3R6?=
 =?utf-8?B?bzNQQWYxYXBhN01FVEtmRkl0QS9kcTN5d041amI4ZlNXSE42cDYxcDcwb3Js?=
 =?utf-8?B?RXBHTXBGajdic1FBTkdtUnd3Z3RjdnhRTTZidnY5ck56WEdNL1pTeE9KUzYx?=
 =?utf-8?B?NWNDUHR2Wml1bndwTlJoemtkUDE5TTlEQWk3OWpoN0YvQ2xOUzVuaFpidEEv?=
 =?utf-8?Q?+PiVrH8Zi9yuw?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YzZEWXBaZlBqZkxhUURxWWVJRDdXQitOQnFiTXJEZzc5ejV3bGdyQ1RrZ3Q4?=
 =?utf-8?B?d0dHaG9KRGY1NmkwaTNZeldVQ0JSay9VK053ODQ3OEc5NTNOdU9oYUltY3NG?=
 =?utf-8?B?MmJGalVRY3pNREdIZGhHUlo5K2Q0dVVUOUlrSjgwSWxaalVlRjMzZ003Y283?=
 =?utf-8?B?NUFjamIrZVNPNDFzUTVWcnNsUWRmOERUeFJnMmhMRUdkRW5XVzJpZU1FQnpZ?=
 =?utf-8?B?RlBDMXl6ditHKzRnMnhvdjVnRnpnaE1mRDBGSHVXUGNybzhPanRuWnNMdnd1?=
 =?utf-8?B?bHROOGJpQmVPRVNXWHdZMXVQS1hTU2Z3RFlybXVHdjFiRU1vWVFZdXpaWFd4?=
 =?utf-8?B?VHBXb0k0R1BhOHZTR1RkQURRajVwNHcvWVorZ0tEeTBpWFBudTQ4ZGxRSzJK?=
 =?utf-8?B?bnRabGhVczRBVGYyV0FZNVlTMVU5bVVYZ3hGaHQxZWFJajBqd091eTJidERz?=
 =?utf-8?B?ZmdROUV1SDh0Mm11OHlxOGMzTExwR0dNWHAyWWFtem5qbmNjRmVIWFVpVXNE?=
 =?utf-8?B?OTY4R2M0RlM0Y3E4ekVlL1gwTlNYaVVxaGZlVXpDU2VIYTFlOS85VG5zVC9r?=
 =?utf-8?B?YUVoL0dabFRKQzN3cGxOVmVVV3RLcFFvRVRkY0hmekVVOThPcytiU25PY3RU?=
 =?utf-8?B?SXZQelo4RWxKcDNMVVZtZ0x0WWxuZUNRR2hHMGpNdkpGNWJ5WGhIbFdsa2da?=
 =?utf-8?B?NXFFRWFLVXg0K29WNm9lRUdHY3V5ZGZPTnY3SmhWQWpIOE1OQ3ZRcld0Y045?=
 =?utf-8?B?Q0tGUitrTTRMSU9ySjdYRVhkYTFna3MwL1ZadUdraThZaFdrd1BvdVB6MzRi?=
 =?utf-8?B?S0N3U0tMcDhIK1JRVHBTZlhpM1ltU0xrV0tyUldkTmNLaWhlWlgyTEROZ0c2?=
 =?utf-8?B?VGplcEdDeTcvbWp3TkF1RTgreDdCZHBYOGw4S0ZqcmFJbW9lT0R6Mm5xd2Ir?=
 =?utf-8?B?NlJTZEk5d3JEaFk3MWZsQjVFbHh3UUJQZFlydEt1Wk9YTUNQaVJWblM3Y2FI?=
 =?utf-8?B?dlB6VlFUOC92UFJYTGN5dzl5VkhpV0lIaTU2aVJDb1NWNDNrMHRiM2tBWFo2?=
 =?utf-8?B?cjBXcWlYTDBOcVVXNjBGOTlYa3M5MzE4RzYzRWFTVkJkWDR1MGVQZHU3Z2ZC?=
 =?utf-8?B?L05maVRMR1JKZ1FMZVI3M1F0MS9pYmNOazlESjM3YVoxSUpBbWFLT0VvV05Y?=
 =?utf-8?B?YnhHcDVUWjJUODFKZzBGOUYxSlA2TURGR2RHbGZzQ0MxcVZ0UmpKQ0lZNVpY?=
 =?utf-8?B?MEFjcVdEQ2IwUC9KMUxtTmkzQXlrQXBXRjNFandraHNBNTZEWlRIbHZmL2Jo?=
 =?utf-8?B?MFp2VzlpNDcwS1VTNHNVazRmbU0wdmJpeWJpUkwyeCtkTDRiOUZvOVhSTGdL?=
 =?utf-8?B?YnFSYkJ5Z2Y3VDhGZ3FuTWhBMkRCWXJoaWtqTFRNNlY1NldtVVlkZjVSMHdu?=
 =?utf-8?B?anpVWG1YZG0rbU9hMGhwc1QyWkZBNGdtWm1OQkZFMWZpS2xiTFJ2OENweWRs?=
 =?utf-8?B?S0RMcUFqbjdUQm5vRTRQYW15dHAxSyt3UkpzL2pVMTRsVTJYRE1iWDB0S29o?=
 =?utf-8?B?cXhPREJ5N0VzMXowWUd1bk9aR1RBRjVUb2VBUmlJNlFwVUNMK0ppQnNkNkND?=
 =?utf-8?B?bTBmU01ScDkrSjFNeUZvL25xVXdsU2xKeGsyWjlKdm9GWjV0cmlGd1RzaUta?=
 =?utf-8?B?Y05mMWt5dzVRZTdPWmUzUGJZUTFWK2pSTHU0MmppYVkwRExBanJkdUlzUVhB?=
 =?utf-8?B?OTBYNTNtQUsxT0xCK20xMnhqZ0xVY3QzazZDYzN3eHIzSlRqOXhIV2QraGxt?=
 =?utf-8?B?ekJmTGhaVTJRY0Nvcyt2YmxlcU54TVI3d2dzbWdHUFh0dGVSZjdlZ05yeVZ4?=
 =?utf-8?B?amkyWkxVU3JpVXhEckpkb21UZnU5VTVkMDFrTjUyMnVsM0JLYUdkK3dwdnVx?=
 =?utf-8?B?NUh3Z1hyaTZMbkNoVm9Ha0FGYnNjYW5ObVRHSFNPMXJiVENhb3p5VXZKTWZp?=
 =?utf-8?B?b25mLzk2Z0xNZysxL09ac29BeHcyZ0lWV2F6T2dVOTE4N3V6QUk0dmM5MTJs?=
 =?utf-8?B?SGNkTWdIM2hCMzBMQVFoNjFQVUlBakRmUkw4NTRpbGNHd3IyOW00bEorM3pp?=
 =?utf-8?Q?dN7ZPZM4Z9LeUe/ULuNWcUQ36?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf65352e-a581-4c63-b837-08dd65787d56
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2025 17:23:53.1472
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eZyQ6hhWVUQqAsfktHWVNzZ0p5LqjAykRiSYiEtlUD4J+ttw9rrr5EMbjhQLrhkTzWe0xemsXjfR0ODL3P4DRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4276

On 3/17/25 12:20, Tom Lendacky wrote:
> An AP destroy request for a target vCPU is typically followed by an
> RMPADJUST to remove the VMSA attribute from the page currently being
> used as the VMSA for the target vCPU. This can result in a vCPU that
> is about to VMRUN to exit with #VMEXIT_INVALID.
> 
> This usually does not happen as APs are typically sitting in HLT when
> being destroyed and therefore the vCPU thread is not running at the time.
> However, if HLT is allowed inside the VM, then the vCPU could be about to
> VMRUN when the VMSA attribute is removed from the VMSA page, resulting in
> a #VMEXIT_INVALID when the vCPU actually issues the VMRUN and causing the
> guest to crash. An RMPADJUST against an in-use (already running) VMSA
> results in a #NPF for the vCPU issuing the RMPADJUST, so the VMSA
> attribute cannot be changed until the VMRUN for target vCPU exits. The
> Qemu command line option '-overcommit cpu-pm=on' is an example of allowing
> HLT inside the guest.
> 
> Use kvm_test_request() to ensure that the target vCPU sees the AP destroy
> request before returning to the initiating vCPU.
> 
> Fixes: e366f92ea99e ("KVM: SEV: Support SEV-SNP AP Creation NAE event")
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>

Sean,

If you're ok with this approach for the fix, this patch may need to be
adjusted given your series around AP creation fixes, unless you want to
put this as an early patch in your series. Let me know what you'd like
to do.

Thanks,
Tom

> ---
>  arch/x86/kvm/svm/sev.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 0d898d6b697f..a040f29bb07b 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -4071,6 +4071,16 @@ static int sev_snp_ap_creation(struct vcpu_svm *svm)
>  	if (kick) {
>  		kvm_make_request(KVM_REQ_UPDATE_PROTECTED_GUEST_STATE, target_vcpu);
>  		kvm_vcpu_kick(target_vcpu);
> +
> +		if (request == SVM_VMGEXIT_AP_DESTROY) {
> +			/*
> +			 * A destroy is likely to be followed by an RMPADJUST
> +			 * that will remove the VMSA flag, so be sure the vCPU
> +			 * got the request in case it is on the way to a VMRUN.
> +			 */
> +			while (kvm_test_request(KVM_REQ_UPDATE_PROTECTED_GUEST_STATE, target_vcpu))
> +				cond_resched();
> +		}
>  	}
>  
>  	mutex_unlock(&target_svm->sev_es.snp_vmsa_mutex);
> 
> base-commit: f8d892c137f7448d7b49f5e3ad7aa7b5a48a64ed

