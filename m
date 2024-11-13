Return-Path: <kvm+bounces-31781-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BDD149C78C1
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 17:23:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4D7FA1F220A4
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 16:23:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C4D0137C35;
	Wed, 13 Nov 2024 16:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Q+VITzec"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2084.outbound.protection.outlook.com [40.107.212.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 578F716FF37
	for <kvm@vger.kernel.org>; Wed, 13 Nov 2024 16:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731515005; cv=fail; b=ppr1xR/s4jD66ZwsWEagV0Q3OMeGo4EAkCNgLIXp97FRAks9DEXpam+qTUHtHxCyrMUdNgSAu4G6vZ05Y9PV14bgLSV2mFEgMz8y0N3OC59MvU2x3D3E+c3f29OoZTMZvHGYXhiiiUH/QGGS3rMA8po5rwEYTI8jRPZGb6hdHOQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731515005; c=relaxed/simple;
	bh=DV3PzvQ1FFn8kOWskD8whW6qY/OOsguSu4BF1NQZh7c=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Ok2qYXfNPZ1ATve00qJW22PTXBRifQldXVwTTqE+J5txV/nR3kZ1GKMoYT/PHuF12QrKRvJiZv1LDUifh8YAzv38P9aXXCfqujSvuH4RzxagNRVbyVxAvt+kjbFCfuM3CvlZ/QiKrdKzNKk+MRbEj+xd8uyw9TXp4hAcVsqonFQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Q+VITzec; arc=fail smtp.client-ip=40.107.212.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eBAbAYHB7B57bLhGJqWkmGSz3i7EVb5lMnX+zDTKaEO8zREa+Ftjg2NJtg7N4oCILs/KQRVx/hbP0wUkxNu/akmq3n1TKtsIN0u7MNrIpEfbySfWrsMZRXx8574MxjT5iScZqyYEvWtVBmWtgbiuoMxmiCHFNFY73mcXgvamYpUx9ZrQVy+YuBPGoa+eiRpiDJ00hj/CYEM0nGx3BO7kmdLRsM3wVZUabEIhqJcXRhnLybQ+CTKbl38sMmgI5YqfGpZBEECtQ1ZuiObmp5T1YdvqfDAqQ+r1Ir59A5x5jfISfNT++MyvKXdRD6Da092Wxpo/qB5quQSCyrEaB4Jn1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qb6Hz5QEhhvWRK0UAjgX+IXz2YXOxk84MHhfI+WQemo=;
 b=KDH1qJzfKo9dFNo8TvHFtYjkEctAE4e0C0r+DjCEe8Hv1CgwSj40eBzgYOwZZ5H8U6qNATBcIMheeQBulYuXYVjaVtFxdv4sk1cc1Co1qWhI7DhEp/f3cUPHBjhEP2jvhsWt9ZvwoQ1Sq9cBybzutc644QxeOXFIWX3IlRUU4yck57szJABWrsdqHiyMnlxwfBakGftmfClKVUmGrx9PO18GYi16/l3Js+6jYl6FCUUjmK/GTVR7jQw1/PDg9liAIVzas1L0Po2uC++2Ss7qptlFbWHs3UM5Qq9w0jmccYqlKCivnZxeAxB8KocJ65HrtcZFxiSwU0yIIv57BvI0iA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qb6Hz5QEhhvWRK0UAjgX+IXz2YXOxk84MHhfI+WQemo=;
 b=Q+VITzecZ29oZK2EZ/CMVjOeF23d0VpkXGEyDr+pq4ihwXt0tFBwda/1yUQP0oSO0baIsexSrYQP/Xnln9fiq7ZZMdzQAKht9eCx+qF9NcpuvA0KTcQKbJqfgnx5DD2kCXF9CqYcBY8k73lhax45qiDGDBL4wc2uP8WRdMc0iTE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SA0PR12MB4557.namprd12.prod.outlook.com (2603:10b6:806:9d::10)
 by MW4PR12MB7261.namprd12.prod.outlook.com (2603:10b6:303:229::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.17; Wed, 13 Nov
 2024 16:23:17 +0000
Received: from SA0PR12MB4557.namprd12.prod.outlook.com
 ([fe80::d22d:666e:be69:117f]) by SA0PR12MB4557.namprd12.prod.outlook.com
 ([fe80::d22d:666e:be69:117f%6]) with mapi id 15.20.8137.022; Wed, 13 Nov 2024
 16:23:17 +0000
Message-ID: <2394ca75-409d-4ae5-b995-27f8b196a1fb@amd.com>
Date: Wed, 13 Nov 2024 10:23:15 -0600
User-Agent: Mozilla Thunderbird
Reply-To: babu.moger@amd.com
Subject: Re: [PATCH v4 7/7] target/i386: Add EPYC-Genoa model to support Zen 4
 processor series
To: Maksim Davydov <davydov-max@yandex-team.ru>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "Roth, Michael" <Michael.Roth@amd.com>
Cc: weijiang.yang@intel.com, philmd@linaro.org, dwmw@amazon.co.uk,
 paul@xen.org, joao.m.martins@oracle.com, qemu-devel@nongnu.org,
 mtosatti@redhat.com, kvm@vger.kernel.org, mst@redhat.com,
 marcel.apfelbaum@gmail.com, yang.zhong@intel.com, jing2.liu@intel.com,
 vkuznets@redhat.com, michael.roth@amd.com, wei.huang2@amd.com,
 berrange@redhat.com, bdas@redhat.com, pbonzini@redhat.com,
 richard.henderson@linaro.org
References: <20230504205313.225073-1-babu.moger@amd.com>
 <20230504205313.225073-8-babu.moger@amd.com>
 <e8e0bc10-07ea-4678-a319-fc8d6938d9bd@yandex-team.ru>
 <4b38c071-ecb0-112b-f4c4-d1d68e5db63d@amd.com>
 <24462567-e486-4b7f-b869-a1fab48d739c@yandex-team.ru>
Content-Language: en-US
From: "Moger, Babu" <babu.moger@amd.com>
In-Reply-To: <24462567-e486-4b7f-b869-a1fab48d739c@yandex-team.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN6PR2101CA0012.namprd21.prod.outlook.com
 (2603:10b6:805:106::22) To SA0PR12MB4557.namprd12.prod.outlook.com
 (2603:10b6:806:9d::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA0PR12MB4557:EE_|MW4PR12MB7261:EE_
X-MS-Office365-Filtering-Correlation-Id: 16ebc95d-9dd6-417b-4413-08dd03ff7b05
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UisvVEhteUczQkd6YnJoZnZUa3Rjckl4KzB6MjQ1TVgyQXhxUXZjbmVrQ3hp?=
 =?utf-8?B?KzlsdUF1YjU1dUhOMXFxZVRHd3A5NFlZdC90Z0dmRy9sYzVUQmpRS3RlSGhF?=
 =?utf-8?B?SGN2NGFlNHRYMFRva3BKZHdwbFRWZWtqbGV5QXJkVGRxNGdudlFDWVVyb2hM?=
 =?utf-8?B?eUNJZXBTTXJxbWYrVWM2V2prSlhvQWwzd2J0VDlMNm9vSDFMS3gyUlY4STdE?=
 =?utf-8?B?M0JkeG5ZS3hnbzJHVkEzdXA0UHMwQ1ZWckpBczVpRm81QTFqYmFJNEROTzda?=
 =?utf-8?B?SEluOXRjb2R5aFl5ekdrRmZwaTQ2WGhrQUZmTytlTlVhbjBxVThnQWhncldi?=
 =?utf-8?B?bkJSa2pod3N6TXozbGY2KzMzdkRjaGdHOUc4dUY5R2ZpZGRkZW0yVVFrZG55?=
 =?utf-8?B?SUE4Zzg3aVhIYXZENkcyYXVvQXRkeitidXQ2WUNlcXNURnZiTVhRdXdUMGRS?=
 =?utf-8?B?K0pYVkVmMjdSZDg1bzd5U1BDZ0szdWpjZk4ybktxbTh1R3hPYllDcFYwN1VX?=
 =?utf-8?B?bS85RFR6S0Z5eWZwRUFKMmlYc2hOTHBqMGxTMHpOTkpKZjZPbUJ0QnFRTVY2?=
 =?utf-8?B?WnJJVFpmblNFRC9obCtjdDlVOWlSZmZkVnRuaWwrbHA4WXgxb0lSUUFSZDhY?=
 =?utf-8?B?dXlhNUhVdG51OCtxVi9BWVluUWNZcGJpMUVIV2NTR2F0OC8rVXJ1b3hxYkRw?=
 =?utf-8?B?TjRhNmJPem8zOUNOdE1QS1RsKytVMTJhaHJyZTBFUWl5cmJrb1UrOUZua2cr?=
 =?utf-8?B?QnlZN1RoazZJWTZSN3F5dk9mTEtMaDBYeTFhMDZPa1pJOXlDZmcxbDFJZko3?=
 =?utf-8?B?SDdWNCsrRFRyN3F3a2FwdHE1VHA1T2EreXNoTTFxNWlTUENNTElPRlMwYlZC?=
 =?utf-8?B?NG8rYUgvRHBOWlFFVUdMZFI3bEFIYkVLcXJES1FUYktyMFU2eml0UWlKaWhP?=
 =?utf-8?B?S2x1blFaT2lwbmRGOFdqOHpSSnl1aTFWSngrUkdyb1NJaUdFMGpBUnJUMGVy?=
 =?utf-8?B?S1RmdDRyS3lYdmI2WWRLZit1bmI4Wk1taDlIT25jY0hManlSSjk1RnFYQ1ZJ?=
 =?utf-8?B?RSthbjhLMGJacDlBM1pRRDFINXhaeitZUHp3MjhLUml4K1FwenFhQ3BVWXZR?=
 =?utf-8?B?TzBackpVdEIrVExWRWlYbm4va0dRcGl0ZVp5UGR1eUZObkNyS1JBQ01Nem5o?=
 =?utf-8?B?OVIrL2Z0SGkwTVBSTVB1Zk1BMDIwZGhZcjEzZy8yYVJBU1d0WklFZnBtOHFL?=
 =?utf-8?B?MzN6TkRjTGdWQm1mNUZrZks5dXhwWHV3MEJtZ1NxYWZRUlVlS2JtZEhiQ1Ix?=
 =?utf-8?B?T3FPVTFORlFGdFJ5eGJTTkFqa256V3FpRTQ1Z0llRHJTN0d6NERSZFYwZ2ps?=
 =?utf-8?B?Tlk4ZnBLSDlzWkdGR25UcG0wUGptSHJXenArcTRodXYyeWYwZDBvVjlyRzFS?=
 =?utf-8?B?aXZKRXNBZkkreHo5LytZUkRDbFh2NThhWCtZdTB2QUp2b0UvOHVzY3dVdWl2?=
 =?utf-8?B?WFhWU0w2UEhYcU15T3BoTnBic2lRamo2VWFQa3NtUU5uTmFyaW0zUkpsZlIx?=
 =?utf-8?B?TmhVdktXOFE2cUVpTmVjYXg5S0dZdjVPNW16M08zanNHeStueDR1K1BCNzR1?=
 =?utf-8?B?Wkt5a0xrakJOUGh5Q2x2b0U4VWU5SUZuZDJOK1Q1U1d4RDMxQlEvN0g0b09B?=
 =?utf-8?B?Z0h4K3RHRUpLK1l6UStGY3ZwTkRKV1pPZER0eUd3S1VjMzkxdC8zR0JJbkY5?=
 =?utf-8?Q?1PtmkeYlWX7pp2hkQONHSkqT/nW8Wt982jgyB+e?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR12MB4557.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TnN1RVE0N1F1aVZxdXk0Y1hYSy96NTh2RTcvZk9XQ0FxU1JwazVPeFdIMTRs?=
 =?utf-8?B?eENMdDdRUkVES0poL25KamZjemhIb2Vkcyt3QVdWdHJsYUtXU1V4WHJFMCt4?=
 =?utf-8?B?TjJ0SzRXVGh3cjBIS0R6ek93Rnc2ay9MT1hTU05JNjc5QVVjb0VwcEhLdW5P?=
 =?utf-8?B?bVdjQU9hZVVWMURCc2VYaDd1WHFrY0VPK0Q2aWozT3ZiZzYzRGNTV3pEMFBk?=
 =?utf-8?B?Yjc3M0I3aTJsNUhBaHNHRDdVSjF4NnFlOWpya0RjYjRWV0pDVC9WbWtVakho?=
 =?utf-8?B?Q0c3WWhvUWQ1Y2VhZjRlOW1ONTJiUk85NUJSbmhWZ0VPcnhmZnJVRFlFZWVu?=
 =?utf-8?B?RStWcU1KUnExRmc1RThCQVJUd3Zrek9YRUR4MUM2UGFVWTF0cjVISnk5RXkv?=
 =?utf-8?B?SDZjY2VPeXdsZzhyQ0ttaGFYWGI0SHpYOHNOdW9KVVdtdjcrWmU4NWlPc29q?=
 =?utf-8?B?T1gwd2RiZk8wcGlab2crL3V4bXFxRlRDR0d6WFpLL0Q0aVpkUXBRNzdJcEZV?=
 =?utf-8?B?TVB0eEhKcFNBSmRUYXBtZ29rdGNNd3ZmQkxraVVUcjNnelBNRkkzZzJKM29P?=
 =?utf-8?B?SERyQTVrWnEweGhzUzFxMGV0U0gzTE92VHBoZmU0cDREN3Bray9GYzBWTU1v?=
 =?utf-8?B?a2Z4Nm9hZllFVm9Nd0plRkJQSGt5WlA3MGQzYTBoeU52VTBXTXFCYkZMbUFl?=
 =?utf-8?B?VUc2dE5uNTBWRE1DYy9tT3A0MFA2NUtQODlYekFnKzJxVE82QlpPRVIyR2gx?=
 =?utf-8?B?SGpMcHg3ZWQ1NDZUS3VFSHdkV29ZbkpuV1Q1N0gwbDNLZHg4RW9VbmRWMTQ2?=
 =?utf-8?B?bzJNTXdoMHZtbDR0YnZ0ZlV1Z0NSNGN2SU1UQ1BEdDJzQ0tIMWVTZ1Nsa3pB?=
 =?utf-8?B?aGEwQXFKSjRJMG84WW83QzVPTUpwaXZ0YjZNcE02OXpyRFNiK3haYVRmSDBL?=
 =?utf-8?B?NHJtTi9FT3JOc0FPbm9XblpVeDZENHhPNE13TmVpRnZNaklnL1ROZkFwRnE2?=
 =?utf-8?B?N0s2Z0NEWmxUb0MyS1MrWFo3allmRHFDZVlSZVlveTYrK3liZDNDcjJhUjVJ?=
 =?utf-8?B?NU0xbThnUUVnN0dka2YyNXIrZk9LcFA0VXAyYmk0Yzd1N1pPYlNTQTVic0RT?=
 =?utf-8?B?Yk1iemF2RVFjK1AwTldtckovbkhZQVRtK0ZsbldIaWZCaTRQdUllanRvTU83?=
 =?utf-8?B?TnUyYi9mWHNVZ2ZQQW1uRTdLSUJ4azNIdW5ySkpON2R4ZHV4RWNVRENOeWp3?=
 =?utf-8?B?Wjd1RmRoaXNvT0NRR3l2VFhwWUJtdnVlM0JPNXFzSGRSQzB0TGZveGR2eUgz?=
 =?utf-8?B?aHNncVZTOEM3ZFFoYlRuTTJwMkY3V2RPdmFCN3UxTll6REhyYXRmS215R1R1?=
 =?utf-8?B?UFh2cjJYYXU5MWphSjVReGdCV2RWQkc1dVhSYm1UZ0FzTmNhNGo5STQ3bUc4?=
 =?utf-8?B?aDhCZ0crZS90eG9JMWJVQjlhQ3pJdktNb1pXZHo4aFNVQzFrVGVWUkNUN09k?=
 =?utf-8?B?N2NHbXBITlVPdTlCVTRpV0ZxMGVHWDlsbEx4aFlwQXJPaUNFNVZ4cmowUHdQ?=
 =?utf-8?B?UU8vMWVqNEI0aXRDc3pCbm1BeFVkdU1sZHByZ2ZNVy9zV2dkYWxvVExSNmVQ?=
 =?utf-8?B?RUo5aktLV2VwNkllNWhiWUl4RUNwZTJXaWh1YXBGS3pvcHRZNm1qdnNLUW50?=
 =?utf-8?B?b0NqajgxejFEVmZMWm90K0d4YW5XdjdMNFY2eVRsa1RsK0N4ZkZXUC9oODZR?=
 =?utf-8?B?c0pGdjhjSmZpUy9ISWdob1hXV01zdVpWNEVPQ3p0MDArcmZtclRwb0J2QVZJ?=
 =?utf-8?B?SEdlOG82NUFJRW5obkVSNWtrTHE0QU9salNSUTh6bllPRWlWVm16aFY1am1S?=
 =?utf-8?B?MXQyUklSZFliSWsvWjlSTnhMc0tsbEVxUXJ4RU9DSjA3OGgzOUZVb3cwcDJB?=
 =?utf-8?B?dGFmWldpTTJkZjRCNlQ0YnlBMlJkaS93SzExV3hWS0U3NDhpUXRkSHZpT1Iy?=
 =?utf-8?B?RFo4WkxZY1lHT1lXRG04TlV1bHdzT2l1cmNhNGlQT1dGdkNBV2dVMnY3UDlU?=
 =?utf-8?B?R2pYUzI4RS9qWHVoOHV2ZkIyMkhxendVbTBNYnc0ZHZIR2lZWnVBZVd0V3B5?=
 =?utf-8?Q?rq/A=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16ebc95d-9dd6-417b-4413-08dd03ff7b05
X-MS-Exchange-CrossTenant-AuthSource: SA0PR12MB4557.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2024 16:23:17.5366
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iWkQV33fDMo7bq6M/OgbNpmxTuF9aaChESrgVSlfVYEsjQ62JJdLP8K0ux/EEc3P
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7261

Adding Paolo.

On 11/12/24 04:09, Maksim Davydov wrote:
> 
> 
> On 11/8/24 23:56, Moger, Babu wrote:
>> Hi Maxim,
>>
>> Thanks for looking into this. I will fix the bits I mentioned below in
>> upcoming Genoa/Turin model update.
>>
>> I have few comments below.
>>
>> On 11/8/2024 12:15 PM, Maksim Davydov wrote:
>>> Hi!
>>> I compared EPYC-Genoa CPU model with CPUID output from real EPYC Genoa
>>> host. I found some mismatches that confused me. Could you help me to
>>> understand them?
>>>
>>> On 5/4/23 23:53, Babu Moger wrote:
>>>> Adds the support for AMD EPYC Genoa generation processors. The model
>>>> display for the new processor will be EPYC-Genoa.
>>>>
>>>> Adds the following new feature bits on top of the feature bits from
>>>> the previous generation EPYC models.
>>>>
>>>> avx512f         : AVX-512 Foundation instruction
>>>> avx512dq        : AVX-512 Doubleword & Quadword Instruction
>>>> avx512ifma      : AVX-512 Integer Fused Multiply Add instruction
>>>> avx512cd        : AVX-512 Conflict Detection instruction
>>>> avx512bw        : AVX-512 Byte and Word Instructions
>>>> avx512vl        : AVX-512 Vector Length Extension Instructions
>>>> avx512vbmi      : AVX-512 Vector Byte Manipulation Instruction
>>>> avx512_vbmi2    : AVX-512 Additional Vector Byte Manipulation Instruction
>>>> gfni            : AVX-512 Galois Field New Instructions
>>>> avx512_vnni     : AVX-512 Vector Neural Network Instructions
>>>> avx512_bitalg   : AVX-512 Bit Algorithms, add bit algorithms Instructions
>>>> avx512_vpopcntdq: AVX-512 AVX-512 Vector Population Count Doubleword and
>>>>                    Quadword Instructions
>>>> avx512_bf16    : AVX-512 BFLOAT16 instructions
>>>> la57            : 57-bit virtual address support (5-level Page Tables)
>>>> vnmi            : Virtual NMI (VNMI) allows the hypervisor to inject
>>>> the NMI
>>>>                    into the guest without using Event Injection mechanism
>>>>                    meaning not required to track the guest NMI and
>>>> intercepting
>>>>                    the IRET.
>>>> auto-ibrs       : The AMD Zen4 core supports a new feature called
>>>> Automatic IBRS.
>>>>                    It is a "set-and-forget" feature that means that,
>>>> unlike e.g.,
>>>>                    s/w-toggled SPEC_CTRL.IBRS, h/w manages its IBRS
>>>> mitigation
>>>>                    resources automatically across CPL transitions.
>>>>
>>>> Signed-off-by: Babu Moger <babu.moger@amd.com>
>>>> ---
>>>>   target/i386/cpu.c | 122 ++++++++++++++++++++++++++++++++++++++++++++++
>>>>   1 file changed, 122 insertions(+)
>>>>
>>>> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
>>>> index d50ace84bf..71fe1e02ee 100644
>>>> --- a/target/i386/cpu.c
>>>> +++ b/target/i386/cpu.c
>>>> @@ -1973,6 +1973,56 @@ static const CPUCaches epyc_milan_v2_cache_info
>>>> = {
>>>>       },
>>>>   };
>>>> +static const CPUCaches epyc_genoa_cache_info = {
>>>> +    .l1d_cache = &(CPUCacheInfo) {
>>>> +        .type = DATA_CACHE,
>>>> +        .level = 1,
>>>> +        .size = 32 * KiB,
>>>> +        .line_size = 64,
>>>> +        .associativity = 8,
>>>> +        .partitions = 1,
>>>> +        .sets = 64,
>>>> +        .lines_per_tag = 1,
>>>> +        .self_init = 1,
>>>> +        .no_invd_sharing = true,
>>>> +    },
>>>> +    .l1i_cache = &(CPUCacheInfo) {
>>>> +        .type = INSTRUCTION_CACHE,
>>>> +        .level = 1,
>>>> +        .size = 32 * KiB,
>>>> +        .line_size = 64,
>>>> +        .associativity = 8,
>>>> +        .partitions = 1,
>>>> +        .sets = 64,
>>>> +        .lines_per_tag = 1,
>>>> +        .self_init = 1,
>>>> +        .no_invd_sharing = true,
>>>> +    },
>>>> +    .l2_cache = &(CPUCacheInfo) {
>>>> +        .type = UNIFIED_CACHE,
>>>> +        .level = 2,
>>>> +        .size = 1 * MiB,
>>>> +        .line_size = 64,
>>>> +        .associativity = 8,
>>>> +        .partitions = 1,
>>>> +        .sets = 2048,
>>>> +        .lines_per_tag = 1,
>>>
>>> 1. Why L2 cache is not shown as inclusive and self-initializing?
>>>
>>> PPR for AMD Family 19h Model 11 says for L2 (0x8000001d):
>>> * cache inclusive. Read-only. Reset: Fixed,1.
>>> * cache is self-initializing. Read-only. Reset: Fixed,1.
>>
>> Yes. That is correct. This needs to be fixed. I Will fix it.
>>>
>>>> +    },
>>>> +    .l3_cache = &(CPUCacheInfo) {
>>>> +        .type = UNIFIED_CACHE,
>>>> +        .level = 3,
>>>> +        .size = 32 * MiB,
>>>> +        .line_size = 64,
>>>> +        .associativity = 16,
>>>> +        .partitions = 1,
>>>> +        .sets = 32768,
>>>> +        .lines_per_tag = 1,
>>>> +        .self_init = true,
>>>> +        .inclusive = true,
>>>> +        .complex_indexing = false,
>>>
>>> 2. Why L3 cache is shown as inclusive? Why is it not shown in L3 that
>>> the WBINVD/INVD instruction is not guaranteed to invalidate all lower
>>> level caches (0 bit)?
>>>
>>> PPR for AMD Family 19h Model 11 says for L2 (0x8000001d):
>>> * cache inclusive. Read-only. Reset: Fixed,0.
>>> * Write-Back Invalidate/Invalidate. Read-only. Reset: Fixed,1.
>>>
>>
>> Yes. Both of this needs to be fixed. I Will fix it.
>>
>>>
>>>
>>> 3. Why the default stub is used for TLB, but not real values as for
>>> other caches?
>>
>> Can you please eloberate on this?
>>
> 
> For L1i, L1d, L2 and L3 cache we provide the correct information about
> characteristics. In contrast, for L1i TLB, L1d TLB, L2i TLB and L2d TLB
> (0x80000005 and 0x80000006) we use the same value for all CPU models.
> Sometimes it seems strange. For instance, the current default value in
> QEMU for L2 TLB associativity for 4 KB pages is 4. But 4 is a reserved
> value for Genoa (as PPR for Family 19h Model 11h says)
> 
>>>
>>>> +    },
>>>> +};
>>>> +
>>>>   /* The following VMX features are not supported by KVM and are left
>>>> out in the
>>>>    * CPU definitions:
>>>>    *
>>>> @@ -4472,6 +4522,78 @@ static const X86CPUDefinition
>>>> builtin_x86_defs[] = {
>>>>               { /* end of list */ }
>>>>           }
>>>>       },
>>>> +    {
>>>> +        .name = "EPYC-Genoa",
>>>> +        .level = 0xd,
>>>> +        .vendor = CPUID_VENDOR_AMD,
>>>> +        .family = 25,
>>>> +        .model = 17,
>>>> +        .stepping = 0,
>>>> +        .features[FEAT_1_EDX] =
>>>> +            CPUID_SSE2 | CPUID_SSE | CPUID_FXSR | CPUID_MMX |
>>>> CPUID_CLFLUSH |
>>>> +            CPUID_PSE36 | CPUID_PAT | CPUID_CMOV | CPUID_MCA |
>>>> CPUID_PGE |
>>>> +            CPUID_MTRR | CPUID_SEP | CPUID_APIC | CPUID_CX8 |
>>>> CPUID_MCE |
>>>> +            CPUID_PAE | CPUID_MSR | CPUID_TSC | CPUID_PSE | CPUID_DE |
>>>> +            CPUID_VME | CPUID_FP87,
>>>> +        .features[FEAT_1_ECX] =
>>>> +            CPUID_EXT_RDRAND | CPUID_EXT_F16C | CPUID_EXT_AVX |
>>>> +            CPUID_EXT_XSAVE | CPUID_EXT_AES |  CPUID_EXT_POPCNT |
>>>> +            CPUID_EXT_MOVBE | CPUID_EXT_SSE42 | CPUID_EXT_SSE41 |
>>>> +            CPUID_EXT_PCID | CPUID_EXT_CX16 | CPUID_EXT_FMA |
>>>> +            CPUID_EXT_SSSE3 | CPUID_EXT_MONITOR | CPUID_EXT_PCLMULQDQ |
>>>> +            CPUID_EXT_SSE3,
>>>> +        .features[FEAT_8000_0001_EDX] =
>>>> +            CPUID_EXT2_LM | CPUID_EXT2_RDTSCP | CPUID_EXT2_PDPE1GB |
>>>> +            CPUID_EXT2_FFXSR | CPUID_EXT2_MMXEXT | CPUID_EXT2_NX |
>>>> +            CPUID_EXT2_SYSCALL,
>>>> +        .features[FEAT_8000_0001_ECX] =
>>>> +            CPUID_EXT3_OSVW | CPUID_EXT3_3DNOWPREFETCH |
>>>> +            CPUID_EXT3_MISALIGNSSE | CPUID_EXT3_SSE4A | CPUID_EXT3_ABM |
>>>> +            CPUID_EXT3_CR8LEG | CPUID_EXT3_SVM | CPUID_EXT3_LAHF_LM |
>>>> +            CPUID_EXT3_TOPOEXT | CPUID_EXT3_PERFCORE,
>>>> +        .features[FEAT_8000_0008_EBX] =
>>>> +            CPUID_8000_0008_EBX_CLZERO |
>>>> CPUID_8000_0008_EBX_XSAVEERPTR |
>>>> +            CPUID_8000_0008_EBX_WBNOINVD | CPUID_8000_0008_EBX_IBPB |
>>>> +            CPUID_8000_0008_EBX_IBRS | CPUID_8000_0008_EBX_STIBP |
>>>> +            CPUID_8000_0008_EBX_STIBP_ALWAYS_ON |
>>>> +            CPUID_8000_0008_EBX_AMD_SSBD | CPUID_8000_0008_EBX_AMD_PSFD,
>>>
>>> 4. Why 0x80000008_EBX features related to speculation vulnerabilities
>>> (BTC_NO, IBPB_RET, IbrsPreferred, INT_WBINVD) are not set?
>>
>> KVM does not expose these bits to the guests yet.
>>
>> I normally check using the ioctl KVM_GET_SUPPORTED_CPUID.
>>
> 
> I'm not sure, but at least the first two of these features seem to be
> helpful to choose the appropriate mitigation. Do you think that we should
> add them to KVM?
> 
>>
>>>
>>>> +        .features[FEAT_8000_0021_EAX] =
>>>> +            CPUID_8000_0021_EAX_No_NESTED_DATA_BP |
>>>> +            CPUID_8000_0021_EAX_LFENCE_ALWAYS_SERIALIZING |
>>>> +            CPUID_8000_0021_EAX_NULL_SEL_CLR_BASE |
>>>> +            CPUID_8000_0021_EAX_AUTO_IBRS,
>>>
>>> 5. Why some 0x80000021_EAX features are not set?
>>> (FsGsKernelGsBaseNonSerializing, FSRC and FSRS)
>>
>> KVM does not expose FSRC and FSRS bits to the guests yet.
> 
> But KVM exposes the same features (0x7 ecx=1, bits 10 and 11) for Intel
> CPU models. Do we have to add these bits for AMD to KVM?
> 
>>
>> The KVM reports the bit FsGsKernelGsBaseNonSerializing. I will check if
>> we can add this bit to the Genoa and Turin.
>>
>>>
>>>> +        .features[FEAT_7_0_EBX] =
>>>> +            CPUID_7_0_EBX_FSGSBASE | CPUID_7_0_EBX_BMI1 |
>>>> CPUID_7_0_EBX_AVX2 |
>>>> +            CPUID_7_0_EBX_SMEP | CPUID_7_0_EBX_BMI2 |
>>>> CPUID_7_0_EBX_ERMS |
>>>> +            CPUID_7_0_EBX_INVPCID | CPUID_7_0_EBX_AVX512F |
>>>> +            CPUID_7_0_EBX_AVX512DQ | CPUID_7_0_EBX_RDSEED |
>>>> CPUID_7_0_EBX_ADX |
>>>> +            CPUID_7_0_EBX_SMAP | CPUID_7_0_EBX_AVX512IFMA |
>>>> +            CPUID_7_0_EBX_CLFLUSHOPT | CPUID_7_0_EBX_CLWB |
>>>> +            CPUID_7_0_EBX_AVX512CD | CPUID_7_0_EBX_SHA_NI |
>>>> +            CPUID_7_0_EBX_AVX512BW | CPUID_7_0_EBX_AVX512VL,
>>>> +        .features[FEAT_7_0_ECX] =
>>>> +            CPUID_7_0_ECX_AVX512_VBMI | CPUID_7_0_ECX_UMIP |
>>>> CPUID_7_0_ECX_PKU |
>>>> +            CPUID_7_0_ECX_AVX512_VBMI2 | CPUID_7_0_ECX_GFNI |
>>>> +            CPUID_7_0_ECX_VAES | CPUID_7_0_ECX_VPCLMULQDQ |
>>>> +            CPUID_7_0_ECX_AVX512VNNI | CPUID_7_0_ECX_AVX512BITALG |
>>>> +            CPUID_7_0_ECX_AVX512_VPOPCNTDQ | CPUID_7_0_ECX_LA57 |
>>>> +            CPUID_7_0_ECX_RDPID,
>>>> +        .features[FEAT_7_0_EDX] =
>>>> +            CPUID_7_0_EDX_FSRM,
>>>
>>> 6. Why L1D_FLUSH is not set? Because only vulnerable MMIO stale data
>>> processors have to use it, am I right?
>>
>> KVM does not expose L1D_FLUSH to the guests. Not sure why. Need to
>> investigate.
>>
> 
> It seems that KVM has exposed L1D_FLUSH since da3db168fb67

Paolo,

I see L1D_FLUSH feature bit is masked for SEV-SNP guest.

https://lore.kernel.org/qemu-devel/20240704095806.1780273-17-pbonzini@redhat.com/

Any reason for this?

Genoa and Turin hardware supports L1D_FLUSH feature.

I tested commenting the masking line and SEV-SNP guest boots fine.

diff --git a/target/i386/sev.c b/target/i386/sev.c
index a0d271f898..f5cc37bcc7 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -962,7 +962,7 @@ sev_snp_mask_cpuid_features(X86ConfidentialGuest *cg,
uint32_t feature, uint32_t
         if (index == 0 && reg == R_EDX) {
             return value & ~(CPUID_7_0_EDX_SPEC_CTRL |
                              CPUID_7_0_EDX_STIBP |
-                             CPUID_7_0_EDX_FLUSH_L1D |
+                             //CPUID_7_0_EDX_FLUSH_L1D |
                              CPUID_7_0_EDX_ARCH_CAPABILITIES |
                              CPUID_7_0_EDX_CORE_CAPABILITY |
                              CPUID_7_0_EDX_SPEC_CTRL_SSBD);



If there are no objections, I can add this patch in the Turin series.

Thanks

-- 
Thanks
Babu Moger

