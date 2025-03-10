Return-Path: <kvm+bounces-40659-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B294A59937
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 16:10:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5D8E8188ABD3
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 15:10:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA85922D4CE;
	Mon, 10 Mar 2025 15:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="wpo50r9E"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2045.outbound.protection.outlook.com [40.107.237.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46DBB2C9A
	for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 15:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741619391; cv=fail; b=Sxq5/4VTTVcb8nnAWdy34eij6SdcXi8X1L5GRzhTJcZp28DUwyxD7RgSUtjhsjNuwp7CFupLLxqTeiMuQE+wodzITLhR10asgskUTUCZ5n4jRrUas9xvQsHvObOAuaPcxBq3Vmt2cccZXioXRN6QP3Ux9OUI55NHdlAa0FGCjC8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741619391; c=relaxed/simple;
	bh=uLH6Zk5UdPp83Psg6/lvUTTE5NXZP+bK/pCtRg/DZe8=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=J7YcetwM85Vpd8rNQHjcOFZfHQnkbEhkgrLQNd2EAYDQQSI2K58adc3M2CjRGl3kjmvZ1jIvqpM/z1nfDRV/UtCgtnWTO+xJH90tOcXlU27j/dW/yyyxRawyxFCVwAqw5ypUBbUsxS1rDJ8e74Dhadry62Q9WcQ+Gnl42EgO3Dw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=wpo50r9E; arc=fail smtp.client-ip=40.107.237.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NGgugCWpasvgPnOVIaabIsOW/2824AGclYrljzlKodQQN08nNDLcQ+LFfOJhzuGpi/XoyH+MsPfcDw6eGYKIsUoOEsbIb+bCBuMyw3lvUIzDAsBeeQdrtKetauSaP9eaR34pONjc2S/+/gaXiIBxTL17kSlDJIqWOicuaELJ+ZmBhD46xUsJv0XuwGrh3xSupv/aHEt2wI82/nUJ58UqRJthqcCRcpcYrqMHW7AkBv5SzPxXcyUNuKHnYAHc8tse6oYsf43TM0jOlB21c1vUdoRWUiTU/vZD3j1NWvBePWElecZPJsbPhOw/7q3FEim/7JNs9JQeg8rMD7Vts1o3fQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7WTZXm3wjhTXs93XD8SD3smctxuVMLAWcRK/Yj7GCDM=;
 b=PV0WRUIZxzyMA76F9ivRj0t1txgSfcgt5Do+IuMxzmqpvaMBY9FaIhVjwdfxX65AvMhuWR6VKciP0vK7dWVkwR7POeSAq/daZYioY7RW05H2CCq5IwU8zJCZ/dhwJhYtb487PRYT+UVo4eb5ZWTo6aM69fJCxoTXjI/aQIJElS7LXVdWbrNn1VN4ZyFGKf0xfBr6K6HY62a3uq03627jBBGeiwCTb1zw51zv2t/gOLKA7F5iyot/Q4yKCM37FsvbckYshrd5S8lGc6tH5rpD4kc+EtAa/mBRzYFFVaGxXxprk8PAf3TG7DNqFqgxRYpcxtSPl1AT8n8XYJcjWjRfIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7WTZXm3wjhTXs93XD8SD3smctxuVMLAWcRK/Yj7GCDM=;
 b=wpo50r9E9cZXp3tfX0zhphWmBcoHP1VWIgWa59oVhuBzFdUBHgoDVxii5o1m2iX1trfNPUIe1OML4pVyAZxpbUjWrmYvooyD6Oa72Q6OVmUraZnFICKSI1ZrUbNSPLeVxYYU2fVPdP6BA6QbbVe2005f1l7tsUmidtP2Thl94hM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5062.namprd12.prod.outlook.com (2603:10b6:208:313::6)
 by DM4PR12MB5914.namprd12.prod.outlook.com (2603:10b6:8:67::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.27; Mon, 10 Mar
 2025 15:09:46 +0000
Received: from BL1PR12MB5062.namprd12.prod.outlook.com
 ([fe80::fe03:ef1f:3fee:9d4a]) by BL1PR12MB5062.namprd12.prod.outlook.com
 ([fe80::fe03:ef1f:3fee:9d4a%5]) with mapi id 15.20.8511.026; Mon, 10 Mar 2025
 15:09:45 +0000
Message-ID: <679f350d-3072-9f8f-b5da-51ac0d70636d@amd.com>
Date: Mon, 10 Mar 2025 10:09:41 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Nikunj A Dadhania <nikunj@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, kvm@vger.kernel.org
Cc: santosh.shukla@amd.com, bp@alien8.de, isaku.yamahata@intel.com
References: <20250310063938.13790-1-nikunj@amd.com>
 <20250310064522.14100-1-nikunj@amd.com>
 <20250310064522.14100-2-nikunj@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v4 3/5] KVM: SVM: Add GUEST_TSC_FREQ MSR for Secure TSC
 enabled guests
In-Reply-To: <20250310064522.14100-2-nikunj@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR05CA0017.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::30) To BL1PR12MB5062.namprd12.prod.outlook.com
 (2603:10b6:208:313::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5062:EE_|DM4PR12MB5914:EE_
X-MS-Office365-Filtering-Correlation-Id: 1599c4a4-02db-437e-86b1-08dd5fe597d0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZzhTMWU5WUIwTWhZdHFNQk1Na1YxbmxtQWREYVlxT1pjTmljVm1ZSDdVSnZF?=
 =?utf-8?B?ZkR3ZkphdnVYb1BNbzUreGV2cThZSE5EOEhHZkxicENiY05ZMk0vYVJYcTEv?=
 =?utf-8?B?WTZhOGZCYTNEL1Z5ZVk4cmwrWEUzYm9ZSXlqMTJHajEzdVdEOEg4NDhURmhB?=
 =?utf-8?B?cWRyUzhMWmlaRzdZUUVCaTN4ZTg3ZTFrYzRCY29jaFYvNUcrQTBwSjk1eXJj?=
 =?utf-8?B?eitVY0R6c053SzMwZ2k1RTczZlBjOVR0OTN6ejVYL3kzcFhxZXN6cW4zUUl2?=
 =?utf-8?B?WWpGRGdJajlodXo5M2ozN2dac085aVU0V083T2xhZ3dTQmdORS83TXpSeVcx?=
 =?utf-8?B?OXgyWVpIZ0xPR0pEU2kyb3lJZDJ4LzNyR3dUN1pGRDR6Z3VudEVxM2U5Mlg4?=
 =?utf-8?B?ZVhjVjdrTjA3V2I1c3JFUURPcmd3YzBTV29qQnArcVVIVHlPb2M5cy9yWjlM?=
 =?utf-8?B?aGdQQkFyd2tyRlpOcTU1V0FtS3U2N0JzcWlDUVpJMmttZDM3NVpYY2lZc0xI?=
 =?utf-8?B?aE9YSllKMFBMME4vTjFtTnE3bENlL1JtNGpMR05IUHppSklFeWV4ZFhnMVpm?=
 =?utf-8?B?a3M5SERTa00rR0pZUi9Pd3RXd2ZLdytHY080eVRRT0NtdzA2ak9iR0NuT24z?=
 =?utf-8?B?d3NKS0xiZlU1SUhiRWQvcTRKL1dESnJEVG1STnljT09EcDlHMVJFZnBIMFhN?=
 =?utf-8?B?SmdZcThPeXJvWkJjNUt1YXBoUTBMZUpCVGRYeERkb3RyYjZUQlIzSHFFcjI4?=
 =?utf-8?B?RUFDRjRKRDlhdGdJa1B5enNFSTRObkdCYzE0SlhlVWhmU3dQdXpXNjVoL3VB?=
 =?utf-8?B?SFFXVVEzU0tSM2JGMU82c1ZHUkJlL3Z1MkcyZUM5ampPS2hFZmN6WlRaNnFp?=
 =?utf-8?B?MVBtRWVkODdDYVgyOHFISVNlZTBJdW8rZ3dLbmUwUExoS0VXUko5QkZaZS9S?=
 =?utf-8?B?eWY5ZHVDczQxN1R3MVlha2RvNFBqUWVIemlEQmNsNlZIL2NPQWJmNWh4cU1Q?=
 =?utf-8?B?UWFoSUR2WG80b0VrSHgwQ2kxc2VzOG1DVWdSWElqKzFqcTNpMVpRVmFHWW9G?=
 =?utf-8?B?ZDVubWdrTnJGNklZMkdkdkI3K1ptUklkczViNzVHcDlSNXA1eTNZU2xOYmxw?=
 =?utf-8?B?ZnA1Y05lTEtGTmVOME81QnVIMlVNSkRQdWpuRW5GYVhXZllpQnY3Vk5TcVIx?=
 =?utf-8?B?UFNKTTlRLzNqak4wU2syVE5XOEgrU3hSdEwxdE5MZ1BWYWlQanNZMDJPYnJ4?=
 =?utf-8?B?RUNQWWpaUU9UZDFEdXpNOGNNc28rN1k4RHdVd0hYMTUyZlFSdFNBaExBUEZW?=
 =?utf-8?B?bU5yVzdZVDNYMi9MM29oSE9UZ2gvUjBaQWljdk1nZFpnTkpwaG9jUmVsNk91?=
 =?utf-8?B?VzdBSzk0ZmxXMEhOeElsVFRGb09QeW5MSm9ITFk5d2tsVDI4RlVsMFA4WHo1?=
 =?utf-8?B?TFpZZEp4Q1pQVlUrZHpBVWdYNm9UOGpRVUp4dUNwSllHdnloUmdKNHJjMk9l?=
 =?utf-8?B?YmlMczVOVGc5RmFObHRGa1liT2kwV0JsK0MyY0FKVVdkcnZLbVAxUE9hSzZj?=
 =?utf-8?B?TSsrbE5YVkUvMzBoVTYvcTg0Z2g1VGpJWnVHK0x0UmNiVGVjNnJpaEtLbis2?=
 =?utf-8?B?TFlaK0pQV2xaa2NMWnMxMVQvQlJ3WUZMbHB5RG9IUWRIY1BIbHNwMHlHZ1hk?=
 =?utf-8?B?NWF3eUFyNzFyTlZxTUloU2VTdlJ0OEVuOE1hTjFTZHpGTzlyRVR6ekxSSzlM?=
 =?utf-8?B?dVczQVFtWW1lYm55aFJzelAyeDVVczVoRExRai9YNVR3OHJPeVB2VWNydTVn?=
 =?utf-8?B?bXlvcWtic21MNGdJRTVTbG9IUSsrR2VvbnRZVlBkK2l2ZnZLaTBXd0h3TWpC?=
 =?utf-8?Q?IC2VYqBaaxevm?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5062.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ellSUThGWDNTNUJhclFlZlR6TjBRYmZxOHdITXpYd1EvSFhRVGd5cFJndHRk?=
 =?utf-8?B?L0tvdGxGNUdtYmtidzk2cjlGLzhTcDJ5QWxnbmQrMkxGdHp1N3FCbUEydFZB?=
 =?utf-8?B?LzBYaGRqU2lNVEpNREVqL3VIT0pXZlJqdHdLVFVUaUpqUE1kMVFhdU5BMHhm?=
 =?utf-8?B?R1F6MWZzLzQzUm4rWnRzRkh4Qit6VklrQ0c4SnhpS0xYU2wwSkxZWWlNZFpl?=
 =?utf-8?B?YUVRTVJjd0pMODZnM2daaXNBRGYwclU3V3ZhUVdKM0FpVnQzQzUxVG5GV0J6?=
 =?utf-8?B?amExRExzMU1sajVzUUd3d3JaZVNOTDF1ZXRvZ0tvbTYyQlhNU3JhVURoV2l2?=
 =?utf-8?B?QnBUMVN1RHFIQS96d1pFRVpSVS8rQkpLSml1MGs3SHR6anNKb1d3VGQxSVJY?=
 =?utf-8?B?YVdlSFFEdW9hN3M2UCtrVEx6V3VYTHhmMG5USWk4VklVQ1hzekh3czJKaXhF?=
 =?utf-8?B?YnZIRnM0dW1GTmFLUk5GZFZ4MEhNT0NUWXQwTUlHUGxxdlBXdDA2WFYwaDVu?=
 =?utf-8?B?VkQ3YStwZGlTV1VtdWJjcTBLcGczNEVvTTFaeW9EVGVyNTNZYUhhcmNvdWtQ?=
 =?utf-8?B?empvU29ZVTlOckpuL2VkMFNDMHZtL1ZrZ1p0NDF6dUh4VWNycWd0S3d1VVZV?=
 =?utf-8?B?Qjg1U1BTY0MvYi8rZGtQR1JiRFNWVmk3blN5aHVTVzN2K1hFVENXR05VRkJP?=
 =?utf-8?B?MEY5QzRUNkRmK0c4LzVvWmxZZjFzcXNQbk9RSCtXYlJDSlp2UVNwUUx3blZy?=
 =?utf-8?B?blpnZkFkRy9IWGorZ0YrUkJ2WXpRZlE3ZllWUE9xMmg3SmZTa2lhWE9pNzZM?=
 =?utf-8?B?QldMbGxaWDZHU0dIaWVEZDBuT3VVRTJqM25xOWpJbTdBcFppTmIzQnd3ZlVV?=
 =?utf-8?B?THNvRitZaWtQNWd5R2djV3llNllWQ29iVDlpSmU3aUcwcmhEZW9HbUUrVGto?=
 =?utf-8?B?VThXTmpRck9OQlBSM21NM09QSEZEalFqcmh5eUU5ck1qbDVsMVhZcENIWmVM?=
 =?utf-8?B?eDlMaVkvZityYlZIMXY3Tjg2LzVYcmVwS3hUU1cwb3pLZWtTUEpGNWFiOXB1?=
 =?utf-8?B?ZmFWUU5CNWlhNmhNekExOHR6TTB2NkVDdEpTczNRc0tyeGJjU3lUcXUvd0ZQ?=
 =?utf-8?B?Zml4Y3BHa3JsdjVvOVhFYU4wWERxSzdJN09iVDBrdkE3M0wrbGg2eExGOFY5?=
 =?utf-8?B?VjdVSGZaZkVieER1UUxVSjJXMC81KzkxWVEvTmNsT1FhdWtJWkcxd1dWUG00?=
 =?utf-8?B?V3pLWXFuNGNmTDNwRkJrZDBxME5SNklnVWRPWllqczJCZnVSdkpHaENzWXc2?=
 =?utf-8?B?WUtVNytyeUtDT2R5L28vR3VxR0V5ODRFOVpKZWZqMllhS05LT2I3NzNmUVR1?=
 =?utf-8?B?Wk1UYnUzOExXUm04WG03a21tY1lEYTNlRERwcUQ3VUFrMFcrMXpHTk9WMzBG?=
 =?utf-8?B?R2ZXU2F5T2tvaE1vNGxpQ2w4K0JLdStlQkNVaTA1V2RxZm9vcWZvZzNEWDAz?=
 =?utf-8?B?MDVTUzhYeWdoU3N1Tmx0b1pJOHFITzhGUHArQk43bThobW5nblozdE1XRVZX?=
 =?utf-8?B?Ujk4aHVaQkpGei96NTNyWEthazBYSTY5R2tqbnFVR1RuUjR2ZDQzUGFzemw5?=
 =?utf-8?B?QUxDWG9GamNFem5IUng5YkJOWXRhWWo1cEpKL3VGSTBmMTZKYWIxWDR0S1J2?=
 =?utf-8?B?Qm82aGc0M2NGYlFqaFFzbzhoR2Vwd3hmMkVEc0xvRklZWDV2QlJBWG05dmYy?=
 =?utf-8?B?N1JpSmwvSEVtWm5kZk9pcW8vQ081MVhEbXMxelp0NUlGbjR6cUloYXFxNnRz?=
 =?utf-8?B?ck8zREhjcWM0R1MrL2JyS2w0aUt5TnhBNXdzUUo3VDZ3Rnd1QW9leTFhZDl1?=
 =?utf-8?B?MlZUSDVDL3dsWFdHQ0xCeWFlbkg1Ylpna1JWMkxnVHViUjBGbGhsSS9VbEFx?=
 =?utf-8?B?YS9tTGJScnpKMy9nY2RUOG5qcFJPMVRFSlA5eEZCYkFaSkJmNlE3TWlwQmQz?=
 =?utf-8?B?b0JkOXFxb1EwYkFmUWJvSHVrMXoyQk1EQ2FzUDhscU1pNlhRY2NVQ3VBUkl1?=
 =?utf-8?B?d1N6dWJHVVB0Y2xUbDRJRlhoL0hzVXY3QUJoWkpKZnpldStYRlZ0YTlhUERR?=
 =?utf-8?Q?mWGpFcvS+czrYSsZuSv2sWHRe?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1599c4a4-02db-437e-86b1-08dd5fe597d0
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5062.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2025 15:09:45.8817
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7fYyuzJ02yjr2GSUpneO+JCyfPsZeg/2EBjINsenfAKtGL4BFXNBPE4rUwEPCqm4z5ZOfjeDkRH4O0fML8IhxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5914

On 3/10/25 01:45, Nikunj A Dadhania wrote:
> Introduce the read-only MSR GUEST_TSC_FREQ (0xc0010134) that returns
> guest's effective frequency in MHZ when Secure TSC is enabled for SNP
> guests. Disable interception of this MSR when Secure TSC is enabled. Note
> that GUEST_TSC_FREQ MSR is accessible only to the guest and not from the
> hypervisor context.
> 
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  arch/x86/include/asm/svm.h |  1 +
>  arch/x86/kvm/svm/sev.c     |  3 +++
>  arch/x86/kvm/svm/svm.c     |  1 +
>  arch/x86/kvm/svm/svm.h     | 11 ++++++++++-
>  4 files changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> index 9b7fa99ae951..6ab66b80e751 100644
> --- a/arch/x86/include/asm/svm.h
> +++ b/arch/x86/include/asm/svm.h
> @@ -290,6 +290,7 @@ static_assert((X2AVIC_MAX_PHYSICAL_ID & AVIC_PHYSICAL_MAX_INDEX_MASK) == X2AVIC_
>  #define SVM_SEV_FEAT_RESTRICTED_INJECTION		BIT(3)
>  #define SVM_SEV_FEAT_ALTERNATE_INJECTION		BIT(4)
>  #define SVM_SEV_FEAT_DEBUG_SWAP				BIT(5)
> +#define SVM_SEV_FEAT_SECURE_TSC				BIT(9)
>  
>  struct vmcb_seg {
>  	u16 selector;
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 0bc708ee2788..50263b473f95 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -4504,6 +4504,9 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
>  	/* Clear intercepts on selected MSRs */
>  	set_msr_interception(vcpu, svm->msrpm, MSR_EFER, 1, 1);
>  	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_CR_PAT, 1, 1);
> +
> +	if (snp_secure_tsc_enabled(vcpu->kvm))
> +		set_msr_interception(vcpu, svm->msrpm, MSR_AMD64_GUEST_TSC_FREQ, 1, 1);
>  }
>  
>  void sev_init_vmcb(struct vcpu_svm *svm)
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 8abeab91d329..e65721db1f81 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -143,6 +143,7 @@ static const struct svm_direct_access_msrs {
>  	{ .index = X2APIC_MSR(APIC_TMICT),		.always = false },
>  	{ .index = X2APIC_MSR(APIC_TMCCT),		.always = false },
>  	{ .index = X2APIC_MSR(APIC_TDCR),		.always = false },
> +	{ .index = MSR_AMD64_GUEST_TSC_FREQ,		.always = false },
>  	{ .index = MSR_INVALID,				.always = false },
>  };
>  
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index d4490eaed55d..711e21b7a3d0 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -44,7 +44,7 @@ static inline struct page *__sme_pa_to_page(unsigned long pa)
>  #define	IOPM_SIZE PAGE_SIZE * 3
>  #define	MSRPM_SIZE PAGE_SIZE * 2
>  
> -#define MAX_DIRECT_ACCESS_MSRS	48
> +#define MAX_DIRECT_ACCESS_MSRS	49
>  #define MSRPM_OFFSETS	32
>  extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
>  extern bool npt_enabled;
> @@ -377,10 +377,19 @@ static __always_inline bool sev_snp_guest(struct kvm *kvm)
>  	return (sev->vmsa_features & SVM_SEV_FEAT_SNP_ACTIVE) &&
>  	       !WARN_ON_ONCE(!sev_es_guest(kvm));
>  }
> +
> +static inline bool snp_secure_tsc_enabled(struct kvm *kvm)
> +{
> +	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
> +
> +	return (sev->vmsa_features & SVM_SEV_FEAT_SECURE_TSC) &&
> +		!WARN_ON_ONCE(!sev_snp_guest(kvm));
> +}
>  #else
>  #define sev_guest(kvm) false
>  #define sev_es_guest(kvm) false
>  #define sev_snp_guest(kvm) false
> +#define snp_secure_tsc_enabled(kvm) false
>  #endif
>  
>  static inline bool ghcb_gpa_is_registered(struct vcpu_svm *svm, u64 val)

