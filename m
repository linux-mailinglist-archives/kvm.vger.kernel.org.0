Return-Path: <kvm+bounces-51974-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CE90AFECCA
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 16:56:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 38DE01C48116
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 14:55:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66A332EA15E;
	Wed,  9 Jul 2025 14:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="MiwSDWFd"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2057.outbound.protection.outlook.com [40.107.102.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B846F2E9EAB;
	Wed,  9 Jul 2025 14:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752072761; cv=fail; b=MwxyTyWVcEfbiNeIZ5QGu4awyKjI1wkZjupTA/IGf4QhkSJGjotVhOfr7J8HQ+ouvELcpo92Xi6oPYtiFpRUt+gDgw93rckp+N/p7+iQDt43MJYbNBX1+UNvJlEVKJV20vpB5KIu0km/suKYjacqoMgHn+0pYvcHVWsara04UX4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752072761; c=relaxed/simple;
	bh=KN/G2lnyzTd6X2nVqUPqLlFa1igosgr49ZomjFTAEag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=aGcNSUqZGyQtpvau3LehM0w4ggEfDXFB5GMx1dUJeNPd/ZzygwWbepLJ87Yk5PDlZ6XqMssv0BQCd7eJWYbL+N3BuGteGwlav4iD4cU1coiKdurgr5BvQVq54qXXyyQZ3LIEZxQQXvDowaVWdmc2xA3w6ErR9/0fdx1hMtPANKs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=MiwSDWFd; arc=fail smtp.client-ip=40.107.102.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Abuaj01BRis2e7ssqMs9zegN/9doWy1EX2hrt+vYa81B6IkstNfa3RXEhteQKa5nBmSg3K7qkwiLRFjkFuzJwL8R85CrUPVGvYctydkgUacljoNHpfBLfv07TS+P9mQCsnScv3wcpjCdydTDWYxzNpBm8EHoyJ7nCg8Dm6H7VqjWB3PSAzIwcwTHiHybUv6UPPtTA67c93r4gVRH5Kj7catLs63MaVX79mUGC585b/BwzVC7MOi5oLWwlOJfO3GcIhclX/dEkqB8rNjENEjZe83MuToHv1uyDDPJj7hi28csyaOh8H3otz8NQzBz0lYT2xHouWcMfj2RyJe9AmAndA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L+S9IMPr7E2SQHs5gt7QJSGVzE3HdbGB2/BM/vncrl8=;
 b=i72n+Z3FcAjBogGf2ELL588lNqAjbXKgOzIq3ZfNJXwlhtttGfR9jcCt7iRFoYsgAEZd6z1r1db8ZK9LxrowxcRAXfyj9ErdZe3WbNNyzL89f6qPNtRqVdfiM1pGO2U/5/UozQy05CZqK2BetnS2YRYiz2CLkmg4/w7+ArW4o7xNVkrOz4HReADBS/pT7Iw+qeGRuBZKsyZsAZP5cJPss0zzlmKvH/mkYbzvAlsp77QTp45IcGehOmPYNhucrMQyoRbUGRQ4g2+xz6UgYzEXk9kYP5OvMzLFV1D62GWdmNA7dAtwFWVb+ULO9MndCZ/EMqy3l24rem2Wmk4p+B4dJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L+S9IMPr7E2SQHs5gt7QJSGVzE3HdbGB2/BM/vncrl8=;
 b=MiwSDWFdBTpf9T/W8PdBXZFIWqbGpa0OS8Xt6ed1zrTh4rxSZBYttZin+6GPJVxa4LqfHAmUxz5OJuzcWZPIKu5J7uZqNkHgqfwuFBO3Iz+KBfCeva5S7PCGPYKR38VxUNNMhxlyJs0zdBFlZWbSEjFb70tZOWwaHPb0eCMlxxMhZrzw4mGLAwNzDgXfqCrww9V4LhowwE78Y0ywFTZr5+RxXJ94eTR912B/12pH8yFLhiMAt+B4CtdopsGDi39HBXUCBhPGxDG3hiZQqsmxO3qSvw0EvRTxRjvooqIf2aXBKSeQENE8z2Mli0hWYlsWjcBumomrqAD18J/EFfN+xQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by IA1PR12MB6356.namprd12.prod.outlook.com (2603:10b6:208:3e0::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.26; Wed, 9 Jul
 2025 14:52:29 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8901.024; Wed, 9 Jul 2025
 14:52:29 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-pci@vger.kernel.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	galshalom@nvidia.com,
	Joerg Roedel <jroedel@suse.de>,
	Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org,
	maorg@nvidia.com,
	patches@lists.linux.dev,
	tdave@nvidia.com,
	Tony Zhu <tony.zhu@intel.com>
Subject: [PATCH v2 07/16] PCI: Use pci_quirk_mf_endpoint_acs() for pci_quirk_amd_sb_acs()
Date: Wed,  9 Jul 2025 11:52:10 -0300
Message-ID: <7-v2-4a9b9c983431+10e2-pcie_switch_groups_jgg@nvidia.com>
In-Reply-To: <0-v2-4a9b9c983431+10e2-pcie_switch_groups_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SA9PR13CA0161.namprd13.prod.outlook.com
 (2603:10b6:806:28::16) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|IA1PR12MB6356:EE_
X-MS-Office365-Filtering-Correlation-Id: 811ded62-7f45-4d09-2b3a-08ddbef83946
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?d0Qhev5u1QsZaihXEpdrZBWmZm+J2Rbd9a3YXG/FSRop+v82Gc5sUvJefSPx?=
 =?us-ascii?Q?qssxw195AvYzIyNNGlzORxCFM2oxqzSXXFFp+aYUxOGK7I6xZ862BBRGc5pq?=
 =?us-ascii?Q?Y4OhuwbYwzqPhsHZJUzewXiOMpb8C15n0RIPQOhf2Mrxe/d2LRDhnhv+ossB?=
 =?us-ascii?Q?BWx/7V850dTZvisHKjRWuzaiQVcbaZvjrJMoZTzqcQldZ4JFQHSCT6ClFl0e?=
 =?us-ascii?Q?bKH2aOM9Un5nJLsvs7wg8RihyOIGAlZIBmUKwGBOY3UfmMUCJr8hZhya2a5Z?=
 =?us-ascii?Q?vz/2WEE0yTmonzZXOyBnoVCqXLnYdCAfFlJg+iWbm4mJzvxJAyfeMfoeTbK4?=
 =?us-ascii?Q?6zqmp+QqsydlEKCG+3mHJ3JaJdqdFJ5CxxneeAK9w6W8nAjVzlLYk540NZp1?=
 =?us-ascii?Q?tXQplk1K7qwQhstKToL/3q7pfbEAuZ+LFfOG5f/Qn8HBtN9t143QIHk7xv4G?=
 =?us-ascii?Q?i/K7l821c4detjvXGQtN7d9i67UQawbvcdTGYhBvKONlwUmWC1pGdB1kBhgD?=
 =?us-ascii?Q?WdMEAvCIUmAikxhCmxSRdsD1/KCWZrN813q+BQsyr6IKKP4Z/UtXtsvjZHNz?=
 =?us-ascii?Q?jTwlGGdc4tSaHB1c6aAWP5Ak2SIl9Q2S4afMcis29Cww1TyLcXJnw733KM0N?=
 =?us-ascii?Q?aNgGsRjQ9IzZDd2svO+f9wbaALhFicmqhPzyx6xcjQTrG8Ab1QQv669IO+68?=
 =?us-ascii?Q?6Fc3scslh+N/Y86y23NhAdvO5yVTAIzmjMcPeWHkNXjUXXTKrtGoBeBnthu6?=
 =?us-ascii?Q?OAx09ZsPBvCVgaXhAv67Df+afRrwFvg2n5vgH53KxL39EXvrnukdhTtasrMc?=
 =?us-ascii?Q?7iADZa1m2TH4q+taPIOun+mtw1bzBRUKi2yNDOV/e8YhH1Yy9ligkXr3c2Ne?=
 =?us-ascii?Q?PgqNUHOb9OE0ZP2Qy0WpaZIBSNnX6Q4Hi63epLsFCJEFwHzPN1K1e8xGVukz?=
 =?us-ascii?Q?XNKtcUdYauYfO4Pl5dtMP8QfdcCzNEBZBDMA+xBuCaBznpc8iON1ZmtrJ5l+?=
 =?us-ascii?Q?HEOM/k55hErm434lS5DcxptNbGGGUxk+7lquUM/RvuEHOp49fGlrymptRx9j?=
 =?us-ascii?Q?3YmVkYxcpqR7hKJU08cmY1Wcg+3rw8+aUQKEL/xyR4DE6x/s+mnO3m2wq4tl?=
 =?us-ascii?Q?vRMIgQTb7Op4s5SLWYd/Agsyyj4YrFetM55yrDFNRLl7PooPmsWuMQPngFaO?=
 =?us-ascii?Q?CmcJYATEVXquJwFRSY9Ic8w8A/uLkxawEIHvIPw8yoWi43RwyJZ4vhN+O8qK?=
 =?us-ascii?Q?IZ3pfAS1dGebLr7ksiEd9FUKapkRhUZjIL6U0UF3awI9IhooY8uW4gAARrAI?=
 =?us-ascii?Q?6DehP7PEBteGwpx3Y34AyuvlUKfQ2FaqfN4SwrslajuDWtm/3sdveWvFbm1t?=
 =?us-ascii?Q?T7HgHZOtLFMaVPDGtYdDKgMQ7FK0t+Wqr2Rj/tbfO2RLMh7Rkw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?CCrFSIfhgRuHa7HaKyJy2K7L/TZNInbDixMXDkqflrmWpT6c9RVVwCPmuZag?=
 =?us-ascii?Q?AJSsoKHuDrADxrYjYLmVWeuBy5qBBhYdqailE+cLBe2TQIM2w+0CwvrYjmoT?=
 =?us-ascii?Q?OfU+H4umMmjolUsVksE6FCsE5L17NhF0auytsNnTl9l71VPudgDfO6rFsLDR?=
 =?us-ascii?Q?TOfA0iQ7pHX4qQiCfTYszVE4xl7X+uzN2k8+JS7IWYsEmnI365jj/LXKvcrS?=
 =?us-ascii?Q?wuX/ZDx//LVv4MWDEL4XNpbuXJiCFJimmH9pCTb6NfuW9H08IKSGYQLDzpA3?=
 =?us-ascii?Q?HJJmTSFUFnZJDN5AOFFWZFqNahRHslIH/9CQxBNAfGEhoarn7dav1s5XrAVQ?=
 =?us-ascii?Q?UREH/RqX6aZyFH7h4Se4BLO1NxA2ayrt1IjRC1hUCzuYzdCkYONVEcvrcwbP?=
 =?us-ascii?Q?A6D0MJYcgtJUfQvwN7Wq8OBamgl8nkTzAu6HT8OP9rAQdxJhZIG/JTiv+9Yh?=
 =?us-ascii?Q?0u7D38jdj8YH2PNB5yyRjiPPpOfrdTb0l/P2yoCSqDZzzB1tYdPpWCaHt+A2?=
 =?us-ascii?Q?erFKF9SS5SXown1FJvPI0ZCsKm7cm7i3lFJCHsBTZbzFucinInL1jmP52qjm?=
 =?us-ascii?Q?8V2WRRwo/sDtsNMBSxnPqdfTeAQGc4J1z5DqeXVoADbbowXE+388cMqCSEld?=
 =?us-ascii?Q?kWlEBy4C9LmnykgJklm5G0ALgQuDm+H3a0IiyqWIZanPhw0bMzkUnwlpBacR?=
 =?us-ascii?Q?QkqGkNOH+8UJsIl3ma5XyfepJgzuaHGW7+uNR941PZuzpzuuuMJrmfw4Gpc/?=
 =?us-ascii?Q?t8wL/IOFZpAuTIQmg18YxF7w/H8LBMhdP4edpAuQ6eGA2oNOjrWnpZfIYtYx?=
 =?us-ascii?Q?6kDAzWUGwhsc8PZ+cMbSp4JnuOwCvoP3m0G+GwJy+XK5xTfSr/91to7Y4XGH?=
 =?us-ascii?Q?oWOs70ny0wiPA+Lv0ssuvf1vxKwmbVuujorqj+2nkeY00EzXSEjzWFiOWP03?=
 =?us-ascii?Q?UywkOITl2E5o+kRSar5Yq6UPdqAvRh7PnRScdAMpzX1p0z9L0vC+4HBGGHv6?=
 =?us-ascii?Q?uceNIsDIsqvFGl7dF/6bzbcWKtytzUw9BJmTP6Bwyl0A96JIizgSjtTc5Mao?=
 =?us-ascii?Q?GisXxqddKWtzcw4WQ2/dyDeYfOSOc0/DenCcz00OOBSG+SDsXJyJujhQ8KUw?=
 =?us-ascii?Q?wLXuP5Ye2tABwGbFR4MO2kuUNrfGOBbv0L0x4Byn7kjUiPAG0ITnEjB+p0KG?=
 =?us-ascii?Q?XK8KUASviCBXYOEWZDNI6j+XCt6nxOuaahwUzPhPha68crqwZO1nLuQmG8FD?=
 =?us-ascii?Q?ETFKwa2qoWtQExXtxbldlvOlmhi6pHmIto9AB1s/9j+qSCFlvRGhs9QwEPYj?=
 =?us-ascii?Q?EQKd0oe79CbayGeFcY0f/bG4xrIVZ3lY2q178xj9SKOJsOrIWo4T32GNbbcI?=
 =?us-ascii?Q?Ag65KocuTqDw9hSn7oKuGf/6jT2b9qcPOdci7DKhC82IeuYCtZqVoxM7H/q+?=
 =?us-ascii?Q?lbY1t7BhpVGD1M+1miDRTKKzrxTZn/I4nM/6C+LqS6C1BNtPr+fODxb2ZWKH?=
 =?us-ascii?Q?dPZw7RThrnMJOLsMnkCbV7YNxcOMxrVhCPOtbDVcM0JlA8BavEHpmUvH9SPO?=
 =?us-ascii?Q?dxQYh3U16yQD+FQwDarRGkcZuA72icqjbpDAD5r/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 811ded62-7f45-4d09-2b3a-08ddbef83946
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 14:52:28.0624
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5rBScJ9vI3vsqDJCay59mC6sSYGAigDRshPeb66uBFiMJKeihRaDp4i4WEJ+AYPm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6356

AMD is simply trying to say that it's MFD doesn't do P2P, use the
existing common helper for this.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/pci/quirks.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 8a9ab76dd81494..963074286cc2a9 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -4640,6 +4640,8 @@ static int pci_acs_ctrl_isolated(u16 acs_flags)
 		PCI_ACS_SV | PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_UF);
 }
 
+static int pci_quirk_mf_endpoint_acs(struct pci_dev *dev, u16 acs_flags);
+
 /*
  * AMD has indicated that the devices below do not support peer-to-peer
  * in any system where they are found in the southbridge with an AMD
@@ -4682,10 +4684,7 @@ static int pci_quirk_amd_sb_acs(struct pci_dev *dev, u16 acs_flags)
 
 	acpi_put_table(header);
 
-	/* Filter out flags not applicable to multifunction */
-	acs_flags &= (PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_EC | PCI_ACS_DT);
-
-	return pci_acs_ctrl_enabled(acs_flags, PCI_ACS_RR | PCI_ACS_CR);
+	return pci_quirk_mf_endpoint_acs(dev, acs_flags);
 #else
 	return -ENODEV;
 #endif
-- 
2.43.0


