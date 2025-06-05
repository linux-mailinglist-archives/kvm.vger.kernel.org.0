Return-Path: <kvm+bounces-48563-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C618DACF425
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 18:24:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B55E07A988A
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 16:22:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D378221A447;
	Thu,  5 Jun 2025 16:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="szQT5m5j"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2041.outbound.protection.outlook.com [40.107.93.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F1BE1A00F0;
	Thu,  5 Jun 2025 16:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749140599; cv=fail; b=d2vMxJReJYy9r047XaciKu6bmhbCQ/rwGC8ndvWfmBqcsmJeTLYL0F3Hn+iwUkAFrq/dUI61RYuYPwfCPOiyJIoXTAfia7YNqmszVee9OPkulH2sO3ve0EFYlUacUKaBkH6StpLxZ53fov0J1zvy55sDvwUsWfuCebkyT5XJVns=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749140599; c=relaxed/simple;
	bh=mlIHc9MHYtiAvfxROqTB6WZzuKZlEmysllviz7BPM6o=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=OfN76jq0QBCE9WMyAIVlRpT87ugG+tAFcSu92qpUamfw3hKvS6yOrkrziJFe6ZmIJI6gDIrwzikZqNBXvvu9UxwuosVWhX9LPepaJfxT7syY1hsyI2DRF0QR+5zAm+i2LhymKakqQZ7f2gnwIi/Avr6wZ5hScHGWO+FHF05jLh8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=szQT5m5j; arc=fail smtp.client-ip=40.107.93.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QNsIYiwpjrAJN3fjJxAcT4ILrAqhcfGStLsUaPrIGyyDx3dobJbE6txEvIAHAVFPZAJbZsc2u7Bl/myHNWUhI8YjZbeUuAsgq3s7DCOQct9y4pxkpoJhh73O6+mak20qWk6k55EKCkr5z5aidE3XMrxYmyToHivPCQxJGJPbxkRCAV2/LtyRscmHc4u8RZBU3pbu0n43Mpoy9Adkjs9gXDfSSd0NPUfAUosSvkCRFcJsr/4Ic7jh9UipCme1ZsD91YUYKvZ+P2qpOJZV3ogFBP3RI5rDo8cXRQznAqU0A+encwRqWEPQRQC7wuS2W8bLEfs9GBIebilG7sUVaeqHmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VNPqd16DOVV/3GzIrz8ADLecJjAgZ4QJiLse8YfQNGY=;
 b=aYVaBvPcsrzNuCX0vTjiH++Y2ArpA3YYPDnTYN3zmfRMfjbS3hUcWNL2dn1u6EroE2wlHlZI4F1LgmnvJcUEgP8TJUL2Ik3q2ounEKUqhsKDIPqkKSYQ9uk5Qe8zrUXN5yLTPznETKBnkGhxSnNFjh6Tp4tWO916eN7QSvVhglQL1EoefnivHCZZ9IoAvftUDzq0p7ycezyNafSi5d0/JpckGSQYjKeSzL+HIitIp7n5IfBqlkDmtuXT7Z8SfCyzyk/cAXbIKQqOc4zcX7pwMLTxn7+jGZjOWGNWpyEe+cNwq/eJdd4Unp2444pYSg8V4B3JQCXMDl5JfjcbVUkCAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VNPqd16DOVV/3GzIrz8ADLecJjAgZ4QJiLse8YfQNGY=;
 b=szQT5m5jaWaW/3chcC/bXqjpfd3CqXsZjd3Y/9IDv4yD3oxE9k/Eyg+/EXN0I//GM7qkxP5+8N0Adnen1/SkUmX+kcNBhlbzhMptw4F3HotftXebM/X89spmIDVOwDR6VSnwmtwLaYuNc2e04V7JX+ZE+yY6GOv3xqKA5RZGOZ8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by PH7PR12MB6585.namprd12.prod.outlook.com (2603:10b6:510:213::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.34; Thu, 5 Jun
 2025 16:23:11 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8792.034; Thu, 5 Jun 2025
 16:23:11 +0000
Message-ID: <087c429a-7d1a-a65a-f254-155cd6b2aa49@amd.com>
Date: Thu, 5 Jun 2025 11:23:07 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v4 5/5] KVM: SEV: Add SEV-SNP CipherTextHiding support
Content-Language: en-US
To: "Kalra, Ashish" <ashish.kalra@amd.com>, corbet@lwn.net,
 seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
 herbert@gondor.apana.org.au, akpm@linux-foundation.org, paulmck@kernel.org,
 rostedt@goodmis.org
Cc: x86@kernel.org, thuth@redhat.com, ardb@kernel.org,
 gregkh@linuxfoundation.org, john.allen@amd.com, davem@davemloft.net,
 michael.roth@amd.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org
References: <cover.1747696092.git.ashish.kalra@amd.com>
 <e663930ca516aadbd71422af66e6939dd77e7b06.1747696092.git.ashish.kalra@amd.com>
 <a6b39023-447d-67bf-9502-4340f9d41c81@amd.com>
 <11700688-98a4-439e-bcd3-44ca51fcaa14@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <11700688-98a4-439e-bcd3-44ca51fcaa14@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0346.namprd13.prod.outlook.com
 (2603:10b6:208:2c6::21) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|PH7PR12MB6585:EE_
X-MS-Office365-Filtering-Correlation-Id: 42fe7913-3b3f-48b5-8139-08dda44d43b8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RTRrNW5XSlJKMXlwVC9nVHU5dkZScW5CT2pGY1d6UmxxbzFUb2dpOEhkbE5O?=
 =?utf-8?B?ZUt4WVYxck1ydFZVU04xandSQ01hR0ZNVzFxbXVab2Vrdk9OMDZ5RUkyQjNV?=
 =?utf-8?B?Y1RFS3dqcVBVOEVUUStVK3pOSFJabHh2OExLZCtRaUx4Mkkxa3paNUFjb014?=
 =?utf-8?B?T3hEdnVvTnl3bkhGa3pZVzMxc1FJaGZrL1ozTEx0WnZPMERWREM3VE00VmEw?=
 =?utf-8?B?U0FNdjdCZDdhZUNDNTVEOUtvSkZ0cE5xQVBmTWJUWHVIQkFoNlYxU04vcGgr?=
 =?utf-8?B?dW9GSG9oc0NkRXFPQnUxRmhuWDdiL0ZWMXo1T28xUUJtUlkxbEhTZ2JiWm9m?=
 =?utf-8?B?UHJNbWRrTFRYRjdJNEFEZDFxS3pmVVIrTllCWmlHQnFtOVdLNlhIdmRqWlVN?=
 =?utf-8?B?TjFOMW1sT2FROXVpbXEzemFDSVZnaklmNVNHaktlYWZDQmd1aXkwVEtoMThH?=
 =?utf-8?B?cWlaZ09CYkNCdWY3ZVViS0tXRlE4WFgzMVo2c3NNaTB5U2pnV0hucVliTEcw?=
 =?utf-8?B?NzlzOGM2Smg2MFFTZmVmelZtcExoTlFacEZ2NlFUZ0JHaWdVbG9FMzE0Z1Jr?=
 =?utf-8?B?RlB0a0djeFVvRkZ5c2xjd2hWUU9nV01HdmRNbTUzMzBlckI2cHNpeGsyNW5S?=
 =?utf-8?B?SklvbVdnaW9vQmFIeEhub3hvdzNUYTJUL1pNUWZaYnF6b0VFbFBwdHBHT2Ns?=
 =?utf-8?B?L0ZPbmcyeFZjUEZyQnU4RkEzd0VhMVpOTGNUWFNaMXh6YmNkNUdDcE1PSnFF?=
 =?utf-8?B?LzFKTjhRS01ENWRVU2NFUlNCRmRyQmw2N2VlditYOUdTTjV1Y2JtMlR2RmVI?=
 =?utf-8?B?elFoMEN0eW9BU003RFRHZnRmVXlPem5PRXFqdDk1NysrNXBEdlBCZXpHZW5L?=
 =?utf-8?B?eVczVHpUTGlHdFdIN3liNHhLWTBrc0VJT21mOXBFUHZuUVdJcVZVOTcxNndm?=
 =?utf-8?B?WnRmMWk4RHZScUxxUFdjbzZ3bmx3WTJTUGhBWjNmM3l6anZjcWpXZElNNHNn?=
 =?utf-8?B?dmowaWhxQmlJcnhDa28ybk5vaGJOZVl6d0JTZEpzK0FRQnBudXJvUDU4bENi?=
 =?utf-8?B?aElkeTYrdVBpNWNaMGVvdU1MMU9Db2drajdmUVlQSTNGcXFWTkNSUHZGd2J3?=
 =?utf-8?B?M0Q3b3VCcWJRcnFkSzFuWDhpa3lkaWxWdnBUUlkzZTY5dFdGN3R2Q1MySXR2?=
 =?utf-8?B?Wm12Q1hyLzkzL0RRQUtKb2pvSG44TUU3bDFDRHFhZ01UZUxFUXEzSFN2T3o3?=
 =?utf-8?B?Y29UYnQxWEJvQkNmM0lFdDVnSndNblhxZ2lNcHRIVURObHc1cUl3eURFNTE5?=
 =?utf-8?B?SnlRTWFydldIbThoWE1jUEtOUysybEdKZ1g4YytLYU1kRE9qdHVFZExuT2tT?=
 =?utf-8?B?NHVNbW1Kd0xQQXBScGVXWnRXamhzSVovRDV2TVVCYm5XdFdmSnM0Z1FnWjhY?=
 =?utf-8?B?anlUOE9aWGw3MWNlcEFYS3Q5bzVlY09ldXZ1U1NvcXY4cnRhYmZaSk90c3NR?=
 =?utf-8?B?aHN4aVBMRUUraXk3QmZuSHV0aWNTY2dIUUpKd2dONFd2QWx5VXdsMHFwN1Zn?=
 =?utf-8?B?ejFJMTdkbGRjUzFMUFZmSTA1YzZUd24raDJQSFB1Nis1M1EvZDlvRS9oS2Y2?=
 =?utf-8?B?MlpDT0JjR3dzeGVaQzU4MTNhNUo4cVprcWE5RWVkaTZXMEl2ME1nUXM2TmFZ?=
 =?utf-8?B?RUd1cFYwNGxLcm9WQnlZclpGZ3hGeXlhdU1QNGdaZURuT21xUlRlRFFhZEFW?=
 =?utf-8?B?dzNIeThBbG1yOE1aMEE5dWVCTzBqay9MSnhJcGR6WjJYUzZ5cmNRTjIzZit1?=
 =?utf-8?B?eVBTQ2FmTkNDemlqU3lvZkZHbFJ1c2g5cUxjeVpnaGdMZjBnb0xHVVRGSmZ1?=
 =?utf-8?B?Njh0UmNRWVNYTnErMnhNU0FvNm1zUURCWGJUSDZDU0FtRzlVSEI3SGcyeFoy?=
 =?utf-8?B?MU15VjUyWW5lKzk4eUcyNGMxSkVwVVdkT29qL2Q2TUVKRXFJSEJqa3RhZVpn?=
 =?utf-8?B?VjhDejR6UUlnPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OFhCMUxLbHYwd2M4a2dsZzRFQWtlVW9wNlhYWlBtcHFrcE54dUhFL3cwSHRU?=
 =?utf-8?B?V3VFMnp3dzV1OWV5VGRmenNrcFNDNzFBWjBoUU0xNlArSHVqeGprQjcyVDNX?=
 =?utf-8?B?aVBPYy9MYUdiMEdBY24xZk1pQng2RU85YWVoZ2Q1M2NHTUtsdXRqK0o3ekNE?=
 =?utf-8?B?SnZIcEdDdWVwZ1BQSm5WRmZpRWdGNXh1VWJmT2hRR3d4d0JnT0JtNkF4Rkh2?=
 =?utf-8?B?MDUwdThhQ0RLOVRZZTE0ZkZvK0V3STVkbkU3S2xkbjBPTFJOT09obTZWcUU3?=
 =?utf-8?B?WnozZi9IdjlsZzQ2Vjl2eVV4ZDVsQ3YwUDZUa2JQRWphYWkvdDF5RW1qU3VW?=
 =?utf-8?B?eHZORWlYWUtBVS9INmJEN2hLeVd0RzFTN0FuOFQrM01OM2xIRE9NUWVycHJK?=
 =?utf-8?B?bzg5TytYRlA2aldoODZqdUF0SkFJZHNndjBpY3dJYm5oOTdXQXpmU0NVTFpp?=
 =?utf-8?B?b0F6KzIwVHJ2UGNkVUZmUEFrd1ZEWkhydVNhREFoUU9VRGc1Z0VmMGcwUFAw?=
 =?utf-8?B?NE4zQm56WjVHQ3NGcWFGc3JsT0NiZ2RGL3licXBnMWFBcHlBY256N1hSaHE0?=
 =?utf-8?B?OTB4N2Q5clJBVDlXVVAyVGtRN2VkaWl5SnZJY3JMWTRCMXM2b094b0NaV0xt?=
 =?utf-8?B?VFk1eFIvQXNGZzBOU0h2RVljdGI2cWUrT01iRVdaVEEwUHRzeXowRzQxZ2Rk?=
 =?utf-8?B?dGNNZWR4STh3OEJqUVFMQVV1UnUwUU92d00wMjh5V0dJSG1uVWdGUVdvblZh?=
 =?utf-8?B?a3haa0Y4MndzOTcvR1V4T3FCaUZPcTZRUy8xT2tWcWV3TnhPejRSMlRwOGNX?=
 =?utf-8?B?MkRLTUVpSkpCUTZ3c3diM2RjYnNTZGUvZ0N0d2kzRVgzcmtoRkcwdnFuVE4z?=
 =?utf-8?B?UzIxeTJUb1p4d2xnQ3hHY3o0ODczb1hZMXVHSlk5M2hSaWdtVEJSUml3NFRX?=
 =?utf-8?B?NHB0WEVZQjZDbitITXdIbDF0bWhHQTZoRGtxMGRPc080bi9SakptYk16TWhu?=
 =?utf-8?B?ZCtSdTgvMjZLSWNuY1d3a3hPZDkvbzJJTU05ZTl2Y0xRcENkY3RUK2MveElJ?=
 =?utf-8?B?WUt1dmwvdnVhWTkzTGRGZ0hKNStIb0FsR3dJUkxHdjdMNmZsSnZrb1pJZ0lw?=
 =?utf-8?B?RVJaYndyaC9LczdsZ09qSC83Q3pRUlE3dHNka3BmYnJuYndPdWRUNzNXWmdm?=
 =?utf-8?B?OUFOM0N5MTBXZ1IwekJiL2p3bHJxWDUzK0Z3aks4eXYzMEowZ0E2ZHlyNUNU?=
 =?utf-8?B?ZW9DSlcyZWJDRVlWVWM5OWpDSTdMUXU3UnJ6aWp5QUE0M2t2WjFzZ05NeGZw?=
 =?utf-8?B?cTBLUGZqcnN1VERsN0hiZkpmaEtRRjYwUXRrMk81RVhiTEFFRUM5czFmdjdx?=
 =?utf-8?B?YjljbFdwaUF2WUY0QWhVQXJDNVowdWczVzdnNGhDUkZZcFloMVF4K0lmMEdu?=
 =?utf-8?B?UVZyM3FoM1M1N3VkMW4xbGlrQ2l5enM5THpvQjlYTDZqV3Y0aitSNktYNktu?=
 =?utf-8?B?MXJqM2RqK1VaSk9hbVJNUVZqOXpVTmFLbWp2N2g4VEsxQUlBQUdZa2kxanRG?=
 =?utf-8?B?SUNKMFFIOHNJV29CQi9EUlhFOGltcmYxMWgzdEppR2JyT0MrdXZGUGR4SVAv?=
 =?utf-8?B?eHc3Ymc3WmJhVCtrcjllOTJFOEZZbWhzOXFsOC95TkNPWEVjanlVWDFHMTFH?=
 =?utf-8?B?d044dmhhYm1KWENYejN3VWppZTJVZE50S2U3SlFwY2FpbUFBVzREb2dBdUxE?=
 =?utf-8?B?V1Viajk4cE9BanNJVHhPYllIRGJpbXlMZGdFdEZLZmpib2pIOFo3eUF4dU42?=
 =?utf-8?B?TXoxQzJMcjNmYWo2SnpIVjVBTE5jTHA2WGkxakgvWUdlem9BUU1HYUpnQUZ6?=
 =?utf-8?B?NklrUkg5cDZpbm1WZkJLR0tJWnhhVHAwN2tiakRLTjNBeTJBZEQ3dHl6MFNY?=
 =?utf-8?B?UnJrN0RyVm9HSFl1RjZ1ZTRJUWhoeDVnaDNzd2sxZVF4RW1wT3ZDaldZYTRj?=
 =?utf-8?B?NWJ4bzRjRmJ4SzhXUWF5RnY5MUFXSXp6bGZsaFVndkw3UWxQcFBBUUlNdWVn?=
 =?utf-8?B?SmZ1NVZGWkVnNEFLNms1dFN5VjUrck5KZmlZTHlvSG5Ibnc4Z01BTm5FK0pi?=
 =?utf-8?Q?3uGiWIdXP5MJ3fhtUSv2wb1mS?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42fe7913-3b3f-48b5-8139-08dda44d43b8
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2025 16:23:11.5151
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OJ24EYfPJ6QLa2bI62uuSDmo/NkTLAnI8YzuSUaN5L9E3CcWQuGop3YZmIkHsACp8ss5rFOKnxMZEzi7dqbQhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6585

On 6/4/25 19:17, Kalra, Ashish wrote:
> Hello Tom,
> 
> On 6/3/2025 11:26 AM, Tom Lendacky wrote:
>> On 5/19/25 19:02, Ashish Kalra wrote:
>>> From: Ashish Kalra <ashish.kalra@amd.com>
>>>

>>
>> The ciphertext hiding feature partions the joint SEV-ES/SEV-SNP ASID range
>> into separate SEV-ES and SEV-SNP ASID ranges with teh SEV-SNP ASID range
>> starting at 1.
>>
> 
> Yes that sounds better.

Just fix my spelling errors :)

> 
>>> +	 */
>>> +	if (ciphertext_hiding_nr_asids && sev_is_snp_ciphertext_hiding_supported()) {
>>> +		/* Do sanity checks on user-defined ciphertext_hiding_nr_asids */
>>> +		if (ciphertext_hiding_nr_asids != -1 &&
>>> +		    ciphertext_hiding_nr_asids >= min_sev_asid) {
>>> +			pr_info("ciphertext_hiding_nr_asids module parameter invalid, limiting SEV-SNP ASIDs to %d\n",
>>> +				 min_sev_asid);
>>> +			ciphertext_hiding_nr_asids = min_sev_asid - 1;
>>
>> So specifying a number greater than min_sev_asid will result in enabling
>> ciphertext hiding and no SEV-ES guests allowed even though you report that
>> the number is invalid?
>>
> 
> Well, the user specified a non-zero ciphertext_hiding_nr_asids, so the intent is to enable ciphertext hiding and therefore 
> sanitize the user specified parameter and enable ciphertext hiding.

Should you support something like ciphertext_hiding_asids=max (similar to
the 'auto' comment that Dave had) and report an error if a value is
specified that exceeds min_sev_asid and not enable ciphertext hiding?

Thanks,
Tom

>  


