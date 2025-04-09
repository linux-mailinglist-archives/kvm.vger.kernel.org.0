Return-Path: <kvm+bounces-42987-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D96E2A81D2C
	for <lists+kvm@lfdr.de>; Wed,  9 Apr 2025 08:38:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7AFB83B6A9F
	for <lists+kvm@lfdr.de>; Wed,  9 Apr 2025 06:38:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D28F91DEFE7;
	Wed,  9 Apr 2025 06:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b="n4WjGcmi"
X-Original-To: kvm@vger.kernel.org
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11022139.outbound.protection.outlook.com [40.93.200.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BE581990CD
	for <kvm@vger.kernel.org>; Wed,  9 Apr 2025 06:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.200.139
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744180717; cv=fail; b=aMesgr/TywtrgOnXlVMedrdeoCnxuT3O3TiVF2+RyPeTWVE36k/VjnH4buRRid3gNHLHIbwoLplimCZ5jGsvq8PAcZZQrQLryYju6VSIP7N/YcxZA1tPjGve+Iroca3R67F3UDLnzNuPJSDyR0IN6FKGLKIPMLRuHK1AdfSs26c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744180717; c=relaxed/simple;
	bh=+LNeyPPMAu2K3s6Jnkbq6hxJPOTcEz9Y5j5O7e4GqSE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=B596Q8T79+cjmvUDOMz1vLHGYAdp+PwTei0uYLUBQKV3VcaEqS9WOVOcQ7ryBDLkO3PFrYh6lBf3mH8Nm/ndsuEEEgTCwhR13uU9y6phxORoGLkkO6ClSpDr3tG2eMDaeqhgSg5etDkQn5pAKriwG8f13GdKqbfZVzb4cmBw3oQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com; spf=pass smtp.mailfrom=os.amperecomputing.com; dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b=n4WjGcmi; arc=fail smtp.client-ip=40.93.200.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=os.amperecomputing.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t6bEHmXR4hsKSydf9mMtsLfzD3oJTGRwaakCRHqsDW6IrP0yksFbmTf0+GAKQFq3umSWYJOPbYsrmwZeaY8EEuvWHSQ3Lg6qZ/6Jd/q97M9sNi1GBXJUHht3afkAK/i0DNMtI5W9k7QtxNOECbgO157m1J3oDXsih39W2rlCDGGRbc3c1oGBHYvbsXJRk57rAYLCeh/tza5hHwgVSXINtoWAyYRiRnXSTDUXCyuL06qBatBZ5Wnaulnvs2Zk1BV6TXMuZ49oDv8ssGTJsz0IEBMVLiHUFh8fJDjdO7/rXQo8yGFcC+gFlGMzDkx5j6O5JhFGqULRJau+LXrIGnaiQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qJlH0uCyNdCamX/IUN9/rVRRurzX4p3FPwRZylrB1DA=;
 b=hMnVXvQveVU6SnsCWC/oIFijUnD3p8psAPQIzypfHPu1pPeHFeCbWIiJi8aNJdzdxjAhCv+0rjuzorsuc/wwlkWu/llv2+J1tKDnEsocBOcwrSxodsaAMJ48/zYOf/mlwt3bHElAQRq45DO3xQ0BxGMy/qpVkxBgfxM10B6lQ869UHh2hPUA590woGqRFwodQt8h9mrRmMawV22NHXY5TAqLv+1DayD9JFqPB0mMgywhRTGnozP4DH4D6EmY7+XccHQiDH1o9iwHuW/e5eQOKS7bVS2En/rCvAPCK+wWtPXrMlB+2Nu0W5FwiJytmYDqSyZQoShBhChGu9QSzvG39w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qJlH0uCyNdCamX/IUN9/rVRRurzX4p3FPwRZylrB1DA=;
 b=n4WjGcmiJne8QcmtdT+c20Fv6oCcePLh4vSQN4LbtknUxFjD+YL2GkbtbHPRjwHzf/toUaxsH+ufPuaFpTu3Ttli4H1w/m30Jr6b31u19Vzi7zxA5gnPaM5ADi4b+GuJnLjVUPAE63n3C3oPd6MawBHlhKhs5dMg6Jtnbs00OPk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from SJ2PR01MB8101.prod.exchangelabs.com (2603:10b6:a03:4f6::10) by
 SN4PR01MB7405.prod.exchangelabs.com (2603:10b6:806:1e8::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8583.46; Wed, 9 Apr 2025 06:38:32 +0000
Received: from SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::292:6d9c:eb9a:95c9]) by SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::292:6d9c:eb9a:95c9%4]) with mapi id 15.20.8583.041; Wed, 9 Apr 2025
 06:38:31 +0000
Message-ID: <7ea61a71-27f9-4b2c-8477-c2067c7219f8@os.amperecomputing.com>
Date: Wed, 9 Apr 2025 12:08:24 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 16/17] KVM: arm64: Allow userspace to request
 KVM_ARM_VCPU_EL2*
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Zenghui Yu <yuzenghui@huawei.com>, Eric Auger <eric.auger@redhat.com>
References: <20250408105225.4002637-1-maz@kernel.org>
 <20250408105225.4002637-17-maz@kernel.org>
Content-Language: en-US
From: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
In-Reply-To: <20250408105225.4002637-17-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA0PR01CA0120.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:11d::9) To SJ2PR01MB8101.prod.exchangelabs.com
 (2603:10b6:a03:4f6::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR01MB8101:EE_|SN4PR01MB7405:EE_
X-MS-Office365-Filtering-Correlation-Id: d41f4bb0-a37d-49c6-66f8-08dd773124c7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?b1R1Wi9tY2R2NjBOSFlweU1pbFRNSStTQ1FHOWREN1owajg2UEtjdHJZSXE3?=
 =?utf-8?B?eXF3NkVJNGR1YkQ1R1Z3M09IZ29KMHRoVW9DSXpwQUdwMnk5cE1taVVwSUhM?=
 =?utf-8?B?OGJ4bW5uTVpmUkxzVmt0cE93bTBJRTM4RExnYVZlM0VNQ0ZVRWl2Z3BvM1dy?=
 =?utf-8?B?MkU3Wk9Zdk9hRStqZmRMU3pMbUFKQUpwc3lOSWRxbzNDRHZQbWlTc1FNaTJN?=
 =?utf-8?B?dEpPSHRmZFRmRi9kMmEyNDVBblBVa3hlR095R3VBYVFMaEFmS3ZKQTk0REVL?=
 =?utf-8?B?QVZVQlJvNFpzY29Cc2FnYXYzMDRyZDB5ZGFaeWxPUFlocWZHMDF6aURHUnA0?=
 =?utf-8?B?c0V4WTFCbklwdFVvWjZEeDl5clFlSm5sM1VwZ2pXeUFUd1FVUlI5R3U1WmVz?=
 =?utf-8?B?KzVOdy9iMkhGdzZJQlFRVUtqM0s1QnVPWU5IaDUwekJrR0lpOUlSaFVjWmlY?=
 =?utf-8?B?eFJjN29ObGZJUTdCTFVmOXhmUDRBTlBERklnUXB2TkVBc1lyYUw4c1V3ZEJO?=
 =?utf-8?B?ckx1TGdBYjlMMWh4NXhwbjcreDdZSTl2Rm8ybzZZVGg2N0ZadUNpWE45My84?=
 =?utf-8?B?SHJDMzNZbFhtR0FUZmtENVNEdDNFRzdZSC9hOE9Va0ZEemlnOEFiOTcxQSs2?=
 =?utf-8?B?cG03dHlYbHlNZitjdTR4SkVUbld4RzJVbFo2MSsvTjZzblVUMEJLazNxK1E5?=
 =?utf-8?B?WFV6dVBlQjNMcnFCYWkvU0hOalpwZVNPdXBXM2MxdTlUeHdTaUNWRW5vbG40?=
 =?utf-8?B?bExuaWpFU2szNnB3UVJha3JlZHJsRzB2aGFSTUlEM1ZlbW03bStXUkRneThW?=
 =?utf-8?B?R1c0Ym1rNzRpZmc4N1k2dGlDc2ZmU3dLekNuU3VHejVBUWxjVytXK2U4QTVm?=
 =?utf-8?B?NnNFblBPeXNPTnZzc3pyY0ZYZWxDMEFjMEN1MnpxSkphYUMyTUNuVUJMZktw?=
 =?utf-8?B?ZGxmY2p1RkJ6ZXZVM2h6WEloZUdXWHFOdmsweEQ5NUZ2NGhFM3dON2tsbVdQ?=
 =?utf-8?B?ODI0cG9tWkhYeENCZ2VJZDQ2MWplRjlIalpIVk1RdDdKWmFYSFp3UlpaME05?=
 =?utf-8?B?RVhKeXdKdkZTUHV1ZFpNNWY4TUN1UXJiUDY4RGdpbW5MU1FEL1QyMUhZZDNJ?=
 =?utf-8?B?TEtZcGkrVUhKbEFkVEt1aGs2ejRDN1pRY3JFTktORkVHYkxPdy92NDFIZktW?=
 =?utf-8?B?U1RlS1hKYnZ6TTdRUkdiSmduY3FqREpPK3FvUlFZRmU3Lzl6N0tTdDBPcERT?=
 =?utf-8?B?WVNYOVJVRmU2bTBidHNRdExFbEpBbnJEWmd2NDNHUERvemluc0dhNlZmaldG?=
 =?utf-8?B?STE0b3UvZUhhcDh5OUVKMFZRZFQ0Sm5zN3hPcGlLdnE3bWYxUy9hT0JHWUw0?=
 =?utf-8?B?b002NFdBVXVvU1pnRjJtZDZhc0xPQktjcXl4c1RUaW9waVozNjgzRWlEWi80?=
 =?utf-8?B?SFNEcmNCbzV4bFVLVnlTOUZQcHlhenplSkZ5bmo3SVRIOUpHMmFuREQrWXZY?=
 =?utf-8?B?a2pzVTlSTHY2VnQ2TDYrL1NHSDF3SlVhNksyOEd4dTMwTlhGV1piUlJVNS8x?=
 =?utf-8?B?dXVvM0Zvb252YjhjZUdTcFhrQStDaWNRMGF0dFlGeFdvc3J1NnQ0RzNpSlAv?=
 =?utf-8?B?UkFaMCtiWTZFVXV0U0t6RDFycVhYcmxEMU51Wlg0clVIdjdYbVRvSjJNWHRB?=
 =?utf-8?B?SjNCRmx3TXlKZlpjT1lRRHNzVVNrZVViQjFBQUd6MTZSY2dFK3pVSUhuQ0pU?=
 =?utf-8?B?V004bWk4Vk5iUWdnNHVVMWFTOTRCQXh6ZE5nZWozT0w2U2JIZzhPOGVhUkhw?=
 =?utf-8?B?bndIR2VBNEs2M294WGRlUlhoSkErcHA5cUQrVm0rNnpLTnF1SllVNjlRZ0Y1?=
 =?utf-8?Q?nJE9HZTI3+hHN?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR01MB8101.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MDJzTU1mQ2oyMTlObm5VZ0RQYVV1bkwyMC8ybWZJMlp5MFc0am13WktYWnhH?=
 =?utf-8?B?bHkzVUw5L1NRWDFEd0pvMDNjaDZ5eisyaXJHejVjSUNVZmw0TGI0VHRnMWVs?=
 =?utf-8?B?NWdhODFlcnJ3REowTUgzRkF0Z0dZNlVWeTVtMGdmbXN5NnRBMnUwK052OGlE?=
 =?utf-8?B?N3QrYWxrWXhBOWN5SFg1V1htR1BrYUlzalY4Vmg0N2UwLzlGOUdub2NxRW1j?=
 =?utf-8?B?a3MzeE02Vkl2QnMyaGx6Y2ZqbmlpUW1sSmlWZGt4Sm81OVNrRkJhMTA1ZEZh?=
 =?utf-8?B?OUxCL1BSR2dpQXBDK0xNRXQ1cUxxSCt1VUhqSWJSMHhXVWYyelROYUtkRDJs?=
 =?utf-8?B?dGtYSExjUmhGQzZXb3pxYVZZK0s0Q2QyYjUwNWtlM2doeFI5Y1JBNGJGVWx2?=
 =?utf-8?B?ME5qUU05WUxRZWdYbStXNUhZZnF4VVpwMUdVd0pmdWlTcFFnUVF5eDY1ekcr?=
 =?utf-8?B?aURjWE9OYno5Uk9VNzFBOXZ3bGtaUDJPMUkzbVZCZ2xUWEZaRnRWRUtpTWRQ?=
 =?utf-8?B?T050Q3B4QW96ZXVtc0FLd28rVWtucVhhb3JVZDNoOFBrQ1hrcWlibTJRQWtM?=
 =?utf-8?B?Zm5vVlZqOHZQNElpaHliNzFzZWgzS1FVL01yWUl0N2dqcDJjVGNNSzU4UnVj?=
 =?utf-8?B?NVlFZFFkeTNVSWFZSFJ4YWJXU3lWZWllMXZDUllhWGdzSlh1MWlWYVIvM3hM?=
 =?utf-8?B?dk5TVDJMU0NOdGZldDJMeDExUk5UanRsME8rWFBxQ0trZE9KYldES3FORG5k?=
 =?utf-8?B?MWdmSGs0d1VRSVZSaGsyNmZiSVJabnQwQVZ1L2pXQnE1Y0tBd3hQamJZc1lG?=
 =?utf-8?B?dEFQT2NjUjhMV2pXMjlQcEkwbkpsMHp3aGwxVnJxSEZNWEtVcWtNUXBrNUlp?=
 =?utf-8?B?Z25pSEdLUGtXNnFpS1RxR0Z1K2V1SEN2TDE4a1FnTDhCakg4TG5EeXRpZXZB?=
 =?utf-8?B?VmEyRDJwR1B1OVNKVnYyNHorWHl0Z0IzZ2ZZNitZellOMDBjT0pXQ2pwREFj?=
 =?utf-8?B?dHlQVnpDVHhRVGlHbnpGT1JBL0QyRHcwZDZxT20rUGZKT3gzZi9qQm56MThn?=
 =?utf-8?B?WkF3TXVuQ3dPVEVJWUZzbmxTODh4amxoRHJnY0lBbnJsM1Q2S0J6bUtQb3JM?=
 =?utf-8?B?ZWNmUWRJNUs1QnROQ3RzRGhjYi9JWk53cjR2a1pEc0JRWGVjckNLZXFnMEdP?=
 =?utf-8?B?RGJCRFZSQWFGWk4vck9aK1VxTzhkS0piNzE3ZkFoeDA4Y3BOR1hNSVM0ODdy?=
 =?utf-8?B?RWVCRnhLQkUzaU0wbWFxakhOVVV4dTRLeUtQNjl0SnU0WXgrbGQva0VOdzZC?=
 =?utf-8?B?cDRHenZ5dGFLNlp1cWFkT2lSNzdLRnBxSFh0eXlNa3JrcExWV3NPUmRXSGRB?=
 =?utf-8?B?VmZudDlBY25vZVVvTG43N0xIRUZIUVZrdmNpY0hKTldOMHRwV2hJSytSQ0pH?=
 =?utf-8?B?RGNuS3NKSkNVaHJTcnFNTkF6UEFGL29KdERyMkVWNDNERXA0Rlh5QXc3cU1G?=
 =?utf-8?B?NCt0b3FUaVR5WE4wNEVRaVZvTTlNaFliZlRqclhodDV4SXpKNjY5Kys3UTlT?=
 =?utf-8?B?MEVnbWhtRlpzS0NKQ3JaRHRXNGs5ZnpKeVB1am5GYTNDM0hpR3JDTkdHb0Z5?=
 =?utf-8?B?MDh6czBQOXZjRWM0UmRVSlBha0NHMVZnN1hmQjR0Z3EwUExMTmFPbG0rdTVE?=
 =?utf-8?B?THNEd2FZZGFMQlpDWXZXdFo2aWpBbG50eVBTeXI0UUk4YWVua1huSUtHdTN4?=
 =?utf-8?B?SlBHME1rNHBER2s2Z3RYL0Nna2E3dE5jd1ZmSkxaTU15M1J4MlA3UHUxYmdz?=
 =?utf-8?B?bUhnVGxGSkJEekxUWkkrOENLVVpMZ29oamFBdncyNWZWWmxyZ3pzeWxZMk5S?=
 =?utf-8?B?SXZySDBTVzFCc2txeGJxNm5QVytMcEYzbUx3MkYyODlUS0FobWJxNjh1SDZr?=
 =?utf-8?B?NHUzR1lZQlVBa1JmZFh1V2MwRXdibldyK2l0Wk5XK25DZFlMSEttV3d2QTdY?=
 =?utf-8?B?MlAxaVZlTXpBR3hUcmc4TmNXc1FYK1cyS3RiM21Tc2dRVDB6Sm5VdDRCK3Zy?=
 =?utf-8?B?RmxJbHVMbFg1TTJiZFNwUFNsT2xBbmhuWnRpWnJmWEdmQXpPRStMY3Zreno0?=
 =?utf-8?B?SlBIbDJXV29OK0Nvc2IvY0lMUjBiYTg0bktncEc2VlN3WXZZVWpDUWlEamF5?=
 =?utf-8?Q?f4QfCEaxQWwdEf9Up/ZMUcZUxba1jlnN3LuEUoTCwoEN?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d41f4bb0-a37d-49c6-66f8-08dd773124c7
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR01MB8101.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2025 06:38:31.3983
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rUdsFMRlNOdV8x1sQPYXMDLFcimS+ZALEj4U34TL3U6QTa3Wz2R9eWdqIScrPEI7a88WeX4UzE8uGTYP8VhQW4eiX3x4HAQch4WKk9a30cbLx3HAlrBk7FvQyVTzmw1z
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR01MB7405


Hi Marc,

On 08-04-2025 04:22 pm, Marc Zyngier wrote:
> Since we're (almost) feature complete, let's allow userspace to
> request KVM_ARM_VCPU_EL2* by bumping KVM_VCPU_MAX_FEATURES up.
> 
> We also now advertise the features to userspace with new capabilities.
> 
> It's going to be great...
> 
> Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
> Reviewed-by: Joey Gouly <joey.gouly@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>   arch/arm64/include/asm/kvm_host.h | 2 +-
>   arch/arm64/kvm/arm.c              | 6 ++++++
>   include/uapi/linux/kvm.h          | 2 ++
>   3 files changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index b2c535036a06b..79e175a16d356 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -39,7 +39,7 @@
>   
>   #define KVM_MAX_VCPUS VGIC_V3_MAX_CPUS
>   
> -#define KVM_VCPU_MAX_FEATURES 7
> +#define KVM_VCPU_MAX_FEATURES 9
>   #define KVM_VCPU_VALID_FEATURES	(BIT(KVM_VCPU_MAX_FEATURES) - 1)
>   
>   #define KVM_REQ_SLEEP \
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 5287435873609..b021ce1e42c5c 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -368,6 +368,12 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>   	case KVM_CAP_ARM_EL1_32BIT:
>   		r = cpus_have_final_cap(ARM64_HAS_32BIT_EL1);
>   		break;
> +	case KVM_CAP_ARM_EL2:
> +		r = cpus_have_final_cap(ARM64_HAS_NESTED_VIRT);
> +		break;
> +	case KVM_CAP_ARM_EL2_E2H0:
> +		r = cpus_have_final_cap(ARM64_HAS_HCR_NV1);
> +		break;
>   	case KVM_CAP_GUEST_DEBUG_HW_BPS:
>   		r = get_num_brps();
>   		break;
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index b6ae8ad8934b5..c9d4a908976e8 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -930,6 +930,8 @@ struct kvm_enable_cap {
>   #define KVM_CAP_X86_APIC_BUS_CYCLES_NS 237
>   #define KVM_CAP_X86_GUEST_MODE 238
>   #define KVM_CAP_ARM_WRITABLE_IMP_ID_REGS 239
> +#define KVM_CAP_ARM_EL2 240
> +#define KVM_CAP_ARM_EL2_E2H0 241
>   
>   struct kvm_irq_routing_irqchip {
>   	__u32 irqchip;

After applying PATCH 16/17 (this patch) and PATCH 2/17 on top of
6.15-rc1, I could boot L1 then L2.
Glad to see that the majority of NV patches are merged upstream!!.

Please feel free to add,
Reviewed-by: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>

-- 
Thanks,
Ganapat/GK


