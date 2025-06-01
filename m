Return-Path: <kvm+bounces-48144-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 233E7AC9E2A
	for <lists+kvm@lfdr.de>; Sun,  1 Jun 2025 11:20:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 188D11897099
	for <lists+kvm@lfdr.de>; Sun,  1 Jun 2025 09:20:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA4481A0B08;
	Sun,  1 Jun 2025 09:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="nOhy3iEo"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2053.outbound.protection.outlook.com [40.107.237.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D485482EF
	for <kvm@vger.kernel.org>; Sun,  1 Jun 2025 09:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748769611; cv=fail; b=lAT4ID6JjA5KEhO1m0xX5BUkz8nwKzrKGoDYhLz0P1HcMITlwfhabua3uA5AallP9k+ikelugUxcbNf/Wz4OZ/dCaw2e8Ey0Zg/KwnW80+LgJKYn07BCiUjiRpujuC1KbQYAvBMgAUEtpp5hEnIAhIRTq0q+RSJRqOTedyvn48o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748769611; c=relaxed/simple;
	bh=27z5/YgLKxk1uLy6vWl43pLWHhe20Tmy921gkgFHguM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=o/5pTx9RmM4J9iziknRmN5vTTznuD9Vy0skoJ0/Q8mQMor3rJobd3gJJeORQMc4GICAfYX4hnxqIoY9UxM8lCE4pOJ0IQCgRlTSKjGjtzHJ0Kbi6sr1cXagrReL8iC8m+lBgYIzdAg827xX2iPMSmhYeMiYEIjYnoYt5Ke8UqIM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=nOhy3iEo; arc=fail smtp.client-ip=40.107.237.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ayTk8P0zql6rhpsomJlkGi5Bh6acqSUuKisHEFH6BI9rt+EDU9uSnaUcTvl1U6JeMai9DBdDt3ovgFmE3Nve58cK7VNKazjTlrOhNdLzsP/psJEbJprlvdYXUGn5f5qZwwe3wwwHzmVFzOlAvsdPlEAzno+GTFhUOTSbxKwFnbBab2dVsZ1L14h1jbBeYHLDWa3TRq1JdlRiRoeiNYbgs+l9h7Ed5JcRskfhSAsNGd0P41WoQbzNb6qQilZrOVs4MWOHen6IDR6GxWjCpoloj55AXiJbSX0O1M5wRUCBWnyxM35TCcshIzdsXgy4NyTGKC3f1TCnGrdTcWgJua47Lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RpSLYJP3sFxLji2PRYM0nLG4x8cyDV9xuqBJdQNsdMw=;
 b=DoUYypE0UfV0A60wSFSdznedshEXBmAX3ermJ8o4MUeaVm31KZYwPcwO3/o6JG5qyA++6Q4hB83RDdAHNx7V0lSRdPwBc+4ypOAYUD0uQJLsjRzqgY2tPktjfeZXLtMIXaFb90nhqsaObayCyQHXqvJqKEE5WVfW5V3z4Nqib5CIbnoj/tx+a08z4Rl8XMcCImWE0BMobIzSlE6i0zE+SY3WPWuSJ2AdIBcSh7sM5vd1I2r0BgC/FbHlqXGUL4SAWjcAyblGdGMdgPPFi1ZDnQd2R5TmgcP/Pk8LNVObzNgAdJjQl8hK+YhLyNLSQN6DD6Hp4kca2CmQo+D3gi9Bow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RpSLYJP3sFxLji2PRYM0nLG4x8cyDV9xuqBJdQNsdMw=;
 b=nOhy3iEoi+uH+AerxCj8yZhgNQNUt7cYCCDDkleCkaAP0oagHN7D1SYG8bMj0RYAtGv/cbNTJO/pn0LFV5ZMT1CiZmsTOz7ppVnMS7nB435V8EvkmoWu3sRf6mmWD1yLBkhxu4gnJMA1fTCUduD8uLCgt0EurPR8hSNNvmrNuio=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA1PR12MB8189.namprd12.prod.outlook.com (2603:10b6:208:3f0::13)
 by IA1PR12MB6435.namprd12.prod.outlook.com (2603:10b6:208:3ad::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.33; Sun, 1 Jun
 2025 09:20:03 +0000
Received: from IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::193b:bbfd:9894:dc48]) by IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::193b:bbfd:9894:dc48%4]) with mapi id 15.20.8769.031; Sun, 1 Jun 2025
 09:20:02 +0000
Message-ID: <79ef3fe9-4b2c-41f8-8f17-9212bb1d899d@amd.com>
Date: Sun, 1 Jun 2025 11:19:57 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/5] memory: Export a helper to get intersection of a
 MemoryRegionSection with a given range
To: Chenyi Qiang <chenyi.qiang@intel.com>,
 David Hildenbrand <david@redhat.com>, Alexey Kardashevskiy <aik@amd.com>,
 Peter Xu <peterx@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Williams Dan J <dan.j.williams@intel.com>, Zhao Liu <zhao1.liu@intel.com>,
 Baolu Lu <baolu.lu@linux.intel.com>, Gao Chao <chao.gao@intel.com>,
 Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao <xiaoyao.li@intel.com>,
 =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@kaod.org>,
 Alex Williamson <alex.williamson@redhat.com>
References: <20250530083256.105186-1-chenyi.qiang@intel.com>
 <20250530083256.105186-2-chenyi.qiang@intel.com>
Content-Language: en-US
From: "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <20250530083256.105186-2-chenyi.qiang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PR3PR09CA0024.eurprd09.prod.outlook.com
 (2603:10a6:102:b7::29) To IA1PR12MB8189.namprd12.prod.outlook.com
 (2603:10b6:208:3f0::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR12MB8189:EE_|IA1PR12MB6435:EE_
X-MS-Office365-Filtering-Correlation-Id: c09f3eff-a47d-47f9-2b62-08dda0ed7d2d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MERwR2ZaeVZIQXcxekFlcWFSUWRaMjk1NkxiUENNWVNLVnpKMTZOZi9VK2FB?=
 =?utf-8?B?SnJiZVlqNDJlRGZScmlnZ2R6Q2VBeldqTzVacU1xekllZ0tsYkdtdTVUZFBH?=
 =?utf-8?B?SFg0RHo2YWZLa0lpOG1FWU85Vk9KRHJFMWdlckJIQjQ3MkJpVklGdS9wLzVT?=
 =?utf-8?B?ME5yNWwrcG1pWWtmTXRTNks0NnRpNjBHOGxabnR1SG1uYXd4UzNqYnA1Y0RF?=
 =?utf-8?B?ejJ4UnY5U2huYnBuNGZhZ0dNSVo5R0hpK05pVVRQdDJkYnNrVmd0V3dCekw5?=
 =?utf-8?B?czFnTFo1dmlWNytCbFhZUFJkNnZ3RXBCV3BCQjRzQ3VJREk0SkRCelFBSnow?=
 =?utf-8?B?K0kweXRRMzRpbDdJSHBvVmhXRVpFRFFzUWEyYkpGNXZGeW9QY1c1Zi9QWVdV?=
 =?utf-8?B?Q3dhMHdmUzh1am16QVFaQzlZelZkQXdON05mZXNENnUvUWpIR21xOGVjNXdE?=
 =?utf-8?B?QTJKSFhKOEYrK2lOd0ZkM3hJWGJNZEtwUmowVzdjWmVIODhxZElyMUNmWjdV?=
 =?utf-8?B?eFd1RktlMkZ4M1pIbjl5ZzFXbVk4cHNHQ2VkMzFoc05kQjBkZnlHNnRiVlBH?=
 =?utf-8?B?c1N0SGlhZ1kvd3pvZkFZbXMyWk9iNCt4b2JEdW9sM1A0c0RqQW1ZV0I0dGlM?=
 =?utf-8?B?MGlhcXNEZk5aOCswTE5TTVhoMWtzL3pHcit3ZVNkZlJNZGFwcE9qakRQTDF6?=
 =?utf-8?B?RDEzQlNOWDkyWWZ0Q3JTMkQ3TGVQdTdmNUhzNThWYXA1YXl2TUQxTWVzQWJJ?=
 =?utf-8?B?bERjN1MySHBDc0dBVWNxb1ZQaXUwYzl4bWlianByMWd4YTJUSGtWeHp4TTN2?=
 =?utf-8?B?QzIzT0dNSzAvUHMyV1lsUXVWTDNLUXJlMEptRzgzTWdJMkpmUHd6ZnQ3cDA5?=
 =?utf-8?B?cm9MRDRkK0ZoV1FEUmNWZUszbEVONDlSUjJKbWVWa3hjWFp0Rk1hbEI2SzE4?=
 =?utf-8?B?UWdQbWJDNTlVY3NuN093WDBMb2w0REttY21UQUZKRmNBUW9YRUhiTnJBcGY0?=
 =?utf-8?B?L25sa2ZsT2pzaWNuWVMyUk83Y0NUd0IvdGIzU2luMWtJMjY4VzRGSnJkT0tV?=
 =?utf-8?B?VEVja21ZUU9ZWGxReVNrbFE1UVo4KzBIWkZMdnJJa0JXS3pXSkdlRUQrVEpl?=
 =?utf-8?B?dHltcFJVQk5naE5Odk83ZThJSlZaOTFGNVAwOFhSY0FMOHNERUhUQWpHRnN1?=
 =?utf-8?B?UTZNc1F5TzdwbnVyUDhCOVR2UnpVSTZJRHNSbjBjNmVCR1crL3RlVUowSjNs?=
 =?utf-8?B?UEF1MlB2eVNkU1ZGSVpiemxaY1BTa2FKMUYzNkgyaTJvMWphM2Q3SXVDaGVU?=
 =?utf-8?B?UFVPYVI5TVBCVllMcjQvM0FZa2ozeiswejVvYytiSElyQlV1TkxIK1hxL3hl?=
 =?utf-8?B?b3BJL0JnUkIxUDB1V0NvUVc1SDRQNG1LMmZhS09xTFRCMWtuWmswcFZ6VWVm?=
 =?utf-8?B?ZFBxWjVQQjduUEhUemRaNk81YXIwNk50RlBOdk9VeGpYRTQrcnNIWktpM29J?=
 =?utf-8?B?Sy9kZWZGeGdGUUZ1dFJxZUk1b2x3QndNK1ZnS0NiS2lsMGZkTm15N0FlYXBC?=
 =?utf-8?B?L3dkQUc0OXg5NW5qZkJIZEhnaHgveUcrQm54QVUrVG5CZjlacnpuQzg4QjJq?=
 =?utf-8?B?V3VocS9KaGFMR3FCLzhuOTBzNHpIdFV4UnJuTFVmVHFGQzFyM0UxRmhiZVc1?=
 =?utf-8?B?TUJDdm9FTWFOMlFFV1lPNk5Namt1ZDFYZU9OMzZ4QVBEa2swY21Jc29BclIv?=
 =?utf-8?B?Q1JkaXB4Z1ZEMTZLeTAyK3NrcjNkQTZ4bEhaR3QvQytVZytlMVB1dlltWTlM?=
 =?utf-8?B?bkFBTjNVa3hIeDZMMGVVV2VrZFdObDBBWjZCV1B5bkxja1owZDY3ZEVuQzVN?=
 =?utf-8?B?MFFZRWVuQTYrZDdwMXZBN2JmSjg4cXNrN0UyTDNEVzN2clpnS0dUYk1DMGFP?=
 =?utf-8?Q?kOXr8JYMRXs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB8189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TUgxbkdDZGgvNjhwZ3ZzTElEL1ltblhVRG9aK1l3S2JrdFdQdkhyUzRSYUpE?=
 =?utf-8?B?cFpYMEJrei9UZ3FkcGJPd0lreDlzMUVPYWZ3WVpiWFIxMjdUWU5vK1p4SENF?=
 =?utf-8?B?NHBFM1VZdGI4UENHclQyaGY3anpsUjc4Y0RNelhNMGdjcStMNWowYTQwVXRN?=
 =?utf-8?B?c3kwTThjV3VUWkRnRkYrU0ZhR1NkWXNCNVc1dDdGc2l5VGljWWlvbkdZNlhi?=
 =?utf-8?B?VWxGOXpUUFZMQ0dVYTFUeFdzNXY5Ty92THp0ZU1yc1BzSFplMjdhVjRaZTJ0?=
 =?utf-8?B?c0hBb2w1TnpVajlwLzNVdWNhMHBiYkc2YjloSUpFWVNQTlhHMTFGOG1xL2RX?=
 =?utf-8?B?cU9WNEtIa1ZiT2VPeVlPV01wZmF1eTdXdElXRW8zanZJbnZiR2pnMXpHSFhJ?=
 =?utf-8?B?NXR6Tm5wTFZORStZa1JuSUhkUk9tWCtHNWJEMWhUMXZHRHpUMFdEK0VPc0dH?=
 =?utf-8?B?Q3NqTHpKM09DUnFpalhXb2t1cjd5QnNQZjVqRy84K09WZ2g5Y0JkSXRSOEpa?=
 =?utf-8?B?bENBZy80NTd4Vkp1OTQxY0VSaDFoTitiTVFxQ1hUL3RXVlBtMlFxa2pKWjc2?=
 =?utf-8?B?V2tqSERZcFpGeVJLbkcvQTJ4YUVyUGpic3NSaWJMNGk0SEFuS1lKWUhUZHhj?=
 =?utf-8?B?YzZKRk95SkV1TGYxOFV2U1AzOW5HbHMwVkhkbmdhei95MnlCN2JEWEo2WlF2?=
 =?utf-8?B?TXdqVzBJOGtGY1dtUXlQNWtUaDlWUHNMS3E5alozYlN4VVRJY0MwVVBxV2Fz?=
 =?utf-8?B?dmJlVGltNEVhMlRqTUpyUlN1SjhaZWI4MGNLTHVFZDdacUNyM2lKbGNxZHJY?=
 =?utf-8?B?MkdLUm4wd2xYYUpEdVFkRkRpdng2OElIeE4xYWhSbFB2MGNSQmxqWVAzWnZq?=
 =?utf-8?B?eWxLb1NiU2xXd3hwR3VNRmdDeWRYalAvZnJ3UngzaU14bU5kbTlINVQ3SVdD?=
 =?utf-8?B?clZ5dEwvOUZKZ3oxVXBJMlovb1UwS0REZTg0NExjdUZncGU1Tm9lM3B4RnRL?=
 =?utf-8?B?K2lNM0hWV1pDVkVvMjFTZlk4YjhaY2lxQ25HM3Z1blJZeWdDWDQ4VDlJRWZt?=
 =?utf-8?B?VnFXY3V4RGRBV1h1cnU5Z24zUU0vcEcwaFpBTUNseXRQcU1mR2dMMGZPTWpz?=
 =?utf-8?B?VS9tby9KQVhtMkw3d2FCdnJreXlqcVgyVjZvYWNpOW1UMW9hWjBCSklzdDY4?=
 =?utf-8?B?SzErQWNRM0d2S21WRzVVcVJrV2tCRjRjTnFGNjU1STIzcnRIalVOdFFDYStI?=
 =?utf-8?B?K2Z3WXBqL3NCdk5rVU9YczRpREdWSUVzVU9LclNvb0JHTUsyaWZsVjg1SUFy?=
 =?utf-8?B?YkFqRlF3MUVoVVNDUTJKT3EydG4wMVM1aysvZ1g1SHc5SU5jN2txc1dSTFVG?=
 =?utf-8?B?a3pmUzRZdmxsMDlDT2RwU3I3eXNoVjRrZHVyOEZDMit1YkpSZWpFTERPTHBm?=
 =?utf-8?B?UnBlWUtFT2xJMDdzVzc5UTk5eTBFcmtKbWpwWElmMmE5aDhSUzBaS0ZmTDhN?=
 =?utf-8?B?Zm9uUkhka05aMTlGTlN0d3QrSHRUN0NiMHVTT0hON0pxZmN4Y1Irc2JhV1g4?=
 =?utf-8?B?aVdoVWFiU09VN2NkMTIvVEE5eHV4dmIxZ2QxeG1ZRzlnZi9vVnNHTDNzbkZm?=
 =?utf-8?B?aUgyOWRoQ0JHOW9RMHZJQ3laZHJXdFUrS05sUlBsa1h6OWtyU0Y0a0JHRHdw?=
 =?utf-8?B?R24yUXRiQTRrZnVTN25NeW4xd2xnS3JoMlIxZWNLQTFFZHI1NVgrc1pCRDRV?=
 =?utf-8?B?c3N5S0RRSnJRZzJUY3VzVk1mYXY3ZjFGaXd6T3BpVDNiVDc1K1k0TXdJdmRF?=
 =?utf-8?B?Z2N1ZFBDOTY0NU5KWDdIUHBvRS9FYTZvOXJsNnBvZzhPVTB1UmNNM1BJdFN4?=
 =?utf-8?B?ZVVvYnAxcnZRbXppYStkOWIzRERJeVB2QnpwY3UyNVphTXJnZGdVT08wWGpP?=
 =?utf-8?B?MTNsYlZCODA1YlNGM1FjVUNTY0NJNkpaZ1JoU256b0cwM0JPZ2R0NHVkTzd0?=
 =?utf-8?B?VCt2VGVpa1pVRXdFNkRFdDl6WXJtMFpoR09UeUdyWUlyOUVRaXVSU0xIcGJu?=
 =?utf-8?B?bkRuOUpSS2ZSWlYrMnR3dm9HUnJ4UjVYb2hpamlmYTRGb1FNc0Mxd0F1OVJB?=
 =?utf-8?Q?pNL3VCJfFONSe0jzZ8mOBoouw?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c09f3eff-a47d-47f9-2b62-08dda0ed7d2d
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB8189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2025 09:20:02.8014
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N12hktnSlLQonhB4klU0EEqOjnl4ZbKhZlD/LhS2HdjnQmPXOlnDdvaAzo9Jck4Uf05AHNwAKIe8e7B0GbnpaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6435


> Rename the helper to memory_region_section_intersect_range() to make it
> more generic. Meanwhile, define the @end as Int128 and replace the
> related operations with Int128_* format since the helper is exported as
> a wider API.
> 
> Suggested-by: Alexey Kardashevskiy <aik@amd.com>
> Reviewed-by: Alexey Kardashevskiy <aik@amd.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>

Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>

> ---
> Changes in v6:
>      - No change.
> 
> Changes in v5:
>      - Indent change for int128 ops to avoid the line over 80
>      - Add two Review-by from Alexey and Zhao
> 
> Changes in v4:
>      - No change.
> ---
>   hw/virtio/virtio-mem.c  | 32 +++++---------------------------
>   include/system/memory.h | 30 ++++++++++++++++++++++++++++++
>   2 files changed, 35 insertions(+), 27 deletions(-)
> 
> diff --git a/hw/virtio/virtio-mem.c b/hw/virtio/virtio-mem.c
> index a3d1a676e7..b3c126ea1e 100644
> --- a/hw/virtio/virtio-mem.c
> +++ b/hw/virtio/virtio-mem.c
> @@ -244,28 +244,6 @@ static int virtio_mem_for_each_plugged_range(VirtIOMEM *vmem, void *arg,
>       return ret;
>   }
>   
> -/*
> - * Adjust the memory section to cover the intersection with the given range.
> - *
> - * Returns false if the intersection is empty, otherwise returns true.
> - */
> -static bool virtio_mem_intersect_memory_section(MemoryRegionSection *s,
> -                                                uint64_t offset, uint64_t size)
> -{
> -    uint64_t start = MAX(s->offset_within_region, offset);
> -    uint64_t end = MIN(s->offset_within_region + int128_get64(s->size),
> -                       offset + size);
> -
> -    if (end <= start) {
> -        return false;
> -    }
> -
> -    s->offset_within_address_space += start - s->offset_within_region;
> -    s->offset_within_region = start;
> -    s->size = int128_make64(end - start);
> -    return true;
> -}
> -
>   typedef int (*virtio_mem_section_cb)(MemoryRegionSection *s, void *arg);
>   
>   static int virtio_mem_for_each_plugged_section(const VirtIOMEM *vmem,
> @@ -287,7 +265,7 @@ static int virtio_mem_for_each_plugged_section(const VirtIOMEM *vmem,
>                                         first_bit + 1) - 1;
>           size = (last_bit - first_bit + 1) * vmem->block_size;
>   
> -        if (!virtio_mem_intersect_memory_section(&tmp, offset, size)) {
> +        if (!memory_region_section_intersect_range(&tmp, offset, size)) {
>               break;
>           }
>           ret = cb(&tmp, arg);
> @@ -319,7 +297,7 @@ static int virtio_mem_for_each_unplugged_section(const VirtIOMEM *vmem,
>                                    first_bit + 1) - 1;
>           size = (last_bit - first_bit + 1) * vmem->block_size;
>   
> -        if (!virtio_mem_intersect_memory_section(&tmp, offset, size)) {
> +        if (!memory_region_section_intersect_range(&tmp, offset, size)) {
>               break;
>           }
>           ret = cb(&tmp, arg);
> @@ -355,7 +333,7 @@ static void virtio_mem_notify_unplug(VirtIOMEM *vmem, uint64_t offset,
>       QLIST_FOREACH(rdl, &vmem->rdl_list, next) {
>           MemoryRegionSection tmp = *rdl->section;
>   
> -        if (!virtio_mem_intersect_memory_section(&tmp, offset, size)) {
> +        if (!memory_region_section_intersect_range(&tmp, offset, size)) {
>               continue;
>           }
>           rdl->notify_discard(rdl, &tmp);
> @@ -371,7 +349,7 @@ static int virtio_mem_notify_plug(VirtIOMEM *vmem, uint64_t offset,
>       QLIST_FOREACH(rdl, &vmem->rdl_list, next) {
>           MemoryRegionSection tmp = *rdl->section;
>   
> -        if (!virtio_mem_intersect_memory_section(&tmp, offset, size)) {
> +        if (!memory_region_section_intersect_range(&tmp, offset, size)) {
>               continue;
>           }
>           ret = rdl->notify_populate(rdl, &tmp);
> @@ -388,7 +366,7 @@ static int virtio_mem_notify_plug(VirtIOMEM *vmem, uint64_t offset,
>               if (rdl2 == rdl) {
>                   break;
>               }
> -            if (!virtio_mem_intersect_memory_section(&tmp, offset, size)) {
> +            if (!memory_region_section_intersect_range(&tmp, offset, size)) {
>                   continue;
>               }
>               rdl2->notify_discard(rdl2, &tmp);
> diff --git a/include/system/memory.h b/include/system/memory.h
> index fbbf4cf911..b961c4076a 100644
> --- a/include/system/memory.h
> +++ b/include/system/memory.h
> @@ -1211,6 +1211,36 @@ MemoryRegionSection *memory_region_section_new_copy(MemoryRegionSection *s);
>    */
>   void memory_region_section_free_copy(MemoryRegionSection *s);
>   
> +/**
> + * memory_region_section_intersect_range: Adjust the memory section to cover
> + * the intersection with the given range.
> + *
> + * @s: the #MemoryRegionSection to be adjusted
> + * @offset: the offset of the given range in the memory region
> + * @size: the size of the given range
> + *
> + * Returns false if the intersection is empty, otherwise returns true.
> + */
> +static inline bool memory_region_section_intersect_range(MemoryRegionSection *s,
> +                                                         uint64_t offset,
> +                                                         uint64_t size)
> +{
> +    uint64_t start = MAX(s->offset_within_region, offset);
> +    Int128 end = int128_min(int128_add(int128_make64(s->offset_within_region),
> +                                       s->size),
> +                            int128_add(int128_make64(offset),
> +                                       int128_make64(size)));
> +
> +    if (int128_le(end, int128_make64(start))) {
> +        return false;
> +    }
> +
> +    s->offset_within_address_space += start - s->offset_within_region;
> +    s->offset_within_region = start;
> +    s->size = int128_sub(end, int128_make64(start));
> +    return true;
> +}
> +
>   /**
>    * memory_region_init: Initialize a memory region
>    *


