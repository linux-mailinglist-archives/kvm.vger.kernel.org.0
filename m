Return-Path: <kvm+bounces-26824-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 39D44978240
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 16:07:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BAD421F25C9E
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 14:07:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 010481DC052;
	Fri, 13 Sep 2024 14:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="DsK+XHke"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2054.outbound.protection.outlook.com [40.107.243.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 856F62E419;
	Fri, 13 Sep 2024 14:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726236378; cv=fail; b=SfzZ7l8j7+PvRqr/s3eCbn2B0OFwW27iKYG/PUulaJIkavep6kUuaRSmS2AI24Lr0Bm3EfVrR5SF67A93C9TEDOLi1GoagQsNik6L0xGTCq5yDkqavQyd+2sVnjALZ4TI5CKBTIAKyHrbs/rboBv4XngGbMLG7bQ/IhHk7+HJrA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726236378; c=relaxed/simple;
	bh=i4GPIRnlkG6jMQYsWbbZQtzTyFXY4qwepAHxpopocRE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=VuEvogi7W/uB/30gyVdH2+snn8HXSwET21zgZLv5eLOcq/4QHADWHY/i2OUGGLpREhWSw6VGBzAjGIEUwQvrIvZftm3iDPI1qmQ1cxjjF+F2qcf58WkbOWysA5xEK6AL8kLru9lKFFdfBBrf/mxZaVH7B6DNmNIj0GpB09GXkhM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=DsK+XHke; arc=fail smtp.client-ip=40.107.243.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aq68USkWqd1k7zze7Fi8z2BywYk84hUwB5MzdmsZr+7lATnhN38gwcliRtmfHs2BgxxrKkojg/l8uJWLKB0Q1oY/6v5LXBQWshIznyRhBYHQDTs7QOvaw1BSdgD+xnO2cI5u2nNFVNpMp4OG7+iUqvI5nyQCcjZizStc+oq80cArfraPglVC9boSIC2OTG/ioeGevjIdTFesLgMmU4vUdF6/ufJkZqpuOXedIxAAXEuM6tpFeYpQM8ctYYdZR5BN9OHoK8qvZMsazjycI/nlH6dwNIn5ICaMve/Abncp8krAO6nOM/vJ1OHTVePR+ye8mJXjp/3Jr08MzCLisKfsuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nvJxA6dYpSaam68G6cKjEBQdfE7Vc36lDWDQDTuIwME=;
 b=gvYQx4V+7b39EedoF9qNRiXMZbfPU7G+F3GdH42ipURbVQILtRBLOdBpmxdNtwa2+qdYdTpQXdQ203fAqQq9Acv6360/4NTCokLk8DwqwGhG0/u0CdNLizH6m6hyovEJMFDE0fTriW6LktczEykz4ry8TzgHKl5jOCSz3NvYfpEj8dTMRDfqI6ruLN1veRCk/4l9sRD8muJ1dKIChEBXR/H/ZlA7u81oG5TEEcuFzzh61zGr7KS/DfZcD41cvO4TvnEzd4A6Wn5JzqqP1e/GqPirUgtiqJ8G74Oj8RfWWj9rgZOGWhpR4EyxPoffxz8xuiALL1WkLoz7/tJEWZIH9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nvJxA6dYpSaam68G6cKjEBQdfE7Vc36lDWDQDTuIwME=;
 b=DsK+XHkeM7fcnedLQYKD/N0q6RoNoYPnZzmSs3hUUJs+s+Ai17fa/tZ2wShHTJRGuJtH3d2YYjaYX1/VVBcoHs5cmBP3gO882+B371xi21nvBITEOd7pJ43BX3HRp1TWF7cU3iUIQJ2mO0bdX1AE4FEz/SCK7VR7WOURoG15itQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by DS0PR12MB9345.namprd12.prod.outlook.com (2603:10b6:8:1a9::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.28; Fri, 13 Sep
 2024 14:06:13 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.7962.018; Fri, 13 Sep 2024
 14:06:13 +0000
Message-ID: <60051636-35ea-d7a2-9204-037adea1d509@amd.com>
Date: Fri, 13 Sep 2024 09:06:17 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v11 09/20] virt: sev-guest: Reduce the scope of SNP
 command mutex
Content-Language: en-US
To: "Nikunj A. Dadhania" <nikunj@amd.com>, linux-kernel@vger.kernel.org,
 bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
Cc: mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
 pgonda@google.com, seanjc@google.com, pbonzini@redhat.com
References: <20240731150811.156771-1-nikunj@amd.com>
 <20240731150811.156771-10-nikunj@amd.com>
 <30a5505f-8c9c-6f13-6f90-8d5b6826acb5@amd.com>
 <a826082f-d80e-4aa3-982e-df7c723e2d2b@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <a826082f-d80e-4aa3-982e-df7c723e2d2b@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR12CA0008.namprd12.prod.outlook.com
 (2603:10b6:806:6f::13) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|DS0PR12MB9345:EE_
X-MS-Office365-Filtering-Correlation-Id: cdd8dcf4-2cbe-4a11-dff8-08dcd3fd3a2e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VnlUQ2R2WWZ3SnBvTkEzMzdwVnFiZDNGZW9sR05jUzJyQmVBKzBGdktrVkVu?=
 =?utf-8?B?Rlh5Vnc4VEZRSFdvbkdvM0UrL09ESHZsb0lKeTBPamNsQlJ3cDRpVC9KOHNk?=
 =?utf-8?B?U0kvQlRYeWZidTZRSEdMa2tOL2ZNSHFYZVROa2owS2s1TW5jQkxIeUMzN29r?=
 =?utf-8?B?b214YmR4S1NTd1VLeHpLbGFBa29RS0N1cTM2NzlrZTArLzNqZG11dm9BVVZU?=
 =?utf-8?B?K3h1Q3pwdlM1dlRNc1NGamRHdm5vNjRSWW9SYzRMWkdoc3N6cTJZNWlyeXNu?=
 =?utf-8?B?Q3RwTjRnME5yZ1YyOWZuRXRXRUgwZTIreGRCQTkzVTEzMEtmelZKb0NOeitC?=
 =?utf-8?B?allwYzUwdGR0QVZsS21Dc3FKYXovaE5veG80bWxTOXVOcmRDd0Jnd1pqRlBZ?=
 =?utf-8?B?ZEoxdWVVV0l4SGZHVEN6Yk1NUTR6WFJkWSt4K0Z0UU5ERnNTVysyb2M0SVdl?=
 =?utf-8?B?dlh6Si9rTVg4RW1WaUthWEVmcFRRTmVzRUdIL1BNV0Nuc3JQTnhLeE4xZjFE?=
 =?utf-8?B?R0Z4c3lJZnNLTTlhOVpRbWNNUU5wTk1MbDlMTWs3c3FkQWRaRlJmODI0OVF0?=
 =?utf-8?B?WUlSaVZOSVlCbWpkTzlQVWNmQnNiaHVUY0EyODhTcGl5NXJTNElCSFBYSGR6?=
 =?utf-8?B?MDZlajBBL2E1L3lmS1ZGYldzOThmMW1rVmovM01FU2Y4Zmp5LzVyWXV6Vkc2?=
 =?utf-8?B?aGV5UHk5eWJuVHZVeTdxUUt6MTRMaldyWk0xUW1mcldYUDdNREtGa2dSZDRE?=
 =?utf-8?B?bFh0N09tOFdnMUVsUE84MWRHcVNuVkQ4d0pDNHdzNmVTWWNLeUNYekVGNUdo?=
 =?utf-8?B?aHlzdkxJOEhFdWFZMnU1TG5qRkFzY2pydlZ6Sm8wNHVvU09vYnNKd1BtU25D?=
 =?utf-8?B?NW5OQXkxUnhodE1nZkkzajFlVzYvZ1FwWnFrS0k0bkhLNSs1VDVSY2U3WmxK?=
 =?utf-8?B?VFBBVU54aTZDbnV6UmJRL3Z1R2xGcDRWYys4MWpDekZGcWw4VzJlQWZJcGFJ?=
 =?utf-8?B?aE5QcHgrYk5YcVZrbW1jTEhPTnhaM2VCeGpSaTNMNHhMYUtPemwzbE5lOWN6?=
 =?utf-8?B?MjcwcGRzLy9NN05IK3RZT1dhZmQ3RGorallkMWNDc3crdzFDUkFpOU15Q3hX?=
 =?utf-8?B?LzFKdFBmN21oaDJhYkxmS1diTGs4d0hBb1d2UWY4NVd3QTdWYUpBQXhVMG9H?=
 =?utf-8?B?WjJhL0hpWG4ra05kS1grTzBqSFJpR1JxazNtUzFzYkZtdURMTk1uWXJlV2Vi?=
 =?utf-8?B?R2ttd1JoS3FkZmF5VDJnSGRNMEtNS0t4a2FIREJCQWZ3UkR1VXlrS3FWOTlL?=
 =?utf-8?B?UlpCb1NobG15ZmFyYnRUS3RoZk5Jdms1NVJ6OVA3Q1BOQlZ0RVIrL3RiMWxp?=
 =?utf-8?B?TFFTZXF1Q3N1QklaaXdOd1hvWDlJL3c0QVd2ZmZVVlJpZkdCdDdlZEY3QWZT?=
 =?utf-8?B?UTcxd0tzTFJXZ2xtOUt0NjFPdFhkUDc1N0c3YjllWEkvdkp3TWhYK3c1V3ZE?=
 =?utf-8?B?T1ZIUnpDdXBxc2hxRCt5ZTlSZ25KejNxR1BFa2Q4UDB6NXVoSHZhaW1jR1Iy?=
 =?utf-8?B?NDQwZUJobVZGTGVHOFRqUWlSSkRodHhSejJ6Q2dtVHQyVlBkWi9FemFVeCs2?=
 =?utf-8?B?azQ3dys1QVNLeFppLy9LbVBsMVJrbDVGRmdray9uZVJabHp4UnJ2TXdhZEJH?=
 =?utf-8?B?UHh3T2dydGJRNng3VHVXOGNhUFZSTWFac2VVbzRHUE9ybE5lYWlhRkhXUFZv?=
 =?utf-8?B?UkZuZnBOaEVrNDJ4SXl0a3Q0T1pIRnFRU29tVE1PUS8vaFpEUXdpWUlxd0Zp?=
 =?utf-8?B?TDNqeVErQmFDRThQVS90Zz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cjFoKzlmY0UwY2UwZGlLalFKL1FQZkk4ZkFmd1VBTGVDaWNsQm9FOXUzR05y?=
 =?utf-8?B?Nldac25NNW9ITm5qTTR1WW43Y2Jlc3ZIZW9SbjBiQUFwNEJ6bitaRUF1aUlG?=
 =?utf-8?B?ZkxFd2pBWk9mRmxocmJlNStLa1BIWUxzN2tYaTBQY1I5SExDUGxNZ2J6QzRE?=
 =?utf-8?B?Y2hTNEl6YVhQd2NZalRVVzFtNFZJRzdCZis5ZGZMcGcycis5TWYwWG9VL3NP?=
 =?utf-8?B?UHFwc3FVNXd3VS9qMCs5aU1mQ2cvaXZ6cUpyRFRCUzVmQ3g5SnlEOUlZdWl3?=
 =?utf-8?B?Szl5d2xzNklFZkFWN2ZjK1hjZXVuYkNrZHZtNWlPN05rMVpoaGhWaE1wVmpG?=
 =?utf-8?B?UjNvNDF0ZGpKd3dkYkhCb2VHWEk5d0NGYU5Xc0YxUTlBc0JOd3d0ODB2WUJk?=
 =?utf-8?B?d2JBTFUrb0xhQmY1aUQ5U1U0Z3JrSGZJc3R4M0JzVmhnSlBpYjRTdm1mc2lC?=
 =?utf-8?B?YThWRmQvRG03T3Y5aVpMSlFTYUJacjBvZVM3MTFDSVZqZE95MHF0VzROVW5X?=
 =?utf-8?B?TWxrWllzVFBhYVVUdXgyNmpxa2FSSENqMWlhM0NYRnF1K3F2Z1B5M1B0Ti9l?=
 =?utf-8?B?VmxiZ3o1UEFEaWtlejFoMjdWTFZKSXE2OVBHa21mcWVOaW9tR2VSUnBHQUlu?=
 =?utf-8?B?WlA3ZjJOaUd6akEyNWkrUXBzVFVKTE1vODFlSHJERHg0UitlblRUc1FEdWkz?=
 =?utf-8?B?U3hZUmdvbm5JQXJ2SEdwUEk2MnNaTlZjaHVRTFhFVnNNWnBBd1NudW5SQVUr?=
 =?utf-8?B?YnJ3cXAxZndJWmh5ZVNaNXdldldWcmMwdXFDQzFXNXFRM2REalZqUXhWODVh?=
 =?utf-8?B?dENRQ3pUQjFpcTI0T0JidGU3VVRXWTFiNWg1S3NUNkdBN0txSGFCUjg2dVU5?=
 =?utf-8?B?aVIzbjlrU25RTmxFak02MFhmMGJURDl6Q0diS21VSzJrR1pTQm0rQXJPNHox?=
 =?utf-8?B?R0RkRjFnMVQxZHp5NFk0Tkx4azJvOHl0elhKN3ZkOWI3RVh5NHcrU09WYXh1?=
 =?utf-8?B?OWRKaUZUVU9xcDJramZxYWFQOVpYaWMrSHkvSm8vSFBLbkhvU2dTYzFOZTJC?=
 =?utf-8?B?dHJseld6T0hML3RTRGsrOUprOFNmbTl1RTB3dk5rZVFZSnFKU01NUmpEQUhO?=
 =?utf-8?B?NE1TazlWVDkvM3Y1eVc5L0ZwOWIrcW5kYjVmZzZUUlBTT1IzQzlCWXk0aWh6?=
 =?utf-8?B?TjhvRk1sZGlSNXhqaFV2NFIvd2U4MW5zSWtjLzVCNERNd3lXdzcrT0hKZnpm?=
 =?utf-8?B?MjZHNjVxSkNBWFZwb0xodjZMcjQrZWF0anJTV0RNbWQyZHdGQllkcnpFcTg0?=
 =?utf-8?B?QXF0eVV6c3FUZkYwcnBmVHFLTEdUUHMzS25DQlIzYnliL0NWc0lBOEVFVFVP?=
 =?utf-8?B?MjRuU01JcnlzNEg5T1l6RzBZeFhQakNKRjhBVFo5ckdCcktWVHBZL2pGZ3Ji?=
 =?utf-8?B?REZwWlhVTjdrUWZINHVDdU1OeHpwV2E4cDhhSVJyNnlZR2I0N3h6ekVJYlhi?=
 =?utf-8?B?S1UyT21xZDZ2dzNua0htYWU0bEc5U1ZZSWhnbzNEWjdWRkE0QU93WWdzUGl2?=
 =?utf-8?B?MXM4UlNWK0NVZHhLSXc4OGEwUGFJUFJqSjBQaUNiUHZmNFowT25LcStjL2hj?=
 =?utf-8?B?MC9Xd2pONzdHcHFiS0dadWJBL21qREdkSDcwZEFoVlVIbGx2QWI0RjlLektH?=
 =?utf-8?B?eXZvQTNpOHFBVkplOE8yWDF1SGt5L3BURnZtTlBGVk04WjRXZVhZcko0OVBy?=
 =?utf-8?B?Tm9oZGNmbExTN3B4NWRYaXd4YjZtYXl6V3hwZ0NLWE44a0IvN0doYXliL3o0?=
 =?utf-8?B?dG0zZTV2Zm1KNjdkY0FGVTZVWGkwcnBIRGpGZzFsUldyZFNFemo3ZkFFNGQx?=
 =?utf-8?B?THBxd1pYRHhVSGZiU0VwQ3NyTWxtelF5L1FpeGsrRUZmTEtBbUVvWENRSmgv?=
 =?utf-8?B?U0x1K2NwVzIrWVB3N1NmRU1hVFpuSkNvK0NRVEwwcEZOSWNmOHlsdTN5RjBJ?=
 =?utf-8?B?UEJYZGpjbzZFYnMwdXZMSGFPeXJRaDJNK0pQWjY3NERFeDVQTkRuUkFSdTFM?=
 =?utf-8?B?dURUenlDWGFOWmJlWFJRV2NydmliQldCM29IcWlFQmU1cGtpV3FDbEhiSGxW?=
 =?utf-8?Q?shy+CsNFE1wtljqH1C+q7mcHH?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cdd8dcf4-2cbe-4a11-dff8-08dcd3fd3a2e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2024 14:06:13.7331
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y+iE3XvF3PN3ijnKLp+zX7Q5EJ7fuyaiCMuct9o8o8Rn09JKYTlK0Yf3bL9UkAgZ9DeJmN3f6XWqnoI5vZN6sw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9345

On 9/12/24 23:26, Nikunj A. Dadhania wrote:
> Hi Tom,
> 
> On 9/13/2024 3:24 AM, Tom Lendacky wrote:
>> On 7/31/24 10:08, Nikunj A Dadhania wrote:
>>> @@ -590,12 +586,9 @@ static long snp_guest_ioctl(struct file *file, unsigned int ioctl, unsigned long
>>>  	if (!input.msg_version)
>>>  		return -EINVAL;
>>>  
>>> -	mutex_lock(&snp_cmd_mutex);
>>> -
>>>  	/* Check if the VMPCK is not empty */
>>>  	if (is_vmpck_empty(snp_dev)) {
>>
>> Are we ok with this being outside of the lock now?
> 
> We can move the check inside the lock, and get_* will try to prepare
> the message and after grabbing the lock if the the VMPCK is empty we
> would fail. Something like below:

Yep, works for me.

Thanks,
Tom

> 
> diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
> index 8a2d0d751685..537f59358090 100644
> --- a/drivers/virt/coco/sev-guest/sev-guest.c
> +++ b/drivers/virt/coco/sev-guest/sev-guest.c
> @@ -347,6 +347,12 @@ static int snp_send_guest_request(struct snp_guest_dev *snp_dev, struct snp_gues
>  
>  	guard(mutex)(&snp_cmd_mutex);
>  
> +	/* Check if the VMPCK is not empty */
> +	if (is_vmpck_empty(snp_dev)) {
> +		dev_err_ratelimited(snp_dev->dev, "VMPCK is disabled\n");
> +		return -ENOTTY;
> +        }
> +
>  	/* Get message sequence and verify that its a non-zero */
>  	seqno = snp_get_msg_seqno(snp_dev);
>  	if (!seqno)
> @@ -594,12 +600,6 @@ static long snp_guest_ioctl(struct file *file, unsigned int ioctl, unsigned long
>  	if (!input.msg_version)
>  		return -EINVAL;
>  
> -	/* Check if the VMPCK is not empty */
> -	if (is_vmpck_empty(snp_dev)) {
> -		dev_err_ratelimited(snp_dev->dev, "VMPCK is disabled\n");
> -		return -ENOTTY;
> -	}
> -
>  	switch (ioctl) {
>  	case SNP_GET_REPORT:
>  		ret = get_report(snp_dev, &input);
> @@ -869,12 +869,6 @@ static int sev_report_new(struct tsm_report *report, void *data)
>  	if (!buf)
>  		return -ENOMEM;
>  
> -	/* Check if the VMPCK is not empty */
> -	if (is_vmpck_empty(snp_dev)) {
> -		dev_err_ratelimited(snp_dev->dev, "VMPCK is disabled\n");
> -		return -ENOTTY;
> -	}
> -
>  	cert_table = buf + report_size;
>  	struct snp_ext_report_req ext_req = {
>  		.data = { .vmpl = desc->privlevel },
> 
> 
>> I believe is_vmpck_empty() can get a false and then be waiting on the
>> mutex while snp_disable_vmpck() is called. Suddenly the code thinks the
>> VMPCK is valid when it isn't anymore. Not sure if that matters, as the
>> guest request will fail anyway?
> 
> The above code will fail early.
> 
>>
>> Thanks,
>> Tom
>>
> 
> Regards
> Nikunj
> 

