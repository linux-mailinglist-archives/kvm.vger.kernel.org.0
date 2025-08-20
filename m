Return-Path: <kvm+bounces-55219-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 014C1B2E89C
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 01:23:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id B6E6B4E2D1D
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 23:23:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 582772DE70C;
	Wed, 20 Aug 2025 23:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="B3dbXVhS"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2060.outbound.protection.outlook.com [40.107.100.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1B1A25BEF2;
	Wed, 20 Aug 2025 23:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755732225; cv=fail; b=lhRVrzGvO55uUUwg/TS0cS3glypu7YFNMequvZreZkmp7Y3Xe/52xXlKO28qIi1e4cwTgXM30hKamOjhfBr+KwDyMW3phukLrimhJJGNZj64KpqVJmhxISXKsI90fOjcCQv4IZOdtYI1jJfxpUXyex2ijx+SnetQmfmIQ4u9LUI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755732225; c=relaxed/simple;
	bh=UwXwTmAk9D0ISJRDcvnexr9IbiN7wGRVpOixGrNfdLs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qCeDOpTruCqxsGpMIIZJ1YlepLCjs56jFOJpJCndb4SzV4cHF3hf/wSky6v5gNH3BHkY/3yTDdgEVKqqQnC+Zr2o6HP8oUExXL/Zrub+1VHmt2d3pOUd2nKn7FuE9e9Hzwb+ahryb0LQZDt5ZUROGu3u+i0uClc9c2dwjNsVnlo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=B3dbXVhS; arc=fail smtp.client-ip=40.107.100.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nfQhkRiRw0VHgcFYbkzNcx/1XnOWffTnz7SXenBBwxUYe8QV/CYA8YyNF0Xdv1fgYhHiCf/kY0fP8+wAXcP6775+0xAUE9g3CK3Ui6MXpj4SkB8wwy3EIC57SW8UbLPD8H0D5S6zgPTnkKJ9ElitQiL+APwx6cqAZCj0JBnhWLWMK9UXSlxDiPVoZPkFKHJzkpclkKBccW2XVkSFZSSY/fIg5mfSm1pYKzvwu822c3SQUhPX4WOZiB8dgWBF5m/+kBNOdj5rA/uH9sYaoAxMytS+UPHBMliOViZKeA5HoAOhSsPQ6mgtPXkYXD0GYcx+tfXP19MkGWJhYBbA3aMNoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eGuJfyN+/wCBvOeXKFA4JbmmNdF2d8Ez0VCZ79bW0C0=;
 b=D+yb1vKm98Yy8JNWja5u5RxLQLPRZ3hBgAHLBcIYhelQ9kNDWP1ymomqfAHPlo5IvoTPHOZf0FVuVUZ/Y1rCl+c1LLKSAkk0qU+CQpKWktyV4u85BX9dHQHLHj+2TANrCI2SX6UlXzpQdVgQP00KCAjknz2t0qgRVdlpUA/uDnYWy6FjVugXNm7CwlmbBOKmCcQhzG4GCY60CiI2Cj5y2vZW+hXCi+5NptYtMdw/ffiqWW1pGCJKdFTM/B7hvj/KAbgzbQxmacC5U+iUfFMBl98wDr6tWNG6kWFOGcELL+gsX3h4xNoFfKeKtzwPo3MIrLHDXl6rADe71BSd5aXSiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eGuJfyN+/wCBvOeXKFA4JbmmNdF2d8Ez0VCZ79bW0C0=;
 b=B3dbXVhS9tRKxrDMXbl9hA1HyVJ+vyaJkKHcq1r3OwbSS9xZ9uji1PqbuqOKXxgb7LT9znFoW4TV79MjyoWZcuP06XEQDpVllPHxTlpEtro+yqqcD9ClHnXa5ubpGDqtLgZYgYrrSVk38KHnNLq2V6RFLFvr1YAFul1rDxnGBsw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by SN7PR12MB6983.namprd12.prod.outlook.com (2603:10b6:806:261::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Wed, 20 Aug
 2025 23:23:40 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%6]) with mapi id 15.20.8989.018; Wed, 20 Aug 2025
 23:23:39 +0000
Message-ID: <7eed1970-4e7d-4b3a-a3c1-198b0a6521d5@amd.com>
Date: Wed, 20 Aug 2025 18:23:35 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 2/2] KVM: SEV: Add SEV-SNP CipherTextHiding support
To: Randy Dunlap <rdunlap@infradead.org>, corbet@lwn.net, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 thomas.lendacky@amd.com, herbert@gondor.apana.org
Cc: akpm@linux-foundation.org, rostedt@goodmis.org, paulmck@kernel.org,
 michael.roth@amd.com, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <cover.1755721927.git.ashish.kalra@amd.com>
 <95abc49edfde36d4fb791570ea2a4be6ad95fd0d.1755721927.git.ashish.kalra@amd.com>
 <5dff05c1-474e-4fff-a19b-7c17b4db6173@infradead.org>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <5dff05c1-474e-4fff-a19b-7c17b4db6173@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0039.namprd04.prod.outlook.com
 (2603:10b6:806:120::14) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|SN7PR12MB6983:EE_
X-MS-Office365-Filtering-Correlation-Id: b74fcb09-acd1-4f88-ca0f-08dde0409811
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RlBpQU9MNlU0KzBkbktFSWo1N3NkUmR1cU81V1RMbDBnUm9nczAxSVFPVklw?=
 =?utf-8?B?V0ZBMXNtYjAwY3NicmRjMG1HL3V0YkJNL3lZckhSWXJJY004TFJ2WDYzV1J6?=
 =?utf-8?B?RlRpQVN2UHNpYkRaMjlYNDQ1VWZhMHBrS2FzSTJkK01SRUlaNnBpTjhXQ3ky?=
 =?utf-8?B?cUd3dk1yWjFTUUdtdWh1UVE3KytyaUQzTVdzU3p5UytZWTlOSW4rNjNZa28z?=
 =?utf-8?B?NzVCS1ZNUUp0UUJ1dEdFdHhxWWRxYWlLN2xZZ3d2NHg1QkZPOHNPMkNCWENG?=
 =?utf-8?B?WGdTOFB3MXJvZS9XN1hSRDJzRGovc3BxdkViMG5SR0c2ektKY1RFVnJxV2VQ?=
 =?utf-8?B?elgraU5qMnJHdEUxYTRjWElwUUpOUmJEK1NEZWUxaWZ5RDc1LzRvd1RpM3lK?=
 =?utf-8?B?RGtxczRUbzZ2elNNR3lOZis4UVhFMzlFRzZlb29VaXhZbkd0a3hnc2RIWlhp?=
 =?utf-8?B?azNDQ0hFSW5XVVpoN3dqWkJlblQrV2NsRkpFYllXeEF4dU9yam1oS2M1T3lO?=
 =?utf-8?B?U1BjQ1dPU2JWb2ZYbm8xR2R5dnEraUI5SjlUcHFyYlp3b1JKNDkwOHpPVVdV?=
 =?utf-8?B?ZktYM0tRVDA1WjVZb05FODRua3dNUk40dmNqNG03TnA2YkpPNFpVVnFhQVQw?=
 =?utf-8?B?UUxSMEU3akNyWUZ2ZnJ6QUYwb2pzMk4xc1QveWlGSFVUSkFOODRVTmozSlJC?=
 =?utf-8?B?MTdQRWJlMVhGZHVCZW5qQ1ZCZEtNM29tVnpVTWRpdFpLbTRnYnFXWjJlc2w1?=
 =?utf-8?B?Q2ZwSkcwSWlyeVVsVmNMOTFYa3BTMXNVZWYzSmdxVmV3NHJtTFFKbGZ0cit6?=
 =?utf-8?B?YmNVcXN6cFRtTno3eVcybDNiemM1cllNNmc3azNpalo4U1lsTnFqTlVVWS9s?=
 =?utf-8?B?NzlMYzRRb0dUQ04zaXRjYlBBTlNKMEtJS3FrRjZLcncvME43ZmIzM2NnYSs1?=
 =?utf-8?B?WmkwVWFUekFPNEI5YUVmWmE4eDA1OGlFT3c4aEZENm1CSk9UcjZmYlV6cnVs?=
 =?utf-8?B?NTh3dEpHdHhmUXVBS2pPSVlmeDdlTHRaUWUwMDdXMzFvMlZDc0pUbWp6VVFF?=
 =?utf-8?B?bTZCMWM0T1ZxSTQyMWFvOUtyNklxdTBlY3Yyb1dtTHVYcDJWNlBpNkJkVFBj?=
 =?utf-8?B?dkN5YmdVYStteS8xNkh3a3VMelV3R1dkL21QT05qZ1NKajMwcEYzbzdJNmRD?=
 =?utf-8?B?Nm13YkJSaEE3Q2xxcDU3MWlRblBHUXBKOVZybFNyUFpyZVdkTnRsbWM3NUFp?=
 =?utf-8?B?NDY4L2liK3VuS25ubHhBNzNCSTRGWjdOcityOXB1L0FFU0NvWUhZaG9UaCsw?=
 =?utf-8?B?a2VEWDVhM2lWVEt1SlpVSXlEMWJuQ0t6ajIwcjZOZU12QW0ydXkyeHVGTFhy?=
 =?utf-8?B?LzE0a1JqckxKMzBKN1BSZ2VRYVpKSjY2dkFNRm94SnBVNHorS3cyWVNNK0J3?=
 =?utf-8?B?YThVV2JzL1NFUjEyMWRFckRpUWVINnVRTU5IL1NBZW92R0JwdDArMDZOL3VS?=
 =?utf-8?B?M1EwUE1XNEdBV1JWWFhaMFU3SVd4RTRwWDd2TUwvK0xYRklWVW1KNi9rbUVI?=
 =?utf-8?B?cVpQamRUdFRBVDU3bmFUamE1c2ZUNzZPN2lKdnhzOENRYi9hdHJoemlSNS9M?=
 =?utf-8?B?ZlMzWm5hdDltTCsweXFyVlIycjhldXVhSUlONlduQk5pWldkNHRBUTJ3d0Vj?=
 =?utf-8?B?RlRvTlRYTHVvY1NxM2JYVks3SzVUNGJGZkhVZFl1Nkg1K1ZyeURJaWhSWGcr?=
 =?utf-8?B?M0lIdlRvc1hMc0JRQUJpK1lScXVXRyt4anA5aG5VYmVYZDdGazVObUIrNVNJ?=
 =?utf-8?B?VUc3bWo4YWFpWVM2b1JxbWRjcTdnaTFSTHg3MzBReUsyOG9VTEYvTlZZdkdi?=
 =?utf-8?B?Q01zOVpjQVNqN1hOWjMzRDdIbUJPYXdSMWE3cEpqMWpraE54MmZiNEZMSUlp?=
 =?utf-8?B?UTJnb25VbXZjaEFmV0R3S1didmpjalJybTJLSjRpV05wTVlKMjZGcTI4eDVO?=
 =?utf-8?B?aFlNQ2JEWUxnPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZmUzZXVRdWpNR3B2WW5ITzRlL2EzVlhNTVBMZERLSjltUExpTGd2TkxrMmtn?=
 =?utf-8?B?eEZwZVFTTWt2YW1iV0p6S2l4TUI4WThWY3ZlSEliQkhGay9Ud1dBdDNZRXUv?=
 =?utf-8?B?SlpvbElmZVd4eVBKZEk4c3I4azVheUluU0RtN05ENEJ1MEJuTlBsSXV3dmFJ?=
 =?utf-8?B?L0xHa3lRNUs5NVhYUFp2bmlzUFlEVWJteEE3SVU2M2FCMlBDdXNqcXcrbUF5?=
 =?utf-8?B?NWpRclZZeVhlV1FmMklHNW5COWdoS0oyRlpPeFljTUlNa2tMNFY5OExYWUo4?=
 =?utf-8?B?cmNGcUd5MnJBUTlXaWNPNTdMb2wrVnZrdWt6dkIxNENkeEZOQnNxTlJRcTMz?=
 =?utf-8?B?eDgzTm12bTFtZnBBTWZMTjVMc2srTFJWSkQ4WndwUUEvanBOY2l6U3l6MURG?=
 =?utf-8?B?MXhmK2ZEd3VFWExZMTk3YnNvcVFzU1N6OXlDcnN0ZDBnUmwrVDVEdW9ZT3NW?=
 =?utf-8?B?eEthdkZjYm8wNStVdVpKenBtNlhSdnNkTExsSlBkckpVeW03OG5yQ0M2NUZa?=
 =?utf-8?B?WDd1dnpWcDVXbStlaWJMdWx2UmlEVXk4TTRZbGlCMkNJQm9JVy9ZZk9FR1ZI?=
 =?utf-8?B?amVXMElyci9DUkk2NkVHUHRaVC9NMFBLZmgxVkh3V01hOTRiMlRWVmlhQ25S?=
 =?utf-8?B?VDFnbUhjWjlJZ1BtcU9ZMldhZ1BHZjN5MjA3M2NxdFFSbXArYk1GMnR6cUtV?=
 =?utf-8?B?Z1pVT25rZjQ3SlEzS3NkdSsvQk90SGtNZkZ2RGR3azI2eldpQkF1cmxMWWpU?=
 =?utf-8?B?SkhiU2d0aytKWnVVaHBwVHViamJVNnRtalhPcEFVWGhzTHZZUzNTcTRDV1NZ?=
 =?utf-8?B?YitXRW94anBVVEVqKzVOMjNReENLZ2RpREdITDgxMXo0bnR6Q2NwTXZJQm15?=
 =?utf-8?B?RFhMdlJSaG5EeklyMmp5YytsTGtnMHAraEFxZmlvUzJEc1k5aEJFZFY1L1pn?=
 =?utf-8?B?N2RlM3ZhdVV5QmhYSXlZWEdZT2prcUNkcWtjcHZiaDJ0SU1IdzdNS2pJUlN0?=
 =?utf-8?B?eU5jempCYUJaeDRGeDdlanRvdysvUUlrdEVuQ0V4Uk1HRGpUTkVMNEtjamNV?=
 =?utf-8?B?aFArSmlneSt3bVBaY2VIYjd2bmppRi9tQW5zMWVyblJhK3FFSG4zaE1saVhB?=
 =?utf-8?B?TDc0RDZ2STd5VkRwK0tqMVVBTXZLUCs4RXNjeFREMk9nUWRMZWNTZXRRTGxW?=
 =?utf-8?B?OHNCd04vRmdSWjZOL0NoUnhWWTdPNU9uQ1IvZ1NTTlZQZnpqejRyWjJFa0Zv?=
 =?utf-8?B?NTBvWE1tc1FNWElFeWxZRkdIR2ovc2NGL3p2alZPd3pxL2FYWHVhOVdoWCtl?=
 =?utf-8?B?THNSaUZiQW8zTGk3bUJ1NDFQM1lJYlFRb3JFOVFwK3p5am8xN3hobFhiNHhB?=
 =?utf-8?B?RFo3dXFGZWVQOFVraGFHc0IvcVU2OGRMMTZiU05iQzViSUhFTnhxd0FuV0Fk?=
 =?utf-8?B?QXIwczhqdzgyTXUzYm5UY3Rtb0JCK1o4QkRqMXhlNU4rZFJXV2RiR0lHU3l2?=
 =?utf-8?B?alA1elJiVkgxNkFSOXJuYXdpa0dZUU9zR0k4cTJFSHdkSjA4OEtvOG5aSjRV?=
 =?utf-8?B?cXlrUnRKM0FYOXliRnFqMytsTDRyNnE2Nmd6RHFzcFNwSmpqS3oxaXAzNUhB?=
 =?utf-8?B?SUpLZ0Z2eVRjNWxBdy83c2NNRk9JZTVVZjRINkYvalRVazduTUJzamJ2REc1?=
 =?utf-8?B?a2ZGVDVvRTNmV2luT0h3dmhKMHRVandZUmZUMGZ2NWdCZ2wxcGhTbzc2M1A0?=
 =?utf-8?B?UFk2RXQzMHhDZ3o5USt0NFBjL2FDZWFTYktHK2N6TUhTZHNkVURjKzh6UzYw?=
 =?utf-8?B?MVZhb3k4a29zeTNzeFB1Rk9KVVhDbENCTWZuZ1hyd3ErYm80TFJUR3hKWW1H?=
 =?utf-8?B?bnZILzdyK0xqblJ6L3BDdWpQdWF5OW1rbDdNcFFwZ1pBa3ZhQkpZMldraWNI?=
 =?utf-8?B?RjdvWVZuR1ROME1jTXpFSUdydjR1dGJqaW05cDU2L2MxSFpIRUxFbHlwQUpJ?=
 =?utf-8?B?OXMxcjU4dW9Na0RzaTZJREpNUEpHUnlwRm1HallwWHRnNFhYOWZWK0hOV2RZ?=
 =?utf-8?B?RUcrb0ZLWkswWFd5UUh5SGFHT0Y3MFhFSW5yc1pQRmtLN3plQ2JLUW9ScXc4?=
 =?utf-8?Q?M0PIbUvnxU3g+d9mhD8fUgpKf?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b74fcb09-acd1-4f88-ca0f-08dde0409811
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2025 23:23:39.2872
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1BgaY+TCz0ZpO87hq/oTcMDUfAPT/ZHNTRKm2U5mnZK551AH0wMO/7o27BFz5d2dFa5ajhSztHSEtk2/ZhSRvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6983



On 8/20/2025 5:45 PM, Randy Dunlap wrote:
> 
> 
> On 8/20/25 1:50 PM, Ashish Kalra wrote:
>> @@ -3064,10 +3070,32 @@ void __init sev_hardware_setup(void)
>>  out:
>>  	if (sev_enabled) {
>>  		init_args.probe = true;
>> +
>> +		if (sev_is_snp_ciphertext_hiding_supported())
>> +			init_args.max_snp_asid = min(nr_ciphertext_hiding_asids,
>> +						     min_sev_asid - 1);
>> +
>>  		if (sev_platform_init(&init_args))
>>  			sev_supported = sev_es_supported = sev_snp_supported = false;
>>  		else if (sev_snp_supported)
>>  			sev_snp_supported = is_sev_snp_initialized();
>> +
>> +		if (sev_snp_supported)
>> +			nr_ciphertext_hiding_asids = init_args.max_snp_asid;
>> +
>> +		/*
>> +		 * If ciphertext hiding is enabled, the joint SEV-ES/SEV-SNP
>> +		 * ASID range is partitioned into separate SEV-ES and SEV-SNP
>> +		 * ASID ranges, with the SEV-SNP range being [1..max_snp_asid]
>> +		 * and the SEV-ES range being [max_snp_asid..max_sev_es_asid].
> 
> 		                              [max_snp_asid + 1..max_sev_es_asid]
> ?

Yes.

Thanks,
Ashish

> 
>> +		 * Note, SEV-ES may effectively be disabled if all ASIDs from
>> +		 * the joint range are assigned to SEV-SNP.
>> +		 */

