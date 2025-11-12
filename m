Return-Path: <kvm+bounces-62910-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BCEFC53C4F
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 18:46:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 1F02A346061
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 17:44:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7640434A783;
	Wed, 12 Nov 2025 17:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="oPMB9HaP"
X-Original-To: kvm@vger.kernel.org
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011060.outbound.protection.outlook.com [40.107.208.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17CC63491D5;
	Wed, 12 Nov 2025 17:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762969311; cv=fail; b=WwSDyhMZMzh9dFUSl8pvm5s66/Xb3HMT0HfkjaFNfYsWm/gZ7EL1uPpo4NXCzhg8k/spPNwuab7EJSrDTR2dFdo8zB4teSOfh+JWz+EEWqk1uR5f4pUdpLRUEn2T+0p5mwRAPQKMcMpsM+XSiWGoOrbrLQRPpA7rexiOWGzX5eA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762969311; c=relaxed/simple;
	bh=Vo35TLnAgMDF7VOgaSaUmgUulvtnQaZK/+vmhJ2RrtU=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k1LYKJsukcj5MQeVP/16Vr7zToibzhv0bxiXDHKTY0vnGd/dv3qT8G98iiBWeC98DxhmiYXnz4EyvlKPXSlkTqeIBcBo0GB4INulv8Jf4D9/Mt+TjHuE88kSgq26dhFuizs0ZFjNOEKBiVyHeaH8ph2rmbDmQ1/Btpz7WUoBHT4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=oPMB9HaP; arc=fail smtp.client-ip=40.107.208.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rlDGwWKZ28rRwTmq/ykGinTg3mNTJaEu5Whbmpm8guYW+hh9iuV3VyvFK/1DufkoDMvXVYLmVV/UWQm4puwemASHyw9BXYMzUeBmW3sk/LnQ6izUvSDq9XoyDw6w8u/W9FmOjCZ0S52m+XDvoTKxFcaCNcSrnLdO0m8liq5v816PF8woqIY8X8MRtN2vn7vB827Bk92SB5NAPKUoTU0XTUoJMfxFVFZQEHMPqEDwBLIZu6ADinWBe8BryPvYeQtZ84S/4WIMlKLznf1bsFefqQkHMjZBDw/LUEeRo/nAp1nh9hrKBE84zxQpz2YTD/j4HDXI/Q+sAq195WMN0vlpxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jHwZfMujozZa/yv897+tcjmISXmqErcFYRydAQKrs5w=;
 b=w9xbjf3RaocwLTn+nyqa8g2HZpABBR/Wn3y6MpLZThZ7AcnBrRx3Sf4NnxV2C209F1m1+pCqTxNZsHvHcZu+cpWhJE5FixQrkPzPg6gUmuWC93gsvVEnZxoFTwm13+0Hkw5WQzTlv7eX8IONPG8XkNjwd2hiknoZ8pOZgoqr1Nzm/q0EJLesIH8rn9/wguX6y3rh65ZsUo2ddhOugdjpIeCnBQjIPZpn/Ye/WKMKVsO/BCXwFTgFD/U2kqhYhWSH/Rfpd6/SblHFc9OE9csEVzXAeLXIgaI/regmi6Txy4EG5vDlccIksxvN9/tKb6e30pr7TzTWAmm/uzSm62JTww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linux.intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jHwZfMujozZa/yv897+tcjmISXmqErcFYRydAQKrs5w=;
 b=oPMB9HaPkZ5REDu8cvwfVy5Mu6sXyqiqlYxGamQoHrZOX2jMETGUIudyp7gmpyeVOaHT0vuL8qAtJua27vtE+Bk21Ummp+IgPZdZ8ANmFAx1yLmwnxdS85exdv1AjBXnK9dYpDLAMVEQWRVqMetISn12gxEbJt2xoSaLYQyfk+WWC1ZE87gtG9bnmc9FzpXXoJGpV0wAxW1DEzNkhmK1q0UwaBBiUhvwhEyFwucFPzWdD8vBxRpocwGUX6Ehl5l70NUE5TqiX7k+StCkKn3ERrjzIX/INSwkawIMvefW8FQ43LwYYaCd0jT8z4Z46kDm2jMOzPmr7efYWKrOESeTdA==
Received: from SN7PR04CA0120.namprd04.prod.outlook.com (2603:10b6:806:122::35)
 by MW4PR12MB7261.namprd12.prod.outlook.com (2603:10b6:303:229::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Wed, 12 Nov
 2025 17:41:43 +0000
Received: from SA2PEPF00003AEB.namprd02.prod.outlook.com
 (2603:10b6:806:122:cafe::3f) by SN7PR04CA0120.outlook.office365.com
 (2603:10b6:806:122::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9320.15 via Frontend Transport; Wed,
 12 Nov 2025 17:41:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SA2PEPF00003AEB.mail.protection.outlook.com (10.167.248.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.13 via Frontend Transport; Wed, 12 Nov 2025 17:41:42 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 12 Nov
 2025 09:41:23 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Wed, 12 Nov 2025 09:41:22 -0800
Received: from Asurada-Nvidia (10.127.8.11) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Wed, 12 Nov 2025 09:41:22 -0800
Date: Wed, 12 Nov 2025 09:41:20 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: Baolu Lu <baolu.lu@linux.intel.com>
CC: <joro@8bytes.org>, <afael@kernel.org>, <bhelgaas@google.com>,
	<alex@shazbot.org>, <jgg@nvidia.com>, <kevin.tian@intel.com>,
	<will@kernel.org>, <robin.murphy@arm.com>, <lenb@kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
	<linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
	<patches@lists.linux.dev>, <pjaroszynski@nvidia.com>, <vsethi@nvidia.com>,
	<helgaas@kernel.org>, <etzhao1900@gmail.com>
Subject: Re: [PATCH v5 3/5] iommu: Add iommu_driver_get_domain_for_dev()
 helper
Message-ID: <aRTGwJ2CABOIKtq6@Asurada-Nvidia>
References: <cover.1762835355.git.nicolinc@nvidia.com>
 <0303739735f3f49bcebc244804e9eeb82b1c41dc.1762835355.git.nicolinc@nvidia.com>
 <d5445875-76bd-453d-b959-25989f5d3060@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <d5445875-76bd-453d-b959-25989f5d3060@linux.intel.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF00003AEB:EE_|MW4PR12MB7261:EE_
X-MS-Office365-Filtering-Correlation-Id: 31930bd6-cc2b-41af-5c5b-08de2212bded
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|7416014|376014|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?e62rU4j3jPnpl/6xKzQSJvCCAJuxNKp4JhtPWnIhCEul6eLAEjqYzQ3v0iJW?=
 =?us-ascii?Q?98YfvS2y5YOWxAAZFyX+iSu0oQuwqIYTFJgQ0xC7zBPA5XhD+i58zTWEFKMN?=
 =?us-ascii?Q?Hy7V/dfd7PzsswxvfkKfCh/GG9KaP3qC2ndpX8fwmci9xCOTbAbX7oEJsmWb?=
 =?us-ascii?Q?Crl+LfMg3jIApdrIaOfOzu1TIoNWIHpxjff5oj2BgCGTRwOoKqRil9/SwPJk?=
 =?us-ascii?Q?iDJtFZ6lWXhXEAUI3HVjGq2he17MNZTqlY8Iwm8GOwjQJ8NJYtNMjgI0zytY?=
 =?us-ascii?Q?08Y1lQ+23E9wMgCbzAvlLxvyCe01WZtaSpgsh/FvrHTxAzAJdx4qld2BQo0V?=
 =?us-ascii?Q?yRoDMxwcMbxrEG3lDSyLJrNQ2DX6cf7qJng0rjvrznywo8lt/aTl5eHJWs3L?=
 =?us-ascii?Q?tVVaw+mliPgAXvHDwEa+ir6NILDBTY+wPGxsJmQT/a6SpGHVpda7h89T/DD2?=
 =?us-ascii?Q?T5UVDIQMLCWAELM/PqBZCMJCAqJM4ze5Qnz3C67TnOi9boYR7Tzp05Oj4RxX?=
 =?us-ascii?Q?dyKXWOZRTBxPgX8yh8aVfGFlIPHfiBz+GhzuEelZE0vcixB2pnf+S77cWfQ3?=
 =?us-ascii?Q?q99A0PN5HfHO+GylMacU9UZOX8ORcRZTkjwrcvlkgE/MmwvnVq1L2tV7rHnO?=
 =?us-ascii?Q?JP1i7EIJoh7otHhFBmgQxvSLIjYeRto1aQIr37d2riJ79ERdAKrlZ23Qyh8s?=
 =?us-ascii?Q?pEHFPQTWhM8OrZT785q0zOMnMrnAH7o+rGHaWH21cisLBfYjTIHW8GTnVcNH?=
 =?us-ascii?Q?G5YJ4r2AXQNp4/SLNIETFdDEEVTzGSUQA4hAFGXbv7pr7jkIRpE0f3n8IrCi?=
 =?us-ascii?Q?J1Q5FBd9uGOnuLSBm9rieLzuaaHa+6fUr7+ouMlGGM+I6QN8wpw1iT9QeJ5g?=
 =?us-ascii?Q?QtNARNwwXILjylTYoJWnmQF/07QnTS0C9Rufx20+8Mk88ko0DgZREp/zhtkM?=
 =?us-ascii?Q?XqIuJnCDNHJ9uHNjcs9i3sNvaFlcdnKNSJPNo0q1O1Pm0iMYgk1lSdKmCu/9?=
 =?us-ascii?Q?HVGpwEXT/pz+qDaFnNpJHtOeinq6u6EvXe8+iTZ84a5AfquVet9tD0lV247h?=
 =?us-ascii?Q?MN4j33Y8n8zVvWMs6GLHnOvzHSXCzngTMWwat9CjI63/84zLelHFwY90b0dK?=
 =?us-ascii?Q?EGTORqcPuGIi4qYl5afzax803PNuTABttvNgxNDB5l6k4rHxMFnMBpx4owx8?=
 =?us-ascii?Q?rm1Z7Yn3U/yAUUhNLhkjML3W3XVYobu7lXP+UqyikP2+tu3NiUYDVbFapLT+?=
 =?us-ascii?Q?6b0gb6rfzMM2ehSu4R3qKeP2h+qSZaVxM6Wc99qIk/GoRyF2uS65WDGFZiUm?=
 =?us-ascii?Q?xSmhyOiingzTSDp5pAWj3KR6aC5KAvNXB2Nubi4e7t1LfGy5mhkWDn4ndwzt?=
 =?us-ascii?Q?wtFNPmKJsHtS++mCUxZpvUE8HRcVDeHpxycPL+QS1IVdF9e15t4jJ7zzouaL?=
 =?us-ascii?Q?1CU2fGJg1Kk4JEgziBGZUFQ6qj0upeW1yFoTl31RuJxZhINFdKsU0j7qlk4L?=
 =?us-ascii?Q?VqS92KONJms3apodj4tbNILvjcgjjedqPRIaH9uUDaDgw2qa5CTv45AEzghr?=
 =?us-ascii?Q?idfFF4R3LLC0RXTAtS0=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(7416014)(376014)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2025 17:41:42.3195
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 31930bd6-cc2b-41af-5c5b-08de2212bded
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003AEB.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7261

Hi Baolu,

On Wed, Nov 12, 2025 at 01:58:51PM +0800, Baolu Lu wrote:
> On 11/11/25 13:12, Nicolin Chen wrote:
> > +/**
> > + * iommu_get_domain_for_dev() - Return the DMA API domain pointer
> > + * @dev - Device to query
> > + *
> > + * This function can be called within a driver bound to dev. The returned
> > + * pointer is valid for the lifetime of the bound driver.
> > + *
> > + * It should not be called by drivers with driver_managed_dma = true.
> 
> "driver_managed_dma != true" means the driver will use the default
> domain allocated by the iommu core during iommu probe.

Hmm, I am not very sure. Jason's remarks pointed out that There
is an exception in host1x_client_iommu_detach():
https://lore.kernel.org/all/20250924191055.GJ2617119@nvidia.com/

Where the group->domain could be NULL, i.e. not attached to the
default domain?

> The iommu core
> ensures that this domain stored at group->domain will not be changed
> during the driver's whole lifecycle. That's reasonable.
> 
> How about making some code to enforce this requirement? Something like
> below ...
> 
> > + */
> >   struct iommu_domain *iommu_get_domain_for_dev(struct device *dev)
> >   {
> >   	/* Caller must be a probed driver on dev */
> > @@ -2225,10 +2234,29 @@ struct iommu_domain *iommu_get_domain_for_dev(struct device *dev)
> >   	if (!group)
> >   		return NULL;
> > +	lockdep_assert_not_held(&group->mutex);
> 
> ...
> 	if (WARN_ON(!dev->driver || !group->owner_cnt || group->owner))
> 		return NULL;

With that, could host1x_client_iommu_detach() trigger WARN_ON?

Thanks!
Nicolin

