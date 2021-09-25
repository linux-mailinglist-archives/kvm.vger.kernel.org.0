Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7685417EDD
	for <lists+kvm@lfdr.de>; Sat, 25 Sep 2021 02:56:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346581AbhIYA5c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 20:57:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346475AbhIYA5V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Sep 2021 20:57:21 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1D8CC061762
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 17:55:46 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id x28-20020ac8701c000000b0029f4b940566so41362093qtm.19
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 17:55:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=wCDTOmCATHVhirkJj1e9UGRNdETjcfm809lLJpA1KZ0=;
        b=NqlSHtDJsZY9ynz1iazGvEiDMeqk04glWuzCtUdaZ74/+oO9rjnWS76Uh5TCi8grB+
         KwboA6njeSjTV+7uoE02X2FwYEkNPrLAm4qkXIZRVzJuxFafx32Mk5Xow/7WaARh1YAZ
         aC51w8eW6QKpvfDfIdD1udB75TJ4xUgQM915d2jcceUTh/hDb7mbGAiLnwAyqt0Y+WNF
         QpBy7FR47VOdDUwc186Fr9j28eODhANC/CUAjZvNZrR7fGsZs3zQzKM9xL4iXSTKlTtT
         +D4Y310QHpvHJHW02qI33BojoXY3YB8cjH1EF1eQmiciixtCRe97iPAZe1mITqWJtBmk
         YH1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=wCDTOmCATHVhirkJj1e9UGRNdETjcfm809lLJpA1KZ0=;
        b=a9nCSi3ydB8ramnUbp2NnhMoBckPTg/V3czPM+Z77MMtw0ydAFnwijZU04aoLl+uyH
         M42DbjdCi4uch6lzTUKbG3wsW8WX93IC7GbAqSQYtX2lxqsF5ps8xDjOYFEUQoMWsJ9k
         GR3MGuK9LDFbt7izu+duniMggQb+1Wy22X+bWCSj8ajvXFz6oAmme/FXUDBqYfQ/f8s8
         p8Ro3I83V7DYw7x3ci8fgmSyRecWqQ2At5gYMr3mrE1ojmLCyfxxsow/HyHljV3ZcCEn
         WUurZysqc9Sz5D3kVGXe2YXWuSZ+584p6NAR0ti8QBtNolxugWgBwwA80ktamp95SRA9
         dEDQ==
X-Gm-Message-State: AOAM5306Xe3yQZaYLZi8l0ofVYWTwsjkbVqtKEdh8+VFhxMmuFgSbjLp
        /Sb6hWMb/qWAbNk6BQd9kbQqmAQqzSQ=
X-Google-Smtp-Source: ABdhPJwAe8cto2GGuy35+RfGF59+NomWHsqVgBAWIRGsvWVII07cOgInTsUOlV2E2ha1qSQ9QAXX81/NXqE=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:4c72:89be:dba3:2bcb])
 (user=seanjc job=sendgmr) by 2002:a05:6214:1046:: with SMTP id
 l6mr4932886qvr.6.1632531346015; Fri, 24 Sep 2021 17:55:46 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 24 Sep 2021 17:55:21 -0700
In-Reply-To: <20210925005528.1145584-1-seanjc@google.com>
Message-Id: <20210925005528.1145584-8-seanjc@google.com>
Mime-Version: 1.0
References: <20210925005528.1145584-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [PATCH 07/14] KVM: Don't block+unblock when halt-polling is successful
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

Invoke the arch hooks for block+unblock if and only if KVM actually
attempts to block the vCPU.  The only non-nop implementation is on arm64,
and if halt-polling is successful, there is no need for arm64 to put/load
the vGIC as KVM hasn't relinquished control of the vCPU in any way.

The primary motivation is to allow future cleanup to split out "block"
from "halt", but this is also likely a small performance boost on arm64
when halt-polling is successful.

Adjust the post-block path to update "cur" after unblocking, i.e. include
vGIC load time in halt_wait_ns and halt_wait_hist, so that the behavior
is consistent.  Moving just the pre-block arch hook would result in only
the vGIC put latency being included in the halt_wait stats.  There is no
obvious evidence that one way or the other is correct, so just ensure KVM
is consistent.

Cc: Marc Zyngier <maz@kernel.org>
Cc: James Morse <james.morse@arm.com>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 2015a1f532ce..f96cda8312f3 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3232,8 +3232,6 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 	bool waited = false;
 	u64 block_ns;
 
-	kvm_arch_vcpu_blocking(vcpu);
-
 	start = cur = poll_end = ktime_get();
 	if (do_halt_poll) {
 		ktime_t stop = ktime_add_ns(ktime_get(), vcpu->halt_poll_ns);
@@ -3250,6 +3248,7 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 		} while (kvm_vcpu_can_poll(cur, stop));
 	}
 
+	kvm_arch_vcpu_blocking(vcpu);
 
 	prepare_to_rcuwait(&vcpu->wait);
 	for (;;) {
@@ -3262,6 +3261,9 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 		schedule();
 	}
 	finish_rcuwait(&vcpu->wait);
+
+	kvm_arch_vcpu_unblocking(vcpu);
+
 	cur = ktime_get();
 	if (waited) {
 		vcpu->stat.generic.halt_wait_ns +=
@@ -3269,8 +3271,8 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 		KVM_STATS_LOG_HIST_UPDATE(vcpu->stat.generic.halt_wait_hist,
 				ktime_to_ns(cur) - ktime_to_ns(poll_end));
 	}
+
 out:
-	kvm_arch_vcpu_unblocking(vcpu);
 	block_ns = ktime_to_ns(cur) - ktime_to_ns(start);
 
 	/*
-- 
2.33.0.685.g46640cef36-goog

