Return-Path: <kvm+bounces-35556-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BD67EA1263E
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 15:40:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D2EA8168EE7
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 14:40:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EBB824A7CC;
	Wed, 15 Jan 2025 14:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="kaq5LxMp"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDC4213A257;
	Wed, 15 Jan 2025 14:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736952026; cv=none; b=ptbPvG3PAUCBIlu/T0NiLL5832LLu2N/jeky0A7pJusze447iZPCN2VcOdmxKUn2zNwcQilxfVdsRpUzzrSw/jHg2z0/qKxPriQ+JGKvCGsjS99gzQ/CZPvjpDtRA4pBGCV7iy1OK2w8GFzqagXtlFX+gW2XuXxMoIDv7ZZnUh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736952026; c=relaxed/simple;
	bh=mhuf6DHcjEAYj61DOh72wbknfeeLXQRAzB6JdiB5Pwk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sudHxANlXzDl6U4315btSgk5oYnmMuhapDWv6PmiPo4xw+zeU2Au6cZ73edOnYhYn7T54XjqkZFMp29zFEwHFqxJaFP0w9n8sZlOiUgkWABAf1pE1/z6pWpoCOEM7vovonnbVcej5wKrEdGgiH8kKFw+xGLcAgw5Af4ZkA2oJzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=kaq5LxMp; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50FE6Iex022210;
	Wed, 15 Jan 2025 14:40:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=aTaUmiM0D0ko3/exI
	M9YYRVJGRyZaOnrj9aNSwj7HYI=; b=kaq5LxMplKW8prTPJGZCrLHUYkPLrJ3An
	8EIU6WtyqCeui+y4H6cY7RlWImHW5n/24atW6dgIZeg1yiWdoZBrPBpKyKrVpqDl
	C29q5FvrbLi5jepVldmZtoMm8cHTDn5P5BezTlkT8rQRhRTApaP/cC9hVanzBsMN
	TddWuqEvdJN84ch71eetJ//CnLc7GvQQExsLgBRCTERFXwmBaums2e1Ard/FkJHc
	Imz2+QDNH24B7j4r5o8Gdun7XNTV/1vEcatryGv+wvtJmaRxiwf6YVHXfpr6k6SC
	kF0yLiCUMypSZNIatfF6lU1o+P519XCyHk12bJyCQNTIAVmYl+plw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 446eg5r6cp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 Jan 2025 14:40:14 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 50FEZmwk029509;
	Wed, 15 Jan 2025 14:40:13 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 446eg5r6cj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 Jan 2025 14:40:13 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50FCRlvX016498;
	Wed, 15 Jan 2025 14:40:13 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4445p1rej4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 Jan 2025 14:40:13 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50FEe9Wd39125280
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 15 Jan 2025 14:40:09 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B82A72004B;
	Wed, 15 Jan 2025 14:40:09 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0E6AB20040;
	Wed, 15 Jan 2025 14:40:06 +0000 (GMT)
Received: from vaibhav?linux.ibm.com (unknown [9.39.24.117])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with SMTP;
	Wed, 15 Jan 2025 14:40:05 +0000 (GMT)
Received: by vaibhav@linux.ibm.com (sSMTP sendmail emulation); Wed, 15 Jan 2025 20:10:05 +0530
From: Vaibhav Jain <vaibhav@linux.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org
Cc: Vaibhav Jain <vaibhav@linux.ibm.com>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        sbhat@linux.ibm.com, gautam@linux.ibm.com, kconsul@linux.ibm.com,
        amachhiw@linux.ibm.com
Subject: [PATCH v2 3/6] kvm powerpc/book3s-apiv2: Add kunit tests for Hostwide GSB elements
Date: Wed, 15 Jan 2025 20:09:44 +0530
Message-ID: <20250115143948.369379-4-vaibhav@linux.ibm.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250115143948.369379-1-vaibhav@linux.ibm.com>
References: <20250115143948.369379-1-vaibhav@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: IdGy6tQO_aZC9GzSZdJgV0K1NeMYEhz3
X-Proofpoint-ORIG-GUID: RQppFp4tD7MdOqOXhGHPOLwtM8d5Vrmt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-15_05,2025-01-15_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 suspectscore=0
 clxscore=1015 phishscore=0 malwarescore=0 spamscore=0 adultscore=0
 mlxscore=0 impostorscore=0 lowpriorityscore=0 mlxlogscore=999
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501150110

Update 'test-guest-state-buffer.c' to add two new KUNIT test cases for
validating correctness of changes to Guest-state-buffer management
infrastructure for adding support for Hostwide GSB elements.

The newly introduced test test_gs_hostwide_msg() checks if the Hostwide
elements can be set and parsed from a Guest-state-buffer. The second kunit
test test_gs_hostwide_counters() checks if the Hostwide GSB elements can be
send to the L0-PowerVM hypervisor via the H_GUEST_SET_STATE hcall and
ensures that the returned guest-state-buffer has all the 5 Hostwide stat
counters present.

Below is the KATP test report with the newly added KUNIT tests:

KTAP version 1
    # Subtest: guest_state_buffer_test
    # module: test_guest_state_buffer
    1..7
    ok 1 test_creating_buffer
    ok 2 test_adding_element
    ok 3 test_gs_bitmap
    ok 4 test_gs_parsing
    ok 5 test_gs_msg
    ok 6 test_gs_hostwide_msg
    # test_gs_hostwide_counters: Guest Heap Size=0 bytes
    # test_gs_hostwide_counters: Guest Heap Size Max=10995367936 bytes
    # test_gs_hostwide_counters: Guest Page-table Size=2178304 bytes
    # test_gs_hostwide_counters: Guest Page-table Size Max=2147483648 bytes
    # test_gs_hostwide_counters: Guest Page-table Reclaim Size=0 bytes
    ok 7 test_gs_hostwide_counters
 # guest_state_buffer_test: pass:7 fail:0 skip:0 total:7
 # Totals: pass:7 fail:0 skip:0 total:7
 ok 1 guest_state_buffer_test

Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
---
 arch/powerpc/kvm/test-guest-state-buffer.c | 210 +++++++++++++++++++++
 1 file changed, 210 insertions(+)

diff --git a/arch/powerpc/kvm/test-guest-state-buffer.c b/arch/powerpc/kvm/test-guest-state-buffer.c
index bfd225329a18..99a3d4b12843 100644
--- a/arch/powerpc/kvm/test-guest-state-buffer.c
+++ b/arch/powerpc/kvm/test-guest-state-buffer.c
@@ -141,6 +141,16 @@ static void test_gs_bitmap(struct kunit *test)
 		i++;
 	}
 
+	for (u16 iden = KVMPPC_GSID_L0_GUEST_HEAP;
+	     iden <= KVMPPC_GSID_L0_GUEST_PGTABLE_RECLAIM; iden++) {
+		kvmppc_gsbm_set(&gsbm, iden);
+		kvmppc_gsbm_set(&gsbm1, iden);
+		KUNIT_EXPECT_TRUE(test, kvmppc_gsbm_test(&gsbm, iden));
+		kvmppc_gsbm_clear(&gsbm, iden);
+		KUNIT_EXPECT_FALSE(test, kvmppc_gsbm_test(&gsbm, iden));
+		i++;
+	}
+
 	for (u16 iden = KVMPPC_GSID_RUN_INPUT; iden <= KVMPPC_GSID_VPA;
 	     iden++) {
 		kvmppc_gsbm_set(&gsbm, iden);
@@ -309,12 +319,212 @@ static void test_gs_msg(struct kunit *test)
 	kvmppc_gsm_free(gsm);
 }
 
+/* Test data struct for hostwide/L0 counters */
+struct kvmppc_gs_msg_test_hostwide_data {
+	u64 guest_heap;
+	u64 guest_heap_max;
+	u64 guest_pgtable_size;
+	u64 guest_pgtable_size_max;
+	u64 guest_pgtable_reclaim;
+};
+
+static size_t test_hostwide_get_size(struct kvmppc_gs_msg *gsm)
+
+{
+	size_t size = 0;
+	u16 ids[] = {
+		KVMPPC_GSID_L0_GUEST_HEAP,
+		KVMPPC_GSID_L0_GUEST_HEAP_MAX,
+		KVMPPC_GSID_L0_GUEST_PGTABLE_SIZE,
+		KVMPPC_GSID_L0_GUEST_PGTABLE_SIZE_MAX,
+		KVMPPC_GSID_L0_GUEST_PGTABLE_RECLAIM
+	};
+
+	for (int i = 0; i < ARRAY_SIZE(ids); i++)
+		size += kvmppc_gse_total_size(kvmppc_gsid_size(ids[i]));
+	return size;
+}
+
+static int test_hostwide_fill_info(struct kvmppc_gs_buff *gsb,
+				   struct kvmppc_gs_msg *gsm)
+{
+	struct kvmppc_gs_msg_test_hostwide_data *data = gsm->data;
+
+	if (kvmppc_gsm_includes(gsm, KVMPPC_GSID_L0_GUEST_HEAP))
+		kvmppc_gse_put_u64(gsb, KVMPPC_GSID_L0_GUEST_HEAP,
+				   data->guest_heap);
+	if (kvmppc_gsm_includes(gsm, KVMPPC_GSID_L0_GUEST_HEAP_MAX))
+		kvmppc_gse_put_u64(gsb, KVMPPC_GSID_L0_GUEST_HEAP_MAX,
+				   data->guest_heap_max);
+	if (kvmppc_gsm_includes(gsm, KVMPPC_GSID_L0_GUEST_PGTABLE_SIZE))
+		kvmppc_gse_put_u64(gsb, KVMPPC_GSID_L0_GUEST_PGTABLE_SIZE,
+				   data->guest_pgtable_size);
+	if (kvmppc_gsm_includes(gsm, KVMPPC_GSID_L0_GUEST_PGTABLE_SIZE_MAX))
+		kvmppc_gse_put_u64(gsb, KVMPPC_GSID_L0_GUEST_PGTABLE_SIZE_MAX,
+				   data->guest_pgtable_size_max);
+	if (kvmppc_gsm_includes(gsm, KVMPPC_GSID_L0_GUEST_PGTABLE_RECLAIM))
+		kvmppc_gse_put_u64(gsb, KVMPPC_GSID_L0_GUEST_PGTABLE_RECLAIM,
+				   data->guest_pgtable_reclaim);
+
+	return 0;
+}
+
+static int test_hostwide_refresh_info(struct kvmppc_gs_msg *gsm,
+				      struct kvmppc_gs_buff *gsb)
+{
+	struct kvmppc_gs_parser gsp = { 0 };
+	struct kvmppc_gs_msg_test_hostwide_data *data = gsm->data;
+	struct kvmppc_gs_elem *gse;
+	int rc;
+
+	rc = kvmppc_gse_parse(&gsp, gsb);
+	if (rc < 0)
+		return rc;
+
+	gse = kvmppc_gsp_lookup(&gsp, KVMPPC_GSID_L0_GUEST_HEAP);
+	if (gse)
+		data->guest_heap = kvmppc_gse_get_u64(gse);
+
+	gse = kvmppc_gsp_lookup(&gsp, KVMPPC_GSID_L0_GUEST_HEAP_MAX);
+	if (gse)
+		data->guest_heap_max = kvmppc_gse_get_u64(gse);
+
+	gse = kvmppc_gsp_lookup(&gsp, KVMPPC_GSID_L0_GUEST_PGTABLE_SIZE);
+	if (gse)
+		data->guest_pgtable_size = kvmppc_gse_get_u64(gse);
+
+	gse = kvmppc_gsp_lookup(&gsp, KVMPPC_GSID_L0_GUEST_PGTABLE_SIZE_MAX);
+	if (gse)
+		data->guest_pgtable_size_max = kvmppc_gse_get_u64(gse);
+
+	gse = kvmppc_gsp_lookup(&gsp, KVMPPC_GSID_L0_GUEST_PGTABLE_RECLAIM);
+	if (gse)
+		data->guest_pgtable_reclaim = kvmppc_gse_get_u64(gse);
+
+	return 0;
+}
+
+static struct kvmppc_gs_msg_ops gs_msg_test_hostwide_ops = {
+	.get_size = test_hostwide_get_size,
+	.fill_info = test_hostwide_fill_info,
+	.refresh_info = test_hostwide_refresh_info,
+};
+
+static void test_gs_hostwide_msg(struct kunit *test)
+{
+	struct kvmppc_gs_msg_test_hostwide_data test_data = {
+		.guest_heap = 0xdeadbeef,
+		.guest_heap_max = ~0ULL,
+		.guest_pgtable_size = 0xff,
+		.guest_pgtable_size_max = 0xffffff,
+		.guest_pgtable_reclaim = 0xdeadbeef,
+	};
+	struct kvmppc_gs_msg *gsm;
+	struct kvmppc_gs_buff *gsb;
+
+	gsm = kvmppc_gsm_new(&gs_msg_test_hostwide_ops, &test_data, GSM_SEND,
+			     GFP_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, gsm);
+
+	gsb = kvmppc_gsb_new(kvmppc_gsm_size(gsm), 0, 0, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, gsb);
+
+	kvmppc_gsm_include(gsm, KVMPPC_GSID_L0_GUEST_HEAP);
+	kvmppc_gsm_include(gsm, KVMPPC_GSID_L0_GUEST_HEAP_MAX);
+	kvmppc_gsm_include(gsm, KVMPPC_GSID_L0_GUEST_PGTABLE_SIZE);
+	kvmppc_gsm_include(gsm, KVMPPC_GSID_L0_GUEST_PGTABLE_SIZE_MAX);
+	kvmppc_gsm_include(gsm, KVMPPC_GSID_L0_GUEST_PGTABLE_RECLAIM);
+
+	kvmppc_gsm_fill_info(gsm, gsb);
+
+	memset(&test_data, 0, sizeof(test_data));
+
+	kvmppc_gsm_refresh_info(gsm, gsb);
+	KUNIT_EXPECT_EQ(test, test_data.guest_heap, 0xdeadbeef);
+	KUNIT_EXPECT_EQ(test, test_data.guest_heap_max, ~0ULL);
+	KUNIT_EXPECT_EQ(test, test_data.guest_pgtable_size, 0xff);
+	KUNIT_EXPECT_EQ(test, test_data.guest_pgtable_size_max, 0xffffff);
+	KUNIT_EXPECT_EQ(test, test_data.guest_pgtable_reclaim, 0xdeadbeef);
+
+	kvmppc_gsm_free(gsm);
+}
+
+/* Test if the H_GUEST_GET_STATE for hostwide counters works */
+static void test_gs_hostwide_counters(struct kunit *test)
+{
+	struct kvmppc_gs_msg_test_hostwide_data test_data;
+	struct kvmppc_gs_parser gsp = { 0 };
+
+	struct kvmppc_gs_msg *gsm;
+	struct kvmppc_gs_buff *gsb;
+	struct kvmppc_gs_elem *gse;
+	int rc;
+
+	gsm = kvmppc_gsm_new(&gs_msg_test_hostwide_ops, &test_data, GSM_SEND,
+			     GFP_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, gsm);
+
+	gsb = kvmppc_gsb_new(kvmppc_gsm_size(gsm), 0, 0, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, gsb);
+
+	kvmppc_gsm_include(gsm, KVMPPC_GSID_L0_GUEST_HEAP);
+
+	kvmppc_gsm_include(gsm, KVMPPC_GSID_L0_GUEST_HEAP_MAX);
+
+	kvmppc_gsm_include(gsm, KVMPPC_GSID_L0_GUEST_PGTABLE_SIZE);
+
+	kvmppc_gsm_include(gsm, KVMPPC_GSID_L0_GUEST_PGTABLE_SIZE_MAX);
+
+	kvmppc_gsm_include(gsm, KVMPPC_GSID_L0_GUEST_PGTABLE_RECLAIM);
+
+	kvmppc_gsm_fill_info(gsm, gsb);
+
+	/* With HOST_WIDE flags guestid and vcpuid will be ignored */
+	rc = kvmppc_gsb_recv(gsb, KVMPPC_GS_FLAGS_HOST_WIDE);
+	KUNIT_ASSERT_EQ(test, rc, 0);
+
+	/* Parse the guest state buffer is successful */
+	rc = kvmppc_gse_parse(&gsp, gsb);
+	KUNIT_ASSERT_EQ(test, rc, 0);
+
+	/* Parse the GSB and get the counters */
+	gse = kvmppc_gsp_lookup(&gsp, KVMPPC_GSID_L0_GUEST_HEAP);
+	KUNIT_ASSERT_NOT_NULL_MSG(test, gse, "L0 Heap counter missing");
+	kunit_info(test, "Guest Heap Size=%llu bytes",
+		   kvmppc_gse_get_u64(gse));
+
+	gse = kvmppc_gsp_lookup(&gsp, KVMPPC_GSID_L0_GUEST_HEAP_MAX);
+	KUNIT_ASSERT_NOT_NULL_MSG(test, gse, "L0 Heap counter max missing");
+	kunit_info(test, "Guest Heap Size Max=%llu bytes",
+		   kvmppc_gse_get_u64(gse));
+
+	gse = kvmppc_gsp_lookup(&gsp, KVMPPC_GSID_L0_GUEST_PGTABLE_SIZE);
+	KUNIT_ASSERT_NOT_NULL_MSG(test, gse, "L0 page-table size missing");
+	kunit_info(test, "Guest Page-table Size=%llu bytes",
+		   kvmppc_gse_get_u64(gse));
+
+	gse = kvmppc_gsp_lookup(&gsp, KVMPPC_GSID_L0_GUEST_PGTABLE_SIZE_MAX);
+	KUNIT_ASSERT_NOT_NULL_MSG(test, gse, "L0 page-table size-max missing");
+	kunit_info(test, "Guest Page-table Size Max=%llu bytes",
+		   kvmppc_gse_get_u64(gse));
+
+	gse = kvmppc_gsp_lookup(&gsp, KVMPPC_GSID_L0_GUEST_PGTABLE_RECLAIM);
+	KUNIT_ASSERT_NOT_NULL_MSG(test, gse, "L0 page-table reclaim size missing");
+	kunit_info(test, "Guest Page-table Reclaim Size=%llu bytes",
+		   kvmppc_gse_get_u64(gse));
+
+	kvmppc_gsm_free(gsm);
+	kvmppc_gsb_free(gsb);
+}
+
 static struct kunit_case guest_state_buffer_testcases[] = {
 	KUNIT_CASE(test_creating_buffer),
 	KUNIT_CASE(test_adding_element),
 	KUNIT_CASE(test_gs_bitmap),
 	KUNIT_CASE(test_gs_parsing),
 	KUNIT_CASE(test_gs_msg),
+	KUNIT_CASE(test_gs_hostwide_msg),
+	KUNIT_CASE(test_gs_hostwide_counters),
 	{}
 };
 
-- 
2.47.1


