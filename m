Return-Path: <kvm+bounces-29331-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D40869A97D8
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 06:26:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 85B4A2849C9
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 04:26:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1191684DFE;
	Tue, 22 Oct 2024 04:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="2+QDGl8d"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2081.outbound.protection.outlook.com [40.107.243.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C062E38B;
	Tue, 22 Oct 2024 04:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729571187; cv=fail; b=i4Qg7QbErXW69S5/H2uOdAth/JuvxYqEDfe/UoD92YibWrmss+2+CgwqqefAyvSQgGoTyAVbNHqnqz9MW5vByYF93n4GVSVzKsn2SaITl+mG07DuDTU7H57SP/AHkmZmbyqjW4SdfSAiYa7mKDgkGXTnRENRzeJ7djV+q3jUM0s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729571187; c=relaxed/simple;
	bh=2cLxRC5Q2YZPbhExmV/yFZY3JbmYmAY7Y3oM4uF2+og=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=pPhyBHFH9jAc37uAoKsOiWTRXnIEvcgTFc7q/FbN9WlqELifdCg5boozI/d28qudU0MWPibdy8Xt6M/GYzGpfeTntmDz2puID3t6p0X3cOyKamarQVvOuydXaiLLrN+g3ZUZUs4gM8z28JfGnfb5twJryGtlqFcgdG1sdGzW5WI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=2+QDGl8d; arc=fail smtp.client-ip=40.107.243.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iCk+Apx8OxmtSy33+IzVqccQxfGvX6E992/9m/cdQV4oX4rlN5cKbMjh9UojBg93MZv0EAX1fdE8BKrtXvYfNDwVHvzZcuH4yxUtbjBtw7InSj6ZGpJVCKLmIZAfk4QirhLWCpscOGCEFqDXs9AalQyw3lC1Z1srlmec/fhP3N3s1Epf3xsXIL0z4GXm6ugIb/gXLL/1kb4kWmlUqE08fGwKj3PHrGsDpogWfbiQn3yBIL6UlLeB66w6LrCfXeDxHtgWL/fo7LtVfNn7CR+YjfXd/9zDe9Ul6sl6litLBorLTOtrDv3HsSYvAw4UNDZpK3jN18RuwpTKrRCv4rFHEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+pjMxNI2bfa3bgns1AWNF6CYiWk5LGfU05U79+ZEPXs=;
 b=Zzna+3+IORKDWSl56u7QCzMEVlzSC0obKJTq+KG+gI+Q1+Nfccd6LkX9qLqTpeRt/CS8ana8xHfmUcOaIewZP3ixOSwyUozxejRSVk/jFh6pYSjqsdMBG//ZJiaReZYnJwsri6a3OoKJ6jWkI0+YSf/kmyW/Hln8fJHblnRhoVTz3e5V6RcmlRuWlCCtJAVnCaalRetDiJl/hnmuWolWQPG0/rDUPHwcMsZtIv8antPjh4B44VdVM5ubzN4y46tB715m8c3iJQX6B4G08VigLrXLsNFibo8gbzYE+c+g3iCdQXS+TF3IXwPnX0TyBh3e6W4vueaENP496T8p2sxmfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+pjMxNI2bfa3bgns1AWNF6CYiWk5LGfU05U79+ZEPXs=;
 b=2+QDGl8dVXK3GBvf+I7qIm6kIrd3KHMfU63xar2TxIIuKLGFFAOd4DNEkYhxTx/iRfu0546Qw/ayu+pDRYF8hSE0sJQgHrm1YQw07wdejbLg8nhwbu2jRDwl7hY5zm4fDlG12+wCdKwUuavMtMMTcz5cJJOvlnJ68rsxfuRj0mc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 MN2PR12MB4320.namprd12.prod.outlook.com (2603:10b6:208:15f::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8093.16; Tue, 22 Oct 2024 04:26:23 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%4]) with mapi id 15.20.8069.027; Tue, 22 Oct 2024
 04:26:23 +0000
Message-ID: <15253a9f-c95d-48c0-c49b-25c8ddf9414e@amd.com>
Date: Tue, 22 Oct 2024 09:56:13 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH v13 11/13] tsc: Switch to native sched clock
To: Tom Lendacky <thomas.lendacky@amd.com>, linux-kernel@vger.kernel.org,
 bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
Cc: mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
 pgonda@google.com, seanjc@google.com, pbonzini@redhat.com,
 Alexey Makhalov <alexey.makhalov@broadcom.com>,
 Juergen Gross <jgross@suse.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>
References: <20241021055156.2342564-1-nikunj@amd.com>
 <20241021055156.2342564-12-nikunj@amd.com>
 <04684b8a-c8a7-5d4d-de8d-16b389d0c64f@amd.com>
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <04684b8a-c8a7-5d4d-de8d-16b389d0c64f@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0199.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:e9::9) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|MN2PR12MB4320:EE_
X-MS-Office365-Filtering-Correlation-Id: f65e9a3e-d36c-4500-0f26-08dcf251af65
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?S1NSRU9qNlZTT2ZEL25WMmlKTzlnbW9nM25ZWks5TzRscUcxQkYyQkc0eU9G?=
 =?utf-8?B?VHNoUkN5OGpDK1RtVHdGbFBremVnTXpvY2JSTjhKbUxtYkUrbVl3ZVlaWjFx?=
 =?utf-8?B?K25WS3JTRHdJSlFIRkRuc05WZGhVNkUyMFFnZUFvcWFrVFBXMks0RUFySTd0?=
 =?utf-8?B?QUt5d3lGSGQwZFlTVUZjRG05MmpScnZWaUpmYkVCZDBxQU43S3lrYS94RWZD?=
 =?utf-8?B?dEtDWjQ3bFZNREduc2hqTGtpb1NVemYrenhOdFlUUW0vT2J1NWtRQ2V5UmlY?=
 =?utf-8?B?ckNBMmVDYXRmN2lYa0toQit1dXRTUzRSdnlXOGdzdzJWdHU2NS8weEF1aFVF?=
 =?utf-8?B?MmltaXRBOGwxVTVUSXdWSWJBV2drMWlLY01RR2ZxU1FmSStBRTJTUldtZnZE?=
 =?utf-8?B?OE9SbEFXeFgzdDYvbHg0ZnBjVVQzZUFvWHppNnNvbVY3NjNieStNSUNPM1Aw?=
 =?utf-8?B?KzZ6bDRyTzVUVit0aEdiTnlpS3ZqK2FXcmtjY2kzUmhVMk5ienFBL0R2dzZr?=
 =?utf-8?B?NmJiYjVLTzE3cG55UXZJOWcza2xQbVdMZlROekc0ZDlUMkpsbWkvYzhqTkVZ?=
 =?utf-8?B?WUxLOVVDeWpmMXBWMlFYMkNjWWdFWnpGVnFrYnlocHRaUnZKQWMvcWc0WE8v?=
 =?utf-8?B?b04wM1BsSDVhdE53QnFYRUg1RVRvVUNKRkcra1BXZjdMZjJrQ1FZeStGbnBv?=
 =?utf-8?B?WHQ5TmF1dFRIbTE2bm9TWHVpRWM5Zk9HYlJyYjRUMzVZN0t0dHhjUThsYi9F?=
 =?utf-8?B?OVRCOTI5VWI2NnpySUZRVnpOTC9zUXFob3Z3QkNwUGpNRFlHbEsvQWRLazNC?=
 =?utf-8?B?a2Y0RFM0bC9TM1dHUFJkZnFTSGxYem8wVFZKSUs5MWpmT2FnSEtlWG5hV2JS?=
 =?utf-8?B?VzZKN0gybFYzL1lFbEtoODNPR2RNTGV3eVZBb283cXRKa3R4VEczUkxwbjU3?=
 =?utf-8?B?TDZNaXVFVy9mMXkxUFBiKzNFN3ZWbURlN0x1aytadkxXU01tcnhNWXV6NzRG?=
 =?utf-8?B?bUFzTDVIOTNodTBLcExrY3J3Yk9EMFgrcnpxaFEzc0xYY0ZtRGlnUUlOd281?=
 =?utf-8?B?c0V0ZWNYS0VDV3h3R3pvb3lwNHMyMG1LUkp6OWxBRzR0R0xuZDlPV09HSE9p?=
 =?utf-8?B?ZHM2SFUxcTQ1K3M2NUlXQWI4UEhJWXhHNXN0NlRPbjR6ZEhnWGlTS09JYkhU?=
 =?utf-8?B?TjNIV1ExVXVVd2kvK2JFZTB4ZVl6djlYaHQwZkpnSnJ1SEpzRTl2T3o5dy9N?=
 =?utf-8?B?clpnTzc0ZFFZcG1MN0NZTEdwSDNBMklpMHBHSkRUTkcwOTdBMU5nTGFWTy9I?=
 =?utf-8?B?RWt5L2Y0RnAzRHhDM0k4aG5FcndldjAvTHVsc0s1WWZlQ25rSGx5cVFrRmk1?=
 =?utf-8?B?YSthYlJMTDRXQjFtQzhuNERNTUtHSFBRRnltcmE3WVZqSkltcjg5Q2lKaExC?=
 =?utf-8?B?OHJCNWptYVd3UVFVeENrSk5DSTlUTXpYOUJkcmVYeWROZ0RhTnpQTmFoMzR2?=
 =?utf-8?B?aEVSK2RUWno2L1JiRjJKREp3VkxUWEYwUk1LRjFEVzFuSXljU3RNTzhlUWMz?=
 =?utf-8?B?Qlh2Wlkrdi9XWkM5ZFlkdHV6TmlRZXFFSnFYc1pzZzJFZU05bU9VaFg3V00v?=
 =?utf-8?B?Z1NEZUg5aXZqdUsybG1sRjBYVG1hNmNQSVFPeUFyOUN0Q1JNN1hNTDMzbnJS?=
 =?utf-8?B?L1JPbStFMURZL0M1K0RWRlJBV2czdGtsOVBsaVpURmtXb1JKVWMzSVJLZEVp?=
 =?utf-8?Q?HRoBUsiwBoFvyE+ch4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZEVybEU5dTlYWngyVHlERHFna1k1M2FjNEdiRUd6Mkt5TjRDcmhwbmlneW9M?=
 =?utf-8?B?SXJvSXBQNnFOUnAwc2pkQ0FMY2xXMEgreGR3VW1NU2Q3UmNqLytnRDVnQnZa?=
 =?utf-8?B?Ykhla2NvSlJqUU5FM2ZJTXlnQ250bzBXaDNjcTdnK28wMEdKallLdW82OHEv?=
 =?utf-8?B?aEVxK1FRTGo1SDVCV2pFVDh4QlZ1ejY2aWd5a0orMVh5bkRlNTlVaXJqN1Bx?=
 =?utf-8?B?UVc4T1dBM1E3US9aZngwUysrSG5mSkRSK2haUWthcjc4UURhUWVHSTE3MDBN?=
 =?utf-8?B?VDdHSW1QQXBFbWtEYTNLS0FKUGlkZEN6NlNQNS84cG5ackdHajNzMXkzUHI0?=
 =?utf-8?B?b29DQ0x4eXh2cDFYR0xpYWpVdk1DbE0xMFlqZ3VMdklkckpFSUprT0JONXhm?=
 =?utf-8?B?N2JlbzcyZ0FWZjNDN0VWampzZUhZYk1tQ2xyek5zc2hWSlFEN2pkTDZ0Smpj?=
 =?utf-8?B?WXQ0T3EvbFBuODhIY1daa3JmQXpXM3F3dUh0S3FrYmVtTDlLdG0ySythcmZC?=
 =?utf-8?B?UjF1b1NkTmpaOURDaE9SR0krZGw4U1RMQ2YrR1hZSnhZbnlSbTFiZ3NpV2lR?=
 =?utf-8?B?VnB0RVh6TVNITVJ0TVZuM2NERUZNMnFvdGdmdnVCWjJNc0NUQjJSOGhsbEJk?=
 =?utf-8?B?T3EvMjFwZk4rdkwvYnl0ZVJQVU91VDBieFU0OHl5Ym02eERLZlhvYnRWOTRu?=
 =?utf-8?B?aVJWdXJiZit5YjdKWXhEcFRDY0tQUi9YVkxZTEdaNEcxZjgzbE9sVUdZRVA1?=
 =?utf-8?B?NFdRVzA2UUhtcUFTRU5kWWZzNGM4NUhlV3BGeEdpUjVmdzd6VU56U205UjJj?=
 =?utf-8?B?blBqV0FTQVFSbUNxSWNXcm9TZHdlQ3pBb2tka0dpQW5JUCtBaHd1WnRJelh5?=
 =?utf-8?B?V1dUYTVXLzEzblZTd1VyME8xMWo0dXVrdi9pYllnSlBoOFEwV05sMFBZU2wz?=
 =?utf-8?B?ekxZSlEwY0VoY0doV2Nzc2xjTVdyekFxUzJmSTVpYWliVkdwZDUwM1VkbUQr?=
 =?utf-8?B?MlVXakViaTk5NWdiZXZiNUFURDBUNU5BcU9vcEk4RGtjRjlIV1JKUHZxcmN3?=
 =?utf-8?B?dk5UeGpxbHpVSkZiOCtkSUVtYkFadTJiazFBNXAxK0FHeGJ2TmI5N0lyL0lw?=
 =?utf-8?B?YTRCNlkwWDVHeTI3Y2llVGlHSnE4R0xwQytrVnp0ay9uUGNHQVR3bk4zWSt4?=
 =?utf-8?B?SW4wRThzdE9GRlZxMmxyaWIxM2NTbnlvU2xyNlpGUmprZXNHb1JIdHJZdVlT?=
 =?utf-8?B?UElkVmFXbWUwNlJNTS9ielhBTFNaVFl5THpSb1BmZlR2K0xPc1JCSlNXM0RN?=
 =?utf-8?B?bEd0Q2NGSFBMejc2b0VjdVlzbVNGdUQ3eGU1OVJ6NUxOS2owWFdUaFJIRi9Z?=
 =?utf-8?B?RVFzQTVPMVJxTjhsYWxtZTFVRitXVXp0Z1d1MTNaajBUa1A0L0lVQ1phLzZN?=
 =?utf-8?B?RldyWmFySXR4YTZzclIzU3JXVS9OaHc3V3lYa2FNRXphSmpBYXMrNDlhVlp6?=
 =?utf-8?B?NCtQU3JQVjhVTVlOREh6N1p3V3A3b0xaV1pxTFlPd3lpUTdSVVAwN3BGcmlY?=
 =?utf-8?B?MzcvUXZ1dnZNdFYreFI5cElCYjV6Mlp0aXN0ZW5ObGJFc29vNEZWVWUrVU9a?=
 =?utf-8?B?TWJ2ZkF1bEVqUGhMaTNqTFByVnhsdVk2S25CbW5YbUVqUjBhL0l5YXdZRWxt?=
 =?utf-8?B?UzBKN2JmcDR4aXViWkJnRjk5dGRRMmQ4RUUrd3F6bjlhL0NhZFlXRjFDblI5?=
 =?utf-8?B?RXFJSDBHdE1Nb1QvNUxhdFJVN1EvNVI2U09aNktsV2cxYW84NkNUQzlYR2ZQ?=
 =?utf-8?B?b2dDQStIbHlyNytDejJEUHlLRHQxUTN0TW5xdWNDRDk5VGJBbVJYSlJFQTdh?=
 =?utf-8?B?Z3NQSkliZmc0eFprbklnTkcxb2NCSURpeXBzekhQRlZrTDVlTlhTR0tlZ1lE?=
 =?utf-8?B?dmVmMDZpWVdodU1lQUlVOCs0Y3BnQzJLTHFOMWJidCt2SWlSWTQvSmZ4NG5C?=
 =?utf-8?B?V29KOFMvak9kRzV0b3pqeTlDSUxiVXA3QlkrNGQyQVd1QW1BbnE1OXhudEpo?=
 =?utf-8?B?ZzlFVWtRRkVpYUpNbWdBOG10UER4eUNMUWR3N3BIdkkwMnFidEYxSU9KYnls?=
 =?utf-8?Q?tdPMINsWZ5XtjaianNFFKYq3/?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f65e9a3e-d36c-4500-0f26-08dcf251af65
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2024 04:26:23.2437
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4FArS4e3jwKX1L1kqwNRSlCJswUUzi2flt4APD+T6Ctfymab0o8s0TqXtO27Z7Rb8Y+U02hEvVs+/02eaTGFHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4320

On 10/21/2024 8:07 PM, Tom Lendacky wrote:
> On 10/21/24 00:51, Nikunj A Dadhania wrote:
>> Although the kernel switches over to stable TSC clocksource instead of PV
>> clocksource, the scheduler still keeps on using PV clocks as the sched
>> clock source. This is because the following KVM, Xen and VMWare, switches
> 
> s/the following//
> s/switches/switch/
> 
>> the paravirt sched clock handler in their init routines. The HyperV is the
> 
> s/The HyperV/HyperV/
> 
>> only PV clock source that checks if the platform provides invariant TSC and
> 
> s/provides invariant/provides an invariant/

Sure, I will update the message.

Regards
Nikunj

