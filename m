Return-Path: <kvm+bounces-31387-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 70A779C331D
	for <lists+kvm@lfdr.de>; Sun, 10 Nov 2024 16:22:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 93E3D1C2093D
	for <lists+kvm@lfdr.de>; Sun, 10 Nov 2024 15:22:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2A216EB7C;
	Sun, 10 Nov 2024 15:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="0UA0NEZj"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2085.outbound.protection.outlook.com [40.107.220.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42CBEA923;
	Sun, 10 Nov 2024 15:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731252143; cv=fail; b=d7CjzqNVfZRPu/o8ACT+myFm0UsUUy920KO8aZt2DwgJ6cmy06oqGNjBDeTqkgpy6YGMiIUS+G+hRXgVf/pVPxEeM69Ra3S6kMyiTNzvh0AJzjny97S1Q36FG7x5bUX+nuzEYmA5bv40q72BX4UKZgW/kVZ0Hgc7ougkZLSfPRc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731252143; c=relaxed/simple;
	bh=yaw7vnyGBDD7FZsmmmhkcyCmwsIoME348UYT81MgSE4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=HSQCtKgjmVh3vA6g548eMV104p3GYhIyhE5vfHG98d37S2MFY7fiio8zTSb1ecRcR6VAPMHDP/32czPFyGl40YV80H7oDnkSOqYcOc+vm38nGqnnMQILMHXHPVuzw+RLYiIXtOmjKuuxSIXR9YuzL/bTHoVds0XlKRyisuG0k40=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=0UA0NEZj; arc=fail smtp.client-ip=40.107.220.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R0gHVrQSaZEyN0aj6G05NTGL4vKuJ4CcTx+pKhwtqnvJy0s5KGsA39BE6gSeu4i+7TOlKy1Gvp8y7BdSBOBJ5h7sYYej+c2KHAh8SEpKXrfLEIcgJxdY81KkIzAZYWS/mkMQ0bekCzzawATghtuFaHDGLUkRGCvFhxFpAQA1t79DDCT3jiyX3SkAZqghlK37mSlrk57mAqcMLngwyb5NqRk7C2ttc/XEaLfrCe5warGc8wIREbUdCVWVPL6s51G83mi+fqIbyPS71NFU8HHebXYPuOMmczQvvJCtPu7wnaDYWZIHrTPHqyiyrkd2IKerJ1jk/hEJZc1YyoWqWOSmMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y+BYCeaAOOrJv8KcdFjpvgxk23dNnKDEUGe66QKAYmI=;
 b=lpFhqZgAL1KWiC4FnLC4GCyYud6WVJUCO8ePLUbqdsqW4auJD3Oe7ZnYy+HGIx9B5KRxoHF2SYAsANOOufWh0fNp0vZ+Nt2VWp+/9eiGu09gL2kAKTyc3D87VktmXekErekKBnG9hX55tqm/LI9Ky1tu/NIkWa1HsKwTaxH321WzEp2Op6RYuBvdwNaHpb4hnhedlMAzTD9/SF4ClkcdODVnhtOKaxD449qu9yAaAiJzJzeTEuRU+IDM19MSZ5cPhAc9v/BnfrSOcHoFe0VIszoxiZsTb5bsPpMSXhLRABZ0Jt2H4VU3l7W4iVqwvZAaOSznzXRewSF0S+EUCo9f3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y+BYCeaAOOrJv8KcdFjpvgxk23dNnKDEUGe66QKAYmI=;
 b=0UA0NEZjiLFboumy4ORO2XBlNU8NZiZQpgFx/nSS0LAUULITs8kX1xG5eIjg63nBS+PRAqum81s5K3FZ/PDFT5yW+VwpxNeN0BumgZf9uIhfIzNaLcUNhTn7cY0BbYcgo95+I9+L5CpAm1cycVcIU964JCPPayR2Pn0z9AypXfg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6608.namprd12.prod.outlook.com (2603:10b6:8:d0::10) by
 LV2PR12MB5728.namprd12.prod.outlook.com (2603:10b6:408:17c::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8137.25; Sun, 10 Nov 2024 15:22:18 +0000
Received: from DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627]) by DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627%3]) with mapi id 15.20.8137.019; Sun, 10 Nov 2024
 15:22:18 +0000
Message-ID: <674ef1e9-e99e-45b4-a770-0a42015c20a4@amd.com>
Date: Sun, 10 Nov 2024 20:52:03 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [sos-linux-ext-patches] [RFC 05/14] x86/apic: Initialize APIC ID
 for Secure AVIC
To: Borislav Petkov <bp@alien8.de>
Cc: "Melody (Huibo) Wang" <huibo.wang@amd.com>, linux-kernel@vger.kernel.org,
 tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com,
 Thomas.Lendacky@amd.com, nikunj@amd.com, Santosh.Shukla@amd.com,
 Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com,
 x86@kernel.org, hpa@zytor.com, peterz@infradead.org, seanjc@google.com,
 pbonzini@redhat.com, kvm@vger.kernel.org
References: <20240913113705.419146-1-Neeraj.Upadhyay@amd.com>
 <20240913113705.419146-6-Neeraj.Upadhyay@amd.com>
 <f4ce3668-28e7-4974-bfe9-2f81da41d19e@amd.com>
 <29d161f1-e4b1-473b-a1f5-20c5868a631a@amd.com>
 <20241110121221.GAZzCjJU1AUfV8vR3Q@fat_crate.local>
Content-Language: en-US
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
In-Reply-To: <20241110121221.GAZzCjJU1AUfV8vR3Q@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0067.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:99::7) To DS0PR12MB6608.namprd12.prod.outlook.com
 (2603:10b6:8:d0::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6608:EE_|LV2PR12MB5728:EE_
X-MS-Office365-Filtering-Correlation-Id: be0661b1-bccd-48c1-c7dc-08dd019b76b3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eVBTT1pWMmFjTGY2WGZybkVEY3JvN1JXZWlTZXI1T2Y0ckpiWnZoQVRpN2Ix?=
 =?utf-8?B?TFJONGw4M3NMMWI3KytaczY3WWUzNFNwQnpGTnVVMzhCd25DbWVkRHYzOWN3?=
 =?utf-8?B?ZzJKOXJmQnpGaldGQXp4ZGpVc3VGVVFnTUV1bDdhcnZrYit4ZTV4YjNMWUhk?=
 =?utf-8?B?aVc5cXJKeEtETUg0S0t5YWt4OE1JMWlYbWdRQjYxYXU1bnpHQXZjM215Umkz?=
 =?utf-8?B?VXkwMEg5Q0FoUzlEVDVNaVJqUHAzVGJMbnI2dW9RMW00Y1VqU3lLK1pNYXd3?=
 =?utf-8?B?ZzlNbXBJQ20rL3VLUzFFUGtPcXl3MitoaktqdTdlTWh1Qm93L3YwQjAvZjRr?=
 =?utf-8?B?cGhLZTdKcm9veG85N3pnV2Z1SUQ3R0NsYjJWS2NLNHRxYjVRVGJIdzVZZlZY?=
 =?utf-8?B?UzBBbEJYeFRPRTNRVXBFRGtnVXJQWE9hVkI0V0VTYlFza1VBV21ZQk9GeXhV?=
 =?utf-8?B?WkQyekZ3TFZtaXhUbVRWUWFHYU1hQ3BRaDNJUE5nOG01L2J5Rm45UmtkOXJ0?=
 =?utf-8?B?bjRSeVJhMDhlY0hvUi9TUmJ3ZzQ3WDlNSDgxQlRUQXlvSHJiL29uZmY3UFMx?=
 =?utf-8?B?cWpoRE50N1ptb2pIdUFOTzBKV21jY3p5aG83OWhmNm16UXd5b3FQTitNRzFz?=
 =?utf-8?B?d3hyeXRZL1E0ZjhVVTQ1cUVsZXpINDhSdysvQWdmMTg5RUhpanc3b3BpUUlx?=
 =?utf-8?B?cnFRNlR6VEdXbU9QRGVDYzM2WUF1VzRyZDFHUTJNRkJpeno4YXNKN1ByVGJu?=
 =?utf-8?B?L3lISmUrSnVyRjBqQXlMOTdDSmd6OEF1NldydDhOSnZ1M3NDSm5YQ0Y4ZUtS?=
 =?utf-8?B?KytYRXlpeGFQcGl3ZDBycXJDdi8zczJMQ0lTZGZvRXNoK2VKdWhkTGZTZXYz?=
 =?utf-8?B?Q2Zwa3hpSmlIZjBnY3cwRTBxckphYytnbnRaUmZjNUphZ3pDSkF2aWxGRzlz?=
 =?utf-8?B?alVCKy8zS3hscE9UQ3k0UkFQaVAwL3NIRHBWSS9iVGttUmk3aGVvUVlYS252?=
 =?utf-8?B?aXI1c0tBSFFqK1VIMUxjd3B4NmxvL0dNQ2ZGZHJpMnJVcm1zeFFUOXRtTGho?=
 =?utf-8?B?cjdxeGZVOC8rRXBZaGVGM3Mrd2luMTlld25HOCsrQnllUnQ4UnBHcS9wUVBp?=
 =?utf-8?B?TUF3bWlxc2t2RCtkZzBkaWdSZVBXaEhOekhlS2RvNVNITmZNODVRcjhEM0Ev?=
 =?utf-8?B?UUhCN09xcWNYUWNvOEp1Tm5KZi9YeHhxRUNtRytiV3pOa1IzL3Z0djBzSEVX?=
 =?utf-8?B?eDQ4MU9JbXh2eUEzSWhUODRyMFZCVlNzcUZERHRQT3p5YldTZ1daUzYwOXQ1?=
 =?utf-8?B?NGdlSnQwTTBUazg5L2FQQnFOaExuQ2NBWjFmOU56a2N2aHJxU1JMOWJRY05k?=
 =?utf-8?B?VUt1VzQ3aW05TDA3RWJLS2dZZi9WWE9LNm5xdTFYbmxtQVlFWXlpbjNuNjZx?=
 =?utf-8?B?TTNmZXp0clNhOGh0NTVtQUNTTW1ZWnpNSmpKVXdIakxXU3R4TldmSTFXZWpH?=
 =?utf-8?B?T000aTdWNjJueEkxQllDMzViZzA2N3A2MldkR1QwNDRCU0h5WjloM0MwZkIw?=
 =?utf-8?B?aXNJZ09DME40bnZFKzN0WU1sUjFPYXZkUHlDYVhjNDBaZ2ZEcldyNmlQSFJi?=
 =?utf-8?B?MmZWQzdTTjRXMVhVNUpTZEJ3WUJ6cWRkeFY5Q1VaUXdVRCtHY1ZkOGlVUy9D?=
 =?utf-8?B?enFOY09CMTBER0NpRzhmb3FLcWc0MWk1aUQ5WlpRSnhXRWUvR2ZwNnU0bXlx?=
 =?utf-8?Q?RYP2BZuEA91ac0BxqKZI8nZFuPGc5NeQ86WKQCZ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6608.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bVdPdG15aDUyUjdmSGxPcmw4YVFCbHZ1VUJaRGgyY3Z0MUJNeW8rOVBteTRt?=
 =?utf-8?B?am5adHpsUWduakdPZmx3MjRMaW11Q2dHSVVoNHhPZERQOG9oTnZ4TnMzNDFO?=
 =?utf-8?B?S0xGWTh5V29RbmpuVFJpVGRNczkycWwzUlgvRSsybWRIeUhWN055TW5NRU1S?=
 =?utf-8?B?UFcxU0pJR2RDdEg5RmpMS012aXhRaDBFVkFKTXhjTnVwRHJjcXNuSHM1aEZQ?=
 =?utf-8?B?cUZUM1pnYUlJaXhhRnFtdFRTdGFKcnYvYnBsQ25UdkhnZGRxR2F2aXBXaHVZ?=
 =?utf-8?B?Vmd0QnJVeDRzUnZVei9SNDJWVUJVRHFpTS82MTQ0cXBMQVRyTjRYZ2dVRlRB?=
 =?utf-8?B?K3J4cFBJR05icUhrTUFjR2oxYUJad0VDcm1PYzgrRUFmL01zSHdDRUNvUUxC?=
 =?utf-8?B?VXJxQ2hsV1AxaytWamlKZUszNGdLUDAxdWt2ZGNlNG16cSs5K0VPSEJRZzI0?=
 =?utf-8?B?aTBTc0pnYzk3N0k0VFNWeXNMK3NZSEs1THFRb3l6RXFLdDVtRUhPalRQcUtB?=
 =?utf-8?B?K2w0UTFLTFZMaEkyTU5yNDhTZ0pHYVVSZU9rU3RjV2o0dTNLRkZPQXJOcllD?=
 =?utf-8?B?QTRGV1FCaDhLaCtSZEZXM2NKMGlndlZSOEpGTUFKQlhSMFBubGYwYU8yemRW?=
 =?utf-8?B?OHloYTdjaWtOdDArazE2WkszMklBc1dLSmEwRGI4SjVpUm9yUHJzS0U4cmRk?=
 =?utf-8?B?TGgvS2xjRUFzU241SGNuUjZwWXhDYXVvRVEydlZtWnpHN1drelh4SUpSSE9i?=
 =?utf-8?B?NzRteUJkTGEwQUVWYnB2aFpFSDRjeUdTamMzOXRSYktaODdhNXdnNENPRFV6?=
 =?utf-8?B?NW9GMnErMFdrZ3FzYTdhdjRMbGdtcXQvdDNiZE1WNkxLYVdUUFVlSk4yQ0ph?=
 =?utf-8?B?YTFOS0lsWWlBd2hyb1FlN2MvZHJvZWk5c1JlaW9ndjBEZzVKL1I3eVhZK0Z1?=
 =?utf-8?B?SlU0M1hNNkhHTE54T1NlNTJYR1hibWtlZUhKc0lOb051cFVDbEZBM1JrNENl?=
 =?utf-8?B?eU41dTcwSFpDVEtyTlp3cHpBR09PcHRrcVZKVzA1aWcyVXorcmlTaWJIN0V0?=
 =?utf-8?B?K1EwRVpDVmhCd0NSNHlITCtvWElJTXBoS2ZhZWo4SEVZWlRKOFpYSGRHNzhD?=
 =?utf-8?B?a0ZUaWpXbE9hdHl5RXRQRU9oK1llWE1DRFRBZzQ3U1psYW5xVHBpR2RtNVJ2?=
 =?utf-8?B?Y3NLRVFIaE82eTcwWWZMNGpJeEY4b1h3amNWdDNWYjNnVktKSVFwa0xDZlB2?=
 =?utf-8?B?R1hyV0FadFQ1bEJlNmF3c004emNwZlh6dG5obURYYWZGN1hMMEFzZlFhbTk4?=
 =?utf-8?B?SGF2YzNDRCtGZjJ3TzhEbWJPRTNhNzVOVWx3NVcyWDBnY3VYRTEvWEFoNVhu?=
 =?utf-8?B?a1E4MVJDZ2hYcGtZWGtZR0VJR1lqVlJ1TjVQajVpSm16RnJlaWMzMndFM2pX?=
 =?utf-8?B?eUhnU2ovWElNTG95RkJYTjlpZkRMMGlrNnRkMVRnWEgvR3hlMXVPVkE1Smov?=
 =?utf-8?B?Z2xvSzRualdlTlQxLzNvSDlZb1dNZmx1d2JZYTRGNnFHZVN1SWY0SFJ2V0Rn?=
 =?utf-8?B?YTdkUU1BcHZVMXZKVzhobG5JSHRGYjk4cHdEVy83dWN0c1BHMndkS1ZZeGJm?=
 =?utf-8?B?aG03bkdWRWxXTzRITFVGWWdBK2ltclZOaWVCdzdlVEZGSWRYcjlvTFo5M0tp?=
 =?utf-8?B?Q2hteHpyYUMzZjBjbUZldTlpQmJLNklBYmc4V1QxdUl3RHZBTFJUcmlCN1pU?=
 =?utf-8?B?QnRqUDI5dWl4OTNCZDdFaHdjdHltaUdwVzFLc1hSOUliU1FwVTU1ZGF1dGVt?=
 =?utf-8?B?c0VwUWhaZW1VU3FOZ09IM2FCb0dZdFNDejBQWlJZYzJrWHAxNnFGN0FVSEpD?=
 =?utf-8?B?UWY3VkM2SStYRncxT3NQeDhBdTZveCtFeU5KTG1lVWpmd09qVzVHc1B4VHEw?=
 =?utf-8?B?ODRIVHNNS0QyUERmeUNGVE01dS9HWHVrZWcyZk04V0gxS0Juc01BNExzZDBG?=
 =?utf-8?B?ZzdLNnFyT1NpSVdZOU1lclB4NE1mekh0OTU0UnkxOE56MDdiaWpLZGczTWI0?=
 =?utf-8?B?Q3ZEZWNnSDNFdWpBRnFJRmhqNGJBbHIwVXIvMGVXZVJJYi9YRERDNk94NWZj?=
 =?utf-8?Q?8qLNZuKtIwPPx1HS2StuwKIeg?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be0661b1-bccd-48c1-c7dc-08dd019b76b3
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6608.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2024 15:22:18.3191
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hyECtPuFqvHRt+SSIPLzIrmKtaDHe/vElSJLqKGLx2MiwC1c84krEqc1WeT3UM6kICZtUpV1XyLjfQf0P2z6PQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5728



On 11/10/2024 5:42 PM, Borislav Petkov wrote:
> On Sun, Nov 10, 2024 at 09:25:34AM +0530, Neeraj Upadhyay wrote:
>> Given that in step 3, hv uses "apic_id" (provided by guest) to find the
>> corresponding vCPU information, "apic_id" and "hv_apic_id" need to match.
>> Mismatch is not considered as a fatal event for guest (snp_abort() is not
>> triggered) and a warning is raise,
> 
> What is it considered then and why does the warning even exist?
> 

APIC ID mismatch can delay IPI handling, which can result in slow guest by
delaying activities like scheduling of tasks within guest.

> What can anyone do about it?
> 

The misconfiguration would require fixing the vCPUs' APIC ID in the host.


> If you don't kill the guest, what should the guest owner do if she sees that
> warning?
> 

If I get your point, unless a corrective action is possible without
hard reboot of the guest, doing a snp_abort() on detecting mismatch works better
here. That way, the issue can be caught early, and it does not disrupt the running
applications on a limping guest (which happens for the case where we only emit
a warning). So, thinking more, snp_abort() looks more apt here.


- Neeraj

