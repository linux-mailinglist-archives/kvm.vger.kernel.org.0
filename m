Return-Path: <kvm+bounces-49300-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1ECC4AD782D
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 18:28:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 79D563A42B4
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 16:23:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7065729A323;
	Thu, 12 Jun 2025 16:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="r4rjZc/z"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2085.outbound.protection.outlook.com [40.107.243.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA5DF4C85;
	Thu, 12 Jun 2025 16:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749745446; cv=fail; b=gGUC18gUNHdEUhq3+1ifTKDgytKvCWJawQGk6fYjbn571YDD6//U2e641YiS04uR66ozK4ZnMwgEdw41tsiSO3abc1rPeSg7uKSspSDpAoSPi60FFWMpDNqsiFuZ2FjOIyrYKPadOYMssltomVAmDlftcP7YF2ktElmDkRvetcM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749745446; c=relaxed/simple;
	bh=tUQi6tR2d+D7jwW1nQCHgAUmdM/yV3ZYPaJUI3TNeJc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=IEvSILWBpMDxtjel1HLFDTELAro98R7Qor+EHq3/1CKcJ4cfe8e3z22mafl18w1h7JWQOFfa3ylPoZE9LN7v9LCe1uWvRGiaF26ZjjyVeWl/GZRw915Qrz9ADQtvQIJQfXFyjX2T2lmhdckeE3liHPa5FSc3EgCiXRoGzufBa2I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=r4rjZc/z; arc=fail smtp.client-ip=40.107.243.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PxraR7Xq6KXVpkczpSAEsBghwYJApoyNmdP4+YCX21DAJtWFW6+vALEQW+pbwHSA2H2vmbtfWXq1MdWpi0NcNIUNSVFVwAC2iG8Te17fQEYFEYr+AwU945AS6XxVV7f0CiXWi80wVJ5ilYaA5LmDeyTq/Tc+vastVLrDq2gLn8W6YyK7fcVepwfOmlJZDxmiD3S+pw/YgavM0PfnJTdg/Rh0aq1kqbXrRdN5w010mHSAZRp11k9O3UtU+haDallqwJ+Mur0zfCEJ/NfhGtIe5saYqBZrhDMnZqUaELjEZNvJUFLkHa+kGRgczaprYQwmBu+0iSLyfZO/u4zcw3bwPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AW3QTv89T0pY5c8QQp+6wuc/JM5XdOdoZosX7Q4/zkM=;
 b=WpwiqkU6iseniUG0v/KtVSR5GDUY2hsl7xu/0FHnj/XRuXD0s1s3vk0iM3gx2XNUtW0yDj8Af/KGtK+rFEM4UnV6XjbIQxX5mUjSNVwsWVL4M1SBSA2KvGXYihBbzhNdoSvLaoD4tbShgfqwtAaQO/cyMp3jmJqtC3mhXGdsRTuwn6nyBhf7q/LGPpkN+eQj1QsSVDelAAoZBMX8Fb+UQJ5E/QmnCjoXcqM8qglpnq/KBNwKLd3mog30iKpU2SUSApSHCX4A3tSTDM9PjI7zFAkZq+tf613hZpLZ5sX4COSnGdQ3wW5iqht1chQTb/MLc97Xlp8Ys5yErADjn2+Vdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AW3QTv89T0pY5c8QQp+6wuc/JM5XdOdoZosX7Q4/zkM=;
 b=r4rjZc/zrghM9hihMrL4ihZxm/fWgBLOrdMPH5jfinvY48wALAwUIzgYeFr1UDb7aLQxA7QgrAb35nes+XkM0kLmC7KnZ8XGG34HNuP6Zur/PaZI2dAWWZk2BErBwpeWSp78GaHFd0/kSKlWwLsYZl9D358LYONgBY7vKholtV4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH2PR12MB4262.namprd12.prod.outlook.com (2603:10b6:610:af::8)
 by CH0PR12MB8506.namprd12.prod.outlook.com (2603:10b6:610:18a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.23; Thu, 12 Jun
 2025 16:23:59 +0000
Received: from CH2PR12MB4262.namprd12.prod.outlook.com
 ([fe80::3bdb:bf3d:8bde:7870]) by CH2PR12MB4262.namprd12.prod.outlook.com
 ([fe80::3bdb:bf3d:8bde:7870%5]) with mapi id 15.20.8813.024; Thu, 12 Jun 2025
 16:23:59 +0000
Message-ID: <478daa8c-90de-46c1-854e-ea6b3a2470d6@amd.com>
Date: Thu, 12 Jun 2025 21:53:36 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 18/18] KVM: selftests: guest_memfd mmap() test when
 mapping is allowed
To: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk,
 brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
 xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com,
 jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com,
 isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz,
 vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name,
 david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com,
 liam.merwick@oracle.com, isaku.yamahata@gmail.com,
 kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com,
 steven.price@arm.com, quic_eberman@quicinc.com, quic_mnalajal@quicinc.com,
 quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com,
 quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com,
 quic_pheragu@quicinc.com, catalin.marinas@arm.com, james.morse@arm.com,
 yuzenghui@huawei.com, oliver.upton@linux.dev, maz@kernel.org,
 will@kernel.org, qperret@google.com, keirf@google.com, roypat@amazon.co.uk,
 shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, rientjes@google.com,
 jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com,
 ira.weiny@intel.com
References: <20250611133330.1514028-1-tabba@google.com>
 <20250611133330.1514028-19-tabba@google.com>
Content-Language: en-US
From: Shivank Garg <shivankg@amd.com>
In-Reply-To: <20250611133330.1514028-19-tabba@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0059.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:22::34) To CH2PR12MB4262.namprd12.prod.outlook.com
 (2603:10b6:610:af::8)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR12MB4262:EE_|CH0PR12MB8506:EE_
X-MS-Office365-Filtering-Correlation-Id: 600d38dc-4990-4a32-ddfd-08dda9cd8944
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QThPR2JMQkFJdlloalNrLzRrMmlJeHdPcW90anExdmlhTTczSVN3ZmJSU3kr?=
 =?utf-8?B?b1p2VjN6QnRUODkwZ2FJOXRuc1k4Y21hVXJJZ1dxNHlFWHBKbDYrTGlBTnE2?=
 =?utf-8?B?ZnA5bUlxaWV4cnNSZ1B0S25Mc0J1ekxKQS9rbXI1c3JrVXNjTHhPd2l4UEto?=
 =?utf-8?B?RVptQ2J2cEw0ZDByK1RqcERTNWJWSGlEakN0OTBOT21FUmZjUjlQZzdCbG5Z?=
 =?utf-8?B?VkJyTXRabSthbEtxZjM3dlUxdFkwZDRjVWQxTDFCR1o1Q28vcHdsNTYyNjdX?=
 =?utf-8?B?R1AzMHpjU3lCbjA5YzNZRExtdmt3KzM1dDErYXB4TTQyZjB0TC9GMW1WYjRw?=
 =?utf-8?B?djVFN01rb1lrcVh5M2NmZWxGMWxmbkNuS2owRXJUVjdZZHNlZW5SdXg4Y0pL?=
 =?utf-8?B?blBKMFJUVXFvanJDU3BEaUMvbTFKWjVLQVRTM2pYZzM4NDc4OUUwMGN3WFMx?=
 =?utf-8?B?SUg3bTRJYTgyZGh4bGxsSG8xOVczVDJ4VzdnaG5CQ2JNQm13ckNic0ZtbGU5?=
 =?utf-8?B?V0hORE1RM29PNTF6TFB5OE5oUWVEejBTSXNJZUlycXlORVg2ZVNYVHJsSTNF?=
 =?utf-8?B?MnRBMW5adlJvV290ZzdwZnp6Qi9ncmFQaE4vUmtDTVlLaHVYL25vTVFvdGpZ?=
 =?utf-8?B?TndoNVk4MGVpemFsS0F6Y0YySU9QMlMyV1FtMTlXWEE3eTFRaE5NczZ6eVlm?=
 =?utf-8?B?dmRJdzJ3dHhhMC9ZUy81UU1VREE5M3MxUktJWjd5MjF4UTJMZUNvL3kzUnhw?=
 =?utf-8?B?V1hmbUlRbWM2MVZ4ZFZGZE50VCtTRUlDbG1oL29tTDJJWXR1MlMxVktzTks1?=
 =?utf-8?B?SVkwRjhpMjIvMXMwM1NidENPMGROdDNIcUY2YTlkZ1NyTU1xdm5PS2NOMFh0?=
 =?utf-8?B?czdZL1FQRW03d3NTY01OenVSSGY1Rm1WekdqdE15a2VTMllrWjRySTgycE5u?=
 =?utf-8?B?UE8zR0JlOXNqR284ME1tVnVUZmdteUhUazJ0YzZnNGFzZzIrZDNHUmxKQWFu?=
 =?utf-8?B?N2U0Y3g4TXN6dXp5MS9ETlBYTlNFYXVlZ0kvVUlFKzlpT1lPdm15Mk9QZkNa?=
 =?utf-8?B?YWt0cFRZRmdHVlFOSDZtMm43a2w1cnhsK25zYloxSVV1R0V6UkVsU3MyK1JW?=
 =?utf-8?B?NE1iMGpzL0UrOUVEc0o0YWJIQXBnaWNzRFdjZnpKZDhQSUV4MzZJVWZyV0dS?=
 =?utf-8?B?Q2pxS3EwdndBWXJXZ2k3MUFtTFBsM2tzYkRQNGxoZk1UZzZWb2w2NmJTb1U3?=
 =?utf-8?B?bDRwdFV3WU5iRC81WWVaNmJwVm1xZWs1UE1lajdaYlpUUUk3UmorRllCeFF0?=
 =?utf-8?B?WXRvN0VkR0RpaHFjbTZhVnVaNUVFUGNneG1uZSszem9zL0kzRnAvOVV1ZnNu?=
 =?utf-8?B?NEVBVzAwUGtvYmkwVjNPaXFXaUZiWUM2WnQ4bThyd3J5L2lMUU9wUnhTVWxB?=
 =?utf-8?B?VGV4YVYyeDRlTHdNVHBwUFlYY3lCWnpnaTJOMTF6QnVJL0FWTEw0b0ptb0Nz?=
 =?utf-8?B?dVFobnBoZTFzY0tPOHNTSkMvQWJzZVlBakErNlZTTXloTkdTTGp5Q3owMzJH?=
 =?utf-8?B?c3AxclovdUpVY2NIWTU4emVIaXF4VmdOQVVkc1o3enhEWWY0WThYSDNYTW1z?=
 =?utf-8?B?cHYxaGZmQXRZV2dsWGlRU1RWbi9aT2V3Q0cwNEdiQ2Z2a1IwTVk5UnpNT0Ey?=
 =?utf-8?B?dDhmK2gyQVBrMEdxbi8zTkxsdm1lUmRlZXFEM241Z0RQaUE0MW05c0ZpV2du?=
 =?utf-8?B?cWtzdjM3MnVhbVZ6MHFOYjJPUW9iOGZ6M2h2SU5rb1JBN1NLYXAyYkhoOUlW?=
 =?utf-8?B?RVF2Q0p4MzFYMzhSTjU1ZmJiaS9vSm5NV0s1eVBNRXR4YTdJZHM2S3RpeGht?=
 =?utf-8?B?cEZpZCtDQTYxTGszTVdUeTFQZk5iSnFUOEY3T1JrNDJxVTZJNzYreU5XV1pm?=
 =?utf-8?Q?1ZoGDXWUrvM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB4262.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RXVHNW1hQWdSUVNUYVdpOTEyREJPSlVDcUwydGRvZEV6a3F3UDhxU0ZEa2o5?=
 =?utf-8?B?bk5wY091L3R2eGVRSnBMSlNrZ0w0L2RQSG1KQlB5STJ3QjI3RjVpK1dpc3dw?=
 =?utf-8?B?WkhVVEJacFFwZkVsekt3MEdESXNjb0Q0MkVtSmRuZW5XMm0xWkdHQ0hkM0Fx?=
 =?utf-8?B?c1ZWNDRwVHJRUmlZYW5LUktmUU1wdEFZU1djYXVqeFltaS84d1ZyTnpHcHJB?=
 =?utf-8?B?b2xUMkVqU2kwN040bWZuRjlVQjhvUHZNYzQ3Z3ZCSEJEUXViRWV2T0VhTjBz?=
 =?utf-8?B?eXhIZERKM2J0OGg4V2JBMFY5WTNabS81RDRSNTRlV1BPbEF1d01pWUJSQTda?=
 =?utf-8?B?WVByTXJlZmZaM05CRVFXWm5ob0htTnlMdUIzdU4ydkV0MVltOS9QUzVyZk92?=
 =?utf-8?B?VDBVUC92UnJTVWkwNnVVOGRvcGZzUkZHYUJrVE9mK3p6eGlLMmlnRTBxeTJw?=
 =?utf-8?B?Wml6aDVCc2dxRGpZTHpYV1pJRDJtY2wyNVREMTRBYi9oUXluczRJalVUNUtD?=
 =?utf-8?B?YTVqSlhVL1MrZ3Y3ZDY0Wmx0Rlh5NEI1VythcXhMWlJUVlpESVhCK0hTMisw?=
 =?utf-8?B?RDd3bnRWcGE3NzNtaFFVSE9NWDIrRnUvK2ZzejdDUVljcThBcEFOV2IwaDM4?=
 =?utf-8?B?Z2pCZHQ4a1A1SG04WWFYWFZ5Q1Ryd0RMdkFweDYxZXJzaHducW1kdUgwUThZ?=
 =?utf-8?B?WkxsTWNNNWoxVDJpakFWalUzTlVwYlQ2TGVzSi9GYnBCTmQrNVp0T0ZFSGpr?=
 =?utf-8?B?Y29BeC9jNitwQ3JkdVlKbm1hUWYyekZlb0R4SEE1MExVSlRDekwxOWZ0eEdR?=
 =?utf-8?B?dFpJclJOeHdDYUFwRHdmVEtiRHduOUNCaGo2eGpUdnluZ3pqd3gvc1lnalpu?=
 =?utf-8?B?aUUybUFKV3Q0UVFMdGl2aE1MaFllZ3prOWZPZFovT0ZZU3UxL2trYWp4Qyta?=
 =?utf-8?B?SHcwdjNHdm9PVmwrOForN2VlSDZmR0EvdEVFbkFQSmVLLzVPNDZzZFoweHdJ?=
 =?utf-8?B?U1liOHMwYWI4QVRUeGN1TVZ3MGJ0dXZtRXJFWnpvaUxZV0JxLzRyMTNpWGVL?=
 =?utf-8?B?ZzZDSkYzNXgwMkZwYnU2QmNxNkhmRTBGTzVzUlVLdmI1MFcvZGkzZkxqVFpF?=
 =?utf-8?B?b3BXYm1Ea2VYcVhkc2EyTllzTkNYL2VmMkJvQVZ2VGtRdi9Gc0ppcmxVcHlO?=
 =?utf-8?B?VjRJV2hOSjhWZVQyVWR6UXJhaHVyWFU2YUhTUnpIMjFaWVl4ZTdoT2xYTnVw?=
 =?utf-8?B?MTFMN2dORDZlOWVjZXhWT0loRUNnVjQybE9vR0pMdTlLdjJGdmFPZzRIalVX?=
 =?utf-8?B?VjhBc3hUWWhmU0ZCaGFaQWp0aUZMNzIzYnFjTlZ3Ump2QkJnb24wSE9xa2Nj?=
 =?utf-8?B?bW90QkpYc1gvTnVkcjhqMGhJSUNhUlRWa0FRU0s1YWp4YzF5dzM3OUQwYkRt?=
 =?utf-8?B?ZTNiWG5mZzVBSHl0NlVLWFZtWXAvZmhvc0t1Z1FVQ0dlRkxUTlZkYWNNTDBi?=
 =?utf-8?B?SlovTjRVVk5EMkEya0ZqU040bmx1VW8rUWM2djdGajJncUQzZm5Nc0lKVGEz?=
 =?utf-8?B?WXVFNExGdXpWSW1wNUtXbEV5ejFqam1lWTBjOUN5WjNuejRoK3lUcXVnMUEx?=
 =?utf-8?B?ZE04TDBpRXU1TFJKcVB5ZHQrZFRMMlc2OXZjNmNmd0w5OU9ZV2x3S21ab0Vl?=
 =?utf-8?B?eHJHVkFCWDMzSzlIaFArVHNiaWpIRzltbXZsNVY0M1pBL0FGZFVaVzdaWFZx?=
 =?utf-8?B?V0NqcVlEa1JIZTFMK3NiM2hIVGpUMXJkQmFsOVhkbGFnVHlJZVhLcmM5KzhL?=
 =?utf-8?B?N0cybis4eWsrK1ZRaUNReFZ6RXZDNHFhMFlxcDY2eUpMNjlMaWZQMDFzRFdm?=
 =?utf-8?B?MDdRNk9UNHRhczQvTWFEdnUvaXdYOVBlTEZuVFFXbkFRK2xyaEQzRjN0RWY1?=
 =?utf-8?B?czA3SnFoSW4wRGY1UWpxd3pJcEJpbjFnb2hCb3lCZ0ZoVDZjK3ZjS1FEZWY2?=
 =?utf-8?B?bWZDZzRXL2Q4SDJyZGRxeER4emJCbWQ3VVZIRktXeXpVVS9MOXdkT2Nkc0FS?=
 =?utf-8?B?Tjh4RSswc2tnUjFmTDU1cHNzalZ2WjBIODYzQXVjU0hsNjRIbXF0NTlvMUdJ?=
 =?utf-8?Q?BEuaEfm4TXo0/keKdMXf6mnxP?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 600d38dc-4990-4a32-ddfd-08dda9cd8944
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4262.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2025 16:23:59.7090
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A9CyWr/SIKKqJjTmLfZtiZwhBRK88/hgLlGiPf4yZUp1K6uYu7YFQlwdw6i4oqrTvFzlnX9v28Hb2JNGD0ym3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB8506



On 6/11/2025 7:03 PM, Fuad Tabba wrote:
> Expand the guest_memfd selftests to include testing mapping guest
> memory for VM types that support it.
> 
> Reviewed-by: James Houghton <jthoughton@google.com>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Co-developed-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  .../testing/selftests/kvm/guest_memfd_test.c  | 201 ++++++++++++++++--
>  1 file changed, 180 insertions(+), 21 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
> index 341ba616cf55..5da2ed6277ac 100644
> --- a/tools/testing/selftests/kvm/guest_memfd_test.c
> +++ b/tools/testing/selftests/kvm/guest_memfd_test.c
> @@ -13,6 +13,8 @@
>  
>  #include <linux/bitmap.h>
>  #include <linux/falloc.h>
> +#include <setjmp.h>
> +#include <signal.h>
>  #include <sys/mman.h>
>  #include <sys/types.h>
>  #include <sys/stat.h>
> @@ -34,12 +36,83 @@ static void test_file_read_write(int fd)
>  		    "pwrite on a guest_mem fd should fail");
>  }
>  
> -static void test_mmap(int fd, size_t page_size)
> +static void test_mmap_supported(int fd, size_t page_size, size_t total_size)
> +{
> +	const char val = 0xaa;
> +	char *mem;
> +	size_t i;
> +	int ret;
> +
> +	mem = mmap(NULL, total_size, PROT_READ | PROT_WRITE, MAP_PRIVATE, fd, 0);
> +	TEST_ASSERT(mem == MAP_FAILED, "Copy-on-write not allowed by guest_memfd.");
> +
> +	mem = mmap(NULL, total_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
> +	TEST_ASSERT(mem != MAP_FAILED, "mmap() for shared guest memory should succeed.");
> +
> +	memset(mem, val, total_size);
> +	for (i = 0; i < total_size; i++)
> +		TEST_ASSERT_EQ(READ_ONCE(mem[i]), val);
> +
> +	ret = fallocate(fd, FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE, 0,
> +			page_size);
> +	TEST_ASSERT(!ret, "fallocate the first page should succeed.");
> +
> +	for (i = 0; i < page_size; i++)
> +		TEST_ASSERT_EQ(READ_ONCE(mem[i]), 0x00);
> +	for (; i < total_size; i++)
> +		TEST_ASSERT_EQ(READ_ONCE(mem[i]), val);
> +
> +	memset(mem, val, page_size);
> +	for (i = 0; i < total_size; i++)
> +		TEST_ASSERT_EQ(READ_ONCE(mem[i]), val);
> +
> +	ret = munmap(mem, total_size);
> +	TEST_ASSERT(!ret, "munmap() should succeed.");
> +}
> +
> +static sigjmp_buf jmpbuf;
> +void fault_sigbus_handler(int signum)
> +{
> +	siglongjmp(jmpbuf, 1);
> +}
> +
> +static void test_fault_overflow(int fd, size_t page_size, size_t total_size)
> +{
> +	struct sigaction sa_old, sa_new = {
> +		.sa_handler = fault_sigbus_handler,
> +	};
> +	size_t map_size = total_size * 4;
> +	const char val = 0xaa;
> +	char *mem;
> +	size_t i;
> +	int ret;
> +
> +	mem = mmap(NULL, map_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
> +	TEST_ASSERT(mem != MAP_FAILED, "mmap() for shared guest memory should succeed.");
> +
> +	sigaction(SIGBUS, &sa_new, &sa_old);
> +	if (sigsetjmp(jmpbuf, 1) == 0) {
> +		memset(mem, 0xaa, map_size);
> +		TEST_ASSERT(false, "memset() should have triggered SIGBUS.");
> +	}
> +	sigaction(SIGBUS, &sa_old, NULL);
> +
> +	for (i = 0; i < total_size; i++)
> +		TEST_ASSERT_EQ(READ_ONCE(mem[i]), val);
> +
> +	ret = munmap(mem, map_size);
> +	TEST_ASSERT(!ret, "munmap() should succeed.");
> +}
> +
> +static void test_mmap_not_supported(int fd, size_t page_size, size_t total_size)
>  {
>  	char *mem;
>  
>  	mem = mmap(NULL, page_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
>  	TEST_ASSERT_EQ(mem, MAP_FAILED);
> +
> +	mem = mmap(NULL, total_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
> +	TEST_ASSERT_EQ(mem, MAP_FAILED);
>  }
>  
>  static void test_file_size(int fd, size_t page_size, size_t total_size)
> @@ -120,26 +193,19 @@ static void test_invalid_punch_hole(int fd, size_t page_size, size_t total_size)
>  	}
>  }
>  
> -static void test_create_guest_memfd_invalid(struct kvm_vm *vm)
> +static void test_create_guest_memfd_invalid_sizes(struct kvm_vm *vm,
> +						  uint64_t guest_memfd_flags,
> +						  size_t page_size)
>  {
> -	size_t page_size = getpagesize();
> -	uint64_t flag;
>  	size_t size;
>  	int fd;
>  
>  	for (size = 1; size < page_size; size++) {
> -		fd = __vm_create_guest_memfd(vm, size, 0);
> -		TEST_ASSERT(fd == -1 && errno == EINVAL,
> +		fd = __vm_create_guest_memfd(vm, size, guest_memfd_flags);
> +		TEST_ASSERT(fd < 0 && errno == EINVAL,
>  			    "guest_memfd() with non-page-aligned page size '0x%lx' should fail with EINVAL",
>  			    size);
>  	}
> -
> -	for (flag = BIT(0); flag; flag <<= 1) {
> -		fd = __vm_create_guest_memfd(vm, page_size, flag);
> -		TEST_ASSERT(fd == -1 && errno == EINVAL,
> -			    "guest_memfd() with flag '0x%lx' should fail with EINVAL",
> -			    flag);
> -	}
>  }
>  
>  static void test_create_guest_memfd_multiple(struct kvm_vm *vm)
> @@ -171,30 +237,123 @@ static void test_create_guest_memfd_multiple(struct kvm_vm *vm)
>  	close(fd1);
>  }
>  
> -int main(int argc, char *argv[])
> +static bool check_vm_type(unsigned long vm_type)
>  {
> -	size_t page_size;
> +	/*
> +	 * Not all architectures support KVM_CAP_VM_TYPES. However, those that
> +	 * support guest_memfd have that support for the default VM type.
> +	 */
> +	if (vm_type == VM_TYPE_DEFAULT)
> +		return true;
> +
> +	return kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(vm_type);
> +}
> +
> +static void test_with_type(unsigned long vm_type, uint64_t guest_memfd_flags,
> +			   bool expect_mmap_allowed)
> +{
> +	struct kvm_vm *vm;
>  	size_t total_size;
> +	size_t page_size;
>  	int fd;
> -	struct kvm_vm *vm;
>  
> -	TEST_REQUIRE(kvm_has_cap(KVM_CAP_GUEST_MEMFD));
> +	if (!check_vm_type(vm_type))
> +		return;
>  
>  	page_size = getpagesize();
>  	total_size = page_size * 4;
>  
> -	vm = vm_create_barebones();
> +	vm = vm_create_barebones_type(vm_type);
>  
> -	test_create_guest_memfd_invalid(vm);
>  	test_create_guest_memfd_multiple(vm);
> +	test_create_guest_memfd_invalid_sizes(vm, guest_memfd_flags, page_size);
>  
> -	fd = vm_create_guest_memfd(vm, total_size, 0);
> +	fd = vm_create_guest_memfd(vm, total_size, guest_memfd_flags);
>  
>  	test_file_read_write(fd);
> -	test_mmap(fd, page_size);
> +
> +	if (expect_mmap_allowed) {
> +		test_mmap_supported(fd, page_size, total_size);
> +		test_fault_overflow(fd, page_size, total_size);
> +
> +	} else {
> +		test_mmap_not_supported(fd, page_size, total_size);
> +	}
> +
>  	test_file_size(fd, page_size, total_size);
>  	test_fallocate(fd, page_size, total_size);
>  	test_invalid_punch_hole(fd, page_size, total_size);
>  
>  	close(fd);
> +	kvm_vm_free(vm);
> +}
> +
> +static void test_vm_type_gmem_flag_validity(unsigned long vm_type,
> +					    uint64_t expected_valid_flags)
> +{
> +	size_t page_size = getpagesize();
> +	struct kvm_vm *vm;
> +	uint64_t flag = 0;
> +	int fd;
> +
> +	if (!check_vm_type(vm_type))
> +		return;
> +
> +	vm = vm_create_barebones_type(vm_type);
> +
> +	for (flag = BIT(0); flag; flag <<= 1) {
> +		fd = __vm_create_guest_memfd(vm, page_size, flag);
> +
> +		if (flag & expected_valid_flags) {
> +			TEST_ASSERT(fd >= 0,
> +				    "guest_memfd() with flag '0x%lx' should be valid",
> +				    flag);
> +			close(fd);
> +		} else {
> +			TEST_ASSERT(fd < 0 && errno == EINVAL,
> +				    "guest_memfd() with flag '0x%lx' should fail with EINVAL",
> +				    flag);
> +		}
> +	}
> +
> +	kvm_vm_free(vm);
> +}
> +
> +static void test_gmem_flag_validity(void)
> +{
> +	uint64_t non_coco_vm_valid_flags = 0;
> +
> +	if (kvm_has_cap(KVM_CAP_GMEM_SHARED_MEM))
> +		non_coco_vm_valid_flags = GUEST_MEMFD_FLAG_SUPPORT_SHARED;
> +
> +	test_vm_type_gmem_flag_validity(VM_TYPE_DEFAULT, non_coco_vm_valid_flags);
> +
> +#ifdef __x86_64__
> +	test_vm_type_gmem_flag_validity(KVM_X86_SW_PROTECTED_VM, non_coco_vm_valid_flags);
> +	test_vm_type_gmem_flag_validity(KVM_X86_SEV_VM, 0);
> +	test_vm_type_gmem_flag_validity(KVM_X86_SEV_ES_VM, 0);
> +	test_vm_type_gmem_flag_validity(KVM_X86_SNP_VM, 0);
> +	test_vm_type_gmem_flag_validity(KVM_X86_TDX_VM, 0);
> +#endif
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +	TEST_REQUIRE(kvm_has_cap(KVM_CAP_GUEST_MEMFD));
> +
> +	test_gmem_flag_validity();
> +
> +	test_with_type(VM_TYPE_DEFAULT, 0, false);
> +	if (kvm_has_cap(KVM_CAP_GMEM_SHARED_MEM)) {
> +		test_with_type(VM_TYPE_DEFAULT, GUEST_MEMFD_FLAG_SUPPORT_SHARED,
> +			       true);
> +	}
> +
> +#ifdef __x86_64__
> +	test_with_type(KVM_X86_SW_PROTECTED_VM, 0, false);
> +	if (kvm_has_cap(KVM_CAP_GMEM_SHARED_MEM)) {
> +		test_with_type(KVM_X86_SW_PROTECTED_VM,
> +			       GUEST_MEMFD_FLAG_SUPPORT_SHARED, true);
> +	}
> +#endif
>  }

Reviewed-by: Shivank Garg <shivankg@amd.com>

