Return-Path: <kvm+bounces-40175-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 58C56A50B05
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 20:09:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B7F6C166756
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 19:09:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 050A4254853;
	Wed,  5 Mar 2025 19:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WepcCEhU";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="iIjMErQ9"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DC061E5B91
	for <kvm@vger.kernel.org>; Wed,  5 Mar 2025 19:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741201572; cv=fail; b=EdbrsK+vLGqIJdQJxnQy6RRbsxGt+7m4hFYYFmyOBocfFIq5v64xeev0aevHeX8Cg7RbIwzCEmhjh32DrHUkb6vmoMZ1jdGubT2Th0OFstXdG1trzZHPpV4AY6aAJN5Dsr6SYhnCnX5ej/mF8A5SP02miTPP6c7BPqh8VEnQ0mk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741201572; c=relaxed/simple;
	bh=aQDtJrFyq+2iw04CuLj2JTPkfWw7exbYqVA9MqQnHBs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=mvzDUc6djZrqpMBoGdXkTWQPxHDzHJXkBLLcb+WVebNvufrgXuP5TLao1/hJQml0/7v1vDyliyHY/cDWObmp8XM1/eo/nzjOeFmw28ty9g1FBBATYDaA7HgtHT5tXvxnCwv26CBvEvGRfGYRxSdXTLemzpSooBlUQAYA9oB1+6g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WepcCEhU; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=iIjMErQ9; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 525IMdlS014056;
	Wed, 5 Mar 2025 19:05:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=1Onvck27OuIqwhJP1DG4P+q2OCXgS0HIUe+ctpRdr9k=; b=
	WepcCEhUbUZn+Hw/eMTAr4GVQEeMrbARANnAGwjOCln5dk1YpepjXpL+qsv8mG4r
	hLTQkTvkuufHND1kPBjATl6GJh4CGsA5Rb6Ijv8Y6L3lZFoc3DjxV/8QpX+QRrht
	WBILNqYR0yaJP6+WYkcQH2qqyA23KUiTw/RSo7uFQHyKISxgqKYYci2ILRCPuVFD
	wi8t81/bT4j2Io479wXz+bgarfu7jqdCUoP64V9qQs0CpykqjsJPfuayRZIauc/u
	S4/rJu+IIQJlU+L3rNQSpyZrS5VMZooWQsvq4aISEZr9m95jxcs59hdX58WoeLef
	iJUw3OUUx0KvrA/yyagPGw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 453u820cqm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Mar 2025 19:05:36 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 525IUl8G039757;
	Wed, 5 Mar 2025 19:05:35 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2040.outbound.protection.outlook.com [104.47.55.40])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 453rpbgr51-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Mar 2025 19:05:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CPktPX7E0QofVUeZbzas6YrdckFTEzAPXhjIvQK9XQfeoeOXNMup9YYuGlOBrQbeqbPP9qwM1HHdfrk/Qt2Xhvv33z+rl1yt0aku+mDEvKcmPfoKHlLi9tTT4/eUjVAaYOGOzXfa6W0aOMXE1P6qLiZg1dZ7jHZAMG7k7M6XMscLp2+lXg7j8jO6YhAuW0VBdy5wXx4/A+rLnRLKoDJWLkTIZMYGTQoeji9Y2KFQ5W36Bu1b3HNGn2EIr4VvuB6vGovJ2a2FUQPaM9SwikZyWPuQRJA3HL/CMpoaumH+AfdHtcm0mNuAxx0BIzvvenwgKcbcbh/D8Lg8YO/2xEd/jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1Onvck27OuIqwhJP1DG4P+q2OCXgS0HIUe+ctpRdr9k=;
 b=kC0RoEiEaQC95JDjL/b/1TYRuLiFqJGsNk6qZpGh9eiXK3qgrJ88X5qL578RdPN271l2Lte6AfOBeCi8SSYWkfJwgv1b09RWkGsQXTgc6XOy9FIphyb7UMaH/7OSO/f5NxsghgiBzQWLkMXC0VZrWU39q4zzy1cHFFTC1+NoAQ3PqDHqcPEjmm+8AKRLGieItkBEHSx+BxESHUTHsgS7ifo5XFkm9+dA91/d1FrqYBbmYdRhK9FzIdDU6yyaUk814QITZNWt5yNFWs94g+NYX6TTew9pRiMe/6szY/fFb4dUb5nVmO89Ga9mTuPOZMWizEpuocBXgs5WehRa6m6lHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Onvck27OuIqwhJP1DG4P+q2OCXgS0HIUe+ctpRdr9k=;
 b=iIjMErQ93CZHoSzimMlDCAPWT68MgIOQyKU1OgN/530T02ZmuhXkzhWZQjzvjbNNjS4t9zmV2f7377ajUsZV/SD+k6S39Twginpl+BWSkjaMZ8wgOMuIWCT4s78zrFSOeDKIrsRxN+H7hOsAO8IKlm5ZErrvCUfm75Rfc0m5Zl4=
Received: from BN6PR1001MB2068.namprd10.prod.outlook.com
 (2603:10b6:405:2b::35) by CO1PR10MB4500.namprd10.prod.outlook.com
 (2603:10b6:303:98::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.17; Wed, 5 Mar
 2025 19:05:33 +0000
Received: from BN6PR1001MB2068.namprd10.prod.outlook.com
 ([fe80::c9b4:7351:3a7d:942f]) by BN6PR1001MB2068.namprd10.prod.outlook.com
 ([fe80::c9b4:7351:3a7d:942f%4]) with mapi id 15.20.8511.017; Wed, 5 Mar 2025
 19:05:33 +0000
Message-ID: <645482f4-5323-4fac-8589-57dbc7fc6442@oracle.com>
Date: Wed, 5 Mar 2025 11:05:29 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 08/10] target/i386/kvm: reset AMD PMU registers during
 VM reset
To: Francesco Lavra <flavra@baylibre.com>
Cc: alexander.ivanov@virtuozzo.com, babu.moger@amd.com,
        dapeng1.mi@linux.intel.com, davydov-max@yandex-team.ru,
        den@virtuozzo.com, groug@kaod.org, joe.jin@oracle.com,
        khorenko@virtuozzo.com, kvm@vger.kernel.org, like.xu.linux@gmail.com,
        likexu@tencent.com, mtosatti@redhat.com, pbonzini@redhat.com,
        qemu-devel@nongnu.org, sandipan.das@amd.com, xiaoyao.li@intel.com,
        zhao1.liu@intel.com, zhenyuw@linux.intel.com
References: <7d6f5d9ce0f23a550aa95bba9bb04425a7a5b9ec.camel@baylibre.com>
Content-Language: en-US
From: dongli.zhang@oracle.com
In-Reply-To: <7d6f5d9ce0f23a550aa95bba9bb04425a7a5b9ec.camel@baylibre.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR14CA0030.namprd14.prod.outlook.com
 (2603:10b6:208:23e::35) To BN6PR1001MB2068.namprd10.prod.outlook.com
 (2603:10b6:405:2b::35)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN6PR1001MB2068:EE_|CO1PR10MB4500:EE_
X-MS-Office365-Filtering-Correlation-Id: 3fe1ba54-8490-4ca2-4292-08dd5c18b457
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aHRVSUNhTzNGTEszM0lQZ3pCbUI1eWlSTXF2c3RhdlJhaHZDbWd1Mlo0eXkv?=
 =?utf-8?B?WlhuT2lhbm9FNXNPamVZOVZkNTZjYUxxSndONnhLVjZmUStJU3AzY0VnWkVk?=
 =?utf-8?B?Y1BpV2NYM3M4amdpSWJkWXd5ZEtKYzJlVDJtWDU2ZldSUzd1dVpEV2dFYnJS?=
 =?utf-8?B?WkZ1VVdEbktaTVRXVGtCUDhWNDZmY093TitqdmNHa2taakJlNVkrV0pUWER1?=
 =?utf-8?B?NkZITllMUW1SeFFMU0VpSUJXdkZYa0hEUFUzd2U0V0dDV0NhZFNZdWdXMHA2?=
 =?utf-8?B?b09KSXhxU2JMTFFhWVZtYWRuOHppelplR3dpck5PRk90L2R6QXMzcDBteVgr?=
 =?utf-8?B?czR1cDhiQW50Z3dmVC84czZkMG5EY1ltUlV2VzQzSks5QW5CY1VqdHJpUkJM?=
 =?utf-8?B?Nytmcm9iWmZ2Y3JELzAyWGY4VHJwTkdMTHh1SWN0MGNrUFE2ek5kUDBLQWlm?=
 =?utf-8?B?ZGgzOGt5N1dHakdSRHhKL1pleWJ1bnM3S3gvS2RTWTFrSjBtSm1BMXdyUHM0?=
 =?utf-8?B?V3FaeS9XZ2ROSlZFWUN0K1BYdWRWUGw0aFdoR1U5cjBhb0crWVdlTXM4SzJM?=
 =?utf-8?B?cms5Q2JQcGk5cXQySGpXc3RoQm5UNW9zL1ZZd29wb3BGTi9lZlFTNFJ4T0pI?=
 =?utf-8?B?N3RaemJLUnN5UzJhZkt2SzlocGg5Um1zOUo5enlMeHNqaVJKOWlmWWhTN3l3?=
 =?utf-8?B?dVNWRGxuMTVYVmRoQ3U3MXhYbm1OTVNvN20yb0hiZi9mN28zVUI2U1VpaURk?=
 =?utf-8?B?NWt3ME5mVi9Od3A1Y3JBdWZMSlllb1h6OE9CQjBkYmNZanVXNmxLTkQ4dTI2?=
 =?utf-8?B?eS80QWlPclNYSlVUQXF2U1hEakRGaktmVDdVbFJYejJZOW1vMEtjbXZySzJ6?=
 =?utf-8?B?aUxCQStkQVNDeTZuSzJKNVBybVBqWFU0dDB4RnBuZ0Y5U0pjY0wzY3F3VWJZ?=
 =?utf-8?B?L1pORVM2aEs2cDRBRXZLTEdVeEF4Z2JLVElRK3RUUitLcDBla2FVYkJLQTdQ?=
 =?utf-8?B?RlVSZlVDRElsRzNnTmdQQUVGWlQrVU5EZWFxM1QwZmxDRTN0V0NFZk9VTnhY?=
 =?utf-8?B?NHZ4Wkw4UVMvTjUwcXQzVzg5Z2puY2RybUUva1lOV0p6UFp5Z1d1Z1NBWEJa?=
 =?utf-8?B?c1FtUzl0WjVPSklqTWhYdHBtdHJVYkNGenBYSFZSbUNVUmUxb091WStxOTlK?=
 =?utf-8?B?Yk5XTk1JckdLWDgwVUZITDJ2UUtzRy9RWmVxdS9Melh2YzVVOU1jVWZ1dnlH?=
 =?utf-8?B?VFQ3NjlSbWd3Uk8yR3pIaTBmVXRQcDdlWFFVd0hMcnhHQVRtQ2lGUHBPWWU2?=
 =?utf-8?B?YloxdzlEQjZyWFdvUG5qWFRDV2VXL05NRUpKc0l3Qkp1SDZyeWZsd2pidndp?=
 =?utf-8?B?bUZ2bGxtcFN0bzUxUkZxdjRWYk8vZ0lKRVprQzM2eElMazFTaTlDZkRYRFJh?=
 =?utf-8?B?WnVPbDFOcVIrVjUrdHAxb2pqSjRHamRVUzAxV0xhSHA4Q2p4K0RjQkVlaHY3?=
 =?utf-8?B?NFBOZ2FJTFFwOUFWMnI4WXp5MzRvMXhwT3NpSjUzTk9NQ2xZSllHNWdjMFp2?=
 =?utf-8?B?VFFQWkhacEk2VDBHK25HSHJ1UFhTVGE5SkxlRjQvN0JCWVRqOVY5c3VsUG5X?=
 =?utf-8?B?TEpQd1NzUUxTeTNsd3hqU2FNV21xSk81RjRHK05KcUZtOGxHV1J2QmtsbjUr?=
 =?utf-8?B?MjJBZHBobEZvako5bUJzbXlHSitMZnZ2VGdydnIxQ09zQVRUemE1VTB5Y3VX?=
 =?utf-8?B?dnpiNDQ0UnhSR3Q0UGtaUEFHZ0VoajFRcnpyc0FYUWR3V1h1UnVib1czZ0dz?=
 =?utf-8?B?VnpjcjVvcEhMTGNwcG8wR0FEMXdJS3B2bU9nNWxBREViSXhQV3QzR2dxWWVy?=
 =?utf-8?Q?ipSVf2U6VhrOq?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR1001MB2068.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UHowTG9pcUlLRXcxcDVBWWE5bnhKTGVFU3Rob2pmd2hjcWtVTnVxbWtWM0Vk?=
 =?utf-8?B?bldlWHBBTzBuUkk4N0l5YkhqUXhiT0cwazNySjh0RHNGb29yVU9Hckh4U1FM?=
 =?utf-8?B?RzlqeDJicG5RcVNTdnczRlByN3ljVklvRXRVVGE0cWx3RThPemMzM3lNUTlF?=
 =?utf-8?B?cm16dnhSb0xBTUJuU01JeDFzNGtzQStPRlY2OTNrYmFUbCs4Q2Q4UlhtWW5E?=
 =?utf-8?B?UzJ2QldidnBhSHRRdk4wYXlXUXFMc0ZMUTg2dUlQemdvWG9zMStRQm5Tc2s2?=
 =?utf-8?B?dDlQNFlDck44RUhIZUVHZEhZckFQRm13bEtWM29MMXc0eWg2Q0tPM0h6YldT?=
 =?utf-8?B?UTJtbzFtQk1RNEJ3Z0tDdXZvY1RSSi9TcGtPWHhsKzBHeDlZamFTMkJNeUpV?=
 =?utf-8?B?aHZHblgyc2hNWFk2L3hlT0R0Z2w4Wld1K1RhVUY3bVh3eWJ0eGhhVmxNMHli?=
 =?utf-8?B?b0FnU0g4VWt6bEJFb3N5VzRBMklEOFR5WG9Vd1lVN2RIclkvQlE3WnNUQ0Ux?=
 =?utf-8?B?bjR1bTZ1WHhCMVByUE1XTVkrbWtiN2VQZ3lSK243c1QxVmpIV1JtQ1BsaitK?=
 =?utf-8?B?dUh1SnBtdENxKzd4cUNOTDN6QzBqVlpOSndkQ2tuMkhFVWZjeG9LYzdHQWNt?=
 =?utf-8?B?a1AreVB0K1VsS0J4NnBZQW0wS0EzeVJxZzN3RHJ3NTdCNkh5bFJiS0h0UVQ1?=
 =?utf-8?B?M051ZlEyT29qbURyTGU0TXQ3K1pkdEZWR0dndGVyMnFGbzdhVkFjdkNTRjgx?=
 =?utf-8?B?dUFWclFlZ0VkWG1tYitKWnl3VU51ZDU4YzRENm0wbWpCTU42RDZ4OGFkeXZj?=
 =?utf-8?B?QkJlTHd1TTdrc3VrQlk5Mm41SlM3VjVKU2ZPaHF4UkxpUEQ2SmY0MGFqQkdv?=
 =?utf-8?B?NHhQdFhFVGgwQlFpeXVwSnJ2UzZIYk1Qck1DZ005UXE2TGh4OWhqcGVYTFJX?=
 =?utf-8?B?aGN1WWIrdVNLOGk4R2VEMFF5TFJFUjNKMk9FSVRWb2t4Tk91cGpTeGdBd1hZ?=
 =?utf-8?B?OC9YOU9YMXZ2QkhKR1hFMzkycGo0S1pCKzM2Nml1VTV2alp5REJSWGljNHFr?=
 =?utf-8?B?bEJJU0R5ZzlkTmljOFlDS2Q3N0lhcEE5STlxUE1KOTFGMFVlVXh6Qkx3VnRm?=
 =?utf-8?B?amUyQ1c1aWV3ZGtIbzlRK1BjWWRjalZ6cGdPL3ZQZ3NzTU00eFNnZlFZZXFU?=
 =?utf-8?B?dlpINDI4VzVtcEplTWdIVXB4VkdhSEFIMzNnczVTcXVJKzllUTRXQ0t1UUJ2?=
 =?utf-8?B?bGh6SURDUnQvbG5ESy9GbTVLNGhQUlljR1hWV29YdGZUZkNvNWJNYWdEVytS?=
 =?utf-8?B?K0RkRUpHVjhXYTJ0RmY2eFd3b3RwbTdZWnZZTjNQcm1iTWpRS0Z0bmdwQTVO?=
 =?utf-8?B?ZDF0MEVMRit1RDlWeUNVb0VaTk9MV0V4bkVCako2eXZDZGFqVWxkUTFwa1NV?=
 =?utf-8?B?K2ZISDd6WS9EZmoxVUZOZVBwUXZFbHNGNUNwY0djN1BpMDFPWTZSZm93R05S?=
 =?utf-8?B?a3puR0hHTE94Vkp1eEd6Rko2TWh5dVFpWFkwc2JGZm4wT1pER2ExRGQ1dDJx?=
 =?utf-8?B?NGdSMEFDWFJlTjhyOENYMkxjQlNJL3dpN0wxOVRnbE5IT1FLTFUxc3VvU1Rl?=
 =?utf-8?B?bkpYa1F3RWQ3UDFkTXV5ZHdiWW9BRThoOFNzT1ZDR2M5UmltT0FYbkE0RW1I?=
 =?utf-8?B?U3hMQlNoWlpmdzA2N2tUU2VGMnBBVWNHVnpucWFsNVcyWXZIeFM2UVJ3WDJ0?=
 =?utf-8?B?dmMwaExMVDlLWld2K1NJbFhSb05XcFFqMlZWNjBGM29jVDRPM0VmRnppNmp0?=
 =?utf-8?B?QWpLNnVkU0pSaXY3U0J6cllBRVZLLzY3RVQvUDBlaTRidm1NUVlORHJoeDJJ?=
 =?utf-8?B?R09GUkxORHZCUFkxTEwvR0k5ejByTEV1U1BTTGZ3eUovU1pFcDVTNlFFVlFk?=
 =?utf-8?B?UitDTnJ3ZmtDcHVkdWZUTjNLbjJmUXpCVVhEc0FNOVJoWHZFaHpoeUt3Mnp2?=
 =?utf-8?B?TFNZNTZVNytpSDh1MC9qMnl2ZXd6eVVUSE1FMzh4dFJNZHJhOEpmZnFNQWh2?=
 =?utf-8?B?dVJ5OEw2VFNMbE96dkpnYTBTdFdXbU9ZL3l1VFN6aGxPV3JHR3BOcXU1TXFH?=
 =?utf-8?B?M25LWGNVYnkwTjhHSFJLRExidkJqSnRiallrOXlzMWhlNjl5SFNBUTcyOUNw?=
 =?utf-8?B?d3c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	fMqt6jH3lRQKAG33SpPChmpJkcpnPI6/Z4Qi4NVcSmJs+5AVp9YgS74jpTJ+JZOUpPQxV0/IUf3RQwgXojZsvQweg6AZgDU7l0J+kPjsNAXmQiANhTmdURuSRVQw2w5n8bkgtIU5TsA8oEZQzsFVHSYZGrXwz9wbCac9gUl0pHQRJRBqwkgSkrhJxpx8X//ZX2HseImaIWQzeYwFDF2XPNymeDqiaGneAaWlrVcm+OK3W9pndon6Ffanr210Wok3SBqWTBX95tQDWE1SpbSlUTAsH95YeVZkjQekzj/YtlIz3QD4p+2mnaKqomhMUTcCVg+8ibqT801t5qH8yMx1J8v+0AostU+S6NkU5FP3K+Fv1L12anyJaWVwtJCN0zA5vtMZAUiXmobe5WRHXcovKGgS+cgG0I5CY2v3QD5E4EsXxh8xxCalOPjCxKFr2D9bJu35VO+/gjzeM6WQsl/nfivNSuSlkH1KjFkZjwT+nmEqYPhoo7U3Q1SbSxAqkAFHC02iU7NgT3vqqvd+P5ihlhtruolg/PKDkxQfyTdwEsYclKEerpB/f4OzWN6y3pRqUlo7v4SVArn9P6bRYHKdGCc/uFbGHiMurFpRVnQxODc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fe1ba54-8490-4ca2-4292-08dd5c18b457
X-MS-Exchange-CrossTenant-AuthSource: BN6PR1001MB2068.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2025 19:05:33.3243
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 07FyR6wJ8Cc4P9MvlGagcqmmy0DUlK5eTkAh/Y4KjuBT3iDd1j9dyJ+MK6PgNFxQhq8lYehjvpXUoRvFt3mSMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4500
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-05_07,2025-03-05_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 spamscore=0
 mlxscore=0 mlxlogscore=999 adultscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502100000
 definitions=main-2503050146
X-Proofpoint-GUID: 5UEOBVcLmmydzvGsF1JYxp1IMw8JEZ8K
X-Proofpoint-ORIG-GUID: 5UEOBVcLmmydzvGsF1JYxp1IMw8JEZ8K

Hi Francesco,

On 3/5/25 3:41 AM, Francesco Lavra wrote:
> On 2025-03-02 at 22:00, Dongli Zhang wrote:
>> +static bool is_same_vendor(CPUX86State *env)
>> +{
>> +    static uint32_t host_cpuid_vendor1;
>> +    static uint32_t host_cpuid_vendor2;
>> +    static uint32_t host_cpuid_vendor3;
> 
> What's the purpose of making these variables static?

My fault.

I used to make them globally shared during the development in case any
other users may need them in the future, but finally decided to move them
into the function as local variables.

I just erroneously copied 'static' with the variable.

Thank you very much for identifying the issue.

Dongli Zhang

> 
>> +    host_cpuid(0x0, 0, NULL, &host_cpuid_vendor1,
>> &host_cpuid_vendor3,
>> +               &host_cpuid_vendor2);
>> +
>> +    return env->cpuid_vendor1 == host_cpuid_vendor1 &&
>> +           env->cpuid_vendor2 == host_cpuid_vendor2 &&
>> +           env->cpuid_vendor3 == host_cpuid_vendor3;
>> +}
>> +
>> +static void kvm_init_pmu_info(CPUState *cs)
>> +{
>> +    X86CPU *cpu = X86_CPU(cs);
>> +    CPUX86State *env = &cpu->env;
>> +
>> +    /*
>> +     * The PMU virtualization is disabled by kvm.enable_pmu=N.
>> +     */
>> +    if (kvm_pmu_disabled) {
>> +        return;
>> +    }
>> +
>> +    /*
>> +     * It is not supported to virtualize AMD PMU registers on Intel
>> +     * processors, nor to virtualize Intel PMU registers on AMD
>> processors.
>> +     */
>> +    if (!is_same_vendor(env)) {
>> +        return;
>> +    }
>> +
>> +    /*
>> +     * If KVM_CAP_PMU_CAPABILITY is not supported, there is no way
>> to
>> +     * disable the AMD pmu virtualization.
> 
> s/pmu/PMU/


