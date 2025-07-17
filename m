Return-Path: <kvm+bounces-52710-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 029E0B0864E
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 09:16:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 35BA956299A
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 07:16:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62F5221C166;
	Thu, 17 Jul 2025 07:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="XD/QWzKT"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2051.outbound.protection.outlook.com [40.107.223.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DC911D554;
	Thu, 17 Jul 2025 07:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752736577; cv=fail; b=Pv3muvNqwBHJkcnaOYuxXlsM/9HOTWBcjUSocEN7xarKMilJicX1oMuaeQRNy/dmks7Xk+KjOkLeSr9NG1hzR+JYjFMg5w4/bolnMLTxzHPnKh5BuKiAa0YBLEcL95cee0U10gKU1ewReb+fV2Svh6e0sq14eOeTH9bPZAccEW4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752736577; c=relaxed/simple;
	bh=qI8bdIrTHlK0y94vG09JpxetwHHpM8oIjYj69ZlsFIw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=EbBwcuhGDhHu+3crkt6qH13DisSz1YlI4WZkeT3oeqx2vjxl2ZYNZRZkDdobF5PTIhkCI+Es156MAOVpwrk+oVWaLecMcI79oF6cfQ/hcyXlUuoPJNQMicA9pEdb+I5MlaktHR8+d9ih7qTgxN6sshso4JNbG8lDAETC5zFWvaA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=XD/QWzKT; arc=fail smtp.client-ip=40.107.223.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QBlReK63CzyX2xZUIDQu1qoOgq4Il/c6aBPGXREnUn2EXuW+VvHEGpJCDUP8rVKOol2Js2Sf5GkABzcVyoUUDRBsXm7hNC+R+VwNsjvsNpi/gglF1jjgCPd8hsA9CtkV/ZgNkkCEFwwmnp/sx7ARSEtL/5MTBRJFEpXBY4idyUoU1cV0PeStTQh7jeMXhpy2oVw+JCg2V9EVnmgPbq8VKm0H5ZeZfr373aXm3cXIGiQ4QZc0VJ3JpuSTkH4JIkrwERwroDwa5ETBaWdpxEVhumk33Oqgd9DUeVoDWYdDZz+FewcoHfaY6y1JW+TVDmHnsK5b59RstQt23z0Qr51FIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RIElyVdxZJmBQ3qU2G7ENzBqH3ZmPEdJ7Orzxl4zO68=;
 b=nrTCXfi+u9IKiJf6hvg4MQrc77ijxD7k++iSkkDeU0sq9MYYrrAxIhzVqySPum9VMh4JEzeJoySfRoqzORw03Wbe5DMece6vn+rFGtq6lQX3H2QEvJTZ33RplAWBDsYxv0UIEcY4hxpXiXnqwTjSXRJJcv4nWJunRsJHl+RfPkqhurHfY37fZ6J+bMsEcrpS2ccwaMev0RHiWwek5piimJXDX6FlbPH2oAm8X0pfP/EilRboz3QiqoBBhVztgdVIa3EfFe+s58b0MaaDM03KUpWnouYR7BWrW2SrsuQWREhmWBDFxlg4eoaUokxPuGxW/YCyA4l1hPvxw2hN4kpCmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RIElyVdxZJmBQ3qU2G7ENzBqH3ZmPEdJ7Orzxl4zO68=;
 b=XD/QWzKT2BrRV3u9ZWVOUvKnhBH8ZKDc5+WQqBRxyomwWYSgEtwNv1JWhNF1L+vpjVEhqUoGpNpsN7UI8zJ5barc/tePPMxOo1HQs/er2LdHiGkMHWwCo5w5u7pvqXHmFl5qS18KqykVz4Nc88KCsXcLZonILWIBaU55Xy1vwtg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by CY3PR12MB9653.namprd12.prod.outlook.com (2603:10b6:930:ff::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.39; Thu, 17 Jul
 2025 07:16:13 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%6]) with mapi id 15.20.8901.024; Thu, 17 Jul 2025
 07:16:12 +0000
Message-ID: <4dcb8442-769c-4608-b4f9-4518d2186356@amd.com>
Date: Thu, 17 Jul 2025 02:16:09 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/4] iommu/amd: Add support to remap/unmap IOMMU
 buffers for kdump
To: Vasant Hegde <vasant.hegde@amd.com>, joro@8bytes.org,
 suravee.suthikulpanit@amd.com, thomas.lendacky@amd.com,
 Sairaj.ArunKodilkar@amd.com, herbert@gondor.apana.org.au
Cc: seanjc@google.com, pbonzini@redhat.com, will@kernel.org,
 robin.murphy@arm.com, john.allen@amd.com, davem@davemloft.net, bp@alien8.de,
 michael.roth@amd.com, iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, kvm@vger.kernel.org
References: <cover.1752605725.git.ashish.kalra@amd.com>
 <7c7e241f960759934aced9a04d7620d204ad5d68.1752605725.git.ashish.kalra@amd.com>
 <e71a581f-00b2-482f-8343-c2854baeebee@amd.com>
 <84fb1f3d-1c92-4b15-8279-617046fe2b93@amd.com>
 <91572f4e-6607-41b8-91b6-146261393f07@amd.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <91572f4e-6607-41b8-91b6-146261393f07@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA0PR11CA0139.namprd11.prod.outlook.com
 (2603:10b6:806:131::24) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|CY3PR12MB9653:EE_
X-MS-Office365-Filtering-Correlation-Id: 6bb14070-36ad-4199-a0f3-08ddc501cfb0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Q212Z1cyU3ZEU091L25ZbkN0QWRMRStWY3F2RUxFRXVHU3pLa0phQlBaZ1NB?=
 =?utf-8?B?THBsWVdlSGVzVm1La2RaSHZKdHg4eUNWa3g0QnhHRENCWGNQWmNvYVUxeEdC?=
 =?utf-8?B?bE9SazYrNE83RWttRHJBWDQvdmtwaFhwNFFEdm1JNDBvUWdEVUNSdjBZM2o1?=
 =?utf-8?B?MXJOdEZxak1tNlpPNmRaNWVWTFlrN1hiOVNUbWFJNko1MUdNaWV4K3RpQ0Nm?=
 =?utf-8?B?WHYxUVFKSCtQVVAvZkp2NU9KOHZCNnhTeXpGem5hNk5xT0FLYU9nYUFIUjh1?=
 =?utf-8?B?UmdiMzd1aUxKb1dEbGZhZFlYMXFNSFhwczdaSGhmS2ZqUVFnVHdZN0RjZEJX?=
 =?utf-8?B?QnRwWGt0QWE1a01xSXV6MFI4M2o0dE9Pc0hTQ0VEN1lqeEdIeGFOMkVYZVlr?=
 =?utf-8?B?cmFMQnBsbTZ0VUN3d1l5WCtMbWd4V01GeW5CL3liVkExOTJ1QWJpeDZUWWsy?=
 =?utf-8?B?UXRRV2pHQ2Z6eFR3dVNYMXo5eHZWWWZYSlJhbzVxRHZ6MDkwS2ZqRDVYVVcw?=
 =?utf-8?B?WW9ORGxnZE1Malk4Q0ZPcmtSSGl0Q3JKR1k4MlJGUlQ2dGk4QUNnSFpqNHF4?=
 =?utf-8?B?bXg5MElPajNJSnpNRlVlcGY3SGtGZ1hsWXFWNE9Wa1JESjlXSXVEMSsrN0Uy?=
 =?utf-8?B?aS9oVlducklHTlFqeDJaMzhYT1RzU0pEOEd2WkIycWRXdU1qcXA3V3FGdldR?=
 =?utf-8?B?VFN3VVFPRWgxZ0I3OC9KSGcvRGY3ejFVeTY1Zy84YkMrZ1FhODdlcVovaElG?=
 =?utf-8?B?Z2puOXZud3VYNUM3SjRuOEtrRWhKd0hyd1VlZkIvTTFydVJ5VENYVVNsaTVt?=
 =?utf-8?B?RzQyWW95ZUNlWHhLWWI2UVZ1bXEreS9PWXFSZEJYQXo2NzkwS1hRb0hvVHNm?=
 =?utf-8?B?dFFaOTROYlNwUmpHVkJLMXJXTC9FdGlrZ01YaWFKbmthdzFiSEFOUU51ZTJm?=
 =?utf-8?B?Q3lMZm8xT3dxYUF0ODB4eldKd1gwSW9FUnpuZ0ppVmlncUpuc0lrYVFGekNK?=
 =?utf-8?B?Yk1hYlFLcWFnK3FPRWYrOUNQY0VlYzE3SmZCWnlBbnl4aGVzOUM0STM2RVlB?=
 =?utf-8?B?UFMrU3ZSc205aVJZQzZjQXlXclJiU2NxVmxBQUJEWUxzajZyVkRoTzNkY3M4?=
 =?utf-8?B?dVRzMEYyem5vakdVNzRia1pseDFDZE9Ca0crVjhXc2NJNjRROEIwbFN0NWtO?=
 =?utf-8?B?OVpITUlEa0RPemZEdmtueGVPbndzaENKQXJ2djM3NHJ2STBQRldpK0ZDOGJt?=
 =?utf-8?B?ekkxTnlkRnBqZXFQVlpYSUhXNkJKdEVXNXExdldzeEprQ2xhNWZWTmh1TDRV?=
 =?utf-8?B?RmY0Zmg1KzNjR2U1akR0QUZ1b2w0VlJIa0Q4VVAwMlJIWmplS1NOdkhhMk1x?=
 =?utf-8?B?TzBxcURhSEUzdmY5am9oTTNzMUkxMFBBbWk4dXNrNUI5TGU2ZnBjMHl0MTRL?=
 =?utf-8?B?OXdzZllwcExHOUZmUWxPNUxJWWVkWGxmSmhOZGo0QWVKVnBtOU1VYUl5bVVN?=
 =?utf-8?B?MlIrZkVNa1FNdGp3WVRRazNZalMrTHAybXBNSnlXdWJuMTNSUlJORTMraWpC?=
 =?utf-8?B?VmRWU3k1WitpWExMM0lER2Ywc1lINXV3SEI4WUtsQlZScW1ac1B5dHJ5YnE3?=
 =?utf-8?B?YmxmZ1JnV2M4M1BsUUFxRWsrc3ZYb3hBL2thQmtaUGswWXFSQW1rQy9kRzNV?=
 =?utf-8?B?cktXSG44eG1wWGFMR3RSOTlqUnRKVVBGWGpIUVc1RnN0SmlUekFBVVlpVUJo?=
 =?utf-8?B?ODU0ajJ0TDVYRGtOWjcwNWJmVG1LWjhCcUdtVGlJUHcvYVBTQ2VOLzVwU25v?=
 =?utf-8?B?RjZJRkw4dVJteDFZZVJWYnhqa1RBVTJIMUxISW41UnJCYzV5VE4wOTNyQjNE?=
 =?utf-8?B?QUgyQTlnL04wREZwc3ZzRlhtVHkwRFZsd1lnZVZjR09qaFZqbDhJc29IMGYx?=
 =?utf-8?Q?09Y7sTIa/DU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M2c5N1U3c25oYjVnUjZrN25tQmFzcFBNMFlubzVBVm91OFpPVExPV3J0VlpB?=
 =?utf-8?B?MEsvR3lQQVVoRDVMa1ZmeG1GZnlaQTdlUnk5YmhRaG9IRzJnb1ZWcVJVd0Nr?=
 =?utf-8?B?OE1Eay8vb0VLaWZvNGJUemxuZnQvajdoZk93bDVCVS85bHgxNHM1TE9yR0g1?=
 =?utf-8?B?UFZJQUFKSXJocXUzVmtGelA0Ym5Eek1FSERuT3RWZjdoME5rS0hHZk1kTVk4?=
 =?utf-8?B?a1RtTFhvaFBxd3kvdmNCMG4xMVQxR2F6UkVrNTJSM3VUK3RQODcyZFl3TG1N?=
 =?utf-8?B?Y0JrcVIya2Q0N3d1akpNUjNWV3J3ZldiTWZRd2RQdDA3YWttNVRYS0p5aFVI?=
 =?utf-8?B?bG5HMmxpeldraDYxQ0RiYWh4dG0rQVdIWGhNNlR3WHJzUGsyaVR5bndpSFRx?=
 =?utf-8?B?UFN1WFR0RGY3MXM4ek9XMURVQmhpazlqVlFUK2o3QnZ3eXF1Y0pucE85RE8x?=
 =?utf-8?B?Z1ZlZGY4QnltNGxoYTl1QVdCa0pEZGE5eFM3Nm5TSXc2ZUdtVFFvSk0xUllr?=
 =?utf-8?B?Z2FpQXh1R0tkSVY5b2V4ZEVLSVBRRkxlcWtJbDhtYm1GTE9yeFQ2c2RvZllF?=
 =?utf-8?B?UkJORHo0U2pKNzZkaGpNaWl1Y2cwbHBDL2N2NllhRFpmcEVqZVd0V2l6SVd3?=
 =?utf-8?B?eUFNSDB4ejNxaU1pMW52YjNNNFpvdVp5RWl6QjdWdzBWUy9KQmpHRDc1aXRo?=
 =?utf-8?B?T0hNYkxmcERzOFZMVmoyczBiaG1MbjJ4aXBUckE0eWEvRFUxVzdPY2pkMm1M?=
 =?utf-8?B?Z1d1UGh3Y0RET2ViT2dqWDRENlFUMkpZODRESXl1NGlLb0JEVXl0MWg5NEpu?=
 =?utf-8?B?VFczQkFORDlPcGNDMG0yVFZwakJKbDE3MUFGNnY5QXRkTUFTa2V1MWZHYW8x?=
 =?utf-8?B?MWZoZW1td1RHV0ZQTzVMQ3pmTmVLSzV0d21yRU4wRlZRS0NTNTBtU1FMWDhs?=
 =?utf-8?B?MmxKaXpSa282YXMrL1ZoYkIxK29yQ0p0QXJPOVB5dWFnYVd5NkpXU1RDdGs3?=
 =?utf-8?B?UVZHMWUzTTcxMWlSTStJc1FIa0RkTFhLSmlTNmIrUVhEMURNTVROL0JaUlg4?=
 =?utf-8?B?MU9zUTVoNDYzWHo0NUk4V1NvZ2R4anEvZFp2TjgwcG5DUWZndm4rWlYwWEtD?=
 =?utf-8?B?REphYXprQWRzdzYwMGZHdldPdEZubjJ6aWU2cjE2L1laZkw4TkRRN2hEQVVs?=
 =?utf-8?B?Ylh3QU9acCtjK2E1T0djOUdIdk8xeDlTa1VmcGloaGt1OEJVVy9aWUsrM0Zr?=
 =?utf-8?B?bHlRRytMZzgwYVZBQ3B0Ky9VK2tCS3lId3lMTDVtK1ZPcEY5ZWRvUkx6RnRZ?=
 =?utf-8?B?ZzV3KzNubWtzcHZzV3hzaTRkYnFCQ2dNbFYwMXJ4T3ozeEJtNWVpTTdUWUxU?=
 =?utf-8?B?dmpZTWw5QVg3eUkwT05vTm4ySzhqZU1ZTVNFSXhjd1JMaGVuMExKcEVnOEV2?=
 =?utf-8?B?V0hQRVVqWHVOa3NGeEVqS3kzZ29hSmgzUWwyV0wvbmV4RWdyNXVFWVA1VzBH?=
 =?utf-8?B?MUo4cml1NjdPRjR1Vm1WMUdlUkZPdnYvejlxK0kwak4rZ0hUOHp3aFp0bVFT?=
 =?utf-8?B?Mk56bkp6cWVRZ1pTZWY0djlweVNIaWJHNGtqWS9zRUNadjE1b2F4T0V6dlh0?=
 =?utf-8?B?SThEbGdmamszdXBqQ0hwa1pRQTArSmZJVFBvK1pqeGtrQTZhc3Rmd3lJdFRR?=
 =?utf-8?B?OHlsd3gwVHJoQkZmejFWcElPL3htSzRmc1U2dklzY0t6dGREMHJacWdXMUsz?=
 =?utf-8?B?S2RQL3lHa0RVOWd1QnhndEp3TWQ1L2VmSjZLTHd0M1QrUUwxTElwenNZSWlV?=
 =?utf-8?B?dm1KVUlQQXhUUzRtbm9XOThWZkpiaXFZalJyWm1NUlYvQVFaWGlza0tWUThC?=
 =?utf-8?B?R0ZjeEdmVG54ZzVXWXdmZ1REb1RaY3ZYNVFHL01wOE5pVTJkNi9TV2pPcUxu?=
 =?utf-8?B?TVFWSmRuUXcvOCtXYkdTS0M3dndzVlNiUS9KdVFUaDdlSDdjcDMwNk40Wkox?=
 =?utf-8?B?YkFuTXc2WUh0NmtvVC8vclNKcmkvTTlXcmM3WkFoSWVtdlNTT2JucC9Ga0g0?=
 =?utf-8?B?YjZoQ2NFVHkwcXhnUTcxbUp3MVNxMUh2VE1EMFdBN2lpa0pzNkZ6QTQyVGJm?=
 =?utf-8?Q?fTn48JE6S6MUQd2eORn1HbCCS?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bb14070-36ad-4199-a0f3-08ddc501cfb0
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2025 07:16:12.8632
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CASjlTILS+pFTTRKuk5afbQ+fJ1ohE//njKLUCZDIyjY36jE06NORuxxwK2RlzqHRD2X5uRdetniMHY762NwGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY3PR12MB9653


On 7/17/2025 2:05 AM, Vasant Hegde wrote:
> Ashish,
> 
> 
> On 7/17/2025 3:25 AM, Kalra, Ashish wrote:
>> Hello Vasant,
>>
>> On 7/16/2025 4:19 AM, Vasant Hegde wrote:
>>> Hi Ashish,
>>>
>>>
>>> On 7/16/2025 12:56 AM, Ashish Kalra wrote:
>>>> From: Ashish Kalra <ashish.kalra@amd.com>
>>>>
>>>> After a panic if SNP is enabled in the previous kernel then the kdump
>>>> kernel boots with IOMMU SNP enforcement still enabled.
>>>>
>>>> IOMMU completion wait buffers (CWBs), command buffers and event buffer
>>>> registers remain locked and exclusive to the previous kernel. Attempts
>>>> to allocate and use new buffers in the kdump kernel fail, as hardware
>>>> ignores writes to the locked MMIO registers as per AMD IOMMU spec
>>>> Section 2.12.2.1.
>>>>
>>>> This results in repeated "Completion-Wait loop timed out" errors and a
>>>> second kernel panic: "Kernel panic - not syncing: timer doesn't work
>>>> through Interrupt-remapped IO-APIC"
>>>>
>>>> The following MMIO registers are locked and ignore writes after failed
>>>> SNP shutdown:
>>>> Command Buffer Base Address Register
>>>> Event Log Base Address Register
>>>> Completion Store Base Register/Exclusion Base Register
>>>> Completion Store Limit Register/Exclusion Limit Register
>>>> As a result, the kdump kernel cannot initialize the IOMMU or enable IRQ
>>>> remapping, which is required for proper operation.
>>>
>>> There are couple of other registers in locked list. Can you please rephrase
>>> above paras?  Also you don't need to callout indivisual registers here. You can
>>> just add link to IOMMU spec.
>>
>> Yes i will drop listing the individual registers here and just provide the link
>> to the IOMMU specs.
> 
> May be you can rephrase a bit so that its clear that there are many register
> gets locked. This patch fixes few of them and following patches will fix
> remaining ones.
> 
>>

Ok.

>>>
>>> Unrelated to this patch :
>>>   I went to some of the SNP related code in IOMMU driver. One thing confused me
>>> is in amd_iommu_snp_disable() code why Command buffer is not marked as shared?
>>> any idea?
>>>
>>
>> Yes that's interesting. 
>>
>> This is as per the SNP Firmware ABI specs: 
>>
>> from SNP_INIT_EX: 
>>
>> The firmware initializes the IOMMU to perform RMP enforcement. The firmware also transitions
>> the event log, PPR log, and completion wait buffers of the IOMMU to an RMP page state that is 
>> read only to the hypervisor and cannot be assigned to guests
>>
>> So during SNP_SHUTDOWN_EX, transitioning these same buffers back to shared state.
>>
>> But will investigate deeper and check why is command buffer not marked as FW/Reclaim state
>> by firmware ? 
> 
> Sure.
> 
>>

Did double check this in the SEV firmware code: 

Only the IOMMU Event logs, PPR Logs and Completion Wait buffers are transitioned to FW state
and hence the same need to be transitioned from reclaimed to shared state at SNP_SHUTDOWN_EX (iommu_snp_shutdown).
 
>>>
>>>>
>>>> Reuse the pages of the previous kernel for completion wait buffers,
>>>> command buffers, event buffers and memremap them during kdump boot
>>>> and essentially work with an already enabled IOMMU configuration and
>>>> re-using the previous kernel’s data structures.
>>>>
>>>> Reusing of command buffers and event buffers is now done for kdump boot
>>>> irrespective of SNP being enabled during kdump.
>>>>
>>>> Re-use of completion wait buffers is only done when SNP is enabled as
>>>> the exclusion base register is used for the completion wait buffer
>>>> (CWB) address only when SNP is enabled.
>>>>
>>>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>>>> ---
>>>>  drivers/iommu/amd/amd_iommu_types.h |   5 +
>>>>  drivers/iommu/amd/init.c            | 163 ++++++++++++++++++++++++++--
>>>>  drivers/iommu/amd/iommu.c           |   2 +-
>>>>  3 files changed, 157 insertions(+), 13 deletions(-)
>>>>
>>>> diff --git a/drivers/iommu/amd/amd_iommu_types.h b/drivers/iommu/amd/amd_iommu_types.h
>>>> index 9b64cd706c96..082eb1270818 100644
>>>> --- a/drivers/iommu/amd/amd_iommu_types.h
>>>> +++ b/drivers/iommu/amd/amd_iommu_types.h
>>>> @@ -791,6 +791,11 @@ struct amd_iommu {
>>>>  	u32 flags;
>>>>  	volatile u64 *cmd_sem;
>>>>  	atomic64_t cmd_sem_val;
>>>> +	/*
>>>> +	 * Track physical address to directly use it in build_completion_wait()
>>>> +	 * and avoid adding any special checks and handling for kdump.
>>>> +	 */
>>>> +	u64 cmd_sem_paddr;
>>>
>>> With this we are tracking both physical and virtual address? Is that really
>>> needed? Can we just track PA and convert it into va?
>>>
>>
>> I believe it is simpler to keep/track cmd_sem and use it directly, instead of doing
>> phys_to_virt() calls everytime before using it.
>>  
>>>>  
>>>>  #ifdef CONFIG_AMD_IOMMU_DEBUGFS
>>>>  	/* DebugFS Info */
>>>> diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
>>>> index cadb2c735ffc..32295f26be1b 100644
>>>> --- a/drivers/iommu/amd/init.c
>>>> +++ b/drivers/iommu/amd/init.c
>>>> @@ -710,6 +710,23 @@ static void __init free_alias_table(struct amd_iommu_pci_seg *pci_seg)
>>>>  	pci_seg->alias_table = NULL;
>>>>  }
>>>>  
>>>> +static inline void *iommu_memremap(unsigned long paddr, size_t size)
>>>> +{
>>>> +	phys_addr_t phys;
>>>> +
>>>> +	if (!paddr)
>>>> +		return NULL;
>>>> +
>>>> +	/*
>>>> +	 * Obtain true physical address in kdump kernel when SME is enabled.
>>>> +	 * Currently, IOMMU driver does not support booting into an unencrypted
>>>> +	 * kdump kernel.
>>>
>>> You mean production kernel w/ SME and kdump kernel with non-SME is not supported?
>>>
>>
>> Yes. 
> 
> Then can you please rephrase above comment?
> 
>>

Ok. 

>>>
>>>> +	 */
>>>> +	phys = __sme_clr(paddr);
>>>> +
>>>> +	return ioremap_encrypted(phys, size);
>>>
>>> You are clearing C bit and then immediately remapping using encrypted mode. Also
>>> existing code checks for C bit before calling ioremap_encrypted(). So I am not
>>> clear why you do this.
>>>
>>>
>>
>> We need to clear the C-bit to get the correct physical address for remapping.
>>
>> Which existing code checks for C-bit before calling ioremap_encrypted() ?
>>
>> After getting the correct physical address we call ioremap_encrypted() which
>> which map it with C-bit enabled if SME is enabled or else it will map it 
>> without C-bit (so it handles both SME and non-SME cases).
>>  
>> Earlier we used to check for CC_ATTR_HOST_MEM_ENCRYPT flag and if set 
>> then call ioremap_encrypted() or otherwise call memremap(), but then
>> as mentioned above ioremap_encrypted() works for both cases - SME or
>> non-SME, hence we use that approach.
> 
> If you want to keep it in current way then it needs better comment. I'd say add
> CC_ATTR_HOST_MEM_ENCRYPT check so that its easy to read.
> 
>
Ok, i will add back the CC_ATTR_HOST_MEM_ENCRYPT check.

Thanks,
Ashish
 
>>
>>>
>>>> +}
>>>> +
>>>>  /*
>>>>   * Allocates the command buffer. This buffer is per AMD IOMMU. We can
>>>>   * write commands to that buffer later and the IOMMU will execute them
>>>> @@ -942,8 +959,105 @@ static int iommu_init_ga_log(struct amd_iommu *iommu)
>>>>  static int __init alloc_cwwb_sem(struct amd_iommu *iommu)
>>>>  {
>>>>  	iommu->cmd_sem = iommu_alloc_4k_pages(iommu, GFP_KERNEL, 1);
>>>> +	if (!iommu->cmd_sem)
>>>> +		return -ENOMEM;
>>>> +	iommu->cmd_sem_paddr = iommu_virt_to_phys((void *)iommu->cmd_sem);
>>>> +	return 0;
>>>> +}
>>>> +
>>>> +static int __init remap_event_buffer(struct amd_iommu *iommu)
>>>> +{
>>>> +	u64 paddr;
>>>> +
>>>> +	pr_info_once("Re-using event buffer from the previous kernel\n");
>>>> +	/*
>>>> +	 * Read-back the event log base address register and apply
>>>> +	 * PM_ADDR_MASK to obtain the event log base address.
>>>> +	 */
>>>> +	paddr = readq(iommu->mmio_base + MMIO_EVT_BUF_OFFSET) & PM_ADDR_MASK;
>>>> +	iommu->evt_buf = iommu_memremap(paddr, EVT_BUFFER_SIZE);
>>>> +
>>>> +	return iommu->evt_buf ? 0 : -ENOMEM;
>>>> +}
>>>> +
>>>> +static int __init remap_command_buffer(struct amd_iommu *iommu)
>>>> +{
>>>> +	u64 paddr;
>>>> +
>>>> +	pr_info_once("Re-using command buffer from the previous kernel\n");
>>>> +	/*
>>>> +	 * Read-back the command buffer base address register and apply
>>>> +	 * PM_ADDR_MASK to obtain the command buffer base address.
>>>> +	 */
>>>> +	paddr = readq(iommu->mmio_base + MMIO_CMD_BUF_OFFSET) & PM_ADDR_MASK;
>>>> +	iommu->cmd_buf = iommu_memremap(paddr, CMD_BUFFER_SIZE);
>>>> +
>>>> +	return iommu->cmd_buf ? 0 : -ENOMEM;
>>>> +}
>>>> +
>>>> +static int __init remap_cwwb_sem(struct amd_iommu *iommu)
>>>> +{
>>>> +	u64 paddr;
>>>> +
>>>> +	if (check_feature(FEATURE_SNP)) {
>>>> +		/*
>>>> +		 * When SNP is enabled, the exclusion base register is used for the
>>>> +		 * completion wait buffer (CWB) address. Read and re-use it.
>>>> +		 */
>>>> +		pr_info_once("Re-using CWB buffers from the previous kernel\n");
>>>> +		/*
>>>> +		 * Read-back the exclusion base register and apply PM_ADDR_MASK
>>>> +		 * to obtain the exclusion range base address.
>>>> +		 */
>>>> +		paddr = readq(iommu->mmio_base + MMIO_EXCL_BASE_OFFSET) & PM_ADDR_MASK;
>>>> +		iommu->cmd_sem = iommu_memremap(paddr, PAGE_SIZE);
>>>> +		if (!iommu->cmd_sem)
>>>> +			return -ENOMEM;
>>>> +		iommu->cmd_sem_paddr = paddr;
>>>> +	} else {
>>>> +		return alloc_cwwb_sem(iommu);
>>>
>>> I understand this one is different from command/event buffer. But calling
>>> function name as remap_*() and then allocating memory internally is bit odd.
>>> Also this differs from previous functions.
>>>
>>
>> Yes i agree, but then what do we name it ?
>>
>> remap_or_alloc_cwb_sem() does that sound Ok ?
> 
> May be.
> 
> 
> -Vasant
> 
> 


