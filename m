Return-Path: <kvm+bounces-69406-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0EU8Fwdfemkc5gEAu9opvQ
	(envelope-from <kvm+bounces-69406-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 20:09:59 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id D63A3A8102
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 20:09:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A41A23043D1C
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 19:09:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18326372B41;
	Wed, 28 Jan 2026 19:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="If97J64O"
X-Original-To: kvm@vger.kernel.org
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011054.outbound.protection.outlook.com [40.93.194.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9083C353EF4;
	Wed, 28 Jan 2026 19:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769627364; cv=fail; b=ZoTQkBal0zn+GGsZ++W8+C1UjG8yNuZUY3z8HdoEUig3v5kpoCuH1cAsEouVSA5HVUT8q+/bklNzcZCeuySOa9A5sBbMtxamb7Ru+2rA0NZzTkbmXrNPeA4YE6diHIPPe/npFMVivdcXdAF/jJYh4FMKbJPOq8MaqEZQ6LA1FwY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769627364; c=relaxed/simple;
	bh=iwEnMmsUpLR7i27PsZ2/ZQPBIKIIxL6GU21ujAnrDOI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=q7YO3O9iuHN6BSW3mfOEF6OLBr5L+MMxlvo/KuuNSJh4YwnQcrEwoDqYzfmOg4GFOlYHpEuiozqT2NlIFWzvPt2ixQxu+TiIHjp8HeRWzPh0NOdaAe+kgF75lFnN0z4fBgW+OvmxKcp1+Wt3xj+IM1dpvniy6EoAD/8uaa6C5dk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=If97J64O; arc=fail smtp.client-ip=40.93.194.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ih7KlQXYuaQmYDFWr0oA8yzbgyg2No9jvbkXUCabifqj5pMZq4nX+mi6VsTOk/YOvjZwNLh5tyYGSBFaSUsSXNg08U1XKX0S7jJ8X8hReqMFi7Lb/a4UAYkeJb2cNlZ+VuzDTFEhEX6cgMXGm+n0pxX8igkhIOX0NZNxQ0pBFs3sLKkHmUGxIF3vgBDW1jRzvk1WZ58dwwPvQ7i8WKRER/21LPQsMVDoLPc8C3/A0fFRiLFE28BlcPk7ON6DibPKuI6rAz1M81xmJq1pMzw4XcDa9941eb/EafpQBpz1m61g1EPRDlDVQVNtIswrylwlKH8SOR5JvfQdW6dmXMzrLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZAirKPevjD4ylO6xlJsqCrx41K+5cDBSbQdo9d3glNE=;
 b=BbN4Ukz0VC7H2IxUHVwsyn0clqKpFRGaUJn5LougeNNZFL4adc+4SvjviAqy+UybeZs0pPj7KuVMSrleckZdayZqkcBSp6JCTT8jUdrel/XKXyHNQ4tZ83xK3FwXwsk7vNDTzkQn79wubgWCfU2miPU6AQjH0F6q7qF1w1Kz96CEISWSe5I5JivXkKx/U1qwc+IfJNHWC6kmL77kdN1wBw9FGEDcPacvmE7Q22i9KxGRKrlKX3QUbzZNP1Erh/lgsPggYGeGUwa9QP1SQEB2Xbwot47FEsO4onI947P07o3EpTZ+CJztjhXT5a+g5leu5YG+OtckH62oMdtx353puw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZAirKPevjD4ylO6xlJsqCrx41K+5cDBSbQdo9d3glNE=;
 b=If97J64OMTOVnN/xlFGd8tMCi+dWCZtKOSGqn6m7/oJ5gm8pTlX43MkfAaCzs3pzSxJG+XTFuSbh9uwYBvTsnS5sEIe7+dmXrP+pEyOXNtHqiyX7+HSYmFVJc6va3wCYCvDkb5095JjCEp8zg1CDczX3uNwIBuwTKoLEMLqq9/A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by IA1PR12MB8519.namprd12.prod.outlook.com (2603:10b6:208:44c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Wed, 28 Jan
 2026 19:09:19 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.9542.015; Wed, 28 Jan 2026
 19:09:19 +0000
Message-ID: <e4b1f40b-427f-48c0-9b40-ed3d4399b3dc@amd.com>
Date: Wed, 28 Jan 2026 13:08:49 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] KVM: SEV: Add support for IBPB-on-Entry
To: Kim Phillips <kim.phillips@amd.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, linux-coco@lists.linux.dev, x86@kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, K Prateek Nayak
 <kprateek.nayak@amd.com>, Nikunj A Dadhania <nikunj@amd.com>,
 Michael Roth <michael.roth@amd.com>,
 Borislav Petkov <borislav.petkov@amd.com>, Borislav Petkov <bp@alien8.de>,
 Naveen Rao <naveen.rao@amd.com>, David Kaplan <david.kaplan@amd.com>
References: <20260126224205.1442196-1-kim.phillips@amd.com>
 <20260126224205.1442196-3-kim.phillips@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Content-Language: en-US
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <20260126224205.1442196-3-kim.phillips@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR13CA0097.namprd13.prod.outlook.com
 (2603:10b6:806:24::12) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|IA1PR12MB8519:EE_
X-MS-Office365-Filtering-Correlation-Id: 24620fda-20df-4dbb-ed6e-08de5ea0bd2f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NzQ4VG9KNWJzVmU2ZEo5bm1rQUdrZEpiNEtjazRBMklrNXJTSmVPcVNmeTk1?=
 =?utf-8?B?R281d0swWnhlTytPWmxLa2dLOUpaZGlZSTNBbUhrUWdXWjVYZ1FMeWhIc1l2?=
 =?utf-8?B?aEZWcjVCVzRYUERHS2ZJR2pxZ2xvYnJ6bCtZZVBMYjdKLzlTNnJTaU5FWStS?=
 =?utf-8?B?QUlhUHhwYkFLVWV4bHZYYkI5aXBxcUxUMHB1SWlVaFhMSzBvMmdMZHVzTXVP?=
 =?utf-8?B?SXNoMTYxTzg5Q0lOaDNpRmowdTV0ZERnV3hETXlSeU9mRE1RNDJCVmFKVlRX?=
 =?utf-8?B?akxjakY1WjFQWmx6YjZoNkZEeDRaOTRpUnE2QXdXdTRFZEhMNjB4ZnpvZDVl?=
 =?utf-8?B?MEIzTVNDZEtldzRscUI2WnRJZlhlWFFLb3dxQy9vOEFoOVQ3LzZDaFdNWTlm?=
 =?utf-8?B?QTBabEp2NU1HWWFBMUFOemR6a0l1dkxOWklFQnhmMnFCQ3E3NXRrbkVIcHZu?=
 =?utf-8?B?S3B2Ykc4UUlpUXJSVnRoODhGSW82aldRQ0xPbmQ2WjAvZlNEMjlNdEdjVE44?=
 =?utf-8?B?b3NDTm1TOTUvalhhWG00eE5CaTRyai94cmhIaWhzNzdOOUREQ0JrOGo5K2I0?=
 =?utf-8?B?bzB5cklzZWlhdHpTMXdESUphaGFZL3d6aDFnNEpLRUNxNXltbEc5VkxYdWNy?=
 =?utf-8?B?cW5URU1kbnlDbW1zVzJYcjJRa0dGTEdKUkJmaFI4N2RpV29idU5udUhuYndV?=
 =?utf-8?B?L2JWVGE2akNpREZMem00cTFMYzB1akUvL2dQT2dEL1B5QVo3SnVxZm5YVXJv?=
 =?utf-8?B?dEpQNGFxWXpKWG5tU21TMTJ5cDBwWTJRK0hoeVFaOHVLdU5hdmFwQVNSempD?=
 =?utf-8?B?ZXFMeVJTNDJHaW1SaDBXa2xlQUtaQVRYNmkwRmdKNTdFRVd0UVBRR2VuZjdY?=
 =?utf-8?B?VXRzRjJoZkRpZWZKSFNKQXF2T1ZnZkMvaEU3MkxFNjRxUnVXdGhGNnJzblRS?=
 =?utf-8?B?aDNZMWx2aXB1dTVSMVB0Q2xkc2l4eGtYeGJtUUsrc2w0OUI3bFQ1UHdRaFBL?=
 =?utf-8?B?NGFuMGYwMTN5dlJGYURxNTZMMjEreGs5c1JnbXgzYVZURHc1VDRZOEloVmhH?=
 =?utf-8?B?eXJKQnhobDdCd2wwYm5EQTYwZFRCN0lxUldEcUVVczJDbkdmUW9GRm94NThp?=
 =?utf-8?B?RXk2Z1hNd1lMaDZxR25CaHhJWFByZTVrTm8vYW1MUUtMTVMranZ5N1JvUVFa?=
 =?utf-8?B?aFVKckNvVWR1aXhpZXdvdnRjNHVDRkQ2ZjlOZzBCcnNPTFhreWV6UGJGREov?=
 =?utf-8?B?UDVzaXcxNEFmT0tPSEdKT0JVSGlDU0w2eGlVdDRIVUVJb2dCY0RzaE1DTkxx?=
 =?utf-8?B?TjhkTWthb3hvWjIwY3hzV09SQUNCazFOMVRIeS9ONzRhTlZkclpJT3NlL3R3?=
 =?utf-8?B?RSt0R0tDNndPVFJhYkhPNzZIaTh5UGxlcWlWeC95NkZDOXpRZVNJanhIUmtW?=
 =?utf-8?B?ajg1KzlpSmtFcE1xNU54N2piNEJsZlVtSjUxNDl4RGFHYmlRUHo0bndrT2dv?=
 =?utf-8?B?VWF5MU45K3BaQ0RXVnRUczVyVUFRZFpydFl5Z25NZlNVVkJKbENkMHpoU2Vs?=
 =?utf-8?B?d1ZGZThXejhCSW9pQ1p4V205SGoxd0NGelY0ZUZScDQ4Y1ZpWWQzQjNUYXRC?=
 =?utf-8?B?aER0Mk5kdWRnLzV6ckhxbk12cW1UeWZkVUZEVko4NS9LZkpyWnQwUW5rV3NV?=
 =?utf-8?B?bzhQQ0lLRUZNYjdOcktSSUJQL1BQSFk2WHZDa1RvbmhkdUZBZzhzUFI0Zyta?=
 =?utf-8?B?Mm5LNzhWZVU4NkRqeWVwWmRxd3JKZzBhcklzQUZ2TVpWNDFCbng5Y1U3ck5I?=
 =?utf-8?B?TkNta1BLdjZnOEVBOXJkWXlxb1BSdXZnemJsU2pLY1hlVVo4eHA3UUszQVNZ?=
 =?utf-8?B?cXVDME02VnNWSXpTUm4yaGhva0JmRkVqL05aWnhIWE56ZHJocmMzZ2FLalJH?=
 =?utf-8?B?bDZvOFFsSGNxd3dDM3UwZHMwdFhTVmhnMHFnTjZWQ2xRSnB0ZTBTdjlkd2pt?=
 =?utf-8?B?RDEvbmNmVEVBSTgvSHMvT2ZZMXRxeFoyRFc2emhtdzIrQmwrWk85N0MzZXJ3?=
 =?utf-8?B?ZzJLMlFST0NGQTU0VXdva2Y5WDIzNS93Szlhb0J1eFFDZ3RsZnQ3cXlCVzRL?=
 =?utf-8?Q?M4wAC3h8AKTMUjM/r6hwy1G3d?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ajZhdTA3NVpHZWpxNENpQmFNS3RXRTloczhaUjRqUVFKM2pGMEc2Yk1Sc0RQ?=
 =?utf-8?B?bTc1ZzQ5ckMyTnA3d2krd1U5Y1ZDallmUElaZEp5eHJqa1hycUJMY2JsR3N4?=
 =?utf-8?B?NXZPY2RlMmR3N2dHZFg1NGpCN0Y2Mlk1cWR2STRpdU44dzlyaHN4SHg5Nm82?=
 =?utf-8?B?SXluc09wd0hSb0Zpa3ZCNytkR0Z4ZWJWdEdmaWk1Y29yZHFKWjdjeEhRa1pH?=
 =?utf-8?B?VWNVN3pvM2F2Y2VjcWh3bGFMd0JzWnhlQno5UUgybnc4Tk9yZW9ieG1zM054?=
 =?utf-8?B?bWtzZnFnZCs3Y2c2Q2JjcW8vNG5VZ1VNSEVJRFRlNHJOSGQwNDBkU1NYUHJD?=
 =?utf-8?B?UjVrbEV3d1BxVk1KZWthQkxTdUFGM3RhYkxnM1FRaXl1Y090VGc1MFErRGcz?=
 =?utf-8?B?ODI1UE9NdzVFN3dQbjlsZ0FDNXVsT2R3Z281dDRZcHVnUU5COGhXVGZlOFFW?=
 =?utf-8?B?bzlYUUcxQmFESDdUWkpOaS82Z3JFUERCL1c1MCtmRlFCMW5HN1JOOE1sS2tj?=
 =?utf-8?B?Qi9oLzBqdy9kOW54dVlNRGNlMHVpLzdZUFBxUDRzV2ZwUnQ3c3BVTWo5d09l?=
 =?utf-8?B?L0Vwblo3QmZkYXBNbnNyeFN6UnJTWGdHZVNWekVOVkJsK2FWNjZGTFNvRDFs?=
 =?utf-8?B?K3AwWHN0KytVbzlEQU9wUVBFa1BROFVhRW5mN2pqNTF5LzlISGJ2WWVJM1lH?=
 =?utf-8?B?a0tWU1lDWi96cXRmNjAwbjEvSmNuZXk1cFc0MmR4enZiQUczVWtXc01oNFRm?=
 =?utf-8?B?UzAwaWRBUDZYS1pKMXhSVzZocmFCVS9CcnBpREsvMytDTmFOb2dyd0Qxa2pU?=
 =?utf-8?B?NkxuZEsvM2tySWUxWmRJaUlKbkVCR0FCQmI2NlN1MVpia3lmS1pRSm9KWi9C?=
 =?utf-8?B?MXRublFWeWlCVmNYTWtaUlJacWxqUFlFUm9rSWtEbk1zMEJVL1lrYVpac0cz?=
 =?utf-8?B?V0doalU3Z1VIQTE3OW9tZzUrc1l4UEhUQ3RKWW1saitDNzYyMm1YcXQyNFc0?=
 =?utf-8?B?Vks3bUNTeDVzNFEvMytLNlpPN2ZWbXphNmM2NmJDZHJZSVhCOEgyc2hlaU85?=
 =?utf-8?B?dy9yZlVyUTN2RlJLY1Znci9pckF6UGh4NmRSYnlXOXZ6TkI5ZzZ6cDhtUEZp?=
 =?utf-8?B?b2VJUXZKaUhuUVEzam9EZDVqUXUxcEJSSGFXZzF2aVpYb3BVZFlBSU1jRHMz?=
 =?utf-8?B?aENLdEhzM0lwOHdieEhFNWp4N3RKT1A3YzZ5NmdXam94aFlBS0hUa29KaFpI?=
 =?utf-8?B?WFhQR3ZyTFg0Tjd0NGdQZGZhd1dGQ0VvdlIwcG4zS3NsdGdqblM2VEY2OXRo?=
 =?utf-8?B?RUtITHYyRFNrT3BsMHRZVnNQQnhIOW1VSjNYWlpuRExBU1VSeHQxRmpPZkE4?=
 =?utf-8?B?OVBaNWlHaFgxbmFZZ1pWUFdUako4ZnV3cGRTaGxyc1Q5NnBQb05JM2xSV01o?=
 =?utf-8?B?VkljcVg5Wmt0NVhKdm5yYnNPZ25NditoMWs2bjc2SlgxRnA0NElCK3d2MzBj?=
 =?utf-8?B?MEYvdVgwVC9JMmoycnNtVWZ0aHpYSU41MkQ3TFdzZ3UvRlk2WWltTGpjSXZu?=
 =?utf-8?B?ZXdiWm9QelJudCtNQlBwajZRSjc5WERjMzlza09RVmY4bUZmbXorOFM0ZCtH?=
 =?utf-8?B?ejNRN3J1VktLWE9Obm4zNlg1NmxqVlRnVThVTk9HWklJODRmOFc1Zlp1SXBL?=
 =?utf-8?B?Z3lTYWw4eXRSOXA5aXNQU2N1OExselMzSU1sVHZNSmR0RnJaZi93STRkQkJQ?=
 =?utf-8?B?RXd2ZmVJcW9vK1RwQ1B4djF5bGk2c1VmOXN6TVcyQ2FUV0c0YnNMMlZ3ZDAx?=
 =?utf-8?B?aW13UWcza29LNmdlcWJ4RGVmSzVwbVMzRnVHeWJsK3dGcEZWaWhJMW82R29W?=
 =?utf-8?B?MWR3eGMybzI1RDBWSXo5LzQ0L1U4RFZpc3AxTVoyYmI5amxUd2tQSUM3c1NR?=
 =?utf-8?B?RW5QTjdhUi9XZ0JnMnZPZnBZZ1M0Y1IxbGEwcDJubVFRRVU2d1FkVG0rdWty?=
 =?utf-8?B?aGpqNFp2TW5xVVZTNnpiYTBQMHJjcU5GdGJqcnpDb3d3VVZNU0wyWWRqRHl3?=
 =?utf-8?B?N0U0L0NRN3R2OFhhLzFMV000eXUrbmlvT1VOcVZNLzdDdXhtb1BDQU9Hb3dk?=
 =?utf-8?B?SVdHbW9QZERNZmV1L0xMVzZDQlFkZktUclorSnVIai92STRMclhVSFNKQ3Jh?=
 =?utf-8?B?d2hmZVdFV1loemtQTUJOalZZMHJ2N05ncUJoK05hbVYxSUpKaEI5Z3EwV1NI?=
 =?utf-8?B?RWJEZDIzODl1by94NVBZRmFVeGxhNng0SE5DSWpxL25rQllMODdOL2NML2VJ?=
 =?utf-8?Q?V4R7TfbHan/wW/twrJ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24620fda-20df-4dbb-ed6e-08de5ea0bd2f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2026 19:09:19.6385
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IS/TZz+V0F//7Lwqo8eFPzBnusB2HVU3Obh3SCzkzMx/usWCpJhKu3ixBgd0cx4ybOMbGleq8C5FtQUKcBnGLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8519
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69406-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[14];
	DKIM_TRACE(0.00)[amd.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[thomas.lendacky@amd.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:email,amd.com:dkim,amd.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: D63A3A8102
X-Rspamd-Action: no action

On 1/26/26 16:42, Kim Phillips wrote:
> AMD EPYC 5th generation and above processors support IBPB-on-Entry
> for SNP guests.  By invoking an Indirect Branch Prediction Barrier
> (IBPB) on VMRUN, old indirect branch predictions are prevented
> from influencing indirect branches within the guest.
> 
> SNP guests may choose to enable IBPB-on-Entry by setting
> SEV_FEATURES bit 21 (IbpbOnEntry).
> 
> Host support for IBPB on Entry is indicated by CPUID
> Fn8000_001F[IbpbOnEntry], bit 31.
> 
> If supported, indicate support for IBPB on Entry in
> sev_supported_vmsa_features bit 23 (IbpbOnEntry).
> 
> For more info, refer to page 615, Section 15.36.17 "Side-Channel
> Protection", AMD64 Architecture Programmer's Manual Volume 2: System
> Programming Part 2, Pub. 24593 Rev. 3.42 - March 2024 (see Link).
> 
> Link: https://bugzilla.kernel.org/attachment.cgi?id=306250
> Signed-off-by: Kim Phillips <kim.phillips@amd.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  arch/x86/include/asm/cpufeatures.h | 1 +
>  arch/x86/include/asm/svm.h         | 1 +
>  arch/x86/kvm/svm/sev.c             | 9 ++++++++-
>  3 files changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index c01fdde465de..3ce5dff36f78 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -459,6 +459,7 @@
>  #define X86_FEATURE_ALLOWED_SEV_FEATURES (19*32+27) /* Allowed SEV Features */
>  #define X86_FEATURE_SVSM		(19*32+28) /* "svsm" SVSM present */
>  #define X86_FEATURE_HV_INUSE_WR_ALLOWED	(19*32+30) /* Allow Write to in-use hypervisor-owned pages */
> +#define X86_FEATURE_IBPB_ON_ENTRY	(19*32+31) /* SEV-SNP IBPB on VM Entry */
>  
>  /* AMD-defined Extended Feature 2 EAX, CPUID level 0x80000021 (EAX), word 20 */
>  #define X86_FEATURE_NO_NESTED_DATA_BP	(20*32+ 0) /* No Nested Data Breakpoints */
> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> index edde36097ddc..eebc65ec948f 100644
> --- a/arch/x86/include/asm/svm.h
> +++ b/arch/x86/include/asm/svm.h
> @@ -306,6 +306,7 @@ static_assert((X2AVIC_4K_MAX_PHYSICAL_ID & AVIC_PHYSICAL_MAX_INDEX_MASK) == X2AV
>  #define SVM_SEV_FEAT_ALTERNATE_INJECTION		BIT(4)
>  #define SVM_SEV_FEAT_DEBUG_SWAP				BIT(5)
>  #define SVM_SEV_FEAT_SECURE_TSC				BIT(9)
> +#define SVM_SEV_FEAT_IBPB_ON_ENTRY			BIT(21)
>  
>  #define VMCB_ALLOWED_SEV_FEATURES_VALID			BIT_ULL(63)
>  
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index ea515cf41168..8a6d25db0c00 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -3165,8 +3165,15 @@ void __init sev_hardware_setup(void)
>  	    cpu_feature_enabled(X86_FEATURE_NO_NESTED_DATA_BP))
>  		sev_supported_vmsa_features |= SVM_SEV_FEAT_DEBUG_SWAP;
>  
> -	if (sev_snp_enabled && tsc_khz && cpu_feature_enabled(X86_FEATURE_SNP_SECURE_TSC))
> +	if (!sev_snp_enabled)
> +		return;
> +	/* the following feature bit checks are SNP specific */
> +
> +	if (tsc_khz && cpu_feature_enabled(X86_FEATURE_SNP_SECURE_TSC))
>  		sev_supported_vmsa_features |= SVM_SEV_FEAT_SECURE_TSC;
> +
> +	if (cpu_feature_enabled(X86_FEATURE_IBPB_ON_ENTRY))
> +		sev_supported_vmsa_features |= SVM_SEV_FEAT_IBPB_ON_ENTRY;
>  }
>  
>  void sev_hardware_unsetup(void)


