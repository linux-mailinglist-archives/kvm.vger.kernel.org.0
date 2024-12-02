Return-Path: <kvm+bounces-32855-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DC2589E0DEC
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 22:31:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4BE70B29187
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 20:59:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5EAA1DF254;
	Mon,  2 Dec 2024 20:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Lpj5IreL"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2086.outbound.protection.outlook.com [40.107.94.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA22A1DDC29;
	Mon,  2 Dec 2024 20:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733173165; cv=fail; b=hePVdc9YUwZ1Ps9NIlMtZp1zWnfGWnDEHQ0YXvBcUMaV79QL62vkXcP0jn14J5+jqCdODkHyP4YhQxdFCsw8tugquQZPZ29iRpU3dhZ75WkMHZHuBC4dLMkB3LXbDP0dOto9isJnTki1Fa4ls6UAO1F8LOnrNJhvIc020OksIe0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733173165; c=relaxed/simple;
	bh=CtCZ42hsSCGp5StusZxW+oL2n3a0mei3BnLYroWIUsQ=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rCQ0tz1Mfri+dIegiD2E6Czy4XBsz3kqXir7pBoAyRlss5/PqQrjRoDG3SRql75XvaqK/OG14HUauOF+PMT7gIXFbgS5KvDrEKmDGcAr/OCwVp/eK/6vYPOEazWu1ZxbfQ1yhdkueAy+/cboi8b7t+5Nv2nC3uGI9E7Xy+2Msxw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Lpj5IreL; arc=fail smtp.client-ip=40.107.94.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b3jv72mrZKnlkIvKWnDTbbW7cq3sAfWMkv4nSF+dUWUCMzh23ifnjREoeYX3osAt7tCQcnB0uYcgbFyrMGy9L8BZ0H7TkBfhA13RrBxzExz2kSAJMohHr83SpbXJZw2SQ9bz/2cAkU32oiVqGBExEPfeSNha5A0cTvvqHQA+rvwqUuJLtrTZTYZ6+LvnpKteQq2Xp7uTOH2nlrb8etG8cnHh1UxEYMiQ4XoYEh4RA/Q3n/l/ef+N+dhvHPpb4fA2YXuE2IRZJ+fElvdihNm4f8xblck7AhVPqMaXiR3Edp5Bx53f65G8pWQN9RIjqnTmaEf/tAJMhbwMKz9yzTxqDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h+pKo7oqPbrsaIi5F63kyUFGX4qtzYIVUh0tH3WVaZw=;
 b=HsQD5sjSNvH+nhlpiQN1JhNNF5aC3GKtu1IjdB5oHFJyLXw4W03pjPz1zHMPEamP3nxikdgbcbK3q3thaFDXdORMOuNHKiyfaJzeMXLfCbm6nUQY9Wjw8S59KCegf3LLaGCdGKJGucWgVsbuAfu4lNcvH9JCPQ3/z/ZOuM7cFTek+Z/XejGoAeyBZHS4CByTcs5vOC0JhzVaNsevAHsDsR2QtUJEfCQBezLbeG3WnhiGKqrrU//bwk/OosMmWy595Lw+qgyv9pqsQIVVJ0mHFyIF/PRaumWE5ZFaAvG2F6dVAsrk0w4VbpYgg3BdChKc0Fo8RWXcQMJ+WObalp7bKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h+pKo7oqPbrsaIi5F63kyUFGX4qtzYIVUh0tH3WVaZw=;
 b=Lpj5IreLUQRc03zsGUgd+W1LlNaXbI8xo+bqZmzhs3RFA0H9etHwlgrHLfaj8i1KX1EriWkr/yxwU5NltnbzY6qvDItz/7EWinS8DkT36YX9pf9WIykBxkN82ACrG+NM+5aXAF0TaEbMtvOhmuJm6arwSyWsMoo1511HWTzNGrM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by BY5PR12MB4049.namprd12.prod.outlook.com (2603:10b6:a03:201::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.19; Mon, 2 Dec
 2024 20:59:18 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8207.017; Mon, 2 Dec 2024
 20:59:17 +0000
Message-ID: <0a8cda3e-8185-0620-32f7-0696a31f4877@amd.com>
Date: Mon, 2 Dec 2024 14:59:16 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v4 5/6] KVM: x86: Always complete hypercall via function
 callback
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Binbin Wu <binbin.wu@linux.intel.com>,
 Isaku Yamahata <isaku.yamahata@intel.com>, Kai Huang <kai.huang@intel.com>,
 Xiaoyao Li <xiaoyao.li@intel.com>
References: <20241128004344.4072099-1-seanjc@google.com>
 <20241128004344.4072099-6-seanjc@google.com>
 <6f4aabdb-5971-1d07-c581-0cd9471eff88@amd.com>
In-Reply-To: <6f4aabdb-5971-1d07-c581-0cd9471eff88@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7P220CA0015.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:806:123::20) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|BY5PR12MB4049:EE_
X-MS-Office365-Filtering-Correlation-Id: 77f343d5-6eac-40e0-f275-08dd13142fa3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RmdvNFVVYWNvaDVab1N4NUJ6TWMvbm5VZVJrVkduWkhrK1pTV0JJeFlQZUtV?=
 =?utf-8?B?N2tiZ25WV2NabEtvUmVRNFp1THdmbjNNSzRKREswd0V2SWZHUDF2WXJRTnln?=
 =?utf-8?B?cDEvS3pTNm8xbVRIVWJDdjZHY2hkWFpORE9idG5MOGRyWUN1WGttTXNzQzVY?=
 =?utf-8?B?MnpKL3UwRC8yQ2hSVWdBMitKMlIyc0VxT2Q2dTBQZjBJYWJ5YUZ6NE0vRy8y?=
 =?utf-8?B?bWk2NWEwZGhhKzd4YXpiYk10WEo0dXY0TzRxdHFUZ252TGwyaWZ5ZTgzM1VZ?=
 =?utf-8?B?UWZOeGorTkpqZUtkeXY1bVgxc1FjY2dLVVZxaHoydTFNWE16cmJOVzVVenA0?=
 =?utf-8?B?Z0FpdTBzMXZQazZMS2ZZbnc4d3I1VjIrMnFzN29oK2VkMTgwcG9UbFFnd2VU?=
 =?utf-8?B?akpaNS9wcldMMTVNS242UDMyRmI1S2VmaDBLTityUkR4dVdFMGFlT1dEcXFw?=
 =?utf-8?B?KzFBb2FBTTFMYlJyam5FK3NqZU81ajlqTmRBeGNRZVdlR1NEL2VwRGIxa0d5?=
 =?utf-8?B?amhyOHdkRWxzWFlWbmN6eDhrNy8wMENLN1ZVMnRIQXN0WUVNZkxTbnZxbi9O?=
 =?utf-8?B?Y2tZcnF2SDEvQnRIMkJxUTF6dDREcEhUaU5KbXNxVFFLcFU4eE1zOEQ2RXlP?=
 =?utf-8?B?dG5zUU45VDRlNVFpNCtBbnhnT25LMSttU1p1cWQyYWYwakVhbVdRejc2bjUv?=
 =?utf-8?B?YVlrTFZTLzh0NVFHSDVBK3YydzhWQktvb2RPSFFITExjbHZmZlcvUGNiTEdD?=
 =?utf-8?B?Y3IwQmxoTmVuVzBFVG1URVIvdVVKMldnZDlsN1BCcUZKM1QwWnNMdFpvZjJP?=
 =?utf-8?B?cXhtTk1ZNGE0Mm9yMzVhMU9SVW9Bb3Y0SEkzUzBuRVlZSTVENWJoWWxQcjNO?=
 =?utf-8?B?YlZud0tZVDJCcDdHb3MvK1o0S0dOakNaNXZ4cFBhbWxHN3lXc21kTm1xdUV6?=
 =?utf-8?B?eHhrZnpvZElXRkp0QUYzaCs1OUo5cWpSNWg5bFlXZ1RlVlNsTVNhN1FjY3A1?=
 =?utf-8?B?cmJlQWxnTTVKSzYyNE5GZFkydmdhTXhQSkZ4NTFaLzkrZjIraUVicjNoVmp3?=
 =?utf-8?B?Zll3Q1V2cGtoMzVlYTdRdVlSTTY5MHpWQktiNUpXOVdlVkhhVkx0TTV0UGNX?=
 =?utf-8?B?RjUzK0czWm1KZ2djM1hKMytGN1l1eGlSY01ydExndzRiRGltR2J5Q210dWUz?=
 =?utf-8?B?ZVE4dHRjMlJ4cyt6VlZibUt4UHZwOUpEZ2ptb3U3bXYyQThDUndoM1JyU2Jy?=
 =?utf-8?B?b3E2MzF0OXNrejA2L3NOUUROaVoyODJlYjQ2NjVuSy9nN2R3bE0zT01LRW9C?=
 =?utf-8?B?T000K0tHZlg3N0NKTnNOZlE5cEc2dXhjaVAranhvTS8vMTBmL2pKay9sM2xO?=
 =?utf-8?B?UW5nbmhsMVZUMHU4MGp5K0RQTUM5NTRESWpDQUZEY3NORC95RDQ5d2xmdW03?=
 =?utf-8?B?UjNZOWNGNWJaU1QvWjRuTk1vVDJkVnh5bDFUSU9RMzQ5V25QbGN6VWhkY1J2?=
 =?utf-8?B?VFZXT01DSmRsZFg4ZlVGYVRPNW9NVnVNZ0JLSkR0UHlPdnhac0JPeisxbGUv?=
 =?utf-8?B?Ry9LclZoWWpCOXlHQ1VmRHVwS3hya3h1WDYxRFNiZXhnZnlRSUJKMzZpN2xG?=
 =?utf-8?B?UlUxQ2Y1YkJJcmxGc0Q1MHB4cUE3dVRjWGRQdGl2QzQyUzIyL1lwc2xtYm5R?=
 =?utf-8?B?aSt0QUt4SzRlWUpRMnRlVEZsVlRpKzNMVDdSSFEzLzVuTHdGUGsxWm5YUWJl?=
 =?utf-8?B?ZXlZMVZVbzU3eEhWek1GbVZTT2VYRDl5ZFkzMjc0clJsYnVFZ3R2bGhyVkY0?=
 =?utf-8?B?RVZhUEZHcE9UQnRheFk4Zz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MWx5Vzl2bnV2TlpQdHNLL2dHRjQyTXY4eks1d3QyWjRVbks3cTlpZklMdGU1?=
 =?utf-8?B?Y21Bc2RCWjdnbUlLOEZuTEM4RXJ1UFZaUk9Nc0NGbTNnankzVkNrc3l5allH?=
 =?utf-8?B?d3krZVpJUGw1MHpIS2s3WWhZVW1kdXNVZDBzUnppVnF1Mk4vTHZzV2VIcTBa?=
 =?utf-8?B?OGdwMWE3bkhpUzMwNjFTOVgzN281ZGR5Zlc4UHRBN054Q3pMQ2MxREIwWTZE?=
 =?utf-8?B?SVc5K1piS2RlUDlLNitrc3dsRnY0dFRvTlMvZnpSdnZvem84QnlzYmJLVzdW?=
 =?utf-8?B?SDFWTkRBV20rRnkxY2E3aG52clpHbWQ4d2FJejQ1Y2xIaHViVXhXTEtzSHll?=
 =?utf-8?B?T3Z6QWtXT3BzaDVIMUlSaldWNWZ3TEFacWZ4ZDVWQjJXdlZvY2NJaTVMVjBO?=
 =?utf-8?B?eUVNUi9GUnhvRWEzQ2NYRFliUFVmMmxxQllSY3kraGFwTGRDTkV1WkJmWFhO?=
 =?utf-8?B?YUxFSGF1c2RYbGtIYTM1UFRQVGc4WTI4T25GdTBZWVJqbExIcG5yREJTckhn?=
 =?utf-8?B?UEJGdTEzSVlVTXNvRFhEMjVPY2FIb3FXckk2V2ZTZVdrV1gxOWtaNkw5Wnh4?=
 =?utf-8?B?aDYzck45NytSdWlHQUUzSGRZdTNpWGxKeTNMRkNObjdtdnh6UUpFeTdGbkMz?=
 =?utf-8?B?TUxpTStreVpFWk5ObXdMNUJzeW5iTHBxTnlvdnFscCt6ZlA5VXVNejNkZ2RD?=
 =?utf-8?B?NEdadDRSa1VhMHpsYWRDS1gyZkhMZkdNcVA0ekZKNWZrMFVPcjN2K25CSVVk?=
 =?utf-8?B?YXJhQk1VSEJlRzZnQVRBMUJySmhMMEJrWWppbnpocXJNQWQyOTZjYXl3bkZj?=
 =?utf-8?B?RUJoYmpPbVBaZkprZWRpSk1Ga0gyVVZHSEQzb1RPRlBCeit1cHRrL0VzWWl4?=
 =?utf-8?B?cUJZZm91VWcwWFJ6ZC83SklYdHFrZ1NEZFlLSjhaTjBnOTJQamJvVlBDOHhO?=
 =?utf-8?B?cE91Sm8wb09pU2d3L3BDRHliNzZDL3p4OUU4YjV2bUF3cDRiV0cvVDlRdnZw?=
 =?utf-8?B?eCtORUltM2o2TXBJRU12K01TRFVvbHdmS1NueDNmeUUwWE9JUERMS2VqWE9N?=
 =?utf-8?B?M3FYeVZCd21EbFBwb3gwditrODF3a29FNW5VTXlDWjBOQVF5TkY4a3FjYXVU?=
 =?utf-8?B?d29VS2pPQUVMcUxOQmplZGtiREwyQjFXRXdVMCs5Tjk5MWlKbWZqSm9jRmJk?=
 =?utf-8?B?M29SbkI5THFZZGpKZ2NmWDd2ZEZQa3l4YzZQT1YrM0lFblhIMzFwc1dqOUF3?=
 =?utf-8?B?T2VDUHVJSlhLUnNXbVc0TmJIRWRaYnVIazlsSG5JQUFsMnVIazdjOXlITDBp?=
 =?utf-8?B?M3hmRXMzdWNTa09ZWnY2M0tmWFF3dEJNN29LY0F2bTY3TU5vbjQ0Vk15dHZF?=
 =?utf-8?B?dXRhNS80dWJEN250SmNNd3lpTkpzRUs3OGZxZWM4Mkk2ZzAyQ1I0NUV2dEl2?=
 =?utf-8?B?T29uZGRSSlFqR3NBeDlKOHBCM1FXT0tHbHlwTnYyUHlpa25leGlxWmpWWDdV?=
 =?utf-8?B?S0NlL3doMjdOSWxieWtLWEhuckw3b1EvUUd0cXdnR2I2eFJDa3J5QmlHV1d0?=
 =?utf-8?B?d2FJejNqZlhQM1l3WG5jSUJpYzM2SUZwZjQwWitsVW1QWmxUSUlWb2FBaTRz?=
 =?utf-8?B?NW8xSTJkVlhGUWV6cDVFV05DVHlmVzVuTjV4aG8rY21jQVlvbTE4ZTdkZG1Y?=
 =?utf-8?B?Q2t5RTlEZHNncWFSMHhKU0N0ZlUvTnBaQTBhb3QwUk01TGdLVE55STE4OUpE?=
 =?utf-8?B?UVB6RGt4a3ZjcFJmV2IyNFVhWW8xYnZLemhNanIyUEVyZnc5Y0ViQy9Yd1JS?=
 =?utf-8?B?WG02TXpjZmZ0Q3RTMm5BbzA2RXhNVE1mU1cyMmM5ZVI3UkN1eFNIaVVVTWM4?=
 =?utf-8?B?T0hhS2RKWFcyaExPOFBoQTVad1NpaG5vL3Y3c1hzMWtPZTZzdTdTSzRHSEIx?=
 =?utf-8?B?N2tvV2RicXlTZzZORjdScnVLb25aNnA0ZVU1UW1ISm5XUVBZU1M2ak5sdzcr?=
 =?utf-8?B?NThmT2lGemg4eFcyYWUzcUVZaksxaHpHYTAvclQ2aDhtVWlmVWdDODN4eVhK?=
 =?utf-8?B?ekxhNU9ielJWQnR1TklrNEpWUENUWFBrM1FpSHUzbmNIcnM3bHkrSklJNklv?=
 =?utf-8?Q?EpPXHSUr8zZCsXy0N8r1IDZkP?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77f343d5-6eac-40e0-f275-08dd13142fa3
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2024 20:59:17.7875
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VW+Kt3YLHRPtWEIYbnqeYj45AIOcnZrXyin7tNyRgX/BwCnicWjlIlDlTgqzBC59NT2SjXmJyuu8ldWkZUssuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4049

On 12/2/24 14:57, Tom Lendacky wrote:
> On 11/27/24 18:43, Sean Christopherson wrote:

>> @@ -10071,13 +10072,15 @@ unsigned long __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
>>  	}
>>  
>>  out:
>> -	return ret;
>> +	vcpu->run->hypercall.ret = ret;
>> +	complete_hypercall(vcpu);
>> +	return 1;
> 
> Should this do return complete_hypercall(vcpu) so that you get the
> return code from kvm_skip_emulated_instruction()?

Bah, ignore...  already commented on by Xiaoyao.

Thanks,
Tom

> 
> Thanks,
> Tom
> 

