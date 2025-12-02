Return-Path: <kvm+bounces-65165-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 082D0C9C77F
	for <lists+kvm@lfdr.de>; Tue, 02 Dec 2025 18:51:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3E9E53A6D55
	for <lists+kvm@lfdr.de>; Tue,  2 Dec 2025 17:50:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6550A2C3247;
	Tue,  2 Dec 2025 17:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="DDPnsCEH"
X-Original-To: kvm@vger.kernel.org
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010040.outbound.protection.outlook.com [52.101.46.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB4D92BF3E2;
	Tue,  2 Dec 2025 17:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764697852; cv=fail; b=GLCjsfk1nXJd7wZB5SkOjk7UcVLPCI8vmvdwScgWuMPmnP3r0BxDbUQ32yxfOAVJBcCG6WLa4klmMnQkMJu5f5m63W14GcHZrJb1CUi6ETCsBnSnIIzDuQ5e0HatvzOEm1yJktUhCkxjiyUTVB6qbaXgmTfze+FiPBRoq3qdN0k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764697852; c=relaxed/simple;
	bh=L6kS1tHA0Si+j/XF3POdvmsG2SEtxUq80CU8No/59uw=;
	h=Date:From:To:Cc:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=QPUaXWxY8IqAc0dULACcbMge/uCxwM7nqnglcwR/+X2Bu7R0KOyBPiB7aABW6ld7/M+1onIxE91y33XPkP/uQuigTRqilc4mPeBW56MYYljb1zRo4g70BbsC8b4DboGQMEMygHFinbrHRwIaaselDtxfHe/+lQqYTu8lXbR8s3U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=DDPnsCEH; arc=fail smtp.client-ip=52.101.46.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gThxdGzRP/RSv1uH8bE8ZOp+BQfvSVRzJ6AsGspW7fk+07GLvGdHQcOzzbIWht6KHTG+zx9+FcfIpzuomTKlwVhIwjWHpdDPPOMjUEiesme9aOW4YaD5eo28VZ+IfiCzkVc1dRqz/wFiuTjERftKs2o4Ywc/SIjwGinRwUpy3qR4aU0NMmMDo+JRzVsJ8ZI30WI0enREIoBzQnpY8gr6OQ3Z53Vs2a5t8aCt2GV0ZJgtgubwDXK/RyREHFLjzn7dKLw6iGbjQVRMYZABjiNQIf6AORyT2pGfi8rqTKPPviaCzu2DeA770SxVrV+yX0v88AvdwfV1CLjdRaKARsx3nA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NXOERekjsu/x8gpnR5VSYv/tOaV44vNfT32/z8lE5AE=;
 b=fc4c4W/EqNMDRPRsBMVaNpCxjyLlLgygKbyNyadX6tDDGbyOsxCE6dgQ9M4FcVwgq5RBUJTYkZNaaeG7nYCp1ikeH6kNOKRRk8YMKzSs3AViHyZ9V0Vb5c3GIzmc70jw7UbxZChHeGiRdcYyMjNda0NdYjkBLWbMMeZPj5eaki8CtyNK4O/1xDb6H06mihAsgu1cOT438JETUhOzSa3uy+at38KUkRsh15FHUf3R6dO7iK7Jo/+0V893sJIJSzjcsG5Xesi/NC+UGI8uxOPun7MoXTW+M6qtlQ6sRy7qYbDV1SaGfMr6woOvXh7oO0ibA/oPeUPP+dWJyhn/PCzH/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NXOERekjsu/x8gpnR5VSYv/tOaV44vNfT32/z8lE5AE=;
 b=DDPnsCEHmRI1xuCWzvW/L/I1n6C4qXEFXtP7IGF/c9Hg+rkPrXk0hwDW+B+DVI+0TO9CE4TxLJKsJUjyr1CufgITKjE2AdELcvY5QdbSrrd+TT13QCd89XqWDiT6nQtrHshv9mqgOEHCtGnZio5dkll6G4gK2kyTYJ8iNREvXL59HZWtyPkuh8L7F13yo4eKJ8PGlfsgZdhGIXdURVoDw4sNDDTlY/vWxYZH1S5k5w7RBUAQsLhOUZn6JNimUIHWpElR4IUVsNTIx0rxKpUB/ynamDGvOP+nf9s6U8nkMp8K6Wr2KIzD7opCCubwfEq9hLXsUlhdSnIjKk1n2j2DOw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB3613.namprd12.prod.outlook.com (2603:10b6:208:c1::17)
 by PH8PR12MB6914.namprd12.prod.outlook.com (2603:10b6:510:1cb::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.9; Tue, 2 Dec
 2025 17:50:47 +0000
Received: from MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b]) by MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b%4]) with mapi id 15.20.9366.012; Tue, 2 Dec 2025
 17:50:47 +0000
Date: Tue, 2 Dec 2025 13:50:46 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: iommu@lists.linux.dev, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Kevin Tian <kevin.tian@intel.com>
Subject: [GIT PULL] Please pull IOMMUFD subsystem changes
Message-ID: <20251202175046.GA1155873@nvidia.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="4QfGn+MFxi24Vn7R"
Content-Disposition: inline
X-ClientProxiedBy: BN8PR04CA0045.namprd04.prod.outlook.com
 (2603:10b6:408:d4::19) To MN2PR12MB3613.namprd12.prod.outlook.com
 (2603:10b6:208:c1::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB3613:EE_|PH8PR12MB6914:EE_
X-MS-Office365-Filtering-Correlation-Id: 90b044e5-5713-4674-11db-08de31cb52c6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?w4FGpsmXGfR3u/lTsOx8NT7zhe2oWEOTilfVr1vzi/FcHxI9NTDO7m6woTXF?=
 =?us-ascii?Q?chpo6G0vTU8cMXvsUo87Y1kiJX3wyryG9tOKyAcTQ6hpIdR6YsmglLQCAetf?=
 =?us-ascii?Q?+NcGN0TllTtq5TV9sp5ohW1fwnrgUdeTRVXzpBmmAKA6cSLU/kF5sOxwsKMe?=
 =?us-ascii?Q?CBNJUyE5tu0I3stGy9TdJgiQq4AcCCFaQ9yE3LrdYWzMMzNdslhkp5D6TZwr?=
 =?us-ascii?Q?q2ELz+H2Ct9MGsODWbzgWWCTiqoHj9GJELorcaaXGRmwD+as1TGgtxbuu0Nm?=
 =?us-ascii?Q?2xNgjdh9YCqqDA0e9vIAQ0fRne7b9TqIa9XgoO1eEtLlkrCuTCS5VsP+8xFV?=
 =?us-ascii?Q?Rdrpyhr04XJK5Yg94M6qQ/LGGjTG1NwtFrJ61ABT4ySlmMy7Hd/ZgjyGJZ5y?=
 =?us-ascii?Q?eYiiAdOGb450ENK+mmGgld+L2RU21lREa5nkawBjmvHlFHF8YqSOF+gr30Ml?=
 =?us-ascii?Q?9T3DH1hjwzWlUf7P24x8ezpvDXCz9yb5HydlTLC/NwfuiN0EpdQZAgNwXgiF?=
 =?us-ascii?Q?d83et5p+VQ/41JawgDLMVnBCR7sHOs4to0/7WTMi/xDHZ3ZeeUhjzltutEW/?=
 =?us-ascii?Q?p9vYrfFtcMLWncXI+Bjo67/EBn1Ctn3h6SPDq6GGeWe2atNzd7WLxVHobDri?=
 =?us-ascii?Q?oOe4fzTxcnnar+cREuopbDxvuY/3cDLEZ6qvpzFCrY4UASsW3Jh5KZ7pYhOH?=
 =?us-ascii?Q?KEfeEuFm88j5vgXU4qcqmt4DLvETbhwUqPTW883teWKUqqCRIHAZZuok8/Ot?=
 =?us-ascii?Q?tVBx5R7/vmvKyAH18kVYwrwtzIR5Fqn+Tzkoi/WOrb6HqcPsezlP9qLCFTZ5?=
 =?us-ascii?Q?YuMLFBkKAOvy8ZoKChaTjHfrdFKNrAzlNiYg8eRMKNLwstAMxLrI8O3uNV1D?=
 =?us-ascii?Q?aJPXEtIat7rOxy6XhApk3QVxaEYldq+WVNlc1JcphBOvS6f/qKYMfX9ons/7?=
 =?us-ascii?Q?heC+fzNiCpuSnpCMuJAhZTDm2B7h01SJrI2y+r3TFVVhm390cvfUWTz6Bq3O?=
 =?us-ascii?Q?cGAFUF9dyCH09ovwQwy6YEYn25tuK2bi9Lyhym7qGMg4ieqE6zEBQMpycEXG?=
 =?us-ascii?Q?HkoVa5jFMDNGTApgZFHmuENSNdnDqpTOw18SIzEEmwt2X39NVLcOeV1GxkDH?=
 =?us-ascii?Q?ordUg2G/9L1UKtn/wdCCPb5OjTahMtBVaghJlM2PQ+ef1favilzbrP5x6PxG?=
 =?us-ascii?Q?Mw+qKUwOjDdACKjlpVrmYLiIn/P8lrGQ+8gDYFeYJyIgFFiceQ1ZLzSHqGFl?=
 =?us-ascii?Q?GTXQHynQ/oXz3saFtpi/g8T3WQ47SfTCZAyQK+b4RqGNPIMt0WVhkHfyBe5a?=
 =?us-ascii?Q?UuxCGUQh4hc/cz2gx8Pa075dLoWVgJ1Vfi9ZEH11NruOBOnv9G/vekG9EN3z?=
 =?us-ascii?Q?wDaJRF8kN6bw9PLp5YnDoA0lnNC+/ooT3FyxrVMxBw9eAkrdGCMyIGOdQ02c?=
 =?us-ascii?Q?7pqL5jVtQOcgMpPIzNPRnwUH9ECWvn2nwL4x5vb858oxwZnJi2YAPA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3613.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Ehz2MtPBe/LPfsVPS2TZsicMvWEBmxY89wEyh0RvqULn+4TCOZYkvIyDazGp?=
 =?us-ascii?Q?xZWvqQAl16K+KfU/CxRtsP7jDtSZxD8E2QZjndJq8w18yFDnJYsMt30ik/dc?=
 =?us-ascii?Q?EvibaFTrLAusdNfPKaK8WjEBmXsT1zBlmvP5GpDhL3QtJz6HNqWSjpYX7ZJk?=
 =?us-ascii?Q?6KlCTIo7k1U2l7ZzAlcUPefWrsA/G1chLJbkbanJBtsE16YycIh6IhugAj86?=
 =?us-ascii?Q?oIGPqeskJB9ZtxYMizNBl9T3f4joapWNNgllvpR8/tOV93XoBuMnbBIOISwG?=
 =?us-ascii?Q?suFXxNNYe77/7Se09rphUtKwQPwP3B8gos4p1vJLuot4HRWiBgcwfIJWo87A?=
 =?us-ascii?Q?umsov/UGmfSA2d/ioG6ewAt+4xkgZkKhTv7wqe6xdjKlgiDt6h6mtZx44AUi?=
 =?us-ascii?Q?sR07S9CzbjK5cwiXGJc7AVNq/eeajaDbZNvsjzaUa+bl33F8qLO4Kvxl8CpL?=
 =?us-ascii?Q?o3wdiZbresSEj9GKJGtX4NqfP4GDj5/R5RO0PgHOzwFKYm8FjY/682r4N58M?=
 =?us-ascii?Q?L3PiiImKkVqbBzdg/qo8mP7J/mLwgyXxg5/qPA1nSUdDmwU58Hx+ZX2tN4vg?=
 =?us-ascii?Q?WnzZ7AdLIfkPphvo23JLxiuoRD8hLrdMHp+tSLgKp75bby94i2J5pe/QUduB?=
 =?us-ascii?Q?jWZhGsFYlgQjZlonQlDuILZWf5AkaNIbZw98WN4rjFWamiWQi5mSFRN+TRLA?=
 =?us-ascii?Q?30kAnz0lmwztEYT8Ut197fpf9Es/z8QNo1Dli1fagcvYV0nf7n9Gf4OH2W0G?=
 =?us-ascii?Q?CQQ6vKAfpPuX6vMnmDrZRtVEdNnwKlJxiZZCkZGHggGKXBukBfsnfDYpVI3D?=
 =?us-ascii?Q?3hug7FKqUeuL/lhIvVlxv769iz20dl0yCwMoAaJZS2jIYDK7grjXA1R1wlMy?=
 =?us-ascii?Q?7FAdHu+CeU+eay4v09RH/JFsPX9Q+v3lZD/0x5OsM0MFNa7+jvNIAOdPQQ2t?=
 =?us-ascii?Q?EZd5Bv7SWYNiifAP7Xy4mZOj8kdJ66hPQRyJNfX3YtLGIfDgLsFUmtKgjN+5?=
 =?us-ascii?Q?18faqlxoKkRtM5sW6s697kqnHjHiXiCp9dIck6RpuAzhJsWkDsg/CmRJzKMC?=
 =?us-ascii?Q?/7T9VmzRH25JDp1C81hW2lyg9ok5+Vk8XC4AWEifmk9n7EoGijROqnHz4l1s?=
 =?us-ascii?Q?2JXAp2CQ601ynMCQuHtQ7PzdRCcWlIGlwMdnwQ3t3JvIgj8n+IIdiQmo1Vgk?=
 =?us-ascii?Q?XRk2tFHYjfp1Bqpo//hgxxexwbIxm/oxjgN8ocAqg5o2Mhddi6Dckjl7WlKZ?=
 =?us-ascii?Q?0XHmhFX+zCTPz3mYqXkiQXFXd9pnLVD3uN+ZR2o9EjcxJEZltYUzXpfS5Of0?=
 =?us-ascii?Q?LMaf6LMmqiyUWNJ01e6OPQvQPEeQg7LdosL+GC5uP2TcjdNpw35lFXpcs0Zr?=
 =?us-ascii?Q?aLLf+9eJ2qsLHZAnLUy+ZXYMlZXR0k91Hi28gnj6oUJyd8SV40hc2fb2heYl?=
 =?us-ascii?Q?KPuF4zNOpjaSqCdoYTZxl1/rEQG/fNz0avXvR0t+9+3Eixcd+owhHeS2sb8T?=
 =?us-ascii?Q?wF2CIFryctf3R2HLDTsSio+cWJT2KVQQpdAD3S6MZtvy+eRdNv3IyZuYcKgZ?=
 =?us-ascii?Q?s2eDN1xDU13HaUsreUw=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90b044e5-5713-4674-11db-08de31cb52c6
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3613.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2025 17:50:47.2664
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 67R4sBKf9dUYqY2erZmXTNu/XlYZBNtFwZGZtGgEclGE7jAw67i+7Q12lRp7jg00
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6914

--4QfGn+MFxi24Vn7R
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

This is a pretty consequential cycle for iommufd, though this PR is
not too big. It is based on a shared branch with VFIO that introduces
VFIO_DEVICE_FEATURE_DMA_BUF a DMABUF exporter for VFIO device's MMIO
PCI BARs. This was a large multiple series journey over the last year
and a half.

Based on that work IOMMUFD gains support for VFIO DMABUF's in its
existing IOMMU_IOAS_MAP_FILE, which closes the last major gap to
support PCI peer to peer transfers within VMs.

In Joerg's iommu tree we have the "generic page table" work which aims
to consolidate all the duplicated page table code in every iommu
driver into a single algorithm. This will be used by iommufd to
implement unique page table operations to start adding new features
and improve performance.

There are a few merge resolutions, Alex's VFIO shared branch has this
against the DMA tree:

--- a/kernel/dma/direct.c
+++ b/kernel/dma/direct.c
@@@ -479,8 -479,9 +479,9 @@@ int dma_direct_map_sg(struct device *de
                        }
                        break;
                case PCI_P2PDMA_MAP_BUS_ADDR:
 -                      sg->dma_address = pci_p2pdma_bus_addr_map(&p2pdma_state,
 -                                      sg_phys(sg));
 +                      sg->dma_address = pci_p2pdma_bus_addr_map(
 +                              p2pdma_state.mem, sg_phys(sg));
+                       sg_dma_len(sg) = sg->length;
                        sg_dma_mark_bus_address(sg);
                        continue;
                default:

Also, there is a minor resolution against Alex's tree, take both:

https://lore.kernel.org/all/20251201124340.335d7144@canb.auug.org.au/

Thanks,
Jason

The following changes since commit ac3fd01e4c1efce8f2c054cdeb2ddd2fc0fb150d:

  Linux 6.18-rc7 (2025-11-23 14:53:16 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git tags/for-linus-iommufd

for you to fetch changes up to 5185c4d8a56b34f33cec574793047fcd2dba2055:

  Merge branch 'iommufd_dmabuf' into k.o-iommufd/for-next (2025-11-26 14:04:10 -0400)

----------------------------------------------------------------
iommufd 6.19 pull request

- Expand IOMMU_IOAS_MAP_FILE to accept a DMABUF exported from VFIO. This
  is the first step to broader DMABUF support in iommufd, right now it
  only works with VFIO. This closes the last functional gap with classic
  VFIO type 1 to safely support PCI peer to peer DMA by mapping the VFIO
  device's MMIO into the IOMMU.

- Relax SMMUv3 restrictions on nesting domains to better support qemu's
  sequence to have an identity mapping before the vSID is established.

----------------------------------------------------------------
Jason Gunthorpe (12):
      PCI/P2PDMA: Document DMABUF model
      vfio/nvgrace: Support get_dmabuf_phys
      vfio/pci: Add vfio_pci_dma_buf_iommufd_map()
      iommufd: Add DMABUF to iopt_pages
      iommufd: Do not map/unmap revoked DMABUFs
      iommufd: Allow a DMABUF to be revoked
      iommufd: Allow MMIO pages in a batch
      iommufd: Have pfn_reader process DMABUF iopt_pages
      iommufd: Have iopt_map_file_pages convert the fd to a file
      iommufd: Accept a DMABUF through IOMMU_IOAS_MAP_FILE
      iommufd/selftest: Add some tests for the dmabuf flow
      Merge branch 'iommufd_dmabuf' into k.o-iommufd/for-next

Leon Romanovsky (7):
      PCI/P2PDMA: Separate the mmap() support from the core logic
      PCI/P2PDMA: Simplify bus address mapping API
      PCI/P2PDMA: Refactor to separate core P2P functionality from memory allocation
      PCI/P2PDMA: Provide an access to pci_p2pdma_map_type() function
      dma-buf: provide phys_vec to scatter-gather mapping routine
      vfio/pci: Enable peer-to-peer DMA transactions by default
      vfio/pci: Add dma-buf export support for MMIO regions

Nicolin Chen (1):
      iommu/arm-smmu-v3-iommufd: Allow attaching nested domain for GBPA cases

Vivek Kasireddy (2):
      vfio: Export vfio device get and put registration helpers
      vfio/pci: Share the core device pointer while invoking feature functions

 Documentation/driver-api/pci/p2pdma.rst            |  97 +++--
 block/blk-mq-dma.c                                 |   2 +-
 drivers/dma-buf/Makefile                           |   2 +-
 drivers/dma-buf/dma-buf-mapping.c                  | 248 ++++++++++++
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c    |  13 +-
 drivers/iommu/dma-iommu.c                          |   4 +-
 drivers/iommu/iommufd/io_pagetable.c               |  78 +++-
 drivers/iommu/iommufd/io_pagetable.h               |  54 ++-
 drivers/iommu/iommufd/ioas.c                       |   8 +-
 drivers/iommu/iommufd/iommufd_private.h            |  14 +-
 drivers/iommu/iommufd/iommufd_test.h               |  10 +
 drivers/iommu/iommufd/main.c                       |  10 +
 drivers/iommu/iommufd/pages.c                      | 414 ++++++++++++++++++---
 drivers/iommu/iommufd/selftest.c                   | 143 +++++++
 drivers/pci/p2pdma.c                               | 186 ++++++---
 drivers/vfio/pci/Kconfig                           |   3 +
 drivers/vfio/pci/Makefile                          |   1 +
 drivers/vfio/pci/nvgrace-gpu/main.c                |  52 +++
 drivers/vfio/pci/vfio_pci.c                        |   5 +
 drivers/vfio/pci/vfio_pci_config.c                 |  22 +-
 drivers/vfio/pci/vfio_pci_core.c                   |  53 ++-
 drivers/vfio/pci/vfio_pci_dmabuf.c                 | 350 +++++++++++++++++
 drivers/vfio/pci/vfio_pci_priv.h                   |  23 ++
 drivers/vfio/vfio_main.c                           |   2 +
 include/linux/dma-buf-mapping.h                    |  17 +
 include/linux/dma-buf.h                            |  11 +
 include/linux/pci-p2pdma.h                         | 120 +++---
 include/linux/vfio.h                               |   2 +
 include/linux/vfio_pci_core.h                      |  46 +++
 include/uapi/linux/iommufd.h                       |  10 +
 include/uapi/linux/vfio.h                          |  28 ++
 kernel/dma/direct.c                                |   4 +-
 mm/hmm.c                                           |   2 +-
 tools/testing/selftests/iommu/iommufd.c            |  43 +++
 tools/testing/selftests/iommu/iommufd_utils.h      |  44 +++
 35 files changed, 1909 insertions(+), 212 deletions(-)
 create mode 100644 drivers/dma-buf/dma-buf-mapping.c
 create mode 100644 drivers/vfio/pci/vfio_pci_dmabuf.c
 create mode 100644 include/linux/dma-buf-mapping.h

--4QfGn+MFxi24Vn7R
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRRRCHOFoQz/8F5bUaFwuHvBreFYQUCaS8m9AAKCRCFwuHvBreF
YY+FAQDplTgD+qgT+hcf/Fzv47G3mHIboX4Q0dsa/REsf+5hrQD/Q/bPuv1hKCgB
CrTJ2ogZyLpRYxEAtgr0fA4PEAyeCQs=
=YLyV
-----END PGP SIGNATURE-----

--4QfGn+MFxi24Vn7R--

