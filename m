Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D784F8BAD1
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2019 15:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729364AbfHMNxo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Aug 2019 09:53:44 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36159 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729350AbfHMNxn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Aug 2019 09:53:43 -0400
Received: by mail-wr1-f67.google.com with SMTP id r3so14107260wrt.3
        for <kvm@vger.kernel.org>; Tue, 13 Aug 2019 06:53:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=opuSm2G6gYcM4qXZGufoG5jzs7R2voT6tX4ZJqRDemo=;
        b=EaGIOKai9KBLVLgBTKzWiSfzD33jhMgdTLSKhaPKxgMs/P2Wx/AkOthD4EiOI3QLhf
         /w6g4HpJ4FI7sruMj6faac9sZYobROd4I8anpsNeQh8meqSD263raHn5tKK7iJ+JAdO/
         UQk2r0bo+R1Dudyh0AVoC08PgHq8ipDRmVb5H1QF0DbLaYlP9wIhynDn5ivdiqypOJGd
         EfVINFaPt/5si7PAEUNBDPCs+04RS4uHUZM8Pnc+2YAd7gF+EgEF3ANPi1T3cN3qD1jc
         c3tbBb7WizpfI54YrfBkji5D7cLADW5NueGrO8Aw1G4EuGw9SI7Kh3YPoesk03D3QyDg
         Fqvw==
X-Gm-Message-State: APjAAAV1Rt+s0f3SW6z9X0CfFW4lQldOBtjguWeUvV5Rk6W5ahgQDGf9
        jgUJzGz4Cw2kT2HQZPKFIcOwn6ulorg=
X-Google-Smtp-Source: APXvYqxtXKosjYcO7Vv1TlMyD9LAKM+5QU0Fz3e0Yt9evI2DYtMcnLuXEnv3H63ZtuXgUqzJd/G7/Q==
X-Received: by 2002:a5d:480e:: with SMTP id l14mr8323838wrq.96.1565704420950;
        Tue, 13 Aug 2019 06:53:40 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id k1sm15205820wru.49.2019.08.13.06.53.39
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 13 Aug 2019 06:53:40 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v4 1/7] x86: KVM: svm: don't pretend to advance RIP in case wrmsr_interception() results in #GP
Date:   Tue, 13 Aug 2019 15:53:29 +0200
Message-Id: <20190813135335.25197-2-vkuznets@redhat.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190813135335.25197-1-vkuznets@redhat.com>
References: <20190813135335.25197-1-vkuznets@redhat.com>
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
Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
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

