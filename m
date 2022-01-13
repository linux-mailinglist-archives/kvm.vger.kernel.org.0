Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E1AA48D7EF
	for <lists+kvm@lfdr.de>; Thu, 13 Jan 2022 13:29:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232141AbiAMM3s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jan 2022 07:29:48 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:44010 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234618AbiAMM3h (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 Jan 2022 07:29:37 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20DCT98R006942;
        Thu, 13 Jan 2022 12:29:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=GPE0+NPk+GB/qIL5sDb+b3pXMDEKGb/c2amWoZ/lzq4=;
 b=ciypoH3AX1pN/Q5qsogTlvwY6gGw70ckMZ3S5rPIWeyKiHGog1SG5xiuGDYiCvM+JX3m
 jNOsvC1UlzOBleMstHPZD+qM11f56WrW7rQCpHWBN9OMt9zBBrg6s7PzBpE7Th/VyQEm
 2VF6s4HrIly7ozhIZlFwH/3ae0DJbaIOO7QAUESFXPZSEjqKtDm88rLvCczrAEqBBm1+
 HAHw8ypF27PeK6tmSmJCbqyd1AhH4EsqhO+m53v8cNso2vnaeAiCt6fISqRQ379q2Wnu
 WCzm3gGBJUz6oCY+WoaGkdhnIvpmIPPvIzlOLTCysdrUGxwMFqjB4JWIUWbUT65WHDgO AQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3djkpdrk7r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Jan 2022 12:29:32 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20DCTPZ0007632;
        Thu, 13 Jan 2022 12:29:31 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3djkpdrk73-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Jan 2022 12:29:31 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20DCSJcM013918;
        Thu, 13 Jan 2022 12:29:29 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 3df1vjmdky-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Jan 2022 12:29:29 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20DCTQZV39256548
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jan 2022 12:29:26 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3893E42052;
        Thu, 13 Jan 2022 12:29:26 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 21EC042042;
        Thu, 13 Jan 2022 12:29:26 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu, 13 Jan 2022 12:29:26 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id AAB7BE03A3; Thu, 13 Jan 2022 13:29:25 +0100 (CET)
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
To:     dwmw2@infradead.org, pbonzini@redhat.com
Cc:     butterflyhuangxx@gmail.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, seanjc@google.com,
        Cornelia Huck <cohuck@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: [PATCH] KVM: avoid warning on s390 in mark_page_dirty
Date:   Thu, 13 Jan 2022 13:29:24 +0100
Message-Id: <20220113122924.740496-1-borntraeger@linux.ibm.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <e9e5521d-21e5-8f6f-902c-17b0516b9839@redhat.com>
References: <e9e5521d-21e5-8f6f-902c-17b0516b9839@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: MAP5mWyygcCwYNeatHCNi8WojDYS3er7
X-Proofpoint-GUID: VMAYwqNOkptejPYOdpa7xFi2pIryeSei
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-13_04,2022-01-13_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 suspectscore=0 mlxlogscore=999 lowpriorityscore=0
 clxscore=1015 adultscore=0 mlxscore=0 phishscore=0 spamscore=0
 malwarescore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2201130073
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Avoid warnings on s390 like
[ 1801.980931] CPU: 12 PID: 117600 Comm: kworker/12:0 Tainted: G            E     5.17.0-20220113.rc0.git0.32ce2abb03cf.300.fc35.s390x+next #1
[ 1801.980938] Workqueue: events irqfd_inject [kvm]
[...]
[ 1801.981057] Call Trace:
[ 1801.981060]  [<000003ff805f0f5c>] mark_page_dirty_in_slot+0xa4/0xb0 [kvm]
[ 1801.981083]  [<000003ff8060e9fe>] adapter_indicators_set+0xde/0x268 [kvm]
[ 1801.981104]  [<000003ff80613c24>] set_adapter_int+0x64/0xd8 [kvm]
[ 1801.981124]  [<000003ff805fb9aa>] kvm_set_irq+0xc2/0x130 [kvm]
[ 1801.981144]  [<000003ff805f8d86>] irqfd_inject+0x76/0xa0 [kvm]
[ 1801.981164]  [<0000000175e56906>] process_one_work+0x1fe/0x470
[ 1801.981173]  [<0000000175e570a4>] worker_thread+0x64/0x498
[ 1801.981176]  [<0000000175e5ef2c>] kthread+0x10c/0x110
[ 1801.981180]  [<0000000175de73c8>] __ret_from_fork+0x40/0x58
[ 1801.981185]  [<000000017698440a>] ret_from_fork+0xa/0x40

when writing to a guest from an irqfd worker as long as we do not have
the dirty ring.

Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
---
 virt/kvm/kvm_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 504158f0e131..1a682d3e106d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3163,8 +3163,10 @@ void mark_page_dirty_in_slot(struct kvm *kvm,
 {
 	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
 
+#ifdef CONFIG_HAVE_KVM_DIRTY_RING
 	if (WARN_ON_ONCE(!vcpu) || WARN_ON_ONCE(vcpu->kvm != kvm))
 		return;
+#endif
 
 	if (memslot && kvm_slot_dirty_track_enabled(memslot)) {
 		unsigned long rel_gfn = gfn - memslot->base_gfn;
-- 
2.33.1

