Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A80AA13D0F9
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2020 01:18:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730090AbgAPAQz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jan 2020 19:16:55 -0500
Received: from mail-pl1-f201.google.com ([209.85.214.201]:46722 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726310AbgAPAQz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jan 2020 19:16:55 -0500
Received: by mail-pl1-f201.google.com with SMTP id t17so7771731plr.13
        for <kvm@vger.kernel.org>; Wed, 15 Jan 2020 16:16:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=t5hhiMVaGy2q0E/z2T4ycE665LCZYtF+TTm8Tr1smIg=;
        b=tOuQX0exFrlUtIawNreCUMl5ovbrJjoQ387lqvKrIjWgH/iE3VZ0K1ng2Ksq2hNC0I
         ltp2RJULwVsQphki50fmjuWZYJ2gkb8tSuzWo+JwVXO3QVj5m+9oRgVbOtj6mZNgrIO0
         jK1jP88lWKP9T+kBzi3Bg2f11tvTTrFor6fNSwnvGc9hIxdP/0J0hEElDvUtVZT94gf+
         QCC0CykWQ7KjG5VzJDAD/YAD4KjRalEs1jkLh4w3EMgt92QtYM3urk7tp+Qbu2Yau8Gl
         uPshjpFpIc5Fsv4kmFFLnVHWr/qmKu5M6EYnNK9hNGu3lXQ0LZuGWfJ7oEfIp6wCrr/2
         eOcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=t5hhiMVaGy2q0E/z2T4ycE665LCZYtF+TTm8Tr1smIg=;
        b=snh5QPevCxDM8Wql63REZJ7yZzQhp+6ig1TD9bfvXw/6NE8zRNTKW3DACjtuomoYsa
         F5qHKxH57rwxX04LEkPg3Mk2+M+fzVQY49PToxig/aBCcsKvTsVq/81CiGGMC9vKt5IU
         P3NzeOs4FVmFleyo4PpG6ezz4uucuFESbn3YDuqzzyii2kf5ESIggx+oHAuW/ToonFPO
         e9GGE07xPkXktbwLF7bz2nIwUi9+AV5wIclXqaBPfkIdBUfWAw/KK33mFZrL7X4ftPKm
         FilB6rOP60HK776spS5i9ZdFN8YmoUsf9H6bG1/mw7uFV7pGsowCS3C+qeRkuHajl2kZ
         +r0g==
X-Gm-Message-State: APjAAAUDRv5RL4WbjUYH4kTYGd85fmE6Xxk8y/4LHsHr2ehStcFzGU8C
        t4USiXDVN3grLPUh4Ea2zYILvq1KXZ5he3E0EjBbXt/CLE1+Q4fKnjZaz3G+B+m6cGdluTB81dt
        P8ox2UbMzwr+neoe81AZq0YyepWH1e+Z+ptaW699LzrU9XvKNkbSCsb8kdG0iqsQ=
X-Google-Smtp-Source: APXvYqzYOrXmkuotXUi1BcXQtiDrkmbf0DY4rTwfJCnnNJ/jNSYeIZwrPXL3Jgyqs+kgCMk87xe9KNpGynZknQ==
X-Received: by 2002:a65:5608:: with SMTP id l8mr36747108pgs.210.1579133814000;
 Wed, 15 Jan 2020 16:16:54 -0800 (PST)
Date:   Wed, 15 Jan 2020 16:16:35 -0800
Message-Id: <20200116001635.174948-1-jmattson@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.0.rc1.283.g88dfdc4193-goog
Subject: [PATCH] kvm: x86: Don't dirty guest memory on every vcpu_put()
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Kevin Mcgaire <kevinmcgaire@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Beginning with commit 0b9f6c4615c99 ("x86/kvm: Support the vCPU
preemption check"), the KVM_VCPU_PREEMPTED flag is set in the guest
copy of the kvm_steal_time struct on every call to vcpu_put(). As a
result, guest memory is dirtied on every call to vcpu_put(), even when
the VM is quiescent.

To avoid dirtying guest memory unnecessarily, don't bother setting the
flag in the guest copy of the struct if it is already set in the
kernel copy of the struct.

If a different vCPU thread clears the guest copy of the flag, it will
no longer get reset on the next call to vcpu_put, but it's not clear
that resetting the flag in this case was intentional to begin with.

Signed-off-by: Jim Mattson <jmattson@google.com>
Tested-by: Kevin Mcgaire <kevinmcgaire@google.com>
Reviewed-by: Ben Gardon <bgardon@google.com>
Reviewed-by: Oliver Upton <oupton@google.com>

---
 arch/x86/kvm/x86.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cf917139de6b..3dc17b173f88 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3504,6 +3504,9 @@ static void kvm_steal_time_set_preempted(struct kvm_vcpu *vcpu)
 	if (!(vcpu->arch.st.msr_val & KVM_MSR_ENABLED))
 		return;
 
+	if (vcpu->arch.st.steal.preempted & KVM_VCPU_PREEMPTED)
+		return;
+
 	vcpu->arch.st.steal.preempted = KVM_VCPU_PREEMPTED;
 
 	kvm_write_guest_offset_cached(vcpu->kvm, &vcpu->arch.st.stime,
-- 
2.25.0.rc1.283.g88dfdc4193-goog

