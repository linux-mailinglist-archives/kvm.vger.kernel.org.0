Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D50E56F6DE7
	for <lists+kvm@lfdr.de>; Thu,  4 May 2023 16:44:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230179AbjEDOoP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 May 2023 10:44:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbjEDOoN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 May 2023 10:44:13 -0400
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF7FFCD
        for <kvm@vger.kernel.org>; Thu,  4 May 2023 07:44:11 -0700 (PDT)
Received: from pps.filterd (m0127842.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3449K6o9002539;
        Thu, 4 May 2023 07:43:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=proofpoint20171006;
 bh=g9+ghSlC7Hd/DQE7kQZuf+mHwitQUFMzo5mP9TTpZnQ=;
 b=PuM+RZ/vy3QYQCKvMPLzA7DfqP9NpjuS+1fLNLOSsABOcgXr1ymfqaY4yXyvBpiH88o0
 GM98/Wf6bs3x7sQo6JR67qo5zcLPaoDePof23bcpi+s+dwLcWtrdgmRGiv/BjkbMKORk
 gkDK+m/YyZ3k5sDsuU6N99YW33rLAhHvBnsBrepf2xxjftPm6lEVBvIy3uk6wxOO90Iq
 /XvHUgd8MHbXMNQvhvzXy2yvxl9KkpFRKqcrSge466k7INFgh+Y6J6ibJ1a/XMxZ+C1J
 IL1jLpa8PYxpxb4+uVq+qKTWFhBDBr8wg1u82EU6NbpHdLLLQgdrrLINBWXFtT4oWeYa kg== 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2106.outbound.protection.outlook.com [104.47.70.106])
        by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 3q92jjc7hv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 May 2023 07:43:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cokOHpX5sMpZnCepAiGU8w6IMC+wYOoR4Wdgx6m7WylYIggxqI3AXRxeAqb7UeOvfZSD/aYNjhuNpYJoOEIvnB6erB3jsIbhJs8SZ9xAsKs6ORYsq5zK5YYL2dOxZvzjSmgTKGUsa7OCY0B9iomWkC9fIf0fu1DDX1m/GJrO3MShSDvkB1AegS59t0tg8eoonvZm/jhs0g9lZC1x4QS1H+eGIbLVOZQ0zod1miXUdCTVdCn7uLPDnl5tR0ntEAgSWYBSXlH1Nf7irmCbQv4+2jxNQHYODypPw3j3M7zz19qt1Jq/V36UxlzGTaxnem991WQtzfbIQWY2obX/h6IyKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g9+ghSlC7Hd/DQE7kQZuf+mHwitQUFMzo5mP9TTpZnQ=;
 b=QUg/7FScCsktHefSsaNEOY75xYl2TZPB2lmnHn344MvZHeJT8MKycJchPZwXO3YyYJ/jdmj1yGv72GZYWaCH1bX+plpBDyTezZgtAshH9TWQM8HWVTvvYpaCLRi1gwyTw8ZvnMxK0eJL72CipD2oouZ6jLlOHa0TN9EhP/IxncZLk++9+n788iehW2/6vpJzZ5neXlYvEhLWW+OFuIOen7I294Fu5Afx5tKlp4kDWAQNjKMesDJnOtZDq/rIHCrCPrdNo/VUc3BzrM4mB+CFlZE0fUAlaYDn7Asd9F+p1PyNFjqJRGJs/Moetg2nvjZEQqbVNe9zz3piW98JleSrPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g9+ghSlC7Hd/DQE7kQZuf+mHwitQUFMzo5mP9TTpZnQ=;
 b=DXCN+PwHOYCQpy7ULYs8INRWRP2LBRzCem7ylULe7G0mpUyF/rxEuC0CGhBhsqfeLB7pDm4KjNTPJD14hpbv92B9LzTf+X4RcQFa7R7wwtBA2SubyZ41AZhMkKFBiafdZoK9AVae87VT5327UtzFIbR+HVYZ1yT6iDg4HOebMOSqQ2ISXRABUvdLfVvJJHBgTcR4lO083gd7hKEVWnlc7TY0D0plQuat0OpFp6jMgISHZUuouGZJkaDoreTV1DCVck2P6uEhY1FbEWGuv1mGfD9FIClxndj10Mu4TjUaXUroomiKBKh2uuMptuqMn9dzzVKUM8249axgpJH9GOUptQ==
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by CH3PR02MB9138.namprd02.prod.outlook.com (2603:10b6:610:149::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.22; Thu, 4 May
 2023 14:43:41 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::bef3:605f:19ff:568a]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::bef3:605f:19ff:568a%2]) with mapi id 15.20.6363.026; Thu, 4 May 2023
 14:43:41 +0000
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
To:     pbonzini@redhat.com, seanjc@google.com, maz@kernel.org,
        james.morse@arm.com, borntraeger@linux.ibm.com,
        aravind.retnakaran@nutanix.com, david@redhat.com
Cc:     kvm@vger.kernel.org, Shivam Kumar <shivam.kumar1@nutanix.com>
Subject: [PATCH v9 0/3] KVM: Dirty quota-based throttling
Date:   Thu,  4 May 2023 14:43:25 +0000
Message-Id: <20230504144328.139462-1-shivam.kumar1@nutanix.com>
X-Mailer: git-send-email 2.22.3
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0274.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::9) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR02MB7555:EE_|CH3PR02MB9138:EE_
X-MS-Office365-Filtering-Correlation-Id: 40222504-9814-42c8-cf49-08db4cadf3d4
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aFWgKmvNDnOesyuz9vZQ+DN9aZ7VRHQPzXLue7BoL4TiuJlfhTiN55RqRzh7l09xgrVrvBuvBBX7OCQEVHvTWQlSdWoZrNN4Ro9szcZjVO6Bf+ELx7nMuybpR8iGKKqnap/w+80fs8/kIxPJOpamO6aNZDWH5JbB6h8fGJwnuf8ms8ZtBZNZo4hXKyrqcpYhzRekfgXscFDG7vdMBzOuUi+YgaLZ0n+j7QxbHdUidyzF3Kgi80UoNZn1O5MubdRrlERTOElEbeT9XsDO2lJ5o5owaYoxjkZoNfAIHHgaZK6kbR/SHEl4oIMEPiiK61pzQkyMZye53l2h28RE3NJL0adSY6thjORu3rTH4Cq0OmUAFVcyVeub2PDUhITvZ7rMI6Z7temUoNOB9cHeEoei++yC6YQKkXh2DbdGH1yeFZ+i6c3FSVyy9ejWanM7UQs8HPp/FluS3CKu3A3h6ypwOnpE7XW7I336dyD6VzzvXRyhFDBqLH/Rue2z2suIayYV6uauU3GUTUlTofhFkVwVMcXr/FcbWHHlTO99XWyYcsNx8uJzWd/I3bpWIo4LwF/AcDF2whFwIOFhUOLx00htidEu/xV6DTy69qym9zJy7pmxINUgsnZEGc1sD4bHwQ7FcV6pcCgqVlc5hLPNrzNaMGdhz54yWWsZYWD/LcrthDA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(396003)(346002)(136003)(376002)(366004)(451199021)(41300700001)(478600001)(66556008)(4326008)(66476007)(66946007)(316002)(15650500001)(107886003)(6666004)(6486002)(52116002)(8936002)(5660300002)(966005)(38350700002)(38100700002)(6506007)(1076003)(26005)(6512007)(86362001)(2616005)(2906002)(8676002)(83380400001)(186003)(36756003)(14143004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EiewKn/dbhkc+VhwKYZL2g6S17AyT90ZSlOTdEViOlm4nuX6EELTpaBn5vux?=
 =?us-ascii?Q?5X6A3MAnr4EOgG4u5FJ5qOIBv9ZS4qUFCBd2dl55UjMvd4MHzyQ65ZBz3I82?=
 =?us-ascii?Q?zzAIwxu9gjcuOnSQudc1GZk9Gd71wNUfEQLkUaAaB2NzSMdzfy/e+7723n1j?=
 =?us-ascii?Q?BDOw+6+RqvdGu4QmyQJqgDKIvzns9S3NEEYFAKxkQNnTjTdJHducy2rcOq6/?=
 =?us-ascii?Q?KLvo4y0Wm7jgcOSg2mp+4eblo8rYa3BAEJRvhBB9UpB5rGuFSOBStpahOERb?=
 =?us-ascii?Q?3JNtlZN8GzdEk0f7HMqRnWeD2dkK8KfH1Gv7YjnEbdXQKbZFKUDRi5p/wKjk?=
 =?us-ascii?Q?NsBnVU3O5NBaC8Tvw9dLwF9kv3UwyuJlaaoG80S8Geg0ud7jI5dHYoT7KrPT?=
 =?us-ascii?Q?sa3aJ6LH9JhKB1R2ZXpVW19SYRbAaYAbm5Q618w9piJMk1+oH8+75Q5Tq3rv?=
 =?us-ascii?Q?RA9aA781c+GZXAYFsEXR9yo0NcDlEsti+72CRMByYEPRKSSxavoaoD6EGchp?=
 =?us-ascii?Q?dtEC0wx0h2VQYzoSq/i/qGRc2q5p6EBufTMZnp8gc7dHGSMzluCFKzyL4na9?=
 =?us-ascii?Q?8RHBl8Q6Ba9xYG9TO8RgGV5A/adqdaMYPOBdThB+xGmkumsNj2hc7pRrd9q/?=
 =?us-ascii?Q?bv5ApCLVs6b90QvsO7Q9Vgl1FlOnpeURHjtfSGpA1mIwuEaPMKfTzaESWVWL?=
 =?us-ascii?Q?SGwJ9WdyOxeOX1sVKLSrzW7AJCk0DrRCX6N5QXyk6YdNenAdTNfulYYYir7T?=
 =?us-ascii?Q?5HYAajGpoC5gZ/8jCW0aJRv5AnunEL4cxDrc2N8qsUwRxEqGvEEDZafhqh0r?=
 =?us-ascii?Q?iq8lTjf7ALJ8LxlyCGKwZDHIVRntbYlAKfa8cua/wO2rX8E3Vp76H7o6vaZ4?=
 =?us-ascii?Q?3xpkd0gGXXzXILgDQ9B6GfiY5qWwUBBcBDdsY3FEOOo3PmqefjSmo6NTmOXt?=
 =?us-ascii?Q?5hASrhEe3Bdr3B5eH45RmdAHMuZPwgnr1PCIlwaGtJ+NYTbFZauOeJeYzSjV?=
 =?us-ascii?Q?liqMah2iI3Gtj7gbFIEYfz20MKGYwMHPGyVfe817dJcROofRkh42xbWff/vH?=
 =?us-ascii?Q?Sn9nGRjmW4dF6P9o/ifbKUpvcrFf1TjgSFAQ+tG2AWPccFLSG+N7fA+mS7Sm?=
 =?us-ascii?Q?BD9TTIa41/pPagdrjUkxBKc06loW/m4Q6ZVH4iWvjU9xEYKo9182SDm+h2RL?=
 =?us-ascii?Q?DvVf7LNSEmMmYr5iE3EyquaPr9ScSIGgU05kiPcA9+zTqBbzWQ9IC0RgGHeU?=
 =?us-ascii?Q?9gSl1eAKDSOiNUwkAvpC3I8SZBX35TtTgDNFYVsihzlYQTmOjrQJkivrfnzj?=
 =?us-ascii?Q?0aedpuhQ9H17ZCQuFvwdRW+1JP5SUR5lxTvArrnKmKmpAcM7+8A25Fi1v7OW?=
 =?us-ascii?Q?RKphmLA2K/Ah5LZxr8cNrF7bZZlrtmYNJUItJz3cYtKycFLM1WawtEexI5Xw?=
 =?us-ascii?Q?jMBvk/8bySvn5Gy9a9HffdJEPx+AbmJlxr6D13CuN0Q371Tx0j8VnA69wUHM?=
 =?us-ascii?Q?YPnEbSRIRDVAYW4vXTIIvu/ABEjaFJG9XhKiaXPjK5liiuA84XixCD+iWmZ6?=
 =?us-ascii?Q?BWP32GmbLmSIE75xEY+NqnXz4cXSATJfWgKOwZaDnArlZBXc4PKGTNu0P9m+?=
 =?us-ascii?Q?3A=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40222504-9814-42c8-cf49-08db4cadf3d4
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2023 14:43:40.8759
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u76K9958OkVyzxxPiJBNe4PIPMwuh7672lolR22NSL+qOqdSRkZHUzKO3FNOg6ogSwca+IKoDXzgZCV6KmusQ2kT5G2x+Pg48h968VS2geI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR02MB9138
X-Proofpoint-ORIG-GUID: BaQSxVMuzToWtNaQQuxXn4IEoH_zzEhk
X-Proofpoint-GUID: BaQSxVMuzToWtNaQQuxXn4IEoH_zzEhk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-04_10,2023-05-04_01,2023-02-09_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is v9 of the dirty quota series, with the following changes over
v8:

1. Stopped accounting guest pages' writes by hypervisor in dirty quota of
the vCPUs.
2. Removed redundant ifdefs.
3. Minor nits.

v1:
https://lore.kernel.org/kvm/20211114145721.209219-1-shivam.kumar1@xxxxxxxxxxx/
v2: https://lore.kernel.org/kvm/Ydx2EW6U3fpJoJF0@xxxxxxxxxx/T/
v3: https://lore.kernel.org/kvm/YkT1kzWidaRFdQQh@xxxxxxxxxx/T/
v4:
https://lore.kernel.org/all/20220521202937.184189-1-shivam.kumar1@xxxxxxxxxxx/
v5: https://lore.kernel.org/all/202209130532.2BJwW65L-lkp@xxxxxxxxx/T/
v6:
https://lore.kernel.org/all/20220915101049.187325-1-shivam.kumar1@xxxxxxxxxxx/
v7:
https://lore.kernel.org/all/a64d9818-c68d-1e33-5783-414e9a9bdbd1@xxxxxxxxxxx/t/
v8:
https://lore.kernel.org/all/20230225204758.17726-1-shivam.kumar1@nutanix.com/

Thanks,
Shivam

Shivam Kumar (3):
  KVM: Implement dirty quota-based throttling of vcpus
  KVM: x86: Dirty quota-based throttling of vcpus
  KVM: arm64: Dirty quota-based throttling of vcpus

 Documentation/virt/kvm/api.rst | 17 +++++++++++++++++
 arch/arm64/kvm/Kconfig         |  1 +
 arch/arm64/kvm/arm.c           |  5 +++++
 arch/arm64/kvm/mmu.c           |  1 +
 arch/x86/kvm/Kconfig           |  1 +
 arch/x86/kvm/mmu/mmu.c         |  6 +++++-
 arch/x86/kvm/mmu/spte.c        |  1 +
 arch/x86/kvm/vmx/vmx.c         |  3 +++
 arch/x86/kvm/x86.c             |  9 ++++++++-
 arch/x86/kvm/xen.c             |  6 +++++-
 include/linux/kvm_host.h       |  5 +++++
 include/uapi/linux/kvm.h       |  8 ++++++++
 tools/include/uapi/linux/kvm.h |  1 +
 virt/kvm/Kconfig               |  3 +++
 virt/kvm/kvm_main.c            | 27 +++++++++++++++++++++++++++
 15 files changed, 91 insertions(+), 3 deletions(-)

-- 
2.22.3

