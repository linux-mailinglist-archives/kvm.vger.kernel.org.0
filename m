Return-Path: <kvm+bounces-25902-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D461696C58A
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 19:37:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8DDC8287FA7
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 17:37:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 488C31E1330;
	Wed,  4 Sep 2024 17:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="q7L6i9ob"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2068.outbound.protection.outlook.com [40.107.244.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEBEC1E00B9;
	Wed,  4 Sep 2024 17:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725471448; cv=fail; b=rgcoBeaWzj7p2JbRmlhqFC52G+cLuw8oFOyefA/Vk6R2wu4s1GabmMwdG3RCUXPfvTHkzFPGSwyij484dXYR68qjgbh0gq3J9e9rWQIGGme32h3TVPqvBPhU+etY8QI2NsyZ+dgYYeBP/gbicCmDw8Qn00iqy86QXqGUj4LkIqE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725471448; c=relaxed/simple;
	bh=XMTT09jMOOGoOB+eZ4FJWI4jVmaZjHkvEUu57TVxaAA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=bzwrmZ2PiqayGViKIB2IdrjNUHcNyPv1uSe1DcJ5dSzG8N0XrtrZbFcpctdoax9eYqRorHBaiqan4Yoi/3rD33npIb9+Yhwq9gwCJxkVFbCZDJsp8A6sGPZw4tmnj4j3TLmwfuN1Jtkgqz7rHgIsnsvC7sqJLVwKTI4ce/UkE7I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=q7L6i9ob; arc=fail smtp.client-ip=40.107.244.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JkdjNjoEOSwUjBj0BQqc9Dkd0Mtvrt9ehSwzWFXaO20mn6kWByQCPp8/punHn2lFdvbY9zGKZIMEGFPQHiUBDJhdLw7cqoFluuvL6OCi+kY7i6/DscsYdKvCdK2NrPMR9FcDwdUmlxXDH30e8oQrkoYr6UBfUbcdB1JVbgSplUNKS3CxpaKxFhmrBsyvhzqiCHIruE+uyAMzEExq5xE/uGqc5TPVGdJy7Z6YQG80/sx+7poE7tRrIG+3TJ/rjbgOqIpZybUtTVgxwHpfhD+uqT3fQK7hRBaQiiDRSVr4GvZu4+kZqo3CTkX80fB124oOFo7wfH+akMU7zlyogJ1JSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XMTT09jMOOGoOB+eZ4FJWI4jVmaZjHkvEUu57TVxaAA=;
 b=JZk5Fb8IiitN5ccFGWgZYijWfoc0K8WdvLp/ZYCq2GgiN1RweDN0MNNoNCCiZRvBN/yCSjQR0i7cG0Q6osGxkPlgVrXzs1D/HJdEkRaianVCoRjCCcxmmhYr2/FM3jRonG91Eszj4bqO8RADAmHwggkNGQRZKi0wwK6YhY70qFOAZquKBLhZcmq4tS0qXr4fo1u1LnfUdCu0bjPIAxmBorcuqIYDwFzkQo5vBtbX9Cdl59OG2PQbTYZaF5khxrOeKoBjIwdF5/kTOJG/bD8BqsVTMme0mlpau2Z4pB7Yp4QxNDaVi6QDDcapmW55/D9pJK1MBJYOT/QA7FBVMgqY+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XMTT09jMOOGoOB+eZ4FJWI4jVmaZjHkvEUu57TVxaAA=;
 b=q7L6i9obC16Kvl/GC5As1wI3sfgKRkmljiO4EU+++ePA6+RvUVmWMCn5zM5Aq/2jOVj3tcOnwi0igfoETZfk1dRVB0ONqpipkcL52l5oMse8G38QBZVCNJ87T5R10UPTIY/ZzMKRkChokawcAPPdh2JLVRidUwR82MZA+tJnzxA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by DS7PR12MB6117.namprd12.prod.outlook.com (2603:10b6:8:9b::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.27; Wed, 4 Sep 2024 17:37:22 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef%7]) with mapi id 15.20.7918.024; Wed, 4 Sep 2024
 17:37:22 +0000
Message-ID: <14b0bc83-f645-408f-b8af-13f49fe6155d@amd.com>
Date: Wed, 4 Sep 2024 12:37:17 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] x86/sev: Fix host kdump support for SNP
Content-Language: en-US
To: Paolo Bonzini <pbonzini@redhat.com>,
 Sean Christopherson <seanjc@google.com>
Cc: dave.hansen@linux.intel.com, tglx@linutronix.de, mingo@redhat.com,
 bp@alien8.de, x86@kernel.org, hpa@zytor.com, peterz@infradead.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, thomas.lendacky@amd.com,
 michael.roth@amd.com, kexec@lists.infradead.org, linux-coco@lists.linux.dev
References: <20240903191033.28365-1-Ashish.Kalra@amd.com>
 <ZtdpDwT8S_llR9Zn@google.com> <fbde9567-d235-459b-a80b-b2dbaf9d1acb@amd.com>
 <25ca73c9-e4ba-4a95-82c8-0d6cf8d0ff78@redhat.com>
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <25ca73c9-e4ba-4a95-82c8-0d6cf8d0ff78@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN6PR04CA0106.namprd04.prod.outlook.com
 (2603:10b6:805:f2::47) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|DS7PR12MB6117:EE_
X-MS-Office365-Filtering-Correlation-Id: d0b4aa8f-98ae-4603-de66-08dccd083b9d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TTgzbDVWTTJzemVRaEpOQ0xKUEtvbXVWTmJEZHJrS2crUE44WHllNFBrRmlS?=
 =?utf-8?B?c1dNTDhWdXRyM2d5L0lBdllPUTcwWm40NEtqSS9HR3pnWXVkcnJsTVhZNXFT?=
 =?utf-8?B?QVRNdVdnd296dXViV21pSkk2dGlZdTM4ckxvZVBXVUcyUXNoMUtqcWdvQzJq?=
 =?utf-8?B?Y2xYbWUzZUt3S3lSdjRmODJrb0h4dGFGVTlxZW5OTnFPNDVVcHY1OXVDb3lm?=
 =?utf-8?B?VVMxK3I2aDJPdnFMUUtaQllDUU1wTmU1cGpkRXMrQmwvZVVTNkpCWVdCMy9u?=
 =?utf-8?B?QUZDTko5bGcwSlIyRXR3ZE8xN3loTU4wWUtUcktSbVRLcENOQmlMOC9tbXJC?=
 =?utf-8?B?bEovWUJURktOTzk2NnZTcUZLRlJkdlo0ZFJKVDV5U3A4ZlVVL0FENmNsWXRq?=
 =?utf-8?B?VjFUamVlOERVMWM0QzRPUGc4VFhhbUc4c21SM3JkMm9pdXRvcWovSERBYVpa?=
 =?utf-8?B?eWFaUVFSb0JEVTFjYWJnTEY2V3hYRjVSVHBDRzAyUkF0dEUrYXkzQ2dyZEU5?=
 =?utf-8?B?eFNmaHE0M2thTlQ2cUdseWtiVjVpSC9WNDhWUEhRQi91K3NWeDJOb3hHc0hG?=
 =?utf-8?B?Nzh0eHZOa2wrQStqZXUrVzg5UHl6Rm9rY0NxaHhiWGVUK0FVdDI0VEhPZC9S?=
 =?utf-8?B?eGdLZVVGUzdxT1NOd242LzhaWjlYaGZUQW9kbzBkUFZkbjhHdmp3VVd4TXNQ?=
 =?utf-8?B?aTAyRUI3cUxsQTBoQjdYUS9TcnJKWktXNHFoeGFLOVd5cHZIMmxtYUtnQkY0?=
 =?utf-8?B?REdoZjZKaldraHU2blZkTUpOOStoVXY0ZCtDVC9jOC9PZWlEZzZRN3FKK3gz?=
 =?utf-8?B?MHpScjhVMWcvUmh6dUhyR2RBalJBSUowTWZsa1NqS2p3OEtYY1luKzRVL0Zo?=
 =?utf-8?B?bVpKUXFyN21mcUlIc3QzRE9jdzRRMXJBMXFYZHY4S3MwVDdhNVpxT2pWRWtR?=
 =?utf-8?B?RGdUc29wVncyWVlXVUpsTGdOM2tENC9kbytDNzZYWTdkSWtmTFc2cndUd0dW?=
 =?utf-8?B?VFV6V0ZCTEVSRm1TK1g1TG00eUljemtteXFlZDFLVTRJUlJEVEg2dnZjWm9w?=
 =?utf-8?B?ZkVXU0praEpoRW1WT2xCL293MWxRTmIxTTdJVjdVRjZGNE15M1B1Y3JpWjdX?=
 =?utf-8?B?ZUl6SVp0YlN1SzFDRy9YbU1FZGxJRnF1L3ZvNGpyQmdpZ3lvSmZ2aGZZM0hE?=
 =?utf-8?B?Y2J6YWVnS09LZnJXZm9uSm5HWnFGNDhZOUdVZExjSS9haTBFTUV4aU1ldzMz?=
 =?utf-8?B?ejd4QVM4bUU3UEFSbWN2ZFppSW5RUE5INzdYbWJmelcrcWlIb0lid2tpNENG?=
 =?utf-8?B?TWduSTAzQUpieHdYczVacVlTUmpzaVNJaXVSUEY3QlJTTWxsRmpScGNuK095?=
 =?utf-8?B?enZDZ2RuSVlpUHJRSTZua1U0empNRTVwZUs4Q0NOdDNzK2RRb2s3ZTVua245?=
 =?utf-8?B?RnV5UGFLZ1RRM1l2cVFramZZbEpkSGk1Q3FUUWtpd1dWa1h4NjIrRDlCb3lT?=
 =?utf-8?B?dXFuSCtNYWhlaEJYWDcyVVhKbFdCYzVqdEtPT3RtS0R6a1VWNEVkRWw5VUNC?=
 =?utf-8?B?TkJvZmZCcUdRVXNuRVgwd1laNG40TWw5ZjZsV29mc2tUMExuVXFWRlpvZ0c3?=
 =?utf-8?B?S1JlZFVKMyt3VkFsZXRjNit0UHFvTHN4b2EwUGxlalc5WE9VZUxYeUh1Q1d1?=
 =?utf-8?B?WTh5OHZ4OExRbkx6cEdudFZGQ3NoNDJZWlR3V2dpcHdaQU9KQTErcXh4aTFy?=
 =?utf-8?B?bGFFZHdTallLN1ZZck5oZTk5S0ZLb3NYSlJmQW1pKzVEdWNyM2VpZ1ZHRGxE?=
 =?utf-8?B?SnRORWEyYzh1ME95K3JQdz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?N0E5QzM5SUxYUGJhdkJjQmRiWEszelhncGxVR21JakczZ3NhTHFIOFBvYnJM?=
 =?utf-8?B?V1orQytrUlVJVGdsNy9YYUZDUUpWU3Jma2FjL2tkdXBWZ1ZpUk1JVnlnZ0NL?=
 =?utf-8?B?TXQ5SUNyNGxFdVRya3cvdmdiMTdCdHNGSVJCaEppNUhOT1pMMXJhNEFmNUxn?=
 =?utf-8?B?Y2VLMlEvU0thSWhtYVh2RXZZa1ZVaDkvMm95N0dpLzVJZlVWemcyRE1WNWQx?=
 =?utf-8?B?RmtKVVdQdHNLWUZZUHNCbHJMazRkNXhlOFl6Um5kSUg0NVIyV0xMTXU4S053?=
 =?utf-8?B?djZ6bmJ1RGdrZW9qdW4ybHhHYVBYSVVEdk1zaEY3UlVLZkZDcllSOVNYeHhE?=
 =?utf-8?B?LzU4bG1zcEJEeHJUZ3ZoZGJWdXFYYnJNVGIzdmgwZlRXcDdWSXRBV3l4M1d2?=
 =?utf-8?B?bnVENjJ4dEhydG1jY0ZUWTNOWHpXRkxtMERmbG5hQ1ZGT0h0Ui8wWGRXY0dG?=
 =?utf-8?B?MXhFYVUxei9OMGx0NWVsTXEvSXdLcXk4T1VzUnYrVnpiNklVTjlGbmFWc3Bp?=
 =?utf-8?B?QW8vTEprc0l4NnlldDJIdTRCYlVad3dvMWIrcHZVSmc0TGNBWGRuUWo4LzVR?=
 =?utf-8?B?djRPQmNZWVhETXQwWTcvMEE4T28vaTFJNjhma25FQzQvd3dXK2wzNysvWGgw?=
 =?utf-8?B?aWxFNTRPLzhCeVl1eGtyYWlWUmlyY3hoNGJhaWhkaGJiaG44dmxVQ05LVi9L?=
 =?utf-8?B?SFF3bGt1OVdPMEk5Q0hFYjZQUTNGMUVWM3hBbC8wSDJIRmxJcUkxVE9kaCt4?=
 =?utf-8?B?cGZpQ2RiK2dXZEN3aXF4dHk0WkhZZGhISTRuZTRaZ0tHZ0x6dFE5enFZZlFj?=
 =?utf-8?B?WVlIYmlKWEhmcGdYY3o4dHdkcXFaQ0o4OXlOYS9ZVTZ2cE1yWHdZcm83UUxC?=
 =?utf-8?B?d0R0RUZ5dzBZR0k5NWUxN1ovMEF2d2hUbzcyMEpNbGg3RUFoYW1qalRRZmFl?=
 =?utf-8?B?eSsxaHAySFkrcm5ZbzQ3eEVTb1JrUloycEtweFlndW13M1FPa3MvYVg4MGN5?=
 =?utf-8?B?M2lvRmZuSWNmenEvcXBIVjN1L2hxZDBrTitTYkJTektOL1MrY2F5TlVnd3ds?=
 =?utf-8?B?Q0NYRzJtdjVLbmdsLzFrNmhZckMyR0E5RFpaNFliRkRZU2IwWE01UFptZzcv?=
 =?utf-8?B?WmkzK3Jza2JqdUhXaFRqRzgvVkg1Y0Z1Q0hZaFFmMTkyWjVsQTNJclpKd3Jw?=
 =?utf-8?B?S0FLWTZWNGFvT1ZhMUdjSGxMaFhzc1BZZHUwRVdmMkV6S2JWZjFqVUZFMW5N?=
 =?utf-8?B?aHQ3T2I4QmtOajNteTBRSEZNUElxaWVjSkdFVHY3bjZwV0xTb0pVWjRFdW9i?=
 =?utf-8?B?RUk5WU1SQlRxMFdvYXdIeGRlZkd0SVRWdThCQkFvMXVHSHFmRXc1U0pXZ1ln?=
 =?utf-8?B?YVpqTnM5cjBHc2hwUVk3bTdCZ3ZSY1cyYiszRUNsTUdwb1phRWZoM3E5MEV5?=
 =?utf-8?B?aU51Tzc2Tlp4ZlZwNVd5Vk5RcVNVQ05VajBoaWVFT3NUUWRMVW96SlRJZ2RW?=
 =?utf-8?B?K1lOK3U4VlRMdWE1bUFQZGtDdy93SjdsSDBnM0ZEQUhrU1hCd1B1WkhRa0pu?=
 =?utf-8?B?SmVZY3A5Uk93THhZQlpMSFprdDBvSkdwcUxxVlo1R3pENzU2dlQyeTBIdkR6?=
 =?utf-8?B?VCs0V2dMN2ttQzI1bUtadjdFdTY1VTZSQXJCQlpldDZXa0xqQ3ZaVkxKUHNl?=
 =?utf-8?B?OHNwZlpoeUpuVHFkMGJYVUJxUE05VU9EaTl6N3kwL3o0a1kyeHE1QWJtd2RF?=
 =?utf-8?B?Zm5TQ0JzMWJlYUJLQTVkYkdJanFxSk4yeHh4bDg1TldQZ0k5VFloYzgvbmg1?=
 =?utf-8?B?cDhWdkFuc2cwMU1lL09PY2pIQXpabE5vRmlVQjFxQ1lsQ1R0d3dpYTBHb1dV?=
 =?utf-8?B?dmdWOGpmT1dYUHE1UTVLczJuWi9BSHBtV3FKR0NlWHdodkNaWlQySzQ2bVVT?=
 =?utf-8?B?anhIaUNNMllvejlJL1Jabmx2b1Fwb2VzMXVVRlpLMU04cFZ5RElFNmcveXRi?=
 =?utf-8?B?MzFCc3JvV3dWWldCZ244ZGVWS2svQjBMUUExNDZCZGMvS1NOS0pMNlBCR2dT?=
 =?utf-8?B?WUZtYWFkQjllREFmODFFU2ZBRkZ5aWVwNktkWXVJbWEvUlMzTC85dTMwc3Jk?=
 =?utf-8?Q?29lbDlZuJ+gU88ulVvYZTxxRE?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0b4aa8f-98ae-4603-de66-08dccd083b9d
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2024 17:37:22.5473
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9D3VS/cwl2IYhbvu6I4h0FYcgPDCyF8xq2AfA1B0PZ7XPZzBEcYD6EtO93ZREICffQOzNT9d+J9V39td70mrNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6117

Hello Paolo,

On 9/4/2024 5:29 AM, Paolo Bonzini wrote:
> On 9/4/24 00:58, Kalra, Ashish wrote:
>> The issue here is that panic path will ensure that all (other) CPUs
>> have been shutdown via NMI by checking that they have executed the
>> NMI shutdown callback.
>>
>> But the above synchronization is specifically required for SNP case,
>> as we don't want to execute the SNP_DECOMMISSION command (to destroy
>> SNP guest context) while one or more CPUs are still in the NMI VMEXIT
>> path and still in the process of saving the vCPU state (and still
>> modifying SNP guest context?) during this VMEXIT path. Therefore, we
>> ensure that all the CPUs have saved the vCPU state and entered NMI
>> context before issuing SNP_DECOMMISSION. The point is that this is a
>> specific SNP requirement (and that's why this specific handling in
>> sev_emergency_disable()) and i don't know how we will be able to
>> enforce it in the generic panic path ?
>
> I think a simple way to do this is to _first_ kick out other
> CPUs through NMI, and then the one that is executing
> emergency_reboot_disable_virtualization().  This also makes
> emergency_reboot_disable_virtualization() and
> native_machine_crash_shutdown() more similar, in that
> the latter already stops other CPUs before disabling
> virtualization on the one that orchestrates the shutdown.
>
> Something like (incomplete, it has to also add the bool argument
> to cpu_emergency_virt_callback and the actual callbacks):
>
> diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
> index 340af8155658..3df25fbe969d 100644
> --- a/arch/x86/kernel/crash.c
> +++ b/arch/x86/kernel/crash.c
> @@ -111,7 +111,7 @@ void native_machine_crash_shutdown(struct pt_regs *regs)
>  
>      crash_smp_send_stop();
>  
> -    cpu_emergency_disable_virtualization();
> +    cpu_emergency_disable_virtualization(true);
>  
>      /*
>       * Disable Intel PT to stop its logging
> diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
> index 0e0a4cf6b5eb..7a86ec786987 100644
> --- a/arch/x86/kernel/reboot.c
> +++ b/arch/x86/kernel/reboot.c
> @@ -558,7 +558,7 @@ EXPORT_SYMBOL_GPL(cpu_emergency_unregister_virt_callback);
>   * reboot.  VMX blocks INIT if the CPU is post-VMXON, and SVM blocks INIT if
>   * GIF=0, i.e. if the crash occurred between CLGI and STGI.
>   */
> -void cpu_emergency_disable_virtualization(void)
> +void cpu_emergency_disable_virtualization(bool last)
>  {
>      cpu_emergency_virt_cb *callback;
>  
> @@ -572,7 +572,7 @@ void cpu_emergency_disable_virtualization(void)
>      rcu_read_lock();
>      callback = rcu_dereference(cpu_emergency_virt_callback);
>      if (callback)
> -        callback();
> +        callback(last);
>      rcu_read_unlock();
>  }
>  
> @@ -591,11 +591,11 @@ static void emergency_reboot_disable_virtualization(void)
>       * other CPUs may have virtualization enabled.
>       */
>      if (rcu_access_pointer(cpu_emergency_virt_callback)) {
> -        /* Safely force _this_ CPU out of VMX/SVM operation. */
> -        cpu_emergency_disable_virtualization();
> -
>          /* Disable VMX/SVM and halt on other CPUs. */
>          nmi_shootdown_cpus_on_restart();
> +
> +        /* Safely force _this_ CPU out of VMX/SVM operation. */
> +        cpu_emergency_disable_virtualization(true);
>      }
>  }
>  #else
> @@ -877,7 +877,7 @@ static int crash_nmi_callback(unsigned int val, struct pt_regs *regs)
>       * Prepare the CPU for reboot _after_ invoking the callback so that the
>       * callback can safely use virtualization instructions, e.g. VMCLEAR.
>       */
> -    cpu_emergency_disable_virtualization();
> +    cpu_emergency_disable_virtualization(false);
>  
>      atomic_dec(&waiting_for_crash_ipi);
>  
> diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
> index 18266cc3d98c..9a863348d1a7 100644
> --- a/arch/x86/kernel/smp.c
> +++ b/arch/x86/kernel/smp.c
> @@ -124,7 +124,7 @@ static int smp_stop_nmi_callback(unsigned int val, struct pt_regs *regs)
>      if (raw_smp_processor_id() == atomic_read(&stopping_cpu))
>          return NMI_HANDLED;
>  
> -    cpu_emergency_disable_virtualization();
> +    cpu_emergency_disable_virtualization(false);
>      stop_this_cpu(NULL);
>  
>      return NMI_HANDLED;
> @@ -136,7 +136,7 @@ static int smp_stop_nmi_callback(unsigned int val, struct pt_regs *regs)
>  DEFINE_IDTENTRY_SYSVEC(sysvec_reboot)
>  {
>      apic_eoi();
> -    cpu_emergency_disable_virtualization();
> +    cpu_emergency_disable_virtualization(false);
>      stop_this_cpu(NULL);
>  }
>  
>
> And then a second patch adds sev_emergency_disable() and only
> executes it if last == true.
>
This implementation will not work as we need to do wbinvd on all other CPUs after SNP_DECOMMISSION has been issued.

When the last CPU executes sev_emergency_disable() and issues SNP_DECOMMISSION, by that time all other CPUs have entered the NMI halt loop and then they won't be able to do a wbinvd and hence SNP_SHUTDOWN will eventually fail.

One way this can work is if all other CPUs can still execute sev_emergency_disable() and in case of last == false, do a spin busy till the last cpu kicks them out of the spin loop and then they do a wbinvd after exiting the spin busy, but then cpu_emergency_disable_virtualization() is/has to be called before atomic_dec(&waiting_for_crash_ipi) in crash_nmi_callback(), so this spin busy in other CPUs will force the last CPU to wait forever (or till it times out waiting for all other CPUs to execute the NMI callback) which makes all of this looks quite fragile.

Thanks, Ashish


