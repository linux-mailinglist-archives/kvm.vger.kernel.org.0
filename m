Return-Path: <kvm+bounces-37315-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D22EFA286E7
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 10:47:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 40C9E3A756E
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 09:47:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49FA422A7F8;
	Wed,  5 Feb 2025 09:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="TnMPtZJC"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2075.outbound.protection.outlook.com [40.107.243.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D620155300;
	Wed,  5 Feb 2025 09:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738748836; cv=fail; b=ZNelwcpLu1fuX7CPjgoy1TGfcz/5vcJn3c/gsbdX5tWxM1a74PC5cAmJreUGgAvzdRFoVBkKkpQgQRI6h6K81+UbruHRviI2Kkcz+Rzp1+oLbTZe4aD3tixa+JbpxRvOXdPFzMc0JcI8/7kEgr4B+00U5uTW+N1ZeArLp2fP/z8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738748836; c=relaxed/simple;
	bh=5VcVV1ckcS/xciIVOP6W+bMTQ+hCZsrpc+EpuhnW4lM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qzDbbWeakSXkCiJK7Jt6aTWzwXXDdHPoEmRGHZxZ25IN+3kC69sgSQ81VN/OvO2HbRhbX2E2vQusTz1GXofrsy6jrsgEAgkeYcnQqDSqm6iDvImf3xz0al/bv54nQ4/8NEDupYf4O3Eg2bBpuIpy/+vvzp1qc0oC3A39SZyZUJM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=TnMPtZJC; arc=fail smtp.client-ip=40.107.243.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TWvTC0DwAVXchjBDC6VTBYPhoqcxISSl6WkGLymL134Pt9ueBScBgHkZCxekDQEg1V2jAkfrMbtAVsYzJ/8Qzzr+DmmG9358Pt6xOt4jZTqrG+UdL8TKdlrNVIvvVQvX0aA//PZb5pr2xyKxzmUxpauS/EOxV0gZNPXFdLwr2lR8LfuXVFiApknsQso6Z/dHDUDGwRAwUqHNy0Ki0FQWd68BV8M9/yT44G6jMgM/MP+viKJ5i6fiJQW2LFRvgED0AqlKDJjWHG5kxy6Ed4SryPsgGwJHJt3Cje7+p8Ajzte2rKAizuUzKYF9uV7rRKOslBFcpeuIWUCjp27TXpnyUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lSk2USYzZJ0DRFI15D1G+zNRaL/vHkD7jC0483c6q1w=;
 b=bsZpeV37YPIqakCjo/e8lOfB3eh26tqjtAnX6vnTjtDXsO5F33+6/BjSP0wkat7hI0MXYuBgSkbCzgDsjQEwr1Zw5zzkQpBJLsvBTvix+cINMHNUX0PqjglEkjx0IEHx6vL4QUoXUjNeqUKSww7XjQSTjSearylpVd49hPsb81eRxppcz9dr0I8PTOMdpvXVci73jz210UqNobdunddBZCo6Nq+vJpohIMu9lQd/i2yP5krYEBVAdVsl2LAjNCLoc6M77MD50SIW8EvLtrIBdUkUrzRXqggm8D3P1v/g+8zFkz62jJQA0V2mtM1Yclj+D/MQZfMKbfIYZ4Z/UDsU+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lSk2USYzZJ0DRFI15D1G+zNRaL/vHkD7jC0483c6q1w=;
 b=TnMPtZJCmwHj/oRrzUmEw1vKAIoYVSc2IQxS6eYi5TMW6W7tQUc/+C9cs06veHGYljYyO8ubNfihtF2SH9hV8ADuQya0z+H2d0lfEiwmyJ40fgQ4OAiyjGb1ap4/ofGvCb2whfS+2I+sIE934AMl/+qJpsq7VM3S+JSpDH9EXV8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) by
 DM4PR12MB7719.namprd12.prod.outlook.com (2603:10b6:8:101::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8398.26; Wed, 5 Feb 2025 09:47:12 +0000
Received: from DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5]) by DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5%6]) with mapi id 15.20.8398.025; Wed, 5 Feb 2025
 09:47:12 +0000
Message-ID: <1969aa1a-e092-4a48-b4a0-9a50ec2ef3b6@amd.com>
Date: Wed, 5 Feb 2025 15:16:58 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/4] iommu/amd: Enable Host SNP support after enabling
 IOMMU SNP support
To: Sean Christopherson <seanjc@google.com>,
 Ashish Kalra <Ashish.Kalra@amd.com>
Cc: pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 thomas.lendacky@amd.com, john.allen@amd.com, herbert@gondor.apana.org.au,
 davem@davemloft.net, joro@8bytes.org, suravee.suthikulpanit@amd.com,
 will@kernel.org, robin.murphy@arm.com, michael.roth@amd.com,
 dionnaglaze@google.com, nikunj@amd.com, ardb@kernel.org,
 kevinloughlin@google.com, Neeraj.Upadhyay@amd.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-coco@lists.linux.dev, iommu@lists.linux.dev
References: <cover.1738274758.git.ashish.kalra@amd.com>
 <afc1fb55dfcb1bccd8ee6730282b78a7e2f77a46.1738274758.git.ashish.kalra@amd.com>
 <Z5wr5h03oLEA5WBn@google.com>
Content-Language: en-US
From: Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <Z5wr5h03oLEA5WBn@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0211.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:ea::6) To DS7PR12MB6048.namprd12.prod.outlook.com
 (2603:10b6:8:9f::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_|DM4PR12MB7719:EE_
X-MS-Office365-Filtering-Correlation-Id: 97fdb570-226f-4fbf-26f5-08dd45ca106a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NXpTV2dlenRmQlFNN0RES1Z5K0JWMENXSHB6RXFkaWtHTXd5YUxHTFpZNVVk?=
 =?utf-8?B?SXJZamJMTEhhRHdtWWNvVVlTUVVMS3YyOU9rdDhoUFZSc2NGTDJlTUVEM3ZB?=
 =?utf-8?B?RzVaWlliWUR5Y0NvRUQrRlE1cStMbGc1QzZOZXV1U3ZrVVRDMVdRRXY4LytY?=
 =?utf-8?B?Ly9pMjdBL3dKYlp3UmlMbEg2dDZEQWVUbml3TFQ4dUcydlliL0s0NzVUQ3ZV?=
 =?utf-8?B?VmNIOWRnN0xpQVdnbTVqTmZEQzFrQmUzYkVoTC9rTmczMk5sVmlSaXdLbk9P?=
 =?utf-8?B?TThOTGxMK242WHdzZysvMlhSeHkwTnRZWklCd3JaQkdueXFsMllEbThTSURp?=
 =?utf-8?B?ZzlmSnNGNi9lMHF2Vkt4M2hxTlhNRTBxOGQ4YytLREtvVUVnY3R0SUJZdUZI?=
 =?utf-8?B?aVhCdWhSZjNMYXhqRzJUUCtMZnRaUnE2ZFlRNFJyL0pKVlk0bmRlQWpNS3JD?=
 =?utf-8?B?bGQ3VWpoWVRSK3ZTRWtTTWJEMVc5cnMvc1gzVkRKUU5teGZvTHJRL0xSZENm?=
 =?utf-8?B?RjBpSFJPdDdoZTY3UTJyRzhnV3NYY1MyekpPNDQyRzVVemxhVHNCZkxvYXZS?=
 =?utf-8?B?eEJFNHoxZjk4L0hkS1JtVlVLSkw5Q2NsWm5DeE9wS3h6U2FhbWlPTlREVzJm?=
 =?utf-8?B?OFZqYWpKWEthelVCMlFxZ29jUkwrV04zMWNZSlhxWUsxL2NHdE9MZDFSU3J3?=
 =?utf-8?B?cEx3Zk5ucWRRTUJPbGh1ZmxKdCtnK3R5VmxJZGlKZi85ZmJmSVRGR0duSXpQ?=
 =?utf-8?B?MHdWdHpTT3RxblZCTGFmTDBpam9nWS80RUNPWnlNVHM1TWFFYmZEYVRveUhz?=
 =?utf-8?B?V09ROVptSmtyLzVkQXY4cFJocEFXVjdhZllaNzNsa3pVTVZEZzczRVY3NE5n?=
 =?utf-8?B?ZDJmY3hRcUZMVWpPMkV3OVNsc0FYTWd6eXF0dEpYTkJwTXl0QTlPeTZXT1lm?=
 =?utf-8?B?QmxRbGlONit6SDFaSThCMFc1SEJEYkM3aGRRVEZ4KzBRTFBLVERoQ1MrSWdr?=
 =?utf-8?B?STdxV1l6Ym5PYUZTVGxNUGpTcDFQdm5kOTdScXlLdzRUUFNNbTI1ZmhaemJx?=
 =?utf-8?B?L28rYVZiU3B5eXg2WXg0d0JncXlwU3pPdjBXTENtMXkydHFFOStyZHpnYmRi?=
 =?utf-8?B?RFloNytvREJJSnVhVVBCZ0JzenVua29PdnlVRGloelQzbkhnMHgyMHBZNnI3?=
 =?utf-8?B?QUdjcktDOXNEb21YS3R3QWZZSUl1OURqYUs1S2FNTTI1SFVTekVPdS9ocXlk?=
 =?utf-8?B?VVNPZE1pYWVSbGZRY204bGhmNHp0WWFyWlNOVjRJTmRPc3U3SUhzSUdQZG9i?=
 =?utf-8?B?UHhKb2lDRDJndHIzWlc1UzdGei9pSGJFNVhEd2xwS2JYcmpyN0V6Ym55aWI3?=
 =?utf-8?B?M1FYTnY3dGx6Rm5jZGlQVERNVjY3TXk5dzhkWC94WU4wN3BCUnBORXhRdE1F?=
 =?utf-8?B?K0c1WGU3RnRWbTF0VjZlaW8xa3c0ZnFaRTVVL3h3SnJ4SmJIM0ZVR3dzY2Vz?=
 =?utf-8?B?dmNJeHAxQ3o3Q0ZqYSs4d1EwY2hRd3RhZjN4Si9NNmR2ei9JVGpSOE9zMTY0?=
 =?utf-8?B?ZWl4dDdHZVdqby9rUWwySkZBL1YwR2hHTlBVR21YNGs5U0dwRnRFRWROSFF0?=
 =?utf-8?B?NnhoSXFOaXp2SnRGc2ZSYzBFOThDZlFicXY5aGJpUzJ6V2Y1MzZhdldEbzZE?=
 =?utf-8?B?enBoQWJWR3dhZStIN3ZhM2FjZ0lYZnlYRVduVXpWc1kzOHc3MDJSU3l2QmJn?=
 =?utf-8?B?cmErYjFTck9XREV3K04ybGMrSGJGMUN3aFhoL2prMitzVjdCdkdST2dUektI?=
 =?utf-8?B?dDFGc2w3djBwaGFHaVZrRGN2MGJEZ1N2QjVRVmtvK21PZFNtVXJxVkErRCtV?=
 =?utf-8?Q?Wq3AYlaqSuGyE?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6048.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?S01IcktxZ3c4b1UzWjFYcnQrMGsyaE01N2NyTjd3V0JBc0NCNkFvenQzakxF?=
 =?utf-8?B?V2ZzNVF6djFRWktjZkVhWXFNV0ZUMXpQMW5GbUVzTWVBRFUyKzBFUzJ2Ymdy?=
 =?utf-8?B?VS9rNFl4NnlodkgxVXVOOGF4WVBSQS9hdGJnSVI5Z0ZxQVl6RUZqT2MvZG1l?=
 =?utf-8?B?RDF3L21yVytncEM1NTBSZmMyTTRMU0lHbWRkRjBKcVYyNWUrcUtYODBuK24v?=
 =?utf-8?B?SUtrR3lmdmowb0hKZDdLcWxIZWZhTFUxcUd0c2FMOFp6ZFZRUTlzWFFBMnhD?=
 =?utf-8?B?SVNnM2RLMmhTZzhsemw2N0Fzd0JlYTJLbGVqMlRVTWV3RGxpeklPWW52eFli?=
 =?utf-8?B?M2dMZjNyaFRLdU5sZGVuZytYUTF4cm9zNE9tQ20wdnI4U0tEL0xmL2M3WnJJ?=
 =?utf-8?B?N1NKcUkvMkVMUmU5OEJReTF2VlRWUlB4Wjdxd051VXU3UlU4WFUwTFFNd3NM?=
 =?utf-8?B?cWdzUmRTWmxNRjI0U1paYXBJODE4bzVUSnpETDhqVjZBK2pKWlZEK0U4NTZL?=
 =?utf-8?B?dmNPeWJtdVhHMi9Na1I4RXFaTDh3QmJVWVF2WFROWHVTMDBKUGtya0hwMTR3?=
 =?utf-8?B?VmcvOEtVWTZSZjZkYnNNQ1R4aEVqTE4vQVltaVJFRXBoK0UwWG9TM1JVU2dO?=
 =?utf-8?B?eDQ1bDQwV2RjL2RFZzNUby9SbmFoMytkMXBpNWZjYXZtRXRDdEZrRzU2bm4z?=
 =?utf-8?B?Mng0QjhJOW5RUEg4Q3N2VDdRcmVscVpMYTJmdHpaREhvNmI2WFNTNC94Qk81?=
 =?utf-8?B?TENLQjdkRlJJMjJBSXh3bEYxajdKRjNzZ1lXMncwT2FLeEt4ZHBYSzJaSnoy?=
 =?utf-8?B?RDZhUDlCTm9lVWllT1Z2MnVOSzJjenlQNGtoMHlpT0ZTb1JVQTJvR3NuSXAr?=
 =?utf-8?B?L00zWlpma3lOTEZXbjYxUW9jWmp6SjRlQkhpYjlxRkhncmtWUmpTNXlZNEEw?=
 =?utf-8?B?RWpVRjdkZGY4WGdmNzRhamVjcjUwcWFKUEI0Rml0YVpRQ1hDczFIdzVvVUFD?=
 =?utf-8?B?cytDdnllWEVpVEdza0xad2JiK0hFeFFQTkdKTUcyTll3WXRBZmpOUEsyRGpj?=
 =?utf-8?B?cGtPWmxuSjJjbUtJdG96ZmV0bmJvTEZQNDdwRjhydGs3V3lsVzNUL09ubFVl?=
 =?utf-8?B?bjUycW5yQW9JSW1ZZ3Y2NTVCdXdNaTZ3VERTZ3VWdkRKTUswQ0NZUHY4aXRo?=
 =?utf-8?B?QWRoSWZxdUNCeUhCVGlxRXh6VG1CUGlqL3NlOXBFTTRjK2JiQjBZQlVOUFlG?=
 =?utf-8?B?VFZtZCtQQm9DampnYklHZTduem1VOFNXcmtoa0JHeCtrK2FHakh6cWptKy9i?=
 =?utf-8?B?T0NDYWZGejJMdHR5VHJwOEJic3N4ZlA2WW5xY1BoeHBGTWt2MGJ5eGcwV1pN?=
 =?utf-8?B?Sy9wNFpOdDJJYUJydVpqU3lPbXFxbUtYRVp0dUcwZ0JHanB5cVJuQmZxZWM4?=
 =?utf-8?B?NHpYTW1OdDhBUS9TU1ZoTm1aaDZlRUk3UFZhTUtKMWs0ZjNpSkFFSnVaWVVr?=
 =?utf-8?B?MkpXVk9ybU5QcFFhcDRPMy9HLzIvekx5bFkrMlBDSEJSZW5hNGRXS3UrWmlo?=
 =?utf-8?B?dWxKQlFubzlnK3oyUjdQZk1sZk5yS1RBMmlrVnp0UTdtT0lyTzFVeUpEckl0?=
 =?utf-8?B?ZFk3bmoxUlhqblJ1M0g2RzEza2lYTnZJaVJ3SGJoaHdWMk9rT0tjRTcvRWlO?=
 =?utf-8?B?ZlBUYTFhajJmeG5SU21wTHpkTHJZYnRwbTBqem5YR2VIUW44dTg5V1ROMHVL?=
 =?utf-8?B?SkNHZjlpRUdBVTBnZHNBTGwrY2JGS0ZsQkZlVWxvZ1JnOUlpaHBzVDIyMzM0?=
 =?utf-8?B?bDRONUJ3Tjk1dklKNVQwWkpsdXE1T05UcHR6cWZWbjVDSFNEdVVtZ0crMllX?=
 =?utf-8?B?QWRBTE1mU3NZa3cvRkVNMGY3RmFJRlY0WWJzdFpPUldPempkMWs4RVhyVVZy?=
 =?utf-8?B?ZE5XN2tSalJEdXFPSlJTYWxOMVpmM295aXcvVFhydXo2RHJ1dlBMcWd2YTNR?=
 =?utf-8?B?bGFuN2RKS3N0NHVnQzdDT2tPS1BjSTF6amdvTWJITGtOcWt5emtkOVdrQmNt?=
 =?utf-8?B?U2pCaFVOK2xVYkM0bzBkUEVTN1BNTVNrNlhPTFRNMUhCaWpiMUowYm55ZDg4?=
 =?utf-8?Q?gJj38Sj1OlmbWYyW1TjBuAIdK?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97fdb570-226f-4fbf-26f5-08dd45ca106a
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6048.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2025 09:47:12.1320
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Aw3IZEnyqOK9KPQS/Hcu3MpI6iUVLDbESywxMHU6NnqTY5vCYjv61RHz43Ra+EV8BhZY6IW/5eYAF69ZuyjJWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7719

Hi ,

On 1/31/2025 7:18 AM, Sean Christopherson wrote:
> On Fri, Jan 31, 2025, Ashish Kalra wrote:
>> From: Sean Christopherson <seanjc@google.com>
>>
>> This patch fixes the current SNP host enabling code and effectively SNP
>   ^^^^^^^^^^
>> ---
>>  drivers/iommu/amd/init.c | 18 ++++++++++++++----
>>  1 file changed, 14 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
>> index c5cd92edada0..ee887aa4442f 100644
>> --- a/drivers/iommu/amd/init.c
>> +++ b/drivers/iommu/amd/init.c
>> @@ -3194,7 +3194,7 @@ static bool __init detect_ivrs(void)
>>  	return true;
>>  }
>>  
>> -static void iommu_snp_enable(void)
>> +static __init void iommu_snp_enable(void)
> 
> If you're feeling nitpicky, adding "__init" could be done in a separate patch.
> 
>>  {
>>  #ifdef CONFIG_KVM_AMD_SEV
>>  	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
>> @@ -3219,6 +3219,11 @@ static void iommu_snp_enable(void)
>>  		goto disable_snp;
>>  	}
>>  
>> +	if (snp_rmptable_init()) {
>> +		pr_warn("SNP: RMP initialization failed, SNP cannot be supported.\n");
>> +		goto disable_snp;
>> +	}
>> +
>>  	pr_info("IOMMU SNP support enabled.\n");
>>  	return;
>>  
>> @@ -3426,18 +3431,23 @@ void __init amd_iommu_detect(void)
>>  	int ret;
>>  
>>  	if (no_iommu || (iommu_detected && !gart_iommu_aperture))
>> -		return;
>> +		goto disable_snp;
>>  
>>  	if (!amd_iommu_sme_check())
>> -		return;
>> +		goto disable_snp;
>>  
>>  	ret = iommu_go_to_state(IOMMU_IVRS_DETECTED);
>>  	if (ret)
>> -		return;
>> +		goto disable_snp;
> 
> This handles initial failure, but it won't handle the case where amd_iommu_prepare()
> fails, as the iommu_go_to_state() call from amd_iommu_enable() will get
> short-circuited.  I don't see any pleasant options.  Maybe this?
> 
> diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
> index c5cd92edada0..436e47f13f8f 100644
> --- a/drivers/iommu/amd/init.c
> +++ b/drivers/iommu/amd/init.c
> @@ -3318,6 +3318,8 @@ static int __init iommu_go_to_state(enum iommu_init_state state)
>                 ret = state_next();
>         }
>  
> +       if (ret && !amd_iommu_snp_en && cc_platform_has(CC_ATTR_HOST_SEV_SNP))

I think we should clear when `amd_iommu_snp_en` is true. May be below check is
enough?

	if (ret && amd_iommu_snp_en)


-Vasant


