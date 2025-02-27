Return-Path: <kvm+bounces-39628-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EEB5EA48939
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 20:50:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8C3E0188D7BB
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 19:50:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3306F26F460;
	Thu, 27 Feb 2025 19:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="m+BFMpm6"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2056.outbound.protection.outlook.com [40.107.236.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD95A1E3DD7;
	Thu, 27 Feb 2025 19:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740685842; cv=fail; b=o6aihey2aLDUWV+dsgiGR91ikq86K8qkOqbktwOoO/QUWqLLH9xjAvVeLnt2uXe7rLF2eTgqz7Ksgdz+pVIVpsWZ6KMArnjFlYD0fPk3+jN0P+VLCoHYhMC6gZfsJQBcmQtmteyRaCMe1fwvgCBTLI8EpA2fLDIUK37BhZg6W7c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740685842; c=relaxed/simple;
	bh=s1YnAcMyft/Lj20qEepr2pBjljAMJqVpaN8uO1fxYv0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Sqm78h61SS4hVIgICWufTGYOkPLz12XTv+oFfRdCA5k9/oZ3mp+E1iz/6ptkZLm1clPxyUYFWn4/W3qBI53cOG7SOU9vjiJ8tDKnxeFvAsUh5d0bmirkFnnpGRPwhThk0CebsQaKp3MMG8zYM4oL3605yzhwSI7IxYpMWd0OcPg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=m+BFMpm6; arc=fail smtp.client-ip=40.107.236.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ek3uvL1hw5lIFcKIqDr6wjbn+0YU8LPK7isyCi/ltj0rRJZJ+4qNSq6eBaUxhPsbpsoSrpfK6fubPPlArhc170amI0vY3lH+po4L6FObdckilF/YVozXgSjXilyotG/OtaJqtmxAD7baHBly6YbhIwOiU8ZVsV3FkUefz3UxHXYSkbkz2hOxfDbrJBnVRzPA4H5ehgXtu4iWe2vud/ltbbF7N0MiC774lgyaRF1jYdG4Gsigg2qxJQiBk35mQw4y88gt3gyiglkLoIQZ2ZnBpIheB0BZL86a00VlvfEBSPYcLuLZlRXmrhutvOKqEebf4n+k90697no/y7JgfK+PUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dholVvtiggUzVnBaLTWESOSFn0evx4/OUbTefhPpaxs=;
 b=GhTYXfxBv6qFOcT09nO8fdwczt8BYoV8GsOcrGf9yZ5/vnldQNbo5BA74uSKGrCpSDzkBpM7XBNmMrrDt3K6oEuR1LlQAHbwabGkYPDAZlwp/BY7UxK1Znyx2zHBgHCTNx+6pEaBIsEFpVtDTXx8sIGfTRbG+dAtI41fK+T9H2sYZLjPlVsjQ0tTqQyH5Be442S8DEsTjoFBsEao0+X9nCwUnM1FJoPzspuUwnXwIN3PkVRYxA36M0QQo5Z4iMDlZoM382aTRd6vtq5y2UcRZDdZXsbNkpuW53/W1xkWhhrTKkB6XJKWAci+NrxUjzqKomn7ppfu9cW1ndpEaSh3TQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dholVvtiggUzVnBaLTWESOSFn0evx4/OUbTefhPpaxs=;
 b=m+BFMpm6sK8Qn+7MkuuYnTvrhQjgT0tbaS5SgAAnFV7kf8hpZ3yMYNGztTWdMwhZd9wMY9IxIMw48tZzJgUmMaQ8/WQTI4obDWfIwwQi2JzGjJWpnUR9HFtLA0qsmll5I1ywdZuoCfl7X27bYaKoUI01oTTd/r5VySw4VwqdsWfV7Dj7QwGBSE/3HnfnnlGdSxb0TggRvY6u5tRWkAd3hfQu4HviFpsFe4OhIOsJFpuDfnyxqaAGCa7nOwKSHeA9tDT04ODkUcsorB8lTCcD9QKK4ArUbydF8R5A670+sVWo+4oMHHKZ9wbg/rG8J1H8v6K48rthBtTeMrMW0rAM3w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MW6PR12MB8663.namprd12.prod.outlook.com (2603:10b6:303:240::9)
 by CY5PR12MB6480.namprd12.prod.outlook.com (2603:10b6:930:33::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.20; Thu, 27 Feb
 2025 19:50:37 +0000
Received: from MW6PR12MB8663.namprd12.prod.outlook.com
 ([fe80::594:5be3:34d:77f]) by MW6PR12MB8663.namprd12.prod.outlook.com
 ([fe80::594:5be3:34d:77f%2]) with mapi id 15.20.8489.018; Thu, 27 Feb 2025
 19:50:37 +0000
Date: Thu, 27 Feb 2025 15:50:36 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: robin.murphy@arm.com, joro@8bytes.org, will@kernel.org,
	alex.williamson@redhat.com, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v1 2/4] iommu: Add iommu_default_domain_free helper
Message-ID: <20250227195036.GK39591@nvidia.com>
References: <cover.1740600272.git.nicolinc@nvidia.com>
 <64511b5e5b2771e223799b92db40bee71e962b56.1740600272.git.nicolinc@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <64511b5e5b2771e223799b92db40bee71e962b56.1740600272.git.nicolinc@nvidia.com>
X-ClientProxiedBy: BL1PR13CA0121.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::6) To MW6PR12MB8663.namprd12.prod.outlook.com
 (2603:10b6:303:240::9)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW6PR12MB8663:EE_|CY5PR12MB6480:EE_
X-MS-Office365-Filtering-Correlation-Id: b80ddcc3-d604-4af1-a94a-08dd576801c6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?gK81KaNmovFTeV31pP/y/4PI+3HpUJUxOa0IZFbEe32SQGrLBsFB2Itn8le2?=
 =?us-ascii?Q?2BKbFtReD+1fRUL00yjTSbZJ1Wrv5CK0MthprDaAKCm4jhbMvPzijzvf0NmE?=
 =?us-ascii?Q?gQ8b3EZkplMAuWV5/uOqoSin2SS1AVOo8qEvA0TojwoGqdRJZd56UQCN2eiL?=
 =?us-ascii?Q?eLPC5SHIamqyVMJ2joqsyLu9GTiHq5TwHTvSJ+rvMoOJI0Yf8+KZiOHzhcsf?=
 =?us-ascii?Q?QMjc8UZSG6gbRciUwBLcGa9r2bFi4U6H/5ojsii+mlgY3IZm92/yJyBYhcfG?=
 =?us-ascii?Q?2tp9glqB8/yoJWGMNfrlb8fZjuDzICkvSEkje2X0bgsbtiS6CsqNOw8jiHhK?=
 =?us-ascii?Q?02neDl6euE6nIjB0lRdAbRIvkqmc2XhDDl+ul0NBxptjbCuvamFPuh6pVtdu?=
 =?us-ascii?Q?OBSrH1kSOwgJDdOl4Zg+aTv1V+CSkmSRSQABBoY2ukggFE2LMIAddx9bL9d6?=
 =?us-ascii?Q?Hin3B4njlDd+LsdoOypI9Bh6IaTvzj9JUuCj/wKTm/CmTzPH2YaesvO1ahxx?=
 =?us-ascii?Q?0bVxW+BjKQN1qp5c69cnfkM5JW2e6TZqZJchk6lyWkqXyNoWs7NKZXfoJjcV?=
 =?us-ascii?Q?SbIBudo2s9HZtN9gfv5qCusj3U65q5YYiRjGueWbVt77FllWpkIHETd6ydwV?=
 =?us-ascii?Q?6+lnALk7ztohsbswG/4SkiFlKOVQaZgV5Lh8CoHwFy/3pX867zvbhHf7Ely2?=
 =?us-ascii?Q?sY4AZ0TdJx0yE5snsWQYHkZc+8zT6Jmgr1n+B8V23bWJmeKyaowUct+gUuVI?=
 =?us-ascii?Q?FZ3MgtFaYfPgCaquVCY0NFOoNtZR3dRBga8R3d2XqEUUKw6KafaB+WKtcT8X?=
 =?us-ascii?Q?wJ3DKn4j8bzTJXT8N3GyGVodENYuNBfi85y3bKYfWjDzgbgcbib59WeD83lB?=
 =?us-ascii?Q?MtshE06CvMLVkwl5ZBemkPhv0EuNHg0WbU6ZctoyZPNlEJG0Bec3ds0wS2vH?=
 =?us-ascii?Q?2Y+62+LdxglDSNvQ2a8mr03WOH/KP23BhNTOLJQeRgafdUAU6JOj4IaCwtVa?=
 =?us-ascii?Q?7vjnlKkyycSOP04k8/aI2KebNxJO2yVqBrbIuSC52QbYXnY8iMSkB3C2yCsW?=
 =?us-ascii?Q?4bO7EVw001XAd4LqoscykcJsFAaUQ4YVxmGI/R/HSIshc2f8fQQ8tc8CrxJ2?=
 =?us-ascii?Q?heWu2Qpnv+IO8YC1n5r/BlkAe82XGYtxEBuqu2xit4uBWP1tpUrzfDzMF1dd?=
 =?us-ascii?Q?6ag4aecSo1SLMDb7P3QOX9Fw5A6y36gX4iI+Gi/Aq1xhuGkUcak/GTGmO894?=
 =?us-ascii?Q?faubS718BdXGamfT3QnOpNyOir4WP7IooDcu+EgTfXm1h7YWFZAAKf+Cdeoi?=
 =?us-ascii?Q?9w6ffijNpTeoDzfDqo8xb+arrBLHAQkDTm1PvrCXw1bNk+u2apIaIDvOCcrN?=
 =?us-ascii?Q?HG6PvPVe8sLIeKhSawnuvjA9BlY6?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW6PR12MB8663.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/vlwlB3V4RlWfi0EmE3W4hFEvB1Qs5O5KvAPUUvlAh7lXrSzVHh917LAPAC3?=
 =?us-ascii?Q?5ZlTPpJO2ABTe4pWPzfw540UtVACV5+IAwVCMZtp0GM2yM0ZSzQ0uSfhkOkY?=
 =?us-ascii?Q?Kf7v10b/B14NQXAYKT+Hy9kZN7gMc2TnkxEbokICXa+wLWyzU5qgyuFFT4FP?=
 =?us-ascii?Q?x1BTnieVQPE7nebESrUBef0dQtbh47Ul4xSylj4rv4DU0Co5R7xyvSDRoevf?=
 =?us-ascii?Q?p8nvyJ6Y4FPv1x/JZHBcX5rCWOABrhtdGF3DZwNccMZyujatFV0KEpjcd9B4?=
 =?us-ascii?Q?931WR2fYjnJgX96s5/gzPAsJl0t38YkMwQPsawI4IubLVdg68EAtLequaZR1?=
 =?us-ascii?Q?7fW+YAJOs71VDaUYsadbyIv94l29a0kg5XwmX/czbm9EgiWRV2wZCLUeC1pp?=
 =?us-ascii?Q?65vyg6nRZGGqBnOgdmWC/T+JeBQUyDAJPlBTyViERPmA00HwPtHE/JhR7y1T?=
 =?us-ascii?Q?D4GNTc7oMAgrqLnTWXzz6I6Ad536bvyS1JM844EggcfHerbI5APAZ/pIzz4a?=
 =?us-ascii?Q?aeMVM+wIA5ZOUxTjy9e2r7aOMO+lUxZv4llHsoRhcgctYXFDPYozIbSR1P5P?=
 =?us-ascii?Q?zolEsrQbjGnruQKlu0cLj4wVqANyN9z8xIT+oQ8KiY6d+P01KoEv/Ghn1G+N?=
 =?us-ascii?Q?fBPvcLxlXehxfjnIgxFh3MKzAzgv5zVgCYHf/HugPeXBB3s1zEZlmdndMChK?=
 =?us-ascii?Q?CV+aL+nOANlowcGneDIOzAio1VbRqALi3kuzH5ZOPhDxXjZwj6Ofog3hjtjt?=
 =?us-ascii?Q?V2DjEsadeGRp3ej3gCF/e7rU5XuAN/NLzbHz/ZVI256+KRixv/p42xIkBcsX?=
 =?us-ascii?Q?UI5RiJEksvE6j0NTv13y0LalnuJzY0gswz2SY2eAypqUo/G3TpluJN0zUvKx?=
 =?us-ascii?Q?Tj9B5lAzcXSK5CqYkVb6dh/G/XlxiCVkxCgnIlipkfGT6YL3IMR8V9WFu1dt?=
 =?us-ascii?Q?5IIPyQiLb6gb/NlEnHZ8nz260K1VIRuEhOl82PrEqnd3JnprTXRpiwt9bQAL?=
 =?us-ascii?Q?4CC0qaVjeetKhmVO+YhOVzClV+ZTPv6o9g60zdJMn/RnKQZDYuDaZ08/8BJz?=
 =?us-ascii?Q?m1qOIsE/ezhdYxbckTo3FOkfWmxU5368NnPMsIEdqh3HJbk04kVKltSpfJhx?=
 =?us-ascii?Q?2M0u5vit6x0xt4kW57gnBIozxNkAAtXGUIYnXH5pntdeqT5FiAEIQWJRVbhK?=
 =?us-ascii?Q?Wk9za7tfmqu4O5D+iWjrBp8lcqz63pwv9dJLAy4cD1JLJbK3jbOWudhjU/PG?=
 =?us-ascii?Q?KE+GLGMIdbLxtkE+X0HTyLmEd1iyAEBdrQnSjSWkwU238jSiktzitMky6kgz?=
 =?us-ascii?Q?kSZbrydcc4lPNQ3+lRNeMEv/HGQ1V6jgTlBx97DehVweSlGo2+8nfh7Zg9IA?=
 =?us-ascii?Q?FEYc3mR/P9ikiZUauKHyOgpz5PyPotnZT3YXWDj3XWSqzT7bB7JwRcv0F6dz?=
 =?us-ascii?Q?i7PhqSSLwiOcaufhdSoBeKPglcT6aA4PPK47rHcgdLVEfp6Sfyi95mZ9kgdm?=
 =?us-ascii?Q?0MJmwFQJzNL5D/LnqzLzs/58ttaYUNJkRknzB1GwCJE5WRL4chlaKhCiYEYP?=
 =?us-ascii?Q?z/8iVMz4BQPDEpzMCKSrKhO+3FuHf2LAq8n3zvu8?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b80ddcc3-d604-4af1-a94a-08dd576801c6
X-MS-Exchange-CrossTenant-AuthSource: MW6PR12MB8663.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2025 19:50:37.6588
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rqmVI+Mjwg9Xwrg5OmeI6SfmjpsrWg1ybnKLH/K4/rM1VgPnIrA+yoZ8fOWzcJh9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6480

On Wed, Feb 26, 2025 at 12:16:05PM -0800, Nicolin Chen wrote:
> The iommu_put_dma_cookie() will be moved out of iommu_domain_free(). For a
> default domain, iommu_put_dma_cookie() can be simply added to this helper.
> 
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> ---
>  drivers/iommu/iommu.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)

Let's try to do what Robin suggested and put a private_data_owner
value in the struct then this patch isn't used, we'd just do

      if (domain->private_data_owner == DMA)
	iommu_put_dma_cookie(domain);

Instead of this change and the similar VFIO change

Thanks,
Jason

