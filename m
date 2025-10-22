Return-Path: <kvm+bounces-60824-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E85BBFC453
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 15:50:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 082DC19A54F6
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 13:48:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBCD934C137;
	Wed, 22 Oct 2025 13:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="IDhQWKAV";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="IDhQWKAV"
X-Original-To: kvm@vger.kernel.org
Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010060.outbound.protection.outlook.com [52.101.69.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1CC634B40A;
	Wed, 22 Oct 2025 13:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.60
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761140779; cv=fail; b=nCMJ/w4tWuRK9FHH+AVSSaZPYnJTNOFguLY1JAeGQoFAzXqHcujcNnAc0TtnE5LC2AhClpDeWZa2zJMT4BpI2eWZ1BXws0XRj0PrlfMMEJkreSL2ISmL6QfOr90b4FtmIsFu+2VFG2EE60ke4YmhACi1M0v3pVkhT+qYF75Covw=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761140779; c=relaxed/simple;
	bh=QhRbLckhrzKhUoMtzQVJ6sHsmORCaYEsM95JRA49VrY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Jj7XEJFm4tNZ+M1ujHiI7cH/h9rWMq1KYh8o3rBOuzIwMP3q0+DrmE/66KgsVL3TpL7jYIYzDVxHsMb4m2lsESi/q1iy/ypHOVDbMxYqhWVVxUUwA6aBdc1VWteus89FQs9YC5JPt9awqG2u862d6x4wk+wuUqvuIPHACs4YHnE=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=IDhQWKAV; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=IDhQWKAV; arc=fail smtp.client-ip=52.101.69.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=FXG0vcIX6nrLYKIwhyrQe1kxkzV2Qjem8/VcdITD8KEoySbp5wnMCCF1onZrdxofP9EnfiJPn4kxc3GugiQvb/0IU7DetIH0HwEA6FigdqKj7T/y4baGYrkPoPRuTFbk+7x9HGRUOr7zHJ0wCzIkidErrypghiLw1YDtayi6EwbR+H5aJe8oE4tginYYohKdkCBZT5TSwNe5dx/f6l/kf67epk6UQjdHLw9FuDTqKh9838RcvR8OXUTJV5e2ub6cYUF7oSXJboKywHwo5kreGHiJuTaET94VodQAaue9YTjLdsTGYFx0kWhwSZ+XOEyQ049Fakejor47Iuy+o7rmsQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B3GYMZNZcjzuo7P0IqYs0wgmC3uSZOue0AnZUQzypNQ=;
 b=UW0oFPlFN1rQK1t73InIqx1eC6kMN+UkWdI1XclG6tO4BZDD3rlkUjGFL+yZPppG67GUYNK9Y5/vg+3S5nqgg+bzr9SgpuUZvkNgjO2JOOkdNG/XBhO/8GsZCmqRi7KNs35sa03HtT41OWfpeGq0fBNRIDC2hI11oOGHGE66mLrd++cRQB8KUyYg8lMbZ8ZxYVdkWhgdhMoZaluMBxBsl06uFH38o8uAdPjk/ichHRFlb1rYTwrVKZFleu+TCn24LWBTDyX3H2lknfMiVQ3x34DDeMgmNG36ROMy1GdsmJCXMUZa+iqcKK8nvMqdoBDK5tdQ1OOKtlXzARl9hVaqew==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B3GYMZNZcjzuo7P0IqYs0wgmC3uSZOue0AnZUQzypNQ=;
 b=IDhQWKAVm03LSVfT2Vh2Mqw50nnsQ7UvKNjpKwLfUSKRYVT+Xt4FsHo3RGZ7cxjpqXu3LYEOCHhbI6W/4INY2nT8zxFjmlZCQsHDWHU4q6GRaYH7kshnVuT+J/I/2i/uWqlmKzIrMhGaQboW0XxXXxRjLdCloNfW9kP311eZYcE=
Received: from AS4P251CA0006.EURP251.PROD.OUTLOOK.COM (2603:10a6:20b:5d2::15)
 by DU0PR08MB9107.eurprd08.prod.outlook.com (2603:10a6:10:474::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Wed, 22 Oct
 2025 13:46:11 +0000
Received: from AMS1EPF00000041.eurprd04.prod.outlook.com
 (2603:10a6:20b:5d2:cafe::f0) by AS4P251CA0006.outlook.office365.com
 (2603:10a6:20b:5d2::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9253.13 via Frontend Transport; Wed,
 22 Oct 2025 13:46:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF00000041.mail.protection.outlook.com (10.167.16.38) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9253.7
 via Frontend Transport; Wed, 22 Oct 2025 13:46:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gyQixevn3hdGdR5sR1V/9E9KnKEwTv+mnqyMyv47cRxlPv0OlSNCSnv7YjThvk3DiR+0XumNe142ZIT6kup0wm2u/HNxUNzkicLc+voiLmIcb+fAW+l5Xb+0BAOfFJNV+WcVfRAO7f9Xu+MpopZpEI8t4QfTLMuxDR+oDYXc5OpZJODxpMgdMTXRDUhQW7FsopKcMsKeTERdKzpZq2K0UdL/Ub3OglCmucd05zD91I76EYI8a2kxIC2/vxqNvdQPxzx+n4yRraooYwFTJB/cdKz9Ixqo5Plh6zWJFIWyNwx/J5YAYPV3rjc2mJqKg9ADXrcfAoYpjL9aKtJTxyYAJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B3GYMZNZcjzuo7P0IqYs0wgmC3uSZOue0AnZUQzypNQ=;
 b=kPqtOFzFeaelTLXs55u0/jlRznxmVAnFxME/fenPPwM6Z5NYZu6fc3vjK+jaAUg4XTTWhVSSm1QzJZuVjcmuqU2cxorDZGHDN9+450ac9lcpNcHUzHVKEldmZ5SloSjOAS5WyBK8E5T9VXklHKtnOZsaz8HnhUYPpe0uUNpQiG+wM7SUkQ6kfaUx7ES+oT30xiNeiSqIHGfjWE/kvC4iLckHOB3VfwndOvexUXIbz5IL2xNqOB18k+cYdtYzPoMEryz86O4pGVDbe22vnMxjHHEnMmtdY6Vfen5w+uJDn9143WWNSd88f56HrJ+5snpkJ9EOV0wUMPuky0Y7sJdvSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B3GYMZNZcjzuo7P0IqYs0wgmC3uSZOue0AnZUQzypNQ=;
 b=IDhQWKAVm03LSVfT2Vh2Mqw50nnsQ7UvKNjpKwLfUSKRYVT+Xt4FsHo3RGZ7cxjpqXu3LYEOCHhbI6W/4INY2nT8zxFjmlZCQsHDWHU4q6GRaYH7kshnVuT+J/I/2i/uWqlmKzIrMhGaQboW0XxXXxRjLdCloNfW9kP311eZYcE=
Received: from AM9PR08MB6850.eurprd08.prod.outlook.com (2603:10a6:20b:2fd::7)
 by AS8PR08MB9244.eurprd08.prod.outlook.com (2603:10a6:20b:5a3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Wed, 22 Oct
 2025 13:45:36 +0000
Received: from AM9PR08MB6850.eurprd08.prod.outlook.com
 ([fe80::e3e:d073:8744:60e2]) by AM9PR08MB6850.eurprd08.prod.outlook.com
 ([fe80::e3e:d073:8744:60e2%4]) with mapi id 15.20.9253.011; Wed, 22 Oct 2025
 13:45:36 +0000
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
	<lpieralisi@kernel.org>, Sascha Bischoff <Sascha.Bischoff@arm.com>
Subject: [PATCH v3 1/5] arm64/sysreg: Fix checks for incomplete sysreg
 definitions
Thread-Topic: [PATCH v3 1/5] arm64/sysreg: Fix checks for incomplete sysreg
 definitions
Thread-Index: AQHcQ1ol731YEYl+mkKHLOWUL2jp4g==
Date: Wed, 22 Oct 2025 13:45:36 +0000
Message-ID: <20251022134526.2735399-2-sascha.bischoff@arm.com>
References: <20251022134526.2735399-1-sascha.bischoff@arm.com>
In-Reply-To: <20251022134526.2735399-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AM9PR08MB6850:EE_|AS8PR08MB9244:EE_|AMS1EPF00000041:EE_|DU0PR08MB9107:EE_
X-MS-Office365-Filtering-Correlation-Id: 7173b414-171f-461a-3c74-08de11715c63
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?dhgpJ9xneZabULWP8W8Y/QqOJ9cx1s95TJvA1BxjsHc07pDt7SHm6kXAz/?=
 =?iso-8859-1?Q?4XDBeGvpBsui3d6BK8VoQxo0AR9Y1xX3MLoql9OhAZezqIcA63D6Cq0BY3?=
 =?iso-8859-1?Q?VoAuUYsrTAM5Ryum3CYWeKsd2MmlG9Kqkp5nVOuA6HeOiN/81TKBmQmyT5?=
 =?iso-8859-1?Q?dJiIFB5cxmfGEtN1/3Hd1IHC/cQDtlOHqoSN53+V16dwnCSYakjforeqPV?=
 =?iso-8859-1?Q?MAUdiT+Wp+akQUQc/zWVianLgBKry+brUmWxMTfJiEu+r86diX8IAy55rC?=
 =?iso-8859-1?Q?SU76qeCSV8ad4B73Qw0sJ5VywVYEz2ExFqPGj/qjb0AFYRNGXRLsov7amI?=
 =?iso-8859-1?Q?lSGRoxRwjDfWAZNZ1OYcDQ4/El9jYT6Ej10XbwE1In60No+SSktNhS28pR?=
 =?iso-8859-1?Q?8xSbfv3xCxvaOAgUa5lfFAgRSG0iO0plaV1le4iDLkOEi/Z2z5+VSwzHah?=
 =?iso-8859-1?Q?PbBJLhcOCT0fGz/xkPCCR1av4ezi+Ri4lx8JF2Xfdh0aW6H3JsXwGTvR7M?=
 =?iso-8859-1?Q?0/l+OebOZEX6+kF4g9rlPsmRdN5q705F3ctFDOVoQG8deTxjynQou0EN91?=
 =?iso-8859-1?Q?/ioMfEKVaU4uyf/FqXgTYi43basRS9gPD8+ADXf/oe1Us7x08L/v+SZ7d4?=
 =?iso-8859-1?Q?5rtm7QLfga9ndk6lub+k5EayyHhTSdHyIWIfGu2hH5+heWRcLk5Kd9QZZj?=
 =?iso-8859-1?Q?9AJqX/LiIw0sKwVIdlgYwgZ+pgNwtiB4XVKN730kpiD/ytIjaZPRjY0mN8?=
 =?iso-8859-1?Q?1JbAtlWDZDfMR8VFkOLYZ9+fKvx+zLfIAeI6wCT4bf9F2MVTzr3a+Ca0kP?=
 =?iso-8859-1?Q?caSvrlSZ311mc3EJZoNejVCGi9u4hhAg5XguahN+OubpPmpONrZ53SgGe9?=
 =?iso-8859-1?Q?OcZI2PV8426+08VEYDeWhyI+t3LV08LyqG03f9CbM4D/frfo5L+afE6ef/?=
 =?iso-8859-1?Q?NA2v337JIFwvkV3A9vQnccXbRCk+pcsSP5AtWvAA9IQVz8J4dOWcDj1gBj?=
 =?iso-8859-1?Q?fUqK82/oFuyrw+2crioJ60TvFow8S7lQHuQdAGmO9NWqBgI/ivLoQlG0kZ?=
 =?iso-8859-1?Q?2f15p21v5AUSafChru3AgYjJqCxIt43TdrpRBGiY6086HKa6k8fWRULvNO?=
 =?iso-8859-1?Q?m0cKO/LZUQXq18t8XNT/BPhXSMfC7W9VfJHwLMrWLRYfP/sngARYeavTPu?=
 =?iso-8859-1?Q?yudQDmbS6SzdRj3zqVu6L5qUBc2+KnmuVt5BkwRoEi3W7oXR2w2Sv+ClnM?=
 =?iso-8859-1?Q?MjHHKG+9F9o2ikDlHfDn7DksmQnNc1F7afuLeVuZ2vg7ii1yeplMoWnIsG?=
 =?iso-8859-1?Q?5sTtPY3rz/A2MJUgl0jrni9oMgVeKY4HXh6NxNshAGL6ETjJBi3cvJYbvM?=
 =?iso-8859-1?Q?AWU8BmEUHNc4L0VuN4pbAyeJWCpu4/uCbWcjkgqC2LqC9pFZYGdl2Ecx5j?=
 =?iso-8859-1?Q?XRHt7eB4hjaLwXzFVdA4ZemXpZ5K/9PTg64wym2kX/fMgNw+AnVlYOKBba?=
 =?iso-8859-1?Q?FFxRLrI/CLmZU8epTSol7gmmjWqJeG2OK/wJH1UY4hRiPwu7w1RKvVppno?=
 =?iso-8859-1?Q?l0HVPbDFBP3CK3QNBf9TZ2BUSgf9?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR08MB6850.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB9244
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS1EPF00000041.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	aba1cfb4-425f-4d5b-7804-08de117147bf
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|376014|7416014|82310400026|1800799024|35042699022|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?AwTKso9jKH+kadMlRpoa51V9xT2C//x9QfmYmkS+kD4ZY5qS3otwpx0s8C?=
 =?iso-8859-1?Q?vs08liS9iMmB2uiWC+82atcJSCmVEB7g0J2b2q37LRM1A5yQxKr51qRdfo?=
 =?iso-8859-1?Q?gx6jUc7+44teKAKbNab6EKGqRz+y1WKNhugTcc3JJE8u1eg/m/2kXf1Kcu?=
 =?iso-8859-1?Q?1HscsKm9idKn7z8Q4bFu/+40OCXrcgL7uZatIpx9X46quA0PQxvIhpVbs2?=
 =?iso-8859-1?Q?su9Vlm1pOf4W2FOvzvNVZxvDXiD6wJbK3lgl0iRtdhvBRvMNpCCtGQL1lq?=
 =?iso-8859-1?Q?dGTtD49LeqtVsBFnRHtT5d/e9JHrsp/J/vNT9aRngKC+9cPRd45Y+4Ykzn?=
 =?iso-8859-1?Q?1bihck/jukAmLjadzzzfVHAJlhDg0/cXVqBd+cSiZ/m1xcBU+2VbwplsBR?=
 =?iso-8859-1?Q?tREzVJs67EeNXVv5bkCg/roYdzJvTuBFfkZ1VyF2xKJ6SW4ny1imEYfBAf?=
 =?iso-8859-1?Q?STN0yNeOrMZo5XLNpj0g6Nq0FrA7WQaA+AX2z63NyV4RjEyPvC5/2F44Eo?=
 =?iso-8859-1?Q?bWQxPCXn7Pr+H8o+QCOuD36qCwlglVpFnZiRvAxNwBxarcWfxQ6eUK5cvH?=
 =?iso-8859-1?Q?NWETlcH887kdjKH96dzU/VvCnwgU62G/62JQYyJICPBG5OfNl96RKFzVu2?=
 =?iso-8859-1?Q?1AAPjK3IdKuzqVYBaxjXIUexpwlxZSDoHm/QdoLQEQJ6dAH/tSSNIuCcWm?=
 =?iso-8859-1?Q?q5cnrrC53RE9mmt7c9nYWjVti5GVrSAPSGJCfO216x8xq/gcYeG8uxkZAY?=
 =?iso-8859-1?Q?QTBYX94rmfK5fnq7WbmhGuFO2TQi6aKGnSLMaJutAWdPkhogQi1V0Pspao?=
 =?iso-8859-1?Q?9pXF7zoQ26Sk9iK5ZJ3rvLbW2gZDTkceMgqxa8MWVKRrxnK0OMS3fA1paC?=
 =?iso-8859-1?Q?k32tHzVxJoMzM/NBrIXcuc0PSCzjLQUMtl1GsW79bWgl++ehyecch5zh1j?=
 =?iso-8859-1?Q?+/kkzl2XM0dv5l2ox0/+U/W7ejy1FjP/yU696L8nlWwS8jJTBQZa0xSpRC?=
 =?iso-8859-1?Q?cJlpu154tP/+7pWAAjJ0mwRV+qIzmIN6wazHFwfjCQTUfDJHvf99vwJ3jT?=
 =?iso-8859-1?Q?JSOzeldZjkpcn/yfNxIrAEGo5xMEtyoKElFhb+SNU0NmA6KtPjd+6iEb+v?=
 =?iso-8859-1?Q?vNNh/nQvt+c26Bx8zycfs319lAcpg94ABy2pBXHANP/wAMhwqk6D5qMhI8?=
 =?iso-8859-1?Q?k6ZDBsuGlB4MUmWfiu6dbEw6ejme1PzWTX765zfpf2jQ+3yshmJCSJZBPh?=
 =?iso-8859-1?Q?XPUAZG2Dl3gHIsYOqqCycBzHZfr+o4LwCNETXhfQ4QBXhAkfkD47sNj8tW?=
 =?iso-8859-1?Q?mlljbuIkcx/AcI2mvxYqwwcY2rHgHNVMdXgWavRdoiK6YsHtm4dd1uSE/D?=
 =?iso-8859-1?Q?ZYHhogpg1NPlUZCodNZnqUCU2TWNwaLU7wUbYXNeTLq5oNWZghZJX7GaKQ?=
 =?iso-8859-1?Q?WrHu+idkJHu3Vatyy792dCBRz+vumFi+J3x7kygZuqMLDPrMu75EP05Cj8?=
 =?iso-8859-1?Q?tjjcRkteAcHaDjSf6PbmeQlfs5f/0lB5iSRHvVfJSbhSR2r8f4ZjwsLwLC?=
 =?iso-8859-1?Q?R+2G0kAVEjS1JRmHJvS2pboI67dH7hBTdg8Tiq6PyJ8ravtH3+wI2WH1NF?=
 =?iso-8859-1?Q?1B09IOkGTwItA=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(376014)(7416014)(82310400026)(1800799024)(35042699022)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2025 13:46:11.1328
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7173b414-171f-461a-3c74-08de11715c63
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF00000041.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB9107

From: Sascha Bischoff <Sascha.Bischoff@arm.com>

The checks for incomplete sysreg definitions were checking if the
next_bit was greater than 0, which is incorrect and missed occasions
where bit 0 hasn't been defined for a sysreg. The reason is that
next_bit is -1 when all bits have been processed (LSB - 1).

Change the checks to use >=3D 0, instead. Also, set next_bit in Mapping
to -1 instead of 0 to match these new checks.

There are no changes to the generated sysreg definitons as part of
this change, and conveniently no definitions lack definitions for bit
0.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/tools/gen-sysreg.awk | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/tools/gen-sysreg.awk b/arch/arm64/tools/gen-sysreg.=
awk
index bbbb812603e8..b5e5705ddbb5 100755
--- a/arch/arm64/tools/gen-sysreg.awk
+++ b/arch/arm64/tools/gen-sysreg.awk
@@ -133,7 +133,7 @@ $1 =3D=3D "SysregFields" && block_current() =3D=3D "Roo=
t" {
=20
 $1 =3D=3D "EndSysregFields" && block_current() =3D=3D "SysregFields" {
 	expect_fields(1)
-	if (next_bit > 0)
+	if (next_bit >=3D 0)
 		fatal("Unspecified bits in " reg)
=20
 	define(reg "_RES0", "(" res0 ")")
@@ -188,7 +188,7 @@ $1 =3D=3D "Sysreg" && block_current() =3D=3D "Root" {
=20
 $1 =3D=3D "EndSysreg" && block_current() =3D=3D "Sysreg" {
 	expect_fields(1)
-	if (next_bit > 0)
+	if (next_bit >=3D 0)
 		fatal("Unspecified bits in " reg)
=20
 	if (res0 !=3D null)
@@ -225,7 +225,7 @@ $1 =3D=3D "EndSysreg" && block_current() =3D=3D "Sysreg=
" {
 	print "/* For " reg " fields see " $2 " */"
 	print ""
=20
-        next_bit =3D 0
+        next_bit =3D -1
 	res0 =3D null
 	res1 =3D null
 	unkn =3D null
--=20
2.34.1

