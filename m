Return-Path: <kvm+bounces-15045-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CDFB8A9083
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 03:16:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DD419B220CB
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 01:16:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A832C848E;
	Thu, 18 Apr 2024 01:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jm3g7CQn";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="T/NGj5CW"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F676A94A;
	Thu, 18 Apr 2024 01:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713402995; cv=fail; b=krVBWkoeN9O63oTHojRwaSvcgHNueqyAxUIxLLLR8kfJ8xIrMlA4ClWhP8eUnVIWBVkx1st3iYoIE/5W4dWvpe7X0FZ1bzuzNwyOs4uGe+deRmnlkluV+jwIZS+3NQJSADurHs6lKLtPe8VnnM1Go5jA2jwp2oy3rEIaVPR0Z9c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713402995; c=relaxed/simple;
	bh=s1nd7zwWJn9g61qeg3ExogLtkC7L9iBiwTCHbaNcHaE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=PblRnD7GxHJad/rYHGuUew68LPiPPFeeNOHOIWxOOjW1Nqti8NVWBTe2bGLkrBeS0vMgIMPSsdQpZXBIAcYZbXelx/jjNqpKMDUQCzo6LZnUOKlvom+bw1iWnfQxcyeZKYaRM8D1BG0dJaabnDBnr7N99ZEBmwT2GXKS8vUklYA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jm3g7CQn; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=T/NGj5CW; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43HM4eTN011245;
	Thu, 18 Apr 2024 01:16:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=H/IfbO3ebmd/iiaFW8koidGeIvz17ClpLD6YL1ZVLgE=;
 b=jm3g7CQnhbvDP4tg9nDkXbebDbu0L6hwdg+3PKjDf9kDv8lUGO5uaF3z9FUPa6WrWCvw
 Q6/exnRnc/Sb7k1VbVB05i0Tux3cx1Cedaal9+kDpD+dn3Z0tmmgzUpXQMZqAXyi37wu
 RFDJpRpYXQ/GwcERkzDWHevXmGxo/LwnAFR03hb6ziaJaW8zWYpWesw/As8FthaKH1bJ
 jT2Yyv3L+09rIH9VBgdu4uJ2KPQSvETj5GlGmeEaYodxA3rxElP4UHz0ljRnULAkKMuT
 WHornoKUWKimpQ67KiqfKRDeFLhxsoiaedjhBxDXWI/BLU5MjTaDqRAOIA27rXYHkbRe 5w== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xfgn2s7rn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Apr 2024 01:16:25 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 43HN4eeG029171;
	Thu, 18 Apr 2024 01:16:24 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xfgg9nq11-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Apr 2024 01:16:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HVCu6mLHeoJcckQFNxMmCI5rM6eakfzDU3YyT1+lX18SGMyDn2wvwlH+ypTWG9yjGWUZWwdztuRo3Y7qIsk2xeWUQKu1/hWrtSgMILMigPVZvQdN2WOZt+3tEQlqnBxl3uWYASx4RDJsAkbyw5QWuZaKaUbZLJKl/6NfMXNIl2tDL8TxkH2bwiKJyEqA6HkFbal1Y9+sGwhzTXW8NvaDqJ83xC4Ela2ME/RaVPUt6e77S4JCebxUNk0xt6mrePjN+ANPmFVkX/9gJjGu28wFghf1pDcFZ9SmxxJygl9kF/Y5P/+dkN0YJejTHxn8fhsW8ApuZFIMF/K6jMXaxp2ueA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H/IfbO3ebmd/iiaFW8koidGeIvz17ClpLD6YL1ZVLgE=;
 b=gbD1+1wFNfN0mfJFTspTqRBxptTtX1ZFwdop7oJgj4FzJn0emTsmVmOyWrhU/1lGA/ckx7AIQXLwlvGKprXxUF22Gf54R9FnfVqL2voo/nUpwOo9tzCR5cJZp3UvI+Sv1UAKd38GE81K8cly84EViwynpMZKBKwKaGnaXksUYDm7BPz/lY02P0qkTPD2B8QMnFu3z6pHTHm9sk+EHFH9tAy2DZn1XqWIQ1hzQI5Kf6hU68FCPE/jVum4mbmcvUzE4jk3ATAJP4ndCL+oTdDCmKLcCpKz476c3eDc0jKNEEufHWzyJvzPuTVunp1/kNFj3hqhtQEjAQkG4Hzah7QZEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H/IfbO3ebmd/iiaFW8koidGeIvz17ClpLD6YL1ZVLgE=;
 b=T/NGj5CWSOzHjLm4blGhnZWPBVKSCSh84Kcdj3frypkHgpuAiPswmDSZR4+LofutL1RXmvvuSSUlEXrJbOX9okeanBtjGEDp3wKwd2JgaiJOEX6eKfB0tT64q/B56tDvdLWTdhXpYR6gEnkXBb7iy6czq4yfDmpur2zccVGtwBY=
Received: from DS7PR10MB5280.namprd10.prod.outlook.com (2603:10b6:5:3a7::5) by
 SN7PR10MB6307.namprd10.prod.outlook.com (2603:10b6:806:271::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7452.50; Thu, 18 Apr 2024 01:16:21 +0000
Received: from DS7PR10MB5280.namprd10.prod.outlook.com
 ([fe80::c7cc:f6b7:386e:fd5d]) by DS7PR10MB5280.namprd10.prod.outlook.com
 ([fe80::c7cc:f6b7:386e:fd5d%6]) with mapi id 15.20.7472.037; Thu, 18 Apr 2024
 01:16:21 +0000
Message-ID: <2fc900b8-4028-4fc2-a83e-a70ef8d7b37a@oracle.com>
Date: Wed, 17 Apr 2024 21:16:17 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] KVM: x86: Only set APICV_INHIBIT_REASON_ABSENT if
 APICv is enabled
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, linux-kernel@vger.kernel.org,
        joao.m.martins@oracle.com, boris.ostrovsky@oracle.com,
        suravee.suthikulpanit@amd.com, mlevitsk@redhat.com
References: <20240417200849.971433-1-alejandro.j.jimenez@oracle.com>
 <20240417200849.971433-2-alejandro.j.jimenez@oracle.com>
 <ZiBPHVKKnQPYK7Xy@google.com>
Content-Language: en-US
From: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
In-Reply-To: <ZiBPHVKKnQPYK7Xy@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0143.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::28) To DS7PR10MB5280.namprd10.prod.outlook.com
 (2603:10b6:5:3a7::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5280:EE_|SN7PR10MB6307:EE_
X-MS-Office365-Filtering-Correlation-Id: d11c28e0-e89d-45aa-62a6-08dc5f45283e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	DgTWj77rFnmSDDwKAIKQdNyAkLDT5nf+sRl1rD/qUgKwShLUUZ3PixG67sORal/Kr+vra5IyhaR9+5K8w5Xgabj2HfbkQzKEx+N5lE5p82P/f6O4YQpLcgsovPCrN1Hf4WmxQMkhQengnqCtR/h0TrEV7q7N/GvuEyzGdDeD+Trm+I50p21VtstjbSin5gn28YmVVAZhoBVUVV69vU35O1QYmCpob7Qhps3S9PZ/TQuYIdNADCCbfbPE9jhlgykbK8tT318E0ZqHZYwENo8jGdTz03X+16tSMv6NhsfvYee5gJ45MBHNuOrEbxf15VPgd0Wx9PUcSe3vr8HnqNb2MvZlmWmDwJy+g3JLwvJr+aXHK90IU5qleyuS1MV78BcYFCcsFLxTZsj3gimaxf4EC0f4BZFpTiOluwP0DQwgFHiFxsze/fAMoqM/gVEGGNyJ0bxxgpjwG7HnioKRmnSFn68r9/28/2T+NSfJRhqmH/yzM+uRFa7PUGJzlUI2rw9kExcPq8HFXzdPXm1dDfiTraZ7HQWfDPXejZqx7UrSG8o/76mU3gU63GD8HE9b1xLwLtE0F63UhhXsg36fzX3cmN7ZaR47ZnXm04pt4dfwajYcIRO/DSj/c/MdUizS14PcKuu7YF30m/IYCZvK3ifR0A4rxbEZ4E+PSdbj5xMODHs=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5280.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?aXh3VjVYWlNSNjNhRjQ3bi93SjdyYlB5MThDb0tDUS9oQWRKaGJGeS9FcWtI?=
 =?utf-8?B?NC9sR1MzWWd5U1pya2R1TERiZkRudElvOFczTHRsU0hxMzdoODBHRFMzbE0z?=
 =?utf-8?B?eTM3cDRDU2hLQXFVcm82aVdZcnZ0Y1Z0NHlLWnNMK2RSYzJzR21BVWs0Y3JT?=
 =?utf-8?B?UTZDRlE1bGhoMXJsczRsVENuVzRhbmVtcndCcGNHTWdiYWdNT2llSnMwRUxN?=
 =?utf-8?B?MW0rWW9lUXhHSDlIZDk5YmZwT20wT3ZTZTNkYTBiZGRRVGp3YURQZnpmcUJW?=
 =?utf-8?B?dGFTYjdsbTRNWGo1cTgyMG05Vk5MbGw4T1VHUlA5bFVoV3lZV1ZVTDVhN1dH?=
 =?utf-8?B?YXpScU1PL1FjeDM3cGl1SC8yc21MTGZXZTgvdVU1d0tTL0VPKyswVlJiVkh0?=
 =?utf-8?B?bGxieGlXbEhROS9YVGhQWnRabzdxdGNGTWlTRUNybEplNTFmYllham4xdCtG?=
 =?utf-8?B?ck1ySVRvMTE5MXJ2Wkk2Z0hvWjMrMVoweE92VmYxWUNiczhiTmZoQ2VJcXlQ?=
 =?utf-8?B?TFNxVjVndHZ5R2srR05LUk5aM2poTDFVN05rTVF5bkJJTFBpb0p1Wm56Ym40?=
 =?utf-8?B?bzVYYVN1bDhrVktSV2tSN01BY3FJOXZFTGE2TjEwRHU0dTZ6Z2hLa0xGSDUw?=
 =?utf-8?B?bWl1MHR1WlhRN3U0ZTYxaU5SQ005emlXR1NzSmczWEswYjhpUDBnZUUzNG50?=
 =?utf-8?B?RHYwMDNicUNtaTY1R1I0ZFVXL3FnYjNKSlFQUFZrLzcybFpsejlENGtMZ3lI?=
 =?utf-8?B?Ly9QazFrWHlTeFlKTnlPMmlWTW1WTUxOSUlJckVNNWZZTEtvUVhMeVB6eFJy?=
 =?utf-8?B?dk5EVUVyRUl0TnlPVkRaZklHVERmNUlzbmVMZERLZDFLMzF6V1pQZWlQN0M3?=
 =?utf-8?B?c1dHVEVTeCtoa1N3MW12Yld0ejVvYmFnM3VKdnhDNTdDQ1RlRytDYys5ci8w?=
 =?utf-8?B?SFBOYTRpb0pSS2xuT09zem9rdXN3SUFtSmxjc1JtNFk4YkRrMi9jSVRpSmZy?=
 =?utf-8?B?T1dselIwTS9mNlBuWTdtOFoyc2xYeXRMM0ZvVThNMDYvOHc3UlJmYzlGWTVS?=
 =?utf-8?B?UUdyU3FydUl0aGdZTHZJM3c5RXhob1ZqbmZpaGowSzVTL0hpVjE2dFl3Z0VC?=
 =?utf-8?B?YUZnOFI4WGNjU1RTbnlCZjI5R0RUSXZoaWV6RWlwTjBEUDFIOXk2QzZNKzNS?=
 =?utf-8?B?U0djMXVzNmd6SzR1M3ZvaExHclJJb2M1RXN1YldRSm52SmNIMTJnbG4yY1Yy?=
 =?utf-8?B?K1A2MjAwN1JoTDcxcDBEcjlMSmtNTkVGbVFENkg5Y2UvS2ZjQjk2bkdGbW9C?=
 =?utf-8?B?Mlplc1dYT3VaSUxOdDJOYjVsL3FmNTNxajlpMFpDNVNLTmRnQzFKTDlRakFy?=
 =?utf-8?B?Y3psR3dNQlplYitEZERucVRQWXA5UDJKSUZnUERxS1hiUUlLSGt2cU02V1Jx?=
 =?utf-8?B?S2pQRDQ0c2xZV3JKamg2eHhLRkx5M2VvT05qUTQzNlNveDRENVdCeCswVGNl?=
 =?utf-8?B?VEFIYzYzTW5IbWxNaVdSV3kzZTNJN3R4Z0g3ZmQ4VFZGSjd4UXRzOWdQVmJY?=
 =?utf-8?B?OUhkMm1jRmFtcXhOaGNqYkg4RXdXQWtVL0lUQ09MUk5GT05ONlIrVlhZemE0?=
 =?utf-8?B?WXpmVlpJbi9SZVJ5dmxick1teHNha3U4aXJTbWxrQjluQ2pYMlRVUjZGeGoy?=
 =?utf-8?B?YXA1VVROWWVHaHVXdURrclc1dEQvK2lqYmhOb2p6dVdqb0RVTC9LUnZUT0Rj?=
 =?utf-8?B?NVRGVHZYRVhxajRVc1E5TkI2N016WlN0alNTTXFYMW55NnhnbThKQWhCcllk?=
 =?utf-8?B?N3pPWTFKaTJyUzNWTy9tVmc2MTN4R01JMXg5ejFndWxsSGxEb0tQOWl1TWF3?=
 =?utf-8?B?MmhuUXFCS05KdHF1RnNpVFFhcUY4eDNPeXo3UXpVaEZhM0poTHBkSnNES3dW?=
 =?utf-8?B?VEY0aDNDNEpxemZQUktoaDNncWcxQkg5QUVxckZPbkRzUTFVZzcwcE5aY1BU?=
 =?utf-8?B?QXIvRVdzSE5EZWxlRnpPOC80WnZnNUZHVFRaSzM1N1UzVDZUWUw3eVVndGNx?=
 =?utf-8?B?OHR4aXJnQzFYckJad3p0MVFxOWorc281ajBzUS9xMTNOUVhlMHQ4ZHY5WVRH?=
 =?utf-8?B?cHlVNDA0aDVlUFllbldaYmloRmkwcTRmMlAzUEJGZXJpemxITTJLM1p5bWJJ?=
 =?utf-8?B?a3c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	ZcecbMet6jydCVnC7I5d/RieEk36maK6g/sOnPOVB7crO9cCwWQW1Iic7IahIVhvV6fA5XZM+kzNCOGCl5ChxnS4k+/YPhXDar3t0sm3RiJDmn6sGVwkRng4zjgZNeAyOmvABmJLng7OjJyktBb4UYnDDwIoi3e/y+VFjb2VbiteJkCMHygM70GJqeY2AKPYu3IsZTvPciZLkgehIJnXlEuMuEK2F02CLgPRABqAZEMho/nchAGp7mlpoFKNVKKLqdXskuf8NODWYLTqzYzmmcNdxLD3tjpFEmglJmACuGmpWTkGbPVBeECbzREdxXw8Cj5/v67xwOvN5CFU6w96VlDkftChSGT7D5dVi36CS4BVXrz+/xZVABwPqXqHO3Y8HNeAQiSXrDWIC7m6yMaGcnYwxBAhKhRqaciqvoVLwGDo2ZZtvGiDOTO0vMiIIjmRgGJLFZDrl2JWoGqLhwuAqwrePoTPWKIGy7bTh1NGMrp3rSvy2vhMcKA+2IvyKvk07egKRr23wb2ZdPR5Wodwhjdj5camzjR9o4Bq9a1rgWlxT1V50T7DLHWhBt71tP4rUfmrrpYF4xCk1nBlYYlnW0M2tSD5sNbJpCO+qiARCHk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d11c28e0-e89d-45aa-62a6-08dc5f45283e
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5280.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2024 01:16:21.4373
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dEASSdmcVKre6Z8t6J7DK1omdUMgOEL4lBHqt5a42Ih3IMQ1ZvX5FAE43VI+N0HCnNdNAX4TDb0xUHT2Fn2GUVDkRPsmdkUlPMn+LwZbyJ0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6307
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-17_20,2024-04-17_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 mlxscore=0 malwarescore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404180007
X-Proofpoint-ORIG-GUID: t0GEhRXGW5ZYaLKKYF2jrRDjODyZGXaj
X-Proofpoint-GUID: t0GEhRXGW5ZYaLKKYF2jrRDjODyZGXaj



On 4/17/24 18:37, Sean Christopherson wrote:
> On Wed, Apr 17, 2024, Alejandro Jimenez wrote:
>> Use the APICv enablement status to determine if APICV_INHIBIT_REASON_ABSENT
>> needs to be set, instead of unconditionally setting the reason during
>> initialization.
>>
>> Specifically, in cases where AVIC is disabled via module parameter or lack
>> of hardware support, unconditionally setting an inhibit reason due to the
>> absence of an in-kernel local APIC can lead to a scenario where the reason
>> incorrectly remains set after a local APIC has been created by either
>> KVM_CREATE_IRQCHIP or the enabling of KVM_CAP_IRQCHIP_SPLIT. This is
>> because the helpers in charge of removing the inhibit return early if
>> enable_apicv is not true, and therefore the bit remains set.
>>
>> This leads to confusion as to the cause why APICv is not active, since an
>> incorrect reason will be reported by tracepoints and/or a debugging tool
>> that examines the currently set inhibit reasons.
>>
>> Fixes: ef8b4b720368 ("KVM: ensure APICv is considered inactive if there is no APIC")
>> Signed-off-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
>> ---
>>   arch/x86/kvm/x86.c | 15 ++++++++++++++-
>>   1 file changed, 14 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 26288ca05364..eadd88fabadc 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -9999,7 +9999,20 @@ static void kvm_apicv_init(struct kvm *kvm)
>>   
>>   	init_rwsem(&kvm->arch.apicv_update_lock);
>>   
>> -	set_or_clear_apicv_inhibit(inhibits, APICV_INHIBIT_REASON_ABSENT, true);
>> +	/*
>> +	 * Unconditionally inhibiting APICv due to the absence of in-kernel
>> +	 * local APIC can lead to a scenario where APICV_INHIBIT_REASON_ABSENT
>> +	 * remains set in the apicv_inhibit_reasons after a local APIC has been
>> +	 * created by either KVM_CREATE_IRQCHIP or the enabling of
>> +	 * KVM_CAP_IRQCHIP_SPLIT.
>> +	 * Hardware support and module parameters governing APICv enablement
>> +	 * have already been evaluated and the initial status is available in
>> +	 * enable_apicv, so it can be used here to determine if an inhibit needs
>> +	 * to be set.
>> +	 */
> 
> Eh, this is good changelog material, but I don't think it's not necessary for
> a comment.  Readers of this code really should be able to deduce that enable_apicv
> can't be toggled on, i.e. DISABLE can't go away.

ACK, I'll remove the comment block.

> 
>> +	if (enable_apicv)
>> +		set_or_clear_apicv_inhibit(inhibits,
>> +					   APICV_INHIBIT_REASON_ABSENT, true);
>>   
>>   	if (!enable_apicv)
>>   		set_or_clear_apicv_inhibit(inhibits,
> 
> This can more concisely be:
> 
> 	enum kvm_apicv_inhibit reason = enable_apicv ? APICV_INHIBIT_REASON_ABSENT :
> 						       APICV_INHIBIT_REASON_DISABLE;
> 
> 	set_or_clear_apicv_inhibit(&kvm->arch.apicv_inhibit_reasons, reason, true);
> 
> 	init_rwsem(&kvm->arch.apicv_update_lock);
> 
> which I think also helps the documentation side, e.g. it's shows the VM starts
> with either ABSENT *or* DISABLE.
>

I initially had combined the checks (using a less elegant if/else), but didn't want
to convey that these two inhibits were mutually exclusive. But as you point out
that is exactly what REASON_DISABLE is with respect to all the other inhibits.

I'll send v2 with the changes.

Thank you,
Alejandro


>> -- 
>> 2.39.3
>>

