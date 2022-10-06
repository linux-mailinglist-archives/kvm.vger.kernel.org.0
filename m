Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E4565F663B
	for <lists+kvm@lfdr.de>; Thu,  6 Oct 2022 14:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230376AbiJFMkt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Oct 2022 08:40:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230285AbiJFMkp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Oct 2022 08:40:45 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E442792DD
        for <kvm@vger.kernel.org>; Thu,  6 Oct 2022 05:40:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EUHdjPRZDdk76Opq2Gf4LdX12liGbqg+VDHY5/Hu46lay1E1u4y2ShamLHtmkFSmBlIVGyLBXxDqW3KgjuU0r9lZ+eVNvm5gw97yvujYTI0Ne5PDgdEoR3843ck44GTZNtdBQ63om07BaNIcMuSj2nPn+2+q0hy6JfXRr5c/XsjCiY9JISs8lOZAAQe2zz2luh5VXewsmbXl4Msc2h7exeqmIY6s5PsrcRKyA9ko+y2u0NLX7eH9uHGDexn7bqfJTeXLgikHkxq0dBGbwtsjkRng2ZjP24xlUhICRqRKE025FOoH3oRGCl39k90V3ZdrK/xiKYOz8OvMaaEzo83bPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GPeYey+wQk5oSYfRFhs/ej27RVjzM3dkWX+s2SBGnI4=;
 b=FoeHCjFeTZQxXZ1/xdVIBiso24WEzb2K4IOzhvMJ+Omg4X5EZw63UBaUBGoY1bYhFRb/GcFKC6tFjp+7WyZvoEt1zGciO4K8puo57ITPyYcDDqgBXNLSxelM2ohCfXcutVwLcV9V0ml9zfacQtolE33gEZe9ijH0CqBwPEgLwxKonWR0AltCybU0j+dtDeaA31GP9nJHcqNW+1KZKuf2TDGO/U+urNMcIxcMPoilxbZzWXDdyVZStfouqKrCX1vCB759a9SL3UCtDSEG5JemhSeITJ4q+yaGxj6j1r7TwyjMDeA5qnH4U84EvS7wzZermDK/DsbOz/gS/RxL1u6sKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GPeYey+wQk5oSYfRFhs/ej27RVjzM3dkWX+s2SBGnI4=;
 b=Fha/JkPVG6G8IU6Togk+6OW+Kvg7wUBcAxkeDfQwmfHTIL9fhtdwGV17bZ7mWCM/xrbj2uvUAYyKo9DjL1ooAxvzWJTb8vxQzoqo6ngY7b+AQRzeSMxdABnSKdkIeCto5AG+tQ+HwAemGloEHYrQQ7OwWgE2SjYDMLwfepRt6vblX6WcpjwcRcvDFw+llobnL7/d8JVk3kj2WHhxki54Xc8KxkbT2JJmUZXv8MIoU3f/G0OboY92d+uLGeAM1Q1UJG+B1evOOqDkC+097sIquFqhFRnDikJ/XYMtQbJNAdrFyS7mbMZC20mIb1bl9jocKSTwDENuvAIY3+VFQWUytA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB5736.namprd12.prod.outlook.com (2603:10b6:510:1e3::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.28; Thu, 6 Oct
 2022 12:40:39 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de%5]) with mapi id 15.20.5676.032; Thu, 6 Oct 2022
 12:40:39 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Qian Cai <cai@lca.pw>, Eric Farman <farman@linux.ibm.com>,
        Joerg Roedel <jroedel@suse.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Yi Liu <yi.l.liu@intel.com>
Subject: [PATCH 1/3] vfio: Add vfio_file_is_group()
Date:   Thu,  6 Oct 2022 09:40:36 -0300
Message-Id: <1-v1-90bf0950c42c+39-vfio_group_disassociate_jgg@nvidia.com>
In-Reply-To: <0-v1-90bf0950c42c+39-vfio_group_disassociate_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR15CA0007.namprd15.prod.outlook.com
 (2603:10b6:208:1b4::20) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB5736:EE_
X-MS-Office365-Filtering-Correlation-Id: 95c62873-2a19-4c0b-dfda-08daa797f92e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: //l3fUzgUyL4fIEVctWObD+DdXl7AmUv5GmWEQRrJBiu0T/DiRX1qx2xXxW6K4j1dUPHne/mvWOMFBwy+Hx6l1WEUDWjH+kRjoLOR7xt38BqwQGNVpIzCm9xRqlUN+Zf6mkTi4Bvj3S2Yl+4VsBoijLm8RKglg2V/ZA7i+n0gjlUFVq9yeachhxCHURKTKDOMfmnf1mFD0PXd7mdpEGt5DRirRKQqGSrwVrREgIB4Exum8pX8WXvUjE/KsG7nbGRNLO+/o2bDVmXCeND4Tgo+Dvsz8210xeS7iDkvIghP9XlayAO36LrD7t7cfnoyIJpUT6rDOYopYRZ5c9h4zG3zUxJCCjaJaC5X6St1k9m5d/5Hi95j+lx82qOKhUBHE68Hg3/o/19/1q89vaKw31PAFUXxwh5DELVILdi/sZjp9LTlAK3ua8v49TJGfcEi0JpEFlbZt+3sK/lT8UR94H2UA+xfv/aSnlx0WJ2k1isKHm5SkIRI9anGlMMVDFeh4sn6jP2nAmapV5aAeCBUKQ/f3QSpPKRkiytGSeJw5ZSEJoSenSM0N5VykXa7bmVgcWUlTjpYpCMEdW3mP9svKlZPm1h2QccBxuqYUXKjnTVIh1PzeRaAjgBEifxpEueNRhzfqWo4c8xWSUYnaZSKlJZpwagVGYDMJi5mBloZIGyP0P3O1eSMoJ2DNgqNjx2ex3wFTOvBP/pDZOjX96tg9rzJGfReBSouc4Zk+giE8uk5ZEiKSDL2pHvCg7mG9qB6PGH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(39860400002)(366004)(376002)(396003)(451199015)(2616005)(2906002)(38100700002)(54906003)(66556008)(66476007)(4326008)(110136005)(8676002)(316002)(8936002)(41300700001)(186003)(83380400001)(66946007)(6512007)(7416002)(26005)(6506007)(86362001)(5660300002)(6666004)(6486002)(36756003)(478600001)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dxLuFuMXE7UWQiSvElRJVNOWevR2LDFH2oNcitqvNuKEDMzzwTVdioF5EP96?=
 =?us-ascii?Q?nvfYVhCzVsVLHSQH237cMiV7rgCpBmQAOQeEla+9IDtbm4qy0IVjx61bFR6U?=
 =?us-ascii?Q?FhUeOd+JgAURg5Gip7GZ7RNJGDg9l7HLR74A2yoI/xSjyddbuN9Qc20GpHSB?=
 =?us-ascii?Q?BjhkxeJ2T/po0rZgVkimPEB7dyw7vTiklrobDTEzL1Yb72bSmVlwqiGmUqiY?=
 =?us-ascii?Q?ep/WRqnA/NawlQvnp4hvCKSSKNIOpgadqwuOeJt/aHjVhHoCQkWIzhBW/s2L?=
 =?us-ascii?Q?WuPJ9GrpwOyj/qrngvcbvQS+4xU9Tl0QJVP4Ue8V66YCqXxdqOLeSmjZruuW?=
 =?us-ascii?Q?gwmZgOIEUkoTP9TyxA+bqyjjIjlBMdC7QF8j3loNyS8Q15TOKFOsdsqhmcHr?=
 =?us-ascii?Q?WBf9K0yERbGS1mkoQSddbF9G9IO4AC2FUN1jDn7qXqmm1dbtmoY+7ckBr6l8?=
 =?us-ascii?Q?iAaA645Al3apywX4evm/wdemSW6/KchjQTiifZHa8JGOg4yc3+owmpxWrk4y?=
 =?us-ascii?Q?y+m8yl9Yzbtd1udmE1rYLY2raqakKHIi+zHw6BPWzUAHbGuLqhgmw6APOFwL?=
 =?us-ascii?Q?xK+cY05pHjdrqrrdmeQGaYgq2a5uY94gOpQ98lCbqwsbeWJzVWjlkUUJ2TNf?=
 =?us-ascii?Q?tAYTsHxNtaZu410t5sd9pDtwe/wqHvxOHWi2bHh66AqbrNjv3GO6GB/+Nd3D?=
 =?us-ascii?Q?mi1uOvlinGYhajYuDd29EgjFjfbkFqO0f24cbmRMe9S936PKQKTa1j+FrSik?=
 =?us-ascii?Q?GXsWtNavwcfqihhTLQq7Te5rMIZ2LY0xivR6Cbw7203W60emu4jwimNaaaN7?=
 =?us-ascii?Q?Y8ZqkBgcHriQf+rqPvZ24Vvgzv6kWyD2j6qcHWOTbk+uoP0Fm9ikoxSGpJ2C?=
 =?us-ascii?Q?tI/zsdtKAbJraiVEd102B9vxI/U6cu8+fuvJk8XHNAEMVq+WOfLufdzfTzqf?=
 =?us-ascii?Q?O0t9zO8qADmvh6+OckkCY/vWaiktaP+bnTNldWzS+jt8g6lDQ9hZ+DQ9uXbc?=
 =?us-ascii?Q?H+q4BFReIxf/Xl1t1mgcJ1Vwv1ma4IEuxW/5QvwR1krnX5WXXPjR58wZJuYP?=
 =?us-ascii?Q?54ekjTsbZDrWRRWP7FSA6RSvpeRggrLLDsd/hhLbRP7PoZB5lvGZsBFTSXhS?=
 =?us-ascii?Q?yOkPOJOOgWRDN8hScfCy+Q7IPMQy0Pjv4I7rImFIu4M3mwZkJx6kbNgQipiS?=
 =?us-ascii?Q?4PNOBx8S8gao7mcO16HiSKZ58FMtgcMX8k5X1MbqKxLo3ana6rkqViO6zs/e?=
 =?us-ascii?Q?0v9wyv/TxIxZMfp57WrUG/RxDEkt+eeXB19D1rEj75AMR1q/oXH//CcYBnCO?=
 =?us-ascii?Q?OoDreEwlr7xAhtvaw59jAXNxP9UujBLLuUPDpSmOznuWFXharQ3mF8XOMuoz?=
 =?us-ascii?Q?nhUUVv8HvXC0sVKfBTcnedC59/MHF0dNXvLV1Ua/UgUWdaN7vLB+pipMvUVy?=
 =?us-ascii?Q?MTp+S7GreyfDwHLmAhe1ITzmsKkZ+GqgzS/2t9kiOg/bAYYGhTq/W3JYYpjP?=
 =?us-ascii?Q?LSPlPNLTdYEPvqahV5esoItdVf9HI+mY/Iahwk9+Cp0IxEC+e2UyLy7vepic?=
 =?us-ascii?Q?qxMhu4mwqtMRkkAFZLc=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95c62873-2a19-4c0b-dfda-08daa797f92e
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2022 12:40:38.9951
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X/KgoqmNjKBJ1ZVN/LtMqq0M/nCnQI/xBWLbAD6ouZtVJCgiPF+3tHEdynOpa5Hq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5736
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This replaces uses of vfio_file_iommu_group() which were only detecting if
the file is a VFIO file with no interest in the actual group.

The only remaning user of vfio_file_iommu_group() is in KVM for the SPAPR
stuff. It passes the iommu_group into the arch code through kvm for some
reason.

Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
Tested-by: Christian Borntraeger <borntraeger@de.ibm.com>
Tested-by: Eric Farman <farman@linux.ibm.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_core.c |  2 +-
 drivers/vfio/vfio_main.c         | 14 ++++++++++++++
 include/linux/vfio.h             |  1 +
 virt/kvm/vfio.c                  | 20 ++++++++++++++++++--
 4 files changed, 34 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 59a28251bb0b97..badc9d828cac20 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1313,7 +1313,7 @@ static int vfio_pci_ioctl_pci_hot_reset(struct vfio_pci_core_device *vdev,
 		}
 
 		/* Ensure the FD is a vfio group FD.*/
-		if (!vfio_file_iommu_group(file)) {
+		if (!vfio_file_is_group(file)) {
 			fput(file);
 			ret = -EINVAL;
 			break;
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 9207e6c0e3cb26..7866849be56ef6 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -1553,17 +1553,31 @@ static const struct file_operations vfio_device_fops = {
  * @file: VFIO group file
  *
  * The returned iommu_group is valid as long as a ref is held on the file.
+ * This function is deprecated, only the SPAPR path in kvm should call it.
  */
 struct iommu_group *vfio_file_iommu_group(struct file *file)
 {
 	struct vfio_group *group = file->private_data;
 
+	if (!IS_ENABLED(CONFIG_SPAPR_TCE_IOMMU))
+		return NULL;
+
 	if (file->f_op != &vfio_group_fops)
 		return NULL;
 	return group->iommu_group;
 }
 EXPORT_SYMBOL_GPL(vfio_file_iommu_group);
 
+/**
+ * vfio_file_is_group - True if the file is usable with VFIO aPIS
+ * @file: VFIO group file
+ */
+bool vfio_file_is_group(struct file *file)
+{
+	return file->f_op == &vfio_group_fops;
+}
+EXPORT_SYMBOL_GPL(vfio_file_is_group);
+
 /**
  * vfio_file_enforced_coherent - True if the DMA associated with the VFIO file
  *        is always CPU cache coherent
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index ee399a768070d0..e7cebeb875dd1a 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -199,6 +199,7 @@ int vfio_mig_get_next_state(struct vfio_device *device,
  * External user API
  */
 struct iommu_group *vfio_file_iommu_group(struct file *file);
+bool vfio_file_is_group(struct file *file);
 bool vfio_file_enforced_coherent(struct file *file);
 void vfio_file_set_kvm(struct file *file, struct kvm *kvm);
 bool vfio_file_has_dev(struct file *file, struct vfio_device *device);
diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
index ce1b01d02c5197..54aec3b0559c70 100644
--- a/virt/kvm/vfio.c
+++ b/virt/kvm/vfio.c
@@ -61,6 +61,23 @@ static bool kvm_vfio_file_enforced_coherent(struct file *file)
 	return ret;
 }
 
+static bool kvm_vfio_file_is_group(struct file *file)
+{
+	bool (*fn)(struct file *file);
+	bool ret;
+
+	fn = symbol_get(vfio_file_is_group);
+	if (!fn)
+		return false;
+
+	ret = fn(file);
+
+	symbol_put(vfio_file_is_group);
+
+	return ret;
+}
+
+#ifdef CONFIG_SPAPR_TCE_IOMMU
 static struct iommu_group *kvm_vfio_file_iommu_group(struct file *file)
 {
 	struct iommu_group *(*fn)(struct file *file);
@@ -77,7 +94,6 @@ static struct iommu_group *kvm_vfio_file_iommu_group(struct file *file)
 	return ret;
 }
 
-#ifdef CONFIG_SPAPR_TCE_IOMMU
 static void kvm_spapr_tce_release_vfio_group(struct kvm *kvm,
 					     struct kvm_vfio_group *kvg)
 {
@@ -136,7 +152,7 @@ static int kvm_vfio_group_add(struct kvm_device *dev, unsigned int fd)
 		return -EBADF;
 
 	/* Ensure the FD is a vfio group FD.*/
-	if (!kvm_vfio_file_iommu_group(filp)) {
+	if (!kvm_vfio_file_is_group(filp)) {
 		ret = -EINVAL;
 		goto err_fput;
 	}
-- 
2.37.3

