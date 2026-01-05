Return-Path: <kvm+bounces-67007-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B7118CF2196
	for <lists+kvm@lfdr.de>; Mon, 05 Jan 2026 07:49:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 3460C3009139
	for <lists+kvm@lfdr.de>; Mon,  5 Jan 2026 06:49:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 179C4292938;
	Mon,  5 Jan 2026 06:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ri22uOM/"
X-Original-To: kvm@vger.kernel.org
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010013.outbound.protection.outlook.com [52.101.85.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7D92221290
	for <kvm@vger.kernel.org>; Mon,  5 Jan 2026 06:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767595761; cv=fail; b=OmNCqpNpvkfbrg1jLgIPP97jSeb343D0hKmWXYSft9eafMMA5hLOyp1/9nsOEYL7RZFNugJeFkrI1MaHPoyVLJBY3oJTNADBI4E/LojzEBJNrg/vPleJKHs9eqi02gMQOgH1MaY6xgYLTlCqFkjkwweN/sKJYys0hmFr7WhbKMw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767595761; c=relaxed/simple;
	bh=gPk1W/o1UrUKjJfQ27FnXIy7WBcL+voU/U+3wNc/evI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qT/namKnVezfT8BFGOZ0uIJpK1FMGrpwGIpaDBqSMhw/DDxLHGmomtssupxq8AOjOsait2yD77e3EoUn2OvfgXwyeRgfdndRi6HCUSPicCKDpylAS4POJOxxSRXUqVmyp7XVAMYArgI7o5cyk07xPH10Uu66sBLlyueZxssFhw0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ri22uOM/; arc=fail smtp.client-ip=52.101.85.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kdBlFdletuust1hI62DjPvukr+meksVNRRcIwlPvUvyAhpZI7Ov/piYwuT+o22k1VnGFF5nPhBq1XI8NphBvaY6QmPGjdbmrmmBGpKquaJXTqvc3SxYH58ieMm2LqCoPXHwIlLPrDlRqJHw/PQgAT0+pDDd7czY6wtQagfhJG6i0lcxWNmXrAgb2KtNkwASyJxj/TYndFktXddGT3INH5l2xkyFWuO1cBvP6TD7mfBhpoF9HSG+Asa2JddUKnNYpeJ/XrPwg+Xvq3LN9g11PsRMpjyh2NLNbMVUNbutiwbeSZZ27rBNR3HJTVAsRJVgFL7mKyEtJzReIoVBsLDWZbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ydBLO2M++I9JkUfIoChkk2QLE/Z8GPW3ma6Zg8AaUNQ=;
 b=P4jhoYVnbAs++OnYc3FNML5K+tI1kXln1/mjKWpEGE69xBXF2PZT87i9RceDFdOiKp4Ksj2TDSFMvDA1qTJmLWhHeuvy4AJ9zilxzuliR7F0VKyfKAZeY2Nnm1ckcfRpb+QnGpb6kqwllHXbN0/PI8p96LR7VtCFhOBd4NMXOz0/gWBQ8pps4oboqkjCpS6ipn5CeykKdWMMxDGoju/UHVb1u84y8mSsaWTkVS+uImQZfRJvfNcPbO1wozAKN82g27ERX4l38aMP7Nw2rrJCKYzu9tdNC1gv71R8BAcgeSazUyMJw7JjYLAPyF8otCyhhElDTxrn4opnuNPIZb9erg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ydBLO2M++I9JkUfIoChkk2QLE/Z8GPW3ma6Zg8AaUNQ=;
 b=ri22uOM/RZIk3p8LbLLtuuP+20KUi9SjpLmwAdEuu8WNf5OqA5zn1RyxRIiUH6KCL+i4HjQtWr5Z1K/RnNdJ0CtmjsoPIvuOw/tnXyEMVQCvNbWb1YSPNUfxgGXxLr33REf958Ou7e0CrdcOuqP5tfvmswPaxzDKlLiodlkHNpI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA1PR12MB8189.namprd12.prod.outlook.com (2603:10b6:208:3f0::13)
 by MW4PR12MB7310.namprd12.prod.outlook.com (2603:10b6:303:22c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Mon, 5 Jan
 2026 06:49:17 +0000
Received: from IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::6cdd:2cd5:df5d:3277]) by IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::6cdd:2cd5:df5d:3277%5]) with mapi id 15.20.9478.004; Mon, 5 Jan 2026
 06:49:17 +0000
Message-ID: <4964cca8-6639-47ba-9800-8bb9120aa449@amd.com>
Date: Mon, 5 Jan 2026 07:49:13 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 3/8] KVM: VMX: Use cpu_dirty_log_size instead of
 enable_pml for PML checks
To: Nikunj A Dadhania <nikunj@amd.com>, seanjc@google.com, pbonzini@redhat.com
Cc: kvm@vger.kernel.org, thomas.lendacky@amd.com, santosh.shukla@amd.com,
 bp@alien8.de, joao.m.martins@oracle.com, kai.huang@intel.com
References: <20260105063622.894410-1-nikunj@amd.com>
 <20260105063622.894410-4-nikunj@amd.com>
Content-Language: en-US
From: "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <20260105063622.894410-4-nikunj@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0153.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ba::14) To IA1PR12MB8189.namprd12.prod.outlook.com
 (2603:10b6:208:3f0::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR12MB8189:EE_|MW4PR12MB7310:EE_
X-MS-Office365-Filtering-Correlation-Id: c4267c42-92bb-4a47-c3a7-08de4c268bc6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UklPcFYzbU9CZm0yQVUxM2hyTXJiOWJKelczWGhudlc4VjUyUWw2eCtHeXVL?=
 =?utf-8?B?Q3A4SU9IRVVXWEZWbmYvT2ROait1Z2IvVGQrY3dOQjJwY1ByejM2dkdyVE9X?=
 =?utf-8?B?RzcveW1mWmUxSlV1M01kSWp0ZXNUTDU2ajVUbStLUHRSMHgxemZGcDIwbFVk?=
 =?utf-8?B?d05NV2dlS0xiM01NU2NscDZXMHduU0kwSERwZ3NJY0FvZFU4QjgrY2F6eVdU?=
 =?utf-8?B?cERhb1BkTWZKelhqbFU1Vi9HVDdvSW1iajdEL2dqR2llN0JjQ1kwL3ozSTVM?=
 =?utf-8?B?bEI2ZWltMEFLdFhia2kwU1ptZHNESHJ3TmxMN0RCanNQc0IxUzlDL3hTeVNJ?=
 =?utf-8?B?eUxUUEYyblJvRGc3Ty9MTnAra1ZFeHlFM2R4cGUyVUIzQjZBelZrdnMxSG1n?=
 =?utf-8?B?VUtpMDJtbTRuVjBSWGczR0sySUxZNkpYU0xMYjlaK1BzVEg4RWZPNHN4NGd5?=
 =?utf-8?B?bHhRU3h0SFFIcC9zZWR3a1UxcWJyZktnWDh3U1RYMWUrZVJ0ZXl1OHdDNGts?=
 =?utf-8?B?c1hQTU5tWmd2WGZKNFdOUHNLTFMyOFRsY0tmcExJNW5BdXRPZVNtNlh5SExO?=
 =?utf-8?B?b1FyQnNPdEk5TTBmWTlsQ3I0dDZWOEUxaTFFZ2ZMb3dmVDZ3dzhRR2xENHFH?=
 =?utf-8?B?ZUdlaG9pNWpyNWFtRkFPUlRITUJkNWJKUEg3SHY5MjM0aStLMllQc1g3UXFZ?=
 =?utf-8?B?akdJTEhOd0JRQkNvNXVja3JPejlXM2oxTEtrN2RPOWdFZ0pxYU1xbG4zQTJM?=
 =?utf-8?B?UHNScnBYTFQ2b1VFVXFHY2Fqbnc3aWt2SllJZXN0UHNua3orc2pvNnZzZVdL?=
 =?utf-8?B?SE5CM1ZJWDRCSU9wSVkzUGN5MEVNaDFLY0FBNkFUWW9MQ1lZTFZnckJtYmtr?=
 =?utf-8?B?WW42aU5NNmVQS015bTUrQmNIbFZLUkxuRnA1UzNwaGJSQUxOUndxMkxabFQx?=
 =?utf-8?B?b1plL0V1M0szd0NJVWgwdzJlcTY2Z2pkR1MrNkVRWVZ0OU1NaG1xVUtVZkJN?=
 =?utf-8?B?RXA5anVXbzQxMWZYdnZscnNwa2hPRkdxbEhWYU9wY2ozVk9FMU9WTnZ4TlVp?=
 =?utf-8?B?Q2hHdkk5TjhaTW9XSnRYZGxRV3lVdGNHZjV3enZzQXdERjFBUVBNWlVQdTA4?=
 =?utf-8?B?cEhrU0pQRkhoTXZ5N3V3YXMxYXkzS256MDh0bGNiUStGRGJ0enZ4QWJuYnE5?=
 =?utf-8?B?UWNzaUN3cXlQa1lUaWpyTE8rTDBaUVBDY2R0NTQrRlBFc3RPOGpqa0hUQmg0?=
 =?utf-8?B?R1JoMEFFRHo0ajRPMUlxanc3RDQ0SUZNZkNmR3YzN1hMTWM4Z0UzY3M3aFNM?=
 =?utf-8?B?eFphNVpSSENUdVhTWXE0N3gyc2wveHJ2ZThzVEVrbjZrb2gzSE5EMDJTamg2?=
 =?utf-8?B?Mmo5cW5kaHN4YWVpRS9qL2tqdWUyOHI4Wm8zVU9hS3NJL1NxYmhqcnNhTVBT?=
 =?utf-8?B?L29xM1dKa3N5MWJmY0RRcEtlNWdlR3NDbzR4dWJwbGdpTnV5TkRqajkwcVh1?=
 =?utf-8?B?K3lzdWxLbGV5RUxab0VpMG9UeXJtaHR1RHhhVmNVbEJFZ0xBWmF0RjNCSDE4?=
 =?utf-8?B?QlBUbkpSMnpHUlJudVdNczM2czI0dUNxMjdyUk5SVmtZMGd6bVUxWENCeHUz?=
 =?utf-8?B?Mk11U0JPWnRwQmxldEEvZWJCMWtpckx1NG5KTm1VM2xJTDNhZjhaa3VoWEJU?=
 =?utf-8?B?Q3ovQ3JhY1RwWW9NTHFpN2RXeFo1NkVjS2tNSkk0TzFYNWl2OW1qTWdKTDNv?=
 =?utf-8?B?enJtdm9EU1oyTnhkaU4zeDFialIyeXVLcklKalpHS1QralVLdzVLblVIRXpF?=
 =?utf-8?B?Zm0wVVhXOC9uMDNiTVJsODcycEMzV3I5ZExJa2NoaG5XTFQwS0ZGZ2NsTGZY?=
 =?utf-8?B?WlF2UlZNMTgyRG93b2JwaTZrZnUzb3dVSm5JMCszVWk5Q1Z0Y053VWx1aTNH?=
 =?utf-8?Q?TU0YWdWFXH5IAERExXeStTT2Y+LA4vOA?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB8189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MVF1cStQeHpoemh0VlFoZmJFMmVWN2FURTlzZ2Y3QjhVdjFHdHFFOG1XbTNo?=
 =?utf-8?B?cnE0UjhrVnVweDE5Z0hUeTY1RFJxQlB6WUNqcEhmSHJJTm5DQW9FTjZra016?=
 =?utf-8?B?WHpDM25SZW1mSkF4S3Ava0QzVGZrYmwzREFrZVRWbFZZa3dhM3NZS1BkZFp0?=
 =?utf-8?B?K01FZTB5b0Z4cTlZbFZ2R2tIMVd3UUhadHgrK2NWaTIzY013cVpheSs1REZs?=
 =?utf-8?B?R2xaZDJnQUFqbGpuK3NCQkg5Uk1nUGlPTnBzRmlXMXJkZVVxMHU3UzQxY0Na?=
 =?utf-8?B?THV5ZzdZSFNtblRadVJLMXRXZmJ2RWtQZ01qOG1JaUYzcVU5cEU0SGVYeEtK?=
 =?utf-8?B?SmJGU2xxMjg2OTJLb042NzZmdzFkajd0eDVaa3RFYzBJV0g5Vk9wbm1rWEhi?=
 =?utf-8?B?K3k3VytHMGJtMTY3MzVvbTc3eXZvSkhESmtCa1pVczBSdnlIQ1MzMkdNR0Fs?=
 =?utf-8?B?ak5TcTZpNHl3NkozQ1kvUDRaSUNMTEZvNllDTkcyRjUzUEd6WVNTbXY3WHdn?=
 =?utf-8?B?SERnV0R3YUNwWkVhMHVKT0FnS3g5UVRZNkhhYmh1c1JNUTNiRENyS1N1UVd3?=
 =?utf-8?B?YnJVZ3Y0NlYzSVVybFM5RXp5M3N2cEVMQW9MNkFVUnFoa2FZb0s3cmpiWGI1?=
 =?utf-8?B?VmFFM1crQloxU1kvKzEwQTE4SGx6MEF4TG8xU1VyTVFYYlUrZ2Rla1FnRENV?=
 =?utf-8?B?d1AzN2NnN1pIUTVzVEMvSm1QTE1uZnc5Y3FZNGxwOHd2QzV5dkJUbE5aYWk1?=
 =?utf-8?B?ZWMzaDRQSDN5WmZuZCt0MXBKQWkvQnJFSmNYTG9jNytXTHllOGltTCtmWFMx?=
 =?utf-8?B?SlYyQWdIK2VCR2lOdi9rUGtnTVpOQnFWTWNlditXeGxFUHp5SllCbDdrV3U0?=
 =?utf-8?B?ck5jRWpHazE5eDMrdTNlOFJxZ1g2cnBoNk1KKzZFY28vNllHWWN5dU1KcUlL?=
 =?utf-8?B?Y2FOUlZaODluR3lwM3ZsVVV2NmRQWG9KTm1DVVl4ck5RdTFuVkRCT0RCeGdn?=
 =?utf-8?B?aVlNSEFyODdvbHJjQnhZUnZLUWhlSDMwQUp2RGV6ekd5eVVTS2tQa1ErMWhv?=
 =?utf-8?B?MEJ1aHRRVmFDZ2ZyWE12SExtVDErN1lFb1dVUnU5S3JCenI1eTgrUHRwVEsx?=
 =?utf-8?B?aStheDhlREVpNnVPTllYeXdLUVhuck9wbGdMVVF4WnRlSWY5ajMxME93eWNi?=
 =?utf-8?B?NlBpZHo1c0YxYXoyWG1tOVExQm12VVg4aUYxaHBCV05xeXB4blZ3Smt0Wjdx?=
 =?utf-8?B?bmpWT0RVZW1PUmY2K0ZwaHJsY0twYlprK1FOdWpZdW1Cb1g1SGd1Y1pGWEtn?=
 =?utf-8?B?cFRNVEd0eHNBejIxR1lNYmJ2VHY5NmRiS3hHSTNsYXZZSE5xR2tLQVdhTGlw?=
 =?utf-8?B?Q3l0L0JlR05aZUZqOFZvcjA0c2ZkWTlmOFhGZjRyYWhFNjdBZnRwemVvc3Rm?=
 =?utf-8?B?UDR2Nzd6dW1zRENxa1Zuc0hodGxYbW5vWWR6SVJFM3IvQmdHOGZiNXMyVjBR?=
 =?utf-8?B?ci84bXJNL1RYRmFnZXhyY0RPUkhSbjZ4SzNtQlhnb0NMRXlhRlkyaTlwQ0RR?=
 =?utf-8?B?RFR6Sit0NzdWcnpsVUFYdDdXbDFwK2EzeFNZWHZ3aC9vV1JLUVd5dUE2a0N4?=
 =?utf-8?B?SUFMeTFWbklEUHRERTZoUmg4bTVNeXBxSTB4NjZQeWRvZzNRV3N2RWREZlNx?=
 =?utf-8?B?bHNTQmdiWEdKWmtab2UrYzBVb3I5NThsVmxDTnYrTjY4NEd1TFBpSlR0NXZr?=
 =?utf-8?B?VGQyY245WFFlME9FWm5VY3BWYlpLZm9pNFo1OURydDJNUlovU29QRmE4WDRB?=
 =?utf-8?B?aWMwYTFjZk1BQ1JnRjhWWjdaTVdWemJOaVhCZzBtV1orUWo5NVBSY241UHVp?=
 =?utf-8?B?MVZ4SXRKYmhMbHl6Vm53eTZTMHNYMERpbGtvZ2NjVVFVcU9NN0xuOVozR21l?=
 =?utf-8?B?Sld3Qm5mYnpvR2NOTzJMWWhKZmYvVmZyb1RmSFJpbWNIaW9DQlErdjJFbkJk?=
 =?utf-8?B?bGM5bEptQURLdlA1b1JScnM3Z3ZrS1FuTkNsOGJNakl5T20xbXNLTXVwUmZl?=
 =?utf-8?B?SXNCd1RJRWs3TjVVV0dqaVVlbjg3THVmQkl6aVRwMDJzRVhzNEs4UysyUGNF?=
 =?utf-8?B?Ly9PeTduKyt5V3hPQVMxOEFOQzNBd2VUNGRJcXNkRjF1QUZLOTVCRHRmY1NT?=
 =?utf-8?B?c1l4b1RKR20rR2lpdTk2WWMzNmIySEtyRFhVY1pEc0FtcEhlMGNJZ3hsckk3?=
 =?utf-8?B?UWlwdW1WTjlrdy9BVk1RNGZrYVhMY3pjZ1VYWWlldVR3MjhhZCtNSDQ1OEk0?=
 =?utf-8?Q?TNHLgnFnDt5fmXnL0J?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4267c42-92bb-4a47-c3a7-08de4c268bc6
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB8189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2026 06:49:17.2954
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6mBk+AREIjwItzwho0gaWJZ16vxX25lA4/qScglhn219kTMpG9Rx02Af8iiZCj5KrmvaOxpAf+6iivDlEwCs5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7310


> Replace the enable_pml check with cpu_dirty_log_size in VMX PML code
> to determine whether PML is enabled on a per-VM basis. The enable_pml
> module parameter is a global setting that doesn't reflect per-VM
> capabilities, whereas cpu_dirty_log_size accurately indicates whether
> a specific VM has PML enabled.
>
> For example, TDX VMs don't yet support PML. Using cpu_dirty_log_size
> ensures the check correctly reflects this, while enable_pml would
> incorrectly indicate PML is available.
>
> This also improves consistency with kvm_mmu_update_cpu_dirty_logging(),
> which already uses cpu_dirty_log_size to determine PML enablement.
>
> Suggested-by: Kai Huang <kai.huang@intel.com>
> Reviewed-by: Kai Huang <kai.huang@intel.com>
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>

Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>

> ---
>   arch/x86/kvm/vmx/vmx.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index bd244b46068f..91e3cd30a147 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -8242,7 +8242,7 @@ void vmx_update_cpu_dirty_logging(struct kvm_vcpu *vcpu)
>   {
>   	struct vcpu_vmx *vmx = to_vmx(vcpu);
>   
> -	if (WARN_ON_ONCE(!enable_pml))
> +	if (WARN_ON_ONCE(!vcpu->kvm->arch.cpu_dirty_log_size))
>   		return;
>   
>   	if (is_guest_mode(vcpu)) {

