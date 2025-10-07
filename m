Return-Path: <kvm+bounces-59591-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DE430BC2436
	for <lists+kvm@lfdr.de>; Tue, 07 Oct 2025 19:36:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 87C9B1887C5A
	for <lists+kvm@lfdr.de>; Tue,  7 Oct 2025 17:37:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3F332DAFCA;
	Tue,  7 Oct 2025 17:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="WPdzXwhb"
X-Original-To: kvm@vger.kernel.org
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010028.outbound.protection.outlook.com [40.93.198.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C4AE2E7F3A;
	Tue,  7 Oct 2025 17:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759858589; cv=fail; b=dLEjIghFL2HePckJAq9lk8TTUVHDxHBgggr9K8BZm470z/bnOW7TK25LpR4QS/pu+SddEm7xomtf9OLpUZmtVvuQsUrsi1KBOj257ZJCe58N1m8oSoaXPIaiScKZhJa1M7THUMKoc0sPvLAseh5wyjF9LVaYVDHXgs4Wz0QC2mo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759858589; c=relaxed/simple;
	bh=cYxgu4Yf/+wHSnyrCEMRAPV5Ws7TvQNwEBWoRIgUE9Q=;
	h=Message-ID:Date:From:Subject:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=eMQTkahbeXtVj/HQi6/Ke29msrNoELvbOUImUdTE+JQG4lPTJ6OiOLkOCC4QipWxMFXIgCXZg472ZmdP/5HNWxyjS7xA7EwHQJeO2woE1RUOSrYs57lBoL7lp31ZIMIz02vYt6ReUM9lcLbKmBGvBAsi5gtlaZ69wUpLzNa0G0U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=WPdzXwhb; arc=fail smtp.client-ip=40.93.198.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FTp0XG40GtcWrfJE5fOMayKFGGl5SHbV1BVjbb2wWo/K0uB/K01i5F3IgyJ9sJmQiZPuyugKWCtO2ukCdCZ/gK/GXT8m3/XT7pIIbM8l0LJZIxTJs3H5LyUmdUsZzyMxv9eZbd/yWIxmZFAc2rHLQ8Olw5Pvv5t1CAU3xnRtIIGvnbYeARHqt/5hJU5lAXNOFxErKc0kYSXyCi7K2XPdw7yuYgCifFAlkCuGVqAsIqyxViPHl2Uscrl1etfedlrF+FcZNNIPPliBlvVxLvyv6UAkrZX944UVZO4XtA1T+HlMFjb8ZTA0dD3QMNGy6sCnlR3w1urvvFD4ymJBC4a0ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EoDkR6ZI891IlAD8ZvK8DXxlMi2Hb12kVVB8wtM005w=;
 b=GGarrv7TNM4BF+0gW4EVK8R/hn2S+SV7C+66757zFThSoz7dPU0k4QEdldl0d4zxL7hoaeRLTIDpQOwbqfb5GHYwBjVnl5H3pvpCv+JsWP5IG9SYBVZRCRi+lVMjfmHVVA7wCZGKoz2k3Jn5p/hyq/ck3wRmHPf6i0zxWz6HYFEmcI+IthXc2KfTQvQa9qT6VyUyqe/r6dLEA0JPA3ul75528X6z3Dt5jIXa0H/XkJNaIVlnbQbCbBCpnYzXb2ZkMzAdbc1ojEFNMjx/MKGps+wNFZyHM53fRW3TJUa3d6EUDTc3htNczcg/U0xOWArvxRUoXz1p/OUnh25c+g8Okw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EoDkR6ZI891IlAD8ZvK8DXxlMi2Hb12kVVB8wtM005w=;
 b=WPdzXwhbeKhLUq9an2hsf1RZtk5ulrWBMxm761uKxvGQGGE8821oZaYLfPRZHEk2Bm/FUII9oAHNcTexinYN0IEbVh72M/UxdrH8RQFKLvwnKhMa57PxZMrIMXXdcyaLvPc+XvdDigocsWycn6Kda1u45nVroCcN5dgv8kGw97s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS5PPFA3734E4BA.namprd12.prod.outlook.com
 (2603:10b6:f:fc00::65c) by BN7PPF0D942FA9A.namprd12.prod.outlook.com
 (2603:10b6:40f:fc02::6c7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.13; Tue, 7 Oct
 2025 17:36:21 +0000
Received: from DS5PPFA3734E4BA.namprd12.prod.outlook.com
 ([fe80::1370:cd3b:4c30:5a57]) by DS5PPFA3734E4BA.namprd12.prod.outlook.com
 ([fe80::1370:cd3b:4c30:5a57%7]) with mapi id 15.20.9115.020; Tue, 7 Oct 2025
 17:36:20 +0000
Message-ID: <0cd2c8ac-8dee-4280-b726-af0119baa4a1@amd.com>
Date: Tue, 7 Oct 2025 12:36:18 -0500
User-Agent: Mozilla Thunderbird
From: Babu Moger <bmoger@amd.com>
Subject: Re: [PATCH] fs/resctrl: Fix MBM events being unconditionally enabled
 in mbm_event mode
To: Reinette Chatre <reinette.chatre@intel.com>, babu.moger@amd.com,
 tony.luck@intel.com, Dave.Martin@arm.com, james.morse@arm.com,
 dave.hansen@linux.intel.com, bp@alien8.de
Cc: kas@kernel.org, rick.p.edgecombe@intel.com, linux-kernel@vger.kernel.org,
 x86@kernel.org, linux-coco@lists.linux.dev, kvm@vger.kernel.org
References: <6082147693739c4514e4a650a62f805956331d51.1759263540.git.babu.moger@amd.com>
 <a8f30dba-8319-4ce4-918c-288934be456e@intel.com>
 <b86dca12-bccc-46b1-8466-998357deae69@amd.com>
 <2cdc5b52-a00c-4772-8221-8d98b787722a@intel.com>
Content-Language: en-US
In-Reply-To: <2cdc5b52-a00c-4772-8221-8d98b787722a@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0041.namprd04.prod.outlook.com
 (2603:10b6:806:120::16) To DS5PPFA3734E4BA.namprd12.prod.outlook.com
 (2603:10b6:f:fc00::65c)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS5PPFA3734E4BA:EE_|BN7PPF0D942FA9A:EE_
X-MS-Office365-Filtering-Correlation-Id: 6993a87b-86ac-4aa3-b463-08de05c8073e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VElHbWZYMWcwSklzQ1BjVEd3UjJ1Wm1jN05GRzByZG5XMWowcmZhZmFBRHds?=
 =?utf-8?B?MXp5dHVPNmtoZ0pqVWh2c25Jb3dJemVIREd1amhwOFBPekRFRWNTVUZidG1I?=
 =?utf-8?B?R2NITXVDYTlDc1MxMWxzSGNlNzJWZEUxMGx3TkRRUkROY1laTWFUQ1JjYmZk?=
 =?utf-8?B?alMrVzNRcTRnZkFXSkx0d3lXZDVCSktYRHZLZ0MxRmxwSUt3S3RKOWJkYVJ6?=
 =?utf-8?B?TjhYWTViSG5hbC9COFpoQzU0TkdvQU5sTTM5cU0rQ2FGYzFITjdYaW9HYzZE?=
 =?utf-8?B?NEJKWnJBQ0tWdXdFbkduZEloZHg2aExXL2RmSmVUYUNSMzZUVGdiU2VxWEhp?=
 =?utf-8?B?cmp3cGE1Qk8wUWZkaVI2UUlBL3JuRGFydm5HS2I4NmVENmt2ZVAvZWtLQzZ3?=
 =?utf-8?B?eXdQKzdFMjIxQXhHd0t5bzVyREp0alVJazJJTEpnbkxhQXdYU1N3N0FTNWFI?=
 =?utf-8?B?Z0ZQV3FlOUY1a1A2Y1JZbEdxcmZrbXJzcktkbms1OGxvME5qYVdHZnNNQmdt?=
 =?utf-8?B?Ry9ybFA3cEtyNW0zeE5TakZaSWZnYUcyTlFUMG1ONFZDQzQyb1NmbzFEdFJQ?=
 =?utf-8?B?SEZKVTJ5eGduTEpmV1k4QUtYNkxFclZiQ01rcmV4YjdzVGtjb25BTzZod1FP?=
 =?utf-8?B?VU5OcXVtWDhBV0dQZHY3MVlFRHEwK2swRGJneWd1NmpjeXB4OVlnL0lXOUtT?=
 =?utf-8?B?K0kzV21BVDhvRUROV2JaeTBqd3ZLZ0g4SGsvd2pDeU5NZ2l4OEVONXA1YzVG?=
 =?utf-8?B?Y2dRRytYVjRBNVNQVzRmWXFlOVBSQVZNenh6MGhjeUthV1VxdGhEQ3ZhNnBp?=
 =?utf-8?B?WnB1TkdMK0o2dUxCQVJVUmJBOWZ3MDJLWWp5Wmxad0Y0czM1aDFIN3R1SHor?=
 =?utf-8?B?eUZ0MUYyRU5ycksveTg0L0RUenArSkl3K0t4dHFtNWZVRUJEbm1lQStXaVRr?=
 =?utf-8?B?bC9Oa2JBekNUSEVCUWlUbGxnV0dSeVYzd3dHc3pQUUFRNUZkSklFRkJDV2xw?=
 =?utf-8?B?UzNhN0RTTmo4RFNITU9UNVJuK21vTzE3ckY3dEZPczdSL2hCOUV4dFBpbUwz?=
 =?utf-8?B?Ni8yb1F6ellGTHBROWRVVnAvUlIwN3JaN2VXNGlRZTlXYkFja0hDUjZjdW1T?=
 =?utf-8?B?K0hqWHYyNGJuSjA5TkFvbjFOVWpqWnBWN0F0bEpVSFpybGlqb2ROc3RqWmxB?=
 =?utf-8?B?QlVQcFJwdkdTZU81dnd2TzdOd2dIR1pBNG9GbE1kOVZIY1hvdkhaODJFNS9x?=
 =?utf-8?B?bE4vWGZPSmFQbmlGdk9kdWN1SkNWSlRSQW1KMFlrYUF4WjNMaW5vRTJ4TkhU?=
 =?utf-8?B?RjRVamZtNXArNnlwSGRmV29iZnlEcEtsSFAzR3ZxUCtuN2dsWjZqbGlQTzNS?=
 =?utf-8?B?bENhSVlsMkQ3SFRyZGRTSjJWVGRQSlZ2TDc5eURzaXNuenZVNmlUSjNFc2NB?=
 =?utf-8?B?TWphME9aL2x6N0dhekpNUXB1aTZ1dWE4MG5tS1dXNGc2YjhndS9mNW93S1Jq?=
 =?utf-8?B?QXJPRUVxdUV6cjVLMDA4L3BueGYzVG1nL1k0eGFyNDAwTlVhaE1NMlZ2d083?=
 =?utf-8?B?RGt2TlFCVDJ2VEIzZ0xUUXNreFZNUDBscDQyUEdtVkJ4NDFpVnBGZmpoZWtv?=
 =?utf-8?B?Z2ZOK2pSWDdmcHhPZVc3YmdHU3hneC9QVHhzbnVoQlY3QS95YUZqdVdzWlIr?=
 =?utf-8?B?RlU3bHVRS1dsVVJyTnU4bWNwSjh3Q05BWG9JdU9Xc0dwK1A3T3g5TUdGUFpl?=
 =?utf-8?B?RkVjKzlRRWI1VVFJbWtlMGxkL3krUHgzQ1NmQUJzaUMxSzZvWEE3NlhreGF3?=
 =?utf-8?B?TWdXV0N5WUJTbmZIOFJTeSs2ZDdyb2hCV3lldmYrOC9HTFpEbWxGalhhSEpV?=
 =?utf-8?B?bmZqTDVza0dYeHdoRXpxWGR6bDF2MDJXbTVqN0JSbjliVkZ5cHFvV2dTRnFG?=
 =?utf-8?Q?pLHgxeGXBrXNPsOwxmbkQGiRDNgiVanu?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS5PPFA3734E4BA.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d2hWaXlpc09pYUJpSEFLOVZlYmtNNTVjbUwyWjBHenB6NWpLVWovakFQdU5v?=
 =?utf-8?B?NDA3R29LV3NRcm5jaVBoZHhrVGJBQ0tibHJoVjZjS3dSTkhBTW5UcmJmYk1R?=
 =?utf-8?B?WXdSU1R6bnZEeXllWW1GTisya0gzSkY3c0owZnBiQytBcDdiaVhBYkhvVE9q?=
 =?utf-8?B?YVFIVm82Qm9OM25IWmlsc0lpeTRJOThDSzZmdCsyWGtnSlVwQ3BESWszM2pH?=
 =?utf-8?B?cEVPMUNFbjFPWXhLMysyRGtVWDdVM2F0SURZb3NyOUtLSFpVUCt2Ykp5NDV2?=
 =?utf-8?B?SE80WThWK3ZFU0FtWkV6dFBYVllJaHBjSDNaQVdjc2JtMS9FN3BjeS8rbWFk?=
 =?utf-8?B?ZStLd1RaeGQvZGxWQWVDSFpQVTJtZDc1WEZQbHVMcE5yeHZDZFFuRGVTMjFv?=
 =?utf-8?B?MVl2OTVxbTFZcXI0d21UWnN3K29OTitZTjROVUFublF4eU14ZCtsZTlWczlu?=
 =?utf-8?B?MVFFc0ZrZ0JDYjg4OUlyVmM1UDBCa1hWemhTMm52NXd6cVlIdDZBc2dIRW1v?=
 =?utf-8?B?RkZqU21pbGNUSEFkNVgydzkyck1uU25FbWEra291d1A1MTlZNkRWbU8zcEx2?=
 =?utf-8?B?ZWtPYjNwc1dYVDBBQXYxY2FkQ3hicDZQNUtLOXNTQTMzMWZFQkliaVVJbGlv?=
 =?utf-8?B?dFRlUXlwQXRnSnllOHdQSkc4TTNGSUhmOUVBYm11MTU2eVdVUElVOEFNNFFa?=
 =?utf-8?B?U2tqd2dKL3hKQ1RZSU1iYmJIL0pVQ2JYNEhhS3ZkYmNUbExCVmNLS2tSYUlS?=
 =?utf-8?B?YlE1bnNRVzdUam4rNDFqUThBeERHZ21CSnhGZllJckxHaWV6Qll3SVRpMjZp?=
 =?utf-8?B?WEQ2RUYxQWFNN0xGeTUrMDZRYzJuT0dJbCtwWG0ycHVka3hLOFNKZzBzNVJJ?=
 =?utf-8?B?YkQ2K1FGZkpmamhPRUlwajNuZlBkcUJVeDJKVUlFTnRpNmxnZk1kZVQ2UkdT?=
 =?utf-8?B?c0cxWUQ4Q3RwdzBZbFhTeXpZODk2ZlFKTEdLaCtteEpZcGtqQ3RBU2Y2QmVT?=
 =?utf-8?B?a1lmY3dqT2ZlbmIvT3BySU1vR0wrVk1TcXdmdkhMejBCSFBOd3V6OWdJWHUy?=
 =?utf-8?B?TW1MQnJZV1J6VEpEaGlxRmlXSlA4MFlxVWxHR1hGQW1kYVljK1Jwb3RoMHhD?=
 =?utf-8?B?VnlhM1Q4UWd6azY1QWhEa2tseCtxNHU3YktqYStXNjh4cGhYWmZaaDdhb21B?=
 =?utf-8?B?ZWkzOUpidGYvVkhuaU41cnJjWWdSYThQWTN0ejNmTUZBWThCTVlDb1dPQVh3?=
 =?utf-8?B?ZjB6ZDNCMDNRTGR3NEJzSVJJaGNCT2pUVHBzcTVQcldnMU5yVUh2WDdPdS9r?=
 =?utf-8?B?MmRYeXpQM3NQM29sNjMzNm5aRmRxRG1RN3FpSXZjcWxrTG15MElmbTduR3BG?=
 =?utf-8?B?TXlJb0ZzYzZLMnQrS2Y4ZWo1a3JBeUxXU21NQ2xEWG54eU9wY0wvYUlMMC83?=
 =?utf-8?B?RWtRVTlmV2xrTE43Wk1DME0zYzIvcVVCSGJISDhGZnI1eFpZeWJWZ2xLZGlj?=
 =?utf-8?B?WVZXcFZteDBQQXdCVVNDOGZxaGdVN2t6VDRzQ0ZwZHRKMUlHbGhjbElxczhS?=
 =?utf-8?B?ejR1Vm5rL0JnRkdqL2F2RFNiL251Y2NuVk5TTnhZU3ZnUFQzZDVQZEtSTUFZ?=
 =?utf-8?B?a1RiYUlpZVcyYXNaOFJpZlRwNkdRL3I5VmVMTTltV1pyVW16a1FKWGFhOHpp?=
 =?utf-8?B?ZXNSWXJhMHgzNEI3S01zMTlwZ0tBOVJoK3gyU3doN201YWFlcUxEQzRDVnk4?=
 =?utf-8?B?Y0tSbm1lZ3NMMkxaOVdIa1lZMU8yd0pJeFhRZXlGUitQenc5d1czRlo2enR6?=
 =?utf-8?B?YW4xU0VDYkx2T20rbUxZYXUzUTIyVndoTlN0Rk5vckVlZExleVQrYlhsQ1dL?=
 =?utf-8?B?OHQ3dE82U1l3Uld1YW9wQ2FpUm9sUXphbkV5ZFFIbDd5MzdxNUJaS0dzNVBY?=
 =?utf-8?B?OXYzZ1hJQUpCWnhDMzdqenNrYVJFSThuc1dGRklsQ0hnM2s2dUo2N1ZVeE9B?=
 =?utf-8?B?RWFGZWJ2V2VtVmJFN2ZVbGlXeXNvK0Q2Y3A5WStldXk5TWlOd3N2Q21sZDZB?=
 =?utf-8?B?dzRyak8wT2VCbXNpWEZSOTJRVmtDUStKYXZ6UFJpeGUzdkJaM29VdDM2bWlq?=
 =?utf-8?Q?LVak=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6993a87b-86ac-4aa3-b463-08de05c8073e
X-MS-Exchange-CrossTenant-AuthSource: DS5PPFA3734E4BA.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2025 17:36:20.8199
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q5sZpQSIVOmcYTdcGAAl0Ln0ycDl5XGroUYhJhxo37xIyT7gFJSeVH8MSjoXVkP6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PPF0D942FA9A

Hi Reinette,

On 10/6/25 20:23, Reinette Chatre wrote:
> Hi Babu,
> 
> On 10/6/25 1:38 PM, Moger, Babu wrote:
>> Hi Reinette,
>>
>> On 10/6/25 12:56, Reinette Chatre wrote:
>>> Hi Babu,
>>>
>>> On 9/30/25 1:26 PM, Babu Moger wrote:
>>>> resctrl features can be enabled or disabled using boot-time kernel
>>>> parameters. To turn off the memory bandwidth events (mbmtotal and
>>>> mbmlocal), users need to pass the following parameter to the kernel:
>>>> "rdt=!mbmtotal,!mbmlocal".
>>>
>>> ah, indeed ... although, the intention behind the mbmtotal and mbmlocal kernel
>>> parameters was to connect them to the actual hardware features identified
>>> by X86_FEATURE_CQM_MBM_TOTAL and X86_FEATURE_CQM_MBM_LOCAL respectively.
>>>
>>>
>>>> Found that memory bandwidth events (mbmtotal and mbmlocal) cannot be
>>>> disabled when mbm_event mode is enabled. resctrl_mon_resource_init()
>>>> unconditionally enables these events without checking if the underlying
>>>> hardware supports them.
>>>
>>> Technically this is correct since if hardware supports ABMC then the
>>> hardware is no longer required to support X86_FEATURE_CQM_MBM_TOTAL and
>>> X86_FEATURE_CQM_MBM_LOCAL in order to provide mbm_total_bytes
>>> and mbm_local_bytes.
>>>
>>> I can see how this may be confusing to user space though ...
>>>
>>>>
>>>> Remove the unconditional enablement of MBM features in
>>>> resctrl_mon_resource_init() to fix the problem. The hardware support
>>>> verification is already done in get_rdt_mon_resources().
>>>
>>> I believe by "hardware support" you mean hardware support for
>>> X86_FEATURE_CQM_MBM_TOTAL and X86_FEATURE_CQM_MBM_LOCAL. Wouldn't a fix like
>>> this then require any system that supports ABMC to also support
>>> X86_FEATURE_CQM_MBM_TOTAL and X86_FEATURE_CQM_MBM_LOCAL to be able to
>>> support mbm_total_bytes and mbm_local_bytes?
>>
>> Yes. That is correct. Right now, ABMC and X86_FEATURE_CQM_MBM_TOTAL/
>> X86_FEATURE_CQM_MBM_LOCAL are kind of tightly coupled. We have not clearly
>> separated the that.
> 
> Are you speaking from resctrl side since from what I understand these are
> independent features from the hardware side?

It is independent from hardware side. I meant we still use legacy events 
from "default" mode.

> 
>>> This problem seems to be similar to the one solved by [1] since
>>> by supporting ABMC there is no "hardware does not support mbmtotal/mbmlocal"
>>> but instead there only needs to be a check if the feature has been disabled
>>> by command line. That is, add a rdt_is_feature_enabled() check to the
>>> existing "!resctrl_is_mon_event_enabled()" check?
>>
>> Enable or disable needs to be done at get_rdt_mon_resources(). It needs to
>> be done early in  the initialization before calling domain_add_cpu() where
>> event data structures (mbm_states aarch_mbm_states) are allocated.
> 
> Good point. My mistake to suggest the event should be enabled by
> resctrl fs.


How about adding another check in get_rdt_mon_resources()?

if (rdt_cpu_has(X86_FEATURE_CQM_MBM_TOTAL)
     || rdt_is_feature_enabled(mbmtotal)) {
                 resctrl_enable_mon_event(QOS_L3_MBM_TOTAL_EVENT_ID);
                 ret = true;
         }

I need to take Tony's patch for this.

> 
>>
>>>
>>> But wait ... I think there may be a bigger problem when considering systems
>>> that support ABMC but not X86_FEATURE_CQM_MBM_TOTAL and X86_FEATURE_CQM_MBM_LOCAL.
>>> Shouldn't resctrl prevent such a system from switching to "default"
>>> mbm_assign_mode? Otherwise resctrl will happily let such a system switch
>>> to default mode and when user attempts to read an event file resctrl will
>>> attempt to read it via MSRs that are not supported.
>>> Looks like ABMC may need something similar to CONFIG_RESCTRL_ASSIGN_FIXED
>>> to handle this case in show() while preventing user space from switching to
>>> "default" mode on write()?
>>
>> This may not be an issue right now. When X86_FEATURE_CQM_MBM_TOTAL and
>> X86_FEATURE_CQM_MBM_LOCAL are not supported then mon_data files of these
>> events are not created.
> 
> By "right now" I assume you mean the current implementation? I think your statement
> assumes that no CPUs come or go after resctrl_mon_resource_init() enables the MBM events?
> Current implementation will enable MBM events if ABMC is supported. When the
> first CPU of a domain comes online after that then resctrl will create the mon_data
> files. These files will remain if a user then switches to default mode and if
> the user then attempts to read one of these counters then I expect problems.

Yes. It will be a problem in the that case.

I am not clear on using config option you mentioned above.

What about using the check resctrl_is_mon_event_enabled() in

resctrl_mbm_assign_mode_show() and resctrl_mbm_assign_mode_write() ?

Thanks
Babu


