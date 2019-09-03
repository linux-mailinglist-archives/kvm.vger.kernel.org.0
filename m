Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A053A7637
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2019 23:31:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727113AbfICVbP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Sep 2019 17:31:15 -0400
Received: from mail-yb1-f201.google.com ([209.85.219.201]:38636 "EHLO
        mail-yb1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726441AbfICVbO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Sep 2019 17:31:14 -0400
Received: by mail-yb1-f201.google.com with SMTP id h189so9305411ybc.5
        for <kvm@vger.kernel.org>; Tue, 03 Sep 2019 14:31:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Opg5K1QfrL8nEMY8t4QOtAKo0xuR0xFxDl5Hh7Z9H/0=;
        b=wJsF5wiqkwDo/VU8kEbu+p977nudq6pCWyWe41pRvirGJnJaUzOw7HthPtkspz8/6U
         RMxmstQlA5l9WVs6IJ+Li6SZRdUAL/nXFDbc+qNc6TeKMiQnb3aY5TWn7TICTiAmAz1g
         ISFidWuoGsoO5yOZpFSWzBgaC+pbYfg6defnT82T2E9GMc5bLSW/HJA3FDce85UonaJ2
         WG78PWsng7x/HbHb5HxU4+CYVUq7PkyegjhIUNFkljfXJpjB1061z5zsuxvhvBKxCzoR
         4DyXsDFPoxMXnjeTu8MhLI821zo93Td+/TU82DVLwOzisdCaUT4V54P5LcRZeyrnG4Z7
         7DZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Opg5K1QfrL8nEMY8t4QOtAKo0xuR0xFxDl5Hh7Z9H/0=;
        b=rpZ7OiJ1L8xAoTBlHUrALNHZGcBBd1KMkm/tEEDnE+PsSAdiiHq3LvQGAvF65Ew8q9
         LXA0ZwGWkzo+gToAFUMiMpJYILNLv5M/Y/Ct9iLYGw5+NQsmoxo3VRU2IiEwtKwCeS1N
         YMDlw5AJl1ephX0XXBvG8h1VIZ8RE7uy7MMJI7lvSTNBOetLJ+YumLlOu6HTCBMdYCot
         D4ntH468EPlHy7QRufRjIYk1T80IAFp8OwE1glIRjYi3ukF9GMuk+L7y/Mseqcu7gzJe
         dkNZED4fkKHO0vNYDXOTX28ldF2hy/W4gA42E1ZpAP3aC4H8SPYh8cb4yV023NaukXMz
         CZ8g==
X-Gm-Message-State: APjAAAXcdbz/YkcULga5VgHJXrlreRlDeu0A9XK5Fe6HHBd8rJ1In2or
        tdnq4QZaCLrbNdRKFCjlvhQrxcvbbBIxTgz7/wYxrtcON9h5XY5MFQ82V3oYc6cHZGP7gO0uWXO
        +XJDQU6BvgAuONDVT36UNhRZnmeNDfDwtMTaLGp4OgzVdYTIg5+PRBKK8nw==
X-Google-Smtp-Source: APXvYqzboWHGWDNuSGO7hb8QTKTL3v4rt6etY3vc85pFdmKqWKlB9IGvS5WPk3Ns6EOiwGsELbj8+z6d00Q=
X-Received: by 2002:a81:280b:: with SMTP id o11mr12422297ywo.251.1567546273674;
 Tue, 03 Sep 2019 14:31:13 -0700 (PDT)
Date:   Tue,  3 Sep 2019 14:30:40 -0700
In-Reply-To: <20190903213044.168494-1-oupton@google.com>
Message-Id: <20190903213044.168494-5-oupton@google.com>
Mime-Version: 1.0
References: <20190903213044.168494-1-oupton@google.com>
X-Mailer: git-send-email 2.23.0.187.g17f5b7556c-goog
Subject: [PATCH v2 4/8] KVM: nVMX: check GUEST_IA32_PERF_GLOBAL_CTRL on VM-Entry
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        "=?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?=" <rkrcmar@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, Peter Shier <pshier@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add condition to nested_vmx_check_guest_state() to check the validity of
GUEST_IA32_PERF_GLOBAL_CTRL. Per Intel's SDM Vol 3 26.3.1.1:

  If the "load IA32_PERF_GLOBAL_CTRL" VM-entry control is 1, bits
  reserved in the IA32_PERF_GLOBAL_CTRL MSR must be 0 in the field for that
  register.

Suggested-by: Jim Mattson <jmattson@google.com>
Co-developed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/x86/kvm/vmx/nested.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 9ba90b38d74b..6c3aa3bcede3 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -10,6 +10,7 @@
 #include "hyperv.h"
 #include "mmu.h"
 #include "nested.h"
+#include "pmu.h"
 #include "trace.h"
 #include "x86.h"
 
@@ -2732,6 +2733,7 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
 					u32 *exit_qual)
 {
 	bool ia32e;
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 
 	*exit_qual = ENTRY_FAIL_DEFAULT;
 
@@ -2748,6 +2750,11 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
 		return -EINVAL;
 	}
 
+	if (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL &&
+	    !kvm_is_valid_perf_global_ctrl(pmu,
+					   vmcs12->guest_ia32_perf_global_ctrl))
+		return -EINVAL;
+
 	/*
 	 * If the load IA32_EFER VM-entry control is 1, the following checks
 	 * are performed on the field for the IA32_EFER MSR:
-- 
2.23.0.187.g17f5b7556c-goog

