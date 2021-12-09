Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 461AB46F829
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 01:48:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234981AbhLJAwW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 19:52:22 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:65398 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234954AbhLJAwR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Dec 2021 19:52:17 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BA0anO5023731;
        Fri, 10 Dec 2021 00:48:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=q151GMb7wtD/jK1JkOcJzVjZA15aOdV8NVf/EuU5AIs=;
 b=y2dsg4L/3Gq8Uf3YrJ9Ia7pxOhYtq0kZjiTs2Y8Lptb42zwEB3fiZb4SSm1jgPsLUAeh
 5AW/hzOij50x9YUoI0SAWZtS3/OqTdEwOy5/yWJIXC8OQyP82jnO5bJJL4IAVm7pBfxc
 48dTuOg1NFpXZn2O7Jb9B2NrtJDcD+6sqqHlZPVbw0iXvylYb2D68u5r50nTcjV7KBd0
 sVId8Sj9Lv4i8jCV11qSEZ0x4d5nQgZ+srgqNtZJx//ZWB653w/3pdVm3jlHpkGrOtXN
 5Ah7I+SXOr5yHHdzIiiwrIDTAm3v5wijoudNf1yJzOTrjabb6gbLn2GG2e8B3+lOcXP5 lA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ctup54mjq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Dec 2021 00:48:40 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BA0knhI186438;
        Fri, 10 Dec 2021 00:48:39 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by userp3020.oracle.com with ESMTP id 3cr1stefw3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Dec 2021 00:48:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eO58+YByRCcUD8NTSiayZrgIYCbaDG7KfBZd2gNZoXMemiM5NKuPFSN9N/b/d2Y/So6cMWKIqgciXT8w0w5r6Zgspi+xWXGTpF2HLCSVwkMXJr28mLVnUvT7rbB+IS44zVAquQHDTd+1UNdmHsr4tUiciWO5Mmd/c+M/zndhaNj7sQKUs/IZdnHObnBtVJs2THw3X6X8XxzdBn+HrDSWmS+6It3iVy9QkPP/l5MH3LcoWmnWABz4jhYyKu/3aAOJGveXpU/ITR7CI8hFO8vdxAyaEUjezjYowzsuBt7+wC4CJt39Mazr6NEdNrKoZ66/HEUC4kA769VpwEMUDDvR+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q151GMb7wtD/jK1JkOcJzVjZA15aOdV8NVf/EuU5AIs=;
 b=EuUaPBHW4sd8AbzptlyUb0YSRKsh7jc+V0zfXggRoICjUqGm8iaPkmVk60RAFVyfEViNiHVXzamv+WplIm5cvcS4r7oZGFCtVEJVoZUn+VxaqnFcnAKNv0JyOG62tJ3Dd7mRIpNSIsKJ7c7hWPZ1UgBDBcfZXJ5wAEejlS9Z+2tbO9jF5hjU9GomCu76jXm9xdJ3zYLASmrHHCBIl7a8IPy3QdkGRs7z0+Kp0gorKitRid0AhNmprRiK2JSllP8hNMCDbES2PSNWVDzs7yorZqvSc3iWU0Z+xc+9hQfF7Mgnof7oUE6UHkMrqpAn2f4AzZ4JblxE5FURPd43LwhfvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q151GMb7wtD/jK1JkOcJzVjZA15aOdV8NVf/EuU5AIs=;
 b=Vr1CC3HeDXoAlAj34m2Auc4QjwgJcrIiVHtA/XCldFreNsck7zTFJVxvvHZdYq6BzhDk99qbr2RfGcHEigPadeZSKSzug6tlOIDWhxSacGirYB2ekyksw0lBNg1cwCkPsQf+SFe31u99Vn7u5+SRXvxf/fQE8yoRtSfne8vL/cA=
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SN6PR10MB2942.namprd10.prod.outlook.com (2603:10b6:805:d7::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Fri, 10 Dec
 2021 00:48:37 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::b94c:321d:7ba9:7909]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::b94c:321d:7ba9:7909%4]) with mapi id 15.20.4755.025; Fri, 10 Dec 2021
 00:48:37 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com
Subject: [PATCH 2/3 v2] nSVM: Test MBZ bits in nested CR3 (nCR3)
Date:   Thu,  9 Dec 2021 18:53:33 -0500
Message-Id: <20211209235334.85166-3-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20211209235334.85166-1-krish.sadhukhan@oracle.com>
References: <20211209235334.85166-1-krish.sadhukhan@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0801CA0010.namprd08.prod.outlook.com
 (2603:10b6:803:29::20) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
Received: from ban25x6uut29.us.oracle.com (138.3.201.29) by SN4PR0801CA0010.namprd08.prod.outlook.com (2603:10b6:803:29::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.16 via Frontend Transport; Fri, 10 Dec 2021 00:48:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c6254542-8f7f-4525-a1f9-08d9bb76cd01
X-MS-TrafficTypeDiagnostic: SN6PR10MB2942:EE_
X-Microsoft-Antispam-PRVS: <SN6PR10MB2942D1450D5CA8BA8EEA651E81719@SN6PR10MB2942.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7xIIRsdxxnfIuaIl+smRiC/Ql/V9DDgkRgvccsIZZg7TBwn/DGrLgpavxhE4ceKYKQeS1bih9iminRaHwVY3SJO2LcZhYuy7qLhMzKV+sXmDRxS3Lz5udL2r5JjzJW51Rd3GqTyuSRWtg8YZXb43+2zize97pH8GTxANDFtkKCds7ROk1CpgwZ9yoAj4r3ltkOetBUO16UNxmcSc2Lwi4IqFGVtS6ca1Xvs5kqGJNP38Z+k8SQZDc1eCaPZxdA9Co1Iswf6IeBbO6g21XIm7oMhLX26H+H3bVmMQQkLPCPN4Dp/Tt+8Ydfc4U/1XZBdWI5eBMlkkYHemV4oRzNMt3t3JSfKbi8YiMtl28QESYwSSBpZNh2FmyYt9i35aOvkVs+9LLoibyRMS2/o76jsd1BJtQCAQZr2CtabVPyF2hInexuhJeJ3Di0e99mQivEM6jv0+IfVYxvCRKLkTE8L0oegVLOz8ZNHADXcdN0V23z0Uy0aZ+LDCQTtwOXVGKXKqm+DyFVRwkv5/f+nN04rAAomq3RyynX4qRmQfxsbyzH9LI2uQfiPB9+pzm/VoMwzYm/RbZkf4kCRKTe8fy5JuT2C2R0V5EYh/Pnp7K+417jlxYTT8M7apEJ10w41tl2UqwPlAB82jEbZ4ZhS+2x28VR1gogDwt+DncKKFRA2mfkjs4BTF3oq0fOFE4ekB2jwMSJUxu1sT7kElbSsZ4R5bvQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4326008)(8936002)(66946007)(2616005)(508600001)(8676002)(1076003)(83380400001)(36756003)(7696005)(44832011)(52116002)(5660300002)(956004)(6916009)(38350700002)(186003)(38100700002)(2906002)(316002)(66476007)(86362001)(6486002)(66556008)(6666004)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?co/DILm0xGKgEAeF/XzPcCU/gGsLFw9B8O4U1BNIvCHdkXwI88fBIKnnAHLT?=
 =?us-ascii?Q?nGf7vsEJKT7dQM5Sqp5t1Opl7kq7OAm9T6DTfHPNOs9+tjdwIsOJtPUCgVZl?=
 =?us-ascii?Q?ilvNZup2DaQnm479iajAIb3A/wlEnPujT5/M/qgWNdrJ98cMJnrQwrG0fH4R?=
 =?us-ascii?Q?rl1pVfRBnxRiwLrklF6B+OgJRfD9QHs9wXSx74o36S3EOw3ecLk7u0wzajn3?=
 =?us-ascii?Q?N2BdrA+NcMkA9SNYCcMKBJR+LveeY0pFZUbD4JlrrYt3D8GLDc7z22QRzmtC?=
 =?us-ascii?Q?ctXRnprNSB+f6KDaiIYP84WlzF3eHBWwb+CWVr0Jo5nQxDPUH/fUZfAGpDk0?=
 =?us-ascii?Q?qA43tAG/7HMvBVruvF2ZoL4XQbxu8G6xuHnt2Q0h85cF+8a6cDcb3k9gGeH9?=
 =?us-ascii?Q?G505NFNxo3teOP2bxtny51cC5sPvKFYpvNCNmn/QlkgyR0rPFdoquJp+EQiZ?=
 =?us-ascii?Q?y/xgp7j+NdhbqNdotMfdQ7aGLmSA+myxNr6WA4HSCgdve7rHfOrzhqD4yv/B?=
 =?us-ascii?Q?M8/ImQRF3jA1u0zBZNp/O5XJ6Jw6xZwesWO2TxzPdB2DsbFnUIvAlizZr2nf?=
 =?us-ascii?Q?WrDEPt00IpicJLDq0h9ZC/W5gOlSw+FFubSUhOkPFMIcy2vxSNkPEDuGRbPQ?=
 =?us-ascii?Q?DWKA9bdrGx4RwS+68tKuuePnG6SHVJJjIewzmoRFSidIwwn1bV+EJZb3l8n1?=
 =?us-ascii?Q?zCNyQx0r5KZRZ+mOKpCmbyzHv+C5iAskxG/7Mvl8PkK50YhPxEc3Gi5qaYW6?=
 =?us-ascii?Q?hcUNs61PKLh2KFk2kqJoQq2MFoQ9g1Tftt0a8ufsieiB7ypq5Do8+MwbBEdJ?=
 =?us-ascii?Q?9vCLMxa1pv0EDwjhdpF9cuj/naJL2nl3J7hrKn+KeyoDM2yrAhtl8FnADsOI?=
 =?us-ascii?Q?EYF4c3TtmKBCeUTgkDCtO93P6x/sCcOpRd/oLOE9CyqxWyQdNvWmzJcMLV24?=
 =?us-ascii?Q?EF7cZvCJ7otb5wKZHM7ksFgMy67twQ+SagWSm/TAuVH3gCQkJ5qnl1/Fmj0w?=
 =?us-ascii?Q?kIDBQy26HyR97P3hXt8W6RpljdyilP0waCns3jTfYs2Ztlc0DxTNTIJallhf?=
 =?us-ascii?Q?Ds2vUWM+gAbVGpK2fGPaG1IQbyUDDCUovwm2TaQOI4fK6mMiN7Fd2ld/tVJ6?=
 =?us-ascii?Q?+WE2LfhL2JBn42F6u97n8bCOtUwuaOJMCtPOciIGg0npK9a0SoSSg3UkJZLF?=
 =?us-ascii?Q?fHk53KS4gLjZ0WAc5OH/9FIxEbBJLiZwKxEyl27sqG/XiHUmm+LyD/cUThFm?=
 =?us-ascii?Q?dLYdwmw+dzVH9j9hM0n1tLrNUCnHf9GV1pxKTjLl7lmtClNAOl9cvKBGUbYc?=
 =?us-ascii?Q?2j/9TxDax/9DSgB/ZTzjTmne5pIFeqSKBfUmfOs4TFgb97lDs88sv2W5uAwO?=
 =?us-ascii?Q?6SdIraqdjiPECB9aLvjJkBQrFu8VzdXPy3dS6jPGv89T2xqntSNJAqfPE3Bw?=
 =?us-ascii?Q?K7stoXt6X3pM4oxhAVMaQof8mbzFXilbxiBHQf//JTnj5nmLMyNcT1YiMNmc?=
 =?us-ascii?Q?dktCV5BTy5F+fZC/e7CHVmpEM1NCGAP6B0SaS9AetOusWn44Y9pv285r3giX?=
 =?us-ascii?Q?jKvMQ/uBtI5MUJlicscvhj/r1NYwWa4kQyR9rds2bk9jJDAE0YVEoffPWCxj?=
 =?us-ascii?Q?UJRra6gjfsnEqdkR1fM01gZXGChCnDnU8MYv4i/o6DeJO4jPgjlTJynZjRmu?=
 =?us-ascii?Q?aplYEg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6254542-8f7f-4525-a1f9-08d9bb76cd01
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2021 00:48:37.1013
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RuOztHjI9P8drMAZlRqVrqbf0aufKq8zVqLlW8KenxKAaCnhCM6ZtGBEpbycPuxSJ4os88QK/4kJSSmYPe08n4IfSkwYQM7o/Y7Zsc9dI6E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2942
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10193 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=958 mlxscore=0 spamscore=0
 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112100002
X-Proofpoint-GUID: aG-gS4y2T_n4U542uLWMqsG0MAlm5JvR
X-Proofpoint-ORIG-GUID: aG-gS4y2T_n4U542uLWMqsG0MAlm5JvR
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to section "Nested Paging and VMRUN/#VMEXIT" in APM vol 2, the
following guest state is illegal:

            "Any MBZ bit of nCR3 is set"

According to section "System-Control Registers" in APM vol 2,

    "All CR3 bits are writable, except for unimplemented physical
    address bits, which must be cleared to 0."

Therefore, test that any bit in nCR3 that is set beyond VCPU's implemented
physical bit width, results in VMEXIT_ERR.

Signed-off-by: Krish Sadhukhan <krish.sadhkhan@oracle.com>
---
 x86/svm_tests.c | 42 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 41 insertions(+), 1 deletion(-)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 8ad6122..4897a21 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -2183,7 +2183,10 @@ static void basic_guest_main(struct svm_test *test)
 			vmcb->save.cr0 = tmp;				\
 			break;						\
 		case 3:							\
-			vmcb->save.cr3 = tmp;				\
+			if (strcmp(test_name, "nested ") == 0)		\
+				vmcb->control.nested_cr3 = tmp;		\
+			else						\
+				vmcb->save.cr3 = tmp;			\
 			break;						\
 		case 4:							\
 			vmcb->save.cr4 = tmp;				\
@@ -2547,6 +2550,42 @@ static void guest_rflags_test_db_handler(struct ex_regs *r)
 	r->rflags &= ~X86_EFLAGS_TF;
 }
 
+static void test_ncr3(void)
+{
+	u64 ncr3_saved = vmcb->control.nested_cr3;
+	u64 nested_ctl_saved = vmcb->control.nested_ctl;
+	u64 ncr3_mbz_mask = GENMASK_ULL(63, cpuid_maxphyaddr());
+	u32 ret;
+
+	if (!npt_supported()) {
+		report_skip("NPT not supported");
+		return;
+	}
+
+	vmcb->control.nested_ctl = 0;
+	SVM_TEST_CR_RESERVED_BITS(0, 63, 1, 3, ncr3_saved, ncr3_mbz_mask,
+	    SVM_EXIT_VMMCALL, "nested ");
+
+	vmcb->control.nested_cr3 = ncr3_saved & ~ncr3_mbz_mask;
+	ret = svm_vmrun();
+	report (ret == SVM_EXIT_VMMCALL, "Test CR3 nested 63:0: %lx, wanted "
+	    "exit 0x%x, got 0x%x", ncr3_saved & ~ncr3_mbz_mask,
+	    SVM_EXIT_VMMCALL, ret);
+
+	vmcb->control.nested_ctl = 1;
+	SVM_TEST_CR_RESERVED_BITS(0, 63, 1, 3, ncr3_saved, ncr3_mbz_mask,
+	    SVM_EXIT_ERR, "nested ");
+
+	vmcb->control.nested_cr3 = ncr3_saved & ~ncr3_mbz_mask;
+	ret = svm_vmrun();
+	report (ret == SVM_EXIT_VMMCALL, "Test CR3 nested 63:0: %lx, wanted "
+	    "exit 0x%x, got 0x%x", ncr3_saved & ~ncr3_mbz_mask,
+	    SVM_EXIT_VMMCALL, ret);
+
+	vmcb->control.nested_cr3 = ncr3_saved;
+	vmcb->control.nested_ctl = nested_ctl_saved;
+}
+
 static void svm_guest_state_test(void)
 {
 	test_set_guest(basic_guest_main);
@@ -2557,6 +2596,7 @@ static void svm_guest_state_test(void)
 	test_dr();
 	test_msrpm_iopm_bitmap_addrs();
 	test_canonicalization();
+	test_ncr3();
 }
 
 extern void guest_rflags_test_guest(struct svm_test *test);
-- 
2.27.0

