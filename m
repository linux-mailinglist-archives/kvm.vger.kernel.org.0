Return-Path: <kvm+bounces-34528-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 127D3A00A3B
	for <lists+kvm@lfdr.de>; Fri,  3 Jan 2025 15:04:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D5D101621C5
	for <lists+kvm@lfdr.de>; Fri,  3 Jan 2025 14:04:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48CA61FA24D;
	Fri,  3 Jan 2025 14:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="wz8Fg1Kj"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2046.outbound.protection.outlook.com [40.107.223.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D15D7190486;
	Fri,  3 Jan 2025 14:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735913041; cv=fail; b=uNTQ/9NyINfarG2vvfxBVR1JhWDpugbKCuUO8STsOymkxlvCHYWg9lkoBiEUXXcCohhFuYkQPIMHZms4QGU/u5BxccfHDrXtdT7DxYJr96sta0GcvYlBGar7BqqKZBYHY1i5iWDnqAKjUfzcYQTqSFg/xtoQ1wbYZOiic0cLuoU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735913041; c=relaxed/simple;
	bh=gLtiE1cmlTaNrvxD1MmVoZ0FRP/n4bXrmi+t04s5ibk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=dxli78wX5Mqlmndh+BYFoqdzGmMVOj7qtv+NcwObvVXhNBqyADNkAjmVaYar9SeHJVQ0x5FngO+A/oUqMbPIwKtTlRxEywd9mfo2+/0brG916gBGUUlc4vDLTXLrxW/3hstsMFlJBSLswZaM/riitjZXnkXl6hchdciIRHBoqEc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=wz8Fg1Kj; arc=fail smtp.client-ip=40.107.223.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kdC12tY9eHqdXgWG8QyLrNPijIKpjmSKnlkSKDQBR5SciLMxF2bl3Q6KAquslqm4njjXlPWLsp9rYMdCK2YcwaUusjZr5GnZfIzN3dKjyv5eW4MSuntwtFbzR/JdZ3AzrCXFR0dX2go1dUXeGH6+3eFpRbTwfHAZ5xz0IK0cD5cu3++U3U4cIog/DOGbVT2mFOfpWaxl2mWluYxKUfcZqjRKj+u9w3pP1pS3istL9yKHkZeTXlMGYk2NCQk+J/Sc640Bz73W7aeKYf5IIVKQzl6tKGNRXzFUihrzildHddp4d663/hDpiuVJViyz3Cb1NAwYe2ie61z19A0F4s7+1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CoIbBL+baDOZrXelE0XIkF6UKAUQHuqb9HJ39brqbuY=;
 b=mo0tlllHinfIS3jnTjoa8Ro5PywNXH1PNnbtCWz5JORx9UJGxDrZ+23yWnPKS1IBL4NIC/x443o2y3wv9oi866dGmn87QlXEcQgU9tPOzsfZZoA6Qp+TfHvBFuOtdkVs19N6eh/2fWITTaYG6rRqt+FjhOFguXmy0IP82D7SYb/GSRh770nNoroV0jwYJsc2Clvj2SFm2E/YKlprp6ljppG9XVN4Hhi0bPrC50UFns/iigy1leErGclBsa9fRrp42bkRRWg2tyebJ04qVJylYff91Dyju26IeEewJWSNuzlOHCg7p596lIDHM815kMm5L/0fk4dmQTGPyrLTDdmSUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CoIbBL+baDOZrXelE0XIkF6UKAUQHuqb9HJ39brqbuY=;
 b=wz8Fg1KjzZPVej+MaBCF+czqFdKPWgdT92K3hWT7Gmfk96Kb/Ct7D95xb9HmWIH6YiFqlyQKqJI/ibLdb+t3obH88B+NEBbkd6YVtdp6WyaEpeNJiTeQ8Zi96VPceNj3hoYx4CCyUVdyzFQ+W49pA3CIuV7wKb7rdzk+tlU6w68=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 SJ1PR12MB6241.namprd12.prod.outlook.com (2603:10b6:a03:458::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.13; Fri, 3 Jan
 2025 14:03:52 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%6]) with mapi id 15.20.8314.012; Fri, 3 Jan 2025
 14:03:52 +0000
Message-ID: <20c20e60-3b55-4c57-b5a5-1a46e286e31d@amd.com>
Date: Fri, 3 Jan 2025 19:33:42 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 10/13] tsc: Upgrade TSC clocksource rating
To: Borislav Petkov <bp@alien8.de>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org,
 thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
 mingo@redhat.com, dave.hansen@linux.intel.com, pgonda@google.com,
 seanjc@google.com, pbonzini@redhat.com,
 Alexey Makhalov <alexey.makhalov@broadcom.com>,
 Juergen Gross <jgross@suse.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>
References: <20241203090045.942078-1-nikunj@amd.com>
 <20241203090045.942078-11-nikunj@amd.com>
 <20241230113611.GKZ3KFq-Xm_5W40P2M@fat_crate.local>
 <984b7761-acf8-4275-9dcc-ca0539c2d922@amd.com>
 <20250102093237.GEZ3ZdNa-zuiyC9LUQ@fat_crate.local>
 <2139da61-d03e-49b3-9c7c-08c137bcf22c@amd.com>
 <20250103120632.GCZ3fSyMiODH8-XBC4@fat_crate.local>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20250103120632.GCZ3fSyMiODH8-XBC4@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PNYP287CA0049.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:23e::22) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|SJ1PR12MB6241:EE_
X-MS-Office365-Filtering-Correlation-Id: c7716f5b-baa6-492a-b94b-08dd2bff73fd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?N05ZdlBaSzdTc3N0UVJiM1RlN2twM1RQUTQ2SjlpK0UvbUxKekc4L1JMWmdO?=
 =?utf-8?B?R3FyQk1kNGtSNjhGNXMxbVJKSmtldk5VTXFvbHoxaCtkSDR6U1ltelJyN3pE?=
 =?utf-8?B?RitheUlWQ2pORkplN1JyU0lxOHRQL1NGVDBmL1JLV1ViNC92YTJxendMVGpJ?=
 =?utf-8?B?UWoyeGNOVHd2M3NaNHVNVlJCSHRuelZTVGsrR09yZFd3bFJqNTdYN045UUFo?=
 =?utf-8?B?d2hRN1hHQ1lYT0VoUDlyUHhEZUdyMUlsN2NPQnRVUDNWaTJEMVpyOXBLQVZj?=
 =?utf-8?B?eXVRU3RXbWdHZUZESDllRk0zU05IMDA5Znc0WFV6cFJSazFTMHJrOGJmSmVF?=
 =?utf-8?B?OEdZaFYrREpwRVd6VU1IOTczSmFPemI5N3k2d3dwYWp2UlhlbU40OHIvQVRE?=
 =?utf-8?B?S1RBNzNlWWk3Q2NDZG8rZkEwVk9DQXZ4YTgzbkNRMlVQT1daeUxtMVBSYUFq?=
 =?utf-8?B?a3VjdmNQNlRPQTU2QVkrcEJOV2Z1S1hKNnMraThvamJqWGFtZThrOXIxN0lL?=
 =?utf-8?B?KzBCU3V0Q3N6U05Ud0tZQ2paSFg5cGM4ano4aXZwMzFrQjk3MzlhVjVjZ2Jv?=
 =?utf-8?B?YTN5aXU2SjJIWEx2a1A3T3RXOTZRd29ueFJTbVh0SHV3K2xibkM0VXNhVzNL?=
 =?utf-8?B?WGhON0FFcmVJNGovRkVmVGZvUWdIdDQ0aHdHV2drTjZ4dFYvY25GUmgxcUg5?=
 =?utf-8?B?cXZjeUg3VTQycUlHMlRHQWxsOU5zMDlLSFFWcmkwMGZzZE5ya2VMSjdVTm9w?=
 =?utf-8?B?Mis2TUlZL05YVEJGbXZjbzVUMHlIUXQyR0thank0azdJa1pzc3NZaW9HZFgx?=
 =?utf-8?B?bWRqcUxqSm5nVGo1WERlRTVCMjN0REowMzJvSnhzOVRKMGtrWmtKL3RBM01Y?=
 =?utf-8?B?cTU0c2hLQTFscFUrbStSM3QzOFJkZ1NYRG5UYVZHVXEyTndEcUhoNVhXTnpM?=
 =?utf-8?B?OE9PQkJpeElYUnZvVkg4ZHA2N200MThCZ0J4a1FxOGt5bmVsZE1OcHo0UEJk?=
 =?utf-8?B?VzRJL1hqWGdsRnRIbEVDRUVhbll4bWNzbmMxYWxGc0xKT09KUFFxMGFSSnAw?=
 =?utf-8?B?aW10cXEyMld1RVRXKzJ5NVM3UmtOVTdHZnpjVFdDR1JjVVBEZUtvcHBsMFpv?=
 =?utf-8?B?bjkxdDFmTUFjRFQyelBiZEN5NDBtMnBQUUcwYTFlVTFiSmp6ZzhtcEh1ZzJY?=
 =?utf-8?B?MjJPVmhjcUw0MEJkZ1VocHZOQlVvb3NhWFJxSmsrTWRQTnEvUStuRi9GQ0Vu?=
 =?utf-8?B?bTJSb2dVMnRWS0ZhRTg1ZFA4bHRNWTBaT0RoRkxmcWtiUHpXYWU5STVZbmRz?=
 =?utf-8?B?Sk5FUFVRV0tDTVpPQStnMHVGVTdvakZRVTd0QStjQndlQW9SWk9XWmtKY1Fu?=
 =?utf-8?B?b01xckE3YWtGbWFtanBKRXFZQUdjRkJxQXlOSHVUakpuZlZPd0lJaVNEaVhG?=
 =?utf-8?B?a2RHRm93WTRwcFhablpnL2paTjdIZjV6YzAxai91eURpQzJ5WnRLOXJsSUZh?=
 =?utf-8?B?YndUdXg4UnJERWtaeUxIMkFCM0k0dk5nTHpsQlBTRlJzLzhhakdQWG4rSzBx?=
 =?utf-8?B?cS9ZNVVCUGtDN2NoNXV1VS9pb3grTEhqMHFNL0U3NzBuL2Z4L3pJSElYQnps?=
 =?utf-8?B?NjlrUWdYNkFIa2QvYW5DbkhtMS9uNnlLZU9mSkpvanR4d2l0RmdBcm5qMjdZ?=
 =?utf-8?B?akl4YU1STVhyTDR2VHBzTTg1ekx3NlFCWGE1Vk1Vam53VTEvMXFJeXNwL3lK?=
 =?utf-8?B?WmJZZkxvNmphOW5MOE9wVHIvUjg1d2JFMW1HZDJsYkJyQS9YU1NBM2RUOVhC?=
 =?utf-8?B?c3BmRzE4MkUwZDNHa1dnS2hrbTJqWG9YaDV6dEY0dml0TG16YXJBelhWVTN2?=
 =?utf-8?B?ZjBOUzR1TkVnckxzYy9CNU95MTlXUnZ0QmhDU1RHUzY5S3c9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aWxxbU9NeEw2VHlHdjlYSkhWNmx6NFNCOXVQZUdBZ3F6WERxYm1UU2xGdkxu?=
 =?utf-8?B?V243NXpyd3RINlBzYmpieDRrazBPUHJ2aE1DVmRsSkdXbC9LMVZ4V0dsRE9L?=
 =?utf-8?B?em03T2xwUjUvT3ZVOTh0R1BwNFp3YUsyVjdoYldJVlNRYzluaUV6YXV4alpy?=
 =?utf-8?B?cXJ3cnlDUlhZYjhQeUdMVWVuVWNQSm9PSXI5a1h6Y0ZCQW9EbGJnSEdPV3Y1?=
 =?utf-8?B?K2tlMzd6ZGNUNUc5Z2JnMjZSak9RWFdHOXljUE9iTTlrVWl4SXA0b2g5VWxL?=
 =?utf-8?B?UFJ5SWN4NENsZFJIbHRUeU0vS0F5RCtSMDdUN0RUSlFiVEJpam50Vzd1aFZP?=
 =?utf-8?B?WjlyOThGZHVaeURsbCtOdzBmUllEcVkzL3pJYXdsbDAwQWZBY1NuYVdZYTRz?=
 =?utf-8?B?c3lVTmpZY0JQOWZHRUIxWHl1bTF3N1p4K1dDcEpETFFSQTdCZmMxNVVVeHFz?=
 =?utf-8?B?ejlaTHZ6S2RFQ3E3MFdERm8zTlJNL0N0NlIzN2R4dFpYcnBZZTcxYXdhM3ly?=
 =?utf-8?B?NDArYXdNcU1ybjVMYW40bFVrai9sU2JuaEp3Vll1N1J5NENrM2tTcjdwYmxu?=
 =?utf-8?B?QlhlSXpuT0pqeWVQN1dZUFJWUzNwc1VIYURPbnp2NEo4czl5UittL1ViRHhV?=
 =?utf-8?B?bVFoNWcwNkN4WG9YditsblgzN3ZkSENGMVpvSExsNG0yaGY0QTVPdVdUc2dO?=
 =?utf-8?B?a0RUanZuVkN3OUgydFF2eHZnL1JKMm1yc01aZmt2VHVQOE8wcitTeGFFMXRa?=
 =?utf-8?B?aE96aFkwNUtCUnIxZUtZNjhJaWQwdnJTYXo3SGFuOGMzT05tWnd1OU5WRFdV?=
 =?utf-8?B?elFzWElGS0Z4bkowTzNOQnFnQlMxaExHWjBMNjlva2hKMm9mdWs5ZkdBdG82?=
 =?utf-8?B?cW04MVVCVG8va2xxMnlWa1RVb0FlaVI2dFZQWjNOZ3BmbTh6NlB6Wm9iTG1O?=
 =?utf-8?B?UmxKMEhCNE96YzhFdm9FS28zc3VUbDcwK1cxTkRUWmNjRE9OeURHSENySmhy?=
 =?utf-8?B?bHF1c1N3UEplZGc5YUh4ODJPNlFLWGUvamI4YTBaaU5aeHZyLzVFYmxXa0lO?=
 =?utf-8?B?aFZpdW9KQVliQThrOWc2VEhhRTRKSUxjK2IvZExiZ01wYmZnMjVZWmxDOCtS?=
 =?utf-8?B?QXZvcFpGN3lXaUowcXZoVFdSSUtUeUsrTHh2L2Z6ekJXNTVaeXFRTzNmdSts?=
 =?utf-8?B?dkw1SlV0Q09aWFVUc2gyMUFDOFgwZVFzbkVSa2JxZ016R0pLMS92VUhoaXBQ?=
 =?utf-8?B?ZE1WdnIvZU5LdW93ZVJ4cVNBdmlaTWY2RlVsQXg5elVMdW5vNlF2cXc3RjI2?=
 =?utf-8?B?dkdpRFBuZEFhcTZvdDd4T3RvQXJkMkZLOVl5RjI3RjMxL0VqZ1hkekxtdU5P?=
 =?utf-8?B?dTJuSFBMOHdrL2s5UTRqbW90eVVzZUgzWGNpNGlFMDJibkFQRitkeG85d2ZG?=
 =?utf-8?B?b2xKVUhTbEdMVzcvcnZkZ240S1MvbFlvdndHRTNwMXBVZzI3RGliTCtnc2Vl?=
 =?utf-8?B?V1ZpaHJXYTV2M3Q5Vkttc0wybkdWWSsrdHUzaUJmVmNiMWxqek1FMDFaNTlP?=
 =?utf-8?B?VHhLUUtjLy9wY2hXMTlBOGQyQmNKN2QwNXV2N0dCai9jdzlHV2h2Y2RmYUhj?=
 =?utf-8?B?MDQrWWtIVkN5TzhJTTJsUUdZVDUrZUxBL0xLM3kxVTdPNG9YakNLTjE3ZHJx?=
 =?utf-8?B?OCtiNTJFQ2pjc2x3ckhsSTVWekJwSnhXcEIwUk5NZU9LTUFyQkRWZDdKY0tn?=
 =?utf-8?B?SGYzMUdlbVhpd3ptRVBsa3BOTklxSjJQV2hxYWFhZ2hoL3BNV1dKZXEyQngx?=
 =?utf-8?B?M0xodm1xZUFhUEY3TkpUZXhWeFYzVHQ5bGs4UlRXd3g0VlIrdkQxaXgxUlVp?=
 =?utf-8?B?WG5mblBHUys1NC9OUExDOVEvMDBCQkdlODN4L3ZrckFyVEhJb3pwZWVnSG80?=
 =?utf-8?B?R04vejBYTEZHenRXSk9XWFpCUFZoUk0rUEJQUDZVemZnTmcrWWx6RWx4eEJv?=
 =?utf-8?B?QzNHQWdPZGJHRWpMU2Y2eG5IZnFyM2lLeXkycEJCV1A2THFaMjlidExoeWZF?=
 =?utf-8?B?SVV2SS9MSnNibUowQjg1cXVVbjBvR0dEVCswTnBDWmlaWUpJRnYzWUlNREk3?=
 =?utf-8?Q?letiDXjhG615ph19XkmmBskT3?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7716f5b-baa6-492a-b94b-08dd2bff73fd
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jan 2025 14:03:52.2623
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dsoEpxmGN+XYDSb6nJkyCGTjO68sMT/VX7AZFMsWtXmPxTpbavS2gmszITrUO2MA2jn9Psr4V9y5ZDoUnn1nnw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6241



On 1/3/2025 5:36 PM, Borislav Petkov wrote:
> On Fri, Jan 03, 2025 at 03:39:56PM +0530, Nikunj A. Dadhania wrote:
>> Right, let me limit this only to virtualized environments as part of 
>> CONFIG_PARAVIRT.
> 
> That's not what you do below - you check whether you're running as a guest.
> 
> And that's not sufficient as I just said. I think the only somewhat reliable
> thing you can do is when you're running as a STSC guest.

This is for all guest running with TSC that is constant, non-stop and 
stable[1] (and detailed response here [2]), STSC is one of them.

Thanks
Nikunj

1. https://lore.kernel.org/kvm/ZuR2t1QrBpPc1Sz2@google.com/
2. https://lore.kernel.org/all/8c3cc8a5-1b85-48b3-9361-523f27fb312a@amd.com/


