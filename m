Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B49638B9FA
	for <lists+kvm@lfdr.de>; Fri, 21 May 2021 01:04:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233153AbhETXFg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 May 2021 19:05:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232984AbhETXF0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 May 2021 19:05:26 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D2C3C061761
        for <kvm@vger.kernel.org>; Thu, 20 May 2021 16:04:04 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id o15-20020a05622a138fb02901e0ac29f6b2so13485137qtk.11
        for <kvm@vger.kernel.org>; Thu, 20 May 2021 16:04:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=GdNydyvj7tHXN7vqxe/SwxHU1uQGMopLadupwTPQaV0=;
        b=FayWd9aapXph08ZHXjPWcaQiQV5AP97ikg/r+HcBhXK1zH4Whj1kt6NwuuJQ21hwMs
         cAqRrcIXpvw5jsfSUpUUioJH3LqPz3I4eMGt7skvhvkAvIN0GaIfGXl/YW+MK/qE/L7l
         JwO6bbJZJdXGjz+E8nTocDeJbj8qY624Oyk/5w5d2YNeqzqmOXBWYNMQ/4OZWwltDlA1
         E6IBzA0mve/IqWq3yIrF3M6+G9X/lzuBk9j6ExY/fDKvv/MeFlF0u3zt7vlxPcdCvkee
         90AWkAdEKCnPkpfIt3TvU0S2xSUJK5aK5QfqzlAcga/bLCNTTHOg9HFZWiWNjxe3nyF2
         ilXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=GdNydyvj7tHXN7vqxe/SwxHU1uQGMopLadupwTPQaV0=;
        b=orJPnad/e5TefoI/LrPwY2usTaHKQXzkn32kYI/s32c5FaO5XLJWTBo14UQJdxYbuO
         GEQanZMLJ6wc4El7xta17mYT9w6XJLE0wBaK401bxAWedOHektg19yEULRawxp8jeLs1
         pB0sQLJr4ZcTdmza+GLHMlg+fmXMbgdFT8+9thyFpA0OGHRYZOWZARRL7u/7iSGU7fzN
         2+z+PvS6Dls34GoDJlfCkO9fEnylhrz0HFSZZvbU1WScNO7gWo49WXXgQIQeu6LZkco3
         CoGnBraV9Lg8Cx0FiueHcCz3xPtUeIelU+u+Om7Sl/AjIZLkS9uiF/w0XNS270bfne2S
         IahQ==
X-Gm-Message-State: AOAM531TV+PZCjf96FIVTjoR61U7cambxxo+82YYAQfwiTcgQ4qLAGwv
        lIHUjHvnpwH+V5haIX8+E99Kn2NCjGv9Z0xEOQLB11IA57K3s/ZGVC87Mi+MhR/EC17O0I2QxWK
        Vum3MEVsrsPGvHUU7AITM7rNayVypxyRSQUttVYHOoSnhez8did6L36BAQLiX59M=
X-Google-Smtp-Source: ABdhPJzxZUYM678BtgQ4XEnWb6KCuaRw3kNQon8IuaovahdAN8akXI2JGhv4gLQz5fAP2LyshAC6piRQs0vzQg==
X-Received: from tortoise.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:1a0d])
 (user=jmattson job=sendgmr) by 2002:ad4:54c9:: with SMTP id
 j9mr8889487qvx.62.1621551843395; Thu, 20 May 2021 16:04:03 -0700 (PDT)
Date:   Thu, 20 May 2021 16:03:34 -0700
In-Reply-To: <20210520230339.267445-1-jmattson@google.com>
Message-Id: <20210520230339.267445-8-jmattson@google.com>
Mime-Version: 1.0
References: <20210520230339.267445-1-jmattson@google.com>
X-Mailer: git-send-email 2.31.1.818.g46aad6cb9e-goog
Subject: [PATCH 07/12] KVM: nVMX: Disable vmcs02 posted interrupts if vmcs12
 PID isn't mappable
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Don't allow posted interrupts to modify a stale posted interrupt
descriptor (including the initial value of 0).

Empirical tests on real hardware reveal that a posted interrupt
descriptor referencing an unbacked address has PCI bus error semantics
(reads as all 1's; writes are ignored). However, kvm can't distinguish
unbacked addresses from device-backed (MMIO) addresses, so it should
really ask userspace for an MMIO completion. That's overly
complicated, so just punt with KVM_INTERNAL_ERROR.

Don't return the error until the posted interrupt descriptor is
actually accessed. We don't want to break the existing kvm-unit-tests
that assume they can launch an L2 VM with a posted interrupt
descriptor that references MMIO space in L1.

Fixes: 6beb7bd52e48 ("kvm: nVMX: Refactor nested_get_vmcs12_pages()")
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/vmx/nested.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 706c31821362..defd42201bb4 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3175,6 +3175,15 @@ static bool nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
 				offset_in_page(vmcs12->posted_intr_desc_addr));
 			vmcs_write64(POSTED_INTR_DESC_ADDR,
 				     pfn_to_hpa(map->pfn) + offset_in_page(vmcs12->posted_intr_desc_addr));
+		} else {
+			/*
+			 * Defer the KVM_INTERNAL_ERROR exit until
+			 * someone tries to trigger posted interrupt
+			 * processing on this vCPU, to avoid breaking
+			 * existing kvm-unit-tests.
+			 */
+			vmx->nested.pi_desc = NULL;
+			pin_controls_clearbit(vmx, PIN_BASED_POSTED_INTR);
 		}
 	}
 	if (nested_vmx_prepare_msr_bitmap(vcpu, vmcs12))
@@ -3689,10 +3698,14 @@ static int vmx_complete_nested_posted_interrupt(struct kvm_vcpu *vcpu)
 	void *vapic_page;
 	u16 status;
 
-	if (!vmx->nested.pi_desc || !vmx->nested.pi_pending)
+	if (!vmx->nested.pi_pending)
 		return 0;
 
+	if (!vmx->nested.pi_desc)
+		goto mmio_needed;
+
 	vmx->nested.pi_pending = false;
+
 	if (!pi_test_and_clear_on(vmx->nested.pi_desc))
 		return 0;
 
-- 
2.31.1.818.g46aad6cb9e-goog

