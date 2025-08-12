Return-Path: <kvm+bounces-54540-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 55E5AB233F3
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 20:34:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8C7D81895EC5
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 18:30:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC2802FE584;
	Tue, 12 Aug 2025 18:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Lk+sbGPy"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2086.outbound.protection.outlook.com [40.107.243.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5B971DF27F;
	Tue, 12 Aug 2025 18:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023365; cv=fail; b=XuDgaMzv8Ipct8V4Jy6S8KCGWUsMFQVXBY8WvMwHeS+o3wBlTRyNV2LaSgRyVehxAL1o6m5j42rKqOdghEgx8Dk6WCE1YfBs2wm5SUdJ1zDSdM0Dx5UUJxABd+spMrRmoE5XUgR4dQ7eFvtGw7lkMzV8SQt2LjAfsy78ZyT/svE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023365; c=relaxed/simple;
	bh=V1FrrP2bX4955sbscIMb4p+9d84fY+tH/wG9yXvuLDs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=biuUU0zwJHlRRDqs3OlFxE+ggx63UztO+YTvJ9WFClnbKl04Fx2VNJnlwMb80owxT7TxvuIxfgBii1hVi/BhQ4mKS41sK/r1W/PWkk1/jkosWpPIguKyVQg6tJJNdwVbEzkcmtwnGun7txfNUPtE6Az7A2ZCZH66N8xPyx1hWAw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Lk+sbGPy; arc=fail smtp.client-ip=40.107.243.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MLVL1W5muIalw6zxoeBMa39bpmzLA5c4aNyPVskAUhFv4NVJB4HDy2nrDKAkcSb1+Tpe5cVR5Cx1OF4oGFgDFrdvCNjz+1mEWEldtSVmzJY+SNALghqTPn+pqFZ0CK7Z0rIJ7xfQVEKb/1M7Z/AbCvDbgZun9xpUqewE2in6utrRqPasw6zJ9OeKi3inUo9dYmfNZvDfzNtIbmUgojMMmWZlMf+U674O5TyRXvUSfB8Ty3f7Q1U4IlANjZtfZRHeTX/cvYlekNqqVMfVgDmixyzVPArCLRQraUwdIRC6IpfDinNY0uvRE2pzDvUsk9KQbCiyL2QpkzMKD4sDuWAyxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mP80PWgkZT2GrZcNnNtM4g0gD8l1EmxjRUCEk2b3JW4=;
 b=LhvvfIDS/sbb7wQ1g1Y6LfTSfr9cgb1MY3gMgqqXQWeZ6fQ9DNAyXvIu1fxOtT2qbdWQipAIooOxp+1Vq1CG1qlB8I9xLg+RRFdebsk5dj9OauhgPx9kjWNpmSNzcZe+wljzRg00GHqg6rzeIwNnMUpsTqUWKa4UT48264vAvsPex1ABo3JZr5TRa0jA4mocPAY/0FiabC58hC6aZAXWxfMDyaqoxRBlFIxz370jlrVN6u4CBITgLCNBp3c4fbPTNiv64IdEyW7O6ipk1KylPt/65jYS3YFNlm16rHwmUuYzVpUjR1CfCpfJPiTHnYPjXL7fr1DsfWYI1my3aGzETQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mP80PWgkZT2GrZcNnNtM4g0gD8l1EmxjRUCEk2b3JW4=;
 b=Lk+sbGPyro7L+rLorKBDRdgB31hZa3z96tKhkZVFtQq9Xa16KXWgB28wjae3BnopCXysX0oOyJsyqOI+B5qZ4zT0WIz7+qvtZQ68PngJYF2toU+tPKWsmUK63bwLfYaq2rcg6OqndpvCESVjQOsGqNsmy4KWak0fUKAu7BfFQmQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB9066.namprd12.prod.outlook.com (2603:10b6:510:1f6::5)
 by PH7PR12MB7138.namprd12.prod.outlook.com (2603:10b6:510:1ee::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.21; Tue, 12 Aug
 2025 18:29:20 +0000
Received: from PH7PR12MB9066.namprd12.prod.outlook.com
 ([fe80::954d:ca3a:4eac:213f]) by PH7PR12MB9066.namprd12.prod.outlook.com
 ([fe80::954d:ca3a:4eac:213f%4]) with mapi id 15.20.8989.018; Tue, 12 Aug 2025
 18:29:19 +0000
Message-ID: <9b0f1a56-7b8f-45ce-9219-3489faedb06c@amd.com>
Date: Tue, 12 Aug 2025 13:29:13 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 7/7] KVM: SEV: Add SEV-SNP CipherTextHiding support
To: Kim Phillips <kim.phillips@amd.com>,
 Tom Lendacky <thomas.lendacky@amd.com>, corbet@lwn.net, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 john.allen@amd.com, herbert@gondor.apana.org.au, davem@davemloft.net,
 akpm@linux-foundation.org, rostedt@goodmis.org, paulmck@kernel.org
Cc: nikunj@amd.com, Neeraj.Upadhyay@amd.com, aik@amd.com, ardb@kernel.org,
 michael.roth@amd.com, arnd@arndb.de, linux-doc@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
References: <cover.1752869333.git.ashish.kalra@amd.com>
 <44866a07107f2b43d99ab640680eec8a08e66ee1.1752869333.git.ashish.kalra@amd.com>
 <9132edc0-1bc2-440a-ac90-64ed13d3c30c@amd.com>
 <03068367-fb6e-4f97-9910-4cf7271eae15@amd.com>
 <b063801d-af60-461d-8112-2614ebb3ac26@amd.com>
 <29bff13f-5926-49bb-af54-d4966ff3be96@amd.com>
 <5a207fe7-9553-4458-b702-ab34b21861da@amd.com>
 <a6864a2c-b88f-4639-bf66-0b0cfbc5b20c@amd.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <a6864a2c-b88f-4639-bf66-0b0cfbc5b20c@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA9P221CA0022.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:806:25::27) To PH7PR12MB9066.namprd12.prod.outlook.com
 (2603:10b6:510:1f6::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB9066:EE_|PH7PR12MB7138:EE_
X-MS-Office365-Filtering-Correlation-Id: e6144bb7-c108-423d-86ad-08ddd9ce25ef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OUUvWG9FcEJWc2dLQW9XM3pyUnNYcjJqa3J1MGZEOWV6M0ZqSHF0QUhkb0RR?=
 =?utf-8?B?ZldIazdsUHhZcExvMjJDZWZPNjZYR213SmpvdXdKcDEzbDRaT0VLNlA2TTV0?=
 =?utf-8?B?dG43WDFMK0dRUzF2TlJxZForQ0RzaS8vS2hJMWt6NXZCM3RLZFVodXZuU0NR?=
 =?utf-8?B?aHpITkdlNTFYRGN5SUhYY0VkbGFid1Z3UkhhN2hTeEVFSDl3Uk52S3gvV1VD?=
 =?utf-8?B?QzMzblgvUWc0dTIvUW9makpxa0JyU210M0t0aWRoL2JlSXBCUUtxS1Q5a1RD?=
 =?utf-8?B?b3IrQlJQK2RmTTNmZWkzN2c1L2FEWjhzWm9ubW4xbDM1UXdrUExiU1hCWjBX?=
 =?utf-8?B?aFZhS2pTUDNpK3BZNkk0U2ZtTXJDdFFpOS9rSmJXK1lwclpFV1hmekdFbUk5?=
 =?utf-8?B?NGR0OHRTUEdYaDRzTGtRT09Tekd6N0xEUUwyajh5REVsNUM4aHVnRi84UC9m?=
 =?utf-8?B?dTkwdlNIQ0N2R1NDMW5KRjdaaUlxY0xRYzlnc1RHOGEwU3ZIa3E4Q1ErNG14?=
 =?utf-8?B?OHZ1TkdtQkJNempwUVVqcDF0VllMSDFlVFFJMjN2SjVobXpuYkVuMmZCZFM0?=
 =?utf-8?B?UExENVNkZFJzYUhjWUFLRzBQODVtNmZ6MHF1ZXRGNGxoV2orenNwRnpoeFRu?=
 =?utf-8?B?UU1hM0g2YU9IWXgxL3ZBemlXUkVYZ0tHallkRnpuSG1ISzZaa1ZlSmRtbzU5?=
 =?utf-8?B?cWRMQ0RpZUUxV3dqM3RVRVNpc1lDck5WY0svUm9ZSjdSNzBueTJMYkdTdHoy?=
 =?utf-8?B?Qit0UXBuT282dmZzcnYraG14QStwQVR6RlJudDA4MCtWR1dGc2UrOHZtbEdl?=
 =?utf-8?B?Rm9qU04va2RNYS91UVpvNTAwTXU1Q1JCUFhTSFZ2R1RsTExUdDRZVFEzSThH?=
 =?utf-8?B?UVdHREdNN2RBOS82U2s3aG54QURzL2gyeklBWWlCempaMDRQRGpnT08zdjk5?=
 =?utf-8?B?ckRBMFFHdy9VYUlTcG8xSjhFaGNlTGp4KzJmZ21UbXVQeUZWbGh0d2ltYWlv?=
 =?utf-8?B?QTM5ZkRzdW1EMVBTUk00MHljTzhiZ0EvSjlmRk5Zc2FaS2d4dytodFVkYUJP?=
 =?utf-8?B?Z0JSTWVoQnRDU0NrS2puQzN0ZDNQc3pJNmRjN1pBQ2hHNG5vTzZ3amhjVWx0?=
 =?utf-8?B?WDNma0o3eFN6NmIrdENVYUZETDUxS0JReFc2ZjE2RlB4azhKNWhNYkZRblpq?=
 =?utf-8?B?ZXp2UGlKTGJkbFFGcWRKYUhwTGhDZExsOXpUY0tpMEJ1aUtUNzkxNFdkM01K?=
 =?utf-8?B?clpOblpjdlVvWlBHZWZoN3Rvd2pka21XQVprWHFFc2NqTkd0T2ZxWVlVc29B?=
 =?utf-8?B?MzRuNnNBMTdEZVIwRkJOSzZZUTloeW9WajBzZlhlN2JQb0tDaG4vTENZVDVz?=
 =?utf-8?B?SU1wd0tXZ0cvVzZnazNsU0lsNlZpWStIL01ubXVKa0hic2tYU0pOQTB3SUFL?=
 =?utf-8?B?TUdsb083NllzNlJ3ZHk4RW5iaVdRejNDMUxEM2lrZnhmaFloMGJFSlJKSmYy?=
 =?utf-8?B?QmdQVUtBMytleEhkcFlsMWQxMzljUGNkNXRNM0NVNlc2SHZ6WTdNVjBsTlAy?=
 =?utf-8?B?S0kvMWZ4LzRxaUJrY3ZzM29KbHBGdktubXRiRWN3emE5OXZVM2pudkt5TGVJ?=
 =?utf-8?B?MXlMVTd0emsvVTlHS3lrTlFWZzlFclZlSWVnRzh1Tytaa3BLTVJldTR4NUJN?=
 =?utf-8?B?VUtobmhaU1RTYlpXcHZvcjl0L3JIaFI0aHhpcUJOYzJ3Snp6SmhFdXFrTUJ5?=
 =?utf-8?B?cVE3RFZsM0FJVWw3K0Q0TmZ3UzhrMXdBRUV6T05pNXJGT1VuMkFDT0wwVEMy?=
 =?utf-8?B?U2haQTY2Z2IwVWYyUDJPQjFOYlMwMFFlK1pVdk1nOHB1azE1Sk9sbHl5UDdC?=
 =?utf-8?B?M1gxcG1KVjV6RDdTZHZJeSsrNEJoamFLMDdpSXpGWVFmL2JTTklKVURORnVK?=
 =?utf-8?B?RkVUc29yK2prdi85dVlCYXd5c2RGaFl4Vk1NRWZ5SUM2TElucFdqQ3dRK1By?=
 =?utf-8?B?NjN6bjQ4a0VBPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB9066.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M0Y2MHlXTXFmYXhBbzc1V0J4NStPbkphbjlCb1VPY3BreG0yWjBIMCtPUytP?=
 =?utf-8?B?RVBYaUtwQkRFODJNVlNtdTdvUlkxUVpNUEhwbDN6UEd2RUUrdElkZUg1a0RG?=
 =?utf-8?B?MTJyUmJIc3dQbGF0NXM1WERMQWlYUXczU0FKTXNYdWFkRnNza1FIbEc1WGgx?=
 =?utf-8?B?L0V3RlNIMFZTcXpFcjBwTVIzdTBESjhlWm1HN1NzSFI4ZU8vT3J3SmYwc3Y5?=
 =?utf-8?B?LzEwMjBDbEZhc3ZtS2p6Mnp5TFNQSGczdzhRbThqMHJUVytyR296cEliaEwv?=
 =?utf-8?B?OGl5UGw0TXRob3BQQ1pmK09DVnFsYTcxdHdqcmJqZ3Y4eG5xL2J4QUFsWXJ2?=
 =?utf-8?B?Q05Jc3Jka2JETTJ2U2dCdjhJRktneHR6azUrSkZKcXIzTmxlYzB0djBRb3dX?=
 =?utf-8?B?dnZBL24zQ2luS01ERUJNclVoUzdTa05ERlRPY0Z3Mkx2TC9EYWxrWWJNWTBw?=
 =?utf-8?B?d1dGOFk0eU00QnVuSXRBYmZsTEpIR3dhOFBjMDU5VDA4YStnc1hmRUpkdFBJ?=
 =?utf-8?B?R3VyRklhSjVUT0lodDdEN0UxSThMT0dPUk1iemNJclBsMlBZQzRKRHFleGtM?=
 =?utf-8?B?TFcvTnF2OGZuelU4emxpbGtxaEpJRDlBUE5XRWZ6Z3BGNnhOVGdNSmUyTXg4?=
 =?utf-8?B?OW90SDZKSXJYU2tFaDRsVUhCVHNMWDhuMG5sYVlQWUZndStuUDJjTisxNEZH?=
 =?utf-8?B?ZDlBWHV2Y1owNFI4ZmpGeFc4dzdVUWg5MFlNOFhHLzhUcGFwbU5UK2YxcGNF?=
 =?utf-8?B?ME03bXBValgrU3JXZmZkZG82aFYvb09CRkF6K1FtUXQ2N3hsOE9VN3VGZE5s?=
 =?utf-8?B?blF3dzMrSERFNlJZdXFlZVVxdnpUK3ZmMnZUcjZWaXZyWnBIVm1NTVVDYXhD?=
 =?utf-8?B?WS9jU29tZTV3T3Uva0FtZzJhRUJxSHJiZ3NVMkNUSTRGUkFjSlpqR0Y3SWhS?=
 =?utf-8?B?TmVXU1YwaktRd0EwRkp3K0IxcmRNY1hESmZGOGNWWWkzLzh2WmVscmVoMDdB?=
 =?utf-8?B?SDNOcGdOYlFJQW0rUWpBMlN5ME45Y1FpNTg4WDc3cnNPa2cvLzVTeVhBMkJp?=
 =?utf-8?B?MUtjMVgvaWRvemhOTEx0dEFpWlUyOUwwT3g2WURNZHd6ZHJISlFycjNXU0Nm?=
 =?utf-8?B?MDBseGQwV0JmMVZ4SVMvY1J1Zit3UFIzaldvVk1QdEVSNjVVWWhRQnNXQUdn?=
 =?utf-8?B?dW1OeTVJdElzTWU3alI0eDVielU2RjA5QTNHYlUzb3FVN1BkZmhUbE13ZHpo?=
 =?utf-8?B?TFROY3N0Znl2MStKem45WlFjcWZEZWFQeHdPNkdHYzdKVVNBMFFZZTQvTGdU?=
 =?utf-8?B?QU9aTmRuRnJIbGQ1ek5wendRZ2wxaUVYMFZiUi9mM2cvQlFWYkxLdkVoWDdl?=
 =?utf-8?B?a2hLS0tIQ3ZSMXFvdHMxcUkzM0dDd2ZzOXp2RGxVdHFjTzQ3KzFrdWNOajQ1?=
 =?utf-8?B?b1VMbENhYUY5Tjljb0ZSY0Mxb3BIZ0NxUmk2bk0xZHhoZ0JCRGxNenk0WS95?=
 =?utf-8?B?NDU3bEZWUDBOOVU2YkpFQnBYWU9Cai90bllCU3FGNE9UdEpTQ1ZFVWVCalhh?=
 =?utf-8?B?ckRCckNiOFI5UVNNWmRkdVJmUjA4ckFFd1R5WGRITUlGTS8wMVVUcG1SRVo2?=
 =?utf-8?B?YjhGbTNhQUZ5YlN2eUdHOCt4V0RUdTR6NzNnRjZneHNjMy9DZGt6VyswRkJ0?=
 =?utf-8?B?L1ZYS1puQ0pUSTQ4ZWRtejVHcWNGcmYrYTloRWo0cWF2bVoyUWk5VlVNbGp2?=
 =?utf-8?B?NlJOWkM5VEh4R0c1TVZnQVNzd3FNSTdGTTlZUW9IVkZualV4Nk5SZzZMWlFj?=
 =?utf-8?B?VzdLa1gyZmtzKzVONHlxZHdzM29HMXV0RytnaG52eXpjSmFPdllId0R3eGVk?=
 =?utf-8?B?SWIwL0dqNktqdDJrSVZMeEpvbTl1YnYvYThQdm9lWnBackJrcUZscWFzT29m?=
 =?utf-8?B?UFZXVGpqdzl0b3pUWldrbjB6aHZXdzAyUHpCdmlLQTFWSUR0SGMvUk5LcDJT?=
 =?utf-8?B?dFdMSXZtSHYzVTk0QnJMc1RzbDRaemlOZkNzaEFCbHFpVHVYcWdyS3pEVWhr?=
 =?utf-8?B?ZW8wWHZFRU9KYnlHQmlaVXNKbW5ZeGtwNVZNenVxNGFXaml2ZnhLOXBEWjNa?=
 =?utf-8?Q?IuJGcjBJGFDVhCRYxusK4JfdZ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6144bb7-c108-423d-86ad-08ddd9ce25ef
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB9066.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2025 18:29:18.1605
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZjNipJbERubIgBRUzFUUsjGPTkXzX4N+Rtt3Sc9FJWDvgiC1M2FsplS1vRygrC2fcESXA7P7+40c/+vLwLFj8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7138



On 8/12/2025 11:45 AM, Kim Phillips wrote:
> On 8/12/25 9:40 AM, Kalra, Ashish wrote:
>> On 8/12/2025 7:06 AM, Kim Phillips wrote:
>>>   arch/x86/kvm/svm/sev.c | 47 ++++++++++++++++++-----------------------------
>>>   1 file changed, 18 insertions(+), 29 deletions(-)
>>>
>>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>>> index 7ac0f0f25e68..57c6e4717e51 100644
>>> --- a/arch/x86/kvm/svm/sev.c
>>> +++ b/arch/x86/kvm/svm/sev.c
>>> @@ -2970,42 +2970,29 @@ static bool is_sev_snp_initialized(void)
>>>
>>>   static bool check_and_enable_sev_snp_ciphertext_hiding(void)
>>>   {
>>> -       unsigned int ciphertext_hiding_asid_nr = 0;
>>> -
>>> -       if (!ciphertext_hiding_asids[0])
>>> -               return false;
>>> -
>>> -       if (!sev_is_snp_ciphertext_hiding_supported()) {
>>> +       if (ciphertext_hiding_asids[0] && !sev_is_snp_ciphertext_hiding_supported()) {
>>>                  pr_warn("Module parameter ciphertext_hiding_asids specified but ciphertext hiding not supported\n");
>>>                  return false;
>>>          }
>>>
>> This is incorrect, if ciphertext_hiding_asids module parameter is never specified, user will always
>> get a warning of an invalid ciphertext_hiding_asids module parameter.
>>
>> When this module parameter is optional why should the user get a warning about an invalid module parameter.
> 
> Ack, sorry, new diff below that fixes this.
> 
>> Again, why do we want to do all these checks below if this module parameter has not been specified by
>> the user ?
> 
> Not sure what you mean by 'below' here (assuming in the resulting code), but, in general, there are less checks with this diff than the original v7 code.
> 
>>> -       if (isdigit(ciphertext_hiding_asids[0])) {
>>> -               if (kstrtoint(ciphertext_hiding_asids, 10, &ciphertext_hiding_asid_nr))
>>> -                       goto invalid_parameter;
>>> -
>>> -               /* Do sanity check on user-defined ciphertext_hiding_asids */
>>> -               if (ciphertext_hiding_asid_nr >= min_sev_asid) {
>>> -                       pr_warn("Module parameter ciphertext_hiding_asids (%u) exceeds or equals minimum SEV ASID (%u)\n",
>>> -                               ciphertext_hiding_asid_nr, min_sev_asid);
>> A *combined* error message such as this:
>> "invalid ciphertext_hiding_asids XXX or !(0 < XXX < minimum SEV ASID 100)"
>>
>> is going to be really confusing to the user.
>>
>> It is much simpler for user to understand if the error/warning is:
>> "Module parameter ciphertext_hiding_asids XXX exceeds or equals minimum SEV ASID YYY"
>> OR
>> "Module parameter ciphertext_hiding_asids XXX invalid"
> 
> I tend to disagree. If, e.g., the user sets ciphertext_hiding_asids=100, they see:
> 
>      kvm_amd: invalid ciphertext_hiding_asids "100" or !(0 < 100 < minimum SEV ASID 100)
> 
> which the user can easily unmistakably and quickly deduce that the problem is the latter - not the former - condition that has the problem.
> 
> The original v7 code in that same case would emit:
> 
> kvm_amd: Module parameter ciphertext_hiding_asids (100) exceeds or equals minimum SEV ASID (100)
> 
> ...to which the user would ask themselves "What's wrong with equalling the minimum SEV ASID (100)"?

I disagree, the documentation mentions clearly that: 
For SEV-ES/SEV-SNP guests the maximum ASID available is MIN_SEV_ASID - 1.

Which the above message conveys quite clearly.

> 
> It's not as immediately obvious that it needs to (0 < x < minimum SEV ASID 100).

> 
> OTOH, if the user inputs "ciphertext_hiding_asids=0x1", they now see:
> 
>      kvm_amd: invalid ciphertext_hiding_asids "0x1" or !(0 < 99 < minimum SEV ASID 100)
> 
> which - unlike the original v7 code - shows the user that the '0x1' was not interpreted as a number at all: thus the 99 in the latter condition.

This is incorrect, as 0 < 99 < minimum SEV ASID 100 is a valid condition!

And how can user input of 0x1, result in max_snp_asid == 99 ?

This is the issue with combining the checks and emitting a combined error message:

Here, kstroint(0x1) fails with -EINVAL and so, max_snp_asid remains set to 99 and then the combined error conveys a wrong information : 
!(0 < 99 < minimum SEV ASID 100)

The original message is much simpler to understand and correct too: 
Module parameter ciphertext_hiding_asids (-1) invalid

> 
> But all this is nothing compared to the added simplicity resulting from making the change to the original v7 code.

I disagree, combining checks and emitting a combined error message is going to be more confusing to the user as the above case of (ciphertext_hiding_asids=0x1) shows.

Thanks,
Ashish

> 
> New diff from original v7 below:
> 
>  arch/x86/kvm/svm/sev.c | 42 +++++++++++++++++-------------------------
>  1 file changed, 17 insertions(+), 25 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 7ac0f0f25e68..a879ea5f53f2 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2970,8 +2970,6 @@ static bool is_sev_snp_initialized(void)
> 
>  static bool check_and_enable_sev_snp_ciphertext_hiding(void)
>  {
> -       unsigned int ciphertext_hiding_asid_nr = 0;
> -
>         if (!ciphertext_hiding_asids[0])
>                 return false;
> 
> @@ -2980,32 +2978,24 @@ static bool check_and_enable_sev_snp_ciphertext_hiding(void)
>                 return false;
>         }
> 
> -       if (isdigit(ciphertext_hiding_asids[0])) {
> -               if (kstrtoint(ciphertext_hiding_asids, 10, &ciphertext_hiding_asid_nr))
> -                       goto invalid_parameter;
> -
> -               /* Do sanity check on user-defined ciphertext_hiding_asids */
> -               if (ciphertext_hiding_asid_nr >= min_sev_asid) {
> -                       pr_warn("Module parameter ciphertext_hiding_asids (%u) exceeds or equals minimum SEV ASID (%u)\n",
> -                               ciphertext_hiding_asid_nr, min_sev_asid);
> -                       return false;
> -               }
> -       } else if (!strcmp(ciphertext_hiding_asids, "max")) {
> -               ciphertext_hiding_asid_nr = min_sev_asid - 1;
> -       }
> -
> -       if (ciphertext_hiding_asid_nr) {
> -               max_snp_asid = ciphertext_hiding_asid_nr;
> +       if (!strcmp(ciphertext_hiding_asids, "max")) {
> +               max_snp_asid = min_sev_asid - 1;
>                 min_sev_es_asid = max_snp_asid + 1;
> -               pr_info("SEV-SNP ciphertext hiding enabled\n");
> -
>                 return true;
>         }
> 
> -invalid_parameter:
> -       pr_warn("Module parameter ciphertext_hiding_asids (%s) invalid\n",
> -               ciphertext_hiding_asids);
> -       return false;
> +       /* Do sanity check on user-defined ciphertext_hiding_asids */
> +       if (kstrtoint(ciphertext_hiding_asids, 10, &max_snp_asid) ||
> +           !max_snp_asid || max_snp_asid >= min_sev_asid) {
> +               pr_warn("invalid ciphertext_hiding_asids \"%s\" or !(0 < %u < minimum SEV ASID %u)\n",
> +                       ciphertext_hiding_asids, max_snp_asid, min_sev_asid);
> +               max_snp_asid = min_sev_asid - 1;
> +               return false;
> +       }
> +
> +       min_sev_es_asid = max_snp_asid + 1;
> +
> +       return true;
>  }
> 
>  void __init sev_hardware_setup(void)
> @@ -3122,8 +3112,10 @@ void __init sev_hardware_setup(void)
>                  * ASID range into separate SEV-ES and SEV-SNP ASID ranges with
>                  * the SEV-SNP ASID starting at 1.
>                  */
> -               if (check_and_enable_sev_snp_ciphertext_hiding())
> +               if (check_and_enable_sev_snp_ciphertext_hiding()) {
> +                       pr_info("SEV-SNP ciphertext hiding enabled\n");
>                         init_args.max_snp_asid = max_snp_asid;
> +               }
>                 if (sev_platform_init(&init_args))
>                         sev_supported = sev_es_supported = sev_snp_supported = false;
>                 else if (sev_snp_supported)
> 
> Thanks,
> 
> Kim
> 

