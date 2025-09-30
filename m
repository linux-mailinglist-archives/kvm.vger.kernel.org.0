Return-Path: <kvm+bounces-59214-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C1F14BAE45C
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 20:04:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 53B831883DEC
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 18:05:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23B1D26FA60;
	Tue, 30 Sep 2025 18:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="OyX3g3G+"
X-Original-To: kvm@vger.kernel.org
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013023.outbound.protection.outlook.com [40.93.201.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA2FA26B759;
	Tue, 30 Sep 2025 18:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.23
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759255482; cv=fail; b=oqXnA2yjQTjZDsrSIWAYCAoXpMa3juMcMD99RXpml1hHWjV/7rEnYHvd7DkkHcq3oNDEH7JdTzIu7VH14wv2wf2Ij4kyCbdfzgmxtRJYclQAipJpxkikL2wxl0R54vdPFDlRKqt1MUA5cB6sXpB4wrg1nXGuOwqeMvOPTifajDQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759255482; c=relaxed/simple;
	bh=W+NuUKN+XMMQ/PNJ3nlefIjisN4bYqDpSf0QpFVHbIg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=UHBBZQVdCydWFwXShkF5qJiCxJqSdt3JuwWaz5IHYUMUP8hmwDWDRGFZhFA6Jg29ljrltzS+474e4s4BEr+3RNvt9SIGRQ+LhKu9Q9K7RbOVWjdtjPKzHHer4OGk+x444Jo2iEyvioUg3BOeClFebXK6RDBstiQsLvcqjm44beI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=OyX3g3G+; arc=fail smtp.client-ip=40.93.201.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Jug1ArO0CQ6HutZthr38LjNIFNhQ54f/5DpjEVvKYWWcKr/fiLG6wbHCsBPJf5wgK4yg2BrOJvvO4vBOQzYNsEvJYGjB3saVXYjetYOrHoNWSBl+SBCdDu1No00FOZClSia1emymFWa7P/bU10fn2CgU80e86v//qmdDQ8d+hJP5nHsb5DeKq+ALg3UUrlGopgKT+9PuYrauiDgkS74lpBYOaKYwCV3lHuGy0rc9VuWnhscBH9AvIASGjkW76qcl1wLeC3bmjNkbX9PcA/1W1EYQCXmhNV5f7gsbtZw7ImsOhNdU3YpETAgSSuO2CKBECCRqMkg+n/myQYJWPn4Nbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DRborw5V+5sPkrv12VBxiU/Je0fts6K9uJXD57mjqw0=;
 b=DPTPfdQkPbRqIZJTkw6YYn752tEhF4b1+1nuhNuHazjdTAVV2lXka/drMMBdQfSBn5Om0eYfwBv8shp9c4MGP80/0pJDrllKewjHHuD8jablCwt0/i9Aj0S4GCmk3b6m0gX6mjdZetmO1iK1DQ0XWi2XDKoMbk4RjSXg6PtUG+hLCNciAu0OBb6FVKwGasvTZeSckE/NDi8p8Z1Frs/yRR+SM7nVNnDnnv9W0/DU6TzDvxIGtTIq5+q5sTGLiGMbSEhV3JVaVRJvuyed4v4qmiCk04+sp0OVhFHSWUjAJI85wg5xaz3ROig7/g7YqbRuGlFQsmaN7qK9uIgALM7khg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DRborw5V+5sPkrv12VBxiU/Je0fts6K9uJXD57mjqw0=;
 b=OyX3g3G+aY8E2fIN+ftroggmAp/zuhf4uPB6EFdsdTa9bLZl4HvulJhCXIqR5leb7ci3jEbG1mhRi/tmCsOQbLRsrkPRnHd7awR8YJ90Qkmpp3tAgCAx5V810Hhr1oFKBT0byuVwTgT+xCB2r5pftTC/n/n2k1rLW4pIq6V6D5t43yO/GVID8cGb/pKCaiG0WZSDpuqsbmUCb4k6xp5HvJXZxBXm5DWcfNIdHs6XGvNjqiFoDmtQRFtgFOEjqM33H+KjQRH/BMRiP1o7dGaIa1Z+9uvy6HYSxAKuAevx57HzXlTZ3783NcVcS/DAEyZbp/LehmgRX7DxsjbPYTZXNA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by BL1PR12MB5924.namprd12.prod.outlook.com (2603:10b6:208:39b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.17; Tue, 30 Sep
 2025 18:04:36 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9160.014; Tue, 30 Sep 2025
 18:04:35 +0000
Date: Tue, 30 Sep 2025 15:04:34 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Shameer Kolothum <skolothumtho@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	Jens Axboe <axboe@kernel.dk>, Joerg Roedel <joro@8bytes.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	Logan Gunthorpe <logang@deltatee.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH v4 10/10] vfio/pci: Add dma-buf export support for MMIO
 regions
Message-ID: <20250930180434.GK2942991@nvidia.com>
References: <cover.1759070796.git.leon@kernel.org>
 <53f3ea1947919a5e657b4f83e74ca53aa45814d4.1759070796.git.leon@kernel.org>
 <20250929151749.2007b192.alex.williamson@redhat.com>
 <20250930090048.GG324804@unreal>
 <CH3PR12MB754801DC65227CC39A3CB1F3AB1AA@CH3PR12MB7548.namprd12.prod.outlook.com>
 <20250930143408.GI2942991@nvidia.com>
 <20250930105247.1935b553.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250930105247.1935b553.alex.williamson@redhat.com>
X-ClientProxiedBy: SJ0PR03CA0045.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::20) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|BL1PR12MB5924:EE_
X-MS-Office365-Filtering-Correlation-Id: d52a0017-4e68-4215-af83-08de004bd0aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?E3SK2j+3tbuJU/AkKlswzOcFqjySaVCIkhNRkbHIiu/k+iZvrMi39stQaa06?=
 =?us-ascii?Q?dSp/iGI6Ft3khh+PP9atLbqALZUUikd4rYbXTCSaodoidAX7vhl6CCQoQwtR?=
 =?us-ascii?Q?v7+pR59XSbKWR/Cs0FcuZvz+Ll8FJdvFXGmdXOLeWLRXl6raMZHgDaT8c/Ok?=
 =?us-ascii?Q?7OpM1hthoHg/aVG9q4qichsWZ9W0TNEQuy0ve6NtlJGVq8SU8XxniC2tdRmF?=
 =?us-ascii?Q?MQhdCvlL0+yCPkTlZNhnv1mO7KzJEwsy15t5LQv32WulqA0yEcjNIiBhvl1p?=
 =?us-ascii?Q?IFw2B5Z6bb4U98zCH3zEGrmAAdK9EUg1bxJEgtZJKqRjOcXzTTJaxLwH5rx2?=
 =?us-ascii?Q?0R1R/uEyrjyrTWhT8nyeF7YXeDuMz7tpCyUZivnI28u0wtdwWyhyi9gAlqmg?=
 =?us-ascii?Q?aMn31LNbKyw0DqOd1NTHd8K5bbbyp/pR7Ovi6yzQyj3wiHd75DBhvjVD/U+U?=
 =?us-ascii?Q?FDP2NLTNBL6TZFXYTQU7pr2b7w2BUI91tyyRMM8RsjPHTZo5WCxlGyM7uQiL?=
 =?us-ascii?Q?QFXt97yzs2oUg4wqqmXv0fmTxd9pKd6uRpuVB9+IN8t/NFryEdxdUoWtBRwd?=
 =?us-ascii?Q?wCS6eKVd2qQUyN5THKbZ4h5BHceFH2ZWDm+b0Fbw7bn9ywcc36EJ27loPiul?=
 =?us-ascii?Q?5dVA3TLPlLRwkTINIzHbkmsbtixUqLpdKsELEEMGZtQyJ/f7u9tGI0QRUyHy?=
 =?us-ascii?Q?MPAwU4GpBUr0zJbhAqeZHwEXHloYllsXTSU33yGVL6Nhwt1vVCDNgjIITiDl?=
 =?us-ascii?Q?2oDdAtfm8uxLP3oDpwImSQsHpEKEJ1unhSIVktVx3DRuPZHI66AOhn+/6A4v?=
 =?us-ascii?Q?/t5Z0wGsSNmV1t/N9QjlJHsLK5OX0tUffCIvNTV7VU4PBFh1H7XeBSnyIchB?=
 =?us-ascii?Q?CrT98s56ej8n+lLWa1e792L6e8DV7kZbaFIrY7HJuZ5OrWMqLJ+6BMS38t4I?=
 =?us-ascii?Q?sna5gkA22MC6ezsnuB3sllo6EPwKVSl599d+eRM8K1A615QuFNRfOmQvuU6k?=
 =?us-ascii?Q?B3V2vM2BkcXariqq4pQoMCWVIhdKsp6Lf2F4tUkU4Sq9/FSIsysYhsA3ocWX?=
 =?us-ascii?Q?I4tIaNr7UwkzbDupWSFdBPJFPgk1J9xv/mmG3Ey59uqFCFWC/VimkpV7r9jX?=
 =?us-ascii?Q?83xtjrNO2GdLuSeOmf4x1gAT5+Z+1P61jSu6CbpeMrf1GMBmxltk452BMJr7?=
 =?us-ascii?Q?Nbz0B7MegpMeNW52Da0yJ6neg//9NEZMRY2CP2BDKv4n7x0T7ZZP4f7C15EK?=
 =?us-ascii?Q?hzgOm3sjX6jd2Db1YPFVTNYc5+ojIjy7jT48Ow1iG36lq8eBSokA85GNexRl?=
 =?us-ascii?Q?vc+50eprgwQD9mEnuiZbpgrdsI1tZ3nRUaMOKRjdZ8GrA4tzHoiHmZ4v4tpY?=
 =?us-ascii?Q?ch7LgcGV6NoO9h4tLTehSCALwcN6ePzMHJq+smpLvipn1aqjAxVP92uEcJxz?=
 =?us-ascii?Q?EPDmJA0evJvj2UoL5WwX+/NOqQO0O7VH?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?LXBO/duRDt96Rw04K2RNJO2YLZpmtHvZaP9kROxOXtN1SdC3wBQfzw9Flr0D?=
 =?us-ascii?Q?28l2hgcxTeFj71l8T6tsVlCol7eNWusyzhOqC2Q5/cVHosyRA2BnveYJGawZ?=
 =?us-ascii?Q?oUjuVxEyDCM2AK4LkX1/mKHrPzw+SfFwQtAnTkNJU1jD4sEAfHFdyCMLxj+/?=
 =?us-ascii?Q?lj2aAnVkhqm8cd57c7gukEOYMHJqUAW+PtUg6Mu6/oSv9jqU2TFgvgZMfnPd?=
 =?us-ascii?Q?7LkXBzPu4h6XUJsm3i0B64MCMRrENSM0MR5xvDUPqkt4KfOQoog/4QzlxZJn?=
 =?us-ascii?Q?o4Hb/sG96ZAt8qoYuuBDJNZoTA3MkSF9uQYrnAKWK+hn234iEwtGnY6FvyF9?=
 =?us-ascii?Q?q2jkDSnUdG2qgUWG4GQG5EHVvzkhxa73Dh/lgDu/KM+ug1y0xlYkEMHFUGpJ?=
 =?us-ascii?Q?to81YGQQS68RluMKKJ+MIGTv0swaZchGoe+P3N9dHzAODRLHyWjTsx6H8yZr?=
 =?us-ascii?Q?7FFtyTEeE/pCuqYaBnqxKe8zKlebCpV1s933dqzavRw6quVAh0edWJibC/so?=
 =?us-ascii?Q?E6/rhXHLtI/IErImH2+bqwWkDoMq8IwoCCFG5KSM+B5+Yc06AL3HgGuc5Wta?=
 =?us-ascii?Q?0OkPpbAOAn/NZig1f2oMg3pkDenrxmyRVxKbeJns/3y2736zsAoPxqlVoj44?=
 =?us-ascii?Q?f39LvSGvLD4a/SAZm+uDuosecBUV034SFPvhs7vYhX0OUeUszz/Y8pUdDwqX?=
 =?us-ascii?Q?w7+vt0cNF4pKu3Xog08R15gljmJjAJNQVut+OOgKWw6VDIdVcPpeCFY7bAPn?=
 =?us-ascii?Q?sgDniD5yg1y6sLE8Qh3jCNEWwgRzzf6b1eP9v5nlP/pLgE8HtxflH8I1eZ9T?=
 =?us-ascii?Q?DHhDXNtinAMFdpj0EX1IWXNPfod+lImTPQmNiTmE0htAmJxxHXtDu76qiU7w?=
 =?us-ascii?Q?+yGB5w1yImYEGKhQRznn9MYuaidSJx2bN2430I38wB0QD2V3QdLGEPlNe/xm?=
 =?us-ascii?Q?chaviLtIlt30fZYYDKEfVGN2pAlJ3bfAxdlI4hdvnbVdGFela2Bipg7YppGW?=
 =?us-ascii?Q?QP9Z6NVCDw5DePAXC7Mj+YSsGuznO1mGguJdXR4l3KRIy5NqPNBNzKjNSFiq?=
 =?us-ascii?Q?TnvyJj0YT5gcpyIJ7s8VXjCSNVEieyXy84ffIDowcWcEEQpwYBVOHFUwfrVk?=
 =?us-ascii?Q?qwKQ8Zt3vK5//kwGuoZz5NBqBzsQYD2eIEQLriPBfnOPRvEjMqjoSJL9Axsf?=
 =?us-ascii?Q?0RjXIz4fNWCsTn2Kv1JbyX8GHZgLz3rs9uBBE3pMUwT7l1PBIENtj6cR9vbV?=
 =?us-ascii?Q?1fJeRguCMKm4YWXdauigM6dE/XSqBnTdS0SzmOWUf5688EDlJ3D3ApaQc34b?=
 =?us-ascii?Q?uHk4LSwlTL/71JHRRnr5JU4JbB40g2x7BqpHK6TAHSVGch5hgdZPQzekSiRP?=
 =?us-ascii?Q?F4jS5oA3fVLcOBUKfCrl3VLYLJF1bRA59iZF1xvJR7GLRE4F/viDkQISF4re?=
 =?us-ascii?Q?rPL0qPYKcvvxNY28Y6q0q1NV8X7I/VfKBXIJBou9Qxuqox5/7cuWmtwdGLwR?=
 =?us-ascii?Q?bHweoBeYRAJdylUw8OgfjrowchtZwQBrRbVqbp01R55k98E0Jd9ajk6FRpIG?=
 =?us-ascii?Q?GtOysy6PYBHdVRxrrZLU8zpDJDDi7oy0Hm4DZLTS?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d52a0017-4e68-4215-af83-08de004bd0aa
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2025 18:04:35.8337
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z+7KBoYOnRK481ERDsAxSPKzEf1NezugLxYADTgrlxGDv46WZtTEWJCTmuqlcNtu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5924

On Tue, Sep 30, 2025 at 10:52:47AM -0600, Alex Williamson wrote:
> On Tue, 30 Sep 2025 11:34:08 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Tue, Sep 30, 2025 at 12:50:47PM +0000, Shameer Kolothum wrote:
> > 
> > > This is where hisi_acc reports a different BAR size as it tries to hide
> > > the migration control region from Guest access.  
> > 
> > I think for now we should disable DMABUF for any PCI driver that
> > implements a VFIO_DEVICE_GET_REGION_INFO
> > 
> > For a while I've wanted to further reduce the use of the ioctl
> > multiplexer, so maybe this series:
> > 
> > https://github.com/jgunthorpe/linux/commits/vfio_get_region_info_op/
> > 
> > And then the dmabuf code can check if the ops are set to the generic
> > or not and disable itself automatically.
> > 
> > Otherwise perhaps route the dmabuf through an op and deliberately omit
> > it (with a comment!) from hisi, virtio, nvgrace.
> > 
> > We need to route it through an op anyhow as those three drivers will
> > probably eventually want to implement their own version.
> 
> Can't we basically achieve the same by testing the ioctl is
> vfio_pci_core_ioctl? 

Could work to start! That's a good idea, then we don't have
dependencies.

> Your proposal would have better granularity, but

Yes, that was my thinking

> we'd probably want an ops callback that we can use without a userspace
> buffer to get the advertised region size if we ever want to support a
> device that both modifies the size of the region relative to the BAR
> and supports p2p.

Small steps..

I added some more commits that remove the userspace buffer and all the
duplicated code too.

Jason

