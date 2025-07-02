Return-Path: <kvm+bounces-51349-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F02DAF658D
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 00:43:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C86734A62EA
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 22:43:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6759D24E019;
	Wed,  2 Jul 2025 22:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="g4li614Z"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2063.outbound.protection.outlook.com [40.107.223.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E69FB1F76A5;
	Wed,  2 Jul 2025 22:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751496217; cv=fail; b=lzQs+Ifwi00fZ583YvOG38KkT183pNuBe04DL9uXFcAz+7rZBUoVi6FOtzz/r81N8+Ws0H6EIgDUnYalFhiWXHHKnH2uPVdEQBWNSWpUrlVvdXWkBSyTzJTK7UhkkKrl61wIn2NmAMQBpWm/jlg5El378/E/+qghizJYaRioAPo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751496217; c=relaxed/simple;
	bh=mlgdoaPxHr4zHGTqpJ46Y1dsinrc1kttHpJdKDHzM3Y=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Zym/yF8MlH9QvwDm/7K0AA+08fj52yFzeMeJ3Oe2pf9ulTgxhj5SwViwyLhgtfwE9ZE0w+z9nFvn3ivLCHBmLtWRqNBvss2KHwkpZR9KABkV2WgIXIhWk4mAiVs0XhEdVwpWy+p6r0n4uO1G47PyyEFwXp+1gWs+s8Dww7Fatxw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=g4li614Z; arc=fail smtp.client-ip=40.107.223.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cAfuFA5FDy42NaIbBZasldtaA7tESzZ6b8hjIaTrOy47jmORABOzuG1mXwoiI2nKiNwX2aHqf1jT0ViJexR+u8wNNg3JD4iCOG/HvDNo+zkbGFDWKxw5jY8xKDWHQxr8xuJdpwtQh4XTQV6losWLED5FEWDlLFqu113qQZ6XSYse6Mvc/AHTdHTSCdQLQtHY6BhNhZdhDIAin5XuW31T7bHKkroDS6zxu/E18rLdfdd8QP3+cgzkC9ryrjQMLW+3lBjPDdrT1L+YFcRcCBo1P5rTxte925g//2h99jo57yfsWoShv5veeTLtLVBSfqpC2bT3L9eq7lp1kREkoAW6wA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AybJB+08Wdfyh99eFd/3rIoK6DTA12mLu3tHTs8b0dQ=;
 b=XJNcbt6ud4G31cYMyJnCs5p82pMa2WzzPqeg16GSIkHAp+z/ourkEviH7WuPGNfY/zNSVf04LEQIDMxM5QW7DG47S0GoP5fFAOrwxBGXCfIv5XUKEMvsmX2jsRiSPjjGfvZTcZuAW+doc5AnXvtG9uumnEzwmt+XymMoeTn6ZW1oCMhkCg2/NIpuuDRY3NDeQnGUDYd5mmuPtkotrhPlC/Zk7u4f6mqA/NLGClL0WivYDJ3jbX6ahrVafCqNAK/vrM4nvK2H6Eu1dS2hdSCxev9lsIJg3E1/FnxTbDTLviaMTigQfV/w5qlsrRaGr17WHYS1DF1N34XYQrtyTOp5oQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AybJB+08Wdfyh99eFd/3rIoK6DTA12mLu3tHTs8b0dQ=;
 b=g4li614ZW55iUhIZZcItCas4tvrMYsOAJnN/C7GtbTVo3lotMkKVnlnuz4W/BOq1W78ujhcYMc465I8lYNJP/o8LSlPgncpkbnbz2MhLj9tqE7O+kWYkNVXAtF5+4oqKMhJbuoHQoK6qtO1Tj/4S0j0jUrTgfK9868ejv7B+Mw0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by MW6PR12MB8950.namprd12.prod.outlook.com (2603:10b6:303:24a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.30; Wed, 2 Jul
 2025 22:43:32 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%6]) with mapi id 15.20.8880.030; Wed, 2 Jul 2025
 22:43:32 +0000
Message-ID: <7598ff2a-fab1-4890-a245-9853d8546269@amd.com>
Date: Wed, 2 Jul 2025 17:43:29 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 7/7] KVM: SEV: Add SEV-SNP CipherTextHiding support
To: Kim Phillips <kim.phillips@amd.com>, corbet@lwn.net, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 thomas.lendacky@amd.com, john.allen@amd.com, herbert@gondor.apana.org.au,
 davem@davemloft.net, akpm@linux-foundation.org, rostedt@goodmis.org,
 paulmck@kernel.org
Cc: nikunj@amd.com, Neeraj.Upadhyay@amd.com, aik@amd.com, ardb@kernel.org,
 michael.roth@amd.com, arnd@arndb.de, linux-doc@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
References: <cover.1751397223.git.ashish.kalra@amd.com>
 <b43351fec4d513c6efcf9550461cb4c895357196.1751397223.git.ashish.kalra@amd.com>
 <790fd770-de75-4bdf-a1dd-492f880b5fd6@amd.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <790fd770-de75-4bdf-a1dd-492f880b5fd6@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN7PR04CA0173.namprd04.prod.outlook.com
 (2603:10b6:806:125::28) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|MW6PR12MB8950:EE_
X-MS-Office365-Filtering-Correlation-Id: 10685976-ce87-4900-ee63-08ddb9b9df72
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?U2VNOWFyUXZjbWdMbzJKbnhLb2lrcnk3bmlqMkRPL2ZLR1JqNURhaHUza21M?=
 =?utf-8?B?c3NJWWdOTkh4NHcxVUdJaVBhRWJjc0NCaTJjUk5lamtJTHJyRE90T1BqZWhi?=
 =?utf-8?B?dUJHanR3VmNFSEZobm5nQ0tjd1F4N1Y0STh4a2RnU3dUZURGYVE0SHVwN09M?=
 =?utf-8?B?dURCbm40TlVaTERVaGt5RDA2dTFkL2k4bERaNFpUOGdnd1JqcC9sYnF0THRq?=
 =?utf-8?B?d3NkZlREaXMydG5kR2tMOHNBWUIrS1B4Q1pJczcxYTFkYURZWGdjcitDanVR?=
 =?utf-8?B?S0hRREhldXJDUXVFTktYekcyMjgzV1BrK2F3Q2RMNGtlYmR5RXFESC9KM21p?=
 =?utf-8?B?cHk3eEsxUDRZakZaWk1iblR4L0dheHFTYjRRUmRucnJDYmpqUmR1SzB2SWF1?=
 =?utf-8?B?SUd0MDFGRjFGV05aTHB5NHZLMktvemI3Q051dHZyOXVJV1dyaUp4STI3Tzdp?=
 =?utf-8?B?cysvWkh2VUtDMWdsS2VBTmhHaGlxZnYvSkc3VlkzMkp6clE1eHBsdzlsR3Zv?=
 =?utf-8?B?NktZQzY1d3hBSlR2aTE4UlREbElEbEo3RzJwTG1SWGdWa1I0Z2UzSFR0emNZ?=
 =?utf-8?B?c29VTWJWVUg3THg1RXB2a3Avc3N3d0d4V2huS1BWVG9kbXpDSktDWkFrQ0hT?=
 =?utf-8?B?UUZmQ0tjR1I4cUd0OFo2anNtTjM5VlBaRDVlRTFKV016VmYrb29iY01mdlAr?=
 =?utf-8?B?K2c4aUJtTnoyL1Z2TFJVSENYU3U1R1ZMS2NkcUh0Qk0xWXpKOVJLcGcwSUx4?=
 =?utf-8?B?SmR2UUU5NjRCRFl5anZzYTFwWmoydjQ2RVNaNTI4a0Q2R2N4dWpkS3BHOXR6?=
 =?utf-8?B?bHJOcFN6VFpxSVNRbXhQbGRnaWN5ZStsUjQzMlY2M0JaVCtSWURXQlkrOHht?=
 =?utf-8?B?ck1EYjBZUlRodExJVStsSmhhbHk3bGxvQ1BoWjBBT2U1N0NRb0FlaVBPS0xI?=
 =?utf-8?B?eWRnZG00OVpvVnpmaVVKWWpmK1BFWUpFNHRhcmVuSVFGQ3dZdGZKRmVpaXpW?=
 =?utf-8?B?WUhPL0ZtdVo0ZGpoT3R4d3JmeWVHMy82S051M21xS0dmWVFpbDBnL1BEeDRz?=
 =?utf-8?B?UGlRQUlvcmNXaDdWU2ZmeEVXS0h3bk9kWHQzQlJad2Rnb1RGZWw2Vi9LNWlD?=
 =?utf-8?B?QmhRSHlyU3IxdndxSTdjV095eGlkRFlQNUoyQ1JQOVZqTmpobEJLTnRtYjVa?=
 =?utf-8?B?alVDK0x4d2ZGeGNJN2MrcTVKK1h1ZnptUEIxcGNKY3JwblFPa0JlS3lSY0w4?=
 =?utf-8?B?MjJiY2phWDI3ZDI2bEVFak9YcG1TSStrTnpPUVdTMzkwaTJpeTVQYlZNaEhS?=
 =?utf-8?B?TWdLMWhCZ2xuMXYyazhIY09wSzBuSll5SjVuUTRVbFQxRTduMjBhWnQxQkRw?=
 =?utf-8?B?dHF1SWNaU3NBb2RjKzdiajZPN2V6dUV6dkoxSlNkT3NxWjB5a2VWL1RIRWtL?=
 =?utf-8?B?NTM1a2N2a1N4L2Nxa1FGaFZ2RkpHL2lhTFZFdFFTNmlJSFVmbkN2aCtXTXAw?=
 =?utf-8?B?SnBYYzA2Ni9jWFQ1NlJRYmhzenVrcDA5QkdmaXVuRUR3RkhwQXlpQkloZlpT?=
 =?utf-8?B?MiszSVZ5NUdkS2JSRmJVM3RIaWtxUVNPdkRZck1jZVhiOWRNRHFFbFg3S1JC?=
 =?utf-8?B?dUxBLzZQSDFtY2pyRjdja1doSFZveEtIZWpxVU9qYTRzNFZTRVpLVElLaWJO?=
 =?utf-8?B?aDRLaExydHdRMnM1MHJ2SVE3eVRrWnZJZ3B2cTRaQjdEQmxhUHcxa2MwdFdu?=
 =?utf-8?B?MlBxOFhWZ3dFZmhiZFExRTZDc3Iva0Jta1hzdFp2b1B3eDZlSDZuQjRScUNW?=
 =?utf-8?B?SVBKaVhZNFpkN0tiUzFsWUtlWnpGQWVSV2ZaakpCMWJPbTlZRmFxUTBLa2FB?=
 =?utf-8?B?cW9tZ3hRczBwYXZpeUZTUlY0V2c0K2YzS04xcTdKQ2JvOE1xS1dhbmdubkdH?=
 =?utf-8?B?QWZFUVlzUjh0WmptOUE5akE2V3FwR01HZkdkQWNVSlJ3eXBjdFIyVS9HNk51?=
 =?utf-8?B?b016MCtqeUxBPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OGpyeEQrMFZxWU5zK2drT3F0SlRKcUt0b1Y2Sy9yYzVoR1pldk9PaFRRUVJt?=
 =?utf-8?B?aGlHYW1LcTRGemdjenIvVFlLVlQvRVZ0Nm8zZzZWUTRncVcrdHAxYmJJOG91?=
 =?utf-8?B?U2k1YkNkN3pWTXlBMzZaUVhvcmc4bVQ5NlZ1M3I3YTEyQVdIOWgyeUlUa1ZN?=
 =?utf-8?B?K0FSZmRnSHVFcjFGU29aQThoSzloTzZsKzJJK21jM2Rjd3JBQk8wNXN5bUhV?=
 =?utf-8?B?YVR4MGpvR2pFRFpJQUYwNGtYVE5za3F6KzdKcXF2c2w1N08xZ0xKZG1QOHNP?=
 =?utf-8?B?MDJTNHkxUmFmVFVaQkF3VUIvcFoySnU3Vmd2V0lNWjdtb2JqUDNyT1RqRHVZ?=
 =?utf-8?B?bXhuQXNRUEVBRkhMTVVmT3A1cXBZY3FmUUtLdndKdVo2QWNJM0g1eVY0YXdn?=
 =?utf-8?B?QUFXTzZabDNGV1pvVUx0OE9zK3BmS2JtM1lTeStFNHRKODFmOE1vblZ1bisz?=
 =?utf-8?B?OGlQYXc5cTh2L2dGa2tmQ3lWWkdQNmFOeXlJN0lPU1ErclFPcS80NDgwWVRr?=
 =?utf-8?B?QlM3ZkhBZml3S1paaUF3am1NTDFrTnRPQWJoL3NLQVpQdWJLL0ZKb3Vqd2sr?=
 =?utf-8?B?K05Vanc3QnBobHBhK3VaQUo2Y2VuNlhVRUhIRUxnejBMcjNsNTdLVTVNVG9i?=
 =?utf-8?B?VzQ5c25jRy9xV1FsOXd4VGcvZWxuaGJWYnViZUFuclpsbi9jK0NoUFFnalg1?=
 =?utf-8?B?RDZ2R2NzaGc3aWllQzBLWUgzdXo4ZjdTSEprNEpxaDY2SEJyMFNYRDRETE54?=
 =?utf-8?B?KzVmdUNZZ3N0czM3KytKdGNod284Q1hJdUMxb2RnaTBDaGdLWG90MHNBQVk2?=
 =?utf-8?B?SnVWQ0xXWU10MUtnaUVqdk9kUm1kREZST0lwR0xHM0J6Y2tkRGVDZ3h2eXMz?=
 =?utf-8?B?LytGaThiMmpJU2FXQjNydzY3ZHNBR0JDeWxhMU0rRk5nL2xVL3g5N0srNERH?=
 =?utf-8?B?RWNrUGQ2aVkxODFTK1hSd0hlaXZyam13OWZIcnNjT2g3TldqelpvaVZVYXJY?=
 =?utf-8?B?QUlIOUlEMXVWdkZ5bmwvYUFXTEdwbzVGVnEyZS9MbGwvd2E1cHhUODJQNkpZ?=
 =?utf-8?B?MThWNGxUckhncE1DSVQ2MkNaZm9ZVmltMTE0eDBOWi9WcW5meFVmRGJiT2du?=
 =?utf-8?B?bFZoQ0Z4NUFrUC84ZEJYSEVocEhNL3J4Z0FtQitUYUxUU0JXd2t4QVlJRXU2?=
 =?utf-8?B?OHdBZ28wYmdtZ3V1bUh4TmR1aW92Q25TSVliU3k4ZlF5V0l0NksvZXh0NnJD?=
 =?utf-8?B?Q0dISDdLK05yQTZBNUpQZ1hOMzFLcWpYcUkwOEt3U0NBOEpvd3dUbjlvMlBj?=
 =?utf-8?B?RkZIQXoyeHJscERCdkpteE5PTFhsWERtbVFpbEl0NUhRbDJyYU5IUlZjRXU4?=
 =?utf-8?B?QjlSRGcxRWlHbnQ3QVN6bGhCRHduSFhOYmMvSGVqcGNzYWpkWHlMWXhabjNv?=
 =?utf-8?B?eWtLYU5oc2p3azUraDJFL2hNUS96N2NMTWUvUEZJakZIYVpHc2hBTjFYZFdk?=
 =?utf-8?B?dDJrQ1c5OXlmd0NyMFB2bGtBWDd1Yjd0ZHQwZFo0RG5JUHlwcUxGUGtIU0dN?=
 =?utf-8?B?Sm8zNzRZTFN2MmpVU2hQVHJXY2EraExOSlFqRTVpbFNsMkwvL3kreG51Uzgx?=
 =?utf-8?B?SkxFdk5BRlZlNTRLSWdvVWJ1SUpEQVZkYS9TSzFwRERnK3ZjNGQ3M2JyaWll?=
 =?utf-8?B?K1VwMGh6REp2RlB0dkN2TlZCZEhSYzJaUkVRSEVSY2kyZ3RGcHFDbU01NzJB?=
 =?utf-8?B?cHhVOERpQXUyN3daWjIwL1VwVWg4dzhaMzkzTlJlNVc5aGJwTGtWUUpub000?=
 =?utf-8?B?aUV5Y05TTjQ4R2NPa2IweTJGVytQVHAyMzk4c0RpRDQ2RElMRzA3eTZSV0pR?=
 =?utf-8?B?VTNJdFM4eWpBeWpuYU5NbUdBbEZuSU1IRTZ4QjIyYlJnYWtDN0JGeDlQcHNM?=
 =?utf-8?B?SjFkRG5yWnhRdW5GUEVPMGZZWEFyTVVIOHpHdlhzZk1iclBheVNjSFFOd1Fa?=
 =?utf-8?B?eHh4RXlBY2lLbUtMa25LZmpVaGlZZ1F1Rjg1aXJsakI0VjU2YWRRSGFPdHlY?=
 =?utf-8?B?VDc2SDQweDUwSlpGaGNmc1cybFVFNmhEQkx4R2x4TzZzcVU2RzloNjQ3MXBy?=
 =?utf-8?Q?qxpIKPgJ1rGyOvIT70rt4b0Ye?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10685976-ce87-4900-ee63-08ddb9b9df72
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2025 22:43:32.7109
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cNTJ+V45OKF6QrLXxbsFsyXDzNjd3Nd6iP4JvzTGUT5+tTqmNFywXAiOfi5Ghjg1p3eXDrzDtszyS06Ok0V65Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8950

Hello Kim,

On 7/2/2025 4:46 PM, Kim Phillips wrote:
> Hi Ashish,
> 
> I can confirm that this v5 series fixes v4's __sev_do_cmd_locked
> assertion failure problem, thanks.  More comments inline:
> 
> On 7/1/25 3:16 PM, Ashish Kalra wrote:
>> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> Extra From: line not necessary.
> 
>> @@ -2913,10 +2921,46 @@ static bool is_sev_snp_initialized(void)
>>       return initialized;
>>   }
>>   +static bool check_and_enable_sev_snp_ciphertext_hiding(void)
>> +{
>> +    unsigned int ciphertext_hiding_asid_nr = 0;
>> +
>> +    if (!sev_is_snp_ciphertext_hiding_supported()) {
>> +        pr_warn("Module parameter ciphertext_hiding_asids specified but ciphertext hiding not supported or enabled\n");
>> +        return false;
>> +    }
>> +
>> +    if (isdigit(ciphertext_hiding_asids[0])) {
>> +        if (kstrtoint(ciphertext_hiding_asids, 10, &ciphertext_hiding_asid_nr)) {
>> +            pr_warn("Module parameter ciphertext_hiding_asids (%s) invalid\n",
>> +                ciphertext_hiding_asids);
>> +            return false;
>> +        }
>> +        /* Do sanity checks on user-defined ciphertext_hiding_asids */
>> +        if (ciphertext_hiding_asid_nr >= min_sev_asid) {
>> +            pr_warn("Requested ciphertext hiding ASIDs (%u) exceeds or equals minimum SEV ASID (%u)\n",
>> +                ciphertext_hiding_asid_nr, min_sev_asid);
>> +            return false;
>> +        }
>> +    } else if (!strcmp(ciphertext_hiding_asids, "max")) {
>> +        ciphertext_hiding_asid_nr = min_sev_asid - 1;
>> +    } else {
>> +        pr_warn("Module parameter ciphertext_hiding_asids (%s) invalid\n",
>> +            ciphertext_hiding_asids);
>> +        return false;
>> +    }
> 
> This code can be made much simpler if all the invalid
> cases were combined to emit a single pr_warn().
> 

There definitely has to be a different pr_warn() for the sanity check case and invalid parameter cases and sanity check has to be done if the
specified parameter is an unsigned int, so the check needs to be done separately.

I can definitely add a branch just for the invalid cases.

>> @@ -3036,7 +3090,9 @@ void __init sev_hardware_setup(void)
>>               min_sev_asid, max_sev_asid);
>>       if (boot_cpu_has(X86_FEATURE_SEV_ES))
>>           pr_info("SEV-ES %s (ASIDs %u - %u)\n",
>> -            str_enabled_disabled(sev_es_supported),
>> +            sev_es_supported ? min_sev_es_asid < min_sev_asid ? "enabled" :
>> +                                        "unusable" :
>> +                                        "disabled",
>>               min_sev_es_asid, max_sev_es_asid);
>>       if (boot_cpu_has(X86_FEATURE_SEV_SNP))
>>           pr_info("SEV-SNP %s (ASIDs %u - %u)\n",
> 
> If I set ciphertext_hiding_asids=99, I get the new 'unusable':
> 
> kvm_amd: SEV-SNP ciphertext hiding enabled
> ...
> kvm_amd: SEV enabled (ASIDs 100 - 1006)
> kvm_amd: SEV-ES unusable (ASIDs 100 - 99)
> kvm_amd: SEV-SNP enabled (ASIDs 1 - 99)
> 
> Ok.

Which is correct. 

This is similar to the SEV case where min_sev_asid can be greater than max_sev_asid and that also emits similarly : 
SEV unusable (ASIDs 1007 - 1006) (this is an example of that case).

> 
> Now, if I set ciphertext_hiding_asids=0, I get:
> 
> kvm_amd: SEV-SNP ciphertext hiding enabled
> ...
> kvm_amd: SEV enabled (ASIDs 100 - 1006)
> kvm_amd: SEV-ES enabled (ASIDs 1 - 99)
> kvm_amd: SEV-SNP enabled (ASIDs 1 - 0)
> 
> ..where SNP is unusable this time, yet it's not flagged as such.
> 

Actually SNP still needs to be usable/enabled in this case, as specifying ciphertext_hiding_asids=0 is same as specifying that ciphertext hiding feature should
not be enabled, so code-wise this is behaving correctly, but messaging needs to be fixed, which i will fix.

Thanks,
Ashish

> If there's no difference between "unusable" and not enabled, then
> I think it's better to keep the not enabled messaging behaviour
> and just not emit the line at all:  It's confusing to see the
> invalid "100 - 99" and "1 - 0" ranges.
> 
> Thanks,
> 
> Kim


