Return-Path: <kvm+bounces-63184-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FD05C5B96C
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 07:41:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 770424EE67F
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 06:38:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19E1D2EB5D5;
	Fri, 14 Nov 2025 06:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="gk7ccM/k"
X-Original-To: kvm@vger.kernel.org
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013009.outbound.protection.outlook.com [40.93.201.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5752E21C167;
	Fri, 14 Nov 2025 06:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763102312; cv=fail; b=SeZWcsP9rE4SpyZUq5twzj3+rwRTzlt0FCsatmPgTi4+tG3TlbMiy2wFyEpRsh9cTe1me0oHEi7SfbWAIsJXZy8mkcmCdEiHJLdI5QXw5hWoieGhWe4OGXjKw/jXVC9Yt265XfijNCXj4GNy7Erh9hUzgWIsNraFJ6q93YE6eL4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763102312; c=relaxed/simple;
	bh=+II7rtUt3eKa9XinuikNU3Rhn07EuRXHyQLwqLunW54=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Eav2LMHBrBbP23h7BAIiKuCZ/iA6tEtTEPfUOQaVAA4DIPH20zdQkZ+IXyKoSY3x2zdI5IONIcyLwck0nM3CsXrwpn4/Ks+0cLuInm12lVx170GNNz1ldP/3LMqr8eU2aqkDVCx9B0eJ4EeaNFhc+ZV/4dsI/QD8OVx08fJpV4I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=gk7ccM/k; arc=fail smtp.client-ip=40.93.201.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tT9TQzhTSiPR6uDYP6K7XFZQN/UllhZ9mtqiXxZmGeHWTpuL+gCEePZgrogQarzNwT6NQXcpOGqaP3ocmXFMqNDsx29NJyC5DOA06QqzlbLwDEyijljFpR2S54wPN19sKDOGtwjGwjDAICfWpOZhN4JdPdf3hpQBPzbeSJFvJD6pmMRlt17IoFbR7TADcC2a/HqibW03GjRpxxunrngrLwspGZW5kwaVLsdvfKw0bw9H4bFpLvd4N5p4T95F+6ezup3ClZg1s5E2EwzXzbolJ9AqJy7KbVUjD5vaFUlKsogqzUcKMbXGtLa1M2X/ct15ILm7PJe9EVd6KYmY60b/kQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g6pI83ALWR/Yw1lj5/6QceWflMHid+IkgJs0Ucz+EGA=;
 b=Wa5YGCTBlJIXaJMLn2qlZOhg+xBfg8ytvc1G7tPsX4y+fm6TJN4q5g00/92WV4joxV1ENn8jPK31WP9M/hRA3ZZPuYCUs0kdNO2IRbqY+Oi0Y9h7HTfiMZ9HudCZxo82N2n+/NtL+hr76q1QxYPtHiBf9IRh3EhFMqoKZGPex26Z3R7yy9IWTdI1ng1lM+Rksu8H8SZjmqIff/KQ40hKYrttvv2J1M0+ehIL2NKm5WpMTT52SGhlF081CGwNghUFj1AIcQs8sYntRFOL8kHart4aL41Gp673s5IickEdJIXU0UfjIMzl3srPlt7hzLml8br6wbbUEhnQu/7GidfCpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g6pI83ALWR/Yw1lj5/6QceWflMHid+IkgJs0Ucz+EGA=;
 b=gk7ccM/kCamdWxmlgloH8ME9kBX3B1kFBzL8QWs5xphFTBQtXBg0ukemv4feRkzYKfHuYQyxr2k04oKs6mU6YBJlYZ21FC34l6H8xuUpsjE7Wl4jqdLNPbokLyxqu+5YEfG13ugIzQSECF6NRK55rNmJNExzJow2zKJmNBkbMto=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5712.namprd12.prod.outlook.com (2603:10b6:510:1e3::13)
 by MN2PR12MB4240.namprd12.prod.outlook.com (2603:10b6:208:1d3::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.18; Fri, 14 Nov
 2025 06:38:26 +0000
Received: from PH7PR12MB5712.namprd12.prod.outlook.com
 ([fe80::2efc:dc9f:3ba8:3291]) by PH7PR12MB5712.namprd12.prod.outlook.com
 ([fe80::2efc:dc9f:3ba8:3291%6]) with mapi id 15.20.9298.007; Fri, 14 Nov 2025
 06:38:26 +0000
Message-ID: <3d0fc5bd-2d87-4691-a937-75c151fe0f6b@amd.com>
Date: Fri, 14 Nov 2025 12:08:18 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 4/7] KVM: x86/pmu: Add support for hardware
 virtualized PMUs
To: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>,
 Sandipan Das <sandipan.das@amd.com>, kvm@vger.kernel.org,
 linux-perf-users@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Kan Liang <kan.liang@linux.intel.com>, Mingwei Zhang <mizhang@google.com>,
 "Nikunj A . Dadhania" <nikunj@amd.com>, Manali Shukla
 <manali.shukla@amd.com>, Ravi Bangoria <ravi.bangoria@amd.com>,
 Ananth Narayan <ananth.narayan@amd.com>
References: <cover.1762960531.git.sandipan.das@amd.com>
 <b83d93a3e677fecdbdd2c159e85de4bca2165b79.1762960531.git.sandipan.das@amd.com>
 <9919b426-4ce6-4651-b1f2-367c4f79474d@linux.intel.com>
Content-Language: en-US
From: Sandipan Das <sandidas@amd.com>
In-Reply-To: <9919b426-4ce6-4651-b1f2-367c4f79474d@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MA5P287CA0090.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a01:1d4::14) To PH7PR12MB5712.namprd12.prod.outlook.com
 (2603:10b6:510:1e3::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5712:EE_|MN2PR12MB4240:EE_
X-MS-Office365-Filtering-Correlation-Id: 86275d51-f55d-4ae8-85f6-08de23486a6f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WXRxOEFjT2dBYU9aWFBYS2VwbTgyYmQ3alhsUEhEVGg0bmJIK2hNTlpkY2l5?=
 =?utf-8?B?TmxZL1JhM3BTb0tGblc1dVNoK1ZrcjBBL3R6Ums2ekZIUHNWTHJ4U2xwYlFR?=
 =?utf-8?B?M3VCUzBZbGYvdUJpWHBWbWNmNkNEV09mU2toaTRuRXB2VGI1bmFGN296bzd3?=
 =?utf-8?B?bFRNbC94ZDNBdHdTSHZCVkozVlc4Z3BnT2xCcWdnVnRQU2NJYVhRdzlYSGxV?=
 =?utf-8?B?SGpLUzJNaUlwREdoV0hyRWJLQTZJalNmMVpFeWtYRVFRL09nNTNIUC9BWFE5?=
 =?utf-8?B?T2JjaHNVYjkyY3lzSkNBdVFzSmFRVWhsSzF1OGE3bDNIRkVrN1JWTWV4NmF6?=
 =?utf-8?B?ZG1MeUJNWTF3ODRWR1F3V0xwM0ZadDBQYkt5cmZ4cFBuOHNMUWtvRmJiaG9z?=
 =?utf-8?B?aDJmT1JFdFFFOVlqRGNxVnhQSVIyUTlKb2FxR1NEeEV1d0tHSnhVbkFNYm1Q?=
 =?utf-8?B?b1lwZTltSDYrR1BDbFlTY3h2cXVOdklsbXNEL2ovcERxUUg2alBsVHVHanVO?=
 =?utf-8?B?a25ZcWhCV2dzYVJMZ0dnakVtMS9Fd2xSdWN5Z0hxSjh3ZUNkODlacnNMaWpC?=
 =?utf-8?B?V1h0L1NxeEl5N2t5VnlPOEh2UnJia3hUdjR1aHNMQmpESXZYMlk2N1NSRnFR?=
 =?utf-8?B?NGEwTzZycCt5RFNhMDNmb2YzZWV1R29CTTd6WExXY3lIWGlxVW5QSHRLd0VI?=
 =?utf-8?B?c3E2aW8zTUtDVGlTV0lCeFRqTlc3ODJnK3V2ZWN1SUJodXNFeHdvSFIvSkZu?=
 =?utf-8?B?WHhsSEVUd3FQM2J0TGlYdlllWmN1TXFtRHA1eUJLVi82M3FZeGpnMkh2cUN4?=
 =?utf-8?B?b3NZN2JoRWQxeEt4K3FyQ2lsTkdDOUxXRnV2SlZGdVE4NWd5MHhOc0wvVm9D?=
 =?utf-8?B?d2x3OExYYS9SREpZNitIcEd2T0M2V3hXcFhxMnYrbEI3TzgxOUN0cHFsSTFj?=
 =?utf-8?B?NDVTb1JiNHphM01TM2h4U0FnNStZcFB5OGl1TVRVbytoTWcrZE05cDhTcVA1?=
 =?utf-8?B?RE1ObzZVZXpoK1U1M0h4bE93ZXZIdHFYTGF5WUpBNWp6dFBTZWwxaFdjbUFR?=
 =?utf-8?B?NVZlVmNickFsKzV4MUxLOHpuTkhtSU9tQkJJVmEwRmE1ZjUzWGZoZEY1QkdR?=
 =?utf-8?B?M29wL3NXTFFjZzJ4YlluUmRBVSthVHR1NXZJeHNlaG9yOEhQMU9WU2llOU1r?=
 =?utf-8?B?b3k4bWJpeHlqeDhTWFFSOGFmclQ4RklXdVpmRFFLclBTZnhTZjZoNEM3c1pF?=
 =?utf-8?B?RExDc1hmaEJsUHdRbFJ6ZkJHNTVIY3ZSVTJGc0hYN3dPSGNzT05vNm5HU1Av?=
 =?utf-8?B?VmtpZXo1b3NMaGE2WktwUElyM1ozTEpFUGJhRHNkZWlIQTIyQ1g0YU1LYVRR?=
 =?utf-8?B?eWc4YXJVSmZNNGphbkFOQ2VVUWREZ0tGMFhPYjZRcGZ1b081RElEUERxMy9H?=
 =?utf-8?B?Qm9pQTRGMURzQWFmVGxrYmNYcEhRajdiSGYraEsvand4dHVoSktvMlozcHpV?=
 =?utf-8?B?bGUweWFQZnVXVCtPdWRDMVBvMHN3ZFpUSEl4b1hUV0xYeVhmRUhEOExyaFRT?=
 =?utf-8?B?UGpBNmZIZmxKRjZtY0pjNTBXYXdrbFlvbW9KOXhjMnVPSGNPNzlDaG1SU3JV?=
 =?utf-8?B?WVN2WHR3MVVQQnR6LzdnYlUvVXFHNWY4TlJ1VDRrSjBLUWZSSys5WDFVSVk3?=
 =?utf-8?B?QVJYbTc1bmU2OE9XazUrOHZmbmVpcWplYXV3eW0xS0xOSzdlQ1hqWk5ycXds?=
 =?utf-8?B?Yi84KzE4YjlGNCtZdjdIcTVWZGkvVEVHcWVEL1R5aThjWWNXZWxxaThWeDIv?=
 =?utf-8?B?Vllodm9FT3dhc1hMZjIxaDFDWFhZSFNHVzJDMDBXeUhjeG45S3k2Q0I5ZHI3?=
 =?utf-8?B?VUQyYW1Dclp2b0VNQWtDaHVKZ1ZMeFBvY1hPUHhXRjFHcENVb1RqdkRZTmVR?=
 =?utf-8?Q?v6rFpUoT7MVohFe6VSe1LfV3DPgok6KT?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5712.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ejJNNkFyTFdrYXZad2JoRVpiMzduZlRFbzhpeWhpdTViSy93R3JWRWZNR1hC?=
 =?utf-8?B?YlpZWGNGbjE1RlVUeTJxT0xHQkQvK2ZpWnJmK2tWTDIvbnNacVRLY09EOWNu?=
 =?utf-8?B?OVo5WFVCbWtLQXl3ZVJQYzlVZEU2Vks3UzN4eUw2VCtTR1FpNS9GeWJVSmdo?=
 =?utf-8?B?M3E1ckQzR0pmWVFnbmc1V3JiNDkrdzhJa3ZObWhrMWhyd3NFQ3hCR01iaVN5?=
 =?utf-8?B?WnU5SmdUbllZUWRHelJCMVNjeW1FcHJWeFFubWNxcDBHRVhONTJGLzhpdmZh?=
 =?utf-8?B?V2RSVGV2WlAzbnRBeHU1YnFkaHdRbjRpODJvODdjejNzQ2hnSVpMMENkZy96?=
 =?utf-8?B?T0l4b2xIenpxamZpTmVNVFpCRUlKbmZzcmtuUXFlUktEQWZtSEIrdWk1Yi9W?=
 =?utf-8?B?bzR0Y29BcTNuaGZHNU94SkcrMm5lUUlmeUUxbGRVd2doaTNxd2ViejhZblhT?=
 =?utf-8?B?YkU3QS85ZjhYdVg2WVhrbk5hOVJIUFo3cmZwU3JiT01tcEt5ZHJzdVAyMFhV?=
 =?utf-8?B?VVE0S2lUanRmRHpjbUpBWVpRR01INy9sajJCL3dmc00rNXRxcDU3TWxmOEUw?=
 =?utf-8?B?aEl6VHVseDNKNmQxRVEzSHFJd29zSnp6RFpVUVVQZ0tiRUZuMVd4dXVWb1Rr?=
 =?utf-8?B?cWRuOXRRYmZNcTBCRzdVSXhvdWtuNGlMVVpEUHB1U2QxQzhMTzZuSEUyUXhz?=
 =?utf-8?B?dkpSc1RUUjZIRVE5bkZBWTBQbmN6UzY0alFHckNVQTNUNUloVVNEU2hUUmZt?=
 =?utf-8?B?SDhwYjYvekpPaFpRL0FyVkxxYXVLYnhNUCs1c253RzQvaHlWeTZvV3V2U0p5?=
 =?utf-8?B?NzRqZUFvRE51aSsvUWxXRmtweDg4UTBLS29TZEgxalZISjBRVVlFVFNDZGNV?=
 =?utf-8?B?TTYzOFJVWTJ2LzJKMGpyRk5UT2trclYxdU5hOXBNdWxqNUxEOEVxVC9tc0NF?=
 =?utf-8?B?SFR6K0VaNkkzMlo5cndDVUc1VWUzZ0NzZVdnSkpmUlY5UElaT2lFMGg1Tk9k?=
 =?utf-8?B?NnV1dU1ycE5MVnIrMzZsSkMwWEcrQmRKTzhua3p1cmRjYi9lbXptL0xKdTNw?=
 =?utf-8?B?TFdzZkJmMlIzY2VGSnZHZ2FXbWVzR1FwUkV4Slo5bzlQSlk2bXN5TFJrcjBM?=
 =?utf-8?B?SFdWZUNySzB4dy92eUR0bWxDTFFOMy9zMzU4c0hBbTVtbHNvaVFqWklUd3lW?=
 =?utf-8?B?b0xkV0VFOGpCdUZOM2NXdEVqQ2tiY0U5NktYMTJteTFUbVRJRHNwT0hLYmFE?=
 =?utf-8?B?UmhZMUZZOGZheDZFTGxUVUhWMHNWTER1WXdKQVkwcFMwN3R5NHNjYmRZTEQz?=
 =?utf-8?B?SUg0bTM5RXJtdFRFY1pERzJEbHNVTkdYcS9iVkFmMGh3dVd6RnIydTliNkxS?=
 =?utf-8?B?ZGRXcTJ0Yk5jNHFTTndQVjBOVHA5WVloK0ZDZ1RQQWZwRlRjR2NEVnoyRldx?=
 =?utf-8?B?WDdqOXFHS1FBeWRyTnBJMzBDaHlRNnBFRWVkeGxlLzlOWGg5VnA0T1NVb3lR?=
 =?utf-8?B?Ni8wb01oMlF5ZGd1UFNUQXBjZUlJRDgrOWFrQUJrS3dUTFRCdXpqWnlGYS9Z?=
 =?utf-8?B?a0FLcTNIUFkyWkEwYVIycHhRQ0tranZtWTMwdzR3RDNmZnZzd0dYbnVVRFZE?=
 =?utf-8?B?RStHc3c0Sk9DYVM5MjFqNHZtOSs4bFBQaFBaR1NwUitHb3RjaUlrZWEwbWZy?=
 =?utf-8?B?WHh2OW5MK0o0R29hWWpRZVl3SDRHYi9OSFg5VzN4NEV6Uy9HalVEcjRyVFRq?=
 =?utf-8?B?ZkYvTzBtcW1IOWhMRElOSU1CajVCbW9wSmVWMVFDV3FjSmhyUG41RkZHcVEz?=
 =?utf-8?B?SmFZOWVTSGltRHB3a20yTkQvWGdzZWxTNzlZeW9sUEx5bVZOcmNXUkhhM3M5?=
 =?utf-8?B?dUo5Uy9rMlFBdzhxSFBET0hGOWFGRHRMZFMrRC94MVhLMHpzVm9zK0QrQ2V5?=
 =?utf-8?B?VFl0bTdNMFc3N01FTmhXaUpaTFFCQkszYnVGRWR5cjFwaEJLS3NxbDQ1bllR?=
 =?utf-8?B?UUFRSllxcUs3SFdmUnI0R0pIb0p2L0FrLzVqaWRTaTAzcUNXdlFRNGZ3bElV?=
 =?utf-8?B?d3BwNkVYUWZ5aDFRVFgzN29PRnhxVE4yaFA0MWloWkw5bTF6RitLQWtoaUJt?=
 =?utf-8?Q?KLAMZ/PJJrZ343m55LaqKDx2n?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86275d51-f55d-4ae8-85f6-08de23486a6f
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5712.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2025 06:38:26.7538
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gBEHeXUNqI9UzILeKkFeoBVgAHpFZWyZCJQBcmHsytk6B0Tc2omib5kg786xRuMuptJizeIdXQdDCQd48KpzIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4240

On 11/14/2025 11:58 AM, Mi, Dapeng wrote:
> 
> On 11/13/2025 2:18 PM, Sandipan Das wrote:
>> Extend the Mediated PMU framework to support hardware virtualized PMUs.
>> The key differences with Mediated PMU are listed below.
>>   * Hardware saves and restores the guest PMU state on world switches.
>>   * The guest PMU state is saved in vendor-specific structures (such as
>>     VMCB or VMCS) instead of struct kvm_pmu.
>>   * Hardware relies on interrupt virtualization (such as VNMI or AVIC)
>>     to notify guests about counter overflows instead of receiving
>>     interrupts in host context after switching the delivery mode in
>>     LVTPC and then injecting them back in to the guest (KVM_REQ_PMI).
>>
>> Parts of the original PMU load and put functionality are reused as the
>> active host events still need to be scheduled in and out in preparation
>> for world switches.
>>
>> Event filtering and instruction emulation require the ability to change
>> the guest PMU state in software. Since struct kvm_pmu no longer has the
>> correct state, make use of host-initiated MSR accesses for accessing
>> MSR states directly from vendor-specific structures.
>>
>> RDPMC is intercepted for legacy guests which do not have access to all
>> counters. Host-initiated MSR accesses are also used in such cases to
>> read the latest counter value from vendor-specific structures.
>>
>> Signed-off-by: Sandipan Das <sandipan.das@amd.com>
>> ---
>>  arch/x86/kvm/pmu.c           | 94 +++++++++++++++++++++++++++++-------
>>  arch/x86/kvm/pmu.h           |  6 +++
>>  arch/x86/kvm/svm/pmu.c       |  1 +
>>  arch/x86/kvm/vmx/pmu_intel.c |  1 +
>>  arch/x86/kvm/x86.c           |  4 ++
>>  arch/x86/kvm/x86.h           |  1 +
>>  6 files changed, 89 insertions(+), 18 deletions(-)
>>
>> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
>> index 0e5048ae86fa..1453fb3a60a2 100644
>> --- a/arch/x86/kvm/pmu.c
>> +++ b/arch/x86/kvm/pmu.c
>> @@ -168,6 +168,43 @@ void kvm_handle_guest_mediated_pmi(void)
>>  	kvm_make_request(KVM_REQ_PMI, vcpu);
>>  }
>>  
>> +static __always_inline u32 fixed_counter_msr(u32 idx)
>> +{
>> +	return kvm_pmu_ops.FIXED_COUNTER_BASE + idx * kvm_pmu_ops.MSR_STRIDE;
>> +}
>> +
>> +static __always_inline u32 gp_counter_msr(u32 idx)
>> +{
>> +	return kvm_pmu_ops.GP_COUNTER_BASE + idx * kvm_pmu_ops.MSR_STRIDE;
>> +}
>> +
>> +static __always_inline u32 gp_eventsel_msr(u32 idx)
>> +{
>> +	return kvm_pmu_ops.GP_EVENTSEL_BASE + idx * kvm_pmu_ops.MSR_STRIDE;
>> +}
>> +
>> +static void kvm_pmu_get_msr_state(struct kvm_vcpu *vcpu, u32 index, u64 *data)
>> +{
>> +	struct msr_data msr_info;
>> +
>> +	msr_info.index = index;
>> +	msr_info.host_initiated = true;
>> +
>> +	KVM_BUG_ON(kvm_pmu_call(get_msr)(vcpu, &msr_info), vcpu->kvm);
>> +	*data = msr_info.data;
>> +}
>> +
>> +static void kvm_pmu_set_msr_state(struct kvm_vcpu *vcpu, u32 index, u64 data)
>> +{
>> +	struct msr_data msr_info;
>> +
>> +	msr_info.data = data;
>> +	msr_info.index = index;
>> +	msr_info.host_initiated = true;
>> +
>> +	KVM_BUG_ON(kvm_pmu_call(set_msr)(vcpu, &msr_info), vcpu->kvm);
>> +}
> 
> With these 2 new helpers, suppose the helpers
> write_global_ctrl()/read_global_ctrl() could be retired. 
> 

Agreed. It will be good to have a new set of PMU ops other than {get,set}_msr()
that can be used to read/write any of the PMU-related MSRs.

> 
>> +
>>  static inline void __kvm_perf_overflow(struct kvm_pmc *pmc, bool in_pmi)
>>  {
>>  	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
>> @@ -520,19 +557,22 @@ static bool pmc_is_event_allowed(struct kvm_pmc *pmc)
>>  
>>  static void kvm_mediated_pmu_refresh_event_filter(struct kvm_pmc *pmc)
>>  {
>> -	bool allowed = pmc_is_event_allowed(pmc);
>>  	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
>> +	struct kvm_vcpu *vcpu = pmc->vcpu;
>>  
>>  	if (pmc_is_gp(pmc)) {
>>  		pmc->eventsel_hw &= ~ARCH_PERFMON_EVENTSEL_ENABLE;
>> -		if (allowed)
>> +		if (pmc_is_event_allowed(pmc))
>>  			pmc->eventsel_hw |= pmc->eventsel &
>>  					    ARCH_PERFMON_EVENTSEL_ENABLE;
>> +
>> +		if (kvm_vcpu_has_virtualized_pmu(vcpu))
>> +			kvm_pmu_set_msr_state(vcpu, gp_eventsel_msr(pmc->idx), pmc->eventsel_hw);
>>  	} else {
>>  		u64 mask = intel_fixed_bits_by_idx(pmc->idx - KVM_FIXED_PMC_BASE_IDX, 0xf);
>>  
>>  		pmu->fixed_ctr_ctrl_hw &= ~mask;
>> -		if (allowed)
>> +		if (pmc_is_event_allowed(pmc))
>>  			pmu->fixed_ctr_ctrl_hw |= pmu->fixed_ctr_ctrl & mask;
>>  	}
>>  }
>> @@ -740,6 +780,9 @@ int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned idx, u64 *data)
>>  	    kvm_is_cr0_bit_set(vcpu, X86_CR0_PE))
>>  		return 1;
>>  
>> +	if (kvm_vcpu_has_virtualized_pmu(pmc->vcpu))
>> +		kvm_pmu_get_msr_state(pmc->vcpu, gp_counter_msr(pmc->idx), &pmc->counter);
>> +
>>  	*data = pmc_read_counter(pmc) & mask;
>>  	return 0;
>>  }
>> @@ -974,6 +1017,9 @@ void kvm_pmu_refresh(struct kvm_vcpu *vcpu)
>>  	    (kvm_pmu_has_perf_global_ctrl(pmu) || kvm_vcpu_has_mediated_pmu(vcpu)))
>>  		pmu->global_ctrl = GENMASK_ULL(pmu->nr_arch_gp_counters - 1, 0);
>>  
>> +	if (kvm_vcpu_has_virtualized_pmu(vcpu))
>> +		kvm_pmu_set_msr_state(vcpu, kvm_pmu_ops.PERF_GLOBAL_CTRL, pmu->global_ctrl);
>> +
>>  	if (kvm_vcpu_has_mediated_pmu(vcpu))
>>  		kvm_pmu_call(write_global_ctrl)(pmu->global_ctrl);
>>  
>> @@ -1099,6 +1145,11 @@ static void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu,
>>  	if (bitmap_empty(event_pmcs, X86_PMC_IDX_MAX))
>>  		return;
>>  
>> +	if (kvm_vcpu_has_virtualized_pmu(vcpu)) {
>> +		kvm_pmu_get_msr_state(vcpu, kvm_pmu_ops.PERF_GLOBAL_CTRL, &pmu->global_ctrl);
>> +		kvm_pmu_get_msr_state(vcpu, kvm_pmu_ops.PERF_GLOBAL_STATUS, &pmu->global_status);
>> +	}
>> +
>>  	if (!kvm_pmu_has_perf_global_ctrl(pmu))
>>  		bitmap_copy(bitmap, event_pmcs, X86_PMC_IDX_MAX);
>>  	else if (!bitmap_and(bitmap, event_pmcs,
>> @@ -1107,11 +1158,21 @@ static void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu,
>>  
>>  	idx = srcu_read_lock(&vcpu->kvm->srcu);
>>  	kvm_for_each_pmc(pmu, pmc, i, bitmap) {
>> +		if (kvm_vcpu_has_virtualized_pmu(vcpu))
>> +			kvm_pmu_get_msr_state(vcpu, gp_counter_msr(pmc->idx), &pmc->counter);
>> +
>>  		if (!pmc_is_event_allowed(pmc) || !cpl_is_matched(pmc))
>>  			continue;
>>  
>>  		kvm_pmu_incr_counter(pmc);
>> +
>> +		if (kvm_vcpu_has_virtualized_pmu(vcpu))
>> +			kvm_pmu_set_msr_state(vcpu, gp_counter_msr(pmc->idx), pmc->counter);
>>  	}
>> +
>> +	if (kvm_vcpu_has_virtualized_pmu(vcpu))
>> +		kvm_pmu_set_msr_state(vcpu, kvm_pmu_ops.PERF_GLOBAL_STATUS, pmu->global_status);
>> +
>>  	srcu_read_unlock(&vcpu->kvm->srcu, idx);
>>  }
>>  
>> @@ -1270,21 +1331,6 @@ int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp)
>>  	return r;
>>  }
>>  
>> -static __always_inline u32 fixed_counter_msr(u32 idx)
>> -{
>> -	return kvm_pmu_ops.FIXED_COUNTER_BASE + idx * kvm_pmu_ops.MSR_STRIDE;
>> -}
>> -
>> -static __always_inline u32 gp_counter_msr(u32 idx)
>> -{
>> -	return kvm_pmu_ops.GP_COUNTER_BASE + idx * kvm_pmu_ops.MSR_STRIDE;
>> -}
>> -
>> -static __always_inline u32 gp_eventsel_msr(u32 idx)
>> -{
>> -	return kvm_pmu_ops.GP_EVENTSEL_BASE + idx * kvm_pmu_ops.MSR_STRIDE;
>> -}
>> -
>>  static void kvm_pmu_load_guest_pmcs(struct kvm_vcpu *vcpu)
>>  {
>>  	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
>> @@ -1319,6 +1365,12 @@ void kvm_mediated_pmu_load(struct kvm_vcpu *vcpu)
>>  
>>  	lockdep_assert_irqs_disabled();
>>  
>> +	/* Guest PMU state is restored by hardware at VM-Entry */
>> +	if (kvm_vcpu_has_virtualized_pmu(vcpu)) {
>> +		perf_load_guest_context(0);
>> +		return;
>> +	}
>> +
>>  	perf_load_guest_context(kvm_lapic_get_reg(vcpu->arch.apic, APIC_LVTPC));
>>  
>>  	/*
>> @@ -1372,6 +1424,12 @@ void kvm_mediated_pmu_put(struct kvm_vcpu *vcpu)
>>  
>>  	lockdep_assert_irqs_disabled();
>>  
>> +	/* Guest PMU state is saved by hardware at VM-Exit */
>> +	if (kvm_vcpu_has_virtualized_pmu(vcpu)) {
>> +		perf_put_guest_context();
>> +		return;
>> +	}
>> +
>>  	/*
>>  	 * Defer handling of PERF_GLOBAL_CTRL to vendor code.  On Intel, it's
>>  	 * atomically cleared on VM-Exit, i.e. doesn't need to be clear here.
>> diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
>> index a0cd42cbea9d..55f0679b522d 100644
>> --- a/arch/x86/kvm/pmu.h
>> +++ b/arch/x86/kvm/pmu.h
>> @@ -47,6 +47,7 @@ struct kvm_pmu_ops {
>>  	const int MIN_NR_GP_COUNTERS;
>>  
>>  	const u32 PERF_GLOBAL_CTRL;
>> +	const u32 PERF_GLOBAL_STATUS;
>>  	const u32 GP_EVENTSEL_BASE;
>>  	const u32 GP_COUNTER_BASE;
>>  	const u32 FIXED_COUNTER_BASE;
>> @@ -76,6 +77,11 @@ static inline bool kvm_vcpu_has_mediated_pmu(struct kvm_vcpu *vcpu)
>>  	return enable_mediated_pmu && vcpu_to_pmu(vcpu)->version;
>>  }
>>  
>> +static inline bool kvm_vcpu_has_virtualized_pmu(struct kvm_vcpu *vcpu)
>> +{
>> +	return enable_virtualized_pmu && vcpu_to_pmu(vcpu)->version;
>> +}
>> +
>>  /*
>>   * KVM tracks all counters in 64-bit bitmaps, with general purpose counters
>>   * mapped to bits 31:0 and fixed counters mapped to 63:32, e.g. fixed counter 0
>> diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
>> index c03720b30785..8a32e1a9c07d 100644
>> --- a/arch/x86/kvm/svm/pmu.c
>> +++ b/arch/x86/kvm/svm/pmu.c
>> @@ -278,6 +278,7 @@ struct kvm_pmu_ops amd_pmu_ops __initdata = {
>>  	.MIN_NR_GP_COUNTERS = AMD64_NUM_COUNTERS,
>>  
>>  	.PERF_GLOBAL_CTRL = MSR_AMD64_PERF_CNTR_GLOBAL_CTL,
>> +	.PERF_GLOBAL_STATUS = MSR_AMD64_PERF_CNTR_GLOBAL_STATUS,
>>  	.GP_EVENTSEL_BASE = MSR_F15H_PERF_CTL0,
>>  	.GP_COUNTER_BASE = MSR_F15H_PERF_CTR0,
>>  	.FIXED_COUNTER_BASE = 0,
>> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
>> index 41a845de789e..9685af27c15c 100644
>> --- a/arch/x86/kvm/vmx/pmu_intel.c
>> +++ b/arch/x86/kvm/vmx/pmu_intel.c
>> @@ -845,6 +845,7 @@ struct kvm_pmu_ops intel_pmu_ops __initdata = {
>>  	.MIN_NR_GP_COUNTERS = 1,
>>  
>>  	.PERF_GLOBAL_CTRL = MSR_CORE_PERF_GLOBAL_CTRL,
>> +	.PERF_GLOBAL_STATUS = MSR_CORE_PERF_GLOBAL_STATUS,
>>  	.GP_EVENTSEL_BASE = MSR_P6_EVNTSEL0,
>>  	.GP_COUNTER_BASE = MSR_IA32_PMC0,
>>  	.FIXED_COUNTER_BASE = MSR_CORE_PERF_FIXED_CTR0,
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 6bdf7ef0b535..750535a53a30 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -191,6 +191,10 @@ module_param(enable_pmu, bool, 0444);
>>  bool __read_mostly enable_mediated_pmu;
>>  EXPORT_SYMBOL_GPL(enable_mediated_pmu);
>>  
>> +/* Enable/disable hardware PMU virtualization. */
>> +bool __read_mostly enable_virtualized_pmu;
>> +EXPORT_SYMBOL_GPL(enable_virtualized_pmu);
>> +
>>  bool __read_mostly eager_page_split = true;
>>  module_param(eager_page_split, bool, 0644);
>>  
>> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
>> index bd1149768acc..8cca48d1eed7 100644
>> --- a/arch/x86/kvm/x86.h
>> +++ b/arch/x86/kvm/x86.h
>> @@ -446,6 +446,7 @@ extern struct kvm_host_values kvm_host;
>>  
>>  extern bool enable_pmu;
>>  extern bool enable_mediated_pmu;
>> +extern bool enable_virtualized_pmu;
>>  
>>  /*
>>   * Get a filtered version of KVM's supported XCR0 that strips out dynamic


