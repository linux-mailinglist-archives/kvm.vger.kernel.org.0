Return-Path: <kvm+bounces-61161-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 405DBC0D801
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 13:25:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id AC0E14F3299
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 12:25:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42B3430170B;
	Mon, 27 Oct 2025 12:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="gpw9xvag"
X-Original-To: kvm@vger.kernel.org
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013029.outbound.protection.outlook.com [40.107.201.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD16C301492;
	Mon, 27 Oct 2025 12:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.29
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761567943; cv=fail; b=mmVZZGXGPKAFBSGlAgA85z7L5tHGZqOwkvhzmTddSo61MBtblBc3cdnIn8tyGNff6Fzfgt+sqihBI5YSiDYfRrRDg7JkdzBCenpKlfUaCwcDcGNyykqp03OSaLnKHDlGOAbEtcpU0He0BYYn5MCzfoWVBwXwNDYs72S7kja/ESw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761567943; c=relaxed/simple;
	bh=RBTivEu/yUekwWqo0mrBixbteXHuQgO6PVE7JdklNJk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lqNOO7v/zmZcl0/pv9ffzF/5qEH0extGczVM8grPpBxL01IWjAXCcC0ccH6fzMlLnNIht3Vb7fD3/6fpCS7XQPg4C0xS9dJRmYKcPKVkf59PLNKLGMZR91SbnrGvvS7xXGNWx7peJ6YmPMCa89coQoUWaPAVjylORjLCET0bL2s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=gpw9xvag; arc=fail smtp.client-ip=40.107.201.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G6k8pI88QAjxsr+E86qMmwgUraRkKV1TdB65CqEgQ+bHAkCPMRsAXPxU8jKHiTbAuoMNNVFpf0NHHOc7JGFtnhIhwk0Ds9C8MdgfO/0X0q/QJ80K9LbC0yp/Z8xhcwWuv4jWQstbFh/KZOCUpHaOZsIFQur87S9MPaeMHRNST7uEPXdDbk8S9hGG4AUqKRq7RdLWbnkRmgK9HoXLVkbiar60qrg/xfob2baFbts5JzbK0pMKYYLqGNFirsLIYA8LAkfJvdrnOuFnP3wLQRAzx07b7TDxvRJJ7uj7qBoK/uMcfZU45yOPT1ogZX3pbIQWmGYXTKyppDEhYbh9tyDQ4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+6Q+/3FGm/DLfdal1fz+RsOeFYzBkWG6s/cfoymDEoU=;
 b=xXHzUlIAc5FZvct0D9xQ9xxsFxDoEg6/2h+T0MRQzae5Gx58XmzqJhXuaS2aen+2hiUpEZ6xI72bfnIEANidCHFzRsWXHnju/lvXeXmGYElNKbwFPwhY+Ib3OCOd5gG6fYAAIgj8n7ZEZa75NQEEiQgi4empk18wbWARrdAycl2mHKwRzHcERmHnD8jEgmbRS+dVRZBhj6j3vOVdsB1z8b5WODlhoF0b4eR3XqgpT7/KPR3Za6btL8kAk7rPlvddCKhn+OUP+x9NNhk1pUlRe7jSKcWzZa9heJuxpNsO9VwMyXDiCqU7pFmGio5P0wAntog9ohv1J3QHb/dJfL2W/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+6Q+/3FGm/DLfdal1fz+RsOeFYzBkWG6s/cfoymDEoU=;
 b=gpw9xvagzbR0Eh7EovyiTy0J4L/g6/g+rUO0IosdFINLKudu2+YjeN5u53UotlObKroHZHkLjq+MAO5tfPJusLWn2UXNos1gx8GDIojUnK6CS9loNDcW0PSuA+p9pWrAYyuPuE9gRKdBZTFKbapA7vX9teke7A2u3YRHCGbfUV4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA0PR12MB8301.namprd12.prod.outlook.com (2603:10b6:208:40b::13)
 by PH7PR12MB6954.namprd12.prod.outlook.com (2603:10b6:510:1b7::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.13; Mon, 27 Oct
 2025 12:25:37 +0000
Received: from IA0PR12MB8301.namprd12.prod.outlook.com
 ([fe80::e929:57f5:f4db:5823]) by IA0PR12MB8301.namprd12.prod.outlook.com
 ([fe80::e929:57f5:f4db:5823%4]) with mapi id 15.20.9253.017; Mon, 27 Oct 2025
 12:25:37 +0000
Message-ID: <88cbf12e-30ec-4b2c-a97e-b8d9e9aa8dda@amd.com>
Date: Mon, 27 Oct 2025 17:55:23 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 04/12] KVM: guest_memfd: Add slab-allocated inode
 cache
To: Vlastimil Babka <vbabka@suse.cz>, Sean Christopherson
 <seanjc@google.com>, Miguel Ojeda <ojeda@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Ackerley Tng <ackerleytng@google.com>, David Hildenbrand <david@redhat.com>,
 Fuad Tabba <tabba@google.com>, Ashish Kalra <ashish.kalra@amd.com>
References: <20251016172853.52451-1-seanjc@google.com>
 <20251016172853.52451-5-seanjc@google.com>
 <343bc9ae-17d7-4466-8788-adc68acccca4@suse.cz>
Content-Language: en-US
From: "Garg, Shivank" <shivankg@amd.com>
In-Reply-To: <343bc9ae-17d7-4466-8788-adc68acccca4@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BM1P287CA0023.INDP287.PROD.OUTLOOK.COM
 (2603:1096:b00:40::28) To IA0PR12MB8301.namprd12.prod.outlook.com
 (2603:10b6:208:40b::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8301:EE_|PH7PR12MB6954:EE_
X-MS-Office365-Filtering-Correlation-Id: 98decfd8-0bf3-4260-da01-08de1553eee2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MGVBcG9oaWVJa0JHRFFWZlh3UHV5cVVzaG0rTFlYSDM2QnBKWnJkeFBNYUFS?=
 =?utf-8?B?cHJhYkJVV3pBNHMxQlQ3bkphWnc3RXFMaUp1YVcwYnhaVlVjS3V5d3M1VU02?=
 =?utf-8?B?a1F2dlVWdjVHYlVLbFFCMWhhck1QcEROcmo2M1ZKRGVUOUxrTEZIYkhUYjNG?=
 =?utf-8?B?VS9CVjBUZ2RDNm14ay93SXNwam5FK21IY00xelMya3JHckNaUXEvT1pjeFhP?=
 =?utf-8?B?Q3l6b042Zkw3VjhseG1sUDdPY3NyS0swcXl1cUFhNThUQ0R2UlhpQzNmbS9L?=
 =?utf-8?B?MTRBSnhxaUU1aTQ3ckQwQUVLT1BIZ01KdXFqMWdPVGlPMm9hRktLcEl3dkhy?=
 =?utf-8?B?ZW9JL0NXV09oVUdyaGFWRURQaDZLT1JwQXVHd242UUNuM2R5RmVneFlkeE8w?=
 =?utf-8?B?enJESFFXRWJZK05VeCtwdjVTSm5pOTl3elF5b0UyWU9KdnppSE4wZFpMK2NG?=
 =?utf-8?B?MzNtcGlxMDRpSzNaTDdsaTFyQ2RVN2NLSlVnOFpwT1Y5RFNNUTlyOGNkOUN2?=
 =?utf-8?B?TVE0SkxvZUZ2ZWtSSG41U2RZZ0RzaU5zS1hIaTdtZno0UktJNUJUNU44a015?=
 =?utf-8?B?SzI4a0FrUmdQV3hYZFU1Qi9Ma2VQWXB4cXdrc0lyWXc4eVhIcW15RkcyNjJp?=
 =?utf-8?B?bFRVOEZJNmhaWmg2bmFhcGVRV2ozVTdQMnhDVWFsSGsra29TazZuYVRyMGQz?=
 =?utf-8?B?RDdpcVY4dHV5NjBwOWIzT2NlVkRxcVk0dkxaVXZ6S0FtMUVZa29GTnRWUTlz?=
 =?utf-8?B?M3BIamxmYkMzV3g0ZlE4T05sRGgwUU5PbU9QODdoYXMzYXJzZjErMkdkNTFB?=
 =?utf-8?B?Wm1pbmprTG11c0VYaVhRaUdYNno1cFcxK3BmcWx6NzhMMElycUY4d0FTYlZQ?=
 =?utf-8?B?Y0FEZ1pzdEozcjFONjRVZlgwUWRjK0E0ZnpwRWVTR3ZMYkJkeDh2RlJuMld0?=
 =?utf-8?B?QkJlYUJWdjJoVjcxcmlGcFV5TlNIWUpFNGZWaEFWTjUyS2NsUU82R1RXNEN6?=
 =?utf-8?B?L3hRRnpnOURmRXRPdFZUcDFOUTZUcWl2eE9TMVZmYTZWb3EwOGVwYWlNeW5E?=
 =?utf-8?B?YUFSRld0RTJzYktVdFo3c1I1RFVpdy9wUEhUWVR6SkVtY2R5VG04bHZZUHlW?=
 =?utf-8?B?Mm1YcS9nZENtWUxUVlQ2OHBRZnlOT2FaSlJYdmVTNVdTZGY5TlBaNEtIN1Jw?=
 =?utf-8?B?N1RId29RNU9qWUF0UVFJTnJTeTkvSGo5Y2g1RzJMbFJPaDhtWGZyL2hHRGtF?=
 =?utf-8?B?aXRseTVJQytzejNwVG5VUUdRRnBJZXRibDRSL1l2RDhDb285NVlPT2FzOFRS?=
 =?utf-8?B?NjU3REV5dTZ6N21KTyt3ZFVBdGhtMmZMblRPMW9UOWNlam5lV2NBaUJraWNU?=
 =?utf-8?B?ak41c1RsN0NpVWh0R3FkeTdtVy9rMk1yTytSREtqOVNzZzFxbDhST1VEeUxj?=
 =?utf-8?B?eTJyT0dkMmx1Q1VORlduNDlIOElnckdFWUtnbGxrS2xjZWR5SmNXN2hBTlZk?=
 =?utf-8?B?L0E5NmRZVlVBb1hJcHduRHRSa3B0OHNaUzF4TEtsQ29sUXJoM0hxZjU3WWQx?=
 =?utf-8?B?eGRqcVlwcFlIQlJtWkZraDEvV1F6a0d2d3Z6cnF3aFNUN0s3UFBZbi9wbit6?=
 =?utf-8?B?Z1k3amJ1TGhnOEQzQ25hbGIvQjh1Zk5sVC9lRkQ1RnpsYkdaMXNIZmZ6dEVu?=
 =?utf-8?B?VjVnZnRuTGtVdzB6Vms4TzB0amRFUUx1VWhnWk4wTnVIaTZCNFZuU2t5by9Y?=
 =?utf-8?B?Y1lPeDFPNHdDbVRuaHd6RGs3Njd3YVowYUZHdzMxTVhjTUNCTlFLd2puSWxx?=
 =?utf-8?B?TnRBVkN3MEhhSk12OTlzZlhaNDlvZjk0MHR0VE93RW1ldjlRY1BnK256Y3N1?=
 =?utf-8?B?NFA0NGk0MHUwd1B0SXErdUpjeVhDNDYvVE55RzVMUGxGTmdRSVpaTndsZDFX?=
 =?utf-8?B?ZUtUb2NrZEs1ajFCVy9qS3M5bW9jUnB6ODFLMFhpbUMzT3ZxNXY5R0tuVzlW?=
 =?utf-8?B?VG10VTFGSzZ3PT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8301.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d0xYVmx1cjJObld2TU9aakNJUlhGZExJMDlnYmtUUVpBL3dJN04wWUpnZGxH?=
 =?utf-8?B?SzJVTnowQ2tNa0FxVGZNWE5TL1NlbnhQWUNGRXFkV3Fjb2p2V1BMbkYxUWJz?=
 =?utf-8?B?c0NFVCs3dnhqd0hRQTZpdWVST1prc3RxdWZDeVRPa3crTmdsZTlGL1l0M0lG?=
 =?utf-8?B?bFBEbW5CWE9XcEdqOUMybCt1QTR0dWZ5Q2gyclhJbnZFTHhzcGFKVkRQb0FU?=
 =?utf-8?B?aXhENENPM1hIT0NXWWVIbDBzb1pkdmZBQ0YxRW9UUU5PamJkaWs3cjBRVlBN?=
 =?utf-8?B?TGhEeHQ0c1VueUxnY2s4UFBjSnM0VlRHNG90UTlsSHZkeE9OVXFGWWVINjRs?=
 =?utf-8?B?SHcxRVo1anNCTFNsZ09pWkNFblNGMlpieGd3MmhORitXRHhXUzgvZTJRZmRK?=
 =?utf-8?B?Tmc3b3hoc1ZROFNpOUVUME4zWkFTWTdDbHQ4QVQ5T3lUR29jTmMrUU03amps?=
 =?utf-8?B?WFVOaFVmQXVSQ3ZZMDFsNEQ5enVvRm1ZaTZ6Q1RtSkRqWUdnb05GcVo4bWp1?=
 =?utf-8?B?OFFlbVE0eEJYZ01reGxVV0V1UFRiVkd3RHluUXRWVWlQOTc4N1lmUWFyL3ZU?=
 =?utf-8?B?RlNNaHdXNmFtNWFxdjdwelJZY1M1eUZwWmp6cndrNGIwTXFGS3RRVzEzb3dX?=
 =?utf-8?B?VGFVZHFjQ1BnbDQvNWcyVEF6QTN0cmkvN1lSTE5zVzFFdVZQalpzWmRpRXBB?=
 =?utf-8?B?MkNpdFFmK2g4d3dHR0cyQkZTQUVkMzBYZjA4d3lGd1NDOE5Ia1FxWjVjU01N?=
 =?utf-8?B?djJSZFFYbzc2SUJjV0VMVUpqclN5VnFBM2R0WUpwZzFSb0Z5M3R5emdrRmk3?=
 =?utf-8?B?bHlTWnNPckl5RzRhelYvZnE2ekh2VHFwbmRDZ2NRVXlCUkkrMVlKbkxQVlk1?=
 =?utf-8?B?N3BpUytTb2ZaYXlwT0FFQi9SSnUrQ1RwT2RrSEtvRzVKcXNsSGtFVXBPRjRo?=
 =?utf-8?B?VUt3MEJBSFNMWmxtSUtIUHVtcEFOU2FXa0pTbU43cTdTQUJ1V2VaM1FVUkJo?=
 =?utf-8?B?cjZkbFA5L2ZGOFNqR1pPbHdNSHNKU3krTWRMbW41dHVwazhOaFByOEUzRnVS?=
 =?utf-8?B?dUVpWjlSTURZdjYzUEJUTDk2NjBPYnVETzJyUlh0MjNjdEVaN2VEbThrOGlu?=
 =?utf-8?B?NVBaRnFQcjh6aENjQkFaTXNJVG9tRTdnRlF2dHoraS9JYmJXUHA0ZEl4ZlFU?=
 =?utf-8?B?QXdMODhvSzhvYnBtbHhtZTdDWjBxYkE4Nkk2K0FLNjI2emRwc1g4UnVTOW13?=
 =?utf-8?B?SDVZSHVMWERMemkwQXFucHRWeGIwMUtET1J2ZFAwSzE3UVhNbHBBZ3ZhTTVr?=
 =?utf-8?B?aVdqeUF2ZTkrQWR3bXBLWFdxeFEycW42d1pkZEd3dnJvTHJuMldGTUM5dzFy?=
 =?utf-8?B?MWRZU1ljMEZXZjNIVTNBU1hiNVdMVmVlckJUVDZCR0ZlQVo5ZnhLaGxMOHNI?=
 =?utf-8?B?MUNnM0ljaWtuV3dqaWNxWitETGtlK0hXMm02NnFCV09xaDJFQ1lnL3ZCVStL?=
 =?utf-8?B?cG83OUM3Vk1GNElhVi9jZ3p2ZzB5R0E0STZ3YTM0Tkd1eFJQSzl6R004alBo?=
 =?utf-8?B?ckd2blFZdzhzMm9rY1ZEN0U0Yy9LSElubFRpczUxZmNpRU1WUDVIV0ZrcEly?=
 =?utf-8?B?di9QRmZBNFhvWGlPMU9rRTFjbnN2cWlDWnB4bytTRDVYUUdhQUdmL1F2SGZQ?=
 =?utf-8?B?NEVtQ0xIUElhaXZ3T3NNeTI4YXV4MEVlU0c4L09PTFBQaXZWSnMxN05mYlNi?=
 =?utf-8?B?TzBGdzdQNFRzTTB4dVNKTE5BS3E3S2YvNlNFZGVlc3dmUkI0aDV3YVdWdHN3?=
 =?utf-8?B?Rmc4dkdpbFVZZ0c1YkJCb0s5V3hQSzF6WVZzN29kS1NPUEZnSjd4S21JNnhn?=
 =?utf-8?B?cXVjK0daTHJ5UjZocEU0VC9WcUwvVzNQaGorNi9QSUVudnp2ZTJoMmRtUWZn?=
 =?utf-8?B?SlFXYytHbEJYTWZDNk1IU0kxNVdjQ0Q2OVhuRWpTN1hmZHh1eS9tNXZnNVZ1?=
 =?utf-8?B?am9mMFVnakR1NG50MFdaL3FkdnpFOG1pdEdDNVhVdkhiZEtGMjB5d3RiTW9s?=
 =?utf-8?B?QlQxTGptdmw0NEc2Vjh3Z3k1eGJJWURhclR1YVpZOStKMW5KekpmUURVK1pM?=
 =?utf-8?Q?EkLyKYoPaoddgoq0PWKt5Ibm7?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98decfd8-0bf3-4260-da01-08de1553eee2
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8301.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2025 12:25:37.1711
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6xspvAmiaJMS82We7jbnLaxArPM/d7FnAbvTuXvfQlHBMj7s+y9MzpgJgTJN6FbaXujjKD6o6GzBEHOtcA5Biw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6954



On 10/27/2025 4:36 PM, Vlastimil Babka wrote:
> On 10/16/25 19:28, Sean Christopherson wrote:
>> From: Shivank Garg <shivankg@amd.com>
>>
>> Add a dedicated gmem_inode structure and a slab-allocated inode cache for
>> guest memory backing, similar to how shmem handles inodes.
>>
>> This adds the necessary allocation/destruction functions and prepares
>> for upcoming guest_memfd NUMA policy support changes.  Using a dedicated
>> structure will also allow for additional cleanups, e.g. to track flags in
>> gmem_inode instead of i_private.
>>
>> Signed-off-by: Shivank Garg <shivankg@amd.com>
>> Tested-by: Ashish Kalra <ashish.kalra@amd.com>
>> [sean: s/kvm_gmem_inode_info/gmem_inode, name init_once()]
>> Reviewed-by: Ackerley Tng <ackerleytng@google.com>
>> Tested-by: Ackerley Tng <ackerleytng@google.com>
>> Signed-off-by: Sean Christopherson <seanjc@google.com>
> 
> Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
> 
> Some nits below, not critical unless there's resubmit for other reasons:

Hi Vlastimil,

Thank you for the review.

> 
>> @@ -860,13 +917,31 @@ static int kvm_gmem_init_mount(void)
>>  
>>  int kvm_gmem_init(struct module *module)
>>  {
>> +	struct kmem_cache_args args = {
>> +		.align = 0,
> 
> This seems unnecessary as it's implicit.

Ack

>> +		.ctor = kvm_gmem_init_inode_once,
>> +	};
>> +	int ret;
>> +
>>  	kvm_gmem_fops.owner = module;
>> +	kvm_gmem_inode_cachep = kmem_cache_create("kvm_gmem_inode_cache",
>> +						  sizeof(struct gmem_inode),
>> +						  &args, SLAB_ACCOUNT);
>> +	if (!kvm_gmem_inode_cachep)
>> +		return -ENOMEM;
>>  
>> -	return kvm_gmem_init_mount();
>> +	ret = kvm_gmem_init_mount();
>> +	if (ret) {
>> +		kmem_cache_destroy(kvm_gmem_inode_cachep);
>> +		return ret;
>> +	}
>> +	return 0;
>>  }
>>  
>>  void kvm_gmem_exit(void)
>>  {
>>  	kern_unmount(kvm_gmem_mnt);
>>  	kvm_gmem_mnt = NULL;
>> +	rcu_barrier();
> 
> Is it because VFS can do call_rcu() with something that ends up with
> kvm_gmem_free_inode()? Because nothing in this patch does that directly,
> maybe worth a comment?

Yes, exactly. I discovered this race condition while debugging a bug that 
occurred during kvm_amd module unload after running gmem backed VM.

More details here:
https://lore.kernel.org/linux-mm/e7f7703d-fe76-4ab2-bef4-8d4c54da03ad@amd.com


diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 427c0acee9d7..e1f69747fc84 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -969,7 +969,6 @@ static int kvm_gmem_init_mount(void)
 int kvm_gmem_init(struct module *module)
 {
 	struct kmem_cache_args args = {
-		.align = 0,
 		.ctor = kvm_gmem_init_inode_once,
 	};
 	int ret;
@@ -993,6 +992,15 @@ void kvm_gmem_exit(void)
 {
 	kern_unmount(kvm_gmem_mnt);
 	kvm_gmem_mnt = NULL;
+
+	/*
+	 * Wait for all pending RCU callbacks to complete before destroying
+	 * the inode cache. The VFS layer use call_rcu() during inode
+	 * eviction (via evict_inodes() -> destroy_inode() -> call_rcu()),
+	 * which eventually calls kvm_gmem_free_inode().
+	 * We must ensure all such callbacks have finished before
+	 * kmem_cache_destroy() to avoid issues with the kmem cache.
+	 */
 	rcu_barrier();
 	kmem_cache_destroy(kvm_gmem_inode_cachep);
 }


> 
>> +	kmem_cache_destroy(kvm_gmem_inode_cachep);
>>  }
> 


