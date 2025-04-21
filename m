Return-Path: <kvm+bounces-43726-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 86E47A9575E
	for <lists+kvm@lfdr.de>; Mon, 21 Apr 2025 22:33:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 490BF189607C
	for <lists+kvm@lfdr.de>; Mon, 21 Apr 2025 20:33:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F33961F09A3;
	Mon, 21 Apr 2025 20:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="a9ZFtSQ/"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2063.outbound.protection.outlook.com [40.107.94.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DC1BDDA9;
	Mon, 21 Apr 2025 20:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745267569; cv=fail; b=tb4/7kqgATaY+crqcurmRqfgmBQ1NbHv3FHyxVFNo5dOUn7CPWLW9R84W5hbn8WkhE307Rp2p0D1i217Q2LcfS1cJdvxU8+/Y+MRdRC0IUxryGGsKr4DpAH1BYsNWu4Pfel7bf33F0rCT44JXaWrO/iybOeDNmRw9jK2VOgQdxs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745267569; c=relaxed/simple;
	bh=lSv0NcqBfs1zbQa6WFXmUKK7o25rfVOp9lK3mZqIvDM=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=MRBTruTTtsp6vLDSulbDUOxn1edNOYMWvWJlIfw5QoM95QF6PP2b03/0n/8w57QnMsJ1r+GTmRILy2w2J4oApviOc5wjn8BqCyc3UHkTR+bb5d8FbOl0kA0IDFGjy7/q+ARd8SVPf0bdCV+9reTCO8I5fjg9B/ccD1nu3IJ7x3I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=a9ZFtSQ/; arc=fail smtp.client-ip=40.107.94.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CBwvF6izH66JhJa2Ov9ftfGSjLJis1yb8C+8GqJTMAd/WeqHsMge1i3KRI4t02zyA2ao5D9qQTL/zL0S1gkbekR8cibSTbulCMnVBi39AOUDYiKY+ypyp/fWAJzqnNxfM4T3OxszEgz+h75WEcsBR6BSvoywx0A9mumKDWYSp/hvvRicvKUKtOehSGHDw/QBxmvet5edvs5bP6VQ1lsUUfVlNBctmNfhCc8GLjed1DcppUUjK3EpBQogZen0nsughENJgHwazdpWd4ZaBTmigVksJcQRVPCGiGt6rJRKtfgxTJ0CVAkk22B05cGr+/KII+jqi613xZuZkdjkhW1Plg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vmEOBr0H8MrFYZP+6/DrqzWi+0a+8YyrorwdTX3PdyA=;
 b=CpllVZieAYkWfnBvWr/kcsYylY3zStTF8JK/jLnwukeQDwT3sEmxA8HelM8BF6HEBuVj0BEiBTquqfwikWzjc+lAZLNJR2yY6JAXfoqGD4llaoKaK4yDh6JEzclZvhJQL7oXWl5SMrVX4RqtaF2C60Oh+IC8ZsYwQSd4YA2BwBQTa7xshfmB1r6u/uQRt0J1B+NSVbyZVuMUygLHyyGK0BbGnMZo4S6SaOv2ydHNGxrW/ylREvvmPgkO4c451xmqdP0pwUtX98BXMWHVJBHnh8QXqL3xlget5/mzTyWyIat5kLGpoWYIHl3+MzFWGs2ThfUwhJS1gtY9R/iL9D0E6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vmEOBr0H8MrFYZP+6/DrqzWi+0a+8YyrorwdTX3PdyA=;
 b=a9ZFtSQ/Y0w+vZYGds2VYPdwt/8wuFSF3MUKMPMxxmLC9blB9l84ib6fZbSlKKA06yMHSxf7CtTBUutoukIBMKeM0u5ZGbb3cwvj+nG+EHQ8u2WVd74Xx5ACtCqWiql5PVagtfck7LGq1Y43y5YEEFdao+pqsSa7j7bbPADcp6E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by SA3PR12MB7924.namprd12.prod.outlook.com (2603:10b6:806:313::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.27; Mon, 21 Apr
 2025 20:32:44 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8655.033; Mon, 21 Apr 2025
 20:32:44 +0000
Message-ID: <b240fed9-0a3d-35b4-79e8-e25e7f042eff@amd.com>
Date: Mon, 21 Apr 2025 15:32:42 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: roy.hopkins@suse.com, seanjc@google.com, ashish.kalra@amd.com,
 michael.roth@amd.com, jroedel@suse.de, nsaenz@amazon.com, anelkz@amazon.de,
 James.Bottomley@HansenPartnership.com
References: <20250401161106.790710-1-pbonzini@redhat.com>
 <20250401161106.790710-10-pbonzini@redhat.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH 09/29] KVM: implement plane file descriptors ioctl and
 creation
In-Reply-To: <20250401161106.790710-10-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0152.namprd11.prod.outlook.com
 (2603:10b6:806:1bb::7) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|SA3PR12MB7924:EE_
X-MS-Office365-Filtering-Correlation-Id: 9bc2ff8b-bfd6-4bd9-c26d-08dd8113abb6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UmZkQTJITTZLaUJ1VHJBMGVJNVZMNG1hQithTFNmc040enFlOVkzazE5a1oy?=
 =?utf-8?B?eVJQVERBRjQwVFNUZnBsR2VrMXU1NVBuVVNxWGJmVVhJOEUva0FEWVJ0bk54?=
 =?utf-8?B?M245REs5OGZBYlVUSitGNXNxTDdsWXVIbkZqWjJMNVAwNlRVUFNDQXNrdlMr?=
 =?utf-8?B?UlpveTRNY3ZHWXdicUpPSTFHdnBsVklHRVlIR0ZIVC9LNFNsc2YxWUlNTkZU?=
 =?utf-8?B?MVlVZ0pVQlZTUnlGNVdHOTQ2Ni9TaVcwZnhFSElsRVhpcjc3alVDZ3g5a09L?=
 =?utf-8?B?LzRBN0FxcWZJZTJjMUwyN05qZUMwRXpnZFFSTVUxQTdpSWRKYjZTeVVnQzFx?=
 =?utf-8?B?dnJTMlBteGlhTitaRjMzUXQrQkVpRjF1U1RNMVA1T080aWZpYVdnVmYxd21o?=
 =?utf-8?B?NVllTHY0cURVY09VdDdLbllKbkpaRGt1aHZ4dUdWYnpIOTJSL1ptMVJoRWRJ?=
 =?utf-8?B?b1cxbXVjRlJnMnh6M0dWTzRvZERXQ0Erd25HVmFwekRTbXY4NHhyQ296UFA5?=
 =?utf-8?B?dkxxbUdPQmNja0pheG56d2JnZ3hiN3lBY0Rad09uU1o0bjVrVDltRitMQ2tN?=
 =?utf-8?B?NUN1WUI5U2c0VjM4czJVcFhLVjJKdVhVK0RWOEpnelJRaGY0eS9Kb3dQSWo4?=
 =?utf-8?B?YmcrTWdpOHFvYWIvbjh4b3d2NkdsaEs0TG9aYUpwZkRLL0s2QndRN1V4QXhJ?=
 =?utf-8?B?ZWgwU3BNTUtnQzYrakJ0UFpFaURRUzFkc3FabUo2L2oyYmtmMXBRYjQ5YS96?=
 =?utf-8?B?OURsOGpEQ0NpYThiZjNnVkp2b1BiNUFORFRhVkptMFZHbWlna1hHRGp6dVJu?=
 =?utf-8?B?Y2NreXdPVldhd0NpWStCZnhua3k5dUc2N01id2VraHd4WGhmekFyYjVVT0py?=
 =?utf-8?B?ZE1XZ2ZURWZHNGlGaE4rc1hSdTZmMWI4c3RDTjJhZllRdlJrUmhlbVh3YzM3?=
 =?utf-8?B?Q0JOSHFxdWxmR3NsNUFFVFN4N2REa09FaG4ydk1YemhiWjZhek1oWk5Vbndo?=
 =?utf-8?B?NE9GTmxlZzZvYktVNGw4WlNTclFid1pLU0Njb3RGTjVadExiQUdjcU5ucDdT?=
 =?utf-8?B?NEx2K2JGWEpJaEV5eisxWWQ1emgvcEdmMU9wa2FCQkthNEljSnlOdEdvUXYz?=
 =?utf-8?B?bjhWYURZaldaREpjQUM5cU50R01Tczg2ZkY4S3lrUnc5Nmw2bHV6T21iY29q?=
 =?utf-8?B?ejVXVHM4K3NjUklTTDdzQlJrYk8xOW5qbnJqK3dIZlRrMzV5SG9KOW5ZL0I4?=
 =?utf-8?B?L3Q0VzR0ZUhYQUZ3Y3M1UkFpblpMSWV3bjRLVUhhTlo3b2tqNVFYanNiSm1a?=
 =?utf-8?B?TTRSbk14U2VaZlhxWXdsaGdIYXQ1aSt1UDNKUmRwWlJnU2EzV2VCcVlKN3Ux?=
 =?utf-8?B?dG9OOC8vQ2dGODllcEVjYXRRc29YZEJZMUNhNjhYeVBFd08zN2ZjNkZQVWY4?=
 =?utf-8?B?Z2FnL1RSMnlRS01ZSWs3R2tIbEtxeWpUSDViWC9IOU81b3VhMzJOdG9IZnAz?=
 =?utf-8?B?QlFEOFoyMmFRVFY3cGJ0VG1kSzZXeG9pRHlOY1hyZXNNMmk5RWxOaDBjcVFD?=
 =?utf-8?B?VkMrS0w5K0FwSzNJUXd1TUMwYno4VUNuUUNrVG5KOHF3ZUxSOW9kYmRqSjRt?=
 =?utf-8?B?ak9HekVORzBVKy9jc1Z6RXRnTE1TeFpQWkVwZ3loanNXQUc0WjNKS0oyV25M?=
 =?utf-8?B?OU1xeXAzbzNCVGgwTnpLbmEvcWJvd2RVbU9Td00rOGZNZkJsanBZRXhhNnJq?=
 =?utf-8?B?b1BWM21nbmR2c0tISkNJQll0NlVsSG5icXVXZGtWRUNTaEczKzFVZEwyWDFP?=
 =?utf-8?B?cXZiRzlPemFhWmsvbUIxdHRyL3RlT3hSLysrUDA0dzNrR05PU09pNjVvdWNB?=
 =?utf-8?B?NzV3UXZEVWlqa1ByaFhhcll3OTg0dHJhOFJtekFUSVRTOXppZ1NNZjRDQUIz?=
 =?utf-8?Q?VAKu3fxb8gM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UjkwUXV3VmRRNkhGOHdPQ3QvZ1QyN2hJQWxRalFDSkY4dVVSMDk0U3BQcE5z?=
 =?utf-8?B?endneVRTWW9tUUpaTVlya2FjaXBOcW9NZ0d0QjVUSy9wK2MyUCticVJCSGY3?=
 =?utf-8?B?WkVYM1BZQzcxNUhFVzR2T0hVelEvTG5ON2tjZUxsUm92SktmaGxJVFJkNnJY?=
 =?utf-8?B?eHhNWDM4UFJLWUI4OGFIU05YZy8zZWZJZGNYckEvdTIrd1p1a0JWNWYvZlMr?=
 =?utf-8?B?SnJnZnVqbTdpd3F3SS90WG5DODlabVJINWJsWTRnY3ZKNjlUQWloRHFTajQw?=
 =?utf-8?B?cER0MCs4UEVJNXduUzZobWR5MGhyUmRmNGFzc2VqbE9WSXg3b2Q1RUtTK3ZR?=
 =?utf-8?B?c2RuMDJwY2EyazVNUU1zQ0Z0SElRZFJKMGQxU3VITXdLTmFXMzAvazZ0T2lu?=
 =?utf-8?B?cHUwNDFxcGlnYUtMNDYybEZ5VEY1Sm1uTGhzSTVJaU5hVEE1Z29wbWgwRWxt?=
 =?utf-8?B?K05PcFlRUVVHMjdGS1U5cFl6N0MyMEZ0TUVrL0hQYzU1Zmg5VU5tY0U2YVQr?=
 =?utf-8?B?VG1sNTNpejJaQmdGZ1BlaEtFc0F0b1lOVDh2UHVldUtjdE1iSUl5OUhyVTRa?=
 =?utf-8?B?WENJNWcwV2xrZzk2Z0pWeG5ZZW1tOE52cG43b2tUamx1dHB4MkZVV05IV0VG?=
 =?utf-8?B?WmVBbTNIajhRbHZOVDhPNW1xZnRsT0U1N29xUDdkYklsTWM1K1hNTEFUNnJy?=
 =?utf-8?B?M3pJLzR0VTdjZ25oVWdycit4YUlzZmJ4bWlmeFNPRHlIYWExMkc1WlkranE2?=
 =?utf-8?B?Q3JaekxFM3pYYWNrZTduV1FLZ3dCNUNncFkxZXdGK3RXZkc4Nkp4TEtLTDQ4?=
 =?utf-8?B?Y1pGSGxPRGhjT2VKSGZtOEhDendybG10VFpDZnZ6Q21DMEN4SFNTTUxNRG9a?=
 =?utf-8?B?M2JTbGtLZ2hsUVlteXMrL3padGlNTHJpY2FRYUk1ZUxOeEJoTlJEQVNsRWJa?=
 =?utf-8?B?T1U0M01kTjB5Sm1SbnVSSDZxL0J2QUlwUUp5alg1WDR1TWU1YmxaUE1DSW1I?=
 =?utf-8?B?UzlDREVNeVQ5aVRJRUs1K2pjcUg4L1c0Y1A0Z2swc3d3UzdpakZTS1NWaytu?=
 =?utf-8?B?R09jbEVHYWJwMCtaQ1dtVk1VWGVWUmRhR1VldWlHUUV0NHdSTzlnazJheHJU?=
 =?utf-8?B?SEpzQVpCdUhJcE1hQTFuazludnFDcFZDNC8yWnJ2NHIxRmRMYUZnODBpSWVn?=
 =?utf-8?B?M21NYmNHTmtmcTE5a0Vkc20wSktnVUtqT3F2TEVmL3Yya0Y4elBEbXRnZTJi?=
 =?utf-8?B?U3JOWjlzT24waUtiYUFsR2FVd3JqVSt4SkxYNWFlK1hzZ21YSzNJQ0J5YnRR?=
 =?utf-8?B?aXdEQWRxTDI5c0E4K1Y0VU1PbXRpN0w5Wlgva21jR1pCYXVzZXAzVS9xdDhF?=
 =?utf-8?B?d1IzKzhRdDFua0FJUjRoQ1lhc2dlMXpKN2l6a2hJQTI2Qkh2TUk1WGpTeE1M?=
 =?utf-8?B?eVROc0l0U3d4SEJsOERjNkdPdnhhczJGeGJKaVVaaVJuaVQ4M1NRbXFDaVRG?=
 =?utf-8?B?bkVrY0g3NTlJTVlTY2NDSjliMERDU1Z5T0x4dCtNaVhlK3MxRFdhNFd2WGJt?=
 =?utf-8?B?U2tVWXBPMi85K0YvYjdiVk1OK3lVQ1oxVTlXUnpsNmtvZzQ0anQrTGFuc0ZQ?=
 =?utf-8?B?dGg1eGxpN25BUmczSGFnSm5RakZISG1od2Y0cmNXVCtJMTBkVDNkNHhmcjdE?=
 =?utf-8?B?N2NxVDByd3dRZDhaOEN5L2Z0dmFWUllqZUJGUnZ0SkdFU2l1QkZEaUNESGxC?=
 =?utf-8?B?MGtwMXF1MEJBNjhZbWlmQWFVUFNhZVhHUU03di9jeE9RMzU2MkpzcHFUQjUr?=
 =?utf-8?B?QlYzMGRxVzlwSUtRNUJFdVpLc1pZYU9BWUp0NHdHV05xelNFSE1wZU1MMWNh?=
 =?utf-8?B?WFlFQktSeUtpMHIyRkZ2Mlc3NU5tV3VZV083RXpiaWtIYmNDbkRMYUxhSFpH?=
 =?utf-8?B?UzI4UDlmQ2lPVUtaTEYyUVFHcVFkUGxqK216T2dIUGhZL3VwaUNQZ0J2MnVE?=
 =?utf-8?B?YzdOekdlY3MvWnRVM2RYdWtiWlA4cW9Nd3RTTmdXZ3FmTVZnOXovdUVvOGtt?=
 =?utf-8?B?czFRbXFLUXFsNS9RZ0IwM2VQdXBhM095ZStiYkgzZEthbEhFSHNhYlVIVTVN?=
 =?utf-8?Q?zJz0KLE+BSHE1djMaRd2Xi3C8?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bc2ff8b-bfd6-4bd9-c26d-08dd8113abb6
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2025 20:32:44.3222
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2i+mgFB4mOElK8Hyn8pc2X/F8Kv8R+9Kpsw3oCIg9D+3PULuPKtzu2zjYJv0cFx5BDS1WwIG7UizccgESq4tLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7924

On 4/1/25 11:10, Paolo Bonzini wrote:
> Add the file_operations for planes, the means to create new file
> descriptors for them, and the KVM_CHECK_EXTENSION implementation for
> the two new capabilities.
> 
> KVM_SIGNAL_MSI and KVM_SET_MEMORY_ATTRIBUTES are now available
> through both vm and plane file descriptors, forward them to the
> same function that is used by the file_operations for planes.
> KVM_CHECK_EXTENSION instead remains separate, because it only
> advertises a very small subset of capabilities when applied to
> plane file descriptors.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  include/linux/kvm_host.h |  19 +++++
>  include/uapi/linux/kvm.h |   2 +
>  virt/kvm/kvm_main.c      | 154 +++++++++++++++++++++++++++++++++------
>  3 files changed, 154 insertions(+), 21 deletions(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 0a91b556767e..dbca418d64f5 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -342,6 +342,8 @@ struct kvm_vcpu {
>  	unsigned long guest_debug;
>  
>  	struct mutex mutex;
> +
> +	/* Shared for all planes */
>  	struct kvm_run *run;
>  
>  #ifndef __KVM_HAVE_ARCH_WQP
> @@ -922,6 +924,23 @@ static inline void kvm_vm_bugged(struct kvm *kvm)
>  }
>  
>  
> +#if KVM_MAX_VCPU_PLANES == 1
> +static inline int kvm_arch_nr_vcpu_planes(struct kvm *kvm)
> +{
> +	return KVM_MAX_VCPU_PLANES;
> +}

Should this be outside of the #if above?

> +
> +static inline struct kvm_plane *vcpu_to_plane(struct kvm_vcpu *vcpu)
> +{
> +	return vcpu->kvm->planes[0];
> +}
> +#else
> +static inline struct kvm_plane *vcpu_to_plane(struct kvm_vcpu *vcpu)
> +{
> +	return vcpu->kvm->planes[vcpu->plane_id];
> +}
> +#endif

Are two different functions needed? The vcpu->plane_id will be zero in
the KVM_MAX_VCPU_PLANES == 1 case, so that should get the same result as
the hard-coded 0, right?

> +


> @@ -5236,16 +5363,12 @@ static long kvm_vm_ioctl(struct file *filp,
>  		break;
>  	}
>  #ifdef CONFIG_HAVE_KVM_MSI
> -	case KVM_SIGNAL_MSI: {
> -		struct kvm_msi msi;
> -
> -		r = -EFAULT;
> -		if (copy_from_user(&msi, argp, sizeof(msi)))
> -			goto out;
> -		r = kvm_send_userspace_msi(kvm->planes[0], &msi);
> -		break;
> -	}
> +	case KVM_SIGNAL_MSI:
>  #endif
> +#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
> +	case KVM_SET_MEMORY_ATTRIBUTES:
> +#endif /* CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES */

If both of these aren't #defined, then you'll end up with just the
return statement from the next line, which will cause a build failure.

Thanks,
Tom

> +		return __kvm_plane_ioctl(kvm->planes[0], ioctl, arg);
>  #ifdef __KVM_HAVE_IRQ_LINE
>  	case KVM_IRQ_LINE_STATUS:
>  	case KVM_IRQ_LINE: {
> @@ -5301,18 +5424,6 @@ static long kvm_vm_ioctl(struct file *filp,
>  		break;
>  	}
>  #endif /* CONFIG_HAVE_KVM_IRQ_ROUTING */
> -#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
> -	case KVM_SET_MEMORY_ATTRIBUTES: {
> -		struct kvm_memory_attributes attrs;
> -
> -		r = -EFAULT;
> -		if (copy_from_user(&attrs, argp, sizeof(attrs)))
> -			goto out;
> -
> -		r = kvm_vm_ioctl_set_mem_attributes(kvm->planes[0], &attrs);
> -		break;
> -	}
> -#endif /* CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES */
>  	case KVM_CREATE_DEVICE: {
>  		struct kvm_create_device cd;
>  
> @@ -6467,6 +6578,7 @@ int kvm_init(unsigned vcpu_size, unsigned vcpu_align, struct module *module)
>  	kvm_chardev_ops.owner = module;
>  	kvm_vm_fops.owner = module;
>  	kvm_vcpu_fops.owner = module;
> +	kvm_plane_fops.owner = module;
>  	kvm_device_fops.owner = module;
>  
>  	kvm_preempt_ops.sched_in = kvm_sched_in;

