Return-Path: <kvm+bounces-32269-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 84EEF9D4F4A
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 15:58:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 16E701F22CD5
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 14:58:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09A811D88DB;
	Thu, 21 Nov 2024 14:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="xFw8cujT"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2041.outbound.protection.outlook.com [40.107.101.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E3351D0143;
	Thu, 21 Nov 2024 14:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732201085; cv=fail; b=NxtQRwwz356j8d1ah8B61+LXXmq9PVtkYEfH8faumgrs6jAT0jNPRmmKENDcsb1Rd1Ht7AY+Ig1L5DeBDG5wH0XjYWIxElKRkYxQpC/kgmVzhmQTFZxBAuH+yg7+cYvklCgJ2ZZPR+DL2p8bBNE24fJaxmW+C5w6zRX49FzDqrs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732201085; c=relaxed/simple;
	bh=J0mtpUSj+03M5yaL5DOkaTCgBxVAtrGPHzj8pG1XlOs=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=kVj/iDw8ozyYp/04YndWpyuTR2rdygyNCXNsNCTG2avZ0H8fAkkvAZlqhtzh23jCpb7RvZKJSPrcromD6kpOiUtTbgd5Iwfeb4nOq+495LYlEAhATQFv2ENc1gIE3YRWqlOaWax/DfAEIHl+ap7hK0Ak/9vXaFbT/lkC43hqHRo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=xFw8cujT; arc=fail smtp.client-ip=40.107.101.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vRQnoOBcXGCCWaiLWUVT4nwj6BLWbX3krCS/+dMLwNVQoSsx6Jwi9pCk6jlWS9xVyuv+VmupG33Kd2mENUKqBXPLFFAOIACLOnTo5yxuzI95MXtxW9LVmY9bPHDM4xaCuYizPBanbVwlqRK4aRJs69NCq/eT6EtLLOneP5Ld0BgLjSgDXH6meAy0ybI1Wf1oipmPQolKucE+zS2bJKzdio9+NjGjQeUV6vcJTEfCAccBZAOB49tt/NgXflwbbJee3QDD2LVWT3ZAI9fRnawcZLNk0pU/ajgqHeNjkf2FduLJWXu/S2ds6d3kuHoRCrKFIiPOhk98n5VJYVBzmeLBIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BQy+racQXlI7SXhjWMVDnTimUowxc6ln0T2PRhxiVuU=;
 b=PLUA57Zxsyw/fPN4ImMy7lT4DYkvn6S6yiyP7VtMz7yrKi6oaKEgPFYnDopbnWL+ZTygdCDsJBpu1hYav+IKWBitVlTQkj/OgVwBYq9LCXhv/OegKVG+TwPGpC9Q7VRKeoRCPWBN3uhI/ZNhcdAu2G4SMFfRcrJN8huUyAsJwUY9onTQeQn+webpLI7m4TW2gtqzKCm/PM03yV+ad4fujnvjHBFHatilSHRF71h755SCulOUZLKEuRCRxz355t4d/iHZrjKXhddWdmsj+L8LfzpE1CekxqZx/UD31IlCG+uZKy5vbwOU0yhbezcBnYWUQdZDf5A8zVqYutecnBHPEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BQy+racQXlI7SXhjWMVDnTimUowxc6ln0T2PRhxiVuU=;
 b=xFw8cujTNkiq7OYrpTif436+gZ0JJ3c9geclTUlNtoSMOVzywULNwfAbrM/j5J9xjF368UIMmMU0L2vWmf5XhzmKBab+wxD9PJ3X04OLmXIpH28IZd3MUmc83XiloB5qPIp/TL3I8/mm0e34iagmguXK/35M20M6W0QRdTAUDn0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by DM3PR12MB9434.namprd12.prod.outlook.com (2603:10b6:0:4b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.14; Thu, 21 Nov
 2024 14:57:58 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef%4]) with mapi id 15.20.8158.023; Thu, 21 Nov 2024
 14:57:58 +0000
Message-ID: <d3de477d-c9bc-40b9-b7db-d155e492981a@amd.com>
Date: Thu, 21 Nov 2024 08:57:54 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] x86/sev: Add SEV-SNP CipherTextHiding support
From: "Kalra, Ashish" <ashish.kalra@amd.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Peter Gonda <pgonda@google.com>, pbonzini@redhat.com, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
 herbert@gondor.apana.org.au, x86@kernel.org, john.allen@amd.com,
 davem@davemloft.net, thomas.lendacky@amd.com, michael.roth@amd.com,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org
References: <cover.1726602374.git.ashish.kalra@amd.com>
 <f2b12d3c76b4e40a85da021ee2b7eaeda1dd69f0.1726602374.git.ashish.kalra@amd.com>
 <CAMkAt6o_963tc4fiS4AFaD6Zb3-LzPZiombaetjFp0GWHzTfBQ@mail.gmail.com>
 <3319bfba-4918-471e-9ddd-c8d08f03e1c4@amd.com> <ZwlMojz-z0gBxJfQ@google.com>
 <1e43dade-3fa7-4668-8fd8-01875ef91c2b@amd.com> <Zz5aZlDbKBr6oTMY@google.com>
 <d3e78d92-29f0-4f56-a1fe-f8131cbc2555@amd.com>
Content-Language: en-US
In-Reply-To: <d3e78d92-29f0-4f56-a1fe-f8131cbc2555@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0173.namprd04.prod.outlook.com
 (2603:10b6:806:125::28) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|DM3PR12MB9434:EE_
X-MS-Office365-Filtering-Correlation-Id: 07ebe7dc-30ac-411b-3fa8-08dd0a3ce307
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dklrcExEZC9MQk5YSUxIQlpGQXJKcnAzaThVS1JCcHhaMGtZbDYxZlkxeStY?=
 =?utf-8?B?bjA5dDBIcXoxRFQzU2I5NTlxV2x3L1lKTjU0dHozL1JESFd0QXAzd3ZMT3RB?=
 =?utf-8?B?bzlHRzI3UnRlTkxpcUk3VXNqOWpyTlV4U1BzSkdVbGFSVDRjZ1Y1QXBJSUkv?=
 =?utf-8?B?MkZGS1ZHcithMENKWmoyM0lTaGxqMnBINXBCWlZXMjZaUEFCZFRZdExTWkxW?=
 =?utf-8?B?SjJlVjkzci83UFZ1L3RTNHl3a3p0VDFLQUEyUVovV0pPcU10WXVLcFpJTURN?=
 =?utf-8?B?UmdCUjZsVHVNNjYvY2VNWjVKY1RzeW5SUG9OYTJjYVJDcm1seEdHbTZhbjRV?=
 =?utf-8?B?YUppN0hxMDAzY1NDeGU4ZTBLN0MvK2F3Rmt4TGQ3Q3N0T2NNVTdtTHh3Tmsz?=
 =?utf-8?B?MkNLVTRyMFNBekxEUkEzUXoxdDdOUTQ4ckJkNE1JcjZMOUdNbmhrVUlzNktX?=
 =?utf-8?B?ODRZYjMrREdaSHlMTXErUEZwT2hScUh5SFpzQk4yV1ZCNDlDa3NMSTdMVStI?=
 =?utf-8?B?RlBmN1phMXVXczdQMXRJcFZRRXJGUnZpdXNHbEMxemRzaEs1VGR6T1o0bmtp?=
 =?utf-8?B?bFJUNUpTNnFMbUtDL1JybElwbnFLZ0s0dkJUMjVjUHJFZWwzQ3FhWU1tU1cz?=
 =?utf-8?B?YkpzOGovWjdHYmhTUzYxMG9qdkRmKzBoTEM4a0hWSXl5RjNib1JWMnQxcUk1?=
 =?utf-8?B?TGl4VUh4UllXV2QwZFVpT0VMZ0dJeXJqTVJpSEVTMHpFTVRVeW83OWMxbjdX?=
 =?utf-8?B?cjlVd29WZWcvR3JVb3kwY2I1YzJjNitXNW0zQXU3ZUkwT3FFMm5zYTZtUkR4?=
 =?utf-8?B?Y3R3c0tjSTRGVU0xR2ViWXhIRUI0cytOekVDaVF3dG10Z2hYNlZMQ3J5T1lH?=
 =?utf-8?B?RDRFMGVydUVDT2VsV0FmeHIya25FaW5rekNKV2UvNlNZenRDblFJMlpHNzBG?=
 =?utf-8?B?cTNINWRxdzM0NTROMkVBc1NXWThrS0VmaVhDNk9SQnE2SG05OGhuTW8vTDVZ?=
 =?utf-8?B?bk5SUHhhclNNd3YxM2dMcitqR25SRGlaYi9MR3VTR3RCUFY2OUZ4OGJVYXQw?=
 =?utf-8?B?UGQ2M2NEUzJBUVNFTUVFNjRkcDVvanhrMk1VWWNBNGRQcVdWa2R2TmtUWXQ2?=
 =?utf-8?B?NDJwYitDQ1VPRGhGSlNqSzVTSGR0SzhDVmZPL0hBclB4Sm1qNmxrYm9zWGdh?=
 =?utf-8?B?aHNTMzExSGlkMEdoRnlhTE5pTUNXdXdVTjlLV2loTWN1RDBLUU5qZldjVU4r?=
 =?utf-8?B?bGpBRUdyUC9PUHJ3Yk1QckdHUkJ6L3A5YUppVnMzSzVkL2RHWW5nUUFQWC9o?=
 =?utf-8?B?cm5RanhqQXZMN2hHblBZaEJ3UklWVzVUYS9DMVJkTWpsZm5LRVkrYlFHMzdT?=
 =?utf-8?B?NG9uTVg2eTFReUpsVEVhdjg0VDVMMmlQYWNvUnRSOWFhT2gwWHUrTkdXOWgv?=
 =?utf-8?B?ell6S2NqY2wwM2pzVlJzMjVUUk5DT0dvRVhQaUI1S2JJRGlMcTlHMjZMOUh3?=
 =?utf-8?B?RUw3YzRibDdocURhelJudTBuOUpVbVJRNHZ6enk0MTNHM2oxK09GRS9nMndp?=
 =?utf-8?B?MERsVTE2K3MwY3JQOW1iRDk2UmFybzRwd0lUTFlkWjgyQTVWK1FpVWlpeitO?=
 =?utf-8?B?UTBqZE9pbHAzVU85V3ZKdEw5Rk5OTy9YcnlURHp2dC8wVTZ5MVBjQ2h1bzFS?=
 =?utf-8?B?UTZxL2JKblczaXNhTmxYVm5EVG42R3RUaVZUQ1EyM2lxazM4a0djV09QbzE3?=
 =?utf-8?Q?zbd45n7tooc2U5AvWcLhBgpWZB+vnh44pyxWN8a?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cldMUzg5ZFNKbzhNejFLYVFNVjE4TU9ON3I1eEZmV1ovRUlqRnlwNVJBY2p3?=
 =?utf-8?B?dW9HZDczSXNSRVcwbWJLYURpL1BOaVJEdndiZncrQUR3cld3eGxGNTFsVVlH?=
 =?utf-8?B?bUtUd3dXay92WFdjVW1zQUZCZ2FwL2wwUzNCOFh0NFRQSkRkOThkSURKbnBL?=
 =?utf-8?B?WU5reHg1VmNYUS9mR1hFSWZTUjBzQjc3V3NFZFNCQW4xTHdlOUNicDZBL212?=
 =?utf-8?B?WEdxVnQzVUtvMXNuS2o4NUFyc2YvK1NXQmkzbnU2VWt1SG0zUXpRaUIwUlZ2?=
 =?utf-8?B?Z0w1RVpPck9VV1BROVVKRTNFSFlyUk80R1J2Vmd1R3h6RXRyNzBKQ01hZHU2?=
 =?utf-8?B?RGYzNmhiUDQ5WUZDd3NzT1BlcEtyM3E4T05EWXFTQXlYQVBpTWFiWlZESmRQ?=
 =?utf-8?B?VzNHai81QllRSkNUMVBNTk01bG5OVTlMclVCbVI0N1JRaWNvT0QraGo4U0tl?=
 =?utf-8?B?ZEVaZzJqTXFNUHNmb0xaNXg0T3pQVEdaUmpGZkt0NmpNeThPWmRQQU1EMG53?=
 =?utf-8?B?TnlTNUxWZEdmaGttNTV1d3lCVVJzOUdacCtqNForRlRHK3M5UjJJK1ZWVHlN?=
 =?utf-8?B?YVY0VVNhRTcwc1Bmb3hLNVZMejRlbU1reFJtM3B3SjJtY2JVMXVqb1lzNFI3?=
 =?utf-8?B?eXcxNm1sd204WWNqUFNJTkZ0eWk4U2Q3d0hZYS8vTHV1cEtmeXpOckFxbVNz?=
 =?utf-8?B?QWEyb2JCOGlmWk9XUlIrZ1JwVWVJdkFVbnkzTG5hVWlFTnAzTG1Jak1laXRK?=
 =?utf-8?B?b1V6anc5TG9lWW1oTkg1aUtYWnVISHE1VXBiY3c3ZnlTOFFqNDRMK0dNbXlR?=
 =?utf-8?B?YUNOdHBjMzdSQWMvUXdJVlp1SWlmSnZnM3FKNkV2OTFCelBib0NyZ2Q3UXhE?=
 =?utf-8?B?dmZPWEZvSjU4OUhFMmllRCtrQnNTdERJekRXZlQ4SzRJSTV1ZU1jY2R5VjhX?=
 =?utf-8?B?bWkwWnhzSzJrbEswekRwNWc3NFhrTElpUlNRZ2ZUSk8yNWNQRUxtY1c5Nmlz?=
 =?utf-8?B?K0wrMHRFQU9vdUptVTFxOTV0S0dUdUVVdTRJMkk3VzVCZFBpVVVFeWI2RTZr?=
 =?utf-8?B?cUtadml5cVNFRmc0Uzh1b0YydUdqTzdTdlQ0NlZmK1RrdDNraGF1elJ5Rys5?=
 =?utf-8?B?eldNOG5NeEljTXhIZ1llYXo1QUtkWlMyYTVQUXJ0ZTB6cUdPZkVueHFSVDcr?=
 =?utf-8?B?Nk8zU0VGcW5CSVRFT0NXS3dBL2hsazFnQnk0R0ZudTYwVzJsRlF1TzFEUlpr?=
 =?utf-8?B?cVRtVkZxZ3ROQnRGdklMS3Bzb0ovRjRyaHk5aFM0KzlVZ2JXQlF2eDhWQXh0?=
 =?utf-8?B?T3lrTnVrSmU2OVRQNzErdXZCOUhVMmEzamdSOU1uMXJ1K053MGtsSzJITDRZ?=
 =?utf-8?B?a0tnNVhtbThNK05rbFpoVVNPd0E0eGxNN1VENHhYNlYyT1R4RlZFNGNGcnFB?=
 =?utf-8?B?cm9pOVVRZEo5YW5MbGhWWnNPNUNDZDdOdEk1TFRJWkJ4Rm1pVXB2R3d3M1h6?=
 =?utf-8?B?QkJzK3doVVJqRGFRVWJCbG92R21paW9hSFZUSVh0MkN1NnVaaThKQ2x3VDhl?=
 =?utf-8?B?L2U1TnNIcmsyaGVtRVBWanRsQk9GMzdWWW9JeDlISmh2bFNtSkxLbVZLUFpW?=
 =?utf-8?B?OEZyUzViL202bDZha3VTSWtBTFpQSzRleTFlc3lzRmg2cWFlbVoxWkRGeEt0?=
 =?utf-8?B?YXRiek1HVGNCclgyd2NrQVhPTDRaMngyaVFJOGh2eTlZazFNeXZ5QmhOdnFi?=
 =?utf-8?B?VEFhNmQxcHQ3bHhmOUlkL2ZjcmYvUVpoN21nTTZ1aUN4TW5NaHZqYlVDZjAy?=
 =?utf-8?B?Vy9TUnNmQS9xQzh4WlhnWSs0aTlBUHBkb2ZNd054Vm5FbmhFcU5GaTlIZ29O?=
 =?utf-8?B?bHh1emVFWE1qREhYTVNUVUxiQ1BvMlhqZDRUdEd2eW4wSzh5bVk3N2o1cXM5?=
 =?utf-8?B?eUJVdGZhaEhVTzh5NHhacXQwUDFyUWJCY1NFUUliMTVEQUdaTENoOGxaL0Y2?=
 =?utf-8?B?WW5RTVErLzEzWHhlM2pHZ1NlUjFCZGRZZStQZk5QbTFtMlhXTlZoZm5Lb29v?=
 =?utf-8?B?MDRQbVBCTThGRDhvMElMcGg2NWh4ZmVtUXlRclluY3pydTh4RDY0eUpvcmZQ?=
 =?utf-8?Q?ygWsGp0GM++19vBGOEmfUP3eq?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07ebe7dc-30ac-411b-3fa8-08dd0a3ce307
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2024 14:57:58.1401
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JJljeQB8CgHndiTC36SDQIGXHFtroh680/1eteFcH8H5Cw+A2Ous0lBxdOF0PD+B3d8lXNqQDGirLAQfuu52uQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR12MB9434



On 11/20/2024 5:43 PM, Kalra, Ashish wrote:
> 
> On 11/20/2024 3:53 PM, Sean Christopherson wrote:
>> On Tue, Nov 19, 2024, Ashish Kalra wrote:
>>> On 10/11/2024 11:04 AM, Sean Christopherson wrote:
>>>> On Wed, Oct 02, 2024, Ashish Kalra wrote:
>>>>> Yes, but there is going to be a separate set of patches to move all ASID
>>>>> handling code to CCP module.
>>>>>
>>>>> This refactoring won't be part of the SNP ciphertext hiding support patches.
>>>>
>>>> It should, because that's not a "refactoring", that's a change of roles and
>>>> responsibilities.  And this series does the same; even worse, this series leaves
>>>> things in a half-baked state, where the CCP and KVM have a weird shared ownership
>>>> of ASID management.
>>>
>>> Sorry for the delayed reply to your response, the SNP DOWNLOAD_FIRMWARE_EX
>>> patches got posted in the meanwhile and that had additional considerations of
>>> moving SNP GCTX pages stuff into the PSP driver from KVM and that again got
>>> into this discussion about splitting ASID management across KVM and PSP
>>> driver and as you pointed out on those patches that there is zero reason that
>>> the PSP driver needs to care about ASIDs. 
>>>
>>> Well, CipherText Hiding (CTH) support is one reason where the PSP driver gets
>>> involved with ASIDs as CTH feature has to be enabled as part of SNP_INIT_EX
>>> and once CTH feature is enabled, the SEV-ES ASID space is split across
>>> SEV-SNP and SEV-ES VMs. 
>>
>> Right, but that's just a case where KVM needs to react to the setup done by the
>> PSP, correct?  E.g. it's similar to SEV-ES being enabled/disabled in firmware,
>> only that "firmware" happens to be a kernel driver.
> 
> Yes that is true.
> 
>>
>>> With reference to SNP GCTX pages, we are looking at some possibilities to
>>> push the requirement to update SNP GCTX pages to SNP firmware and remove that
>>> requirement from the kernel/KVM side.
>>
>> Heh, that'd work too.
>>
>>> Considering that, I will still like to keep ASID management in KVM, there are
>>> issues with locking, for example, sev_deactivate_lock is used to protect SNP
>>> ASID allocations (or actually for protecting ASID reuse/lazy-allocation
>>> requiring WBINVD/DF_FLUSH) and guarding this DF_FLUSH from VM destruction
>>> (DEACTIVATE). Moving ASID management stuff into PSP driver will then add
>>> complexity of adding this synchronization between different kernel modules or
>>> handling locking in two different kernel modules, to guard ASID allocation in
>>> PSP driver with VM destruction in KVM module.
>>>
>>> There is also this sev_vmcbs[] array indexed by ASID (part of svm_cpu_data)
>>> which gets referenced during the ASID free code path in KVM. It just makes it
>>> simpler to keep ASID management stuff in KVM. 
>>>
>>> So probably we can add an API interface exported by the PSP driver something
>>> like is_sev_ciphertext_hiding_enabled() or sev_override_max_snp_asid()
>>
>> What about adding a cc_attr_flags entry?
> 
> Yes, that is a possibility i will look into. 
> 
> But, along with an additional cc_attr_flags entry, max_snp_asid (which is a PSP driver module parameter) also needs to be propagated to KVM, 
> that's what i was considering passing as parameter to the above API interface.
> 

Adding a new cc_attr_flags entry indicating CTH support is enabled.

And as discussed with Boris, using the cc_platform_set() to add a new attr like max_asid and adding a getter interface on top to return the
max_snp_asid.

Thanks,
Ashish


