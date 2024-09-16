Return-Path: <kvm+bounces-27000-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2EDAB97A527
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 17:20:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E68F928AD85
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 15:20:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4247B15A86A;
	Mon, 16 Sep 2024 15:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="tondjNBN"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2064.outbound.protection.outlook.com [40.107.237.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B68A215A864;
	Mon, 16 Sep 2024 15:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726500036; cv=fail; b=CHoM2lwdKiI0jYIQn9Z3eCtqlmK6L+lunwbpwm6dlIihDis7omI0a0Z19fEQxWkev8r+nXMb6K1oC0SrR34nDfXvuZanhkpQ0AQM5h75U220GfWRiLsD55J4EPJNiOq/PKWzVy6h+VqLIPx1uwiBbngFYSHJodrEloICC2wFHDg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726500036; c=relaxed/simple;
	bh=Dm28Qy0AEAlrh9aOehZ2mI+tYjIebSDNKMlQQYtfhps=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ooXAwoMd57SmLmhgwSutM4dtQ8SZSHE66aBoCkJI5OO7BLKehtU81984RmxFSqpIAXSKHREjeS1fZJs5hx4GjeaQ4Nml8R4vpWsNe7r67u0W7nKSmLXrMBzcnvOadoqLDL0H7QASGuhdf6NNIW3/76ZAXuCr/DH/NIU9R5CMEJI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=tondjNBN; arc=fail smtp.client-ip=40.107.237.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bG6eQJxIBvw0hg39JvZfk5uL96DxKxLmFRoY7bTrUg39u8ORg5qjhNl/vPs3Ct2UjuNdHF6zCoJbAW8vnGAxXwx4yjUOu+Iu2CCg6CZQnU/P3BYLf92Au71eU+W3+Cpm90q/hgrd+m8adhzS1J3V4vT5otHVMPEJ67FjfJgLCEZSq/kCbfs4Xt5KEXDRlVDfUtZpZEkMpUuil6D0/4QnNMRdcsrJ+hd3/TPEfrJ/Xqzwaim7Tlkt33meESUWFG6ZPrXL9SAdCxdW/CNOlvNmJ6k5E6te2+CtQLPT8yDV/cfXzmay/fgDgG55PB0/aom4USnwMPzXlKLHX30HD9ZJHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I4aECBFXDuQaOBC3IGqcm3YuDqt7ufMAk6hyDk3fjCk=;
 b=xj4tT5BaaRBr/Nmk5wN1eqBAY538DRH+4LyAviDRmmzp0+UWlBiCms8GlvYURkYut76sDXEKaAUBcdisvACQEEJiWMd71ynr8Gf+UHNnnMW4XVOGrtcdKDBRcNyCe5OlsciFvpjEvSmrZcZ6/qirCGn3BHZeBJV0VddGqaiiQHs8lp56hcd5ITL1jf9KecdWIWhkjNsy5+DcJeYfkrqXDhU4G8fGShT86n8I/jVXYlLedV42XFmQMaxx8XuLhp0vfAurOSvZ3HKoZZjRnjiY6kbv7Y4Q5QZybERuFuYw8dvmK3HtS/wM0RUOg/p9zoBCT67dDuPnciUwCyMIfMjnpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I4aECBFXDuQaOBC3IGqcm3YuDqt7ufMAk6hyDk3fjCk=;
 b=tondjNBNIvs6cytgU+/eWdwZ+az7jNF+PPxEqwVpbQmQ3RH/fwGZJ+TnQTYmWbYV2dZEdIUTDezbgl12pXMrEZ8MjJziDep5xCW9hLYRKL/SPRsvK0lbCXrMi1MrAalraIfNpzSnV9KjyRx0QJ14vGH2Uev+0Ka1ttWUw9rxgGE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 CY8PR12MB7217.namprd12.prod.outlook.com (2603:10b6:930:5b::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7962.23; Mon, 16 Sep 2024 15:20:31 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%5]) with mapi id 15.20.7962.022; Mon, 16 Sep 2024
 15:20:31 +0000
Message-ID: <9a218564-b011-4222-187d-cba9e9268e93@amd.com>
Date: Mon, 16 Sep 2024 20:50:20 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH v11 19/20] x86/kvmclock: Skip kvmclock when Secure TSC is
 available
To: Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, bp@alien8.de,
 x86@kernel.org, kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, pgonda@google.com, pbonzini@redhat.com
References: <20240731150811.156771-1-nikunj@amd.com>
 <20240731150811.156771-20-nikunj@amd.com> <ZuR2t1QrBpPc1Sz2@google.com>
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <ZuR2t1QrBpPc1Sz2@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA0PR01CA0101.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:af::11) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|CY8PR12MB7217:EE_
X-MS-Office365-Filtering-Correlation-Id: b3f64a14-b42e-4eb6-4b9e-08dcd6631a05
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MFhmenFPalBpWVZFck4xemVaR0lzdzRkaWpUcHdUNjVDbDZFdEJUY1lGeEpv?=
 =?utf-8?B?RGJ3d0hDb2ZkSHVYR3d6YUxrSTVtSUxJTXcwVFdzMDM4VGt0U0pacGJzeU5k?=
 =?utf-8?B?YTczZmcvZSttZmdBNVp4dDkzT3RRdHllVXZiM0doWW9nK2pQQWNkN3ptWFRq?=
 =?utf-8?B?RHBrUVEzSnFvYUsxeEJPdFJCN3VmbENBWG54cmt0SkxQcHJ6cDliRzRkdCtX?=
 =?utf-8?B?V2hWZUNnaHNWeTdRRWJNakFxVThuNyt0cnpxL3FnN3dxK1dTR3RXZ3FCdVBj?=
 =?utf-8?B?dlpwUnM0b0NjTThDTS9UTGpxSEZzWFJYTkZpWVFkbzY5S0p5RFUrMWw4d2hP?=
 =?utf-8?B?K3J3dXpJbTdpRlNnd2xyN1pVZnFsOFl4RTlPRGc5eTdnM2piNzdMRko0UnhU?=
 =?utf-8?B?SVhYZkxtaU02YXZnV3cvN2Uyd3JUaktZdlZadUJqdlY4OW14NXUvcy9QaDJL?=
 =?utf-8?B?OU1zSHA5R2lVMnZyWVNWWE9kUElrVkd5OG1rQjgxbkFIVFBUYVYvS28rczU1?=
 =?utf-8?B?Zm5HSXUrTEJCWjhobXA4endGREZQWlRkYkFFdHFvVVZhWklBYmk4ZklDUGJB?=
 =?utf-8?B?L1dqNG1kNEZCUTZBVXVyc3BSZ3paQ1ZyMi9oMUZ1dmszSHdwZ3RlMnN5RlFB?=
 =?utf-8?B?bDdrQmJaNmI5RHUzeWxuSExxckhzRlo3aDBZSldYM2JuUHRyS3FHQ3ZDN3VQ?=
 =?utf-8?B?eGtPdFEwbFJUbzNkR1B5NFBHb1lvUjUxQldSemduVHRtNmlXMHZQN0pBU05L?=
 =?utf-8?B?US9oK0Y1MURBcS9welhBaGNTcEh3TVZHYlN2b1JJSmZQTG9sc1hFM0kwRVRN?=
 =?utf-8?B?QU1IaFJEMExHM0hDMlllN3FKendIam5DZlpmYTZtMWxSNDRpMXZna0xYU3RW?=
 =?utf-8?B?dWd3eDN1VWhCSXBSazZjRTFWaC93ZHlpckZwQlBWWENVeFRsWjZTbHl2SkM3?=
 =?utf-8?B?czVqL2p1RWU1V0lTTzdBNGlKeFgxNHNaTFBXdlEzSUlqM0E2ZHJyRXNvZjU0?=
 =?utf-8?B?SXFQQ2NEOFgrSVJFam11UU95THNlTEFXbldTSGF5UFBTZ0c3c2NURlVzNVM3?=
 =?utf-8?B?M2p5YlRpeEtNMUE4amdlV2NvTGJHWXFPQUhNMk93Y3dRbUs4a3pkbGFSWjd4?=
 =?utf-8?B?UldjSTVEMkJDcVE1WGtRTEZ0OVdDUG4weVl0QlZPbXoyZDJqR1VKZmtCWWMw?=
 =?utf-8?B?QjVVMzQ0L210NzA3eDB2cVNXZDlMZU5NU0NhNEVYSHdKcGk1OUtPWFVaKysx?=
 =?utf-8?B?MnpRYjNUano3dkFrWVNabjZ4RUFyNTFLRmZMb0dpS2lDcmJZVFdIY2NYbkxq?=
 =?utf-8?B?b3J0R291R1lwcmlYbDAwb1g1WFZESUdjRXl6RVIyaDJBa3EzSGVWcWloTlYr?=
 =?utf-8?B?MzA5K2QrRHlIaitWbHF2NWxod1RFcjZsVTB5Y1hQUTBQVHNacG0yaWdobUwr?=
 =?utf-8?B?cjF2U2VLVUFDd0FYWmtlbk1iVm5ZRDR0RnJtdU1JR0hQMUQrODF4WS9DUjNq?=
 =?utf-8?B?RmhQMGx2SU5EQ3ZIdmZlaDhxN2ZJYUFJbFFPWDFhZWs2SGszNjNTTmNTeTNh?=
 =?utf-8?B?M01XUVBQeDVteUpiNVF3SUFzdGNKa2VJRUh4YnRsZXVYRUh5RUdmZlBtR1Np?=
 =?utf-8?B?RFdybVk5VThFQlJRY04wWHFSaXFFOWVuYUFRejdRZzJNazMrQXFwSlpEVExs?=
 =?utf-8?B?SU5ZYjN4U1hjL2lhWjlvNnpTQ01NaDdVZ0Fuc0hDTHc1VjF2Y1RuUWpzZlh6?=
 =?utf-8?B?cWtUSnJBOXp6UkJRTXhWcm51T2hKc2dTSEYvandpQk51d3R5Z0I1VlVvNWpP?=
 =?utf-8?B?M1RZOVl0TXlDMlIyY1luQT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ekdnQVJxZFV6R05YODNnblJ3RW5jYlFNS1p3Mi9YRUkweXNHODJ1U2FuQnEy?=
 =?utf-8?B?Z2VVb0VwZ0FUQjYyUHErWGQyeFZyZVdpcHdCcDVJM0ZNQ1FOTzBxak1aRjUz?=
 =?utf-8?B?Y0NGYmtDTGQ0NHdiaUoveWg4aDBLQXVyN1BGcjJJQUJVS0FXTWN4MnhaTE1R?=
 =?utf-8?B?RUk5L0hKT1FKdWtrY3NsNnIzYnBqdVFqZmFnNVlpMzYyYzR3VHkxZ1BHdTRE?=
 =?utf-8?B?TkFRS1BRYTJvNGpCZGRhL3BmNytHNXJDVCt5RVpuMXhGS08xQ2ZMaVordGl6?=
 =?utf-8?B?emFoYWpCcmRvUXlQYmZRMks2ZFJOUitrUHJVNUMxSng1Q0R2VjdaM014N3Nn?=
 =?utf-8?B?Z3luYUI1RDRGYUZ6R3hTYWF4Nks3Wnh6NlB3LzdlWUw4WWVFaHF6Nk9CQjll?=
 =?utf-8?B?MkZ0bzBnaUZIaW8yQ3BaZkdMS0Y0REZCNm9oQmtjZXh6bnQzTXVjanRmdVVV?=
 =?utf-8?B?dXhKUmtkWlVXaFN4am1EZVlBK3V4V2ozZ2NlUHNuVlh2THJQZENHRy9RbVdR?=
 =?utf-8?B?UnBaNG1iNjhzaDh5NUVCYW5iMGNNMXdGLzZ4NzUwU2pZNE1IeFJHY0R5Yk8v?=
 =?utf-8?B?VXZXNUxRVGlKT0RmK3VIMytoaEg5VDE4Tkt1OThESnRoSzFTd0JLNEN2S2xZ?=
 =?utf-8?B?SU5TenNPaENJTERzMm8vSmdnYWtiVnRxRU1UcDZVeXFsZnVGZy9HSEFxVzVG?=
 =?utf-8?B?UTdTRy9DRG8zS3REWFB5b0hTbHJPOUlGNGRxS25sek02Q3dYdGhwYXY1UlVs?=
 =?utf-8?B?VFhmS2ZFOC9HcWdQejdtUDlZT3R2dG9TTHBpaVhlV0M2NWVDREYzMVJHTUxx?=
 =?utf-8?B?Tyt6aEhPWDVRNmVqT1ZJMHdWU3p3Z0tIZk9WZVJzUXE4dThpcmI3SEFlMVBE?=
 =?utf-8?B?a2JJSUFQcmRZcDZmSVFRYWlUVFJmRWZ4djBQamZQUkFVb211Q3d2VEMvSU5q?=
 =?utf-8?B?eHFRV0REanlzS3FzemVtRWhTM0RpenhQaEsvS0ZDTlVSRUFQM3plWXcvV0V6?=
 =?utf-8?B?QXNaM3BoT2N0dUFOZWNQU01MSnorNHAwdVJESUR3cW84ZnN5TzBUbVJDSWNq?=
 =?utf-8?B?dGtKT3NDSjlHVUd0WlNRalMvMVJUSGJ2NCt1aEhWbE9PZFZhZWZodU1WVWJk?=
 =?utf-8?B?NjNiNDcyMld4VFF5aHZRY1Y4Q2syLzBLd0E1dDRoQmNLT3VlZGl0SkxyUXU1?=
 =?utf-8?B?UTNaQmhXcVllcHQzUmsyTURUMTVCN3N6RGhxY20xWlB2N2lOb3BraGR2aCtv?=
 =?utf-8?B?SUFoWmJlK25lbkxKV0NiRlFaTXkyTGt4bEFpY2ozcWVVek1CNmFVVkI3UlNE?=
 =?utf-8?B?NlB1QllVZ2xLbHgxREtlSzQ1YVBveVRKNTFBaURPSDJRRkd0ZTNKdzlrdnRn?=
 =?utf-8?B?NWMyL1BSdVFqSjE1L0NMb0o2UGRHNXNLZjh3ajZ3ZTdLYzhxR0c1clhGUEdv?=
 =?utf-8?B?U2dJSWl1YUZ1NUY0aE9aT2RvdlgzQVVveTlMLzhRS0U5T0VVNVdaSzNuemE4?=
 =?utf-8?B?ZkVGM0xYaUdPcnZ6QnVlQUJTL2RWNGdzbGoxTkxnaVZ1ejhvZDRGQzM0Vm43?=
 =?utf-8?B?RXE5L09ZY0gweXhlczJjSFMrak5tdWUxeEJpbERrc1J6eGlkakZGZi9XZ1Mw?=
 =?utf-8?B?RksvbTQ0eGZSN0h1UDVIRnhtaTVKcEdBcVB3VGJwd3RwVHFVRWFyQlNoRDEv?=
 =?utf-8?B?aFpGbTQzRDg3RVQwTU1Vby92dGR4LzZkb2duem9VcVlUV2ZoTHZHczBzRytl?=
 =?utf-8?B?RWw5S1ozbE1hZ2Zsb29RV2N6aEpCME1xQjZONGNUVmJYSG1VL0IwU1QzSFp6?=
 =?utf-8?B?YVVMeWt6eU1iTkcxRkQ1UW1YN016K2VEd1A2QzdhRElOaUxHV0o2UnpLM0hm?=
 =?utf-8?B?TWFmMjBSbHBBdXkrdTlQU0RFOEdSZ2VVU1I1Q1BWTHAwZ3B5Q2FWdUR1ZkZX?=
 =?utf-8?B?dER2eWpjdWFmaVE2cHlWdFJKS0lqcGIyRUZwOXE3Um1ibGI5TTErRTFHLzhJ?=
 =?utf-8?B?MEZIYmtLOVF5cFJNYXVOMnV6UDNYNWpXYjZXcXVYNDFWM2x2eHdsbGNVR1g0?=
 =?utf-8?B?aXRHMU5ZVVQyNktSV1VsakJYbGs0OFovY3NPVWc5RVhrTVptRXRsMXF6bkM3?=
 =?utf-8?Q?C0kaI1xFRrEA3q+cN4kD4lNYJ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3f64a14-b42e-4eb6-4b9e-08dcd6631a05
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2024 15:20:31.0028
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W1T45oQwg/JJxfewZKVtLBs0raOHMivbJ5pGPKcXM8WXg5wuACXpH1gD3o94flPJAQPLZROUjS02PAzct9PSiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7217



On 9/13/2024 11:00 PM, Sean Christopherson wrote:
> On Wed, Jul 31, 2024, Nikunj A Dadhania wrote:
>> For AMD SNP guests with SecureTSC enabled, kvm-clock is being picked up
>> momentarily instead of selecting more stable TSC clocksource.
>>
>> [    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
>> [    0.000001] kvm-clock: using sched offset of 1799357702246960 cycles
>> [    0.001493] clocksource: kvm-clock: mask: 0xffffffffffffffff max_cycles: 0x1cd42e4dffb, max_idle_ns: 881590591483 ns
>> [    0.006289] tsc: Detected 1996.249 MHz processor
>> [    0.305123] clocksource: tsc-early: mask: 0xffffffffffffffff max_cycles: 0x398cadd9d93, max_idle_ns: 881590552906 ns
>> [    1.045759] clocksource: Switched to clocksource kvm-clock
>> [    1.141326] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x398cadd9d93, max_idle_ns: 881590552906 ns
>> [    1.144634] clocksource: Switched to clocksource tsc
>>
>> When Secure TSC is enabled, skip using the kvmclock. The guest kernel will
>> fallback and use Secure TSC based clocksource.
>>
>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
>> Tested-by: Peter Gonda <pgonda@google.com>
>> ---
>>  arch/x86/kernel/kvmclock.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
>> index 5b2c15214a6b..3d03b4c937b9 100644
>> --- a/arch/x86/kernel/kvmclock.c
>> +++ b/arch/x86/kernel/kvmclock.c
>> @@ -289,7 +289,7 @@ void __init kvmclock_init(void)
>>  {
>>  	u8 flags;
>>  
>> -	if (!kvm_para_available() || !kvmclock)
>> +	if (!kvm_para_available() || !kvmclock || cc_platform_has(CC_ATTR_GUEST_SECURE_TSC))
> 
> I would much prefer we solve the kvmclock vs. TSC fight in a generic way.  Unless
> I've missed something, the fact that the TSC is more trusted in the SNP/TDX world
> is simply what's forcing the issue, but it's not actually the reason why Linux
> should prefer the TSC over kvmclock.  The underlying reason is that platforms that
> support SNP/TDX are guaranteed to have a stable, always running TSC, i.e. that the
> TSC is a superior timesource purely from a functionality perspective.  That it's
> more secure is icing on the cake.

Are you suggesting that whenever the guest is either SNP or TDX, kvmclock should be
disabled assuming that timesource is stable and always running?

Regards
Nikunj

