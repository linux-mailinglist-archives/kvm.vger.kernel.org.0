Return-Path: <kvm+bounces-43152-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BBFCA85A1B
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 12:36:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2CB23466674
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 10:34:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 791BF221271;
	Fri, 11 Apr 2025 10:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="e0COTkXf"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2066.outbound.protection.outlook.com [40.107.100.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A01B017D2;
	Fri, 11 Apr 2025 10:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744367680; cv=fail; b=H8Dvi+zNWqwMAzMtcu2YXQkouFzO3K85qfJvk1KoeGD6rk3jzsz4lnTmwUhrWBa3mkfcYyS27qpGdrdxO0PzObaK5otpT96l50sZue3fiLb1X3RDidJdqhBcSlicW3C9tW5cL5UXiG2T0J4bhHrJPZXbX6zhKBk7jyUfaVMG4/8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744367680; c=relaxed/simple;
	bh=8ltG8JhZ99OVnpDrE/sBnQTIX+udiCCTamCtZvvGc3A=;
	h=Content-Type:Message-ID:Date:Subject:To:Cc:References:From:
	 In-Reply-To:MIME-Version; b=jaQGPyBN0mzP09Ih+VG/fFpjry34DN9HMZRQSVZx+sb7isT/AiZpJPFmertjNfBj0KHegaTlSITP5lU9Z7QTpwxP2e1f1vVsHJ9fJz3VU02+LfbNzawMzpNQ5fyLb9qnxGtSlcGcyD+kBVgBv3Wfm2bvG8lUHsOMaUDchrF2dPM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=e0COTkXf; arc=fail smtp.client-ip=40.107.100.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UmqQBkeA8bUFEXvfew2R4SLHpAWmpn6DnjalOfCOepb377byKoiYW1GrLpLuS6SB1QTZ0nby9O/bQmlnAMBacXh/bCjqmTxZnA3kqpfWwKLXDslVaRx5avTbkxgMUybOcn0ily4iCSJ2Lp1ls8dk6gbw/bET32NYUoQYEgglDrYIt7OilDNbx/7iGaZDA+8589hNsoF/KItWVK+SC2Uu+vyKMdSUwaGGyIa4rNaiW+LlDOoDtB/KoWkXIr01ub3WiK7mZMH4WJ6gY3fU9Q1YMHJKcJROiYiE9QgO0KwhQKj2GUOq03myW19tiGrDcXHnr7bdm6dEUoP3NhHsv8XDJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8fwBvBOunO74aYG4aqh99/XjjPwFB1pzu+i7/+uHV4c=;
 b=BZQNzbOJ9scG+JtQ0rQlsC5AoG+GvqnlZQeq/omvu7bj3mTCCWfs8oCGZ8dnvryicFnEiLOywRtBDdsFpjmvUmDp7Wm6v5iiZBHidkMfmgr9F916mYUY4TEhwFjKgIgmHMHV9yVwEfcNt1N8Kf+LRx8dnl1Dl5lqcpZ1EdcUYjEqBn70TmvzWH1GYCe/0A9qMbX67x9knJpwfaOZvyYoBFC5pTc3Mhcmlf6/gKx6oaB9YnkCJfdr0dapublqLzIndanVjAkdJH4QC4wJTkx1ycRuDblyE1FwczlP35ei+QsnRH/jtDvg5E/oF9eTeNrqplTemcrSLdXQyZ79W7X37w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8fwBvBOunO74aYG4aqh99/XjjPwFB1pzu+i7/+uHV4c=;
 b=e0COTkXfoJ0ihgTgMgi3ZEAxmAjcH8n5CMfOfq9qUJmEaA9NsdiHPkQIQFN37SmogZHiT02GBRUBVlMScZzV90E/z6sgNq0bw1v8RwxqJFguHP7F2ndrIEGNoThE998H4qItTADOcl3IWTPl65eHvje23Ds5JRUsdUmHCxvto74=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH2PR12MB4262.namprd12.prod.outlook.com (2603:10b6:610:af::8)
 by MW4PR12MB6731.namprd12.prod.outlook.com (2603:10b6:303:1eb::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.21; Fri, 11 Apr
 2025 10:34:35 +0000
Received: from CH2PR12MB4262.namprd12.prod.outlook.com
 ([fe80::3bdb:bf3d:8bde:7870]) by CH2PR12MB4262.namprd12.prod.outlook.com
 ([fe80::3bdb:bf3d:8bde:7870%4]) with mapi id 15.20.8606.033; Fri, 11 Apr 2025
 10:34:34 +0000
Content-Type: multipart/mixed; boundary="------------OVYlF9jM5tTe8P15h0iKc6jU"
Message-ID: <92f78d33-e80a-4c8e-aa16-e5988bd69713@amd.com>
Date: Fri, 11 Apr 2025 16:04:14 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 3/9] KVM: guest_memfd: Allow host to map guest_memfd()
 pages
To: Ackerley Tng <ackerleytng@google.com>, Fuad Tabba <tabba@google.com>,
 kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk,
 brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
 xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com,
 jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com,
 isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz,
 vannapurve@google.com, mail@maciej.szmigiero.name, david@redhat.com,
 michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com,
 isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com,
 suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com,
 quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com,
 quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com,
 quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com,
 james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev,
 maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com,
 roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com,
 rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com, peterx@redhat.com
References: <20250318161823.4005529-1-tabba@google.com>
 <20250318161823.4005529-4-tabba@google.com>
 <aeed695d-043d-45f6-99f3-e41f4a698963@amd.com>
 <diqzr022twsw.fsf@ackerleytng-ctop.c.googlers.com>
 <d5942725-2789-4626-bee1-81d69ed794f8@amd.com>
 <diqzzfgn4oxy.fsf@ackerleytng-ctop.c.googlers.com>
Content-Language: en-US
From: Shivank Garg <shivankg@amd.com>
In-Reply-To: <diqzzfgn4oxy.fsf@ackerleytng-ctop.c.googlers.com>
X-ClientProxiedBy: BM1PR01CA0157.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:68::27) To CH2PR12MB4262.namprd12.prod.outlook.com
 (2603:10b6:610:af::8)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR12MB4262:EE_|MW4PR12MB6731:EE_
X-MS-Office365-Filtering-Correlation-Id: 061fea2c-cb4f-47fa-78ec-08dd78e47378
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|4053099003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UDNYYmpQOU1vRGQ2M1daZnByRytZVllGY0ZxQmZVUk00NS9wTG16Sm5qblU3?=
 =?utf-8?B?cjVuSFlpcXJyTzJBcmdXODVyM0d1b2krS3V6QjJMUG9WQ3JNbTA2WlRsTVN0?=
 =?utf-8?B?WTB5cklBa3ZDT3EyY0wzK2EzTCtjd3JJb3VYTllWYnRzbW9EZEJKQ2xrQ0or?=
 =?utf-8?B?aktkTEU5VFNrWDBSOFBpQWxZVHRZVkRDT202eVMzWFBqanpFNTVXbHlkVVJi?=
 =?utf-8?B?a2VOUkpzUS81RGNwV0RHV3NtdHNjbStTRkRxaU5Eb2VURTZjM3pmdDVHQVVz?=
 =?utf-8?B?UDNvMzVrU3BRellFbXVsNW1zeXlSdUdsZmdmMUNzamdIKzkyNEo2eVhkSzdH?=
 =?utf-8?B?QWRQVDQzOUl6QlEwM1gwQk93NTdjTExZYXIwWjIvOGJ6Tk5zSE1waCt6ZjM4?=
 =?utf-8?B?QldBRDhwK2FHZmhxWnFYSEZzUk4rMEhtWFkvWGtLMlQ4TVBYeXdZOXJJMjFm?=
 =?utf-8?B?ZHNiSkgzeCtZelR3emxza0plN2U1L1BpWkxBbk1RZ0xBMEpnV3I4ajJFV21u?=
 =?utf-8?B?c2tmdTlFaEl3Y2ZKMGVGM3drUEExdjZaQWk5Y1hlNU92VmNSM3o5VFF6Rzdn?=
 =?utf-8?B?Ri80azNHOWhXamYvWWpXSkU5aWJPZmlZTVh0MzFWcTZHWFAvTHJkK1hwVVdP?=
 =?utf-8?B?anRtMGRKNDMxdjFKSWR6eWMwM0ZOSFZKajA3VlkwTm5FeFBMaUwxWjMveU9N?=
 =?utf-8?B?blpkSERGZytiekhCWURTQzQrQUdvdkJZV3Jtb1ZySmlMNUZTSGlWNFpYSWFO?=
 =?utf-8?B?amw1R3JPT0MwU1pSdzhCblp2bURuWHFoLzM2VkR5TGprL21JeTg3Umkxa2pv?=
 =?utf-8?B?THlmVWkzd0RpRXdFRFhla21zZUwrcDRSZ240clFhMGdzTDQrYzltVi9sL252?=
 =?utf-8?B?K0srYytwODFjZ3o4ZFg2eTNTL1ZoeHd6WnNyS2pqbHNRd3FhSDZ6VktnRXdI?=
 =?utf-8?B?Z2w2ZUFCbVN6MUZCb01jdmdaMldSZUhOSUUzcXBJUTFJN3Z3NC9Ic21kNWlV?=
 =?utf-8?B?cmRBZ0k0TUNnQmNxU1BsMXFoTnBjRzlpemJuQUNBcy9mUnNyQ1gxR2p4SE12?=
 =?utf-8?B?MkJrWERzcm9ZdDRBTWZpSUZncnZCdVVUZlYwZVB2cThoTzNvWlhZU0hGNWVn?=
 =?utf-8?B?TmdNZ3g0cWNpcTNKdTdWSjh1NStWN0FyalNiT0hMaWhFZjZ1SXVGSVlmY3FN?=
 =?utf-8?B?VjluZkorK2lVeTR0NDhYcHM3U05XNHYyUFFTZVVLYTZUL2xsOG1GdEx2bmRk?=
 =?utf-8?B?UDRlNEFxaDd1NWtMc014L3JwMXhWcEJUWTNJcXI1STJhbVloU3k0c1lSckFV?=
 =?utf-8?B?L1JYdTBmSDcvTmJWT0ZjL25WUmdST2hQc1pkTkI3QldvT2VPU2tLRCtxY0Qx?=
 =?utf-8?B?UzRxazk3a0JUSDA1Sk8rNXZoSXU1anFXOWkwOXpTdDljaXFuZUJRTWNpbmda?=
 =?utf-8?B?bUdhWWtiRlR6MWtkeWFxNlFwOXJFOXpuODNDUTkzVzB4NlRMamlKM0VFSlZ6?=
 =?utf-8?B?RVRRdE5KcC96TFB0QVk3RXJBM0krWmZYNmRDdjdpaGJaWVNTK1RPQzI2eW80?=
 =?utf-8?B?QXkzem5SVTY0dzBrR09MQUF5SVBoRDE4WDdLSVJLellIUWQwSU9nVG9POExT?=
 =?utf-8?B?NUh0RHcybnAvWTdtVVY0L1h2c3ZHdjFCUGVuaXdlN2x2N3lNTmFGS1h3MVhQ?=
 =?utf-8?B?alBEdTQyeWxvUGp1VUpXQWhKb0RCbkMvT3lnSTZlbG0yd3NkMmZrQ2JHVi8x?=
 =?utf-8?B?OVFVTEJDSzdlVlF0c0xlMDRqL1NrL3ovbU9QRGhYSWJoQUZDZHAyNUdtUGdO?=
 =?utf-8?B?K0RNdWNMOXFGK3pPMmpvSnlvT2FEYWwxWjJ4MWdNdzc0dUk0Z1pxNEg4dzZY?=
 =?utf-8?B?Rm0zeWkzZWdadTkvM0dWS1psbFg4WEQwQW5jL0NyUm9zN1c5NnI0MndmbXY3?=
 =?utf-8?Q?FCEz40/zovU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB4262.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(4053099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SjBPdE9ZTDdUSk1CWWlSNFBNNlpwdXl0cU5idCtoMFBJUW9XQWpVcGhnMW5N?=
 =?utf-8?B?d2xtUm9MbHRPMXV5SUhmdXhQSVA1ejcwUVlFTXY3dnlCVVdWT05xVGVXaGho?=
 =?utf-8?B?NGw2L29xaE1hZlpSTExxQy9TMENJUitYdlpNWU1ScElDeFd1dVBMZGNYNXpS?=
 =?utf-8?B?eDFuN2lSTXdocWVBMkhJQVVYd0t4UHZzWC9BUHB2MnZxS3NnM3k5bllYYllq?=
 =?utf-8?B?bjJFc3lVYms0b0F6cjltUXB5MjBWWmZPUjh1WHR0S1k1NUlTNDkwdUMvZmNL?=
 =?utf-8?B?Z2NOYURDK1dsditRdTk5T25sZ0JzbHZhUmJCZmVCV3E2a2ZHbHlqTXRkTmJv?=
 =?utf-8?B?M1JBQkNFWFE1RXVTWFl1VWJrSUpYWDYrZTFmTmxISnFOQjFsRXBwakUzTlpM?=
 =?utf-8?B?Y2FvSk5GOTlFMjJZSUpjODl4U05aUUpSMzM5UU96YXRDc0ZRc05wbGxDbFRR?=
 =?utf-8?B?LzFyMHM5elhUZ1lZNFZkeS9nalZMV3d2TW1hczc5SzRWZnpYcTRIT1hyV2dX?=
 =?utf-8?B?WUZVekhYQW4rbTZ5VFIzbFl1QlZoMzRNTHhJc1Y4cnNIcFB2K0xpdnZ5bHNG?=
 =?utf-8?B?YTVjelZuMEFLS21GYVNZZDdTcEZIdkxMNmp1dzVPTllPeFk1K0hwOXdubjFR?=
 =?utf-8?B?K0dIMFplWlJoaDdmU1RJVWZpUEJtYWV0Z05HZGR5NlQ1WkljUTFQSlV0VWZI?=
 =?utf-8?B?OEJkRjR6ZUlRaUFjUnVRZEVXMVAzY0xFNGtpL2p3NVRsb2gzVnpoaEZLV3ND?=
 =?utf-8?B?RHpPd1Fwai9FTTlDRDVSRzBaL3puT0NXY3JNUmp1aDhSb2VhcHJmbkFNRWNq?=
 =?utf-8?B?UStSdnErT0ZITlU5RUt5MUN4d2ZhenpLOE1BT1VVQW5NaS8rcE0rRjBnY1ZI?=
 =?utf-8?B?WUVKS0JkMUFkQzVYbmVLMW9SZDdoeHZHcWxPOTQ3NG14aDZlWGJpelFvTEda?=
 =?utf-8?B?dTI4RVU4dCtXdTVXWlhFUU54TUNabkM0YjFEenYyd2lzVllYRHZQRVN1WkRp?=
 =?utf-8?B?Q1JYcndvTEttYlNnbll6M2g1NUtCY295MnNUSGltakZqTVRPLzJ2bzV2RE15?=
 =?utf-8?B?Zi91ZTEvRVQzMWhkWkFjaEpEZ2VwY0lKU3NGQnIzVWhNbi93MWlUeG9nS2Zh?=
 =?utf-8?B?ZXp2UlBHQTFZcVMyWVF3dmpOVFo1ODRRVXZKa01MVGN4TG9HWlpFSEpIWXBq?=
 =?utf-8?B?Q1lBSWMxdEZEL3Z5UU5TM2pkaDhnYXhkMmVkRzA0aloxcFc2UjBKWlZyOGtu?=
 =?utf-8?B?VnZ0V1R6am9KK3hhTmxSTnVjay9oTkhzUXlPMm9jbDN5WVdyMm5ZV1FFWlV3?=
 =?utf-8?B?ajV6dENCaUJ3MU9GcUs4MTljY2xoZVJ0Rml3WEVaQ29hazNCSjBUdktBVkla?=
 =?utf-8?B?Y3pDeXhFV3dkSTlyWllpQkw2aVFaNnVNMUVvYllCUSsyMXdhNVFteklFQ3RO?=
 =?utf-8?B?NjRVTWZRcW5MK1ZRVFI2OVZ0L242bnFoblZCRXdMSmd1NHlzekZjNjM1bFQ2?=
 =?utf-8?B?WWMwL1FobVY1bjBIcnRXYmY0SjFLcUVpekcycWVvYkhuMjBQaDEzNCs5Um91?=
 =?utf-8?B?VzEvLzJ2c29WbzhHb3ROVEl5MWRad0UwbWV0Ky9XZFgyZFRpS3NBMFJWUzJN?=
 =?utf-8?B?OC9sWmp5YlZJTUxZVzh3UnEyR2xIa1ZFSDY1T0RjcXBIWUVwVjY1UVdaNkha?=
 =?utf-8?B?cU5kM2E0S0pVYURTK3UrS2xpeTd6UUR0V1E1VGRpRVNVNU1KOWc1WmM2c2py?=
 =?utf-8?B?K01qRGRqUk02T2JrcjlMR0IxYktRc2Q5RXVoTXNhOWJQYVJaVnFYWGdtOGUv?=
 =?utf-8?B?Y0ZKNGwxcGJIKzNWZ1dsRWpNdzVndVNmNTRyU2d3WURlT3VpZ1VEVjdJK2Qv?=
 =?utf-8?B?T2pWM3dJRFRYVW9BTTFVcGtsWUVEbU9wUldaMjVJdTl2K1dKUzN0cEdiRDVp?=
 =?utf-8?B?SXBqUTJiOXdXWGtSVlEwbUNVS05RU2lxNGEwc0ZPUDJtNUdHVWZjVXlXT29K?=
 =?utf-8?B?VUZCek13cFVFR2Q1N2hFcm0wZWN0UVRWZTk4MDJNYmlHdEIyRkhDTUJBcEVu?=
 =?utf-8?B?bTBQbGx6d21yb1RFVU9xcGxtTTdVbE9MZGhEYzl4U2FSOXArV1hDdi9EYmh6?=
 =?utf-8?Q?H5ccNbSpAKUusqMxsfm44fAfe?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 061fea2c-cb4f-47fa-78ec-08dd78e47378
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4262.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2025 10:34:34.6689
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cIBop+H+7xMB7y42jcWdG+XnMRQFWcnl8KRD7+d4BKqUDXLbIRGYE/3jbvj82qBqWKb/DMtaZpOEHPTto/R9XA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6731

--------------OVYlF9jM5tTe8P15h0iKc6jU
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 4/11/2025 4:14 AM, Ackerley Tng wrote:
> Shivank Garg <shivankg@amd.com> writes:
> 
>> On 4/8/2025 10:28 PM, Ackerley Tng wrote:
>>> Shivank Garg <shivankg@amd.com> writes:
>>>
>>>> Hi Fuad,
>>>>
>>>> On 3/18/2025 9:48 PM, Fuad Tabba wrote:
>>>>> Add support for mmap() and fault() for guest_memfd backed memory
>>>>> in the host for VMs that support in-place conversion between
>>>>> shared and private. To that end, this patch adds the ability to
>>>>> check whether the VM type supports in-place conversion, and only
>>>>> allows mapping its memory if that's the case.
>>>>>
>>>>> Also add the KVM capability KVM_CAP_GMEM_SHARED_MEM, which
>>>>> indicates that the VM supports shared memory in guest_memfd, or
>>>>> that the host can create VMs that support shared memory.
>>>>> Supporting shared memory implies that memory can be mapped when
>>>>> shared with the host.
>>>>>
>>>>> This is controlled by the KVM_GMEM_SHARED_MEM configuration
>>>>> option.
>>>>>
>>>>> Signed-off-by: Fuad Tabba <tabba@google.com>
>>>>
>>>> ...
>>>> ...
>>>>> +
>>>>> +static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
>>>>> +{
>>>>> +	struct kvm_gmem *gmem = file->private_data;
>>>>> +
>>>>> +	if (!kvm_arch_gmem_supports_shared_mem(gmem->kvm))
>>>>> +		return -ENODEV;
>>>>> +
>>>>> +	if ((vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) !=
>>>>> +	    (VM_SHARED | VM_MAYSHARE)) {
>>>>> +		return -EINVAL;
>>>>> +	}
>>>>> +
>>>>> +	file_accessed(file);
>>>>
>>>> As it is not directly visible to userspace, do we need to update the
>>>> file's access time via file_accessed()?
>>>>
>>>
>>> Could you explain a little more about this being directly visible to
>>> userspace?
>>>
>>> IIUC generic_fillattr(), which guest_memfd uses, will fill stat->atime
>>> from the inode's atime. file_accessed() will update atime and so this
>>> should be userspace accessible. (Unless I missed something along the way
>>> that blocks the update)
>>>
>>
>> By visibility to userspace, I meant that guest_memfd is in-memory and not
>> directly exposed to users as a traditional file would be.
> 
> shmem is also in-memory and uses updates atime, so I guess being
> in-memory doesn't mean we shouldn't update atime.
> 
> guest_memfd is not quite traditional, but would the mmap patches Fuad is
> working on now qualify the guest_memfd as more traditional?
> 
>>
>> Yes, theoretically atime is accessible to user, but is it actually useful for
>> guest_memfd, and do users track atime in this context? In my understanding,
>> this might be an unnecessary unless we want to maintain it for VFS consistency.
>>
>> My analysis of the call flow:
>> fstat() -> vfs_fstat() -> vfs_getattr() -> vfs_getattr_nosec() -> kvm_gmem_getattr()
>> I couldn't find any kernel-side consumers of inode's atime or instances where
>> it's being used for any internal purposes.
>>
>> Searching for examples, I found secretmem_mmap() skips file_accessed().
>>
> 
> I guess I'm okay both ways, I don't think I have a use case for reading
> atime, but I assumed VFS consistency is a good thing.

I'm happy to go with whatever maintainers think best for file_accessed().

>>
>> Also as side note, I believe the kvm_gmem_getattr() ops implementation
>> might be unnecessary here.
>> Since kvm_gmem_getattr() is simply calling generic_fillattr() without
>> any special handling, couldn't we just use the default implementation?
>>
>> int vfs_getattr_nosec(const struct path *path, struct kstat *stat,
>>                       u32 request_mask, unsigned int query_flags)
>> {
>> ...
>>         if (inode->i_op->getattr)
>>                 return inode->i_op->getattr(idmap, path, stat,
>>                                             request_mask,
>>                                             query_flags);
>>
>>         generic_fillattr(idmap, request_mask, inode, stat);
>>         return 0;
>> }
> 
> I noticed this too. I agree that we could actually just use
> generic_fillattr() by not specifying ->getattr().

I’ve attached a patch to remove it, letting the VFS default
handle attribute queries. Please let me know if it looks good or
needs tweaks.

--------------OVYlF9jM5tTe8P15h0iKc6jU
Content-Type: text/plain; charset=UTF-8;
 name="0001-KVM-guest_memfd-Remove-redundant-kvm_gmem_getattr.patch"
Content-Disposition: attachment;
 filename*0="0001-KVM-guest_memfd-Remove-redundant-kvm_gmem_getattr.patch"
Content-Transfer-Encoding: base64

RnJvbSBiZjcxM2Y0YjdkOTZkYzkyOTYwZDI0NTM3YjQ4ODU4MmM1NTIxNzIyIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTaGl2YW5rIEdhcmcgPHNoaXZhbmtnQGFtZC5jb20+CkRhdGU6
IEZyaSwgMTEgQXByIDIwMjUgMDg6MDY6MjEgKzAwMDAKU3ViamVjdDogW1BBVENIXSBLVk06IGd1
ZXN0X21lbWZkOiBSZW1vdmUgcmVkdW5kYW50IGt2bV9nbWVtX2dldGF0dHIKCkRyb3Aga3ZtX2dt
ZW1fZ2V0YXR0ciwgd2hpY2ggb25seSBjYWxscyBnZW5lcmljX2ZpbGxhdHRyLCBhbmQKcmVseSBv
biB0aGUgVkZTIGRlZmF1bHQgaW1wbGVtZW50YXRpb24gdG8gc2ltcGxpZnkgdGhlIGNvZGUuCgpT
aWduZWQtb2ZmLWJ5OiBTaGl2YW5rIEdhcmcgPHNoaXZhbmtnQGFtZC5jb20+Ci0tLQogdmlydC9r
dm0vZ3Vlc3RfbWVtZmQuYyB8IDExIC0tLS0tLS0tLS0tCiAxIGZpbGUgY2hhbmdlZCwgMTEgZGVs
ZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvdmlydC9rdm0vZ3Vlc3RfbWVtZmQuYyBiL3ZpcnQva3Zt
L2d1ZXN0X21lbWZkLmMKaW5kZXggYjJhYTZiZjI0ZDNhLi43ZDg1Y2MzM2MwYmIgMTAwNjQ0Ci0t
LSBhL3ZpcnQva3ZtL2d1ZXN0X21lbWZkLmMKKysrIGIvdmlydC9rdm0vZ3Vlc3RfbWVtZmQuYwpA
QCAtMzgyLDIzICszODIsMTIgQEAgc3RhdGljIGNvbnN0IHN0cnVjdCBhZGRyZXNzX3NwYWNlX29w
ZXJhdGlvbnMga3ZtX2dtZW1fYW9wcyA9IHsKICNlbmRpZgogfTsKIAotc3RhdGljIGludCBrdm1f
Z21lbV9nZXRhdHRyKHN0cnVjdCBtbnRfaWRtYXAgKmlkbWFwLCBjb25zdCBzdHJ1Y3QgcGF0aCAq
cGF0aCwKLQkJCSAgICBzdHJ1Y3Qga3N0YXQgKnN0YXQsIHUzMiByZXF1ZXN0X21hc2ssCi0JCQkg
ICAgdW5zaWduZWQgaW50IHF1ZXJ5X2ZsYWdzKQotewotCXN0cnVjdCBpbm9kZSAqaW5vZGUgPSBw
YXRoLT5kZW50cnktPmRfaW5vZGU7Ci0KLQlnZW5lcmljX2ZpbGxhdHRyKGlkbWFwLCByZXF1ZXN0
X21hc2ssIGlub2RlLCBzdGF0KTsKLQlyZXR1cm4gMDsKLX0KLQogc3RhdGljIGludCBrdm1fZ21l
bV9zZXRhdHRyKHN0cnVjdCBtbnRfaWRtYXAgKmlkbWFwLCBzdHJ1Y3QgZGVudHJ5ICpkZW50cnks
CiAJCQkgICAgc3RydWN0IGlhdHRyICphdHRyKQogewogCXJldHVybiAtRUlOVkFMOwogfQogc3Rh
dGljIGNvbnN0IHN0cnVjdCBpbm9kZV9vcGVyYXRpb25zIGt2bV9nbWVtX2lvcHMgPSB7Ci0JLmdl
dGF0dHIJPSBrdm1fZ21lbV9nZXRhdHRyLAogCS5zZXRhdHRyCT0ga3ZtX2dtZW1fc2V0YXR0ciwK
IH07CiAKLS0gCjIuMzQuMQoK

--------------OVYlF9jM5tTe8P15h0iKc6jU--

