Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3769D58024A
	for <lists+kvm@lfdr.de>; Mon, 25 Jul 2022 17:54:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235804AbiGYPyb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jul 2022 11:54:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235775AbiGYPy2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jul 2022 11:54:28 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D537112740
        for <kvm@vger.kernel.org>; Mon, 25 Jul 2022 08:54:27 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26PFkltm013296
        for <kvm@vger.kernel.org>; Mon, 25 Jul 2022 15:54:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=GfJFCxMYKXtYWuuwJIfYZ9Iy6tHMydG8ae2oT96zmj4=;
 b=ZDXMqc++9YN2omfUIOD//mc9/kmu2OnrmJiKn01SZ1UnYV+mwrO5hrFa0TXq7vU4tv0n
 qcATwN5COj8ABToMmwh/KXFMtnCpfo6WxSpkJEF+8t00pG33k7VgAITehPymqC31vDwj
 NmcIJqvxKdyY0saNI8QWVqMd/9iOYvMsEamuT26uNE/uwAvDwrS0Iy3gUHGJd2YzMUax
 yTvtz1F7XeUFawxMHd3oV5zPJRLLlOr4LAnOrnJ6yaa/aHcTR6rMIvKQgiirH93vroTE
 ZYGUtaoqsnuuwWdR0l4pJ7vCRy4Y9G5+SAKKj2cH6zTIxW/HZB4FFm7yqY1U2TRR2oXt Pg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hhx49g7vr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 25 Jul 2022 15:54:26 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26PFsQBn016775
        for <kvm@vger.kernel.org>; Mon, 25 Jul 2022 15:54:26 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hhx49g7uv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Jul 2022 15:54:26 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26PFqe5H015823;
        Mon, 25 Jul 2022 15:54:24 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma05fra.de.ibm.com with ESMTP id 3hg94ea06a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Jul 2022 15:54:24 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26PFsL0j23069020
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Jul 2022 15:54:21 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5459D5204E;
        Mon, 25 Jul 2022 15:54:21 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 2280A5204F;
        Mon, 25 Jul 2022 15:54:21 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v3 3/3] s390x: smp: add tests for calls in wait state
Date:   Mon, 25 Jul 2022 17:54:20 +0200
Message-Id: <20220725155420.2009109-4-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220725155420.2009109-1-nrb@linux.ibm.com>
References: <20220725155420.2009109-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: J9ggzL6y-ke0UD214PnYZgHMtiBN-MCn
X-Proofpoint-GUID: RDRmyue9oKOWi8LdNLWpowv5kHWa9mSK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-25_10,2022-07-25_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 adultscore=0 mlxscore=0 clxscore=1015 impostorscore=0
 lowpriorityscore=0 phishscore=0 bulkscore=0 mlxlogscore=835 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207250063
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When the SIGP interpretation facility is in use a SIGP external call to
a waiting CPU will result in an exit of the calling cpu. For non-pv
guests it's a code 56 (partial execution) exit otherwise its a code 108
(secure instruction notification) exit. Those exits are handled
differently from a normal SIGP instruction intercept that happens
without interpretation and hence need to be tested.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/smp.c | 78 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 78 insertions(+)

diff --git a/s390x/smp.c b/s390x/smp.c
index 12c40cadaed2..d59ca38e7a37 100644
--- a/s390x/smp.c
+++ b/s390x/smp.c
@@ -356,6 +356,83 @@ static void test_calls(void)
 	}
 }
 
+static void call_in_wait_ext_int_fixup(struct stack_frame_int *stack)
+{
+	/* Clear wait bit so we don't immediately wait again after the fixup */
+	lowcore.ext_old_psw.mask &= ~PSW_MASK_WAIT;
+
+	stack->crs[0] &= ~BIT(current_sigp_call_case->cr0_bit);
+}
+
+static void call_in_wait_setup(void)
+{
+	expect_ext_int();
+	ctl_set_bit(0, current_sigp_call_case->cr0_bit);
+	register_ext_cleanup_func(call_in_wait_ext_int_fixup);
+
+	set_flag(1);
+}
+
+static void call_in_wait_received(void)
+{
+	report(lowcore.ext_int_code == current_sigp_call_case->ext_int_expected_type, "received");
+	register_ext_cleanup_func(NULL);
+
+	set_flag(1);
+}
+
+static void test_calls_in_wait(void)
+{
+	int i;
+	struct psw psw;
+
+	report_prefix_push("psw wait");
+	for (i = 0; i < ARRAY_SIZE(cases_sigp_call); i++) {
+		current_sigp_call_case = &cases_sigp_call[i];
+
+		report_prefix_push(current_sigp_call_case->name);
+		if (!current_sigp_call_case->supports_pv && uv_os_is_guest()) {
+			report_skip("Not supported under PV");
+			report_prefix_pop();
+			continue;
+		}
+
+		/* Let the secondary CPU setup the external mask and the external interrupt cleanup function */
+		set_flag(0);
+		psw.mask = extract_psw_mask();
+		psw.addr = (unsigned long)call_in_wait_setup;
+		smp_cpu_start(1, psw);
+
+		/* Wait until the receiver has finished setup */
+		wait_for_flag();
+		set_flag(0);
+
+		/*
+		 * To avoid races, we need to know that the secondary CPU has entered wait,
+		 * but the architecture provides no way to check whether the secondary CPU
+		 * is in wait.
+		 *
+		 * But since a waiting CPU is considered operating, simply stop the CPU, set
+		 * up the restart new PSW mask in wait, send the restart interrupt and then
+		 * wait until the CPU becomes operating (done by smp_cpu_start).
+		 */
+		smp_cpu_stop(1);
+		expect_ext_int();
+		psw.mask = extract_psw_mask() | PSW_MASK_EXT | PSW_MASK_WAIT;
+		psw.addr = (unsigned long)call_in_wait_received;
+		smp_cpu_start(1, psw);
+
+		smp_sigp(1, current_sigp_call_case->call, 0, NULL);
+
+		/* Wait until the receiver has handled the call */
+		wait_for_flag();
+		smp_cpu_stop(1);
+
+		report_prefix_pop();
+	}
+	report_prefix_pop();
+}
+
 static void test_sense_running(void)
 {
 	report_prefix_push("sense_running");
@@ -474,6 +551,7 @@ int main(void)
 	test_store_status();
 	test_set_prefix();
 	test_calls();
+	test_calls_in_wait();
 	test_sense_running();
 	test_reset();
 	test_reset_initial();
-- 
2.36.1

