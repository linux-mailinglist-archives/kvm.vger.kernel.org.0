Return-Path: <kvm+bounces-25919-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A786896CCA6
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2024 04:30:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6061D287E67
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2024 02:30:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6092013B2A2;
	Thu,  5 Sep 2024 02:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ZyVUsJJz"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2057.outbound.protection.outlook.com [40.107.223.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 814A5946F;
	Thu,  5 Sep 2024 02:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725503392; cv=fail; b=sVMULxHA+EAsrxNjDeWuMJL+5S/77KG6KAW6AVgf1aTVqJIZWj31LKZbh5BBw87GcIHPkq0LysN5MnO/ETlUwbfB9fv1FVJcmwJF5qvVJNcu9HBlw2ou21LpqaaldqyvfkGzznOTacab1SZe89K3MCQ/4x43XnJJJYqyK5hqI4o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725503392; c=relaxed/simple;
	bh=kPPUVltUoY7cIte8h0pHzSdf5HjsrYI+O8lohdK8mro=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=hfxcbGrSBoPDz3zq92y+yZbU04izkwmxnld7fOpjhOeePL9opzDDrRUupv0puZ1Uu3r/v1hHCgez2lkbCqM1uXVk8JzuJ3S9WZuaLV+6QlHueEe5pDM6NH5PQFhIGVbvltNxvQOCpyZoDZJ3EUeGv0MBAuvICM27DQ0gsa0ME68=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ZyVUsJJz; arc=fail smtp.client-ip=40.107.223.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Yrxbmlj8hBAmhE5tqc2h7Gyzc+F/hPclv4V1kChLc7CKJms+yOrtBVJB0HAo31kyKwqsseYPpgwBQzOkMwogqjDT629k8k22sx/lwO2nE2FwS3F8HhFbtj6z1LTIekn/4I/KafRNJ2+YACGXInpUiNx4LTIDSAmrjOpOUsXjrjFVhteV2vebwdj7zvI8Vya3FvROXbIceMeerX/QPU5fu6Dyz5bbz/UYx3WV6OqbQQgiNbUdOl8oEXv/5UQkbHZ/FAyqNL6+16Y7fX4zi24UKoIqt5PLKoNWS46XwJypeApQZopWaV+8hD9cKLhfV8DGTe+Mn7JWWJv7Ytq4pOXAVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SmI9XP1ponenCwRfQSUxKXwHULKjk0JpS0YI0GCU1E4=;
 b=StY9zanmQssTpVbm/fUGkZjfPmSO58a/ebFpcLVzFrhsuk7qfMVJidsZqs30kzHPMUrF2srlK3k9Wu+2pue0OISXpwEegY5J507ybQyPyyXSp7M7WsZZASAHbE13CqvsI7V/a7GaCRSTglTstFrjNf1Jzbk+8IuJtzNIuBwV4yezdMf2KFZclFwqS3AuMYwbzptHIHjj2MGpYDgQ5OVaV07pdwZ1ootSpN4v4dMAjc0eHXqk/Rjung09zJShPfuiEKO4PpSB/sLYkwXuCuM5+rNinQsrW3NYY97NeS10hFWPmutUDmvvjhzMmi+8L4WajxBLhtHMimEjF7doZ0OziA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SmI9XP1ponenCwRfQSUxKXwHULKjk0JpS0YI0GCU1E4=;
 b=ZyVUsJJzSYiDQ/N0kSW7n1QQpzGRg5fdu9Eo3sLsTsG9c7r4JGh3SKrNlHYJ849xuYZjZUcpHS4ZjLEo9tsIuEX6RHqZvXTQOPv8ENV77X9mA5HH/aof2yQc3toOWy2x9wWk/rGy7fknZjPFUITj8I7n7qfFyOuee6a8460sSBE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by LV8PR12MB9231.namprd12.prod.outlook.com (2603:10b6:408:192::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.27; Thu, 5 Sep
 2024 02:29:47 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f%6]) with mapi id 15.20.7918.024; Thu, 5 Sep 2024
 02:29:47 +0000
Message-ID: <16182660-3eb0-4df0-95a5-d4d2c4598319@amd.com>
Date: Thu, 5 Sep 2024 12:29:38 +1000
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [RFC PATCH 06/21] crypto: ccp: Enable SEV-TIO feature in the PSP
 when supported
Content-Language: en-US
To: Dan Williams <dan.j.williams@intel.com>, kvm@vger.kernel.org
Cc: iommu@lists.linux.dev, linux-coco@lists.linux.dev,
 linux-pci@vger.kernel.org,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Alex Williamson <alex.williamson@redhat.com>, pratikrajesh.sampat@amd.com,
 michael.day@amd.com, david.kaplan@amd.com, dhaval.giani@amd.com,
 Santosh Shukla <santosh.shukla@amd.com>,
 Tom Lendacky <thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>,
 Alexander Graf <agraf@suse.de>, Nikunj A Dadhania <nikunj@amd.com>,
 Vasant Hegde <vasant.hegde@amd.com>, Lukas Wunner <lukas@wunner.de>
References: <20240823132137.336874-1-aik@amd.com>
 <20240823132137.336874-7-aik@amd.com>
 <66d77f5ec9da8_3975294d7@dwillia2-xfh.jf.intel.com.notmuch>
From: Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <66d77f5ec9da8_3975294d7@dwillia2-xfh.jf.intel.com.notmuch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SYBPR01CA0078.ausprd01.prod.outlook.com
 (2603:10c6:10:3::18) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|LV8PR12MB9231:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c3c8a6b-35d3-4b08-9798-08dccd529bf7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RGorcHQwTThvekN2NUwrLzExTFIvLy9FNGtDbWZjc2E1TFBWUzg5TG1qZWRu?=
 =?utf-8?B?MXczeDB1Qm9Da2pVMjVZMlFNU3gzZDE0L2kxaGFUSEc1QVNNa2FMMEVwWDdJ?=
 =?utf-8?B?TnRLODlMQk5zU3JUWU1MOFhXOU05ZHVUaDZFWm9xMGRDbmk5TGFwK2wzTFM1?=
 =?utf-8?B?UE5YK3VmOWF1MDZiOCtZTUp3SENBYWNaSTRwajJwWGkrek1ROTNQTVdpSkRQ?=
 =?utf-8?B?NWZTNmNYR1lIemNJUm82RXdEeC9xTzJBekdLbzJVSkdCVmFGZzFYVjU3a1Iz?=
 =?utf-8?B?OUJRNGQ2cGhoemlUVHV1c0RaaDJiRjhJRGpWV1B5WktXd3BpSGZjSU1EWWQy?=
 =?utf-8?B?dzFwSWNDTEJjOHE3aFVPRnRHcExYNTdRL0RHSFNSOWFDZ0t4YlNncWJucjdx?=
 =?utf-8?B?QUZ3dUY3d0FSZ01JOXpKdDVEbGR1VU5WeTRyenRsUTc4dGxEZGUranF5U1k0?=
 =?utf-8?B?OHRVUkJxWTIyRzlRdmN5UjFkL1FiQktjcmM2OFNSM01odzl6SzRaMlNXV3R3?=
 =?utf-8?B?NXRqQkE4U01NMEUxM2MzZGRNcGFjUDdwR3FTaGg4ZnN3L2JDWFVEVENiWnJZ?=
 =?utf-8?B?WW1wTXpQTUNTNmR4OVdzNlFINEdYSWUwY0N2djh0TERQa09NSlU0RXl3bzdo?=
 =?utf-8?B?L25ONncxUS9ZWElSaUEvVEFMdjU5ajFXUG5WakZBcmtCSGdQMFQ0dHFkL2tQ?=
 =?utf-8?B?RFNEU05maWZDdE9leTdTY3FpOHNqKzYxSy9OMjlSQm9GNklVc1dncHlkbWdo?=
 =?utf-8?B?ZzdvajZFMGpuWXpPZDZSS0N1U3k5YnBRSW5WY0R4TjRaYnZlcFRzUmd1Y2Qw?=
 =?utf-8?B?T0x4cmpiTmhQUkxRai9vZ3pqODI1aWZyKzEzM0tVZnFNTWt4TkErcnQ2TUc0?=
 =?utf-8?B?QWkwMUZvams3VnZqM0lDN2VpUExuay8yMi9FRzlvdXVkWFBnUE1qSTF2MjZM?=
 =?utf-8?B?RGMyODFMSm5UcENZQWM1NXg5WmJzbzNBTFJvVEs0ZVVtWnBpcklOTlpuNXRk?=
 =?utf-8?B?MHZzR3NzY1g5ZFUvQ1o5eGJiSnMvQlA5NHh1TTBPWHZSWllzclJZTERjR21v?=
 =?utf-8?B?SlBGVGgrTzFRczJHcFNMRGRmZkZHV1N2UVEvV1JKNEhoazRXMDFBUjhYVkt2?=
 =?utf-8?B?dkc0QmN0bmdYcXJ6RnFQK3puVkgyeGtuMDZybjFhQ2J3VE84eU9ja0wwWkdh?=
 =?utf-8?B?b3hhYVVWbnNFV01FbHVBVE5KWGNYRkFDb2JZeWl0T1VZYjdoVW1nRDRkK3VF?=
 =?utf-8?B?cE5OY2cydER1bW5CM2FLWHZmeTVzK0taSzZoNmVUQmJMZzJsNEt1RXlja0l1?=
 =?utf-8?B?V2pVTVVmWDhDcTlQQWIwTG1sODk0UGwrR0tZZzdYR1kyQXJXM2lWbXlublQ3?=
 =?utf-8?B?a21CNlhrSXVxMnk4eloyaHdOSGNhdWRCT1E1ZDA5R2N4ak80cmFWY21ITi9D?=
 =?utf-8?B?NERwQWk3dEc2UWFlSElXT3pidHZwbXFlSXRrMlo1eEh0T2M4QzVSaU9ZS1Y3?=
 =?utf-8?B?NlcyeE9HQ0NnMlZDWDBoWDR2VzFENVVGS2g0dERNbnprQUtEUUhIa3lKL0RG?=
 =?utf-8?B?Q3NwQWgzSjNySTlHTnNJb3RsSjVUdUZDQzhpcE5ZQUxaWVAwakdGUHRWSGJT?=
 =?utf-8?B?dVVJc0lYaEtuZnR5TUJlK2ErdWs5b1Qvc1NXNzRQamluaStoaWd3UDcwTmRm?=
 =?utf-8?B?STF1cmpoOUdLcXBqVS8zVTRQZkFoejM0MUdWejZFRnoybEsyYzRTVkRXSGcv?=
 =?utf-8?B?a3FMbHFtYjB4c0VadDVYS0tna2hQZnZOSngyaDZweWlVc08wL21oTjBhdnU1?=
 =?utf-8?B?am0yMUtYSGRIcThmcXdEUT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?L1hhREdRTEowTUpESjZOMTlWQnhzZCtuWnhoR3RiYUF5VTBWK3g4enozZ0FC?=
 =?utf-8?B?amZRMzAwNHp5dzdrTkRSU3MvL2I5NGlCZmpvQjdsRWtjZXBud3BJb3BmVEhE?=
 =?utf-8?B?RkNqSmNuZnpHSnRScjFWNXlVYlFjeTJQZGJrbnpjd0hDWlp0eXNoSk9rbElI?=
 =?utf-8?B?VzN4ZHlGRlFKT0UwMG9tTzdGRUJINVNOOHVGdUtoa1pncHBXZkw5OWNCTURS?=
 =?utf-8?B?b0w3K3hWNEZudFY4QVYyZkhvbFFwSHozSEVOMEtWdUhzMkFMT0hEV05IK1pX?=
 =?utf-8?B?N091Y2FwMmdNQUdKRTk2QXhwSjJ5WmU1YzAzcjZJWjM4ZVlrTHlUdHcxRXF4?=
 =?utf-8?B?SVd1aGlBY0FWcURSVUttSE9xb0hUZm1GaHhadDhPOXErSXYwekhQVzhmV05j?=
 =?utf-8?B?dE10WjJTRjA3UkMwQlJMSGJaZjFkREd1d2t4YllobmUzb0JyYkpYd1VYaXVz?=
 =?utf-8?B?OEt0M252U1RHQXFNcGphTjZrK1o4UEk4T1o5cWlqbzgxTmlyWWErczdHYVda?=
 =?utf-8?B?RWE4ZTdRanhzTHBJVEtHU3BxdzBaRmZKbVp0OTdsYmFHNkZTUkFWQmRZR1VE?=
 =?utf-8?B?cUlrS2x1SXhSMmE3ZXA2M1FhZFhYRGZ5ejNQUjZvTDREZzF0TXljbllRYUdp?=
 =?utf-8?B?QUNFZFh4N0d5RytZOHhLZHNMdjRHUVpBY1hBTmVuNVlMNHJKVC9zMm8yVVBh?=
 =?utf-8?B?YzJ5N2plWVEzNUh1UzRoR0tFaWNBU3VJY3ZabXdNVWpYNzZnNWlXOEQzWU5p?=
 =?utf-8?B?bkRrN2x1ZkhySzJtWm91Vi9ZMFFCdnhYUEtraFIvVFJKWkhaUURZaG5tNVhq?=
 =?utf-8?B?S3kyUVYxdGxqYkhMTEIxUzFubk4rSk1rV2pwWjA3dFp5MUh5SHBjVk1KaVdH?=
 =?utf-8?B?NmhZbzhYNkRYVk9TR3hYV3B2Q2czRnFoUG1Ddk1jaWQvWmNkS1ZoRWx0c3dt?=
 =?utf-8?B?RENBNlM4Z09rRTdvbGJwcW4xWkZ3a2Z1TWpPeHJQY2dSeGlXL1RscEhyVUxu?=
 =?utf-8?B?eC9rcVV1andkMlpBSnBhTlJUL1FzWTVBRENXdUlscG5LNm9SWDdNZTdEbXlK?=
 =?utf-8?B?WlMyVGtPaE0wUW00NzA5WU1GNXQ5QjhTQTQ1d3RnaU1VODlDb0JodzEzMnZy?=
 =?utf-8?B?UkRwSzNpcjluRS9GN2MyNkhNM2pObS9FdXdKaDFldXh2YUMwRVVGYzlYRG9n?=
 =?utf-8?B?KzhoUnhXZzhQWDNGeTUwWVMzUkxmMjRyU05rMW82cXZrSWJoYzREZVFzRkZP?=
 =?utf-8?B?NFdGSHE4T0hJWVJmWVkwbUYyendmYVk4c3NvTHkzRUpLSlhld3FSV3pqUEpk?=
 =?utf-8?B?ZmxMU283eW1mYk92b0VRaUptTXpNSVNkdE5ONXpldGVZaHlrZUZ3Q1FWWUpp?=
 =?utf-8?B?NTdOa2VLbnFtOWl1cDBPa1ZHQ3ZiTFhtWVdRaGFyRkJWazRaWDJ1MUN1cG1w?=
 =?utf-8?B?bmxmMVQwVXY5LzVMTVRqRkJ5Q3FGMDZSc01rTTNvc05FV0lDQUxFTlVKeU9U?=
 =?utf-8?B?M3VRY3Q1TzFqaVBtU21BSy9NUnIwVVgwbWZmeDNRTU1ub0E3Z2V1Qk1wRzVH?=
 =?utf-8?B?WU1sMTVnSDlSRmxrR1MvcmNTZnRHZkhKQ0pBajAzU3JUdnpUZVF4Q2NMUGJh?=
 =?utf-8?B?V1ltcFNzNkYrcEQ1WDIyYVc4RHkvNWx6TmJBSUNleVAxZWZFZ1RrQzUzSDRL?=
 =?utf-8?B?Qms5NEpKeS9UQUFyVGw4dXpNL1pwVSt2RXI0eUJlTFY4Y0laMFB1NDRQWnlz?=
 =?utf-8?B?K1gwWFI1VUN6SXg4cGd4UmhlYXZqaHZ4M2lDV3VNYzN0eGJsbG1VSUdJSTFH?=
 =?utf-8?B?WlNQQzZHOEhFdGZJU2Z2NE5MaHBwOEdmRCtKZjhSazd0TTRva2djQ1RBTjVq?=
 =?utf-8?B?bVd1Ukl1UWRkL00wS1AwMFh4Tk1UNlhJTmlDYmYrUXFYM0VuaVpLdjhobXZX?=
 =?utf-8?B?T1h3aVQreHdKdk5jTEFYemFLR2QyVmJKRnJRUWZRMjQ3SndvZ2t0azVtR2tn?=
 =?utf-8?B?T3kybzV6Q25YeXFMSHRZd0pUMjZBOVVWaGtQWmcvTUFkU2wzc1V6QTY0MVR5?=
 =?utf-8?B?bFFCTzJZdWJNVTRFYllSYXY1bjNUR1B1R29kRjJNUjVxbWxiRGZJZzN5Ymsw?=
 =?utf-8?Q?ZuS0Vc412Oay93xlC3/N4zX/C?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c3c8a6b-35d3-4b08-9798-08dccd529bf7
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2024 02:29:46.9110
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B25ATLFUhe4hL1JYnihVdzpfPzJr/TuF1Cz3KYANJzWnxTGWp/lDz8EgBgHIuElik9laZCaUZTTKeBEZ4nVdHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9231



On 4/9/24 07:27, Dan Williams wrote:
> Alexey Kardashevskiy wrote:
>> The PSP advertises the SEV-TIO support via the FEATURE_INFO command
>> support of which is advertised via SNP_PLATFORM_STATUS.
>>
>> Add FEATURE_INFO and use it to detect the TIO support in the PSP.
>> If present, enable TIO in the SNP_INIT_EX call.
>>
>> While at this, add new bits to sev_data_snp_init_ex() from SEV-SNP 1.55.
>>
>> Note that this tests the PSP firmware support but not if the feature
>> is enabled in the BIOS.
>>
>> While at this, add new sev_data_snp_shutdown_ex::x86_snp_shutdown
>>
>> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
>> ---
>>   include/linux/psp-sev.h      | 31 ++++++++-
>>   include/uapi/linux/psp-sev.h |  4 +-
>>   drivers/crypto/ccp/sev-dev.c | 73 ++++++++++++++++++++
>>   3 files changed, 104 insertions(+), 4 deletions(-)
> 
> Taking a peek to familiarize myself with that is required for TIO
> enabling in the PSP driver...
> 
>>
>> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
>> index 52d5ee101d3a..1d63044f66be 100644
>> --- a/include/linux/psp-sev.h
>> +++ b/include/linux/psp-sev.h
>> @@ -107,6 +107,7 @@ enum sev_cmd {
>>   	SEV_CMD_SNP_DOWNLOAD_FIRMWARE_EX = 0x0CA,
>>   	SEV_CMD_SNP_COMMIT		= 0x0CB,
>>   	SEV_CMD_SNP_VLEK_LOAD		= 0x0CD,
>> +	SEV_CMD_SNP_FEATURE_INFO	= 0x0CE,
>>   
>>   	SEV_CMD_MAX,
>>   };
>> @@ -584,6 +585,25 @@ struct sev_data_snp_addr {
>>   	u64 address;				/* In/Out */
>>   } __packed;
>>   
>> +/**
>> + * struct sev_data_snp_feature_info - SEV_CMD_SNP_FEATURE_INFO command params
>> + *
>> + * @len: length of this struct
>> + * @ecx_in: subfunction index of CPUID Fn8000_0024
>> + * @feature_info_paddr: physical address of a page with sev_snp_feature_info
>> + */
>> +#define SNP_FEATURE_FN8000_0024_EBX_X00_SEVTIO	1
>> +
>> +struct sev_snp_feature_info {
>> +	u32 eax, ebx, ecx, edx;			/* Out */
>> +} __packed;
>> +
>> +struct sev_data_snp_feature_info {
>> +	u32 length;				/* In */
>> +	u32 ecx_in;				/* In */
>> +	u64 feature_info_paddr;			/* In */
>> +} __packed;
> 
> Why use CPU register names in C structures? I would hope the spec
> renames these parameters to something meaninful?

This mimics the CPUID instruction and (my guess) x86 people are used to 
"CPUID's ECX" == "Subfunction index". The spec (the one I mention below) 
calls it precisely "ECX_IN".


>> +
>>   /**
>>    * struct sev_data_snp_launch_start - SNP_LAUNCH_START command params
>>    *
>> @@ -745,10 +765,14 @@ struct sev_data_snp_guest_request {
> 
> Would be nice to have direct pointer to the spec and spec chapter
> documented for these command structure fields.

For every command? Seems overkill. Any good example?

Although the file could have mentioned in the header that SNP_xxx are 
from "SEV Secure Nested Paging Firmware ABI Specification" which google 
easily finds, and search on that pdf for "SNP_INIT_EX" finds the 
structure layout. Using the exact chapter numbers/titles means they 
cannot change, or someone has to track the changes.

> 
>>   struct sev_data_snp_init_ex {
>>   	u32 init_rmp:1;
>>   	u32 list_paddr_en:1;
>> -	u32 rsvd:30;
>> +	u32 rapl_dis:1;
>> +	u32 ciphertext_hiding_en:1;
>> +	u32 tio_en:1;
>> +	u32 rsvd:27;
>>   	u32 rsvd1;
>>   	u64 list_paddr;
>> -	u8  rsvd2[48];
>> +	u16 max_snp_asid;
>> +	u8  rsvd2[46];
>>   } __packed;
>>   
>>   /**
>> @@ -787,7 +811,8 @@ struct sev_data_range_list {
>>   struct sev_data_snp_shutdown_ex {
>>   	u32 len;
>>   	u32 iommu_snp_shutdown:1;
>> -	u32 rsvd1:31;
>> +	u32 x86_snp_shutdown:1;
>> +	u32 rsvd1:30;
>>   } __packed;
>>   
>>   /**
> [..]
>> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
>> index f6eafde584d9..a49fe54b8dd8 100644
>> --- a/drivers/crypto/ccp/sev-dev.c
>> +++ b/drivers/crypto/ccp/sev-dev.c
>> @@ -223,6 +223,7 @@ static int sev_cmd_buffer_len(int cmd)
>>   	case SEV_CMD_SNP_GUEST_REQUEST:		return sizeof(struct sev_data_snp_guest_request);
>>   	case SEV_CMD_SNP_CONFIG:		return sizeof(struct sev_user_data_snp_config);
>>   	case SEV_CMD_SNP_COMMIT:		return sizeof(struct sev_data_snp_commit);
>> +	case SEV_CMD_SNP_FEATURE_INFO:		return sizeof(struct sev_data_snp_feature_info);
>>   	default:				return 0;
>>   	}
>>   
>> @@ -1125,6 +1126,77 @@ static int snp_platform_status_locked(struct sev_device *sev,
>>   	return ret;
>>   }
>>   
>> +static int snp_feature_info_locked(struct sev_device *sev, u32 ecx,
>> +				   struct sev_snp_feature_info *fi, int *psp_ret)
>> +{
>> +	struct sev_data_snp_feature_info buf = {
>> +		.length = sizeof(buf),
>> +		.ecx_in = ecx,
>> +	};
>> +	struct page *status_page;
>> +	void *data;
>> +	int ret;
>> +
>> +	status_page = alloc_page(GFP_KERNEL_ACCOUNT);
>> +	if (!status_page)
>> +		return -ENOMEM;
>> +
>> +	data = page_address(status_page);
>> +
>> +	if (sev->snp_initialized && rmp_mark_pages_firmware(__pa(data), 1, true)) {
>> +		ret = -EFAULT;
>> +		goto cleanup;
> 
> Jonathan already mentioned this, but "goto cleanup" is so 2022.

This requires DEFINE_FREE() which yet another place to look at. When I 
Then, no_free_ptr() just hurts to read (cold breath of c++). It is not 
needed here but unavoidably will be in other places when I start using 
__free(kfree). But alright, I'll switch.

> 
>> +	}
>> +
>> +	buf.feature_info_paddr = __psp_pa(data);
>> +	ret = __sev_do_cmd_locked(SEV_CMD_SNP_FEATURE_INFO, &buf, psp_ret);
>> +
>> +	if (sev->snp_initialized && snp_reclaim_pages(__pa(data), 1, true))
>> +		ret = -EFAULT;
>> +
>> +	if (!ret)
>> +		memcpy(fi, data, sizeof(*fi));
>> +
>> +cleanup:
>> +	__free_pages(status_page, 0);
>> +	return ret;
>> +}
>> +
>> +static int snp_get_feature_info(struct sev_device *sev, u32 ecx, struct sev_snp_feature_info *fi)
> 
> Why not make this bool...
> 
>> +{
>> +	struct sev_user_data_snp_status status = { 0 };
>> +	int psp_ret = 0, ret;
>> +
>> +	ret = snp_platform_status_locked(sev, &status, &psp_ret);
>> +	if (ret)
>> +		return ret;
>> +	if (ret != SEV_RET_SUCCESS)
>> +		return -EFAULT;
>> +	if (!status.feature_info)
>> +		return -ENOENT;
>> +
>> +	ret = snp_feature_info_locked(sev, ecx, fi, &psp_ret);
>> +	if (ret)
>> +		return ret;
>> +	if (ret != SEV_RET_SUCCESS)
>> +		return -EFAULT;
>> +
>> +	return 0;
>> +}
>> +
>> +static bool sev_tio_present(struct sev_device *sev)
>> +{
>> +	struct sev_snp_feature_info fi = { 0 };
>> +	bool present;
>> +
>> +	if (snp_get_feature_info(sev, 0, &fi))
> 
> ...since the caller does not care?


sev_tio_present() does not but other users of snp_get_feature_info() 
(one is coming sooner that TIO) might, WIP.


>> +		return false;
>> +
>> +	present = (fi.ebx & SNP_FEATURE_FN8000_0024_EBX_X00_SEVTIO) != 0;
>> +	dev_info(sev->dev, "SEV-TIO support is %s\n", present ? "present" : "not present");
>> +	return present;
>> +}
>> +
>>   static int __sev_snp_init_locked(int *error)
>>   {
>>   	struct psp_device *psp = psp_master;
>> @@ -1189,6 +1261,7 @@ static int __sev_snp_init_locked(int *error)
>>   		data.init_rmp = 1;
>>   		data.list_paddr_en = 1;
>>   		data.list_paddr = __psp_pa(snp_range_list);
>> +		data.tio_en = sev_tio_present(sev);
> 
> Where does this get saved for follow-on code to consume that TIO is
> active?

Oh. It is not saved, whether TIO is actually active is determined by the 
result of calling PSP's TIO_STATUS (which I should skip if tio_en == 
false in the first place). Thanks,


-- 
Alexey


