Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59EE25B5343
	for <lists+kvm@lfdr.de>; Mon, 12 Sep 2022 06:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229584AbiILEdA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Sep 2022 00:33:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiILEc6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Sep 2022 00:32:58 -0400
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A292A186E3
        for <kvm@vger.kernel.org>; Sun, 11 Sep 2022 21:32:57 -0700 (PDT)
Received: from pps.filterd (m0127838.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28BBpBjV032655;
        Sun, 11 Sep 2022 21:10:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=proofpoint20171006;
 bh=XKWh7S0RwwqsUh9Cj/9m4Ed7oe1tS7vVsa7SHfwzMd4=;
 b=j+sCXxgpLxi+QNHH0iaXg4Ss3anzsF3cvbnCL63sSfIpxGhhQvVYnOhw/b3QyhWrDFC6
 lj3Tf78etlS7cD9ysQPojuWqGTdSmM5iYJKCk+nVxhANEiV8XK1L4UQrvRJcRZ6kbuUg
 UDtbMJe+d68f2CpKKg7979swvivHxYmEILxpUDiPMKmviqlK0CJsnvI/xjGolpvmfcaV
 BXcBH3zjZ0kGn+ETS2ti2VCXJGmDcTAyOaKAvT+b1aHijXqtm06aIGvaZQyjzg42/rAX
 nDdTupBsA3AWpi0wQa0AF5tpsmubk1aMI8Nekbfqge5EIJIIe5YUAJ+h9yrAjXfAlKhJ YQ== 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2175.outbound.protection.outlook.com [104.47.56.175])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3jgt4y2ncd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 11 Sep 2022 21:10:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bs4gvruyaUBRI+IZJ4O6NDaoJTn/dL9mftAZTVgpb7FY2qvNXxI8Pk/57TnY5xFLsDUYvbUsV4Gtu3VjIpWx63QQDKvr935plUF2yKqfn+5LfBlTdTURdT6GjWj1WZdCZmN0OcsrGyQzcZ5KftDzKKnwAVHrbVm9NHqLeGE3hvB4FLoPFd5u61iiPy5zRtsserWst7gv4LhqPenJznaF/wPl4TBbG/HKsy6o89cwfUleSKD/X/TlVeRhFJTese8r+n/sAaD2gSxmRkzw7yAnRp68ZFBw369ulVKADirNBOL2MmJhG2tWN+OkBtuD6GKhshZunu2nHal+gzPn45lwMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XKWh7S0RwwqsUh9Cj/9m4Ed7oe1tS7vVsa7SHfwzMd4=;
 b=edx3lgzdRogHV1CP6U6ARfTVsUfrnrop6HRzJ+e3c+bYlNEFU07YP8jahw2p6NLduteqixCnk4BVZWwFPeKfKIXHnDvPM1gJ6hC/Pul2vnUBORM1yi0bH12/SDqn8x6qQH2xrkrHO/otOY3yV757+Z0lS9mpcPiqXzBaYvWJCLKDU3oWdvu9M4XLt46oOK8QK4r5QB8psqa18VJM02puJmI3F/+SupouAvdZ/dxEdsVAvPtvY63skCbku2NfTbZlDt9JtZiGH2twT57QGpN/iVynr7vEWsXcq9+Z7aRtJyoTVkVGYtq/z8lywn8DSeS2Wfad7DGA6Ao6iaQUeOz3xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by CH3PR02MB9116.namprd02.prod.outlook.com (2603:10b6:610:144::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.12; Mon, 12 Sep
 2022 04:10:23 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::bcdf:6d6f:e6e:b9cf]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::bcdf:6d6f:e6e:b9cf%7]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 04:10:23 +0000
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
To:     pbonzini@redhat.com, seanjc@google.com, maz@kernel.org,
        james.morse@arm.com, borntraeger@linux.ibm.com, david@redhat.com
Cc:     kvm@vger.kernel.org, Shivam Kumar <shivam.kumar1@nutanix.com>
Subject: [PATCH v5 0/5] KVM: Dirty quota-based throttling
Date:   Mon, 12 Sep 2022 04:09:22 +0000
Message-Id: <20220912040926.185481-1-shivam.kumar1@nutanix.com>
X-Mailer: git-send-email 2.22.3
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR03CA0025.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::35) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR02MB7555:EE_|CH3PR02MB9116:EE_
X-MS-Office365-Filtering-Correlation-Id: fdd03c57-1b58-408a-689e-08da9474b6bc
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AWePJaXaU3JYvYvG5XhopAyb32ijbRDh1nSDB/mfqrlLvB25sGuNIe5g2ekSKJD7iYHbbX5aUXr1rh49vuLrU/eN0ZjOmYv3RbUvKaoUZMu30yZAn+O62jFFmEprZMYpYL1mypi5WV/8pr+SY/btm1hZ9IMMHmfzJ/UDtSGNateOM0Zvu/P8O+f84juK8YVUsvrVMmz8gXF1cp+Y2R9RK7yvQNqNK5O+vSmSl83v8PSdXb1C5qQBTB4WKEMrr/BfXk4MVN5rhJ9ukgXblMwVotlO8M5UhS8Tp444opCwB1Q7MvG0AVtZazTH2hkJM5t0w77j8DF8JTsc7an7tWaabO8/nkO7Ziv3FdAanGsy6hdS993uZSLqEDt5bEzr0HW7+jKa6fIBnj29Wsb+fN8UpKEpx84/EXS43k6HLzcFcnnaa0LOIrfy6oXUtx1/GRcDO8sOy5LKf2wHVg7VKvxuH1r8NbDMB74pS2wNwtyR92eb5j+dgIJyAwx1CSYzNLxoFnNc+fOeR/an4hnlxbsROZYRC6fD/bQLUvWjjkj1xgjiLI0Dl2h3xHs2kOsxJZjTl3hsq2ejSY0+/D2nE1KQQ4k/GjhZZ5SMhuJGSpzf5dVdy7n4SG6P4QERE8Dng6hHhvG6n3eZqzv9Ov4AdxuiUsz6kgYUttUe/BqCcy2HdGSRs9AotDq7tE6d6ODjVYfm+ItlcSswt/7vyc74kMSVfgaf8peSnoV4+UsdvhbFsUlwskkKymjPW1mvNSi6vygSrluKiwTmTXOlIPyN8uUV0e1ZVN9tqDTi75cKSyoPgB7YfihvtTfsANu6pOxw0h22f27W0WscdsTiL2NFTao2grKvifTwVDhy2ZsoYk6WgmA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(366004)(376002)(136003)(346002)(39850400004)(26005)(107886003)(6512007)(52116002)(41300700001)(86362001)(6506007)(478600001)(966005)(6486002)(2616005)(1076003)(186003)(38100700002)(83380400001)(2906002)(15650500001)(38350700002)(36756003)(5660300002)(8676002)(66946007)(4326008)(8936002)(66476007)(66556008)(316002)(14143004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bwt2KPuU30hb+ap0L1jP6yaiGRW6Qc41EjKEvDjXnqia3dukJWBub+kONZBK?=
 =?us-ascii?Q?lRGUYp5vszdbc+2RAUzgt+6/RVZK/gyJkN1+ETNhoBlOzHH0Rxm8oj81nj1O?=
 =?us-ascii?Q?ZJjWWXYa1ENmLxWr/Kqzj+SpxZg6eu/c89V5x3tGbv0ZKQrXUQ9/PW8sSibw?=
 =?us-ascii?Q?pdZpYuyXaRutR6JhkrlwFjYnun2/75y8hBxy11ge4zGVbKgHKrQCD7pzYULv?=
 =?us-ascii?Q?joB3VrVushOqIDyU37KPlFNRMF1wG/cLE8/OAelZ8odELW6A3BHww+Aik6CR?=
 =?us-ascii?Q?4/U+xgeEIN1ktN6h42gzhlM9LWdSWiXZ4DIkjgzAhQEqfO6qaV+u7w6iuVDe?=
 =?us-ascii?Q?vP+aTFTJm6jZStlwolSCUC5umhaF0I9PGDCPK2rDvyMIZhAFCB5NYwQAKctL?=
 =?us-ascii?Q?YWfs8KZZ/YTVE52bdAxIa//1kN1H56TdLcRVW77bPC1sdq3899r+ZY3rsb2M?=
 =?us-ascii?Q?G3OthCDz+K9E2J49ErglJzeLkrS5mF6aOIuzbPOloG1tIQW6RblQAkUOyFTP?=
 =?us-ascii?Q?pf6fwY+0SZ2yDu8sLFTOTPq3b4w2Be9xVd9NG5FplWDSALr2znJgLZlkD5Mu?=
 =?us-ascii?Q?XdwdyKcDymmaHQy4gcwMsd7/UvP8XjpvB0uuwbZ28SOUJcKzKKioP457BRMU?=
 =?us-ascii?Q?I04xSerB6OUkyLhk9TvotygMHSIu1pn2HqkBCbKvQTWBZhZYv5fIP8T+tYKz?=
 =?us-ascii?Q?Vw72NeVCS+8srSqLw2Q8vYGC/C0hnO2xVmz6YFRe0sNdfEI1Vr2EUyipPBda?=
 =?us-ascii?Q?MIjwFDmJINc5fB1njti9ONEFXrkLZeaQiU28Wa+o5RYlmy02m+gfioxGn/Z1?=
 =?us-ascii?Q?If03QKO9iZSZ46O77239PDleuNJSxl2VyfSUc5CoqNkykNKczSptvF5TjIf8?=
 =?us-ascii?Q?T2SzPVm1vffAjrYGiSow4zLEDdvYcEf7pCuy5PgBhZeZ4ekJV/y3QCi2BGqp?=
 =?us-ascii?Q?mqhlUI4h0qMf6iFxpiQ07JR2AOsuZonitMe7NYPWXsbeglaHA2MWKwU2zr1J?=
 =?us-ascii?Q?BBetcq+ojQIaxB0M5dFMttA48RPZaUkvHDCXPa8d8eoHnsRObn5fVlLQuGt5?=
 =?us-ascii?Q?a2eUHW8MNxM1WGOsaP3j0zBLk/WjaJgmNDPsm7hTTbWaORUj2zc6BSdG1Fjn?=
 =?us-ascii?Q?nVIxI4p/4A/kyKo+xwZlfomjdgZSG0zkVYihw5lac2zO1Enj9wgtYv1gnftC?=
 =?us-ascii?Q?THfhaYxt7Xdw+rjY1EXTaWM+tl0jyGUS1Fw7euz5eub/iQHpEQZXVwjvaze7?=
 =?us-ascii?Q?21HDgtNGMatybK6HhTuyjhzfQH+fcgvOYO9La3zmdUFvQL3CMZIJsGYUQ47L?=
 =?us-ascii?Q?85rQwjzxPbTV1rpq6mJIoVLoKQOmZFYFB3V26lo3N2I1Jp/UAm7WPojRAIFB?=
 =?us-ascii?Q?4LBUlJ74+5kK9iOM8+62ftkd4Zv9ltbGms071moG/mC1TcFVWeLWxt99K317?=
 =?us-ascii?Q?bbqaiREHc720wShyIIikpKBLsDVksaY/+ZVzDWizU3WjTKI/BQREvEI6yI2P?=
 =?us-ascii?Q?cdbqBc0IVnfM8Q9NndovjUg+Q+t52ajLmX0sxfDmledNoMXCQNwNMC5v2hpx?=
 =?us-ascii?Q?ehiO36PAdo+CM4Sw3fiO2Ph9CvYofSgx1PgaMT0bOfyGIYOkJyAXuNm9aw+h?=
 =?us-ascii?Q?wg=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fdd03c57-1b58-408a-689e-08da9474b6bc
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2022 04:10:23.0670
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: REHPqRTDvWQljHTx7FUuULvQK4V6YLTrhN5F+2TlmRDgp41ziFVw8pNlUi/7OBmgO4Ryne6tpeov0voRnd4O862WSj4hr7e9B+yFoQ97O+U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR02MB9116
X-Proofpoint-GUID: eRD1wrSug4asnFCTMQgGPw4zWgWYfMnM
X-Proofpoint-ORIG-GUID: eRD1wrSug4asnFCTMQgGPw4zWgWYfMnM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-12_02,2022-09-09_01,2022-06-22_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is v5 of the dirty quota series, with the following changes over v4:

1. x86-specific changes separated into a new commit. 
2. KVM requests used to handle dirty quota exit conditions.

v1:
https://lore.kernel.org/kvm/20211114145721.209219-1-shivam.kumar1@nutanix.com/
v2: https://lore.kernel.org/kvm/Ydx2EW6U3fpJoJF0@google.com/T/
v3: https://lore.kernel.org/kvm/YkT1kzWidaRFdQQh@google.com/T/
v4:
https://lore.kernel.org/all/20220521202937.184189-1-shivam.kumar1@nutanix.com/

Thanks,
Shivam

Shivam Kumar (5):
  KVM: Implement dirty quota-based throttling of vcpus
  KVM: x86: Dirty quota-based throttling of vcpus
  KVM: arm64: Dirty quota-based throttling of vcpus
  KVM: s390x: Dirty quota-based throttling of vcpus
  KVM: selftests: Add selftests for dirty quota throttling

 Documentation/virt/kvm/api.rst                | 32 +++++++++++++++++
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
 13 files changed, 190 insertions(+), 8 deletions(-)

-- 
2.22.3

