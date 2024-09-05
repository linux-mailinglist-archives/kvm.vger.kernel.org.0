Return-Path: <kvm+bounces-25935-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 90B6A96D75F
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2024 13:41:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B69871C2411C
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2024 11:41:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 153C0199EA6;
	Thu,  5 Sep 2024 11:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="p+QAv5le"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2064.outbound.protection.outlook.com [40.107.243.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67F56198A32;
	Thu,  5 Sep 2024 11:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725536466; cv=fail; b=iPJeINjN/NbA6HzINqTPj1ALlW2LwiOhMx8fiW9/xe02IzTQqJX1W5gpjIzI8YX40HUnPBJO4Ao9D+7gRgYYHLMMBqG4m6DNBO5sgJRArLNFDsSQac+r37sz3T2z8ANLj8Gj8n+cTC/fFRQKXaunOLyauFZ2arjhIbLReGxBFI4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725536466; c=relaxed/simple;
	bh=hVM/HfGT5xxQAdKjPBG2ET29u1d5GREfng3uubnkR14=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=b/TVoqJp6ruDb051+0N+Ol6OwQZ9jVq+pgpj7FlfgE3qn2XQgYFKxPtQiHAETzoo1Kf0c5vAWw3rJNLIk/4oeu5qXa21t/jYqJnMuuHUQAuv9qjRFo9p1xrD9Xcu9j1s8LyAHuqG9jl4Y+MpXEylX5VyBAOcZLsCEGcpG1Og3k4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=p+QAv5le; arc=fail smtp.client-ip=40.107.243.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xJQO6YmXBqY8qUtsv0n+3QN3pTLveJoxdZbXG+n8yWPjLNbJ2D+1TZIxWnQ9OJumfMFzVoztYDUuHJiX8R1jeUr59faFFCsTWCLiXhREeJ8hhKa748QiecPMG+g7A3sfjIKsQpyLm5Xpe9PXuxBbSn5p4MnhvcoMZydcWNHDFOY3nrCyH0uCssWR5C+Pue4Maz4hMRZutgvuU8w89HM5my9CflRWd7NF6zOes2sov1DBT7lsjsMoSu9NN6hKzwhKKRBJKwmWIYOVH9S34TyNz3jZ7hYpuhrwek5uQksD4Uk3RPATfg1Sv0pE2vl558AB7TFgL2nh9Icz8wiqBi3KDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pC39Orns1/uxr0dyrTuZUk1I1FFuQRfZ184pW0EwOHM=;
 b=IuhjYMeIC0ArOFwNt85OdoECpT8qgJQA/CiNp8vH4JAFIAFq0lrxHBl3fj3beXDrpSjDkBJO5oZpy5CUQP/sjR6XOp9IUbpBlG2P8ub4NA8F/LBtDabs2ePtdyMc3WNXVD3YDiX5CWIAW2xIOkTVjUgs3/N/WHy54MelmnDxsQFrFXsDEcBimlC28UVqfSNSUB+I/GVjSN8HPNwbcmjyFnrpVkpehGwUOzg/myLGcM6Hhx/pWpfeeny7rffLSPP7lJ4Y0h37GUvosoTMX5Y7B4h4JkCumJXJgT/R7mQLesCZRFnlvCSzTX36EkiLxm0Z+P33692G5fsWDxsChfcWDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pC39Orns1/uxr0dyrTuZUk1I1FFuQRfZ184pW0EwOHM=;
 b=p+QAv5leo+3RtX8yN3TE2EIPvMp2d8Ed5icZBi+SLnrXQKMdM6nB8XN4adhQUVAbSg1xwCWVaL7n7oG0XARi0vpgN5D8g21s8+Khexiq940fBat+CoyhNit+jIRfUc7P9sZnP24r5IkSyd//qoZeN33sVRbe4SvcN27YVPQFyNU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB6588.namprd12.prod.outlook.com (2603:10b6:510:210::10)
 by DS0PR12MB9421.namprd12.prod.outlook.com (2603:10b6:8:1a1::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.20; Thu, 5 Sep
 2024 11:41:00 +0000
Received: from PH7PR12MB6588.namprd12.prod.outlook.com
 ([fe80::5e9c:4117:b5e0:cf39]) by PH7PR12MB6588.namprd12.prod.outlook.com
 ([fe80::5e9c:4117:b5e0:cf39%4]) with mapi id 15.20.7918.024; Thu, 5 Sep 2024
 11:41:00 +0000
Message-ID: <46d610e5-3f4f-4113-ac56-3ecdc66e4029@amd.com>
Date: Thu, 5 Sep 2024 17:10:47 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/4] KVM: SVM: Add Bus Lock Detect support
To: Sean Christopherson <seanjc@google.com>
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, pbonzini@redhat.com, thomas.lendacky@amd.com,
 jmattson@google.com, hpa@zytor.com, rmk+kernel@armlinux.org.uk,
 peterz@infradead.org, james.morse@arm.com, lukas.bulwahn@gmail.com,
 arjan@linux.intel.com, j.granados@samsung.com, sibs@chinatelecom.cn,
 nik.borisov@suse.com, michael.roth@amd.com, nikunj.dadhania@amd.com,
 babu.moger@amd.com, x86@kernel.org, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, santosh.shukla@amd.com,
 ananth.narayan@amd.com, sandipan.das@amd.com, manali.shukla@amd.com,
 Ravi Bangoria <ravi.bangoria@amd.com>
References: <20240808062937.1149-1-ravi.bangoria@amd.com>
 <20240808062937.1149-5-ravi.bangoria@amd.com> <Zr_rIrJpWmuipInQ@google.com>
 <d391cba7-e20a-41dd-b395-3923893bdbc0@amd.com>
Content-Language: en-US
From: Ravi Bangoria <ravi.bangoria@amd.com>
In-Reply-To: <d391cba7-e20a-41dd-b395-3923893bdbc0@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0052.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:22::27) To PH7PR12MB6588.namprd12.prod.outlook.com
 (2603:10b6:510:210::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB6588:EE_|DS0PR12MB9421:EE_
X-MS-Office365-Filtering-Correlation-Id: 3b9bf4c8-664b-49f9-343d-08dccd9f9d3c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?S2NQUThTSTJJUlRaU05TUU9jaEFMMTlnT01xTjUrOHVRdVg4UlJLaWVsbmpG?=
 =?utf-8?B?ZldiSis0UVRUV0t0L0tRYjd3eTF6cmVmVlVkbHhlWmJIbVZTVTU0UVRhcm5z?=
 =?utf-8?B?T2hTK0Q0U3MreXFhdmw4aG1CU2dEcjVaNXB0QjFYeW9jWnhJaWw4RWN2MXNK?=
 =?utf-8?B?VzhxdWZWN1FhRlJvQ0s0VGR6eHBHVnN4OXh3RUVTSGl0cWZ4QlJXdzhyQldZ?=
 =?utf-8?B?elkySm0xWGVMdUxLSkFHNU4zWmNmSVZjTzNZd2NEc3ZmSFZRa21mV21BUXVp?=
 =?utf-8?B?UmFVR2ZXcFFsK2VFd0VTSlFsMjZ1VS9OZHNLazNsMUdMbHo5bktPbkt4NnVX?=
 =?utf-8?B?T0Urd3VoOTNDeGJYZk5kTHBKaWFSRHYvajBPeWZNRHNwcVlheFdQamtQdjdE?=
 =?utf-8?B?SzdGYzk4anZFemx3MGF3cTdGM2svNVZzNTY1R1hpeFY1QTFyaVJIMTlkeHd5?=
 =?utf-8?B?ZlJmT3AzM2Y3a0dpY1hYYlVBaFVJYnRqQ3V1cmNlRkREbjNnTjBrVkNXQlBT?=
 =?utf-8?B?eXhZTmwyeHRGSXBFTW1MUXlNazhtQWdHSzJzaDVaVThFYzlWemtRY2hXNUk0?=
 =?utf-8?B?S1lrcjJuK2pUSmdveEZDS0VDWkhiNXBUdkd3WkRMbXNlRVBoTmJuVWk0YjYz?=
 =?utf-8?B?dlNtRlpKc3MxeWwvRTB6aUhLYTBydk1ocjFucjE4T1F6Qk5OdDl5bGRsWFBR?=
 =?utf-8?B?c2hrMCs0YUF5bGRRNnhmQU1hcjRSdlYzRkUwSDFLcytjUWloT3Y3TmpqcXlT?=
 =?utf-8?B?WUlMVGxobzF5ZHVCaXMzUUlUMGtJOWRGbzhDMkhnK09IdU84dEhxNXFDZnlj?=
 =?utf-8?B?Q09GdmIvZkY4cWxYei9FbXliRUNvL0RaTkdlWTRxbWhtUGpmVGhXOVFsNmhH?=
 =?utf-8?B?dlc2NkFORXNpcGZ3UVdBN3NDWnoya3BrbzNQa2JDa1VPeUV6T2FTM2RLdTFU?=
 =?utf-8?B?cHBxUXZDUy95N05EdnhVdjhJbnNZcXplamtTM2pick1RQXhNYTVTUUQ4aEoz?=
 =?utf-8?B?ZFZPeTdBcS94VjJKRGhJdU1aZFVHNXJldllmMDlZWXBvQkhCQkFyNHFxWkJL?=
 =?utf-8?B?UnNxekJyK0hMbVd3VVVIdFVQZjEzQXFad200cnhEYXZwOTJWNklLVThJa21J?=
 =?utf-8?B?bXNGU1c2dTg4Sm1VeDAxN1hnUGhPcUJrdmVhSUxsdWp2RmtjT1E2MnpzcXIw?=
 =?utf-8?B?U1RXU3ZMZldyZWk5bzNScjdOZXUzM2xxRDRyeHg3K3RUZ01ka05DOVdmNnlI?=
 =?utf-8?B?MUFIMlV1UlRFNExlK0xWNEM0dXBBNGsyRGFvdGY2Sjc5eHlJNndXMS9CMVp0?=
 =?utf-8?B?bFVBVld6elo3L3c1TE54UXlVK2RNYlhoM042S0ZkSTdnenV2aXFGUFYrM0RY?=
 =?utf-8?B?SEVyaFY4RzM0RndvQnpnckdsYlFLZXk3U2RGWjhSNmxtOE9vUWFmSktJeVlR?=
 =?utf-8?B?WWZ3bU1rcUZxUEZhTUZnd0diTXM1VXFxUHdFK3d0bTR6d0s3LzJzazMzR3VD?=
 =?utf-8?B?MEw2N28vNVMyem9tMUsrZTd0OVJWcGczaDJrL2pVUXREYzlFQWJjVFgycHFQ?=
 =?utf-8?B?ZjdSa0lneVB1WmR5c21MaUxySWZrNklVNEdXSUFZYko2c0Z0RDhNY0tFWm4x?=
 =?utf-8?B?b1JLTy9PWkQ5MmxjSTFEcmExeHM1bG1wblhkY2JRZGtRc2ZaRElIbExXUm8y?=
 =?utf-8?B?TUNQeVd6SlNLWGV6QTAzbGs5NGxkaXgya2kxam1FMXYzSEt1RGhHZm0zNWF3?=
 =?utf-8?B?dUM4OHdkRmZBWW5UMmxaQWcwSXYvTDJKOG0vWnF5cGd4akJlandNRDd1Vkta?=
 =?utf-8?B?TnBkSFVjM0RlaVRjMExYUT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB6588.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TE1iOG9hZ3NhOFIybWVzVWZMZWNZOEx2dmYwTGRvOGJGNzhoMlJ4T0ExUmFC?=
 =?utf-8?B?aC9KK0RGbmtwYjF1RXNOYi9JbzZOSW9PY2IxT0dxaW8vRk9Ia3h4Vlo4ZDJN?=
 =?utf-8?B?R2FOUXZDT1Zzbk9GZlA3QTZHeFhzbmtzMm91RDZlWEZvQUNxQnZFM3A2RXd4?=
 =?utf-8?B?a0p4TWQwRFMyd0REZk9tc2pwMkNzQXJUOEFpamZkSFJxQjNUYnJnWUgxNllY?=
 =?utf-8?B?bDRsU2l1MUQ4eXlJTzNvcnI4Nzd2azlhbTNaVHlEb1NpQWNTV2tBT1lXblg0?=
 =?utf-8?B?bnZYRXpsOTlPMVZXVGJ1cGFHbkIyZm1mSTFYSEFQN3Y0YXdUajFSWUxyRk1v?=
 =?utf-8?B?Y1d0blpPL1ZVYS85NkNqSWQvNm0xdG9zL29CazZLcHZJZWExNER3WWFjUEJo?=
 =?utf-8?B?clZPVEVzeE5YVmRWOUl1YWtuRVZweHFLSFFwNURIL1kyNkRpWWJPSXZHYkZx?=
 =?utf-8?B?NzlEY0FZWmhCSE5RZkxoTDVScDVaQTlaZDlhSC9kWElUalBJVy9OeXZaczFk?=
 =?utf-8?B?enE4QVJheDdXUm1iYUNWcjdLRlNqczJqeHpmaTRWbmUrcVZyTzVManVKWHQr?=
 =?utf-8?B?ZXl4Z2NrTTZZMGxWWlIyckFRODAySk1UMDVxZTJ6eTVSSWY3U21vZTFTSVYv?=
 =?utf-8?B?cVF1bFoySURyL2QveUhRSWpDVXNWZWo4NW8rTWhOVUdFNjNLdEdBeFJRR0VS?=
 =?utf-8?B?YUN5Y0FrZjBlUllzRTNHd0RUbW4veW5WZ1Mza3RncTE2OWg3MXhiY1diVHF2?=
 =?utf-8?B?a2dwdVM2a0dHbjVPQ0VrVlVrOE9DVXRZYVRTV3d6SW9wVlpiMnUrWjFyM3F0?=
 =?utf-8?B?Wmx4WXg0b0FrWm83cE80eXJYYXJYMlZ4VGdtR1k5T3lpWEVvUHZ4cHpUUS8z?=
 =?utf-8?B?T2tvQjd1TEQxV00wUWY3dDBGWnl1eW5wSFRHVDZ4ZjZHQWJVMDJwQ1hkbUJC?=
 =?utf-8?B?ZkhEU0diUk9KOFJud3A5d2JSd0IvT3ViaFAyaVpGVkhRTDNxQXFBMzlzU3BH?=
 =?utf-8?B?OFRrem55VlJpWHlRaFFuWDdEaXI0aW0xQmxDVGhMTXo2RVJ3VVZHWUo4SFdX?=
 =?utf-8?B?MjZpbkR3ZStyY3RQUnZVTEVRQ0ZlN2VQRm8vcWI0NzZiczJUSUlKL2tkeVhn?=
 =?utf-8?B?aHFMMWY0NitPeFBDN25Ed0tIU3l1TDhsQ2FrNDNJUzF2ek01MUFMU1gvUzdo?=
 =?utf-8?B?WTJVRnNWU085a0F5b24zRm0vYlpWRjdxVTRjOU5SOTdZTG43b0h3MnlTaGJ0?=
 =?utf-8?B?c1Rsc2krQklqeDRNekp1T3ZKaGFOeTJacTNRVXpUMGJWcDFIWDhSM0hQY1Rl?=
 =?utf-8?B?MzRsSWVvU2pKdS9wd3h2ZS9aYklZS2hCNXhTNVV5R0hIeFB0Sk5oQjZObFNl?=
 =?utf-8?B?bHJNeWZ3WVBDM3BoeEV5bDdra0l3SWlNM2RZNWRiWjBPUzlBZUNDQko1Tnhr?=
 =?utf-8?B?R2lSUUhuUXhwVjkwT2pWWHdFNmhYREVkOHVJQXJ4Mm1JN0MyS1doL0tSV3JL?=
 =?utf-8?B?ZkRmSzJRSW51ZUVEWHZBSzhReStpR0FKMk9mVTB5aStYc0oyOWpmRWYwL0Z2?=
 =?utf-8?B?M0Q5UmFPdndWdmQrZXk5R2FCUEpHaitqZmRSdzBnOS93WDF3QmZET241UjVM?=
 =?utf-8?B?VUlGaGRVSC93bnFKK2VjMTk5Rk5QRDhWZllUUFZrZXlQSmlrbS82SkFJZUF5?=
 =?utf-8?B?NVlnb3MvZjBGK1B4SVhaSVNBRWhQYmR6MHVJUnNvUFprQ3JrQk14N2lqS0k5?=
 =?utf-8?B?V1BOQklNN2ZvbERDQzJ1WjMyNTM1amxxWkkxR2p6VlgxV1U4aDVaRVJiU0N0?=
 =?utf-8?B?Z0M2VVdlQ1NoUUhQelVLMXYvZkxEYjExRGo2YXllNER1ZkdCM25iT0NEWXpw?=
 =?utf-8?B?dHd3b2NpcW1yOTNTVGxhT3cyUW0vUXU5OGF0ekp0WXE2V1JadFBxelNwLzZJ?=
 =?utf-8?B?RDZUc3pJU1NkcEdvMHhmTUVtZ2hWeUVRR09hNHQ5ejlySnJUMG9UdnpVZ0ti?=
 =?utf-8?B?VGJsSDJrYk5IOFBKSVFpaU1GSFNrM3J2MUdsSmFESElJWENDZDNISmVFR1RT?=
 =?utf-8?B?cWlrNjMycUVzeml6KzhEaXBBNW1Zd3hCblM1bU8weHZRS21vMVkrUmhhVFU1?=
 =?utf-8?Q?UST2G/K8ZlNCi/lDSjeHtnosP?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b9bf4c8-664b-49f9-343d-08dccd9f9d3c
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB6588.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2024 11:41:00.4825
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xvJDm+ScYFsAJU/qlsv1n/ZHh55nPSvS6O4/7BhiNGYJpcltgUR7s+G+lLYU7bEU4ABzFpCu5qsCRouzK4kyNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9421

On 20-Aug-24 10:08 PM, Ravi Bangoria wrote:
> Sean,
> 
>>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>>> index e1b6a16e97c0..9f3d31a5d231 100644
>>> --- a/arch/x86/kvm/svm/svm.c
>>> +++ b/arch/x86/kvm/svm/svm.c
>>> @@ -1047,7 +1047,8 @@ void svm_update_lbrv(struct kvm_vcpu *vcpu)
>>>  {
>>>  	struct vcpu_svm *svm = to_svm(vcpu);
>>>  	bool current_enable_lbrv = svm->vmcb->control.virt_ext & LBR_CTL_ENABLE_MASK;
>>> -	bool enable_lbrv = (svm_get_lbr_vmcb(svm)->save.dbgctl & DEBUGCTLMSR_LBR) ||
>>> +	u64 dbgctl_buslock_lbr = DEBUGCTLMSR_BUS_LOCK_DETECT | DEBUGCTLMSR_LBR;
>>> +	bool enable_lbrv = (svm_get_lbr_vmcb(svm)->save.dbgctl & dbgctl_buslock_lbr) ||
>>>  			    (is_guest_mode(vcpu) && guest_can_use(vcpu, X86_FEATURE_LBRV) &&
>>>  			    (svm->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK));
>>
>> Out of sight, but this leads to calling svm_enable_lbrv() even when the guest
>> just wants to enable BUS_LOCK_DETECT.  Ignoring SEV-ES guests, KVM will intercept
>> writes to DEBUGCTL, so can't KVM defer mucking with the intercepts and
>> svm_copy_lbrs() until the guest actually wants to use LBRs?
>>
>> Hmm, and I think the existing code is broken.  If L1 passes DEBUGCTL through to
>> L2, then KVM will handles writes to L1's effective value.  And if L1 also passes
>> through the LBRs, then KVM will fail to update the MSR bitmaps for vmcb02.
>>
>> Ah, it's just a performance issue though, because KVM will still emulate RDMSR.
>>
>> Ugh, this code is silly.  The LBR MSRs are read-only, yet KVM passes them through
>> for write.
>>
>> Anyways, I'm thinking something like this?  Note, using msr_write_intercepted()
>> is wrong, because that'll check L2's bitmap if is_guest_mode(), and the idea is
>> to use L1's bitmap as the canary.
>>
>> static void svm_update_passthrough_lbrs(struct kvm_vcpu *vcpu, bool passthrough)
>> {
>> 	struct vcpu_svm *svm = to_svm(vcpu);
>>
>> 	KVM_BUG_ON(!passthrough && sev_es_guest(vcpu->kvm), vcpu->kvm);
>>
>> 	if (!msr_write_intercepted(vcpu, MSR_IA32_LASTBRANCHFROMIP) == passthrough)
>> 		return;
>>
>> 	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTBRANCHFROMIP, passthrough, 0);
>> 	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTBRANCHTOIP, passthrough, 0);
>> 	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTINTFROMIP, passthrough, 0);
>> 	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTINTTOIP, passthrough, 0);
>>
>> 	/*
>> 	 * When enabling, move the LBR msrs to vmcb02 so that L2 can see them,
>> 	 * and then move them back to vmcb01 when disabling to avoid copying
>> 	 * them on nested guest entries.
>> 	 */
>> 	if (is_guest_mode(vcpu)) {
>> 		if (passthrough)
>> 			svm_copy_lbrs(svm->vmcb, svm->vmcb01.ptr);
>> 		else
>> 			svm_copy_lbrs(svm->vmcb01.ptr, svm->vmcb);
>> 	}
>> }
>>
>> void svm_enable_lbrv(struct kvm_vcpu *vcpu)
>> {
>> 	struct vcpu_svm *svm = to_svm(vcpu);
>>
>> 	if (WARN_ON_ONCE(!sev_es_guest(vcpu->kvm)))
>> 		return;
>>
>> 	svm->vmcb->control.virt_ext |= LBR_CTL_ENABLE_MASK;
>> 	svm_update_passthrough_lbrs(vcpu, true);
>>
>> 	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_DEBUGCTLMSR, 1, 1);
>> }
>>
>> static struct vmcb *svm_get_lbr_vmcb(struct vcpu_svm *svm)
>> {
>> 	/*
>> 	 * If LBR virtualization is disabled, the LBR MSRs are always kept in
>> 	 * vmcb01.  If LBR virtualization is enabled and L1 is running VMs of
>> 	 * its own, the MSRs are moved between vmcb01 and vmcb02 as needed.
>> 	 */
>> 	return svm->vmcb->control.virt_ext & LBR_CTL_ENABLE_MASK ? svm->vmcb :
>> 								   svm->vmcb01.ptr;
>> }
>>
>> void svm_update_lbrv(struct kvm_vcpu *vcpu)
>> {
>> 	struct vcpu_svm *svm = to_svm(vcpu);
>> 	u64 guest_debugctl = svm_get_lbr_vmcb(svm)->save.dbgctl;
>> 	bool enable_lbrv = (guest_debugctl & DEBUGCTLMSR_LBR) ||
>> 			    (is_guest_mode(vcpu) && guest_can_use(vcpu, X86_FEATURE_LBRV) &&
>> 			    (svm->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK));
>>
>> 	if (enable_lbrv || (guest_debugctl & DEBUGCTLMSR_BUS_LOCK_DETECT))
>> 		svm->vmcb->control.virt_ext |= LBR_CTL_ENABLE_MASK;
>> 	else
>> 		svm->vmcb->control.virt_ext &= ~LBR_CTL_ENABLE_MASK;
>>
>> 	svm_update_passthrough_lbrs(vcpu, enable_lbrv);
>> }
> 
> This refactored code looks fine. I did some sanity testing with SVM/SEV/SEV-ES
> guests and not seeing any issues. I'll respin with above change included.

Realised that KUT LBR tests were failing with this change and I had
to do this to fix those:

---
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 0b807099cb19..3dd737db85ef 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -795,6 +795,21 @@ static bool valid_msr_intercept(u32 index)
 	return direct_access_msr_slot(index) != -ENOENT;
 }
 
+static bool msr_read_intercepted_msrpm(u32 *msrpm, u32 msr)
+{
+	unsigned long tmp;
+	u8 bit_read;
+	u32 offset;
+
+	offset = svm_msrpm_offset(msr);
+	bit_read = 2 * (msr & 0x0f);
+	tmp = msrpm[offset];
+
+	BUG_ON(offset == MSR_INVALID);
+
+	return test_bit(bit_read, &tmp);
+}
+
 static bool msr_write_intercepted(struct kvm_vcpu *vcpu, u32 msr)
 {
 	u8 bit_write;
@@ -1000,7 +1015,7 @@ static void svm_update_passthrough_lbrs(struct kvm_vcpu *vcpu, bool passthrough)
 
 	KVM_BUG_ON(!passthrough && sev_es_guest(vcpu->kvm), vcpu->kvm);
 
-	if (!msr_write_intercepted(vcpu, MSR_IA32_LASTBRANCHFROMIP) == passthrough)
+	if (!msr_read_intercepted_msrpm(svm->msrpm, MSR_IA32_LASTBRANCHFROMIP) == passthrough)
 		return;
 
 	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTBRANCHFROMIP, passthrough, 0);
---

I've added a new api for read interception since LBR register writes are
always intercepted.

Does this looks good?

Thanks,
Ravi

