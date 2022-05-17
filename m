Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E6F652A836
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 18:37:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350997AbiEQQhK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 12:37:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351008AbiEQQg7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 12:36:59 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78E0431222;
        Tue, 17 May 2022 09:36:58 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24HGRHLu025840;
        Tue, 17 May 2022 16:36:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=jHug6eYZ6oI3KjAFYek7zWjl+7HvCUn/kgXXn1N8Iow=;
 b=Cg68QwtZUYKYlFb0MRw1idinUzjfvUX5raBX2Nq427UwAnf7DV15zunLzyxWgCUieG6w
 nqelTfKd1nzPKwtbBdqU3Q0v+7bEZemlayBy6O3X0zTQzXeH7bzuUllxg641qU0mELA7
 X7b57AVsXw/EPX7knus2/ohRqpfQi2WHdRNf9cbV+ZAE64u7OXlQjLaskcwDKgSpmTNp
 +A6M4HTtCZqEZsvB/y5HXbEPYEARrK+uKt+r0PMGH10kLTRaFH0IYfQUyu4Bk49w5bCX
 fCNgpdV9nvZy0ZStAGKjGn6Q9Tut2jQfe+DSWdZ1Vq8+ZginQq4PFnyrvW4nRukEio6H ZA== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g4f8807pt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 16:36:57 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24HGWmOT011858;
        Tue, 17 May 2022 16:36:55 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma01fra.de.ibm.com with ESMTP id 3g2428umwr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 16:36:55 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24HGN18Z54919490
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 16:23:01 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0749B11C058;
        Tue, 17 May 2022 16:36:52 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7F13C11C04A;
        Tue, 17 May 2022 16:36:51 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 17 May 2022 16:36:51 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, borntraeger@linux.ibm.com,
        imbrenda@linux.ibm.com
Subject: [PATCH v6 08/11] kvm: s390: Add KVM_CAP_S390_PROTECTED_DUMP
Date:   Tue, 17 May 2022 16:36:26 +0000
Message-Id: <20220517163629.3443-9-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220517163629.3443-1-frankja@linux.ibm.com>
References: <20220517163629.3443-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: YbjMqDCBs54Tqq831n-HYjrQvmhMc7cV
X-Proofpoint-ORIG-GUID: YbjMqDCBs54Tqq831n-HYjrQvmhMc7cV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-17_03,2022-05-17_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 bulkscore=0
 spamscore=0 priorityscore=1501 lowpriorityscore=0 impostorscore=0
 suspectscore=0 mlxscore=0 mlxlogscore=443 clxscore=1015 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205170101
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
index 1938756d4a32..99ce1aced86b 100644
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
+		r = is_prot_virt_host();
+
+		for (i = 0; i < ARRAY_SIZE(pv_cmds_dump); i++) {
+			if (!test_bit_inv(pv_cmds_dump[i],
+					  (unsigned long *)&uv_info.inst_calls_list)) {
+				r = 0;
+				break;
+			}
+		}
+		break;
+	}
 	default:
 		r = 0;
 	}
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 204b06e3a50b..108bc7b7a71b 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1144,6 +1144,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_S390_MEM_OP_EXTENSION 211
 #define KVM_CAP_PMU_CAPABILITY 212
 #define KVM_CAP_DISABLE_QUIRKS2 213
+#define KVM_CAP_S390_PROTECTED_DUMP 214
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.34.1

