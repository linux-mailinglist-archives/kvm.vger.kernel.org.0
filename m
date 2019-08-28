Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC141A0E59
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2019 01:41:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727195AbfH1Xlu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Aug 2019 19:41:50 -0400
Received: from mail-yw1-f73.google.com ([209.85.161.73]:43168 "EHLO
        mail-yw1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727102AbfH1Xlu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Aug 2019 19:41:50 -0400
Received: by mail-yw1-f73.google.com with SMTP id a12so1156793ywm.10
        for <kvm@vger.kernel.org>; Wed, 28 Aug 2019 16:41:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=L7ofrvxz7KTbwrithNZ6hvYCCs95MI4yDOF6MJ9BBSE=;
        b=AhDx5tuGaT4Z628duiOtdKJQ3m5WBQmiw7/AalHacnoUDKwvDRBEK83GnzQMvwOVmr
         OccPA+FgEsmU9J7AB5Gu0bvUKScH6RrNtEfciO6l+zz++U6aEbVQAdZslri8fnlvcHpo
         VHth2s8uSnw045OMuJG8lLMBoA73fmJG0OpLeiV/Euqyr5K1PJZzzEtNJv+EK6gwIY2p
         XzThVfjCa7gEc/PUBxitgCfIZiySjE7pvZxXoWa0QpqsPOZoy4FVT/mzZUtztAGHjpT5
         9UtA36UtsjD6OOsyRI9jcN6/mqSEmt4zCWX9aL5d/Z0yM7bL/wUHgYiXteMoEoiFWa5Q
         /cpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=L7ofrvxz7KTbwrithNZ6hvYCCs95MI4yDOF6MJ9BBSE=;
        b=r+fl593thCrVxG9f8sgM1uLOjhPGP4DBfiiIR2qYhPDokCwGh+WTVNi35LdFVXT9Q3
         H3olzKaw/14n9qVLiuwP9x/GtHXUfIx97lhnHaXxdd1E7pGDto4GhVeyq0tb0JiVJLRI
         kFRFaiSmh/zmgXIH2Lxogrp5uQkq2FMBubhAtnTtW1lQZX9gAnp8IDbJLkonVhGgXBXJ
         ImJ6Y45VN3w44gGpAqAq+Qc8609PzfkD4XkjVDfbP9PwU/5S5sIztiYQmYdFRiEgmS56
         Q6DAFE6SAi0vCd1pyoJkeF+9FWIAesuFy74t9rVdxKOdNMTZqdc0KTgF3wWpBs+glpOD
         AZFw==
X-Gm-Message-State: APjAAAXuBgyrKALY++8ZChrOJXr1lnL3T+EjGgFQB8FumSWl2UdIQ3rF
        hDisGzmvWzrRorGV6I31jTlMAQIH+gjrLteYOd3+1egW9zwxnyeEnaPShWukz4aSkoFqwIfVE1W
        1FcP9klOoepYLhhOkL2Sb6zXTj69KUJFr0Toi3YIjbkBDvSQsADnstHUE4A==
X-Google-Smtp-Source: APXvYqzlLRkxJfm2QHJz11jP8GYSPDDDnwkOtEVFxQBOo6dF7SwFgZH5+gCOjXjv3D+u9oB/n69kt3TdhjM=
X-Received: by 2002:a25:f202:: with SMTP id i2mr4987549ybe.462.1567035709182;
 Wed, 28 Aug 2019 16:41:49 -0700 (PDT)
Date:   Wed, 28 Aug 2019 16:41:31 -0700
In-Reply-To: <20190828234134.132704-1-oupton@google.com>
Message-Id: <20190828234134.132704-5-oupton@google.com>
Mime-Version: 1.0
References: <20190828234134.132704-1-oupton@google.com>
X-Mailer: git-send-email 2.23.0.187.g17f5b7556c-goog
Subject: [PATCH 4/7] KVM: nVMX: check GUEST_IA32_PERF_GLOBAL_CTRL on VM-Entry
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        "=?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?=" <rkrcmar@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to the SDM 26.3.1.1, "If the "load IA32_PERF_GLOBAL_CTRL" VM-entry
control is 1, bits reserved in the IA32_PERF_GLOBAL_CTRL MSR must be 0 in the
field for that register".

Adding condition to nested_vmx_check_guest_state() to check the validity of
GUEST_IA32_PERF_GLOBAL_CTRL if the "load IA32_PERF_GLOBAL_CTRL" bit is
set on the VM-entry control.

Suggested-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/x86/kvm/vmx/nested.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 9ba90b38d74b..8d6f0144b1bd 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -10,6 +10,7 @@
 #include "hyperv.h"
 #include "mmu.h"
 #include "nested.h"
+#include "pmu.h"
 #include "trace.h"
 #include "x86.h"
 
@@ -2748,6 +2749,11 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
 		return -EINVAL;
 	}
 
+	if (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL &&
+	    !kvm_is_valid_perf_global_ctrl(vcpu,
+					   vmcs12->guest_ia32_perf_global_ctrl))
+		return -EINVAL;
+
 	/*
 	 * If the load IA32_EFER VM-entry control is 1, the following checks
 	 * are performed on the field for the IA32_EFER MSR:
-- 
2.23.0.187.g17f5b7556c-goog

