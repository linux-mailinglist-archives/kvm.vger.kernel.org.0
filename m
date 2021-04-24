Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92588369DFF
	for <lists+kvm@lfdr.de>; Sat, 24 Apr 2021 02:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244493AbhDXAtv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 20:49:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244327AbhDXAs1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Apr 2021 20:48:27 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A3D4C06175F
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 17:47:25 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id a7-20020a5b00070000b02904ed415d9d84so4615758ybp.0
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 17:47:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=bZhFtNS6H4/qf4I8RWVJ2+WzcwhJXicC5JMUikKYnuU=;
        b=jFVVaBFZMcDYN7hb4egS1sUaS6IMOo7muvsB5U4vo0ARzbvBBEorLBvCAW/At38u6N
         Rox4cksEOHGe8nBD7fxsO0TK8JrEKwIAs8aXMT8hBdvkFrAYUzU6t3o0aHlhxTtPTkp7
         oABbrSeMftw785UuunwjeGx+eg8khpZDWI0R7gjLo5wJrSaZisYbZWub76DXwmSPHRCC
         Plnmt9gApth3A0lCrYWwctC6MSLbbYhsr+wWcHaM/oEeomqvRncWFvhpVLQNYufxO8tv
         NyTWauJC27FU95S6wBSZIYW6+vDBi59LSChLyQ6GBt/6CHl4MfiGw2UOltARSlRxSbdq
         SZKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=bZhFtNS6H4/qf4I8RWVJ2+WzcwhJXicC5JMUikKYnuU=;
        b=r6rdCZl6FD4f6rzY6z7/I+HWCo7bogr8+F/yWPyhGOwA734zgHI//cRcPxiX1Zs9of
         E9RQeZ95ytQBijTC+N5Ct1xkeFqtmayPxfkStUs9yKFkvJmzdknV4M58ZW37t46T+SBj
         0o2x8n/6jCPpTTvwdo3K6QSyWKtW4HbyY/gZJaotl/Y+qIhWCKWComyv7Ti582N3G7oM
         cZQuPUkXVUg8Elz0a4kF7dh2T1QWAa8RqYIirgylTPPnPcmopOT2gBSZnLU0p4P0kESp
         eaYaNl27ZdoCvM7SLHPv1yp96Nfhe7pP2/TlI1sTIcyFA15XvuyFB3bS9tAy7+USgjTh
         GISQ==
X-Gm-Message-State: AOAM532eZgPCMNx7JiGdHFJG06LP6yTQPJYtGUw3jWDAX3JeXUQK1Wnr
        LXtWB6EseAkNfOLWme8IC67rRLhoAb4=
X-Google-Smtp-Source: ABdhPJzW7SSyk1RpTzdj7JWWqLsRpSIgopTP0PSz261q7zhylYUyaXFATUOLvvXvDD5ESYWQsrYl4ze9zeg=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:ad52:3246:e190:f070])
 (user=seanjc job=sendgmr) by 2002:a25:ba83:: with SMTP id s3mr9551305ybg.280.1619225244508;
 Fri, 23 Apr 2021 17:47:24 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 23 Apr 2021 17:46:13 -0700
In-Reply-To: <20210424004645.3950558-1-seanjc@google.com>
Message-Id: <20210424004645.3950558-12-seanjc@google.com>
Mime-Version: 1.0
References: <20210424004645.3950558-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH 11/43] KVM: x86: WARN if the APIC map is dirty without an
 in-kernel local APIC
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

WARN if KVM ends up in a state where it thinks its APIC map needs to be
recalculated, but KVM is not emulating the local APIC.  This is mostly
to document KVM's "rules" in order to provide clarity in future cleanups.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 152591f9243a..655eb1d07344 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -192,6 +192,9 @@ void kvm_recalculate_apic_map(struct kvm *kvm)
 	if (atomic_read_acquire(&kvm->arch.apic_map_dirty) == CLEAN)
 		return;
 
+	WARN_ONCE(!irqchip_in_kernel(kvm),
+		  "Dirty APIC map without an in-kernel local APIC");
+
 	mutex_lock(&kvm->arch.apic_map_lock);
 	/*
 	 * Read kvm->arch.apic_map_dirty before kvm->arch.apic_map
-- 
2.31.1.498.g6c1eba8ee3d-goog

