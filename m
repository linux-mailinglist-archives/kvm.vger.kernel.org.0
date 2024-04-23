Return-Path: <kvm+bounces-15605-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C8A338ADCE9
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 06:44:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 017CB1C219BF
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 04:44:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88F7C1F5FF;
	Tue, 23 Apr 2024 04:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="PSa0qZNj"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2048.outbound.protection.outlook.com [40.107.223.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C1281B813;
	Tue, 23 Apr 2024 04:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713847464; cv=fail; b=STxNoF3TngQeyF57WLPIE1nT3pyySDhNoehKI4apkTgnUljt3qPgfwdhftEnc1ppUMZqZ0T4s9f2c+vEIewZbLczuEbPu81SaLU3NtjUyYmJY2xsT0bc/PkROGurzCR1vqbPR2eD6BrZ2nqqAHsxHS1+CvLaQJYY0OyjSH4Lh+g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713847464; c=relaxed/simple;
	bh=0WQVGnX9rcG+lISlUdPi34vnrULHDcEj5K0rolNdx50=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Pv73fQwN6VXffHHTbKzBbN9eJ9dWlNG+1I8CfBe51dIJThUw3IDrRB5i3nfNltj1Q+fQH0uShktJB4C1RPyw9DUjrF4/pmTPcvd9CEJC/QBZCI5bY3CdHmMsiB6VCBgyMZlAVHLiLPQaaSYHFK07BvoFDgV9Wyd6A1dGrXvKjmU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=PSa0qZNj; arc=fail smtp.client-ip=40.107.223.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gq6K+kSMtZftrl2yJR90ohLnmizlsTVnZ1/0BLfgAKArym1S6rDHmB1HduqErN4aFQOh9fuXtNBWZ1/dyl2S811uV1vPu9P83iXjve7WJmZgoUMSOK8RHuwBZCIj6plpsd99gzww5/KRWsMtgNz9K0MEhO83uraQlHw60DeYSTRLgkR27EhB8TsqzvYlksXLuWNCBZrhaDtnEMUN2erHAEH2A8IyFPXfvDv90jscrFYzXpblS9Jp2yzt2qOTuCS6LqG/mOi4zXX8a1TDRpU33kPJRmgK7nyzhLPHFUPP1eVepYqgsB5Bs7IcDjjJks6I4LVm2j2DKEFI7OapUA5dKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uMiIPvTSiEQAqHc9p6gkH85jPtlXI4PYxh8FkreKWiM=;
 b=YhF1RXi5JiBHlFpMBuqTnNrifs1VCtFzPsEQuX/qC6LV2lTo6PaMEnfhjsChbWEPeH/KivK/HbdRsvueIBZaX4Zq6nwkHmREE8aDPBrWSba4ZMOWYCHQvWb2/u5UesHwmYRaW2TOjKx49+SDVRqsYHrLNDa3mI7MN9whTiVIT1nW3T+YPv+Ucc5UVQGJLG87sAEfOEWAvXjbg6w8PfxQMpg/9RTPplZlLjxJY3v854nNX59AfQPmlvuen04FRBIu7T7TI7jIJYqQJ9Dk7Q+YvVeU6uswUnDnsY1N9cYitbf72FiK9I7QwBJwVIKMtS3V4ktEsf/5ETbCVZ7hLfz4pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uMiIPvTSiEQAqHc9p6gkH85jPtlXI4PYxh8FkreKWiM=;
 b=PSa0qZNj4dUa1pi141OhFd3j+ttS2ZqR9GRYrD5ujtQNxITtVtbUInM8cPri6fwMaCYjjziO0wd6JcsfBCMMAH1XSEt+dzQSh84LMvYCb7X2XkOp5CYWuIBkHtYH8xYprv3KnVq3+o8+SQeJArI/VjKEgQb2caMwf0tqxzSsYzc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 MW4PR12MB6924.namprd12.prod.outlook.com (2603:10b6:303:207::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Tue, 23 Apr
 2024 04:44:20 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%4]) with mapi id 15.20.7472.044; Tue, 23 Apr 2024
 04:44:20 +0000
Message-ID: <e394360a-85c0-4d6f-a0e1-dff466f572f9@amd.com>
Date: Tue, 23 Apr 2024 10:14:08 +0530
User-Agent: Mozilla Thunderbird
Reply-To: nikunj@amd.com
Subject: Re: [PATCH v8 10/16] x86/sev: Add Secure TSC support for SNP guests
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
 kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
 pbonzini@redhat.com
References: <20240215113128.275608-1-nikunj@amd.com>
 <20240215113128.275608-11-nikunj@amd.com>
 <20240422135019.GDZiZrG0sKpq0fXQ8d@fat_crate.local>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20240422135019.GDZiZrG0sKpq0fXQ8d@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0115.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:27::30) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|MW4PR12MB6924:EE_
X-MS-Office365-Filtering-Correlation-Id: e814d1eb-863f-4acf-0812-08dc63500a6a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?R01yWjRPWmRKZWdTWERqbnI2VXZVWExFWFVzU0xSN0daNlRKTHAwSWpaUyta?=
 =?utf-8?B?ZEFtU1BRa2xmVEN4eWlMZU1naStmWm82N09tby9xNmcxZ3dHNXRSY3hLeGlq?=
 =?utf-8?B?Lzd6UmlLUjQxeFhOQzJEVmZIWTY0WVhNdjBRUkZENXgzQW5oUVNFa1B5TitN?=
 =?utf-8?B?WTNPN3BtZ3FTSG96TzdWako4WVYwQlZudUFFWUR5eHNoTDJtbkRGTHA4QVdp?=
 =?utf-8?B?MGlwWVQ2MDBsY3dycENGQ1BCYlVEWFhEdVhKTzBpKzdhem1VdXAzc0h1czZF?=
 =?utf-8?B?WWhTdnJ5STRqVGpxZVA0S1FvVmJuNkFGVzhBRjBFK2NUZ3ZxOVdtVDk5SmUz?=
 =?utf-8?B?Nzdwb3ZTMVRxNjliQ2RTWWd4STdseXk4VTM2OVZab1UrZGh3UnFIemFQb2do?=
 =?utf-8?B?YXlsWGZ4ZWVCSHFGeTVYTjRDTXp1U1lpOHMrUVl2aDlPOUhqZVZ5RDVXTkY2?=
 =?utf-8?B?VGJ4aXV1MmNTRFhsN2JxbkRHdEQ5RjBKcnNPcm8weXR1VTNMLzM3bE1oOW50?=
 =?utf-8?B?RUZ2MlhWRXcvV0U3ZTZyRFZwNTJPRzJyRWFHNE5ubHl2ZFlYMXZGeGd5SFZE?=
 =?utf-8?B?dkZKbkZValhOVGdnbUVjeFBhQ3JJMmFmU0tjb0FkeTRvRkFpVmJFdGxGaW40?=
 =?utf-8?B?Z1NlL2RlNW44MDFkem5rS29oTndCbUhGZksyZXJ3OURDTlcya0JNb2paWEZR?=
 =?utf-8?B?Z09Jc0hLZ05Xd2dWSGtSMUFOajlvckFCS3hidlpzOUhFdW9EMXB1RTQwcHN6?=
 =?utf-8?B?UkZCdGJYTDdaUW40ZjROQ2VGVUw1YTg3Mlovc3dnallnWDhmMzZlZXNtaTFk?=
 =?utf-8?B?RVhGS2lLQTNuQnNYTkRXRUsxVnpDN0RENmlXQllsVzdUUm1vZzd6QlpYZDJH?=
 =?utf-8?B?ZWJKZ3VJNThON0FsNDgyNzBMZWtGcW9EWlk1bkM3K0U2QXVtaE9veVZNS094?=
 =?utf-8?B?MnJZWWRyM1BNYURoNVNvREdiSVNqWmFwT0VLNkErVVdwejRud0M3WW5QcnlG?=
 =?utf-8?B?akZQcTlhK2UvdmpmdHR5djFYcDE1T1NtdXR2UHNZaC9ZV0UxZ01CbElIZG5w?=
 =?utf-8?B?SXh2QU81ekUzNFdnZVFoWEFSK3NZdXZsZ2srZ1pFOGtidEVkQVpuUlQ4KzhJ?=
 =?utf-8?B?bEZuL0ZWVzJVcDhURFRUWVBaM2RzUlBwbUJidUVzaXNRTnJmVFRETENhUENR?=
 =?utf-8?B?ZzJlMFEvdlpYUFFpNXF4dGRBYWdZK2FTenlBbDU5ZUxLaFZ3cS9ZcVlBa0hO?=
 =?utf-8?B?Mk04MGk4cmd6Ti8zY1BscnY5UHF4elZTVVN0YWs4SWphNFV1a1NDRXVaNGVw?=
 =?utf-8?B?VGFNN1hoNDF6Y2dCWVZJN1F0SnhxQ1UvL0plVnBlMnNZT2FNSlE0UGw4MHZi?=
 =?utf-8?B?ZUpKc1VFajRaaDFtakRKWUVITytYM1ZLQXoyMDQ1SmR3SUNRazR1WncxUzYy?=
 =?utf-8?B?cVl3ejE2ejRKLzZvVUY1TytPank5R0ZtNGVaRHZNYldEbU5qbUxrZTRDdWpC?=
 =?utf-8?B?TFc1and6ZEhWNER3NG5sbDc1OUZveDJXSjQ1WlZtZXUwY0dKenhwM1c5TG96?=
 =?utf-8?B?dWxBV2ZtM1BMMXVHN0hka1ErYVZrSUpCVEgwVWhER3AwcnorTEE3UVJBYnFp?=
 =?utf-8?B?eUhyWVBaaWIvTTZFWm1zMjg5SWxpaGFrRjJiTEJiMDRnOXpWV3ZiY0NjTDY2?=
 =?utf-8?B?NjdVUW9ERDVHd0d1czh2YllnQmpBemF6cFRwdVFvV1Q5VDNveGF0NlFRPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(7416005)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?c3hnRXY3NG9UeFNDam84ZUNFTEJhcE9tTDZjeGdkcG5LYlNFQllQYU4vNmw4?=
 =?utf-8?B?cWVXZXE3SFpMTGNFUE5oNnpzQ0J5b1RxZDNOVjgzMW41Y1JESnFDMzU2UEpj?=
 =?utf-8?B?Z28vcjFsQ3pVaTF2TkRUMllYNmZ0WE1RLzkwYXBOUVMxVWJIU0Z2cDd0Nzd1?=
 =?utf-8?B?aTNEUXhUK3Qvd1YzT1AwdmFnMlpmSmZTcW5kbU12MFYrVFRLRXB6TDN2NkJ4?=
 =?utf-8?B?R0RDMURRdnR4VHpta1NKMlpqZlVTVXNtWG9iTEdObmwzNkhxV3FGNWZ2c0xN?=
 =?utf-8?B?b0E1TXNWTTkzT3lrQkJkalRYK2JVUk9YV2M1bjRoOWYyOUlRY0FHbk1Cbzg1?=
 =?utf-8?B?Z1lCQWZTZXUxbERvdG1VeHBDbTl5VXFQWjQxcFFOTTU3SWFwUitkQU5OVjhY?=
 =?utf-8?B?cGJzVUc3S0xXNkpObFBQZXVGRTV1WUNHVW4yRTUwZllIZ1lLRWU3TmhaSlZX?=
 =?utf-8?B?U3NNZTZzUG83QkthUXZZTFBzUDhDclI4Z3E5bml3ZGt5dUlkdU9UaTNKbi9Z?=
 =?utf-8?B?RTNsc1BFRmhmWWxhM2QwMHFlRHNseWhNNlFzY2xKcjNSYTZHQXpXcERBdXAx?=
 =?utf-8?B?VzJJSldwWUlGdElxTG5WK2svWDVnQmlMdzg0d1dlZTJwNFlhcERjc0J6UjVq?=
 =?utf-8?B?MUtiSUNXV3FjZG01RFJPZEllN1lWVFBMT3dpd1RoQjFzbnk1UGxQQTNOcVNl?=
 =?utf-8?B?aUY4a0VYMmdaQmV2S2FFUVNnR29Oc3VKWlpTMXBRL2hTUHJJbDh1L21uaTR4?=
 =?utf-8?B?NVI4Z0FMK2ZrUnlnQUdqQ0o4Y1ozYU9OZWdRV0NEL3F1bWZZdUhUN1RZN2cv?=
 =?utf-8?B?Um9KcG1KOG0xVExyZW80Yy85Y0IveGZRWTFUNEh3THdPRXZxQlRzam1YNjZH?=
 =?utf-8?B?dHBEVndzQ1VVTWNvUFVaWlYwbE85MDhMNUltcmhOdVhkdXQ0MDgzYng0Ly9Q?=
 =?utf-8?B?MEhLRWRzaFhFV1UwdTNkUWVtZjhXa2NkR251dEE1WnhhdklqQnZWMXJpNm1r?=
 =?utf-8?B?UWx4L2hqK2NVNHNBMVZHRXJIekVHY2M5OU0rZVA0cTZPNmZWVU5IeWNjMzln?=
 =?utf-8?B?L0pzeUhMQnRKaU9qSVdSYm5BWTVCamYwcXNZUFcyTlFkOFdUOHY1b0RrR29X?=
 =?utf-8?B?YkFBOXZEM3AyZ3AyT2ZUeHIvekdOYWlIa201bzVSZHNWeUNHOGdlak9HMmJy?=
 =?utf-8?B?ZFZ3L2JQNXl3NXNXWElaMGFnMHpTM2lsR0lUSHp2b1U2VFBSK0Jtc1NJanR5?=
 =?utf-8?B?Q3RoNVJ0NnZDellEcEdwUENaSUpCZG9wQjRjUHRHUzNTbXlrWnRrckRYL2d4?=
 =?utf-8?B?SzVFRHFEYm9iSm5DSkhFdjNXWXRWN2MzTkRhRFBnQzA4NTJxOGFHNXI3cnFC?=
 =?utf-8?B?bjEyVDRLTGNmN3VCUTIxM1JrRWlYM25Qc2Z0RWVBNWwwN1F0NTZnVEI0OEFz?=
 =?utf-8?B?Q1BRc3RTNUYwVUhIK3dTSW5YMjFoTGdMMU9wdUdDZXZCbDdBZ2pUcm0yWGRz?=
 =?utf-8?B?NG4zaC9qYXlXblh2cCs5TFpOVGlDRmR5KzhvM09CNWhYSTg4NUJ5VlVTRkpa?=
 =?utf-8?B?YlRKR0hWeXRqR0Q5bk1qa3J1Skh6cnU5RHcrajlyaG5BS2t5U1B4bUJEdlNP?=
 =?utf-8?B?SjlPaFJzTHhIMlBHRmIyZ0xzUU1hM20xN2wwZ0xqRzYyWFBDaDR1ZE4zQUQw?=
 =?utf-8?B?cUJYanhGbFJ3aCt2RmVKRmk2T0FBdnFpVWVFbGluOWNxeE9YL2ZDWDQ1ZGQw?=
 =?utf-8?B?L2tZK3lCd2JUTXhZMmM3dXJWR1VwOVBvVzBabEg4TXI2dDlJMEljZm0vanhp?=
 =?utf-8?B?VkJkeXpNNFdRenlCbjZNT3ZUbEU0R3c3SWRnR3kvL3kveFRYK1E5ejI3R3dP?=
 =?utf-8?B?U1VwOERCbVR1N0h6UlVmTXgzSnYvbmJ5TEdqZEtsMmFoWTVrY3QxRkVlaVBD?=
 =?utf-8?B?WFZmYTl0eU5sWDd4RndSVHM2ckphOUNaVHZ0dDN1a0FVYko0bFpZejUyOEJv?=
 =?utf-8?B?UE8vVS8zOHdUVGk5dmlpV1lYWGg0Y2ZvREMzZXRKb2ZRYXc4SnlZYmJlNHV3?=
 =?utf-8?B?aXBTeVk5dXA2dzhHbjE0MnZpSHBlQ21PeHZSZ0VNdFMwY3ZoY3B0MG83MGF2?=
 =?utf-8?Q?yS2Em1WTsLZtwcwKkv7rD1x2J?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e814d1eb-863f-4acf-0812-08dc63500a6a
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2024 04:44:20.3853
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KbCegqfkNem4KoO9LuWbpUALoxIRMLs4IUT4Lk6owXc9SNmU69fgntlyQCvvU6RkiS9rfMxLCmLJaGsITlvw/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6924

On 4/22/2024 7:20 PM, Borislav Petkov wrote:
> On Thu, Feb 15, 2024 at 05:01:22PM +0530, Nikunj A Dadhania wrote:
>> Add support for Secure TSC in SNP enabled guests. Secure TSC allows
>> guest to securely use RDTSC/RDTSCP instructions as the parameters
>> being used cannot be changed by hypervisor once the guest is launched.
>>
>> During the boot-up of the secondary cpus, SecureTSC enabled guests
> 
> "CPUs"

Sure

>> need to query TSC info from AMD Security Processor. This communication
>> channel is encrypted between the AMD Security Processor and the guest,
>> the hypervisor is just the conduit to deliver the guest messages to
>> the AMD Security Processor. Each message is protected with an
>> AEAD (AES-256 GCM). Use minimal AES GCM library to encrypt/decrypt SNP
>> Guest messages to communicate with the PSP.
>>
>> Use the guest enc_init hook to fetch SNP TSC info from the AMD Security
>> Processor and initialize the snp_tsc_scale and snp_tsc_offset. During
>> secondary CPU initialization set VMSA fields GUEST_TSC_SCALE (offset 2F0h)
>> and GUEST_TSC_OFFSET(offset 2F8h) with snp_tsc_scale and snp_tsc_offset
>> respectively.
>>
>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
>> Tested-by: Peter Gonda <pgonda@google.com>
>> ---
>>  arch/x86/include/asm/sev-common.h |   1 +
>>  arch/x86/include/asm/sev.h        |  23 +++++++
>>  arch/x86/include/asm/svm.h        |   6 +-
>>  arch/x86/kernel/sev.c             | 107 ++++++++++++++++++++++++++++--
>>  arch/x86/mm/mem_encrypt_amd.c     |   6 ++
>>  5 files changed, 134 insertions(+), 9 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
>> index b463fcbd4b90..6adc8e27feeb 100644
>> --- a/arch/x86/include/asm/sev-common.h
>> +++ b/arch/x86/include/asm/sev-common.h
>> @@ -159,6 +159,7 @@ struct snp_psc_desc {
>>  #define GHCB_TERM_NOT_VMPL0		3	/* SNP guest is not running at VMPL-0 */
>>  #define GHCB_TERM_CPUID			4	/* CPUID-validation failure */
>>  #define GHCB_TERM_CPUID_HV		5	/* CPUID failure during hypervisor fallback */
>> +#define GHCB_TERM_SECURE_TSC		6	/* Secure TSC initialization failed */
>>  
>>  #define GHCB_RESP_CODE(v)		((v) & GHCB_MSR_INFO_MASK)
>>  
>> diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
>> index d950a3ac5694..16bf5afa7731 100644
>> --- a/arch/x86/include/asm/sev.h
>> +++ b/arch/x86/include/asm/sev.h
>> @@ -170,6 +170,8 @@ enum msg_type {
>>  	SNP_MSG_ABSORB_RSP,
>>  	SNP_MSG_VMRK_REQ,
>>  	SNP_MSG_VMRK_RSP,
> 
> <-- Pls leave an empty newline here to denote that there's a hole in the
> define numbers. Alternatively, you can add the missing ones too.

I will add empty line.

>> +	SNP_MSG_TSC_INFO_REQ = 17,
>> +	SNP_MSG_TSC_INFO_RSP,
>>  
>>  	SNP_MSG_TYPE_MAX
>>  };
>> @@ -214,6 +216,23 @@ struct sev_guest_platform_data {
>>  	struct snp_req_data input;
>>  };
>>  
>> +#define SNP_TSC_INFO_REQ_SZ 128
>> +
>> +struct snp_tsc_info_req {
>> +	/* Must be zero filled */
> 
> Instead of adding a comment which people might very likely miss, add
> a check for that array to warn when it is not zeroed.

Sure.

> 
>> +	u8 rsvd[SNP_TSC_INFO_REQ_SZ];
>> +} __packed;
>> +
>> +struct snp_tsc_info_resp {
>> +	/* Status of TSC_INFO message */
> 
> The other struct members don't need a comment?

Sure.

>> +	u32 status;
>> +	u32 rsvd1;
>> +	u64 tsc_scale;
>> +	u64 tsc_offset;
>> +	u32 tsc_factor;
>> +	u8 rsvd2[100];
>> +} __packed;
>> +
>>  struct snp_guest_dev {
>>  	struct device *dev;
>>  	struct miscdevice misc;
>> @@ -233,6 +252,7 @@ struct snp_guest_dev {
>>  		struct snp_report_req report;
>>  		struct snp_derived_key_req derived_key;
>>  		struct snp_ext_report_req ext_report;
>> +		struct snp_tsc_info_req tsc_info;
>>  	} req;
>>  	unsigned int vmpck_id;
>>  };
>> @@ -370,6 +390,8 @@ static inline void *alloc_shared_pages(size_t sz)
>>  
>>  	return page_address(page);
>>  }
>> +
>> +void __init snp_secure_tsc_prepare(void);
>>  #else
>>  static inline void sev_es_ist_enter(struct pt_regs *regs) { }
>>  static inline void sev_es_ist_exit(void) { }
>> @@ -404,6 +426,7 @@ static inline int snp_send_guest_request(struct snp_guest_dev *dev, struct snp_g
>>  					 struct snp_guest_request_ioctl *rio) { return 0; }
>>  static inline void free_shared_pages(void *buf, size_t sz) { }
>>  static inline void *alloc_shared_pages(size_t sz) { return NULL; }
>> +static inline void __init snp_secure_tsc_prepare(void) { }
>>  #endif
>>  
>>  #ifdef CONFIG_KVM_AMD_SEV
>> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
>> index 87a7b917d30e..3a8294bbd109 100644
>> --- a/arch/x86/include/asm/svm.h
>> +++ b/arch/x86/include/asm/svm.h
>> @@ -410,7 +410,9 @@ struct sev_es_save_area {
>>  	u8 reserved_0x298[80];
>>  	u32 pkru;
>>  	u32 tsc_aux;
>> -	u8 reserved_0x2f0[24];
>> +	u64 tsc_scale;
>> +	u64 tsc_offset;
>> +	u8 reserved_0x300[8];
>>  	u64 rcx;
>>  	u64 rdx;
>>  	u64 rbx;
>> @@ -542,7 +544,7 @@ static inline void __unused_size_checks(void)
>>  	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x1c0);
>>  	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x248);
>>  	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x298);
>> -	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x2f0);
>> +	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x300);
>>  	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x320);
>>  	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x380);
>>  	BUILD_BUG_RESERVED_OFFSET(sev_es_save_area, 0x3f0);
>> diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
>> index a9c1efd6d4e3..20a1e50b7638 100644
>> --- a/arch/x86/kernel/sev.c
>> +++ b/arch/x86/kernel/sev.c
>> @@ -75,6 +75,10 @@ static u64 sev_hv_features __ro_after_init;
>>  /* Secrets page physical address from the CC blob */
>>  static u64 secrets_pa __ro_after_init;
>>  
>> +/* Secure TSC values read using TSC_INFO SNP Guest request */
>> +static u64 snp_tsc_scale __ro_after_init;
>> +static u64 snp_tsc_offset __ro_after_init;
>> +
>>  /* #VC handler runtime per-CPU data */
>>  struct sev_es_runtime_data {
>>  	struct ghcb ghcb_page;
>> @@ -956,6 +960,83 @@ void snp_guest_cmd_unlock(void)
>>  }
>>  EXPORT_SYMBOL_GPL(snp_guest_cmd_unlock);
>>  
>> +static struct snp_guest_dev tsc_snp_dev __initdata;
>> +
>> +static int __snp_send_guest_request(struct snp_guest_dev *snp_dev, struct snp_guest_req *req,
>> +				    struct snp_guest_request_ioctl *rio);
>> +
> 
> Pls design your code without the need for a forward declaration.

Sure

> 
>> +static int __init snp_get_tsc_info(void)
>> +{
>> +	struct snp_tsc_info_req *tsc_req = &tsc_snp_dev.req.tsc_info;
>> +	static u8 buf[SNP_TSC_INFO_REQ_SZ + AUTHTAG_LEN];
>> +	struct snp_guest_request_ioctl rio;
>> +	struct snp_tsc_info_resp tsc_resp;
>> +	struct snp_guest_req req;
>> +	int rc, resp_len;
>> +
>> +	/*
>> +	 * The intermediate response buffer is used while decrypting the
>> +	 * response payload. Make sure that it has enough space to cover the
>> +	 * authtag.
>> +	 */
>> +	resp_len = sizeof(tsc_resp) + AUTHTAG_LEN;
>> +	if (sizeof(buf) < resp_len)
>> +		return -EINVAL;
> 
> Huh, those both are static buffers. Such checks are done with
> BUILD_BUG_ON.

Ok

> 
>> +	memset(tsc_req, 0, sizeof(*tsc_req));
>> +	memset(&req, 0, sizeof(req));
>> +	memset(&rio, 0, sizeof(rio));
>> +	memset(buf, 0, sizeof(buf));
>> +
>> +	if (!snp_assign_vmpck(&tsc_snp_dev, 0))
>> +		return -EINVAL;
> 
> Do that before the memsetting.
> 

Sure

>> +
>> +	/* Initialize the PSP channel to send snp messages */
>> +	rc = snp_setup_psp_messaging(&tsc_snp_dev);
>> +	if (rc)
>> +		return rc;
>> +
>> +	req.msg_version = MSG_HDR_VER;
>> +	req.msg_type = SNP_MSG_TSC_INFO_REQ;
>> +	req.vmpck_id = tsc_snp_dev.vmpck_id;
>> +	req.req_buf = tsc_req;
>> +	req.req_sz = sizeof(*tsc_req);
>> +	req.resp_buf = buf;
>> +	req.resp_sz = resp_len;
>> +	req.exit_code = SVM_VMGEXIT_GUEST_REQUEST;
>> +
>> +	rc = __snp_send_guest_request(&tsc_snp_dev, &req, &rio);
> 
> The changes to *snp_send_guest_request are unrelated to the secure TSC
> enablement. Pls do them in a pre-patch.

Sure

> 
> Ok, I'm going to stop here and give you a chance to work in all the
> review feedback and send a new revision.

Thank you for detailed review/feedback, will address them and send new revision.

Regards
Nikunj


