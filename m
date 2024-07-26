Return-Path: <kvm+bounces-22309-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EFE9293D052
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 11:19:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1F7431C21278
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 09:19:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1482E17334E;
	Fri, 26 Jul 2024 09:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="taKRVX2l"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2080.outbound.protection.outlook.com [40.107.93.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8644B6116
	for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 09:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721985545; cv=fail; b=E3RS1/yX+jzbUiGL/OjDsOcdoYqIimINZVW/WbBJ92TgTIyhU8WGqp8qoNzLXS/+qmweJDYqVbAQ2mcIQMjf/KPal+OE6Q4RsQbU7Pneb9o9LX+vMFYr5Vj21z+IfeXqcoDdNpEhdN0FzoBvoDYMNmycMVEYHyrh1OKo57g4a/0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721985545; c=relaxed/simple;
	bh=Ew66EMItRxWHvAafUNxCQ5atTYPekH6JRDMO/T2dK0s=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=R+1pcntLqH/zBTYsP05XK70SC083XVcceJJPLa4ZIX8tW/dIDtOlcptaiJ3P8iouowu0nl7cUnsMyLChnyB1GR/cN7YEM/G5eF/+ImckraQfAnWEVlCAr5TV3QhFTmd88ocTn4fycXfefzzOPv9K1PFXFYQONGJ3S0K7XPh3y3o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=taKRVX2l; arc=fail smtp.client-ip=40.107.93.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GNRCbw2TxhI2Fs/KiBDgb1Xk3E6g+cyYS+C2N20bOoUWaPuXnA+kGWJ8aaSJMGfxAIIPyQxIyQn2YGSQ79OdyvV9X8zrx+/Gesv3FZQNUSkp0aQP2OIqPJOnWR76pN6v8Zrg4mbeOYMwducpy1AZwRnVo3zdQYTwXEIj/yzmFdqD5cF47RjaXfm+YOjS1mHL+THwRpfbxbG2PXDS+8qYzzo3MDsVyCILPfdLrx1ngixGDiu2AS5oJnw7BdLLL5Ob09yCAHVDGmyHlQl7glNQlfw7EcRknBqs9XVO9H76t3Y9XkhHrJu1UGE6rr7NOetCA1pSJmdD2uNDQX06/YfqMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OKX1e9+k1sDzGdhRtHy2zNySAUxL8AF8qVM4VcLlp00=;
 b=FyEfiYwmE8EfJ4i5auHEuRd4VHdL5Azme2uo5eNRtJnB9SXGwZO4JyG5Ei5kHIikpti3+kH0GNkdJ1yoyxcda4Rwx/DTtMTP0oZDXT0yPMwywRbHflwbxM3lI9ObRNqfkzpWi68G/lAfDaHIRLUs6GKKl0pCVgd8tNmToi+KoXJlZ/Lk8vXcmxg9DMjLBRoFz4N7UlVuYNPDN1TsOPJ9w7LRxk4T8iVUHkOrOpsOhuujZQQ68m70fBmJT8Jz685yFJV4A+4YBWf+kymV018B5+X8ZUPIaIg1SD0DnAgPbxSdKMmcyGt04wt4kkxGL5E/NeSVWpxM5r2q5Yrf6+O5wQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OKX1e9+k1sDzGdhRtHy2zNySAUxL8AF8qVM4VcLlp00=;
 b=taKRVX2ltUqRlBxDGREUFR8wlceEAWCcxnjhWzwsuyTh4XGIXjZcBpkm2fucwG4KnNR6rs7Fpen+z1OOMStxQc5tpVJnUeGg7/bo+M4kPEimvAVQMSZLOw0qciwHa0TL14Uz8I2dLHtMJL8SEsgiwuFBbYxqebIs+U7mpwd+5RA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) by
 DS0PR12MB7533.namprd12.prod.outlook.com (2603:10b6:8:132::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7784.20; Fri, 26 Jul 2024 09:19:00 +0000
Received: from DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5]) by DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5%7]) with mapi id 15.20.7784.020; Fri, 26 Jul 2024
 09:19:00 +0000
Message-ID: <db1d622e-0f72-410c-ba2d-c21e14dd8269@amd.com>
Date: Fri, 26 Jul 2024 14:48:31 +0530
User-Agent: Mozilla Thunderbird
Subject: =?UTF-8?Q?Re=3A_FW=3A_About_the_patch_=C3=A2https=3A//lore=2Ekernel?=
 =?UTF-8?Q?=2Eorg/linux-iommu/20240412082121=2E33382-1-yi=2El=2Eliu=40intel?=
 =?UTF-8?Q?=2Ecom/_=C3=A2_for_help?=
To: Yi Liu <yi.l.liu@intel.com>, XueMei Yue <xuemeiyue@petaio.com>,
 "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
 "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
 "robin.murphy@arm.com" <robin.murphy@arm.com>,
 "eric.auger@redhat.com" <eric.auger@redhat.com>,
 "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
 "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
 "joro@8bytes.org" <joro@8bytes.org>,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
References: <SJ0PR18MB51863C8625058B9BB35D3EC1D3A82@SJ0PR18MB5186.namprd18.prod.outlook.com>
 <SJ0PR18MB51864CD07C0F5FB0AA23AC05D3A92@SJ0PR18MB5186.namprd18.prod.outlook.com>
 <903517d3-7a65-4269-939c-6033d57f2619@intel.com>
 <SJ0PR18MB5186AD98B2B0449BF097333FD3A92@SJ0PR18MB5186.namprd18.prod.outlook.com>
 <859fc583-6aca-4311-ad9c-ffbea68c5b17@intel.com>
 <SJ0PR18MB5186B961317770AE36A58A3AD3A92@SJ0PR18MB5186.namprd18.prod.outlook.com>
 <034e27df-e67f-410f-93ce-ac7f3d05ded0@intel.com>
Content-Language: en-US
From: Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <034e27df-e67f-410f-93ce-ac7f3d05ded0@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0110.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:27::25) To DS7PR12MB6048.namprd12.prod.outlook.com
 (2603:10b6:8:9f::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_|DS0PR12MB7533:EE_
X-MS-Office365-Filtering-Correlation-Id: a7d7224e-5c89-4c68-b377-08dcad53fc1e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|921020|220923002;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OTNoLy9UU3U5LzBBVm5saThDcW5xWTBwdWVJclRWUUk5VG5scUNmem5VRUZq?=
 =?utf-8?B?dEhDQjlIMkNsSW5rMG5wM1JxSE9SRGhHLzRpU3ZLbGNzejQ0U3R0N0FGWlZF?=
 =?utf-8?B?Sy9sMnpCREZoVkl4VkhoL2gzdjljdHFaMFJoU2Nrb3FpNTRVWXlLdUJoSC9x?=
 =?utf-8?B?YUNVRkU1bTkyY1lrelFnYURWNG4rZjMrSm5YYXpJVC91TW9OQlNqRnk5VDhx?=
 =?utf-8?B?ZU9uMndRMzVwODlESFcvYWtCbDlIL2JFVUJZOHBlYW1FZm1SaHdpaDcvYWM4?=
 =?utf-8?B?UUJyUWRIMTNaWWZDeUQyLzJpN3Y2Y3NwbTBZMjhJQjJxOVAzcE5Qdm9UQVUz?=
 =?utf-8?B?c21EYktJby9YcHFzcitsVVFtMkEyamNHOVluMVpCZlRaVWlIcTJnWjlkQWpV?=
 =?utf-8?B?bDY0VXI0QXJRdG5XNzhIblpxRXA5TE1YS1RqUGJocFBONHIzRlE0WmRaRmlr?=
 =?utf-8?B?aVo4UkFLQjA4RldxVkRicTl4cDdXYXlDdnRQT0FRNWphRWF6ME8zR0E1QU5Z?=
 =?utf-8?B?Mk8zLzJITzBYQi9NNlp1TlY1cnIzK01nTUhJaFh4S3hDN1FsMFdZMmdzdGRy?=
 =?utf-8?B?VndrYzE2cnJsM0dvT0dNeVBUQnUwSGt2ZkI5QUVMYWR5ZTVUWC9TZkZRZU1E?=
 =?utf-8?B?bXR0TGZCYThMVElOV3ZjWkI3UDVjNk80eGZ2YW1oODZ4bTFyVCtmK2ZrdTQv?=
 =?utf-8?B?djV3Tyt3VDBZWllPQnplelp0OS9DbHMzTHUrR1lXOXhJYmtxMjVQbklTU1dw?=
 =?utf-8?B?bkxDZWNvYlk0WnhsVlc4ZGxDR3VlYjBDOHlUbWQ2eGNQbFNoWDdvTE9JSVk3?=
 =?utf-8?B?REFNN01pd3kzdmFha1pOYTlLZlN5L2ttaEVDbjZYR1puRUtBcnMxRTk1Mis2?=
 =?utf-8?B?SUVFejk3b3JFRkE0eCtxNDdTeGpUZ1IzU1dSN3FrZHM2ZXR0U3kvQ09adkNp?=
 =?utf-8?B?WmxWSWE5Tkt0UzVmZHBxUmxlYkZpb0hRM1hGdlNCdXlUS1lRckpYWExLMCs1?=
 =?utf-8?B?blV1VDdubDJwRGlwM2ZPZlhkb0xTZHQ1MlZNeVpzMW9RK0JOamRJTUYrRlRZ?=
 =?utf-8?B?Vm11MFlNTlk0QXFPV2xaQU9vcmxqUkhSWThkS05HRmxMczQ0K3VQYWtIbEdz?=
 =?utf-8?B?N0p2a0lYTzlBazgvOUEzYWJabnBWT2c5WVB1c054QXA5VjB3UU9wMyt1NEhl?=
 =?utf-8?B?K1NaV2FMS2R0OEc5Tjl2a2lidTFnMSswMnNkR05iREVwZkg5eUl6ZSt5Vm9j?=
 =?utf-8?B?N05NWWJZenZTU2krSUlXd0s0OVd4NEcxU1dqZ2oyRDlRdzE5U1pIanVKUWsz?=
 =?utf-8?B?ZG5DV0pyVzVXRVJzUVAxd245ODRLVXFiZEVzQzRiWjlxeUFVbGdSMG5PMGRP?=
 =?utf-8?B?K1hhTXMvL0pBbm1SbUpON2hWbGgvaVp1NHhtU3Ewd3pNMFgwbTBzZ3YzYWE0?=
 =?utf-8?B?ZUlnZjk3eW5PRENrS1g0SzNPd3FCTm5LTWIyTHVhL3VjTTJjaldNalY3R1hy?=
 =?utf-8?B?TmRCTjJBUWZPNzVMWnlUVW5WL25zdnVDWEFhVWdCc3RrVy9oMXhqT0FSOHo2?=
 =?utf-8?B?WmlFZjFNL1MvNC9lM0I3V0lwR3o1RXl1dllUcDdBWU81Z2hSWmd6ZForYlAx?=
 =?utf-8?B?aEpkTnBjMFhSeDJHTnJDTHgyT1U5UFBLMzZ4dXRwRDVyVzNsZkJ6SGpVUGps?=
 =?utf-8?B?ekFqOEw4U3E0V3lJeEhBZmFybHlhVTYycEhpVjRhdk5jTDh6Q3JpSWNmREF0?=
 =?utf-8?B?T0lSQmhGdlhhNUdDKzBUWFpzb1NDVDArNVROcm12amNIRm11VHpCMzZJdUNz?=
 =?utf-8?Q?WGthkxrM3affi/PyegWBpjZM18uVnGqOq6p2w=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6048.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(921020)(220923002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cHl0VEZ6Z2R4VWptRTZBVTk0ZzV1ZCtVb0dpTjN4NWl2dVZHREVINGRmNjJB?=
 =?utf-8?B?Tkg4ZDBSUlhXUnJ1d2h4U2NJRVdUeTV2TTNEQ2Z5RmEyY2NydUM4L0NOSXZW?=
 =?utf-8?B?a2l2K29zS1JiMW5zbzNiaHEwQ3Z6NXdnaHhlMEhUZWlOT3M2SXhzb1dYV0do?=
 =?utf-8?B?SXUwV2x4cUtXRklxbTdCN3QwcnpnVnRzZ0JmTTRSbEJHQzBFSzRHQXVpMWMy?=
 =?utf-8?B?L01DZ25Sa1hQd2JnMzRhUTlUZ0JFUkI0V0ZscGhFQjNQRTNrODdpU0lTL0tM?=
 =?utf-8?B?dm50Ukx4VGRRWXZPeUp1QjlVTVBZR21haTF0WmVySWNkMDQ2Y2pYVkNKMVBQ?=
 =?utf-8?B?b01OOERIOXZMb2NmdEhuY1BRdGN5NUR1UTNJL2lTblBodGFlczBESVB5ODZ5?=
 =?utf-8?B?N3pGTGJYVHMzU0J4UEVST2lmdzk2cmtHakJBYWcyVjVtZ3ZRak5EdzlKY05C?=
 =?utf-8?B?Wi8xOVBFTFlabzJFQzhzS3JvUC9EWVFjVDhtRkFxRGVDVVpnOVNreDNiRlZE?=
 =?utf-8?B?N20xbmVIUUNBVGZBNHhVK2lKUUEwVzM4bFh2TCtNZXUvRG9kbWE2MGZ0NURk?=
 =?utf-8?B?czdEOVJBSXpMbjNwSkE2dlVqNEgwOWNraHRPRGZnclNhRG1iZXRKZzk4Nk5j?=
 =?utf-8?B?dUtjN2hxWTRRZmpLUVNQQkNFeVRKZXR2VUNFcVJxQWFSU0lBbzRsak94dVp3?=
 =?utf-8?B?d2xPeVQvM1cwM3AvUTdUYTBUN05KTVlNR1VYZUpaNzJYSzZ3blVPRkVJNVRl?=
 =?utf-8?B?RW1lQ2ZQVTl5WHpBaE5iZGNiUUVENFdMVXFNY1NrRWZRdm1OTjBsSXRnZ0JW?=
 =?utf-8?B?SGowQU5uKzlqYXVNS2dCcThva25aWTJLUWhJSnZlMEJaRHAyNDV1bktkVjRs?=
 =?utf-8?B?cTdidFpML0RYWG9IRU9SbjhtN3YrdmpZakhISkhsOUpWaUFXc0pCWHg3eEpy?=
 =?utf-8?B?c01XeXBEajNDV2d6ZjF5QmpuQWl5RCtHbWtGU1ZScHNiOUkvYy9oSFVWSTJo?=
 =?utf-8?B?WU9DSlFENjhsRlBhdWdoZlFuWWxpeUJkNStncVQ2Y0xxa1l3bTdpYXFvMXhC?=
 =?utf-8?B?MHN0RHBmRnNQaUJUekJkc0Jwb0pYR0Y2NCtDb3V5OElyOFMyTUR3U0JkNjlo?=
 =?utf-8?B?YklqYTIxWStsL1VwYkYySlEva1BXYjVHN0NaQmtLRERsZHVzL3lIZW8zWkVi?=
 =?utf-8?B?MjhEY01PL0VkYzdpQ0hmejBPVjJPeTJWaUliU21CYWxiWWF2YmRyUm51MnNH?=
 =?utf-8?B?blFWejJSTU8zQ0NreXJDcVFha213dEJ4bEJjRGZGLzF6bHplUkZMN3VNUkxm?=
 =?utf-8?B?dXgxakdsYkRFM0JEZ3JOck1XS08zWWJqTXQ3aTRWKzVXK0V3SEkrcXpLUE1I?=
 =?utf-8?B?R08wSWo0TThQdCtpc2lacTgxVUlxR2U3RTN1TXpxOUtHODdsS0RNL2EwVGM2?=
 =?utf-8?B?RUtSdE4vclc1NjY5TVlmL00vTjBwVWZ3RnhVQ3NjZnFwMTRmZjJqZ04zenBW?=
 =?utf-8?B?SXUxQWIvM1MrUVBuZEJnRlRlTFMvVmJRTXE1aXN1UmNzb3JabjdTTFdoeWgx?=
 =?utf-8?B?YkVkejE2R1dEVExTbDlyWm1Qd3hhUjJOZ1dmcE5ITFRZQWJOSWhDUGRRekNH?=
 =?utf-8?B?OGV3U2c5aXRyUldza2tsSHpLanZkb2Y5VWhjNExGUFZCTEdoajZ1M1JPWndt?=
 =?utf-8?B?U0hQSE14MEFUUXltdlBLeG9NYUY5T2hZRm9QZUxEL0VuMUY2a3RQR1ZJZEcz?=
 =?utf-8?B?ZldpREEzbG0wOUwxZkQrSk9ickE5VXNMblZVSUI1MzV3UHFIaUd0VXVua0RF?=
 =?utf-8?B?MVlpWDBqZ0RzV1N6bVg5bkdYcTI3VEViN1dXVFNQdm5QbjJGcGlKdHdnSzJ1?=
 =?utf-8?B?dkZQYitGK1dUQ1JBWjVmbExkUUZUdllzak5IVkhMK2EwemE1N2pXdEI1M2I2?=
 =?utf-8?B?YklaM3pCOG5PVWJxV1B6b251NzdhM0lPOWdWTktlcG1ZOFVsb1FGeWpDMkJZ?=
 =?utf-8?B?SXM0RmwzYjJ6Z1pEUXVRR01zbHBpUW44UDJybTk1UXVvR3dUOTVuWGJSSmQv?=
 =?utf-8?B?QkljaVBiVElIK2Y3VkJYcEdQc3p6aTBSblNONmJiZm5oTUovanZlK2YxWno5?=
 =?utf-8?Q?9qscmQ4cp1/Wt1xKLUyt8BJxe?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7d7224e-5c89-4c68-b377-08dcad53fc1e
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6048.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2024 09:19:00.6736
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9q228rA4yJ1lHppZI9ZMeoIkVPEMSQIQitBgVTmx3wlzhzfMZBQhcbuRoeDynq0J8QKe1RCX7PyRkgk/wG0s4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7533

On 7/24/2024 8:21 AM, Yi Liu wrote:
> On 2024/7/23 14:52, XueMei Yue wrote:
>> Hi Yi Liu,
>> Thanks for your suggestion!
>> we have tested ATS without PASID successfully.
>> Now I want use PASID to verify other function.maybe not related to ATS.
>> Could you give some suggestion about my example "iommufd0716.cpp", How to make
>> it run successfully via linux user API ?
>> Thanks very much !
> 
> you need to make the pasid attach path work first. As I mentioned, the AMD
> driver does not support it yet.

Thanks Yi for responding. I missed this thread.

You are right. Currently AMD driver doesn't support attaching PASID outside SVA
domain.

Regarding ATS, AMD driver enables it by default if both IOMMU and device has ATS
support. So you should be able to use/test this path.

If you want to test PASID/PRI combinations then you can use SVA interfaces.

Regarding exposing PASID to user space via iommufd, we haven't looked into it in
detail. Its in our list. but it will take some time.

-Vasant


