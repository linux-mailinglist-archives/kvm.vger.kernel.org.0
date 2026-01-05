Return-Path: <kvm+bounces-67080-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 373C8CF585C
	for <lists+kvm@lfdr.de>; Mon, 05 Jan 2026 21:27:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 88DAD3094A77
	for <lists+kvm@lfdr.de>; Mon,  5 Jan 2026 20:25:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71DE7346ACE;
	Mon,  5 Jan 2026 20:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hn+p+lFs";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="aoX6eL1e"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71407338F55
	for <kvm@vger.kernel.org>; Mon,  5 Jan 2026 20:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767644750; cv=fail; b=jQ3E886nLMAebort/ESrn1CPu6lhHo2WeJrV/bT/AHMJ0srdIfzJAYi9GBD3rUs4TSu/EJaY2gzEI2dKaqZ1dqH3oBVnFfAHyr9QK7TwO1vaNkxi7tHTTuZjfkBLx08Q8K7zZKmOxVlIjt2Fabt6x2wUjpBTleWlRuo8EYEvIAI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767644750; c=relaxed/simple;
	bh=G3upX2V717MmYsXIvT8DrSdF+qfH9zy7TV++Cg8jcXs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=WRFK1ngJqxdxapzmC8rZZp0ZEs/lnMcCvIIXmthe2AUkuf2cavHFewid8GY1+Q+WfrHEzXm5HKhJHCU16eOesncH39RGpFZOMOxV2Tcq+THKYnMRwAodLxk0AvofTFcNmydka/8IC5lKiZNVepGov0vw6XUm8lpqpdn/fPbrJ8g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=hn+p+lFs; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=aoX6eL1e; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 605JKXa91874348;
	Mon, 5 Jan 2026 20:25:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=HEBNA8KzOi1/ASw0IBZT69GYT/g+r+YapZuBvq66DRc=; b=
	hn+p+lFsUlm5lYEqxMpELbRHZoi9JQNqYAcsBtFWffPGXbUJMcnWnkDjILhgtvFD
	X4iFko2inWZ5Wz4n8XaLipps/bvDlL8HGFFrg1k0htYeZ3ib8SFGxnbBmyBMaVw4
	CFPrVK8sivxM9iDAQTTOQju/VGp/cItbt59rxUlB9iO5psqAP1OTIqRokCRmMKNx
	bghnTeSF1rg5IlKHAGgKmsajqBL/4+VzqXxB+tZXkWX4QNVNPYAvqRIyjzVqRbac
	4EtLQWzm4pSaOvujqZSrmmu3qPbr2EVSz8S5aB3NJ3S5XW7orNwEhM3dlW4G7Ivv
	iDtv8C94c5x4lv1aLWJ08A==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bgkcfr384-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 Jan 2026 20:25:08 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 605IneB5026376;
	Mon, 5 Jan 2026 20:25:07 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010054.outbound.protection.outlook.com [52.101.193.54])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4besjj26c5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 Jan 2026 20:25:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IiZw+Mo+ax2oyEwClvIv92ewrHQFctEz2shvebeW3zgKRk/3BGYYRuL6hJf9x71c1bbeDGcaFYJsztGzoRuXmpWk9Q0XlsP6yR5kUUIVo5eyqajHmpYaXRv+8Tk+DRTUGBtuhCAyUuwswB8T1ZxhOu2zqVniit9U9dyMRowI2c+rdZoKTvzoIOtkIlitXZ6aI/z72ecSDjgUuWHlI/YSHOCwA5hz8oEZ95ytbyRP95ez8R3Mpssbkke5rdpE+d1cVs38NWD/W00oO1UxJ54AkKSvJl/Y0PfiE/XhDcrF6tIAchexEN3V3oHdyZ/ASCqZlIXvdeCBtk2niqTq6zJVww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HEBNA8KzOi1/ASw0IBZT69GYT/g+r+YapZuBvq66DRc=;
 b=Wum4UKxjbkem0566gAbevJlBA+ne1VAVkAC+yDp1vU1hEc/6OMUFk1Ehurg0TY180su2vY4T85xjyLWQRkBDrSFyAWbmPHodLpaj4ah1kh1p9fVKl8gbrHmBKiwTg1YHcTWEUMQgnBlRdfY5giDjN2F3RDGZrnWEeFtJTfgmbxoSsDxqk3vE3rEyEWCMCUCVxWadE4qk51w8U2sOK2F2bRY9a4P8trpu+A7pr0NyiwODTGrGQCYg9/FlKiLfMv2PtnW5KuGfw6+ROoQpB8xpdD7c7EnEyYNNl0l0Tk80XY+J7oAbycMzFt7CFhWkvRnxgidHGks7rBvJ+owtUInEfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HEBNA8KzOi1/ASw0IBZT69GYT/g+r+YapZuBvq66DRc=;
 b=aoX6eL1eK+on8uEmjmJ+DZACD6WXbukxjq5wrBlvvXqQsw333arKt9lJu/QqIxj+coIUi1wVbv32dHzpBPoxAce/q375G/9yxtCH0abbDoNoyBpgIlyrTCeAHU0do/FFdGpsdPdYOYDltLF6KX5fAvaRqi6wLULWKgeksREmJIk=
Received: from DS7PR10MB7129.namprd10.prod.outlook.com (2603:10b6:8:e6::5) by
 LV3PR10MB7770.namprd10.prod.outlook.com (2603:10b6:408:1bb::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Mon, 5 Jan
 2026 20:25:04 +0000
Received: from DS7PR10MB7129.namprd10.prod.outlook.com
 ([fe80::721c:7e49:d8c5:799c]) by DS7PR10MB7129.namprd10.prod.outlook.com
 ([fe80::721c:7e49:d8c5:799c%3]) with mapi id 15.20.9478.004; Mon, 5 Jan 2026
 20:25:04 +0000
Message-ID: <0f9f360c-b9a8-4379-9a02-c4b6dd5840a3@oracle.com>
Date: Mon, 5 Jan 2026 12:24:59 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 7/7] target/i386/kvm: don't stop Intel PMU counters
To: "Chen, Zide" <zide.chen@intel.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Cc: pbonzini@redhat.com, zhao1.liu@intel.com, mtosatti@redhat.com,
        sandipan.das@amd.com, babu.moger@amd.com, likexu@tencent.com,
        like.xu.linux@gmail.com, groug@kaod.org, khorenko@virtuozzo.com,
        alexander.ivanov@virtuozzo.com, den@virtuozzo.com,
        davydov-max@yandex-team.ru, xiaoyao.li@intel.com,
        dapeng1.mi@linux.intel.com, joe.jin@oracle.com, ewanhai-oc@zhaoxin.com,
        ewanhai@zhaoxin.com
References: <20251230074354.88958-1-dongli.zhang@oracle.com>
 <20251230074354.88958-8-dongli.zhang@oracle.com>
 <de20e04a-bfeb-4737-9e30-15d117e796e8@intel.com>
Content-Language: en-US
From: Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <de20e04a-bfeb-4737-9e30-15d117e796e8@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL1PR13CA0201.namprd13.prod.outlook.com
 (2603:10b6:208:2be::26) To DS7PR10MB7129.namprd10.prod.outlook.com
 (2603:10b6:8:e6::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB7129:EE_|LV3PR10MB7770:EE_
X-MS-Office365-Filtering-Correlation-Id: b1b3bdc4-ec05-4b7a-e12a-08de4c988246
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SVZKRnFUUmphNytYeXZURXRQMXA0d093enlQVDRLNTFxNEdDNUpLbVIrME94?=
 =?utf-8?B?Wms5OU5hMGJQVEhKemU2d3QxTEpob2JrMDZZbFJyMy9oYzAxbUdhVGxhQXNC?=
 =?utf-8?B?WFhSWE5yWTZ5MGtUSHcwbnZ5NmVZUm9taHRia3AzL1dBaDZsVDJhT3JzTlZY?=
 =?utf-8?B?c0V1Y0NNdXhETmdITGhlZFZpTlFSUVQzVGZvZTRQeEp6QmE3cVozd1dUSEh6?=
 =?utf-8?B?TzV1NVN4TTdQUVBVYWQxdXZxTndsSjFsSkRrcHNGSW5zZDZvbFJJeEtjRENx?=
 =?utf-8?B?SU1lUDN1eWZ1eVFMZ2lZRHdNQmVCbHhRaGVoWTZmdks1MDlGSmE1UTY5OWNC?=
 =?utf-8?B?bnpDbGJmZlFJREoyZTlySk1qa09iek44WDJwSGZtMlE3NmpGeW1UTm9SdExZ?=
 =?utf-8?B?WGc5NnZJZGtxQ0NYM1U0Ujh3WFFEeDhjOHZRbFhnZTR4T0E5b3JSK3RnRG93?=
 =?utf-8?B?NEh4ampWY0ZaWjhHWEQzYnJQOGViODRycy8vNFFrQW1HaGo0Nmc0RzlCVDcv?=
 =?utf-8?B?M2RaVER6M0lNdEFaejBqSThVZlc1ZTJXeFBrandEUy9rK0ZhMndNZ05KR1dM?=
 =?utf-8?B?L21KYmc4K3ZrSXpUaVorNWY1RmhJTWJNd3hOUnVQSjlQY0NRRUtTM2xRSHBU?=
 =?utf-8?B?RHJULzllYmRwN2lxazZ6NENJaGQ0dzNYUDNWUmExUGl2eUFNY1VoWXBoaDE0?=
 =?utf-8?B?RDJJMVl3K2VLMWNmb1dyM2hVMGp3TVl5RU9XWHNySW02U1V5SUtibjloM2w0?=
 =?utf-8?B?SFlwN3YveXlTdlE3NnJpSHNIZWI0WVpzSk1jS2tkRXY0Y2RZNE1yR3h4Rm5o?=
 =?utf-8?B?ZXViMW4vY1NjZ1ZUM2Z1UnJZRTFQa2M0UGpRc3lGb1J3SzBNY1NpSElEZ0FF?=
 =?utf-8?B?MGs3d25DK285aVdLV0Rja3dTZ3ZmQVROMmY0dXpDVFJVMkxoYzlIYXp1T21r?=
 =?utf-8?B?Z2RoakZvRk85U0xaUlNqNzJGTG45TWFtMVRNYm8zUmN1QXlDZWRqY29kRyt3?=
 =?utf-8?B?cHAvcHNmV3FKWW9ZVENoWVZaT0RnUmRZczFPY1E2OC9MREM5NDB1WFhlYld6?=
 =?utf-8?B?bGo0TTQyMCtsQm5nanFQeWRZN2MyMGIvZWtBbUdYUmxhdmlwUzNzMEdMUW5E?=
 =?utf-8?B?STlqTEwyVmlvWVV5dFpWUk9ZOXFBRmU4bE9BbW5GSGFDQVhoS1oraWd4VS84?=
 =?utf-8?B?RDdNdi9MUHV3bFkwRlViY1UwMzJZWkQvQU9QbnQ5YnRYU3lKc2J3MC9odldD?=
 =?utf-8?B?QWltVWlGelU3bUR4QTNwc1FwWmJUaEVCVExZNFViQkdhRlNZMG8xdXNmTENo?=
 =?utf-8?B?czZ1QUs4a1FMUmZWRm5WTTFRbXFoT0o5VzV6QlFtVEl5UytmYXYveENmNjE3?=
 =?utf-8?B?SkxWNXBiQ29IR0hWUEZib25qZWlzZ3FHaXo4aTdJVHZ5UHBsc0MrS05MYVFB?=
 =?utf-8?B?ZXJTc1c4aEF0WVhnRGpOUVBBUEdTRWJ3bHhuQnNCTDYxaUFOQXkxN1NoZFlL?=
 =?utf-8?B?RmNhY3BjZHRaTHdJN0ltZFVBWFNVL05PZUt6dks1TFVKenpqb2o4enhoK3B5?=
 =?utf-8?B?OW5EMXRwUm9oRmVJQkFibUx5Y1VnRzZOMTE5N2NWU1hFTWxHcXFTWGk3NGVj?=
 =?utf-8?B?OEFKUHBtaVVIV0JaWTRZeiswYmUwbnlmeHg3NHBNaHR3VmI4VkJPcEpJMXMy?=
 =?utf-8?B?cXBBNThoZFc4ZWhxdHNsWEtyckV3WCs3LzY5bHVTWXpuckhCQXh6Y2lDNG5r?=
 =?utf-8?B?TDA5UitzNUNhSk1BU3RBSjhDTkpMZXg0SytHZDlneVhTYjNNZVNrWGpMcExW?=
 =?utf-8?B?RXNZWkwxNlRXQUlZL2xZMjhBZ1ZBUk5ROHdkcmxqa21JQ3czWjlkUjZpdVRL?=
 =?utf-8?B?T3JnV05WWTMzdUNKVExqK2Y3aGtRTVpoRU5JSWZCK2RnMWxMS0orRGU2dGMw?=
 =?utf-8?Q?emIYMDReeiLnHhAkqYyuTOTuN5k/5b0d?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB7129.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aW9UKzU1MU1kcjlPeWhaeFZZZUNVTVYxVlhDL3kvdVYwWTB3eFZzNUVNSkw2?=
 =?utf-8?B?dDFpN1N2Y2ZiejRwRlFPbUhncjlTbmVITzNJZmFIM1o1Q3NxNGh2Z09ZMkQw?=
 =?utf-8?B?Z0ppTUlNSml0djFOUFhyTnFZZmdKOGhHZVFKdDVzZ1pDNm9xZlM2a0xvck44?=
 =?utf-8?B?SkpUeWtkalhEWUpzbzM0N0R2YU5tbm92SzlNZmF6RUFrblhVMXU2ZHNMUE1l?=
 =?utf-8?B?Q2x6SG01TjF6YWdOR2s1SkxlZ05CejhqSDlJVEZNYXVwVHI4clNKUmRhOXlR?=
 =?utf-8?B?Q2VGUjVQQkxSYWJZR1NyOEJTTTJiVEh6ZW1Wa20veFY2UVVtcUs0V3BIMXVT?=
 =?utf-8?B?djJQNmVhekgzL2dSUllnYTBibzZIMFlnUUdLQ3VWcmU4N3hFNURoZGJXK0p6?=
 =?utf-8?B?SVpVMlcrcC9iZ2JsV280dXkvK2hHVDh1VEZWUWUrcnlQcm5wcnRleXhzbE5N?=
 =?utf-8?B?RnZERGFpd1AwM2xNQWQ5WGozVmVJVVk1VCtLb2wyWUpQRUJKMEcrU1V4Tk5m?=
 =?utf-8?B?MkEzbk9YSW1KVXdtWTY4dVpaM1pGOERPRTUxT1VyY2pJWXloaU9zYTZFRTNZ?=
 =?utf-8?B?TElKLzZyZzd4OUh5dkNzQlNFcUFjLzk2cXd0ZnB1K1h4T3BFd3ZpejVoK3g2?=
 =?utf-8?B?YmUzOEZPRmlOY1FPNVJpVklxMTF3WlVCT0hNcmZjYkhwOFpGWS9LNS91cmpV?=
 =?utf-8?B?MTNHQkZaQUVhM2QwRG1UYndoeUJGUnFsUFF4ZnNLSm9hTEJlQkFNU3FGdzlL?=
 =?utf-8?B?WDgrYy9ibldEc2syMFR0c1hmQ2VJMFFSRU53d053MTBEM2tDd21LNXQ4T3d4?=
 =?utf-8?B?UGJzKzRMNDJoekJVUDVkc1JXajRLd1FnWGVNUURGaitSMUg3Z1JRRXFJTUll?=
 =?utf-8?B?c1BBL1AzL0djMmR0TFcvbHhPWTQ0VnhtYTdSaDJUeEljNldTcHArN3lSK25l?=
 =?utf-8?B?WmRmKzNOOE5WOUhBMjJRZlBIMWUxMkcwRTNvK3FuOG81cEtyVDNvYk43aGtR?=
 =?utf-8?B?ZEZraVdkaXZ2RmZuYzJWL1JIWi9ybXZKcER0NEZUK2ZyUWVLTEF6UnRMZDkx?=
 =?utf-8?B?SmlsMTNub2VlOTR2S09YS3MwYzBTay9zTGFOSFdQSkVFaUpOY2t1MEFNdjYy?=
 =?utf-8?B?ZlU4eWYwQW16bG91KzBma3REQlFJdXdWbEZqMmVZZjZwR21nVFpnWnJuRytV?=
 =?utf-8?B?RjBEV3lCcVpZMnJ5WDllb001SmJ6SHRPRlRXdmk2VE0ySnhZdmNiUFRiYlRv?=
 =?utf-8?B?Y2p4YUVmSXU5QUh3UEZpLzhwaEVvR2pnYzMwdDhaTURNV3FMOEhvdlhhT3ZO?=
 =?utf-8?B?Umdsdk5pMkpmajJiWHN4amhpbzlvM1UyeXEzWE9NQkxhQjIwMHE0WGN1TG9P?=
 =?utf-8?B?VlhNZkRkcnFUbWZNYzhUZjBDK2p6Q2d0VW0rQUVLNStUOW1NMWlZbm04WWJj?=
 =?utf-8?B?Uk4zODJXS2tCd290TFQ4cTI5d3RaWGZEYTgrdWZXQUZPdVdicC9aYWhKVjNx?=
 =?utf-8?B?Yzl0TllmNmhBVU9RdlAreWE4NDFhbk5MQ1RtUUJibG5NVmg0aVFnVnVrK0RT?=
 =?utf-8?B?M01YT1VRMnczVVNNVWZtK2g3SW9PVFFNdmVlbTlmQ3lFNWc4TnVpYkZxaGNL?=
 =?utf-8?B?UzQwVkhCZWxMeTFjeld0UWx5UG9uL0FmdDYzZFhZbjdxQnVqK1VIelZhT2Js?=
 =?utf-8?B?ekdRclkvNWp2NUE1dU1IcWVyVFRnYTRDa3FBSU5YbUYwZTRoVThzWkZLZ1Rk?=
 =?utf-8?B?bFQ4aUp5bmIxY1lVNnlpdkk1WkxJdDdxeTI5R2xLU2Y3bU12TXpvcHAwM29M?=
 =?utf-8?B?ZWdRbnJMbUhmKzZLc29nWDBGeVNlNklQMGg4bVhOSVdObXd6OC82K090cC9I?=
 =?utf-8?B?bW96NGowamFyYS9RVDQvTEduOUVuaUtiYlJmTHRNc2YxL0gzZ0VRZk56MUN4?=
 =?utf-8?B?Y1NmWWlIdklIN2F3YVg3WkNMcHNRNmkvMXNoOXdncVNsZFRaUEM0MGw5RmZT?=
 =?utf-8?B?YWZDM05qOTM4cjZUNE55aVZXYzg2NGVCK2svWFFSSFVvUWhjKzFyNVlXQVBv?=
 =?utf-8?B?MFRmUENOWlJHMjlxR3diY3dwbmgydVlpZEYrc3cvK2VwcGdzU3ErOTNCRnA3?=
 =?utf-8?B?Y1BDNDZ6cnd1ZHdhUEJ3d3YrZTk3czRvSVZYU3c3d0lDbXhYTWsvcWw3Q1k1?=
 =?utf-8?B?a2RVaGZXdXJYMWk2TFBIOXJHMzlCTWNGT3lzT21VMjlXVlA3SkMyeTB6L0Nt?=
 =?utf-8?B?WitSK3hxYURDYnRweXJIQkNIQjFoWEVQZWkyTzMrY2RQSnN1dFdWUjkxbWJa?=
 =?utf-8?B?Yy9ZalR2bDBaNjBpUU1tNW4wcXFiYnJkYnlTcGtlbG8wYmNYS2daSkpPL1VZ?=
 =?utf-8?Q?H82sxhnBX3Qiiehw=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	/0KI+anEubgjDnnOEFfaPEfJJQsfz43lfL+2pLvLWneora+YOvhHbXzCKHxLT1EszzSAuoVst8dlZe2KjpPUPWW+MmJv9iF3ebFh1xp5x7nsPTYdBFMtqFeLxA8h3sp0c2RXUu31wK872WbqbIRp9Ngrt8inGrSWltsQFB+HL+VFOvlfntbEeIBvvyVdcaF9d/719TOBhoM/FsqBcD7h6mAJLkhYhy9XM6ORf5B8WsqNHsCCOEx4i30PnjnNtqG/WqnpLQewfZqbd4bIwgZGuQCdQqeOxFHNk6GPWETW4q87aZXTINCiIpyZrtKwvNMGcw4H1IGDQ426+/U2GPOIdw1hCiPdM+hPm2Mqeyc9Bzl7t777nFMSJKSwK2lpg8NjVnFG5iN8WUHbnNdm8Wkm6IkuBh7TzBEzdM9hPMGwHvWOWJjLtLglLn9GdAbvlHGyyNL55bloqxXbCanrJIiymLBnJIbiLKaAdkQqF5AAEWCfKnvwX6SOFijT+vCO0M5xyUukDObT+FQufRMQb7aIkvYgzsZO8zYLpA8ILusNC+NxuvRVPshkoHNgw6RU7lT2yGxouhlom5ml7bSDEuPOM6R/JFquUT5e7Zpwc43Ta08=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1b3bdc4-ec05-4b7a-e12a-08de4c988246
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB7129.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2026 20:25:03.9328
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yl1k5Nns4Xf8k3ieRlRXndUrHLqgpOa2M/NQJHRwdCZEcCnps9HLPfonIXJLH/KOghyRyFYsp1T7JwRxCXXTkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB7770
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-05_02,2026-01-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 spamscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601050178
X-Proofpoint-ORIG-GUID: frvsG3NOT7vR-lOARmqzMMzepYRohoo3
X-Authority-Analysis: v=2.4 cv=VKPQXtPX c=1 sm=1 tr=0 ts=695c1e24 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Nyeg5mjbU8dZabaxP9AA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:12110
X-Proofpoint-GUID: frvsG3NOT7vR-lOARmqzMMzepYRohoo3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA1MDE3NyBTYWx0ZWRfX3ZicDk0gO0zN
 KhgnLnzEJsHAr1Xv/VvSsbI5TkFqcfGWny+BiCNDaIluoVDGvLzZDADFkfxVuH2Y+JZfwp9V4pm
 8jslOfoIbUB2y8wiJzgwJW12amiEuL4L4DBDk24kA2TgqBA9Y0+j3tBESI2ctRG1L5ZkcV1MUYc
 cln8xKyxQbqzBzOigcyKipVowEBLwNuLwGR+9MIeUA8En/YOg9kett/V6nm5BoJhGaVmReyrplz
 gTe+0vLhoq3SwGKaFYo+Wc0BQvi512DPq+ka1CXh36Kd9BkzvoCrMALYwC9V7WqOaxK0tSFgx14
 i8LSnbw61VoEcpHy0LsTLmjZGhaXbq5YbeBcKRt8LTAVcARK0q421MT++baqPsd5ZnvemXQr6Sf
 0Qjdv/+7k2gdqY00dojrblr1txZumxSkE+yhCscFd20DKZHsz6rhGqJxIBNOlGUS3mycKeVGLKE
 yy4fcfRUmtKm1dyehWCVgo7HEuQ4+YGjVz/qY0RQ=

Hi Zide,

On 1/2/26 4:27 PM, Chen, Zide wrote:
> 
> 
> On 12/29/2025 11:42 PM, Dongli Zhang wrote:
>> PMU MSRs are set by QEMU only at levels >= KVM_PUT_RESET_STATE,
>> excluding runtime. Therefore, updating these MSRs without stopping events
>> should be acceptable.
> 
> It seems preferable to keep the existing logic. The sequence of
> disabling -> setting new counters -> re-enabling is complete and
> reasonable. Re-enabling the PMU implicitly tell KVM to do whatever
> actions are needed to make the new counters take effect.
> 
> If the purpose of this patch to improve performance, given that this is
> a non-critical path, trading this clear and robust logic for a minor
> performance gain does not seem necessary.
> 
> 
>> In addition, KVM creates kernel perf events with host mode excluded
>> (exclude_host = 1). While the events remain active, they don't increment
>> the counter during QEMU vCPU userspace mode.
>>
>> Finally, The kvm_put_msrs() sets the MSRs using KVM_SET_MSRS. The x86 KVM
>> processes these MSRs one by one in a loop, only saving the config and
>> triggering the KVM_REQ_PMU request. This approach does not immediately stop
>> the event before updating PMC. This approach is true since Linux kernel
>> commit 68fb4757e867 ("KVM: x86/pmu: Defer reprogram_counter() to
>> kvm_pmu_handle_event"), that is, v6.2.
> 
> This seems to assume KVM's internal behavior. While that is true today
> (and possibly in the future), it’s not necessary for QEMU to  make such
> assumptions, as that could unnecessarily limit KVM’s flexibility to
> change its behavior later.
> 

To "assume KVM's internal behavior" is only one of the two reasons. The first
reason is that QEMU controls the state of the vCPU to ensure this action only
occurs when "levels >= KVM_PUT_RESET_STATE."

Thanks to "(level >= KVM_PUT_RESET_STATE)", QEMU is able to avoid unnecessary
updates to many MSR registers during runtime.


The main objective is to sync the implementation for Intel and AMD.

Both MSR_CORE_PERF_FIXED_CTR_CTRL and MSR_CORE_PERF_GLOBAL_CTRL are reset to
zero only in the case where "has_pmu_version > 1." Otherwise, we may need to
reset the MSR_P6_PERFCTR_N registers before writing to the counter registers.
Without PATCH 7/7, an additional patch will be required to fix the workflow for
handling PMU registers to reset control registers before counter registers.

If the plan is to maintain the current logic, we may need to adjust the logic
for the AMD registers as well. In PATCH 6/7, we never reset global registers
before writing to control and counter registers.

Would you mine sharing your thoughts on it?

Thank you very much!

Dongli Zhang

