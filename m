Return-Path: <kvm+bounces-65850-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 26A21CB91A7
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 16:25:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6962930A298E
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 15:24:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38D1032145E;
	Fri, 12 Dec 2025 15:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="kqi3FJ1U";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="kqi3FJ1U"
X-Original-To: kvm@vger.kernel.org
Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012045.outbound.protection.outlook.com [52.101.66.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 808AC313285
	for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 15:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.45
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765553029; cv=fail; b=Cand+ax5HTJRMa801aDYWf3fYZVe5QMKeNUVeD0J8od0Ou9BXXvyOtPxNeMsb4+xncIb8k9VhADIoszMGIzbWSsyI+uWg749d/SivFrsJcVKpgFucvciI+VSqC9biZM+fr5obVq780mCXHfQltItKo/kEZchzCqd88KlXEry4SE=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765553029; c=relaxed/simple;
	bh=2JjHupT3oQLFjBWcEhbbNgRJ70toNFOUFHuYJ7gtOEk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=QXeJv09qlROpDPCr6/7c6tWpWCtyWq55EeJOnukbw185oZwRn+BULdnM1uDV6ylZI9HDAmjhnA7nm9HbXJFluXTjGIQ+1FPLyyRMJRlHS7l80vMXM3a6WWm9qTW4zGlfxhZsJKUoTYl9FDvjJQZbtXTDn4oLIvEw3AhCbFw7aG4=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=kqi3FJ1U; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=kqi3FJ1U; arc=fail smtp.client-ip=52.101.66.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=FOPewsna53XaPFEwVyI93Qh09cd4IopLccOwTG8BJgdx0SsW+txO0fMmm96dTr9SkgQm9fBXgD0pZ0jIa4VKOMG5aGttTKfM2tX5tyWpzxzD9FsJCYopdv3adcyvq/NrXUiXoa9oD76+BA0reDqx5AeeduB54xaeQ+KITUUL/h4ZHr8tnk415NRNRgMLxa4j0VMv3UQHGtJOeA7FMNJEUP1qkqWYsR+lYxxqx9E8kNdHWd8xPNkHInaUxGu3TSlmRzJJzitNgSEybMJl/gvg3MFz2fp5ftAn3WYOrYdO2irDAXFQrsEJpQzjIlR2n0omfHSvR+OBAyeaigGQ7SD5Vw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rouLkxmmvffLePxqI8f8Q8k2HRCkAxOAHbJkLzWe9fc=;
 b=mGlt0TAVKeQy1iWw/dVeDljvrfyXbBTVmSmUwfr/OotocDJaSa7fK9m1kIPEAYDsajo2iDbwfAmSXNdv3wjzhl9m/JFV20awmo+SwGKPDjWkJoL/vcS/B648Ifcbi2qBDy7Z3RFUXn0jSCQiU5E5Wea+Z+hc2zEQla/7VzE7crp4D6FZhofoy7rpa0WtwRhuZBfyz1vcD4adgiWV0tf4p4QAY+gM4VA1RXtp1MaKkZLg4CcRRdjf7JMiyJ9k8rklrXCzRaZBn685Jfos4EWERYcV6xKellzXTjER4KHJE+eaNOmsmOPEAmzJKx3q9FihRjg+2swfGH72dSl/jpKFOQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rouLkxmmvffLePxqI8f8Q8k2HRCkAxOAHbJkLzWe9fc=;
 b=kqi3FJ1UzbzfSwxABxeF6vtZHteT+Ff7v/8AlL4qXelmUNQxi2j20HR2ycDC1CvggOZHeKyoplr4KakC9XGuP+ue/liSBPFvqcycfDK5rxgHAK2oLXbDxCyoz6ZzSDn8IonG1dKnjdFnnQJuWv6vRIZwU3OYgP6l2OqCVxKcSrU=
Received: from AM4PR0302CA0017.eurprd03.prod.outlook.com (2603:10a6:205:2::30)
 by PAWPR08MB10118.eurprd08.prod.outlook.com (2603:10a6:102:368::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.10; Fri, 12 Dec
 2025 15:23:42 +0000
Received: from AM2PEPF0001C70E.eurprd05.prod.outlook.com
 (2603:10a6:205:2:cafe::17) by AM4PR0302CA0017.outlook.office365.com
 (2603:10a6:205:2::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.9 via Frontend Transport; Fri,
 12 Dec 2025 15:23:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM2PEPF0001C70E.mail.protection.outlook.com (10.167.16.202) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.4
 via Frontend Transport; Fri, 12 Dec 2025 15:23:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZMoq5EJgEdrJE7J5u3rYJGIIAWtYJ+HJiv14dDIwzlZ3QT5PsC9sNEuTPclWFW6ho//GfaZGiEp3RcjG0p6xO2ZXps0rH4czFNhIHcRF3q7SR15KQD1p5eQFHMfzB+aABBDVpfkBG970okhpDr74rC64jqfcdKz9kZL00zd8gD4quAMYhdbR0d2vKq/jV9p/z/pau5j6Tp8kLW44Q7AEnm0+vWXW+Y+pa2o0dcGaDDo10fZtAUKR0hRGoNlAjb7LKvkMzZiRithnhuNqBH+NK74U+gb+LyQxJ2C9eKWU7qvoSEPqS76ZdfN51dicMyRrV9rTEap0p9IwG/deVYtpxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rouLkxmmvffLePxqI8f8Q8k2HRCkAxOAHbJkLzWe9fc=;
 b=U55awXWPihBNJwUnAy/6YbutJwt6xFGmriAX6e0Qtmnwom66KCn/vCEluumTpypwH/CLszYJXeIjLQ61aO0L2qBqD1KP+ZC3HFoN4eMmz4kxdFU352JXIv1lRQtOhvnI/VkWfvrtakwmh4hYOgRa5WiAPFmUCIfsa6alXzoGFJawXmmvfMy5fRBie3uwnVHUoSyHEuH3ApaJUG9n+0RkBVwXhxQCEKVFhfP9RIGMmGgjwqBkhlrwtHRXleCChn+FtsSNLt8+OSmBOomLNO7kxdz2HC4kgmFVxInLxCuze1yW8vrwtCpX0lrkqZ9k35FFX/N7kPzqVn4mRLzImpxTyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rouLkxmmvffLePxqI8f8Q8k2HRCkAxOAHbJkLzWe9fc=;
 b=kqi3FJ1UzbzfSwxABxeF6vtZHteT+Ff7v/8AlL4qXelmUNQxi2j20HR2ycDC1CvggOZHeKyoplr4KakC9XGuP+ue/liSBPFvqcycfDK5rxgHAK2oLXbDxCyoz6ZzSDn8IonG1dKnjdFnnQJuWv6vRIZwU3OYgP6l2OqCVxKcSrU=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by PA6PR08MB10565.eurprd08.prod.outlook.com (2603:10a6:102:3ca::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.10; Fri, 12 Dec
 2025 15:22:39 +0000
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704]) by VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704%4]) with mapi id 15.20.9412.005; Fri, 12 Dec 2025
 15:22:39 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>
Subject: [PATCH 12/32] KVM: arm64: gic: Set vgic_model before initing private
 IRQs
Thread-Topic: [PATCH 12/32] KVM: arm64: gic: Set vgic_model before initing
 private IRQs
Thread-Index: AQHca3snwcAyioK9HUitkB89CNEd6g==
Date: Fri, 12 Dec 2025 15:22:39 +0000
Message-ID: <20251212152215.675767-13-sascha.bischoff@arm.com>
References: <20251212152215.675767-1-sascha.bischoff@arm.com>
In-Reply-To: <20251212152215.675767-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	VI1PR08MB3871:EE_|PA6PR08MB10565:EE_|AM2PEPF0001C70E:EE_|PAWPR08MB10118:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c6fd8be-7762-43a5-b928-08de39926ec2
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|366016|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?MEI4asUYOUb32o5g51DxpHZCBeu/ROKHtLwsM/qLyPWBRcIKdFFofOL5C1?=
 =?iso-8859-1?Q?fqmiY9rxAo0N1C1MQVODJLIwirQT2TMCroD+cJCQ8C3EUvBtnRKVJd6R10?=
 =?iso-8859-1?Q?UOXP1QU6YpaJttq+Vq6Zy+15uGSu2hJYB8zWiJBKL4Jkmg0fCRTpDkC7sY?=
 =?iso-8859-1?Q?+SYK/5R9gFvAparwPAiZVQ2XFupyoPX6cewKdByPfyjfINOCjT4TYXFzUq?=
 =?iso-8859-1?Q?bLQYlcZTEXP+InfxYYOhnL/bMQXga1etdtmeBcDiWJ8ubNi2TZ8fw8jQYy?=
 =?iso-8859-1?Q?2f0QEQXwXvG9NVw4EItwtAhaE/xQFFF/LfBqZJOaxn3m22J+ozpxEQE/Gl?=
 =?iso-8859-1?Q?XPMJ+xG091pLok5Dc0nt5GRMWX/9tDmJVerzXOUQ9zdKX4P50GQQrm68Fh?=
 =?iso-8859-1?Q?XaV8OFkgJIQleGq44QvzZxjuRqiGhFxrckmIVpoLNfNp24nVDFJfk+3Diw?=
 =?iso-8859-1?Q?WkHULaWTsltsmUNzOmKGesGFpX8H9H/i7i2TwVYXIdhfPytx52rsDI/0Qz?=
 =?iso-8859-1?Q?+gzbDFaMLZ1EdwW/ZXBgiek07NnXIZi3UHeMK1pl5EO08rby8bN44D/bfl?=
 =?iso-8859-1?Q?aYSljNPnbBc1hUHCeO1mvFWgRuE66hLM8Lvc91M7qIjxTcAyb9yR4FTTAD?=
 =?iso-8859-1?Q?39UH+9hKL+G7zUbastttAw2rU099eCmOrAoMpQJ5B/Khu35uSaqtw/a/1N?=
 =?iso-8859-1?Q?cqfiwzzN3Wpmf2S/2OcY5gFpz/yJ3021yendV9EyqAPxkeJPgKMOEcJT/+?=
 =?iso-8859-1?Q?HqmYFfjIjA/SNZiL/p81lDLK4r1Tnozs4iie7t35898pM9xpfHMxNtOWIz?=
 =?iso-8859-1?Q?+wEBaiaMjFeIPCYUU1YzIf7Er6CHoe0vhQBUpl9gD9lMDLfcIpGLnJpGGR?=
 =?iso-8859-1?Q?MSOvd0p3Lmr5tXjxH9C7Tu/trcVHzti6180UjzSz1DvZkicFAO2+mLf7w1?=
 =?iso-8859-1?Q?vNIXzPSoMDq/QCfcYVCBlk4THk6d28u2Dh2jXLZAltoVIl5RvCnBCXVtOC?=
 =?iso-8859-1?Q?P8Fi/OUF6Angs+3BMLLoE6ir2pjXNe/dh45k9QAHQU9ly5hnpIYmhs9oMT?=
 =?iso-8859-1?Q?t0sr8ZL2T1V70WO2JpG4AKPpXS2ArNO/Fq/0LZ27kAyXm+IrQNjTqImfsN?=
 =?iso-8859-1?Q?6XAShYxqCksWZRoBg37cCw7YoKbB4f2NwqphU5qQPk5ZK/JSZPqYkZGM3G?=
 =?iso-8859-1?Q?gCjhOUwotQ/2Ttc+jKlXmwvMHrWJA9Z1rmRBIjjo9GCFrGpRlyUuxQ8gbw?=
 =?iso-8859-1?Q?EAGqElkuuWS2BsO1fKkBf33CoGfwa/yGVT+EBfkazDikAFjG8Pbm7C9ORv?=
 =?iso-8859-1?Q?hVQMk8qqH+lrHifMXayb8Da3vRyrDP4seiMCiGFS1+V8Zu2LAAsIhxZyZX?=
 =?iso-8859-1?Q?Fy/VdAR8K4ivfJBmrVJe+bJiUbhXZS00MPTexQMnhKxSZTXUFMHyBAerd0?=
 =?iso-8859-1?Q?KyTfBGNVzyd2pl9f2M5qoFEbEh/4s1myfWPSR/IxBpumSR98pCT0lHqi2x?=
 =?iso-8859-1?Q?LmmorArTWak0N+aI3d98x4EoeAWF2KfrcAdEF3Iy2RbeKfUTa3DdLCiQVD?=
 =?iso-8859-1?Q?aE5VFH9qBad1Gz1MHIhkSkfZ7IRN?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3871.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA6PR08MB10565
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM2PEPF0001C70E.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	38c501e3-ed84-4b4f-fadf-08de39924983
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|14060799003|376014|35042699022|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?LoaQZtcxe/0HB1kzC1L5hX47/pgxxlDIQ0B0KZ4Bohsy+Qwmpkhn/0edo0?=
 =?iso-8859-1?Q?6cqSEmWcQmNU11sxD4fJHjy6uSDyLLeLuxNJ1ucCz1GHObns0VBLTjwSSL?=
 =?iso-8859-1?Q?S3o8g6ijPptV2uPw+7Ao2XLEjir5A+uKmYR8Oq64eXuGKqShSOJh4XwdIK?=
 =?iso-8859-1?Q?J7Pi2HKvjjq4l023zVmU7QTcW3ibnLqvlxW9ar0HYY572fNjnKSktUSL1z?=
 =?iso-8859-1?Q?NfCMB+2fvzUrSVgK/ivNqngrbAxQ4lztHmd5kKl5jFQqr+PZt4WW883LZ/?=
 =?iso-8859-1?Q?YiFy/M0vnacv946J4HtDpmuHNvgVvjBFigOi3vNeOaf0uRHVsNCG2VbwYM?=
 =?iso-8859-1?Q?iBVTI48sMuuPYwu3nWKZEFtzq9ATslslr8s9kBtSpXJW9M8hpukbry4Ocb?=
 =?iso-8859-1?Q?N10ORo4VwttqQd8Lq2GD8EMA2i84NsGwNXOagvuD9OBmE9JC3g4SxatVnr?=
 =?iso-8859-1?Q?NBDXmv/iuV5CP059pzapPs45fyGOZLTcEInE6UNmchK7g3h/ZB2WkraBTG?=
 =?iso-8859-1?Q?+t8o2bi/9Tf92Q5oCqCO6IpMmrPuM8U/+yOaCdo5HEqqrRAOqOKkKesZxr?=
 =?iso-8859-1?Q?EEAGmoe4tw+YxG9MkxW5xC6YkF+iYJyOS8/Lu+46mgaf8e4iwyw9sQjCNl?=
 =?iso-8859-1?Q?UVEYKD2i9R/uUOe/xtlIxTtHvQ0ONWvuf2kXEEC06yNG2Il9l4t0dysui/?=
 =?iso-8859-1?Q?Hs5FqTs+fZM7ev2qlkjj71JA7VA5op4TG9VgVyKunD3MK4Vb0hRJrdtekP?=
 =?iso-8859-1?Q?ZLNRxY2T/amM6TtuGpnCmeHB70wIbGT4XnRtsJ71ooEKyfrtfCkWZJ8BK3?=
 =?iso-8859-1?Q?Zi/TB4Q+kaYpnuBfjBIyNp4hb8EmkJH28qKO1cBxhz3aOdT6jwApFRyyTc?=
 =?iso-8859-1?Q?G4UJ33ERoHdNdreQNX/EqhkXyocn7IGmd0Ydvin9Qs5MzCgiSqSGKEQ3UU?=
 =?iso-8859-1?Q?I1vhiPpeP76X8FSOhP/PJxUiyr1detB3zoWr0Xg2oWNsjLtk+EM8be7ITn?=
 =?iso-8859-1?Q?oAGQ/PtLP81zpi5oV9ZrP9qiMOFIMOmppcc/rHTjeMU93s9w77zW+AJReL?=
 =?iso-8859-1?Q?VVZmdXh4KIkOmHsK4XY+Lx9+6KkqtBH7eKM280n5IGphK8AaHCqRJyivQJ?=
 =?iso-8859-1?Q?PeUWLc7FtnAj68A5STkNsxrMg2Cu7iIS/VE22VCVxoGQ61tsTe4MuPMWj/?=
 =?iso-8859-1?Q?PwErF+axbvynurqU7YDzzRqe8qZLrgvUVW2+p19pNT0aKx/e5ksFtu10x9?=
 =?iso-8859-1?Q?4+WPJjDSRPMB5DdPBWfdLc1CELkN8XWH5EZ8CP648ABnvjBzBcbWMLoTPp?=
 =?iso-8859-1?Q?rl5cfvfIPYOti0IMHuLUejz8HOmBsMVJnL5BP99VIDxp6Pzpo5V0xJbcC3?=
 =?iso-8859-1?Q?/BIu9KvkFahVQJa94e8aYOXWxRuioa1wLhEX0Nlr9fj9U8hi6hjiirIwB9?=
 =?iso-8859-1?Q?XQvHjMgL60AT5iNpR6gKEfmFZOKCJ0tzMDphr6Z5XWmCdRpBtvvoTsRJ/R?=
 =?iso-8859-1?Q?gV/MO0ZgUFe0BZ8ZSoGIqcPkYW9xOPs5o9OIn6SjwKcUKRTULQ1YM4stoJ?=
 =?iso-8859-1?Q?wgnHSU+6wzsg/wJudgh+oXmMpZI5qjcAkYr5F95Cbk0LH17Uw9Nit8MhWq?=
 =?iso-8859-1?Q?oQDJwAreK9qfQ=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(14060799003)(376014)(35042699022)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2025 15:23:41.8534
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c6fd8be-7762-43a5-b928-08de39926ec2
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM2PEPF0001C70E.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB10118

Different GIC types require the private IRQs to be initialised
differently. GICv5 is the culprit as it supports both a different
number of private IRQs, and all of these are PPIs (there are no
SGIs). Moreover, as GICv5 uses the top bits of the interrupt ID to
encode the type, the intid also needs to computed differently.

Up until now, the GIC model has been set after initialising the
private IRQs for a VCPU. Move this earlier to ensure that the GIC
model is available when configuring the private IRQs.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-init.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-ini=
t.c
index dc9f9db310264..b246cb6eae71b 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -140,6 +140,12 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 		goto out_unlock;
 	}
=20
+	kvm->arch.vgic.in_kernel =3D true;
+	kvm->arch.vgic.vgic_model =3D type;
+	kvm->arch.vgic.implementation_rev =3D KVM_VGIC_IMP_REV_LATEST;
+
+	kvm->arch.vgic.vgic_dist_base =3D VGIC_ADDR_UNDEF;
+
 	kvm_for_each_vcpu(i, vcpu, kvm) {
 		ret =3D vgic_allocate_private_irqs_locked(vcpu, type);
 		if (ret)
@@ -156,12 +162,6 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 		goto out_unlock;
 	}
=20
-	kvm->arch.vgic.in_kernel =3D true;
-	kvm->arch.vgic.vgic_model =3D type;
-	kvm->arch.vgic.implementation_rev =3D KVM_VGIC_IMP_REV_LATEST;
-
-	kvm->arch.vgic.vgic_dist_base =3D VGIC_ADDR_UNDEF;
-
 	aa64pfr0 =3D kvm_read_vm_id_reg(kvm, SYS_ID_AA64PFR0_EL1) & ~ID_AA64PFR0_=
EL1_GIC;
 	pfr1 =3D kvm_read_vm_id_reg(kvm, SYS_ID_PFR1_EL1) & ~ID_PFR1_EL1_GIC;
=20
--=20
2.34.1

