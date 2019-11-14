Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D987FBCEB
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 01:17:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbfKNARj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Nov 2019 19:17:39 -0500
Received: from mail-pf1-f202.google.com ([209.85.210.202]:53137 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726564AbfKNARi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Nov 2019 19:17:38 -0500
Received: by mail-pf1-f202.google.com with SMTP id f20so3033611pfn.19
        for <kvm@vger.kernel.org>; Wed, 13 Nov 2019 16:17:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=BX7RT8qAkB+AYWbevuwN18lQM0QHX09qJQguHxmgnmY=;
        b=Alw++F/VhpvBDrSg3BlZomdOwgdEM++PB9tbLgs0ncIIzEWHM1tz8pvcPLzvcP92Ls
         EM2qa7v3tn6TxCOKg0msG2klSK67yMbNAUgiAjAwIEkCfvj/NdUSnCMZZAINkcAydiMy
         l7CNZ3g5tX6ujfTOFptQLx92g2YsRgFjytuDuvv5rO/bvWndu2O+CtZBHu7HWl8KWWWp
         7x8Co+OabbQQDPXfFxH86kimWWO7DUi3lvadsZ/AYczPWlW0S29OuHEeWC0UjUsal4el
         WXzVDZcbT4dhHSwSzGSB8S5vi1+JAqfPMS6NVDGf2120BfFiSNTMvWG8lqTfaML0IW4S
         RVYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=BX7RT8qAkB+AYWbevuwN18lQM0QHX09qJQguHxmgnmY=;
        b=crcsba+SM3lrRDUaBrjuywP2rBS9A5RM2fdcDKVMAYqQhbz7b2L4wJpz0GT0AD/0Hz
         ZTfiA7w+WzB+YN2HKz7eSsQ+D0kH9/XrS09MTttDmYAb+7TVcNy2NdhmWzUgJryXkdXY
         76/7CVRGI+TMG15Jii6+A5NKVIGVJg62SypiktHUSG7JMpyW1GoTw+3m228m7u656yW0
         HGm38Jc4pxPTnw/hijA9CpqdxT3RrX47eY2saKWCbJp+C2DJ7VWC03P8pXB4ck1m5bwK
         6eiz9lIRw8PgjOSlTkK17InVQwpmDwJVTxtQWIGP2S0aJ9GyLd4TDBzhS3xwVHlRvgX3
         k9Fw==
X-Gm-Message-State: APjAAAXFL0azCqsiT9vOSCyUFmj7J2h91hmyII8yz1CyKm3ZN8wPERfQ
        WvTbnjTDbFMVTRmp1vw9kVi8LlRIuZJ9NQU+YRSf6i/q24GsQ8fwCgehIzPjv8aCzZlO6PVE3LV
        pjXD76bODIHavCxWXWwdILXK5uBgNP3hgknD7s09cA+N67pkRUjiFr6v5kg==
X-Google-Smtp-Source: APXvYqw6DegNtUI5cRcWXUOA81/O7WE2fG9ibAJ1flbxMp23RvhMwub05oYde9aQZL7xd5kVnuaq2DXuioE=
X-Received: by 2002:a63:6286:: with SMTP id w128mr6816399pgb.290.1573690655957;
 Wed, 13 Nov 2019 16:17:35 -0800 (PST)
Date:   Wed, 13 Nov 2019 16:17:16 -0800
In-Reply-To: <20191114001722.173836-1-oupton@google.com>
Message-Id: <20191114001722.173836-3-oupton@google.com>
Mime-Version: 1.0
References: <20191114001722.173836-1-oupton@google.com>
X-Mailer: git-send-email 2.24.0.rc1.363.gb1bccd3e3d-goog
Subject: [PATCH v5 2/8] KVM: nVMX: Check GUEST_IA32_PERF_GLOBAL_CTRL on VM-Entry
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
Reviewed-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
---
 arch/x86/kvm/vmx/nested.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index e76eb4f07f6c..c19975c57d69 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -10,6 +10,7 @@
 #include "hyperv.h"
 #include "mmu.h"
 #include "nested.h"
+#include "pmu.h"
 #include "trace.h"
 #include "x86.h"
 
@@ -2779,6 +2780,11 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
 		return -EINVAL;
 	}
 
+	if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL) &&
+	    CC(!kvm_valid_perf_global_ctrl(vcpu_to_pmu(vcpu),
+					   vmcs12->guest_ia32_perf_global_ctrl)))
+		return -EINVAL;
+
 	/*
 	 * If the load IA32_EFER VM-entry control is 1, the following checks
 	 * are performed on the field for the IA32_EFER MSR:
-- 
2.24.0.rc1.363.gb1bccd3e3d-goog

