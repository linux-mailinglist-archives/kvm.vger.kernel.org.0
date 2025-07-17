Return-Path: <kvm+bounces-52709-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2307BB08628
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 09:10:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D34341A64D92
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 07:08:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC6D42222BA;
	Thu, 17 Jul 2025 07:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="WoJRGC63"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2059.outbound.protection.outlook.com [40.107.93.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42EFD21ADA3;
	Thu, 17 Jul 2025 07:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752735920; cv=fail; b=prYDw9jTRm0aa75voF1nofkFuXc4nKU98kygiAALSQ+GhR9JC+YzDtJyTO8KSVcT/tlhf9nGMj4E17/LC/gg8Cg8ic5IpuwAoNy0hSKYYKhtJNauNRYb0wv6D84lZz6Rsz2/IEdT6a/O83qNZxkqUMjLlmGf4pfkY1U0cHaY2Hc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752735920; c=relaxed/simple;
	bh=aTcSpA9QXvxtHKu1AyILblInx72KQuBKd4TuCDxFU8I=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=bZTBsBkozksSeJC7ZORGZV2Ge27odefo2pHAfT3D1J/Yqj3BH0qR2qFSBZK+Fz/y3PNmebFCNZAQY5QRLkO10WZCZR30OVrr7NLGjwfYXCixqTPU1hqPbMxM1i2lPLVfTxLwhjQrdW9eM8QtdYObvv2FYW7h68qb+OVD+4Xnerg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=WoJRGC63; arc=fail smtp.client-ip=40.107.93.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q4Ulq9d/wLNZzzpRVV7Yqjxg43dnstKh3ovV9j3HdAqddDeOKR/CdT86mfQhqcdhi9dMa/lRqp9q/dwv4ap56IrlNxtpTGiOR09dHwH1Gz+Bbz4HbsI7zHzauKHjEXzZcneGxQwJqNDxIqWTQDGNl0ME+Z2CaOtXtVyPnogwzv7MKZvfvM0XwllWZqQgrsApjPCwyzx9NZ0IZwWvEmgnvNGCraBlb/He+hPTJb6JXY6ePvJz9Pq5D4YJmpDqzdEcssUoG7s3C37sCJmdi4Z4lWgO9owcfoOn7Eaq5nKzBK8xisKT6X1id+mUAruPvgG+IJvyR6fMORka31pP0SHf1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mwlUglMgx6dkPn2RBeP71PBpS0NsLHUUqQBnPkZ94SQ=;
 b=pd1ieaFVL7UnUrLWddQZxmb6JYYHC+8cAbb4nAFNWsbHRE5CNUvp9VeH5TjS8OPFShhcBQvQ63aXK1nXAzvyCudMrXKdslaEO6h1KYjxnGmeCkzNfkrNyYg4hzsBp1Ji1V9A8pZYyNhbetCl7+KT2RQNE5bxKGbrKhUIeHyTTvG1s/4mUdXp4KbOD5lbGmKYHP1XeLYUMoYCjPsUix3pvvs7zb1bZZrKsd+vqANBhunfmTjjs+rYKdekCl9ZZCU8lbOGZH6w1nDb7mRPiXmUtB+OUSyxgGANBANoVHxJqs9I/W+3v8zEzIKAgxmHSwHEX6z3VbIn44UfRAPoVG2B7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mwlUglMgx6dkPn2RBeP71PBpS0NsLHUUqQBnPkZ94SQ=;
 b=WoJRGC63CTOawLny5vsLk7FUjv/jTSw+pSvg8w0g0csG+bye3YkvpUKRcZcdjNXBbKUvQC8jLlIRUNCraJp+C5QnxHAHZj7pxnlQvUgrFZtbhKtjQgZCucPUjpwtZd5eDbPKWSp+F4L7Y2LhBBwUMy/ab1+8PjojLRhyjzUkNjY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) by
 LV5PR12MB9779.namprd12.prod.outlook.com (2603:10b6:408:301::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.39; Thu, 17 Jul
 2025 07:05:13 +0000
Received: from DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5]) by DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5%5]) with mapi id 15.20.8922.037; Thu, 17 Jul 2025
 07:05:13 +0000
Message-ID: <91572f4e-6607-41b8-91b6-146261393f07@amd.com>
Date: Thu, 17 Jul 2025 12:35:04 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/4] iommu/amd: Add support to remap/unmap IOMMU
 buffers for kdump
To: "Kalra, Ashish" <ashish.kalra@amd.com>, joro@8bytes.org,
 suravee.suthikulpanit@amd.com, thomas.lendacky@amd.com,
 Sairaj.ArunKodilkar@amd.com, herbert@gondor.apana.org.au
Cc: seanjc@google.com, pbonzini@redhat.com, will@kernel.org,
 robin.murphy@arm.com, john.allen@amd.com, davem@davemloft.net, bp@alien8.de,
 michael.roth@amd.com, iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, kvm@vger.kernel.org
References: <cover.1752605725.git.ashish.kalra@amd.com>
 <7c7e241f960759934aced9a04d7620d204ad5d68.1752605725.git.ashish.kalra@amd.com>
 <e71a581f-00b2-482f-8343-c2854baeebee@amd.com>
 <84fb1f3d-1c92-4b15-8279-617046fe2b93@amd.com>
Content-Language: en-US
From: Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <84fb1f3d-1c92-4b15-8279-617046fe2b93@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN4PR01CA0045.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:279::11) To DS7PR12MB6048.namprd12.prod.outlook.com
 (2603:10b6:8:9f::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_|LV5PR12MB9779:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b50385e-8ab2-415c-d0bd-08ddc50046a5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZDZFLzFLVjlxZVk4TEZ5OXVpUHBFM2NjYTlBcXpZQW52OUxFVUlKcDN6MGlC?=
 =?utf-8?B?UjQ1TFhPY2RseEdkbUY5TTBmTlIzL1NNdEl3Rjd6VUtTbXNMKzF2Uk53QjlM?=
 =?utf-8?B?MUxoL2ZFNUptbGV5L3pObWZDL2c2NVBHNXNPcFpMVTd3YklNZjNGWU50OTR3?=
 =?utf-8?B?RlBIQ2lWamZ2aENlQzFqUm4rWTFna2NLdmxvVk5URlJzZEtObTNRRjJoRkVZ?=
 =?utf-8?B?TUZVdTlEbVRDRFF5enkycHZwQ3FNSVlJZ2w3enVjVkM3a0Nubng4LythNVRa?=
 =?utf-8?B?eWNPdFRYdng0QUl6M3Y3UTRIc0I4TTJEeXJjRUZBMHFzNnhSTjBtLzdoZ25W?=
 =?utf-8?B?WE1nd0ZGUXhuWmNkK0R6MjkzTUtyWU5KNklVVmQrK29QOEJRU0F3Zk0xUmxp?=
 =?utf-8?B?c3gzNXZOSGFPWGpqNEo4TCt3TXk2QWJHakpEd2VQY2dKeFJKV1Z0d29ia2cv?=
 =?utf-8?B?WDUwUGpxakp6L2xKREtGZGh1WCsrbG4xVjZ5UFhzZnRISjdJT2d5VU5ja1pJ?=
 =?utf-8?B?NlRVY0QwaTZJckRCNmovUHJURlpDZFNxUzFVTER2azZ3Y3FLVXdZRmwwKzVM?=
 =?utf-8?B?RTlYOWZqRFVVR2k1QTcxWWNRbDdFdjhQVDJicGtCdERZVG9FdG5KcGVFd1Ro?=
 =?utf-8?B?bWlvVmtLK2F1dkxpOGxScDNES2hBUEVqSGlMME5NTkFYQmp4TG9SK0dtOEhE?=
 =?utf-8?B?cm13eG4xMHdXWHE5Z2szNXp4Uk02YjdpSGJ4Z3ZaNjgyN25JemQ2dU4wdDBj?=
 =?utf-8?B?ekZORTJDemhoYjB1Qm9YcXMrZk9LTFdnRU1NNURjcm5Rc3BUd0xUODdRVTk2?=
 =?utf-8?B?c3psZWU1Mm9LWEFHZkltcUlMZTJ1dVJNMG1XTmVuSmMzWkk3OGszZldhS01z?=
 =?utf-8?B?anBMcmV1QlYyYTgvZVdjY0t3aEc0aVpqd1p5NnREQStpSmdyMDFNemlOZ2ho?=
 =?utf-8?B?SXZLcHJBVFJCV0FtUFVROUwwaUJMNlR5Zmg5cG5DaUJJUVRtU0JUcUxhZVAx?=
 =?utf-8?B?M3p2QVJHTGZvTko3Y2doR0s1REVMeTFCcER2MU84V1EreG42NEpvSUVWZnZI?=
 =?utf-8?B?SG9WOFhoVVQ4TnZhODR3Vkc5UEtzTHptc0xucFhBSWdXM3NZd05rcm1VRUdD?=
 =?utf-8?B?T2p1TzNoMDZ6WEFyUVFWckdicFUxSTZDb3gxUE01djFwNFlkUmtVcVJsWlRh?=
 =?utf-8?B?WVFGVk9Ha0xxVG15REVTWFRTYnQrNGxKU1kzZjRpakFxMTRVQWFWUTNxdzZy?=
 =?utf-8?B?dkFPK0tXWE83SXY1eC8vRnZ3eUVZZk1YYW1RckEwdWJqV3IzQ3JTSm1RT1pQ?=
 =?utf-8?B?VEh5RXZ1LzllQjcxaWpDLzFVd3BIdjJqaXhCZ3ZIKzVmNWtmS3V3aFltWFNU?=
 =?utf-8?B?M0Fac3dCdjNlL1lqbTRtSHdIaUEveDkwc2hVM01mbHNPTUFVUTJ4QWhrRVU5?=
 =?utf-8?B?dERqNG1ZK0ZFMEwxL3Eydzk5Y1R4WlZYM2puZytZS01WU053bjByUkJiOGJn?=
 =?utf-8?B?U0xsdTY0SXdMOHlQUFk3WS9UTENJek92Rk1RZE5HdlV2T2QzTGdvVkhTODZy?=
 =?utf-8?B?ejN4alRIeUJMRVhyY1o1VEpidUlKclhLTEdOM1hsWENBOG8vdFRGUmFIMDVz?=
 =?utf-8?B?Mno5MVJBTTlKTGRickVEcC9xVElleXBaMGhoUVRyYUU4YWxhSFE5a01hNXBC?=
 =?utf-8?B?ckppS05DSDRpWXJEcmRtY0NzcW9ud1EwMHpvTjEwY1AyRjdDZW40RTlSZVJF?=
 =?utf-8?B?TU1KeG9oRDJiTVpIa2p6ZThvbGJXbU50MU9meVprd3NvNmJtUDJxTWhnVk5p?=
 =?utf-8?B?K2pWeE9nUDlqTXZ3bHVGRnZSbFVLYkJMdzBqQk54azJsVjFrcE8xeHo4a1gx?=
 =?utf-8?B?RDlhUitTYUV2eFd4eUFsSzdsTlhIVG0yaFJtTjljaDZiUGpLb3drYWVXd2NN?=
 =?utf-8?Q?YDl8itFBRfo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6048.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Yjh0cWhGeDRXL2NzS29Ycmo0OERBMjczQVBmN0pWZ3gwbHlnbHNaaFVlVjhQ?=
 =?utf-8?B?SEtpR0lJLy83cno2bE9UV1hmRjFaVFRhNFdpRytsTkVpYUxtUDhqUkJyRFUv?=
 =?utf-8?B?NG53N1FQNDFaTlNoanVzaGJteGkyUkx4SFdYMFdjQWlGU3EyenBaU2tjMjlr?=
 =?utf-8?B?U2s2YVRhOVJpdzR1b1Vidm8ybVV3OTFrMXRRUFRLVzAvRFdQVi8xa0hIWS90?=
 =?utf-8?B?VE03MEtrRjBwVU1pMDdkZi9UTENQL2ticVhsa2xHRDlINWd3WURmMnV0Qkdq?=
 =?utf-8?B?WDZCNEJMRGZJWWd5MU1NQkp2WndsZTdINytCUVk3bjYvdVZWU3BlbmI2aUZj?=
 =?utf-8?B?eXhqZGoxb2VRRTNwUjk3dXlFUDJXRi9ZdGJWUk9LUC84YUFCdHI5OFZtdHhn?=
 =?utf-8?B?b0tTZkRJSWRSMGVXOFoxTmRtdGJyazF5MTRQbVBtWFJYMGR5RGp2Wi8xZWww?=
 =?utf-8?B?RytuelVTMTB6TUdOTW5ZNDVCTHdWL0cxeDcyT2QwcGkxcy9sOW5LeTdzVVUr?=
 =?utf-8?B?M0VQbkZKYUx5VktqZFR3Y3dXS3dSd3p5bUhKZVVCUG82eWMvMDFsNGxXZllO?=
 =?utf-8?B?NUtvR1pSdkdxRkpWczkrMVJyL1UzNzBFUmlBdXB2Z0RQNVF3UkZ6WWZrT2ZI?=
 =?utf-8?B?YUJIQ2tYc0Vqc3ZGY2xJQ1NjTnJNMHd5R0FxSEY0cFVOSTF0Tk9tRTZpVFVz?=
 =?utf-8?B?ekxpekgrMDMxWjZvQXNScEpnczQxQmVEVngySXlJbzBVbFJGRkFZWmlRNWVm?=
 =?utf-8?B?YXZjdGJNMnJhK2JPWUlEOVo0aUw3TllDbmc3bVBvYUttbzE4UG1keGU2YUJE?=
 =?utf-8?B?MmpsaXY3dG1TOEZxWTZXU0tUMkxSUDdHZTBrNTczanMzb1hSVEJrYXdSMEtP?=
 =?utf-8?B?WUN3V1VlaWlhUDEyWm5id043ZVpsTFpxeThKeUdoL1lwZDh3T0ZSSWRiQmlv?=
 =?utf-8?B?N243cEZOMm14eFdzS3RmYzdvU2hwdWUrTlFIOURqeXhzRG1jS2xmU2d2eDdY?=
 =?utf-8?B?VFYxRkFTVHJMVzJXWktvSVUzVGZmYTc3VmNDejR3TEhtODhYRXpFNzdGZXN3?=
 =?utf-8?B?RUFONlc5N2pOMWJxOGJ6a1hldmxYRkVnUVRmR2NQaXJDQ0RUb3pkOW5xQzkw?=
 =?utf-8?B?cjNGWGtBOHRVMnAxYytzaGwydUt4c3FqdjNmR2FQZ1RvYkV3WjdYbENUT0hZ?=
 =?utf-8?B?TEh5U25aclhNb3AycVNLelBuVnJxL2diR25QYXVJaUVFUFFBUElUc3VwNld1?=
 =?utf-8?B?UHpZZVJ5cTJEM2xoakVoUzc1Y2VmQlJNVjIycmxjY1d1WGRvMmlkZTcwOEgx?=
 =?utf-8?B?VFlRc0NPd3VpOUdtdlQ3NXRiL1o0RmtEelBZUHovbjNhT2tGYWs3VkFWN3Vl?=
 =?utf-8?B?NDduWko3ZTdtMndiUDZYS1Y3Y3E1cmFXTy8rZFNaYmFWTTQySU83MnV3YnVN?=
 =?utf-8?B?L1BId1RHY1lJVnlKaU1HTGkwWGZBZE02b3Y4clJnbTVzdkpiM2ZwMk5KSkFZ?=
 =?utf-8?B?R1J1aGZtd0habkpyUWVpZHpPZklydmZtVUM5UGFOMVRBM0twV0ViTzVoMkxx?=
 =?utf-8?B?SE93N0lrSGVOdkRieGtLdElnZ0piK3Fpd1FiRVVKRXJGVDBJWDgrZ2JSYnli?=
 =?utf-8?B?U2xwTFJPSWNtRmJRdm5VQkJ1a2g3bW14TW02TWZLSFRDU2orYm1yTm5kRjh6?=
 =?utf-8?B?TVFSTHIwRUpyWW5Kcm4wekF3cWZKMElUeXBGam1sNDJ6Ri84bkhGQkNJTUtT?=
 =?utf-8?B?dXAxclFWSk4zR1V1WGs0cVN2L25xRUpubnBmOW5yeW50UFZXWWlBQ2ZuUjBQ?=
 =?utf-8?B?TFFXM2xHZmNMUlRUN2dSVmo3QUF5VXBZR1YrdHV5ckxyek9SYmo3V0lOZXh3?=
 =?utf-8?B?S0ZLVFhGZWxSdUMzV2ZFeFg3b0srZ1BMNVkreVNRSm16STFidmFTcWFmS1Bl?=
 =?utf-8?B?VVUvWmhGZ1VQU28rMUpSRFFRY3hGYzlKdEcyTnRSNUhSWlhudDNKSk03Ui83?=
 =?utf-8?B?cXV5a3R1QUJVaEF6aVFWaytBRlpIVTBIVkZqTkRuUTBWVGJpck9NMVdGRk15?=
 =?utf-8?B?K2RjNkt1em5LUW13dlVOL2hMOVhUOG5EV2E5ZE9VdE8ySnMwZUpDOW9sL2Fi?=
 =?utf-8?Q?glaZ24f1QlQoQceVh57P3da/y?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b50385e-8ab2-415c-d0bd-08ddc50046a5
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6048.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2025 07:05:13.6941
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jrj67wGZQu6zGaoS9nChrk6e6T4TICMKJMq6EW9htxKLvBTwSpeZsHvvyjTVVIsO8J95M3baG7COlyqbTx6hNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV5PR12MB9779

Ashish,


On 7/17/2025 3:25 AM, Kalra, Ashish wrote:
> Hello Vasant,
> 
> On 7/16/2025 4:19 AM, Vasant Hegde wrote:
>> Hi Ashish,
>>
>>
>> On 7/16/2025 12:56 AM, Ashish Kalra wrote:
>>> From: Ashish Kalra <ashish.kalra@amd.com>
>>>
>>> After a panic if SNP is enabled in the previous kernel then the kdump
>>> kernel boots with IOMMU SNP enforcement still enabled.
>>>
>>> IOMMU completion wait buffers (CWBs), command buffers and event buffer
>>> registers remain locked and exclusive to the previous kernel. Attempts
>>> to allocate and use new buffers in the kdump kernel fail, as hardware
>>> ignores writes to the locked MMIO registers as per AMD IOMMU spec
>>> Section 2.12.2.1.
>>>
>>> This results in repeated "Completion-Wait loop timed out" errors and a
>>> second kernel panic: "Kernel panic - not syncing: timer doesn't work
>>> through Interrupt-remapped IO-APIC"
>>>
>>> The following MMIO registers are locked and ignore writes after failed
>>> SNP shutdown:
>>> Command Buffer Base Address Register
>>> Event Log Base Address Register
>>> Completion Store Base Register/Exclusion Base Register
>>> Completion Store Limit Register/Exclusion Limit Register
>>> As a result, the kdump kernel cannot initialize the IOMMU or enable IRQ
>>> remapping, which is required for proper operation.
>>
>> There are couple of other registers in locked list. Can you please rephrase
>> above paras?  Also you don't need to callout indivisual registers here. You can
>> just add link to IOMMU spec.
> 
> Yes i will drop listing the individual registers here and just provide the link
> to the IOMMU specs.

May be you can rephrase a bit so that its clear that there are many register
gets locked. This patch fixes few of them and following patches will fix
remaining ones.

> 
>>
>> Unrelated to this patch :
>>   I went to some of the SNP related code in IOMMU driver. One thing confused me
>> is in amd_iommu_snp_disable() code why Command buffer is not marked as shared?
>> any idea?
>>
> 
> Yes that's interesting. 
> 
> This is as per the SNP Firmware ABI specs: 
> 
> from SNP_INIT_EX: 
> 
> The firmware initializes the IOMMU to perform RMP enforcement. The firmware also transitions
> the event log, PPR log, and completion wait buffers of the IOMMU to an RMP page state that is 
> read only to the hypervisor and cannot be assigned to guests
> 
> So during SNP_SHUTDOWN_EX, transitioning these same buffers back to shared state.
> 
> But will investigate deeper and check why is command buffer not marked as FW/Reclaim state
> by firmware ? 

Sure.

> 
>>
>>>
>>> Reuse the pages of the previous kernel for completion wait buffers,
>>> command buffers, event buffers and memremap them during kdump boot
>>> and essentially work with an already enabled IOMMU configuration and
>>> re-using the previous kernel’s data structures.
>>>
>>> Reusing of command buffers and event buffers is now done for kdump boot
>>> irrespective of SNP being enabled during kdump.
>>>
>>> Re-use of completion wait buffers is only done when SNP is enabled as
>>> the exclusion base register is used for the completion wait buffer
>>> (CWB) address only when SNP is enabled.
>>>
>>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>>> ---
>>>  drivers/iommu/amd/amd_iommu_types.h |   5 +
>>>  drivers/iommu/amd/init.c            | 163 ++++++++++++++++++++++++++--
>>>  drivers/iommu/amd/iommu.c           |   2 +-
>>>  3 files changed, 157 insertions(+), 13 deletions(-)
>>>
>>> diff --git a/drivers/iommu/amd/amd_iommu_types.h b/drivers/iommu/amd/amd_iommu_types.h
>>> index 9b64cd706c96..082eb1270818 100644
>>> --- a/drivers/iommu/amd/amd_iommu_types.h
>>> +++ b/drivers/iommu/amd/amd_iommu_types.h
>>> @@ -791,6 +791,11 @@ struct amd_iommu {
>>>  	u32 flags;
>>>  	volatile u64 *cmd_sem;
>>>  	atomic64_t cmd_sem_val;
>>> +	/*
>>> +	 * Track physical address to directly use it in build_completion_wait()
>>> +	 * and avoid adding any special checks and handling for kdump.
>>> +	 */
>>> +	u64 cmd_sem_paddr;
>>
>> With this we are tracking both physical and virtual address? Is that really
>> needed? Can we just track PA and convert it into va?
>>
> 
> I believe it is simpler to keep/track cmd_sem and use it directly, instead of doing
> phys_to_virt() calls everytime before using it.
>  
>>>  
>>>  #ifdef CONFIG_AMD_IOMMU_DEBUGFS
>>>  	/* DebugFS Info */
>>> diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
>>> index cadb2c735ffc..32295f26be1b 100644
>>> --- a/drivers/iommu/amd/init.c
>>> +++ b/drivers/iommu/amd/init.c
>>> @@ -710,6 +710,23 @@ static void __init free_alias_table(struct amd_iommu_pci_seg *pci_seg)
>>>  	pci_seg->alias_table = NULL;
>>>  }
>>>  
>>> +static inline void *iommu_memremap(unsigned long paddr, size_t size)
>>> +{
>>> +	phys_addr_t phys;
>>> +
>>> +	if (!paddr)
>>> +		return NULL;
>>> +
>>> +	/*
>>> +	 * Obtain true physical address in kdump kernel when SME is enabled.
>>> +	 * Currently, IOMMU driver does not support booting into an unencrypted
>>> +	 * kdump kernel.
>>
>> You mean production kernel w/ SME and kdump kernel with non-SME is not supported?
>>
> 
> Yes. 

Then can you please rephrase above comment?

> 
>>
>>> +	 */
>>> +	phys = __sme_clr(paddr);
>>> +
>>> +	return ioremap_encrypted(phys, size);
>>
>> You are clearing C bit and then immediately remapping using encrypted mode. Also
>> existing code checks for C bit before calling ioremap_encrypted(). So I am not
>> clear why you do this.
>>
>>
> 
> We need to clear the C-bit to get the correct physical address for remapping.
> 
> Which existing code checks for C-bit before calling ioremap_encrypted() ?
> 
> After getting the correct physical address we call ioremap_encrypted() which
> which map it with C-bit enabled if SME is enabled or else it will map it 
> without C-bit (so it handles both SME and non-SME cases).
>  
> Earlier we used to check for CC_ATTR_HOST_MEM_ENCRYPT flag and if set 
> then call ioremap_encrypted() or otherwise call memremap(), but then
> as mentioned above ioremap_encrypted() works for both cases - SME or
> non-SME, hence we use that approach.

If you want to keep it in current way then it needs better comment. I'd say add
CC_ATTR_HOST_MEM_ENCRYPT check so that its easy to read.


> 
>>
>>> +}
>>> +
>>>  /*
>>>   * Allocates the command buffer. This buffer is per AMD IOMMU. We can
>>>   * write commands to that buffer later and the IOMMU will execute them
>>> @@ -942,8 +959,105 @@ static int iommu_init_ga_log(struct amd_iommu *iommu)
>>>  static int __init alloc_cwwb_sem(struct amd_iommu *iommu)
>>>  {
>>>  	iommu->cmd_sem = iommu_alloc_4k_pages(iommu, GFP_KERNEL, 1);
>>> +	if (!iommu->cmd_sem)
>>> +		return -ENOMEM;
>>> +	iommu->cmd_sem_paddr = iommu_virt_to_phys((void *)iommu->cmd_sem);
>>> +	return 0;
>>> +}
>>> +
>>> +static int __init remap_event_buffer(struct amd_iommu *iommu)
>>> +{
>>> +	u64 paddr;
>>> +
>>> +	pr_info_once("Re-using event buffer from the previous kernel\n");
>>> +	/*
>>> +	 * Read-back the event log base address register and apply
>>> +	 * PM_ADDR_MASK to obtain the event log base address.
>>> +	 */
>>> +	paddr = readq(iommu->mmio_base + MMIO_EVT_BUF_OFFSET) & PM_ADDR_MASK;
>>> +	iommu->evt_buf = iommu_memremap(paddr, EVT_BUFFER_SIZE);
>>> +
>>> +	return iommu->evt_buf ? 0 : -ENOMEM;
>>> +}
>>> +
>>> +static int __init remap_command_buffer(struct amd_iommu *iommu)
>>> +{
>>> +	u64 paddr;
>>> +
>>> +	pr_info_once("Re-using command buffer from the previous kernel\n");
>>> +	/*
>>> +	 * Read-back the command buffer base address register and apply
>>> +	 * PM_ADDR_MASK to obtain the command buffer base address.
>>> +	 */
>>> +	paddr = readq(iommu->mmio_base + MMIO_CMD_BUF_OFFSET) & PM_ADDR_MASK;
>>> +	iommu->cmd_buf = iommu_memremap(paddr, CMD_BUFFER_SIZE);
>>> +
>>> +	return iommu->cmd_buf ? 0 : -ENOMEM;
>>> +}
>>> +
>>> +static int __init remap_cwwb_sem(struct amd_iommu *iommu)
>>> +{
>>> +	u64 paddr;
>>> +
>>> +	if (check_feature(FEATURE_SNP)) {
>>> +		/*
>>> +		 * When SNP is enabled, the exclusion base register is used for the
>>> +		 * completion wait buffer (CWB) address. Read and re-use it.
>>> +		 */
>>> +		pr_info_once("Re-using CWB buffers from the previous kernel\n");
>>> +		/*
>>> +		 * Read-back the exclusion base register and apply PM_ADDR_MASK
>>> +		 * to obtain the exclusion range base address.
>>> +		 */
>>> +		paddr = readq(iommu->mmio_base + MMIO_EXCL_BASE_OFFSET) & PM_ADDR_MASK;
>>> +		iommu->cmd_sem = iommu_memremap(paddr, PAGE_SIZE);
>>> +		if (!iommu->cmd_sem)
>>> +			return -ENOMEM;
>>> +		iommu->cmd_sem_paddr = paddr;
>>> +	} else {
>>> +		return alloc_cwwb_sem(iommu);
>>
>> I understand this one is different from command/event buffer. But calling
>> function name as remap_*() and then allocating memory internally is bit odd.
>> Also this differs from previous functions.
>>
> 
> Yes i agree, but then what do we name it ?
> 
> remap_or_alloc_cwb_sem() does that sound Ok ?

May be.


-Vasant



