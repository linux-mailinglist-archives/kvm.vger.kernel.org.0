Return-Path: <kvm+bounces-50354-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BF4AAE45D4
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 16:03:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 01AE8172B50
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 13:57:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4AA6255F2B;
	Mon, 23 Jun 2025 13:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Q3fRIa5Y"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2071.outbound.protection.outlook.com [40.107.236.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AD2E2550AD;
	Mon, 23 Jun 2025 13:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750687050; cv=fail; b=RnYcLFzDTQYxA8d0MJDMhy8MdiFO3REonKqDPuU8HRjowC7SrcT/rA4aVo+JxjeW2wK2bPJ5S00watgAY2/lqff+OXXfYujXpNX++ZWF+doABksOcgzNC4OOsOmnwh3H7sqN8JN2kxIAupndHubWYeBWCx5gOhgLQgAHEJcrWpE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750687050; c=relaxed/simple;
	bh=K+9y9GpMvYWqrqkfzDQGI8+jLI65eMA3LvioAQBOU8E=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=DqGQ0NejHcxexexNlSPLo5gaH/vHToTRFN8dwUK2AGhbgH9BCB74D139UWTzdPTm31SKegPzHqyavzTWl3Lds/eD2uCUmPlnEKTmuYt0Aos98vGdBUSolkZ9CE40/2KRP/XDo+cxKRbOgJgJx+9preNEOwk7rWf40TwvoofZ1bI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Q3fRIa5Y; arc=fail smtp.client-ip=40.107.236.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M/qfwkctofS3SncJT9Zkrz1tuisHhYnpkL0HIpI/T22XxD4zxTBX1FU9O5lyey6BPAzChjvKjfad5DjjXLiFPdhjg+y31USWS0Eh+ppjYdx1s5qv2Ii+E8RnnRCpIK6YuSTF7hPwDBpLo6o+j5Pmvlw8TXLUE9CTLcHg463qZBcqFProvWDEpBIZ5bMknflYsD7TNa2L28NBB4tQYS4AiBw871X2GZZOBcx7oHCDSeFlECesWuoUjp4SN/mePgN5sStgUWdJcg4i46J9YDX70/R8YNPOTH5MDLeEsa3YbP9yJNa+BnzTG7TpwiBeP+fTYh1G79FUSj3OTgpVYJlUVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zeB6mpFid533ECQOom40pUkdHDPKCX8f/T8OJyvTQ/0=;
 b=Db4cAgkl7Rku5vl6wNlWSKQw+LkVasZRO+9iGKnQPmy18dmJdbd52JTQD5CjS09nAHCpGDzJCNIwGDKCTOrDlXfj+zASKoAbooIryD3A/Vz0H13iFkp3wpd3TGSVu/7/7BrF0+AGlutbwRu1N2JfPbhReiMl7cAmwhLsZjhH62dMOe9DAw/DuXoez6IBW1idrfOvoWnWsYQX5RE+4xn8oSIwt61SooreRAKlGKHZHxfg5bOPco5WTrrFmCxPHyVNtoZdj23grVfuD7PEIKeaRHh6RDfKszKTLdMiVLFQf3b2CBkCnHlm1A2ROKPls5xJoapxyAi39DBpYc0QzBqNxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zeB6mpFid533ECQOom40pUkdHDPKCX8f/T8OJyvTQ/0=;
 b=Q3fRIa5YvCA2AbhPzd3KEOXSUwbUGLRkKHGgdNqvSNNwaWDkxZlJ0a7GvXEKnPhMD/FQC3T8rlq0EF9cpG0+3Xfot96dFBQI44IxA8fB3A+EOIi7mrs5vlxS/Rf8bM8SZZHsoehmQKSbRJ0YB/ir1+Ig1dPzZbKlRd1bvbjzYm8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by SJ2PR12MB8181.namprd12.prod.outlook.com (2603:10b6:a03:4f6::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.30; Mon, 23 Jun
 2025 13:57:23 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8857.019; Mon, 23 Jun 2025
 13:57:23 +0000
Message-ID: <6b4b8924-c0a7-58ab-f282-93d019cd0b96@amd.com>
Date: Mon, 23 Jun 2025 08:57:20 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v2 1/2] x86/sev/vc: fix efi runtime instruction emulation
To: Gerd Hoffmann <kraxel@redhat.com>, linux-coco@lists.linux.dev
Cc: kvm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
 "H. Peter Anvin" <hpa@zytor.com>,
 "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)"
 <linux-kernel@vger.kernel.org>
References: <20250602105050.1535272-1-kraxel@redhat.com>
 <20250602105050.1535272-2-kraxel@redhat.com>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20250602105050.1535272-2-kraxel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0084.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:35e::25) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|SJ2PR12MB8181:EE_
X-MS-Office365-Filtering-Correlation-Id: 5acff83d-4a9b-49e0-1132-08ddb25de0e7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SzdTVHFKL3MrYmRGMXc5ZjBCcXpnRThzd2ZLREJrMk5RQUJvRlBsZWZGNHJD?=
 =?utf-8?B?ZUZhN0YyVjRNbXZLOEhxVm85cXIwcGpRL3ZoL2ZjeExtSWN2ZWFQd0hFUWE1?=
 =?utf-8?B?a0RQdlNxUHNXVHVIQkxBa3plZUEzelhCc3dRS1k0THczd3FtTEx2QktTK1Bh?=
 =?utf-8?B?djM5cUgwRW9TWUVQb1dLSS9CalVhK3kyWFY1dW9OV3laWWdwenZjSkFURTJT?=
 =?utf-8?B?a0ptajE3aUI2c2gxWHNDR1hUemdmU1VDNjBYT0VvWE5tNytGbStLeHlGb2s4?=
 =?utf-8?B?TGdZejFmZjkzTmhzb01Pb1NlS1I5VThucVBleDFZU2RxUWo5V08rcFg0ZnJZ?=
 =?utf-8?B?TEQzSzlBdVZ0MlY5aUgzeTlMVUJFSE1WQjBxZmY5b0pKVEhhWE5DeUdUdUNL?=
 =?utf-8?B?RWNkeW5rajY0dG50bDJWazQ3eVc4QjlmMjBrYWE0dkpoTTNIMU9OZDlTb05R?=
 =?utf-8?B?Q1NaNVNMWmVJTUhNYTNnM2pWV3gxOVIyZXN1RlV0cy9ybkdwcWZqQ29ZQ1JV?=
 =?utf-8?B?STEvUDdDcTFRc0JFRDRTMnJqZ3NQdFhtQ0xvTWc2NyttalBIMTdyWkdqYWV3?=
 =?utf-8?B?NEEwQVY0VitIRjZhSUZBL29vRkFJdE9hdWFKMFMreUJuY2ZmSnZHOXNxT2Iw?=
 =?utf-8?B?ZTFwU3p0WG5RamM0MDAyN2Rma2R4M3hZWjc5N0xzbVRQT2JBYkdTN2tVS1lD?=
 =?utf-8?B?OFhTNEd2OFhGRTZkdTFmQjFLM0VTV0kvUFRURVBhUTVMaTNJaW9sNXVjeElO?=
 =?utf-8?B?M1BtZXhPeWErRmVvUGQwcERhbE9HZVVVMytNeHBINmVpN3Bxd3d4Qll0cUly?=
 =?utf-8?B?MzhMc2xkTWd2OGtJVU1YaDZaWWVBYmQ0Z2NuOHhBWWJKWWJRZnZVaUpCQXhN?=
 =?utf-8?B?SXd1c2NWbm90MGEwV3JFMGo2YnRuRlB3bFNXRlRJdHl6Mm9uNHM5U0JGT0s1?=
 =?utf-8?B?TlpaVDFFOGVFRE5qci9admpXNUJHVFlRcU1oUkhRb0dDSkFXNG12TXJDc1ZK?=
 =?utf-8?B?a2FzV1g4cUcxZ2g4Z2JPMklqdWxnUkRVWTJWQ3VaRmlnV1JoWjlGYjFKaW92?=
 =?utf-8?B?N2pQSnU5UktXRTRSSnRQcFV6Q2lHY0RmcUtpREZSNEZhYnlnc0ZCY1VDT0sw?=
 =?utf-8?B?QkJqaUxkaCt4K3pTa0tZM0h6eTVQdXhhTWZFTEJtQkMwSVdRMTdZdlZBWTVU?=
 =?utf-8?B?ZlBHVWZlU01VbHJGV2RxRFlFMUNnQS9nSG5QWWZjNGdUd1lhdFN1bWFOVUYr?=
 =?utf-8?B?eDBzUWpGZm5KN3ZZQWgzQUdFOUFwcW5nelBKWitxQm54UThCQitLQk1oY29D?=
 =?utf-8?B?dUJTSnA3ZFp5U01HTFhWU084ZHVWaVRCU2lIYWNBZXN3d2Z4a3VXQS9FdkVK?=
 =?utf-8?B?TEdvUVJoaHdGNGVjQ2JIT08xSExzNnRJdEZQTDkyaHVuanFGMVRxU1BYTEZa?=
 =?utf-8?B?Vm9ZWjM1NlRlOVlmcXpBYy9BeFFaVU1mRXMrakNzKzdTWmFweFRqN3gwK3Ay?=
 =?utf-8?B?aWd6YzV4d1F4Mndra0QyLzZaekxWWXo0WEFURjZ2REVsdFkzRzlkck8xZVlJ?=
 =?utf-8?B?Q2NYRTdmWXNTUXJwU1pPc0szSG5nZDNwc1pTM1RMWVRpTVk4SjdkS0phdkhv?=
 =?utf-8?B?ckl3SWV5K3g5UUZVWVBQejEzeUM3MWhxeTlyaUxpN2Z6aXphWklYMzY4RUwz?=
 =?utf-8?B?UmR0Vjh3ZnlzNWtZNlNNcE5FZCtVbDRRNXRVZ25vYTVmZGJlRzMzUG83OVlI?=
 =?utf-8?B?VDIvV1RBeTVOSDlzVkk0N0xlaHp3YzI4MTdVT0VrWkxwZ21TT0g4TUJxQWdG?=
 =?utf-8?B?ampkOVp5My9VZmRjQlVCRThsZkpQMTFKOHp5NFdXTXRBaVJPWldTS0tLM0dm?=
 =?utf-8?B?dy9SMTdzMkZIcHRHUUdvSGZIc3NWMnlaUmlaK1cvMkpOL1ZqcHpWc2Yxak5w?=
 =?utf-8?Q?9TXWyP4pvS4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Q2dzUi9jNyt5K29ibSt5c2Q5YTJJQUo0RlZ3b0RIQlFINzBXZXpzRnVVYW1W?=
 =?utf-8?B?S1o1QlhyRDBYRERENHJIUkhCZ0s4SWFFbnIzaHVtWXQ4bGhpN21jSHVFUGxv?=
 =?utf-8?B?Q1NQUDZlbytYOENvMHZuTEY0Z0RDQ1VrbFRsTjdHQlBFWmJUVjlLdXkxamw3?=
 =?utf-8?B?S3AyOW5hMFJQQVlJZFFUT1JrSGc5bnNGSkw2bllWUjlua0oxMWx1U1pzOWxz?=
 =?utf-8?B?NGVGNHQ2MjRlV3lOYzJ4Z2FIanN1SFN1SjlxK3ZIUTFtOUFNTDNNajQxVnpT?=
 =?utf-8?B?S0pYc3BzZGhHVFJUSnpQMERNcEwxM1B5Zk01MElGU2hiUERSZm1OV0tRREw1?=
 =?utf-8?B?aVQ3WXp5VHI2cEhzbDF1bWZuTENKMGVNS3lLYjlMTTFYUkxSQUlBRGZZM05D?=
 =?utf-8?B?aTYvTTdia2czOTFtYXJrUUFkZnNpNDdISDh1Y2IxZmUzSVVwK3czd1M0ckNi?=
 =?utf-8?B?NEpxQXE2dWd0ZWxZWDlLK0RkT3ZzVFhxaFo1ZEY5L1Q5V2c2MnJmckpRajRE?=
 =?utf-8?B?NjBIZ3B0SFJveTJBMkk0V3NVVEJrem5SZGorRDJvZmFaRTZ4eWwxeGlCYXNa?=
 =?utf-8?B?eStPMi9UK3BTaXMwbkYzeEVJeHRZc1d3a0o1SERpSWxEZDhuVnRITmpWOGVz?=
 =?utf-8?B?NUVzRWs1TEYxSjMvdWowS2tOam1IWmFlRXQvTzFRVnA5SVdhWnRQMlVaYlE3?=
 =?utf-8?B?am5tWDRIeWFMMFg3NXlwOEppWC9PMjlLclBUckpDWG45VVdPY3laMFU1MzNR?=
 =?utf-8?B?dXk0S3lsZEhzTUNRU0hkamlOc3RLYkZYRGhJMXRwNzZEb2xDSk0vNmlGRVJ2?=
 =?utf-8?B?K2t6emJRR2s5a1dqTXErZUUyNHBwb3JYTnlkOW5lanZRMDBDV3hmLzFHVXNT?=
 =?utf-8?B?QXpDaHh0MmRIRGJ3QVFHU3FsNmMrTFJRVmdFZ3h0UUgyQUJLdDhOWXhTd2Fq?=
 =?utf-8?B?T1ZZYk0yOEprcEM0RkJFRnNDOVJYSnpxZUlGNnIvZ3FmdFVJaHRlN3l4SC9U?=
 =?utf-8?B?RC9Yd0xQSnNYSWlUSjZGMG5yQTZOZ3RvVW9KNjVhTnh2MGN1Ky9mZFg5bllL?=
 =?utf-8?B?Z1VRZ09hMGM1dUh6Q2R6TmRFTHBTWWowckw2NVNJcUh2Sm9yU2plcCtiNHJa?=
 =?utf-8?B?aWhBZ0Rpbk9BeGFyNkR0VDQ2RFVPQ2N5NFlIM0FYVHNFcllmUXA5OHBkRDIv?=
 =?utf-8?B?TkFxRXJRbXFCVUZNNXhNNmhmTkowTTUySkk1S2U3WnR0aHBidkVTTGVwdUJE?=
 =?utf-8?B?OFhpNFJWaFh2cWp6aGpQTmdscGpUMDlxdUxqWCtUOW5EVDRES09HbUdab2hL?=
 =?utf-8?B?UEg1QXROVlIvYWNvdHJoQkdqS043eWpEakRVQk5oblVlRDdSSUN3ODdiNVVt?=
 =?utf-8?B?NkswVWdicFJ1TWMvclpOc3JoQ25ET2pYK28wQzFPbWRYdVJTM2hhOHJwVUFB?=
 =?utf-8?B?Y25Tc1NTeGN6cVlqUWdJcjFLaUNCWFEzS1ZoWWJTWk5WS2hDdWFQWk9iQTNk?=
 =?utf-8?B?elJNSm1oYkE0Q1I5cFF0UUIvVEx5TnlxNzhKWmNUV21lR3dMODdoaFhlVFE2?=
 =?utf-8?B?MXc4Rlh4bytkVUdOa1VwRkhJZDNkV2lZSmxsMlZXL09wcDNuOWJUNWRGY1Y0?=
 =?utf-8?B?ZHpQbVg5dFlFWnpaWG9GNHRNd2daWXhCa2dqVlh6Y1BSV2ZaNFlIY3NGaFhj?=
 =?utf-8?B?KzVFNUV5WE10RktnTGJTTnRJeGdUNXNLZEZKbkFubE1SSEE2N0ZMb3FPYzRj?=
 =?utf-8?B?V25BMzNzMjZCbVdSWE9EWnAvS1JzQnVlWDJTbVdvVTkxSHFTZVdhYkFTY2Jv?=
 =?utf-8?B?dWFMVDBhWE5zb2xhVHFQamNmNm4vcGtEOUV2SWpYWmlKc1pTQlFZT1UvVW8w?=
 =?utf-8?B?MzRvUURkMlcrSHpnS2ZpTGp2eDZXVlROTVBycGVwUk8yamdPWXcwSFNmTVVy?=
 =?utf-8?B?cnp5UlBNdVhaRTNXSVhkQ0Q2cVFSVzB2S2ZFNU5YcU1ub05tZGs1SHBENUc2?=
 =?utf-8?B?SkdFZjA4UW9ZTzJpWEJ0djBDR3ZRZTROcHg4bUxwOUx3U1RVSWMvYkRNb3Iy?=
 =?utf-8?B?ZEY4YmF5R2RTcmRXRHNXemlpbHVab0FTZThUemIyYjlCcHhDU0dLalREdU1Z?=
 =?utf-8?Q?+3dO5IR8Bh7l9PkdCrvjVxHpL?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5acff83d-4a9b-49e0-1132-08ddb25de0e7
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2025 13:57:23.6318
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g5JS8PBEqEsiDtRsO2ltUqwr2gmzM8bvY+ySaNb7sogRGqdH67usg8icF0jjiJfaAjqdg9G+Pkh2idxW+wTMgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8181

On 6/2/25 05:50, Gerd Hoffmann wrote:
> In case efi_mm is active go use the userspace instruction decoder which
> supports fetching instructions from active_mm.  This is needed to make
> instruction emulation work for EFI runtime code, so it can use cpuid
> and rdmsr.
> 
> EFI runtime code uses the cpuid instruction to gather information about
> the environment it is running in, such as SEV being enabled or not, and
> choose (if needed) the SEV code path for ioport access.
> 
> EFI runtime code uses the rdmsr instruction to get the location of the
> CAA page (see SVSM spec, section 4.2 - "Post Boot").
> 
> Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
> ---
>  arch/x86/coco/sev/vc-handle.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/coco/sev/vc-handle.c b/arch/x86/coco/sev/vc-handle.c
> index 0989d98da130..01c78182da88 100644
> --- a/arch/x86/coco/sev/vc-handle.c
> +++ b/arch/x86/coco/sev/vc-handle.c
> @@ -17,6 +17,7 @@
>  #include <linux/mm.h>
>  #include <linux/io.h>
>  #include <linux/psp-sev.h>
> +#include <linux/efi.h>
>  #include <uapi/linux/sev-guest.h>
>  
>  #include <asm/init.h>
> @@ -180,7 +181,7 @@ static enum es_result __vc_decode_kern_insn(struct es_em_ctxt *ctxt)
>  
>  static enum es_result vc_decode_insn(struct es_em_ctxt *ctxt)
>  {
> -	if (user_mode(ctxt->regs))
> +	if (user_mode(ctxt->regs) || current->active_mm == &efi_mm)

A comment before this would be good. Something like:

/*
 * User instruction decoding is also required for the EFI runtime. Even
 * though EFI runtime is running in kernel mode, it uses special EFI
 * virtual address mappings that require the use of efi_mm to properly
 * address and decode.
 */

Might be too verbose, but that's the general idea.

Thanks,
Tom

>  		return __vc_decode_user_insn(ctxt);
>  	else
>  		return __vc_decode_kern_insn(ctxt);

