Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 114ED52808F
	for <lists+kvm@lfdr.de>; Mon, 16 May 2022 11:10:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242193AbiEPJKM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 05:10:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242081AbiEPJJg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 05:09:36 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2CE522B31;
        Mon, 16 May 2022 02:09:35 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24G8kDAV023555;
        Mon, 16 May 2022 09:09:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=wCpXC1TxLIoay1mrqC0C1E/dHW2j4JjpG5XRQFjLLtA=;
 b=bLg6qwebOjei1/cEzG9EbLwc6Cu61bbg6+1u7E7XZ/lSitv6epVGmGgTdOmF7/zjQ+qb
 pfAkLzZxbBObZki5EtYdp+fA8erwJE8Xc1wuGxFshbIi2RQxTvXRrAYzCMK4xpdXLxzh
 xX6ldKooJzQqEhHGQ+PqOMfOi/LXd+BKtKXxkQbxNNg0LJB1ljzJZ48xQqYym1KPWwDI
 7hUPc2ZD7so8PdBLMDexo16ZrByZ26HwYL6QRkkiExc/T8qQmmPmoYpP3uwWmTu5g8Ku
 AGtj/qVAR3lSukdDlZq6OIwsiuzKJDhAwYePsu2RCe6f4pN2YKDxGjHFORS6/htJ4jMQ Gw== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g3kcv0ct0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 09:09:34 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24G98NXa011685;
        Mon, 16 May 2022 09:09:32 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma05fra.de.ibm.com with ESMTP id 3g24291tku-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 09:09:32 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24G99TSW22413644
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 May 2022 09:09:29 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B2D9442041;
        Mon, 16 May 2022 09:09:29 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3607F4204C;
        Mon, 16 May 2022 09:09:29 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 16 May 2022 09:09:29 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, borntraeger@linux.ibm.com,
        imbrenda@linux.ibm.com
Subject: [PATCH v5 08/10] kvm: s390: Add KVM_CAP_S390_PROTECTED_DUMP
Date:   Mon, 16 May 2022 09:08:15 +0000
Message-Id: <20220516090817.1110090-9-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220516090817.1110090-1-frankja@linux.ibm.com>
References: <20220516090817.1110090-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: eNLnR0E0SGAnEVcuL5XTrWlaTyPcJlun
X-Proofpoint-GUID: eNLnR0E0SGAnEVcuL5XTrWlaTyPcJlun
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-16_05,2022-05-13_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 clxscore=1015 impostorscore=0 bulkscore=0 malwarescore=0 suspectscore=0
 phishscore=0 adultscore=0 spamscore=0 mlxlogscore=449 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205160052
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The capability indicates dump support for protected VMs.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 20 ++++++++++++++++++++
 include/uapi/linux/kvm.h |  1 +
 2 files changed, 21 insertions(+)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index c0c848c84552..1d65235ed3d3 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -606,6 +606,26 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_S390_PROTECTED:
 		r = is_prot_virt_host();
 		break;
+	case KVM_CAP_S390_PROTECTED_DUMP: {
+		u64 pv_cmds_dump[] = {
+			BIT_UVC_CMD_DUMP_INIT,
+			BIT_UVC_CMD_DUMP_CONFIG_STOR_STATE,
+			BIT_UVC_CMD_DUMP_CPU,
+			BIT_UVC_CMD_DUMP_COMPLETE,
+		};
+		int i;
+
+		if (!is_prot_virt_host())
+			return 0;
+
+		r = 1;
+		for (i = 0; i < ARRAY_SIZE(pv_cmds_dump); i++) {
+			if (!test_bit_inv(pv_cmds_dump[i],
+					  (unsigned long *)&uv_info.inst_calls_list))
+				return 0;
+		}
+		break;
+	}
 	default:
 		r = 0;
 	}
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 0a8b57654ea7..ba8f2985a8c0 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1152,6 +1152,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_DISABLE_QUIRKS2 213
 /* #define KVM_CAP_VM_TSC_CONTROL 214 */
 #define KVM_CAP_SYSTEM_EVENT_DATA 215
+#define KVM_CAP_S390_PROTECTED_DUMP 216
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.34.1

