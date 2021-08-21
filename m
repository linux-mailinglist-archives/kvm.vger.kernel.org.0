Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D01033F377B
	for <lists+kvm@lfdr.de>; Sat, 21 Aug 2021 02:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240906AbhHUAFy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Aug 2021 20:05:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240681AbhHUAFt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Aug 2021 20:05:49 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 114BFC061760
        for <kvm@vger.kernel.org>; Fri, 20 Aug 2021 17:05:11 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id z2-20020a5b0b02000000b005982be23a34so4671847ybp.19
        for <kvm@vger.kernel.org>; Fri, 20 Aug 2021 17:05:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=54uWzZ0QiUh7LTT7cDKnUdwo+y1GGb5heMjjM1DQHz8=;
        b=QuIJU/m6yr7P7ZfLNtjrp+hIPsQn15KcSx30QYnMYc696QV4CagBH1JTiIXWDUxjru
         a8GUH9i9PTbP5j03MbPTUYRMv/iL4uMXUwLV9dkPe0lh43QzHOHwdYlHZgZBG1DprbLR
         AOGyQL8wUDJNU4QdsK4LjdePpZn1MR9k+sHHUD1kL/cXFBpIB6U0uqXz/me445ZhdKVw
         Rk0ZIcMg21zoCyBXSQL+PLnBgPBnIYmkepCRDn1wsmDcoD1nUwJ6yOMYxsCNPBZU+br4
         eD5ZFLCnTCt4JyuzwkFWLuhDkcLmXWOY22mCqAJTV7a+in3aD/vASl8vCzRLzD4z1Vl7
         d90Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=54uWzZ0QiUh7LTT7cDKnUdwo+y1GGb5heMjjM1DQHz8=;
        b=Mw8MYBo7K0Ut5x/47zVk+wB+WeKg5jNOH/85TeOqxBggcbu0VOtm+yrLtjfDZ20wgp
         nOfoG5B7vPsTmQWO2ecn749jKWM2Pdfyv7z8I8Cv8dseK+Hdphea9NGwSGCfqjALCanz
         7A/IsVK4EZyTK7cuifaUbsKne/73U7wUnSzl/7yFEJ1mZkJznLMLGOTBRYE41oxfr2cq
         cJOBiiHh4076+VxUO11z6QyODf88JhNuA1Bx1Dypm1VOdQa3LlL3kbcoqymWfbRvbrxS
         Snmd+699Ed6UOZYV+SCWfwgs7JKRxEaUgByXxivsfuils14uWz6VS98LIePhYx8KMXsp
         Qjpw==
X-Gm-Message-State: AOAM530bBbW1riFjH2VaO8pmeOr2jaZUN5DzY4Ns0QXdCIS/1BV4SeG6
        JvrlLr4RMst6MD237YoSOmhFYoaTYho=
X-Google-Smtp-Source: ABdhPJyPm+NpIq4wrSZHClc41jcpFkL/5oM1mRA3LBoTVpreEbKzK2vAugDww45UFQ6hyIbUB4yfr0SjmEk=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:f11d:a281:af9b:5de6])
 (user=seanjc job=sendgmr) by 2002:a25:8c4:: with SMTP id 187mr27225917ybi.369.1629504310265;
 Fri, 20 Aug 2021 17:05:10 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 20 Aug 2021 17:05:01 -0700
In-Reply-To: <20210821000501.375978-1-seanjc@google.com>
Message-Id: <20210821000501.375978-3-seanjc@google.com>
Mime-Version: 1.0
References: <20210821000501.375978-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.rc2.250.ged5fa647cd-goog
Subject: [PATCH 2/2] KVM: Guard cpusmask NULL check with CONFIG_CPUMASK_OFFSTACK
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Venkatesh Srinivas <venkateshs@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Check for a NULL cpumask_var_t when kicking multiple vCPUs if and only if
cpumasks are configured to be allocated off-stack.  This is a meaningless
optimization, e.g. avoids a TEST+Jcc and TEST+CMOV on x86, but more
importantly helps document that the NULL check is necessary even though
all callers pass in a local variable.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 786b914db98f..82c5280dd5ce 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -247,7 +247,7 @@ static void ack_flush(void *_completed)
 
 static inline bool kvm_kick_many_cpus(const struct cpumask *cpus, bool wait)
 {
-	if (unlikely(!cpus))
+	if (IS_ENABLED(CONFIG_CPUMASK_OFFSTACK) && unlikely(!cpus))
 		cpus = cpu_online_mask;
 
 	if (cpumask_empty(cpus))
@@ -277,6 +277,14 @@ bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req,
 		if (!(req & KVM_REQUEST_NO_WAKEUP) && kvm_vcpu_wake_up(vcpu))
 			continue;
 
+		/*
+		 * tmp can be NULL if cpumasks are allocated off stack, as
+		 * allocation of the mask is deliberately not fatal and is
+		 * handled by falling back to kicking all online CPUs.
+		 */
+		if (IS_ENABLED(CONFIG_CPUMASK_OFFSTACK) && !tmp)
+			continue;
+
 		/*
 		 * Note, the vCPU could get migrated to a different pCPU at any
 		 * point after kvm_request_needs_ipi(), which could result in
@@ -288,7 +296,7 @@ bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req,
 		 * were reading SPTEs _before_ any changes were finalized.  See
 		 * kvm_vcpu_kick() for more details on handling requests.
 		 */
-		if (tmp != NULL && kvm_request_needs_ipi(vcpu, req)) {
+		if (kvm_request_needs_ipi(vcpu, req)) {
 			cpu = READ_ONCE(vcpu->cpu);
 			if (cpu != -1 && cpu != me)
 				__cpumask_set_cpu(cpu, tmp);
-- 
2.33.0.rc2.250.ged5fa647cd-goog

