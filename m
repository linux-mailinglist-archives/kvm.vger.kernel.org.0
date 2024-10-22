Return-Path: <kvm+bounces-29327-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A7609A977F
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 06:12:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7DB101C2167D
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 04:12:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62A95824AF;
	Tue, 22 Oct 2024 04:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="CDeQJyCC"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2050.outbound.protection.outlook.com [40.107.223.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05E3C819;
	Tue, 22 Oct 2024 04:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729570358; cv=fail; b=nPVnLHySpvKwRQsf4nmxS8W8ljPMPg5WewSBrTwq0nDN3D6ALnI1xbrTCt675wryW+gSuJg1WNcA0n/cZnRbunCDOrLfhxH22b8MQM9qvbAD4IU+iP9NJ8niAtxmhXuv8wh1sf1t3AetkxrhZem7zYvk6OOmSG59WjJHvAyhjHw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729570358; c=relaxed/simple;
	bh=gBntMdWysATfoBQWKQHSZ+L2aSUXRgt0HicNBkVkl7w=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=a1chJiU5QUFhtNeI6Nh5CjH9nltmhFspa6gFRbP2MDYuqqkChkFbJEbHQrv5RXrYQZBjBt56Lx3wK10OfbDBNvhb0jllKATFsnIg70/DYTxvn5el1Nr/ERuTPvl9ltszFWKdqWm/ZLBK7H0BcMjSP7mwFnWdYSkrH0M5ppFoClE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=CDeQJyCC; arc=fail smtp.client-ip=40.107.223.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fkvpdcwrp6c5NDgeaqo/2tJmUy/GwFId/zVMBodQ3qPSb5e1dkfkTS1ZvoWPdddV0HwqxvhRRpdVO2DP8EUz7+aRB9BgUwi9Tvk1Y4h7PKBLX5UmW2VOn+YqxiMixNAnXZ5a6e7e/yKQ2lnZUu76+4uql7XZkoJa0b26srAno08v4NoMVES9ACIrxtrfBTbvkKKH1kxmkTmVih/QZkpYDY1sJXmwaTcB553FtLk1C1idKPu25bzh9i9xJ2GpKC9jE0FffcegZXsfKNE9QyMUlBRNhLQQkEr/Kk4mZJdtORd6F6ppQZAivrcnKuFuNX2B6+P41nOpwpkm1bDjP85+iA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bH2V/ltbOydoJJzmmZozva/IkYWTEDkPL6IP/GFusu4=;
 b=pnOSyg/qo2j4ptPBhcVAhHJuaUTK5S6PqiSvxFnzgP2zPLZArYQ23GKMDKPgon7U0As3jxmdT+64V7S2wW4dBx65ce+AhHhCXhTbtOyin4/hNqhRyOAz8727cuXHzyW1trmaGysErtuXy4N29z40IcfGLm9QF2VlZsC7cN2G5OAya7reVHL5i9T3UCdmIXy00Jx7w+187ldzcVKLuHJdTSwZ6Y0zbPvsoKmLPTQ4MCrE09hIfd2FkPk6cP1iUPJHhhJOSUbaIYmTaD8MTpm9VAOnLlwPsdAs6XpdqyTJQgaPXn/M0vDfi+jnes6UdJzMRbw49r+IRHnntgja2ODKpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bH2V/ltbOydoJJzmmZozva/IkYWTEDkPL6IP/GFusu4=;
 b=CDeQJyCC1Dw5DsWsLIdTzsPFNeZ7ea9DcuaH/r9oIpp0APxofTz5BfXW0n5l9W2vrv4VeeoZ543LqTHH/KCG1rsMt763JpyXdtT7Ca3ZejRj2Q96L5cskaDLfEu1p0eO80Vi+s92GRA3lbHgonhaO2Rkq8FiiiWSvh5lHQX2V4w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 PH7PR12MB9101.namprd12.prod.outlook.com (2603:10b6:510:2f9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.28; Tue, 22 Oct
 2024 04:12:33 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%4]) with mapi id 15.20.8069.027; Tue, 22 Oct 2024
 04:12:32 +0000
Message-ID: <134c03b8-aa94-6d61-6d2b-965154c72949@amd.com>
Date: Tue, 22 Oct 2024 09:42:23 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH v13 01/13] x86/sev: Carve out and export SNP guest
 messaging init routines
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
 linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, bp@alien8.de,
 x86@kernel.org, kvm@vger.kernel.org
Cc: mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
 pgonda@google.com, seanjc@google.com, pbonzini@redhat.com
References: <20241021055156.2342564-1-nikunj@amd.com>
 <20241021055156.2342564-2-nikunj@amd.com>
 <5350829a-d30f-41b4-82db-8ed822e13d09@wanadoo.fr>
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <5350829a-d30f-41b4-82db-8ed822e13d09@wanadoo.fr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN3PR01CA0159.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:c8::20) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|PH7PR12MB9101:EE_
X-MS-Office365-Filtering-Correlation-Id: c6c13eb1-efc1-4324-6867-08dcf24fc04f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WkJ2ZVdyTkhrUVhXb2hOenZsQU5ycFpOZmVzalllTnhKWUlUMFoycElqZnhr?=
 =?utf-8?B?cTdOTHJDSXRNRHlRWnBIMGtZYjhuL0VFZHFhVzkrTENNeVlpQW5qaEJyMmxR?=
 =?utf-8?B?TnVUUTJqZ2UwK0F3VlVsYkt3VXg2dm05Y1hKY0I0b08vTTFMT0FNR3J5d2hB?=
 =?utf-8?B?M3ZFTXJlR2gzWFdQUlJYa2VKRjJaTUVNSHhVb2lvZFdid3NORWlSL2lRV3Ax?=
 =?utf-8?B?d1VyUWRKbytVNzI5TGtxYkEwejF1aEp1b3o0SzBQd1huSS8xYjd0aGR2ZmhD?=
 =?utf-8?B?Zm1abHhhbFh2R3VWUVlIWXlxaEJENHJsZjJkRGx4SzZ2ODllZDloNEEzdUQr?=
 =?utf-8?B?ZXBTMUVQakpYYzYxYmRpS0xNTVEvTkFkemVjNGdFQ1VPUHJObmJrSEhDYzIy?=
 =?utf-8?B?UFdlS1VlbHVqM1JyejN2Vmxjay9Kc1RvYkVLb25NQVpNQ0QrdXpkYTVmTTZX?=
 =?utf-8?B?eGRjckw5blJ0SE1oTTRXYVdRa3g0enhUTXZ4K1NPUnFhbkhnbWY4QmtZalVy?=
 =?utf-8?B?TFZZY01abjRpRTNEOTVuRkx5a1kvK3NJSUxOLzZsS2twU1RzazNVNk5ZZDI2?=
 =?utf-8?B?VFgzTW53YXpob3E2UWF2RjV5dmJFZCtkQmR4ZmNuVnNkVDljc1pnWENyc3Ix?=
 =?utf-8?B?U290LzlIWEdvK3Y4dmZHUnNUUGFzd1RuclNkemZHTC9UTG4wcUd5dHdXNWtE?=
 =?utf-8?B?U0JSZWY4bUsvendZZVo2Ynd2cjBqekpFc0V6OUZhOEcyREJsc2pXK0RUL2Mw?=
 =?utf-8?B?UEVUVjZOZjcrSk9tNEp2WHdDaTVuMThxKytwYTFEVXVIRW5DWVp4NVNON0l4?=
 =?utf-8?B?RzZTNWZ5TEV5Sks5QTJ1all6ZURxSUFHdjV6UFpUemVFSlJ1VHF5RUtEeHJa?=
 =?utf-8?B?TWh4eVVZeERvUENlKzFHZllzbWF0MWpwMzdaTVNMRzBaQjh3bUJ5ZHFXMHdz?=
 =?utf-8?B?eHdUSER3dnZtU3ZNTTlsNGNwbi9mcUNabnRxUjV5UlRIN3ZEbjYvTGY2WnhP?=
 =?utf-8?B?TXdKK29DaDA4M2FHd3B1eVpWZXl2cXZjQllWd0hocDI4NDYvN0RnZ1BxNS9E?=
 =?utf-8?B?V0xBUUhqTUtHMEFrcG5oQnl5ZUFSMDVmNXM2ODQ1aEgwZnpLd1JidHlNcXp0?=
 =?utf-8?B?YXppOGd2OG5WQVNhdjU4K2FVaFhRUm1UZTUrS0NLRzEvTmpLNDlyRkFFR0pG?=
 =?utf-8?B?YVVjdnkyT2lPMjJuTGIrb2IvQ1c2cWdXYkE3MHpoMFErVkxETGN2QVFEZXJ4?=
 =?utf-8?B?TWdYbTU5M3hEcVNxbVR1UTZkaWpFSzRPeDBsTnBaOFFicXBWRTVyamZ0dSsz?=
 =?utf-8?B?T2QyK3VHc2UwZ3hqYzdBZHRvMHdwWDJhR2JNMWE1Ullmd2kxbGlVR09aVzRU?=
 =?utf-8?B?ZFYyaUJ5Y2YzbkVieW1Bb0xsTGlNNlowbDFsRkRrSzk3RkY5VHcyNnAyS1pj?=
 =?utf-8?B?L21Pd1NQWStLV2RPa0w4UlkxKzk2TGpaNmU5Y2JNUXlITVFSTTczS1VLVUNO?=
 =?utf-8?B?ODdTaktIQmpydDZqeitKYW1XbFhLcXVQVGl1V1RVYUhGSUNwZ0RDQUhqV3Iy?=
 =?utf-8?B?RVF3d3JRSm9TSjRma1JPV1ZlaFdhN1FjMXZ0QnQ4K0NTNEF6NWJwcmh4TjFx?=
 =?utf-8?B?cXppYmJUb0N2TDdNR1ZMYnlYVE1Db09mbjhCMnAybDJPR2x2Rm5Ua09tbVMy?=
 =?utf-8?B?Rm8xUjFUZ0d5eEprWnY4cU5vak53ak8yeElka0JaVzV0TkJ1NUJpMWRyL2dk?=
 =?utf-8?Q?5CLhXn4vIygyRjXppuDAupKj+g5cJarPFuodctA?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aFVXdXRmWmNBTExWL21UYU5Sc3J6YjZJY0Q0YmlhTGRLTnhHYlJ1SkYzTWJC?=
 =?utf-8?B?UDhEK2wwY0Zsd2toTVRzWFdJQzBnY2w4YmtOOWExUUhMRFdJYUFpYWJENUZY?=
 =?utf-8?B?QTl0aVI0MEFNREpxd1dVbEVJaHQ4dmIzeWthYWFFSmlpN0N2MERDc2wzL0lp?=
 =?utf-8?B?b1Y5Q0tVVUk2QXd4Snp3QUJDbGFFamRSSGZFcFV4UW83aHFwSVRlWDZkekRy?=
 =?utf-8?B?QXV5dWJzemxka0xoOHRYK3ovbTlRSkhUTStCK3VCSis2dy8raXVnc3d6R3JS?=
 =?utf-8?B?UjJacjJnSGNjMmtWRFdSUU5TZzFsR1lValMyVVpUTHNmQ1hJcEZqWEk4NXk1?=
 =?utf-8?B?WVNQUzZIU0tuUk0xT3NSNnNUUksrcmcrem0yR1NKRkYraDh5ek5rc2JhZGE4?=
 =?utf-8?B?cWRxeDB6aHVpMjRGVkxiYnVLd1B1ZlFkRUJzSjJDRlFjTi9jcnpFVlU1OEYw?=
 =?utf-8?B?UENISHZzR1NPVzFGSnJhcDFnWkdtL3prbUZra3RoelVFZnFjSGg3WUZZMlhB?=
 =?utf-8?B?RU9maS9QcnQ5T0F2VWd6emRQbG85TGFQQlgycVZwVkRGZk16Rkh3Szl4KzZl?=
 =?utf-8?B?SkdYL25DcEFwR29OZ1FOaGVTNkJlMWg5eThpMGFxanE4NVdtZzNUcWlGUk9o?=
 =?utf-8?B?MFlTZHE3eHpUL3BKZ24yOTBWcWR0d25MeHpZeU90aFpUditGU05LcmM2NWM5?=
 =?utf-8?B?aUdvN1JjVTJzSWFhMFlmV3BOSDRyTWNBNGZRY0pvOFB1RHp4MXJCQitkVVNk?=
 =?utf-8?B?WEc3STkvMnBqcFpLazl2MEZkZkRveElDOWdIYnphc2N4Z2R0RVByY2dJOWFY?=
 =?utf-8?B?NkdKaDZVanpnaUY2dWlXdVNjTHppRWhJekVPZ2VsM1ovUFluS2hkSDJxNnk5?=
 =?utf-8?B?MlR6V0Z5cnNWQUJPbk1tOW1aMEZMV2JVajZwREhJbG1xb3lvVUpBaXJpRFhM?=
 =?utf-8?B?OXMxYzBucTBNRkkvTXZIVnp2RU92YU5qNEJoQ29tR3k5ZnFXaHVRS3ZObVQy?=
 =?utf-8?B?cXQ5V29hcUY2MEl6QVREMWsrNFdHYjdKSWVRMXV1TGphallsVGFnNjV2M3Zn?=
 =?utf-8?B?U3BuU1R0WUQ0V2JJZU5nOTNmb1lXWGIrc3d0dUZpckpYSjc3Rk9vZ2JDMXdF?=
 =?utf-8?B?aFpYWGxMS2RZMHVVb21LdEJIc0JDYnVLK3FkNUlXeEJHQlczUENzbEU5dGlI?=
 =?utf-8?B?MmVwZmUwa3NxMkpQS1FMcGpXVlYvNWZKZDd0UUFRcTkxUzduWm8vSC9ocGRY?=
 =?utf-8?B?djdwNEZSSXlWZ3FiRSs5VWJiakFzeFh6eXlHWGx3THVsZ1FieHhHSEp0SGhC?=
 =?utf-8?B?bEZUWjhVc1EzcnAzckxBSklrS1pXY0VKUjV3ZmV4SkpUMFhsZjdJVTZZeDRI?=
 =?utf-8?B?NDhqVWVxTmVJRysxSTBReHgwNnBjQlNYQ3o2b2g4UHZhNTlKVU5GSFZ1cU9x?=
 =?utf-8?B?MzRHb3hnTW9LUWFiYlFFVnQ4UFJ5OEIxSlg2a0EvVm5NaEZZWjlmakg4Wmw3?=
 =?utf-8?B?R0NlZHI3V1JOQUpxMDlMTnMySkptczJlMmtzN2RlVkZaWWJBbWwwUmJJenNq?=
 =?utf-8?B?aW9pSGJKaDB0QmdsYm9JM2RGSzIzeVl3L1ZKbFNHOFJyNzd4MlNONWFRdXdS?=
 =?utf-8?B?ZXhIT3hwWk1TYWF0U0UrQ3lwRWowcDlkTDVNUnp6OUgxRkFQTTMyK3hWWCsw?=
 =?utf-8?B?emtHK25STmlnSFJvL0ZadEZYMkpSUUpvdjdqVFpTcHpobDhib3VaSHlMRWJT?=
 =?utf-8?B?QVFPV2taREhtTGlueisxbVZCN3Y1d1dEVW5KWVIvTW9RVmloWEFJRkozWUkx?=
 =?utf-8?B?U1l3cjRjVUVneEFta2M2SVlCTUw3cUpCazNDUGFuUTQ1cTJuSmR3a0RKTmFJ?=
 =?utf-8?B?L0NOQ0JUVE5VVE45UlNuVGNXWkFJNU5pK0J3RjZMa3FMOVF6ZlQyY3F4VU85?=
 =?utf-8?B?T2xrU1VOS0k3dTFMaEQzNlNheThrclMrVDJyWVg2VnRPcFlySDJSVUU5ajY5?=
 =?utf-8?B?c0hlczl0UkZGTFp1S1VzSytzbmRJRVNRSHVyR1NGQ1BjR0U2Q0s3QWpHdEhl?=
 =?utf-8?B?R3dPL216bXQzR1VGdDdiNkxIbml3ZjN4ZlZIRm1lV1NrOSs1cm5BbXFsVGtv?=
 =?utf-8?Q?TZefYD8guyvplqkh751retOj8?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6c13eb1-efc1-4324-6867-08dcf24fc04f
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2024 04:12:32.6432
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4Vg3ncr1aYzZrQ5fl/Ds7eL9ZEvV2wU6mM8EpIV8BCoWtsIIGWCvRG0s+Iom5bfvmaVyuwh5tKjFJifVbRMcag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9101

On 10/21/2024 1:18 PM, Christophe JAILLET wrote:
> Le 21/10/2024 à 07:51, Nikunj A Dadhania a écrit :
>> Currently, the SEV guest driver is the only user of SNP guest messaging.
>> All routines for initializing SNP guest messaging are implemented within
>> the SEV guest driver. To add Secure TSC guest support, these initialization
>> routines need to be available during early boot.
>>
>> Carve out common SNP guest messaging buffer allocations and message
>> initialization routines to core/sev.c and export them. These newly added
>> APIs set up the SNP message context (snp_msg_desc), which contains all the
>> necessary details for sending SNP guest messages.
>>
>> At present, the SEV guest platform data structure is used to pass the
>> secrets page physical address to SEV guest driver. Since the secrets page
>> address is locally available to the initialization routine, use the cached
>> address. Remove the unused SEV guest platform data structure.
>>
>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
>> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
>> ---
> 
> ...
> 
>> +static inline bool is_vmpck_empty(struct snp_msg_desc *mdesc)
>> +{
>> +    char zero_key[VMPCK_KEY_LEN] = {0};
> 
> Nitpick: I think this could be a static const.
> 

As the primary objective of this patch is to move the code, I have retained the
previous implementation.

Regards
Nikunj

