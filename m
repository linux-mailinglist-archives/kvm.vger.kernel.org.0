Return-Path: <kvm+bounces-31292-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 426129C21C7
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 17:15:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BC48F1F234B3
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 16:15:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AEE312EBE7;
	Fri,  8 Nov 2024 16:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="jq1U1PGt"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2070.outbound.protection.outlook.com [40.107.244.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C5C0142E7C;
	Fri,  8 Nov 2024 16:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731082486; cv=fail; b=OtGK9m/LJgU1zfqLLOjo5P1ATDAhuhqZcL6u8xAaJY6TdcOYYCxT0Nt/U9lLBZPNmtJvZSOaZwM7/gq9QF6NjZj/GrqfQF89Y2RFlRF0FVXwLy4W8KGPYhokliDGyV2lnSl9vHcbNI3Q08s90BcLqN+u7pKFJwOvQfF366iUA4Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731082486; c=relaxed/simple;
	bh=mpoEJJ4NzTVf1WoIBNoWGlVSY9ExnJlX9UEocPJM4/4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=jHP2XY/yYYfK4x1huF3WDB/GTOCKHOTQog8FNPyFTjYmW/wcKFZuJiU9ZC6pXJLGqJ/0Ja3DLMdpx2Ny/yhUss07mhFJp5GnOWLJdxHHoLw622uESm7h/rQLFs6lQI6T2t+xlnXajpeVqSZnGo6nlzdTizVS/UFPsWE5nlO8E6A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=jq1U1PGt; arc=fail smtp.client-ip=40.107.244.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kUc5kJpJUOsBL9peAoBtWe0kSeqU4d47aReUYudmnnK6jvJX1D0VCP9ygmmDOsWkeVIBH9owwtYhCm0Z9j0if8cBOMHWveltQM7zScEtQi2kIZNMsNMMRC0rv6Kd3TCgcaG1QhlN2vLQe7Zq6CFMXVOOmQneqejdBtNG6jRsfCABswVOYYPgG/935e2xntTjqnFxs+h9ePvmfyddTsy17p6rLEkOJ31THEmDxB+5toapQ/helToNjs/AUd5XAm8Tt7rzIbEpDAaukcPsvbETwYND0Krv0v/Xiul6r3rIGfPShKSumKFvqMsTILE+qnkDgoic4UuZAA4wrUlbDsYYTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kESBHnebdLupsf/GLPtTkMd/HM9+o1DlaEd8o4Lai3w=;
 b=RrfIPtLoR/XtRbKuF38GU72YJEeeAMVFt/h+l/rOacpaprp7S1njlIIaE26R+oop+d8naCQHUywEaCRyNUhYgVWLEwOlWlbNHIbddvjY0T2dUpl4LsmdhDpFQccDn72j5tFAc/c/OTZcltIMNqwDKI7uQhHsGsbPyOm627i32umGNkgyHT3g/bbV70RuzOmmV5XAu2X6FSDZWd+dkTausVcQ0sD4xQWJHUfCi22LJOUFNLnbskn8iQBtihyI8Sd1hJSsffXVOOEEgV+STDtisCmZdJOS11pIb4Vq8SUPR98MFFirh99eBNaQpjS56ZA24jUvh/ObaGfBXL+T+d/F3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kESBHnebdLupsf/GLPtTkMd/HM9+o1DlaEd8o4Lai3w=;
 b=jq1U1PGt375sMujkZTn0rGKdozecy2pErXMICTRC2gT6cDzNFvc1Mhocg8e1k0hRsiz5d1Jk9Q6k8D1D9Pc6mj5nGrIp8E4cXQv/itPAniN5Qw+V3zYQL2U5jIlKDc9K+ahhezFfZ68ffR5GfpmLg0kYrT9Z3hfO95icer8uvCw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CY5PR12MB6599.namprd12.prod.outlook.com (2603:10b6:930:41::11)
 by CH3PR12MB8284.namprd12.prod.outlook.com (2603:10b6:610:12e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.20; Fri, 8 Nov
 2024 16:14:40 +0000
Received: from CY5PR12MB6599.namprd12.prod.outlook.com
 ([fe80::e369:4d69:ab4:1ba0]) by CY5PR12MB6599.namprd12.prod.outlook.com
 ([fe80::e369:4d69:ab4:1ba0%5]) with mapi id 15.20.8114.028; Fri, 8 Nov 2024
 16:14:39 +0000
Message-ID: <42e356ee-5f8e-40e9-8907-d41c5fe162f5@amd.com>
Date: Fri, 8 Nov 2024 21:44:28 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 03/14] x86/apic: Populate .read()/.write() callbacks of
 Secure AVIC driver
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
 dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com, nikunj@amd.com,
 Santosh.Shukla@amd.com, Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com,
 David.Kaplan@amd.com, x86@kernel.org, hpa@zytor.com, peterz@infradead.org,
 seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org
References: <20240913113705.419146-1-Neeraj.Upadhyay@amd.com>
 <20240913113705.419146-4-Neeraj.Upadhyay@amd.com>
 <20241106181655.GYZyuyl0zDTTmlMKzz@fat_crate.local>
 <72878fd9-6b04-4336-a409-8118c4306171@amd.com>
 <20241107142856.GBZyzOqHvusxcskYR1@fat_crate.local>
 <2f10fdf6-a0c7-4fa4-9180-56a3b35cc147@amd.com>
 <20241108104850.GAZy3skueAeYIgqf1W@fat_crate.local>
Content-Language: en-US
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
In-Reply-To: <20241108104850.GAZy3skueAeYIgqf1W@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BM1PR01CA0145.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:68::15) To CY5PR12MB6599.namprd12.prod.outlook.com
 (2603:10b6:930:41::11)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6599:EE_|CH3PR12MB8284:EE_
X-MS-Office365-Filtering-Correlation-Id: 75a34a26-9d93-4b24-04ca-08dd0010724c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WVhuZjNHbmxZWUpRcUpOQitsT1ZnRzBnVUlkeWVNWjV4VkpOY3J4MWlQVmVO?=
 =?utf-8?B?SjFUbnhGOUYxUjdOdHR4MlhVK3JlZjBldFlQMnNUVXdpbWpBR2Z0d1dsNmYy?=
 =?utf-8?B?VU1tdHZSOUI0OGV1aEdZTHBFQWRheEhnbkFNNkdiR0ZzMDE1cDJ3YVJUSWJY?=
 =?utf-8?B?V0VWNS8yR1QzbjRMK3pZRUVUSWI4OEdkVEs4WFY2NVEvTkZuRGcrZEIvL1Br?=
 =?utf-8?B?ckc5Z1daTzgxWTM5cEJFbi9QdlRiYmZ4VDFoVkNKcjZFT3N0VTI5cjZhMEw3?=
 =?utf-8?B?WFY4c1kzRGRGWDJuMHZSdjJybVdmSmNlY1VNMDZ3dFhDZW5jck5uWlBRTTZa?=
 =?utf-8?B?OXZjNlJmVlhJWXVUcVJ3VmtiUDBPYnI5S0FxR01sQzJNdnI3Umk5bnlLUkZO?=
 =?utf-8?B?VFdHRElDN0JCVms0aFJzZjNHY0wxL2FMa0RmS3Z3VERNbWw5dXI0ajlXNzVv?=
 =?utf-8?B?OEpzdUd2elNaSXhvS0RxcFVYYUFTcmdlZXBFOHBJV3ZoTWI0QmNDVldWanJL?=
 =?utf-8?B?OGhnN1d2cWp2MU5PcEk1Mmxrb1hQbkhOQjFtUUtoVzhVcmltdnRORzNUSTVw?=
 =?utf-8?B?RmRPTXQxRGhoZjRkY0J5UDJuVXk5TE5yc0Fyblp3UWZrRzhCZ0RLMURlLzZs?=
 =?utf-8?B?NHBSTUNLNHRFV3FFck5WbkloaDBKUzBQRGJXV2taYUxvMmJZZkVlZzJkak9X?=
 =?utf-8?B?cEthMzZ6MUgyaVBNMzVkMGd5RHcxZklSU1laSk5VT3F5ODBucTJuVzlUTnQ3?=
 =?utf-8?B?VDY2cDIrclNXbVM5U3BaUjBpNW9QWWM0Q1o3UndxWklGMjJNOXRHWHBWaDhi?=
 =?utf-8?B?NG9XT0NjRTNIUFF3czNicEZML29CdzBWWkhub09CU2FsTk4zejNUUmlmdE52?=
 =?utf-8?B?RGdGUHNoY0ZhNWJYRTlad3lrNi83OWxHL1ZZVXpoQkk3Y1hwNUJkV1NOeWp1?=
 =?utf-8?B?T3M2VGowekd5ZUFnSnZmYlFQN1VVRUt2WlMzNy9xTFhxeHZHdW1VUVJ6dGw5?=
 =?utf-8?B?bitvUW9GaDVLN3JFTlplc1VGR0ZjZjlTSDRTVmpLbVphVWdGK2ErV3BQRnR0?=
 =?utf-8?B?bk4yZExlU1FDRU1WdzR3dW5kQ3hYbU1CVEt0Wk82UFViakUzNHVJdzQ3UzlE?=
 =?utf-8?B?NlVBVjBUdGxMT3JLLzJyNmMxVmlSK3l3WEhRU0NGSGlIYmtMWVhpTlpNeTc5?=
 =?utf-8?B?SDFwU3NFYnE0UUl4a29MYjZCSUUveU8xUG9ZeXhJZ0ZEOVREQnJybFByT0Yz?=
 =?utf-8?B?MHlnLzRxVDEvV1FSeS8zMldObGJlTDhrcVVqL1pnKzNPVENBdkdLUlN6ZElM?=
 =?utf-8?B?ajM0VlJPOFczY3FKNkFBOHZXWHVCZ1VEMDBhOSt0V0xScjRBZHl6Sm5ENWNU?=
 =?utf-8?B?OE9pcFdaRk5lMHdSeDlpRFR0ZGljczkrYnZ3QUJkNUJOeUUzbWFNbG1VVTcy?=
 =?utf-8?B?V25wMmhUZkdCSWFpTVR1OUhQRmRia0xPd1NKYlpPdERVYTNNZnpRSmdCdVp2?=
 =?utf-8?B?Uy92QWJoMU5OdDltSytXbi95a2Z1ZUZQYmp6WDZMeHFVaGVqdkFWOGZnYnBz?=
 =?utf-8?B?Z0w0Q0NLRWdqN1h0MjdRMlNOc3NubmJWcE9NT1RERDhMTDRNdWZuLzlVbnJ2?=
 =?utf-8?B?Yml4d0MrRG9XRUZhVXlvdmRjMWUvbUF3MFQ1N2FVakhnNFhiK0IvU0JQYjZz?=
 =?utf-8?B?eWc0dWMxdzNsTFZkcm5OYk1pOUlSTVR6R0U2Yk10c2lMRXFXSXBpOWVOaUNn?=
 =?utf-8?Q?Doj4hWNrItJBviWXZYA34SCmP0KFn5RpI39EG6b?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6599.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TUE0VURpWjhyRlE2VlhaVTBqdlpyNXpzZTZVbVJ4U2d6QkFkVTdyOTVYWDBW?=
 =?utf-8?B?V3V3TVl1RnFEcWRYZ0xQZm9tYlpuUmE1SlRhcS9PZlVmWVFlYkx1YTBFclds?=
 =?utf-8?B?RGJhcXIrUFZVRDRENS9sTlR2M2FsZklJQUtZUUN4T3ppS0NlZWpaYUtpKzZw?=
 =?utf-8?B?WEx6TUJHTEI2Q0ZCdCtPNko4cmlLVVRDaS9FMFh4dkU2UWtBNUM2MWM0bUVr?=
 =?utf-8?B?TEc0NW9ocnVJdkFJc0VRc1NMa1JxdnpDUFNONlB2bExtY1BIZFFyRmx5aldh?=
 =?utf-8?B?ZStrVFpoNVZpQ1N0M3drUlg2WFBoRXh2QzJTT0pSQW1TSjdoVTJQR1BtcFcw?=
 =?utf-8?B?TlkrUTllL3FjeXJYYm96NVRRakp6MFhkYWpPRk15L1ZEVFhDcFdUUHFTcDAv?=
 =?utf-8?B?bEJsVUNsbzlNNHhvWTIyUC9VTnFVcW93V2lTaWpYdmp0TnNlUXVkVHhYQk1S?=
 =?utf-8?B?NVZwNC9OYnNsSVRQUzVlV1p1RlpvTGdWczNoY0Y0bUZQZWxoWWx2UVVjUnhZ?=
 =?utf-8?B?aHhuMkhXZGwzZ2NwL29pYTNzckMrTWhaajJEVmFDeHNzZmNjUWxOSTNZdGhU?=
 =?utf-8?B?QzNWVGFGbmNOS2dqdUtpZFZXY3JDajdmR0Y5aThUSXRIOS83WXN3c240Wmx0?=
 =?utf-8?B?OEd4UzZoNkZFWHdKZUZ1ZlRTanoyUWVvOERwMXVhY25IWlpGTDhsNENabVJY?=
 =?utf-8?B?YjYrOEJxNzRYUGlvQ21UUjZUemR2WEs0MVlZSVJ3NW9SV240Um11Z0pOeTUz?=
 =?utf-8?B?SngxeGtmbFVmaDlVbkJLV3NjSTRYN3oxVlRlbXQwbWZOc2FKcXQxbmN6QytW?=
 =?utf-8?B?Mjg0cTltNENQRjRuRTR3aUx6ckx0YmcvZlJLNnJmeC9yV0dURnJ0cXErWFdm?=
 =?utf-8?B?dndtUUpaQU9EYUdZR1I1VGsvRVpWUGdLYkhFTjZGU3lNdHUzeVVOQ2VmRzFW?=
 =?utf-8?B?M3lnbmhsSFFEKzVCUVFMUnNWY1p0THUyRllBYTJBZlJnZHJvUE00TTF6QnFk?=
 =?utf-8?B?SHBSTlJZMHFoRDhzbUQrSXV3SkgzaHBxRmJkMlVrdEJCQ2NXNkRxQVRVS3h1?=
 =?utf-8?B?TmdsSlNmcndhNk1RQThlUkV1YVh1ZmVneXgvc3dBbHphOFJCY2JyNmRFNjdZ?=
 =?utf-8?B?VWNpYWZOR05GU3MvaGFFcDVTa3Q4RTNyc2JoaU9qMVF4bHVic214bmMrSEVI?=
 =?utf-8?B?eXBYRFIwbDd3YVdVK09NbmxLMGFORnhodUZOK1puSDdYQkpubHRsYUsraTVJ?=
 =?utf-8?B?NGt4MGFwZzBKK25WbDZLUHBua2plVEc1ZUJlUkUySFgxOUVXS1pQcWFoM05k?=
 =?utf-8?B?QjJYZlJCekNsVHBQYmtQTjlpS1ZkbU5PUklVMk1BNE4wa1FGUUsrRUZleFV6?=
 =?utf-8?B?T1cwa1ZrOXdZTEdMMkZnRmV6aDZzNENncXRoWDJHS3g0Q2NnZXYzbk1IWTEw?=
 =?utf-8?B?dktYdmRIaUVlQTI2SHVLbkN1ejFzWnJGZ3g4T0RVanNhd2ZKV2JGWVJLcEZG?=
 =?utf-8?B?OVN3YnNUTkdVb2IwUnlCWjUwT1o3amxMa2t0aUpvS2FzUndrOENoWGZPWDNT?=
 =?utf-8?B?VGtuUldWbThFQ2FBUFlFRXNXdmg5dkExL2UxNnVUSC92Z3FUVlFNNERBS3VE?=
 =?utf-8?B?c1k1VVloNmhwNmFqai9nZzE0SDZ6MjJXQ0ZaOEJUSG9BVGNxT3lLUFg4R0pP?=
 =?utf-8?B?emJqaHZoTnJUWXZiTWRZbmxpcXZtZWFZbTJLSTZnMTg2akZjdTdUWlBzVm1T?=
 =?utf-8?B?OURPc21OUkhlcXFoOUJscmhobmxSenRCem9wQWY3T1Y2K2cxVllEcU1idTY3?=
 =?utf-8?B?am9Bdkg5VlI1Z0lUL2pIQkZQZmVSbHBtcU9va1lnMTFLZStmNVZVTnlqejhX?=
 =?utf-8?B?MFJGdjZLaXFkbXdxWFQxZjdEaDVOTkhabEc0OTVRWW80V3NUOElQaFk0TFZy?=
 =?utf-8?B?M0ZhZnNmS25zTmtSVWErb3k4UjdBQmEzWFlFMW5CVXpiWGpxSGprSmRrWk9j?=
 =?utf-8?B?ZFJpTzdYYUNoWUlYYzIwbS9ncFl1QklYb1RBdlBMNWJudG0yb3Z5QU95OUVJ?=
 =?utf-8?B?azJWdyszdTcrR0h5QjlldVpYMGpuMEVhckxFVEZOWEVadGVKQWw2azZaWVZE?=
 =?utf-8?Q?tZp88HQ7cS1Pb9LMLOyX7qZW+?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75a34a26-9d93-4b24-04ca-08dd0010724c
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6599.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2024 16:14:39.8016
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: akuu8habyzwLYPtuWr3YVwc8m9Jc/MZAQ0u64u4vsY/1AuQNgGmv686y5QcraHLQw43Pc/iFGtFCzPIX7Nn8Qw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8284



On 11/8/2024 4:18 PM, Borislav Petkov wrote:
> On Fri, Nov 08, 2024 at 02:29:03PM +0530, Neeraj Upadhyay wrote:
>> From the APIC architecture details in APM and SDM, I see these gaps are reserved
> 
> What I actually meant here is whether SAVIC enablement is going to keep adding
> more and more entries here so that it becomes practically *all* possible, each
> spelled out explicitly.
> 

Ah ok. My bad, I completely misread it and went too far.

> But I went further in your patchset and it doesn't look like it so meh, ok.
> 

Yes, the offsets layout I described was with respect to the complete series. Thanks
for checking it.

>> I would ask, does above reasoning convince you with the current switch-case layout
>> or you want it to be range-based?
> 
> That's fine, let's keep them like they are now and we can always revisit if
> the list grows too ugly.
> 

Sure, thanks!


- Neeraj

