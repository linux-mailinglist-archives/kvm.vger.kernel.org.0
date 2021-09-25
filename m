Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8067F417EBF
	for <lists+kvm@lfdr.de>; Sat, 25 Sep 2021 02:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237193AbhIYA5M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 20:57:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233410AbhIYA5J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Sep 2021 20:57:09 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A7D2C06161E
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 17:55:36 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id b17-20020a056214135100b0037eaf39cb1fso43293148qvw.11
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 17:55:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=2ksHGqIX50byEw/B/i+4MAj6IHSuI0V9Re6S49u78QE=;
        b=Cv4b8gw7+pQzNKHQ+8lMUi5KSfKwZImP0gbOdovtDY21Pa+DbRVpLf0FX3Ny/GtGV+
         l0V69NsBIy1juCTYkrc+ZecGEpb/+2U0I7btvRRB/j7TbeGomRTqALuS7CRNK3ZK77rs
         I8jAXLs2069h1QaDqdwGdc7NdArdNnk8SOx0Kbb5tZimbUbkp1AE++ltJXqt239HcPIt
         7iiqQhvEA6upugk00ug/jEN4lU79fHpjgvTEj2CtM3woq//N0ZgH8t2jvtwzT+D/nuL5
         Y0Urz5Yiku+Wb2J8tPb6U/TZ8fP2oxfPADDLSPy+boqaGEopEHKI+QAne2jnc9ignY3J
         8/fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=2ksHGqIX50byEw/B/i+4MAj6IHSuI0V9Re6S49u78QE=;
        b=hRqShIJbxY8sGifOAAc0kogDHzAoWcfynvmxavtH03/hZFtUe8h/b/dLUlErVx9GN2
         S03LweO4IXT92JotiH8ANJu4wQHWLvVHD0B3uIj5WI+mkErvoldfhW0WvKE23oE4Pttw
         EVR0aohwgvzpiT3EdQHg5b85hbK6L+Dyyvfft5eCPJdho78qzI/cQ2v3qoyjZJbiRjo8
         Hi8ohrwpSX97uJLp58qmBJi+QYXGV61+rd+XH1GRfZr1uPMfkcyTSvc5xFkBuN8VN19x
         9HyxrhU2K/Y/ZKFe9Kr407wT5g8vKvluyPsgQEqUxMu7mI8MA4CKRe3cXssH7gybVdtu
         Rjug==
X-Gm-Message-State: AOAM531ATJRgg8tqhWAF4K+vfTKs76vRlAAl1OcnXkCQHzP8deT6cWX4
        xUAzAbpzxKQAaDoQQ7ZNv5ma170sGCI=
X-Google-Smtp-Source: ABdhPJyoBfybYr+VTcT30KA/5NRI2oATafpveFnKITvJxQlG0tfUXjcoc8CvFJgJOt3i4NZOnBOTLU/4h4Y=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:4c72:89be:dba3:2bcb])
 (user=seanjc job=sendgmr) by 2002:a05:6214:44e:: with SMTP id
 cc14mr13352413qvb.19.1632531335232; Fri, 24 Sep 2021 17:55:35 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 24 Sep 2021 17:55:16 -0700
In-Reply-To: <20210925005528.1145584-1-seanjc@google.com>
Message-Id: <20210925005528.1145584-3-seanjc@google.com>
Mime-Version: 1.0
References: <20210925005528.1145584-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [PATCH 02/14] KVM: Update halt-polling stats if and only if
 halt-polling was attempted
From:   Sean Christopherson <seanjc@google.com>
To:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
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
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Don't update halt-polling stats if halt-polling wasn't attempted.  This
is a nop as @poll_ns is guaranteed to be '0' (poll_end == start), but it
will allow a future patch to move the histogram stats into the helper to
resolve a discrepancy in what is considered a "successful" halt-poll.

No functional change intended.

Cc: David Matlack <dmatlack@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 768a4cbb26a6..8b33f5045b4d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3214,6 +3214,7 @@ update_halt_poll_stats(struct kvm_vcpu *vcpu, u64 poll_ns, bool waited)
 void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 {
 	bool halt_poll_allowed = !kvm_arch_no_poll(vcpu);
+	bool do_halt_poll = halt_poll_allowed && vcpu->halt_poll_ns;
 	ktime_t start, cur, poll_end;
 	bool waited = false;
 	u64 block_ns;
@@ -3221,7 +3222,7 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 	kvm_arch_vcpu_blocking(vcpu);
 
 	start = cur = poll_end = ktime_get();
-	if (vcpu->halt_poll_ns && halt_poll_allowed) {
+	if (do_halt_poll) {
 		ktime_t stop = ktime_add_ns(ktime_get(), vcpu->halt_poll_ns);
 
 		++vcpu->stat.generic.halt_attempted_poll;
@@ -3273,8 +3274,9 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 	kvm_arch_vcpu_unblocking(vcpu);
 	block_ns = ktime_to_ns(cur) - ktime_to_ns(start);
 
-	update_halt_poll_stats(
-		vcpu, ktime_to_ns(ktime_sub(poll_end, start)), waited);
+	if (do_halt_poll)
+		update_halt_poll_stats(
+			vcpu, ktime_to_ns(ktime_sub(poll_end, start)), waited);
 
 	if (halt_poll_allowed) {
 		if (!vcpu_valid_wakeup(vcpu)) {
-- 
2.33.0.685.g46640cef36-goog

