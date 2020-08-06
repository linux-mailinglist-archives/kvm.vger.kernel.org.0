Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5D0A23DBC2
	for <lists+kvm@lfdr.de>; Thu,  6 Aug 2020 18:32:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728507AbgHFQcI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Aug 2020 12:32:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728255AbgHFQbD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Aug 2020 12:31:03 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74B5BC0086D6
        for <kvm@vger.kernel.org>; Thu,  6 Aug 2020 08:14:40 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id r1so18434173ybg.4
        for <kvm@vger.kernel.org>; Thu, 06 Aug 2020 08:14:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=1uE7JbpwTljkttUhNuq7JiM1Q6xrfAQ85WQdQB2dT2I=;
        b=Ys8mzKeE9+ROSXLY4wRCds6Bim+pgIKL9YRgNM+f3zTVU2TsK58gtK2pra5lO1lNn7
         Bapmp+xWgMOSc7r6FWgcubLi8HYKZVbZ6+goK2T8gsx4DTd3Bqa7wkj7PzbD0ZGjie+w
         Rk5LyxxI3tkpVWGLSmJTOkt/4lOB9a/9Ce7fBf92tQESfYgTTkCVZUuZO/5kmMIFCDkJ
         Et1PLQzNqxSltmQpsFUFtL3EL6GepaOeUZj1pmhc+T9VgjNEr3r5po936h8HUdzKfI1C
         v+0z+yh/o7PhET5eQTkIfCTDH45A4TjKoXY6T6Henr/Dvo5BHc0O/HOhkG21+UqCPOuE
         G0Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=1uE7JbpwTljkttUhNuq7JiM1Q6xrfAQ85WQdQB2dT2I=;
        b=rLZl5kH8cCey/B/GBl1EJvU5sbMb/C47igvLVaKdK1lhLwt8vHeyMDLyF2/ST30YAB
         AAeXBGtRYIhn1b4AFusgASUagqeXPwvtvOEZ+z9fJYd3Xy7vEroSROdmWuB6DNCxU2rP
         NJ9YEeB2cR7k60Ppi/hD24ZDIg0k10xeiT2RPyw0QLb4FeZoY/ezcpkkd+dqm6x0VU3+
         FNkaDSTvkzbI2EwcKlzlZOxwMDq/wX35flhdJXxSg2xc8NnKnXVIKGlKLXVZzwnzhJTP
         iL3HnXHKEHYEmKBGYYpnetJXiJgcdh2zHbU6TlgXo/FCLOKHcKxzfwuJYWyKVhPA0VWG
         WTjQ==
X-Gm-Message-State: AOAM531aZJeRypWT43S5IVIePF+8DKALLN9oCObr542eT877sI++9aky
        OfmXdKNYyaCWWped8El9SnHaLRRKUTCOMXN9OkC1pR5t62RCZviiBLFRE/3damuvxJESk/VegGI
        d6FwhhBn9kiekFj5yPEgIA51nVFU3IUxeC9gzfcHubHGg3GDl/Zozl+qH0g==
X-Google-Smtp-Source: ABdhPJzpleHzyjbKIOW1eW0Eh3kZFE1aZ5CiDGRN4g1dvjiLiMmRr6ib3l6c77Z1rBsUX9nVFylfPyBwJrk=
X-Received: by 2002:a25:d702:: with SMTP id o2mr13195812ybg.379.1596726879655;
 Thu, 06 Aug 2020 08:14:39 -0700 (PDT)
Date:   Thu,  6 Aug 2020 15:14:31 +0000
In-Reply-To: <20200806151433.2747952-1-oupton@google.com>
Message-Id: <20200806151433.2747952-3-oupton@google.com>
Mime-Version: 1.0
References: <20200806151433.2747952-1-oupton@google.com>
X-Mailer: git-send-email 2.28.0.236.gb10cc79966-goog
Subject: [PATCH v3 2/4] kvm: x86: set wall_clock in kvm_write_wall_clock()
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
index 5ba713108686..683ce68d96b2 100644
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

