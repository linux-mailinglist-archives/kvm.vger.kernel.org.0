Return-Path: <kvm+bounces-35295-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 62B2FA0BB68
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 16:14:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6681616D613
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 15:10:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 467AA240245;
	Mon, 13 Jan 2025 15:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="VQZN12mj"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2041.outbound.protection.outlook.com [40.107.220.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73120240234;
	Mon, 13 Jan 2025 15:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736780611; cv=fail; b=bZ44WPBjunj/e5IEz0OGdFWzQhKeeA0pERWggISWfSXMMmpEGZH++OEComNgfoZZ63NxMQthIL0y9XTxmZuEydpWq0F8qWEyC1NCjCgbchkNZKeIrJ8FXiQ+JwEEs/bUTRxgv+RegpvgYTDe79V4D9lU7yHsHSwJU3reo2fL72o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736780611; c=relaxed/simple;
	bh=ZAKM7dVpOqA9PNG2W8BJhJjD2sfW1lqTY01sV9wvoCg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=XNk5epqhTLoBQWODvLfTJVztudrhNTJSVTHkYW3RjoBtv7p30NGUAb+5yFMarc1Bj1am83M1hCOTT8iZoNIAqzb0qJO/AuVasWQibDJrnleYxISmnl57738Cu3bfo+sIdFFq7WlDUjYBki/eb8NY/7eeZauAfBJCAKunSvtdfbY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=VQZN12mj; arc=fail smtp.client-ip=40.107.220.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O/HjFauLXybBTQ10746oLz5OPRzD3sDpy9JH1nIudvlNIKnkQ4FTd70u/KIJf6mz0ssdj70b93qQc7hZFSNgd1RwPVDO4UrPnwCAcKbgeEVqEfKW4urtkbxheO0Q3cmdFv/M4weloaVm+XNnilG6CH2ErfE4uegwF9XlC4fCea3YkPWT9DYs/LjQTmJI68MFb48flnHayObYLaRtMicKwlSOLwFc/GWaSq6IqKfKLA8dvSbDj4CoH/2qoluW/E2l2Wa02cNp++qXtFaiO83EtdYkw0UdjVfBK9Ai2IeXCg+fO8Q2dfx4N9z1/br5ZaHMF2hmOKnAyxThFfVHmwHTCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vuqdfZW7qY9AdzaZr7u3vZgYgNlp7SFu80ojGQinuqA=;
 b=pTayQw40+NZjvvScLvGQRStdx+wqGPw4lCiD8vlw4JhUsaWvi8h4BAYbi1YWHYwg8xwCnWprwNdYC2e4bx2h54l5uJn7xxyYDNFHI7MNIlSTeM5OPUldXvSABROjZ8EI9OJ712nbqJF3Hu1SlWvlJyAQv+td2yWTw6xioc6ous4pk6RZx6VcBpahMbQEI7ywnJ3vkcSVlOqzLYGe8e4BjwmtunkK+O/3oRnlrT6IZMEy5JL9kBHIdaPmMgkLipmIc0ewX0bTevxWvtwuc/NCvxnnLzLcm6rW1bipXHErqqloBiaxCRRYituv/QZyQKTztqIj/+R+vUV5j3vtI0DKUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vuqdfZW7qY9AdzaZr7u3vZgYgNlp7SFu80ojGQinuqA=;
 b=VQZN12mjEQNKePnl7//i4D0HkFYmC0L1V3+mnhqXqgLob3lyb8/E6AIfVrSRbzaeFb/EQ+2DIy2RuCIy/nisRDBUy+NY182xWqfKsiOtGbcn9ocy8XNGohtzpgwR8sTrPsloyjuivR2FJQDwP+I7nmv+Np+5ttIZx0XmitEzJO8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by SJ1PR12MB6315.namprd12.prod.outlook.com (2603:10b6:a03:456::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.17; Mon, 13 Jan
 2025 15:03:25 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef%3]) with mapi id 15.20.8335.015; Mon, 13 Jan 2025
 15:03:25 +0000
Message-ID: <5e3c0fe3-b220-404f-8ae0-f0790a7098b6@amd.com>
Date: Mon, 13 Jan 2025 09:03:22 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 6/7] KVM: SVM: Add support to initialize SEV/SNP
 functionality in KVM
To: Sean Christopherson <seanjc@google.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>, pbonzini@redhat.com,
 tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 john.allen@amd.com, herbert@gondor.apana.org.au, davem@davemloft.net,
 michael.roth@amd.com, dionnaglaze@google.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-coco@lists.linux.dev
References: <cover.1735931639.git.ashish.kalra@amd.com>
 <14f97f58d6150c6784909261db7f9a05d8d32566.1735931639.git.ashish.kalra@amd.com>
 <6241f868-98ee-592b-9475-7e6cec09d977@amd.com>
 <8ae7718c-2321-4f3a-b5b7-7fb029d150cf@amd.com>
 <8adf7f48-dab0-cbed-d920-e3b74d8411cf@amd.com>
 <ee9d2956-fa55-4c83-b17d-055df7e1150c@amd.com>
 <d6d08c6b-9602-4f3d-92c2-8db6d50a1b92@amd.com> <Z4G9--FpoeOlbEDz@google.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <Z4G9--FpoeOlbEDz@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0022.namprd04.prod.outlook.com
 (2603:10b6:806:f2::27) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|SJ1PR12MB6315:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c311810-8b89-4cf3-1ebd-08dd33e36e36
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?blNaTzdZOTVWWVFFaUhrdHdoU1poRWw5Y2w2UmJ3U2dFMElSSGc4Vi9CMk1Y?=
 =?utf-8?B?UlZZeDZ3THJCLzY4T1N5TFdSdytTN0JjSlVrT1ZncDhWV1NvcVY5azg1L1M2?=
 =?utf-8?B?U3JiTXZ6TmFicVlqSzhCUDJIL3RZYjVqelZoTzk2ZTZZY1NnTmpEWnhFZW9p?=
 =?utf-8?B?SCsrdk9qR2NVVHpYUGhaVE5rVklVQmFYQXNsZm1zVGZGTGl0ZEdVS0lkY3hJ?=
 =?utf-8?B?NGlVbnQyRDVORXBCWVZNMkx2WnVrRHRodE1GVTR0bVdOd25nYUNqNW0zaGZS?=
 =?utf-8?B?RVNSNG80TldnbVU0MkJIbjMxNDF2eG9XK3BndHhjS0NvRmJsTmRiTEZBWC9m?=
 =?utf-8?B?eEJZam1JbkxtcXJTNlJ1akluWUQreEJEYXFhQ3Y0TWpMY0dmd0l4ZEt6dyty?=
 =?utf-8?B?Qkh5VjAxaS8xNE1iSGtHK0hidlJCM1llRVc4azFQeDNYNFc5YnE0cFc5eGpF?=
 =?utf-8?B?c2ZxTnZUSVRucmhObHJlMGNIN3NaVllmNE8wZ2h1K2xsSnhoQjJ0U2MrTSs0?=
 =?utf-8?B?ekhxRW5ldVlaeFVOeTliVlFaS0pZdERyR25VNFdmWDhvWCtNdWU4U1Z1Sy94?=
 =?utf-8?B?Z3FVTTh1cStiWWJzZmhZWTRwZ2V2bjhnc2dzS0o5YUQ5TTIyQlA5cUxucWFm?=
 =?utf-8?B?MUgyOCs5cGZMbVNRZnlIRjRtaU15U1YwTEZUMFB5QjJreFRHU0RIVjI0NGJk?=
 =?utf-8?B?MDdJVTZlZ3g0dEdFMit6anhuUXBYeUJCemcwYTVFeHhDYVptR1l5ZTlMWDk3?=
 =?utf-8?B?RWhhRUlGYmNRSEFzV0l6eTd0Q05BbVB4VXcwenFJa2tsVGYxanY5NDRKc3VJ?=
 =?utf-8?B?OHA0QVRFUUkrb2x6V0lYcitQaTdqUWhWRVZzTDBQaEFvOVIzbytCQmpVMFI5?=
 =?utf-8?B?VUJOdmJhZlVEclltbWhTSEdET25ZYjFxNjkvdDh5NzlSOW5qdUloN1BSTEtQ?=
 =?utf-8?B?bno1bnZkVG00QTltNTNXWnZSOXZzQWZYSmd6RWp5aHdWbkRjMEc5ckM3R3F4?=
 =?utf-8?B?ZVRyWFhkQmkzaGIrYTJjdGlXRUxFdUgrSE5HVWRvbFdXcmtxRkVSNmFLMElU?=
 =?utf-8?B?bEFHQktmRm8rcHRtcGRTM1FDNWpkbW02alNjWFNPRVRmVk91L3VzZTBremk0?=
 =?utf-8?B?NkpUYXl5bktXbGE4L2JiUjZCeFJmZGhxc2NYN01pVFpFM0FNTGZGeG9pSVUy?=
 =?utf-8?B?ZDdNSFBpdnp4aHJ6cE9EUmd2ZE9LZVJCQVVwSm1hekltVzBDdUQ0VHJSOVhZ?=
 =?utf-8?B?REcvbDFWYS9VR3ZYd2JTM3J3eVBhZVB5cUNiYTFyUDYwaUxOY2tqZTdnb2g0?=
 =?utf-8?B?dlNGOU9SNnhyY0orS1JMekVEM1hCNFlBSFE3VEtqTHhxRzc1T0tORlhNUng3?=
 =?utf-8?B?UnpHL0pmUDBnQUdvem9RajhzRS92c01nOE5VVnozcVBjNFppRGdxWmxBTFJl?=
 =?utf-8?B?T3NwUTgzaFhwb2NNS0tLVjlYaXh2TEJ3Q29NUkxKc1FkMXRtZ0hNbjAyL2Y5?=
 =?utf-8?B?SDVjb1FPVnF2V05kbllRRjhZMkNjQmdOL1kyZ0ZENk52ZXkvdjh2TlpsdlpO?=
 =?utf-8?B?Qlo0UnZ0UmwwZDlpRnZxc3VySkxsUmoyWHQ2emhTRWtBZmRFejJGVGp6dzVD?=
 =?utf-8?B?NEFOMmFPRzJpRDBoeWFnN0FpdDlZTld4TW1VK1pKNTcvMjh2U1JTaUkwRktp?=
 =?utf-8?B?SHRLYk81Uzkyb2FhYk92SEFjUjZhNlovQTdoNDFIZlQvaGJ1T0Nqa1czVTMy?=
 =?utf-8?B?YTdKQVprMGJqM2JCZGxlUWlPeDdxSURPQ2RtMTlBK2o1S1Y0RHJwdXpwdDlO?=
 =?utf-8?B?WnlkdWdGdkljZXpycXQ5VVFjbHdXRCtySSt6R2tXWEJwM2JKSEoreTNyU1lJ?=
 =?utf-8?Q?e1JxKD8QvrfnE?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VEZGUzNRMGtvY0JJOEZ2UU1xRFgvTzVDLzFXdzVvOWt6bXVObFlMSjFYc0ht?=
 =?utf-8?B?L1E0LzJmWUpQaGF5QjN2NHJYd2tSRHJheVpuSDB6TjVWTVVyMERxVTNkb3Fv?=
 =?utf-8?B?UlpGSlJpcFRHZXlORUpJVjJOQnlEUjdzUlM0N0tCVzVMZ0xDK2dKU0xZWlc5?=
 =?utf-8?B?eWdWL2Z3QzdiSkdrVXpwTlhoZkdodTVWL3MrZVV5anFrQmplSGVNMDZDcTZE?=
 =?utf-8?B?Njd6b2JZZ3F1REx5Z21vc3FCZC80MGI2M3BZL0pSTEV5VzRScTdpUnR1bXow?=
 =?utf-8?B?L3ZHeWFpSnArR2lrR0RmeGlaZGFVcW5DSmZmOXpqVnhSaldXcVBFdkRwcTda?=
 =?utf-8?B?ZnRSMzFtK1BUZVUvN1JOZmMvU2hpT2Y0eDNvWUd4UC9VbGFqdTlhUkJndXhF?=
 =?utf-8?B?ZDd5aUoycXhxOSs2MTRtVjdidlJFam15dWw2Uks0QkdhNlZNRDl3WWJ3Uk5u?=
 =?utf-8?B?emJGb2d2ZGxCWVRMTXZLZGFSYkQrVk5OR0J6bUhsczh0eVlrb0RFUm5rU0Vy?=
 =?utf-8?B?QzNJQmFYS3RKbE1GM1d6dkF3YTJ6bGtQRlA3UTBFbTRscU0rcXhVS0tYZCtM?=
 =?utf-8?B?RlZNV2kxaXhhUHBFcHppbEZtbGJHYktlWXRFNDFadGVEYjdIbVRDVGFVS3lk?=
 =?utf-8?B?a1lvSUdDTEVkNVpJcGwvTUNIY20xUm5TaFpMNkxQbjR2TDBHVDJUVDdmeVcz?=
 =?utf-8?B?ZGw3RmlrSmZmb05rc2EyRVdvZUptSE5Kd3JUME9BZXFCQWZhQkJnVUM3T1A1?=
 =?utf-8?B?dEhTRis0MVMvQ1pqYXFEdHB2QTN3Mkgyc29nazMrVkk4NFU5REh4M2NFbmFB?=
 =?utf-8?B?Y3JCQWN1VmpoNCtXbi81T2pERDBQSWtGU08ycGswaElrUm9HZFk0c1F2K05H?=
 =?utf-8?B?S05VR09rZDFacUh5ZDVDczdGUWpJQVk4c0Vzalg5SHlzMm9xRlduY0FBMFVG?=
 =?utf-8?B?eExXS0Q0ZFlwUUxIVDduSTBEaFRkTmxtYU9NV29JYlhrS3pRNDdkeW1tZktF?=
 =?utf-8?B?a28yM2IrZU0zeXRXNjZBUjZmL1QvVHdnZ0Vxd2VJWXdWOUFZRXE0OUpuOHp5?=
 =?utf-8?B?L2puZ2ZJM2d4TjFmUDJkOFI0dHJ6ZHhPRURnT0wyTHZySGZlWVh3aFhyT1Qx?=
 =?utf-8?B?MUFFczlTamIrTnJHMWRCRlMrWWlLdEdNcUhUVFd6QzRWRk9ub0F6Qzl3VW81?=
 =?utf-8?B?c3pMcFN6UitvS1JWZ0phV2ZFY2svdXlrUzB5d0FZK243M3ZBY1luUW9abll6?=
 =?utf-8?B?S3FVU3ZBZjFIdDdaekdHV21PMU1ESTNnWjlDVEY1N0czemVHSnBodmNpbEhF?=
 =?utf-8?B?aWl4RXZkN0Z2N0x2Z0psU29FcENMdzlZbGZ2Y29LRGlSNWVmVHhDa21GdFZi?=
 =?utf-8?B?Z1lOaWpEOTZYUTFHVFhjenE2enEwNHY1bGM3Ym9pb3RReFl5UWR1OWdibU9u?=
 =?utf-8?B?bEZRWi85bWxWMjM4UWpMSnA1NjNmWDVaUExlMEdyNkFyUUZZVHdwc3FjOWJv?=
 =?utf-8?B?QmRTYkZyR0dlaTJHK3pPelVhOC8ra1lNaC9QSmlBVzgyWkNXVW5aRUtiekE1?=
 =?utf-8?B?WjQ3alEwdXYwTHlGaFNoNXQ0cGRGRCtyVzhaVmtVa3hpbG5QcG1qMFBGS3k2?=
 =?utf-8?B?NzFQUmdlMWJHUFI2VTNnU2ErN3dQcHN6YWVFYnhxeEtsOWFmTDhZMVByWlRL?=
 =?utf-8?B?VEgzQjRQbkg1OW80a3lyK1JraENLSElMUGhEUzA1K0FPaHdoWUZxVFl6d2dn?=
 =?utf-8?B?TndNUFNaQmNGbnVnOFB0TWpOMlplT2NESTlDRDBGcHl5TWJQZGt3UWdmVUlW?=
 =?utf-8?B?anBEamZGY2s3TFpOc1RRMW9nSTljd29mOWJpSGRVVmZHOHROc2M5eENMUXM3?=
 =?utf-8?B?U1RHRTRMSzNMYVVSUU4wSk9RaTAwSHJsTFdUNmM4d3lNM21hZ1pnK0lUNU94?=
 =?utf-8?B?Z1JPNUpab2VpMFJqMkxpOUM4UUFTNXlaTDVpK01OOHZFSUVMTG1jQXRwdWd5?=
 =?utf-8?B?NTUySm4rdUFRakY5aU1GMytuSnhqTElUWExqUVhpd1hkUFAwZTlVRFVFcjRT?=
 =?utf-8?B?WVN5KzYwN3JNODQwMXQ3dnEreGtHUnZxVkszNm5IVFl5eHNVbGdxYWswNXh4?=
 =?utf-8?Q?IZQb8wUfAx4lbcgLrxg3jxGgB?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c311810-8b89-4cf3-1ebd-08dd33e36e36
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2025 15:03:25.7677
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JczrxYYO7s6wGH5aDugg8TSAnAkp+5lUNb0CWP8xxb0lggM3/vkvjKPThPp8IPROGmCI6pkrDnCdDZmyI5C7uA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6315


On 1/10/2025 6:40 PM, Sean Christopherson wrote:
> On Fri, Jan 10, 2025, Ashish Kalra wrote:
>> It looks like i have hit a serious blocker issue with this approach of moving
>> SEV/SNP initialization to KVM module load time. 
>>
>> While testing with kvm_amd and PSP driver built-in, it looks like kvm_amd
>> driver is being loaded/initialized before PSP driver is loaded, and that
>> causes sev_platform_init() call from sev_hardware_setup(kvm_amd) to fail:
>>
>> [   10.717898] kvm_amd: TSC scaling supported
>> [   10.722470] kvm_amd: Nested Virtualization enabled
>> [   10.727816] kvm_amd: Nested Paging enabled
>> [   10.732388] kvm_amd: LBR virtualization supported
>> [   10.737639] kvm_amd: SEV enabled (ASIDs 100 - 509)
>> [   10.742985] kvm_amd: SEV-ES enabled (ASIDs 1 - 99)
>> [   10.748333] kvm_amd: SEV-SNP enabled (ASIDs 1 - 99)
>> [   10.753768] PSP driver not init                        <<<---- sev_platform_init() returns failure as PSP driver is still not initialized
>> [   10.757563] kvm_amd: Virtual VMLOAD VMSAVE supported
>> [   10.763124] kvm_amd: Virtual GIF supported
>> ...
>> ...
>> [   12.514857] ccp 0000:23:00.1: enabling device (0000 -> 0002)
>> [   12.521691] ccp 0000:23:00.1: no command queues available
>> [   12.527991] ccp 0000:23:00.1: sev enabled
>> [   12.532592] ccp 0000:23:00.1: psp enabled
>> [   12.537382] ccp 0000:a2:00.1: enabling device (0000 -> 0002)
>> [   12.544389] ccp 0000:a2:00.1: no command queues available
>> [   12.550627] ccp 0000:a2:00.1: psp enabled
>>
>> depmod -> modules.builtin show kernel/arch/x86/kvm/kvm_amd.ko higher on the list and before kernel/drivers/crypto/ccp/ccp.ko
>>
>> modules.builtin: 
>> kernel/arch/x86/kvm/kvm.ko
>> kernel/arch/x86/kvm/kvm-amd.ko
>> ...
>> ...
>> kernel/drivers/crypto/ccp/ccp.ko
>>
>> I believe that the modules which are compiled first get called first and it
>> looks like that the only way to change the order for builtin modules is by
>> changing which makefiles get compiled first ?
>>
>> Is there a way to change the load order of built-in modules and/or change
>> dependency of built-in modules ?
> 
> The least awful option I know of would be to have the PSP use a higher priority
> initcall type so that it runs before the standard initcalls.  When compiled as
> a module, all initcall types are #defined to module_init.
> 
> E.g. this should work, /cross fingers
> 
> diff --git a/drivers/crypto/ccp/sp-dev.c b/drivers/crypto/ccp/sp-dev.c
> index 7eb3e4668286..02c49fbf6198 100644
> --- a/drivers/crypto/ccp/sp-dev.c
> +++ b/drivers/crypto/ccp/sp-dev.c
> @@ -295,5 +295,6 @@ static void __exit sp_mod_exit(void)
>  #endif
>  }
>  
> -module_init(sp_mod_init);
> +/* The PSP needs to be initialized before dependent modules, e.g. before KVM. */
> +subsys_initcall(sp_mod_init);
>  module_exit(sp_mod_exit);

Thanks for the suggestion, but there are actually two major issues here: 

With the above change, PSP driver initialization fails as following:

...
[    7.274005] pci 0000:20:08.1: bridge window [mem 0xf6200000-0xf64fffff]: not claimed; can't enable device
[    7.277945] pci 0000:20:08.1: Error enabling bridge (-22), continuing
[    7.281947] ccp 0000:23:00.1: BAR 2 [mem 0xf6300000-0xf63fffff]: not claimed; can't enable device
[    7.285945] ccp 0000:23:00.1: pcim_enable_device failed (-22)
[    7.289943] ccp 0000:23:00.1: initialization failed
[    7.293944] ccp 0000:23:00.1: probe with driver ccp failed with error -22
[    7.301981] pci 0000:a0:08.1: bridge window [mem 0xb6200000-0xb63fffff]: not claimed; can't enable device
[    7.313956] pci 0000:a0:08.1: Error enabling bridge (-22), continuing
[    7.321947] ccp 0000:a2:00.1: BAR 2 [mem 0xb6200000-0xb62fffff]: not claimed; can't enable device
[    7.329945] ccp 0000:a2:00.1: pcim_enable_device failed (-22)
[    7.337943] ccp 0000:a2:00.1: initialization failed
[    7.341946] ccp 0000:a2:00.1: probe with driver ccp failed with error -22
...

It looks as PCI bus resource allocation is still not done, hence PSP driver cannot be enabled as early as subsys_initcall,
it can be initialized probably via device_initcall(), but then that will be too late as kvm_amd would have been initialized before that.

Additionally, it looks like that there is an issue with SNP host support being enabled with kvm_amd module being built-in:

SNP host support is enabled in snp_rmptable_init() in arch/x86/virt/svm/sev.c, which is invoked as a device_initcall(). 
Here device_initcall() is used as snp_rmptable_init() expects AMD IOMMU SNP support to be enabled prior to it and the AMD IOMMU
driver is initialized after PCI bus enumeration. 

Now, if kvm_amd module is built-in, it gets initialized before SNP host support is enabled in snp_rmptable_init() :

[   10.131811] kvm_amd: TSC scaling supported
[   10.136384] kvm_amd: Nested Virtualization enabled
[   10.141734] kvm_amd: Nested Paging enabled
[   10.146304] kvm_amd: LBR virtualization supported
[   10.151557] kvm_amd: SEV enabled (ASIDs 100 - 509)
[   10.156905] kvm_amd: SEV-ES enabled (ASIDs 1 - 99)
[   10.162256] kvm_amd: SEV-SNP enabled (ASIDs 1 - 99)
[   10.167701] PSP driver not init
[   10.171508] kvm_amd: Virtual VMLOAD VMSAVE supported
[   10.177052] kvm_amd: Virtual GIF supported
...
...
[   10.201648] kvm_amd: in svm_enable_virtualization_cpu WRMSR VM_HSAVE_PA non-zero

And then svm_x86_ops->enable_virtualization_cpu() (svm_enable_virtualization_cpu) programs MSR_VM_HSAVE_PA as following:
wrmsrl(MSR_VM_HSAVE_PA, sd->save_area_pa);

So VM_HSAVE_PA is non-zero before SNP support is enabled on all CPUs. 

snp_rmptable_init() gets invoked after svm_enable_virtualization_cpu() as following :
...
[   11.256138] kvm_amd: in svm_enable_virtualization_cpu WRMSR VM_HSAVE_PA non-zero
...
[   11.264918] SEV-SNP: in snp_rmptable_init

This triggers a #GP exception in snp_rmptable_init() when snp_enable() is invoked to set SNP_EN in SYSCFG MSR: 

[   11.294289] unchecked MSR access error: WRMSR to 0xc0010010 (tried to write 0x0000000003fc0000) at rIP: 0xffffffffaf5d5c28 (native_write_msr+0x8/0x30)
...
[   11.294404] Call Trace:
[   11.294482]  <IRQ>
[   11.294513]  ? show_stack_regs+0x26/0x30
[   11.294522]  ? ex_handler_msr+0x10f/0x180
[   11.294529]  ? search_extable+0x2b/0x40
[   11.294538]  ? fixup_exception+0x2dd/0x340
[   11.294542]  ? exc_general_protection+0x14f/0x440
[   11.294550]  ? asm_exc_general_protection+0x2b/0x30
[   11.294557]  ? __pfx_snp_enable+0x10/0x10
[   11.294567]  ? native_write_msr+0x8/0x30
[   11.294570]  ? __snp_enable+0x5d/0x70
[   11.294575]  snp_enable+0x19/0x20
[   11.294578]  __flush_smp_call_function_queue+0x9c/0x3a0
[   11.294586]  generic_smp_call_function_single_interrupt+0x17/0x20
[   11.294589]  __sysvec_call_function+0x20/0x90
[   11.294596]  sysvec_call_function+0x80/0xb0
[   11.294601]  </IRQ>
[   11.294603]  <TASK>
[   11.294605]  asm_sysvec_call_function+0x1f/0x30
...
[   11.294631]  arch_cpu_idle+0xd/0x20
[   11.294633]  default_idle_call+0x34/0xd0
[   11.294636]  do_idle+0x1f1/0x230
[   11.294643]  ? complete+0x71/0x80
[   11.294649]  cpu_startup_entry+0x30/0x40
[   11.294652]  start_secondary+0x12d/0x160
[   11.294655]  common_startup_64+0x13e/0x141
[   11.294662]  </TASK>

This #GP exception is getting triggered due to the following errata for AMD family 19h Models 10h-1Fh Processors:

Processor may generate spurious #GP(0) Exception on WRMSR instruction:
Description:
The Processor will generate a spurious #GP(0) Exception on a WRMSR instruction if the following conditions are all met:
- the target of the WRMSR is a SYSCFG register.
- the write changes the value of SYSCFG.SNPEn from 0 to 1.
- One of the threads that share the physical core has a non-zero value in the VM_HSAVE_PA MSR.

The suggested workaround is when enabling SNP, program VM_HSAVE_PA to 0h on both threads that share a physical core before setting SYSCFG.SNPEn

The document being referred to above:
https://www.amd.com/content/dam/amd/en/documents/processor-tech-docs/revision-guides/57095-PUB_1_01.pdf

Therefore, with kvm_amd module being built-in, KVM/SVM initialization happens before Host SNP is enabled and this SVM initialization 
sets VM_HSAVE_PA to non-zero, which then triggers this #GP when SYSCFG.SNPEn is being set and this will subsequently cause SNP_INIT(_EX) to fail
with INVALID_CONFIG error as SYSCFG[SnpEn] is not set on all CPUs.

So it looks like the current SNP host enabling code and effectively SNP is broken with respect to the KVM module being built-in.

Essentially SNP host enabling code should be invoked before KVM initialization, which is currently not the case when KVM is built-in.

Additionally, the PSP driver probably needs to be initialized at device_initcall level if it is built-in, but that is much later than KVM
module initialization, therefore, that is blocker for moving SEV/SNP initialization to KVM module load time instead of PSP module probe time.
Do note that i have verified and tested that PSP module initialization works when invoked as a device_initcall(). 

Thanks,
Ashish


