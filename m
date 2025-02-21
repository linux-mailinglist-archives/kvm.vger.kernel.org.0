Return-Path: <kvm+bounces-38816-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 83A90A3E94F
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 01:47:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9EE717A61FF
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 00:46:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8945B111AD;
	Fri, 21 Feb 2025 00:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Phq+fTti"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2045.outbound.protection.outlook.com [40.107.237.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A6401E871
	for <kvm@vger.kernel.org>; Fri, 21 Feb 2025 00:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740098817; cv=fail; b=hBAxx2EyHJcO69c4ImRpQFrmpizC7GFGwx1CoCwvEIpBdMl8abXLgYsszKLMaWdBah9H1NwEilxnB18fqL0ZvcIIJxvAz7fpihGbvDjx5CETghWr7k9Jl4OtxsJoIeIxeapLkguXT9gg+PHldD9hzDnjlPp+YWgbwCKxu8+RMqs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740098817; c=relaxed/simple;
	bh=ly+F7HxrnbKInFjPvzGeJDE6+ZxlGm5R5Bpzvt9MI+E=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ADD4BetoWTxcxeLUCgQTYscJ/BuwgCLatbz3Ge0V2LWGOBtWv050VAa+lQ+8Tj3kNdQ+NeL9P30LpLBs2HZuCLfKW2rNmkm9eqSbc3NgwdY8oN9/nYcQj64RpcOATwYX+beQwVjrMEaylBQnXXJR8EJ0hf81mbhB8j0tb3AoK4k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Phq+fTti; arc=fail smtp.client-ip=40.107.237.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Gv4roXUPrMk4IDMXPoONVru9MzHgur1QyHuQKfV6NLCuBLye4ykNnUV1/mEd2XIJ4Uy8PjRw9hkB9oL4k9hNQ0WugqxHJFcJtEQkf/XuC2OubnoolsnTijUK/XWFZ8XKg5vVgMc7x9RSawCVY9aEngnO+exSOV50FsavqTtwAsFec/lm1tHAShtk9thg+tbmV6W9AU8kjnQfurk+oVBdUrMiEoArMGLBzb9d/AMvUB4sbVph4ANfMVqBR5UXskuhdiZtzEGMDlhaZEl88xQMGvD3N61Bt2TrdWcRtdK4WOVbDDV56+6cP8veow9xIs+hAEIGNc54CNCjn5j95Xx9aA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z2wn/n+AL2fgpS9GVWJMebVh49pV1hA46vqacqGDBEA=;
 b=lTR6WMLUtwNiz0R2N2wl0dgdyj6Hd7D91/WRqFst8WE4MA/x6gcYq46cqzu5I7hLaJPwHZS8L4ldcTtGGmN2Zz3UbdqfetFDKQd8eP4RCJC9vY6vD0SQfxJsy3sSJj/35c31ncWg9BeTbdyZfqj2bzGQhqhy5m9GoKwDB/j1b7xIQAC7QRfpVA62lxCxm0X/U2yvxkms4iSQksUXGeAThj3/KwR9osLFO/RCM2gHZAs0ePSwCKfyM/ljeLCDt2bzsXL2ZWF7hyjESFnNiZA/NXYTKdOilJd3ymbVIF94HqZUFHB1k9dXydWq6HS545Rx2JsKiQLr5q0tfv/aPks1TA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z2wn/n+AL2fgpS9GVWJMebVh49pV1hA46vqacqGDBEA=;
 b=Phq+fTti1rOlwAjdb5zxNv3JXgY4GA0dWWCsMpLCYJc9nrVSsZoZR9jY3jsX/LK05zHsexEzwUdMh/w4VEfBE7zoqvcKPuCVYv0Mq4uIiQqNUobRyGmzJI06GU4tbdxzhTDKsjzqPNU/1iPwZh64wH0AjTV+N/XEm7YK8KK5FSU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MW3PR12MB4553.namprd12.prod.outlook.com (2603:10b6:303:2c::19)
 by PH7PR12MB6612.namprd12.prod.outlook.com (2603:10b6:510:210::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.16; Fri, 21 Feb
 2025 00:46:53 +0000
Received: from MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::b0ef:2936:fec1:3a87]) by MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::b0ef:2936:fec1:3a87%4]) with mapi id 15.20.8466.015; Fri, 21 Feb 2025
 00:46:53 +0000
Message-ID: <a35f2d83-7d78-4f2a-97f5-c06c71c34715@amd.com>
Date: Thu, 20 Feb 2025 18:46:50 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 5/6] target/i386: Update EPYC-Genoa for Cache property,
 perfmon-v2, RAS and SVM feature bits
To: Zhao Liu <zhao1.liu@intel.com>, Babu Moger <babu.moger@amd.com>
Cc: pbonzini@redhat.com, qemu-devel@nongnu.org, kvm@vger.kernel.org,
 davydov-max@yandex-team.ru
References: <cover.1738869208.git.babu.moger@amd.com>
 <ded4e65f9c9109f0863d1a00888b1ba48fab1549.1738869208.git.babu.moger@amd.com>
 <Z7cad1GabzGG1pAp@intel.com>
Content-Language: en-US
From: "Moger, Babu" <bmoger@amd.com>
In-Reply-To: <Z7cad1GabzGG1pAp@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR11CA0017.namprd11.prod.outlook.com
 (2603:10b6:806:6e::22) To MW3PR12MB4553.namprd12.prod.outlook.com
 (2603:10b6:303:2c::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR12MB4553:EE_|PH7PR12MB6612:EE_
X-MS-Office365-Filtering-Correlation-Id: 50f3e486-2402-47ef-fa63-08dd52113bef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eTgxWFFPcmFhVGhIVHlLTStLQXY4RFppRTlUakRjRjFLWFNramx3YmxNdTNt?=
 =?utf-8?B?YlZnQ1lSZTl3ejhVaFhWWEMrd2txeEkrRm5xUm9QKzFaSzJPMVFOT2JCVnVU?=
 =?utf-8?B?V0hGTGs0dnoyMWJKemlPcC9xaEdXSmVWcjZlQ1RVMWVJckxuY1R6YXUzL2VI?=
 =?utf-8?B?Z3VMRnF0dGVDQjZheEd0K2NYVjE1c2lqUmkwOWNOSUdaRVJPMGVjNFdLTWR5?=
 =?utf-8?B?RitER2FybndSR3h4Nk1ZaEFHd0xOeUhpUzdRODFLZ01TNWE5MStGUStxbyts?=
 =?utf-8?B?d051czFkcTRJNGwvbDNQSGhWUVF3U2piZGFwaVVZVUlVdGNTUFZaQ0t1ZkEw?=
 =?utf-8?B?aEQ1eVVqQ2d3TkhzVGdudWNRODN5aUxYK2Y3OUcxS2tPenZWNkRHOFRWd3g4?=
 =?utf-8?B?QlVwNkM0NS9xTi9HblkvSGljUFFTcHY0bSt5M0EyV1V2YWNwTnRWaVhzZXRm?=
 =?utf-8?B?Mm52Qnl6dmpiRkFJRzliNk1TTmt2TFRMMjN2YStLM2dSQk5MSWg3R200Y0Uw?=
 =?utf-8?B?OXNZMHF1czVuK2paSW9zNmV4WGxxZytNbDN0MUdlcE5iQW96RDBRUmdsSy9Y?=
 =?utf-8?B?YmJQRnlXRDZnYlBFbG1RcE1LclY2RnNPbU5JOEJKR21WWTFFV1FMNlJmNXZK?=
 =?utf-8?B?ODBVaWtlakZmcFhWR28rUHlmdVE0YXB6RlE0K3RzMFh5dlZMNmxLK3RNYmFO?=
 =?utf-8?B?am5PdlZ5akxMY1lqYkFQRnFGZjN2MnNYbFFmZXBDR1BHSWQrdTd2clgvQW0w?=
 =?utf-8?B?M1hWSjc0eit5SHZnQ0UvZ3k4K0FMeGdtTERadDVFbTlBME1pcWZhKy9QbFYy?=
 =?utf-8?B?OVErMlBRUS9ERWhSR0I4RFZ2MXlkVlJqMEZ2OGJGb01Sd3grL29zTDYxNi9z?=
 =?utf-8?B?VVRkcDZNaTFZeDhUQkxaSVVMczY3eE02N2pjV0NnQ1M2UkhxUlhJaHA4M3dH?=
 =?utf-8?B?a2gzbHFmak5QN1ZOSDhGdEJ6VFVsOGFCTXpWOEFjQWg4ejBvLzVnVEhQY1Jp?=
 =?utf-8?B?bUNrZGV5Wm9BcFJxYUZ2enVXaFRjZS9aaDd0VUMyN2dhS1g5aUVZQXc5aTdy?=
 =?utf-8?B?dUFmY1FHVFI1M3ZzamVoWE40WnVGbXBDUG1DN05DdWw1SmhFWW9zNEdCWVJl?=
 =?utf-8?B?V2U0MHQ1WlM4d1FrVXNKYW1aU3ZlYnRoNmZVTXMxM2ExT3FIejJWOThvUnVv?=
 =?utf-8?B?bjlZZnhhVHkxczRxdGJhVXA2bVlmM3dJTDA2WVNVeDFEeWNsTEM4M21TVWRL?=
 =?utf-8?B?MWE5OFJPN2lRVHRnY0JYTGtpaUcvYkdHOXZIZG12RkNYVDhBVkNoREpLUEh0?=
 =?utf-8?B?a0JOd0tlakRCRk5WQ2lrRjU2d2ljRlhTUkM4NThMc0pBT00rTmhlenV1ZVIv?=
 =?utf-8?B?VlJGNTJQVGQrRW5Bc1hVenpHMit4aFlWYnpPZGhyeG1KamJ2MWMyYk45RDFs?=
 =?utf-8?B?YjhId0s0Slh3blFmTFo2b1ZTeGREbUhTNGJ4S1J1NXp1QkljT2pKMnNTVzh5?=
 =?utf-8?B?U2x2anQrNjZxUERubG0zVEt0NnBLV0JidlY5OUxNMDhOakhHOG9KV2UyVWxl?=
 =?utf-8?B?VUIxZ3BQV0FzV1hSc2lSbmZrdk5VU3p6Ym9aNlgwQVhHUGhOSlV3TjBRQWVE?=
 =?utf-8?B?eTRwOU1tS1ZKZkVLVWN4RmRqcFZqL0RVajZMZW1jZWJnK1FvRHFyUWQ2M0ZN?=
 =?utf-8?B?VVNITExuS09heWpxa1IxVG05N2kvZG1TYWxJbkJnM1J1Y3VMNDQvMk1FTTlx?=
 =?utf-8?B?WjF5VTA5QXAxZkJnTnRiMzc5ZnRIcUlNMklTQ0orR3hSek1yTFlnL0VWOCs3?=
 =?utf-8?B?anhOaDMwQUdzMWNpamcrSFpRam1MdEM5Y3JWekpnckxaTEFaSlE2T2ZLWDdJ?=
 =?utf-8?Q?JmAO3vjmA6jj3?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4553.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NWlVdzFYZkUva1A0amxLV3U5YkFDK3VLYTRzSnFZQXQrZnU2dDNzZ0dNaFAv?=
 =?utf-8?B?dWlJMUdHTVFZa3ZmUWhRR0Nvb1NNd1hTV0lUektRSjlUNkk4S2QyZGkyVnZN?=
 =?utf-8?B?SnJjWGpFSkdlS1gySEt1ckJMenhGKzNoajN3Tnh3M1pNNDd3bWVXS3QyWHc1?=
 =?utf-8?B?czFNVWtKbGNCMWxrRW9XUk5jWEN5Y2RwVXVUQmlxS0RBR0tSNzEyWW9NcW8z?=
 =?utf-8?B?WTMzT2EyaXp3d09QS0tpWnZZdDlPZ2FJQmpaNkc1SmtZU0ZVR1JXM0I0WjRF?=
 =?utf-8?B?UDJRU3F6SlNFVzFSRGowTE92K3RsL25keGNOSzZ1c0pJQ0huc0lUQ0c5TUN3?=
 =?utf-8?B?RG1iRmdhUjA4YkdFVldpRnZTazB0NlpJL3E0V3JCTHJQbmlpTXN2aWFxYzgv?=
 =?utf-8?B?R3JwalZza0pBTW9yelVUUnF2bXJlZXlzWEFTUDE1RUt1dTRJZUg0NUEvQmZa?=
 =?utf-8?B?L2NRcUxZRDJ2TjRZUFdubFZCQTlacTNvNk9XcUZxeUdCNXJ2WHhEZG94QThF?=
 =?utf-8?B?MHpsN0V2WFFJR1ArVXNoeXRvTThUOGRkZG5qNjBQYW9JazJ3S3FONi9IdW14?=
 =?utf-8?B?RWFEOE91Q3dNRVMxZ2p4Um01Qkx3RkxKcDEzbW02QXRpbnUydVFwM3RPVlVt?=
 =?utf-8?B?YmtkS2JuUC95M09nS005SDFjK3djNzJPVFZCUEo1MkhkMkdMaHZNbjJuNHFP?=
 =?utf-8?B?bFpDTGR0ei9sQ3BTRmVmMk8xSUFIYm5kOVFzdjE5dWZUOG1qVXF0aklmeEVi?=
 =?utf-8?B?OUR0WEdzMUNKbkFQbllqeDRubjd0cmdYaDZRN2dod3JxeHVDcTl2RDBneGsy?=
 =?utf-8?B?YzJXUEpDeUpRMk9uUHRsTk1BQkxFaTA0VE9CNDB3VEV1TnJFVjQvNm00ejQ0?=
 =?utf-8?B?V0tPbzZpUUZXd2htK3lNNERFMW12K1ZkVWowNDhzbWdneE1SNDZXcGY0TTk5?=
 =?utf-8?B?OXdkUmM0bVJiajF5QmdJWHAxcUs2Q2R4WjcvRjZRRCswY0dabDc3bDFPbEJZ?=
 =?utf-8?B?Z2ZZOVM1Z3lIdzZZQXlzeGxBQ1ZPOWMxc2lSRFRrTnNIRG9sZWpxbEdvdjdJ?=
 =?utf-8?B?YjcxYkhUcmg5WlFmdzNQVDk2QWs2MENZYXU1QjlUbHVML3I5WmdUZU5xNmIz?=
 =?utf-8?B?c0VEbjhxSDZkQjQ2MUFoSFN3QjhaRml5SUxKS2hpM2lzSnFhYWZyZG1PTFF5?=
 =?utf-8?B?UnlzNUtjTk5hQThnbXRXNnZyZ2h6L3ZEQlVjQnh5aSthcndKRjRLck5VSG81?=
 =?utf-8?B?YkZpSzZ0VEVvbExYZkhYMTZQdFU1UTN0RDlma1Mrb3NCRmE1QjhYKzlreFRV?=
 =?utf-8?B?Qit3dDJ1c21IVWJ4anVnK0NiT2RzMU1jZXVqUTZxeGJibDFqbTVPa00wZGpm?=
 =?utf-8?B?RUQxS04wSzBzMXlIN1RJN2FaNklXMVZsMkZXc3Z6WXU0YUxsVWh0WHBtMDVX?=
 =?utf-8?B?SURtbGxSenZGNzFwdzlacEJTbTNGblp0WkFyQTd0ZW1panRDQ0M1M3FidXgw?=
 =?utf-8?B?Mjh6Q0prck1pZkFWam00MFhTRHFCQ0xZUENrSG5GVXZJUHdsRit5WVF6emNr?=
 =?utf-8?B?T1N6a2tZYWNYdjhaM0QxK0hERDhobkFaaWlYaUkxNzZUWnRzNnBDandYYVJt?=
 =?utf-8?B?OTg1eTEwWWwzUGdYMnBnRFlJODJ1ZmVGa1UyNHYyMk5wUmRYVHZWaVI1ZERH?=
 =?utf-8?B?dmlPT3U0cit3OVFWMURwalVJV1BxSTFncDRKUGM3T1llRnh1R1ZQTGtCdis1?=
 =?utf-8?B?SUtrMjlRd0V0THY2cy9Pb2NxbzNQK1NkMHlXWmtuVlFrTE8vS0d4Y2NWSlVU?=
 =?utf-8?B?MDZIdlYrKy9WaGdEdzdsdS96WnlOYS9mMVE1bFVUcEZoYno4eXhvZno5UTNF?=
 =?utf-8?B?RENMTWo4bTJVSEpOOVBCbjlOS0lIcHNmbFFMOG5HbENCY1VPdTc1ZXErcFVN?=
 =?utf-8?B?bWdIaGpmb2R3SlJORE5Ca1IzUU82eXY5WXRPbTFoZ04rL2x1a2VpQzNhYlRh?=
 =?utf-8?B?ZFJoUFN4UVl0bUx4bUFpTS9MU3loVGNTUlJ2dWhJNkRKaVJRZ3BoYkJ1bEFF?=
 =?utf-8?B?cml5WHNjOGRycWhUOUxmSXdMa1pvSXZkbmJGMmNIdXozSFhmamgvVGsvUWhp?=
 =?utf-8?Q?Rc50uVyfKrhsO9QBHwGt4F0dH?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50f3e486-2402-47ef-fa63-08dd52113bef
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4553.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2025 00:46:53.1483
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rZY1ZXXqzL8C4UR3e2LCWxWgVMwpajT12LKffssTUwN15BQH1xGP+H/qJpz447qZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6612

Hi Zhao,

On 2/20/2025 6:05 AM, Zhao Liu wrote:
>> +static const CPUCaches epyc_genoa_v2_cache_info = {
>> +    .l1d_cache = &(CPUCacheInfo) {
>> +        .type = DATA_CACHE,
>> +        .level = 1,
>> +        .size = 32 * KiB,
>> +        .line_size = 64,
>> +        .associativity = 8,
>> +        .partitions = 1,
>> +        .sets = 64,
>> +        .lines_per_tag = 1,
>> +        .self_init = 1,
> 
> true.

Sure.

> 
>> +        .share_level = CPU_TOPOLOGY_LEVEL_CORE,
>> +    },
>> +    .l1i_cache = &(CPUCacheInfo) {
>> +        .type = INSTRUCTION_CACHE,
>> +        .level = 1,
>> +        .size = 32 * KiB,
>> +        .line_size = 64,
>> +        .associativity = 8,
>> +        .partitions = 1,
>> +        .sets = 64,
>> +        .lines_per_tag = 1,
>> +        .self_init = 1,
> 
> true.

Sure.
> 
> Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
> 
> 

Thanks
Babu

