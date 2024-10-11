Return-Path: <kvm+bounces-28642-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C07D599A8D4
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 18:23:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E16D21C217CD
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 16:23:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0547C19CD1E;
	Fri, 11 Oct 2024 16:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="KAb+KGI9";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="KAb+KGI9"
X-Original-To: kvm@vger.kernel.org
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2058.outbound.protection.outlook.com [40.107.21.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BC441991B9;
	Fri, 11 Oct 2024 16:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.21.58
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728663767; cv=fail; b=J0JGmPnzNIj3NaDG/NQGyUxPzBLs/gUX5oXk1YrUd1gwz44LUK1PaqCYv/IyhpxWAAG7nL64agZrle4HKDudVXLNQLcLmoOjmdUwXXWpOJdjnxhwnKNNBHCojBH/A9gUTN9JdxgqqvUYFH99PhSJd18Q56tAmL8OBko0lNTC2wo=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728663767; c=relaxed/simple;
	bh=rB3xN7b0CjhrmQk7vpH18S5AOBDSWx0xSre2sHRkV9Q=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=CHHo7CzHrdV7dtOTQF6Qch6xu5EaaOuwq9NvvgY5BbmCrFyAQNMAs4r9/CD8aV/8XdGe/2FIF3MqGNIATvg+jJghmwMS6LMxPIraIB/MwTAgusMMXSgqJgxrMjVnCbaG8e96wT657P6YxfVbOW6JWs372WSGAjHZdRnN2Kmxuq4=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=KAb+KGI9; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=KAb+KGI9; arc=fail smtp.client-ip=40.107.21.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=hxe8kP0A4CN9YyGgfBO4GY8vtgBt7H+0sb8N9zKti+dI5TNTGquvz7y0L1O3yGpfYK0JV73sKX4TEGaWuFFBbrnMmsyhyWZJucd55eBsgqjUFpKAhXBxaF/TSbrSdj93JG4IZz/XMR0rHkoUaDr6ftstcu4a4p5zVDFCRwUmWojwdkRr3NbdayTtMzskSPykB/O+TkNt06yjZ96hOW2RNrrADMSy4UoFBG+7gBBn7zd7xQP44m3Pu6qdt3eBDbgQiCjQuKYm+z2nR80uI9Q9DwWjbhwRidZc7uFkc6RuPUmC9zCx82h84rPl16sr4xM+VTYZ9t7aseL4U18gHMgU3A==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uBdm1MRiRqqpHmaZfT6UOaI8T/vKVAAtjgsugempIbU=;
 b=jUxNnEwlA1SJ3zLlI1FwrUxubIEWd6xlp012CRaw5UGnQg6pBEn3zuNTpF4LoCg8UMV53wA/Ro5+Dn2avbpF7KIbtU71rqt6RxURrwyov3E5+c+losKAuBJL1zS45hUtn4zj10/PjTSJDgXh6ihcUlO7mCgFc3Zq4La3YY62UHxKKbcB7Jqt4oHbuRZdwGSruUce300Gr8rP04i3Ax3rNYHAtSaXIErWMyi9qX6ewE62PvjiJGtlP4AxYTl6b0lZ9xZVrRDUVX8sxQRuM3B+zGD2NTFxlNldden179PiZMNtmkqjSnDStziwK8Ba1gZE2xaFJBseDFK6yX3jxRmSmA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 63.35.35.123) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uBdm1MRiRqqpHmaZfT6UOaI8T/vKVAAtjgsugempIbU=;
 b=KAb+KGI9Z23jH3l4Bbq3oyVcCHzN2/v+g8NLw4ojzoitZYiC41lI2zhMDNALZ9L1YrNgUl/HISmvb5JjhJHr7ZUNVlLCcMSBU4dXmVTdX+q2lu+sCd8x5VMCn63e2md3igH5y21+c4YK+8NLi6rj1iIWrwICXIM4tTmoWFutfAQ=
Received: from DU2PR04CA0039.eurprd04.prod.outlook.com (2603:10a6:10:234::14)
 by AM9PR08MB6276.eurprd08.prod.outlook.com (2603:10a6:20b:2d4::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.20; Fri, 11 Oct
 2024 16:22:36 +0000
Received: from DU2PEPF00028D06.eurprd03.prod.outlook.com
 (2603:10a6:10:234:cafe::5f) by DU2PR04CA0039.outlook.office365.com
 (2603:10a6:10:234::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.20 via Frontend
 Transport; Fri, 11 Oct 2024 16:22:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DU2PEPF00028D06.mail.protection.outlook.com (10.167.242.166) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8048.13
 via Frontend Transport; Fri, 11 Oct 2024 16:22:35 +0000
Received: ("Tessian outbound 0658930cd478:v473"); Fri, 11 Oct 2024 16:22:34 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: f651a13edeff2ba9
X-TessianGatewayMetadata: vKymkcsAP75eHoLcnw3inokIDTesRXTv8tLix4LVm/A+XaU+7/XfrzX7V1Rmg2qS3FxErPe9x8o4iW8ay/i2Hq5BC1mT20Yimw2orjpUEZ2Yyp12VsVNoKI9ow6WtXXNLIHbV0j5ePo992ofOyK1nQ8iOMczvr1Xvql1LAmQ5j0=
X-CR-MTA-TID: 64aa7808
Received: from Lf1451d181c08.2
	by 64aa7808-outbound-1.mta.getcheckrecipient.com id E497F276-C08B-44E3-9295-3FE0A98402A4.1;
	Fri, 11 Oct 2024 16:22:24 +0000
Received: from EUR03-VI1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id Lf1451d181c08.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Fri, 11 Oct 2024 16:22:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wiVktydkJy/Yzz33gU0XioYhpkxVifcVqo2SThcv4OpFBSsEnpyJJXQr4I1EPdlg4xOSzvPRKdOVbL210l62kHnh5Wa3Qyhr5nKwqsy1mniCe+JD1lxorhPGZ7L+6LPTXI7IYrY5KqRPDaZDzhJgzfhyZl0th1q/YzNk6ySPtt/VnwcfvB0ZZ7pErVaLVC7Hjg1ckV/B17WXfukY1rkHvpQzAeZ/nJGFLQeOrXZ8fZJyDMKxB1HZwQ9zOFjNqaTXL7ofJ/HOcCHX/eIkS8gn1nVGyc4xSFnDvZNZYWsKu60d+wGZGsaHvjo+cGHv5XUHj9J0kz5Tq/g2fp+zq7JlQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uBdm1MRiRqqpHmaZfT6UOaI8T/vKVAAtjgsugempIbU=;
 b=bmwnFctHKl2Gm8QH2spyXe3QrtMzmCCapyrwVOtgVnfqS99t+ZxfPXkJ1bWv/4JBwn5zJGsSyOzjvyWfw+xuFRIYPnSx1Md9fGjVcgzMTjkbJlB0B0rJNeeCQ4shxW0L8lrIUy7G+ZVaX9c40vO8h+g3p1pQmk4NI8iYXw/qGTdDlFUv40W5Ji1Dcm1nvsRqB4hHAYh1YdWPJvLCZ79aMK4Hx2kb3wyOZEAlFu3mDnX876JfaTNSqTi/2tfkrc9GQCKrHuaCLYp+H+Qt5PrgXnB5/gO8U2zXaNp5jIb9lL8Dm8NEvVNZ7LL8T79fBTKdL+GlRJRWl/Sg2XX7G/3Cng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uBdm1MRiRqqpHmaZfT6UOaI8T/vKVAAtjgsugempIbU=;
 b=KAb+KGI9Z23jH3l4Bbq3oyVcCHzN2/v+g8NLw4ojzoitZYiC41lI2zhMDNALZ9L1YrNgUl/HISmvb5JjhJHr7ZUNVlLCcMSBU4dXmVTdX+q2lu+sCd8x5VMCn63e2md3igH5y21+c4YK+8NLi6rj1iIWrwICXIM4tTmoWFutfAQ=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GVXPR08MB7727.eurprd08.prod.outlook.com (2603:10a6:150:6b::6)
 by AM8PR08MB6594.eurprd08.prod.outlook.com (2603:10a6:20b:36a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.20; Fri, 11 Oct
 2024 16:22:20 +0000
Received: from GVXPR08MB7727.eurprd08.prod.outlook.com
 ([fe80::9672:63f7:61b8:5469]) by GVXPR08MB7727.eurprd08.prod.outlook.com
 ([fe80::9672:63f7:61b8:5469%7]) with mapi id 15.20.8048.017; Fri, 11 Oct 2024
 16:22:20 +0000
Message-ID: <7a83461d-40fd-4e61-8833-5dae2abaf82b@arm.com>
Date: Fri, 11 Oct 2024 17:22:17 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 10/11] virt: arm-cca-guest: TSM_REPORT support for
 realms
Content-Language: en-GB
To: Steven Price <steven.price@arm.com>, Gavin Shan <gshan@redhat.com>,
 kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: Sami Mujawar <sami.mujawar@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, Dan Williams <dan.j.williams@intel.com>,
 "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20241004144307.66199-1-steven.price@arm.com>
 <20241004144307.66199-11-steven.price@arm.com>
 <5a3432d1-6a79-434c-bc93-6317c8c6435c@redhat.com>
 <6c306817-fbd7-402c-8425-a4523ed43114@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <6c306817-fbd7-402c-8425-a4523ed43114@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P265CA0043.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ac::22) To GVXPR08MB7727.eurprd08.prod.outlook.com
 (2603:10a6:150:6b::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GVXPR08MB7727:EE_|AM8PR08MB6594:EE_|DU2PEPF00028D06:EE_|AM9PR08MB6276:EE_
X-MS-Office365-Filtering-Correlation-Id: c02d049d-b705-4d60-0d55-08dcea10ea97
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?b3NhY3c4eCtIZHo2ZjdhSlNqVDBGOWNtN3pPTndDV2FSNURxS1JLc1Q1b0pO?=
 =?utf-8?B?TEdYZ1JKYmRlcFVyOGkrM1o4R1RQbzJDRkJndVNJOVZWcG8vZmxEYWEvZVU5?=
 =?utf-8?B?K25sN3M5VUw4SFhCT24zL2tnSFEvTm4zT2N0NmxUSC95VjgzS0ZnV000Z0No?=
 =?utf-8?B?NXdNaG5vbXptandDZU93RlQzWWxuOEVra2FBU1VQQzJoV3NQUXJ3L2M3MTh3?=
 =?utf-8?B?YThpd0VCTHpncjJQSzg1bzRmK3NpWkNIZG1HWDJPb3BFbEt4OVVzUWZub01w?=
 =?utf-8?B?WmdMaWlVbXRMQ1dHQUZCV05PY1RwdFI3RjdCU2h4V2pHVVZ5cnA3Zkw2ZlRr?=
 =?utf-8?B?eWtBN1lNaDRPY0ovTWRlZHF3bEs1OFFFaG1YZWZmTG9BNWZNOWZQelcyT3hD?=
 =?utf-8?B?VHBXcXZROEVjaVRxbi9qNzlITUk1MlJ1VUJFbGVVTlYrL3dKTEFDb3g2bDRY?=
 =?utf-8?B?R3ZCSWxLZWtsbFVMMmZEOEFJVnVxTXo2M1pMNTZ3dGlDRW5USW43S3VqTVVB?=
 =?utf-8?B?dHRvODZFd2dFbWpkbVVMUXpZbGJzK0RwVFB2N0hoNWNLQlA1eTBvc0lNOTU5?=
 =?utf-8?B?NC91K0F4eW5xc05pVTJiRmtFbk9ZR2JzZjU2REFhSjFNb2pXdWRLWFFYbzdR?=
 =?utf-8?B?K25TQVZnUHF4L2xIdXcyNDFZUndLeFF6eUdScHY4OHhaQ04yK1BKSGFYclRx?=
 =?utf-8?B?bEZJM0tDd1J4OExueGRhcHp2N0hpVSswQXdad2ZjT1ZXSUxOaDJrUWZ6M1VT?=
 =?utf-8?B?TzVzK3FidkFLbitkREQ5dWVTQ3Y5Q3p4K2crcTBoZVhuVFpTMHpibDNBUkJ0?=
 =?utf-8?B?Z09LMkJReWlpVTZuTjJMS1c4SE5BRjdJazZOa1NBTUNUUmRhekxHYk0wL2RP?=
 =?utf-8?B?U0FvZ1dWZU81UDEza2N6bFByY05JRThYVUNzNzFCWGVBZW5IKytVbHJpWXhG?=
 =?utf-8?B?ck1wTUUwMWgrOHRNM3ZuQUhBaFVnYVhtd01wdUMreDdydmdFR3lLZHk0SW8x?=
 =?utf-8?B?UlNHSTJkYXBvU0tpUEFXL3JyUElvSHpCaU9ydzh1dkd1b213UXlJSTR5eUxS?=
 =?utf-8?B?QTJMWWhWcTNqL1hnMUxXUk10bFJ5QW1URittVDdaL29xUklEajl2ZXdPb09u?=
 =?utf-8?B?Z29FcjVxcEhKRlJEOUdhaEpxZVJhSENkUTJDUDlhNytJZWxKZ1lVU0ZRcUox?=
 =?utf-8?B?WFN6NGZlWTBKQjhnNzd4SjlmZS9aaHU3enAxY2l2U3VUUXNEbkkvU1RNQmJn?=
 =?utf-8?B?WWtEVGg3emg1TkVPRzF6bTdLaVUraG5aa0tDcnlYOGZCaytxckRaTzhFOFJL?=
 =?utf-8?B?VFZWalpITW1yeS9ybG80QWovR2VlZjZ5VSttTnViSmFhWnU4SGZ0V3MrZHU2?=
 =?utf-8?B?RkpDYzlLMzAwcVRBbTg1K2lScE1yTUl5WW1QWjFXNlR6NVlpcmlub1VWckJG?=
 =?utf-8?B?R1NST3BnWTNHNG9Odkp3RnYyem5LRFVwbzAvTDNmaEszNkhucFh5N3JrUWJo?=
 =?utf-8?B?YmZ4bVVxRks4NHVaUTQ1clJ3MmRDcFFXZGhLcXJ0R2ZRVXdvUVlSTk1iMmhL?=
 =?utf-8?B?UEFicW1SMmx5VzF2djBlWEt0RXpiWHhYS1pXY2dyRXppRElPWHBjWGdpcjBq?=
 =?utf-8?B?R2FHc3c5SGRKOEN6Vm9PelpoVC9ldUlBNzVmSm9KamVDWDQreGVIZXZ0cFds?=
 =?utf-8?B?NmlDbHVhVDROQUNKcEgyWjZxMkhQVUNLeDFNQjMzbzE4eFpEL0tKWFlBPT0=?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GVXPR08MB7727.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB6594
Original-Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-SkipListedInternetSender:
 ip=[2603:10a6:150:6b::6];domain=GVXPR08MB7727.eurprd08.prod.outlook.com
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028D06.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	f903a1c5-037c-4ec1-c6ea-08dcea10e128
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|376014|1800799024|35042699022;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?M25haXpUdWlrNkRoZlN4bkNNY1hsSm9KdFltUUVEWXpZODEzemdPLzBlVWhG?=
 =?utf-8?B?VkZYTUQ2K0xPL0thb3JTYi9XeVNYQVRGbmZSYi9XWnlzdW40VlZDemc1RUVI?=
 =?utf-8?B?VytjWThKQWpQeWZHRkVlV1dhRExla2hKZmhKZi92ZHQ0VzhBSUN0Z0FNK2Fz?=
 =?utf-8?B?c3JMSkhhTWNaZm4yVk5Yb2duWkFLNkFoaG1QV2ZmT2NoYi94SjNRZWxwNFRa?=
 =?utf-8?B?UXcxbk5NSU1HUGZHdFRpK085KzFRcU0rM1NRTzN1WG1GTEdBSVd3ZURvVFVR?=
 =?utf-8?B?UG5kNHNJSFgxbDFlcmt6dlc5TDNVd0dvNTVEZkZxN0FiTUx6MloySlJtTVVU?=
 =?utf-8?B?WVV0VXI2ekRpekhvbnhWSVI0VW85SnJFZHdBNk0yYk1xTTRhYm1BVDBJT041?=
 =?utf-8?B?dTVlZTNBUDlOWlQwVDkzZzNpUHMvR1pCak9QSzIxc0xQalFiQlVQejY5RU1Q?=
 =?utf-8?B?ODJtemhzY1ZXelVzaUwyWGg3MEJNV0VtdG4zRE83Yk5wVEJsbVBuTlltc3lM?=
 =?utf-8?B?TGI1MnZZQ0x3bmdwOEF3QnB5aUtxR2xKaHNlSWxXaXozS0xISk5ibERlaGtS?=
 =?utf-8?B?ZktyLzc0U0ZMMkJkNE5aRWZNY0pvaXJzL2xMR3JBTlFUVjhFZkU2SW8vN0c3?=
 =?utf-8?B?Z1ROZnJJVmdFVjY5SUpCUE1pUWZ4clFwSzdmNGRLZUZFTzFod2Nqc2t0bFAx?=
 =?utf-8?B?UU1yWDlISHV5azNiOEs2RzduV3lxQ1A2dU9xektsWXhxQmpEK0llb1c4NVpE?=
 =?utf-8?B?N1F5dXZZd29IRkNmOVJNeDRGSTdwWEZDNmhZVHlzN09pMEJxWEVMYzR6M0Yy?=
 =?utf-8?B?VWllZFBjYjIxRVlDZDd6RW85Sk90OGhkUVVVdFYyM3R3Q2VTVGtXYTM0TlJs?=
 =?utf-8?B?cGo1dHppUVRkVlhMZ0cyME9uOWRMR3doWXJ2NllxRzhrQkVJWjJGQldBTW1z?=
 =?utf-8?B?UjA2dUc3b093enlIanl5Y1liSm9qUlRncU00S25QM2MrM0d5NFB2UW92TVhY?=
 =?utf-8?B?eEFlcDY0d0pycTlsOUtiT1BqdGRwRUc2dlRBT25QODBzdXhrUU1VS1g3MVFx?=
 =?utf-8?B?SHpTWWlHRURiNThkd3JjNXJybDF5TmVBMndxT2lOdUdPdExuUjJ5alQycWZL?=
 =?utf-8?B?Y2ZDMGhZOUh6a3FUblJJOTVkbWVTZWhyUEs5VnFNdWE0ck9ES0dtYndDbVlV?=
 =?utf-8?B?TDFwczBGTFA2QzZOaE9mVTNiQ3UzbnVMN1ova0dqUjdJWmtjdTVHYUEyWW03?=
 =?utf-8?B?eEZyZjFjdk42K1VwbEhEcmdRUjh1b24xcXR4RHVOZFNKT0lMUHJWb1N2bVJu?=
 =?utf-8?B?WEVyZWpmT2dhbWVLelErZSszNHc2TGV2WGVuUG8zOHk5V0RsYUwza0JWU3ZD?=
 =?utf-8?B?dXFDaGxkZzltdllja20vWk1LbW4wOVRBb2xsU0dnWUk3ZWV0UG1FNjdDcUxZ?=
 =?utf-8?B?eVhIUDZMbmVYUGZGN1FHTFhDRGdncXNrVU4vUHZHQ3ZEQkRhZVEyOEFEUy8y?=
 =?utf-8?B?WnplL0QvSmNQcDlLQWp2SVpEblZ1dGNBUi9qeGJtRUp5VU5VcTlhUHM0TGQ0?=
 =?utf-8?B?N3NJdEhsK01vYm16bjNhd0NPOHQxTmdnNEREeDI3eGZ1Y0tWMnBrOGR3OE9C?=
 =?utf-8?B?VTdicEdwR3FHQzlneHlSYkNwODN0NGE0MUJsN2oyOEovcHBFR0wvTzd1NTBG?=
 =?utf-8?B?MzlGOGZabkk3Zm9MWEEybXJ2cm5KaVZtK3kwc0pyTnl0ZVNOc2RLMXU1TWtR?=
 =?utf-8?B?bG9PWkdtWm53M3RhNW02Q25WQmdVaUlmaWtmcnI1dDZwaHF6dVEraEpUNTJw?=
 =?utf-8?B?MzJlSEpCVGwvSDc1Wmt3Uzd3NGpaOGlqUDBadGxNS0UyYXVWTnc5K09wb05D?=
 =?utf-8?Q?DLEKgi7q1SCSI?=
X-Forefront-Antispam-Report:
	CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(376014)(1800799024)(35042699022);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2024 16:22:35.5599
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c02d049d-b705-4d60-0d55-08dcea10ea97
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D06.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR08MB6276

On 11/10/2024 15:14, Steven Price wrote:
> On 08/10/2024 05:12, Gavin Shan wrote:
>> On 10/5/24 12:43 AM, Steven Price wrote:
>>> From: Sami Mujawar <sami.mujawar@arm.com>
>>>
>>> Introduce an arm-cca-guest driver that registers with
>>> the configfs-tsm module to provide user interfaces for
>>> retrieving an attestation token.
>>>
>>> When a new report is requested the arm-cca-guest driver
>>> invokes the appropriate RSI interfaces to query an
>>> attestation token.
>>>
>>> The steps to retrieve an attestation token are as follows:
>>>     1. Mount the configfs filesystem if not already mounted
>>>        mount -t configfs none /sys/kernel/config
>>>     2. Generate an attestation token
>>>        report=/sys/kernel/config/tsm/report/report0
>>>        mkdir $report
>>>        dd if=/dev/urandom bs=64 count=1 > $report/inblob
>>>        hexdump -C $report/outblob
>>>        rmdir $report
>>>
>>> Signed-off-by: Sami Mujawar <sami.mujawar@arm.com>
>>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>>> Signed-off-by: Steven Price <steven.price@arm.com>
>>> ---
>>> v3: Minor improvements to comments and adapt to the renaming of
>>> GRANULE_SIZE to RSI_GRANULE_SIZE.
>>> ---
>>>    drivers/virt/coco/Kconfig                     |   2 +
>>>    drivers/virt/coco/Makefile                    |   1 +
>>>    drivers/virt/coco/arm-cca-guest/Kconfig       |  11 +
>>>    drivers/virt/coco/arm-cca-guest/Makefile      |   2 +
>>>    .../virt/coco/arm-cca-guest/arm-cca-guest.c   | 211 ++++++++++++++++++
>>>    5 files changed, 227 insertions(+)
>>>    create mode 100644 drivers/virt/coco/arm-cca-guest/Kconfig
>>>    create mode 100644 drivers/virt/coco/arm-cca-guest/Makefile
>>>    create mode 100644 drivers/virt/coco/arm-cca-guest/arm-cca-guest.c
>>>
>>> diff --git a/drivers/virt/coco/Kconfig b/drivers/virt/coco/Kconfig
>>> index d9ff676bf48d..ff869d883d95 100644
>>> --- a/drivers/virt/coco/Kconfig
>>> +++ b/drivers/virt/coco/Kconfig
>>> @@ -14,3 +14,5 @@ source "drivers/virt/coco/pkvm-guest/Kconfig"
>>>    source "drivers/virt/coco/sev-guest/Kconfig"
>>>      source "drivers/virt/coco/tdx-guest/Kconfig"
>>> +
>>> +source "drivers/virt/coco/arm-cca-guest/Kconfig"
>>> diff --git a/drivers/virt/coco/Makefile b/drivers/virt/coco/Makefile
>>> index b69c30c1c720..c3d07cfc087e 100644
>>> --- a/drivers/virt/coco/Makefile
>>> +++ b/drivers/virt/coco/Makefile
>>> @@ -7,3 +7,4 @@ obj-$(CONFIG_EFI_SECRET)    += efi_secret/
>>>    obj-$(CONFIG_ARM_PKVM_GUEST)    += pkvm-guest/
>>>    obj-$(CONFIG_SEV_GUEST)        += sev-guest/
>>>    obj-$(CONFIG_INTEL_TDX_GUEST)    += tdx-guest/
>>> +obj-$(CONFIG_ARM_CCA_GUEST)    += arm-cca-guest/
>>> diff --git a/drivers/virt/coco/arm-cca-guest/Kconfig
>>> b/drivers/virt/coco/arm-cca-guest/Kconfig
>>> new file mode 100644
>>> index 000000000000..9dd27c3ee215
>>> --- /dev/null
>>> +++ b/drivers/virt/coco/arm-cca-guest/Kconfig
>>> @@ -0,0 +1,11 @@
>>> +config ARM_CCA_GUEST
>>> +    tristate "Arm CCA Guest driver"
>>> +    depends on ARM64
>>> +    default m
>>> +    select TSM_REPORTS
>>> +    help
>>> +      The driver provides userspace interface to request and
>>> +      attestation report from the Realm Management Monitor(RMM).
>>> +
>>> +      If you choose 'M' here, this module will be called
>>> +      arm-cca-guest.
>>> diff --git a/drivers/virt/coco/arm-cca-guest/Makefile
>>> b/drivers/virt/coco/arm-cca-guest/Makefile
>>> new file mode 100644
>>> index 000000000000..69eeba08e98a
>>> --- /dev/null
>>> +++ b/drivers/virt/coco/arm-cca-guest/Makefile
>>> @@ -0,0 +1,2 @@
>>> +# SPDX-License-Identifier: GPL-2.0-only
>>> +obj-$(CONFIG_ARM_CCA_GUEST) += arm-cca-guest.o
>>> diff --git a/drivers/virt/coco/arm-cca-guest/arm-cca-guest.c
>>> b/drivers/virt/coco/arm-cca-guest/arm-cca-guest.c
>>> new file mode 100644
>>> index 000000000000..e22a565cb425
>>> --- /dev/null
>>> +++ b/drivers/virt/coco/arm-cca-guest/arm-cca-guest.c
>>> @@ -0,0 +1,211 @@
>>> +// SPDX-License-Identifier: GPL-2.0-only
>>> +/*
>>> + * Copyright (C) 2023 ARM Ltd.
>>> + */
>>> +
>>> +#include <linux/arm-smccc.h>
>>> +#include <linux/cc_platform.h>
>>> +#include <linux/kernel.h>
>>> +#include <linux/module.h>
>>> +#include <linux/smp.h>
>>> +#include <linux/tsm.h>
>>> +#include <linux/types.h>
>>> +
>>> +#include <asm/rsi.h>
>>> +
>>> +/**
>>> + * struct arm_cca_token_info - a descriptor for the token buffer.
>>> + * @granule:    PA of the page to which the token will be written
>>                        ^^^^^^^^
>>
>> s/the page/the granule. They are same thing when we have 4KB page size,
>> but there are conceptually different if I'm correct.
> 
> Indeed they are different, the granule is always 4KB, the host (and
> guest) page size could be bigger (although that's not yet supported).
> 
> Here 'granule' does indeed point to a (host) page (because it's returned
> from alloc_pages_exact()), but that's just a confusing detail.
> 
> I'll update as you suggest.
> 
>>> + * @offset:    Offset within granule to start of buffer in bytes
>>> + * @len:    Number of bytes of token data that was retrieved
>>> + * @result:    result of rsi_attestation_token_continue operation
>>> + */
>>> +struct arm_cca_token_info {
>>> +    phys_addr_t     granule;
>>> +    unsigned long   offset;
>>> +    int             result;
>>> +};
>>> +
>>> +/**
>>> + * arm_cca_attestation_continue - Retrieve the attestation token data.
>>> + *
>>> + * @param: pointer to the arm_cca_token_info
>>> + *
>>> + * Attestation token generation is a long running operation and
>>> therefore
>>> + * the token data may not be retrieved in a single call. Moreover, the
>>> + * token retrieval operation must be requested on the same CPU on
>>> which the
>>> + * attestation token generation was initialised.
>>> + * This helper function is therefore scheduled on the same CPU multiple
>>> + * times until the entire token data is retrieved.
>>> + */
>>> +static void arm_cca_attestation_continue(void *param)
>>> +{
>>> +    unsigned long len;
>>> +    unsigned long size;
>>> +    struct arm_cca_token_info *info;
>>> +
>>> +    if (!param)
>>> +        return;
>>
>> This check seems unnecessary and can be dropped.
> 
> Ack
> 
>>> +
>>> +    info = (struct arm_cca_token_info *)param;
>>> +
>>> +    size = RSI_GRANULE_SIZE - info->offset;
>>> +    info->result = rsi_attestation_token_continue(info->granule,
>>> +                              info->offset, size, &len);
>>> +    info->offset += len;
>>> +}
>>> +
>>
>> As I suggested in another reply, the return value type of
>> rsi_attestation_token_continue()
>> needs to be 'unsigned long'. In that case, the type of struct
>> arm_cca_token_info::result
>> needs to be adjusted either.
> 
> Ack
> 
>>> +/**
>>> + * arm_cca_report_new - Generate a new attestation token.
>>> + *
>>> + * @report: pointer to the TSM report context information.
>>> + * @data:  pointer to the context specific data for this module.
>>> + *
>>> + * Initialise the attestation token generation using the challenge data
>>> + * passed in the TSM descriptor. Allocate memory for the attestation
>>> token
>>> + * and schedule calls to retrieve the attestation token on the same CPU
>>> + * on which the attestation token generation was initialised.
>>> + *
>>> + * The challenge data must be at least 32 bytes and no more than 64
>>> bytes. If
>>> + * less than 64 bytes are provided it will be zero padded to 64 bytes.
>>> + *
>>> + * Return:
>>> + * * %0        - Attestation token generated successfully.
>>> + * * %-EINVAL  - A parameter was not valid.
>>> + * * %-ENOMEM  - Out of memory.
>>> + * * %-EFAULT  - Failed to get IPA for memory page(s).
>>> + * * A negative status code as returned by smp_call_function_single().
>>> + */
>>> +static int arm_cca_report_new(struct tsm_report *report, void *data)
>>> +{
>>> +    int ret;
>>> +    int cpu;
>>> +    long max_size;
>>> +    unsigned long token_size;
>>> +    struct arm_cca_token_info info;
>>> +    void *buf;
>>> +    u8 *token __free(kvfree) = NULL;
>>> +    struct tsm_desc *desc = &report->desc;
>>> +
>>> +    if (!report)
>>> +        return -EINVAL;
>>> +
>>
>> This check seems unnecessary and can be dropped.
> 
> Ack
> 
>>> +    if (desc->inblob_len < 32 || desc->inblob_len > 64)
>>> +        return -EINVAL;
>>> +
>>> +    /*
>>> +     * Get a CPU on which the attestation token generation will be
>>> +     * scheduled and initialise the attestation token generation.
>>> +     */
>>> +    cpu = get_cpu();
>>> +    max_size = rsi_attestation_token_init(desc->inblob,
>>> desc->inblob_len);
>>> +    put_cpu();
>>> +
>>
>> It seems that put_cpu() is called early, meaning the CPU can go away before
>> the subsequent call to arm_cca_attestation_continue() ?
> 
> Indeed, good spot. I'll move it to the end of the function and update
> the error paths below.

Actually this was on purpose, not to block the CPU hotplug. The
attestation must be completed on the same CPU.

We can detect the failure from "smp_call" further down and make sure
we can safely complete the operation or restart it.



Suzuki

> 
>>> +    if (max_size <= 0)
>>> +        return -EINVAL;
>>> +
>>> +    /* Allocate outblob */
>>> +    token = kvzalloc(max_size, GFP_KERNEL);
>>> +    if (!token)
>>> +        return -ENOMEM;
>>> +
>>> +    /*
>>> +     * Since the outblob may not be physically contiguous, use a page
>>> +     * to bounce the buffer from RMM.
>>> +     */
>>> +    buf = alloc_pages_exact(RSI_GRANULE_SIZE, GFP_KERNEL);
>>> +    if (!buf)
>>> +        return -ENOMEM;
>>> +
>>> +    /* Get the PA of the memory page(s) that were allocated. */
>>> +    info.granule = (unsigned long)virt_to_phys(buf);
>>> +
>>> +    token_size = 0;
>>
>> This initial assignment can be moved to where the variable is declared.
> 
> Ack
> 
>>> +    /* Loop until the token is ready or there is an error. */
>>                                                               ^^
>>
>> Maybe it's the personal preference, I personally prefer to avoid the ending
>> character '.' for the single line of comment.
> 
> I agree, my preference is the same. I'll update this.
> 
>>> +    do {
>>> +        /* Retrieve one RSI_GRANULE_SIZE data per loop iteration. */
>>> +        info.offset = 0;
>>> +        do {
>>> +            /*
>>> +             * Schedule a call to retrieve a sub-granule chunk
>>> +             * of data per loop iteration.
>>> +             */
>>> +            ret = smp_call_function_single(cpu,
>>> +                               arm_cca_attestation_continue,
>>> +                               (void *)&info, true);
>>> +            if (ret != 0) {
>>> +                token_size = 0;
>>> +                goto exit_free_granule_page;
>>> +            }
>>> +
>>> +            ret = info.result;
>>> +        } while ((ret == RSI_INCOMPLETE) &&
>>> +             (info.offset < RSI_GRANULE_SIZE));
>>
>> It may be clearer to use 'info.result' here. Besides, unnecessary () exists
>> in the check.
>>
>>                  } while (info.result == RSI_INCOMPLETE &&
>>                           info.offset < RSI_GRANULE_SIZE);
> 
> Sure
> 
>> Apart from that, we needn't to copy the token over when info.result isn't
>> RSI_SUCCESS nor RSI_INCOMPLETE.
> 
> I'll move the error case up to avoid the copy.
> 
>>> +
>>> +        /*
>>> +         * Copy the retrieved token data from the granule
>>> +         * to the token buffer, ensuring that the RMM doesn't
>>> +         * overflow the buffer.
>>> +         */
>>> +        if (WARN_ON(token_size + info.offset > max_size))
>>> +            break;
>>> +        memcpy(&token[token_size], buf, info.offset);
>>> +        token_size += info.offset;
>>> +    } while (ret == RSI_INCOMPLETE);
>>> +
>>
>> As above, it may be clearer to use 'info.result' in the check.
>>
>>          } while (info.result == RSI_INCOMPLETE);
> 
> Ack
> 
>>> +    if (ret != RSI_SUCCESS) {
>>> +        ret = -ENXIO;
>>> +        token_size = 0;
>>> +        goto exit_free_granule_page;
>>> +    }
>>> +
>>> +    report->outblob = no_free_ptr(token);
>>> +exit_free_granule_page:
>>> +    report->outblob_len = token_size;
>>> +    free_pages_exact(buf, RSI_GRANULE_SIZE);
>>> +    return ret;
>>> +}
>>> +
>>> +static const struct tsm_ops arm_cca_tsm_ops = {
>>> +    .name = KBUILD_MODNAME,
>>> +    .report_new = arm_cca_report_new,
>>> +};
>>> +
>>> +/**
>>> + * arm_cca_guest_init - Register with the Trusted Security Module (TSM)
>>> + * interface.
>>> + *
>>> + * Return:
>>> + * * %0        - Registered successfully with the TSM interface.
>>> + * * %-ENODEV  - The execution context is not an Arm Realm.
>>> + * * %-EINVAL  - A parameter was not valid.
>>> + * * %-EBUSY   - Already registered.
>>> + */
>>> +static int __init arm_cca_guest_init(void)
>>> +{
>>> +    int ret;
>>> +
>>> +    if (!is_realm_world())
>>> +        return -ENODEV;
>>> +
>>> +    ret = tsm_register(&arm_cca_tsm_ops, NULL);
>>> +    if (ret < 0)
>>> +        pr_err("Failed to register with TSM.\n");
>>> +
>>> +    return ret;
>>> +}
>>> +module_init(arm_cca_guest_init);
>>> +
>>
>> It's probably a bit helpful to print the errno returned from
>> tsm_register().
>>
>>    pr_err("Error %d registering with TSM\n", ret);
>>
>> The only errno that can be returned from tsm_register() is -EBUSY. So there
>> is no way for arm_cca_guest_init() to return -EINVAL. The comments need
>> correction by dropping the description relevant to -EINVAL.
> 
> Ack
> 
>>> +/**
>>> + * arm_cca_guest_exit - unregister with the Trusted Security Module
>>> (TSM)
>>> + * interface.
>>> + */
>>> +static void __exit arm_cca_guest_exit(void)
>>> +{
>>> +    tsm_unregister(&arm_cca_tsm_ops);
>>> +}
>>> +module_exit(arm_cca_guest_exit);
>>> +
>>> +MODULE_AUTHOR("Sami Mujawar <sami.mujawar@arm.com>");
>>> +MODULE_DESCRIPTION("Arm CCA Guest TSM Driver.");
>>> +MODULE_LICENSE("GPL");
>>
>> The ending character '.' for the module's description may not be needed
>> and can be
>> dropped.
> 
> Ack.
> 
> Thanks for the review!
> 
> Steve
> 


