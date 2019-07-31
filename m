Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A75877D157
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2019 00:42:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729798AbfGaWln (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Jul 2019 18:41:43 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:18808 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729565AbfGaWlm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 31 Jul 2019 18:41:42 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6VMfath105628;
        Wed, 31 Jul 2019 18:41:36 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2u3hcrnuvy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 31 Jul 2019 18:41:36 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x6VMfZRJ105523;
        Wed, 31 Jul 2019 18:41:35 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2u3hcrnutx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 31 Jul 2019 18:41:35 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x6VMedS3023852;
        Wed, 31 Jul 2019 22:41:30 GMT
Received: from b01cxnp22035.gho.pok.ibm.com ([9.57.198.25])
        by ppma03dal.us.ibm.com with ESMTP id 2u0e871db5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 31 Jul 2019 22:41:29 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6VMfRTj52887844
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 31 Jul 2019 22:41:27 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0761C2805A;
        Wed, 31 Jul 2019 22:41:27 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3054328058;
        Wed, 31 Jul 2019 22:41:26 +0000 (GMT)
Received: from akrowiak-ThinkPad-P50.ibm.com (unknown [9.85.130.145])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTPS;
        Wed, 31 Jul 2019 22:41:26 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        frankja@linux.ibm.com, david@redhat.com, mjrosato@linux.ibm.com,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        pmorel@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH v5 6/7] s390: vfio-ap: add logging to vfio_ap driver
Date:   Wed, 31 Jul 2019 18:41:16 -0400
Message-Id: <1564612877-7598-7-git-send-email-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1564612877-7598-1-git-send-email-akrowiak@linux.ibm.com>
References: <1564612877-7598-1-git-send-email-akrowiak@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-31_11:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907310226
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Added two DBF log files for logging events and errors; one for the vfio_ap
driver, and one for each matrix mediated device.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_drv.c     |  34 +++++++
 drivers/s390/crypto/vfio_ap_ops.c     | 187 ++++++++++++++++++++++++++++++----
 drivers/s390/crypto/vfio_ap_private.h |  20 ++++
 3 files changed, 223 insertions(+), 18 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_drv.c b/drivers/s390/crypto/vfio_ap_drv.c
index d8da520ae1fa..04a77246c22a 100644
--- a/drivers/s390/crypto/vfio_ap_drv.c
+++ b/drivers/s390/crypto/vfio_ap_drv.c
@@ -22,6 +22,10 @@ MODULE_AUTHOR("IBM Corporation");
 MODULE_DESCRIPTION("VFIO AP device driver, Copyright IBM Corp. 2018");
 MODULE_LICENSE("GPL v2");
 
+uint dbglvl = 3;
+module_param(dbglvl, uint, 0444);
+MODULE_PARM_DESC(dbglvl, "VFIO_AP driver debug level.");
+
 static struct ap_driver vfio_ap_drv;
 
 struct ap_matrix_dev *matrix_dev;
@@ -158,6 +162,21 @@ static void vfio_ap_matrix_dev_destroy(void)
 	root_device_unregister(root_device);
 }
 
+static void vfio_ap_log_queues_in_use(struct ap_matrix_mdev *matrix_mdev,
+				  unsigned long *apm, unsigned long *aqm)
+{
+	unsigned long apid, apqi;
+
+	for_each_set_bit_inv(apid, apm, AP_DEVICES) {
+		for_each_set_bit_inv(apqi, aqm, AP_DOMAINS) {
+			VFIO_AP_DBF(matrix_dev, DBF_ERR,
+				    "queue %02lx.%04lx in use by mdev %s\n",
+				    apid, apqi,
+				    dev_name(mdev_dev(matrix_mdev->mdev)));
+		}
+	}
+}
+
 static bool vfio_ap_resource_in_use(unsigned long *apm, unsigned long *aqm)
 {
 	bool in_use = false;
@@ -179,6 +198,8 @@ static bool vfio_ap_resource_in_use(unsigned long *apm, unsigned long *aqm)
 			continue;
 
 		in_use = true;
+		vfio_ap_log_queues_in_use(matrix_mdev, apm_intrsctn,
+					  aqm_intrsctn);
 	}
 
 	mutex_unlock(&matrix_dev->lock);
@@ -186,6 +207,16 @@ static bool vfio_ap_resource_in_use(unsigned long *apm, unsigned long *aqm)
 	return in_use;
 }
 
+static int __init vfio_ap_debug_init(void)
+{
+	matrix_dev->dbf = debug_register(VFIO_AP_DRV_NAME, 1, 1,
+					 DBF_SPRINTF_MAX_ARGS * sizeof(long));
+	debug_register_view(matrix_dev->dbf, &debug_sprintf_view);
+	debug_set_level(matrix_dev->dbf, dbglvl);
+
+	return 0;
+}
+
 static int __init vfio_ap_init(void)
 {
 	int ret;
@@ -219,6 +250,8 @@ static int __init vfio_ap_init(void)
 		return ret;
 	}
 
+	vfio_ap_debug_init();
+
 	return 0;
 }
 
@@ -227,6 +260,7 @@ static void __exit vfio_ap_exit(void)
 	vfio_ap_mdev_unregister();
 	ap_driver_unregister(&vfio_ap_drv);
 	vfio_ap_matrix_dev_destroy();
+	debug_unregister(matrix_dev->dbf);
 }
 
 module_init(vfio_ap_init);
diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 0e748819abb6..1aa18eba43d0 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -167,17 +167,23 @@ static struct ap_queue_status vfio_ap_irq_disable(struct vfio_ap_queue *q)
 		case AP_RESPONSE_INVALID_ADDRESS:
 		default:
 			/* All cases in default means AP not operational */
-			WARN_ONCE(1, "%s: ap_aqic status %d\n", __func__,
-				  status.response_code);
 			goto end_free;
 		}
 	} while (retries--);
 
-	WARN_ONCE(1, "%s: ap_aqic status %d\n", __func__,
-		  status.response_code);
 end_free:
 	vfio_ap_free_aqic_resources(q);
 	q->matrix_mdev = NULL;
+	if (status.response_code) {
+		VFIO_AP_MDEV_DBF(q->matrix_mdev, DBF_WARN,
+			 "IRQ disable failed for queue %02x.%04x: status response code=%u\n",
+			 AP_QID_CARD(q->apqn), AP_QID_QUEUE(q->apqn),
+			 status.response_code);
+	} else {
+		VFIO_AP_MDEV_DBF(q->matrix_mdev, DBF_INFO,
+				 "IRQ disabled for queue %02x.%04x\n",
+				 AP_QID_CARD(q->apqn), AP_QID_QUEUE(q->apqn));
+	}
 	return status;
 }
 
@@ -215,6 +221,10 @@ static struct ap_queue_status vfio_ap_irq_enable(struct vfio_ap_queue *q,
 	case 1:
 		break;
 	default:
+		VFIO_AP_MDEV_DBF(q->matrix_mdev, DBF_ERR,
+				 "IRQ enable failed for queue %02x.%04x: vfio_pin_pages rc=%d\n",
+				 AP_QID_CARD(q->apqn), AP_QID_QUEUE(q->apqn),
+				 ret);
 		status.response_code = AP_RESPONSE_INVALID_ADDRESS;
 		return status;
 	}
@@ -235,16 +245,25 @@ static struct ap_queue_status vfio_ap_irq_enable(struct vfio_ap_queue *q,
 		vfio_ap_free_aqic_resources(q);
 		q->saved_pfn = g_pfn;
 		q->saved_isc = isc;
+		VFIO_AP_MDEV_DBF(q->matrix_mdev, DBF_INFO,
+				 "IRQ enabled for queue %02x.%04x",
+				 AP_QID_CARD(q->apqn), AP_QID_QUEUE(q->apqn));
 		break;
 	case AP_RESPONSE_OTHERWISE_CHANGED:
 		/* We could not modify IRQ setings: clear new configuration */
 		vfio_unpin_pages(mdev_dev(q->matrix_mdev->mdev), &g_pfn, 1);
 		kvm_s390_gisc_unregister(kvm, isc);
+		VFIO_AP_MDEV_DBF(q->matrix_mdev, DBF_WARN,
+				 "IRQ enable failed for queue %02x.%04x: status response code=%u",
+				 AP_QID_CARD(q->apqn), AP_QID_QUEUE(q->apqn),
+				 status.response_code);
 		break;
 	default:
-		pr_warn("%s: apqn %04x: response: %02x\n", __func__, q->apqn,
-			status.response_code);
 		vfio_ap_irq_disable(q);
+		VFIO_AP_MDEV_DBF(q->matrix_mdev, DBF_WARN,
+				 "IRQ enable failed for queue %02x.%04x: status response code=%u",
+				 AP_QID_CARD(q->apqn), AP_QID_QUEUE(q->apqn),
+				 status.response_code);
 		break;
 	}
 
@@ -321,8 +340,29 @@ static void vfio_ap_matrix_init(struct ap_config_info *info,
 	matrix->adm_max = info->apxa ? info->Nd : 15;
 }
 
+static int vfio_ap_mdev_debug_init(struct ap_matrix_mdev *matrix_mdev)
+{
+	int ret;
+
+	matrix_mdev->dbf = debug_register(dev_name(mdev_dev(matrix_mdev->mdev)),
+					  1, 1,
+					  DBF_SPRINTF_MAX_ARGS * sizeof(long));
+
+	if (!matrix_mdev->dbf)
+		return -ENOMEM;
+
+	ret = debug_register_view(matrix_mdev->dbf, &debug_sprintf_view);
+	if (ret)
+		return ret;
+
+	debug_set_level(matrix_mdev->dbf, dbglvl);
+
+	return 0;
+}
+
 static int vfio_ap_mdev_create(struct kobject *kobj, struct mdev_device *mdev)
 {
+	int ret;
 	struct ap_matrix_mdev *matrix_mdev;
 
 	if ((atomic_dec_if_positive(&matrix_dev->available_instances) < 0))
@@ -335,6 +375,13 @@ static int vfio_ap_mdev_create(struct kobject *kobj, struct mdev_device *mdev)
 	}
 
 	matrix_mdev->mdev = mdev;
+
+	ret = vfio_ap_mdev_debug_init(matrix_mdev);
+	if (ret) {
+		kfree(matrix_mdev);
+		return ret;
+	}
+
 	vfio_ap_matrix_init(&matrix_dev->info, &matrix_mdev->matrix);
 	mdev_set_drvdata(mdev, matrix_mdev);
 	matrix_mdev->pqap_hook.hook = handle_pqap;
@@ -350,14 +397,19 @@ static int vfio_ap_mdev_remove(struct mdev_device *mdev)
 {
 	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
 
-	if (matrix_mdev->kvm)
+	if (matrix_mdev->kvm) {
+		VFIO_AP_MDEV_DBF(matrix_mdev, DBF_ERR,
+				 "remove rejected, mdev in use by %s",
+				 matrix_mdev->kvm->debugfs_dentry->d_iname);
 		return -EBUSY;
+	}
 
 	mutex_lock(&matrix_dev->lock);
 	vfio_ap_mdev_reset_queues(mdev);
 	list_del(&matrix_mdev->node);
 	mutex_unlock(&matrix_dev->lock);
 
+	debug_unregister(matrix_mdev->dbf);
 	kfree(matrix_mdev);
 	mdev_set_drvdata(mdev, NULL);
 	atomic_inc(&matrix_dev->available_instances);
@@ -406,6 +458,22 @@ static struct attribute_group *vfio_ap_mdev_type_groups[] = {
 	NULL,
 };
 
+static void vfio_ap_mdev_log_sharing_error(struct ap_matrix_mdev *logdev,
+					   const char *assigned_to,
+					   unsigned long *apm,
+					   unsigned long *aqm)
+{
+	unsigned long apid, apqi;
+
+	for_each_set_bit_inv(apid, apm, AP_DEVICES) {
+		for_each_set_bit_inv(apqi, aqm, AP_DOMAINS) {
+			VFIO_AP_MDEV_DBF(logdev, DBF_ERR,
+					 "queue %02lx.%04lx already assigned to %s\n",
+					 apid, apqi, assigned_to);
+		}
+	}
+}
+
 /**
  * vfio_ap_mdev_verify_no_sharing
  *
@@ -448,22 +516,39 @@ static int vfio_ap_mdev_verify_no_sharing(struct ap_matrix_mdev *matrix_mdev,
 		if (!bitmap_and(aqm, mdev_aqm, lstdev->matrix.aqm, AP_DOMAINS))
 			continue;
 
+		vfio_ap_mdev_log_sharing_error(matrix_mdev,
+					       dev_name(mdev_dev(lstdev->mdev)),
+					       apm, aqm);
+
 		return -EADDRINUSE;
 	}
 
 	return 0;
 }
 
-static int vfio_ap_mdev_validate_masks(struct ap_matrix_mdev *matrix_mdev,
+static int vfio_ap_mdev_validate_masks(struct ap_matrix_mdev *logdev,
 				       unsigned long *apm, unsigned long *aqm)
 {
-	int ret;
+	int ret = 0;
+	unsigned long apid, apqi;
+
+	for_each_set_bit_inv(apid, apm, AP_DEVICES) {
+		for_each_set_bit_inv(apqi, aqm, AP_DEVICES) {
+			if (!ap_owned_by_def_drv(apid, apqi))
+				continue;
+
+			VFIO_AP_MDEV_DBF(logdev, DBF_ERR,
+					 "queue %02lx.%04lx owned by zcrypt\n",
+					 apid, apqi);
+
+			ret = -EADDRNOTAVAIL;
+		}
+	}
 
-	ret = ap_apqn_in_matrix_owned_by_def_drv(apm, aqm);
 	if (ret)
-		return (ret == 1) ? -EADDRNOTAVAIL : ret;
+		return ret;
 
-	return vfio_ap_mdev_verify_no_sharing(matrix_mdev, apm, aqm);
+	return vfio_ap_mdev_verify_no_sharing(logdev, apm, aqm);
 }
 
 static void vfio_ap_mdev_update_crycb(struct ap_matrix_mdev *matrix_mdev)
@@ -536,13 +621,20 @@ static ssize_t assign_adapter_store(struct device *dev,
 					  matrix_mdev->matrix.aqm);
 	if (ret) {
 		mutex_unlock(&matrix_dev->lock);
+		VFIO_AP_MDEV_DBF(matrix_mdev, DBF_ERR,
+				 "failed to assign adapter %lu(%#02lx)\n",
+				 apid, apid);
 		return ret;
 	}
 
+
 	set_bit_inv(apid, matrix_mdev->matrix.apm);
 	vfio_ap_mdev_update_crycb(matrix_mdev);
 	mutex_unlock(&matrix_dev->lock);
 
+	VFIO_AP_MDEV_DBF(matrix_mdev, DBF_INFO,
+			 "assigned adapter %lu(%#02lx)\n", apid, apid);
+
 	return count;
 }
 static DEVICE_ATTR_WO(assign_adapter);
@@ -587,6 +679,9 @@ static ssize_t unassign_adapter_store(struct device *dev,
 	vfio_ap_mdev_update_crycb(matrix_mdev);
 	mutex_unlock(&matrix_dev->lock);
 
+	VFIO_AP_MDEV_DBF(matrix_mdev, DBF_INFO,
+			 "unassigned adapter %lu(%#02lx)\n", apid, apid);
+
 	return count;
 }
 static DEVICE_ATTR_WO(unassign_adapter);
@@ -651,6 +746,9 @@ static ssize_t assign_domain_store(struct device *dev,
 					  aqm);
 	if (ret) {
 		mutex_unlock(&matrix_dev->lock);
+		VFIO_AP_MDEV_DBF(matrix_mdev, DBF_ERR,
+				 "failed to assign domain %lu(%#04lx)\n",
+				 apqi, apqi);
 		return ret;
 	}
 
@@ -658,6 +756,9 @@ static ssize_t assign_domain_store(struct device *dev,
 	vfio_ap_mdev_update_crycb(matrix_mdev);
 	mutex_unlock(&matrix_dev->lock);
 
+	VFIO_AP_MDEV_DBF(matrix_mdev, DBF_INFO,
+			 "assigned domain %lu(%#04lx)\n", apqi, apqi);
+
 	return count;
 }
 static DEVICE_ATTR_WO(assign_domain);
@@ -703,6 +804,9 @@ static ssize_t unassign_domain_store(struct device *dev,
 	vfio_ap_mdev_update_crycb(matrix_mdev);
 	mutex_unlock(&matrix_dev->lock);
 
+	VFIO_AP_MDEV_DBF(matrix_mdev, DBF_INFO,
+			 "unassigned domain %lu(%#02lx)\n", apqi, apqi);
+
 	return count;
 }
 static DEVICE_ATTR_WO(unassign_domain);
@@ -746,6 +850,9 @@ static ssize_t assign_control_domain_store(struct device *dev,
 	vfio_ap_mdev_update_crycb(matrix_mdev);
 	mutex_unlock(&matrix_dev->lock);
 
+	VFIO_AP_MDEV_DBF(matrix_mdev, DBF_INFO,
+			 "assigned control domain %lu(%#02lx)\n", id, id);
+
 	return count;
 }
 static DEVICE_ATTR_WO(assign_control_domain);
@@ -789,6 +896,10 @@ static ssize_t unassign_control_domain_store(struct device *dev,
 	vfio_ap_mdev_update_crycb(matrix_mdev);
 	mutex_unlock(&matrix_dev->lock);
 
+	VFIO_AP_MDEV_DBF(matrix_mdev, DBF_INFO,
+			 "unassigned control domain %lu(%#02lx)\n",
+			 domid, domid);
+
 	return count;
 }
 static DEVICE_ATTR_WO(unassign_control_domain);
@@ -910,6 +1021,9 @@ static int vfio_ap_mdev_set_kvm(struct ap_matrix_mdev *matrix_mdev,
 	list_for_each_entry(m, &matrix_dev->mdev_list, node) {
 		if ((m != matrix_mdev) && (m->kvm == kvm)) {
 			mutex_unlock(&matrix_dev->lock);
+			VFIO_AP_MDEV_DBF(matrix_mdev, DBF_ERR,
+					 "KVM already set for mdev %s\n",
+					 dev_name(mdev_dev(m->mdev)));
 			return -EPERM;
 		}
 	}
@@ -919,6 +1033,8 @@ static int vfio_ap_mdev_set_kvm(struct ap_matrix_mdev *matrix_mdev,
 	kvm->arch.crypto.pqap_hook = &matrix_mdev->pqap_hook;
 	mutex_unlock(&matrix_dev->lock);
 
+	VFIO_AP_MDEV_DBF(matrix_mdev, DBF_INFO, "KVM set for mdev\n");
+
 	return 0;
 }
 
@@ -972,8 +1088,11 @@ static int vfio_ap_mdev_group_notifier(struct notifier_block *nb,
 		return NOTIFY_DONE;
 
 	/* If there is no CRYCB pointer, then we can't copy the masks */
-	if (!matrix_mdev->kvm->arch.crypto.crycbd)
+	if (!matrix_mdev->kvm->arch.crypto.crycbd) {
+		VFIO_AP_MDEV_DBF(matrix_mdev, DBF_INFO,
+				 "Failed to set CRYCB masks: missing CRYCBD\n");
 		return NOTIFY_DONE;
+	}
 
 	kvm_arch_crypto_set_masks(matrix_mdev->kvm, matrix_mdev->matrix.apm,
 				  matrix_mdev->matrix.aqm,
@@ -1013,9 +1132,10 @@ static void vfio_ap_mdev_wait_for_qempty(ap_qid_t qid)
 			msleep(20);
 			break;
 		default:
-			pr_warn("%s: tapq response %02x waiting for queue %04x.%02x empty\n",
-				__func__, status.response_code,
-				AP_QID_CARD(qid), AP_QID_QUEUE(qid));
+			WARN_ONCE(1,
+				  "%s: tapq response %02x waiting for queue %04x.%02x empty\n",
+				  __func__, status.response_code,
+				  AP_QID_CARD(qid), AP_QID_QUEUE(qid));
 			return;
 		}
 	} while (--retry);
@@ -1062,8 +1182,16 @@ static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev)
 		for_each_set_bit_inv(apqi, matrix_mdev->matrix.aqm,
 				     matrix_mdev->matrix.aqm_max + 1) {
 			ret = vfio_ap_mdev_reset_queue(apid, apqi);
-			if (ret)
+			if (ret) {
 				rc = ret;
+				VFIO_AP_MDEV_DBF(matrix_mdev, DBF_ERR,
+						 "queue %02lx.%04lx reset failed: rc=%d\n",
+						 apid, apqi, ret);
+			} else {
+				VFIO_AP_MDEV_DBF(matrix_mdev, DBF_INFO,
+						 "queue %02lx.%04lx reset\n",
+						 apid, apqi);
+			}
 
 			vfio_ap_irq_disable_apqn(AP_MKQID(apid, apqi));
 		}
@@ -1089,6 +1217,9 @@ static int vfio_ap_mdev_open(struct mdev_device *mdev)
 				     &events, &matrix_mdev->group_notifier);
 	if (ret) {
 		module_put(THIS_MODULE);
+		VFIO_AP_MDEV_DBF(matrix_mdev, DBF_ERR,
+				 "failed to open mdev fd: VFIO_GROUP_NOTIFY notifier registration failed with rc=%d\n",
+				 ret);
 		return ret;
 	}
 
@@ -1096,12 +1227,19 @@ static int vfio_ap_mdev_open(struct mdev_device *mdev)
 	events = VFIO_IOMMU_NOTIFY_DMA_UNMAP;
 	ret = vfio_register_notifier(mdev_dev(mdev), VFIO_IOMMU_NOTIFY,
 				     &events, &matrix_mdev->iommu_notifier);
-	if (!ret)
+	if (!ret) {
+		VFIO_AP_MDEV_DBF(matrix_mdev, DBF_DEBUG,
+				 "opened mdev fd: guest started\n");
 		return ret;
+	}
 
+	VFIO_AP_MDEV_DBF(matrix_mdev, DBF_ERR,
+			 "failed to open mdev fd: VFIO_IOMMU_NOTIFY notifier registration failed with rc=%d\n",
+			 ret);
 	vfio_unregister_notifier(mdev_dev(mdev), VFIO_GROUP_NOTIFY,
 				 &matrix_mdev->group_notifier);
 	module_put(THIS_MODULE);
+
 	return ret;
 }
 
@@ -1124,6 +1262,9 @@ static void vfio_ap_mdev_release(struct mdev_device *mdev)
 	vfio_unregister_notifier(mdev_dev(mdev), VFIO_GROUP_NOTIFY,
 				 &matrix_mdev->group_notifier);
 	module_put(THIS_MODULE);
+
+	VFIO_AP_MDEV_DBF(matrix_mdev, DBF_DEBUG,
+			 "released mdev fd: guest terminated\n");
 }
 
 static int vfio_ap_mdev_get_device_info(unsigned long arg)
@@ -1202,6 +1343,11 @@ int vfio_ap_mdev_probe_queue(struct ap_queue *queue)
 	q->apqn = queue->qid;
 	q->saved_isc = VFIO_AP_ISC_INVALID;
 
+	VFIO_AP_DBF(matrix_dev, DBF_DEBUG,
+		    "queue %02x.%04x bound to %s\n",
+		    AP_QID_CARD(queue->qid), AP_QID_QUEUE(queue->qid),
+		    VFIO_AP_DRV_NAME);
+
 	return 0;
 }
 
@@ -1217,4 +1363,9 @@ void vfio_ap_mdev_remove_queue(struct ap_queue *queue)
 	vfio_ap_mdev_reset_queue(apid, apqi);
 	vfio_ap_irq_disable(q);
 	kfree(q);
+
+	VFIO_AP_DBF(matrix_dev, DBF_DEBUG,
+		    "queue %02x.%04x unbound from %s\n",
+		    AP_QID_CARD(queue->qid), AP_QID_QUEUE(queue->qid),
+		    VFIO_AP_DRV_NAME);
 }
diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
index 5cc3c2ebf151..f717e43e10cf 100644
--- a/drivers/s390/crypto/vfio_ap_private.h
+++ b/drivers/s390/crypto/vfio_ap_private.h
@@ -24,6 +24,21 @@
 #define VFIO_AP_MODULE_NAME "vfio_ap"
 #define VFIO_AP_DRV_NAME "vfio_ap"
 
+#define DBF_ERR		3	/* error conditions   */
+#define DBF_WARN	4	/* warning conditions */
+#define DBF_INFO	5	/* informational      */
+#define DBF_DEBUG	6	/* for debugging only */
+
+#define DBF_SPRINTF_MAX_ARGS 5
+
+#define VFIO_AP_DBF(d_matrix_dev, ...) \
+	debug_sprintf_event(d_matrix_dev->dbf, ##__VA_ARGS__)
+
+#define VFIO_AP_MDEV_DBF(d_matrix_mdev, ...) \
+	debug_sprintf_event(d_matrix_mdev->dbf, ##__VA_ARGS__)
+
+extern uint dbglvl;
+
 /**
  * ap_matrix_dev - the AP matrix device structure
  * @device:	generic device structure associated with the AP matrix device
@@ -43,6 +58,7 @@ struct ap_matrix_dev {
 	struct list_head mdev_list;
 	struct mutex lock;
 	struct ap_driver  *vfio_ap_drv;
+	debug_info_t *dbf;
 };
 
 extern struct ap_matrix_dev *matrix_dev;
@@ -77,6 +93,9 @@ struct ap_matrix {
  * @group_notifier: notifier block used for specifying callback function for
  *		    handling the VFIO_GROUP_NOTIFY_SET_KVM event
  * @kvm:	the struct holding guest's state
+ * @pqap_hook:	handler for PQAP instruction
+ * @mdev:	the matrix mediated device
+ * @dbf:	the debug info log
  */
 struct ap_matrix_mdev {
 	struct list_head node;
@@ -86,6 +105,7 @@ struct ap_matrix_mdev {
 	struct kvm *kvm;
 	struct kvm_s390_module_hook pqap_hook;
 	struct mdev_device *mdev;
+	debug_info_t *dbf;
 };
 
 extern int vfio_ap_mdev_register(void);
-- 
2.7.4

