Return-Path: <kvm+bounces-42574-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 10DD5A7A245
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 14:00:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9AE50169A64
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 11:58:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2EC824C09E;
	Thu,  3 Apr 2025 11:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="a3sIIb8K"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2047.outbound.protection.outlook.com [40.107.94.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EE9924C074;
	Thu,  3 Apr 2025 11:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743681500; cv=fail; b=l4hWtoPamQPKmClSHTzNCBrHRtW+wcVXjGxMrjNk6QM6ErB0AvgojGjvcdsOap4JEfUQ1qNFsJaRr9GWWLVpJcEKMP9GB092H7Sf6YjXHyATUzdxtRMTGq4BNBd9l3XtdIAXb4J9ofJfy8NyqiEhO1PxvI3KolGSLPhyz30xnLk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743681500; c=relaxed/simple;
	bh=ZUuOCZPhAkDEOxeV1PhT9ooaGsSyBl2IWo2u1Ig0Gb4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=GBkJrLe6+cx3eRatpqV9LBIf0I0+Diaec5jloT5jrmTYBYu5bltnlcQOoyw6Pxui/RF5UiCxmo8XUoOLK3tbAwoUIbD/aRIH7fzA09N5YACIF3EnFBnKlYUCq7Kd8Qb9o1Rq5C77FXlUTS0WSAPIimBghqMer/Ezf1FdUxe0rtI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=a3sIIb8K; arc=fail smtp.client-ip=40.107.94.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YoDfX5zXCDgfmJvWYiuGutQ346+FtdZne2JbnzxV2AtehHuxJ7sTRRN9U4RckQf4t+SkNQoOz/XHSuoj2wiMvbnJegwazVVl9CjfFLXAT3hcrCNgWDdDpTotKzpodQOLH/dk8IV/kYK+nsEmTQpmpR0B+Nx7vnsbi2QGSR9/ccTElUlp8vsipBLtS8LntqMSh2F00+8/pFWZdc2vvE7+yvpidNb5syXmH3R3VWweuC58tRnNVY681hVNWPz2bJ8SxHF+yYE1G6wNWUgPfqcKtQIQnuGOdzMMtcwUbzciGrIEu0JRzE8XXT4jb6Y6muVvy/kXIzKL0Rxv4Spslr8M8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+CuShASyKi9rGLyK1CrH5z36A/Lhu8YQ80zaGHwvMw4=;
 b=VZc+wVKFqI/2y9nfnxqBHQciW83B/bHJN+eqlNU4D/OhVCN7L36Ef6F/2YR8cLtdns0/HlmgY85jvinFN01j57NXXTyP2yGV06xrzwy4Moyz7QgAJS8SNUKSqacmQ3AsK6iKtIfBXN+z7X51u0Aw69ucrhmXfFxd/B4svicFDa7wDwb/XJhID0DbTic4JWmZWeH5EVhBqqVe7x6scIglYhUV+8GMPZvYDJH1ULWBvyZyzAhrhD9RJRleRIrlXxcMRUeKMN2l1huqPHGoVoop7egaYygWVvhSZr8bTfCEVtYemKwoYj40jOI6MxFajMM1HAytDNtuQa/xYcxPplX3iA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+CuShASyKi9rGLyK1CrH5z36A/Lhu8YQ80zaGHwvMw4=;
 b=a3sIIb8Kj9cERDAcWQqZz4QCHj42vMQdLiwkbedlCVcbdN1k53rS2YZbmQJIa8vGmHoCqiBeQTSDEubywvLQfpYOgodfnDkog9o916usmNd30RBZRLmg67QIpAf5AFNCYA+XCUuFydrmImwOiWMDkycmtRTrZLd4P0Xf75ah/mY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6608.namprd12.prod.outlook.com (2603:10b6:8:d0::10) by
 CH2PR12MB9495.namprd12.prod.outlook.com (2603:10b6:610:27d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.50; Thu, 3 Apr
 2025 11:58:14 +0000
Received: from DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627]) by DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627%4]) with mapi id 15.20.8534.043; Thu, 3 Apr 2025
 11:58:14 +0000
Message-ID: <a63c260e-0d30-4f88-becd-69b40157ff57@amd.com>
Date: Thu, 3 Apr 2025 17:28:02 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/17] x86/apic: Add support to send IPI for Secure
 AVIC
To: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Cc: bp@alien8.de, mingo@redhat.com, dave.hansen@linux.intel.com,
 Thomas.Lendacky@amd.com, nikunj@amd.com, Santosh.Shukla@amd.com,
 Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com,
 x86@kernel.org, hpa@zytor.com, peterz@infradead.org, seanjc@google.com,
 pbonzini@redhat.com, kvm@vger.kernel.org, kirill.shutemov@linux.intel.com,
 huibo.wang@amd.com, naveen.rao@amd.com, francescolavra.fl@gmail.com
References: <20250401113616.204203-1-Neeraj.Upadhyay@amd.com>
 <20250401113616.204203-7-Neeraj.Upadhyay@amd.com> <87y0whv57k.ffs@tglx>
Content-Language: en-US
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
In-Reply-To: <87y0whv57k.ffs@tglx>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR06CA0010.apcprd06.prod.outlook.com
 (2603:1096:4:186::6) To DS0PR12MB6608.namprd12.prod.outlook.com
 (2603:10b6:8:d0::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6608:EE_|CH2PR12MB9495:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a20fcb9-75aa-4972-7417-08dd72a6d014
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?clVHTDlFK3VtbmsxdjNCUXZVbWNIK2wya1dtL0gvWVc4em13b1E2SDVVTnhF?=
 =?utf-8?B?Qlh6cXNVS3czMjZSb09OZ2E1RW9qUVJ4QkZRWnFsczZyZ3VyNTV3VEVPUlcz?=
 =?utf-8?B?YnVhZmlSWlBRK0RTdTNTbEJEL1Nodms1ZnlVb0MvSkdmRDhZY2d3NmNQTHB4?=
 =?utf-8?B?RzYyMENUMnhHbEgrbzRvNi9wTlhlbVJhSjFnNXozbE8yRTNtMWVCL1E2TUpJ?=
 =?utf-8?B?V1dLY1BYNW5DQ1N2dm5YOVJ6SHdZQW9zaEJMTG5qWm4ycCtWaHNpWHhRUFNp?=
 =?utf-8?B?enVWMEIyQ2Fwek96S1EvV3d4cjBUdDFSbE1zQ2hnS1hralF4OElzSHhPOWJB?=
 =?utf-8?B?emc5eVl3NkxpUUdLd0ZFejdsMG9nZ09qdjM3dGtqWC9yUkJwL0VPcmxhSWVp?=
 =?utf-8?B?YWY2YVhrY1JIdTBhWFBiSnlEcDBkZUdZR25TNXhNekJCd3FmVVNQZDBITVRa?=
 =?utf-8?B?TCs0bk81N2p1aldMcmNNdHY2WkZxZDEyMnY5RG5DeTZiWm1NOFpmSUozbExh?=
 =?utf-8?B?WGw2YXRxT3pVdStpVExMN2hxckdDeFJFcHRFWkw3Wi9uZ2Nwc2hRak5LZHpK?=
 =?utf-8?B?UFoyamoyV2tmNFlvSlVCTlBrbnFQTnBLRXl0ZmRMZDB3NTFDcFAvSHNZeWl0?=
 =?utf-8?B?YXpPdjhISVhya2g1NG5QNFhrQ08xTElvWTNKaFJzVkswdnVQdXlZZDhhZFJB?=
 =?utf-8?B?eE9lbEF2OTJ5c2lvVGpkbndZVk94TkJON2ZsbmZNelI2cUZmVmhKOFpnS29O?=
 =?utf-8?B?K2l1TnlrNGxraTFHcjRXUHdZQVhQUHV5THFIdkJmVS9EL3FFQTBYYWYraENt?=
 =?utf-8?B?WGJjb0ptakRmYWpsYmJCNmdSTW9pU2VHUitvLzErdHhtVytIek8rQ1RjS1d1?=
 =?utf-8?B?aDdhK3V6KzlCa0h0U2xxZDVSekorSWxjWEh6MVFjMnFPZXZyVFFxNEJFUXp5?=
 =?utf-8?B?dmNDWDN4MkZsdlNaVzBzbjAyQjdMcmVzV1dhQmZUUmZ4MDRFMnFCdUpWd0d0?=
 =?utf-8?B?dmxNb3UvVWZwVVhRaUllcjM1SmI4T1BSMENXNjdYSTRtMzhZU1hMamh3Wk9W?=
 =?utf-8?B?Nm5uUUFzTmhsOSt6YXRPbS9tdi9xS0M1dzh6M3lKYVJJZ2VDZm80U0lIQk9j?=
 =?utf-8?B?OWtOdlNLRWNlczBObzlYa0F1S1c2QTdTRmVuNzZ4dURZRWtJQmxiT25Vc1Va?=
 =?utf-8?B?UGJ2amJYaHBScVBrNTByWFpTTmRmLzFxbnE4Q3Zid2F5YlB6eGNxbTdkbHV1?=
 =?utf-8?B?MnJkZTlkN2lhN3VManhmSXZNVUVLQ2JNaW05RGpzamIxd3BhdTc1dFFjVXF1?=
 =?utf-8?B?Wi9LZXlLVmU1YnFZZ0tpOFlGcTRKbW1NQy9KcVZBZGpDQi9WVjdGaDA2eU9j?=
 =?utf-8?B?NE5FNDQyYXdHbzI1T01qWFdVQTQ3VGJHNXE5ZXZqZGdDVFhYTDRybU00UUE1?=
 =?utf-8?B?YjRhSkVUZ0J6YVNNMlNYWGw1RVFEZnhld1dmKzNsRkhGaWhOYWd4VkZTWHFL?=
 =?utf-8?B?cFVtZ3JWYkVKWHMrNXBUUSs3WGN1c0NPYkgvbnd5QWErUXlOUmV1RDdnSkRz?=
 =?utf-8?B?WisrVDRpdytvc0NPSGpVR0VVdkJ2cjNrYVo1blBKU3JRKzg2WDhQT2JnSkd6?=
 =?utf-8?B?VmdiaVA1Z1d6YUlNOUFVUEJxNXJjYUFCRUpGa0ZQdGpiOWV2Y1kzOUtreHZ3?=
 =?utf-8?B?eTVRa3ZVS3E5SGNTajdWRExBdDBHd1JGWnhJTkU2c0ZTV0xFQ1JtMExXcHcx?=
 =?utf-8?B?RTkxRXJDdy9YMEpDeGFzYVVxbW04dDhxeG1oNGQzckJ1dzNSbDhaQWlFRHhp?=
 =?utf-8?B?UVNvaFVCMnVodnVBaUJTRlpEakM1Y09lNTR2VFpDYTBMQ0hCcGlnb3NwdW11?=
 =?utf-8?Q?UGS+tmm6jmP7m?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6608.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NTVIL2MwOTkzMjYvSUxaVnRuNFBDWlZpNkN4Q0ZEbUNvR1R1THpWMTQ4a1lv?=
 =?utf-8?B?YUpjRnczdXJOWGRQM0pUQ0ljQXErRXVLVGt1dmYrdDhxa2tvNmlZZUlUT3c5?=
 =?utf-8?B?ZnMyMHNlY25JMnUvS3dBWGNPMmhvd0FqUzVNVy9Zd3ozSGFVWUxTRCtxYWZm?=
 =?utf-8?B?SUhodk1HSWNZS0I5VWhFSlR3RVpQNGdTZC9ZK1Q2UnZ5Nlp5eXdKTHhtR09H?=
 =?utf-8?B?Ym01Tms5VjhhNk54UXQ1RVIzVDh2Rk42NTdSS2lBNERmRll2bVY0V051NW1x?=
 =?utf-8?B?Lzh3OHZzQy95bGZJSHpKTFNVeGZ2VnMyam0vRVRYY2pTc3lOR3Exc2hWVnFl?=
 =?utf-8?B?Z3Y4emtMT2RmcVlZcDNxNmtVWkZvTDVOWDJGZGs5cjZWenoxSUd6eXdFbzJO?=
 =?utf-8?B?dVYwcU40ai9XQzVKWFdlM01WZHlHclBRNzVXSjdacXBFcVE2VW5nQUp3Y1BV?=
 =?utf-8?B?MFVqY1pvUDl0UFVpZUFBd0FEdzVtSm1OU2p2V3R2N2hXb3dNajgwNWhkMWJD?=
 =?utf-8?B?SUV0YXJkZWdnK2RIb3JSbzRrV3NaejZWbkJYaFY2b24vWTMrVUJNUWZPZVVR?=
 =?utf-8?B?bFEzazA5bU5pOXFUNjlWSFZaMWVwakRITW9NTnFUN2tuZDdBdEliQ3AwM2w2?=
 =?utf-8?B?VmFNdnlMc3dzNHVta2VDSlJDWWNoSXMrYm1FNmRTUnVtbWppQlE0VHc2YUds?=
 =?utf-8?B?U2NIMTJBS0tkdGNGcnVIZURiOHU0d1VUbWdFYlg1d2hjaHlYcTc1bW9xKzZ4?=
 =?utf-8?B?c1FDOUFFT1RmWVk1MzdKM3owVXFnT0NmTHJtUVEvbVZvdFRRdWJZM2NWbUVh?=
 =?utf-8?B?enMrenJnRklJelpvR2g2bUNwS3VkSFBnbFh1TXJ6WnBiaEFUWlF6Tm5DOFFz?=
 =?utf-8?B?WnNUVytDdm5XNFNTWTdGbmJ0bFdLZjJkUHhRbDNBNzNMWUtiamtaS1VHK3dx?=
 =?utf-8?B?ZkVraUFrc3VtMDNJYjE1UUdEVzdOcm54L251cEY2VEZWc1YyY2dXendtK0Jw?=
 =?utf-8?B?U3JIU1pzWGFPODd0ODNEb2lteGordm5NaDJNTWcyV2hWS3JONlZRQUJtLzhq?=
 =?utf-8?B?cEJCYzk4UHhGeUcvTWtWTGhBK3JRMkkxR2RSdCt1LzZjdStBZG9XNXk0Y1NB?=
 =?utf-8?B?SjhkNUVWRWp4MGhkdDJGSmdrclVtVkJSV1BrZENvNGl2dktCZ0FIZllqM3hY?=
 =?utf-8?B?N3YrQ1BzYXRJeFZMV1VRTFhlSGFKVzhPNmRNVVBTQVVTK0VPN0wwak5hRkZV?=
 =?utf-8?B?MGQzeXRMN29jaFQxcnFtYi91YnlSZnUyOVRXTG9NSSs5ZXRFd2h5WThscjNy?=
 =?utf-8?B?eDlpU01mY2ZkcC8xZ3lxY1UrMUl3MFh2dDdSUHh0ejJDTndGSUR3ZDVhQ3Bv?=
 =?utf-8?B?ajJwN3dXRUsydytsbjZONGdJTzdLRytEV2R1SUdNdGc1SXlzZ3NTajFZUURt?=
 =?utf-8?B?RW9IQ0l3WEM2RENlQmhBdDVhZU1kYXlZTm9NV041ek5hUnNMZFBraW9nOFpO?=
 =?utf-8?B?TkxNbkNmdEUxN1VRcFMvZVU3YTdwS0V2YVZNMC9KRkxIN2VORjNBZEVKM3dF?=
 =?utf-8?B?clVBMGo3QWVsU2NFclgyb2ZQOE9UZWM1NGtESmY1WEFVNmZ2QWxUa2t6T2dl?=
 =?utf-8?B?RmdMOTg2ejZTdktnY0plR2VwUGtNaDdpUk9KS1BNaFpQZnNza1RPM284TFFL?=
 =?utf-8?B?Z283K0x3U2Z2V3pDM1AvNVdsL21IVXIwTzUwY3FGclRtZTJxRFQydHBtb2sy?=
 =?utf-8?B?QkNBbmsvcmRlZlZXTnZMUFRrY09PWm9CVC9vOUNOOC9HMHNmaVdJbi9waUx0?=
 =?utf-8?B?bVRVM0NtUTg4dGdSdjhjdVJEVzBlbHRDVnkwYWVqSUJlZ29QWGlXUjd4eCtL?=
 =?utf-8?B?dWlqL1p1dzd0eHBZTW5hdUJlSTRBNG12NnplOURwaTJlNE9nUGFzb0tiamdG?=
 =?utf-8?B?UHpkYnV5ODJBcnBhaThXV1R2MndNNklzSmRpTXlNVDRLb3d6eGltMG9yOWNJ?=
 =?utf-8?B?QnJvd1RiT3dUVmFTdUhRWlgzd2xxbjZUWnI5V2QzcE1ZY2hHTnRCM2NRNG9H?=
 =?utf-8?B?dDAvR2EzY1RiWWE0UzdHa2g0dzUrTlBGNldUdDh4QnRnaXNKWGZGQUJBRENM?=
 =?utf-8?Q?kV7nm/N4bHsFNimpDbMGhaPn3?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a20fcb9-75aa-4972-7417-08dd72a6d014
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6608.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2025 11:58:13.9273
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FHNPNDQHqLGFt3kOihFevfpXhMWGNH4OHUvhK9YN9eeu/ZQ62/UrQfI+4gEVQNAmcCpC8wdTTGUnn9Zhc06+wQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB9495



On 4/3/2025 5:15 PM, Thomas Gleixner wrote:
> On Tue, Apr 01 2025 at 17:06, Neeraj Upadhyay wrote:
>> --- a/arch/x86/kernel/apic/x2apic_savic.c
>> +++ b/arch/x86/kernel/apic/x2apic_savic.c
>> @@ -46,6 +46,25 @@ static __always_inline void set_reg(unsigned int offset, u32 val)
>>  
>>  #define SAVIC_ALLOWED_IRR	0x204
>>  
>> +static inline void update_vector(unsigned int cpu, unsigned int offset,
>> +				 unsigned int vector, bool set)
> 
> Why aren't you placing that function right away there instead of adding
> it first somewhere else and then shuffle it around?
> 

Ok. Intent was to move this logic to a function only when second usage came during
the series. I will move it to "05/17 x86/apic: Add update_vector callback for Secure AVIC"

>> -static void __send_ipi_mask(const struct cpumask *mask, int vector, bool excl_self)
>> +static void send_ipi_mask(const struct cpumask *mask, unsigned int vector, bool excl_self)
>>  {
>> -	unsigned long query_cpu;
>> -	unsigned long this_cpu;
>> +	unsigned int this_cpu;
>> +	unsigned int cpu;
> 
> Again. Do it right in the first place and not later. Same for the
> underscores of the function name.
>

Ok. Another approach I was thinking to try next was, to remove IPI callbacks
definition from "01/17 x86/apic: Add new driver for Secure AVIC" (where I mostly copy
logic from x2apic_phys.c) and add define then in this patch. Then the diff
will be clearer.


- Neeraj

 


