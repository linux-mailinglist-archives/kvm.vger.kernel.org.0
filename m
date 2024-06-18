Return-Path: <kvm+bounces-19891-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9258990DE03
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 23:11:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4261B1F23361
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 21:11:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD060176FBD;
	Tue, 18 Jun 2024 21:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="xxi0Ov/o"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2063.outbound.protection.outlook.com [40.107.93.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6862B6BFBA;
	Tue, 18 Jun 2024 21:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718745069; cv=fail; b=mUifCg/ocy5Fz5zo108TOK9XeG8WvW+UDYerpU2KdosnfpvTbUexVuYKznYQNCoK5BT+6XF9rVEcP0l83ony1Cg0v9KWRG9kKqM8racnLWffA7H5md/APGadcnUkVh4I12VP8v3zAndkz4P/5tODpV5qLuv2n3PMP+akbgdr7J4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718745069; c=relaxed/simple;
	bh=wkAMdR0N0z4W38MJYu7pGA1GRjADXCw+wXijfbrCd30=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=JmmJ7RRicoaCdKtVgruWSEMxNx5yiRQU2jIW3MUrvf3wIfKoEhmQfcq5SPH6YgJp0OnEDDEmzaVk3lR6rDGrGQA0deVYuC18xzg+p09dZTc06MS0GefSmbbnCZaHEfLQUT3+4/DIijUZL7cFAgodCYv7dKyDdZvmjnquk7VzyOo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=xxi0Ov/o; arc=fail smtp.client-ip=40.107.93.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ua2ZTGbuZeLxr+D9TAD66JdsNaG+8r7XcrP7WnqOfkg6ely6lXPsyZm/k9rqo/brMSAtU0zfhn5i9uzptCuA0tvkHv50bZauNpqZQojH+aJm0wSeaXkp5vfsAqWtPz5R/JncPCkJeH03NA8Uw6fIrwEtfsBGkZXu7zM3RTJ8BCk/ZcQFbebRh2CkeePXfnL/1/ALXdkqABBq1c8URmBTy/VDgpLPfzSNaZYLgAVUIxKVU9f8ceq9tdQvCf+p+UmKvMpi5z1++DFtMORMvHHzHKbXqJFPIATITJAxqv7jp6mJcnG2hor5yz4lq9SP8FRWDj3i+tUzoecPsCqYxSQ0iA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LGTeHoGoTKB9BzmBIpdm3dvVTnKfQq0AK8o4a6oTsw4=;
 b=IQVsAQ1Fl6DcPLE7yaq1bQ3KwjNgtTzWBpsJYwifKi6xc4Yoezzgf/Qg2fjngQjDZCJ8jaUd1xIKBJJ+M4reLuUfe8yijg7xd0dQwrTHvLbbrFNOHRm73wAn7Xh0Yf7JJtUfrm5nHG0H4Kn/y4AUEMGdE3QOJwSAbOyIdrxjid/vTOGjtqY3jx+pyvcHRKAAIWRCMVN18S2KhkCLhUoE8mNd7bBt0nN23QhW3e8R6SYp3GFg69eHS5JQw9/fUCf6A0s4PpS9kTUN5X/BPNHLr14mxU2MBPsF5o/u7wgBH5G9+mPmZYuzEM46FcDq39nYjBg/+eaCeygqje4gOuxQUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LGTeHoGoTKB9BzmBIpdm3dvVTnKfQq0AK8o4a6oTsw4=;
 b=xxi0Ov/o6yVGNh/g47ZQysdMTKTeuLXgnYiCR07kPybhBiMmcfhI4u6UveBOGWcPGkWoU8ruOMJzXv4PXXLMW560czxVgFq+dmU9CwuV85p7qPUtyGxICrLk7osW9+AWdwA1vkxAIOUPfA9/VVjRuCX0eLC7tQNEiwsLzLaHAN0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5732.namprd12.prod.outlook.com (2603:10b6:208:387::17)
 by CY5PR12MB6478.namprd12.prod.outlook.com (2603:10b6:930:35::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.30; Tue, 18 Jun
 2024 21:11:04 +0000
Received: from BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::bf0:d462:345b:dc52]) by BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::bf0:d462:345b:dc52%6]) with mapi id 15.20.7677.030; Tue, 18 Jun 2024
 21:11:04 +0000
Message-ID: <b4da8dc1-17ea-52da-c8f4-76a8bb6acb16@amd.com>
Date: Tue, 18 Jun 2024 16:11:01 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v9 05/24] virt: sev-guest: Fix user-visible strings
Content-Language: en-US
To: Nikunj A Dadhania <nikunj@amd.com>, linux-kernel@vger.kernel.org,
 bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
Cc: mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
 pgonda@google.com, seanjc@google.com, pbonzini@redhat.com
References: <20240531043038.3370793-1-nikunj@amd.com>
 <20240531043038.3370793-6-nikunj@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20240531043038.3370793-6-nikunj@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0027.namprd11.prod.outlook.com
 (2603:10b6:806:d3::32) To BL1PR12MB5732.namprd12.prod.outlook.com
 (2603:10b6:208:387::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5732:EE_|CY5PR12MB6478:EE_
X-MS-Office365-Filtering-Correlation-Id: cd392282-1c35-4c3f-25e7-08dc8fdb29b1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|7416011|376011|1800799021|366013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Vy9MV3B2MmEwZXc2V1MxYXp5M1A0WXdnSXRna0RMMUozb0NmTWRncnlSaEpv?=
 =?utf-8?B?U1UwUWJKd3R3N1dXcGNXcHZpdmQ0clgxbklwbHc4MHZWWjZ5R1ZwWEJ5UEMv?=
 =?utf-8?B?ZU9pbVpsdXJXTVpnYTlyS2VUUG1kMFVKUFppZkdRYTZqZmN6cVZWR1QvNi9J?=
 =?utf-8?B?UXdBMHBYNWRaY1ZsUjhrQnBTeitneWQvdDd6T3V5THRiM0xna1dlVnBkZlRz?=
 =?utf-8?B?b2FBRmcwYjRJVkNYVi94Z0ptc08wSzcreHhLekMvdUJldmVySHFpWjNZbURw?=
 =?utf-8?B?V1g0SFk5ZlkrRFlRU1BNb1JidW4yblRKVUl6NklOeHZzQkk0ZVQ4WFVRWjVX?=
 =?utf-8?B?ZmdJTTRFSlp2d2s2Y3FVcUtqZzBQTVJFcXlUZ0xSL0E2NUZab3h2Y3pSOXMw?=
 =?utf-8?B?U21GdE1pblZJSllnNnQ1cWVxSWRSSEF5RWJPSzJIQjhhUnRqTTFrRlRSckdB?=
 =?utf-8?B?WVlDQlNvUkM0Z0ZXZjlHMlpmT2pHb1REbXl0dWFPOTFCV0dqakpNYnJaN2ty?=
 =?utf-8?B?Q2xHOTBBbFR6R3FpTzdGY0p3Z1R4QXloempNNm5pWDR4YUoxT2JiWjNvL3Qw?=
 =?utf-8?B?K2k2WWgrbWVsUVliWFNZREJLeFlFWE5RR1BIbVVYMFI1eHcvZVhzZTdlcmFy?=
 =?utf-8?B?NHNUdmVPMWM3ZGQxSSs0Z09ndEFlekZLU251ZTRBV3k2VzlyK0VCMXcxbHlr?=
 =?utf-8?B?bytWNHdoMm56L1JFSU9tZm5hQ3lyUXJscW1Nd3ZlVHZXSjNLMlhJbmQya2VX?=
 =?utf-8?B?c0UwS2kxVGlseEhDOHJvVXNaNHp0WTIwb0MvZlhRTVliUVQ2Zk1FVUw2Mi9Q?=
 =?utf-8?B?eStYbmtGZU9UV0tKR0pxeld6MDFhcExCb0hwakt3V1hHTnByNjJvcndkYXJy?=
 =?utf-8?B?ZmxRaWdvZTBuUW9oYUpjVit5c3hETXRTQlRobzhiNTUxK09ZSEZCQ2ZrTCtt?=
 =?utf-8?B?K2M4NVF6Ykk5TzcwanBnMXh5eTd4c2FGR0ZuTjhicVhkYWt6bUp6VGw3dTN0?=
 =?utf-8?B?MUprSDcxSy85clErUkI5dG1EVGg0R29Td0E0Sm9hWUdidjFlWUVXL0tuN055?=
 =?utf-8?B?dmltVWFPekppSjVJdThiM0NUcnpJTWNMSm9CdzFyRGxrdTBSdmZsc0F4eGxD?=
 =?utf-8?B?L1J3T0E3Q0c3KzVvY3FZelhpem9sSUpLeGdQWTVBcHl0d0JtbDJqcElwVnFo?=
 =?utf-8?B?RWFkaFZndXZvNHFkSDNXS204dFNHbXlERW9jT1VhMDJOeVhMaUtEQ0dGTHJu?=
 =?utf-8?B?WWhJTnZhTTYzVitndWVaOXI0N1lhb2RFNXVpSXBqSk9XS1RZVTliOCtWOFZM?=
 =?utf-8?B?YXZJUmhialVRbUVxMjZ1ZjFBMGxid1J4bVl4TTE3QmpDR2FYSGtVRE1xSmhQ?=
 =?utf-8?B?cFFXVTdPSzh5Y2Q4dzQ5YzU0cDQ5bExZa2d5dmU3Y0VXVXhadkg2b1YyQkZC?=
 =?utf-8?B?dk5SNVFuT2hTWmtpTFQ3cXJZWHpNSWs5ZlorOU5XY1poNm03Mng1eDZndFVT?=
 =?utf-8?B?UTg4bU1Tdlg3T1gvTG5FQnVFZUpXbWYzYXRGNUJxaVdpdEdIVzd2ZWtKdDU1?=
 =?utf-8?B?cjZKSFhCb0Jod2c0bTBqVWtiT1BWK1pjemN4MGEzUjNTZFR5NkpxZzJzd3Y5?=
 =?utf-8?B?UWZFVFpDUjRLalFGS3MwanJBdkwzMEgzUWJCTUhBWmJmMzE5RHJrWUU0bzVI?=
 =?utf-8?B?VVFwOWYzd3VMY2lsSlNRN1pqcFF2dVlXRHNyWkV4K29VQmNYc2hYTWF5UVdZ?=
 =?utf-8?Q?Cjtwtvt9tefs4Qb12VHbfyrP/B52NMm4ikwcwsw?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5732.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(7416011)(376011)(1800799021)(366013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bHRZWDhFME5XTzNhSjBESlAySDI0R2xKek9VVTlZV2VUdzAwR0pGaGY2UDI5?=
 =?utf-8?B?V2x2TnNzQmRmcmxBYkhqN2RqTVBjUUdiTzRERi83WGRHUDRIbTVwNUo4UVda?=
 =?utf-8?B?OUNXVDdCdnJVaTNYemFVOFRYOTFaMVN0ZXdMMWZ5N05hUW85cHd3OXgvVm5C?=
 =?utf-8?B?WFZ6dHBKZ25GRnlLQS90bk9MRWlSdldSNnBkbUhWc3N2cndzc3FJcnJYbGpO?=
 =?utf-8?B?ZU5pUEN6WmVVSzFLTFVyMEZxVGJFc1dydEc3eVZNUVN4aVUwcTB1U3FJWFpG?=
 =?utf-8?B?VlZuanFiRUtnSnpEMS8va1N3T2ozVmRPZXJzWGFSL29DZkZrS3lhWXJJQ1R2?=
 =?utf-8?B?M2k4V0tuV2hUV0ZUWnFSSVQvei91a3Z4RGtaYVNGRU5tMUVCTFU5TjF2cjE0?=
 =?utf-8?B?NU12eUtWWVpNeGc0RGVGSytzbkE5Sk1YcU9JVDlBU1VNTC9wQXdPaWVwVzc2?=
 =?utf-8?B?dWZsUDdlZkszY256Y3A3ZmszQzAwSFppaFZpYTFMaldaQTV6cDZlcWxyc2l0?=
 =?utf-8?B?cDJNckwxbFdPTzhvYnk4aTlQNFN1b1NlY2Z0WW5jL0VhMVFLN0l2RkttT0xM?=
 =?utf-8?B?NitNekhRSnkzNEoxZ21qQTN1aU1GcGtOaytvRXd4cEx4L1lXV2ZVajBCa3l4?=
 =?utf-8?B?MStCZXJQMnRZY1J3d0NOZklDaUNxWjBXdlVpNkt1WkxwamNETHN4NUt0V0Iy?=
 =?utf-8?B?RWhLSUFsbTg2YUo3WWovOXAzZU0wMmlrSTJ1VzR0NlAySVRXaFgyN0hNeTN1?=
 =?utf-8?B?S0l6L1FVUWE3ZmtWOE9ubUxOaGs0M0cxbG4wSlI5cHBFd1JHUit2aEVsZEtL?=
 =?utf-8?B?Vkl0Wkg0QW4vUGpyc0UyaXJZNGRhUEZNZXV5WGJXOEdxa2pESkd2enNMNnF3?=
 =?utf-8?B?SGFYQUREMUM0UXVGaDVUUnBocEFRL09Oa09GV2MwaDNYSEswL0htd3hwczlo?=
 =?utf-8?B?Wk9acWViMlJWdi9LamtTbXRRTTFKdDFzVHMrZFl1SCtzUklpODFqMmNVNzVy?=
 =?utf-8?B?Y2x1VVpnMHUrcVdKcEdieFVjcXRVOUt0Wlk5ZzlEN1d1ZWd6Q29hMnlFYXN6?=
 =?utf-8?B?Ykh4L25xV0VOWWNhRkE0MUdwTXdPdDdJS2w5OUdkdHJJY21xcjgzRVlad2dQ?=
 =?utf-8?B?azBjWm5ET2RkQXF1TDBOZXJOdVFLZXdsWmxkclNsSG40NHRhKzhsNTZ5V2dq?=
 =?utf-8?B?RWhvajIzMHoxUHNyTVVNUkF4WjQ0Mk02bERqMkNFUUY1TCtyTU1uUTFWZ0N2?=
 =?utf-8?B?L0J1QmtyckpCS0FxUm5yaVNRQWZDcXhvay9FaVVPRlBwdlF1SkEvRTRQUHRF?=
 =?utf-8?B?Y09NcGpLME1Yc01IUkFxbkJoQ2Vvd1lGaE5EcDFoejRmU0RFZHpxbEdybEtk?=
 =?utf-8?B?M2RsTXUwSjFMY1g0VnNEWVNPamNlU2ZvNXhOSjBabzArUkZ3Ymh5cWhKR1Vn?=
 =?utf-8?B?ZEw1TGJURC9xc2FZWDR5QWErVm0wYVpDL1RLamViaWdWSDZmalpVRU5CU1V2?=
 =?utf-8?B?b2doeXQyMUxsM2NsRXBSMWF0RFE5OFFtaTlsMVdaMzRPN2JxYVorNjEzNmlh?=
 =?utf-8?B?SFhXaVBGeWRLRHhERkQ4RlU5N3FxZkNhWVRCZ2Y5NEJoN05OaU9hSDAzUGgr?=
 =?utf-8?B?MjJQaHZiakt1VFZQMDJxR21tWWhtL2J2cnNSWWgxUHU3dEZ3anVIMGlrUFdP?=
 =?utf-8?B?ekRZSUlmdG5qMkt5MVd2ZVFQTkNaV2t1Ym8vYVVDdWhpOHZZVnZPMXNUNU9J?=
 =?utf-8?B?ZGlnQW05K21Wb21DUnJUQ2VidlpyaGptR1p2Znd1aU1sZXU0WStucjlkbnBE?=
 =?utf-8?B?SjIvbEEzWWhITng1Qm0ybTQ5bTBFUnE3VkF5U1kwVmFlN0l6MkI5T2ZqTmV1?=
 =?utf-8?B?R0pOdzhPakNucWF5NmJXMXdPYklvaU05YWMzVVB0WHdMUVlOYm1zbUFETE5y?=
 =?utf-8?B?TkhYcktNOHN2dXdHNDl0VVNwNWVGaW55V2NUeUVseFdJQTR0ZW1lalBGdUYx?=
 =?utf-8?B?YzR6bXJDWUlsdDZwNkVQOHZtNWdwWGZ1RUhEVjl5aFVKTzJwV1VaRnBvaWlO?=
 =?utf-8?B?T3lQWEZZMVpkWG41SVJnQm9vWVE0T0Q2cG1hQ0htcXN6dTgzWEpRRkZGeVpF?=
 =?utf-8?Q?4535Qgf6oufdqei4J3t/V4zUY?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd392282-1c35-4c3f-25e7-08dc8fdb29b1
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5732.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2024 21:11:04.1131
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PJCthnsqgge13rY6BRjW/4wCCUw/Ik01RGNnOBRPH7aWODA59Em64nP5gqNWYtBqP5Nx6puzRi9yVo5qVHbi9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6478

On 5/30/24 23:30, Nikunj A Dadhania wrote:
> User-visible abbreviations should be in capitals, ensure messages are
> readable and clear.
> 
> No functional change.
> 
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> ---
>  drivers/virt/coco/sev-guest/sev-guest.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
> index b6be676f82be..5c0cbdad9fa2 100644
> --- a/drivers/virt/coco/sev-guest/sev-guest.c
> +++ b/drivers/virt/coco/sev-guest/sev-guest.c
> @@ -95,7 +95,7 @@ static bool is_vmpck_empty(struct snp_guest_dev *snp_dev)
>   */
>  static void snp_disable_vmpck(struct snp_guest_dev *snp_dev)
>  {
> -	dev_alert(snp_dev->dev, "Disabling vmpck_id %d to prevent IV reuse.\n",
> +	dev_alert(snp_dev->dev, "Disabling VMPCK%d to prevent IV reuse.\n",

You use "communication key" after each VMPCK%d below. I prefer this
shorter notation, but whichever way it goes, they should all be the same.

Thanks,
Tom

>  		  vmpck_id);
>  	memzero_explicit(snp_dev->vmpck, VMPCK_KEY_LEN);
>  	snp_dev->vmpck = NULL;
> @@ -849,13 +849,13 @@ static int __init sev_guest_probe(struct platform_device *pdev)
>  	ret = -EINVAL;
>  	snp_dev->vmpck = get_vmpck(vmpck_id, secrets, &snp_dev->os_area_msg_seqno);
>  	if (!snp_dev->vmpck) {
> -		dev_err(dev, "invalid vmpck id %d\n", vmpck_id);
> +		dev_err(dev, "Invalid VMPCK%d communication key\n", vmpck_id);
>  		goto e_unmap;
>  	}
>  
>  	/* Verify that VMPCK is not zero. */
>  	if (is_vmpck_empty(snp_dev)) {
> -		dev_err(dev, "vmpck id %d is null\n", vmpck_id);
> +		dev_err(dev, "Empty VMPCK%d communication key\n", vmpck_id);
>  		goto e_unmap;
>  	}
>  
> @@ -911,7 +911,7 @@ static int __init sev_guest_probe(struct platform_device *pdev)
>  	if (ret)
>  		goto e_free_ctx;
>  
> -	dev_info(dev, "Initialized SEV guest driver (using vmpck_id %d)\n", vmpck_id);
> +	dev_info(dev, "Initialized SEV guest driver (using VMPCK%d communication key)\n", vmpck_id);
>  	return 0;
>  
>  e_free_ctx:

