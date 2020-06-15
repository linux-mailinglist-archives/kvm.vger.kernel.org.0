Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E58111FA3E0
	for <lists+kvm@lfdr.de>; Tue, 16 Jun 2020 01:07:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbgFOXH5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jun 2020 19:07:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725960AbgFOXH5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jun 2020 19:07:57 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0234BC061A0E
        for <kvm@vger.kernel.org>; Mon, 15 Jun 2020 16:07:57 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id h18so15502420qkj.13
        for <kvm@vger.kernel.org>; Mon, 15 Jun 2020 16:07:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=xcoRC3ukd3JVnqlPGdKawsU/brIQlrTI1XM8BxAKzo0=;
        b=qNvgE9pA0YdBpFN8P5+egecHo526fpmt4Uq5HFPR05TM3ek+tBUrzY5I8/GhaFUmqX
         W5+Y3ispf43Wy5mGsPVD376WYegQvJZIC+fGK+DRmDIBcpRP5L6iiA5mALQzocGKULRi
         aHdDBgVE68TvwuTLKapsXEY9ma3QjdBv5t3x8ehV6JV6JznyPyfV+QxE0iPJzXa8hqN+
         ZHsgDwftz6xx9FBwL9AD059zyFWG/yWEwWbGXL6z7PfuPWV9zrogxR480iPmE4W3rtyT
         3V9U6Xsh6bIRFeKjdeKLwEV4DiybfJyvYr6eKOjUBPqNWxywWj1G9V4EbGMVGLzU2gLK
         4EMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=xcoRC3ukd3JVnqlPGdKawsU/brIQlrTI1XM8BxAKzo0=;
        b=FXZnRkHKZwdxwq85FyIrxgYEgi97x8BvkxAaQV0RZP+qmrTKh0HYXKsjyG5jwd6u9R
         vCrx4/SXZn/gcn/N/ivverFoKCME34F+AlxlATJHbPGX+0Zc5ojoB5TbKMg8E4zhu2HS
         FNjnkFavlMIlqoDdzWk3vPTUvRpJ6R0rZK/MtZPMSyBYXGq8aK2UeI7WSTZp+TBFPdHJ
         cdDhH6AGXPSuRw4vL9vqSe68t2kKbIbAh4E1ll8fH41ktRfQu8tv0k/c6gRHf4Hop6eq
         evUHcYGdDmvuJGGW97ZmIKFmMZnluhvmHbThvGtiGy7MhrbfhwS6W6780Zu7cHQGHi4Z
         c6Zw==
X-Gm-Message-State: AOAM5303SrfEGzC+o/7C5JQ0Sssvp/mQtPmItWGG8HWN8pnmg+1ubCAN
        yZU6ae2XnIZiwxQJGWItOj9IoGPOOdIM5WJ06o7/wKnoFUvS/Ex89YtNkEh7w1JqGdKa/FPDT21
        rLBOmic3jTtxmHu++ZJqM5ax9UF8+oduyJgUd1T58k5LnmKlCCKD4YT4bOns1iWc=
X-Google-Smtp-Source: ABdhPJy7/o7amkHHEBR+jxgFfk29OJ/uSYG4K0BSuLhWRqEMXkXcD7V3eNPH7A2RdX2rL1zYdGwXX/z69lxehw==
X-Received: by 2002:a05:6214:10e1:: with SMTP id q1mr84631qvt.78.1592262476058;
 Mon, 15 Jun 2020 16:07:56 -0700 (PDT)
Date:   Mon, 15 Jun 2020 16:07:49 -0700
Message-Id: <20200615230750.105008-1-jmattson@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.27.0.290.gba653c62da-goog
Subject: [PATCH 1/2] kvm: x86: Refine kvm_write_tsc synchronization generations
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Start a new TSC synchronization generation whenever the
IA32_TIME_STAMP_COUNTER MSR is written on a vCPU that has already
participated in the current TSC synchronization generation.

Previously, it was not possible to restore the IA32_TIME_STAMP_COUNTER
MSR to a value less than the TSC frequency. Since vCPU initialization
sets the IA32_TIME_STAMP_COUNTER MSR to zero, a subsequent
KVM_SET_MSRS ioctl that attempted to write a small value to the
IA32_TIME_STAMP_COUNTER MSR was viewed as an attempt at TSC
synchronization. Notably, this was the case even for single vCPU VMs,
which were always synchronized.

Signed-off-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
Reviewed-by: Oliver Upton <oupton@google.com>
---
 arch/x86/kvm/x86.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9e41b5135340..2555ea2cd91e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2015,7 +2015,6 @@ void kvm_write_tsc(struct kvm_vcpu *vcpu, struct msr_data *msr)
 	u64 offset, ns, elapsed;
 	unsigned long flags;
 	bool matched;
-	bool already_matched;
 	u64 data = msr->data;
 	bool synchronizing = false;
 
@@ -2032,7 +2031,8 @@ void kvm_write_tsc(struct kvm_vcpu *vcpu, struct msr_data *msr)
 			 * kvm_clock stable after CPU hotplug
 			 */
 			synchronizing = true;
-		} else {
+		} else if (vcpu->arch.this_tsc_generation !=
+			   kvm->arch.cur_tsc_generation) {
 			u64 tsc_exp = kvm->arch.last_tsc_write +
 						nsec_to_cycles(vcpu, elapsed);
 			u64 tsc_hz = vcpu->arch.virtual_tsc_khz * 1000LL;
@@ -2062,7 +2062,6 @@ void kvm_write_tsc(struct kvm_vcpu *vcpu, struct msr_data *msr)
 			offset = kvm_compute_tsc_offset(vcpu, data);
 		}
 		matched = true;
-		already_matched = (vcpu->arch.this_tsc_generation == kvm->arch.cur_tsc_generation);
 	} else {
 		/*
 		 * We split periods of matched TSC writes into generations.
@@ -2102,12 +2101,10 @@ void kvm_write_tsc(struct kvm_vcpu *vcpu, struct msr_data *msr)
 	raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);
 
 	spin_lock(&kvm->arch.pvclock_gtod_sync_lock);
-	if (!matched) {
-		kvm->arch.nr_vcpus_matched_tsc = 0;
-	} else if (!already_matched) {
+	if (matched)
 		kvm->arch.nr_vcpus_matched_tsc++;
-	}
-
+	else
+		kvm->arch.nr_vcpus_matched_tsc = 0;
 	kvm_track_tsc_matching(vcpu);
 	spin_unlock(&kvm->arch.pvclock_gtod_sync_lock);
 }
-- 
2.27.0.290.gba653c62da-goog

