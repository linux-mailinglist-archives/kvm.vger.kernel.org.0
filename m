Return-Path: <kvm+bounces-69730-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sKS2K6DGfGnaOgIAu9opvQ
	(envelope-from <kvm+bounces-69730-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 15:56:32 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E8570BBCF2
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 15:56:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 42E0D3011C7B
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 14:56:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEB153328F7;
	Fri, 30 Jan 2026 14:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="uZDDkC2k"
X-Original-To: kvm@vger.kernel.org
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010022.outbound.protection.outlook.com [52.101.61.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF5B42D97BA;
	Fri, 30 Jan 2026 14:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.22
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769784976; cv=fail; b=ma3oPW/GjEp0c5ITWT8OmEay1/9yuBknJBzsL7zRyzA+dZeGMbUfxogH2PylSHz9XxgxdZL+596QjZqioPZJ9ThHIRgLCTLI1ueqXI93BIxVJyt2GhDTL18JAtzZn42UArfq3FmGYmXs074DGRhIUONE5FMb6eDRDQNNj8V5VG0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769784976; c=relaxed/simple;
	bh=i1YGO2zOJybnqVtSa6M2ne9hgaRPw4T19V3jIbzujHo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=K8jU7aVbif/CFHDKimeKxxccn4lJ1rmPOMiSOTmpSt78Mf5+eQ4x1KQFFPjmIMYAP5KSQ7QUSGudzr1sz3HH24Gcc8faLK0MA/VpNK+UZxfS4J15nrQr1A5jMMmEhYa2axEc7U5h9C2Ckjt7kH+oydj4BdInODxaSkazpUarYwk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=uZDDkC2k; arc=fail smtp.client-ip=52.101.61.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DkgwvhyHBe0TrgfckusZvhzVFiWvEZMFOQSeKGseVNicguIa9dNtv9O1xznJnnFldffiKAIeo5mazGlazumduBLC87PDzM3twj1aXDunimmuxAotBnlod07Y3NUob01bhwqBwG3Ewih69b5/vi3/5pJh2DD1g0AIY2JMBXU/KDZY+Ludv59CV3fAfH4DqOYMFtxa87cZXtV2wGjfeOiCiKD6Uo+hdUvKwGCS9DYBQGqw6NWdVhrjAzMjykS/HijE3TPqKwtrG4pXqO4gr6BZfKXf+CSibH8JYwYUdRWj7NK7mJ2ANbhhXliVVpqoOmw8ggi08fO3HmaWX7DBJXRIcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TISl19RZvBtfEZhSxJUu8xXxheTdCyp6Uv+Zu/AsMx0=;
 b=jjXvTLPeMmWuLdlIbRLl+KL5lEONwMxFQ4vS1k9j/2u9fHCuyza4T8E+MTG1YjzEsts22CdqJnarITHsYhHlqadySE9a+/Kwo3AveqQzTLEQ1rKypBVb0vKVN1/HIYEjZ0+4VnsgabN5gO8NSTrfVOuYHvPzGI400EZyrJnL9whciIp/Y+1HTrdHK6TdGFnJFH0BKrq8X5XrkibtSAC6ovphnp65sDl+98ux98CKti0wIzbLyXGMbb+dEjtPfnWia7VzirK9ywxgiGJ3/a9ppTS5D+zhtYFRnd+uRCT2ve3mxyMnBrxgfNtzDdgTf3Zj25XfWo8dMgjYBrLJVAiBuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TISl19RZvBtfEZhSxJUu8xXxheTdCyp6Uv+Zu/AsMx0=;
 b=uZDDkC2kVkD+IkhyXvz1ZzF2LpwZdPQk8oiNo4M+aoyut3nMraLSC3kJZjmNE/ynsasOvkkszY5xyFxGVZ1BWo4qyewywb90ekpxbCJZSAiB/lVg5vecbK8QsQBYno/CLALqwiFi1hLpFW0t+B4AjM4RY4GkX9Ru70hGuKMi89g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5062.namprd12.prod.outlook.com (2603:10b6:208:313::6)
 by DM6PR12MB4139.namprd12.prod.outlook.com (2603:10b6:5:214::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.12; Fri, 30 Jan
 2026 14:56:11 +0000
Received: from BL1PR12MB5062.namprd12.prod.outlook.com
 ([fe80::5155:289a:c3ed:f959]) by BL1PR12MB5062.namprd12.prod.outlook.com
 ([fe80::5155:289a:c3ed:f959%3]) with mapi id 15.20.9564.006; Fri, 30 Jan 2026
 14:56:10 +0000
Message-ID: <2295adbc-835f-4a84-934b-b7aba65137a8@amd.com>
Date: Fri, 30 Jan 2026 08:56:07 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] KVM: SEV: IBPB-on-Entry guest support
To: Borislav Petkov <bp@alien8.de>, Kim Phillips <kim.phillips@amd.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 linux-coco@lists.linux.dev, x86@kernel.org,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>,
 Nikunj A Dadhania <nikunj@amd.com>, Michael Roth <michael.roth@amd.com>,
 Naveen Rao <naveen.rao@amd.com>, David Kaplan <david.kaplan@amd.com>,
 stable@kernel.org
References: <20260126224205.1442196-1-kim.phillips@amd.com>
 <20260126224205.1442196-2-kim.phillips@amd.com>
 <20260128192312.GQaXpiIL4YFmQB2LKL@fat_crate.local>
 <e7acf7ed-103b-46aa-a1f6-35bb6292d30f@amd.com>
 <20260129105116.GBaXs7pBF-k4x_5_W1@fat_crate.local>
 <f42e878a-d56f-413d-87e1-19acdc6de690@amd.com>
 <20260130123252.GAaXyk9DJEAiQeDyeh@fat_crate.local>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <20260130123252.GAaXyk9DJEAiQeDyeh@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0069.namprd11.prod.outlook.com
 (2603:10b6:806:d2::14) To BL1PR12MB5062.namprd12.prod.outlook.com
 (2603:10b6:208:313::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5062:EE_|DM6PR12MB4139:EE_
X-MS-Office365-Filtering-Correlation-Id: b2b58081-05f8-4953-6d79-08de600fb46a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?alYvanNqaEhhR3F0UmUyNXNYYlpIa2FMME82aE9RTmYvZkt3ZUlKbHJtVXE4?=
 =?utf-8?B?R29UZFBYL1dsVWNlSHJiTHVHTENLRTZ1LzljVXVGekdGUGtYYnQwRHRSZUJ5?=
 =?utf-8?B?WHNtdzk2K0gzMkNzWDg5ZmxnTUR4VVNSM3FUbDh6Z2I0czQ3L0VxUUFIZTV5?=
 =?utf-8?B?QmFKZVpoRm0vaEExYlZnQ0l3LzRsa3F1TlpSSHVlcldOOXgzcDUzSlFla2F1?=
 =?utf-8?B?dHNWV3hOTU9VZG4ramtoU2VIbkRkTjNFUkpzSGR0cGY3WUlnaTdob1JkVVk2?=
 =?utf-8?B?cHFRVzZGMlVLblNZSWMxZFF4a2dRb1NmTXBjbFYyc2dyQnQ5SDduSXJRMSt0?=
 =?utf-8?B?bVcwUVFGbUVraGhVS0NvbENIVzJwdy9kaEFjV1VraHRCeXM3OGpEMlQrL0Rk?=
 =?utf-8?B?QmZkaW9rWWU0ZTlxdFRaazQ1bWpkQkNhRkk0SUd1ZGZUY1hwNThaWFFTU2M5?=
 =?utf-8?B?Skordjl4UGZaNmtwZUF4bDBLL0d4MC9YdjZVUFV2Vk9oMVhFeVhKSUNLaytz?=
 =?utf-8?B?b2owRElHTkRMWE0vYllna0pIYitlaDlHNEZ4SVhjTFBoc0dOQVZGVjh3eW5D?=
 =?utf-8?B?Wi9VRHdOeXVzY1d5WFZmbWo3L1ptd0txUFRwRlNEQjh4WEhFQU9EOUVNc3l6?=
 =?utf-8?B?dzNVUC9wTkFJT2NROE9MdVBmWUNvM0JTcGlPdXMrVk5icTNCcENuU0FQcHdo?=
 =?utf-8?B?SitYVWlIV1RCaUIzRXlCWTBsUUpjT1p3RkZyTkhJNExxb0dFQmV0aU9Gd3BK?=
 =?utf-8?B?a3JkVTJBVytFdmRPeE5sYjNNbzUrM2lYVFJIOFRHT3VLWFFVTGd3T3pRY253?=
 =?utf-8?B?d1hUU3NiaHFWWHd2SGJlZDRJU1NpZldBbTRUOVdlQVhpbWUxdVk1Wmo5b1lX?=
 =?utf-8?B?ZXFGc1A0UW1EbVh6WS8zcDBpZDZCUUZqMFRrVTByUVJRb1lKK0k5aFZRVFpD?=
 =?utf-8?B?eUhSWEFFR3E2Ri9aTTNvWTN0ZDIzdmZGSHBiQ3ZuYncvK3RDVHVsUFJTd2tp?=
 =?utf-8?B?ZEFjVVlxWnRFVEtjNDkraWQ3T09SN0tIT2ZrcEFWUFlYUzZ6U1VwdzlMMnky?=
 =?utf-8?B?RFQ3aExjbit5OFhTajhMbml6aTFEVEFKZXJLNC9ybzgzZm5xWkxSZnNuTWt6?=
 =?utf-8?B?NWxkRTNCazRNV3YzMDNuSWExNDc1bnd2SVAvUVlvdEVyaVNDbnNYbkxCRXpM?=
 =?utf-8?B?aHNrRk1Cb3g0eTFacFJDRVc5ZG9CWENGQWpyWktZWkk5dmwweHdiTVk5MFk5?=
 =?utf-8?B?MGt2ai9SN2Z0OVFOTU1hRlRUZVp2aXpMTHp2L2h0MkRoVFRGMVlLWlJvbXFn?=
 =?utf-8?B?MDFzVWYzamcvS0N5eUFmdExTYVQyS3oxTzRiT2hyQmJtdUdGMmNnM3RzSENn?=
 =?utf-8?B?YURncFNZV3JzbFBGbnJhR0VNanBmNkpqcDN3d1YyTWJ2M3A1dzViREdBd3A4?=
 =?utf-8?B?MXJwb0owR2k2MDNMaUtYYXNhK1FGV1krNXJoL0Y2QS83QzFqVlZtWS83b1h4?=
 =?utf-8?B?amFpQmMxUGJ6R1kwR3AreUN1eVJmUi9zdnRNVWNQSDY4aUVwdHN1L0tmZW1K?=
 =?utf-8?B?ZEZJWm1XcG1rUk1SRENwcXJOK1dJTCtnL0laTVNqUFNCRU1OMmRIMzJQdk1i?=
 =?utf-8?B?RXNrNndaRy9aT0R0WHFja0xOQ2hpVFdUUDNaRkVrTVlLMVBkTkhBVXdJTjhR?=
 =?utf-8?B?QXo3MlhicmVQUXU5SUorYlF1TlFVWkc1bmxiaDBXYmErcjhqaStQbDBSKzcw?=
 =?utf-8?B?RXArRTBXTnZqbU9KUGhDeXl3VG9ZUWpmSDNDZXJnS1JVM2FURm42Q0Z4Znoy?=
 =?utf-8?B?Q3IyclpCdklleWpVMGs2Tmo0N1hWTkZpOEtuMmNYczBuMUxYUHBjWE5kRzds?=
 =?utf-8?B?SzU1dStSdklpWkduZStxQmZ4b3g0a2puR2VYeDY5U3hFR094WTkrYVBhbXJq?=
 =?utf-8?B?VEY3SlJaeldkcU44UmFlNVJUelpRbVA5UE9EbHZrTncrSnNqU2NsWm1qSGxV?=
 =?utf-8?B?citDRDFpQUhzVjhzYURXaDQwMDNKMGFPcFVidElxK2c0NDZXaWs4OS96WU42?=
 =?utf-8?B?T1M1bFEvVUFLYTZkSjlDVDB5VExwU05uN0RtR0xiREdqV1ozVzA1V2hsZHA0?=
 =?utf-8?Q?TPsg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5062.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Z2J0bm1UamZZajlrcmM0dHFhME9tQXFLckNrZU5jRWVnZDRCMmVXampENEww?=
 =?utf-8?B?dzE5QjdrSjNNdENLeTFKRlMvTzVnQkJwcXRselRhK2RDeURqMVQyR0RBRmFV?=
 =?utf-8?B?VnprWHNDTXRtWkxVUU1mSytzT0x5UDZYY3NoWkVHNHR1UUh6SkNIZVc2MENN?=
 =?utf-8?B?QWtzNEU4L2tPaXQveWpMNmtLUFRmaVd0WkwvYlFZc3BTWkhHMTQxNW5ZNkps?=
 =?utf-8?B?UnI4cm5WRTRDaEFnZXpIeFpmS09hTThpMGhUVnh3YzErSXVZdzhnTWMycVhj?=
 =?utf-8?B?cDZ1dTBFQUN0V0t4UnVzMGlMTEt0ekVaRzBOSUsrSVFhTWZQc2V3K1lwMlZl?=
 =?utf-8?B?NStmTHFWZ2lFbmJteGlNTHhDMjViczQreERYOStrdmdBSHZlT2Z1ZE5EQlAv?=
 =?utf-8?B?OURxV3VocElwclRJeVUvbzk0a1drbVpVdlFOVXkzUU1YeVJob2RQdktNQ200?=
 =?utf-8?B?eEM1dWpJM1VhMS80RkQ2UVVyek9yMmRFOHZ1WWwrcW5NQkE2RFB6TFhUQk5z?=
 =?utf-8?B?Q3hMM20zNE40YVpmcm45TG5GVXRqbUl3QlZmcCtEVDZRcUwvRXBrMERmcXZZ?=
 =?utf-8?B?NVRGbDIxdU1zZUc3Z2s1Y1VTemFPRUxuSE1taDgwQnlxd3lIbmF0cmRTTzVx?=
 =?utf-8?B?Q3g3ZTlGdXVwQy80RTlLbUxFdW5vd1loYllIcEFiRHl1QmRHTHNuOHlkZ2lh?=
 =?utf-8?B?L202TzQ3RWRIZStlNUVaVzhReWZocHZwNTJtOGllbXBYRXI4VUhoQ1VUU3Rw?=
 =?utf-8?B?Uno4NTR1Mmh0SGlOaEk3SFVZeEZ4UVg4NUN1eUdPN1NXYVp4T2tZcEpOeTBU?=
 =?utf-8?B?M29GWk1acmJyTXpqNE9EcW9Mbk9rdW9yZkFHRjJCM3ZTUnI4WXJkUk9Lb25m?=
 =?utf-8?B?M0F2eHBFSHhld2lVcFpaMysraVlvRWg2WEVoaTZrTWdpZExWVVN5eXBFWmpt?=
 =?utf-8?B?Tk9zVmtuT3YycDR3NVlwS0FMM0M4SE5wUFpFN2h3dmpXVUp2QldjZXBYa2pl?=
 =?utf-8?B?d1o5OFd1cjJTN25jREVneGQrNlZLdzdldVR3STlVN3E5enl6akdTdGpEMTNy?=
 =?utf-8?B?MTlpK3B5aEpsSGQxS1d2aTJIamJ2K0JtQ1VDbHhBckloZTNUK0dCT3RrdjE5?=
 =?utf-8?B?UlN5SWgraGJPRHhYemVTbGVqanVhSkpuSFNkTnpUUkd3WEgvWURBais4SW1F?=
 =?utf-8?B?bzNnSTBFcUMwNmZkekR4MW41ZlVlN0hqSjRLVWZyeFgvMW9JbTBhNTBQZlho?=
 =?utf-8?B?a3NvZTJJRHIvTGNjckh4OEJlQXZwTVdCUmpKZkR0SzR0dk5lVTlKME5PRFll?=
 =?utf-8?B?N2FFYUVrYUtBRWZsbGI3R05OOVliUGtVL2lLdDM0b0gyaksxM0V1QXRIaXND?=
 =?utf-8?B?aitOWUQxZzBleW53SWJ1YVo5a1dXMnN3cEprN1hydkZDQjdYYUNseTNVSU9q?=
 =?utf-8?B?c3lndUtpNzQ2T3BGMmFHZysrdExSZmo3YTYxYzM0elBnV1o3QVpXMkVOZXZj?=
 =?utf-8?B?MXZMRldJaStOdGZIZW1oS2Y1dGpmK3crVFFOOVpIamdLRjErMmErd3hna3RB?=
 =?utf-8?B?OVQ1Yk1hN2N5cW5OQXdCYWtJYmJrYW1VYkk0M0ZsYUdlYjhvVHRSNk13Ymww?=
 =?utf-8?B?T2lTNXEyWHhKNEFjanZwSTlPUDRqSTJMTS9Kak54eGNFMnRyNkQrS3FsUHJt?=
 =?utf-8?B?VlVLWGNid2dCZXRQM1BKbSt1L1pqQ05nbDlHNWJQZUpUVzJoTW5CUDhMaXR3?=
 =?utf-8?B?T2VmME43TnY2aFJpNTdNRHNlME9EYTBpQWh0SjUyb3FXNjRZZjRhZ3RMKys4?=
 =?utf-8?B?Y0p4SThhVy9vYndpUXdNMGZLYnRXYitOUTB6SGIrSUpjT1RLR3NuVVg1Uk5I?=
 =?utf-8?B?bTkxblYyV3RYbHVSc21GSkJ5TDQvaks5SHFjYzF3RVpiN3kzcmN3WXRrcTIx?=
 =?utf-8?B?UTVrTEhqOUJWZHdod1MzMnVrT1kyelQ2RXBJVitBcXBYQlRoVDlldGhRWVFY?=
 =?utf-8?B?K1QxYURqRVp0UGJxK001ZmlValA3ZE93Q3YxeVd2Q3RiZ3BpSWxoakwrSk5B?=
 =?utf-8?B?Z00xMUxRNC9CRUl2VHg1cWdITTJxMENtMU5Oay8wV1kyakswcVVGMWxJblhn?=
 =?utf-8?B?NVcyOGZKL2p6VVlHNmltZzRKbnFJSkovKzB0b2ZVMWs4aVl5dmV0UUNUNHpK?=
 =?utf-8?B?amdNU2pjbFE1YnlTekNIRndDTmVBWjVpc2w0OUg4Y0tpYmZYYnFReVNVZTdY?=
 =?utf-8?B?Z2tveS9YT1laN3QxZlQrVm1hazNhRllQcStuWHRvYTNOUWhjV0tQZkRRVTJP?=
 =?utf-8?Q?bSYqHnhQFW6pwx0mGN?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2b58081-05f8-4953-6d79-08de600fb46a
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5062.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2026 14:56:10.3022
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PmNppX+od0B/4wvdGi+cff7KY1eViOhVjkFrPZR6NvoK9kY5qII/dkFNrvO4TqExITzaGqy+Cchv31nnleaRmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4139
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69730-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[14];
	DKIM_TRACE(0.00)[amd.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[thomas.lendacky@amd.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,amd.com:mid,amd.com:dkim]
X-Rspamd-Queue-Id: E8570BBCF2
X-Rspamd-Action: no action

On 1/30/26 06:32, Borislav Petkov wrote:
> On Thu, Jan 29, 2026 at 04:32:49PM -0600, Kim Phillips wrote:
>> Not *all* SNP features are implemented in all guest kernel versions, and,
>> well, for those that don't require explicit guest code support, perhaps it's
>> because they aren't necessarily well defined and validated in all hardware
>> versions...
> 
> Ok, can you add *this* feature to SNP_FEATURES_PRESENT? If not, why not?

It can be added. Any of the features added to SNP_FEATURES_PRESENT that
aren't set in the SNP_FEATURES_IMPL_REQ bitmap are really a no-op. The
SNP_FEATURES_PRESENT bitmap is meant to contain whatever bits are set in
SNP_FEATURES_IMPL_REQ when an implementation has been implemented for the
guest.

But, yeah, we could add all the bits that aren't set in
SNP_FEATURES_IMPL_REQ to SNP_FEATURES_PRESENT if it makes it clearer.

If we do that, it should probably be a separate patch (?) that also
rewords the comment above SNP_FEATURES_PRESENT

Thanks,
Tom

> 


