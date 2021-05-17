Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9533E382E19
	for <lists+kvm@lfdr.de>; Mon, 17 May 2021 16:01:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237584AbhEQOCn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 May 2021 10:02:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237568AbhEQOCi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 May 2021 10:02:38 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77BCDC061756;
        Mon, 17 May 2021 07:01:21 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id 27so3416715pgy.3;
        Mon, 17 May 2021 07:01:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=OXpOhNWfIpuhpnHdPJrluE5Py5GUd57HQ7WW+PgXS2c=;
        b=ajL8VZkyPWHRi81eL4m4qbx/XsNbUiH/XOIqcU9VNghE0X8fkTeVlF8Q5rgmQBb9mx
         WeSoobDW7gQ2QXTgFE8iy+Uy+AnPcmuDU5J+86toTiU28EjGs0Wyczr1kCRGIex8awP0
         6IBYMfWUrNCZHQ0+6BeQOo0lFfJuWTQazVCm6cOGR4m5qNa6B944km18Mfr9ptqmZ6PU
         QG8Gb6ikoUgFmDYDT8J+0VhBapuj38UxDEFLn86hrdCjBL3/kQQ4XyhoFrRJ2lkAYAT1
         dzpAvPz6sr0D7XJRCwd8HUROK1P3tZCoLq9KfjstjvpjZzS7lV1kGh1TPflhdI/7axyO
         E94A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=OXpOhNWfIpuhpnHdPJrluE5Py5GUd57HQ7WW+PgXS2c=;
        b=eFrBCw4iaHxh/s4IAIunVoUFx/56zBZIsQZuPMpv/pLmA0txvh3GM+inOb6aqg8SWm
         7PxTyjyf+oUgGaVdWagv0OzkK/mwXBnGilAnvo3p1T2/VtSfwNwbLk0A0ckbPxeOD5YM
         iX1q+j7HCSODkrlcfIqkpMe3g4sKiggwyrGLjMXwdt689AuqyvthcDhDEJ7Ixt5MYo+A
         HjbNSGvQpL16m5V8ohm+neIqf0vNoR65IRpXhQwZ/0R/p6RWNUx9daBaEQjJ8HXVhlDT
         CLJx7qHRN3TZ7pbCewGDOrl7JUFNMIhKbvOqzynOecm5eMVwBl8LelEnKgzxhozjwXF/
         5a1A==
X-Gm-Message-State: AOAM533XtuW84s3KOS0/VpypdlhxkQEDR4ivsKmPk8kTG/lugRjVyxET
        cSd47484g8HJOv8Wa+8FY6Own07/Ss4=
X-Google-Smtp-Source: ABdhPJwHxSzExHpL+57mfMVKEs8ePvUwo63gs+VDRh9qqggeYBWmNPE1HPIzDUpx8Ac16na1HngHlw==
X-Received: by 2002:a65:5bc6:: with SMTP id o6mr993570pgr.364.1621260080787;
        Mon, 17 May 2021 07:01:20 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.61])
        by smtp.googlemail.com with ESMTPSA id k10sm3074229pfu.175.2021.05.17.07.01.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 May 2021 07:01:20 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Ben Segall <bsegall@google.com>,
        Venkatesh Srinivas <venkateshs@chromium.org>,
        David Matlack <dmatlack@google.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Suraj Jitindar Singh <sjitindarsingh@gmail.com>
Subject: [PATCH v3 1/5] KVM: exit halt polling on need_resched() for both book3s and generic halt-polling
Date:   Mon, 17 May 2021 07:00:24 -0700
Message-Id: <1621260028-6467-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Inspired by commit 262de4102c7bb8 (kvm: exit halt polling on need_resched()
as well), CFS_BANDWIDTH throttling will use resched_task() when there is just
one task to get the task to block. It was likely allowing VMs to overrun their
quota when halt polling. Due to PPC implements an arch specific halt polling
logic, we should add the need_resched() checking there as well. This
patch adds a helper function that to be shared between book3s and generic
halt-polling loop.

Cc: Ben Segall <bsegall@google.com>
Cc: Venkatesh Srinivas <venkateshs@chromium.org>
Cc: Jim Mattson <jmattson@google.com> 
Cc: David Matlack <dmatlack@google.com>
Cc: Paul Mackerras <paulus@ozlabs.org>
Cc: Suraj Jitindar Singh <sjitindarsingh@gmail.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
v2 -> v3:
 * add a helper function
v1 -> v2:
 * update patch description

 arch/powerpc/kvm/book3s_hv.c | 2 +-
 include/linux/kvm_host.h     | 2 ++
 virt/kvm/kvm_main.c          | 9 +++++++--
 3 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 28a80d240b76..360165df345b 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3936,7 +3936,7 @@ static void kvmppc_vcore_blocked(struct kvmppc_vcore *vc)
 				break;
 			}
 			cur = ktime_get();
-		} while (single_task_running() && ktime_before(cur, stop));
+		} while (kvm_vcpu_can_block(cur, stop));
 
 		spin_lock(&vc->lock);
 		vc->vcore_state = VCORE_INACTIVE;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 2f34487e21f2..bf4fd60c4699 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1583,4 +1583,6 @@ static inline void kvm_handle_signal_exit(struct kvm_vcpu *vcpu)
 /* Max number of entries allowed for each kvm dirty ring */
 #define  KVM_DIRTY_RING_MAX_ENTRIES  65536
 
+bool kvm_vcpu_can_block(ktime_t cur, ktime_t stop);
+
 #endif
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 6b4feb92dc79..c81080667fd1 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2945,6 +2945,12 @@ update_halt_poll_stats(struct kvm_vcpu *vcpu, u64 poll_ns, bool waited)
 		vcpu->stat.halt_poll_success_ns += poll_ns;
 }
 
+
+bool kvm_vcpu_can_block(ktime_t cur, ktime_t stop)
+{
+	return single_task_running() && !need_resched() && ktime_before(cur, stop);
+}
+
 /*
  * The vCPU has executed a HLT instruction with in-kernel mode enabled.
  */
@@ -2973,8 +2979,7 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 				goto out;
 			}
 			poll_end = cur = ktime_get();
-		} while (single_task_running() && !need_resched() &&
-			 ktime_before(cur, stop));
+		} while (kvm_vcpu_can_block(cur, stop));
 	}
 
 	prepare_to_rcuwait(&vcpu->wait);
-- 
2.25.1

