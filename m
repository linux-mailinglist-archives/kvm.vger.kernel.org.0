Return-Path: <kvm+bounces-38769-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D61AA3E3D5
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 19:28:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6484C16CC58
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 18:28:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B844621516A;
	Thu, 20 Feb 2025 18:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="I+zEwrKJ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2086.outbound.protection.outlook.com [40.107.243.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 228C4215049;
	Thu, 20 Feb 2025 18:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740076071; cv=fail; b=d7HI8JyK1yUDd9K9HuYiccSCH1hcrMxB4wss+IABhB9ycN7LqH79VBD3cmw88iwNA4hRj/cJfRhCbf+I5oTR4GKToJqI+q1eEBbtpu41Plfwl3QJLOMdsKAfePfAUzss4NrDVed042cQBRv0XddoAVgsC5icbFnEZCI9D7o6hmo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740076071; c=relaxed/simple;
	bh=csNWN1E1EDaD5WD5shH+EmYpMBdyGoxFggA6EcyyBmk=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=DUdVpTAmQfeJ0NqALvD7RS6l9KGDgyTWHlw6FR3XeraQ4Co1yEbc7+JSo42MIKaIV/VkLitJ+SO5xQvIIEgB2eS1y2cu8ssdOPysgZUTcEotX2zqVhRIP8benFT5GRHba0SzSoFfFDBKJbhtouVItIgEqYDkZAibTqa+G5CFiRI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=I+zEwrKJ; arc=fail smtp.client-ip=40.107.243.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F2x69pDgIpPrlI8NDZFVVplWMVxYkZsH8/ucnpXDS3bD3Ijy9D1tpibGFe+xLxnJLmIVMRF7tkUjkXSndml374l/XxZ0/KIgqJtT8Ed3QSNJtPVE80LriNgF25HADuopUKp0emg3hmOQkWNJGUR59xG7V2Nl+Q23qxqi1SmHMNJGLH0rexDzu12WQlrvs9+fsH3EKc56wfutQie6KU2mo/5VBIOljylkFYQW1J6uLCOjPemZlYX8t8nm70AbcjmMlK5RZuucI5sen9DbN+8YuKRo7KZNjwDe8Mva7uuzZIeVyT4lNM+t4cYQhE5D5X05aYfLDRXQYREJ3m/XoKXQJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3TPaGxGrlyVcobf/564HnpxFSApcr8IEwNmaQ6xFT1I=;
 b=K7V3w9k6ocszNv1hzW8rGx10vwkCbf1y1QfUbGDO0qmJ5Nymco+UwrsMYdfQai+yJuBulyEz/JyvujVP5qLcRLYMpiQIO5KYp2jmfqVfzSLHcURJiDUJHDzo0gXh8GN0D/JYcVTFXDEseIyI9xVxZEtjHsSngzlu0yhkGNOQL8Gu3pbeD2ohE+cBdEUHO3YLkOhnOlEDfRpAtbqJm7KsTsy+lEsMuqGMiF26Z3m811CPm22VPMIkMr1sTWWS+Ylih05Nu4etR/8j42gentM4X6jMP8PeHDt1AbWWEHiIb11xcQG41md9d840uOFhRLgYUaOx3ZVFABdjsN66RnatZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3TPaGxGrlyVcobf/564HnpxFSApcr8IEwNmaQ6xFT1I=;
 b=I+zEwrKJoJnEHFXI9uYzCqAAJOpCaY0a7fpgGRgmeazkKUIqBwBf0gq2se7wI0EHvZ0lPZiagq3SmKeNt0PGC1snNknIwI+JWJe7EtK90AUa02BbQ8b/F5sUJ49470B3AEItB2880fjf/06+J/Lw5pGHHvrUscuj+RXSCy+yaWU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by PH7PR12MB7330.namprd12.prod.outlook.com (2603:10b6:510:20d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.15; Thu, 20 Feb
 2025 18:27:46 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8466.016; Thu, 20 Feb 2025
 18:27:45 +0000
Message-ID: <452b7748-9b77-fc9c-f24b-2930af92a5af@amd.com>
Date: Thu, 20 Feb 2025 12:27:43 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Ashish Kalra <Ashish.Kalra@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 john.allen@amd.com, herbert@gondor.apana.org.au
Cc: michael.roth@amd.com, dionnaglaze@google.com, nikunj@amd.com,
 ardb@kernel.org, kevinloughlin@google.com, Neeraj.Upadhyay@amd.com,
 aik@amd.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1739997129.git.ashish.kalra@amd.com>
 <5fe0faa1070d5225c19e3df207825d0e337ee3b9.1739997129.git.ashish.kalra@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v4 1/7] crypto: ccp: Move dev_info/err messages for
 SEV/SNP init and shutdown
In-Reply-To: <5fe0faa1070d5225c19e3df207825d0e337ee3b9.1739997129.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0170.namprd11.prod.outlook.com
 (2603:10b6:806:1bb::25) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|PH7PR12MB7330:EE_
X-MS-Office365-Filtering-Correlation-Id: 00791f14-561b-4887-19d5-08dd51dc457d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dG1yMmxCSHQ3QkdJOHZyV0hFQlJONFdIaEtwRzFrYmlMSHZ2S0ozdi8wb3dz?=
 =?utf-8?B?NGNLaS9TL0NrazdHUGZPWER5N2NTWXIwdUJKYlJuTXR5ZW0vYm81dWtXU3Zi?=
 =?utf-8?B?RDU1NWN2OWsveUZxRmNuak9WeEhXQ2tqTVhlUTdTYmE2aGdsekxnWDFDaklw?=
 =?utf-8?B?VXFGd0l3dThaNnFPYUQ0WFZpOFQ2WUQ2cThOR1FBWHk3UFlLTkNPS1E0UFJ5?=
 =?utf-8?B?ZGxwd0FINE1JL2xMOTB0MFdzQllqNmcyYWVvbWpKdysrQWRFVjE0bjFxTWpU?=
 =?utf-8?B?aDZNSFRHWlBoVHJzUFA4ZEdsN0ZHOE5wRU5IY2VSVUVEc0E1UCswUUxNN1Ja?=
 =?utf-8?B?cnlDV0hNN0pkN2hRc1JkL0xxOXJOcU9UY0Jld09WbXZyODcvZUF5S1NqUUhU?=
 =?utf-8?B?eDdhcmsyVzV2VFZpNWd1VTQ3QVZ1Y3VyNDgzSWRTVGltSnd3cXBYZUhpMVZy?=
 =?utf-8?B?MVZqQm9NLzBoTHV3MjZvOFRvN0kyZnVvbzNvMHMyWmZlT0JSb3ZUN0VueHR4?=
 =?utf-8?B?VDJRa25ML0JIWStIbUtOTHdteUl0VlNCRHlLcEFuZ0tPMkxMS2E1UW8rdW84?=
 =?utf-8?B?TDNjRmc5cTNwL1U5djMrbWg0MG5EUFNCUENHSituWW9HNnhhcStwTWFaYWVr?=
 =?utf-8?B?bU5rQ1ltSjhwMWdLRnVEckUrWHorY2RHMHVpdjZtK0V2MlN5dXhWa0pIOFE5?=
 =?utf-8?B?ZFZBNk9VOXFwY3VhK2pYMFlSTVVld3Z1ekxodjU5NmZqWmdTK05abFp4N25o?=
 =?utf-8?B?QXJ5VlE5MXRqaUNlQXRKMnhFMlJ4cTdxV1hOR2hOdXdxWGdPbmE2WmNnUUdL?=
 =?utf-8?B?YlIvajJSa2FxNUc0SG0wODBGczRGRDlJWHl5bGpaRWxFYVFvamNBZGRYbEJj?=
 =?utf-8?B?eW52bmtFV3Rnd3ROdnBhR0JicUQ0ejFnUHVqMCtydjdxS0JTczZMd0pySlpE?=
 =?utf-8?B?blVpMjVoQ0tVZm41Q3dvQnJub2tXWkI3Q3AwR0w0bVJIQ0pnV1pCUTRRSS9U?=
 =?utf-8?B?SExXVnFoQWkrd282YmFIbmJYVmt4Q2czeEdobHI4alVTUGtCazc2bG91TlZo?=
 =?utf-8?B?VzdUekVWOXNramdsS1VmZU83dUlRNGRCUEJUNkFjSW1OVTYxN2hCRCtUNUNt?=
 =?utf-8?B?TURuMUdLQXVPUkhxTURLMHA1cFA0bG5paWFEcUlITUM3L1JNTHZGYnJqcXp5?=
 =?utf-8?B?YmxRTk5tdGtzUytZdHJDWWhWR0hGbjdZdk5CQ24zRXFQQ09VaFcvcGs2eTZK?=
 =?utf-8?B?TmIvdXpXWUMyK1cwUWliS0pKT0xwbW1aQ0p1RFV4YnVSSE1RU2w1Nis4Z2xF?=
 =?utf-8?B?eTlJYk4xSTRtS3NKMlk3RnQ5TytLdWtPZGFhaXNRT1A5TEQ4ZmZCV25ud1Nz?=
 =?utf-8?B?L3JwVW14Uy9LUXZrbXZKcjIvNy8ySDArYzNVam1PRDJ6V2F0a3hMbW0rSndl?=
 =?utf-8?B?SGI5MHBJN0lTZ1FEVEpDeWFjMTh5VjlqYkVieVd4aVZ6aTJUZmJEMldNZXV4?=
 =?utf-8?B?N1h2WCswNElRa3BtNk5ZdGc4Q2xzbjJTVDhkbitGS0F1ZExTQzlLL1YrT1lk?=
 =?utf-8?B?d1JrVXVNZmowUmthbTNIQ21tb2ppZjUxNFhxSnYzbXp1VkNHSW92OUJXSUtv?=
 =?utf-8?B?dzZ4QXJyY2toYThuakNNNGZMZURwR1FOTGFyTDlFMzd3VFBuVFNQeFhqR3k2?=
 =?utf-8?B?bTRJamtLYnMwcCt6K1FwZ1VISE52OS9Kd2JHclkrcFJDcVVnTWNXenpqSlBY?=
 =?utf-8?B?Wk1ENmJBdksyNm8ya1UxZE5UdmgvMUtsZ2NXeWVyTVlzWkVNTGdVV0NFbkpZ?=
 =?utf-8?B?UUdWQ251enYwd2wxUDJSVnA4RFhvdlpFbDFVZ3d5WFovdDBtd2JUSkVaRDNG?=
 =?utf-8?B?c3YwT1k1czhNWWhKU1ZGUURkZGVYME5DWjJTcTVJN3dKSEZtdkZVaERHUnVJ?=
 =?utf-8?Q?/5Ie60CfIy4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M3liaW5MQitVMEVuMVQ5c2xOWkVONlZzZ01aMEJpanArY2FkU1VjZ3lnU0lM?=
 =?utf-8?B?TnFaZmNJczNJUnhtdGV0MElhVkl1Q2t1aWtYcXZrMkNwMGJKUTFLa0U3U01D?=
 =?utf-8?B?b1YxUzdaWFp6d2VXYW9WMTZrc2UxYXpMMVVxYW5zcUNQSk1raklZbDNLNWxq?=
 =?utf-8?B?ckdsNFBlQ3RmbGZBNm9TMU1lb1h4NFJScjJWMGY5UGZOWlNhNG0xOTNGVGxX?=
 =?utf-8?B?QUV6TXhOL09CZDVLRzRiaUxteXhpYkF0b1ZPKy92cXZ2TElmbVR0bkcrWldX?=
 =?utf-8?B?ak9HZGNYQ01mNUovKzVxMHE2b0FEL3RjMkVudVZnNlovTWgrRHlOSk5tTXRo?=
 =?utf-8?B?d2lQR2Z4UXhaR1lxZEt0UnpZSzVteTg3VDc0eTBwWExwenRBeHpVenZkQXlB?=
 =?utf-8?B?MVIvVUhpbHg0amdPdEtCc0ZzY0VpUGsrUDVsenFxaUJtY21CdXhqWHA4eFYy?=
 =?utf-8?B?dmh1QWJiQjNNZCtzVng5bGpNWWE0ZkZGR1Y3VUJuVDhKMzF4MUtkWHFEaElK?=
 =?utf-8?B?dlhlN21MZ2NlVitHeThFOWtKUHdpZWlNRjArTmVzQW5UTnhkWjhiTFJLdkpP?=
 =?utf-8?B?c3dzM09Sa2M1Y2x4aTlDZzNKQ2RrdFBiTlZwekhsMEF2c2xVeG1YaUorSEVp?=
 =?utf-8?B?QlJGUTlEUU1YK0Nac252cytQK2VPNzJRN2g5dzRQbjJuU1I5RUs2UHhqNjBS?=
 =?utf-8?B?eXh3Z3BONHRocG9OM0VTTVJFRW50SDRTc0s5a1QzR2FZMXNUTzRKZ0hzTVZV?=
 =?utf-8?B?c081TEZpVFhlQ0JXTFZ1dGJnenRqK2ZNblNadkRZRjh2ZjBhTVN4UGFmWWF6?=
 =?utf-8?B?dVh3NkhhVlJuWXRka0ZKZUpHTSs5LzB2a3BnNFlGNVpMcWJ5eWdud1RWYTdk?=
 =?utf-8?B?MkJkT1NmNTFjVDY4dGhac2cxQmlVVVk1cUtCZlFldGJBcnE1bEExMlpGeWR1?=
 =?utf-8?B?S2t5SUJrVE12SUFUL1JuTnozZ0t2b2VPS0g3SGdEWFZqbmV3dURobHFTN2th?=
 =?utf-8?B?Z0ZlU1EyVUdyVUc2SUlVYlU4T3RXSm4zbEIzekFFaVYyR09KYU1kdUlBQlBW?=
 =?utf-8?B?SU1oK2hsUkZ4a1NDUmtzVTNtOGlFRXAxYmg0SHFSQ2lFVmR3MVBXWmFVVVln?=
 =?utf-8?B?N3FZeU43aGFuV1ZkRklFZFVTSVRNZEgvZk9ORForWWFyKzlTaUZhbW80NjlS?=
 =?utf-8?B?QUxYeFIxMytYVTVCN0xWb0RoMjV1SituczVSL1BjaWszQkpJTXFReFJ0LzFs?=
 =?utf-8?B?R1FiQTJHdlNxZzdJWXBtZ21EMkhPamtaR21EcEZKUHozQ3pJZG5hVE1qamtR?=
 =?utf-8?B?ZTdVRDVORHplaTNuemZqOU1JUU4weGMzcmVObXBrUXVERWNFL0d5WHJpMGNH?=
 =?utf-8?B?SmZlTytWVnNvQ0VndzBZbUxta3ZObkpjYzAwTUJXZmpmeG5XTVJYYWxlbTEv?=
 =?utf-8?B?TTJ6VTByZDBHU21vVHU4akN6bWVYSnNzaG9lM0NzVHpqT2tyYVByeEt4eHVv?=
 =?utf-8?B?QUJCNlFSMTdWbDA0ejc0anVITk5NVWxZOWpWcUgySlM1OTZENUZCWXFpRS9o?=
 =?utf-8?B?SFNYRW5YOVk4Z0tNamVGeU1XeU54N3ZVQ0RXRzIvbzV4Sk4ycjBRVi9pNlJv?=
 =?utf-8?B?Z0pXWXhxZFM3cWlWT2oxTktaTnZQQnBTVWJCVTVzRmdvN2IxQkp2RU9weTFB?=
 =?utf-8?B?dGhIOEg4QzNRRjlDdCtvZ1JTa09Hd1ZmRlhkWHRnZXdFWC9VbGtuVGttZk54?=
 =?utf-8?B?WlZyMXdhWXQ3ZDFESEthcWhLcS95ckhLUm5uT1lrWHBKTG1VVm00b2JzQTh1?=
 =?utf-8?B?UkkzYnUrcFNzeGJYNmZ5UVAwMzZjZUhOL0lYbTlpVmtTMFhxWTcyMmlrUFlN?=
 =?utf-8?B?UGpqaUtmTjd4c3p1SE1US3VCRFBlS3BGL1UrNlNtZ3NzS0JXSlFKMkpDSkNu?=
 =?utf-8?B?R1hlaUY0S3BiVWRFanlsd1RmNENPVnNDOUZLYm81ZTA1VzdKcVg4SUl2YUtv?=
 =?utf-8?B?U2JxWXdHaVFnN0t1N0dvQm9lODFnZEJ6cEVLc1krL0l5SE04MjZ1TFJvK2xu?=
 =?utf-8?B?bXRwVUZTVHVkRXBWZ05oL1Boc28waFFObmxXRDdzaTJHQjB2ZUFWd0ozVWY3?=
 =?utf-8?Q?iDb97SaxpbUKQ+95PPqECQZzb?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00791f14-561b-4887-19d5-08dd51dc457d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2025 18:27:45.8770
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uP3sUw9D8Go+fyv19w2qmg2dGNxkpPr+rksz+od69rdw2DNIHNalCPeSzJCUOct0gRPTZh7LarogfgEF/U2K3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7330

On 2/19/25 14:52, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> Move dev_info and dev_err messages related to SEV/SNP initialization
> and shutdown into __sev_platform_init_locked(), __sev_snp_init_locked()
> and __sev_platform_shutdown_locked(), __sev_snp_shutdown_locked() so
> that they don't need to be issued from callers.
> 
> This allows both _sev_platform_init_locked() and various SEV/SNP ioctls
> to call __sev_platform_init_locked(), __sev_snp_init_locked() and
> __sev_platform_shutdown_locked(), __sev_snp_shutdown_locked() for
> implicit SEV/SNP initialization and shutdown without additionally
> printing any errors/success messages.
> 
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  drivers/crypto/ccp/sev-dev.c | 39 +++++++++++++++++++++++++++---------
>  1 file changed, 30 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 2e87ca0e292a..8f5c474b9d1c 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -1176,21 +1176,30 @@ static int __sev_snp_init_locked(int *error)
>  	wbinvd_on_all_cpus();
>  
>  	rc = __sev_do_cmd_locked(cmd, arg, error);
> -	if (rc)
> +	if (rc) {
> +		dev_err(sev->dev, "SEV-SNP: failed to INIT rc %d, error %#x\n",
> +			rc, *error);

How about doing:

	dev_err(sev->dev, "SEV-SNP: %s failed rc %d, error %#x\n",
		cmd == SEV_CMD_SNP_INIT_EX ? "SNP_INIT_EX" : "SNP_INIT",
		rc, *error);

>  		return rc;
> +	}
>  
>  	/* Prepare for first SNP guest launch after INIT. */
>  	wbinvd_on_all_cpus();
>  	rc = __sev_do_cmd_locked(SEV_CMD_SNP_DF_FLUSH, NULL, error);
> -	if (rc)
> +	if (rc) {
> +		dev_err(sev->dev, "SEV-SNP: SNP_DF_FLUSH failed rc %d, error %#x\n",
> +			rc, *error);
>  		return rc;
> +	}
>  
>  	sev->snp_initialized = true;
>  	dev_dbg(sev->dev, "SEV-SNP firmware initialized\n");
>  
> +	dev_info(sev->dev, "SEV-SNP API:%d.%d build:%d\n", sev->api_major,
> +		 sev->api_minor, sev->build);
> +
>  	sev_es_tmr_size = SNP_TMR_SIZE;
>  
> -	return rc;
> +	return 0;
>  }
>  
>  static void __sev_platform_init_handle_tmr(struct sev_device *sev)
> @@ -1267,8 +1276,10 @@ static int __sev_platform_init_locked(int *error)
>  	__sev_platform_init_handle_tmr(sev);
>  
>  	rc = __sev_platform_init_handle_init_ex_path(sev);
> -	if (rc)
> +	if (rc) {
> +		dev_err(sev->dev, "SEV: handle_init_ex_path failed, rc %d\n", rc);
>  		return rc;
> +	}

Messages should be issued in __sev_platform_init_handle_init_ex_path().
The only non-zero rc value that doesn't cause a message would come from
sev_read_init_ex_file() when sev_init_ex_buffer is NULL, but
sev_read_init_ex_file() isn't called if the allocation for that buffer
fails. So I don't think this message is necessary. But double-check me
on that.

>  
>  	rc = __sev_do_init_locked(&psp_ret);
>  	if (rc && psp_ret == SEV_RET_SECURE_DATA_INVALID) {
> @@ -1287,16 +1298,22 @@ static int __sev_platform_init_locked(int *error)
>  	if (error)
>  		*error = psp_ret;
>  
> -	if (rc)
> +	if (rc) {
> +		dev_err(sev->dev, "SEV: failed to INIT error %#x, rc %d\n",
> +			psp_ret, rc);

Similar to the SNP INIT comment above, how about:

	dev_err(sev->dev, "SEV: %s failed %#x, rc %d\n",
		sev_init_ex_buffer ? "INIT_EX" : "INIT", psp_ret, rc);

>  		return rc;
> +	}
>  
>  	sev->state = SEV_STATE_INIT;
>  
>  	/* Prepare for first SEV guest launch after INIT */
>  	wbinvd_on_all_cpus();
>  	rc = __sev_do_cmd_locked(SEV_CMD_DF_FLUSH, NULL, error);
> -	if (rc)
> +	if (rc) {
> +		dev_err(sev->dev, "SEV: DF_FLUSH failed %#x, rc %d\n",
> +			*error, rc);
>  		return rc;
> +	}
>  
>  	dev_dbg(sev->dev, "SEV firmware initialized\n");
>  
> @@ -1367,8 +1384,11 @@ static int __sev_platform_shutdown_locked(int *error)
>  		return 0;
>  
>  	ret = __sev_do_cmd_locked(SEV_CMD_SHUTDOWN, NULL, error);
> -	if (ret)
> +	if (ret) {
> +		dev_err(sev->dev, "SEV: failed to SHUTDOWN error %#x, rc %d\n",
> +			*error, ret);
>  		return ret;
> +	}
>  
>  	sev->state = SEV_STATE_UNINIT;
>  	dev_dbg(sev->dev, "SEV firmware shutdown\n");
> @@ -1684,7 +1704,7 @@ static int __sev_snp_shutdown_locked(int *error, bool panic)
>  	if (*error == SEV_RET_DFFLUSH_REQUIRED) {
>  		ret = __sev_do_cmd_locked(SEV_CMD_SNP_DF_FLUSH, NULL, NULL);
>  		if (ret) {
> -			dev_err(sev->dev, "SEV-SNP DF_FLUSH failed\n");
> +			dev_err(sev->dev, "SEV-SNP DF_FLUSH failed, ret = %d\n", ret);

Should provide as much info as possible, so create a local int variable
that you can pass into __sev_do_cmd_locked() and output that in the
failure message.

(I should go through this file later and make all the message formats
consistent.)

Thanks,
Tom

>  			return ret;
>  		}
>  		/* reissue the shutdown command */
> @@ -1692,7 +1712,8 @@ static int __sev_snp_shutdown_locked(int *error, bool panic)
>  					  error);
>  	}
>  	if (ret) {
> -		dev_err(sev->dev, "SEV-SNP firmware shutdown failed\n");
> +		dev_err(sev->dev, "SEV-SNP firmware shutdown failed, rc %d, error %#x\n",
> +			ret, *error);
>  		return ret;
>  	}
>  

