Return-Path: <kvm+bounces-60020-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 43965BDACAF
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 19:38:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5476A3BB011
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 17:38:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB1413019A6;
	Tue, 14 Oct 2025 17:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="4w4gswMk"
X-Original-To: kvm@vger.kernel.org
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011066.outbound.protection.outlook.com [40.93.194.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF573221555;
	Tue, 14 Oct 2025 17:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760463495; cv=fail; b=pSa3QYGXebLynPcQqdDVhmsQiBF/FdILSr9NzybSl6mgKu684DJForrhDoL4leVfywUEQu2Fe4vwOqdQ2thi7AwGH79C5qw+0X2ByJn+bW/MXh5WsiUS5hUqsX/gQXzWvwQuF00F2F0xU5vfemA9zWMW8GVdj1+Znf01yM7Opu8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760463495; c=relaxed/simple;
	bh=BTJK6M7eAFAL79FeEVbqe8R+11+F2l/Jat5mlz5L7OI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=CHgRcCAzyLotxL5sYN0WdWThMagm96mGsRMsueUp6nCgNicDqHdcmzWnyPwGkIUHAHTHOtLRTRvtX0f8KmWciiaNvDbYoI8M1oGF+qDAzDASDWT4Lr9C+GPHJr+PupXe0F7rvsRxjJC5pKz8fpXqCN1thVmBW7gbtyEekvEpaLA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=4w4gswMk; arc=fail smtp.client-ip=40.93.194.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MMboxOe2T2guSqtlti1rvT5N+scNtyBP4mxfBVQa0MtDyFrb4h3G2DOxcE47OxOJBS/JIzzXhzUbE0eGAViTYdjzL3Q9sE2AT/X9xnBGnTjJesDScgw7BchnmGxrtCoWcBxiEc2vqwwWX8xymZhgu2NFRwug6UmdVztOMOLjt+N1qqyE/sq9TALIAQLkQc8SesyiZzIGqE8byLQOWur3fqMq/O7NP179MKm9XhEHqBUUpoTbngmv/xBqAguDZKInbcMho5JRIIIVaR9FETumjTVuhUR9aSllsIdYJ49llut0sz+fhtlv+YSKutrz49GAy2ZOKa74KEd89wspX8Zv6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=unocId+db402jiqWjEBXa3DwHfZq2zSPc8dfVDCUEwo=;
 b=TvUr5zBkEdLJqI/ZKu8HnAjd4jD2mle22VfKgEEuGqRxjnUchktLwuDP0IvfuXdwA9/c60Gi6NCK7W1IotvJFAdOXyu28FHXGDy7Ledl6ggIbMRHpXax6K6AubUJq4J3dRr9LbLP8rZOhw4tW5PbgokhEraho2RybLibnYjH/PwwOgwTUEw//vrZlGownQah8feniu+a+Ji06Ye2xpMbmoxSj9SfbInqILXk5YWyxEj6Crm4/3IV6OWq345dnbx6Yz6TQ+7a29D0ZXHxx46cD8BGSZdajhP1Zdt1DLZx93n5Ti4Fdtf+ENqbd38VbMrg/FPHjHRkFndNuqgJOWTo0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=unocId+db402jiqWjEBXa3DwHfZq2zSPc8dfVDCUEwo=;
 b=4w4gswMkcnb3STWgdKtlYmo56GYwbc9oCTAUjpuyg2/iLAz/toIK7J1zpVzu7fb8rwKt6h3KRdA4m1GRiM2VpT7HRSLfnUHGOVmqT4F/c4B64LhPx6A+CpitEWIB2XRqo+jyuXQVlFuXVrfBZ36PlHAzeCyHPoQEV3g3jfdgMRs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc) by CH3PR12MB9195.namprd12.prod.outlook.com
 (2603:10b6:610:1a3::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.10; Tue, 14 Oct
 2025 17:38:08 +0000
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::8d61:56ca:a8ea:b2eb]) by IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::8d61:56ca:a8ea:b2eb%8]) with mapi id 15.20.9203.009; Tue, 14 Oct 2025
 17:38:07 +0000
Message-ID: <0e52d4fe-0ff7-415a-babd-acf3c39f9d30@amd.com>
Date: Tue, 14 Oct 2025 12:38:05 -0500
User-Agent: Mozilla Thunderbird
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
 <0cd2c8ac-8dee-4280-b726-af0119baa4a1@amd.com>
 <1315076d-24f9-4e27-b945-51564cadfaed@intel.com>
 <3f3b4ca6-e11e-4258-b60c-48b823b7db4f@intel.com>
Content-Language: en-US
From: Babu Moger <bmoger@amd.com>
In-Reply-To: <3f3b4ca6-e11e-4258-b60c-48b823b7db4f@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA0PR13CA0010.namprd13.prod.outlook.com
 (2603:10b6:806:130::15) To IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PPF9A76BB3A6:EE_|CH3PR12MB9195:EE_
X-MS-Office365-Filtering-Correlation-Id: a2bef2c0-6b8a-4498-515c-08de0b486fab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bzR2bWE2RExxZXJrODBML1FBeURoOHlGOS9EWWVnTXdUUTk5SWdHSDJOcWZw?=
 =?utf-8?B?UktnYmlnMk9RMFNrTTJMdlhIM3AvYzhpY2hxV2ZHQW9wb0FYNU0yMmhBRDhC?=
 =?utf-8?B?NDE0NHlXRnMxU2F1aW9YTTA1MFhBampzVnJHQmNJdzhJMUd5TWtEeEhmdktW?=
 =?utf-8?B?K29YTzdkWjZHaVl2dFMrdURDTVI3ZkorV0taNWNqT0sycVBkcWUzdUgySGd3?=
 =?utf-8?B?bTNSbGx6cDh6QVkydkV1ZDlzWlplbDRvVlQzcFhLVUcvRmpNM2pnV1R6OXNC?=
 =?utf-8?B?WENqNWo2WWQ1Tk9XVXFaQUJnVEovWng4RG5Ya1NuTmtodDB6MG1sQ21KdE9X?=
 =?utf-8?B?TllpZTc3blpYVmRHNGZMTEZmekJ2NkFWa0ZPYnNOa3lBVUV1L2orMFRqZEJZ?=
 =?utf-8?B?ckUxeFNHM3d2bXRFYXBQdzU0K0ppMlFQK2hyOTVTMlg5b0xOcmsvZW94bE5j?=
 =?utf-8?B?dGlLZGFHNmpRMTZBa3EwYjhDYUUxY2FXZGlhVWRTZWM3Mm1xcUNFaWNQSGVp?=
 =?utf-8?B?NTduUWRvOS85dC9FbWpmRm8zUFVZamhSZElnaDA1WE4waHdLWDJoRktkTDZV?=
 =?utf-8?B?UmxEQTduY0Q2TTdqYm42WFo1MGg2eENIMDNMc1VZK1FJb1BwL09XaGE5M21h?=
 =?utf-8?B?NmtuVDNOMXlBaGJQU1dZUjNuVXJ3L3RhSVVLUkFpWWp0bGtQQkhmam5ZUmd2?=
 =?utf-8?B?T2dsTzM4Y2E1a2lvSE5hK011NXdKUnNWRDFHRFRKZGNiZGZSWlFjOVhFMmta?=
 =?utf-8?B?b0p0MjEyMDNVZ0pLOFJ5K0RMVS9MUnVQUHZTWTB5R2VDcTNjdEtKd1FGQlEw?=
 =?utf-8?B?TzAwbHg0RkhqNDNPZnNaZUs2YkFNYmRvV2VkSTBuT2tjMVh6NGhiY21rbkFj?=
 =?utf-8?B?U0wzb00yRGJLbHlGMGdtMm9JQnJtT3lXbytSVkkrU1ZlbFFOWFdPYXM0Q1Bk?=
 =?utf-8?B?U2JvZlFaY1pRaUE5T3AvRndLOTBrd0x1OVNveDlCeFlDS1Rxa0E3RjUzaCtn?=
 =?utf-8?B?VGVtVWVkcUo4bFVwUXdENUxjNkRGazczUkNPb251Sm1CRldaSDhKZlg4LzJm?=
 =?utf-8?B?L2QvZVQ4U0p3SHhTTXN1a0VWNURJVWNBMUsrQ2wwYnMwNVlDVnBpTFkzRkph?=
 =?utf-8?B?ZUJUTUk0d2Ird3ppS0pPL1VYNVR6TkdDZndBemVwZXY0N284THo1bGVNVGRp?=
 =?utf-8?B?TUhMQ2M3TGdzeU1MdlZDdHI2L21pU0ZIUTdUTWF4YVo2eldsYVA0Y3QwTU9X?=
 =?utf-8?B?Q3k5aHRBbjh5ZklpOGQ0RWxqb3lVN05GQ3cxRkQ2S3NjSCtPWW9acnByanRG?=
 =?utf-8?B?R1ZnZEdoaUNjS1ovL0UzMVBpWVp3bXpTRG02bTZ4M0tpajR2elA1eTEvZ1NH?=
 =?utf-8?B?OFFmMFpveFRwMm5SK0lEMThmcDIwV1ZwdW5NNGk3Rk9XZWtvdkJUdDZXdXFW?=
 =?utf-8?B?N3lUTGx2cTZlQ1ZmOTRHRU9mZ2daN1RFblFQRjhmdnd4V1VCTHJTbHJLSlBJ?=
 =?utf-8?B?dmR4MkhLZkgvNzM3UzEvbDRyZFBxNFJQbldPYkdBc0N0Z0pUMC8wTlM2bG5N?=
 =?utf-8?B?RFE0MzlON1NFbVdjRzhrM2wxUkgrNm9kTkxGVkJwVXhJQlMrMDhwQ0lzTm1R?=
 =?utf-8?B?eDVMMVI0TVdzS0ZYek15LzNhZlhxRE9lSTlyMFNVbis3dVhLUVUwc2IzVURw?=
 =?utf-8?B?N2dvaWROanFWT2VvOFhib1oycE9FNjdSRmx3a3VuYktDbHdncFRQMlVSamFY?=
 =?utf-8?B?aWt1NE1JbHcyNmM0L1pvNzBpcjJ3UEkrekRMWnIyZG1lRkRVUSs3cUN6WEtu?=
 =?utf-8?B?NjNnNmdxZzhlMWZqM1BnU09RWmVHYWZMOW12dHBnRnRld0h4WXp0TnlBT3BD?=
 =?utf-8?B?czRHclk1bm1wUDRXQXpHTHcra2ZTZjZrc0VNZEpPeGhXMEhGV1c3VVBJYWhl?=
 =?utf-8?Q?Rr2neuqxBrU7951Ksm8f/tqixgG0v901?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PPF9A76BB3A6.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cUxNMU9IbXJQZE5HRTBoMS80bExmY1dVaHFOWFhNZHVuWnUvTEhKNGZMWlJo?=
 =?utf-8?B?TkN5OG1VWEtJNCs0UkdOZ1hYSlJuK0pJUzlkVWttNWMzRzV0ZDFjQ3F0UjFv?=
 =?utf-8?B?N2YvL3FicWk3YVpCb0M5MDdLNENaQnpqQnFRd1ZtRldqT2Z6WlhLOURPTFNm?=
 =?utf-8?B?TEtGWTVvWEpDSkpSRHpqTkJxNUVBZjlMWVMrNzFmV2djcGVpODBqbUNNVWx2?=
 =?utf-8?B?bjNsdmU4enlOL2d3OE9NRkpPRVMrazUrSlpJQzNTQVE2RHp1NFNkaUZOU1h1?=
 =?utf-8?B?MzZwTzFjZnZOeExiSmVvcDJPREk3SnhvTGpnSUJiOGNlQ215LzZUR2xOdVB3?=
 =?utf-8?B?cFV3VVhsK3IrUzRUZkJUUUxxRGsvZHR3Z2NkUGxUT1lsSWh2WktydUtWWHIy?=
 =?utf-8?B?eXBMZXA0NTllTG5VMzZsYmw1dlVNTVU5MmZ6RjVJTVFHNFhra2VCRUFuVXVz?=
 =?utf-8?B?MjlBZjhZK1RubjQ3UUxTSHdZRmxJelJ3TytoZnpWUEVHN0JxeUx1SWxJRS9Z?=
 =?utf-8?B?SExPWllxY0kwU1ZxellFbDQ5bVlzeGNzdGU2TGpZdy9wd1owVnA2b09zMzBY?=
 =?utf-8?B?VENGbVp3R1BHejNWWHhKbEVod25OOFo3QmxQODh6cWNXV2VIdEFpckFWWUFU?=
 =?utf-8?B?N2I1b2ZpeWpCc041TmZnaEpwRDRVMGtMdlhoNGc1cnE5RVk3MWM4L1pPcDlU?=
 =?utf-8?B?TmpRUWJoZnM0d05vVlozQURpdkpKV0xWZkZWcE1HMzh3UkVndFpkQ0hqc3Yw?=
 =?utf-8?B?TWFOdHpWblpWL1pVbkhBY055ME5sdnd6RXFLTzZWb3hEc2tPZmFEek9XeG1B?=
 =?utf-8?B?WGdRM00rRG1CVGFkTFhOWVRaLzR5ZmJWWlpEeDNRQ0tjY0V0eWhnTXdBMU9V?=
 =?utf-8?B?a05ueEhMakh5MUNGTE1mTktKU0FaT1JNSXpaNDdpN0JybnVVb01PUmtmazEr?=
 =?utf-8?B?bWhsYmJBb2xweDJVcmE1V0ZnK2RKelVXZ1dURktZSWNDcHdyeUpjMHdlRkR2?=
 =?utf-8?B?VCtuL2J3N05MTXZZZE12MGdrUUFFK2c2QUh1MzBrb2JkbTBlK3JaM3J2YmZK?=
 =?utf-8?B?Z3MvNjRCTEtaYjZTK2tDbGpWSFBNWHpRWHF5aE1LblJmNTVvS3ZnSU90UXVU?=
 =?utf-8?B?a3oycU1uOWpVaEJBNDRrS0hYbTlPV0hvcHBEZ05nM01IUWc0RFBkRy9sQU5D?=
 =?utf-8?B?S3NnRUlSbEUwMklCMHlSOVNlNWtyazNIZ2JTR2g2ZEplSEJOZVdDMm5WSEUv?=
 =?utf-8?B?UkpLbndMYjE4U0JWQjVlemNKVWFkdnBrL2FFYzg1RmdCSVV1THdxMEdINXpy?=
 =?utf-8?B?cWQ3R0NvQ00wbzU1ekNhSGFESHB2N2JBRnBERlBvRmN5em1td09sZ2cxbHQx?=
 =?utf-8?B?V1ZKMUpYZWhXekdPbEJEZm92cW1uejRmelRleHd1ZWFaNzRiZ0t4MW9seWhH?=
 =?utf-8?B?TDc0eVlXMFFzeUZMcTJiT2dHSUxwa3V4NGRMZ0pIaVRSZkJpa1pLS285eTdS?=
 =?utf-8?B?V0J2alM0a0JiU2JkRkx2dzdoUDJJeFZSZkpUZTZoSjRaSVVrOWRTKytWNHBD?=
 =?utf-8?B?Tyt3Vm5CVXROQUhkOHZWQXJ0ekNIZDZ5aFF6eS9obis2V0VNWFVWZllpRWlQ?=
 =?utf-8?B?Yi9LdWlteXA2RlZabzY1N0tlS0dwdlRJZVVnbVhyVWZMTW1EbERUd3Y2ZS8z?=
 =?utf-8?B?eXllNzdONW1uNTZoL0dDdC82U1Q0eGlXVWNVTis3TUFMekdnNU1GUkdUMW9M?=
 =?utf-8?B?REt4SksyaEdjSTIzc3B6bTI1ZDJEaE42YmlIbzFlR2lsd3hQWDI4Q3VTTE8x?=
 =?utf-8?B?Z0pLbklnNDE3ZFZTdHp3RlBmMm9xaDRNMWQ1NlRJaVF5UXlKUmxCY2JsRGV2?=
 =?utf-8?B?S3MyaWtGdlFDYTZvV1c1MU9hRmdieEsyb3hVUFZMMmdWM1lrZ1h2ZEdhQmhG?=
 =?utf-8?B?SEJrQ3ZBYjAwZ1ZBUnptaUdxVnZ1R1FodGpUeEpPaWdOQXYvS3dhZGZ4dzN6?=
 =?utf-8?B?SkZWZ1FIdE9FWnkySm9wZlNBVS95SlpvVUlPTXNkZ2FXK0NJcS9iZnI4MFIx?=
 =?utf-8?B?NlY1LzhUMXNVVGcxamdBeE4wanNnVEdwR1haTWF0NHNmMVVlZmV1a0JCdjFl?=
 =?utf-8?Q?Ru48=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2bef2c0-6b8a-4498-515c-08de0b486fab
X-MS-Exchange-CrossTenant-AuthSource: IA0PPF9A76BB3A6.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2025 17:38:07.3734
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: woqx6Swm0SYqQeupXgQtRjZql048uaTke+X9kL4lDBMpQjZkU4F2b+BZtE7n0BL5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9195

Hi Reinette,

On 10/14/25 11:24, Reinette Chatre wrote:
> Hi Babu,
>
> On 10/7/25 7:38 PM, Reinette Chatre wrote:
>> On 10/7/25 10:36 AM, Babu Moger wrote:
>>> On 10/6/25 20:23, Reinette Chatre wrote:
>>>> On 10/6/25 1:38 PM, Moger, Babu wrote:
>>>>> On 10/6/25 12:56, Reinette Chatre wrote:
>>>>>> On 9/30/25 1:26 PM, Babu Moger wrote:
>>>>>>> resctrl features can be enabled or disabled using boot-time kernel
>>>>>>> parameters. To turn off the memory bandwidth events (mbmtotal and
>>>>>>> mbmlocal), users need to pass the following parameter to the kernel:
>>>>>>> "rdt=!mbmtotal,!mbmlocal".
>>>>>> ah, indeed ... although, the intention behind the mbmtotal and mbmlocal kernel
>>>>>> parameters was to connect them to the actual hardware features identified
>>>>>> by X86_FEATURE_CQM_MBM_TOTAL and X86_FEATURE_CQM_MBM_LOCAL respectively.
>>>>>>
>>>>>>
>>>>>>> Found that memory bandwidth events (mbmtotal and mbmlocal) cannot be
>>>>>>> disabled when mbm_event mode is enabled. resctrl_mon_resource_init()
>>>>>>> unconditionally enables these events without checking if the underlying
>>>>>>> hardware supports them.
>>>>>> Technically this is correct since if hardware supports ABMC then the
>>>>>> hardware is no longer required to support X86_FEATURE_CQM_MBM_TOTAL and
>>>>>> X86_FEATURE_CQM_MBM_LOCAL in order to provide mbm_total_bytes
>>>>>> and mbm_local_bytes.
>>>>>>
>>>>>> I can see how this may be confusing to user space though ...
>>>>>>
>>>>>>> Remove the unconditional enablement of MBM features in
>>>>>>> resctrl_mon_resource_init() to fix the problem. The hardware support
>>>>>>> verification is already done in get_rdt_mon_resources().
>>>>>> I believe by "hardware support" you mean hardware support for
>>>>>> X86_FEATURE_CQM_MBM_TOTAL and X86_FEATURE_CQM_MBM_LOCAL. Wouldn't a fix like
>>>>>> this then require any system that supports ABMC to also support
>>>>>> X86_FEATURE_CQM_MBM_TOTAL and X86_FEATURE_CQM_MBM_LOCAL to be able to
>>>>>> support mbm_total_bytes and mbm_local_bytes?
>>>>> Yes. That is correct. Right now, ABMC and X86_FEATURE_CQM_MBM_TOTAL/
>>>>> X86_FEATURE_CQM_MBM_LOCAL are kind of tightly coupled. We have not clearly
>>>>> separated the that.
>>>> Are you speaking from resctrl side since from what I understand these are
>>>> independent features from the hardware side?
>>> It is independent from hardware side. I meant we still use legacy events from "default" mode.
>> Thank you for confirming. I was wondering if we need to fix it via cpuid_deps[]
>> and resctrl_cpu_detect() to address a hardware dependency. If hardware self
>> does not have the dependency then we need to fix it another way.
>>
>>>>>> This problem seems to be similar to the one solved by [1] since
>>>>>> by supporting ABMC there is no "hardware does not support mbmtotal/mbmlocal"
>>>>>> but instead there only needs to be a check if the feature has been disabled
>>>>>> by command line. That is, add a rdt_is_feature_enabled() check to the
>>>>>> existing "!resctrl_is_mon_event_enabled()" check?
>>>>> Enable or disable needs to be done at get_rdt_mon_resources(). It needs to
>>>>> be done early in  the initialization before calling domain_add_cpu() where
>>>>> event data structures (mbm_states aarch_mbm_states) are allocated.
>>>> Good point. My mistake to suggest the event should be enabled by
>>>> resctrl fs.
>>>
>>> How about adding another check in get_rdt_mon_resources()?
>>>
>>> if (rdt_cpu_has(X86_FEATURE_CQM_MBM_TOTAL)
>>>      || rdt_is_feature_enabled(mbmtotal)) {
>>>                  resctrl_enable_mon_event(QOS_L3_MBM_TOTAL_EVENT_ID);
>>>                  ret = true;
>>>          }
>> Something like this yes. I think it should be in rdt_get_mon_l3_config() though, within
>> the ABMC feature settings. If not then there may be an issue if the user boots with
>> rdt=!abmc? I cannot see why the rdt_cpu_has(X86_FEATURE_CQM_MBM_TOTAL) check is needed,
>> which flow are you addressing?
>>
>> Before we exchange code I would like to step back a bit just to be clear that we agree
>> on the current issues and what user space may expect. After this it should be easier to
>> exchange code. (more below)
>>
>>> I need to take Tony's patch for this.
>>>
>>>>>> But wait ... I think there may be a bigger problem when considering systems
>>>>>> that support ABMC but not X86_FEATURE_CQM_MBM_TOTAL and X86_FEATURE_CQM_MBM_LOCAL.
>>>>>> Shouldn't resctrl prevent such a system from switching to "default"
>>>>>> mbm_assign_mode? Otherwise resctrl will happily let such a system switch
>>>>>> to default mode and when user attempts to read an event file resctrl will
>>>>>> attempt to read it via MSRs that are not supported.
>>>>>> Looks like ABMC may need something similar to CONFIG_RESCTRL_ASSIGN_FIXED
>>>>>> to handle this case in show() while preventing user space from switching to
>>>>>> "default" mode on write()?
>>>>> This may not be an issue right now. When X86_FEATURE_CQM_MBM_TOTAL and
>>>>> X86_FEATURE_CQM_MBM_LOCAL are not supported then mon_data files of these
>>>>> events are not created.
>>>> By "right now" I assume you mean the current implementation? I think your statement
>>>> assumes that no CPUs come or go after resctrl_mon_resource_init() enables the MBM events?
>>>> Current implementation will enable MBM events if ABMC is supported. When the
>>>> first CPU of a domain comes online after that then resctrl will create the mon_data
>>>> files. These files will remain if a user then switches to default mode and if
>>>> the user then attempts to read one of these counters then I expect problems.
>>> Yes. It will be a problem in the that case.
>> Thinking about this more the issue is not about the mon_data files being created since
>> they are only created if resctrl is mounted and resctrl_mon_resource_init() is run
>> before creating the mountpoint. From what I can tell current MBM events supported by
>> ABMC will be enabled at the time resctrl can be mounted so if X86_FEATURE_CQM_MBM_TOTAL
>> and X86_FEATURE_CQM_MBM_LOCAL are not supported but ABMC is then I believe the
>> mon_data files will be created.
>>
>> There is a problem with the actual domain creation during resctrl initialization
>> where the MBM state data structures are created and depend on the events being
>> enabled then.
>> resctrl assumes that if an event is enabled then that event's associated
>> rdt_mon_domain::mbm_states and rdt_hw_mon_domain::arch_mbm_states exist and if
>> those data structures are created (or not created) during CPU online and MBM
>> event comes online later then there will be invalid memory accesses.
>>
>> The conclusion is the same though ... the events need to be initialized during
>> resctrl initialization as you note above.
>>
>>> I am not clear on using config option you mentioned above.
>> This is more about what is accomplished by the config option than whether it is
>> a config option that controls the flow. More below but I believe there may be
>> scenarios where only mbm_event is supported and in that case I expect, even on AMD,
>> it may be possible that there is no supported "default" mode and thus:
>>   # cat /sys/fs/resctrl/info/L3_MON/mbm_assign_mode
>>    [mbm_event]
>>
>>> What about using the check resctrl_is_mon_event_enabled() in
>>>
>>> resctrl_mbm_assign_mode_show() and resctrl_mbm_assign_mode_write() ?
>>>
>> Trying to think through how to support a system that can switch between default
>> and mbm_event mode I see a couple of things to consider. This is as I am thinking
>> through the flows without able to experiment. I think it may help if you could sanity
>> check this with perhaps a few experiments to considering the flows yourself to see where
>> I am missing things.
>>
>> When we are clear on the flows to support and how to interact with user space it will
>> be easier to start exchanging code.
>>
>> a) MBM state data structures
>>     As mentioned above, rdt_mon_domain::mbm_states and rdt_hw_mon_domain::arch_mbm_states
>>     are created during CPU online based on MBM event enabled state. During runtime
>>     an enabled MBM event is assumed to have state.
>>     To me this implies that any possible MBM event should be enabled during early
>>     initialization.
>>     A consequence is that any possible MBM event will have its associated event file
>>     created even if the active mode of the time cannot support it. (I do not think
>>     we want to have event files come and go).
>> b) Switching between modes.
>>     From what I can tell switching mode is always allowed as long as system supports
>>     assignable counters and that may not be correct. Consider a system that supports
>>     ABMC but does not support X86_FEATURE_CQM_MBM_TOTAL and/or X86_FEATURE_CQM_MBM_LOCAL ...
>>     should it be allowed to switch to "default" mode? At this time I believe this is allowed
>>     yet this is an unusable state (as far as MBM goes) and I expect any attempt at reading
>>     an event file will result in invalid MSR access?
>>     Complexity increases if there is a mismatch in supported events, for example if mbm_event
>>     mode supports total and local but default mode only supports one. Should it be allowed
>>     to switch modes? If so, user can then still read from both files, the check whether assignable
>>     counters is enabled will fail and resctrl will attempt to read both via the counter MSRs,
>>     even an unsupported event (continued below).
>> c) Read of event file
>>     A user can read from event file any time even if active mode (default or mbm_event) does
>>     not support it. If mbm_event mode is enabled then resctrl will attempt to use counters,
>>     if default mode is enabled then resctrl will attempt to use MSRs.
>>     This currently entirely depends on whether mbm_event mode is enabled or not.
>>     Perhaps we should add checks here to prevent user from reading an event if the
>>     active mode does not support it? Alternatively prevent user from switching to a mode
>>     that cannot be supported.
>>
>> Look forward to how you view things and thoughts on how user may expect to interact with these
>> features.


Yea.  Taken note of all your points. Sorry for the Iate response.  I was 
investigating on how to fix in a proper way.


> I am concerned about this issue. The original changelog only mentions that events are enabled when
> they should not be but it looks to me that there is a more serious issue if the user then attempts
> to read from such an event. Have you tried the scenario when a user boots with the parameters
> mentioned in changelog (rdt=!mbmtotal,!mbmlocal) and then attempts to read one of these events?
> Reading from the event will attempt to access its architectural state but from what I can tell
> that will not be allocated since the events are not enabled at the time of the allocation.


Yes. I saw the issues. It fails to mount in my case with panic trace.


>
> This needs to be fixed during this cycle. A week has passed since my previous message so I do not


Yes. I understand your concern.


> think that it will be possible to create a full featured solution that keeps X86_FEATURE_ABMC
> and X86_FEATURE_CQM_MBM_TOTAL/X86_FEATURE_CQM_MBM_LOCAL independent.


Agree.


>
> What do you think of something like below that builds on your original change and additionally
> enforces dependency between these features to support the resctrl assumptions? From what I understand
> this is ok for current AMD hardware? A not-as-urgent follow-up can make these features independent
> again?


Yes. I tested it. Works fine.  It defaults to "default" mode if both the 
events(local and total) are disabled in kernel parameter. That is expected.


>
>
> diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
> index c8945610d455..fd42fe7b2fdc 100644
> --- a/arch/x86/kernel/cpu/resctrl/monitor.c
> +++ b/arch/x86/kernel/cpu/resctrl/monitor.c
> @@ -452,7 +452,16 @@ int __init rdt_get_mon_l3_config(struct rdt_resource *r)
>   		r->mon.mbm_cfg_mask = ecx & MAX_EVT_CONFIG_BITS;
>   	}
>   
> -	if (rdt_cpu_has(X86_FEATURE_ABMC)) {
> +	/*
> +	 * resctrl assumes a system that supports assignable counters can
> +	 * switch to "default" mode. Ensure that there is a "default" mode
> +	 * to switch to. This enforces a dependency between the independent
> +	 * X86_FEATURE_ABMC and X86_FEATURE_CQM_MBM_TOTAL/X86_FEATURE_CQM_MBM_LOCAL
> +	 * hardware features.
> +	 */
> +	if (rdt_cpu_has(X86_FEATURE_ABMC) &&
> +	    (rdt_cpu_has(X86_FEATURE_CQM_MBM_TOTAL) ||
> +	     rdt_cpu_has(X86_FEATURE_CQM_MBM_LOCAL))) {
>   		r->mon.mbm_cntr_assignable = true;
>   		cpuid_count(0x80000020, 5, &eax, &ebx, &ecx, &edx);
>   		r->mon.num_mbm_cntrs = (ebx & GENMASK(15, 0)) + 1;
> diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
> index 4076336fbba6..572a9925bd6c 100644
> --- a/fs/resctrl/monitor.c
> +++ b/fs/resctrl/monitor.c
> @@ -1782,15 +1782,13 @@ int resctrl_mon_resource_init(void)
>   		mba_mbps_default_event = QOS_L3_MBM_TOTAL_EVENT_ID;
>   
>   	if (r->mon.mbm_cntr_assignable) {
> -		if (!resctrl_is_mon_event_enabled(QOS_L3_MBM_TOTAL_EVENT_ID))
> -			resctrl_enable_mon_event(QOS_L3_MBM_TOTAL_EVENT_ID);
> -		if (!resctrl_is_mon_event_enabled(QOS_L3_MBM_LOCAL_EVENT_ID))
> -			resctrl_enable_mon_event(QOS_L3_MBM_LOCAL_EVENT_ID);
> -		mon_event_all[QOS_L3_MBM_TOTAL_EVENT_ID].evt_cfg = r->mon.mbm_cfg_mask;
> -		mon_event_all[QOS_L3_MBM_LOCAL_EVENT_ID].evt_cfg = r->mon.mbm_cfg_mask &
> -								   (READS_TO_LOCAL_MEM |
> -								    READS_TO_LOCAL_S_MEM |
> -								    NON_TEMP_WRITE_TO_LOCAL_MEM);
> +		if (resctrl_is_mon_event_enabled(QOS_L3_MBM_TOTAL_EVENT_ID))
> +			mon_event_all[QOS_L3_MBM_TOTAL_EVENT_ID].evt_cfg = r->mon.mbm_cfg_mask;
> +		if (resctrl_is_mon_event_enabled(QOS_L3_MBM_LOCAL_EVENT_ID))
> +			mon_event_all[QOS_L3_MBM_LOCAL_EVENT_ID].evt_cfg = r->mon.mbm_cfg_mask &
> +									   (READS_TO_LOCAL_MEM |
> +									    READS_TO_LOCAL_S_MEM |
> +									    NON_TEMP_WRITE_TO_LOCAL_MEM);
>   		r->mon.mbm_assign_on_mkdir = true;
>   		resctrl_file_fflags_init("num_mbm_cntrs",
>   					 RFTYPE_MON_INFO | RFTYPE_RES_CACHE);
>
>
>
>
>
>
Thanks for the quick patch.

- Babu

>

