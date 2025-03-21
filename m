Return-Path: <kvm+bounces-41663-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 687ABA6BC82
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 15:05:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8C5B6482A59
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 14:02:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F93F78F29;
	Fri, 21 Mar 2025 14:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="yKO6D4rO"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2048.outbound.protection.outlook.com [40.107.223.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1153D2E401;
	Fri, 21 Mar 2025 14:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742565653; cv=fail; b=FqaBmqtVRlix/uccra2SJbTzmC4r4roC3+grj2Vg86RtIz5Le2xM51RT6EFWO0eDNfvtd+59VXG6CZNDpaL3ViUARYi+ni/N2DmO/d2zd6vgwOjTncD9Ob4tXJl4Nt/X8c8oJH/SLBKIGSHjXU3i9CkVW2KSOugX/Ctrk5dlvaE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742565653; c=relaxed/simple;
	bh=voV4ihmqm6/fp9+4hDrPc7nJEKBCd1Gqa/frtW7PT7o=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Dg7HabtPpxR0IQv+AnvK1pufAlCLRVe+cnuUOC3XHtvxJWBvi5iGw3GrdTCsaUZFwbLM3U4VbYd5F2sF64GcwQ51mX21ONRReRlw87cdon0zurRrRdv7f4JkaVqOIY4+E61gpilGDH691cGQp64riQvYq7ELbVelgZWjAz3wKxM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=yKO6D4rO; arc=fail smtp.client-ip=40.107.223.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rTYyM2Cmg3j6ubxJY3WGdgxqRF8Q9wa32oq+3TBfvRYxJKQs5eGa+GVxkArxO87Sykcht/m7NUUhetM4qW8nQsanq+yWgNLFjswJjYppfqPQ/vahPexArrE5kGXQzIpJ6J5It6Nv3OR7MdpIPUZZ+s7djuIgwGTk/KHHqPhMlK/GHDgB4cMV1zv/BwB6o8vr96jKfAky+fw5eXDyJAbqQgOJPkzR+e9DhnS+vk/aZtq0CVz7s6M0Psu2W1/puwfBQ0MHenyjfuHftfRcj4L2JfuiSdGs+xYBmjBD7kqQ6M0szHXeVo6HvpXiHC0HJwsWPJ+CGP/0MtRAFTXH8bFzzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V/reyNYMP0ySZxdQxbMSe78ziO0UKgzSJ+uYMMclIgY=;
 b=nRSdQXjWJzz5Fwxh/fofFUcrkK4Vyzhnc9UXksFzw++Ix3kB8kuNZpVNyABNKC1lnu/KbsyybEGTiB7YnZgYQZAOGiVbOR4QVkMTYk0Bw3eUAmzEtH3phrYSnix8rklpAOzyPBl6rStwyN9BD/0R+FFxxCWmJ1VS9Sxu9VpbW3jazbNfgyIWHxX4AlsaV75iE1v7vDkOv1drzMR0BNap56hoA6uak1i8Y55V7gA8W/VEcJI01yXnPXuuoJKMNbqTiBgchTLvF25vWbOWreozoEsT6rw3ESGuNLWNSfbG3OgX81QmQwVU9elAp0mDM+8Va2RRVcQx+3CePUnU5BcAtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V/reyNYMP0ySZxdQxbMSe78ziO0UKgzSJ+uYMMclIgY=;
 b=yKO6D4rOxIBQqbASQWCYCOYiR7wJoTPGaD0aocG8gJMWJ8lF+gp3ag8JR8hCkxCwcK2SJJT+IbeM0l8/PE907F0ppwYOtq2WMvNCIzEUe1LSCsMLoTf6hd0Rmayxbnljz9aG/ZQsuv3gI9WhgmB1rPzjVH1nLyOedb8/ejfDZLQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6608.namprd12.prod.outlook.com (2603:10b6:8:d0::10) by
 IA1PR12MB7758.namprd12.prod.outlook.com (2603:10b6:208:421::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.35; Fri, 21 Mar
 2025 14:00:46 +0000
Received: from DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627]) by DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627%4]) with mapi id 15.20.8534.034; Fri, 21 Mar 2025
 14:00:46 +0000
Message-ID: <c5947e5d-7164-45ff-997f-b36565412b86@amd.com>
Date: Fri, 21 Mar 2025 19:30:36 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v2 03/17] x86/apic: Populate .read()/.write() callbacks of
 Secure AVIC driver
To: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Cc: bp@alien8.de, mingo@redhat.com, dave.hansen@linux.intel.com,
 Thomas.Lendacky@amd.com, nikunj@amd.com, Santosh.Shukla@amd.com,
 Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com,
 x86@kernel.org, hpa@zytor.com, peterz@infradead.org, seanjc@google.com,
 pbonzini@redhat.com, kvm@vger.kernel.org, kirill.shutemov@linux.intel.com,
 huibo.wang@amd.com, naveen.rao@amd.com
References: <20250226090525.231882-1-Neeraj.Upadhyay@amd.com>
 <20250226090525.231882-4-Neeraj.Upadhyay@amd.com> <87plia33mu.ffs@tglx>
Content-Language: en-US
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
In-Reply-To: <87plia33mu.ffs@tglx>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2P153CA0005.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:140::11) To DS0PR12MB6608.namprd12.prod.outlook.com
 (2603:10b6:8:d0::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6608:EE_|IA1PR12MB7758:EE_
X-MS-Office365-Filtering-Correlation-Id: 83b9c02b-e5a6-48cd-136c-08dd6880c6d9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZmUvNmJ4L2NDVmM4b3RubGt0Z0tuY2pvaU1mRmVCbUQwQU1vaDlrSzZVY2lM?=
 =?utf-8?B?UFRUOHV1cllDeitCK2lzUjJaNnY3S1ZLYmpmRWdWWFRIOXhSV1RqcUhVbStz?=
 =?utf-8?B?STM1cWF5aU5ZZUg0MlFFR0hhMmVaLzVTTXZjeEF2cG9UYXVzWkpXMnFIM0tw?=
 =?utf-8?B?RXFkcG1POWtQTDJsMXFyUjNIRkdmZUFvOXJIOGRscWYyMWt4Lzc2c0t3RWhB?=
 =?utf-8?B?cnVjL2dIZENPVjY4RGt4TUl1eWQra3B4ZzFoRWVIYWRqbzd1VXZLWHhIdHox?=
 =?utf-8?B?N1E4TnhwajFPTFBYQ2xTMGlVTmVHK05NRG9MQjU5ZHpkSmUwU2srWVo1VjN3?=
 =?utf-8?B?SEVvMWUxbzAvRnlpbEFFeGdJclBCNXJ1d1ptbnF3MGl5V0lwUU5IcEdmWVBU?=
 =?utf-8?B?Z1hrNVBia0MxakJWZURObEg2VDlyTG9PVWhrWnJFMkdtM012ZDBFRjhSVndo?=
 =?utf-8?B?c3NTK0ZBSXdNdEFEOTJ2SDluT2dObWhDZ1hLQllBZmtVQm5MOTJYeGJCN0px?=
 =?utf-8?B?bHJsUThSZ1p4dVFlSWxVYVRhUjdHcjFJNnZ3RWxqZCtScklIVTU2OUtJZlBz?=
 =?utf-8?B?M3lobTVrdS9HaG9VVFBodGkzRTN6dGlOcUd5L0J0WVRmVVZ2RlZxeG5Uemg0?=
 =?utf-8?B?cWQ0MnFodE5NbUtCbUlQZE9uc1dwcW1ubHRQVUVzdDRQZGs1YWZ4bTErbHhQ?=
 =?utf-8?B?WU1HVUtuTDdyTlk1V0ZReHBlaCtrNC9Od01tZ1FiZkNoVFdaTWY3KzdSVjVE?=
 =?utf-8?B?M2QyNzU3T0E1U2ZjMWJDbDROWUwrK21ndUJ4Mm1DTjFyaStmK1p2aWtoSmN0?=
 =?utf-8?B?VGJpUm1SV0tPUE9rbU03Z1IzZ2xXRTZjREdWcG90Nm1Pd3J1S2UzRWNKeVM2?=
 =?utf-8?B?T3JEbWtEb0tNR21MeE5yWkRoY3ZwNmtjeG9PZ1p6OVZBb09aZGZiclR2TDZz?=
 =?utf-8?B?NFd5R2dRSXRnT0crWkp0SERoWmJEa01zQzZQbk9yeEZtSDIvZ0s0cE5ybFFT?=
 =?utf-8?B?Sm5idmdKci9oMkNDSXo1MGlWSWZ1ZDdrZWVlcFJLVjVqdVM3UDBtaWU1dTVj?=
 =?utf-8?B?NXBPUXQ2VUpDbTlaU2ZrYTk0RjBLZmxKdDArYndPREg5T3QwWXdRVmJVUHdh?=
 =?utf-8?B?b1ZmTkRxRWw5ZWNGdm96RytwdDBYZDFTbGJLYkR0bVpBN1pXSWVWcFlBUHJ5?=
 =?utf-8?B?OUNmT3Ezc0Y1QjJER0dNVU5RbjJVNzJsTTVyY2lHU2RLYU9veGo5dkw3TFhR?=
 =?utf-8?B?REdPcUl1d2kvbTdkT2xyalZnOVhla1hqWDBWUGx6Ry9aNlpkMEpTc1N4STRh?=
 =?utf-8?B?OGN5eFE0TzJWTGloNkhYVFRZZ3NsMlZ1SUxHd0pFVmZzWk1FdUYxVzNnRWNp?=
 =?utf-8?B?TkM4SUtocExhRVlJaEhGN0h3bk83ZXVKc3FQZXRZR0xVNmpMblRadTZqU2NH?=
 =?utf-8?B?bUE5SEhuS0FYcStkbTArKzQrK0ZpbEFiT2FBTXltTTRSalFjSkl3UlgzRDlw?=
 =?utf-8?B?aXZLZzhvcWdnNHUzcmJOcEt3RDNhWDllMmk2VFBzcWNvcjU5cVlOODBLTFE3?=
 =?utf-8?B?UGIralN3czdoSFNNK1UwWDdXVW43TEk0MmZ4dVA3TDlqN3JqWm1td1hEajhV?=
 =?utf-8?B?ZkxzOEwzbVJZNUtPcDdEbEdFNklQN3YvQklKcjRkbEVXdWVwL0d4bmU2R0tw?=
 =?utf-8?B?T1FnUHg1UVBhK2lOa3R5VnZ4TW1wTUUxZkFybm1IZlFKYkVuaHkvdWlMb0pR?=
 =?utf-8?B?K1daU0NDbll5ellBYUE4akJzL0s0Mk85MTl0NzR5NDNKUjFUQ2Z5M05BWjI5?=
 =?utf-8?B?cnk2OGNSKzJ4Wk42RjdCTGljNWFqa2hOSWV3YUFIWXJET21ndlpqbzdENE1s?=
 =?utf-8?Q?sgo0zfM04eUVG?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6608.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZmM0UUtXY2xicjd1N0l3c21Rck1VeFBqR0NETWlpQmJiNEFGQ3QyRFAxb1lD?=
 =?utf-8?B?TW40ak1Lc3NxR1J0VGczT0U1ZExJTGRReEFJOUJTZDlMNTBUMkxFeWc3LzFR?=
 =?utf-8?B?S2dhcWxIbzduSFNuMHR1aVVBV24rN25SMmVwWXNQSHZHMDk2M1dhK2tnNmtM?=
 =?utf-8?B?a3h4TExMMFZOMVFzeHJqYU5LTkg4N3JiMnJtak0ydjY1c3BSd0sxN0xLdjB6?=
 =?utf-8?B?bFRHVTltdWRBZTA2OE9xRDdLcGNRVWRObUFNNWY1TDV3Y0VRb0Q3Q2hGRFND?=
 =?utf-8?B?bk9HYk4wU1lNZk55N2NHRlhaQVV6ZXpYVkFBQmJTbWJtaXd4V1dOa3crYU0w?=
 =?utf-8?B?ZTJRLzJ3Y25RWlI3a281bXhHblpTVFg3UHhQRmp1MU56aDVPM3NiYktQUmR5?=
 =?utf-8?B?TzNxZjFiWDRGamoxMlhPNmtZNmVPUDh4QlA3dUh4T2Zad1BjNGhMalJhTHlV?=
 =?utf-8?B?SC9iZlU5ckdPMHl0TTJVZ3krWXRvcGxvQWVUdncxY2w2bS9RNUk0Z0tsR0RU?=
 =?utf-8?B?QWNvVlFVQlh0bzB6MkVFek1QOXBkcHNUei9sai9vL1Y1cVNDZmRLWmV0Rk1o?=
 =?utf-8?B?c25KY3NtVUZwMmFRV2ZMdDlzRlFGRkRNWFRIQmp6Qm1iTEhManR0T2YwbmFq?=
 =?utf-8?B?ZSs0S3VGQlRRYXZYeDMyVVJDQWhnTDNQSU92aUxETWNLWTgrdEgyem9jR3Zi?=
 =?utf-8?B?MWdHZnZPbjdxSVdTMXN0elRJNkJnS3cvY0hCVmV0aWdQWmFCZnJ6bTk0Wk4r?=
 =?utf-8?B?RmNXNE4wSTAycEE3cFVySnJMT2RsbkVpQnFWUVVLWG9ZTnVaNnF4SVNnYWJE?=
 =?utf-8?B?amRoVGV3djJkWmFlUkpxeTVjRTh3SVRVaU04ZUIwOTdhakt1YmVidFVYUE5P?=
 =?utf-8?B?SXZBWWtNeWFBZkR5S3FjTk5ZWmlrVUc0cVFhSUFFb01GTEtReUwyYUZCSXc4?=
 =?utf-8?B?UjNsczU1ZEZZby9uS1dmUFRVMTQ4VDdoWXFGWitLWWw3bm9kUjBDZFVST3Iv?=
 =?utf-8?B?d2tOS0psTm9MSyt1dllhdHliM3dSaGhSL2xVTHNMTXBIL2phM2tVdFFDQm9o?=
 =?utf-8?B?Z1lQSkt4eGdSSEtRSENDd0JHYjMxSlVwRFZ5VTltUTNaeHg3VnhPL1FqSllz?=
 =?utf-8?B?eXNKREVXSkRES3R2OGhJNmkzSk9PSDY2VWVDL05YZHovM24zbThpS29Db0xL?=
 =?utf-8?B?MDBCRDJhMjN0dmx3WmtkYit6aUdmWllHN1N0RTNlMnYrTWN4Zy8zUWtVYXVJ?=
 =?utf-8?B?cUtENC9zZXpQWFZtdnRrNE9WSDR3eUVnS3JFTjZYbEJZNitRbTYwQWxJWFB6?=
 =?utf-8?B?bTNTNDVwUVRBMXNKYWtYUEZtYTFCWXBKeHdiMnpGV1FSTkIyQWN6SC9ZbGVt?=
 =?utf-8?B?a2NQMDJGbXg2a0dubEdRSWdXNGkvTEtIYXdtU2RFaTl1cHF0YTBYeXJXbE5K?=
 =?utf-8?B?MXhKUXM0S3gyOGorVnEzdFZlc1poOXNXd2QvTXl2V2ZCRUlvTDZGT3VJODlq?=
 =?utf-8?B?MWYrUnEvaTB1d3h4cUpqRTcxa2VhWnUzY1JFcVpiSjhUS3FTTmJXTmtjOUFW?=
 =?utf-8?B?dUdYNXZtb3ZObUw0MDJiSjVaRFROdUxYVWR2dDYwUS9rRVEyczBOdHI4K1Bk?=
 =?utf-8?B?YStpOHNqcjlOZXEycDZWRVBKYzNncjZhOEg4eUhCZzJvWUxQcFhjS2xCRS83?=
 =?utf-8?B?UnVtTnBtQ2tPcU9KZ2lxMEltczNPVndCelAzYWRocERkWGR2enBYYStFNlJQ?=
 =?utf-8?B?RTZiRUhXcFArbTN1VnNobmJQaWREanpYRDhiOUJkdmVGSjgwb0dJVklPZHdM?=
 =?utf-8?B?RjMvWnZpVlBRQ0Z4S3dVQW5vNzMzVzI1ckFBRm9kWnVQMFltWWR2TTJKb2Zm?=
 =?utf-8?B?ZDIreEs5UUNDMHhUZHJWSGZDNVhwcmw1Mm1nZUV6MkFRak13ZVpXL0duanJB?=
 =?utf-8?B?Q3crdDhjSlFnOGRSQ0ozNHQ3ZGIwRllvTjFUQTlqeWQvTy9qNzlsYlFCZEsz?=
 =?utf-8?B?SEV0VjV6c2loKzFIK0o3UDN0MTR5UnBhbnlIUVVxTkpQN245dkZNYzhUaENz?=
 =?utf-8?B?TENBUzV4VldHMmRHNElWKzNCK3FjbUxaczlEZ0VNZTkyWGErd3pwRnRidGxN?=
 =?utf-8?Q?t6uvwOs2Uotm9zybvMKz8aqpK?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83b9c02b-e5a6-48cd-136c-08dd6880c6d9
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6608.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2025 14:00:46.0989
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r4WThOFkeCQt0fhaHtXLUSXelKX3I6j/X37OypvyG69a+OQ07JQnwOCpePIgEMPVNRlzjZB3DrVHvy9VBHZxUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7758



On 3/21/2025 7:08 PM, Thomas Gleixner wrote:
> On Wed, Feb 26 2025 at 14:35, Neeraj Upadhyay wrote:
> 
>> +static inline u32 get_reg(char *page, int reg)
>> +{
>> +	return READ_ONCE(*((u32 *)(page + reg)));
> 
> This type casting is disgusting. First you cast the void pointer of the
> per CPU backing page implicitely into a signed character pointer and
> then cast that to a u32 pointer. Seriously?
> 
> struct apic_page {
> 	union {
> 		u32	regs[NR_APIC_REGS];
>                 u8	bytes[PAGE_SIZE];
> 	};
> };                
> 
> and the per CPU allocation of apic_page makes this:
> 
> static __always_inline u32 get_reg(unsigned int offset)
> {
>         return READ_ONCE(this_cpu_ptr(apic_page)->regs[offset >> 2]));
> }
> 
> which avoids the whole pointer indirection of your backing page construct.
> 

Thanks for suggesting this!

- Neeraj

> Thanks,
> 
>         tglx


