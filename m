Return-Path: <kvm+bounces-58376-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AEF1FB8FC54
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 11:34:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9D94F18A1C91
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 09:34:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 063E2287513;
	Mon, 22 Sep 2025 09:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="VthH+zbz"
X-Original-To: kvm@vger.kernel.org
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012067.outbound.protection.outlook.com [40.93.195.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4EBB286889;
	Mon, 22 Sep 2025 09:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758533655; cv=fail; b=gjl2+mmFBYNQ0iRX/Ok7Vja76Wn7hgJ8aHAhNtLkEyA8l8MZOTX7rsgrU5OoYkDOxC0rXCYMRetX14uR7jKUQmg+T62aSkJcaNbnYW2/kW2dnyiOzhypxgx3RsTpR68wYrqxKjnQnpZC8wgABpoR/e7J5ocxHlOwl72BysE8pWc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758533655; c=relaxed/simple;
	bh=TOwhcWBUoRiLkCXTguONNdNSYCufq75jXHpON0E7PoA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=vDekNdHq4111ii/mpY1HXWq2GFwiYDsQ61QWW0proNS/ItnkirfmbgBaZptZHdqd/8le201ZPsVUJrD5HpixqPV55sjUltSAv/KBcxd7E9TrKFUAq5h1fiSDG+c5cn1tFfM4dT/ScNKkV/2seeIrT66C4vFRzanCvb1xQchZK+Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=VthH+zbz; arc=fail smtp.client-ip=40.93.195.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=luGvYFSmLoxMVvYLirHApwPWwsirPztsx3P5ptp6DdEbP9vklGymuUsKFA96IsYbCtA0+vIQO/5ptdCz4L4Jy2jkX8nowEc+o2rxKC+yN4Zr7cb1T8QT2UYzH0u761WEyG8ok0F3zXfrn9S7hO2W1YkuNi1vlB6j2VA0qKw5iXydcwhAKtZp31Jln2cKx4nHtTmkGSSebmsGmE5WC7uVfsaKHuDL4cum682eHa7gPGCjBXwLyy6XHNpPFrR3KK7fEdsamsRtJB7HUSj+h2eqz9n2VtwXjoEPT3E43eep+rTWy5scFfHVsItlx+l7QBVRikYtnU+396RQKAIGxKfzXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/pLeot03CT3WpeJiE5mCL/18Zto0g7Vhf5WjVecZCng=;
 b=Kz4ZjXPGobVUW141UufsXcw8K0ibUpudCAd9yl1Lh/4xPzahZsgGS2kleUnG/wnttlMuRduIPBk5rDUPy4u1YcC+4bXT8PnokuX8OdEkBSxyNO8VFjFYib+I5RGmr2YIkkTqClQOsL+9yF9NF504HRKh8Ybrcku9XCSIpvtMC6y7b++n+R4vPeOP0ZcheqqWnUs/Gq9qF4zmgBA/mcpzOUbTFD5bVcfoUzYz0l/k19BZPfB7dhilwnlQw9Ab5Q1VHTFZlpK8eaJhtklK0uSVT8Bq2s7+LgmJvHgxOJ08eAOrFGT/K0GHREu6AhbxT9rWW7KHXKXUpi93D9CsfH0QFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/pLeot03CT3WpeJiE5mCL/18Zto0g7Vhf5WjVecZCng=;
 b=VthH+zbz1vOe7ZZNBZgC7yt+9WtddYmlKrWrTBwqop3zaKjQMa86oRwG5F4IZEl6OJP/WS5rsd7ZOlrbrVRBUteQKdqy5LEvS2OWqF6uSFhW9VTbSxNiFciaL7BW3caA4iNY4mDR+VKrDbX4m9d0J/P/i8YEOpKuxze1cj2B8y8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6608.namprd12.prod.outlook.com (2603:10b6:8:d0::10) by
 DS7PR12MB8371.namprd12.prod.outlook.com (2603:10b6:8:e9::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9137.19; Mon, 22 Sep 2025 09:34:10 +0000
Received: from DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627]) by DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627%5]) with mapi id 15.20.9137.018; Mon, 22 Sep 2025
 09:34:09 +0000
Message-ID: <bd8831a3-2a23-43d2-9998-73cd5165716c@amd.com>
Date: Mon, 22 Sep 2025 15:03:59 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 29/41] KVM: SEV: Synchronize MSR_IA32_XSS from the
 GHCB when it's valid
To: Kiryl Shutsemau <kas@kernel.org>,
 "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
 "john.allen@amd.com" <john.allen@amd.com>, "Gao, Chao" <chao.gao@intel.com>,
 "seanjc@google.com" <seanjc@google.com>, "Li, Xiaoyao"
 <xiaoyao.li@intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "minipli@grsecurity.net" <minipli@grsecurity.net>,
 "mlevitsk@redhat.com" <mlevitsk@redhat.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>, naveen.rao@amd.com
References: <aMnq5ceM3l340UPH@AUSJOHALLEN.amd.com>
 <aMxiIRrDzIqNj2Do@AUSJOHALLEN.amd.com> <aMxs2taghfiOQkTU@google.com>
 <aMxvHbhsRn40x-4g@google.com> <aMx4TwOLS62ccHTQ@AUSJOHALLEN.amd.com>
 <c64a667d9bcb35a7ffee07391b04334f16892305.camel@intel.com>
 <aMyFIDwbHV3UQUrx@AUSJOHALLEN.amd.com>
 <2661794f-748d-422a-b381-6577ee2729ee@amd.com>
 <bb3256d7c5ee2e84e26d71570db25b05ada8a59f.camel@intel.com>
 <ecaaef65cf1cd90eb8f83e6a53d9689c8b0b9a22.camel@intel.com>
 <7ds23x6ifdvpagt3h2to3z5gmmfb356au5emokdny7bcuivvql@3yl3frlj7ecb>
Content-Language: en-US
From: "Upadhyay, Neeraj" <neeraj.upadhyay@amd.com>
In-Reply-To: <7ds23x6ifdvpagt3h2to3z5gmmfb356au5emokdny7bcuivvql@3yl3frlj7ecb>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA0P287CA0015.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a01:d9::10) To DS0PR12MB6608.namprd12.prod.outlook.com
 (2603:10b6:8:d0::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6608:EE_|DS7PR12MB8371:EE_
X-MS-Office365-Filtering-Correlation-Id: e39de92d-4030-47ea-2086-08ddf9bb2e9a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SHN3TW1ib29XVm4wd1RrTXpzOXhPaHhTTmtpWXNTWkVZV3BHa3E2clhpc2ta?=
 =?utf-8?B?d0lJWkZKa2gxYUU4clEwL0pJTVdDWHJaNm5lNTVlTWtxWHR1eTc2VDZiVDE2?=
 =?utf-8?B?aWtKZit1UXdxR1ZjTWFRSW5ER1RXbnhvSjZvUEY5Tnd1dUM2eTVQbVhQZTJn?=
 =?utf-8?B?NHFNaXRGV21tT3pURmlybTc4NmRFSFE2R1FJTThueHlZY0lucmtrc3hDNmYr?=
 =?utf-8?B?YWJ2bjB5R1BlcUZJQmw0ZFFoc1ZoakdBNjZlUGwyNG1RY3YzUGFZcXY2ZEtW?=
 =?utf-8?B?TDd2QTUrQ0c5NWtJb0ExWm9lcmlTVzdQam5mQ0dMRTIvK0FzSi9paWdKR3Rp?=
 =?utf-8?B?MFdnQ1ZTM0ZSR3ZHb21TamNJRHN0ckhDWVZFVWk5RTRhU3N1TlFtTW9YZUJh?=
 =?utf-8?B?R0Z3SGNleG1JVzJXQTJDVUJEMEtQcWFrOGdVRXI2dG85SnVkL04zdTFnNE1M?=
 =?utf-8?B?YUNacE9xRFd6N3gyZUZMOExRR2c3NkdwQmFYS0lORC96a1NUbzFRZkljTEhv?=
 =?utf-8?B?NmQvY1dVZTRGcGkrbFZ0TlBWRVZmbXU5WnZXT3VmMHR4bS81eHhhTVpkNEVi?=
 =?utf-8?B?TzgxWUFWcTRTcGxFaXE2U1NTYUY1S0lSa3lCRTNieVlWSnBDelkzOGo2bkVy?=
 =?utf-8?B?bndpa3c5OS9hWCtyRm56Tkd5M0t5SWM5eHYwRnhvcUlBK29ybmJuMFRrNGdM?=
 =?utf-8?B?eGlLaDlCOU9sM2ZPSWw3Y3MxdEl3WmpXMWQ0b0xXc09BdjE4M1lRZjNKS241?=
 =?utf-8?B?TGZlWDBTd0JuQmhHNUI1UHpJYVJ3bkxCWVN4dlFHREQ2M3hhN2xMOXFvSVgz?=
 =?utf-8?B?cXlSZHdZZnljenlwaU5DbWVyRzNiVjRHd0s3b0p4ZXltbW1lcFVoNGFXQStv?=
 =?utf-8?B?WWhwZEROV0Ivd25QQUdEUWU1OHk3L3JaLzdla3NhbEFUbUlzZmc4TTBCcFJN?=
 =?utf-8?B?QjFXMkFzck1UcjRtT0FyYjNyU1NrYTd4TEdIdG52OEdjcmV4MnpZVUdPVWdl?=
 =?utf-8?B?RitjaWVWUzUwUVBXdmttM1o4U3lLaFBQZmFGM2hCRXRYNU05ckRpNlRZWE9J?=
 =?utf-8?B?SlZORlZoRkM3cTZmVnN5cy9wRDRBWS9taEVla2JPV240REFxRFpPcmt2OGFU?=
 =?utf-8?B?UDg1N3FNZ21FdTZhZUxMV2E2UFpTVnRvR3FoeFpxUzh5bjMzbmJ0Q0lFNlBE?=
 =?utf-8?B?Zis1UnVldDhFcit4anhlbVZRb0R5VXBxSS8xejlpY3YwQWYzRXNxdXRYQmwr?=
 =?utf-8?B?UGsrQ3NsSXYvU05oMlFaYXluMkl1VDlPYmUxcHM3K0pGNVZJbitEYm1zbTJD?=
 =?utf-8?B?QmhCTlVxNm5KUUMxdnBQTDZNbFQ0Y2dhVjd2YUt1UW9oNFQ4WDJJaU5nZEto?=
 =?utf-8?B?TTd1ZldWYzBqaEMrSUpTYm9oSU50amdOQ21JOHZvYXpyeUN4VFQvL2FYVEdK?=
 =?utf-8?B?RUl1ZlZac3I4UDhFT1ZqK1AwUVMxU0h3WXZiZkFmd21tUmxRM2YwVHhEckdS?=
 =?utf-8?B?WHo1VnVrUVZudC9EbWs1ZWgzajNBSU43WW5RbEcrYW9yTnVENU4yeTE2TWRV?=
 =?utf-8?B?Z1YyV0ZWZVJQandzdWJzbWhrWFVaNzJuY1E4d0pqQUdZVUFVSjlrejYrYTc1?=
 =?utf-8?B?Q2lQN0Y5QUZWZWVVK1Boa1ljQlNpVFMyV3dXWitHZ3BNYTB5MFR3MDRuMnVv?=
 =?utf-8?B?dTk4cWt1RzQ2U3I1QUFvbXJXQ1dPMXJYaHk0MEtnUVRyRlVmM1hkT2JYZXA3?=
 =?utf-8?B?THVjVmxmaHBnLzhuZzNyVWRlUjBHNXV3dUFkbHJZekRPSFVYK0drNVJPVFd5?=
 =?utf-8?B?aTJMUERXa3ZGNTFkL2JiTGdjUWhqYS81V2xaaU9rSFQ0cFF1bE5SNHlzdnBH?=
 =?utf-8?B?eGJpTDRYdjFOQzNyUlpmMEc3cEF6c0d3Y1I3VnBvYWk0SkE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6608.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Znd1dSswa1htdXVMM00rYXlHQ2lybUNRZFpOTFd2VzFSMXluWTVIQk5LT2Vv?=
 =?utf-8?B?UkdHZEVwKy9tK3hFSngxbHZZRm0yMWlJRVBuc2dKVjU2QW1PY3JROGZKMGpn?=
 =?utf-8?B?aXc4cnBFTmdDWTR1NzZOUHdHM3N1VVJGdlFYWGdDcmRMc0doUWlVbDJjNDZZ?=
 =?utf-8?B?a3hCbHdLTU5COVVUdUNwNXBIZU9pbnhBWG5nZWpXVkphL0xmQ1REWmdWakxm?=
 =?utf-8?B?SkxRR3EzdGhTeVo4U2w1MUJCT3hNWmp0cGhXTUYxcWlPVTVEMUFidWVCNEtN?=
 =?utf-8?B?WEoyb1pmT3ZHbyt6cHRBYnRVbWt2aEo0VlE3U001ajYxWW9RQkhCRGdwa0J6?=
 =?utf-8?B?d2F5cmRzc2dNUkxlK2MzcmVIL3l0RHRzZTNvT1M0aFdQNmNVUEFYcUJ6SnlB?=
 =?utf-8?B?L2NRc0tHd2k4K2p4UXpVZHh0OElWdHdHNkVTdGpzeTRhMWNhSXQwMHFxLzdr?=
 =?utf-8?B?aDZxVFhBeTFGN0hpOHhQTGEzQTJiY2dxU2wyeXFjcGlVYnJVaTFOeTFrWW9G?=
 =?utf-8?B?NmtqVUl0QU5PMUZRWDlyNHpNZnRtK2FhZ1piTktOREZETmZiRzYxbGtkOHAw?=
 =?utf-8?B?ZGJtS25JM2JkZjdscXJ1alg1VTd4U2ZzRFJEWmxjTk9yU0g3Q1QyOHk4U1JQ?=
 =?utf-8?B?YXVHQmxUR1ZHTlRGdFRTbk1CZkVvZ3g0bHdvVkVWVTJmekEweFFIZkMzeVRF?=
 =?utf-8?B?N2c4SHNjUzJxZXFVMzFjdGRYU0l6M3FtZ0RMSGZiNVVDNEREODRKWDBacysy?=
 =?utf-8?B?bnJ5L0dyUGp0czJlcERXNVByaTVHNFczcTJMMjZCK2NCZUhRWjdIcTlJNklq?=
 =?utf-8?B?QjhWVEdCRG5uRUxMWFpxSmpWNUNwZ0drZWVZSXE3bWFlU2hKZVhEWXRLcjhJ?=
 =?utf-8?B?aFRMN2RnUmJGUnhscHE4R2JhWGNmUG9aN0RTNzRFTytYczh6djBVOGZJRUdE?=
 =?utf-8?B?VUZGSEsyczFFOEI2Z2k4Q2RoM1hNY0pCSXVwS3RtVDIvVHNldFExbDNEVGNr?=
 =?utf-8?B?UGhmeGh2S2ZKZGJISllkS1ljRUhmS3luTm04WlFQaGpQOGw3RThOZFFLUWIx?=
 =?utf-8?B?ajQ1N0M5Q3BKOHdIc29NMmxVVmNFelhNNnFqT0pUSitJWkhrOE13UXVXbXE3?=
 =?utf-8?B?bkZ6VUkyMUJMVmw0aFJEWENGQmRrRUh0VlVQUW9yUkpjYVd4b0dxRHVLU2dn?=
 =?utf-8?B?bHc3ZlBUMXlKalVudWs3d09wR1pVQmQwb1RLbDQ3TXU1YzRoc3lyWk9EMmNO?=
 =?utf-8?B?bHFmZll0Q2RFaGthMW0vWEE5cGR3KzJiQ1k4cG41c3hPdFlLSE9Rdmk2bDNn?=
 =?utf-8?B?OUFZakFVSXBHaU9hVXNWRkQ3SUw1Z1FJcXExZEtzVVBwdjk4RWNtK1VpQ3lr?=
 =?utf-8?B?U2JLOEtGMW4rcXFrTUNlSUNIWXplMER5eSt1NXZ4YkRZbjhQRkdLbklvTFVS?=
 =?utf-8?B?VUQrS1NpcCtraFhZblQ3S2ZKVDRaTERodjMzRWNZdkF1NHF2b3NXWjhHSm5O?=
 =?utf-8?B?L1VYbXdOMVQ0Q0l0TVhCYTd4MnFlUG9LUDUrTXpHVG14NXMxdmRSeGFPVFJN?=
 =?utf-8?B?NlE0T2Y2QnZRN3BtOXBnb3BQM2Q3SXJZRHAxVHVvRHpyZE13N3dhNEh1S0Fl?=
 =?utf-8?B?T0Z4ZzM3WlEydWxiN2NnekFnMGY5SS9MbzN6MmRONFdrc0h0VUQ4Y2ZEVGNT?=
 =?utf-8?B?ZVRmMXhTTEVoK2J2UGNnU0RZRnRZcVRaMnd1eVJoYzM2TE5CQUppTWo1aElT?=
 =?utf-8?B?M0RGZEM0OXl3U1JTMEw3K3VwNmRhY1FhYjBMTXZyMmY3bWNBY1BLOFRwNVVi?=
 =?utf-8?B?MERpVURQRVdpRmNlMm1ZNkZodDdQMDlzQ1UvcXVFL1NkTC9USnpIRnVPMHRS?=
 =?utf-8?B?WEx5WGszM3Y3WmRpRTZ0RVpzcFMxc0R4RmtSR09ic3A2YUVFWE83V2s4dEpy?=
 =?utf-8?B?OGhtbDVLWnpsa21TQVlkU2taZmdxaGFNOGE3RzRCMUZPMTNRV0I4VDNhaXpN?=
 =?utf-8?B?NUdHcXhwNE9TdmhueWFwa3pmanlZN3U0K0hFd0hqR2F5SXc3eXFlTU5sMWJS?=
 =?utf-8?B?NXFkT2tBYlN3MkZSQ25lamUwY01GQnMyNDVHLzNsSlhQREt5eEEwT0JsOS9E?=
 =?utf-8?Q?QtGlRsUgq1oyo7QAbe6VXZWhT?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e39de92d-4030-47ea-2086-08ddf9bb2e9a
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6608.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2025 09:34:09.6894
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tKw4O+yrar/uhqF1ovdCqOgA1dvtD4W47/qPyriPCw5ns2rLlNLJ89YY8YzywDIm2U6BQxchWHqY1HPLMTvh8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8371


> 
> In TDX case, VAPIC state is protected VMM. It covers ISR, so guest can
> safely check ISR to detect if the exception is external or internal.
> 
> IIUC, VAPIC state is controlled by VMM in SEV case and ISR is not
> reliable.
> 
> I am not sure if Secure AVIC[1] changes the situation for AMD.
> 
> Neeraj?
> 

For Secure AVIC enabled guests, guest's vAPIC ISR state is not visible 
to (and not controlled by) host or VMM.


- Neeraj


