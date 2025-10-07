Return-Path: <kvm+bounces-59582-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 87760BC20A7
	for <lists+kvm@lfdr.de>; Tue, 07 Oct 2025 18:08:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id A89B24F6325
	for <lists+kvm@lfdr.de>; Tue,  7 Oct 2025 16:08:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 839882E1F08;
	Tue,  7 Oct 2025 16:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="lpsCv2Mc";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="lpsCv2Mc"
X-Original-To: kvm@vger.kernel.org
Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013065.outbound.protection.outlook.com [52.101.83.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21456C2E0;
	Tue,  7 Oct 2025 16:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.65
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759853285; cv=fail; b=ByqqUypuq+CS0zA1bbeYhuoAerFGDR69ym5ZKSgHjDaGksxS3v6FIQo64tjxhHE3t8Ncdq1tsrbkkpLhGIDQVJ51pK9MrmXz1yfdWaz6L8I7RK9p81FxF1A89FN/GHPmr+3WZp7PXdDhq9d2rn2LfvrxT6JtX1GAt1f6NDlzMeg=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759853285; c=relaxed/simple;
	bh=kNBgwK4ghmU4YWDmpbtBKsjs/p8CJheb5CUFt3Vbg+o=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=m2Fe/uMLpSkHlEObwJ0SrptT+CnBHXuMWgkwiGE7rN4e+n2BkfzROOVdgnmymFHGhFnlvocra0LXsTnsO0D5IiPH+Fj6f+55aCe3ZMJDmuQdAq5LTWJrQpuULLxfq56RS6VkQhFeK8hcYXzddX9KSDKKuWO6ZtohpUhYHHKzHLQ=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=lpsCv2Mc; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=lpsCv2Mc; arc=fail smtp.client-ip=52.101.83.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=kL+szAJ+MiykriG/FDi6EL11Fy6tDD7HoGUgsphJJhH9w00ZRMp65jP8Vjh8UtkLOEGiUELU/lV2LlWjmatYOxtXjWzaKH/Q+I2pihPfFaGixs0nqcGPQcGVPbcxkq1c3/HEp00MzMa714kYgj+s5xdHqHjvcBLZ+3OxfOuzKiLE28UYqiEpTofJA965ggLp1L/jnSh707QyoxIL2KfKjR85LPajlfRR1MDjsFHe6Itdl7jgOILK0Fyl0I6G/y8Ps8oEkXuYj27Et0EL35R50nvfDEVwTREduF2Jx/bhBaaRQzVW3Mqwbvl3qXcvWM7p/tg1s51lUjq2oM8mqzL+QA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gfMknKkXTstQ6i9AuVuS4jTAapdYzzSWFhu2awD9pVg=;
 b=L0C6A0OxwMpVzcA2oBLtnxJEF+1iDgYEHXL8il+UZcAtN3ChBhk1Gop7QYK9ekX+3K7HLEuHDSwMeNZsdx6JEwtKBbSkSETp0mZOD9xmwF8vz8xud/j/Qd9YWTFiwYgVGdv3vCUcwboO1SGC/Mi2jRNm2kTm5B2ByXJqYTO1EYBkuSUjjNV0QeEe6n6E4EE13pk2Tszl4X0VhhzKTT07DmAUw1ytqADnQojp5gLpMPPtQzWUbbrmUpbYgf/kuj9HPU0DVY4LzbrwMk+u6ebchn0aU2mwx7FMgs9GZ7Uc3aYrM1fLi58DYwY+QBnWK1/k1kTUg1objiEGhCmZ2VhgrA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gfMknKkXTstQ6i9AuVuS4jTAapdYzzSWFhu2awD9pVg=;
 b=lpsCv2McTKpA3nDRHE30p5FtLURwWRXEqOC2YrPbz/5FbGBc7CdlGR+p9EQeYLBXVdWEpbNlwYw4eaunFt7YKTFTbhJI4I7mzdgR9bpYkV6FkjKeO4UJj9USuKOhB9mCzz6jAo4b+pWwFxwqOpivrt/9im0R42AdQiB4lsdCMVU=
Received: from AS4P190CA0039.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:5d1::12)
 by AS8PR08MB6662.eurprd08.prod.outlook.com (2603:10a6:20b:397::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.20; Tue, 7 Oct
 2025 16:07:53 +0000
Received: from AM2PEPF0001C70C.eurprd05.prod.outlook.com
 (2603:10a6:20b:5d1:cafe::19) by AS4P190CA0039.outlook.office365.com
 (2603:10a6:20b:5d1::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9182.20 via Frontend Transport; Tue,
 7 Oct 2025 16:07:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM2PEPF0001C70C.mail.protection.outlook.com (10.167.16.200) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9203.9
 via Frontend Transport; Tue, 7 Oct 2025 16:07:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ld4E0W1jH4qAyKNLvBoDa2rNyhWkTRKFmZLpNluJt4/AXJPfepujoglytFC4tC1p2UHsA2KN6cS5wEWOi3CIqCezkeZpvw3JFMaiBzywfeshbQRTpGQaqeHunf+yAdWDqEhdMxt1JgHRA/231or6jBRVjdteVgr/+ILUJlfPURqRyCN9a0CIca4Q8kk/Xop2RzcWGqmQYYLGrzrgoXxHBb77krfEqK6v2UKqjHWs+aHvUcRcOFf0DvPVvBZES2BEx38z8eS5FiUdDVTxyQMTiXg0Td9GuSVGZaaMXlgypo6nSNXwvwv/SppuG2DhAnr5gYMQ5IIe/yBnAIcuAoQBOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gfMknKkXTstQ6i9AuVuS4jTAapdYzzSWFhu2awD9pVg=;
 b=Md3THAwGG/4BDhNnjanBR24aHqBde1s2RkxudtrO5YVSWaYEXmevXqCM3rR72PbEOZYPnUdmhnAauBhbg0rvRvvuINg+b+7FjVT4on3kHAGmOZ8A6wXg5xtiLudyurXTEY3B8ocL7tYagzYmGylcxMONQRIXaN5AXByh74oqoTEvET/SBng24McejPnQuPjlXY5F+7vAMmXhIPut3YfmdOkbvfTcecxERmXYRbgbTsQ6SR1EjXrbjahjNuXoquDaNvD290N5jrG/+GNp0j25/Xi/Xz5aDFjGDIrigOf7Nsax4jYPYlpEoeunRusslTKs3+BbMzm9Bu202vacEXD9pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gfMknKkXTstQ6i9AuVuS4jTAapdYzzSWFhu2awD9pVg=;
 b=lpsCv2McTKpA3nDRHE30p5FtLURwWRXEqOC2YrPbz/5FbGBc7CdlGR+p9EQeYLBXVdWEpbNlwYw4eaunFt7YKTFTbhJI4I7mzdgR9bpYkV6FkjKeO4UJj9USuKOhB9mCzz6jAo4b+pWwFxwqOpivrt/9im0R42AdQiB4lsdCMVU=
Received: from PR3PR08MB5786.eurprd08.prod.outlook.com (2603:10a6:102:85::9)
 by VI1PR08MB10220.eurprd08.prod.outlook.com (2603:10a6:800:1bd::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.18; Tue, 7 Oct
 2025 16:07:13 +0000
Received: from PR3PR08MB5786.eurprd08.prod.outlook.com
 ([fe80::320c:9322:f90f:8522]) by PR3PR08MB5786.eurprd08.prod.outlook.com
 ([fe80::320c:9322:f90f:8522%4]) with mapi id 15.20.9182.017; Tue, 7 Oct 2025
 16:07:13 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>
Subject: [PATCH] KVM: arm64: gic-v3: Only set ICH_HCR traps for v2-on-v3 or v3
 guests
Thread-Topic: [PATCH] KVM: arm64: gic-v3: Only set ICH_HCR traps for v2-on-v3
 or v3 guests
Thread-Index: AQHcN6RxSabusPY2cE+sCqOkchM+xA==
Date: Tue, 7 Oct 2025 16:07:13 +0000
Message-ID: <20251007160704.1673584-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	PR3PR08MB5786:EE_|VI1PR08MB10220:EE_|AM2PEPF0001C70C:EE_|AS8PR08MB6662:EE_
X-MS-Office365-Filtering-Correlation-Id: c709460f-4b0d-42c2-be4d-08de05bbab73
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?cfJz62ql3pwlOgn6ZDdEd8NfVPCiJ6gL/guXjKZbRqsk+OIOIYahw0iw0O?=
 =?iso-8859-1?Q?ahcqqtbnbvamumLVtEgP7GwWMI9N9sT32XzyCZKSOW1Os+Fynfi6dnIZq3?=
 =?iso-8859-1?Q?zXtL+nfc/qtPjUfO3HqZ2tJoVKmjzVcDUWSh/Y540Muo6GkZexYiUmwSa/?=
 =?iso-8859-1?Q?QgxdksUH4A4xav6DSFdRX2ieyNirtRwXrUN6F8eGemoJ2kVbKaHQRx8Ecl?=
 =?iso-8859-1?Q?uxu2vPCRyhXmwKbNzi+oRbY+t3RvPMQuidajwXRIapGQkpvjmREaIX28ny?=
 =?iso-8859-1?Q?nTkIeTePFhy+AP1tCoLovzdbfQHenfgQ7J7fNgXkuqj++8XfZ20oXDtij6?=
 =?iso-8859-1?Q?2EvKAR5+PNKAyAiJpMfL1lBetgOz5m9m/MRKsgtebwJBllpOCLvPZADyM6?=
 =?iso-8859-1?Q?XX9JXLy5jiJW+uvy7dEXjl9Q+n0tEC8Q04bwI6F9YnizNLudFWwKizbYYE?=
 =?iso-8859-1?Q?+iTP7Zu0wJ9PwrBuySv25qR5Xtp8Mh4tVVi1Q3/yy7qhg+wP+wRpgKT7ju?=
 =?iso-8859-1?Q?J9UGeq9cnhjste7NaZZSSim/hq/4CeEPLSEUEK7FvVg6/q2B2c6BI3pP0m?=
 =?iso-8859-1?Q?2qcdcnG1rHiL788WYgDGwbMiOO3Qch0BFJv/miBiSxH4DUwCSdMRCaLY0I?=
 =?iso-8859-1?Q?VgPsE6rS5eVm+YnTX5MxxHyx6F7rSRiSlcDpkfKyVr3+NN500bnU1H+aWd?=
 =?iso-8859-1?Q?7h+fOuIaY+twGvNENdPlasg1rwdthPh37yQ5iNgKsqKvr4ERTHY6NDbfrd?=
 =?iso-8859-1?Q?ralRwFVa4eH9xCFOQ/Gyh7S1jOYrdZFtC5YbGgF/dLezEkdGqiKyMo7qVh?=
 =?iso-8859-1?Q?yIT10SmjiNTykTqqS6ZIi7VAF1HV+C/LdVM9fbgdjxzyp0xuzkbpCzRW27?=
 =?iso-8859-1?Q?75klYDFiHowc7hZFm7Vg4dOrvTPq7v/JaGUw/F9fe5TNSVcFVCmYE4SdPa?=
 =?iso-8859-1?Q?G/2Dz/KP3B1eLgmItz6J0QkRsw4XmNUWSFPkB+fV7yFS/Mi4Nzrkyu6MX9?=
 =?iso-8859-1?Q?3TlWx0HG5oeoDg6GlkXUN9r9QJ6Wb0SFdRnYBCxW0XoTXBKPWLI+na3lQR?=
 =?iso-8859-1?Q?AULkdOdkwfLZUjgOkOZ1CKBX+2ZIp6ZjkxPnpm65crAmVrp26aAddx+qJz?=
 =?iso-8859-1?Q?9cwVNS3wWRCAibGGDzMCnwAGkMZg8+Zmj2ZeP7HoVWVFZ7k1K7BsyFJERW?=
 =?iso-8859-1?Q?B0H8SFLk2h4mqLQRUScJPxCS1ikAoZSpyC9Mk4xr3Oe7fpPNJ9fWiCSkkK?=
 =?iso-8859-1?Q?zcnF2aeoSprV+JOHMtq7pV4+SDY/7ivcTMHYok0Y1xp2F4sC77ixFNk+br?=
 =?iso-8859-1?Q?Cg1eOlEaowiaEhXmRLavEvJWDXPXwnTfqDPLGzF5GXhsU+MYH0w5hD8+hK?=
 =?iso-8859-1?Q?wrA6A1ndE6+GONAS9LvqIQEi/E4/WlpQ1OqLLhq3XeDFMOYSvsXmpwHwUe?=
 =?iso-8859-1?Q?DTMcdJL09rsSv5hLGIPsj20Mep1+s9wMkbv/xxYnnxyShmCqUtMd9I7+Ty?=
 =?iso-8859-1?Q?K9Dp8KMqJQUsNadvqg1XmvXvGZsK9QF3Sr1MNay2+p/Cst2o+uB4LQS+fR?=
 =?iso-8859-1?Q?uRAoDejLHP5wYoUADq6xoiK266Yl?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR3PR08MB5786.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB10220
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM2PEPF0001C70C.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	6b4c738b-0e38-49b2-5459-08de05bb93f3
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|35042699022|82310400026|14060799003;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?TKyza9lM0AtuGCTB2MllGpXjR9YOuBnXbSd6s/+XRNm6vUaUUVlxxdNZ0V?=
 =?iso-8859-1?Q?VgRH1BdMZFZdHyGyYxfMxV/yJjr1ApL7wZzHs80IHuYXSaxWtapDAnEFWw?=
 =?iso-8859-1?Q?OPhRoDSYnVfDWPQFz4wCZspvP6SEECMfyjV641xAo9VBmPiFUSHmGKUqC3?=
 =?iso-8859-1?Q?Av93+edJ6zhpgsZjMAnXJ4gPqOm8ATgzCX5K8OxSb2hd/SzE569hfs3s8I?=
 =?iso-8859-1?Q?8XSpisnGtzWiOtSO4GyUzETNsf7zm7XrZ+p5swT4SKMOY3+eeRtkYhT4z+?=
 =?iso-8859-1?Q?OY3sqK6mRupQ2YHnyQo5EFS0RynojNH/ghohGKGeFr6IyHexNz1FnRcmMP?=
 =?iso-8859-1?Q?7OqcjP8KzhppVR+s3cqCa1kXes3rVyfJQOvkMq4xXQ0Waat7bXp3cCK5BI?=
 =?iso-8859-1?Q?1zVzHjrvX9l/Xge/uawFNQhFFbgMt2HhbtIxNLfQ2oemyH/mto47h98GCZ?=
 =?iso-8859-1?Q?qADdn4JfxtDqOQjxstLOZQV9X6AF70t+NVX8HFO6ftcuxNGVcA2JpwElmr?=
 =?iso-8859-1?Q?apUlWgllNdCYQIUYTaQlJLzaUnZycTHZyUKaFhEocLpWh/9joZIqqpN53m?=
 =?iso-8859-1?Q?BT/LzLMMOfVIeOyA3ruw90qfhETtt0iwSeyzQv5raaQ87Rycsdn8X4r6mE?=
 =?iso-8859-1?Q?n/SlKbPKqzdsCJQBKAls2Se34O7m7Ot8XybS775SvfHsW4yarpRNUwiP3t?=
 =?iso-8859-1?Q?RPFsCcLbyQcauG1vNXvXtqZDoDMaHBNIQTjT9a77Y8r39q6/RxNQdbYL5c?=
 =?iso-8859-1?Q?pR+KnmmPgbwy8hQA0Gy5R1fIO0UGWJnBIN8FTupjsbo1JP9z4mNpHiF7PM?=
 =?iso-8859-1?Q?FPtcWCGHWwVKbIYyttI9Bpf/RJkNTNopiKpAfnkCSrOhL43lKMBw5HQUCW?=
 =?iso-8859-1?Q?SUkwxezYKvurZQbjuwYe2d41U1XoVLfL6zPtmL1dJ8e/79aAMB48WXxkDZ?=
 =?iso-8859-1?Q?/sKufBnG9pDEvBm8DyIeLDABLOXssJn6YajXGWfxpqBwPLgGLbm8e1nGMI?=
 =?iso-8859-1?Q?h27Yhpf6IJoHentgncz3ZMxW5eh7itG9UHQUxAeHHnfNwnt5jjNTWAukKj?=
 =?iso-8859-1?Q?eZzdr6qkXTQ2G7Z5DDbc1VmHaV9OyCIje6EIldB8GIXRTvbZI6ohV/t1zw?=
 =?iso-8859-1?Q?5elzV1nQILYcCJFETvI8ltnR6az1Veq7+AhW3XoP051SAVFYSME+7m1BRE?=
 =?iso-8859-1?Q?u0tRWDq35kZw+IdahQlVRZSQa1A7lzBR7xmSdnd6OeX6a8o/ATrk9FjTzJ?=
 =?iso-8859-1?Q?g/SAbIgNZx5isQLd+5cg9uUCnaG838TcBOtdyG2vNcGdKUCNDOrAHsNtES?=
 =?iso-8859-1?Q?3lvHQDbEWx9RgNkM2bt0f+l70XEINfm4spr2DotLXDmIZfU6vh4fM/UbC8?=
 =?iso-8859-1?Q?h7lE8qArN8LnHQliaK4jzrzlK+tizQRs/wbqfPlZ5FdEAR8Orw0iDPRT4q?=
 =?iso-8859-1?Q?a9htEmLOXWJAmODpclaurerotCc0N1RQpXBKyW1IO4b3SEYVjKoN0iCdYt?=
 =?iso-8859-1?Q?7D8c2g6xuaOLAF9wl+1Rrxv0Qnv1zkOY+Aredaqb0JmAZEHQptBkn8zGvo?=
 =?iso-8859-1?Q?TVaqcwJEQfwLdT9fzAFRLBKSO9PkfHOa2OzrY8SEz7izVL18ObrpoUBcKy?=
 =?iso-8859-1?Q?hgs+RtDfzwIk4=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(35042699022)(82310400026)(14060799003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2025 16:07:52.5761
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c709460f-4b0d-42c2-be4d-08de05bbab73
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM2PEPF0001C70C.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB6662

The ICH_HCR_EL2 traps are used when running on GICv3 hardware, or when
running a GICv3-based guest using FEAT_GCIE_LEGACY on GICv5
hardware. When running a GICv2 guest on GICv3 hardware the traps are
used to ensure that the guest never sees any part of GICv3 (only GICv2
is visible to the guest), and when running a GICv3 guest they are used
to trap in specific scenarios. They are not applicable for a
GICv2-native guest, and won't be applicable for a(n upcoming) GICv5
guest.

The traps themselves are configured in the vGIC CPU IF state, which is
stored as a union. Updating the wrong aperture of the union risks
corrupting state, and therefore needs to be avoided at all costs.

Bail early if we're not running a compatible guest (GICv2 on GICv3
hardware, GICv3 native, GICv3 on GICv5 hardware). Trap everything
unconditionally if we're running a GICv2 guest on GICv3
hardware. Otherwise, conditionally set up GICv3-native trapping.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-v3.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index b9ad7c42c5b01..bc42c05b53bac 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -297,8 +297,11 @@ void vcpu_set_ich_hcr(struct kvm_vcpu *vcpu)
 {
 	struct vgic_v3_cpu_if *vgic_v3 =3D &vcpu->arch.vgic_cpu.vgic_v3;
=20
+	if (!vgic_is_v3(vcpu->kvm))
+		return;
+
 	/* Hide GICv3 sysreg if necessary */
-	if (!kvm_has_gicv3(vcpu->kvm)) {
+	if (vcpu->kvm->arch.vgic.vgic_model =3D=3D KVM_DEV_TYPE_ARM_VGIC_V2) {
 		vgic_v3->vgic_hcr |=3D (ICH_HCR_EL2_TALL0 | ICH_HCR_EL2_TALL1 |
 				      ICH_HCR_EL2_TC);
 		return;
--=20
2.34.1

