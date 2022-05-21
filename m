Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18EF652FF61
	for <lists+kvm@lfdr.de>; Sat, 21 May 2022 22:30:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345338AbiEUUab (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 21 May 2022 16:30:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233059AbiEUUa1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 21 May 2022 16:30:27 -0400
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA9295AA60
        for <kvm@vger.kernel.org>; Sat, 21 May 2022 13:30:25 -0700 (PDT)
Received: from pps.filterd (m0127844.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24LBs7KX000406;
        Sat, 21 May 2022 13:30:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=proofpoint20171006;
 bh=4sZjI28qI7EYRitLQCA/sag8F7gKkQf4zjdnL1W5UIQ=;
 b=MCtGjwP5NY4Sq1BSpMUIBn+LDhUQkzsL8Da6qgaHqivV/zbW9h9bWJ+02bDnPIHsfzgz
 aVUA2ED5xzGWdtF5851ikg5xJQ1RppI0bWmI1+qQ7mRtYvulj1L6dmeqTHuG7oz/EZHe
 D66PUEWMzb2EVbnbtUdGAMREUU2rfgieYsv8ARHqM8gnm6XpOpdltp8cqOW2P1mUVCgC
 vGFHVQBM3Q/sFIM4tsMoaeWxuKijxKG1C/smh0uDEVHJvPPy6RFvzmtekJ61xljWiBte
 bVknTxwWbdeJB9AxFxRIosfrAm+zFc4br5GTM0Fw5DFgTCdMkOb3CF0opA7pRdIqNM7H 2Q== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2174.outbound.protection.outlook.com [104.47.58.174])
        by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 3g6ym08fuk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 21 May 2022 13:30:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OpveHVWFGVJA86eYWAmLfhrGDfHSoDkXo0AQFy6edPP6qqE8UCTNYqJF1JC731hR++gaH6TeTi1PwYzP1ba2IUSNdggU+IUjOX6xBP01j1ZfcthtiKq4HiUVo3OvR6C0lkBAfVyROqC+eLq0LrJiAS4EeeuL2AUcSITPyTF7t6ZbSCJ0LlUDu1863YOR5M2UX96jjdnxMv8yPCxSzp6MrdQ5jyFDr6Ax37ACstCTDS8g9Sl7Jf5+IWW2AdGnv77sG8RabztmpofPv5dUIfU3Z0HUUHENMiT2qN7C4Lmoey1JYZZcYyUXXGT43utJ4M/Z1g3QK2CVBaHvXrDcvZygbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4sZjI28qI7EYRitLQCA/sag8F7gKkQf4zjdnL1W5UIQ=;
 b=TVsdhoV9CS7FCYBmQB92Ed/oHLdNb8N4pgtzjoB80d4rbnYaNHGOVa7wPKoCh0RgPNXKtkri3mQ7D0BMnZuq3VBGoVjwovCn4FVR3rOzfHap3dESv5NhDYFagsDroZdhgFasbHD4RgK0G9yPHGNAKbYPGVvA+MINLqN923/ytbW19Tlkl6A8E/EjlcHbWKtuIX5hRgkzPNZtq0vukVP5whCHrEc64g5IOkboj1To0yf7gY8ayqokQxRoRyU7wILkqAxodSoYSNMYDXQ0+lq1KUH+XCjjCB56IIGmDHyo/U3DotHgN8nEA5fT9wssTEonNWSGR9faQTHNrLYs1kgB1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by SN6PR02MB4319.namprd02.prod.outlook.com (2603:10b6:805:ac::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.19; Sat, 21 May
 2022 20:30:06 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::6819:797c:706f:9a01]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::6819:797c:706f:9a01%6]) with mapi id 15.20.5273.021; Sat, 21 May 2022
 20:30:06 +0000
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
To:     pbonzini@redhat.com, seanjc@google.com, maz@kernel.org,
        james.morse@arm.com, borntraeger@linux.ibm.com, david@redhat.com
Cc:     kvm@vger.kernel.org, Shivam Kumar <shivam.kumar1@nutanix.com>
Subject: [PATCH v4 0/4] KVM: Dirty quota-based throttling
Date:   Sat, 21 May 2022 20:29:34 +0000
Message-Id: <20220521202937.184189-1-shivam.kumar1@nutanix.com>
X-Mailer: git-send-email 2.22.3
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0064.namprd05.prod.outlook.com
 (2603:10b6:a03:332::9) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f09df5e8-06be-47aa-3e7f-08da3b68b12d
X-MS-TrafficTypeDiagnostic: SN6PR02MB4319:EE_
X-Microsoft-Antispam-PRVS: <SN6PR02MB43190AE642E28E3D7360437BB3D29@SN6PR02MB4319.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sslZgKUNEV4rhlTsPPShihT3CH9btGEDrsBQNAc28FbJBzCjCxhhjN+aWPvHF503kMZanu/K4LczfjlNDQe8Lt/+lUp1zvs2Gk0w6W7D+Tq/bLK4DRLy1B6sm2j8RxFodjTQ/xxoH2utDZ2utGDpxCXz1E0Qzdqp5Id4PA5P/cSWPRNFarHxSYFNS7b0e5XLjQBIbir8FqJxYkGVjHzWBoH92TPdmuXpRHc64PMwfe32DbXJUmNjs+DN0hgxftlSNOCSOReguPnKiTNRcFuE2iq4YFumM07dIIVUcQDvEVgUf0I5qPzyXm/FC3/vsJ2kHHcQJNsmD7FahuqjcOUia+oYdEHq6O+nAUOp8+qTl/usz/OtWquiY7tVR1MvIiAmwzDSsmVXdQdnt2GOQeL17KRSWefyJORkKn1JaXuX3FfevjJvGqb40+TzWQxKhBQE3iAsrRo4c0GaXE7rIlm07/T7MUaSOGKvgeInhBKtMnFBeBwHU9UXaP1/JNnILdgwSJw1l+WZ3LCPHjUZgZp3EYZVQTqo7WHZHMGz8wQj7f87F0X96C80JoyD5OpliRuLsQiGqMyDpAZ3+zE5z+Yu690R3wBiZGregvcybO/i5X7pIIwCGLxdBYcGpFU48CeHDhUVBMyYnPmQF7HtnbLU+gEzZhRA8YquY5nxuKt/CNIemr7gey2s1uBdYXsdbPu5VlcMrVL88y+QQpX+532cCniZLxkPPjGseJEgsllRaNiso0dH5/iYI5VJ/w7VhCHZ4t2RV+EXNZLh/6qEAYnguhGT2Wm3Al+e1OPAv9Lbav7PkFdaKSuzaNkATN3RpNULzS02LA+jZ+AndFBpyeYoBEtRp38gomTcc0JiuLl6QTE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(15650500001)(52116002)(6666004)(66476007)(66946007)(66556008)(2906002)(8936002)(5660300002)(508600001)(4326008)(966005)(6486002)(36756003)(86362001)(8676002)(6506007)(6512007)(316002)(1076003)(83380400001)(107886003)(186003)(38100700002)(38350700002)(26005)(2616005)(14143004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3e6qV2OY+FdreXImFYd74644JaLVzNeqnC0NyKaQKODGIUFeVRI2uGzBvDlX?=
 =?us-ascii?Q?wYi3FQVmArz02luqtLizTVvvsnDoBDQYa2zfb+g8k76xYJFYyyTpAeEw8p1w?=
 =?us-ascii?Q?lPRvrVh4d1gI7Kf0Mw1qJ46Tn0cP9t9713m5Dm4pAdbkifJYx6/CPGzuF3CK?=
 =?us-ascii?Q?wK+lEdy9furFOGR78RNorwNu7pzZ/WlIjfG3wL+/Ux2TVRklk3tAa2kL1xb3?=
 =?us-ascii?Q?qCe5IDpMEDIMDXJTvy1WEO5j9dVsQTIemSbJU+3vIS9WjAnfyGfWQkGoTuyy?=
 =?us-ascii?Q?bFcpM9kOKdUrckvy1Pu+/ADIPubWLhZOM7EWT2+9JW6YFMvAXtEGHSLhRwR6?=
 =?us-ascii?Q?qgVKgVUA7PGyGkdfvMmJ1OnpnxdemCpqIG18vZa16oKALYfSnfK1hq47vmMa?=
 =?us-ascii?Q?VCi92jrsbPgTLicjCVkqviLK1mQouG5DaZ0quwxaAAQvyvQSew1dtIapuQaD?=
 =?us-ascii?Q?akZ649/3Y442dfgPzys0CflTTotPZLK3LHx1YOrAOK2gz9k/dl2MMoTH1h91?=
 =?us-ascii?Q?42up6292BtN/IGO4MVA0ZpaD4JcLkDM9+Nk5z2CAB/vS2mho8MhaEuJfJewa?=
 =?us-ascii?Q?rZPAtzlbCjk+0X0eiYL8HoeArIrcFvPIqp5QtbBFmCEaxrwdb1R1DrxO6sMF?=
 =?us-ascii?Q?mAQdUvyi5dA1XjgJhazX2aOOFj9Dsy1c+RH9jjTMNSopj9CLsHcgREF0ftJB?=
 =?us-ascii?Q?WSXw9Mjr8gZ1/ubell6sXc5TlhtgjKHyQ77S2hnFkjUxE/rTs77h/BRQwuH2?=
 =?us-ascii?Q?+anflrw1LEF+jczFEB2IbHX9PnjG4m1K5GLMWmOAThyyyEFwPuUlzl/SLRXU?=
 =?us-ascii?Q?qsvgKbNPvuK/YRItgrUXYAN8zs2EXmpV+53eK08cFwl7sDarrODP/d4ZH2wq?=
 =?us-ascii?Q?xoLbkk8IJxq6Xgp3S4mukek0jvWQ3tJ8EnblqBt6fkfJbzKFXMJuNxX/B7RA?=
 =?us-ascii?Q?IumNJwHVn54EqW43zGshCUWMZKUxfr7UFWVdjOQTVhvUDx9llbb39XJOXhG2?=
 =?us-ascii?Q?77vMEpsnrTe6EOLpwVmSTNY+s8ARlboPEtZbQl7FAKsNHpfeSA4rgNaMU6Ck?=
 =?us-ascii?Q?QrGajeOZ+/cEsTl72XC7I8+Isak81igbz9haOQeJaz1T4g7u0FbQOMN1wjnC?=
 =?us-ascii?Q?fE7TjFCergR3OgnxOLBRtLoDMLYeEe6F1bBLn9k0ZRLFWebF0DQ9mRgH65eH?=
 =?us-ascii?Q?Bkr6Wjs2452ThaCYbWxTDMcMWG4SiQqh/hFYvXW25AoAv/u1MzpanhjKQAPP?=
 =?us-ascii?Q?P1szCigEYWzH+ZDKmWflnUKMV7LX6oFeogJ4rtHnAQLeeFoFjSk5G3t4v5/n?=
 =?us-ascii?Q?yxFrJ1zJB6v68wNyqLyYuRs3miqT1X7K/TBaJaJL3KTLT5E+tTeFJ6zs8LZi?=
 =?us-ascii?Q?uWPJMb5f8pHHv8DE/HSurz/SyuJwubXnOg5ETFeyeVDnfOa2/hzAyg1QowtW?=
 =?us-ascii?Q?ngFbpanNpV5PNaBkhQtFbOxoMnZt/GGXXF2foB0271Lr1qdmZo8QpCbx+wew?=
 =?us-ascii?Q?oQt8AQwoxzmAvY5+Dp4A0gI7BHw4h0AjQCPKU+BcgySFeshHup9nAoK77fmX?=
 =?us-ascii?Q?B08x6TMkx8HYLxCvG0fBu5XGB6hPxaaeFld+iL/PF+22ApoC5S5rRRTmkjUd?=
 =?us-ascii?Q?+bElCZgwq83cvuqn0mvIN3PeLytqoL4GEgwmCX5xx5y1KQaMfhK7aTBGR4B7?=
 =?us-ascii?Q?SazZ/Q9MQB2VRtnFuYtdSr5sGXf4PGPtyB053fHnkjQPNuHK78wsTyeEMWcv?=
 =?us-ascii?Q?9SKyVtmSXU1Ji/nhfPDU0OBGHDj73YU=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f09df5e8-06be-47aa-3e7f-08da3b68b12d
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2022 20:30:06.3859
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TO7XJlmFwO6gw1XkobN7ucFF7YDgRh5InzyHwG7h+CEI73pGxpGD0+fmVGDc28XNucwDamQb+p+OkErjBu0p1tQI9EfUN79lRrpGhaq1sZc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR02MB4319
X-Proofpoint-ORIG-GUID: O4gNFE9vg8_OpHyqn7PCiZsTsQLnsBO-
X-Proofpoint-GUID: O4gNFE9vg8_OpHyqn7PCiZsTsQLnsBO-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-21_06,2022-05-20_02,2022-02-23_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is v4 of the dirty quota series, with the following changes over v3:

i) Changes in documentation based on the feedback received.
ii) Handling some corner cases, e.g. adding dirty quota check in VMX's
big emulation loop for invalid guest state when unrestricted guest is
disabled.
iii) Moving the s390x and arm64 changes to separate commits.

v1:
https://lore.kernel.org/kvm/20211114145721.209219-1-shivam.kumar1@nutanix.com/
v2: https://lore.kernel.org/kvm/Ydx2EW6U3fpJoJF0@google.com/T/
v3: https://lore.kernel.org/kvm/YkT1kzWidaRFdQQh@google.com/T/

Shivam Kumar (4):
  KVM: Implement dirty quota-based throttling of vcpus
  KVM: arm64: Dirty quota-based throttling of vcpus
  KVM: s390x: Dirty quota-based throttling of vcpus
  KVM: selftests: Add selftests for dirty quota throttling

 Documentation/virt/kvm/api.rst                | 32 ++++++++++++++++
 arch/arm64/kvm/arm.c                          |  3 ++
 arch/s390/kvm/kvm-s390.c                      |  3 ++
 arch/x86/kvm/mmu/spte.c                       |  4 +-
 arch/x86/kvm/vmx/vmx.c                        |  3 ++
 arch/x86/kvm/x86.c                            |  4 ++
 include/linux/kvm_host.h                      | 15 ++++++++
 include/linux/kvm_types.h                     |  1 +
 include/uapi/linux/kvm.h                      | 12 ++++++
 tools/testing/selftests/kvm/dirty_log_test.c  | 37 +++++++++++++++++--
 .../selftests/kvm/include/kvm_util_base.h     |  4 ++
 tools/testing/selftests/kvm/lib/kvm_util.c    | 36 ++++++++++++++++++
 virt/kvm/kvm_main.c                           |  7 +++-
 13 files changed, 154 insertions(+), 7 deletions(-)

-- 
2.22.3

