Return-Path: <kvm+bounces-57761-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ED973B59EC1
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 19:04:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D16B7583898
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 17:02:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FD60313D6B;
	Tue, 16 Sep 2025 17:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="00RFeLYP"
X-Original-To: kvm@vger.kernel.org
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012001.outbound.protection.outlook.com [40.107.200.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6C3D2EA14E;
	Tue, 16 Sep 2025 17:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758042023; cv=fail; b=DziwT1xkfO57ObgpnKVkySQ5v/L2dx+M+i83N+TC1zlU+pXgQO6tITJeUual1e4x3JZ+pH3MBDgBEhBG+J7kDz+AkdJWHZ7+LkpDQpZ0GODu5lCWfmvKzWTsmxZzyC6kVt1tYXJzjeNgQLJ272/Q2jGaRdvm/SeJDy6WQX/dBdA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758042023; c=relaxed/simple;
	bh=eMQ0GGTCG34ghU3nnWIYJ3aocsPugND7zQzaa0TkZW8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=UdOfkTigxTWhEt7rStf8YFd0rN++q9MkyQKz/w3UntErsIpeEycC5C0f0yMTZkfiNqILZBSDpbvSad81BQcVPI2qBFxwyT0/zsduKJ97GwAd/pHzALIIoMTUFo0R+tZGsoZYEmirodwsaqYKzp6up/6GJWEA8ziPsauFol2b2zA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=00RFeLYP; arc=fail smtp.client-ip=40.107.200.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DluI7QCtZXNHICt1KdMyIBM21i7LueHms9Tb14EbAlZNaQmj0LQiyM+aayNCAHOMpUiIrjEQdM++cPiv4SZ0t0jK6axs8b/tvbolGj8Pk5a8TeMCfxvSZJ4oxLhw3DhJNizzlIyekxBBIEY8C5kdaDRLK+qhnr0qKKXaSQhgvVsufyvKfV/gZ7+LeQMGWnqCUy1gzEYTZuQu9q29HQZ0ekRVpPW89EbOr9fFjlOrFt/SN8OCt1H3gCvHNSRcofoqZRHMBfVw/g4o6rMN4Pt/cM0rSo9DoDzGMhmJL0YAPI7t/g1Bin1kM1Hh4oMWHm7VdWM1O53fDPmGfG1jWiupfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e+a/GigxunrtI4ye1O9xa7y+2+4q6mL0AKpmWQDp5hc=;
 b=V3YlNmbdmzGpe7syutUkpLdsEJTOWEln6q4acGj5u+jn1f5hfFQnyZl6AFWBLx88txm1Y2PF+B1m4dIPmnVvVPtEE945A9N6Dl+Y9B7FOZ0rZz24wNHtiNOxXSeLdTNrdNTIlpm/O88OQw2Ky25LwiiJX09KHCnv6l18qpiG2mIHrTmErgD3VUK3tY4MyUIRsU3CUkVS7rYUtB+SH5O2u2uUJ6vnjB9v63hnCxFPpUeP78Qn/WMENCPDh49u9EEYfcnWzOqBA3OOMYl19ZW0CtkZaVXG+ni414To2G/F19zygow++nnYbaCKCIO+n+uEjWvffkcBbY+IO8vuk5l++g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e+a/GigxunrtI4ye1O9xa7y+2+4q6mL0AKpmWQDp5hc=;
 b=00RFeLYPVcqbzk5EpcLnFNnLspJsWsdReSLO82TbYUFAZZQrDwmMA85+mRxbMKBjwSuZ6hKtNc/xSIExA5u5umnTUH9ECK2BsHy0RlYhuaWEuzmqjQqWQJqLiMFB/y++OkZN0TiH45rzvYRseGTkXsrV7h76TAbKT+LwpObefd8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc) by BL3PR12MB6593.namprd12.prod.outlook.com
 (2603:10b6:208:38c::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.22; Tue, 16 Sep
 2025 17:00:14 +0000
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::8d61:56ca:a8ea:b2eb]) by IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::8d61:56ca:a8ea:b2eb%8]) with mapi id 15.20.9115.018; Tue, 16 Sep 2025
 17:00:14 +0000
Message-ID: <be1db2e1-b6e2-425c-81b0-00c8227b298d@amd.com>
Date: Tue, 16 Sep 2025 12:00:10 -0500
User-Agent: Mozilla Thunderbird
Reply-To: babu.moger@amd.com
Subject: Re: [PATCH v18 00/33] x86,fs/resctrl: Support AMD Assignable
 Bandwidth Monitoring Counters (ABMC)
To: Reinette Chatre <reinette.chatre@intel.com>,
 Borislav Petkov <bp@alien8.de>
Cc: corbet@lwn.net, tony.luck@intel.com, Dave.Martin@arm.com,
 james.morse@arm.com, tglx@linutronix.de, mingo@redhat.com,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, kas@kernel.org,
 rick.p.edgecombe@intel.com, akpm@linux-foundation.org, paulmck@kernel.org,
 frederic@kernel.org, pmladek@suse.com, rostedt@goodmis.org, kees@kernel.org,
 arnd@arndb.de, fvdl@google.com, seanjc@google.com, thomas.lendacky@amd.com,
 pawan.kumar.gupta@linux.intel.com, perry.yuan@amd.com,
 manali.shukla@amd.com, sohil.mehta@intel.com, xin@zytor.com,
 Neeraj.Upadhyay@amd.com, peterz@infradead.org, tiala@microsoft.com,
 mario.limonciello@amd.com, dapeng1.mi@linux.intel.com, michael.roth@amd.com,
 chang.seok.bae@intel.com, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev,
 kvm@vger.kernel.org, peternewman@google.com, eranian@google.com,
 gautham.shenoy@amd.com
References: <cover.1757108044.git.babu.moger@amd.com>
 <20250915112510.GAaMf3lkd6Y1E_Oszg@fat_crate.local>
 <b56757b8-3055-455d-b31b-28094dd46231@intel.com>
Content-Language: en-US
From: "Moger, Babu" <babu.moger@amd.com>
In-Reply-To: <b56757b8-3055-455d-b31b-28094dd46231@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA0PR11CA0036.namprd11.prod.outlook.com
 (2603:10b6:806:d0::11) To IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PPF9A76BB3A6:EE_|BL3PR12MB6593:EE_
X-MS-Office365-Filtering-Correlation-Id: 80c1af16-6420-4727-a784-08ddf542813f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NVlVNi94R0tvQ21DV3pMOEZUYjVIZUJQZEFKRWs4SGh1QWpnKzdqZUZ1WTR2?=
 =?utf-8?B?WGRRTEsreGZlMDNIaFlJQWpQNWVrV1gzWlM3c0lJZGpCNm9kWlFlMDduQ0NT?=
 =?utf-8?B?b05mZTUyQjVOY2tPQkY0NTRwNklZWUJHdGpDRkRlNGhKMlBzeHJpMEhBcDdk?=
 =?utf-8?B?eUFwOGR4cFMrL2Vab2ZSRTg5MHovMm42VlM3Znl6SDl6ZDdwQkhwTUtKWTBC?=
 =?utf-8?B?eEdSMFVGekpXQ0EvOEZxcFg2RUpJRTNZL0NpSitCbisvZVJ3Sit6QmFPSjZL?=
 =?utf-8?B?TjBFTUY5NU1qZk53KzcwdWFhdXZ2ZXcvUGtFc3FxOUtjUmpDbVBNMGxaZDd3?=
 =?utf-8?B?Q1BucVNHQ09PSDM1elJmKy9UWHQwM3VPUXd4UlprOGpzakFpOS9ndTlNYUxK?=
 =?utf-8?B?cnI4ZWhLaEJ1aWw1dUF4dEFNWHlFeTZuU3BWdEhXcFpydVVJYkI0VXJTcjgx?=
 =?utf-8?B?SWc3Z1JSRUFvVFpIZE1GZkJHMkdkNEViazJ4L1pGem5ScEFUZ3pSNzdvOVFx?=
 =?utf-8?B?SnNQSjhhbnQwa2NFQ3JTVVNWYmJqNW9EdDYvczlOOXo0MjhteXBSbkEybGR4?=
 =?utf-8?B?R1NVbVNZb1FoNXhqSzlwV2ptZGRKaXhqTmc3enBSeDJ5L3JpbHh1Nk51NEdV?=
 =?utf-8?B?R2JRa3dqbW55NTNQNDUyR0xCSTBhcmI5ZmVYMUJJMUl5TUtmL1V3RXhuclVM?=
 =?utf-8?B?TjN4TXNFQUQ0cktVL0p1T2pIUDdpVU5Zak5oOXRkN1FQbGZOVnFRWEdzTitO?=
 =?utf-8?B?ZGhRNTY4MDRsUjdyZmx1UFhISzNZaFhiTngyU2NSU0hkZGc1dWZKRDlMcXF5?=
 =?utf-8?B?T0dFRUNpMEFsem16cXRWclVzdHBzcVArRXdqZGdsMXNjZmpsTkNDQjllaVVD?=
 =?utf-8?B?Mit0aFcwZzlMcXNtMTlnSHdhWmlVL2tZOGRuS1dJcjBVajFRZERKc3FET0Ir?=
 =?utf-8?B?RjBYNFZOYXJYRGJtZjUyVVZOYTdzUWdaeTRtbGZSVXpaSUNBUFcxZVhKTXNx?=
 =?utf-8?B?OVJRSVFpaGNRMzR1UGZVRFNqL1JpNS9Xcnk3Y0VMQitQN1gzT1FRL3ZTa2t6?=
 =?utf-8?B?UDdOZVdQbXAxUm9WMitYalVKSlpaNkVnL2RwQ3E5YU85U1pGLzFuTHRKSytH?=
 =?utf-8?B?L2JsWWRMMnNLNVpjankvQkNmSXNZUW1jdVIzVUd5ZDVuV3NLTEthNTdoTWJo?=
 =?utf-8?B?bXNURklaSmduWmprSnAvdGl0TjI1Y1hBUG5xeFVGR3hMQ0NDWjBTWDNVUlR2?=
 =?utf-8?B?WGVRcGhHOTd0Uk9jNTUrVStnZHVSMGlSb3M2S3NiWk1pNk9BL3hEajdLTHVV?=
 =?utf-8?B?cmJlMCt3UUh0aXNBalVQWmNUc2sxVkx0SmtvNHcvVkVsNU0xQ2hJWXpnWUtO?=
 =?utf-8?B?aDJnN3Jqbzd3QWVFcTEycVFZaUloZHhqb0JCU25DUlJlaGFaZVUvN3Ywb1JO?=
 =?utf-8?B?QSs3MURGNk9aOUdPTE15WnV2dk4zUUFPWjkzZGZNY3h4WmQ5ZTEzaHQwZHgx?=
 =?utf-8?B?NkdUZnN4M1IyWDU5VXpyMGJoM05UbEZWUllSVWhCTXhnMWdPQURGcTR1SFdp?=
 =?utf-8?B?ajJMYXhMV2p5U3FGV3ZXT2lPZXJicVZLOU5ZR0YwWngwSERRQW9PV2tyb2FB?=
 =?utf-8?B?eFNMYVIyeU1pMWZqSUp0MlpMZzJRdFhzalQ4ajllcGVsVUdHTXhnU1MrQ1ds?=
 =?utf-8?B?a05CQXpDT2hVblpoNm5ZOEZPQUlWUzhXUmdBb080KzNERk9HZEZXUTFqYnVN?=
 =?utf-8?B?QVVUWk5yc0xwTUVxQXA4ZGRpYzV5M2ZxcytGU0w0bFpmQkVldHRoT013N2R2?=
 =?utf-8?B?eFNLcm9oaWhMRkdjNzRqU0lCQ0hRQWJXME9pc0FibEtEYlNKN09VSEIxMklW?=
 =?utf-8?B?b0wyditldkJCKzNURWhZRE9nYWN3L3ppTk9zMEtLaCtwWUxBVjlBMVBZMW9i?=
 =?utf-8?Q?QkizgE2Cqbk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PPF9A76BB3A6.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UjB2Rk5BTUhnY3ExdmhvR2xVQm1OZnZKaUhCcmlmR2E0OFl2S2NDV0JVQkxI?=
 =?utf-8?B?eVZaNC9mNU9aQkd0RzV2cEwxRGh4N2ZDTVpvQUJRTGNQdWxlRkFqYmZTMkda?=
 =?utf-8?B?RjRpRXNqWGNVNThIMkEzQTR4RTU2VTd4S01xZHVwajM0YmY4Uy93bTBpTTJm?=
 =?utf-8?B?b2hXWFdqNUo4V2V6NE1la1pVai82NzdtTHNUQWI3WlNpbGNJN1c4dkdGdlpQ?=
 =?utf-8?B?Sk1wKzZGcEJBaHh2ckRaNUh5aElkQVF1L0JzNC9KS1h1WmZUUkFLazFEamRO?=
 =?utf-8?B?b0ZpRkY0R0I5aVl0REZ3WXE0VCtRR0pmb1hseW9xd0JySkxOREtjUlc4OGlx?=
 =?utf-8?B?VFliMHRRa0M3U3ZweUxVL3ZkL0ZKUW1MTWFSOUErOUlBZ2p6eE5EZEw0OFdh?=
 =?utf-8?B?VDk1Q3JudkxITGtSZVU3T2xUdHNzNjFLVlJHUlpLdVlQMWFZaUt4alMvVVo4?=
 =?utf-8?B?alVic3BnSWhjQWZJWFByN0t0b1pXSUtzMzhwdjhxbU5xazYxemNBdXkvMWxl?=
 =?utf-8?B?YllJeU9Yb01halc3MEtyS0grWmRZM3RMdFN3K3FBMUFQSVNXVUdORVcwd3V3?=
 =?utf-8?B?aFNrVHRNcHFqcG5za1dtbEd4eFlYZDlwTHh5V01oUFRKdVk4d3ZNOW1tYlBZ?=
 =?utf-8?B?aTFlNVFaNVJ6ZHhVNWN2T3QrZkh1WXlaUXVjMnpsSFRuY0VKelhuNCtBSnRQ?=
 =?utf-8?B?RUdnWmpXZ0JZSXlZMVFXem9hSjZsUHdwRk1RcG1jVjhwbzZCekphcFBwVksy?=
 =?utf-8?B?MXByVTlQT09KUWx4SHJvckMrR1pTV0phUW5Fb0ZGbFcyUWNGUDc1RitEOGNS?=
 =?utf-8?B?RUtsQlZWQUdyRmZMdmJCa1UwbmxudHRzOTZWQzFLRUE3WEoxaEdPQ0dtZFZF?=
 =?utf-8?B?SExmQnZkUyt4Z3c4NFZGTUdzdXpSMUZxZ2xaRnNZRnJKVFpZb1E2d0tQK2lz?=
 =?utf-8?B?QjMvaUp0aWkvL0dtSFJEU3dCOE9mRStoQzFUWU93WGw2VWtiS2VGQmoyUGJS?=
 =?utf-8?B?b0gxS1piNzFNS05xTE11RXhoM05WbndPZzFnWERLNGpqeWREQ3NSSjNmZk4y?=
 =?utf-8?B?UXlESjVEVDVOMXRvQ2xNUnh2T2RLb2hSelFrTmlUV0RPMi9WMlZwV3RQT3Ux?=
 =?utf-8?B?cWZBdThJRUJNMmRQbjhKSndGN09LbmZiRHViN2d0bndQTFgybkVBL3lwNmVX?=
 =?utf-8?B?ZjlVaGVuNkFIZHlYVEVZWkhUSVRpdVpTOFdVQ29od1lZemo0SGZWOUZ1TEZv?=
 =?utf-8?B?eC9qKzNvUU1XZWRCWkhlK1hyclVNcFR5VFRpS3RRSHpmTUJWdGNIajBkbUlk?=
 =?utf-8?B?VVo2YzdzL0k4ZHJBM2NraFplR3FQSTBwa0pnRnpYYm5OUU4vVEZzazlvUkV3?=
 =?utf-8?B?bDJCNlQwcEg5WnRScjJlV0VqdG5jR1czWGpqZXFBZGVKWVFFS1FhSHg4MlFY?=
 =?utf-8?B?Umk5ckNFZ1lGOGxqV0JYS0ZSakZKaUgzdnJUeW5hQmJHS2MyZnFpZFBOZExN?=
 =?utf-8?B?WjZuN0hLR0lBTjMyTFBzUWo2Z21lNnljSzltUWs1TmZhekJIZ2U2TTNJaHBU?=
 =?utf-8?B?bTZmWHZqUlhRcnJUU05uazFna1dEaFdUUVFGaXhPTFd5aGI4T0l2T0NoSnhG?=
 =?utf-8?B?b1hQUU1hRlpOM2k3ZjJyWVRXaEM3dURsUlB2YjVGQ3kxUTF6MDVDbGUyQ1By?=
 =?utf-8?B?d2tURFNmN0hwL1BTbEpodGQxQmFHeFlWZjZ4UWQvZlh3VE1zcktKUmVtK3RT?=
 =?utf-8?B?TXBPWVoxZlJlaDkzR3FtRkhHS1JCS0dxbFJCVlNMOURUYy9GaUtkZEJuL2hn?=
 =?utf-8?B?TDhDRC9NeTgrZDM2RU9yUFpuc1M4cnpFTmpCajByazYwczJHSThOTkpJTVpQ?=
 =?utf-8?B?d0xpMzk4K0g5RmhmakpqR3hDZVpKTWZZU09yN3ppNnJ6cnR4V290UVFpV21i?=
 =?utf-8?B?ZlhUNlNOdWhkQmJNRDJyVDkySXRDdi9MWkY0SUNjOCsrelpQVzRJQmpQcEMv?=
 =?utf-8?B?bWtDSkNjbHpwazlQOE81S05yZVZRYUMwQ0JMRks0M0dOWTJmNTJIa3FNNDlu?=
 =?utf-8?B?dlZ5c0ZJU2N5cUdBY012V3BqSk9KUUxwdUw4NlY4a2FBcFZBYXFqc29RdnMy?=
 =?utf-8?Q?U5r8=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80c1af16-6420-4727-a784-08ddf542813f
X-MS-Exchange-CrossTenant-AuthSource: IA0PPF9A76BB3A6.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2025 17:00:14.3760
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 50SgQXHP7Ex5KxdScIDNRxr+2LH7gSWIeeVys6Lj/wIEexGCmhfsYAXzxr+lZuPA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6593

Hi Boris/Reinette,

On 9/15/25 16:07, Reinette Chatre wrote:
> Hi Boris,
> 
> On 9/15/25 4:25 AM, Borislav Petkov wrote:
>> On Fri, Sep 05, 2025 at 04:33:59PM -0500, Babu Moger wrote:
>>>  .../admin-guide/kernel-parameters.txt         |    2 +-
>>>  Documentation/filesystems/resctrl.rst         |  325 ++++++
>>>  MAINTAINERS                                   |    1 +
>>>  arch/x86/include/asm/cpufeatures.h            |    1 +
>>>  arch/x86/include/asm/msr-index.h              |    2 +
>>>  arch/x86/include/asm/resctrl.h                |   16 -
>>>  arch/x86/kernel/cpu/resctrl/core.c            |   81 +-
>>>  arch/x86/kernel/cpu/resctrl/internal.h        |   56 +-
>>>  arch/x86/kernel/cpu/resctrl/monitor.c         |  248 +++-
>>>  arch/x86/kernel/cpu/scattered.c               |    1 +
>>>  fs/resctrl/ctrlmondata.c                      |   26 +-
>>>  fs/resctrl/internal.h                         |   58 +-
>>>  fs/resctrl/monitor.c                          | 1008 ++++++++++++++++-
>>>  fs/resctrl/rdtgroup.c                         |  252 ++++-
>>>  include/linux/resctrl.h                       |  148 ++-
>>>  include/linux/resctrl_types.h                 |   18 +-
>>>  16 files changed, 2019 insertions(+), 224 deletions(-)
>>
>> Ok, I've rebased and pushed out the pile into tip:x86/cache.
>>
>> Please run it one more time to make sure all is good.
> 
> Thank you very much.
> 
> I successfully completed as much testing as I can do without the hardware that has
> the feature. Will leave the actual feature sanity check to Babu.

I’ve completed the overnight test runs, and everything is working as expected.

However, I discovered an issue with automatic counter assignment that I
introduced during the v17 → v18 rebase. This is my bad. The automatic
merge mistakenly placed the code snippet in rdtgroup_unassign_cntrs()
instead of under mbm_assign_on_mkdir.

Here is the patch snippet. Will send the fix patch separately.

 diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index 50c24460d992..4076336fbba6 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -1200,7 +1200,8 @@ void rdtgroup_assign_cntrs(struct rdtgroup *rdtgrp)
 {
 	struct rdt_resource *r = resctrl_arch_get_resource(RDT_RESOURCE_L3);

-	if (!r->mon_capable || !resctrl_arch_mbm_cntr_assign_enabled(r))
+	if (!r->mon_capable || !resctrl_arch_mbm_cntr_assign_enabled(r) ||
+	    !r->mon.mbm_assign_on_mkdir)
 		return;

 	if (resctrl_is_mon_event_enabled(QOS_L3_MBM_TOTAL_EVENT_ID))
@@ -1258,8 +1259,7 @@ void rdtgroup_unassign_cntrs(struct rdtgroup *rdtgrp)
 {
 	struct rdt_resource *r = resctrl_arch_get_resource(RDT_RESOURCE_L3);

-	if (!r->mon_capable || !resctrl_arch_mbm_cntr_assign_enabled(r) ||
-	    !r->mon.mbm_assign_on_mkdir)
+	if (!r->mon_capable || !resctrl_arch_mbm_cntr_assign_enabled(r))
 		return;

 	if (resctrl_is_mon_event_enabled(QOS_L3_MBM_TOTAL_EVENT_ID))
-- 
2.34.1

-- 
Thanks
Babu Moger


