Return-Path: <kvm+bounces-71790-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IB1wB6mLnmltWAQAu9opvQ
	(envelope-from <kvm+bounces-71790-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 06:42:01 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id B02FE192172
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 06:42:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 4377930398C6
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 05:41:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 609CC2DAFCB;
	Wed, 25 Feb 2026 05:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="m2lEc+nf"
X-Original-To: kvm@vger.kernel.org
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011069.outbound.protection.outlook.com [52.101.52.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 773CE2C08A8;
	Wed, 25 Feb 2026 05:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771998110; cv=fail; b=bbj49TvUfCvVYsgQq35OUC+t40WSUZHqVBRhUVLWkz7CVmfTZA5OUuzlY35Na5EvHyXCfM/8Vy6/+k8MPPkdJBa49FO+I1OoCnBmjgFObSnupYCehTIrMiuEAVU5VJhn61Te+r9h22LGgQ84MAeiBbZaZcpxS9eQ7AS7WH2DZJ0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771998110; c=relaxed/simple;
	bh=TGMtxEXuBcoJyvf3qr0ACfILP9lL/W42/WQ5ROWB4fA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Iel4/NOgWWnWwc08HoOl05n2znlO9zL5QaSxI5ZGhQpNTQuUOZvV+FAhtMXuc0YD+2njJ08uKtqdiJtbnj4u7pzUHmvK3Z0thYtOWDGJ+K0mNS4IOYWfF9yWByvLbFT02v6uzoqBqoXI4AVOEJSZ1Zr/lOnKLaK+pdCfEg9yvZE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=m2lEc+nf; arc=fail smtp.client-ip=52.101.52.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=e2asWmlBkbC/ZQstbRgz6KEtqwty89Vxm3LV5A/lEAMloWu7jPIS1q+D6KWCXCxLvofLP1rMk3V35a9BS0b/1EqG7rVmfaDFZUyLad/pAhwJH+OxPtppr/RIfXrBN1dAUQOueauzADK0z0dx4m2wmWvvo1y9XBjbepcvZ7CeVrjSFS8dJgdjYCQljwkCjFz9cLPbnvFCzieuJRgoLS+KHkSj9XFGOPI/GHsUKC9qiiOiBD/vTQNBvyH+n626WPt7M3UTv8T8GS8tBCSv7QmRVCGN9jdVpYsZpfn3X346lCI8o0ygxcWe/ELpSK40JZ29SPvKRDDKR0xz0T+09ZLrVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cQUrkxJcz4VVl5du5WX+kn8K1jOIhqaZDfkPvfE1wak=;
 b=s03mkPz+IoIRZkwqFV5PenMUzIc1FCeIS5GYX7qpQNBJUEP/nlBoinaj+G212cFB0fPlBaRJlkjIgzZnmg/fgHZHSSdws79DR3/qztkAYFo8a6N/6BSmpY9cjXC51LrwIFvUrYUTPIlyFQk0vEkWtEikTcv47hafdPGbRPBYg1kAg+3rxXfF7UJoiYCOJsuUnl3JBun9TUEM0aaL1oA3TMSGC7PsbzGlC3qXt7IurXn7TMflzMbRkW+mKBcAOmVD5QHLYH6Qu6nyatNy64Sk7AVJ84EK3zmPEDuM0u8taJnVjnmRvrQM7IXf2rzl1E/79M8Isyy1BvBrH+ckzmT3mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cQUrkxJcz4VVl5du5WX+kn8K1jOIhqaZDfkPvfE1wak=;
 b=m2lEc+nfPgxlmp095x/x2ebD+HvJKQ4JyE3Tm9KsQX4mkQlpAnM2aQQcAtkTw/UhiM2pKpRvfdqJmCAqDAxGCOwxw5uitC3mZUFQb9DhZugIqbNjJCuA/CcXwl3AKu9ars0HDqPP1HHt4wspScFW07YXK8SncAUwrX5HJy+PEJY=
Received: from MN2PR04CA0023.namprd04.prod.outlook.com (2603:10b6:208:d4::36)
 by IA1PR12MB6307.namprd12.prod.outlook.com (2603:10b6:208:3e5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Wed, 25 Feb
 2026 05:41:44 +0000
Received: from BN3PEPF0000B06A.namprd21.prod.outlook.com
 (2603:10b6:208:d4:cafe::1b) by MN2PR04CA0023.outlook.office365.com
 (2603:10b6:208:d4::36) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.22 via Frontend Transport; Wed,
 25 Feb 2026 05:41:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN3PEPF0000B06A.mail.protection.outlook.com (10.167.243.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9654.0 via Frontend Transport; Wed, 25 Feb 2026 05:41:44 +0000
Received: from aiemdee.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 24 Feb
 2026 23:41:24 -0600
From: Alexey Kardashevskiy <aik@amd.com>
To: <x86@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-pci@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "Ingo
 Molnar" <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, "Sean
 Christopherson" <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
	"Andy Lutomirski" <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
	"Bjorn Helgaas" <bhelgaas@google.com>, Dan Williams
	<dan.j.williams@intel.com>, "Marek Szyprowski" <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>, Andrew Morton
	<akpm@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>,
	Michael Ellerman <mpe@ellerman.id.au>, "Mike Rapoport" <rppt@kernel.org>, Tom
 Lendacky <thomas.lendacky@amd.com>, "Ard Biesheuvel" <ardb@kernel.org>,
	Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>, Ashish Kalra
	<ashish.kalra@amd.com>, Stefano Garzarella <sgarzare@redhat.com>, Melody Wang
	<huibo.wang@amd.com>, Seongman Lee <augustus92@kaist.ac.kr>, Joerg Roedel
	<joerg.roedel@amd.com>, "Nikunj A Dadhania" <nikunj@amd.com>, Michael Roth
	<michael.roth@amd.com>, "Suravee Suthikulpanit"
	<suravee.suthikulpanit@amd.com>, Andi Kleen <ak@linux.intel.com>, Kuppuswamy
 Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>, Tony Luck
	<tony.luck@intel.com>, David Woodhouse <dwmw@amazon.co.uk>, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>, Denis Efremov
	<efremov@linux.com>, Geliang Tang <geliang@kernel.org>, Piotr Gregor
	<piotrgregor@rsyncme.org>, "Michael S. Tsirkin" <mst@redhat.com>, "Alex
 Williamson" <alex@shazbot.org>, Arnd Bergmann <arnd@arndb.de>, Jesse Barnes
	<jbarnes@virtuousgeek.org>, Jacob Pan <jacob.jun.pan@linux.intel.com>,
	Yinghai Lu <yinghai@kernel.org>, Kevin Brodsky <kevin.brodsky@arm.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>, "Aneesh Kumar K.V (Arm)"
	<aneesh.kumar@kernel.org>, Xu Yilun <yilun.xu@linux.intel.com>, Herbert Xu
	<herbert@gondor.apana.org.au>, Kim Phillips <kim.phillips@amd.com>, "Konrad
 Rzeszutek Wilk" <konrad.wilk@oracle.com>, Stefano Stabellini
	<sstabellini@kernel.org>, Claire Chang <tientzu@chromium.org>,
	<linux-coco@lists.linux.dev>, <iommu@lists.linux.dev>, Alexey Kardashevskiy
	<aik@amd.com>
Subject: [PATCH kernel 5/9] x86/mm: Stop forcing decrypted page state for TDISP devices
Date: Wed, 25 Feb 2026 16:37:48 +1100
Message-ID: <20260225053806.3311234-6-aik@amd.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260225053806.3311234-1-aik@amd.com>
References: <20260225053806.3311234-1-aik@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B06A:EE_|IA1PR12MB6307:EE_
X-MS-Office365-Filtering-Correlation-Id: dabd96ad-75a9-4530-65b8-08de74308f2b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|7416014|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?GZllTBu7ZRIGrFYeBz0gzPQBjdh4r+9qQa8jvadovZ966RwiPeJTGiBbfuFe?=
 =?us-ascii?Q?zb9n+6eD1Ndz3phrnkiekHE4m6tfLwnVYLm/XFg6Gat3NMy+v39O5V1bVe8T?=
 =?us-ascii?Q?5xCjFWItfHRmfJsts6hJhGbwjAH/l8mdYAOwatfnl8LxZSKyz96vbBHfDn/u?=
 =?us-ascii?Q?bWrlG77vsGTcYNE81EkaX7zDA9+F2eJIpMUT+pGCcga6vsuaaJLiZ7nosPQ1?=
 =?us-ascii?Q?XvBpvWaTnB/TtXo6v1dJjNQQqIzMYJF4fY5eKHy0KoAPnMtXM8NXC8Ow6+Hf?=
 =?us-ascii?Q?i4SXtXefChJajZhhSRRrDFFylXC6MiSvtFWSVy+QQRqDhb10H0d//6rGzCLZ?=
 =?us-ascii?Q?AQN0IgQ+Xt908YocHg+4QIwvFV/xaz4FENDL3RVbp6toSsVj3sxhHx/rEXwF?=
 =?us-ascii?Q?N7iMs5i/s6n5JTh60obmkJMq5Lcb3mkL9JFHy3whDJSuieCXdA5aK8mRZqKi?=
 =?us-ascii?Q?n7qmfqX9s1ifBRieKJXjzCd4j4w0UNv7IaBxpeMPc/KKtQPAFdo9LrcYK+0J?=
 =?us-ascii?Q?Z7j3BaBbhlRqdMpc7hnA1eUZ2B428GsyNrEsqOoCqtnUwPt0LWjz0UeEDmZN?=
 =?us-ascii?Q?2Ag/pwPOWSRJywtZ/1QwKMCBDLUU6JThPuOR0Eey8IEXROr0sn8Me9wbjCjK?=
 =?us-ascii?Q?uD2ZRp6OZD4nRg/QGlh59/yEO3bblZPu5zblj6EJuAZ1SjeFOcAW0hVEiXMw?=
 =?us-ascii?Q?sVdPTpFMW77RoHZxZAUsp2pVCZUVeHkphbjUrEWiTzUKgc0C48DaNLuaYZlG?=
 =?us-ascii?Q?oLrorATYbCGj4/w3ErS3VfPdRrZ3Vpt7AP5fSLSOMDKiuXjYXnzTnxst50kK?=
 =?us-ascii?Q?U58Uq6DcbUzn5CjuyaG3UT3RIuSO1ZhGgRh6qwNxIsYqGF6thyJHFPR2OoSz?=
 =?us-ascii?Q?CMOc281YGMgNgg5wacE7UaixlZmBLI2AEz8zmhyNzikj4/X9AoYl/5WQTJQw?=
 =?us-ascii?Q?puQf9wH4h7hltCkAH0ns0cpWgZxuJMA67rkLW+uF2Qj0+64hXPooemZBHNue?=
 =?us-ascii?Q?KU+vprj3jy+nLZn/NFxanD3NIE0F3Olcn+79niKnn6DeVX1wqhxQGqajlPRh?=
 =?us-ascii?Q?CG9+iXH72ci9Eph/wIugsWyImK8Aqv1xPdeQ1Pl24WcBdYBDXz0reI469eAG?=
 =?us-ascii?Q?DL9x2cr5R8KQ/2/Zgn2uxO0Iz+prnuR5qf6SEEKUeLsfnpsaaQCioCgyWBDo?=
 =?us-ascii?Q?G+2SHOqYOv60aaESlIbk+bhS8/ogtxVvk7UTiHHeTXvMHvt41p5Dldb9Z6mz?=
 =?us-ascii?Q?jIlMfxo7vArluRLZdOE3RmkbnXDIU4lMH4EXFqdoaYFL0G/zfff3OUwnRwSK?=
 =?us-ascii?Q?GEDOZj1lZ3/aq6zlyhena9huHMkqfArnAQllKEBRGamSk52+7BILExOp26/b?=
 =?us-ascii?Q?CUgiKSepwfTcGbWSSugj/q9HaBLCxrRPHhOF0F7WHc6ut/gcU7ddo//OyHm4?=
 =?us-ascii?Q?OQUppHR2UNrPsZZhr0BjV7Wtfb924NSla04kl5zZ4x/pX28UJwNRFBpGioJF?=
 =?us-ascii?Q?egb7ppMefkKvasbvkROLn/CofAWC3XR0zt/aZhpUIt4UTSym0WrMD70inb3y?=
 =?us-ascii?Q?KQ9zukadhk0qLT41VW5qgEWJdqNKpcT1Dh7j6uDTz42wGnBm8ifrlUtW56xZ?=
 =?us-ascii?Q?/04T4KWdTWy3G4pXHMgXrqPkcgYD065aQR+QN4Q26nAID4n5A14WAzzTyV11?=
 =?us-ascii?Q?xAYdbw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(7416014)(376014)(36860700013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	0PMhx87ocCc6jId0x++BJBSWPW7WVOus0eMh4eYawS/Ra+jPj95lvlPHNF0BSR3EwMGEZELQIULM084q+6ETWhttMJQlyp8CGfJAOQOWaXV+WSEiXLVxQedWELg8jcT4S4nYtBWMH4Wx1R6xu2f6QYbtnhHhD3WPRZSs/TIjIcwPmRiTERB8S+eUYzVMEmdKx9D2s/v1tImf4aUkLQze96RmX8kylyylBW4PW3VBgdVZVZ23Dq3K6jPGoGRNQUE2qHQmwuFmvvWyq1wk+Ziut1Gvxe3jcApNO2bBaI8dSUeqs0Z0XSu/j7HofyyPPNZKMh0qgVh0YuIk8g5GZ9hsLg+cw3zTbpV7V/7XU8IsjqDaky8hheXNlQJHlfoSdPKvaTBSSYYt8+WEtLxPbTvCAfg6LfrFavHG+PJdlDgLXUaYHPDbXzx+Q2iMZqk8SkPA
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 05:41:44.1983
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dabd96ad-75a9-4530-65b8-08de74308f2b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B06A.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6307
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71790-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[amd.com:+];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[aik@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_GT_50(0.00)[58];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: B02FE192172
X-Rspamd-Action: no action

The DMA subsystem does is forcing private-to-shared
page conversion in force_dma_unencrypted().

Return false from force_dma_unencrypted() for TDISP devices.

Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
---
 arch/x86/mm/mem_encrypt.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
index 95bae74fdab2..8daa6482b080 100644
--- a/arch/x86/mm/mem_encrypt.c
+++ b/arch/x86/mm/mem_encrypt.c
@@ -20,10 +20,11 @@
 bool force_dma_unencrypted(struct device *dev)
 {
 	/*
-	 * For SEV, all DMA must be to unencrypted addresses.
+	 * dma_direct_alloc() forces page state change if private memory is
+	 * allocated for DMA. Skip conversion if the TDISP device is accepted.
 	 */
 	if (cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT))
-		return true;
+		return !device_cc_accepted(dev);
 
 	/*
 	 * For SME, all DMA must be to unencrypted addresses if the
-- 
2.52.0


