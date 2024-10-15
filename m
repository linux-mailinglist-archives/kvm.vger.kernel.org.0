Return-Path: <kvm+bounces-28866-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C19F999E331
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 11:56:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 22F95B21CAB
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 09:56:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88C071E2821;
	Tue, 15 Oct 2024 09:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="pnhgSmBD";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="pnhgSmBD"
X-Original-To: kvm@vger.kernel.org
Received: from EUR02-VI1-obe.outbound.protection.outlook.com (mail-vi1eur02on2064.outbound.protection.outlook.com [40.107.241.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05E857F7FC;
	Tue, 15 Oct 2024 09:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.241.64
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728986167; cv=fail; b=Sde691t7e+3muhRUt7MD9T+6HFabyRHF7+tMKyGFVVSdWiJOCGWhBygsXt6Hvyhn2/9mX32JeLgl9MGbYwBLGNvgv8pimxTIb0iAlgLOK8LhOgbkbtlCLvSBWDybTBfikq4RIRxUeznDQ9kNpQ9EGp2kCCj4q+h7WIaWWWkyGUM=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728986167; c=relaxed/simple;
	bh=R1GPs8UE6POR+Nt294U4EhhKNyZsm0aQulrPqD3Vr/Q=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Zked1DmuxymOWhLPdVf+gHDBs42eAJD1/PnkJYLFIdAAXFlOv62zlMc0/EZl9db9dtmGYDpOMJ3fsCs5fOYk/v+ai1UMNOUf65vnrODWR09ayQ0Xabq9mXv/QCBFzBRTxTkh7j9QkhF5ipzVJcXebpKqxZ/QpeB7ZQwp3cwXC18=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=pnhgSmBD; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=pnhgSmBD; arc=fail smtp.client-ip=40.107.241.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=ygOQH9F3wDXAyo9rcHJbw0hK2jvQPgutmBmAGQGqPUnxVSWXzX2fXpKRIx7KRLTCk4BevTk2tiqdgItaj2FxYGJWNF4dBoZZwf4iaC6VfyD/CuE3/rnj/Nq2BIIiXHegfPY0SFQcvfMUcPkMQbNQ34IDWnonqHsG5QQQjQGgeS9b4iz8kjZ6Xdv28dwgoYKkFa4GO4NxEAZcfju6uBRS6UN4rJ2RIyoH14rJqkgQODKPoG7+EnPq9vYMqthvWZu9D/wG1WQ9vX5WkL5Te7qFRJYaW6ioScScieTxx/k1og2kPKEOpCwj9k0Pha7/4ETs3ljRwA+CLuvSYCLOaada/g==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fxo0034oQei77aEQA8eboxrK3kfTKT64TeU9b4BwAlA=;
 b=giiQZHnOznSTSSz//RewR2xmNiZZH6ageuKnjGKxdJHE0eWUsmdstUDGfIqjBWFEc3N4PbA/W22ZRDipO+5XLALTAU+1khOsieQwaEKtI76weoF0AT80ig4GrJCw8EMAegthR+I93tT5ZR7UnmffCpIa64virlTWdiEUwRag4gClpYkV3Q7NgkpXoAYsZtRCLAZGp47gj5vcR4xlM9He8hmLbsSBDveXlB/j0nZolHztcdH3P5yxYooxGXkjIPCFQzQSRX+XcSbxrF6v8ie60/DhI6bUZIcPCRGka0a7jl9zZk+k0ytUiFuVhtmE//P9zTW5I1ABSPF1pxKexzmq8g==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 63.35.35.123) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fxo0034oQei77aEQA8eboxrK3kfTKT64TeU9b4BwAlA=;
 b=pnhgSmBDaxdhQ+zDNwT3bNCFza1JIamKWb+1fdect8zdLLhRjYFJePeF0cngEE81baGm17+G67PWkg5SHW5rEWC/EhQreBeA3NPqTCNrRRiRRdZ4A0kT7AZ15R4KZb9sAbJsdVRm7oTB35qGVO7G9F8khTAvXHA2E713jCKMgqc=
Received: from AM0PR04CA0085.eurprd04.prod.outlook.com (2603:10a6:208:be::26)
 by AS8PR08MB7840.eurprd08.prod.outlook.com (2603:10a6:20b:52f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.26; Tue, 15 Oct
 2024 09:55:59 +0000
Received: from AMS0EPF00000195.eurprd05.prod.outlook.com
 (2603:10a6:208:be:cafe::78) by AM0PR04CA0085.outlook.office365.com
 (2603:10a6:208:be::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.17 via Frontend
 Transport; Tue, 15 Oct 2024 09:55:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AMS0EPF00000195.mail.protection.outlook.com (10.167.16.215) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.7918.13
 via Frontend Transport; Tue, 15 Oct 2024 09:55:59 +0000
Received: ("Tessian outbound 5c9bb61b4476:v473"); Tue, 15 Oct 2024 09:55:59 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 1fe33367947a5308
X-TessianGatewayMetadata: 3awlzYEwt0DMe7+iprxZjrCQERfzQG8heXlNJnaWxbSqhWiQWGmcRG+jqQNoGy4pOa3JkH1ASWoODvJSyG5R2iRIhjkaOnZ8/1F08TXnLkBTiPN3+HCfQ66q4h90gVLbow8LFNkxUr2IE6wa0jCdz1O2HMxVX1iy5KFypGV1vCc=
X-CR-MTA-TID: 64aa7808
Received: from L5030f799defd.2
	by 64aa7808-outbound-1.mta.getcheckrecipient.com id 544C5CF6-6824-463A-81A5-5C4C3A0C76E3.1;
	Tue, 15 Oct 2024 09:55:48 +0000
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id L5030f799defd.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Tue, 15 Oct 2024 09:55:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u7xgFIvTgKlbyRShrTo/HgeWy8/OK3K0wcAdmxTAD3MG4fbFnUkoeezoEQb4BIaUWNHtNVWnmc5CmTEktHyApJPLYBoJFwhg2F6SV6PUWyRgk0sS9OJTVZhcgJm2cc5bp23jvYRaD2ObivZJECf5rSv+Oiq+cSMB5qVM8xCmHaKP3h8vp2138JHa0TfKSCtDUY3M3KE5o0UkYHCvGgbudEJrb6bg5N5M3mEMLH5w5NyOO1TjEwxQu8E/ai/lRPUeo3WOKGKxQRhsgk9B44MkmXY8/npIIEhI+OjL4826RIgEiSFg5Olrv5j6cTFtDPpsiQROXIGyaXesSGtqGjc5VQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fxo0034oQei77aEQA8eboxrK3kfTKT64TeU9b4BwAlA=;
 b=TArszB6JuH5tDU0ujJrvsCXniCRIpcFOswC65PWXWRjk6aFuCV+iPcAc+H/ic7Ibgrni8kryhe6Ei7KtAoWVG0NtdQnafKhnl3pdZfkIdKjEoHeP0tWBCEDhX7sOUihH9Ld6sPUJJSIItz47el402xc6zWJ3tf1JCo8CJxAMDM2SmynTlGGH3h35ci1fHgZBXQeX7Ay5EKchXIUaAzXaLAd96A5TPAHKFVjTYi6Gc7ZUaOzZ9g2g7zRRluUhL50pIQ9WQdJ2sdJ53L0ypwQcfOysibSd8XFJp9XrSqGj0BIzTlk1jjTbIVwf0Ts84boMx+E2+a9XkSwERKKoJrVOPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fxo0034oQei77aEQA8eboxrK3kfTKT64TeU9b4BwAlA=;
 b=pnhgSmBDaxdhQ+zDNwT3bNCFza1JIamKWb+1fdect8zdLLhRjYFJePeF0cngEE81baGm17+G67PWkg5SHW5rEWC/EhQreBeA3NPqTCNrRRiRRdZ4A0kT7AZ15R4KZb9sAbJsdVRm7oTB35qGVO7G9F8khTAvXHA2E713jCKMgqc=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GVXPR08MB7727.eurprd08.prod.outlook.com (2603:10a6:150:6b::6)
 by AS8PR08MB6293.eurprd08.prod.outlook.com (2603:10a6:20b:23e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.20; Tue, 15 Oct
 2024 09:55:45 +0000
Received: from GVXPR08MB7727.eurprd08.prod.outlook.com
 ([fe80::9672:63f7:61b8:5469]) by GVXPR08MB7727.eurprd08.prod.outlook.com
 ([fe80::9672:63f7:61b8:5469%7]) with mapi id 15.20.8048.020; Tue, 15 Oct 2024
 09:55:45 +0000
Message-ID: <0bb96cfd-8994-4a74-8ef2-fe5dcd5a1508@arm.com>
Date: Tue, 15 Oct 2024 10:55:41 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 11/11] arm64: Document Arm Confidential Compute
Content-Language: en-GB
To: Steven Price <steven.price@arm.com>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>
References: <20241004144307.66199-1-steven.price@arm.com>
 <20241004144307.66199-12-steven.price@arm.com>
 <20241008110549.GA1058742@myrica>
 <846c43a8-9720-4dd5-b40a-73ec00b9a9a7@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <846c43a8-9720-4dd5-b40a-73ec00b9a9a7@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0614.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:314::15) To GVXPR08MB7727.eurprd08.prod.outlook.com
 (2603:10a6:150:6b::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GVXPR08MB7727:EE_|AS8PR08MB6293:EE_|AMS0EPF00000195:EE_|AS8PR08MB7840:EE_
X-MS-Office365-Filtering-Correlation-Id: 64060fb3-5c5e-4d41-fbac-08dcecff927a
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?UDdOOUVzMStYTitGTERWK3ZvT2d6YXJGZFlyNG9GdUZwcGFxTzlUYXg0blNs?=
 =?utf-8?B?UDM2T1ZKZFk0R015TU5qN1hXeWhDUkxSVzVhV3JkeGIxa0MrSmVpNXcrRlBh?=
 =?utf-8?B?Wmx5ejJLMU8yQXJVR0tVVmVwUDVyMFI1djdjWDFlS2Z0Z0xEZ3FGWkVKdlBK?=
 =?utf-8?B?SkxJclg3UGhGZVk5Tkd4bkFJcC9ZQ0Exc3BNUUJKWnNwSnBUdnZFYmdkbzky?=
 =?utf-8?B?WlNpb1RqL205aUVnWElOQXg0K1F1TFBmVnFLOW1NV1FvQTVOR2MxQmNSZk5u?=
 =?utf-8?B?R3BKb1k1RHhEZWk0L3pqNXhiVHJ1L2tFNVdqR21lZGxWV1BSdFdIbDFTT1lK?=
 =?utf-8?B?V256RDk2dkRrbjh4QS9HckxmVnZ1cEY2MmRySENpTDN5Q0F5TW9abktqL0pi?=
 =?utf-8?B?UkdaSEhNVlNLUjYrYUc1UGYyd2tiYVE5OXVHT2NndTdCK0MrU2ZVZ3Z6bkRU?=
 =?utf-8?B?ekRCUU0rc085dXFFTXpyV3o2Uk1SVjJrblBVOE1FNlUvZ1o0c1pHTGRzRHZN?=
 =?utf-8?B?bGpVUHRIbTM1dE4zNkxMTVh4L0JrWDMrdld5OEVHeThWSkFDMHM4Y3I3YlRx?=
 =?utf-8?B?Ri9LUU41LzMrTjlFNkhOc0xjNmxrRERicEdvSkcrb3BxbFJQeHp2TVlSOGww?=
 =?utf-8?B?d1dvUDRMUXBNWndReHNmUWd1MFQ4YTE3N0M0QlY1ZzhydDR6TU1ER2tMRXZE?=
 =?utf-8?B?ODMrMnA2ZStEYzdGblA2TjMxNFV3YTBuTEVEZ0xRWG9OK2N0bzdOL2xHd1RT?=
 =?utf-8?B?QTFaVGM2ckJOa2RIS1FKWjZqY1lpL3lIR29qM1BxckpteWVPNHNhK2Zwa0hj?=
 =?utf-8?B?RWFjSlRYa205QW1zcit0ZTVZNjJ1R2xwUWNoankwVERzUmU5VGJOM1I3ZWtE?=
 =?utf-8?B?OUFSN0dOa3VxTlR1VXl3Q1pYalNmc2kxRGR6b0w2aXhRSmVYYm1GS1ZyVTh5?=
 =?utf-8?B?NFhoYkI3cmNDcitOOTViN3BvOFl3WXZuNSsrZk9jMFgzTk5Ibzc0QTNaSWNI?=
 =?utf-8?B?NjFEWStaN0lhd0doSWxyeUFHelZqU0l1MzduQStxZTkwR1FoSWl5a3plMktn?=
 =?utf-8?B?dlZ0TXI3SVl6VnFvMW1QTisxMTkvQTJaNUJ6L2k5VnN6SVU4QndVMUFMSDdo?=
 =?utf-8?B?RkxLekpFY3JxRVJSci83WEhrRWJFdnlWTEptRXZWZklHUWRRV0hDZjVOMkNi?=
 =?utf-8?B?QytNeXVhM01DSWdlZG9lZ05YU294MkYvY1NuOWlPNTZrWElGNU9LOXBGYW1B?=
 =?utf-8?B?VVhkUzI4UHBoMkx5Nklaelp1cjM1ZWViOTRpR3FaZjBvWWl4aGlRL3ZSaHJ6?=
 =?utf-8?B?NmMrQUhuekRrQ2VObHIxcGRodFNldGVUNjdZWTRSRGJURC9YZnl1b0JRYXRS?=
 =?utf-8?B?S2hvQ2ZEcDN1V1ovRFVkd0o1UnptdE1NdGdTaVpPeFdITzF1T3VJcWpvUy9t?=
 =?utf-8?B?L1RpUk1zNmhPT2pDRytwb1RzL0NZajVVWU9jaGhmS2srZTJrU1EvLzE2NnVk?=
 =?utf-8?B?QUVPaXN0TGplZjh0ZFpaT01LN2M2SWhwU0ttUE8rVzdyT0NvSWltb2kyenhL?=
 =?utf-8?B?aE9tWTJKL3hNV2RLb1NNVVdIMGc4eUwzYnZVdmhudHdxSS9aU0pwTitjRDVu?=
 =?utf-8?B?NVdKdTZBbnpNR1ozdHkwMDBFNzROUmgyS29SbXhKMXZpaEVURlJzR3E5S2Jw?=
 =?utf-8?B?UDZtd2pVN1NUTFVFRUMwbDJsWS9OcUFHZUE4Tms1YTdYT1NKU3F2WklRPT0=?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GVXPR08MB7727.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB6293
Original-Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-SkipListedInternetSender:
 ip=[2603:10a6:150:6b::6];domain=GVXPR08MB7727.eurprd08.prod.outlook.com
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF00000195.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	35582aeb-555b-425a-0e4a-08dcecff8988
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|35042699022|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UHlIVlRiR2RlOTVyS1FzblFGT1pRbzI3NWZrelowa3EwQkZLdEQycDlSd0Jv?=
 =?utf-8?B?azJUL1dvRThQRUNaaEtmdkRSUSswVEVJVFFiakZkek8raGZzSWo0ZGs2Sno2?=
 =?utf-8?B?cEFEQzNOelVYcDBienVqT04wMjNYMkMvOFE3TTQrdFFkWHh4bGJvNVRuWGk1?=
 =?utf-8?B?TWFxN1NOaWg1Tk95eGdHYUdjUlpRWWsxODZjdmNMKzk4L1ZoVWlDVDQySFpn?=
 =?utf-8?B?VkYvZ2RrQ1d3VEZzVGMxRFp1UkpydURtRW0yeEpqcU50ODZJUCttYTRSWDNS?=
 =?utf-8?B?bUJWUmlnZUN6cTRuSDI3akVzWDQwdnRwMjFyQ2VTQXlNRm41QjFkZzBmRXZK?=
 =?utf-8?B?ZVc2dW9UazVGdUdLcDVJRnBrOElvNDNEdWk1UUp3b0Ezbm5OQyt3QU5iODE4?=
 =?utf-8?B?L09tUlNVNEU2TEpsK2JsZUxUUmtmUFVkS0NEbCsxVzZCZEk4bUhBUTBrb2VS?=
 =?utf-8?B?MjVqZ2w4SHdoMytqWVlaRE0xWUFtMHNlNHZMVGYxMWhVM0xJcVkrWm0rVENm?=
 =?utf-8?B?RHFxWFptS2FlT3E2U1RjZVFhdXp3NkMrQXR6bWYyUWdLUUhvbXRURnlOUU04?=
 =?utf-8?B?MXgvK25EU2ZWeXhHU0tMc1NpSzVxc2N5Tm41citsZTRkbG5RUE1VMHloU3Zj?=
 =?utf-8?B?eVNYblhJbnpYRUFDZk5rQVMyNjNnU09DTzEvMUhwa3RCS3BCcGhvcG9jWkpZ?=
 =?utf-8?B?T0xrNGJPWkRzYklBeWtYMFVRNTNJOG52bjFsUlhZL0IrK1k3YTRJQzhndmRV?=
 =?utf-8?B?L3lmR081ZzRmVTNHN2s2Y2pWTU4wSFJ0UU50TEhTT0RsTkkrUmxBbzV3KzQ0?=
 =?utf-8?B?d2pkVU91RC9qM2RmQXRmVXNmUnk4aExpK1VqUU9kcW5IWVhDdlR2ZWRoeVFz?=
 =?utf-8?B?dzREQm5vU29DNnpqdllUZmNHSU5iQzhaY21Fb3U4amNxeWxBaHFKdFdGU0h0?=
 =?utf-8?B?bEk3bmR5UnVXL0k2ZWphT3dqd0RTNVBWcEVqYXllYkgyMkhwMFhuTnBEdm9r?=
 =?utf-8?B?d3dhRlNHYzFDUTRhUEFIbnhUdHZRaFp5L25Xb3RvUmZPVkltM0dISzhtNVZx?=
 =?utf-8?B?MkNWdllIdDV4S1c2dGZXVVMvK2x3UmJYT3BMeXlLNVVJUDF3ZHJSZjJvZGpi?=
 =?utf-8?B?b2t5Wlk0QkpVRjZ3MkFrMlI3Y3VPOE9ONzVoUVo5elBDemZCV0FiMTR3WFdH?=
 =?utf-8?B?NC9LRGpCQXdKZnNaYzFMWnBybFdMdGw1WnNjNTcvZ2kxM1JHY0JYQ0h6YWlx?=
 =?utf-8?B?S3A2ejdnRXVLcGpEN1dSV0lVb1krZGFxeTVPR3BnSDNoQWRFVk5uWGt6VktT?=
 =?utf-8?B?RnZaZ2d1ZWxQSndJSHVOZmY5eFVTVUpBWlc2TjkzNUVIOThKTzlCS1Z1aEp6?=
 =?utf-8?B?UHhIeGNraEpYQmZ5eWdCK2JiOFE1UVZxMkk3OVhMSC85bk9idXdHd29tb3dG?=
 =?utf-8?B?RUZYL3ZyMXo5SElJcThKVFZGN0ZuRGV5dytTTnFVWUVFbFM4NFRpbXZmQmR5?=
 =?utf-8?B?OVRSc01BN2g3MGlCdEVpdEpnbW55VWxCcUs5RlNQQUZVZXlQdkFEaFdiaVVM?=
 =?utf-8?B?NEswSkxwSlBWcnFLU2hUeWdEYTlDa0YrNGhjNmJ4RTZFU0VPazN2UTlUUWlj?=
 =?utf-8?B?ZlhwUGJUU2pqRFhZYURkUDkwVFF5ZHhkNUJFQWRadHZQaUdlN3dUN08xbWNt?=
 =?utf-8?B?WlYwU2ZzdjV3dlIzR21WK2g2R1VxTFNOUXRNWFJTdFZwSjM4K1A0L1krQUZT?=
 =?utf-8?B?Nk5VVmNRcURreWlNY09uSkc1VnBvQldZeUo5VlFBV05uZDh5dDMyR3dtdHpN?=
 =?utf-8?B?dGFFKytVSDloOHhBc3F6Vlo3UGppQmFzcndxSGR1NEtPNXFLejdRLzFZRFNx?=
 =?utf-8?Q?RBt8DZBDjZmf3?=
X-Forefront-Antispam-Report:
	CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230040)(376014)(36860700013)(35042699022)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2024 09:55:59.6241
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 64060fb3-5c5e-4d41-fbac-08dcecff927a
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF00000195.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB7840

On 11/10/2024 15:14, Steven Price wrote:
> On 08/10/2024 12:05, Jean-Philippe Brucker wrote:
>> On Fri, Oct 04, 2024 at 03:43:06PM +0100, Steven Price wrote:
>>> Add some documentation on Arm CCA and the requirements for running Linux
>>> as a Realm guest. Also update booting.rst to describe the requirement
>>> for RIPAS RAM.
>>>
>>> Signed-off-by: Steven Price <steven.price@arm.com>
>>> ---
>>>   Documentation/arch/arm64/arm-cca.rst | 67 ++++++++++++++++++++++++++++
>>>   Documentation/arch/arm64/booting.rst |  3 ++
>>>   Documentation/arch/arm64/index.rst   |  1 +
>>>   3 files changed, 71 insertions(+)
>>>   create mode 100644 Documentation/arch/arm64/arm-cca.rst
>>>
>>> diff --git a/Documentation/arch/arm64/arm-cca.rst b/Documentation/arch/arm64/arm-cca.rst
>>> new file mode 100644
>>> index 000000000000..ab7f90e64c2f
>>> --- /dev/null
>>> +++ b/Documentation/arch/arm64/arm-cca.rst
>>> @@ -0,0 +1,67 @@
>>> +.. SPDX-License-Identifier: GPL-2.0
>>> +
>>> +=====================================
>>> +Arm Confidential Compute Architecture
>>> +=====================================
>>> +
>>> +Arm systems that support the Realm Management Extension (RME) contain
>>> +hardware to allow a VM guest to be run in a way which protects the code
>>> +and data of the guest from the hypervisor. It extends the older "two
>>> +world" model (Normal and Secure World) into four worlds: Normal, Secure,
>>> +Root and Realm. Linux can then also be run as a guest to a monitor
>>> +running in the Realm world.
>>> +
>>> +The monitor running in the Realm world is known as the Realm Management
>>> +Monitor (RMM) and implements the Realm Management Monitor
>>> +specification[1]. The monitor acts a bit like a hypervisor (e.g. it runs
>>> +in EL2 and manages the stage 2 page tables etc of the guests running in
>>> +Realm world), however much of the control is handled by a hypervisor
>>> +running in the Normal World. The Normal World hypervisor uses the Realm
>>> +Management Interface (RMI) defined by the RMM specification to request
>>> +the RMM to perform operations (e.g. mapping memory or executing a vCPU).
>>> +
>>> +The RMM defines an environment for guests where the address space (IPA)
>>> +is split into two. The lower half is protected - any memory that is
>>> +mapped in this half cannot be seen by the Normal World and the RMM
>>> +restricts what operations the Normal World can perform on this memory
>>> +(e.g. the Normal World cannot replace pages in this region without the
>>> +guest's cooperation). The upper half is shared, the Normal World is free
>>> +to make changes to the pages in this region, and is able to emulate MMIO
>>> +devices in this region too.
>>> +
>>> +A guest running in a Realm may also communicate with the RMM to request
>>> +changes in its environment or to perform attestation about its
>>> +environment. In particular it may request that areas of the protected
>>> +address space are transitioned between 'RAM' and 'EMPTY' (in either
>>> +direction). This allows a Realm guest to give up memory to be returned
>>> +to the Normal World, or to request new memory from the Normal World.
>>> +Without an explicit request from the Realm guest the RMM will otherwise
>>> +prevent the Normal World from making these changes.
>>
>> We could mention that this interface is "RSI", so readers know what to
>> look for next
> 
> Good idea.
> 
>>> +
>>> +Linux as a Realm Guest
>>> +----------------------
>>> +
>>> +To run Linux as a guest within a Realm, the following must be provided
>>> +either by the VMM or by a `boot loader` run in the Realm before Linux:
>>> +
>>> + * All protected RAM described to Linux (by DT or ACPI) must be marked
>>> +   RIPAS RAM before handing over the Linux.
>>
>> "handing control over to Linux", or something like that?
> 
> Indeed that actually makes grammatical sense! ;)
> 
>>> +
>>> + * MMIO devices must be either unprotected (e.g. emulated by the Normal
>>> +   World) or marked RIPAS DEV.
>>> +
>>> + * MMIO devices emulated by the Normal World and used very early in boot
>>> +   (specifically earlycon) must be specified in the upper half of IPA.
>>> +   For earlycon this can be done by specifying the address on the
>>> +   command line, e.g.: ``earlycon=uart,mmio,0x101000000``
>>
>> This is going to be needed frequently, so maybe we should explain in a
>> little more detail how we come up with this value: "e.g. with an IPA size
>> of 33 and the base address of the emulated UART at 0x1000000,
>> ``earlycon=uart,mmio,0x101000000``"
>>
>> (Because the example IPA size is rather unintuitive and specific to the
>> kvmtool memory map)
> 

With the above addressed:

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>



