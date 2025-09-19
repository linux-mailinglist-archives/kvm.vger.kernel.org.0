Return-Path: <kvm+bounces-58168-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 43E25B8AA4F
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 18:54:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EC082565F71
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 16:54:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC24724729A;
	Fri, 19 Sep 2025 16:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="LJM4bOWK"
X-Original-To: kvm@vger.kernel.org
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010062.outbound.protection.outlook.com [52.101.193.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C77478F26;
	Fri, 19 Sep 2025 16:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758300849; cv=fail; b=ras3Xb0G5HhvpQH57s+b8AOigDFqXg+VFhMQdH5HETZFhih/0sdcVJbkxQjh9vzLqG0Qxb1X8LYAJx3wJDaIDKhGO/UGbAM2f6IMV3/2cyNfACQhQq+mua1uzus/BrLkmcfON9uJg2eXnw6adKdQ2f4G+477ZfwkHn/SCIQPbfs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758300849; c=relaxed/simple;
	bh=NB1cUBhUO3Wc1UpgseKttTapBEZfQc2ElKfy/61FI3Q=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=GXyNDrbyR+28b/7seV5t12YlS1ko88pnN7FnkxgF1o8oMKfYqJY/B7EA9qLSj6ASWiMSCggqOE+P5cxtWpBz3tgsdBubnLM2V0APQeZsulFDeMWpICzrqB1byTODkEuATK0f2YSyD1eZttZZPUjRiJKmAx93mOd+Oc1Z5V/yiQY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=LJM4bOWK; arc=fail smtp.client-ip=52.101.193.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G5sQFhNKsZsStjTOTcQu6k62xLURC3cnO6vr9dmidQZJ5HgYsw0uyQqJMB4IDjEeMv8Yg+n0gf3XaNRkh2mqhzrmpq4Pb/x0vs40wnObpW9zp8Gm/GcF1nArvI2zTJAeuHZ0/eo7lhD2ZAwNqFILcmQHeKYDVpBo+bwmq+euMK+BKGj+4XNdAHxDyehQuRknxhoSdgEUzSA7AtNm37zKbb5vfzEe7leOHL3PUqybNxWd2qti4YPYLi67EuTRtcKL79268o0QqWi8bsLInsOMdrdwVjdwAVNVf+7raiuGalO6YvBn5PjTlAQH2OTqugwAZoKQ1go7TrAW0Fm/BAK5lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y/KpIB0/rx0dPdjzmN6sf3HPJtW/ok5/ZXsX5VhbCIc=;
 b=B6sw9f1D5O/bPvCcCIAP7TwQ3G1amXyMqmyGX6VuajE9KQr5kcFmpnFpd8psO2IDMbu30YAOZ1Dfmammq3dt6XYKhHx+NqW8KMyGoAz6yB2CO/95h6lgfR5IHntBVUHTfTSVNR16b742SNCrAr6hVOs92IVbLFtf+A84scOcjKedlqw+zGCzdXDILK/lhqdL1wlJeqD80WZWCxqDI81vunEhH6E01/3MMOt/BY0Sydw5v6wYSWTwb5XX+45fModL7oP2lfKwfgqR/RcNipsGH0P2IiNgd7c2qj2epQ+DKHhhvZ+JY4e29n7shh9WkbM4N01bERBTnimnoLIpSPp+5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y/KpIB0/rx0dPdjzmN6sf3HPJtW/ok5/ZXsX5VhbCIc=;
 b=LJM4bOWKFw1+U4UAytTgfDpXhSZ4EUWwSVfBVyqJBAk5IrB5veYz4tu3KpVUk0O4jIc+Bij103qVqeoyzJGL8Gk7BIPDzEzQg/R4CbixZG5fpQ/tVxtqzKRLk6Jd/UiDSqGGL/o/2EHs4TYT2AiGVRx/5t9QlwuzqGEIAJpDkrY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc) by MW6PR12MB8897.namprd12.prod.outlook.com
 (2603:10b6:303:24a::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Fri, 19 Sep
 2025 16:54:04 +0000
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::8d61:56ca:a8ea:b2eb]) by IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::8d61:56ca:a8ea:b2eb%8]) with mapi id 15.20.9115.018; Fri, 19 Sep 2025
 16:54:04 +0000
Message-ID: <f45a8fbc-6639-40a4-ba40-3a7a9c680fc7@amd.com>
Date: Fri, 19 Sep 2025 11:53:58 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 03/10] x86,fs/resctrl: Detect io_alloc feature
To: Reinette Chatre <reinette.chatre@intel.com>,
 Babu Moger <babu.moger@amd.com>, corbet@lwn.net, tony.luck@intel.com,
 Dave.Martin@arm.com, james.morse@arm.com, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com
Cc: x86@kernel.org, hpa@zytor.com, kas@kernel.org,
 rick.p.edgecombe@intel.com, akpm@linux-foundation.org, paulmck@kernel.org,
 pmladek@suse.com, pawan.kumar.gupta@linux.intel.com, rostedt@goodmis.org,
 kees@kernel.org, arnd@arndb.de, fvdl@google.com, seanjc@google.com,
 thomas.lendacky@amd.com, manali.shukla@amd.com, perry.yuan@amd.com,
 sohil.mehta@intel.com, xin@zytor.com, peterz@infradead.org,
 mario.limonciello@amd.com, gautham.shenoy@amd.com, nikunj@amd.com,
 dapeng1.mi@linux.intel.com, ak@linux.intel.com, chang.seok.bae@intel.com,
 ebiggers@google.com, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev, kvm@vger.kernel.org
References: <cover.1756851697.git.babu.moger@amd.com>
 <c9c594dddd02b53498a184db0fda4377bcef5e89.1756851697.git.babu.moger@amd.com>
 <13a1d78b-4bcd-4216-93cd-b95961a12369@intel.com>
Content-Language: en-US
From: "Moger, Babu" <bmoger@amd.com>
In-Reply-To: <13a1d78b-4bcd-4216-93cd-b95961a12369@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0039.namprd04.prod.outlook.com
 (2603:10b6:806:120::14) To IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PPF9A76BB3A6:EE_|MW6PR12MB8897:EE_
X-MS-Office365-Filtering-Correlation-Id: e623e5c2-f775-416b-1512-08ddf79d2411
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|921020|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NVUvdG5WYjVDVytBQmpjSVEySVpFVEQxTHliVHBhRTVEa2FUVzhESXRYaGRJ?=
 =?utf-8?B?YVkrb2N5alMzbVQ5UkxrM1RiS2U4d2ZMcUovL09vb2FXK1JWTUxjRUViTGQy?=
 =?utf-8?B?c2NSbjgyVHQ4YTVFVlk0QlVWaWhpbVpGZ0VZM1QwMjE0MXUxRDFwQ0czenBM?=
 =?utf-8?B?MzdSaUpiUzJFbFk3ZGVzaWd5Vm1wUnpvd1M4Qml6VjhvZHFtZVk5TmZwcmgz?=
 =?utf-8?B?R1lpOWxsTkxTNjNpL0tueFc3V2RlUmF1UXIycHBrNENDWmE5Z295WjlrdTlu?=
 =?utf-8?B?cmp6bkx2dTVtZm5uYnVkVFVpMmZSVVRnc2FIaTdvbWpmbkdudTVLc3Q1RTB4?=
 =?utf-8?B?bVZpc0JsMVZFenNyR20rWjhNNjdqMnNzdnhkSlZ1M0diYXNuWUJpVFltYldV?=
 =?utf-8?B?RVVlOHNNQzBvQmw1ZDdMeDVlZC9WMUZiN1pjRlZ1MUpYT1R4R3FGcUxzK1NS?=
 =?utf-8?B?S2J4RGJKOXMweExRZGNrcW9zK3ZXd1FpSGlrRVptem1Sa1Z5UHlUN0kyUjhv?=
 =?utf-8?B?YS9EeEgzMnp4d2tGYU00VmkwZEVIRzRnN091TEgvZDZyOUFwRktWT2ErRGlC?=
 =?utf-8?B?aHZqTmZoU1k0U0tieTNNbVRlYmhTSlhRWVBWeXNJWUltUGt4bUo2WEIxVmhs?=
 =?utf-8?B?RFMrYlZOWnh1UmNzeENiTWdCeUgzcE0vdksvSGVwMmlnUTZoUFBnS1l0dnZE?=
 =?utf-8?B?MnB6ajFxeTg2b3NMZ0ZqTElCUFdneU9wL3I1N2FSZHlVVFRpdC9IOXlrajZy?=
 =?utf-8?B?N0xQcXQ3Qnl5ZVptVUZlUkFCSVFEMVJGMCtWSEJuMlB5YkJOVThWNkQ3bml5?=
 =?utf-8?B?dTVPL2dvOGFCQ3grWjUvaUlxTC9ydldSVUFCU2E5bTlJVVNLNTRnVkh6Ri9z?=
 =?utf-8?B?eXIxdENwbURpeGZRa2laSVhPczhhSzZXb3QyVy9rV3Y5dzR6QitYR0l4eG9r?=
 =?utf-8?B?U01Kem41NXRRbG96SGJDZGRyVkJ5QzNhQXZ3QTlCY1Z6dDRVYmtzSlBuUVUv?=
 =?utf-8?B?STRpWnpLdDUwU0xhVGVpRHFxMkNkRTQrSnBGejlIVDc5NjM0Ukd5Ukd2VG5P?=
 =?utf-8?B?TWtGNjNUaGZWcHV5UjZPbi9ocDFlMTk4Z0RpR0FrRlk5dW1MZHlzY2ZzZTZJ?=
 =?utf-8?B?NUluZ3pJdW1aTVpJTmN3M0tVSnpUelpEMmFEa1BjbG1kazEvSzlNd2FvSHpt?=
 =?utf-8?B?L0VTTzFOb2o5c1Y1RXQ5ZkNseUJWbFFnbjMzRG9Fdi9wc2VvT2h4ZlBkTkRF?=
 =?utf-8?B?OC9oQ3JObG9MdUxLOXJOL0w3aHRtMW9odGxuYmd2QmgzT1NnTHd6R2s1QVJk?=
 =?utf-8?B?dmpscE5DazZZTENGR0xFR1FNWnlka0d0bmw3Tk94MHlDbmRTZGxyMnFYVEhD?=
 =?utf-8?B?QVRWRTdybDNXVEhNZzQ4MFVjRXRTT1lQVjhyNW5zV3F1Q090RzRVUzIwQ1Nt?=
 =?utf-8?B?R3AzWHpnVUFqQ1doWFNBd2hPQUlyS1dPcUlWTUp1OTF3TENCRHNOdFo1NGNY?=
 =?utf-8?B?eW9jaXNFVG9pZ2pJVTBmdnl1Wi9ta3pGK29QOVNvQVhEMjg1UGJBakpyVU1k?=
 =?utf-8?B?Y0hEeTc1Qjl6ZEhrUUJOUzh4ZnVCOUExNHRYa2xHcEhWLzNsVVlnNnE2UjM1?=
 =?utf-8?B?TE4zV3p3ckhvNmNiQnZVamZMTDVHUFArWkJoWG1aamVKajRIelpJOVErUFYy?=
 =?utf-8?B?Z3pPRGdVMGExbUZiM2FQa1QrOTBwdjdab0xkUThBWHVkcnU3UDlZSkErdk12?=
 =?utf-8?B?dHJjdFFWYjkyNjdabk95TEJ2SEFLNklEblBRakpDYXhnUnN5Zy9zbThORmc2?=
 =?utf-8?B?NnRaandBUUVQQjhmcndlUTd6QTlab0d4U0pjYzE5K1dsMUNjMkQvQ2tkbW5x?=
 =?utf-8?B?ZnFNTGlNamNQY3VReXZOV296VW8rS1pCdGd0OERNSVR6bGc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PPF9A76BB3A6.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(921020)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MjkwVEpVWGppMXRFWTdVaDBWbEtmc3JWUkRJcWNqSEpPUmtFU29rUEQrRkcr?=
 =?utf-8?B?V0VCZG1wVERvV3Y5N2tnbUlrYzFSbTUzT3VrU25HRVhETG10eEtaYThYZUN6?=
 =?utf-8?B?NVNZZnZSMlpmLzh3VEVuUGJQb0tEUzNnNTR5Y3VXcVA1TlF4bEd3SUdLT2tk?=
 =?utf-8?B?eVVOV3BDUldWbVI3RFJlUTFEQkFGekdIRUt4SFduSmZmbC9MYXdVRmdjTEZ4?=
 =?utf-8?B?RHRjaC8xelFuRDFNRXV4RnNRMDBqd0d6UVJPNjlSUS9CdXVBMzNOSTNzVkI1?=
 =?utf-8?B?Z1ptYzBZUERyM3I2aTEwVnBiV29SaStOSXFhdDlnWEhzWWRpREs4RWNmLzEr?=
 =?utf-8?B?eThrak01SE5iSlVIK0pJbGMvR2R0b2piL3Z2UzJjdjZkcmdmdjVZWU5wY0FV?=
 =?utf-8?B?bTVab0F5TlpvU0pmYTlsYmJRZWpiT1g0WEhFeGV5SlpNV1A1TDBmcnBOcHVp?=
 =?utf-8?B?NW9HdjB3TENRc3pLaWExMGRGbnBHSXdlbS9Vblc3T3FvUkg2VjhHaStWN2ln?=
 =?utf-8?B?eVNZRzY5Q0cxU2trZk1HTy9sUkVra0EyVkhnUlZ3Q3VnSVJ0VEhweG9NclpC?=
 =?utf-8?B?MEJ0YnVIK0MvckJGK2R4cE9lVjVNM3Evcll4ZXdLNkh2MHBHU2tWL3RDeUFE?=
 =?utf-8?B?ZHU5Qjk3U1pXT3JBRHZORmtQMTlYak9SSHlkQTBOTmI2WEU0dTZwYlowUWor?=
 =?utf-8?B?Y1NLbnh5bDNVbVR6U3FMUG9vZ2diMnhmR1JNWEVWSEdUNkxnN1lVM1BUaWo3?=
 =?utf-8?B?elJQUHFqY0Q4UkhLQnBFWlR6Wkw2b1VaWk1QeXZYK3JaRVlSM3dTV1dlQnVN?=
 =?utf-8?B?Z3U4NWowR24wSjVaNlExdHF4TDQ1WHJRVkxzUnNpbjhsdG5TdkEzbWo1REc5?=
 =?utf-8?B?S2JHNFg4YUtmRG5iV2l0dzJJdEhDeE9FdHJXNU1BckNTZG8vOGtvV1pnS2JY?=
 =?utf-8?B?UGlNVXhmTGhjZ2l0U0NLVlBJdEJpQWhXeDEzUHU1dmdyL2pKbnlCVWQrL1Fs?=
 =?utf-8?B?UHF4NlhZTjRSS2YyYUtGNlpBTEhSeGdvWkFiMjRPaWpBUm00RDhuZW5sRmJr?=
 =?utf-8?B?SmZIYW1yVXpzbis5cUY0K2F3S3lJVWRDdlptbWY1SGJhVS9TbVNZeHdUTUpK?=
 =?utf-8?B?Z0NXTVRPTkdQL0I1cjVEcmp0YmR6MTllbTljQmppWnY2Q0xjaWhOY0pLUlNJ?=
 =?utf-8?B?emxWYm4yMG8zRlY4dFRYNi9ubWFJTjRIdU9RMXU4NW1nZEl6cTVTSDJKd3NR?=
 =?utf-8?B?QUdHL1dPbGJEVkFrNlRyQVFyamV1Y1ZHN3NzR09aUGN1ZDNFbmFOVkp0R0NC?=
 =?utf-8?B?eGhYd3ZaYUpLdnFwdWxqcUhybnlnRTlMVnpaRHo1MHNHcm1sUmV3empQLzBs?=
 =?utf-8?B?SlNnTi9ySUhGdDFLWVVTaGVtNVJqaGNsYnhhc1pLUFJtaWE1RElZSzVkZTlw?=
 =?utf-8?B?cm5kVDZrUnV4VnpRY2d5WHRUc0tIb3BTYjlxYVJTb09JNjBWeXVxY1N4Szlr?=
 =?utf-8?B?S1FuakZOZXRvUllVRUhrbzNQbHF5dmZLUFloK0xWeUF1WGJwUDk3WkEyelR6?=
 =?utf-8?B?emt1ZnlVQjJXeGREYzBmdnYzVjVhV1daNVMvUWJsOU5EMllyQjFwcG1WN0Zx?=
 =?utf-8?B?Q09wa1c4UzhIVW51dWhORnhXeFhMb0FZOFhqZWk4OFVTY0xRS3psOGhwcWUv?=
 =?utf-8?B?K0xxbXREcHp0Y29yVTNmRTljQlRQaU1Ic3h0TkJ2SXA0YW8yVU83bjJXT0xX?=
 =?utf-8?B?Yk5OcGtRY0lscmNUdXlmOFI1cDBEOXBueGQ4Mm5nSEdFMTdMa3R3VWxBTXZo?=
 =?utf-8?B?dGJzcTIwNmZOc2VjQ2k3NGVwMHVCRFpaTkh6ZHBERGpndUVYQktONXBHNExa?=
 =?utf-8?B?eHBjMG9VRDlCamdyWjdPR2FYcEh0eGNCSTkwSDM5TjNoQTg3TE9BM1VYS3JG?=
 =?utf-8?B?OW53RWhJSzdJd3Q5ZThjZkdFSis0OWN4a2tKRURIMHRQMGs0RytRblZQdkRC?=
 =?utf-8?B?Yk0rbHpGTFJ6b0JEZG1CVnhSWG5vM0dzeHg3UkloYXB4VWs5N2xrMUt1M3pH?=
 =?utf-8?B?VlR3cUxkTHJvYVVJQXk3aytUNEVLTURnWm5MS3FWeERSRS9BNE5mM3VtVFI3?=
 =?utf-8?Q?K2cI=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e623e5c2-f775-416b-1512-08ddf79d2411
X-MS-Exchange-CrossTenant-AuthSource: IA0PPF9A76BB3A6.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2025 16:54:04.4967
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vHgdIe7lavAKkW902GbGfsXNHlPZMm/pnJzEvJ/wJDlidOk5KbaykfV50Y+aje3R
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8897

Hi Reinette,

On 9/18/2025 12:15 AM, Reinette Chatre wrote:
> Hi Babu,
> 
> On 9/2/25 3:41 PM, Babu Moger wrote:
>> Smart Data Cache Injection (SDCI) is a mechanism that enables direct
>> insertion of data from I/O devices into the L3 cache. It can reduce the
>> demands on DRAM bandwidth and reduces latency to the processor consuming
>> the I/O data.
> 
> This copy&pasted text found in cover letter and patch 1 and now here seems to be the
> type of annoying repetitive text that Boris referred to [1]. Looking at this changelog
> again it may also be confusing to start with introduction of one feature (SDCI), but
> end with another SDCIAE.
> 
> Here is a changelog that attempts to address issues, please feel free to improve:
> 
> 	AMD's SDCIAE (SDCI Allocation Enforcement) PQE feature enables system software
> 	to control the portions of L3 cache used for direct insertion of data from
> 	I/O devices into the L3 cache.
>                                                                                  
> 	Introduce a generic resctrl cache resource property "io_alloc_capable" as the
> 	first part of the new "io_alloc" resctrl feature that will support AMD's
> 	SDCIAE.	Any architecture can set a cache resource as "io_alloc_capable" if a
> 	portion	of the cache can be allocated for I/O traffic.
>                                                                                  
> 	Set the "io_alloc_capable" property for the L3 cache resource on x86
> 	(AMD) systems that support SDCIAE.
> 
>   

Looks good. thank you.

>> Introduce cache resource property "io_alloc_capable" that an architecture
>> can set if a portion of the cache can be allocated for I/O traffic.
>>
>> Set this property on x86 systems that support SDCIAE (L3 Smart Data Cache
>> Injection Allocation Enforcement). This property is set only for the L3
>> cache resource on systems that support SDCIAE.
>>
>> Signed-off-by: Babu Moger <babu.moger@amd.com>
>> Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
>> ---
> 
> Reinette
> 
> 
> [1] https://lore.kernel.org/lkml/20250911150850.GAaMLmAoi5fTIznQzY@fat_crate.local/
> 
> 


