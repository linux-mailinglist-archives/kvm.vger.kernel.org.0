Return-Path: <kvm+bounces-60021-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 49A0ABDAD3F
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 19:43:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 56A581892B53
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 17:43:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 294C43043CE;
	Tue, 14 Oct 2025 17:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="q7+C5kdn"
X-Original-To: kvm@vger.kernel.org
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010058.outbound.protection.outlook.com [52.101.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9BAA287518;
	Tue, 14 Oct 2025 17:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760463794; cv=fail; b=E7pGs1DNUQYpKIcczHdfcqRdORlqbZM2W+SL/56KLJpS+8Iyt8vbvrxolVlYvWSK1uTmaP/iqvYGXQ1BipIHqOj1yDL1Lgz3m5DpsokBgMJ93t+tpPTLZl5/aP5gpgxkjK8suCRi2mTvKdyrF9n0DX0uXkxLiYmPZAd82b4y3YU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760463794; c=relaxed/simple;
	bh=iqmJgP3yJLhnN3JnSDavwP/QgFp7HWpEIVUr8LhKJvA=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=r6OJY+Z8MxeqN6mq0NyjafVSt7RBZyQiDmuFA13tO/I8+FocF3c09NzdIpqF8/QXMg+yQqwwBWeTMMHmJu7uXOc6SL0diJcbMOjF7e65Q4OYs7Zferdu1XCzMFFKSYpSut+lCmHgPEkzHBCUbsYyHFoofzC56NTkXmOgfuoVT04=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=q7+C5kdn; arc=fail smtp.client-ip=52.101.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Aktbsm+oJZijmjFG63I3gL4RB1NXBFY3ZxEh6jI9DxfpmKhYb3S5MupGBRxSm4JRrKP3L6ODo3Rj+SilqIbG0HTACquhIERKCph+Z5WneQxhQxXAcIv03bPTE6TY/W3u6co18tbvL+bKauZs2Fbl0H0a3pzgINYT5B5gNDfEGMUOwUb4kwtGI3egUBzogz3CUG9iNromvUCRdqsTX9DgiiJuUivrcu1A816CNFYzPFYgvgOcmBPOF2/V7Pp1qxgpNaBCElioq23c9ZsLfosLIqb3Te++Eyd7ZGDf/VWOzOQIqTjqAnKyFMUoV3rShULVpziPqp1sjITsnXC2RvkKOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g9eiLSW6o31BDSkmEkyjvdFIG76lIcS6OleoiWMKnN8=;
 b=KlKcTHLmOqFU6f/apfUSkrmRScAA9K/YczmjiJ9WG1IU+Hx4YOeSbsN5zdizzQ3BDYZtawJkNdkBgiyNLb4K1g1+o6ltMXOwC3P7GXOEA6Nh3zQacRtiJXbC9ultPLmpR2wbTQNmcJuLr7Ed11Ob2wokJgYyY2Z6tCvWOlhcpOL0n1xdfPVe+HrjSQBiiYhHuL70AlcHfylFcfasz5Cz7T1Ct5XEAJjQwuo2laURVayj0RHWv5SJlXW/3Yec/iyanCvXlRfMg1AB8yLI+eCZP5GqAMP0IILYw34/Cw5/H7PIxzTfSgUGRcfQ7/S50sJpkteP0LywmfqQcaTf9aaE8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g9eiLSW6o31BDSkmEkyjvdFIG76lIcS6OleoiWMKnN8=;
 b=q7+C5kdnX6ixZmRKgHb04cZ6S6u6yUJoxps/vXI2GsMCgFdVEkgZzBtAmxeGFB6U2h6ukU10GSXjwdkotojjEmvMz9w4M6feQG4NufKuRJdutKmHfR297FXw20GfIobRfjVgbbWyqv2XgGKY+Pvc3ZkOWTUgTEN34bEnYpkzLUY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc) by SA0PR12MB7091.namprd12.prod.outlook.com
 (2603:10b6:806:2d5::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.13; Tue, 14 Oct
 2025 17:43:05 +0000
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::8d61:56ca:a8ea:b2eb]) by IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::8d61:56ca:a8ea:b2eb%8]) with mapi id 15.20.9203.009; Tue, 14 Oct 2025
 17:43:04 +0000
Message-ID: <7292333a-a4f1-4217-8c72-436812f29be8@amd.com>
Date: Tue, 14 Oct 2025 12:43:02 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fs/resctrl: Fix MBM events being unconditionally enabled
 in mbm_event mode
From: Babu Moger <bmoger@amd.com>
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
 <0e52d4fe-0ff7-415a-babd-acf3c39f9d30@amd.com>
Content-Language: en-US
In-Reply-To: <0e52d4fe-0ff7-415a-babd-acf3c39f9d30@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA9PR10CA0023.namprd10.prod.outlook.com
 (2603:10b6:806:a7::28) To IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PPF9A76BB3A6:EE_|SA0PR12MB7091:EE_
X-MS-Office365-Filtering-Correlation-Id: aeeb11b7-aecf-497d-f134-08de0b4920fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RDZXVUhIZms4TjVCbWpZdVVwOEVTZ1ltZ0VKZGl4cW9RSXg3Yks5cTNESTFj?=
 =?utf-8?B?azRURVNqV3loQ0RYa1p5Sko0eUNxeHdwVVh4K0sxYzhWbzdyYzI2czJSMkxW?=
 =?utf-8?B?TVg2SWJ4YzB5QVV6SFg1bUlPMUl0eHl0RjFFQ29BcWFPc0puc0VpWGthakQ5?=
 =?utf-8?B?MHlMTlQzUm9UTEVQTTVBQWNNM3FVSk52NXd5MXJHSHRrK3VnUU5LSkVCK2Vs?=
 =?utf-8?B?RzUzckV1RHpkTVZKNTc4OFFxWXVzMWs4RkdBbDJQLzUwWk5VejhZcUpWVGZh?=
 =?utf-8?B?WWFYa3BycEZWK3M2MEpyaUdmM1B0UmZJZHA4cVRrOUIraFJnV2VpWEpGMjkw?=
 =?utf-8?B?NnNEa1l5cFRaQUdJZmwySEZFR3N3ZVJodWt1d1dhd2NWSzdWOFE5dGcvaTBD?=
 =?utf-8?B?MUZYZXo4NFo5WkkwWTlxN2dWMzV2TWZHTEl1ZWE5RGhQd3U0OWEyZEdsR3lO?=
 =?utf-8?B?M2UwVkoydDdsUEJERjdWdm5xT0pUN2JJNUF2M3hoNEdaWCt5THFONkdmL3E4?=
 =?utf-8?B?eXlMSlc1eEpsdTQ1VVR6VCtadllPMlJROVEwdEZHWTR3UU15T0xrSnVDaW4v?=
 =?utf-8?B?THpFeFVkM0h6a0FGcTQ2WGxINFVJb25hWVZJSU9XYXVvcXBRYndHZnB1R0RG?=
 =?utf-8?B?Zm0vQXpqajhHUUdNRElzKzB2MlE0VXU3REpPK2UyODBzU2pQTEZLRjZlTVNM?=
 =?utf-8?B?ekx2MXZZaTZZYzh0TWFJbW5tNzVtdmVsSDRXVkg4OTBxQTdHKzNacmNrQ2Zv?=
 =?utf-8?B?ZTlpNHBacEJ0dERGR1lORVZmOHFkWE5qVjFiQTl2YnNEcVJJMEN3R0tOWXdz?=
 =?utf-8?B?dXNpcnJGUVZjdE1jL0tweHlVaFlBNlZPN3NIZGlLYURoQTZBZ3hIU1pzSmp5?=
 =?utf-8?B?MzZ6TVV3ZjE3ZmpSbVhCN1lCU0hFZFRkbExtSW1udjhjbVVNY21HUmNGclo1?=
 =?utf-8?B?MFgrWDh1NFlQcDNjWklZS2RlWFY1Um9ST21OVUMwU3VnMnZHdUxlRGJzVHU2?=
 =?utf-8?B?UFQza0xrR2lBd2twektUS1FYVjAySUZtblVRN0QyUjFTQmlzSmhEeDJxd3Qw?=
 =?utf-8?B?bkFYL0tIK0trSkt1WTB1TXZsY0dXWHRMRHZiU3ZxYTRDZEZ6Z214d0pScUVD?=
 =?utf-8?B?SFRMTStqU053RWx5U1RnNEg2TGZnYld5UHJFWUNYOTRtMzg0bml6aWw5UGlr?=
 =?utf-8?B?ckx2Z0FGSklUYVFLcUhJWjhiWHpiS3cvaDZBLzZjOEdUNEsvZ2FjdUVDOEdh?=
 =?utf-8?B?VmdsYUZ2dUZyT05Xc3pMLzlFR3NHS2xrcGxPcU9aMmtGUWF6bmszZm5HYTda?=
 =?utf-8?B?UnBTclc2cHhacndCbmk5S3J1UjZES1BSYit4dEVvL1FpTVdrSVJ3bHlwQncr?=
 =?utf-8?B?NmVZUXJ6enMrdlVxWklLdERvWXpkL3dKVjlQYUFtMkYycWdocUtHendvTHcy?=
 =?utf-8?B?T2hIcVJFSnRuYitEYjRDSkFqOUVYMW1PcE9nZ1ozY0VJT2lmWjI4MUJkam0r?=
 =?utf-8?B?Zm5ZdW41UzdsMmxHZDFNa1hNbnlmWG9JSVovM0UrRDBWcVhlQlFhM0FBeXFM?=
 =?utf-8?B?WGROY2MwWDgrSXlkUlRIME5lM2M4a25zOVdtMnZEOUdKYXd6ai9LYitacEsr?=
 =?utf-8?B?alVwOXV3eXhXNWVDQXFnMVhudWJESWQ2bGRLS1ZqZytjNEl1aGhKSWpyN2NQ?=
 =?utf-8?B?TTRtS0dYZ0ZDYmJKaHFLUXNzbm0yWmY2cWYvTU15VVBUYUlsazFxUlNISXFo?=
 =?utf-8?B?UEdMRTRhTkZFNm55UnMvN2huQ25CbjFXSEVhNXJJQ21NUXorWHRSYUlYd1Vo?=
 =?utf-8?B?ckJJLythSXJwczdZQnRiNHZ6aVRQWXd0anpHMHpidmlpbkNJV2NVVS84bDdG?=
 =?utf-8?B?RW5PUjEyTnRrd3M2d3M5VEVJMEdUdi8rRjZybnd5WWJKaDdYNlMyajd3K0tB?=
 =?utf-8?Q?RxlofQnbaDfPTyaMD+6mpW6deFE6DXo4?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PPF9A76BB3A6.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SC84SFRlTm5OVVlLR2x4WXZzQWZ1SHJmQktXWk84WFZrVWZZZ1FEanB0d3ZN?=
 =?utf-8?B?OWZEUGZzaXRCYXAvUnB3UVJhWnV0UzdjZnE5TGROZkZLTDBjWWQwY0FIQThv?=
 =?utf-8?B?ZEpSU1htdmxaWkQ4cFdSNE9nalNyaHIwR2c4V3hmWm9GRjM3bk1QaGQrK1BC?=
 =?utf-8?B?amlkSS9wZmF6V20zOVI1UmFRU1hUOTdsTU1Pb0tzZUZwNnBlZkZGYVRLaVBR?=
 =?utf-8?B?RjZUck10N3RJZEY5SWpJWlFXTVEzdFp4cVhhTzVPU2xkcys5Y2pjL1VyMWdQ?=
 =?utf-8?B?VWs5dnF2REhoemNDUUpiY29nOUYwYzdFZy9qR1ZhSXZMTVViWWlvdUhCcWJo?=
 =?utf-8?B?OEJwcDhEaXIwdXd6cHFCWnlock5xOGo0bnNXMWZMRUNKQWNYWG9hWWtoaXox?=
 =?utf-8?B?Mm1jckdycTRabS9yZnRJajhadkFVRUhwS0lsZDJQVjd0MUNWRHJYdHFxa0hM?=
 =?utf-8?B?RFIvZG9GMjNvQ1dEdHJpc1BTdUVETU1EcERXNC9NUTR5NldrcTdteFZJOUUr?=
 =?utf-8?B?VW9OaUtFa2RYSFlOUFhsaWFpRlByVlRyMHdWcks0U3Q3N3JLSWdaRWNCYS9G?=
 =?utf-8?B?T2U2SUN2UlpwZVBLTDNDKzRkQTdTdk4xdS9MYS9lWWxaRWEvY3diYlYra1dY?=
 =?utf-8?B?RmdHK2pkTlNWcmxDWGUrR0tzRldLVXAxazFjZW5OT2N4azJESS9reklGWWU3?=
 =?utf-8?B?aFVFY2haUU1ZaVZWR29OdENMSGhwTE1UMDFrenNyUEhWMmlIKzRHWG1kTy8w?=
 =?utf-8?B?WTNacGhGaFF2NGJ5WStNTnFXTXF2SnFSRHV2aFducW5NTm8zRnBPa1RLenlk?=
 =?utf-8?B?V2JhRE5RcytOaW8vTEJrbkladWpuS0IxU0FHdFlnTWc5amNHd3IvVVhiRVJ4?=
 =?utf-8?B?dTJSMGR3T3hmd0pTTVBjZ3psTHV0ak56WThKdWpZSUoxRW1TNCtneGx0UDU3?=
 =?utf-8?B?Z0lKYU1PZXVRcVp4Yng1L0tjY2J3SE5xU2ZHVkZtUzA5NWRXeHdmL3p6NTZC?=
 =?utf-8?B?RjVUSjFvTlM3U0o2S3RTemw5azcvc2hJb01KMzgyQlpqMDZDNHNkQzVHTkN0?=
 =?utf-8?B?VklYbURLRTRNNHpDOXQ4dDFPQUVCMmhmUU5VN3pVQzJGTnRHeTI0dzVjS2gz?=
 =?utf-8?B?aURxMDlsQ1NOd3hlUnNCT3c1U1AxNE9VSlhldTlUbnZMeUZvQ3U0Vko5ZHZB?=
 =?utf-8?B?aGM0UExkNmF4NU5UVVNaOXllTWM5Z1N1Q0FFeUxMS2wxMFlJTnVVSGFRa3ZZ?=
 =?utf-8?B?QjhXaFQzSzB5ODhJQ05KWWpOY0ZyMUlCYVJ5YUUwVkkzK1A4aitnbzlsc1JN?=
 =?utf-8?B?c3oyK3R1UlZ4SnF4cW1iSDZkWnZIaVMwN29VWUVjdDVpOTlhcjcyS2Rya2hm?=
 =?utf-8?B?Znlybi9OMFY0MG1nUkNCaUkzOW5LdVJieXF5UUZFbzBpQnE2V1QxTnVhakFN?=
 =?utf-8?B?a2huTzhVN0pyWUFCZmlZdlA0cVJOLzVtSHVXY0FuQWQya0JITndScFRTQjRn?=
 =?utf-8?B?UzZEZndZNnZPMUFKNmNUT09NUjRUT2FiQkgvN01uWmxFYXB3ZURIVjZIUzkx?=
 =?utf-8?B?TUtHRkJJY2dmQjMrWFVtL1l5dTdmbWlWTnZ3VUhUOHRlWU5aVkg1QkpLcWpK?=
 =?utf-8?B?Y0dISFdYQVV6TnNiUE1IUFJNUndmcFZIdmc5K1Fac2huT2pFSGEyVERwTkhE?=
 =?utf-8?B?aDhZMkJNYzR5UEtWOVJWczN5VVE5cU14V1VyTVpjVE1zNzFyTjBoNk5tRnFS?=
 =?utf-8?B?WFpXV3FKWkY4YXQ3TTFOcnNrbnVxcmxYYmNWZ1BDNFY0dk1oWFc5c0N4RSti?=
 =?utf-8?B?Q3lPbUlPMEhZdEdQTnhxa2dZTXlJeSsyU1ZLQjZjZncrZTVxdStPV3JMSjJz?=
 =?utf-8?B?MGV1VURUNXU0TXdKa3Q3aEZBWGEvT2JVbjdvd0c1K2ZBM2xKTXhpL0dFWXF2?=
 =?utf-8?B?L1NOZ29FMFZhYTdvSmM2VUNtK083OU9LUTFqM0hmbkt2OUZyK2FIOVNXTm5U?=
 =?utf-8?B?RmtOaVpWVHVDTEJ6WlczR3FNZERIdjZ0dk45dDBsYVJJV3ZTRlZiK3dPNUU0?=
 =?utf-8?B?UlFXcUYwRlR2a0ZGK1hMSnJOYXM4NW1ZVG1aZ2F6cEtPK055OTBuVGhmTElF?=
 =?utf-8?Q?8NY8=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aeeb11b7-aecf-497d-f134-08de0b4920fc
X-MS-Exchange-CrossTenant-AuthSource: IA0PPF9A76BB3A6.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2025 17:43:04.8587
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H5J6BvpD9fhs+x39vh/EBudrVRwecSxpXbE1TWUHNEU3VEC1fptn2Oouoo087N1d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB7091

Hi Reinette,

On 10/14/25 12:38, Babu Moger wrote:
> Hi Reinette,
>
> On 10/14/25 11:24, Reinette Chatre wrote:
>> Hi Babu,
>>
>> On 10/7/25 7:38 PM, Reinette Chatre wrote:
>>> On 10/7/25 10:36 AM, Babu Moger wrote:
>>>> On 10/6/25 20:23, Reinette Chatre wrote:
>>>>> On 10/6/25 1:38 PM, Moger, Babu wrote:
>>>>>> On 10/6/25 12:56, Reinette Chatre wrote:
>>>>>>> On 9/30/25 1:26 PM, Babu Moger wrote:
>>>>>>>> resctrl features can be enabled or disabled using boot-time kernel
>>>>>>>> parameters. To turn off the memory bandwidth events (mbmtotal and
>>>>>>>> mbmlocal), users need to pass the following parameter to the 
>>>>>>>> kernel:
>>>>>>>> "rdt=!mbmtotal,!mbmlocal".
>>>>>>> ah, indeed ... although, the intention behind the mbmtotal and 
>>>>>>> mbmlocal kernel
>>>>>>> parameters was to connect them to the actual hardware features 
>>>>>>> identified
>>>>>>> by X86_FEATURE_CQM_MBM_TOTAL and X86_FEATURE_CQM_MBM_LOCAL 
>>>>>>> respectively.
>>>>>>>
>>>>>>>
>>>>>>>> Found that memory bandwidth events (mbmtotal and mbmlocal) 
>>>>>>>> cannot be
>>>>>>>> disabled when mbm_event mode is enabled. 
>>>>>>>> resctrl_mon_resource_init()
>>>>>>>> unconditionally enables these events without checking if the 
>>>>>>>> underlying
>>>>>>>> hardware supports them.
>>>>>>> Technically this is correct since if hardware supports ABMC then 
>>>>>>> the
>>>>>>> hardware is no longer required to support 
>>>>>>> X86_FEATURE_CQM_MBM_TOTAL and
>>>>>>> X86_FEATURE_CQM_MBM_LOCAL in order to provide mbm_total_bytes
>>>>>>> and mbm_local_bytes.
>>>>>>>
>>>>>>> I can see how this may be confusing to user space though ...
>>>>>>>
>>>>>>>> Remove the unconditional enablement of MBM features in
>>>>>>>> resctrl_mon_resource_init() to fix the problem. The hardware 
>>>>>>>> support
>>>>>>>> verification is already done in get_rdt_mon_resources().
>>>>>>> I believe by "hardware support" you mean hardware support for
>>>>>>> X86_FEATURE_CQM_MBM_TOTAL and X86_FEATURE_CQM_MBM_LOCAL. 
>>>>>>> Wouldn't a fix like
>>>>>>> this then require any system that supports ABMC to also support
>>>>>>> X86_FEATURE_CQM_MBM_TOTAL and X86_FEATURE_CQM_MBM_LOCAL to be 
>>>>>>> able to
>>>>>>> support mbm_total_bytes and mbm_local_bytes?
>>>>>> Yes. That is correct. Right now, ABMC and X86_FEATURE_CQM_MBM_TOTAL/
>>>>>> X86_FEATURE_CQM_MBM_LOCAL are kind of tightly coupled. We have 
>>>>>> not clearly
>>>>>> separated the that.
>>>>> Are you speaking from resctrl side since from what I understand 
>>>>> these are
>>>>> independent features from the hardware side?
>>>> It is independent from hardware side. I meant we still use legacy 
>>>> events from "default" mode.
>>> Thank you for confirming. I was wondering if we need to fix it via 
>>> cpuid_deps[]
>>> and resctrl_cpu_detect() to address a hardware dependency. If 
>>> hardware self
>>> does not have the dependency then we need to fix it another way.
>>>
>>>>>>> This problem seems to be similar to the one solved by [1] since
>>>>>>> by supporting ABMC there is no "hardware does not support 
>>>>>>> mbmtotal/mbmlocal"
>>>>>>> but instead there only needs to be a check if the feature has 
>>>>>>> been disabled
>>>>>>> by command line. That is, add a rdt_is_feature_enabled() check 
>>>>>>> to the
>>>>>>> existing "!resctrl_is_mon_event_enabled()" check?
>>>>>> Enable or disable needs to be done at get_rdt_mon_resources(). It 
>>>>>> needs to
>>>>>> be done early in  the initialization before calling 
>>>>>> domain_add_cpu() where
>>>>>> event data structures (mbm_states aarch_mbm_states) are allocated.
>>>>> Good point. My mistake to suggest the event should be enabled by
>>>>> resctrl fs.
>>>>
>>>> How about adding another check in get_rdt_mon_resources()?
>>>>
>>>> if (rdt_cpu_has(X86_FEATURE_CQM_MBM_TOTAL)
>>>>      || rdt_is_feature_enabled(mbmtotal)) {
>>>> resctrl_enable_mon_event(QOS_L3_MBM_TOTAL_EVENT_ID);
>>>>                  ret = true;
>>>>          }
>>> Something like this yes. I think it should be in 
>>> rdt_get_mon_l3_config() though, within
>>> the ABMC feature settings. If not then there may be an issue if the 
>>> user boots with
>>> rdt=!abmc? I cannot see why the 
>>> rdt_cpu_has(X86_FEATURE_CQM_MBM_TOTAL) check is needed,
>>> which flow are you addressing?
>>>
>>> Before we exchange code I would like to step back a bit just to be 
>>> clear that we agree
>>> on the current issues and what user space may expect. After this it 
>>> should be easier to
>>> exchange code. (more below)
>>>
>>>> I need to take Tony's patch for this.
>>>>
>>>>>>> But wait ... I think there may be a bigger problem when 
>>>>>>> considering systems
>>>>>>> that support ABMC but not X86_FEATURE_CQM_MBM_TOTAL and 
>>>>>>> X86_FEATURE_CQM_MBM_LOCAL.
>>>>>>> Shouldn't resctrl prevent such a system from switching to "default"
>>>>>>> mbm_assign_mode? Otherwise resctrl will happily let such a 
>>>>>>> system switch
>>>>>>> to default mode and when user attempts to read an event file 
>>>>>>> resctrl will
>>>>>>> attempt to read it via MSRs that are not supported.
>>>>>>> Looks like ABMC may need something similar to 
>>>>>>> CONFIG_RESCTRL_ASSIGN_FIXED
>>>>>>> to handle this case in show() while preventing user space from 
>>>>>>> switching to
>>>>>>> "default" mode on write()?
>>>>>> This may not be an issue right now. When 
>>>>>> X86_FEATURE_CQM_MBM_TOTAL and
>>>>>> X86_FEATURE_CQM_MBM_LOCAL are not supported then mon_data files 
>>>>>> of these
>>>>>> events are not created.
>>>>> By "right now" I assume you mean the current implementation? I 
>>>>> think your statement
>>>>> assumes that no CPUs come or go after resctrl_mon_resource_init() 
>>>>> enables the MBM events?
>>>>> Current implementation will enable MBM events if ABMC is 
>>>>> supported. When the
>>>>> first CPU of a domain comes online after that then resctrl will 
>>>>> create the mon_data
>>>>> files. These files will remain if a user then switches to default 
>>>>> mode and if
>>>>> the user then attempts to read one of these counters then I expect 
>>>>> problems.
>>>> Yes. It will be a problem in the that case.
>>> Thinking about this more the issue is not about the mon_data files 
>>> being created since
>>> they are only created if resctrl is mounted and 
>>> resctrl_mon_resource_init() is run
>>> before creating the mountpoint. From what I can tell current MBM 
>>> events supported by
>>> ABMC will be enabled at the time resctrl can be mounted so if 
>>> X86_FEATURE_CQM_MBM_TOTAL
>>> and X86_FEATURE_CQM_MBM_LOCAL are not supported but ABMC is then I 
>>> believe the
>>> mon_data files will be created.
>>>
>>> There is a problem with the actual domain creation during resctrl 
>>> initialization
>>> where the MBM state data structures are created and depend on the 
>>> events being
>>> enabled then.
>>> resctrl assumes that if an event is enabled then that event's 
>>> associated
>>> rdt_mon_domain::mbm_states and rdt_hw_mon_domain::arch_mbm_states 
>>> exist and if
>>> those data structures are created (or not created) during CPU online 
>>> and MBM
>>> event comes online later then there will be invalid memory accesses.
>>>
>>> The conclusion is the same though ... the events need to be 
>>> initialized during
>>> resctrl initialization as you note above.
>>>
>>>> I am not clear on using config option you mentioned above.
>>> This is more about what is accomplished by the config option than 
>>> whether it is
>>> a config option that controls the flow. More below but I believe 
>>> there may be
>>> scenarios where only mbm_event is supported and in that case I 
>>> expect, even on AMD,
>>> it may be possible that there is no supported "default" mode and thus:
>>>   # cat /sys/fs/resctrl/info/L3_MON/mbm_assign_mode
>>>    [mbm_event]
>>>
>>>> What about using the check resctrl_is_mon_event_enabled() in
>>>>
>>>> resctrl_mbm_assign_mode_show() and resctrl_mbm_assign_mode_write() ?
>>>>
>>> Trying to think through how to support a system that can switch 
>>> between default
>>> and mbm_event mode I see a couple of things to consider. This is as 
>>> I am thinking
>>> through the flows without able to experiment. I think it may help if 
>>> you could sanity
>>> check this with perhaps a few experiments to considering the flows 
>>> yourself to see where
>>> I am missing things.
>>>
>>> When we are clear on the flows to support and how to interact with 
>>> user space it will
>>> be easier to start exchanging code.
>>>
>>> a) MBM state data structures
>>>     As mentioned above, rdt_mon_domain::mbm_states and 
>>> rdt_hw_mon_domain::arch_mbm_states
>>>     are created during CPU online based on MBM event enabled state. 
>>> During runtime
>>>     an enabled MBM event is assumed to have state.
>>>     To me this implies that any possible MBM event should be enabled 
>>> during early
>>>     initialization.
>>>     A consequence is that any possible MBM event will have its 
>>> associated event file
>>>     created even if the active mode of the time cannot support it. 
>>> (I do not think
>>>     we want to have event files come and go).
>>> b) Switching between modes.
>>>     From what I can tell switching mode is always allowed as long as 
>>> system supports
>>>     assignable counters and that may not be correct. Consider a 
>>> system that supports
>>>     ABMC but does not support X86_FEATURE_CQM_MBM_TOTAL and/or 
>>> X86_FEATURE_CQM_MBM_LOCAL ...
>>>     should it be allowed to switch to "default" mode? At this time I 
>>> believe this is allowed
>>>     yet this is an unusable state (as far as MBM goes) and I expect 
>>> any attempt at reading
>>>     an event file will result in invalid MSR access?
>>>     Complexity increases if there is a mismatch in supported events, 
>>> for example if mbm_event
>>>     mode supports total and local but default mode only supports 
>>> one. Should it be allowed
>>>     to switch modes? If so, user can then still read from both 
>>> files, the check whether assignable
>>>     counters is enabled will fail and resctrl will attempt to read 
>>> both via the counter MSRs,
>>>     even an unsupported event (continued below).
>>> c) Read of event file
>>>     A user can read from event file any time even if active mode 
>>> (default or mbm_event) does
>>>     not support it. If mbm_event mode is enabled then resctrl will 
>>> attempt to use counters,
>>>     if default mode is enabled then resctrl will attempt to use MSRs.
>>>     This currently entirely depends on whether mbm_event mode is 
>>> enabled or not.
>>>     Perhaps we should add checks here to prevent user from reading 
>>> an event if the
>>>     active mode does not support it? Alternatively prevent user from 
>>> switching to a mode
>>>     that cannot be supported.
>>>
>>> Look forward to how you view things and thoughts on how user may 
>>> expect to interact with these
>>> features.
>
>
> Yea.  Taken note of all your points. Sorry for the Iate response. I 
> was investigating on how to fix in a proper way.
>
>
>> I am concerned about this issue. The original changelog only mentions 
>> that events are enabled when
>> they should not be but it looks to me that there is a more serious 
>> issue if the user then attempts
>> to read from such an event. Have you tried the scenario when a user 
>> boots with the parameters
>> mentioned in changelog (rdt=!mbmtotal,!mbmlocal) and then attempts to 
>> read one of these events?
>> Reading from the event will attempt to access its architectural state 
>> but from what I can tell
>> that will not be allocated since the events are not enabled at the 
>> time of the allocation.
>
>
> Yes. I saw the issues. It fails to mount in my case with panic trace.
>
>
>>
>> This needs to be fixed during this cycle. A week has passed since my 
>> previous message so I do not
>
>
> Yes. I understand your concern.
>
>
>> think that it will be possible to create a full featured solution 
>> that keeps X86_FEATURE_ABMC
>> and X86_FEATURE_CQM_MBM_TOTAL/X86_FEATURE_CQM_MBM_LOCAL independent.
>
>
> Agree.
>
>
>>
>> What do you think of something like below that builds on your 
>> original change and additionally
>> enforces dependency between these features to support the resctrl 
>> assumptions? From what I understand
>> this is ok for current AMD hardware? A not-as-urgent follow-up can 
>> make these features independent
>> again?
>
>
> Yes. I tested it. Works fine.  It defaults to "default" mode if both 
> the events(local and total) are disabled in kernel parameter. That is 
> expected.
>
>
>>
>>
>> diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c 
>> b/arch/x86/kernel/cpu/resctrl/monitor.c
>> index c8945610d455..fd42fe7b2fdc 100644
>> --- a/arch/x86/kernel/cpu/resctrl/monitor.c
>> +++ b/arch/x86/kernel/cpu/resctrl/monitor.c
>> @@ -452,7 +452,16 @@ int __init rdt_get_mon_l3_config(struct 
>> rdt_resource *r)
>>           r->mon.mbm_cfg_mask = ecx & MAX_EVT_CONFIG_BITS;
>>       }
>>   -    if (rdt_cpu_has(X86_FEATURE_ABMC)) {
>> +    /*
>> +     * resctrl assumes a system that supports assignable counters can
>> +     * switch to "default" mode. Ensure that there is a "default" mode
>> +     * to switch to. This enforces a dependency between the independent
>> +     * X86_FEATURE_ABMC and 
>> X86_FEATURE_CQM_MBM_TOTAL/X86_FEATURE_CQM_MBM_LOCAL
>> +     * hardware features.
>> +     */
>> +    if (rdt_cpu_has(X86_FEATURE_ABMC) &&
>> +        (rdt_cpu_has(X86_FEATURE_CQM_MBM_TOTAL) ||
>> +         rdt_cpu_has(X86_FEATURE_CQM_MBM_LOCAL))) {
>>           r->mon.mbm_cntr_assignable = true;
>>           cpuid_count(0x80000020, 5, &eax, &ebx, &ecx, &edx);
>>           r->mon.num_mbm_cntrs = (ebx & GENMASK(15, 0)) + 1;
>> diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
>> index 4076336fbba6..572a9925bd6c 100644
>> --- a/fs/resctrl/monitor.c
>> +++ b/fs/resctrl/monitor.c
>> @@ -1782,15 +1782,13 @@ int resctrl_mon_resource_init(void)
>>           mba_mbps_default_event = QOS_L3_MBM_TOTAL_EVENT_ID;
>>         if (r->mon.mbm_cntr_assignable) {
>> -        if (!resctrl_is_mon_event_enabled(QOS_L3_MBM_TOTAL_EVENT_ID))
>> - resctrl_enable_mon_event(QOS_L3_MBM_TOTAL_EVENT_ID);
>> -        if (!resctrl_is_mon_event_enabled(QOS_L3_MBM_LOCAL_EVENT_ID))
>> - resctrl_enable_mon_event(QOS_L3_MBM_LOCAL_EVENT_ID);
>> -        mon_event_all[QOS_L3_MBM_TOTAL_EVENT_ID].evt_cfg = 
>> r->mon.mbm_cfg_mask;
>> -        mon_event_all[QOS_L3_MBM_LOCAL_EVENT_ID].evt_cfg = 
>> r->mon.mbm_cfg_mask &
>> -                                   (READS_TO_LOCAL_MEM |
>> -                                    READS_TO_LOCAL_S_MEM |
>> - NON_TEMP_WRITE_TO_LOCAL_MEM);
>> +        if (resctrl_is_mon_event_enabled(QOS_L3_MBM_TOTAL_EVENT_ID))
>> +            mon_event_all[QOS_L3_MBM_TOTAL_EVENT_ID].evt_cfg = 
>> r->mon.mbm_cfg_mask;
>> +        if (resctrl_is_mon_event_enabled(QOS_L3_MBM_LOCAL_EVENT_ID))
>> +            mon_event_all[QOS_L3_MBM_LOCAL_EVENT_ID].evt_cfg = 
>> r->mon.mbm_cfg_mask &
>> +                                       (READS_TO_LOCAL_MEM |
>> +                                        READS_TO_LOCAL_S_MEM |
>> + NON_TEMP_WRITE_TO_LOCAL_MEM);
>>           r->mon.mbm_assign_on_mkdir = true;
>>           resctrl_file_fflags_init("num_mbm_cntrs",
>>                        RFTYPE_MON_INFO | RFTYPE_RES_CACHE);
>>
>>
>>
>>

I can send the official patch if you are ok to go ahead with the patch.

Let me know if I can add Signoff from you or you can respond after it is 
reviewed.



>>
>>
> Thanks for the quick patch.
>
> - Babu
>
>>
>

