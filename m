Return-Path: <kvm+bounces-54945-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E762B2B7DF
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 05:43:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A9F8D5E5839
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 03:41:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 914312D7813;
	Tue, 19 Aug 2025 03:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b="dIWkidLm"
X-Original-To: kvm@vger.kernel.org
Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazolkn19012057.outbound.protection.outlook.com [52.103.43.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E134D248F70;
	Tue, 19 Aug 2025 03:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.43.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755574881; cv=fail; b=b9V8lazQOTv0IxMCNpVQtVhPSrJ/W9/TaKu8fT2WVTLemIaQ193NiINyKvXhAlhisA5wqFhhzMiX4t3/5pcGF0Ny2lc5bt7Ewq7NNWCfwJ0Cx8YhetLBTB0s5yddK7qHBDBqHBvs4WWjD0En/vCUZY3yMJ+76I7AObFX1yIQkwg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755574881; c=relaxed/simple;
	bh=qLFNbLJ7+dlaJe+NVIgaens3GR1S3v9sgYOBJo55WpI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ZGUGDSGy0iAWyMplwWrsfoCB+crr6Uv21pg6uYYfuaCthPG24260UpnU6BHZDEh0/oGJkMi/yq2vpzpxHk37A8s7Vclsj+DT0x/RKWgcvkCfhexOPZtTyjoH/h9C+orFlS6s82AzxpcbWSDP84hNIVfLVGOLlThLSjnXeyBeTJo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com; spf=pass smtp.mailfrom=hotmail.com; dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b=dIWkidLm; arc=fail smtp.client-ip=52.103.43.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotmail.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WGKF7FpeoDo6PbiGzaULMVSOb4+275d8+WvEoxm8Pe+i6x9hB4iG4w4CK5Gzla25Tb5ngENwfQA0sTgdXyYKoHLDySMddvHm7tDbMFdSWQZwZBRk4GPO2yMFyIoTnuXXnDo5N/6aGEDcTf03TijnQqYlO0xCCQuz67E2BJe0mw8IJnSt3sgjh1iN4T4MHFhTpbHX8RfNhgUzTmVefhpYpStm1iYxFNuzx4nV4S4flCXFYhje/7ZOTjjoXT65k8eepLKS7ByF8Di6fJCrSMhlPsL0c4OyYpKbSVr+a5ufYtoWFkq4+vDotWZbvn+w+vBPHU9KwlzHv+o5OzMIASd5MQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eqTwYO4js0VsksozqddjqCQ07AJ85hf2UvlHPJJXX1c=;
 b=IIfxCb9ojRYEPpdd/KC+xkHVboWZb+LHSu/boCmcXpGActTWjXmNiL7RHsM9E8Q0xUzJNTtVqIKgx6EGgcDAY6Nvq6dwH1wAB3YcuyiaXsOP010sam8WKNgYkrB5a6xD6LWXD3i6l6s3nHhBN64OblquMboLMLZuUH3jDmAd1B/9AKe6Hst5Bv84whFkwVkHjXPl9rXYJL1E0tilAulUbOfS6s7NNoP6gGeowrG6QSW4JJlARYR8CbGU3TDBsxc2VMYuokOvU7VDejfVPl2zqkyhvqoI8dS59Nw+s7JLazXoXa/qcVyPM/iUv2e9H5SfKsdfVm41LTFuL2DX1juieA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eqTwYO4js0VsksozqddjqCQ07AJ85hf2UvlHPJJXX1c=;
 b=dIWkidLmnUebOz+LtZEwlEJ0Ck4lIHOMflSXx8AFkSaFrgcFamcMyFWhC4iRmbL9QGSbJCNncaX/BFViBLGjEz5b4GKFUFnOrcyMC9PmIskfR5aGq2kwSbLEOzccK5ZHq6IQkChpayYB9U1Q3cHGWwFkSO/1GVNhZ/qeqvcae9Ow8gDpNWt/iAAzRCQ24PNnVnNp9ZJVPz5bNR85PqmOLGV3/vALpny3AQ/bQsKwJdQ2jAmHG21GyACQNUFsgKvF+jqn0P34lRpsyfVNHrC8jwYsZPi/Lgae+nTPh/Ggy+HEbjA5PNslWhAcXHWUAgLzN2qdMvnQUDyFexy5b/7IYw==
Received: from TY1PPFCDFFFA68A.apcprd02.prod.outlook.com (2603:1096:408::966)
 by SEZPR02MB6253.apcprd02.prod.outlook.com (2603:1096:101:e2::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Tue, 19 Aug
 2025 03:41:14 +0000
Received: from TY1PPFCDFFFA68A.apcprd02.prod.outlook.com
 ([fe80::209a:b4cd:540:c5da]) by TY1PPFCDFFFA68A.apcprd02.prod.outlook.com
 ([fe80::209a:b4cd:540:c5da%6]) with mapi id 15.20.9031.018; Tue, 19 Aug 2025
 03:41:14 +0000
Message-ID:
 <TY1PPFCDFFFA68A8349F6BAD182C0816F9FF330A@TY1PPFCDFFFA68A.apcprd02.prod.outlook.com>
Date: Tue, 19 Aug 2025 11:41:07 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/6] RISC-V: KVM: Allow bfloat16 extension for Guest/VM
To: zhouquan@iscas.ac.cn, anup@brainfault.org, ajones@ventanamicro.com,
 atishp@atishpatra.org, paul.walmsley@sifive.com, palmer@dabbelt.com
Cc: linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org,
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
References: <cover.1754646071.git.zhouquan@iscas.ac.cn>
 <f846cecd330ab9fc88211c55bc73126f903f8713.1754646071.git.zhouquan@iscas.ac.cn>
Content-Language: en-US
From: "Nutty.Liu" <nutty.liu@hotmail.com>
In-Reply-To: <f846cecd330ab9fc88211c55bc73126f903f8713.1754646071.git.zhouquan@iscas.ac.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR02CA0015.apcprd02.prod.outlook.com
 (2603:1096:4:194::16) To TY1PPFCDFFFA68A.apcprd02.prod.outlook.com
 (2603:1096:408::966)
X-Microsoft-Original-Message-ID:
 <1c20326c-d563-492d-9daa-017c539f490c@hotmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TY1PPFCDFFFA68A:EE_|SEZPR02MB6253:EE_
X-MS-Office365-Filtering-Correlation-Id: 83c3f5dc-7419-46be-a948-08ddded23f10
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|36102599003|6090799003|8060799015|19110799012|23021999003|15080799012|5072599009|461199028|40105399003|3412199025|440099028;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?clBOUVJrT3AvL1orOFh3MkF2VnpVdzlkeWN4VllkNlB1Ni9IdkUyV1RJcHdn?=
 =?utf-8?B?OGRTc0gxNUlvNUkwRDYwVHFmcmU1bzlraldnY25LQTZRNXlFa29ZSFhUMU9E?=
 =?utf-8?B?Y3ViWGxDTGZLRkc1SG0rQXFBSzc5WjY3dzRFOUZLSXZsdFpIYkZaelU5KzRa?=
 =?utf-8?B?WWZFa3pQZjdBM2pXY0V3a0JyNzQvdTZwN2pNZmlaanFyKzVrLzYvQ2N5Ryti?=
 =?utf-8?B?MUVLUlR2SFMrMlpwUmdjYnh4d1Y2OWtVdzM2T0pnWVJpOWNod3FueitYUnp4?=
 =?utf-8?B?UGFRbnV5K090YWhXdFA5cUdJbzViU0EwSkFQL2VScVdRTmkxdGxFTm13bGMz?=
 =?utf-8?B?bkc0bk8vTWtiUDg4M1gxUDVMaXZZcklGd05OeGtQWFpyUXR0dzRVUG02MStV?=
 =?utf-8?B?aGZXM0NaUWtUSW5EOXA5cUZ6UjhyOTU3QXdyQXVFVFBOczZOaUVBd2JRYmJr?=
 =?utf-8?B?T0FkSGM1OWJ1eUlBbi9OSSttbW9IRVVyQWsrVEtyZ1RUVXhIMnBvUndTS3Nx?=
 =?utf-8?B?NTQ2dUNzbVE5cjdCN3paKzFrVXVDaDlxcDBpU1ZFLzJhNGt0ZGlIcG1ZR3Rv?=
 =?utf-8?B?K3RGZGYxRjRlbXNQTzhXa0NEREJJb1BjVnlKSFluSk5OcndtOU5sMStWTklz?=
 =?utf-8?B?MTNTNktuTjg1ODF0MHJzZ2lLNUlMQnI1UUU3NTF4NzFMSTRrUFUvYlJYVk9p?=
 =?utf-8?B?SHRQMHZDTTIxRWZJS04zdWVWbUY3TjhUUjgrYUZRZW5kMFFNbUNEK0dzVVk4?=
 =?utf-8?B?VGhUU1RIVjczcHAyVzlaN0xNQnh4cnZxOWt4N2Zpcy9qN1FnM2FiWEM0T2l4?=
 =?utf-8?B?Y0dNa1ZnVkFZUjZXU3Z4TUZOUWpYTlNqaXloNVl2cytoQ0hHTzRtcmpxemlJ?=
 =?utf-8?B?OFBYTGJKYmpNN1YxaTBoTEtiVkJ4U2loejZBNUpwd2FOaGRBck8yQmFqc1RN?=
 =?utf-8?B?Y01wZk14d05zL1F1T1NOTWpsZEs4NHBwVlIva3FnOTFROU5tcnhGaUlpTWJD?=
 =?utf-8?B?ck9wZHNUL1hMS1FPYWN4aml3NUhwVGJ3VitJQXVWMjFhMGt4NURNZlczRTV3?=
 =?utf-8?B?M1V0ekYydEVuVWRlUlhrQlNvV0lGQmlkZ0RIeEhYRUJZWWZyV2xIdFlrYmQ4?=
 =?utf-8?B?NHFnZ0t5M2hwWldMR3FYd0tUYjlFSGpnWUFYSVVhOUtMcVhHdmVUZjYyd2JT?=
 =?utf-8?B?SGhEZTByV24vdC9MQ2EzZGMyQ0hhMUlQbU85NE9xNHVLVk1QQnk2SkpvcmM3?=
 =?utf-8?B?a2Z1RldiRnNTNExFNFdISlNvbXg1amovRmR4Qmk1TTAwRmplSHBZRFczUmNr?=
 =?utf-8?B?K2d4M0FtbEdrdGtaUm9ZNEFOa1AxZFBzMzdBcEtEQWdOMmZFVnpIS28vMW5I?=
 =?utf-8?B?RG5vQzAyT01EaEFNWGc3cjcrT1Y3MVJXYW9MNmpZOElQOWg4ZVA2N0h3OUh0?=
 =?utf-8?B?c1JTN0tkelhvWG9oSlJEVjVUY3JhaklYYlcvTUROWWZoZlNadmVMN1JiQ3FB?=
 =?utf-8?B?cjRxNzhTK2FJM2xWbU90UzI3UHNlNFF5UytydG1PT3dqNzNUNjA4aGRkbEV4?=
 =?utf-8?B?L3NlbytoV3FRRmx4QUI2Ung1VE1KcGNCR3BIVFNPZVlJQi9tdlU4TGdWdG01?=
 =?utf-8?B?bC9IRFFHcWVpT09pNkNvc3RDY0MxSWc9PQ==?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RnRURXliSFJKdDl5eTlwVEhFQmRMK2Q2WW9teGRtNzhYbHJMVDlSeTVwVWV0?=
 =?utf-8?B?UWZrbFRDSEVjaUN3bmZQMHdVaEtXRVc0dk5aSkdrYXhKV0ZrdGp1TzhYelhi?=
 =?utf-8?B?bnozb0VhVzhhTmtUNTRYa3hkNVU5TGFwZTY2TXJlRHZod2pYb1JsTzhlUGZl?=
 =?utf-8?B?aGl4NW9jQ3FZS0NxMThsVjh4blJxd3ByOUJHbDlrajcxNFZlUlROSjIyNDI3?=
 =?utf-8?B?SDJQQmxDRlZBK1h0QjlsQ3g0STM5OTVWS2NyUyt5NE1xakM2bGhsa2ZnVjNK?=
 =?utf-8?B?WGMvQmxyYXpsSFpXZjYvWmZaUmxsajI1cE9uYUtFbHFVM1ZLelhTZks2QSsw?=
 =?utf-8?B?dkhUdVF1NWpnazQvR3EraEhLZ1R6dlhKdnJ1eDVqd09ub0xGa0NUazAzQWs3?=
 =?utf-8?B?N2FBTmtja0xLbmw2cWtMQ0VvR05ZMVdQVWI2SzdWcHhXTlhHenhvVjlJdERN?=
 =?utf-8?B?cURUa00vc3ZDamNYRWVPWWN0KzE1MVhPUUtzdzhwTHpOd0FGaDIvSmdJVXgw?=
 =?utf-8?B?MUF0VDJySjlrUWtUY1BZTkg4NHJOQW1vK0h4Z2ZBenA2Y0JRUUNvNjVjZTIy?=
 =?utf-8?B?V08yRjdpRzJzOFo2WG4reGZEY0o0bExmdXgyNTBvcWloeDRaSDIrWklVTlU2?=
 =?utf-8?B?V3RKTER4YW1MVCswb29QaXg3OU12ak9JOTAzRVowd2pQLzhPQVRiSnNDdU56?=
 =?utf-8?B?WHZObFc5Mis4S09KbSttNmJLa3Q3NmI3aHhmTFJqOVJzMFJPZEx2dGRQczNL?=
 =?utf-8?B?cUhLVWNMc3FkNTdkVXRTdld0MmllYjNNWHBYUEhad3o4U20wc1haci8zN3N6?=
 =?utf-8?B?K04yR0IrVVRIQ3NZUUFlaUZLYjFiaXM0ekxsWFJwZnBJamxiaTlpbS9BUEMz?=
 =?utf-8?B?SFZ0a3kveEVuU2d4bW9pMGRibnAvT0NPblIzbjh1VGJtRVJKR05DME5ibENG?=
 =?utf-8?B?SFBqVXJDdG5sUXJUckUyNWNhRVhFckxEMDV3L2ZuN2tGTjhIVm1tVnJrSVRV?=
 =?utf-8?B?UUFVeXB3QmtENEdqbjJyMXhJMzBzZERkT2UyQnpVcDRqVldEOEJ2ZlJPTlNR?=
 =?utf-8?B?SmJoVUR6Qm9HK2MyV1lpRUNVVFNMS0g4QXhUZVEwT05aSVV5bXdQYlRwcVVW?=
 =?utf-8?B?R3BTNTJYbW5adTBKb2IxRmRGUjhyQTgvT1lKMXZzSzZSd1hjbnVOdGVhVzJO?=
 =?utf-8?B?VzZvUGpsK1JXQ2RxOENTbFpnd3pDRDNodlorNytDSkVWUjJJd08raHZYb2hJ?=
 =?utf-8?B?aWVKNlNlWmowR1NsbzRVdWNVWnhDRitDSGNXUFc1WG5MZmZnZmdNem1ndDVV?=
 =?utf-8?B?SnlMRmJXbktiL1JrcXkzL3BTWnYrN2E5VmVRWkJjakhNbXUyMmxEdU9vTW5L?=
 =?utf-8?B?UVlUSWxUQ0RZTHhyTnVRdThvb2cxbVkyYlFLcGVLQW5TQWhDY3l2TjFuSXBz?=
 =?utf-8?B?ZmdoQ3BjLzJzN29EMTVTNUp1KzRIWjQzOXBjNUJ3Q3hjaU5LYTM3VjgyNGNT?=
 =?utf-8?B?SzYrUUU1VHo4TmY0MUQzSTM5dXIza21OUW1IUkJYZFNXY0x5UitkTy9tRVVP?=
 =?utf-8?B?TkRsN1BOVmxtdHFUcUEwc2g5M1lpV1hYZUlVaHpZU2NXZ2NJcEpSaFpvbTRm?=
 =?utf-8?B?dmxqbHhvZ3BVQzUrSFdZN3JBaFNQcE56cHNPejRJR21WZWw5WWRCNHBXZFN6?=
 =?utf-8?Q?rtUgAsgAGwi4g3H6h6Rh?=
X-OriginatorOrg: sct-15-20-8534-15-msonline-outlook-c9a3c.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 83c3f5dc-7419-46be-a948-08ddded23f10
X-MS-Exchange-CrossTenant-AuthSource: TY1PPFCDFFFA68A.apcprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2025 03:41:14.3327
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR02MB6253


On 8/8/2025 6:18 PM, zhouquan@iscas.ac.cn wrote:
> From: Quan Zhou <zhouquan@iscas.ac.cn>
>
> Extend the KVM ISA extension ONE_REG interface to allow KVM user space
> to detect and enable Zfbfmin/Zvfbfmin/Zvfbfwma extension for Guest/VM.
>
> Signed-off-by: Quan Zhou <zhouquan@iscas.ac.cn>
> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> ---
>   arch/riscv/include/uapi/asm/kvm.h | 3 +++
>   arch/riscv/kvm/vcpu_onereg.c      | 6 ++++++
>   2 files changed, 9 insertions(+)
Reviewed-by: Nutty Liu <nutty.liu@hotmail.com>

Thanks,
Nutty

