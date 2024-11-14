Return-Path: <kvm+bounces-31873-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0538D9C8FC7
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 17:30:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BA7EA282507
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 16:30:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEE7319259E;
	Thu, 14 Nov 2024 16:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="q4Ib3g2Y"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2081.outbound.protection.outlook.com [40.107.93.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8569F14A09A
	for <kvm@vger.kernel.org>; Thu, 14 Nov 2024 16:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731601705; cv=fail; b=cJk7k2anviE80IqRYF/EshoOOOURLL2VtiI54k3nKl8oUlp3ttRwM2DGRD1w/6GLujVhJCp3EK1d70uUFEOkrr3ZpAsJ8g7wL6+qhxf9XNBOnnHIeef2k5Kx40bP4rZ2+nosxEPjc/0cx9Jl5sIT+eZI1tq7BFhTiLDly2WPEEs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731601705; c=relaxed/simple;
	bh=O3L+rWmMfr+marYeMQ3ns/7TwEAY16l1QYUKvtFlj4U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=JDv7bGTw18VrXjYB/xOCWsANE/6+KkqEdIY5n2ZKz/V6/uPwyFW0eo8LCBjvMu7yFSaLM+EUMlJmqVHi7m860sm8hX12uzMkESLkJ81wS1ZuMJ+yEHPH3N4lfXwL+hI8LX2HigjW09kjFeAJGjA7BY04TQYKMIJIv86YSsWAr/I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=q4Ib3g2Y; arc=fail smtp.client-ip=40.107.93.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UAtcOaDoQYZ61MTPzT4vc20M3RjGz9un6aRleEiAPhO0MkBruegMyhcbMqqP/zi/W/ZNUiteNtfWkxC1oCD5yuBTphVeaSQ6+LSvT00abQNfnYt3/XyjnkIJbdcPrtCphzT7agK3JxTR/Rv3yldq5TTx3g/2C12rBU6Kbyt0d2QgASeRqnDPo5JDj1VhUIOLO+BS1kHTAnpZnDTNTJzmp4yvyT2d10Ppw3nC0sU+Qu9Cev4aaj7zub7IEBjpH6OUXVzGNxuFDxQdT1AgzE6Iyp238vBQvAo0R97SA64Wie+t3GbTT7oPecMcPRPepysvwou8jevtgWeAJ5tXrSWnQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3POW8gE6ImDhLT2o/xG41zenhqY3jKOm3FWT0R6EMvA=;
 b=d0c7ATNiJB+TNtEBhMez+bDIANYNQZZRxNQwF+6Sb6xIsujrpC9Dq8DU3ymNl7rJCuPtvY0t0Jtwx0eY4NkIXeO8OySFGXq7CZRJDGw5NjI0JgRG2zgQvcJrOzYKOn9T097rQNQuzdCKQkMhjwyFqUe1o7Spq05E96uA8JE4AHk5IUuoLuPud17lNWtI+/CAbzzhU7zSjKLykHGUM6GVt6MY61G+vRd0KAAs6nz1gX5L9BQ7t4Y8G7durirH05Ua7ipkgSg6ItcD+3YsHpHulcTykmg1Xy9DR1XSy4eZ3zjoe9XkogKlLpzEA7i0xN8IoNUw8a6Cbd9kDKoWT/V6DA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3POW8gE6ImDhLT2o/xG41zenhqY3jKOm3FWT0R6EMvA=;
 b=q4Ib3g2YqxlfSrhV/phYJlqeU1CTPmnRv4g/IBu22Fi0GIGk7LxJ5ai/8zPnW7obqi3rOFefQuC66RlO24RHJgbr2R8DmfZedAZ0hcHEZzQqNpHOoE0fnh0ugjdYtfKWtRYZ7HrfDPrbx2W5sQAuV61WntX62TCVjHMTaiKf7UitOTtOQGeVHYls6be9rEyyOqLOYkmA6TjIHrsAtehcPq+jqOAbuv5m50LtHEJcbTXT0kHV4sFIqLmqi+nyMDolChe4djjyjfiCecxsr/T5RlfR4DP1g/rdV6w4xHfDFdD5lZkPUbhgsFSUDhXYvgiOMNq1hSvjCUnWYB8rl6INwQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by IA1PR12MB8538.namprd12.prod.outlook.com (2603:10b6:208:455::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.18; Thu, 14 Nov
 2024 16:28:17 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8137.027; Thu, 14 Nov 2024
 16:28:17 +0000
Date: Thu, 14 Nov 2024 12:28:16 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Yishai Hadas <yishaih@nvidia.com>
Cc: alex.williamson@redhat.com, kvm@vger.kernel.org, kevin.tian@intel.com,
	joao.m.martins@oracle.com, leonro@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH vfio 2/2] vfio/mlx5: Fix unwind flows in
 mlx5vf_pci_save/resume_device_data()
Message-ID: <20241114162816.GR35230@nvidia.com>
References: <20241114095318.16556-1-yishaih@nvidia.com>
 <20241114095318.16556-3-yishaih@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241114095318.16556-3-yishaih@nvidia.com>
X-ClientProxiedBy: MN2PR07CA0012.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::22) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|IA1PR12MB8538:EE_
X-MS-Office365-Filtering-Correlation-Id: d9095ce6-d428-4234-81d8-08dd04c9588d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/5Dvjgwlv2vQoaxE8aGRd0meMBi6qlLpQRPJlkO/8+Y9pcvG+M6JyWPirSsZ?=
 =?us-ascii?Q?dLumNzDWK5s04ZFyqH9sTpArFrPUAM2ygRFdWy4AR57DbjWYNklbI1Zm8h8j?=
 =?us-ascii?Q?fGxU9olOKAlDYW75G5yS0bNWHQTwrLnryNBHhI72u1aygw9N24uTStQ3UfEm?=
 =?us-ascii?Q?al52CyIfgKcuPlP9uOSuLFKp49d3OgSkJ/DdYUgKte6b4bwp3E84mjlpBO10?=
 =?us-ascii?Q?cRNR8v4stlv2MljwC2EYC8f57eXVIlOg40vr8ydZ8XKC0EkJCo7Oz9anxxEs?=
 =?us-ascii?Q?TNzQfOKYSSo88kEoEKUUsYMVZzHkyu9EIo8zCkU6+bAzA7vTh0hMlVK2VWiE?=
 =?us-ascii?Q?pAyzp8mwyGUN0/IHr2e7XbBACgoZEa0xSG/GYY4WO/Pbo03WppimHCng1bjP?=
 =?us-ascii?Q?CEoweCRXheUnG3J1md3635VlJkw+vNJIDdDvoCxktac8gLGzdms1VGFtMhU9?=
 =?us-ascii?Q?VM3MIWC/Vx1qHF6xeu90z1fOUdEOicOJxcnVYDypjAIEmTYVT5T9jZDk+rp5?=
 =?us-ascii?Q?Pe2zlWMNshkWjFCyOm7i2DqhrnwKxGYYJHpoXyAfK2Y4u/y/2Ii0zJd1K5CM?=
 =?us-ascii?Q?tQIhiMGP1viH9nHFepZPwNa4X2YIm4Rqv1Qhb5T7JpRnjv0YMm1pLsT974eM?=
 =?us-ascii?Q?cy0yzvhhu8OE6O0xWE/olsza2EsPjNKUJqGtVxQczH1Ik8VuHJcMhyOSMUK4?=
 =?us-ascii?Q?qVpE4/yYn+8Lx24cGXytzCSwAk0ilnHz1wL9ueNi7kMnQq27Q4aE/fmulqrh?=
 =?us-ascii?Q?O9HfWfpwqYM6Jn3izYP3LCUV2ka2gscuPLPCLqa4lQZHV9x0dChz1B4hi9gn?=
 =?us-ascii?Q?Qj78inYOaKHzC2Fqo0OycvETFGugWbfc5d7Llu/uOK3KVn9K5MG4BvYUCdm5?=
 =?us-ascii?Q?XcmKMxEuMxO5nTaQgL+yHt8IWe6Dd3Jjk4KRhUn3aFSyKm19AWSt2tUzEEly?=
 =?us-ascii?Q?7FCbizce7mYBQvOx1o+cf63OEvq0K/KxDvA3zbf0fbmXSM9l9bjKFeNnpMUg?=
 =?us-ascii?Q?DO9E/peYqa8y5+qk5Bc2O5k/RvOYlUsJHBGRNiXWI9kDJr4FOGnmCQutCuQK?=
 =?us-ascii?Q?ErEEQvxAHIQUwtL2xfd2A0nBYr8GFtDNoRgE/d1h/3nclHhovbFuqtuzv+tC?=
 =?us-ascii?Q?I8Tw/5VLDLZKqPKupQ5W6/teUGyMPEixeLu9eaApiv7QpP1Tq6BaaGkSJG0c?=
 =?us-ascii?Q?ftO4snxB5UVYNA7qXuof6CK+1sGSirg5GOL5iJb87n0qiV4frxbDCpAH0Lui?=
 =?us-ascii?Q?1blgpKZNFSJfuWAcBJtQS9njQ22dm58RDEExzkpZZrTjtR7ktEO5uicyIRQR?=
 =?us-ascii?Q?fXI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?44t4OjwJVVB7Z3rayPDl36I+3kSw06J9eHpMYmE7bRPT1GDU/+2X0JdeMgfT?=
 =?us-ascii?Q?f9KsMacwCR/7qJlpvV3YezTqfCwSHt2YlCWh2hmRK+ebQyWEFNxSrX4CvUER?=
 =?us-ascii?Q?4uJ7h+TWgvcCOpN5eO1yOEY8YjlxzlM8gvJKuGS7mbZ8lxbn18yjntP6NN99?=
 =?us-ascii?Q?aiq3SBanmic3crvMAYlUo8+Gq+yN1N3jtqGdX+IJkbUqnA6AxbN+nZX3EMNx?=
 =?us-ascii?Q?C5WWB6pIUvYtMsrVfBXUnwj2DWdZRVvwLgiyW0WElGhiRSIqM/0XZajtygm2?=
 =?us-ascii?Q?EPKnyeMPgXju8ClxpqTfS0cLERnjV9GV5AHDd1wX4jCnTWQ92Vc6nZRcDrte?=
 =?us-ascii?Q?Jq0r7qG2JaX4Adz6con+1tvKk6a7BlLTAchSbMq/5t//g+o/kBz2CZVUUUsB?=
 =?us-ascii?Q?afjRZQDVzgNvGJ0wqYXBeldvpwhu++3OXs0xEzQh/pQU/jiRL0srl2A8Giav?=
 =?us-ascii?Q?1ZTma1BwIH1nMHxsVkVlOmaxM15r5rGEIBiJgKmtoA5OSTl8/S6dsZ7svvTP?=
 =?us-ascii?Q?uVwuoHkYRhBKu3byZXJuk8jYbysvuY3xWWsspM1mdnTuAkz6YbmlQ9dfDNm2?=
 =?us-ascii?Q?i2nrTtrdJF/SWAFUOTQC3+55dQWloYx2pSZcdKGFCIAI+o7FffPWKs71qN0v?=
 =?us-ascii?Q?fSRV6yT0te+GkY80TsK4IC9UNtq4AHFXxBFYuNhu4lmy9O9XlifUQ67LHJaQ?=
 =?us-ascii?Q?+PlVPPbVEwlNv5FOWCv8Tkgk9Xis0MDvJ3t6LKSsW1EeXLWLlNkb1jXyHheF?=
 =?us-ascii?Q?vj9YCzPiYbJx8HfPLWcoLdSi3kQ2uA6wWBvDhc5PaTjrauLDoeXdpDLm8z4D?=
 =?us-ascii?Q?8j1BlbMrDnYmEYtdanvuS2bsm2/qxOBY7skmHysFnZkh4Brtk3JGJXepMl35?=
 =?us-ascii?Q?1EiWF1sK6ZvSrovkLQYXZCnqmGbkSpehNE585TuMQrLCMIelhdIzj0LC7qd8?=
 =?us-ascii?Q?naaN4VjrJqb425u+xvYo6EgYRq16NFvg3E6UCUakj7HAeOIlfroyYru+ltRF?=
 =?us-ascii?Q?bLbjh1mY5eoRlrl1uRIfNuz0zTsCcR/7lPG0FWLw3/V7NewpLR2+nEh7RXHi?=
 =?us-ascii?Q?7IPy1bYQIGSbZ0fz4hNDYvrIjEID1fRLsFIpV4Ns+LixvBBGW8VdxNyfPv8B?=
 =?us-ascii?Q?oAnjWuDBKVAjDf87h6VPurxZtfYww07NSU+EDXXApW6E58bnurYZFSbjD8V3?=
 =?us-ascii?Q?1MDDkUQcCLI52IqZsMDjtmVO2P/1RryBLaGLyKwKsA4cJRS2v7eZPG5r8Kmr?=
 =?us-ascii?Q?IINK4NNhG2ixzVJ+0jaOlGHE3C2iuSNFz/FN+U7hLee9xAApbfCpkb2x9uuC?=
 =?us-ascii?Q?8dN1Igica8zUbvWUub4+tZ9YXKkXRZseiA9cG4bhp2VrOx3Nde5QSDItVM4P?=
 =?us-ascii?Q?9THrjkXMxPXlL/wcdYgbe3TdO9m9rt0Xl68SkuHi9I29e/8WTcLtS8Pea9ju?=
 =?us-ascii?Q?hls7gR/5LCMSiR/xPEjHB2SCSBzQqyipaJ+UdJuS6rfyNKwXNwUZ8mRQKKjE?=
 =?us-ascii?Q?Mn4AY0Nvy9DiuUr7ZSF2p53eSCPOkicsyDa9Wtm2FePO7XzqIXQrHYEYCAf7?=
 =?us-ascii?Q?Hctr6nrQfhKnnXUsISFPKvn19whe4cE4xCSOmc/9?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9095ce6-d428-4234-81d8-08dd04c9588d
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2024 16:28:17.8548
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l+B37tJ70OPBqd+cuJUEpBGew3lWX0ENvwYY0ey18cWwPDcK5B1tBDM3UbMGfn3P
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8538

On Thu, Nov 14, 2024 at 11:53:18AM +0200, Yishai Hadas wrote:
> Fix unwind flows in mlx5vf_pci_save_device_data() and
> mlx5vf_pci_resume_device_data() to avoid freeing the migf pointer at the
> 'end' label, as this will be handled by fput(migf->filp) through
> mlx5vf_release_file().
> 
> To ensure mlx5vf_release_file() functions correctly, move the
> initialization of migf fields (such as migf->lock) to occur before any
> potential unwind flow, as these fields may be accessed within
> mlx5vf_release_file().
> 
> Fixes: 9945a67ea4b3 ("vfio/mlx5: Refactor PD usage")
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> ---
>  drivers/vfio/pci/mlx5/main.c | 35 +++++++++++++++++------------------
>  1 file changed, 17 insertions(+), 18 deletions(-)

Tricky

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason

