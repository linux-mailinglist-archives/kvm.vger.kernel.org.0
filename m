Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E71A5BDE5E
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 09:37:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbiITHhM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 03:37:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230201AbiITHhL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 03:37:11 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D6C160516;
        Tue, 20 Sep 2022 00:37:09 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28K7VlJe012159;
        Tue, 20 Sep 2022 07:37:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=XJS6h7Hqf7r1OPV/ZjjGlGunF+tbbmUOOmgrsrVKS2s=;
 b=muV1alMZrSNVGOSbNLkrtNIYHxyUFu4RLfOPF8pN5kuyh+ctD6Fasp2DJsQzaak+7Otc
 EVBPWczKU1h/Sdl+zr1Q+e5VPYvUOm6r5zJdLOOH/d5KdHKu6SEAQUB4CVB0wzKTIG6M
 hB4mTWOMNJFriHUUnJ+DnJ1XdJridzPN6KHS/fDOKZ1T0rgWrLCT7Rwz2MBmtuXf/sWi
 7oR4kWvK4t3cBuQzE7OG7S45CxiT9qfea5SyW2ulCh2DfP01s+dJB/pMq7c5EWhaDs0g
 qlQveQzDFGB0ZCICHiSBXCQGSu87MdlnyBZX9+8WGNqnreLguUPSCJ1G/QUCmXQwIfh7 IQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3jq978046k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Sep 2022 07:37:08 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28K7VnaG012206;
        Tue, 20 Sep 2022 07:37:08 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3jq9780458-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Sep 2022 07:37:08 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28K7KrWU005773;
        Tue, 20 Sep 2022 07:32:06 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma01fra.de.ibm.com with ESMTP id 3jn5v8jj5p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Sep 2022 07:32:05 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 28K7W29p45154560
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Sep 2022 07:32:02 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B090011C050;
        Tue, 20 Sep 2022 07:32:02 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B5AD311C04A;
        Tue, 20 Sep 2022 07:32:01 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 20 Sep 2022 07:32:01 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com, Nico Boehr <nrb@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 03/11] s390x: smp: add tests for calls in wait state
Date:   Tue, 20 Sep 2022 07:30:27 +0000
Message-Id: <20220920073035.29201-4-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220920073035.29201-1-frankja@linux.ibm.com>
References: <20220920073035.29201-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: _HAdkx2w_g2LlAUGlBjTp1T9BB0RkbdF
X-Proofpoint-ORIG-GUID: 4ezAsU8EtN-DEZEvHoSwAEuoMD_PZ2w6
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-20_02,2022-09-16_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 bulkscore=0 impostorscore=0 phishscore=0 lowpriorityscore=0
 mlxlogscore=999 priorityscore=1501 clxscore=1015 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209200045
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nico Boehr <nrb@linux.ibm.com>

When the SIGP interpretation facility is in use a SIGP external call to
a waiting CPU will result in an exit of the calling cpu. For non-pv
guests it's a code 56 (partial execution) exit otherwise its a code 108
(secure instruction notification) exit. Those exits are handled
differently from a normal SIGP instruction intercept that happens
without interpretation and hence need to be tested.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Link: https://lore.kernel.org/r/20220810074616.1223561-4-nrb@linux.ibm.com
Message-Id: <20220810074616.1223561-4-nrb@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/smp.c | 97 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 97 insertions(+)

diff --git a/s390x/smp.c b/s390x/smp.c
index 5a269087..91f3e3bc 100644
--- a/s390x/smp.c
+++ b/s390x/smp.c
@@ -356,6 +356,102 @@ static void test_calls(void)
 	}
 }
 
+static void call_in_wait_ext_int_fixup(struct stack_frame_int *stack)
+{
+	/* Clear wait bit so we don't immediately wait again after the fixup */
+	lowcore.ext_old_psw.mask &= ~PSW_MASK_WAIT;
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
+
+	set_flag(1);
+}
+
+static void call_in_wait_cleanup(void)
+{
+	ctl_clear_bit(0, current_sigp_call_case->cr0_bit);
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
+		psw.mask = extract_psw_mask() | PSW_MASK_EXT | PSW_MASK_WAIT;
+		psw.addr = (unsigned long)call_in_wait_received;
+		smp_cpu_start(1, psw);
+
+		smp_sigp(1, current_sigp_call_case->call, 0, NULL);
+
+		/* Wait until the receiver has handled the call */
+		wait_for_flag();
+		smp_cpu_stop(1);
+		set_flag(0);
+
+		/*
+		 * Now clean up the mess we have left behind. If the cleanup
+		 * were part of call_in_wait_received we would not get a chance
+		 * to catch an interrupt that is presented twice since we would
+		 * disable the external call on the first interrupt.
+		 */
+		psw.mask = extract_psw_mask();
+		psw.addr = (unsigned long)call_in_wait_cleanup;
+		smp_cpu_start(1, psw);
+
+		/* Wait until the cleanup has been completed */
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
@@ -474,6 +570,7 @@ int main(void)
 	test_store_status();
 	test_set_prefix();
 	test_calls();
+	test_calls_in_wait();
 	test_sense_running();
 	test_reset();
 	test_reset_initial();
-- 
2.34.1

