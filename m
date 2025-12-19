Return-Path: <kvm+bounces-66373-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C2F05CD0CD7
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 17:17:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3470C313D5AD
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 16:06:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3189D364EBB;
	Fri, 19 Dec 2025 15:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="qCMh/5KS";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="qCMh/5KS"
X-Original-To: kvm@vger.kernel.org
Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013011.outbound.protection.outlook.com [40.107.159.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F009E36214B
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 15:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.11
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766159645; cv=fail; b=iPOE+PuYxR2d9eBtFWGKD9uhCwYEJoMz9KWdDPah5Ei+2kIdVpjdrSiY+B5SJH9DM5R6zfIJHdFL4kRZHzpr4blVPk54+DWv5cgUzssY840BGmLJyr00jxeXyUVktlaONtn89dpMFYcjHBeZiBKOJt17hF0nE9Y/81nosUsuo/U=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766159645; c=relaxed/simple;
	bh=69YKrdYpGSrH//isuF2PGDhh2ZSpL5K6vWSBzAoIMTc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=DuLnLKPEiny47JZ1mE5bx1sudw8IGYvCxTc14HW/v6lFEbWg3EbtxQGl0wN8qrGNX5MlBUgjEbqYA6Afr3ADl31BJ/siNi3EZ7QxY9ZjtPIZUl0s5UmMWMnLjnPXhnEmn93ZFa7uQZ5zcQ8UNiA+6G8UW4RYioaCgPlvidNGTWU=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=qCMh/5KS; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=qCMh/5KS; arc=fail smtp.client-ip=40.107.159.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=f34YWHqeBe2XHZ258Uoa+Ci9xBim2RAqlOgzxWC0KEiq3iIcSs04+1oTa3jpBy46aANlb68LmdVOZjdRUrkdouuwMyZ5FPtQNoyTOkkDeMPtWJOxxkb74XiV8NsegmjsUiHUrc/ExjTDTrXseBmWXlx41R/0n8EYGUmOQposYNjweK6DsX4+if/y5w1n5fip7TOpsP0baxhrml4p/I9qL9A9U8va2isTorTVaek/rSGQtg7qqgSBlxAGBZyqZIPly0fWUKCaHeENJkWT32su3Q+mlXgM62To/JQpbI1rRKA0lAqjckxqNCIUUI7trHhFU18kgKwyNbEeThEEcSd2iw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FP7gJ+Ab+Hy4TrEvb/5yPBc5T8W2SY1375bXlQTPWTI=;
 b=uL/RtlmI8j6bNozZtYgepWoiT+r0dZB1TpV8fn30jX/cQp9DUw1ZblkZ7kuzla1PNS7Ne0NYLXd1bAHd/h/qHvZUZpW4XKfjao9TDfyQWvhxiSAhl5m84VAiMVJgic9/8LmKiLgWJwK5pfDPrfpXC7fQ3ZK1KF/qaEjr+fDi/UfxvacUAE0h4hvuBgwXKL5qpF/2a4G6enjagnk/7vMXCQPtcyGz5v7YntSY1rdBppOTFa/aRKcf/L2tgRcL/HbitzacmMyr3i23vd1t7H01PBEO1bc7/JNa311YRiyWy4IPCEChAxivCWs1pRvOT99eqWJ0Hn1KNDl0KsHyyzPD2w==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FP7gJ+Ab+Hy4TrEvb/5yPBc5T8W2SY1375bXlQTPWTI=;
 b=qCMh/5KS9npAbTnDIqOSfnirfC8HV1e24HESmK77QevjNE3lp+zua4/Yi5JxodGYQ9YHjqxoPLMzXqp06VSw9q0J0TgJPleQ1poQwCkudHau0QjMPxq2GPUhX+wH7nIxqvziK6DiDBBGKbpLPRGtgCYftPwNkDEzZ4LCA/eiNFM=
Received: from CWLP123CA0251.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:19e::15)
 by DBAPR08MB5590.eurprd08.prod.outlook.com (2603:10a6:10:1aa::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.9; Fri, 19 Dec
 2025 15:53:52 +0000
Received: from AM2PEPF0001C70E.eurprd05.prod.outlook.com
 (2603:10a6:400:19e:cafe::8a) by CWLP123CA0251.outlook.office365.com
 (2603:10a6:400:19e::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.8 via Frontend Transport; Fri,
 19 Dec 2025 15:53:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM2PEPF0001C70E.mail.protection.outlook.com (10.167.16.202) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.6
 via Frontend Transport; Fri, 19 Dec 2025 15:53:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eJCtRsunQ6NeJ3bcHP6r8T2AdVRmicM8Ft8jeTxbXnbck6pfS90++yffQcDeyK4pqZKPEZJWID7Bd9ZZ0wln0/TBUG1TsvM9/EvdW8SYtm8J8jnZVFSzAJl9sPVNt0oyVMsmLfat1kIi3WfOTRFQ16Gg3Ds1Cg7F0uLe0liyMQtVmAYM607meJVpK5xf5lI0BEnQmsdwWWcycorNN6XpxHK7k6gzEvOLWFv+tWbIVHWRIlPe73DHqzj96xjZ1KUASPgMFVepIocwjDUgtcIi0h8fOyPXcVJc8Ah2YpHrcJx5gImvP4uBwFfoCArKW4fCA5AIyd8sU3nc9+xU28Mnbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FP7gJ+Ab+Hy4TrEvb/5yPBc5T8W2SY1375bXlQTPWTI=;
 b=JrKpRxTb6GVLuTAujJlzwABjzPkXkGV9ZiKCZ4o2CiKdZBu4YUxqDjV4GM5TtYgBlAl5YBghcTxSIY5+1uAHzoTuKrxUYesKKC4q9mID9Czr/dTqEhfUPRuGCeKDlgyAxgFy5sF30OKGiHNhMPimQa2tjn20MGWgW7So5Ar1T6xJukZolbkT9a1X5fVxfhqaKhtBafAyQsyAtIcew7PXpubJY42qmh+0T/7x3IZeezpLqSVmAhy+rsC21nb7pRcMxae1jcGimgS31LAdPGappIm/EuDqRzV5YDSfgoDNfVS+EuBWtE/b0UD8eTKaxiF+SoRJG2+BdiNuRxd478J0nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FP7gJ+Ab+Hy4TrEvb/5yPBc5T8W2SY1375bXlQTPWTI=;
 b=qCMh/5KS9npAbTnDIqOSfnirfC8HV1e24HESmK77QevjNE3lp+zua4/Yi5JxodGYQ9YHjqxoPLMzXqp06VSw9q0J0TgJPleQ1poQwCkudHau0QjMPxq2GPUhX+wH7nIxqvziK6DiDBBGKbpLPRGtgCYftPwNkDEzZ4LCA/eiNFM=
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com (2603:10a6:803:b7::17)
 by PAVPR08MB9403.eurprd08.prod.outlook.com (2603:10a6:102:300::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.9; Fri, 19 Dec
 2025 15:52:44 +0000
Received: from VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704]) by VI1PR08MB3871.eurprd08.prod.outlook.com
 ([fe80::98c3:33df:8fd4:b704%4]) with mapi id 15.20.9434.001; Fri, 19 Dec 2025
 15:52:44 +0000
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
Subject: [PATCH v2 21/36] KVM: arm64: gic-v5: Finalize GICv5 PPIs and generate
 mask
Thread-Topic: [PATCH v2 21/36] KVM: arm64: gic-v5: Finalize GICv5 PPIs and
 generate mask
Thread-Index: AQHccP+DOirGMbr2k0aWwKAdr6jb4A==
Date: Fri, 19 Dec 2025 15:52:43 +0000
Message-ID: <20251219155222.1383109-22-sascha.bischoff@arm.com>
References: <20251219155222.1383109-1-sascha.bischoff@arm.com>
In-Reply-To: <20251219155222.1383109-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	VI1PR08MB3871:EE_|PAVPR08MB9403:EE_|AM2PEPF0001C70E:EE_|DBAPR08MB5590:EE_
X-MS-Office365-Filtering-Correlation-Id: d13b1ef5-28a3-49a5-f009-08de3f16cdbf
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?vuMTfvrF0WJyjSPOX6/4CZ6oPpFWzfFUeoCYwjhusI0j5dNlGRED2jg6PR?=
 =?iso-8859-1?Q?2aDuGDMX0YVfGwjB3LRlPl3DKIEdPhhFDgsbkVLCZpIRmLTFdBds3oVUfh?=
 =?iso-8859-1?Q?mBTF92osAxx57Q1d+ivRs4BEbFPDcOrGHyWZiulGZ+2Te5KZQIgXVMqNs0?=
 =?iso-8859-1?Q?//T9uAnTNEqR2Um9SvXxoSNB7hIghoUJdmpPheC+XGTk363rUt1RbQlV6z?=
 =?iso-8859-1?Q?xJVwHs/dq7XVd2EXsogAshUbw8ZMqQAO/UiRZbHIQfPcu7Idp5da7Dw5oM?=
 =?iso-8859-1?Q?hjk2PjXMpKB/ideP2ZV3BWLwSLh5xwWiPHc7fPgAH+rp0MkrLMRjt/GGup?=
 =?iso-8859-1?Q?B7mIItF+SrwWaQsulUGHNHRFUPbXaRApruHO+Lj/YsNDhEX+PmsT7Kh/rC?=
 =?iso-8859-1?Q?psLaHmf71qHP5i5fbIVsrTEz/9OC6o/9JlrjQOKTFT7uaS+pU2f2T5uuUS?=
 =?iso-8859-1?Q?yC/ygMC3gQxsQpJr5xRZ+RR9/rkCvSWLqs86DtQTa9hsZh0ny9NtNVUfuD?=
 =?iso-8859-1?Q?Ep9jbQx+pb3XTIQxh8ue3GuPZDE3E9TYpOmMuNh4dN54+RE6Vx3aJQDdw6?=
 =?iso-8859-1?Q?2De8SNxpNG20QxGsjXh4shGa8V/22ltvryM4srUct7U3vp3fJElfNCYAHW?=
 =?iso-8859-1?Q?Ppup02yt1A5zZKyi7DCoVi+zjRLkhcFj0uLqomaWjZ4pQPxzClH1Pb78Kp?=
 =?iso-8859-1?Q?BK1ioXBRil43WR7YCwCFl2h+pMEiLISBIdyRi9RHC/8rX4y7rvuRbQsOFY?=
 =?iso-8859-1?Q?9m/FcVM8KINNbmYH7qrwss/OK4Clu7i59Z9YQgW3RcdKKrZNKqZvjwUwEG?=
 =?iso-8859-1?Q?SgBAf3X9hBmwyY8rEaXSHRtk9Nle09kMKncS91/8T6qVeIkevQ8w4FDxH4?=
 =?iso-8859-1?Q?lphXFXQY82XViSeKodPV3/+zqtSrSWZwEUK3IeKc93PHKVdFDZwqwVbg1x?=
 =?iso-8859-1?Q?yFeQ9hl4z/TujaZH6A5Flh4DPinTudNyxNSQdqGBu72DuPQLjUKiT3pmmw?=
 =?iso-8859-1?Q?fgyAH7Xk9wGZkueFMey7yekW4ONZmMB17ki7G7PChKe3ndFxKWw93sIHw/?=
 =?iso-8859-1?Q?GGROd85Y7UpOiTmU6vu8RRk48OBC2m6sI5pWDdAo1cJl+lcRw1srADyCbg?=
 =?iso-8859-1?Q?y8OSbhyLdWUAJIUR9ClJu9lnitlB/ELPu0fttESajCRUgR3wbhwGqAM1N8?=
 =?iso-8859-1?Q?lsKFEXTN2AQE+1sFxw8YFqpg1K182EsBb7XCPRb8Z0ZvtmcKAr38JKUrkd?=
 =?iso-8859-1?Q?5IRDUyLatpZPHehDLv+m+QvKRUBnGStLqKYtY3uY+0BUeX3bqtYhIZ7x9v?=
 =?iso-8859-1?Q?EyulhuApqP5u3oWpHlPZYZ/Z74brpZZp4xlqfTnHHZO2Ed9EYQDOnqZPHP?=
 =?iso-8859-1?Q?MGzUdJu+0cDUST3eLndbgJr2Tn1ENbeFRYSO1iWacyftMLMGB1IbTRWsrz?=
 =?iso-8859-1?Q?/iBp+y50V1xzlUQXHEpbl7gNkvrqVf8ga1lq9hkiE5tUdQnrMV/kzMWBhg?=
 =?iso-8859-1?Q?sR0Y/lzbejHQctRcNvYpbCF27NbUFmLMLoJWBmQD7vKp6PDrTHDXyUHiky?=
 =?iso-8859-1?Q?xCpRp6kQ5P7uQ9+H6D+hfvJBPkr0?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3871.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAVPR08MB9403
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM2PEPF0001C70E.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	380fddb8-662c-4ebc-548b-08de3f16a657
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|36860700013|14060799003|35042699022|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?R7Vwk8AcSmYy0UlI8KjYUSfjHpzdyTwgJwZ57VLqz79zDi6h7zgYFr+opm?=
 =?iso-8859-1?Q?dVoz7P92KW33P7bxrbtor8Ff3QAwRVpS2t46razbRyglvtr+9yQRaoWKkz?=
 =?iso-8859-1?Q?qOhPzvrZULHrxy04IpLFY/gnM5fXlbMvV/AHVBT+669p2TLfaJIFrCY0PC?=
 =?iso-8859-1?Q?EPo6Lb2ZnAMG8Ga2wfoyDd6gnuEw24X9yVl5jabAoDJd5aXzwRmZCrw+4h?=
 =?iso-8859-1?Q?EF0Zt11VTDXZ1m5DCbXPTWm07VF+PRbbNmd/hnMDgZLtZxCw8kq5AyeAhr?=
 =?iso-8859-1?Q?zKLmU0ZLMdg8DCeo9r6qh9gur2LSXKj5AUxXOrlahl+FX+/7LPfgHQjETI?=
 =?iso-8859-1?Q?d0/21tJB0DdjRmvjkRqiPvcbtMZuznbAghaTdyHF8u64w6K55GLncqZRlB?=
 =?iso-8859-1?Q?vQNGG1rseOV58HDUKPb4Bj8iutBbQ0MjLqDQ15kDUm4ywHjcMGK4H51VJ8?=
 =?iso-8859-1?Q?srChVf13vbIyqJEcDGOjB6nL97v3GkXRQycAso5o3MmoPAuBIFU61d9XBI?=
 =?iso-8859-1?Q?69+JyxTOQi+QamoE55g5a72I2pwZRFrbXn/wFY9UfkcgEnoEtES4WGDzuZ?=
 =?iso-8859-1?Q?M6edMVuImtEpCPLpVtexANWTACSR0B67fZNuKg6Ull9un7WMvTQBXGpJER?=
 =?iso-8859-1?Q?h9ItMRUcKCSJyd6LZqUEVqDgdAyfAWMJeMOoQ5qa52LxRXsfeM4FMUQ3wn?=
 =?iso-8859-1?Q?qQ2Dc1ePFtAhDFT8K5vs0sH+C0PK3HjOORSVd01JVKQP5jTeqgU4JmMg7z?=
 =?iso-8859-1?Q?UnCisdubrXUki60QUxcp4FXbEfXDh6A5Fmrodd7FkJxv14do8zv4K8nLJB?=
 =?iso-8859-1?Q?3okcTUW7ceFvKLXSu/5i9SE+w7sbdDOVMNGcbBO6hkUOWqmw3dI66bPCWC?=
 =?iso-8859-1?Q?DVYo2KTBqi6G96qtsfU1+IPXmggIchBA5DYYrMyYH175iI8KHh+wD2n8D2?=
 =?iso-8859-1?Q?0fl8gOn+Bnu4jcgu+3nho3RuhQFrm9IziCrrwGarkxJ3rJl3E0TjT8mUAf?=
 =?iso-8859-1?Q?WeP3XAomLy/hYA/mvfD16c4IZkBIegwumWXEtpeSGhWKwRKnAaBOV1dv1e?=
 =?iso-8859-1?Q?31yPGlVssDbGSF6pdrxK8IazJeGZOIpJOvHBoJrtnCiYw7jMSMVo1x4VPT?=
 =?iso-8859-1?Q?dioqibgB6COQ86p8pRa15iuDSWq18kXvNqs79JOJR08/axIMvCp3inOrou?=
 =?iso-8859-1?Q?zt3nMZ+xaiHUVe2/OHgPfAF/C+DVkj55R0F66jEAhGIrDpSQ9k2UIEZMuS?=
 =?iso-8859-1?Q?iQWHNU4zp/HxGxNniYYAPkNftBhNHzsDUPOEpzcJwSJg9dr+AOPF6eO0/F?=
 =?iso-8859-1?Q?jTcPT2CsQhe30ZkRejxn9OZPw565Mr8LWYeRxIOJwwhHrn0Y2fRvZUxm54?=
 =?iso-8859-1?Q?f3eJkXgmei/ZT2lijiEDbM97f6UE+sqCEGRvg2kN5XQokQGY4aVa1qGUVw?=
 =?iso-8859-1?Q?VET6rQo/9SyTsaIU+ygj1nImGGwgs046uFsJVz4w0WDhWnde+Fb0iG+/sZ?=
 =?iso-8859-1?Q?Y7AEAIh7aNXAT9yGQ6efwj9U++rE33XEWsFRQQLjZhD3NfW/90klj2jELA?=
 =?iso-8859-1?Q?sH/GrOTFQhSC9o8gwaSpZ/b3i//L1PDc9VdHBQgqfArw5iYcU81XMkvK9T?=
 =?iso-8859-1?Q?liy3dImZP8xzc=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(36860700013)(14060799003)(35042699022)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2025 15:53:50.5985
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d13b1ef5-28a3-49a5-f009-08de3f16cdbf
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM2PEPF0001C70E.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR08MB5590

We only want to expose a subset of the PPIs to a guest. If a PPI does
not have an owner, it is not being actively driven by a device. The
SW_PPI is a special case, as it is likely for userspace to wish to
inject that.

Therefore, just prior to running the guest for the first time, we need
to finalize the PPIs. A mask is generated which, when combined with
trapping a guest's PPI accesses, allows for the guest's view of the
PPI to be filtered.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/arm.c          |  4 +++
 arch/arm64/kvm/vgic/vgic-v5.c | 60 +++++++++++++++++++++++++++++++++++
 include/kvm/arm_vgic.h        |  9 ++++++
 3 files changed, 73 insertions(+)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index b7cf9d86aabb7..94f8d13ab3b58 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -888,6 +888,10 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu=
)
 			return ret;
 	}
=20
+	ret =3D vgic_v5_finalize_ppi_state(kvm);
+	if (ret)
+		return ret;
+
 	if (is_protected_kvm_enabled()) {
 		ret =3D pkvm_create_hyp_vm(kvm);
 		if (ret)
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index c7ecc4f40b1e5..f1fa63e67c1f6 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -81,6 +81,66 @@ static u32 vgic_v5_get_effective_priority_mask(struct kv=
m_vcpu *vcpu)
 	return priority_mask;
 }
=20
+static int vgic_v5_finalize_state(struct kvm_vcpu *vcpu)
+{
+	if (!ppi_caps)
+		return -ENXIO;
+
+	vcpu->arch.vgic_cpu.vgic_v5.vgic_ppi_mask[0] =3D 0;
+	vcpu->arch.vgic_cpu.vgic_v5.vgic_ppi_mask[1] =3D 0;
+	vcpu->arch.vgic_cpu.vgic_v5.vgic_ppi_hmr[0] =3D 0;
+	vcpu->arch.vgic_cpu.vgic_v5.vgic_ppi_hmr[1] =3D 0;
+	for (int i =3D 0; i < VGIC_V5_NR_PRIVATE_IRQS; ++i) {
+		int reg =3D i / 64;
+		u64 bit =3D BIT_ULL(i % 64);
+		struct vgic_irq *irq =3D &vcpu->arch.vgic_cpu.private_irqs[i];
+
+		raw_spin_lock(&irq->irq_lock);
+
+		/*
+		 * We only expose PPIs with an owner or thw SW_PPI to
+		 * the guest.
+		 */
+		if (!irq->owner && irq->intid =3D=3D GICV5_SW_PPI)
+			goto unlock;
+
+		/*
+		 * If the PPI isn't implemented, we can't pass it
+		 * through to a guest anyhow.
+		 */
+		if (!(ppi_caps->impl_ppi_mask[reg] & bit))
+			goto unlock;
+
+		vcpu->arch.vgic_cpu.vgic_v5.vgic_ppi_mask[reg] |=3D bit;
+
+		if (irq->config =3D=3D VGIC_CONFIG_LEVEL)
+			vcpu->arch.vgic_cpu.vgic_v5.vgic_ppi_hmr[reg] |=3D bit;
+
+unlock:
+		raw_spin_unlock(&irq->irq_lock);
+	}
+
+	return 0;
+}
+
+int vgic_v5_finalize_ppi_state(struct kvm *kvm)
+{
+	struct kvm_vcpu *vcpu;
+	unsigned long c;
+	int ret;
+
+	if (!vgic_is_v5(kvm))
+		return 0;
+
+	kvm_for_each_vcpu(c, vcpu, kvm) {
+		ret =3D vgic_v5_finalize_state(vcpu);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
 static bool vgic_v5_ppi_set_pending_state(struct kvm_vcpu *vcpu,
 					  struct vgic_irq *irq)
 {
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index b5180edbd1165..dc7bac0226b3c 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -455,6 +455,13 @@ struct vgic_v5_cpu_if {
 	u64	vgic_ich_ppi_enabler_exit[2];
 	u64	vgic_ppi_pendr_exit[2];
=20
+	/*
+	 * We only expose a subset of PPIs to the guest. This subset
+	 * is a combination of the PPIs that are actually implemented
+	 * and what we actually choose to expose.
+	 */
+	u64	vgic_ppi_mask[2];
+
 	/*
 	 * The ICSR is re-used across host and guest, and hence it needs to be
 	 * saved/restored. Only one copy is required as the host should block
@@ -592,6 +599,8 @@ int vgic_v4_load(struct kvm_vcpu *vcpu);
 void vgic_v4_commit(struct kvm_vcpu *vcpu);
 int vgic_v4_put(struct kvm_vcpu *vcpu);
=20
+int vgic_v5_finalize_ppi_state(struct kvm *kvm);
+
 bool vgic_state_is_nested(struct kvm_vcpu *vcpu);
=20
 /* CPU HP callbacks */
--=20
2.34.1

