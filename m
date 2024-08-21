Return-Path: <kvm+bounces-24682-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 273129593A3
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 06:26:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CB19F28453A
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 04:25:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 423DD15C139;
	Wed, 21 Aug 2024 04:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b="nowqEVUu"
X-Original-To: kvm@vger.kernel.org
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11020117.outbound.protection.outlook.com [52.101.51.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B40234206B
	for <kvm@vger.kernel.org>; Wed, 21 Aug 2024 04:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.51.117
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724214352; cv=fail; b=j2duE06yaRYN7kOf69FBJDjYAfwseueyKgcOxYGAPngEYGUF0WfUteMxFmCR339QhJY51Fd1CUOd6AieVdNsr6Xzp+zdCpCf70y/f+PmJ4Bd3XOq+grMfXtm+14tc6X82q9f1cvAMH51HkWBXQFN5EwvMeOGfSj4rnPr0Zmy128=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724214352; c=relaxed/simple;
	bh=nzWPw5on4tH/B3gcQhg/0Cq0aplwL5BYw8s9kGh0CgI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=CsLgPXlKKRMNLwzG7jDI2Qs1WDymlslAa8bkWiA9ipEV45+8+9sUm6BIA4XRqVDmE/ICy1MfXm7RZZTtBY9SMY/k47uKTiM9OKRI1TF5boEE0mCNR8wt8NQYxKdu8loz/VzTHJs6vI1Cr4Um5q3lkk9NJAsFBg0Hk+ex4/4r/j8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com; spf=pass smtp.mailfrom=os.amperecomputing.com; dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b=nowqEVUu; arc=fail smtp.client-ip=52.101.51.117
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=os.amperecomputing.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O4qNohgfZbSPSfqDea9DPHs1oovoxjxGNo94WUNM11hm4HItmqwjf3JWsTq5VOmIFg+M+NgYtQDrpLp/Fpm4wxx4gmv3y3wxNN1eYDWQRR28H9w5gwcoV3MAOXL2BVCLdNqUGDICk0nr5b96sGUSBT9Q0Y27lSOdRPzDrWBtXaYC+WVt38exq04UNaRFQmQ4vJ8GlyhEiPkWsxdCDZwQGg9svlyDC3E3dCDxRSssWP543fUl7sYojHNtIyEaaaFXxwtUgojtWSzE4KwhCuSy1uPYAIQAJk0+ohV2wKhX2nH+m9k7B4GFODjfMRNFBQ902VLbh50mhlJK29NMfBzyDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sh1Y8xzIDOw/Py7CxKHOoPoCIhCSIm0UEJyu2PdZxw4=;
 b=Ov0L7mjcMGTq2FXtjOkdtOMVlCDXSVv5R0nIWBytPtmmzhC3KTBMIpCg9iWQBcfB9VO92aEkFwOYCAtcdygUEU9EGZ1eH9+nALdHmC5sKczJZhm9UOzKhVxDFZSiI6f++CfQAMZz1+IGheH9K61LnslmeNYUjzWD+b8hQATI0a8dJINyzeEr00s4IC8zwFeXtWUNGPOa+DRwr9W0SIEVcGSZQNp59m7fs5YzKAfwB2NASb45zMW+CARQAOZigaXFFzcTA1gBhwze5T0VBzFAuJUqkEzvnWeoOislgwAlNTzb/44V7lZUtTOD7Yf8em48SbaspGIuYTPYWgrA77QdAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sh1Y8xzIDOw/Py7CxKHOoPoCIhCSIm0UEJyu2PdZxw4=;
 b=nowqEVUuD46ZZ3WtYR6fRWcyDjyYVICCX+jR4UDE9Rh6yS80EUH4KQvjuy8l6XLXNnWOxg9FcPryih3A7yNqA2LXRqJ5F8U0cdEBfjqPBTKfpnB9Sx+kssf5Z5ki2LiWKOKxR/uzfy8fKnsCyPnQtYwFow6WNR/0QHhK39JsYgE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from SJ2PR01MB8101.prod.exchangelabs.com (2603:10b6:a03:4f6::10) by
 LV8PR01MB8477.prod.exchangelabs.com (2603:10b6:408:188::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7875.21; Wed, 21 Aug 2024 04:25:46 +0000
Received: from SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::292:6d9c:eb9a:95c9]) by SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::292:6d9c:eb9a:95c9%4]) with mapi id 15.20.7875.018; Wed, 21 Aug 2024
 04:25:46 +0000
Message-ID: <b3e34ca2-911e-471f-8418-5a3144044e56@os.amperecomputing.com>
Date: Wed, 21 Aug 2024 09:55:37 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 00/18] KVM: arm64: nv: Add support for address
 translation instructions
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Anshuman Khandual <anshuman.khandual@arm.com>,
 Przemyslaw Gaj <pgaj@cadence.com>
References: <20240820103756.3545976-1-maz@kernel.org>
Content-Language: en-US
From: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
In-Reply-To: <20240820103756.3545976-1-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA0PR01CA0075.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:ad::16) To SJ2PR01MB8101.prod.exchangelabs.com
 (2603:10b6:a03:4f6::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR01MB8101:EE_|LV8PR01MB8477:EE_
X-MS-Office365-Filtering-Correlation-Id: 292bd846-6ebf-469d-6ec9-08dcc199541a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?KytyVE9oOTVZb0tPVWh3YzBvdE8wRGl4VUhrMFZIWHFrdVhFangzdE5XdVVv?=
 =?utf-8?B?TXpnSTlxVlhWVzEvSWhUWFlRazQwRmZaUHhjdkVzeFkvNVV4TXowY0JYcE1X?=
 =?utf-8?B?alRLWDlYc01SRDZsQi9WNTExQVZrSWlWc0k4T3Y3MFFPWmkzaWZaSWNDWkZo?=
 =?utf-8?B?VDZpaGZ4Ly9OTmpCS2g1UVhhR0dmSUV3TzdkNkRhckN5LzNEbGxYMHVSTzdh?=
 =?utf-8?B?V2dlcWk0YTZ5N3dFR2xSY3FrYSswUXBKbjFkazZtQ3ptTi8wYjQyUEZacEJv?=
 =?utf-8?B?QUdTZjBOVTNlUUIwQ3NDVlU5QWI2UEFVVGpuVEhBdWt2VkJaUU56MXdhU2ox?=
 =?utf-8?B?S0FjNTNJRjIxbktpRXQ4MFdaYUM4a3RQaWY3Ymd0d0dpZnpPWkQ4UE9rVmpx?=
 =?utf-8?B?RC8rcnVEalBvRWIzanZ4dmtRTHI1a0RoSW83UmRaMHpIV3dQcjMveWVGRVNu?=
 =?utf-8?B?aFB6RC9tRlZlb3djeWZFdW1nd3dEaGNsclhZTkl2NkVCNW5kTnFhYzhSaWFL?=
 =?utf-8?B?aTFVVm1QclMydXZOeHNGbndHdHBoVlB3UFdZNXA4ZWhJVEQyL2lFemRWeTBo?=
 =?utf-8?B?a0VHZ2hoT1dSUEVkQldjL0hLWHpTOEVsaGpzN2IzNjNwRUR1RTFZU2FCQWY4?=
 =?utf-8?B?WmZDd3lDQlhIanBLK0VHNGNMd3ViN3JxVWdSak4wckNsVFZabTV4Q2lUODht?=
 =?utf-8?B?ZWtFU0RXZDcrK0hpK2liS3JKZDZXMkF4dVlrNGFIa0Q1akNFbGlUTDZ4cWFK?=
 =?utf-8?B?ZHNsSnBGeWp6T1VvbzMySW1ucHg4QnVlQUQ5dnJFdTRyZ2VZS2xBaDgyUTlY?=
 =?utf-8?B?aVV4MllVU1RPZENPdlE4bk9XZ3p3elpKdm9PZVB1S3RJdVEyT2JWMTFRSVNs?=
 =?utf-8?B?K0tiUjArVUNJcG13TkdlcThHUHVqb1NqMURhYmF6V3VOQkJPOFdhZzNJZnRY?=
 =?utf-8?B?amVTUVY5dnBjY1N2UytXV1lTVHU0VkNmZXJySTgycjArU0hxUTFDZUtjaXla?=
 =?utf-8?B?bG5HS2ZDeGJoakdxRmFrM3gvSW5KTkdSRFE3NjJ4VUZoTExoOGhndXlVaVQ0?=
 =?utf-8?B?a2xNV0tnempueml3OVNrUmpraEhIdC9mSWtpU0wxRUFoY2VNeVdMSDQyR05Z?=
 =?utf-8?B?bTJrNEttQ05oZUoxbnIyVXRKYVVzVTV6MlJsdU1sUTVhZkNnSnh1UFlqTzlJ?=
 =?utf-8?B?d0NzZUJITnYybERPOVJ2bmlxT3JiWmFSRW5Kek1ZQlNNc1diaUIzU09FRk14?=
 =?utf-8?B?bEMxak1kQlcyZ09mSUtua25RaUxsSms4S3JLd2o5NlZpUkJRc0N6d3hPVU5q?=
 =?utf-8?B?SVp6MVFud3lMdEZ6QXd6Q3VEWEdMbHplOW5zaW9mR0NWMHY0dEtsRTAyTWRT?=
 =?utf-8?B?OHNQdkxGakhJRHIxM0VHeTVTRU5HSTZxcnloK1BiczdtWlQwL3l4TzE5R2U5?=
 =?utf-8?B?azErSC9SajFNaUlWb3R3Tm9sMVNFejJkRU1aL01FWjAwZlBDNytnQWpuQjNF?=
 =?utf-8?B?dzNEM3hZQzhQNlVyVnQwS0ZjYmVhZmhLbUQ2dWZQbG04a1VYeHJkd1BXY28v?=
 =?utf-8?B?VVJmUElJSjNWcWh4d1BHeXFMZEh5TFlYZTVSWS9wYUVqeTVaVWJreisrYUh6?=
 =?utf-8?B?ejNRNzZvT1lIT1JxUFZxYTBpZktvc0I4cUxiRDBEN1UrejhvYVpuQnN2aHZS?=
 =?utf-8?B?L2I2SVBoV1BUUnpBTjlaWVlMemI1YzczdUR6c1lLMFIvbi9MdTFjU3laNG5Y?=
 =?utf-8?B?QW5LenI5RTZkdG1jeHJOU1NHMnh5MXBNMU8rdCtNbWcvK1M0OXo0aXdpT2M4?=
 =?utf-8?Q?eMCR9BpEHH1bJq9E+6tUy7FP1PaDPiHF9ia8Q=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR01MB8101.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Uk5kN3FDZ1V0eFh2K1BLZmxDa05MYStKbFdSZkhTMGF1WjJNQ3VWK0lFYS9Z?=
 =?utf-8?B?clpNeDdRM0tjYm13eTNFVXNZc0Vyazd3NXZaNkpyd1JObHYyV213aHE5TllS?=
 =?utf-8?B?RXVMc2VJVUhVYS8zQi9BZC9yRm16UDhmQnlyYWVoVlBFZitPcHRZVldRWGk1?=
 =?utf-8?B?TWd2dXYwN0JqVWdjb3hFa2xBV1dsLzZPNEtKNmpMTzR0a2JuNkJQM2Zzdy9J?=
 =?utf-8?B?emNndG56dktEYVlmd0lkcE50NjNhTS9DOVhucGh4Tk9qaFp1Vm9SaDlvNHZI?=
 =?utf-8?B?N0IyQ0tTcUJZbDI3Q0lzUThnRFp4amFGVFpZQUdib0pQTk9SUzJwUSttWGRW?=
 =?utf-8?B?M1kwZGw3TW04QmNqVFhmdlFkQXBhSnM0QWZKa2NOTjE3a0g5ckl5Z1ZRblRV?=
 =?utf-8?B?OG1VQWlyQmxPSHExY3VlUDM2ZUFwSlpVVFNLMVFwU0Q3VHVBZGxWWEJibVov?=
 =?utf-8?B?MmdmOEljL3JzL2R4c0ZUbCtad202UnJhU20wN2lHTjdJa2VjWGdZeU5DbVVi?=
 =?utf-8?B?RU5VZEZ5eW1uQVFXbVJkQ2JDUVRkYzEvUUM4dmRnSEtpUVFldFlpQVdxNlE5?=
 =?utf-8?B?RXkxREhVS1RLRFFNYkJvc2JQUkh0d1JXYXpmQ1pFZVJxM3ZvN3dvQ3BuTk9Q?=
 =?utf-8?B?djJDY1Jyd2xkekIrV3dvQUp5c01rZm52VFJzbVpJMHVLaDhuam0yNnZWSmE0?=
 =?utf-8?B?WDE2cUpwOU5HaWJaWWRQajl2RFNHZmpwUVViWnN5cnhFMlJoYzF6bklNK09V?=
 =?utf-8?B?RERZdEgwaCtQcnVSOFQ3Vm5UNXptSEFjajhDUFpvMzg3b25hRU5LMldPUFFU?=
 =?utf-8?B?OStxZEN2Zld1d2ZobEd5ckVWbVBidmtyTi9YbGk3ODhRNFBuVlR3OU5VaUVh?=
 =?utf-8?B?dGRERDljZFF6T09DbG9nd0pmSWdaN2EzT2llQVFmTmNuR0JOb0JnWGtoZjJQ?=
 =?utf-8?B?SVovVjgzaGVtN0Qva1FkVytCTnBBVGl4YVcvanorNXBRWEp2L3BuZk9QdStQ?=
 =?utf-8?B?UWkxZXNxMkJaMkJpeFFOcW0vNEo3UUZubS9rL1ZsOUhOVUpteVJDZXQzdEZ1?=
 =?utf-8?B?WTY3YWNvNkdQektybFlVbDlDelZoZTAxZ1NQSWtaUHBiZ1JNdEVtaUdmNGda?=
 =?utf-8?B?c3F0ekU4WjdpQy80N29GWUNjcG1mVHc5QVdGODQ1VEtzNVNSUHdIUXVicnBE?=
 =?utf-8?B?WEVFTHh6VmZtYmFkRi9oZHBKQ2lTWmMrWGlBRDdXYUw1bUsxb0lmMDdiMXJO?=
 =?utf-8?B?SkpBWS82VmtNWlpsVFNPK25WTlVnQ3Eva2pOcjRvVFNBYUhtbVRRck9ycmVU?=
 =?utf-8?B?Q2R1Nmt6aEdkazg0SWhLY2J6VjkwRlZBeWU4dGltOW1QWFUzd3RhU012bGpq?=
 =?utf-8?B?RWI4b29CUElyZUFYbDFMaG4wdlNudE1BUkh6ZVJGOTFvcDhSL3JZZnFZSVpP?=
 =?utf-8?B?ZHV5Sk52ZTg3a1BoT3NaSE5ZRENHN0NTVmtiMVlHRWJxVUhLSkdJMVZNcFVz?=
 =?utf-8?B?N0xHaGFkaThra0xBYTBvSjJjcDFKK2NTS3lQYnM2b2V0UEI4bFg0dC9vbW5u?=
 =?utf-8?B?V3c1TlE0T1ZvM0c3L21na3l2NXRHWTJ2QlpVTy9MTE5XTm5iVkwrVWIxUVBv?=
 =?utf-8?B?aVl5UCtjaldlWXJWRUJST3FzUHVuaTdueFpNN1gvUnF4RlJ3QXVnQlkyYXR1?=
 =?utf-8?B?S2x5RTRwMkRGQWRCaXJRMExPNVBqWU94UmtuZ29DNmIvKzlBMmEvRjdvdTlM?=
 =?utf-8?B?ODVXYWo2Ulpwd1RrOW1aNkp3ZW9WOUt3WktqaXUvTkhCby9JSXd2UzYrSUdE?=
 =?utf-8?B?ZG9nTTkyTlAwd21hWGkybDRCY05SNGVDUGxwdTByMVJiREo0b3VtVGgvQlpv?=
 =?utf-8?B?aEpzbS9xSWF3akgyanA0S2hYREJoMU5UcDFKUERURzgvMmtZS2RrTXdtMU1U?=
 =?utf-8?B?M1BTemFtWE85WE9VVlJPRmxseTZBSU9OdGp2RFpsTURRa0QrYWMyRkNDRW5Y?=
 =?utf-8?B?VHdyTysxN3VvOTNEQmpWRmNtODluaVRVQ0hwYklhM2JmQUVKUk9BSkJsN3dP?=
 =?utf-8?B?cG5IbXhPQnFhZXQ3MTg2YVZYcjgxaUw3dmRHVGMvdWxpUEhTRmVOTEJ6RW1p?=
 =?utf-8?B?bm5OWEpkUFFKZHgvYW8zMTl2NUJlS080dlFUMUswTGxKcHlsbm5pRVpZeTZl?=
 =?utf-8?Q?rzvDz5n7OIJU1s9tRELTqchOZk7vM2n7k4Qt1e40scx4?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 292bd846-6ebf-469d-6ec9-08dcc199541a
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR01MB8101.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2024 04:25:46.6017
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XkNVh2d36BFS4MIwBUfNMPJAd6IN2c+v6w7osovE6vcWgffGRcF+KAXCpMFrNd45YCGXm6vjsFppHJsA5PDrYAyez37J26sPocFyGh1QiCzYuC3+POom3LbNHsYAhx0+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR01MB8477


Hi Marc,

On 20-08-2024 04:07 pm, Marc Zyngier wrote:
> This is the fourth revision of the address translation emulation for
> NV support on arm64 previously posted at [1].
> 
> Thanks again to Alex for his continuous (contiguous? ;-) scrutiny on
> this series.
> 
> * From v3:
> 
>    - Fix out of range conditions for TxSZ when LVA is implemented
> 
>    - Fix implementation of R_VPBBF to deliver an Address Size Fault
> 
>    - Don't grant PX if UW is set
> 
>    - Various cleanups
> 
>    - Collected Alex's RBs, with thanks.
> 
> I've added the usual reviewers on Cc, plus people who explicitly asked
> to be on it, and people who seem to be super keen on NV.
> 
> Patches on top of 6.11-rc1, tested on my usual M2 (so VHE only). FWIW,
> I plan to take this into 6.12.
> 
> [1] https://lore.kernel.org/r/20240813100540.1955263-1-maz@kernel.org
> 
> Joey Gouly (1):
>    KVM: arm64: Make kvm_at() take an OP_AT_*
> 

Have you tested/tried NV with host/L0 booted with GICv4.x enabled?
We do see L2 boot hang and I don't have much debug info at the moment.

> Marc Zyngier (17):
>    arm64: Add missing APTable and TCR_ELx.HPD masks
>    arm64: Add PAR_EL1 field description
>    arm64: Add system register encoding for PSTATE.PAN
>    arm64: Add ESR_ELx_FSC_ADDRSZ_L() helper
>    KVM: arm64: nv: Enforce S2 alignment when contiguous bit is set
>    KVM: arm64: nv: Turn upper_attr for S2 walk into the full descriptor
>    KVM: arm64: nv: Honor absence of FEAT_PAN2
>    KVM: arm64: nv: Add basic emulation of AT S1E{0,1}{R,W}
>    KVM: arm64: nv: Add basic emulation of AT S1E1{R,W}P
>    KVM: arm64: nv: Add basic emulation of AT S1E2{R,W}
>    KVM: arm64: nv: Add emulation of AT S12E{0,1}{R,W}
>    KVM: arm64: nv: Make ps_to_output_size() generally available
>    KVM: arm64: nv: Add SW walker for AT S1 emulation
>    KVM: arm64: nv: Sanitise SCTLR_EL1.EPAN according to VM configuration
>    KVM: arm64: nv: Make AT+PAN instructions aware of FEAT_PAN3
>    KVM: arm64: nv: Plumb handling of AT S1* traps from EL2
>    KVM: arm64: nv: Add support for FEAT_ATS1A
> 
>   arch/arm64/include/asm/esr.h           |    5 +-
>   arch/arm64/include/asm/kvm_arm.h       |    1 +
>   arch/arm64/include/asm/kvm_asm.h       |    6 +-
>   arch/arm64/include/asm/kvm_nested.h    |   40 +-
>   arch/arm64/include/asm/pgtable-hwdef.h |    9 +
>   arch/arm64/include/asm/sysreg.h        |   22 +
>   arch/arm64/kvm/Makefile                |    2 +-
>   arch/arm64/kvm/at.c                    | 1101 ++++++++++++++++++++++++
>   arch/arm64/kvm/emulate-nested.c        |    2 +
>   arch/arm64/kvm/hyp/include/hyp/fault.h |    2 +-
>   arch/arm64/kvm/nested.c                |   41 +-
>   arch/arm64/kvm/sys_regs.c              |   60 ++
>   12 files changed, 1259 insertions(+), 32 deletions(-)
>   create mode 100644 arch/arm64/kvm/at.c
> 

-- 
Thanks,
Ganapat/GK

