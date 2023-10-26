Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 396777D7CBA
	for <lists+kvm@lfdr.de>; Thu, 26 Oct 2023 08:11:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343958AbjJZGLk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Oct 2023 02:11:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233233AbjJZGLi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Oct 2023 02:11:38 -0400
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10A29115
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 23:11:36 -0700 (PDT)
Received: from pps.filterd (m0127840.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.17.1.22/8.17.1.22) with ESMTP id 39Q4WJOp002470;
        Wed, 25 Oct 2023 22:43:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
        from:to:cc:subject:date:message-id:content-transfer-encoding
        :content-type:mime-version; s=proofpoint20171006; bh=uVrtHS6tpJt
        JFPYRLQTP7bCxWI+yHPfjYCxt5/A7xG0=; b=xE0/9SZ8BmtCnro4ApP1rEdHrJ6
        Ba8/V+nM9ofiNojuF6t0zX20WEqdzywkTX20sOBccppoBiPQryDmGwBvfhJczwCK
        9jPxE6auefUbartZmtTLv0Y9HHlW4QHjs+foKUTGPlS9cVWo7s7v7XTQ2eWQ5Elz
        sEiodu3W63nT5KdC/Bxdjoe14/qpy+gBirpE1FhXnW1lM4fb9XNKr8FKo8MQZS5B
        LzWochFSEutVNrxZehixw9u809d2M4nXjLEvJ/z7us7qNIYK6kkfLkqVySR0OQ73
        Qpd415n3NnY1bnR9q6xmxLtddAPu3c6aA44KMVQuYU58SmDPwgd57xZbEww==
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3tvayqyjrs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 Oct 2023 22:43:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TBIwvqcEtLisV/G+lvrxpxH0lIZbesRzYjCY0zcmxgxWiVtSy/AgaOxT/LB0gRHLx+luaBmKQ360WcW4nqhy8oI33fmxptamXVpuZ6o1Lu3xfaaatvgoKCvQTV79LXEaajQJAhEk9brDdYpK+0P4vaD5Inm98k5rDo33aThyO8+LfirI5aSquyAXRV6/MpwPGzfmytE3YvDogDWoFV5+uLcKb1aG7pcz2eelwZkHkYcAhi0UjXu6vuRYp29xIKO45Wh8ys4MoSKVna7CiGH8jMmqekGwkmq3jqf4BQ+B7ShL11r1xfiEhB8uHSWtJJcwyGRgCn/n+V03jeY0yCXSOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uVrtHS6tpJtJFPYRLQTP7bCxWI+yHPfjYCxt5/A7xG0=;
 b=l3ehV2raQ4vdzGQkxDCqkGMH8EjXScmK8lqXqPzrN0Hn07tr1I39uYrLchq3+klumJsAwYCpzkXnGxiPdoMGKAKkzlQUVtkD2bZnvFxsl7UVFy8FNV+L0nDIbbEhSjRPEMhm2iyhvFXQGHHjLWN4UdH2HlcyPrxXYisJqYz4J3pObIcWmSWzEoXfxY/ipC98KkC5WUGNRiUIDwBv+SlZqB0cPxqX3b4wpDXN6fiYCU4fPg3M9NjKMGehx2UXalZ8etrf5Del7CqBWd0Sz5CogkFIJLmb4YYzRDlfHR3v1FFMEkIIjzX5rbliempD/F9Bfh6uhv9ZR6KaWvmKccj5Zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uVrtHS6tpJtJFPYRLQTP7bCxWI+yHPfjYCxt5/A7xG0=;
 b=cCqipeqLJ2pHjykk1gE89Dybd/PDr7ZEjK9Kl45EnwkUdi/ZnA5gd+SKsLUU9dXPylD4uiJp9t6zwOJURVbS024E4VqSj207iz2nGMHMWuWn24qk6LlVPB5CbnslEIuy+8fdY22UTlUId37Uv7gUrDju5jEvASqVyBOMDyG95QuBiTQqpFW+DfiAWk6G4t/snoHHFnsKLhJECZUGN8vYIyt99i94P7KNJ0qo87wMGpB9clU32pnLgVTvM496o5KnUfWsKOULqRhOnCZEeHc2+QqGRjL2dRqiemD9vsj+Y3ZZQ36bWCyloaVGveSuTaJ2fWSKemczkY3OlwKqzhBurw==
Received: from CH0PR02MB8041.namprd02.prod.outlook.com (2603:10b6:610:106::10)
 by CO1PR02MB8507.namprd02.prod.outlook.com (2603:10b6:303:15a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.33; Thu, 26 Oct
 2023 05:43:32 +0000
Received: from CH0PR02MB8041.namprd02.prod.outlook.com
 ([fe80::22f:727b:8c9a:e456]) by CH0PR02MB8041.namprd02.prod.outlook.com
 ([fe80::22f:727b:8c9a:e456%6]) with mapi id 15.20.6933.019; Thu, 26 Oct 2023
 05:43:32 +0000
From:   Eiichi Tsukata <eiichi.tsukata@nutanix.com>
To:     pbonzini@redhat.com, mtosatti@redhat.com, kvm@vger.kernel.org,
        qemu-devel@nongnu.org
Cc:     Eiichi Tsukata <eiichi.tsukata@nutanix.com>
Subject: [PATCH] target/i386/kvm: call kvm_put_vcpu_events() before kvm_put_nested_state()
Date:   Thu, 26 Oct 2023 05:42:01 +0000
Message-Id: <20231026054201.87845-1-eiichi.tsukata@nutanix.com>
X-Mailer: git-send-email 2.22.3
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0050.namprd05.prod.outlook.com
 (2603:10b6:a03:33f::25) To CH0PR02MB8041.namprd02.prod.outlook.com
 (2603:10b6:610:106::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR02MB8041:EE_|CO1PR02MB8507:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a05de5a-54a4-4a1e-10fb-08dbd5e67d2a
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QKWB6o5GxjraEbnAXSx3I+HltIr6JEXRAmauILw5aa4aMk98+H8Tod4nQXSqig+4i6sOqbjj5zVj/2//1/wURVMkBBNJzoRAFoFlmx5mgtj7ZRwl9asyJXwxN25krWzqogVQDTkhDs68DOsYvvHGpE1mERCnab6SKKoGUTbxm9enj9of1sZ12o/SyrdE2E6akVRhsVxKSC4z6EkasBtkyMwdslTrqtq7f5GNYkK+GNHnevAp3my/bILWPcVj3l5+vBNxEWOtNwG7QNFgbHvZgvf5t+5jG4lWeXCmef1e2b3APFyohD2SNdasa9urZ/X086f8SAw5u+vSeAbqUj5rnNSaj1FCurEhjFMDG2FSMz93aoBadmvstolTFwNvfCXB5bHF+FY20hXgVQMLjABQf71dce5wwK7oqeeiODnj8XNrHnHlioRFHwQSCsHm5pxNK8ZmpogooAyElBaebQT+9H+1yPqq9nTB6zjR1UnvsRqZ1LdEeyZSfQyyths5bSOZGj72bWoMcvxQsun8F2hAf2ndrdvJVU+ijma0AO3JjpY8hnBHJpCC/43TCy0QT4xblPEFHYPT1RU2hfof5FIA9Y42gBZeJ22MQpGEAj/qesFMLi2wNDRJdCG3yTXKceWO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR02MB8041.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(376002)(346002)(136003)(396003)(230922051799003)(1800799009)(64100799003)(186009)(451199024)(38350700005)(316002)(6512007)(1076003)(66476007)(5660300002)(26005)(66946007)(2616005)(83380400001)(66556008)(38100700002)(52116002)(6506007)(86362001)(478600001)(6666004)(36756003)(6486002)(2906002)(41300700001)(107886003)(8936002)(8676002)(44832011)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YwnCY5zj0vOEhFfpcNelwx2okbM53nLyjuIJGISHVoIOpPO52Zo/lGl2ePUO?=
 =?us-ascii?Q?w9dah8lPG7YI45d0dzXwWsiXXPaF9br2YE3wwIs/zn35fgfyyRvrT3nxNMz3?=
 =?us-ascii?Q?Z3eUKlFdutqoytsqcNXIMtbmYJPLeoVVNJ/cn0wPDArHG4m7zbenes35ekUC?=
 =?us-ascii?Q?uCROlDHt8k3c6Zt1umZvdgjk1dpt3+hpPk+iOCNOB8eAKtyIItd3HWPv8iQf?=
 =?us-ascii?Q?OssgTc5C3467RxyqOvByK+W0cGQK5W5CW8FXOgteLnw3SCmUyL3riow2A0Lw?=
 =?us-ascii?Q?GkWaH14WWMvN5zRUWvnsADlP4KsVmqa3kMimJvotR6uLGysRpGULeMVXoxhO?=
 =?us-ascii?Q?nUcaLbz4PP7JLS9dgx/JWhTkpn3Sq762s0D5YsfC+Z3+7P8AYXxI4CxYZnzZ?=
 =?us-ascii?Q?59dyOcNZ+wfUomxi1zRYi+zb29L9aPDbidQjMizMChwMoLbRe/mNI7nEb6io?=
 =?us-ascii?Q?aii4R+8wSlDVGWP73flGWV0dJexnM5oF3rgX9z+xajZfOFlACgTQA4sLYGlC?=
 =?us-ascii?Q?vYQLCCr7CbrVt6leQmAa2M7oyvKFIj7VPuLLUX7o8RseSwuMpzqMQHEBpnMC?=
 =?us-ascii?Q?5rQu5zy36uh/EydX5P64cfUcc6KFGPzAbRytcUPU4dr3VbUetAuC2ZQPGjG5?=
 =?us-ascii?Q?aYZW7x4f09Vefq/BbDetpi2UByi5/EoLUTkSLqKavWxV+HDuhcMRyPaPJTZ3?=
 =?us-ascii?Q?GiGUomFJHKJeEvwd5ydlDJC1M+hpF2c+pY2l3lDOi2/ypkiAl9ecWS44ZtLY?=
 =?us-ascii?Q?rMDsCZyTYrsZHOoallNdfe8nKjsOxlvm0wCG+fGAETjPvDKSCOvwX83hNjD1?=
 =?us-ascii?Q?YZgWYm6InF0+v3mms5j8L76gsXuJURBpFn7lR6jYOdklRSbXpteXwm162eV5?=
 =?us-ascii?Q?22kYG6wdYmbx+nHbP8JML/mj6VhiskWaxH+bQ2z+69zR1gMc6JPvYzdfZLAG?=
 =?us-ascii?Q?jvZB2MkEYz/uVBXJOsBIVJOaWS1oAPFGWLN9oPUgOgzk0QwyBdxttJQnJALJ?=
 =?us-ascii?Q?2vp4y1cVeu/G5DJGjRJYW37hSWO+/i22+xfNDM0b2j2wJ6d0djxvQzcyCAlM?=
 =?us-ascii?Q?i8Xx80OyIwNNS8wda/REZ4nsMq6Ja5lvnubqM2krcCTnAbLgqScKp9Hw1vAz?=
 =?us-ascii?Q?5nbTRX0M+bchjNzNuo1scT/L1slq+mmHXfjWOQt85y96L3HRaNAnmBJBOh8a?=
 =?us-ascii?Q?lmgEVGW0pHKjOli7TTRcN8I/w2J9WHmC7KuhAAXwCQe/ip5D2CnHgI7HaZCk?=
 =?us-ascii?Q?SIq39lWZUcVedSqsxtd/yJqvQ8DgFxSxU46zW1eQynndZ/wplQ4ACBjyravV?=
 =?us-ascii?Q?sr8wPpADUPkfMCZ+/vRQybr31CaNJytMG2YKl/P/BqVVNPz7pgUrv4jdoOpd?=
 =?us-ascii?Q?vJXL1kW0ECPUBVu9Hm30u2vrEMO31cxQoktLngiAdUEdgE4z7eTEJ62c+fPx?=
 =?us-ascii?Q?PFQ6Z5gU88lptWjuaTiQgF+Z2sg5uyNckXO2tu15X6mCARnSRYP/PUJRJO/r?=
 =?us-ascii?Q?tkyUtW6cnRRaFKij52OjPu7cz3fdf+qZooM1YCGFOgY9Vrhp+9y5bdotulTq?=
 =?us-ascii?Q?jZXsNVGwfrPm/cTsAqFzMxNp2MH3LiysiiA3IAC1HwkS72O4jH6BJItHjYBt?=
 =?us-ascii?Q?UQ=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a05de5a-54a4-4a1e-10fb-08dbd5e67d2a
X-MS-Exchange-CrossTenant-AuthSource: CH0PR02MB8041.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2023 05:43:32.4082
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NT80kb0GGbYoPbsk1L4FcVT707IueJXQ5WYbt/G7XbsJ2HTstlY8EFVTJcLq67zuDL/xvJ/Std+c9Bk+T+oLW7UHy60rnw6/mMwWSUbIByk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR02MB8507
X-Proofpoint-GUID: nRZPC2hy5-zuuFmOsCLJUALz8xA1r62R
X-Proofpoint-ORIG-GUID: nRZPC2hy5-zuuFmOsCLJUALz8xA1r62R
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-26_03,2023-10-25_01,2023-05-22_02
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_put_vcpu_events() needs to be called before kvm_put_nested_state()
because vCPU's hflag is referred in KVM vmx_get_nested_state()
validation. Otherwise kvm_put_nested_state() can fail with -EINVAL when
a vCPU is in VMX operation and enters SMM mode. This leads to live
migration failure.

Signed-off-by: Eiichi Tsukata <eiichi.tsukata@nutanix.com>
---
 target/i386/kvm/kvm.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index e7c054cc16..cd635c9142 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -4741,6 +4741,15 @@ int kvm_arch_put_registers(CPUState *cpu, int level)
         return ret;
     }
 
+    /*
+     * must be before kvm_put_nested_state so that HF_SMM_MASK is set during
+     * SMM.
+     */
+    ret = kvm_put_vcpu_events(x86_cpu, level);
+    if (ret < 0) {
+        return ret;
+    }
+
     if (level >= KVM_PUT_RESET_STATE) {
         ret = kvm_put_nested_state(x86_cpu);
         if (ret < 0) {
@@ -4787,10 +4796,6 @@ int kvm_arch_put_registers(CPUState *cpu, int level)
     if (ret < 0) {
         return ret;
     }
-    ret = kvm_put_vcpu_events(x86_cpu, level);
-    if (ret < 0) {
-        return ret;
-    }
     if (level >= KVM_PUT_RESET_STATE) {
         ret = kvm_put_mp_state(x86_cpu);
         if (ret < 0) {
-- 
2.41.0

