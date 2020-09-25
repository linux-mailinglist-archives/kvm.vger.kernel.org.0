Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BBF127932E
	for <lists+kvm@lfdr.de>; Fri, 25 Sep 2020 23:23:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728171AbgIYVXM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 17:23:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726687AbgIYVXK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Sep 2020 17:23:10 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EF34C0613CE
        for <kvm@vger.kernel.org>; Fri, 25 Sep 2020 14:23:10 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id s4so3254407pgk.17
        for <kvm@vger.kernel.org>; Fri, 25 Sep 2020 14:23:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=Ua7W65/d+eys6TkCdCKyUD20UsOP9zKnnrEciCir1oA=;
        b=Ba8vZCGd6BVlQ3ApTWbLnydXdozDtsK//xKSkkcRq0/GVpiouAAKjNjX7g4wF3RHFh
         cm5pVnHUV72MHz50fFJTsAvMnamSUg8AVwiSAeq5C9/d8lvMDSrVhmJ7zjsVAPZhwAXx
         ok7JapD/Nia/Sd55oRtc2pYiYuZxpbjV6n029qzPHEdB+TcXZ5lhD5rhMQCoVfJ9eDFM
         vyk3DEF8RNUUn4UAgLXIiI54oE+o55wAly4tB+unfNR85PQwZO7r18osoAV7JRb7iY/7
         5HoFJ0A6IIgZGQWwvH97D+IQ9OTkR9YgWOU1suPLe6xQypWfPomWfLrz+3Um8Ful6DUT
         B8MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Ua7W65/d+eys6TkCdCKyUD20UsOP9zKnnrEciCir1oA=;
        b=F7MuyPkKzQbiKweOlAZWD5aK8odXSj0h9lLuNEiuFeHqNBCOWo/BTAWkt2i+LmYdKT
         6ZIt/qeBWKEggHAqHadBqSk8kkt+05Rf76yrD87OELgs+OyaaJyP7v0X1HAlFpkrhsBJ
         xtB5s1FS57HssJpJFktVI2YjCTzVcsag/rGx6gl/0TdF8LEAAW9tzzJmjER5ocCclk45
         wYv2H76ryhOWEdizXwF7h9WHwYEdPSWxfz4L2qQvaA9EWyqXqZj+lxL98Yo5HBoOR8Xt
         cw2quOsmGWcL8JhMMQ0Bo50yx1fyGwgxCBohDlLVAUMZ82ZAHN4mnBnoFgMppy1xsiwk
         AXCA==
X-Gm-Message-State: AOAM5338+rDQllQiiaHg1FI+D7HnvhPa5NqvGVgH5R+2Z4Z2co6wHHI0
        mUGxBfU4CJb9XCh6qMD86+Z3p2tAapD1
X-Google-Smtp-Source: ABdhPJwH0e7NUIaLBoXcIY3Ow2PsHnPi1TLNqHlvGwApDUSsvb4M85/q+KEi4+WBsGf9fCmKb47sSKwNYysg
Sender: "bgardon via sendgmr" <bgardon@bgardon.sea.corp.google.com>
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:f693:9fff:fef4:a293])
 (user=bgardon job=sendgmr) by 2002:a17:90a:f298:: with SMTP id
 fs24mr475139pjb.4.1601068990014; Fri, 25 Sep 2020 14:23:10 -0700 (PDT)
Date:   Fri, 25 Sep 2020 14:22:41 -0700
In-Reply-To: <20200925212302.3979661-1-bgardon@google.com>
Message-Id: <20200925212302.3979661-2-bgardon@google.com>
Mime-Version: 1.0
References: <20200925212302.3979661-1-bgardon@google.com>
X-Mailer: git-send-email 2.28.0.709.gb0816b6eb0-goog
Subject: [PATCH 01/22] kvm: mmu: Separate making SPTEs from set_spte
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Cannon Matthews <cannonmatthews@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Separate the functions for generating leaf page table entries from the
function that inserts them into the paging structure. This refactoring
will facilitate changes to the MMU sychronization model to use atomic
compare / exchanges (which are not guaranteed to succeed) instead of a
monolithic MMU lock.

No functional change expected.

Tested by running kvm-unit-tests and KVM selftests on an Intel Haswell
machine. This commit introduced no new failures.

This series can be viewed in Gerrit at:
	https://linux-review.googlesource.com/c/virt/kvm/kvm/+/2538

Signed-off-by: Ben Gardon <bgardon@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 52 +++++++++++++++++++++++++++---------------
 1 file changed, 34 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 71aa3da2a0b7b..81240b558d67f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2971,20 +2971,14 @@ static bool kvm_is_mmio_pfn(kvm_pfn_t pfn)
 #define SET_SPTE_WRITE_PROTECTED_PT	BIT(0)
 #define SET_SPTE_NEED_REMOTE_TLB_FLUSH	BIT(1)
 
-static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
-		    unsigned int pte_access, int level,
-		    gfn_t gfn, kvm_pfn_t pfn, bool speculative,
-		    bool can_unsync, bool host_writable)
+static u64 make_spte(struct kvm_vcpu *vcpu, unsigned int pte_access, int level,
+		     gfn_t gfn, kvm_pfn_t pfn, u64 old_spte, bool speculative,
+		     bool can_unsync, bool host_writable, bool ad_disabled,
+		     int *ret)
 {
 	u64 spte = 0;
-	int ret = 0;
-	struct kvm_mmu_page *sp;
-
-	if (set_mmio_spte(vcpu, sptep, gfn, pfn, pte_access))
-		return 0;
 
-	sp = sptep_to_sp(sptep);
-	if (sp_ad_disabled(sp))
+	if (ad_disabled)
 		spte |= SPTE_AD_DISABLED_MASK;
 	else if (kvm_vcpu_ad_need_write_protect(vcpu))
 		spte |= SPTE_AD_WRPROT_ONLY_MASK;
@@ -3037,27 +3031,49 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 		 * is responsibility of mmu_get_page / kvm_sync_page.
 		 * Same reasoning can be applied to dirty page accounting.
 		 */
-		if (!can_unsync && is_writable_pte(*sptep))
-			goto set_pte;
+		if (!can_unsync && is_writable_pte(old_spte))
+			return spte;
 
 		if (mmu_need_write_protect(vcpu, gfn, can_unsync)) {
 			pgprintk("%s: found shadow page for %llx, marking ro\n",
 				 __func__, gfn);
-			ret |= SET_SPTE_WRITE_PROTECTED_PT;
+			*ret |= SET_SPTE_WRITE_PROTECTED_PT;
 			pte_access &= ~ACC_WRITE_MASK;
 			spte &= ~(PT_WRITABLE_MASK | SPTE_MMU_WRITEABLE);
 		}
 	}
 
-	if (pte_access & ACC_WRITE_MASK) {
-		kvm_vcpu_mark_page_dirty(vcpu, gfn);
+	if (pte_access & ACC_WRITE_MASK)
 		spte |= spte_shadow_dirty_mask(spte);
-	}
 
 	if (speculative)
 		spte = mark_spte_for_access_track(spte);
 
-set_pte:
+	return spte;
+}
+
+static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
+		    unsigned int pte_access, int level,
+		    gfn_t gfn, kvm_pfn_t pfn, bool speculative,
+		    bool can_unsync, bool host_writable)
+{
+	u64 spte = 0;
+	struct kvm_mmu_page *sp;
+	int ret = 0;
+
+	if (set_mmio_spte(vcpu, sptep, gfn, pfn, pte_access))
+		return 0;
+
+	sp = sptep_to_sp(sptep);
+
+	spte = make_spte(vcpu, pte_access, level, gfn, pfn, *sptep, speculative,
+			 can_unsync, host_writable, sp_ad_disabled(sp), &ret);
+	if (!spte)
+		return 0;
+
+	if (spte & PT_WRITABLE_MASK)
+		kvm_vcpu_mark_page_dirty(vcpu, gfn);
+
 	if (mmu_spte_update(sptep, spte))
 		ret |= SET_SPTE_NEED_REMOTE_TLB_FLUSH;
 	return ret;
-- 
2.28.0.709.gb0816b6eb0-goog

