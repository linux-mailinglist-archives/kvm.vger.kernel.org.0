Return-Path: <kvm+bounces-39605-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E4988A484B7
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 17:22:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BD0A13AF380
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 16:17:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C7E81C8636;
	Thu, 27 Feb 2025 16:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="CNKruWLn"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2067.outbound.protection.outlook.com [40.107.244.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9B531AAA05;
	Thu, 27 Feb 2025 16:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740673012; cv=fail; b=CmKzjyCiVe05LhJUeYaQWzrrT3upNDFbsp1kdupIH6R1XecAdBWzj7d4WMFt/xNWiFhTqTF0NxmpJ6V+hh6FOFY6m/w7c80HsjHlnd4EcHqwGuhzH2T+Fm0OpXVMyfIKAzi9OnbCFenkYBU5delr/33IiwuEPVs9UZizqpNVHbs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740673012; c=relaxed/simple;
	bh=CjcH7LPgyEQz1rd/DVqLzmmlsmXzkGhyHfMkQH9QeEA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=i5ZPm9rFitNwrkUlslPsQ6c8cv9Bra5Hy8Uwz/hP2di/qbtWyINo9zpN0l6Y0huSEsmJkDNKFm+vK7xStPD+AG4Mg2NOgMTndJYSSxzuGtvxtWvxwhf26oVIYYAa2FbkG7ONFZPqmRUkBz3iDa33xEkT7b1v+JSmDFvz+yGRE8A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=CNKruWLn; arc=fail smtp.client-ip=40.107.244.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MT8rLJxQQEuhetnBnsbqhan6HG6JAGjyEAbQu0rGKuZE+IKv2HPKqbVtVDIPdxuvMxqhpNY72RTDiVrjzZAJCyQ9cdhsIxDUjn8P2AJCgSMHYGvIqXKI/mff0mGTY4Gdy+MaPNmyltV16RR+bwpMT4NbJ8ZMMXh3P6acWI0SjlwWnRltmdFWe6ARI3c57oZj68nuEoKgwKvCSdqBAJGzLAJ2MTR036XVqw/QpDyCteUlLy9FNmgp/ZWN8o8VPWAmsK3smW3D7jlEtGnLqaOYTtZ2g8Y6ph3ZXd54yaHp01BGyMVCuO3rA6pvQiJ7FIEpnOmYMxqawLWEneVoSfsjeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yOREGOrOeS7brsw0Y0ZSNg4tRmu1ARABGuR/ixtm1uc=;
 b=A4meJHeymr1lFV0OL83RKMIRu00EZCPbsTuN++QYkH9MPLO2MW+gymI0HQh4Pa3q4c7W87m7hEHVtL2Bmm3Ka+8lJL8BJZ533VcSaTy59nafae9cV2xWXsJc2V3cbmEkSgzaHz7bXOMfAkj9W8MDyjXcX4lU62qRfpOZR3PRS4eiLyl1SryrJH125CI6oZog6jawPIJU8ANCvjciK6k9ZnkUJ8Z9XpUFMUfcy01MLiDLmC4ueHWy01AjYZAXLsn9DRLrnMIR65cmCsQUlTRDHZTYIGuwVNchV7KBxt1K2jBP0aKIndejdsz9Gfe0BAUg0aNKMVfeVvCCnprKnvbaPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yOREGOrOeS7brsw0Y0ZSNg4tRmu1ARABGuR/ixtm1uc=;
 b=CNKruWLnxPl3YmWuQb4yQ9F/EnXHw+XBwIpuSZ2hb1RjJxlf/fXCkHbeOo2sdGceqZrP5rUuOmfB1BmRujU/nVIpB7er9mveqrw1pu9BHU+IHnH8iKR6Wi4OskumcBA2WWyx9//39gBApA7xu9zawZv2ysd4jsrrLFhBO7Paejc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6214.namprd12.prod.outlook.com (2603:10b6:8:96::13) by
 SJ2PR12MB7964.namprd12.prod.outlook.com (2603:10b6:a03:4cf::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8489.21; Thu, 27 Feb 2025 16:16:49 +0000
Received: from DS7PR12MB6214.namprd12.prod.outlook.com
 ([fe80::17e6:16c7:6bc1:26fb]) by DS7PR12MB6214.namprd12.prod.outlook.com
 ([fe80::17e6:16c7:6bc1:26fb%3]) with mapi id 15.20.8466.016; Thu, 27 Feb 2025
 16:16:49 +0000
Message-ID: <9ec81d11-be50-4820-a076-a4394346f0d8@amd.com>
Date: Thu, 27 Feb 2025 21:46:43 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: selftests: Relax assertion on HLT exits if CPU
 supports Idle HLT
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250226231809.3183093-1-seanjc@google.com>
Content-Language: en-US
From: Manali Shukla <manali.shukla@amd.com>
In-Reply-To: <20250226231809.3183093-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0098.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:27::13) To DS7PR12MB6214.namprd12.prod.outlook.com
 (2603:10b6:8:96::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6214:EE_|SJ2PR12MB7964:EE_
X-MS-Office365-Filtering-Correlation-Id: 53d516d4-d53a-4fc4-b023-08dd574a233a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eWZacWd0eG85SEhmRXdwWGxsRWNrSmpyY0hIMzFHTVovR2lPbFJzRElkMERt?=
 =?utf-8?B?UENsd1hyeEUvNVdHV011V0Y3NW9XTmM1QVY4eEt5bVI0cjF4dTRWeURuTHZU?=
 =?utf-8?B?WmZ0Mm8wRzFmOWtMa0E2NlZIdjd6aGRsdG1tT2N1M2xGN2F4VzRJWWlyd1hk?=
 =?utf-8?B?RDgxN3diR0xCNEdWTDF5YWVOaDFKMm04elhRQlJFaENzRll2cDZNdDFKSlJr?=
 =?utf-8?B?ZWtSZGVKdG9hR0k0WDBKM2ZpMlJKWjZJaWFvUVIzdkpCZW5rYnhYTVh1ZmVv?=
 =?utf-8?B?ZUpkbUVka2dGSGZiV3BWdy9BZC9OdW1LajNON2ZSVGt3bGtuZURJclJINEI0?=
 =?utf-8?B?T3FudVVQMUdsVlBqVW00TEt6dzRzTkkyZnFWUG5yQnRqTDdRcnNvejUxYzZY?=
 =?utf-8?B?SE1HMzVLNlZaRjZCWVF5VVFoN0ZTUUZXbU80djhra0s2Q0NTdFFscjZMcVdr?=
 =?utf-8?B?VG1IaGxGTzdkQ2tkamZLS21XZ25ZRHJ4Tm5TZ0RpN2FNRzRDMG5aelpNSVFv?=
 =?utf-8?B?Tm4rZlljaFZ6WGg2QmpZSmY1R0R6NndWRjRVRm0xSm9RM3g5ZXgrQjk2WmlU?=
 =?utf-8?B?Skc3UEh5QU04SkZpdWJjQnkwVW5nNGFQSTUwMXh6eHZnNTFYaHFOS0lCSm9o?=
 =?utf-8?B?NENKOHdsNXFCZHBFUzFxd1RXdUcvaEVGRXR2aG8rTzVkZktBbDBaOUR3ZzVs?=
 =?utf-8?B?bzlEMk1TcGdOV0hzN21tOG1wb1FNR0o1ejQwSUVQd25LWTNkOEhYZUp3ZytF?=
 =?utf-8?B?TjNaRTF3SUh3bCs0dlJ5NTV4Rk4xM2lSTUN2Q2ZHZDJsa01CS1ppWHBFa1ly?=
 =?utf-8?B?aDF0ZzA2cTJsYVlHaVdnR05XQXVTMTFBRVVuQy9MZm5uUklLR0hvcTZKWTNj?=
 =?utf-8?B?NWJ0QThLcm1rN2hxU2hzc2JWc0g3NGNhL3JKRDE3VXNKa3p4cFhTU2ZOakJh?=
 =?utf-8?B?aUdnazY3SUh5UTRna25TdnRmQXFTOFIyNklKSVBJOVZEZU4ya3YvZm5kcHN1?=
 =?utf-8?B?S2d4RWlDMEVPTWFaSnlFODZBY0pjU013OFVJclNpWTQzaFBhT2FGaWdsUFJ3?=
 =?utf-8?B?Z21aR1ZGaERJc3JUNHk5TytEaVVDUTJ0aG5ITVN1V1BOS096NXhXTVduclc0?=
 =?utf-8?B?STdIcmtIR1BRQVZoSGJJTy80NU1kUEw0b0hVdWoreEF3OERYamhDOURaTHdK?=
 =?utf-8?B?MVljYlZzTWxhQ0hNNUNaRGM3RXY4NHVrNFpaYmtVR3VqY3VoN0tkamorRHEx?=
 =?utf-8?B?cENWQ3VOUUxKcTQvMUM0RXkxaTlDelV2dmNsZVd0OUQrQlNqMER4Y0xZcVhk?=
 =?utf-8?B?ZnNUdWFwQy82dlNGc256RHY1ZlZkMEdDMWcxMml1ZTZyNkZHQUwvLzg2V1lp?=
 =?utf-8?B?Y1dHQXRPcTUwNWMrL3BHcmFHOG1HbHpJNXNjVFc3akVUZG81MUFPckM2amRW?=
 =?utf-8?B?Z21NRkx2a3VocEpvUExOTE5PeEdBQXA3Wlp4d1IzZVljdWRjN0o4aE5pbmRx?=
 =?utf-8?B?ZjFMVXlTOTdpUVd2cTRFS2t4TDBQN0dkSkpaeVg5ZWxSWTZRSk9LN214dG8y?=
 =?utf-8?B?a1EyTUY0bEtWZ04wM3Z1SnAwN2NHRGpwWGwwRmRwdFlpTnRkM2RsNEExWGY5?=
 =?utf-8?B?TjY0TzJ3TFhxSGVBNkRhNXpqU3NrM3ppdVlTV1dwaHRqMjM4UGZNYWxWSDdt?=
 =?utf-8?B?N1BzNlpZeDBRbW90Y3NaVkpkRnJ6S0t2VXhGWVlWMVEybU9ta1ZFajZnL3ZX?=
 =?utf-8?B?MjV3WE5aWUFhVTVJcjBzdDNGd0ZsMEhYTXdtUDdOVjByQ25VclJUZzQ0cG1F?=
 =?utf-8?B?SzN6bXhueXBWSzlzM2pzbEwwaUpiOTN6NU1uS0ZYOGdJemJjTXdVcHNaUWl3?=
 =?utf-8?Q?hyy5GKAojoUKl?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6214.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RWZaS0RXdjFBYjNNU3B3NzRnOFhzVjQxQ2M3eEFNaHVhM1dVdit0SjFha3U2?=
 =?utf-8?B?TDhPWDEzUEY3d0Y1aExlSnpQL1A3cjgzWU8wV3pKaFFmY2xxQ1hPMk5TU1R6?=
 =?utf-8?B?STgvcldJV21xNlZjTnNmRGVVTE55bk00aHVkcXY4eCt6N0Y4OWMrMTNNay9T?=
 =?utf-8?B?V0VMUUozMHMzUGtBWlZCMmJ6dHRPeFJQMVBoY0I0ellnc2wwdTFhY0lEdER1?=
 =?utf-8?B?Z3hDcEdZNWpDa015NHNLUS93eE1JOEFpa3FyWGFDTUM2WjB4ZTlpL21EOFBJ?=
 =?utf-8?B?MUkxM2xNdXlZL3lrN1VHU3dBZElqWVRKNFhHblRyMGlpNkREdng5SUNLTUlI?=
 =?utf-8?B?SGRjZUEwT0JZU2tFUXMwSUIvS0JYaWlXUFRjeE03UlFZM0NMOUZLem5vbjdw?=
 =?utf-8?B?YXloelNSU0JhV0VPTDZGYVBUNjlTUlBWMGtXNUttTFh0TzRRdFgvZkd4L3l6?=
 =?utf-8?B?SEFWNjdFMEZ1a1k1RTZZN1pnUFhMQUlpUEVZZUw4bVJaaUZMZ204dDZiNFI5?=
 =?utf-8?B?bXBYWXliVmFjaTdKOGZLYlhvdVlMV1BadTBDWmVybGdmSmxGK0dHM1hJYVdH?=
 =?utf-8?B?b2pqM3Q2YkEyT0xLa3ZJeDFndkhLK3ZhY3ExWGxaWGNNK0lDdWZFR2NaQ1FB?=
 =?utf-8?B?UFk5a2hDUlFJUkttK0E4QzhvcGVKYUlLUGkweUoyQWNBZkhnWTM2L0s2b2xQ?=
 =?utf-8?B?YURDUVUzNC9UM0g0ejdMSUllVVpFUzhrVVJaYjBla3pBdEVNdytvY0U0bUJV?=
 =?utf-8?B?ZUhHblFjd001TmhYSENvcTJIUzZPcWhGdUtPRHl6enJ0N3ljQVlTdmdkTjN1?=
 =?utf-8?B?S1NMdnlOS1FMRFpDV3c5bk9SZFFWYWdwUXdpSFJYeHdRRlF6RXF1SFJGTXFs?=
 =?utf-8?B?cEE3WEE0UjJtV01wTXc3eU9mcVVlYmEyTmZKclBuSVlybUFuZWU5cHlFVlF6?=
 =?utf-8?B?WlpMaHJ4R2s3U1BQTW9Mcm9aMmExUndzSGNzMjNia0owTGMwcWx5U0ROejBQ?=
 =?utf-8?B?YXJZczJmM09rM09DTjFsQ09sZENWRGRnSjRQQllZei9sR1FpdkVTblZEOThF?=
 =?utf-8?B?T01NK2lLV0dZckJwR09pNCtRUmVCTWsvaFdBZDgxQ2dKL3pZaDdiZUYvdnox?=
 =?utf-8?B?dHQyWFl2UDhRalM0V3RGQ2t3UHhqbFo4U0dqS0x4TWJZYU9IdlZUVFN0TzE4?=
 =?utf-8?B?Uzk5ZWhUbWNBemdvVVhyZUJEZm9rT2kyN3M4Z3p6eVdVUDludmkyUU1IQWI0?=
 =?utf-8?B?WlhVY0lNd3Vlam5RRmwvQ09YdWlRb0xkd3o4amZiRUpmaHVxL3BsUTBMbVBB?=
 =?utf-8?B?TzkreXdxYjdoNHdXYjlTYW01V05BWHNiYm5NcFROalgzKzlubTNCQmE5L01R?=
 =?utf-8?B?Mi9IS1JKRjUvd3dIclozN3llR0thWEpsWnhlMHRMV2V0emltK29PdytkY1Jh?=
 =?utf-8?B?SDdUOXpoZU1mcG8xTjB2bk9naEcrdnVBOENTWlo1OVNlUUppc0dycmo2UXZX?=
 =?utf-8?B?cjVMK3NwNFY4N3BBT0RzMTlzMm9ndEg1TXllSDVoQzFxVjVTMy9OV01iRDgx?=
 =?utf-8?B?RjFKQlBMQ0lSQndEOFpNL3RGUHFsTzJzMWlXdVpXWlh1WHVxeGFwS2xEZHk1?=
 =?utf-8?B?QzJvdWdhdU9YaFhDbDRtUEtaMGkwY1V0bjJDR0RhbTJvTXlWaFVqT2w5cGZW?=
 =?utf-8?B?cUpPazV4NjhrL1Brb1ZKOXhkbzBtMVhlRzMrTHV2ZUVKYk5JK3ZHbC9EMW9a?=
 =?utf-8?B?SExuL3UwS0ZIMDFVU200dlBJL1RMbzk4RmhGNnpEd0pDWW02Z2hydUFMd1g5?=
 =?utf-8?B?bjJrK25oNmVYb0h1VGt1M0ozVUxpaGZiNG1pZ0Z6SU0wK1RvSnFBNisxL3ND?=
 =?utf-8?B?ZVFzN1RMZmJIVHJoMGlFTjhuNUVBN0VzZHJvTDM5VllDL2dLQjM2dXVydU5v?=
 =?utf-8?B?bi9qRzJ3SVFkQ0ZkTDBjbTd6Tnl4OXZPQVBMTHF1MEN3MU44NVdIZmtQSTVS?=
 =?utf-8?B?VzlrNGMyT08yeUYrT0pRSFJrakFXcDZ2Sjhwd0ZlOU5rb0VHd3JGWFpnNmtx?=
 =?utf-8?B?ZzJHcmJDSlZtYkt4cHZYME1HcHZxWDdLZ244K3B3TGY1TmNUNUJGZ0l0bHpy?=
 =?utf-8?Q?5TIvEWTLGOsNzJA1CtEUaIC9g?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53d516d4-d53a-4fc4-b023-08dd574a233a
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6214.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2025 16:16:48.9716
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: agZvbrQ6fELSImOFo8wHeDjWgrTR54wwv+eDHQWjfnrmluQfqPS0VAexAHU+X2Mg6E2bzAQ9Xish9l9Jjl8BaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7964

On 2/27/2025 4:48 AM, Sean Christopherson wrote:
> If the CPU supports Idle HLT, which elides HLT VM-Exits if the vCPU has an
> unmasked pending IRQ or NMI, relax the xAPIC IPI test's assertion on the
> number of HLT exits to only require that the number of exits is less than
> or equal to the number of HLT instructions that were executed.  I.e. don't
> fail the test if Idle HLT does what it's supposed to do.
> 
> Note, unfortunately there's no way to determine if *KVM* supports Idle HLT,
> as this_cpu_has() checks raw CPU support, and kvm_cpu_has() checks what can
> be exposed to L1, i.e. the latter would check if KVM supports nested Idle
> HLT.  But, since the assert is purely bonus coverage, checking for CPU
> support is good enough.
> 
> Cc: Manali Shukla <Manali.Shukla@amd.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  tools/testing/selftests/kvm/include/x86/processor.h |  1 +
>  tools/testing/selftests/kvm/x86/xapic_ipi_test.c    | 13 ++++++++++++-
>  2 files changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/x86/processor.h b/tools/testing/selftests/kvm/include/x86/processor.h
> index 61578f038aff..32ab6ca7ec32 100644
> --- a/tools/testing/selftests/kvm/include/x86/processor.h
> +++ b/tools/testing/selftests/kvm/include/x86/processor.h
> @@ -200,6 +200,7 @@ struct kvm_x86_cpu_feature {
>  #define X86_FEATURE_PAUSEFILTER         KVM_X86_CPU_FEATURE(0x8000000A, 0, EDX, 10)
>  #define X86_FEATURE_PFTHRESHOLD         KVM_X86_CPU_FEATURE(0x8000000A, 0, EDX, 12)
>  #define	X86_FEATURE_VGIF		KVM_X86_CPU_FEATURE(0x8000000A, 0, EDX, 16)
> +#define X86_FEATURE_IDLE_HLT		KVM_X86_CPU_FEATURE(0x8000000A, 0, EDX, 30)
>  #define X86_FEATURE_SEV			KVM_X86_CPU_FEATURE(0x8000001F, 0, EAX, 1)
>  #define X86_FEATURE_SEV_ES		KVM_X86_CPU_FEATURE(0x8000001F, 0, EAX, 3)
>  #define	X86_FEATURE_PERFMON_V2		KVM_X86_CPU_FEATURE(0x80000022, 0, EAX, 0)
> diff --git a/tools/testing/selftests/kvm/x86/xapic_ipi_test.c b/tools/testing/selftests/kvm/x86/xapic_ipi_test.c
> index b255c7fbe519..35cb9de54a82 100644
> --- a/tools/testing/selftests/kvm/x86/xapic_ipi_test.c
> +++ b/tools/testing/selftests/kvm/x86/xapic_ipi_test.c
> @@ -466,7 +466,18 @@ int main(int argc, char *argv[])
>  	cancel_join_vcpu_thread(threads[0], params[0].vcpu);
>  	cancel_join_vcpu_thread(threads[1], params[1].vcpu);
>  
> -	TEST_ASSERT_EQ(data->hlt_count, vcpu_get_stat(params[0].vcpu, halt_exits));
> +	/*
> +	 * If the host support Idle HLT, i.e. KVM *might* be using Idle HLT,
> +	 * then the number of HLT exits may be less than the number of HLTs
> +	 * that were executed, as Idle HLT elides the exit if the vCPU has an
> +	 * unmasked, pending IRQ (or NMI).
> +	 */
> +	if (this_cpu_has(X86_FEATURE_IDLE_HLT))
> +		TEST_ASSERT(data->hlt_count >= vcpu_get_stat(params[0].vcpu, halt_exits),
> +			    "HLT insns = %lu, HLT exits = %lu",
> +			    data->hlt_count, vcpu_get_stat(params[0].vcpu, halt_exits));
> +	else
> +		TEST_ASSERT_EQ(data->hlt_count, vcpu_get_stat(params[0].vcpu, halt_exits));
>  
>  	fprintf(stderr,
>  		"Test successful after running for %d seconds.\n"
> 
> base-commit: fed48e2967f402f561d80075a20c5c9e16866e53


Tested on Genoa and Turin systems to cover both scenarios: CPU supports idle HLT intercept
and CPU doesn't support idle HLT intercept.

Tested-by: Manali Shukla <Manali.Shukla@amd.com>

