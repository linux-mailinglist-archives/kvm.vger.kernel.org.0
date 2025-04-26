Return-Path: <kvm+bounces-44458-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FD7BA9DB92
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 16:53:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D48617A5985
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 14:52:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E54725CC61;
	Sat, 26 Apr 2025 14:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Jkmcfiby"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B539B256D;
	Sat, 26 Apr 2025 14:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745679223; cv=fail; b=XiUxwEzQ0jxNLZSXZSEPa26oOxV74EkXzB3MTkp1Kj5/Smi1kyNt+P7n9i8bcZ2rIo86endWUiSrXsfGe9KLs0agZmq24CQDzee7gIXtMyBuecYhahn5DNQQK2sltDmhbtrOJtKE7iK1WQ5sanENCPWclbiBCEmaS82yoC71H3s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745679223; c=relaxed/simple;
	bh=9TmNDua3FQe/IESnMHMyontJIlve9kDDLDUXFH0f5Rs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Y4NyonXKIHNIPbBXV9Qr41RWqgQhR0QNX5A8JGe7syZ2iR4eoU7cLEIVHJtRx+2p5ZurAaEVLKA/ZvfvaHl6dattiKGVJ5CT+cD7ibTEPDbSYKtVf2odNWMGoTxL1EwTx5vcr8T3ldAuH3ywfHRi28dHEsGmpdgnWQczIjsYUN4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Jkmcfiby; arc=fail smtp.client-ip=40.107.236.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rQNvyaV70I0Z4gFMIeNkL0JlW9zgXiMBjUZFwtpVYnzgEgmTJ7ySzHu+wc0XQ6Ag26VPf/tGu8OZV7l6lOml25P4iK4aJvCYHDzDevsZZy74VB8agESTc6t7CCl7mZ09xc1bzeYeScRQbclwDwziHufQIiRvKn9UDiaoitZ2QU1QGyG9ZuThzTbZXuea52uid586ShdwzCPDbL6AKyHgwQ+qnvo0Qi1FEYx3eRlUwb7iJLmDRG6XCQQC5C6JmSPzUfUABLW4SvhQJES+OGvc3JRDZuakryko7/cHD/GNlvBxB7AZM0DLo/FFrow3B4FDMSNaXrAF5e7+6/6yYzXenA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tXIUZKT8KWh7vwxMFlEE0XrBFhoaK81Z2EsP1Eg2ols=;
 b=X798Crteem9rXK80GNi1hUWi3QFoGWJq8RF3G2P3YQ78nP87+IwS0Uaib3PhC+EXN06B3QXe8JCJ4xijoPstjbxqxlEInnetXFUy21bdEtu6UqQMFeTQexTSGtrVHW+kng+eyNf0/CfZ4ojEPTcJ86PPjBqazJBequv7n3b1ZxWb7SnCWR1iVa2ytLRBZUxixfDTY7ABHYmEAeCP7tHY21shjDnnhyiWi21jiVj4BCF6elJBZHaxKUBYimG4/L6rDSqETnQiJFAuIlAC7YXqHzsJpq6omepfJwckmszidKnpaKSAMUIgMQLcOwazxtfpUFE+VLvVEdN6SrBe9eya0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tXIUZKT8KWh7vwxMFlEE0XrBFhoaK81Z2EsP1Eg2ols=;
 b=Jkmcfiby06VXQ1jSPQxa/OTW6LSK5avBF8BA5zYPu5LRKagVeEAqmomLQaIw2hNAl0WVbwijcWAXJStSuHZ9v+Svftz6zgcxMUtCj4TtZ4x1ARXCVVAUJm5+Qx9Cle8ahzmr9yu5u2r83ZGr8bxTHDoCUzUyn5X8Gc6XAzTKssI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by IA1PR12MB8221.namprd12.prod.outlook.com (2603:10b6:208:3f0::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.29; Sat, 26 Apr
 2025 14:53:37 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8678.028; Sat, 26 Apr 2025
 14:53:36 +0000
Message-ID: <a9db63e8-8104-dfbb-4a06-1d574ade518a@amd.com>
Date: Sat, 26 Apr 2025 09:53:31 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 0/5] Provide SEV-ES/SEV-SNP support for decrypting the
 VMSA
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, x86@kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>,
 Thomas Gleixner <tglx@linutronix.de>, Michael Roth <michael.roth@amd.com>
References: <cover.1742477213.git.thomas.lendacky@amd.com>
 <174562167852.1002481.1333824218465912701.b4-ty@google.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <174562167852.1002481.1333824218465912701.b4-ty@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0026.namprd11.prod.outlook.com
 (2603:10b6:806:d3::31) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|IA1PR12MB8221:EE_
X-MS-Office365-Filtering-Correlation-Id: 197ba483-ce74-47da-f7a2-08dd84d21f96
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aGZsdUFxVk1ORlhSVzA5eVF5dWlSQ0h1QlZOWS96VnNnQW9Ba0ZwTjZyNHh4?=
 =?utf-8?B?NmJCNTNITDdwUktMekp2anl5TWxMWlhoMzRFbk9GbmhtVER4Yk5qYjVuYjBV?=
 =?utf-8?B?Y3hLa1RjdXZmelVMWGo5cUZpVTd4RUVaR240VllhY0RONjRqZ0o1UmJxdzBY?=
 =?utf-8?B?S3QxVEZBQXN2R0dsY05rQjdFL2VzYWt1S0xrSTk4YmU0MDc3V2NCVWdBaVZh?=
 =?utf-8?B?VjRJQjRJSjJ2aWovb2c5OTVFSndHWEZDeXAyUURtZFBJcXRwNFRQaXF2a3ZQ?=
 =?utf-8?B?WitZVVhmQzJFbTJnT2RzT3cxWEdBOThZbXVRdkZKNnliR2ludGlWZUlJdVlC?=
 =?utf-8?B?ZExwam1odE42TEpSd3VXNmhpSGlpWEYxM1hEcVpYWUdBaVh0cWQ5a3pKR1NE?=
 =?utf-8?B?d1NLNjYrNkszSmphQUR6QnZzZnV2V29TdWxSWlZHeDJucXowK2xRc3dNd0ZN?=
 =?utf-8?B?SFFBWFdzV1RGY0F0bWc0SFpMN24zWldGZy9Kd1BnS2FmQ09mc2dkUytxaUZD?=
 =?utf-8?B?WCtrdVdrdU1qanB4eTZpTUtpdDdSTmNJaytJT3UvamZETWRIVEVXUytwNDlZ?=
 =?utf-8?B?enNHU0N3WjZ2K0h0d2xHOW0zRlFBYXFhWWVMQ1BiTWhVRHJEVzh3dHVKUWND?=
 =?utf-8?B?Z0hyUWNVRzlZYWZxRWdBYjJSNVZxY1ljNWpJNHl5cEpjZWNvdFlZdDRtWXda?=
 =?utf-8?B?T1AwS3VMOWFXU0lVMVVrRzg5YlpLaDI1K1MrZE9ldWo4a0JxNklBaGpmWmFY?=
 =?utf-8?B?amo2M0x5UHdiZUpYWjl1MS9WVy9LMEdLNElsMUtOQ0kxa0JEZlhxNmd5L1Bx?=
 =?utf-8?B?T0NLN2pQSXB0WEpnd3p3Tkk0UHkrVFlmTXcrUHZFVVVDVEw5SjFuRjZEaFlF?=
 =?utf-8?B?bzB3dDN3eTFmaTF1eDNIbW1SMGN1dUc3KzlYdTdiV2YzYWdzUlV1VUZXTDZ2?=
 =?utf-8?B?MGU1MGc5dFJSRndFZXdNUkVCdlFqdzYrd3hqVExvQ0Jvd25qWFZoU0Ztblk2?=
 =?utf-8?B?cENWTHIrdU45ZkpRNEczSUtpMWRLcTU4Z2hTcmhwcGxKbHgyNGx6VzQxV0hT?=
 =?utf-8?B?WVZnQlVZdytQanZHaHhNUjlrdWxXb2RDbHgrT0Y1M2k1VW12YUkxMVhjZ29K?=
 =?utf-8?B?RGdHa0dlTWFhZWh0c1hiTnFmNTU5OWs5Uys5TVFDeTFQWVlTUzk2T3FrNHFK?=
 =?utf-8?B?VEw2dXRyMVBmZitCWFJEbWhEQWpzd1QrNFNwL3l0d0NFbGYvU3lIYXE3SDd1?=
 =?utf-8?B?ZGo4VisvQ1JPZTAwd0lzd2UyZE0rUXV6UmxzUy9raGhLcHFQMGdwb25XTFV2?=
 =?utf-8?B?MnhNdGI5YnExclJwenV0cUo4OXhRUmdxMUpCc1ZNRytSU2s1ZjVzYlUyeFJw?=
 =?utf-8?B?alZIQm52U2R6Y0VhTzEveTlBN2t5bUh6MktBUkVOWHIyRmtHeEE3bTk1WEI5?=
 =?utf-8?B?RWhsNXBUVXZPZjN3MFhCbHBCYzlwUVBuK2tqTWxqNXhNM0lRUG1aQndHVHRn?=
 =?utf-8?B?WUdkVGYzc0RmWkladi9aRFpxYkhWQXZhOUo0MnNHdVUva0c3RUw3UlNHUzFn?=
 =?utf-8?B?cERDOEdtRGdJWHo3UGtLcUFkaHdNRXJHbGhqQjllZU90cVdEd0EvQmdIcU5M?=
 =?utf-8?B?MEZ5Y2lycGJLTG5WL3VTazlpMmVtbzdwT2xiNmY1cTJZVUhZSXVpTUJyUVFo?=
 =?utf-8?B?QXZxVklGcHlqUzZXcktuRzN4OFhYS2VSZCtxM0FhSDBqN3EyQlFqbUlMTzh3?=
 =?utf-8?B?ZjJCTnVjVFdvWEFGeTNYeDYvMmJiVkpSNXA4RGZPOXhpRUsrVUVZeVpYbkNy?=
 =?utf-8?B?VG9RT1hPczJrUXNCajlMcWhPN1RLVmJEclZub2t5NHhZd1YyU3dsQ08wU3Ji?=
 =?utf-8?B?d1V2ak9ndmEvVm5yVmplK1VhbnVXRm1pOHFXWTN6MU10YTlsNVlTYU5ubEMr?=
 =?utf-8?Q?UVLrSpYwwU5bajptxqSZHLSQt11VK3Hj?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WmVBMURlMXMyaVNiWGc1ZXZzSDY5QkVMOXgzazNCM0pqbFlmWHphODdrcWdr?=
 =?utf-8?B?TktvelM4eWxuUmM4cTB1Q3dQT2dZV2FNWXkxclFlWVVTR0hpeTJETi8zdkV5?=
 =?utf-8?B?Z1lBZ0EydjhZVVIxbjdxVDIxeHhmQ3YvTUF2TDJyY0F4a3FvWkR4ZG0zN2RU?=
 =?utf-8?B?VWJDQTJOR09oOHFrdTZoRysyTlpFcVR0K1NmZ2R0RVM5UnVuek4vQmlyN3ov?=
 =?utf-8?B?clJBQ0x1UURoQWZ4aUlGQjdRTFhzWW9neGM5TFhjckhJc0pyQ2x1TlF5SlNQ?=
 =?utf-8?B?c2UvUFdnaDdhM05ienN3VHFNQTliVjB0NW5xOEhlTmpCODZsbTkremFjNHN5?=
 =?utf-8?B?L3ZPM3ExSHQzRldwN0t3YjdibVR1dzVhNkxLV3UyRWVBbEpoRzE1RHl0VER4?=
 =?utf-8?B?YWI3bXpEZUFtVzZXZi9pSW51YUNaRWhpbHN2SUtTM1dyZjJIaEFGSElNZE9I?=
 =?utf-8?B?L3U3ak51eEtQdFVZZVcwUVlCN0lRSk42WW5wZFZLZmROR0J5UWFDMWxGZ0VQ?=
 =?utf-8?B?WUlrY2J2SGIyRUNwMURtNDdRRVhUaHhGcDc5Ti8rZTZReXFFRWw2Tkg2Si9t?=
 =?utf-8?B?VStSditBYjZMckVrak1LbG8vV0RJRUVmcUlVUTR2YWhHQ3VmcTNVaHFBVkxp?=
 =?utf-8?B?Y1R0QzgrbnpTNFpsbXRKTmxuZ1ZYM013djMyUHVjMjNWQjJ3WWUwQWJaUTFv?=
 =?utf-8?B?cWZKWUtqb3NrY0xHRENVL083SVpRYnRLQmlkdTlzVEU4SFFJcHE4bFVxVFdl?=
 =?utf-8?B?KzFpam9xeXUvSEhrekVtdjkxRld6TzdyWDBQaTBFaHpld21QR1U0cDJGakQ1?=
 =?utf-8?B?N2pMT2xqeVkxWTE4MWQ2N3pRUnRNNWtpcnVhemI0S2VrbGdDRWZMS3BmQlpW?=
 =?utf-8?B?Mk9tbVpyVHliOGVCaUlqQ3UrRWhvdjVvMkpFZm9FckEwYXJIRXFzZnZyWkVZ?=
 =?utf-8?B?U3JERjNnT0daNjNxQVdsb0J6VnJyUW9LK01lMlY2SG5hQ21XVXNpNEpTcWxW?=
 =?utf-8?B?SGNrOW5WLzYxODM3Q3A5OXpXd2FlQkhsd0VQWTZGNkUyQWFpZDhva1cxbWtJ?=
 =?utf-8?B?ZTIzSVRJZGladHZ1UlFUa25qcVdtVGljV2hIWHJ0cm81cm5kT1FrNFlQeWFN?=
 =?utf-8?B?R2V6SmVFMkN6Snh0WW5EdkFqdlBmQVcvVUJ5UCtIUjIrTVo1QzZLSVJkTnVp?=
 =?utf-8?B?MzhtcklkQlZKSXhmYjd0Y3NCSHdpMzFqbDliWW9oQS90TEprM1djL3J2cjA1?=
 =?utf-8?B?SE4wV0g2MTdoY251NitQZ1Vidmk0SHBoVDJIdTNzb0pqVVJRbEIyS2lVWEwz?=
 =?utf-8?B?RFdteXVlQ2IxbjBYcEhhV2hOYWFVVnkyOFJ2OXFYOThsWFZhT21XVU1VU3ps?=
 =?utf-8?B?U1JUVGl6V1hycUlNYWkxaWllTXErREExRk5veVRITnNleCtJN2tHWVJjSUdD?=
 =?utf-8?B?Q1RsWjRhcHE5YlB1dGw5elZjOTV6RzRwaStvVDYwSE1ha2Jubm50NFA5V1dX?=
 =?utf-8?B?SmY0ZnViMVNyQTBTUWJRNjVndk5IeFhoWnVmdDV3a1NGTkw5R3B1YWV3eFNC?=
 =?utf-8?B?TlFMM1BjalZhM0V3RU8yUHp2NnF0VDk1MGNOK1R1LzlSMm9zTXdXWUtHQUNL?=
 =?utf-8?B?NkZET0lheXpzNmxINW5KVFlkb2tZaWY4R3VzQlpLUU4zc3BEakNZMVVtM1Zn?=
 =?utf-8?B?RTVHQnoyenlKOFhaZ3hBWDZDdjMrTTNXdU1lb0ljL3RWLy9wdUtzL2JUYlZ4?=
 =?utf-8?B?UlUwaVlsYk5GL3RxSCtITDJGOUN0MVBlZkl3aXVSV1NKQzAzczBXOUx6Nkls?=
 =?utf-8?B?Z3JwMk1aNllWdGZTYUJJTHB5Z3ZKY0lvV0t0RUhobGpiZ3QvR3kwUFpoemFE?=
 =?utf-8?B?cGtuZHlnTUhoZXVLeEsxc1hSV2lJRS9kS01HREI5RXNabTNUYnNLRUV6Rjlh?=
 =?utf-8?B?SWhCdi9FZ0xIcXl3R1pldnpZZ1hrQ0dRUDBUUDBBMUFUVnp6cDZYa1FKWWxK?=
 =?utf-8?B?SndGRHo4RlN6dTIzdWpkbTEwdWRNaEM3OU45Rko0aHFoa3IyVTdhKzRYeXd1?=
 =?utf-8?B?bVJxSjdicFpSUXNXMWIvVnBQV1ZmNG0zYkg3M01vZUF5eDdYelJYMk5ieGtO?=
 =?utf-8?Q?foAzpp+yWT2GddmzoBh7hzog7?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 197ba483-ce74-47da-f7a2-08dd84d21f96
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2025 14:53:36.6791
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8wdbqVJ1a6ntQ7SD6tclFBVPbCk/PV/LdZGx9ZfKEaCw0+zByLKAP61Eng+f+4EA3C47QuUKkoODQjHWx+zhYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8221

On 4/25/25 18:23, Sean Christopherson wrote:
> On Thu, 20 Mar 2025 08:26:48 -0500, Tom Lendacky wrote:
>> This series adds support for decrypting an SEV-ES/SEV-SNP VMSA in
>> dump_vmcb() when the guest policy allows debugging.
>>
>> It also contains some updates to dump_vmcb() to dump additional guest
>> register state, print the type of guest, print the vCPU id, and adds a
>> mutex to prevent interleaving of the dump_vmcb() messages when multiple
>> vCPU threads call dump_vmcb(). These last patches can be dropped if not
>> desired.
>>
>> [...]
> 
> Applied to kvm-x86 svm, with Tom's fixups.  Please double check I didn't botch
> those, the last few days have been a never ending comedy of errors on my end.

Everything looks good.

Thanks!
Tom

> 
> Thanks!
> 
> [1/5] KVM: SVM: Decrypt SEV VMSA in dump_vmcb() if debugging is enabled
>       https://github.com/kvm-x86/linux/commit/962e2b6152ef
> [2/5] KVM: SVM: Dump guest register state in dump_vmcb()
>       https://github.com/kvm-x86/linux/commit/22f5c2003a18
> [3/5] KVM: SVM: Add the type of VM for which the VMCB/VMSA is being dumped
>       https://github.com/kvm-x86/linux/commit/db2645096105
> [4/5] KVM: SVM: Include the vCPU ID when dumping a VMCB
>       https://github.com/kvm-x86/linux/commit/0e6b677de730
> [5/5] KVM: SVM: Add a mutex to dump_vmcb() to prevent concurrent output
>       https://github.com/kvm-x86/linux/commit/468c27ae0215
> 
> --
> https://github.com/kvm-x86/linux/tree/next

