Return-Path: <kvm+bounces-28865-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 91ED299E31B
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 11:51:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B478A1C20EC6
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 09:51:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C36C91E5018;
	Tue, 15 Oct 2024 09:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="V198M1GC";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="V198M1GC"
X-Original-To: kvm@vger.kernel.org
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2057.outbound.protection.outlook.com [40.107.21.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 272CE1E3DE8;
	Tue, 15 Oct 2024 09:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.21.57
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728985835; cv=fail; b=PdUQ7OOabdK0FBqL04cOtFGv+0z2MpHOCSuzU0E3N9eahmEsnDmvq5ijObKzlZ1XR3ofvvWzASSwiK4UTJ72sl9c8i90b0Q4ZWAPoBHd5xC3MiCCK7yiYZuqTuZ0clan9x7qEYzYnVgHIShrbypKKxisgFGy9skIz645NnCNSxI=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728985835; c=relaxed/simple;
	bh=vUbDwPDWuiRhAFzxehmVe8id1VXWxHNjRCSkQ3LDylc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=sbpKKELz87XPRSr/ZNZwL/V+oykEExaago7AHXdbWIY0IxBIy2Gz+uhP3W2D0T99XDDBfJn+yiroTayQIjMraqnqWbRzL/yk3qE2e6KjcZOUO2Od/zG07lw7+ILQOBYXLekK/ZLyxpJ232jI1maWrOPy5iH0gr1ufPRTblxl5/Q=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=V198M1GC; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=V198M1GC; arc=fail smtp.client-ip=40.107.21.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=Q2x64mlkP3di8gutL+hJCwqRG6+di9GnpAXH7GOvbglOgeLHl7AJ4flCJOhI3rdLf+91B0VhCTVOeQxdK290Gvp02iQsaTd2Avq4nHk/gnq8xDNtRdjTp40+k8rvJI8xWiB5fM9eeLLX6xPs7JUZlUCHrZW05thijujv/Mr6dCEjtTsLzdT32ZSe3KBr38BygpBesfG7LC6weFktz4VhfiSzgI43UVXM9gszoEahVq0FyU7J3av1YkB2DfJOE0ZaU0Y/HxW06Ohmyis+KAe+4STjw6eCljFwr4XpFmRdAAlNgLCbgPlhw5Nycs8Q7SrBjGTA83pnKDKP/cGq+TkLag==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=daXcSnSOEWCZYclq34WAAKgKmwcD5Zla5crGi7XaVX8=;
 b=KYei9FF9MtcEbkK/sshYj24qP4uYFH7O9xx35zgLpoWyE/FxKQMZwXbsUJOl2VLpqOZsbSgS1bZjNFStQrXqe7sO4vp31VEXE/qsweQl5aYIJSmI+DFLAh/WLuWkjXqKw8oRnh13H2/XzImMxF/QL/BVDT+VOz5X6O5WXE2oJPT75m4zfQP0BYPNIBWLe7l7AXq1JpJRm1m5zBpK34dgGXBTDWQ4zweQ5i2E84wds3U9EIcM+OIIWeSgkdrYn5brvC0jg4y8coPG5Z1JVp4553bqCI+YhQmKKi/pLJV5749zDc1nBqOdB/eOVQwzeR7nGrOm8DRGpvjl16UKmEGnbg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 63.35.35.123) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=daXcSnSOEWCZYclq34WAAKgKmwcD5Zla5crGi7XaVX8=;
 b=V198M1GCw4oVm490TAbvH/kzj1BMFeceGhPmN7VyYJhl8JqsHZhZAMjNvsRwTnaAsRZ3LKN0EQzho4zOK+xdYayP9W+31ATa3tDpVZ8CX0ZJVcYLdwOd10sXeVxKRLDeyy+TPCNwtEyQ39TkkVkaLRLjN4Yrkhadggo6bJeOTqc=
Received: from DUZPR01CA0295.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b7::11) by AS8PR08MB9361.eurprd08.prod.outlook.com
 (2603:10a6:20b:5a8::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.26; Tue, 15 Oct
 2024 09:50:28 +0000
Received: from DU6PEPF0000A7E3.eurprd02.prod.outlook.com
 (2603:10a6:10:4b7:cafe::f5) by DUZPR01CA0295.outlook.office365.com
 (2603:10a6:10:4b7::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.27 via Frontend
 Transport; Tue, 15 Oct 2024 09:50:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DU6PEPF0000A7E3.mail.protection.outlook.com (10.167.8.41) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8069.17 via
 Frontend Transport; Tue, 15 Oct 2024 09:50:27 +0000
Received: ("Tessian outbound de6fe3af73ff:v473"); Tue, 15 Oct 2024 09:50:26 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 9e4ba14d390810ea
X-TessianGatewayMetadata: 38I3scu9nUjdit9UgGg41MgVfCfJuoKWrrNyRyf589mN8RGf6qOhTa/B+Xv69xcIS7rMBSyqzjDJZM2wJksMO7Yn3aVCzF0+FAyhL/uFhjfT/wY0u2wOQtoEmEUi0k2tL10I3joiRWyOojiUyIeqSYy5CjvwRYkUnFS5HBGYv+0=
X-CR-MTA-TID: 64aa7808
Received: from L55565543ef01.1
	by 64aa7808-outbound-1.mta.getcheckrecipient.com id 91022FBA-2715-4296-98A4-4F0780517350.1;
	Tue, 15 Oct 2024 09:50:14 +0000
Received: from EUR02-AM0-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id L55565543ef01.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Tue, 15 Oct 2024 09:50:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=COerVVTaQ8SHBuiPoYFSt/kDuBu136bU7IuOEk0d3QoO1gePMi5YSSZm1BLkiLk3/teWwqj/9SUURYFfA33CR22BCUq2rO1pFfdFyesnDF1B83q9yXlOEv+nERgqJqmlPTGOmTDwG8bI7ML4rFODUKfmrvG5G5zxFeGux+QX+VEKCN/q1N+51D3nxAnLRpwgmxYqoN5AVXnDcY1vX/Xfll1HflY5z1ws0ivQkkP51ZqdBrEK0hB7crAVkJCF8BNz+ZefcRY1lVGZzR7ye/NrZjRKpcOFI+isOgTsS2bGp9QHaO/p3I8DsZbx/YTaBJhrGQqMXCBmSlYOTBCuIBviJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=daXcSnSOEWCZYclq34WAAKgKmwcD5Zla5crGi7XaVX8=;
 b=ZE0v1hhsaA/ALwv5opEe7hjE7AqnPaMZ7rzlUueRixcfseS6zFEvzBIJohAurzoAbYG4xyBK0p+KuI3diBYumn+N3+SO0r9Vbpb9OOr1me0GWSf0wPscIxVoomzVlfXi3yBFOvbNZAPBhNidd0GK34Ls8z/4FR/gNsxsMEGXb9WZpXVaovPXUoXJbrWobVMIY8JJwgYOY/lnbVikhMSsVZ58v8Z/AwfiWbqcCbwWjCng2vqx/+HAijXJHA7zSNYxCCFJTp2McqN3CdvrvS1WVPk+RSaa/bPXkoYP+SGz5B8wiqX0pt6IjZk07yTHwqqf0+vJNwrghSepmFkCUIvJFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=daXcSnSOEWCZYclq34WAAKgKmwcD5Zla5crGi7XaVX8=;
 b=V198M1GCw4oVm490TAbvH/kzj1BMFeceGhPmN7VyYJhl8JqsHZhZAMjNvsRwTnaAsRZ3LKN0EQzho4zOK+xdYayP9W+31ATa3tDpVZ8CX0ZJVcYLdwOd10sXeVxKRLDeyy+TPCNwtEyQ39TkkVkaLRLjN4Yrkhadggo6bJeOTqc=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GVXPR08MB7727.eurprd08.prod.outlook.com (2603:10a6:150:6b::6)
 by DU0PR08MB9846.eurprd08.prod.outlook.com (2603:10a6:10:445::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.26; Tue, 15 Oct
 2024 09:50:12 +0000
Received: from GVXPR08MB7727.eurprd08.prod.outlook.com
 ([fe80::9672:63f7:61b8:5469]) by GVXPR08MB7727.eurprd08.prod.outlook.com
 ([fe80::9672:63f7:61b8:5469%7]) with mapi id 15.20.8048.020; Tue, 15 Oct 2024
 09:50:11 +0000
Message-ID: <af109240-ae77-470c-9d10-046890754e6d@arm.com>
Date: Tue, 15 Oct 2024 10:50:09 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 08/11] arm64: mm: Avoid TLBI when marking pages as
 valid
Content-Language: en-GB
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
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
 <20241004144307.66199-9-steven.price@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20241004144307.66199-9-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0190.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a4::15) To GVXPR08MB7727.eurprd08.prod.outlook.com
 (2603:10a6:150:6b::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GVXPR08MB7727:EE_|DU0PR08MB9846:EE_|DU6PEPF0000A7E3:EE_|AS8PR08MB9361:EE_
X-MS-Office365-Filtering-Correlation-Id: 5bd763e0-7659-4d6b-aaa2-08dcecfecc5e
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?TXB0V0ZaRWl6SFBCbkEvZW9WMWhvNzVjK2ZBR0l1RDBLbi9ibnFJQTAycE40?=
 =?utf-8?B?RUozMkkvNi9tMmh0L05YdHZONFlJVFphY2czMFdxUHpEa1hHZzk5Q2Y2MmFa?=
 =?utf-8?B?RjlqM04xc0VVeVNZc3NEQVNjeDNYY3krSUx2cG12MXpZa2FJUlNiSjVVUXl0?=
 =?utf-8?B?NCtLekFmMG9JNnVxZE9SeTVtSjFZMTIzNGxXL3lPWlprTG1iV1V6WTg4bFR4?=
 =?utf-8?B?KzVoek9SWHk0U3M2bHN3M3owMXJQRFQraVkyNTBnZDZ3aTFIN1RYK2Rndjd2?=
 =?utf-8?B?SjlJdWs3MnE2NDhPNlBrd0ZWUHhDTHpqK0FGcnQ1YUlsRFNRVWVnajVGemls?=
 =?utf-8?B?Z2dGejhtUlVzZ3Jxc0JKK0lidmtXcW0rQTVLTzV3dW5SeDJjWFhsdTBwblU1?=
 =?utf-8?B?ZWs5QjVQNzY0WDE1QkI5bUhxckh2eUtGRkw5ZlpXM0FYcmVIU21MZDl0ekI1?=
 =?utf-8?B?am5oSHlJeUgzd0J5Zlo3UDBzLzJTVXVPdFdRbDBhRTU3RGFEa1JveENSMm8z?=
 =?utf-8?B?V2xTb0M0WnhkRWpPUElNQTlPWEpsSVRodXBsTG1UT0VjM3Nza3hyc0dYdlJB?=
 =?utf-8?B?SFVNQ1c5aVAzcDAxL3RXOUxSRkVpcWo2T3dzZEk2YVZqOGEzWlh5TllvM0hz?=
 =?utf-8?B?dVI4SWtIMElpekxkTHY1Zk82MjF5aTVtY3hzOVIyWWdZMldEcm9pNDJ6VFM2?=
 =?utf-8?B?eUZGNVNXZ3NsUDFMK0NySEw0TTQ1L2NtVEV1Zm9PVytOMlRsb1k1WEh4eDI4?=
 =?utf-8?B?QmVHZ0dBUURRNW5pV2tTRGpxWU90QnlrRUhQclRmRXd3L2FtWFF6cXJLUEdx?=
 =?utf-8?B?QVQ0dVBMMGw3R0dOYitzdlJOaUwveW5iL1d5RFRhbFoyc29yYW5tWGxBU3RJ?=
 =?utf-8?B?Mm9VbWlzNmM1UFdQUURUWHhRZ3RKYWNSR2VYUjJrTngrMVozVHJicXcwZEZk?=
 =?utf-8?B?emFWVkFYTkdBcklucDFLRit1RjhGYWNmNzcranJsUGkzdmdJaTZ3S1B4Q05H?=
 =?utf-8?B?RnlXaDNlUys2bkVFSk44YmFmd2xTZXBsQTh1dDRCRlEzd2FIQ0Q4Y05TYzdn?=
 =?utf-8?B?aVo4ZmluTkNmMG9BZm14ei9OM3dGckFOSG45ZGFQMkVlUHlaVUNRWVNJQ0dV?=
 =?utf-8?B?di9FQnRaUDF1aHFBME5laEJXZDZ2bzMzdS9qaXc1Znk2dDN6eWVzU1lENW5r?=
 =?utf-8?B?emY2TThUSEcxN1k4bGJSNUJpdnJPV3ovaUQ4WU5QU2ZCeVRtbWNIY3BnUzl0?=
 =?utf-8?B?bzVnVFoxaXRzdzhXUFYyd0g2L3BuM0pGc0VVeUxsVEs2NllRME83U0hNMnNC?=
 =?utf-8?B?Qi9McHQyTTZjMFNLMTI5OFI5MEJSYTFSUTliN3gwNG9sQU5YeEUvMUUvcDUw?=
 =?utf-8?B?a2l3RzJpZHIyNjA0S3FHQ1FlWFJtSDNUK05sNlFRZkxGU0pxamwrVU1vcU5X?=
 =?utf-8?B?K2RRb1JuRlRhNEdkOUUyRmVEUXJKS3cwRFJRRjlQRlQvbzl5TGtVL2JsSElN?=
 =?utf-8?B?QitWS3dWUm50U04veXdJMFFweVpWU051cERsMXJNY2kxc2EyajJQRWREeThr?=
 =?utf-8?B?NlZIZW9VRE9NcWVrcGsweDBPMGtPa1NoVThZV0g4TWlCaGpZYTkrQWREbEhR?=
 =?utf-8?B?MytwN1lwVDI3Y2FYdWFoaDZNWXJHNmN4VmJBTkZqNXE3T2dsTk9iazBjZ2sx?=
 =?utf-8?B?VUErR3dCNGFLZGYxckU0N0RFNFBCM1lGeEd4T21IWGt4aG9BTVNuMVBRPT0=?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GVXPR08MB7727.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB9846
Original-Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-SkipListedInternetSender:
 ip=[2603:10a6:150:6b::6];domain=GVXPR08MB7727.eurprd08.prod.outlook.com
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF0000A7E3.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	801a5743-4c69-4b04-b5ba-08dcecfec2f2
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|1800799024|36860700013|35042699022;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eERRZlY0dGFWWXN4cWtHZTZUM2ZqRkFqQXAvY1V4Y3FoYS84YTFuckRobHkr?=
 =?utf-8?B?dkRZT0d2MjNqa0NkbW9MNlJ5WC9Pd0Z4WmJHYWg4eXJWNGs0Q2JoVnJWUjZW?=
 =?utf-8?B?L3YrSXBta0hMem1GWXZtelVKempCVlUwK1BNMGhteUc5emZPeHVkYjZKVmNN?=
 =?utf-8?B?ZnppNEVLODNFWVdORUhyM3drakYrQ09SMHh0empkUm5NWFJ2QXpSL3pVSDJC?=
 =?utf-8?B?SC84NDVDMnNHSi9uR3pCdFdDMDdIdGxyejIrRHlFUG1DRWNWM0d4RWYwS2Ir?=
 =?utf-8?B?QWVYbFRxY1FDei9WeE80Vm9weHJsK3ZYZnJrdlJZSkxaQVpieGdycTVvZFpU?=
 =?utf-8?B?Z29RaG42K2NURGRHSHFkSTJIL0RRSDRTVlhOL1IyTm93Y0cyVGJaOU1SVTFT?=
 =?utf-8?B?TEZUY2MxSkl6YUU0MGdzdEZHK09MNTZLL1BhOGFIVnRwc3VGd3Azc2p1NEpt?=
 =?utf-8?B?K2RTL3R4WWpzOEpEV2I0WGhsQlg4Yjc1aWNmY2F2VTVwVHVHUlY1K3JRS2tF?=
 =?utf-8?B?ZXBvQitEZ2hBMVdUbklmWWVqUFVQbmtNRHlZZ2hYQVFScWdaOUZMZFFsNUd3?=
 =?utf-8?B?dmhORnM1WVR5SE5QY0lTdHNYT1o1Y2Q2eUIvR1JVVEwzelFOWGgvODEvVjN5?=
 =?utf-8?B?c0kwblA1Vy9aR3J6YXhMdDFJc3FSK2xrSzhBdEZBT3EraHcrWlBTWjYvRUJG?=
 =?utf-8?B?TDk2cDV1VXh5cEl4T0wvckplU3VMR29peU0zem9MYXNndVZZUnpwcnZBdUJP?=
 =?utf-8?B?dHdUOXVnN1U3OGo0cXM0T08yV0Jsb0gweXdJN2RqZ0cyMTFSYWVubEJla2dp?=
 =?utf-8?B?c0xucXBXaEZSNkczayt2U2wvUzRKSTdRdnlrd3I4Zm1pcWZhRElHdnFiSWZj?=
 =?utf-8?B?SVQ1c1QxLzZsM0ZFemd0Ukl5QjFGYzJMRXIwN1QwSVY1Mk5oV2tXaFRid1Nj?=
 =?utf-8?B?ak5UTk1hREQ0aUFlazdoU3JPZUkzcW9jYUdFN2g3clZubXlSNzNWUnFRbU9h?=
 =?utf-8?B?TkFYT3BSYitxSUc5QUNYNXpMNXpkVlM1Y0pQd0c0c0ZFdEQ3dTBNalBDMmpv?=
 =?utf-8?B?LzRIVzM4dzFWNDRkcG8wY2lqZno2UkV3dnRqNTZDaUxGcW5FSTVGWXhFNjVy?=
 =?utf-8?B?NVRnVHBZZHgwbDExNy9rYndMYTljSFExdHJJYzhPNE9mM3dRQXRhRHlmTlY0?=
 =?utf-8?B?QUFJWmx2WEtNRkRheGdubG9uODUzUExLZGl3anU1NGF5emUwa3NwNUxSRnV0?=
 =?utf-8?B?bkZoM1V0ZWZxdWsxUmFsTUhoNGJvUG8vbFNKTEVlMTJJRXVOaVhRUi9GY2pu?=
 =?utf-8?B?UVc0UVlvQjF3RklJNEMxQ0xIYktxb216dkhDWk1TcWZ2ZkdTQ2xoYkpXUURI?=
 =?utf-8?B?aXR4cDQyNHFDOHZyVHNmUzk5THhBak9sVHgveTdhWXIxalQ4QWlWQkM3YVBr?=
 =?utf-8?B?dnM3b3hlNVF5aXlRclRJcnhMQU15Rmw3TGpaZmw0UCt4S3dkOHdrUXBXdW9U?=
 =?utf-8?B?S2NkM1BQWjZITE1pbzJhZFZuNmpIYTBlNGhSVWQrL0JKMDdsT3dEWEwyTnVK?=
 =?utf-8?B?MFRCVjlpbEcvN2sxMUZ6TmNtdFFMR2R4aFM5S0pwNmo0VmhEQlA5NHNURVAv?=
 =?utf-8?B?KzhWQ0dQMlRBQkJ4bmo1NU5tdSsrY2U5YWR2ZWhTbGFveWE1WG1tUldoR21H?=
 =?utf-8?B?dFd0YmZGbjB6bCtSbE54VFN2RG1wU1dVNXBWZGlJNXZoTVRrL20wVmoxNGRC?=
 =?utf-8?B?R3daaTZ2MHJCMnJlN0ZnbmdaR2h3WVdNRlIxZW9xUnM5Uk5YUVQ2bHlFMVI0?=
 =?utf-8?B?MzFUVjNqbnpnRzZFSHp0Zk9ieTkwb3J1ZlhndVJiczVXbHByQlRCY2g5K0oy?=
 =?utf-8?Q?8thqUs4Emg0+F?=
X-Forefront-Antispam-Report:
	CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230040)(82310400026)(376014)(1800799024)(36860700013)(35042699022);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2024 09:50:27.4059
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5bd763e0-7659-4d6b-aaa2-08dcecfecc5e
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF0000A7E3.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB9361

On 04/10/2024 15:43, Steven Price wrote:
> When __change_memory_common() is purely setting the valid bit on a PTE
> (e.g. via the set_memory_valid() call) there is no need for a TLBI as
> either the entry isn't changing (the valid bit was already set) or the
> entry was invalid and so should not have been cached in the TLB.
> 
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>


> ---
> v4: New patch
> ---
>   arch/arm64/mm/pageattr.c | 8 +++++++-
>   1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
> index 0e270a1c51e6..547a9e0b46c2 100644
> --- a/arch/arm64/mm/pageattr.c
> +++ b/arch/arm64/mm/pageattr.c
> @@ -60,7 +60,13 @@ static int __change_memory_common(unsigned long start, unsigned long size,
>   	ret = apply_to_page_range(&init_mm, start, size, change_page_range,
>   					&data);
>   
> -	flush_tlb_kernel_range(start, start + size);
> +	/*
> +	 * If the memory is being made valid without changing any other bits
> +	 * then a TLBI isn't required as a non-valid entry cannot be cached in
> +	 * the TLB.
> +	 */
> +	if (pgprot_val(set_mask) != PTE_VALID || pgprot_val(clear_mask))
> +		flush_tlb_kernel_range(start, start + size);
>   	return ret;
>   }
>   


