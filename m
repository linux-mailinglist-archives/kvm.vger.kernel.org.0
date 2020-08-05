Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B278123D38D
	for <lists+kvm@lfdr.de>; Wed,  5 Aug 2020 23:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726262AbgHEVVt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 17:21:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726316AbgHEVVm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Aug 2020 17:21:42 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB87EC061756
        for <kvm@vger.kernel.org>; Wed,  5 Aug 2020 14:21:41 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id 4so5889556pjf.5
        for <kvm@vger.kernel.org>; Wed, 05 Aug 2020 14:21:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=FeBeam1y+XQlyZj+eo/3cIxBAhbswkJZwONr8od37Pw=;
        b=ds3+5Saw6p5mv3+tZlbQ2KRk7WCll8wRO6o9Dl3ABxlIWJmQaxe48jmTcruMDA2Fdn
         cd/jM8f4lvXl5z1/iyoFRSGJOvQWvlkbz98Kfj21FdPKTNq6fIKYXXHa86YIu9bYF8yv
         uTgt3QinLX/SBFtQGfQRrp9yfHRpi5GKuCxu/Ef7hfJswEHVhU42bSF1/YiEbS4/J93f
         Aruo7Lxa8cwwrNUIiorcqJ87lsAuw0XAsdr7xGOnMQksgcLDG4NYu7WvcWh/QtV0CBB5
         fEKjMnlszTESMj5rJ932FBL+8M0YShb48ol3cfqb72zHOQ6pRIeYalKwJ7ASXon9BIDT
         IAZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=FeBeam1y+XQlyZj+eo/3cIxBAhbswkJZwONr8od37Pw=;
        b=N8NmsIMb4XTvPRQE6+tezgRDixF7bmvJ6P9fWu2EMBy2h6qpBA9BqB9wyOJhxoYhDG
         4zl3hD95x4BnRgmDCMPjLTLGPsLAl35pqM1goilzE1Qp+BknxQrKCL4Q05gf8MsexpuU
         F+XrO0E+lDP/BlyB5FnKgQSLZR3+BOJVbQ/xTYWs/Z65q6FKvdQXwhg5C1/Jb2wKwSg9
         OrYgM8PdQl7qnGJARxTGf/Mv6GVrgRlR+kQZNZopib/B7ZftKzJx0S52ig2HgtHyZiON
         m0u4wsi1AJaVS1erx0iLZdMzVelvTAhKYD8+VDpSGpaEZ2XCArt1SYkWCi5MUsgOTBK6
         F0dg==
X-Gm-Message-State: AOAM531egBv2Aou981yB5JEhUB8pKqcNP/olnIyR4+0yDOYpJ/N96ONh
        6ln3ME3D6/MHX3mm62AefKw6GCmopsc4PgIZZ959kgFCvkV3KUK3LUAsWiSPleR8tpyP2TYpIEU
        +43L1VkPDGM4Gc8HqdxHe4YNSsDa+WzTd1JjVQMiIMYfwIoSpRWO+77mpmA==
X-Google-Smtp-Source: ABdhPJyhJmdcMXsslnt+7FMcFeCVxLh/cKR0In5lp3N+Ou6yal4Zr7WXXJikyuG+92NmebuJqSWIPCFjwPg=
X-Received: by 2002:a17:90b:f11:: with SMTP id br17mr5280393pjb.68.1596662501272;
 Wed, 05 Aug 2020 14:21:41 -0700 (PDT)
Date:   Wed,  5 Aug 2020 21:21:29 +0000
In-Reply-To: <20200805212131.2059634-1-oupton@google.com>
Message-Id: <20200805212131.2059634-3-oupton@google.com>
Mime-Version: 1.0
References: <20200805212131.2059634-1-oupton@google.com>
X-Mailer: git-send-email 2.28.0.236.gb10cc79966-goog
Subject: [PATCH v2 2/4] kvm: x86: set wall_clock in kvm_write_wall_clock()
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Oliver Upton <oupton@google.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Small change to avoid meaningless duplication in the subsequent patch.
No functional change intended.

Reviewed-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/x86/kvm/x86.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d18582aefa9f..53d3a5ffde9c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1790,6 +1790,8 @@ static void kvm_write_wall_clock(struct kvm *kvm, gpa_t wall_clock)
 	struct pvclock_wall_clock wc;
 	u64 wall_nsec;
 
+	kvm->arch.wall_clock = wall_clock;
+
 	if (!wall_clock)
 		return;
 
@@ -2997,7 +2999,6 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 	case MSR_KVM_WALL_CLOCK_NEW:
 	case MSR_KVM_WALL_CLOCK:
-		vcpu->kvm->arch.wall_clock = data;
 		kvm_write_wall_clock(vcpu->kvm, data);
 		break;
 	case MSR_KVM_SYSTEM_TIME_NEW:
-- 
2.28.0.236.gb10cc79966-goog

