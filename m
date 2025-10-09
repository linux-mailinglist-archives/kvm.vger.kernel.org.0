Return-Path: <kvm+bounces-59721-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id BD28FBCA420
	for <lists+kvm@lfdr.de>; Thu, 09 Oct 2025 18:56:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 423633524E3
	for <lists+kvm@lfdr.de>; Thu,  9 Oct 2025 16:56:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E09623C4F1;
	Thu,  9 Oct 2025 16:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="EQqB8AQp";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="EQqB8AQp"
X-Original-To: kvm@vger.kernel.org
Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010006.outbound.protection.outlook.com [52.101.69.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 734C222B8D0;
	Thu,  9 Oct 2025 16:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.6
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760028929; cv=fail; b=Wg7M/rx702f/Yt2HI28WLF0vjlwQsC4waTMYsV2AYsaMIAOq4970rZ7ej1EKpWc607DRs3WlOXwp8bDXfQd/l7SzTf+XJLYZDT7GnkPR5vH0l04hTJd0EVC5LAWbin4yEXHHNw4spBCI7gKPsqDPWmLI0KzibFBHZq2Hh3ftnEM=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760028929; c=relaxed/simple;
	bh=7q1R5sCn+NuILRgQtm6DyYmBzhM8BcXsaRGApLdSf1U=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pYBQerhCB0M4XiWLLDJBHe7a2KjMYYMNywsABHS1VBYSmvk2pOMreuGxxOQ4LRNmG89BgpiAhOXEdRUEQ3thx+FyVUNuh6vofjVkpnwfy7MCSs58PR5AXA66SKdcHfbSDz+NluBZ3vH2dFmEIGTVPzB4IDqkujiFhqRt5E4prvo=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=EQqB8AQp; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=EQqB8AQp; arc=fail smtp.client-ip=52.101.69.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=XUF4IIHRA5Td1gJUyjQSgCmWn0N6kjK4Y6CY2lv9grKAh+SNSk5WNEjcZf20xFgJgMcZZ1GgKimf3JS79duzBXggfPmKsA+BY9cjemSsu6cbEFEto6sLryTytITg2RpwFqJ5J9+g5XVznPtjYaVHgnnIrMp9n+A9ueIS5cEq5b//2bT5vvWCUy+Gc6MmNCGMKUmMUVmh9l3ZgiEgNXWWS+ijZDNSkzChV3D/PR1cwOyf0nP+kQy9nKmXWjEQS93QDLJlZwT+KPEvgU6U+dmK8WLYSFKXUyOcwa2f51dCqwkLbl6WpXa5PpiUiIMfSG8qh601VQxlT4cgmC9AgFFtqg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F2VwvQCuhj8pB/eUv2nqRJn4LiZ8oAD9fKQzkO6g108=;
 b=I9w7rXkM99kxAHsd5rcBavhZaMyLUuzypP+2iJ2ki6e4/ZhMcAvg6GCMAifyr3neDh7Ya+RzywTHpHzyOEeWC6C8x77p0lRIC8UDM9kqV31A84NhNYjPPDvjCHPyISoV7psZTLAMo21bhesPa0DoaQJRNnc6fetL7G4VmPIQhfOhPEL7NZsarS77QPmkyTQiYkdV4mq0BEfblLS6OMe+XQAT4DQvYOBljlsuZWVDrMSPL2g/5ekHMPt2JW1rNpcHLww9gzbcjgdcWY884M5cYfNSUid4m5W8rJ/+T6erdBQlXZateWWlLlNGKbtGqFytoZ1lC/jsEmUEpkq2O6Bunw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F2VwvQCuhj8pB/eUv2nqRJn4LiZ8oAD9fKQzkO6g108=;
 b=EQqB8AQpMuMiGkEHcUnPYvbbCUOC3vJtzLG/I7p+kGTSN0hS76ZYMq6DEh64P7u4irxU1czHVUjlKdmn/TjwQzW0uPuVoNyrpk2wW9m1gUfsnIPiTdHTSxIDNcAbAs0EtJNvAYBdYCGplghWdZ9/mnZATqAiko2EnI69A+itKh8=
Received: from DUZP191CA0064.EURP191.PROD.OUTLOOK.COM (2603:10a6:10:4fa::17)
 by PAWPR08MB9808.eurprd08.prod.outlook.com (2603:10a6:102:2ea::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.10; Thu, 9 Oct
 2025 16:55:21 +0000
Received: from DU6PEPF00009528.eurprd02.prod.outlook.com
 (2603:10a6:10:4fa:cafe::75) by DUZP191CA0064.outlook.office365.com
 (2603:10a6:10:4fa::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9203.10 via Frontend Transport; Thu,
 9 Oct 2025 16:55:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF00009528.mail.protection.outlook.com (10.167.8.9) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9203.9 via
 Frontend Transport; Thu, 9 Oct 2025 16:55:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N92HwBXhYjn9qGMRMwZnPcnTpKifbM7HK5EFKTZi286IxRf6rNyK5pLxfyU0niGPpLWdor+pcK9aHefk/6c8eplWW/2fQrv/LzpCunvfi+2zS2ZMbpBjbIbQn6pLwHuLXCzYgp+DYGXygrsBMhtKU6tHwcK7B3G411/9L1VIJb3vQQj8g3WvqeE/8LGwnvnUA+cE+BmGvlJFOIiSReftL31Id8tYpfdxDK4zxG6gltDig/TBk1TQM/NNsIK3VcTcecfwTp5QbMusUfcH0CJZm2+utW6YX1aIIr70kdo6AqpU1HjA4MfmzaSy59Ijx+vqbeSWf5YvdwwhNlibPCZBCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F2VwvQCuhj8pB/eUv2nqRJn4LiZ8oAD9fKQzkO6g108=;
 b=Jg17wMnXVmgqksqpzoeSw0CpjTb2kH2l+WwWoh3JVNuPQ5AN5btJztL/NpX1Z3MKDRK/dNWjhHJyhM31x0F2e1h0eq4CBlppgOoWTRsoX3QLqUzOKPSw8dwev6FvQYr62GkxAAF4D8h3Jj2IWmjNUa7RWHghljl2X1BldMYbB/i0fN9Jf8iO+EdarnnbxpVnuEO9he2RF3F6dzaNd5nCPqH6ah/oOPlipAghxhRU84PvKRj3AfgwOwtMKTQVEnSkcAr0E2PNVYNJkoW6tzjuQ+7+VNWA5evhOHbg3tQwxy7CnwqIcLPGzzHuJK3UEUoSrpbHQ8hY2J8FCNTeJM59pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F2VwvQCuhj8pB/eUv2nqRJn4LiZ8oAD9fKQzkO6g108=;
 b=EQqB8AQpMuMiGkEHcUnPYvbbCUOC3vJtzLG/I7p+kGTSN0hS76ZYMq6DEh64P7u4irxU1czHVUjlKdmn/TjwQzW0uPuVoNyrpk2wW9m1gUfsnIPiTdHTSxIDNcAbAs0EtJNvAYBdYCGplghWdZ9/mnZATqAiko2EnI69A+itKh8=
Received: from PR3PR08MB5786.eurprd08.prod.outlook.com (2603:10a6:102:85::9)
 by DB3PR08MB8795.eurprd08.prod.outlook.com (2603:10a6:10:432::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.9; Thu, 9 Oct
 2025 16:54:49 +0000
Received: from PR3PR08MB5786.eurprd08.prod.outlook.com
 ([fe80::320c:9322:f90f:8522]) by PR3PR08MB5786.eurprd08.prod.outlook.com
 ([fe80::320c:9322:f90f:8522%4]) with mapi id 15.20.9203.009; Thu, 9 Oct 2025
 16:54:48 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, Mark Rutland <Mark.Rutland@arm.com>, Mark Brown
	<broonie@kernel.org>, Catalin Marinas <Catalin.Marinas@arm.com>,
	"maz@kernel.org" <maz@kernel.org>, "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>, Joey Gouly <Joey.Gouly@arm.com>, Suzuki Poulose
	<Suzuki.Poulose@arm.com>, "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"will@kernel.org" <will@kernel.org>, "lpieralisi@kernel.org"
	<lpieralisi@kernel.org>
Subject: [PATCH v2 3/4] arm64/sysreg: Add ICH_VMCR_EL2
Thread-Topic: [PATCH v2 3/4] arm64/sysreg: Add ICH_VMCR_EL2
Thread-Index: AQHcOT1szE8urJIjv0icwk1HXl5Piw==
Date: Thu, 9 Oct 2025 16:54:48 +0000
Message-ID: <20251009165427.437379-4-sascha.bischoff@arm.com>
References: <20251009165427.437379-1-sascha.bischoff@arm.com>
In-Reply-To: <20251009165427.437379-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	PR3PR08MB5786:EE_|DB3PR08MB8795:EE_|DU6PEPF00009528:EE_|PAWPR08MB9808:EE_
X-MS-Office365-Filtering-Correlation-Id: 08363599-e5be-4b41-22eb-08de0754a223
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?Vt7pWGb8vXz8ImDSCxv67FuDQVjLYpFFNRWGxYjTmTokA2UL8Jl4OCuJBa?=
 =?iso-8859-1?Q?Q4V+oBLYBur8a0EJp05IVKGoEnRtIdJ4zZb9eLW66lXKIfTPHnc8KyDcoL?=
 =?iso-8859-1?Q?KJSRNC5CR3/X8XHoKsVHLnMM9LNbdLj+MfPr8tpcC+fRCPlayel9GS8z+e?=
 =?iso-8859-1?Q?EE6srBW2dtastvlNB//hPq6BzN1GPx2X5YPwpUkR9mc2AQI7xYig3faakU?=
 =?iso-8859-1?Q?WA3Nz9VXqeIRifzLQY6i8KacraYsKIriQEmvQTnN+apM2DBh2mzoPkJJbJ?=
 =?iso-8859-1?Q?U81ah/gMkO+S2m57cfpgTAcMW6CkB5ycb8Spf3Ow5TfEC2tnd5sR2+X8Xq?=
 =?iso-8859-1?Q?pmef9gQJqOCUm+w8La9trVEJQGFV5W/cfXa5iGs5zbFPgJSUZie4G1AoEQ?=
 =?iso-8859-1?Q?9jZSEHUlu5OIE39lYtL3dziDB2WMy6syzHKJKB/jjog7iJOMHYnrGCQJ27?=
 =?iso-8859-1?Q?8Ebj8gpyUpRgpT4fSZyUnbVRUWKhOr0YKYcEB0En3jXF/8HfiJYRfnwJa5?=
 =?iso-8859-1?Q?K+J+D6o0E14LEbSLe1kFDOU37n9SfClZG4UdMJBLszodNfSmtGfBtaWi4N?=
 =?iso-8859-1?Q?tDhes194ahAXhwrvdELb3e0gMCWc2ucy5Aalbv9RtA3qaipKXgHihP8YU4?=
 =?iso-8859-1?Q?o030fCj3dI2Ee5z/cFVvDS4p0t0hqMhVaWk96HUJ0d40lwBxqK0e5bQyki?=
 =?iso-8859-1?Q?Xge9ktVQRdY+ehpPRFmJPNx/OC/0wy9dApKMX+wYQbTfKqqoauBlizufu3?=
 =?iso-8859-1?Q?3iOqvkYdpy5ji8wI8OcKEcOrFB3iRMV1cCshvZ7/WgzxDnf+BWxBL7n0HL?=
 =?iso-8859-1?Q?D3T7/YDvyZr58TXS31HPeM2BErmkJGepODpplAgBXOnlHB5sKQ5UB4vZZK?=
 =?iso-8859-1?Q?O1qvVIBlww7WOimWRZhCu85Pdx4umcdTywliujZdJrEsOcTTZM5o0LinUQ?=
 =?iso-8859-1?Q?nVPCFPIU7Xk6UF25bkxVfdK/Bur6CF6g+TxHx6kqFz1b3NX3mgF0g+6f7z?=
 =?iso-8859-1?Q?qwPtDjjaAQA7gMqfvRNGAgRkzdUTINcbKgYbpJeYip8o9TSihPWCRJZ8b7?=
 =?iso-8859-1?Q?y1y+Pq2X8IeXnNwbPCKS/pu+kepyY0ZKsL4+KqATf6mqba1hoaI01MHdY7?=
 =?iso-8859-1?Q?E9Fw4081AkD6LeYWeP0uY/ssQE7CA66+dEKqUa65SwEtbgevN+9nG4nKXI?=
 =?iso-8859-1?Q?9eYhBGmXlM9peBiJXhLdcfVSm9vT1oXt/v2Ce3+P2MepPdweqXksENtmNs?=
 =?iso-8859-1?Q?L6eCtUyDjb6wxhd1NlK/yj90p80qKOUVySQK1sVIFPzS6P9HNwftYT9TDZ?=
 =?iso-8859-1?Q?Mp8LcKJCeQIRR4+Fa2xyGKrFriEb8D5yqX7f4p2j75E6uU1dENEO01uxL6?=
 =?iso-8859-1?Q?uHcxxVzuzt7M68HoCHwl4MIuIbCoyC3+fkaOsCsL82eYCstDLtWkptCR3T?=
 =?iso-8859-1?Q?tqX+XZ7suIZnE6hLVo7/YgVWrO3RhnZLmgF1biNvO7kj1JNG626CIS2WYZ?=
 =?iso-8859-1?Q?HM476czc157D10T/5iWHl8+S8bEZo82IxWfDIe76NzVr0FKR/HVKbKSfZY?=
 =?iso-8859-1?Q?d9/isj9dfIXLLlQ7cMWj1px5YDfQ?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR3PR08MB5786.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR08MB8795
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF00009528.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	e7d66cd0-992f-4909-0e0d-08de07548ed9
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|14060799003|35042699022|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?NhgxwxY5ivMTwtzSUFssYR4x+FV9E6h940HqLtSNuUmgDSe90V2u2wlg9B?=
 =?iso-8859-1?Q?YO8BpkzX18DIJgjyA4qt75/9hk1+dZ3zIvX10mm6JridQp8grC0BTpkpha?=
 =?iso-8859-1?Q?a+nYOIWRujyh7Lvbjm4Lhxa5W45I01WzA13d2NmV0X10w1DVR6DHxxC9d/?=
 =?iso-8859-1?Q?bbHne7CIEoQXi/RgaGUChHOFh6eIbWtjXTWJMz94tQruTXWtvnQr78yP9H?=
 =?iso-8859-1?Q?Qf5WCN1kQVPMRxahqem557VJ+HsZNwZ95KYAurJIo4dsiz7dQf7PasFAXV?=
 =?iso-8859-1?Q?sgw6GiSSWNlRszsuVRTf1C6A6W8bIYMR51QFfYzjL5wF7gY1iI3WqTsNju?=
 =?iso-8859-1?Q?3SlZzbHz+rcAceAMS/WXYa1jrwlw/zQoe/h+rS+q6iwYv1KKDF3lwWhi38?=
 =?iso-8859-1?Q?rANmYCgXP2Poc1z3WhoKD4mDoLeJy0d7M6XRcwgie7v3gcOzoLq+qAaRNU?=
 =?iso-8859-1?Q?rzTX6DA+i+6PObdqpsQqSKj0GG6toRbuke17GLa9OxBubOqOqBnRGF9SFr?=
 =?iso-8859-1?Q?ekAgQwU5z8cDqXHN3kMXUt+atFTIgRdfhyC0aHzJxjTup2e6/CN666slvy?=
 =?iso-8859-1?Q?p3dDNho3PU6kgi8rMCoG7nAVQCQFf4hfIDN4QJlEgoTOEnxdGtzaq8u0cp?=
 =?iso-8859-1?Q?UVfL4FQqe47DpczLY6HplW2ZTL1Yp42wtnsSbSACpflyIRFXmuU0dOvyr6?=
 =?iso-8859-1?Q?FzNT6iswH2wdzz+6/4g6gJdWpnN7V1PCPvJYHydKOO/IReg1Dd58YJ6MJr?=
 =?iso-8859-1?Q?kg6clItXPC9bIBQ8aytRHtlynKqIVg/42EthDRUTdCsLJzDkd8LgMib4/L?=
 =?iso-8859-1?Q?4I7ZQEv0oDJN5bhO1QUFBmmUPahcBmhE9ZLaoZYUonozGG3ME6WNyx9C0y?=
 =?iso-8859-1?Q?2BsQsEBt7cIas603m88FijSM+Y18mw2uZ9EEcBaQRNAXOIJ63h4Ke3BJwp?=
 =?iso-8859-1?Q?pgrOzhzcXKrxE/hECC09POznUPH0R4uRLdPxJlGNgQ380A0p+ha0yXXyAv?=
 =?iso-8859-1?Q?cRVV3nP7UjETfNrCwWcdw1CW6n9mhue73wUw0MICo3Yjy7SrqPgh+xekM/?=
 =?iso-8859-1?Q?6ejkkvGJJJX4cXja1HSEUqIceKnQwHwAC57jGwDvGpUd/I5cInS+fLkPp4?=
 =?iso-8859-1?Q?2CBbGi03Od78tQZ0InW4zwWZqelDzl9jWFBIV5q7bwnjuD1kq33Kea4XGN?=
 =?iso-8859-1?Q?F6stl9sQBNvQZ+eqTjbo2aJHhClsMKSlu5vYauh62+QGGpNuhs+fLmAdfL?=
 =?iso-8859-1?Q?pCYUrfMeF3KsSJFNI23bPX96Q8lW9k+QB6fSHFX5H0tyo5g+7qE9vthC3v?=
 =?iso-8859-1?Q?NlPQ32R92TUaZfcHUalY/HVHuOjnETpO3rkclo8WgL2t5puuKi3sGE3vDl?=
 =?iso-8859-1?Q?2dfkCIl9j2DAHpnZj0J8gV8bRLXGn0rulfl15Bvbty7LPBGYCGfzYkxkwa?=
 =?iso-8859-1?Q?rRvKHxy/UjovUY0Upf80j9yNvOtHZJszX0Wo0KePx47jgA6Gmpt/DSIReT?=
 =?iso-8859-1?Q?05iXr4zcoUttnaTx4Y6wV6jNP56VclXd3yLvARj4vwORGKQDwNIX7nwTOB?=
 =?iso-8859-1?Q?8L4yCKCz70/qPF+cgIERigP6t8sTLau+jxUBr28+BMh2XodB6jzMeIWkcv?=
 =?iso-8859-1?Q?H5lk3S1aC1GrE=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(14060799003)(35042699022)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2025 16:55:21.1070
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 08363599-e5be-4b41-22eb-08de0754a223
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF00009528.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB9808

Add the ICH_VMCR_EL2 register, which is required for the upcoming
GICv5 KVM support. This register has two different field encodings,
based on if it is used for GICv3 or GICv5-based VMs. The
GICv5-specific field encodings are generated with a FEAT_GCIE prefix.

This register is already described in the GICv3 KVM code
directly. This will be ported across to use the generated encodings as
part of an upcoming change.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/tools/sysreg | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 696ab1f32a674..11ddcb3198fbc 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -4668,6 +4668,27 @@ Field	1	V3
 Field	0	En
 EndSysreg
=20
+Sysreg	ICH_VMCR_EL2	3	4	12	11	7
+Prefix	FEAT_GCIE
+Res0	63:32
+Field	31:27	VPMR
+Res0	26:1
+Field	0	EN
+EndPrefix
+Res0	63:32
+Field	31:24	VPMR
+Field	23:21	VBPR0
+Field	20:18	VBPR1
+Res0	17:10
+Field	9	VEOIM
+Res0	8:5
+Field	4	VCBPR
+Field	3	VFIQEn
+Field	2	VAckCtl
+Field	1	VENG1
+Field	0	VENG0
+EndSysreg
+
 Sysreg	CONTEXTIDR_EL2	3	4	13	0	1
 Fields	CONTEXTIDR_ELx
 EndSysreg
--=20
2.34.1

