Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3D5D501B35
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 20:47:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344765AbiDNSsx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 14:48:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236852AbiDNSsl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 14:48:41 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2087.outbound.protection.outlook.com [40.107.220.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD28CDB498
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 11:46:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h4zoa6/th40iCi7eYivr7a8dEdSNTp6b5NlIlmL1dyMeh94hS3KOanys1oNvTYX7Fa8oMFxo01aqSMhrs9dd51FgbWDku1gStrdtHy3tZdAsGF3mhLgDd+Oml+0DttAijWS5Nnh8iyKazDbTZ2ciUayUF3SUzPOtd9WPv2kM3BCPB4M3UlLev69jXRnEZNZ1dVzE+AK+1EFzNaWfYriDrrti3sY6iLXjXsrIC6IhIgy7xv+x7WyLE4tvixdwTp2D1A6gPqaUOFgD97FnIfjWwrg7Fu6Iq4qAcJjmlNHKw99ywHDzBMkz0C19G3TgoFlR8/Kx+kTErY/mCbuKyilkNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7CLxETMMldOr4VkojCs1afE53FK2CKd42RuE+PWxnUU=;
 b=hGVLlfvSAVCa4eubmmOSqMZf49qR2xhzQu0hk+gv7Wud4C5t1w7RXZC/uF5Ar0qKdkY4JxsopyemEELNjI+w9CEfy1ezk6TV5QoNY/DOw4eDVzsm03lOtZk0zeWdYJOukb13J0O7fDpsAb0gfKP41O26K1hUFA7DqtBq1u+w/xKxi/NY9NrENmN2QhmBTq+YXQiwrmUln2b4xf2EnltCitEkABQ5ERgJS15NtlrxHV82PB1VS+Aqq4VEixxDgHld0YvAmvr/CkAvZsIhMoeVPHTR7ubpiStN4qICT1rufkllizbf9O1oQCAw9/ccTBr9mAo7IHg3VwDtljxuA7ksMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7CLxETMMldOr4VkojCs1afE53FK2CKd42RuE+PWxnUU=;
 b=tPXtrxf1pVp4c69uZc2JWbbgu1sUoLJk/KToIUqF47jTcwel2PSLaroIpDN9mv2l2NclT0dboC9v+l1Q+06iu+IESRUWgSPnRTxbubrepItG3hqjsr9aG9fLgJXuqZpj5y2dCcVv0G8MBgkQxmKw8kDNiWCHg4Mvlmq3TUc2ES/m2rHcFnoBd+92LhlBzTVi4nnasPO4DXyKX3aPzrJSIiSD4aLIbZ4zHsb/hGjCU5fEphpa1wyVjvSOXXlUbfssZ4Nm9cGV+3yravYi58CZ0Jhi6x5J3m4un5wgfUUEIUSuhSOvaTaXkJSETuQs7JnCtQpbsf/MMsqhw088PecwpA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BL1PR12MB5350.namprd12.prod.outlook.com (2603:10b6:208:31d::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Thu, 14 Apr
 2022 18:46:12 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%5]) with mapi id 15.20.5164.020; Thu, 14 Apr 2022
 18:46:12 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Eric Auger <eric.auger@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Yi Liu <yi.l.liu@intel.com>
Subject: [PATCH 04/10] vfio: Use a struct of function pointers instead of a many symbol_get()'s
Date:   Thu, 14 Apr 2022 15:46:03 -0300
Message-Id: <4-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com>
In-Reply-To: <0-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P221CA0020.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:2c5::7) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 30394e9a-690b-47b1-ed23-08da1e470bef
X-MS-TrafficTypeDiagnostic: BL1PR12MB5350:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB5350B23B4420623DCB0C271FC2EF9@BL1PR12MB5350.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6dHusWEm7uSe7FcVkbzXY6v1/Mt//eQtS6+aqkaPxL5Rax7wKHrArO9Gx7zf8NaTokw6EGddtwXyGaGH0Kiihd+QybLs3XtocyVmZNVnnbFywufvGkfdoRp20wMC2Mwkz9rf2aMbjlwYwvlswey1V52epYrI5DzO/Ot8WXYQpnmaTuskHciHARTlpEPDZBgGWolUYgnf/MEWkP3romd0dRLNZvWlQyMWcGqj1sHjQXboVoXs+6/KZFASpae/wxlIP8VYRXkw6CFB7b+FD/ngmxfWfY0dpYWUS5RPgQGdodLcAK/4wvJDLq3LtARj5DU6V5Gq2f4btZu1WkutFLxCJnhnukln8cDHdt9U429Uw6kZQcvpvBVA65/8wX9asfjNZSkF36NUZ3csZt9kS3EB3axBTAY68GAIpTsqKOHbYiDCiVkb53sKvWb70UCw9y60deqz+uI2Z5uxcjEdrKny5Kg0BqH58u1hlcUMt0/3h1cOZF1z9gufwoaRwrXfdynkA7RYd4b0qP9myDBozAAqKn1wBqSOBbuMrUyUr2iWC2kzJC/NXaS3e6XRaps9XEIIZrI3LwKn1MAdSm9xPzCQDDzicgfgGyMZmC9dDV0qaXY7ksMuPiKth3XoBcO5DkibRhKK2f8rPIArs0TzWWQnOQ0TJIMCIrt1LAAUBY+LbPVywzUlr9CHW1yTYIKvTlad
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2616005)(86362001)(186003)(38100700002)(83380400001)(110136005)(66946007)(66476007)(66556008)(8936002)(4326008)(8676002)(316002)(5660300002)(54906003)(26005)(6506007)(6512007)(6666004)(36756003)(2906002)(508600001)(6486002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TGaZdQU6s2p+n2jvCqPMWjEtYZu4BpbMKH5D9Uy7+rWF4K2fKvbj577W4Rtd?=
 =?us-ascii?Q?M3oYQCg4JpbDTq3TFa+lnmZfqgl2/2cOrNP0FmN4RcThJJMxO0qE20JAuv0E?=
 =?us-ascii?Q?b6Z47Tsjxgt3XcfNeJo888qWyCjEEZxYZqId1GgRL+3TQ6R8E2W1Nsj7WUi8?=
 =?us-ascii?Q?5d+CS9lhK39T2CdeEOAhzWx8GFGVMd+oPjJuqQtxebArqvWDLquEXmu0BM/w?=
 =?us-ascii?Q?GkFs4u67TYjiK3NkcTYagvXWFIVxhsNb8zrpJ6Uy61eIdPtTS/cA/PY51Bjr?=
 =?us-ascii?Q?zs+yuOiL2O8QDl/MQdQnPLna+v1Y7KGCBIg7hyKNNiiQHig4O8+6x1withDG?=
 =?us-ascii?Q?9w8dMLVifNIbx3nGQVoftUUiIHJztKfhYVvbhqiMts0msoFUWyR2LqVOgq7x?=
 =?us-ascii?Q?uhqRy3SgrZj5EEE8prwj79/ZlnPAExpW6xDG6xJNqrhI7xHQJJxMN3CZpuIR?=
 =?us-ascii?Q?ubOMzqF4iFBBS7wa0uxuJhabKutv9MpHbdX4z75ha7RwScxF5N35jNDgUnlX?=
 =?us-ascii?Q?QqA+OXIRg8WcbvzYsNI9FSHR25/4V04Dvzu9Ag015eWrXs+vDmLaGL8wzERD?=
 =?us-ascii?Q?dDhR4Ybz0efhdGagbDyPwEoy1ojzds1rfm9SQm6mVmE5u4uU4g27vqXyO8xM?=
 =?us-ascii?Q?Y9iA5Gn/I3Z/7Dx/a5qY0IdGa+FwkpMtxfsKiwU/o/pPGCwNk1R20kNbi95Z?=
 =?us-ascii?Q?6B6ahYwjCpnPhYjuwOpaG0vjRDQvBDm8y/L6EtLdb213/kSxjzs4GsjQE9b6?=
 =?us-ascii?Q?w7EhVc26B/KzsA6srjKsb1VeDTlcOeKA4aNyCkMad1ZwWoHhSiOAj7peNNIq?=
 =?us-ascii?Q?rysdAD4+6Ln2U5ervOtS5yGpEQgWJUdla75fXVBKCLWLgLqr+QBHiOX1SzYp?=
 =?us-ascii?Q?EqF9F6YWb+bMO5rvRJSjPiPEDjemJH6AbQTPsnf6ldPRApQINVJ3hS1A7RKb?=
 =?us-ascii?Q?gBNnHxiYAdPAkZWmpXKWHefE1R3QgA2Z4qIrpczmWNtw+AvDXMC5w1Vptl8t?=
 =?us-ascii?Q?9AhKDl+uwWg1PPGUlYGY1aFqPYPkrPL0NaaSQdfdvvvC9yNkrcn4cczLge6u?=
 =?us-ascii?Q?vntODPD6fTuwnUEdOcrhkg0p1/Svl5ENLBWTUnX2xfGRmFe4QwJSwupv95ad?=
 =?us-ascii?Q?iBO7PAyts+bL4GVHA9YARtipQxC/w5hnYspb80/4OBZT/VKKlSOLlMtl9vNH?=
 =?us-ascii?Q?S0+k04z/oqYdhd2MdcYh9JD7kgEBuyEOgYoNrXzS3haQRIk5O5poREKhTFus?=
 =?us-ascii?Q?uXIu2E0P1Yk2JwqzCyFjina1cz88jKjR4zqZNdIk6YEJ/pQY+xUumRuf4qoG?=
 =?us-ascii?Q?MY/Qr5A/OKgvEIh1NiIqPSzHZFfR0N4F8sQ8iWt+m1Rk3LTlb19llttTsfqE?=
 =?us-ascii?Q?Td5jW36/1FsMkRBLEa3+yCUyGK2VQOFUAn80KxwPabuwCR5F5m7kEHTq26yj?=
 =?us-ascii?Q?1KfvOvOG08Rv/Vw4XWYsr5vgkkAHfGJciEw1Q+7iRJpO1vIP2N2phLv/1AlW?=
 =?us-ascii?Q?MqnQ0ZOugklKl+9Eku+thLGK95CJryKhT8Rnq/G0648NhOKiP0GP5ClMqARZ?=
 =?us-ascii?Q?12E/INW3bTt0zj3XABmc/90GbMrQHKBlzDhjs/VYpnn5CdU6BVHr+rRKvNLT?=
 =?us-ascii?Q?mPQEhlArpb5I0Ism2Idgl73ugY6NNXob5UXqMq80RSTaQErgcT7DDA0Kwb9L?=
 =?us-ascii?Q?gbXYQmLDyxL42ydSxIAWB/hNMu15hPnzcHIMY9ZRiQjiyQnGNplczWzZwHkH?=
 =?us-ascii?Q?uouNcV+Z1g=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30394e9a-690b-47b1-ed23-08da1e470bef
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2022 18:46:12.0318
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K5mtGNm3iXhHnMdQzvis1mJZBmoPCPDIo0yBvffDOOsOkCwUK7s9nZNFYfFh2H1y
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5350
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm and VFIO need to be coupled together however neither is willing to
tolerate a direct module dependency. Instead when kvm is given a VFIO FD
it uses many symbol_get()'s to access VFIO.

Provide a single VFIO function vfio_file_get_ops() which validates the
given struct file * is a VFIO file and then returns a struct of ops.

Following patches will redo each of the symbol_get() calls into an
indirection through this ops struct.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio.c  | 19 +++++++++++++++++++
 include/linux/vfio.h |  3 +++
 virt/kvm/vfio.c      | 14 ++++++++++++++
 3 files changed, 36 insertions(+)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index a4555014bd1e72..93508f6a8beda5 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -2013,6 +2013,25 @@ long vfio_external_check_extension(struct vfio_group *group, unsigned long arg)
 }
 EXPORT_SYMBOL_GPL(vfio_external_check_extension);
 
+static const struct vfio_file_ops vfio_file_group_ops = {
+};
+
+/**
+ * vfio_file_get_ops - Return a struct of function pointers to use with the file
+ * @filep: VFIO file to return pointers for
+ *
+ * This API exists to allow KVM to call into VFIO without tightly coupling the
+ * VFIO and KVM modules together. KVM will call this using symbol_get() and from
+ * then on will call VFIO through the returned function pointers.
+ */
+const struct vfio_file_ops *vfio_file_get_ops(struct file *filep)
+{
+	if (filep->f_op != &vfio_group_fops)
+		return ERR_PTR(-EINVAL);
+	return &vfio_file_group_ops;
+}
+EXPORT_SYMBOL_GPL(vfio_file_get_ops);
+
 /*
  * Sub-module support
  */
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 66dda06ec42d1b..409bbf817206cc 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -138,6 +138,8 @@ int vfio_mig_get_next_state(struct vfio_device *device,
 /*
  * External user API
  */
+struct vfio_file_ops {
+};
 extern struct vfio_group *vfio_group_get_external_user(struct file *filep);
 extern void vfio_group_put_external_user(struct vfio_group *group);
 extern struct vfio_group *vfio_group_get_external_user_from_dev(struct device
@@ -147,6 +149,7 @@ extern bool vfio_external_group_match_file(struct vfio_group *group,
 extern int vfio_external_user_iommu_id(struct vfio_group *group);
 extern long vfio_external_check_extension(struct vfio_group *group,
 					  unsigned long arg);
+const struct vfio_file_ops *vfio_file_get_ops(struct file *filep);
 
 #define VFIO_PIN_PAGES_MAX_ENTRIES	(PAGE_SIZE/sizeof(unsigned long))
 
diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
index 7e1793a1f5f1fd..254d8c18378163 100644
--- a/virt/kvm/vfio.c
+++ b/virt/kvm/vfio.c
@@ -34,6 +34,7 @@ static void kvm_spapr_tce_release_iommu_group(struct kvm *kvm,
 struct kvm_vfio_group {
 	struct list_head node;
 	struct file *filp;
+	const struct vfio_file_ops *ops;
 	struct vfio_group *vfio_group;
 };
 
@@ -196,6 +197,7 @@ static void kvm_vfio_update_coherency(struct kvm_device *dev)
 
 static int kvm_vfio_group_add(struct kvm_device *dev, unsigned int fd)
 {
+	const struct vfio_file_ops *(*fn)(struct file *filep);
 	struct kvm_vfio *kv = dev->private;
 	struct vfio_group *vfio_group;
 	struct kvm_vfio_group *kvg;
@@ -221,6 +223,18 @@ static int kvm_vfio_group_add(struct kvm_device *dev, unsigned int fd)
 		goto err_unlock;
 	}
 
+	fn = symbol_get(vfio_file_get_ops);
+	if (!fn) {
+		ret = -EINVAL;
+		goto err_free;
+	}
+	kvg->ops = fn(filp);
+	symbol_put(vfio_file_get_ops);
+	if (IS_ERR(kvg->ops)) {
+		ret = PTR_ERR(kvg->ops);
+		goto err_free;
+	}
+
 	vfio_group = kvm_vfio_group_get_external_user(filp);
 	if (IS_ERR(vfio_group)) {
 		ret = PTR_ERR(vfio_group);
-- 
2.35.1

