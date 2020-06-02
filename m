Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 982791EC37A
	for <lists+kvm@lfdr.de>; Tue,  2 Jun 2020 22:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728372AbgFBUJE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jun 2020 16:09:04 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:52364 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728304AbgFBUJD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Jun 2020 16:09:03 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 052Jw0Ew163040;
        Tue, 2 Jun 2020 20:07:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=y/OdzxZwiVwo/FlqUUNmqvD8ltVeZT1qJE9sRiVtvAU=;
 b=ufhnpC2+71pmQ4EFvqye4K6P11PDUAWlochhay9WkjOLjPxix0MpMpLETPr15W9r0SSI
 /iMR1pc84O6ohAy5DGLSYgcqiZ1NUfX+1IDNWLfiyDlJKSp2LbcxSzr5B7st6YPGLlVl
 2R6M8xWGtEbfZMKUwGZsqB6rmV1uF9lxBvnSDdNew329IGq2niFTH2BpYTg/xEIMFktV
 ZIJCtCxTkEXrXGNF1M85kEGDdpabnMXGdbb8xvFTnQ7WcMDkVmz9As3DfwFzbUvvmb+4
 a7SxIULE9bBQ0JBWBWczFbOA/03XJau/PMlK0QDO43jzQiOdTD6nMLMYdv+RPZxK7lEC Rg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 31bewqwy9y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 02 Jun 2020 20:07:42 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 052JxHKu135212;
        Tue, 2 Jun 2020 20:07:42 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 31c1dxtrmv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Jun 2020 20:07:42 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 052K7eql022850;
        Tue, 2 Jun 2020 20:07:41 GMT
Received: from ayz-linux.us.oracle.com (/10.154.185.88)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 02 Jun 2020 13:07:40 -0700
From:   Anthony Yznaga <anthony.yznaga@oracle.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     pbonzini@redhat.com, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        steven.sistare@oracle.com, anthony.yznaga@oracle.com
Subject: [PATCH 3/3] KVM: x86: minor code refactor and comments fixup around dirty logging
Date:   Tue,  2 Jun 2020 13:07:30 -0700
Message-Id: <1591128450-11977-4-git-send-email-anthony.yznaga@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1591128450-11977-1-git-send-email-anthony.yznaga@oracle.com>
References: <1591128450-11977-1-git-send-email-anthony.yznaga@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9640 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 spamscore=0 bulkscore=0 adultscore=0 suspectscore=2 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006020146
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9640 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 bulkscore=0
 phishscore=0 suspectscore=2 impostorscore=0 cotscore=-2147483648
 lowpriorityscore=0 mlxscore=0 adultscore=0 spamscore=0 mlxlogscore=999
 malwarescore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006020146
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Consolidate the code and correct the comments to show that the actions
taken to update existing mappings to disable or enable dirty logging
are not necessary when creating, moving, or deleting a memslot.

Signed-off-by: Anthony Yznaga <anthony.yznaga@oracle.com>
---
 arch/x86/kvm/x86.c | 104 +++++++++++++++++++++++++----------------------------
 1 file changed, 49 insertions(+), 55 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d211c8ced6bb..1e70d188d83a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10036,41 +10036,65 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 }
 
 static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
-				     struct kvm_memory_slot *new)
+				     struct kvm_memory_slot *old,
+				     struct kvm_memory_slot *new,
+				     enum kvm_mr_change change)
 {
-	/* Nothing to do for RO slots */
-	if (new->flags & KVM_MEM_READONLY)
+	/*
+	 * Nothing to do for RO slots or CREATE/MOVE/DELETE of a slot.
+	 * See comments below.
+	 */
+	if ((change != KVM_MR_FLAGS_ONLY) || (new->flags & KVM_MEM_READONLY))
 		return;
 
 	/*
-	 * Call kvm_x86_ops dirty logging hooks when they are valid.
-	 *
-	 * kvm_x86_ops.slot_disable_log_dirty is called when:
-	 *
-	 *  - KVM_MR_CREATE with dirty logging is disabled
-	 *  - KVM_MR_FLAGS_ONLY with dirty logging is disabled in new flag
-	 *
-	 * The reason is, in case of PML, we need to set D-bit for any slots
-	 * with dirty logging disabled in order to eliminate unnecessary GPA
-	 * logging in PML buffer (and potential PML buffer full VMEXIT). This
-	 * guarantees leaving PML enabled during guest's lifetime won't have
-	 * any additional overhead from PML when guest is running with dirty
-	 * logging disabled for memory slots.
+	 * Dirty logging tracks sptes in 4k granularity, meaning that large
+	 * sptes have to be split.  If live migration is successful, the guest
+	 * in the source machine will be destroyed and large sptes will be
+	 * created in the destination. However, if the guest continues to run
+	 * in the source machine (for example if live migration fails), small
+	 * sptes will remain around and cause bad performance.
 	 *
-	 * kvm_x86_ops.slot_enable_log_dirty is called when switching new slot
-	 * to dirty logging mode.
+	 * Scan sptes if dirty logging has been stopped, dropping those
+	 * which can be collapsed into a single large-page spte.  Later
+	 * page faults will create the large-page sptes.
 	 *
-	 * If kvm_x86_ops dirty logging hooks are invalid, use write protect.
+	 * There is no need to do this in any of the following cases:
+	 * CREATE:      No dirty mappings will already exist.
+	 * MOVE/DELETE: The old mappings will already have been cleaned up by
+	 *		kvm_arch_flush_shadow_memslot()
+	 */
+	if ((old->flags & KVM_MEM_LOG_DIRTY_PAGES) &&
+	    !(new->flags & KVM_MEM_LOG_DIRTY_PAGES))
+		kvm_mmu_zap_collapsible_sptes(kvm, new);
+
+	/*
+	 * Enable or disable dirty logging for the slot.
 	 *
-	 * In case of write protect:
+	 * For KVM_MR_DELETE and KVM_MR_MOVE, the shadow pages of the old
+	 * slot have been zapped so no dirty logging updates are needed for
+	 * the old slot.
+	 * For KVM_MR_CREATE and KVM_MR_MOVE, once the new slot is visible
+	 * any mappings that might be created in it will consume the
+	 * properties of the new slot and do not need to be updated here.
 	 *
-	 * Write protect all pages for dirty logging.
+	 * When PML is enabled, the kvm_x86_ops dirty logging hooks are
+	 * called to enable/disable dirty logging.
 	 *
-	 * All the sptes including the large sptes which point to this
-	 * slot are set to readonly. We can not create any new large
-	 * spte on this slot until the end of the logging.
+	 * When disabling dirty logging with PML enabled, the D-bit is set
+	 * for sptes in the slot in order to prevent unnecessary GPA
+	 * logging in the PML buffer (and potential PML buffer full VMEXIT).
+	 * This guarantees leaving PML enabled for the guest's lifetime
+	 * won't have any additional overhead from PML when the guest is
+	 * running with dirty logging disabled.
 	 *
+	 * When enabling dirty logging, large sptes are write-protected
+	 * so they can be split on first write.  New large sptes cannot
+	 * be created for this slot until the end of the logging.
 	 * See the comments in fast_page_fault().
+	 * For small sptes, nothing is done if the dirty log is in the
+	 * initial-all-set state.  Otherwise, depending on whether pml
+	 * is enabled the D-bit or the W-bit will be cleared.
 	 */
 	if (new->flags & KVM_MEM_LOG_DIRTY_PAGES) {
 		if (kvm_x86_ops.slot_enable_log_dirty) {
@@ -10107,39 +10131,9 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 				kvm_mmu_calculate_default_mmu_pages(kvm));
 
 	/*
-	 * Dirty logging tracks sptes in 4k granularity, meaning that large
-	 * sptes have to be split.  If live migration is successful, the guest
-	 * in the source machine will be destroyed and large sptes will be
-	 * created in the destination. However, if the guest continues to run
-	 * in the source machine (for example if live migration fails), small
-	 * sptes will remain around and cause bad performance.
-	 *
-	 * Scan sptes if dirty logging has been stopped, dropping those
-	 * which can be collapsed into a single large-page spte.  Later
-	 * page faults will create the large-page sptes.
-	 *
-	 * There is no need to do this in any of the following cases:
-	 * CREATE:	No dirty mappings will already exist.
-	 * MOVE/DELETE:	The old mappings will already have been cleaned up by
-	 *		kvm_arch_flush_shadow_memslot()
-	 */
-	if (change == KVM_MR_FLAGS_ONLY &&
-		(old->flags & KVM_MEM_LOG_DIRTY_PAGES) &&
-		!(new->flags & KVM_MEM_LOG_DIRTY_PAGES))
-		kvm_mmu_zap_collapsible_sptes(kvm, new);
-
-	/*
-	 * Set up write protection and/or dirty logging for the new slot.
-	 *
-	 * For KVM_MR_DELETE and KVM_MR_MOVE, the shadow pages of old slot have
-	 * been zapped so no dirty logging staff is needed for old slot. For
-	 * KVM_MR_FLAGS_ONLY, the old slot is essentially the same one as the
-	 * new and it's also covered when dealing with the new slot.
-	 *
 	 * FIXME: const-ify all uses of struct kvm_memory_slot.
 	 */
-	if (change == KVM_MR_FLAGS_ONLY)
-		kvm_mmu_slot_apply_flags(kvm, (struct kvm_memory_slot *) new);
+	kvm_mmu_slot_apply_flags(kvm, old, (struct kvm_memory_slot *) new, change);
 
 	/* Free the arrays associated with the old memslot. */
 	if (change == KVM_MR_MOVE)
-- 
2.13.3

