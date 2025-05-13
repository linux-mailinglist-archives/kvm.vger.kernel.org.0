Return-Path: <kvm+bounces-46351-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E1725AB5531
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 14:51:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 309223A3DD6
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 12:51:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BB5128DEF0;
	Tue, 13 May 2025 12:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="oNNhEZvX"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2087.outbound.protection.outlook.com [40.107.94.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C316214F70;
	Tue, 13 May 2025 12:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747140675; cv=fail; b=UPrbNgQbHE10va1Qmm2P5WVCi25MJaGi2HQReocU0MBB94qco+Wi/EhrAGaLwJ0QE5iffy4DeU+LBnzSassmrVR5lgvdhsRJWMYSphCxCNRrazOuc8SR8G9zlPrGhWOiixskUyN3g9AxHB71GrrzGtc+JFQXBNWQLuWiJ9ZiG9U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747140675; c=relaxed/simple;
	bh=BIi8s8W0WgTM7WKpS3b4x2Gwg9VwytHT/rVIQfIyeW8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lZsUAv90ePjalGzDD6+7W75vH8u1toJgbPTJcXpQKWBjIx7fw3cso3U5frjpRjScJRgcvbk0lrUg99JK1dF7aH5RVPuv07pKPFKFxM5SOYtQ24sP9BVfKT9pFWoj8MdPpHB6IB8oIn72enlCOcCmIdXa/oVSR1MHK24MsIypKSM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=oNNhEZvX; arc=fail smtp.client-ip=40.107.94.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jGiqgucvimHwhQ1f4jqs+DQIj9h7C1ZhNuLnNz13XslpJqXD8O+YNMCxrhTlKuKqKg60F1bI6qomvhLDw23zGosvk6zD9yENzLnSbLSB5O/UBV0IZ4NQqLLvHUYG//+NKxtQw9r96K3H9dqm2Lzst0Zh/S1l/Q1a+6N1SOdjCRJbMSqatkM/pRtZ2TW6DHCEe8h5Rw/IkaSdQ4VPhihFfcWJqaQDqw42mdrRGUx8xVnr6C6p75dLjn0J1zl5xmrr/zljGcXyDxVLXLSesc42uZO0Kt9Cypw56u893ZwVqWhYwpxifqowmXjjabrViVhcYNA1Jp8Ka3ebk/MrnccU4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZIZXXFjXR+UyP6+SEB4SYks1Poszx4QW9OENDEKSKC8=;
 b=fr0DsswvuCLSF1dOT+KIvXUt3XBxDDBnr92/VwbYgEgOsJu8wcI3grJwWp8h7R6b1nsl1ll5fCFkb/zjXCybtSgEdQjs4U8HUg3Hx9KkSnytUwVhq8f+85AscV5R1yVRRXHdL3N7sEklZ1A1fKKwon+vM9o9xUUc9iSprl97Jw19ygBWBKuts5/4EEEcUevDd2a6yZEjAsUDz5d9UEn6gw/ClTDXYQ/NjhpbooPmj7hx2rcw/ppm0RDPHph2FR6uwBIP2zbB1c5xTE7ERDz6IO+oTvBO8s7xOwOtOJGIpTJmLNh/ZlGcI/IIK0bQZhxfmmdKnZ90gSZ8wPovHQi3ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZIZXXFjXR+UyP6+SEB4SYks1Poszx4QW9OENDEKSKC8=;
 b=oNNhEZvXsmFde7D9+AV6apdoMkCCrkCrUZ5d01gd25ZErNFBdTBWpuFDeBnQzS1l0ZWeAHxr2dFOacMiIXitCJZpuz1ek1og6VueAYO5DERQ5InHnjHCHVDH19QhM9COqbug7kwCgpqiLZePlSZ3Pia/ac0E1gQ5N9moP7Psb+Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA1PR12MB8189.namprd12.prod.outlook.com (2603:10b6:208:3f0::13)
 by SA1PR12MB8697.namprd12.prod.outlook.com (2603:10b6:806:385::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.29; Tue, 13 May
 2025 12:51:11 +0000
Received: from IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::193b:bbfd:9894:dc48]) by IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::193b:bbfd:9894:dc48%3]) with mapi id 15.20.8722.027; Tue, 13 May 2025
 12:51:10 +0000
Message-ID: <f8a6e61e-dfa4-4523-bd25-6b6ef7f8b53d@amd.com>
Date: Tue, 13 May 2025 14:51:06 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/5] KVM: Check for empty mask of harvested dirty ring
 entries in caller
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Peter Xu <peterx@redhat.com>, Yan Zhao <yan.y.zhao@intel.com>,
 Maxim Levitsky <mlevitsk@redhat.com>
References: <20250508141012.1411952-1-seanjc@google.com>
 <20250508141012.1411952-5-seanjc@google.com>
Content-Language: en-US
From: "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <20250508141012.1411952-5-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0320.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:eb::9) To IA1PR12MB8189.namprd12.prod.outlook.com
 (2603:10b6:208:3f0::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR12MB8189:EE_|SA1PR12MB8697:EE_
X-MS-Office365-Filtering-Correlation-Id: 7eba8ac8-2108-4d67-bdac-08dd921cd615
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WjBKR1FiR2dVOFFWVlIzK0IyYVRIVVp1MGZwRVZweWcyNjdPbHB4SUVCSzVI?=
 =?utf-8?B?R3ZOMTZqV3lhLyt3d2ZkeVB1MzZveTZlY1RmOWI2blAwRVFndGhGajUwWERB?=
 =?utf-8?B?NTdPaFdmcjcwYUFoK0h0ZFl0ME4zOFJxa25mV2tNWUhrckU0dkUxZldjWVRt?=
 =?utf-8?B?UUhaQlA0ZnBPdnFZcHc1L3pxcjRlYjJtZVFJZ1pKTXZLT3RPTEJMbjB2MlFj?=
 =?utf-8?B?NkJPa0VqYWhQU2lhOElGVy9GL3NjdXZIM3B4alBWQlQ1RnZoYXdEZTIzTDJT?=
 =?utf-8?B?ajVkcUVoMTh1SnBuZ1Y3Nk1iMFhBSFVJZE1XWHdMZm9PWUVIUzI4Y1RLTUV3?=
 =?utf-8?B?QjI3STFLNzMzdmVpeFlVT1lSSzZJc0E1dE1tUlMzcWF4U2RJUXR3QUdSdnY3?=
 =?utf-8?B?KzJJTnhDRDlNUWdkTUhKNnc5b0NoRmNEU1hYYU5VTjZRaXZvSnlyQ21ORi8v?=
 =?utf-8?B?N1VUN2FBNiswSzhLZ1pXWmk3eVJyeDhZRTBHUzBVRkVURlZwKzlwSHVUak8w?=
 =?utf-8?B?bXk4RFk3elJzZ3JuWWNGdkk0N3hHTjZXQSswcTJFRTBXK2d3MGdwem5KYW5L?=
 =?utf-8?B?dkNBWS9neTFCVWxMVFF4a2psbGZsdUI0c2FDRWtoRHQ1bWlPZ25ZUzl5WnJn?=
 =?utf-8?B?VXFROTZ4R1RhR0JjZ0Q3OGZULzhsS3hNV1h6U2ZVeUR4NFZLcytSZC9ibFMv?=
 =?utf-8?B?d2poTXZwMTY2Q3BYRk5RUjJBTGRMM0tzNUVSdVBzY1h0VGlSYmdmejhmR2JO?=
 =?utf-8?B?bWppTm5FUFNBcU1tK2tjMGJMVHVXNEx4eXViSk9PRlMzNHQ4WG0zM21zaDZQ?=
 =?utf-8?B?dFlJYks1SSs4eEJnWk5tM1M5ZmorV1RHa0FmSXZPbnVFTm5pOHNPelBTNGwy?=
 =?utf-8?B?ZVhiR0dJM09adnJ6Zk5oSWRhWUt1RFR5SDFFbk5Ya3JVZUtPT0ZiaGdQZ3ZH?=
 =?utf-8?B?TERFOHRVOXZQR3VPaC9yUDRoZTg3S251QW1vL3ZMUVlUV3NOdjczWlNVdVpx?=
 =?utf-8?B?TExOSHVkaFNMdmNLdmI5MHZ3OGVza0cxQ1ltN0hLbmJqcW1Zb0Nsb25xdklX?=
 =?utf-8?B?U3lOcHV0ck4ra1dGSitZbWdlNGFvSjZoK1E1c3Z5c0lKckViRHlkeFJXaktG?=
 =?utf-8?B?MVUwOVZVZFZiaXQzdms2VGl1RlRpYUh5QS8rTVdCeHVCNkdZWW00WjV2eExa?=
 =?utf-8?B?Uis5N1NKUVF1L2pxRE1MQWVuOUdnRUdNNnRVYXdkVU5Wa1RrZnY3VDFQcnJx?=
 =?utf-8?B?dkdDempWQU5ZcHBYWndaT2diYUx5Vi96L0phS0luTUhDNU5RTWRYRnQ5Vllq?=
 =?utf-8?B?alZUak5yZTlyTGExTmc2cnVzNzc5a0JCZGdSSEVYMWxIMnc2U2JEc25ETVdG?=
 =?utf-8?B?S0RRN3I2eHlRUHdhdlNCcUsxUlc4QmIzLzg4QXZMT3BZakxkMEtrTmF6RnB6?=
 =?utf-8?B?R3N0TmRyQXJzSVprSXZ3OWpvYzRHVzU4WWozRFlaR0FPbnhHcjRvcytwUkNh?=
 =?utf-8?B?eG14U3JxNzcrNXc4ZEdzczRXNjRQYm1oUXFjSlVzYXJkeDgxOUJ1aUlMSFRM?=
 =?utf-8?B?UXdzbjVCdVh0SFZHL2ZVVHRnTDhmUVNhejJlZCtTTFBvMGtQZWlsQk9iR1lG?=
 =?utf-8?B?dURkYUFoWFhSaDhZdUtzWUhLd3lUM3laZ1V3dEdDSGxjNTZLRkg0dXNsKzFl?=
 =?utf-8?B?Lys4WGx5aG1PcTFiRzZDK0pqdjVQazF2OTBjNy8xQTlVRGpldjdVdEJudWNB?=
 =?utf-8?B?YTh3UkkvWU4zQWNqSituZHdvM3EvRG00K08xRzZxOEM4VUhtNnJmNjdpdXFB?=
 =?utf-8?B?STk4YThRWVdTQ2F3OC8wU2NDSFN6VGx5V2IvdkZOcklvdW1BVURHVG53VnNo?=
 =?utf-8?B?U05LZk9RMHJsaUtwQ1N3VXFNN29FVzYxWTY2aVRjdHh1VmRGMEowUFg1eldO?=
 =?utf-8?Q?UrShKfcZ/BI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB8189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VURmYUtGV3R3a1gzZVBzYytFMGNVV25PSjlqeDk0YndMSTB0QUExSDlMcUpj?=
 =?utf-8?B?VG45d2RoK3V6b3B1WFFtaEtITnpPQjg4bXVZKzk3cDBNTmlVcThVdmQzc1lt?=
 =?utf-8?B?RmtISHBkaGJGTEZjcGppTW13bWNYaVVLa1RtS1NrT3VyMFdGYWZtVFZmc2Zs?=
 =?utf-8?B?cXNJYlV2VE5OcUhNMmNSYkRQTTFGeXhhV3RpRUtOT2tNVG9OK2hpbzNhaGdQ?=
 =?utf-8?B?bFowenFtMGY5Q1lBVVp1Q2Fody9ackRDcTMwSXpjdjhxMjc1YlFJekl1Y2J2?=
 =?utf-8?B?K1NHYlBMQXFVSVZ6MFdIWmtzdHA4RldHcUxsbStFN1JocWlwZ1ZBZ2dXMTFE?=
 =?utf-8?B?c0hYL0Qyd0dSZWozOXZScC9VVTBwZHRKdVhpREhOWEtpdTZQK29uc1czV2dD?=
 =?utf-8?B?Nk9vQkpacDdRR21wOGRlb282SFpLNzF4QVNsdkJ6Q214elg1WlNxS1BMbis4?=
 =?utf-8?B?TElsdmtuSThWN0ZNcy9aSENRQnVUV2g4d1phVzBkakJieGRCdGh3WXZxZzIy?=
 =?utf-8?B?TVFNYWtoYWRyTnJVNUZCZVFsUkJIRmwxSThQeWFzb2JSMEN3eHpFREUvaWZj?=
 =?utf-8?B?TDJWc2Roek5aTTR2ZmU0SkRURDU5TitKU0VoZDhRVkU4eTUwN24vb2lLOEdw?=
 =?utf-8?B?a1AvckNQSEtiMWRPZEsvekNVeitPaDBvQlduaGRPVUVlak1hWGdHSjlCUVIr?=
 =?utf-8?B?QWw3RmtuOE10d2NGdUFWWTM4djVRZVJFYm4vZStwZmN1a0JxZDBVQ3BXNUNr?=
 =?utf-8?B?ZnNaeDI0Y1JzSGk3YTRhVlZzM2RKdktQRVRlRUQ5U0Zabzd5WE1FUjZnaHpF?=
 =?utf-8?B?TS9CWHVLNTcyY1BWM21xeExoUTM2UnBZVUN2aklCYkM2ZnN2aTdHdGZqZ3lJ?=
 =?utf-8?B?QXltQi9Vd292cHpBb3p4SmtYK0luRG9iQThTODVzdVVXOG95Z2FTUUNPeWhX?=
 =?utf-8?B?cFI5aTBJZXM0K2RvUFNPQTd4Q2dGWTduWndpU0pjV0EzUGdHbzRXdUgxUmdq?=
 =?utf-8?B?YjVPK0dwWjMwditaRG5HSmVjcG9lYWtnRlpGTlVZd0hoVDRyTCtFaUJ5VVVR?=
 =?utf-8?B?Z2o4cWtxZkdpNitFRDJHdVhFRzRJeGt1WDc1RHlwalJxTGJaM3BUVklIMWtV?=
 =?utf-8?B?OFBDUW52aWlnaTQzZThOalIyeUdYSVk3UW1BeVFxaWZLT0wwM2FuaWsrUkxR?=
 =?utf-8?B?M0EyVUdGYjIrd2dKL0Q0by9lOU1RRE55cHdqdVJVNzNyK2x3MldHTllxUVpL?=
 =?utf-8?B?VzQwNW5VUFZoeUFxZ0Qvd3gxZW5LQ1M2NXVmY0JQQ0pGQTl6SCtzNVFLSzh3?=
 =?utf-8?B?UVROSkZLaGhJbm4ybzBPZndmMFp5TVA5NHZYRnpJeFhZWmhNdStGSUVzMXd2?=
 =?utf-8?B?S1Nra2JNSEJDTUdIcU10dUg2YW53NXdDVm9RemNGNkZxNllTRUNGNDZBTjZn?=
 =?utf-8?B?bW0rU3J1K2dObzVNbHFWcG1LTElwZ0ZITmFtc2c0OHNhL2xaYThwVTU5Tm41?=
 =?utf-8?B?NTFTL0s5Qmo1R2t2WmZGTXJQTTNEczgxZlZveVZHSG1UVXI2ZTBCTXNOZnRP?=
 =?utf-8?B?cFBVSnRRQTNQTjlQVVhvaHJXR2xvalBJRmZMNGFraEtnVkZrRnFzdTR6Rjlu?=
 =?utf-8?B?a3A1WElVeFhGZSs0ZGdsMGd1Tmc2Q3hMYmxKaC8rNHdxYW12M3k3bjdOQjBR?=
 =?utf-8?B?YnZKOFR3WkwwVFNvcnRRckxRMk10V0ZXWERRdzljWTlqbWR5aXNZcWVTNStu?=
 =?utf-8?B?bSs1Q1UzWnhmOER4TU9mVFBDcmt4S2g2bW9SNEwyVE9sOCt0OWFvenU0MnEz?=
 =?utf-8?B?S0RaQlpsYkwwRXhTSE9xaWpTL0ZoVlBaVVY3VUdRTlN5TndBb2taWEgyS3RG?=
 =?utf-8?B?SHB0d1RlaEluQjZzZ2lvVTNlKy9YMlc2RXJTcFdVQXVDODd5aUFjYTdRNzBS?=
 =?utf-8?B?UFI3c1NnTm5pcnR2cktiM25LOTJNdm9yQUJHazYzS2N4QlRCT2VGeVd1RWtj?=
 =?utf-8?B?NmZpNVRsUWhReTQwK25qWkJ2U003NHd0L25kU0RKMlFnenJRQjQ4NTFaUWht?=
 =?utf-8?B?TzBXV3ZYWEZMM2t0U25ERWxmQVpRV0I5Zmh1S2I3QWRVRlhuS292K3BYbEV6?=
 =?utf-8?Q?xmtvILMf4/JXgAbmkGWdlxZyL?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7eba8ac8-2108-4d67-bdac-08dd921cd615
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB8189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2025 12:51:10.7854
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ftk3Q0y03YZzdGTPnRu+Sw3anRhQb90KlvuKxpNSe/zdYbJW+uM7wZmTYS070x9pElHbVpvTUYL/4FtFqfJnfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8697

On 5/8/2025 4:10 PM, Sean Christopherson wrote:
> When resetting a dirty ring, explicitly check that there is work to be
> done before calling kvm_reset_dirty_gfn(), e.g. if no harvested entries
> are found and/or on the loop's first iteration, and delete the extremely
> misleading comment "This is only needed to make compilers happy".  KVM
> absolutely relies on mask to be zero-initialized, i.e. the comment is an
> outright lie.  Furthermore, the compiler is right to complain that KVM is
> calling a function with uninitialized data, as there are no guarantees
> the implementation details of kvm_reset_dirty_gfn() will be visible to
> kvm_dirty_ring_reset().
> 
> While the flaw could be fixed by simply deleting (or rewording) the
> comment, and duplicating the check is unfortunate, checking mask in the
> caller will allow for additional cleanups.
> 
> Opportunisticaly drop the zero-initialization of cur_slot and cur_offset.
> If a bug were introduced where either the slot or offset was consumed
> before mask is set to a non-zero value, then it is highly desirable for
> the compiler (or some other sanitizer) to yell.
> 
> Cc: Peter Xu <peterx@redhat.com>
> Cc: Yan Zhao <yan.y.zhao@intel.com>
> Cc: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

LGTM

Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>

> ---
>   virt/kvm/dirty_ring.c | 44 ++++++++++++++++++++++++++++++++++---------
>   1 file changed, 35 insertions(+), 9 deletions(-)
> 
> diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
> index 97cca0c02fd1..a3434be8f00d 100644
> --- a/virt/kvm/dirty_ring.c
> +++ b/virt/kvm/dirty_ring.c
> @@ -55,9 +55,6 @@ static void kvm_reset_dirty_gfn(struct kvm *kvm, u32 slot, u64 offset, u64 mask)
>   	struct kvm_memory_slot *memslot;
>   	int as_id, id;
>   
> -	if (!mask)
> -		return;
> -
>   	as_id = slot >> 16;
>   	id = (u16)slot;
>   
> @@ -108,15 +105,24 @@ static inline bool kvm_dirty_gfn_harvested(struct kvm_dirty_gfn *gfn)
>   int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring,
>   			 int *nr_entries_reset)
>   {
> +	/*
> +	 * To minimize mmu_lock contention, batch resets for harvested entries
> +	 * whose gfns are in the same slot, and are within N frame numbers of
> +	 * each other, where N is the number of bits in an unsigned long.  For
> +	 * simplicity, process the current set of entries when the next entry
> +	 * can't be included in the batch.
> +	 *
> +	 * Track the current batch slot, the gfn offset into the slot for the
> +	 * batch, and the bitmask of gfns that need to be reset (relative to
> +	 * offset).  Note, the offset may be adjusted backwards, e.g. so that
> +	 * a sequence of gfns X, X-1, ... X-N can be batched.
> +	 */
>   	u32 cur_slot, next_slot;
>   	u64 cur_offset, next_offset;
> -	unsigned long mask;
> +	unsigned long mask = 0;
>   	struct kvm_dirty_gfn *entry;
>   	bool first_round = true;
>   
> -	/* This is only needed to make compilers happy */
> -	cur_slot = cur_offset = mask = 0;
> -
>   	while (likely((*nr_entries_reset) < INT_MAX)) {
>   		if (signal_pending(current))
>   			return -EINTR;
> @@ -164,14 +170,34 @@ int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring,
>   				continue;
>   			}
>   		}
> -		kvm_reset_dirty_gfn(kvm, cur_slot, cur_offset, mask);
> +
> +		/*
> +		 * Reset the slot for all the harvested entries that have been
> +		 * gathered, but not yet fully processed.
> +		 */
> +		if (mask)
> +			kvm_reset_dirty_gfn(kvm, cur_slot, cur_offset, mask);
> +
> +		/*
> +		 * The current slot was reset or this is the first harvested
> +		 * entry, (re)initialize the metadata.
> +		 */
>   		cur_slot = next_slot;
>   		cur_offset = next_offset;
>   		mask = 1;
>   		first_round = false;
>   	}
>   
> -	kvm_reset_dirty_gfn(kvm, cur_slot, cur_offset, mask);
> +	/*
> +	 * Perform a final reset if there are harvested entries that haven't
> +	 * been processed, which is guaranteed if at least one harvested was
> +	 * found.  The loop only performs a reset when the "next" entry can't
> +	 * be batched with "current" the entry(s), and that reset processes the
> +	 * _current_ entry(s), i.e. the last harvested entry, a.k.a. next, will
> +	 * always be left pending.
> +	 */
> +	if (mask)
> +		kvm_reset_dirty_gfn(kvm, cur_slot, cur_offset, mask);
>   
>   	/*
>   	 * The request KVM_REQ_DIRTY_RING_SOFT_FULL will be cleared


