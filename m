Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 691DC2642F6
	for <lists+kvm@lfdr.de>; Thu, 10 Sep 2020 11:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730649AbgIJJzS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Sep 2020 05:55:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730426AbgIJJvJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Sep 2020 05:51:09 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F13BAC0613ED;
        Thu, 10 Sep 2020 02:51:08 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id l191so3964225pgd.5;
        Thu, 10 Sep 2020 02:51:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=czOly1540I6BKqMoR9raepWwmmlZQ0MNBG9xzJ8lIuk=;
        b=RpOegm/l6JpCENCZQdON8OVqhPsf8h5roKmEBsTCAGzJiC3MLll5p4GTTdM0INZ4Qr
         XbAP/KFa1mixl8oSn/OYM15dDPAo9rw4qwupXyL/YvskJ6coTKspuB8G5tuBZR6VWrcU
         oCcHAV0HiKMq7vfraDc7ELRfAuNMwuG/oN/4eg+2PMLRbqXbPnOcxhEEsH7kZLuKuOC1
         cKCrgh84NW4pRU/GwYi61dtdVeBwyPJTIjsH5Y2qN4ItiPEp+VcFQYw8QTowT7i/QKAA
         PRx9J8pi8v9RLq5yPlAF6oa+W7KdQCkfp7OlMBFQ57OYWhHOgAQfh8CB53NC7helHJPr
         Xe7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=czOly1540I6BKqMoR9raepWwmmlZQ0MNBG9xzJ8lIuk=;
        b=aZ8wy+I6PE91Q2PHCJbqnz7/XKYuEB7RaqvDWeVHn3dDRKIg631o3UWK8/f9a6TvXO
         ZUfL6yBNvVpAZG7BxMbFC+KKerOzistQfqVscj6+7EsBWXowKIeMcOlo+XFlXRiHdKxT
         lyolYOoSbGNQUFbfRaV1pUg4a21h2u3Ffgwx9IqobyaTlyfskA/G8fCzYW6Bbjy0/W1G
         0zDTQs3ZKYA4uoXA5xZ2Gaqq0D0ryesCg+f3g9EetmJ8id9C+MgylcfKNdtWboWeOfrT
         dvUMFUF3Mg6EIKu9CmqabuE5X8JNk2vPMM9PNThMPLUT2Ag07OxfKqJe14bk2yAl1ARb
         qspQ==
X-Gm-Message-State: AOAM533Afhqg9IvspXkxtbrQzk430gbzFDwEcNvM+tqvwQF6PqJ9Qv39
        ae02OCGqulhgLDD7PMCh65jmk7zuaeA=
X-Google-Smtp-Source: ABdhPJxGjSfsVATKZs0iOBS1CNkwsW0OZPfU49sSnMDfaxsKL5FQfeF8hebA9K+CfzAnRkXSEE0XpA==
X-Received: by 2002:a05:6a00:808:b029:13e:d13d:a05d with SMTP id m8-20020a056a000808b029013ed13da05dmr4512317pfk.35.1599731468294;
        Thu, 10 Sep 2020 02:51:08 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id e1sm2576534pfl.162.2020.09.10.02.51.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Sep 2020 02:51:07 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH v2 4/9] KVM: VMX: Don't freeze guest when event delivery causes an APIC-access exit
Date:   Thu, 10 Sep 2020 17:50:39 +0800
Message-Id: <1599731444-3525-5-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1599731444-3525-1-git-send-email-wanpengli@tencent.com>
References: <1599731444-3525-1-git-send-email-wanpengli@tencent.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

According to SDM 27.2.4, Event delivery causes an APIC-access VM exit.
Don't report internal error and freeze guest when event delivery causes
an APIC-access exit, it is handleable and the event will be re-injected
during the next vmentry.

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/vmx/vmx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 819c185..a544351 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6054,6 +6054,7 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 			(exit_reason != EXIT_REASON_EXCEPTION_NMI &&
 			exit_reason != EXIT_REASON_EPT_VIOLATION &&
 			exit_reason != EXIT_REASON_PML_FULL &&
+			exit_reason != EXIT_REASON_APIC_ACCESS &&
 			exit_reason != EXIT_REASON_TASK_SWITCH)) {
 		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
 		vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_DELIVERY_EV;
-- 
2.7.4

