Return-Path: <kvm+bounces-17970-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DF08A8CC4AD
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 18:10:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6C1A31F233CA
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 16:10:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4946F13DDB0;
	Wed, 22 May 2024 16:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FpOJKYc8";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="zFTp+i0x"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8A9B20DF4;
	Wed, 22 May 2024 16:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716394239; cv=fail; b=ZZoxb0aVUHdMDtFLlOXETWrxKc8PwIb6HEFGt2vBd+muf6MXWTsMY9Z90Nuu78OpVUy4o4HVILHldkAuBlDLBrfgiGpUtk4TJzXbq1DDS22VUCj4cYjHkXdr9hnVseJM1RI0oTNSPekbqhetn5U2AiL1GSwqL+ujWvaR5qLd08M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716394239; c=relaxed/simple;
	bh=qXjoAOPwh54I+hGu834fp4ZXRWu/gKP9/4ZzEN63040=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=JsPWn9jzgtrvW4oLZ6s24toMNKJsmZ+L6CqaIsH5ptEevpNmn2gekJMSx8QlLbqxa9da5rRAzdsdAd3lDMwHOeO0TkOwuoVFup+fq+vvvhQ9PiZWgsu+vDe1Ph5BeSDhen1QfcqU1LF+wM+zOoGPg3Khomi3XSs2F9tbs7koIS8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=FpOJKYc8; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=zFTp+i0x; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44MEnxE5019056;
	Wed, 22 May 2024 16:09:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=leGMrjFQFhZi2UeryAlxCPIf36I7arJ1Bvp+OIv0hKQ=;
 b=FpOJKYc8YleglvJ9ZHwu7KVsVoTScyyBejJdWmIYAjQ5zM83jx0qRdZf1E1rc38rGPhe
 qgmF9HoWJ9wJGSPbsBgVNZ//DU1ZR8BtKQf0eepxo9LVnf+S9ZwwHYppk7xoHyhTSxcH
 wvc8z1MA1PdDY8Qd2LHjUCHkb0zZXqKI8VnuMSV4AnQ04SoFaM2/C+RSv/A98Z9lupQy
 W3bog+uQo8CPntsAuzXeo/OdANIsFO/f4cXaBkx5IZ8PyngLo4hZI1GCFtg8GIOGGk/X
 WmKTyGYgOZ+u8inaevyvHToXuwHiEB8GEhjp7hbc3w3hkmnw+3PkMzWVtCeBWmaHkTxq OA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3y6k8d83sv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 May 2024 16:09:45 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44MEtktc019507;
	Wed, 22 May 2024 16:09:33 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3y6js9esw1-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 May 2024 16:09:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SObeb0DswY9syYUUIc4GfWlK0YDgAfX+hKgmNOlFslWUBKazHzXRDKK2eTv7BtcWN+vlt8i+vhf57kJtYolph7zhUst2r2pSIP+h5EaLV9bWl9LxsLIjKRFSQcdL4IADwcizFex5AVEQk+FQm0U++awKbgchWCZE6lkYayF5DxRVS85iLbmonCnLenU7NCKrhawcwvZ8U+3EqX6PhUiNKxi6BdCjQBno00evLIQOLPO/j9JlH5ni6f0wocX/SkbYqXEDflQC0ueFVJgX7Y9qDWZ987AnCKaIGQLtKuKY+YP7gIjL4ycU/3mR/VKtVA2uMerZUA5Prnm/WUIb4mAsLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=leGMrjFQFhZi2UeryAlxCPIf36I7arJ1Bvp+OIv0hKQ=;
 b=CS+c2u4VsouwMFTbELc24+N2dHm60yYbqe5Gcw2BV6Mrt8SIyVfFkkrRJd7ytTGVNA1923RFWKY5mYRrmeoiU8/F4L2XxHTnNKVjReYia0jELvGB/nijdkEqyN7xZhlCDc8b9uOd8xEYhLXTPoA0XcMvvfvXMED08z5S2zuGiAiqf+fbFyuBv7+RU1smHV6UAFUqSfn57GWiHK20ohDXvRY0Uk6k3tBJbxssXtL3mNFaNlxS9FrAO1EIRmEVCl0cPQ+e9toc0A7yqtnoMrV4/4w8l1aeX7Pfc7lwiaipHvKi3ec1XhZOMX6r2Vf+IGdGtkvatcbJ0EoycrPgwtc+pA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=leGMrjFQFhZi2UeryAlxCPIf36I7arJ1Bvp+OIv0hKQ=;
 b=zFTp+i0xC0NtgqfrHj4aOZW1A7z2Zf1FvQhMngZiFjwwUd4M1MkASOQQFcev+uJ4BJ/CEdttjGhbab9q7T0XdGhBNB+zy46Q4fyTji1S+CPsXgF9Koecc+rrGSxjqnDUSSJW5utJkwtaXJnJ0jHpeKINEqk8Px/3i/6XbjM3K/Q=
Received: from PH0PR10MB5893.namprd10.prod.outlook.com (2603:10b6:510:149::11)
 by IA1PR10MB7357.namprd10.prod.outlook.com (2603:10b6:208:3ff::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.35; Wed, 22 May
 2024 16:09:30 +0000
Received: from PH0PR10MB5893.namprd10.prod.outlook.com
 ([fe80::79f1:d24f:94ea:2b53]) by PH0PR10MB5893.namprd10.prod.outlook.com
 ([fe80::79f1:d24f:94ea:2b53%4]) with mapi id 15.20.7611.016; Wed, 22 May 2024
 16:09:30 +0000
Message-ID: <3f72519e-bf82-458f-a066-0c296a7d655f@oracle.com>
Date: Wed, 22 May 2024 17:09:20 +0100
Subject: Re: [PATCH 4/9] cpuidle-haltpoll: define arch_haltpoll_supported()
To: Ankur Arora <ankur.a.arora@oracle.com>
Cc: catalin.marinas@arm.com, will@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        pbonzini@redhat.com, wanpengli@tencent.com, vkuznets@redhat.com,
        rafael@kernel.org, daniel.lezcano@linaro.org, peterz@infradead.org,
        arnd@arndb.de, lenb@kernel.org, mark.rutland@arm.com,
        harisokn@amazon.com, boris.ostrovsky@oracle.com,
        konrad.wilk@oracle.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
References: <20240430183730.561960-1-ankur.a.arora@oracle.com>
 <20240430183730.561960-5-ankur.a.arora@oracle.com>
Content-Language: en-US
From: Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20240430183730.561960-5-ankur.a.arora@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4P192CA0023.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e1::9) To PH0PR10MB5893.namprd10.prod.outlook.com
 (2603:10b6:510:149::11)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5893:EE_|IA1PR10MB7357:EE_
X-MS-Office365-Filtering-Correlation-Id: e3e83bc6-5280-4202-703e-08dc7a798f70
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|7416005|1800799015|376005|366007;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?SjN3Q3VuUGNua1pvZmVuTkowQmRRTERyaFMrMU4xOWovbzVpbGlMQXRsNUdz?=
 =?utf-8?B?QkN4UzZ0TDJyamlKbUhaZklqS3p4WGFGUXBwZGoxMzI3L2RDdG1TUk5xOGRV?=
 =?utf-8?B?TG5semYyYlgzMGRnZFRSa1ZlL2liNjhPclk3SFZ3RU1sQUdoS0p3UVVYMTNG?=
 =?utf-8?B?cEhabkxNaXFXYzhMOVJHc3BWUTEyUW1URXdYY092UFd0MmllZjBHeDkyT3NV?=
 =?utf-8?B?YUtKSksxRU9rbG5GQ2huQWFQTHk4bFo4Q0dGTGVjdExyTys5QlkyQU9xMWNz?=
 =?utf-8?B?L2FHZHRYQnFwZCtLOEkydXBEd1I1K2p1ejJ5NWoxVUpJbjdzbVlXVUsrY3Q2?=
 =?utf-8?B?dkxXWmU1ZFFGSjNqYjBtdkpmNkZNMC9yUmNHUndQd3g2RkpLWU52elZjdVBC?=
 =?utf-8?B?MFlKT2VLb3dtazkwYkJnU3p0NE11Z2VnK0E3ZkpZU2R3cjhFUlhzS1lZcDBK?=
 =?utf-8?B?SUNqTk1kYWlIN3lQTjhNU2xlT3VEdVp3NThaUHdxMEFWZkhSeHJzcnFJSlgz?=
 =?utf-8?B?UWg5aHUwTEVQRE5LOUttUElNaGFNelREK1YrTllkdStLNjZMMk9BSysxZzZC?=
 =?utf-8?B?cXE3MTZLaUszMkl4SXhURHFKNndiYjZFRGMzY0M4Zi9GOUJvcTI4UlYxc0hV?=
 =?utf-8?B?YnpPejdFTDZiRjFtQjJkM3E5MEF3bFFKMlZSYWhPWFpmbHZZTS9neXc2Rjk0?=
 =?utf-8?B?aHZhcUlWUlhNZ2NxRkZHM1ZYN2t3MmVOTEJGSFBaSEpaa1FVVmhtYTh5MElk?=
 =?utf-8?B?di9zc1ZlRU1oVUpmVGtHckY1NGJVb1Nna1BzQ1IraTFMZjVZQmkzbmtVbnR5?=
 =?utf-8?B?SU9OVXJvbTBLamV4L2IzN2NFck0yMHd1R0Uzc1h4SFppTVdXcFo4R0xhUnMr?=
 =?utf-8?B?dzBzYTNPZDVCNVZXTVR0TVI5M2w5ZGs4OVRTdnpxRTNGVjhQKzFKUGxQNkVX?=
 =?utf-8?B?VG9SRmVsTW03OW5kdk1mRk1KYktjYy9qdFh2QVVIMlZrM2JlalVBSVo2OXFM?=
 =?utf-8?B?OGpKTk5RU1lzeDJQUDlqazFhN3g0ZUhydjVIMEErbkZ4RVV1ZTQzRm91ZG5C?=
 =?utf-8?B?WExoMHVUNVpGZGZsRHJyUm91N0ZTakJWdGxSTDY3SGJ1d3I3SkFQbGU0UVBz?=
 =?utf-8?B?UXJScWZVSGFWc0k4V2x4M3ZBaW5FREkyM05KY05VU3MxSHh1S3FuQWNzd1ZK?=
 =?utf-8?B?THZzYnljakVMclFVc3NKZEFxV1IzOEtDUU9QUnRwSHdSSThNS3BkYmttVFJZ?=
 =?utf-8?B?WXgycjBIUmVQbU9hRTE0aDl4TDlxR21GMnFybWE4UkRGUlRqbklGVHJkNjA3?=
 =?utf-8?B?ZkY4aTlmbW5iNlRjRlpWYzVteEhYZG0vZWhkbmV1U2tFdWovVVVYMElvbmth?=
 =?utf-8?B?VjVDd1IveXhEYTFtTEdOWFRmOVdjbndPTjQrSG5pWDJnYjRsZ3NCOXNLbUho?=
 =?utf-8?B?aDZ5VlVEOHlXNEYrUzlWUDRubWcrNVJtTythd2NVaHpKbmd4ZXU5MVk2REw3?=
 =?utf-8?B?SVdqRWNUamlzais1LzdoUHpDVDNKVHgrNG1TOEYyRm13VFVNSmxXTDdSYnVS?=
 =?utf-8?B?ZjRUci93N0RFaEk3ZWx0ejJQdm93azRLc3JMazRSTHllWnVYTHorM3JFMThW?=
 =?utf-8?B?VHJ0dE5xK1U1MmFQL1NhTGhRR1QwQStxL1ZlY3BHaXNvK0cyRkNnVGN4S1Mw?=
 =?utf-8?B?UE5QUVRuM3VsaWE3M0RVYnlRV2RwWFhwZitwS3dlN0V6ODVxaFJ2cENRPT0=?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5893.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?TVpuS2JRdDNrc0ZJbHZJMGE3NGIrS2dRaWM2R0ZyMzZKSnMzbjlVamZiZUlI?=
 =?utf-8?B?aUJpVlpJY1l0b05IdngxY3hQNVl5cVU0Nmx5SFpiQ3UwMEJmY1BrQXZpbmtx?=
 =?utf-8?B?VkN1L2RDR3I0eUQvbEh2aTlZQWhzbDZSRWVhWENQUXN5elRKZU1LcnRxR0My?=
 =?utf-8?B?ZG9XeHppK2ZoN3dYOWNTbnhCSm1RaCtocmZIem9QNm8wTEFoU3k0bFRGRjR5?=
 =?utf-8?B?bFdvV2QzM1k4Q1k2dGFGUlFzWjJydVZoaVVMVExyMHpTaHcwT0J1SW1uUnZ5?=
 =?utf-8?B?aWdJck91Nys4RkdEMWVZeE5oZGEwODhFOGZOMGlVSENaaW9RTHlWUmgveXF6?=
 =?utf-8?B?RURVaDdVMmR5ckxiZk5KZ1ZtQnJSeld6SGY4TlM5WFlwV3F2N0tRTFhmODd4?=
 =?utf-8?B?UVF1bDRJVDJ4TkoweWM4UGdJOWRxS0c0WTV3c1lzdFNUYm1nNnZ3eEQrVWRv?=
 =?utf-8?B?YkV2V1hKS0p3eElxUmFiMEY3c3RON1F1OFNFNmI4aTVBZlJvc250NmJ0eG05?=
 =?utf-8?B?bVBDczd1U2hvTGVQc3hZVUtiMTJobmp6WEhyZ1lGZzdWS1B0aW1OdytZZWJJ?=
 =?utf-8?B?aXpFVHhiTXdZYms2alpNbEEzRjZjMTVqM0xVdE1LbDc2U1JCdDJmRlRWa3RX?=
 =?utf-8?B?bk95OHdXZ2lseFZxY29tNFYrd08rR3BhM3N4ZU54aWdOSk1BZVlpakR3NXVN?=
 =?utf-8?B?Q0dOQkt5VXpMbHRVd1BiUnpKZ0FKaHlnQ1c4dHAxZW5LdFUwUVQwb3ovT0Mz?=
 =?utf-8?B?OEJnZGFsRkFMTktGczlrMDVkS3NnUEZpRG5yNHBoTHRUWTh3dWNzN1l1cktJ?=
 =?utf-8?B?eVVWdGh3RFU3aVZ0M3NSenNWbzJQTmJOVHhtMkQ1bzYyU2JJYlhJL1lhK2J0?=
 =?utf-8?B?OU9EWUZoRkRVQWVUN2JhWkl3emlocGxzck1LejVTMlNHSlEycE5FS0xSM3FR?=
 =?utf-8?B?K2NiMDRydE9yWmV4Q2NjMjZWY1NFYTV4VFBkTWxQNHFuSEhELzk0U1dvNVJi?=
 =?utf-8?B?bEQzYVZlZG03VDMzR2FvY1BmazJzNE9KUEpMbDAxbFFUZFZFdkdDWjVWMWg2?=
 =?utf-8?B?aVNDdkQvbEoyc3BETjBkN3l0NHNFZzhsb1lmRWsrdkp3SU5KZWVMeTVYRHA1?=
 =?utf-8?B?NlVpZnEwYWZQdk5vS3htV24yZWFSZ053anN1bDlzOEpKMEtzdE9Ucmh4ekZ2?=
 =?utf-8?B?VGUxeXpZRnJzbXg1S24vZ250UnJJeUxSb1dMN2FKWTZBVmUrOGEvVXRBbUJB?=
 =?utf-8?B?NEZZREJPSTZlZk5IODM0YjUreWhpbUJKWTlkNmJoU25qV2dQejNRZFBGcnJ2?=
 =?utf-8?B?UUFubFhYeE1wTXhyTXV6UlBYMVFvckNxSUJNOVYxdGg4WjZUeXVXZ0Y0dTd5?=
 =?utf-8?B?WWRDM0g5aUJHMVp1VlppR3Y5SThtaWdkRThPQzVDU2NtdVk3NXJNaVBPVUsy?=
 =?utf-8?B?RzMyZVdhcGRhSEdzZ0FBektMbW9NY2RMYVdOcGEvaEo4Rkg4dHVtOVA2aHZp?=
 =?utf-8?B?Yjh1NGpIMm9ldWhDdUlNV2FnMk5TcVFaMVB3ZnZ5cWJ2emFyN0FQVW03NTVy?=
 =?utf-8?B?bEpFVGtJWmtiaTluNVpiTktuVTVtWWNyOWQ3Z01vdDVPKzZBUHpveHhyTGZH?=
 =?utf-8?B?RFRFT2dyRXVZby9BNGpCank5cS9VYXdObitsc0lwckx6V2twdnh1aHhGZm0w?=
 =?utf-8?B?d0xXZ0ZuUEYyU0E2MklHTjhzSC9tUjBXYm1JREZRS21JQTRTQXQ2VmpsbHZl?=
 =?utf-8?B?ZmxnY3NIUE1nQjNzNVZRV1M0bE9ZaC8xQlFzUFhtWGpERVZ2d3hDT0drOVpT?=
 =?utf-8?B?K0ZlOHd2ME5iTmR3dTRGbTUwczFHQkVVaU83T051TWdnMU1xSUF2TG1tenhZ?=
 =?utf-8?B?ZzZMaWRvbmxlWVo3citwTXkxYi8wV3dEbjBHckx3RG9nbmdseS9HdmYyMnN1?=
 =?utf-8?B?b1diS0dMci95Z3VqdURHSXlMVEl4VTRhdlE1Q2hGUElwbWttbmIzeTY1bGFr?=
 =?utf-8?B?U3ZGUzNiMEdzUUwyWDh2OVRFYlFyS3BvTU5jMkdiSlo0VlE1RlFBcXJwdURj?=
 =?utf-8?B?RnFSSkYrYU5RUkRiYSszSGJ6TnVUbGhXdzU1UnNHZHRhekxOZFBWMklyNkxu?=
 =?utf-8?B?VkVjQ1JxcUVwWWtxcVRkUjZiUnBPYzUrcUdnaTRVbXR3OXhTWk5tZHN2Q0FY?=
 =?utf-8?B?d2c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	5kwBDkwEgaIeu0yD17GmY27cAX45im1faJjrJwk4aomS9Tyg2NYCW73LbDqJDRXsTP2hGU/JTAABGUvJcUaiqQZTUpjXhcsVLu2GyOZiCTY/x9bQtLvI3ZXm7Q5vX3+YEsDjc9HNAZpG8QvZdStUvHVsS2BvbJOhxsUzYQWA4Pa6VyTygmwdcHDSuoQE798bkVJBfId4mbBm2sdicU2HR+rcpLJSYbVSIfsWCoswpQD9E9mZc2WOzC5nYiDOKiQeba2mbs4o0v90xy1rB7iA4Ogu7RQ8OWh8zf0uAOrkGhlM4CUU41a9PlnP+JP0/Ra7eBrJtrpJhkuwcsrWaPmQhQ1j+w6mSdJN8qtUycMt3GCTpR6ymeZ7JGMsP0YFnvhwZpV1/ZxhIe53fGyGAjVylkd+qvlzGbPYj3U/gGnRjcM8IGU+NfO8EtNXHwk7XHbjM8CaS/Np4ReEZJWD+rmNMrbldC6HgEWqZwgf57PCdz8GvEWAp2XhWAqWSfjbedPV3GB4SjFSFpvPJ4vCveLOMVcZaqEalbzRSsr1MAoKevlWoAgXo3LAlPAfB6JPitCkXFKCbhN87UYbHqp2DnghuRquBw44cmStNuEpdjj7bZQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3e83bc6-5280-4202-703e-08dc7a798f70
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5893.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2024 16:09:29.8549
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o1KVmT/fT1DXrY+PsYXvb31bQ7hojf1xtnuiAU4ZxOhY+uZaRda0UXqCFCj+AAdlxo2mpyKGryyI+oqLF4EK7+mC9APEDbTJMNga7qX3Jb0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7357
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-22_08,2024-05-22_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2405220110
X-Proofpoint-GUID: T1LtFMseGCqNIGRtjdFBg12D8stPD2G1
X-Proofpoint-ORIG-GUID: T1LtFMseGCqNIGRtjdFBg12D8stPD2G1

On 30/04/2024 19:37, Ankur Arora wrote:
> From: Joao Martins <joao.m.martins@oracle.com>
> 
> Right now kvm_para_has_hint(KVM_HINTS_REALTIME) is x86 only. In
> pursuit of making cpuidle-haltpoll architecture independent, define
> arch_haltpoll_supported() which handles the architectural check for
> enabling haltpoll.
> 
> Move the (kvm_para_available() && kvm_para_has_hint(KVM_HINTS_REALTIME))
> check to the x86 specific arch_haltpoll_supported().
> 
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> Signed-off-by: Mihai Carabas <mihai.carabas@oracle.com>
> Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
> 
> ---
> Changelog:
> 
>   - s/arch_haltpoll_want/arch_haltpoll_supported/


I am not sure it's correct to call supported() considering that it's supposed to
always supported (via WFE or cpu_relax()) and it's not exactly what it is doing.
The function you were changing is more about whether it's default enabled or
not. So I think the old name in v4 is more appropriate i.e. arch_haltpoll_want()

Alternatively you could have it called arch_haltpoll_default_enabled() though
it's longer/verbose.

Though if you want a true supported() arch helper *I think* you need to make a
bigger change into introducing arch_haltpoll_supported() separate from
arch_haltpoll_want() where the former would ignore the .force=y modparam and
never be able to load if a given feature wasn't present e.g. prevent arm64
haltpoll loading be conditioned to arch_timer_evtstrm_available() being present.
Though I don't think that you want this AIUI

	Joao

