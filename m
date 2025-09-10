Return-Path: <kvm+bounces-57248-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E2C32B52169
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 21:49:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0229E1C862A7
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 19:50:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A2B42D97AF;
	Wed, 10 Sep 2025 19:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ALv3OXrX"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2074.outbound.protection.outlook.com [40.107.244.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8F192192F5;
	Wed, 10 Sep 2025 19:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757533773; cv=fail; b=o2uvUoT90RBqyw4GBM2ByecaJK+ZSHjkAX+78A8V5a/YBUUfptJYzw9daDHcjee/wol1JcFIxZdKWdotxNsQRjaNjG2Y8tp1bX0i/krTVh0M5s/F8lXKDrX/ZtbBfTREakSu2KR69EMZPvtCNqPqBXQMmNxAJmEMpZ7/CRf2YaM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757533773; c=relaxed/simple;
	bh=MH87dHM4nphZCGqFKWAFWB/eauUNF0tmS4BgOGo0i5Q=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=i5CoAMi1cH/BdyyvhHmsEeG2SFIVqB4cYwugtcNimjqhdVEKH4NaTKLXQ2lLQjS7DT5c4oKRmjJYl/Vd+1TcBoNYM58gXGy8ipyv4P+UEq7dOWzx3AdbsbIf+xZdjJISSNpnq+eds4JR2ZWZ4xlsmIbz1yu9jTdbVGwVb3eHUDk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ALv3OXrX; arc=fail smtp.client-ip=40.107.244.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Aar5tR8l1UMVB5mNWK158jS5pmWP2fqB5FFxSMz7E26WMTOAqdrnYVqUmaqIDWH181HwXDsONNge4CShaXhWifNG9AHCYGqsfuoi/zWyCD3bs6S42+xFJ3D8t2TGCywQqsE8pdFIiZ9QMEr4QWXOUUH/rVTMQ4MzEw4egcwaOvTSGu0jUxexZNr4fHjuvtTrk/+3TL7UvPFHECbm3TY+lNeYBDzSJmKdY/vhvvlGW0cj/HgVYMwwlgwrgppz6k7J+07cPHxSvTtW47/zWGbtao6vW1GK7WxNUMuT573EkF4fC44tznKBFA1rKjboLOkKQade2ymM7IV3j1SYtarqwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O5ejXGZFQU2EVwC7yu5yAIHJN/c1EWuwmGzxhqExA4U=;
 b=O9QWXl1+tuZ8cEQf4DWQZ9UkLU/vQQ6/tv0TG9Yci+0dBBCKUC5Rnm2gS96CDjYn+InI5vtRpydT2qLmO/CtxkZPrQFd7uzRs3cxo+FDy0GlVTkvCCKPVzUHXDe9pnxw67IeY9Ja85VJ2BKmSuIrnmCqsQmauFIYIKPObMn0lsoancV6sNGM5X9Q78p8aQQpzjtPsfBjLRzyCe2cdbwas2WZBABkdCIXXlxEYAtAJLNq8RAPGRUBTgC/bK2Hp3raE89CxgfNoqfoZqVYOjWXoKQFmpZ9930P3OUEpCas/DOSk7dUzqK3pZZDCxUi/7pSwB1XQQBh24cusuxnRY5AxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O5ejXGZFQU2EVwC7yu5yAIHJN/c1EWuwmGzxhqExA4U=;
 b=ALv3OXrXmFSncTF3H/8Cmia7vIY1FPRgL86PGt6Cf1FNO27A08bAeFLzcC8JyMeuaITCy0zFL/j+kw7Et99z5m/FotymeDdE9wJPicm9v0n68SYNAEkMDSIObrbgXug/45FSLuVBZSVWH5cD+xQt+zNJrxxeYU7D1OCUTmbvsLk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc) by CYYPR12MB9013.namprd12.prod.outlook.com
 (2603:10b6:930:c2::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Wed, 10 Sep
 2025 19:49:28 +0000
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::bed0:97a3:545d:af16]) by IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::bed0:97a3:545d:af16%7]) with mapi id 15.20.9094.021; Wed, 10 Sep 2025
 19:49:28 +0000
Message-ID: <1096bc24-2bac-4bc2-bc4f-9d653839e81d@amd.com>
Date: Wed, 10 Sep 2025 14:49:23 -0500
User-Agent: Mozilla Thunderbird
Reply-To: babu.moger@amd.com
Subject: Re: [PATCH v18 14/33] x86/resctrl: Add data structures and
 definitions for ABMC assignment
To: Borislav Petkov <bp@alien8.de>
Cc: corbet@lwn.net, tony.luck@intel.com, reinette.chatre@intel.com,
 Dave.Martin@arm.com, james.morse@arm.com, tglx@linutronix.de,
 mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org,
 hpa@zytor.com, kas@kernel.org, rick.p.edgecombe@intel.com,
 akpm@linux-foundation.org, paulmck@kernel.org, frederic@kernel.org,
 pmladek@suse.com, rostedt@goodmis.org, kees@kernel.org, arnd@arndb.de,
 fvdl@google.com, seanjc@google.com, thomas.lendacky@amd.com,
 pawan.kumar.gupta@linux.intel.com, perry.yuan@amd.com,
 manali.shukla@amd.com, sohil.mehta@intel.com, xin@zytor.com,
 Neeraj.Upadhyay@amd.com, peterz@infradead.org, tiala@microsoft.com,
 mario.limonciello@amd.com, dapeng1.mi@linux.intel.com, michael.roth@amd.com,
 chang.seok.bae@intel.com, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev,
 kvm@vger.kernel.org, peternewman@google.com, eranian@google.com,
 gautham.shenoy@amd.com
References: <cover.1757108044.git.babu.moger@amd.com>
 <1eb6f7ba74f37757ebf3a45cfe84081b8e6cd89a.1757108044.git.babu.moger@amd.com>
 <20250910172627.GCaMG0w6UP4ksqZZ50@fat_crate.local>
Content-Language: en-US
From: "Moger, Babu" <babu.moger@amd.com>
In-Reply-To: <20250910172627.GCaMG0w6UP4ksqZZ50@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA9P223CA0016.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:806:26::21) To IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PPF9A76BB3A6:EE_|CYYPR12MB9013:EE_
X-MS-Office365-Filtering-Correlation-Id: c407cc2c-0e7f-4acf-8496-08ddf0a326d8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eWhQaDNONkxrNCtTNHpGb3lsSVNaTkdzWGdXbVVRNm81ckNwTzNPME1ORFdB?=
 =?utf-8?B?US9VVDRVL3NQcFJWenFTVWk0bDN6Y2orTzJpc1ZjSS95dHJJeTFiT3EvODQ5?=
 =?utf-8?B?NGVtMU9wUnlFYnNrUkVaeXlucy9oMEVSMEVoZjVmMGFrdjJDQnpJc01xbUhr?=
 =?utf-8?B?NXdCTm1Jc2ZtTHE5ejNDT29ieDZYMG5aamt3YTUrcyt6Y2xZTFNUMjdtUW1j?=
 =?utf-8?B?WFZlcFAwWS91ZVpaZG9EMmhaVUhSRHZKeE5sZ25Kc2ExL3lZSU5DenBCZU1V?=
 =?utf-8?B?OFJnQm0zSi9ldU1KSmRoY1lhMEcyeC9pZzdpY1NENzdmTjNDVTNjZkQrUWlG?=
 =?utf-8?B?aXBwNi8rYm1BZDNlaE11L3RxVlFBa1A4V1JtY2hxUmgra3o5c0J4cTQyN3BH?=
 =?utf-8?B?Q21kTVlKcEtFUG1ScFFvZFVMRDViQU0zZnhnOTk0MnVxWGlYNWYyRWNaT0RG?=
 =?utf-8?B?TjVqYmhhS1V3akk1UWN3Mkl0MjFhQWxZSGU4blhUTEJFOTBrWkFjQWc4QWpi?=
 =?utf-8?B?LzYwa0t4ZUFDUHE4MGkwUlJvTTVjWGJ4aHVjM0x4Wms2WDFKRU1xc1dRRHlY?=
 =?utf-8?B?L3F4YVpEOFJLaEkxVjZxMjRPNDNQbm53aUhDdDh2eTJiVWpRK3lXR2JXc21Q?=
 =?utf-8?B?cG5HdWlSeW1HVUxaWlJKWlA5RHdpTFBRUWtqUGRaWTJiWGk1cXdob1AweTBX?=
 =?utf-8?B?LzhnVDY3Q0tmWS9mZnBsSUJWMlhyNHZVc3YzVG1ieFNxR1hmdFZvb1o4NDc5?=
 =?utf-8?B?OVdKV0NtYjA2KzIyeUVzbExxdHM2UElEWmk2VmQzcEFjeVFzOEpMT0h0NGJU?=
 =?utf-8?B?dENHVndudnVVQUo4dmtwZmtUZloyVDc3M1JFOS9qWEhjTU42K1MxR0xQR0h1?=
 =?utf-8?B?MDAwWGgyZ2R5RkF5VjBMNHJYeGNnQy9RUGdYU2pzOVM1bkZnV0Rwc3RFQWJV?=
 =?utf-8?B?ZjNBeTJzQlZDem9QQi8vK2JPZXZRekxOU1J5cW5aVDhtdWtlZ1Y0YTM2NGVI?=
 =?utf-8?B?WDkxQmFwbFJNY01MSGtNM0xIbDNvUSs1bUdmV3VDa3dhVDVUM3J5MXl1eUFm?=
 =?utf-8?B?aVE4bUpoWjNYWk1IVnQ1ZGpRNXlFV0UvNVZDVCtreEtNTmV5aGtKQ1I0c0t5?=
 =?utf-8?B?VTJrbmFHTU9ZZVk5VlVtVjBraVRnc3JXQWUxb0M4ZTh2ZG1hYzltejNKaVM2?=
 =?utf-8?B?dUw3OUlSVHB3ZHlrL0EycU9idUZTVEtPNGw5VSs4UXI1dDRaaXdQYkxnRDlm?=
 =?utf-8?B?VnMrL25iaG55anVSYTE3UmVuWW1tM2ROdlFYSjdFblBja3BKWUdCQzBtZi9p?=
 =?utf-8?B?a2daYk4rUVpmd0c1ek1FVUl4YytCRWVUd2RXd1h0UHlwNWUxb2h3SHQ3cU94?=
 =?utf-8?B?ZFVwb1c0UVlzNFlWSGxHdVlNT1VjM2oyVnBoU1c4Qy9QMXU1ZjhIaXNjOGN0?=
 =?utf-8?B?VzhtTXFrVVVuN3VZYnZmM01XSzV0T3N4VGhZOEV1UmpNVGtPYXZRelM2NkVy?=
 =?utf-8?B?c2NkNHpnZk1hbFJzZjRkQWc1SkxCc2JEZGFGWGlwbkR5elZFczN0bWR1MldQ?=
 =?utf-8?B?NFBXeTVrU3JlZlNOY3JtQUU3bkdhNjNnbXFyM2tkRzNINjZTRm1MTWk0T2RC?=
 =?utf-8?B?ZzRQWUxiSTh2czVjbFJjNHhnREZzU1NOem92RE5Ia3JoZnFrR1dwL0Zpc1ZR?=
 =?utf-8?B?ZGwzVGh3YXFvUmpiYnZlZXJyaUNxSGZhRklybW1ZanJzdjBWc2JadGhBSncr?=
 =?utf-8?B?YnNndWw3elRFaXNzOTFGN1dONEpMVHFkcWl1TlZQU05oMnFCUmJNU21ZNVM3?=
 =?utf-8?B?TDU3WEd1K3QzQ2ZCUFBsNUdCeHlWZ0xYcWZxMXlNVk5NMzdGWTZWMU1kWThN?=
 =?utf-8?B?TE5rT05xVFg5VDhDNjdvWGJkZHZPWGxhTjRUbUYzUkVobFV0R0hqYk5hSXI1?=
 =?utf-8?Q?bG1Nqb+411I=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PPF9A76BB3A6.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UlNIaXpKNVpLWDRWanlUS3A4TVd0ZlF6M3g1b1V6N1NqdUgzZzdnaHpKemlO?=
 =?utf-8?B?aGVHT0lYYnZ5ZC9aMmdFcVhUN3FNL1laa0VSTE9UQ0xhTzYvenlOSnUrdmM3?=
 =?utf-8?B?eG1PcUZYM1JsdXpmdEdQazhxNlMwaDN6RXVFQnRhcnZodFNsYWU4czlVWGhy?=
 =?utf-8?B?NThGS0U3U3c4R01FR3l4cVpoUmpBUXdvTmZTQzIzMElPbGtJUFBvbnJSdVg4?=
 =?utf-8?B?dUdzeDFRc3owUE1XOTk5SzdQV3l5UjBPcGwyanVTSy81RVd0RG4xM3hKbTY2?=
 =?utf-8?B?Q25aQkJFZ0xkNkhvSE45YjdCZ2Z4Y3JYQTh4a1M3SmQ1eDM1YUxRQXRuQU5v?=
 =?utf-8?B?cjB1Y2NPMFdGT0lPRno1MEhDdnYxQi9jVU4vd3p2cGMvMGkxdkxZQ3lMTFIz?=
 =?utf-8?B?Vk04OUJPcWlCZ2pXR3dCbDRtOFlhWG1kQTFZMG00LzhxRXI1d1F4VVVLRjYv?=
 =?utf-8?B?VHdhZURMOEh0ZnRVWWNjaVJTSEQyRVlHbTh0T2lZVWFUQnJJTC9oZjlhTWRB?=
 =?utf-8?B?dmc3U3Uzb0MyNVk4Vkc1dXgreDFtNnUvUjI0NSsxYzFsUitnMlgvdU1Ja0xk?=
 =?utf-8?B?Ym5FU3Zyam9lOFV4S3VlNTMrL3pyM3NaYlI3WjdPK2ZSTVR0QkgwL09XNHgv?=
 =?utf-8?B?c05kUEhvL1J4MG0ra1JtLzVpK3FsNWNGVk4zSFo3cTNDMTBDd3paNStzR21k?=
 =?utf-8?B?RnJvRkZWWDVrK2E3MDBTazNQOGkvalhjZG9GeVpmWXlEaHhCc2tZZ1NCVWNm?=
 =?utf-8?B?elFUb0htMlVVL3J2VCswa2g2b2p1NWxObGZYY1FpVUorbDd5Uzlxc3FwcVhz?=
 =?utf-8?B?OUVUM1I5MGp1NjdiemdjcTY1eWFRZC9VcTFjRUxlY3hCQi9MZFJVZmxuUmRH?=
 =?utf-8?B?L2pRNSt0L0xiYnNyNXBwLzBKdTQwdW9pak1JNUNrRzcvRFVoSnlTKzliNGpj?=
 =?utf-8?B?MFRqcC9UVVY1dnVpYy9xNFBvN1RzcDBkSHY3UU5iZDl6V1lGaVlBc0RSOFlJ?=
 =?utf-8?B?dFkyekRZVjJSSW5qZlRJREs2ZGgwTCttN0cwcHBGeHJmakJjNVUxTWVNMzdY?=
 =?utf-8?B?T1kyKy9QOWhNYUtTcnFHamxPZit2QmlXcDdMTlNNTFB3SmJ6WVF6UUt4NTh4?=
 =?utf-8?B?TlhCdWZOdjJrMDE4blhhaTBySEc4Mnc0TVJmZThxL2dJdTU5TjZnbGxYMTdQ?=
 =?utf-8?B?bXQ0WFZzNFV1UHZ1MHVtZzVyVkhxRkkyV25uUUt0NDcyY2Y4N2xWdVRMR0E3?=
 =?utf-8?B?dGZNb3k3U0Y1SW9SU0k1SGk5M1RITkFGRnpVcC9nb2l1dzVKeWllU1QxTmpC?=
 =?utf-8?B?Rjk0bEtabXRiSlBDU1QyRWxQd3IvOEJOOGhOWUl6RTByOGU4Y1VKdVQzbFhh?=
 =?utf-8?B?ampMbVhjYjZIOVdmc2F5VEdMaVFRTnJJL3JrV1JQSWYyK0o0UkRLYnNDbkFs?=
 =?utf-8?B?ZXYxeXUyVTJKZE5HU3lhcDdablJtQkhzaE5VYmtzMGFXbTh5OVdzSTV2VHNF?=
 =?utf-8?B?TnhCcEpqRTNjRXRvWDg2TEk4YXc3YWhNRFZ3T1hzZnF4QmNiYnJOSlhnU2t1?=
 =?utf-8?B?ZGhmYitmZklJd3h0ckN1akNhSWxCV1VYUnlod1NMRCszbVlUYVVucGJJN0NI?=
 =?utf-8?B?QjVZeFVJc1IvOWR0MDZiektsM1FKamZ3R21jRjcySkRBVjU5Y2Y0L2FWL1lz?=
 =?utf-8?B?Q0NiemFmT0VVTmhBZ1RQTnNyblJqbDR6Tm1ESDJkRDlNS1BJcHFCaUVRQVlt?=
 =?utf-8?B?SlFqWHFDcjZJNVJEeFRoUCt1cW5ReTB6S3ZJcHMvanNxZ2ZIRmcyL0dxOUZn?=
 =?utf-8?B?MlhPaHduZkxpRHBpWG9jRnZXMGZDTjZFLzAxeElkaGJHb1ltUjZvRDQra2c5?=
 =?utf-8?B?ekNubU9qbVdIc3Z5dEJjeS9uaGY3WGw5Qk11T1l4cDRreUczQnhoYnJaY3hj?=
 =?utf-8?B?Skg4c2FQTmVMeDRSQjIzdzZGWGg3cXExM2Z4U0xIL1RKOFl5OG1CWjk0UVZp?=
 =?utf-8?B?azB0dmZxS1Uwc1ltSlJBUndVWHNmV2pZN1BrQW9yaURlQXdTWjkyY2RIM1Qz?=
 =?utf-8?B?b2R4ZS9Nd1ovRGVMdE9zU0VBeFVJZnFCWTBnMTJjV05UbXVwUDJzWlFhakM1?=
 =?utf-8?Q?/Aik=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c407cc2c-0e7f-4acf-8496-08ddf0a326d8
X-MS-Exchange-CrossTenant-AuthSource: IA0PPF9A76BB3A6.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2025 19:49:28.0537
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kZPrUkVy3ZOnugxWyAePbygokVf+3IbSaNiK091bArS2k7L1zqqPJe8HX2rd01OT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB9013

Hi Boris,

On 9/10/25 12:26, Borislav Petkov wrote:
> On Fri, Sep 05, 2025 at 04:34:13PM -0500, Babu Moger wrote:
>> diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
>> index 18222527b0ee..48230814098d 100644
>> --- a/arch/x86/include/asm/msr-index.h
>> +++ b/arch/x86/include/asm/msr-index.h
>> @@ -1232,6 +1232,7 @@
>>  /* - AMD: */
>>  #define MSR_IA32_MBA_BW_BASE		0xc0000200
>>  #define MSR_IA32_SMBA_BW_BASE		0xc0000280
>> +#define MSR_IA32_L3_QOS_ABMC_CFG	0xc00003fd
>>  #define MSR_IA32_L3_QOS_EXT_CFG		0xc00003ff
>>  #define MSR_IA32_EVT_CFG_BASE		0xc0000400
> 
> Some of those MSRs are AMD-specific: why do they have "IA32" in the name and
> not "AMD64"?
> 

No particular reason — it was just carried over from older MSRs by copy-paste.

In fact, all five of them are AMD-specific in this case. Let me know the
best way to handle this.

-- 
Thanks
Babu Moger


