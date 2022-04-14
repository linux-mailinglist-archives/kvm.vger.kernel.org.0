Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B866501B37
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 20:47:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344776AbiDNSsu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 14:48:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243184AbiDNSsl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 14:48:41 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2087.outbound.protection.outlook.com [40.107.220.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0C8BDBD13
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 11:46:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ODzD7opW+b6+es/RzB3R5z0lBonBHRwkusN4t/5+Sd6Ndj8dEt66PnxUve4RCmyzXHfdHib0uqsi5q6D1ARfoDBwDz/ycYekUw4KMAdsrRAPeVMVCxI6tHrGVk2FtuguREEgfUbcjCzRnbcVFNfeA5bGl/k36Ak37IUz0ySHeC5MLKN2Hx2Va/UNUgPUne3GkK/EwWw1m2f8SNAtlcDPyUiAvOWsRm+JW6CXj5MM2ucMu1vXJwkBN481z48Mp55/gpbImDCPX3U0uPWXPw1wJiBVHm5/o+4bLMKbQWDoZsG9ho6XQVV6JjVj1yTik7W0xAsLJ63BRvenq5LMMRgIbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dPYNkGtKhIC3GQC4bpyRromr8EXvQn3unFBLkP+MEF0=;
 b=myXDoDVYKVtRn+Elgqs2f9TVP3Qf2+vwpDSEiEYNUPKYNmRwpOoFx9qjAP+tsGuva25RBESxB+PvgG+jV4KjqdEX5y0rDDHLvtUS7RpUNZ7fCChX4w7fWy4bozxRbEKnkSMSi/cBlOaNoeHEw2yrmkDBVrRwntpvj7v9PdLZ+xjY8Mh/N+RkkY/BZwKOn7xw6G2KeTHFd1+V1zgeiLNml8ezBPN3rtK3ucPMFSRy9vhmjB+4C3d+3Sf4BX/6F6rAibIJjCWVmo8Pc8eTUkROffnBxEADQDBulN2IMVY0uRngQgoomp6TeKWXRx2MsF20MyAHvucVo4aLbiazdH02Tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dPYNkGtKhIC3GQC4bpyRromr8EXvQn3unFBLkP+MEF0=;
 b=hD28ThIdCg3LQe9lKwAWm9DjbOKftQvrZzfW3Q3jYXOB+/7mGppDOJCInueHXa1eQks1XhDwhetcDVuu4fof/FPC7Kk1syhgZwsJ/A/adKlaY7iVEyewvp78WpNekTqWk8YYkn0X/Rrx6Mcw8YUTFxcLiHNTDafIGCWT69qc/99huEsXMc2meENHVnQoH06tz25rnxs91OwSGdAafdVp9Tjzq7D418g3AhtDP41MpbMLSQ+R26EdxZVMJi8Xb5B6F/Bt8xtGz/7SwcPSNkwe6rfptRnmbgtCnvDMzkArG7QwIP6APnf16mFNLUNQDILCX98KoE9hGfErizwyaOmDMA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BL1PR12MB5350.namprd12.prod.outlook.com (2603:10b6:208:31d::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Thu, 14 Apr
 2022 18:46:12 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%5]) with mapi id 15.20.5164.020; Thu, 14 Apr 2022
 18:46:12 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Eric Auger <eric.auger@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Yi Liu <yi.l.liu@intel.com>
Subject: [PATCH 08/10] vfio: Move vfio_group_set_kvm() into vfio_file_ops
Date:   Thu, 14 Apr 2022 15:46:07 -0300
Message-Id: <8-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com>
In-Reply-To: <0-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0061.namprd03.prod.outlook.com
 (2603:10b6:208:329::6) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f77520be-4761-4205-433d-08da1e470ba1
X-MS-TrafficTypeDiagnostic: BL1PR12MB5350:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB535015B3BABCAA4E64959099C2EF9@BL1PR12MB5350.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VlIKjzHkgZWPKjcF/5QZ1MM6ilDaxAZK5k7bKSL/2foJ/6SlNawmU1ni81QjqP05QDPeeN3vBwA07MEWjb7ZGuC915j6rgAhGCkIpc6x+yf/ACQ/cXrTp7JZdSSO3xEB6m+zLdAHIaCN8eDLwU6n4nZjP6c3bmpQaFsd2HzuAzbeRt78QFwGX8GK0SU5hkYPo4FnEABPqEoayE+qMUPw1GAMK0cAJmC/P23YIvcVJ3qMINr0/F6IV4oXCUXeqy+E9PRA3xg0KStMYgIZFQpMnFF7mPE4UeckgV9gV0n/eor7Lh4Iskqhf48l2GdQgPadHAPAQn6oWwj7kqqTTnKdVc/zE6CHH5TFLrw+J5Onu9+EzxJzT9EBjdagKRXJHeMSuUoWWvA0V6FAEV84PqOvS4bIbEc5UMKGBSgKCMl3M4pjPXUZ8kIYd62toibR1TLOnsIZmUz3siCqxnhxO4CzRLviFmuqW2Ax+O6C3gOsyR4luEPQccUYgZmwolxlc0UMKWz08P/Hg/249nZlx1jz9hdr+cMZXoyYk27nqd/tmWlX/L074LlcvCAINNq43FOZBGz3JFkGEJVVvBq6Mq9iNlgPakSRFOOLpjNCyT/Ott28jbushaLlL0HTqqe6C1nbn+y6YgkAKuCPNyClDjgl4RMLscwtzNhSoL3S7O03qnnpKoWAiaIe5K8omnFrcLsmUrr72UZaHeGttXPfNjFfGQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2616005)(86362001)(186003)(38100700002)(83380400001)(110136005)(66946007)(66476007)(66556008)(8936002)(4326008)(8676002)(316002)(5660300002)(54906003)(26005)(6506007)(6512007)(6666004)(36756003)(2906002)(508600001)(6486002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BTOK42c3eRd8ngsDU1IUmHfaW0H2ga2Uh/2ChPhizgcyltGvAUrxMUaLLNYX?=
 =?us-ascii?Q?jDdMMhhl/X2Yh0tG4HqOV/2t7eWw/SNIlYy30Y495SHyYIAdXcejt1YSCfDY?=
 =?us-ascii?Q?SLqFG6+461I1vlUJCJS7J8hchuDnDgFAh4baE7p2JO1mUM1WQ3j7vD+xrt7V?=
 =?us-ascii?Q?l0hC0SK6hNqD4tuQ9STQEwFtcyymYOB7X6K1ChpNoUsPulP/D1HsbumJXQef?=
 =?us-ascii?Q?0cE7QJXnmfFzpZ/G0CQ+hOMt7ns78wWjGRRiY9Wq4ovipOpLREO+7iWN7w+p?=
 =?us-ascii?Q?i47g4MUpF6ERhRX+6SmVxldm66g9wro3fNimRFBnoLYMtHeEMxQSv8NFQOPo?=
 =?us-ascii?Q?9UMZp9q0znfwzsWgem9tsLZkczDUM+1TZ+m7GsCqUrYJ1HnjQsOxbb0rEUta?=
 =?us-ascii?Q?Hnsc7JMFcrZPGQjuvNNhb2Jcf1DL4CFPxX4HaouZCd5SymvelrCfGX6ogqNM?=
 =?us-ascii?Q?E6GsOKQ6pzpO+4PWFPsHWw/GNt9ej7CKgn3SYvjir/SR2pikJLF+W8lG0Gsl?=
 =?us-ascii?Q?8hLvm7qkCtqWvbfXYfjBx8pO50JbhKTNz/uLit4uOFjSKIffC8I3ZQsSWjQd?=
 =?us-ascii?Q?aVTIYzIXKZCTq1n/aHVeOc1PpJQnoUYey4O7Thp2uInJrdp5eK3PzfULrJYa?=
 =?us-ascii?Q?fj9UZfxDVXBpmODySES3jaOvLSDg4hpkBni1g1CgFv+cp2fwaZYeUg5LEOsG?=
 =?us-ascii?Q?iXLY9MhU9q0M8vKpgVLTlDM9XXaRWDDGOj2F97wFbFfWfiR4SLywCIMM6j+/?=
 =?us-ascii?Q?1jfuup1u2rdA2ajWk8PsA13Hx5LablyNlUl9iLR/NqfHlxDmUJLkuU5QlBGh?=
 =?us-ascii?Q?t6WSgtlrwc/xuSr+10FIa5jWmABN8HIfoaxyliLj/1peJ5uoAv58Yu7Ti17i?=
 =?us-ascii?Q?RYlzFgkmSfTjVxh8Lu6vGL9KB9Fxgd0Di3yTPXklu/yIIR8oNZ+W/QDRE6VQ?=
 =?us-ascii?Q?IdH4Vx1kQHhgI9jweEkTcFonL22cOprVTubXaoKIf6LyU2rDv5meZ/FEz0DW?=
 =?us-ascii?Q?DfW6QZvVsgkD0trlomsj1pfyZ/u/nGoqRJyZvLs6RRadxnfkiXlv+d2OfuBk?=
 =?us-ascii?Q?6YWlr5SGBVGuprHBTxso2kXduMbf42w/n7jy6QrdgDEa1EUQe4b4+h8XNiAB?=
 =?us-ascii?Q?UvNm9rMfZC9pkUFQhbRrPmGgwsGlz3TiQPUQpsGrQgqCBqLanngF8oYFvRbl?=
 =?us-ascii?Q?zvlnhQPIbvoO0H4HmUuTNz1MaI+r9YEPMH3nDmtbAOwJNonXtItMzxD64Hhp?=
 =?us-ascii?Q?li5CwHhDT1Sn/x/KIpetcNBJ6rqVAxIwQxffzdkWKlxD8KfKcSi4PnSq8Imz?=
 =?us-ascii?Q?crC5SVNecuhdXIZnFp8pVc9lrpaP77Ve+HvDD0rFrQr/XLpr4wCUTDVZQrMj?=
 =?us-ascii?Q?HWXWbOEbDZMa1WbrFFUgl6cSS3tuFTfXAuruySYOIMWg+1v5/dDtSqj9JLe3?=
 =?us-ascii?Q?dGOHm0n0Kuqv7V2R8d/aCi7zbi2E9ev+8MeGwxlI52K2vih7aktVi0mNoBcD?=
 =?us-ascii?Q?Qw+K5d6eoZ+2iN4M2PMuvH8lM339Tb+Mab4GHJ2fYnTWX+QsArPA1PjINFS5?=
 =?us-ascii?Q?DJN/rdqB8GFnnRZMhK1nhraEg32qMxHeBAmC3gwmYgsiU5PvMjhIAoOOPkv0?=
 =?us-ascii?Q?fbvJjTYhl0ZLTSvvEVuFKAM5AUpQG+uIKg3J8wcK7FUGehB+Jnm4+BncLzme?=
 =?us-ascii?Q?m0wLp22Iq5ytHWPsLo6swYCSNSVgbhl36uoLa7w/yHS5tbdU+T+mcu02sB/s?=
 =?us-ascii?Q?n2gn6cPzkQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f77520be-4761-4205-433d-08da1e470ba1
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2022 18:46:11.5475
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UeqbMCuHMxhlnIIrissNd7o+cYHojSNyH03+gLI0XoNqh6u1jmbPf1WxwUZD+N55
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5350
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Just move the exported function into the op and have it accept the struct
file instead of vfio_group.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio.c  | 26 ++++++++++++++++++--------
 include/linux/vfio.h |  5 +++--
 virt/kvm/vfio.c      | 19 +++----------------
 3 files changed, 24 insertions(+), 26 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index c08093fb6d28d5..2eb63d9dded8fb 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -2029,9 +2029,27 @@ static bool vfio_file_enforced_coherent(struct file *filep)
 	return ret;
 }
 
+/**
+ * vfio_file_set_kvm - Link a kvm with VFIO drivers
+ * @filep: VFIO file
+ * @kvm: KVM to link
+ *
+ * The kvm pointer will be forwarded to all the vfio_device's attached to the
+ * VFIO file via the VFIO_GROUP_NOTIFY_SET_KVM notifier.
+ */
+static void vfio_file_set_kvm(struct file *filep, struct kvm *kvm)
+{
+	struct vfio_group *group = filep->private_data;
+
+	group->kvm = kvm;
+	blocking_notifier_call_chain(&group->notifier,
+				     VFIO_GROUP_NOTIFY_SET_KVM, kvm);
+}
+
 static const struct vfio_file_ops vfio_file_group_ops = {
 	.get_iommu_group = vfio_file_iommu_group,
 	.is_enforced_coherent = vfio_file_enforced_coherent,
+	.set_kvm = vfio_file_set_kvm,
 };
 
 /**
@@ -2461,14 +2479,6 @@ static int vfio_unregister_iommu_notifier(struct vfio_group *group,
 	return ret;
 }
 
-void vfio_group_set_kvm(struct vfio_group *group, struct kvm *kvm)
-{
-	group->kvm = kvm;
-	blocking_notifier_call_chain(&group->notifier,
-				VFIO_GROUP_NOTIFY_SET_KVM, kvm);
-}
-EXPORT_SYMBOL_GPL(vfio_group_set_kvm);
-
 static int vfio_register_group_notifier(struct vfio_group *group,
 					unsigned long *events,
 					struct notifier_block *nb)
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index b1583eb80f12e6..bc6e47f3f26560 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -15,6 +15,8 @@
 #include <linux/poll.h>
 #include <uapi/linux/vfio.h>
 
+struct kvm;
+
 /*
  * VFIO devices can be placed in a set, this allows all devices to share this
  * structure and the VFIO core will provide a lock that is held around
@@ -141,6 +143,7 @@ int vfio_mig_get_next_state(struct vfio_device *device,
 struct vfio_file_ops {
 	struct iommu_group *(*get_iommu_group)(struct file *filep);
 	bool (*is_enforced_coherent)(struct file *filep);
+	void (*set_kvm)(struct file *filep, struct kvm *kvm);
 };
 extern struct vfio_group *vfio_group_get_external_user(struct file *filep);
 extern void vfio_group_put_external_user(struct vfio_group *group);
@@ -186,8 +189,6 @@ extern int vfio_unregister_notifier(struct device *dev,
 				    enum vfio_notify_type type,
 				    struct notifier_block *nb);
 
-struct kvm;
-extern void vfio_group_set_kvm(struct vfio_group *group, struct kvm *kvm);
 
 /*
  * Sub-module helpers
diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
index f5ef78192a97ab..9baf04c5b0cc3d 100644
--- a/virt/kvm/vfio.c
+++ b/virt/kvm/vfio.c
@@ -73,19 +73,6 @@ static void kvm_vfio_group_put_external_user(struct vfio_group *vfio_group)
 	symbol_put(vfio_group_put_external_user);
 }
 
-static void kvm_vfio_group_set_kvm(struct vfio_group *group, struct kvm *kvm)
-{
-	void (*fn)(struct vfio_group *, struct kvm *);
-
-	fn = symbol_get(vfio_group_set_kvm);
-	if (!fn)
-		return;
-
-	fn(group, kvm);
-
-	symbol_put(vfio_group_set_kvm);
-}
-
 static void kvm_spapr_tce_release_vfio_group(struct kvm *kvm,
 					     struct kvm_vfio_group *kvg)
 {
@@ -184,7 +171,7 @@ static int kvm_vfio_group_add(struct kvm_device *dev, unsigned int fd)
 
 	mutex_unlock(&kv->lock);
 
-	kvm_vfio_group_set_kvm(vfio_group, dev->kvm);
+	kvg->ops->set_kvm(kvg->filp, dev->kvm);
 	kvm_vfio_update_coherency(dev);
 
 	return 0;
@@ -218,7 +205,7 @@ static int kvm_vfio_group_del(struct kvm_device *dev, unsigned int fd)
 		list_del(&kvg->node);
 		kvm_arch_end_assignment(dev->kvm);
 		kvm_spapr_tce_release_vfio_group(dev->kvm, kvg);
-		kvm_vfio_group_set_kvm(kvg->vfio_group, NULL);
+		kvg->ops->set_kvm(kvg->filp, NULL);
 		kvm_vfio_group_put_external_user(kvg->vfio_group);
 		fput(kvg->filp);
 		kfree(kvg);
@@ -334,7 +321,7 @@ static void kvm_vfio_destroy(struct kvm_device *dev)
 
 	list_for_each_entry_safe(kvg, tmp, &kv->group_list, node) {
 		kvm_spapr_tce_release_vfio_group(dev->kvm, kvg);
-		kvm_vfio_group_set_kvm(kvg->vfio_group, NULL);
+		kvg->ops->set_kvm(kvg->filp, NULL);
 		kvm_vfio_group_put_external_user(kvg->vfio_group);
 		fput(kvg->filp);
 		list_del(&kvg->node);
-- 
2.35.1

