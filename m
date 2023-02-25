Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 026716A2BB8
	for <lists+kvm@lfdr.de>; Sat, 25 Feb 2023 21:48:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbjBYUsd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 Feb 2023 15:48:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbjBYUsc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 25 Feb 2023 15:48:32 -0500
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2B0CD511
        for <kvm@vger.kernel.org>; Sat, 25 Feb 2023 12:48:31 -0800 (PST)
Received: from pps.filterd (m0127842.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31PIx8Lw032332;
        Sat, 25 Feb 2023 12:48:13 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=proofpoint20171006;
 bh=FF9vo3RcgTPdm5Fj28KqzQ2A9FgbvPr7NBCJv7QoG2U=;
 b=W1mqTplBcK4chtyvfkVV3rfP1dJONyQWy01R+5EN6EmEIwvwHsKeUEFDK6FCq91Vqq3W
 Xk44/W/BoGOOZKfRgdsBRRyE8wE9pAriAYrKB2jBzVycmjQHRGK0BGZVCpvr+5zNBkd1
 WhYq4axcE4TEwrHWc2IuDWuJz+8o0liZ77smoIemuwY9j2WvT2VeXjW6HTPpkAmpCEqP
 ZBmfSW1VSOpiaGNSTgqQgvmpNDZHoyHUTffJvfbBP7Ww4mfCgMQnMJMWb2k1PWqYjeu+
 dvisw47o44UC2LN3MqPoI8UPPSZWL2wV5Bb85WASSBr2LzX8DDtVsRzNzAb1O6HJy8aJ LA== 
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2046.outbound.protection.outlook.com [104.47.57.46])
        by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 3nyjhn0fun-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 25 Feb 2023 12:48:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Th9F/3W61siX/ilxmQAO8po9LDer7mhaax1V6/oBJCdQejtg49PgVGVfDkLvke6tqrye1NN95q/AN9eFhI8BOHdlrwNgbmftH4AZVlFt5YEEpmOR1emPBaHdAhBQgKMi493cMN7uqCu6SOzBJjXYtu3NeCV+2X/s6RNY2zRehEGQNjfSJqqGAJYneZ8TtbNwq50CAwZohKTFALD8W5NsP4MiFmHbmHfhswWENF2GehvPmPZPEQBqq2fukGJ24BESsY7Ge6m1gqAXFgyv2aCOYsFyEO0bFR1X8RK/r0AYJ0CsfA6WHLCeTN989M3j3St2Hi3m0vv6jJp9Crjus0/7nA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FF9vo3RcgTPdm5Fj28KqzQ2A9FgbvPr7NBCJv7QoG2U=;
 b=LG8P382pdnpWqHLHUXh9bLJ0IP/o4/hyd5eoceDGjhLw8nPyA3dsaWu1eQO5NYXxhV95iNDuD0iPSc8+khDxHkH9IMaJ3DZUBrKSopozhSlt/8j23yLz6jHCYfUMpl5MpkmvPc/6F/9HMfxi97GEHNTbeKh5f+lEH8FqVXn2wOvTlc2dlhhDG+5N9iU38wovFzGDv7lBw1binei4ygoff7rUzEYHaR/Q6oELzcSUlDLV3bKhNrx2LAxhR17cie+f2xMBTgXAlSk7DhtxCDmf8XtQTpmZ1ZyZvOkp6tLSZvWwdbV1EuTU2O4P27kWYXmu2uMl8kgy0izpxeRPS/0RnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FF9vo3RcgTPdm5Fj28KqzQ2A9FgbvPr7NBCJv7QoG2U=;
 b=LFgux5radsV5lbZVlKyImsNgJU8pIaBMWCwRNHrYY9RAZcFHerz5xJfWu83sTDd4BCshD1pTju0byXSoqoLusO2Q+6Y6HsYZVqQGdAEO5LXsSP65Y1zNkmDRIwhFhsXFHaGPAtEJBh6ndEM+CVdlauOC/ceqjwvIcLAPiusGBEffx3Yt4hbJFgjPsckpfz3w7u1CX39cpYhPFAgyhiZ4BoP4zMJ73RV8oiJr+fvXL0lFoLYp6IfJuB8Idxk98aiIMrzZHmGXmSNuY6cxCMIlPBbsWJhSu+hz33T95EpZ5wdlgOJ2KI6U1Q+Iwi92FcmydJVCCR9tAsbfDzP3Zd8syg==
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by BN0PR02MB8175.namprd02.prod.outlook.com (2603:10b6:408:163::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.25; Sat, 25 Feb
 2023 20:48:10 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::aeca:cda9:6785:bce0]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::aeca:cda9:6785:bce0%9]) with mapi id 15.20.6134.025; Sat, 25 Feb 2023
 20:48:10 +0000
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
To:     pbonzini@redhat.com, seanjc@google.com, maz@kernel.org,
        james.morse@arm.com, borntraeger@linux.ibm.com, david@redhat.com,
        aravind.retnakaran@nutanix.com
Cc:     kvm@vger.kernel.org, Shivam Kumar <shivam.kumar1@nutanix.com>
Subject: [PATCH v8 0/3] KVM: Dirty quota-based throttling
Date:   Sat, 25 Feb 2023 20:47:55 +0000
Message-Id: <20230225204758.17726-1-shivam.kumar1@nutanix.com>
X-Mailer: git-send-email 2.22.3
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR03CA0009.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::14) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR02MB7555:EE_|BN0PR02MB8175:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d333e77-422f-4bb7-a045-08db17719ab3
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KqE8kNrRBXqfzTjvuznhftscSWd6Pm8KSRmFqDF6dlVj10h3RqcWVxAfwqjwKiwXGRhBsOYsxcX7O4oNlLIlIu8TxxfN/9IInAflXV9t33ssqW+cspGXzBiy+XsCzHBm60e1ptL6qZhIwunXSwJ0OmxZR6aXHWW3L8xEAVqgZiTYiA0Ia+O7BC/5fmNS3gjhrbOmC7WPkYsRwzG3STBKZLhWAHrO5n0z38hb87fk4WBZXkycjXjDrS4AnRjouNWnvLgv+KdC0yH6O2ceaUE+indA/Y2KZT0mRk20p+eKRd5G+f8i0klbXHv/p3Yt/QZo+TmZ5IdumBvXONAZ74UIJ1yvDLYyaJ8j5WIajpcfryF52yQUO7jhaIlf8us1zCv2e56G66UqyvF1RNrAX8qXmeEGX2bZc9tc6K79ysVpnf2NJwWu20J4pM+jcaS53eAgIGKcqB/KttdxcZSCDtesrRr4m6ouf+q1F77geNVlRalpXqgE9hkk17ejw3hOutAA3heoyYd57C754wah10yeu+T+Yfm3pg32zsbjWq+H3Wy9nWu1eeifYcCGhDGYSFoNI1TB44RcFaf0NL4J3gC+BXq57gdlAMrffRzwbUbpYGALRoWCDGxk8lMoscwLyUAQRjURUgAwR3WOLZlt3fCYL5nO0Gg/xelMmQLUhFz0RccV7ZmLrxyP6D81VzWLxOJbE0iMWpvPNIM8fCGJI64fixkQ/LRvibzDbpKTrF2gjfTHVoqiIcHbIm8OT57jsKxu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(39860400002)(346002)(396003)(376002)(136003)(451199018)(36756003)(86362001)(41300700001)(66556008)(66476007)(8676002)(66946007)(4326008)(8936002)(478600001)(6636002)(5660300002)(316002)(15650500001)(2906002)(52116002)(83380400001)(38100700002)(38350700002)(6506007)(107886003)(6666004)(6512007)(186003)(26005)(1076003)(6486002)(966005)(2616005)(14143004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/32asbkgTw+AX/wsyolrZLQbQbZFMXKJ5sjEO17yodre8/tRAKF7V43pF9EY?=
 =?us-ascii?Q?SQEUZpuTMbyq1tA0NAMWjuUvhU8mKmP8rku9CcEnWOWcBQH7LndC+0NlT/yz?=
 =?us-ascii?Q?OK6rCQme5A3j4XQxej+DoF++ynM8RzNH0wCIZOg2LsuO8m7MNAZgdXSCjtCK?=
 =?us-ascii?Q?pMVoNBTWHL0wydrb03wL/ZuAYq/BnH2AKul+Ng+U71/DMCz7a6+xNRS+O8F/?=
 =?us-ascii?Q?B0XzfFEEryaMxzykaRlmctX2VzdWhWTnFrez/4G+YW+GPmlilX9bKHPig0rY?=
 =?us-ascii?Q?bppNfOFcsh2yVMWdPWAs7t5YfA3+DsHdxzs//e6M8Jmz8ANw8lXWBpYEDLcm?=
 =?us-ascii?Q?DqDHn2e3MRSPMPM/1gJnQ4Pva9lmi78k2StBTqMbYerO0+dO+UQ73C539CNh?=
 =?us-ascii?Q?ELrwad0gRhj9tJu6COSqg6Vu+AVZ4BQQmw+74vlbzcawmzz/Rf4XPOdWlr3d?=
 =?us-ascii?Q?gWXmSQcEPbxojryWjOZyu6GDK6OFuSBGlhuURR0CbCJvTAnLYfXQdGEl465P?=
 =?us-ascii?Q?bhPwbQ5UAso/09GLPW0DXG7AeInYG7u78sBg8VOkMqd34+oEppaogNWgFwXo?=
 =?us-ascii?Q?xtK4JSYZClFKDfbBbHdxskexmTnEJ+cbg8uMH5Im6InIdOaJvlrkfhBaH0oh?=
 =?us-ascii?Q?iZ6qBasGJy7ukyJS6Q/NMzSKMWQ8wsTY+Bh3kwJ8XUSHYxJ8KjP/0Bzsc0mk?=
 =?us-ascii?Q?IJCTjakiTTBobaB9bgJxMdGzPl/R9UuOsEcZK3A8K/XZSSfhB9F5MAu9HMJQ?=
 =?us-ascii?Q?zMaoMURRzeiYzVEBO9S7xUtMny84S7wW+hSvaD5Vf7sOvT4CKc40/492z81E?=
 =?us-ascii?Q?dLUxIT67qxCTHdvNvzXPKKihSSLJSt3rEUT0wrPuK4ka+NT8dxx5hrUuTyIn?=
 =?us-ascii?Q?TjvPSXTc4o/1oo8kXLmxpst75L/Y/8CSG1tYlRM4LXVTM2+booFv/CGAv8Ls?=
 =?us-ascii?Q?bElmpXe6LVdGOpFxobRZHzoi6LqHX9Fty678rP9zsjV6rQhUS5335NtEebHb?=
 =?us-ascii?Q?JCS1re9sANLsSafs3QoYzk9jQjWIPw40CmzvDhU5i7CU8XZSCtSIO0b9gS+l?=
 =?us-ascii?Q?l1UehPwc1CTyXEdyAUqLuTR7AjIqAxnQbY3rDqHAc2w9B9CmfIpE0V8FTHLx?=
 =?us-ascii?Q?qfa/DKF3AKw59/9/+eyrrEQyRZoF0CeWOlq2emt371l2hgCrsEQ6tt7sbJyp?=
 =?us-ascii?Q?d0RJG5tQ73prKI53CJpx86DjRIRJWkCFteBs9uiYzWV+LEBRlTXHiUycegpq?=
 =?us-ascii?Q?8zoNL4Kro1ACDBCqAIyebNUAE8KNpYbn0ZaAyTiFIcs258qSwlsjAe4JjsU+?=
 =?us-ascii?Q?rqlfvJVSpEguL1wAk7Hgpmtu+lThUm8vDL0noXglXSW2hRP/56H5MI3k6IbA?=
 =?us-ascii?Q?hL8TuBWcM8ZXRAXO2i+EZb2S+8Qd9sZVT14aR3bzATzAnodegM4adKNDOwbG?=
 =?us-ascii?Q?57bUhy3VIuOCagY1h8hF1oQTv+71nlWapmdOCMzEPqYgdu3WSQ14S64QwbAW?=
 =?us-ascii?Q?CMO32rBfYZgSKDcRXcLU4PIKilk5ca1NS8oWfnDySE1pw8B+ABHEAOmBfpz/?=
 =?us-ascii?Q?7vUfEVwJ4M1dG/rAZpeSF62NOVDpA7U2uZr5ZSr9F0hzewX8E2mN3zud+UkL?=
 =?us-ascii?Q?BA=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d333e77-422f-4bb7-a045-08db17719ab3
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2023 20:48:09.9919
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WaNpvp8RKHt7uMaXu/oKvrM/5cLfy4VKiNnWCbnU5idITkb5zQ4QhlnQD+2o45Wl92Z/AA9xofI0tNsT4eOMJzzpe4jpd11CyNILVAlT6SU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR02MB8175
X-Proofpoint-GUID: Sh4Mb7yWJBGwKXNnnldSwyCdhDYxzmTy
X-Proofpoint-ORIG-GUID: Sh4Mb7yWJBGwKXNnnldSwyCdhDYxzmTy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-25_12,2023-02-24_01,2023-02-09_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is v8 of the dirty quota series, with the following changes over
v7:

1. Removed pages_dirtied stat. Now, a single variable
dirty_quota_bytes is being used for throttling.
2. IOCTL to enable/disable dirty quota throttling. Enabling/disabling
can be done dynamically, e.g. we can enable dirty quota just before a
live migration and disable it just after the live migration.
3. Decoupled dirty quota from dirty logging. Introduced a new function
update_dirty_quota that decreases dirty_quota_bytes by by the
appropriate architecture-specific granule or page size. It also raises
a KVM request if dirty quota is exhausted.
4. Each arch that wants to use dirty quota throttling feature needs
to call update_dirty_quota at each time a page is dirtied. Also, it
needs to process the KVM request raised by update_dirty_quota and
facilitate exit to userspace. Added support for x86 and arm64.
5. Code refactoring and minor nits.

v1:
https://lore.kernel.org/kvm/20211114145721.209219-1-shivam.kumar1@nutanix.com/
v2: https://lore.kernel.org/kvm/Ydx2EW6U3fpJoJF0@google.com/T/
v3: https://lore.kernel.org/kvm/YkT1kzWidaRFdQQh@google.com/T/
v4:
https://lore.kernel.org/all/20220521202937.184189-1-shivam.kumar1@nutanix.com/
v5: https://lore.kernel.org/all/202209130532.2BJwW65L-lkp@intel.com/T/
v6:
https://lore.kernel.org/all/20220915101049.187325-1-shivam.kumar1@nutanix.com/
v7:
https://lore.kernel.org/all/a64d9818-c68d-1e33-5783-414e9a9bdbd1@nutanix.com/t/

Thanks,
Shivam

Shivam Kumar (3):
  KVM: Implement dirty quota-based throttling of vcpus
  KVM: x86: Dirty quota-based throttling of vcpus
  KVM: arm64: Dirty quota-based throttling of vcpus

 Documentation/virt/kvm/api.rst | 17 +++++++++++++++++
 arch/arm64/kvm/Kconfig         |  1 +
 arch/arm64/kvm/arm.c           |  7 +++++++
 arch/arm64/kvm/mmu.c           |  3 +++
 arch/x86/kvm/Kconfig           |  1 +
 arch/x86/kvm/mmu/mmu.c         |  8 +++++++-
 arch/x86/kvm/mmu/spte.c        |  3 +++
 arch/x86/kvm/mmu/tdp_mmu.c     |  3 +++
 arch/x86/kvm/vmx/vmx.c         |  5 +++++
 arch/x86/kvm/x86.c             | 16 ++++++++++++++++
 arch/x86/kvm/xen.c             | 12 +++++++++++-
 include/linux/kvm_host.h       |  5 +++++
 include/uapi/linux/kvm.h       |  8 ++++++++
 tools/include/uapi/linux/kvm.h |  1 +
 virt/kvm/Kconfig               |  3 +++
 virt/kvm/kvm_main.c            | 31 +++++++++++++++++++++++++++++++
 16 files changed, 122 insertions(+), 2 deletions(-)

-- 
2.22.3

