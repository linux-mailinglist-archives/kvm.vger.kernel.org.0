Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 471286A2BB9
	for <lists+kvm@lfdr.de>; Sat, 25 Feb 2023 21:49:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbjBYUtB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 Feb 2023 15:49:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbjBYUs7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 25 Feb 2023 15:48:59 -0500
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82084DBC8
        for <kvm@vger.kernel.org>; Sat, 25 Feb 2023 12:48:58 -0800 (PST)
Received: from pps.filterd (m0127837.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31PJf6BR020594;
        Sat, 25 Feb 2023 12:48:38 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=proofpoint20171006; bh=9FVJ0v+ZSpT1rAFY42LiJYewV8FsI0kOzcvvAEqnSJA=;
 b=gALypOusr3vRW4PvMdNVVAdxPWgK2+7fLM87hqBrHm4Uefm/fQLf9fPWbMYv2mtCH/BG
 XhscXc3VzWjcUDqKHzLuZpFC5aEnGCZkp6qOIn8VShRJ8fYZ6pbWnvy/pz11MBP5sXIg
 qpDW6He2tYO1oc0olwjjJz7aEyljBQ+8Ksuc+6k9ONTeKj2VKFp0im3i1VioO58yd1/V
 glV0xdnp6aLilnuy/KTMlg3qV/PXHHex6/TTJgAO9UUPwZJU9JX0c/lS0xPiqfM1THvc
 rSDWPXTjrGqEHjQtCWb3Cp/xTFJA+5tnFEAWQoUxPE2y3k/M29cz18LRNOcT2iAUZvq8 WA== 
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2046.outbound.protection.outlook.com [104.47.57.46])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3nyf4egugv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 25 Feb 2023 12:48:38 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Du++PGYivKJIdMH4S7kZUIZRDBy+UNsNEBvDyvRnVz+REuIaXZS/KterPIN9mdva0BBI+BZBh813JRokfEsvFQjVPM9E4xtzysbfh2yZw9bWV4mfsxDSFlwJue45ovbYFhHZ6jrupvHCzQqB2avQHzyUgR5u6LhhfRhhtFN0XXyL2k2sQn4N5d9PkaiQHZtaLkDSZ9UblfbLNXveNcd3W8p1ROC6+U8DrptPkAAdzp928xcmrXLl5FKRpDnaF467Vg50ycJv6Xl+ltHdO85aYovQwwyio1Cv/42aP/m9R4ynSEARZyJMnBaMMyk4rlpEpD3rG2B5Di4m0zcIDYZy6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9FVJ0v+ZSpT1rAFY42LiJYewV8FsI0kOzcvvAEqnSJA=;
 b=k8Uh+f91LsYiVGvatz4qfdKYvcDjlaosyqur5nBvEmBI4NwyKAMMiC4StoljrueeFTuMqSCDyy+pmnl5TPA+IhZug9FRXOA6hEBdilLptw7AERArpNaEdbQpKOwguW1Pl1OyUbRkSAkK1BBXjQq/fMyktDHAiy5/q46jL34hC7V7cgq0Ffz7gHOxjLXussxJVIHjuKoedJJGY+m4f5DZB4gGZsA+NTJA1gh++hoH2p/Fle1bZ4r2Lac/7VhrDWKjbzesOo8bbO7mEcPEV8FVOiy7PlM2z/ZWMJbfFz3aKQH/pVGOOdYGx2tYZ4EAzXvym1b538KaersZFtIM+BIXyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9FVJ0v+ZSpT1rAFY42LiJYewV8FsI0kOzcvvAEqnSJA=;
 b=DesIG1TWr2165yd44E72ALEvYdlOFJYqdCnLpYXpv21FPHsF/nIgRfO7fccx5JjMGiE2u2P4VQrImOTJ0Ga1wA08QyBCOjPf9WJiVWG2He8RcCXK2zRKPGIQY1eWoIIza344HnRMQgK4XBiLBwobBVUXhcG6IWP/O/x6OglpNX1BFNHG90fGiYZyK6Fr7TAgdRV2Z+w4iKr9bgfAup9gmbDkHC5/qI4WORnK6y2ep3meLgV0g+v3rr4zpHMtryyUdNIM+yxZFA8J2G6tsD+lQnKAimOcE5dv/BGmMopIQtvD1g0XWpgbUnOb6dh4KVNUZvKiwsZ9hg7e9Y9mqLhqYg==
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by BN0PR02MB8175.namprd02.prod.outlook.com (2603:10b6:408:163::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.25; Sat, 25 Feb
 2023 20:48:36 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::aeca:cda9:6785:bce0]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::aeca:cda9:6785:bce0%9]) with mapi id 15.20.6134.025; Sat, 25 Feb 2023
 20:48:36 +0000
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
To:     pbonzini@redhat.com, seanjc@google.com, maz@kernel.org,
        james.morse@arm.com, borntraeger@linux.ibm.com, david@redhat.com,
        aravind.retnakaran@nutanix.com
Cc:     kvm@vger.kernel.org, Shivam Kumar <shivam.kumar1@nutanix.com>,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
Subject: [PATCH v8 1/3] KVM: Implement dirty quota-based throttling of vcpus
Date:   Sat, 25 Feb 2023 20:47:57 +0000
Message-Id: <20230225204758.17726-2-shivam.kumar1@nutanix.com>
X-Mailer: git-send-email 2.22.3
In-Reply-To: <20230225204758.17726-1-shivam.kumar1@nutanix.com>
References: <20230225204758.17726-1-shivam.kumar1@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR03CA0009.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::14) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR02MB7555:EE_|BN0PR02MB8175:EE_
X-MS-Office365-Filtering-Correlation-Id: d0cbc2b4-ab3f-458d-07c8-08db1771aa5c
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fqlJ52KGoF3kk8XF/6i9hPR9fqX1zSMeSPHhdEQ1yvkTy0c4fQnbN9VSL5tDTGEoezmhiCMsZxF6Pz3vzlivyhr3ZWrfB+rjzJI/gKf1lyAqjJ+CpKKWiSMx92xn3lxsDMPK97siZFXtSC6QbSpqEgsOm8EVpYwvFfwY1LJi99RnEdK1aJ8SHNvPMZ6VmEViopdjFMvXg3gCw/jFdZ6KAuKuNYYpGOnYv2CtD8NxxP6Y6cmc03MkAP1YSIJK2wD963Pqaji0fqtNhu+WTvEB04D4MFTN0WbhxlTJAQnkhLA5lYtN/nc7AUHwTvUrfcNE+Dp7bBnAltxDPF60cEe2Bwlo6q5N1l7NPqcEqOUgVWipyT+AYbtX2x9fV3lJge7xuXijTUr+dnFswfy5YFKmQRZ4DQsxnJQ5EPSJANLOFNs+Hy+0rVSoSWJ1MoLXtPsdS84BVzNNnymZz7bH8ZxYjvRFkvY0izIQ6OaAcN9fn2KGMsp+QodPkluqxXVrn4E5B1MQ71Q+Jn2P3UqI02bBylTXjKxs4zCI9lKqeuNdyGkWzVL8kFHz4kvR/+1A4K4bYlk5AVsiLOIb8SJXvZDkI27w1O2kBjIxjnOcfLGfMCDXzdhj+jgGeRo82tDb8aWIWCmilMcObnKv9fhqr7HPhQNo/5cYONUr+EIi0HAVAZFpGGTK0FFzIugMxuDkwpFRcX2mIdrb5vmkc3JxmxNrcuBcOBPRw9IV4pt+keUt6yV9DQtmCmKo6xlIqa223r21
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(39860400002)(346002)(396003)(376002)(136003)(451199018)(36756003)(86362001)(41300700001)(66556008)(66476007)(8676002)(66946007)(4326008)(8936002)(478600001)(6636002)(54906003)(5660300002)(316002)(15650500001)(2906002)(52116002)(83380400001)(38100700002)(38350700002)(6506007)(107886003)(6666004)(6512007)(186003)(26005)(1076003)(6486002)(2616005)(14143004)(309714004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cSKZkm2oKhlnU0oKx7e3LlP2iUVtsKRT6I63WdcIvN53FRaMehXjdJeJqrPC?=
 =?us-ascii?Q?PJUWPfwIQWjsPMWWSvPkNgWHgl/cM9XvwQGN9vXuUoXsHGDDKnhlGPEO2DSD?=
 =?us-ascii?Q?PaRt8+xRHiHxxV6Ro+uKO7TwKnEdrFbEkMXAmZD/jtl2NlJy5H9f4WxOjqla?=
 =?us-ascii?Q?SVn1qWCWjh7J8gESmgsNgtfjAUU4a/Z9cv3Tpno29xcxX238dS1Qgtjt+hDS?=
 =?us-ascii?Q?Vw2+75rbqh27QpvzgbBrvGL1PPTRVuNeD+LT/B4auCIfCT82d/6gUiVEjD9O?=
 =?us-ascii?Q?0XKUbsePRv6YlQWOy6zdtCXHqVCLPiDhTkeyGvp2BSnfKs5XL99BdEYsm+ER?=
 =?us-ascii?Q?a86V8eR0SZBzZjOU4vDViXkFn9QUMlLyM1MX6MaPnfUWKV/TaxcUrl6UL940?=
 =?us-ascii?Q?P//1gfFllYBR6IeWpnTFyR3xMbdPa+6pcezOHm/tV+aOMzMVxHjBh7Rg3K5J?=
 =?us-ascii?Q?skn3CpVfPm99dXuEtgNOkgF8t6VgwjBnefgi8MEXGxuXnC0zNB/mOB2Xp5aw?=
 =?us-ascii?Q?nsbUsnG1Eor4SkiQ76Q9v5SePvv0tBJ6whnDP3p9KpqIpe2svTnosL8beF5g?=
 =?us-ascii?Q?rnWEYcPs3RKq5QoBDbUynmhKnPwKNm7xu0wlz7/L53MmUiM5HVEAzjCJkFqS?=
 =?us-ascii?Q?0oofAiFFL0HoYHD95I5AnaylPleMZTSljO0dJQRdxQb8tipnwzUd/8laSzoi?=
 =?us-ascii?Q?OLWgiVjVSq8dROTywzuFPyKgdTV+ST6/cUy5OVHqomUfMOtx+qbJE9tgyWVW?=
 =?us-ascii?Q?dD0n6mIjm92VJZ9PITKgWtYHAl9/b8mS0PX4CQCSLwmbuh0Y5cPUhOvom6K8?=
 =?us-ascii?Q?sTNdPQwsJhmDT0LOKxzM+gIs5+hI1vgYz5cbhOLOb6QeT/+jXD12bYSymIh/?=
 =?us-ascii?Q?whCuP5qK2SFRTDTk49iki7Dd95cmgqW7sXdS8PI5Z4oCRjs/A3ecY8LuAuFa?=
 =?us-ascii?Q?Ktq97VR2wBQobpseffqyBcsbh1CCI86gTKIk3u5B7amyKBx2hRLcOeP2OQJl?=
 =?us-ascii?Q?WJbFwZNUktArH2R8SAf55QgRFxcrekgtC8CUslrkhGUErQMdsr8KoZCM0LDM?=
 =?us-ascii?Q?fzfrEQXRkdj+QT9ZO7XrdTuyTz4s65jQ5xl9UXzvdXo+SS4P55admAbh5Mnb?=
 =?us-ascii?Q?ARgYM1CsO9SVQGyj6pPQT8jA+lD1i2ikCoDr2uKTlSiJKE4sLdiyrFBWqDN3?=
 =?us-ascii?Q?8deceDA4j7LBO6DdnrEqJ6xlIIRejSaOgAFWBslEy+JQDnWKKh6BL2ueXkVr?=
 =?us-ascii?Q?IUMdhK5UPC9csB48qqUk4ltJK/sqbm9c2gjEnEPvhZ99k4Es1Crg1n/V644V?=
 =?us-ascii?Q?s3q7yEKdnfoUVsgmuVUizYeUgbo511g77qVXJywcJljbVH3XSDzpse9IUW0w?=
 =?us-ascii?Q?mgzWsAbqqN4KtebCoLVDyjc9zv+FYuvf98x44iW//bN9QuKYVP0YgwlUCFvs?=
 =?us-ascii?Q?PgWrjqxIOolwaZxNiY3mze3VAvJXiPUOcDOeI6KI8lU4xC/hyJTh7QBp0tHo?=
 =?us-ascii?Q?7O+V2zZddYtI9cyOCqTEb9tf7kEDzPzuBNipWdT4A/I+4IIEbzBcDluX5OvB?=
 =?us-ascii?Q?w/46fGGr1ocIf7Nq4CUaUPp1WrQgRY3iX6dkd4QRyj+3ozMWNHRAOq5xFRl+?=
 =?us-ascii?Q?7g=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0cbc2b4-ab3f-458d-07c8-08db1771aa5c
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2023 20:48:36.1520
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qT5B9NtvF3HpiWAGQg0zT6pX6A+2s4eaml5Od8L5a7NjAlMQdAuuB7su2HPTi3MjMSN4zl5kyb+l1eQwfGEVXRerx738ygB6qEy3UkuaHJA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR02MB8175
X-Proofpoint-ORIG-GUID: GvTLQJazGrkdBeNcCn8bDQPMUoiC-E_W
X-Proofpoint-GUID: GvTLQJazGrkdBeNcCn8bDQPMUoiC-E_W
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

Define dirty_quota_bytes variable to track and throttle memory
dirtying for every vcpu. This variable stores the number of bytes the
vcpu is allowed to dirty. To dirty more, the vcpu needs to request
more quota by exiting to userspace.

Implement update_dirty_quota function which

i) Decreases dirty_quota_bytes by arch-specific page size whenever a
page is dirtied.
ii) Raises a KVM request KVM_REQ_DIRTY_QUOTA_EXIT whenever the dirty
quota is exhausted (i.e. dirty_quota_bytes <= 0).

Suggested-by: Shaju Abraham <shaju.abraham@nutanix.com>
Suggested-by: Manish Mishra <manish.mishra@nutanix.com>
Co-developed-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
Signed-off-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
Signed-off-by: Shivam Kumar <shivam.kumar1@nutanix.com>
---
 Documentation/virt/kvm/api.rst | 17 +++++++++++++++++
 include/linux/kvm_host.h       |  5 +++++
 include/uapi/linux/kvm.h       |  8 ++++++++
 tools/include/uapi/linux/kvm.h |  1 +
 virt/kvm/Kconfig               |  3 +++
 virt/kvm/kvm_main.c            | 31 +++++++++++++++++++++++++++++++
 6 files changed, 65 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 62de0768d6aa..3a283fe212d8 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6688,6 +6688,23 @@ Please note that the kernel is allowed to use the kvm_run structure as the
 primary storage for certain register types. Therefore, the kernel may use the
 values in kvm_run even if the corresponding bit in kvm_dirty_regs is not set.
 
+::
+
+	/*
+	 * Number of bytes the vCPU is allowed to dirty if KVM_CAP_DIRTY_QUOTA is
+	 * enabled. KVM_RUN exits with KVM_EXIT_DIRTY_QUOTA_EXHAUSTED if this quota
+	 * is exhausted, i.e. dirty_quota_bytes <= 0.
+	 */
+	long dirty_quota_bytes;
+
+Please note that enforcing the quota is best effort. Dirty quota is reduced by
+arch-specific page size when any guest page is dirtied. Also, the guest may dirty
+multiple pages before KVM can recheck the quota.
+
+::
+  };
+
+
 
 6. Capabilities that can be enabled on vCPUs
 ============================================
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 8ada23756b0e..f5ce343c64f2 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -167,6 +167,7 @@ static inline bool is_error_page(struct page *page)
 #define KVM_REQ_VM_DEAD			(1 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_UNBLOCK			2
 #define KVM_REQ_DIRTY_RING_SOFT_FULL	3
+#define KVM_REQ_DIRTY_QUOTA_EXIT	4
 #define KVM_REQUEST_ARCH_BASE		8
 
 /*
@@ -800,6 +801,9 @@ struct kvm {
 	bool dirty_ring_with_bitmap;
 	bool vm_bugged;
 	bool vm_dead;
+#ifdef CONFIG_HAVE_KVM_DIRTY_QUOTA
+	bool dirty_quota_enabled;
+#endif
 
 #ifdef CONFIG_HAVE_KVM_PM_NOTIFIER
 	struct notifier_block pm_notifier;
@@ -1235,6 +1239,7 @@ struct kvm_memory_slot *gfn_to_memslot(struct kvm *kvm, gfn_t gfn);
 bool kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn);
 bool kvm_vcpu_is_visible_gfn(struct kvm_vcpu *vcpu, gfn_t gfn);
 unsigned long kvm_host_page_size(struct kvm_vcpu *vcpu, gfn_t gfn);
+void update_dirty_quota(struct kvm *kvm, unsigned long page_size_bytes);
 void mark_page_dirty_in_slot(struct kvm *kvm, const struct kvm_memory_slot *memslot, gfn_t gfn);
 void mark_page_dirty(struct kvm *kvm, gfn_t gfn);
 
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index d77aef872a0a..ddb9d3d797c4 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -264,6 +264,7 @@ struct kvm_xen_exit {
 #define KVM_EXIT_RISCV_SBI        35
 #define KVM_EXIT_RISCV_CSR        36
 #define KVM_EXIT_NOTIFY           37
+#define KVM_EXIT_DIRTY_QUOTA_EXHAUSTED 38
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -526,6 +527,12 @@ struct kvm_run {
 		struct kvm_sync_regs regs;
 		char padding[SYNC_REGS_SIZE_BYTES];
 	} s;
+	/*
+	 * Number of bytes the vCPU is allowed to dirty if KVM_CAP_DIRTY_QUOTA is
+	 * enabled. KVM_RUN exits with KVM_EXIT_DIRTY_QUOTA_EXHAUSTED if this quota
+	 * is exhausted, i.e. dirty_quota_bytes <= 0.
+	 */
+	long dirty_quota_bytes;
 };
 
 /* for KVM_REGISTER_COALESCED_MMIO / KVM_UNREGISTER_COALESCED_MMIO */
@@ -1184,6 +1191,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_S390_PROTECTED_ASYNC_DISABLE 224
 #define KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP 225
 #define KVM_CAP_PMU_EVENT_MASKED_EVENTS 226
+#define KVM_CAP_DIRTY_QUOTA 227
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
index 55155e262646..48f236e2b836 100644
--- a/tools/include/uapi/linux/kvm.h
+++ b/tools/include/uapi/linux/kvm.h
@@ -1175,6 +1175,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_DIRTY_LOG_RING_ACQ_REL 223
 #define KVM_CAP_S390_PROTECTED_ASYNC_DISABLE 224
 #define KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP 225
+#define KVM_CAP_DIRTY_QUOTA 227
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index b74916de5183..ccaa332d88f9 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -19,6 +19,9 @@ config HAVE_KVM_IRQ_ROUTING
 config HAVE_KVM_DIRTY_RING
        bool
 
+config HAVE_KVM_DIRTY_QUOTA
+       bool
+
 # Only strongly ordered architectures can select this, as it doesn't
 # put any explicit constraint on userspace ordering. They can also
 # select the _ACQ_REL version.
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d255964ec331..744b955514ce 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3096,6 +3096,9 @@ static int __kvm_write_guest_page(struct kvm *kvm,
 	r = __copy_to_user((void __user *)addr + offset, data, len);
 	if (r)
 		return -EFAULT;
+#ifdef CONFIG_HAVE_KVM_DIRTY_QUOTA
+	update_dirty_quota(kvm, PAGE_SIZE);
+#endif
 	mark_page_dirty_in_slot(kvm, memslot, gfn);
 	return 0;
 }
@@ -3234,6 +3237,9 @@ int kvm_write_guest_offset_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
 	r = __copy_to_user((void __user *)ghc->hva + offset, data, len);
 	if (r)
 		return -EFAULT;
+#ifdef CONFIG_HAVE_KVM_DIRTY_QUOTA
+	update_dirty_quota(kvm, PAGE_SIZE);
+#endif
 	mark_page_dirty_in_slot(kvm, ghc->memslot, gpa >> PAGE_SHIFT);
 
 	return 0;
@@ -3304,6 +3310,18 @@ int kvm_clear_guest(struct kvm *kvm, gpa_t gpa, unsigned long len)
 }
 EXPORT_SYMBOL_GPL(kvm_clear_guest);
 
+void update_dirty_quota(struct kvm *kvm, unsigned long page_size_bytes)
+{
+	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
+
+	if (!vcpu || (vcpu->kvm != kvm) || !READ_ONCE(kvm->dirty_quota_enabled))
+		return;
+
+	vcpu->run->dirty_quota_bytes -= page_size_bytes;
+	if (vcpu->run->dirty_quota_bytes <= 0)
+		kvm_make_request(KVM_REQ_DIRTY_QUOTA_EXIT, vcpu);
+}
+
 void mark_page_dirty_in_slot(struct kvm *kvm,
 			     const struct kvm_memory_slot *memslot,
 		 	     gfn_t gfn)
@@ -3334,6 +3352,9 @@ void mark_page_dirty(struct kvm *kvm, gfn_t gfn)
 	struct kvm_memory_slot *memslot;
 
 	memslot = gfn_to_memslot(kvm, gfn);
+#ifdef CONFIG_HAVE_KVM_DIRTY_QUOTA
+	update_dirty_quota(kvm, PAGE_SIZE);
+#endif
 	mark_page_dirty_in_slot(kvm, memslot, gfn);
 }
 EXPORT_SYMBOL_GPL(mark_page_dirty);
@@ -3343,6 +3364,9 @@ void kvm_vcpu_mark_page_dirty(struct kvm_vcpu *vcpu, gfn_t gfn)
 	struct kvm_memory_slot *memslot;
 
 	memslot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
+#ifdef CONFIG_HAVE_KVM_DIRTY_QUOTA
+	update_dirty_quota(vcpu->kvm, PAGE_SIZE);
+#endif
 	mark_page_dirty_in_slot(vcpu->kvm, memslot, gfn);
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_mark_page_dirty);
@@ -4524,6 +4548,8 @@ static long kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 	case KVM_CAP_BINARY_STATS_FD:
 	case KVM_CAP_SYSTEM_EVENT_DATA:
 		return 1;
+	case KVM_CAP_DIRTY_QUOTA:
+		return !!IS_ENABLED(CONFIG_HAVE_KVM_DIRTY_QUOTA);
 	default:
 		break;
 	}
@@ -4673,6 +4699,11 @@ static int kvm_vm_ioctl_enable_cap_generic(struct kvm *kvm,
 
 		return r;
 	}
+#ifdef CONFIG_HAVE_KVM_DIRTY_QUOTA
+	case KVM_CAP_DIRTY_QUOTA:
+		WRITE_ONCE(kvm->dirty_quota_enabled, cap->args[0]);
+		return 0;
+#endif
 	default:
 		return kvm_vm_ioctl_enable_cap(kvm, cap);
 	}
-- 
2.22.3

