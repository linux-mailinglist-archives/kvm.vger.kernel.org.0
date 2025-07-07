Return-Path: <kvm+bounces-51705-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DAFFAFBD8A
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 23:32:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2D49E4A7BCF
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 21:32:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB427288526;
	Mon,  7 Jul 2025 21:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="qBIfKI6s"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2088.outbound.protection.outlook.com [40.107.93.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 050602874FA;
	Mon,  7 Jul 2025 21:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751923948; cv=fail; b=rYqz1X1Ja59WOC0OE3qXYvh+181vMZZ8tKGRsY9bhpL7inf1p4mbApSzYNZSGpJSV7kQEZgtBGBeVglZ/BspCr2M924zNWxfZl0oBY7s7RhQV8y27VtX+pe1cxNH85CWp+ikXp0MQ6TVui9pJlh3ksOHdq9ixhMopy8a/1krUPQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751923948; c=relaxed/simple;
	bh=48mYz8xtqceT41M0rPbfxPR7chG6aZ9dtYVHXOHtZt0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ZGfUnAoPYhDv01jozFMtUrQv4gpfllEFik9aZ1I+E5dU5kRFGq5nfQmZQy1xYyndIp8iAbggauQuuqyzy0IkwmDD7mFWjipMRBvPziO2NLz1/IvPB/lbnje2k9Qr/Q1G6DjQbn1QK5SOomdt/56XwKOQ00Q0hEGHgvcWMfdZ7fY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=qBIfKI6s; arc=fail smtp.client-ip=40.107.93.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KmPq8P39rWVAzG4BOP0Hml6f4F3elxSbJ0red1r6u9Jlk7JO2gP0+AyoWr0L40ulJYPCYJ3zW6ydFmIfbpVpjm3SOfoabnMvjIdWO0sB6r2nB02kt6fu4Y0w/J9wq3rXgL9OTMsZGgLateD/wXJKMoMnlxKJg1dJ+qDmsC1pd336V4rjZNkGLHNPI3TCTGfNSffm3fRYtodPMwWZe8CUMA1V8cCld91GGmuvCiYH2AFTze94ooxbYdWRP53O8Hh5uFn3DhhcCmulmXM6SGbpIlnOe7V7vIgLEycI+EtZZJ4rLAUls/8vlmNdfVBLcy/PuCLrU6qqWF/FgcXmXGRPOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E1DxI4irj22OGD0LFARxZaBEBVrAYRb8uIrG+BRn1gQ=;
 b=WZMJzK00e40NKXPk5M+RMfAvgSMQWJosltipd/m7aGnTi1mbQAbPPb5Fws+hrxCahJaC69v9gCXOznF5J6nSlSi/HvDwnPgWfAwA+fYvLV05ck7xaNaCrNVXWnl/XtsRbHaTuqxgrUw1eHVedXH3JBkd8lFz5znzXLb/qDEqjtVKQfMUNTxNhmo7l7HOFiOfV+GhRxLu71jpbtI65/xkcjONal3DlwR3lnihvnjdgJFDsRTDUGiNaMiaVsMViZnUR8EGy9T+oUZbKB6C3G3z3wSDSS49IVgze+38aR4AvghmfG19IWenv4ipwcg8H9DbghyQAD5NNxW4n+dTePniSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E1DxI4irj22OGD0LFARxZaBEBVrAYRb8uIrG+BRn1gQ=;
 b=qBIfKI6sB8SJibNaMLCRU5xfkBPwKQ4F2H4jtDNzqvJ/bXN3LQzRhp8xeWcq20wsAvCxEDUTeXqpO5xpU+UqckajdnUjpAeYZ8IP+fC9JCdfSszTpIEWdfZpHVvsjPmLF2QEuJrcvIjYi27CawxY5vAmnXCHCFikLgnIZ73bhyg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6263.namprd12.prod.outlook.com (2603:10b6:8:95::17) by
 PH8PR12MB8430.namprd12.prod.outlook.com (2603:10b6:510:259::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.29; Mon, 7 Jul
 2025 21:32:20 +0000
Received: from DS7PR12MB6263.namprd12.prod.outlook.com
 ([fe80::66d2:1631:5693:7a06]) by DS7PR12MB6263.namprd12.prod.outlook.com
 ([fe80::66d2:1631:5693:7a06%7]) with mapi id 15.20.8901.024; Mon, 7 Jul 2025
 21:32:20 +0000
Message-ID: <0a1a2cb8-aeb0-4727-9703-e85bc4b8c435@amd.com>
Date: Mon, 7 Jul 2025 16:32:11 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 7/7] KVM: SEV: Add SEV-SNP CipherTextHiding support
To: "Kalra, Ashish" <ashish.kalra@amd.com>, corbet@lwn.net,
 seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
 hpa@zytor.com, thomas.lendacky@amd.com, john.allen@amd.com,
 herbert@gondor.apana.org.au, davem@davemloft.net, akpm@linux-foundation.org,
 rostedt@goodmis.org, paulmck@kernel.org
Cc: nikunj@amd.com, Neeraj.Upadhyay@amd.com, aik@amd.com, ardb@kernel.org,
 michael.roth@amd.com, arnd@arndb.de, linux-doc@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
References: <cover.1751397223.git.ashish.kalra@amd.com>
 <b43351fec4d513c6efcf9550461cb4c895357196.1751397223.git.ashish.kalra@amd.com>
 <790fd770-de75-4bdf-a1dd-492f880b5fd6@amd.com>
 <7598ff2a-fab1-4890-a245-9853d8546269@amd.com>
 <d76dd17d-39e6-4cfe-95cc-d68a485864d6@amd.com>
Content-Language: en-US
From: Kim Phillips <kim.phillips@amd.com>
Organization: AMD
In-Reply-To: <d76dd17d-39e6-4cfe-95cc-d68a485864d6@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA9PR10CA0021.namprd10.prod.outlook.com
 (2603:10b6:806:a7::26) To DS7PR12MB6263.namprd12.prod.outlook.com
 (2603:10b6:8:95::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6263:EE_|PH8PR12MB8430:EE_
X-MS-Office365-Filtering-Correlation-Id: 724f1832-566d-4209-eaf0-08ddbd9dc0f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cTNKcGgvV2dhU29rS3QxendhVmt2aG5HZk16TnNkdnZQRjc5VE1ERlJPRk12?=
 =?utf-8?B?RW9veVRCa0RvNDB6QTFvMXcwSllzU0NDeDVqcDZ3bXpYQVhtWGRaUlY5cmFJ?=
 =?utf-8?B?ajdHTTB5U2lXMFdocGxPZzNxaWVURW5GSDlxbU9FQ3EwRVkyUzN5NXpPeTlT?=
 =?utf-8?B?bWpITzEzc09wSUpEbFNaVjJSUlA3QjF0RDRrT01LLzliN0NBbjMrWEVEbmJk?=
 =?utf-8?B?R1VvZkFXUldOcHV3Ym9Fd3ZiNERqSDVodk1nSytnazVLeHlkcGtoWmg0TTVH?=
 =?utf-8?B?NXZJQU92eDE2a2JwZW1aMEh5QU4vaGFjdytuS0I4S3VpOCtqdmg1dzh5QWw4?=
 =?utf-8?B?dG5McTJQbzVveTdKZTEzRkU2VDFIOGxUcnJvZHlxNjNwZ2pRRTJwUFZlbTBz?=
 =?utf-8?B?dEJkNmx0ZXQ2VlNGaGlIYWNxMTF4MkEwcFFxdnlFOCt3U0NlaVhwWnRxbG8x?=
 =?utf-8?B?RHVwU0FOVDRwbFFFTmhZbXhHZXNrYnRqNzluRG1GVTRrU2ZsdkM0dDVVcEhr?=
 =?utf-8?B?VTU2a2hqMDlkQUJPWS9uWU9oR3ZienpHZzJvMXh0YXhNTTdobzFQbmt0Ym43?=
 =?utf-8?B?ODNqUGkwTTc0MGZFVngvcEhsVy9wem8xVEdXdWFnaVJyWmFTMnNZTFAxZG92?=
 =?utf-8?B?ZHFoc0lyT1luSTJFcUpRSjc5MkNzQXJzN2xHc3NtNnI5VHlXWmdZUXZjdFhX?=
 =?utf-8?B?LzBNZTBsV05JcThycmVoZXhHQ2dkUHd3dWNwNEZvK2svbXlaSnlVSWF3TXpp?=
 =?utf-8?B?RnptL2FZZVNsMUdQK1QxeHo5dzEraGlReFY1VHBzWnloazFQdWs3MVRwMlFs?=
 =?utf-8?B?ZmM4dHBubkhRVHZmOHl0d0VNcVRDTWkxdzVXekg2NUV6RUNoR3k5d3grVnRp?=
 =?utf-8?B?eDMvQmw3QTlpc0ZEVy9HS054RlR5VVZ1dENKSVlwVks0NE1Zb3JLelNBVCt0?=
 =?utf-8?B?aVBKRkRyenBtZEhXM0FySUlWY2F0VWZvbCtJWmlTbFhKd1FRSkI2eHk0emFz?=
 =?utf-8?B?S0lDN0hMOXVONERKb2lFbXdPRVpuQnZnTXlRZHFTd29VVHlOd3IzNUJpOG9B?=
 =?utf-8?B?Vk5wcFZRMy9iWm9pRWIvRXVOcHdnOFdnemlyNytJNHFuMWRuU0I2SnAwZFlj?=
 =?utf-8?B?bUJnaXNUbzJHWVFEQjNLRjhsSzN1VzZZRUxYbFZDREpVN3paTXUxbk5jeEs1?=
 =?utf-8?B?NG0ydkpyVUF2YTBxVERucExYVWZjbjY0N3k4UllYcjBkSUx6a0J5ZkZQMXd1?=
 =?utf-8?B?UkM5eDl4UjViMlgxeVpyM0s4QjRsRzkyNzZETFMrQmdqNUVKbGkybVlCcDVD?=
 =?utf-8?B?TkFBeHVlYkpVRThqcnVqUnluRFdVbHRJMXhzNjRRMS9NbjJLK0FXQjVscEZq?=
 =?utf-8?B?UDdqQkJ4aitHT1RCTWc1dGpUY2dXQm1mVktpOG9ZclN0blFBekQyYlk2VXpv?=
 =?utf-8?B?ellITWdvdXp5bW5oVXZzTFljc2VJQml2ekM1TlMxb0Y0alJDY3ptK0hpVFlW?=
 =?utf-8?B?dXJ6UVhnNTVaeVZ5THBPUVBjbm1ITUZJUzk0SSt5cTlCK205aVkzNWhSNW9J?=
 =?utf-8?B?K2poTFZPZ3JBUVZkYXprczhJbm9wT25oODRlaE1wV3BDd1ZHcVBQYXNZWEFO?=
 =?utf-8?B?UzJJOE0yY0NzTDJvUUF4VTFrUTNEY0FrZWJhT09BOU5DOVd3bFFHYnorUjhT?=
 =?utf-8?B?ZHhIcnFpT3EyRlZqV0tKU0Y4ZmZacHBUZUorek5mRkVabXFtTnBZODA4SXR3?=
 =?utf-8?B?anNrUjVvNlQ1dkxJWlVEaDJYeTNEb2ZwWmlHbWNmUCs5TG1LenlQNzR3ZVhL?=
 =?utf-8?B?MHFsRm1GOEw2c3k3T21PT1IzMlNCRENPa2xrT3dnUFhtVjZqT3dFQVJGWEkw?=
 =?utf-8?B?K01xOG9nNFJ6aUR2RG83V212ZWQwZk5vak9KdlZIdkdidjZnK0R3OHJVMG1S?=
 =?utf-8?B?RWNnb1ZBUzBUMWtnU0J3YklXQ1JlVmZPL3FKWVhWRHVUdHdvbDVRS3ZJM3V4?=
 =?utf-8?B?RDArclpZaERnPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6263.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QmV2R0c5N2YzNUpqN0ROSjBtUHhvd3VHdFNsMFVEaVN4TWZpY0t1UmxJdVpD?=
 =?utf-8?B?T0FRUGNoM2MrR09lUmltZTRPS1ByL3dxTU9wTWw1SmxJZitVaGVwUk9wZmR6?=
 =?utf-8?B?OTlMdVRhV0JTL2JaTk13bEdsOURtdUQzU3d2RmZZbWdKZkdZQjBSZWw3ZXA0?=
 =?utf-8?B?OTNwOUtvUWUwYm43d25WTmxnYlA5ZXBuYjd0VlpiQkNrOGYyYmJRS0lhK0s3?=
 =?utf-8?B?VDhNcG1FZTNBY0VJNmx6ZGlkQVNHOGdmWERqbkpqc1FvWHc0RW1MM0JtY2lQ?=
 =?utf-8?B?TCtZdWpYd3JHTnc2dkZtMjkxNUZFRy8wUnJ3d2UyWmpDVXorSk1MaXRjVThI?=
 =?utf-8?B?S1kwbDhkeEsrcmI0azBFTnRUU1YyU1VldGlGWERsQzNvWmFhUkRDQThXYUFR?=
 =?utf-8?B?d0IzZW5ONDdLY0kzT0pnWFl3SlNwYk9tT1FKamU0VmhVRC9RNnowT2twdXVw?=
 =?utf-8?B?QzJSMXBHdmdCazNLQ2cwS3pCU1dZQkJrZWxlbGJqSXRwWFBFQnlYc2VtS2M4?=
 =?utf-8?B?Rjk5YU1TSldFd09SNTRCY1RkbVlTeDNpUzlQSFJ4RDVaVHVNK1FCS1J1ZG9R?=
 =?utf-8?B?OGhyRVZaR0k4VVBqRldTdlBMekVjSVFEM0ZCQktVeVVmdks4S0hpOHNxU28y?=
 =?utf-8?B?WkIweUxLcnc3YjRudGtUekNteVRDWngwUDJhakhaZC95ajB6MENDcUdCQ0tp?=
 =?utf-8?B?bVd5Rmo1SGI4VDhjQnU5U0FJVk9SZGxaYU1GMStzc2E0clROMGR2N20xa0lh?=
 =?utf-8?B?M0k2OG4yZ24yd2F0TCtVL2Fha25FOFNMRG5nbStQT3dOOFRZVjhSU3RVeGhZ?=
 =?utf-8?B?MEFlcEdDV3VjNlFnMm9kNmdIYURuNWt4ZUVWYzFTaTJYREhRcml5Z2FQVlBV?=
 =?utf-8?B?THVHUkdnbkFoYlY0M2NJU24zeWRGMDI0aHR3N1JESlFQWEtiVURFOFlJTkZX?=
 =?utf-8?B?SlExR3o3UHgvTGFxQTI2OUpYM2M0NXo3SHNzS3JLR3kxMjNuSkRVZW1wRWFw?=
 =?utf-8?B?WGg3WVZxT1BQcld1RjBWV0FEeFJBTEV4RWRWNk1HT044MjRFQjdDekh2LzZO?=
 =?utf-8?B?UVpkU3Z3SC9hY0JVZVVpQTd6cmhSaFVvbXRKaWFmRXJtT1l1WHgyTFVJUE1x?=
 =?utf-8?B?amlKS3dkMnFjR0hOb3NvRVhkK2tYam40bmxrd0psK1A3OVZSZllHOHByeDRO?=
 =?utf-8?B?NGVINHgyRVVaVUJVV0EzOTRWRDZMZGZ4QkxJYUJDaWNTNU05ZUt0WGdvZjdy?=
 =?utf-8?B?UHBscjI3U0hCQ3VWVDJuc1pXb2N3b0lwdW05eWhWdUpwbXdHMjFzZnc5RmZx?=
 =?utf-8?B?VmwvN2szdnE0NUFpV3UxWnI2MmJGSThlT3BFYWFUV29zYVFRRitQajlXb2h5?=
 =?utf-8?B?UVZGU1JGTVUzNTdyd1QzazROcW9VeFhZeXV0RWRITndJV3VqRmZqSk1YSWVL?=
 =?utf-8?B?UXdmbDRONzF4YzFidEVUY1pqSFlHTmQ1QUx3eUV3WWtOcXl6bFQrV29aYXU5?=
 =?utf-8?B?YjFHTDNJdWd1cS9Yb0VoL2RtbmswSElvV05GOEJIL25NaW1QcDRHZmtSY3Q0?=
 =?utf-8?B?alpLN1M3ZnU5YWRsYTZiOG5VUHVCLzUxRmd4ZHA3RFN3SUxQdE9yS0ZpNUZv?=
 =?utf-8?B?K1hEK1hSMmlWRGlQbVlodWk3TEV2RmlWTWhvMWxmWW5rQW5IcDFnVjhGdytP?=
 =?utf-8?B?QW1UQWtWSFR0VmFxVXlRMDV6K0RtbjBCd0tsaTl4QlFoWFFudkNxY1ArNmda?=
 =?utf-8?B?T3JyQnlLQkNHV2tpOE93ak1jVC90cU1xS1JDV1pGT0N1UkNHaklCSXNNSHA3?=
 =?utf-8?B?UzM0Z3k4YjFoaXIxS0tsaTQwMTNxZEUyektWYk00TFpQUkFTandRbFdLRDUx?=
 =?utf-8?B?UWdiaDdtMlgzNm80VjdsTGVsWWtTT2tSV0VnZUxEZ2FSYkx0cG1CZTBOd0x1?=
 =?utf-8?B?bGZaTmxEMGpNb2l6ZWl3Y25ESGNDb2c0OCtYMGV4MU9YUDNqS3plbnpRMFRN?=
 =?utf-8?B?UUZnZ3BuSnhGeTVLZFRWQmdQa2RkRmNvWW5pWElWOXAvTStxbVNVb2VaaEVw?=
 =?utf-8?B?YUFpcGwxQnRqU0xwR2FWNVNEN0dneGRYS1U1WGZGWkVDOFJPcHVkTGlpRXpy?=
 =?utf-8?Q?jL7TqIj2yl7F+7+zw/lO1PG0y?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 724f1832-566d-4209-eaf0-08ddbd9dc0f4
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6263.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2025 21:32:20.3385
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0m5zyynXFiZQ8xRdp/EkS0hHicndCfyr4fuTedTWbJRA0v2WFgto+OtOt+S1J+dR6hyfMn0HKNkKbTn77EC8bg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB8430

On 7/7/25 1:16 AM, Kalra, Ashish wrote:
> 
> On 7/2/2025 5:43 PM, Kalra, Ashish wrote:
>> Hello Kim,
>>
>> On 7/2/2025 4:46 PM, Kim Phillips wrote:
>>> Hi Ashish,
>>>
>>> I can confirm that this v5 series fixes v4's __sev_do_cmd_locked
>>> assertion failure problem, thanks.  More comments inline:
>>>
>>> On 7/1/25 3:16 PM, Ashish Kalra wrote:
>>>> From: Ashish Kalra <ashish.kalra@amd.com>
>>>
>>> Extra From: line not necessary.
>>>
>>>> @@ -2913,10 +2921,46 @@ static bool is_sev_snp_initialized(void)
>>>>        return initialized;
>>>>    }
>>>>    +static bool check_and_enable_sev_snp_ciphertext_hiding(void)
>>>> +{
>>>> +    unsigned int ciphertext_hiding_asid_nr = 0;
>>>> +
>>>> +    if (!sev_is_snp_ciphertext_hiding_supported()) {
>>>> +        pr_warn("Module parameter ciphertext_hiding_asids specified but ciphertext hiding not supported or enabled\n");
>>>> +        return false;
>>>> +    }
>>>> +
>>>> +    if (isdigit(ciphertext_hiding_asids[0])) {
>>>> +        if (kstrtoint(ciphertext_hiding_asids, 10, &ciphertext_hiding_asid_nr)) {
>>>> +            pr_warn("Module parameter ciphertext_hiding_asids (%s) invalid\n",
>>>> +                ciphertext_hiding_asids);
>>>> +            return false;
>>>> +        }
>>>> +        /* Do sanity checks on user-defined ciphertext_hiding_asids */
>>>> +        if (ciphertext_hiding_asid_nr >= min_sev_asid) {
>>>> +            pr_warn("Requested ciphertext hiding ASIDs (%u) exceeds or equals minimum SEV ASID (%u)\n",
>>>> +                ciphertext_hiding_asid_nr, min_sev_asid);
>>>> +            return false;
>>>> +        }
>>>> +    } else if (!strcmp(ciphertext_hiding_asids, "max")) {
>>>> +        ciphertext_hiding_asid_nr = min_sev_asid - 1;
>>>> +    } else {
>>>> +        pr_warn("Module parameter ciphertext_hiding_asids (%s) invalid\n",
>>>> +            ciphertext_hiding_asids);
>>>> +        return false;
>>>> +    }
>>>
>>> This code can be made much simpler if all the invalid
>>> cases were combined to emit a single pr_warn().
>>>
>>
>> There definitely has to be a different pr_warn() for the sanity check case and invalid parameter cases and sanity check has to be done if the
>> specified parameter is an unsigned int, so the check needs to be done separately.
>>
>> I can definitely add a branch just for the invalid cases.
>>
>>>> @@ -3036,7 +3090,9 @@ void __init sev_hardware_setup(void)
>>>>                min_sev_asid, max_sev_asid);
>>>>        if (boot_cpu_has(X86_FEATURE_SEV_ES))
>>>>            pr_info("SEV-ES %s (ASIDs %u - %u)\n",
>>>> -            str_enabled_disabled(sev_es_supported),
>>>> +            sev_es_supported ? min_sev_es_asid < min_sev_asid ? "enabled" :
>>>> +                                        "unusable" :
>>>> +                                        "disabled",
>>>>                min_sev_es_asid, max_sev_es_asid);
>>>>        if (boot_cpu_has(X86_FEATURE_SEV_SNP))
>>>>            pr_info("SEV-SNP %s (ASIDs %u - %u)\n",
>>>
>>> If I set ciphertext_hiding_asids=99, I get the new 'unusable':
>>>
>>> kvm_amd: SEV-SNP ciphertext hiding enabled
>>> ...
>>> kvm_amd: SEV enabled (ASIDs 100 - 1006)
>>> kvm_amd: SEV-ES unusable (ASIDs 100 - 99)
>>> kvm_amd: SEV-SNP enabled (ASIDs 1 - 99)
>>>
>>> Ok.
>>
>> Which is correct.
>>
>> This is similar to the SEV case where min_sev_asid can be greater than max_sev_asid and that also emits similarly :
>> SEV unusable (ASIDs 1007 - 1006) (this is an example of that case).
>>
> 
> Also do note that the message above is printing the exact values of min_sev_es_asid and max_sev_es_asid, as they have been computed.
> 
> And it adds that SEV-ES is now unusable as now min_sev_es_asid > max_sev_es_asid.

Right, it'd be nice if that were made clearer to the user, too:

min_sev_es_asid 100 > max_sev_es_asid 99

>>> Now, if I set ciphertext_hiding_asids=0, I get:
>>>
>>> kvm_amd: SEV-SNP ciphertext hiding enabled
>>> ...
>>> kvm_amd: SEV enabled (ASIDs 100 - 1006)
>>> kvm_amd: SEV-ES enabled (ASIDs 1 - 99)
>>> kvm_amd: SEV-SNP enabled (ASIDs 1 - 0)
>>>
>>> ..where SNP is unusable this time, yet it's not flagged as such.
>>>
>>
>> Actually SNP still needs to be usable/enabled in this case, as specifying ciphertext_hiding_asids=0 is same as specifying that ciphertext hiding feature should
>> not be enabled, so code-wise this is behaving correctly, but messaging needs to be fixed, which i will fix.
>>
> 
> And i do need to fix this case for ciphertext_hiding_asids==0, i.e., ciphertext hiding feature is not enabled, as the above is not functioning correctly.

Right, it's not just messaging, SNP should still be enabled when ciphertext_hiding_asids==0,
whereas this is not the case with this patchset.


> 
> Thanks,
> Ashish
> 
>>
>>> If there's no difference between "unusable" and not enabled, then
>>> I think it's better to keep the not enabled messaging behaviour
>>> and just not emit the line at all:  It's confusing to see the
>>> invalid "100 - 99" and "1 - 0" ranges.

Please also consider this.

Thanks,

Kim

