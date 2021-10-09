Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58A424275BE
	for <lists+kvm@lfdr.de>; Sat,  9 Oct 2021 04:13:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244198AbhJICOz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Oct 2021 22:14:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244237AbhJICOx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Oct 2021 22:14:53 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7C3EC061570
        for <kvm@vger.kernel.org>; Fri,  8 Oct 2021 19:12:57 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id bk9-20020a05620a1a0900b0045df00f93a9so9871983qkb.1
        for <kvm@vger.kernel.org>; Fri, 08 Oct 2021 19:12:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=duVCxds/Xk54aU09i5UIkyaIUq0yJMQJZI9wZA2YDlA=;
        b=Wv/kcG4ULQxV2PKupeA3o9viF1KOUTbF8+9gkKByWbWPMHCHTm+TZZg7F5whB1kJEv
         00RE4Q8btFY4lrjbmtjP6hVSSAYJJdql8WRFW8k/FQZNMBqfykiFr2BiQA+wfe28C543
         SWlusb4mpYdymW6ZMpaM7mrIbRvVwIrPb/jvum8yisSKEvO7UFeRbl7H6trZAhauAzQD
         a1bpHkCHoYH6NJt8GSDU7cMPxIgXQRKLxIkS2NtUm9+Lov6n2e8PGJQvej1YmfsKCffW
         TihOARLN4ummUTvbvoWa2j+nguD9Os55BuiemMJ8jed6VNGgNVOfE7xoH5rBJNb4aOyN
         lvIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=duVCxds/Xk54aU09i5UIkyaIUq0yJMQJZI9wZA2YDlA=;
        b=yJx+xShd/zLLjpyiQooLq2LxObuPJgLRYnXJBVEL5DtYtB9ohq6mGGw4tuzaJYoDCG
         mZE/n/jeJyWfIeusk8qrwsBOM85mth21l/X2TU0LdAHIrI1Wn3klKu6l74dFE9Ad4QXY
         tnNAU55mLrgT4wNo+BAkjuQHcEQKRLh3Je+mH3Yj91E8LfrJvv6HLQUNitimssb3gG3g
         yqvD8xkIoY10YQm04ZoY5jrinyCHEjSzre3+/gmWJ1++7Ax7sWLmwj/e0mc2KEUofhz4
         mVp0ogVxtfuygvkQDW+ZAZqmP6FPIswQJ2BcDd3XUzZrWPM8ExJ79DOkzzwmn3QmWuAb
         b1KA==
X-Gm-Message-State: AOAM530ciOU1DYUnGJ7nCZzR41OGlfZEv5brD5HBGGXDkZVv8BGf2+Wo
        MBHPYPjz341jp9rP8oOwh4MjiTCUSEI=
X-Google-Smtp-Source: ABdhPJzReckbemypX4PIoTmT2KiRT9pVyd7dG9YNXxxpVcLBpBPcyP9Rkq3/2bNbj++4tivC2JpyLGM9nrE=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:e39b:6333:b001:cb])
 (user=seanjc job=sendgmr) by 2002:a05:622a:1055:: with SMTP id
 f21mr1892047qte.24.1633745576813; Fri, 08 Oct 2021 19:12:56 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  8 Oct 2021 19:11:59 -0700
In-Reply-To: <20211009021236.4122790-1-seanjc@google.com>
Message-Id: <20211009021236.4122790-7-seanjc@google.com>
Mime-Version: 1.0
References: <20211009021236.4122790-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v2 06/43] KVM: Refactor and document halt-polling stats update helper
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

Add a comment to document that halt-polling is considered successful even
if the polling loop itself didn't detect a wake event, i.e. if a wake
event was detect in the final kvm_vcpu_check_block().  Invert the param
to update helper so that the helper is a dumb function that is "told"
whether or not polling was successful, as opposed to determining success
based on blocking behavior.

Opportunistically tweak the params to the update helper to reduce the
line length for the call site so that it fits on a single line, and so
that the prototype conforms to the more traditional kernel style.

No functional change intended.

Reviewed-by: David Matlack <dmatlack@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 6156719bcbbc..4dfcd736b274 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3201,13 +3201,15 @@ static int kvm_vcpu_check_block(struct kvm_vcpu *vcpu)
 	return ret;
 }
 
-static inline void
-update_halt_poll_stats(struct kvm_vcpu *vcpu, u64 poll_ns, bool waited)
+static inline void update_halt_poll_stats(struct kvm_vcpu *vcpu, ktime_t start,
+					  ktime_t end, bool success)
 {
-	if (waited)
-		vcpu->stat.generic.halt_poll_fail_ns += poll_ns;
-	else
+	u64 poll_ns = ktime_to_ns(ktime_sub(end, start));
+
+	if (success)
 		vcpu->stat.generic.halt_poll_success_ns += poll_ns;
+	else
+		vcpu->stat.generic.halt_poll_fail_ns += poll_ns;
 }
 
 /*
@@ -3277,9 +3279,13 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 	kvm_arch_vcpu_unblocking(vcpu);
 	block_ns = ktime_to_ns(cur) - ktime_to_ns(start);
 
+	/*
+	 * Note, halt-polling is considered successful so long as the vCPU was
+	 * never actually scheduled out, i.e. even if the wake event arrived
+	 * after of the halt-polling loop itself, but before the full wait.
+	 */
 	if (do_halt_poll)
-		update_halt_poll_stats(
-			vcpu, ktime_to_ns(ktime_sub(poll_end, start)), waited);
+		update_halt_poll_stats(vcpu, start, poll_end, !waited);
 
 	if (halt_poll_allowed) {
 		if (!vcpu_valid_wakeup(vcpu)) {
-- 
2.33.0.882.g93a45727a2-goog

