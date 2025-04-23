Return-Path: <kvm+bounces-44022-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9479FA99B66
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 00:20:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CA3894459A3
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 22:20:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CF4A1F7075;
	Wed, 23 Apr 2025 22:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="JcJRI2ZI"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2076.outbound.protection.outlook.com [40.107.96.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D8A41ACED3;
	Wed, 23 Apr 2025 22:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745446795; cv=fail; b=UQQN1/Tl9JO+t0h+WOZebIgsJ8Q6lI7xEjwULTGGn25g/TjiTY6t0ZEjjesxq+EXLEwpYAJRMdRbKdy1sokiu11jXWsG4Js5RyEj+2+R0er4dBFeH3wsmtIh0duKcek51Hch0mXbOoGwBE4pArZ7Eu1ZVqdcO3QVUZcWOORjYXI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745446795; c=relaxed/simple;
	bh=tgt7M/MWjSGTuGemgtlnxDZSgEO+gFjz05VH49mDtHA=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=eJ3edL4k/5TWJzrUkFt65fQJm4b2Xr2mrp97qPLyNIgpMlIwY8V6k0YX3YLmXCNF8WavCCOsZnYbYeZJE6t8n2ndPEzuNElY8YEpneU4xFiaII/RpeVMOLx0ZXjOXDi91vR1+RJrqXAmF21Cuys3hC/DdfIcLC2LY0hs94No/ac=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=JcJRI2ZI; arc=fail smtp.client-ip=40.107.96.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OX9B1EVqsXD0fSJJo7xF0ajLxzkQkaPvL9Xah5PXhRh6+KFnzNhYAV1X/Wgr88kRDHhNbXlQBzCvxgCE20LuJX23HeXFtVEPhHplCzk3laHGqXl5K7fzC2bTC3WHaQo2SC2ueIaETehdhadN11/2SfUj6qfI02Ild7CdxLU3nYMyuI7ecxeV2qqdGnVEFvuH15FzsG9Rv6GSLYtK7XtKIP7d+JkRw+6+JVCtqcPVzNV4tthFFEsRyKd1xy6Sput4THfdgfad4o6TuSmMUFI9avtQAgc9KEX2S/mxCuTUheNQzu3G2+cnivvvgflW/pvzWl1ZrifYTTC8YappXV4zgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7rJGJ6wrn/AWFe08ug3WSDqPwd07ENZ28zcBKqNQkJE=;
 b=DGbQ+GTJrhoCjl1HvkwyjYnt6Lhh2U7Vi1pagg4dbOWIeP4enZC4JYpQYWy3bGWaq2oXXG6u2GMf9BgpGXFeOewaMH8kERk++NpYAg2jq4OHAP5VNXxEKOdIGCEJ/kfEP/lUkyHcJ6xBAHztDOOoYCdDmE2IUj3kbPd12Rfh2efc1O+nryLhWwV0Dj3lwaZYEDnsXF3elUjIVkVERSs6UzZqLx6aA+JfE687CTFUxzRlxhXYUbN5WFeYmokjgeWBFPyFR2EmhwtDeO/mGspN3JQprjHZUtGJY7y5V9AiMpHPExitt+zcbYJidDfhOyvOBDH61GQIhBl0zLorpfyd5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7rJGJ6wrn/AWFe08ug3WSDqPwd07ENZ28zcBKqNQkJE=;
 b=JcJRI2ZI7hWGkfpUXZITyf/HZgSCs/Z9JXnZtw6OcAAyvomXVhxHp5aDEG6hifhkHyIf4Y7HuZ0dqXYqpYyAloZSDEkYMuqlaZg5Z8gbt8PzvY22pORj+LwBmOPxsynCxLUHmUSprijzOzDf/1eMrD8JVd9fqXZk6bnEjqrcGsc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by CY8PR12MB7756.namprd12.prod.outlook.com (2603:10b6:930:85::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.23; Wed, 23 Apr
 2025 22:19:50 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8678.023; Wed, 23 Apr 2025
 22:19:50 +0000
Message-ID: <9bbce4d4-fc65-6b58-a4fb-ffb28a1180f0@amd.com>
Date: Wed, 23 Apr 2025 17:19:48 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Ashish Kalra <Ashish.Kalra@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, hpa@zytor.com, herbert@gondor.apana.org.au
Cc: x86@kernel.org, john.allen@amd.com, davem@davemloft.net,
 michael.roth@amd.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org
References: <cover.1745279916.git.ashish.kalra@amd.com>
 <94ffa7595fca67cfdcd2352354791bdb6ac00499.1745279916.git.ashish.kalra@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v3 3/4] crypto: ccp: Add support to enable
 CipherTextHiding on SNP_INIT_EX
In-Reply-To: <94ffa7595fca67cfdcd2352354791bdb6ac00499.1745279916.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9P223CA0014.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:806:26::19) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|CY8PR12MB7756:EE_
X-MS-Office365-Filtering-Correlation-Id: fed6b764-9493-4c7a-6015-08dd82b4f6da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SEZ6Qi91YlRmLy9UZC8wNWMrL0VscExqbkhsbnY1T2ZmVTAwQXU4MTRmVFpX?=
 =?utf-8?B?UWdlZE5pTjViWE9nVzBxMk9lcE96a0RuMkVVZXJ4VW5JTmZ1NklXejNFZTgz?=
 =?utf-8?B?aFk2ZXlNUjJxT0p1aTJOR1QwSHBzajJBS1U4MUxUcXJCOUsyeFZKWWJCM2hD?=
 =?utf-8?B?S3QzMEZaMGEzWHZkNnAyNnV1RTMxeGlpNVpYTEVYQ0FpK1V2OG9rUndEMVIx?=
 =?utf-8?B?ZmxxMlBDTGlpa2pLc2RSa2pwZHI0STBNMEdGTERJeXlkNFUwckdLbStnMXdk?=
 =?utf-8?B?OWZGYWE0amFKTlIzTTN0TjljMWI1Q1dERWs0d0JETzdoNWFSRU1ob0JZdjJX?=
 =?utf-8?B?eVRYV0E3dU52SnFKY2VQUWIvZ0xQVGNhengwRy8rZmpuLzZZOEFNL3JtQTZY?=
 =?utf-8?B?QW44bWh3bG9PeXZsb2V1LzRuNTAxSUZFeGFCOUZ5eDlOUzI2TytHeW5wTlhv?=
 =?utf-8?B?MFFNZ1VpK0hLNlJwejh3RTgzRUh1R0s2UGtackJOeVdGaVdLWXdTN3hGNDJQ?=
 =?utf-8?B?ajhtQjJWM1VJd1IydEJHVkdMb0JRSHVKdnNwcmRJZUFneUNURHhZNHJBeXZL?=
 =?utf-8?B?bElHSzV4c2Q3cnF3Z2ZHa0pCUDZZM3JmQ2tkaE5HWXpQWDMwaDIwcEhTbkto?=
 =?utf-8?B?WGFPRGJVclRDcDdPejVtYmwyU2c5RlNpeW90b3BOb1lCQk05eXo0cjQzQUNt?=
 =?utf-8?B?RHBWMFZBckFwdko1UTlSOTJ1UzhJRTNESFNQOURYT2E0WFRhdHpidkJQcWVP?=
 =?utf-8?B?Q05DNC8wRjZDUVc0SkRweGx2TWdjajVaS0pGSFlJZHN3czVGVm1ORGVXeU1X?=
 =?utf-8?B?eFdmU0tWTU1kdDVxcHFGT09kYWViN3A5dURyVlZiR3lOSllqQWoyNm5vdlBm?=
 =?utf-8?B?ZUlRc2FndWNhUm5BSlIrcnVYNG40SHR5ZTYzamxmTGFxQWdUMFZrYVlKY3ht?=
 =?utf-8?B?b1UxZENiSDQ1S1FhQUlKTzluMWhnaHYzRVlua1V1TE1senVMeVFSZHBHNFlW?=
 =?utf-8?B?MGQ1aVF4TmF4a2VBTE1uU3RqbFBZZjE4bm1VNkhBQkVWRXRFRS9tTndmRm1P?=
 =?utf-8?B?RTJxbjdmWWZpRU9vRXRPc1JNdDFSSU5hc2ZxbmQybm1mSnZqcVRRb1NUTWxB?=
 =?utf-8?B?L0lGTGF6Ly9PMWt6SVdzZHRkdjRXNC96VWJ2Unc1cDJ6M0ZrcXF1MFMrZmJQ?=
 =?utf-8?B?VlN0SDMrRUlsV2plTkp6Y2VDejFHblVpcTNEdGQxMUpDamI4aldVT1BLUE9r?=
 =?utf-8?B?a3U3czhkb3RadG5MeUVObnJaUUF5MVdHMXpIaHM2NHBoWnJsdjBOdXp6RGxt?=
 =?utf-8?B?aysrUFJzcDVaMkl0RHVmR0RFaC82QTFCVHJZZkZvdXZPOStVZlVFb24xMEF1?=
 =?utf-8?B?U2o3R2YwVU5nWjk4ZVUwNkF4b1BNLzVrU0ljNUpSekJtcUlCdE9SNVcyNWM1?=
 =?utf-8?B?M3l0cXNwbk55OVJkaWtuOGlUOHUzNnpnbGY5ZHhKZXRwQjFGelhHcWZNVzVJ?=
 =?utf-8?B?aE5NTi83NW9WTEx5cWF3NHpxU2tTcFB5T0JjRHhZYkJIeU9PdytTNHBGWWND?=
 =?utf-8?B?MGNUanlaOVFLL2pnc05tUE5YRnNlMi8wZDNwa1lIOGdDTCtCUElkZytGd3hs?=
 =?utf-8?B?TTFPbFdvWVBVVXcvYkJreGZoRDQ1SVdpODJHQVBhSDRVYjd6bjNzRHBjSHBw?=
 =?utf-8?B?WUZLNm9sbUROZDY1K1Nac3pnNmYwbzV4MjhybUZ4MzJZaVpUdFJiYk16K3Jn?=
 =?utf-8?B?alFLSVFjcXgwNDhST1lKaW9xWUxvQXd5MEtHVlpNZHdMbEp5VFRVSVYzZmM4?=
 =?utf-8?B?SjI5YWkveXY5OHJwSThkcTJ2Z25JVnpwa3grWm5pbkNSNUkxOUZYUEdmdTJY?=
 =?utf-8?B?dG00Z1BNbE9rOExTY1NmeC9hUVcxbmRTRjA2OVNQc2xOazFSOFdNRlFKVlFH?=
 =?utf-8?Q?cwmSq4WAqJ8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MVBEWWFoRllGejY5QjlxWnF5WHUrVlBxUFhmTFRGeDNTblJ4MG9zVWRrUkZQ?=
 =?utf-8?B?NUdzaUxnckZHbHhobmNCTU9qc1FNK1g3UVYvUDZCUHFFOEVhVFF0YXl3czQ0?=
 =?utf-8?B?MmxiL2RxMWpxaUxtZFE5dzRJcXl5YUVtelV2TlAzbkJhZXp0WFg3dU4yTUoz?=
 =?utf-8?B?SHVVNDNEMTVIMVJ4RUFQcHh4a2gzYnJmWWZpZmVRMVVKVHZvZ1VRa0hyN0F2?=
 =?utf-8?B?aHgyZzFOQ0lRUllzbTkvd2xoUTBmbTY1Ry9Dbkx1aHJFcDZ0VVlKODBBOFJT?=
 =?utf-8?B?Uk8yQjViZnZtbnYxOUVBbVNQSytnVzBZRHhZZURpbW9JbzNFcGJwb3lSVGxp?=
 =?utf-8?B?OFlqTFFWTHR0MCtnQllucCtVVHNWcE4rbnIyYkVlSzlMaU9Lcm94aVU5YjhT?=
 =?utf-8?B?MXhiekJra291Mm5uYThZaTZqdDNlZjI1QVZ6cnk2ZjhLOCtUYXp6M1gyT3pa?=
 =?utf-8?B?WkRMSW1HUnI4RUlncnQzZExiamgzS1AzbFRZMUdCZDRTSzlDdk1aNlBRQ3Ri?=
 =?utf-8?B?SGp2dHFIcXhXYWNHdXR4THpuNWNyUitqN1VmMFdrc01DdnY5VjdRZjRvd0dh?=
 =?utf-8?B?cjYvdzlSQk1LbjNBR2ZWamNxRmh1dS9EQ0l4dUVrOVBaT3pDazRocWFWRlVH?=
 =?utf-8?B?U2NTaS9nUDhnTWRGUXFmekZXL3kyZ2lCZHZuK3pla3JYWG9naGJrUFRCU2Q2?=
 =?utf-8?B?U1ZaTlpzelBIcTM3WUVYSThJamphOHNPQWZleEErQVFxS205MXNFa2U1SXY1?=
 =?utf-8?B?MzVBQWhHamU1Z0gvbUcxd1UrOXl6R1YyQkFKbW1HQy8wTm01WjRPRmJQSHlZ?=
 =?utf-8?B?WktMaWJ6WkFTdmhveDNLd1FEVjEzVTZYTjN6WmJyRzFjOHJMdXhGMllnS0Ro?=
 =?utf-8?B?L0d5SWhFNi9TNEhUT0FGRFVTRVFEQXVaVEhLZlJPUjNMS0hObFpzd1FsTWFv?=
 =?utf-8?B?U0IrNm9DREt2NGhBaS82SnRXUUY2cmt5SkR5ZnFveEFRYm1zZ1puYTJBOXZD?=
 =?utf-8?B?QmJkS2VEeElGbTIyQWQ4Vm9iVENzTGhpSkppMzdQazRCRzNKMzNkbk81NWFk?=
 =?utf-8?B?dVNXdTVzdmVEM0NObDNtSFN2OXZZNWRlRlpMUWkxNTFhalBFK0N6RHhwZHhs?=
 =?utf-8?B?TXE5bXhNS0MwWkpyT01WV0VBRUQwMGdXdW8vcjRYRGpOZDZlOUVoQi9CQ0E0?=
 =?utf-8?B?aENvS0hwWVVjblhGS0VjNGJ4Y21rM0w4bExDcnEzUnpuaGNKZkkrMzBrZ2c1?=
 =?utf-8?B?M3VWM1B3U25XOXpPR3NFdTl5a2w4bmFyWVpCRmJYZmVRejJQc0o4T21ZWnF3?=
 =?utf-8?B?Q1NWOEdhNlo0c0RqcnZ2RndRTjZtSEZBRGU0MU90QUQraHFSeWpDNThodnJU?=
 =?utf-8?B?eEtqaVFyYnNEKzJlWkJmY3pKUjBwdnhkY2ZNN3o1VWlRQ2F4TG1wRVhvdFFO?=
 =?utf-8?B?T0x4SlpmZzZCUDdpUFM0dEFYWjFIcDBEbks2djVPOWZlcENaL1FzcDdhUXJN?=
 =?utf-8?B?VjcyNFpWNFpvcEJuTUJNNGp1TGl6enZjUGNOaGs3UUdaTDFEQXp4SG03bDEw?=
 =?utf-8?B?Um9UbFZibEh6REUvL3dES090Z1VZMlNPY0tVanExZGM3azZ1UmlkZWtKMzFD?=
 =?utf-8?B?UWdjeWhkeXBwTXZBM3RlSFJ6Vm1LUHdSOVFEUk5XY3NGTlRGL1Y2VUdqLzds?=
 =?utf-8?B?ekdXa216aC9adldzVW9MTElZZkRZL1M2K1ZWb3hYc3pFMGRUZkpDb3RMejB0?=
 =?utf-8?B?dEZ1QlNFdDUvZmo5OEQyRFVmc3dMNWpKanQ0TVU1YmtGdXkxNHBwTHhGQUlV?=
 =?utf-8?B?bVl2eDZKb0ZyMWUzdnJjY2k4NXBwOW95UzJXdFBjVUxoakozVENaSEl2OWIx?=
 =?utf-8?B?Uk4vZFlmZ0d6UjhrRTU3MEZkcWF5K1lSSlBpa3lyRm9UMmNROG8yZ3JHd0Zp?=
 =?utf-8?B?aElIRnVBZmE3b0tNZUdSN256L1dxWisxcld2dHZvVmFoa3dtRFRWSjY1TG1E?=
 =?utf-8?B?cjdOOXFLdzVuTElSWXZFS2ZoaTZUazhQM1FRSUVlT21qc1Y5ODNhSm00OUMw?=
 =?utf-8?B?K21yL0lOQ0FoUnBrOXBvOS9uRkhGVmpnV29vaXlleDRWa0VCQWt2UkNiN1Zw?=
 =?utf-8?Q?XWZJs+/tCTNepfjF4r+t7IcaI?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fed6b764-9493-4c7a-6015-08dd82b4f6da
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2025 22:19:50.5624
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I0q66iufJ26QVjZcahmkh+UXQGIbKCfvyhPViHhSnKbJiA7piS8aC1pALL4O8jT5mdMGYu7AHGuNI9a1FsiJFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7756

On 4/21/25 19:25, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> Ciphertext hiding needs to be enabled on SNP_INIT_EX.
> 
> Add two new arguments to sev_platform_init_args to allow KVM
> module to specify during SNP initialization if CipherTextHiding
> feature is to be enabled and the maximum ASID usable for an
> SEV-SNP guest when CipherTextHiding feature is enabled.
> 
> Add new API interface to indicate if SEV-SNP CipherTextHiding
> feature is supported and enabled in the Platform/BIOS.
> 
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  drivers/crypto/ccp/sev-dev.c | 31 ++++++++++++++++++++++++++++---
>  include/linux/psp-sev.h      | 18 ++++++++++++++++--
>  2 files changed, 44 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index f4f8a8905115..ca4b156598de 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -1073,6 +1073,25 @@ static void snp_set_hsave_pa(void *arg)
>  	wrmsrq(MSR_VM_HSAVE_PA, 0);
>  }
>  
> +bool is_sev_snp_ciphertext_hiding_supported(void)

sev_is_snp_ciphertext_hiding_supported

> +{
> +	struct psp_device *psp = psp_master;
> +	struct sev_device *sev;
> +
> +	sev = psp->sev_data;
> +
> +	/*
> +	 * Check if CipherTextHiding feature is supported and enabled
> +	 * in the Platform/BIOS.

I think this should be expanded a bit to indicate why both the feature
info and the platform status fields have to be checked.

> +	 */
> +	if ((sev->feat_info.ecx & SNP_CIPHER_TEXT_HIDING_SUPPORTED) &&
> +	    sev->snp_plat_status.ciphertext_hiding_cap)
> +		return true;
> +
> +	return false;

And then just make this:

  return (sev->feat_info.ecx & SNP_CIPHER_TEXT_HIDING_SUPPORTED) &&
	 sev->snp_plat_status.ciphertext_hiding_cap);

> +}
> +EXPORT_SYMBOL_GPL(is_sev_snp_ciphertext_hiding_supported);
> +
>  static void snp_get_platform_data(void)
>  {
>  	struct sev_device *sev = psp_master->sev_data;
> @@ -1147,7 +1166,7 @@ static int snp_filter_reserved_mem_regions(struct resource *rs, void *arg)
>  	return 0;
>  }
>  
> -static int __sev_snp_init_locked(int *error)
> +static int __sev_snp_init_locked(int *error, bool cipher_text_hiding_en, unsigned int snp_max_snp_asid)
>  {
>  	struct psp_device *psp = psp_master;
>  	struct sev_data_snp_init_ex data;
> @@ -1208,6 +1227,12 @@ static int __sev_snp_init_locked(int *error)
>  		}
>  
>  		memset(&data, 0, sizeof(data));
> +
> +		if (cipher_text_hiding_en) {
> +			data.ciphertext_hiding_en = 1;
> +			data.max_snp_asid = snp_max_snp_asid;
> +		}
> +
>  		data.init_rmp = 1;
>  		data.list_paddr_en = 1;
>  		data.list_paddr = __psp_pa(snp_range_list);
> @@ -1392,7 +1417,7 @@ static int _sev_platform_init_locked(struct sev_platform_init_args *args)
>  	if (sev->state == SEV_STATE_INIT)
>  		return 0;
>  
> -	rc = __sev_snp_init_locked(&args->error);
> +	rc = __sev_snp_init_locked(&args->error, args->cipher_text_hiding_en, args->snp_max_snp_asid);
>  	if (rc && rc != -ENODEV)
>  		return rc;
>  
> @@ -1475,7 +1500,7 @@ static int snp_move_to_init_state(struct sev_issue_cmd *argp, bool *shutdown_req
>  {
>  	int error, rc;
>  
> -	rc = __sev_snp_init_locked(&error);
> +	rc = __sev_snp_init_locked(&error, false, 0);
>  	if (rc) {
>  		argp->error = SEV_RET_INVALID_PLATFORM_STATE;
>  		return rc;
> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> index 0149d4a6aceb..af45e3e372f5 100644
> --- a/include/linux/psp-sev.h
> +++ b/include/linux/psp-sev.h
> @@ -746,10 +746,13 @@ struct sev_data_snp_guest_request {
>  struct sev_data_snp_init_ex {
>  	u32 init_rmp:1;
>  	u32 list_paddr_en:1;
> -	u32 rsvd:30;
> +	u32 rapl_dis:1;
> +	u32 ciphertext_hiding_en:1;
> +	u32 rsvd:28;
>  	u32 rsvd1;
>  	u64 list_paddr;
> -	u8  rsvd2[48];
> +	u16 max_snp_asid;
> +	u8  rsvd2[46];
>  } __packed;
>  
>  /**
> @@ -798,10 +801,16 @@ struct sev_data_snp_shutdown_ex {
>   * @probe: True if this is being called as part of CCP module probe, which
>   *  will defer SEV_INIT/SEV_INIT_EX firmware initialization until needed
>   *  unless psp_init_on_probe module param is set
> + *  @cipher_text_hiding_en: True if SEV-SNP CipherTextHiding support is

s/is/is to be/

Thanks,
Tom

> + *  enabled
> + *  @snp_max_snp_asid: maximum ASID usable for SEV-SNP guest if
> + *  CipherTextHiding is enabled
>   */
>  struct sev_platform_init_args {
>  	int error;
>  	bool probe;
> +	bool cipher_text_hiding_en;
> +	unsigned int snp_max_snp_asid;
>  };
>  
>  /**
> @@ -841,6 +850,8 @@ struct snp_feature_info {
>  	u32 edx;
>  } __packed;
>  
> +#define SNP_CIPHER_TEXT_HIDING_SUPPORTED	BIT(3)
> +
>  #ifdef CONFIG_CRYPTO_DEV_SP_PSP
>  
>  /**
> @@ -984,6 +995,7 @@ void *psp_copy_user_blob(u64 uaddr, u32 len);
>  void *snp_alloc_firmware_page(gfp_t mask);
>  void snp_free_firmware_page(void *addr);
>  void sev_platform_shutdown(void);
> +bool is_sev_snp_ciphertext_hiding_supported(void);
>  
>  #else	/* !CONFIG_CRYPTO_DEV_SP_PSP */
>  
> @@ -1020,6 +1032,8 @@ static inline void snp_free_firmware_page(void *addr) { }
>  
>  static inline void sev_platform_shutdown(void) { }
>  
> +static inline bool is_sev_snp_ciphertext_hiding_supported(void) { return FALSE; }
> +
>  #endif	/* CONFIG_CRYPTO_DEV_SP_PSP */
>  
>  #endif	/* __PSP_SEV_H__ */

