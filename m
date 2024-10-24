Return-Path: <kvm+bounces-29588-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F91B9ADC1D
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 08:24:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A88131F23334
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 06:24:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1EA9185936;
	Thu, 24 Oct 2024 06:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Af0od5SX"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2043.outbound.protection.outlook.com [40.107.220.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26E0E2FC52;
	Thu, 24 Oct 2024 06:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729751075; cv=fail; b=hc950w1+out2V4TuLNggy4uO8Atpn1pxsifJzMDFESEcYKNZ5syL6A0PvAMbPr64RYE62Vbk2wBVF2L9ZL479GbME8tTxpmBQwBdCznLkO1JneqvXGailFjoHb6Xv+8MK1xlyCKq1BIUJzaVV1cVmTyFruwiLqZJhfrxWmb6/dQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729751075; c=relaxed/simple;
	bh=Vo/wcTEOkI+vQtIbP0J9VGaae0788Mru7biGcDzPgu0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=PjYAanISj5rSUjKVcDjx3RAm4LIS/ts32D5226VBsd/BweRjsTalwqmWdTmPGOxGRdfXatX6HnMmQJLzG2CcbkDUHj/kjZDtDw6A0T97O/0msHflb7c4Iz3KHFr+w6yaGjvF758gCQ/m7BEavGDQXRCwTeVMMNw4/Oj88rkoge4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Af0od5SX; arc=fail smtp.client-ip=40.107.220.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KrpttG6vq4LpQSp2mTmgnmZXZkeYp3l0gHzsJ6su1B/7oTvgBeU1nb3G8Oq2ciN40QumlEGJhSlUelJ5lvzwDp6v4/QTTKVlXRtDEGT5Kv2i7cUal/w0dZrSg5fdoCiSg+sF6hCAueZFCfQkDOVjzBYvdSv0+3b2sVwYpg7GD2bn8hdrJ5RitMqJgS6d7hGU31ULNZ/C/gl6rOHDDHnAKDkHs5WUWvmiuc246kVzap3y/lDdvKuIH73x7/Y9W4VmAMFlmdCHFCQRaNRk1UuIweqtOi2W7FNOzXp+QSoQ92Zhf5rLF673JDbyuXvk2nQKSdwTQBErQuMTvJeLW4vUwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1f5vN69gzwNV6DqaJdUf0mR4u2/xX16KbZzM5BsRaus=;
 b=VLIjhMqujpOvOFJ+dixdG7B4YzmjKC7Bsx5ylU/08y1Y4V02YPHkCGFB0DvpFtm+VKGy1yzorzAsH8e4Xn97Od2hqLKN0SRv+qztXXsh5E3vjOs5BxomszFMtRZGPdSxrjw10uoXCfW44iu/q494KiBpItmxGxStEgfnwUkFNykebMHy/uEa/obiZcPCt5UlpMMI/rUyd9zA4eqcDETQhegk4EhwqPuI/Wn+ojrFXKzXq+B+ewIWeLWP7DVIuaH6F19+blcTqVB1Ld6Lb8BWdMke0r3sRv5ReR6+DNM5LEHoAVB1ZOo2lhDhHxB74pt883xbSq+z9U/Pk/O5IKRaqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1f5vN69gzwNV6DqaJdUf0mR4u2/xX16KbZzM5BsRaus=;
 b=Af0od5SXeVG2qKDJ8Tf2r5EFwpZ+VRJ6WzNSX5pRNst/KFfQT4TWmXDB7awW/6qjCKg99jTynzOXyuRPsYk9kp/sL+1CZ9FjeHge8WiMf9TPg//7uJSVtT0yoF4h5aR5beFW4fs9OMBU/vfGnZsNfM88LTm/Yv86Fzzr6qmU7mM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 DM4PR12MB6543.namprd12.prod.outlook.com (2603:10b6:8:8c::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8093.20; Thu, 24 Oct 2024 06:24:29 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%4]) with mapi id 15.20.8093.014; Thu, 24 Oct 2024
 06:24:29 +0000
Message-ID: <33300e68-dde5-0456-2a6d-4fb585d188a6@amd.com>
Date: Thu, 24 Oct 2024 11:54:20 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH v13 04/13] x86/sev: Change TSC MSR behavior for Secure TSC
 enabled guests
To: Xiaoyao Li <xiaoyao.li@intel.com>, linux-kernel@vger.kernel.org,
 thomas.lendacky@amd.com, bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
Cc: mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
 pgonda@google.com, seanjc@google.com, pbonzini@redhat.com
References: <20241021055156.2342564-1-nikunj@amd.com>
 <20241021055156.2342564-5-nikunj@amd.com>
 <c0596432-a20c-4cb7-8eb4-f8f23a1ec24b@intel.com>
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <c0596432-a20c-4cb7-8eb4-f8f23a1ec24b@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN3PR01CA0035.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:97::14) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|DM4PR12MB6543:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c96e306-533d-4b21-ac55-08dcf3f483d8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZEIyNHBWUFVWRzRJT2hjYXo2T25DeTMrc1ZpZC8rN09sNFNlQlRVb1FpSk5C?=
 =?utf-8?B?bzBXOTdKN1pqQjN1VFlaZEFxVFU4ckJ6a2J0VHhGZzd5TUN6bUFaNVk1WGRR?=
 =?utf-8?B?VFExWjY1WWZ3ajFFOWhqV2hZVXN3VGk5dElUUnVkZmtOdW1RbEVCUzRCRHh4?=
 =?utf-8?B?OTRLYjk3NFA3d01XVnVHbEtlT0hBeVowcVlxYnZCVTROOUpCMlovcFM4czZL?=
 =?utf-8?B?Wmh6UHNuN3krUCtWVHdTcjdqZ1FUZXZCeHRNOTluYVlCS0pSZU9MeXF5Y3lI?=
 =?utf-8?B?YU93TDY5Ym9CWVRkTTNLNzVTYXAwQnhSU2pCQWNCQ3U4T3JKUy9kVDBKbmVD?=
 =?utf-8?B?eUFSanFrR2RWWUlhZWJlVGhwWVIxWnNURTNNMnVzU0kzZEpqQUgzejJZSEN4?=
 =?utf-8?B?K3B5ZkJwZDdNYUFGeng0WWtFWVJPRy9JWWl3d1d1dmV5UEp6UE8xbXRoTGhH?=
 =?utf-8?B?dnRGTXk1d3VWdmRpUVRoQjZ2RlN6UkpJUmJGMThmWDllcTg5VnJDa1hoOUFU?=
 =?utf-8?B?ektXd0xrdFdDRlN6UkN0bUJMRjAvL2pUajI3bFdzVHNFZ1lLN0orMHZ3aXF5?=
 =?utf-8?B?TGN4YTduUkd0bVdxUlZZMjNNNG5aeUxRcGZ3bFIzNFdCeTJ0MkhmZUtjR0k0?=
 =?utf-8?B?TmNBL1ZzeHE0MllsbUcxb0pCcU1Velk0ZVVqN0lmSE1CMGxlWGU1TC9YNnZG?=
 =?utf-8?B?OTI1U01GYzB2ZFc4azdTOVM1d2dLMUdOWEpRejcxNFdiTWl6QnY3T01PMUUr?=
 =?utf-8?B?ZEZ4QWdkNk14WkF4aWErOUdOVm1yRVplZEpDY1ZUZnZTVWJhdmpEbWlkSFBs?=
 =?utf-8?B?SGNXYUhGdFFWUVU1UHVyM3ppdklVcHhWbFo4dnh2VEZRcXRQV1Rub2U5QUl6?=
 =?utf-8?B?aWl6blVDSUJ0M3U5Rm5JOG52ekxLb3FZV3Y5ci9oVXNJenNmakFOUk5SaW1M?=
 =?utf-8?B?elIzTTRBOGw5bzNkZDdiNWNERTJuZVMwOFdpY1d2QTdQVzRjemVubWlPQlV4?=
 =?utf-8?B?OFJMSnRUSTdYdDN4aGtlQ2dUeUxtYXFWNjJxNk56SitsdWZZQkhsMGlFd01X?=
 =?utf-8?B?RkRrMVZXYXhEeHF2czA4ZDhVeFpkUnF2RmxXZTdqOFBldTk3Rjg5ZFRVUGRs?=
 =?utf-8?B?U1c2MTVKcEtXZHptOG5IV28vZExxODhMRFppaDA5aGt3dHAxcC9yV1FKUG5o?=
 =?utf-8?B?Q1JSNGJQQ01xUExXVUoyVXNSOXJUdjgzYnFqZmZ0MjA5RElVK211OXhmTHZt?=
 =?utf-8?B?Q205d0kwdU16OVRYbEtNWU5vSkFXQWlpbVlVQjJlK3RVRDYzeEZwTHo4aTJK?=
 =?utf-8?B?cC9PQkJONTgyN3pHdDJ4OHhVRnlVTzBWZEpiQXZkQVpQU3JUZXhDWWlBbUZy?=
 =?utf-8?B?VmVJZnkxN2JmOTRQL3ZBRnlwZm1HVDF0NzNUSWtxOFVWTnF3SU9XYU4yM3VG?=
 =?utf-8?B?ZWtpVVZXd2V2U3Z6RVFmSXBDMDFTQmMzZXJSOTJKL3RzN3RRalhTb3RBL1lM?=
 =?utf-8?B?TXMwOWVlNjJlZ04yL2xUekliWWZsOEUxbGdvVXF3N3dsOUQ4WVRjVVpRa0NM?=
 =?utf-8?B?MjhqNko5YVBQL2xHblNDU0RsaVNJeVlEMHNiWksvS0xUbFVzcUZ2V1F3YUVF?=
 =?utf-8?B?MlcvOW1acXppblkxZk1HSVY0N3ZnZ29oMmRWZmwyakp4L3hRUTVZY1dPNzlL?=
 =?utf-8?B?YndyeTZhbDE4UHQwV2R6U0V5M3FXVWUrRjQzcjdlZ0lPbXdWSCtjRUZVSFpi?=
 =?utf-8?Q?KCzDH2jb8SA4Gvgaj9eGlOw4cWm2/P9U7OjUShr?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SkEzNkJMWnA4Si80bWpCVGNnbDhtZngvcmxXUjNUcUNZcjBQZ0t4YVBwb3VJ?=
 =?utf-8?B?cDhyUzB4RjVxdmRlcjh6VStjWXFoQVZHZjZnTFRFRkhTN3I2L3AxNlhrWWgr?=
 =?utf-8?B?SUFzVE5KMno4ZExWd1p6ZENJTW9VdG9jdnJzaCtQYWQ5MnpnMCsyR0N6aGNE?=
 =?utf-8?B?SStWOUVrZVlTUG41RFRZb0VUTlpyTVoyRU83Si9EbUhmZ29VZXI5ZDUwZEt0?=
 =?utf-8?B?eUdLUWpERFA5RGNFQWx3dUVWWVhHb0xQenZtV0FyQjlpcUlFdVpKSkF5eCs3?=
 =?utf-8?B?V1FOcEQzZXRpWkJYZTlVZDVsVjJKZ1lBN2lic1FPR1JKS3B0QURtaHM2TG5Q?=
 =?utf-8?B?ajFSNHR0SnF4aUJNNk1EYkxyMEFwU1RwWXMxMFkwS3JJWWJrc3FGOHpaUmFN?=
 =?utf-8?B?TUhZVnM4NWRGNEQ1NW5uSkVuNXhNcTNtZ3RjZHpEOXluNURWbTRtZFAwcUlM?=
 =?utf-8?B?SUNZd01lSk9UWEsrQ1pzWGpVRmFOU0tYbmFqRGtxTzBLOEsrclBjOVl6d1A2?=
 =?utf-8?B?ekVtSHZnOVFUNUp1NzRuS0lMdjA1ZUQ4d1RXeHpVQkJ2MDZYb2ZhelFtUnVi?=
 =?utf-8?B?YUQzdEh4QVJHSUhTNk1zaEY1RE92ejV6SXRiMmlpTEx5SXNGZ25WdlNsRGxC?=
 =?utf-8?B?c1R1eGU2U21KNDZ5Mk1NdGxTRDZwbGprdjg1bnJXT1lKamdMZXhHQU1IVTNM?=
 =?utf-8?B?KzhLdDdrdzU5ZFVGa1QvTlU2RUxNKzRzbUI3YmFjYjVUZ0NiYzM3Z2hweWxp?=
 =?utf-8?B?NnRycHpYY0lLYzFmWTNCcUFBT2dGRmEyU0JXK29FUVpaTzduQVF5WnRIR3lV?=
 =?utf-8?B?dUNXWmhRYkJQUm5wRWlwcDlYTVhKQnM2WjB6aXRxK2hWc241YnVud1Q4V01G?=
 =?utf-8?B?dStXeHl2Z0dBZ29BLytuRWJYYnFUMXFjTHJHV25qU0FTdG9DV1c4aWtBRkRT?=
 =?utf-8?B?MmdXR2tiNjh5N1VsNjF5blU3R0x4SVhJTTFQZ2JLb0tWSElnM0xQRHZMemZ6?=
 =?utf-8?B?eFJybU8yckFpTTJRZHFjM3NUS3Ixak1oNlI5TGdKK0tqbGp4TnFVY2RZUXVh?=
 =?utf-8?B?R05UQW1qbm4vaFRCb21rU01jS1VXUkpjQW1BUDZnYkEwa1V1SUhQR2tzcTF1?=
 =?utf-8?B?MmtXUjRjS3g1c1cyek43cGROUjdBSWFvU1Z6YitMeDBjL01LTTF4aU1VOUln?=
 =?utf-8?B?Q1pObzRCQjZoM3pVVjhUUkRlaTl3WUtCZTk4R1BEOTJQRlNYZmxKSExDMjRH?=
 =?utf-8?B?aXJJVDBKZm41WUR0QytmR0czZmNjM1ZkTjUzaXBFdmhOVktFUm0waFErSnJ3?=
 =?utf-8?B?NTRKQUY4RUlpaTlIakRWT1I0SVRudHJXMkdUVnFjVVY5bW1DWlIrbFpmWERD?=
 =?utf-8?B?NlM3VnBqMUhsekVOL0pXb3BvaksvQ1ZSS0JTTTVIV2FFYk9ad3RYOXREa2hu?=
 =?utf-8?B?dzEyd0NNYjJSQ1ZBaTA1cnZvZnAvMXJ3SkNTczY3LytvSlpndlRxTlVBNGhs?=
 =?utf-8?B?dWdLYmJmM2lrVGZkZk1hL2NCRHV5ZzZHT2J0N3U3Y1NvejlnUHpocGpmWGZs?=
 =?utf-8?B?ZW1YVks0V2xwRUtQV1l5VlhyRGEzY1hyZHVSVjl5ZmdnM2UrQUxYcjdXQUxv?=
 =?utf-8?B?SHJ0VytUR2Y5Slg2N3A4Y2hjYS9ieStLcndUNS80dE45Q0tkV214RU5iZlFW?=
 =?utf-8?B?c2xPODUxdkJSWEVOQmt4di9oRy8zdWRrUUVIZlhMTVRtcmx3RmlRdU9xbXVm?=
 =?utf-8?B?MXFNTGpPNnpwWURYYy9lc3dJOGFWWE9ZMkkvN00wWW1mcGVXQkY3aTNEakc5?=
 =?utf-8?B?N0oyaVNhS0NTalcweGtNTm93L0dMVjVoSHdCejJlU1VocHVKNDlWZWl6d2hr?=
 =?utf-8?B?RWRCVmdsNEdpakxLYnJ4U0hJR29wL3REUXFOeWFWUGZvaVZzWlVmNDBVRDZx?=
 =?utf-8?B?Q1pyaElyZTY4V3Mzc2xYU2NVTC8rZEdHaVl2QnZSckp5SUJETlhjSjgzeUFR?=
 =?utf-8?B?RTNYVjhZeG4yN1c1dk1yblhudVBxRDltV0VQcmE5akxmbnRHMlVhdzBCZWdH?=
 =?utf-8?B?dW5VRFpIT0o5SmxGRzhtV0o3UHkzeitVcVgwWWxZTnlqRE9rUDlnaEJFRDV0?=
 =?utf-8?Q?ixaXyecG4NueCEE2ZuHp3tDGE?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c96e306-533d-4b21-ac55-08dcf3f483d8
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2024 06:24:29.2789
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b0m/Q+mR/Q0k6raXxuORvvak9U+7p8VqkcJSSET38fHSmHdxPHjsDIiKXkh+GCtt9dKnEqVyqFcrIUeu+1fKUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6543



On 10/23/2024 8:55 AM, Xiaoyao Li wrote:
> On 10/21/2024 1:51 PM, Nikunj A Dadhania wrote:
>> Secure TSC enabled guests should not write to MSR_IA32_TSC(10H) register as
>> the subsequent TSC value reads are undefined. MSR_IA32_TSC read/write
>> accesses should not exit to the hypervisor for such guests.
>>
>> Accesses to MSR_IA32_TSC needs special handling in the #VC handler for the
>> guests with Secure TSC enabled. Writes to MSR_IA32_TSC should be ignored,
>> and reads of MSR_IA32_TSC should return the result of the RDTSC
>> instruction.
>>
>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
>> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
>> Tested-by: Peter Gonda <pgonda@google.com>
>> ---
>>   arch/x86/coco/sev/core.c | 24 ++++++++++++++++++++++++
>>   1 file changed, 24 insertions(+)
>>
>> diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
>> index 965209067f03..2ad7773458c0 100644
>> --- a/arch/x86/coco/sev/core.c
>> +++ b/arch/x86/coco/sev/core.c
>> @@ -1308,6 +1308,30 @@ static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
>>           return ES_OK;
>>       }
>>   +    /*
>> +     * TSC related accesses should not exit to the hypervisor when a
>> +     * guest is executing with SecureTSC enabled, so special handling
>> +     * is required for accesses of MSR_IA32_TSC:
>> +     *
>> +     * Writes: Writing to MSR_IA32_TSC can cause subsequent reads
>> +     *         of the TSC to return undefined values, so ignore all
>> +     *         writes.
>> +     * Reads:  Reads of MSR_IA32_TSC should return the current TSC
>> +     *         value, use the value returned by RDTSC.
>> +     */
> 
> Why doesn't handle it by returning ES_VMM_ERROR when hypervisor intercepts
> RD/WR of MSR_IA32_TSC? With SECURE_TSC enabled, it seems not need to be
> intercepted.

ES_VMM_ERROR will terminate the guest, which is not the expected behaviour. As
documented, writes to the MSR is ignored and reads are done using RDTSC.

> I think the reason is that SNP guest relies on interception to do the ignore
> behavior for WRMSR in #VC handler because the writing leads to undefined
> result.

For legacy and secure guests MSR_IA32_TSC is always intercepted(for both RD/WR).
Moreover, this is a legacy MSR, RDTSC and RDTSCP is the what modern OSes should
use. The idea is the catch any writes to TSC MSR and handle them gracefully.

> Then the question is what if the hypervisor doesn't intercept write to
> MSR_IA32_TSC in the first place?

I have tried to disable interception of MSR_IA32_TSC, and writes are ignored by
the HW as well. I would like to continue the current documented HW as per the APM.

Regards,
Nikunj

