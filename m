Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0EF382B69
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2019 08:03:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731852AbfHFGC0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Aug 2019 02:02:26 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:35712 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731594AbfHFGB4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Aug 2019 02:01:56 -0400
Received: by mail-wr1-f68.google.com with SMTP id k2so702564wrq.2
        for <kvm@vger.kernel.org>; Mon, 05 Aug 2019 23:01:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yAuOdcFvKcJE+TJQBnlj7YZrsenOZm0DkL2Ya79xDlk=;
        b=sSj7ZgYQv3h7JuYXxxeg6yGVWKzoOVVEJCTfbIElKxsTE5G+89jtRAKXXeshQ5ooWu
         TjIFmL4yjxuJjlp+ZqpbTgzgXHnfZtA+mmIssCXqgmMOosop7gNhvDK3GhqEgLyNTV6S
         JgJsCDRd90yNDPYXUgjbFVtWGozYfMjkPMyK1VU4mcNctfEqEIYP31MKF5Vv9eXQEae3
         zwhcaCZt4SMEnOViFuv3zW5SGAnaOu6FBHUqswo9HZiKsOAUo3Bu31BepRMTx2DZPO6k
         jHy8kdQkkUuHbXx8MAzQFjwK5fzd0InV/VfDtmZRZiX7jjFghmfUw11u6/IZwZ9V2pE9
         NfLA==
X-Gm-Message-State: APjAAAXYmfKdYtpbJ/mi8zVyifd8t5zvazTj4CJlpm8NwkImpI4nkO/f
        0CteYSH3bIx/C4WgqCJv+vGfNstbeVc=
X-Google-Smtp-Source: APXvYqwiXF1AxGJU6sydSioAj2Kx1NEbKgbGzojrBQjdzJNbV+M2zF0ErfZ5H9XpyXimTCxAOZa3Bg==
X-Received: by 2002:adf:db09:: with SMTP id s9mr1692425wri.214.1565071314493;
        Mon, 05 Aug 2019 23:01:54 -0700 (PDT)
Received: from vitty.brq.redhat.com (ip-89-176-127-93.net.upcbroadband.cz. [89.176.127.93])
        by smtp.gmail.com with ESMTPSA id r5sm94216756wmh.35.2019.08.05.23.01.53
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 05 Aug 2019 23:01:54 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v2 1/5] x86: KVM: svm: don't pretend to advance RIP in case wrmsr_interception() results in #GP
Date:   Tue,  6 Aug 2019 08:01:46 +0200
Message-Id: <20190806060150.32360-2-vkuznets@redhat.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190806060150.32360-1-vkuznets@redhat.com>
References: <20190806060150.32360-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

svm->next_rip is only used by skip_emulated_instruction() and in case
kvm_set_msr() fails we rightfully don't do that. Move svm->next_rip
advancement to 'else' branch to avoid creating false impression that
it's always advanced (and make it look like rdmsr_interception()).

This is a preparatory change to removing hardcoded RIP advancement
from instruction intercepts, no functional change.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/svm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 7eafc6907861..7e843b340490 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -4447,13 +4447,13 @@ static int wrmsr_interception(struct vcpu_svm *svm)
 	msr.index = ecx;
 	msr.host_initiated = false;
 
-	svm->next_rip = kvm_rip_read(&svm->vcpu) + 2;
 	if (kvm_set_msr(&svm->vcpu, &msr)) {
 		trace_kvm_msr_write_ex(ecx, data);
 		kvm_inject_gp(&svm->vcpu, 0);
 		return 1;
 	} else {
 		trace_kvm_msr_write(ecx, data);
+		svm->next_rip = kvm_rip_read(&svm->vcpu) + 2;
 		return kvm_skip_emulated_instruction(&svm->vcpu);
 	}
 }
-- 
2.20.1

