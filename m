Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B60CB39BEB6
	for <lists+kvm@lfdr.de>; Fri,  4 Jun 2021 19:27:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231208AbhFDR3Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Jun 2021 13:29:24 -0400
Received: from mail-pj1-f74.google.com ([209.85.216.74]:51033 "EHLO
        mail-pj1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230314AbhFDR3Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Jun 2021 13:29:24 -0400
Received: by mail-pj1-f74.google.com with SMTP id s5-20020a17090a7645b029016d923cccbeso664304pjl.0
        for <kvm@vger.kernel.org>; Fri, 04 Jun 2021 10:27:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=hPqg2zEw8xWDxZPbY6MJzuzKRTdbGJVq1JFdi5WkfCk=;
        b=OhJpnQ64jlGrRhwDsKiuMuzPBsFqtfKAZefM5r1f5A6dQVyzU/xQRqqIoE+giSHCDq
         8QVISi1tQF9uWXLZWGaYNd/vwtYR6XPX2y/jbb6n9Ij3UfR2aDFFfuVQDdF87JbvY26v
         YkYzEoNN+GyelnjBzV8xyXrxn+K6eeVgWdmvBRwNW4SI/ADUO1YLGz4ok2gw2uKWB7s6
         un8XWPTlNOo2EgaQkoQh54mhkPdRN+Ul0ZqaLsFdUaBnZJJDHapFp2o77YvNbyW5anix
         FPLKbF2Qo6NwfqO3tqkZUJMQ3i7YjCrBm9OdXty4H2w94EiSiyqpv8L/g6qrRPihsX6t
         yAJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=hPqg2zEw8xWDxZPbY6MJzuzKRTdbGJVq1JFdi5WkfCk=;
        b=iphON5ayPsUJ9NsOI6RyE45no7kxxE8w8p3auuQpuwbdJeYhDxgct+vAPqNnS5hT0G
         wGdtF/6H+wd+HAkuVHR40ARdbHX3ibxjS+5Wx1YILkXHWmc3AuTbc7zohNrUY6djyew+
         Lv9juZbMeDO4bdkp/hmDtbxXGJkIUiDtjDOzPGMFvc6N5/Vj+/bVpzXiNlzhet+7JOGm
         5mDMQlmTi89CdaUMIJD5dqc32pFYpZn1uQQVY3ul0gzPlPTGjxlYo4zuoBx/VgRK/RO7
         ur5Q4iB6QIJRFustrerRuoatGL3/Mz63fn84VPyprkTAgh8x1ODGmTpyKOkaegF4CvUq
         iuVg==
X-Gm-Message-State: AOAM533a9Gfk2A007WyJo/2VQu6VFhBtIms9qM+tY3neWkC5RfNO03Wp
        LtW0ICW7wl8woHoRDzSzvBlxnm752dTnCRsOhxsu3lTF9m1kRG6FOR9YRnle7TOz2E4gOyiyxzY
        uB4NohO5RVhHQw/qaKgbTmPchf7Sfis0+OaL6VcQ3/RvXWhAqIq3KQ3CYVkigdg8=
X-Google-Smtp-Source: ABdhPJwyzqPV8+hSeY9vyX5P/zbx6JKJG+QpCLyVuNOjGanv0TwxWmx4830vzff8SWcl92nvzbsNPsOGgvYmTA==
X-Received: from tortoise.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:1a0d])
 (user=jmattson job=sendgmr) by 2002:a17:902:ce84:b029:10f:a857:1e73 with SMTP
 id f4-20020a170902ce84b029010fa8571e73mr2654870plg.72.1622827597477; Fri, 04
 Jun 2021 10:26:37 -0700 (PDT)
Date:   Fri,  4 Jun 2021 10:26:05 -0700
In-Reply-To: <20210604172611.281819-1-jmattson@google.com>
Message-Id: <20210604172611.281819-7-jmattson@google.com>
Mime-Version: 1.0
References: <20210604172611.281819-1-jmattson@google.com>
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
Subject: [PATCH v2 06/12] KVM: nVMX: Fail on MMIO completion for nested posted interrupts
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When the kernel has no mapping for the vmcs02 virtual APIC page,
userspace MMIO completion is necessary to process nested posted
interrupts. This is not a configuration that KVM supports. Rather than
silently ignoring the problem, try to exit to userspace with
KVM_INTERNAL_ERROR.

Note that the event that triggers this error is consumed as a
side-effect of a call to kvm_check_nested_events. On some paths
(notably through kvm_vcpu_check_block), the error is dropped. In any
case, this is an incremental improvement over always ignoring the
error.

Signed-off-by: Jim Mattson <jmattson@google.com>

---
 arch/x86/kvm/vmx/nested.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 7646e6e561ad..706c31821362 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3700,7 +3700,7 @@ static int vmx_complete_nested_posted_interrupt(struct kvm_vcpu *vcpu)
 	if (max_irr != 256) {
 		vapic_page = vmx->nested.virtual_apic_map.hva;
 		if (!vapic_page)
-			return 0;
+			goto mmio_needed;
 
 		__kvm_apic_update_irr(vmx->nested.pi_desc->pir,
 			vapic_page, &max_irr);
@@ -3714,6 +3714,10 @@ static int vmx_complete_nested_posted_interrupt(struct kvm_vcpu *vcpu)
 
 	nested_mark_vmcs12_pages_dirty(vcpu);
 	return 0;
+
+mmio_needed:
+	kvm_handle_memory_failure(vcpu, X86EMUL_IO_NEEDED, NULL);
+	return -ENXIO;
 }
 
 static void nested_vmx_inject_exception_vmexit(struct kvm_vcpu *vcpu,
-- 
2.32.0.rc1.229.g3e70b5a671-goog

