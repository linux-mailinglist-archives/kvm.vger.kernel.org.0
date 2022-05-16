Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 355C7528BF8
	for <lists+kvm@lfdr.de>; Mon, 16 May 2022 19:27:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245546AbiEPR1m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 13:27:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230463AbiEPR1j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 13:27:39 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2053.outbound.protection.outlook.com [40.107.223.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6916A1EEFF;
        Mon, 16 May 2022 10:27:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S6kfZR7UUzWqo6Z14npqV5oH535F9IL7p4uT2DubKQDpxiRpSw5/o7FQUaVxuyMTHebNlJDImp6Y5LlmNLTChPHKp5a3P9sb7+vOn31R0nzDICDIp2bh/E88HeK44s06k7kvC3MiAmSmvhikrVcPxAzuBNvFjVnJo+7UaDuIDJqDFLPWAknrp7MkUSN7L763QZQWAhhBizu4z41K2LLFQ7INFTn9RaAR9O/A5IDnI3E0OKeuc/KXn3CA9iO7hDP8epbDV5UOHRdi5g1w/8/kpORfPmDjNGGQtbTXHSeBRNJtzED3W5JK6O+F+IuJvFW48UhEiZFCV4EEbNV9EhYcKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/8oKhkgUKjJUm4GS90ruNN5lvMRh8HTxJHZIXIjrew0=;
 b=ZM5dpPORCNzo1jUYLS722vN83QjHW+bO5RsonYlCjLek3vN6EhM6PY9OyDnk0yYk5TBesDOQQ6sE2LAxzaqPgS1SfSTb6f0eLCabXO6VYbqzykrIP+rM74SU8eeWEkYcL6jakZ/YgCiB7WFb2NB4tCEDA1UjLtODO5SOtetpmYf3Ldvs/zykpFXuhlM+ALXc4nh6OrrLos0Xd3rSrbiHK9L0uReWdCampmbM12UehpDAJD92WUQt28VMF6bK8ntVkY9XQ+GsWItnynrAECc8dLswgrPMqLLphuqjXblcKJ/RUMkz4lxwaMgnG5MwmLoKVYby2ZhlMGmBykwN6IFzwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/8oKhkgUKjJUm4GS90ruNN5lvMRh8HTxJHZIXIjrew0=;
 b=HgWfBDI6U8at6JxWVLkdFoikOjjbeF2SmPl9iuq65jIQSrflCsp3teVIH2qrDNkHfuASGzjBrXhG8MZHVlkslGhTj/pW2c8ytTUbXwCdNxRwJMjnRo5Hsk/oFY9XsVyAovchYfhIUE59inkGh2Gm6CEyMVBauoHTbbN8ZjFUh6szqnnUfIQMCyLSySM68EirTQNsUrUB+kfQlGXdF9Gd99MMFbxlthf5HfdXcNiryE+oY0oyAMWX8hnv0mS8wj3REnKJXyA9fMZaG1wvZWUAE4OZSffq0onIBn1Tqj0TrClv1CrdU3qVYTQsLv51NYMQunzGdMIC6vwf1RvGjVEAnA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM6PR12MB3243.namprd12.prod.outlook.com (2603:10b6:5:185::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Mon, 16 May
 2022 17:27:35 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%5]) with mapi id 15.20.5250.018; Mon, 16 May 2022
 17:27:35 +0000
Date:   Mon, 16 May 2022 14:27:34 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, alex.williamson@redhat.com,
        cohuck@redhat.com, schnelle@linux.ibm.com, farman@linux.ibm.com,
        pmorel@linux.ibm.com, borntraeger@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        agordeev@linux.ibm.com, svens@linux.ibm.com, frankja@linux.ibm.com,
        david@redhat.com, imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, pbonzini@redhat.com, corbet@lwn.net,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v7 17/22] vfio-pci/zdev: add open/close device hooks
Message-ID: <20220516172734.GE1343366@nvidia.com>
References: <20220513191509.272897-1-mjrosato@linux.ibm.com>
 <20220513191509.272897-18-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220513191509.272897-18-mjrosato@linux.ibm.com>
X-ClientProxiedBy: BL0PR02CA0031.namprd02.prod.outlook.com
 (2603:10b6:207:3c::44) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c6c0285f-24f7-4678-0dd3-08da37615dee
X-MS-TrafficTypeDiagnostic: DM6PR12MB3243:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB3243EF7AD704DC585E96C359C2CF9@DM6PR12MB3243.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D7bXM1/7EpJyxJx6E7YvOluoHsQSBd9MC7dR3clQDcLT7hFNeszWeUFXuR8exTsyTSOfXbUUfWrOyg+/gGN6GUAQlaxHEmS623jPY4kdwOMZuFNjz+OtrrU4Qg9738GbB7JivfdTUlTOAeUdUWriAH8VEuGWQlheUiG6LGnsGR+Kx7erM4WRetRu9QmpYC/PdV/28A9Zj7EqKqjtBqpiHxXM26ezM8FoK/EvY8xUN2HcYkGSsycZRE179Xn5vh1Kyckv06Z7iSSXixLMDTGLPg9nU5OYzEgg88M79/oX/D+s5b5t6B51Mm5xdViVm8945TDOFRHHXMahVwn4vta8lgnyuizDcaln4FvQEkEgAq1KmEm9bbzuc7Tt1g/t9f/WBuEUwhV+VCOQ4qJqtsAD8yQ7RJLnYIAhDkJS0dUe05R+1pNJaFIbLhPc1Qk4OEo85TrCRlup9OeaygbOOpyBTTFyu8rIM5isqsuyeD3nKywpVNuSTsbp8bPB/5Lkmmv9VVvR8ew+cRkSxQu5np7YrvYVUedcxJLmLCCJabeobEQsTLz2TA1nzMWeRmFAJIE6DGoAEyR2IJJFXC7lUWSotWF7FnRVztxlkMrxBmqjcKxbosgXJNVLFCEbZWyAF2II70zhe4qjjpwzHbJoH0o3cA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(6486002)(6512007)(6916009)(6506007)(8936002)(26005)(86362001)(7416002)(316002)(30864003)(83380400001)(36756003)(38100700002)(4326008)(2616005)(8676002)(66556008)(66946007)(66476007)(2906002)(1076003)(33656002)(5660300002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?x9Q+ZWfbJ2BWswmG/YuvExSAzxEwXZm5BpXhhLwtRoduwWFdjhiVagsYkxkz?=
 =?us-ascii?Q?Yz9yBz3rQtd3R2WUYYFW6HHBi5rwTb9S/RX4c6rggc4GnRiU17iHOI3fC/Z8?=
 =?us-ascii?Q?LOfa5rJYiLsgBb0N2oeHs9bppj8xnTb5siWLhkmjyEWFnwuhIy1w6/+O6rO7?=
 =?us-ascii?Q?+IStkM3ePUoVeT537vpHmLDjcX9wrWBJDf3jlNrNSc6W//2MqS3HBBjR25zY?=
 =?us-ascii?Q?055xMpGW4Rc17UzP7YgkxdgkMTtUSEOyjNYPa/PXgkHhe1AqKItRBHsVBZzv?=
 =?us-ascii?Q?g1yIhMmRAuaHxnjsjgasUUTLHWMUP41zpzj4zNFALMQIK3+FFjdShX74r1Hf?=
 =?us-ascii?Q?0lFg8qyRVhxqKSf8v1g96D3oUWRhaRTZgDGGmhODNsvUOuCWXYDUebs0AwgU?=
 =?us-ascii?Q?5J0gSMVORUWVgvruTvBia/W63ufqc10FFUo9+cLMHmyt4kVy2GHx0BnhQkYs?=
 =?us-ascii?Q?93imxANYPSJb3g9fig8/WbVQKyjrEup5w/z7JWuPbYsUp15tODhDkWZv6YxK?=
 =?us-ascii?Q?bbnzyiO3hAqkdBDOlehrnv9l54hwkQxyGdRtlI/zauyAf10xAnyVSgn36/RG?=
 =?us-ascii?Q?JO1mSKRBPalfXHe3BqC+wzzEx4lynPepnh9k5LKv3Nf23PcOZMwez2RtbGJ1?=
 =?us-ascii?Q?VW7UEN9x7uCNN6wEi/vAUyfTyUvDCrIuyK+nWz32W2CLzHBaOOlxuvgpn/XP?=
 =?us-ascii?Q?JBa7RJc/iVqy1SIL+V7Gw/7nnhg8Yfg3FMFIwsXORs/U4CQsiNTCxxkLMHzI?=
 =?us-ascii?Q?677pnhk/JTFapQ27Pdh6sblMPhbYk7quMdeIWIY+nK/b/1jXYbd/Km36xsmc?=
 =?us-ascii?Q?yT1hsifo5RhMplfPaoLy/JaGwMIMHuXuOkcPrEmUApwseyIrfuqMrIGi4A/z?=
 =?us-ascii?Q?7O34ARtJ46POm4IQmu9B3dAhk4NJXkas1/8C4MglgEKneniWzABf6WCoeD2p?=
 =?us-ascii?Q?15r00y7Sf0+QmaOaH1Pk4m7WlG5cK3DGZm7aFDJ8NoHnmU4INYPy4ppEOQr6?=
 =?us-ascii?Q?NTSQmiE6/SJYNHxpaLR7c2Yg7c737tn78u7JTt//uUy/UprUqjA8wwzaK8Qu?=
 =?us-ascii?Q?1V4KVIWlLNnTNtFpFigFLkQ7Rq0QcwRvyAUsqWeJ5J7/tQG1PFVz3bLejWtN?=
 =?us-ascii?Q?rVTPrrxdXkH9P6uv/1SYH4L0KVCw6PiCD/rOpEVc/Th+tcz10t7TSAw/R7hR?=
 =?us-ascii?Q?lJuBWHsfzJKcozL27NmiK+CXQyogcVHw5W1pqfGUGA1bzMWV8+zl155JbJ+s?=
 =?us-ascii?Q?+1ym52xtccQ9K6FOZgJmWKqqcrf5OVZWPhoCoTxus8h95B3RM12o+yl+nR5i?=
 =?us-ascii?Q?Yp3TKaK69WTh+iL31/eQwbByodF3fZDMFy+pQm0gcyxpyE7IYT6P+LB1CPwX?=
 =?us-ascii?Q?30GnB18pQeDSb5nC4X46MR6NXoQp7GpTSER9CyuKK4WuJW/x11gyy/ANZ7eS?=
 =?us-ascii?Q?KqG7/IGIdEdm8XD+VPAODGXIyZLDBNwk8Dh1HJVKbsCDHyyh8G6g3iovmPCj?=
 =?us-ascii?Q?4tRQpJioSAsUro/iq4sJS+Sce53gzCW1i2iYk4AinpZZIpWcEuAxkq3w8m3J?=
 =?us-ascii?Q?t7frFfrZ+xSJYcZBiL7bmysdfe5vgrdnanXmIq+EW1htK0N2aS+0/Fq6rR+V?=
 =?us-ascii?Q?fZL5CI4qaDJoAtycEcUJKSz020GotTPiS9YGtkDhL/KHn+0p53i9glpkSdL4?=
 =?us-ascii?Q?32ZhMtdBKqk1Pw/F5WsDXRD6V3o2hNK4b2qigOam7TlF5KHxdfXdULK5KsNY?=
 =?us-ascii?Q?ZoiIzXOA/g=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6c0285f-24f7-4678-0dd3-08da37615dee
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2022 17:27:35.6864
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jtDq43GjWPmVkdQ3tgON6ehPLtxFpI4fSw0qh/oboNd8KKvyVDfXDHTG5CTQeK/t
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3243
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 13, 2022 at 03:15:04PM -0400, Matthew Rosato wrote:
> @@ -136,3 +137,56 @@ int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device *vdev,
>  
>  	return ret;
>  }
> +
> +static int vfio_pci_zdev_group_notifier(struct notifier_block *nb,
> +					unsigned long action, void *data)
> +{
> +	struct zpci_dev *zdev = container_of(nb, struct zpci_dev, nb);
> +
> +	if (action == VFIO_GROUP_NOTIFY_SET_KVM) {
> +		if (!zdev)
> +			return NOTIFY_DONE;
> +
> +		if (data) {
> +			if (kvm_s390_pci_register_kvm(zdev, (struct kvm *)data))
> +				return NOTIFY_BAD;

The error codes are all ignored for this notifier chains, so this
seems like a problem.

> +		} else {
> +			if (kvm_s390_pci_unregister_kvm(zdev))
> +				return NOTIFY_BAD;

unregister really shouldn't fail.


> +		}
> +
> +	}
> +
> +	return NOTIFY_OK;
> +}
> +
> +void vfio_pci_zdev_open(struct vfio_pci_core_device *vdev)
> +{
> +	unsigned long events = VFIO_GROUP_NOTIFY_SET_KVM;
> +	struct zpci_dev *zdev = to_zpci(vdev->pdev);
> +
> +	if (!zdev)
> +		return;
> +
> +	zdev->nb.notifier_call = vfio_pci_zdev_group_notifier;
> +
> +	vfio_register_notifier(vdev->vdev.dev, VFIO_GROUP_NOTIFY,
> +			       &events, &zdev->nb);

Normally you'd want to do what is kvm_s390_pci_register_kvm() here,
where a failure can be propogated but then you have a race condition
with the kvm.

Blech, maybe it is time to just fix this race condition permanently,
what do you think? (I didn't even compile it)

diff --git a/drivers/gpu/drm/i915/gvt/gvt.h b/drivers/gpu/drm/i915/gvt/gvt.h
index 2af4c83e733c6c..633acfcf76bf23 100644
--- a/drivers/gpu/drm/i915/gvt/gvt.h
+++ b/drivers/gpu/drm/i915/gvt/gvt.h
@@ -227,8 +227,6 @@ struct intel_vgpu {
 	struct mutex cache_lock;
 
 	struct notifier_block iommu_notifier;
-	struct notifier_block group_notifier;
-	struct kvm *kvm;
 	struct work_struct release_work;
 	atomic_t released;
 
diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
index 7655ffa97d5116..655d47c65470d5 100644
--- a/drivers/gpu/drm/i915/gvt/kvmgt.c
+++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
@@ -761,23 +761,6 @@ static int intel_vgpu_iommu_notifier(struct notifier_block *nb,
 	return NOTIFY_OK;
 }
 
-static int intel_vgpu_group_notifier(struct notifier_block *nb,
-				     unsigned long action, void *data)
-{
-	struct intel_vgpu *vgpu =
-		container_of(nb, struct intel_vgpu, group_notifier);
-
-	/* the only action we care about */
-	if (action == VFIO_GROUP_NOTIFY_SET_KVM) {
-		vgpu->kvm = data;
-
-		if (!data)
-			schedule_work(&vgpu->release_work);
-	}
-
-	return NOTIFY_OK;
-}
-
 static bool __kvmgt_vgpu_exist(struct intel_vgpu *vgpu)
 {
 	struct intel_vgpu *itr;
@@ -789,7 +772,7 @@ static bool __kvmgt_vgpu_exist(struct intel_vgpu *vgpu)
 		if (!itr->attached)
 			continue;
 
-		if (vgpu->kvm == itr->kvm) {
+		if (vgpu->vfio_device.kvm == itr->vfio_device.kvm) {
 			ret = true;
 			goto out;
 		}
@@ -806,7 +789,6 @@ static int intel_vgpu_open_device(struct vfio_device *vfio_dev)
 	int ret;
 
 	vgpu->iommu_notifier.notifier_call = intel_vgpu_iommu_notifier;
-	vgpu->group_notifier.notifier_call = intel_vgpu_group_notifier;
 
 	events = VFIO_IOMMU_NOTIFY_DMA_UNMAP;
 	ret = vfio_register_notifier(vfio_dev, VFIO_IOMMU_NOTIFY, &events,
@@ -817,38 +799,30 @@ static int intel_vgpu_open_device(struct vfio_device *vfio_dev)
 		goto out;
 	}
 
-	events = VFIO_GROUP_NOTIFY_SET_KVM;
-	ret = vfio_register_notifier(vfio_dev, VFIO_GROUP_NOTIFY, &events,
-				     &vgpu->group_notifier);
-	if (ret != 0) {
-		gvt_vgpu_err("vfio_register_notifier for group failed: %d\n",
-			ret);
-		goto undo_iommu;
-	}
-
 	ret = -EEXIST;
 	if (vgpu->attached)
-		goto undo_register;
+		goto undo_iommu;
 
 	ret = -ESRCH;
-	if (!vgpu->kvm || vgpu->kvm->mm != current->mm) {
+	if (!vgpu->vfio_device.kvm ||
+	    vgpu->vfio_device.kvm->mm != current->mm) {
 		gvt_vgpu_err("KVM is required to use Intel vGPU\n");
-		goto undo_register;
+		goto undo_iommu;
 	}
 
 	ret = -EEXIST;
 	if (__kvmgt_vgpu_exist(vgpu))
-		goto undo_register;
+		goto undo_iommu;
 
 	vgpu->attached = true;
-	kvm_get_kvm(vgpu->kvm);
 
 	kvmgt_protect_table_init(vgpu);
 	gvt_cache_init(vgpu);
 
 	vgpu->track_node.track_write = kvmgt_page_track_write;
 	vgpu->track_node.track_flush_slot = kvmgt_page_track_flush_slot;
-	kvm_page_track_register_notifier(vgpu->kvm, &vgpu->track_node);
+	kvm_page_track_register_notifier(vgpu->vfio_device.kvm,
+					 &vgpu->track_node);
 
 	debugfs_create_ulong(KVMGT_DEBUGFS_FILENAME, 0444, vgpu->debugfs,
 			     &vgpu->nr_cache_entries);
@@ -858,10 +832,6 @@ static int intel_vgpu_open_device(struct vfio_device *vfio_dev)
 	atomic_set(&vgpu->released, 0);
 	return 0;
 
-undo_register:
-	vfio_unregister_notifier(vfio_dev, VFIO_GROUP_NOTIFY,
-				 &vgpu->group_notifier);
-
 undo_iommu:
 	vfio_unregister_notifier(vfio_dev, VFIO_IOMMU_NOTIFY,
 				 &vgpu->iommu_notifier);
@@ -898,21 +868,15 @@ static void __intel_vgpu_release(struct intel_vgpu *vgpu)
 	drm_WARN(&i915->drm, ret,
 		 "vfio_unregister_notifier for iommu failed: %d\n", ret);
 
-	ret = vfio_unregister_notifier(&vgpu->vfio_device, VFIO_GROUP_NOTIFY,
-				       &vgpu->group_notifier);
-	drm_WARN(&i915->drm, ret,
-		 "vfio_unregister_notifier for group failed: %d\n", ret);
-
 	debugfs_remove(debugfs_lookup(KVMGT_DEBUGFS_FILENAME, vgpu->debugfs));
 
-	kvm_page_track_unregister_notifier(vgpu->kvm, &vgpu->track_node);
-	kvm_put_kvm(vgpu->kvm);
+	kvm_page_track_unregister_notifier(vgpu->vfio_device.kvm,
+					   &vgpu->track_node);
 	kvmgt_protect_table_destroy(vgpu);
 	gvt_cache_destroy(vgpu);
 
 	intel_vgpu_release_msi_eventfd_ctx(vgpu);
 
-	vgpu->kvm = NULL;
 	vgpu->attached = false;
 }
 
@@ -1649,6 +1613,7 @@ static const struct attribute_group *intel_vgpu_groups[] = {
 };
 
 static const struct vfio_device_ops intel_vgpu_dev_ops = {
+	.flags		= VFIO_DEVICE_NEEDS_KVM,
 	.open_device	= intel_vgpu_open_device,
 	.close_device	= intel_vgpu_close_device,
 	.read		= intel_vgpu_read,
@@ -1713,7 +1678,7 @@ static struct mdev_driver intel_vgpu_mdev_driver = {
 
 int intel_gvt_page_track_add(struct intel_vgpu *info, u64 gfn)
 {
-	struct kvm *kvm = info->kvm;
+	struct kvm *kvm = info->vfio_device.kvm;
 	struct kvm_memory_slot *slot;
 	int idx;
 
@@ -1743,7 +1708,7 @@ int intel_gvt_page_track_add(struct intel_vgpu *info, u64 gfn)
 
 int intel_gvt_page_track_remove(struct intel_vgpu *info, u64 gfn)
 {
-	struct kvm *kvm = info->kvm;
+	struct kvm *kvm = info->vfio_device.kvm;
 	struct kvm_memory_slot *slot;
 	int idx;
 
diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index e8914024f5b1af..f378f809d8a00d 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -1284,25 +1284,6 @@ static void vfio_ap_mdev_unset_kvm(struct ap_matrix_mdev *matrix_mdev)
 	}
 }
 
-static int vfio_ap_mdev_group_notifier(struct notifier_block *nb,
-				       unsigned long action, void *data)
-{
-	int notify_rc = NOTIFY_OK;
-	struct ap_matrix_mdev *matrix_mdev;
-
-	if (action != VFIO_GROUP_NOTIFY_SET_KVM)
-		return NOTIFY_OK;
-
-	matrix_mdev = container_of(nb, struct ap_matrix_mdev, group_notifier);
-
-	if (!data)
-		vfio_ap_mdev_unset_kvm(matrix_mdev);
-	else if (vfio_ap_mdev_set_kvm(matrix_mdev, data))
-		notify_rc = NOTIFY_DONE;
-
-	return notify_rc;
-}
-
 static struct vfio_ap_queue *vfio_ap_find_queue(int apqn)
 {
 	struct device *dev;
@@ -1402,11 +1383,7 @@ static int vfio_ap_mdev_open_device(struct vfio_device *vdev)
 	unsigned long events;
 	int ret;
 
-	matrix_mdev->group_notifier.notifier_call = vfio_ap_mdev_group_notifier;
-	events = VFIO_GROUP_NOTIFY_SET_KVM;
-
-	ret = vfio_register_notifier(vdev, VFIO_GROUP_NOTIFY, &events,
-				     &matrix_mdev->group_notifier);
+	ret = vfio_ap_mdev_set_kvm(matrix_mdev, vdev->vdev.kvm);
 	if (ret)
 		return ret;
 
@@ -1415,12 +1392,11 @@ static int vfio_ap_mdev_open_device(struct vfio_device *vdev)
 	ret = vfio_register_notifier(vdev, VFIO_IOMMU_NOTIFY, &events,
 				     &matrix_mdev->iommu_notifier);
 	if (ret)
-		goto out_unregister_group;
+		goto err_kvm;
 	return 0;
 
-out_unregister_group:
-	vfio_unregister_notifier(vdev, VFIO_GROUP_NOTIFY,
-				 &matrix_mdev->group_notifier);
+err_kvm:
+	vfio_ap_mdev_unset_kvm(matrix_mdev);
 	return ret;
 }
 
@@ -1431,8 +1407,6 @@ static void vfio_ap_mdev_close_device(struct vfio_device *vdev)
 
 	vfio_unregister_notifier(vdev, VFIO_IOMMU_NOTIFY,
 				 &matrix_mdev->iommu_notifier);
-	vfio_unregister_notifier(vdev, VFIO_GROUP_NOTIFY,
-				 &matrix_mdev->group_notifier);
 	vfio_ap_mdev_unset_kvm(matrix_mdev);
 }
 
@@ -1481,6 +1455,7 @@ static ssize_t vfio_ap_mdev_ioctl(struct vfio_device *vdev,
 }
 
 static const struct vfio_device_ops vfio_ap_matrix_dev_ops = {
+	.flags = VFIO_DEVICE_NEEDS_KVM,
 	.open_device = vfio_ap_mdev_open_device,
 	.close_device = vfio_ap_mdev_close_device,
 	.ioctl = vfio_ap_mdev_ioctl,
diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
index 648fcaf8104abb..a26efd804d0df3 100644
--- a/drivers/s390/crypto/vfio_ap_private.h
+++ b/drivers/s390/crypto/vfio_ap_private.h
@@ -81,8 +81,6 @@ struct ap_matrix {
  * @node:	allows the ap_matrix_mdev struct to be added to a list
  * @matrix:	the adapters, usage domains and control domains assigned to the
  *		mediated matrix device.
- * @group_notifier: notifier block used for specifying callback function for
- *		    handling the VFIO_GROUP_NOTIFY_SET_KVM event
  * @iommu_notifier: notifier block used for specifying callback function for
  *		    handling the VFIO_IOMMU_NOTIFY_DMA_UNMAP even
  * @kvm:	the struct holding guest's state
@@ -94,7 +92,6 @@ struct ap_matrix_mdev {
 	struct vfio_device vdev;
 	struct list_head node;
 	struct ap_matrix matrix;
-	struct notifier_block group_notifier;
 	struct notifier_block iommu_notifier;
 	struct kvm *kvm;
 	crypto_hook pqap_hook;
diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index cfd797629a21ab..1c20bb5484afde 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -10,6 +10,7 @@
  * Author: Tom Lyon, pugs@cisco.com
  */
 
+#include "linux/kvm_host.h"
 #include <linux/cdev.h>
 #include <linux/compat.h>
 #include <linux/device.h>
@@ -1097,13 +1098,25 @@ static struct file *vfio_device_open(struct vfio_device *device)
 
 	down_write(&device->group->group_rwsem);
 	ret = vfio_device_assign_container(device);
-	up_write(&device->group->group_rwsem);
-	if (ret)
+	if (ret) {
+		up_write(&device->group->group_rwsem);
 		return ERR_PTR(ret);
+	}
+
+	if (device->ops->flags & VFIO_DEVICE_NEEDS_KVM)
+	{
+		if (!device->group->kvm) {
+			up_write(&device->group->group_rwsem);
+			goto err_unassign_container;
+		}
+		device->kvm = device->group->kvm;
+		kvm_get_kvm(device->kvm);
+	}
+	up_write(&device->group->group_rwsem);
 
 	if (!try_module_get(device->dev->driver->owner)) {
 		ret = -ENODEV;
-		goto err_unassign_container;
+		goto err_put_kvm;
 	}
 
 	mutex_lock(&device->dev_set->lock);
@@ -1147,6 +1160,11 @@ static struct file *vfio_device_open(struct vfio_device *device)
 	device->open_count--;
 	mutex_unlock(&device->dev_set->lock);
 	module_put(device->dev->driver->owner);
+err_put_kvm:
+	if (device->kvm) {
+		kvm_put_kvm(device->kvm);
+		device->kvm = NULL;
+	}
 err_unassign_container:
 	vfio_device_unassign_container(device);
 	return ERR_PTR(ret);
@@ -1344,6 +1362,10 @@ static int vfio_device_fops_release(struct inode *inode, struct file *filep)
 
 	module_put(device->dev->driver->owner);
 
+	if (device->kvm) {
+		kvm_put_kvm(device->kvm);
+		device->kvm = NULL;
+	}
 	vfio_device_unassign_container(device);
 
 	vfio_device_put(device);
@@ -1748,8 +1770,8 @@ EXPORT_SYMBOL_GPL(vfio_file_enforced_coherent);
  * @file: VFIO group file
  * @kvm: KVM to link
  *
- * The kvm pointer will be forwarded to all the vfio_device's attached to the
- * VFIO file via the VFIO_GROUP_NOTIFY_SET_KVM notifier.
+ * When a VFIO device is first opened the KVM will be available in
+ * device->kvm if VFIO_DEVICE_NEEDS_KVM is set.
  */
 void vfio_file_set_kvm(struct file *file, struct kvm *kvm)
 {
@@ -1760,8 +1782,6 @@ void vfio_file_set_kvm(struct file *file, struct kvm *kvm)
 
 	down_write(&group->group_rwsem);
 	group->kvm = kvm;
-	blocking_notifier_call_chain(&group->notifier,
-				     VFIO_GROUP_NOTIFY_SET_KVM, kvm);
 	up_write(&group->group_rwsem);
 }
 EXPORT_SYMBOL_GPL(vfio_file_set_kvm);
@@ -2061,42 +2081,6 @@ static int vfio_unregister_iommu_notifier(struct vfio_group *group,
 	return ret;
 }
 
-static int vfio_register_group_notifier(struct vfio_group *group,
-					unsigned long *events,
-					struct notifier_block *nb)
-{
-	int ret;
-	bool set_kvm = false;
-
-	if (*events & VFIO_GROUP_NOTIFY_SET_KVM)
-		set_kvm = true;
-
-	/* clear known events */
-	*events &= ~VFIO_GROUP_NOTIFY_SET_KVM;
-
-	/* refuse to continue if still events remaining */
-	if (*events)
-		return -EINVAL;
-
-	ret = blocking_notifier_chain_register(&group->notifier, nb);
-	if (ret)
-		return ret;
-
-	/*
-	 * The attaching of kvm and vfio_group might already happen, so
-	 * here we replay once upon registration.
-	 */
-	if (set_kvm) {
-		down_read(&group->group_rwsem);
-		if (group->kvm)
-			blocking_notifier_call_chain(&group->notifier,
-						     VFIO_GROUP_NOTIFY_SET_KVM,
-						     group->kvm);
-		up_read(&group->group_rwsem);
-	}
-	return 0;
-}
-
 int vfio_register_notifier(struct vfio_device *device,
 			   enum vfio_notify_type type, unsigned long *events,
 			   struct notifier_block *nb)
@@ -2112,9 +2096,6 @@ int vfio_register_notifier(struct vfio_device *device,
 	case VFIO_IOMMU_NOTIFY:
 		ret = vfio_register_iommu_notifier(group, events, nb);
 		break;
-	case VFIO_GROUP_NOTIFY:
-		ret = vfio_register_group_notifier(group, events, nb);
-		break;
 	default:
 		ret = -EINVAL;
 	}
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 45b287826ce686..aaf120b9c080b7 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -36,6 +36,7 @@ struct vfio_device {
 	struct vfio_device_set *dev_set;
 	struct list_head dev_set_list;
 	unsigned int migration_flags;
+	struct kvm *kvm;
 
 	/* Members below here are private, not for driver use */
 	refcount_t refcount;
@@ -44,6 +45,10 @@ struct vfio_device {
 	struct list_head group_next;
 };
 
+enum {
+	VFIO_DEVICE_NEEDS_KVM = 1,
+};
+
 /**
  * struct vfio_device_ops - VFIO bus driver device callbacks
  *
@@ -72,6 +77,7 @@ struct vfio_device {
  */
 struct vfio_device_ops {
 	char	*name;
+	unsigned int flags;
 	int	(*open_device)(struct vfio_device *vdev);
 	void	(*close_device)(struct vfio_device *vdev);
 	ssize_t	(*read)(struct vfio_device *vdev, char __user *buf,
@@ -155,15 +161,11 @@ extern int vfio_dma_rw(struct vfio_device *device, dma_addr_t user_iova,
 /* each type has independent events */
 enum vfio_notify_type {
 	VFIO_IOMMU_NOTIFY = 0,
-	VFIO_GROUP_NOTIFY = 1,
 };
 
 /* events for VFIO_IOMMU_NOTIFY */
 #define VFIO_IOMMU_NOTIFY_DMA_UNMAP	BIT(0)
 
-/* events for VFIO_GROUP_NOTIFY */
-#define VFIO_GROUP_NOTIFY_SET_KVM	BIT(0)
-
 extern int vfio_register_notifier(struct vfio_device *device,
 				  enum vfio_notify_type type,
 				  unsigned long *required_events,
