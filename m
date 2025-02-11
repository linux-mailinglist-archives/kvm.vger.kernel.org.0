Return-Path: <kvm+bounces-37875-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 83B50A30E9C
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 15:42:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C95731887C07
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 14:43:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2491A250BE2;
	Tue, 11 Feb 2025 14:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ftkY0uRa"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2080.outbound.protection.outlook.com [40.107.236.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05B4D1F12FC
	for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 14:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739284973; cv=fail; b=Qt+NBm++U1lr+47YMSHF8QLWAxzjrs/v155Zd4l3wSKmVDSNYzp4ECou2PvfYRWRa9XURWIRvSOZfKFuCpu9XUJo7jdLxxlw4WlsOU9hOwmsL7bE3kl7dXfNxOBJBgnZpqu5oM+mIQzDLhrRyWqEQnSZ1vEOlSuXh9bFDMQLgq4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739284973; c=relaxed/simple;
	bh=fZLPo0yQ4PNGNqOc1G5RbJe1hQOzM2yFyEEc3h7X0XA=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jOweWjAyiOS4D0lKu4HsBzb6aPpNOSgHZ/RAEdPqPN7cZqhRmKYe0rXgiyfgi1LJ0BIhlGUDlJvkvgpCRECXNq8PCAd5NEQmsAMEVtVaZ+cJWkNVf9+VWgITmG2zmwtxudvTipq6bOsXky7n8T0/8KAnR1hsUj07pAHGa8oiG9M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ftkY0uRa; arc=fail smtp.client-ip=40.107.236.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lu1VbunN1LN5Rh7C6ORxpG8XHl8fO6xe/NWVwYrr5iJt0RpwtOridIZmi2uPnIy6M9fIbbz8suWdeU/MUJDvslGnlLkKxLuKD5WpcsMQI1MZmLjnv8q65FFdWXGBNnkDNEta7U9sUSsR/rBR7MywwvtZIUTcsJxV5muuw65+dEpVf52wgz5HqZXOSSVWJFMCfeDvligmXQGy/0WuFkvW1ExI1PgVvsMPrdNcFMsV62mNSofa5OrtmY02om9+SybiG1rGMHp8pQ0wkCPXoJnxbsYiWO2wZAYVurCtcu1ZzYzc1Ivk4zSs7NPrYEKApXq5D0gWg1joHWr0+h2J8Ip5xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QBF5b7eN2OgecEiblgbbO5L/AEYpc+zn9NUj/1Vbew8=;
 b=OcQSpFBcj7JIQ8aj8PyM0n8wY7l+umjO6rj+SI199l5yXNG4LhYecZeeZSwgX/5JFn/7vOSXzgZ+QC56rTEBh7zNXc+4g5Kzk3GVb1LaTfuvkbApBjzcBOGdAu6qSWxZ+W8RqHca1jCJgaFhXZZmyvwknckD8XK4li/oLtFBooCZo/aESx4BbwlFwX7NJvkxoHz2f6tB9BoHi+JjG58StxMnhS8WRj+GaggZzy4oVtfyuIFGOt4EChaPGzw7JoH4VfeEhJKJmBO/XnRNRrRfNNXVOQj0rx8WTm150QfiDh0ZqlFjtM/uIW/1FRbd2C1fV/OOIPX3twucmiLQ3eIK3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QBF5b7eN2OgecEiblgbbO5L/AEYpc+zn9NUj/1Vbew8=;
 b=ftkY0uRao6JpM1QNx9XK4syEGMUXiD9O39b8v2FvuLcPDzULkwHYQKe7+BjutqScGEuVhWmrZI5hSrmxTjNxzS2hXnRxHpuq+gDoydRf+5epvayAIHfmHijVeiHcc0js4k+8Xv9K86hmX2bOrfmITGjj7avZ+hQbT+IV1DWRC10=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by PH7PR12MB5806.namprd12.prod.outlook.com (2603:10b6:510:1d2::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.19; Tue, 11 Feb
 2025 14:42:44 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8422.015; Tue, 11 Feb 2025
 14:42:44 +0000
Message-ID: <f13c458e-d836-33bf-631e-e15e6c9f81ad@amd.com>
Date: Tue, 11 Feb 2025 08:42:42 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v2 3/4] KVM: SVM: Prevent writes to TSC MSR when Secure
 TSC is enabled
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
To: Nikunj A Dadhania <nikunj@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, kvm@vger.kernel.org
Cc: santosh.shukla@amd.com, bp@alien8.de, isaku.yamahata@intel.com
References: <20250210092230.151034-1-nikunj@amd.com>
 <20250210092230.151034-4-nikunj@amd.com>
 <8ec1bef9-829d-4370-47f6-c94e794cc5d5@amd.com> <85ed04ubwc.fsf@amd.com>
 <33fceaf0-ab35-cdcc-6e4f-16b058a96b42@amd.com>
In-Reply-To: <33fceaf0-ab35-cdcc-6e4f-16b058a96b42@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0020.namprd04.prod.outlook.com
 (2603:10b6:806:f2::25) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|PH7PR12MB5806:EE_
X-MS-Office365-Filtering-Correlation-Id: ddbe701d-8c3c-4006-9cab-08dd4aaa5821
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZnJuQkFFcy9FamZKOHgxamI2QjR3MHVDem92M215Z0dkM0RPeDFVaDNqd3RZ?=
 =?utf-8?B?OVFHa1Rxd3hPRVdRNU12M2ZQNVBuY1RnelFBM0E2eS80V1RCb1dzN3kyUWR1?=
 =?utf-8?B?WVM2dStDTFZCRlQ4VW51blJyS2pkL20yaU9zclBybzM5TitBdk5QZWNJRDNO?=
 =?utf-8?B?N2F1OHh4czFlQ1NBWXFITktKOGhFYXhKaTFTcUx4S1JuU3JyTzRuaEN1T0pQ?=
 =?utf-8?B?VitYcEZYQ2gvSTh1Qmtza0hVa09ocXBUWENncGtFSDJiK1FDWk42aUEzTmFJ?=
 =?utf-8?B?blNyMWM1emd1ZkpjTFpmejc4VkFrTElmTnlGSUFhVW92b1hVNm8rNGxUWk8x?=
 =?utf-8?B?OUFtNGh2Q09UZ0x4NFlEbVJwVG9sOEJBWTBKdlMzdXY5bUhmMTlBeVBGZ0J1?=
 =?utf-8?B?QXR0dmlxenJCR0VYOHRQQ0VSKzNlMCsvQkdsQkRhdnltelBpSkFzaGNmZmNQ?=
 =?utf-8?B?Y04yaWxkVXgzd3orbko4c0tXRHF1YTNueEZnUldheGhCNE9ERTNveFd1bDM5?=
 =?utf-8?B?dlNlbVNGTVVVOW4vZzZlTG1jUFIrbnJqQTk1YXJUY2d1Uy9sdysrMWNxNlM4?=
 =?utf-8?B?RTlTQ2h4Q1BoVHNkMDNORmlpVngrYjVIWWVsWEdqUWxhSzBKVXRvVWkvRmRC?=
 =?utf-8?B?TWJKTHJnajBZRzNhTHhBdmQyMUVNeGc4TnozMWwyclBzaVR0Y2NhVkg5dWRj?=
 =?utf-8?B?dVZDOXRUK0UxTU1CdnRheVN0KzFOSUhNakV0NE9lNVJMN2xreUNXeEVKcEJS?=
 =?utf-8?B?elpiUEw3WEhoYVRHbUI4d2lCSm9GRDEyOG9xdkx0NnUrZWVnYW1jS0ZkSmp3?=
 =?utf-8?B?Nk9ubVVmTkpWMnZSOStUUGN5UmxxWmRIa2dDTVdIQis0TVFVeHhkQ0Jucjdo?=
 =?utf-8?B?R0lGVGEwWE1ST2RyK2R4anZMdmVqY2UzcFUzYVgvM29YenBtcXE0bnFFTEJa?=
 =?utf-8?B?N2Yva2xhOGd0N1FiSEEyWkZBcTkyZjZKS3B3UHhUbFcyWXErUytITHpyR01I?=
 =?utf-8?B?bDE2OElQbkZNcTF0dFc4R2YvNkFEMU1NVkdsOW55czF6OG5jZTlWZEpONWp4?=
 =?utf-8?B?TERuOGU0Sndic2l4d1l6cENXbmt4bG5qNG1SaXpjQ3ZnYVJjWDJGdHNybDRK?=
 =?utf-8?B?MU1qU1lacml2Ly9DRjBnMjhweURyUCtoaFZZWVJEZURFMmFZYnhWS3ovWTcy?=
 =?utf-8?B?S00weGdGdmJYZXgvcUVqbkxpaitiZVlxeWF1bjlQMjFwS2lJVHN5VnM4NjNY?=
 =?utf-8?B?Q1BPZDFFMnE3eXMwQ3drZk1wY2VMblZLTUtCSWFFOTVOZGMwaDEyYThLZytS?=
 =?utf-8?B?cU1UQ1FGUFpxMURyVHFEWjMvb2RwTS9CYW5scEdwZy9uditJZGk2TEJ6YXl6?=
 =?utf-8?B?Z0QwQmUvQ1YrTTVycFVaUCt3NlA2dW1BLzJ1QzFzMUw2VlBtd2NXdWhhbFk2?=
 =?utf-8?B?dlJzWGltQVc0NitTbnFqc2lZVzhDOEZTM3FZNVh5ME9JdE1sSDlzQ3EySkZX?=
 =?utf-8?B?WmpKbDh1VnVMTHJPUGQxb1Bxb0tPOURQNnc3OVMwek9FVnN2ZEZKN0Z6QzE1?=
 =?utf-8?B?VmRHRktyNlYvalRsT3ppalV5MFdrVi9TaGRGc1dRRkNFSmNaVTF0TmkzWERN?=
 =?utf-8?B?OTFLb1NhZFpSamtMclZlVkFkSWF5cVJCQXViR1R0NlJRL2xZTmF4UUdQRVpQ?=
 =?utf-8?B?V0lZdHRRQkxWdHNidHpUeUNyYUw0ZkE0bUlNaU1BbTJCeWF2OVA2aXNEYlpn?=
 =?utf-8?B?NTYzNFYzaC9TMUgrQTMzK1FYS01OSWpoL3JYaGxRYUdTbTR6WXN5Lys2QWRJ?=
 =?utf-8?B?dy9tbVlBY2dicllWZmJuOStZNFVmSDlsb0tBRzd3cXl5aU42ZWdlV1N2N01x?=
 =?utf-8?Q?01bxLaZGe9ajv?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Z1JRS1NNYmhIZFlMemVBakZuU3V2VkxSME04eXF0Y3lzSGZFSitpZG8zQjFy?=
 =?utf-8?B?UnNqWkJMVzBpTnlKWDY4b3NBZm5rSlhyZWpIVGNIODhoRWRwQ3ZLOWRlZWhZ?=
 =?utf-8?B?V1VabGVaVmRqT3Z5TWNTS01zUFlheVdUbng5VVlqNmZRbll0RkpINUFzZEcy?=
 =?utf-8?B?aURYVzRBL2lPWURJNzgwWFdjTzhxU3ViYnFtbDdGRzc4SmR1YUpucnM0R2NN?=
 =?utf-8?B?a2RsNyswa25lTlpaVDJYQWtvQ3lxNHJXUUM2d3FqRW5nejNHUmh3MzFMdEVU?=
 =?utf-8?B?dUVnT2Vqdk5UV2Y5TmVmVldXcWNWcXZxVllXQnZBdmlNZUorMTVxYy9rZDI2?=
 =?utf-8?B?OFlPOWZWZUVmaHNYNjR4M2Q0QTBpRXg2b0RKNk5EdnorNHlQYU51QU1TQTNX?=
 =?utf-8?B?dTltWERhRXF5NVpXSVNsVng2ekpHM0F1dCtZUXR0R05MNDFSRG16VFh3ZXBO?=
 =?utf-8?B?RGxxSlNUM1k2cWIwSFcxQ0hSdEhna0hEeE9xcXZpVnA3c0VhNTRzMi9xNENF?=
 =?utf-8?B?c0gyQU5mNVNBbEZTTWpHeDlKZExYbWdNSEJTQzA2bVEyd0p1MDZTdVJXVWh3?=
 =?utf-8?B?T3BzMXRKbHo5SlJpdFFuV0wxWERYTmUyZ2ZOSndOZ2VpMU0yUjBucFpJRk50?=
 =?utf-8?B?OXl6dUg4WllOc0dHOHRqSENDMFU3YVFGTXJhTDRiZUpjaDMzOTZ6VkxuVC8y?=
 =?utf-8?B?aCtWbmNjOXJtcWdJbGpvdmdtWGczemNEbXRNVC8rWThmYVEwdDJmRjFlYUFS?=
 =?utf-8?B?aXlwdFBsNElCSjZ4QTFQdXVsYyt4VkNBcEhiU1lBN3ZJVDZ3Y1BmV1Y4Qk44?=
 =?utf-8?B?NkNBaHVmQXBHSGRiem5wdlJzei9GK3FzWjVaMGIwSkZEdHpPS0NaL3hzdU9P?=
 =?utf-8?B?V1dpeWFQTzV6d1BxaVVvOTltbUVxTENkTDVObkJROWRnNVQ0VXRBVStCWE4r?=
 =?utf-8?B?Q2RpaHk4bUkrUlYwMTNDL1hWbVBhL0s5d01XWjVNTTRicDdxbVRZVFdwZWlt?=
 =?utf-8?B?VmdkNHdJcFBLcWwyQmV5S0tRZVBiMnY4VGQrV0E2ZG1lbGpiNnI5WEx5dlo0?=
 =?utf-8?B?VGpjZWhITWVSNTZUZW1vWU9ZWk9wdGxtL2FnRUhCNmIxL2o1N3pVMTFvVDlD?=
 =?utf-8?B?azZBY2NlcUF4ZFZINWl4N2FyMUZiOXlMeTlueS9nbU5leFc0SzdUaWIvc1d5?=
 =?utf-8?B?aFVRT1JSaVJGMDUxdWdTQXhhTlRGeHpDaHdLUVVTWjBMd1NLdkRLS2xHL2VP?=
 =?utf-8?B?eHRnZ0h6akpJOFR1WWVSa0sxNGg1N2hNdmhqSk5GNjNxaHIydm1kNndoblAv?=
 =?utf-8?B?bmJvVFZjcGY0WFhqZWF2YTAzY2pIbWltaEFRc3ZYVVBNTUN2eThJK3FCOUtU?=
 =?utf-8?B?QWhtd3g4MzNNUHNqZTVNNFpVeC9yakU4MGhEb2xnV1JpblFYN1FOd0JDNDJX?=
 =?utf-8?B?M1p5aXNhR29OMkZDb0NGMVllRjFOcEdOV0hiNjV5enIyT2dobE94dWVDSU5m?=
 =?utf-8?B?cm45Uk1mU2U4UXJwd1F4eVg4RkR3UTBJNWRRU0FlbzE2dklKcEIyZDZJTml5?=
 =?utf-8?B?dUlaNFlvOUFhbmR3cDhBNEx2cThZVVlZMFU2aG1yZ2NhcndodVZ0R2llZ1Vo?=
 =?utf-8?B?a2FmOWU0d0ZWZTRWbXlhSTFTNlRSQVNmNElEUDFMdUI0UXZYUnZpRW1mWHNB?=
 =?utf-8?B?UEsybEo1VWt1dU9QMlBBTExHdEVML2pYUWxIYVM3UXRWRk1GeXl3UU40dmhp?=
 =?utf-8?B?TExCN2ZMZmxTOHRLeGVobFN2NWw5ek5lQWlHVTBnQUxCWDkxdnRjenJhL2lE?=
 =?utf-8?B?VFI4ajFvWXpMNFpNVGVDRHZ6UHJFYVBrc054TDI2M0ZZK2JHcUVqNjRFQmJZ?=
 =?utf-8?B?aitGUmRnd0VHejlsOGlNbjhoc0pxamd3SkluMFA2dUtIRUhMSHFFTWFlUEdk?=
 =?utf-8?B?b2xkRmZML2JhVFJ4b0NXYWlTRUZIWGhrSWo3d01hRjIzbWxaT0xiRWJCZDlo?=
 =?utf-8?B?UzkvWEtPMDlwRUEzQTA4OHFwbkNOSm9sc1NFWFJWNXlVaW8zOVoxSW1Qckxk?=
 =?utf-8?B?NU5zMExqYytmcTRKcDR4ZmRZK0xvZURuaDJhUDE2SnpEbEN3UkdVV2FUL1NL?=
 =?utf-8?Q?7jYehumFWcpy102aaQ+zpqNPO?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ddbe701d-8c3c-4006-9cab-08dd4aaa5821
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2025 14:42:44.1971
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CJC3foCJFNzbMpLPNSd5oTQgpbLSUM6frTQHE5vUG9AMoOmHbgcSZC8XhnNglcw/lrrxRwL+7r6HVuTxjC7pAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5806

On 2/11/25 08:03, Tom Lendacky wrote:
> On 2/11/25 02:24, Nikunj A Dadhania wrote:
>> Tom Lendacky <thomas.lendacky@amd.com> writes:
>>
>>> On 2/10/25 03:22, Nikunj A Dadhania wrote:
>>>> Disallow writes to MSR_IA32_TSC for Secure TSC enabled SNP guests, as such
>>>> writes are not expected. Log the error and return #GP to the guest.
>>>
>>> Re-word this to make it a bit clearer about why this is needed. It is
>>> expected that the guest won't write to MSR_IA32_TSC or, if it does, it
>>> will ignore any writes to it and not exit to the HV. So this is catching
>>> the case where that behavior is not occurring.
>>>
>> Sure, will update.
>>
>>>>
>>>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
>>>> ---
>>>>  arch/x86/kvm/svm/svm.c | 11 +++++++++++
>>>>  1 file changed, 11 insertions(+)
>>>>
>>>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>>>> index d7a0428aa2ae..929f35a2f542 100644
>>>> --- a/arch/x86/kvm/svm/svm.c
>>>> +++ b/arch/x86/kvm/svm/svm.c
>>>> @@ -3161,6 +3161,17 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
>>>>  
>>>>  		svm->tsc_aux = data;
>>>>  		break;
>>>> +	case MSR_IA32_TSC:
>>>> +		/*
>>>> +		 * If Secure TSC is enabled, KVM doesn't expect to receive
>>>> +		 * a VMEXIT for a TSC write, record the error and return a
>>>> +		 * #GP
>>>> +		 */
>>>> +		if (vcpu->arch.guest_state_protected && snp_secure_tsc_enabled(vcpu->kvm)) {
>>>
>>> Does it matter if the VMSA has already been encrypted? Can this just be
>>>
>>>   if (sev_snp_guest() && snp_secure_tsc_enabled(vcpu->kvm)) {
>>>
>>> ?
>>>
>>
>> QEMU initializes the IA32_TSC MSR to zero resulting in the below
>> error if I use the above.
>>
>> qemu-system-x86_64: error: failed to set MSR 0x10 to 0x0
>> qemu-system-x86_64: ../target/i386/kvm/kvm.c:3849: kvm_buf_set_msrs: Assertion `ret == cpu->kvm_msr_buf->nmsrs' failed.
> 
> Should KVM be doing anything related to MSR_IA32_TSC for a Secure TSC
> guest, even handling this Qemu write? That Qemu write takes it through
> the kvm_synchronize_tsc() path, does it need to? I'm just wondering if

Ah, strike that, the write from Qemu is just ignored in this situation.
But doesn't that break existing support since we no longer call into
kvm_set_msr_common() for MSR_IA32_TSC? This looks like it needs to
invoke kvm_set_msr_common() if it isn't a Secure TSC guest.

Thanks,
Tom

> the Secure TSC HV support needs more handling of MSR_IA32_TSC (in both
> set and get) than what's here. Thoughts?
> 
> Thanks,
> Tom
> 
>>
>> Once the guest state is protected, we do not expect any writes from VMM.
>>
>> Regards,
>> Nikunj

