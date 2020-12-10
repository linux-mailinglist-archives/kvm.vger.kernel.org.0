Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C42EF2D5D8A
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 15:27:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390040AbgLJO04 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 09:26:56 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:17060 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390034AbgLJO0z (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Dec 2020 09:26:55 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BAE26TO151265;
        Thu, 10 Dec 2020 09:26:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=FYnXvlm4/lJDaJNStTlQhRs1uDUV/YqFG6nAzY4Cfws=;
 b=LnYZeC7WNxX+kJdpimpxXUFTZ1V6aKAMRbzUViZIuHqqZU6wTO9nAjgDHq2j3T3RBx8J
 XVtzgXs+dR9kVMaFX4V3zNcP7hGy8TlucfPgJtp2qwAEs3/mrdoUc6Wn4BycRHfWsJx4
 JDP/8Qv6eYWjHE5X7e/p0JUVzP1JKUBr0GB7EIovibmH3zEstOZGDgxzIJv0M1KREmQ8
 IApar320wUrNuNbqnemYELIsxfgBHb5i0SctcWNaiIQT59/zjHMYWS1BfUgZLE3sv+xy
 N85Qi76cMsbBGlKWnG3akvct8cKAAri0OOnWN6TJ0kCt5HUdeoEg1H/Go2PhwqpArYtk mg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35bjvbwe2b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Dec 2020 09:26:08 -0500
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BAE32fs160543;
        Thu, 10 Dec 2020 09:26:07 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35bjvbwe1d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Dec 2020 09:26:07 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BAEHGvl025295;
        Thu, 10 Dec 2020 14:26:05 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 3581fhnvnt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Dec 2020 14:26:05 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BAEQ2Hw25231832
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Dec 2020 14:26:02 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9E4AFA405E;
        Thu, 10 Dec 2020 14:26:02 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8D6C8A405D;
        Thu, 10 Dec 2020 14:26:02 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu, 10 Dec 2020 14:26:02 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 5455AE0450; Thu, 10 Dec 2020 15:26:02 +0100 (CET)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Collin Walling <walling@linux.ibm.com>
Subject: [GIT PULL 4/4] KVM: s390: track synchronous pfault events in kvm_stat
Date:   Thu, 10 Dec 2020 15:25:59 +0100
Message-Id: <20201210142600.6771-5-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201210142600.6771-1-borntraeger@de.ibm.com>
References: <20201210142600.6771-1-borntraeger@de.ibm.com>
X-TM-AS-GCONF: 00
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-10_05:2020-12-09,2020-12-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 malwarescore=0 clxscore=1015 adultscore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 priorityscore=1501 mlxscore=0 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012100084
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Right now we do count pfault (pseudo page faults aka async page faults
start and completion events). What we do not count is, if an async page
fault would have been possible by the host, but it was disabled by the
guest (e.g. interrupts off, pfault disabled, secure execution....).  Let
us count those as well in the pfault_sync counter.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Link: https://lore.kernel.org/r/20201125090658.38463-1-borntraeger@de.ibm.com
---
 arch/s390/include/asm/kvm_host.h | 1 +
 arch/s390/kvm/kvm-s390.c         | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 463c24e26000..74f9a036bab2 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -459,6 +459,7 @@ struct kvm_vcpu_stat {
 	u64 diagnose_308;
 	u64 diagnose_500;
 	u64 diagnose_other;
+	u64 pfault_sync;
 };
 
 #define PGM_OPERATION			0x01
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 19804c388d61..065f94f22fd3 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -60,6 +60,7 @@
 struct kvm_stats_debugfs_item debugfs_entries[] = {
 	VCPU_STAT("userspace_handled", exit_userspace),
 	VCPU_STAT("exit_null", exit_null),
+	VCPU_STAT("pfault_sync", pfault_sync),
 	VCPU_STAT("exit_validity", exit_validity),
 	VCPU_STAT("exit_stop_request", exit_stop_request),
 	VCPU_STAT("exit_external_request", exit_external_request),
@@ -4111,6 +4112,7 @@ static int vcpu_post_run(struct kvm_vcpu *vcpu, int exit_reason)
 		current->thread.gmap_pfault = 0;
 		if (kvm_arch_setup_async_pf(vcpu))
 			return 0;
+		vcpu->stat.pfault_sync++;
 		return kvm_arch_fault_in_page(vcpu, current->thread.gmap_addr, 1);
 	}
 	return vcpu_post_run_fault_in_sie(vcpu);
-- 
2.28.0

