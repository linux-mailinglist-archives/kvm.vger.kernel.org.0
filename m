Return-Path: <kvm+bounces-52667-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A19BBB08009
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 23:56:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C060017EC10
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 21:56:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D25D2EE26B;
	Wed, 16 Jul 2025 21:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="o2zxsKwd"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2061.outbound.protection.outlook.com [40.107.244.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80B722ED87A;
	Wed, 16 Jul 2025 21:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752702961; cv=fail; b=VM74D1JuSxZfu8A1PiNP2S2TqtLK7GVlamEXT3bEv1MPfNUM2O8d7bxokaFw73tZ2aBByjEfFOB6J0LyGKGzodJNPDR1eYlEDdVUZdzDXk2aAJkESsjhFqszWshj4/nxU8GIoh7VQUBP7WOevrd26mjc/WSfYn4v/v68hYK6238=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752702961; c=relaxed/simple;
	bh=LRJCog2pQI7jrcRGuLxmUR1ukjWHgsSlArkmKBH30lk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=uNH2HQEKO90Cvkm+UQijkecu2cRxp+u5SK4eiaDc63P2svpMDdjwgKnlYW/FI8D8iT78gxuUHJRBDHU0XzCkznTOQsj8oEeu8C0/iRQNlO0EwrRfYlBgo/mpYsQj9nxttNMlrsUVRESDRn5pIMVnMPKw5KoQL0fZzH5CjpWpSHs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=o2zxsKwd; arc=fail smtp.client-ip=40.107.244.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fit2AvLZxbcAjsgUjhfhkVTCAgKU+Iq6+VgHtXjGdmUiBs84s27T59PW+THuL+zv7oq8/3uEvfqQdPXIcliefnpmKi6yqcwighHloKJgEpZD8z57eNlcdxmPseKECA9bZY2260NZ9YCWxgkWwDCXzI2FICmrVSFkE/E3AQYdw4HOTlt7nvzYqX+dC1TtUBY7fW/HmpYj0QwZUPTcF4dlIatIrvL8WyZyPPzCOGfaYGSlV9RFIjP6G/7i2L2IqGHfJlO/rdxWYzsR05JPRQ0slM6qG+aK5mcSxdy10gXaG5+9/WGIvFv+FQWhU4g3Q6FB70OyXUbEIwS6dqFHG1heGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CW0z6IdKr+pxnnYg38YTdlCPGUfqcQzBd0A4/xoqjYs=;
 b=Cv2Xa+mKyKspadzEDgtPFnvjsnYoj/yv1WoIe1KTysuqyP3zm9+eHLy4RBArEbhvLTRbSUTMzEPOEWytthReXVJho0M0L+WgM7Wt12gaCuQlJ5oGduqykwSJn5V30uPK7H6KJb9BqEdVfqyvHnjf20pkND03DFR1CFiEbIK8KEYLBFrC1S5jSfml6t3ZuKq9RfhJwKRb9KkzJzRmLW9CG7xUxaTKdl0hY1m7TCLgHntY2qJ6dn6l6TJVs/Mk98HAlgU4eQbWTowRUcLgSxzvfeOSIJTdqt9Z5tSx2LeT2+eO4jc4K4C0UVK73MRwIb9qh9P/utIhKlahb2CUgGSMhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CW0z6IdKr+pxnnYg38YTdlCPGUfqcQzBd0A4/xoqjYs=;
 b=o2zxsKwdJZ/R8cg1782UfwKXERaCFnX3FCmkMYxr26w614hKal6ul3LI0cST+t6sGane3cBqhkTTgkQBaLaodWWZzdkdP1xK1Vs/W6Xn6r9Gc3DSL6ErY9tgeCb14/KbppW1mNyQEoBbl6vClrphW1H7RqFh7S4dANlZDqb7OBs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by DS7PR12MB6069.namprd12.prod.outlook.com (2603:10b6:8:9f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.33; Wed, 16 Jul
 2025 21:55:54 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%6]) with mapi id 15.20.8901.024; Wed, 16 Jul 2025
 21:55:54 +0000
Message-ID: <84fb1f3d-1c92-4b15-8279-617046fe2b93@amd.com>
Date: Wed, 16 Jul 2025 16:55:51 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/4] iommu/amd: Add support to remap/unmap IOMMU
 buffers for kdump
To: Vasant Hegde <vasant.hegde@amd.com>, joro@8bytes.org,
 suravee.suthikulpanit@amd.com, thomas.lendacky@amd.com,
 Sairaj.ArunKodilkar@amd.com, herbert@gondor.apana.org.au
Cc: seanjc@google.com, pbonzini@redhat.com, will@kernel.org,
 robin.murphy@arm.com, john.allen@amd.com, davem@davemloft.net, bp@alien8.de,
 michael.roth@amd.com, iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, kvm@vger.kernel.org
References: <cover.1752605725.git.ashish.kalra@amd.com>
 <7c7e241f960759934aced9a04d7620d204ad5d68.1752605725.git.ashish.kalra@amd.com>
 <e71a581f-00b2-482f-8343-c2854baeebee@amd.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <e71a581f-00b2-482f-8343-c2854baeebee@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA0PR11CA0175.namprd11.prod.outlook.com
 (2603:10b6:806:1bb::30) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|DS7PR12MB6069:EE_
X-MS-Office365-Filtering-Correlation-Id: 11caaf49-983f-4005-6e8b-08ddc4b38962
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aU92ZnVRR0lPa1U0WEpOeUd0TkY5eS95Q2h5cDdQMkJDWnBiNHlzMXIxNGVC?=
 =?utf-8?B?TXl2cERRSFZ1cmh2cVVicWZrUElYbHJ2bWlITm9kZWt6VldSMm9haVJqWElp?=
 =?utf-8?B?VS9PR3hzNFVQZXVWYnFBMEZRV1FaaER1YkEyZ2pSSjFDRHVsMEgvcHU1elht?=
 =?utf-8?B?NTZCaTczVDNRRXhIdHQvcEJrVklNcVB0cVorUFFzT3JUaWxoUWp6Y2wvNzNC?=
 =?utf-8?B?bk1aWTBic09QaXIxbnQ3MTlKNzdsTEVRc2ZlUzQ5akhsbkZpOVBFb1l0SStv?=
 =?utf-8?B?UW9taEFIME1YYkUyQm1lQnBkTlYyazQ1cUdCajJXMVRuZ1NCMkVpaTh0d2tr?=
 =?utf-8?B?RFcyckIwd0pHZ3daTmRCTS9HWkp3MHh1SWpQWENTSVNjVnp3cldzeVdpS1Uy?=
 =?utf-8?B?bFlGUmdoQnVvbXExZ1cxSHVwSFVaT2hBVmVEWmM4aExDZVBkRytHeDcrcUt1?=
 =?utf-8?B?cExMT3gzNjhWb2VNazA1bWdrcDJRTkQ1bkl5cU9GUWpQTmozZ2RjY2tKcFg5?=
 =?utf-8?B?bEM2S1c1U0MvY2JBdXZ0S01wZ1RIOG9JSFY1VTJDR0J3ekMzUmdIYjYyRm1z?=
 =?utf-8?B?cUJqdG9tWlRNVWcyV3R6NTdUdGwzTDAvcFNkekIydWplTW03a0N2ZXVWMjQr?=
 =?utf-8?B?emhSeFNaV2NvK3ZkUzBLUUV4RGhZZUdSM0RNaFZLMXk4U25uNVZyem01c1oy?=
 =?utf-8?B?Z2NlYTh3MStDZnJIRUNheU0yV0I5SDZ4SjVIVmlZL0JJeXVaaHZMbHVJOFVT?=
 =?utf-8?B?RkdHcmFMRW5idEM2dnlwdlpjQWFMYjZUakV1LzJxL2huZlE5b09XUTN5Mnph?=
 =?utf-8?B?VnZOZ0psWGhCWkpqRC9wVEJnWGs0eFVOaXZHU3Z1ZWpZdUg0eFkwd2lyN0Rx?=
 =?utf-8?B?cktZd0NhQk05ei9ObHA5V0hJOTAzRVhONTV5TTNzeEp6Tk5JM2xoS2pRaU9V?=
 =?utf-8?B?WE83Qk1PMXh2VzM1UHZKTDR6WjU2Y3VtY0cxdWhtd0lpc25oTUp3cFNMTG5y?=
 =?utf-8?B?VlhWL09RcDJVRzlHcTdsd21xQldiY3R4WDZpMmFEVERkWi9FUlFySmNvMldx?=
 =?utf-8?B?SnZ3UFBGV1FhS1FIV0FwSmN4Uko4dHpLbVVXeHo4T0pCcW5GeVIxOE9EODBp?=
 =?utf-8?B?cE9CNG5kWDV1YnErRGFyUW1LMHMvQldiSkJKdkU5QVhuNEpLUVlnUzhWbFpF?=
 =?utf-8?B?VkhxVkt0R3I0N0dPK3JhTGp2d1RUU2R4dElFdXZveFJpM25sTWMwNzZSZTNI?=
 =?utf-8?B?TVZaYXVNQS9BT0lpVXVKb1BrekU3eGhuaDVmRlkzRDVndnpiUEdvbFgzTmJq?=
 =?utf-8?B?aEt0dEVBZU1UTDgyVDl6K0IxK2FqamV0aGg2OUhKVE9tb0loUDBtL3F6VE93?=
 =?utf-8?B?WFByMFRVUjNiMWM4QkZ1UER4U3hzWDBNU0R6dHM3OWdoaEJ5TUVwbmZnTnJW?=
 =?utf-8?B?TVpEeHdZNEd1YnhXY0IzK1VqdzJuOEs4bUs0NXFnVjF5UnRkWU9CUkFGQTg2?=
 =?utf-8?B?ZDc2NVF5T1hPejlvWDFkdXV1d3dwbW8zaHc0UGtMOVNFdTJ0VUpuTWxUZHM3?=
 =?utf-8?B?dVNINDJjelc3RUszQVg1TXRzdTVMMzVhNHhZYXMwWmVZa0t1bDhtdUhjNmRr?=
 =?utf-8?B?R0ZkU0lVTzR6bm5NM1RnbTZkQXFTMUFOLzhxdS9FMWVYM0NaV0dnSk1aUlg1?=
 =?utf-8?B?S0hDQ0tlcWJaU2ZnU3h0eWJOOWgwS2pTZHpJM1NobkFJOXFaSDhDVDl3ZlU3?=
 =?utf-8?B?ZnpKczRjaFdndklpVHFJejE3NGlrNmVXTWlZazJUR2RVQ2hqSlcvVUVuZzI1?=
 =?utf-8?B?M2o3RnBOa1N1QTdBK290SmRnS3FTNktnVy91VEg0cHpjS2h4dTdjMG9Oa21x?=
 =?utf-8?B?SmZQdVJwQ3pYV2t0SXZFeklLM1BFK0ZsR3h0RVVWVVNzTHk3dm5QQjVyZDEv?=
 =?utf-8?Q?mQ13vp+vAcQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Rzk1VjdOeWk4enJNNXpycTJBdmlTbFVFUEs5QjdqODltWlFESmN1QXp6WXJ6?=
 =?utf-8?B?TG42TFRubVhUSjNEMi9MRG9SSGpOM1dNc0RnTUl6dStCTDdJRDVEd0Znb04w?=
 =?utf-8?B?Qkd6SERHN2YzazBmcXhCQkhnVjJPYncyVTVYdkxNdTFzOXlUNnBzM3VXZGNq?=
 =?utf-8?B?VksxN21hcWNrRjE5UHpGL1JORzNZSnJxWFBNTENuUmJBVW5ZdW1RZkJnV1Rn?=
 =?utf-8?B?RlZnNDBpUS9zcjlJMk5kdzh0NEhncjk4ejhja0VRYTkwZTdTL0gyeUY2SnVs?=
 =?utf-8?B?Tk02a3VqOVk5MEJLdDZoOGNQRjZnMkt1OVU2ZDRFWTlBbFdvUnRueVdzYWRS?=
 =?utf-8?B?NGo1Mi9FeWR6QnllMDJhNHRTY0J5bEZ1N1gxV0V4VmtodzNBN3MrYXRkMXJH?=
 =?utf-8?B?SEZkQTM0MUo1TlJTL0trVXoxNk5qYzJDOUQ5UG1mQlN5cFNkN2hEcGtzMWVq?=
 =?utf-8?B?V2Z2ZlZhNThpZW1lT3lEbEQrZlU4dmlkOENiNGU1d2w4WS9yenE5Y09ZRThX?=
 =?utf-8?B?WEV0RVc5V3IySVYzRGQ0WWlRRTF1QXV2bkRkU0RqOG5LbGJROXhmTytLTzZC?=
 =?utf-8?B?Y3IyQ3JHa0lqTGNsNWl5RUtZL01DWnlrWG85K1JpWjFlTjEwUzdsM1pUbW9L?=
 =?utf-8?B?ek5oaTdhOUlRdHpRek9IQmhEQmhEUGZoelhjbmcwNEVmSmtOWTlwSGNUbWg3?=
 =?utf-8?B?Ym9ITjVjTWV0bGVOd0dxYWNaMXYvbktBclBsamMxMTJVUml6V1JOa0FLRzVK?=
 =?utf-8?B?cG9ucHJZRW1OWDh0TFEyemE2cEpuendaRjVTU3FBZFVNRHFqSTRTMWJpUkxF?=
 =?utf-8?B?UlZET1paT0JKeU9FL1h2bjFseDREQzJoVFZXWmJMbCs4ZUZ5WUFZS1E4OUpt?=
 =?utf-8?B?ZzRaczJkaEJHckVhL3VmK3Zzb00vRVpBOXI4NE9GK1Fxdm8xQWRoL29iSXVr?=
 =?utf-8?B?cnpNZUR3eEYxdHZxQWtZRzJnU0ZueTQxd3duWVFOSDIvUGlqVGdyK1NubWxh?=
 =?utf-8?B?KzZWRlhISjh1MmRBS2F6M0lDTS90MWpNV2dIaEZoaWxaM0t6MHpQZzF6WEZV?=
 =?utf-8?B?Uk93VkRtdHdlQ1o5cUc2VW9lNS9HU01HK1FVeTZ5c1A4eVFkcSs1eXlQenQ2?=
 =?utf-8?B?azJBanZlZ054SWhwVHo5dFo0aVJIeitqaS9DMHh0QjNibGI5U0d4WG1mNGU3?=
 =?utf-8?B?ZG10SmhKSjFrck5IOUcvMUxKZjRsZDVBN1N5a1NmVzVvTDhMbFovTUpHZWMw?=
 =?utf-8?B?WG9vZFI0RWxvRjZrek43MzBya2FtRUFOaTNzV1FLY3FQY1l3TUNoeFpKbVNK?=
 =?utf-8?B?anVxRGZ3Zmo1Nm9xaFZTd3RGeVBGYjhoTTFuajgwZitDdGQybEkzMFNPK2Iz?=
 =?utf-8?B?cXBMQzl4WklBMm8xRkNXY0ppTmtBOVRlTjRrelB2WVQwd0ZtSXFXTHkyM0t6?=
 =?utf-8?B?MjRaL294SnNoL1ZFd2lkUlJWWCtHRk90OHpTeUlPcFNqMEkwdHRuQkV0YjhG?=
 =?utf-8?B?bGJkRWdDamN3MWk2ZytpVWJTWGk1Nm8zWi9vMFFXUWZITFQ2Q0lYblpmeUpU?=
 =?utf-8?B?RjB2cXhuNVNkN1p2RlArN2hlVXNWalZyVDM4akNEQnVyc0lXdmRwM3lkbkZ1?=
 =?utf-8?B?cGxYeFdQeTdnM29GVVhuQ2ZFU291WS9TbjlxcFdlVngxeERaZ282MG5zaWJD?=
 =?utf-8?B?OGpNYTQyK3ZzVlJ3c2U1ak0yZjZ6dVdFZkI5UWZRTGlMbmdPVkJmWFlYWDdI?=
 =?utf-8?B?TlZwNHhhTk1TbkpZRmhSdDBveXA1cnE1eHFETXphUDA4ZWFhWW9FZDUwOTlL?=
 =?utf-8?B?UUdNcWcvZkE0RnN5bmcrMUs5WnZGY3Z4bkZqcG1nRnJndDVZL0pKdGZEcjE0?=
 =?utf-8?B?NktuM1Q1dWtpUEtlTmRFOVU5WjhuWlB3M2tmU1FJZWwxUWpDOFc2anJmeit0?=
 =?utf-8?B?bWNyYmhKMFNveHVtaTg5MU1TZ2prYjRMQi8wNkxrQjZnbHFZL2pQQUJweURG?=
 =?utf-8?B?NTJnR1RlWnhCRTcxMU50cmg1MzhydGJScWJJR3A2NFdLRzRqKzVjcU93M1Zm?=
 =?utf-8?B?cVY0bUVWMlVSSnIxcTlPeGNDVHZkL3pxUDVCajdjQWpGczV3NFo3VDYvR2Nq?=
 =?utf-8?Q?OTtfLre5NsjF20EO1qgIJD8CN?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11caaf49-983f-4005-6e8b-08ddc4b38962
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2025 21:55:54.1799
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Pz8MhBqTYn3ZQDIl+qnmMogbrVa5f8hp7KrZF4JFAitGUEkLifwjVipkAKdYk57LMeP4ouEuHF3QtTfdt5YvuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6069

Hello Vasant,

On 7/16/2025 4:19 AM, Vasant Hegde wrote:
> Hi Ashish,
> 
> 
> On 7/16/2025 12:56 AM, Ashish Kalra wrote:
>> From: Ashish Kalra <ashish.kalra@amd.com>
>>
>> After a panic if SNP is enabled in the previous kernel then the kdump
>> kernel boots with IOMMU SNP enforcement still enabled.
>>
>> IOMMU completion wait buffers (CWBs), command buffers and event buffer
>> registers remain locked and exclusive to the previous kernel. Attempts
>> to allocate and use new buffers in the kdump kernel fail, as hardware
>> ignores writes to the locked MMIO registers as per AMD IOMMU spec
>> Section 2.12.2.1.
>>
>> This results in repeated "Completion-Wait loop timed out" errors and a
>> second kernel panic: "Kernel panic - not syncing: timer doesn't work
>> through Interrupt-remapped IO-APIC"
>>
>> The following MMIO registers are locked and ignore writes after failed
>> SNP shutdown:
>> Command Buffer Base Address Register
>> Event Log Base Address Register
>> Completion Store Base Register/Exclusion Base Register
>> Completion Store Limit Register/Exclusion Limit Register
>> As a result, the kdump kernel cannot initialize the IOMMU or enable IRQ
>> remapping, which is required for proper operation.
> 
> There are couple of other registers in locked list. Can you please rephrase
> above paras?  Also you don't need to callout indivisual registers here. You can
> just add link to IOMMU spec.

Yes i will drop listing the individual registers here and just provide the link
to the IOMMU specs.

> 
> Unrelated to this patch :
>   I went to some of the SNP related code in IOMMU driver. One thing confused me
> is in amd_iommu_snp_disable() code why Command buffer is not marked as shared?
> any idea?
> 

Yes that's interesting. 

This is as per the SNP Firmware ABI specs: 

from SNP_INIT_EX: 

The firmware initializes the IOMMU to perform RMP enforcement. The firmware also transitions
the event log, PPR log, and completion wait buffers of the IOMMU to an RMP page state that is 
read only to the hypervisor and cannot be assigned to guests

So during SNP_SHUTDOWN_EX, transitioning these same buffers back to shared state.

But will investigate deeper and check why is command buffer not marked as FW/Reclaim state
by firmware ? 

> 
>>
>> Reuse the pages of the previous kernel for completion wait buffers,
>> command buffers, event buffers and memremap them during kdump boot
>> and essentially work with an already enabled IOMMU configuration and
>> re-using the previous kernel’s data structures.
>>
>> Reusing of command buffers and event buffers is now done for kdump boot
>> irrespective of SNP being enabled during kdump.
>>
>> Re-use of completion wait buffers is only done when SNP is enabled as
>> the exclusion base register is used for the completion wait buffer
>> (CWB) address only when SNP is enabled.
>>
>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>> ---
>>  drivers/iommu/amd/amd_iommu_types.h |   5 +
>>  drivers/iommu/amd/init.c            | 163 ++++++++++++++++++++++++++--
>>  drivers/iommu/amd/iommu.c           |   2 +-
>>  3 files changed, 157 insertions(+), 13 deletions(-)
>>
>> diff --git a/drivers/iommu/amd/amd_iommu_types.h b/drivers/iommu/amd/amd_iommu_types.h
>> index 9b64cd706c96..082eb1270818 100644
>> --- a/drivers/iommu/amd/amd_iommu_types.h
>> +++ b/drivers/iommu/amd/amd_iommu_types.h
>> @@ -791,6 +791,11 @@ struct amd_iommu {
>>  	u32 flags;
>>  	volatile u64 *cmd_sem;
>>  	atomic64_t cmd_sem_val;
>> +	/*
>> +	 * Track physical address to directly use it in build_completion_wait()
>> +	 * and avoid adding any special checks and handling for kdump.
>> +	 */
>> +	u64 cmd_sem_paddr;
> 
> With this we are tracking both physical and virtual address? Is that really
> needed? Can we just track PA and convert it into va?
>

I believe it is simpler to keep/track cmd_sem and use it directly, instead of doing
phys_to_virt() calls everytime before using it.
 
>>  
>>  #ifdef CONFIG_AMD_IOMMU_DEBUGFS
>>  	/* DebugFS Info */
>> diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
>> index cadb2c735ffc..32295f26be1b 100644
>> --- a/drivers/iommu/amd/init.c
>> +++ b/drivers/iommu/amd/init.c
>> @@ -710,6 +710,23 @@ static void __init free_alias_table(struct amd_iommu_pci_seg *pci_seg)
>>  	pci_seg->alias_table = NULL;
>>  }
>>  
>> +static inline void *iommu_memremap(unsigned long paddr, size_t size)
>> +{
>> +	phys_addr_t phys;
>> +
>> +	if (!paddr)
>> +		return NULL;
>> +
>> +	/*
>> +	 * Obtain true physical address in kdump kernel when SME is enabled.
>> +	 * Currently, IOMMU driver does not support booting into an unencrypted
>> +	 * kdump kernel.
> 
> You mean production kernel w/ SME and kdump kernel with non-SME is not supported?
> 

Yes. 

> 
>> +	 */
>> +	phys = __sme_clr(paddr);
>> +
>> +	return ioremap_encrypted(phys, size);
> 
> You are clearing C bit and then immediately remapping using encrypted mode. Also
> existing code checks for C bit before calling ioremap_encrypted(). So I am not
> clear why you do this.
> 
>

We need to clear the C-bit to get the correct physical address for remapping.

Which existing code checks for C-bit before calling ioremap_encrypted() ?

After getting the correct physical address we call ioremap_encrypted() which
which map it with C-bit enabled if SME is enabled or else it will map it 
without C-bit (so it handles both SME and non-SME cases).
 
Earlier we used to check for CC_ATTR_HOST_MEM_ENCRYPT flag and if set 
then call ioremap_encrypted() or otherwise call memremap(), but then
as mentioned above ioremap_encrypted() works for both cases - SME or
non-SME, hence we use that approach.

> 
>> +}
>> +
>>  /*
>>   * Allocates the command buffer. This buffer is per AMD IOMMU. We can
>>   * write commands to that buffer later and the IOMMU will execute them
>> @@ -942,8 +959,105 @@ static int iommu_init_ga_log(struct amd_iommu *iommu)
>>  static int __init alloc_cwwb_sem(struct amd_iommu *iommu)
>>  {
>>  	iommu->cmd_sem = iommu_alloc_4k_pages(iommu, GFP_KERNEL, 1);
>> +	if (!iommu->cmd_sem)
>> +		return -ENOMEM;
>> +	iommu->cmd_sem_paddr = iommu_virt_to_phys((void *)iommu->cmd_sem);
>> +	return 0;
>> +}
>> +
>> +static int __init remap_event_buffer(struct amd_iommu *iommu)
>> +{
>> +	u64 paddr;
>> +
>> +	pr_info_once("Re-using event buffer from the previous kernel\n");
>> +	/*
>> +	 * Read-back the event log base address register and apply
>> +	 * PM_ADDR_MASK to obtain the event log base address.
>> +	 */
>> +	paddr = readq(iommu->mmio_base + MMIO_EVT_BUF_OFFSET) & PM_ADDR_MASK;
>> +	iommu->evt_buf = iommu_memremap(paddr, EVT_BUFFER_SIZE);
>> +
>> +	return iommu->evt_buf ? 0 : -ENOMEM;
>> +}
>> +
>> +static int __init remap_command_buffer(struct amd_iommu *iommu)
>> +{
>> +	u64 paddr;
>> +
>> +	pr_info_once("Re-using command buffer from the previous kernel\n");
>> +	/*
>> +	 * Read-back the command buffer base address register and apply
>> +	 * PM_ADDR_MASK to obtain the command buffer base address.
>> +	 */
>> +	paddr = readq(iommu->mmio_base + MMIO_CMD_BUF_OFFSET) & PM_ADDR_MASK;
>> +	iommu->cmd_buf = iommu_memremap(paddr, CMD_BUFFER_SIZE);
>> +
>> +	return iommu->cmd_buf ? 0 : -ENOMEM;
>> +}
>> +
>> +static int __init remap_cwwb_sem(struct amd_iommu *iommu)
>> +{
>> +	u64 paddr;
>> +
>> +	if (check_feature(FEATURE_SNP)) {
>> +		/*
>> +		 * When SNP is enabled, the exclusion base register is used for the
>> +		 * completion wait buffer (CWB) address. Read and re-use it.
>> +		 */
>> +		pr_info_once("Re-using CWB buffers from the previous kernel\n");
>> +		/*
>> +		 * Read-back the exclusion base register and apply PM_ADDR_MASK
>> +		 * to obtain the exclusion range base address.
>> +		 */
>> +		paddr = readq(iommu->mmio_base + MMIO_EXCL_BASE_OFFSET) & PM_ADDR_MASK;
>> +		iommu->cmd_sem = iommu_memremap(paddr, PAGE_SIZE);
>> +		if (!iommu->cmd_sem)
>> +			return -ENOMEM;
>> +		iommu->cmd_sem_paddr = paddr;
>> +	} else {
>> +		return alloc_cwwb_sem(iommu);
> 
> I understand this one is different from command/event buffer. But calling
> function name as remap_*() and then allocating memory internally is bit odd.
> Also this differs from previous functions.
> 

Yes i agree, but then what do we name it ?

remap_or_alloc_cwb_sem() does that sound Ok ?

Thanks,
Ashish

>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int __init alloc_iommu_buffers(struct amd_iommu *iommu)
>> +{
>> +	int ret;
>> +
>> +	/*
>> +	 * IOMMU Completion Store Base MMIO, Command Buffer Base Address MMIO
>> +	 * registers are locked if SNP is enabled during kdump, reuse/remap
> 
> Redudant explaination because implementation is going to support non-SNP
> scenario as well.
> 
> 
> -Vasant
> 
> 


