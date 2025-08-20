Return-Path: <kvm+bounces-55083-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FD29B2D149
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 03:19:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E91974E1CCB
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 01:17:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E90A61A0BF3;
	Wed, 20 Aug 2025 01:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="dFwMXmxl"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2050.outbound.protection.outlook.com [40.107.96.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B55B8634F;
	Wed, 20 Aug 2025 01:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755652637; cv=fail; b=eVDHcQ16rxCqf1UpkKXS7PR2SBgqXAHlOGyT41FvwakxzEPh3L4ilDdsfc8tlFvo8Pp+/KuWU+iBSgKqfPAjEOoGuAlXcjybMMdNeQMa/TI0k6az6xZeOxWZ1TlBTiHE7K+IAP3Q6E1xZiKMcCbEz9MmLbGLx0+PltPG2O+2k1c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755652637; c=relaxed/simple;
	bh=oCN6eGAHzp3cCttZaoY+n69k42ey5kMvIFIAb1FmecY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ZWZyxyx847cPrxm8LL2sTJff1lbpSJRzOJAcc5u01+zTaKI2qrmzqVY3T2lFY9cb9u/bdu1U+6htXfM1qblETQNF1W5ATc9UjdI+B5THioD6buzj9WL7cFzkhavP7VLAEHdRe2/v4Ha6hqWcI1YD15Yk89cGi6do0TlNO6WWNek=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=dFwMXmxl; arc=fail smtp.client-ip=40.107.96.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OKGwf2+F+BTPD3CSVUr0KRCgugjlxCj0+B/Swojz/iGh4/ezop4g92S0RMXkIHdTahSd+Nbt5bRJv3SbZlFzfV3rtH+pP5YOpAZcTSDmqgnb+/DU4HABWHmrj4x+bSFXhsKxlrOYxnNx6s0mysYY7CaAtkbqIOWvSQCTGvLLBAK/2dYrYyBsfuD8lTz9/hyTFTRDqDKSG8iAwllXx7AqGoloLGWZQWPWGeWwYbqBmYp4b6I6H2bHavVs7UlcWqovIL2A+vMfyjTp/1nOcPfxtdhco1GKq2q7cE506/P2OdOLrbnXUpEkAx09LXrPC/tyZbsqtMTbpsz+q17Y6lqwcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i/OPpfmeCVVK3FX/CAvjfkt4HhcRNZFmRFvV+G2Z8FY=;
 b=i9VMHDKUSWhi8rn4TlkeUQz1j8R/WkLW099teuor1P24A/2vwZ3ADm/nd1JZu2dbQ/SsYKw31pGcqXZPCwQxfAXF4D2iXuvpNO3uHPkmZGvOhTOZX4b5EWgijeIbH+hbJRJ0ykUOx890ML5dHaWzQjNcyGk9c9heVpPVODId/YCuKT6C7Lr7owHPH225BSbTxJtl/Q4obECjcSHNhAyBIGICjzYmpf+R6JoaDFjDbhtcP/qbndMZ577IAxtQBCbLQhnn5SuwgWcJCYXKFUpyYuRhJQjS6jO1ny5ErqwA3dv817GeH8GPhZceQ0ZNvM4JlTP/OG0lxJ22UGbejJWsqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i/OPpfmeCVVK3FX/CAvjfkt4HhcRNZFmRFvV+G2Z8FY=;
 b=dFwMXmxly7AIuZsJ/NyrWFHqTHhnRDn1IVeuDlX8LtDMUHnXkP2Z3vOSIMIln+tcJWl/6OFEt9wl8wNH+0OObPHnjZBZyXlgGuYAZIdTxg67Ha10Yp+5MmqzfA08q0t+XlUBS+sMTIY2jOe9SGuuh9aDpyxTX22nPisV5YDev6w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by BN7PPFED9549B84.namprd12.prod.outlook.com (2603:10b6:40f:fc02::6e7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.17; Wed, 20 Aug
 2025 01:17:12 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%6]) with mapi id 15.20.8989.018; Wed, 20 Aug 2025
 01:17:12 +0000
Message-ID: <e1740fa2-f26c-4c3b-b139-b31dd654bea6@amd.com>
Date: Tue, 19 Aug 2025 20:17:08 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 0/7] Add SEV-SNP CipherTextHiding feature support
To: Sean Christopherson <seanjc@google.com>, Borislav Petkov <bp@alien8.de>
Cc: Kim Phillips <kim.phillips@amd.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, Neeraj.Upadhyay@amd.com,
 aik@amd.com, akpm@linux-foundation.org, ardb@kernel.org, arnd@arndb.de,
 corbet@lwn.net, dave.hansen@linux.intel.com, davem@davemloft.net,
 hpa@zytor.com, john.allen@amd.com, kvm@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, michael.roth@amd.com, mingo@redhat.com,
 nikunj@amd.com, paulmck@kernel.org, pbonzini@redhat.com,
 rostedt@goodmis.org, tglx@linutronix.de, thomas.lendacky@amd.com,
 x86@kernel.org
References: <cover.1752869333.git.ashish.kalra@amd.com>
 <20250811203025.25121-1-Ashish.Kalra@amd.com>
 <aKBDyHxaaUYnzwBz@gondor.apana.org.au>
 <f2fc55bb-3fc4-4c45-8f0a-4995e8bf5890@amd.com>
 <51f0c677-1f9f-4059-9166-82fb2ed0ecbb@amd.com>
 <20250819075919.GAaKQu135vlUGjqe80@fat_crate.local>
 <aKURLcxv6uLnNxI2@google.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <aKURLcxv6uLnNxI2@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1PR03CA0024.namprd03.prod.outlook.com
 (2603:10b6:806:2d3::25) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|BN7PPFED9549B84:EE_
X-MS-Office365-Filtering-Correlation-Id: e2acde6f-5ae3-428e-a889-08dddf874a97
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OXJ6OHdKMXg1TS9sN2c0MjJ3UWhmRXR4NllXWnFIc24wazJrS3E3RHgvSlB0?=
 =?utf-8?B?OWdWbTFLOW5hK0dXYzBHbnM4dkY3VGNFUk9wanhmaFhGY2V5MGZaWDFPMXVv?=
 =?utf-8?B?aDNhT3ZFaUJxdWNUWXNXYUdHaTRsZFYvNXlUWFg3TzVtOHBXYjFDVmEyZ09Y?=
 =?utf-8?B?R0JvSjV2QUgyOURGVnNScUU2T1ZPS1A5czFQMm05aGVBeXU2U25tN1c0YmtG?=
 =?utf-8?B?am1yNW4ybFYwOVk0bDlrQm9KRXJHU2pvVzJxYngremgxM2JWVXplKytUdXBi?=
 =?utf-8?B?aHJPQ3FYdDd3VGJiT1FzSW5UMnVadFVzcEFUTUFtTUZiYXk0cHZqb3JvRVFM?=
 =?utf-8?B?SXBWbS9DSXlDTnJQaDFnamsyZHlIb3BSWEZFcml1b0syVFlaZFBnTVJ5MkJF?=
 =?utf-8?B?N1JDbWYwUnpZYjhEWmxzU0hYNTV3MXk5N1g0L3JjOGtOaUVqWlNkMHVSaVpV?=
 =?utf-8?B?aSt0bUI4a2VnekJKMENoRWNRZFNRdEV0Z0p2UEp6YnloMDhIMmI2eGNkMHFU?=
 =?utf-8?B?aHVlTWhIbEpnaklYd29oNGc0TCsxN2p0SWxlTDJoN1hoLzlBck92ZExrMy9H?=
 =?utf-8?B?dkk0VSs2c29BZ1RKNjFPTmdEbDVWYVlmaGxqcW5EWkRLd1VzdmJxcEhMMnly?=
 =?utf-8?B?VXJxSGhsbnQyK3h4TndsSmh5WmwwZjhXVU9DY1ZrU0RVSzhnQnpLUThocmlT?=
 =?utf-8?B?eXB6MTRhSjdzQjdSamdLNjdoZEZzNElYTlJuVXZpWm8wRjRNd1RJdXVYRllN?=
 =?utf-8?B?OFFIeTZpUHRUbHlDV0doOFY3NkV3aW04MUJFZEdIU2ZCQkp5bm5pS3RIZ1Bu?=
 =?utf-8?B?TzBpcVNKM3RHRkN0blg3R0tyM3RRUk54VnRaSDk2MkJtcHJCYU1wQzR5RzNl?=
 =?utf-8?B?WmtBMUFLMktGaDBCMFBRNkZ0aUxNaWVmZFJGZXROVHdGcXI1aWVtMk04eVNj?=
 =?utf-8?B?SGZkR2xpTk5JbHhweHQ0dWZTR1JFN2pPQW1NZHcxWnkzTlQ1L2trb2FyblBT?=
 =?utf-8?B?MXFhRWtTV2JNa2pUdk5SWFV5cVM1d1p1cE41VWQ3YURwNnNkV3pneExwaVVP?=
 =?utf-8?B?SlpMM0FROXozL1MrOFhFWUxPcXc1UE5vQlJadmRuU09CWVdCRDJET1IxVlZq?=
 =?utf-8?B?QnBMQWJFSTN1VDRtc2tCUE40dUNjV09WL2UvV0V5OFRsaEswVFlXcFRkbGZi?=
 =?utf-8?B?aTAxSDhxaGVoaFA2V2xFdnhQUStKQVoyeFlsSUl4YWlFU0V2ZnhPUWF5bVZv?=
 =?utf-8?B?TVMrcDhoZUxKRjVzaTY1K1BJQXl3YzdVdWdkZmVLa0owd0hXR0tSbVNLazQ3?=
 =?utf-8?B?VVNiT3JHTllvbnhBNGtVWnd3d0dGektBcnFPQWZQanBaZHVEc3pUbXlJVEdH?=
 =?utf-8?B?bks5VHlFS0d4QmhlZWNJZFcxVlhBRWlGZ2NKV1lRaHZRVXp1Mm4xM0h2WGZ4?=
 =?utf-8?B?Y0xNUFdMUVpXWTJreHdPb2k4Tm56SFlQQXMxd2wyd1BGMWVYQW1CekFoeDVJ?=
 =?utf-8?B?MG9iYUY2eXI5YithL3EyZDYyQ1JOTEh1SEl2cVNaS3BrRldtd0ZHQlpZNXAv?=
 =?utf-8?B?MTNvTVBGSzF3WkNsOVUxbkJzb0pkWE1GTjlmd2czdUN4SytKeXJzZlc4U0My?=
 =?utf-8?B?bExzN203c3JwaGtHay85OHUwWWlVWTBFbW9YejBKQk14NWt5SUYrM3I4bSti?=
 =?utf-8?B?eXlMd2o4SVk4dENXaDU5aVFWeHNzKzNQbHZ3ZWMwLzNqUTNnTUkvQVRVNWxa?=
 =?utf-8?B?L0VPcTBJUGlCZVZTNmNtc2IyL09oV1pHWTlRV1kxQy9xSGlCcVozM0U0NVg5?=
 =?utf-8?B?YzVkcVRaZWNCRWVYUThDYTNDRGRWN200Umo3K1JJMkZYaDZJaTR3cWRhNzhw?=
 =?utf-8?B?OWRaN2xDSW50WlZXNFJ6K0FkUmU2K3NBR09PM29GcGZUSlE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aEdmYVlMa3ZBTE13NEFkeEFwNHN1blBpVHNIUnFtRkR1c1MyaG1Ccm9hWERL?=
 =?utf-8?B?TU9sTzNRYnlNekdoaERuY2d4c0NKeDRuVUc0VjNaTFZ1QWZyR0RaTjh1UHJY?=
 =?utf-8?B?OFB3MTZGeTMzOGN6UGVTODlmUTlVTU1oazI5eFhFM0F1RFkwekJhTEU2MFNS?=
 =?utf-8?B?WGs1cWtKcHVoWWxyWldNTE1HWG5zcW0wRTNaUENlcWo1eG84L0Q0eWFZbkhG?=
 =?utf-8?B?ZC9TSkhwZENWNDB1bGhFcFdCci95bVJDNnhZY1lXQS9RZ21Yc3VTRXFBZVN5?=
 =?utf-8?B?TFJZcThMZis5dTR6UUE0cVFoWG8yWnc5Q2VpbDJqTk0ySnFqUHNyR1pGcktQ?=
 =?utf-8?B?Kzg4YWExdmNUcEgvL09LY2V5UmorWHdaa0hCaWZJQ2Z3OTJQUm90R0V5ZExk?=
 =?utf-8?B?Z0wyTnF5bHlDYjF3VHhkR3FrK1N4UEpIUEJpS3BoeitkQnNkdUJnRk1TTWMx?=
 =?utf-8?B?djJHUkdIZG1PaC9EVGxFaVlIVUhXUGdHcGdrRHA1Z3RpTXAzVXdrMmVEdWFn?=
 =?utf-8?B?dHJlVUFSdVhzT3oxQm9oK29LdDh2VGtxZWpSaVZOeGtiRXV4QXdvbmRzb3RX?=
 =?utf-8?B?SVcwT01lT0ZEeFYzK1hIVTZBdVk0dnc1dm1mWERmOXJ6WVpSRGxSUzVJaGIr?=
 =?utf-8?B?WTE0ejdEeEtYWUw4QmNWcng4d0JsOEg2OHlOVFRIUHlNOXAyaCt2ZlVDcHMw?=
 =?utf-8?B?QXc4RGFRb0RMeHYyM1ZpV1hhcXFsc3FsYzhjaEduZkcwRnprdDY5OGdPcUtQ?=
 =?utf-8?B?Zngxa0lIY0NiUk5HaEhFU2ZXaGpoMjF4ZlNFY2NabGVSUmJ6SFR5ZzI3WXgw?=
 =?utf-8?B?ZExhVW51ZlpFK1EzOG5NMkpPUFNzTThlaTlHNFR2UTJvMkdBZkxMdzlIUWlI?=
 =?utf-8?B?Y2hCc0xITUNtTitKN1lxeERkSHZOeWFMaXVYTjIzRWVEbGJPMHlkM0g5THR0?=
 =?utf-8?B?M0g0em5KeWJsbjdrS25uNnB2RC9GNjM4KzRpbnJJUUliV2xlc3BvaFFHcTVH?=
 =?utf-8?B?bUNiZFdoY29YTWd4OFpQUFB6a3BYV1hobG92QTVlNi9lZ2QvOUMxdGpOc0E4?=
 =?utf-8?B?QksraGlndG1XNVFSVjNHOGZWSklwdzdpbFhpODI4cWxLbk96bHhLMWh1eGZn?=
 =?utf-8?B?V24yalNKZEJnVTJqTnVmdGUyQ3RwbTBobzcwc2Ircng1b1FDajVYaERGTjBF?=
 =?utf-8?B?T0xYampxOXdsdXpCN21MWW0wWjVWeWpWSm02TUpzeUlkYzdqNCtKQUhIS2Nu?=
 =?utf-8?B?K2JsbENOSlJ0c3NjSnhlWk1PYVJyKzh4WUVZSkF5SE96TUFmTjE0R0JNek9m?=
 =?utf-8?B?MzNMZmd2K29kVFRzdmNub0RQamROcWJMdFFVNzdramZpOEJheis5ejY2Qisx?=
 =?utf-8?B?RDF5SW5SY1BWOFdpakVCbklySkp3V0N1ZDVzRnZOODRPQWZCWVg1anRaamp4?=
 =?utf-8?B?YXAxQ2Q3eTl3VFVZU083NUhSNDEydi85MTYyS0pPaUFFWXI5WnBGQ3IyV3hn?=
 =?utf-8?B?ZDdVTjVJTVloWVF1NkZTUm1GWGQvUy9zd0Y0NmRQWXpsVHNKMDhVSkJJeFVK?=
 =?utf-8?B?d0pGeWVSWktlRkJMc3cyZDhQbXNzUmN0cGx0YVQydTN6MWh4enRyUklveGJy?=
 =?utf-8?B?cFBBQUc0Q0tqZnFrNk9mUTQreVprQVB3Y05yVGc5Z2pQYVdRYTlGaWVvT2p2?=
 =?utf-8?B?OFpDQnhtdmJMVWErczRmWEtTZjVCM2JkM1ZNSEp0WVM0dld6K05EZDBJSUwr?=
 =?utf-8?B?L0s4WU5DTi9tUTNLY2J2elFodXNCRzJlcXpxdjgzYjVJSDNZNE55RGc2Zk1h?=
 =?utf-8?B?aU1pdG1WSHF3bkpiNEZPa2ZxaXVuRHBmbUpINjJ3ZTBMSTQ2Wm1VR0pGR0l5?=
 =?utf-8?B?TmtyTFVuY0RVcERUMWg1enRqZkl4U1V0NUk1MlNUZVIrR2ZiblVZQjd6Nkd4?=
 =?utf-8?B?QzNhK1B3WWFtNzdRTW9YcWpGZUlERitJOUZXdmorOTM2Q2MrUnh3TGs1NUJo?=
 =?utf-8?B?TWFqTEZ6WDlyMWsreGY0Z2xheGNWR3Q2NFp0dDJSNmQ2ZG8wbXozeWZIS0Vi?=
 =?utf-8?B?ZG0xRHN4RWhNdllEZEdld1pOeDY5U3VYR0Y0cjRzcXpXR3VWcWdUcWJrUXJw?=
 =?utf-8?Q?vV6gYsGBGODcKVzsMAfkIKTxW?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2acde6f-5ae3-428e-a889-08dddf874a97
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2025 01:17:12.3452
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lBj5nihYwawwBfCRFsh2T5U2ZfmgXqcwrLobPRKEsInR0kw/gIupRqmdvF3SqZOwUXyXrT9GV8XI7iz94MlvFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PPFED9549B84

Hello Sean,

On 8/19/2025 7:05 PM, Sean Christopherson wrote:
> On Tue, Aug 19, 2025, Borislav Petkov wrote:
>> On Mon, Aug 18, 2025 at 02:38:38PM -0500, Kim Phillips wrote:
>>> I have pending comments on patch 7:
>>
>> If you're so hell-bent on doing your improvements on-top or aside of them, you
>> take his patch, add your stuff ontop or rewrite it, test it and then you send
>> it out and say why yours is better.
>>
>> Then the maintainer decides.
>>
>> There's no need to debate ad absurdum - you simply offer your idea and the
>> maintainer decides which one is better. As it has always been done.
> 
> Or, the maintainer says "huh!?" and goes with option C.
> 
> Why take a string in the first place?  Just use '-1' as "max/auto".

It's just that there was general feedback to use a string like "max".

But as a maintainer if you are suggesting to use '-1' as "max/auto", i can do that.

Thanks,
Ashish

