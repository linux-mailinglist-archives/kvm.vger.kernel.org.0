Return-Path: <kvm+bounces-68412-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 78931D38998
	for <lists+kvm@lfdr.de>; Sat, 17 Jan 2026 00:09:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2758C30621E3
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 23:09:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31ED9314B89;
	Fri, 16 Jan 2026 23:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DGMBN4Ht";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="HhSIQFEz"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D62630FC05
	for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 23:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768604982; cv=fail; b=rdEHY0z/xL9ge8moDeSF92CqcZl7hxx5uhh7GHtqXS1ipAmXM2cU+efJFFntegOXrT1dbLfbRQ/3PJYnGAV0PeSx8rPhfkphWSbXjd9kIam5U35BdmA07U5U2l8KYcYGKeEL3W/LqFnampxk2bFFXBqs8qlsnihrZWJv0AyeDu8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768604982; c=relaxed/simple;
	bh=GKF3vm7WN1wsZW3eC84Fzs8m+cN6CGPpRoUlO5zXkPk=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HoBVHTww7v+QcHrDm1ZIUC/+q7B6MrhRUFxME3j0mpL+gz5BfhnyR2y6uYNHrSu7wQNkVlLipjfchfAuMuxzhdeKQtTsi2hBZP9YIPSMag2l9C8M3a67UFGtiYLmwADk6QvlkcHYVNPrIr/GKICaYqTzv8d8o7BS3Oi4Y5smIWo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=DGMBN4Ht; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=HhSIQFEz; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60GKW0oM3528575;
	Fri, 16 Jan 2026 23:08:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=+w8m3m2+l6px0qzwrt3DKW1ERFJUf4K8+8pKnNTZ0p4=; b=
	DGMBN4HtplVdfKnix+dZG3jeTWaS6cPvuRUedSF5TB7EGlWIhQjfOsQ+RruQ5gh9
	Ma2ehgXp6O860dkjkR8ci3x6MjrMKZ8UnCt1QSqLcgwvpJbNIG9Sg285v7oyKRs0
	UUhChLdhtQ5GaXiCKNr8g1kdodMMRF6HwV47BXB+D+yUAecrIqxxOOfdZVhoUx50
	/yNPio6ZVgY3+XgrNgsLN6PKEI+BJmop4KUVIJ/shPJbP7oWP5avx0LnewIDZ6gM
	e2hec/fX8Up5v1bivNRuOWBUmlBh3NWBEOQB17gu8GQUKI32IjS8F/GCL6DoSmzw
	XwywUveVqsviJN9GCEUQlw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bqveqg5x5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 Jan 2026 23:08:59 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60GKt6M2023202;
	Fri, 16 Jan 2026 23:08:58 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011068.outbound.protection.outlook.com [40.93.194.68])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bqvsqkp81-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 Jan 2026 23:08:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uknAiso1cFx0CvEPShG6FFdiSlblc4aXpqO0B8oNsKx+df0ChqIOUn2Ux70EFOPRbHHGRpSJlq6pblHEljliwDuTd445oReRstZmMl5tb6/VfWecoHxPUgFmGVRL9r0pr6qMMS1XItgRstXp79y+K9dm9ggTFAfUcn6v362KnOwtzqhBC5ZOZVSMhDMHdvDticblwHvHjYvLc4+RPa/yMU+oJbp6W6dVKYiU/XASeNaRdHiqZaVR5ux4CmGqxyfuDmm8agT5FluzfmZ71tIfC21qPlyEqpXAvtk7PK102pNQLsBnbzn2h0oGSFSonpnoRIxcOEYVMIT0yOhXGD3shQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+w8m3m2+l6px0qzwrt3DKW1ERFJUf4K8+8pKnNTZ0p4=;
 b=fUPjBVn5sfUlZIWMNlExftIMsFJKUEqWHQ+oixrS7snrySWTjKN+s1kuVn4CgviIcE5bEO/MUMFMy4HP1IQ9cTaCyM6SLgGu/Ghz9mdxnzWduOzgR5YwY3X50CJb1wwMFNNG2ZnjLvN0PUB2iXYCnk3bOjDtb2iMPfwEbpLNvhDyfB3iJUQQXB4DlLkLhBCiPkRu+B2gMiuqpqt5COlY4A2O+mGVQ1Y8S7pCU1WRkGcW1f3gDiVaH6XXK7HTDOvEiaqyBKzP7H/xx7dJu/+kdlJrftqP02KvmVkdTxsQRwrhBjRAyk874Kv2LR/vKxkcDknLxdp2oiBm0yXQrbeEaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+w8m3m2+l6px0qzwrt3DKW1ERFJUf4K8+8pKnNTZ0p4=;
 b=HhSIQFEzOdqfB2339sUOn2nNSa70+g4yNIZexH6EuL3Bz+ipZK7E09koDDEV8JRfFY4MXKte2N8xxo4MDtb7pd35vmACpACL5F6G9wkC7v3IqIV6ppcEzFV+cmM4nM/YdD3Qbpj+QbpOnFFQQgo/dcfg0cu+WkvQVYLxPqAOV9A=
Received: from DS7PR10MB7129.namprd10.prod.outlook.com (2603:10b6:8:e6::5) by
 IA1PR10MB7388.namprd10.prod.outlook.com (2603:10b6:208:42c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.6; Fri, 16 Jan
 2026 23:08:55 +0000
Received: from DS7PR10MB7129.namprd10.prod.outlook.com
 ([fe80::c649:a69f:8714:22e8]) by DS7PR10MB7129.namprd10.prod.outlook.com
 ([fe80::c649:a69f:8714:22e8%4]) with mapi id 15.20.9520.005; Fri, 16 Jan 2026
 23:08:55 +0000
Message-ID: <6f4167a1-6d8b-4560-b541-c6808d83860f@oracle.com>
Date: Fri, 16 Jan 2026 15:08:52 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 4/5] target/i386/kvm: reset AMD PMU registers during VM
 reset
From: Dongli Zhang <dongli.zhang@oracle.com>
To: qemu-devel@nongnu.org, kvm@vger.kernel.org, zhao1.liu@intel.com,
        sandipan.das@amd.com, dapeng1.mi@linux.intel.com
Cc: pbonzini@redhat.com, mtosatti@redhat.com, babu.moger@amd.com,
        likexu@tencent.com, like.xu.linux@gmail.com, groug@kaod.org,
        khorenko@virtuozzo.com, alexander.ivanov@virtuozzo.com,
        den@virtuozzo.com, davydov-max@yandex-team.ru, xiaoyao.li@intel.com,
        joe.jin@oracle.com, ewanhai-oc@zhaoxin.com, ewanhai@zhaoxin.com,
        zide.chen@intel.com
References: <20260109075508.113097-1-dongli.zhang@oracle.com>
 <20260109075508.113097-5-dongli.zhang@oracle.com>
Content-Language: en-US
In-Reply-To: <20260109075508.113097-5-dongli.zhang@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0154.namprd05.prod.outlook.com
 (2603:10b6:a03:339::9) To DS7PR10MB7129.namprd10.prod.outlook.com
 (2603:10b6:8:e6::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB7129:EE_|IA1PR10MB7388:EE_
X-MS-Office365-Filtering-Correlation-Id: 9af11b4a-3316-4747-af7e-08de555438ad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bnl5dXZqbHFTYjRkdzZZaU1IaG1tYUZRT0tnVXdodDZrUHZEMkVmSGhVK0kv?=
 =?utf-8?B?MUVyQnpNUitHT1YvTVMzNEZjNlE3NFNCcFpNTmpBUXNhemtTbGdZV3dIM2NO?=
 =?utf-8?B?RUdScW1aSDRRVHNGY3FieThCUzZGWHQvcnBZNkFCYnhuNm1qZWxraVVEbGJT?=
 =?utf-8?B?YWg5Nkl6Um05NmVwWnB0OTRqRTdGaTZna1RpTjBtNm5kYXh5dkVkN0IreW8w?=
 =?utf-8?B?eDdCS1dsZG9MQ2hiVUdRU2VZNEZlY0ZvaXhrRmNoaFpEY1NuWWttaVkwSXls?=
 =?utf-8?B?MkdXelhZdFoxOVBmRzQwRnlacXduT0RObVhvQVdBZ0xtL3VHbzI1RytKVk1C?=
 =?utf-8?B?dHl5ZEsvbENZSUJvMnY4SFhaa3NJd1ZiL3IzZGVLUGZ5TXUxK0FncjBIek5q?=
 =?utf-8?B?SGxYaVBDM2J0VFNOQ2U5VWhwODA2MEhncktvT0ZmVjZGYWNIVUxHTGRhd2xU?=
 =?utf-8?B?b1VrMlBTQVBVR2ZabWtObmxwZzEyVGxVREpwMjgxQ29nOWUwR3VNTGVEdHdu?=
 =?utf-8?B?SEVpTEdDRnI0S0UwejBuOHgxajJwK3JHN3dOcnZWNVQ1ZnlZQmVXZjZ6ZnZB?=
 =?utf-8?B?cU4xbXM2TENUQnFqNlRnVjlPaDExd01WZGdSZlk5SDkyRkR0UnBpQzFjVVdD?=
 =?utf-8?B?aE1IUEVnRjdpdjc1emNJNjhXcHIrM2ZpRGVhbXdSWCt1Mksxa3JpcGJCNnFS?=
 =?utf-8?B?Qmk0aUJTV2FueU5qRVpCbll6M29QN1BQcjhJUXdBQlFZOWJIOVBxRHpHYytz?=
 =?utf-8?B?WGZFM093Z3RidHRzSkxDSjNOK1VRRGJpU1ZOcDBvQjI5WWY0bHh2OEMzL0t2?=
 =?utf-8?B?Y3RFMzRDcUxHdHpGamJidlV6NExCSFBtYndFdDdWcWtLM1c5bEpYTkh2SjZD?=
 =?utf-8?B?VDFIK0M1bmF3NHNNZEduOVNEdjNCanUwcUpSTmZxLy81VlNhWE5DVk55ZWM4?=
 =?utf-8?B?c1M2QjJiZUQ1WjJKQ28rQ0trRjBPVWx0dHNHVllvQS9vUWtJRDlvOHlERGRL?=
 =?utf-8?B?Umk5aE43RWFnZGdHbHZEQndiZmpDZnRQTzE4cjZvVVF0Tkw0anZTQ0FjRzJu?=
 =?utf-8?B?T1M3dXlUNjZYU2M5dkNod2JsOGRaV1IyWmk4MDFwbzVGSWc2M1BGK0F6OEdL?=
 =?utf-8?B?QlNRUk9IcE9ZcmpkY0JYSWxvTHB4cmRONVJpSkNwL29zVTZFUi80bVpsdU5s?=
 =?utf-8?B?YWZVUlRtdytiNERyaUd1eUJvaXRUQXE2d0trZ3BHMjJnUmpkRDlLNmdSWUNh?=
 =?utf-8?B?RWZtejd0dlRkemNROWZYeHZ6ZkUxR2tpajlrTm0rTmtmQmhsZEFaY0RFWlo2?=
 =?utf-8?B?TUxtWjNzclNxUmd5ZUE4RHEzWTN2cXB6bnZLWkVKV0xtNXVHN2x1NDVyRmkv?=
 =?utf-8?B?cnNpMW9QS3p3d2MwRlIwaDlxWGsvWFRnL2RLbXF0M2ZtU084MmVUU3lVcVFP?=
 =?utf-8?B?eEZlOE50UXo0MktZN2dkUGRPdEJlaUVHVWVQTE9lMk5HVWdweVJzcU55ayts?=
 =?utf-8?B?Uk9ZN3hRdEdzbTVCVzRRQ1RZeCs5cEQvd0MzSC9XTzBjOVE3eUJMVUE0anc0?=
 =?utf-8?B?WVRTbmppUEdKR045cEZ3Q1dCaWpoVHl0b0RuYWxmUElHaUdlUDhrb3ZnQWpX?=
 =?utf-8?B?VlVIS3NSclh5bDE0QlM5WHgzWnN4S01DS25ySlhEWEVtdDdnMlRvWjJXNU5X?=
 =?utf-8?B?ZHM3dnVJaGEzekdTa2NKVExKZ3ltcENVQTd1dmxKTTNVbWhWVjM0TlZ1aWhB?=
 =?utf-8?B?N3B3U3F2eUFPV0IzRW1lRVE2eUl0b2FGUFYvQ2xJelk3WG5lNWRKcHRWRXYx?=
 =?utf-8?B?aGJYai9GMkRVaGthY1FsKzdpYlpQVGZMUDAwbFFibWFBMWlkMFJvR0R3R291?=
 =?utf-8?B?NVlBL1dGY0hieGFkcXdDYUVvdHlRazlqN0xtUVIwSlNRc2UvK2E4MXREaTVy?=
 =?utf-8?B?ei9GdU5xdGlYc1RST051SVdGN1ltZnVCcmJ1UUtPWTlaRVVDQUtvS0xqOFpy?=
 =?utf-8?B?WFZIdHRiSHR2SDlkRFJmSk42OW9iOHZWM01JUUEvUW8yanJ1cU1JWG9tQ2Ez?=
 =?utf-8?B?YnpFL0VOYUhyS3psdmRPeCtocHJmczA4RWkyN1pmOW1MbDFkVUU0NS9kTDN6?=
 =?utf-8?Q?FlXY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB7129.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UmdWc05WRE8ydDFoYlBIR201R2pEWVhDSXFNWWswZ29jbnBKUm14UnViZUhG?=
 =?utf-8?B?Sy9KUkgzK1FkMFNyY1FEUUJESi95bW5wSFMxV3pWRWc4L1pEODRZQkorU2N3?=
 =?utf-8?B?WGlIK05xUFh3WHcxQzRyU25vamVtNnNkY1RtblMrRnNQNHo4MEJtN0VTZk5F?=
 =?utf-8?B?aDVBdy94b2NrSW14SWU3SFJNSG43VUFWL3YzamVEMlkrY2N6cUZIYmgveFlu?=
 =?utf-8?B?S1hwbEwxelVDZU1XMlhVb3YwNUl2ZnA5OVVXMXduK1cxZjB4bEhFMHMraVNF?=
 =?utf-8?B?dXpHZDRIMlhVQUFSZmloK05jT1Z4blVYT3ZlQjlKMEk0Zlk2SjBtOVY2Q0F6?=
 =?utf-8?B?S3FUZlhxVVpES3J1ZTVMNFQ1cC9wU1FxRmUxd0YyMjZicjNOMVhxTjFmZkw2?=
 =?utf-8?B?UzdIQktRTnJsU2xPanBVOXdCZFM5VVZscGYzMzlicTlPWmNTK1hOa0RnYkps?=
 =?utf-8?B?ZGhDbGhocnVRcFlTdTFYTkVaT2dldk1LVC8wMDU0dy9hL0JYMDVqOElRdnZa?=
 =?utf-8?B?YXZZN3BSS2xmdU9GeWVROW1NcldOL3U2M0VpRTUzS0lvY0ZPaEJxNEdERVor?=
 =?utf-8?B?OUltMDJYRjRPckEyKzJYKzN3M0J3ZXJnMWtJTmlXZnFiMzJFaWxOaTg0MW9o?=
 =?utf-8?B?K1NYUW1UZlJTUTRhVDZnTXRYMGpRaENSdFVsTy9qQkNBTW1qNmlkYnVYYTdk?=
 =?utf-8?B?dkh6T0MwMzFWMGpIYTIwQ0FEamxVZDhrK2p0b3JQMEp1UXlDZ054OGNMSFVW?=
 =?utf-8?B?YjhTWVA2bTc2cEhrRjEydU5FZmpaZ085NU1WSTBqVGdWcWtOMHA2QzZsRUZ2?=
 =?utf-8?B?Mm1tTjdNc0twdGUydlBiWVVBT3ZUZnJHVVlSUk85QU53N3BtekIzQTRudGkv?=
 =?utf-8?B?Y3FNd0hqVGZpOFBlRVZJOGpBZ0liaUM4ZEQ4dmV0N3p2aEY1Mm9HUEVqbXdF?=
 =?utf-8?B?SkJSdGpIK2l5SEhUM1A0NmhXR0dLZXhOaytOdGZHVEtYaSs3b09pOWIyaCtG?=
 =?utf-8?B?eEVWMGRTcWhINjNKeEVrUFBGaDVjYjNxZStlS0xSTDBkWG14aEJ4Q3JkcDRT?=
 =?utf-8?B?RThIaklzM21oc1ZpZDA5RTNmZ0tzOHBOeVI5U1NXY2ExRjR5c05iV0IxaVJi?=
 =?utf-8?B?US8vc3QyMmNFaHFFbFJic3lyaW1BejBwem81eFBNdXN3bGxJbE4wc0Vvc0NX?=
 =?utf-8?B?QUVlMUtEOWMyMmVJS1M3S24zRU1jbDR0VEZSdXhQKy96dkluVjdvNmVGbzc3?=
 =?utf-8?B?cDM4cmp2bjJ6ZTF5SUVRcEFUSm1VZEgrSHhLb0NtT09MVFZvOFFNbENJZnRw?=
 =?utf-8?B?bitaSjBVd3hoSk9uK2V1QUo1TlBZY0pDTDVPMkdpTzVlRDNLei9mbGt6MnVH?=
 =?utf-8?B?NUQ5a2VqRm02NG5Hcy80M1EwdXVZL2RYaytHd25VQmRsaWJrd3BOdWVOMmN5?=
 =?utf-8?B?YklDOVFPSTUzY1dOM0hCaklaUDFxelJJMjJadUZ6dDFPL2RoSHE2S29Lcnpm?=
 =?utf-8?B?bmFjTE5YTjFKbWRobnV6R2NZQ0Z0bTBHT09NN2FpRlBkaTJvUFZkdEpZa0ZV?=
 =?utf-8?B?K0I4VFZHOUNZVVlKblkwQU9ENjRsQlpPaTlXbEpDNC9hVHplWHI0ZUhCd0JO?=
 =?utf-8?B?bVp5dEpoT0JrVGtmUjJ6OElxaW4wS3o4N0tHbjBoeHVtQzNNWTMvbDhwdlcx?=
 =?utf-8?B?dDltM1hxSTVlZ0dvZC82MElHNTIzMTBZdmMyclBFSEVCbXlsRTNZdGFjWTlG?=
 =?utf-8?B?cUt2ZDV1SGlsWG9kbDNtQzZ2QXZDSW1la2VxZ0RWUFRueTR5YXE3VU1iY3FX?=
 =?utf-8?B?WFpyZ21lUHdEOUtJVmtMbFZsRktLbXBWS0s1SmdnVjAzS3pmNW5XNnNMMGxh?=
 =?utf-8?B?V3RSbitrTlRoRjliZllBTmlkZFVjRk9VWkxRWFZ5SFVaTkhsamt3R24xU1Nj?=
 =?utf-8?B?YW5kSzlXTTdqTVZlem9kYjQ2aFlWcHFtdzBFTWpXMGJhR1dSNjJOMUYycUFZ?=
 =?utf-8?B?MHVhclZKWFc5RWtQTzNGTHlpVElFM1VYenNDalhoRFhCbXR5cXZ1OEZGeXdW?=
 =?utf-8?B?RzFiblhQVWwzcVRsdXI4RFpNdjZUNStMNlErcXMwNzB3MlBrbWx6ZXZVWE9U?=
 =?utf-8?B?MVZ0SVFRNFEwa2U2L2JBcVZaK1haczJndGhEME5uZ2lGKzNuNnJxMnNPOUlq?=
 =?utf-8?B?amVZcmEvQWN3L3pTemV2MGlVdmt1VW1TWjhhZmZhZFpBVXVMVHI2b0hFenc3?=
 =?utf-8?B?K214VkxmcVU0ckFNTjBhZG01eFJGbXJEOXBYQWcyUDBsYUVWYVJ5dFVzV3h0?=
 =?utf-8?B?b1MzUlNpUEpmQmZsRGFOc1lwU3NpTGFwTjBzTUticTJEM3pySTV3UT09?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	WyjAMsK+iPt/e+La4M9gUdk0mPVIS19n1m4eMfwlw9gO/FBN/6HvomSda84FJLlPwQbrGZSFN+hnIWRDgQJWfALXjj/6W+miGUWMLUeEuPQtMnFsI9O0oRUihO91TXrbNrtNfSS1C3OtfQcdzQPqP7RbO0vSvJee5vnnGh3cFvh5xCH+PNnfxvgNiqkIY8pwLdCFESFzoDxW7F4AAeHFXgaQz5v84MIR/dz7UKwpYc3R2dsBtnK5U4934EKPYXjdrg2a8XbYxmNXwcaEGrencaXcLpQfX3PdRvvnw8HLwuVFC60eTwTiaPcqbHsixtHn+AmMJp/zE/NK3lqmdGHblwH5iYbNIRqxd6XCvQKMFy6pwKJhNvNGEEg61hoW/ph0s2oy5VwRCsYwbtA4EYTd5EyaLoRLSuULqUnsWIMlfWJNSSqVdDb7dBWPCf3C9jSfbVmzl/yHV+LmvTvwc0YJC05SnMzkNB5EcAmkbvOyC6yIh7Y4/XGuBPjmMCIUvME9aJBehZuoAg1AWrD9nxq48BR+HhX6yPEucC42/nxuuUDPdVaSnD3GXCbRNVhFw1dULQGb/8xrYwWrDg5h2KDCuC2L4G4/Pr/UNMqA6xSA/I8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9af11b4a-3316-4747-af7e-08de555438ad
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB7129.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2026 23:08:55.1771
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qPHMO4xyfyb5+gbTn+ZFGTIBmLGjHYdiJIztfNT3nkMqLyuuz1miXW5AKX/0t+rAUyAvmHux5npltYKvmjhs7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7388
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-16_08,2026-01-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 phishscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2601160173
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE2MDE3MyBTYWx0ZWRfX3GaHWOEdMrhb
 baFSCsyOU+BB2InT0PdyvMlnBCiOGBdh7mCLZV9QTGh81wH7VsBeY214XmQscUIdCrWfL9jFIC/
 eWGkTJMxdlwfF/VHXHYlhgqu4Y5Y4idD+43l2xFyFBazlZt0VzgcpxoCdg94wlApThYF3/FisTS
 Cz3/X3wxG4cLcFRT3RhqPn2Rbc+qSr+e3v8xh704DiWNp8AQx6w5E4f1KXcNnpgDEwawiEFFJut
 wVQSp3TeQtw/SR2kJ6R9w6M9eQRBN61/ddVetul9V+etMJD0sIWZELJqtqKoQ6HLop3ZdqNjDsO
 NTtjjKANvFWSW8CpZ7KmKrO4udUPFoqCNKeUScM1aSrkdHDFGMRsTiEU71vHpbYzLO6PtbnPppd
 fiZ7Z8hHRCFdf6inXnlv/aZEhFSWwDXpatsbnPZQzsyv1gpW9tHmiXal/LfaDWZM30hwIjATdja
 r71xm4jDl8pbOKdndPnubLEnMlOYkMJGoT1jFUdM=
X-Authority-Analysis: v=2.4 cv=TOJIilla c=1 sm=1 tr=0 ts=696ac50b b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=uSRsRj3XGYQBFlY6ohkA:9 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:12109
X-Proofpoint-ORIG-GUID: WyjSNybLXSttaxNimvuyL_a9UHhu_eRl
X-Proofpoint-GUID: WyjSNybLXSttaxNimvuyL_a9UHhu_eRl

Hi Zhao, Sandipan and Dapeng,

FYI: I have removed your Reviewed-by since the previous version.

I have removed the following code since the previous version as suggested by Zide.

+    /*
+     * The PMU virtualization is disabled by kvm.enable_pmu=N.
+     */
+    if (kvm_pmu_disabled) {
+        return;
+    }

Thank you very much!

Dongli Zhang

On 1/8/26 11:53 PM, Dongli Zhang wrote:
> QEMU uses the kvm_get_msrs() function to save Intel PMU registers from KVM
> and kvm_put_msrs() to restore them to KVM. However, there is no support for
> AMD PMU registers. Currently, pmu_version and num_pmu_gp_counters are
> initialized based on cpuid(0xa), which does not apply to AMD processors.
> For AMD CPUs, prior to PerfMonV2, the number of general-purpose registers
> is determined based on the CPU version.
> 
> To address this issue, we need to add support for AMD PMU registers.
> Without this support, the following problems can arise:
> 
> 1. If the VM is reset (e.g., via QEMU system_reset or VM kdump/kexec) while
> running "perf top", the PMU registers are not disabled properly.
> 
> 2. Despite x86_cpu_reset() resetting many registers to zero, kvm_put_msrs()
> does not handle AMD PMU registers, causing some PMU events to remain
> enabled in KVM.
> 
> 3. The KVM kvm_pmc_speculative_in_use() function consistently returns true,
> preventing the reclamation of these events. Consequently, the
> kvm_pmc->perf_event remains active.
> 
> 4. After a reboot, the VM kernel may report the following error:
> 
> [    0.092011] Performance Events: Fam17h+ core perfctr, Broken BIOS detected, complain to your hardware vendor.
> [    0.092023] [Firmware Bug]: the BIOS has corrupted hw-PMU resources (MSR c0010200 is 530076)
> 
> 5. In the worst case, the active kvm_pmc->perf_event may inject unknown
> NMIs randomly into the VM kernel:
> 
> [...] Uhhuh. NMI received for unknown reason 30 on CPU 0.
> 
> To resolve these issues, we propose resetting AMD PMU registers during the
> VM reset process.
> 
> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
> ---
> Changed since v1:
>   - Modify "MSR_K7_EVNTSEL0 + 3" and "MSR_K7_PERFCTR0 + 3" by using
>     AMD64_NUM_COUNTERS (suggested by Sandipan Das).
>   - Use "AMD64_NUM_COUNTERS_CORE * 2 - 1", not "MSR_F15H_PERF_CTL0 + 0xb".
>     (suggested by Sandipan Das).
>   - Switch back to "-pmu" instead of using a global "pmu-cap-disabled".
>   - Don't initialize PMU info if kvm.enable_pmu=N.
> Changed since v2:
>   - Remove 'static' from host_cpuid_vendorX.
>   - Change has_pmu_version to pmu_version.
>   - Use object_property_get_int() to get CPU family.
>   - Use cpuid_find_entry() instead of cpu_x86_cpuid().
>   - Send error log when host and guest are from different vendors.
>   - Move "if (!cpu->enable_pmu)" to begin of function. Add comments to
>     reminder developers.
>   - Add support to Zhaoxin. Change is_same_vendor() to
>     is_host_compat_vendor().
>   - Didn't add Reviewed-by from Sandipan because the change isn't minor.
> Changed since v3:
>   - Use host_cpu_vendor_fms() from Zhao's patch.
>   - Check AMD directly makes the "compat" rule clear.
>   - Add comment to MAX_GP_COUNTERS.
>   - Skip PMU info initialization if !kvm_pmu_disabled.
> Changed since v4:
>   - Add Reviewed-by from Zhao and Sandipan.
> Changed since v6:
>   - Add Reviewed-by from Dapeng Mi.
> Changed since v8:
>   - Remove the usage of 'kvm_pmu_disabled' as sussged by Zide Chen.
>   - Remove Reviewed-by from Zhao Liu, Sandipan Das and Dapeng Mi, as the
>     usage of 'kvm_pmu_disabled' is removed.
> 
>  target/i386/cpu.h     |  12 +++
>  target/i386/kvm/kvm.c | 168 +++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 176 insertions(+), 4 deletions(-)
> 
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index 2bbc977d90..0960b98960 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -506,6 +506,14 @@ typedef enum X86Seg {
>  #define MSR_CORE_PERF_GLOBAL_CTRL       0x38f
>  #define MSR_CORE_PERF_GLOBAL_OVF_CTRL   0x390
>  
> +#define MSR_K7_EVNTSEL0                 0xc0010000
> +#define MSR_K7_PERFCTR0                 0xc0010004
> +#define MSR_F15H_PERF_CTL0              0xc0010200
> +#define MSR_F15H_PERF_CTR0              0xc0010201
> +
> +#define AMD64_NUM_COUNTERS              4
> +#define AMD64_NUM_COUNTERS_CORE         6
> +
>  #define MSR_MC0_CTL                     0x400
>  #define MSR_MC0_STATUS                  0x401
>  #define MSR_MC0_ADDR                    0x402
> @@ -1737,6 +1745,10 @@ typedef struct {
>  #endif
>  
>  #define MAX_FIXED_COUNTERS 3
> +/*
> + * This formula is based on Intel's MSR. The current size also meets AMD's
> + * needs.
> + */
>  #define MAX_GP_COUNTERS    (MSR_IA32_PERF_STATUS - MSR_P6_EVNTSEL0)
>  
>  #define NB_OPMASK_REGS 8
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index 3b803c662d..fb7b672a9d 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -2096,7 +2096,7 @@ int kvm_arch_pre_create_vcpu(CPUState *cpu, Error **errp)
>      return 0;
>  }
>  
> -static void kvm_init_pmu_info(struct kvm_cpuid2 *cpuid)
> +static void kvm_init_pmu_info_intel(struct kvm_cpuid2 *cpuid)
>  {
>      struct kvm_cpuid_entry2 *c;
>  
> @@ -2129,6 +2129,89 @@ static void kvm_init_pmu_info(struct kvm_cpuid2 *cpuid)
>      }
>  }
>  
> +static void kvm_init_pmu_info_amd(struct kvm_cpuid2 *cpuid, X86CPU *cpu)
> +{
> +    struct kvm_cpuid_entry2 *c;
> +    int64_t family;
> +
> +    family = object_property_get_int(OBJECT(cpu), "family", NULL);
> +    if (family < 0) {
> +        return;
> +    }
> +
> +    if (family < 6) {
> +        error_report("AMD performance-monitoring is supported from "
> +                     "K7 and later");
> +        return;
> +    }
> +
> +    pmu_version = 1;
> +    num_pmu_gp_counters = AMD64_NUM_COUNTERS;
> +
> +    c = cpuid_find_entry(cpuid, 0x80000001, 0);
> +    if (!c) {
> +        return;
> +    }
> +
> +    if (!(c->ecx & CPUID_EXT3_PERFCORE)) {
> +        return;
> +    }
> +
> +    num_pmu_gp_counters = AMD64_NUM_COUNTERS_CORE;
> +}
> +
> +static bool is_host_compat_vendor(CPUX86State *env)
> +{
> +    char host_vendor[CPUID_VENDOR_SZ + 1];
> +
> +    host_cpu_vendor_fms(host_vendor, NULL, NULL, NULL);
> +
> +    /*
> +     * Intel and Zhaoxin are compatible.
> +     */
> +    if ((g_str_equal(host_vendor, CPUID_VENDOR_INTEL) ||
> +         g_str_equal(host_vendor, CPUID_VENDOR_ZHAOXIN1) ||
> +         g_str_equal(host_vendor, CPUID_VENDOR_ZHAOXIN2)) &&
> +        (IS_INTEL_CPU(env) || IS_ZHAOXIN_CPU(env))) {
> +        return true;
> +    }
> +
> +    return g_str_equal(host_vendor, CPUID_VENDOR_AMD) &&
> +           IS_AMD_CPU(env);
> +}
> +
> +static void kvm_init_pmu_info(struct kvm_cpuid2 *cpuid, X86CPU *cpu)
> +{
> +    CPUX86State *env = &cpu->env;
> +
> +    /*
> +     * If KVM_CAP_PMU_CAPABILITY is not supported, there is no way to
> +     * disable the AMD PMU virtualization.
> +     *
> +     * Assume the user is aware of this when !cpu->enable_pmu. AMD PMU
> +     * registers are not going to reset, even they are still available to
> +     * guest VM.
> +     */
> +    if (!cpu->enable_pmu) {
> +        return;
> +    }
> +
> +    /*
> +     * It is not supported to virtualize AMD PMU registers on Intel
> +     * processors, nor to virtualize Intel PMU registers on AMD processors.
> +     */
> +    if (!is_host_compat_vendor(env)) {
> +        error_report("host doesn't support requested feature: vPMU");
> +        return;
> +    }
> +
> +    if (IS_INTEL_CPU(env) || IS_ZHAOXIN_CPU(env)) {
> +        kvm_init_pmu_info_intel(cpuid);
> +    } else if (IS_AMD_CPU(env)) {
> +        kvm_init_pmu_info_amd(cpuid, cpu);
> +    }
> +}
> +
>  int kvm_arch_init_vcpu(CPUState *cs)
>  {
>      struct {
> @@ -2319,7 +2402,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
>      cpuid_i = kvm_x86_build_cpuid(env, cpuid_data.entries, cpuid_i);
>      cpuid_data.cpuid.nent = cpuid_i;
>  
> -    kvm_init_pmu_info(&cpuid_data.cpuid);
> +    kvm_init_pmu_info(&cpuid_data.cpuid, cpu);
>  
>      if (x86_cpu_family(env->cpuid_version) >= 6
>          && (env->features[FEAT_1_EDX] & (CPUID_MCE | CPUID_MCA)) ==
> @@ -4094,7 +4177,7 @@ static int kvm_put_msrs(X86CPU *cpu, KvmPutState level)
>              kvm_msr_entry_add(cpu, MSR_KVM_POLL_CONTROL, env->poll_control_msr);
>          }
>  
> -        if (pmu_version > 0) {
> +        if ((IS_INTEL_CPU(env) || IS_ZHAOXIN_CPU(env)) && pmu_version > 0) {
>              if (pmu_version > 1) {
>                  /* Stop the counter.  */
>                  kvm_msr_entry_add(cpu, MSR_CORE_PERF_FIXED_CTR_CTRL, 0);
> @@ -4125,6 +4208,38 @@ static int kvm_put_msrs(X86CPU *cpu, KvmPutState level)
>                                    env->msr_global_ctrl);
>              }
>          }
> +
> +        if (IS_AMD_CPU(env) && pmu_version > 0) {
> +            uint32_t sel_base = MSR_K7_EVNTSEL0;
> +            uint32_t ctr_base = MSR_K7_PERFCTR0;
> +            /*
> +             * The address of the next selector or counter register is
> +             * obtained by incrementing the address of the current selector
> +             * or counter register by one.
> +             */
> +            uint32_t step = 1;
> +
> +            /*
> +             * When PERFCORE is enabled, AMD PMU uses a separate set of
> +             * addresses for the selector and counter registers.
> +             * Additionally, the address of the next selector or counter
> +             * register is determined by incrementing the address of the
> +             * current register by two.
> +             */
> +            if (num_pmu_gp_counters == AMD64_NUM_COUNTERS_CORE) {
> +                sel_base = MSR_F15H_PERF_CTL0;
> +                ctr_base = MSR_F15H_PERF_CTR0;
> +                step = 2;
> +            }
> +
> +            for (i = 0; i < num_pmu_gp_counters; i++) {
> +                kvm_msr_entry_add(cpu, ctr_base + i * step,
> +                                  env->msr_gp_counters[i]);
> +                kvm_msr_entry_add(cpu, sel_base + i * step,
> +                                  env->msr_gp_evtsel[i]);
> +            }
> +        }
> +
>          /*
>           * Hyper-V partition-wide MSRs: to avoid clearing them on cpu hot-add,
>           * only sync them to KVM on the first cpu
> @@ -4629,7 +4744,8 @@ static int kvm_get_msrs(X86CPU *cpu)
>      if (env->features[FEAT_KVM] & CPUID_KVM_POLL_CONTROL) {
>          kvm_msr_entry_add(cpu, MSR_KVM_POLL_CONTROL, 1);
>      }
> -    if (pmu_version > 0) {
> +
> +    if ((IS_INTEL_CPU(env) || IS_ZHAOXIN_CPU(env)) && pmu_version > 0) {
>          if (pmu_version > 1) {
>              kvm_msr_entry_add(cpu, MSR_CORE_PERF_FIXED_CTR_CTRL, 0);
>              kvm_msr_entry_add(cpu, MSR_CORE_PERF_GLOBAL_CTRL, 0);
> @@ -4645,6 +4761,35 @@ static int kvm_get_msrs(X86CPU *cpu)
>          }
>      }
>  
> +    if (IS_AMD_CPU(env) && pmu_version > 0) {
> +        uint32_t sel_base = MSR_K7_EVNTSEL0;
> +        uint32_t ctr_base = MSR_K7_PERFCTR0;
> +        /*
> +         * The address of the next selector or counter register is
> +         * obtained by incrementing the address of the current selector
> +         * or counter register by one.
> +         */
> +        uint32_t step = 1;
> +
> +        /*
> +         * When PERFCORE is enabled, AMD PMU uses a separate set of
> +         * addresses for the selector and counter registers.
> +         * Additionally, the address of the next selector or counter
> +         * register is determined by incrementing the address of the
> +         * current register by two.
> +         */
> +        if (num_pmu_gp_counters == AMD64_NUM_COUNTERS_CORE) {
> +            sel_base = MSR_F15H_PERF_CTL0;
> +            ctr_base = MSR_F15H_PERF_CTR0;
> +            step = 2;
> +        }
> +
> +        for (i = 0; i < num_pmu_gp_counters; i++) {
> +            kvm_msr_entry_add(cpu, ctr_base + i * step, 0);
> +            kvm_msr_entry_add(cpu, sel_base + i * step, 0);
> +        }
> +    }
> +
>      if (env->mcg_cap) {
>          kvm_msr_entry_add(cpu, MSR_MCG_STATUS, 0);
>          kvm_msr_entry_add(cpu, MSR_MCG_CTL, 0);
> @@ -4975,6 +5120,21 @@ static int kvm_get_msrs(X86CPU *cpu)
>          case MSR_P6_EVNTSEL0 ... MSR_P6_EVNTSEL0 + MAX_GP_COUNTERS - 1:
>              env->msr_gp_evtsel[index - MSR_P6_EVNTSEL0] = msrs[i].data;
>              break;
> +        case MSR_K7_EVNTSEL0 ... MSR_K7_EVNTSEL0 + AMD64_NUM_COUNTERS - 1:
> +            env->msr_gp_evtsel[index - MSR_K7_EVNTSEL0] = msrs[i].data;
> +            break;
> +        case MSR_K7_PERFCTR0 ... MSR_K7_PERFCTR0 + AMD64_NUM_COUNTERS - 1:
> +            env->msr_gp_counters[index - MSR_K7_PERFCTR0] = msrs[i].data;
> +            break;
> +        case MSR_F15H_PERF_CTL0 ...
> +             MSR_F15H_PERF_CTL0 + AMD64_NUM_COUNTERS_CORE * 2 - 1:
> +            index = index - MSR_F15H_PERF_CTL0;
> +            if (index & 0x1) {
> +                env->msr_gp_counters[index] = msrs[i].data;
> +            } else {
> +                env->msr_gp_evtsel[index] = msrs[i].data;
> +            }
> +            break;
>          case HV_X64_MSR_HYPERCALL:
>              env->msr_hv_hypercall = msrs[i].data;
>              break;


