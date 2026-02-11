Return-Path: <kvm+bounces-70867-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sFeQMGiqjGlasAAAu9opvQ
	(envelope-from <kvm+bounces-70867-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 17:12:24 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F52B126009
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 17:12:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9CC443029E5E
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 16:12:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E15633B6EA;
	Wed, 11 Feb 2026 16:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b="MooCDTcf"
X-Original-To: kvm@vger.kernel.org
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011027.outbound.protection.outlook.com [52.101.52.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5372F33A9F0;
	Wed, 11 Feb 2026 16:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.27
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770826324; cv=fail; b=Il9JeI9aAk4d/k7F6myjWZ09bExMPRUjF3DcStzY0oHwsC0PXPBKQvXPAw4F31FxeV9a7wld9vscGKjq5DbtF8UVRvp4IifwHSWdIqP8x0ONmjkAxeNgeiDV/+ruWApQIxHAw/gCAhVgjaYt+ICua1uA5et+EF/RVG2NP+7XT4o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770826324; c=relaxed/simple;
	bh=FRsH4Fr1g8XRXu+WCfKRVlZg22mADM3i41iEwfzrDBQ=;
	h=Message-ID:Date:Cc:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=VSif6QSblCNHrD08c4PooTJy4BYW2FfvUYfT/52aTQwcjDv6sDa4RtuslkuFtYqt5jpiDnjXrBDJHleaBleS897tMWSotdSUyMDJbOsJ+6AAw5QtiutTCFM9PlePS8shEsI56sp1QClblhazFs0mJT4qCsQOXwOStUR7jRo5xJg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=citrix.com; spf=pass smtp.mailfrom=citrix.com; dkim=pass (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b=MooCDTcf; arc=fail smtp.client-ip=52.101.52.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=citrix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=citrix.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WbbYAj4ZWzsB7enDLqcnwOjK8NlN0QQWxKdGsScDavuT2HgXQ1b7G8oBADAAhcWYFjwFwLBtnx2gaNX57n0XYHvFfq/bnsZvMafp1l7yvRR9wCsUXfzO/baRqalDYmelyCcA5vOlae2Oy2Y5tYdVqAh/9HEOmHk0MXx+6dxHHRvl+xOdl9fDG28I3In9ZBaU6BuB9SmiHSAuz7NBUhmLWhqXCefdnpdglDoe5RXtb6U6F8C5ZQb068UYC/pPneYRapVsTnfIQPRyPtSvOxbtDImKpnMWjSXLtkKwy+LirgD9tMb/9tWWmbggTXk9TpaLLrajI+Gh48dyunSQSb4SoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EEIG73UweMFiXAJA6eqcNQDsABzAvhVw54iYF0KMtY4=;
 b=C4JgBhJ5XU4vrGrO34TWQern1vpag5Jfv8BdPd6OGDqCrR5TnqVgUM2HHV+D/NGW4T7ohIcTpnTBNaNqtjCf06kjczoR1F1ANWOQTow4irVDGc4gVnBM5XW+5RrnOekTUXSIN/8aakuikUODhIhqBn4Cs/PK8nEtTdLh8flsPQbrzUQr5x4F07HmgoR75UZB8WbEtLINRMG4NDhmT6EWvaQV1do7hOGXGHiwgQWgZ+tCq91SEUx2DlKwivskSUGD7AbYWEsz3reosAz4zIxsiy91O7Mk1UA3AYYRvtpoi1C/8l2qMFpbJRqMlG2eyqDPmxJSLjvXohldX+NMBEVfFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=citrix.com; dmarc=pass action=none header.from=citrix.com;
 dkim=pass header.d=citrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=citrix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EEIG73UweMFiXAJA6eqcNQDsABzAvhVw54iYF0KMtY4=;
 b=MooCDTcfZ4Se1HlJFZz1GoWjXlEUwKNxThMtygAM34mxjmIWRuLxdmsZRciguMOHPjppaDepvcwb2rJZoXviJl5Ii+JaPp8PTARUXdKW2iuWr/kG8KEcu2OmhWpUU5BchYfs3JDSGDiviDjFhvZMBvRcuNxXXF04IsONYLn+6aU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=citrix.com;
Received: from CH8PR03MB8275.namprd03.prod.outlook.com (2603:10b6:610:2b9::7)
 by CY3PR03MB8127.namprd03.prod.outlook.com (2603:10b6:930:100::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.10; Wed, 11 Feb
 2026 16:11:57 +0000
Received: from CH8PR03MB8275.namprd03.prod.outlook.com
 ([fe80::a70d:dc32:bba8:ce37]) by CH8PR03MB8275.namprd03.prod.outlook.com
 ([fe80::a70d:dc32:bba8:ce37%6]) with mapi id 15.20.9611.008; Wed, 11 Feb 2026
 16:11:57 +0000
Message-ID: <bc3784ea-3315-4e96-9cc9-7f837410e7d9@citrix.com>
Date: Wed, 11 Feb 2026 16:11:52 +0000
User-Agent: Mozilla Thunderbird
Cc: Andrew Cooper <andrew.cooper3@citrix.com>,
 David Laight <david.laight.linux@gmail.com>, ubizjak@gmail.com,
 bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@kernel.org,
 pbonzini@redhat.com, tglx@kernel.org, x86@kernel.org
Subject: Re: [PATCH 1/2] KVM: VMX: Drop obsolete branch hint prefixes from
 inline asm
To: Sean Christopherson <seanjc@google.com>
References: <20260211102928.100944-1-ubizjak@gmail.com>
 <2af5e3a8-f520-40fd-96a5-28555c3e4a5e@citrix.com>
 <20260211134342.45b7e19e@pumpkin>
 <5276256b-9669-46df-8fcd-b216f3d3e45b@citrix.com>
 <aYyjw0FxDfNqgPDn@google.com>
Content-Language: en-GB
From: Andrew Cooper <andrew.cooper3@citrix.com>
In-Reply-To: <aYyjw0FxDfNqgPDn@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO2P265CA0331.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a4::31) To CH8PR03MB8275.namprd03.prod.outlook.com
 (2603:10b6:610:2b9::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH8PR03MB8275:EE_|CY3PR03MB8127:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f0587ac-a0c8-47e2-ad59-08de69884790
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OTJrZnM1cHIrY0pPOG9WSzZaVE0yazkzclM2UGpkYXZiYllKZWYvTFFJcVhW?=
 =?utf-8?B?SVpOWjJORFVXV050RWdmMjhNSGRJbzVlWHdtQStGNXhtZU4xS2kwZzJxVHU0?=
 =?utf-8?B?bVVZN0RwVUdKTXNZWktYWW1QVGVJRmducWd0K043UXFwYk1oMStYVU8yNTU5?=
 =?utf-8?B?UTZqMHRhMDUySlRmTjFqa0V2NkxWd1JlRVBMdXpXbzVUNTlMd09sd01HclU3?=
 =?utf-8?B?c1hBUVgzOWgrdUI1SkZmSnAzOFMyanRUY29nYkZDalRaUHM1eDdrUTAvOGwx?=
 =?utf-8?B?bENzMldibm8wZXYrdkZiNFRQeGwvY1NBRWw2cHZtL1Rxblpuai92aC9Ld3NU?=
 =?utf-8?B?M25ucVlWdGUwV0h4b1JTZ0lXS1V2NE5BNmZCa29tSmoyWVRsaDJjL1UvMmlp?=
 =?utf-8?B?ck9vdWlrRC90VXQ3NDl1RWlaUGdqU0tVZXdoOEgvMmdwclhhR2FRZ1ZaQ3NE?=
 =?utf-8?B?QjBGRHdsQURzZWtod1RhT2ljV2dGVTFrUHF3VFJrckRhK1o0WXFNSU01Sm5Y?=
 =?utf-8?B?Y3IxU1hkbmJLQTk4ZDNFRTlTN1F6ME1jQzNvM1NwTWV4bGFxVG1tOEdpSTNK?=
 =?utf-8?B?MHltajNLejRBZkJMWXFOa0dkWDBXZFlLY0Y5VzY3QS9xK3FvSkRhdHlLa1o1?=
 =?utf-8?B?Um5yUnhQRjd1UGdIUGZjSkVMSUkzbng1K3RIMGdVcERaeVFHZXBZZUJzL2JF?=
 =?utf-8?B?eFRuM0o4UFhCait1WlpvMWR0ZDIrMHNnVmpiSzFITytvUWk4RU1DeU9WLzVK?=
 =?utf-8?B?VE1WaWw0TWp5eXhLQzJyY0JBZmZuVlc4aGFmeXJIbXdQNXN2ZVdYNWh4WmxP?=
 =?utf-8?B?eFJrUGFScWR6cHJpclVLTTBGYjBzeUpDSTlJamRtbVoxdlRWcGJiQzJKVWVH?=
 =?utf-8?B?S09Fb2hzbUpxZTdXS1R5TFVlSHdRV08xdDhqQTV6akRjL3orSG4rWjFGcXhJ?=
 =?utf-8?B?bk9rdW9qbERJQUkzbWk0M3YyQVVRQnBJVjJJUXUxdDVRZFFIQjdBT3J3Q1Ry?=
 =?utf-8?B?YVBvMFBMNHJ2bGZqNWNNZzVaNGxFa2RXL0tneVhieVI5bEd1VE9TZ0VNSllQ?=
 =?utf-8?B?eHFHMWQ1ZElCQi8yT3lpQkNyVmk3K0RiekcycEUyblAvbVk1UVBEbldXcWlV?=
 =?utf-8?B?emh3OEhJRkVXNFBTSHFKaWVuRE1NYmVFeTNzbHZEcllrNklJVkFuWWFsdDhm?=
 =?utf-8?B?eW43cDZGNWFNL0FQYVB0RVVnSW94WFhnNTlhTDV2WjN1SHM0WjBUNlNKSnU5?=
 =?utf-8?B?Q0NmbnVlZUw5YzhBTnBXSVlDMk9NVVBNc2VBVkdBZVZ4cnBwbFIvajJlc0JM?=
 =?utf-8?B?YzR3bE5zSndxRDJlYWVzZFh3UklMcTY0TTAvUy9NcnEvUURpTnFIRElsbHhr?=
 =?utf-8?B?eEtXanlnUHE3ZjZET3hUV3kwbW1SL2lmMitmbXpvMTBNTUtKMndrbnNtMGRZ?=
 =?utf-8?B?b2NtdVcxWm1tL0tKSkFud0VnTVR1UzVScVBSNUJ2TTNCTlBobWc0dTA5UkVS?=
 =?utf-8?B?d0RNK3JhWGxIMHV3TUNOeU4xRGZpbUl2Y0ZzVDFYK3lxMEQ3OEpzR1pnUGlx?=
 =?utf-8?B?RVdJOWpsVldUdnp2dElzSlN6YTJFZXA3cyt6RlFNVS92SHFzNDl2QVB3aStm?=
 =?utf-8?B?L3hPRDd5WDl3NFY2VXUyZGxUbTd3c3lWZkZOTTE2WWd0T0tRd2hWNS9ZWTJY?=
 =?utf-8?B?YnhUMjlRVDVIUVZicUN3QUJFQ25kWjdObTNxMVpPSnhSSWtsSHByZXdDNllm?=
 =?utf-8?B?UHBUOU5TVnFlbldtQUFFSEY5UE1JaEErdWZ6RmhNdFlPRWNkNXRzYzE5SzhV?=
 =?utf-8?B?RHg5eWdTZTJ5bWxMenpiKzBmODZqVGNxT0x5OTB0azEyWkdaM25FcjREVjBP?=
 =?utf-8?B?S3BCWTQ3NDV0dWJrWGV3bmlLY3pjZi85bHlBYnZ6VUQ2cHhjanluU29YaVk3?=
 =?utf-8?B?MnptbzhzRlJkQm1tdGl5eElyNU1KaERzbDUySXRXeWx2UnJ2cXRMYjlOOGZO?=
 =?utf-8?B?WUhzdDBKaU9BMC9xOXVBOFJab1EzM1UrYis0VXkwUzQyejJVM3JLSFI5aFVs?=
 =?utf-8?B?NjR5MkJBVWE1UHFaTkd0cWJFTWhrRGVsZjRTMnVOQzZacU5uTTh2RlZMd1Zu?=
 =?utf-8?Q?0u/A=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH8PR03MB8275.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M0VCUis3QnFKVTgvK09xNElOK3oyUnlhdzVrNFROWldraG50QS9ZMmhGNWRl?=
 =?utf-8?B?UVk2aGNPMXUxT0FQV093UlZOOUJrZ0hWVWlQQUNwNlhjYlMzTDlDc2VTSnE4?=
 =?utf-8?B?SUJaQytML2ZOYk5BdHJMSmp3bkdmWlh5b2x6SEZhRE90eDErbkN1NEorb3NJ?=
 =?utf-8?B?elN1ZXNkZWJEYlA4VEhhUFcrazdQSmhsRHR4V3BXS3I0ZlVlWnZ3WEpYOEVU?=
 =?utf-8?B?Qlc3cWlXRXVyaWlqSmZVOUNWTDBLMER5alFReDNIM25aeDhrSVpRSy9ybHlW?=
 =?utf-8?B?YVU4NWNOa1J4UEZNdFE1RGEwVjY0dEIwNVRFaUJrdlI3eTluM1pHQUNYZnQ0?=
 =?utf-8?B?QzJpUnArNFlNd3Z4NG5ScnVzK0I5QjQ3RFhvbnJVMGdTc0ZjR3VBVnNrREpF?=
 =?utf-8?B?UVgyUVd2VTl5N1RuKzJPZnQrUlE0MmZkRGFUaTFPRElQNWJZNVV2Q2ZoYTNB?=
 =?utf-8?B?TVNEU2ZtemwwWFZnZ3BtQjcrYjVUUldCQks3djlJYURTTFBXaXRLZ0JDY2x5?=
 =?utf-8?B?aTFCYXpOWllzcFJHSjNTOUxHNUhpNEFWUzIxbFg2cjYrTERORUphRk94QWFq?=
 =?utf-8?B?empCRkRiYjBVdHoyc3AraGFxWkdRbEVpaGFtSTRkRWdlY1VTWUt5ZVlMaXB5?=
 =?utf-8?B?OC9XVEZMU0lUR0k4TG5QSlp4aDQvTUZoeU9XNEN6emhVRDJlMkhaRzc3RVhU?=
 =?utf-8?B?TGdVaWhKZEw3NnJZNTdJYkN2bmNkMkhjS3R0LzlnekdFVEZMRWExTjloM0xI?=
 =?utf-8?B?K1NaMTJiVUh6TjRuVE9ScTV6Z1kyMktiYVRhb05WSkdRMVV1SGtiZlhQbGtz?=
 =?utf-8?B?T0loemZGbGpCdGJOQ08yMzF4Q05xVUJrTlBzOGg4RlVkcDFQWnRheGhleDdR?=
 =?utf-8?B?WjdkQURwZWw4cldGczJoa0wrQ25jeUFWLzFPYjBlKzFlZE5FOVF2S05ETEk3?=
 =?utf-8?B?Z1RyZFc3aWFrck5WQ3YwRlFiQWNjZFhzNkF5ejVJZmpLM0VRcG9IMDArK0NL?=
 =?utf-8?B?anFhb05NZVpnL2lmT25mZzQ5NHd4ek4wRllJcEJuSG1WcWUzRGNOd1BRV3A4?=
 =?utf-8?B?akdzaGFtTkVsWHQ0NyszYTR6ZS95RkRYajZ5aTZRNFZBWk9MR04wRXFjeFdU?=
 =?utf-8?B?MWZFcTlXQXYyQ1VFanNGaXYzTjEyUGNheVJzZXNNVGpOSmd0VmNCdkhCZ3NJ?=
 =?utf-8?B?dU8xSHRtcVNtRm0rbW53bmpIM01OOElGTjNXTWpDbFhwbWZHU05qbGtqQXNU?=
 =?utf-8?B?MUJjREZvMDY1bGVqeWpOT1pVOWsyallBUGk3cHcvWG92NnlZZlZCYktzM3ZX?=
 =?utf-8?B?N050TiszdGxaRnBCdldwQnpOWjJMRWU5MU03cHZnM0l5WTgxd3dHL0s0dzMz?=
 =?utf-8?B?NVFLdTJac0JGL0ExUVdDRDBsd1VLWjdCa1dyZnVKL0pSNW9QZmhlVGo0OWdT?=
 =?utf-8?B?NWFGeXNRUmRJdURobE1sRHJJT2xyWVZDT3grdXJJNWRqZDFlTlVuZm9Zem9P?=
 =?utf-8?B?bmZSSlloc1ZTcS90dldTN0llbW5RSVk1djVwU2RrRWVQb20rNmVFQjhGWW1m?=
 =?utf-8?B?MlErenk5cDgxUTNZS2YxZ2RScXRzRnE3RXJWZHYrcTJYUnNQMlZGMXFFNzV2?=
 =?utf-8?B?Y0lmNmUxZnE4SlpiQVBGKzEyMnVuVTNwRUxzV1hxSXFPdDM4Q0c4Y21tb1Ew?=
 =?utf-8?B?RW95d3lJcjdyWHA4ZGN0V3hKeDF4K1BibGFKdXdCaGU5NmRYcHNBdE5jYnYy?=
 =?utf-8?B?NGtKWVNIOTFBN0JyYmlVSjV0enBKZ2FrUVg5UjgxTExlOEpKS2VyVWQxQWFN?=
 =?utf-8?B?U2NxR29IOWpQVVRTa1huQzFubEw2dVo5Vm5nV3hTZWRCVW9FaWJnaGlvSkkz?=
 =?utf-8?B?aVkzelh6Z0lQcHlpNDU1Z0lPeURRR2RmcDBYSUJtT08vUlBrdU5EeHZNVEtG?=
 =?utf-8?B?Y1JCSTBzYTF4T0lHRlJ4aUdDUjBORGU2eWVuZG14Rjd4TEZKMHNsbEpCU0J0?=
 =?utf-8?B?WElqWlBRVEFidTNxajUvOG5qd1ozdU5oVGE4Vm53L3VlNFhTRGtDbU1GWkJj?=
 =?utf-8?B?YjUvaFNUYXNqZTVqZ0wzMm4xalJmbm9EY09CY1NWTjRXVzhwa29TMVhHRUZh?=
 =?utf-8?B?NzdvcFBGUVMzdk5ZYVpNMzQ3cU5PZ084SytOOXgvVU9xZVcrU0c2MnRCd0pI?=
 =?utf-8?B?VTRjemxvMWNSNmJoTEU3bnBQanN2b0V6M3FBMTdxc2ZtVitrNkMrdFNleFFK?=
 =?utf-8?B?SHlKU3FYY3F1K3FBRnQyR1FWc1l2cmVvNjQzM1djRG1JcXB6em1Oek1sL0ZM?=
 =?utf-8?B?NERzU2IxcFhJQVBRNnN5LzNibFo2RWxUamIvK0Fyd0VpcjVJYlYxZz09?=
X-OriginatorOrg: citrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f0587ac-a0c8-47e2-ad59-08de69884790
X-MS-Exchange-CrossTenant-AuthSource: CH8PR03MB8275.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2026 16:11:57.1308
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335836de-42ef-43a2-b145-348c2ee9ca5b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t+mG7T9nhQf/LC/xOo7fcBtjv+4GSpQGxJMOJgmcWt9xvNRBP4PP1PITtXbHRtu8qhvDGIJiS8QOBqDz43IbepKzJsj1gC2Fovin/L9kRpE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY3PR03MB8127
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[citrix.com,reject];
	R_DKIM_ALLOW(-0.20)[citrix.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70867-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[citrix.com,gmail.com,alien8.de,linux.intel.com,zytor.com,vger.kernel.org,kernel.org,redhat.com];
	DKIM_TRACE(0.00)[citrix.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[andrew.cooper3@citrix.com,kvm@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[citrix.com:mid,citrix.com:dkim,citrix.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 5F52B126009
X-Rspamd-Action: no action

On 11/02/2026 3:44 pm, Sean Christopherson wrote:
> On Wed, Feb 11, 2026, Andrew Cooper wrote:
>> On 11/02/2026 1:43 pm, David Laight wrote:
>>> On Wed, 11 Feb 2026 10:57:31 +0000
>>> Andrew Cooper <andrew.cooper3@citrix.com> wrote:
>>>
>>>>> Remove explicit branch hint prefixes (.byte 0x2e / 0x3e) from VMX
>>>>> inline assembly sequences.
>>>>>
>>>>> These prefixes (CS/DS segment overrides used as branch hints on
>>>>> very old x86 CPUs) have been ignored by modern processors for a
>>>>> long time. Keeping them provides no measurable benefit and only
>>>>> enlarges the generated code.  
>>>> It's actually worse than this.
>>>>
>>>> The branch-taken hint has new meaning in Lion Cove cores and later,
>>>> along with a warning saying "performance penalty for misuse".
>>>>
>>>> i.e. "only insert this prefix after profiling".
>>> Don't they really have much the same meaning as before?
>> Architecturally yes, microarchitecturally very much not.
>>
>> For a branch known to the predictor, there is no effect.  If a branch
>> unknown to the predictor gets decoded, it triggers a frontend flush and
>> resteer.
>>
>> It is only useful for programs large enough to exceed the working set of
>> the conditional predictor, and for which certain branches are known to
>> be ~always taken.
>>
>> Putting the prefix on a branch that isn't ~always taken is worse than
>> not having the prefix in the first place, hence the warning.
> These branches indeed ~always follow the hinted path (not taken in this case).
>
> So it sounds like this definitely isn't stable@ material, and maybe even begs
> the question if dropping the hints is a net positive?

The new behaviour only exists for hint-taken. Because it only has any
effect for a branch unknown to the predictor, the behaviour without this
hint would be as if it were a larger basic block.

hint-not-takens have no behaviour since the Pentium 4 that I'm aware of.

This change is almost certainly marginal at best.  It's not as if
VMREAD/VMWRITE lead to good code gen even at the best of times.

~Andrew

