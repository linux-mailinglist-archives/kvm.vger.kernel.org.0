Return-Path: <kvm+bounces-33864-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B0639F3621
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2024 17:33:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DFF721632F2
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2024 16:33:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A119201249;
	Mon, 16 Dec 2024 16:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="FXfZy/Mt"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2046.outbound.protection.outlook.com [40.107.244.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5031126C0D;
	Mon, 16 Dec 2024 16:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734366694; cv=fail; b=T9e6gkMZVTGI+LwJ+DqlF1geIHtlz3ejVSeOesSONaCY2U7t/XqE/x6B9/4NDTH7e56MKscgOHpd1tW0K7dsAlr8hWA2uGEfI4mtJyPEAX2cE6BI1bXN10Nkq9QPRr1nBCKawCJKP0LIlB2yn6Z7NxDqPSNcMcBrdJD2tk7cZ3U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734366694; c=relaxed/simple;
	bh=GZJhLHrUDtg9qswpECpLxwLXAp6Jd9+pgZuiTInUEkg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=JszJlviq0m5GWfJRaoArNW+N4CqHBwNQ/Ix0khj7ZA0c6Gv37ttsurRsRtxgMUbWhiDazqRnhxefpQe/qEoridEqS7zJMNqjStGrkmb/4wuvPPeIjT2cOISliZIpauGbJnqqVqxDF1cQ6Jz2hPPWSlfJCYQuxsfNdXRvCqKl9So=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=FXfZy/Mt; arc=fail smtp.client-ip=40.107.244.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vCPPUeuJzOZswVpGy+JQ87k2y1Xx4PQY8X45L64wfniaHorG3W74BK64YCYW2u95iinGF6gjMlpwoYtTpiuhhXYytwmgyKqm1VDIuLvN5+l/l6p83cvMReeIOEVilt8rZo/YFe4Y18WF5XRIQ9LeUaU6ngv6FEuHxapl+MXoGKNIkoJHcVh21MvWO8ZRIht79Gd0Z1rya6p4ignBRNc17VW3zDJJFuyv2qwOAU3kAhKk1pwq9xPG//pCfabx96sJS+w8LVl/jBN71gNhbWL3uRwmZUmkvnWE0P1kwXlWSNBwmOWCbGQpqmVwR8j84YE53nw2NSprib6lsz0j7Xtk3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mj7w/CUM3dzsQh/0Pb4OTRVKQi45t+A8cc9cXT8qwgs=;
 b=Dwx1OgEoV8llo8TTizDdS02HUhxpnSSl28KdFBojVqHqTog1IEhfLNCAgYWAjWan0u1UA8h4ac5fZm/v8amAOKQWP5xu6pVmVYkXh5f41CR9W3NuC58ktBUgNMsX1EwBTvTup0SgDgVv7MY2IJuPiBni6ETv1uwk/2edT/tk1ilCkvTmArbuXxOnJCm5AkEX3M428M9tsY8e9FdXhMb5vpXHdzS3Gi8Srz2nF+2btB12QrpyKFsOHlSqrEQd2ARTRagS6Pw62toHCISaB0Baxt/gvDsFfVzAUqRPJzK3A+RXwa1xAXHPX/x/CxLkgs8yNz8U4rrR/7L1QHrK8wBSDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mj7w/CUM3dzsQh/0Pb4OTRVKQi45t+A8cc9cXT8qwgs=;
 b=FXfZy/MtS1p8lHb4oDYabqetV1pXSsETPMzyvJctrvnTSbRjspyhm5K8ykyKrCvLtiEoHhNscs48/hkwUb1gfhziAaiabX3Cpf959TayqMHoYTrg6OqHpLyXXs7zy6P1qBoMEyvyTzDKp+5cfUrgeh2WaFeNayjq/zoVEdISKlo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by MN0PR12MB5857.namprd12.prod.outlook.com (2603:10b6:208:378::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.19; Mon, 16 Dec
 2024 16:31:30 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8251.015; Mon, 16 Dec 2024
 16:31:30 +0000
Message-ID: <4dc0f6d9-764d-69de-6a4f-ae0f9a4ca7a8@amd.com>
Date: Mon, 16 Dec 2024 10:31:26 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v15 09/13] tsc: Use the GUEST_TSC_FREQ MSR for discovering
 TSC frequency
Content-Language: en-US
To: Nikunj A Dadhania <nikunj@amd.com>, linux-kernel@vger.kernel.org,
 bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
Cc: mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
 pgonda@google.com, seanjc@google.com, pbonzini@redhat.com
References: <20241203090045.942078-1-nikunj@amd.com>
 <20241203090045.942078-10-nikunj@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20241203090045.942078-10-nikunj@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR10CA0005.namprd10.prod.outlook.com
 (2603:10b6:806:a7::10) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|MN0PR12MB5857:EE_
X-MS-Office365-Filtering-Correlation-Id: 830b3ba7-7d47-4a19-5a6c-08dd1def1860
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OFNiU21ic1hjaGtDQjJKQ0dUVFQyK0dKdHBLd0tyRU9vWTdDMmZGY1VsM2p1?=
 =?utf-8?B?bWN1d0xZbm4rSTAzdVVWYStsaXZuSXJrVlpqSTJUd0g4ZU4xOC8wYVZXSWVk?=
 =?utf-8?B?ODhqcnN0cnlNa2hzRFJEQWpjSE00bUZSNlJnc0JUN3lkd01kUHdvNTBsdDIr?=
 =?utf-8?B?elpUcHdoRGNXYm4rSHJaVm0wTDJzMjhXUHFsaGU5aVJVb2YrNkVBOVJ0ZzYw?=
 =?utf-8?B?d3hEZVE0bVhMWUEwUG9Ob3NDM1BqdU9zYXhMMUhUWDdtNkNDNVRFa2tFRHJJ?=
 =?utf-8?B?OWxib0RvemtoL2ZQTHZ5ei9uNFdBR2IvSEp2S0N5TVJyYVNucDJLRHcxVGh1?=
 =?utf-8?B?RjJMRnBXZ2tUaFNGRUpTbFAvbldoVzFBUVkySjVlTXVnOFhVVnEwVVE2TjRN?=
 =?utf-8?B?eFl0ZzVBSVdHQWZkeWdtelN1OXZCVjZsSFM2Vmo0aDh0Q05Ebk1zaWxId2Vq?=
 =?utf-8?B?NkVDRXRLRGsydUtJZ01rQXk0RmlWQUk4Wjd1Mks0S1hIZDJsY2JkeCtwYVIw?=
 =?utf-8?B?ZnJ4SmM3dlJsWkYzb0E3NWc2ejdqdWw0eWVBN0I1Tm1zQ0hvV29odDFSQTdi?=
 =?utf-8?B?TlYyM0hWY3RRZEU4ZWYrL0RYbHQxR25JWHFlckY0d1NyUENremw4dDdSK2VG?=
 =?utf-8?B?TW5iVXBFU2RQZ1Y1c0w0Rk5TeEZERXZObHFtUi8zVm1NczJDZTU4NDZvTXgz?=
 =?utf-8?B?T1R6bUcrdndQYTdkSTJYWFNpVXMxdyt3UjdlMUt2c1V6Tmc4MTdJKy9USHVw?=
 =?utf-8?B?b2dkN2wvMDlvRjhiakk2MTFYRUd5RnlqaXlsT1V1aTQ1Z3RCS2hxbjRGV0tR?=
 =?utf-8?B?OEwwYlFtNjhhdFBpc0k3TWlRbU1ETmtsVDJsK0lTMTk1OWFIaWZSN0VUM0N2?=
 =?utf-8?B?bVowQjkydDk5OXVXNDltSTBWOXF2N3hSZG1wTjBhSzl0ZFN5czIzblU5TE9I?=
 =?utf-8?B?VFh5SnhYUGhDUGsvL3pHTC9JU3JrM3lqQWlRazVLSEtQYWpZQXFVd0c1K281?=
 =?utf-8?B?OHU0NWRYVXFKd2hEMUY1M1U2MFM2RDhERzhlTGI1OEplMVZ6MjVOUFZzc2NQ?=
 =?utf-8?B?Qk5BYTZxSGgvTitKeW41VnlwNERTVGNYdzNHcmtORnc1eE1vcitGUE9XSXFP?=
 =?utf-8?B?VVdXSWNuaTE5OUF6MWZEUGF2dkZiaW9yT1htTVhQOS9UNXNxdVVjb0xsZjUx?=
 =?utf-8?B?dG9ka0dzaGFNT1MvMU5pZVRaNmtWMGZkUm0yUTkrU1ZMOEwrWllOTHVTMFdR?=
 =?utf-8?B?eGIvUDhEb2Y2eDQyR2lEbEdLeTFTeFFXc3dGWll4WEZVbVpYNVpFRm9FclEx?=
 =?utf-8?B?SWc5ZGpyNG52c1BvZDNaY0tiRkNES1BndUgrMVNpc2phVGNJUDFZZG5Uc2VS?=
 =?utf-8?B?V2thYmRoV3QvbVlPTk5pUG9VSUJoVExzckVNUTZvR1VkM3didSs3WUorSDg1?=
 =?utf-8?B?bzlvWmtpU1lkR3VWbTdrQWZMOHZVWndDZEk2UWtEVko1UXpSL2N6ZEd6VFo5?=
 =?utf-8?B?QVNlVC9qN2ZNNzMwNFUwZE03OG1OOE1RMmFKOUQzRlA0NTlaaHpwQW4xWjB6?=
 =?utf-8?B?SFgvYTdFWjgwVXh2TTA0S3QxR3V1Z1BwVDVmNm9HTjJrNGNFL3M4UkdCdngz?=
 =?utf-8?B?U29EUFFScHBaMU1QMXBXM3dJQ1R0UkQ2SEpwV1VmTGlqWnIzMU9MMTFkSFE0?=
 =?utf-8?B?MTh0cmltZlFpR1g1b2hDQU50OXF4U0wyOXJNbkVXeUxibU0rZ1U0VkF5M28r?=
 =?utf-8?B?Q1orQTFOMkhRNFUzQjVFazBKQ0FuZ1hQN0NBdDR1TlFLTlVkdS9CalRsbUlZ?=
 =?utf-8?B?NUxwWGZIdktwZmN6SkRNeHFzRXBwT1NrVC9PcnRoR0dkczZNRWZmc2JPWVpC?=
 =?utf-8?Q?AXyLQesVC8skW?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?amNnUC9RMGk0Y2xZM3paakJKK2NudVJJTlJZb0NzVzA1SEFuUm13S21PRTUz?=
 =?utf-8?B?dlhzV1p3YVVYWkdUREl0bHYxNzFzREZVQytoelpiZjdtTkFvL09rVGljVnhx?=
 =?utf-8?B?YXZiKzZQN2Ruc3ZLWCsyekdMdllmcmlITm9QYzVGRjFCREJaRTNoYjJzRHpz?=
 =?utf-8?B?T3ZqM3ZSWit3UVhqUDBEKzhSeVBhWll0N1pYaUJITDF5VG5kdkU5SFNwWDEr?=
 =?utf-8?B?YkdLVU0vTHdKVCs1L1E4SzBFTWE1akRLV3Qwd09xb1pNZ0NSdEp2N1JjZElp?=
 =?utf-8?B?WlB0a0U2bSsvWFZqRFR0dkQ3QzllbythMkFVN2VTYUtzQnZiblpVZ1BoQlR3?=
 =?utf-8?B?ZnVoOXJHQUpBcVlrQ3VKNmlTTlp0WUhwcDIwemV5OVkyeWxPWUpITjBSMUNW?=
 =?utf-8?B?NE5FTFNKeEpjdUNmWHp5a3dTUFQyc0g3MHljYXVQK2pHUCtvdzVGeThmMHpJ?=
 =?utf-8?B?TE12RjRJdDZtWktoNXdWcG9OTE9TdEV5bUg5QzlSemV3Wkxvd3BEN214ckY2?=
 =?utf-8?B?UmsveFhxaXRoTTRRdXVwcUh3NjNaRFhCcTFMVEtJNHN6SXViK1N2SFNROTMy?=
 =?utf-8?B?RE4vVm5Ydyt6dXZXVTRPWkFIaWdxYmZiL2NGd054dFJpTG5XWW1Dd01WRFFW?=
 =?utf-8?B?VkZvZVV3a1hTVWhBU0RCVkVkb3FQbXcrUnE5NWJLOGd5MTNGY01odUF5V1dB?=
 =?utf-8?B?YVNHUW5EdjFwSEJaLzZWNnYwSGZZQm5HaDhuNmx4NzY4c05pUmk2QUltL0Vw?=
 =?utf-8?B?R1ZqOElkQTlsNm1aWE1vNnpLd1IwdlF0Ly9nMDUxcFF5VGxxUVBFcklSK3B4?=
 =?utf-8?B?QXlaUHdVMks5dnBZT0I1dzl2d05HTlhxRnIvNit1Q2VETE5vZlprcFE4S0l1?=
 =?utf-8?B?cDFoWUJtbS9oQkV2YWdoSDlPSmhsZEdocGdJRnpuUTdiT2xqakdRYXBCVzJR?=
 =?utf-8?B?U1JCUnhXZjU1cnFZMDhFN1hIWFNqVnBtb1FvcWw5bEV2TmVLYjJQT2sxejdI?=
 =?utf-8?B?ZVMzR0F5ZjAxL2U5bE45Um5PNjhJYXFCYVF2UXpQam9OY3h4VjFoQ01FV2Zy?=
 =?utf-8?B?YS9Xb0RMak03S1czS2NnK1YzU3pZaXd6RHYya0V4bkIzcGpvOFVXdzMzYUJD?=
 =?utf-8?B?NG9aTVo4QkhURzAwSGRTNTNTUG1adkNSeHNtdEFGa3l2MWFINjJ0WXFhTllr?=
 =?utf-8?B?NnNXZGxuN0R1SW0xbzh6SVRDSlBlNWgydUQzT0FuSXY4Yys3UE83S2JuR1BF?=
 =?utf-8?B?R2gwOHpHY2JMQjFSUitCRENXdm04WVlvMUVRZ05qY1pUV0grNHFOaDBBb0Q2?=
 =?utf-8?B?NGZtNTloTHNNcmhrZW0yTGhuajRod09UejdDR2tiZU5rQ2YvUHBOUjMxL2NR?=
 =?utf-8?B?d0h5ZUNsRkNsWVhMa1dSVVN3ZDZETkpDTUdqUkoyaU81aEtHeHRETnZpNG5q?=
 =?utf-8?B?aUhCN0ViTDdTZHh0V3F0ci9PMkllMHQrYzJZMVRETkVIbm9DRU9iSmV2QzFi?=
 =?utf-8?B?WGRVQlFoSlhKd0l2cUpwV0U4RVQvbGZDV0tPN3JYOXZqbjRSSkdWaFhUY2dY?=
 =?utf-8?B?Wmh6cGdXU01UVXhBRnkvTmRGVC9USzhDcUY3WTdhZi9vTGU2SGhUZTJwZzFl?=
 =?utf-8?B?VTdyU1FmWEhEa1ZuYVd2eDIwVkpTSVNaekNZTWlWOCtORVVSWXlWQ0tEczZn?=
 =?utf-8?B?alVjYys2K2g3bktFb2N0Rkt5MkdmcnBveEtGb0F4Q3NuWGR6NlpmUTdGbGs5?=
 =?utf-8?B?RWtmQlk2R2dQTGZ4emYyUHRBa2dxeDhtU05LMk1WQzlHeWpULzdSSm9wdkpV?=
 =?utf-8?B?VEMvYXV3WnI1bFhIUlpmdEc1ekV1TkVSN0VNc1JCQUpGVEYydmZLZ0RXeXZ1?=
 =?utf-8?B?YlpncGZseGVEZHdCbHdNTVRZN0lWR2NGNCtFWkZzMnVwaEo1dE5lZmlHdzZq?=
 =?utf-8?B?S2NjM1c5OGpFSzg4bDJ3d2ZRZVMwMEl1WGY0RHF2c09YT05BZG5MWjNYeHJt?=
 =?utf-8?B?M0tYKzBtUDdWSUJMNTllWldXN3NnTzVvTUR3eEJ3eGxhUDE2YUxvcldBbzJH?=
 =?utf-8?B?YmZlcXVocnNSeXJ0M1ozWDAvMnBMcC9DWTQ5dFBnV3lTeVg4c3pvNUFsWVN4?=
 =?utf-8?Q?fKxa+z6zlLrkS0H/kAgnvYhXW?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 830b3ba7-7d47-4a19-5a6c-08dd1def1860
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2024 16:31:30.1295
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /6/Hk0VEKGtAYV5CdDrokBP1iSq246Wc4YyZYdomtT7JN64h3XAasjzOh2GE1mJSUGSuGC0646n3Yvft5YIwnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5857

On 12/3/24 03:00, Nikunj A Dadhania wrote:
> Calibrating the TSC frequency using the kvmclock is not correct for
> SecureTSC enabled guests. Use the platform provided TSC frequency via the
> GUEST_TSC_FREQ MSR (C001_0134h).
> 
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> ---
>  arch/x86/include/asm/sev.h |  2 ++
>  arch/x86/coco/sev/core.c   | 16 ++++++++++++++++
>  arch/x86/kernel/tsc.c      |  5 +++++
>  3 files changed, 23 insertions(+)
> 
> diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
> index 9fd02efef08e..c4dca06b3b01 100644
> --- a/arch/x86/include/asm/sev.h
> +++ b/arch/x86/include/asm/sev.h
> @@ -493,6 +493,7 @@ int snp_send_guest_request(struct snp_msg_desc *mdesc, struct snp_guest_req *req
>  			   struct snp_guest_request_ioctl *rio);
>  
>  void __init snp_secure_tsc_prepare(void);
> +void __init snp_secure_tsc_init(void);
>  
>  #else	/* !CONFIG_AMD_MEM_ENCRYPT */
>  
> @@ -536,6 +537,7 @@ static inline void snp_msg_free(struct snp_msg_desc *mdesc) { }
>  static inline int snp_send_guest_request(struct snp_msg_desc *mdesc, struct snp_guest_req *req,
>  					 struct snp_guest_request_ioctl *rio) { return -ENODEV; }
>  static inline void __init snp_secure_tsc_prepare(void) { }
> +static inline void __init snp_secure_tsc_init(void) { }
>  
>  #endif	/* CONFIG_AMD_MEM_ENCRYPT */
>  
> diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
> index 59c5e716fdd1..1bc668883058 100644
> --- a/arch/x86/coco/sev/core.c
> +++ b/arch/x86/coco/sev/core.c
> @@ -3279,3 +3279,19 @@ void __init snp_secure_tsc_prepare(void)
>  
>  	pr_debug("SecureTSC enabled");
>  }
> +
> +static unsigned long securetsc_get_tsc_khz(void)
> +{
> +	unsigned long long tsc_freq_mhz;
> +
> +	setup_force_cpu_cap(X86_FEATURE_TSC_KNOWN_FREQ);
> +	rdmsrl(MSR_AMD64_GUEST_TSC_FREQ, tsc_freq_mhz);

This should never change, right? Can this be put in snp_secure_tsc_init()
and just return a saved value that is already in khz form? No reason to
perform the MSR access and multiplication every time.

Thanks,
Tom

> +
> +	return (unsigned long)(tsc_freq_mhz * 1000);
> +}
> +
> +void __init snp_secure_tsc_init(void)
> +{
> +	x86_platform.calibrate_cpu = securetsc_get_tsc_khz;
> +	x86_platform.calibrate_tsc = securetsc_get_tsc_khz;
> +}
> diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
> index 67aeaba4ba9c..c0eef924b84e 100644
> --- a/arch/x86/kernel/tsc.c
> +++ b/arch/x86/kernel/tsc.c
> @@ -30,6 +30,7 @@
>  #include <asm/i8259.h>
>  #include <asm/topology.h>
>  #include <asm/uv/uv.h>
> +#include <asm/sev.h>
>  
>  unsigned int __read_mostly cpu_khz;	/* TSC clocks / usec, not used here */
>  EXPORT_SYMBOL(cpu_khz);
> @@ -1515,6 +1516,10 @@ void __init tsc_early_init(void)
>  	/* Don't change UV TSC multi-chassis synchronization */
>  	if (is_early_uv_system())
>  		return;
> +
> +	if (cc_platform_has(CC_ATTR_GUEST_SNP_SECURE_TSC))
> +		snp_secure_tsc_init();
> +
>  	if (!determine_cpu_tsc_frequencies(true))
>  		return;
>  	tsc_enable_sched_clock();

