Return-Path: <kvm+bounces-54216-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 596C1B1D271
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 08:23:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 764765617E1
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 06:23:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EAEB21D3F0;
	Thu,  7 Aug 2025 06:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="yTETvz/H"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2040.outbound.protection.outlook.com [40.107.101.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ABC81537A7;
	Thu,  7 Aug 2025 06:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754547817; cv=fail; b=iUykf4xT8tFMn87Zdz1j4qEoWoYqaTqy4IZtk48JC+0heELf39qnddMnoxz9dADluP5TcKi85QkVHc4ZuAEekflhfIZsCaP/hdeoNXyavAE2jyWzsZ4LBROg0bM8OFn+dhphO+6IOcDoWRcoEZ/L2ZW7kFVF8FS6hmts4ly1FZI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754547817; c=relaxed/simple;
	bh=C9wOtzWujzncWUDUF2ZCPAf45F2aKdIJC+sCQnkY2tw=;
	h=Message-ID:Date:From:Subject:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=sGORPMxR+Xu2pV0+rKbzou6nhDg0/n9s/S05XnCg94gCX32hgdf0d48pE7MpS7wGyjSxubr9z8Z+5vnMHjcFm0CLHnym4lDrVNLPh8UdYfKMELGJceK2Tg8petn5mXkfQoYiZDdYHn2JD9ZoUM1jItY6zeD2LlU31ERuaRsvaAY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=yTETvz/H; arc=fail smtp.client-ip=40.107.101.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eRcO2oNMSisDLnLYOMdt9G0NXbghlSxvd4Z3yS+EcvbxxSsBbsVQYxLPbu/V9E7nc+f9Uq9BhqAEPtgpo2rVYmKz1xSEj7eCaZdUnzoGOS9LuggOEtcIjTRcLcU91A5cpYuaR1kK3RmhK4RiI9K29NrP0HKQUlvOOBaD/PBwFCuC3n9hUjuAvBIdCi32FwzHcv4UHrJW2Q3/hgDlNwaYLreojzSA/Scq/gJFZrIs3+j382ovdBZ1967NkJENZJW0VQLwdlz+cUuEKBiRhGv5k0juPE09xJVFKJwrnrw0Zf2SnFYyBxhKvRmvOfEimb0dpbgn3BYZxQ1KsVVFbXktXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6AyJBnBNN5zzHGhXTBM4/MOWf4gfzgZpOyoXFWOOZZM=;
 b=CTf+JH3kNFFmaRtXGZelZcH1aHv9Ozhg9krD9bJHz5u2yK+AeF31TEUIlrrECH28Yi/oA4SXOgHxrYHw6g+06Y6JqaISYIZF5lYqL2+wrQFv+Qe0THm6i5G7yBVMM7uXyV/F11UrfdqbNXO1c/jNnCZNO1ttwkAg6jWWej2ajVy4kLvd1j6zTOB1eKpje2UsNPi1F3yRm1V5MjCPe+4C1OTj4kx0eyWLTvqs375hPwS2JtMV7gkfSe4xq5cqqsOWc/jhndIYkPMhWMo/+LePxTjErdvsNS1qFd6QuJaMc/PJwCaHeVyBVeaI+bGGSpeUc+Acj7aNGinyqu99fu8Vcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6AyJBnBNN5zzHGhXTBM4/MOWf4gfzgZpOyoXFWOOZZM=;
 b=yTETvz/H1K/t+g+6KD8pFAQcf6qmp2hoARBRYdfGehVS1ALPiCa1fPN9SzPbIxTVMCAPveM4aStJ6avItphbf+JGDyKvyYOB0q+JGscwTSckQZ/3NRlYW/5v83rO63FjTyw18buboxIkTUdCd1V+QNV8+BWFlSqT7TcO+bUBwYc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5712.namprd12.prod.outlook.com (2603:10b6:510:1e3::13)
 by BY5PR12MB4290.namprd12.prod.outlook.com (2603:10b6:a03:20e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.15; Thu, 7 Aug
 2025 06:23:32 +0000
Received: from PH7PR12MB5712.namprd12.prod.outlook.com
 ([fe80::2efc:dc9f:3ba8:3291]) by PH7PR12MB5712.namprd12.prod.outlook.com
 ([fe80::2efc:dc9f:3ba8:3291%4]) with mapi id 15.20.9009.013; Thu, 7 Aug 2025
 06:23:32 +0000
Message-ID: <129c59a7-1715-41f4-b839-19e6a0adb9f1@amd.com>
Date: Thu, 7 Aug 2025 11:53:24 +0530
User-Agent: Mozilla Thunderbird
From: Sandipan Das <sandipan.das@amd.com>
Subject: Re: [PATCH 00/18] KVM: x86: Fastpath cleanups and PMU prep work
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Xin Li
 <xin@zytor.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>
References: <20250805190526.1453366-1-seanjc@google.com>
Content-Language: en-US
In-Reply-To: <20250805190526.1453366-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BMXP287CA0018.INDP287.PROD.OUTLOOK.COM
 (2603:1096:b00:2c::34) To PH7PR12MB5712.namprd12.prod.outlook.com
 (2603:10b6:510:1e3::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5712:EE_|BY5PR12MB4290:EE_
X-MS-Office365-Filtering-Correlation-Id: 549b5a93-af8a-4957-7c53-08ddd57aee93
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SVhSZ3dXZ0drMWVNRE5YSFVWS01xUEpoa2JlWFB6RzBJU2loN2Exb2R0WEJL?=
 =?utf-8?B?eEgvTmh6WDNlTjZIMGk0R0drTjNOQnkwV3F5aC8vTVJjWmZpQ0wzTEprRW1D?=
 =?utf-8?B?WVd6SENHMDdmWGVrb2VJVWVNTlZWMU9zRWhGeStUYkkwempCRURDR3RnNVJX?=
 =?utf-8?B?dE1IUlpsNnZaUDNXc1o2cmp6SkQxNVFGSWhGNHl6ZTVBb1dGOTFtTXBvM3Nt?=
 =?utf-8?B?Qmw3dCt0MXFpL1FjMjBCTmV3WllHM1Y2YkgwYXY0NGxJWlBxM2o1YmJzZm8w?=
 =?utf-8?B?VFVKZExhQTk5WjlpL0ZvQmxwTWkxOWdaUGpPeDFmdFlycUZiL0ZNdGVZeGhP?=
 =?utf-8?B?N0V0a1daNEgwUjBhd3hNWXh2NnhkUmFKNmI5aGhTcW9HMUwzd0xRUE0rRE9J?=
 =?utf-8?B?dlFRQXhzLzhSWnZoOWRZMzVnOTlabXVIcERrUDdsNnJkVDJSNHFBcXpMMUFO?=
 =?utf-8?B?UFpreEl4ZklhaWtpbmNPaTl5VkV0d3BiclYwMGlraVlDOGRWSUF1dFVrdU8r?=
 =?utf-8?B?eldIMzMxaTBJeENJL1BwalFrTFRzU2hTaXlSUStwQXZOOEpueE1yVHRCbmxM?=
 =?utf-8?B?SnlTcHlzR2tYSndZbSt5NjRvM053TWhZb0J2ek5kdks3Q2VDWU9xZnVFT3gw?=
 =?utf-8?B?dHNGc3UzMm9NbC9ZeFBLbzBENUcvM25zUElaWnoxcE5DaWQ1RmdnVDFZRi9k?=
 =?utf-8?B?NnVDWkpsOWFyTWpDOGhMSmVpN1lDcFg1THcwY1pwWElodEIzUnFHRlZsUU1C?=
 =?utf-8?B?Mk9UaEV5NnJWNmt3OFh4eUhEN3g0THczRGZUdi9KMm1CTFZJekN2UndTSHZo?=
 =?utf-8?B?dGphK05CekVxbVdVdHhXMzFJSnhOT0dzVzZJbGRkbjRTTFczOWdwNHpFU0Zu?=
 =?utf-8?B?OXE3OWF0N2ROYXlacmdmVXQxMUozZEVSNGgyR3hnZUZLTVBWck1NQUlXOE8z?=
 =?utf-8?B?bWgybFQ5eER2cndsd0Q1T3hGU3VQWWRYM25mRFNGRlp6Wk9tZTgwbG91T2dK?=
 =?utf-8?B?aUZ3RmMxTmZGb3hNMDdNVi9HTHlyemhDazA0VnpDTjdnUmdKOFJDZTNuQ2U4?=
 =?utf-8?B?YTFDcmxwOTJ5QXhlNVBUa0swYmlMS2dXUlUxWDBjNS9MT016U2lXdXMrd0N0?=
 =?utf-8?B?VisyV1U3Zng4bDhabmUrWmtrYlFXUlBTWjVuby9oZjhoSWdtdDZqOHcxa21q?=
 =?utf-8?B?L29ZYlhpWC8xdnJqc2tZSTBLNXFmM0lmWHhFNElvMGJ0Vzdlajh3Kyt2b3V1?=
 =?utf-8?B?WFFSV1BJS0R5UTVqZmJUb2J6KzRPeDJIVGxUUVRlbTh6M3ptdDh3NG1UZy9D?=
 =?utf-8?B?NGlJaGxDOG1TMG5LckNna3h3bEZoUmx1ZUJWSkx2ZDd5YWtIS05tWGJnRUlJ?=
 =?utf-8?B?NG56Q1ZWUGE5c3VqcytlS3JmNkY0bkF4aDNnZzFrQmVVeU1JV0tpQ0FiMmx5?=
 =?utf-8?B?Q1FoYmE1UkVXZnd0S2hPZVZNcU9nT2RxYWRKK0xidDEzSHB1aUR2VWttc2FN?=
 =?utf-8?B?eDFjQkFOWEFPcTlqb1MvS0huWGJvRXIzTGgxeTV1ZzdkclJ5OGFPdHJxdEVH?=
 =?utf-8?B?LzVlM0UveW9nT2ZmNWh6QWlrNXhWZHMzUDgrMFNiUTRwaDlnZXFRSzE1VUpP?=
 =?utf-8?B?YW1qSUZJMzdaemxUQ3lTQVNndnBXbExOdVpPSU54TE1ERks4QkV1c3ZoOHZR?=
 =?utf-8?B?WGZ0NzFCV3pFbXRVS0FnenExRGx4T0gxbHFHUWZxdDhjcDM5M0lCNW0xdXVr?=
 =?utf-8?B?M2pKeFpqRE9uVURCb2pzKzZtcjhCa3Vzb2tRVWI1eVYvVkkzNEJhZHFWOVNB?=
 =?utf-8?B?WEtZZW9sMThEb0lDdlV5QzJqMm5JYkFGK1oyUEFMbHhINTJoVTQxWUJ2V204?=
 =?utf-8?B?djd2cXpzYkZ5eFJyS0xIdW92UHBXSUQzUmQzVDhOYUJadzduc2JZRXQxRmF5?=
 =?utf-8?Q?v/EdKkHSJ+Q=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5712.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UGFtZGJMckVOaHMvU2Jud2NYZGFleGFPVnRaYlZZY0s5R3AwMW0xcVdtTlQ0?=
 =?utf-8?B?RklHZzMyek9GUEpkdWpLYkdmSS9JRDh6UEpoOW1YQmhJOHpGSmhibFBrdExr?=
 =?utf-8?B?eEY3QWRXMzdMajJoc2xyYStLUlRuME5vRit4bTcrajhxY2tVL0huN1NnN0Rj?=
 =?utf-8?B?ZWpHQlB2WmhJWXU5MVlvZGJVT0lyVnpoWWhPQ0Jqa3F1c1ZheWVCM0c5OExI?=
 =?utf-8?B?aXhocUxxeXNrUU5qc0JEcFNwZmE4ZTh6ZHl2Skc2N3k2ZW5SREY0VnhPTjUz?=
 =?utf-8?B?Wk9qbGRlb0FpK3Y0a0V1UHZBeGkxbmV0ZExzRCtKVDhmUFFOZitwOVM0NGlz?=
 =?utf-8?B?TE9TRnFtZStZYzVScmlWRWlSUTJOUmRJZnFTRmdIblBIRW9VcnZ4eFk1NW9Q?=
 =?utf-8?B?SVJlMUthaExBMERCQ2h4ejZqSkZJN1NGRWxhUEFlVE5tTjV1dTl6UEtQcmpT?=
 =?utf-8?B?c2hBZzJiWkhMYkhJZkM3YzFJYVhueGF1T1RJakZNOEp1bXlwQk8ydGJ4RUpT?=
 =?utf-8?B?N2JjR091WFpFMGh2QkpndmNyQXk1THR3TmxnaHpkWnZjZVdsc3dTQjBQOG1F?=
 =?utf-8?B?THFPeVRNaHZEcm5qdDlzekQ0WlVMYWxZWWJPdmU4OHo3QUtheWxDOUMwVnFt?=
 =?utf-8?B?QlBNckhzWjRHZmlzaUQ4YlkyUVB5ZVVQOVBOUkk4VGV5cFRwdmhxK2lUbkpI?=
 =?utf-8?B?WUZDRE52ZXh2bnV6U09oNVI4YmVrQnBSNitXSURTdnhaMjZWdkdOVzh5eVFT?=
 =?utf-8?B?Tk0zcEpMbzZFaVBwZ1NFZi9CTUhrWVRWczRtUTMyc1h6ajJzUTJCYWR3c0I1?=
 =?utf-8?B?NWoxOWFqY0xTa0lFelU3elEwL3BqcGJnNU8yTnBPdUF5U2tMN0pjZEQvaEdO?=
 =?utf-8?B?MXNKcm83QjJPMGhRMFJ6T3l4Zld6dWZZUVd6dmY0TU9seExkai9XM0RiMFQ3?=
 =?utf-8?B?a1d2RzFuY25aQUNqOFpJZDB5YzErbnJLZ2ZKa2hGT2JmeWhpZzJmQzlTYVZt?=
 =?utf-8?B?cWQ5Y1hXZ1N2bHBwTGxZYzJRdW1FTzRVRlRKdnJHeGxOSVZZeXZIQjRKdCsr?=
 =?utf-8?B?SFNtQllUaGJEb0QvVzRCSmhMdWtMcEpCRGhXSHNhbCtMcW04eDZkWGtkZzNJ?=
 =?utf-8?B?WUdzWjJUc1Z3OEFEZG53cVM4b0pBaVpBSVBkcWU0TXR3dW9SczFzeGhLRzQw?=
 =?utf-8?B?R3RadkdCdlZPQ0kvaW1vUGJHWnRGWFBpUXZSQlpaMEpJY1AwaVg0TkRsRity?=
 =?utf-8?B?aFQ5MjhhWm5idVRob2hRVGVMVXZXQkx4OWNrR3FrejQ3UE8wbWVMbnZ3WGIv?=
 =?utf-8?B?MDBEdWhzNm9IMG0rNjNQQ2lTRjJEY2xUM0luM051Z3RPeG9GaGFhZHZPZU9S?=
 =?utf-8?B?UmtiWDZucGdRYURvZW5iaFh4a2x4Z1NHQVlQNnFTYXM1WDhSdVczbk1QcU5v?=
 =?utf-8?B?dmpycW54TGJNL0czTnRhNkZDQ0oyUXViR1oxdWJ2UDdkOTM0N0JjdjMzVklO?=
 =?utf-8?B?RkZNRHhISW9tMWxxMktXeWVRUzRycDBYQ2E4Skh1ZGtsMWI5Q1pFZU5BRU1M?=
 =?utf-8?B?Y2xib3V5aUVYZktFVjNteFBVK0ZIYVJwaTZ1TWJRRnMwT3RkMTROUnEzUzQy?=
 =?utf-8?B?K0hhcSszbU0yenQvbUhqaHFlTUxKYXRielhPY1ZQbWZzYmJ3azhDcWxHTlN1?=
 =?utf-8?B?SzlqN3FjZURKcVRzeWhmZmE0VlpmWjFIcTRIc3BVWS9SbEZmVlRPQ3JDMCto?=
 =?utf-8?B?bktSZlpnaWdFZThnbkZrZ0hiQW9xMzZrYnJpc3kraUNpUjdjQkdCU21HYk44?=
 =?utf-8?B?dWVFUktqQ2dwODlLZHRPMUFiZHVtWU8waHBhV0NKNDE3T0FvK0tkdXJsc0ZC?=
 =?utf-8?B?bHczNUlPZnQ1ZWRVVUVqRWFueHZIdjdvdWlLNEN0WkEvRUwxSjZKd3ZNWEg3?=
 =?utf-8?B?N3R1eVNmOEt5ZEFkVzMzTlE3T3pyZjZSOFA2R3hxZUFnUjg4MXF3RE4xbUZH?=
 =?utf-8?B?WWMxeHdvQnIwZjRESm9mUFN6SVRxK2lzTjRRK1BENUVjdFNkNkxpenBta1VE?=
 =?utf-8?B?YXFYQlo5ZHVlUExDYm9LT1BlakZPMGFiemF3Y1RtRVJ2MjllQldvNTRrbnlY?=
 =?utf-8?Q?13cDAKLZ9vlpUW/Sez/QNH2PC?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 549b5a93-af8a-4957-7c53-08ddd57aee93
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5712.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2025 06:23:32.3696
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ekk1oRZ7G7PcHbOFiqRgRKsrBuifRQ0kLJazowwqWemKFZTV74Te3iONMIISO7vBgwcGsYDQSa3rsv4r6dzBbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4290

On 06-08-2025 00:35, Sean Christopherson wrote:
> This is a prep series for the mediated PMU, and for Xin's series to add
> support for the immediate forms of RDMSR and WRMSRNS (I'll post a v3 of
> that series on top of this).
> 
> The first half cleans up a variety of warts and flaws in the VM-Exit fastpath
> handlers.  The second half cleans up the PMU code related to "triggering"
> instruction retired and branches retired events.  The end goal of the two
> halves (other than general cleanup) is to be able bail from the fastpath when
> using the mediated PMU and the guest is counting instructions retired, with
> minimal overhead, e.g. without having to acquire SRCU.
> 
> Because the mediated PMU context switches PMU state _outside_ of the fastpath,
> the mediated PMU won't be able to increment PMCs in the fastpath, and so won't
> be able to skip emulated instructions in the fastpath if the vCPU is counting
> instructions retired.
> 
> The last patch to handle INVD in the fastpath is a bit dubious.  It works just
> fine, but it's dangerously close to "just because we can, doesn't mean we
> should" territory.  I added INVD to the fastpath before I realized that
> MSR_IA32_TSC_DEADLINE could be handled in the fastpath irrespective of the
> VMX preemption timer, i.e. on AMD CPUs.  But being able to use INVD to test
> the fastpath is still super convenient, as there are no side effects (unless
> someone ran the test on bare metal :-D), no register constraints, and no
> vCPU model requirements.  So, I kept it, because I couldn't come up with a
> good reason not to.
> 
> Sean Christopherson (18):
>   KVM: SVM: Skip fastpath emulation on VM-Exit if next RIP isn't valid
>   KVM: x86: Add kvm_icr_to_lapic_irq() helper to allow for fastpath IPIs
>   KVM: x86: Only allow "fast" IPIs in fastpath WRMSR(X2APIC_ICR) handler
>   KVM: x86: Drop semi-arbitrary restrictions on IPI type in fastpath
>   KVM: x86: Unconditionally handle MSR_IA32_TSC_DEADLINE in fastpath
>     exits
>   KVM: x86: Acquire SRCU in WRMSR fastpath iff instruction needs to be
>     skipped
>   KVM: x86: Unconditionally grab data from EDX:EAX in WRMSR fastpath
>   KVM: x86: Fold WRMSR fastpath helpers into the main handler
>   KVM: x86/pmu: Move kvm_init_pmu_capability() to pmu.c
>   KVM: x86/pmu: Add wrappers for counting emulated instructions/branches
>   KVM: x86/pmu: Calculate set of to-be-emulated PMCs at time of WRMSRs
>   KVM: x86/pmu: Rename pmc_speculative_in_use() to
>     pmc_is_locally_enabled()
>   KVM: x86/pmu: Open code pmc_event_is_allowed() in its callers
>   KVM: x86/pmu: Drop redundant check on PMC being globally enabled for
>     emulation
>   KVM: x86/pmu: Drop redundant check on PMC being locally enabled for
>     emulation
>   KVM: x86/pmu: Rename check_pmu_event_filter() to
>     pmc_is_event_allowed()
>   KVM: x86: Push acquisition of SRCU in fastpath into
>     kvm_pmu_trigger_event()
>   KVM: x86: Add a fastpath handler for INVD
> 
>  arch/x86/include/asm/kvm_host.h |   3 +
>  arch/x86/kvm/lapic.c            |  59 ++++++++----
>  arch/x86/kvm/lapic.h            |   3 +-
>  arch/x86/kvm/pmu.c              | 155 +++++++++++++++++++++++++-------
>  arch/x86/kvm/pmu.h              |  60 ++-----------
>  arch/x86/kvm/svm/svm.c          |  14 ++-
>  arch/x86/kvm/vmx/nested.c       |   2 +-
>  arch/x86/kvm/vmx/pmu_intel.c    |   2 +-
>  arch/x86/kvm/vmx/vmx.c          |   2 +
>  arch/x86/kvm/x86.c              |  85 +++++-------------
>  arch/x86/kvm/x86.h              |   1 +
>  11 files changed, 218 insertions(+), 168 deletions(-)
> 
> 
> base-commit: 196d9e72c4b0bd68b74a4ec7f52d248f37d0f030

No issues observed with KVM Unit Tests on recent AMD platforms (Milan, Genoa and Turin).

