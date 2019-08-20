Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90179964AE
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2019 17:36:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728618AbfHTPg3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Aug 2019 11:36:29 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:54941 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726550AbfHTPg3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Aug 2019 11:36:29 -0400
Received: by mail-wm1-f68.google.com with SMTP id p74so3014713wme.4;
        Tue, 20 Aug 2019 08:36:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:subject:date:message-id;
        bh=VMBAs+uLqXnI9IwrpGIH72gdXUySmwFWOLfMIvLIRqw=;
        b=Q3aduewAEjklJX9l3q7fNNeDNihlNGNa03YzufK5MLFbraHno5JHCLedoFBxcN7J4/
         wSb0yv7swMC4A/vgYZAWYg5Pnw/fEnpeCP/+/WD1VEyEdXh1+Clr4b9b/UhCFn4TT5ZA
         R0IzU1r6sFN8XS7Eh/OO1tb3V/+0atKTIROGIaGm4fgsK2QmVAt6CIIUD+ldWcqLNHrn
         1wew4naeyVY3ccq83vMBganN2mfBr35YkMJ7RxoIlqwi/YrNB8VNvpeNGqfn9A6AV4li
         QSAi+uo+6qc9rHQ4AQOVLT20v6lwviblYJvxzlqdkWcww2IY/HAjy3ofxccwdUPQePKx
         DY+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:subject:date:message-id;
        bh=VMBAs+uLqXnI9IwrpGIH72gdXUySmwFWOLfMIvLIRqw=;
        b=Rz9VBrU6vQ1FyfkMoi8IsbPY5r6YhgmZLNN5GebHr0TQT1TrCOHwJ40hapLyFfGqU4
         DoJnjEKhWE9fQjVMcI3BYKNXaZezitiVuT1V7MO9wiZE2rclzeXaIGZP+n4OIxLnP7rl
         R4iUmwXEEe5Kh6sBPRqfxNNbbrg5CO/LnBjI8h3QfsKtoBQSPan3DCVjqWuXqENE7KUs
         KfHxcRqvNc6pkX6L5e8WZSgCycQVKwmQk72JIG1xN8dmhEWTuS9+U57V5zdx0vUgMCgL
         BpnY1a3TFSO13Cx6nDb9f1jdy0qtXwKlgpLdQFHdIafUgTqAGfpa5eSsMw2T6K/gz1Z1
         6mow==
X-Gm-Message-State: APjAAAX0/SQo8zRWDnBjZay6VYbVSOupDc/TPyOPFmxq/Hhhd75AVoJp
        9h5CBxdjpsKjgEao94Wi8EH31bgi9zg=
X-Google-Smtp-Source: APXvYqzr+dnJ/vQhc/+wT4H+W8aeBVX2OjchyzrlmPtMEWY/2vhR0GSKORtdbgw8MfbzVEqN/xNVdA==
X-Received: by 2002:a7b:ce0b:: with SMTP id m11mr630379wmc.151.1566315386768;
        Tue, 20 Aug 2019 08:36:26 -0700 (PDT)
Received: from 640k.localdomain.com ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id v124sm587415wmf.23.2019.08.20.08.36.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 20 Aug 2019 08:36:26 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH] selftests: kvm: fix state save/load on processors without XSAVE
Date:   Tue, 20 Aug 2019 17:36:24 +0200
Message-Id: <1566315384-34848-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

state_test and smm_test are failing on older processors that do not
have xcr0.  This is because on those processor KVM does provide
support for KVM_GET/SET_XSAVE (to avoid having to rely on the older
KVM_GET/SET_FPU) but not for KVM_GET/SET_XCRS.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 tools/testing/selftests/kvm/lib/x86_64/processor.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 6cb34a0fa200..0a5e487dbc50 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -1060,9 +1060,11 @@ struct kvm_x86_state *vcpu_save_state(struct kvm_vm *vm, uint32_t vcpuid)
         TEST_ASSERT(r == 0, "Unexpected result from KVM_GET_XSAVE, r: %i",
                 r);
 
-	r = ioctl(vcpu->fd, KVM_GET_XCRS, &state->xcrs);
-        TEST_ASSERT(r == 0, "Unexpected result from KVM_GET_XCRS, r: %i",
-                r);
+	if (kvm_check_cap(KVM_CAP_XCRS)) {
+		r = ioctl(vcpu->fd, KVM_GET_XCRS, &state->xcrs);
+		TEST_ASSERT(r == 0, "Unexpected result from KVM_GET_XCRS, r: %i",
+			    r);
+	}
 
 	r = ioctl(vcpu->fd, KVM_GET_SREGS, &state->sregs);
         TEST_ASSERT(r == 0, "Unexpected result from KVM_GET_SREGS, r: %i",
@@ -1103,9 +1105,11 @@ void vcpu_load_state(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_x86_state *s
         TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_XSAVE, r: %i",
                 r);
 
-	r = ioctl(vcpu->fd, KVM_SET_XCRS, &state->xcrs);
-        TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_XCRS, r: %i",
-                r);
+	if (kvm_check_cap(KVM_CAP_XCRS)) {
+		r = ioctl(vcpu->fd, KVM_SET_XCRS, &state->xcrs);
+		TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_XCRS, r: %i",
+			    r);
+	}
 
 	r = ioctl(vcpu->fd, KVM_SET_SREGS, &state->sregs);
         TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_SREGS, r: %i",
-- 
1.8.3.1

