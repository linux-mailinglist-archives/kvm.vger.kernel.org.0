Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C35E1CB90E
	for <lists+kvm@lfdr.de>; Fri,  8 May 2020 22:37:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727100AbgEHUhA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 May 2020 16:37:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726811AbgEHUhA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 8 May 2020 16:37:00 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F335C061A0C
        for <kvm@vger.kernel.org>; Fri,  8 May 2020 13:37:00 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id j4so3535353ybj.20
        for <kvm@vger.kernel.org>; Fri, 08 May 2020 13:37:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Qcb4vvcQqRXsDBmKyBIQkPZTiuE/XsF+tWw9+Q+7+I0=;
        b=Qk7wdSMsN5vkbs1NfrrX4UKqwjbWzalid1t69mr1A/Q/Q6B8d/wND5S285btB7y1MK
         PWoULzyfLqq7yUCfYmmBV4GitfC8aY5/hDsix5zpZghRJSb6jzDyuNKwt8vtd78o4NVM
         e9eJLqqFSUIUKs1OZXu0s66Isaeo/1+hp5wMH+1DGjLHnMWDL6+GpJbwji7Gcx2pB7bl
         TKV6NeplKgjKeDkEQ4jB5ULWeMboLQODRfJFl958H+lt+kFY6TL+pEMVjmfdPznnUPmf
         G8djp0QvjD2+Rzv2GoEN48gIqkekQUWm+Wsq/kKQMd02zIALC8MEABPnEEYiSJZL30q+
         IgWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Qcb4vvcQqRXsDBmKyBIQkPZTiuE/XsF+tWw9+Q+7+I0=;
        b=I8norwl+JvuiQtew2Flz7DpNf167iE7A5cIQFizaoQkafTY//O9YP0OdXJjt0JN1Gg
         zc5k4c78egzKJ9ay+8kJoCfXMzNDdUb9DQEq1MuNPWrwwin3GygCUXWLIZDINKYE5Zva
         LbO3uDGPnGUyqe7X62mWHFOjABE/3FJZ/bkzSANOpSaqTu2W92z4yzVxRrZSJaLIhfif
         vnDhyl52AIAeKvUvr3FJWtZwiPFZRNCLlgHvlKVPsassVMPXOZyPVrlv0MhgKsA+Bs4b
         ERVBuYBKD/D8bxAdT6eBr2PxF/NoVrYxGuYZes/yi0nPNUphy8WCi8FrwYt+0SSMSOrJ
         8sIQ==
X-Gm-Message-State: AGi0PuYbdtbqQzin2C+bqjVerYpkGzw1tRV4QST6M46A5pncNBcOwH6G
        SQXiDT/LGnKECUU5rk4lfZuQDxujg+4s5OyiPumdKupC4IkRiv8dEeQwWqXSZbZgyVB88EkRfNr
        Z3YTAYhiHFoMXKN/3UsuVK6paTMCpAgkBYR5wvSzTs/25/RBuladwxWzCBiviHZw=
X-Google-Smtp-Source: APiQypLLg2dj+v1i92RV4I4X9Okba9Ag3baU2Adrb5e5XceLCXCuLRYuq1IX6g5Y7lVid8C2citxOzJjh/nxKQ==
X-Received: by 2002:a25:9a42:: with SMTP id r2mr7472703ybo.281.1588970219625;
 Fri, 08 May 2020 13:36:59 -0700 (PDT)
Date:   Fri,  8 May 2020 13:36:41 -0700
In-Reply-To: <20200508203643.85477-1-jmattson@google.com>
Message-Id: <20200508203643.85477-2-jmattson@google.com>
Mime-Version: 1.0
References: <20200508203643.85477-1-jmattson@google.com>
X-Mailer: git-send-email 2.26.2.645.ge9eca65c58-goog
Subject: [PATCH 1/3] KVM: nVMX: Really make emulated nested preemption timer pinned
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The PINNED bit is ignored by hrtimer_init. It is only considered when
starting the timer.

When the hrtimer isn't pinned to the same logical processor as the
vCPU thread to be interrupted, the emulated VMX-preemption timer
often fails to adhere to the architectural specification.

Fixes: f15a75eedc18e ("KVM: nVMX: make emulated nested preemption timer pinned")
Signed-off-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
Reviewed-by: Oliver Upton <oupton@google.com>
---
 arch/x86/kvm/vmx/nested.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index fd78ffbde644..1f7fe6f47cbc 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2041,7 +2041,7 @@ static void vmx_start_preemption_timer(struct kvm_vcpu *vcpu)
 	preemption_timeout *= 1000000;
 	do_div(preemption_timeout, vcpu->arch.virtual_tsc_khz);
 	hrtimer_start(&vmx->nested.preemption_timer,
-		      ns_to_ktime(preemption_timeout), HRTIMER_MODE_REL);
+		      ns_to_ktime(preemption_timeout), HRTIMER_MODE_REL_PINNED);
 }
 
 static u64 nested_vmx_calc_efer(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
-- 
2.26.2.645.ge9eca65c58-goog

