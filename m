Return-Path: <kvm+bounces-52707-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B287B08592
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 08:56:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 01F0E1A61044
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 06:56:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B76EA21ADB9;
	Thu, 17 Jul 2025 06:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="qPmVGwQF"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2041.outbound.protection.outlook.com [40.107.212.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DA76218AC4;
	Thu, 17 Jul 2025 06:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752735327; cv=fail; b=I6011qf6Dpmi02AhNchII4/HoOUJJqGF+knazH762MzKN1Y0K0pVymDPutnH/pqrjeGUvTiowXoApXhZYLd7FCSH6DJ89ybzwCBIMImQZUKfOCTwQCdPansNoBi+kgwE7h94ys8ncC0UtVMDJTazPAftVt9bOBAej08fYdNXBzM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752735327; c=relaxed/simple;
	bh=I4LeD/sejPUWx0aK/bgeBDW0DJ+UoQI+TSIEhLQ+V2Q=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=f7mWOYMqKJrceDvQkWa0OqTF1sV4FQOF5AsJwQaEWj8sR/s95vUGWnLj0qZD3X4GSBjW2tE8IUlh/z8FS0ufB+MNT9KwGifypxbK0B5Xo4uHGTjf4nHyMUvOkHxARiy2bvmjLwmZUoWAvxigu7bYK+jqmMfxxjIfaGyVn1WLBTU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=qPmVGwQF; arc=fail smtp.client-ip=40.107.212.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jbBAo9t3nnEypoOPXyKBgRO7v2lKTwbpuH7Nt4gzRDkxJhz2Wvs1ptOX3BkNofezexb0phHTPtgJS+mGOOFZI7HnacmG87KFpfAOVeUuXj16UN9QBga4SnAtveHvMau7LW0qjXz0Cu9Mu1/aVJQcz8KfUkprIU8sZh4CGio/eKlqpefZ6uy9/KChuYexK8nveyWR2JwkYcCdo7cQWg0ltevKRTCb/Rvtjq4EFIk+DsZZtnr91DYJSL2OBzqp1Vnd/EhGXiZZZZlZDHT4oQugQKdTXN0RbDKzr169jP4uToilk4EeLFKH4Nb+jm0a0uBXy5cVcsLc0719oXAHOA3z5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=465E46VYv+6kr1lXZKXi7wmckSdFALxYg0sGVeme4KY=;
 b=L5PLCloKfWdvbXmsxyqTHHzzyUbN1sqosCAU//iJxtNzn0pge0jwduNlkl6ukIu9OzJ8ab622ZgnXxf9lhX/pPof2Hl6EyokS83VNW6ft4us1eYZDu0x6no4jfmN3k8Lud09X3RGOqJVKWFyw5u9kZJcqW+G4kzNaiat/5noJRf0N4ZO2ewsva/ZdTZfeQRsTG7y2hdeRTOKtkFhc3egSfasMIJoktuGnefPfB55Z48T0SFsukvziD6LqBSYTzqMj8Cnr2Vd7Y8DKSD0AmIDWo6jZzI26rzJpA5HUyONj7ZJF8K77aACADR+75JD9yDolmT+Rtnzg2/zM4oLgeHUeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=465E46VYv+6kr1lXZKXi7wmckSdFALxYg0sGVeme4KY=;
 b=qPmVGwQFD7//hunr8IvV7F05BEjDm9zEIMA3iGjnFjHIZc+vFClbEwrtoqueBBkjW50uX0AP7ney+uhJqW9LMrAyYKdxFGQ/Z4IK0iauR1uMT9IT2JY5ML5EALN/xY+VF+UdLnGIXSBVo5ApcBPBOfWWOmbGNlFuY0JGDqopoXU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by CY5PR12MB6622.namprd12.prod.outlook.com (2603:10b6:930:42::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.39; Thu, 17 Jul
 2025 06:55:22 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%6]) with mapi id 15.20.8901.024; Thu, 17 Jul 2025
 06:55:22 +0000
Message-ID: <145ab956-4dd5-4298-bbad-77759d70383f@amd.com>
Date: Thu, 17 Jul 2025 01:55:18 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/4] iommu/amd: Fix host kdump support for SNP
To: Vasant Hegde <vasant.hegde@amd.com>, joro@8bytes.org,
 suravee.suthikulpanit@amd.com, thomas.lendacky@amd.com,
 Sairaj.ArunKodilkar@amd.com, herbert@gondor.apana.org.au
Cc: seanjc@google.com, pbonzini@redhat.com, will@kernel.org,
 robin.murphy@arm.com, john.allen@amd.com, davem@davemloft.net, bp@alien8.de,
 michael.roth@amd.com, iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, kvm@vger.kernel.org
References: <cover.1752605725.git.ashish.kalra@amd.com>
 <ce33833e743a6018efe19aa2d0e555eba41dcb96.1752605725.git.ashish.kalra@amd.com>
 <529c8436-1aeb-41bc-94bd-8b0f128e6222@amd.com>
 <49ef7e43-6a5d-452a-936b-87a573225d1e@amd.com>
 <e5665a37-d9b0-428b-bb6c-6d05c60bdd51@amd.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <e5665a37-d9b0-428b-bb6c-6d05c60bdd51@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA0PR11CA0067.namprd11.prod.outlook.com
 (2603:10b6:806:d2::12) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|CY5PR12MB6622:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b656663-b481-40aa-4346-08ddc4fee666
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Mmlobml2b1FYRXM0WXczcVNjQnJGbURLS3dlaFVoOFdwS1pVVTZ0aEMrZytH?=
 =?utf-8?B?cmNQUjVKU0JnOVZkV2NTY25HdjVSb3owd0tSZ3RFcExpUWpXNVF6T3hBYVBh?=
 =?utf-8?B?eGorWjRhZVBGamdtK2ZtcWRxbUVLaXVLcHR1RCsxVEplK3ZKNXJ0OWtZVE5S?=
 =?utf-8?B?Tm4vSC9iRzBzSml1OUJsWXdiU3JNc2VqaUVxdUdHR3dETURUTWh6L1N4WE1S?=
 =?utf-8?B?am9TMWt6NVdETU05UHRWNi80T3lYeU40MkVqUnAxNGtXTnM5RUVEUStTK2Mz?=
 =?utf-8?B?emhvUUYxWGNXQkFid3p1dVQ2NFN4OWlITDZtTWl5V2V2ZUw0WnhSbmlFR1c4?=
 =?utf-8?B?TGR3a0E0WVBUbUlEalNGUlk5MU5OVXF6T1E1aE9ocWNJSUw3ZjdoOW84N3FJ?=
 =?utf-8?B?MmFXM2dTdldmZHZKNlNqT0k3L0t0UkJsL1pjZ2paQVMydytSTzdNcSszZkZs?=
 =?utf-8?B?NEpTajNKOFIyY3ozZ3hReFBTeDJ2Z3JEYkR2NC8xYUVINkVUUmM2dHJLRERT?=
 =?utf-8?B?R1VoQVpWUzNrOFFQVTdzVjNpSm5RYVpMLzZBUFdMK2lFMFYvMUlORDY2QmxZ?=
 =?utf-8?B?RUhnVElJZ2xBUyswQVBjelA0WWxhc2J4WlNnN3BiY0wvTm1uYW5GTFJSbEhY?=
 =?utf-8?B?eGoxK2t4RlRYMlJTNG1jNzl2c05xU2FGL2IrVmRtaFRYRlF0MC9IdEtMeVpK?=
 =?utf-8?B?amhHN1k1eVJOTEl6ZWdXUW9RdGFCTHo1ajhoQTNEMUdkYWNlSUhmQitteXNw?=
 =?utf-8?B?b3VuTEJCd1VFZSsvcThYd2xTcEJ2bGxhTWdxTnBXc0lOc0JrV2d3U2ZOUzZD?=
 =?utf-8?B?bXZKckg5U0UzK2JMbWFoVmt3aUxqTHFFcERzOVZxSldKNCtFYnpFc2FxVVAy?=
 =?utf-8?B?RjdoT3AxeFNMLzNVcjVpaFhmYWoweFo0Z0V5ckdWZGMxeFB4Wlpidy9kZ2lP?=
 =?utf-8?B?Rm1xczF5SkhwMER1SjZSdjBwcjVCcEE2cUR5TTNWeWF1T29DNnFnZnhRTTFm?=
 =?utf-8?B?cklZVGFLMWZvb1NJRHIxYUR2a0liMm1TNUNoYmlpUVdGOExTeVQwYkNEdUdj?=
 =?utf-8?B?K1pmUlByR3Zxa1UySjhTSldpVnRHTGJXWi96OWNJaVFkRGJJVG52L3VkVnZx?=
 =?utf-8?B?L1lrMS9CWlh5cXBlVVpWS1ZJanVIcmsycjYyckRaWHhabXhNYXBsTGZycjlZ?=
 =?utf-8?B?OHkrejM1dGxmU1NqWGlZcUZhcnRacXB4NlpKZEMrSlA4WDRnUm5TWjAzM20y?=
 =?utf-8?B?aTdNMmVBU2ExWndQZEFFM0F2Mkx4OHI5Wml4WVp5Y1RuOER2TzdCV2hta0sy?=
 =?utf-8?B?K3BvRVgwMHQ1MjdrbVp2ZDJlMFdqK3VtajFQMUUydVg5c2pCZGRZZXc0MGF2?=
 =?utf-8?B?YnE2V2UvM3FwMmhpbkoyL01IczdZWEpWamxhdmpqZHJwaHBiY2toZ2ppZCt0?=
 =?utf-8?B?dFJJaHEvTks4UWhLdnlVdXkraytiekxBOWNrOURRMmZ6R2UrWVplTjA2bmdx?=
 =?utf-8?B?Q3ZPTDFzT2toNlFtd0R1cThoRlpXbnhxeHV6eGs5RC9oRDBsa253ZG1sRUhT?=
 =?utf-8?B?UldCSTFETU1ERmF3VU9nWXp1N2c4TDRRbTBoNVRGODJqUjZKNEN2RHVrM2lB?=
 =?utf-8?B?cEVONEtuUGJnOVZycFZpNHVTT20vM3M0clJEQWY1YjB6QTYxb2xIMHVrb3JF?=
 =?utf-8?B?eFBFZ0VBaGNmYWF3bHRwVWowVmpxMFBpM2lqQjNzZnJCMEpwWThZYXVrS2lw?=
 =?utf-8?B?OFgzTTVkeVlWaXB3bSs2c0lyMkNXMHpCOGlyUExndzBtRXpCek1zZ2pLblha?=
 =?utf-8?B?dVNVTmRmaVNpKzFHbmZtNXk2UzVhSjJaRVZXL09IZFN0a3JabXo2NVR4aFFL?=
 =?utf-8?B?T3VQMXBQSG5NcHIvU1lkcEg3SnQyYzM3SWZLQlc3Uk5tcFNINHhpSyszckRy?=
 =?utf-8?Q?Yh4uP4hvmm8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Z0NQZ0I4ZEJ5RmZEVnBrWHAzNkpFeVdmWUhaNk9reEhBcjloVFhtb2JyOGdO?=
 =?utf-8?B?RkhWWml6RzgrUDNGeTI4a0tMVTFJdlF3SE0zckVFdGVMUFRaOUxTeXAvRW1s?=
 =?utf-8?B?clVaTmZMaXBRT3BPZ29tbHhVZEdXSlBDVmxqRzFDTlh6Z2NDbWxzdUlacmtC?=
 =?utf-8?B?YmNibWhCVW40T1JtTkY3bmllbnFlZ1MyeDE3ekx0eEhCZHYrdStTTlVaV0RO?=
 =?utf-8?B?ek90SUpjSEZPOTdxbGk2UWV2YWRiN0xabjMwQlI5cVNIbElVVDZUamFjZGhJ?=
 =?utf-8?B?Wnl4RVFFeG5yYk80aVhsZ3RDTDZrTkQ5R0VHdEhmUmxiY2Z1T0o5WGhHY08w?=
 =?utf-8?B?VUhaS01DdXFjbC9TcHM3MllDbGhBY2QreC9OUzZ6WGtjME5FL3VSZHlMa29Q?=
 =?utf-8?B?ZlkzZ3ZZUnNQZ1djeWE3US9TQVRsNVllelZJWFFTTm1MTXJUWXNpTm02czdB?=
 =?utf-8?B?UTIvSmRSajNXb3lZcHZSMzhYUzdLa0laY1pWb3dCM0NTWDVHSW9nZ1VVcDhR?=
 =?utf-8?B?aTVwZEYybUttNE13L3JWTmJmNFpNWXYzNHBZcml5Yi9EM0x4ZWwzUTBYWU42?=
 =?utf-8?B?SE85aEtlTlYrL3ZhVGJxdVovL0IxVmVCV21ScWRrc0dZOHh4cmx2Qjk0a3hJ?=
 =?utf-8?B?R0pFNkdQd3JUbnVCTDNwRWR3dFNKNXdEd2NVU0hlRnoweG4vbnZmM2E2Y01x?=
 =?utf-8?B?WjBvQ2QyUHBIeDFVaFdNZHEzOVZFeTJmWFVDWjlHcjA1VmdOMWdIK3Y3aG1m?=
 =?utf-8?B?eVFyQUtvQlRDdGtxSHkvNzJiK1BhT2lGeE9BZGZFVEpEVTJQdSs1Q2VpTkJ1?=
 =?utf-8?B?R0NPZC9pUmdLK0lqNGVSZCtnTzF4eG11MHVIRFlYR2IrUk8yek5iNklFYllz?=
 =?utf-8?B?UzdxMWw2eGM5UHlsbjZWbnVGQ0h4WXRpMzZqRTBzdWhwdUlIbEc4WjBtNnFZ?=
 =?utf-8?B?RWtpSEs1RjFsVURqMUgwVGtZakxiVytnVFhqejAxZHpDb2FidStPdnJMTHhE?=
 =?utf-8?B?aXJybUxmYnZZQU4rNzZSSmd6SzU1T3VyZ3Jsc3Rlb1RPTzNWT3F3cnhEL2RW?=
 =?utf-8?B?MVpkRkFlYlltLytyVHNMejdDOXZ6encxakptZThEd0JoOGc5S1ZNc2FUc0Y3?=
 =?utf-8?B?RmtsVHlOeEVVVEZ0bDZYMFRWdXZlRWh3eUtoNG5taWV0LzlveG9QYkh0eGdD?=
 =?utf-8?B?UFRqbEFkL01CbTlIajZleXE1ZzFySFNCaE1tNUQxUzFCMVdnakpNQ2RvRC9R?=
 =?utf-8?B?MC9aMXpHazVzUWU2dnJLS3cxd0lCS1RQWWdxVlZKczREUCtTQmJVVzRDR1N2?=
 =?utf-8?B?TkhSUThlakhhOWlGcllDS2Z5a2J3SWR5NDBVYkF0MmY5dlQ3SGg5ay9TYWJX?=
 =?utf-8?B?enRRSldwNG1OTXU2ZC9kY2h3bm1NVFErRzZsb2phNDN2ZXpRa2UxRXBYazFr?=
 =?utf-8?B?elhSOEg4azRmci9KY0JtcVUxUmNMVjJTOUR5WnFQYUxnWVhEU0NOWlJrS2lX?=
 =?utf-8?B?ZXNReHhGclQ0SWZzT0tWd2xEV0VXRU1kby9XbnYySjRlcW0vRFpGM005bFds?=
 =?utf-8?B?UHdLWGIwQkw5UnkyRGxYdGF0cmpSQS9IckJBWlZ2NXpEWEszZ0c1di90S0RU?=
 =?utf-8?B?ekJKZTRxYXZMVWZ6UE84TFY1ajYxV0RmekVGRnR1dVBqMTZTYVNNdll2bzEv?=
 =?utf-8?B?NGVJWkwrT09sbUxwMHdXMlFDR3ZrR3MxSUNuS3ZRZmV6SDVZMkRRTVZlS0NL?=
 =?utf-8?B?dG9rbkZvMlh1cXFOWGFOTWxJM2cyZ0RIQXdLMDRYU2lLeklsM1hmOURmeXJs?=
 =?utf-8?B?OUY4cnlEQWxNMkpEZ3NEeWVjcWtzb3M5SFZwYXg3RFF1UUduVWtodU5LYmlF?=
 =?utf-8?B?Vk9PNUpPc1NTSTNGWmRPMkY3YlR6MzFoT0lwUEJoZVZCeFFiNmo4bThNc3N6?=
 =?utf-8?B?dWU3UVg0RE4zTkF3cGVsVGFFU2hhV3MrMlpPSDVySlk5U1lTaG9IOWd0QXdu?=
 =?utf-8?B?MEVxTSt2c3pEMHI5NmFsZGZZRDRnSkMvLzNRMmJubzl6R21GMDZWUzUrUnNH?=
 =?utf-8?B?NnVmZERTWHVvcFY2dXBpQXBnQlAvYnhVQ3dPMFdSdWJyUzU4K00wYzM3RWlQ?=
 =?utf-8?Q?4jT4YdR/w42D4bVeUXoPYLf16?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b656663-b481-40aa-4346-08ddc4fee666
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2025 06:55:22.4178
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6IAwcs3B31TjauZxWi/mcp55GY2CLodEqM441gsm4c+Gux1B3etw6nAlaEHNvnZLMCHnahwGy8rMTKtGNygatA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6622

Hello Vasant,

On 7/17/2025 1:22 AM, Vasant Hegde wrote:
> 
> 
> On 7/17/2025 3:42 AM, Kalra, Ashish wrote:
>> Hello Vasant,
>>
>> On 7/16/2025 4:46 AM, Vasant Hegde wrote:
>>>
>>>
>>> On 7/16/2025 12:57 AM, Ashish Kalra wrote:
>>>> From: Ashish Kalra <ashish.kalra@amd.com>
>>>>
>>>> When a crash is triggered the kernel attempts to shut down SEV-SNP
>>>> using the SNP_SHUTDOWN_EX command. If active SNP VMs are present,
>>>> SNP_SHUTDOWN_EX fails as firmware checks all encryption-capable ASIDs
>>>> to ensure none are in use and that a DF_FLUSH is not required. If a
>>>> DF_FLUSH is required, the firmware returns DFFLUSH_REQUIRED, causing
>>>> SNP_SHUTDOWN_EX to fail.
>>>>
>>>> This casues the kdump kernel to boot with IOMMU SNP enforcement still
>>>> enabled and IOMMU completion wait buffers (CWBs), command buffers,
>>>> device tables and event buffer registers remain locked and exclusive
>>>> to the previous kernel. Attempts to allocate and use new buffers in
>>>> the kdump kernel fail, as the hardware ignores writes to the locked
>>>> MMIO registers (per AMD IOMMU spec Section 2.12.2.1).
>>>>
>>>> As a result, the kdump kernel cannot initialize the IOMMU or enable IRQ
>>>> remapping which is required for proper operation.
>>>>
>>>> This results in repeated "Completion-Wait loop timed out" errors and a
>>>> second kernel panic: "Kernel panic - not syncing: timer doesn't work
>>>> through Interrupt-remapped IO-APIC"
>>>>
>>>> The following MMIO registers are locked and ignore writes after failed
>>>> SNP shutdown:
>>>> Device Table Base Address Register
>>>> Command Buffer Base Address Register
>>>> Event Buffer Base Address Register
>>>> Completion Store Base Register/Exclusion Base Register
>>>> Completion Store Limit Register/Exclusion Range Limit Register
>>>>
>>>
>>> May be you can rephrase the description as first patch covered some of these
>>> details
>>
>> We do need to include the complete description here as this is the final
>> patch of the series which fixes the kdump boot.
>>
>> Do note, that the description in the first patch only mentions the 
>> IOMMU buffers - command, CWB and event buffers for reuse and this commit
>> log covers all reusing and remapping required - IOMMU buffers, device table,
>> etc.
>>  
>>>> Instead of allocating new buffers, re-use the previous kernel’s pages
>>>> for completion wait buffers, command buffers, event buffers and device
>>>> tables and operate with the already enabled SNP configuration and
>>>> existing data structures.
>>>>
>>>> This approach is now used for kdump boot regardless of whether SNP is
>>>> enabled during kdump.
>>>>
>>>> The fix enables successful crashkernel/kdump operation on SNP hosts
>>>> even when SNP_SHUTDOWN_EX fails.
>>>>
>>>> Fixes: c3b86e61b756 ("x86/cpufeatures: Enable/unmask SEV-SNP CPU feature")
>>>
>>> I am not sure why you have marked only this patch as Fixes? Also it won't fix
>>> the kdump if someone just backports only this patch right?
>>>
>>
>> As mentioned in the cover letter, this is the final patch of the series which 
>> actually fixes the SNP kdump boot, so i kept Fixes: tag as part of this patch.
>>> I am not sure if i can add Fixes: tag to all the four patches in this series ?
> 
> But just adding Fixes to this one patch is adding more confusion and
> complicating backport process.
> 
> Is this really a fix? Did kdump ever worked on SNP enabled system? If yes then
> add Fixes to all patches. If not call it as an enhancement.
> 

Well, kdump only worked on SNP enabled systems if there are no active SNP VMs.

But i think it makes more sense to remove the Fixes: tag from these patch-series
as this SNP kdump support is more or less a feature enhancement for SNP.

Thanks,
Ashish


