Return-Path: <kvm+bounces-39899-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id ADEE4A4C8E1
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 18:12:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8A89D166B15
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 17:06:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4BBD22B8B0;
	Mon,  3 Mar 2025 16:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="nLlNx0YU"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2057.outbound.protection.outlook.com [40.107.220.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51153253B6F;
	Mon,  3 Mar 2025 16:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741020556; cv=fail; b=eDDq2B6UQLJXXO1PxW1dqqB8XL+jAZVX+U0uScV7F4OK1Pe/DLkMejHoGxCj/+OsPd8nLO8OSFBAogXXJp4dxQIzosNyd5eV9ABqX4Pfql8iw+L3seeNLS2yQccc0wrZOCoAbhVrAt4XJKHLQlz1rLBBmExGYy4DnPHM+XRX83E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741020556; c=relaxed/simple;
	bh=WySF0Wa6i4Bw1mAJFejxOXcNOC8D/Dh8yc0Ig0OVNU8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rKvjapk1wUBWK4+pXbgd3LS76SVlQxIqOEX2bMtIQC+4mVWAuw1+AMayq1JUkX/JuS9CsOmZZdSIp9a6G4D10rpu2/mz6aorXEF3i9J2ktbAn2P1Iq/7qGwRAOJygqXdw2K7BhNuRSZeCtJViz5UJCFZIMjSCVv7eZKABhrq600=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=nLlNx0YU; arc=fail smtp.client-ip=40.107.220.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QzyRPyOmolnP1Jf40YX20GIfNRYqoaiHQrDYThJgohYCDLfAk/A5th7CQ4sS/+lRwCf2+snFqVNI7K/PgAgpqWwgQzSQYFWQErc/KYt2U8bzp+0n23RWvRY/B8IBb0Y5UMGdMj28gkCWtZZJIlZVlfZ+1p7HdP9UnVS3lc5/pQnhIfW6ZG0xMwW5wkqBOBFH3Il7TI2oDsMfz7sgObX49ceYQK4K8LzZA759ii1mXDCwGLj8nupjz8klvzBFsEMEuRE9Og3yEeYAC8sAefgSoU4d3oPYCaZ++aaIoCkW502nONXXz4FbWZrm80nmWU+868t7/LWGXQlwlASfknusvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bx1aJ1zBxPJBFpVk8FOzE07T8jShu4wr8649RAWv36M=;
 b=sR7W00Eyf7sNLMGjMR7rR2Ls7uealNWGWEQ3K6PFuHjhQsJwMPMc8lHF4iDAZoPwmkExiRDlJ+ft535eQQsMSyPxcTBFlaxDLm8sYjVv29ZG+LDpR/t93DtyyLqrqQxo5n6N4r5lLjLkvEDjoEORsdAVO5zEs58kqBtsNylV4nBhLlDuiiU464frIiCX4TqXdrU2e31og0ZkgrlYQ0WIiA8MedJFhk8wEqgsSOtVLCTCCz2GaNfMlMFPGF4poScmwFgnom+0ybjMpp5887s3R2v5obmaZLyEb/Z/y2BypsVvRhfNZ2OeIF/yINmZV9jBJHUeP21DqQkHhn+hNINtTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bx1aJ1zBxPJBFpVk8FOzE07T8jShu4wr8649RAWv36M=;
 b=nLlNx0YUKeZa/rqWLytvggZlU07R0yealtQcF34oEkZv109ix7bzujAE4Eh/AOVCqAkj4U7F2JDGLxJ3mWvr+NoBJqZyxcZLFD8wlPkwEQxvxBu4cP35KWd2BVz4IdSXm9VnRF8UYGJ6YFeb7W0Y9fAj++/6S8GBsHEbwEL8FT4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by BL1PR12MB5779.namprd12.prod.outlook.com (2603:10b6:208:392::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.21; Mon, 3 Mar
 2025 16:49:12 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8489.025; Mon, 3 Mar 2025
 16:49:12 +0000
Message-ID: <6fa6012f-d48e-2863-d9f8-d029fba6c5b6@amd.com>
Date: Mon, 3 Mar 2025 10:49:10 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 5/7] KVM: x86: Use wbinvd_on_cpu() instead of an
 open-coded equivalent
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 Zheyun Shen <szy0127@sjtu.edu.cn>, Kevin Loughlin
 <kevinloughlin@google.com>, Mingwei Zhang <mizhang@google.com>
References: <20250227014858.3244505-1-seanjc@google.com>
 <20250227014858.3244505-6-seanjc@google.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20250227014858.3244505-6-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0187.namprd11.prod.outlook.com
 (2603:10b6:806:1bc::12) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|BL1PR12MB5779:EE_
X-MS-Office365-Filtering-Correlation-Id: 80313fa5-3e58-47bb-0ffa-08dd5a73538c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WE9FNkVRclBWcXlCdWxOUmdBWTBmVVRCSVJNNlpSMHJrbkcxdUo5MFNBZ1hy?=
 =?utf-8?B?cTl6QVVwMEdXemZPUlkyOFA0blBUQWI5VG0rOTJHRlh4R1c2QUlNR3BZNVZF?=
 =?utf-8?B?TjExRENGZElXbXhvUGx4VnhVdmpTS2xmWjhyR0VNKzl1T3dWOUdVQ2pqRU9X?=
 =?utf-8?B?RVJGeVJSOUJrRGNvMjJ6cStBYU52emxBQkp5Q0owVlFvNEYrMjRYNkVLUVpu?=
 =?utf-8?B?T1V4aEtpdjdMb3VlSVBSOS9BZlYvdGh4UEM1NkJzZDhYS0NTVXg2RDE3RURn?=
 =?utf-8?B?Zy9KbU9OUy9nUmV0VTBsZGxVdjUvQlpWK09ZVS9taDA3YVdGRWU2eHA4T1Zq?=
 =?utf-8?B?M3J6MmtaSVdkOU8xcWJBNndUc3hNa2kxUkdWQmF1UEJIYm5JbUxMY0dyYTcw?=
 =?utf-8?B?MjArOTBrT1dvT2IxcGlNeVRBdUtxaWVmT1poMkFnQWhmMDl5ejBTNDZaQjlo?=
 =?utf-8?B?STRreVhLb25MbzV2MGltalN4U0V3ekpadTljdzlRNDh1Ukd4SmJvcFFhV2JU?=
 =?utf-8?B?WFFOTTI4YnBvM0d4NjhDd1RhMFlsNFQxeXpOcWdIVEVWWlBQOXhtTDdOaDZJ?=
 =?utf-8?B?TTAyWjViUE1hUXorcmxEV2t4dEV3V3JlQjV0RWtJR2ZEVGJ0RnQvR084Q0JJ?=
 =?utf-8?B?SzQ4eEpGQW5nOVVtd2k3T2xIRjBXMnBjUGFmeWFyQW4vMjEybkZ0ZGVoN2d0?=
 =?utf-8?B?NzlRMlNLSzUxd2x6cFdJZU9UYk1sTEFRakJqWGlHblVqM21mZDR6ekFMbzZM?=
 =?utf-8?B?QjYzTGp3WWVrSTNnczBuL1VHUFJISjNuOUZZWFBVWGQ3a3Q0UWNQSmlDK3hN?=
 =?utf-8?B?eUJ4TUhvd1FkU0MyenJMUHcySU90MUtUTU1qQXZZYWtLOXg3WEErVmJpMHF4?=
 =?utf-8?B?RTBqUms3b21lN2Fpb0pTM1JSSnJCczR4TkZaclRiZnhKOEdrTmczOVB0TTNF?=
 =?utf-8?B?dHEzMFFQWnlwRnljVUZtNWxnMVlaUDBuWVRVc3dBQmlCVHczM2hOcTdEV0VC?=
 =?utf-8?B?Z0Y2RytlVXlVSEZpN2hWUzhFMXE5VkR0cWdGMXhjU3JnbGJhWHhoZGsyTk9l?=
 =?utf-8?B?eTdad1NNNSttNzUrWlNXczF5aEJuclg5dTB1bitwN0ZadDBucWRjL2dUVjFF?=
 =?utf-8?B?TVcxc1pmY1Ava0FGbkQ5akQ0c3JuaHVPWlc0ZzQ5dDZDbGw5ZklTUWw0VGlw?=
 =?utf-8?B?Y3dMQ00vM0h3ZnlPQmhPdlg4OFhPL3BwcDlGTjhkMDJjcndLTVVLVTBCeFNU?=
 =?utf-8?B?QXQ3Y0g5QUhTZnpyYmxrNjUrVGszN0xLRnF4TCtkNlpPZnFkd2FuVE9UWmVM?=
 =?utf-8?B?TTJMZkJ3SFBrdTFZTU1LSjFBUG8yZTFGVklvZ1RwdjQ2Y01MYmlCLzV2aFlH?=
 =?utf-8?B?RHZXcW9SK2Y0eEdONUx2cVdJY0tEZHEvYlpzaGx4dFpKVGl6Nk5KcE5uWUNW?=
 =?utf-8?B?RVBwZk9GbEpySjh5T2FUUk9IK3ZPamlydWZvVVlUVEJqdThha292RFBPTURs?=
 =?utf-8?B?TzJqTVZ3Zm9hcytibmduS0RTWENSM09RK2ZnRmd1QkU5ZWJ1VDJUV2xQQ3A5?=
 =?utf-8?B?WnNsZ0wrZDhybEZiYUpBOEl6VlpOWWNBN3IwdDc3cHNBb3JCbFhMUVd1V2xl?=
 =?utf-8?B?N1U1TG96V09pNDBHWGIzWFAwT3cvS2o4NTdRcUdrMlorSnBpYjF2b09ESTZo?=
 =?utf-8?B?bHFObzVQVmdiMUcrbTF5K1NUQUl6Q2x6bzBtMnY3MndHc2FGYWZxNU14ZGhN?=
 =?utf-8?B?TnpHWWYxcDNPYUU2eHhLVEUwK1Q1RnRodXVqTjZMV3ljTHJlRkVDV0wrbzZL?=
 =?utf-8?B?cXoxbUZOS010V0JMTEZVQlhJc1VzbU96cy9VaU5aOTNqV0JuM0NYdGFqSFdD?=
 =?utf-8?Q?3JJM+MHCgcIl7?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?N3pHcXJObFd0dGREUzN6SVBnTFBSMUlDZVNCRUFKWDZvR0R3SGtvOTBac1cw?=
 =?utf-8?B?Ync5amVodXFlaWVmSFU3RndreUZnNzhQeWJxM1BPa25UY0dsL3p3emlNT0JD?=
 =?utf-8?B?ZXBmZHlRNklCZlg0aDRkZ0hBMDVtd1QxYStVY3cyYkVvdmVBQXJrZENrZTFa?=
 =?utf-8?B?Z080Y3ZuRHYwYldYNkczS0R2NHNMU2pSOTNUUW9kdS8yZ1pxT0t5Smk1Z2NI?=
 =?utf-8?B?cWFUZmZHamZwVkNqbzdHRkg0RU5zMzhFTUREaFB5ZjNXUUc0bnhRdEpzVXVW?=
 =?utf-8?B?T0FPaUtKU0lScE5DVnZIdWxyM3B4bHd4VVV6d0JRVDZhQ1ZsOHFibGVON1h3?=
 =?utf-8?B?K1JNTWc1RTV3OUVEU0JHbmNUb2V3Smw0Sms4NGJrK0w5cTQxZTA5elFHRmhr?=
 =?utf-8?B?SFFqWGhUUG5Kdm5rMnVubjR2dXNjRlJTYjVlbms0S2Y5b1pBNjNqRzNTWmpI?=
 =?utf-8?B?c2Y4TWlTNGFnSTNxaENzUmdjaTlGcWVzNUtxK1F3K29CTjNVUU52dEJ1cEJh?=
 =?utf-8?B?K0o2MlhNU1VZZGRRdmhLazA3VzA2bU5QMWtNRWdpZ0ExTC9KOXFLWWZ6YUJ3?=
 =?utf-8?B?VklGd3RMMVBsS2N5Y2RyR3lKUXZMUFpnLzdwQ0hJMUYzREZJL3FKN2habTU3?=
 =?utf-8?B?QTN5ajI0aFZTM1lHWmc5aTh4TFZRODNFNVhoeXMwS2xGZUdoTFF3azhiRHgx?=
 =?utf-8?B?NTFEdE14SUhaMWFSM3J2OU1pMXJHOEJxK2dnMlNXNnNmN0VpbEhQd3V3TjdK?=
 =?utf-8?B?WWI4M0lGQXhuQWdERFB4MGZMV25sbmNJeUlzbUJrSTFQeE1wQU50NGF3WG1W?=
 =?utf-8?B?Znc5OUdNRWhrWTJEUDdPRXh6UDNlSVJkaXo2ci9pL0VGNlZQZ2FPY2dhVmxC?=
 =?utf-8?B?QWlSeFJuWjhVOWNwS3hiTWVBSUtCeUFqQUc0NVRocWJuVWswaGppUGZXQnZZ?=
 =?utf-8?B?Nm5ZSTRRaWtiSEJuRFVucWdYZkNQZU9CcWJvUEVVTnZFa2RuQndNRnI5bDJ4?=
 =?utf-8?B?MWs0SC9FWEdYeUN3NElTWU43ZVFvRSsvaFhmQ0lZOXE4azAzcFBGRjlnSUpJ?=
 =?utf-8?B?TGRVQjh1elc4N09PM2hoV21Ubm01Q1JjaFhDaHJIVkJoV1NJbmFBY0FxN285?=
 =?utf-8?B?UmpVN2kzejNuRXVOTDc0WlY3TWhzbDU4SWdkazRCcEdLYmpYVFAwNTVKbDBo?=
 =?utf-8?B?R0VJdXNpSTB1cFAwajI5Y2tka1FuWGJLa05OR05jZUdGVmlZbEtYNUt3Z01h?=
 =?utf-8?B?UlEvbVMyZnNsV2VnN3NOdGMxS2lmbS9NMzV5d1I0NjVPUGFNTFlWcDhrb1N2?=
 =?utf-8?B?UEFXdjRvdGpjU1E0SDV2TlZjRXhlT055ZklrNTZGK0F2Tm4xRFMwZW1VeVJP?=
 =?utf-8?B?a3A3czBVZVpiVWlMU1NyZWJIQ3R5MmcwczdrN2h3L09xR1daZy8yYVJ2QXhI?=
 =?utf-8?B?czZRc0g5NEF2Y0I5bW96Zy9VU3ZvdUxGZmNuTEE4VmJoMjlGaWQ2NHRNZjhW?=
 =?utf-8?B?MWJSVXdvTlUvM3BPMFc5QWRzOTdLcW5rVzgyTG90YXplRXVYUmhGN3MvQXJ5?=
 =?utf-8?B?ckpxbVVZZkd5N0g5ZjA3NXJLQi9hVFR0VzljOC8wUlJMT1daNDJyWE5TbE1V?=
 =?utf-8?B?alg4dUtyZlNDNC92NFRPNU5rRENEUlpHdWZOMHdSU2drSSt2U2ZBdDY2Y09I?=
 =?utf-8?B?YXRZZXN6SldiaWxiNU9JM05EbFBFR0hTYnJDeDFhWW5NcVMvdmtVOXdOa21U?=
 =?utf-8?B?M0NQQlJqaTVuZ1pVTWRDTTN3RHFlamkxQzZoOHErcG5SNXp1YUM3MWY5WEZx?=
 =?utf-8?B?RjJENE4yRlhtR243OGZCMlhNaVRnbDV4M2tETDJ0alRNUzZienRpYUN0amYz?=
 =?utf-8?B?MEtWM2ZtVElDLzJLMWE2QTdXVUg4b1pMSnFGM3dqcmxKR0ZNdHhvNVlpL1NW?=
 =?utf-8?B?anBEeHl6V0RjaTlPVTh0UGFMbVQvbEtDN0gwazNQRGRNQXFWMWk3Q081RzJr?=
 =?utf-8?B?YlV6bnVXUUJBd0pVMlBidUpjZExGMmlPUU8yMFh4NUp5bno3K2dkUGZJU2dv?=
 =?utf-8?B?NC9uYWd1d0JNZXJVY3FzMmlteDN5VFVrNmJsamRIRUNDVkhoYVRwMmZZbnFQ?=
 =?utf-8?Q?LcedTAdH2FpNc1HwbIC7wNB60?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80313fa5-3e58-47bb-0ffa-08dd5a73538c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2025 16:49:12.7480
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aIE+NFgVc5PhYOuVZIg5oNO35tSP62iePteK/EqxWKVBTgm7wbQsCuX+4dBFB3gD7Ucs5AhWkLQ+ed6bhUkXTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5779

On 2/26/25 19:48, Sean Christopherson wrote:
> Use wbinvd_on_cpu() to target a single CPU instead of open-coding an
> equivalent.  In addition to deduplicating code, this will allow removing
> KVM's wbinvd_ipi() once the other usage is gone.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  arch/x86/kvm/x86.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 58b82d6fd77c..eab1e64a19a2 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4983,8 +4983,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  		if (kvm_x86_call(has_wbinvd_exit)())
>  			cpumask_set_cpu(cpu, vcpu->arch.wbinvd_dirty_mask);
>  		else if (vcpu->cpu != -1 && vcpu->cpu != cpu)
> -			smp_call_function_single(vcpu->cpu,
> -					wbinvd_ipi, NULL, 1);
> +			wbinvd_on_cpu(vcpu->cpu);
>  	}
>  
>  	kvm_x86_call(vcpu_load)(vcpu, cpu);

