Return-Path: <kvm+bounces-27385-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C39C984A07
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2024 18:56:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1472F28410D
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2024 16:56:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EAFA1AC423;
	Tue, 24 Sep 2024 16:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="KAwtSzrY"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2057.outbound.protection.outlook.com [40.107.220.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E58971AB6E2;
	Tue, 24 Sep 2024 16:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727196972; cv=fail; b=A7oBzKSBobORjp15Jq3wRJontfjr7kckjjyWLM27XCMRTyZfEz9w8GZButrFF+Hbek+XBJzItn87aj3fhVASndExUNXP9x8aggy6sWWNirM4FBmwQcpAl9n1cw/zbK2ywwZp7j+UfLeCZjp97z+Q0OgGJj9xJfibY41RkhNB0V8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727196972; c=relaxed/simple;
	bh=p9nN6apFh1xWIlgXwLqa7mhEKl+QLsOi5WQQ6AdCo8Y=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Lvew/WXsbbXLgmSNJy+4gCu0/AL0gAU2AEWXD3t3ZVfgGQ9Y6uTPqoZbd3TXw6xWVV+3qwqgA1G0fBgBRCBZjv3VDufjg1a4/negzoK4kn7HMLXPOyj2tQXEcNPcRggPvIsisFy3IjmEpJ/QHlSooRkvNk6lj7a+VQ1oRJ8vS0E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=KAwtSzrY; arc=fail smtp.client-ip=40.107.220.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UdxF/RjPPUmT91bvAxLpqhrKXi/m7um1X24dWmj6TiV7YQ8FZYN2vP5H5sC1vprp3TA94PHx7nIAL6fHiKT9XkXDwnHUGxCgen8JmqMlQWXE5NUUigaJA8K3B2Bjmag+rmyfAj2yEHoaR4CDHSoQnfY7mBlPqTuJq/SZMGw5eXt/sixazdhpsPNYdwGqRB2HdJF//v3UcH1eJrwRYF875Csr3VJI7JKQeot4klbYXssfmXd6HXgOpks4DAOGD0TxURyW80b4lDgsHTmlmuqlXM+iymOMU4svAtFG/F7sGyG6aFflHSbzcx6yVLhSlP/BBp1gq5HZ3DAKEfOWeM9TeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VYDa1DZfVlDJjpzCa5PnnVB4Phckm425devls+QYMjE=;
 b=fOqfk7ySYXENxMHdG8MxqaAt+z6ey/SLLwmoTymKlMmoBMqRdB+02S121VjimoKNDHAoLm9v1vAO5RRdEgc9kXgUFK1d+TFYvbLO7LyGle1whLJlpJ94GNTHxQQVtOpC1GI2KddOWnNIuApCbUuH2T1Ond1BmLvCOKWhqEOjepWSSjUG7s6va/PufdO1nOiBA0CFnbAvWDeo0w+Vz6W+4zmzJ3zoed8QUAwEqDYIP2yoaBL+pRzsu5GE6IiJQMbAjliicqRAqMs2/27L8qLGM6Iubn+4SOd3sBmb/rBC4ptKwa9Ot63Kl8uruJdKqQIW+/IgeUiyXlOmBYLZFlNtag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VYDa1DZfVlDJjpzCa5PnnVB4Phckm425devls+QYMjE=;
 b=KAwtSzrYi6Z1pxywR7padN3nDQnzxBfi0lq8AAavts3TPnpW+sSeM3DmlvIg69WOv9bVMp/BJTZGYyeHpZDHe7nDI818u1i4n16Zb4bfa27EyPgyzEKSZhf9McVTpgduTmHeO99bZdDR942hmJbvUzDkmlepUXC83On2KZ5itYk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6214.namprd12.prod.outlook.com (2603:10b6:8:96::13) by
 DS0PR12MB8788.namprd12.prod.outlook.com (2603:10b6:8:14f::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7982.26; Tue, 24 Sep 2024 16:56:07 +0000
Received: from DS7PR12MB6214.namprd12.prod.outlook.com
 ([fe80::17e6:16c7:6bc1:26fb]) by DS7PR12MB6214.namprd12.prod.outlook.com
 ([fe80::17e6:16c7:6bc1:26fb%5]) with mapi id 15.20.7982.022; Tue, 24 Sep 2024
 16:56:07 +0000
Message-ID: <07efd7f9-8adb-4648-aa3a-a4a3341bd9c8@amd.com>
Date: Tue, 24 Sep 2024 22:25:54 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 14/58] perf: Add switch_interrupt() interface
To: Mingwei Zhang <mizhang@google.com>
Cc: "Liang, Kan" <kan.liang@linux.intel.com>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Xiong Zhang <xiong.y.zhang@intel.com>,
 Dapeng Mi <dapeng1.mi@linux.intel.com>, Kan Liang <kan.liang@intel.com>,
 Zhenyu Wang <zhenyuw@linux.intel.com>, Sandipan Das <sandipan.das@amd.com>,
 Jim Mattson <jmattson@google.com>, Stephane Eranian <eranian@google.com>,
 Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>,
 gce-passthrou-pmu-dev@google.com, Samantha Alt <samantha.alt@intel.com>,
 Zhiyuan Lv <zhiyuan.lv@intel.com>, Yanfei Xu <yanfei.xu@intel.com>,
 Like Xu <like.xu.linux@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org,
 linux-perf-users@vger.kernel.org, "Shukla, Santosh"
 <Santosh.Shukla@amd.com>, Manali Shukla <manali.shukla@amd.com>,
 nikunj@amd.com
References: <20240801045907.4010984-1-mizhang@google.com>
 <20240801045907.4010984-15-mizhang@google.com>
 <9bf5ba7d-d65e-4f2c-96fb-1a1ca0193732@amd.com>
 <1db598cd-328e-4b4d-a147-7030eb697ece@linux.intel.com>
 <3dd7e187-9fbe-4748-9be5-638c8816116e@amd.com>
 <CAL715W+a9p_44CVdXZ6HCS42oUgfam=qYT_XoeN6zxfS16YY8w@mail.gmail.com>
Content-Language: en-US
From: Manali Shukla <manali.shukla@amd.com>
In-Reply-To: <CAL715W+a9p_44CVdXZ6HCS42oUgfam=qYT_XoeN6zxfS16YY8w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN2PR01CA0246.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:21a::16) To DS7PR12MB6214.namprd12.prod.outlook.com
 (2603:10b6:8:96::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6214:EE_|DS0PR12MB8788:EE_
X-MS-Office365-Filtering-Correlation-Id: ace9847b-6e92-4fbe-e360-08dcdcb9c82f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eFE3QkY0NUpJUHNDZDVxRjJieXNtTHdFL3ZSV3hZaDJBR3lJcU5TZTNPZjFG?=
 =?utf-8?B?dlBURG5ybXExRkNnRUg1VlpxRWFPYk5ocW51eGozL1pkUFQ1VDJ3eFkySkNI?=
 =?utf-8?B?MjVoR08wNHVBeWIva0Fsemw3U2hoQVl6ZS9vbDNMaFpZalVlV2U5UGc0dDY5?=
 =?utf-8?B?ZG5yZTVqUXpjZDlqaWQvYzNHTksvazRaOGZNMHpQTW5GdkFKbURQdXV6cERS?=
 =?utf-8?B?ZnNLSUNDck5HNTBFaGNpcWRqa2F5VTcrRjRLNE82cGFBemlCanNsS2VWMVc2?=
 =?utf-8?B?ZkhTOHMwWi9sb1pwYkZXMWhnUGNhNW1oSVVwMnV1SVNsajR0bGo2cXBqWlRn?=
 =?utf-8?B?VzZ0dVR2cW5BZXlGenlneDl2bFptME04Lys5R2xhRnd2Z2FaRm54TUlSR05F?=
 =?utf-8?B?T2tjTytmbzY0a01NbmFIbUkrOHZadi9iN1FRL1YzalBObGJNcnZuNzJlc1Uv?=
 =?utf-8?B?NUFUWWwrVXhMTnFqZ3I5ME53ZVBIVzdHc3BOQ0YwOWRpTmkzWUJiUGxubzM0?=
 =?utf-8?B?MEcvYTZQMFM4SDd1a2ZmNHcxRmpUQWlZWWF1VmJBVWFWdE1MZ1BXL0wzV2JC?=
 =?utf-8?B?WGR2VVdvQ2xQWXJIZjZNelpNdU5pc20vZjRYYUVYcDI4bmhlQ0lweG8wSVpo?=
 =?utf-8?B?dS9HcHVMNzVyaXNVb3BpanJZYmIyVFY5ZjBvek9TeVNKcU0rdi9UNVMrOERm?=
 =?utf-8?B?a2hJUExMUnJieitUckZJMjFRbkovenFLY1lsOW85RTI0NjVWK1ZNRFhwQzh5?=
 =?utf-8?B?ajJDK0l2SWk1M01tamhzNEtqMENOM05XS2MxeTJCN045VWJqc3lCTlRua21w?=
 =?utf-8?B?bVlhcEt5Q1dMR0NsT1ZaNzVndmwxeGZvTCtiK1gydjdCYzczOXA1VlZWblk4?=
 =?utf-8?B?OXBQZGFIOVpid1RMMHFxUkhkc2ZTTEFJdDRvSXVmeDdVV2FDTDMvaHpZb2pl?=
 =?utf-8?B?WDVZcVRQSkR1Vm8ybC82dmI3TGsxczlxREhCYVgyQ3lpMHgxSXlqekdVWnI4?=
 =?utf-8?B?TXVFVW1JT2RXT1VjcEphdEdrWW5PYVg0K1BSQWluU2NKalA5TEZMcUI5cXRW?=
 =?utf-8?B?VGJ0cFdnT0lzOFdsaFZPajBmSUVOM3d2RGJLNkhINDFWa3FQN01uM21JQnVH?=
 =?utf-8?B?SW1QenBQbzRxdEhqNG1DTFBNdWZBRFdBcDdYOG5jNXVDQ24vaGFGWU9OMkJP?=
 =?utf-8?B?dSs5N01ZUUJjSHUvREwvVDFIYTBsdFUxdFpEY1ZiMTIzcWl5NXJ1YW5SaklH?=
 =?utf-8?B?VStSWlJadk4xYzNNd1R5bks3NVFSWXEwMFVmWUVMeWtBL0M1eHBRWU0rM25u?=
 =?utf-8?B?c3hTczlpQ3M0UTZ4ZkxWbUh4R0E2ZHp1b3BHNlREa2lsbFFKYjhvQ3dmazRC?=
 =?utf-8?B?OTlFMHNpa3huaWo0VnNTakZUb2FuOHNmVUtUMFJ2OVFNb3hOV2NkbmM4Uld3?=
 =?utf-8?B?SFNYdzhvWTRUOXI2c3JobzN6YkFUL0ZEam0zN04xM3RJek4vQkNXWlBNMWVY?=
 =?utf-8?B?YW8zbHczK0JSdnJ4dk92dzFJeE54VzU3S3pMc1FZUC83elBuVWpyMnU1R2Jy?=
 =?utf-8?B?cFVlYytQMml0cVdRdjJXb1Q5VnhWSm9zcXdOdkdjMW94N0J2ODMvT2k4THcw?=
 =?utf-8?B?Q0R3QXE4WmNoN2Q1dTBqR3AvVFlaTGtLK2xzUDRHWkJ1MXRlSVZLNjBZUDNL?=
 =?utf-8?B?ck1FVnJteHBTeUJKM2xJTXp0VmdnaWdLRk1oR2YrQ0xmcGJxYkdRV2NRPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6214.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cEEzQlIvUVlwNzlBNXlVazY0NWVEWmJiUXVlK0FqRVJUMFNQaUNETExHZVdD?=
 =?utf-8?B?dEJ0MTZBREhxYlZUdnRMZSthbFhOUnVkckwrOThVNTZMaFpqTXFrT0NvSzRN?=
 =?utf-8?B?SkZDY1VFRW1LdWc2cFYzQ1EySU5sMERrenNYalhrd2EvVmhyQjBuTGJZZC90?=
 =?utf-8?B?ejhuc1F1RDRob2lOdFNVRkEvenBTQU0vek9FVzBaUjM1UVRhVUllNHNFZjRI?=
 =?utf-8?B?V1MySGxXYSttNEFkL3FTQ0dPbVdUZFpJSkZFTU1TVEtaVXRXWFpmdUVnUSta?=
 =?utf-8?B?NUVER3lrYjQ0VG1kaEkyYW5BVGtCeGc3OGNHSEZWZHdDZXdlRnZ4aTd0bng5?=
 =?utf-8?B?YmlhMzJXZHB6R0ZNSU1PNkJHRkhla0pzQWZGWnF6cFRGM0l4Ly9mcWpsMWhR?=
 =?utf-8?B?Y1lCNHh4eUpLNVZqZTl5eEdwdCt5b2I1SGlKcitlbHJlaXJ6dDY1UmtwTXR5?=
 =?utf-8?B?MHptOUszaFoxbVRCclArVmxKVFJLTTVOcGNqNXFUMWtVcTEvSHZobk1tNU9l?=
 =?utf-8?B?ejZOTitXVG5XNEZOc1J3MTR2TlA4a2s3NldYWlhOWHFodkkyYytCTG9HN2tx?=
 =?utf-8?B?SjYyUnl6QmxSbitoUk40aG9YRzV1WVlnUlpyTzQ3SGwyVy9HL0R3eFhQd1Jn?=
 =?utf-8?B?MEREdDhMODVBWVVnOFhxSEpiRUFEcU9oQ3pRK2drSE9MTkkvSC84ZHFXYjlE?=
 =?utf-8?B?eTR1TmRYa1d4cTRmeEZ6dndZa25uQ3JaZHRlSmxqNmd6Q3pKZkVOdGU3cTlY?=
 =?utf-8?B?TWdzREhWblNYbDlYVGV4WXVjNnF6ZnA2RkJKNi9LWTlLdzRxLzF3UllHRzl4?=
 =?utf-8?B?dlhSdm9XL1JxUnVMSU51SHFhajI4QnF1OFFlc3hpOGhPOGVPWkx5YzYvM08v?=
 =?utf-8?B?eFlzRlhyVDRwY3QyQWdlbUd6SnJVcFR0S0FnOEtMWm5tcXhMWFRLRUM3a1JM?=
 =?utf-8?B?MGFvbmFWVFNXTm5mYUwwNi9mTElwUEVNSDVBMzBaNkcrTHFKODFUdVBJMEZ5?=
 =?utf-8?B?bi9weXFGM2w2TG5kaEZlY2tUeGJNa2tlM3VNelA4Z2tlUElKSDE3MFcxZnJE?=
 =?utf-8?B?NlNkbTBIRkRhdDZnTkxtRDJUYkQyay9ZOURrSWZscXZNOVBSZldKNWo0UktQ?=
 =?utf-8?B?dVFzTXJDYXVMbVdxcFdvZGJlZzRSQkl1WWFaTDkwZklaTGwxWmJReFpBMk9D?=
 =?utf-8?B?RVlXeEpNZktWbTJqeVVMeElud0xDTGhTWEFxS2x3WFVJbGhJdE9kSTllUkVn?=
 =?utf-8?B?WTloVmc5b09PcS84ZU5Ed215bEY2VHNHak9qMEtLRGhnNDdkU21ZT2hpczlF?=
 =?utf-8?B?Mm80eEdZdmNlVFFvN1pzV0ZaZ1B0bll3OTdGNmw2bWlDVWVhOENScmdWOFQ4?=
 =?utf-8?B?MDlpZzliQVVaQ2ZFWUgxT204QlMxY2hVOGJMN1VpWVVhQkFqc2JVMjQ4QnFP?=
 =?utf-8?B?Z1hvRXE1K1ZHZlZSYjlxcHFjSlQrb0x0dlVISFJxaGUzNFhnNk1rSDFnK1JK?=
 =?utf-8?B?OEM0L3A0YnN5Z3JlR29HQitxRXZWbGlDUUhnVDUxRGl5L2ltc3dSNzRZNkdS?=
 =?utf-8?B?ZmVEQ2R0Tm83VjdZOVRPNFk4blRvMXQ1Uk5WUFVnbndONG14NklsU1FxN3dD?=
 =?utf-8?B?VmV0TnNiMzB4cVM5ZDdrSktzdE5pRS9rRUVZQXpLUVVzQnc2enB5dm1NM1k0?=
 =?utf-8?B?bFJ4OHdxWVVXMloyazBQK1FObG5OSDFObmZKM2hmL2RIblQ0c0cxMGdCVEQ4?=
 =?utf-8?B?cC8xcG91RWluMUhDdmxCdkRzUVZULy9oNEUzRm0rcE5iUHRvN3ZnQTRtdkRr?=
 =?utf-8?B?Slk0SGdpRTNpTXZyR0kzd3JaWm55UFpLT1BZUzhXQUNZZjAxbXFBaXM4UjVS?=
 =?utf-8?B?bDJHcU9mMFhuUjNmRXgwYUQ4ZCtoN1UvSjFxdnBJY2x3TE9DUTZySnNBTVJZ?=
 =?utf-8?B?dlVWS3NmbHU3Tm9ERjFNVUpSK08zQk5Od1V1cnZrc1ZoQUhQOUxOWDVsaUJj?=
 =?utf-8?B?bk1ySHZUSjUwOWI1T2Uzc0VrbFZyai9ZSlNESEtXMDJFbytZV3BiOWZTL1lh?=
 =?utf-8?B?ck54QkNzVFgrU1Z2RzU4cDYreFVML3E2Q1dGdlAzOWtsVUk3T09MZUdLRjBa?=
 =?utf-8?Q?JgMXGbxSy+dJ759n5NuKppXof?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ace9847b-6e92-4fbe-e360-08dcdcb9c82f
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6214.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2024 16:56:06.9580
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DT/Y4QF6/j0fEs8Ydk+qNtKHJhvuZO/X2thh1r9DBmHtwf9bwNDOiEQKw74HMI6ti5t19kLQveb/0Af1jlOj0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8788

On 9/24/2024 12:19 AM, Mingwei Zhang wrote:
> On Fri, Sep 20, 2024 at 7:09 AM Manali Shukla <manali.shukla@amd.com> wrote:
>>
>> On 9/19/2024 6:30 PM, Liang, Kan wrote:
>>>
>>>
>>> On 2024-09-19 2:02 a.m., Manali Shukla wrote:
>>>> On 8/1/2024 10:28 AM, Mingwei Zhang wrote:
>>>>> From: Kan Liang <kan.liang@linux.intel.com>
>>>>>
>>>>> There will be a dedicated interrupt vector for guests on some platforms,
>>>>> e.g., Intel. Add an interface to switch the interrupt vector while
>>>>> entering/exiting a guest.
>>>>>
>>>>> When PMI switch into a new guest vector, guest_lvtpc value need to be
>>>>> reflected onto HW, e,g., guest clear PMI mask bit, the HW PMI mask
>>>>> bit should be cleared also, then PMI can be generated continuously
>>>>> for guest. So guest_lvtpc parameter is added into perf_guest_enter()
>>>>> and switch_interrupt().
>>>>>
>>>>> At switch_interrupt(), the target pmu with PASSTHROUGH cap should
>>>>> be found. Since only one passthrough pmu is supported, we keep the
>>>>> implementation simply by tracking the pmu as a global variable.
>>>>>
>>>>> Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
>>>>>
>>>>> [Simplify the commit with removal of srcu lock/unlock since only one pmu is
>>>>> supported.]
>>>>>
>>>>> Signed-off-by: Mingwei Zhang <mizhang@google.com>
>>>>> ---
>>>>>  include/linux/perf_event.h |  9 +++++++--
>>>>>  kernel/events/core.c       | 36 ++++++++++++++++++++++++++++++++++--
>>>>>  2 files changed, 41 insertions(+), 4 deletions(-)
>>>>>
>>>>> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
>>>>> index 75773f9890cc..aeb08f78f539 100644
>>>>> --- a/include/linux/perf_event.h
>>>>> +++ b/include/linux/perf_event.h
>>>>> @@ -541,6 +541,11 @@ struct pmu {
>>>>>      * Check period value for PERF_EVENT_IOC_PERIOD ioctl.
>>>>>      */
>>>>>     int (*check_period)             (struct perf_event *event, u64 value); /* optional */
>>>>> +
>>>>> +   /*
>>>>> +    * Switch the interrupt vectors, e.g., guest enter/exit.
>>>>> +    */
>>>>> +   void (*switch_interrupt)        (bool enter, u32 guest_lvtpc); /* optional */
>>>>>  };
>>>>>
>>>>>  enum perf_addr_filter_action_t {
>>>>> @@ -1738,7 +1743,7 @@ extern int perf_event_period(struct perf_event *event, u64 value);
>>>>>  extern u64 perf_event_pause(struct perf_event *event, bool reset);
>>>>>  int perf_get_mediated_pmu(void);
>>>>>  void perf_put_mediated_pmu(void);
>>>>> -void perf_guest_enter(void);
>>>>> +void perf_guest_enter(u32 guest_lvtpc);
>>>>>  void perf_guest_exit(void);
>>>>>  #else /* !CONFIG_PERF_EVENTS: */
>>>>>  static inline void *
>>>>> @@ -1833,7 +1838,7 @@ static inline int perf_get_mediated_pmu(void)
>>>>>  }
>>>>>
>>>>>  static inline void perf_put_mediated_pmu(void)                     { }
>>>>> -static inline void perf_guest_enter(void)                  { }
>>>>> +static inline void perf_guest_enter(u32 guest_lvtpc)               { }
>>>>>  static inline void perf_guest_exit(void)                   { }
>>>>>  #endif
>>>>>
>>>>> diff --git a/kernel/events/core.c b/kernel/events/core.c
>>>>> index 57ff737b922b..047ca5748ee2 100644
>>>>> --- a/kernel/events/core.c
>>>>> +++ b/kernel/events/core.c
>>>>> @@ -422,6 +422,7 @@ static inline bool is_include_guest_event(struct perf_event *event)
>>>>>
>>>>>  static LIST_HEAD(pmus);
>>>>>  static DEFINE_MUTEX(pmus_lock);
>>>>> +static struct pmu *passthru_pmu;
>>>>>  static struct srcu_struct pmus_srcu;
>>>>>  static cpumask_var_t perf_online_mask;
>>>>>  static struct kmem_cache *perf_event_cache;
>>>>> @@ -5941,8 +5942,21 @@ void perf_put_mediated_pmu(void)
>>>>>  }
>>>>>  EXPORT_SYMBOL_GPL(perf_put_mediated_pmu);
>>>>>
>>>>> +static void perf_switch_interrupt(bool enter, u32 guest_lvtpc)
>>>>> +{
>>>>> +   /* Mediated passthrough PMU should have PASSTHROUGH_VPMU cap. */
>>>>> +   if (!passthru_pmu)
>>>>> +           return;
>>>>> +
>>>>> +   if (passthru_pmu->switch_interrupt &&
>>>>> +       try_module_get(passthru_pmu->module)) {
>>>>> +           passthru_pmu->switch_interrupt(enter, guest_lvtpc);
>>>>> +           module_put(passthru_pmu->module);
>>>>> +   }
>>>>> +}
>>>>> +
>>>>>  /* When entering a guest, schedule out all exclude_guest events. */
>>>>> -void perf_guest_enter(void)
>>>>> +void perf_guest_enter(u32 guest_lvtpc)
>>>>>  {
>>>>>     struct perf_cpu_context *cpuctx = this_cpu_ptr(&perf_cpu_context);
>>>>>
>>>>> @@ -5962,6 +5976,8 @@ void perf_guest_enter(void)
>>>>>             perf_ctx_enable(cpuctx->task_ctx, EVENT_GUEST);
>>>>>     }
>>>>>
>>>>> +   perf_switch_interrupt(true, guest_lvtpc);
>>>>> +
>>>>>     __this_cpu_write(perf_in_guest, true);
>>>>>
>>>>>  unlock:
>>>>> @@ -5980,6 +5996,8 @@ void perf_guest_exit(void)
>>>>>     if (WARN_ON_ONCE(!__this_cpu_read(perf_in_guest)))
>>>>>             goto unlock;
>>>>>
>>>>> +   perf_switch_interrupt(false, 0);
>>>>> +
>>>>>     perf_ctx_disable(&cpuctx->ctx, EVENT_GUEST);
>>>>>     ctx_sched_in(&cpuctx->ctx, EVENT_GUEST);
>>>>>     perf_ctx_enable(&cpuctx->ctx, EVENT_GUEST);
>>>>> @@ -11842,7 +11860,21 @@ int perf_pmu_register(struct pmu *pmu, const char *name, int type)
>>>>>     if (!pmu->event_idx)
>>>>>             pmu->event_idx = perf_event_idx_default;
>>>>>
>>>>> -   list_add_rcu(&pmu->entry, &pmus);
>>>>> +   /*
>>>>> +    * Initialize passthru_pmu with the core pmu that has
>>>>> +    * PERF_PMU_CAP_PASSTHROUGH_VPMU capability.
>>>>> +    */
>>>>> +   if (pmu->capabilities & PERF_PMU_CAP_PASSTHROUGH_VPMU) {
>>>>> +           if (!passthru_pmu)
>>>>> +                   passthru_pmu = pmu;
>>>>> +
>>>>> +           if (WARN_ONCE(passthru_pmu != pmu, "Only one passthrough PMU is supported\n")) {
>>>>> +                   ret = -EINVAL;
>>>>> +                   goto free_dev;
>>>>> +           }
>>>>> +   }
>>>>
>>>>
>>>> Our intention is to virtualize IBS PMUs (Op and Fetch) using the same framework. However,
>>>> if IBS PMUs are also using the PERF_PMU_CAP_PASSTHROUGH_VPMU capability, IBS PMU registration
>>>> fails at this point because the Core PMU is already registered with PERF_PMU_CAP_PASSTHROUGH_VPMU.
>>>>
>>>
>>> The original implementation doesn't limit the number of PMUs with
>>> PERF_PMU_CAP_PASSTHROUGH_VPMU. But at that time, we could not find a
>>> case of more than one PMU with the flag. After several debates, the
>>> patch was simplified only to support one PMU with the flag.
>>> It should not be hard to change it back.
> 
> The original implementation is by design having a terrible performance
> overhead, ie., every PMU context switch at runtime requires a SRCU
> lock pair and pmu list traversal. To reduce the overhead, we put
> "passthrough" pmus in the front of the list and quickly exit the pmu
> traversal when we just pass the last "passthrough" pmu.
> 
> I honestly do not like the idea because it is simply a hacky solution
> with high maintenance cost, but I am not the right person to make the
> call. So, if perf (kernel) subsystem maintainers are happy, I can
> withdraw from this one.
> 
> My second point is: if you look at the details, the only reason why we
> traverse the pmu list is to check if a pmu has implemented the
> "switch_interrupt()" API. If so, invoke it, which will change the PMI
> vector from NMI to a maskable interrupt for KVM. In AMD case, I bet
> even if there are multiple passthrough pmus, only one requires
> switching the interrupt vector. Let me know if this is wrong.
> 
> Thanks.
> -Mingwei
> 

Yeah, That is correct. Currently, switching of the interrupt vector is
needed only by one passthrough PMU for AMD. It is not required for IBS
virtualization and PMC virtualization because VNMI is used to deliver
interrupt in both cases.

With the mediated passthrough VPMU enabled, all exclude_guest events
for PMUs with PERF_PMU_CAP_PASSTHROUGH_VPMU capability are scheduled out 
when entering a guest and scheduled back in upon exit. We need this
functionality for IBS virtualization and PMC virtualization.

However, the current design allows only one passthrough PMU, which
prevents the IBS driver from loading with the
PERF_PMU_CAP_PASSTHROUGH_VPMU capability.

As a result, we are unable to utilize functionality of scheduling out
and scheduling in exclude_guest events within  the mediated
passthrough VPMU framework for IBS virtualization.

- Manali


>>>
>>> Thanks,
>>> Kan
>>>
>>
>> Yes, we have a use case to use mediated passthrough vPMU framework for IBS virtualization.
>> So, we will need it.
>>
>> - Manali
>>
>>>>> +
>>>>> +   list_add_tail_rcu(&pmu->entry, &pmus);
>>>>>     atomic_set(&pmu->exclusive_cnt, 0);
>>>>>     ret = 0;
>>>>>  unlock:
>>>>
>>>>
>>


