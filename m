Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 821F05B988C
	for <lists+kvm@lfdr.de>; Thu, 15 Sep 2022 12:11:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbiIOKL2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Sep 2022 06:11:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbiIOKL1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Sep 2022 06:11:27 -0400
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49A1B2ED55
        for <kvm@vger.kernel.org>; Thu, 15 Sep 2022 03:11:26 -0700 (PDT)
Received: from pps.filterd (m0127840.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28F4E55Q000414;
        Thu, 15 Sep 2022 03:11:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=proofpoint20171006;
 bh=HjGF+nl5YPVKun32b7clHccuZpww0mD0xeLR5o9cDvI=;
 b=S5QiXuEjlkOEBdxR+9ZQNlSDvfxB7ElBwMd+G3M7kmxuFn9iUXC8e9eP0nfvVxf6cf5T
 WSer9Y7zM32wdgJhGEDwnQrqVQBVVBfKjxk36AdGfK+xwcKZBnUnBttryI6MR/9bWp8W
 2duL/5kfn3EPkmun6rYukhgdMW9YiiA31GVC6wVPNhR+f9n/ynCFBhzJFROLhyG1dPQt
 QiP4x3MTonwWN+7WNMgt8YJFu3kWv/2gf7RNFcEGmXQ9VykyyjiQlyg/klzTCqfrloL4
 Bhtu3uV61G3tGyE5i0CsIIotoge4AK9zInkqtPOXaaakf1N5629AVY8ZlrAZxIYE9bHG 4g== 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3jjy0mc87r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Sep 2022 03:11:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=drOhHQlfzQLgPvJr5m7ahh+M391ziqIW91SHV8TIwSrmCAbJ+/A/XnRUrZK5uKxowQqsGAh1Iz8osuoHR4fXzP1xw3pl3dutgLYNbyZ5NgoxMutAhTAqyJcAd+Hn4B5kmMc3aYbQt3hXdsPN/8ZxQ5tgmhbPUNJUf40wiZi/+fKySkWeGv1NJfjJY7xoGC/qUXJy+hEUFZ0zFOEF9G64bMgwNttb+8hX5nlbTlFWOsjBG+QTihkVkKrE2ndyvB39wiMouih5mop5RQwofch6Fv/G1TsS3kBkc0PZvSbdTuQkihR+qbh3KtfWYvGMOo1J3yJf5AqzNKxLAO1BPkdO6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HjGF+nl5YPVKun32b7clHccuZpww0mD0xeLR5o9cDvI=;
 b=efBFnN9JbVHTDT/kSrj8TS5DqOgTSnGhRnReSKPsvgs7koLj+3aPLmtX/AtZprmXGDDAynRzPvJxswhk2M+s9Ong0CFSAoAFCKXpWH2nNkw6pGbqNcIsjj9q4lWDRDQFbWoSymuF/fenQZA8FKn+u1QPO2tyemO/+JDpvzu5d3ImyGXRqEwZdOJj+uyJVnB/IK6PNuKSgtKnweozpDwwAV3Edc9Pjtt3oHrvxAtfNknKc55LQMCPiaCji2ObJ5Cx4+nYoFjGoy1zyHXUSRaHqoDUbvuyf6w+gNTHedG8r8F7kjjyj2i7+oDtzwBKB9pg8P2pMftD4SbLW/tr0MLbOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by SA0PR02MB7370.namprd02.prod.outlook.com (2603:10b6:806:e0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.19; Thu, 15 Sep
 2022 10:11:04 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::bcdf:6d6f:e6e:b9cf]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::bcdf:6d6f:e6e:b9cf%8]) with mapi id 15.20.5632.015; Thu, 15 Sep 2022
 10:11:04 +0000
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
To:     pbonzini@redhat.com, seanjc@google.com, maz@kernel.org,
        james.morse@arm.com, borntraeger@linux.ibm.com, david@redhat.com
Cc:     kvm@vger.kernel.org, Shivam Kumar <shivam.kumar1@nutanix.com>
Subject: [PATCH v6 0/5] KVM: Dirty quota-based throttling 
Date:   Thu, 15 Sep 2022 10:10:44 +0000
Message-Id: <20220915101049.187325-1-shivam.kumar1@nutanix.com>
X-Mailer: git-send-email 2.22.3
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0235.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::30) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR02MB7555:EE_|SA0PR02MB7370:EE_
X-MS-Office365-Filtering-Correlation-Id: 085195c2-39fc-4252-8873-08da970298ca
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pRiXJn1Wh+BZmaaVqEUw8j5vbgEF5u8VSX8VTxH99VuU2+ZN5pbRVyECYjZ18FrD8XcN9Frtcl7KVw815Ory0H27XIHlU4+M3T0SWQNrT8yzHtvSoq/gxO4NmPCyMMFbX8euQ3c6wq4WgT4Layqvc6SqPKTvsWNXtiBhW58Eyj7Kaqqzuyg7I8r9W24cwgKnJhSW8nEf3w75y1YAawXVl9GmKWZgu1ddqcHLX4hOM+lY7pkfTNlYhmmH3hjP7oCmQ06j+WyKlEBzcv76hPzxTR/edHOlhKACZOdWFN6asZK1OUtJ7B7vLA8/rev3fOAWxSnBHK4ut/oCt+auyTwLTuaYGxTAeQKxKc8VJFA8fYWPFP1RJm20m9ci4ws5OSWvl3md3Atx8nO39LvBoo5yfPM0LddAee1p22tXVRDFrM3auggXLGY/DLLyShEBIur1KI+57G8rQ7SX3WOGSlosxcrVr9KZJZrkELS8SiPYZWrwpS42NHhgRxPBI1ykPjgKGhYE2Op0P94DqWn+ifIB4UNsFX9Byf2vwkJ/PDkdOmhXEaB8/YThiCOOCctD90Nptt9Oa3yJtE1JuXtLPEruhQ6MoqkWa1l5A9ehfHBsykyruy5e0Lv0ZYIR7Oj90R6NVUWfVpoJc7Ygk2H2N8t4eZO30c4aQTJCejgE9BKN4SiAw1fuJ+c/4uix0JprcQ1yrimybdZHSpCFx64o1OCM0XHURRiNTyTHYCzYXB39C6vDsrcJ9TeJiy+3Q2/820nOEPOD+hfbUD6fcTL1gPNYOuqA7dMxdUtj7jN3tWPrfFtoDWxbQr3NkU948lePui5GMEsdw5fM1Ls4/tRKSuaHnmOUQNMZjr2je2tRjXPB5dM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(366004)(346002)(396003)(136003)(376002)(451199015)(6666004)(52116002)(107886003)(2906002)(38100700002)(41300700001)(66946007)(83380400001)(2616005)(966005)(186003)(6486002)(8936002)(6512007)(316002)(66556008)(478600001)(6506007)(4743002)(4326008)(5660300002)(86362001)(66476007)(8676002)(38350700002)(26005)(15650500001)(36756003)(1076003)(14143004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zstbWV/RpK+Bysl8PSo9LZCA6XQ059ZocJuA6ukk/3E1W+AXXcv+0Vg3OOo8?=
 =?us-ascii?Q?lKUpsoRIipIGdIIizskza66te2RwD3sDDdZ1t8QOzWgc6GhTYi7mhhouPJ9T?=
 =?us-ascii?Q?5LAfMBxU0jz5jAcc42SFnlYDAvQmKmLOmDzJQ+h0XjslYCidBafmd8x9pVEs?=
 =?us-ascii?Q?+Ef9Ppp7Af+6Es7Txpm/4m/NbeeQGvhLQnwz5DsmjUvELalKqm4iXo5fmiVG?=
 =?us-ascii?Q?INuUm1iY8Utrde4pL1na8ih0iwHq5BrYz+ZeGP3kOxd+KXrOiAD4lrSnxZFn?=
 =?us-ascii?Q?ORZ5AqDu5A8XsEVQJIVbdy+axHS4U4q/uHU0BG+5o4kxiveBXBv7/hjwSESI?=
 =?us-ascii?Q?I/3K/tL+agaYqDgow0Aso3L+wp1LCW1epaxnMuTxSMKZDnv4Nd/pywRTIxfd?=
 =?us-ascii?Q?4pSBfsnMVb2tfwrV87B8FlofDeuILsWyjMx4S8QUc0G8Kf/PzFGEvPRYY6Bo?=
 =?us-ascii?Q?GchSxBOK9RSRSf/QCWZ7UZqHADLRqP/FwF+ipa1hmZWqPofvZMo73WJURrKG?=
 =?us-ascii?Q?9Y/hmTQC5XphkTkIU2SqvTe4iYgmogcy/597YnRT7RXTYtuvX3TqczesB4Y1?=
 =?us-ascii?Q?nJCmzpDTnkxbkIXxybMGjucLdpM0HnahyQEehjE3SpPEEJpFcXwysVrK8X4L?=
 =?us-ascii?Q?xXBsjAooF+7S+zDjA1p4R5brgtvT5bS1GWkBir9jUXnGCNXgWpIu+pYkZReP?=
 =?us-ascii?Q?W0HC81sMAAMbkf1T7KW+5NIa4GUhh7JhkJabSpOlHJ7dzawgfT456pZgNGr8?=
 =?us-ascii?Q?OLCWgMYULj53pbFFGzFGHYFTYd8/UHKztHJtxaHa2xgwMnAyQIw8LEsGOLja?=
 =?us-ascii?Q?xy6j2Y7Rjt9sAPR1gB8GzL0E8QSKa3Vc62TQhNi8IPLktP/+pcaWlGKINiD6?=
 =?us-ascii?Q?JcST9/CODG7H7FjbKqKqb1GhV5r3lycEK1PWsaFzn+HTWDuj4SEhjtnZFvuf?=
 =?us-ascii?Q?SsXjgu5aRoiWK3iJBxeSRcN8vm1CpEJnO2GgG0Ta0UL7ql69mfN1PTuoP3W3?=
 =?us-ascii?Q?zUskrcTzr79n2/aSeS094iiWnNjlRDO0A+BSQdqXR3Cm7gYoRHQZCQUGk+qe?=
 =?us-ascii?Q?jMS+MUqLlYhpWDGEPe0eTzKtj2CDgqhv+37YNHtjSNgFL3IbAApzZutDOHp/?=
 =?us-ascii?Q?OJKLDuj8ZPFKhGHmOc4jq83v3DBvWGrZe5MSJjUy6dHrpjMuhIeY5gP6YD3I?=
 =?us-ascii?Q?rFC8tyGJW3Do1/e9/PjvLdvc2tSaxOGnICZGF2imwHS1umFzFSNZ7K7aphTA?=
 =?us-ascii?Q?3iqObcsfFuv5gn6gHXlNLgDKXFbJSHIJwKiCtgKaKZOzggzPrK1KFEbP81vg?=
 =?us-ascii?Q?nhZj+nb/551C33KS4GY9L+tpwtT5Be4hqAx+pI+EOteiHpQJ9q3mgXyKTw8r?=
 =?us-ascii?Q?cLWR+0Uq1NYKdaK9Y+CG6oVbfUJHN72PpW1kjt9O6svHAUC/KpORnGtCFiQ/?=
 =?us-ascii?Q?H6mQU69e3Duz1hh4UVbfYJLzwkQFttAX6Qyd6onaFoPD5sqE4KQ2zZMCNUPn?=
 =?us-ascii?Q?0P6fYJtz9uTFApc8MA39jwKYHNqn7A5HH3LfcW58uE6hNR0Os8LmRUjcOy1u?=
 =?us-ascii?Q?WKwnQAv/6bIdZF1ZOAPdrz3uGG8vSL/n2dsCAN/t+s1n6tHR+5Ksp1S9K7Zz?=
 =?us-ascii?Q?4w=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 085195c2-39fc-4252-8873-08da970298ca
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2022 10:11:03.7984
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tHnuEAjGtAE1M37ACkhknV3ELnclu4sH/Q+ZiVfEtp7wZ/I2IZw3D4IMelo/+yAfVcwZPdidqX+P1RiGEz9LhJFZWNBMOMmstcoRIg9f+Vo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR02MB7370
X-Proofpoint-GUID: N0lBB1MuUvH77gtBd8ryUJViWm801gXu
X-Proofpoint-ORIG-GUID: N0lBB1MuUvH77gtBd8ryUJViWm801gXu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-15_06,2022-09-14_04,2022-06-22_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is v6 of the dirty quota series, with the following changes over v4, v5 had
some styling issues in the blurb added to the KVM documentation (unfortunately the
'checkscript' script didn't report any issue):

1. x86-specific changes separated into a new commit.
2. KVM requests used to handle dirty quota exit conditions.


v1:
https://lore.kernel.org/kvm/20211114145721.209219-1-shivam.kumar1@nutanix.com/
v2: https://lore.kernel.org/kvm/Ydx2EW6U3fpJoJF0@google.com/T/
v3: https://lore.kernel.org/kvm/YkT1kzWidaRFdQQh@google.com/T/
v4:
https://lore.kernel.org/all/20220521202937.184189-1-shivam.kumar1@nutanix.com/
v5: https://lore.kernel.org/all/202209130532.2BJwW65L-lkp@intel.com/T/

Thanks,
Shivam

Shivam Kumar (5):
  KVM: Implement dirty quota-based throttling of vcpus
  KVM: x86: Dirty quota-based throttling of vcpus
  KVM: arm64: Dirty quota-based throttling of vcpus
  KVM: s390x: Dirty quota-based throttling of vcpus
  KVM: selftests: Add selftests for dirty quota throttling

 Documentation/virt/kvm/api.rst                | 35 ++++++++++++++++++
 arch/arm64/kvm/arm.c                          |  9 +++++
 arch/s390/kvm/kvm-s390.c                      |  9 +++++
 arch/x86/kvm/mmu/spte.c                       |  4 +--
 arch/x86/kvm/vmx/vmx.c                        |  3 ++
 arch/x86/kvm/x86.c                            |  9 +++++
 include/linux/kvm_host.h                      | 20 ++++++++++-
 include/linux/kvm_types.h                     |  1 +
 include/uapi/linux/kvm.h                      | 12 +++++++
 tools/testing/selftests/kvm/dirty_log_test.c  | 33 +++++++++++++++--
 .../selftests/kvm/include/kvm_util_base.h     |  4 +++
 tools/testing/selftests/kvm/lib/kvm_util.c    | 36 +++++++++++++++++++
 virt/kvm/kvm_main.c                           | 26 ++++++++++++--
 13 files changed, 193 insertions(+), 8 deletions(-)

-- 
2.22.3

