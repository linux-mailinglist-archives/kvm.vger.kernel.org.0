Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28D34630DE5
	for <lists+kvm@lfdr.de>; Sat, 19 Nov 2022 10:47:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233903AbiKSJrL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 19 Nov 2022 04:47:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230424AbiKSJrJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 19 Nov 2022 04:47:09 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54722A8C17
        for <kvm@vger.kernel.org>; Sat, 19 Nov 2022 01:47:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=Rygr6uyOPlrDnMmK7Se6ONCtNZIVfB+UvwZcwGtTHqY=; b=aDSUktBOT+1geBJADUeMWae66A
        RIYafyunV9EmbqsE0cIrv17KiEY9ToithzQysuxS0zieonhmscDcPthmg4GWZnJV5iZYdLkq48Xo7
        S5g4b37Ba857DyFIWieDjF47uafaOQkKKeIXJI/qi/Fqc/8BXrR8NZtjvzQd2ZZkKDRRsZD/S8FuV
        zPm+iXJ8c18zeJRG4zomjJ0DNGzFaRfaSuJVBrp4DQVRSQ7nZ3oLvghVmI7cDNGMGzh5cAW1Hmnl4
        xcTg0o3W6fjrAdgJXpdAw0ptoTNsZdRP2EPkYuoILmwQaawW9zXZKhzWMttlHsdBnt3Df8gQLiSJC
        mhuMXHBg==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1owKR9-002Hui-WA; Sat, 19 Nov 2022 09:47:01 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1owKR9-00035q-Nm; Sat, 19 Nov 2022 09:46:59 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, mhal@rbox.co
Subject: [PATCH 4/4] KVM: x86/xen: Add runstate tests for 32-bit mode and crossing page boundary
Date:   Sat, 19 Nov 2022 09:46:59 +0000
Message-Id: <20221119094659.11868-4-dwmw2@infradead.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20221119094659.11868-1-dwmw2@infradead.org>
References: <20221119094659.11868-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

Torture test the cases where the runstate crosses a page boundary, and
and especially the case where it's configured in 32-bit mode and doesn't,
but then switching to 64-bit mode makes it go onto the second page.

To simplify this, make the KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_ADJUST ioctl
also update the guest runstate area. It already did so if the actual
runstate changed, as a side-effect of kvm_xen_update_runstate(). So
doing it in the plain adjustment case is making it more consistent, as
well as giving us a nice way to trigger the update without actually
running the vCPU again and changing the values.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/kvm/xen.c                            |   2 +
 .../selftests/kvm/x86_64/xen_shinfo_test.c    | 115 +++++++++++++++---
 2 files changed, 97 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 8aa953b1f0e0..747dc347c70e 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -848,6 +848,8 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
 
 		if (data->u.runstate.state <= RUNSTATE_offline)
 			kvm_xen_update_runstate(vcpu, data->u.runstate.state);
+		else if (vcpu->arch.xen.runstate_cache.active)
+			kvm_xen_update_runstate_guest(vcpu, false);
 		r = 0;
 		break;
 
diff --git a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
index 7f39815f1772..1f4fd97db959 100644
--- a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
@@ -88,14 +88,20 @@ struct pvclock_wall_clock {
 } __attribute__((__packed__));
 
 struct vcpu_runstate_info {
-    uint32_t state;
-    uint64_t state_entry_time;
-    uint64_t time[4];
+	uint32_t state;
+	uint64_t state_entry_time;
+	uint64_t time[5]; /* Extra field for overrun check */
 };
 
+struct compat_vcpu_runstate_info {
+	uint32_t state;
+	uint64_t state_entry_time;
+	uint64_t time[5];
+} __attribute__((__packed__));;
+
 struct arch_vcpu_info {
-    unsigned long cr2;
-    unsigned long pad; /* sizeof(vcpu_info_t) == 64 */
+	unsigned long cr2;
+	unsigned long pad; /* sizeof(vcpu_info_t) == 64 */
 };
 
 struct vcpu_info {
@@ -999,22 +1005,91 @@ int main(int argc, char *argv[])
 				       runstate_names[i], rs->time[i]);
 			}
 		}
-		TEST_ASSERT(rs->state == rst.u.runstate.state, "Runstate mismatch");
-		TEST_ASSERT(rs->state_entry_time == rst.u.runstate.state_entry_time,
-			    "State entry time mismatch");
-		TEST_ASSERT(rs->time[RUNSTATE_running] == rst.u.runstate.time_running,
-			    "Running time mismatch");
-		TEST_ASSERT(rs->time[RUNSTATE_runnable] == rst.u.runstate.time_runnable,
-			    "Runnable time mismatch");
-		TEST_ASSERT(rs->time[RUNSTATE_blocked] == rst.u.runstate.time_blocked,
-			    "Blocked time mismatch");
-		TEST_ASSERT(rs->time[RUNSTATE_offline] == rst.u.runstate.time_offline,
-			    "Offline time mismatch");
-
-		TEST_ASSERT(rs->state_entry_time == rs->time[0] +
-			    rs->time[1] + rs->time[2] + rs->time[3],
-			    "runstate times don't add up");
+
+		/*
+		 * Exercise runstate info at all points across the page boundary, in
+		 * 32-bit and 64-bit mode. In particular, test the case where it is
+		 * configured in 32-bit mode and then switched to 64-bit mode while
+		 * active, which takes it onto the second page.
+		 */
+		unsigned long runstate_addr;
+		struct compat_vcpu_runstate_info *crs;
+		for (runstate_addr = SHINFO_REGION_GPA + PAGE_SIZE + PAGE_SIZE - sizeof(*rs) - 4;
+		     runstate_addr < SHINFO_REGION_GPA + PAGE_SIZE + PAGE_SIZE + 4; runstate_addr++) {
+
+			rs = addr_gpa2hva(vm, runstate_addr);
+			crs = (void *)rs;
+
+			memset(rs, 0xa5, sizeof(*rs));
+
+			/* Set to compatibility mode */
+			lm.u.long_mode = 0;
+			vm_ioctl(vm, KVM_XEN_HVM_SET_ATTR, &lm);
+
+			/* Set runstate to new address (kernel will write it) */
+			struct kvm_xen_vcpu_attr st = {
+				.type = KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_ADDR,
+				.u.gpa = runstate_addr,
+			};
+			vcpu_ioctl(vcpu, KVM_XEN_VCPU_SET_ATTR, &st);
+
+			if (verbose)
+				printf("Compatibility runstate at %08lx\n", runstate_addr);
+
+			TEST_ASSERT(crs->state == rst.u.runstate.state, "Runstate mismatch");
+			TEST_ASSERT(crs->state_entry_time == rst.u.runstate.state_entry_time,
+				    "State entry time mismatch");
+			TEST_ASSERT(crs->time[RUNSTATE_running] == rst.u.runstate.time_running,
+				    "Running time mismatch");
+			TEST_ASSERT(crs->time[RUNSTATE_runnable] == rst.u.runstate.time_runnable,
+				    "Runnable time mismatch");
+			TEST_ASSERT(crs->time[RUNSTATE_blocked] == rst.u.runstate.time_blocked,
+				    "Blocked time mismatch");
+			TEST_ASSERT(crs->time[RUNSTATE_offline] == rst.u.runstate.time_offline,
+				    "Offline time mismatch");
+			TEST_ASSERT(crs->time[RUNSTATE_offline + 1] == 0xa5a5a5a5a5a5a5a5ULL,
+				    "Structure overrun");
+			TEST_ASSERT(crs->state_entry_time == crs->time[0] +
+				    crs->time[1] + crs->time[2] + crs->time[3],
+				    "runstate times don't add up");
+
+
+			/* Now switch to 64-bit mode */
+			lm.u.long_mode = 1;
+			vm_ioctl(vm, KVM_XEN_HVM_SET_ATTR, &lm);
+
+			memset(rs, 0xa5, sizeof(*rs));
+
+			/* Don't change the address, just trigger a write */
+			struct kvm_xen_vcpu_attr adj = {
+				.type = KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_ADJUST,
+				.u.runstate.state = (uint64_t)-1
+			};
+			vcpu_ioctl(vcpu, KVM_XEN_VCPU_SET_ATTR, &adj);
+
+			if (verbose)
+				printf("64-bit runstate at %08lx\n", runstate_addr);
+
+			TEST_ASSERT(rs->state == rst.u.runstate.state, "Runstate mismatch");
+			TEST_ASSERT(rs->state_entry_time == rst.u.runstate.state_entry_time,
+				    "State entry time mismatch");
+			TEST_ASSERT(rs->time[RUNSTATE_running] == rst.u.runstate.time_running,
+				    "Running time mismatch");
+			TEST_ASSERT(rs->time[RUNSTATE_runnable] == rst.u.runstate.time_runnable,
+				    "Runnable time mismatch");
+			TEST_ASSERT(rs->time[RUNSTATE_blocked] == rst.u.runstate.time_blocked,
+				    "Blocked time mismatch");
+			TEST_ASSERT(rs->time[RUNSTATE_offline] == rst.u.runstate.time_offline,
+				    "Offline time mismatch");
+			TEST_ASSERT(rs->time[RUNSTATE_offline + 1] == 0xa5a5a5a5a5a5a5a5ULL,
+				    "Structure overrun");
+
+			TEST_ASSERT(rs->state_entry_time == rs->time[0] +
+				    rs->time[1] + rs->time[2] + rs->time[3],
+				    "runstate times don't add up");
+		}
 	}
+
 	kvm_vm_free(vm);
 	return 0;
 }
-- 
2.35.3

