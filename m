Return-Path: <kvm+bounces-46646-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F1F64AB7E9B
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 09:15:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 06DFC1BA4FCD
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 07:15:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0E981FE474;
	Thu, 15 May 2025 07:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kuka.com header.i=@kuka.com header.b="nCYr6r4s"
X-Original-To: kvm@vger.kernel.org
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2073.outbound.protection.outlook.com [40.107.105.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09B1C3C00;
	Thu, 15 May 2025 07:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.105.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747293321; cv=fail; b=eTjxNJpGrRIp+x6Ox+E6Y663zTse0aySORHzNJudQx3ePFMnJsJ49MiaKsc6E49HljnuqU08m3LfUXl+y/YSziyfkVPPsi4wzeVp54HnpORQPCh4vGY9c9vAXGafqX5Wi4IPudHpUffgSzZxYSDQacNNpyMKdXrNIDfbHC/ULQ8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747293321; c=relaxed/simple;
	bh=yDx+yDj7W0/BOKpSGTO1/CB9KK+ftLQZ6AGKKj5PZhg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=UG5rDq6tYiXdIqcJbo+PlgQCCYTwWjIs+EsRV6LMP4o/KGp06CoL+6Y7fUyT1aweDVErokti5uE/7xhN5Pz564FXGF+h17BFR9Z25/B3SclaliwxX6TeKEXYJVy5zk88RfeexdBLhTlgoqqRW0ker70KgTV/xQpjEcuvBxcCxiM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=kuka.com; spf=pass smtp.mailfrom=kuka.com; dkim=pass (2048-bit key) header.d=kuka.com header.i=@kuka.com header.b=nCYr6r4s; arc=fail smtp.client-ip=40.107.105.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=kuka.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kuka.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HePs5kFj1d3iwvbPJdzvTGNLqf9XnRRG1xFbD+yXva+JtxnSQ0XZLuvZSppb5UaM/+rC4RTUMsPy9kQ8Lt2KPmhsZPxAtaOIFDaBqtAxoTJB7vRW1l7EsIU+uOC9w6du65dxLOeXHYq61K6ws0SlpuNQNZbOw8ueZGOtS/LziBnHrsFvmwYeNEisbkae5tJ7Pe5opvNS3Qwptpga2FRz3FJp6eBwfKiiTE+2cSlkHeAPM+6sUQ7KvG83KLZFEMglx2xQvM3/4Ay/nKJ2aEKil5WdfxA2F6+6yXf/OiKVEC0vqE4/6tM04sEqhqkWMbg0MG2o2p+HQSP9dZR84+T3fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yDx+yDj7W0/BOKpSGTO1/CB9KK+ftLQZ6AGKKj5PZhg=;
 b=L0IjUr4ESTNYK5x7KyfcSdQT6XJ4vyGCTLAsP07A4CR8Uy2GNQ2G/jQdIAYpnGI1DF0vZz+unDa8sMD2on677rJabs5Gg0ytQmXMBGyT7iiFpstpEn7KWL96ZpRy4IOd10HZ0fzT/d/1Ed07d341QCgNrDaqqALGBLzfqXvt7GNCiecpeq3CIp1gkUT9HHOF+Vi0pCeszK8Gj89NtV5INTwpsgJ+U7qILKm8gwhxKxp4DuX/DIz8iZ5rxGqe1Jg6C26pxCJhvegLaQh1zT6kJgThQYUIF57mGvwmg93RVy/zOPK8Mlnv4nl73rRHPcUgttmGHrF9DM5Rx9w3lOEqdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kuka.com; dmarc=pass action=none header.from=kuka.com;
 dkim=pass header.d=kuka.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kuka.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yDx+yDj7W0/BOKpSGTO1/CB9KK+ftLQZ6AGKKj5PZhg=;
 b=nCYr6r4sB4U0HpeVKKRIoI36z0OjkTePQXm8Z3RFOqV+r6v1sjDT+Onv3VJjBm8hbbrN4xkthF29D+BIyH1kvBql7fUydvP6/+YDSoDKuHx/MajDS431YqHoxPqwDHz1kQ81SUMurLERKtcrqnupJRk7Adlh4rzNFDZW0WXUQKfPZ3k2fsALAbmvJqXh7F5eTw16vLtG+/wKzRqtIQbdn81NdCkEUDoGFXNBq8ow3asIySSlx4bPMP6faF/eyfTlKUE8zbRGc+OB3Ll5r6WzCfga/7InQzvAIGqbBF/iyt8YKnakjY25MtZZnO/4vMJrf75RMp93M9ACGOTSEad7vw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=kuka.com;
Received: from VE1PR01MB5696.eurprd01.prod.exchangelabs.com
 (2603:10a6:803:123::12) by VI0PR01MB11067.eurprd01.prod.exchangelabs.com
 (2603:10a6:800:259::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.29; Thu, 15 May
 2025 07:15:12 +0000
Received: from VE1PR01MB5696.eurprd01.prod.exchangelabs.com
 ([fe80::ac38:4740:6a66:b5ba]) by VE1PR01MB5696.eurprd01.prod.exchangelabs.com
 ([fe80::ac38:4740:6a66:b5ba%5]) with mapi id 15.20.8722.027; Thu, 15 May 2025
 07:15:12 +0000
Message-ID: <b0e6ba16-9313-4e43-88db-c0b266f873e9@kuka.com>
Date: Thu, 15 May 2025 09:15:11 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: s390: rename PROT_NONE to PROT_TYPE_DUMMY
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>, linux-mm@kvack.org,
 Yang Shi <yang@os.amperecomputing.com>, Janosch Frank
 <frankja@linux.ibm.com>, David Hildenbrand <david@redhat.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, kvm@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com
References: <20250514163530.119582-1-lorenzo.stoakes@oracle.com>
Content-Language: en-US
From: Ignacio Moreno Gonzalez <Ignacio.MorenoGonzalez@kuka.com>
In-Reply-To: <20250514163530.119582-1-lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0094.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9b::20) To VE1PR01MB5696.eurprd01.prod.exchangelabs.com
 (2603:10a6:803:123::12)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VE1PR01MB5696:EE_|VI0PR01MB11067:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d2f238d-bec9-40fc-3a09-08dd93803beb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?M3ZCQnZRQXVOanIwU01YSkttNFc2Mnk5c0JNbHJEdGYxYTdFdHBYMyt0VUlZ?=
 =?utf-8?B?STFtQ2VqTDVFQUlLNCtad1pSUG1SV1hvUTQrcUMzMWpPOXBpeUtvdG9nczNx?=
 =?utf-8?B?MllGYlY5Y0Uvbllad0g2ZFJ4NkJweTdqUWl5am9zQU85Qk0rZmhPREgxeEs4?=
 =?utf-8?B?ZXMwVG10M0kzQWZKM2Zia1pLNjI5SFh6SVFuWjBiUFFKSEFoY0huTTBlbFNK?=
 =?utf-8?B?UHhHSzRhWllZSlJQNDZVbEdsbVRXRmJjUFp4Vi92THpnMVZ5ajRuNm4ySVhS?=
 =?utf-8?B?OCthZlNoNlNYVWptVll1Zm5odXFUSEx1WUdaNHhQeHRXYllEY2pZeXFiZWNH?=
 =?utf-8?B?Q1ZyMTVac0g0RnY0YVJzeFdDanhwK29hYUl4OVphRWJtaTluMVZtR1pPMzky?=
 =?utf-8?B?MHdBZEY2cVNPUWlSditFZ3NpcllvMHdDdWZGYWp1NHhFaVA4R3Q1OWhkUGln?=
 =?utf-8?B?MVFmb1Njd1V5NWRaODNhSmRSTTRTUHBFWWdLL0YyN0pkdTlPNnlJbHlFZlE4?=
 =?utf-8?B?TE96RGpBY3cveTRoVy9FQm55NHBEbjZpTCtOMVZIU3JwYm1yR2ZaNGc1U3BY?=
 =?utf-8?B?TTBMZFpwN3dTMlFIZ1djOW1wTU1UN0UzT3RPbXJjbGJjY2RjZCtuMFFaQ1Z2?=
 =?utf-8?B?Ui82N3lEbzJTeW02ZnVidEZPZHZZeTN1NkRZWSsza2ZZbUNOTWlDUWNwcVFO?=
 =?utf-8?B?MHpIc2FhcDZYMUlRdzZ4VnZzSlJyTUFwbFQycVpkMXdFUnFTV3ZvVXlWYjVC?=
 =?utf-8?B?OG1iVWJvcy9xR1F5NCttYndnQi9ZN1l3c1c1aW01S245QWw2VVg0M0lZZGF4?=
 =?utf-8?B?KzlaMjcyaUNDMXpPcm9QcHNqN091UVNib1ZHYi9lSHM3aWdQSnphOEQreG1k?=
 =?utf-8?B?aktNMVZaM3d1RFYyVnBVelpyQUlmWWI4d0taZnVrRVl4ajBOUHpEdGVDcDMv?=
 =?utf-8?B?NS8xUFRZalJ3dk9pNVVOd1h2KzdSeitJS0I2OEFrTHNGSXdTdVZIME5YR3hv?=
 =?utf-8?B?akxFYk43TlpmUlZrVE9DSWFZdkZuSFZXbVdIRGorczg3SnQyWkc5YVRNZVlI?=
 =?utf-8?B?WjBubGpaQ2hJMittbmkvSi9Ib3hOVE4vd2dmdW5zUFdEd3JYTVJPYXAzanBp?=
 =?utf-8?B?QUI2VjU4NG1aYm9ReUFWN21leFYySnd5eDJoeVR0YUVpOFd4ZVhtN1R0dmtl?=
 =?utf-8?B?cGVDTG42RUk3WVRnRTdOamRWS3lTbG5mbkR4TVVTSjh4NU52clh6cTV2UGJ6?=
 =?utf-8?B?UmZmUzRhaUE1eWZabFYyYzFGd25hZHpLYXk5MThNbEdCNFdaYjJTTExtUVlO?=
 =?utf-8?B?ZW11UGRmR2F2OGFENENya0NyclJKLzNxYUQ4UUN1TUlEdDJIUEJqdUU4QnBu?=
 =?utf-8?B?VkkySjFxUzI4cExYUjBGM240eVd6Qi9Rc1JiTGVJS3A1cm9QblhqUEZNcGtN?=
 =?utf-8?B?ZkY4dWhWL3NKcEVnRWEremVmK1I1OTUwRWFSS2lVZ2M0MjJzc2NqSXVWODVa?=
 =?utf-8?B?Nzlmc29heEtHNS80RUQ2R0dGbFhiNSszNkc5NDlZczY5NmhpdXFvWDBLa2kw?=
 =?utf-8?B?WjYzQ2k0azU2RjR3M1d4ZGJMYlUwZGxjN3dTdnE3Z0NSNStvU1lnN3JrSmtV?=
 =?utf-8?B?ZEIwcUhMemt2N081Lzd3SWJ3Rm45UnY2eGc2NURSaVU5a1o5akk3UHJHVXhS?=
 =?utf-8?B?M1BzOWxHa2Y5RXlSeWovNWZETTZtZXZ3aWNYUzdrMUJ4VEQ5dGs5SWdBUGZa?=
 =?utf-8?B?WDI2R2phOVowd2NxREVDWXEyVEZINFNEVlh3cUNwNHErbDRTTDEzbE5hcFhx?=
 =?utf-8?Q?azNhRlinNCTZgthgF37/HfuCutoUnQF33cH5c=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR01MB5696.eurprd01.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U1dqcTV0TktoaS82WkJqWTR5VmN5VWxNakpxMEY0U2hOS0JLVjJKUkhJdWZp?=
 =?utf-8?B?eElCRnF4MXFhcDFKM3pPeUZyL3FTY1BEM3picmtkdUNGbmcvcHE2NmQ0RVJY?=
 =?utf-8?B?cFlvN0pJeWw0NEpFK0g1TGJYR2F0MnRLRWgzME1sQ25WV2F3c2M0cDRKS2dR?=
 =?utf-8?B?VmorUEd2R1ZsanhtVE40OW5OZkF3bUZKNm8xYnpROFJTMjc5MzNXTTU3eXNs?=
 =?utf-8?B?QWNBOVZVNjZZd2cyNHcvczhCN1NZNnpPWjNEZkpSVzRIWnZLTlJsK2ltSDBw?=
 =?utf-8?B?TFQvb1dTSThuQWZ4TWt0UnFVcUQrWVFNVytzU0xCZVNRRFJ1NUVsMkpqQ0tC?=
 =?utf-8?B?UCtTNVZ0VU5CNFZjbHVXei9WdkgrZmVNcDhHSkM4R2lONUNTOWh1dFJMc0Q5?=
 =?utf-8?B?eUxTcjBWTUhPandCalZwUjRNQ0toK1pFQlFQMXh6TWEvQVl6MExvZExhRExT?=
 =?utf-8?B?NHNTcnUwVGErVnhMd0x6Rm95QzVmTzU0c2tGNHZEQWVybE5xS2xlUDRIOVZ2?=
 =?utf-8?B?UmN4cWs2anBtV3krd2twZU13R2tCRUhxS244ZHZ0MlZqNVBLN1AyR2IzTCto?=
 =?utf-8?B?UURMUEdNei9VWlBFNWczVTZic0VWMk56OEljUHRyZmdSejRtMXdlUlFNSE1K?=
 =?utf-8?B?emhoci96c2xXSnpud3VDOVhLcVoxcEFUWVZQME13UHhGZG56TmtPUTJnT2JU?=
 =?utf-8?B?dUhVL3Z2SjVMcGIwZWVaQy9COHYzS3VOZ0hkamxybmVickNGUnRPbVJ2QzFU?=
 =?utf-8?B?eFlFZ1ErdHJMaTNBY0lTYjlReHNIQ1VPVnczeWhFY0hKaXRvRVJ5Q25WODU3?=
 =?utf-8?B?cDhsRmtSVlg2alZWNVd5aU0yWVRyK0hDcUVCZjZObzA2UFpTS1ZYRUlOS3lr?=
 =?utf-8?B?UHB4bmFwcDZMWXJhdFZtNWdPTVVXTk5mckFHYjNaeit5ZGZmRFhuUnpnSGta?=
 =?utf-8?B?bXcwcjZRVEpJQjlxeXRJb1BjbkNmQU5jaVFJQldRMHZKdGpXNHU1UmY4aGJq?=
 =?utf-8?B?TzFqN2FKZ3UvcVlTUVZib3JiM0MvTysvWWM1UVhzRkgxRkNJS2hWY3ovbC81?=
 =?utf-8?B?d2ZwWlFjVm45UmtzcHFnaFZGV3V5NEc0Z0RuYTQwcmJyWjlna2hrNHhEVmoz?=
 =?utf-8?B?alZMZk02NmpSOE1JbEJpbU52VzR5MEFFK01NWk5VbHQ2SGhRUXhUZGNkeDlD?=
 =?utf-8?B?dlh2T05EM1FtdDFEb2crWktoQ2k4c3NJTFBWOWJGKzExcmRheDlMazFrejkx?=
 =?utf-8?B?a0QwSEpqd1FtSXBsK25ja2FLWFE0ZkxITGNiUFFoUC9mTHBVaDVZV0MyL2Ux?=
 =?utf-8?B?dDFDTVRoQUZITjluTEw3SWNqTnEyb1VleDN5TG1wZXBZWmJCNTM5MWVwWDdU?=
 =?utf-8?B?aDFKNUVBV3Mzak5jMFIwd1RtbWJ3eU45anpYSlVEMnpZL3R6SC85ZVhzOVgz?=
 =?utf-8?B?WFRLYUI4L3dyWGZVcExBMjVLbVZsYkJLR3JLT3l6Z2J6cWtMWFE3UjRad3lX?=
 =?utf-8?B?c3ZSemJmOWpkNElJSmM5eFAvcnZ6TGh6ZmJocDRJQkVrenI5V1VJaXdRSmNI?=
 =?utf-8?B?RDUxZWR3YWtCelJZV01GdEJLRE1hOVBhMmZKN2JGenczV1BKeDR3cmQ0MlVq?=
 =?utf-8?B?NFZ4aXFPTDZLcTFKM1UvUWZoU21zM1NPYnRsV04zZVlReW5vaGhDU25WYUI2?=
 =?utf-8?B?cUw4L3gvd3BUa1EzUEcxZHMyN1MwQnB1ems2VVpPbGhTb2c5cTZ0ZzlLRDBT?=
 =?utf-8?B?ejBxWjBlaVBqWEtPdmN1MXRWdlRqbkJmZ21MNTMzWm9FRGsxV3pVNmN1dG04?=
 =?utf-8?B?U2VQYUNmL2tkV3RIS0N3cXc2VjlvUllFbW9oQ0tkUnh1c3NsbFFLSldKZ1cv?=
 =?utf-8?B?OVlQYWs2aUNTTmdnbnNaSExhdzMvSGtSeVArS3FlUGdiYTV4M2R2RFVlZk83?=
 =?utf-8?B?ZXdZNlVMczFzNU9NdkpOcjZpQ2FGeGhreWN0NlFlUGNVRXJheG1HZHR3REF0?=
 =?utf-8?B?eURQcHBmMkVnaUFWdStQTW92d0N2VUhSVld3SjBJbm5pa3RXcFBoQkVtVWZl?=
 =?utf-8?B?aTJiSFE4Nkt3YXRnZEFSNDlwK2FhU0dTWnFvekVwb0NhYjNlK3AyOTFyY29t?=
 =?utf-8?B?c0x2VVUxMHJKdjFtdUVEdFJGaFpCMXFVbDVyTm1CcXRnYzQxbzZLSU1TYnYr?=
 =?utf-8?Q?qOqPipLR8mUBnPZitbLou5s=3D?=
X-OriginatorOrg: kuka.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d2f238d-bec9-40fc-3a09-08dd93803beb
X-MS-Exchange-CrossTenant-AuthSource: VE1PR01MB5696.eurprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2025 07:15:12.7954
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 5a5c4bcf-d285-44af-8f19-ca72d454f6f7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fJAL61/fauI6Iq0B8A/ORNLlmZXBf6sYW0aR5HnPhqH5GfjGt3ZDBJUEOjKaTX2BQJCUsCw+8y65XMu0846J3JV9cX4FlxhMhJ6lf7nMcbQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR01MB11067


On 5/14/2025 6:35 PM, Lorenzo Stoakes wrote:
> Caution! This message was sent from outside of KUKA. Please do not click links or open attachments unless you are certain of their authenticity.
>
> The enum type prot_type declared in arch/s390/kvm/gaccess.c declares an
> unfortunate identifier within it - PROT_NONE.
>
> This clashes with the protection bit define from the uapi for mmap()
> declared in include/uapi/asm-generic/mman-common.h, which is indeed what
> those casually reading this code would assume this to refer to.
>
> This means that any changes which subsequently alter headers in any way
> which results in the uapi header being imported here will cause build
> errors.
>
> Resolve the issue by renaming PROT_NONE to PROT_TYPE_DUMMY.
>
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Suggested-by: Ignacio Moreno Gonzalez <Ignacio.MorenoGonzalez@kuka.com>
> Fixes: b3cefd6bf16e ("KVM: s390: Pass initialized arg even if unused")
> Cc: stable@vger.kernel.org
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202505140943.IgHDa9s7-lkp@intel.com/
> ---
>
> Andrew - sorry to be a pain - this needs to land before
> https://lore.kernel.org/all/20250508-madvise-nohugepage-noop-without-thp-v1-1-e7ceffb197f3@kuka.com/
>
> I can resend this as a series with it if that makes it easier for you? Let
> me know if there's anything I can do to make it easier to get the ordering right here.
>
> Thanks!

Acked-by: Ignacio Moreno Gonzalez <Ignacio.MorenoGonzalez@kuka.com>



