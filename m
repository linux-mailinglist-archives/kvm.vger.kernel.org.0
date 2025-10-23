Return-Path: <kvm+bounces-60945-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id C3F4DC03CDD
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 01:12:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id D6085508FB6
	for <lists+kvm@lfdr.de>; Thu, 23 Oct 2025 23:10:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 598382DC776;
	Thu, 23 Oct 2025 23:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Qx0WfSdW"
X-Original-To: kvm@vger.kernel.org
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010014.outbound.protection.outlook.com [40.93.198.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90C442D94A4;
	Thu, 23 Oct 2025 23:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761261000; cv=fail; b=W4ZucTVMCoavmV4ceUg7YOjhOLgqjHGh4OwfAmGDdlB7GVlk1AKxT10jnRGraYC0QnBpnwt67c/VVfgQg4G73yCobqrJnsv/Gc8++XVDuTIkJEV47/RL6YiUEGNvl2p/CXkXquraMwNS/NFVkBnWJrW6nZ33nxYW/jMho8B8+Qs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761261000; c=relaxed/simple;
	bh=2oSwwfNlmFQ8wr6quMr4IUdtXtQozDXLXAgFHkqgQ9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=u9mR7v+LGRIc/xqU24KoV3wk/uugqkc8sM7/1riqA74Cf+0zOqYZYKYu3VRJ6pkui5nu7gsyYJRIyesabiE+bNF1LMnwp0chKtJwhdJ/IIympuQxmR3WHHfzR5S9t2tpovcjnuoL4gaHDvk6X2xGr8x8SSsejQutsQgimzyxOHg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Qx0WfSdW; arc=fail smtp.client-ip=40.93.198.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QRlusBRFD9jsULIMQ9ZL242VYM6kyX90z5k0n1wdR4SsIe7WEZrXTYG1U4qn3N4HlFvS+TXz5wFIzBa7f8PqSz38ZrF1K6XIrc+od1NiBvEhPDEXFuk29fCiQpp97WC8Ytiv3kDjTmMSA4rj4Nzd41bZo9WdO7k6mFWz3sNKm0G5o+ocgKOUKdu9Srrf0sJ+kaiZz7+xR14UjjtPl/bGO+Vn0r5sMUm7GbrgduuSf3hVoGi30N9G+JroYlxxRpxYi2YAdISWSp5l3d5DAktg13AKQKgpARskg3YLnKdxX98Ogqw2+kKIhW91R5hzo0o1ovoZTXz2VHHNlPIxlCCkcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GfckQgCIkppcIsxa66nzhZJRxmQNoMTJ3XeABHDHo10=;
 b=yPdpiYmVkDdAg0pKEhmWeeda5UfiLtiV7OINjW+natZW5UbTWb9CHobC7F0B67mhy5cmNaqDym+EiRkFnPnXRAhZRMoJhper7sCSKtsPFkQ49LHTzEzTQixZKfHw2HCHl9H2vToaRR/Xw+SjzD0vurGiYJtHPwu3NCGGloycXZ4ldazW9x1rdQGB3TSGut3Lm2xGnp/ioGarbCpuphfeLYKf1bW9t3e2Ebab9olBbgVUCgIYL+YaUTx8/B6Ym1A6iNcEblj94Kfd/krffxjxZ5a0sB4ahPS55N2wp93rIC3YxLgQsujb18MTQvKaAa4NmEJ510wyIBo0ZocbggoSKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GfckQgCIkppcIsxa66nzhZJRxmQNoMTJ3XeABHDHo10=;
 b=Qx0WfSdWT0z4GABD4KvuGFRR6Uq5Q09vPy60VpxaROfsjMp8jr04EjLAEcL8mibICO5X1k5x7nJtIvMAPMBTYmbEC2PPuhhPLJrTAQqjFvhpBFkE1wcVxVuC5iGzRNEAljEvmjED4hQN7IujPpL+921T90C4uAgt6n7XI595aSLzuQ9LTA3Kzyjd3B2xlq4lEgskbhBnDC3qqEPhZ/ClDSeat0Jipjpg5o9Gy4fsxy29Sa+H9RfrgBYQjohOYqp/M/bjE68UjHayTwPDg6eIb/Hj5bhc+1CQjrCT9rW28I80EQwq7XsKGL8DkNSvHlk7DXJgKYUGFIlXg53ULsfGbA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB3613.namprd12.prod.outlook.com (2603:10b6:208:c1::17)
 by SJ2PR12MB9138.namprd12.prod.outlook.com (2603:10b6:a03:565::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.13; Thu, 23 Oct
 2025 23:09:49 +0000
Received: from MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b]) by MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b%4]) with mapi id 15.20.9253.011; Thu, 23 Oct 2025
 23:09:49 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alexander Gordeev <agordeev@linux.ibm.com>,
	David Airlie <airlied@gmail.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Ankit Agrawal <ankita@nvidia.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Brett Creeley <brett.creeley@amd.com>,
	dri-devel@lists.freedesktop.org,
	Eric Auger <eric.auger@redhat.com>,
	Eric Farman <farman@linux.ibm.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	intel-gfx@lists.freedesktop.org,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org,
	Kirti Wankhede <kwankhede@nvidia.com>,
	linux-s390@vger.kernel.org,
	Longfang Liu <liulongfang@huawei.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Nikhil Agarwal <nikhil.agarwal@amd.com>,
	Nipun Gupta <nipun.gupta@amd.com>,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Pranjal Shrivastava <praan@google.com>,
	qat-linux@intel.com,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Simona Vetter <simona@ffwll.ch>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Mostafa Saleh <smostafa@google.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	virtualization@lists.linux.dev,
	Vineeth Vijayan <vneethv@linux.ibm.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Zhenyu Wang <zhenyuw.linux@gmail.com>,
	Zhi Wang <zhi.wang.linux@gmail.com>
Cc: patches@lists.linux.dev
Subject: [PATCH 16/22] vfio/mbochs: Convert mbochs to use vfio_info_add_capability()
Date: Thu, 23 Oct 2025 20:09:30 -0300
Message-ID: <16-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>
In-Reply-To: <0-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0128.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::13) To MN2PR12MB3613.namprd12.prod.outlook.com
 (2603:10b6:208:c1::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB3613:EE_|SJ2PR12MB9138:EE_
X-MS-Office365-Filtering-Correlation-Id: b1fb9479-828e-4be8-5ea6-08de1289428e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?RHWUJOjdk18l3qiFo6X/8l9wzSnvMQRyH2n9JFyowubApt3ZZw/a9jIY7eMp?=
 =?us-ascii?Q?dBGQNyt8rX2Qzw2JXtrd+bO+03O6QmL6nUH3j8ZOSsm51dOm7Gj/z+3zX4kI?=
 =?us-ascii?Q?D1vMBLRxjBDRCiNHOPTnpyLYeQqHFpLsskupkktZ7rUZF5/3d3RXpPoxMg1z?=
 =?us-ascii?Q?Lb0tQImlYg+hyythl56/6WqWwuXQbswg+I7akXFdDnf/repvJEkXa3xj3mhN?=
 =?us-ascii?Q?joPmCak9BHflp5Oj+sLvDY6zTFbUeOhMILQqIpDj77CECHZFrunbpPB3vlBl?=
 =?us-ascii?Q?xyMfIP3fz0ZJEhMZE8WVpEvRmkBmsqTssIQZsVcABhz5kl2pR8wwqvHVOA/v?=
 =?us-ascii?Q?U6U5+yEZ5wFfbxcJIembu69EYoNSCgLGftQ50HZ9c1/MBpBDelPotEq3MEpx?=
 =?us-ascii?Q?fNOQpiiT8XueQCibJL3N/9HV91DVBVgDSYjAmRfFgvqnFDbh0f+fgD8SGN3h?=
 =?us-ascii?Q?6ExciSoUOf6pP1c18pqtpsELjgdY/bcuVYuHJLX3ysTTzxaAeATlnFYNLwPg?=
 =?us-ascii?Q?cfFwP9Kn0gE4kqU/Jo0smM4o2C/hE2mZ3ukrBoQVIb4w0Pw4ToU/7Gj0OWlS?=
 =?us-ascii?Q?XDnnGjof1dGtqAz0AOQHAUsAiFHlRdMMPNQc7iEKl8yiDfpbQYBgdTgGUXxl?=
 =?us-ascii?Q?naX4DEfTeeG6P4O4FVXydaZyT18MoY8BcFruaN/vdjjqvMyN+xkCGmDHg65c?=
 =?us-ascii?Q?bYuWLS0bHOP/KipgcX54rDyRNJKiwPd241M+C3b6UPLBxnN9SIZxSwFgUTb2?=
 =?us-ascii?Q?LBiof3cm2qp2SEdzv7AmmtFB5Nrb7yyO5yr93fQKdrRvebBatO2vOelZGoTj?=
 =?us-ascii?Q?C2Tvokfvl9XAJdhPPGtUpzYFjBDx70+z32O6TZkddWapODEI+JN8rtctYRYU?=
 =?us-ascii?Q?XbB/fT8Mwgzyqmz7TZCORBTVMoNZJLE66Q4NXzxDAIAYJcaxg7IuP3UcNPxN?=
 =?us-ascii?Q?5M67MQG/xzKZetkp6GcOV7E0q4O/HPLvGfpzam0A9Ni0n0mi35OP2PLYUoQl?=
 =?us-ascii?Q?/tMAET04KAjayqbS8LEbvACBFR24ueJTwKOatsE6PrEEFdcl4dD3SF/rLkrb?=
 =?us-ascii?Q?zuqKNuVGk4Xq6ZR1qaONfLYftoqrvIcrCASAHrYwhaUK7XMcDh045oAA+aBo?=
 =?us-ascii?Q?COj2KWkJ9xIniotkVeOTP4OmDwzNjFzsqsOFCIolLEl2/PqDTiTIEkWpb46+?=
 =?us-ascii?Q?l3cPIvjRN8S9Kl5gRYfVSPsFwlRTOKe4d804aN+Hbqa1d+Ss/cYPvIMyRB+G?=
 =?us-ascii?Q?dZ6tf8iFN/TO2rrLL+sj5sEE1/Lz6RVMXbREULcm5h1FRTb4BH+543nojnX/?=
 =?us-ascii?Q?ljcOiJwjOwXinEBCcWI7R8DTisZIcF1vOJ4rrRVGGd3muUy8PQgzABXOL3Eq?=
 =?us-ascii?Q?w5MgjRTBwlFfKtHPNOqgxuCq153m7AbB0/huQ0QuX51T3B/heuSmDKJxGAfT?=
 =?us-ascii?Q?9o42+4lZ54r97M+FRrYRw+kwzcTAATtSO6QkG3ENn1Yc5iEgmvsPXuRLXdQm?=
 =?us-ascii?Q?z6/N3dHmFR/w1hk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3613.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?T0it8HKgMv+fUQAdkME+rSl2CAbjTatPcG/VhAJYcm1ZLL1oQaX7MRgyGvhy?=
 =?us-ascii?Q?qIPN21JEm1GYV4nUfSSSpt4vWGwYPLFiWgNc7EiUxIbUlmvt4Gu1u0rP6qfe?=
 =?us-ascii?Q?fIDyRhmYjnQ+25ehfurs7FTKOU4zRuVV9KgBdFCAHzRPkka/nlTwYywhdXGU?=
 =?us-ascii?Q?h8Xa0MhuFgB3blhszvWDn0LZefb0L+YL1QFTaoGo2sRGaKa/A+Z8BcmVBhqa?=
 =?us-ascii?Q?uZ/bRJN/xu4NlWVyhe62AwEsBVSMq/DUdxpDr5URBEirO4yOarwCtBmoQz6V?=
 =?us-ascii?Q?WPCnXn/z44iJC0rAJmy6V2+IVf9OlEgFmrMp+KKbkakh933GvcNZ1oAqCCFE?=
 =?us-ascii?Q?E10QGXz6P2txVPOhGuPrzlYC67CReaCqyA4FLGL6rUFrklvlhY2cK2SUwtKn?=
 =?us-ascii?Q?pJl1QF3xjkcT3pHiL+zkxSCwkeEZzTfBt4xQisrJfnKEHrsPY3Wqh7sKONgs?=
 =?us-ascii?Q?l2NmPK0i3LUACiQn7GnHksfcPLK8uB8FWIEmP++IOJxXEjuZxyRDHHA9ydnP?=
 =?us-ascii?Q?cGmkUHqFkQpnWDHWe5fnSOYYOOYBiW73VJrfNeXCphvmF8zbPgEpGVFWOe3r?=
 =?us-ascii?Q?/CFMSKOKluGqu+bDlLTDPYL94lC4fQK4aSDISaxEK2THk13JZvraf5MC1p54?=
 =?us-ascii?Q?FMGoqwLi0wq+0ta9Xu2n0qlaE0br83MvLEz7h0BzgAE8/CrRmg4wvJ9ETMyJ?=
 =?us-ascii?Q?jgncYk5R+LD84NRZ/i0zGzHUedZ61TBsIqOoDUmKJmT8l1tWro3LdT5N7Rpn?=
 =?us-ascii?Q?UunfMhKV0DucYjFBZwuKfB7Md4SossC7HN9UmLrdvgtc5aNce4UHXs+ojudp?=
 =?us-ascii?Q?DXXN+ia3K6bvAI1OMOpirCHPXEKGiI3BbPLO7eyA8aJksA5GsWJnTplEJADX?=
 =?us-ascii?Q?n3sJT0DP+rdCkAx6FptmG1IeU3qpFGVR7pUDazIeDV5pxHJ0HGFdlOtdW54O?=
 =?us-ascii?Q?Er4AkF4sjh0ER6Wt1KLMVGQvFoHzu7ll8TCNgWDaJWgd2fr/lfQuZt9K7pWk?=
 =?us-ascii?Q?PoOYxpn4An1ciR3t8X8P0gL7Zyc8ALHSDv983Yz7nFOuKapOTqzRGvuy4oKH?=
 =?us-ascii?Q?QLp8VovcCVluvBKTTG74LrSd4aYvT+IuOcSk6Grohqb2LGet2prChREipGuo?=
 =?us-ascii?Q?2xZeF1LV46JXF8+pT1A9w8kEjgvFNTcNx4liicgA/hg07S+Xk6MQqLQeoSqM?=
 =?us-ascii?Q?kWEiN7hrD2oxflhj6oSRkUVBX9QNKUvXZjmCn2pELegd6m4pglsObHVjdYii?=
 =?us-ascii?Q?79s8JbHNz7q2cr7vVL6sR++u+97x7reqUhU+BbZOB2Cp9DzpTvtvHbgtcp/R?=
 =?us-ascii?Q?scrjEZ/xEPXSFPtoIHIfSVpxVauLlQlLPOHo9ymNPfczrG5VdJT8DIBtnjtb?=
 =?us-ascii?Q?+oJHnHeg9GudPI2H7HiZZ9XgGReaDPAjgZMoGZw+HjhQp+me3924JtQs1QJB?=
 =?us-ascii?Q?s4YgMGYqGn6bY8AR/Q0ucj02gGNLp/5kM6HxbgIBWI6R7au9XTxrXJtkyZ0e?=
 =?us-ascii?Q?voEyHKFZTHuXJ/Y/5hZjcnz3vtjhus2X96b2N8L1p+p5qF0PL0Jpt7h2ekip?=
 =?us-ascii?Q?jnTg+cNh+wzj+n6hPcUSXpbkurvAxNO3enVmwx/q?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1fb9479-828e-4be8-5ea6-08de1289428e
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3613.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2025 23:09:47.1517
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OrECeGGNwOsB4Epk1nxXXY4IhHytAmvowfh7rIt3X6uni/bc9OShXZ0ZdwT11/ea
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9138

This driver open codes the cap chain manipulations. Instead use
vfio_info_add_capability() and the get_region_info_caps() op.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 samples/vfio-mdev/mbochs.c | 75 ++++++++++++--------------------------
 1 file changed, 23 insertions(+), 52 deletions(-)

diff --git a/samples/vfio-mdev/mbochs.c b/samples/vfio-mdev/mbochs.c
index 7f889b31fa2ce2..a4228a67014c2a 100644
--- a/samples/vfio-mdev/mbochs.c
+++ b/samples/vfio-mdev/mbochs.c
@@ -143,11 +143,6 @@ static struct mdev_parent mbochs_parent;
 static atomic_t mbochs_avail_mbytes;
 static const struct vfio_device_ops mbochs_dev_ops;
 
-struct vfio_region_info_ext {
-	struct vfio_region_info          base;
-	struct vfio_region_info_cap_type type;
-};
-
 struct mbochs_mode {
 	u32 drm_format;
 	u32 bytepp;
@@ -1033,10 +1028,12 @@ static int mbochs_dmabuf_export(struct mbochs_dmabuf *dmabuf)
 	return 0;
 }
 
-static int mbochs_get_region_info(struct mdev_state *mdev_state,
-				  struct vfio_region_info_ext *ext)
+static int mbochs_get_region_info(struct vfio_device *vdev,
+				  struct vfio_region_info *region_info,
+				  struct vfio_info_cap *caps)
 {
-	struct vfio_region_info *region_info = &ext->base;
+	struct mdev_state *mdev_state =
+		container_of(vdev, struct mdev_state, vdev);
 
 	if (region_info->index >= MBOCHS_NUM_REGIONS)
 		return -EINVAL;
@@ -1061,20 +1058,23 @@ static int mbochs_get_region_info(struct mdev_state *mdev_state,
 		region_info->flags  = (VFIO_REGION_INFO_FLAG_READ  |
 				       VFIO_REGION_INFO_FLAG_WRITE);
 		break;
-	case MBOCHS_EDID_REGION_INDEX:
-		ext->base.argsz = sizeof(*ext);
-		ext->base.offset = MBOCHS_EDID_OFFSET;
-		ext->base.size = MBOCHS_EDID_SIZE;
-		ext->base.flags = (VFIO_REGION_INFO_FLAG_READ  |
-				   VFIO_REGION_INFO_FLAG_WRITE |
-				   VFIO_REGION_INFO_FLAG_CAPS);
-		ext->base.cap_offset = offsetof(typeof(*ext), type);
-		ext->type.header.id = VFIO_REGION_INFO_CAP_TYPE;
-		ext->type.header.version = 1;
-		ext->type.header.next = 0;
-		ext->type.type = VFIO_REGION_TYPE_GFX;
-		ext->type.subtype = VFIO_REGION_SUBTYPE_GFX_EDID;
-		break;
+	case MBOCHS_EDID_REGION_INDEX: {
+		struct vfio_region_info_cap_type cap_type = {
+			.header.id = VFIO_REGION_INFO_CAP_TYPE,
+			.header.version = 1,
+			.type = VFIO_REGION_TYPE_GFX,
+			.subtype = VFIO_REGION_SUBTYPE_GFX_EDID,
+		};
+
+		region_info->offset = MBOCHS_EDID_OFFSET;
+		region_info->size = MBOCHS_EDID_SIZE;
+		region_info->flags = (VFIO_REGION_INFO_FLAG_READ |
+				      VFIO_REGION_INFO_FLAG_WRITE |
+				      VFIO_REGION_INFO_FLAG_CAPS);
+
+		return vfio_info_add_capability(caps, &cap_type.header,
+						sizeof(cap_type));
+	}
 	default:
 		region_info->size   = 0;
 		region_info->offset = 0;
@@ -1185,35 +1185,6 @@ static int mbochs_get_gfx_dmabuf(struct mdev_state *mdev_state, u32 id)
 	return dma_buf_fd(dmabuf->buf, 0);
 }
 
-static int mbochs_ioctl_get_region_info(struct vfio_device *vdev,
-					struct vfio_region_info __user *arg)
-{
-	struct mdev_state *mdev_state =
-		container_of(vdev, struct mdev_state, vdev);
-	struct vfio_region_info_ext info;
-	unsigned long minsz, outsz;
-	int ret;
-
-	minsz = offsetofend(typeof(info), base.offset);
-
-	if (copy_from_user(&info, arg, minsz))
-		return -EFAULT;
-
-	outsz = info.base.argsz;
-	if (outsz < minsz)
-		return -EINVAL;
-	if (outsz > sizeof(info))
-		return -EINVAL;
-
-	ret = mbochs_get_region_info(mdev_state, &info);
-	if (ret)
-		return ret;
-
-	if (copy_to_user(arg, &info, outsz))
-		return -EFAULT;
-	return 0;
-}
-
 static long mbochs_ioctl(struct vfio_device *vdev, unsigned int cmd,
 			 unsigned long arg)
 {
@@ -1381,7 +1352,7 @@ static const struct vfio_device_ops mbochs_dev_ops = {
 	.read = mbochs_read,
 	.write = mbochs_write,
 	.ioctl = mbochs_ioctl,
-	.get_region_info = mbochs_ioctl_get_region_info,
+	.get_region_info_caps = mbochs_get_region_info,
 	.mmap = mbochs_mmap,
 	.bind_iommufd	= vfio_iommufd_emulated_bind,
 	.unbind_iommufd	= vfio_iommufd_emulated_unbind,
-- 
2.43.0


