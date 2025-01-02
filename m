Return-Path: <kvm+bounces-34468-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D67559FF629
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2025 06:03:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3B5837A13DC
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2025 05:03:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC6E917C21C;
	Thu,  2 Jan 2025 05:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="HL80I/db"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2077.outbound.protection.outlook.com [40.107.92.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 325B620322;
	Thu,  2 Jan 2025 05:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735794224; cv=fail; b=KGu9YKEj2dVuryfVbrCVJEO2BBHo2cWCXXD1Eutz/bgkAuqU1QNtZw7/AeA8EDdBU4N7/Grg1pTJD7MpHTm0HGgp2Td112Rd9m27wfjuCV5n15HLWItwe4K8uAZ/CuVSo5j3mQsx3HZWdhSimEgSdsVt9uGsCPudj/yF87jyUzY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735794224; c=relaxed/simple;
	bh=OxYNeb4vuT+lMLPIuqatF2PsfWkGvcReK3QEnVW7d9E=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=n86n2gZgsVtod+NCYIcri3KkwAon0F5issN1M7T0SDLS/nF8YuZqpG624Zehc3yxj+XQhF24amcoEUujyXOC3yXBHwnTTv2VaGAcJn18oSW1IARZ5EVFjlFy4awAvW2jv7NSJlBxazu4XLLriAjeQX4pltUdngWedMD08neBa8c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=HL80I/db; arc=fail smtp.client-ip=40.107.92.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O9/6SvVQQRiBz6TZ8ftNM7RHWm92NCWVazQmxtSZ+ian1DKhZouRCY8sOMqMS/4UVQWxzM6noOAELGzQWNeqYPO6I72grEWWKJw5m8mVl7VBD4cpVQHxWLdASAJlNYzozew7dI8u5wb3ce4ZqmBtXvVSyPdNUfwfE2QFZ8Sjc+eUqGW9859zfDsQAYCw5+6OQQw34XrOpleWunoMBcrJFwjatpOiJCrOsFdmeeoZEuPtQa9Rfop8osnY9inqCC2hV16GRojMMwjKAC6moarrPtZOMbemJxdQuplvEF6Igrw7NZ1kmBvXOzfbHGm6V8GW1e5A58fjB6dI/yd9Hnmw9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yq5WaCs4BWwyk9xYPq+ikx1IEdZFgrr3GqtVOuH6Z5w=;
 b=gMEHkvzAyTUZ8jHOLGd7gnz7nOClhYPiKT74B5LuzG0Wl9r9Myi9d13Ri7LLZPuLtuLzeWTEqCbB4Avaj+iJlcarxSjBfvZ9wP4yQ3QMaNRpdUr+o3N78ku9KuC3Liyoog7YoxRF2dTxQv3JmSkjesFdS10ZS/kBofvFQA5lFi2IvFyMk62eea9j7FJwzldWRqnnYl5Ja1VQ8G7tnrIYH2m6k2TrXfQ/OSqGMRhj9yOzeC8YD+Ipi72Gl4Yf4E/i/LKRnNsJ0D40fOZulv1+rnb8EAtsAhDq6j3bkPxZmLWLPD6Tr1KYsZPVt9NXRidehOXA4lp//CpKwdKkeo9nUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yq5WaCs4BWwyk9xYPq+ikx1IEdZFgrr3GqtVOuH6Z5w=;
 b=HL80I/dbumVi7Y54CokDmvAJLW+YSwvA6mMDtKFF3N6rBZGdXlmk3ZrFmL4DJoDGngeT6VYUfMc7aBSa6p69ue66s72sSDjlKQLCB3qNL0G1obepo15RAJ1Qk0M+g4n6cWlcAcHJIs3HXuRl96g6QPLWs+aImKtaoGT0Y3lFexs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 DS0PR12MB9322.namprd12.prod.outlook.com (2603:10b6:8:1bd::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8314.12; Thu, 2 Jan 2025 05:03:36 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%6]) with mapi id 15.20.8314.012; Thu, 2 Jan 2025
 05:03:36 +0000
Message-ID: <9d4c903f-424b-41ce-91f7-a8c9bf74c07c@amd.com>
Date: Thu, 2 Jan 2025 10:33:26 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 06/13] x86/sev: Prevent GUEST_TSC_FREQ MSR
 interception for Secure TSC enabled guests
To: Borislav Petkov <bp@alien8.de>, thomas.lendacky@amd.com
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
 mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
 pgonda@google.com, seanjc@google.com, pbonzini@redhat.com
References: <20241203090045.942078-1-nikunj@amd.com>
 <20241203090045.942078-7-nikunj@amd.com>
 <20241210121127.GBZ1gv74Q6IRtAS1pl@fat_crate.local>
 <b1d90372-ed95-41ce-976f-3f119735707c@amd.com>
 <20241210171858.GKZ1h4Apb2kWr6KAyL@fat_crate.local>
 <ff7226fa-683f-467b-b777-8a091a83231e@amd.com>
 <20241217105739.GBZ2FZI0V8pAIy-kZ8@fat_crate.local>
 <7a5de2be-4e79-409a-90f2-398815fc59c7@amd.com>
 <20241224115346.GAZ2qgyt3sQmPdbA4V@fat_crate.local>
 <a28dfd0a-c0ab-490f-bc1a-945182d07790@amd.com>
 <20250101161047.GBZ3VpB3SMr9C__thS@fat_crate.local>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20250101161047.GBZ3VpB3SMr9C__thS@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2P287CA0003.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:21b::17) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|DS0PR12MB9322:EE_
X-MS-Office365-Filtering-Correlation-Id: 346a1fff-4d8a-40e3-c67e-08dd2aead020
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?b3NqOHYvZytaYnhHbjBzVE50SkFWQ2ZqaDJuQ0k1djI4M1RxeWxKMW55Ymw0?=
 =?utf-8?B?blA3UnYxZnBtbzdJY0h0ejNndkVPNEFwblpvdTNibTQrSXdFcmV6Vit3emVC?=
 =?utf-8?B?YzZYMW54bVRzVUk5YjJlZURmaVhRNVJROFBRcmZsL2xSWTdpQzNiOHdUVU0z?=
 =?utf-8?B?aVl6UHhra3UyV1hTdlRqdmJmOVpFZjZ0UUU5emUrc2JrVm5jNHVYN2ZqTTk1?=
 =?utf-8?B?bkx0aTlKK2IxbFIwR2lrQ3B1YXoxdEVGN3FndVpVWUdDME51M045UFF3MXk1?=
 =?utf-8?B?NUhNVW9sRE1CMDc1QktJczBrbXBWMEZ1RWphczR1TXhvZG9haW5kTEQrR0E1?=
 =?utf-8?B?QWNXY01GbnBrTVNJbDl3Tkk5djR5MExDN2M2Z1Y4Z3ViRjBqU2VoSzU0Tzhs?=
 =?utf-8?B?cHlYbC9ycXRFenI5YlRjc05vTGhFN2VLSnBzNC9nUHFxK0VmTEUvM0hFRzNM?=
 =?utf-8?B?MXE2U3Z3KytqcTB6a0hxM0p6WCtOUUZtVmRJSE5VT0toMWVKcnR3aG15dk5E?=
 =?utf-8?B?ZEpMQ1Vmbmp0Q2x6c1VKMVF0eVozdmNSTGZYNkhBMnRDS2ZDMjNUT0FXTDlQ?=
 =?utf-8?B?UHdjeU5zYS9vbHlZcHpJQnBpbWtwOGVjc1d4bDBaR1YyaTRkUThMaFBUc1Fa?=
 =?utf-8?B?WjAycjJCT29uakhzSTlDQ2Qrb2duTk5UMVNoZmorRDZGblRPb1I0Z2xRakZZ?=
 =?utf-8?B?akV1ejRIcy9tV3pHY3EyNE14QzVkODBsVk03VkdVMGxqZ3J0MFo4QzE1RXk3?=
 =?utf-8?B?bjQ3TVBNT296elFrOVJJZVNUVnRLVVJBMTN3RFUrSHZseHIzTE90ckF6TGpN?=
 =?utf-8?B?WTZjTDZiQ1hFOGxYOHhWQjNjWVhSRFphb3BWdmpCakVOVzVYT3dvUUtTaFZo?=
 =?utf-8?B?NGFiOTMvOTVSRjJyVlF3OUxSZjhQNGJKcjhPNU9qTzY2UlB1N3dyQU01Z3hN?=
 =?utf-8?B?cXFORDdXVE1YOFpWcFNEaDhWSTJvK2h0YU44VHAvK0J5Y25RL3o5dU8rWTky?=
 =?utf-8?B?NEVXYUh6djBMTkRiMnhjUnNFTnVGSXVWL0pOQ3krWEhPWVZVa25XdmVLdVV6?=
 =?utf-8?B?a1N6VjA0MnVrb3lzcnFHWVpXbTdyQkRxbjQvODNBcmpJSUhrZXA3SS84UFpN?=
 =?utf-8?B?WDZqNEgrMi85U1BpeWl0SlRaV3VqWkR3M2EzQUE0N0dJT2U5VHJiZ3RKSGdt?=
 =?utf-8?B?eTFzVWpKbTJlaHdNVFFPQ3hpcy9nc0trOXB4TnI1SEFnNnYvajYyUHlBR09G?=
 =?utf-8?B?QTNody9kcVR4bnpoaDF6c1JITzV2MDNiRFk4MlJialJCRHVHWFZKWk13VE5X?=
 =?utf-8?B?OHR6cmplbGdGYWt5ZTR6aXh3U1l4Y0g0OWZXL0JRRHlKckhmOG0rWXo1Wmxt?=
 =?utf-8?B?ZkZjVElEelY2azl1dm1wbmpyTks2ZGNnOXcxVHBZcHkybEtPckk4UVltNTlK?=
 =?utf-8?B?R1hjK1NnQnN6RWNkVUJ2cTMyOHNIMDJqZnBvTXhkTXN1WWZ3SnFXdzJjeFNX?=
 =?utf-8?B?YjBhZmtZY2RGdHp1aTU0M3Y2MFhPMEE5RzQvQzUwUDRPdTZPT0JrYkdsU1o0?=
 =?utf-8?B?V2ZrMTRXM2duSzU0TlYyaHo2Slc4Vy9Xd0ZOM2gxd1ZZczBtNVFtemVmVXdh?=
 =?utf-8?B?S0VZeUg1MkM5QXNMeFpPejJxdUFvaGJSU2NxbUVkYnlJY2NRK3E5NmJsMkJ5?=
 =?utf-8?B?V3NFMU5DTDh2bDFRZ3FZM0FxS1FMVUNpcXZjSW5UeGFIc3JXNjRSQVQ3R09O?=
 =?utf-8?B?OXJ4c29tTU0vNVh5R2F3Mkx0dTVRaUU4Z3laUVIxdTA5SnZPN0Z3b2MvZitk?=
 =?utf-8?B?TGQvRWptYnUxb1o4ZHA1SnlGcmtPc09aQkpkUTJFQXhNNUNBSzk3Tzd4a1pJ?=
 =?utf-8?B?TTNpR2t6QnRmN01BU2hqelR2VGtDMXlZa1poWm1XN1JhZEE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cW1VWGVTSC85YjJ4VjAyb1hOckxmSW5OalA2MC9rT0xMSUIzTjR1VTlGN04r?=
 =?utf-8?B?cjFXNE1aK1k0cTdFWVRVSC92d1JmaHZ5WmowRWRHL3RFSzFIb3N4R29EWHI2?=
 =?utf-8?B?dWt5Q3FPU1pvMStCc0FiVUJnK3RXQk5lb0ZpbUVQZWk3YlBFMHlnd2xnckxu?=
 =?utf-8?B?Wm1Rc3FPdlQ3Vk5pQzdMVlF4R2E2UEVrYjBiRWNvLy9zWmcxZDdBUnpjRzUw?=
 =?utf-8?B?QndaZ0w5SGt3Wmloc055UVFFOWdKTUhPdHZCS1BQMU82Rk5GcTJXQjBOcFNk?=
 =?utf-8?B?R28xZUlOdHNnaXhSU0tqSVpvSUZBS1FkbDE4clFMMnBuSW45TEhrY3lCVG9h?=
 =?utf-8?B?UTFWZDN6dGg4bnU3U3BFeE5ZOGFvUU9UYmJERUw2Lys1OVR4RE9NVVhGUVYv?=
 =?utf-8?B?dnZSMVlGNWlvd1NFcFA2UEtHdUY3VzZMOVc0YklGOXRYd2pJc1FncGF1N3l4?=
 =?utf-8?B?eGVpbU9DUndiTXFuUm9Gd2xVYWMwalZHaFZaTTdocHRuNTVLbVk4eTVGMFJH?=
 =?utf-8?B?ZGJIT2liZ3JOQjFheTBaWEl2QjJzQ21ucXRMUWFPMW1jTGUrT2V0dlljejBO?=
 =?utf-8?B?bFFuQUtjbUswNVRwOFFnQy95bFVLKzZSREptMWxnSUNzQ1JHVmhlSDZUS2FT?=
 =?utf-8?B?UHRISk1NTEVxWUJnYW9qV21hbVFzekl5SSt0YlF3QVkxaElRajdGR3lnb3pa?=
 =?utf-8?B?anh6V29hUDdiMWFBVkFiU0l6Q3czaElLdEFlV3RsZTNrbDNSSVRwbTlBRDNy?=
 =?utf-8?B?aFlMMnhSNnByOW9OTm5zYlR0NVdyRDhhOGR2b1hiazdISmpQbE9JTmgxMjJj?=
 =?utf-8?B?a0ZENk5FWUYxUWdNMVRGS1RLcHhyY2ZJTHE2NjZOMWUyTURMaFgwYWdmS1di?=
 =?utf-8?B?OEc5RnNYVmhla2VZUE9BUWt0a0ZJK0VGOE81Rk93SlNpaTZWcjN6bGtja25s?=
 =?utf-8?B?WGZKRVloOWJmUDFvQnVSTGZZMHY3Z0cydXQxellNUGtHblFaVWk5Vmdsbk1u?=
 =?utf-8?B?cDgvZHhVeUdtdEVxUHQzYXBLRTVoZEFMWml2aDc2U25nNFhHMkgzRUxCTGti?=
 =?utf-8?B?NzlXaDRpL0IwdnpzT1hBd2twbENobG9Xd2o4dGwwWWJrTDhHNjBZTmFCR2Zk?=
 =?utf-8?B?aEMvclpUOGkyMVFScjBOaVJVRVIybFZoTEI1c2dRbG4xdHV3a1NNMVNjbVho?=
 =?utf-8?B?QU1JVUVMdHlBNng5eEw2UUtFVThmRUJhNTJieVlaL3huZmx2QmxoMlA1NGpR?=
 =?utf-8?B?R0k4M0ovZWx5c3Y1bTFlTGVxNnlyWWdxVDQrWndNY0Mrc3RScnRoWG84akJI?=
 =?utf-8?B?UHBlcUFhUUpuRENlOTBOYnhiYnFUODYxdG8yTEt5TXZnOUlrSlVHZlhHc2ly?=
 =?utf-8?B?cWF6enp5QjRrS2pzYlgrNEplY2c4dndQNGdidStrWUhmUFpBYlY3OGVxelVj?=
 =?utf-8?B?cHJweXp0QytKcXRyWUF5Nk5XYVRhUWgvazUvcDQ0ajBNMGNJRXl1cUFtVjUx?=
 =?utf-8?B?M0orNFFMeiszejdvVy91czREM0RUckNNUkFxLzdzYUpRRG9EOW00TDcrbnFJ?=
 =?utf-8?B?SkZtdmQ4UVFNUmQ3QnkrUXo2bUgrQ0syUW12OEZJcTRQcjdQUU96ZjFLcnNr?=
 =?utf-8?B?NlF3TUROc3N6azc0VWJVeWltNGVHMExlaWZNc3hTR2VhQ2lOWEZFMHU1SkRZ?=
 =?utf-8?B?Z28xRGlOeVlCK01EU3pqQ1lUeGtCbloyTjZWVjJXNm40MHFoNHU5cFU5UDZI?=
 =?utf-8?B?WmpFSjdadlROK2tjdUFKNG5zcjM4YW52WVFla0RWWTF2b0N3Wk5yWXJSRFRz?=
 =?utf-8?B?emxETllEUUdqa3BrN2toM2ZYTDRnZW1LTEZteW5naHM2ZklUVFZNYTZ2SFU5?=
 =?utf-8?B?YmZLTXpqdlpiM3dHN3pqdk1xWjU5eEtlYjVLLyt5dXl1UFFtUlpvaUV0WGp1?=
 =?utf-8?B?VU5KazY5d3BBVXVGZmhhVG9iK05TK0lNQnk5ZWNJaUFxdnZ4U29VVzlTeEg1?=
 =?utf-8?B?T1RscWFoT1VMZHZGYWErVGIvVWpXQlFQMEdBbDdQMTU5UEl0UWJUMmlMTCtO?=
 =?utf-8?B?TER1SlJEZEhqMjBpRlk5SVJ2dVJsVmlyTEs5UzlUZkU3VE1YSmhGOWd1Yng5?=
 =?utf-8?Q?b4Wj/bcghO6ptREdsB00y0Ewv?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 346a1fff-4d8a-40e3-c67e-08dd2aead020
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jan 2025 05:03:36.2879
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PFTtzTP6gd1O+WvGJwc2vnhlQgjiSG8kfFH7QVYW1kYCTzNq0mQHHxvk8F8yRY8Q/l3P15DOFMuz5AoqYMKATQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9322



On 1/1/2025 9:40 PM, Borislav Petkov wrote:
> On Wed, Jan 01, 2025 at 02:14:38PM +0530, Nikunj A. Dadhania wrote:
>> @@ -1437,8 +1471,16 @@ static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
>>  	/* Is it a WRMSR? */
>>  	write = ctxt->insn.opcode.bytes[1] == 0x30;
>>  
>> -	if (regs->cx == MSR_SVSM_CAA)
>> +	switch (regs->cx) {
>> +	case MSR_SVSM_CAA:
>>  		return __vc_handle_msr_caa(regs, write);
>> +	case MSR_IA32_TSC:
>> +	case MSR_AMD64_GUEST_TSC_FREQ:
>> +		if (sev_status & MSR_AMD64_SNP_SECURE_TSC)
>> +			return __vc_handle_msr_tsc(regs, write);
> 
> Again: move all the logic inside __vc_handle_msr_tsc().
> 

Boris, I have mentioned in my previous reply why this is incorrect for non-SecureTSC guests with examples and had asked for your confirmation if it is an acceptable behaviour[1] and Tom has also objected to the change of behavior for non-SecureTSC guest[2].

I think we are dragging this a little too far and the implementation[3] that I gave is good without any side effects.

Regards
Nikunj

1: https://lore.kernel.org/all/7a5de2be-4e79-409a-90f2-398815fc59c7@amd.com
2: https://lore.kernel.org/all/1510fe7f-1c10-aea7-75be-37c5c58d6a05@amd.com 
3: https://lore.kernel.org/all/a28dfd0a-c0ab-490f-bc1a-945182d07790@amd.com 



