Return-Path: <kvm+bounces-57399-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B6DDB54FCD
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 15:41:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DC071AA3464
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 13:40:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B78C30DEBB;
	Fri, 12 Sep 2025 13:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="UdRQoRb5"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2059.outbound.protection.outlook.com [40.107.101.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FA47283FDF
	for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 13:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757684454; cv=fail; b=EuCq+5Tb2NktMUkakBCKKyD7PlfSZ3p4rmUc/T5A6Zt+cpW/DXy/EZ6UKs3C/suTjHKORJbqn5u3Sn4KQQQTpouiPpV6HyIzFQQPGmnz2UIDHRhhLHRLJYHXqrHZKgRfTXzqe+zKDh+ZMUbG/C1HSzbkdNSbUNn6sGw1zmYGFn0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757684454; c=relaxed/simple;
	bh=i7mUslr54JfnkcXFnRZoDfoJ/mAnJaUQo26MIAfJ9nA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=iGkiE0gCbETDPuh8mR01zv7zBA/AggxYg5RTBkkL4ooSAPNB4df/ciT2nzVpry1d91rFq4GWgGjAnev2ilxmg+UZPHkkPY/WpdWYLUtO15VXjhk5jAi6mZweirpsDzMCMXZTORGBfP0tOrTYK6gFOw1vP0iEAugNAq4Jy+ZU6fM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=UdRQoRb5; arc=fail smtp.client-ip=40.107.101.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZcOSdIIm9391l+mL+NbuYiH9Hn0Tf+/fnx0r/30TfjqOtLwRcnzniWD7fzIAOmKvnds9CiYQPIdVU2MyNMQ7nVLOLwxNrLUM/IS4ccnSkSvPIWXINx7oYmhKCGIOxx+/w/gUZEXVD8OgIcbf8+rwCiZbgDEjXyhzSh3cPf0sYxzfcdX8OsqZ3L1a8zVshEvdezf4O0G3P22aVDpn7DUrod8dUwFjyJB9qNhw4Hamo7yj+z8qq1VdidlXuFPDHiS27Ywd/gOMvN8bSpNO3bisBKZbF2/1xUao/rq9TsSQvp5IODK83k2ylM/mxWTAYS/HALzJ8u5ACKXZIBvY68lfTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=izpDadd/IkIk9ppt/fEZ5WXWJ1qfat7cCsvFxnUDDgY=;
 b=d9VbDdaW96yW32rhNtsiyq5xmzJjfW8GLgrmJ96YZOiHP5wG5xqwcCMmixMLFxp02pfB8/HqQ66Tqc5TFUDmZdnCNcqkwG672KwjwaiDPAMnJ1tu98RjHn28MpmC3JJDd0c4z7VsXGyreIU0ri2lFwGCk3nOvLXHhFXKqZ9bzkgUztLhA8+sk+i36IquqsVwROHLVxZRMzJkjhPDDwSZCnL/PEz6jZceQ2RFVvz0NinXJTYL2qGEeAw39O5iNrYp0SP6/sXwwlFbNbOdx8K1qljn7thKBmu4Eoxq+MFkioPdT09E/tvAmb+T+xtvQCJ3AQgYEpE8xYsgk+ZeZYOqXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=izpDadd/IkIk9ppt/fEZ5WXWJ1qfat7cCsvFxnUDDgY=;
 b=UdRQoRb5kGnVYZXfSXdORX2SOn9SDon5Cb+6gWHwDmN0PvWwl6NsUH9BHnSfx4cCv3ZMCPGyYiBi+KKT8wQpj/3O5t/Akeh2cu21HeUhoSPYo3j9/00rfT87+Kslt2tVrFwXt1LDQpaiJk+lQHgvV9gGGBgNSh3mIHMiKn04HPY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by BN3PR12MB9595.namprd12.prod.outlook.com (2603:10b6:408:2cb::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.18; Fri, 12 Sep
 2025 13:40:46 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%3]) with mapi id 15.20.9094.021; Fri, 12 Sep 2025
 13:40:46 +0000
Message-ID: <24cafa98-697f-4243-9023-8a68f53ebf6b@amd.com>
Date: Fri, 12 Sep 2025 08:40:44 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/7] target/i386: SEV: Validate that SEV-ES is enabled
 when VMSA features are used
To: "Naveen N Rao (AMD)" <naveen@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: qemu-devel <qemu-devel@nongnu.org>, kvm@vger.kernel.org,
 "Daniel P. Berrange" <berrange@redhat.com>,
 Eduardo Habkost <eduardo@habkost.net>, Eric Blake <eblake@redhat.com>,
 Markus Armbruster <armbru@redhat.com>, Marcelo Tosatti
 <mtosatti@redhat.com>, Zhao Liu <zhao1.liu@intel.com>,
 Nikunj A Dadhania <nikunj@amd.com>, Michael Roth <michael.roth@amd.com>,
 Neeraj Upadhyay <neeraj.upadhyay@amd.com>,
 Roy Hopkins <roy.hopkins@randomman.co.uk>
References: <cover.1757589490.git.naveen@kernel.org>
 <75d491d24e39a6d95049868c56e4f2088ed48d6e.1757589490.git.naveen@kernel.org>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 vFkWitqCJg==
In-Reply-To: <75d491d24e39a6d95049868c56e4f2088ed48d6e.1757589490.git.naveen@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0078.namprd11.prod.outlook.com
 (2603:10b6:806:d2::23) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|BN3PR12MB9595:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a183128-fa8a-4730-732a-08ddf201fa33
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eUFjUkpDRllqS3A3eXEwUWZPK2M5UFl3OGtWclc5TkZDSFJBUVRjS293Nll5?=
 =?utf-8?B?RlpZVEZEVkNlNVBMNU9uQWgzdXRiWjRNNXFySzg0SzdtTHJyZDZyemlncmpX?=
 =?utf-8?B?ZFFFT0hkQ0Z3bkx4R1NBNU54TTdjWnZ6czBKc3N4aTFpUnNzVDZnU3ZkREN0?=
 =?utf-8?B?QnBPR1J1WjBSNHBJRmN4Y09CZmlhYjRkVlJrYjZleTVFQjYxd3ZscmhhekhR?=
 =?utf-8?B?SHQwTmFKZDdTU25nN2I4WmlJWDVnc3Jiam1TZmwyM2UvYlVXN09Ed1hTMFFQ?=
 =?utf-8?B?YWVSQnZiOVJQK2o2Z0JvWmdRaXBzcXoxQndjblNuTzJENHA2ZGJFczZ3Rk9P?=
 =?utf-8?B?elhVTjJPRjNJYnE2STNEaDFJdldxR0xEcjBtL3R6OWRVNVVOcmgyQzUrWG53?=
 =?utf-8?B?TmdHTk5UcGtWSTlhQnd1MUZOMXJSU2NIRGV1MWVMN0phZ2dQQ3NKWEpiL3FO?=
 =?utf-8?B?Tzh1V09LbHM3clFwTjVFazhZYXJ3WVNVQWFGcjVzUjRRR1VsWExIeFhwU3J5?=
 =?utf-8?B?ZjJZQVVHQnBsVWhJMlRrWHBNclBoSVROeGRPcG81Nkd5UnhJUjRHTXdQTVFs?=
 =?utf-8?B?bHhCem0rMUQyRnZJamtaU3JrNlprbDBNdlRpdWZoaEpLVUg1YWVvOHoySjJu?=
 =?utf-8?B?bDNqeG5zWWZwNXB2RnFQUmFBYnMyWGRoMSt3dDgvZzU1N2NXN3gwcWNubndC?=
 =?utf-8?B?KytFYksxWWxvaEtpcm1ZZFRrR1NSY3ZhdktXVnY4MTBuWlp5MFFsb0JySUwr?=
 =?utf-8?B?Y2NFOTJybDVOMXpwSkJRenlDL3JnMTVaUkcxeW9SZHZNRWx0SUd6YVBXUzY0?=
 =?utf-8?B?aUgzT1NhTzQ0VzgrbWdCSDJ0L01jbWJ2REU1VXBtZWl1dTlpODJuNXU5WlNS?=
 =?utf-8?B?Y3dMOFoweGNFSEsvRVExOFpjN0N5cjNOQ3pOd3U2K1AvUWtrSTZ0anczOWU3?=
 =?utf-8?B?dkY5VmJMYzFRQ3RTTUJIUXp6MFRrLzNlU3NpWnBkRkhIS0p6S1ZNUTA4RWNs?=
 =?utf-8?B?aDlWR0ZsMUxpc2k0M3lKRlFpdDlFMkJhc3RLd0taM3lTeEFQUDJWcThlUDBU?=
 =?utf-8?B?SHR6MnF0OEV4QnVRdldJQXRJYm9EUnJGVHR3azRGOGNrbVczTEhGNFJJOWZM?=
 =?utf-8?B?ejVNT1lHM1NDZS9CZTJxU2FiOXp1WG85TTdyMi9yMENZQWtELzFYN3lnMUtU?=
 =?utf-8?B?VVBJaFRMV014UHNxaityazZkK01JTTNrK3FkNE5hNGhsU3czcTZzaEVZYWF2?=
 =?utf-8?B?cGd4UEZ2Vk9zNk5vZGJxZHE4S0ZHU0ZPNWhPRmtWNDVFRTlmUE1XY1lOOEZj?=
 =?utf-8?B?V2F4ZGN3NWdBM2lOMWMvdmF1VmRaaVVGbGMyWFVoVUNEQ0FsdTU2WTFuVVFZ?=
 =?utf-8?B?cjd3eFpuQmw5RFpzeDlWc1JPd1FOWktiSjd2bWdQWGk4dGNLT0VLVlZsMll5?=
 =?utf-8?B?ZDZ0RmIzd2srSHZrMWpDajdRK1J6UGM4T0JtOUJERHdzcWlWVXNxc0RkRm8w?=
 =?utf-8?B?cDRFT2JBWWgxZEYzN2xpMlYyNWR4MEdJbHlnNkR2VEpqV0lLSGVjdkgxM2xL?=
 =?utf-8?B?WFg4bllEeUNqWFQxQmRJbEZhM2xUK0xHc3A2Z3VobHJUYWprUy95QzFNZHJt?=
 =?utf-8?B?a2JsMm5BNTNsRmNaOCtBWmZWU2tmSzdjeko2c1U2Unh0TTFBUVFWY3IyYTRJ?=
 =?utf-8?B?b3JENGNDL2VSTjlQODdKUThLMUdxcjNodlBVSVpMZmkvakY0ZEdicWxOaGp6?=
 =?utf-8?B?bGNxZEk1Zm9xOEF2VGxoMDBiWW9pS2hjVzVpdmVhZGhuT0YvK09XTDhTbGhO?=
 =?utf-8?B?a1JVRkNaNTNMbTlEUzhiNTZQd3JmRVVwTVpnUDFpR2h0Q0FKS3RkbGZOMXFL?=
 =?utf-8?B?ZFlCQVk1ZVVQaWhyMWdtZ0pYR1NUUnZmMmFUdFNuZ05DWjlMb3N2OERIK2Jj?=
 =?utf-8?Q?ee6Duz2ORRU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SEd1aXJLTGRBdzVhejAzaERuQ1lNU2dvZXlhaHhjT1VzMGdEQkduUlV1RWg2?=
 =?utf-8?B?YXRvR3hvTkxOOFVwMG5KcUFCWERQeGJTWVh2SEwwRzJ4SVlVOVJiMHVXbC9t?=
 =?utf-8?B?SytLemtCdHdBNXNIWDJncVMwL010VFZ2aGZaTkdRU2pWM1VkSGt0Y05ZMnhs?=
 =?utf-8?B?VHQ2S3dqcE5vYjJwTmdaU1VhdE5NckNxcFc4TnY2MmNOSSt6Y3RZWU4xWGh3?=
 =?utf-8?B?dWlRNzFEV2hwdkZqZDN5M0U2MVhpQ3RJWWMvVDZWTU53alBuTlFlK3hKTkUx?=
 =?utf-8?B?d0QvZ1lETlgzQ203SjZZTzRqM09CdmZEVGQrY1A0KzdZOE5YaEhwbnEvQVdX?=
 =?utf-8?B?NGc0RkdnMTJjekpPMFhXNXZ3QlFCYklWbXNiT3U1MTF1VmJndWNhWUxLa2gr?=
 =?utf-8?B?dmtWRzVuZnNDSHBtb1kvMnozVkdEUm9YUDVnUmhSWEEzZHNyc0lGcy9GSkcz?=
 =?utf-8?B?MHM5d25nUUVJeDFnQlNGQjluODdNcEJBUmN0dmxEdG43WGFQSlFSVEozWEl0?=
 =?utf-8?B?Z2s2dFFQdXBQcTVUOTRlQWludyt6Y0M5clpFbVo0TVd2WlhqNWU5blJKU2RS?=
 =?utf-8?B?Z2s3SCtiTkNvekVRZXFCRDNvbktTTlBJTi8vcTMwYjRSZlRvTFRDM09YMUpH?=
 =?utf-8?B?RnBOUmd2MzcwUzRvQlA2a3FubUxybmF0ZmxzUG1KcHVyaVZXbkdHWWlLZGtq?=
 =?utf-8?B?Ry84R2VLMk51THJBRUp0YlI3ZTR2U0tSSnU3RENJL0c5aWlLcUxTcVZ5Vzli?=
 =?utf-8?B?blQxdzFvay9uYzRuM29OR0pYUWtWaHAwNHZDTDhsVllXMFU5Ri9CMzQvM0pN?=
 =?utf-8?B?bUtZZkl0TjBXeUQyU2FDWGp3SENxVzNzTG1mdThDVlJaMC95QUxDcWVnRHJp?=
 =?utf-8?B?RmJXUysyMVNpTVJQajgvdHYzSzlTaXB1MVdCQ0p6OUlwNWtMNG5TS1Y4aHpN?=
 =?utf-8?B?RUJnZldpVVpoYmdZazkwYjJFVUIvbHhLVnFhSUxaUnNEV3BLYjhKOGYwYWsy?=
 =?utf-8?B?Q21Ma1NkdmJjOGROaDk1UkQrOCtSRHBYVisrZmorUjZaVFJQalBFdDVrQnV0?=
 =?utf-8?B?ejF5cmlKaDVPZXg5eUNjVytINUJtYmkwRGNmNTVJc1RXcnVOV1pwTmoxdDRB?=
 =?utf-8?B?bG9oU2NIWXlsK2t2Nml6djZiYmNVNzdkamFPMlVJNERoRGdWMXhZdm1wL1Vh?=
 =?utf-8?B?TmNwTHo3Skx5ZHFoK2M2aFJVZmxZQzAvd05ybkNlZFZuZmtLcTN2bWdhKy9a?=
 =?utf-8?B?Vk00cFRtYllDZjYrc1FwYzVvdGZxeC9qcW5rekhiaFVPZDFLdzY2blJyL04r?=
 =?utf-8?B?MWNJZjZ2UjEvcHFyLytYSEp6OCtLV0lhMHhRVkNzOXVTUXJRbjhCY2lNbVcr?=
 =?utf-8?B?OE81MnpYQ3dRNUFQODJXUllTVzlhMTlNRC9BVkdqY3VKTDhOMjlMVzltbFFl?=
 =?utf-8?B?RWxVU1VGSlY3QlJlOTBLZ3F0WHl5QUhHOTZ4N2RLbGgzUnZxRmswSWxFVDFt?=
 =?utf-8?B?dVk2SGJWOXMrNkc1S2wyK1N5bnRIcHNyMHZIaUd0cjZiK09vWHY1QkFUNDlB?=
 =?utf-8?B?VEpidE15eEZkb095cVUyMitWb2x5L3NUazRQTkZFS3pMeUNnbk8rNzhRSWxv?=
 =?utf-8?B?eXIvK3pLSi9teXhRaGc4anJFKytFaENqdkNYa1dSWXBMaEo5M29IZE1PdktU?=
 =?utf-8?B?V09YTEJNSXRMR2c2T1I3c0RNWHVYSUV6RkpCMGplakVPMDdwb3JuNjk2emNO?=
 =?utf-8?B?Qk5PeVpuWHcwNG5zMlBoYnA0N3Q3ZE9WWWF2Z1loY1c4N2p6b2FGT3JJbWVy?=
 =?utf-8?B?TGxwVHc4UjhueWtqRFNiRS9KVWF2OW5BRUxQL0pBTGFjbGwyUXFkbEJnZEVI?=
 =?utf-8?B?UGhPTVFiU1ljYWk5NzEyOHNQRDN5OUoxUlRIVnUvS1U2VzVmeEJlOHpONDZT?=
 =?utf-8?B?TVJHODZ6bTFDR3JmZmc4b3FUdExWMnVNSU1TNCs0dExBS1FqN0pFQVZubStx?=
 =?utf-8?B?MGlVR2xzKzVNNzNqbXBEMmU5VHVRS3JMV2U5TjlHN2ZZV1lSbDZWQnVVdkQ2?=
 =?utf-8?B?RUlDdTZLNHV1K2FTaGxFM2xITGd6QXRocTVESHFvOGtnNE83aWJNMStmeTdk?=
 =?utf-8?Q?CWC/AMNprcGK3MxeMbWQuHQv9?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a183128-fa8a-4730-732a-08ddf201fa33
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2025 13:40:46.4699
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CGLMjpuvTlxEUCeYIAROFqCwoHUrisP20EMfNCxiHka8W05q3V8ESKBBAurrZ5oHYABc0oEDiAx9lqDxiwblcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN3PR12MB9595

On 9/11/25 06:54, Naveen N Rao (AMD) wrote:
> SEV features in the VMSA are only meaningful for SEV-ES and SEV-SNP
> guests, as they control aspects of the encrypted guest state that are
> not relevant for basic SEV guests.
> 
> Add a check in check_sev_features() to ensure that SEV-ES or SEV-SNP is
> enabled when any SEV features are specified.
> 
> Reviewed-by: Nikunj A Dadhania <nikunj@amd.com>
> Signed-off-by: Naveen N Rao (AMD) <naveen@kernel.org>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  target/i386/sev.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index 243e9493ba8d..fa23b5c38e9b 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -509,6 +509,12 @@ static int check_sev_features(SevCommonState *sev_common, uint64_t sev_features,
>              __func__);
>          return -1;
>      }
> +    if (sev_features && !sev_es_enabled()) {
> +        error_setg(errp,
> +                   "%s: SEV features require either SEV-ES or SEV-SNP to be enabled",
> +                   __func__);
> +        return -1;
> +    }
>      if (sev_features & ~sev_common->supported_sev_features) {
>          error_setg(errp,
>                     "%s: VMSA contains unsupported sev_features: %lX, "


