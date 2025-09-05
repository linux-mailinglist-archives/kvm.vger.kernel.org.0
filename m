Return-Path: <kvm+bounces-56905-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F224B461C3
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 20:07:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C95DE3B8AFD
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 18:07:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF62131C57A;
	Fri,  5 Sep 2025 18:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="fYAPPyu1"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2056.outbound.protection.outlook.com [40.107.93.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F8E137C0E1;
	Fri,  5 Sep 2025 18:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757095607; cv=fail; b=VSr+dHC+4Hit8iWKdPSJu0Q9EY8EyE1T5mGTLq68pQFo1ChTZH3sF+5NtODjeV31LJz26I71FmGzpQ1OCQGFA6XXzE463ZyZ3TTyRKptoNjOg/W1NYHidsWGs219KMZtqfv0EYryicScMWD5IOpstkKNKZU3Ca9/fLQdKT10umc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757095607; c=relaxed/simple;
	bh=EDIyJe28op7/u0jxNtgfuXDh1KRK0+kXGRpTcIW0Et8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=EZosZqopDbQHL7KzxQVHw5oW2pmG7WBk210lwExmMLDroGjyATCS4XCucmWqdn+oENUQAc2D1jLXRTuMpIoq6udDuxD1y5Ajso+867GcrLmRa1Qv67Uj9Zg5B30EPgwMzvaBvIsL9V1HvFBO2m8F1kvqpC5Inxt29ih9ZaXMoUc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=fYAPPyu1; arc=fail smtp.client-ip=40.107.93.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KqmuFc2D5rIIUypNxCqnz5kXv0aMqmQ/tyMBfSim9yD+tD5O7lmKcF54Zz9vrTOpMyftig4YHApgNy4Lu6uGAie9T+eIii5UrNb2X/VdEhzuS6EC6lShbxDX4UvDwXGd+zc1/wJpHmXm9+e2E3eqDDHc8jMZTHhUs9+f7L/I4f8npiv5mK4+sfgRo6Xad4vuvF4fPrtrTh4nNPmwxT4WQRn0zn6HvZaVnHrDD8dc0akAx7r35bACtSHzzf3Nu5yfn//bGtx2KQCKpbXtMpXxClyfSZDAWv4VaRxxgBHDApZa8Kyo5FrdTTwvk7EJkMQy8f7klTa82HUUXdUnm6PT4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b45PaD5PopHBfTq3XEkqYmfAC73CukyL7A2IqhvpSiU=;
 b=xQH8qIz1ecVnfKRIdcQXIpLN1ooFuANjFVM2G+gjzRFHnvur/EhGFMNA6ZRRn7eYzPaLinQK6w0Ijv4iWTVqEq/rWtY89iqMOHS4quosfbH+eTLuyTt/duEQ3hJEcPFljzCutCqGzQgT4bDdXH5IaE2zy4iQQgzeI0p6V+I7GFasnlDvus1A7PMSQ+yg1pJJg/7NRTHtudgL3RdgpYgBOfYJRAIJ1ufRffMoglg2wns15TR5XKQigadD+x5cuDiraXwTpJKtHzwLoI0WYhgLWAiF4lGwsBVhhpDcfzUUI63ou7+O6OjyCNHl0xqfQdljtsCqQhu0SfQLWT/MooHHdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b45PaD5PopHBfTq3XEkqYmfAC73CukyL7A2IqhvpSiU=;
 b=fYAPPyu1T7GtuGzCVpro4Js6Czbmq5s75BeMIzNaBvBvJ/jZfNGO2B5OemZnBo+NlqGusha0YNHuGQ9EL74bULfZhFDlu9uPZY6qfI8BcL0Rwbfbge/wUWkGFjWe09UJwzDzrUZ85ucmyAQGm/YKaUZx+hIajjiyAthKNi5xdEm87Y/hF73Hkh7NtilnlEzX/I6YNkv5mpe49jMxQSqlSliwbHlCsGVCrL49L03sztKc4uvXnIcRcM5mMfUTsoPRm/HHc1hz/UOo+h2+jDqgS3kCEPwXywAttJseqkxjl/gZQH337852mA/44zRqiBWxse14UvX/t469vQqK9B3n5A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by SA1PR12MB6776.namprd12.prod.outlook.com (2603:10b6:806:25b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.19; Fri, 5 Sep
 2025 18:06:35 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9094.017; Fri, 5 Sep 2025
 18:06:35 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-pci@vger.kernel.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Donald Dutile <ddutile@redhat.com>,
	galshalom@nvidia.com,
	Joerg Roedel <jroedel@suse.de>,
	Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org,
	maorg@nvidia.com,
	patches@lists.linux.dev,
	tdave@nvidia.com,
	Tony Zhu <tony.zhu@intel.com>
Subject: [PATCH v3 11/11] PCI: Check ACS Extended flags for pci_bus_isolated()
Date: Fri,  5 Sep 2025 15:06:26 -0300
Message-ID: <11-v3-8827cc7fc4e0+23f-pcie_switch_groups_jgg@nvidia.com>
In-Reply-To: <0-v3-8827cc7fc4e0+23f-pcie_switch_groups_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0148.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:ac::13) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|SA1PR12MB6776:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a411c66-c25b-467d-a0e0-08ddeca6f19f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?G+3ChtG2P3UwWulWRNnGi57iVve5YdTxMLotwNqahl/XX5lF2WmCl5HZ4gFv?=
 =?us-ascii?Q?jRsWV7hHRuKJ2kBK7UgQOuzjYz9Xl5PFs8ndRb0UWg7WnC9SjhsolhLAguR6?=
 =?us-ascii?Q?x/+xFTpFQ4z4d1SmUypCWq3U5afSQHyR7Il9jNyteaCZrMXdUIQAxbw0Y2k9?=
 =?us-ascii?Q?xB2UGujs029Y2RmUnEAN4/zEE8wQN/VNQG1cYqgvj7SSPAxepy/0M8DdpOyN?=
 =?us-ascii?Q?H2UCrYY2aaqjvYfXVkhMTGroY8kYKbweFdE3jiypO+HsJasxYC5Nnf7ZFjqi?=
 =?us-ascii?Q?BM5/ks3z0zzsBQuspSXETbnGYnQDHx52VMH8WqEfWte18A3tPzMcAcZeBXY9?=
 =?us-ascii?Q?YyDZP6UM/42VzNmutn/hyOHGi1Zq5JvwM5vXKmoQ92AugArJprgzEQM+EF0V?=
 =?us-ascii?Q?wLasS15GQt+ITCmST6hl/ag6axpBapGb6M/mFOz1kE/prgjHvnKD/o519Yct?=
 =?us-ascii?Q?prGVAHawG+S84duvisuV5XZ0j2DiVY2wsqXPtB5ydgLek9Aazr4g/c9aR2Sw?=
 =?us-ascii?Q?wMwC3PkQh6gTyqBdUuPG38ZD1jtjhtH5QrT8+xD+QaiFrhgJJf5P/WwNeJK3?=
 =?us-ascii?Q?z4DcMevBuTa2XKoWNBKEWZgcXQbSgC7mvuf2lB6GzJzN8awUkai1oJ2oWPvy?=
 =?us-ascii?Q?RRgXejnejrOMqsgaHEmcxggxovdK1tT/Hm9jGmrWkA3xg6c49BvpTvcu624O?=
 =?us-ascii?Q?yv17BRA4B60O/qXjBBXW7t3UJKlx6N7jmAJybexFnUItVnbT1Dh1RG1slQWo?=
 =?us-ascii?Q?ERlNTTgncyHQaaOj/Qm9ilpimM0zr8SnOYhWHGmt+SolJ7q8v0xR1nMcoGJC?=
 =?us-ascii?Q?l49QFLQsUEaGJJV2Qob2HUSyRGL0bKxxaurCuCjxNYnvzeA4VGoCdEtLf3fX?=
 =?us-ascii?Q?F5QA/RkEINFGZTetps0Jbhf4y8GA5m8vCoR/SvLMP/2HDiMGyoOEa44UYXtb?=
 =?us-ascii?Q?Dk2xltFAEQew7o0IpGWIul/J2RDQ2WNb6cccO7iKgLhIILaLSMUxIz6Fnqfs?=
 =?us-ascii?Q?oWsrR5A/MFucDQeQBjTK6M+lzS7R2SGmgEwSHlbu9luEUn7hn/QuPVHnYZms?=
 =?us-ascii?Q?Vk4LWUZVqMhCruNEoGwnEV8caEdJG8NuBmT9LRXkHec1BzNmbAJkw1wIThBT?=
 =?us-ascii?Q?Yk7vSw7XZ1m2VeVqftkUZVMPjpsjT6dBm27hqtAVSNUE4+rflU7yfLamZNr0?=
 =?us-ascii?Q?7wpS3TSrf4F0/QVfjiq00tI1xOL186jgIGuazekmS9OduVnc4lJAi1nPd4+1?=
 =?us-ascii?Q?SRHuQmvggkLn3uVXT89cU9s+9ZR/OlG53PCQZUOdnYJHSD0b6x1aEdXWayFl?=
 =?us-ascii?Q?CF6+721bjUnaI3VDXSktxa4MwWiQgXCcGAO7xUhb33/uZ9Y0ThFAB7jVpLNy?=
 =?us-ascii?Q?fVBNoenH7/b8O5+OlUrE5essYQyuneWGiZXiqqoCVrTFuMuOHQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+GRXMeVRvyIv0p7fK7NwKrDO3UKDCRq3NYyCHQGTSfTiFW/+PoJJLLg4iS1o?=
 =?us-ascii?Q?kni2qxva6vOezXzNqHHoV+rHI5T4QDkxXlF9GLV4UVaGOnHTIo667hLVZr1a?=
 =?us-ascii?Q?EbYuKNCKV5+aFv0p+afKBFNF5DwbElC/rxfIG7bw2fNjR59NScEqtCK7bA2f?=
 =?us-ascii?Q?1MRjcov1HLUhSR1pSx4v5lfPzypEj5shaIhT4ydKXcDhV8GE7C1szfTp2f7s?=
 =?us-ascii?Q?WOxOaDcVQywR78O+R6Z+5cNPQUuotyA8Eq4TzaV0G79jg/vXio/vklf55m3f?=
 =?us-ascii?Q?G3euIOB5sGqqkLVjCtEleIUgmVWbGO4fw81a/biCVe6lXtYGrv5K6XoQlrf4?=
 =?us-ascii?Q?MKgE6FBBbLa3hnaCLj1gejt9PCGpJGt8KFqgzVunjWIzE4zpbq4/Vmc5/cN9?=
 =?us-ascii?Q?igU6QXDpDQXtKXP0wJg1HBn0xDYifPc1i2vX7bZsQW4YkWcwgyKtbtIMApt8?=
 =?us-ascii?Q?ZVJ8BY2/qYEdzNqB94W2Lf7WCK+IVDWoGy7CZjIlZ46RW5Je4iLICPFdnO/V?=
 =?us-ascii?Q?I+l3DJO/fLHT0CD4GiOSGgoJGDWAKypY7X29Fd5haK+voUgGOrbqHkiYVH0G?=
 =?us-ascii?Q?u3ddUsKbyOpfJVw80pcJWJCjpEjOyRkbUudPXvH95e8qX27umpuyjCtwHcWc?=
 =?us-ascii?Q?JsVDXPLJ4ok9K6xYrmgyiDtGoMkEm75tcbE9kHxjy2Bw4B2k19yL7nRj06kZ?=
 =?us-ascii?Q?imAKYejYU7qlRvhUSfKxnYcy8dvMRSRSRnENDaaHrER2g8K5PX8uD4ydKC10?=
 =?us-ascii?Q?+MN8V46bhhzf6yw0o46aR26/xMQiqC341oMDLDX5qCb2pF1/MG0+UEO/drE3?=
 =?us-ascii?Q?Lyc2tCKrFr45G1DpeIys7oEu8BMU7RnWhDnHMEyZvUWKu/N9JoLAlpi+HM+f?=
 =?us-ascii?Q?soN1jg2T/N1dXWl+I6L8RUTwCKlZeZIbUkPDQUwZJPsdFV/jM3nlyxTQG0l0?=
 =?us-ascii?Q?6JtqetGrHO71ofPgHqQeAc9dYOFV3RVvXVs/Bsfufakpnb30i5li4G3CjyHT?=
 =?us-ascii?Q?NDvmOWY4VSeWmYXFIZI4aBwucQNxkeSHTLdcnFFwRYDEpFGV/pDihW5MosMq?=
 =?us-ascii?Q?WfRaIdjNH3VQHNj4AhGAugrdrooAOAevkZiPSpKUd7TBqOe0o1Elpi3b5G8I?=
 =?us-ascii?Q?wVwuVzjEdDEfETWdkmOLXBpDWacT5NdAEXFQVkhT/Am0tZi7l64EmJ/xSIY5?=
 =?us-ascii?Q?LgY40ol0LsGAMd0jdF+R8f6GEDz2RHVWoDnUwkH8+i+xjsGRinxHAKTFbE4e?=
 =?us-ascii?Q?OJAwdpd0+tqazIvXmsNEn3zH9IqhY3LHOn5OSQ0p3h1QBBC6RdIieWLbmS+l?=
 =?us-ascii?Q?z/2X99PIkXz1N+SYOQzisUNNPHOIgs7z5s6nyts09+S9uosDX5ItEuxQS6rk?=
 =?us-ascii?Q?G6G+g/096hR73RAQRyNp2ECaDG7mEr02d3xVW8cQ9mDgaiRLWCw1oLbTPlL3?=
 =?us-ascii?Q?VuAjo7aSlrESTFwE3i8jB1gdFWWCoLeH/fi01+xeo44VOl2iCDAcKGyeRwoT?=
 =?us-ascii?Q?h4woDsx1cr+dCWPe7mVjuiTqUirGnbj0jc8qPeft2+El8gouFa834TnUH69j?=
 =?us-ascii?Q?rx7yXPNaihz8TSv5+lU=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a411c66-c25b-467d-a0e0-08ddeca6f19f
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2025 18:06:32.0235
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bFb8L5uOJ/GVZeP3VbTe6vJQsDQr9PWxYxFXn4UCUVDZwMq2Lf7AoRXt3xDZunWC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6776

When looking at a PCIe switch we want to see that the USP/DSP MMIO have
request redirect enabled. Detect the case where the USP is expressly not
isolated from the DSP and ensure the USP is included in the group.

The DSP Memory Target also applies to the Root Port, check it there
too. If upstream directed transactions can reach the root port MMIO then
it is not isolated.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/pci/search.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/search.c b/drivers/pci/search.c
index dac6b042fd5f5d..cba417cbe3476e 100644
--- a/drivers/pci/search.c
+++ b/drivers/pci/search.c
@@ -127,6 +127,8 @@ static enum pci_bus_isolation pcie_switch_isolated(struct pci_bus *bus)
 	 * traffic flowing upstream back downstream through another DSP.
 	 *
 	 * Thus any non-permissive DSP spoils the whole bus.
+	 * PCI_ACS_UNCLAIMED_RR is not required since rejecting requests with
+	 * error is still isolation.
 	 */
 	guard(rwsem_read)(&pci_bus_sem);
 	list_for_each_entry(pdev, &bus->devices, bus_list) {
@@ -136,8 +138,14 @@ static enum pci_bus_isolation pcie_switch_isolated(struct pci_bus *bus)
 		    pdev->dma_alias_mask)
 			return PCIE_NON_ISOLATED;
 
-		if (!pci_acs_enabled(pdev, PCI_ACS_ISOLATED))
+		if (!pci_acs_enabled(pdev, PCI_ACS_ISOLATED |
+						   PCI_ACS_DSP_MT_RR |
+						   PCI_ACS_USP_MT_RR)) {
+			/* The USP is isolated from the DSP */
+			if (!pci_acs_enabled(pdev, PCI_ACS_USP_MT_RR))
+				return PCIE_NON_ISOLATED;
 			return PCIE_SWITCH_DSP_NON_ISOLATED;
+		}
 	}
 	return PCIE_ISOLATED;
 }
@@ -232,11 +240,13 @@ enum pci_bus_isolation pci_bus_isolated(struct pci_bus *bus)
 	/*
 	 * Since PCIe links are point to point root ports are isolated if there
 	 * is no internal loopback to the root port's MMIO. Like MFDs assume if
-	 * there is no ACS cap then there is no loopback.
+	 * there is no ACS cap then there is no loopback. The root port uses
+	 * DSP_MT_RR for its own MMIO.
 	 */
 	case PCI_EXP_TYPE_ROOT_PORT:
 		if (bridge->acs_cap &&
-		    !pci_acs_enabled(bridge, PCI_ACS_ISOLATED))
+		    !pci_acs_enabled(bridge,
+				     PCI_ACS_ISOLATED | PCI_ACS_DSP_MT_RR))
 			return PCIE_NON_ISOLATED;
 		return PCIE_ISOLATED;
 
-- 
2.43.0


