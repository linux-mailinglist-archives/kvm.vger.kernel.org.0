Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EADF82B68
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2019 08:03:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731832AbfHFGCP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Aug 2019 02:02:15 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37683 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731769AbfHFGB7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Aug 2019 02:01:59 -0400
Received: by mail-wr1-f65.google.com with SMTP id n9so61492493wrr.4
        for <kvm@vger.kernel.org>; Mon, 05 Aug 2019 23:01:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5IKaQpUKaGFD2eXbnxPYilppDEMXmw1IQnFzmbG2kIs=;
        b=FmQY42PIFgbq1m29h28e8p7F6Q4BOschXZVmqvl4UKUmXAzBMa7D4FgyybprmMGeys
         4Ae83qWWclALTyLbD+HueK7kMYp6x+pjV3RhlZodfkH4WS1T+FziEZ+IEea7UtYeHGXR
         j/0jeA51/wnipIvnJ8bepw3g9GaxY7DEiGLt2YsQiykeq0X4dhP2iSOIi18bjJKl0m+G
         SM6xTiS75D4aVeY/TqDdxyKtN3IWLUzQzeROwxseE5sVqZ1PYYl58hLWS4B7ypal7Nur
         GOme9BJNy7jKIDHOndNVK253iw2Qswgy2OIs+bZWQ0lZ7zi2I0WzQscs76FtV7W6xODW
         yIEw==
X-Gm-Message-State: APjAAAXs7BjCPjk5QFDwCw/iDwjCB617a+L2yzgWPAGuV3xuVw8QFnpv
        93LWvj9gewg6CJEBButUNZC9/czCjQQ=
X-Google-Smtp-Source: APXvYqzfhabQ3uNqXVjy7dkBXglvC99jIMAh3DG8YLE7Sf8cSzYx13uemFaSwRlYO2vqFDyEOkGY7w==
X-Received: by 2002:adf:eacf:: with SMTP id o15mr2364192wrn.171.1565071316992;
        Mon, 05 Aug 2019 23:01:56 -0700 (PDT)
Received: from vitty.brq.redhat.com (ip-89-176-127-93.net.upcbroadband.cz. [89.176.127.93])
        by smtp.gmail.com with ESMTPSA id r5sm94216756wmh.35.2019.08.05.23.01.55
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 05 Aug 2019 23:01:56 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v2 3/5] x86: KVM: clear interrupt shadow on EMULTYPE_SKIP
Date:   Tue,  6 Aug 2019 08:01:48 +0200
Message-Id: <20190806060150.32360-4-vkuznets@redhat.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190806060150.32360-1-vkuznets@redhat.com>
References: <20190806060150.32360-1-vkuznets@redhat.com>
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
  (static_cpu_has(X86_FEATURE_HYPERVISOR) case) we forget to clear
  interrupt shadow.

Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/x86.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c6d951cbd76c..eac8253d84d2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6537,6 +6537,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu,
 		kvm_rip_write(vcpu, ctxt->_eip);
 		if (ctxt->eflags & X86_EFLAGS_RF)
 			kvm_set_rflags(vcpu, ctxt->eflags & ~X86_EFLAGS_RF);
+		kvm_x86_ops->set_interrupt_shadow(vcpu, 0);
 		return EMULATE_DONE;
 	}
 
-- 
2.20.1

