Return-Path: <kvm+bounces-28707-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B1C7799BE3C
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 05:37:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 678F8283217
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 03:37:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D58AF7F477;
	Mon, 14 Oct 2024 03:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="hy9snmOa"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2069.outbound.protection.outlook.com [40.107.237.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44E8A231CA6;
	Mon, 14 Oct 2024 03:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728877026; cv=fail; b=ejZkNQ7HXO5MMAjxSta95CRwuoZfgWB3UGrThQb/LFAYEXIQJUCvSfOAinm+MJWoMENm5tKv923L+SSnezz4RTf+7abpUuVoySKz7K1RDhoJPe/91fW5x6nWIAM1uHuNJxzZf9LuruxMBJSzuDfPYtvSxplS4a6nrWuHEtHds90=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728877026; c=relaxed/simple;
	bh=z9fPLjkUD5bmkn9gqMjQUEJG8G7Fn37kQ3DgDZnJVbY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=hNNKBvkG6B9hP0g1JxRqdNFtWDtI13jGhoMsvv4E+eJRbV49rA8WltDMci2LBKtiqnzNLlrHmcUmEYJHm4ztsnHt80ZrEUsf02gtGwDk0aUqmnYrYWGz+pmw5HFZPrtu/lBTghvhQHrD8MdofvemCxHEoyeBM+3oHa4aswHTTos=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=hy9snmOa; arc=fail smtp.client-ip=40.107.237.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sWqcIJ+93iQvczqKvAk2xRViTOYICjiPGKPvDW8IMvR5uTs9zitYpUlW06pJX+AoJiPMHPDlW3ceyTP1XVUGW6sNCO0N/M24NjhFXjM9l0r7nmv8zE2vb6YVblvEDtCte3rDQbPqbIABFIBIn1IuTUtCmcrmmQ8aeb1taP0RusMEGXCf7Vmtvnb1SwvAbrYbmG1L5NCcEFJjeVI690b2Z1sWcNQIqnxLf3MGsWnbuI/idFK0/DxWVXECwP3VxJYaYAhV+FggQFFbghBJPslN5jzOyrUeFWXWQtd/0/evbVPASR+IrrzDFzD0QE73qmpw6XR8FPpjYDLq7x8ZGkh6TA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EcrViTubG9W2sblRoKThmVv/X3SNbdXVQxSD97Bw3bU=;
 b=X4wocc8MinLVH2ORGMTwTI7O5akdk+nr+WpJX0Lazwu3to+OU7akxwPJdg5XdTjE86F7IRQ7yYmRH5x1qKJZ7yUROObWeSQ1x70NCEG+x8Mp4Ypc8CPkVNOYg4IcD22xFXPVpLVeNUzqRkoYJAyNIqoPbc766XU02kPhjtDuQtCJxzKgpdaXypKw8TQ0t0kipnp3bSAHuSqBcl7sTk7+7Rt3VrnuFDEm83OgCWp7zphq2nDagbf6x7HF0uomZUcveeBoqlLD8pQDCRdSLxStVRObO1j8Hjy0sFDSegv70AzO1414pEsn+WoXzAj3rgh5l2L//KZEE8Vr0dh2KkfvYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EcrViTubG9W2sblRoKThmVv/X3SNbdXVQxSD97Bw3bU=;
 b=hy9snmOaEDPVEF8rDrf/d4l814gME95dRnI63wOMQZAOL74Q2ACLzdZWR5fzZdDd2RBJ/iFE2XCfMIQL0OUPt45HktPfcp0NlxLAwnBztjL958JaDZQn+U4xsf7VXa7KnuLphjhV2GWVUioOK5KoDPMPrJvCur/CJr9y/7IRl7Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 DS0PR12MB7926.namprd12.prod.outlook.com (2603:10b6:8:14a::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8048.21; Mon, 14 Oct 2024 03:37:01 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%4]) with mapi id 15.20.8048.017; Mon, 14 Oct 2024
 03:37:00 +0000
Message-ID: <9482e110-0837-d6e0-4f6c-a4b119da8c20@amd.com>
Date: Mon, 14 Oct 2024 09:06:58 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH v12 14/19] tsc: Use the GUEST_TSC_FREQ MSR for discovering
 TSC frequency
To: Tom Lendacky <thomas.lendacky@amd.com>, linux-kernel@vger.kernel.org,
 bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
Cc: mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
 pgonda@google.com, seanjc@google.com, pbonzini@redhat.com
References: <20241009092850.197575-1-nikunj@amd.com>
 <20241009092850.197575-15-nikunj@amd.com>
 <72407a44-fb70-52cd-a231-c80fd81e0fa3@amd.com>
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <72407a44-fb70-52cd-a231-c80fd81e0fa3@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0184.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:be::13) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|DS0PR12MB7926:EE_
X-MS-Office365-Filtering-Correlation-Id: 52513a99-5407-46e0-4615-08dcec017649
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aXgvUmdNYTJlUVJWYTlVS0RyWitCck5ZcTFDQ0FJZE9XbnI2V0xFai9zMmxC?=
 =?utf-8?B?Y21icnduSGtUUU1GNW8wd094a2U4V2R6QWRSaEh5VnozUGNjb3kzbUErMksy?=
 =?utf-8?B?QzdYaWtaZGNpMnEvMHlCbTN2aGdKMlRCbEcvUHVKMXBpNEpGTlBjRVJiSnVz?=
 =?utf-8?B?RGR2a2d3M0hIaUd4Y3lua2pSK241eHptYVR3ek1IeXRMSzRXQmdOd3lFR29V?=
 =?utf-8?B?SUJjSEp5M1ZSU3dkNWNtMHFKdG5RZHpTMTJSM1ZxVkZjNkd1a2NtNi9aaFph?=
 =?utf-8?B?WlNveFpaajhhemVrcmNZL2x4MisxRUlYbHdkZEdDUWcvdnVjbmswL0J1cFlY?=
 =?utf-8?B?YXRYVzBKK0F6WHdTcTF0NHovTEExMk1OaCtVS2NzNUFoSmx1VVozamxvSnJI?=
 =?utf-8?B?bXVSdWxNY242dXNGRm40Z2F3ZzYvYzNvVUxOWW14RXQzUzM4QXBHRTVyaUxQ?=
 =?utf-8?B?L3Y1SkFkRWUxZWtyNzJScHI3SmxBT2grVXpoaU1jMElnaFFKTXpYYXFOYU1W?=
 =?utf-8?B?dHR0bmo1UFJScFVDaTdDR24rUVk5RHNESS9YalN2emhqMW40Z2pYdlV6K09k?=
 =?utf-8?B?QnFaZWNlMWpkVXJNV2s0dGUyV1VsWDdBdGwvZ3F5ajhiZEI2NDNnUEFDdkgx?=
 =?utf-8?B?c2RtbVlhVEFCTmY1ZndIZzBtR3Zjd2lGTmNhSUIwRjhvS3RsUjJkUDZiVjR4?=
 =?utf-8?B?c253OGlFbS9PZDBNMkpvRmlrOWhjbGlIcC8rRVZ4WWxHQ3V2VXpLYWh1RUp3?=
 =?utf-8?B?YlhiL3JBa1VLdlc3OGNuNjdSMnBTTk4zS01hZHMrRDJwZElwZ3dDL2NkT2ZJ?=
 =?utf-8?B?b1IvS0NPOWFwUlFNTFZDLzVqb3diclVMcGp2Smo2ZGZsc0hnNzhzUnFRem5j?=
 =?utf-8?B?b09UVWt2ZTV0NUl4OXNsNURDZzNJSDRsYkpxQklYZGNrV1FVaXNhdWVDZ0tl?=
 =?utf-8?B?VUxjUVVqS1FiN0dwbjJMSGllMzZjSXRPWkROaWZYc3pPSDFjbHZ2cEQzR1Uy?=
 =?utf-8?B?dDl3VGlrM0lyQVRzN0xTd3BOeFZLUGF3cU0xaHFVNEZuTGpLOFIrbTJTNmlh?=
 =?utf-8?B?R3liKzhXOXhtRUxKM2YyekwwSC96TmJoNDFURXkxWUJvSndOVDZhTU9yaHI1?=
 =?utf-8?B?WURRVzhPUTNNL2ovbk56QnA2SFdYZm54eVk3aHZkVjVvV1E5dzhCUGphTTln?=
 =?utf-8?B?RmVMSXZHanFiTlhOUnVkSW8zRTBTd2NveDAxS1JHcGg2dFpYYXJqQks2Z1Nw?=
 =?utf-8?B?SUt6SDluN1luenU2aEp2SnhmaHRaUTUrWlBTbWFQZm9tYUpXemtRR0FLamZF?=
 =?utf-8?B?YjgwZ0MrQlIxWGVaMWFBRENSMy9JOWsxZGxvaitQWkFlM2hOYjc3b054L29L?=
 =?utf-8?B?YU1qMmZ0Z1Yyd1JUUDFBWHFGcUNvSVhxOEU3RWgvK2pXcWlab0FxMzFRRVA0?=
 =?utf-8?B?Y2ZHeDIrTVJmSTZ4OTI2Rm04RWozN09XZjluZXYvakZNLzRpWktJeEJsdjRP?=
 =?utf-8?B?NXJ5SmtKYlJpUFFwN1JPQWVUaXBRZGlVZ2VIajJLbVVFeWsxKy9ITDJBenQv?=
 =?utf-8?B?Y1NsR1F6Zk1jcSs2YzdQaEhBQUxrN1pvL1VMOWJXMlFtQmJPZFR6ZUg2OElD?=
 =?utf-8?B?bURvT1dYMDhWSWh1a0QrajVIOC9TM2gyV2R3Q2hkUTJUOUFteTFOZDIwemJt?=
 =?utf-8?B?SEpBVzdabWN0TE1ob0RwSWpabUJYbkFDbyt4OHZUNkVBYUcxckU0YndnPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Q2FndUpscVFSaC9FMzNJUGdMUHFyMnEzN1ZValZBdEY2cGpzS1pQdlpxa3Bl?=
 =?utf-8?B?eXRKSHZPWi9xZlVrZjEyWEVwSTBwK2IwSGEzekRqdjBCMXFlbXFOd2x6NEE0?=
 =?utf-8?B?SngzRURCQ2orcG13Rk1ZbzlSQTBoUkMvNUhhMTg4ZEdsTUlnOTNoNGhZZ2pG?=
 =?utf-8?B?YkZxTWpkaGxHS0FnbytVaFRIVk9vQWNqWXozRVBIbnNBYWo2S2prMUoyUzRT?=
 =?utf-8?B?T3NqZDF0ZjNmUGloRUNIT1doSE9HeHNvS0JBVEhiLzU3RmtwQzh4S2tPMWcw?=
 =?utf-8?B?NE1vUmNXeE80amhZMG9Ka0JXVUFyS1IwSkRoSGlsaFczbW1VYit2T0NhZjI0?=
 =?utf-8?B?VUNEanMwMmxCdzJZR25sbmY4Tm9lVEdoaGZFa3lMKzJVYVZ6eWtEaGd6WEoz?=
 =?utf-8?B?ciszNUxPMTVHbVFUUnlBTjdYbGJaWTBpWW82VnZCbW91T2FucGpnb2RzNHFU?=
 =?utf-8?B?UHR6TldrRUh2RHRwcnU2N1FYQm0zaUFaR3NncmxuV01SNHNBM0xaSXdHOHFJ?=
 =?utf-8?B?Sjg5MitXNHVYZXhFWWJQRUR6ZUdFUlF6MWdwTFczMklPSGxTRkRXTGhhRGJW?=
 =?utf-8?B?bGpGQ1ExRVpxczBsSWlsMitDSkJReDR2OUlqRWtGQkttOHFieDRReEJ4eDhX?=
 =?utf-8?B?cVNjRG9TQnc2Y2I4L24zUlViU2RJU0thTFd6SkpKdlR6dUxPbXMyY3NQZkc1?=
 =?utf-8?B?dDRUL0xtUndpc01UdnExN050UktBRGovMzRnVEtlc2gvalZJTW5pSmFDSjdV?=
 =?utf-8?B?SnNiMnJSdUx1d29VSDZKbGM2bjBraXhNYXRzZHl2UHhXTDlEZVF3RDlhMldK?=
 =?utf-8?B?b3VvbXNCWnlPQ2N5S3R5LzhBdG5STWVjTHB4cTZSTjd6dEdpUVVHOG9uL1I2?=
 =?utf-8?B?UExUTDJlNFRyOUdCZ3ltM2YvM0I2L29KeVU0QUpvc24wTFpiekd5U0UrcjRM?=
 =?utf-8?B?SnFvZEFjTWk0dnN0bHdVTFBMRjhqdjdNSGpKZWh1K3Uzb2pqVzlrZXBpbkh6?=
 =?utf-8?B?SjQ4YUxrN1ZRdzJnTngrTDZOMGlNMlBocjl6QWZRSTN3ZU95UTJ5VndMVU5H?=
 =?utf-8?B?Y20zU0ZpL09yN1ArQWtla3RhYys4T09zekl2emZJaGVnYlorT1ZRSVd0anpP?=
 =?utf-8?B?SzdaZGNEeXM3T1hCcHkydERDNkFoQ3dpSFc2RFlrZjJHZ29JelhuSlhoeWVh?=
 =?utf-8?B?alI5RXRxcC9vU1VLZE0vTEM5MFRQQUJucnUrb0ErdHhxRGdpSzI5WGxaeHV1?=
 =?utf-8?B?RjBZekZyeVkvUFdldTFkWG9lb3dXbVN2aVBiNFZlV0orZjd1aFRsbHhtblJ1?=
 =?utf-8?B?S09qdSszL1JzY0ZOdEFXSkdxWFJuODBVMDFWRUJIMFVONHVaa1RibklCZXFR?=
 =?utf-8?B?MHBjenRqcG1Qcm1sL3JuVEFETmFiL3kwVDc2TUlTYW1mbnpXRERnOUhGbnBF?=
 =?utf-8?B?QkNaQ3hxKzQya2N0bkxZc2tqTGNZU00rTTZXOUsyL2owb0dRQ2JxYzdJeWpy?=
 =?utf-8?B?cEtpcHhKaFg0MVBycG81RlV4RlE2NFNhOE9MY1hUQ3lxRlMwWTdwQnFZNGp2?=
 =?utf-8?B?NU9oZUN5TjY2aEtEb3BNWmpFNEhJQ3Q2SnIyTHhpMWZmVkxnTm5URmw5ZmdH?=
 =?utf-8?B?WWlRQ2VpVEhWY1FmQzhpZG16a3I3WGFwdk5MTkowbWxqYlJUK0E3azg1WUx0?=
 =?utf-8?B?bWk3djUwSUcwbVc1ZnRKaDBmWmxZTWJvWFhNeGpBMUFtVDBnWDEwRkpIVTFB?=
 =?utf-8?B?UXZidlFYMEFBZXhBZ21zWFpDQ1V0UEVJbnlXRTBOaWVIQWVTOHYrSlVsZzVW?=
 =?utf-8?B?S3dDQjRDTjVDbm5naGc2a3VCZTlUb2RJVElnVkYvSkJ0TlJTTVhkUXNEdjBJ?=
 =?utf-8?B?UTIvVDByeDUwSHdwOVBldm94cjA4cEZ2OWNIVy9Ma1pLeVhBejQ4TzlFWXN6?=
 =?utf-8?B?NXNWdFhRaDRlZ05DQm9kTUdDbDdqVndiZWRUSVJjZFZMTkpvOXlNODZMdlhm?=
 =?utf-8?B?MENPMDA4TzFEbmh6NHVTalcrMXhEV2J4cEN3NWRPZGxGU0JXZHZrc2pyZXZw?=
 =?utf-8?B?T2djT1Ard0RNTEsxakdXWHJRSTMxcGxkT0Y3VjNnUks5Y042bTFKOUxqWjdy?=
 =?utf-8?Q?IfUUnbhD+eQUxMBkaQw5smRfH?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52513a99-5407-46e0-4615-08dcec017649
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2024 03:37:00.6958
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L3lSSrCw4nKPm14kBU/lEZ1GphwTHJf+tkYwjYO8gcgl+AMfxKYFW6IGxO0aQ/AxC5YX8KW2a6R2nPrfWgP+Vw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7926

Hi Tom,

On 10/11/2024 1:09 AM, Tom Lendacky wrote:
> On 10/9/24 04:28, Nikunj A Dadhania wrote:
>> Calibrating the TSC frequency using the kvmclock is not correct for
>> SecureTSC enabled guests. Use the platform provided TSC frequency via the
>> GUEST_TSC_FREQ MSR (C001_0134h).
>>
>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
>> ---
>>  arch/x86/include/asm/msr-index.h |  1 +
>>  arch/x86/include/asm/sev.h       |  2 ++
>>  arch/x86/coco/sev/core.c         | 16 ++++++++++++++++
>>  arch/x86/kernel/tsc.c            |  5 +++++
>>  4 files changed, 24 insertions(+)

 
>> diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
>> index 5f555f905fad..ef0def203b3f 100644
>> --- a/arch/x86/coco/sev/core.c
>> +++ b/arch/x86/coco/sev/core.c
>> @@ -3100,3 +3100,19 @@ void __init snp_secure_tsc_prepare(void)
>>  
>>  	pr_debug("SecureTSC enabled");
>>  }
>> +
>> +static unsigned long securetsc_get_tsc_khz(void)
>> +{
>> +	unsigned long long tsc_freq_mhz;
>> +
>> +	setup_force_cpu_cap(X86_FEATURE_TSC_KNOWN_FREQ);
>> +	rdmsrl(MSR_AMD64_GUEST_TSC_FREQ, tsc_freq_mhz);
> 
> So this MSR can be intercepted by the hypervisor. You'll need to add
> code in the #VC handler that checks if an MSR access is for
> MSR_AMD64_GUEST_TSC_FREQ and Secure TSC is active, then the hypervisor
> is not cooperating and you should terminate the guest.

Yes, will add this in my next revision.

Regards
Nikunj

