Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C536C62711D
	for <lists+kvm@lfdr.de>; Sun, 13 Nov 2022 18:06:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235373AbiKMRGE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Nov 2022 12:06:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235378AbiKMRGC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Nov 2022 12:06:02 -0500
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70E151275B
        for <kvm@vger.kernel.org>; Sun, 13 Nov 2022 09:06:01 -0800 (PST)
Received: from pps.filterd (m0127841.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ADF5hJ7024808;
        Sun, 13 Nov 2022 09:05:42 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=proofpoint20171006;
 bh=wibz9g+RzUH44IEY66kc29pMI5CvwkcWWzaoDBmo91c=;
 b=PrC+8INP0QodSUIxrdKl6y6SiTIJg0UU0f+rf+aligDEfWC2sQCBft7lW4Ndp9fHaWzm
 QaJftFbCHgUneGvL6Vv+3tUttAf51N4UUhSc0TwbSMFJjcu9q3bXqd6VU99OsJ+03SVQ
 KKMd4yk6eGu4x6AEugmG3/QKjbSGsplFm3tk++SahURyZlMKMhEwH+HerOiN7F9QuQrR
 D5TruMu2AGFEFg+dL1MXo/SA2Iw0o1sh+eFp/5ixVOP4060yxKGlRM9RVc+6l53sMaEx
 D9cpTdO7b2t/EiDtwqLmSG1rBnInLu9/3mwSw8k4Ar8JqIHnhWCQBmot1lCTjZjPf/jN lg== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 3kt9wdt6rx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 13 Nov 2022 09:05:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NFIqvpLr1i45NYSZQFKaVdtRzet2Gu5TdRIFlawiiK85FXkw130aLf0OX3r3OaUhct7GTa0500zVn05ldxnw3ONfO1JzvyrGIfde/zqeXPwwpMekdl97EpocHckdk8OMgICiiqivMnngTydYbI5nV+TsK1PDZWjyq15jaxiB0B9AiR8R1jF60uzqMOWb3mb2Uzb1J46Rd8u6jcr0pOO8MDFGRVF+UyToi0shGenoDhb4Byc4J5dAkyEAMNsBoaEjcgxmItTwsdh5s7X/9n75R6UF6tGl80TneHJk+h6baGvmYwn1HlBJ127HOqOuDjnVx9u+OU3Ryn2r2cLJl30s1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wibz9g+RzUH44IEY66kc29pMI5CvwkcWWzaoDBmo91c=;
 b=A9cuowQ533+YqInnxjDhjDbmK+NeEIP+i+US+ya7QhjEZzM9kgOaxs1sc7mQWZeROG/l2xFRPmjDkvUTjxYEju7OQ9fYtaOLqfTGweoVeZXfkzQQzlomEIiCn6eRaUxiPIBbnq9Lf7TSCqFKfpAI5fTgpIftlcBP5Wt+m5mn5FC4PFNQAjtFDBO7/sSYWXGfciOwtHPCe9NuCHioMwyQM0Kzv4oTKzb5h/Wbtkjs3fjyeHqtZdl/9FP76uN+8RjVj9Ll2SmtasWYBzGPPw/femaDrsdOMqymvLZRgLj0LTRaf8aopeHBxa7wAFJU9D5XDAFYB99b+dtgSUl5PNwPZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wibz9g+RzUH44IEY66kc29pMI5CvwkcWWzaoDBmo91c=;
 b=ElogdTKXo5DuWo42rL3cUYqE8aqaoH3kdTqqu/loo1NwSDl/81UxeCA+T2+37zmqFrMLLSNZ8Rn01xHTAWop90fM8rzhugYgc++y/KEl6MMebUdfGkDsnuib5Gpl/d4AjnNyrXyzd6dimn0Sl6rKSZ/D3rDCBhnrBetX9pdGK/9isQhdDhJgA4pv/bilBsQWZcFTsrMkj7nZWvS91EFYLxEJUseb7Z1w+o+Nze9bY71a/KMhUlAhHItkX/l/CYjiH1y8Ha99aEP4fKHdXqOx81N8ihwkVN7WCL5gbdieOU3yGfwK1Ow/oBO899dvxq75i2aRzTFEH8PgCeNuV0P7kA==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by DM6PR02MB7004.namprd02.prod.outlook.com (2603:10b6:5:22e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.16; Sun, 13 Nov
 2022 17:05:39 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::74fe:5557:d2d:1f5c]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::74fe:5557:d2d:1f5c%9]) with mapi id 15.20.5813.017; Sun, 13 Nov 2022
 17:05:38 +0000
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
To:     pbonzini@redhat.com, seanjc@google.com, maz@kernel.org,
        james.morse@arm.com, borntraeger@linux.ibm.com, david@redhat.com
Cc:     kvm@vger.kernel.org, Shivam Kumar <shivam.kumar1@nutanix.com>
Subject: [PATCH v7 0/4] KVM: Dirty quota-based throttling
Date:   Sun, 13 Nov 2022 17:05:04 +0000
Message-Id: <20221113170507.208810-1-shivam.kumar1@nutanix.com>
X-Mailer: git-send-email 2.22.3
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0045.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::20) To SA2PR02MB7564.namprd02.prod.outlook.com
 (2603:10b6:806:146::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PR02MB7564:EE_|DM6PR02MB7004:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b299040-e389-4f84-2b46-08dac59949e2
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qmnpKw8v2Jxhln24RjiSgA3iWtOe4pGb/W1FOodSLBdeN3OHOgV7NOcTl23rq+kue6DOt47j1+PhFitDRAJMKAvcGVxffyvM5e7l8VQW+LT1SEISuxDy3Jn0b93jqJGnRJ/KmsXYSfxQZdg1gy+7UqONhM7kBPRRcjwFuSQc1s3yocCTQw33jxcmOUY7nS8x+IoxZ4avodK95MVb3qtTLmx0WID5X0lkUQqvIPv0fuvR7tUp/q7vNsbLSrDukVYSPo81turJ1dUT/UM/8LZVDhR4auybiVyuGOVUz5LZIFC04KENBkTKWRkRsJca8RmXjJV0I1WcRgNUG23xVQJjZsT4i8Wkear+Rae4ZdSTr359hFwnmhMre5uDhOqBzVcb1D1QWObYU4J5UfafEuW4PdzghhySAjUD0M32kkNPK3jD6k/1sGYk75/3HdWkKMuYqI0JieWh72JQVv5OocBXtd2B33GnPSdNBnoYGDuBvkaB3REPmPYAei36tpn4yVN1DrvV2liXwjjCiHe5pr2hqRwN5FTWIrQMQgE21CWMcW3/eyvnhl1Y2jRqpqNJO8AzZmR0bM/OyV1c+9l3iJ2cRvUaN+i46jcSrt1kGiRO23z0n6sjIGF+QNcJAKtOKUGviLRxXMjuIQejEfJp8wGxzGLmvCTVrlXTLdY3YjReaMs+v8vxATALem/wnAZA1mEstcZn5I9k0Cc5u35hgsmdHXNk/UXn9ktixzrE/kaLtNSK6bY6YKtibMkaZ+9yFkFqcKB91lZ/l5/SsdgP6faDCeVkqBXe02Hc9MPsFQF7EFwMAS6PW6GT2TjKCOTeHjzAdGjuy/U+jQPudMHuZSZW1YdpPK7IrTYmzSwxlFLJtxw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39850400004)(366004)(346002)(376002)(396003)(136003)(451199015)(186003)(83380400001)(2616005)(1076003)(86362001)(6486002)(478600001)(966005)(52116002)(6512007)(6666004)(6506007)(107886003)(38100700002)(38350700002)(26005)(41300700001)(4326008)(316002)(66946007)(66556008)(66476007)(8676002)(5660300002)(15650500001)(2906002)(8936002)(36756003)(14143004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+8Z2vr2TWAlQciE00d5p40nHo92EKpvlMZvST1DwBZX4+NJaGxpAg3jSLzwX?=
 =?us-ascii?Q?UijSUpGYbWtOiuYG370JcqdIR/0ThAaJ64ZaoZPuPicuNBWfdB0CivcVHVP1?=
 =?us-ascii?Q?zB1bBT++mVoeNz5Cg6WQ3pq0qqsnM06CuIbBc7H6lmf+qcekSMiMCStKji3m?=
 =?us-ascii?Q?ZS5vCGCjIP3GZlwD+R0WhbOTYJhVqloJK7MF8BU9LfhJaHEFlW8md0yU5yu+?=
 =?us-ascii?Q?JonJSEiHQ87TajsWwZkkpPK2vGG9NtfM99DytjGSjuzF+brS+oylvNYN3VuS?=
 =?us-ascii?Q?pBfvPZADr64ZoCgtqpyKOwjYXdwD9EOBj7bOPPBmiKrETX6hgqlIXn8LaJZ8?=
 =?us-ascii?Q?WIeWoL7FMPi5CoPyvZsZHAbDse5/fUO980BqjU9ypS8DGQCrrtW/m41Ur24C?=
 =?us-ascii?Q?cPNzCV3DxEGcuerEEQP0yk7s6B1BUPr3jod4UqZi33ooTCmpIRBk/lrsSd7G?=
 =?us-ascii?Q?LPu8DDcdj7VWfvGv2RDJuyAy1ue6bu4gSwf1rqgopG7+k27ULraH1sQ4g57v?=
 =?us-ascii?Q?AKJoPffc8rRZcKVACnxTHzSYv+CtVVfBl0hAs4cwC7XfvHBOif3u0JQPxfyz?=
 =?us-ascii?Q?vIIs3d1NNJSC9miY1BErK/guLxyMu/FChFwhJh2qWTML+vVplB3lksiFCkyk?=
 =?us-ascii?Q?ShrUuOowgzJ+0jdNXY1zjN10GxheeqEXrZtjLwmbAL5Hjpy+mHdos2PmkHaj?=
 =?us-ascii?Q?IlZxkb6AUclSavnz6VQ0FXV3k1C0a2gwOFggW8GXCgbcvnSfKlULjusS6Slk?=
 =?us-ascii?Q?L4PkWkKbwegGPajG5cVJQtnxp29BymAxQxESJQ7q346DrQ/iQ20epZ0MSATi?=
 =?us-ascii?Q?4lHx9z4k8Qvgd/I1NxTetsyU10Z12+HsJ+TkseJv9AMf5QvrZEOSqRVQDh6x?=
 =?us-ascii?Q?Y+fpK/9Or+dvVr/9KvR8hqcEbTMw+MRSo7OjFov6WDRpX4ASnxIHz3QyB094?=
 =?us-ascii?Q?1bouPv2WnZL+ZnphaB5pnFMuNE+2agIhiIzmB/HCmrt6WkHcqNYAyu2YNpc4?=
 =?us-ascii?Q?F+pIKJUpqcUrxU4p9KLjpzzKl6yDdpYkDerWYFtRS3JnMv0/JYMsZP/m6Z4O?=
 =?us-ascii?Q?DbYCjEzCdR3+c48zfBH4RX4BuVJHelVyVOPSkACH0PFcJytUu1X/7DO7bzHO?=
 =?us-ascii?Q?oenqPhGPoRKiAyhvjFejOvE0xyxCzS1dpRqUjtr7ADyhuAp8WCtrotGW//YO?=
 =?us-ascii?Q?roM2tQH/KT/CRJVOtQ7fkA1jFNrzelZhxG3cRpXysUbSHtVGDQa19CYifOkw?=
 =?us-ascii?Q?AXbfa5AudtFY+BtXrFFpmiSXMSASOnrQr7q3u5pTpgqbbJ9wDgGqPpvWagiV?=
 =?us-ascii?Q?jj/egMAtjQjHfY4kLn12kQINY9to1v66R2KK47rNa5F9BY/2I4i+4IWlnhbI?=
 =?us-ascii?Q?CsAGX1b/ozcCc4IPjhQHz3YGT3TvzABJXe6FsO2lB6ZAXP+qWZS/Y9y0SNa0?=
 =?us-ascii?Q?ZnfoCiGJ7gXUEUGjPCNdQwgQjAkJIWZL293X/1dCrOQQq9Zq3AYedk6MsVQC?=
 =?us-ascii?Q?q2OVdtGCQJo+LxurPZ+YGDdMAHHuPn3LFSxpOM7EE4ylFuXmZS2iJZlD30yj?=
 =?us-ascii?Q?PFh6bt4mgPXBsjNSxwpOze76y7EesE6pMy5epheSN1qxWC7sc/evLz5Cp2yb?=
 =?us-ascii?Q?mA=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b299040-e389-4f84-2b46-08dac59949e2
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2022 17:05:38.7979
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sNhtS16qoARBhddufDJl1YaZxacToxmNjZ5moFMUyCKIUBKP0hu18GX5//rQFycgMPpnkMKQ7z/S5Z+quhUxrzu989ulXHs7PZ9ayiwjn+0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR02MB7004
X-Proofpoint-GUID: i5zOiX94I7alqfSKnxb_Yews60uoJ_Dh
X-Proofpoint-ORIG-GUID: i5zOiX94I7alqfSKnxb_Yews60uoJ_Dh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-13_11,2022-11-11_01,2022-06-22_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is v7 of the dirty quota series, with the following changes over v6:

1. Dropped support for s390 arch.
2. IOCTL to check if the kernel supports dirty quota throttling.
2. Code refactoring and minor nits.

v1:
https://lore.kernel.org/kvm/20211114145721.209219-1-shivam.kumar1@nutanix.com/
v2: https://lore.kernel.org/kvm/Ydx2EW6U3fpJoJF0@google.com/T/
v3: https://lore.kernel.org/kvm/YkT1kzWidaRFdQQh@google.com/T/
v4:
https://lore.kernel.org/all/20220521202937.184189-1-shivam.kumar1@nutanix.com/
v5: https://lore.kernel.org/all/202209130532.2BJwW65L-lkp@intel.com/T/
v6:
https://lore.kernel.org/all/20220915101049.187325-1-shivam.kumar1@nutanix.com/

Thanks,
Shivam

Shivam Kumar (4):
  KVM: Implement dirty quota-based throttling of vcpus
  KVM: x86: Dirty quota-based throttling of vcpus
  KVM: arm64: Dirty quota-based throttling of vcpus
  KVM: selftests: Add selftests for dirty quota throttling

 Documentation/virt/kvm/api.rst                | 35 ++++++++++++
 arch/arm64/kvm/arm.c                          |  9 ++++
 arch/x86/kvm/Kconfig                          |  1 +
 arch/x86/kvm/mmu/spte.c                       |  4 +-
 arch/x86/kvm/vmx/vmx.c                        |  3 ++
 arch/x86/kvm/x86.c                            | 28 ++++++++++
 include/linux/kvm_host.h                      |  5 +-
 include/linux/kvm_types.h                     |  1 +
 include/uapi/linux/kvm.h                      | 13 +++++
 tools/include/uapi/linux/kvm.h                |  1 +
 tools/testing/selftests/kvm/dirty_log_test.c  | 33 +++++++++++-
 .../selftests/kvm/include/kvm_util_base.h     |  4 ++
 tools/testing/selftests/kvm/lib/kvm_util.c    | 53 +++++++++++++++++++
 virt/kvm/Kconfig                              |  4 ++
 virt/kvm/kvm_main.c                           | 25 +++++++--
 15 files changed, 211 insertions(+), 8 deletions(-)

-- 
2.22.3

