Return-Path: <kvm+bounces-15602-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5066E8ADCD7
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 06:28:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BA55EB23694
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 04:28:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98CB52135B;
	Tue, 23 Apr 2024 04:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Im9WGGAP"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2077.outbound.protection.outlook.com [40.107.93.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F23A20B33;
	Tue, 23 Apr 2024 04:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713846414; cv=fail; b=iJHyGPq/dp4xZdR/EXMg9jiLP3ReVKYMlUfo7kd/QnOwBGIR5VQOdmYZxEWE3lj00THuJnakAsst5flXwo+/RGkANJCQhaH9Zo4efGK21yPSZ9QxmWSgW7I7MeqZ71dlgcprqAd+0Cx0lJUejXbJmEkj9k/JsahWIGfwdQiNbss=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713846414; c=relaxed/simple;
	bh=hz82K3Dq0/YN9Qc5TIqKt1aNDcQXWq3J4IJDAr3FvjI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=FeEnH8fmoPVelxhHH1lnc9m4wkaa/jT49qB50gjNDrucE1bDbNPIuUwry+ayMeU4UC+kKiEPKECR8EqxJTrg1gnhEtTX3IkLX01scHA2MoFqFmt3UjrwLSeXzoBacTyf4UuRn3FbKHIK2IXVNYVEmXJOBqhx5VY/lm+kPZhgRvw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Im9WGGAP; arc=fail smtp.client-ip=40.107.93.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rd2Qa/TFafoKN3JZVJfJKtMWRY/jzKb/irBQXGHQL6ZIcYw8cZeobr032i8UVJxsBvu2s/MtZ82HNNuRBWGEcAhPr6oB7i8PJ/4mwrKe/avCHQrtbgdfSvfwABtiLrKeaF+SFrKFpGXWz5Q8BEnaXiVzVS5HEPn73yXam4pLhbYmeJWmU26Q64hGBfyuWUBY2WmI5QNsZruLSq/9adldhoHvxmTZ6wOjIENI5ZJeqRl/bz0AEUP9mKaltnKgXzeIWOjO1GnK8wg9VO/VwE8+lqzIMTDn15NVIR/0/gZxfkmWEu3YDUbt3T7D7ICaBSoNCxC1WGhQnRYYXAksHFPPYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9dzvKC6lfs0Kh7d+j6V6Pwe4EOvM7QXPbaHOWAFNZho=;
 b=DeatGkQHRNwuL3m3DDU7jEybZZ0x6f3YpisdWwRGvbTqUwfPu0d3PWClespW2GNMYPcfc8ZwlF8w/+7T3Z3W1rKmX+l/hWL/ilqogMcwtbybA42mfKUDNPCQP8/GevU55wEMPTVaV309bt0gkkiYw3b5FCVbx7xJV9ApWbE1vfGzWPQm/YsPDT223ZPSrhlEPLP+83+xOohIg516EBVeTPDyDIvzz7L6xIaXiHRYDFs/Sq/zzvJCGNZfDGpYruR1ZCepGMlV40HeofLUH9TyLGtSjlDcKebHytEtLx8kR0YPvr0Va9yf9ISjHX15yjthDeaeoU91EnBL+icQb32owg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9dzvKC6lfs0Kh7d+j6V6Pwe4EOvM7QXPbaHOWAFNZho=;
 b=Im9WGGAPPK5T+hlfcP5Wcj75WUVQRDPzgv2Mi1Gp6m7GyvncUq8n2N+YlHGCM2+2m5KyGjIUenh6BGZPa5GMAmkTthV7a0OvP6My9cK29lgHIEeYfUwGZh2HMy5m4+D/MwTUDYd9+GcVerZohhIN7dwpsBUjXKC4IZt62Sw+FOY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 IA0PR12MB8929.namprd12.prod.outlook.com (2603:10b6:208:484::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7472.44; Tue, 23 Apr 2024 04:26:50 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%4]) with mapi id 15.20.7472.044; Tue, 23 Apr 2024
 04:26:50 +0000
Message-ID: <eadcab6f-b533-49e3-9aec-dc06036327f5@amd.com>
Date: Tue, 23 Apr 2024 09:56:38 +0530
User-Agent: Mozilla Thunderbird
Reply-To: nikunj@amd.com
Subject: Re: [PATCH v8 07/16] x86/sev: Move and reorganize sev guest request
 api
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
 kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
 pbonzini@redhat.com
References: <20240215113128.275608-1-nikunj@amd.com>
 <20240215113128.275608-8-nikunj@amd.com>
 <20240422131459.GAZiZi0wUtpx2r0M6-@fat_crate.local>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20240422131459.GAZiZi0wUtpx2r0M6-@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BMXPR01CA0094.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:54::34) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|IA0PR12MB8929:EE_
X-MS-Office365-Filtering-Correlation-Id: edc30ffc-e130-4ace-1079-08dc634d9844
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?S2ZRcHd3c0RHNkJTanlhN2RDNG5hTmVyc28rSFpBVS9iME1aSGdBQUhhTXl0?=
 =?utf-8?B?SkozMTIrS1JNcmdEL1N3VGxFUXlqdkE4U3p5YkxVaC9vRWIrRUtOU3ZVYWhu?=
 =?utf-8?B?YXlKWk5JMHFqbC9ENGVLbHVabmt4a3loaHJzbVY0UFJlU0RYdjA5b1FQOVVC?=
 =?utf-8?B?OVdyY2N3SkVmRlZNU2I5YnJaZDRJbks4VjlYMHRaSjcwSm1DQ0JVVHBub1ht?=
 =?utf-8?B?K293QjRqOUdJUkMxUjZSbUxYM2VPMzJnd2hmYTNOUStqSDlYVCtpbnJWU29E?=
 =?utf-8?B?UE9mOHhpLzBjb3NmR3RuRmMyb3hiZThxMWhEbjhkbGJWYUtXRU5UNjh4UU1j?=
 =?utf-8?B?MWZ1KzJtNWJtZms0YjByYzlQOE5USjBzZlc1ZGd2YzNIc25VRDFDbjUrWXFW?=
 =?utf-8?B?cEFRNnR2cHlLTUsyU3RZWWxueFR4cHZNRWl3WlhNVDBrbWZFcXpaWCtEcFha?=
 =?utf-8?B?TlQvNU5CMGJZaGRiR1dyeDI0QjlUclNsT1NleitsR2ZYKzE5RVA3RXNDYUZX?=
 =?utf-8?B?azFnMVpqRis3d3pBQllwV3Y4Y2htUmJkdkhZanZCNGkyU0E1QXNEL2dWVE9M?=
 =?utf-8?B?am85aGlPeDNrazFtcWR2ck1LeWZlQm9CaWFMZ05DREl0WEVRR0NMOThsRUFj?=
 =?utf-8?B?blVyNjJ6dGFKRTl5aTJvOWl0V1NQYW1weVVJQmE2eTZhb1dQVmF6eTUxdjBh?=
 =?utf-8?B?TVRBNnRlVzFqMm5mVURPZlZGOG9ZMVhpaE01TFk3SjA4TjBlRm9haE1JUEFv?=
 =?utf-8?B?ODBZcDc5QjIxRWpEa3ppa08zWHNqKzN1UUpxQU44ei9ncEw1cWFTMFJCdDI2?=
 =?utf-8?B?QzlLdVVsL2NJN041QVdmTzZ3dG50YjNKRDY4eUhlQU9YNkpLd043KzVJSXIv?=
 =?utf-8?B?U2FCNHlXSlllUGN1NEN6NGVKOWNHc1BqZCtCN0oydE5NKzJ5UGVDTm54MTlM?=
 =?utf-8?B?eGlzUjFyMzVXTm4xVzh0d3JQVkhiUVhEYXV0NTBBMGpXNWk1VnMrUVA4Z2tG?=
 =?utf-8?B?b3pDd2RmckpEc01UQXd3MEVGQXRWNlFwczd1NXdqbEk2SDQ0cXhkOGU2Y0V5?=
 =?utf-8?B?clhya215a3B3a3lzOGRFUFBkQWRsR3QvZ0JEZ1FHSGxWaW9PV2l4NWkzWTU1?=
 =?utf-8?B?SXByRk9pYVFrU2xqSldBcE1MVzAvRTQ3TTNQZXdJQ21xQ0tJemJ0alNvR2l2?=
 =?utf-8?B?SzBWY0QzUk14bGdzWDZhUlE1UlZ3cER0bDNGd0F1SUVLVEVnb05IbTJCdmx3?=
 =?utf-8?B?MFFYVk9LeWx1ZmM0ZmdhNVVSSVRvNDdTM1E1MkxseENRR2ZkemxrM2IvYktp?=
 =?utf-8?B?aTdsN2hubFlRTWsrUWZqN1IrN29wWVQ3QmZvWmgxbTNkcWh6N2ZzVzM5MVNx?=
 =?utf-8?B?MGJxbnUvbGtVY2hVWEJ1cm1KaDBDQUpDb1VUeFVBSmw5bkJjYjRhNTdMeFpp?=
 =?utf-8?B?TEV3OWZXU0cwMlJISWY5ZVhOQUdjcHd5Rm5Gd3I0c2F4enM0WkQvUjBjbG9r?=
 =?utf-8?B?VzN6VVVjd3VHdW53NUV2c05qZ2tJdTN5M0U2WGFoQm11Mkhjbzlzb1Zkc1RI?=
 =?utf-8?B?STFqbmFxdXhFNnhtSDM5Z1BvenhvKzhyaS9mWnFvdUxzRC8yM1MyZm45UURP?=
 =?utf-8?B?dXMwc3AyMjJySTVHWFpjOU1wSGJxUjJPWnNzdTc4SWNBVyt4c3k0Q0QxS2xs?=
 =?utf-8?B?UHRoLzRjMVR4bXdwU2w2TDdVWWZxYnlYVC9QNmJFdm9xZVl5TkVOKzl3PT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(7416005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aStZMjdNRDl0OGZUNFVMWTN0OU16MWt4N2EvNGIrOWd5TytpQlMrT3krZXFa?=
 =?utf-8?B?d1I3SHQrcmtwVlJ6Sm0zWGxKbHhuS3NzY0tMVXpWbGxmNWpLSnlGbTlZTEFr?=
 =?utf-8?B?amJiaVZ2RlYrNWdLak5MUVN4cHBraXRvV2tWOTIyL2Rvb0poeGFZVUt6MnRm?=
 =?utf-8?B?NzR6eWRoNlBmUUtKZG5OQUlRbGRpOEFxd1NudDFNNFFXcm9ra3owL2EwdklR?=
 =?utf-8?B?MlJHa3g4dmxDc2Y3NjlaMWJ5WHpJdXlsUVNlVlZVUUprQjBUeHpVSlJJYm8w?=
 =?utf-8?B?NzY4TStheGFQMXZldWo5RU0rblM5Rzl4V1JoekdWRXppMDVQaEJuUlRoOWNw?=
 =?utf-8?B?WlhpOGZWOXQxK3Q3Z3FMTmx3S2ZFcHoxcXQvczBiUFJkR2k4eEYzVi82YkF0?=
 =?utf-8?B?SzZCQ0lrc3kwZFcxTnpUVER3ZU82a2tDWGRlZ1lZU3RLMjVnL0FCc1RJdHp4?=
 =?utf-8?B?TkZqUnV4eXBhMjRNUWtYVE1RU1BGL1VEMjhwZVRTTU1qRlNOV1oxdlN5ME0v?=
 =?utf-8?B?L3ZWUGo3Vm5MSk5KSDhpeDlpYU9odlMzcUMyVDlmY0JIVzNoMVQxQTZTdDBt?=
 =?utf-8?B?cFl1ZVYvREsxSnkzUW8rbmltTkdKSmFzZlN1NlFzL285eFRjZWtGM28rWjAv?=
 =?utf-8?B?OExzNlVRbUp2VTFSN052OWZqdnJRNFZRVzhQeTlHYzloMW9MMS94U1BlZ0J5?=
 =?utf-8?B?VjZ2andpT2kxZFJjSVBMYkdVWlBvUUpUbjZKRC9UNStwaE1KT0VkcTM0Z09H?=
 =?utf-8?B?K05aMURrbzJNZWFyNEZRUHlnN2VORkxEVU1SYnpYT0ZmNGpXTDRrQWVuYXhh?=
 =?utf-8?B?eVZ2bzhHazJNOTdFYXkraUNyTTlxakdad0NxV3VBdllvV05tU0lqWmQrS0Ft?=
 =?utf-8?B?MXFJMElud1pVSGUzZ2d1RkNyTW5BMzhTYUVxZExBM0xCbEEybC9kSE4xSFFm?=
 =?utf-8?B?OUhCSlU4aldieHZPbFowM0xTT2h1Z2thZzFUVG9uazRiUUVIU0E4WHFCdHdy?=
 =?utf-8?B?QWdSVmlqbXlDeXN5VXlMd3JFTmw3Mk9VeE5PMFZaSHhFMEw0UGpxUWJkdmVF?=
 =?utf-8?B?SkRsWXc3VHlxNGlTaDk4UzFpV3plc2xOVXA1amVLZTYvbUVwNWJOWHMwdnU4?=
 =?utf-8?B?ZDNtc1p4eWVDQmFucWNnbFdrOGpIWEFlNzdodVdhZFlsK3E4TGgvZkF3a2xk?=
 =?utf-8?B?L2lreklRSmh2VE9LYzIwTWRvZ0hFQXVCZ2Z3b3lYNi9SL0YwZlNEOXJkcm9h?=
 =?utf-8?B?aXEvbURxMzV3bDdaRDJDcVNjbWpqdEdUOWtLbFZwTlRFOGlObWJ6VVZwRjhD?=
 =?utf-8?B?aDFkWmVBOVFXVXkvOW16UndpdkI5VXljdExyVi9HazVzc0xFYzY5Q2ZhdzJP?=
 =?utf-8?B?d0x0RVpyTDh4TTI3MHFLZHZ1K2RnLy9KcmVsM3Z3ZG5VaXJ5bytlWTBTbERW?=
 =?utf-8?B?MElkRWdnaDlxclRWWTMvcnNTNGdtTTR6SWxRMGVaT1pRSFAvWkU1UURFQ0Nr?=
 =?utf-8?B?WFQzeEo0REVkTXBVNTdUWU5Penc3MmVmTko5a3JrZHJURXlvU3pCZDIwb0JV?=
 =?utf-8?B?SnplQ1J6c2JGTTJiVVV1dm9vSEZhKzZ2TGJKSStycWM4NThFeDgvTXcrbzFn?=
 =?utf-8?B?N21mRGJRZzlxODZJNEV3d1dGZ1dPdjlNdnJWcGE0aWE0SFFPaXZiRk9TbERY?=
 =?utf-8?B?NW5tZGE4TGdlSlBJYzlTYS94WjNQR3hnUml4VXBZcjlkUWl4K210T2paNHlR?=
 =?utf-8?B?U2k0Z3FCWFprTkhGVkxDWjhMMnlBNG9paDd1WnBnRHdTckFOajV0Y1RUWFg0?=
 =?utf-8?B?YmtQSFZpYVQ2blBLbzEvcS9IUnZXeUJqTWZyN3prNWZmVnFCZWJ6VkxPbjVJ?=
 =?utf-8?B?M01zYW1reGRMMy9wMStGVFpJYTYzeTJ5Sis1bjIrSFBWaGxnVVM4UGJrZjRW?=
 =?utf-8?B?ZXd0NjhNOVdVS3NweERZVm5taVYzd2tPWFljSWNJVzJzbkhGczJ2Q25MckVk?=
 =?utf-8?B?V1VpUUJYSnFoTmlOUS9scW5GQTFuK2F0bXZ5RXVLM2lPVnpFNEloNHBVN0Zs?=
 =?utf-8?B?NHNCVHNOdEhlQXU1NHZRYnEwMHdTZllwV216aHU2alVJK081TG5qTm91Nmhx?=
 =?utf-8?Q?ph6iISRloKZSWH12g07EvRyMZ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: edc30ffc-e130-4ace-1079-08dc634d9844
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2024 04:26:50.1447
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uM4Lo0yVv5l4fMCDX8RfMpA1VgD3GDrD9UKu24dn42krYm0Th8opWT+BQ4B1HgUHUJIPw+05boU5UIVSlDN3pw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8929

On 4/22/2024 6:44 PM, Borislav Petkov wrote:
> On Thu, Feb 15, 2024 at 05:01:19PM +0530, Nikunj A Dadhania wrote:
>> Subject: Re: [PATCH v8 07/16] x86/sev: Move and reorganize sev guest request api
> 
> s/api/API/g
> 
> Please check your whole patchset for proper naming/abbreviations
> spelling, etc.
> 
> Another one: s/sev/SEV/g and so on. You should know the drill by now.

Sure.

>> For enabling Secure TSC, SEV-SNP guests need to communicate with the
>> AMD Security Processor early during boot. Many of the required
>> functions are implemented in the sev-guest driver and therefore not
>> available at early boot. Move the required functions and provide
>> API to the sev guest driver for sending guest message and vmpck
>> routines.
> 
> Patches which move and reorganize must always be split: first patch(es):
> you do *purely* *mechanical* move without any code changes. 

Yes, I had tried that compilation/guest boot does not break at this stage. 
That was the reason for intermixing movement and code change.

Let me give a second stab at this and I will try just to make sure compilation does not break.

> Then you do the code changes ontop so that a reviewer can have a chance of seeing
> what you're doing.

Sure

Regards,
Nikunj


