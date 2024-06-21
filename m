Return-Path: <kvm+bounces-20305-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 002AE912DC7
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 21:21:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A0AA31F230E1
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 19:21:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00BA417B4F2;
	Fri, 21 Jun 2024 19:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="d6DX0kfk"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2070.outbound.protection.outlook.com [40.107.100.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 245DC4644C;
	Fri, 21 Jun 2024 19:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718997702; cv=fail; b=lkp13T5uC3zVHWYHzrWIi70qBpJn0YBy2J6l3grw6oDFNDCQkFRQJ2ZiSNHe00wn5FTrjM5uD2nEMsEGflszE4jPbsbX4WJ3WmrC8a76df01WAj3t6JWtHS9huB3Q6u55swHWN1w5KBdXjRH2x9Ydb6UCL7+aVmc9tnFdPG2o64=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718997702; c=relaxed/simple;
	bh=YFxVVczuhrJrVbND59592X2vd2l4dl1m85rSqRBbkb0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=YLuKRfu+Zu/Ttwe7cCSUOhBBa4UfAU7CXt3OcJQXde0jsMUmF4xwL9KlEPR2TP0PgqYbm1y6oBOWxQsS/hByk/Rah2iECuony5pVHmvPenm+mngr1zYFSdZEcpjyAx5lKFqokvhN7qOYT/4p2YR/gv4P0yBL2bqX0fHHgNKqmas=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=d6DX0kfk; arc=fail smtp.client-ip=40.107.100.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IdKG8LTXtJbzOBTASkwZZYyxK6leZT07TUSwRXoZFR1vLHmifR3DPRhMjfsfRu+f3iJKKhBNDShGyOrhMMHoSAasoQJfeEL9t8x8o1lWNd8FUx33rApdaOTFHLFrLm2LgwvhtngYzUGwi978FCQn2dA24jfzvWXw3M+J4xpQD28nVa0jyYoBkSAgqRgf8ieE+yh+Pv0L1tNQkU2lQS821RHwv+OihHSz8skatKqD9ibTAn/fJDJC5ZrA0OO83Z4UUTnwWguu3KobitIrHMedu/MrPI3y0Y5+j+CNn2ZgdnSw6J/xyto4hOOHieK2T2qCDSbFCEMJZKG4CgJnMqt68A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KGnq1w1iZyJtabHV3/Y1fH6rE5/G1/ikocKH3iS7VxE=;
 b=Klo/h6Fs0SSSuJ6jqRHp7Vxyty35+2stHOcNzsdonrvtcRx/6XSvAEngKif4+bOm+0P5RXbolReYServxEYKgS3qS3govEUYTVseSgdoi5Zm3meim9wzYERK9nvzpvjJtMnTybIBcucBpHqknYD/LwmIot9QQGW3yYPqEQcvQWruoD2p/JRjMLRf48m/8rvxFN6PxlXzT0ouLTHRFj1f3VqYUN0/vp5k1NWnSdiyJ9jM3KXP2u4YFK1K+yjVRpj5s0PCya4Vq/lI5stfYawARNGPDAjOvxmPIcaISh9vTpSgB1nJH/OouH003oQ9P0QNRoZblTPdfuGwZunr3bmm3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KGnq1w1iZyJtabHV3/Y1fH6rE5/G1/ikocKH3iS7VxE=;
 b=d6DX0kfkH26I9l/LrXxrFcqnJobo+IlMnB7qHZWqY3JIiuzvQffmPsvf+M14WL5rthaEtKK0j99MoZbb7Nv3pIj0MCcJnBWVQY9jBDtlNjnaE3ANA0M7vapf7CiZ7FIY/ZroO9fRlymeueep2lva88DglYrSWeju9Md/NvFOJgM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5732.namprd12.prod.outlook.com (2603:10b6:208:387::17)
 by SA1PR12MB5672.namprd12.prod.outlook.com (2603:10b6:806:23c::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.37; Fri, 21 Jun
 2024 19:21:36 +0000
Received: from BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::bf0:d462:345b:dc52]) by BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::bf0:d462:345b:dc52%7]) with mapi id 15.20.7698.020; Fri, 21 Jun 2024
 19:21:35 +0000
Message-ID: <495cafc1-9ba0-5dba-4eab-8f8f04beb48b@amd.com>
Date: Fri, 21 Jun 2024 14:21:35 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v1 3/5] KVM: SEV: Provide support for
 SNP_EXTENDED_GUEST_REQUEST NAE event
Content-Language: en-US
To: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc: linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org, x86@kernel.org,
 pbonzini@redhat.com, seanjc@google.com, jroedel@suse.de, pgonda@google.com,
 ashish.kalra@amd.com, bp@alien8.de, pankaj.gupta@amd.com,
 liam.merwick@oracle.com
References: <20240621134041.3170480-1-michael.roth@amd.com>
 <20240621134041.3170480-4-michael.roth@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20240621134041.3170480-4-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR13CA0168.namprd13.prod.outlook.com
 (2603:10b6:806:28::23) To BL1PR12MB5732.namprd12.prod.outlook.com
 (2603:10b6:208:387::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5732:EE_|SA1PR12MB5672:EE_
X-MS-Office365-Filtering-Correlation-Id: d5ee2b9a-8c60-4964-709d-08dc92275e00
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|1800799021|376011|7416011|366013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?M2M1RW5DQkZqeFZZVFdqQjFlVnVCOU8rS2F2eWNiNXJKTmNySUJjUnpUcnZy?=
 =?utf-8?B?NnNaZmExbGJlMUpOV0puMjVVaFkwSXZSN3hhQVZmQllVcEJwZWdERy93ZW5G?=
 =?utf-8?B?TFZhSmlNamhXZURrQ3NDWUovQWQyQ3JqbUdNakF1U2hIalBhTWgvQVRDdjNB?=
 =?utf-8?B?amtoZUg1VHgzTE9UT2k2R2c2VEtUaEFDOEppSWM4NDZTNmxNQm5xTnlvMUV6?=
 =?utf-8?B?UzNEYzNweUo4NzNWa2d5OFpnemIzOUVITXg0SUtIajdhS2JQMGdBMUNCcjF4?=
 =?utf-8?B?djIxcURvQmlBVWFHWFFZQnp6aHZPU3Rra2gyWWhiLzZxU1QveklSQ3M0V0or?=
 =?utf-8?B?a3MrTFgwRW5ETmtXR0s3NmFCREV4VnloMFZQVDQ3K09HNTN1SjAvN3d1TEIr?=
 =?utf-8?B?SEFRK2tRT0tjNEpkN3pSU3N3bjF1dndTSmJaVUJmbjc3dU1jRGhxd0xad1ZG?=
 =?utf-8?B?K1dSWElDSnZvd013TWo0a1piaitpVnpVTHlOMnZiWTRkMTUydmpZRnJnRjd2?=
 =?utf-8?B?M0dibXRqWUtKQ2ZMUUdmQktlaCtQUlZ2U2c4K2p0SVpWcGdrY3J6Wml5TjF2?=
 =?utf-8?B?c1ZaMWVkeXZLMEI5V3lSbkh2Vk0waHh4S3lNSGRscWpjOFp5UHE5VkZncU5S?=
 =?utf-8?B?SXR6bmgwdXd4VUZhNm1ReGxuOEhoeGZ3WXBlMDBuSjJzUis2enQ4enpOYVJn?=
 =?utf-8?B?VmlGdUZaVmtpMS9iZ2tWOGtXbFE1SW1xamE2RXd2M2hoOVJwSWY3SFZKWk1C?=
 =?utf-8?B?RFhPb1Q0cm9rWXZkZ1NnZUZoL1A2cnl4RTFlOXBCY1lnNkszRnVFQWNlVUlr?=
 =?utf-8?B?RGczcWdJL215bGVoUTIvcWkycklSSUdiZVp3SnpPaFd3N3V0a3VsN1JUck9G?=
 =?utf-8?B?cDNwK1RFM2NFbXNvR2xkanhQZU9WNmxNeVNJRm9iQWxNamd6c0dUOEFkS1Vz?=
 =?utf-8?B?c1N5ZWhBanI5dVNMTHg2eTBGSzlyL080M0VEa3p2emlZaU9iVnJWalBQdXBG?=
 =?utf-8?B?R01laUtGU0RnQXdZN1FxQnhNWHpVVmlWQVdhcGhQMGZKeWVZL3duRFZoakRx?=
 =?utf-8?B?TVNRckhId2M2RGJWOFFBZEJ6VlJZS1lIeEhob0dNMGVzOFVkWXdlMEJPRWxl?=
 =?utf-8?B?RktSV2pma0hRYmdMeC9hTDV1NVRYSUFDSE5mdTF3QmhlU1dmTXN2b05KcG52?=
 =?utf-8?B?UnZ3bTVnMk5tSG9KU290blhkbVNVU1NsUVlQT2Z2VXhnWFZZbzJoNG55aDBm?=
 =?utf-8?B?OEhSU3lTdFZHQ0pzTWR5bHlsZXdsSCtnSzkwZSs0NUl3YUJLYng3LzhTU203?=
 =?utf-8?B?VFRnbG9pd0F6ei9XQW1wWU41cGZrTEw4eGl2UE1PMXkybURFNlh1b0puSGRi?=
 =?utf-8?B?TzBMMFFqek1ZSVFuR2pBK1A1ZUZheHJmZHcxZUxWcVpHTUtabG5WNFl2dnYv?=
 =?utf-8?B?QU9jT2lwNDM2Yk1uUklvNHVMS3RYQ0xUZkpQZTJXRzZwYUxjUVpFVm5OQjNO?=
 =?utf-8?B?aU44YXVSM3d0bTdzWDlnZlcvQ2pGNVovVVN5MXpYY2p2NWtHeDYreXZvSTgr?=
 =?utf-8?B?aGlJZXQ0OFdKUWltUFdqRTB5YzRlMFlHQ1ExczZET2pVY1dGQ1kyMWlISmpt?=
 =?utf-8?B?U0hieDNPRlRmcmp0RXFRUE9iWFR1aUtGT3FPTG02T0wzdndKaGJ5SUJ6NmlB?=
 =?utf-8?B?UUM4dmJJM2MwU21QbUFBaWt0WnBoZFYyMHFWZEpWWnlwYmlTS0NSVG4zYnY0?=
 =?utf-8?Q?3fNekkHt92+yaPPoEKWu+sTBCfJXsn/0xmZI7Bt?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5732.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(1800799021)(376011)(7416011)(366013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b0t3c2oxbys4RkYzQ1J4TGVTVkh5emZIZXhIeHovR0FjdjdEemR3RDY4N3Mv?=
 =?utf-8?B?ai9Jc2Z4eDdCNEE2U0lZZnRDeTNkaDM4VXEveVViellUVlhFWGd6QldVT0tO?=
 =?utf-8?B?RXk0WHFtVjFtdnhFem5vc0JSVjhneUJIMDVCTVRhaGJ0YkhaTjdaMEk4QnVy?=
 =?utf-8?B?Z1lqSmxnMFJnTy92K0Y0YnByUWNoUHZFb3Q3VlFCT0lpenlFMkpvOGxOUUlB?=
 =?utf-8?B?N2hYdmUrZlpDektZd3MwbHB2Qnp6ZklNQ2s3eVk0R2FqNmJ5KzgyZXp5OGxM?=
 =?utf-8?B?eUVRNzVxeFA2akY3Q2ZXR3JCdVBuN1FrVXMwV3JmcktIOHVKUnM5U1pVNEk3?=
 =?utf-8?B?T21idG1DUlUrM1pXblNmdEtJWmpPTG5vWGlENFNsS3dvZ2lXUEZ5bk0veDM3?=
 =?utf-8?B?Z0UvdzBvcVZiTkptbTRZdmpyMGN4SzBzL2F5WFRCWE12U3JFeTJ0cW81bFhX?=
 =?utf-8?B?VEFHbEhFUlFMb3YvTnpaSy9KT0IvODluSWZCbEE4OUY3Y1NsM2xUUDRlVXYz?=
 =?utf-8?B?WUlzUmJvWnF4cGJ2VVdKa3ZMYVVLc0NzcFJCSlI3NmxRMHE0c1JzV0Z5MEtu?=
 =?utf-8?B?REs0MDdOOE5SOGlWV3MvdFJLWmRvQ3hjYkRCMmNKZUxYSUl5Y1FGU2lIQkRF?=
 =?utf-8?B?Q3hmUmNpZFlGbkJHRjBEREJOZDRSaTJMOHRTK1pDWW5kYXdTTFNCZDBPc093?=
 =?utf-8?B?WFNYMlBqdTJocnBseStrRE1heXROVDl5Qnd5NE4ydjQ5TWgzWjdyY3prayt6?=
 =?utf-8?B?U09ORkhEaVR0U3d4REIxUlBzejczbnVQSmc1UzRNNlBaL0RmZ0RiY1BPb05t?=
 =?utf-8?B?OXFBNGNNZGFSaHo2SHc5VXVYdFphK0FIemJsQmdoRzd5QlFQNGdpcWJ0Sng2?=
 =?utf-8?B?amhzT20rQ29FTVViRCtQR3F5dEZLMG5kMmszT2RtcmtwMk9qQzVsaC9iVmt5?=
 =?utf-8?B?SWJBK0xtVkc5ZkF5elRpcmJrWTJxTDh4THhRKzZtRjdNRi8ya28ySHhOS2ht?=
 =?utf-8?B?YnJaUGZhWTJ0SnhPS1ZTY1pXV3RZNE8xRHZEekRsVHNIQlNSYTQ0cThncnRx?=
 =?utf-8?B?OG53ZEZoV0R2Z1NkcDF1RThXdjNtV2pVY2NnVXVXenA1cGs4enNXSlZKOUlY?=
 =?utf-8?B?bWhlY1I4V2kwSzZCbTRtcEhNRGFYWW9nQXFvN1BjbGdNSkdUcVF0dzJGNGJk?=
 =?utf-8?B?d1dFdnFVckFwSnI0OTdxZ3FrNjM4UWsxME1aSjhGVHBvRklqLzBabWFETjdY?=
 =?utf-8?B?RXBmZFY3bmJrRm9ScHE2RndtNnd6b1RJK1BlQkNaODE3OHoyS09xUGpmSlZW?=
 =?utf-8?B?TFl2U0JucEFhQ2NCazVCNXRkemJHMi92NzJqRTBmY0VpUUw1Q1lYano0R0tL?=
 =?utf-8?B?b0g0bVgvNUVGMGFHNCs0Uy9KUHhQK3lUNDFyeWtWb2Fuc2RxS2ZCcWtqc2Rv?=
 =?utf-8?B?NXJZRkhBSnZIUVhCd2RlZGRXQUEyV3hwWm1MZzJoTmpQeXQrajlMemtkL0I3?=
 =?utf-8?B?cFhKYnJ0bFRTYTNZNFNlY1JuVS85dXlpYTA0VFlZNkRqcmhSZDhYb2pEQ2d1?=
 =?utf-8?B?TFFvbUJUSHFJeTErNzM3b28xeG5la0g2VlZlQ1kxck41ZnlOVllWZVh6bXV2?=
 =?utf-8?B?SlNQRi8wWnRjb2ZNc0xVYm1HQVZZc0JPVG9jeStsZmtKWUVlemlCTzZkZldT?=
 =?utf-8?B?Mk9ud3g2TS9xRHVrNG5DOEdaYlhxL2JsbHhoN1krVW1hVUJXM1liYUthZHhW?=
 =?utf-8?B?MG9waStCYWJSUVlTaGdWQS9IOUJLS3Jrb3RqVUV1RDBwdUN5VWZ4QkNzK1Vm?=
 =?utf-8?B?c1ZFSEV6R1pCNlZwVk9RZDZTUGxCVWFHMTRFZ0NIbVllRnBnMWlQWTdJTytt?=
 =?utf-8?B?ZzZVTlA4ck9LQzBPbklrL3JvZjUxKzA1VXNBODRaQmNKQjNUWVplOG1YaVNr?=
 =?utf-8?B?aUZ3OHNwcTNCYktNcit2VkoxNTNhV0ROMGg2QjVMSmRsNkVyUjd2WGZpY1pZ?=
 =?utf-8?B?eGV6V3l5TnR1a01ZWXN2Q2lBUnJjVUNHWnRXc0dwRXdYWEkwRHJ0VlVTOGJ1?=
 =?utf-8?B?dlFBQ0QvYWVVMThzYklsZGVmczBUSmFxbk16a2YxQXNheU1OVTlUb2RqU2lv?=
 =?utf-8?Q?Ls/6eqoD3DKZ94fxKCZ2rO7EH?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5ee2b9a-8c60-4964-709d-08dc92275e00
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5732.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2024 19:21:35.9578
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u5vDdv/ORHAzZL7jGIr7NtGX3jeVAKWOV+oHr/0oE0vnbS/IIC22iYo7O0qJu1cUlyAmMcauiyCg24uDzHOMWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB5672

On 6/21/24 08:40, Michael Roth wrote:
> Version 2 of GHCB specification added support for the SNP Extended Guest
> Request Message NAE event. This event serves a nearly identical purpose
> to the previously-added SNP_GUEST_REQUEST event, but for certain message
> types it allows the guest to supply a buffer to be used for additional
> information in some cases.
> 
> Currently the GHCB spec only defines extended handling of this sort in
> the case of attestation requests, where the additional buffer is used to
> supply a table of certificate data corresponding to the attestion
> report's signing key. Support for this extended handling will require
> additional KVM APIs to handle coordinating with userspace.
> 
> Whether or not the hypervisor opts to provide this certificate data is
> optional. However, support for processing SNP_EXTENDED_GUEST_REQUEST
> GHCB requests is required by the GHCB 2.0 specification for SNP guests,
> so for now implement a stub implementation that provides an empty
> certificate table to the guest if it supplies an additional buffer, but
> otherwise behaves identically to SNP_GUEST_REQUEST.
> 
> Signed-off-by: Michael Roth <michael.roth@amd.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  arch/x86/kvm/svm/sev.c | 60 ++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 60 insertions(+)
> 

