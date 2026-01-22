Return-Path: <kvm+bounces-68851-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qBpgLbOwcWlmLQAAu9opvQ
	(envelope-from <kvm+bounces-68851-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 06:08:03 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D40F61E90
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 06:08:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id BBB08488AB0
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 05:03:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5B383C00A0;
	Thu, 22 Jan 2026 05:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dYO9/QpY";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Kaex/Pv3"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E2A6345724;
	Thu, 22 Jan 2026 05:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769058147; cv=fail; b=B+uywBEO6ZCX1s95nwzIVriRSo2qz5oSGB9oVgzUPYl2ORB88p17ZDkYriSP8Rt4nZAA9Lumu3jlIq40oWx0pwPExKUmQzLiPSFu7pgDtdwrFLV9qSBuG0D/bTi3F3m6Wv2ProCZPe61MHDIVZtnbG1Mo7bgIRJevjeo7pYWFd8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769058147; c=relaxed/simple;
	bh=SJIjQkK5/9PbGI6ShHFacLBupkft1zsrzoD66BqP5R4=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=S2w9lD81pKi/XsOsKi3QxRxVh1ut4Gf82S6Q2TpbFEYbSCYFiv/tJVfCIM+UVfp8eXVwk/QYHJAMAx9SuJ+gN4jIyfX3uoNRA/ZpzBKazjYHx84RL7k6E1HazljyBzuEQ9rz8EsB1eDvX/JZIGC7El3LGh+fVo3djFPETZs3Kbw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=dYO9/QpY; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Kaex/Pv3; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60M0lghT3264931;
	Thu, 22 Jan 2026 05:01:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=EIrVlkAZVyfhZdgwsPpg4LT1V5cx52N7jVWasPndPBU=; b=
	dYO9/QpYfJglWBMpV2cYSM5awZiEsESe1Wbv2u2w8+KrQoaUZITLUPadBk+bUOP8
	6/hytawxoC74hNJ88yhhjiEdQEkZOwOVvSPrehhEgEm1hOro7Pe/7c135SaCvzgW
	Lwa9h+wO2gEbVwnYe3eoMQPBdQJRnMREY3/Nz9JnXsgoJvhiN1oFX4tDfaOlGkL7
	QZEOL0mjEsQXrzY5DxPLCWMil/0eRrRq3VtRFP7sH19EZrCnoGa0mt8D2d0kJ1qH
	CXxsCT5dspbMp+5fuA8s3y/1uwAIqB8+SyaA1g6rOZsLvmRi8YjgJqJL0u2pCy27
	YXnzMQaDkDKevGz9Q54+zA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br1b8f6cr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Jan 2026 05:01:19 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60M4b64g008388;
	Thu, 22 Jan 2026 05:01:18 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010049.outbound.protection.outlook.com [52.101.46.49])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vcat3w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Jan 2026 05:01:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wjiGY+etBXhSgzREiSrVj6Q4z2lBMy3UuTStircL/da8vZzDFbZNDu8t9rD8Jg1MnW2BmBupQeetCvuTCRQxrJG208a2yPElYxH6jAFnfPjEDj45gKTXFdDkzxDeBXu0JviMcjMruLIwVSxAf0XLvl9XqQFEe40PgJGxuU8jp3+UDMQktV0DMtGiFFwkWHVQXF/C1gXvcs4OroGvXqxPYD0F2e6R117ig7xfGBt4uJQQUzB8iYRg4ZRUMy2xViJy9/Ps92VkiQKvpvcs2y+qcy3LL2155N8ByXvmJxO9/xw6zQgVmNdakbrbo1/Mv4yhBrKIjTLV93BVhFQUOvj+Pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EIrVlkAZVyfhZdgwsPpg4LT1V5cx52N7jVWasPndPBU=;
 b=PKhiXCZyX6Yl5m/Y4fivJjLuOR2Qe0XcvPLfEhQyKpMtQglVlhBBPfLPTyIONLE8g6QU/nLH0fqoYd7hP8DtthG7vQyIE8/AnxWDM+biTSv3dOFmcnrLSSzjH5r4l6zV8x/8rFe4q1oEazVhQOwTV1omthDVXo0/kk6As1sv2AYlKLhwzrB0fU3fPNsl0dxpKfjdfXcuCnKtDh108Qfo2KVCgNsrtghftJ8GXEXNUUvKqlSATlQXFZG4NRrT82lqi8LU5K92jYJfr5xJshrYv3LwPGl/7fgAGdMQ39tl+IfMpfIyGxtF+ZEB7AYdRSaFvwAqiaX9jRwFy6GZn5tAkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EIrVlkAZVyfhZdgwsPpg4LT1V5cx52N7jVWasPndPBU=;
 b=Kaex/Pv3U+SUU45eQWpZKaVzmF1CyvST2dEIRz/T+hMEJJX2oFJVNIbQEjVe9YJ+AskfhGiLtMGsVXfaEHqZTTzIoZ0FuZwzj06vwzgkwvK/neXF/nrDdCiHSTYnfbTkVNY7xB8XoKmkIYAJocaPfk9bq8zPmL7N1k/eLkBKNSY=
Received: from DS7PR10MB7129.namprd10.prod.outlook.com (2603:10b6:8:e6::5) by
 PH8PR10MB6340.namprd10.prod.outlook.com (2603:10b6:510:1cf::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9542.9; Thu, 22 Jan 2026 05:01:15 +0000
Received: from DS7PR10MB7129.namprd10.prod.outlook.com
 ([fe80::c649:a69f:8714:22e8]) by DS7PR10MB7129.namprd10.prod.outlook.com
 ([fe80::c649:a69f:8714:22e8%4]) with mapi id 15.20.9542.008; Thu, 22 Jan 2026
 05:01:14 +0000
Message-ID: <e1371007-b8a5-455e-a3a5-928c8e8ed8eb@oracle.com>
Date: Wed, 21 Jan 2026 21:01:10 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] KVM: x86: Mitigate kvm-clock drift caused by
 masterclock update
From: Dongli Zhang <dongli.zhang@oracle.com>
To: David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, paul@xen.org, tglx@kernel.org,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        joe.jin@oracle.com
References: <20260115202256.119820-1-dongli.zhang@oracle.com>
 <cea56100-9c43-4246-912b-234c6cfdc876@oracle.com>
 <285e30927dad5736df58aad5d957448e93b2d047.camel@infradead.org>
 <4ed7a646-707a-40c9-93f9-2289fedf5709@oracle.com>
Content-Language: en-US
In-Reply-To: <4ed7a646-707a-40c9-93f9-2289fedf5709@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL1PR13CA0150.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::35) To DS7PR10MB7129.namprd10.prod.outlook.com
 (2603:10b6:8:e6::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB7129:EE_|PH8PR10MB6340:EE_
X-MS-Office365-Filtering-Correlation-Id: deb8ea57-b2cb-42e8-8b98-08de597344ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|13003099007|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eFhaL3JkclVRWnBFeGU3RzFPcWdDMTZxN1BxRkN1cFhTNlQ1a0w3a2RXSlFC?=
 =?utf-8?B?Q2pIY2s3dGEvcEtqa1pSTzREZWQ2Nmh0Z3QwYUY4ZUF5bWllM3dlWmkzMlhx?=
 =?utf-8?B?aWFlc2RSQ1ZZWmtTT2F4d1JjcUpIcERRaFUwcFJmRW82YTVzYUNzZFZpSHRs?=
 =?utf-8?B?Rk15c2lCK1gvWGJHWVJRd3owM0VMT0NESEgra0t3VkJkR3d1VkxkMG1lZUVY?=
 =?utf-8?B?N0tBTWllb3BpWTNqMzRCcHhZUDVDZWZhbWZTSkgva1BPYnMvWUJ5RVFQQ2VM?=
 =?utf-8?B?UFFXVG1pUHJwUXdzcW85elV0RGhtSkMzQ3NtUTlkTW9JRU1hVkcyVGlyZHFN?=
 =?utf-8?B?Q3NQZkF6czFEWTNsMTUxcTNsMkswdXRnYWw5Y0VoZ2RsdVBLd2VnN2FrZDUy?=
 =?utf-8?B?Q29CWEtMTkxLNjFydDBFVkltOFhwL1ZiRFRvWXVMN1NHWlRMME9uSkw0K0FC?=
 =?utf-8?B?K3hhSVNMdFhYWW5nRUNCNnpxQlNRMTVDVWR1RzR2b0RaTERWVzk4aVhndmJI?=
 =?utf-8?B?MnNacVJlZ0d5K2JVamZURWtVelFySTdDS2FVdWt6NTBnK3dPcWVkMEtuVk5q?=
 =?utf-8?B?c0g5TnNNUjdxR3NTMS9zMWFkYVNTL0oyYWd5ZmVUbmFxSmF2SWF6S3MwVk9L?=
 =?utf-8?B?T2JTYm9Oc09KNmZGZ3JBT1RSSDFXcmc0WGlua1VrRUtPTTBNeU15RGd0U0ly?=
 =?utf-8?B?MUtHcWVsNm5WeWoxQlNDNTZUOGMvWTM5d1pDWFFLcEJzMHBVZzVtVkoyWWg4?=
 =?utf-8?B?a1BuQVV1QjNUei9BOXRxZHhyMjF4dG9uUzNmcHpZWUordHhSbUI3aTZ0cW0x?=
 =?utf-8?B?TVNlZGR0U2xnUFZZdkVvRy9rS09GbFYwRFlkbFI1UHY2ZndvM0pYMDh1b1h1?=
 =?utf-8?B?cGxkK1JxNjI2ZmNCOXordUl6d2VLLytjQzNJOVVVVHBDSEpWd2szWkdLcmtV?=
 =?utf-8?B?M2pSZzk1TkNpNWl0dlZjb3lHbEd0ZUFQL2hSR1A2bjl1a1hodUdBT2dLMk01?=
 =?utf-8?B?bUtlVkZqMnpNSkNQaXpqTmRuU2hySTdMV1ljNmxLU1paQW9HZ1BJNVJRYUFm?=
 =?utf-8?B?cGlxMDBWMjZpQ0NUc0E2RjZBTVRxekFnZkc0UnBYUmdqeGFTdi9XUXplalNR?=
 =?utf-8?B?MFB1elNtYUc5b1dlSjBuMGZjQXNhSlFCS2YxWkFzcUFmSXlxeEt2WER4YUsy?=
 =?utf-8?B?SERNc1BEN0d0b3lud2UveGVUVmM3KzExamdaRzFreGNXRmZLaUdQTCtydnRF?=
 =?utf-8?B?OVNEc0gzM0J3TE9ScFhlNWR0bnRBcCsvUHk0YnpFQ0I1TW9RZ05tbmdTMHUx?=
 =?utf-8?B?d29BbTZkYjJ5YTVWZnRyVEtGQzFiSzhGS0cxdXZQWCtEdUFzK0x3Y2NTalVo?=
 =?utf-8?B?bUs4TlMyWFh4WmJ5VERUSkJlb0IveHJCN2hhWDBXMTNhREs3NXpxUXNLN3VC?=
 =?utf-8?B?NmN0bmtPK2VRQ25mciszMFFyeCsxS1VibWxaWm4yU1ZYdnEvNGJENzNmZzFh?=
 =?utf-8?B?bGxhc09DN3RyT3dmUFhHTytZTWYwUzFVWHVEMHZucGY1bWZ5VGZoTVd0Wnln?=
 =?utf-8?B?YU8ySXViQUh6d1A4Q1MzdWxaZnNDV1oyeTFobWhSVC92NXVrT3RuWnYvOTdy?=
 =?utf-8?B?cmFEY0taRVM0bTRrNlBQRWk1Nm9NVFpUY3Q2aGk1aCtOZHljdFdHK2xFbDE5?=
 =?utf-8?B?dkFkOFFjTktya0RZeEp3bU5KYkJqNEFRa29nUXoyWUxaOE1XM1YvN0dSNzln?=
 =?utf-8?B?cHJMc1ZrNFgyV3hkYTFjS3ZWenVuVkV0WWpuV0JDcVhnV0l3WjhDRFVCM0FB?=
 =?utf-8?B?RExNMEF4L0lzSzZWQjl1ZUtpSG5FZmNINkVXM3lBem4zWEMrbXYwUmZES2pH?=
 =?utf-8?B?RUsrSmNCSm5lN0VNMElLazIweXdVd2tmaEZEazBkM3hYVk1KSUN0VWltNjRY?=
 =?utf-8?B?bWN6Z1VDbmtyWW03K1ExblFxQ0trc0k1TStnS2x6dUVCZDU3Q01FMXdhbGdn?=
 =?utf-8?B?NVBzWnpvcmVlNzNTMWVzNWJ1ZWlhalIwYjVrdm1TNnp5M0RZVzFoR2dNcDRs?=
 =?utf-8?B?OFhpbXpOVkZQVENXS3g0K2gvS2t6SVNuWGhlUlJpWXZmdDJHQkJ1VzZPUG50?=
 =?utf-8?Q?iSFAOAeq8/xUxppRfCREHhzyJ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB7129.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(13003099007)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SUliVVVLMjhGMlVOZGNWSWtqZVhXY1g2bzJETGhLbk9Xbkh0TkM5RUswdE9R?=
 =?utf-8?B?K3prV3dHamRNNGtZdU9lTE5DcWtmK3lGYkxtYk9qaEtrRzlPY2xRVVhXbFZW?=
 =?utf-8?B?dUZXV1FNY285SmpYVll4QjRObTNNMXdoWVJMZUJKWFh5cE1ZakN1czFiZ3Jo?=
 =?utf-8?B?cnVYaWNIN01wbkJNUDN1enBiTFRPQ1FieVVqRW9yRU52Z3FnWUwyR1ZadDk5?=
 =?utf-8?B?Nm5BUENSU2x2aHpJMEc0SmFPUTBBTkJyeWl0dXllajJJZzBlZTJqTDAwbUd1?=
 =?utf-8?B?enFCV3BjR1o3RnpoY3dZaEY1SnlaK3p5M25tdnNHYkhrb0RSQzRTcGRhRnNE?=
 =?utf-8?B?SlpJN0FKdzhHV0VyU0hRa05sSVJRem5qQkliZVFQOFJsZUtINDB3aU5udENw?=
 =?utf-8?B?eGJRREpCdElqMzdWbWpWMXJWd1dFVlVQRW9wb2lPU1BkSGxCdHlRcmJOWEhH?=
 =?utf-8?B?dUdFMTE0SkhTVjlZSTNWVEUzMndCTEdyOTJDSXFuOFI1WUdhN3p0WlZmQVhY?=
 =?utf-8?B?eENscU9IZ1NCK200ZFpYcXIvVkx3YW12NVo1dGRKWEFUUkh0VFNyMEpTVXVJ?=
 =?utf-8?B?bkY2c1gvU0VKcTZVOTBmTldXN3FIS2c3YU9GQkEwZEk0eEp4V3d3STJlY1pQ?=
 =?utf-8?B?dGhrQ3JFK3BxdTkrdDdNVWM0NjFQeUtLaUFzbGtrdk10clBvdlRERjBtNkZQ?=
 =?utf-8?B?QU5ONVRhbUpSeVk3WmFWM2ZIdzZtRkNzcFlKbG9NL1pqMGdtR0tiVDRKN25h?=
 =?utf-8?B?UGY2ZkNKNWtaSTd6ZWNZZjFOVHE0c3M5dERhWEFhZk5peFdvVlg1anRBTzdx?=
 =?utf-8?B?NXdIdGIrbXVXajVlejdlbjRaUHZaMWJidUZGczFpS1J1ZjU3Qmc0alYwaklx?=
 =?utf-8?B?OHVlUU1xMWlQMndSY1hFYzNzVTAwWDhWeXZFM2xneGhKby90VXQ5VU5zWUxl?=
 =?utf-8?B?SFMvc0VxRnVpRTlGUUIxeG5pZ3dZVGFMTkppTVVaM3MzTnAzdWJZNDd1YWpi?=
 =?utf-8?B?cVhBWGh2cUZwbFNhM29yZjVZdHBaRCsxOWZVNENkU3MxVWxBSVZRaEpKdS9Q?=
 =?utf-8?B?T1JYK1pKWWZqTXhYaWt5UVlqa1Y1RFdOM3p4R2RHRGgrMkN3dEs0Wk5LQUox?=
 =?utf-8?B?a2FJaEJYTWJUZC9uUFB6QUdlUG1EUURITU15LzNDRFNsZjFZckpxbWF1MDBy?=
 =?utf-8?B?b0xDaXlTTUwzWGlpVngrb29zUS91WkFOTjNTSVVJaDVyZzloaTR1TEk4RkZD?=
 =?utf-8?B?MEtUYnJqeGd1ZXlGWmF4OXFxQ1dqTkZOUnNxMmVJNjF2SEpzZGN4Y3oxMktn?=
 =?utf-8?B?ZTk5a0ZDRldrZWdVYVlIYUxTWDdKa1NacjZMWFJVK3JqYnlxaEhXTnJqcjdB?=
 =?utf-8?B?UThnTlNOY09NcVk1bVh4dWk3QTBrbTM2L1ZMdlBwWERqa0hERWZYU3dRWEVF?=
 =?utf-8?B?all5cU1JaWxKYzdnODRCNERHOHBFSGYyL3IvTEYvT0d2Q0dwNVEyZlhENE1O?=
 =?utf-8?B?M1NObEpMZWNiTCtKNkNySG8vcFdCRlBoLzJTSzdycU9raS9oaHlLZEthM1ZM?=
 =?utf-8?B?d0ZnOGFVY2JXaHd2YXBWOWQ1NjByTkNvemE4SDNvTm5ld1NyelFCTXB4a3Ex?=
 =?utf-8?B?a0FaOHF1cU1jbFhJbEVieVNVeForSzFjLzZiRHB1KzA1NFB5V2lXOU01QnE2?=
 =?utf-8?B?SU5HcEVQYWVjYmNlcFZQYUhGS2VPS3JuSU4zN0Q1aVdSbnhKOVB3N3l2enFP?=
 =?utf-8?B?NXA1RW9oMlBzNU9IcDhSQW9QUVJIZDJGODNwS1VhL09lcTlBVVBwZVNhdnBH?=
 =?utf-8?B?UHlMdDcyeW9wbXBvZTlLRU9XblJNbjZ3TWxRd29Fei95SmhNRnFIeE10L0pE?=
 =?utf-8?B?Yk5RdTZYbDZicUc0eEgrd3QwNW8wQXFMbGlrUS81MnAvRG50VTFpaEZKb2RT?=
 =?utf-8?B?ZkVwaHRneHhGMk9rR0ZNdGVSeEFxbTAwbktlK041SE9WaEJER29sWm11WHpW?=
 =?utf-8?B?WnpTTlZIYjNCQW1SU2tKUEJ1SjFFdVUvcS9FKzcwSTZuL1FFTlVtRVgxaHJw?=
 =?utf-8?B?dDBBb2szYUtvenBSTWxPelB5RXdXUTBiSEdTYXBIU2JkaHc4QWtDYjgvTzB6?=
 =?utf-8?B?cHdtRE5uVHFtbXhUSm1YVkhMeU80MExGM0VoRnBTeHFobjhaTHFXK2ZySHFo?=
 =?utf-8?B?NFg0cjJ0SEd3STZiYWU4RC96NHRBclZwcDliNjVvcTJUOGhXQUx3WWdJMzgz?=
 =?utf-8?B?UXp2MmlpdW14b1dkc0daRDU1OUlFaGdtMWtiMXBtaWp2S3JvUlJlOUplZFEy?=
 =?utf-8?B?dnd4NW9WTjJWMTE5U1ZUeG9jaGNWVjZ3eStsUnNZRFpVNzh5dTBBQT09?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	8g+0ajZvcd4xGyuBf0yvb0H0VFKm0F8WconjjfbAWAEOTXnrpg688jud3zV/c6vCrJnCtQhi2xBoCGfaUloHyJxU3DaZdgN+M0OXwLTImZfROFoEE5n0QHoX/i1JpBncRae+sd2XcURWlt2RHwt+IYAEgNpCTySZK82z5mACS0Q0TJi8NmgkZs+t7V16nTWZNHylulE7laD5eF3FEKbqdyXBQQ55seCts7jfCdrRkrtZGjIel3W67HgAq7xU7ZvXX25NrTcyvmpDMyxy6pgdloOXKkgi0kcA6nxI2EsdGRwViwiayrxe7eUzo8M+kAmXSKvT8g8gLFzz4LqYGChuCnYxQfHJ9KbIFQGKGfapoerFrHkgZCL0J6Nmtjj1GvHUyqUy6EbGJrzZ+nGGqXv6wQnvHxZCTWk7Ea0vzEbBiW/r2GTqU4/gbFKrqad6PKp4jEj7eUJtjASi3eqrNUY8TputS4RB9I9Py9civ5TYOE2jyfst8cjXx83hNz7elvvraTcAwINiKotfBjwcFxDJxPOM3A6Qbafw8K9eh2G6dcN4ink2102xKh6659jQztbqpZwMnVdgcz0ilUZeu9jC3R2HNt/xwH7aYmAI6xPla7A=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: deb8ea57-b2cb-42e8-8b98-08de597344ce
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB7129.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2026 05:01:14.5623
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CzLUOZV1XgsVU1xF0rMDCRy9O329gnrodb07k5PL70iaBndnHb/1wFGjTQPY866Ze6LBkriVePLPRIlFUNVT3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6340
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-21_04,2026-01-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 malwarescore=0 bulkscore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601220030
X-Authority-Analysis: v=2.4 cv=WbcBqkhX c=1 sm=1 tr=0 ts=6971af1f cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=JfrnYn6hAAAA:8 a=yPCof4ZbAAAA:8 a=k5g9ik0fW-iRHoB2gLQA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIyMDAzMCBTYWx0ZWRfX3+juHHompB2w
 PALg24BLXNP0ZxOzgt98X8tX6G+mm4yHY73DkzHWFpDvYrc9xARoMxoFI5BCTbe8Iz9k8QrWz0H
 ia4dEp9QsM9n6Zd5lWLceEooKtKcgv7L+SJGORNBuQtWA4OFgprkABr33q9llpSo/PL+Mzar9LZ
 OG3seVNhC/pK/he3Ec7ygIpTcAHXPQz6KnHxnu//pYkSa5x+3lNdVuNfqKtYwNpL+5F07yVAe+S
 +Pc3zYXoAGUe002/OGxgwUn63QnMiozUekGA+2emfz/d+HX/5dA3xc7Js0EPMiDt0Ub91zWI/Wl
 cWrRRUPch6cZJ4dpONCq5Px+N1ffnhi6sfD+JRZc6Fly0hvvtC6+tiJoo6McPfuvhi1Yal3Vwbz
 fAq0sxW0M9BKxZ4OffiB/1PTpWXw166DXqYRsmIcNycYUVfF9scT4YWui3t+Kuhc5G52e9ELcyQ
 Y9Ew4BhwdaFX8fCXVow==
X-Proofpoint-ORIG-GUID: hxQYHPRo1Ei44iZ_VOy3aEzW4OuO82yK
X-Proofpoint-GUID: hxQYHPRo1Ei44iZ_VOy3aEzW4OuO82yK
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.04 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[oracle.com:s=corp-2025-04-25,oracle.onmicrosoft.com:s=selector2-oracle-onmicrosoft-com];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-68851-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[13];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DMARC_POLICY_ALLOW(0.00)[oracle.com,reject];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[oracle.com:+,oracle.onmicrosoft.com:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[ams.mirrors.kernel.org:helo,ams.mirrors.kernel.org:rdns,oracle.com:mid,oracle.com:dkim,oracle.onmicrosoft.com:dkim];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dongli.zhang@oracle.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:7979, ipnet:2a01:60a::/32, country:US];
	RCVD_COUNT_SEVEN(0.00)[9]
X-Rspamd-Queue-Id: 6D40F61E90
X-Rspamd-Action: no action



On 1/16/26 1:31 AM, Dongli Zhang wrote:
> Hi David,
> 
> On 1/15/26 1:13 PM, David Woodhouse wrote:
>> On Thu, 2026-01-15 at 12:37 -0800, Dongli Zhang wrote:
>>>
>>> Please let me know if this is inappropriate and whether I should have
>>> confirmed with you before reusing your code from the patch below, with your
>>> authorship preserved.
>>>
>>> [RFC PATCH v3 10/21] KVM: x86: Fix software TSC upscaling in kvm_update_guest_time()
>>> https://lore.kernel.org/all/20240522001817.619072-11-dwmw2@infradead.org/
>>>
>>> The objective is to trigger a discussion on whether there is any quick,
>>> short-term solution to mitigate the kvm-clock drift issue. We can also
>>> resurrect your patchset.
>>>
>>> I have some other work in QEMU userspace.
>>>
>>> [PATCH 1/1] target/i386/kvm: account blackout downtime for kvm-clock and guest TSC
>>> https://lore.kernel.org/qemu-devel/20251009095831.46297-1-dongli.zhang@oracle.com/
>>>
>>> The combination of changes in QEMU and this KVM patchset can make kvm-clock
>>> drift during live migration very very trivial.
>>>
>>> Thank you very much!
>>
>> Not at all inappropriate; thank you so much for updating it. I've been
>> meaning to do so but it's never made it back to the top of my list.
>>
>> I don't believe that the existing KVM_SET_CLOCK is viable though. The
>> aim is that you should be able to create a new KVM on the same host and
>> set the kvmclock, and the contents of the pvclock that the new guest
>> sees should be *identical*. Not just 'close'.
>>
>> I believe we need Jack's KVM_[GS]ET_CLOCK_GUEST for that to be
>> feasible, so I'd very much prefer that any resurrection of this series
>> should include that, even if some of the other patches are dropped for
>> now.
>>
>> Thanks again.
> 
> Thank you very much for the feedback.
> 
> The issue addressed by this patchset cannot be resolved only by
> KVM_[GS]ET_CLOCK_GUEST.
> 
> The problem I am trying to solve is avoiding unnecessary
> KVM_REQ_MASTERCLOCK_UPDATE requests. Even when using KVM_[GS]ET_CLOCK_GUEST, if
> vCPUs already have pending KVM_REQ_MASTERCLOCK_UPDATE requests, unpausing the
> vCPUs from the host userspace VMM (i.e., QEMU) can still trigger multiple master
> clock updates - typically proportional to the number of vCPUs.
> 
> As we known, each KVM_REQ_MASTERCLOCK_UPDATE can cause unexpected kvm-clock
> forward/backward drift.
> 
> Therefore, rather than KVM_[GS]ET_CLOCK_GUEST, this patchset is more relevant to
> the other two of your patches, defining a new policy to minimize
> KVM_REQ_MASTERCLOCK_UPDATE.
> 
> [RFC PATCH v3 10/21] KVM: x86: Fix software TSC upscaling in kvm_update_guest_time()
> [RFC PATCH v3 15/21] KVM: x86: Allow KVM master clock mode when TSCs are offset
> from each other
> 
> 
> Suppose the combination of QEMU and KVM. The following details explain the
> problem I am trying to address.
> 
> (Assuming TSC scaling is *inactive*)
> 
> 
> ## Problem 1. Account the live migration downtimes into kvm-clock and guest_tsc.
> 
> So far, QEMU/KVM live migration does not account all elapsed blackout downtimes.
> For example, if a guest is live-migrated to a file, left idle for one hour, and
> then restored from that file to the target host, the one-hour blackout period
> will not be reflected in the kvm-clock or guest TSC.
> 
> This can be resolved by leveraging KVM_VCPU_TSC_CTRL and KVM_CLOCK_REALTIME in
> QEMU. I have sent a QEMU patch (and just received your feedback on that thread).
> 
> [PATCH 1/1] target/i386/kvm: account blackout downtime for kvm-clock and guest TSC
> https://lore.kernel.org/qemu-devel/20251009095831.46297-1-dongli.zhang@oracle.com/
> 
> 
> ## Problem 2. The kvm-clock drifts due to changes in the PVTI data.
> 
> Unlike the previous vCPU hotplug-related kvm-clock drift issue, during live
> migration the amount of drift is not determined by the time elapsed between two
> masterclock updates. Instead, it occurs because guest_clock and guest_tsc are
> not stopped or resumed at the same point in time.
> 
> For example, MSR_IA32_TSC and KVM_GET_CLOCK are used to save guest_tsc and
> guest_clock on the source host. This is effectively equivalent to stopping their
> counters. However, they are not stopped simultaneously: guest_tsc stops at time
> point P1, while guest_clock stops at time point P2.
> 
> - kvm_get_msr_common(MSR_IA32_TSC) for vCPU=0 ===> P1
> - kvm_get_msr_common(MSR_IA32_TSC) for vCPU=1
> - kvm_get_msr_common(MSR_IA32_TSC) for vCPU=2
> - kvm_get_msr_common(MSR_IA32_TSC) for vCPU=3
> - kvm_get_msr_common(MSR_IA32_TSC) for vCPU=4
> ... ...
> - kvm_get_msr_common(MSR_IA32_TSC) for vCPU=N
> - KVM_GET_CLOCK                               ===> P2
> 
> On the target host, QEMU restores the saved values using MSR_IA32_TSC and
> KVM_SET_CLOCK. As a result, guest_tsc resumes counting at time point P3, while
> guest_clock resumes counting at time point P4.
> 
> - kvm_set_msr_common(MSR_IA32_TSC) for vCPU=1 ===> P3
> - kvm_set_msr_common(MSR_IA32_TSC) for vCPU=2
> - kvm_set_msr_common(MSR_IA32_TSC) for vCPU=3
> - kvm_set_msr_common(MSR_IA32_TSC) for vCPU=4
> - kvm_set_msr_common(MSR_IA32_TSC) for vCPU=5
> ... ...
> - kvm_set_msr_common(MSR_IA32_TSC) for vCPU=N
> - KVM_SET_CLOCK                               ====> P4
> 
> 
> Therefore, below are the equations I use to calculate the expected kvm-clock drift.
> 
> T1_ns  = P2 - P1 (nanoseconds)
> T2_tsc = P4 - P3 (cycles)
> T2_ns  = pvclock_scale_delta(T2_tsc,
>                              hv_clock_src.tsc_to_system_mul,
>                              hv_clock_src.tsc_shift)
> 
> if (T2_ns > T1_ns)
>     backward drift: T2_ns - T1_ns
> else if (T1_ns > T2_ns)
>     forward drift: T1_ns - T2_ns

Here are more details to explain the prediction of live migration kvm-clock.

As we know, when the masterclock is active, the PVTI is a snapshot created at a
specific point in time as a base to help calculate the kvm-clock.

struct pvclock_vcpu_time_info {
    u32   version;
    u32   pad0;
    u64   tsc_timestamp;
    u64   system_time;
    u32   tsc_to_system_mul;
    s8    tsc_shift;
    u8    flags;
    u8    pad[2];
} __attribute__((__packed__)); /* 32 bytes */

PVTI->tsc_timestamp is the guest TSC when the PVTI is snapshotted.

PVTI->system_time is the kvm-clock when the PVTI is snapshotted.

Ideally, the data in the PVTI remains unchanged.

However, let's assume the PVTI data changes *every nanosecond*.

As you mentioned, "the kvmclock should be a fixed relationship from the guest's
TSC which doesn't change for the whole lifetime of the guest."

We expect both PVTI->tsc_timestamp and PVTI->system_time to increment at the
same speed.

For instance, after GT_0 guest TSC cycles ...

PVTI->tsc_timestamp += GT_0
PVTI->system_time   += pvclock_scale_delta(GT_0)

... after another GT_1 guest TSC cycles ...

PVTI->tsc_timestamp += GT_1
PVTI->system_time   += pvclock_scale_delta(GT_1)

... ...
... ...

... after another GT_N guest TSC cycles ...

PVTI->tsc_timestamp += GT_N
PVTI->system_time   += pvclock_scale_delta(GT_N)


However, in QEMU, the guest TSC and kvm-clock are not stopped or resumed at the
same time.

P2 − P1 is the number of nanoseconds by which PVTI->system_time increments after
PVTI->tsc_timestamp stops incrementing.

P4 − P3 is the number of guest TSC cycles (assuming TSC scaling is inactive) by
which PVTI->tsc_timestamp increments while PVTI->system_time remains stopped
until P4.

Therefore, if (P4 − P3) > (P2 − P1), it indicates that PVTI->tsc_timestamp moves
forward more than PVTI->system_time, which will cause the kvm-clock to go backward.

Thank you very much!

Dongli Zhang


