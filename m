Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2612E7D4C2
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2019 07:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729331AbfHAFOY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Aug 2019 01:14:24 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41188 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728774AbfHAFOY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Aug 2019 01:14:24 -0400
Received: by mail-wr1-f65.google.com with SMTP id c2so68850495wrm.8
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2019 22:14:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yAuOdcFvKcJE+TJQBnlj7YZrsenOZm0DkL2Ya79xDlk=;
        b=ff4VCGSYO6jCKrRHoNRfL6KoTAINoxuCi0242vGHdlVMU6LJ/1x/Nzl4wEaRceos6b
         WgqYkfulFpv/dVx/4BMdVbrMRZNj6cjRQ9qjMhY0vXwH8Dz9IWTquYHjoyfglP05oykd
         VhQ5ayDQUuyEDZHIg1urmzHYLa6EwnCmzU7ozxXNraR5dfppWqiPc4cmCQ64P5shdq8d
         9GjGywUqbN9fj35+KJh+L71bKxLKRcDoH7UR+aFYnny3Rirb5yjSTMhpbm7ra1OrGTjp
         eNDMNdjTDoFR3qs3ZIjnmxLPYc0n8IyAPQvy+s77vqlb6i2Xm6+6SiqpkMlEcZVdVq0p
         cDXw==
X-Gm-Message-State: APjAAAWOFbPFuLqZBaqIYilMp+DXYd9ikJG+pckvlTNtSMzvKakk2Xts
        IAZQRglLFP3cOGvmgXBz4phWxDCByDI=
X-Google-Smtp-Source: APXvYqxGr1k6z/5aukJhARWDztMaUzfRv7qON3x9aDo/AOjnn+DXp9dJsmkrTq0CaT2g5O1DakAPCA==
X-Received: by 2002:adf:f64a:: with SMTP id x10mr35053386wrp.287.1564636462452;
        Wed, 31 Jul 2019 22:14:22 -0700 (PDT)
Received: from vitty.brq.redhat.com (ip-89-176-127-93.net.upcbroadband.cz. [89.176.127.93])
        by smtp.gmail.com with ESMTPSA id a2sm73855351wmj.9.2019.07.31.22.14.21
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 31 Jul 2019 22:14:21 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH 1/5] x86: KVM: svm: don't pretend to advance RIP in case wrmsr_interception() results in #GP
Date:   Thu,  1 Aug 2019 07:14:14 +0200
Message-Id: <20190801051418.15905-2-vkuznets@redhat.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190801051418.15905-1-vkuznets@redhat.com>
References: <20190801051418.15905-1-vkuznets@redhat.com>
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

