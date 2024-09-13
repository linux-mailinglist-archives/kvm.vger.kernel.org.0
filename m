Return-Path: <kvm+bounces-26836-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DB4B978629
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 18:49:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7765D1C22B3F
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 16:49:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A915D80C04;
	Fri, 13 Sep 2024 16:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="tf0SU293"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2055.outbound.protection.outlook.com [40.107.212.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B3592F24;
	Fri, 13 Sep 2024 16:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726246160; cv=fail; b=S1Kv4cvXne3UnShswNbaAqFC5kUTrqH+NcNjJKYoqZGKKU9OCWHmapb9Hb8Z3hriGOx1uiBc1qGAqdRW1W5kgd1l0UmH43WUr9wcnLqIXVer0FYAx0bQClEdFujQU6yPTkUqU563BvoAh5tNUOQayI9NBGBPZ+dorwmRfYpmsT4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726246160; c=relaxed/simple;
	bh=qvtTDT/F/YGLJ+BYs+enwOqssnUlowk3gW4cqUAwfkg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Myd4+hrPPy2xI1cIuq/sjbeSe6dsmT4xrdvC1VgEuIWHERi2mWrMj1w3ixqcR9xb/zAumDBrfJ6lc7jPh73EoeGXtbcUWf0wavC0PYtNjUjjPGD5U3I1rOy8kVfuCrfnaBvB8BMGBN+G4zT9dgKXiGSKF7K2M3+bArYaRzmQsB8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=tf0SU293; arc=fail smtp.client-ip=40.107.212.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b1q/Mw0T3r+H0SqwoB+oHeYLF5Nr/qYdoKxkDs+EbfssVTR9XrzFRiDvTAMuVj+Zvliy6bKNqAXHfqrVnxxRKcgmw5MTbIEPokfTPD7ZTCTXQ9+NUIEk02ZdzFp1Y2h/yMnOgBz9tGS+PdE4SjXmAKr+VG71xt5m5OdX7j3vJ3Pjw8f5RYCHr0hmf4L8jRtn9oUofZRNqsk8fCfoOR7XXCP5Uugl1GKOvTxRJ3sqdui9XwL50+PKJg+4XKOZZ3Kw8uE1pfcyxWOlnxw5XrADvI7BMm9B2s60SoJGPHFbAbWnSBZXq+5JywR4hpvXemJjkZvePIQjvS9BQ1n66hxn1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BL3zvXyam4BcPk4TLg30KklNCOFQWimAZz2uFmE7awk=;
 b=hhz9mC1dqhN6O0PD4YRqomgUc7NDIfzyL+CzkOHM8QcaPnmcIE2MD5kNzOClKLzDJKnEfzBf9zxg7suScw55fPzxand1IR1WO9mDgO/0xnL9oHtOaOYgg2AF9sIcfskGD5NbpkSL91hNbW0wgcLJQ6YM07Id0KC2Tr6Skh9doquYzdepBaLRgjCzqeS+J/NO0LXJjIo5OmHMs/GccBt578Mt+N5A7tCXhvmRfgISYN+hVYNyXCbT/O/EV+Ao4njnSaPPa207zY/vXit8WcDbad1D2tH6GqXGQMql5AdAPwAguQkQtoP8eFXQbgLMukCxZSbK7fazYLZcHh9qcEuZUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BL3zvXyam4BcPk4TLg30KklNCOFQWimAZz2uFmE7awk=;
 b=tf0SU293qtPh3zKi73tSxzx2haLITfLhus3Oy5efOyocL1RQhyZsf6fZzlLxf9lx+KpHJFse6/WsCinH8csmS/fg4EM+kA42ri2qWoYAyPEYBNAzicxAweuq+TBXkqo9VAL8PZw6cePkUpR2g57o9JkicbjXFkr8PnmYmHxS0O0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by DS0PR12MB9039.namprd12.prod.outlook.com (2603:10b6:8:de::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.21; Fri, 13 Sep
 2024 16:49:16 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.7962.018; Fri, 13 Sep 2024
 16:49:16 +0000
Message-ID: <ac0e03c0-832c-98d6-843c-756f130dd6cf@amd.com>
Date: Fri, 13 Sep 2024 11:49:17 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v11 16/20] x86/sev: Prevent RDTSC/RDTSCP interception for
 Secure TSC enabled guests
Content-Language: en-US
To: Nikunj A Dadhania <nikunj@amd.com>, linux-kernel@vger.kernel.org,
 bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
Cc: mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
 pgonda@google.com, seanjc@google.com, pbonzini@redhat.com
References: <20240731150811.156771-1-nikunj@amd.com>
 <20240731150811.156771-17-nikunj@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20240731150811.156771-17-nikunj@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0153.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:3c3::17) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|DS0PR12MB9039:EE_
X-MS-Office365-Filtering-Correlation-Id: ac8dfb6f-16a4-4332-f09f-08dcd414002f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bHlwUlZGOVVISWR4OXpqb0Y1WVhKT2t4dHdGa1NkUHcyUnVQYmdDQnJlRGEr?=
 =?utf-8?B?OHJjSGtNcGZ0RFJYMWx2VzdFOTYxR3ZYVHA3Q3UyV295RmxNcVo2Z0lseFR2?=
 =?utf-8?B?bC9jQ0k2bnBwbTlINlNIVnpTdlpRZC9tNmlaTm5GbVQ5cnkvZUcwRnFyOXdS?=
 =?utf-8?B?dHp1ZFlMUkZBSW5obi9IdDJtaEZ5anpWYlNubC9CTXRLOXFCNzBDSVRFWFhy?=
 =?utf-8?B?T29SaW80cStUaWdvT25UcmVQSDBCc1hBRFlnWlRObTlmWWpUVFBnY1RMa0tC?=
 =?utf-8?B?NU1mODhndDk3a2JNSlJjQ2dSK05DVUx6czRlajFtZGtsV1JpbGdSTFhmTCth?=
 =?utf-8?B?N0hVVVdtSGZkNXg1UE00ekhOT3FYTG1TRDNoNHNxTXRBK1lLUkRQQWY1aTg2?=
 =?utf-8?B?U0JxZ3FUV1FNUFVPeERSdS9MRG5nbTZjb3Vka1RSMFhNT3laOVpzUWYvVDdT?=
 =?utf-8?B?QXdUdTdMVDM0YTRNL1RoOGovYzVJWmJWMEpjSlpvdkw3MHFtZnFFRTI3UkQv?=
 =?utf-8?B?NlVDM0hDc25KcXZtTUY5TW9FcUN6eEJwRVFGcmVyQkNQNW1mOXdCckxKTTlD?=
 =?utf-8?B?Z3JtSFM4bGFWZHNsUGVkelV5d1lNdkVTbHZaU3ZFOUQvRHdEUE45ei9RQmhS?=
 =?utf-8?B?aWV6VGlBVVdoTjZCK0FEMExBOG9qMjBiYTYwRDNoNElBMTVrZ255UVA2SDRH?=
 =?utf-8?B?SHgyS1V5d0hhYXdlSW4rTTJsWjh1QW91aTlMZ0tsVTIrUVF4YVQ2b0pmaThE?=
 =?utf-8?B?L0l1c3djNXFLbWdldDNURFM4ZHA3T2xzcThqSng5bUtPYXdHN0FuWGdkTVMr?=
 =?utf-8?B?MTlRak5NTmhLUWhsWm5OaUE1OFVlQnZsZE9DWUttZy81aUluM3czYXZUVFU2?=
 =?utf-8?B?QTlaQ2NoMjg4aXkwMGM3NjUrRGtvOGhaaXBMVi9nMDlwOEhxY2JFQlVTaldF?=
 =?utf-8?B?bUZIVTVxVFdCWDVPa1VzWmpsdHFVdUxaNnVqK3YxWE5TU3hlY1labWxZMjNZ?=
 =?utf-8?B?eHJHVFJrdVJ4SXh0a095UXYwbzBZRGgvMlhVQnNvZkVBZWZibEtwQnpxOVdi?=
 =?utf-8?B?THc2TEt6cVBqRXd5YStFUUlmWm1RWFRzVzlyZkZJOWtlSXh3MU5sNXBKSGZj?=
 =?utf-8?B?RFp1ZHh4T2ZzcTBzOG5sbGh5ZllOMDJoemxRZUI0OU1UTUw3VXZrVXlxdk15?=
 =?utf-8?B?amRlaDRkK21VOUI4WHZjNkxIYVFjYmhyZlN0N3g2RGs3QlJzUmwyMzNSYklV?=
 =?utf-8?B?MkhadSt2R2VDeWhGZUc5U1RvUkU0bmpwTXVuR2s1aDBhaWhnRStnaE1XSDBq?=
 =?utf-8?B?cGZzNFF2MU52WWhDWm1PclhqSVFkak9mM0grTjc5TkZ4VjcyaURJTkxIcG1I?=
 =?utf-8?B?am9UVk1kMEZmdWpJVGVzQy9oMWc5U0x1K1VXamMvRy9FT3ZaVEpoRk1Cd2tR?=
 =?utf-8?B?SmEvUy94VEViWnlBYkFoSDE5WG0xZjQzSk1ERlQycE1yd2Fza0E2b2R6bFBj?=
 =?utf-8?B?TmtHWUx0NitrYnpKTVBuYWNwRnIvdnhxMEZoT2hHTkR4a2RKR2V5SHVyQmZo?=
 =?utf-8?B?WFJySlFNQVJGYkw1OHR3Q0R4Z1UzVWFqTFhPeGtmSWN5K1QybWUxMTFNK0lX?=
 =?utf-8?B?YUJmQ09iTVRtcDQ1dGpYY0ZpVS85UjBMVUFoaG1kSmlIU29qRVUwTk9wUDFJ?=
 =?utf-8?B?ejJXRjF2TWdaMWxnL2xwL1dmK3Q0bkNKeXlkK3FBcEZONlBHZ2lvazBiUUpY?=
 =?utf-8?B?L05JMDhCNEo3ckFYWDlBdDBETXBNRjNqbW5hazhIaVdtMWw0YWsxbDNiL1Bm?=
 =?utf-8?B?Q1UyLzdENEZBbHA3eFBzZz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MmZlRWJQRHN3dXljcGdNcjBHdXYvenVoTHcvQTVXaVZyN00vR1RvdnZOK1ZL?=
 =?utf-8?B?WU9Mc3dqczA4d05FeHFRcWVLWXZWVFhvMTM1L0c0Vk41bWhpNU1iWCtzL3M0?=
 =?utf-8?B?SW9vVUNGT1hpQ3FCN1VScXZibzlGcnhWTURTR1RQeVdHNngrdEFuM1NVaWV1?=
 =?utf-8?B?OFBJRWZMNWN6aXVCUUExVksyYVJPU2g5UTZKNksrY05vNW9pVmpGRlBVc1JB?=
 =?utf-8?B?MFBxQXpsRVEwS1hWd0FZODRjT2lqQ3I5d0I3ZFhoRHBmd3pLZldtRXJ5NFlI?=
 =?utf-8?B?ZVp1UjZOVDU3SDU4QUhSd2dDdWdhaElZMGJ1dDBiWkJWYVRpNzRGY0RmRy9Q?=
 =?utf-8?B?WGEyaGpocDNodEJuQ1dOU2FtN0t3aHBIV1MvVW1XUUVXMGtDL0JEVWZ4UjFx?=
 =?utf-8?B?RjN1VHlKbE5OTXU2NG82T2N4SEozL2NLVTlHNXVCODdHUWpMYlZpNXhYUlhu?=
 =?utf-8?B?ZTk0aFU1RXBkcU4wWHp2K1ZiRU5OMDJVTlEvUmVMTUliM2NIQ1FhMGlDOFN1?=
 =?utf-8?B?dE93UnZSYTJBTDIxbEdvVGQyYk53cUpoQVRQWTJmd0U2aG00WVV0eHhMMkd6?=
 =?utf-8?B?aDJyVW5nMGRZVGV1NVNMdWpYV1RTUm04bzhiSkdzZ242cUFBMUZEeTJJTW9M?=
 =?utf-8?B?SWNiM2NOajdJSnpMeUxQa0E3bk5QZlFVN3VKbUluaEdXWmhQd1FPM1laVHpF?=
 =?utf-8?B?NEdiY21IVEl6eU9DR2E3bWoxTFJtWk5rb0x5VW9raUJkS0JTbnpkdzJDUjNv?=
 =?utf-8?B?ZEhmZnI0ejNPRVp5MGhaZUQ0czA1N3NGcWt5S1BSRzR1MURLVUprNm5XU2pJ?=
 =?utf-8?B?YnJvZmxEazlWWDNKb0gzOTBpV0ljV2hnNDdDQ0xpYXE0a0JLeFpYc0taY0xI?=
 =?utf-8?B?UDl5MTdxN0EzM3pUSW80U1RhUkxuckltSTFhRk4zV29tT3ZuazFHKzZKNWxa?=
 =?utf-8?B?ck11YlllUU9KblNnSmd2M05FWmNmai9aNko3T0RkeWh2Q09iVjVHVURrL0Yw?=
 =?utf-8?B?OWxEMmZqQW9rWWpDUUNJZDJDbW8zMlEvOTVkdDZsajBFVVI4WHpnYWJNSHh2?=
 =?utf-8?B?YVhYWndGNW1rQlFUdzBWS0I1R044eCttcnFOM3U1WEVuZ1VvRHVvYmVOZ3Bl?=
 =?utf-8?B?UmhsTEUyZml1Y0prUGZaZzVoWGNGWjZKTWNOWmV3WlJqbVpPZlBJYWI0K0hl?=
 =?utf-8?B?bkIzS2xscFdCYWIwdUE5Y1lJTkZ6amdXaFFhYnRkWDlhcDJxL0hRUEtMUE5E?=
 =?utf-8?B?eWRta0MyQzVWcFdlRHdHVElzc1YzQ05iY1pYcEx4dUYzNlRrRlhmT3d3cllG?=
 =?utf-8?B?U1lKVUowc3NMb09zaFRrSUM3alQyZnF0UUQ4enF4ZWZnRlUrQVArckpqeSt2?=
 =?utf-8?B?cmk1V2g3Q1gzeGJkZkRaRFh4TWMrWS9rWEtrdTdsbGdJV204VGo0RlE5ZFhG?=
 =?utf-8?B?Ni9WYmR2OWFuUGRKTUhaMFJpSTZodmg2MFdraUhBcHNsVDJCUW1OU09ReW5L?=
 =?utf-8?B?aDZMeUFMTTJBdlIrWWljL1VoVDRFY1JTc2ZJNnRzSFB3VmlvM1RsdE1jNXBI?=
 =?utf-8?B?WURDekMrNnFNTE9ZRFlud0g4RE9qdTdNbUlIS1pweFc0T3QwcXNGcFlGN0kr?=
 =?utf-8?B?TTZobE1McVlMbE1TZkR6akNiVUVQWENMdGxoQ3ZCZFhCMXNGTVhsY0g3cndY?=
 =?utf-8?B?Qi9jVTh5UmtjYUUxWElIYnZ0bkI5V29Fb1JHSmcyWW1XN25ONFBZTEdIOUNJ?=
 =?utf-8?B?WFA0MDZwak5wUG9EL1hwU1dxZWxSTCtiR2JZWEpxZ3hoY1JpU1o4eC8wUmZU?=
 =?utf-8?B?VnpnNDBEa25oaWtmZHpZOWlGdFBHSERNSHdDZEZHLzEvVnhuQm1rK2dtZlVH?=
 =?utf-8?B?cW9PdzRoTklseFBGbkJNVmRtQnR5Sk5uQ3lFTXlJRmpvdDhmWVZFa3JXeS8r?=
 =?utf-8?B?a250Z3lTYjdBUkJMdTk5V1Y4akZObFVPZE1VZWhaejdpUktqQkh3ZXBTd2ti?=
 =?utf-8?B?YWZGL0k2cURyTkNnSmhLSUhrSlArV2d0c29odkUwSzJLRTYxb0MzOVJ5YzdR?=
 =?utf-8?B?Qzd0RzBoMTRQRDZZSDhIUmYySk1Xa0xIbksvTVNRVzJVV1hKMCtVSXl1YlJq?=
 =?utf-8?Q?Jquk9OU7ImKu3rKjtNpNnqyez?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac8dfb6f-16a4-4332-f09f-08dcd414002f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2024 16:49:16.2732
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RpIc9XPFVXMjLC2kZu2J9jkCWjXXvoAEZPrI6kMiMH90vvHbNPIIqOk2LKuo0BkWrksLHqORM8aVvYiichtb8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9039

On 7/31/24 10:08, Nikunj A Dadhania wrote:
> The hypervisor should not be intercepting RDTSC/RDTSCP when Secure TSC is
> enabled. A #VC exception will be generated if the RDTSC/RDTSCP instructions
> are being intercepted. If this should occur and Secure TSC is enabled,
> terminate guest execution.
> 
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> Tested-by: Peter Gonda <pgonda@google.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  arch/x86/coco/sev/shared.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/arch/x86/coco/sev/shared.c b/arch/x86/coco/sev/shared.c
> index 71de53194089..c2a9e2ada659 100644
> --- a/arch/x86/coco/sev/shared.c
> +++ b/arch/x86/coco/sev/shared.c
> @@ -1140,6 +1140,16 @@ static enum es_result vc_handle_rdtsc(struct ghcb *ghcb,
>  	bool rdtscp = (exit_code == SVM_EXIT_RDTSCP);
>  	enum es_result ret;
>  
> +	/*
> +	 * RDTSC and RDTSCP should not be intercepted when Secure TSC is
> +	 * enabled. Terminate the SNP guest when the interception is enabled.
> +	 * This file is included from kernel/sev.c and boot/compressed/sev.c,
> +	 * use sev_status here as cc_platform_has() is not available when
> +	 * compiling boot/compressed/sev.c.
> +	 */
> +	if (sev_status & MSR_AMD64_SNP_SECURE_TSC)
> +		return ES_VMM_ERROR;
> +
>  	ret = sev_es_ghcb_hv_call(ghcb, ctxt, exit_code, 0, 0);
>  	if (ret != ES_OK)
>  		return ret;

