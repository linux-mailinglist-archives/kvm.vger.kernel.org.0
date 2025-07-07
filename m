Return-Path: <kvm+bounces-51681-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 174A1AFB887
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 18:20:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 705E7189F850
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 16:20:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0489621B9D6;
	Mon,  7 Jul 2025 16:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="AXHxErwt"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2065.outbound.protection.outlook.com [40.107.237.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D3C41E379B;
	Mon,  7 Jul 2025 16:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751905202; cv=fail; b=cFf9N0vh5SV6FhC4zEUvkGIy3Jy9hYa0MklWqqDreSkO2kD3+XkywPiXM9eH+9cNGgzCt56K/j/W+0FkgdjYXLTtSCpCROX6Zr6/ez9ptbRUzfU47cshCDwE09O16g6idapjaUgj4NF+mmPfEoeHpPwIXc4sQg3apyAU0deC1M0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751905202; c=relaxed/simple;
	bh=Agmroa7ordAUddmep+O9s8wZXuPvIV2sBw3zzZiBcMY=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=KLl3ue3rEWSnj+tkeZgIvvJEz5dN7RKLBk5/IZvAHAL2Edw20l0iRdXj2bdywv3QAVZmc9sVsJbAeZLQ3UrakWKCBpVB6olZIY2JfGvJLh8kl69ffYqS3U/9YwgCCJiSLmOqDSjyuBOnVRyIP0gmDwH08S8YayiluLaxJEnD17U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=AXHxErwt; arc=fail smtp.client-ip=40.107.237.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lrAtel/QMgXWcPgPCDq14TcjLX+nMoWmd7vmaz3n1VRqQCLfknfokwKc+UQf195ox3EyX3Njz7tVWE8Hyhq4XbNCfhxPQo3RTMuXQrKyCpLxoMAwIp4ROMY8z5AlUGl+fnHAqo0ZnFxUcWFZWx4f768exIG5l967FvFyJmLzwXD5NSaCUD/1XA7mYPvg44a9tbqApI+GD+yUhXNeIR8TVDilK4N2vgYmEZDjl+53xqnp5/XH73uspZRXmvcgKQBvpOINqAxKSIv9ebVaYZE8vuCrECmOAoRH2u1Y7BCkxV4DhLjTRXqmwGihNXJXGEFtHimkUpyuCB5t/KeiXbP+Vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oE2pDpV533al+5tGgHmM9CdsmRbNRqAGkPM/NU1cmqs=;
 b=o1Hg50BW8Q81/q7HlqvpNofsjS8NoE2aobhcM0jOw8Mwlu0iNhhjeO6wO4R2wyXxZheOANn5G0WnjypEkm33ScC5SUSXZCQ5YdHQNYJY2fgbu/w/XP+Kd9NvhZw5NqgHAbg4uhI8lJBFtJvNz1z2Kci03XXno79Eun91X8RcJy4grx1qATMp6+lX1H01HJIKc0MPGRPeB0suw+Xjk/vltwoZ1n94/aX3zqx3lGfWtRBoOb42MTMiP7qpPr/00z1iBQE8JKEZsP+Gs/ZZn8N4RPtVCQ09y22iivshM4qOUmplcAnmAWVQs12NnP+/4GY0asxzwAQ+N72b1Srmf7wvJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oE2pDpV533al+5tGgHmM9CdsmRbNRqAGkPM/NU1cmqs=;
 b=AXHxErwtcLN77egjlOqrP8RE8DoRwWHLjtmyJlIsAWovnS4/ZDt4TGor1HH/6cY+dLtMhiLZV6JtntOwDDpp0IhVfYuKgow3EKdkhym8C76mH5bwnI3vUKWDqi0WJ2dO8Hlw9je18COtRlQq6TMnCtjEqsTUyvCaYy/s6pT68hw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by SN7PR12MB6765.namprd12.prod.outlook.com (2603:10b6:806:26b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.26; Mon, 7 Jul
 2025 16:19:55 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8901.023; Mon, 7 Jul 2025
 16:19:55 +0000
Message-ID: <b024fc14-47f1-c5a4-078c-9ad4e81817b8@amd.com>
Date: Mon, 7 Jul 2025 11:19:52 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Ashish Kalra <Ashish.Kalra@amd.com>, corbet@lwn.net, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 john.allen@amd.com, herbert@gondor.apana.org.au, davem@davemloft.net,
 akpm@linux-foundation.org, rostedt@goodmis.org, paulmck@kernel.org
Cc: nikunj@amd.com, Neeraj.Upadhyay@amd.com, aik@amd.com, ardb@kernel.org,
 michael.roth@amd.com, arnd@arndb.de, linux-doc@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
References: <cover.1751397223.git.ashish.kalra@amd.com>
 <a93e3912accb6c3b6d66b748f0045bd9e147c800.1751397223.git.ashish.kalra@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v5 4/7] crypto: ccp - Introduce new API interface to
 indicate SEV-SNP Ciphertext hiding feature
In-Reply-To: <a93e3912accb6c3b6d66b748f0045bd9e147c800.1751397223.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR13CA0047.namprd13.prod.outlook.com
 (2603:10b6:806:22::22) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|SN7PR12MB6765:EE_
X-MS-Office365-Filtering-Correlation-Id: 1dc0dca2-68c6-4578-e7b7-08ddbd721c1e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UHE4ZDZ0SmppaTlqQUVQbmZTaVBYTEhrMDhLS2NXVVVtTTV2SytTL3N6RWtm?=
 =?utf-8?B?VUVqdWxQbTBtVkJXTFBxdWlFOXhsK0s5U1UwSkJnbXQwQmE1ZVRaMXRyU0hJ?=
 =?utf-8?B?YitJeXpoaW80bk42aFlLWUpEQUxVMzNoK0swbEZHZit0cFVEMGpLV3U2WUhU?=
 =?utf-8?B?WkV4MDlscHYzNGNEZUV2YmwrTVpBanZhRVRSNWFQdStlNXVGK1NnTHNCQ2Ji?=
 =?utf-8?B?TUdEN1VIQlpJK2dWSnFJWlNCR2gyOGhYYkNaeXpCdk1lZVZwcENhWUZ4K1R5?=
 =?utf-8?B?VjU3dlg0aGlUTDNETVJCS2RJY2wrcENkMmM2ajVzbm45QXRDQ1BzanBOaHZG?=
 =?utf-8?B?QXZMM0R1cGdEWFg0dHVWMDVydXBCOG0rcE0xd29ab29adE56SERDWk45TXI0?=
 =?utf-8?B?bkdOZDNsbkJtZlZYclZmdjd3MHZzVlZuT3cyR3ZoVHI0WDJOZi9UQXRrWmxw?=
 =?utf-8?B?M0V5Mm0rSERHYS8vdkQxTTF4bXhYbzhwOWhnOXFaalpnYmxuekpERFFOdWhh?=
 =?utf-8?B?eWZ5dklDM3BXbG9IQ09Xemh1bHpMN2ZrYjdZM05JOGhxc0lFYXNFbFZmN0ha?=
 =?utf-8?B?R1pGbmpGZ1pURUdiYnVmY04rSkZLaDFCa28yeDU4YnRWcmRZdkpHNGkvbmNw?=
 =?utf-8?B?RmxranJCcTU0NGxla3lTdmVva0k1TExGZUhKQXBoVjVzaGtRcmJVQjFVYTZZ?=
 =?utf-8?B?SHB6T24yczEwL0JqelhNa2pNNWh5emlpVHRFMVY1NEtzVFA2dVV4aFo0YTVo?=
 =?utf-8?B?dlkya3QyYU01UWtyVGIzRDdzczR3K08yOUprUzBuelJjSkNUWXpsL1RvS2pn?=
 =?utf-8?B?TUNIZWRaT0pkZFJFQlprd0ZBVTRmSjVoNzZhbG1oYnQ2L3BITXZWZ1ZxMFhz?=
 =?utf-8?B?SVhNVVEzaElMaC9PcHFxeGRmdEtWdWxCZ2U1K21na2NYUWRwUXBSN2xEVzE3?=
 =?utf-8?B?T0RUQ2dVencxSkU5eklvRmpRS3JnYTdackkwcUpjUEZtRndQU2pPVHNVMFd5?=
 =?utf-8?B?VTZ3a0E2SXErZEpUT01rODdGL0lMTFlNV1A1VHh1cERwcHFmeDNXRVdZeXIr?=
 =?utf-8?B?b284THlhdFpCMnBTYzFWUXF1SWtDT3YvUWN4ckJFdGxtZytZeTA5QlR4d1cr?=
 =?utf-8?B?VGVqOTB2Y29wK3FYcEpWcTBlR0NrR3RJUjdHY0d5ZFZaUnVKV1ZxWTdrb0tK?=
 =?utf-8?B?RWtlOHplNVVOdHRPK21uTEN5NGtXTE9Fd1pEMUxsMG1xcW1tZHBDaWFjUndM?=
 =?utf-8?B?cUhSN01VK05tMkR1ZS9tMXlQMjQ1QWRxVDZ4OFVEN1ViRXFSLy9PektvaUZp?=
 =?utf-8?B?U2NGR01CaFdLVHZ6Nk4yVFQ3bmdBT3Yza3RpZTIvNU81TnBRMDhRa0pmakcz?=
 =?utf-8?B?NzFHOVFYWFUxQktySysxUFhXaUd1N25IOGRMRDVZNlpNUlNVeGN2Sm1tc3BB?=
 =?utf-8?B?ZDZ5blY4OVlnR1pDb2t4ZkY5V2hDMDh6dzlBMkRMMTR5anV2MGUwU0hMQWxG?=
 =?utf-8?B?V0RtanJvenJ1UE10YTQ2UEEzaXNOWTBTdDZCZEJXVG9PVEI5T0NlWlp6TDM0?=
 =?utf-8?B?UjNieHZuQkpmRGJTdnVnRkd3ZjhMVHZkdTBPTWYwQ2piTGZIN2J2ZWZVNGo3?=
 =?utf-8?B?THRvY1ZvbnpyOXRNOG1nTForK2dqeHA5b011c1ArbXBxYjQ0QjRrRTZlMXRR?=
 =?utf-8?B?SDVkYlVZcEVhSjI3c1h5eXpMSlV4VTU5cUk3SXJsSnJoNHZwK01WUzhSaElN?=
 =?utf-8?B?cmhFYUdtRlhSMmRFNFpkcHdkTkFhN3k5SzNCMUtYSCtCVXVSREt5VnU2NkdC?=
 =?utf-8?B?RmdpSllZell5Zy95TW5QSGk3NHJZZkxjMW1zenF6OXN6N2YzRjRqYU9IRDFT?=
 =?utf-8?B?eTVoS1FYTGlGZ253TmNQTFc2dmR4cFpMaTVCeFBnSTY1bkZsSk8xc2xDRlRQ?=
 =?utf-8?B?VExoWHB4WGdHaU1HekVwSGRCU29ESmcxenk4U0EwaDRmRWNyUTdpQVVOZFhx?=
 =?utf-8?B?TlhMdSs3bERRPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?V3JWT0hjUkZRdHArZEV2d0JMMkM1elJQcGwxUWFNbjVyN1JweFI1dkxqWHY0?=
 =?utf-8?B?b2RZSkhjMThYZk1RRU4raGVPYkt0SU1Cdkt1cDVhWmtKRzAwZVVkQk9PMkYy?=
 =?utf-8?B?WkxtNGF5US9FSmx1VW9WdUNDRUpYbDh5QWI5c1FVK2o4YllWOGFsM25CcGpw?=
 =?utf-8?B?QlNaWkpram5idCtUQWUxMWYvWktmalNzT0Z1Unk0YmtNbEQwb09oRHRWVFVm?=
 =?utf-8?B?Ym84bjVabmt1TDA4OGVNLy9XRVpQL1FCbjI5Rm1lOCtDak1MVjdWUzFYd2pi?=
 =?utf-8?B?eGFqTGwwbWVBK0NwMlY1NUp0NnVicTlESlZpQjhJR2RRaUJRN2F1M2hXTloz?=
 =?utf-8?B?VVZVVVdLVSt1UVAyVWRBTEwzVDJmWDlJV0N6TzZ4YnFiaGxHL3hwOXBubjN6?=
 =?utf-8?B?MzhabnZ0ZTMrcHRWaTcvSEU5eS9HVmx4RDk5RS9MZUtualJZbWMydmN1UjNq?=
 =?utf-8?B?ekRuSWVDcjVaSlBZdzhmeVpTOXM0WjRJalVxOUhmaWJaRGVzekR0ZlhTZnA3?=
 =?utf-8?B?REdJU25NTVVuc0kxYVhTNzdia3p3SDBPdTlTS0RteEdCZ01HYjV1Vlp4aDN6?=
 =?utf-8?B?ZDZOdE0raHBxNmNTbkZmK0VtQTlveFpyay8yMjBKSTJEV2JYZHpiRzZYazBa?=
 =?utf-8?B?VkswcnN5dWpRdVU2K3hXaWt4TWh2SzEvUFpadlNtWmRBVS82dW1uOFVhNnU4?=
 =?utf-8?B?SXFLZ2pKMjJwSUVRNmFXSStWWE1XdFhCN3JyMmhqVkRPaTc4WkpQbnowblNx?=
 =?utf-8?B?b0NwSzFDR2Zwcnp2SC9ERy9wZzg4N2N1b3MvU1FtRFdDRUMzNnF0QlIxNktJ?=
 =?utf-8?B?UW5SZEdubWtyOXJHenNnNTdjL3dtaHZWdWczVVBjYWNCN3h1S08vcmJ0QWxH?=
 =?utf-8?B?VE1JRk1VRGdlMkYzV1BXZ1Y2SElRRmdjdm1EVkFiOG00ZlVIb2pzK1ZteVRn?=
 =?utf-8?B?TFZiR1BjaU9SN2h1NFRXMXZDNGdqZkQramJydkhSWHc2Z1dPc3pxUkpsaS9W?=
 =?utf-8?B?WjRMelNRTWN5d0MrMFpYWEY0K3AzR0VXeEUrSHVna0VZdWpmUUQyZ3hGNHky?=
 =?utf-8?B?bWJtelcrRjBHMFJOaC8xZWQ1Tk54bG5COUh0TjlvTjZPcnRobGhXdy9FaWRl?=
 =?utf-8?B?M0FzTC96S2hUOFdZbStEM2ZrNEp5amhxWitiUE0vOHRpTEFHY1Z1cnk2d3lj?=
 =?utf-8?B?OVg0KzB0RGk3cnlNWmJTTUQzWFh2c0ZvM1ZXK1VoR2dnYVFIdU5qY1NTUkdF?=
 =?utf-8?B?dmdGQU5ocXFnV3dQWlhOWUR5SUF1SUMzQUJIaWV4RFF1SmVoQ1g0amdTalBQ?=
 =?utf-8?B?Qy95VkQrNlBPQitnZ0FzWjZHRkc1UlRNbExRSFNxdjVSOXVQVDhvWXY2a0tt?=
 =?utf-8?B?dXZwdFdWQjFVOFk5c1Y0RFUwUFQ1aG04NlQzdS9FWXQxVFR6NUUrYU4vQ0tp?=
 =?utf-8?B?eVZpMTRGVE5BTTYxVWQzdVVQaDBpNCt6Nk9zZXdvdytRTWVScnBvZFp1TzV1?=
 =?utf-8?B?eHN4R2s5M0pscjRzQU1PVEhKRUpHT1BjT2MrbnBTTjBxVjhDV3hRZmRVN2x3?=
 =?utf-8?B?a2NzQWVxdlFlMmo0SnlwR2llMld6UGV3NXpjK1Q3aVV3a2I1RDYyeW1taUJj?=
 =?utf-8?B?T29UZDJmbjVzWEN5T212MjJrT09lTlNVeEMybUVQcGQ3VDJFRS92WUxQRWtL?=
 =?utf-8?B?YzVBVC9KRWlMR3l1NHVieUs3bEY1TTFnUWl6K2F5TS9PU2xJYUxjZXZNOEgx?=
 =?utf-8?B?dTQxR1NIVUYxS01SVWtOS1BvNEVUM2Z6R0xVdHRJcWdDSHVCczZLT1FDQTcy?=
 =?utf-8?B?L05WY2JJRFhBWVNoMWtCV1R5c2FBQ2MyWnZYNzFWckR0YnBMeGMrOEtXMWdw?=
 =?utf-8?B?ODlZUXVCWERUQUtZSXZlVVlhQVZzNFBmak5ZaHltUUcrejU4NHYvdjhqbW8r?=
 =?utf-8?B?b1dXUXR3ZVdad0NsU1krRm1hZ0JZVzBabjZlUnZvaXdzT2ROV2UzODZtOVZ1?=
 =?utf-8?B?STNUTDR1Y0xCTGw1OTRyLzY4Yk5mb2N0aTJlZjltSUJCS25SWU9hS1dXZWJK?=
 =?utf-8?B?SXJZbHdVTk04VS9DV0s3MXQ5QzJ0eUVOektLbG51Zkx3alNEdHhNSDJmc1BJ?=
 =?utf-8?Q?oRVKywQUCZXHA+HG4ed46WBri?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1dc0dca2-68c6-4578-e7b7-08ddbd721c1e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2025 16:19:55.5496
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TxU46oulNeIbPoQlZMAubgqppk20IQH++7dE959hWtbOEPFOdcwlSFZrz0Q9vQVdMqRlESk+4/QNxKwgqfu4WA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6765

On 7/1/25 15:15, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> Implement a new API interface that indicates both the support for the
> SEV-SNP Ciphertext Hiding feature by the SEV firmware and whether this
> feature is enabled in the platform BIOS.

The API is a single result about support, so how about something like:

  Implement an API that checks overall feature support for SEV-SNP
  ciphertext hiding.

  The API verifies both the SEV firmware's support for the feature and
  its enablement in the platform's BIOS.

Thanks,
Tom

> 
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  drivers/crypto/ccp/sev-dev.c | 21 +++++++++++++++++++++
>  include/linux/psp-sev.h      |  5 +++++
>  2 files changed, 26 insertions(+)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index d1517a91a27d..3f2bbba93617 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -1074,6 +1074,27 @@ static void snp_set_hsave_pa(void *arg)
>  	wrmsrq(MSR_VM_HSAVE_PA, 0);
>  }
>  
> +bool sev_is_snp_ciphertext_hiding_supported(void)
> +{
> +	struct psp_device *psp = psp_master;
> +	struct sev_device *sev;
> +
> +	if (!psp || !psp->sev_data)
> +		return false;
> +
> +	sev = psp->sev_data;
> +
> +	/*
> +	 * Feature information indicates if CipherTextHiding feature is
> +	 * supported by the SEV firmware and additionally platform status
> +	 * indicates if CipherTextHiding feature is enabled in the
> +	 * Platform BIOS.
> +	 */
> +	return ((sev->snp_feat_info_0.ecx & SNP_CIPHER_TEXT_HIDING_SUPPORTED) &&
> +		 sev->snp_plat_status.ciphertext_hiding_cap);
> +}
> +EXPORT_SYMBOL_GPL(sev_is_snp_ciphertext_hiding_supported);
> +
>  static int snp_get_platform_data(struct sev_device *sev, int *error)
>  {
>  	struct sev_data_snp_feature_info snp_feat_info;
> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> index 935547c26985..ca19fddfcd4d 100644
> --- a/include/linux/psp-sev.h
> +++ b/include/linux/psp-sev.h
> @@ -843,6 +843,8 @@ struct snp_feature_info {
>  	u32 edx;
>  } __packed;
>  
> +#define SNP_CIPHER_TEXT_HIDING_SUPPORTED	BIT(3)
> +
>  #ifdef CONFIG_CRYPTO_DEV_SP_PSP
>  
>  /**
> @@ -986,6 +988,7 @@ void *psp_copy_user_blob(u64 uaddr, u32 len);
>  void *snp_alloc_firmware_page(gfp_t mask);
>  void snp_free_firmware_page(void *addr);
>  void sev_platform_shutdown(void);
> +bool sev_is_snp_ciphertext_hiding_supported(void);
>  
>  #else	/* !CONFIG_CRYPTO_DEV_SP_PSP */
>  
> @@ -1022,6 +1025,8 @@ static inline void snp_free_firmware_page(void *addr) { }
>  
>  static inline void sev_platform_shutdown(void) { }
>  
> +static inline bool sev_is_snp_ciphertext_hiding_supported(void) { return false; }
> +
>  #endif	/* CONFIG_CRYPTO_DEV_SP_PSP */
>  
>  #endif	/* __PSP_SEV_H__ */

