Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D1E88681C
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2019 19:31:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404463AbfHHRba (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Aug 2019 13:31:30 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43159 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404381AbfHHRbC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Aug 2019 13:31:02 -0400
Received: by mail-wr1-f65.google.com with SMTP id p13so21138593wru.10
        for <kvm@vger.kernel.org>; Thu, 08 Aug 2019 10:31:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5QNclWHn7I50/yByYJpJAi95dRXHnd68QPD5QLdpAaY=;
        b=nap9Oj+Pk431CMmMG0cA42LnFqNGGuI2zvsQNkbUn0RfJvpxDQ1KW9Ag94lGNaaJrw
         lmRAm9fQaM9d89t2wvI9QWOL2LxvbCshddbl8jf7pF5hky57jfBrPGnEzLBCFkexGs04
         jBabbpyNuHoH4HO4Fq3Pd23CjEyvL4WOaWzfC58DbkjxLIWufuVDnJRZDC4mvAdajcI1
         s6jMqG+0AURH/xJv2YY2IPXFjpNWkumpc05TN+/4i/c1A6GaqvhvkD140G/F1DeEoBXk
         PNNtgimDELfUA7+leLOF7Cf0FxfCCCNb6w4CeKdAMAJViKOfp4vhU/EkGwQeMF/rLgat
         AgSw==
X-Gm-Message-State: APjAAAV85ZFDss2vjcmNpe4YcB5ZU497p2ZdSi+rVB/2Uo7oC0qZ4lAY
        yG2ebvAtW/9u7i48Su8vI6+Zo1LHZ1U=
X-Google-Smtp-Source: APXvYqzRg2bisd+LGUzlteXdIflm96RWkFrIQbtPx50BZLXO8WM7jtxu3zCYfl0aQY7Vo371sdiuuA==
X-Received: by 2002:a05:6000:12c3:: with SMTP id l3mr14769850wrx.100.1565285459920;
        Thu, 08 Aug 2019 10:30:59 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id g25sm2136859wmk.39.2019.08.08.10.30.58
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 10:30:59 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v3 3/7] x86: KVM: clear interrupt shadow on EMULTYPE_SKIP
Date:   Thu,  8 Aug 2019 19:30:47 +0200
Message-Id: <20190808173051.6359-4-vkuznets@redhat.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190808173051.6359-1-vkuznets@redhat.com>
References: <20190808173051.6359-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When doing x86_emulate_instruction(EMULTYPE_SKIP) interrupt shadow has to
be cleared if and only if the skipping is successful.

There are two immediate issues:
- In SVM skip_emulated_instruction() we are not zapping interrupt shadow
  in case kvm_emulate_instruction(EMULTYPE_SKIP) is used to advance RIP
  (!nrpip_save).
- In VMX handle_ept_misconfig() when running as a nested hypervisor we
  (static_cpu_has(X86_FEATURE_HYPERVISOR) case) forget to clear interrupt
  shadow.

Note that we intentionally don't handle the case when the skipped
instruction is supposed to prolong the interrupt shadow ("MOV/POP SS") as
skip-emulation of those instructions should not happen under normal
circumstances.

Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/x86.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a97818b1111d..50e0b25092c7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6539,6 +6539,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu,
 		kvm_rip_write(vcpu, ctxt->_eip);
 		if (ctxt->eflags & X86_EFLAGS_RF)
 			kvm_set_rflags(vcpu, ctxt->eflags & ~X86_EFLAGS_RF);
+		kvm_x86_ops->set_interrupt_shadow(vcpu, 0);
 		return EMULATE_DONE;
 	}
 
-- 
2.20.1

