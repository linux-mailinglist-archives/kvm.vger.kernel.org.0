Return-Path: <kvm+bounces-34759-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A0A7CA057FD
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 11:21:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EBE451887155
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 10:21:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30CE91F8938;
	Wed,  8 Jan 2025 10:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="LA2zG9XT"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2062.outbound.protection.outlook.com [40.107.95.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 958841A76BC;
	Wed,  8 Jan 2025 10:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736331624; cv=fail; b=K7A5jQNajhXvedVBam2F5CxoLpzkYvvZW/QtTM9Avaip59pRpz4sJjJEnizyRuxl8Ff4Rgtqlfdk5IMZ3gfKvJJHlYuyzMjcoxiu5myyQ8FLWutuw3VLtIDWMwUJWbogklKGxzp6OwKqrRmdqpb3nxnDNn9Rk93trQYXfGvH0Dw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736331624; c=relaxed/simple;
	bh=sc7VqFfpswLqsagw0JmyBLfGbyRTdZbhpsJRYIzKh4g=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bvsxgPM/sY7oA3fyKgHpqRKrHj2ntQb0IocPgOs02ienI2bnHLzbSYiUSEd07/6s0U5SpZnns5D1+BdWushLaUaSjVWeeIU9/KQR9edXojcq5jS+SxcYbOzpXIM4Z3PjnrW6laRKPWq5LVTcEfREKMkbyP77spu8AGZ6yMum9nA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=LA2zG9XT; arc=fail smtp.client-ip=40.107.95.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pbDyCHktAfvYZOuZAiPP6HO0dL4QmS8kdFiS0JA8nwgwCPGEkI1vQKmdM9DQPkn11z/aXNkm0I4c1ibhZ8eD186n0+sszXuxP5W92LmZotBs4NVqz6WAwpjpg/1EwXL07yFWNJKxfs5SP7G22srreUkGFW0HyU4pTTwuLeF+HU7+UnrqxdB3xu+Ot6c/t06LdyaGpxpsXzOlaBcxH8dsRVeMfLGzVbOtxmSDpgvw2sEAVDP7qN+LjdSzpS7TkMAaFJ+/w4+gHkdlAhqgvvkV4DWMckp4tdg1a6sCUFnfVWz9i/R0yxzpveE5E3ygtzN14Ly4e1rExFW4n71b3gKvvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nSUMBZcfl9ArUMEd+nTDNOXRP7YLCcQXhjknF8DluxM=;
 b=uLw1DeJCL+QX/scQt4+piMnV5jsa5OhsmxNwcnvz3eRYhmAGjwujhKm3r5SJMJt8kBvm4nGM4mRxtZ6vnVE5J9zOW88cuG5SmH5CVVwcdLdLVBpT/iAZpg0/T1tq6vRRBIfGcQhueknu5sfpqDSetvD+fHgGhTpN5fdnxecE68F66fXhTeQPbIR+OMMF8Yn/CNDUaAQkr/fkBCkvlYGW/IDFeVRBrHQkLzd738BbemPpYesL1GARQ0c6uW+aXbXOCxjPnzn+JvwdkQ/gdClt9PtRkurea90FfPy1tV9X3RQRBJPpTv307svJvIxphkNvsC/FHvVKlInX4Cog4grzRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nSUMBZcfl9ArUMEd+nTDNOXRP7YLCcQXhjknF8DluxM=;
 b=LA2zG9XTdSRS1j06UP6UY9tdCnGLFpVVG/fZbTLG3MUAs3ijEO51cILwWHiaETj/10EQHeAg8O1g/9bkmAoxoIgRM+P8Pw1Z2GyeHTPqDVfW1LMVd0LQQoxQoeQHL0SmRrdqZuPCcSIogNng3te5gZcpcasosBRfO72hOkRho/c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 CY8PR12MB7363.namprd12.prod.outlook.com (2603:10b6:930:51::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8335.10; Wed, 8 Jan 2025 10:20:20 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%6]) with mapi id 15.20.8335.011; Wed, 8 Jan 2025
 10:20:20 +0000
Message-ID: <cd6c18f3-538a-494e-9e60-2caedb1f53c2@amd.com>
Date: Wed, 8 Jan 2025 15:50:08 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 12/13] x86/tsc: Switch to native sched clock
From: "Nikunj A. Dadhania" <nikunj@amd.com>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
 kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
 pbonzini@redhat.com, francescolavra.fl@gmail.com,
 Alexey Makhalov <alexey.makhalov@broadcom.com>,
 Juergen Gross <jgross@suse.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>
References: <20250106124633.1418972-1-nikunj@amd.com>
 <20250106124633.1418972-13-nikunj@amd.com>
 <20250107193752.GHZ32CkNhBJkx45Ug4@fat_crate.local>
 <3acfbef7-8786-4033-ab99-a97e971f5bd9@amd.com>
 <20250108082221.GBZ341vUyxrBPHgTg3@fat_crate.local>
 <4b68ee6e-a6b2-4d41-b58f-edcceae3c689@amd.com>
Content-Language: en-US
In-Reply-To: <4b68ee6e-a6b2-4d41-b58f-edcceae3c689@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0215.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:ea::8) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|CY8PR12MB7363:EE_
X-MS-Office365-Filtering-Correlation-Id: b6d13c50-7d0c-4675-2977-08dd2fce0dc8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?elNjZWpQR0RGa3pJRll3aXFURFFPN3ptSlNsNnQyck51cWdlREdKcDNSNGg1?=
 =?utf-8?B?T1NLNjNqc2tQL2tHNlBxMVpiVDNPeDZISElzdlhqZnNiTXZRVjVtMHVFcHNF?=
 =?utf-8?B?VWViZCs4R3Q0Mk5rZk1SNUhPMVhpZ0lOdEd2Unk1QVRVY1VSaExvczBhTWRi?=
 =?utf-8?B?UDg1M1M0dW5TYll6K3NZbEJ1MmVHMElwYXB4V0RNSm1qRFlSREljN1NXSjJM?=
 =?utf-8?B?eEkzNDVVRmtHMS9BUmpYblZOT2JGNDZDTVFqMTFjZEFaRUxPSW8yY0MzOTZE?=
 =?utf-8?B?K1Z4Yk51d1JNbWFTY2dqTGs3Q3NONXp1ZWt3YVNieHI5UFlaNFdjQWRDbEZy?=
 =?utf-8?B?UngxN1dRNG80NnNMNmJRRDBkNlB6Y1d1ZndVQTk2OEZSL2J3RmdqT2lsaHJs?=
 =?utf-8?B?N0w4WW9KZDU0ckk4TDVUWGVmNm9RcWVORDZXWWYyZjZ3b0s3Qkd1YnlTQyt2?=
 =?utf-8?B?VGxpWStaNHZYeEtlLy9GNExmNFhpQ2w4NUw5L2NJVUo3UmRmTW1JWFpObUgr?=
 =?utf-8?B?K0h0WkcwZzZmTERXVCt3QVlBU2UyM1JxZmlMNmtsN2xmejNmMUZ3RHg5dFlv?=
 =?utf-8?B?RFQ4ZHpjQTVmUGZSdVdkbUtZelA2a0lPVE5uM3oxMjA1NGJtVnR1MTBnMkJO?=
 =?utf-8?B?K2diWHRlR01ZWGdqTjA4eEMvdUw5Wkl3TGw1Q3ZUbTZEQTZrRlhSbHpmcGtU?=
 =?utf-8?B?NWVpQTZ0SldJUUkvSC96aWUzNHRYdllnbllRSmt2RFViU2g0d1AzTkdvWHBw?=
 =?utf-8?B?R3FlUlkrRDdNdFgzWUtzaWpPSll1czFQZTI4OU0yZUxRS0tvSXZuWmw5SE4v?=
 =?utf-8?B?YXJjVVJZbHh1UUlFTWZxTWJKcXZ6R2xOdTgyY2FSdUFCRU0xdlZBa1o1NE9N?=
 =?utf-8?B?d2pyL3ZkV0dpQjR0VWR2R01BRmZDbERFeUc1VFhjT3BhZzNaMU4zY2x1N0x6?=
 =?utf-8?B?K0tXZ28rcjNqd3hhM0ZuYktIVHFCSkZwVnVueWl6N3dNWUlHVnJPK3lDUEJD?=
 =?utf-8?B?TFVjT0VmbGl6RHRnS1p1TWwyM0VlMDhqUjJzWUwwcW1kUDltVUJWU3ZiUUJP?=
 =?utf-8?B?cmNDemdzZUhsSjFEY1JIR0Y0d3N2WE9DN3BuUUpIWGZoNEJmSU42RE51d0du?=
 =?utf-8?B?UVd5M085VUNFUHJiSGh3T0NTazVhaXcxMXJJYy9jaVJhdFBrSXNGcjR1cWJp?=
 =?utf-8?B?N29xeFptTXVXTXVSUEVWZ3RTTExZZzVVZWJ0Yy9IcDBTL1REQmM0dnZua0Fn?=
 =?utf-8?B?bzVjY2Y3VmhldFQrcm1lc1dmNVdNanltOHdHb0pOOFg0RVI1UTE0cUFBR21B?=
 =?utf-8?B?eDd2cXV2a054aGR5OVRDUmVaTXFzRzNEeEU4Qm1udStGWHR5dkVvWGhBejBp?=
 =?utf-8?B?L1l6T1A0QVJYQWZjL3RBSUZTOC9KRFFCbWhST2RpY2xaSU1UY1FjNkNQQVNB?=
 =?utf-8?B?Z0ZrVDZ4Tm1SNTdrakhzTklUdFY4eEZPaTcwa25qN2JmSm5DREtvcTZvVk14?=
 =?utf-8?B?R2VDSERvbFBBUk5FSWtkbVM2Yy9BUzJUTDVXS0l3eUFvZHJvd21ubzBDYjhF?=
 =?utf-8?B?dEZPcllDSmJCS1lodEc1TUpseDhMRmZqUGFNV2pjWGxLY3VhclFIYnVybWxP?=
 =?utf-8?B?eVNKNTNYTllONTFQUUVVVEJnK2pZcER2T3EzTCt3Wkp6MDlRbVFzZTRpcW5O?=
 =?utf-8?B?VHY3UWtOUXRJd1NiL1h0Q1dyQjhZZjJZUjZ5bTIwN0RYd2ViRUQxemgxL1pC?=
 =?utf-8?B?YTFNM21waUxLWUNEMmdFL1hkUSs5WmpFVHhCNG1PK2VxWGRqdzB2UXBxRXhl?=
 =?utf-8?B?bDA0SW1QaWNkc01Ed2lVNVYyQU9Ga3NUbEY3NGtFZnUxMnJHbE4vcmMwQThS?=
 =?utf-8?Q?mBueQdQDsaxYY?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OVVjYVlpaDUwalJFVThPZFRIS3BpM05lY285Tm85L29kZmsvNmhiM0RDR0J5?=
 =?utf-8?B?SUNDdWlHc3VTL0UrSmhpemg2RTRTNjFGOTEzWU1TNWU0RGZIaVdJOEh5U2hC?=
 =?utf-8?B?VXJ2WmtGa1B1L3JJVGd3LzF5NWwrLzRLRk5nL1ptVjlwTC85WUJtWWZsUE1x?=
 =?utf-8?B?OERGb3NiUDNQY0NsYXdxS0tKQzljK2FpTHdWa1hEWFFUbEtXZ1llTGxIVUxp?=
 =?utf-8?B?V3JiL1plQ1I4c3BuRFBYZlNsMFZLcUpmUWowS1BCWkNPaC9lZEZTRzhxMlZH?=
 =?utf-8?B?Njk3bHFYbDAyTFcwei9OQ3VJZlVHSEh0d2NleTlNL1dheDdMaTNpNjRDVFlx?=
 =?utf-8?B?VGhTUUoxNnhpTEhvMDVEL2Z4dnlnbGxETlRSRkh3NUM4b1NEYTFOYWExdkZ5?=
 =?utf-8?B?OW1LZnJUMmVzSTNpZ3dtTGdJSEUxNmtuWXhrQ0pJWkVIdHBlRTM0WVZwQlBF?=
 =?utf-8?B?Szl6bjJ5dE5VU0tOQ01QM1Z1Y1JzNzUyTGl4YXVJTWJvUVFDTFJXK1pPNTdy?=
 =?utf-8?B?LzFFQ0Q3NG8xU0F3QVFoSklTMlM4UFc0YVUxTmYzMHNLeFRDQnlLdGw5RDlU?=
 =?utf-8?B?ZEpkSWFaRzR2MGdRekwzUmpDdHJlaDd6ZU1KYXZsVjJEQVFBR3hBSDhHQ2gy?=
 =?utf-8?B?WDFYc3pUQUhxQy85NHFKVjdyU2JMUFdOYVFyblY1bXVXQTBJVExUelpPcnoz?=
 =?utf-8?B?U1YxYm0reW9NbEhFTXpCQllLUmx4QU9tWWhaRVpieFFFc0lmUUFCMnJMd3BX?=
 =?utf-8?B?MGFIZGRWQ3NBMVZvMGQ5L3NEZ3h3WC9DdzZaTXdyTlQrOTlHZHRnL2wzZlBq?=
 =?utf-8?B?bzZHcEU5T1AzUEtaM2tKMm1RUHNSMDhwbElGMG84dG5pVVdWQ2NXNHB0Z1U3?=
 =?utf-8?B?YjB2a24ySFV6djNFMVI4OWlmNGwxbzErK0xVU0ZubDEzYkFJTVQySVVLclVl?=
 =?utf-8?B?cWtrRERKUWNjUHUwSlFhN0t3VW45MG5YWFYvVmJrdktQdFNqczY5Qm1RUW9Q?=
 =?utf-8?B?NVcveE05OGxCeTlMU3g2ZUFicDAzV0gvYXlxbU9YRFYxRm84aGI0a05vMlBj?=
 =?utf-8?B?ZmE3NVUvMVBNTE9lRDlBbDczQ0lHRnZaV0hQT3R5RFJrcEhTcEljNmFsbDRu?=
 =?utf-8?B?Q3d2OWdhamdGL0xieG5OQW1xRll6ajFRUEJvcXJSNjN1N2wyQmZFbXlHT3V6?=
 =?utf-8?B?b2N2TjNEcTdERDJpaFVCa1c3dnVMQUoxY04rNlQrMC82TkpQSW96RCtUemRj?=
 =?utf-8?B?TDMwUkFhTG1Ob2FoMjFPbFYwdnN1SDNUVWJSdm9BK29tYkI4a3lUenhseW5Y?=
 =?utf-8?B?cjl5eGN4R2poOFN2L1VndTA1dUxTSm01UUpmdFk3OVVwdW1nSklQSnBqM0U4?=
 =?utf-8?B?ZkZ5by93MVRsdzBtbXdEbTVPcUNoQkdidG1TUVBVQWtndldjbmloN0k3RlRM?=
 =?utf-8?B?RSs1RDcySXVJd0RGR080TDVkMGFRanhHQVRyRWZBdDdpNHZ0ZjlvbkkxTG5i?=
 =?utf-8?B?VGw3L3YrVXVoNTluaklNMjl4ZlRGRDJiMGU3WERQMlI2b080c0I3NjljTmJ6?=
 =?utf-8?B?T1hxNHlPdjNDSkZrVmp0NTdnekJWQTJrUnphNC81ZmJuLyttWmNHSVZ5SlVs?=
 =?utf-8?B?MmNFVVJtbUFQL0YxWDBlcmxyRmppOUhZQ2k4MTlxOTdaWHRhcC9pRFM4WnRv?=
 =?utf-8?B?NHV0K0p5eEpUQ0VoN21XTGRqWU5uRFFyc05GUlNINzZPSHMrc0VNeDR5c05z?=
 =?utf-8?B?U0c2MWRVendqdFZ0QzM5Vjh4Q2dNNkhnZEtZQ3JuMjJrQlNWSU9rZ0hmOGwr?=
 =?utf-8?B?dUlHMktFYWRYRHkyekZZOVdxY2p6OTFoMHlvblc5RnhPK1h6cGEwNHl1L3dk?=
 =?utf-8?B?VWVCNjJ5YnlUaVVVbS9wMkFKT01yRzZBYy9kNFFoSGtNakxISVhyTFFHU0xX?=
 =?utf-8?B?MUFRRFdVQ1dRQlJCN1luWFFmMHN1cER0cGlKOUpvdXh1U1JXaFdEdFBSeVNP?=
 =?utf-8?B?bXdVYXVaWUptZkJlOUJEbkYydHdHZitwSms3Mml2cHpwaGFmaWhlYVE2RWVQ?=
 =?utf-8?B?T2w1aktGVGtqcndyNGNiczk3QkQ5b1hjL2Z0TSt5VTZLc0JRY1dqd1JPSlFD?=
 =?utf-8?Q?No//BflFZcSYMTsBcS/7KfLGI?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6d13c50-7d0c-4675-2977-08dd2fce0dc8
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2025 10:20:20.0997
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Escs0Bt+jwYSo3yDpsuEa/M/F8GixeJvje+Gqf2+sWstD+njl6mE4RS7+9TEQyKKUxTch6Drb70RlPS/Pi5SAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7363


On 1/8/2025 2:04 PM, Nikunj A. Dadhania wrote:
> 
>> If you want to take care only of STSC now, I'd take a patch which is known
>> good and tested properly. And that should happen very soon because the merge
>> window is closing in. 
> 
> In that case, let me limit this only to STSC for now, i will send updated patch.

From: Nikunj A Dadhania <nikunj@amd.com>
Date: Wed, 8 Jan 2025 14:18:04 +0530
Subject: [PATCH] x86/kvmclock: Prefer TSC as the scheduler clock for Secure
 TSC guests

Although the kernel switches over to a stable TSC clocksource instead of
kvmclock, the scheduler still keeps on using kvmclock as the sched clock.
This is due to kvm_sched_clock_init() updating the pv_sched_clock()
unconditionally. Do not override the PV sched clock when Secure TSC is
enabled.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/kernel/kvmclock.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index d8fef3a65a35..82c4743a5e7a 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -324,8 +324,10 @@ void __init kvmclock_init(void)
 	if (kvm_para_has_feature(KVM_FEATURE_CLOCKSOURCE_STABLE_BIT))
 		pvclock_set_flags(PVCLOCK_TSC_STABLE_BIT);
 
-	flags = pvclock_read_flags(&hv_clock_boot[0].pvti);
-	kvm_sched_clock_init(flags & PVCLOCK_TSC_STABLE_BIT);
+	if (!cc_platform_has(CC_ATTR_GUEST_SNP_SECURE_TSC)) {
+		flags = pvclock_read_flags(&hv_clock_boot[0].pvti);
+		kvm_sched_clock_init(flags & PVCLOCK_TSC_STABLE_BIT);
+	}
 
 	x86_platform.calibrate_tsc = kvm_get_tsc_khz;
 	x86_platform.calibrate_cpu = kvm_get_tsc_khz;
-- 
2.34.1





