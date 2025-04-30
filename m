Return-Path: <kvm+bounces-44848-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 09E4CAA4288
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 07:39:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BE8FB7B2B9A
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 05:38:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC4781E1E01;
	Wed, 30 Apr 2025 05:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b="ab2l7rjP"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2126.outbound.protection.outlook.com [40.107.220.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 517312E401
	for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 05:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.126
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745991540; cv=fail; b=CBDparWmOfLPPs8ntUR+lSB5w8zI5qquedWh5K/eIf4aDFDHvw1fEPgHv8oPUIl35UfxF4IcJpyGc6Rn6aE9k5YMGoAY4dbyOyjJ3N75sXY0gPRHj6MuFc1/idgiT7ESv1fjXn/GFSap7ZlUEfNRdrkoLEU80UjhXlEqNgRO3K0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745991540; c=relaxed/simple;
	bh=A1mQ0aIpuPY+JBRh8Ajr5rvoYrgijRgx8KSRWWgrApU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=aXz70KegcsIIvjlUAX3SDVFGC+PkIGk3bMuESY0mNqYjvzIGDV4QGecgdh3X3xegZSZvR93/ttjS0PQ2D+QscByDJuXwf4i+oVLSh788GoXSDmVuQG3sKb23Oabxj25y5uzlhvZalkoh4pyr04ThxknoU+wgIxt/jtz6+K/JuJ0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com; spf=pass smtp.mailfrom=os.amperecomputing.com; dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b=ab2l7rjP; arc=fail smtp.client-ip=40.107.220.126
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=os.amperecomputing.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pbWF16cXyXLExAGYzNmz4CYTRojroIEIEYZ/cDekmQ/YiCQb0qMy//CTsbMbhcDAis1UcYWmfqPfsheAy+gYEpadsc4L4I9Wj/iHomwdTtJt/ib6Q9Yh1hfT4ai71ZP5NennzGsXJYzwFORElRPh0V2kvMOv9d44I/WMmcH+zUeN2FcWCAj7SIFwiF1GEJXdBUSQWMjYZyM3nbopyLqt6AxUqdIAvEa0FwvpnB3mPKrENIJkmmfXq7YxGawLdwJr/t2S+rBg2dWWnhTWk9tWs8XTwF/FKfEFf4UpSB54Rg0W8Nv24Ii8H0oVdBnunn0j7+lxuVnph3AxcFFQiLiy4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SmGKTT6kuCq56DCvEp6REMh8SfTyQQiX73QMoBnL7D0=;
 b=gh9F1Zr9U4WokvZtGbpfoVFNVTf57RsqNEzpBTpOzthOsXQ9JZ1DQJT+4iIV4MFeVRdfkIz9oKVRO/KuhM89DCwbVv0E5Y37R+bDB3NBMtJNyuh+/YrKDNh+IqzO9Z2ApFF74uXk+QzgbRFzpWDA6pjobVuFQ8fjN8qtcgnuabxTU9tvFgu08659S/22/EY/d3qyt+SyKGdwMllnGI3BHW/jlrPXAFTGorYHbozTeDi7AobijucvnbdRiwsUOz2vycHfkVgN8neajCk8D1HofE0rPvB4lQuLYvZJnOa4Za+8kfo4CiNyqww5IBhSpq9AJUNg+eve7ASP1S3zH7g+Dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SmGKTT6kuCq56DCvEp6REMh8SfTyQQiX73QMoBnL7D0=;
 b=ab2l7rjPhHnfRVse3SKQ314Soza5fKxZyLMX6WUaTLOAEqOQEWOT06NJwp/+byvEbO6Cskb/bU6HnvDaR8/RhjS2K0JNEwReQUB1YxNOcJqB4u+PIIAyFAc5zfvJFt/i1UVwZ98m1LNq1bcKobpAGo8ROei0Y5UaEgUTwkMcePs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from SJ2PR01MB8101.prod.exchangelabs.com (2603:10b6:a03:4f6::10) by
 CYYPR01MB8241.prod.exchangelabs.com (2603:10b6:930:be::7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8699.19; Wed, 30 Apr 2025 05:38:54 +0000
Received: from SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::292:6d9c:eb9a:95c9]) by SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::292:6d9c:eb9a:95c9%3]) with mapi id 15.20.8678.028; Wed, 30 Apr 2025
 05:38:54 +0000
Message-ID: <42312808-d3e2-4f1e-94f7-233837fd04b1@os.amperecomputing.com>
Date: Wed, 30 Apr 2025 11:08:45 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] KVM: arm64: Make AArch64 support sticky
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Zenghui Yu <yuzenghui@huawei.com>
References: <20250429114117.3618800-1-maz@kernel.org>
Content-Language: en-US
From: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
In-Reply-To: <20250429114117.3618800-1-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA0PR01CA0076.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:ad::17) To SJ2PR01MB8101.prod.exchangelabs.com
 (2603:10b6:a03:4f6::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR01MB8101:EE_|CYYPR01MB8241:EE_
X-MS-Office365-Filtering-Correlation-Id: 2aeb51e9-5c75-4838-1efb-08dd87a94b87
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SzJoSnlFRzU2eEYwS0lVdW1wRGZLTUE0NzJSYW5wMEY1OHd0cVRFZlJaL0VD?=
 =?utf-8?B?T0JNV1ZrakFVZ1Y4Q2FDTHhLa1ZjOHJWckFTYTMxckNVVUl4WkRIRkllSkVs?=
 =?utf-8?B?U3djNHc1RkdjS3QzTHRCYVRnOWRBdkVHR2M3ZWh6dUNkeDBzWFFrQ25KRy9m?=
 =?utf-8?B?Y2JkckliTzdSb0JwM3Yvd2hkMmVYb0JWMXJwWEVSWmhYSy81SlZZRzRmWndS?=
 =?utf-8?B?SFhlVGtlbFFUcUJlUWRJUEYvZmM5bG9tRUxESHpuUEVwaGFnVDFGRW9LaUxO?=
 =?utf-8?B?azZVTGM4dDFaVkhQa0Uzdi9XY1NJWmVtWXJkZEJBOFdYTGo0amVBTzIyOStM?=
 =?utf-8?B?L1FrNDBIWW9JOEhaazNZWWVBQXpoNmtVS3gvMGx3RFB6M2MvdUN3SXpnRUp0?=
 =?utf-8?B?MVVHU3RIa1FwOUxHdGZWZTQxN1ZGQ2dlUUQ5RVdacWM2QVkzREpPV2dKa2N4?=
 =?utf-8?B?WjhQVzBzTjRtZUxSdzUycDZMcmo0OUxhUVgwY3Z1SytoTG01bCtYcWd1QUI5?=
 =?utf-8?B?eXBRN2lOM2NMMmNQbmVheTkyT3YrMXY5dFl5bHUrc29tdko2ZWpyUkhsekJp?=
 =?utf-8?B?NVNZdERvL015emJzRWJWaXRmQlFwV3JEc0JkKzlGQnFlb25OVzA1SFcvV3Ro?=
 =?utf-8?B?Y3RlL2ZUV2piRVFJckRnRStwRStUamsyQ2Z0d3JxMWxndzVKWUpRVDVnQmlw?=
 =?utf-8?B?dCttMjB2NG1lRWVqRzd0cngzM1FEZDhCOXVrb1hmaWpBS3JJTVByeXBkL09B?=
 =?utf-8?B?VGh3ZXdjOW81RUE5S1hyZUtHWkFLdEI3M2lIWDl1UVZGREZVby9PaTNtUk9S?=
 =?utf-8?B?LzROL3JpS0ZlL29UOVJTbjIvaURWOHNiRk1jSUUzTnQ5NDU4d3I4Q1luRndU?=
 =?utf-8?B?L24vU0FHdTQvamhrTzJJb25lZHdtMVlwME5kTmtKS1UrK0l3TlVIcjVkU0ZF?=
 =?utf-8?B?bENTdGpHMzdBb2tLY2F1TGl1Y1ZZRDFxZjAyQUE2dklQS3dMSkVjb0Ira3dj?=
 =?utf-8?B?blY3NllZS0E0V0ZDMTdyKzdlUlVZOFc0MkszSEg0Z3dENU9GREFFdFNja29T?=
 =?utf-8?B?dy9Icy9YWVRhdTRwQThrYjRaWm1GN1RRcTYxL3F5V0sxYU4wTS90NDZDVWJi?=
 =?utf-8?B?L0FqUjFKbDhkbEVRb2J3QWNjajMrMXh0UGRoc05uY3I4amhqTlQ4VjVlSU5t?=
 =?utf-8?B?N1cxRytlR3Rray9mZHZNblF1WnVDUUNzbjUyYkU4QjhVTm9Xek1oUEFPMnYx?=
 =?utf-8?B?SER3U2RxMjFNdGVVTGN3b0JhQWNhOWtNRHc5Vm5SUVdTeGt1MDJCRGgxek9j?=
 =?utf-8?B?Ukw4SGlzdHNPcVZtUFVSU0pPSDBrdisxeFZ6S2JDVVM1eUpadlRXeFhIWGov?=
 =?utf-8?B?TUJhem80dWdsZEVKS0VtQkV2V1I3T1p0REZYdUZkaWk0cHVwTWtrRTcvTHRw?=
 =?utf-8?B?dkptWVcxUXEwZ1JGK09IcTFrRGhoWlNBam5BY0ZqZ3JVRlR4MWxWMEVIczQr?=
 =?utf-8?B?Vjd6TFdIcG9BZ29RUm1PanY0UGJSOVhrcDV6YTJvTGIydVBKNTFtZ1lVV0hJ?=
 =?utf-8?B?NTZBb0oySmhxK0xQMUVzMy9NTmJLd3p6b3IrbDBRclR4UHE4L0lUanhSYVIw?=
 =?utf-8?B?NS9ycUJzVW5DNHNJRVg0UHFFelZTQkl1TUhRTWo4RlJtYlltYkRFMGxlTmIv?=
 =?utf-8?B?bFlxRFlwd01aRng2VVkxcldXUDlJZTN2Y1EyRG1KcTI3Mjc3NllQVHIyemtG?=
 =?utf-8?B?bTFjdkR1anBKWVRYaU1wLzcwN0hHMWt5OWY3b254ZlBvQUQ5SFY4cUZjUzRZ?=
 =?utf-8?B?cG4wMzIrU2lZeE5kM3IzbVFWa2FpRUdCRGxWblN4eWJBK2JvZlUvTVgvOTNt?=
 =?utf-8?B?UGJBK1c4MHV1cXhTazFzeWp6Zmw1TGl2Ym1EU2VnOE9DWnJNVVJPWFBJVUl5?=
 =?utf-8?Q?r8wcqwA3c6E=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR01MB8101.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Y0t5MUcxZzVWOUtOZ2FTTWpvVEdrRG00RktJb0pvVlVQeURIZWNEc3BURmdJ?=
 =?utf-8?B?eEZKQ3JKM2c1Uk9Qd2tNWHU2NWF1YjVDU2Q3V2JLZmVjRjU4WWpuVTRIb1VG?=
 =?utf-8?B?TEJTY25McW5Qb1FzQzM0VEJRL3kzNXNua0xLYitHS2VNMFh1YjJzRVFkUE5T?=
 =?utf-8?B?eGZWTlBWVUdkT1RKcUhnOHNjaE5TaDJOOVE4VnQyY25KcktmdjVrMnVMUkpV?=
 =?utf-8?B?cmFxaHlMT2oyYm1lTE53WCtHeXBYNHBlWCs3VWl6R1ZWTG44NmVrU0JzazRj?=
 =?utf-8?B?ZHp4RE9QSG9sTDkzZElydjkwY1dBdytaVTJJRFhIR3FDN0FQZnpCdnlTSVpH?=
 =?utf-8?B?OEM4djdYbVBxTS9DanY4MC9Ic3FrRXE4dm1rU2IyNmRydWc2RmVhSlRBamY0?=
 =?utf-8?B?YktLVi8wdW9UT0VsVnVlODZqdHE0d0Q4RzFFWGJOMGNyUTVjckZpYmNtVVJH?=
 =?utf-8?B?SFVyRkVWRzFHL1BLSFNvNHVPQ3hhWldycFBnc2ZYQWpaNmFFaGlRazV2Y3gy?=
 =?utf-8?B?SEduclYyUllTQ1VlTTZGc1NXL3BLYTdNSklzR01GcEtKUmR0aytkd1lIV0Jt?=
 =?utf-8?B?WTBoSHNSb2s5TUdXUEI5YmJGQVZNYjBEUlcwc1NQdndBVkxwSVI3WWlLS01w?=
 =?utf-8?B?ZkcveFU3S1hUNGorWm12QmtQU096c2wwMERpaG9VZ0hOamJwRTJPNXlSdGt3?=
 =?utf-8?B?dzNFKzBjTU80OG9LZVoycXhXN2RhUmIxcitZYWMxYTRaMGpXTWNPSWlMSk9x?=
 =?utf-8?B?MkdBc2RUSUR2SWk3VFFYYk55Z01nRDh6NWE0eW9mOFJqVy9wb0dCWk5sMjlo?=
 =?utf-8?B?L2FyajEvZ0pRSlY1RDJ3Slh1M1c2ZUNpYlJaZWFiWXNLM1puNG1vOGZQM0lZ?=
 =?utf-8?B?MUVmVTNRdzF3dXRpM0VmRDJXRVN6ZmtFWkxad2xTY3R2cG5iSUp2UVFSS2tw?=
 =?utf-8?B?bU1pKzJDS0YrWTJSK2pWNWlTa05TeGFsM0pJZDd6Tm1qeEluMFNkUEZQbFh4?=
 =?utf-8?B?NWhsa2EveUZMVUVxdkpiUzZ3L1BZcDNWUVJBaTRWeGl2K0RNMER6YmF1bWtF?=
 =?utf-8?B?TDZreklFTmhmTXlRM2luTGxuSFlVYUxNRGtQUFBpYmgrQWJlcnBBYjE1c0FF?=
 =?utf-8?B?d3JkU2Y2VWFVdWtMTFdWd2xmcmI1b2hkNEJKZUhaVGhkemYxZis4RjVQMFY0?=
 =?utf-8?B?YUR6blQ1eXlnVi9jbVJwMU9Gb21PSVhNZHFvdFoyNHFNbnM3M2poNVBFNUNv?=
 =?utf-8?B?NEo2aE5UbDVrS3E3aDZXM1VDUkxLb2RoeEcwUm54TmdyNVBBaVpraEQ5SVAv?=
 =?utf-8?B?ZGFLaGRaY2RMT0xOb2JqOUc0eDJnSHNsbzNTY3hMVXBvenN6bndzTDhMaHJ3?=
 =?utf-8?B?VlZvKy9UNFFhcEJGNTdVVXpsYnpyb2lpUUVmQjR4Q0RGNnBOdGc3cGswd0Rp?=
 =?utf-8?B?U05reXloVkc3cDQ3T3JKemorZGZXYjA5cVcwQlVsOTA5K2FrSXRNKzY2V1pD?=
 =?utf-8?B?d0FjT1l3RjJ5MWtIYUJET0tkdXUxVDAxTm5temVDSVlNbXk1c1NaQjdscnVs?=
 =?utf-8?B?d2N2OUFaNWR1MkpBM0ZaOHl3S05aRisraW0xSHRwYklIODBkK3RrS3Mwa0ds?=
 =?utf-8?B?L1RiT2RsYmhlWXJ5M3R3bmk2K1NUMGFFNUVXcWs3NE5tMXpwVVAzM1picnJH?=
 =?utf-8?B?eFdJdUR3U2M3a1F3SGp2L1BUUFFwT25iZDZ6TklJTmZabW9acnJWSDRTTlRH?=
 =?utf-8?B?ajVkTDdsUkRST1RQai9IdHJ0NldTdFJyY1ppSnN0aVQzbXdSWDlZOTdHQ3o2?=
 =?utf-8?B?Nkh0VVVLZlAyOERxcjErMXhnVGNsZWI3V3pEL2poL0hyNWd0TTlFUVRWZ3N5?=
 =?utf-8?B?amRDRnpZVExyc0VQVUhRekl2U1J1QWQ4S3JRUjFEeE9iYWpFLzVqcS9PT21z?=
 =?utf-8?B?cXU0cFBGaHBtRy9WUUl5TGJ6R3VIRlRrZU5oUzh4am1xVHlwRGpaNzVDaWo1?=
 =?utf-8?B?QnpoQmpmRVZxVU4vd1FRdEFxdzM4Skp6LzNWMXVtT2YzRFhVOGIrMnpsZjkr?=
 =?utf-8?B?bkZUMWJ3STJIZ21GSXlhVHRQQUYzdU1SR3creHFIQ0t5V1BQeFEzNzRlTnk0?=
 =?utf-8?B?WXByNEVJMnFNbXFrY3NQbnlTMndTcmluSGdGQnp0V3ptbkRncTBGRTI2OVdy?=
 =?utf-8?Q?M2X4L4CT3Icbxs0U7Tswgmb+ofKZTqqU0+Sl37HWXVc/?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2aeb51e9-5c75-4838-1efb-08dd87a94b87
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR01MB8101.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2025 05:38:54.4568
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bBKMevvX34T7Vnrda3cTht2vYbV/64LbzfwC+ZJwZSSVlSOCd111l/4crirVcq9ut94+m0NlvyGg01Wcf5GH2bJgoJ1FAY8Gx7ZRKeIQLUkcXu6wrvGmXMNE9Vjb/o8s
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR01MB8241

On 4/29/2025 5:11 PM, Marc Zyngier wrote:
> It's been recently reported[1] that our sorry excuse for a test suite
> is writing a bunch of zeroes to ID_AA64PFR0_EL1.EL{0,1,2,3},
> effectively removing the advertised support for AArch64 to the guest.
> 
> This leads to an interesting interaction with the NV code which reacts
> in a slightly overzealous way and inject an UNDEF at the earliest
> opportunity.
> 
> This small series fixes KVM by bluntly refusing to disable AArch64,
> and the test to stop being so lame. I'm also fixing the NV code
> separately, since it isn't upstream.
> 
> [1] https://lore.kernel.org/r/4e63a13f-c5dc-4f97-879a-26b5548da07f@os.amperecomputing.com
> 
> Marc Zyngier (2):
>    KVM: arm64: Prevent userspace from disabling AArch64 support at any
>      virtualisable EL
>    KVM: arm64: selftest: Don't try to disable AArch64 support
> 
>   arch/arm64/kvm/sys_regs.c                       | 6 ++++++
>   tools/testing/selftests/kvm/arm64/set_id_regs.c | 8 ++++----
>   2 files changed, 10 insertions(+), 4 deletions(-)
> 

Please feel free to add,
Reviewed-by: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>

-- 
Thanks,
Gk

