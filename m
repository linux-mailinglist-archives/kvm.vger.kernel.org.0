Return-Path: <kvm+bounces-42466-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 84A4FA78C78
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 12:35:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4A3C2170D04
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 10:34:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38E8A236A99;
	Wed,  2 Apr 2025 10:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="mblwOenL"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2053.outbound.protection.outlook.com [40.107.223.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1B3F2AE77;
	Wed,  2 Apr 2025 10:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743590089; cv=fail; b=FeisYL144LfELslNhxjBOhRvL2inIFwCdDH9ENMNELgpuGG9M7zaAxUhDrsRrA1M3JeMavVzxWCNd0SjA/zxoQf3XAY1frMP66cNezCtXmXApQNtCoWzqZpv3TFZT5a5lWaN/TlyQoULUbWbQvZMpxJofmPdeRamLPW5BwdYwiY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743590089; c=relaxed/simple;
	bh=THEk2Lm0o6CsjH8zDYGsN76R+Uk6u4KW5ep/KnxD3Qg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Rv6d+1XMh3L44rUMS9D4ZkVpN/aUhHNHxkSHGl2LDuBtjTgZYs0fuo9aHRkZU8HmWOTqTogX42I7r9jCxCPhlH+4aMkxpQCzcAElWSl86fHir9yvy2sClrej0o+0sJ0N6TSPikL12O8A4TRWqpBi9pfy9ndlO+J8aU0nzRchOmQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=mblwOenL; arc=fail smtp.client-ip=40.107.223.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iOfAEyC72ToTKYCMLzVl5EDLFtVzTtyNjQ+r9WcLOK8B/WOKvtFvHHtGKUkGNyPUIZMAOq0JSjhUQYTfk609uZfilXFhuW2v6vHQDNDKiQu8PfSA33iiYlT1v/MxOV5udLZ1Ldj3OGAQGUuxzFmhHDzgyfgKjBjSM6EfHwxyalw8MsvkMktzOhlFPt2YmZ6OcH0Glx5xRDjfTivy8Dauzcnx/C6Mp5oJpIHJJYVCbbqr09Tf0CKmizcNOAz+AwdQ523EvfyZhqxl31lkFQ3IHY2LhMoygvJSAPWeiDx7Ry1IAP9Lmu4/5lmn6trSyrNnvZSQQyOMkilO0Ic+4032zQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EV3mmkqDt97D6I9nEAhtdhc0YUMzEdgQNS7e8IFgUaQ=;
 b=UsX5vEXXimATBT/DnmINbV3J97DGyd8ILOrWuE25oe86w7mAHjCShXXQDcD3Dk1KgTebm+IA/Mv9fqbXQptv/7VLz48BLyrvQ8OFTzNElwzhCXCn4l2/nnoH117u4ahHTuRUusUeS1pofzKt9TnMAHalsu2wK9XsyseHzzWKc0ZwUO6hVFiCxhyioHbqthjbWc9JhxCtThPu6o6h5eLcwB5IMqmf+sstO+h1wiMp79RsPlGVw286AjgGLxEVMwR1hrtCWPWbTP+15LN1IdT+LIXc8a/kTpKtpFuuS8RZ9LSpSjYvpUeXd7TjKmcpM0en/lE5OdmTNzgEl14tX9lrLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EV3mmkqDt97D6I9nEAhtdhc0YUMzEdgQNS7e8IFgUaQ=;
 b=mblwOenLVVuYanI6GOtHOet2PnoLoWjctICwJm2yEwBFZ48AIlIJyAh4biH6V84EI45MHzBPy9POfN03va5InG69jrpCMFvW7SgSdkirdWQCZvua1XerMqNjbyroKLfT6cYxMD1XblZKw4nlL1qnUv64uVA6SACBslWHQwOtzwg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6608.namprd12.prod.outlook.com (2603:10b6:8:d0::10) by
 MN2PR12MB4175.namprd12.prod.outlook.com (2603:10b6:208:1d3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.53; Wed, 2 Apr
 2025 10:34:45 +0000
Received: from DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627]) by DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627%4]) with mapi id 15.20.8534.043; Wed, 2 Apr 2025
 10:34:45 +0000
Message-ID: <18538e70-aadf-4891-964e-4f8a06d85e5a@amd.com>
Date: Wed, 2 Apr 2025 16:04:34 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v2 01/17] x86/apic: Add new driver for Secure AVIC
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
 dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com, nikunj@amd.com,
 Santosh.Shukla@amd.com, Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com,
 David.Kaplan@amd.com, x86@kernel.org, hpa@zytor.com, peterz@infradead.org,
 seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
 kirill.shutemov@linux.intel.com, huibo.wang@amd.com, naveen.rao@amd.com
References: <20250226090525.231882-1-Neeraj.Upadhyay@amd.com>
 <20250226090525.231882-2-Neeraj.Upadhyay@amd.com>
 <20250320155150.GNZ9w5lh9ndTenkr_S@fat_crate.local>
 <a7422464-4571-4eb3-b90c-863d8b74adca@amd.com>
 <20250321135540.GCZ91v3N5bYyR59WjK@fat_crate.local>
 <e0362a96-4b3a-44b1-8d54-806a6b045799@amd.com>
 <20250321171138.GDZ92dykj1kOmNrUjZ@fat_crate.local>
 <38edfce2-72c7-44a6-b657-b5ed9c75ed51@amd.com>
 <20250402094736.GAZ-0HuG0uVznq5wX_@fat_crate.local>
Content-Language: en-US
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
In-Reply-To: <20250402094736.GAZ-0HuG0uVznq5wX_@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0033.apcprd02.prod.outlook.com
 (2603:1096:3:18::21) To DS0PR12MB6608.namprd12.prod.outlook.com
 (2603:10b6:8:d0::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6608:EE_|MN2PR12MB4175:EE_
X-MS-Office365-Filtering-Correlation-Id: dcef1b68-3aa9-4242-398d-08dd71d1fc01
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Y0dyelRMSytRclFFQmZoZHB2WkFJSmdmNldCeUN1ZlRrVnlESFFuRmhtQ2F4?=
 =?utf-8?B?NDRaSGZnd3EwS2QxR1lJd2JCTmRYdTE3dXJSdE50eVhMWXY0TVNQYXNkamZ5?=
 =?utf-8?B?ZG1WeUkya2dad1hkaHNzZ1ZvVUNFaHdMOUJ0cy9kdnMyUlM4Y08zcFFLVWVD?=
 =?utf-8?B?d0s2RGIrUEphbU56T2JyNHROQTdCakN3ZVpFcXk2TE11bnNaSFBCYUcvSEYx?=
 =?utf-8?B?ZUo2NWxMR2dDSnQvYU1CQlJSeW5XVWEzNDMzV1FMa0JNMDAxYnhUaFVxaVQx?=
 =?utf-8?B?S0EwemtMUWR0WW1uYXZ4cUE1QzQ5bVdHZzhWd3ppNjFVV0U5ZjVwNFFZS08z?=
 =?utf-8?B?TmdodkRVZFpaK0ZKNEx6Mk5Vd3VYM2hEMFNVcHZmcUIxQXZlOUkxb1NycTM2?=
 =?utf-8?B?WHBocXhyT0ZZc1B3cXVnTVF1UkpTbnhSYTlZL1pLaWdHaWp6RER2YTUya2dV?=
 =?utf-8?B?eGtTL1VVUE9YdmVhZUU1RVE1UHNQRXcvaFJmNmpXWEhFbDQwRGdLbVNsbWp3?=
 =?utf-8?B?dkxKRWVsbUhhenhWM2o0RFRoVUcza21UM1VKUFVLcnZNQ3hKT0c0ZytlSjgx?=
 =?utf-8?B?NExUeGNCaFdPNHVTOVJXUVdaUnIweUFBNW9QRkRVNXlzd3hxOE9IU0xUcG02?=
 =?utf-8?B?N2V2d016T25pejJZZVJUTGY0VFJGMFdWQTZ0NVZtaHd5d1Ara1pFSGwyL1Rs?=
 =?utf-8?B?a1VHMlI1SGdYRW81Z3ZrMHdya2hmdjlObVIvdGNKbHdBNis3WExQVWQvMzhX?=
 =?utf-8?B?c2U1em9lNWZ0SEk4WU1NQnBkNCtvdnRPZHZlWlRXQ3pYOE10WnFwd2ZDUmZS?=
 =?utf-8?B?anpWVnlQN29zZU4rU0Z0dmFsRnJ4ckdiVHEyMXZlMjZXcGZaUGJWd01Ndi9y?=
 =?utf-8?B?cmc2SUFHMTN4Z1A1RnA2SVc3dE93VFF0RU1vWHRtdi8zOXRCaWp2ZjczTkdq?=
 =?utf-8?B?VUdHZlM1MjRpcklURnlrRUpwR1BJNDVxM3ZvL09TNTQ5cWVkQ1hxYy9lYkdl?=
 =?utf-8?B?R2N5Z0k3T0szWGEyWWdHd3F4Z2lxQU5jMjY2T2U4dWVRR3V4N3lDaXJnUFN2?=
 =?utf-8?B?YlQzdmZOWFY0dDBzVk1HNmQyWjN0S0p0azQ0OHk0Vyt5SnprYXdlY0pGYVlt?=
 =?utf-8?B?Zk54ZndPMzBUS0N0MUVWdzRZbDh4OGtpT3hneEJjV1BWUXhOZ3ZIUC9QSEVF?=
 =?utf-8?B?U29PM29XbWVPdzV3RHNHYy8zdGRlVk5nbkQ4MU55VnFHRm9ka1BsVHl3RlBm?=
 =?utf-8?B?QnNtV2M2UzNIRWhSaHkwOEVTcUVIWFB4aU53ZFNjVzNxY1NmUkNibmxVaWV6?=
 =?utf-8?B?M0VWSWl6d1hSYTFsZFk3citMakV2VTRnOVNkQmdTOWdoYnoyOUJPTUk5UEEx?=
 =?utf-8?B?RlpaRnFMdEVxblFkbEtiZWNMQjdzbjJHdDVtdzY3d0h4NzZvWWdyYWJZQXNQ?=
 =?utf-8?B?YzVma2JWZThLMGdFNnp4b0JhMzE4ODBuRWp2WEtmd0VqbnJpRDFvM3hINHBG?=
 =?utf-8?B?R2J4TDFmTG5xQ1BPcFZjQ1JoaW9meThGZzR3YTdxMHREVEVHSlAxNWNtd3l5?=
 =?utf-8?B?MjdnU2h3ZDJzSkdSb3czaFJ4dmd2SFhJVnNlais1Q1FpMTlRV1BnY0hCbnZS?=
 =?utf-8?B?Q0J0ZjRnMlZLdGNmQkxTUUU4N2lRNmRUNGZUcTJiN0llaUVxa2d4YW5uRmsz?=
 =?utf-8?B?dXF3RUpVL21LMlk3UXlOU0tucUVCRXJWK1VxNmtuSmg0by9ITmVKVDRHMjZm?=
 =?utf-8?B?ZThlZjljUy9PeE1QVGdhTlY4MjJMNXhyR2IrQW53TGUvR1ZWcWIyd2xKZHMr?=
 =?utf-8?B?WHR1TWVFcnhJall6eFRwQT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6608.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VGhJQ3F4ZzlSODkwQ3RITGxaL3M0OXc0QlJaa0hCOVY3NDhoN0piTlQ4djJO?=
 =?utf-8?B?azc0U0s3U0ZXV1pjdHJweGFTcEhvNUs0UjdhYXNkbzVoTlJoSzBvSHE1V1pp?=
 =?utf-8?B?cFE0VVdURHBGSDg0WkRSK2ZxNzc5dFBBUTZFbGZ0SmRuMndBVHErMWtnY3VN?=
 =?utf-8?B?TVE4UzNvajhSRE55clA0cWRWQWJGbThiRVNlaHdDR3RoazBKRTF2enJOR2Zj?=
 =?utf-8?B?NWdKQlZUdVdvbHBkamdUbXJLSnd3VTE1Qml4STRoTUorYXNlNFJtc0Y4MUZW?=
 =?utf-8?B?b1pjSHhrOXZjbG1YVXd6ZHlEVUYxUGJDTWFpQTRXYlJtN0xCSFRuMk5nS0xH?=
 =?utf-8?B?ZVhLbGZFVDVBWUI3TVlIdUpkQTlwRmd3QzJnRFpHcHlFUXhrRHdLMEtUQ2FP?=
 =?utf-8?B?QkxhK3FucjhLODcxNkI4TVFUNG9sbUVkM2loek5CUDNmdEJtOVZ1YXFnYmhj?=
 =?utf-8?B?VnpyYndodGt4cXdRaXRyV2xWdUdHU3d6RjlhUW1xS3UyZkNNZDhoU1YyaXJQ?=
 =?utf-8?B?eWVhM2hlL1ZoU0Nrb3FidHpnSHVORTZHZ3pjUEx3Z0FXcUpsNXNNYTduakR3?=
 =?utf-8?B?UHVXbXJmUWtXM0FOSHBMV2c1WGdaaVd4cW5DYnpqTGtXUzRXM0xHRmdzMG9O?=
 =?utf-8?B?dGFNV2djSFNZd3NHR3ZrZ3NOeWpoSXBWUEVkVkxQUGNPdjBoOWRtWWUwaTl1?=
 =?utf-8?B?b3FQbjBTeWU0S05jQTFhc0tDcy9uVW5DUkg2cVdVaGFzdkVqd1RnekNBYUZx?=
 =?utf-8?B?NDNmVkl1T3JFcy8rTmdDTUN4N2FncURKeG9NTFR4d21nSjlqK21MWEJUMGZF?=
 =?utf-8?B?bmx2N3RDUFRZQnlMaVlETHlreld0b0o3dit3bEtySnVxN3c1RElBdnN3bnVr?=
 =?utf-8?B?SHVOa0ZOck1XdGFibjBjbTIxYWRyTSswMDFOR3hnZGtmYkdDcWNaemdYdkUz?=
 =?utf-8?B?NXQ3YzI0N0pSdE9PYk9DbE15eVJsUlZ2RnNmb2hRdjRXLzZKbjc4czZiWnVn?=
 =?utf-8?B?elB4dzVaWjM0Sm4xOWIyQzhFSUtyVElmOWIvUjN2dndGa0M1MFlLMlErQk5I?=
 =?utf-8?B?KzNhQVNQbUdBSzE0TDVuVjVHUldHUFdsZGx5Y0x2Vys3VFNxVllVN1RUWXpn?=
 =?utf-8?B?bHpOKzlSZ0k4NnVUZ3lIR0d6Z0tUMXN3L29TSnkyK0FvZnMrV1pMYlhrUHE0?=
 =?utf-8?B?c0VPZ0gvVlFrTGF4b1pTQzZ3VEx3VFpmWGhKWnE0MFRlRm9UU0pVVngvNzhK?=
 =?utf-8?B?VXJ0YzB4REJ0QWtFM04vaHVMMkEreFdyOTNzVFhmMXZ0VklZWGQ5K1ZOYUhi?=
 =?utf-8?B?REd3ZkJxeXZwWS80OWhISTJ6eHk0S1FNZzB1b2l5UWh4TDBSRkFZc0xRcEl2?=
 =?utf-8?B?SDhZQ0REcFpxMUtZQ1pIRHZEcWZ0MDhSLzlzY1RUczVqblpDaXlLZ0w3aW9l?=
 =?utf-8?B?SVBpZ21odllnbmp4M2crNUdrYVNLamVCNmtUeC85emVCaHNWS05iSVdTYTNj?=
 =?utf-8?B?NTNkV3RqQmhrWUhZdStLbXkvTnJEV0RqeFNMRkNaMUhzY3IrQlJ6RjVLMFY2?=
 =?utf-8?B?cVNKbW01Nm1KMmp5djNFUk9vcXo3a0ZuVDNPR0RyYXZuRndtd2Z6NFBhRzhC?=
 =?utf-8?B?MENHK3FMMXJITmprRFQ3NkVtbm5hWE85N3FCVEhtcE4veVhIdkk5eWtHb2Fo?=
 =?utf-8?B?dkFoR1BmTnZXL1NObWdScFRlSUpnQkdqclRRZWhYVFFjVWhSYnZqNW9TcWlw?=
 =?utf-8?B?ZzZVL1FzeVlSMWN4M0hHOUFyR2prYnZVa3B1Y1IxZDZVUFdMQ0twdDdJcThO?=
 =?utf-8?B?cWd6RXRudVY4M3E4OWgyTUZyU1RhU0VMWUtZbXRvYTM5MjE5ZGUvd3pSSExi?=
 =?utf-8?B?QnlMQ2JTdithL09LSXJZbXMyelM1OThRck5salBCcXRXWHhnaG9jTEYxbHFs?=
 =?utf-8?B?djZpOTBuNnJyOTQzMlp1QkRKY0FEcUx1ZVVNQ3hNdWtmTUNaelo4ckVRL21R?=
 =?utf-8?B?S1lYZURDY1AwdTM1SDVFNzhqZ3dVeGY0ZjZvK3ZyaWZPSFN2VmFKS0R3enRD?=
 =?utf-8?B?eHZuYXhPMTJ5WkJvQWRUSVBxSWlDOUdTTlVIS1lwMGhJTUMwTnBwc0xtZ1hn?=
 =?utf-8?Q?Cqyy7Xl4ZaR0JG36FGApzsDUO?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dcef1b68-3aa9-4242-398d-08dd71d1fc01
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6608.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2025 10:34:45.0736
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AzQIM/NdM0EXqfsursaojNyMAKn8wBV+7I9/DO+reJHkFzbuJmlkxgd7vvjgpTRuhJs54r/sGYyKSIbe1GDdyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4175



On 4/2/2025 3:17 PM, Borislav Petkov wrote:
> On Tue, Apr 01, 2025 at 10:42:17AM +0530, Neeraj Upadhyay wrote:
>>> diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
>>> index edc31615cb67..ecf86b8a6601 100644
>>> --- a/arch/x86/include/asm/msr-index.h
>>> +++ b/arch/x86/include/asm/msr-index.h
>>> @@ -685,8 +685,14 @@
>>>  #define MSR_AMD64_SNP_VMSA_REG_PROT	BIT_ULL(MSR_AMD64_SNP_VMSA_REG_PROT_BIT)
>>>  #define MSR_AMD64_SNP_SMT_PROT_BIT	17
>>>  #define MSR_AMD64_SNP_SMT_PROT		BIT_ULL(MSR_AMD64_SNP_SMT_PROT_BIT)
>>> +
>>>  #define MSR_AMD64_SNP_SECURE_AVIC_BIT	18
>>> -#define MSR_AMD64_SNP_SECURE_AVIC 	BIT_ULL(MSR_AMD64_SNP_SECURE_AVIC_BIT)
>>> +#ifdef CONFIG_AMD_SECURE_AVIC
>>> +#define MSR_AMD64_SNP_SECURE_AVIC	BIT_ULL(MSR_AMD64_SNP_SECURE_AVIC_BIT)
>>> +#else
>>> +#define MSR_AMD64_SNP_SECURE_AVIC	0
>>> +#endif
>>> +
>>
>> I missed this part. I think this does not work because if CONFIG_AMD_SECURE_AVIC
>> is not enabled, MSR_AMD64_SNP_SECURE_AVIC bit becomes 0 in both SNP_FEATURES_IMPL_REQ
>> and SNP_FEATURES_PRESENT.
>>
>> So, snp_get_unsupported_features() won't report SECURE_AVIC feature as not being
>> enabled in guest launched with SECURE_AVIC vmsa feature enabled. Thoughts?
> 
> Your formulations are killing me :-P
> 
> ... won't report.. as not being enabled ... with feature enabled.
> 
> Double negation with a positive at the end.
> 
> So this translates to
> 
> "will report as enabled when enabled"
> 
> which doesn't make too much sense.
> 
> *IF* you have CONFIG_AMD_SECURE_AVIC disabled, then you don't have SAVIC
> support and then SAVIC VMSA feature bit better be 0.
> 
> Or what do you mean?
> 

My bad. Let me try again.

In previous sentence

"SECURE_AVIC feature as not being enabled" - SAVIC not enabled inside guest.
"SECURE_AVIC vmsa feature enabled"  - SAVIC enabled/active in hypervisor for that guest.

This is basically continuation of our previous discussion here [1]

- "sev_status" reports the SEV features enabled/active in Hypervisor for a guest.

- If guest is launched (qemu/VMM launch) with SAVIC VMSA feature enabled, hypervisor
  uses SAVIC interrupt injection flow for that guest.

  SAVIC VMSA feature is reported in "sev_status" and tells guest that SAVIC 
  functionality is active (in hypervisor) for that guest.

- snp_get_unsupported_features() looks like below.
  It checks that, for the feature bits which are part of SNP_FEATURES_IMPL_REQ,
  if they are enabled in hypervisor (and so reported in sev_status),
  guest need to implement/enable those features. SAVIC also falls in that category
  of SNP features.

  So, if CONFIG_AMD_SECURE_AVIC is disabled, guest would run with SAVIC feature
  disabled in guest. This would cause undefined behavior for that guest if SAVIC
  feature is active for that guest in hypervisor.

 
  u64 snp_get_unsupported_features(u64 status)  << status = sev_status
  {
        if (!(status & MSR_AMD64_SEV_SNP_ENABLED))
                return 0;

        return status & SNP_FEATURES_IMPL_REQ & ~SNP_FEATURES_PRESENT;
  }

  /*
   * SNP_FEATURES_IMPL_REQ is the mask of SNP features that will need
   * guest side implementation for proper functioning of the guest. If any
   * of these features are enabled in the hypervisor but are lacking guest
   * side implementation, the behavior of the guest will be undefined. The
   * guest could fail in non-obvious way making it difficult to debug.
   */
  #define SNP_FEATURES_IMPL_REQ ...



 

[1] https://lore.kernel.org/lkml/20241009110224.GGZwZiwD27ZvME841d@fat_crate.local/#t


- Neeraj


