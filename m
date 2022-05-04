Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 307705192BD
	for <lists+kvm@lfdr.de>; Wed,  4 May 2022 02:21:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244584AbiEDAYg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 May 2022 20:24:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230437AbiEDAYd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 May 2022 20:24:33 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2051.outbound.protection.outlook.com [40.107.94.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66CC61A811;
        Tue,  3 May 2022 17:20:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E5RqliDX2MFZRJ5Qq1TNrHTDF55EFd542R1UEDTSfxu1l6xyOM7gsaTwSnVQglbkMFGE7UiFpbd5u7IkP8W9CVMIcYrCulK+5xnfESza3VOUCAgSDzstzfbqT9o73A8oaAbf5QBxVIFuAXNb6Xcb7FJJiqmAU6TkgfhEBDyrV+ECPQZWCmMxdi5earJrUBZKxET3ZLP8ir/iQ9kWDwxDJUkCiwcG5oB1xLbJpHdv5k1EY3CMIjaV11elk/CgVK8spsJzzjnDB7kXUXsLFLla2xAV1qtsFEfCLc0IecvAoFsoukgy0kI/kElQwfzwS9aEGQDB8UnFykRj/w3Stxiedw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FginmT8J/6XvmL6t/KIqeV5eqwhsP4DFKnZgwjAUPXc=;
 b=UQB04TLmnLbpsCOWGhBqEe/BCCl3fDJDL6pFEQlgeXuJw/Zjm3nJWD5Tm669CiGa+TEGQqaSLp1FtamHOU28rcp57Woen2TjxD8o29hmGEFjd94qzKdI55ltbwtHi6o3c5BA9E2Sc8Bhz02X38tgMr8Kann0bgM2xYa89dDUPhJgUdNa0SqxFQC4YAMmcrFs/EweVZ2MjsAjNY2+OMltZU5r7RgzR+Z42wqzIxm8mMVwFOVpP7E2tXb2gUc8mQJSXZWakqliEa8qKyJeTuU/EKYSygVOXcIr1g0HJ7xQUEb6B3ERPfKQxZXxDnoA4Eyy7MDTRwxV30RAm4G1MXycUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FginmT8J/6XvmL6t/KIqeV5eqwhsP4DFKnZgwjAUPXc=;
 b=Hf8Y0rsnCUKe2uliTXkS7m38ikb77vmTvLI299bK6OBpxAvUoWJXt0ncxCG7cgtKhSReuppap43Dm2lVp+40eLhoCAVoP8GVaonFhg0G3ha1K6LQiIeaIVqaulb4JatA/DQXxTaHmbgYL3S5ymv9qerb+AuwaTd0lPE6V6jyKDQX80cqdJdRDJb4a3SvHQMd24snpI7uNpA53POx6oQohR+RqqSI6CLaxN6pHtMU1/LzPCWWG84jE/qDY9Hfmz1jJRR9ktIYmak9uSkIYDp8fooOWLciEVtRmcNXCScwwVlv/Tx2hprE0ybWT/tnX37ZqpLTnBvoytMls0ATIFTpzg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM6PR12MB2748.namprd12.prod.outlook.com (2603:10b6:5:43::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.14; Wed, 4 May
 2022 00:20:57 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%6]) with mapi id 15.20.5206.024; Wed, 4 May 2022
 00:20:57 +0000
Date:   Tue, 3 May 2022 21:20:56 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Abhishek Sahu <abhsahu@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Kevin Tian <kevin.tian@intel.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH v3 4/8] vfio/pci: Add support for setting driver data
 inside core layer
Message-ID: <20220504002056.GW8364@nvidia.com>
References: <20220425092615.10133-1-abhsahu@nvidia.com>
 <20220425092615.10133-5-abhsahu@nvidia.com>
 <20220503111124.38b07a9e.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220503111124.38b07a9e.alex.williamson@redhat.com>
X-ClientProxiedBy: BLAPR03CA0141.namprd03.prod.outlook.com
 (2603:10b6:208:32e::26) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fd4ebf35-27e0-4714-daf2-08da2d63f5c1
X-MS-TrafficTypeDiagnostic: DM6PR12MB2748:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB2748F1A9310C52EC6B58698EC2C39@DM6PR12MB2748.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NysgA7pVsRM4d/Dck5tYBWG9heJ1fC/INJJ3ka2Y1UDuXfF6XUN/iOAS73le+UqvjYcak2gYe7V8+hUEkoGgNNOSioxxVvjkUyYZZqY7+9RtXREY2evFmE4J3E1gQlU+8VAldll3SD7wkOZ6G3sdCAwePYrAjzWm5Wd7ePvJmMEjGKSxwIfvkQ6jwxQtHLVVXKcMbPykuksrF2xwe/i4NrdIsT8s7Xllstw79334N+gXus6ZHHBrwEl2vkZ0ImRqrOmpgGP4l4C415RNfUk7M9f8VRlV3M22Z4mhlurlXMYR5kT/y5Q8fHNlRLPTjmjGggdb8yVACyC9qdvnGPvLvBqYSnz+2n4SDAAVRItjR8ihmnbP8hGd9Z4kmD2QpTZBiYy1VjITnIzSvfiIyQxsSvbEnuRtz9uU0UjAG1XeteZ5etRo+XoYapYbZY+bvhFwFcMnQsUKoCxJmLppvE2EAU63NSRh9y8+ZORyAYDofnsQaw/XuOcW68CgA+Gm8fbhNe/4KWzu2xj/6Fjp9YdUknk23fW8g4cf/Okkd9PFeKSBF13NDofptd3Jrpiz8Y3a0TGLAIRbbrBbtLtjbvDUcKjNq6RV7XTklRfxVeJwfasqnllWHNiuNTZRDxDyBe3yn2FoyrCzmpjGLAB3nSIlAG9zGV020o2sq2ISCj5udXkCawWMLJB/YeiM8BQ/1hkAn1AVpwTrTfysOILd0I04NPI0/XDHA4GcE/QGM8a3+28=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(26005)(86362001)(966005)(66476007)(36756003)(6506007)(6512007)(66946007)(66556008)(54906003)(2616005)(316002)(186003)(1076003)(6916009)(4326008)(6486002)(33656002)(8676002)(508600001)(7416002)(8936002)(83380400001)(2906002)(38100700002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?exrOtyBZxZVmfaZ3YvSu9yEOveclWAik86zyiXt8tkFQeUDcg1i3D4OF2gkQ?=
 =?us-ascii?Q?+zWFcWLmOtc1HALlYxvJNBAEFwpDjsyEFxLd8yBKnBSzVH8/0Er/xHnsvQ9S?=
 =?us-ascii?Q?AiCyd+x8qWywlii1u/pD+qihScdHWU4zaajun3YAKf1bBFu8E4gc6O0hq54f?=
 =?us-ascii?Q?6pOrkUcbKnSm5zz9laeF+uv3iy0QmA6jnXWxDFs2IxEr6e/jhl7jgUslrCE+?=
 =?us-ascii?Q?mkGzX7/zVBWbtbpY0O5K9WwM4ikf8wVawFzyb3feens0z2xl2LvP+TY3Ws0/?=
 =?us-ascii?Q?VW5KqJR6/tDnIqafec/ovhqpTL/2aJ5JUiPFxJeEjNyFo3fJBW3dSJSHZyCs?=
 =?us-ascii?Q?GKvIrnbRbEnBhwUuJV22VNz727zM0K1v+9ud+WtgtaTgMfvDLGHCcqynbWbb?=
 =?us-ascii?Q?NoP1MdoiBeSrExE4wzpA5jerKOi64JSNzevw1dhOxAhqLGHYX4kk3A1IUGYC?=
 =?us-ascii?Q?0h6bbmARFIjuOBLlCjAIbJ5o+6xJgIPyVmLVYh43OFsPqBD8zdSiGuKaiH/D?=
 =?us-ascii?Q?5rfRQasicXrfNGbL1Y5eguYSWn43bwGaxqlqJh2ygaqc2+cuROrJWkWE3p8R?=
 =?us-ascii?Q?YD8+wD1HBAT3C8Cj6HfOWE77OdAwsDq5EEsyliG9VA5/fHlpH95fDDhAUj7g?=
 =?us-ascii?Q?qwGFxFLsyC5WpJj5PWZMhYIzFtSTqpEr5wwXfhMmB3uhumEs2ywfwv06iTrX?=
 =?us-ascii?Q?qFvcHGGXP5mOrI7aLhl4uJf+jgFRVqbccDAXWKwnrJKSsFA39iYgauO+UhkJ?=
 =?us-ascii?Q?4K8FdXmrnC27tv5ME2VQuJngGVYRfiDAzNkNkc3bruKsn0o959jzKU5pp3fL?=
 =?us-ascii?Q?2gOnRsL/hoHmVAdXYSpHPgzUhY9783Jce5JNY6IPb0fri4PCnLGK9nm6CTVf?=
 =?us-ascii?Q?GLVw5JY1fwxDQ6CAZsXJqI1+mqdr4TwQEUp7gccGnrjrLwY+DwlgA82h1j6b?=
 =?us-ascii?Q?welMRLjBDMIbbfynZxpjWE2WtJy1dt/8jvmSqUz0BWyZlyQH3DxrZ1IH8c0B?=
 =?us-ascii?Q?lAwrZXIusr5cEXdLBl1l6mVie8vrjOtPV5OcnP5+qnNuEjDIlYC5jvv/pzqE?=
 =?us-ascii?Q?vn4fp0Fx8ojmGPQVHnyIwnFyRd081MPggBKsihm5vXGyOi2WnxtK57+eAcUO?=
 =?us-ascii?Q?Sab5moolhv1375xwb1T53g33bn4rx0gXqJb6f3wX17/rVqnPqT78V9+7SEY7?=
 =?us-ascii?Q?ePvxNMCiRduTlanD3u/kvR0CoFZ6eQAvJfxb01TEegDwbQUuOMyQKgdnNcwb?=
 =?us-ascii?Q?GSFQH8MiQTXJOa38EwZXb+i3DKlbUiFmPDHU70Vqd9O6cY7zk8hnI/lwMm0g?=
 =?us-ascii?Q?r7YNv6r+OSVrK5oRxBk6PmKJRVA2uimpKF6c+6VuaokluudLrQZZMdqlNQN8?=
 =?us-ascii?Q?nXs6T9ksaznkohQmqKYChJ5lnEx+2ZHEFJm4HKghe8KAmPz0iRiUqZuylJf6?=
 =?us-ascii?Q?TY9BjIbMsl2TzCE/ceW+jXupyaPobg9Hs17KF6kQ/d4seBlWrq9IALw9W8qn?=
 =?us-ascii?Q?EL5GiCieQXLEOUkDhibc5bp+LI7ndOXgRqHaVdmI7Hyf6RT/+4eQLnKvd5bA?=
 =?us-ascii?Q?CmVybZCveAmx+J+wrGq96MtpBsTfRVuThLjDGV5OEvvlNh5+rhkSS9m4w2Kq?=
 =?us-ascii?Q?luxZWDZF4urYdPdwRAGwT10vMtDmeTbxujgO6B+L90q7m7wOClBzeEXlG/t8?=
 =?us-ascii?Q?DqEuMeU/+dw7fmgJsXW7fpP51lHUO7Pp/0EXfOXlHhq9ZZTBvNf/lz/4xury?=
 =?us-ascii?Q?JI6yX5Jjqg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd4ebf35-27e0-4714-daf2-08da2d63f5c1
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 00:20:57.6199
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XNwS/C8MoKIv7iNVS995WQ/KwXK4C3TOOf0Z7fWpKNtbTMXYtAFEMgkCTiQ953Rw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2748
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 03, 2022 at 11:11:24AM -0600, Alex Williamson wrote:
> > @@ -1843,6 +1845,17 @@ int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev)
> >  		return -EBUSY;
> >  	}
> >  
> > +	/*
> > +	 * The 'struct vfio_pci_core_device' should be the first member of the
> > +	 * of the structure referenced by 'driver_data' so that it can be
> > +	 * retrieved with dev_get_drvdata() inside vfio-pci core layer.
> > +	 */
> > +	if ((struct vfio_pci_core_device *)driver_data != vdev) {
> > +		pci_warn(pdev, "Invalid driver data\n");
> > +		return -EINVAL;
> > +	}
> 
> It seems a bit odd to me to add a driver_data arg to the function,
> which is actually required to point to the same thing as the existing
> function arg.  Is this just to codify the requirement?  Maybe others
> can suggest alternatives.
> 
> We also need to collaborate with Jason's patch:
> 
> https://lore.kernel.org/all/0-v2-0f36bcf6ec1e+64d-vfio_get_from_dev_jgg@nvidia.com/
> 
> (and maybe others)
> 
> If we implement a change like proposed here that vfio-pci-core sets
> drvdata then we don't need for each variant driver to implement their
> own wrapper around err_handler or err_detected as Jason proposes in the
> linked patch.  Thanks,

Oh, I forgot about this series completely.

Yes, we need to pick a method, either drvdata always points at the
core struct, or we wrapper the core functions.

I have an independent version of the above patch that uses the
drvdata, but I chucked it because it was unnecessary for just a couple
of AER functions. 

We should probably go back to it though if we are adding more
functions, as the wrapping is a bit repetitive. I'll go and respin
that series then. Abhishek can base on top of it.

My approach was more type-sane though:

commit 12ba94a72d7aa134af8752d6ff78193acdac93ae
Author: Jason Gunthorpe <jgg@ziepe.ca>
Date:   Tue Mar 29 16:32:32 2022 -0300

    vfio/pci: Have all VFIO PCI drivers store the vfio_pci_core_device in drvdata
    
    Having a consistent pointer in the drvdata will allow the next patch to
    make use of the drvdata from some of the core code helpers.
    
    Use a WARN_ON inside vfio_pci_core_unregister_device() to detect drivers
    that miss this.
    
    Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
index 767b5d47631a49..665691967a030c 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
@@ -337,6 +337,14 @@ static int vf_qm_cache_wb(struct hisi_qm *qm)
 	return 0;
 }
 
+static struct hisi_acc_vf_core_device *hssi_acc_drvdata(struct pci_dev *pdev)
+{
+	struct vfio_pci_core_device *core_device = dev_get_drvdata(&pdev->dev);
+
+	return container_of(core_device, struct hisi_acc_vf_core_device,
+			    core_device);
+}
+
 static void vf_qm_fun_reset(struct hisi_acc_vf_core_device *hisi_acc_vdev,
 			    struct hisi_qm *qm)
 {
@@ -962,7 +970,7 @@ hisi_acc_vfio_pci_get_device_state(struct vfio_device *vdev,
 
 static void hisi_acc_vf_pci_aer_reset_done(struct pci_dev *pdev)
 {
-	struct hisi_acc_vf_core_device *hisi_acc_vdev = dev_get_drvdata(&pdev->dev);
+	struct hisi_acc_vf_core_device *hisi_acc_vdev = hssi_acc_drvdata(pdev);
 
 	if (hisi_acc_vdev->core_device.vdev.migration_flags !=
 				VFIO_MIGRATION_STOP_COPY)
@@ -1278,7 +1286,7 @@ static int hisi_acc_vfio_pci_probe(struct pci_dev *pdev, const struct pci_device
 	if (ret)
 		goto out_free;
 
-	dev_set_drvdata(&pdev->dev, hisi_acc_vdev);
+	dev_set_drvdata(&pdev->dev, &hisi_acc_vdev->core_device);
 	return 0;
 
 out_free:
@@ -1289,7 +1297,7 @@ static int hisi_acc_vfio_pci_probe(struct pci_dev *pdev, const struct pci_device
 
 static void hisi_acc_vfio_pci_remove(struct pci_dev *pdev)
 {
-	struct hisi_acc_vf_core_device *hisi_acc_vdev = dev_get_drvdata(&pdev->dev);
+	struct hisi_acc_vf_core_device *hisi_acc_vdev = hssi_acc_drvdata(pdev);
 
 	vfio_pci_core_unregister_device(&hisi_acc_vdev->core_device);
 	vfio_pci_core_uninit_device(&hisi_acc_vdev->core_device);
diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index bbec5d288fee97..3391f965abd9f0 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -39,6 +39,14 @@ struct mlx5vf_pci_core_device {
 	struct mlx5_vf_migration_file *saving_migf;
 };
 
+static struct mlx5vf_pci_core_device *mlx5vf_drvdata(struct pci_dev *pdev)
+{
+	struct vfio_pci_core_device *core_device = dev_get_drvdata(&pdev->dev);
+
+	return container_of(core_device, struct mlx5vf_pci_core_device,
+			    core_device);
+}
+
 static struct page *
 mlx5vf_get_migration_page(struct mlx5_vf_migration_file *migf,
 			  unsigned long offset)
@@ -505,7 +513,7 @@ static int mlx5vf_pci_get_device_state(struct vfio_device *vdev,
 
 static void mlx5vf_pci_aer_reset_done(struct pci_dev *pdev)
 {
-	struct mlx5vf_pci_core_device *mvdev = dev_get_drvdata(&pdev->dev);
+	struct mlx5vf_pci_core_device *mvdev = mlx5vf_drvdata(pdev);
 
 	if (!mvdev->migrate_cap)
 		return;
@@ -618,7 +626,7 @@ static int mlx5vf_pci_probe(struct pci_dev *pdev,
 	if (ret)
 		goto out_free;
 
-	dev_set_drvdata(&pdev->dev, mvdev);
+	dev_set_drvdata(&pdev->dev, &mvdev->core_device);
 	return 0;
 
 out_free:
@@ -629,7 +637,7 @@ static int mlx5vf_pci_probe(struct pci_dev *pdev,
 
 static void mlx5vf_pci_remove(struct pci_dev *pdev)
 {
-	struct mlx5vf_pci_core_device *mvdev = dev_get_drvdata(&pdev->dev);
+	struct mlx5vf_pci_core_device *mvdev = mlx5vf_drvdata(pdev);
 
 	vfio_pci_core_unregister_device(&mvdev->core_device);
 	vfio_pci_core_uninit_device(&mvdev->core_device);
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 06b6f3594a1316..53ad39d617653d 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -262,6 +262,10 @@ int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
 	u16 cmd;
 	u8 msix_pos;
 
+	/* Drivers must set the vfio_pci_core_device to their drvdata */
+	if (WARN_ON(vdev != dev_get_drvdata(&vdev->pdev->dev)))
+		return -EINVAL;
+
 	vfio_pci_set_power_state(vdev, PCI_D0);
 
 	/* Don't allow our initial saved state to include busmaster */
