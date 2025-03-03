Return-Path: <kvm+bounces-39887-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CD8D5A4C3F3
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 15:56:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CC3FB1895E58
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 14:56:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CD00214201;
	Mon,  3 Mar 2025 14:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="pINEgrDK"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2073.outbound.protection.outlook.com [40.107.220.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39254202F9F;
	Mon,  3 Mar 2025 14:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741013796; cv=fail; b=EqNKpNAQT+Ph1Y/lwdpv4HoVo3K/nfDLLy+0TYhKFxLPGhf4h5fDpvqrKoH82UuHReQc4HidhZ5wn+5HmGW4eyGFDMcWGnU4DkaKHAxyMG+J+RXoSdTIXDmCVZFKjMzMqnjwtegGALz2IjpUgAaMn3XukP806lgiLNv4nO8Y+h0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741013796; c=relaxed/simple;
	bh=HkDHxI+nbmx20WExEB4sxR1w1heVQXM//hbQXoxyFxM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=TZ3vNKBUPnszFNXj8MI/9RtqQiOEkpAy24qVD5wrlhRThm6/FlBhiUwH1yz5QfZB3SHrZOBFBkHo3/i6Vtc6EonpN57tvbqbLjZpTY4MjRa8qylYNrlNwg79LFzyn0PCbZxfymrPpUJYQ09C+kqr2gDqqFUkzfNU0WvwVMVTrao=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=pINEgrDK; arc=fail smtp.client-ip=40.107.220.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VH7U7DK7UgnvQ5ww9oI4LiIv1QRdD4EyuD3xr7WB0QrYCmqYE6q9nUBFQdON//WZNuwrR3AZ8fZekFnSBD1VPzM+IvvD4dnatC4ZknKVK0l87l9AMJDvFLMTo7hkiwX+Rqz3ysKX2T9Iqvi3nAb+CbHFYO459d1G4G+BGRDV8qN7MTKNxdSX/Cr4a8YBlwaVQR7QPzDfQoOxupJtZKtSMr7TLmqfolSZDzD72jjzQfLJwn4wiTVU6RNcJPfFFOYmZYiNt2M7tA73QzH39pRkbL3wXZ9tP/88uy3U8yQoWAf9r7sthP3C7lXhM/QMRBop8mxwlt8vZU9fAzGahq6/kQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MvgzT85Qa/iqOLJCz97m1pig49gBYjNp1tKJVrTb+Zk=;
 b=Xli9r7PbUJSfQYFoINc48GzxWY8d67ItS1Pju4NvVDBXKnz6EXKOsdOsZaVUSs5LKODGAI6MDHIkemSB3VEm2Rii/fKB3RX7lYRclRYYi/ha2Ir7JjFqC4kae/M9+udaZFd7QcOtx3HjbmmAF5pbnGq1r2Zfzm4xFz98KqnVSfEqGdoq2me60dfRMT4T8Tp0qrmm4uhrcb7EuvYXpINdqy84LzprdjPRv37ZwgeQ9Hc70TuTOU3C/Jqaic1ZS9Aco0aAiMVm4Gk9/2lqmK7lQZDJcOgLOJPFWUhR1KJYbIfNjLQqFrELy+T5DxO/9Z0xquKma9soG8rvC0njn5flNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MvgzT85Qa/iqOLJCz97m1pig49gBYjNp1tKJVrTb+Zk=;
 b=pINEgrDKxrZxjwFFY7d+I/XqWjFycwNCOaL+4Y7vTlo29gtEqts0e2BP+t0W00Gv3rICLp17jwXQWUjhlXho26YM1peTR3ZmyLXO09uKnIjBxh5u5b/I3D/6IZwF+hzVBCSol75244/Si2y8Wtmuib1xe1BtM3tszExuA7tOXYI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by CH3PR12MB9219.namprd12.prod.outlook.com (2603:10b6:610:197::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.25; Mon, 3 Mar
 2025 14:56:31 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8489.025; Mon, 3 Mar 2025
 14:56:30 +0000
Message-ID: <a299aa00-a127-cd78-d48e-caf95a489f2a@amd.com>
Date: Mon, 3 Mar 2025 08:56:28 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v5 4/7] crypto: ccp: Register SNP panic notifier only if
 SNP is enabled
Content-Language: en-US
To: Ashish Kalra <Ashish.Kalra@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 john.allen@amd.com, herbert@gondor.apana.org.au
Cc: michael.roth@amd.com, dionnaglaze@google.com, nikunj@amd.com,
 ardb@kernel.org, kevinloughlin@google.com, Neeraj.Upadhyay@amd.com,
 aik@amd.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1740512583.git.ashish.kalra@amd.com>
 <29e8c21eae96b2cbe0614d04cfa1014b424134b1.1740512583.git.ashish.kalra@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <29e8c21eae96b2cbe0614d04cfa1014b424134b1.1740512583.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1PR04CA0011.namprd04.prod.outlook.com
 (2603:10b6:806:2ce::18) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|CH3PR12MB9219:EE_
X-MS-Office365-Filtering-Correlation-Id: 662facc5-3ea7-4e97-5fb2-08dd5a63951b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NU9XRDhpTzlXL0hneDhXYW5JTFl1ejNsMXVtcFhtTDFKWFRBaUVCZjdENGpC?=
 =?utf-8?B?TUlvemdISC9lRjN5RkRYWUVvV0NoUWNXd2RVMGtNd0FMOTdYbjRwT1RqSnJJ?=
 =?utf-8?B?ZU4vQWxjRWRGaU10Q0FrWkZzNmNJejk4dmV3UWdpZDhRbXE5V25tRUgzS3Y1?=
 =?utf-8?B?dmdmMTdFbnMrTzJoSkQyOWc5MUdoN2xab3BEcU9XQ0NhUm9XSzgrd3BaT2FN?=
 =?utf-8?B?bGg2VVBlZ1lzRWxpdDd3ZkNkOEEyYzNTaFZleVdvL1ZRUHBVY2prT2F0TW5Z?=
 =?utf-8?B?b2QrVGxYN1EvbmRHOWhiV1orWk1TSDdtdlQrMHZ1USt2UkxwdGJOSTIxU1lQ?=
 =?utf-8?B?MVBTU25CcE8xSnBmSDVYdUM5UUhsYVZ5WVJZaVZOalhvVFFiZGtEREp1VGNv?=
 =?utf-8?B?WUwyWHE3dXdjdm13K2lTK1NpbUVxZ0x6YTNQRnI4dFlXSXdWRmg1UXFQemhu?=
 =?utf-8?B?bUp2cHBGL3hIb3VQRy9SR1JwempSRkFsS3hOakpRVDN6RFNHTGJyajVKeGRm?=
 =?utf-8?B?ZTQ4SFNLUkFEWUJiQ1FYcnUxUnVaejFvWDBXRUFQR25OcGhSVEVkTnQ4TXJr?=
 =?utf-8?B?V0M1REt3MGNSVHBuM1ovRzVic2d6KzRQd2J4RHZEZjMrengxT3VmR0JrNzB0?=
 =?utf-8?B?VWIzT1NHOEkyekhXWllocFdXOXRzV0I2ZStMK2ZIUHlVd1JDdlY4RmlqRkQ3?=
 =?utf-8?B?bWtVUmxKT2JDcGN6elVDenBudGNWOXhMdkg4YUJCcVhxd2xnK3BKMXU1N1JJ?=
 =?utf-8?B?blNoSFBBSnI4M3liaGhVRklvdUQ2b3RZOGZ4Q2ZqaGNaVUF1N3M5ZTQxMVJz?=
 =?utf-8?B?bkRXL1MxYkVXMS8xbkd5MjlMcEhxOGpKRkJORk1NR3EvV3A4NWJTRGFtQ2xY?=
 =?utf-8?B?Q3dsQTFzRjJqWVlUK1hQN0cvUGpJRWRyTERuTDFNYzl0RFFmRFhtR3MyaXVq?=
 =?utf-8?B?TExVSmg0ZTFkZXpDOW9yMm5PTjIwTStJbGI3a0p2c01qa0Vha1ZzQUxGT2xj?=
 =?utf-8?B?VGFmbjMvbWJxNUNLcUdzV21NU3MrSU9hdm94dTdBTmxXZmJJR0hDWCs0WWJh?=
 =?utf-8?B?Q2JBY1BIVWl1T3dWQnRNY2I2VFdOdldOaG8xeTlIQlZMaDhaUUVzcWw2c3cz?=
 =?utf-8?B?L2RXdUY3RDBzSFpwUUQ2SHh1dUMzMStOWmNRZE1KaDZMTjFZZ3FhZkZHQVVP?=
 =?utf-8?B?RmFLZU1PWlVnRnIrclAwNDRpN2M0aTRuM3FBa3hpRlR2VUdFZkpVaTlvdS9L?=
 =?utf-8?B?NUxOaDJBTWpPQnVxOXBwNEZaelQ1QWlNZVY2TlR4a2JHVXZ0aEVsSzMyTzBp?=
 =?utf-8?B?KzVndWFwT0gwUk1CZkhubUdWM2dEZk5FZm4xMUpmL3BnQXVzSTRNZGM1TnNE?=
 =?utf-8?B?VkFWTHo1VUhTRGltaUQxS0RiYjJDUjYzNE9UaU5GaEtYSkhmV1RhU2l5Z3pV?=
 =?utf-8?B?bWtEckY1U3J4dlJ0R0UxUTE2eVhkMVBrbWRTU2QwSHlleTFpK1dOQXo1OFhi?=
 =?utf-8?B?ZU40S3RLdTJQNmFjejBLekFtT2VSUEtBb1NZSWhDOEZWRk1yaC9EbjY0L0E4?=
 =?utf-8?B?TmZqZEx6blBZWUZMelRsN2ZHNkZlZDlGZVViUUx3YS9UWHFVVHVrVHR2VWUv?=
 =?utf-8?B?ZzBhR2pZSnh3N1dQZURrZThPRWdVSFV4aG5STEZBVmRTMnB3dmMrcVpHN1hp?=
 =?utf-8?B?UTNRYnJDRzZjOXpnU0hYSTdqRkZ1RVNJajFJdE5JTFlBWXpKTGl2U29aSXpU?=
 =?utf-8?B?blhETGErYUdVVEJzektoRDFQZ215b1JUWENQckt1eGJyV2NSK0lKNVpmdENa?=
 =?utf-8?B?R2Yra3hRVVRyOGpZOW1IMEtiL2dNYkhmelY1Ri84cnBtaEdhaUJFYjFWMHdJ?=
 =?utf-8?B?MFF3bzVLaUxtcEFUWmtvaG5ObExXSzNmcUxuelJNR2hEV3RwZ2QvSndhdTg0?=
 =?utf-8?Q?9L+Aj0h6SqQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VUtWaW8vcUM1MmM4ZVA3RHhjWS9nV1I3UWduaTdCSDZRcDJBdFM1bXhYUi9I?=
 =?utf-8?B?OTVMTlR4cXgreWhad0JqZFdNRVVtZ2Q0SElibmUxaWpZVjU2dkhqK2FJQkRk?=
 =?utf-8?B?TmlZTVRQUzdGS2V5WVhwa1lPZWNXY0xEQlRJc0tVeThLNXhGdlBHZlNnZjZz?=
 =?utf-8?B?YkczZCtLKzkyL0pDUk1WWVprSG5CNkQ0WmRYT2N3cjBZeitlMWxkQXNsblhB?=
 =?utf-8?B?YnRFbGNvVmpsbVBEMXNOVFhnVUV1bDkyRWJ5blRaU2ZsVTZXRlRNZUxkTzlB?=
 =?utf-8?B?aC96aXpUSitxQXlabUtkL1NVaVFNYzZQOGptYnFBNmNQVWhmWktzRUlKYXI0?=
 =?utf-8?B?ODhTUm5hREdKaHpEdjFrZ3VDNEtFMHNUbVJPYlkvRHJ6R2F4eWdMSE9sRG9F?=
 =?utf-8?B?eXJTUWhVck1IQUJscWxCMHByb0czcjhBNVF4MTlsUWdWUEVjYmN2WlEwSy9t?=
 =?utf-8?B?bTJ3WGo3YXJXUHNTMVZxazc5d0pGNHdsc04rc1RidTMrRVliRGRUY3FKeGJm?=
 =?utf-8?B?ckxEL2VwdVdJQ2N0R0NHbmVPdDJWT0pWUzhOdmVoWHNISFlLVUVtMVZQNE5u?=
 =?utf-8?B?WklCNndXeW9qanJnRmZGVGE2dUNRa25IbzZ2T3NwTzNYcTkzenF2ZktDY2hP?=
 =?utf-8?B?MDMwN0syQjd3K1czSW42YURaZ0RsaGhwanh2MmQ2TmpyWXpzWnRESEpwVFJv?=
 =?utf-8?B?b0s3S21WcStOYW1DWTExOUQ3eDBza3FVck1BUEVqUFZueUlremRSR0lNRWda?=
 =?utf-8?B?a242UVRjb2wrd3V6eU01TnhiTE15SUU3cXhBVjlPZ1FNNmhHR29EWnNocDlE?=
 =?utf-8?B?NEZlVTk2Z3c3WUQyekx0T3Jidjc1M3ZwbEhFRVFaRU5RYWoyRkZLWUg0eFNM?=
 =?utf-8?B?WHR2YWpHQWFYUlozMXhRY0JBeVgrRnBiZzRJZzltdzJsTjBvUmo4czlCSGxo?=
 =?utf-8?B?ZUlISGZETENodUEyZDNjeEZjZ2RGeVVvU1JzTUFDK3A3Y25xZFMvRmtPcTZC?=
 =?utf-8?B?VzZwQnFqTk9JQ21qbHhSWklCQVY4cnM2TnNpMUYxRjh6cHJNZHUxK3BES2pG?=
 =?utf-8?B?VENYNldBRG1oQ3B5ZS9wYU1FUDFWbXVmb0h3dTBSUDd3b1Y0aHB5YzRUcVJ4?=
 =?utf-8?B?QmpVSGwwaVkxa1NqeGtDeVYyUzlyMUtBTGNRR0k4R2Z5UGRrUFI3RWNBQzVa?=
 =?utf-8?B?NEIyTzFUTkhRdXdTbDFieHpUd1BOUHpFTHdLd1ZlcDFONnVsNjFsTDcrTUNp?=
 =?utf-8?B?WTBucWJUNkQ4TFBtNjFjVmRSbVVaQzFuYTRRY1JPK0dWU3VwVWVLS2lHNE9s?=
 =?utf-8?B?RGRoZGdpNmZtWlJKUFNCcGJHUnZNWEJQSmV0aXdBTTNjSGZEcXVQV29qUm5E?=
 =?utf-8?B?dzRQeXNkazNjek9VUGY1NzNoaDdlVlJTYlU5SCtLQzdMaDJjZnhGWXpOeDlH?=
 =?utf-8?B?Mm9WeXY4R3RtcGI1R2J1cVRVUzlXYUM3SlBhSzhTTXR6ZnVQcFNFT095ZG1D?=
 =?utf-8?B?ci9ib0RPM3FCWUxwVm1vTkZXOHNhOGVKZHZ5Q1djd0x6Q0N1bHhjZ2daSFpl?=
 =?utf-8?B?dm0wSnMvZkQ1TDNhblVXYUZQRit0TndoaExQdzlHOGVxYVpBYTZpZVg3TnlQ?=
 =?utf-8?B?UEpKTHVDbWREaDB0WFAwYnBvc1RPZG1WYm9ueWJYM3Y2aUlWUTZLY00xSkdK?=
 =?utf-8?B?TGNUcFhvTFAwWGt1NGpITVlOaVl6WHhHMUdLZXJZaUwxc2lNUHdYTXV4MGV4?=
 =?utf-8?B?bUxDUVJpN25FeVF5U3U4TjAzOThDdnhybVl6YlpKQVh3R09ibUtqRERPVTZk?=
 =?utf-8?B?Q202OWNoa3RKeGlVWHJxb3hJK3JrWWNwcUJkZ1NJQ1ZHR04rM0RWdkt0SEVu?=
 =?utf-8?B?ZlFBMVBjMTFOZUtmSnlMM2lYMTIzS2JkcVZhSDdIRHJVQ2RVV2tBdEY5UzJp?=
 =?utf-8?B?ZjJ1TE5aMm9mcWlVTTVYMUFvSjRZSDNkbmtBM2xxWC9OeHg0WWw2YVhkNVpm?=
 =?utf-8?B?aWF4MTJVN3Q0Z3Rrc3lOVkpFQmZ4UjZydXRjWjZyaHdOdXN6bW5qUEVUZHIz?=
 =?utf-8?B?cmpNdnF4eFVsSFJKTVJkQ0VUQklRTG9NTUJwcVI0Wnd4L1FGTE5QMGUwcG16?=
 =?utf-8?Q?vU61iKZsWeIbrGiKnvYrpMTXo?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 662facc5-3ea7-4e97-5fb2-08dd5a63951b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2025 14:56:30.8100
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KiwwJLaF1/iazBlatyJi1Mc2sjK5otsdwPa7h5RwOqArWX+fkThZUOwy9fkOwJ+tpjVtZTWb1+WdY0xpuUlSAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9219

On 2/25/25 15:00, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> Currently, the SNP panic notifier is registered on module initialization
> regardless of whether SNP is being enabled or initialized.
> 
> Instead, register the SNP panic notifier only when SNP is actually
> initialized and unregister the notifier when SNP is shutdown.
> 
> Reviewed-by: Dionna Glaze <dionnaglaze@google.com>
> Reviewed-by: Alexey Kardashevskiy <aik@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  drivers/crypto/ccp/sev-dev.c | 22 +++++++++++++---------
>  1 file changed, 13 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index c784de6c77c3..b3479a2896d0 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -109,6 +109,13 @@ static void *sev_init_ex_buffer;
>   */
>  static struct sev_data_range_list *snp_range_list;
>  
> +static int snp_shutdown_on_panic(struct notifier_block *nb,
> +				 unsigned long reason, void *arg);
> +
> +static struct notifier_block snp_panic_notifier = {
> +	.notifier_call = snp_shutdown_on_panic,
> +};
> +
>  static inline bool sev_version_greater_or_equal(u8 maj, u8 min)
>  {
>  	struct sev_device *sev = psp_master->sev_data;
> @@ -1198,6 +1205,9 @@ static int __sev_snp_init_locked(int *error)
>  	dev_info(sev->dev, "SEV-SNP API:%d.%d build:%d\n", sev->api_major,
>  		 sev->api_minor, sev->build);
>  
> +	atomic_notifier_chain_register(&panic_notifier_list,
> +				       &snp_panic_notifier);
> +
>  	sev_es_tmr_size = SNP_TMR_SIZE;
>  
>  	return 0;
> @@ -1754,6 +1764,9 @@ static int __sev_snp_shutdown_locked(int *error, bool panic)
>  	sev->snp_initialized = false;
>  	dev_dbg(sev->dev, "SEV-SNP firmware shutdown\n");
>  
> +	atomic_notifier_chain_unregister(&panic_notifier_list,
> +					 &snp_panic_notifier);
> +
>  	/* Reset TMR size back to default */
>  	sev_es_tmr_size = SEV_TMR_SIZE;
>  
> @@ -2481,10 +2494,6 @@ static int snp_shutdown_on_panic(struct notifier_block *nb,
>  	return NOTIFY_DONE;
>  }
>  
> -static struct notifier_block snp_panic_notifier = {
> -	.notifier_call = snp_shutdown_on_panic,
> -};
> -
>  int sev_issue_cmd_external_user(struct file *filep, unsigned int cmd,
>  				void *data, int *error)
>  {
> @@ -2533,8 +2542,6 @@ void sev_pci_init(void)
>  	dev_info(sev->dev, "SEV%s API:%d.%d build:%d\n", sev->snp_initialized ?
>  		"-SNP" : "", sev->api_major, sev->api_minor, sev->build);
>  
> -	atomic_notifier_chain_register(&panic_notifier_list,
> -				       &snp_panic_notifier);
>  	return;
>  
>  err:
> @@ -2551,7 +2558,4 @@ void sev_pci_exit(void)
>  		return;
>  
>  	sev_firmware_shutdown(sev);
> -
> -	atomic_notifier_chain_unregister(&panic_notifier_list,
> -					 &snp_panic_notifier);
>  }

