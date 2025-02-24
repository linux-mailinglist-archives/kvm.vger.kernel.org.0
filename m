Return-Path: <kvm+bounces-39069-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 33454A43173
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 01:00:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F02DF16DFCD
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 23:58:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CD4620D51E;
	Mon, 24 Feb 2025 23:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ktk59DSF"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2052.outbound.protection.outlook.com [40.107.94.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0157520D4E6;
	Mon, 24 Feb 2025 23:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740441370; cv=fail; b=Q5MBMrKuJd3wmTVm2eQn0wRtiG8nPDI/GwbLFv1tb7D6CTPDGssnnbAzOMt4bRwKIAPsk2f7bzd3AYfsbN/4IFYa0gbwsNIUrVm08vZfAp6mSpP6dkJ69iBfRhcfm/JG7P4Picg/TcoR4bcVjQFFJAGPUbajSWlxvaWUEesJXnQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740441370; c=relaxed/simple;
	bh=fWTN6Ec5O7+nlzK1Zm7b6HOeUp0JxDkSzNyH3e8WJFk=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=DRt9dXY6iFxzVsQr9OqbuuLk4hMj4EzgP1zqTsXPLRnKbNsWjqc1Nji1OFVsfYye3t9T+uEoMZhw6tWfohtPDzg8Gnt1q5uLtUq6AzBU1LWiAIq8lbfZ1lQEQlV/bhJYKhS/eKJFiBICi4grNTl8SFb/dhcuLJbfXCFCnc3OrJk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ktk59DSF; arc=fail smtp.client-ip=40.107.94.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rAoegMyRVBL52UldAe9vLABp+hC/TGaRqTOhXEDs1/srv4Sy9+LZYLNx9kbLIRfM4EXWO8g7YlOy1jOMw4NOrcCwrtlrN8W5yauSl/fZYFFfy2IYuaZZJDeix46BRLhy8xr5QKvRNh2R2seu/x6UXsBfOVeLRPbZRhNQYbCsB0C5SpOXLY34IuESmw2fPh9lIUxY7lLuPFFMFYXybR+iVUFh9kZGsx2a3NUs7sHAi08ckkoc6TFInBvPUx1yh/sm7ZK6bFkcTQl1QQY9unVrv4pvLLShKZki8aQJQCQwfos1A2Mslf6IyDO3ugRwLrYULDyAF5nob50nk7V6crL98Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=74mnIWHIdWOe62LIKzKT/jYh82TsJH5NhAsdxK6r+mc=;
 b=oXvBYHNS8ye6gTfgm2I+4Utv9WqAvV6l2wTleH9W5xpFq3e0lLVZWvNLun8P/8bdvNPSIZnXd0MYjE9zcUI66mIU/6M4No/iHrlq9ULV3czdNOypr82qRVLmbiOxT8RuRZw6DrhHlT1VWcyzZ505OkbYKqOg3LnrS0DSRHoTT1xLqHfGG6/R3xVpjQS8oimdsfF9RsMoTVUZ7RpMvZjgf5vviNNzEZyETuxsYn4y8pUw1f9pwOX6SGGnegqrwJJiuy9YUAABSWNe3sAFTeiEDpS9JX/HpP4mzcrUMitsChTKrWTYol6EcnihYFP3UVsAc8ZFAdLyYyfBXdO1ikPxgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=74mnIWHIdWOe62LIKzKT/jYh82TsJH5NhAsdxK6r+mc=;
 b=ktk59DSFna9AV+bokDnEbK8QpOis7qf3LYs8M2fWaGkrcQsHsibGy9N0y534qFQfU70iN9QB3XAWE1sYIAOGBcXSWpDtdyzUKnKxoW7+1CtN4RETDQ1iFgd80jtj6RX2NS6stW5V+06jW5oYdNg7Mi3LSWhnQ/9IJIrTCfIAeSY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by SA1PR12MB6896.namprd12.prod.outlook.com (2603:10b6:806:24f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.21; Mon, 24 Feb
 2025 23:55:58 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8466.020; Mon, 24 Feb 2025
 23:55:58 +0000
Message-ID: <f9050ee1-3f82-7ae0-68b0-eccae6059fde@amd.com>
Date: Mon, 24 Feb 2025 17:55:57 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Naveen N Rao <naveen@kernel.org>,
 Kim Phillips <kim.phillips@amd.com>, Alexey Kardashevskiy <aik@amd.com>
References: <20250219012705.1495231-1-seanjc@google.com>
 <20250219012705.1495231-4-seanjc@google.com>
 <4e762d94-97d4-2822-4935-2f5ab409ab29@amd.com> <Z7z43JVe2C4a7ElJ@google.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH 03/10] KVM: SVM: Terminate the VM if a SEV-ES+ guest is
 run with an invalid VMSA
In-Reply-To: <Z7z43JVe2C4a7ElJ@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR16CA0050.namprd16.prod.outlook.com
 (2603:10b6:805:ca::27) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|SA1PR12MB6896:EE_
X-MS-Office365-Filtering-Correlation-Id: d14570d3-27e7-4b82-5509-08dd552ec908
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VXhmbXZlNE5Xd0k0NWxXaEJPVkdkMVBpZ213cVZHTUNSdUJxNG9ua0tjZU55?=
 =?utf-8?B?YjN6OHp5eXQwNGRtRWRFVEpMN0tEcVExNE5YclNWMlhDT0IrWlgvUTlzZVBq?=
 =?utf-8?B?M0JPdmdJd1IyYy9UNW44bEFZVmFkQUpmNndiUHNJQmN2OGdxZmU4OVZsa1Rp?=
 =?utf-8?B?NE9mbTBMZFBBSU0xNE1mVWE0WmpIdXN4OEVYVkE1NGVPRXB5NFFDVG9lSUJ3?=
 =?utf-8?B?MnZTQnVWclQ1MlVlTkhQTjgxYno5cmhxRWtCT3crakhFZzU5SmpZaUdkdkw5?=
 =?utf-8?B?djRTZ013V2VGaWZLU3hJMWpuNXZJdjBpUG1uSmlMejZTazFUSjlPeUdsTmQw?=
 =?utf-8?B?NHNGM2NQVGt1TStoYTdMWjh3T093Mk1XcUlZdEdKQndmTFQzTTRKaUV1S082?=
 =?utf-8?B?OHNhclhiRFRmS3RheVp4OExVYXgwbkRwRDR1Y21DNUsyMDRvQ1lkKzBSMmJl?=
 =?utf-8?B?bW9CLzFlTEpZS0k0Unk1ZUVXaHpnbUVuOXNSTDdmdEZOakJvbFJzazJpcjAv?=
 =?utf-8?B?TVNOWGNja0UwZVc1R2paT2RhVDl0VHNLNUJVV1ZaMGxzMEh6b2xTZ25STVIz?=
 =?utf-8?B?bE1KYXZEbVdVT1FiUHdmWkhreTVrMVF5K0Jkbmh0Q3lhTnNIdXByemwyY3do?=
 =?utf-8?B?TTJ1Z2JFSW1ydHNPaUpXanhOR2tkd3FFeW1ibWlSSGQ0S216bTNFQ0VlUlpG?=
 =?utf-8?B?ZlBDRlFFWTRnY2ZLMnJudkN1RHF2SW5qSXk1dXJxM1I0bm9CSEY4NkF6UlZV?=
 =?utf-8?B?VENpV0F6bWlOeG9KalNncDd0VlBjUDlOTGNTWDBtUFZCdkJaQ3k0bDE1NGVo?=
 =?utf-8?B?eGdlR1NOSHRibjVEa2owREVuWXRxY0t1NFJGV1FJS0t6bVZncXhIM3A5Z3BN?=
 =?utf-8?B?UmRMUmx6QjFaZ1ZQVmhwY0xyNDBJZnh2cmRKN2Z6SUVkUmVNVWpvVnp0dDQ1?=
 =?utf-8?B?elBzSlNaSGRzbHNFdmNaL2VHdVo1U1BtTnMyOUhDUTdiQU83OXkzSzVXM09t?=
 =?utf-8?B?ak9WVGlyMU1PVmtDWkJ1Q1VORUJMOGtZVHZzYUoxcTdWcENuYU55b2FtWTV2?=
 =?utf-8?B?Z0xGWGxUSk56RGdRYXJnc1ZTQXN3dFVDZFFnRThGZnBqQzNhaC9wZ1Y4SS94?=
 =?utf-8?B?THRMSmIvZE1sb0dyeWdSeDhjREVKOEpnTG80ZUlWSVN3SW10cFVjc0FtZXpm?=
 =?utf-8?B?QU5MV0Q5MlpsVTMxNXNyeTBWQUpRMm5pSEExWGxlZjdFajA1UXpHWE9hL1hZ?=
 =?utf-8?B?anhYTkt3L3RWRzNoVVk1aXUyL0N6RTNlelNjZXhhTUFFU3dsS0xIVG8yd1ZK?=
 =?utf-8?B?YXJ5ek5RRUtZOFZkN2FScG9DUCtWL2xuaG5ZMVhHaW9xZ0YxRloyeTlXeUNt?=
 =?utf-8?B?aG94WnVLeENrdWdzTFcvWG5OcXpMcnI4WlV0c05xL3dRYXF5cVRMcnlaeUpJ?=
 =?utf-8?B?bU1oZzNmUm1TNGplTHV6dWdRalBTMzhRQW1DUlFQWUc4NmdDLyt6OEljc0ha?=
 =?utf-8?B?YWRWZjJxZ2puTTZOdXBxLzZEOThndlFKZXpET3hWdFMzWEtCb0l3ejZXYURq?=
 =?utf-8?B?MFErTmJFSlFnRkRXOEM2VWgvc0wyNGpZNzdsazNuenlzVXRoOU11TGNmenph?=
 =?utf-8?B?RzB0LzNCTk9TSytOVlVaazY1cUEyYkx4SFJnZ3JoWTlKNXhqaXRDS3g0NU5Y?=
 =?utf-8?B?YlBTbVZOWG45dHFHZkJXYzFYK1NhMUg3czNycnZLY1YyU3BhNHJ5ZVN1MGtp?=
 =?utf-8?B?Wnluc09nUXRwQTVNQWJCdWwxTmhBS0xGZmY4YkgwUzNWNUJUYzIzcWJpbXBL?=
 =?utf-8?B?UU5lZExsM2RPc05CekxPOVY3dWJqOW52M1d4Y1JmeEozRlFJblNabUhRRzZC?=
 =?utf-8?Q?mpthvClFgxU0D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RHhKN1pRQUI1SWw3b3B1blJvOHdLN1hybitOdkJRRXBUemwwcnQwNHU1MGJP?=
 =?utf-8?B?ZlZmdkdwUjQyZzgxaExoRDZzdVlsbzRKNnFCdkQwQW5EcmFpeFMyR0NvaGN5?=
 =?utf-8?B?OVJzUk54aEVnQkgrLzRBU1YyOWNGcW5xalZOZk5UNGZXSmUvQ2dyOExldnpQ?=
 =?utf-8?B?Tm1ua3AzazF3UE4wMmRXZHcrNlU1ODN5T29MNllzQVEyTzJWRmdWWW9wUHdW?=
 =?utf-8?B?TlMwK3FVVDdSSjVWTUpDUldacDZ3RmJwdk9yYXZhRWJnelZacDMyT1RLQTZk?=
 =?utf-8?B?TTNsM0gyQnR3Q0FpckJTcm1KWmkyRUxEcWdqTExXQzBpQ2JvNzZ4bktjTFla?=
 =?utf-8?B?WVRSbzdyc01jbGxCWmdhWEVDcUpKYmswTDlXWjdWYzNRaTBMdDNYSzE2RzBm?=
 =?utf-8?B?NDRVSGtuaVh6dERaVHFBbmxxRW5VdmtmRGl0RGVXVjhzM244WHNzajJ5Ymh6?=
 =?utf-8?B?ZEppQ3BKTTFWNnJWaHBhMVlSbVRrT1ltMFJVTkFyRUZVam82QjY4Z2dmTDVp?=
 =?utf-8?B?eGNwK2wwcDJKUWhCOUc3WWp6K1RRRjYrRVo3WllDdkc4TEVvZTZCRTNOVVhh?=
 =?utf-8?B?QXJYZDc1anVjZ1U5MTE2WlQyQlRHTzR4Mk5scGdrczF0R3JOYjV4VHhxOXY5?=
 =?utf-8?B?UUhTSGRjZ1EvOUtJZ0tYNWZybEFzbkxmOEhwejl3TmtjUUxHaGVzUzd2VkZW?=
 =?utf-8?B?encvWnc1VDVUUythd2pSNWg3cVgwVmt5c2U3SnlKajZVTlE0c0t0Z1RKUjho?=
 =?utf-8?B?SVNmdEtmR3NhcWVhcG9pbm5QQXpLYWZXRE9rLzJNRHVVOWVnZnVraTNYS3NQ?=
 =?utf-8?B?bGF0UEliZ1Fac1ZNenBJVkV5K1Jzeno2Q2hBY25TRTVIOGNTd055eGJ2V2xt?=
 =?utf-8?B?V1BZTE41SHZ1TTV0UG1rY0pBRUdJcmdHNlE5Mkx5U0lpblhxZkFrQm1zaXE3?=
 =?utf-8?B?WWZSdHRoa0VEd3d4MTRNUys3L2JmcGM0M1NkbVA4OUtGNjljREkxRnlMT3hz?=
 =?utf-8?B?Y2tCNnYwZm0vbFMraFlzckpucE9QbVJLTHdCN2pwT0dzaEFMNndMT2NCR1pY?=
 =?utf-8?B?UnNFU0wyM1pSR0VJbjMyekFVUzQ3UlZtYkZJWURpUDFQZG9QWVVDTmVOajdJ?=
 =?utf-8?B?Wm13a1lxZmFjSTFjYys2cVJ1UllEaXVFTlowcDJCR29jZzY2elU0UHNkYzA5?=
 =?utf-8?B?TEtLeENFMnUra3JTbUVkemxJekVJb1F6ZmJBYUxSZ0lPSDJxaUdtV1F4TTdn?=
 =?utf-8?B?bEIxcGJTaldMVkZMVURuakdlM0Z3amJlQ1BXaTVtNW55djBJSFgvY2s5M3pJ?=
 =?utf-8?B?RnE5cHZrblhpYW9RL2EwY1dFeTlHQ2gyQUw5a0Fma2VXV2o0bHZmTVV1V2Fo?=
 =?utf-8?B?bWV6enlMQUIxbzZUd1l5UUxBcHJ6aUh0OGxxRnRoU3BjUGt0R1JjYjV3R0pM?=
 =?utf-8?B?ZUVsTEVsYVBpY0JQREQrNmNLcXh2U1EyYW0yODVTVXUrSzhodTgyZHF6dmxF?=
 =?utf-8?B?eVpzUzRVbzloaHJFdi95S0ZIRm43djdxcUoyQktCbi9oVU8rQ2hZMTI3Ulg0?=
 =?utf-8?B?TlRHS2dxbVBrM1NRTzZPZGZQZGZZZTgzdWdzaVhUcTZ6ak5zbzBVMDBGQjZn?=
 =?utf-8?B?OUFtbzFjQzI4aFlDVy8vZVZTcFpwWUQyRDdRUmtGQWVtSjBvVSt1dS96ZFc3?=
 =?utf-8?B?ak5oVDd3NDBMbVBEb2pQRGNENlk2bXMySVBUek1yYm91T3QyTEwwbGRvVDUz?=
 =?utf-8?B?S1NHaDRYY3VLeEwxZml3ZkhlZUhaMzRzUE42ak5OSVdQaWkySDcvNXBVUTVw?=
 =?utf-8?B?V2tLYkFxNitLYUFaekZIcjVWZGt1WTZ0enBBOHMxU0NEaE5WVTN4ajVqWDBU?=
 =?utf-8?B?aVlJWUlXSlB6M2Q0dEtCYnVPS2orVkJJSGlJbDYyaGZ0bVhlT05mWVR6OWMx?=
 =?utf-8?B?bTZqZ242V29LSjl2cncyVERSNWFlZzhSSXVheCs2cDNiTzFETmVoYkI1VUdk?=
 =?utf-8?B?WTJpMk9kSnhOOWx6ZHZ1TTRlZWpPbGduQUFYUi9xOVF0Nk04OE50MzdVSTBD?=
 =?utf-8?B?QW92czA1U0lnZHRxNDU1UnFOYS9pOVdUUlVhQ3FhTmx4NU1SWFJvT0pkRS9P?=
 =?utf-8?Q?tTDoxqhNzkwhK/7OJjpGPpkOY?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d14570d3-27e7-4b82-5509-08dd552ec908
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2025 23:55:58.7683
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DJPrGrWWNk1KK7GVyn2eTUWaWOxOnrUvUDyJlsqnrlnV94oZU+nm5O5eG76GnvAoMy3mFkBTP9TSGKPYBHEQxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6896

On 2/24/25 16:55, Sean Christopherson wrote:
> On Mon, Feb 24, 2025, Tom Lendacky wrote:
>> On 2/18/25 19:26, Sean Christopherson wrote:
>>> -void pre_sev_run(struct vcpu_svm *svm, int cpu)
>>> +int pre_sev_run(struct vcpu_svm *svm, int cpu)
>>>  {
>>>  	struct svm_cpu_data *sd = per_cpu_ptr(&svm_data, cpu);
>>> -	unsigned int asid = sev_get_asid(svm->vcpu.kvm);
>>> +	struct kvm *kvm = svm->vcpu.kvm;
>>> +	unsigned int asid = sev_get_asid(kvm);
>>> +
>>> +	/*
>>> +	 * Terminate the VM if userspace attempts to run the vCPU with an
>>> +	 * invalid VMSA, e.g. if userspace forces the vCPU to be RUNNABLE after
>>> +	 * an SNP AP Destroy event.
>>> +	 */
>>> +	if (sev_es_guest(kvm) && !VALID_PAGE(svm->vmcb->control.vmsa_pa)) {
>>> +		kvm_vm_dead(kvm);
>>> +		return -EIO;
>>> +	}
>>
>> If a VMRUN is performed with the vmsa_pa value set to INVALID_PAGE, the
>> VMRUN will fail and KVM will dump the VMCB and exit back to userspace
> 
> I haven't tested, but based on what the APM says, I'm pretty sure this would crash
> the host due to a #GP on VMRUN, i.e. due to the resulting kvm_spurious_fault().
> 
>   IF (rAX contains an unsupported physical address)
>     EXCEPTION [#GP]

Well that's for the VMCB, the VMSA is pointed to by the VMCB and results
in a VMEXIT code of -1 if you don't supply a proper page-aligned,
physical address.

> 
>> with KVM_EXIT_INTERNAL_ERROR.
>>
>> Is doing this preferrable to that?
> 
> Even if AMD guaranteed that the absolute worst case scenario is a failed VMRUN
> with zero side effects, doing VMRUN with a bad address should be treated as a
> KVM bug.

Fair.

> 
>> If so, should a vcpu_unimpl() message be issued, too, to better identify the
>> reason for marking the VM dead?
> 
> My vote is no.  At some point we need to assume userspace possesess a reasonable
> level of competency and sanity.
> 
>>>  static void svm_inject_nmi(struct kvm_vcpu *vcpu)
>>> @@ -4231,7 +4233,8 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu,
>>>  	if (force_immediate_exit)
>>>  		smp_send_reschedule(vcpu->cpu);
>>>  
>>> -	pre_svm_run(vcpu);
>>> +	if (pre_svm_run(vcpu))
>>> +		return EXIT_FASTPATH_EXIT_USERSPACE;

In testing this out, I think userspace continues on because I eventually
get:

KVM_GET_PIT2 failed: Input/output error
/tmp/cmdline.98112: line 1: 98163 Aborted (core dumped) ...

Haven't looked too close, but maybe an exit_reason needs to be set to
get qemu to quit sooner?

Thanks,
Tom


>>
>> Since the return code from pre_svm_run() is never used, should it just
>> be a bool function, then?
> 
> Hard no.  I strongly dislike boolean returns for functions that aren't obviously
> predicates, because it's impossible to determine the polarity of the return value
> based solely on the prototype.  This leads to bugs that are easier to detect with
> 0/-errno return, e.g. returning -EINVAL in a happy path stands out more than
> returning the wrong false/true value.
> 
> Case in point (because I just responded to another emain about this function),
> what's the polarity of this helper?  :-)
> 
>   static bool sanity_check_entries(struct kvm_cpuid_entry2 __user *entries,
> 				   __u32 num_entries, unsigned int ioctl_type)


