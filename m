Return-Path: <kvm+bounces-27825-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D17F598E4C2
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2024 23:19:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 55A071F23350
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2024 21:19:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22D5F21731E;
	Wed,  2 Oct 2024 21:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="QGRINdXT"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2077.outbound.protection.outlook.com [40.107.236.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 925BB19412A;
	Wed,  2 Oct 2024 21:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727903962; cv=fail; b=JDskOzMzM4UEZkYoMtrZI7EfCg2MDJbDI8BFZgxH3d0pPfT45gKRxmMY1ArWCBHxLl9z8A35j1xEWR613sWDF+yOSyKGVRyEkX0U8fYlSJDpP9w0U+T9c9l2JlUUPpyj60HbeZmuFtv4r5FKvKUMwPHo+pGNEWT1sVvRGFdKKWQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727903962; c=relaxed/simple;
	bh=/yAaHxbv7RIR3oOK+E0vk8orYgjPoyYUWWYXiDwOmvo=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pb6kTBYsuEFM8qBrMZ3BQ2vDEidwu3JA/sn+hlX8+2XOlh5w1rz9wfo5AM5xymUVg42NxOd0TkZUc61ac01t9tDzCMMQ9I/6gPhL8nxWqabA29Oxe8CM2AgtsebtVWVe37V+Dvkt4rpRnp4ZOlMDuHbr+6zWr+U39X9h4NSsFfI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=QGRINdXT; arc=fail smtp.client-ip=40.107.236.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N9kE6yQdwwGjv2a1eGmDFmnKEYvCY5afRUtypA23Qg07+9IEWcmjikxg0OlxrdzSp1VdPeAiiLF1x8VjdzxuBedudfKODmbuTmqHYWxndeq+9iIPUI/g7RxcqLx3Jl+ScUr5iNbL+vm96tRzx63YvHzBENyscQ9XPyeshuTq2yICBFNxCjZN2SgONdc7UJb4JjfUOLwqPSNlz3ZQgeCm4JUnSzQV89doVU1ZBCf4V1a65/U0r7/9+r7SILWmyb/WWZZvXpjhvLO1hl81T0L7GysyYHex78CB86xHSNQlkyP1d2z4QR1lo/rB0if52hWMsWmqpfRMs1oVS9egyh1EAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c4av4WreKMOtEx2EmjZr9T+D009ROcfgrY7OMcrcLTs=;
 b=IS14vS0JsEbuzLwZ+rRiPTNMn8gjaxpOgsIGMHROw65bLdTOAQ+xhbJZ1iOhH2sJc0OwgLwxfLdAQpDGtqmirIpJA5J71O21Ex/pyOi/kcR0Qr7PaO8F5COfvhoXVgKfVLqhsMTE8/qRwtXzqc9WYGdEWSadOrD5GtALqHCsvp6jBOrsb7WV9kU/vMkOVoMRUybY2oUMDg8mhqy3Gb9Zo6yiO7RrNdWdPZeNGq6nfZchX64Wfw9mj9kQMpTtYw9KO2ZmlHyTrZQU4eSRHIin535IYayTmdoz+NdmbFNw0x5R9GcjxxPU/Eq//PpaSBxd8/JJ/zm/JyhiNt0tKAPNJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c4av4WreKMOtEx2EmjZr9T+D009ROcfgrY7OMcrcLTs=;
 b=QGRINdXTDhokqMusd0Ch2gxgT9hTaOOBO7rdiZVEasIM/cLiQMfo7MCqjsHFrWrrM5JX6Nz53AWPEs9bkr6mYizKAmjJTU5vTcuIiEF0qBwt76Aol4EcSvL9xFkkUSWK1RZ+wB1bCKUzQpwJ92x8aGcqRa1lWQPLS8JwqLl1H04=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by DM4PR12MB5865.namprd12.prod.outlook.com (2603:10b6:8:64::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8005.27; Wed, 2 Oct
 2024 21:19:17 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8026.016; Wed, 2 Oct 2024
 21:19:17 +0000
Message-ID: <5ac11cd9-dfd5-499f-b232-5c9d0ed485eb@amd.com>
Date: Wed, 2 Oct 2024 16:19:15 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v2 2/3] crypto: ccp: Add support for SNP_FEATURE_INFO
 command
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
To: Ashish Kalra <Ashish.Kalra@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, hpa@zytor.com, herbert@gondor.apana.org.au
Cc: x86@kernel.org, john.allen@amd.com, davem@davemloft.net,
 michael.roth@amd.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org
References: <cover.1726602374.git.ashish.kalra@amd.com>
 <0f225b9d547694cc473ec14d90d1a821845534c3.1726602374.git.ashish.kalra@amd.com>
 <3b2e58da-33da-1b40-2599-e7992e1674c7@amd.com>
In-Reply-To: <3b2e58da-33da-1b40-2599-e7992e1674c7@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR2101CA0021.namprd21.prod.outlook.com
 (2603:10b6:805:106::31) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|DM4PR12MB5865:EE_
X-MS-Office365-Filtering-Correlation-Id: b93fcc19-abcb-4bb6-2c9a-08dce327df87
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TVdqUzU0aVZjRDFvd2pMZ3JjMytPSVlVa215cE5UL2UzRzJrWE5Fdmswa3hY?=
 =?utf-8?B?TC9wNFBzemR5UFE5WmZYRHkxVTFEdDFIdGgxa2R1N09rVXc1aG0wZXhVVDk3?=
 =?utf-8?B?NWd5Ni9Hc2ZiL1E0NGhJUENZK2xCLzNKczc0cTQrU2tyZmdYRjJDT3FDdDEw?=
 =?utf-8?B?djhDUEN4ZktLQjdzWkVyWUhySVVTSmJwNE1KNHZVQjRDN3JRR25SUjlCaHNj?=
 =?utf-8?B?ak1ZZFd0WHdQR01pK2dVSE9wMG1WNWxrNjVtc2tXa0NsUFZrdVNWZlh2Ky9z?=
 =?utf-8?B?U1V1aGVmNzlzZ3hDWExmclBxQ1BVb3dwSklyY0dkeE01N1VWVkFiZEFPRDBW?=
 =?utf-8?B?UmwyaG1TaEFZbnBiaEJXYzVOaFpKNHlodTVmQVMvQjZRZ2lObVlFQjVWTTIz?=
 =?utf-8?B?TUhnUk9ER0JXM2NzV1JseVBYWnRWVndOdUVmUjRwNDNmODBJaWcwNXlwZkFG?=
 =?utf-8?B?OTBZdGtqcEpwOFh0MUw0VDQ4RjBMdi9XNm52dmRoWW9yWHVsWWQ1Wi9LVDJw?=
 =?utf-8?B?a0lST0VLWk5YdVgwckJ4VTA0WElaS3Fqa2hVaUdDOSszMmdER0FNWU82d1JS?=
 =?utf-8?B?cU1qM2lIeW9CZVFNZDY3RGY3Mk8wS1U0elF1SlB0b0ppa2Z1UGhMV2RyUTJG?=
 =?utf-8?B?SjMrOEdOWVRUZFhNREpKRHN5SEF1T05PZ2UwNjdBbmFsTjhXVXo1VENCTURt?=
 =?utf-8?B?Z2FDbFBvYnh0MGI4Y3BRb3dRZ0JBaldCUDhBTDJETHZzQXBtdTF3NmxhZDRM?=
 =?utf-8?B?OXpRZ1JKeVhabEJmTllGby9CUTAzWnFiY1dHU2I3ODd5WFNUNTVFK0lTR0Jy?=
 =?utf-8?B?RmV3WktLUVNYd3NWUmRnd3VOYlN3SGpzQ3dRLzZkK1pJZ2xUbW41VVRBa1JW?=
 =?utf-8?B?M0tFekZVWFZHdHo4M1FHMTg2ZTlRRFRzZDREczRNWEN1RVRaT2Z4SmoyTmdL?=
 =?utf-8?B?ZzNsMDJueUhZMHBjNGRCOFBBT2VaYXdFK3hqdkloSzNqRkhrMnFpRWNCTTla?=
 =?utf-8?B?OEdFZTZnV1pSOVREZDBZWVNNMkpKNjZYb0NHeWx5dXJSekxKckVHdjNpOUF2?=
 =?utf-8?B?Tnh3ZVQzaVZ1QnlObnpsMGpJUzVteUFzS1VRUHlZbUJFN2hKaXFLdFFqVFBP?=
 =?utf-8?B?bzh1QXBnWkhqWFBmcWVndEUvQm96SmlBTjVURlBFM25RbjAvbUFsblRRZnJK?=
 =?utf-8?B?RVlsVy9uN0kwT01tRXRlb0svcjdDc1B2VmZJWVFFb0JFUVpPTTRoSEthSStO?=
 =?utf-8?B?alZaWmNWb1Jpams2S3dNc0MwdVBGOGlIMzA5cHczQTUyVWNPVDVSS3ZkWnhy?=
 =?utf-8?B?dmUvYmxPdjREakVEdnNmL3JYZ3VSNmhtaDBBaTkrWlFhcXMrVlV0cjJYQnNr?=
 =?utf-8?B?K0FBTGFLL0I0S3lXUHhLOXRQTjQvczl1c2kyc0orSmdROHZJbGJkVitjVEpa?=
 =?utf-8?B?czNacEIzTnY4M0xkUEZRTXE3NE9sRGttYm5BMmdsT09qeUVOMnZjK3BvRkkw?=
 =?utf-8?B?eGl5bWJ5T0krMDJLdmdMSDRRMzMvMkhubjIwenNhQWdvb0lDUnczaW9lR05K?=
 =?utf-8?B?NVY2R1p2TSt5eHYxV3Y0SVNMMjJRQ21QQnlac1k3dHRNQkFJSG11MW9HREdQ?=
 =?utf-8?B?cVJyVkVUQnpTeHpHVk00TEoxNUxwSnNETUN6MVFRSmhLMGhmYnRDcHhKQ3Qr?=
 =?utf-8?B?YlYyL29jQU82RU5kVWl0VW9aaGZReUdpU2V5TUtKdGtpSlA1aEM3WmRBPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?alpwTG1GaDRjbkJoRDNFeHB1VERRcHNQWnRCelJHMW1uV05zQWI5V2tHQ3JR?=
 =?utf-8?B?aEFIekoyOFRTcVIvSXR5S09xTHRuUnNFcUVqT2pXbWsvQzFpaXczQzJhdW9U?=
 =?utf-8?B?a0lPTXJwVWpIK2w0Z1NmdHpnSERiSHM2OGZJNlFEck9FVWVuRVlKV25ONDZ6?=
 =?utf-8?B?bDNQYkpQMDZIak1yK3hpMnJmQnJvcXEwdkRGQlROb1pHbmNodWZ0WUIydmdN?=
 =?utf-8?B?VmsyRG1Bc1JhemduMUsyL250OFR6UkRON1JhUDJQdHNLaGVjSFpoYVZSdTZO?=
 =?utf-8?B?dU1qMGlvUWNrSjk3b01rZEpZTUNtSkFEV3NDd0NTZjU0eGFGUEZFMzZNOHVM?=
 =?utf-8?B?OWxJSlFiZ2IwTTRHMWFDVk9acmFuWWNmUXRJNHR4eXYrMUw2SEIzN0IwMWFV?=
 =?utf-8?B?Y2ovOGtONDJqKzhPYmJYMlVwcklybW8yY3Y4UUpaRzFhN0dtc3ZZMThGUXlm?=
 =?utf-8?B?c3ZPcXdMQTRISWdmRUJBR1ZRRVBjaEpLdTB3ZitTSFo2WHdDUEUzQVdzR3VP?=
 =?utf-8?B?V2E4OE94c3JuemlNbUdvUjRFN3NYN0dsb1RsRzV4a2VoZlh4clhJcU8yczZQ?=
 =?utf-8?B?WkpuemxxaUhPR2dGRUUwZEZYVGtCSnMvc1Bia3Z1bzZqMEYzQlMzZGZPaTFC?=
 =?utf-8?B?aStJTU9RdWNHbGNpL2dVRUU0YUoyL3JTNjVSa2VOcmhScVluMnplSVdRQUkz?=
 =?utf-8?B?ZFAyZGNKcVZXSzR2bU9KVjkxYnhEbFdJbW1lN0RaaitxZFVKQ0xvaGdOZkxi?=
 =?utf-8?B?bFQzZG9VQ0NuZysyVHBQRmcxSEh4V1ZKaWtjc1hqSjdFa1JrSmYzMk9hU04y?=
 =?utf-8?B?bkNTVTdTblZVL0Z3dDZUQVFMYVo5TW1zYnQ5N1FKaEt6MHpxYUxNWW9FdGVj?=
 =?utf-8?B?bU9VRDc4TERwTnJBVWhhUER1WExVeWFuSlpBa1RhZU1JWEFNc2NiMHJ4L3RN?=
 =?utf-8?B?Vm45bFJUNXRuMnVmRXRoN01rTktjYkhRYWErUCtrWXMzV1Q2a1VJUDFWUGZs?=
 =?utf-8?B?UVhDNHZuVHNuVVBEdGljRG5XTDJTWFZoRXVtTEkzRC9RQjErdE1yZDZUbnRq?=
 =?utf-8?B?Q0hzelk1RnNMZXJMVGpLOHlBeERXeEJxYkROMXNYMTRmV25rVzdkRnhoWkVM?=
 =?utf-8?B?T1kwUysyVHNOT2hXNVE3WFFmbmorL0duOWFkUzRGVnQycG1XRTcxMG04aG8z?=
 =?utf-8?B?RFZ5eWpmQ0pZRDZ2TUd0TVpNVHpYZGFQMVl3WFpDWVdFS2JnZzAxVGZqbUkz?=
 =?utf-8?B?a0JGY3NiWEw1ekZYdWNLWE0wdC9ZMEtjSmR3UjJCdmxFR0ZqUDlqUGpIcDB0?=
 =?utf-8?B?YTBRR1FnMzZObFU1RGVMQjdjeXJmN3FpM1J1WlFzcm85MGR1UFMyTDFpNktK?=
 =?utf-8?B?N2N3U3hIdElMQ1J4YnRrT28rNGdPUWlHWkxoSDdzM1JrQ21XRWVHM3JVUENq?=
 =?utf-8?B?NlJuMndwOUlMUXFOdlhzaTJ2ZVBESTJGK2FBOGFqeDMyaDYvbGxaWFd3dURJ?=
 =?utf-8?B?akVVR3RsL1B6akR5QW92NmdYRVZKWmlxamtvSnhLbTAwTUtuZElIN1lGUjFC?=
 =?utf-8?B?c01iQUg4bldsMS9qdFk3KzhpYWVQdCs0VHAvSzFUeVk3OHBWeWxGT0c5WXQ5?=
 =?utf-8?B?eCtjaElRZGdmQTNNUnE3MWYxeUp6RUV1WFRPSE14MkxpeGhYUmJNeldXVDdZ?=
 =?utf-8?B?Y0lsZG9KZG5WRXBOMTVHWjJyNGNSZTczbVN0RUN4OFlueTN0NzdOaUovbk1s?=
 =?utf-8?B?cEZ2YVZkMmFxSGhOVEwwcW9KbG9zbUQ3eUsxYlpSaUxBUFYyZVZSSHl5K09F?=
 =?utf-8?B?djFpWHVNZXNxV2NrQnkrUmt6a0k0NmxDeTdQT0h2bXRsQU16dy9SL3hROU1Q?=
 =?utf-8?B?Uzdtc2YxWSt0ZmxsV2RwM0xrMUZXT1FzcDF2aDh1QUM2b2l1ZXR6cUhyNFQy?=
 =?utf-8?B?VDZrc3NEYVN3ZFhOTGJrd3JkRUdheG1kMDFhRDl2NzBObHNlTk9pS3FWRmQx?=
 =?utf-8?B?S1pqRXZCTThUYnVZTDhPeExLdmE0VGY4L2lCM25BMFVad3hhU3hVTjdRUi9I?=
 =?utf-8?B?dGh3dmN3Zis1QmI4SUJxQ2VrekdhQk5IdWx0TGR0aWJQRmJrRUtuQVFDY0k0?=
 =?utf-8?Q?MDXaS9HnOJezvIHxS99FJUx4j?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b93fcc19-abcb-4bb6-2c9a-08dce327df87
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2024 21:19:17.4395
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HDZuU4pyIEmNVOcTa7SjXSKXBTZvoUWgEPEx2X53V2V2loy4RtJb3ZNbWB9f+RlgFdHdWUMMWLFt9mq4PUF7QA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5865

On 10/2/24 16:18, Tom Lendacky wrote:
> On 9/17/24 15:16, Ashish Kalra wrote:
>> From: Ashish Kalra <ashish.kalra@amd.com>
>>
>> The FEATURE_INFO command provides host and guests a programmatic means
>> to learn about the supported features of the currently loaded firmware.
>> FEATURE_INFO command leverages the same mechanism as the CPUID instruction.
>> Instead of using the CPUID instruction to retrieve Fn8000_0024,
>> software can use FEATURE_INFO.
>>
>> Host/Hypervisor would use the FEATURE_INFO command, while guests would
>> actually issue the CPUID instruction.
>>
>> The hypervisor can provide Fn8000_0024 values to the guest via the CPUID
>> page in SNP_LAUNCH_UPDATE. As with all CPUID output recorded in that page,
>> the hypervisor can filter Fn8000_0024. The firmware will examine
>> Fn8000_0024 and apply its CPUID policy.
>>
>> During CCP module initialization, after firmware update, the SNP
>> platform status and feature information from CPUID 0x8000_0024,
>> sub-function 0, are cached in the sev_device structure.
>>
>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>> ---
>>  drivers/crypto/ccp/sev-dev.c | 47 ++++++++++++++++++++++++++++++++++++
>>  drivers/crypto/ccp/sev-dev.h |  3 +++
>>  include/linux/psp-sev.h      | 29 ++++++++++++++++++++++
>>  3 files changed, 79 insertions(+)
>>
>> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
>> index af018afd9cd7..564daf748293 100644
>> --- a/drivers/crypto/ccp/sev-dev.c
>> +++ b/drivers/crypto/ccp/sev-dev.c
>> @@ -223,6 +223,7 @@ static int sev_cmd_buffer_len(int cmd)
>>  	case SEV_CMD_SNP_GUEST_REQUEST:		return sizeof(struct sev_data_snp_guest_request);
>>  	case SEV_CMD_SNP_CONFIG:		return sizeof(struct sev_user_data_snp_config);
>>  	case SEV_CMD_SNP_COMMIT:		return sizeof(struct sev_data_snp_commit);
>> +	case SEV_CMD_SNP_FEATURE_INFO:		return sizeof(struct snp_feature_info);
>>  	default:				return 0;
>>  	}
>>  
>> @@ -1063,6 +1064,50 @@ static void snp_set_hsave_pa(void *arg)
>>  	wrmsrl(MSR_VM_HSAVE_PA, 0);
>>  }
>>  
>> +static void snp_get_platform_data(void)
>> +{
>> +	struct sev_device *sev = psp_master->sev_data;
>> +	struct sev_data_snp_feature_info snp_feat_info;
>> +	struct snp_feature_info *feat_info;
>> +	struct sev_data_snp_addr buf;
>> +	int error = 0, rc;
>> +
>> +	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
>> +		return;
>> +
>> +	/*
>> +	 * The output buffer must be firmware page if SEV-SNP is
>> +	 * initialized.
> 
> This comment is a little confusing relative to the "if" check that is
> performed. Add some more detail about what this check is for.
> 
> But... would this ever need to be called after SNP_INIT? Would we want
> to call this again after, say, a DOWNLOAD_FIRMWARE command?

Although, as I hit send I realized that we only do DOWNLOAD_FIRMWARE
before SNP is initialized (currently).

Thanks,
Tom

> 
> Thanks,
> Tom
> 
>> +	 */
>> +	if (sev->snp_initialized)
>> +		return;
>> +
>> +	buf.address = __psp_pa(&sev->snp_plat_status);
>> +	rc = __sev_do_cmd_locked(SEV_CMD_SNP_PLATFORM_STATUS, &buf, &error);
>> +
>> +	/*
>> +	 * Do feature discovery of the currently loaded firmware,
>> +	 * and cache feature information from CPUID 0x8000_0024,
>> +	 * sub-function 0.
>> +	 */
>> +	if (!rc && sev->snp_plat_status.feature_info) {
>> +		/*
>> +		 * Use dynamically allocated structure for the SNP_FEATURE_INFO
>> +		 * command to handle any alignment and page boundary check
>> +		 * requirements.
>> +		 */
>> +		feat_info = kzalloc(sizeof(*feat_info), GFP_KERNEL);
>> +		snp_feat_info.length = sizeof(snp_feat_info);
>> +		snp_feat_info.ecx_in = 0;
>> +		snp_feat_info.feature_info_paddr = __psp_pa(feat_info);
>> +
>> +		rc = __sev_do_cmd_locked(SEV_CMD_SNP_FEATURE_INFO, &snp_feat_info, &error);
>> +		if (!rc)
>> +			sev->feat_info = *feat_info;
>> +		kfree(feat_info);
>> +	}
>> +}
>> +
>>  static int snp_filter_reserved_mem_regions(struct resource *rs, void *arg)
>>  {
>>  	struct sev_data_range_list *range_list = arg;
>> @@ -2415,6 +2460,8 @@ void sev_pci_init(void)
>>  			 api_major, api_minor, build,
>>  			 sev->api_major, sev->api_minor, sev->build);
>>  
>> +	snp_get_platform_data();
>> +
>>  	/* Initialize the platform */
>>  	args.probe = true;
>>  	rc = sev_platform_init(&args);
>> diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.h
>> index 3e4e5574e88a..1c1a51e52d2b 100644
>> --- a/drivers/crypto/ccp/sev-dev.h
>> +++ b/drivers/crypto/ccp/sev-dev.h
>> @@ -57,6 +57,9 @@ struct sev_device {
>>  	bool cmd_buf_backup_active;
>>  
>>  	bool snp_initialized;
>> +
>> +	struct sev_user_data_snp_status snp_plat_status;
>> +	struct snp_feature_info feat_info;
>>  };
>>  
>>  int sev_dev_init(struct psp_device *psp);
>> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
>> index 903ddfea8585..6068a89839e1 100644
>> --- a/include/linux/psp-sev.h
>> +++ b/include/linux/psp-sev.h
>> @@ -107,6 +107,7 @@ enum sev_cmd {
>>  	SEV_CMD_SNP_DOWNLOAD_FIRMWARE_EX = 0x0CA,
>>  	SEV_CMD_SNP_COMMIT		= 0x0CB,
>>  	SEV_CMD_SNP_VLEK_LOAD		= 0x0CD,
>> +	SEV_CMD_SNP_FEATURE_INFO	= 0x0CE,
>>  
>>  	SEV_CMD_MAX,
>>  };
>> @@ -812,6 +813,34 @@ struct sev_data_snp_commit {
>>  	u32 len;
>>  } __packed;
>>  
>> +/**
>> + * struct sev_data_snp_feature_info - SEV_SNP_FEATURE_INFO structure
>> + *
>> + * @length: len of the command buffer read by the PSP
>> + * @ecx_in: subfunction index
>> + * @feature_info_paddr : SPA of the FEATURE_INFO structure
>> + */
>> +struct sev_data_snp_feature_info {
>> +	u32 length;
>> +	u32 ecx_in;
>> +	u64 feature_info_paddr;
>> +} __packed;
>> +
>> +/**
>> + * struct feature_info - FEATURE_INFO structure
>> + *
>> + * @eax: output of SNP_FEATURE_INFO command
>> + * @ebx: output of SNP_FEATURE_INFO command
>> + * @ecx: output of SNP_FEATURE_INFO command
>> + * #edx: output of SNP_FEATURE_INFO command
>> + */
>> +struct snp_feature_info {
>> +	u32 eax;
>> +	u32 ebx;
>> +	u32 ecx;
>> +	u32 edx;
>> +} __packed;
>> +
>>  #ifdef CONFIG_CRYPTO_DEV_SP_PSP
>>  
>>  /**

