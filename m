Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B5B24CEE27
	for <lists+kvm@lfdr.de>; Sun,  6 Mar 2022 23:26:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234358AbiCFW1k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Mar 2022 17:27:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbiCFW1k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 6 Mar 2022 17:27:40 -0500
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADEC222BEC
        for <kvm@vger.kernel.org>; Sun,  6 Mar 2022 14:26:46 -0800 (PST)
Received: from pps.filterd (m0127838.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 226KgSLd001313;
        Sun, 6 Mar 2022 14:26:40 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=proofpoint20171006; bh=g0zbLYBp2ImP7dhDo3S5jCO3iU9GcYtXYu0GdrBigv8=;
 b=JyN1Am0B2NWWL2w4zsCleg429gs+KpQNJx3bjUa6E1VgRPTq9wHkhirAKF636oxsvpCp
 tz8y266dvdSUuG9jVgkvuUvE7G3KhDE2Lt0H584UJ26OVRyOnpB+D1xUzXswjxFeFR14
 oEI8Tf/Z8juWpAlF77eg+G+dpuJN3LIdEaTzmrBI8hHJuDi6B4uOSARqyZPMx13GolEK
 EvLBstIk8aJCK1hvGvSF3QeHF/6L7ehUsMXDmLA6pfZf7Wxd1j33QBSS7d4B+wp8awqR
 nYHGkiWUQEZjjDHNPDs+biSQFLVwygo91emZT2mWYwd3+4PdAK57kAqN+y338YeuGywo LA== 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3em8a31wmn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 06 Mar 2022 14:26:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KXuFneBU9nQSKNivJ64ud2x4eYNoxN73IUSPrKoion0RHL/5BTc+VLLcTlf93zmyxntWS0CuwSS1iDEJcjvw/5vNU7a1+z8e4snDV2ZGlr0bpdO5qC8ZyQ7LcMrAFCy9DqpVnZYSQUC+ZFRi02NcC1+4bItiBCVf8UEOmrDbVdDO0DP68NUO4boJTEWdXXbUYXtilkWiRFFE3OUp59ZUt1UlJgyClyjCVvdIvo9MIqVvdqt1zXQMa1+19vggiUoAtU2RwqFnNxTNw542hmrpjOvDkVNpdgO2NZgH0jT0gaX3cxUkcrq/6d9oWxe0EKZixIuB8oeGRGP/QfyYFvta+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g0zbLYBp2ImP7dhDo3S5jCO3iU9GcYtXYu0GdrBigv8=;
 b=nv0wjjbUdb3xx3b3JNGqL6TGm9DJKCSaWJkyTjqmkEiQrNBEIBQCnvM1wCwPDXwnZ4aDUEF6O7K3qOQkFVag36t5tBI4cNHb8UBLSsUs52aD9Dw6qMjXDDgRvwtO7nQfIpjl0Nn/8IEd37/ODWPXoybMKC4GdjnI0Sj6LEVmd7IgRbHPQuzkd3qsOj6sd25n8OLXwyi1154JcI+XzhGZI/Amf2uIgjuleeVu+9c/D0pdDaExsy5d7kK3qeZ45OqGpp5HVGsnxhQyM/oGRzbDzQ/smaFG1uji6MTwGVEyx/t3WMdEedVleV3oPoK27vJIG19xx2D0meND9jB/nwpcOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by BYAPR02MB5495.namprd02.prod.outlook.com (2603:10b6:a03:95::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.17; Sun, 6 Mar
 2022 22:10:35 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::88fa:f43f:f4c7:6862]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::88fa:f43f:f4c7:6862%8]) with mapi id 15.20.5038.026; Sun, 6 Mar 2022
 22:10:34 +0000
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
To:     pbonzini@redhat.com, seanjc@google.com
Cc:     kvm@vger.kernel.org, Shivam Kumar <shivam.kumar1@nutanix.com>,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
Subject: [PATCH v3 2/3] KVM: Documentation: Update kvm_run structure for dirty quota
Date:   Sun,  6 Mar 2022 22:08:50 +0000
Message-Id: <20220306220849.215358-3-shivam.kumar1@nutanix.com>
X-Mailer: git-send-email 2.22.3
In-Reply-To: <20220306220849.215358-1-shivam.kumar1@nutanix.com>
References: <20220306220849.215358-1-shivam.kumar1@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0155.namprd05.prod.outlook.com
 (2603:10b6:a03:339::10) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2dd07f2d-31cc-4584-c217-08d9ffbe22f8
X-MS-TrafficTypeDiagnostic: BYAPR02MB5495:EE_
X-Microsoft-Antispam-PRVS: <BYAPR02MB5495E59CBC71107A433A33A3B3079@BYAPR02MB5495.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: riwV37A3GH3mvZpXcxec940srT+NMVyy54QyYuvB6ZqPAZ6R6+SqInVIPsSzaPrJdOLTUvFrDFS2e9Gnp25+cgR83o15OUFP/0D80MaHY5DUbEL+/BOZbQQOkqH1cfg+NLsJPEM6U5Yk/CXGPKP4BNHTolSF418gpjEGxKBBSivKt+3VPC7qGcxkTwPr0i64x8rosTSYi3vz7BPRkCaq+Li8vdYFMjduQ9VcVrbNJfs5v9p/KKB9gns2Cvsa5t5VcSoxyza9Ew1u5NPxguxcXWZ43vkLQKBx0Fvx5lquu47g1S8/TVPFwHOS2iseju4Pps+YQyfIH2O9zw/Zu8jd9CO4xSO97Kq/5XEFUDFdiYa8R0Vhw2O0Y5/Ea/ZidmWcXtALPCabJt9bXtzkDcTAipcYhwZG8E5mFT2vb9IW/RH97I1BLS4v1ik3f2ryFK17fxwVgNDZAUY75wPaRM0enN1/f0toZCnm6h83i4EfQQcnXxoZTo6hScFJCLC5n7hhzQqshWJY0H9V4Gj93QzSWsOMGUyfibw8Eq+yrH3hQcxBJVjvRAgizwZA7anI+dI7TOjizkd/cu/G/h+HJCRYIJAhlDTk3MXmqfrHW6KdXzJ5dWGI6Vcj5xgzoTtZCYe1JIbgpbRwgZvbl5OZsljxC+9fzaaxF/QJMUrqx9GUBvAuPmZFFtV84+oRKfTHTl4opVP0hbnmBlPQAUTkT2HzovlgI77dN0e+NDwLUNiTc4ihmrFnNgPkVrpCl7uT5ADk9RIuKxY14gT/T42StNlabx3YEk3YMa76757kdnnc5jVXDpECALkiYa1Pid1K6IPF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(5660300002)(15650500001)(86362001)(2906002)(508600001)(8676002)(66476007)(66556008)(4326008)(6512007)(6486002)(6666004)(8936002)(6506007)(966005)(66946007)(83380400001)(52116002)(107886003)(54906003)(38350700002)(1076003)(186003)(26005)(36756003)(2616005)(38100700002)(316002)(14143004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IQIL8bJ8tWhsw7aKTQsXTZFj2VMK+OCTh2mucUy5Wnw8pad8paOooZNIHc4i?=
 =?us-ascii?Q?TOtCciZzHOl9JwmPzmTq2ECtUJVLWN0cqJ21mmuIgpKLQYSR3q2cBkJzoUqS?=
 =?us-ascii?Q?+g3lZCE18icwKWrPgW5no8jJ4Twl3ejNVBcvf30FOxO/rZGp3aedeq7Q5n+9?=
 =?us-ascii?Q?ovnkDbD6GocaToaTzCBYrmYlfXjU5BTHmNiY3nCn9CCr1E9CaE25XXLn3Q8c?=
 =?us-ascii?Q?rldMABxvlbgyB3rJv9sJwBORGbpEM7D/hEqtR48S5HCoI9yL0x04T2Ut6Etf?=
 =?us-ascii?Q?NAIj4uhaEhWqavmUWULe0UPyJKZ1vJ1s/omxmfLOtyM+lEu+iW9tZicsOQmN?=
 =?us-ascii?Q?gw2jdet4HeMr5MZKDyPOiKeTVGuPI5bjhSssjV35SUFP1EQbSCfPB60QzGcP?=
 =?us-ascii?Q?VDmCjinWj5eoBZwm7HkUteNnolyMnGe8bndrrL2hj/MDyxSA0/FYYwu2+Oii?=
 =?us-ascii?Q?WDNA7SjxPFYEOY92bC0IrDvlreJ7nWkEVmvlp4MPMj+eUQjO8NAgz4emaSmR?=
 =?us-ascii?Q?9Oeqqiewayn0ewE1Cdc6hIcH7U5hWsp+C2t8zx8/7879uVhTnakWS54Fpt7k?=
 =?us-ascii?Q?8eqczy/UP9oKUGfpuoy35x10wZRW49Y5tOHhiy/ahJJ5kZaqQG+n6pLS2dd3?=
 =?us-ascii?Q?Z69OKV0z1RNaJyz1/SALrq/05ehG8rhmBNGQSlEW1BzMaYmp89iUwBbmhIhi?=
 =?us-ascii?Q?TGCgR0Eb6u3dvWg9/eRd/kdsjL+C1Vx4d7o/OM3/F5sxcM2w5dAX7KAgh78M?=
 =?us-ascii?Q?tJ8ys4nL+qI2ECkisBYGwIahwWJaCZVvElFKzLLqzmJWIlgBfV+v8csCFrdL?=
 =?us-ascii?Q?rsvC9rkRRfxvjg6YJ0f2gh1Vl+JVmx0yLp4NUSbe9iHrCoA5XvpVterpGOxR?=
 =?us-ascii?Q?m9nzZ5G0Xhf5Uihq9txTWGH+GQq3RpmNIDSFg0DhEqrnoms+TvTFEbRYTbMs?=
 =?us-ascii?Q?X6weu7KBiVd0LFAtSJgh4uk6Hi1i6vZWP2AjWmW+c4enzBiSSZeYJ7jz33Z6?=
 =?us-ascii?Q?QfptNw8ZV2cxCiTpNUo5okIqu4+mIZJ4aL+XQ0X00xfYnlqlTtHmWzYpsjLU?=
 =?us-ascii?Q?cZ/Y+rDbm03JtcDfUcqn0DFVziyjpdvkaQMcEcIRV+0E+N1buJmTuJvpMXPo?=
 =?us-ascii?Q?k+6YbLzx5TvWnt7OLFlb5eV/FJjzMSG6z0d3dCA7OM8E3+MmLiRLdPNFvdPL?=
 =?us-ascii?Q?tzvcgFY2RWeCxutb/WyftnHnhJQ/AROM+Di9UB7rqbh/wKZUR+8RY+SYzKHu?=
 =?us-ascii?Q?yauJJiPKuPa5kBvj7Kappzzq9p4iSpIXBhJir4obbFfEBVaOVYdrr8QFuPT2?=
 =?us-ascii?Q?DrNl66k0bNunrbl6hyp3Qo6PIj1XpcuFihXdJ/AqCjXVLW1q88Wc0nJsApBk?=
 =?us-ascii?Q?TFDu/7AXUcbBvQp8onnOvMIDtGfXwiQIKgOqjP/Tpg8dTziz8o3FNiuhmsoP?=
 =?us-ascii?Q?+tWKlXQKsWqFY8WMhkpswLa1WEgswqqv20Vr+ja0eNoahwHTnGbf732cWB2L?=
 =?us-ascii?Q?G+Q0ktGiqrxfUUNk2Bh38DnjJFQyQCMRPRlV3gtI69tl6GHDnD4URrpRNAAf?=
 =?us-ascii?Q?6A9YOPaLoeG3W2k0NwLSF8kcA9toVJlgqj6d9mipelOnjKgamqjWdIG6IHPD?=
 =?us-ascii?Q?1YNKIzG5Rs+i3LyM4YimmUDUKt+wyngNxh4N5nq0E2LgCRdVB0j/aLBW8jWV?=
 =?us-ascii?Q?ObR3daZ6PoMLpk+s4qWzyxFacLs=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2dd07f2d-31cc-4584-c217-08d9ffbe22f8
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2022 22:10:34.6482
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tUx1lHLmBe7IgvawQUDm9tud5Q+JIzlAooISUsanT7pz6NNhlbWbEkPCIaJGhgnq3GtbZAzTcXvvGHbclwdaYoDjmhHLi6Cd4V1D4akFs20=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR02MB5495
X-Proofpoint-ORIG-GUID: vzQQoxGSb37aKNB6U8kyTLwcW-WYTYJT
X-Proofpoint-GUID: vzQQoxGSb37aKNB6U8kyTLwcW-WYTYJT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-06_08,2022-03-04_01,2022-02-23_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Update the kvm_run structure with a brief description of dirty
quota members and how dirty quota throttling works.

Suggested-by: Shaju Abraham <shaju.abraham@nutanix.com>
Suggested-by: Manish Mishra <manish.mishra@nutanix.com>
Co-developed-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
Signed-off-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
Signed-off-by: Shivam Kumar <shivam.kumar1@nutanix.com>
---
 Documentation/virt/kvm/api.rst | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 9f3172376ec3..50e001473b1f 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6125,6 +6125,23 @@ array field represents return values. The userspace should update the return
 values of SBI call before resuming the VCPU. For more details on RISC-V SBI
 spec refer, https://github.com/riscv/riscv-sbi-doc.
 
+::
+
+		/* KVM_EXIT_DIRTY_QUOTA_EXHAUSTED */
+		struct {
+			__u64 count;
+			__u64 quota;
+		} dirty_quota_exit;
+If exit reason is KVM_EXIT_DIRTY_QUOTA_EXHAUSTED, it indicates that the VCPU has
+exhausted its dirty quota. The 'dirty_quota_exit' member of kvm_run structure
+makes the following information available to the userspace:
+	'count' field: the current count of pages dirtied by the VCPU,
+	'quota' field: the observed dirty quota just before the exit to userspace.
+The userspace can design a strategy to allocate the overall scope of dirtying
+for the VM among the vcpus. Based on the strategy and the current state of dirty
+quota throttling, the userspace can make a decision to either update (increase)
+the quota or to put the VCPU to sleep for some time.
+
 ::
 
 		/* Fix the size of the union. */
@@ -6159,6 +6176,17 @@ values in kvm_run even if the corresponding bit in kvm_dirty_regs is not set.
 
 ::
 
+	/*
+	 * Number of pages the vCPU is allowed to have dirtied over its entire
+	 * lifetime.  KVM_RUN exits with KVM_EXIT_DIRTY_QUOTA_EXHAUSTED if the quota
+	 * is reached/exceeded.
+	 */
+	__u64 dirty_quota;
+Please note that this quota cannot be strictly enforced if PML is enabled, and
+the VCPU may end up dirtying pages more than its quota. The difference however
+is bounded by the PML buffer size.
+
+::
   };
 
 
-- 
2.22.3

