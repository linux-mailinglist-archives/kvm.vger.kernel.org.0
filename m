Return-Path: <kvm+bounces-39592-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 286A5A482CA
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 16:22:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0478B18900A5
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 15:19:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3B8C26AABB;
	Thu, 27 Feb 2025 15:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="YpDpVrLl"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2042.outbound.protection.outlook.com [40.107.243.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BA1526A1B7;
	Thu, 27 Feb 2025 15:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740669526; cv=fail; b=dJtS1Xr4m2PH6GlzhSPs/jZ9zBrsDVl5Kqre4u2lRKRFIhKGx+gWacKRUzlWxhpCyERms1qdHycvA0AgxoVAfSNU6NFbUSR7JJ+LtDLUq8PPZI3HppXSZwnZBFvqYz8n0BftPqZwo3P+SisN11R6ABuwCoQy19HFg1eWotUT8HQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740669526; c=relaxed/simple;
	bh=5iGSWvZMjltLiuuYS1bz1RX00pi0lotfNmeXjYZ6ens=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=bchkQ3TtBCt6eU58jg0oe75592YnAuqJDOVGw3D30qsMD5qGbEAev3GPAvD1jZ7iczZyU/wCVME8VyldmLxpwFnf4zl4Fga6dZU9r8bNWbBmoDvu8bY50acdAt2LLQHvkYfSnSwjF5Nm6IdcGL7TS3PLgFwnx8krMQhHeoJcTvg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=YpDpVrLl; arc=fail smtp.client-ip=40.107.243.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RdYi4e7uc9RQnb7utYFXcLpbLVrfJ1CCrb451bMneuVwDMG/0XXN8iZ6vW3SNtTLc8a3G9H4dclqUAMX0t9yMDkSaRA2WtQSt7cXqKOLt389V1XyR5+/7SD2XpFiH+zZ2wPK/ic989TzXcSmsBZivpXE5LshYU2eTvNeQEUzPCj8VXiODPuWZ+4JT14cqf7TJl8/0LsxM5vcceDIhwOhFL0nIALPUOmqsLH096aHy5zlclvfYTKcgfnBLTMOL668ftxKQJtGZRJayuaonA0dA4Vdwabg2HalmTP7OHl8tN6EJ+lKvkXWMlTkHFu1PxHN/szmvGnva1Vahc9AsOjWkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VnqDZtoYGZBCyeDo1PxzywG33zkobpBrX3771U4ByJI=;
 b=O1xPrF9urjybSL4GW5la4IQRRmYhAvwRkMuK29kB+C9DTtvsXii9KZ3jP28ZyucM3YWtM4OjJ7sqNQmX2hsEUkorxscFqfE9D69zUbz/X1tHdHLsf+1GrxSluCLjey+bG4/rJXdKiTvBw6sXaXCpNzCSTsHyMHAoVaCwsM9vQkxO5K692sw0+vKh1P9dZ9fxMHm4qCxIRkPghB0W1vTZJFWLV5/AQnePQCkfp2tDUUw0+3VouvR7GcTNhe/N/hS4fTfkEuJnrZL9a5nGbhnfOrlxL+E1yPQiycTNhAirYgmMpzJhthwPTKTZCwgr2zChgaDPeiN4G1EKduemOyc85A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VnqDZtoYGZBCyeDo1PxzywG33zkobpBrX3771U4ByJI=;
 b=YpDpVrLlYhOuiz/+K9vQQ1zCSKB/RxuIOxCLK9PqDuBS81eznB1q7g23ULKVPVKdKCPUhxNv7n4a46LYlUv6lrf2OxUh1xHwLPGSk+LIuPFrpeHQdzBTDG0fJrrjVV1hlESWsfMTu7aQx5jtgrmn56S5/6H2a3oeAYq0Wa/Zj7Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA1PR12MB8189.namprd12.prod.outlook.com (2603:10b6:208:3f0::13)
 by SJ2PR12MB7941.namprd12.prod.outlook.com (2603:10b6:a03:4d3::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.20; Thu, 27 Feb
 2025 15:18:40 +0000
Received: from IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::193b:bbfd:9894:dc48]) by IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::193b:bbfd:9894:dc48%7]) with mapi id 15.20.8489.021; Thu, 27 Feb 2025
 15:18:40 +0000
Message-ID: <f59991ed-e24d-4bf4-8739-b314327ca1d3@amd.com>
Date: Thu, 27 Feb 2025 16:18:26 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 05/10] KVM: SVM: Require AP's "requested" SEV_FEATURES
 to match KVM's view
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Naveen N Rao <naveen@kernel.org>,
 Kim Phillips <kim.phillips@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>,
 Alexey Kardashevskiy <aik@amd.com>
References: <20250227012541.3234589-1-seanjc@google.com>
 <20250227012541.3234589-6-seanjc@google.com>
 <4443bdf2-c8ea-4245-a23f-bb561c7e734e@amd.com> <Z8B3x7EPYY8j8o7F@google.com>
Content-Language: en-US
From: "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <Z8B3x7EPYY8j8o7F@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FRYP281CA0005.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::15)
 To IA1PR12MB8189.namprd12.prod.outlook.com (2603:10b6:208:3f0::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR12MB8189:EE_|SJ2PR12MB7941:EE_
X-MS-Office365-Filtering-Correlation-Id: a2e4d2d5-fdaf-4da8-6ca6-08dd57420432
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MkpOaHhNd2l0cG1kYTNmWGkyZzB6ZlJwR2xsaUhtdmlOeUlCY2xoazJTVTJv?=
 =?utf-8?B?YWt5aTcwVUpCMnlOR0NlaWh0cnlWUmw0eGI3R0hZSHQ0V1V0UytOa1I0WS8x?=
 =?utf-8?B?bDZhWi8wTDc3NjRxN3R0WW1DTWVNT1pSL2dFVXozYTFCM0MvazJhRStpczI1?=
 =?utf-8?B?YWpYcTBwQTFDRCtMblhTMnZSa2NmclZCRjNXbWFpbUgydzRyRkFrRWViWnl5?=
 =?utf-8?B?bVYrL3ZoN1V2eFduSjV3N1U1c0JTL0pKKzRIbVhtZWYxTE9Yays4UzZ5T09Y?=
 =?utf-8?B?ODc1dENra3lsWmRENnRHeHdQcUljbmNmcGJWc2ZKVlZMa2dQZzFhWGRuY1dW?=
 =?utf-8?B?S0psRzlGcnkzdVFXUThEaUJOcDRJT0k4VTl1WVBZYkFZSFpaMWZtZTJVd3dK?=
 =?utf-8?B?OC84SjdmbzhNK2ZNaUxkb1pibXdYbkgyN011S0ZsbVV4YWdtOXUvWXorYkFv?=
 =?utf-8?B?ellJYXZrYmU5Qjc1Z0wzdzdXNFRyb0t1elBpMDVTS3JBcXZLSitFZUtyazdX?=
 =?utf-8?B?b0FseWdNdHFjQlFXeWhsUnBtTUF5K21vaUdXOEpKOFRiUTIxLzB6cU1wK1JI?=
 =?utf-8?B?L3VlUjBiQ2RMVEhVQmpBYzRQZjB6TEtDSHY3dFYweXk4d2g4ZGtjbHVWVWFS?=
 =?utf-8?B?OHFGZXdrOUxVMHJvSnl2cERUdFV3MGQ4cVNSZ2Z5Wk04dnhFVU02L3BVNDcx?=
 =?utf-8?B?a1FhN1hWUFpBSUhtRVhZckZuTW1XUzNhY0FKMFlJakRydmV5T1JQeFVvMFRj?=
 =?utf-8?B?OFJLQ1JnYndHSEd6SG5kTXBYTjkrWEdBZStFb3E0U3VQZDN3ZjJrTDNBTXo4?=
 =?utf-8?B?UnZDMkNOUmpudWtUdFJuK2hiV3VwWHNUWWRMSzZmTkdDNkFlTHZ4NEtHZStL?=
 =?utf-8?B?dWdzdDZjQjBMTUxzandjRlFBYzFic2h3RHNJS1k4VHhIaWVRMEcydjR2Q2Ev?=
 =?utf-8?B?dTBvUFNSbm9udG45bm1tZjJzNUk5T0FpZkE1MzNVV3NDZThCOW1yMFJ5eG1G?=
 =?utf-8?B?QWF2ZGlnbS94MEVsQ1EyTXBiSWdsVC9yTERic1ZyY0FlWHVEaHdsSnNuWXBx?=
 =?utf-8?B?OUkrcDRNdEJXNzhrQXd2ZHo1dm0wcEsvRmR3Y1RBNzhmTG9WQnlzeUlteVYv?=
 =?utf-8?B?eWExQTkyb3JwU1p3Qzh6a3lMelhWQmozWThMQ2p2SWgreFFwKzd5SHBLRU1z?=
 =?utf-8?B?UlFKcUh1bG5MY2dkVkM3NlkyUjlZSGFQNE9IcFlFSXFQUHJsWlV1ajZWQkJR?=
 =?utf-8?B?STRoOFVYb2dyTjRWSWsxajVMNXAyR3hhV3Nyck9VRDdNWVRYbU5GdU5lYTlK?=
 =?utf-8?B?NjJsbVhxaUF2OTl1M1BKa3d3eHc1NHlYb05wOVNaYm9kcFdCUGhmQmJqZzJr?=
 =?utf-8?B?UlFwb2NTVVoxcGVDb2cxM2dHck0xNFRHRW0xKzhFVWgwb0NFZEl1ZU96cDhm?=
 =?utf-8?B?WlhSWDlhUmUyTk9nYWpDTWJZVmZKQUdDWEQ0UWtTVXI2OEJoakJOdDhWVlFG?=
 =?utf-8?B?T1pwUXdTTGRobkdsWDFDanFnNE0xNUw2Y1JpK3dibmpLaXdxTGk5dC9PM0NN?=
 =?utf-8?B?aElWRHNzN2lBanRyT0F0cThodUkyakNycjh2c0VLdTZtdzZUcjBtNWpKT243?=
 =?utf-8?B?NGxiaWFTRzhPVXdvWVF2TERJV0tvbkczY1R5NkEwc1JHeG11T2lUOHRCMlc3?=
 =?utf-8?B?TmtzdElESHpwblcwQ1ZNeXBwenNXM21uUEhNN0o4MnJDcm0yOGxKUHc3eG96?=
 =?utf-8?B?UWFid1dnVFRoQ1lzY2pjTTFaQ09FL1lSZjNSRy90MmlGbVNZaWlkd015S2Nj?=
 =?utf-8?B?L0lqdXcyaGFocDl3Uy8vTzUweC95cjFVcmczcUFoNkdsSG11MGJieFM1OEpI?=
 =?utf-8?Q?ykHGKeDTUDQjO?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB8189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZFVYM3UyR2h0elRnSTAvRWZEV09LajBZUkxHaHR4eGQ5NG5RTFRPNUxmNUFQ?=
 =?utf-8?B?aDZOcjBNWmdNQ1VCSWk4TXBBVlUvRlNnMHZQcnArVE1uUXpWbER4bEk5clNn?=
 =?utf-8?B?RE9YbEk2WEZUTE0wNlJsTzAwMEw5QythUUFXazhHNWN2TytSUkdRQi9BY2o4?=
 =?utf-8?B?YUZxc3hMUklrVGdPa0xldkdzdjBrbjF5UjltYWJTekZLMHRBLzRjT3VSRmxT?=
 =?utf-8?B?YWJtcTVpenZIYWRmbFJGUCs4OVYrNThabHhrTWFNeDIzbStza0wzQktMQ09L?=
 =?utf-8?B?VVlEMjI1SU4xYnZUdWhJSTljMGQyRTI5WmtEQWE4KzJuazNReUxUOHFBK3NJ?=
 =?utf-8?B?ZnU5U3ovc29hdGw4eVNCWEZicjZNeDlMZDRXU0pZSjF1UTZzaXZtWjZIMXNk?=
 =?utf-8?B?Ymk0ekpNQTRQOTNsYy8yVllIYzJjVjZZOTdPME9yQXVONnc2cEovZFQzdHl3?=
 =?utf-8?B?VmlEdW5zeE9xbVNBcmt5RGNmdkxZNVVjK093Y0pDMFQ1dWJEWjNUeE04MEdh?=
 =?utf-8?B?L0ltTGJRUjZoWDdDajBxR3B3RVYxdndwaXhQM3RMZE5rbHdDaFZnQnNjbFo5?=
 =?utf-8?B?ZGowMTE4QkVwT3VIL1U1M0lMcFNXSC9KdERnRVJnSVI0UldMNVFLem0vellx?=
 =?utf-8?B?ODY3OGFwWWYrTVM0enhZcjdQckdYVjFqUzZXekFUZ291RlNDZ005RUNQN0w0?=
 =?utf-8?B?a1lkeTVnUW1WVzIyeHgyVndQNEZkV051cU1mTFRSL2pXUklXRmZuWG80bTN5?=
 =?utf-8?B?RnRUYUpsYWg5UlhIcjFweTk4ZGcyRERVZU9zR0pQOFp0ZzFkMXlDZFpaU1VH?=
 =?utf-8?B?UUF6VC9IbTF0Rmd6TWw5Z0cxdXlSRHV5RVNsS0RkcFFlaGFpbHBNbmdOOCtB?=
 =?utf-8?B?REViRm9LbTIxQVBCT2lYMWNJTEl6OHB5NC9wMjZvVWJoaXZKWlU0SFRnZWlX?=
 =?utf-8?B?UUxJZGVxaEM4UG9oWHN6bUZHSzNkM1lYcnA2YkV1OGpZRmt4alM5MUlKSHRJ?=
 =?utf-8?B?M2phSE55NVNvYUp2VG1jaHZwb25PZkRHUkl4YWpVTlhkYWg0VzlCMXhad2VQ?=
 =?utf-8?B?eTdaeGtsZngwZyt4ZnRGUlBpZm1kNkRDWmtBazhjakk1bVptVnNIV2dUMUl0?=
 =?utf-8?B?dUhNOElDc1gwUEt2Q3Byc3lUTDdIN05Ea3djeTd5UnhBNU9oQUZXWGl1M2Z5?=
 =?utf-8?B?ZTA1dGphb2IxQnpKYWp6cHMyb2NQSlIweXZnclFENVJ2NUhhaTZBZFI5MjU3?=
 =?utf-8?B?MGxDdjZ4aFJJbU1wRE1IQ092NERBL1VyaC9FVjFrTmVpYTFGYlVJNHp2cjZW?=
 =?utf-8?B?V0xyM1M2QkpZWnIzWHgrRnB1RVRzcVd4S2xYU3dkKzA1UVJxUFFYaWtSYnNp?=
 =?utf-8?B?T1lIcmV2MStSTkJRaG1TM3pkZXFRU2FwdCtsRjI4QlRvOENvQ0ZsbThaOUE5?=
 =?utf-8?B?ekxuZUZrTTlVZFQ5aWdiRHZqVXdLWjJPRzN4NEFsTlVNRDVxL1lMd0kvOEhp?=
 =?utf-8?B?Nll2OHpMM2E1aEZSeEhFYmpPRUJzVEx0NHVUU3BKclpCam0rNHczT2RNQytN?=
 =?utf-8?B?V2plNXUwR3ZjVVhEN3J2THllRVR3TlNzaTV3SWhqbUN0VGdycDNNUng0bUZo?=
 =?utf-8?B?eWxnUVBIQ1dpUTZmSS9tSnhHeDVqc2RMR2tFZlpESlZ5QjVEQjlBTVdzZGJ6?=
 =?utf-8?B?bEdQRFk4ZENidmNFRWxmb0N5eUpEVlBoc3JqdDh3dUxab2tXdGpacEZBSjJJ?=
 =?utf-8?B?SmhkTnBoL2ZhaGZJVFJrckVDcmtnb0pCYzZkS2FvNDJqTHY4TExWNlliaGZE?=
 =?utf-8?B?Y3ZNWkZ3cWZHTkVXcUVMZkJMdjc2OEZpcnlyQktOR3Y5aS80Q1dIcUZWd2tX?=
 =?utf-8?B?VGYyMjNRYzVDQkZ3eXdQQ01ETGcrUEt2eEIyZzdWREJQZ2ZleUZYUHlBdFdz?=
 =?utf-8?B?bkxCZ0h5ZW5ZOEN5RHE5RXl5UTR0c3FFaHVsMHI5K3I4M1pYSW1WaGdmRDRF?=
 =?utf-8?B?Zk9ZMlV4bjNITGYrWGRmK0FZM0ZNQm1kMXE1ZFk0UnRPVzUwMXFsMzE1WDRO?=
 =?utf-8?B?NmV0UWlRaFJ2SmtZUUlnT2ViYi9NWDA3N3FETHpFZXZSckJDNEJBK0JwL0ha?=
 =?utf-8?Q?2e3BmtbNmbXTiMy6EnME/PKwF?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2e4d2d5-fdaf-4da8-6ca6-08dd57420432
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB8189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2025 15:18:40.8101
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X5QLot4HkluP0iLz3XXmbFbyMVR5W0bUoZ/xK+0zR73j3TntPtDx+KT/n7ipoKmE2PmoI2gmYkfugBV7VxzRxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7941


>>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>>> index 9aad0dae3a80..bad5834ec143 100644
>>> --- a/arch/x86/kvm/svm/sev.c
>>> +++ b/arch/x86/kvm/svm/sev.c
>>> @@ -3932,6 +3932,7 @@ void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu)
>>>    static int sev_snp_ap_creation(struct vcpu_svm *svm)
>>>    {
>>> +	struct kvm_sev_info *sev = to_kvm_sev_info(svm->vcpu.kvm);
>>>    	struct kvm_vcpu *vcpu = &svm->vcpu;
>>>    	struct kvm_vcpu *target_vcpu;
>>>    	struct vcpu_svm *target_svm;
>>> @@ -3963,26 +3964,18 @@ static int sev_snp_ap_creation(struct vcpu_svm *svm)
>>>    	mutex_lock(&target_svm->sev_es.snp_vmsa_mutex);
>>> -	/* Interrupt injection mode shouldn't change for AP creation */
>>> -	if (request < SVM_VMGEXIT_AP_DESTROY) {
>>> -		u64 sev_features;
>>> -
>>> -		sev_features = vcpu->arch.regs[VCPU_REGS_RAX];
>>> -		sev_features ^= to_kvm_sev_info(svm->vcpu.kvm)->vmsa_features;
>>> -
>>> -		if (sev_features & SVM_SEV_FEAT_INT_INJ_MODES) {
>>
>> 'SVM_SEV_FEAT_INT_INJ_MODES' would even be required in any future use-case,
>> maybe?
> 
> Can you elaborate?  I don't quite follow what you're suggesting.

SVM_SEV_FEAT_INT_INJ_MODES macro is not used anymore? If there is no 
plan to use it, maybe we can remove that as well?

Or I am missing something.

Thanks,
Pankaj

