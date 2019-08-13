Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABA4D8BADC
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2019 15:54:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729444AbfHMNyF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Aug 2019 09:54:05 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:54525 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729190AbfHMNxo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Aug 2019 09:53:44 -0400
Received: by mail-wm1-f66.google.com with SMTP id p74so1601922wme.4
        for <kvm@vger.kernel.org>; Tue, 13 Aug 2019 06:53:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=N0JnsZY26PRvpYDGTc2Pe4GLRcJAxgHbDsa9zV94zQU=;
        b=TLPlAiWh1g74rKGBS1don05fydsk17lEN8MVq+WmJiiHdgs7YfdtVHIhpZKBDOkwNK
         Us15jTuxd6EKcuwzb0VFeo44QUzEy2YSLxZwdoEOk2gjs/quko8VskjUB2d/0EostaDH
         YMuZIWAOJSDAmhpynH/VvAq7H9cQ1+mC/nExcNSCtGjwh2clsPRmkoZ4IgA1NJcmdzzt
         Dax/su8R5/506yDo9chf5O8AZkDgf4T68SQR81pgJS+MxBQ8R6qZ0sfLDneA0EITyhHt
         +Ffc1TO+x123nUSpjhQgBIWXEYVHSvecGHuUy0T8P1HZE9Kz4nDyKm9Cht6/QoeuGYcU
         ud7w==
X-Gm-Message-State: APjAAAX91KvSVJBThVMJvISQW5YiONnAKMWWXAkh9QIyG4Fr98/eU9ML
        Y0NCbXf3YAxGuOEb36QQSkarZe1pEMo=
X-Google-Smtp-Source: APXvYqx7LOYSOyFaXYCeHH4qMpq9142a94Tu9q092qneV6hhDoXpP+eyaFhRAGlLPcVNfQqsCLla0Q==
X-Received: by 2002:a1c:c915:: with SMTP id f21mr3139239wmb.173.1565704422729;
        Tue, 13 Aug 2019 06:53:42 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id k1sm15205820wru.49.2019.08.13.06.53.41
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 13 Aug 2019 06:53:42 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v4 3/7] x86: KVM: clear interrupt shadow on EMULTYPE_SKIP
Date:   Tue, 13 Aug 2019 15:53:31 +0200
Message-Id: <20190813135335.25197-4-vkuznets@redhat.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190813135335.25197-1-vkuznets@redhat.com>
References: <20190813135335.25197-1-vkuznets@redhat.com>
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
index e8f797fe9d9e..c2409d06c114 100644
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

