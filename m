Return-Path: <kvm+bounces-67603-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 615CED0B8B4
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 18:13:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 13C47312D589
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 17:06:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3734368287;
	Fri,  9 Jan 2026 17:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="VqO4fY9b";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="VqO4fY9b"
X-Original-To: kvm@vger.kernel.org
Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012019.outbound.protection.outlook.com [52.101.66.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C015536656F
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 17:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.19
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767978358; cv=fail; b=ACuMRIPPlp8kIEy/yzgWDPJ9nH4X4qU5TXibqPgobut5ywyHi96LZIX5WPaAWtcCY+oF6D9biuiyc8HfpE0tHbbhXBSdPumXoj+cRkSHuxC2jFQew6hhxPQYiMpAs0+BNBbBk4YRO9IuAaM5wGNKPP222PW0sPcd6Ff/TA4NK90=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767978358; c=relaxed/simple;
	bh=BGZUW6y2cFwCM+nqbl+mDg30RY2gmQmn7e/MX8GU56w=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bCrjqJ83G2YObY0k8y5dqys3Uq2NO713yXSkr3RbHwYCXFzBLB618GtmVafzI8Jon0ZNaCJakdxXppSLnUlahFl44ziEc8OqsXt4ydr6GXMHpNd4xZj4WwaV10SjuZvC+uZR57HEZZ90ST1v1lqUzogzCS+pTnOG94zw4ONMFn4=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=VqO4fY9b; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=VqO4fY9b; arc=fail smtp.client-ip=52.101.66.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=JeDFRAinHBrj6OZ32t2+F2TIJb2yuoJv75kk4Sbp9ZEMXGFzfx0pKoaYbn/SDWWWRXvfHDcxeyZWFPXZ/Q8mooEfRnAlYIiidQIuiV2ksOKPxVHtlgAIVsA5WECPv6H4oO67wWTyqeC/H3QO2J3bUpvhlF8zE+lKivU/efppGX1D6+7q4fUsNx/iikOqYv+RlaW/4A7R7mWRj/6QAzWBB0fkyMShyK6eOIHbh+JHLF/jht1Sa8AYXT5FRbtxkSQ2zsj23dXEXOEqFOdum5YN3xAD7n1IGnz1haMdQ5Suur3fKj3BALTWUyD01xlioJeXMx7Nyq0MxGEFf2sjBLoqwA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dcNp/1Mlx8hRB7DLeIx0XlE43lF161+C5JNKCkewH2s=;
 b=STKaRIaNz5e+HK08havmlAeghmI3KdkeZ6jWofwlG4PyFIKD5heoG/vDE9wLqvSsVu4Ak/mzCQgzB0SxBUwUPNpvI79+zZZ+tw2IYgkci+hbrDqQRYlhfR0Sw9+H2y621f5ZIsZn45bnFBYRGcKWKJy27+T6oa12mKXubD+HmhKGH1r6osfwLVYDeIIyda9Ty4kIJL7z0FgBr/dhwb8J5mWSvtza7+CLTaVimcsEe2XvKwLftGwYNtpIfdYBmkCGzMwoLi2xHBHj9tfHLKQIUHXBvrFa/ZK1WoLv8mXcG65BVAxDFFzbhL0Ql1Vs/G0hHadqzjMxrDdchViVk/2oJQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dcNp/1Mlx8hRB7DLeIx0XlE43lF161+C5JNKCkewH2s=;
 b=VqO4fY9byo+eTwvUr4ilpPUbPg20lsbqNQi6syqHhAqdF5qRgXgyDqJlu6GqizDmrns1W01LbGqvt6i2ln/oLuDjYbkCGgGp+B9BqrUoJwaK50hJPPgdSA7iEUqNwrboiQS5J4Gw7O+a8JSozlFREeV+FpK/moIQE8jNDE/kJcA=
Received: from DB3PR06CA0033.eurprd06.prod.outlook.com (2603:10a6:8:1::46) by
 AM9PR08MB6674.eurprd08.prod.outlook.com (2603:10a6:20b:302::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9499.2; Fri, 9 Jan 2026 17:05:50 +0000
Received: from DB1PEPF000509FE.eurprd03.prod.outlook.com
 (2603:10a6:8:1:cafe::17) by DB3PR06CA0033.outlook.office365.com
 (2603:10a6:8:1::46) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.4 via Frontend Transport; Fri, 9
 Jan 2026 17:05:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509FE.mail.protection.outlook.com (10.167.242.40) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.1
 via Frontend Transport; Fri, 9 Jan 2026 17:05:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ifS5OmPMjHvKRt8UwR153vf22LFxmj78t+xvaRYM1t553sYPd1nIug8HWZ76GAXNl1J3pR6W0bd+TsW7UUKZfLV1AqrzAX1jd79y+G0haGbUAdtqkzsgVBrF6LszBJlyMvHmFNDHNBxcoFCZ8xkfucO/9FITZ1UncwDB3sbHi1So4kP8/ijYe87+ABsODPXGGN0keX21Mf8atK09olqaFqtpmoTpsbw94g4XBkkbB8NKf73vhascyMg8a+IM515PKMC8ZP2o1zcYDkocjWtDgBsvvkpMW17veSJ/Ql0TCAKtjDHnZwkQHexuAxrK5qQgFcwS+SocUQgEGpf9AgKQWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dcNp/1Mlx8hRB7DLeIx0XlE43lF161+C5JNKCkewH2s=;
 b=LN9ZupjPO1O5OUIuBnI3zE2YpbiH5Lrhpu19yDIP4bpKjZ34Xrh2MkaDScbm+ij8q18VhPPPN2e2OBqWinICqAfOU0eAM9DmnRJO2w615pgCc6d9stc82EBs+lnVCnfeOF+XvSyNvoYlYAdBvucNhNMkMvMTh6WvB7wHFn5//qiDZfd8TygXXtOpsMuwRb8PMiS5+fgoywrCfe7+5BwfyExVaanodqNsVIDaaqai3fXd2iZXVhQCO9eFT64ZUmXLvHI7LpqCFOdZROFb4DtswcVOTWxj6PMwt5yXIujWikRMcDyYmGURefRRkT6fCIg9tC3wGdhb0oee1iw6OXsvOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dcNp/1Mlx8hRB7DLeIx0XlE43lF161+C5JNKCkewH2s=;
 b=VqO4fY9byo+eTwvUr4ilpPUbPg20lsbqNQi6syqHhAqdF5qRgXgyDqJlu6GqizDmrns1W01LbGqvt6i2ln/oLuDjYbkCGgGp+B9BqrUoJwaK50hJPPgdSA7iEUqNwrboiQS5J4Gw7O+a8JSozlFREeV+FpK/moIQE8jNDE/kJcA=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by PA4PR08MB7386.eurprd08.prod.outlook.com (2603:10a6:102:2a1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.5; Fri, 9 Jan
 2026 17:04:47 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9499.003; Fri, 9 Jan 2026
 17:04:47 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>, "jonathan.cameron@huawei.com"
	<jonathan.cameron@huawei.com>
Subject: [PATCH v3 21/36] KVM: arm64: gic-v5: Check for pending PPIs
Thread-Topic: [PATCH v3 21/36] KVM: arm64: gic-v5: Check for pending PPIs
Thread-Index: AQHcgYoOie7eoJMOhUad9bE4khSQDA==
Date: Fri, 9 Jan 2026 17:04:46 +0000
Message-ID: <20260109170400.1585048-22-sascha.bischoff@arm.com>
References: <20260109170400.1585048-1-sascha.bischoff@arm.com>
In-Reply-To: <20260109170400.1585048-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS8PR08MB6744:EE_|PA4PR08MB7386:EE_|DB1PEPF000509FE:EE_|AM9PR08MB6674:EE_
X-MS-Office365-Filtering-Correlation-Id: 697533d0-648d-4e82-db7f-08de4fa15713
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?xvBcaXbASjPLdNErWd6BHfJOtq6NqA6eGJSuVRuq9axE2a4h2+VfrUTTDq?=
 =?iso-8859-1?Q?dewOjPLI7zwSPg955ck63sTnRCbkEf7LoXonLy1SJoGIRkR1Vl+R05lkjq?=
 =?iso-8859-1?Q?+8U/ZxX0ueVHygAvlFeRYiOVF3eDl31Xc6UGVdRNtGD/RljJTE7aXMXUc/?=
 =?iso-8859-1?Q?EbJfhjgoXeBGBro/dgH7I4Dik+XoHXqR6Bc9VSTTPpFPIvvmTiNO4S6T0j?=
 =?iso-8859-1?Q?tWuc3nTY4w0p+N3yQBfeoc2cY4Mxo6X4iv/yFr6bUr0vc1nf0AuXcRg2j9?=
 =?iso-8859-1?Q?4Z547NZNnXmxHz4j2KxRalWIfn0UXhpYcJEzbeWm/KYQfb7ISoRmgd1vya?=
 =?iso-8859-1?Q?6chx3vZkH8urxbvgBC5LwavCCNKHesuaSDdC6QsdyhrwvLXt3NRvYaIf+Z?=
 =?iso-8859-1?Q?CxCZ20P3G5wLLDQNSY+auhDHWnFxqZxWtSxIxxAkm0EzkeSfkM5Gp/5l36?=
 =?iso-8859-1?Q?eeqGwscKPhk/AusVcb3pVUyM3sTbCsHuomSPZVrpEPRoXlbCm9A8B/J7kS?=
 =?iso-8859-1?Q?fddGQzVUSbBBQcj0Y3vBBYQPN6BQxeuOosX8ZmVTHLo58w5M+PXtdel1k+?=
 =?iso-8859-1?Q?lIqNaPvMrgirJdhvXHpe32hg8tjy0mRe1m0YfrO9ciWM9NrQ4xqXOcKD4V?=
 =?iso-8859-1?Q?qmz4oa8DirQ1ba+FvtJiz7w3GRpcWg/j6Ql4PKApuY+cLE9SuDYZO3qkSf?=
 =?iso-8859-1?Q?liu6E8ySVJFz8COCRzC2GmwHtQI83m7f2teP4Zzr0UAbVi+fviSBqJ78rr?=
 =?iso-8859-1?Q?cEBqpKvrqOUwtNBLuYlQOoOAapY4pxGdq+gWbGlB0Y23SuLBNpkU/v2Gkt?=
 =?iso-8859-1?Q?Hzy/7h+5XSX55UkIC+3Tv3xmWVU4jo7VacScLvZ7na/qgIRy1F+qFgBzsC?=
 =?iso-8859-1?Q?tQ0ugIW16dF07u6EElJsK8b85s6LeDhFKSDRfsXiW6p+trh1nnI6X5G2Ld?=
 =?iso-8859-1?Q?6u4O/eCRgh5spDdhWW/nl6JsyKbdowTammLx6OSs92Yu5vJu6K/iijUFqd?=
 =?iso-8859-1?Q?oDOvNKfOTEHV+Nu6fOy+RvelAwbpIq2+ReEs8IMOR9v6AU7/ij0K+3/xtm?=
 =?iso-8859-1?Q?iIYvltQmcAceNxwbR3Bu3Zee7vgnSYySFslM641WODi3ASR52m2YeoNcCE?=
 =?iso-8859-1?Q?9l1epx77wxoen9TJYvc65bk4r62M8zHmfNw4/5OUV5k6fVCTeb+TfkHcT7?=
 =?iso-8859-1?Q?pXdI3nyRrPwSU6Wv5mVyFmPtSCux6QP2DsRlCcSnzHFUoZp9zyni1t85uG?=
 =?iso-8859-1?Q?USdefln52+gcqvA7WLtGOOLtBo1lziutUpjItbNY9TbWwd7DH9Sd+q1dTp?=
 =?iso-8859-1?Q?OTxoAjsJHQKwtLOkbU7an0bL7Y4OC8JVXxR6PdbNiwq8xUzlN/2P+YldvC?=
 =?iso-8859-1?Q?k/HQWGzGyJE2CKYHlSec/D3WA3qmHp72jdwjV60xSj/DJXqozZRbEDrxEn?=
 =?iso-8859-1?Q?RpPCbOvF8gnkM/5t3zPHKL/BmEN9dPcI4xhoeLfMIFBOzGExJGZRdIPvqF?=
 =?iso-8859-1?Q?QIQWaO3MM5ClF7kPV7BH6A953uJbqOuCYTVJu2A/ndMW/iRFkvFUgD2m58?=
 =?iso-8859-1?Q?xCzr0ZXLP3eYM4x+wwQ1JBZQxWI7?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB6744.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR08MB7386
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509FE.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	fbe3f774-f437-4eeb-cf46-08de4fa1319c
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|376014|82310400026|1800799024|36860700013|35042699022;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?o9JqY0PIU2Xtvj0E4s67ANd3hVYh/c2dk5ORh8GNepkiX0sZpAn4Gbs5QM?=
 =?iso-8859-1?Q?eHTbmM5hkQZtvr6Yd84Yz7/GogJbFvl+si8dN2bBzr99I8/7VbsXt1/DM+?=
 =?iso-8859-1?Q?mQRM5B0jV8Ze6rRfTUNsu4jKjyWiCREIMr/3ZPFon6VCdo7y1w5YejjZMK?=
 =?iso-8859-1?Q?Ng0KvHt0vgm8EUbuoEgukbWn5zUk0TB0MdciPlvn8p25kj6cykVJmck9RX?=
 =?iso-8859-1?Q?6RjPYfdvXKXaV9DasU1bpvZ63WKNvV95iD3Kk1NyVCQQhGXd8Ix19ngs4a?=
 =?iso-8859-1?Q?yKP0Ar9m76Y4cIbk2OhhRyJEmPLnQIlp3fMsjcxqeH0c2XbHxvVwrTw3OS?=
 =?iso-8859-1?Q?UiwWuPTIxwEm1QmqGCk9xAkbR/NKGIAPjCIfzWDOvY1ncsRCSi/g8GH3bh?=
 =?iso-8859-1?Q?I0q6DxUbS1mhf8CFv0DYgUffCUQhObzvv2WhJcaQvaZDlDDrnzefbMy4Qj?=
 =?iso-8859-1?Q?KcD3WYrNTS7OPfqX1yg7OVuja/f8Wv+iVG13DPlE2A83ASGNfFZmvyJpjq?=
 =?iso-8859-1?Q?wnxugrPvyCdzrgXvT8IpdPC2AhrW8XqrWL2AwvZjZQdKk9F+8wgVKcsjTn?=
 =?iso-8859-1?Q?6AN/QPA5d79leolvwYUJyneL1uwuJG8SsekUiDO8PvLmAmFsTWNnW58gCO?=
 =?iso-8859-1?Q?/Hhmko8Yn5Mwc9URGlv3EDGs16+XoZG3omgICTkfLRVkletmg+pbKN4OR+?=
 =?iso-8859-1?Q?YVTgnmm4T2wAU4jYdzmwkoDWtUfkdrcOXPvz87JcqSXVUmFfpMY0A0v/NK?=
 =?iso-8859-1?Q?qBFmR3rQHLfAUtDu8xFk5M1qj+vUe5Ro5AyizFWEiT8/zzasVNk6t8z0sj?=
 =?iso-8859-1?Q?waVhH7KgcYvzvmuijCuym4kYBYDGjjODCWFRHmH8Tr7phQbbYQXDyoaiix?=
 =?iso-8859-1?Q?FiZiVvq8ch/tBUFx8aAT05wNx+wfWmkRJB4SxF12+nrG/ZG9SzFoEYnGr2?=
 =?iso-8859-1?Q?A028Ecu8oVvmsIgy9ANAR0j0FPEc2gexlSS6r1UXsz73ugsyv/0pLKZc5W?=
 =?iso-8859-1?Q?aUvI77Cw3TsLyJ2OXCCOrjpQ/KwyIN9T+krOBsnEBpNSq5TdySZtpBJzk+?=
 =?iso-8859-1?Q?BrAdhqS8twDjdkG1ndPIUtyXVqbeoTXY+iOtjna0fpCkW3IVyYDRBDuzr7?=
 =?iso-8859-1?Q?c+ngYCZClAD7VvbfipvDM5qjIGYuMe8oqtpqJ0WuzyzzExuUTxkLwjrm+l?=
 =?iso-8859-1?Q?fq6RmVPNZYzjWb54ChYWsI7Sk0APgYMYOCY7b1KYGxDchow0AllYUpOzQJ?=
 =?iso-8859-1?Q?6GrDc4R0W7m/eQPcdrNNX4Lv9iMHerCLMKGE8Mb8TYn9twXY3qpk2XEfW4?=
 =?iso-8859-1?Q?36rMQgbaVarbozPSiM6bwmLSseBJY1BsWrfKocmXKFeMIRECg4xmscEgrt?=
 =?iso-8859-1?Q?g0NkTXSbVYyCrzEl0ce8hX7J3E2f7FjTd2tWt0XF4h2Ua/SshuxIwWdpDW?=
 =?iso-8859-1?Q?kAGt8edZ3IfCO2Rz9LcOnuA9Q+hUIEUAuEuJa6o2k5fmIPdRTQaVtpZjZI?=
 =?iso-8859-1?Q?dnXv9+tL+dzY+4tG+oQdDnUI9RdpPdUPB6NLeJHU+dFzPt7HH+/yIMcEOG?=
 =?iso-8859-1?Q?kksQMs7PLfZuKmL4k1A+HE2dWrnoHPwzdHosVSkz2X3RKDIYMFmIOuD53p?=
 =?iso-8859-1?Q?zXYJ62aXiGB0c=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(376014)(82310400026)(1800799024)(36860700013)(35042699022);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2026 17:05:50.1318
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 697533d0-648d-4e82-db7f-08de4fa15713
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509FE.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR08MB6674

This change allows KVM to check for pending PPI interrupts. This has
two main components:

First of all, the effective priority mask is calculated.  This is a
combination of the priority mask in the VPEs ICC_PCR_EL1.PRIORITY and
the currently running priority as determined from the VPE's
ICH_APR_EL1. If an interrupt's priority is greater than or equal to
the effective priority mask, it can be signalled. Otherwise, it
cannot.

Secondly, any Enabled and Pending PPIs must be checked against this
compound priority mask. The reqires the PPI priorities to by synced
back to the KVM shadow state - this is skipped in general operation as
it isn't required and is rather expensive. If any Enabled and Pending
PPIs are of sufficient priority to be signalled, then there are
pending PPIs. Else, there are not.  This ensures that a VPE is not
woken when it cannot actually process the pending interrupts.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Joey Gouly <joey.gouly@arm.com>
---
 arch/arm64/kvm/vgic/vgic-v5.c | 133 ++++++++++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic.c    |   3 +
 arch/arm64/kvm/vgic/vgic.h    |   1 +
 3 files changed, 137 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index c1899add8f5c3..3e2a01e3008c4 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -139,6 +139,29 @@ void vgic_v5_get_implemented_ppis(void)
 		ppi_caps->impl_ppi_mask[0] |=3D BIT_ULL(GICV5_ARCH_PPI_PMUIRQ);
 }
=20
+static u32 vgic_v5_get_effective_priority_mask(struct kvm_vcpu *vcpu)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+	u32 highest_ap, priority_mask;
+
+	/*
+	 * Counting the number of trailing zeros gives the current active
+	 * priority. Explicitly use the 32-bit version here as we have 32
+	 * priorities. 32 then means that there are no active priorities.
+	 */
+	highest_ap =3D cpu_if->vgic_apr ? __builtin_ctz(cpu_if->vgic_apr) : 32;
+
+	/*
+	 * An interrupt is of sufficient priority if it is equal to or
+	 * greater than the priority mask. Add 1 to the priority mask
+	 * (i.e., lower priority) to match the APR logic before taking
+	 * the min. This gives us the lowest priority that is masked.
+	 */
+	priority_mask =3D FIELD_GET(FEAT_GCIE_ICH_VMCR_EL2_VPMR, cpu_if->vgic_vmc=
r);
+
+	return min(highest_ap, priority_mask + 1);
+}
+
 static bool vgic_v5_ppi_set_pending_state(struct kvm_vcpu *vcpu,
 					  struct vgic_irq *irq)
 {
@@ -216,6 +239,112 @@ void vgic_v5_set_ppi_ops(struct vgic_irq *irq)
 		irq->ops =3D &vgic_v5_ppi_irq_ops;
 }
=20
+/*
+ * Sync back the PPI priorities to the vgic_irq shadow state for any inter=
rupts
+ * exposed to the guest (skipping all others).
+ */
+static void vgic_v5_sync_ppi_priorities(struct kvm_vcpu *vcpu)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+	u64 priorityr;
+
+	/*
+	 * We have 16 PPI Priority regs, but only have a few interrupts that the
+	 * guest is allowed to use. Limit our sync of PPI priorities to those
+	 * actually exposed to the guest by first iterating over the mask of
+	 * exposed PPIs.
+	 */
+	for (int mask_reg =3D 0; mask_reg < 2; mask_reg++) {
+		unsigned long *p;
+		int i;
+
+		p =3D (unsigned long *)&vcpu->kvm->arch.vgic.gicv5_vm.vgic_ppi_mask[mask=
_reg];
+
+		for_each_set_bit(i, p, 64) {
+			struct vgic_irq *irq;
+			int pri_idx, pri_reg;
+			u32 intid;
+			u8 priority;
+
+			pri_reg =3D (mask_reg * 64 + i) / 8;
+			pri_idx =3D (mask_reg * 64 + i) % 8;
+
+			priorityr =3D cpu_if->vgic_ppi_priorityr[pri_reg];
+			priority =3D (priorityr >> (pri_idx * 8)) & GENMASK(4, 0);
+
+			intid =3D FIELD_PREP(GICV5_HWIRQ_TYPE, GICV5_HWIRQ_TYPE_PPI);
+			intid |=3D FIELD_PREP(GICV5_HWIRQ_ID, mask_reg * 64 + i);
+
+			irq =3D vgic_get_vcpu_irq(vcpu, intid);
+
+			scoped_guard(raw_spinlock_irqsave, &irq->irq_lock)
+				irq->priority =3D priority;
+
+			vgic_put_irq(vcpu->kvm, irq);
+		}
+	}
+}
+
+bool vgic_v5_has_pending_ppi(struct kvm_vcpu *vcpu)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+	unsigned int priority_mask;
+
+	/* If no pending bits are set, exit early */
+	if (!cpu_if->vgic_ppi_pendr[0] && !cpu_if->vgic_ppi_pendr[1])
+		return false;
+
+	priority_mask =3D vgic_v5_get_effective_priority_mask(vcpu);
+
+	/* If the combined priority mask is 0, nothing can be signalled! */
+	if (!priority_mask)
+		return false;
+
+	for (int reg =3D 0; reg < 2; reg++) {
+		const u64 enabler =3D cpu_if->vgic_ppi_enabler[reg];
+		const u64 pendr =3D cpu_if->vgic_ppi_pendr[reg];
+		unsigned long possible_bits;
+		int i;
+
+		/* Check all interrupts that are enabled and pending */
+		possible_bits =3D enabler & pendr;
+
+		/*
+		 * Optimisation: pending and enabled with no active priorities
+		 */
+		if (possible_bits && priority_mask =3D=3D 32)
+			return true;
+
+		for_each_set_bit(i, &possible_bits, 64) {
+			bool has_pending =3D false;
+			struct vgic_irq *irq;
+			u32 intid;
+
+			intid =3D FIELD_PREP(GICV5_HWIRQ_TYPE, GICV5_HWIRQ_TYPE_PPI);
+			intid |=3D FIELD_PREP(GICV5_HWIRQ_ID, reg * 64 + i);
+
+			irq =3D vgic_get_vcpu_irq(vcpu, intid);
+
+			scoped_guard(raw_spinlock_irqsave, &irq->irq_lock) {
+				/*
+				 * We know that the interrupt is
+				 * enabled and pending, so only check
+				 * the priority.
+				 */
+				if (irq->priority <=3D priority_mask)
+					has_pending =3D true;
+			}
+
+			vgic_put_irq(vcpu->kvm, irq);
+
+			if (has_pending)
+				return true;
+		}
+	}
+
+	return false;
+}
+
 /*
  * Detect any PPIs state changes, and propagate the state with KVM's
  * shadow structures.
@@ -348,6 +477,10 @@ void vgic_v5_put(struct kvm_vcpu *vcpu)
 	kvm_call_hyp(__vgic_v5_save_apr, cpu_if);
=20
 	WRITE_ONCE(cpu_if->gicv5_vpe.resident, false);
+
+	/* The shadow priority is only updated on entering WFI */
+	if (vcpu_get_flag(vcpu, IN_WFI))
+		vgic_v5_sync_ppi_priorities(vcpu);
 }
=20
 void vgic_v5_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 1cdfa5224ead5..8f2782ad31f74 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -1174,6 +1174,9 @@ int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu)
 	unsigned long flags;
 	struct vgic_vmcr vmcr;
=20
+	if (vgic_is_v5(vcpu->kvm))
+		return vgic_v5_has_pending_ppi(vcpu);
+
 	if (!vcpu->kvm->arch.vgic.enabled)
 		return false;
=20
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index c8f538e65303f..2c067b571d563 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -366,6 +366,7 @@ int vgic_v5_probe(const struct gic_kvm_info *info);
 void vgic_v5_get_implemented_ppis(void);
 void vgic_v5_set_ppi_ops(struct vgic_irq *irq);
 int vgic_v5_set_ppi_dvi(struct kvm_vcpu *vcpu, u32 irq, bool dvi);
+bool vgic_v5_has_pending_ppi(struct kvm_vcpu *vcpu);
 void vgic_v5_flush_ppi_state(struct kvm_vcpu *vcpu);
 void vgic_v5_fold_ppi_state(struct kvm_vcpu *vcpu);
 void vgic_v5_load(struct kvm_vcpu *vcpu);
--=20
2.34.1

