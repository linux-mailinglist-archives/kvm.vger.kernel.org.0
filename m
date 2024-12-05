Return-Path: <kvm+bounces-33107-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BADC9E4D95
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 07:24:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 925381881223
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 06:24:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5FEF199935;
	Thu,  5 Dec 2024 06:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="3wns42yL"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2075.outbound.protection.outlook.com [40.107.94.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AF2818C33C;
	Thu,  5 Dec 2024 06:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733379844; cv=fail; b=lAD9AOzCK1Qj78PvD3nu2IetzVLDYsDhcsnropMlThGTsvGdIYrfZwuWh9W6rarIcr1g0WJYKFyn5K5M6bKtyxnjSgjVAQLKpqMOpUdM3ZS3PfJ0cU8D8w6TSv4Fm7gSmmUixN9K64UqU6RPk/3ITGgfNfmcMf2xtGIzW1ecbVc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733379844; c=relaxed/simple;
	bh=uRn7NtXglr59JOS1Q6SZ4mq4bol259BFdC29Aw101hk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=uVXj9lTEZtSytS++8oMhK+lI6zrXi7MilmwtmfWNiISM0w3xyMG0SGz65mL0b/v3XHOVWY38glvDNbuwmMUG6ziKaSURCijbK7417Ijh5StYyJdFAKRHZcyn/w2M8AtunCWiEyi3ae4DRnXMn2T67uSnXb+k4Gyw5o3OJcfiSpg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=3wns42yL; arc=fail smtp.client-ip=40.107.94.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RSxMojBURKXBg0kN8G8XCeXpf8E/7NOlXeqJyxDAm/+FUHMi+CHvBeaMJeV7bJS8AX7ZU6Oiiwugfc0XDlo9SwmVn3HRCRTOrXpRX94YWGmSb8h7vTdj49nH/so5bQy9ZifoQNHgmPNy0F7peN3tmC0ky0yjaW/NU76BQrEcToqQocuBQ0XX4IbekFYe4e8o1TCWLEWXABASfvlwLpTyiP0VYHhh1KLT6m7AJupCFkm5vOtRWHKAEWufpQGWlNCARZPdFXxXUoZ17f3Km7Hn6kJubmPBgZDz7ka4sll0RHz5srDCXOx8A2hrSgzDcqPxMb86omcqvS90SUkX9Faq1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZgNkGt9zcv+7Zk1/X908YCSgx5bbWF+RofyjaDJr1yY=;
 b=Psk2V3oS4Evd4s/6hK7Iocf6lEbBxvAbUUXnUgb8UCmtEFVE9nEEgZvCstjSODwGeRRMcWmWhzsN97ZhcfIHZTNkTjfErg4pu6CBh39YmGQHIVYLnE+/e/rnYD506n6tDcmSu1B9ZZdRRi7OQKEMcXzqhP0144xDYxZMIViBG9hZQi2psHQVr7z4iWUqXYWgco0xjI+gh5WdarLbLViEeqxGt2M6+M9Q5mjje7PQnAd2b+1k2xkubqVM0wvcAdFTfTaojCssnfJfgWVe1ZxiUTQLZ7ebzIJ4fbKTtJOXXtFmcfn+HSqh2uOHQymmsF77ce5BVpvA4G9+U/WEsxEazA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZgNkGt9zcv+7Zk1/X908YCSgx5bbWF+RofyjaDJr1yY=;
 b=3wns42yLjlEIdu4cnl4KVbUKExYwSQ3eImhpdDs8dHPovAodLgto/Mv4sQfz3H4wTzB4gm9EbtANAcyvGKlJzpGTKjTVyKDQRM11ZCNEuAanRpvWlSEJna0W34fvXcffNkiPtd7XpR49cYyEHhISkUsfQUR/XHPMH/jwwombym8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN0PR12MB6317.namprd12.prod.outlook.com (2603:10b6:208:3c2::12)
 by DS0PR12MB7996.namprd12.prod.outlook.com (2603:10b6:8:14f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.11; Thu, 5 Dec
 2024 06:24:00 +0000
Received: from MN0PR12MB6317.namprd12.prod.outlook.com
 ([fe80::6946:6aa5:d057:ff4]) by MN0PR12MB6317.namprd12.prod.outlook.com
 ([fe80::6946:6aa5:d057:ff4%3]) with mapi id 15.20.8207.017; Thu, 5 Dec 2024
 06:24:00 +0000
Message-ID: <8965fa19-8a9b-403e-a542-8566f30f3fee@amd.com>
Date: Thu, 5 Dec 2024 11:53:53 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 01/13] x86/sev: Carve out and export SNP guest
 messaging init routines
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
 kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
 pbonzini@redhat.com
References: <20241203090045.942078-1-nikunj@amd.com>
 <20241203090045.942078-2-nikunj@amd.com>
 <20241203141950.GCZ08ThrMOHmDFeaa2@fat_crate.local>
 <fef7abe1-29ce-4818-b8b5-988e5e6a2027@amd.com>
 <20241204200255.GCZ1C1b3krGc_4QOeg@fat_crate.local>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20241204200255.GCZ1C1b3krGc_4QOeg@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0235.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:eb::13) To MN0PR12MB6317.namprd12.prod.outlook.com
 (2603:10b6:208:3c2::12)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR12MB6317:EE_|DS0PR12MB7996:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b4a103c-9054-4c1c-1fa7-08dd14f56825
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dEsyVGRpZHlaYWNKK2JSTXBnZExhL0szY3YxbGNYQjNJRUdoc0NiYW9MVEpi?=
 =?utf-8?B?Y1oxa2JOZ29zdDFYNEZ4cXpxbWN4OHZRNnY5YnB0MmFhVHpzTWpzV1A0ckhC?=
 =?utf-8?B?amJFeHJKYmFHVVBiYnRuQ2dGaTlJalRMS3MvUFhja2dOQlRCdWl5ZCtycCtn?=
 =?utf-8?B?RWtHL0Q1ZkY0QVpVWkorVzlFaUtjVU9YQW9XU0xCYVNrTHo2clovaGU4TmxF?=
 =?utf-8?B?cVdTUVQrV0U0S0wxUzZETlVPaERxL3c0N05mcG1tOXhoWjFMN1kzMWppSmRi?=
 =?utf-8?B?cnZMOHJMdUxuVktBVzJFWXFLMmhzYlJiQzBMZ2pnWHBIbXRpS2kyZldEdmEz?=
 =?utf-8?B?UnAwakpwUHpZWSt1V1VJVnM1T1pYRW5UOVVSWE9MdU1CVVV0U3ZmYm0xQzhr?=
 =?utf-8?B?Q2xUdERjNk5kanlrcU1QRGZzcHNjdTFJTkpDRVd2MTluM0VQR1UvZjM0VXg4?=
 =?utf-8?B?aEZRTURWR3U5UG1heFFVaG8yR0Zka0VER00xZHB3L3BUTitkR01jUHJKMmpF?=
 =?utf-8?B?cGoxOWdQSW9aNmpBaEFqcHBlM0kybEdWTnVtbDdxQnFoZkF4MVhHeU1yQ0dN?=
 =?utf-8?B?MmU1MVVkakNOV2RwRnBQbjJoa3daQnNrYzJEYjZTbXBNVTYvQnhzOWs5QXI1?=
 =?utf-8?B?WFlKTTJOcWN5M29kRC9oN2k3cWZMQWhaN3paT1hxU3JrOUVuMDdSTUdubkRL?=
 =?utf-8?B?b1c4MFhoZk9KMXhWQ0xxcitGQUxrcEtSamhKOWQ3VzNqdHNlZlVvWFhiUU9l?=
 =?utf-8?B?aitMYVYrWDJZaXU5Q1NpOGZrZGh1a1ptQnNEWlJ3enA3akVTZVlMNG5JaFF6?=
 =?utf-8?B?VjhsSFRqNlFrRERqN1lkMkZteVhQaWY1S1dlcjZyNTh0QVpOQ3IxLzFmYWh5?=
 =?utf-8?B?UzNDUkV2eHo2WktlcisrR0d2MEVOWHFYaHB6RUNoUXRDRzZTY3RDamVEU1My?=
 =?utf-8?B?cVh3UHlQMkFnQXFpandXS2RUbEIxQm5uRGhHSkM0Rit5MHVzSld1bHIxcnpE?=
 =?utf-8?B?M3hYRVJ6Ym9OekJySlF2VGMyb3BCS1BaaXJMTGhWdlhESGFERTEwNEhTL2x4?=
 =?utf-8?B?d1M5VjdHUllSczg3eUtSM1ZIQWUvUi9Xb0dOcHRHZGh0ZFZxb25nRHE0SzNW?=
 =?utf-8?B?a3pVLzc3T0p1dXZEQlRDSnVCTFpYdGtNWkNjeVRzV3hLckExMUdNVmRLekgw?=
 =?utf-8?B?emE4NTlWV3NyYkpweXpKbGZRZXFCdGs0TmNwcTRwQU4rZjBVdUlQQkZCOGdL?=
 =?utf-8?B?bm83UzBHL0lpUEhydk56YmtuMzNOVGplL0VxYW0vempHN3F6V2YrbXFUL093?=
 =?utf-8?B?SEd5cHkxNXRwTklMSlRHdm5Xd0lmOEZRVGhkWnRUTDdtSjQwaDBrV3BRbVJU?=
 =?utf-8?B?RGNVTVo1UXk2VnBrdVdMTGUrQ0tyRlc2c1NFOG85cHhmakdkYU9OYkptcEdx?=
 =?utf-8?B?YmxaUTcrWnpxeWRmTFNBZVZNMjBvTFphalNaR1ozSWxNWVN1QWFjL0ZNOUx3?=
 =?utf-8?B?cDZxQzU3L3NNcHVCMy9XWWY2eG1WZ1FSUTNwcG11ZGRLYkxETnNtajdHa09k?=
 =?utf-8?B?RXpjdU1zOStSTjlHZkJwVVhEYVpySUEyQXV2OWMyYTZZMzNkZEZkOTdlT2Rw?=
 =?utf-8?B?QzFpOTVDdEJ4cHNLK01Qc2dxZTdKWXp2bkl2d2Izclk1eStxbkRrekN0c0Jl?=
 =?utf-8?B?QjZwRmh1aDNrcFlTMWk0YW0vVTFhWEFxMlpaWUUzNytWbVBZbE84QW83V0JN?=
 =?utf-8?B?bXkyeHZ2VUU1eHhNOStRSDdabFdQVktFMlBzd0kxVmhJTHlXdlVKeTUwZ292?=
 =?utf-8?B?b3RmYXBUZHNtY0d6UlNHQT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6317.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?V2Y0a0JLS0VaNWtmd1E5T3VlNFZmSnVQT2dpUTVBS0o4dDRMbjhtRk9RSEhB?=
 =?utf-8?B?RWJIR1IwTkpBR2xHSi9TVjhNa2x1SzNyMXNJdkg3MmNJaWhWVnBxbGMvSTY4?=
 =?utf-8?B?S09rTlFpY0Z4WVJUOFN6anpSWXhsbVI4Y1M4ZjBGSnFrZXRmR0Y4bS9qS0N5?=
 =?utf-8?B?a1RMWCtkaUpzZUlueklXZDdSSWVBTVByb2NxRktIZjFOVHd2OW8vMmFQS1VD?=
 =?utf-8?B?YzdZdEw1Q3dkcGhUY3ZiL1lyZ2NRQ01wcWE4RnlESEdmdEFHb0JMZTkzbG01?=
 =?utf-8?B?SjdCNWdBcFNKWEtUelpYQUlCcnAvaEtpOTdyazNWNFpabThldStUaythd2VT?=
 =?utf-8?B?VkozZFIzcUw5eVRUMjYwWlcyZzZGY21qTy96Qng5RlU4VXY3QkJSTklsdm1x?=
 =?utf-8?B?cjRodlErZ24rWEwrd05HdXFKb29IS1QxSWQyY25UU0xDOXlpc0RuN1JHT3JC?=
 =?utf-8?B?VVlYZjJZS29CTnliT1R4bUNiYlVhcG5nQjMvajQwQnJEUjRITHdoeTZmVWZi?=
 =?utf-8?B?c2tRVDdlZFQ1NFRnendaUUtFd3N2V0l2VDNmVTVyTTk3RmdubjE5bkRoZm5n?=
 =?utf-8?B?WmZ6bHVWVGVaNGVJYU5EWE5ZMGhnSU4rUlJJcGVJdmNVWnJyc3RpdGlidHd0?=
 =?utf-8?B?SHZqRW5NbFlhclBVWklBeHZVbTFkTnk1ak1hSFo5SEcvWDg1dW84bjE5aytx?=
 =?utf-8?B?UEFDMkM5eGNHbmp6VmlhZ2RIOXUxVFJLVlMwenhtRURJNC9vVitsN1I2SitS?=
 =?utf-8?B?RjdEczJZVzYyeTk1OXVoSnY2SlBSOExKT1Y2UzV1cUNSVzZaMTJiY2tjdlVm?=
 =?utf-8?B?VFloNEp3dnVZbFBxamZwdjZneGVGK3BycFhEcHRtYU5LM2ExOFhZWDlhZUpq?=
 =?utf-8?B?cGVoYjFHZHNCTVVGNVNsZzF4QjdSbkRBMTMvUGxVa3pJcU9ZbkZSdCtTSng3?=
 =?utf-8?B?Zjg0UW1FemRkYWZEVDRPbXVYWnduNU8wRnlmUHRHT0ljSmZ0WEpYRDdjODl3?=
 =?utf-8?B?VVZ4RmFDbTVzenlqaWpQeTRLVGFUa3BxMVlJMVYwN2c1Y0tmd0pYMlgwenZO?=
 =?utf-8?B?cnFqN2hjQWtOMmtPdHp6SzhOZkFLdUlWVEpzQW1RZS9TeXRtU1ZrZUhYcjhB?=
 =?utf-8?B?UGNSVjB0ZWVVdDFVcTlZMTgzdEJNbU9SWFZsK0dnTDNGVHkyTGhHbE5FR2pm?=
 =?utf-8?B?TUxqekc1dlVnU0JYaWx3cjExamNtM2w1c2NBcEZoTGlpbVIxUmRpZmpyZGg1?=
 =?utf-8?B?VVBSTElNVDljKzE1UjVGeHNGckhaUG9tZStFWENSWXMxTmU5V24vSDhWQWFL?=
 =?utf-8?B?NWk4QWxPV01EK05lS052MUhKKzVoZllkOE1wYkRlZFV1YmZYM1NQMzFQUkRT?=
 =?utf-8?B?cGh3ellJUHowN01rUFcyWktqUmRicXRPdjcwQllSaW5JdHEzUUlsbFgzVXBX?=
 =?utf-8?B?ckpBem5jenNBclVPNmRnSEJjYUlxRFA2VklVUlFWdlg5MHVHRE81NTNyVVZo?=
 =?utf-8?B?MDNFM1VOOTdjOGE4YTBSMWI2OUtxTWhReXU0QnFqRlY1RmcvYmtmU1cyMVBj?=
 =?utf-8?B?Y0JCOTBtVXVTMXhEclRPVVRpK2kxc2h0UnVJMHdUaVU2ci9IUDdHQ0MxaWx4?=
 =?utf-8?B?L015Z2hFNG1neEVYMDc4QWxUeFpwdUZISlovVzJKekxrNWxxdG1jR2xjWkEz?=
 =?utf-8?B?TlBEalRFcG1jQTZsdHpROFREMUtCSDVVdWlFMW9iVjl4V21xVlI3UkRKMjFM?=
 =?utf-8?B?Vm41OStjN09ReVBkRGxYcnFTeWNEZmhHYkVUZUZPSnBad3krbU5xSUpJR1Vr?=
 =?utf-8?B?SzhZOGVtYlRJeTg5elMyTTRralFTSTNUMi91ZWdJamFzVDFBbGRJd0Z1WVlr?=
 =?utf-8?B?RkQyZmc2Z1ExQ0V4OVpGNGdFbUREWk0vdmQyZHlUdi9EMjJ0cUI2ZjRwSnpU?=
 =?utf-8?B?UHFDNzdyVHVQaC9vYkZQendYL2R4YmY4bUJXQmp5YnRqVHhWWjVtS1A4SFd1?=
 =?utf-8?B?QzE3ajhaMlRoMlRXZHM1UW9UbGlYOTRjODB6QjV6Yy80OHVVWUdEWTRGZWhL?=
 =?utf-8?B?Q2FpOVQvQlJnRWpGMVpZSnlhMWxmeDFnNTM0ejVRYlpMcGxBd0hwejcrR0Vv?=
 =?utf-8?Q?v3HxxQaAoUi4045ckwdcIUJo7?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b4a103c-9054-4c1c-1fa7-08dd14f56825
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6317.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2024 06:24:00.6531
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7AvXHNvzX2EMCnLHkUzBXPxgV9B8wzcxQdhPSnSLujlIVfMwiLU9ye0hKBJ6ymZ9FkdUvfc85ekMRWrpBXqYKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7996

On 12/5/2024 1:32 AM, Borislav Petkov wrote:
> On Wed, Dec 04, 2024 at 03:30:13PM +0530, Nikunj A. Dadhania wrote:
>> The above ones I have retained old code.
> 
> Right.
> 
>> GFP_KERNEL_ACCOUNT allocation are accounted in kmemcg and the below note from[1]
>> ----------------------------------------------------------------------------
>> Untrusted allocations triggered from userspace should be a subject of kmem
>> accounting and must have __GFP_ACCOUNT bit set. There is the handy
>> GFP_KERNEL_ACCOUNT shortcut for GFP_KERNEL allocations that should be accounted.
>> ----------------------------------------------------------------------------
> 
> Interesting.
> 
>> For mdesc, I had kept it similar to snp_dev allocation, that is why it is 
>> having GFP_KERNEL.
>>
>>         snp_dev = devm_kzalloc(&pdev->dev, sizeof(struct snp_guest_dev), GFP_KERNEL);
>>         if (!snp_dev)
>> -               goto e_unmap;
>> -
>> -       mdesc = devm_kzalloc(&pdev->dev, sizeof(struct snp_msg_desc), GFP_KERNEL);
>>
>> Let me know if mdesc allocation need to be GFP_KERNEL_ACCOUNT.
> 
> Let's audit that thing:
> 
> * snp_init_crypto - not really untrusted allocation. It is on the driver probe
> path.
> 
> * get_report - I don't think so:
> 
>         /*      
>          * The intermediate response buffer is used while decrypting the
>          * response payload. Make sure that it has enough space to cover the
>          * authtag.
>          */
>         resp_len = sizeof(report_resp->data) + mdesc->ctx->authsize;
>         report_resp = kzalloc(resp_len, GFP_KERNEL_ACCOUNT);
> 
> That resp_len is limited and that's on the guest_ioctl path which cannot
> happen concurrently?

It is a trusted allocation, but should it be accounted as it is part of
the userspace ioctl path ?

> 
> * get_ext_report - ditto
> 
> * alloc_shared_pages - all the allocations are limited but I guess that could
> remain _ACCOUNT as a measure for future robustness.

Ok.

> And that was it.
> 
> So AFAICT, only one use case is semi-valid.
> 
> So maybe we should convert those remaining ones to boring GFP_KERNEL...
> 

Sure, let me add this as a pre-patch.

Regards,
Nikunj

