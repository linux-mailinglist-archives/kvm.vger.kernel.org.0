Return-Path: <kvm+bounces-43590-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ECFF0A92DD6
	for <lists+kvm@lfdr.de>; Fri, 18 Apr 2025 01:13:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3D2653BDA97
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 23:12:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 494EE214235;
	Thu, 17 Apr 2025 23:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ehj7MrGJ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2077.outbound.protection.outlook.com [40.107.102.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4998322170A
	for <kvm@vger.kernel.org>; Thu, 17 Apr 2025 23:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744931455; cv=fail; b=exXGQz/ftYHJf0pkyZLmKyytMydzxnQbj5oDeGofXejjVsiapWPK99VgGJlixBPvNc6nKCzlT1hDlmBti5bZCZsWwTO0NfcDXBeLZuK1tXOFfVqSO+IqkJ55uEscZSVpeC78WqhP9b+5dVdPzp4/nLdASlfJZSYmCPrXcqHSgJ8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744931455; c=relaxed/simple;
	bh=EOUsl3mof3X3lRHBG7IozQ6XkmPt+/dZ9+fHXmo/bDo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Vt0zxsLkt7EguITUlL1D7VO1K5E2Q8G9g3BjGU8Hqsdb8B2K1Mi1G9wp86AytkqHVLymn03jxyehcjfDHo1FKAVErJ1hybAhEGgHQ8AR6RFC+6CdK0Yo9mEsBpId4UGc9QGlzrRAI+C+EtOBIuYYys+aMvPrLwZH8rpK/LzCNyM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ehj7MrGJ; arc=fail smtp.client-ip=40.107.102.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y+24E+2I7edAC2Z8F1350zcxFpp4fkAWC+9nUGVMqM6UuYP07Fcr7Et5o7SLkwrk/i187Enp11nxFPgUezolVPWBH7/iSdaxxcpHrUOsaPz1vWtoNitSd4RjnwOZUOIE5Cj0BQQTycGywv+SO9gUZAMVB6VSi1Gu2jSIULA8+f1fxqwSNc+10W9sCgAcejC9d1pnHNLk74Qt0oCdbXBvxF07xQNt7z2IkK/UIP0YUyeKFLZtuQR6bg+wfYkxf4u4VXaquBNkvdrGqhkb3BFBNu1bAE54mlme74RyC7t2UXwMoqIXm+10w9BF1tn6Kim/T83zGyNx3OnukkLTMMmzLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tGLKaUmZkqXzy234inX6M0NQId3+OpS+K9ph/6UVoUw=;
 b=H/Pzh4LH0SGS+Ewh02klKGai0nyDu2a9jw5spzA5CvLVJB0z5Rg6GDhAZ1qtcaogCSKgaMvyKvcZxk4V0ncn5PfqgnWYbHEp/IV2aJbZUebW0qO3P/tmNXNaSZDZ6XzbBwB1f/FTzMS2ZxMNtLW7cy5TA0g7SafZfiiDPG2IItI7viE8RU5o2DDb7hSUnSonmF1Ih0xkUtBFrnKEIaKFgF/M0A456pO+xZ4qYENPeFcLNa3TTPZWAIrdJ7S+ks8pk4Hp30DvGji4JD3TsDq7UfYf4gxJ1uLjivT4VXFdCEFu68i19tiSzaB55HQQw6ZE5/YyJstEf+6ebXXNJOu1Kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tGLKaUmZkqXzy234inX6M0NQId3+OpS+K9ph/6UVoUw=;
 b=ehj7MrGJzDi36uXGzifUsU4yv7WJqH6iptGX/KPGJBxvLTStur+ACQoqwPv1XWOPyuXo50MlmJNcOK5PoG9Ndp7D456BUjQkOE1y2UQ/2Q1irPRVDZ5UAHKVAHYgnTYkX3QtsF2RLWzcMPCTrZK3qZrmfiFFS9nGE1Pn/sytmeU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by SN7PR12MB7809.namprd12.prod.outlook.com (2603:10b6:806:34e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.32; Thu, 17 Apr
 2025 23:10:50 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f%4]) with mapi id 15.20.8655.022; Thu, 17 Apr 2025
 23:10:50 +0000
Message-ID: <43b949b1-bc8b-4b7d-ab3b-206cb88d4756@amd.com>
Date: Fri, 18 Apr 2025 09:10:42 +1000
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH v4 04/13] memory: Introduce generic state change parent
 class for RamDiscardManager
Content-Language: en-US
To: Chenyi Qiang <chenyi.qiang@intel.com>,
 David Hildenbrand <david@redhat.com>, Peter Xu <peterx@redhat.com>,
 Gupta Pankaj <pankaj.gupta@amd.com>, Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Williams Dan J <dan.j.williams@intel.com>,
 Peng Chao P <chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>,
 Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao <xiaoyao.li@intel.com>
References: <20250407074939.18657-1-chenyi.qiang@intel.com>
 <20250407074939.18657-5-chenyi.qiang@intel.com>
 <402e0db2-b1af-4629-a651-79d71feffeec@amd.com>
 <04e6ce1f-1159-4bf3-b078-fd338a669647@intel.com>
 <25f8159e-638d-446f-8f87-a14647b3eb7b@amd.com>
 <cfffa220-60f8-424c-ab67-e112953109c6@intel.com>
 <fd658f30-bd28-4155-8889-deda782c56eb@intel.com>
From: Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <fd658f30-bd28-4155-8889-deda782c56eb@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MEWPR01CA0217.ausprd01.prod.outlook.com
 (2603:10c6:220:1eb::17) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|SN7PR12MB7809:EE_
X-MS-Office365-Filtering-Correlation-Id: 32a4828a-d56f-4cce-3ebf-08dd7e051819
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cjZxdnlSek1hekJocUpaaUx5RXY1Vjd6bXIxS21SZkhoR0lZL3Y2N0RnSEJp?=
 =?utf-8?B?QUR5ei9nUlZ3L21KM0x1NjFtUTNLTlFzMjlpVmwxMk1hRmpydG1nZDFNbFQy?=
 =?utf-8?B?RGRVckwza1oyQi9rajJTVWt1ZlZYNW45QmlsdmhISWhzWkhSRmVUWkIyZktE?=
 =?utf-8?B?aGMyL1dOSnZFNzk1Y2wwTUpLVVZpK3Jwa2FKbEJmZjBVcytrRTVhTmJaN2Zm?=
 =?utf-8?B?S0xXTmxoQnk5bVZ5ZkNtV3YrRlNkTDhmYVpseXNJU0hHZDJUQWRIVWVFN1FP?=
 =?utf-8?B?QzFCL0s0RStkSVVPYzA1aWNVNlYwdlZUb2RFYjVENmpNOUF6ZXF5YlN0OXdm?=
 =?utf-8?B?U1l2bnN2TUxmajFkdjBjQXBQUi9UZjFVMjFLb3g3VjhBUFdlTjlNNzF4bUVJ?=
 =?utf-8?B?bTRlZlZzTTB4L3hyUDFFYUpZcVBkTXhPN2w4RjdEWFZzV0N2bzl1MG5Ld2d2?=
 =?utf-8?B?Y2FoQVdxQjNsVlJ1WERNTmRnL0VTN3EyYlJjZVd2VWtqT0RkdDNXQkd3Q0xq?=
 =?utf-8?B?a2U3Z2kwMnBORXl2TmhVOE5kaitKVHk5aTJKeXFia2k1QTNUSFZsc3N4dlZo?=
 =?utf-8?B?c2t6Q3BFSEVkVWlSZ0ppSGM5bmdxaHdaU05kLzR2a2FTSUFLNHB5Q3ppTENy?=
 =?utf-8?B?NTZpdFpqanh3L1RYQzd5aUdvVzFFSXcvcjVrczc0ZVRweUI2cmhpeTd6d1pC?=
 =?utf-8?B?dVhTa2Z3K013MHlGTkFnNG9ySmYzUGU4SXZ3amZWOWkyWUYvVnNBTmNFbXhF?=
 =?utf-8?B?THFFUWlsbHpnR2pNQmFXdlhJSXNjR21yRmpjdzBqMExEY1JNTnkxMENZa2NO?=
 =?utf-8?B?UDQwTWtQbWJIT0Z4WFZ1d3M0cUpZNGQ2WHVweDhVb2RjS1FCQnp6dXp4azg3?=
 =?utf-8?B?YWk4R3paMUxCb1ppZ2pPbEVhQnlIVDFiczF2aUJYVFk1QVFvV0V3aEtCQ0Zh?=
 =?utf-8?B?YW8wTWZicGxuRUNhQVlnYVlOT3NoMXRZaHVvSUV1L0RtWmJJS2I2R2xrN3ho?=
 =?utf-8?B?RHUwQTRiK0NlZWxqVHYwL1ZTTUZqbzFOU2xLNjlqQUhkdm9YQjFEcHFRZmdM?=
 =?utf-8?B?TllRbVVzaGlpWDhROXRYeEVMbGduMjV2T1JKTkxyTmRhQ3l5dURRRHYvaGtk?=
 =?utf-8?B?bkFob09lN251SVkvbndPTXFyR1AyaElWcDZpalJiM3RvY2dEZzZWODFqNXBP?=
 =?utf-8?B?YXlGL0t5MHpxZHpwQlowUXZJWFYwZnBCTzcxaFpCSExvUU9GZEZXSFIzaVdT?=
 =?utf-8?B?RU5Ldzdxb2JqNnZZdmlwL2U5NlNkVjlHOWl5TFZMZTRLLy9RblIyZkU5c2dQ?=
 =?utf-8?B?L3A5TU1zMDh6eWlPNUxiUUlQVnJXK2JqNU8yRXplb0tFOEp2S0tUMnBDajZC?=
 =?utf-8?B?VlhmQlMxdXRGTW4rblhhS05CZWhnOXdYOUJCNzBTZit1WlBYV1ptNDdiSmgz?=
 =?utf-8?B?MlYrMjZxMUQ5VVJhMUZ6azViWEZ3R0tsSXN4a3BPUkcrVmNpcm9kMXU4MlM0?=
 =?utf-8?B?MjIvNnNjYVBhaEM5VWZJajhPKzlVdk44RHJSZXlrUHo4ZFpIRkIvT05RczBX?=
 =?utf-8?B?V3NRanErS3VUVWR6NklQSDB1MUxVbnpQQXpObjl1bUJCb3JLWmprYjFGZDBm?=
 =?utf-8?B?ODlxL0RrWWRNWU54T21tcmkrQTA3Vlg2YWdPcHRkZk53c3M1Yi9NT2dESnZ2?=
 =?utf-8?B?bEU5N3YwZnNqRURwdVIraFZmOU1KV1FiTWJvSTg0Ujg5alFxOHc5Vll5czM4?=
 =?utf-8?B?NklIQUttZ1JiN0EvUlpVZlV5WXlKRkxZRHFxeEpSMlljcVlZaDdMM1E2NUdx?=
 =?utf-8?B?T0t3LzZSVjRFZktJREVYcjAyY1ZTUm5kMVlmazZmZWhDM2RQUkRuQjZSY0x3?=
 =?utf-8?B?SFM4aVVBb01SMk1nNHFMMTdld0J0YWo4UElmeVk3ZUZJeVFSMkFCdnlIRHdj?=
 =?utf-8?Q?3hqpvczAZbk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U0hQTEJQRHB4bG5hdjJpQ3JUekhPb25oVjlJdkdsRWp4ZFkxK0xTUnpOenlT?=
 =?utf-8?B?MXhVVS9xVTRnbEp1eDZQamVyaHU3alNYLzlJbmJQTk81aEMyU0R1VnFrOU1p?=
 =?utf-8?B?MXRXaWZyaUFYbVVyZSsrTkV4YzZ2UnpMSk1UcUpsSjFYc0JvYnZHNWR2TVVZ?=
 =?utf-8?B?MHNZaXlyc1RWcWhxVXo2NStuWkxldlFPbVZMT1lHZmpQcjJ3NW5lWHZBQ3kr?=
 =?utf-8?B?T0ErZyt2Y280b2drMTdvVzRpN2F4R2dJNEI3VGxwS3dBak11UXZNYXVLbXZQ?=
 =?utf-8?B?a3gwMEswNldwamQ4WENJZGRFWDQycDh4SEZ4V0NJa1FjMDhmaFlWVDZWbWE4?=
 =?utf-8?B?RmIxSW02amt2a2x5NytodUtpQ1JOVlBJeXlkeTcxVExycmw4U2gxU0RZaHhF?=
 =?utf-8?B?ZnZNNE1LTjFaaG04VWJLQ09JYUdWaWxFMDVQVFBmQmszUm5UcjNoUVRGUWNj?=
 =?utf-8?B?ekZhYUsrN2xsQW54c3pWR3ZOMVJEeG1reWRUSUlVeDRQaDg0OVkvTWQwSGR3?=
 =?utf-8?B?TGk4UVgxMERjNU9ZaVJUWFpPQVo4UnRRNUljVzd3VG54RFVER05PNTJBOHBL?=
 =?utf-8?B?M1VLYnJjdnZycldVTC94bWVmQTBvRFFQVHQ1TktsenJFQU5ra24xdzAvc3Yw?=
 =?utf-8?B?QjNZY0pJb2t0cGxLT0RCQUpFY0k1VUhlajRlMVBEcnhOQlJDbWRSNHh1Tjdt?=
 =?utf-8?B?N0t0REFJb1A2eEsyV0preTVDbjhQdWd6V2thQlRISzNaT1ArMHNIOTlmOUty?=
 =?utf-8?B?bEJiZWc0Ui96RldORTFBcVNDM3Ryb0NOK2JqMU9Na256czVONG5MQjJrZkxM?=
 =?utf-8?B?ZjA1Mjl2WUdEQlcrUlVMWDZtYmE2a2MvWkY3TkNNYXhRd0NGK1gwbi9hQ0kz?=
 =?utf-8?B?Q3g4L0U3d3ZaR0lSNERJdVg1b0REbTlyZGdtd3VHdldZUk96bHU5bnRJUWcw?=
 =?utf-8?B?R2FtdmtxUlZiZVVSYWdrRWJVcmdpbVkyTk5ZQnVQZ3U4QzBoR1ZsNjZNSkox?=
 =?utf-8?B?U3FsWkN1QnEyYmNUR3p0NVp1c1l0RHFjVDFVK2ludm1jQ0ZsU3ExWm5FdXZX?=
 =?utf-8?B?M2k3QXhiWEtLMkMrcVpicVdYSzNBUjRLU0lEUEdjOFpuR2czb0RlcitUNjRZ?=
 =?utf-8?B?UHdTa29nRzNFSEJjc0FmSXovMXEyMm9WQWMxUGdxNkM1bUtSbyt4R1hkZXJk?=
 =?utf-8?B?SFRrQkhOMlR5cFpVRnRSZ2lwbHBmeGV2ZmpFb2ZLOGJCUnplTHFDcC95cS9T?=
 =?utf-8?B?M0laMnU1M3ozZVFqN0J6QVdmS2Z0UjE0QnpjVHJWVFR2aG04M082d2RiKzBq?=
 =?utf-8?B?T2txUGVGVXdWQi9ZbjgwaDF6ZEp5ejF2U2s2THB6OVJ4SCtPNWY3RzVhQXY2?=
 =?utf-8?B?c1NNYm1RQksxOC9vNnl6TzhXV2h1bVJyYWszL0hLUG5PSmVtK0tURllFa1Bs?=
 =?utf-8?B?Y3VJZzM2bWJqcGdrcURwSTdScjNwbWtGR0RiMzlZbzVmaTEvc1BvcXpqd1Rl?=
 =?utf-8?B?Q2VBTVJSb3ByMmcxU1ZlYzVxWWNDYVViZzlCRlBUZ0lFenFMcTVUeXJsekxZ?=
 =?utf-8?B?MWlzL2pJWEZSeDVCZ1ozcnJXZUorOWdPNVNrMGN4RnQzVW9CRmE1cFgzWmkr?=
 =?utf-8?B?Z2tKZm9BWU1MNmtxZHUrT3JZRUYxSUFmZnl1YXo3REFDTC96L0tDZG5Mbjdp?=
 =?utf-8?B?MEZ3SFd6RmhHWURqOVpmbVFXaGFZNjc0YnRrZnlJSzA5czZDTHp1bEtidUtj?=
 =?utf-8?B?Q0VTQ0pBdCt0M0JMeURYZGIyZmMzR2hJRjM2SHAyeWpKdVoxWnVxR0ZPWTYr?=
 =?utf-8?B?ajlURHJGVEpGbWFjT2ZOeHBzMEdwVEJXYVVDaUZIZXAxVFlJLzVaNDY2dlRC?=
 =?utf-8?B?Nk8xQzN4RTNBWFNLK3BaelNXTG1RbGtPY21MRitsUlZTT2g5Nm85bENDNUpD?=
 =?utf-8?B?bTVTSnpmRUFiamY5WXZyaDVxQmFDVmoyZGo3UGV1RzdLS2U5NTZlbWxleUJW?=
 =?utf-8?B?STZjTmVEYkxHdDV6R0R2RlBRR2tiV1RQc1FSQW42UWFaaGRBVDZWS29sUmtL?=
 =?utf-8?B?Z1ZGZWE3aXU5NVNDdGI4ajgxNGg1NnBWc2tDOStqOStaZkxkWDBJZi9KMDZO?=
 =?utf-8?Q?cl/S8Uj8prSvywLeIu1y7Ugfq?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32a4828a-d56f-4cce-3ebf-08dd7e051819
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2025 23:10:50.3788
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SeAkPjH1YMAlg+3xFGj2uGzuLbcEBs+X1Io6CnU+o4SW9PlcY+FdYcGBN1CyilTbch9XZGsfo//ZfFzjGRiL5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7809



On 16/4/25 13:32, Chenyi Qiang wrote:
> 
> 
> On 4/10/2025 9:44 AM, Chenyi Qiang wrote:
>>
>>
>> On 4/10/2025 8:11 AM, Alexey Kardashevskiy wrote:
>>>
>>>
>>> On 9/4/25 22:57, Chenyi Qiang wrote:
>>>>
>>>>
>>>> On 4/9/2025 5:56 PM, Alexey Kardashevskiy wrote:
>>>>>
>>>>>
>>>>> On 7/4/25 17:49, Chenyi Qiang wrote:
>>>>>> RamDiscardManager is an interface used by virtio-mem to adjust VFIO
>>>>>> mappings in relation to VM page assignment. It manages the state of
>>>>>> populated and discard for the RAM. To accommodate future scnarios for
>>>>>> managing RAM states, such as private and shared states in confidential
>>>>>> VMs, the existing RamDiscardManager interface needs to be generalized.
>>>>>>
>>>>>> Introduce a parent class, GenericStateManager, to manage a pair of
>>>>>
>>>>> "GenericState" is the same as "State" really. Call it RamStateManager.
>>>>
>>>> OK to me.
>>>
>>> Sorry, nah. "Generic" would mean "machine" in QEMU.
>>
>> OK, anyway, I can rename to RamStateManager if we follow this direction.
>>
>>>
>>>
>>>>>
>>>>>
>>>>>> opposite states with RamDiscardManager as its child. The changes
>>>>>> include
>>>>>> - Define a new abstract class GenericStateChange.
>>>>>> - Extract six callbacks into GenericStateChangeClass and allow the
>>>>>> child
>>>>>>      classes to inherit them.
>>>>>> - Modify RamDiscardManager-related helpers to use GenericStateManager
>>>>>>      ones.
>>>>>> - Define a generic StatChangeListener to extract fields from
>>>>>
>>>>> "e" missing in StateChangeListener.
>>>>
>>>> Fixed. Thanks.
>>>>
>>>>>
>>>>>>      RamDiscardManager listener which allows future listeners to
>>>>>> embed it
>>>>>>      and avoid duplication.
>>>>>> - Change the users of RamDiscardManager (virtio-mem, migration,
>>>>>> etc.) to
>>>>>>      switch to use GenericStateChange helpers.
>>>>>>
>>>>>> It can provide a more flexible and resuable framework for RAM state
>>>>>> management, facilitating future enhancements and use cases.
>>>>>
>>>>> I fail to see how new interface helps with this. RamDiscardManager
>>>>> manipulates populated/discarded. It would make sense may be if the new
>>>>> class had more bits per page, say private/shared/discarded but it does
>>>>> not. And PrivateSharedManager cannot coexist with RamDiscard. imho this
>>>>> is going in a wrong direction.
>>>>
>>>> I think we have two questions here:
>>>>
>>>> 1. whether we should define an abstract parent class and distinguish the
>>>> RamDiscardManager and PrivateSharedManager?
>>>
>>> If it is 1 bit per page with the meaning "1 == populated == shared",
>>> then no, one class will do.
>>
>> Not restrict to 1 bit per page. As mentioned in questions 2, the parent
>> class can be more generic, e.g. only including
>> register/unregister_listener().
>>
>> Like in this way:
>>
>> The parent class:
>>
>> struct StateChangeListener {
>>      MemoryRegionSection *section;
>> }
>>
>> struct RamStateManagerClass {
>>      void (*register_listener)();
>>      void (*unregister_listener)();
>> }
>>
>> The child class:
>>
>> 1. RamDiscardManager
>>
>> struct RamDiscardListener {
>>      StateChangeListener scl;
>>      NotifyPopulate notify_populate;
>>      NotifyDiscard notify_discard;
>>      bool double_discard_supported;
>>
>>      QLIST_ENTRY(RamDiscardListener) next;
>> }
>>
>> struct RamDiscardManagerClass {
>>      RamStateManagerClass parent_class;
>>      uint64_t (*get_min_granularity)();
>>      bool (*is_populate)();
>>      bool (*replay_populate)();
>>      bool (*replay_discard)();
>> }
>>
>> 2. PrivateSharedManager (or other name like ConfidentialRamManager?)
>>
>> struct PrivateSharedListener {
>>      StateChangeListener scl;
>>      NotifyShared notify_shared;
>>      NotifyPrivate notify_private;
>>      int priority;
>>
>>      QLIST_ENTRY(PrivateSharedListener) next;
>> }
>>
>> struct PrivateSharedManagerClass {
>>      RamStateManagerClass parent_class;
>>      uint64_t (*get_min_granularity)();
>>      bool (*is_shared)();
>>      // No need to define replay_private/replay_shared as no use case at
>> present.
>> }
>>
>> In the future, if we want to manage three states, we can only extend
>> PrivateSharedManagerClass/PrivateSharedListener.
> 
> Hi Alexey & David,
> 
> Any thoughts on this proposal?


Sorry it is taking a while, I'll comment after the holidays. It is just a bit hard to follow how we started with just 1 patch and ended up with 13 patches with no clear answer why. Thanks,


> 
>>
>>>
>>>
>>>> I vote for this. First, After making the distinction, the
>>>> PrivateSharedManager won't go into the RamDiscardManager path which
>>>> PrivateSharedManager may have not supported yet. e.g. the migration
>>>> related path. In addtional, we can extend the PrivateSharedManager for
>>>> specific handling, e.g. the priority listener, state_change() callback.
>>>>
>>>> 2. How we should abstract the parent class?
>>>>
>>>> I think this is the problem. My current implementation extracts all the
>>>> callbacks in RamDiscardManager into the parent class and call them
>>>> state_set and state_clear, which can only manage a pair of opposite
>>>> states. As you mentioned, there could be private/shared/discarded three
>>>> states in the future, which is not compatible with current design. Maybe
>>>> we can make the parent class more generic, e.g. only extract the
>>>> register/unregister_listener() into it.
>>>
>>> Or we could rename RamDiscardManager to RamStateManager, implement 2bit
>>> per page (0 = discarded, 1 = populated+shared, 2 = populated+private).
>>> Eventually we will have to deal with the mix of private and shared
>>> mappings for the same device, how 1 bit per page is going to work? Thanks,
>>
>> Only renaming RamDiscardManager seems not sufficient. Current
>> RamDiscardManagerClass can only manage two states. For example, its
>> callback functions only have the name of xxx_populate and xxx_discard.
>> If we want to extend it to manage three states, we have to modify those
>> callbacks, e.g. add some new argument like is_populate(bool is_private),
>> or define some new callbacks like is_populate_private(). It will make
>> this class more complicated, but actually not necessary in legacy VMs
>> without the concept of private/shared.
>>
> 
> 

-- 
Alexey


