Return-Path: <kvm+bounces-65853-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CA25CB91AD
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 16:25:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C7C7C30B0960
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 15:24:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 960AC322B9E;
	Fri, 12 Dec 2025 15:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Qf4/rAlA";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Qf4/rAlA"
X-Original-To: kvm@vger.kernel.org
Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013016.outbound.protection.outlook.com [40.107.159.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43D183115B8
	for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 15:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.16
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765553031; cv=fail; b=hEHIrqox4Ng/dRDHxgDBLBnAKeGy/tshCwEN9GRH7PT5dmvk4FYAo5nQVKpkl7O6s0jsOr7gP2OkNSRld4nsrVxsOexY5O96GLFiCae8DLZJSlLByGVsUAAQ2shy04/fia9A9raoH3jJ+Ai69DIQVdqBTpymyxVRg8yaulSkyUg=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765553031; c=relaxed/simple;
	bh=HJW1sIuztnW/YT9eMkrPw9vZun9VhjweO6IvrhqSQrs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=DRPkZLT6bKlOO5eI7iPeV1R+qBC9K+4F+IxE1o7DWmOqRbf2Qwphre/275YJJpYi46+g/2KyOubQ/9jzW54q1CndP985HrIpsHhGcY2c4+j4t4GCQmXECKubCB6fwuHqtuz/lEQAlyLdCjJWxcDcau1SV6iPddi08s4mdbHh13U=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Qf4/rAlA; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Qf4/rAlA; arc=fail smtp.client-ip=40.107.159.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=Bxy5f7QJ1nIT5X7fDrUr18aVZnurzjU3HWEdXTBswPUtWQgBZNmic1XTw5Q8AmX3nk5XZTFcHKWejY7ne2eauKYfeve+5onFG4ZWUv8oEvG2E88EWnpKWUZvGcMYaXHQzy1wwWkwCFlkK4L6izbNPae3wnt3EWGh7Mb0aubeJpHmNJlEw2htXxInpPZNaUvyQnBYqYXkowO7eaaYot27f1SjfbMXJHxwzgKvSgyUN0K56S4xTpz4Wt/FtQUMQt62M3STEnyHVmXR7iJ89cjB2ITGC1Y6okCvO91QT+UWj4S9BdMIBgfUrNwjvdVM86Qa21zMCv5KCdSTagZfA5SJVw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PZ6MWevsCxZAoPnDeWChrnADZ1tMzKRUS/N8T+p9SJY=;
 b=D0q2wxIZK3yPqcr+VGd8MxlJHZTI6+xNblbOPS0tr/xStZkHucHoEYt7ob/5xYmZ9RcFC6ZmbJW9uASIoaU5/k5iy+Xf52tq5vwatM42iSXjdyOBT8x8wfySA/jARiC8FmhiX/D15yfiCNKvwsRjK+sFI8tI3gsC7emp8Ijn6HXt0k/e2TOF9GrA7u4+G7PQq/NoQyyoVpFSbAWXjRq3kcP1h3L7jSE/+yaY83QV4NpeEjKpxiOQv0jR1av/WUCpvZ/OzQZG68lEAGpRuFFNilAs+VCzU/U9lqQhK56kkuy74yCxuV3QoVgdOhYDdJ+z0ZK5GVIxaGNYgc3H/x7BuQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PZ6MWevsCxZAoPnDeWChrnADZ1tMzKRUS/N8T+p9SJY=;
 b=Qf4/rAlAszHILoYotSQs89ACtUnJKCq8Uv4TlZv9sOX7khMFow02bW4kPCI6nPmVia8FG7crPTs9Ig5i6Z/8cgNzsRIbghyzKtgsEg3t4mDfQtOPjh75Oj0dpuh+QV+b0BtwnCX5GUNGCGHCGMz3oIrAgtAOW+UeSw1sw5mZKag=
Received: from AS4P195CA0037.EURP195.PROD.OUTLOOK.COM (2603:10a6:20b:65a::26)
 by AS2PR08MB10323.eurprd08.prod.outlook.com (2603:10a6:20b:5fe::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.10; Fri, 12 Dec
 2025 15:23:43 +0000
Received: from AMS0EPF000001B2.eurprd05.prod.outlook.com
 (2603:10a6:20b:65a:cafe::51) by AS4P195CA0037.outlook.office365.com
 (2603:10a6:20b:65a::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.11 via Frontend Transport; Fri,
 12 Dec 2025 15:23:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF000001B2.mail.protection.outlook.com (10.167.16.166) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.4
 via Frontend Transport; Fri, 12 Dec 2025 15:23:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nmMC7EZj9Iazpz+8EwvNNHV9HygpmDSTT/1aGhiOwqU6U+grdfb+YmUhFbpeFwhF9wNOmnjfhc0EjUZjGNq4B7fMJ+9t+Zal8JTF5/BfEo+bpVTIzsiDpWs9ByVXb6ddvBoqw01hsZ/nWTfdmoUdaVdhsM9m5OEtD4UMq8MoWN0dcIIHvDIfV5Qj8vmV/Sj6xj8kbre7f+m2QviyPZyVj9p2FxXOFsTCHOIquAnl9Uenfp3E/pkaH9Zqc32NMNcyx7fmGebdi0ZwLQUefaEdcCJtIvkF79kOloNXPt20VIZvcqfTI/kGQCoTd5HLtitxZA2ocqNI2B8TkROAiCw5Hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PZ6MWevsCxZAoPnDeWChrnADZ1tMzKRUS/N8T+p9SJY=;
 b=jPy6Trvat6Bf07N7mgqIfOIdEzg1vXZR5H/XFM69xQIqWOrHccvHLu7ZmD7NhKdE3iSp/UgrnpUK9YQhNlz7YTjePw+As//5cSKAx+2Z8ZJrxKpWJNQWMp+21/HCZ8XgKyQKZ4Dhp2Zoo7elP+c/FOzrIuYm8LuQFr1rhyOztAs24iDtazakaDwK1+jkOhyDsTnFBttgfIdVB2EymO06DjJWz5+Oz7IjgyEzs534q8/n8fo/Ooh6n6md2udBh8XWCZPQpmCQwEdk9OOfCYapgG4beCjjsIm27sWpmy4sLIbF9rqPnXnW8y9DXtKsNRJkTGZApULTfisDbTCSxBu3rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PZ6MWevsCxZAoPnDeWChrnADZ1tMzKRUS/N8T+p9SJY=;
 b=Qf4/rAlAszHILoYotSQs89ACtUnJKCq8Uv4TlZv9sOX7khMFow02bW4kPCI6nPmVia8FG7crPTs9Ig5i6Z/8cgNzsRIbghyzKtgsEg3t4mDfQtOPjh75Oj0dpuh+QV+b0BtwnCX5GUNGCGHCGMz3oIrAgtAOW+UeSw1sw5mZKag=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by PA6PR08MB10565.eurprd08.prod.outlook.com (2603:10a6:102:3ca::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.10; Fri, 12 Dec
 2025 15:22:40 +0000
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704]) by VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704%4]) with mapi id 15.20.9412.005; Fri, 12 Dec 2025
 15:22:40 +0000
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
Subject: [PATCH 15/32] KVM: arm64: gic-v5: Implement direct injection of PPIs
Thread-Topic: [PATCH 15/32] KVM: arm64: gic-v5: Implement direct injection of
 PPIs
Thread-Index: AQHca3snOVn3vQjJPUKUcgOiolLUfg==
Date: Fri, 12 Dec 2025 15:22:40 +0000
Message-ID: <20251212152215.675767-16-sascha.bischoff@arm.com>
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
	VI1PR08MB3871:EE_|PA6PR08MB10565:EE_|AMS0EPF000001B2:EE_|AS2PR08MB10323:EE_
X-MS-Office365-Filtering-Correlation-Id: 247976a7-5aac-4d54-52cd-08de39926f83
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|366016|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?lQ3leUVby4oVPcLv+jyZPCxRCP/lc6BdsPgXQPn1hBSqEsway+H0Cr9Tkm?=
 =?iso-8859-1?Q?uGCOHjj9gXOJQgdRUu5p2x2MNDeJxiDN49bfSJIegqSo1MVzc7vznf0tkJ?=
 =?iso-8859-1?Q?FpvmyY0yCDIH3BqYwJ8ewEeLKEO70znwbi5ZG7QeVUZEB1PNQXmcHcEJcu?=
 =?iso-8859-1?Q?XMHeX56u48bzfwk3XGeUi8PiEoN+aTjqQZh318y4ZWgw9hdUtPTN70Caux?=
 =?iso-8859-1?Q?Uu1ipSrIGcPB18pQpb1yauNeHQxh87kKVCQz8/5Ij9HbJG0qcVT406T9vV?=
 =?iso-8859-1?Q?UnY4FmgRRBl96c9/9fhtC0U+ZpURgrji9Z04jgd3Ayj0g1cMzoN1mN0mjl?=
 =?iso-8859-1?Q?+0XjnTlfzWUOgk/WOPvckN1BVXKPc855lPxjbu61a9UWyjJ0p1INcRq0b+?=
 =?iso-8859-1?Q?pKfNiD7NIcwwEKcuqaRx0BFul9zy1io7HtB8BAl7XanYclgZT/CsZlEp5B?=
 =?iso-8859-1?Q?W8vPyOfh0xHEzhKQ3KVkM3ycRlm+Uj09kX8OlOaYJJD2OOxvEXn5jH9uy4?=
 =?iso-8859-1?Q?jnRXXkoDZqSFW/gaRtWvUZBv3Je8dqCAguKDC4dgpvTVTXNNOgnMTTQlPU?=
 =?iso-8859-1?Q?Vl2+PU8MZNVIMNx/JXD4TchzEMd+8Rj1DpbNxS7pdNdh42ZlNfjZQhbhtu?=
 =?iso-8859-1?Q?Kv0TPyH/bMeCI4VAskrEMk0yzbCdxefvB68ht6dbwijnBqqcOXA9Ft2JtS?=
 =?iso-8859-1?Q?ikJ1ai3OlEVgqvpVRUDqUIN8c4d2YRycSyHt5EbbFUAcP2DfJMFQqMfY7D?=
 =?iso-8859-1?Q?w8GG0rbLvPQ+44MCfMtpYab0Ti/y2F/yK3nKfgJwS0+vEykh6JhnZZJr0r?=
 =?iso-8859-1?Q?4ebGMFa5mMXfbpdnX1q7Ad+LRv9Uv1CTnMPSrsT2Vd8cVKZAltkLQ1Iapz?=
 =?iso-8859-1?Q?OzW26mX6ICO3N/FcBSRjqD/aO/WN2yizo1zpn0E86bDWBRX8P3Xg3JPVy/?=
 =?iso-8859-1?Q?3LK5ZQ6y24GzQiw1S9hFZoFYbiP5lZPk09dfDOXwk61R7NSccmEnQQGjia?=
 =?iso-8859-1?Q?rdixwfHb3b46rI3k7w4886aTe1//4zW+yHFgseB7Y0R7qZmqIascSaMRY/?=
 =?iso-8859-1?Q?pY1uSLhMk4MHl9MtEgd6JdBPEqUaI52mn/6zlX94M6W/2WqNtH2rs2dhX0?=
 =?iso-8859-1?Q?vHFfZ3XQqV9rdtCBJXfmzDvhnS8DSjfve7xXt2nKRMBZB/KxpXxDnmHPzD?=
 =?iso-8859-1?Q?pu3WqmcxsyUMh6MO8EhsOrhzxx+f+ErILuxaUP5Jtq69y0d4iez18i0j/u?=
 =?iso-8859-1?Q?kBAzcpdcVR5wm8XPSinMnwsRt/L6ZZmItJOdKL7eu9DV9MKDpftPz3kT12?=
 =?iso-8859-1?Q?vs0pgDvL+7zGcRUqM7vGp7InEIP6FKSM60Nwi/bIR0kB7plY+F3WSs5pP2?=
 =?iso-8859-1?Q?Cdl0bEQJzudew/XUcga+DrMhwCvf8T9N3xdfLnBSPq4EkEnf7VfV/mmkWv?=
 =?iso-8859-1?Q?tfNJCTa86VMB1VPkVIJrW7e4TWObMcvk+xzmhX0Ko+JWdv16Yv/y05IXAa?=
 =?iso-8859-1?Q?enqp+58Zge99KjWRwRJezsoryh8m3Atc1k+rwPVgrO0+TaA0eq8wIrVh13?=
 =?iso-8859-1?Q?jlSYkx+HpUN2hAZHWwfK0P3YaGpP?=
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
 AMS0EPF000001B2.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	0f173e1f-1f37-4064-2daf-08de39924a3b
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|14060799003|35042699022|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?1rdslXF3CYJYD4EmQRxTQQS7uX/bzpGajirv6tLTNTVi6F3h/qpynCv47O?=
 =?iso-8859-1?Q?yoOpVobGv6rIotA/0q9Zt8kB2+CBFW+CPMpnK5uET6pShlMtZIvVNvpXBC?=
 =?iso-8859-1?Q?H/76cvm/QUFNW80y2Rez/JO4kqTq5EhyDeYF/bYARDv2UeBt0wKhjjIqYW?=
 =?iso-8859-1?Q?8WlbG/hwaQezmafa2uR4eDrUo5IND06035AcQGKnk9t6LgbzXvuC1W6otH?=
 =?iso-8859-1?Q?3gg+QGV+FDcGJ/69bMjMVrT0ULSvwnMn2xmVe31bccDgbjLJO/wxmgaHq8?=
 =?iso-8859-1?Q?qr+4s6WaaZ7BnUMfifcKtE3YmMZZsAwLRkhO6SF+RZPJ9KxNM0nbVD3J/G?=
 =?iso-8859-1?Q?8ehHHiTAnnSv7nFXNfoDSvktcFxYLUIQfdehK4Q9xfFAtpAalsfY6PxuKV?=
 =?iso-8859-1?Q?stEGk7osso+H9odangmgIul9m0GyN/Xu1i0XitojP6SuOPfmoccvJcPDde?=
 =?iso-8859-1?Q?4UebuOB8OBLjACkPsjwWyQtICEhVDKyUO8ylEznM02hHxvnyg54D5TAq9e?=
 =?iso-8859-1?Q?JeYGKHZJya5HFyWQO7YXnGgp6fKHNfdZbI5UM2DN1Ur0S/Yoyu+K9B5ZvV?=
 =?iso-8859-1?Q?DO9O9xlxXNmfDh/ERR2VC4eTtCeMSTeQRVBHHf36QqI3u37CPNFZPzZ+sy?=
 =?iso-8859-1?Q?GgKmWiQurXhNYj1ASzUK+7tZ9SUja8SOFJk6le3m//ci8MDxZd9MRA7AUL?=
 =?iso-8859-1?Q?qBFtYWfOYcrI4NT7XsLipoAVyAi7unKeTiAaGBzRoFSumLRMU7hMQohnkU?=
 =?iso-8859-1?Q?JBIfW+nuCeQ2660i1kvWvhqsnlGkA661jNyHhsQl5kikGNFWztcuCloLKf?=
 =?iso-8859-1?Q?oQ31X52P2TZqQpXa72PryU4fY8C1S6CrbuMNfDY2h2T1utF5goeAtWa3Mp?=
 =?iso-8859-1?Q?YPCjRCxEDRzpUkISFZFeIM0hbCGpCwMXrtuo3VW91egFPOPlf78caV1Xj/?=
 =?iso-8859-1?Q?FhhnFXWhZo9QiPS+HBNY7KhJMpfLU9x36DhBlpGAMDQ2lIhw1WhdBsyBxw?=
 =?iso-8859-1?Q?rpQAS+c8rfYHPaZ4E2P7myYiqGlabC9RmOLu/hzPxL2x2SvM5FhSFfMlBN?=
 =?iso-8859-1?Q?GZw6iri9MDgO9m+r+BakCUTy2o32T0LMnwQu848XX4lj473Wne0qG6O30L?=
 =?iso-8859-1?Q?ZmGytS1ohoiAzbzb5I+pf9ZZUwkT2qaXk0ZQZ105p+ynft/kJHvY++Pn0e?=
 =?iso-8859-1?Q?X2CfNXb1bOb2tptpGQQwtgzzyinA5O4aIKSZyFeBk+IT5rkjKWeURMp/Me?=
 =?iso-8859-1?Q?Q/dKaev6+Idu0HqX3oHI4BMT5kOB3IjVq64TqwFrqYutSEqXTFHcpef5X8?=
 =?iso-8859-1?Q?7t4brcgn3n+080qgxgEkVzyKBx46UXbiPoaCobFIATc3gBwx1RohUBw/KK?=
 =?iso-8859-1?Q?2fglESXD9sbYa4Ro/uRy6aI4RRGqIdHehnSxJtczE6BZ1I0uKavDzuSnKD?=
 =?iso-8859-1?Q?cF0620gEB6RAYizlCoGnH7Et0nrxTmFioG4z5U3Ft+i5SeWe+YSGbOfgIO?=
 =?iso-8859-1?Q?edL3UkugYzhxIgVPLUfnQ/WRdFQm7td6p+4Cvj7Q96cm+Oa10svzji5d5n?=
 =?iso-8859-1?Q?sXHWBEQRlDE9wLu93WTwE1LqXnmdTsrNwHJktpT6pxm+jz6dNXuTikvAa1?=
 =?iso-8859-1?Q?DDK2hN0cTLUfU=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(14060799003)(35042699022)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2025 15:23:43.1109
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 247976a7-5aac-4d54-52cd-08de39926f83
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF000001B2.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB10323

GICv5 is able to directly inject PPI pending state into a guest using
a mechanism called DVI whereby the pending bit for a paticular PPI is
driven directly by the physically-connected hardware. This mechanism
itself doesn't allow for any ID translation, so the host interrupt is
directly mapped into a guest with the same interrupt ID.

When mapping a virtual interrupt to a physical interrupt via
kvm_vgic_map_irq for a GICv5 guest, check if the interrupt itself is a
PPI or not. If it is, and the host's interrupt ID matches that used
for the guest DVI is enabled, and the interrupt itself is marked as
directly_injected.

When the interrupt is unmapped again, this process is reversed, and
DVI is disabled for the interrupt again.

Note: the expectation is that a directly injected PPI is disabled on
the host while the guest state is loaded. The reason is that although
DVI is enabled to drive the guest's pending state directly, the host
pending state also remains driven. In order to avoid the same PPI
firing on both the host and the guest, the host's interrupt must be
disabled (masked). This is left up to the code that owns the device
generating the PPI as this needs to be handled on a per-VM basis. One
VM might use DVI, while another might not, in which case the physical
PPI should be enabled for the latter.

Co-authored-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-v5.c | 22 ++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic.c    | 16 ++++++++++++++++
 arch/arm64/kvm/vgic/vgic.h    |  1 +
 include/kvm/arm_vgic.h        |  1 +
 4 files changed, 40 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 2fb2db23ed39a..22558080711eb 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -54,6 +54,28 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 	return 0;
 }
=20
+/*
+ * Sets/clears the corresponding bit in the ICH_PPI_DVIR register.
+ */
+int vgic_v5_set_ppi_dvi(struct kvm_vcpu *vcpu, u32 irq, bool dvi)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+	u32 ppi =3D FIELD_GET(GICV5_HWIRQ_ID, irq);
+
+	if (ppi >=3D 128)
+		return -EINVAL;
+
+	if (dvi) {
+		/* Set the bit */
+		cpu_if->vgic_ppi_dvir[ppi / 64] |=3D 1UL << (ppi % 64);
+	} else {
+		/* Clear the bit */
+		cpu_if->vgic_ppi_dvir[ppi / 64] &=3D ~(1UL << (ppi % 64));
+	}
+
+	return 0;
+}
+
 void vgic_v5_load(struct kvm_vcpu *vcpu)
 {
 	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 1005ff5f36235..1fe3dcc997860 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -577,12 +577,28 @@ static int kvm_vgic_map_irq(struct kvm_vcpu *vcpu, st=
ruct vgic_irq *irq,
 	irq->host_irq =3D host_irq;
 	irq->hwintid =3D data->hwirq;
 	irq->ops =3D ops;
+
+	if (vgic_is_v5(vcpu->kvm)) {
+		/* Nothing for us to do */
+		if (!irq_is_ppi_v5(irq->intid))
+			return 0;
+
+		if (FIELD_GET(GICV5_HWIRQ_ID, irq->intid) =3D=3D irq->hwintid) {
+			if (!vgic_v5_set_ppi_dvi(vcpu, irq->hwintid, true))
+				irq->directly_injected =3D true;
+		}
+	}
+
 	return 0;
 }
=20
 /* @irq->irq_lock must be held */
 static inline void kvm_vgic_unmap_irq(struct vgic_irq *irq)
 {
+	if (irq->directly_injected && vgic_is_v5(irq->target_vcpu->kvm))
+		WARN_ON(vgic_v5_set_ppi_dvi(irq->target_vcpu, irq->hwintid, false));
+
+	irq->directly_injected =3D false;
 	irq->hw =3D false;
 	irq->hwintid =3D 0;
 	irq->ops =3D NULL;
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 6e1f386dffade..b6e3f5e3aba18 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -363,6 +363,7 @@ void vgic_debug_init(struct kvm *kvm);
 void vgic_debug_destroy(struct kvm *kvm);
=20
 int vgic_v5_probe(const struct gic_kvm_info *info);
+int vgic_v5_set_ppi_dvi(struct kvm_vcpu *vcpu, u32 irq, bool dvi);
 void vgic_v5_load(struct kvm_vcpu *vcpu);
 void vgic_v5_put(struct kvm_vcpu *vcpu);
 void vgic_v5_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 45d83f45b065d..ce9e149b85a58 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -163,6 +163,7 @@ struct vgic_irq {
 	bool enabled:1;
 	bool active:1;
 	bool hw:1;			/* Tied to HW IRQ */
+	bool directly_injected:1;	/* A directly injected HW IRQ */
 	bool on_lr:1;			/* Present in a CPU LR */
 	refcount_t refcount;		/* Used for LPIs */
 	u32 hwintid;			/* HW INTID number */
--=20
2.34.1

