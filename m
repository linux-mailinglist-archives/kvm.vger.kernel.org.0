Return-Path: <kvm+bounces-67963-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BBA5D1A9B8
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 18:27:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 62B60307932D
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 17:25:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FF47350D67;
	Tue, 13 Jan 2026 17:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="WIIHsD9H"
X-Original-To: kvm@vger.kernel.org
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011050.outbound.protection.outlook.com [40.107.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D97FE34DB4A;
	Tue, 13 Jan 2026 17:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768325154; cv=fail; b=HDKBNoNwIKXcQMPFmGDlVqjeyNWMxA8wv0CsECH5lUkjOKt3gPzpm+I/PsQbss3PCyXnA/hQHVJpyF7YkZqAnDUZD0jw3ySmw0HxzQTXoImIpSbiiWihqrRFoipqCOPAatBXhn/MVxu/qb6jURvzXjuf6B2mqyYBjCzSNfS8Hak=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768325154; c=relaxed/simple;
	bh=si8bt4nPkgO2lSiOwkt0gLy1eB36qx2GSlzlzZEKLMQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=SDbADFJRaVU6HExLwEdBT71nzlyhqIRmAQJEASny4gsv7JhFWF0+ulEO//G9HF/jXblLWOtvfI9JSbCDTkcKJt90N2dfV5y5GJ8QZUXtTjYS3dELOodnL+WVwx7AtuBO1FoEgonzhhMfw7aGxHknh3yha5VaVL3K460TjtZBAqQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=WIIHsD9H; arc=fail smtp.client-ip=40.107.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W+0nrU4QQ39bmK1OR3TsiAZ9ryzFVeWm2gmw7dTAy9XM6ZmH0czEb2Gr3eqbsdP7FE8XjJvcTxfUBz0agDBhxKJgPhTcxIyfp/ewbW99Y8soDIhYx9SACbABzPBOn1Wm9swndb1YQJmZ+obh+jndIjLDMOxyjmG4+vJ+MFpKdn6NAoWhs/xyeiRBj/9mm95grVn6nxwvgQaPXwENXBpnvkMqX8YSYHLNhA5vOJ6T0JnmkXmnu+9PqYU9GTvIl300k7SERgF9RRKdGv6fwZf0U80Sb+3ZHByMOShKEvrqvaYStG6cA/JhFMkPjJOvn1kbhcxKSKlTmIZoNJIU+BBoUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a4DosN8kaUQyhedJANI3HbaJwxLwhavx+C+mxk5lWo4=;
 b=oe8//mdGewpx3edclSap89cnrrt4OGaV6lG+miKJfcPOBSqjqX2PGYKBFyay8N6p7YbAGCzKL7ISR9KrRSC8H1xmsjnHaPMamvQxseaeOz8VmWKCWKBgiORv33EiDeaZoTF/wUBT+GZRXsDDlHpAxIWvEk+BIigoJfABf+AFtemXDxDtlZQPRCdskD3dqepR8fWpgUDfaztqZhAG9f8UkFVp5Pi9Ked0Ez7nMXohx/jCywDLCbL3NYi0Ag/KqUjK071KC1z0aKfCVj6VJbc8T36k/EatdIddgp0jayQjJMw3Mrx+M/EmhzbziTIMre0x4oPSBzpnJs6HSVn6xgUG7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a4DosN8kaUQyhedJANI3HbaJwxLwhavx+C+mxk5lWo4=;
 b=WIIHsD9Hvb/LY/dhyb4FYly4L5Pl09dV1hRlROSOT4oDJEfooypa8Aa8rkzQlxFPpfGlpCQpL2VHRzL+XVcd3K1VIULLdtWfAPQKU1kcKwCGcT74P366WnNSoIyvmjwcRudmwg9A+xk1vC/TB4U5z8n7NQLvZOLtlvZ5CIC9WcE6USvVKIBqMDnFvsBxpV9wBKsC4qkgiXgT4MrvAwttMJnLpRQx53rXLCsJ9S7Vxd3Et5INT7g8MMCBRUd5QHB6rU001TFeHeNX+ue9YY0HTACLi+OIM7jhaIGY21YK1i3xuoqhqX7efF4q1i2H2C4U4clPrRJb8jef3C1voue+ag==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by PH7PR12MB7985.namprd12.prod.outlook.com (2603:10b6:510:27b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Tue, 13 Jan
 2026 17:25:49 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c%3]) with mapi id 15.20.9499.005; Tue, 13 Jan 2026
 17:25:49 +0000
Date: Tue, 13 Jan 2026 13:25:48 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Kommula Shiva Shankar <kshankar@marvell.com>, jasowang@redhat.com,
	virtualization@lists.linux.dev, eperezma@redhat.com,
	kvm@vger.kernel.org, netdev@vger.kernel.org, jerinj@marvell.com,
	ndabilpuram@marvell.com, schalla@marvell.com, dtatulea@nvidia.com
Subject: Re: [PATCH] vhost: fix caching attributes of MMIO regions by setting
 them explicitly
Message-ID: <20260113172548.GH812923@nvidia.com>
References: <20260102065703.656255-1-kshankar@marvell.com>
 <20260113022538-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260113022538-mutt-send-email-mst@kernel.org>
X-ClientProxiedBy: BL1PR13CA0204.namprd13.prod.outlook.com
 (2603:10b6:208:2be::29) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|PH7PR12MB7985:EE_
X-MS-Office365-Filtering-Correlation-Id: 69780e9d-fa1e-46b0-5948-08de52c8cb55
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?SNsAqx/3+EKrcrNFYDyTl/sxb8SaGBn1F0r5mVjko5cpF/unajzjiczNMM0w?=
 =?us-ascii?Q?otk952YeQ63baq5lJ6IwYAB+dJEPwlox1fUO+cL73QWA6JsB8X0sm80X+UAg?=
 =?us-ascii?Q?RYOV4toO3C6PxH91b1+n0V3GbYFA5MmNkE5xs5HV+drQSu5pxr6X4BULSpL/?=
 =?us-ascii?Q?CpSej8iPRgamqwSBZZJlvSn+BRCqJ9TP87LydEUiQyrxLSSMKs3DXOWo1ks4?=
 =?us-ascii?Q?naS6w/jk4OLy99IBGyQBveEVe2+jTF78IB1U4h7TL0EhwWvPlC/hTwJexIM7?=
 =?us-ascii?Q?jbUnhQ2b8JUU2N8ItH4uQX8uyUSwXUShXQXY4wAkKpFaNaeS/3bRiWAo84Fh?=
 =?us-ascii?Q?6U5GhdVQeV9ytdD8tFwapP6wT9h12i5iSYsHbOOszc9qD3dFZCFpIx0m+L+G?=
 =?us-ascii?Q?RNFwU0O3sAxOpCrtCETpWlYFR8r49nW0sC3iLHNQwUyuaFC5iCTH0Qf6ElEs?=
 =?us-ascii?Q?Vul5UJpVU49PnAjKPXBMW81rGQjwuGvKAiHO4QUUd+ZYrOaLBRtSMtPOpvHQ?=
 =?us-ascii?Q?PdMzkWfQhLPO7cZBP8Rhbg7Keg8yw+WdvRoMafOhQZg6KlsbXb7mYK+ZSK/R?=
 =?us-ascii?Q?Cj3Mg/wTZfhLnyiotaNR7k2PME+ypoc/NoS30yjxmT/YzIhzVLa1pAerFlYM?=
 =?us-ascii?Q?1ajh1ARrKYFOHI6YrtaXMlwOe/4Dw/Vy8yPWVf/QmCsf58Nmws3Bn+19lMHB?=
 =?us-ascii?Q?vI0XKiE1EXsPInRPSZ3Aohny0ZjiBeRbl5YVo0QK5rA6OTSPt+Ok/Nwka++F?=
 =?us-ascii?Q?zt6WBTlDhdTwraUgftZHoKdh9/ozGRg2SNZSuW05uN+0LfwNlagHWE4eOE9Q?=
 =?us-ascii?Q?iViu3MYRNKmOvJgp4XUcUPqY2HteiUgISoZYeFvBm3d4H9aH5FGtUEuRumz1?=
 =?us-ascii?Q?SmnFS6dAoAq6yit4f4YS0e7jnrRti6hCAkw4SyfYL/+uxZZolZ2fwL7nxbmw?=
 =?us-ascii?Q?g8PGrvKldHu8J2OUv2R33HutWxRTQhMJyVgQQIQZn155fmuf0/9ZA4We3tGM?=
 =?us-ascii?Q?EwN35LwdVIm/tOwrKivCjwWX+PvA2N1zaGNKIIl1uNoo21Z5L9jlpezZmsos?=
 =?us-ascii?Q?d5742QN5VY2LC9FDUs+QERHGIWZJnJ58wUDDjckuRZ+NbT1u3SBaWW02FHvO?=
 =?us-ascii?Q?TZ+27k0CifODK/OSEApJNxGEPFPpFhYr8rt0pBQVW9yiriuT4PLWOdJIy8Rq?=
 =?us-ascii?Q?EwibsDLMxePNTdIw6Z7ZXRW/u3Nl4zUmWma1Gv4UPNmR3Q+hY9/KiznFZfGi?=
 =?us-ascii?Q?C54TVVPmUpXQbvcpQroXQEh+YdvD4uzdSCZafCN1YSDx9D4J88AoyY2X73OY?=
 =?us-ascii?Q?ZXmX9942rps+VrpAhFskjBonb5w+zzHC8NbLYjW+yTQTYbWHvvQMaFOJl6ez?=
 =?us-ascii?Q?Y7tenkZPB0E8s3LvGWvV6whEwn4dmMRqLBtehubNjSDqw6iqOUJa9Y1jEiZi?=
 =?us-ascii?Q?R8pyPeQV1ojYQGe2g/TNRt+BWNfeof5u?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1cyAFEfywxd7FijxmR7HU5vMXs8s/2SWczjv/Wg4ePZ03s8rhx16oVSjozBs?=
 =?us-ascii?Q?7ABu4NSWnWB64Vq/bffjFC03+E6DBldRvTmMxV586u1MKDs4GP7mHQe6Dzgp?=
 =?us-ascii?Q?vcEulfPnrMqH8vjuv6G4hhXyxQpckltTKoLvlbgg/Kp4r7nMEIkmVxcjPxrD?=
 =?us-ascii?Q?NvY5oONz/rgwaThTpblTSGYbm8u6m3N6b+jIsyEJm27jggmRyxQwK1QmtG+j?=
 =?us-ascii?Q?MqFs/Rzn4EZgfrvUdxKEeuaNsDmaCJl8flWnMNrjHZDWipXuBYge3QNxWgDE?=
 =?us-ascii?Q?4lvgVmsst9h2XbL8cEw539bTRplA/m0WMdmpwNPzxJR+MjjxNvghS81OmzgG?=
 =?us-ascii?Q?Wg3PebwDGj5re8Du6nlgjFV4bDNBg35nfA61WssuoX3OriM/EEuC7oKIDYtm?=
 =?us-ascii?Q?KC7lv8V/8SynQtPeQrl+lIWqudr18ueJ41Q4gzb33TtS2VLTnMS3cGP6SXEa?=
 =?us-ascii?Q?lik9dZLLpuf0T0sJwve55MrvPO4VdeGj+v4t2wh6wiKeLoy0c+cfJ5OhynL+?=
 =?us-ascii?Q?3RWbNPeNc/4FWX0u8KG64HvjGEkq4g+h2CPJh8rpbznJ4GxlcdYJjIDAbX4Y?=
 =?us-ascii?Q?sl9l7e7+P7NtJS5FXaSrWf5wzv80aF48e0NZ8GQWrBtvntFVn5HKAzZ3yyE4?=
 =?us-ascii?Q?vkpk1oUMhTjxDNkZJFoLSBCFdpSU2GDNtTRXLcAicDDkm+LcnJUiNC5stKa3?=
 =?us-ascii?Q?evjPGUMZz+o7FB7d1SGzcKdzYjbBTVq85c23fVaBg82QpWcaIJuhEi7r5Zgp?=
 =?us-ascii?Q?zCJgaVYglVgeLY5HTRP1EolFlodvS/ydYXYr9yhaqUly9q+US3FkIjoD0KLY?=
 =?us-ascii?Q?xcgwWyxT75iSCgnEpGYSIlOhVSqZuXtY1FjsmIR3B9EKRZuiwNRaHV8O8nQR?=
 =?us-ascii?Q?pTa28UbwgVk95tU3RZaWiGARj6f31WeEnKVxzjYUV4Ablp7g/U9bUsRBntGi?=
 =?us-ascii?Q?k3A4yJgh7QOy5ZMKJ5/lAI5bmE8FUJBzoAQq0bsYRfb+/ak8xwvA+KuObmpP?=
 =?us-ascii?Q?Y5uHFBNVq4KMfFnEA4rde75gs+qAonPtk0BUjqICILEkkBIhhCMT8XbOnBxl?=
 =?us-ascii?Q?xPNZi9lhK5nJNjOG4Ffnd+3Pu29tWtajUs9JkQQjJ429U2ApB4ecAmggXzuk?=
 =?us-ascii?Q?kL5g4dsDCSj4ndGXs5Q6i+ZJEaJjBRftj1jf4jEvY18+aRRtXNMTHfrI9bjN?=
 =?us-ascii?Q?OinC3JLijG+FoJf7LVITpWFbwuCujPMtvJ/PMR7lQVitL65em8ozO3IFqkn2?=
 =?us-ascii?Q?RwhfQ3hF34cbYVI2NwCaTJ2b3o9nZNGiKHEs6hE/6650/olbXvryWvagspyG?=
 =?us-ascii?Q?LB9gBy0X+8hcDyW4sEIHSQkAT2KXj5Z1FB5PtV0nx82DSSfJ8BYxVHn2ThLN?=
 =?us-ascii?Q?aYfwmH3g7FGexfYkziu0BeMieZL7X1s4y+MK9Ge+7/Bgy7AIztUXmXJOCRYJ?=
 =?us-ascii?Q?FjV/v5DxIQBpSV6KqSF66HTl6RXAr4PvT/k06ccUoQ7HOeZa/aH6sfVdNYyQ?=
 =?us-ascii?Q?WrKNPweMDM5jtLhaccw97EkMvzYWAvCZXNJW2txpRm/L3GyOf/O3/P+V40gV?=
 =?us-ascii?Q?HqQub6tzre6+xOa8C41gx75DmrUuxrfqza8VBMmXdlOBDckpNeXoyaOnE7xH?=
 =?us-ascii?Q?K2LBo+N8gZcyAU4h0s4fGG1orKnZuSsuwV3u3JOXJOV0iAjygZiLpDBV9xq2?=
 =?us-ascii?Q?6B/lVW/mnN2xX3rRvuhYHbpYrmwaf5mE+z2UFc+2ARuPSUIKtn4dJfqvO1V/?=
 =?us-ascii?Q?0Si1KnvTVQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69780e9d-fa1e-46b0-5948-08de52c8cb55
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2026 17:25:49.3031
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tCJj4YK9OwE+AQ+DbD8XmDospdKW/K1jEnaN6VcOP9/dLpvDaox4koskbcWn2f8S
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7985

On Tue, Jan 13, 2026 at 02:30:13AM -0500, Michael S. Tsirkin wrote:
> > Signed-off-by: Kommula Shiva Shankar <kshankar@marvell.com>
> > Acked-by: Jason Wang <jasowang@redhat.com>
> 
> I also worry a bit about regressing on other hardware.
> Cc nvidia guys.

> > +	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
> >  	vm_flags_set(vma, VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP);

This is definitely required and correct if notify.addr comes from a
PCI BAR address.

You need to trace the origin of that memory in all the drivers to
determine if it is OK or not.

For instance mlx5 is:

	kick_addr = mdev->bar_addr + offset;
	res->phys_kick_addr = kick_addr;
[..]
	addr = (phys_addr_t)ndev->mvdev.res.phys_kick_addr;

"bar_addr" is PCI memory so this patch is correct and required for
mlx5.

ifcvf:
                        hw->notify_base_pa = pci_resource_start(pdev, cap.bar) +
                                        le32_to_cpu(cap.offset);
[..]
                hw->vring[i].notify_pa = hw->notify_base_pa +
                        notify_off * hw->notify_off_multiplier;
[..]
	area.addr = vf->vring[idx].notify_pa;

octep:

                        oct_hw->notify_base_pa = pci_resource_start(pdev, cap.bar) +
                                                 le32_to_cpu(cap.offset);
[..]
                oct_hw->vqs[i].notify_pa = oct_hw->notify_base_pa +
                        notify_off * oct_hw->notify_off_multiplier;
[..]
	area.addr = oct_hw->vqs[idx].notify_pa;

pds:
 No idea, it is messed up though:
	area.addr = pdsv->vqs[qid].notify_pa;
    struct pds_vdpa_vq_info {
	dma_addr_t notify_pa;
 Can't cast dma_addr_t to phys_addr_t!

virtio_pci:
 Also messed up:
  	notify.addr = vp_vdpa->vring[qid].notify_pa;
    struct vp_vring {
	resource_size_t notify_pa;
 phys_addr is not a resource_size_t

Guessing pds and virtio_pci are also both fine, even if I gave up trying to
figure out where notify_pa gets set from in the end.

So the patch is OK

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason

