Return-Path: <kvm+bounces-67717-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B78FDD11BAE
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 11:09:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7A7F230F0F5A
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 10:04:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 997B729346F;
	Mon, 12 Jan 2026 10:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="LwFRaC7X"
X-Original-To: kvm@vger.kernel.org
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013003.outbound.protection.outlook.com [40.93.201.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42FB819067C;
	Mon, 12 Jan 2026 10:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.3
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768212288; cv=fail; b=H3TObj1lfWH3ricZ4btmEMRNUa8uFiyxM2vaaXjmBRMkTbWKJYD21G/HJdxcpH1r17kMD7pBgCbofUa4VFBz8ugLf/v+q0+67ZupPi8yKLMfcKIFZZulOX3jrKkm0L6Ms9c1qsAU7zotJtxSH6a+kyCZaQvSrxLHguz2nLY52os=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768212288; c=relaxed/simple;
	bh=EE8lVOSqtTOAoAz7fhOZOWjqg8KsoNhmTfhN+3YFp7s=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=G7YNf5wVzG0ISHOK9Gb2NlO05eKB01uNvU3s7N/axxai1+bkIq/ENFGG8w4jX70YoRD43zpfdOcxNM+hYuQp2Bzfcce4qJhXp68F6pF5jL/sIMRddBJNGXDopYyCVcxRn9HR76pVRMXKcStrIAlpmdK7AWLYGYjpqI23UJIV0QI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=LwFRaC7X; arc=fail smtp.client-ip=40.93.201.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UQHBhT3aBWLNQ4h3QomJfE0w8v6ymrfQFbs6zQ4FLet8xBQZY3j7rMrMOM+14cEa6tQ7c9rvoJ+AS4B85RZsSHKykIC4DGJYo8BpQnRNbu8lrO6pBD0iWsyR/JRKhzApI1Zl0ADJsVXzQ1a3Mt6R17joaQgSwv+9tioKO0996C0d+JmAq7hPNPYgip/fp9qIDzPM2o2wsi2iOcgqJCNIkxOhoz4EDcDXL3LFC/7HtPbJXLPeWuKI6M4D99Svbbdmpi+zG7ZMhqmj2eZQEEHYg/FxO88T+Jr4W6RWacZRLJBJ+9G/dAx67hhUBydY6vdMBa+Cyx4ygODeDLiideWMdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jQiY3qH2y2VRIQmxpoKfaF8HSv/MOOTbOatZ+hKs9xo=;
 b=lOo8+mqEmsDtuBj9pVxOSvFWNxehoGsKlmMmkj5bnGXCOULD6axnI1a+nzBQLchWBwxPzLv9yfz5A0sj3lIl7j3vnElUyL+e/a0cQ7fjGhezx+mmLnh5yA8PUsZ9hHdJeKQTeWjOlzBLESK764K/f+7cF+v6xgWaWCytK7mxpQWh1sIzvXqgkSTBrtFt7AhMqaR/ecGHbZoUOo52uoLcv8mEtIRTYrdv7QgUIYHsvkE4CfKsSSry1kEpDzdszM3ZaTEPWjWlQ4meeObYJzom6G0Gs39iVFTFJnBcT5J6Fxk3jXtkMSKNAFjmDbHUAQftTD2cFNlEVZZOsjM5bdNfZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jQiY3qH2y2VRIQmxpoKfaF8HSv/MOOTbOatZ+hKs9xo=;
 b=LwFRaC7XgHB0gOsM5bCuoN5CE2gI2A4i7Agj6EnIYkbrvggKY3X03NdZ/wJ+RO1cQUkbAusw/h/h54jx/hWJI7AmeoGss3cP13eNGY8f5AtztGdoISXnOgHKccYKI77T/rP+I2kvsVNeg9/Ao1c52kT+/i7m4uFxmroE9OCvnNg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by DM6PR12MB4043.namprd12.prod.outlook.com (2603:10b6:5:216::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Mon, 12 Jan
 2026 10:04:44 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::46fb:96f2:7667:7ca5]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::46fb:96f2:7667:7ca5%4]) with mapi id 15.20.9499.005; Mon, 12 Jan 2026
 10:04:44 +0000
Message-ID: <eed9fd4c-ca36-4f6a-af10-56d6e0997d8c@amd.com>
Date: Mon, 12 Jan 2026 11:04:38 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] dma-buf: add revoke mechanism to invalidate shared
 buffers
To: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 Sumit Semwal <sumit.semwal@linaro.org>, Alex Williamson <alex@shazbot.org>,
 Kevin Tian <kevin.tian@intel.com>, Joerg Roedel <joro@8bytes.org>,
 Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linaro-mm-sig@lists.linaro.org, kvm@vger.kernel.org, iommu@lists.linux.dev
References: <20260111-dmabuf-revoke-v1-0-fb4bcc8c259b@nvidia.com>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <20260111-dmabuf-revoke-v1-0-fb4bcc8c259b@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BN9PR03CA0787.namprd03.prod.outlook.com
 (2603:10b6:408:13f::12) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|DM6PR12MB4043:EE_
X-MS-Office365-Filtering-Correlation-Id: 3b57b368-3d23-467d-580d-08de51c20299
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UnAzTTNieXkxN0crOE1OVTV4NjU0YXZhdkxjK1V6UzdPUmM3a05OYzVjN2U5?=
 =?utf-8?B?bHk2blNYRlVmMkRMbjIxYlJtNXlaT2pvT1VJTlF0WUlLeEVTczEveEJWVDgv?=
 =?utf-8?B?NzBCT3BmUGM1YVlpeWxmdUtjTFJudzlzNkVFUFh1RGFRKzhYaEd0eDVIQjdq?=
 =?utf-8?B?dkFvYW9OUEd0OEpHMGxlZ1ZhUkpaQmQ4d1hKenlHMzUwYmZlZ0FKUUxLblJZ?=
 =?utf-8?B?anNWR0xFNmRzUHlCR2tvS2ZCcWYwcjhTVXpyWW1RNnl3Z3BaNzlOR2JoS1lw?=
 =?utf-8?B?dTcybmpySEorYnFSK0RDb0gvRU1meHBHekNFSXpzR0NQNkhrY2NsQ2FhZ3I2?=
 =?utf-8?B?bGZPVU15QzBocXhOWkFSYk5JeVV1Mm5haXljWnJUQ2NuekNwNisweDlPRUxk?=
 =?utf-8?B?RGFXQTBvQVdNZmQreTZ5T2lhcjUwelVpZ1ZIc2k4VTg4NklacTNHcmhlZkwr?=
 =?utf-8?B?MVhadlZGUXJ1Z1pDZzZYRzQrVDczaUhvVFpNZENaWW9KaGpXcTloYzM3R1VX?=
 =?utf-8?B?ZmtsY0lsRWIwMldXV3QyNEZlZWxYM3VPcFNLdkdJK1hQZkM5aVlCQjgzeVhp?=
 =?utf-8?B?QXljU05OUXBjU3kyK0pvSkIwOEJBQ0ZaTk5QcEdMWDg1YjdOcUtUYndwVTcr?=
 =?utf-8?B?U21ya2J4cUdKNEpZc0V1VG5jZHAwa2xoY0kvNDVLWms5QVo2Y3VqTWpCWURn?=
 =?utf-8?B?cEFFQ3dnSVNyMXF0ZGVPV1FzZklTVGhxM0NhOXNET0xud1RCSU0yRXNuUjVQ?=
 =?utf-8?B?SmlnZDlhVktzZWEwOXRHVU5YNDI2bmZnR3hiZjQxaVVJajJWc2twZDFMN1BZ?=
 =?utf-8?B?NFM0RmVHbGZDUU4rWkdzU0tqZEQxSDRKdmxJRlhPckVxM1ltZGVFbC9OUWJ6?=
 =?utf-8?B?WkhKQ0hac25WWGpSQmJNT2svUjN1bHVCaHppampwOFhHU2VncUVnQ2FhZU5k?=
 =?utf-8?B?MDA5RFdYRzkzb05GQzlvcEo2K0FDQld5aVpDTlJDb1BpMHBMdndoRWszd2p1?=
 =?utf-8?B?QVJEQXEzZW5leWJDTUNJYjdTbEZDNit1MDJhMUI4RmVCQkUyLzhqSnl0Nmxt?=
 =?utf-8?B?TXNZZHJyNXdweW96UjFMMlRHNkpqOUZIK3dHcm9waWZSVnREaGJqYWN6VTNZ?=
 =?utf-8?B?VXdIZDMzU2JlekZyUXBmUXRkazc1REZ0bE9ZYisrdHBlTHIxTk93K1lXcFox?=
 =?utf-8?B?NHB3eFRSeXZ4VVIrVG5Jc0k1ekorZnk5OWhVeHUxUHM2a0V0TCtCMHlqT3d2?=
 =?utf-8?B?endBL2NhV0RxSnhMSndaRzdoMmMwcmpZb0t3Tm5VQ2VlOFJXY2pielBNcGFF?=
 =?utf-8?B?WDYzb0EyREQvM2pBS0ZEbnFZdUd5Vi9pUTFNblpsTkhBZWpZK09xY25hWjVI?=
 =?utf-8?B?TjBhNFNvbUVqYUF4QjI4b1ZGQzNINW14cEowcEp4cm0zeHNTNGg3SVQzeVd2?=
 =?utf-8?B?M2pVOXQ2cmJxSmNVYjNkZlozT0doK1FLTGhBaERhbTcrek0wc25jZ3hPN2hz?=
 =?utf-8?B?MDlkVU9yR1kvSnV2V1FMSEM1ZmtwVW9KR1Y3Ym9OS1JESDl5OEJGRE9COXAr?=
 =?utf-8?B?dVplcm9aNENKRHhZckJaMHovT3RQaW5ma2RTNE5rbEhGN2FzVEZwWGp5UkFy?=
 =?utf-8?B?OVlZRGp3WDI4TGIwNkFMU1V1dkVBL3o3NmEvZC84dDRWTzhpM3Z0eEtvWlU5?=
 =?utf-8?B?Rmx1K0k5ZG5LQUNqZ05CdXo4eFdtZEdSM2kzUERDVldaR0lnWWJ3T3IwOGRJ?=
 =?utf-8?B?dXppUlFHeUpoYndBZDBuanFnTWQ2cUJTZnZKMXV5Q1RGNUhwblVHYmk2REZq?=
 =?utf-8?B?LzNpeVlYK05sNCtnZ2dNbWRJQitDSjNndXVMUXhVNzZaWjFKL3BJKzlNY25a?=
 =?utf-8?B?a3RJVEdjcnBQWWo1dk13YjVPWHVsMkxBTDByZnFiSEM2cGFQZWNrWU1weFc1?=
 =?utf-8?B?UDNPWWU4NVJlMjBZcVhkWi9XUFRxSjdleGszVnV2a2ZFbFZVTVIwWnk0bnFC?=
 =?utf-8?B?R1VRWGwvek9BPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QXVqcXpnV3NYVWovZnZWdUVQdldvWXQ1L1pydmlHa2JrRkdvYTZRMEZvWnRV?=
 =?utf-8?B?QmlLSFRoTURpNEpmSDYveXNlcHRuMlJlcndzcVhpUWVJWjdweEdFeFhYKzM5?=
 =?utf-8?B?OXBsRExwUUJUNlZvZFVkaWpPUHVOa0crTjlDd2FaU2FXMmx1eG5UZGxrYVpX?=
 =?utf-8?B?bU51SVMxdW1STHdrMzZFdGRwQXZQWUhnMjZkWDlYMDgxMnE3ZCtScGJWRTMy?=
 =?utf-8?B?Y0JEWDJUUHVweUx4ZWl5d0k2S2xXclk2SXlmTnh1RSs4YzlaTHBXSllvYy9T?=
 =?utf-8?B?ekVXSEhlUmFsRGZRUTBZSGgrcDNUN3VxdUIrczhQaThZZVpJV3Zpc1NhVFBs?=
 =?utf-8?B?VW4reVcwL0JNWkdGam9RRXJrT1UxZUNlWXhMZUVjY2U1V0hTeldGVUIvYldZ?=
 =?utf-8?B?SVlGTXlzbFF0SXJGQ0ZyRzJwcWdQNWh5L3dXRTNwS2pPRHFGVXlDLy84RkZQ?=
 =?utf-8?B?NHBvMmJ3dlpRNzBHYU90RTM3ZkdlN1JGa093MERYa0V3QnllaEU2Mm5qdm1C?=
 =?utf-8?B?R1lTZjVqeUdJbWlUTEZBOStnVE1qOXpsTFdrd0JKS3pKZ285eTZoSS9ZMWdD?=
 =?utf-8?B?MlpzdGd1RWRpNENnS2dFb1lEenhOeCtXaWsxNXRDT1lPY3k2dU9ubUh6bjEx?=
 =?utf-8?B?MlFxYlJzQ2x0aFNNMXMrREc1eXp4YkphRjladHJBMVNUMnJBd3dBOW0zTklX?=
 =?utf-8?B?THZIVjlGNGFzK0JZL2JaMDhzVFcrTkdmaUZrQnhNOXFER2gvMVUvOHZkcldz?=
 =?utf-8?B?QzZiaVdlSHVJQ3dKODZ2UGM2a3JzSkw3WnJDWXptL3cxTXJFZ3UrajRGdEJL?=
 =?utf-8?B?WnMrRFVUTUIxMlA1VHFNK0VBbE5RRWxFeS9NTUJxWDYzbDduL3NJSFJrVk5W?=
 =?utf-8?B?c0lPamd3dWdYUGlFdXBUZi81c25SeDFnTGx3YXlqM1FnRVlMbzdNcXAvK3NJ?=
 =?utf-8?B?UjM4UkI1R2Yrc0l0YUltbUtwTk5nNHlRalJrcmEvYkE1YWdPMXFyaS95SXRP?=
 =?utf-8?B?Yk56RkUrcVNDYmc1cndVT2RzaUFSUnJqa1N6MWdDMVU3MmF0bzk5TVRBcFI4?=
 =?utf-8?B?QWNFd3pBWFZ5bFY4WW9NZEIwL3BlS05kWnBpMlNzN2FkYnFWTTZvQzhrejJ5?=
 =?utf-8?B?Z3A2aitLNHJWcHM5NllJS0hlaWtyUVJJNFJFNzJ3d1BUZ2xjTVhMYVJJMjhX?=
 =?utf-8?B?SENPOTgzMkRheXljWUZDd3lVREJDakRkOGVOWU1xSnFybkxkV1hnMytjL0Zx?=
 =?utf-8?B?WVNuSVJOUXBRR2h5UDlZTk93cXNKUkUwL2dRSlgrZVF3TVllaytobFc2UDJL?=
 =?utf-8?B?dDZQYWtrd3ZtdkNrWjd1QURQYXRFRm1sOS8reWxHRTlxckFPc1A0ZFVnQlk4?=
 =?utf-8?B?MUE1bW56RTQxaUR5VUtwZWovUFBJSTVJckU5eGlrVzhiVmVEbzA1ZEtBRHNw?=
 =?utf-8?B?TGw4VkIvK2RtYUdOdDY2V1NvVzc3ZE1ucFp3bjQxUWx5bjRXY0JLK092TlZS?=
 =?utf-8?B?SUZwaHpYaEZ6cEJPL1RRUXpVdmkvNnRaOTdVd2RTRDZxOWJzL2lLenA0R2h3?=
 =?utf-8?B?bXg1alRQWm1xQ0ZiM0lIZ1EzVjhKVkxCZ2xlWFJIMStIeXA3b3hBRFgwVHAz?=
 =?utf-8?B?czhHNDd0S2ROM3BTZ2ljSFRDclpPeGc5NVBYM1hBanZEVUMvREJaVDZFUGJu?=
 =?utf-8?B?YkV2RktLTTRWVG9SbUdESU1MNVMwMDIyNXhZVE9wS1NncHVYZ29FbWVSbDNa?=
 =?utf-8?B?WThhVUpYMEZHRUpLWDZ5RFE5dWE5dmtDbHhHY0h5WDlSNXBSazNDUkdjL2FX?=
 =?utf-8?B?RmFTbXlDWVFBWVQ5RHV3Wko4QmdPdWJnQ2hOR2tUWHV1UFhTQ0Iva2dueFdJ?=
 =?utf-8?B?cWdjcDlaZVExMGNQcS9BS1VpMjFwbGRBYjlOb2VIY2V1aUtaV2MyNWI3WTN5?=
 =?utf-8?B?UGd2SWxpOUpyb3pOUmRoL1RaMGtuT2syM0lldjNFRGhlQWxMQ2pkZlVMdEQ4?=
 =?utf-8?B?eDFuYXNhSGhrMGQ0bXg1TzVLVHFpWDY0aWRJWTJCT2hGZzk3Y04za2xGOGtJ?=
 =?utf-8?B?YlFwRmNLcll0YXp6cEpoUkc3bDNSamRLaU9jR0doZmZYWFIwWGRhaGlrbkxR?=
 =?utf-8?B?dnV0T1VIcktSUDhvRGh2UGF3bDNla2I4cU9EbnFkaU52SFBjUnlCL0J2OUhm?=
 =?utf-8?B?aXc3SVZ3WEkxMlE5YWV1UjRHUGNkaCsvMW5ScHZ0K1duODF0MHJ2QlAvR3h2?=
 =?utf-8?B?MjJrVDhDcTFMVlplRGRsbGpoaFJxT01YMy9TT3Y2RlRLSFpWaElad2E4Kzhr?=
 =?utf-8?Q?R2Ud1/0uqLxd+gz1pu?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b57b368-3d23-467d-580d-08de51c20299
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2026 10:04:44.3550
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uMxbMXMcFsg6aXFsWv3EpWINSh6r+zR8lJJovGI5N9p5ipl0kMAlJSSPJYAw42Nu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4043

On 1/11/26 11:37, Leon Romanovsky wrote:
> This series implements a dma-buf “revoke” mechanism: to allow a dma-buf
> exporter to explicitly invalidate (“kill”) a shared buffer after it has
> been distributed to importers, so that further CPU and device access is
> prevented and importers reliably observe failure.

We already have that. This is what the move_notify is all about.

> Today, dma-buf effectively provides “if you have the fd, you can keep using
> the memory indefinitely.” That assumption breaks down when an exporter must
> reclaim, reset, evict, or otherwise retire backing memory after it has been
> shared. Concrete cases include GPU reset and recovery where old allocations
> become unsafe to access, memory eviction/overcommit where backing storage
> must be withdrawn, and security or isolation situations where continued access
> must be prevented. While drivers can sometimes approximate this with
> exporter-specific fencing and policy, there is no core dma-buf state transition
> that communicates “this buffer is no longer valid; fail access” across all
> access paths.

It's not correct that there is no DMA-buf handling for this use case.

> The change in this series is to introduce a core “revoked” state on the dma-buf
> object and a corresponding exporter-triggered revoke operation. Once a dma-buf
> is revoked, new access paths are blocked so that attempts to DMA-map, vmap, or
> mmap the buffer fail in a consistent way.
> 
> In addition, the series aims to invalidate existing access as much as the kernel
> allows: device mappings are torn down where possible so devices and IOMMUs cannot
> continue DMA.
> 
> The semantics are intentionally simple: revoke is a one-way, permanent transition
> for the lifetime of that dma-buf instance.
> 
> From a compatibility perspective, users that never invoke revoke are unaffected,
> and exporters that adopt it gain a core-supported enforcement mechanism rather
> than relying on ad hoc driver behavior. The intent is to keep the interface
> minimal and avoid imposing policy; the series provides the mechanism to terminate
> access, with policy remaining in the exporter and higher-level components.

As far as I can see that patch set is completely superfluous.

The move_notify mechanism has been implemented exactly to cover this use case and is in use for a couple of years now.

What exactly is missing?

Regards,
Christian.

> 
> BTW, see this megathread [1] for additional context.  
> Ironically, it was posted exactly one year ago.
> 
> [1] https://lore.kernel.org/all/20250107142719.179636-2-yilun.xu@linux.intel.com/
> 
> Thanks
> 
> Cc: linux-rdma@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-media@vger.kernel.org
> Cc: dri-devel@lists.freedesktop.org
> Cc: linaro-mm-sig@lists.linaro.org
> Cc: kvm@vger.kernel.org
> Cc: iommu@lists.linux.dev
> To: Jason Gunthorpe <jgg@ziepe.ca>
> To: Leon Romanovsky <leon@kernel.org>
> To: Sumit Semwal <sumit.semwal@linaro.org>
> To: Christian König <christian.koenig@amd.com>
> To: Alex Williamson <alex@shazbot.org>
> To: Kevin Tian <kevin.tian@intel.com>
> To: Joerg Roedel <joro@8bytes.org>
> To: Will Deacon <will@kernel.org>
> To: Robin Murphy <robin.murphy@arm.com>
> 
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
> Leon Romanovsky (4):
>       dma-buf: Introduce revoke semantics
>       vfio: Use dma-buf revoke semantics
>       iommufd: Require DMABUF revoke semantics
>       iommufd/selftest: Reuse dma-buf revoke semantics
> 
>  drivers/dma-buf/dma-buf.c          | 36 ++++++++++++++++++++++++++++++++----
>  drivers/iommu/iommufd/pages.c      |  2 +-
>  drivers/iommu/iommufd/selftest.c   | 12 ++++--------
>  drivers/vfio/pci/vfio_pci_dmabuf.c | 27 ++++++---------------------
>  include/linux/dma-buf.h            | 31 +++++++++++++++++++++++++++++++
>  5 files changed, 74 insertions(+), 34 deletions(-)
> ---
> base-commit: 9ace4753a5202b02191d54e9fdf7f9e3d02b85eb
> change-id: 20251221-dmabuf-revoke-b90ef16e4236
> 
> Best regards,
> --  
> Leon Romanovsky <leonro@nvidia.com>
> 


