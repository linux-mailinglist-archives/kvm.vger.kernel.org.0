Return-Path: <kvm+bounces-51651-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E569CAFAB84
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 08:16:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 949ED189B4CA
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 06:16:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81DDF2797BD;
	Mon,  7 Jul 2025 06:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="QG2zN/9D"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2045.outbound.protection.outlook.com [40.107.94.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 063F919F40A;
	Mon,  7 Jul 2025 06:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751868971; cv=fail; b=T2dmwEJEQFBw0jJ7nVukF4sVIq8zfFlypBwnu1lAgKgVJF7BakEFIbcKKyjZ6q+tGQJmTjbunB0fFqOjhQBYqlZaxYHMItHhE45F/nxkK6hGtAwidQXWjwI4HkKASGrqKEOI4AjWyn6iPWXa6AJMfuPuYHK+T6kosSQO5js/4NM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751868971; c=relaxed/simple;
	bh=i6JfPi9BGj6RCMJEXM/r14lcmQ5vbUjFT7KWwCriDOo=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hyJeV3NtKNO0TPBr8/KEJxX9VouJAzGJvTQughQusWKytGcVt8UVqLDYoZm1rDzxAg8GNlDg3UFzerx+8nnWrN9a9X+WJZqNr+IU4VmAWf+Zw4nTxwMyZrrseYAoWgq1DifbGYY7baAtdyCCM56FzJxjkNYRo4ieuY1UEUuakqo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=QG2zN/9D; arc=fail smtp.client-ip=40.107.94.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rvugUppKSCIzHdW3OvN6AkmlJR5ueINQuQuzaY1YTDIp5gxfX/IhpxE+9yArsc/hTENNoT7pa7uQbSS33d/utp0ik3jKLv5pwB9HdJiVZoakDz9NBuBfzp+QEs5c0wE0Bhcq3O9TRwq/dptnv2qz8raDkihd6EpU1iAY0UgkVcc0SOs7yd83dfjXG6edUsVmptxoKGWIrteupRDofZ3Vn7rjDecyQUF6bz95V0tnHjRsWr26Vka/ttUGh38C6mmbC7tySTsjH2P+mc5d8LUUx7RLCk7wF8w40YNTQHl1mw/7bqsr+bi1UfWORCn7j3pqnrOChB/LN3WebfBVoDd7dA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DDVB82+hIOCFDB3QXcJEqUYgbd2YdT59051RkpD1s2U=;
 b=axIlCpA1y75MJuI1ajhV9CI4zuhR5VzIuUkkTBNpVPOpGdYET1xOqV0/hDcQaP6M//RZQnMdMIEtXBQObF7vnr+9u/aloGjQRPrj/xstwSD4kaj7EiC6lf1uZjBLaukk3iIjcnf7SB9ALNwf8mIZDJBRhVn5UfcePElLBbM7S+vkzAPMkEfgmHqLun4UreWE4gp+JFbqKgWs0tSce/5x60TnrogEjSb1HYT+YuiDIi5yFTFRav4jMR2VLxaA4ef2UFVVAZ/eHUV23DulqOLCkJtwFy5ngO0h87S+vZ8LEevjEuM81pw+CAPOuFNi9OxBJEHxQBnZjpq/n3/vq6fh8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DDVB82+hIOCFDB3QXcJEqUYgbd2YdT59051RkpD1s2U=;
 b=QG2zN/9DG/jOv4RuIU1acv/w+e1afaP3Z7A/FV0mbJG6GKP8EhgY29WIjfAvvq/wYwjZQr2lHAK2eEjkcPtZcxhcZzUG0kEUfrfnLDS7MrJA5ApLduUpQ3RZCY6IfpUy8CnNdhlgf5sTWfrHoZ8RgULgq7PARIZNhRnzYN0aAps=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by MW4PR12MB6997.namprd12.prod.outlook.com (2603:10b6:303:20a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.24; Mon, 7 Jul
 2025 06:16:06 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%6]) with mapi id 15.20.8901.024; Mon, 7 Jul 2025
 06:16:06 +0000
Message-ID: <d76dd17d-39e6-4cfe-95cc-d68a485864d6@amd.com>
Date: Mon, 7 Jul 2025 01:16:02 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 7/7] KVM: SEV: Add SEV-SNP CipherTextHiding support
From: "Kalra, Ashish" <ashish.kalra@amd.com>
To: Kim Phillips <kim.phillips@amd.com>, corbet@lwn.net, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 thomas.lendacky@amd.com, john.allen@amd.com, herbert@gondor.apana.org.au,
 davem@davemloft.net, akpm@linux-foundation.org, rostedt@goodmis.org,
 paulmck@kernel.org
Cc: nikunj@amd.com, Neeraj.Upadhyay@amd.com, aik@amd.com, ardb@kernel.org,
 michael.roth@amd.com, arnd@arndb.de, linux-doc@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
References: <cover.1751397223.git.ashish.kalra@amd.com>
 <b43351fec4d513c6efcf9550461cb4c895357196.1751397223.git.ashish.kalra@amd.com>
 <790fd770-de75-4bdf-a1dd-492f880b5fd6@amd.com>
 <7598ff2a-fab1-4890-a245-9853d8546269@amd.com>
Content-Language: en-US
In-Reply-To: <7598ff2a-fab1-4890-a245-9853d8546269@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA0PR12CA0006.namprd12.prod.outlook.com
 (2603:10b6:806:6f::11) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|MW4PR12MB6997:EE_
X-MS-Office365-Filtering-Correlation-Id: bf93cadd-e85b-44c3-b462-08ddbd1dc1cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Qis2OG5GUGExS1FrTUlBeTJvZ05wRzFzc0tOakN5Q2E0eGw1THJqZmtReUoy?=
 =?utf-8?B?K3h0SUUxYUhSUG96MzlucGk0aUZIYThITUxHVkhHYkRoeTVrekxCdkhPTDNS?=
 =?utf-8?B?RW9KcDJhL3hIcHhwbnB5bE9HZlN3M3Y3NEE2VzNlK1ltWEpaNUZOdXJObGdB?=
 =?utf-8?B?bEpLaXZ3VmFWNk9TRVdEdS91Nzc4eXZQK3RDbk5Ubm5ma3V2cThaVkVMNXQr?=
 =?utf-8?B?RFB4WFRid09Ud056SUsrT1IzdTlyaURjRnh0Z0pxSlFValg5cUNNNzR1WitK?=
 =?utf-8?B?TmNrcFJmY2E5Rnc5VWRaVElhS2FKSGpYbG50Q0hxeGo1QzI5eWhGb2NuNkgz?=
 =?utf-8?B?eVNmS0ljQWtPOEMrK0NGMHhtYlZSUy83MUx4UlBHOFZoMzR3aFVKU21ZckhG?=
 =?utf-8?B?VnMwVVlWQ2tSc21PN2IwNExjNjR3ZEtHTE43MlRaNFhCMnhZRmJXVElrT1hs?=
 =?utf-8?B?OU5PemxpUDdpbEVYbGRIRDdkMUdzYkFrVTlVbi9MSjlUby81ZXpnbm1rc25X?=
 =?utf-8?B?d2d1WWx6TlRyR051bkUrV0h2NzZvMHg2WVFndC9LQ1FLZDBOU0kxOTNaOTlt?=
 =?utf-8?B?SUUzMERENnd4MGNtZ0VDYWtqUGgrZ3YyZnRpWXJIZEhwdlpncEtQLzk4dlBl?=
 =?utf-8?B?bHQzWVUwRVRlanNxRDA5ckJydjNZUi9lYWJRRmtyams4RGcraDdiSThiMk1r?=
 =?utf-8?B?d1VUSGxQK1Z5U0JTcjRoYU9LV1F4cHQ1Y05CU1loZktVMmdZOFY3bkI3Rmo1?=
 =?utf-8?B?WEVQOWMydmt1V1I4M3UyM01tUjRmRTFobytGUzJjZXEyVE5uVStxNnlnS2N5?=
 =?utf-8?B?c2FMU2phNXFSZDNzcmNlVzRQcGJGWEtTcXBzNGxVWjlKZjNlUlNuM3VCZjhZ?=
 =?utf-8?B?V0dTN2hjZTE0UTJtUHdxb2gxc0V3dVBodTBPUjZQTG9ZaGtxdDR6VGZCQU85?=
 =?utf-8?B?b2FJQ0NwdmRQcG01cUNxUXY1NnFQMlorREhJUlE2WXR3ODJNYktoc0xDaFdX?=
 =?utf-8?B?RW0wSmJhZ1IvbXJVVEhwVWpzSkZXaGw0VlRrK255S04rQ0ZDUmhieWNjVWR3?=
 =?utf-8?B?OFVVOWp5N2dkOW9NLzVGNTBQS2hoOXFhRUF4NGNBanRuVGRmT093SkpGSW5t?=
 =?utf-8?B?Zm9JZElpeTI3NjAxeFVxbDFpUUx5ZjBVM290N215TzB2ZHRBaFIxY2xCb0pR?=
 =?utf-8?B?eVo0MnFVRytKZEhoZ2s5VVEvd0pad0NSNVJoV1FNQStkbEhiS1lvZVZ3VkFj?=
 =?utf-8?B?ZVVVVW0rcEI1WCtPc3hYUG5QYkYwVm9DQ0VCTVQvc3psUGwrc1NyZFJIQ0Y4?=
 =?utf-8?B?UkJudHdlN3UwYjNDT3czM1lPSlRXWm5hdGVWSGRXN0xCYUlyRjdCWlRnekY4?=
 =?utf-8?B?b2grRTV2ZER5TXgvZDV1RW9FYWpnaDVoVWFCOFFOWXJONVpKZW9BS2NyRmlx?=
 =?utf-8?B?TFdWeWw1OEdwUWJlUFNJNEJDdGdndEIrUUxGMG5LSHNKbkVhZ3FiQ3lSd2ZT?=
 =?utf-8?B?NWdwNkt6MjVQSmJxbFp2MG02VmxMSmNRVU1XR0E4NVNrUnNITll0VTFHT1RY?=
 =?utf-8?B?VzkvZWxuSkcrLy9lVzVkME40emhhTTRRTHluNWxHTWxRd2hkdytIaWMwTEM0?=
 =?utf-8?B?MmRKM0czTGhiWmcwekZmTmJKdlA3L2poTWFERlVzMEhPeVUyZlVUWERmOWM5?=
 =?utf-8?B?NEFoa085MUpjN2tKcDlTdEUwQnJodzNDcHF3YlZhczh1K3l5T09DdjJyemx6?=
 =?utf-8?B?Y2FBUjFwZTRMdlJzRzBjR09YbkgySU1TU1RpcDVLTkh1amdhNkQ0Ynd2SFpF?=
 =?utf-8?B?bE1KbWoxTGZJVkYzR3ZZYTZSWnJyZlI5dVQ1cnVCTnJBWnk5SXNHMDBMMFNt?=
 =?utf-8?B?YWozR3dOS2FxTE1JdHRhSjdVNVVZeHMrVm55a3NaUFZtb3RJckV4WFcxcWZj?=
 =?utf-8?B?Q25ORC9uaXNSeXJudGFmNUw0ZE5vUkUxUDNpU0pPVkFrc1d4cGUwaXMxSVVl?=
 =?utf-8?B?ZWZ0L2tRSW9RPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VHJYZEVQeFY5OHRGYWJjSitHZ2RaYW9ZWmYyUFYwRSs5ZUUyRGJMcGRMdmZG?=
 =?utf-8?B?MFFxaXM5ZmRKOTl5MzFORmV4K1BhdkpDbzY2dXdVMzA4d21JbkhFMnJNY2ZE?=
 =?utf-8?B?dk1WaW5XY2VHN3g5SG1iQ2xVM1hvNXEza0RQb2FITzkzeFhFWklBbHFFY1l1?=
 =?utf-8?B?YTI5Y2JlVzVhZ1dwWCttVUt3dS9zSjQ5TFlXUGpRVi9hOUVwSjMxazdqTDJB?=
 =?utf-8?B?MjBoVnRyM3gvZC9sWEN4OGJES0ZXTzZGN2F4MVRWeDJMWkplQWw2OHhoTkV0?=
 =?utf-8?B?UmRoRjRiUDEvVzk5bHJqaFhFUjBjZCtPVmpUc3Q1RjZRdFpLSlBUOE9QUWpY?=
 =?utf-8?B?Y25iemk1bXhSSmExUFlqbURXQkZIWFdoaWwwV1BoVWlxWDRpendQVzNzME9N?=
 =?utf-8?B?MW5pRVYrM2hyM2NLa1U3bEJ1cFcvK2lGWVlHRVFjdkN0QTh0cEZQUkRLMVIw?=
 =?utf-8?B?TjZsN3dLVXM3WVZ5eklUUFdQaTRETzdiY3B3d1BSTmZjTTZxdE53NzNPc0sy?=
 =?utf-8?B?RmlNbWIrbmN3WnhaKzc1S2FmKzlqSUhtTllrcmNGSXd3YlNpS2pJRU01eURF?=
 =?utf-8?B?Njd6UUl6Y244Qm1vdzBTUlR5TSs0SXo0dGpWRW1yZlZpYXNyNGNXRnVpaUt5?=
 =?utf-8?B?MzRLajhxb1ZseHdZUzl5eUlrWGZneGpTMFFVWUd0dWM4Z1BHTkdFdlQvd2Jo?=
 =?utf-8?B?NG43ZzhycEJFaEVDOHIzSTYveU5lN3VBN3RCNThVSGR5QVFocnp4cmllN3BZ?=
 =?utf-8?B?T2VNL2FHaEptTXlzRzdyQTJ4SXZpa0tRWCtUN2tJV01JZmxPczArRWwxVWJW?=
 =?utf-8?B?K2ZUQllJZS8rcndHUVBDdFppV3MreGloNjVHaytOWWlTZnJxQmtmNDhTYlFv?=
 =?utf-8?B?VGNkR052cEpnVW5Ra2NQV2U0SXljS3JRU2FkN3Q1RDgvbWdzVnFaRm5MNnB5?=
 =?utf-8?B?LzZFUGVJcVFYa0x0UmhmYmtoUEQyN2dZdDJLd3hFS3ZDdWg0SUtsWnpudUxM?=
 =?utf-8?B?Z3hIcXVvbW9ZYVpJNW5VcDRpQ2I4aGVOeStqb0kzK01BaUR2YS9RRjBMcElH?=
 =?utf-8?B?ek1OZWVLWFNxM0JRby9LMGFBbHhzdE92YU1sQ3N5UVo3ZlJhVG1PNkMrZU5T?=
 =?utf-8?B?Ykd5Q0RwSDV4WFVETjE0OEhCQ0RpR3E2QktvblhqbUVvVlgxZ01EUGZrM1NT?=
 =?utf-8?B?TXJhZlJIMVlyRmFMWEppUDJQYW9mc0x2cHVUNmpGL1VLblN2ZGRSV1MyZmYx?=
 =?utf-8?B?NE9wZjF1MVo0MUFHU1Q3YnFKQStwNm5zLytVRFhzQWxWUHd3WTYxR0dMQjRR?=
 =?utf-8?B?SGNCNENYNUlCY3hNZ2J3UnBhSlRJWjhIZjJhT1pTOW8rVlJiNUN4a25Fbjky?=
 =?utf-8?B?RUw1eDUwb3JzaXd1SlM3M0hPaVA5RnhpUk5JOXVvS0dlWFZxbUlmZWhKWmJl?=
 =?utf-8?B?SWVjaEVTTUhseVF5VUVPdkRHVjF6Zmc2VW9nVVd3bnR0VHI3MXVUT29nWVdR?=
 =?utf-8?B?dWtmUGF1Q3FuTUF5Z0J5NEg3TWp5QmNjTWZXVjZkejI3WHVFbWF3TG12Umla?=
 =?utf-8?B?S1VLbzJxL1k0OEJQSmJqV2NLc3llQjVyczBCYnJZRW5BVlVaMDZVcTd0eE1I?=
 =?utf-8?B?cy9uWE1hakdpd2FVdG9aMXR6aC9oME5Tcm9QdkxRaU9QR3J6bDVhQzlkV2pK?=
 =?utf-8?B?VUlBWFplem51cHJ4U0hYdHZYeUJ0aEF6UHlqVThTaEQ2ekhEUlROL252RSsw?=
 =?utf-8?B?MElaNC9YWmZMRS90SW83eXh5M255dUZMTjFPUnloNkhNUVFiZUlSaTdKL1hy?=
 =?utf-8?B?SldKTCtWMTIvMm5KVlF4VXl4SVBESloyWWxwc1ZRVCtIYjdoVi9qd2ZrMERW?=
 =?utf-8?B?eWNuaHYrSkVHQTY2TDVKTW9VcGJZbG1oQlN0bnRFaEloZ3BvbnVrVnFrZjdh?=
 =?utf-8?B?R083SUpDV3NoWUhFamczczZ5RnB3MUpyWk9PZFZwaU13eVIvUDFicFhwZG1j?=
 =?utf-8?B?V2JDVGMxTFFibU44aWk0a0pDWkg4VTkvWWt1eXRidnlvb0c2dm5MUFBBZEt4?=
 =?utf-8?B?bC9wMHdyemF6azk0YnVpSXlOakVlVTNOYUNsU3pEcEUyRitJeWp4ZVZKa0J4?=
 =?utf-8?Q?1aouyrist/BxZ48WS5FoeSBn2?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf93cadd-e85b-44c3-b462-08ddbd1dc1cf
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2025 06:16:06.1966
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H9OVEdSzl8ZsHPn/Chk9uaemJaEsQ8qoVduD241I/HTfbGzu9mZRqm9lbdbMNh5PU6U3D0EAGu5QXLmtFQH1kA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6997


On 7/2/2025 5:43 PM, Kalra, Ashish wrote:
> Hello Kim,
> 
> On 7/2/2025 4:46 PM, Kim Phillips wrote:
>> Hi Ashish,
>>
>> I can confirm that this v5 series fixes v4's __sev_do_cmd_locked
>> assertion failure problem, thanks.  More comments inline:
>>
>> On 7/1/25 3:16 PM, Ashish Kalra wrote:
>>> From: Ashish Kalra <ashish.kalra@amd.com>
>>
>> Extra From: line not necessary.
>>
>>> @@ -2913,10 +2921,46 @@ static bool is_sev_snp_initialized(void)
>>>       return initialized;
>>>   }
>>>   +static bool check_and_enable_sev_snp_ciphertext_hiding(void)
>>> +{
>>> +    unsigned int ciphertext_hiding_asid_nr = 0;
>>> +
>>> +    if (!sev_is_snp_ciphertext_hiding_supported()) {
>>> +        pr_warn("Module parameter ciphertext_hiding_asids specified but ciphertext hiding not supported or enabled\n");
>>> +        return false;
>>> +    }
>>> +
>>> +    if (isdigit(ciphertext_hiding_asids[0])) {
>>> +        if (kstrtoint(ciphertext_hiding_asids, 10, &ciphertext_hiding_asid_nr)) {
>>> +            pr_warn("Module parameter ciphertext_hiding_asids (%s) invalid\n",
>>> +                ciphertext_hiding_asids);
>>> +            return false;
>>> +        }
>>> +        /* Do sanity checks on user-defined ciphertext_hiding_asids */
>>> +        if (ciphertext_hiding_asid_nr >= min_sev_asid) {
>>> +            pr_warn("Requested ciphertext hiding ASIDs (%u) exceeds or equals minimum SEV ASID (%u)\n",
>>> +                ciphertext_hiding_asid_nr, min_sev_asid);
>>> +            return false;
>>> +        }
>>> +    } else if (!strcmp(ciphertext_hiding_asids, "max")) {
>>> +        ciphertext_hiding_asid_nr = min_sev_asid - 1;
>>> +    } else {
>>> +        pr_warn("Module parameter ciphertext_hiding_asids (%s) invalid\n",
>>> +            ciphertext_hiding_asids);
>>> +        return false;
>>> +    }
>>
>> This code can be made much simpler if all the invalid
>> cases were combined to emit a single pr_warn().
>>
> 
> There definitely has to be a different pr_warn() for the sanity check case and invalid parameter cases and sanity check has to be done if the
> specified parameter is an unsigned int, so the check needs to be done separately.
> 
> I can definitely add a branch just for the invalid cases.
> 
>>> @@ -3036,7 +3090,9 @@ void __init sev_hardware_setup(void)
>>>               min_sev_asid, max_sev_asid);
>>>       if (boot_cpu_has(X86_FEATURE_SEV_ES))
>>>           pr_info("SEV-ES %s (ASIDs %u - %u)\n",
>>> -            str_enabled_disabled(sev_es_supported),
>>> +            sev_es_supported ? min_sev_es_asid < min_sev_asid ? "enabled" :
>>> +                                        "unusable" :
>>> +                                        "disabled",
>>>               min_sev_es_asid, max_sev_es_asid);
>>>       if (boot_cpu_has(X86_FEATURE_SEV_SNP))
>>>           pr_info("SEV-SNP %s (ASIDs %u - %u)\n",
>>
>> If I set ciphertext_hiding_asids=99, I get the new 'unusable':
>>
>> kvm_amd: SEV-SNP ciphertext hiding enabled
>> ...
>> kvm_amd: SEV enabled (ASIDs 100 - 1006)
>> kvm_amd: SEV-ES unusable (ASIDs 100 - 99)
>> kvm_amd: SEV-SNP enabled (ASIDs 1 - 99)
>>
>> Ok.
> 
> Which is correct. 
> 
> This is similar to the SEV case where min_sev_asid can be greater than max_sev_asid and that also emits similarly : 
> SEV unusable (ASIDs 1007 - 1006) (this is an example of that case).
> 

Also do note that the message above is printing the exact values of min_sev_es_asid and max_sev_es_asid, as they have been computed.

And it adds that SEV-ES is now unusable as now min_sev_es_asid > max_sev_es_asid.

>>
>> Now, if I set ciphertext_hiding_asids=0, I get:
>>
>> kvm_amd: SEV-SNP ciphertext hiding enabled
>> ...
>> kvm_amd: SEV enabled (ASIDs 100 - 1006)
>> kvm_amd: SEV-ES enabled (ASIDs 1 - 99)
>> kvm_amd: SEV-SNP enabled (ASIDs 1 - 0)
>>
>> ..where SNP is unusable this time, yet it's not flagged as such.
>>
> 
> Actually SNP still needs to be usable/enabled in this case, as specifying ciphertext_hiding_asids=0 is same as specifying that ciphertext hiding feature should
> not be enabled, so code-wise this is behaving correctly, but messaging needs to be fixed, which i will fix.
> 

And i do need to fix this case for ciphertext_hiding_asids==0, i.e., ciphertext hiding feature is not enabled, as the above is not functioning correctly.

Thanks,
Ashish

> 
>> If there's no difference between "unusable" and not enabled, then
>> I think it's better to keep the not enabled messaging behaviour
>> and just not emit the line at all:  It's confusing to see the
>> invalid "100 - 99" and "1 - 0" ranges.
>>
>> Thanks,
>>
>> Kim
> 


