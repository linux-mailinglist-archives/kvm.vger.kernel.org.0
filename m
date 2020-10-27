Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 396ED29CD5C
	for <lists+kvm@lfdr.de>; Wed, 28 Oct 2020 02:49:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725857AbgJ1BiT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Oct 2020 21:38:19 -0400
Received: from mail-qv1-f73.google.com ([209.85.219.73]:53328 "EHLO
        mail-qv1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1832973AbgJ0XLN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Oct 2020 19:11:13 -0400
Received: by mail-qv1-f73.google.com with SMTP id z9so1857123qvo.20
        for <kvm@vger.kernel.org>; Tue, 27 Oct 2020 16:11:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=3+6ectJfOiKDR2LfaiKnLMFM89IuvdIsyMu19K7v2oM=;
        b=uM4jsXZsNl+FtusXOt8LC/fnbcXL8edJ7kArSXR5lEmdtnPf9gY+IH++dxVnxSmILE
         ElsfqB2vqVcjXpPirqWczohWQKNuwejJwCaavkUYmO7GaSJXZlNsx9frtSfyNyBQafl6
         6rQgoO2mC2wdAqMqVlrcMj3U14lA3SfoaFrCR4jWQsB55RSVrLWNGKIZ3y8a427aj1zO
         BrYiRdIJrvg+H59CbidQ+tk23nXzCuWxv/3wruwPWDVDgOE90kKh6/6iFCjw+r8uEKR1
         WlkxPgzTnLhF3qqb0rdWGovjkvB2HdgiAoXhTn237HM4mOeq5Wdx/Qb4EIgpoSr9mQlf
         +r9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=3+6ectJfOiKDR2LfaiKnLMFM89IuvdIsyMu19K7v2oM=;
        b=cWtlXIsAPALetKd2Fm55DTJkzCg8MNTxiHVasAqF80klHLXN9zEZ9DtvBtOBEOMiRI
         ew4gR1/uVQMdZNk8xvNkk1EJKOiA0A/Z2l1scp9OEcPIDvZwM5Jv+vpt4e16icF9y4N+
         Cl9KAyvuWyUGO+A9+/HhObFtfZRYuhEmXmqQMBjxNdWCXPBCfoxNYZFoiIi89fvKBUq1
         4pcyshkcfsvPCr31iSaTlTrPcLUOCy8tuGjwQAjNToBCXvWn3fcBywrz87/LjAV3LsVz
         dZYBtisG3arjNUFJD5OqyyhfupO6UuGsGhkHpa2lNFiQdtHKosKwLNHRA/R9NjKHXULN
         LCkg==
X-Gm-Message-State: AOAM530fEm1vRUYVVbxmUIChDHpy6m4Qi73U3qodeEp1idWMNot2XPGD
        Tbaf5xctvdSFL4yFtMBN7AzCPKa/ziKwtPMHapSZL/XMLTlruExEoo8UBRGEDTmkCWbRuziQjXu
        3FoxYIelBwCpfX5qeF7HQGaYz1Gy78CbnQVc0RUIxi6stE6NQGLUV6+IOWQ==
X-Google-Smtp-Source: ABdhPJyc0GXdLwsQDByePLIyx5jcBiX0bXCKgdhO9KQJ4wsr92CjbX4xA3m7fBjLZ59mntrHqjsB4ty1Euo=
Sender: "oupton via sendgmr" <oupton@oupton.sea.corp.google.com>
X-Received: from oupton.sea.corp.google.com ([2620:15c:100:202:f693:9fff:fef5:7be1])
 (user=oupton job=sendgmr) by 2002:a0c:9e20:: with SMTP id p32mr4855505qve.44.1603840271080;
 Tue, 27 Oct 2020 16:11:11 -0700 (PDT)
Date:   Tue, 27 Oct 2020 16:10:43 -0700
In-Reply-To: <20201027231044.655110-1-oupton@google.com>
Message-Id: <20201027231044.655110-6-oupton@google.com>
Mime-Version: 1.0
References: <20201027231044.655110-1-oupton@google.com>
X-Mailer: git-send-email 2.29.0.rc2.309.g374f81d7ae-goog
Subject: [PATCH 5/6] kvm: x86: request masterclock update any time guest uses
 different msr
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

commit 66570e966dd9 ("kvm: x86: only provide PV features if enabled in
guest's CPUID") subtly changed the behavior of guest writes to
MSR_KVM_SYSTEM_TIME(_NEW). Restore the previous behavior; update the
masterclock any time the guest uses a different msr than before.

Fixes: 66570e966dd9 ("kvm: x86: only provide PV features if enabled in guest's CPUID")
Signed-off-by: Oliver Upton <oupton@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2970045a885e..4f7dce1b1447 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1965,7 +1965,7 @@ static void kvm_write_system_time(struct kvm_vcpu *vcpu, gpa_t system_time,
 	struct kvm_arch *ka = &vcpu->kvm->arch;
 
 	if (vcpu->vcpu_id == 0 && !host_initiated) {
-		if (ka->boot_vcpu_runs_old_kvmclock && old_msr)
+		if (ka->boot_vcpu_runs_old_kvmclock != old_msr)
 			kvm_make_request(KVM_REQ_MASTERCLOCK_UPDATE, vcpu);
 
 		ka->boot_vcpu_runs_old_kvmclock = old_msr;
-- 
2.29.0.rc2.309.g374f81d7ae-goog

