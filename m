Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68CD2644E3E
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 22:56:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbiLFV4D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 16:56:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbiLFV4A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 16:56:00 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58C3D490B0
        for <kvm@vger.kernel.org>; Tue,  6 Dec 2022 13:55:59 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B6LIYlv011102;
        Tue, 6 Dec 2022 21:55:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2022-7-12;
 bh=78/rBblz1yKfIbn4QyGk6ASEjWpqQ+byNXWNtsswFmA=;
 b=joEUZxhdsoG+6Q57HWZXsSO9HgPz4muO5xaILD66UZIxLGvlgOcQ2dkQwBcIPSmIi0kv
 z8bElnt5l4aa193+NCg02vxvldXzY4O6RRrE7i1eH/KKmbOIXNWl8YLy+UERaDxQd+O3
 exPwJs160JxzK8G/EfZdBJ+HFxoUbVMu54UVwUJyQIptnDIER+jR13vYveEppjWqh/pq
 XBLiA0QrsvuSrPkS8CW4TtWzOfWnt38QDAlEDidUZIygW6jz18k/54J1Qr25K2OoAfed
 xexuQNFTtXreKORIQAbrksFFWhvEfLjaGduBst0DxT7rHpNogDr3gtPBUyhywBMUCGL9 rw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m7yeqrsk6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Dec 2022 21:55:57 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B6LM3mr033256;
        Tue, 6 Dec 2022 21:55:56 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3maa7b2m9x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Dec 2022 21:55:56 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2B6Lts0n038701;
        Tue, 6 Dec 2022 21:55:55 GMT
Received: from ca-dev63.us.oracle.com (ca-dev63.us.oracle.com [10.211.8.221])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3maa7b2m8v-4;
        Tue, 06 Dec 2022 21:55:55 +0000
From:   Steve Sistare <steven.sistare@oracle.com>
To:     kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Steve Sistare <steven.sistare@oracle.com>
Subject: [PATCH V1 3/8] vfio: close dma owner
Date:   Tue,  6 Dec 2022 13:55:48 -0800
Message-Id: <1670363753-249738-4-git-send-email-steven.sistare@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1670363753-249738-1-git-send-email-steven.sistare@oracle.com>
References: <1670363753-249738-1-git-send-email-steven.sistare@oracle.com>
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-06_12,2022-12-06_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 phishscore=0 malwarescore=0 spamscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212060184
X-Proofpoint-GUID: pCssBng9EO5wvGZ8jRv60DU7r-_MazAS
X-Proofpoint-ORIG-GUID: pCssBng9EO5wvGZ8jRv60DU7r-_MazAS
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Define a new vfio_iommu_driver_ops method named close_dma_owner, called
when a task closes its mm (ie, exit or exec).  This allows the driver to
check if the task owns any dma mappings, and take appropriate action,
such as unpinning pages.  This guarantees that pages do not remain pinned
if the task leaks vfio descriptors to another process and then exits
or execs.

Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
---
 drivers/vfio/container.c | 146 +++++++++++++++++++++++++++++++++++++++++++++++
 drivers/vfio/vfio.h      |   1 +
 2 files changed, 147 insertions(+)

diff --git a/drivers/vfio/container.c b/drivers/vfio/container.c
index 5bfd10d..b660adc 100644
--- a/drivers/vfio/container.c
+++ b/drivers/vfio/container.c
@@ -10,6 +10,7 @@
 #include <linux/capability.h>
 #include <linux/iommu.h>
 #include <linux/miscdevice.h>
+#include <linux/mman.h>
 #include <linux/vfio.h>
 #include <uapi/linux/vfio.h>
 
@@ -22,6 +23,13 @@ struct vfio_container {
 	struct vfio_iommu_driver	*iommu_driver;
 	void				*iommu_data;
 	bool				noiommu;
+	struct list_head		task_list;
+	struct mutex			task_lock;
+};
+
+struct vfio_task {
+	struct task_struct		*task;
+	struct list_head		task_next;
 };
 
 static struct vfio {
@@ -330,6 +338,136 @@ static long vfio_ioctl_set_iommu(struct vfio_container *container,
 	return ret;
 }
 
+/*
+ * Maintain a list of tasks that have mapped dma regions.
+ */
+
+static void vfio_add_task(struct vfio_container *container)
+{
+	struct vfio_task *vftask = kzalloc(sizeof(*vftask), GFP_KERNEL);
+
+	vftask->task = get_task_struct(current->group_leader);
+	list_add(&vftask->task_next, &container->task_list);
+}
+
+static bool vfio_has_task(struct vfio_container *container)
+{
+	struct vfio_task *vftask;
+
+	list_for_each_entry(vftask, &container->task_list, task_next) {
+		if (vftask->task == current->group_leader)
+			return true;
+	}
+	return false;
+}
+
+static void vfio_remove_task(struct vfio_container *container)
+{
+	struct task_struct *task = current->group_leader;
+	struct vfio_task *vftask;
+
+	list_for_each_entry(vftask, &container->task_list, task_next) {
+		if (vftask->task == task) {
+			put_task_struct(task);
+			list_del(&vftask->task_next);
+			return;
+		}
+	}
+	WARN_ONCE(1, "%s pid %d not found\n", __func__, task->pid);
+}
+
+static int vfio_canary_create(struct file *filep);
+
+static int vfio_register_dma_task(struct vfio_container *container,
+				  struct file *filep)
+{
+	int ret = 0;
+
+	mutex_lock(&container->task_lock);
+
+	if (vfio_has_task(container))
+		goto out_unlock;
+	ret = vfio_canary_create(filep);
+	if (ret)
+		goto out_unlock;
+
+	vfio_add_task(container);
+
+out_unlock:
+	mutex_unlock(&container->task_lock);
+	return ret;
+}
+
+static void vfio_unregister_dma_task(struct vfio_container *container)
+{
+	struct vfio_iommu_driver *driver = container->iommu_driver;
+
+	mutex_lock(&container->task_lock);
+	vfio_remove_task(container);
+	mutex_unlock(&container->task_lock);
+
+	if (driver && driver->ops->close_dma_owner)
+		driver->ops->close_dma_owner(container->iommu_data);
+}
+
+/*
+ * Create a per-task vma that detects when an address space closes, by getting
+ * a vm_operations_struct close callback.
+ */
+
+static int vfio_canary_create(struct file *filep)
+{
+	unsigned long vaddr = vm_mmap(filep, 0, PAGE_SIZE, 0, MAP_PRIVATE, 0);
+
+	if (!vaddr)
+		return -ENOMEM;
+	else if (IS_ERR_VALUE(vaddr))
+		return (int)vaddr;
+	else
+		return 0;
+}
+
+static void vfio_canary_open(struct vm_area_struct *vma)
+{
+	/*
+	 * This vma is being dup'd after fork.  We don't have the new task yet,
+	 * so not useful.  Ignore it on close.
+	 */
+	vma->vm_private_data = NULL;
+}
+
+static void vfio_canary_close(struct vm_area_struct *vma)
+{
+	struct vfio_container *container = vma->vm_private_data;
+
+	if (container) {
+		vfio_unregister_dma_task(container);
+		vfio_container_put(container);
+	}
+}
+
+static vm_fault_t vfio_canary_fault(struct vm_fault *vmf)
+{
+	/* No need for access to the mapped canary */
+	return VM_FAULT_SIGBUS;
+}
+
+static const struct vm_operations_struct vfio_canary_mmap_ops = {
+	.open = vfio_canary_open,
+	.close = vfio_canary_close,
+	.fault = vfio_canary_fault,
+};
+
+static int vfio_fops_mmap(struct file *filep, struct vm_area_struct *vma)
+{
+	struct vfio_container *container = filep->private_data;
+
+	vfio_container_get(container);
+	vma->vm_private_data = container;
+	vma->vm_ops = &vfio_canary_mmap_ops;
+	return 0;
+}
+
 static long vfio_fops_unl_ioctl(struct file *filep,
 				unsigned int cmd, unsigned long arg)
 {
@@ -351,6 +489,11 @@ static long vfio_fops_unl_ioctl(struct file *filep,
 	case VFIO_SET_IOMMU:
 		ret = vfio_ioctl_set_iommu(container, arg);
 		break;
+	case VFIO_IOMMU_MAP_DMA:
+		ret = vfio_register_dma_task(container, filep);
+		if (ret)
+			return ret;
+		fallthrough;
 	default:
 		driver = container->iommu_driver;
 		data = container->iommu_data;
@@ -372,6 +515,8 @@ static int vfio_fops_open(struct inode *inode, struct file *filep)
 
 	INIT_LIST_HEAD(&container->group_list);
 	init_rwsem(&container->group_lock);
+	INIT_LIST_HEAD(&container->task_list);
+	mutex_init(&container->task_lock);
 	kref_init(&container->kref);
 
 	filep->private_data = container;
@@ -396,6 +541,7 @@ static int vfio_fops_release(struct inode *inode, struct file *filep)
 	.release	= vfio_fops_release,
 	.unlocked_ioctl	= vfio_fops_unl_ioctl,
 	.compat_ioctl	= compat_ptr_ioctl,
+	.mmap		= vfio_fops_mmap,
 };
 
 struct vfio_container *vfio_container_from_file(struct file *file)
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index 8a439c6..0cf3cfe 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -92,6 +92,7 @@ struct vfio_iommu_driver_ops {
 				  void *data, size_t count, bool write);
 	struct iommu_domain *(*group_iommu_domain)(void *iommu_data,
 						   struct iommu_group *group);
+	void		(*close_dma_owner)(void *iommu_data);
 };
 
 struct vfio_iommu_driver {
-- 
1.8.3.1

