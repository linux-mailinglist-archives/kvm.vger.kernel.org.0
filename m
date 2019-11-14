Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 489E2FBCEC
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 01:17:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726923AbfKNARk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Nov 2019 19:17:40 -0500
Received: from mail-pg1-f202.google.com ([209.85.215.202]:41250 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726605AbfKNARj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Nov 2019 19:17:39 -0500
Received: by mail-pg1-f202.google.com with SMTP id e6so3141207pgc.8
        for <kvm@vger.kernel.org>; Wed, 13 Nov 2019 16:17:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=wyU7X5+KZ1eW/8rXzi076f3hAP9H70n2FWQEO44IkUo=;
        b=WlDhbmzzXfj/My+sRcsc/e03UkeLMxc9jk6m56WS2CofWmA1sWtPxTuzUpA9vJsYXh
         xoaeZu0Z0VdoJUpfKMdppMZaqW6ntokmvqNsfr26X2KCJumq9DyP4zMY9HzK2d/0I7ZR
         Afvofz2+W06OeuTi49jbw/neAJJpw6Mh+4aAICi8e3xZLgd2D675pi6mFZKGaXqSFFn4
         c6GrjF0Pk1kQ6g0s9vjdUkT+QxA5pz8Yg9HI7MOPg79lVVbCUCnaxZXF8tAJ884nIis6
         5F9FsQVxRR8jTegCW2354RZElM4lvBweVQsvqM6ynL8oN6Zwr5cWwL5BB27qhHZQdPfb
         QnPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=wyU7X5+KZ1eW/8rXzi076f3hAP9H70n2FWQEO44IkUo=;
        b=EBDnoc/h6Vuft8WBgYjE3IIrGOq1OHaNTUDPiX2oFWb1jw2YlYaTf95yLHvqSLRLC7
         Yezc3Oj6C33Nk1zALfv/zlugTNQcZw5WptwzSOSrwUG1x5TDkY2y0LOH9JJSw1P9kk7x
         opPgum9nUqECsLi0B7+q2kmXitvqsLHgwxa8v+D5lb2cJ8A3xQ2qIzKsJNPCQTu0dtyA
         P5X1GLMrBEwWoK0ia/bTWRuSk9CN9zZkPC/mi63t0ocGQG5382SMtQErgDVhnUZEDm+G
         6T05eKylqVtP+HK7EU5Hxcve3Cs5dp68zYkzTNuSy9SE4dJNyvdkJOmdkYTtOs4bE4RY
         1tqw==
X-Gm-Message-State: APjAAAWlc+8VokhzKHzG65We9ZgKK/MCL5OuM/NKNSrbByrffdbFylNO
        QWhcObfrcLH1s+zZSlC8HcLRPeryUKs3D/ybLhMsO1zdZCzNOmuEk5F4fve7hsfDDSpv/1JsNBT
        JXL+9Ts4F7fVISjQBxj/p/KoS6JdNR6uCo3y9ediS6zdrVirZknLiTYAXKg==
X-Google-Smtp-Source: APXvYqzKQwOjYeTIEiDFuKyqYaAeZJUWI/ozSTmKYGbOn2qX4C0tZ/6R0cRerj4IAC9Hp/3rLaLfSmi4dog=
X-Received: by 2002:a63:9d0f:: with SMTP id i15mr6975542pgd.286.1573690658232;
 Wed, 13 Nov 2019 16:17:38 -0800 (PST)
Date:   Wed, 13 Nov 2019 16:17:17 -0800
In-Reply-To: <20191114001722.173836-1-oupton@google.com>
Message-Id: <20191114001722.173836-4-oupton@google.com>
Mime-Version: 1.0
References: <20191114001722.173836-1-oupton@google.com>
X-Mailer: git-send-email 2.24.0.rc1.363.gb1bccd3e3d-goog
Subject: [PATCH v5 3/8] KVM: nVMX: Check HOST_IA32_PERF_GLOBAL_CTRL on VM-Entry
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

Add a consistency check on nested vm-entry for host's
IA32_PERF_GLOBAL_CTRL from vmcs12. Per Intel's SDM Vol 3 26.2.2:

  If the "load IA32_PERF_GLOBAL_CTRL"
  VM-exit control is 1, bits reserved in the IA32_PERF_GLOBAL_CTRL
  MSR must be 0 in the field for that register"

Suggested-by: Jim Mattson <jmattson@google.com>
Co-developed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Signed-off-by: Oliver Upton <oupton@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
---
 arch/x86/kvm/vmx/nested.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index c19975c57d69..f9ae7bc0a421 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2665,6 +2665,11 @@ static int nested_vmx_check_host_state(struct kvm_vcpu *vcpu,
 	    CC(!kvm_pat_valid(vmcs12->host_ia32_pat)))
 		return -EINVAL;
 
+	if ((vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL) &&
+	    CC(!kvm_valid_perf_global_ctrl(vcpu_to_pmu(vcpu),
+					   vmcs12->host_ia32_perf_global_ctrl)))
+		return -EINVAL;
+
 #ifdef CONFIG_X86_64
 	ia32e = !!(vcpu->arch.efer & EFER_LMA);
 #else
-- 
2.24.0.rc1.363.gb1bccd3e3d-goog

