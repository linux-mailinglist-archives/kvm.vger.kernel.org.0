Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 466EA5B9893
	for <lists+kvm@lfdr.de>; Thu, 15 Sep 2022 12:12:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbiIOKMl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Sep 2022 06:12:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229693AbiIOKMj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Sep 2022 06:12:39 -0400
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5F2B7B7BB
        for <kvm@vger.kernel.org>; Thu, 15 Sep 2022 03:12:38 -0700 (PDT)
Received: from pps.filterd (m0127844.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28F3Ld3d022908;
        Thu, 15 Sep 2022 03:12:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=proofpoint20171006; bh=YyfVSbyTRijCayA0e318Az45XK6QFnxj79/isEOk73k=;
 b=JNQnGzTiu5w31auSp5XsXnXQhb9Q5KFM9GcFuFkfbHnceiJ41tyqsm1X7V9SrKDO1lsP
 2Zzyx3QdWmlc5sXHAWwSp7Mo7TAQ70C+8xvpq8wkMYRvXA1adxF49vE3DDpRp0yrT0JZ
 AtOfAuTINw9r1lL7AR0szIjGrA0CxCEVkEd3J6LERVDLqX8J2MdyPyMBkEEZlaQLk62V
 BMvIsxE80WW942LwRpXSGzKlzzMAztllbHKaqmHm2232YJI2l9JtyqNc3lfvibB52pRT
 RMqCKDSIxWry/DMFqo5p9BF8WNmq32NeICsWugp6u5tm4ltNzaw+zUKaR6fi7HAm1NrQ Sw== 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2107.outbound.protection.outlook.com [104.47.55.107])
        by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 3jjy074aks-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Sep 2022 03:12:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PSVww/Q0wHlHlJxBzPCTfvrGtqmh270OVybhBsjzHmyQLdZgfREHnULgNP0koNUgyUe0R2YnaFK0gDb+3gBY3qyNXARMqjrKJPOtC4HInXCX+HibwQMQw7GkwFUh2lRxw6xLdstOXAbToGe8V/kiKJQGwfG5TdXVKC6nh2PudvQqolj0pYxKC5OUVDTos40pbRiFezKkYwOthbIofnChPi/gzaObqPrfbSoPKyPYFwPrm7JJ97Dc9ZFiyxefsRsAnx5iApdGMJonoEWBy05AeqzG/Yiq8XF/P2Cz4h4BZVGlF749T6iKK2RLk6Axfbuq+CZC7+WWI2EkjGaECjI6nQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YyfVSbyTRijCayA0e318Az45XK6QFnxj79/isEOk73k=;
 b=XfrtGFTytVaTBTBGJzWK2FFRbAB5R3qZD7bHnBasUfpwDD34+FJ9xmI67k4LarNCWpi1hPDVewVq+qObFIWBVbUallD7Fo7ErosiD6nxEUHcLSm4/3O/HC2+IFJ/YlFcEDGcEc3EcvvdqWWOLHPphl0nL3IgaRVyOrhsGXQ2GE8EPVRAmoVb05M++kLvkr90H6KTL2kMr6pHEAzHYFaMRGACgT3/rsbuXA6fYz0D9y+lhgKs/LmwvLHe84KnVHWaiiBatkfxbY4reSyFAJTifQjoOlQc3I1DHD57ahw3igMS2J8aGcXjma/UUYoLkEUW14VgKluJkB9+wChouKjizw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by SA0PR02MB7370.namprd02.prod.outlook.com (2603:10b6:806:e0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.19; Thu, 15 Sep
 2022 10:12:26 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::bcdf:6d6f:e6e:b9cf]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::bcdf:6d6f:e6e:b9cf%8]) with mapi id 15.20.5632.015; Thu, 15 Sep 2022
 10:12:26 +0000
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
To:     pbonzini@redhat.com, seanjc@google.com, maz@kernel.org,
        james.morse@arm.com, borntraeger@linux.ibm.com, david@redhat.com
Cc:     kvm@vger.kernel.org, Shivam Kumar <shivam.kumar1@nutanix.com>,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
Subject: [PATCH v6 4/5] KVM: s390x: Dirty quota-based throttling of vcpus
Date:   Thu, 15 Sep 2022 10:10:52 +0000
Message-Id: <20220915101049.187325-5-shivam.kumar1@nutanix.com>
X-Mailer: git-send-email 2.22.3
In-Reply-To: <20220915101049.187325-1-shivam.kumar1@nutanix.com>
References: <20220915101049.187325-1-shivam.kumar1@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0235.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::30) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR02MB7555:EE_|SA0PR02MB7370:EE_
X-MS-Office365-Filtering-Correlation-Id: d9a95b7c-3c5c-4432-4510-08da9702c9c8
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sof20DH9WIgNR7HNfydNEZ80XzCaE0gkIJgiVeDCtZWnpJjLJRFPDZUGV7zl9KwmGUVrWdC6IY/NanjL+C7FhqcYZ4IdrIfKb2zLL/J5FHp17xOZ3EofZzq2rXw9la+38AAem3n1DMJMXQhDVA3sUUjPnWEtZBgzdS+QPKQ79i5Vuw1FKUYsJl7mz0EvCgzMkG6795lbrrsfnNL+DZImDMsEEQyHp2KRGTjY5EbkAFV628isrr7fERLTB52oI5LpwRLZmYUUDwPJXfPEdFMieQen1DrutV9ClDfPJIvHsBEDvCBs4vFs/bzkopaCpPaZ9gX4r3rIPcue+sWw+E4aGFzENBrb4hSRvUtVFtMx0WrSzbf+xukYIY8nqc/HXWz5iAgtWgL+ocwaZpBrfUxKVRaUKmFOIEiFw42dIPaQmKZ3z+lgmcW9BCx47LfbTGDo+gUI68IusDLUbksml1P2xKB3cvoaCxWhj9W/TmrBH+UaoY40+ZTLLVzVZhq0TbVixXPdLb+uXiPJVf56paAXbE3esnNweQCE80SuOkuTBT6V491ZNYtikdstekbxVHFQQHwu5GwhrHQX02UNM1lql1TbrSDwLwNa1uEeDLP0tYsRQncWnXJN/09gy80iqAVhNod/x9h58NSmLaiqTuZCCRFl31jZuhzmzyY67UoQH4sY44ksT/aup1VAlu4sVeCna4yykjD4u70BxgSkFhDV7HI06zMXcDqp9eGTBENPOrtmddVT2JB9iq3H1f/AKa18akVC8L2xdE4E8VdKBz0zstQLBEsHgrhFXE6p2+h6nq0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(366004)(346002)(396003)(136003)(376002)(451199015)(6666004)(52116002)(107886003)(2906002)(38100700002)(41300700001)(66946007)(83380400001)(2616005)(186003)(6486002)(8936002)(6512007)(316002)(66556008)(478600001)(54906003)(6506007)(4326008)(5660300002)(86362001)(66476007)(8676002)(38350700002)(26005)(15650500001)(36756003)(1076003)(14143004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ghki8xvAUGycNTR9P1Ch2fxi7Lz9BEb7/R6Va8VAqPIc9/Z2ZXC+P59zBqxF?=
 =?us-ascii?Q?xeCDPd6UEhfG+p2YmXQAWrdZv7hz+YnvsQwv+F+NqQYng6xSBhIvQqyCmLh5?=
 =?us-ascii?Q?miMVU7ySDhbrLxTfe+7WucBqQGondKK3TfAlNWZ5inW6vn2OZmGWCmMQc16j?=
 =?us-ascii?Q?7L9TvBgm2dhtzOd6mp3Z+j3LL5GuEGtuaJdSkmCEbxSahj1TqAfU6evIX3BQ?=
 =?us-ascii?Q?+4wLyKwYqO29iddoLPIeQbGnHhRE9E+sOcqpVOJeH2spskHLBp8zqGIwIAMc?=
 =?us-ascii?Q?I8I6Lc1YMx84IR/8huDfceTYjgZyw3snGCj1INg0Cxf1Zre9/qgBX8NGOuJC?=
 =?us-ascii?Q?aEHcKBWjIIX28ufG7zlxZv/EZeQeXjFnetNGhMVSEuqveWYp6Zx5+s47P8nR?=
 =?us-ascii?Q?rkHfScJaPm1RiSegr6djYinqOHYDeTAIDOdYdVqVNRFz3/BH7MqcyR0WiXFn?=
 =?us-ascii?Q?QFCQ7pBeCH0soR+qFplWgM7DoNjoEabmcaJl7lhwwwLLrZc5S/Fl8J7d6zjY?=
 =?us-ascii?Q?4LwkGNRgT+lfRpEbIypHF/1ZkBpS5325PXizdwUQwAK5CI3wGaGcBLXQXr2l?=
 =?us-ascii?Q?xJY3KMuQRYcW4Ij+bG12DK18ZRNOQFeBuPirXS3d6jHAY0W7ZKfd4xJXvhdc?=
 =?us-ascii?Q?/Ol3IFF/H7ZnEHVyGZwWLoNrgzegTKO3fhRhCYzsON076vUdgnE4AtlcQXEk?=
 =?us-ascii?Q?gB/YHhC568ZRBTkardcThcEmqnlV3LS1MAy2o9AnhhI+afn8uBgXot9adPGd?=
 =?us-ascii?Q?nq+J7XjWpP7r30s/ivrRKmZoNObiXQWYHAx7fdYbh/7tX6XbkzhRu7l/S3X9?=
 =?us-ascii?Q?/VxwhcVe2HjNF0ceU73fZj6WGil+/ZYwR6p/NbIGREIpx4ZvnRu44X7Q6O3Z?=
 =?us-ascii?Q?a+Cic8t6tzC2V3zaZkQKH+nvLdXXHPDgam6idkMFALxsw1iCn+SibeLRxuro?=
 =?us-ascii?Q?Z59ZebU2B+8S+85EIF6cLrfsCBd9vxCXjlK8K53HTq+LRpJxYQ51Np9wtJvA?=
 =?us-ascii?Q?QbInd5PHmmbmeLE3yyKeWhOr+Sl7enuijN5mf7e4fjY17PAs7QCo6Se8R+w3?=
 =?us-ascii?Q?OzoeuUq/qOTaheEvOZ3SndehgrIzKDXnXPJpG3dVWHxuXT35R/nFLwZ9AOEE?=
 =?us-ascii?Q?xh66iIssbDCCvGdljHf/iGjZL3Tj0QE3bxqEfnj8Ohu0rA0NXbxsfj+SNFsq?=
 =?us-ascii?Q?R8ybAlNFif/DoBTjGQ+pu+PTaXtBGfvs87F5wxIkWkmI8w8N99HopY1JhlFL?=
 =?us-ascii?Q?6TPK1O2vR+8I+zE4JJ6QWurIvpNiPtHV2S540bhnuVgou5rJWx+mzTYPu6y5?=
 =?us-ascii?Q?UysgRFiS78up6Po3pmnZCVX7mgoBA2eznGY4Y0EpexXpHRGtP6cst8IFRl15?=
 =?us-ascii?Q?FJ0JerJb15Wn4Ono79Enc37pGm4K10i6eAUtQLhAP6Sg8ff4tgemW7gAnngb?=
 =?us-ascii?Q?QLZ3vEsLUClIASSXRNROLaza+oU0Ts3KJ+x9UdlklpSi0B8oY8zZtspvZfJQ?=
 =?us-ascii?Q?w5AOxadzh2S2/Bmk2n/Y427fnJ86pHibqtF8WPSmrMhObVRnZRjHYc0nPByL?=
 =?us-ascii?Q?TWKTBwfLpT70bBBCLVz8vQ3aA+jdhxtqSUIRLY5hYjMM2L62rXQ513n3UijT?=
 =?us-ascii?Q?Dw=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9a95b7c-3c5c-4432-4510-08da9702c9c8
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2022 10:12:26.0076
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kEwzN03BQHprzab+9HFK2fqTJPttyA3/air+3tAQJ8/swbWLl5HdIJRZf3y0ut/Gw8mW/OJ23mY3JcifNG/zeVRSKicLe5svtLUjJaV6OEM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR02MB7370
X-Proofpoint-GUID: u7OYYwh613PQFqLZd6ZacILB7bKqZTHa
X-Proofpoint-ORIG-GUID: u7OYYwh613PQFqLZd6ZacILB7bKqZTHa
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

Exit to userspace whenever the dirty quota is exhausted (i.e. dirty count
equals/exceeds dirty quota) to request more dirty quota.

Suggested-by: Shaju Abraham <shaju.abraham@nutanix.com>
Suggested-by: Manish Mishra <manish.mishra@nutanix.com>
Co-developed-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
Signed-off-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
Signed-off-by: Shivam Kumar <shivam.kumar1@nutanix.com>
---
 arch/s390/kvm/kvm-s390.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index edfd4bbd0cba..2fe2933a7064 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4343,6 +4343,15 @@ static int kvm_s390_handle_requests(struct kvm_vcpu *vcpu)
 		goto retry;
 	}
 
+	if (kvm_check_request(KVM_REQ_DIRTY_QUOTA_EXIT, vcpu)) {
+		struct kvm_run *run = vcpu->run;
+
+		run->exit_reason = KVM_EXIT_DIRTY_QUOTA_EXHAUSTED;
+		run->dirty_quota_exit.count = vcpu->stat.generic.pages_dirtied;
+		run->dirty_quota_exit.quota = vcpu->dirty_quota;
+		return 1;
+	}
+
 	/* nothing to do, just clear the request */
 	kvm_clear_request(KVM_REQ_UNHALT, vcpu);
 	/* we left the vsie handler, nothing to do, just clear the request */
-- 
2.22.3

