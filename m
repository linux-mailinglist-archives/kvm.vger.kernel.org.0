Return-Path: <kvm+bounces-34851-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 76512A069EC
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 01:28:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ADD5B3A6CBF
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 00:27:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2749B4C8F;
	Thu,  9 Jan 2025 00:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="LL6DzEMk"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2045.outbound.protection.outlook.com [40.107.95.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CDB7B660;
	Thu,  9 Jan 2025 00:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736382469; cv=fail; b=U5f+7ojaG/sDp5jRPImRulbQknKZcEpfKJLd/Mj5ZpA8+tXSbTFjec04vodyvGafZC9Z9lIZfQ+sCgHfSRC64KPlP1BJyE0VUT+JMj5cKA2exSH8FOG0SSN+k33KPXKmRWNH9rjVX8I4VSr3ZOGUFZAHr6Io1nEmLPAv+NRT174=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736382469; c=relaxed/simple;
	bh=eEnIPJVzTd0lCN8LLuuVtQPqUrq2v6SuvQVJFHILsnc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=tRcNxvmwmxavRL5I+3p/oUDykAac74C6QFyBi4or5FH5vvVKZfaqcJlSW8hSAMSVzFagNXZPyIz4HbvUXt8n+3sHBVnRXENdKZuQOA1KjbEGK8FFWQP4P8fwxMfUZDdmQqNNc0HvEX4XZi4jlusy8pHWPaXgZIBVI3SFxToCFWQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=LL6DzEMk; arc=fail smtp.client-ip=40.107.95.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Mx2hz+Lp1uFtdC+zYykoU3hFpyUw29dKwmi0YzYqjiB3rO6PqJXhbEcvI7+TVJxM9HJMdY3S3ujW5Pndwh7IVzkuvbznqnPnNvF56OZc9tCP5kzcyxbabcT1hpRtsWxhbV9335KqfqoGW3RpvLVu77actOJm82HWDBSWiNyVbmICHfwFEa9+q6eZoyRkflmI0pi2IdyrKBwSSFvSqEEseH9f8z1gd+XcVjcu/lM33+cVuw1iTgoSI4kOBvbSzCAGTa3tnw4M9yjesmvZUN5cFkfl+yWPLvb/PlN8U2pSTwR5LOWKPJzwyCZBSz9wqJgMYOUWZ5GVO44dHXfCSzVcTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Dc5H7p1OMawhAks38xWEDnQQ4paaQnwQe4piNnqz8FE=;
 b=RWBIMwNbZeq0TbsMIkfPON2f4BCGZuF+trMnrL3mq3MnnWHNdadDq5teZWdi5nLMzMmEF/Fx75Z/rLQ2cpG8c7Hlo2d7Zb3jiUUTqLfM0tHqOuoGQXUj0P+NA0Sz57YkqEB7Htg7YKzRy0ddxrtnfNaVvhHHx5Erb7gMGOpx6cuIWJR0jHNoRa/tOx1dQQCZA/B3ksRx3qMeoEB0JfPGCKwArzUjdI0Cw0JOjloeVVu99CVsXqu7wyUoDwQO7sC79BytF4kWtQ6yKi2+sxUDqTMmiH1MD+qBave/vkZztXHUvbbI479Y8SCVb7779s4JNJ4ojnbmAqMkPwMn82rz/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dc5H7p1OMawhAks38xWEDnQQ4paaQnwQe4piNnqz8FE=;
 b=LL6DzEMkHF4SvtqAcTL8jdM7paHx+769J6Ot3VjQR2EC2po9TkH8EW0eduysuDNJ5TXlstDortHKvcyAn6Lv0XjTuMdYs1d1KZriQh4VLnTZ6n6oQkMtgkY7REWCfY7acxs0YBYmvsPcJ58j/OS/IX/Jl+RwVNcZo3liTKWjGPM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by MN2PR12MB4269.namprd12.prod.outlook.com (2603:10b6:208:1d4::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.10; Thu, 9 Jan
 2025 00:27:45 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef%3]) with mapi id 15.20.8335.011; Thu, 9 Jan 2025
 00:27:45 +0000
Message-ID: <ee9d2956-fa55-4c83-b17d-055df7e1150c@amd.com>
Date: Wed, 8 Jan 2025 18:27:42 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 6/7] KVM: SVM: Add support to initialize SEV/SNP
 functionality in KVM
To: Tom Lendacky <thomas.lendacky@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 john.allen@amd.com, herbert@gondor.apana.org.au, davem@davemloft.net
Cc: michael.roth@amd.com, dionnaglaze@google.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-coco@lists.linux.dev
References: <cover.1735931639.git.ashish.kalra@amd.com>
 <14f97f58d6150c6784909261db7f9a05d8d32566.1735931639.git.ashish.kalra@amd.com>
 <6241f868-98ee-592b-9475-7e6cec09d977@amd.com>
 <8ae7718c-2321-4f3a-b5b7-7fb029d150cf@amd.com>
 <8adf7f48-dab0-cbed-d920-e3b74d8411cf@amd.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <8adf7f48-dab0-cbed-d920-e3b74d8411cf@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR03CA0023.namprd03.prod.outlook.com
 (2603:10b6:806:20::28) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|MN2PR12MB4269:EE_
X-MS-Office365-Filtering-Correlation-Id: f23ec598-a7d8-4b7f-058c-08dd30446fe6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?enhWUHYzMkVmOU1zcG1GL1YvM3IxbjB2SWFNdnY4cjc2VytrV0RXRkl0Vnlt?=
 =?utf-8?B?Z2FtVVp5Y1llNjlwRFA5cVNMa1VXaThjUHNLYUNGK1JIYkFBSVY3aExIdVd5?=
 =?utf-8?B?cnF0RUd5Ly92VmpHVXVDNk0yTWFvc1dtVWlaZTQ2c1pZYnFRMDZaeENISm1z?=
 =?utf-8?B?WTlmWmdwbTRVNmp6UTRiZ1ZvYXc5emZ0R3R5UHNPNEQvNkVTWThtSTVzZ3pE?=
 =?utf-8?B?c28vN24wMkN5U1ZqUnM4a3NsL251MXBmVjg5TnNzTGg3V1FORzFWbGZyRDZi?=
 =?utf-8?B?aW9mWGxuWW9CTjI3RCtmbGVYb0h2b0xuMWdtMkg4WjhOQS9qdWdWQ0pmeU5N?=
 =?utf-8?B?cmduK0pleldTU0luNklFYkQrTE1HeHpzN3lpbU8wOVVNZ1pVY3JEOEU2R0M0?=
 =?utf-8?B?aUZBN0tiZDZCMWt2dlZnK3JKdlZLSE10MjJDaFNDVzR6VlNkOWl0WkI0WlVN?=
 =?utf-8?B?a2FnSnRjL3A1d2diOWtzYmpSYVFKdHFzemx1WlF3clhkbHM2YUJMM3UxT2dm?=
 =?utf-8?B?WTBsdE43cWw0a2E4MEFaTGpia0FSRllaZldKdW1yeUFSUGlaMUd1ZmF5OEdY?=
 =?utf-8?B?UFZSWUtGcU5lL3JQSWl3RGQ0ODVTU3VVcjRhQTVaUy83VnY4aXJ6eDRYNDJO?=
 =?utf-8?B?N0hpU1lpTmJtUDc1NmdTRW50c3hOWkkrNW1VNXhCR2pYeEw1K2wwdFozNkww?=
 =?utf-8?B?SjBiUnMzVXkwUTkzeG9aRTVmZXJuZ2dYZUhUQXdRcGZ4cE82b3luNXBhYlpU?=
 =?utf-8?B?Ny9Oc0R4OHVxQlBZeWQ5dWlPL0s3dllyMEpVcFZDVU1qKytCZVYzVHYxMXFQ?=
 =?utf-8?B?QytITXFwWGtSRVBhUzI5c0ZlV01IWGM1b0VlSW9XQ1ZZeVF6aENkekU5Tm0x?=
 =?utf-8?B?elpQSVVkaXNGdnNjSllKWm5Qb0dOZjJHYms2NFdob1h1NXFVdEg3N2xYWHJq?=
 =?utf-8?B?eEsvWWVRbnVwN2dONUlIMDhLQ2d2WjFjR3preVg0d3B0RVBxQTUrb1Q3ZFdj?=
 =?utf-8?B?Tm5PYnUzbVVTRGFiTlFEZWZpdVZCYUNIalV4d1MvK0QxUDlqc000VmxuMmg1?=
 =?utf-8?B?dW8vY2wvZG5pMHEvQlRNYzZRNHdVbXQ1UXR5MlBsSG10UmJHRm9GdVlZTjhp?=
 =?utf-8?B?cXZZQjdWMDVqMW1MQjlnV1p0bWtwN2RrVko1RjZLWUhTdVJza096ZjJKVFdD?=
 =?utf-8?B?c2tCV3dWK0crRldCRThSUHdYYWJXNFAzWUNSWjAwVDZrOW9QYVVVaXB6Tys3?=
 =?utf-8?B?Qm55NUZMKy9iL2gvcGthcysrbFUrVGJvbUJjSjErQXBBMnFYVDVlTU1iTkhR?=
 =?utf-8?B?cmxoandCVTN1d0VabjVoU0tQNzl0dnF2RDlucHZmQ1l0MXI2QUd3aFcxR0Fy?=
 =?utf-8?B?ZmlkUWxUditIZjlwNWxRVE5Ccy9SM0Y2UnY2eVhSUW45WGk4Q2tKV2xNV2F4?=
 =?utf-8?B?Rmdjd0FwTlRRVVZCL1FHbUdQb0tDVGE0RmNTOVladHRkZVpTb09XRG1saEh0?=
 =?utf-8?B?L3lsQ3J1dFIxdkNwT2I4T2Z0ZzcxU1QrcmtKZFFyVUErZENSbmRmbWJNVEtx?=
 =?utf-8?B?TllpRVZSL1lYSk5yVjM3TDV1VmRwdE50bUtzU2RSMEJKK1htcXFtZnFvYkY2?=
 =?utf-8?B?ZmQyT0pQZ3hrbEkrVSthd3dHa3JGdUc2SVpGMW9VaSsxdXE2aVd6RkFJRlhH?=
 =?utf-8?B?V1RHL0NHemxVOVY4YkVhMHBvcGdXeWdKbVNwQ2xoR0pGaEo0Y3MzaFdQNlFB?=
 =?utf-8?B?Z1JQejR6Wk9WWmxMbWVva0ZqYUsxRFhEL3Y0WFg0dG1nU0F6L1RRMW9lSkxX?=
 =?utf-8?B?UHNNSGRJOWxSdVIveTk2Si9tZjZYSUtyR05UV1B6K0RaVXkzSjZCQ1JMbkdk?=
 =?utf-8?B?YXJMSkhibnZJcWdtVUJzcm9sQW5VaFdjaFJ6U3REQVhQMUdiWkNaeEx0REZT?=
 =?utf-8?Q?gtNREG6jrJI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SEw0MVM2RmNFd2RDZG9xWXNZWGsxVEtSQUdpNDQ3VlYrT21KekRCN0p5V000?=
 =?utf-8?B?MXM1RFAxNkQwa3RNS3VpQWpnZzZGaWtTZDlPaWtoZ28vVEMxSHRUSXhBMHZz?=
 =?utf-8?B?Vy9PZ1UxNGliNW0wS05UK0gzRy8xUEpwVmxDcWJXWCs5bk5MWGdTYmRSV2RW?=
 =?utf-8?B?VDJJWmZaSmdUK2NUWCtOZHpzRGZzZkg5MWN2dG9IMVJ0S0d3K0t0TW1oLzhH?=
 =?utf-8?B?YWNXaTdNNWlXNkUvU1FCV2hpMlNtbUp0VzdMUWNINU5JM1hMUXNiM1ErbHBy?=
 =?utf-8?B?Y2VsdXlnMzdoVVpMZ1VmWTF4bVQxa0xaaWVXaXJsZERNOXZXVmsvblNDTXFP?=
 =?utf-8?B?ZEx5RFhzdTQrRk56TXUyejZ3ckhyYVdOOTV2MFRjUDZVdHF4czdDNGVqRDhW?=
 =?utf-8?B?a1Z4OW9wQXhuQlJabVpPNVdMak9Ea09Yd29TeDI3S0h2VUZCK1lkZ3dEQmMw?=
 =?utf-8?B?bWVvNVFRWDBUQWpiL2Q1eDM3S3ozVGdhUTZNRFZncWxrSURtTlFVdTI2UjNN?=
 =?utf-8?B?U3YxQTA1bW5EaXpraHRjRWdrUjRUbHZMYks1b1RVVEMvbUVuSWhBTCt3M282?=
 =?utf-8?B?aEg0dUFvdmd3cnNWMzBKMTZQTVFaN3A3b0lCbzQ0VDZ5QXMvWHl0bUw4Nlh2?=
 =?utf-8?B?M3locS9KazY0OGdXNldLWEdHMlFGMEMxRVc1a21KNmJsOEpkL0pCNmU3NFdY?=
 =?utf-8?B?T0YxSldHRjZkcXF2YUlZVCtUbjZWOG9WVHd6Skl1eGxuNVZnMHFheUpKSkZo?=
 =?utf-8?B?Y1YxSjdpbHB0THQvOWJ1UHI5UkFOemZxcjNxRnljWktTSjNhRzYremJBUGts?=
 =?utf-8?B?cUlPcHpFRHk1a09TNEROc2l2T3NCc05ybEdQSDlodGFEL2FKWHRSa3V1RTZt?=
 =?utf-8?B?RmtVNFpvcW0zUVR3WXFjZG9qSTFOMjRNVWgzdWxHM2FrODkxNWliUVc3dXAy?=
 =?utf-8?B?cmFlSmk3WHVmSVdEQ3NWYmdpenY0cEV5K0RDTE4wckNFelROMWhrZGloUDdy?=
 =?utf-8?B?K3UyajFaVkN0Y3pWNVBhQTIyeFZjQTdDVVkxay80dW50SnlpVURPQ2d0Y2Fk?=
 =?utf-8?B?dXdkcXFZc1gzc1h2N21VenRQc2V4ZnZ3MjRrbFNZQWp2czVNTDRYb2JyUlVl?=
 =?utf-8?B?N094UjVHdWFmZEhJWU92eitUSmg1dlBRU0picW1iZ3haYVhJZjVhaEd1K0dt?=
 =?utf-8?B?S21mZkhuMGhReXVuaGltODNiQ3dQSndkUHRCZVF3WFFyYWtraFFLNmljWFMv?=
 =?utf-8?B?NGc1QlFKMUZqVnd5L294UkcrVytlL3lrQlBWOXQ0L1NTcFg4Wk9BZk5yb2FS?=
 =?utf-8?B?aWd2bmRYazIzRy9QeEsrbWRuMkpQUEV6d3ZSeGRqOVh6bXZZOWtiRlI2Vlo2?=
 =?utf-8?B?WkxKQzRDV3N4d2d3RjJZNTFUakVxdHpQMWJmQ3E1SlpEU3pmc0ozTUlUblFn?=
 =?utf-8?B?aE1yTmozdjN5QTFpcTJuSzRlZXZscU5HTXl5TkdRK1FwZ3gyd014L2grcCtP?=
 =?utf-8?B?NTZzQUhUbFh0TDFjZ05iaFYwRGJqS3o3dWdvN1hvSWpOU3ZPK3VBVDFza2FF?=
 =?utf-8?B?Z3laNm1acTE1eXBEQnZGNkdCdUpHTUNWNVg3cmFLdlk1dzYrbnZ1d05wNDJ4?=
 =?utf-8?B?UHpLUWZ1M3Z0SEU0TW44R0Q5Um8yZE96S3FYRlFJYnMxMFR1M3NMdm5ocVJm?=
 =?utf-8?B?SzRSbFFIZ1lVY1ZSelB0ZmhMajB2QmVtTCt4aXRUUHJzV01zb28vYWNOUE9I?=
 =?utf-8?B?d1FkbUJZZVgySmlvUlVnOWI3TlJuNFVJUEs5K2hheGtZd1hpTFFLZjR5cHVn?=
 =?utf-8?B?K3FHOUk5Rk9JQ3RJMWtvWFhINHBzdUtXdUdjZEhjMVpwbmFORVdvMC9uUi8z?=
 =?utf-8?B?U1pMdSt2bGU3MWh3d1FlMUtJL1hVMG03cjFjM2FTVXhWdGRlVjcyRUtOTWJ3?=
 =?utf-8?B?SDV1UW1mdGVvTE9kemZscTQvRG96bnd3WnU4bXM4bmRVRmJXY0I0NFI0VTlj?=
 =?utf-8?B?Z2Fhd1JVOWdrRVltTFliSDVNV05CNVdjSHplRDZXdnczcHFZVkpVbUs1eVRn?=
 =?utf-8?B?bHRNaElZcUFienI3MFVKMERlTDVYbFBaM0V5UCtkZ3BxYUpWVyttYWswVURm?=
 =?utf-8?Q?OTLwNtzGNUNxudkYEU4tk/oE9?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f23ec598-a7d8-4b7f-058c-08dd30446fe6
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2025 00:27:45.1501
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3d8t+UDOcTWBVCfaCVx+T+CY2gsFV4qwy/bj1P+GCMH8sKhrk7T1Atz7cbWxOzuZQc5+lEancEUPtyxtkyarXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4269



On 1/8/2025 11:22 AM, Tom Lendacky wrote:
> On 1/7/25 12:34, Kalra, Ashish wrote:
>> On 1/7/2025 10:42 AM, Tom Lendacky wrote:
>>> On 1/3/25 14:01, Ashish Kalra wrote:
>>>> From: Ashish Kalra <ashish.kalra@amd.com>
>>>>
>>>> Remove platform initialization of SEV/SNP from PSP driver probe time and
>>>
>>> Actually, you're not removing it, yet...
>>>
>>>> move it to KVM module load time so that KVM can do SEV/SNP platform
>>>> initialization explicitly if it actually wants to use SEV/SNP
>>>> functionality.
>>>>
>>>> With this patch, KVM will explicitly call into the PSP driver at load time
>>>> to initialize SEV/SNP by default but this behavior can be altered with KVM
>>>> module parameters to not do SEV/SNP platform initialization at module load
>>>> time if required. Additionally SEV/SNP platform shutdown is invoked during
>>>> KVM module unload time.
>>>>
>>>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>>>> ---
>>>>  arch/x86/kvm/svm/sev.c | 15 ++++++++++++++-
>>>>  1 file changed, 14 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>>>> index 943bd074a5d3..0dc8294582c6 100644
>>>> --- a/arch/x86/kvm/svm/sev.c
>>>> +++ b/arch/x86/kvm/svm/sev.c
>>>> @@ -444,7 +444,6 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
>>>>  	if (ret)
>>>>  		goto e_no_asid;
>>>>  
>>>> -	init_args.probe = false;
>>>>  	ret = sev_platform_init(&init_args);
>>>>  	if (ret)
>>>>  		goto e_free;
>>>> @@ -2953,6 +2952,7 @@ void __init sev_set_cpu_caps(void)
>>>>  void __init sev_hardware_setup(void)
>>>>  {
>>>>  	unsigned int eax, ebx, ecx, edx, sev_asid_count, sev_es_asid_count;
>>>> +	struct sev_platform_init_args init_args = {0};
>>>
>>> Will this cause issues if KVM is built-in and INIT_EX is being used
>>> (init_ex_path ccp parameter)? The probe parameter is used for
>>> initialization done before the filesystem is available.
>>>
>>
>> Yes, this will cause issues if KVM is builtin and INIT_EX is being used,
>> but my question is how will INIT_EX be used when we move SEV INIT
>> to KVM ?
>>
>> If we continue to use the probe field here and also continue to support
>> psp_init_on_probe module parameter for CCP, how will SEV INIT_EX be
>> invoked ? 
>>
>> How is SEV INIT_EX invoked in PSP driver currently if psp_init_on_probe
>> parameter is set to false ?
>>
>> The KVM path to invoke sev_platform_init() when a SEV VM is being launched 
>> cannot be used because QEMU checks for SEV to be initialized before
>> invoking this code path to launch the guest.
> 
> Qemu only requires that for an SEV-ES guest. I was able to use the
> init_ex_path=/root/... and psp_init_on_probe=0 to successfully delay SEV
> INIT_EX and launch an SEV guest.
> 

Thanks Tom, i will make sure that we continue to support both the probe
field and psp_init_on_probe module parameter for CCP modules as part of v4.

>>
>>> Thanks,
>>> Tom
>>>
>>>>  	bool sev_snp_supported = false;
>>>>  	bool sev_es_supported = false;
>>>>  	bool sev_supported = false;
>>>> @@ -3069,6 +3069,16 @@ void __init sev_hardware_setup(void)
>>>>  	sev_supported_vmsa_features = 0;
>>>>  	if (sev_es_debug_swap_enabled)
>>>>  		sev_supported_vmsa_features |= SVM_SEV_FEAT_DEBUG_SWAP;
>>>> +
>>>> +	if (!sev_enabled)
>>>> +		return;
>>>> +
>>>> +	/*
>>>> +	 * NOTE: Always do SNP INIT regardless of sev_snp_supported
>>>> +	 * as SNP INIT has to be done to launch legacy SEV/SEV-ES
>>>> +	 * VMs in case SNP is enabled system-wide.
>>>> +	 */
>>>> +	sev_platform_init(&init_args);
>>>>  }
>>>>  
>>>>  void sev_hardware_unsetup(void)
>>>> @@ -3084,6 +3094,9 @@ void sev_hardware_unsetup(void)
>>>>  
>>>>  	misc_cg_set_capacity(MISC_CG_RES_SEV, 0);
>>>>  	misc_cg_set_capacity(MISC_CG_RES_SEV_ES, 0);
>>>> +
>>>> +	/* Do SEV and SNP Shutdown */
>>>> +	sev_platform_shutdown();
>>>>  }
>>>>  
>>>>  int sev_cpu_init(struct svm_cpu_data *sd)
>>


