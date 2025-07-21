Return-Path: <kvm+bounces-52976-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F634B0C4EC
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 15:11:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 30C30188B375
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 13:10:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 287E82D9497;
	Mon, 21 Jul 2025 13:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="vFRnwaj7"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2048.outbound.protection.outlook.com [40.107.220.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 607282D6617;
	Mon, 21 Jul 2025 13:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753103339; cv=fail; b=Gfh549huVJIl9jau67Lb3knT9XpBHc2JLlVrQvkcvPeuwMXEdg6c0pW87JMrPmJY6/CLH+f0fDqFavpcO2jhkw5yI8uYp5QMeGtwi26dq+jSwkjE4udnxGzUDQzdh7uGaY6QJxZpa56v81jY4VbOf4YU4/v/Krf5RsmmPnVCjLI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753103339; c=relaxed/simple;
	bh=DXEiICrtc8oHfV/XICu7jV5d/mRT0BjEI1ArO/rlRdk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ivpCpK8YZ67TngJ9wnGYI/nywZ+1Qr1NVaPE6HSTS9R7JtxNhL86ISrq6BqJE44n0fyhD02SjfJiDeqI5MWzsabbOG4SwCEt821xjuZAC3Tyo6YrrybKg1prshmOPFccHKTV/fisetSZ+BF5Pv1aBF1LqMMy1szaU2aD/f8kbpg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=vFRnwaj7; arc=fail smtp.client-ip=40.107.220.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rZ/vmcX6e7mi1PyBia14znWxB/NkoP9hfa+Bn1bLHPxlfHbuAEQ0m4NiPGEsbqNu+QZAOm3SbziHKSBS9W/2eCVY/SzFsjnRey4UpFmWuRAydfxTL0FZZe5j1Cgmdim234yvPjkoYrXpJXR9sB1CgtB5IwNB6IRF5wmrlUszjsOap44mNum3VXqZe7hjN2ru5WYchapgnrz6H9gaNhkfqNflbjgtuo/Cw+stEMzqU2dBmTO1TW55076EgqU/DIvNgIwBvVJYQCPYMcBvNLY7W7qbbDwFfEdZyscWr2mcYBPWfY1J6cH0ufvriR0pLN3aadKEAj6vxprazSLtR/13FQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y4uNs1qKDtwDKD/g+fRl/yCBL+3wm40Q/5F1ASMa6Jc=;
 b=gs9EaD4jpkFljPMQ6CjaKzmizuUZ+TH69I5iApAZkMCx3IpcRsDZ8ecQx8+McgdI2dOV8nzra4kxTDX0YSZJQE7uPwY5TGRtsdcHh+0d3qMaIyEqzX72hsVs44xbo6NLNuqmHLqoV68SXaL/VKvKkvauM0L+QAH4F/KILJchx8rjud7cRkfpbcKzkksNwRgr4TobqClvnn9gwoVC8EUngT41qA0dPh413aHWae9nXlJUsct4NomQSzP60Ka2yIcyt6HaTHmP2uDjzVoVidpeZx05oM5hquo+VmWaJr/x7Fpe93R7Nk9Zu205hnxCURBmBsr9QZ005uoaDIrzffn1ZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y4uNs1qKDtwDKD/g+fRl/yCBL+3wm40Q/5F1ASMa6Jc=;
 b=vFRnwaj7nnaJY+9ZLmwu2Rnx1IVgLDFBaRNp4Y33dbcgTBD5jcqJF6jTvB2QkY24vdiDnVxK8xPM1Xc8V+hCAJOKko7FZR7VHOEWkA7I6CEQfYW3jD9X6WD+bN84HxkfLGeytkzQzXTA83RcCPndmM9U2dOGVxO9U0PKfqzG78E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by SJ5PPFDF5E260D0.namprd12.prod.outlook.com (2603:10b6:a0f:fc02::9a6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.28; Mon, 21 Jul
 2025 13:08:55 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%6]) with mapi id 15.20.8943.029; Mon, 21 Jul 2025
 13:08:54 +0000
Message-ID: <f999349e-accb-dcd6-75f4-eb36e0dda79f@amd.com>
Date: Mon, 21 Jul 2025 08:08:51 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v4 0/7] TDX host: kexec/kdump support
To: Kai Huang <kai.huang@intel.com>, dave.hansen@intel.com, bp@alien8.de,
 tglx@linutronix.de, peterz@infradead.org, mingo@redhat.com, hpa@zytor.com
Cc: x86@kernel.org, kas@kernel.org, rick.p.edgecombe@intel.com,
 dwmw@amazon.co.uk, linux-kernel@vger.kernel.org, pbonzini@redhat.com,
 seanjc@google.com, kvm@vger.kernel.org, reinette.chatre@intel.com,
 isaku.yamahata@intel.com, dan.j.williams@intel.com, ashish.kalra@amd.com,
 nik.borisov@suse.com, chao.gao@intel.com, sagis@google.com
References: <cover.1752730040.git.kai.huang@intel.com>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <cover.1752730040.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7P220CA0007.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:806:123::12) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|SJ5PPFDF5E260D0:EE_
X-MS-Office365-Filtering-Correlation-Id: 92397fec-5dc9-4c18-effe-08ddc857bea5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cHlONWhZb2xDbDdvSUJrem5zakErTVZ3bmh3RThQcjZGenFpeDlJclpLem1t?=
 =?utf-8?B?ZHRJRjRoenY2aG1icHUyTlRJaDlYRUlxUmVnUTFFazZaUHFXZkdQcHFid1kx?=
 =?utf-8?B?T2JFSjRPcUZDMWRBOHQ3WE1ZVXF6dktucS9NOFRFdEp3Z2JPQnl6d1pLNGVy?=
 =?utf-8?B?ZDVjbzNYT1JkNWpnUFd2L3k1SUR1U1UvWFIvdUtEYUU0U0NhdGgxaE5xa1g5?=
 =?utf-8?B?MmtpSzA4UFJYbTA1YmVqNDhYZTNtdUROQTlhdWhzd2VkVUZERDI4TnZIRTNX?=
 =?utf-8?B?VGZNRjkrYS95QnI4M3ZYd1B0NHpOMU4zUklzMDN1NUQ1dzVkTEhKQzBnUmlj?=
 =?utf-8?B?OWM4a2N4UFFRdzdkWC8xb3RqQis4OStoUE84eWp4VkRwb3NOdDdGdzduRm1Z?=
 =?utf-8?B?YXE4NmNFSlNNTDBXY2o2NXNXa3p2cWZmWmorV3BmcnpraEdyNWZwcXg2OVYy?=
 =?utf-8?B?MkphNnprMXg3clZMcUhjY0ZMQmFiM0ZNNU9NeXRPZk81U2RRdFVhL1RSZ09K?=
 =?utf-8?B?bmdPMk1lcytWelJUQXJvb0JCblBkeFFUU05rL01NRTF2S1NBU0RidWZjREVW?=
 =?utf-8?B?K2FLd0lkMGtjaUFlQWNHcHVUT2NCQU85UmVZbS9kb1hJTUlwMjVYNjZDdzRF?=
 =?utf-8?B?dldpMzlPME5laWlPNkdUUG95cnR6ZzA4dnVXd0NMb0Q5V3J6bkFZL0t4NmVK?=
 =?utf-8?B?aVlWdTdhNjdKZEhjRnBQNVRFWWpEVnpBSUxuK0RwaU9xNTZtTjgwRXE1dWNt?=
 =?utf-8?B?ZW41WjNKM2UwL3ZKOThxK3E3SklvbldqZHNXUGhiN2JmblNHTHpBdjhMQjY4?=
 =?utf-8?B?SzJYVkFrODV2RWNTblBYNVFyWWpGam5PTmdNSE5JeGNJUmNDam5yOGR5Mnpk?=
 =?utf-8?B?aWhNK2Y4RjRhczdzMTVKUklFTmM4UzJZNEdUNVdHS3d5ck1EMWx3a0FnOFA1?=
 =?utf-8?B?N1YyMHFvZGt1UGhBQUZtNkFnSExjcDRpb00xT2d0eGNsT3hUemNEZTVCWGRm?=
 =?utf-8?B?eVN3WnZSdmc1ZU9BUXl3SUZWQ3c3L2drNGMrRXlJK0NpNE94am8zbmt1RHlw?=
 =?utf-8?B?V3ZrYnVpUkswTTgzTDVlZU5oSElUYW5PaVZDNnVianQzU3VhczlGR2pNV1lF?=
 =?utf-8?B?bEFCZXNkczdwMkFjQWVQNE1BWE5IRmNEbTJ1KzFoa0YxdnpQZkhoWkRGYXd1?=
 =?utf-8?B?UU5FQXNkU1lhY1JyWG9ZVndGVGd6dGNBeWtjRytGNGdPSHQ0VHVnWFhLRERx?=
 =?utf-8?B?UUhheHdWMlZscFRZQ0FFWUdadjZjU29PTWxxVmZ5TjRoWjdCaUpiMkppZEdy?=
 =?utf-8?B?UGJrNFVsdHdocHhJcVd1NEdBR0pGbTNCeUppdWZsV1JrUFZMb2NsTE5yYm1v?=
 =?utf-8?B?eVdyaWJaTUduTUxqbE5nanU5RTdMeGJwd1BkWE9PZGdGSmpmZjRnZ2hLOTdo?=
 =?utf-8?B?YS9qcGtOODUrWlhXL2hCUkNONXNpZHVNaUlLSm1KZ1R5UGRXM0xrN1FKbHNW?=
 =?utf-8?B?WEE1b0RsaW04NkJlTXNEYVZHa0YrRHlJZkFKRFduenJBVHhGeVBoWmNkaFdU?=
 =?utf-8?B?TVhGeDU5U3B0NUd5Rm5hVTIxZkVGNTBlOWoyWGpNeVA4amtGaElCeXgzN2wy?=
 =?utf-8?B?Wml4bjhvazRLVWhJK1R4ZXFycVJXck9HRytLSkdCendNamI5a1Q4Mzl2elNW?=
 =?utf-8?B?YSt4QWx4ZTBQM2gxTnJVQTNMcXVNcUlQYnVkU1FqK3lVUWZGemMwR1RJZmxm?=
 =?utf-8?B?NU1yaW5KU25vcUg4dkpUSVJWSDNOMzh0dzc4OE10ZDVqb1RpdWhlOEpqZmJU?=
 =?utf-8?B?K0lCK1dyVlFodGhrZlNmY0Y4d3N1Y2dvVTJKcmlEK3hjR2pLT2xuKzI3cHJI?=
 =?utf-8?B?R3k5UGk2bUdDQ1FKY0dTOWhwVHp6NGhYd2ZkWW9Wa1FnNG45M1E1dXYyUjFr?=
 =?utf-8?Q?N+4inYIUsAc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dHloQjBWS1hYVHAwVmo2T21IU20veGlhNkVZbGlMMDB6M3NHYkdXYWhFYjlJ?=
 =?utf-8?B?MkxIV0tWT1FIaEJwbk1KT0I4REcrUnViZ0lTd1dtekxLeDhxRlVkZzZ6SGQx?=
 =?utf-8?B?WEZOeEtsQ2lRa05OMzQ4SVpUYWtJQ2hQRjgvN0NnZ2Z2SjluQ2xaZm5xVzZN?=
 =?utf-8?B?VEtIYzVVSSsyVi9rSzJjVFYzRDY4Q0FuU1lXY2hwR0ZJc2hycUp2c2M4NURr?=
 =?utf-8?B?STdMWlFvazZEcTRveEIrSlVRSS9aUDFVeDlqTW5WdnBwMmpKM3hUaWE5Y1dB?=
 =?utf-8?B?MERVUmZBTjdISlRlYlQ2L3pERC93MFpjZzY4a2dZcHRrYUFINTJZVTFWSm9M?=
 =?utf-8?B?cEVYUHp3UWF3M05SdDVxbVpBbnlZZ2lkaElpdml0MEs5YUpoa1dQOVNXc0I2?=
 =?utf-8?B?UmNSRXRKWTUra0NxN1dxMWVRS3ArcGJVQXAvekVneFdXQXNwcW5jazVpMlYw?=
 =?utf-8?B?SlBZb2doNnhRRFhlSkdXaDYxMnJBZ2xCQWxORHhUQy9TMk9TeVdHWmgwM3Y0?=
 =?utf-8?B?MjJWendvZnVkRU5MVXdscEhtSldCUjJzQmRoYVVhdytYU1BseHh3YVFaL3dv?=
 =?utf-8?B?OHludmRrakgyNFFSQmpwV0xQNGxYeTBzclJPdXVVS3d3Ny90S3I4Vzh6b1Vt?=
 =?utf-8?B?aFdaR0dEYm5YR1RscllwQUJFdFplV3BzMStGZGZ6STdTT1F4MHB4a1ZocDJ3?=
 =?utf-8?B?M1ljZmlyWGk2WnMxSW5WVS9UZEFTNngxZjBpUElPWXloUG1CKzQvVnphL3RN?=
 =?utf-8?B?a2pzakhwTnpjSlhDd3VMYVN5YmdrOGtnRVVCYnRacHNzZ1FHS2xxMHJQaGxw?=
 =?utf-8?B?OGpaMDUxbTY5OVI0RVIxSWk3dTR4NTZXTWtyTWVlOExGK2RWbTQ4eXJnRmRh?=
 =?utf-8?B?RCt5R3JRbXNKVVptZ08xbzB0RXdTaitONnd5RTFGWkRNdHBDVHMyZDI4cE5R?=
 =?utf-8?B?bkVJVXZXUExBdDhEY0gzcDNHNlFlbnB6SGU2WCtETmdwbGtORmpkcTBMRDJE?=
 =?utf-8?B?RTBkU3d5d0VOSEIwS0RoZUVldnFEazZQN3F2TXdnMlNyOUs3RGp5K1puZVhi?=
 =?utf-8?B?OFJKOVVzZWtTTXFkWnRlZkR0NkdBdVpIa0ttejBoYXpGM0Z4VGR2Q0p1c3dR?=
 =?utf-8?B?T2ZIYWVmWGNkYVdmQjVWNGw4cVFZS3Y3U0JaTlRaODBSK3RPL1Y5bVhaM3Bt?=
 =?utf-8?B?T2FuTEx0TSs5MWhuRytlRGp3ckFQVXUzZ1pNY01qbmtiM3huU2tTWHB5a1Vz?=
 =?utf-8?B?dXN5dUFOZE5HcUd2aXQwWTFqdmV0cVRxUFJMOEFKTXk0Y05oNjdFYzVNRG9w?=
 =?utf-8?B?QmlsMm52UVRsYmwraUFCZ0hxTzBGOHdpeStnYXJ2NkF0bEY3dVdtcnVpaUhn?=
 =?utf-8?B?aTVVdTVBT1lMaFM0Z1lhaXRsSzFmVDFodGxlVGh6MUdreWlCNzFZMkdXTXVP?=
 =?utf-8?B?KzRaam9NRXFXMm1EWDFFVmpZeW04bVJpZ3k1QUhBK29FVy9DV2svdm42cFNn?=
 =?utf-8?B?WUdaK0dJbDlSQWMyVU85OUhVSUtpUi9vU1FWSmhYRW1FNW9uK3lpRWxtVTlT?=
 =?utf-8?B?alYvVDhyeVhSUkFLTnpzNkZ0MVhyb1o1ZWJ0WjYvdjZlbHkwdUlNaTlyaWZY?=
 =?utf-8?B?NWxDcHZLNGVnRTlycTdQY2s4bVVyTmIwZUVJYlEzTENlVnRjaVpZZXA2UGRx?=
 =?utf-8?B?bFZ3RlI5SEcwZ1Z6cGRVc0xsZnhkWld4MUNwcHpBRnBzS05OQkJjemJHYzBF?=
 =?utf-8?B?TzhrQVA1QkFRTkIwV2pYSEJiWWo2a2VlTlN1SWxiVGNGNHVoTzE4UGNBTWZL?=
 =?utf-8?B?V3NjWGM2QTltakxudmU3a2s1c2dCN3htT3QrdzhJMlh6eXNibmxCZ0R6Zys5?=
 =?utf-8?B?dFhRdnNiU0lRdkpnQVJZRElJWVIyWWNrZDFqMVpCbzMvQzJEWllGOExMNldS?=
 =?utf-8?B?RmNGejh3aG1oVEgwSTRuamQ2c2V6QkRpQlpmQURyZTNHODY4K0VoNE5uemNT?=
 =?utf-8?B?RktOODRiTzVmalVpZFNyMU1SRzBMVGpEUlBscWJHcVpkdXdHQjBKVDNnL0ZM?=
 =?utf-8?B?ckdaTjJuWkN4aTNSQVhRYWtwMTZST0crUjJiK0dBeDVLcGFVc1BtUjl5VXkz?=
 =?utf-8?Q?45NtaudrVY5MmVpvNPyIS3zGZ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92397fec-5dc9-4c18-effe-08ddc857bea5
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2025 13:08:54.5753
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3f5Ti40et6LxXoPZpQ3OmSgxLkf0xGNgP13PbwUI2e2IxS14254J11LfXruX5qDmJAJnZld0Siz6FdqZi8apwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFDF5E260D0

On 7/17/25 16:46, Kai Huang wrote:
> This series is the latest attempt to support kexec on TDX host following
> Dave's suggestion to use a percpu boolean to control WBINVD during
> kexec.
> 
> Hi Boris/Tom,
> 
> As requested, I added the first patch to cleanup the last two 'unsigned
> int' parameters of the relocate_kernel() into one 'unsigned int' and pass
> flags instead.  The patch 2 (patch 1 in v3) also gets updated based on
> that.  Would you help to review?  Thanks.
> 
> I tested that both normal kexec and preserve_context kexec works (using
> the tools/testing/selftests/kexec/test_kexec_jump.sh).  But I don't have
> SME capable machine to test.
> 
> Hi Tom, I added your Reviewed-by and Tested-by in the patch 2 anyway
> since I believe the change is trivial and straightforward).  But due to
> the cleanup patch, I appreciate if you can help to test the first two
> patches again.  Thanks a lot!

Everything is working, Thanks!

Tom

> 
> v3 -> v4:
>  - Rebase to latest tip/master.
>  - Add a cleanup patch to consolidate relocate_kernel()'s last two
>    function parameters -- Boris.
>  - Address comments received -- please see individual patches.
>  - Collect tags (Tom, Rick, binbin).
> 
>  v3: https://lore.kernel.org/kvm/cover.1750934177.git.kai.huang@intel.com/
> 
> v2 -> v3 (all trivial changes):
> 
>  - Rebase on latest tip/master
>    - change to use __always_inline for do_seamcall() in patch 2
>  - Update patch 2 (changelog and code comment) to remove the sentence
>    which says "not all SEAMCALLs generate dirty cachelines of TDX
>    private memory but just treat all of them do."  -- Dave.
>  - Add Farrah's Tested-by for all TDX patches.
> 
> The v2 had one informal RFC patch appended to show "some optimization"
> which can move WBINVD from the kexec phase to an early stage in KVM.
> Paolo commented and Acked that patch (thanks!), so this v3 made that
> patch as a formal one (patch 6).  But technically it is not absolutely
> needed in this series but can be done in the future.
> 
> More history info can be found in v2:
> 
>  https://lore.kernel.org/lkml/cover.1746874095.git.kai.huang@intel.com/
> 
> === More information ===
> 
> TDX private memory is memory that is encrypted with private Host Key IDs
> (HKID).  If the kernel has ever enabled TDX, part of system memory
> remains TDX private memory when kexec happens.  E.g., the PAMT (Physical
> Address Metadata Table) pages used by the TDX module to track each TDX
> memory page's state are never freed once the TDX module is initialized.
> TDX guests also have guest private memory and secure-EPT pages.
> 
> After kexec, the new kernel will have no knowledge of which memory page
> was used as TDX private page and can use all memory as regular memory.
> 
> 1) Cache flush
> 
> Per TDX 1.5 base spec "8.6.1.Platforms not Using ACT: Required Cache
> Flush and Initialization by the Host VMM", to support kexec for TDX, the
> kernel needs to flush cache to make sure there's no dirty cachelines of
> TDX private memory left over to the new kernel (when the TDX module
> reports TDX_FEATURES.CLFLUSH_BEFORE_ALLOC as 1 in the global metadata for
> the platform).  The kernel also needs to make sure there's no more TDX
> activity (no SEAMCALL) after cache flush so that no new dirty cachelines
> of TDX private memory are generated.
> 
> SME has similar requirement.  SME kexec support uses WBINVD to do the
> cache flush.  WBINVD is able to flush cachelines associated with any
> HKID.  Reuse the WBINVD introduced by SME to flush cache for TDX.
> 
> Currently the kernel explicitly checks whether the hardware supports SME
> and only does WBINVD if true.  Instead of adding yet another TDX
> specific check, this series uses a percpu boolean to indicate whether
> WBINVD is needed on that CPU during kexec.
> 
> 2) Reset TDX private memory using MOVDIR64B
> 
> The TDX spec (the aforementioned section) also suggests the kernel
> *should* use MOVDIR64B to clear TDX private page before the kernel
> reuses it as regular one.
> 
> However, in reality the situation can be more flexible.  Per TDX 1.5
> base spec ("Table 16.2: Non-ACT Platforms Checks on Memory Reads in Ci
> Mode" and "Table 16.3: Non-ACT Platforms Checks on Memory Reads in Li
> Mode"), the read/write to TDX private memory using shared KeyID without
> integrity check enabled will not poison the memory and cause machine
> check.
> 
> Note on the platforms with ACT (Access Control Table), there's no
> integrity check involved thus no machine check is possible to happen due
> to memory read/write using different KeyIDs.
> 
> KeyID 0 (TME key) doesn't support integrity check.  This series chooses
> to NOT reset TDX private memory but leave TDX private memory as-is to the
> new kernel.  As mentioned above, in practice it is safe to do so.
> 
> 3) One limitation
> 
> If the kernel has ever enabled TDX, after kexec the new kernel won't be
> able to use TDX anymore.  This is because when the new kernel tries to
> initialize TDX module it will fail on the first SEAMCALL due to the
> module has already been initialized by the old kernel.
> 
> More (non-trivial) work will be needed for the new kernel to use TDX,
> e.g., one solution is to just reload the TDX module from the location
> where BIOS loads the TDX module (/boot/efi/EFI/TDX/).  This series
> doesn't cover this, but leave this as future work.
> 
> 4) Kdump support
> 
> This series also enables kdump with TDX, but no special handling is
> needed for crash kexec (except turning on the Kconfig option):
> 
>  - kdump kernel uses reserved memory from the old kernel as system ram,
>    and the old kernel will never use the reserved memory as TDX memory.
>  - /proc/vmcore contains TDX private memory pages.  It's meaningless to
>    read them, but it doesn't do any harm either.
> 
> 5) TDX "partial write machine check" erratum
> 
> On the platform with TDX erratum, a partial write (a write transaction
> of less than a cacheline lands at memory controller) to TDX private
> memory poisons that memory, and a subsequent read triggers machine
> check.  On those platforms, the kernel needs to reset TDX private memory
> before jumping to the new kernel otherwise the new kernel may see
> unexpected machine check.
> 
> The kernel currently doesn't track which page is TDX private memory.
> It's not trivial to reset TDX private memory.  For simplicity, this
> series simply disables kexec/kdump for such platforms.  This can be
> enhanced in the future.
> 
> 
> 
> Kai Huang (7):
>   x86/kexec: Consolidate relocate_kernel() function parameters
>   x86/sme: Use percpu boolean to control WBINVD during kexec
>   x86/virt/tdx: Mark memory cache state incoherent when making SEAMCALL
>   x86/kexec: Disable kexec/kdump on platforms with TDX partial write
>     erratum
>   x86/virt/tdx: Remove the !KEXEC_CORE dependency
>   x86/virt/tdx: Update the kexec section in the TDX documentation
>   KVM: TDX: Explicitly do WBINVD when no more TDX SEAMCALLs
> 
>  Documentation/arch/x86/tdx.rst       | 14 ++++-----
>  arch/x86/Kconfig                     |  1 -
>  arch/x86/include/asm/kexec.h         | 12 ++++++--
>  arch/x86/include/asm/processor.h     |  2 ++
>  arch/x86/include/asm/tdx.h           | 31 +++++++++++++++++++-
>  arch/x86/kernel/cpu/amd.c            | 17 +++++++++++
>  arch/x86/kernel/machine_kexec_64.c   | 43 ++++++++++++++++++++++------
>  arch/x86/kernel/process.c            | 24 +++++++---------
>  arch/x86/kernel/relocate_kernel_64.S | 30 +++++++++++--------
>  arch/x86/kvm/vmx/tdx.c               | 12 ++++++++
>  arch/x86/virt/vmx/tdx/tdx.c          | 16 +++++++++--
>  11 files changed, 155 insertions(+), 47 deletions(-)
> 
> 
> base-commit: e180b3a224cb519388c2f61ca7bc1eaf94cec1fb

