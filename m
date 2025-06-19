Return-Path: <kvm+bounces-49954-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 42D1CAE0162
	for <lists+kvm@lfdr.de>; Thu, 19 Jun 2025 11:11:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D4FDF16984F
	for <lists+kvm@lfdr.de>; Thu, 19 Jun 2025 09:11:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 170281FC0EA;
	Thu, 19 Jun 2025 09:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="2/EGQG0Y"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2055.outbound.protection.outlook.com [40.107.223.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61C46229B02;
	Thu, 19 Jun 2025 09:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750324304; cv=fail; b=V+UonXwcom7X1HLDcLVfsdCDEGTzL42mONIf0ctklZI28bLgAwJqHPKekYe69fGVLNsBUhnm1G7zmsU+xf6EdBOkehxBzVmWBCC2vpksRU1gYyq95N3yyl+n4WlJGEU3Y6ehzeLY79+aQbDkdj7AL8nym/IoDRM3P1w/Bpg0DYM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750324304; c=relaxed/simple;
	bh=IcPoHczvRU2dT7cxiPKPmX6X+zzu7j9aL13f0GpYYUg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=LWELoFEFl5fY51X9wxsdnL7j1fzIBlfEW/PCk9g7JIKsVU9gT03Fdzjc3eVDlovXp1qXZJVPBwHOWKz/c4w4ZLEMJETGE7wQYAZqsla6ie4BipXEwZAxGEgbiuixGKo1kWw3lzS2NPmx5xGUHPo14oetA/cpt1UwGNuEzaUD5q0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=2/EGQG0Y; arc=fail smtp.client-ip=40.107.223.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T7k/RT/NHNWWqTXMtdwVkgPoefINsEVaYFObvMGvxGhwwWhwaIfU2xF305nJXy7qn98mHClASypJqX3jwMf0ckYaEX9/dj2htvxuUGzimNpEYlpsa+7K2U3VauL71uJTD206GInUkqLWFeSjK26oHDBAdc63SAAFDb5WslHTkVkSnLLjhTkVkJDJLOpHT/LlX5f8lfTTUzQdjCJ9XVJcKo3C45iqkPqbEDeIh9GbfD5aV9xLszoA0brRfJqak+xSYTVRbbdxPpyLnguzlPh+VbTFOsZ8CQ9jTClLXpd/0jFmUgYlKCxJpUoqIEnDU/TeqRPxBb1Lk3AuPkv9h8310Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pFwiNsRQBdOCUUdUQn1qGK+GHhqWrXiOW4hA3E/gX6U=;
 b=T5huniKssq15eEYm4QGgcPZJVlNywyFjio1bxQ2cEYAVhTeONyoXj9lmPUTEI7EeNaWMlOEL/Q5D6jXYP9TdxYUteH1xv5CcCO4Jod3U/Tavf9stRooGsoswIIs1aoqdt6NWisZKb2KJv3sN/zS4AhqX3JHTX9fEYzRe3Fycfq2B2Nq73CKBSSd648DB3zbIm1HiEI4z1x8TAk9H4zVuTSMUHjSLj5bTziGDcm5gou9kvqP6j96O70Hee5GVgXmqhhbIFuhyPRlTf07ysCGhELEMvNZ2BD2dQ58sYZqTg9ZYq7w26kOkZwpjMbf81KW8H3aMMk8FwWJsZ5f3in090Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pFwiNsRQBdOCUUdUQn1qGK+GHhqWrXiOW4hA3E/gX6U=;
 b=2/EGQG0Yg7YAwTIs2SzVRtc9vKi/umOgDE/MiT0TGPxZN9xRRaxLceGGryXH+LGKvhEgadYeuBHQhpXuU1af2qjtdCtX6yXI8wiVj7XBcUVzByRv/QkTDAo90pnMeY/NJWWgRSg6cdoAK+mGrEbbWOTa7N6IpD/gSaR3U9Zfg1I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by MN2PR12MB4253.namprd12.prod.outlook.com (2603:10b6:208:1de::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.28; Thu, 19 Jun
 2025 09:11:39 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::1e6b:ca8b:7715:6fee]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::1e6b:ca8b:7715:6fee%7]) with mapi id 15.20.8857.019; Thu, 19 Jun 2025
 09:11:39 +0000
Message-ID: <a2dfd120-2305-4793-9b9f-c978ee692ecb@amd.com>
Date: Thu, 19 Jun 2025 19:11:32 +1000
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH v2] PCI: Explicitly put devices into D0 when initializing
 - Bug report
To: Mario Limonciello <superm1@kernel.org>,
 "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>,
 Alex Williamson <alex.williamson@redhat.com>
Cc: bhelgaas@google.com, mario.limonciello@amd.com,
 rafael.j.wysocki@intel.com, huang.ying.caritas@gmail.com,
 stern@rowland.harvard.edu, linux-pci@vger.kernel.org,
 mike.ximing.chen@intel.com, ahsan.atta@intel.com,
 suman.kumar.chakraborty@intel.com, kvm@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <aEl8J3kv6HAcAkUp@gcabiddu-mobl.ger.corp.intel.com>
 <56d0e247-8095-4793-a5a9-0b5cf2565b88@kernel.org>
 <20250611100002.1e14381a.alex.williamson@redhat.com>
 <aEmrJSqhApz/sRe8@gcabiddu-mobl.ger.corp.intel.com>
 <e4047149-ddfe-4b70-991c-81beb18f8291@kernel.org>
Content-Language: en-US
From: Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <e4047149-ddfe-4b70-991c-81beb18f8291@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SYCP282CA0010.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:80::22) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|MN2PR12MB4253:EE_
X-MS-Office365-Filtering-Correlation-Id: 46b4c85d-8f1b-4b8b-a797-08ddaf114c90
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?U1A5UEdSVWUrQWE5ZzZoTS9OdDMzaDdGbjE3clVEaGRSY2N6d2Zac2FQQitu?=
 =?utf-8?B?dGVMQ0cwTFhWS3AvWTRjaENnakJ1eDcwdzhqM0lvSkhlemNIYTNTdlZtSVc1?=
 =?utf-8?B?elFhMTFnR3oyd250RlROM0JMUnNKWm5SRFluSnhBS1dBVTl0ZGZHbjN4NWYz?=
 =?utf-8?B?emhXamJQYW5BeXZqdW9wY0cxL1hkVU1yekwzdmNOQ21Nazl1UXZyVkN5dUJo?=
 =?utf-8?B?UFd2MVRoRGhZQ0FZR3R5dDJkRzFSWXg5Zk9nazBoVDlBemJPZkVrcFhMWGQx?=
 =?utf-8?B?eVFWN0dzb1AySEpHdWpFUGtKSVJZelBTSGR2OEo5RFJ6cHR6cmdvQU0wN0ZO?=
 =?utf-8?B?cHNnaDhrMVp1ZUtGN1Z0M2tPTTNaTWJKazVSUVhCRG92cXh4aHFGU3JXT2JB?=
 =?utf-8?B?aWFQbG14cHNiOEZwNlJNUmlpUFhEdlBGZ0hTSitYYWNyMXFDS1I4ZkM3R3Qy?=
 =?utf-8?B?MkpZaDlxbGhQdG9WZkptRm9SZXR2MFBhNFhuQ05FM1NLSDdNUStHQTh0RkQr?=
 =?utf-8?B?cWZNMDQrVFltNTh6TU5Kb0tINkp4RFdkbkg4MkU0MGtyK0VySEZFb2tDbEM3?=
 =?utf-8?B?VGpwbTE2dFpWckV2ZmNhV1dEc3ZObmdzS1BuN1c5aWlkOHAxMVZDOFdRRG90?=
 =?utf-8?B?R2RCdktlakg4a291RGJyZjBQTjNUbmxIeDZSRnYwOXFVajRZZzNhNVFWVklW?=
 =?utf-8?B?bUtBMEx0MnNxREpJMm9yNzJ2dDNNbGtTbXdwOWRkTU51cWV3ZW1qOThhZzFO?=
 =?utf-8?B?dE9Vc1RqRWNESklVYjRBTjA4TWt4WjFUZ29SWnJxbVEwY0k3aGFYZXlVdVlL?=
 =?utf-8?B?b3piamNHVytuM3hwRTJmWFBqbmYrSzNuZ20xcnArbVR0WmVkWXJVbWhNaWlm?=
 =?utf-8?B?S1p5Rk1aZ05NK21ScW0vdUhidldyeGNkMHF5UkpMVFFoZjFyOHN3WVljZG9s?=
 =?utf-8?B?TlYvZTg4RXZVNFF2K0pScEZWMTI3OWZiQTdMcEZ4cjE4SmF4ZUtIeEswbncv?=
 =?utf-8?B?NHZWNEIyRDV5RjFZSUJadzNabUNIQlM2cFNBeTRKOWhCTlhBU2tDZ2c0NFBa?=
 =?utf-8?B?d1NNRXJEaGE4eHdrWXoxbGNqaFNZekk2QzFldzdLem1jR0tHSFJpaFpHbVpy?=
 =?utf-8?B?bmhId1I2RUR2OFRKK25GdmdrSExJclZCUHJSNXA2QlJKbXp0SU5yb1p4bG9h?=
 =?utf-8?B?U3ovMkRWbnl0eXI2TDFyRTN1K3c3NENTSEFSS1VucjdtL2txbm8wbjFicnpV?=
 =?utf-8?B?Z1h5KzZ1cmJsb0Rzb2tEa1JHNFVxWlNoYnlHYnM2YjhKT3h4WGlMU3V3aHFx?=
 =?utf-8?B?MzdYdkhZNGdXY2t4WUd2YWUzYWZSUzhLT29yT3M4OUFlTENTOUJRVkxOaTVp?=
 =?utf-8?B?Nk0xR2I2QWV4QUZ5TWdFRXFVTXZRd1I5V2w0Unl5Z0tTeXdWNnZHa29nOUkv?=
 =?utf-8?B?K3NwWXJNNjhydVEwUDBleDBIc0NuNXpvS1NHRTVFd1hLSE5vZnpLS2VHUnNR?=
 =?utf-8?B?OGZPUCtXUThGZ1JEVjhRemZCMmU1cUZQY1pqcGkxdzV2WjdUeVBTaEwwbHI3?=
 =?utf-8?B?WWF1eHZRbm1oYnpBK0xQWER3UzhqeVo0WnNoR3RFOUpTYUk2cFh2bFpPSFVk?=
 =?utf-8?B?eE9wU2krZnJXMm5TQjFmM1NzVXRKQ0VUOGFJTVJmVHBQUWJZSW1qdkhkSXV6?=
 =?utf-8?B?bXczc1Npb3F2c2p3NlJFY2p6U3BaaVZvcG1kQVNXZldVWGNzSGxYMUN2SkE2?=
 =?utf-8?B?Q292aFNzZUpQS1pCUk9xc05JZXFSZzBoQ0RsQWRHR2VvdVEzNXllbjRkdHdS?=
 =?utf-8?B?bEsvNGlFVW0wL055SWFDeVczSHFwdjNlamtscTVxRXFrTEJrcUtTZlF1UVNX?=
 =?utf-8?B?bHh4TllxMlFDeTBVK3NQa1NCTHZjbFk0UG5mV080c0JIa3pYMFJTTWF0MzlJ?=
 =?utf-8?Q?iB6VAh+QHRU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TGo0MURzUi9ENnNJVFZ1b1hNRi9kcmlNWkJ5NW5QMTQ3V1IyRVQxeWFkMmZY?=
 =?utf-8?B?b3k1WmVUVHZGcHlIZWJjMkJ5dm04ZlhsOEsvaEM0bnQwNG5qOUZOQ0FaT3pF?=
 =?utf-8?B?MERIeFpWaFI4K09neDgxb09GbHM0NEdLbERJRk5ZVHppMGoxS3B0RUMvQ1A0?=
 =?utf-8?B?bzZKYUZ6SHRORHVYYzBJQnNJeW56VTNPRU5VZ1BPNDkzUDR6eFp2V3paTGk0?=
 =?utf-8?B?UW1ESEpRMzZCZTNOVlJNYkVZU3RpNUdtUGZlK1owcUZVUk1wWjYxRXVaUElE?=
 =?utf-8?B?emt2SnVnSFU0MzJ3U1kzWGxYQUpCcGZ2cFFJVE9zd3EyVVpGU0dmcnhKUDVC?=
 =?utf-8?B?Zi9pSTdRM01qY1I5VzdhbFdoak9oa0lVK2ZNR1lEOU1WNTJMRkp3OXNjRnUv?=
 =?utf-8?B?YzNUQzlsd0pVMGxRTzFpMC8rclhXdzNvcmV4RUdOSUd5TWxNb2dpRlVXZkhs?=
 =?utf-8?B?ZTI5V3UyL0M3cFEwclRxc3I2TGZjNEFDTlh0Rnc2cmk2SFJRRnd1MC95QjEz?=
 =?utf-8?B?bURxMXF2YjJNd3pvYUsxanRKRko5VnR0Z0Q5Z01uZ3dMamlyMU5mWmZsSHhr?=
 =?utf-8?B?Y0FDcDVnQmJOTGRUc0h3Y2NraE0yVjR6UnFmYUM3UmpNbS94Y1puc1dFV2o4?=
 =?utf-8?B?dEZnYVZyanc2TjZpQ05MK25kUHlnWmNYdnJlaFlpUE5TWGt1M2oxWEZod3Jx?=
 =?utf-8?B?cXpFTWwxVm82aWhERU1VTmZNVWI4aVJnVlJZa3dvWXZidml2TEY3UG8yVERJ?=
 =?utf-8?B?MkpuZDgxem9WM2kzUG9YSUJQcDZKbTh2S09iNGNLL0ZHUkVyTXRycXQxZTcz?=
 =?utf-8?B?eW5hSVUyb3V1MlZORDNobXkwZk80WGs5RmM3ZDZKMWhtaGhNdjN4L1luV1JZ?=
 =?utf-8?B?WThucS8vaVFKN1NmZzI0dTFnMEl4Um5RMVdTZlZ3d1dyL2JUcXJVUVljUDdP?=
 =?utf-8?B?aHk5bjZQa1R2eFZseHNHR2U1VUU2RFY5YzZoaVlqOEZwOWdqeEZCWHVyTy9m?=
 =?utf-8?B?Z1FHWkZLOUhRZUxCeGZ3ZmY2SWxDYmUwSVhZQm15Qm9SZXFIRU1kMjhLeUo0?=
 =?utf-8?B?UnlRK0pWNzNaWkswaVdPN1lJNUpkOFA3MEcxcm8rK09ERXFWNTF6M0xFYUxh?=
 =?utf-8?B?Zko4aHlkcys5UDZZTXJJQWYzNlZRay81OUdpT1ZuL2c4WjVzOUhsUHMyenlm?=
 =?utf-8?B?UlBCSndDUUhkZ1lWTXFYeW1CeVlTZWRmSGpVSjBEODZoVmhkZkpmMFFlODQ2?=
 =?utf-8?B?M0gxUG9uQUNLdGdITWl5WVkrTFJPdjlzVGhtY2FZM0t0QW42a1dSVUxCM0lB?=
 =?utf-8?B?L0lERXd1ZUluNVJHcWxGTExyL1BSL2czdzM1QnAzU0RudExSRHZRL2djbEFW?=
 =?utf-8?B?dmFJa0o2S2JBTnYwT0pid3B2MFNLdjZteS9sb0JWc1BCajVqelFQMHNXeEo3?=
 =?utf-8?B?NUpYYjYwQ2FvekFtbkpMVFd2aldnN3dlenFISUNTRWtGZE1VNzM0MlNORk1L?=
 =?utf-8?B?bk4rUlVoY3JiSVRlQ2ordktyemNIeW96dTQ1WXNMbkJ0bTc4QzZiNUtWQzgr?=
 =?utf-8?B?YVBuSkI4a1MwUlR5MTlkclJsSExMTGpYbk5OS21HM3MveWhyYVNCWVB5UVlH?=
 =?utf-8?B?a1ZxWXI0V3luWjNCU1FhNHRKdXRHOENuMzdrSFBvVlJLRk84RHM3b2FkWEI3?=
 =?utf-8?B?SnM3STlzaklPSUlSNXVLbGRDNnpCTzdEU1hOcU1scjlnbmExVEIwY09yMmJi?=
 =?utf-8?B?RUZGeUxqZHB4c2JoMCt5R3JzakJia3FvbUZkRzE0NlQ2d3FUOFNHa2VDMFU4?=
 =?utf-8?B?WStLOUlOK3N2MG1LN2F2NERURDQ2S3l6Vmtkem9yK2tRZWNHYWVFdStPVDI4?=
 =?utf-8?B?eXUzekQwTGl0Q0hKVmpqVHp6UnBOVWhaL2c3RVpMUGhoVjdEZUhOdWhac201?=
 =?utf-8?B?ZXowZ2FTdVd5NEptL3lLTDdtUGFMYnI5SnZJZHVqV0c3Y1ZMcWM4VVpxdWVV?=
 =?utf-8?B?UStBOVJGcWVxS2VGR2NNVzBzaXllRGg0dkkvOW5HTUthckpCTzh1aHYxa2J5?=
 =?utf-8?B?WFpOTlFWYldPK20wMGc1b2d0TjdncHcvR0xwSWtrbmJadjhLdkt2VkpYanBa?=
 =?utf-8?Q?tDd8XHc2L2RG3BR0SzHAh58N0?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46b4c85d-8f1b-4b8b-a797-08ddaf114c90
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2025 09:11:39.2547
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: StOrt/WfqKvTsywFZM3h5CPvWtbpLHmhvhUsR+aQ045nd709bxmgWvMNON7BDgD4pMjrtvpAf+QQG+5FVLx7iQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4253

On 12/6/25 06:45, Mario Limonciello wrote:
> On 6/11/2025 9:13 AM, Cabiddu, Giovanni wrote:
>> On Wed, Jun 11, 2025 at 10:00:02AM -0600, Alex Williamson wrote:
>>> On Wed, 11 Jun 2025 06:50:59 -0700
>>> Mario Limonciello <superm1@kernel.org> wrote:
>>>
>>>> On 6/11/2025 5:52 AM, Cabiddu, Giovanni wrote:
>>>>> Hi Mario, Bjorn and Alex,
>>>>>
>>>>> On Wed, Apr 23, 2025 at 11:31:32PM -0500, Mario Limonciello wrote:
>>>>>> From: Mario Limonciello <mario.limonciello@amd.com>
>>>>>>
>>>>>> AMD BIOS team has root caused an issue that NVME storage failed to come
>>>>>> back from suspend to a lack of a call to _REG when NVME device was probed.
>>>>>>
>>>>>> commit 112a7f9c8edbf ("PCI/ACPI: Call _REG when transitioning D-states")
>>>>>> added support for calling _REG when transitioning D-states, but this only
>>>>>> works if the device actually "transitions" D-states.
>>>>>>
>>>>>> commit 967577b062417 ("PCI/PM: Keep runtime PM enabled for unbound PCI
>>>>>> devices") added support for runtime PM on PCI devices, but never actually
>>>>>> 'explicitly' sets the device to D0.
>>>>>>
>>>>>> To make sure that devices are in D0 and that platform methods such as
>>>>>> _REG are called, explicitly set all devices into D0 during initialization.
>>>>>>
>>>>>> Fixes: 967577b062417 ("PCI/PM: Keep runtime PM enabled for unbound PCI devices")
>>>>>> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
>>>>>> ---
>>>>> Through a bisect, we identified that this patch, in v6.16-rc1,
>>>>> introduces a regression on vfio-pci across all Intel QuickAssist (QAT)
>>>>> devices. Specifically, the ioctl VFIO_GROUP_GET_DEVICE_FD call fails
>>>>> with -EACCES.
>>>>>
>>>>> Upon further investigation, the -EACCES appears to originate from the
>>>>> rpm_resume() function, which is called by pm_runtime_resume_and_get()
>>>>> within vfio_pci_core_enable(). Here is the exact call trace:
>>>>>
>>>>>       drivers/base/power/runtime.c: rpm_resume()
>>>>>       drivers/base/power/runtime.c: __pm_runtime_resume()
>>>>>       include/linux/pm_runtime.h: pm_runtime_resume_and_get()
>>>>>       drivers/vfio/pci/vfio_pci_core.c: vfio_pci_core_enable()
>>>>>       drivers/vfio/pci/vfio_pci.c: vfio_pci_open_device()
>>>>>       drivers/vfio/vfio_main.c: device->ops->open_device()
>>>>>       drivers/vfio/vfio_main.c: vfio_df_device_first_open()
>>>>>       drivers/vfio/vfio_main.c: vfio_df_open()
>>>>>       drivers/vfio/group.c: vfio_df_group_open()
>>>>>       drivers/vfio/group.c: vfio_device_open_file()
>>>>>       drivers/vfio/group.c: vfio_group_ioctl_get_device_fd()
>>>>>       drivers/vfio/group.c: vfio_group_fops_unl_ioctl(..., VFIO_GROUP_GET_DEVICE_FD, ...)
>>>>>
>>>>> Is this a known issue that affects other devices? Is there any ongoing
>>>>> discussion or fix in progress?
>>>>>
>>>>> Thanks,
>>>>
>>>> This is the first I've heard about an issue with that patch.
>>>>
>>>> Does setting the VFIO parameter disable_idle_d3 help?
>>>>
>>>> If so; this feels like an imbalance of runtime PM calls in the VFIO
>>>> stack that this patch exposed.
>>>>
>>>> Alex, any ideas?
>>>
>>> Does the device in question have a PM capability?  I note that
>>> 4d4c10f763d7 makes the sequence:
>>>
>>>         pm_runtime_forbid(&dev->dev);
>>>         pm_runtime_set_active(&dev->dev);
>>>         pm_runtime_enable(&dev->dev);
>>>
>>> Dependent on the presence of a PM capability.  The PM capability is
>>> optional on SR-IOV VFs.  This feels like a bug in the original patch,
>>> we should be able to use pm_runtime ops on a device without
>>> specifically checking if the device supports PCI PM.
>>>
>>> vfio-pci also has a somewhat unique sequence versus other drivers, we
>>> don't call pci_enable_device() until the user opens the device, but we
>>> want to put the device into low power before that occurs.  Historically
>>> PCI-core left device in an unknown power state between driver uses, so
>>> we've needed to manually move the device to D0 before calling
>>> pm_runtime_allow() and pm_runtime_put() (see
>>> vfio_pci_core_register_device()).  Possibly this is redundant now but
>>> we're using pci_set_power_state() which shouldn't interact with
>>> pm_runtime, so my initial guess is that we might be unbalanced because
>>> this is a VF w/o a PM capability and we've missed the expected
>>> pm_runtime initialization sequence.  Thanks,
>>
>> Yes, for Intel QAT, the issue occurs with a VF without the PM capability.
>>
>> Thanks,
>>
> 
> Got it, thanks Alex!  I think this should help return it to previous behavior for devices without runtime PM and still fix the problem it needed to.


Seems working for me too, thanks,



> 
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index 3dd44d1ad829..c495c3c692f5 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -3221,15 +3221,17 @@ void pci_pm_init(struct pci_dev *dev)
> 
>          /* find PCI PM capability in list */
>          pm = pci_find_capability(dev, PCI_CAP_ID_PM);
> -       if (!pm)
> +       if (!pm) {
> +               goto poweron;
>                  return;
> +       }
>          /* Check device's ability to generate PME# */
>          pci_read_config_word(dev, pm + PCI_PM_PMC, &pmc);
> 
>          if ((pmc & PCI_PM_CAP_VER_MASK) > 3) {
>                  pci_err(dev, "unsupported PM cap regs version (%u)\n",
>                          pmc & PCI_PM_CAP_VER_MASK);
> -               return;
> +               goto poweron;
>          }
> 
>          dev->pm_cap = pm;
> @@ -3274,6 +3276,7 @@ void pci_pm_init(struct pci_dev *dev)
>          pci_read_config_word(dev, PCI_STATUS, &status);
>          if (status & PCI_STATUS_IMM_READY)
>                  dev->imm_ready = 1;
> +poweron:
>          pci_pm_power_up_and_verify_state(dev);
>          pm_runtime_forbid(&dev->dev);
>          pm_runtime_set_active(&dev->dev);

-- 
Alexey


