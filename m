Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37A245FA383
	for <lists+kvm@lfdr.de>; Mon, 10 Oct 2022 20:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229454AbiJJSmK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Oct 2022 14:42:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiJJSmH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Oct 2022 14:42:07 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2041.outbound.protection.outlook.com [40.107.244.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16FDD2DC6
        for <kvm@vger.kernel.org>; Mon, 10 Oct 2022 11:42:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nb4ix2bMerU114ZmwVyzRsx/cJMfIslkbui6CbZecONVewWlp6oyUcPrHjGsbomtNTTVYxp0NEBt+4gqQx9uk3ISqVRZaEJFAtuOGr2RufuxrVvi/3CiLoXadMRoifArEdhSuMkNG7NTcckHmbrgcSODAhtki2F3S/l7HJs+wOFQo1kyIQKj/ccplN8N0fqEdoyD7UIGuMW3xpo5s3PgSbfzYbFBEaFapBwZ6mjD2srSaXarKBnjwdziib2o858wTbBe0ev8juvrvPOyDFcvoYosYsP7UVfERQaU80kp7U3K+N6qGouYBgBLh9h2gM17bwY4wFgUZyZIJkTjzo1jGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IGm/pfPYd6U6EdWI/qNerXyFdkE1GaEUvakx74vzVU8=;
 b=Lri3T3CDU3uFXfVbkNd2mJfsVKsxLo1yViHmPcn5wBGUfeWZ2G1zQwlGX/vDO5qeh1V/tLZNMZoIBG+/oj/jvrXGqk15Omjic/Bgsdt49/WnqnJ4EsmrMoad2F05X1/b7hEr7KtL5SB1YqmPj5k79E4Av8LAeHNV8S9C3OZLxWaK457jDPYsT968FVaC7spWUODoge/OU1nciC1Oh7gPxfxARSll2N8mO758OtkfFqywRpSx4h1nceQIqByheXroityprRjxwYuHJc7HuovX4Bh7pVfYbi8RiyBGwO/9TyxEb6i6KeHjEsmsVIHoW56ZbPERlbReRfz8zQiMGCIeYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IGm/pfPYd6U6EdWI/qNerXyFdkE1GaEUvakx74vzVU8=;
 b=rb9D8lqj36SQgJZGRWvLSn0Bvu7CvX6WG3DObA26lfwqlf3UmxZlS1uvEp0VvqxBD43T0bO6yqKjMIajQNHJIED/K27N60+7/SuQQUgM3Wl3iXexajLDN/TKSE/BiGGEnhNQzDt3r7W9Dpr9Zk5dtcUlbkhbRhV80fbIn0TZdOPnxoKIJkgFGC2oKzmAbjeK3ZLKK2GmyK49B8HhYlNphv4i82/GZqg+LawIR5CY8d6N3pACvbkl8oiAw5EtyH8NEmtNISRDKf1DU3qv9D1y7nA6hLJtWNtciIFjxqh4SThe8kSDundOSlSkFfc0Q3/nPeOTNKJtzDFTULvHepZsvw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ1PR12MB6146.namprd12.prod.outlook.com (2603:10b6:a03:45b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.28; Mon, 10 Oct
 2022 18:42:04 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de%5]) with mapi id 15.20.5676.032; Mon, 10 Oct 2022
 18:42:04 +0000
Date:   Mon, 10 Oct 2022 15:42:03 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v2 2/4] vfio: Move vfio_spapr_iommu_eeh_ioctl into
 vfio_iommu_spapr_tce.c
Message-ID: <Y0Rne7dwZVdqF3cX@nvidia.com>
References: <0-v2-18daead6a41e+98-vfio_modules_jgg@nvidia.com>
 <2-v2-18daead6a41e+98-vfio_modules_jgg@nvidia.com>
 <Y0PFJwIlaeJY0nSe@infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y0PFJwIlaeJY0nSe@infradead.org>
X-ClientProxiedBy: MN2PR15CA0054.namprd15.prod.outlook.com
 (2603:10b6:208:237::23) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ1PR12MB6146:EE_
X-MS-Office365-Filtering-Correlation-Id: 802b5a10-665b-44da-180e-08daaaef2062
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sjTcIXE66Wljb2np2lNubRhQvrAiPVdzpj/ns6sMrgTuZpbRMHTKA52wJmpwpnQWDYlW+yFYiR/ZoThfd9UC8D2S6TMt2xnwFqW1sfJd8qVNU3HYeShmXKDT9Go2ii1pqLLRmeHWQhd0k5fwYtDj6CkxjLXIwVR17pYnWvyfQLVoEfZEWkC9nM7TZWRNQ5RXQnh2cdJ7dh9VFPFRZeh0MhEjR72ITIa1+PhSjLu+GO6UJWf9gtBLqsbrBz0BbKFixLki4M8gmV3EJUXdwH9mQiEMTo9Dw6xOl7Ej2rDt1EpQDVDEibs69IoXQzaZjaF5PrJEe8NV08rpyF8j+Aozfcv08gGFgN8q0kjSaBRr/ZhGUJMKVAeZv12fum5KAYQpE8e429Fxp1A9EIzXZpmNbhi74ZnwZaWDV7hY4+ciudHVWT7Q0TyUyo1eNozLrahhWpO/ysEzKfWpVrq1Z49zIEKiS8RK2NQl/kYeo1CGcDZGnk0wtQYvrpUzWUcyVmE5lSQn/CPmrdhzokJ4i5exjRGQWgHnpMLmHgvdUlxVFSaki2Cjzu0GuqoNuv85WCjDEpAOlDD9Deo3FkQ8WMNQmMYJEAulFUEZgF1zYMEoFhaDQVWagIivTquMUMpZ9ImewwTQPC0L88qMhYrxGAynk/IVqtNu1WBHxuP6z+u+/KJ8nTaUYvTa/qAeqXJvQXHmIQeqnuSjBaLM6X7xc0dwmg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(366004)(376002)(136003)(346002)(396003)(451199015)(5660300002)(8936002)(41300700001)(186003)(2906002)(8676002)(66946007)(66556008)(6512007)(86362001)(26005)(38100700002)(66476007)(2616005)(6506007)(36756003)(4326008)(6916009)(478600001)(54906003)(316002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?g5Q2J+4Yfm9RkFqe6i/wUw2+wLGjiroMLjQQAJ6um6HsCEjB91a+IoYMX07k?=
 =?us-ascii?Q?GWvqpz4noU+70OTfEpsta5V0dkwDcZm6UjoHd30GP4ISU35MoCXnWwiXXRvB?=
 =?us-ascii?Q?+/kPUtbkwgnmVXHwH9Ehu9er6149rqgbwZh9TOPF2/VIymaytVK/kVQLIB24?=
 =?us-ascii?Q?Rosh+imVeSnPgbZloO9E6aTRfw36b9NyUJPTXdyJNFdRI0Yse5dXaVMzCoHC?=
 =?us-ascii?Q?qnfowARpuOJYV+TMofZy7L4Dy4DShFoi3jsFz+jiGzcefH8enkzP2WBfQdsq?=
 =?us-ascii?Q?n9mOh45RUlQbx/IZUzGOueigHQia1EkMnlgexb6+NIe0wgg/8DJ+ugfLtHUf?=
 =?us-ascii?Q?aH7YTBYEuYMRIwsxIRStKs3DOGNZFQU5jdvcbipmPLJOwHj704RS9gKlGlZR?=
 =?us-ascii?Q?Dt+Hfzxig/4oQhnygprIEmzhA7p9zI7egHzH051qTXNCf6aOVLYuqQfCQLy7?=
 =?us-ascii?Q?iccMO4VcTMRHu6HgfVkBQDf9IpTGZRIv6zL7/z+PsY9SN85/H8NpKgHSlHsU?=
 =?us-ascii?Q?p2/v7oocMj8pA4ATh8WP4sHoBf/soFdDGcU7lcuvV4kO4spBq384sNGafdAC?=
 =?us-ascii?Q?72t1XRSB+EMB5DbXobDQdmH4+NQAu2sdAM8uV+nRw3AcuNtR91C0Rtczu+qM?=
 =?us-ascii?Q?4PKTqIHJqMuYATGNPbq2rDyymvzHDwdboi6CWm66Qb2lnOq4cfcB1eG3pIIH?=
 =?us-ascii?Q?K4br2/kWk1p4dL7vPsca0SZNcYdLUJ8O0r+4L+tLuQgzo2EFoUGAMZTDhf1M?=
 =?us-ascii?Q?9mpkQ8M2fg2NNp5YXqYdwaom2KnQkkk9d8pla7jn/qW8cN4Xit6GvZBlHwcy?=
 =?us-ascii?Q?bGG+/joPHqC6q4xOyDuHXgS8SSODnhMRxuvk1gtSmDpKp24uHtkWZSWSQvnQ?=
 =?us-ascii?Q?oH6eCaM5JS6eU9hABsw1PNQqOYwz1GJMV5FJGfZkyFFemBRljl+1qL/tZLlC?=
 =?us-ascii?Q?ncRLP6lRqdJnYPKXnswbElEwmwLasw6YnUFNA1Zaz8Kji+93wdePfeygI/H+?=
 =?us-ascii?Q?BH5/TFC2c4myEMqCdSWw/PmFhgJyRw+fihxzutTzArPsVLwLSuhdi9zPOPUV?=
 =?us-ascii?Q?OvJSXjefpvYI5S+qv44DQlHfMk/bDWn56QdJ5pBakaf7Nffq2AruxM5Tl+9c?=
 =?us-ascii?Q?9Tl5RQY6oq/kElhledt+6NXWOA7XvljE0Hj4XOTOFq4BTuLYWDE2La7HusZf?=
 =?us-ascii?Q?QcvCboIc0sWvs9mgQ7hkpUULaPtUZi6HVyAqAQckpf5M45bEQZQng4qcr52g?=
 =?us-ascii?Q?6fi/ytK9JdbP3iVpRforePrhLSCUng8DhslMemPUmmCVvx4pSUBrvhQoYlxy?=
 =?us-ascii?Q?dSOgSqIx7gCOlW2OO6ydkEIHotofw/FefauZ+LL08I6znERYa3Uv85l80Ob/?=
 =?us-ascii?Q?VeqFjjJRWIt88iZU7+HFJgoZXOsh4rjVs118ABeVIhJjWPOymek+XYYrJN/L?=
 =?us-ascii?Q?WW1t2obZAG2KGND70fdI70CMbchjXy79mcMiQnPhlr+RgdXv0ZXwslSHMOF+?=
 =?us-ascii?Q?/+6mZy3NLoxxYWxbNasc1KaycUSZDDa0XsPxN32W1woTOq6ohqmIeuAmMTil?=
 =?us-ascii?Q?ytPYRZjJLdB2M2BDHUY=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 802b5a10-665b-44da-180e-08daaaef2062
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2022 18:42:04.4657
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fq8Kov/Znh1BVHxAU4eR87xXOCfWHxEwXBSVLvpBxoN9li8xQgUsEbVQ/6MAT9+p
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6146
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 10, 2022 at 12:09:27AM -0700, Christoph Hellwig wrote:
> On Mon, Oct 03, 2022 at 12:39:31PM -0300, Jason Gunthorpe wrote:
> > So we don't need to worry about the fact that asm/eeh.h doesn't define
> > enough stuff to compile vfio_spapr_iommu_eeh_ioctl() in !CONFIG_EEH. If
> > someday someone changes the kconfig around they can also fix the ifdefs in
> > asm/eeh.h to compile this code too.
> 
> Please just break it up by opencoding the VFIO_CHECK_EXTENSION
> cases and just having a helper for VFIO_EEH_PE_OP.  I could look
> for my patch doing that but again it should be trivial to redo.

You mean to fold the case branches into the existing switch statements
in tce_iommu_ioctl()? Like below with indenting fixed?

diff --git a/drivers/vfio/vfio_iommu_spapr_tce.c b/drivers/vfio/vfio_iommu_spapr_tce.c
index 47a8b138cf7f6d..b6426109db5e0f 100644
--- a/drivers/vfio/vfio_iommu_spapr_tce.c
+++ b/drivers/vfio/vfio_iommu_spapr_tce.c
@@ -773,8 +773,8 @@ static long tce_iommu_create_default_window(struct tce_container *container)
 	return ret;
 }
 
-static long vfio_spapr_iommu_eeh_ioctl(struct iommu_group *group,
-				unsigned int cmd, unsigned long arg)
+static long vfio_spapr_ioctl_eeh_pe_op(struct iommu_group *group,
+				       unsigned long arg)
 {
 	struct eeh_pe *pe;
 	struct vfio_eeh_pe_op op;
@@ -784,14 +784,6 @@ static long vfio_spapr_iommu_eeh_ioctl(struct iommu_group *group,
 	if (!IS_ENABLED(CONFIG_EEH))
 		return -ENOTTY;
 
-	switch (cmd) {
-	case VFIO_CHECK_EXTENSION:
-		if (arg == VFIO_EEH)
-			ret = eeh_enabled() ? 1 : 0;
-		else
-			ret = 0;
-		break;
-	case VFIO_EEH_PE_OP:
 	pe = eeh_iommu_group_to_pe(group);
 	if (!pe)
 		return -ENODEV;
@@ -843,8 +835,6 @@ static long vfio_spapr_iommu_eeh_ioctl(struct iommu_group *group,
 	default:
 		ret = -EINVAL;
 	}
-	}
-
 	return ret;
 }
 
@@ -860,14 +850,14 @@ static long tce_iommu_ioctl(void *iommu_data,
 		switch (arg) {
 		case VFIO_SPAPR_TCE_IOMMU:
 		case VFIO_SPAPR_TCE_v2_IOMMU:
-			ret = 1;
-			break;
+			return 1;
+		case VFIO_EEH:
+			if (IS_ENABLED(CONFIG_EEH) && eeh_enabled)
+				return 1;
+			return 0;
 		default:
-			ret = vfio_spapr_iommu_eeh_ioctl(NULL, cmd, arg);
-			break;
+			return 0;
 		}
-
-		return (ret < 0) ? 0 : ret;
 	}
 
 	/*
@@ -1121,8 +1111,7 @@ static long tce_iommu_ioctl(void *iommu_data,
 
 		ret = 0;
 		list_for_each_entry(tcegrp, &container->group_list, next) {
-			ret = vfio_spapr_iommu_eeh_ioctl(tcegrp->grp,
-					cmd, arg);
+			ret = vfio_spapr_ioctl_eeh_pe_op(tcegrp->grp, arg);
 			if (ret)
 				return ret;
 		}
