Return-Path: <kvm+bounces-44812-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EF9BAA13C9
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 19:10:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BCD12927FC1
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 17:04:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40943251780;
	Tue, 29 Apr 2025 17:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="FsJBXNsE"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2054.outbound.protection.outlook.com [40.107.94.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B23D224A055;
	Tue, 29 Apr 2025 17:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946238; cv=fail; b=Pa91v1xsteKXj57QkocN3bNuH0xu/7qBGzUgkagPRHRBgg3P82X5JOkmCi9i4B8NeBBiEuxTWXFuh8oRHv+W/b5p2Licr2ppZrXMSWCJuMHIFtW/fjYkigBCsFJsANBQecJgdpB/C3WqaQLAuboYPRsn2+ElevlqYo2q/TmkwP8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946238; c=relaxed/simple;
	bh=mrJGKVVZDyAU821gMxW7VpjMV12df6AyFpRxBBbtdCs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=CH/MEqs5SchQEiY5cAI5oo/uvFFXdmKGqeIcxNxx8VROPxS+tHdcpQIRbETU7VhrYHgQRTgKCPeLYCUolhS7TS4fBqsZTFV1KCxDhjpsbMS9TRLD4x5giE/ZapL/s4ts921h1JGqQBZZ65fLMfbM6IVGMvzzleHyy2BG+tPqfVc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=FsJBXNsE; arc=fail smtp.client-ip=40.107.94.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZomwlGMGoeY6CUeKckN8e9maZ4MUuimidez2K3tRHDlvYeft7SY0ZdwTDwgf8NeTe/5KLovgz9YTGDoCshZcZMIquAA4/CpdXdA9i/oSq5UofMmtlTvwPXLgvqyYO+AwusAx+fU5bPg5RRyBygFCIlECgDyGMH4n2wXoTQgso+TcpkgDocaaiZXGZd0BgQBGzrioQEVreWwzsJFbMSqvnletueu8Ix8AsccIQZXsETujMpejU8vous+HITQUcP0f1yq66sj1N2znqCBOLOcsVNGG/W1pTD8uCYMCA466Q06AVT1ybiEN2pM0g5oYTE1WsIYduAUhW4KMIgRIOEUJAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6DQVFsKYz/EZeoBfORBWsMVHo5HNsxEY43czVIH3lr4=;
 b=o6YdQ6w/hJDsu6Zv1+dAjY56chzSbiznOZGD1M8xGi6P42VGMGvGSMIxq4DMv9WzCGZjD2lgt7jKCvDn0kkU329uASnFhD3wpRxwD98yNuvwHPFAx78i3RfW2uXNnFMUj4yqNOJN7ohNfSueIK2xWhheqn1LOptNp6J77xGsTIheoXAKArTlfGkJe11lPY7p3bIsWlmYjkVJDCwLtrG5Ag2Fj/HXQUAtEoBjj/UwWjpFwB3VgjUDuLckktmHNOodFG4vaGSmx9Qyk1qUkhBZU3VYaml34p7w5IZLYF1rCFdRPPSFAof/n587UbYhm4tKwNnn4jdMArQ5N5emVuHu8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6DQVFsKYz/EZeoBfORBWsMVHo5HNsxEY43czVIH3lr4=;
 b=FsJBXNsEJ/WtL8+CR+D81M1EqJBJbE86sbFjjktBum4/0FKzfC5ZS+BkYuNKW4CicWeF7QoV2Y53+nykdasKaon0mSWPYsJqOWRkzZxCuDRN/fzUeCK32+ljUDSuaboyiBFMLzYC1g5kEOJbfeTLBh34BXUssZoi47W1SxPjSoA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by IA1PR12MB9532.namprd12.prod.outlook.com (2603:10b6:208:595::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.31; Tue, 29 Apr
 2025 17:03:53 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8699.012; Tue, 29 Apr 2025
 17:03:53 +0000
Message-ID: <536d5354-97d4-e9cb-9caa-f25c934b08a2@amd.com>
Date: Tue, 29 Apr 2025 12:03:48 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH] KVM: SVM: Update dump_ghcb() to use the GHCB snapshot
 fields
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>,
 Thomas Gleixner <tglx@linutronix.de>, Michael Roth <michael.roth@amd.com>
References: <8f03878443681496008b1b37b7c4bf77a342b459.1745866531.git.thomas.lendacky@amd.com>
 <aBDumDW9kWEotu0A@google.com>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <aBDumDW9kWEotu0A@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR01CA0034.prod.exchangelabs.com (2603:10b6:805:b6::47)
 To DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|IA1PR12MB9532:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ed6bc96-e82e-4af1-a951-08dd873fd211
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?a3NNSE5pb3J2MklCT2ZJM0t6eWpMMnpBeGNzUjU5bnNlaTJlUTVYb2xscCt1?=
 =?utf-8?B?ZDk4K0dwdkZYMTlUQWdFbXF6QWg3OFdUbGlscXgyQ3ROcWdLQWc1VUxiYlVN?=
 =?utf-8?B?cjNhbTl4QXVndkR5ZGNhVnk4S29PZWxBU3IrbjBYS2thc3Ftam51dy94N2hp?=
 =?utf-8?B?VU0rWHhubXIwaVQwV2hseUgySktvb0cxUDJMTmI5YmRBTXFmeldJYTB0MVdP?=
 =?utf-8?B?UE1PdFJsQ0J3bmNkZkdUcEQ0ZmRjdGUreDdsL3BjWmZGUG81c3dOVW9kTXlu?=
 =?utf-8?B?M3BhWHltcDFNeFF5cmFudWVaeGY1ZWlSamtBRG11ZU9tMWlud0lKRGkwMjVy?=
 =?utf-8?B?cCtxYWpHZkh1Z01HTE5tblBmWngydldtRW1OaHJoZDdLanVFNmxNVWxGa3F2?=
 =?utf-8?B?ZUFreUpsL0M4ZzRIUG5adGdpK0QwdXhkZFp2dVYzTWM3ZTBkOXhDYVNFQkh4?=
 =?utf-8?B?MUJHY1dZTjc1RENWeGcrakJHT29xQkd1MGFvb3ErWHRHcS9CS3JTRTFrTXBl?=
 =?utf-8?B?Tk82dUxVTXdsd2VHWHVOWUZ5MjhDY2p3WU1qaWh5OFZTNWJhdEpheHdNcWIv?=
 =?utf-8?B?b2JieU9CZS9Sb3llSVk3am8zV3J0NFUycG1HY0VMeDFOTHFEQVlsQmh1VmJt?=
 =?utf-8?B?YXVJUGVQVzZyTzdFVnRvWUk1cHIxZ0JENGJCMVQ4RDMvK1VEZjA3NVRLTzJV?=
 =?utf-8?B?SW53cm9UZWRNNXFVcm5YWVVkU3pPVVlyR29kM0NhcE1UNnpnTG9tWG9lc015?=
 =?utf-8?B?cS9xMGY5UkNIdXl3dzRNTDZmUUhGMzAybXRwa0hraWsxWUZhbVlWWVROQzIw?=
 =?utf-8?B?MDJnVEFxMHk3bnRqeExYSkl3VmFhUE9ocy9iYzFIaTVsVGRnYkl5aG5UL1Fy?=
 =?utf-8?B?YlFpSS9MSkMrUVZSMkVxZm5HZms1NjRRWHlSZmJIU05YRm5WTFpzQlNhVkps?=
 =?utf-8?B?MU1LRkZIMS9SZnh6K3BjSE81alFJTlVFNWs0emIzZjVMVnB0UzhMa3dLa29q?=
 =?utf-8?B?OUczOHI3WlZjOHpmdHJqZGFNejFwLzZpM0JNM05EMUxCNWlXU2tteG0vUFZr?=
 =?utf-8?B?ME1pNmxmdHZrYnF0S0t6NXZRWmJuNWZSWGhSMVh4ZUJLdGpsTzM1YlkvVzJH?=
 =?utf-8?B?NW1naFRrNWx2aWFrb0JQNWxJNmZsbkJnY3FEMkxhS2NIZm5KdndBZENac1U3?=
 =?utf-8?B?RXJDVXk1djFWSzZGZlh2VVdubFZIZExqcmp5YnhaM04vMTJkR1NTNHZoaU9x?=
 =?utf-8?B?RFhGS0VGK2pxNE9MKzZCaDJNMk5wQkduVWRjNER1ZzRoVHFvSXZqd2txdng5?=
 =?utf-8?B?eGFLdXY5QXRVMEgzRDdNOUJUUjN6Rk1IZzRRTjNJakROVFY0SGh3UkdUTjRy?=
 =?utf-8?B?UnRWKzJrUTBwYjg5US9RdnkralBQVi9ZOEZBN1pGcWJ0bFFRdXJjWlFNQkZF?=
 =?utf-8?B?VEg1ZFdUZEFNVGFqZkhEeUU0T0VlNHlMMWFaMnBTaDNLRk5lZk9HMDkzODAz?=
 =?utf-8?B?THFiMmZ2Ykl4OFVnMUlMeCtOSjlQRkgycWxVV3lKSEdnRkc0YVlDbjVJRmJ0?=
 =?utf-8?B?em9BV1ZvMGxsZG40WlN5MnMyRUtZMkdza2ZLdUxxeGxydHVFdUFSdGlGblV6?=
 =?utf-8?B?NlBkb2dlMjUyWnNDQURZcjc5THRLZHBiLzVaYUxGT1c1dXVrVnRldFpuell0?=
 =?utf-8?B?K2pnbG1oVmdiMnRDTk5EUDdhMFNCY09hUUgrN1JBRGdPS1Vsbi9GSUc0d2lt?=
 =?utf-8?B?cnJPTVQxbkFYQXU5NFhicU9WK1RpdnJhSTVZdkpydzMvSFArYytxRjhHTE5L?=
 =?utf-8?B?eHpwekllUWw2a2YyQmZ0cE9oZXNmZ08zZmp6YzVzbVVYQjAzcDRseXhvdUNN?=
 =?utf-8?B?dHVIV0t3bnJvd1JGN1Q4Y2xNVDFLaEV3K3FCRmlvS3lxK09WWjhzOXU3QWpw?=
 =?utf-8?Q?jPF0H/+ozRg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MTMrczFoNG44Rm05cnl0SCtqbi8wZWlNbVlFUmg3dElWS1kxL3ZsQW4wTUxy?=
 =?utf-8?B?aE9Qb2tpc0xGNm4wOUl5TmY2MUxHNDkveFdRMGsvU0syTVM0UUI5VHFyTlJO?=
 =?utf-8?B?ZFFQcEl0WVRhcFd1T1lYbUYrdEVsVFNKWkliQURIWndUUjlqQ2czcjFkalNr?=
 =?utf-8?B?K3p2T1ZmMlVpdDdLeGlzVVlRTm8vWFdrM0tQMnVPQnQrck1YOXV0ZXg2Q0Fl?=
 =?utf-8?B?ckp2eU9RVmREcHNLK3dLN3BBUG93TWMzckxBV05nYUFLTFBidGt3TTdZcWU2?=
 =?utf-8?B?aUNRTHlNaVVvcDRDbWlvTFg4L0gzaDdjYlJlclI0RVhoQlhjelY0UjA2UUpy?=
 =?utf-8?B?eVhUeW16QnZaTjZLamlCQlhyb3JsRWlNdXYxazFFMlZRbTV5bWFFbFpQTGtv?=
 =?utf-8?B?UlZxYytuYk5HQzFOSU5jYTY2dEFVNHRjYjgzMlZIRGVPaGtuUWZiaW9SOFZJ?=
 =?utf-8?B?djRDS1RRWG9yOFlNdkNVejEwSU5vVE1rZzZDVUg3RGpndGdxVWF4RVhjUnVz?=
 =?utf-8?B?Z3NGQzNGZHpJc1FvYi9LZnp3eUNWYlBWZ0FDMkIyVHFzTXdxRDQycy9lZ25w?=
 =?utf-8?B?ZTlMM3BET0YyTU4yd1VGWUlJVjBkUWw3c2liTXFucVErYmhjby95SXJKeWdS?=
 =?utf-8?B?dWlDRC9vY3M2NXQ5Y1RqMTBoMWV1ZGZNZjhPYzJTSWU3QTRZM0lORjJWTTF2?=
 =?utf-8?B?WmV4M2c1VDJ6a1VwbUZyOGR1ZzJhQm10dzRhcHV2TmZMQVQ1T2VpZGVlTlpC?=
 =?utf-8?B?T1lnMk94SHMrekhPRC9hMUZkWWdvVjlKcHBTUFRNcDluamN5c001bE9ET04r?=
 =?utf-8?B?eGI0dHBiWTFVZXJ5UFZsQzg3NVNTNzdnSHdJV3JDVlE1Zk05MHgxcVUyYmI5?=
 =?utf-8?B?bmQycWpDYUxHRTNadWJ1WUFwb0FmSTk0SmltVEE3dzJyWTlZY2wvelRYSlAz?=
 =?utf-8?B?N2owMmd2eGswT29qM0VjTlF4SDBXYXRTb1I3dmJRMWZsbUZXZExvakh1bHY1?=
 =?utf-8?B?VWMrdmdlbWdmTDRRY0VzZm1kNWg4dlcyRXJLeldwM2R1K3BEMmFrdTl3ckdL?=
 =?utf-8?B?TGR1YzRQTG1LUW85Z0xZOWw3T0lmVjJSRDJQYnFNakhEMDF5YVFLVzdCK0dv?=
 =?utf-8?B?ZDhHU0dTZHQzWXgrR3AxVkpjc05DaGJydTN0QjVLTGViNU1EbndwTUQvU1Vw?=
 =?utf-8?B?U2ZuejVHMHRMOHIyWTl6NFRmU0I2T203S0QrVHVOSHRGT01mWTdqOGFvaWh0?=
 =?utf-8?B?ZHBqMCt0dUNJWE12TmhCVDIwTXBxOUs0S0JKeHNjU0xRaWRIRUtjRU85cU9E?=
 =?utf-8?B?V0YvQnN1OXFQMkRXVVFkMEhUQ2JLWC9vUkdSYnFRQU9hejIrNFZvODI5ZHB1?=
 =?utf-8?B?KzVOTk9uSmVhUnJxT3U2TENHbkxWK0s0VzF6WWZlWGZkdU1GZFlpZ3ZKUlFl?=
 =?utf-8?B?anoyb20wY3hxUjZGa3BhVUhDS2ZoNnNKT3A5MGZVS3lOY20yaUNUQmthZjdv?=
 =?utf-8?B?cDY1L1BpbU9qYVNvb21rblM4Z09SdlBqMk50aXNsblRFcFpjMk9Dd3ErbEJs?=
 =?utf-8?B?cmNkc2xDSWdqRWJJZzZwRkZvN2lZVGtGTmlaaGxBdXR2VG5ibDljdjdjajN1?=
 =?utf-8?B?a2ljb0lJQ01tMVpOaE9GWVp3LzhHZGZMOE5WYm0wMFJtMTh0SlliNjBqOEpq?=
 =?utf-8?B?cHg2dG54V2Q5QkZlLzZUVkNYRTdmNHVjeXBtNjcvZlEyOFJuVXZHb3hVcEF1?=
 =?utf-8?B?anFXWHF4Z2tIN213a3VEQTNpek5UZkJNR1h2QjFoRlNBeTFCSW1vZ3ljRWU4?=
 =?utf-8?B?QmttUHR2dDdBT1NkbEFQMlBHMEtiaXZ6NnQzNFlIS1R2MGNIdWF2bDBpZnRX?=
 =?utf-8?B?V3I1eHdMWWhqRTBMVG1ZejNsS0ZEZW4yMTd6ZmtOZWp3OHBCVmNLUVFsaXpy?=
 =?utf-8?B?V1Z0aTRrQk5qS1phOEZGTTkrd3NXRmFTK0NmNWFGTjFjcXp4SDJ0UjRJVkt2?=
 =?utf-8?B?dkRyQ21YZnRmSW9rdnlPaHBLdGRPcUplREFiRkhrQVYwbk9NTHh0SHJsOWdR?=
 =?utf-8?B?bVZjaTRZdWJJS1F5azNmcDM4U3YveGpsSk5SL2cwcGhPMDhEYnFXQlU3dENC?=
 =?utf-8?Q?FgXHgNDk6E/keFWaDszTOACnE?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ed6bc96-e82e-4af1-a951-08dd873fd211
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2025 17:03:53.5385
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ESS5aojjxDsH4aN3pnaWuUCew8plF072c4E4GF/n5TS0OHrszcuGP47+PWZhvcygqYlXpEBgndxgwZwEzmfIkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB9532

On 4/29/25 10:22, Sean Christopherson wrote:
> On Mon, Apr 28, 2025, Tom Lendacky wrote:
>> @@ -3184,18 +3189,18 @@ static void dump_ghcb(struct vcpu_svm *svm)
>>  		return;
>>  	}
>>  
>> -	nbits = sizeof(ghcb->save.valid_bitmap) * 8;
>> +	nbits = sizeof(svm->sev_es.valid_bitmap) * 8;
> 
> I'm planning on adding this comment to explain the use of KVM's snapshot.  Please
> holler if it's wrong/misleading in any way.
> 
> 	/*
> 	 * Print KVM's snapshot of the GHCB that was (unsuccessfully) used to

s/snapshot/snapshot values/ ?

> 	 * handle the exit.  If the guest has since modified the GHCB itself,
> 	 * dumping the raw GHCB won't help debug why KVM was unable to handle
> 	 * the VMGEXIT that KVM observed.
> 	 */

Otherwise, looks good to me.

Thanks,
Tom

> 
>>  	pr_err("GHCB (GPA=%016llx):\n", svm->vmcb->control.ghcb_gpa);
>>  	pr_err("%-20s%016llx is_valid: %u\n", "sw_exit_code",
>> -	       ghcb->save.sw_exit_code, ghcb_sw_exit_code_is_valid(ghcb));
>> +	       kvm_ghcb_get_sw_exit_code(control), kvm_ghcb_sw_exit_code_is_valid(svm));
>>  	pr_err("%-20s%016llx is_valid: %u\n", "sw_exit_info_1",
>> -	       ghcb->save.sw_exit_info_1, ghcb_sw_exit_info_1_is_valid(ghcb));
>> +	       control->exit_info_1, kvm_ghcb_sw_exit_info_1_is_valid(svm));
>>  	pr_err("%-20s%016llx is_valid: %u\n", "sw_exit_info_2",
>> -	       ghcb->save.sw_exit_info_2, ghcb_sw_exit_info_2_is_valid(ghcb));
>> +	       control->exit_info_2, kvm_ghcb_sw_exit_info_2_is_valid(svm));
>>  	pr_err("%-20s%016llx is_valid: %u\n", "sw_scratch",
>> -	       ghcb->save.sw_scratch, ghcb_sw_scratch_is_valid(ghcb));
>> -	pr_err("%-20s%*pb\n", "valid_bitmap", nbits, ghcb->save.valid_bitmap);
>> +	       svm->sev_es.sw_scratch, kvm_ghcb_sw_scratch_is_valid(svm));
>> +	pr_err("%-20s%*pb\n", "valid_bitmap", nbits, svm->sev_es.valid_bitmap);
>>  }

