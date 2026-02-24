Return-Path: <kvm+bounces-71600-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IOLgHBZtnWkkQAQAu9opvQ
	(envelope-from <kvm+bounces-71600-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 10:19:18 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BDE7184714
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 10:19:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 7AF4F30275AD
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 09:18:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF55036C0AF;
	Tue, 24 Feb 2026 09:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="PbASo9IE"
X-Original-To: kvm@vger.kernel.org
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012067.outbound.protection.outlook.com [52.101.43.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B12A8274B43;
	Tue, 24 Feb 2026 09:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771924693; cv=fail; b=BxdVtxD8Akdvt4HZpYxTXS8B8dAvYv3OpnN4REELfviF5OSAh6udjnCBiM050y39v2FogAMiBpBJ/xlv59CKRWJ7BM9qyz21qdz+pbMfwe9k3Xbe7WjXbTiFiPtp8zbMxN635W/BG9/wVRE+SLYST93vjGKT5sxol0g/uYJHCJE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771924693; c=relaxed/simple;
	bh=jIlIp2vIhPCdMQtbKfsKAdmwpxFoWYboTWpfhs213K4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qtBZjS+uAjOaU4K6D2pCNtRxG8HcewdDDHmEbMWqOWYmjJvBDzq3fBHp+Ka52+8heM421wEnFNAeFRq+tLp6AV/VMcvsN+nXWhu3QKVuheG0MTLnVzrSzkDOdEE/RLQMKhzKo/DqfkJZXuaU5l0JIVtuWKzixX0AtoxKZYYh9AI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=PbASo9IE; arc=fail smtp.client-ip=52.101.43.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MFRUqOjvd4CNfRJt9b5iEqL+WlZaNggB9A1SW3af0gK3ubeGHO5na0ka+7J3br0o0TmwkNJ5k2m0FvEjLl4kLnhHCjjmRwTJna03RrEWlO9v3thMsiQulyMKRSap4Lgs/OgwU0GgkM6YP86SupHvSDkqbMJGKOrf9Mcgc/I8476w34qRelgQPuy1sphNNaFM1Rttzf7pXMfbuVLPyJBXDiB3CVyEum0L9Fo+Izl83bJFgBpJ297kFmEb8lt9101HQUWvHb5douXbpUBTx+SGo+mASbsD9D3uPb6CiHucmzfzTK3JScju9LW70Pr3QHs+/Za//DegpnGrle7aRmRf2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1Jlj7LNhkFrQIhTzYZeBMH0hypygL6cbaTgjjSIlkXo=;
 b=u/HWAqj6+krjvMRrp7Wit8hd4sV4RD8Yhi8XnAaKkdeJzXMKfflvabvv+w7HLiGI/AXqn08Rqm0ruFgweZNi8ktF/QE1z7Sd/coe+kngqvY1t96zKLQ1Mv/Vg/eGuB2lVmKC/l568IH1sZEeRPX24viMTAJq+BCIIajnP0ndWUHTEgxNEHqbDP44mihEe0Fq/1vuxZu0LrboAaR0+vvxunV3C0qzhPw0tESO9bAJJIrePhO2k1jCXsbcQD81lz9KseQUm1ijE42nhls/50FbXmjHCwQbIaAW/4QHkcv8Fw6y5MNiTNjn6aS8RWXopZM4USPVscEj/lqpzTYoC0371A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Jlj7LNhkFrQIhTzYZeBMH0hypygL6cbaTgjjSIlkXo=;
 b=PbASo9IEJwO7MCNkMZTm95mkmVlPqElIDkfO8fWna5mYUFKGC8H/tkFIxERoxnGsk5vLPnBvbRWICF3Y4gbUcDXnKwnp/Q9dpwjUrMtD5LNGb/el5BhRelENzHe1R3IH9KPHDARTw9a3O4Nl00MOmtfTfdrXfdVSkWCMCgN+5EouwsaGHy9CCRAdKHXAQU1MpPbEq/kuFFm1oXk7sHEYQO0yjCod0GpiM4uVDFEIQsEGdlTBQFZeWgAa4HsTWjvuVVWGLLj5I6Y8GovhwkkSi3A3giX2ST3HT4rcpfVP9V62vl5NCXHxQ5YYJfuNQnkfs0pj+F+Z9soxnzfXTSSfCQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA0PR12MB7003.namprd12.prod.outlook.com (2603:10b6:806:2c0::10)
 by DS7PR12MB5888.namprd12.prod.outlook.com (2603:10b6:8:7b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Tue, 24 Feb
 2026 09:18:08 +0000
Received: from SA0PR12MB7003.namprd12.prod.outlook.com
 ([fe80::4099:396e:1f40:169b]) by SA0PR12MB7003.namprd12.prod.outlook.com
 ([fe80::4099:396e:1f40:169b%4]) with mapi id 15.20.9632.017; Tue, 24 Feb 2026
 09:18:08 +0000
Message-ID: <3c2969a9-c58a-4935-9d53-f3d6f3343b21@nvidia.com>
Date: Tue, 24 Feb 2026 11:18:01 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] KVM: SVM: Fix UBSAN warning when reading avic
 parameter
To: Naveen N Rao <naveen@kernel.org>
Cc: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Dragos Tatulea <dtatulea@nvidia.com>
References: <20260210064621.1902269-1-gal@nvidia.com>
 <20260210064621.1902269-2-gal@nvidia.com> <aZx_VsnmWLx96AeY@blrnaveerao1>
From: Gal Pressman <gal@nvidia.com>
Content-Language: en-US
In-Reply-To: <aZx_VsnmWLx96AeY@blrnaveerao1>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0148.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:95::7) To SA0PR12MB7003.namprd12.prod.outlook.com
 (2603:10b6:806:2c0::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA0PR12MB7003:EE_|DS7PR12MB5888:EE_
X-MS-Office365-Filtering-Correlation-Id: 634d8f18-bd4a-4be4-856f-08de73859fd3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NW1sSXR6YU5iQ3dYemZlSjV5WkxZWlgvNC9rUlJrQm1JUG1TQ1FXVjdXNVM5?=
 =?utf-8?B?VUZ3eUdqRk1OaE1meGZmc3JNR21EUmpoSGpwb1FvaWZUcjV5L2k1ZkNXaW9w?=
 =?utf-8?B?WnVnSkpPK2N5eWp3R3BlOVBTb3FRcWlyb0o3bkcxRy9TS082S2VTc3VCd3Y4?=
 =?utf-8?B?dWtWdnJoRlN3bk9uVnRWalhpcm9WOW5LQzFrY3JIa2gyRXhtaml5UmVQaUpL?=
 =?utf-8?B?VnEyRm9QZDlYTlZ2YXVyeENBY1RvckxxOWtWTzZHM00wL1lDWjB6TE41RkFq?=
 =?utf-8?B?WndkWTA1dVphSnFLQUkraWZGczZjOVNBWWRDNWZHVE5DVk9Fd2x6bUV0eEpM?=
 =?utf-8?B?VmNuczhpdExOdDRtc3VDZHdaYzRZblJadXhodHFHaHBPMGp4RndMOUlLNnAv?=
 =?utf-8?B?L3N3NGVOcnV5SE1EOGVkenNnSHZWR0F5MVVaNzl2NUlKN0tibXllRDN2UC81?=
 =?utf-8?B?QlQrKzQ3SmlCUDdoNUFvZkJ1dGhmb2hvVjFNdDgxcm52cVJmb2g0cFk1SkVF?=
 =?utf-8?B?N2piN0N5UStFSFhPT29nZkpBU3FRS2FxWk00Q3hsSWlSbHhHNlpCdGpDT3NU?=
 =?utf-8?B?UVB2bzIvVFA4NmZKWDVlMDE3alUxeXc5Q1BMdEJBOEIxcVFkRlpzK2E0MkVE?=
 =?utf-8?B?bkVqY2VzL29ReGtqTW1DanplSjhyQk5tb1VKbUdvYk9nT3FFdmRRZVdScnNZ?=
 =?utf-8?B?UFMyTkZ5eWNxeHMvSjh2WnA3L1VLYWY3a0gzd3hyMXB6UTZVd0pkdXJYcS9H?=
 =?utf-8?B?dUNEd0pBK2V2RVdRYTBRbGM2WExvc2lnQTZFb0Z5TnJFRUJxTXZ5d3M5OWRw?=
 =?utf-8?B?VmJFNEp2bXp2OEtjejFHK0lZd0J2ckszSHZ5dG42bW0ySXEvVTkzV3hzekpm?=
 =?utf-8?B?Z3Q0dVFQVWo1NGgyaDdpYU5HUGN1ZkY1bFF3c0dLZTUwMHVyS2UzbEVYS0hm?=
 =?utf-8?B?QXByN24wMmdIRldwL2o5WC83OGwvbnRtRFhHM2svZnBFMHFvR1MrODQ1TUpp?=
 =?utf-8?B?TmZKM3U4N25FbzdHTjVtbnpzV1h4bjJYN2N5MW0zMS92LzhlZVh0UXJOZUJW?=
 =?utf-8?B?SXU5ZEN1cncvQmNsM1J3ZzFnci9tT2oraHI3OWxEM01TWVkrdzVUWm1JeVFS?=
 =?utf-8?B?T1J4ZTRrV3U3a1BIYTB0Qk9MSjhzdU5OcDVtT2xoUG5xcjhCMGVWYWNpYU5S?=
 =?utf-8?B?Y043MnVhdUNRVi9haXlOcEI5aEtscUgyQUZDZUtCemU1dHRmT3N4R1ZzRzds?=
 =?utf-8?B?V2ZNWTNsbzIzeXpCL09HbURLWVNGQWtPZTcreCtpUUFjUFBGV3hUM0hoRVJr?=
 =?utf-8?B?WkZ0a3VlekxUZkFYZHNHN2M1MFVNVzJxN0hlenJYZ2VyTkxMeGRqQVBEWXlj?=
 =?utf-8?B?Nm1SOTE3MkUrZW9ucTZHeGIzQTVaRDY4dGJJRHN5OWoyVFY3NzFFbmZjb1lu?=
 =?utf-8?B?M3EwMVFidFF0SUdiZm9PWGNxdjVZQUVwMjJadWhoeVdiK2RZSUVFQU03bk9h?=
 =?utf-8?B?QjUzM2o0SUNDcmdJaS9kem1RRW1WV1hyM0Q4ck1MRGZDeTVJUVY4T0xESkRs?=
 =?utf-8?B?NmowQVZqVTcxNytjNEF5NnZDQ1VEMFNJUms3K0plQStrR3NEcnVadFB6ekJO?=
 =?utf-8?B?KzNQOEpwbzV4U3MrMXJxVFRGMW1iVXFrdWdGYlErMHJaYWtMYlNoeWJDR2xY?=
 =?utf-8?B?SVlsQzBDcVlsdVloTWV5SjVuazQwdkhVdTFQSENaN2M5dGk2cGNaWGtlT1Z6?=
 =?utf-8?B?c1pRb285M1hLd0syZzg5cjBuMFhrTkZRNkhzMmpWbU91aHhrRmtZYkJ0dWZH?=
 =?utf-8?B?KzZYbUhERzVxdlgyVkpqSTg3c2dQcnBkaHhmRkYzL09jU2pmSWtzTjNWa1Ez?=
 =?utf-8?B?QU95YzBsZytraTJXdUE2ZHFiUzZlTDBkakdYVDJQcG9KeEhaTHZtM3NMR0VU?=
 =?utf-8?B?YWlvdGxQSFFqb2pxU0tmaEVuT213YkJsWW5NM2NEbnB0OUhjNXJsbTZ4dDRp?=
 =?utf-8?B?NUpGL2RKeEUvNW9GV25uQ2dNSDFFYnRMbWJJaDBzUnhmZ0ZnenlIc2psbVFa?=
 =?utf-8?B?RkxYSm16b2Rua2tiUTlpVzdaVmh0TUtBSmRZRnA0Vnhvb3Y4UFUyUGM0Qlp5?=
 =?utf-8?Q?hPa0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR12MB7003.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Qm9BWjI1QVlvdFVJUUthWE9XL3FzOWJKT3FvRHMyVEozN1FKRXcwOE5tNmFJ?=
 =?utf-8?B?ZENrQnJsV1ZuQmNkSEQ1Q2drU3pGRmJlRnhJZ1dzSUxCeWQyNXlKSlI4VGhB?=
 =?utf-8?B?QlJCNWNDYW5BbUhZS2lQQWorUUt0VUM4bjJUbzcrZWRMNk9YYjJkaGowK3BZ?=
 =?utf-8?B?R2J1S3FZMjV0N1E1MUM0d1BMNCtZbC95b0pkUG5vK0pKQjFIb0hKaldKcTJQ?=
 =?utf-8?B?UFdsR0dVd2dmWW1zMGJ5NW82UlM0SlA3NTA4aitaK0dTY0h6SDJEWDVQQ3Rr?=
 =?utf-8?B?eUtaTGVKUGxVb1NRcnprbnd5OWVodWtvS3FSbzVNdWkySncyM1l1WlZrZHUz?=
 =?utf-8?B?cmFjcmg3OUdzSkdyNEozbXNhVjZKUW9idnZIVnFMRnpiMlRrL0cwakdSaTJR?=
 =?utf-8?B?ZHFreStBendlaFMwVVJGYkFhYS9nZ2NGcExlcnhGOEN6bEtHT3Y0SUxCOS90?=
 =?utf-8?B?a293Qy85VmZ4NDg1b0JiRlQzL2VaQU1peXRJU3E4OUQ3K0dUbFFKVHh1R2R5?=
 =?utf-8?B?NUdQSmZVRXpwNzhvTWthZFFZTzJqak13VCtHclZ1SzF3WEp5YTdFc090bDFM?=
 =?utf-8?B?WlpqVmxaeDBPVURvY1RBc2ZJK0JoSmZVL29DT3R4TlpOSnZxcmltZVdtQm0x?=
 =?utf-8?B?UXBCekRnanhpUTFoWlBQL0ZZaGw2cnNUKytrYlB2L2ZyakZPVkVEWnVPVUhJ?=
 =?utf-8?B?Nk8xYVIwRkRNczZDdWI4eU1lb01sTDhsdjdoK2MyV0p0dDR4bXArR0pTOENL?=
 =?utf-8?B?Z0dRaUJmWXpkWFoxV1p6UnlRYm13UUlYcUthakdOQ0lpbW1ZSzNUcnNCamZz?=
 =?utf-8?B?Nk5MdTA5c2w5UWxoZllzZGpKVmJjQldGdlNPYUUvYUZWSmNJWU5UdEJCMW0r?=
 =?utf-8?B?OHVQcG5Kb0UvNkF3eldMMEdLcGErWnlnUXFIdU1xNDkwdXE2eWVpYmpBWG5O?=
 =?utf-8?B?M1pMUlBiaUc4clErd1B2RU5vS1ZzTnVSKzl3Z0tmaVNvUG5qZGdxM29Dc0pX?=
 =?utf-8?B?U2pUMEcySmYxdU42ZGE3Z1I5V2lUSmlnMVdzY1FhRExMbG54VFh5bVRLbkN0?=
 =?utf-8?B?aVdWcGtpVCtrSDU3Q3FWODcybnBzb2N0SjhoUmtoNVZvZWpBOU5xUDYva3U5?=
 =?utf-8?B?L3J3UGlDYWxGY1BqOU80RmpzWXZGWXp4OUZmZTdFbE1LbjBnUW0yNXBSVzQr?=
 =?utf-8?B?Q0dGZ1RYa0RJSU9KTXFFaTJ2RDB3dEJ5dDJHY3huQm1uRmxST1E1bU9OS25Q?=
 =?utf-8?B?YUZNbXNIU3dYalFja09zSGdwL2dMS2RnRDFlcytFVEFKaUZwYnVkSXNvMkVw?=
 =?utf-8?B?empiakl1UkI3MDdET2MxdzFoamxTODRMY2FxTkpySE9FeDBTVzVEU0tiUW9u?=
 =?utf-8?B?OE9lUHZFVlNHbUVUd2hTdkdha3pBN1MrSWpMYmV4ZHF0YXQvNTh0T000em5r?=
 =?utf-8?B?RFp4NHQra3VMK0o2MHNVZGxSZnlZcU9wSlpYZXZKc2xxSmpiaGdwa2VsbGJE?=
 =?utf-8?B?dlhWWm5ldkR4VWsvWEFGSnI5MWtZenZQdjhNTjVCS0V3YStYV1BHemlZN0F4?=
 =?utf-8?B?ZjVmTm5NeUJVaHlZQVR2aFdVM2k4QklKbjhWcUtlaElpNmczdi8reGFXMWtD?=
 =?utf-8?B?WVdGU0o3Q3dvYUdrY1dUNjQ5SFJpQ1VKSW8vM1FqeE1nY2dEa2szWnJiVjE0?=
 =?utf-8?B?dVNLVHpLdmRNd2RxK0txL1p1OFF6M0srV1N6TUptZUVUelIyN2dXaTIva1dT?=
 =?utf-8?B?TXFmQTBwWjJMRXBIUVBvcmhuaXJBWE52RFBIZmpaR0dsSmMzUHhPL2Rxd0dC?=
 =?utf-8?B?YUVyTk9keVYrbUl2Tnp6dU1HbnY3UjNodXJTc0lNMWhHK3pTaVlSbklQY3c0?=
 =?utf-8?B?OVVRWDd0a3o0SGJrRDVGMk5Ka3JoL0g1MmE0RmpFdXJ6UmxYSTZRZFhQT1lM?=
 =?utf-8?B?MjBBRWF0VEQ2NEF3SFNaTllHc041elVuVmNMYVZYOXRlRzI0RC9xb05qZWFW?=
 =?utf-8?B?eHAzSjJsTEJHeWVBSFhBNHlBTjFkdWM0Rk00WW13UElLaGJudzJDS2cxRTYz?=
 =?utf-8?B?MS9yZGxnSnp4VTBlcmJHejhqeWNJYWJyWW5RNlQzaUFPS2g1NkhoRkhFT3lz?=
 =?utf-8?B?MzNuUExtQSs0R0ppL0R6T3h4ZVdET1lORG1FbGVNSWpFOWYzSUNNQlpoR3Bx?=
 =?utf-8?B?QnowcENSNk14MHdaZCtSNWpEZGdjZW5jOS9ITnB0TDFVVmJyVkh0V1pZc3RO?=
 =?utf-8?B?dC80UGtVWWpoN2d5QXo1QzZ5SmRqNkRrRFZudHZUVXIzZ0hZVi9WYXBya3Jk?=
 =?utf-8?Q?r8/xSskQBoSrwKK6CR?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 634d8f18-bd4a-4be4-856f-08de73859fd3
X-MS-Exchange-CrossTenant-AuthSource: SA0PR12MB7003.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2026 09:18:08.3794
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h2mNiu0vbrfQXsb5N8XMxD33cU0MFTD1pKPN+0O7pFDHXP0LDZUq1VG71ClqH6fK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5888
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[nvidia.com,reject];
	R_DKIM_ALLOW(-0.20)[Nvidia.com:s=selector2];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71600-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	DKIM_TRACE(0.00)[Nvidia.com:+];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[gal@nvidia.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,nvidia.com:mid,Nvidia.com:dkim]
X-Rspamd-Queue-Id: 9BDE7184714
X-Rspamd-Action: no action

On 23/02/2026 18:38, Naveen N Rao wrote:
> On Tue, Feb 10, 2026 at 08:46:20AM +0200, Gal Pressman wrote:
>>  
>> +static int avic_param_get(char *buffer, const struct kernel_param *kp)
>> +{
>> +	int val = *(int *)kp->arg;
>> +
>> +	if (val == AVIC_AUTO_MODE)
>> +		return sysfs_emit(buffer, "auto\n");
> 
> My preference would be to return 'N' here, so that this continues to 
> return a boolean value when read.

I guess the boolean conversion used to return 'Y' before this patch, why
is 'N' better?

