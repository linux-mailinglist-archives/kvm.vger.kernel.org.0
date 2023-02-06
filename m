Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB6D768B6C9
	for <lists+kvm@lfdr.de>; Mon,  6 Feb 2023 08:50:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbjBFHug (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 02:50:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229921AbjBFHuc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 02:50:32 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on20603.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eaa::603])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E950B18AA1;
        Sun,  5 Feb 2023 23:50:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=obie/PwJcOe2hDpi6+/p0mbSZE+iDhqWzJUUigICaut5IiNVmMZcMK0s1zPImn5mryTULm8oG6FX05Q+fIoIJ48WxWZLG8j0S6AYWXDjPrYtZmdOlO7ztoKDhgjInSqWe+pDAxICHsYnluMjoSz3U6wTTjmbmpBLuTOW7bnT7WwcXK8BaXp+ZAoAmghhz/eZDuTVhoSgq+Yub+eQmBp00p/B16DOhWTzesK9GBmTheTGJjSgpHFdMgQbvi3dH7PyuFOrwI3gdkOuY0Q4e8Z/k3JksCiPrU2s71luD/qYO2rlokmq8mLCMFwg7ekZxSXAu3c85YcujhyBylouCQBJ6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sABmSCNhqUaki37ROAvn5I2o7zlTWP9iNz0mlKPN/jY=;
 b=CFPPMeAcsBiiJ46UEfy5VNfnk4mAIN6Dr9ckIFEop+AVXMXunqipKYFibH3NfUpVVLybvP4oE7GZRlJH7uE57qY7G3+DUvMQ+X3WbITsattT5PXhPfZ5CrVtPRHeOJNDLO2oTZDuawODWrGJDJcOIIcHRpgi6MXri/KS6PEB8CmBZPXonbKPMwEBFBcQ+wfiEwYtKcGA99gATAvqib8pez3DEKJbGIJea+7+BrO5kC0YcQF+hd5Q7uDl65rGhKN4jFj1jwP1gtSF0kA6BOp+xuoSJas3Oqyi4kkDQsSmdccxxrq5XtsJdnf3MxW349vZAQmWTJzukswV4GNS2HNZVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sABmSCNhqUaki37ROAvn5I2o7zlTWP9iNz0mlKPN/jY=;
 b=CHQwI+iS0hEE2NUjjhh1a8duKr1QEY6gPXkrUEGnhAhiYZh+EwVnEAFuu6/3arCe0qEFPyeE2mBJS0Udgi5k66OavT3AMmplZcz+uqJ83WF5eUQ5sS442WqtwUFWuLpFxK/zyKakGOwypeQsFr1EktqHWHS5HGj9MTzIj/AKquxhLnOuUR71GyVwKhW56iQeZoCko6AgUbTs5rLuExRipjp4QI8mrKGzItovJHdZJzO2Fpz/Ba0JCxnBKnH4N5jmB2+0c3yQah1YL+DcG/bEQext5pLO3aDQcjy6sqSW9YyWytpFSiGFz0j/RXveAB7XaOc8DdrOQSGve00kTSX1UA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3176.namprd12.prod.outlook.com (2603:10b6:a03:134::26)
 by DS0PR12MB8573.namprd12.prod.outlook.com (2603:10b6:8:162::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.32; Mon, 6 Feb
 2023 07:49:34 +0000
Received: from BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::4bd4:de67:b676:67df]) by BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::4bd4:de67:b676:67df%6]) with mapi id 15.20.6064.032; Mon, 6 Feb 2023
 07:49:34 +0000
From:   Alistair Popple <apopple@nvidia.com>
To:     linux-mm@kvack.org, cgroups@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, jgg@nvidia.com, jhubbard@nvidia.com,
        tjmercier@google.com, hannes@cmpxchg.org, surenb@google.com,
        mkoutny@suse.com, daniel@ffwll.ch,
        "Daniel P . Berrange" <berrange@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Alistair Popple <apopple@nvidia.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org
Subject: [PATCH 12/19] kvm/book3s_64_vio: Convert account_locked_vm() to vm_account_pinned()
Date:   Mon,  6 Feb 2023 18:47:49 +1100
Message-Id: <afa65293cb7aa418fd7a02486817a3a81b88baf8.1675669136.git-series.apopple@nvidia.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <cover.c238416f0e82377b449846dbb2459ae9d7030c8e.1675669136.git-series.apopple@nvidia.com>
References: <cover.c238416f0e82377b449846dbb2459ae9d7030c8e.1675669136.git-series.apopple@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SY0PR01CA0008.ausprd01.prod.outlook.com
 (2603:10c6:10:1bb::7) To BYAPR12MB3176.namprd12.prod.outlook.com
 (2603:10b6:a03:134::26)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB3176:EE_|DS0PR12MB8573:EE_
X-MS-Office365-Filtering-Correlation-Id: 1711d04f-1228-49b9-6835-08db0816affc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ivvth6W4nqFwCtLaRy31c0XU0ftAT7d0a+ncwklm/9hY8CDYIaLq8S9Jt2xQjUHxCuE39zwggwD/XO53FRHcYW1qtRs2tTLOW7vRhqIrBHYMJ9323/945oJADFzxZKHDVs6lUFv50zoYf0bfEusrFpmVmPVJQLmXVgYDaqhXSlybJ54Nb+MoKlEYynZapcQ13LWsg2+98QqVzcvI9NiZH4u12UOdiXeL29R/tul5Gx5oHmlnrsYMHLVbYioDcqqURbUci5Mwsw5cdFsI2/jjQdQ1LGAlr4ca4tdToJy6ks9DEVIb0CoVjPrJ3mmvqOtileYU5KI091ItQnZZdNTO9G+Ew9R+MxfNlFWij0HejOfkyr+GwPn/bJvNDs0QZGHbV5zwtu/7CvLHGuEsBLQbtuPSyAyOaNtdkwsBgX4ILtycqzAUXa2SuJNL3KL+iQU8SK/635mU4gavA2nari5HHpXFjPKm3fPLJsBM6IGHUdYfGDyF9/tMbN1Wfm+HbYu2hhi1aZuach6sacGBh0z7TgaMd0iDiWPRD5BLqE8YTEFT/D16746WxEkx0Ok1H6xxQ245Udui6PaqaB+SHubEythSM2HiRTk3B8ltzXn/PygycjHCQxhMrJpallA2QZIeQxTKJiB/X78qMo62cUKse58eA40a69NMAtKUimwAxyrRhv7TbnRiI5nrrqZKWN/2vbvQs0zCJkwryFodHzS3dw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(396003)(136003)(39860400002)(366004)(346002)(451199018)(54906003)(316002)(86362001)(6666004)(6486002)(38100700002)(186003)(2616005)(6506007)(26005)(478600001)(6512007)(7416002)(5660300002)(83380400001)(15650500001)(2906002)(36756003)(66946007)(8936002)(4326008)(41300700001)(66476007)(8676002)(66556008)(473944003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ay8XosogCpkzfmHNeC+DwsG6+2Mjp57f5iWgheg8h1dEFMr2NETA+gBVc0bY?=
 =?us-ascii?Q?APJv9JWXE263bQhiw4FP0PqKc4qUtuFNRZZ59XV7v4yHQU1T4a56TNbxaxHM?=
 =?us-ascii?Q?FwG7LGQTMNg/jT0xVXpb8rSm7/z7dV4NrDckvYimWl9aodag6vY3l2LHvTs4?=
 =?us-ascii?Q?wNS/La/dsWq5nOsK6QeI0rJmbpDpFngl5D986CNO2Vi3y3d1YQPIrkEQw8q2?=
 =?us-ascii?Q?B0XUo8ExB3gHezUReau3OlMkQ8U6f6yU5EvKvX7+wCtY+UvXwCL2DwmIBMu8?=
 =?us-ascii?Q?TTQ2vYtdJuqD/v0puA44iR8zcR8xYqjhp79cFFAwKZHDRPxpCw7vl06vRlIT?=
 =?us-ascii?Q?j6+B+Kn3yEW4xKVRFUQvGgZEoY6C6wKFwswXF9+f6zLkWftBmPibS9cBFE37?=
 =?us-ascii?Q?y2c9FxUgoZFqaWdFy1bSP0VE7FiNhE4ccnivmk48iA6C3wbl7Qmf2gdG35dT?=
 =?us-ascii?Q?UHApoTY74Bn0Nl7vVjc34616QxCdbBPWZrE7YPBoDxircSESUzSXRw0odxAG?=
 =?us-ascii?Q?tFL4G2y5AavytvlgQavkOiSQwUTNHQwlYZQkzRDGo/NUgalbMI1+U73/xiQ+?=
 =?us-ascii?Q?s7hnTA9EEs5vF6jTORbBotq5iE3gbufrqf9FQr80pzeT8urtpuX6xnuC9gyt?=
 =?us-ascii?Q?7p1cVUBgZymWci/gN/z/Yorhpy8f1AhrIl45kLi9Fg0bdaGdGc8+xbuNc4LY?=
 =?us-ascii?Q?yPkOUC/rCCBBV05mygMS9I06XydHCtXv2qMkw0M9XR6w+jljsWYGN5WVFaY+?=
 =?us-ascii?Q?QSMUPl/tz368jzEJsCMLf3K8OxGMhvwnRD9Axf3NLz2JPWUHxtQ/Z59Z6ohf?=
 =?us-ascii?Q?/fCPFE3XHQqTxMwzXzRn/E1Vj/oQddE6shZNenfuh2H5K9CurOaIXwvNrW8U?=
 =?us-ascii?Q?+ZKskJfZn1p1l0Xgs8F/9UNeZUYX+f4llgO1FBTx9rwTImOm4+ezUZGYiNU8?=
 =?us-ascii?Q?XVOhsxX/ko44nf9j7/niHDddmKcoxXO1ce41cj1wl1HOAT+xzBOCGxyqVsp4?=
 =?us-ascii?Q?9WhnHdKJvUgWduOylyhXr5r/0lF3ZAx4qH3Qu3N1NEszkeytXWG9YQKW6zNT?=
 =?us-ascii?Q?m3H2ebdLOHxd8XQP61f/fKG38eC9B4IOh4GsXCylh6gRszJ3WIZjDG35JNcQ?=
 =?us-ascii?Q?koP1sfG/xAwFRniir2Ipt3GbDiPjS34t7ca5A4XOk9bmxL5hJBpNF3us5+In?=
 =?us-ascii?Q?TE9rH7qgH86T4ojOv4GLqIu/DlX3+JSDYDDFNLDGUQ0ZM0+QPi4ZO3zLsuPm?=
 =?us-ascii?Q?OkK9CH03s+TLaKhzmlzvq/xU6W57wj7uF4s5o91nJwe9mYjKpLa6BrVzProP?=
 =?us-ascii?Q?wFqtJoNi7y2wgI/j9353o1+8FLEY/veLPTutass9w4mSPjMDX0kHwfJp3ew6?=
 =?us-ascii?Q?+VYOfimqvzYs/4X4NMXUJR4u6qhEJOarofjVSmAWiD5oGmjxS2RbCujzBeCg?=
 =?us-ascii?Q?sO0y/ixQfmGbY5RR5a+/JLYdWq1WQV3jZqcbxo+6AwmXmxVyNdKZeNq7vU6x?=
 =?us-ascii?Q?c53fke44EmeHgk5LjnTiEKr5CyKIrY2ReJSxnjFxfcIUbO6W+E0U6fdlJB5G?=
 =?us-ascii?Q?mcPDcggpLbUqX2wDPn9PQDGXxt6HTikcSBMkvLb+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1711d04f-1228-49b9-6835-08db0816affc
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 07:49:33.9164
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c9J1tJaY4pyotV0qCSTqLu5myKDaf6kn5nhV5WxMGeFphKFkr68yrsw6s6yLnhpSy6sjXSjUlVCrpf09HaGxPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8573
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

book3s_64_vio currently accounts for pinned pages with
account_locked_vm() which charges the pages to mm->locked_vm. To make
this consistent with other drivers switch to using
vm_account_pinned().

Signed-off-by: Alistair Popple <apopple@nvidia.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: linuxppc-dev@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
---
 arch/powerpc/kvm/book3s_64_vio.c | 10 +++++-----
 include/linux/kvm_host.h         |  2 ++
 virt/kvm/kvm_main.c              |  3 +++
 3 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_64_vio.c b/arch/powerpc/kvm/book3s_64_vio.c
index 95e738e..ecd1deb 100644
--- a/arch/powerpc/kvm/book3s_64_vio.c
+++ b/arch/powerpc/kvm/book3s_64_vio.c
@@ -273,8 +273,8 @@ static int kvm_spapr_tce_release(struct inode *inode, struct file *filp)
 		}
 	}
 
-	account_locked_vm(kvm->mm,
-		kvmppc_stt_pages(kvmppc_tce_pages(stt->size)), false);
+	vm_unaccount_pinned(&kvm->vm_account,
+		kvmppc_stt_pages(kvmppc_tce_pages(stt->size)));
 
 	kvm_put_kvm(stt->kvm);
 
@@ -301,8 +301,8 @@ long kvm_vm_ioctl_create_spapr_tce(struct kvm *kvm,
 		(args->offset + args->size > (ULLONG_MAX >> args->page_shift)))
 		return -EINVAL;
 
-	npages = kvmppc_tce_pages(args->size);
-	ret = account_locked_vm(mm, kvmppc_stt_pages(npages), true);
+	npages = kvmppc_tce_pages(size);
+	ret = vm_account_pinned(&kvm->vm_account, kvmppc_stt_pages(npages));
 	if (ret)
 		return ret;
 
@@ -347,7 +347,7 @@ long kvm_vm_ioctl_create_spapr_tce(struct kvm *kvm,
 
 	kfree(stt);
  fail_acct:
-	account_locked_vm(mm, kvmppc_stt_pages(npages), false);
+	vm_unaccount_pinned(&kvm->vm_account, kvmppc_stt_pages(npages));
 	return ret;
 }
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 4f26b24..bd7a7be 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -35,6 +35,7 @@
 #include <linux/interval_tree.h>
 #include <linux/rbtree.h>
 #include <linux/xarray.h>
+#include <linux/vm_account.h>
 #include <asm/signal.h>
 
 #include <linux/kvm.h>
@@ -717,6 +718,7 @@ struct kvm {
 	 */
 	struct mutex slots_arch_lock;
 	struct mm_struct *mm; /* userspace tied to this vm */
+	struct vm_account vm_account;
 	unsigned long nr_memslot_pages;
 	/* The two memslot sets - active and inactive (per address space) */
 	struct kvm_memslots __memslots[KVM_ADDRESS_SPACE_NUM][2];
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 9c60384..770d037 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1142,6 +1142,7 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
 	KVM_MMU_LOCK_INIT(kvm);
 	mmgrab(current->mm);
 	kvm->mm = current->mm;
+	vm_account_init_current(&kvm->vm_account);
 	kvm_eventfd_init(kvm);
 	mutex_init(&kvm->lock);
 	mutex_init(&kvm->irq_lock);
@@ -1258,6 +1259,7 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
 out_err_no_srcu:
 	kvm_arch_free_vm(kvm);
 	mmdrop(current->mm);
+	vm_account_release(&kvm->vm_account);
 	module_put(kvm_chardev_ops.owner);
 	return ERR_PTR(r);
 }
@@ -1327,6 +1329,7 @@ static void kvm_destroy_vm(struct kvm *kvm)
 	preempt_notifier_dec();
 	hardware_disable_all();
 	mmdrop(mm);
+	vm_account_release(&kvm->vm_account);
 	module_put(kvm_chardev_ops.owner);
 }
 
-- 
git-series 0.9.1
