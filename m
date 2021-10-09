Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F19E4275B1
	for <lists+kvm@lfdr.de>; Sat,  9 Oct 2021 04:13:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244189AbhJICOr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Oct 2021 22:14:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244166AbhJICOq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Oct 2021 22:14:46 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCDC5C061764
        for <kvm@vger.kernel.org>; Fri,  8 Oct 2021 19:12:49 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id b9-20020a5b07890000b0290558245b7eabso15002825ybq.10
        for <kvm@vger.kernel.org>; Fri, 08 Oct 2021 19:12:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=VOf0o+drOoyjtnZHAjwPMyY2QgjmuejeI8ZGvk5qQh8=;
        b=c594JBXBzlzJm/B4MJiuak37F10cOGqzZRDRYYkHvGtg+tYhi9bkpT7HAvzA4a7CrO
         wY9eJk+8SXC6VXSYxm/HtIH7HCqw4WmraTlKbDvDXkb0ieGHnQEdhLp9SHTOoF1D+ihb
         l0NC5UfvB9mBvn0GShFPrhMJGBfjxpiBY5BrX5s0xEdDxmIpWuxZBBx29TlMmh0JGg0R
         lof8oMgaYbwVizPYN+9qQPXHfvL56RO9ccLyp7IYNiT8OQ7d02343dCZy83nOSQGhHOM
         xfDcm3J7v9Zaqb3Cv7KhQ0mVfu7vqET/6w/svCdKYDLPxqzAsRNGhLifWQMr9xoyFcPL
         LUIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=VOf0o+drOoyjtnZHAjwPMyY2QgjmuejeI8ZGvk5qQh8=;
        b=q3Y3RajpnyvHbQWhFnc+6fNqxKNfs+2ui3TQT5JmKnJj67A/ilMwEKiCfoYxNWvGJE
         OEAOCZpiNuZBXM3NNSxTRiK4GE2IABYTZOl23eET0vhmM1EunKuR7RO51znz5p69hOZc
         yMm3WWGnhFYPL0h7ElUwTPnohZ4RStO0gRMJ1fZfhpVfjHSMpD5AY1AdZbDWjCXcks8i
         syZiUE/vSnwCwmigPtkJpNhLpZKU2TpFGtLxmkwWl2Im2zpXjpjcdtaeeAveHLxk3Dx2
         zNYN8mFrr7wMate9jRegu/ulbSlF28HYjGEaQYC+97H/PUqwD2Q5a4AmliSxbio4OYPZ
         Mpzg==
X-Gm-Message-State: AOAM530rCqDYcRuBBq57Xx/IFjpbBkHNuslzSu3JphhhdC7B9YpWJtmj
        jBHIuIKMNzlmpPExrlHf0ZeWlok5E9o=
X-Google-Smtp-Source: ABdhPJzvUj+lYxE1uvv63+XvvDPeheCH+oyqg89jaLQyiP8PVpc/MK53zetbWHLCR1OXSf8DRfROgUDiyR0=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:e39b:6333:b001:cb])
 (user=seanjc job=sendgmr) by 2002:a25:d915:: with SMTP id q21mr7203996ybg.17.1633745569082;
 Fri, 08 Oct 2021 19:12:49 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  8 Oct 2021 19:11:56 -0700
In-Reply-To: <20211009021236.4122790-1-seanjc@google.com>
Message-Id: <20211009021236.4122790-4-seanjc@google.com>
Mime-Version: 1.0
References: <20211009021236.4122790-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v2 03/43] KVM: s390: Ensure kvm_arch_no_poll() is read once
 when blocking vCPU
From:   Sean Christopherson <seanjc@google.com>
To:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Atish Patra <atish.patra@wdc.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Wrap s390's halt_poll_max_steal with READ_ONCE and snapshot the result of
kvm_arch_no_poll() in kvm_vcpu_block() to avoid a mostly-theoretical,
largely benign bug on s390 where the result of kvm_arch_no_poll() could
change due to userspace modifying halt_poll_max_steal while the vCPU is
blocking.  The bug is largely benign as it will either cause KVM to skip
updating halt-polling times (no_poll toggles false=>true) or to update
halt-polling times with a slightly flawed block_ns.

Note, READ_ONCE is unnecessary in the current code, add it in case the
arch hook is ever inlined, and to provide a hint that userspace can
change the param at will.

Fixes: 8b905d28ee17 ("KVM: s390: provide kvm_arch_no_poll function")
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/s390/kvm/kvm-s390.c | 2 +-
 virt/kvm/kvm_main.c      | 5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 6a6dd5e1daf6..7cabe6778b1b 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -3446,7 +3446,7 @@ bool kvm_arch_no_poll(struct kvm_vcpu *vcpu)
 {
 	/* do not poll with more than halt_poll_max_steal percent of steal time */
 	if (S390_lowcore.avg_steal_timer * 100 / (TICK_USEC << 12) >=
-	    halt_poll_max_steal) {
+	    READ_ONCE(halt_poll_max_steal)) {
 		vcpu->stat.halt_no_poll_steal++;
 		return true;
 	}
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 3f6d450355f0..7bc38549487e 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3213,6 +3213,7 @@ update_halt_poll_stats(struct kvm_vcpu *vcpu, u64 poll_ns, bool waited)
  */
 void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 {
+	bool halt_poll_allowed = !kvm_arch_no_poll(vcpu);
 	ktime_t start, cur, poll_end;
 	bool waited = false;
 	u64 block_ns;
@@ -3220,7 +3221,7 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 	kvm_arch_vcpu_blocking(vcpu);
 
 	start = cur = poll_end = ktime_get();
-	if (vcpu->halt_poll_ns && !kvm_arch_no_poll(vcpu)) {
+	if (vcpu->halt_poll_ns && halt_poll_allowed) {
 		ktime_t stop = ktime_add_ns(ktime_get(), vcpu->halt_poll_ns);
 
 		++vcpu->stat.generic.halt_attempted_poll;
@@ -3275,7 +3276,7 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 	update_halt_poll_stats(
 		vcpu, ktime_to_ns(ktime_sub(poll_end, start)), waited);
 
-	if (!kvm_arch_no_poll(vcpu)) {
+	if (halt_poll_allowed) {
 		if (!vcpu_valid_wakeup(vcpu)) {
 			shrink_halt_poll_ns(vcpu);
 		} else if (vcpu->kvm->max_halt_poll_ns) {
-- 
2.33.0.882.g93a45727a2-goog

